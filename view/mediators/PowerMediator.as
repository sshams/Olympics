/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PowerMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "PowerMediator";
		
		public function PowerMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
	}
}