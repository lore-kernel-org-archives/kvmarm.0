From: "Tangnianyao (ICT)" <tangnianyao@huawei.com>
Subject: Re: [PATCH] arm64: KVM: reduce guest fpsimd trap
Date: Sat, 19 May 2018 02:38:33 +0000
Message-ID: <F348A9E21A573744858FF7E5D32E29D81BDF6C92@dggemi509-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57BB94A0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 May 2018 22:28:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id afq9wddbyvVR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 May 2018 22:28:19 -0400 (EDT)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BC474043C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 May 2018 22:28:19 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Zhangshaokun <zhangshaokun@hisilicon.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 16, 2018 at 20:46 PM GST+8, Christoffer Dall wrote:
> On Wed, May 16, 2018 at 11:32:17AM +0100, Dave Martin wrote:
> > On Wed, May 16, 2018 at 10:25:40AM +0100, Marc Zyngier wrote:
> > > [+Dave]
> > > 
> > > Hi Nianyao,
> > > 
> > > On 16/05/18 10:08, Tangnianyao (ICT) wrote:
> > > > Add last_fpsimd_trap to notify if guest last exit reason is handling fpsimd. If guest is using fpsimd frequently, save host's fpsimd state and restore guest's fpsimd state and deactive fpsimd trap before returning to guest. It can avoid guest fpsimd trap soon to improve performance.
> > 
> > So, the purpose of this patch is to context switch the FPSIMD state on 
> > initial entry to the guest, instead of enabling the trap and context 
> > switching the FPSIMD state lazily?
> > 
> > And you decide whether to do this or not, based on whether the guest 
> triggered a lazy FPSIMD switch previously?

I try to detect guest using fpsimd , but not overtraining which may 
include more complexity and not suitable for common cases. Therefore I 
just decide whether guest have triggerd a lazy fpsimd switch last time.

