/*-------------------------------------------------------
  Prototipo Projeto Iniciação cientifica 2015-2 á 2016-2
  Representação maquina de estados que sera controlada
  pela cadeirinha inteligente, essa maquina de estados
  controla ao dispositivo ligado a chave do motorista.
  Temos como entrada a comunicação, presença da criança
  e o botao de consciencia, e como saidas temos um led,
  um vibrador e um buzzer. 
--------------------------------------------------------
*/
#include<SoftwareSerial.h>

int bluetoothTx = 3;
int bluetoothRx = 4;

SoftwareSerial bluetooth(bluetoothTx,bluetoothRx);

//Sinais
int led_1=10,
    led_2=11,
    led_3=9,
    pin_butt = 2;
  
//sinais para teste 
  int butt2=3,
      butt3=4;
    
//entradas
int comm,
    cri,
    butt;

//configuração inicial
void setup()
{
  Serial.begin(9600);
  /*
  bluetooth.begin(115200);
  delay(100);
  bluetooth.println("U,9600,N");
  bluetooth.begin(9600);
 */
  pinMode(led_1,OUTPUT);
  pinMode(led_2,OUTPUT);
  pinMode(led_3,OUTPUT);
  pinMode(pin_butt,INPUT);
  
  //pinagem para testes
  //comunicação
//  pinMode(butt2,INPUT);
  //criança
  pinMode(butt3,INPUT);
}

//Loop de execução do codigo
void loop()
{
  /*
  // Define as entradas comunicação e criança
  if(bluetooth.available()){
    comm=1;
    cri = mapeamento((char)bluetooth.read());
  }else{
    comm=0;
  }
  */
  
  //entradas teste para comm e cri
  //comm=digitalRead(butt2);
  
  char c='0';
  if(Serial.available()){
    c=Serial.read();
  }
  if(c=='1'){
    comm=1;
  }else if(c=='0'){
    comm=0;  
  }
  
  cri = digitalRead(butt3);
  
  //Entrada do botao de consciencia
  if(digitalRead(pin_butt)==HIGH){
    butt = 1;
  }else{
     butt=0; 
  }
  
  Serial.print("communication ");
  Serial.print(comm);
  Serial.print(" crianca ");
  Serial.print(cri);
  Serial.print(" botao ");
  Serial.println(butt);
  
  int* vet = maquina_estados(comm, cri, butt);
  
  //controle sinal visual
  if(vet[0]==1){
    tone(led_1,5);  //tone(pino, frequencia); 
  }else{
    digitalWrite(led_1,LOW);
  }
  
  //controle do sinal vibratorio 
  digitalWrite(led_2,vet[1]);
  
   //controle do sinal sonoro
  if(vet[2]==1){
   digitalWrite(led_3,HIGH);
   
   digitalWrite(led_3,LOW);
  }else{
    noTone(led_3);
  }

  free(vet);  
}

