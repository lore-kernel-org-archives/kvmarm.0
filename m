From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Date: Tue, 07 Apr 2015 18:20:15 +0200
Message-ID: <552403BF.8090008@redhat.com>
References: <20150318144111.1e56c6d9@canb.auug.org.au> <20150318075537.GC23225@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150318075537.GC23225@cbox>
Sender: linux-next-owner@vger.kernel.org
To: Christoffer Dall <cdall@cs.columbia.edu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 18/03/2015 08:55, Christoffer Dall wrote:
> Hi Stephen,
> 
> On Wed, Mar 18, 2015 at 02:41:11PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the kvm-arm tree got a conflict in
>> virt/kvm/arm/vgic.c between commit ae705930fca6 ("arm/arm64: KVM: Keep
>> elrsr/aisr in sync with software model") from Linus' tree and commit
>> 71760950bf3d ("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn")
>> from the kvm-arm tree.
>>
>> I fixed it up (I think - see below) and can carry the fix as necessary
>> (no action is required).
>>
>> -- 
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc virt/kvm/arm/vgic.c
>> index c9f60f524588,ffd937ca5141..000000000000
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@@ -982,9 -1092,7 +1098,8 @@@ bool vgic_queue_irq(struct kvm_vcpu *vc
>>   		if (vlr.source == sgi_source_id) {
>>   			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
>>   			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
>> - 			vlr.state |= LR_STATE_PENDING;
>> - 			vgic_set_lr(vcpu, lr, vlr);
>> + 			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>>  +			vgic_sync_lr_elrsr(vcpu, lr, vlr);
>>   			return true;
>>   		}
>>   	}
>> @@@ -1001,12 -1109,8 +1116,9 @@@
>>   
>>   	vlr.irq = irq;
>>   	vlr.source = sgi_source_id;
>> - 	vlr.state = LR_STATE_PENDING;
>> - 	if (!vgic_irq_is_edge(vcpu, irq))
>> - 		vlr.state |= LR_EOI_INT;
>> - 
>> - 	vgic_set_lr(vcpu, lr, vlr);
>> + 	vlr.state = 0;
>> + 	vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>>  +	vgic_sync_lr_elrsr(vcpu, lr, vlr);
>>   
>>   	return true;
>>   }
> 
> Looks great, thanks!
> -Christoffer

Got the same conflict when pulling from the kvm-arm tree, I used
a different resolution though:

diff --cc virt/kvm/arm/vgic.c
index c9f60f524588,b70174e74868..8d550ff14700
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@@ -955,6 -1095,25 +1101,26 @@@ static void vgic_retire_disabled_irqs(s
  	}
  }
  
+ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
+ 				 int lr_nr, struct vgic_lr vlr)
+ {
+ 	if (vgic_irq_is_active(vcpu, irq)) {
+ 		vlr.state |= LR_STATE_ACTIVE;
+ 		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
+ 		vgic_irq_clear_active(vcpu, irq);
+ 		vgic_update_state(vcpu->kvm);
+ 	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
+ 		vlr.state |= LR_STATE_PENDING;
+ 		kvm_debug("Set pending: 0x%x\n", vlr.state);
+ 	}
+ 
+ 	if (!vgic_irq_is_edge(vcpu, irq))
+ 		vlr.state |= LR_EOI_INT;
+ 
+ 	vgic_set_lr(vcpu, lr_nr, vlr);
++	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
+ }
+ 
  /*
   * Queue an interrupt to a CPU virtual interface. Return true on success,
   * or false if it wasn't possible to queue it.
@@@ -982,9 -1141,7 +1148,7 @@@ bool vgic_queue_irq(struct kvm_vcpu *vc
                if (vlr.source == sgi_source_id) {
                        kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
                        BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
-                       vlr.state |= LR_STATE_PENDING;
-                       vgic_set_lr(vcpu, lr, vlr);
-                       vgic_sync_lr_elrsr(vcpu, lr, vlr);
+                       vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
                        return true;
                }
        }
@@@ -1001,12 -1158,8 +1165,8 @@@
  
        vlr.irq = irq;
        vlr.source = sgi_source_id;
-       vlr.state = LR_STATE_PENDING;
-       if (!vgic_irq_is_edge(vcpu, irq))
-               vlr.state |= LR_EOI_INT;
- 
-       vgic_set_lr(vcpu, lr, vlr);
-       vgic_sync_lr_elrsr(vcpu, lr, vlr);
+       vlr.state = 0;
+       vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
  
        return true;
  }


Christoffer, this is the same logic as Stephen's resolution, but
can you confirm that it makes sense "semantically" as well?

(Stephen, you'll still get the conflicts in linux-next for a
couple of days as I finish local testing of KVM changes for 4.1).

Paolo