> > 
> > > > 
> > > > Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
> > > > ---
> > > >  arch/arm64/kernel/asm-offsets.c |  1 +
> > > >  arch/arm64/kvm/hyp/entry.S      |  5 +++++
> > > >  arch/arm64/kvm/hyp/switch.c     | 38 ++++++++++++++++++++++++++++++++++++--
> > > >  include/linux/kvm_host.h        |  1 +
> > > >  4 files changed, 43 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kernel/asm-offsets.c 
> > > > b/arch/arm64/kernel/asm-offsets.c index 5bdda65..35a9c5c 100644
> > > > --- a/arch/arm64/kernel/asm-offsets.c
> > > > +++ b/arch/arm64/kernel/asm-offsets.c
> > > > @@ -136,6 +136,7 @@ int main(void)  #ifdef CONFIG_KVM_ARM_HOST
> > > >    DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
> > > >    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
> > > > +  DEFINE(VCPU_LAST_FPSIMD_TRAP, offsetof(struct kvm_vcpu, 
> > > > + last_fpsimd_trap));
> > > >    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
> > > >    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
> > > >    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> > > > diff --git a/arch/arm64/kvm/hyp/entry.S 
> > > > b/arch/arm64/kvm/hyp/entry.S index e41a161..956e042 100644
> > > > --- a/arch/arm64/kvm/hyp/entry.S
> > > > +++ b/arch/arm64/kvm/hyp/entry.S
> > > > @@ -197,6 +197,11 @@ alternative_endif
> > > >  	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> > > >  	bl	__fpsimd_restore_state
> > > >  
> > > > +	// Mark guest using fpsimd now
> > > > +	ldr x0, [x3, #VCPU_LAST_FPSIMD_TRAP]
> > > > +	add x0, x0, #1
> > 
> > Can this overflow?

It won't overflow. It only trigger one fpsimd trap and restore guest's fpsimd
state and deactivate fpsimd trap. When next non-fpsimd trap comes, it will be clear unconditionally.

> > 
> > > > +	str x0, [x3, #VCPU_LAST_FPSIMD_TRAP]
> > > > +
> > > >  	// Skip restoring fpexc32 for AArch64 guests
> > > >  	mrs	x1, hcr_el2
> > > >  	tbnz	x1, #HCR_RW_SHIFT, 1f
> > > > diff --git a/arch/arm64/kvm/hyp/switch.c 
> > > > b/arch/arm64/kvm/hyp/switch.c index d964523..86eea1b 100644
> > > > --- a/arch/arm64/kvm/hyp/switch.c
> > > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > > @@ -92,7 +92,13 @@ static void activate_traps_vhe(struct kvm_vcpu 
> > > > *vcpu)
> > > >  
> > > >  	val = read_sysreg(cpacr_el1);
> > > >  	val |= CPACR_EL1_TTA;
> > > > -	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
> > > > +	val &= ~CPACR_EL1_ZEN;
> > > > +
> > > > +	if (vcpu->last_fpsimd_trap)
> > > > +		val |= CPACR_EL1_FPEN;
> > > > +	else
> > > > +		val &= ~CPACR_EL1_FPEN;
> > > > +
> > > >  	write_sysreg(val, cpacr_el1);
> > > >  
> > > >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1); @@ -105,7 +111,13 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> > > >  	__activate_traps_common(vcpu);
> > > >  
> > > >  	val = CPTR_EL2_DEFAULT;
> > > > -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> > > > +	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> > > > +
> > > > +	if (vcpu->last_fpsimd_trap)
> > > > +		val &= ~CPTR_EL2_TFP;
> > > > +	else
> > > > +		val |= CPTR_EL2_TFP;
> > > > +
> > > >  	write_sysreg(val, cptr_el2);
> > > >  }
> > > >  
> > > > @@ -406,6 +418,17 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> > > >  	__activate_traps(vcpu);
> > > >  	__activate_vm(vcpu->kvm);
> > > >  
> > > > +	/*
> > > > +	 * If guest last trap to host for handling fpsimd, last_fpsimd_trap
> > > > +	 * is set. Restore guest's fpsimd state and deactivate fpsimd trap
> > > > +	 * to avoid guest traping soon.
> > > > +	 */
> > > > +	if (vcpu->last_fpsimd_trap) {
> > > > +		__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> > > > +		__fpsimd_restore_state(&guest_ctxt->gp_regs.fp_regs);
> > > > +		vcpu->last_fpsimd_trap = 0;
> > > > +	}
> > > > +
> > > >  	sysreg_restore_guest_state_vhe(guest_ctxt);
> > > >  	__debug_switch_to_guest(vcpu);
> > > >  
> > > > @@ -454,6 +477,17 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
> > > >  	__activate_traps(vcpu);
> > > >  	__activate_vm(kern_hyp_va(vcpu->kvm));
> > > >  
> > > > +	/*
> > > > +	 * If guest last trap to host for handling fpsimd, last_fpsimd_trap
> > > > +	 * is set. Restore guest's fpsimd state and deactivate fpsimd trap
> > > > +	 * to avoid guest traping soon.
> > > > +	 */
> > > > +	if (vcpu->last_fpsimd_trap) {
> > > > +		__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> > > > +		__fpsimd_restore_state(&guest_ctxt->gp_regs.fp_regs);
> > > > +		vcpu->last_fpsimd_trap = 0;
> > > > +	}
> > > > +
> > > >  	__hyp_vgic_restore_state(vcpu);
> > > >  	__timer_enable_traps(vcpu);
> > > >  
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h 
> > > > index 6930c63..46bdf0d 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -274,6 +274,7 @@ struct kvm_vcpu {
> > > >  	bool preempted;
> > > >  	struct kvm_vcpu_arch arch;
> > > >  	struct dentry *debugfs_dentry;
> > > > +	unsigned int last_fpsimd_trap;
> > > >  };
> > > >  
> > > >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu 
> > > > *vcpu)
> > > > --
> > > > 2.7.4
> > > > 
> > > 
> > > This doesn't seem to be the 100% correct. I can't see how this works 
> > > when being preempted, for example... I suggest you look at Dave 
> > > Martin's series[1], which does this correctly.
> > 
> > If I've understood correctly, this chooses between eager and lazy 
> > switching, which is addressing a different issue from [1].
> > 
> > In effect, this code is attempting to predict whether the guest will 
> > use FPSIMD before the next exit.  If the prediction is correct and the 
> > guest does use FPSIMD, then the overhead of the lazy FPSIMD trap 
> > disappears.  This is probably a good thing, though it may increase 
> > interrupt latency a little.  However, if the prediction is wrong and 
> > the guest doesn't use FPSIMD before the next exit, then the overhead 
> > of guest entry increases for no benefit, because FPSIMD was switched 
> > unnecessarily.
> > 
> > Do you have any benchmarks or metrics on the accuracy of the 
> > prediction and the overall impact on performance?
> > 
> > The changes in [1] should reduce the number of FPSIMD context switches 
> > overall, so may reduce the benefit of this patch.
> > 

This idea may be different. It tries to detect guest using fpsimd, do eager 
switching ,and reduce guest trap. [1] reduces fpsimd context switches in host when
it has already trapped.

> 
> 
> Based on previous measurements [2], I found that only in 29% of the times when we return to userspace or are preempted, has the VCPU touched the FPSIMD registers, and therefore a significant majority of the times we enter the guest, the guest doesn't touch the FPSIMD state, even if it has touched it before.
> 
> As Dave suggests, if there is data that shows that an immediately following entry from an exit that had VFP enabled implies with a very high probablity that the guest will touch VFP again, then something like this might make sense, but I'd like to see some data to back up this hypothesis before adding additional complexity to the code.
> 
> [2]: https://lists.cs.columbia.edu/pipermail/kvmarm/2018-February/029835.html

I try to detect guest using fpsimd, and choose eager switching to avoid trapping to hyp soon.
The reason is, in some micro architecture, vmid switch will flush all L1 TLB entry which doesn't
contain vmid. It will result in extra 2-stage table walk when returning to guest, which could be
avoid if not trap to el2. As I know, Maia has this issue.

I have done some benchmark test on guest and find that, frequent context switch , which
save and restore fpsimd frequently, resulted in extra cost compared to host context switch
because of fpsimd trap. In some benchmarks, like lat_ctx and lat_udp, one asid usually got stuck
and scheduled to another, where context switch and handling fpsimd happened very frequently.
In my performance test, lat_ctx with 4 asid switch. In comparison between guest and host, 
without this, guest is 10% worse than host. With this, guest is only 8% worse than host.

Detect guest using fpsimd based on lazy fpsimd switch may be not 100% correct. 
I think accurate detection may be overtraining and is not suitable for common cases.
Therefore I just do it in simply way to reduce some fpsimd traps.


Thanks,
-Nianyao Tang
