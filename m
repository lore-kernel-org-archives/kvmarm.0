From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/9] KVM: arm/arm64: vgic: Defer touching GICH_VMCR to
 vcpu_load/put
Date: Tue, 21 Mar 2017 12:16:07 +0100
Message-ID: <20170321111607.GA15920@cbox>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-2-cdall@linaro.org>
 <a4683f7c-498d-85f3-8987-f6e002f1ebb3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9DD40BE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:14:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aHgCHU2UkRNJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:14:23 -0400 (EDT)
Received: from mail-wr0-f170.google.com (mail-wr0-f170.google.com
 [209.85.128.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4925D40BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:14:21 -0400 (EDT)
Received: by mail-wr0-f170.google.com with SMTP id g10so109803075wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:16:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <a4683f7c-498d-85f3-8987-f6e002f1ebb3@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 10:29:08AM +0000, Marc Zyngier wrote:
> On 20/03/17 10:58, Christoffer Dall wrote:
> > From: Christoffer Dall <cdall@cs.columbia.edu>
> > 
> > We don't have to save/restore the VMCR on every entry to/from the guest,
> > since on GICv2 we can access the control interface from EL1 and on VHE
> > systems with GICv3 we can access the control interface from KVM running
> > in EL2.
> > 
> > GICv3 systems without VHE becomes the rare case, which has to
> > save/restore the register on each round trip.
> > 
> > For in-context accesses to the VMCR, meaning emulation code needs access
> > to the value of the VCPU that is currently running within vcpu_load
> > and vcpu_put will detect that the it should load the VMCR from the
> > physical GIC instead of using the cached memory value.  While this extra
> > checking adds some code complexity we end up moving code out of the
> > critical path.
> > 
> > Note that userspace accesses may see out-of-date values if the VCPU is
> > running while accessing the VGIC state via the KVM device API, but this
> > is already the case.
> > 
> > Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_asm.h   |  3 +++
> >  arch/arm/kvm/arm.c               | 11 +++++-----
> >  arch/arm64/include/asm/kvm_asm.h |  2 ++
> >  include/kvm/arm_vgic.h           |  3 +++
> >  virt/kvm/arm/hyp/vgic-v2-sr.c    |  3 ---
> >  virt/kvm/arm/hyp/vgic-v3-sr.c    | 14 ++++++++----
> >  virt/kvm/arm/vgic/vgic-init.c    | 12 +++++++++++
> >  virt/kvm/arm/vgic/vgic-v2.c      | 46 ++++++++++++++++++++++++++++++++++++++--
> >  virt/kvm/arm/vgic/vgic-v3.c      | 42 ++++++++++++++++++++++++++++++++++--
> >  virt/kvm/arm/vgic/vgic.c         | 22 +++++++++++++++++++
> >  virt/kvm/arm/vgic/vgic.h         |  6 ++++++
> >  11 files changed, 148 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> > index 8ef0538..dd16044 100644
> > --- a/arch/arm/include/asm/kvm_asm.h
> > +++ b/arch/arm/include/asm/kvm_asm.h
> > @@ -75,7 +75,10 @@ extern void __init_stage2_translation(void);
> >  extern void __kvm_hyp_reset(unsigned long);
> >  
> >  extern u64 __vgic_v3_get_ich_vtr_el2(void);
> > +extern u64 __vgic_v3_read_vmcr(void);
> > +extern void __vgic_v3_write_vmcr(u32 vmcr);
> >  extern void __vgic_v3_init_lrs(void);
> > +
> >  #endif
> >  
> >  #endif /* __ARM_KVM_ASM_H__ */
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index d775aac..cfdf2f5 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -348,15 +348,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
> >  
> >  	kvm_arm_set_running_vcpu(vcpu);
> > +
> > +	kvm_vgic_load(vcpu);
> >  }
> >  
> >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  {
> > -	/*
> > -	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
> > -	 * if the vcpu is no longer assigned to a cpu.  This is used for the
> > -	 * optimized make_all_cpus_request path.
> > -	 */
> > +	kvm_vgic_put(vcpu);
> > +
> >  	vcpu->cpu = -1;
> >  
> >  	kvm_arm_set_running_vcpu(NULL);
> > @@ -630,7 +629,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		 * non-preemptible context.
> >  		 */
> >  		preempt_disable();
> > +
> >  		kvm_pmu_flush_hwstate(vcpu);
> > +
> >  		kvm_timer_flush_hwstate(vcpu);
> >  		kvm_vgic_flush_hwstate(vcpu);
> >  
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index ec3553eb..49f99cd 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -59,6 +59,8 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
> >  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >  
> >  extern u64 __vgic_v3_get_ich_vtr_el2(void);
> > +extern u64 __vgic_v3_read_vmcr(void);
> > +extern void __vgic_v3_write_vmcr(u32 vmcr);
> >  extern void __vgic_v3_init_lrs(void);
> >  
> >  extern u32 __kvm_get_mdcr_el2(void);
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index c0b3d99..8d7c3a7 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -307,6 +307,9 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >  
> >  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >  
> > +void kvm_vgic_load(struct kvm_vcpu *vcpu);
> > +void kvm_vgic_put(struct kvm_vcpu *vcpu);
> > +
> >  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
> >  #define vgic_initialized(k)	((k)->arch.vgic.initialized)
> >  #define vgic_ready(k)		((k)->arch.vgic.ready)
> > diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> > index c8aeb7b..d3d3b9b 100644
> > --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> > +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> > @@ -114,8 +114,6 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
> >  	if (!base)
> >  		return;
> >  
> > -	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
> > -
> >  	if (vcpu->arch.vgic_cpu.live_lrs) {
> >  		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
> >  
> > @@ -165,7 +163,6 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
> >  		}
> >  	}
> >  
> > -	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
> >  	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
> >  }
> >  
> > diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > index 3947095..e51ee7e 100644
> > --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> > +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > @@ -159,8 +159,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >  	if (!cpu_if->vgic_sre)
> >  		dsb(st);
> >  
> > -	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
> > -
> >  	if (vcpu->arch.vgic_cpu.live_lrs) {
> >  		int i;
> >  		u32 max_lr_idx, nr_pri_bits;
> > @@ -261,8 +259,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >  			live_lrs |= (1 << i);
> >  	}
> >  
> > -	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
> > -
> >  	if (live_lrs) {
> >  		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> >  
> > @@ -326,3 +322,13 @@ u64 __hyp_text __vgic_v3_get_ich_vtr_el2(void)
> >  {
> >  	return read_gicreg(ICH_VTR_EL2);
> >  }
> > +
> > +u64 __hyp_text __vgic_v3_read_vmcr(void)
> > +{
> > +	return read_gicreg(ICH_VMCR_EL2);
> > +}
> > +
> > +void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
> > +{
> > +	write_gicreg(vmcr, ICH_VMCR_EL2);
> > +}
> > diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> > index 702f810..3762fd1 100644
> > --- a/virt/kvm/arm/vgic/vgic-init.c
> > +++ b/virt/kvm/arm/vgic/vgic-init.c
> > @@ -262,6 +262,18 @@ int vgic_init(struct kvm *kvm)
> >  	vgic_debug_init(kvm);
> >  
> >  	dist->initialized = true;
> > +
> > +	/*
> > +	 * If we're initializing GICv2 on-demand when first running the VCPU
> > +	 * then we need to load the VGIC state onto the CPU.  We can detect
> > +	 * this easily by checking if we are in between vcpu_load and vcpu_put
> > +	 * when we just initialized the VGIC.
> > +	 */
> > +	preempt_disable();
> > +	vcpu = kvm_arm_get_running_vcpu();
> > +	if (vcpu)
> > +		kvm_vgic_load(vcpu);
> > +	preempt_enable();
> >  out:
> >  	return ret;
> >  }
> > diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> > index 94cf4b9..dfe6e5e 100644
> > --- a/virt/kvm/arm/vgic/vgic-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-v2.c
> > @@ -199,6 +199,9 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
> >  
> >  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  {
> > +	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	int cpu;
> >  	u32 vmcr;
> >  
> >  	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
> > @@ -209,12 +212,35 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
> >  		GICH_VMCR_PRIMASK_MASK;
> >  
> > -	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
> > +	cpu_if->vgic_vmcr = vmcr;
> > +
> > +	cpu = get_cpu();
> > +	if (vcpu->cpu == cpu)
> > +		/*
> > +		 * We have run vcpu_load and we're on VHE which means the VMCR
> > +		 * has already been flushed to the CPU; flush it again.
> > +		 */
> 
> I don't understand this comment. What has VHE to do with this?
> 

Bah, I used to only do this on VHE systems and do the save/restore on
GICv3-non-vhe systems, but then I changed it to use kvm_call_hyp in
load/put, so the comment is out of date.  Thanks for spotting it.

> > +		writel_relaxed(vmcr, vgic->vctrl_base + GICH_VMCR);
> > +	put_cpu();
> 
> There is one thing I don't quite get: I thought we could only get there
> with a userspace access. I understand that we've run vcpu_load()
> already, 

Actually, I think I was completely misguided here; I don't think you can
ever end up here between vcpu_load and vcpu_put...

> and that we end-up with a stale configuration in the HW. But
> why do we need to immediately propagate it? Surely we can rely on the
> vcpu thread doing a vcpu_load itself to load the new value, right? I
> must be missing something...

... and you're right, there's no actual change in functionality in that
userspace should stop the VCPU to ensure an updated value when reading
back the VMCR-based register values.  So I can just get rid of this
nonsense.

> 
> >  }
> >  
> >  void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  {
> > -	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
> > +	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	int cpu;
> > +	u32 vmcr;
> > +
> > +	cpu = get_cpu();
> > +	if (vcpu->cpu == cpu)
> > +		/*
> > +		 * We have run vcpu_load and which means the VMCR
> > +		 * has already been flushed to the CPU; sync it back.
> > +		 */
> > +		cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
> > +	put_cpu();
> > +
> > +	vmcr = cpu_if->vgic_vmcr;
> 
> Same comment as above.
> 
Same answer.

I'll rework this.

Thanks,
-Christoffer
