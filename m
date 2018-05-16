From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] arm64: KVM: reduce guest fpsimd trap
Date: Wed, 16 May 2018 14:46:21 +0200
Message-ID: <20180516124621.GB55598@C02W217FHV2R.local>
References: <1526460738-11157-1-git-send-email-zhangshaokun@hisilicon.com>
 <F348A9E21A573744858FF7E5D32E29D81BDF52AC@dggemi509-mbs.china.huawei.com>
 <4a812440-b5c6-8a11-a89d-0bad0e7d5150@arm.com>
 <20180516103216.GR7753@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180516103216.GR7753@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Zhangshaokun <zhangshaokun@hisilicon.com>, "Tangnianyao (ICT)" <tangnianyao@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 16, 2018 at 11:32:17AM +0100, Dave Martin wrote:
> On Wed, May 16, 2018 at 10:25:40AM +0100, Marc Zyngier wrote:
> > [+Dave]
> > 
> > Hi Nianyao,
> > 
> > On 16/05/18 10:08, Tangnianyao (ICT) wrote:
> > > Add last_fpsimd_trap to notify if guest last exit reason is handling fpsimd. If guest is using fpsimd frequently, save host's fpsimd state and restore guest's fpsimd state and deactive fpsimd trap before returning to guest. It can avoid guest fpsimd trap soon to improve performance.
> 
> So, the purpose of this patch is to context switch the FPSIMD state on
> initial entry to the guest, instead of enabling the trap and context
> switching the FPSIMD state lazily?
> 
> And you decide whether to do this or not, based on whether the guest
> triggered a lazy FPSIMD switch previously?
> 
> > > 
> > > Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
> > > ---
> > >  arch/arm64/kernel/asm-offsets.c |  1 +
> > >  arch/arm64/kvm/hyp/entry.S      |  5 +++++
> > >  arch/arm64/kvm/hyp/switch.c     | 38 ++++++++++++++++++++++++++++++++++++--
> > >  include/linux/kvm_host.h        |  1 +
> > >  4 files changed, 43 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c index 5bdda65..35a9c5c 100644
> > > --- a/arch/arm64/kernel/asm-offsets.c
> > > +++ b/arch/arm64/kernel/asm-offsets.c
> > > @@ -136,6 +136,7 @@ int main(void)
> > >  #ifdef CONFIG_KVM_ARM_HOST
> > >    DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
> > >    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
> > > +  DEFINE(VCPU_LAST_FPSIMD_TRAP, offsetof(struct kvm_vcpu, 
> > > + last_fpsimd_trap));
> > >    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
> > >    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
> > >    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> > > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S index e41a161..956e042 100644
> > > --- a/arch/arm64/kvm/hyp/entry.S
> > > +++ b/arch/arm64/kvm/hyp/entry.S
> > > @@ -197,6 +197,11 @@ alternative_endif
> > >  	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> > >  	bl	__fpsimd_restore_state
> > >  
> > > +	// Mark guest using fpsimd now
> > > +	ldr x0, [x3, #VCPU_LAST_FPSIMD_TRAP]
> > > +	add x0, x0, #1
> 
> Can this overflow?
> 
> > > +	str x0, [x3, #VCPU_LAST_FPSIMD_TRAP]
> > > +
> > >  	// Skip restoring fpexc32 for AArch64 guests
> > >  	mrs	x1, hcr_el2
> > >  	tbnz	x1, #HCR_RW_SHIFT, 1f
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c index d964523..86eea1b 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -92,7 +92,13 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
> > >  
> > >  	val = read_sysreg(cpacr_el1);
> > >  	val |= CPACR_EL1_TTA;
> > > -	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
> > > +	val &= ~CPACR_EL1_ZEN;
> > > +
> > > +	if (vcpu->last_fpsimd_trap)
> > > +		val |= CPACR_EL1_FPEN;
> > > +	else
> > > +		val &= ~CPACR_EL1_FPEN;
> > > +
> > >  	write_sysreg(val, cpacr_el1);
> > >  
> > >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1); @@ -105,7 +111,13 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> > >  	__activate_traps_common(vcpu);
> > >  
> > >  	val = CPTR_EL2_DEFAULT;
> > > -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> > > +	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> > > +
> > > +	if (vcpu->last_fpsimd_trap)
> > > +		val &= ~CPTR_EL2_TFP;
> > > +	else
> > > +		val |= CPTR_EL2_TFP;
> > > +
> > >  	write_sysreg(val, cptr_el2);
> > >  }
> > >  
> > > @@ -406,6 +418,17 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> > >  	__activate_traps(vcpu);
> > >  	__activate_vm(vcpu->kvm);
> > >  
> > > +	/*
> > > +	 * If guest last trap to host for handling fpsimd, last_fpsimd_trap
> > > +	 * is set. Restore guest's fpsimd state and deactivate fpsimd trap
> > > +	 * to avoid guest traping soon.
> > > +	 */
> > > +	if (vcpu->last_fpsimd_trap) {
> > > +		__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> > > +		__fpsimd_restore_state(&guest_ctxt->gp_regs.fp_regs);
> > > +		vcpu->last_fpsimd_trap = 0;
> > > +	}
> > > +
> > >  	sysreg_restore_guest_state_vhe(guest_ctxt);
> > >  	__debug_switch_to_guest(vcpu);
> > >  
> > > @@ -454,6 +477,17 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
> > >  	__activate_traps(vcpu);
> > >  	__activate_vm(kern_hyp_va(vcpu->kvm));
> > >  
> > > +	/*
> > > +	 * If guest last trap to host for handling fpsimd, last_fpsimd_trap
> > > +	 * is set. Restore guest's fpsimd state and deactivate fpsimd trap
> > > +	 * to avoid guest traping soon.
> > > +	 */
> > > +	if (vcpu->last_fpsimd_trap) {
> > > +		__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> > > +		__fpsimd_restore_state(&guest_ctxt->gp_regs.fp_regs);
> > > +		vcpu->last_fpsimd_trap = 0;
> > > +	}
> > > +
> > >  	__hyp_vgic_restore_state(vcpu);
> > >  	__timer_enable_traps(vcpu);
> > >  
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index 6930c63..46bdf0d 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -274,6 +274,7 @@ struct kvm_vcpu {
> > >  	bool preempted;
> > >  	struct kvm_vcpu_arch arch;
> > >  	struct dentry *debugfs_dentry;
> > > +	unsigned int last_fpsimd_trap;
> > >  };
> > >  
> > >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> > > --
> > > 2.7.4
> > > 
> > 
> > This doesn't seem to be the 100% correct. I can't see how this works
> > when being preempted, for example... I suggest you look at Dave Martin's
> > series[1], which does this correctly.
> 
> If I've understood correctly, this chooses between eager and lazy
> switching, which is addressing a different issue from [1].
> 
> In effect, this code is attempting to predict whether the guest will
> use FPSIMD before the next exit.  If the prediction is correct and the
> guest does use FPSIMD, then the overhead of the lazy FPSIMD trap
> disappears.  This is probably a good thing, though it may increase
> interrupt latency a little.  However, if the prediction is wrong and
> the guest doesn't use FPSIMD before the next exit, then the overhead of
> guest entry increases for no benefit, because FPSIMD was switched
> unnecessarily.
> 
> Do you have any benchmarks or metrics on the accuracy of the
> prediction and the overall impact on performance?
> 
> The changes in [1] should reduce the number of FPSIMD context switches
> overall, so may reduce the benefit of this patch.
> 

Based on previous measurements [2], I found that only in 29% of the
times when we return to userspace or are preempted, has the VCPU touched
the FPSIMD registers, and therefore a significant majority of the times
we enter the guest, the guest doesn't touch the FPSIMD state, even if it
has touched it before.

As Dave suggests, if there is data that shows that an immediately
following entry from an exit that had VFP enabled implies with a very
high probablity that the guest will touch VFP again, then something like
this might make sense, but I'd like to see some data to back up this
hypothesis before adding additional complexity to the code.

[2]: https://lists.cs.columbia.edu/pipermail/kvmarm/2018-February/029835.html

Thanks,
-Christoffer
