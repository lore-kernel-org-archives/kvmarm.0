From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 38/40] KVM: arm/arm64: Handle VGICv3 save/restore from
 the main VGIC code on VHE
Date: Thu, 22 Feb 2018 20:28:37 +0100
Message-ID: <20180222192837.GY29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-39-christoffer.dall@linaro.org>
 <3de7e88c-e7a2-f9b5-41f7-3b6886459806@arm.com>
 <20180222144227.GO29376@cbox> <86o9khjcg2.wl-marc.zyngier@arm.com>
 <20180222160200.GT29376@cbox>
 <8075943d-9519-bba3-9a8c-5f622f3e81d3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <8075943d-9519-bba3-9a8c-5f622f3e81d3@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 22, 2018 at 05:21:20PM +0000, Marc Zyngier wrote:
> On 22/02/18 16:02, Christoffer Dall wrote:
> > On Thu, Feb 22, 2018 at 03:01:17PM +0000, Marc Zyngier wrote:
> >> On Thu, 22 Feb 2018 14:42:27 +0000,
> >> Christoffer Dall wrote:
> >>>
> >>> On Thu, Feb 22, 2018 at 12:32:11PM +0000, Marc Zyngier wrote:
> >>>> On 15/02/18 21:03, Christoffer Dall wrote:
> >>>>> Just like we can program the GICv2 hypervisor control interface directly
> >>>>> from the core vgic code, we can do the same for the GICv3 hypervisor
> >>>>> control interface on VHE systems.
> >>>>>
> >>>>> We do this by simply calling the save/restore functions when we have VHE
> >>>>> and we can then get rid of the save/restore function calls from the VHE
> >>>>> world switch function.
> >>>>>
> >>>>> One caveat is that we now write GICv3 system register state before the
> >>>>> potential early exit path in the run loop, and because we sync back
> >>>>> state in the early exit path, we have to ensure that we read a
> >>>>> consistent GIC state from the sync path, even though we have never
> >>>>> actually run the guest with the newly written GIC state.  We solve this
> >>>>> by inserting an ISB in the early exit path.
> >>>>>
> >>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>> ---
> >>>>>
> >>>>> Notes:
> >>>>>     Changes since v2:
> >>>>>      - Added ISB in the early exit path in the run loop as explained
> >>>>>        in the commit message.
> >>>>>
> >>>>>  arch/arm64/kvm/hyp/switch.c | 3 ---
> >>>>>  virt/kvm/arm/arm.c          | 1 +
> >>>>>  virt/kvm/arm/vgic/vgic.c    | 5 +++++
> >>>>>  3 files changed, 6 insertions(+), 3 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >>>>> index cbafc27a617b..466cfcdbcaf3 100644
> >>>>> --- a/arch/arm64/kvm/hyp/switch.c
> >>>>> +++ b/arch/arm64/kvm/hyp/switch.c
> >>>>> @@ -399,8 +399,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >>>>>  	__activate_traps(vcpu);
> >>>>>  	__activate_vm(vcpu->kvm);
> >>>>>  
> >>>>> -	__vgic_restore_state(vcpu);
> >>>>> -
> >>>>>  	sysreg_restore_guest_state_vhe(guest_ctxt);
> >>>>>  	__debug_switch_to_guest(vcpu);
> >>>>>  
> >>>>> @@ -414,7 +412,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >>>>>  	fp_enabled = fpsimd_enabled_vhe();
> >>>>>  
> >>>>>  	sysreg_save_guest_state_vhe(guest_ctxt);
> >>>>> -	__vgic_save_state(vcpu);
> >>>>>  
> >>>>>  	__deactivate_traps(vcpu);
> >>>>>  
> >>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >>>>> index 5bd879c78951..6de7641f3ff2 100644
> >>>>> --- a/virt/kvm/arm/arm.c
> >>>>> +++ b/virt/kvm/arm/arm.c
> >>>>> @@ -717,6 +717,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>>>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> >>>>>  		    kvm_request_pending(vcpu)) {
> >>>>>  			vcpu->mode = OUTSIDE_GUEST_MODE;
> >>>>> +			isb(); /* Ensure work in x_flush_hwstate is committed */
> >>>>>  			kvm_pmu_sync_hwstate(vcpu);
> >>>>>  			if (static_branch_unlikely(&userspace_irqchip_in_use))
> >>>>>  				kvm_timer_sync_hwstate(vcpu);
> >>>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >>>>> index 12e2a28f437e..d0a19a8c196a 100644
> >>>>> --- a/virt/kvm/arm/vgic/vgic.c
> >>>>> +++ b/virt/kvm/arm/vgic/vgic.c
> >>>>> @@ -19,6 +19,7 @@
> >>>>>  #include <linux/list_sort.h>
> >>>>>  #include <linux/interrupt.h>
> >>>>>  #include <linux/irq.h>
> >>>>> +#include <asm/kvm_hyp.h>
> >>>>>  
> >>>>>  #include "vgic.h"
> >>>>>  
> >>>>> @@ -753,6 +754,8 @@ static inline void vgic_save_state(struct kvm_vcpu *vcpu)
> >>>>>  {
> >>>>>  	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> >>>>>  		vgic_v2_save_state(vcpu);
> >>>>> +	else if (has_vhe())
> >>>>> +		__vgic_v3_save_state(vcpu);
> >>>>>  }
> >>>>>  
> >>>>>  /* Sync back the hardware VGIC state into our emulation after a guest's run. */
> >>>>> @@ -777,6 +780,8 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
> >>>>>  {
> >>>>>  	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> >>>>>  		vgic_v2_restore_state(vcpu);
> >>>>> +	else if (has_vhe())
> >>>>> +		__vgic_v3_restore_state(vcpu);
> >>>>>  }
> >>>>>  
> >>>>>  /* Flush our emulation state into the GIC hardware before entering the guest. */
> >>>>>
> >>>>
> >>>> I'm slowly wrapping my brain around this thing again. If I grasp the
> >>>> general idea, we end up with two cases:
> >>>>
> >>>> (1) The GIC is accessible from the kernel, and we save/restore it
> >>>> outside of the HYP code.
> >>>>
> >>>> (2) The GIC is only accessible from the HYP code, and we do it there.
> >>>>
> >>>> Maybe we should bite the bullet and introduce that primitive instead?
> >>>>
> >>>
> >>> You mean something the following?
> >>>
> >>> static inline bool can_access_vgic_from_kernel(void)
> >>> {
> >>> 	/*
> >>> 	 * GICv2 can always be accessed from the kernel because it is
> >>> 	 * memory-mapped, and VHE systems can access GICv3 EL2 system
> >>> 	 * registers.
> >>> 	 */
> >>> 	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
> >>> }
> >>
> >> Yes. I think this would go a long way in making this code easy to
> >> understand. 
> > 
> > I'll give it a go on the next respin.
> > 
> >> It also mean that we can have a unified save/restore
> >> function that picks the right GIC back-end, resulting in less
> >> code duplication.
> >>
> > Not sure I understand hat you mean here?
> 
> We now have:
> 
> static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
> {
>         if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
>                 __vgic_v3_activate_traps(vcpu);
>                 __vgic_v3_restore_state(vcpu);
>         }
> }
> 
> and 
> 
> static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
> {
>         if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>                 vgic_v2_restore_state(vcpu);
>         else if (has_vhe())
>                 __vgic_v3_restore_state(vcpu);
> }
> 
> I have the feeling that we could reconcile them in a nice way, but
> I'm not completely sure now...
> 
Hmm, yeah, so we have the VHE GICv3 flow:

vcpu_load -> vgic_v3_load -> __vgic_v3_activate_traps
   KVM_RUN -> kvm_vgic_flush_hwstate -> vgic_restore_state ->
              __vgic_v3_restore_state (if we have irqs)

Then we have the non-VHE GICv3 flow:
   KVM_RUN -> __kvm_vcpu_run_nvhe -> __vgic_restore_state ->
     __vgic_v3_activate_traps
     __vgic_v3_restore_state

Then we have the GICv2 flow:
   KVM_RUN -> kvm_vgic_flush_hwstate -> vgic_restore_state ->
              __vgic_v2_restore_state (if we have irqs)

We could at least rename __vgic_restore_state to
__vgic_hyp_restore_state.  Do you see further room for making this less
complicated?

Thanks,
-Christoffer
