//
//  ViewController.m
//  sqlite3
//
//  Created by Joshua on 26/08/14.
//  Copyright (c) 2014 Joshua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    NSString * dbPath;
    sqlite3 * contactosBD;
    BOOL seAbrioBD;
    BOOL existeTabla;
    
    char * errMsg;
    NSString * sql_stmt;
}


@end

@implementation ViewController
@synthesize campo_id,campo_nombre,campo_domicilio,campo_telefono,txt_datos;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self iniciaVars];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)iniciaVars{
    // Directorio de Documentos
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // path del archivo de la base de datos
    dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contactos.sqlite3"]];
    NSLog(@"path %@",dbPath);
    
    
    if([self abrirBD]){
        existeTabla = [self CrearTabla];
        [self cerrarBD];
    }
}



-(BOOL)abrirBD{
    
    BOOL resultado = NO;
    
    if (sqlite3_open([dbPath UTF8String], &contactosBD) == SQLITE_OK) {
        resultado = YES;
    }
    
    return resultado;
}

-(void)cerrarBD{
    sqlite3_close(contactosBD);
}


-(BOOL)CrearTabla{
    
    BOOL resultado = NO;
    
    //creacion de la tabla CONTACTOS si no existe.
    
    sql_stmt = @"CREATE TABLE IF NOT EXISTS CONTACTOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
    
    if (sqlite3_exec(contactosBD, [sql_stmt UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        resultado = YES;
    }else{
        NSLog(@"Falla query de creacion de tabla. %s",errMsg);
    }
    
    return resultado;
}



-(void)Alerta:(NSString *)titulo Mensaje:(NSString *)mensaje TextoBtnCancel:(NSString *)txtbtnCancel{
    [[[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:txtbtnCancel otherButtonTitles:nil] show];
}







- (IBAction)btn_query:(id)sender {
    NSString * sql_plantilla = @"";
    NSString * titulobtn = [sender currentTitle];
    
    if ([titulobtn isEqualToString:@"Agregar"]) {
        sql_plantilla = @"insert into CONTACTOS (NAME, ADDRESS, PHONE) values ('%@','%@','%@')";
        sql_stmt = [NSString stringWithFormat:sql_plantilla,campo_nombre.text,campo_domicilio.text,campo_telefono.text ];
    }
    
    if ([titulobtn isEqualToString:@"Actualizar"]) {
        sql_plantilla = @"update CONTACTOS set NAME='%@', ADDRESS='%@', PHONE='%@' where ID=%@";
        sql_stmt = [NSString stringWithFormat:sql_plantilla,campo_nombre.text,campo_domicilio.text,campo_telefono.text,campo_id.text ];
    }
    if ([titulobtn isEqualToString:@"Eliminar"]) {
        sql_plantilla = @"delete from CONTACTOS where ID=%@";
        sql_stmt = [NSString stringWithFormat:sql_plantilla,campo_id.text];
    }
    
    if ([titulobtn isEqualToString:@"Mostrar Registros"]) {
        if([self abrirBD] && existeTabla){
            
            sql_stmt = @"select * from CONTACTOS";
            
            sqlite3_stmt *recordset;
            
            if (sqlite3_prepare_v2(contactosBD, [sql_stmt UTF8String], -1, &recordset, nil) == SQLITE_OK) {
                txt_datos.text = @"";
                while (sqlite3_step(recordset) == SQLITE_ROW) {
                    
                    int rID = (int) sqlite3_column_int(recordset, 0);
                    char *name = (char *) sqlite3_column_text(recordset, 1);
                    char *address = (char *) sqlite3_column_text(recordset, 2);
                    char *phone = (char *) sqlite3_column_text(recordset, 3);
                    
                    NSString *cad = [NSString stringWithFormat:@"ID:%i NOMBRE:%s DOMICILIO:%s TELEFONO:%s\n",rID,name,address,phone];
                    txt_datos.text = [NSString stringWithFormat:@"%@\n%@",txt_datos.text,cad];
                }
                sqlite3_finalize(recordset);
            }
            [self cerrarBD];
            
        }
        
        
    }else{
        
        NSLog(@"query %@",sql_stmt);
        if([self abrirBD] && existeTabla){
            if (sqlite3_exec(contactosBD, [sql_stmt UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
                [self Alerta:titulobtn  Mensaje:@"Query realizado satisfactoriamente" TextoBtnCancel:@"Ok"];
            }else{
                [self Alerta:titulobtn  Mensaje:[NSString stringWithFormat:@"Falla Query: %s",errMsg] TextoBtnCancel:@"Ok"];
            }
            [self cerrarBD];
        }
    }
    
    
    
    
    
}
@end