//Maquina de Estados do projeto
int* maquina_estados(int communication, int crianca, int button)
{
//estados
const int WAIT=0,
          STAND_BY=1,
          LED=2,
          LED_VIBRA1=3,
          LED_VIBRA2=4,
          LED_VIBRA_APITA=5;
          
//estado atual
static int state=-1;

  int * saida=(int *)calloc(3,sizeof(int));
  
  switch(state)
  {
    case WAIT :
          Serial.print("WAIT \n");
          if(communication==0 && crianca==0)
          {
	      state=STAND_BY;
	      saida[0]=0;
              saida[1]=0;
              saida[2]=0;
          }
          if(communication==0 && crianca==1)
	  {
            state = LED;
            //Tempo 5
            //delay(100);
          Serial.print("LOOP-WAIT \n");
            for(int i=0;i<10000;i++){
                if(communication==1 && crianca==0){
                    state=WAIT;
	          saida[0]=0;
                  saida[1]=0;
                  saida[2]=0;
                }
                if(state==WAIT){
                   break; 
                }
              delay(1);
              
            }
	    saida[0] = 1;
            saida[1] = 0;
            saida[2] = 0;
          }
          if(communication==1){
                  state = WAIT;
                  saida[0] = 0;
                  saida[1] = 0;
                  saida[2] = 0;
                }
	break;
     case STAND_BY :
       
          Serial.print("STAND-BY\n");
            if(communication==1)
            {  
		state = WAIT;
		saida[0] = 0;
                saida[1] = 0;
                saida[2] = 0;
	    }else{
		state = STAND_BY;
		saida[0] = 0;
                saida[1] = 0;
                saida[2] = 0;
            }
         break;
      case LED : 
      
          Serial.print("LED\n");
            if(crianca==0 && communication==1)
            {
		state = WAIT;
		saida[0] = 0;
                saida[1] = 0;
                saida[2] = 0;
            }
            if(button==1)
            {
                 state = LED_VIBRA2;
                 //tempo 4
                 //delay(300);
                 // for utilizado como uma forma de gerar um atraso com teste de eventos
          Serial.print("LOOP-LED 1\n");
                 for(int i=0; i<10000;i++){
                        if(communication==1 && crianca==0){
                          state=WAIT;
	                  saida[0]=0;
                          saida[1]=0;
                          saida[2]=0;
                        }
                        if(state==WAIT){
                         break; 
                        }
                        
                   delay(1);
                 }
	         saida[0] = 1;
                 saida[1] = 1;
                 saida[2] = 0;
            }
            if(communication==0)
            {
                  //TEMPO 1
                  //delay(10000);
                    // for utilizado como uma forma de gerar um atraso com teste de eventos
          Serial.print("LOOP-LED 2\n");
                 for(int i=0; i<10000;i++){
                        if(communication==1 && crianca==0){
                          state=WAIT;
	                  saida[0]=0;
                          saida[1]=0;
                          saida[2]=0;
                        }
                        if(state==WAIT){
                         break; 
                        }
                        
                   delay(1);
                 }
                  state = LED_VIBRA1;
                  saida[0] = 1;
                  saida[1] = 1;
                  saida[2] = 0;
	    }
         break;
       case LED_VIBRA1 :
       
          Serial.print("LED_VIBRA\n");
             if(crianca==0 && communication==1)
             {
               state=WAIT;
	       saida[0]=0;
               saida[1]=0;
               saida[2]=0;
             }
             if(button==1)
                    {
                     state=LED_VIBRA2;
		     saida[0]=1;
                     saida[1]=1;
                     saida[2]=0;
                    }
             if(communication==0)
                      {
                        //TEMPO 2
                        //delay(300);
                          // for utilizado como uma forma de gerar um atraso com teste de eventos
          Serial.print("LOOP-LED+VIBRA\n");
                 for(int i=0; i<10000;i++){
                        if(communication==1 && crianca==0){
                          state=WAIT;
	                  saida[0]=0;
                          saida[1]=0;
                          saida[2]=0;
                        }
                        if(state==WAIT){
                         break; 
                        }       
                   delay(1);
                 }
                        state=LED_VIBRA_APITA;
                        saida[0]=1;
                        saida[1]=1;
                        saida[2]=1;
                      }
           break;
	case LED_VIBRA_APITA :
          Serial.print("LED_VIBRA_APITA\n");
              if(crianca==0 && communication==1)
              {
                state=WAIT;
		saida[0]=0;
                saida[1]=0;
                saida[2]=0;

              }     
              if(communication==0)
                        {
                          state=LED_VIBRA_APITA;
			  saida[0]=1;
                          saida[1]=1;
                          saida[2]=1;
			}
              if(button==1)
                      {
                        state=LED_VIBRA2;
			saida[0]=1;
                        saida[1]=1;
                        saida[2]=0;
		      }
          break;
	case LED_VIBRA2	:
  
          Serial.print("LED_VIBRA 2\n");
              if(crianca==0 && communication==1)
              {
                state=WAIT;
		saida[0]=0;
                saida[1]=0;
                saida[2]=0;
	      }
              if(communication==0)
                {
                  //TEMPO 3
                  //delay(1000);
                    // for utilizado como uma forma de gerar um atraso com teste de eventos
          Serial.print("LOOP+LED_VIBRA2\n");
                 for(int i=0; i<10000;i++){
                        if(communication==1 && crianca==0){
                          state=WAIT;
	                  saida[0]=0;
                          saida[1]=0;
                          saida[2]=0;
                        }
                        if(state==WAIT){
                         break; 
                        }
                        
                   delay(1);
                 }
                  state=LED_VIBRA_APITA;
		  saida[0]=1;
                  saida[1]=1;
                  saida[2]=1;
                }
           break;
         default : 
             state=WAIT;
	     saida[0]=0;
             saida[1]=0;
             saida[2]=0;
          break;
  }
  return saida;
}

//Realiza o mapeamento entre String para inteiro 
int mapeamento(char valor){
  switch(valor){
   case 'p':
      return 1;
     break;
    case 'a':
     return 0; 
  }
}
