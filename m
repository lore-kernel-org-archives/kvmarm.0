From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 39/40] KVM: arm/arm64: Move VGIC APR save/restore to
 vgic put/load
Date: Thu, 22 Feb 2018 15:44:43 +0100
Message-ID: <20180222144443.GP29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-40-christoffer.dall@linaro.org>
 <3f2f60ba-2269-7ebd-872c-b50dc2ca3e3b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <3f2f60ba-2269-7ebd-872c-b50dc2ca3e3b@arm.com>
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

On Thu, Feb 22, 2018 at 01:11:55PM +0000, Marc Zyngier wrote:
> On 15/02/18 21:03, Christoffer Dall wrote:
> > The APRs can only have bits set when the guest acknowledges an interrupt
> > in the LR and can only have a bit cleared when the guest EOIs an
> > interrupt in the LR.  Therefore, if we have no LRs with any
> > pending/active interrupts, the APR cannot change value and there is no
> > need to clear it on every exit from the VM (hint: it will have already
> > been cleared when we exited the guest the last time with the LRs all
> > EOIed).
> > 
> > The only case we need to take care of is when we migrate the VCPU away
> > from a CPU or migrate a new VCPU onto a CPU, or when we return to
> > userspace to capture the state of the VCPU for migration.  To make sure
> > this works, factor out the APR save/restore functionality into separate
> > functions called from the VCPU (and by extension VGIC) put/load hooks.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_hyp.h   |   2 +
> >  arch/arm64/include/asm/kvm_hyp.h |   2 +
> >  virt/kvm/arm/hyp/vgic-v3-sr.c    | 124 +++++++++++++++++++++------------------
> >  virt/kvm/arm/vgic/vgic-v2.c      |   7 +--
> >  virt/kvm/arm/vgic/vgic-v3.c      |   5 ++
> >  5 files changed, 78 insertions(+), 62 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
> > index 1ab8329e9ff7..530a3c1cfe6f 100644
> > --- a/arch/arm/include/asm/kvm_hyp.h
> > +++ b/arch/arm/include/asm/kvm_hyp.h
> > @@ -110,6 +110,8 @@ void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
> >  
> >  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> >  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> > +void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
> > +void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
> >  
> >  asmlinkage void __vfp_save_state(struct vfp_hard_struct *vfp);
> >  asmlinkage void __vfp_restore_state(struct vfp_hard_struct *vfp);
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index febe417b8b4e..6f3929b2fcf7 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -124,6 +124,8 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
> >  
> >  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> >  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> > +void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
> > +void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
> >  int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
> >  
> >  void __timer_enable_traps(struct kvm_vcpu *vcpu);
> > diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > index 9abf2f3c12b5..437d7af08683 100644
> > --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> > +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > @@ -21,6 +21,7 @@
> >  
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_hyp.h>
> > +#include <asm/kvm_mmu.h>
> >  
> >  #define vtr_to_max_lr_idx(v)		((v) & 0xf)
> >  #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
> > @@ -221,14 +222,11 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >  
> >  	if (used_lrs) {
> >  		int i;
> > -		u32 nr_pre_bits;
> >  		u32 elrsr;
> >  
> >  		elrsr = read_gicreg(ICH_ELSR_EL2);
> >  
> >  		write_gicreg(0, ICH_HCR_EL2);
> > -		val = read_gicreg(ICH_VTR_EL2);
> > -		nr_pre_bits = vtr_to_nr_pre_bits(val);
> >  
> >  		for (i = 0; i < used_lrs; i++) {
> >  			if (elrsr & (1 << i))
> > @@ -238,39 +236,10 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >  
> >  			__gic_v3_set_lr(0, i);
> >  		}
> > -
> > -		switch (nr_pre_bits) {
> > -		case 7:
> > -			cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
> > -			cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
> > -		case 6:
> > -			cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
> > -		default:
> > -			cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
> > -		}
> > -
> > -		switch (nr_pre_bits) {
> > -		case 7:
> > -			cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
> > -			cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
> > -		case 6:
> > -			cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
> > -		default:
> > -			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
> > -		}
> >  	} else {
> >  		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
> >  		    cpu_if->its_vpe.its_vm)
> >  			write_gicreg(0, ICH_HCR_EL2);
> > -
> > -		cpu_if->vgic_ap0r[0] = 0;
> > -		cpu_if->vgic_ap0r[1] = 0;
> > -		cpu_if->vgic_ap0r[2] = 0;
> > -		cpu_if->vgic_ap0r[3] = 0;
> > -		cpu_if->vgic_ap1r[0] = 0;
> > -		cpu_if->vgic_ap1r[1] = 0;
> > -		cpu_if->vgic_ap1r[2] = 0;
> > -		cpu_if->vgic_ap1r[3] = 0;
> >  	}
> >  
> >  	val = read_gicreg(ICC_SRE_EL2);
> > @@ -287,8 +256,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> >  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> > -	u64 val;
> > -	u32 nr_pre_bits;
> >  	int i;
> >  
> >  	/*
> > @@ -306,32 +273,9 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >  		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
> >  	}
> >  
> > -	val = read_gicreg(ICH_VTR_EL2);
> > -	nr_pre_bits = vtr_to_nr_pre_bits(val);
> > -
> >  	if (used_lrs) {
> >  		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> >  
> > -		switch (nr_pre_bits) {
> > -		case 7:
> > -			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
> > -			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
> > -		case 6:
> > -			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
> > -		default:
> > -			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
> > -		}
> > -
> > -		switch (nr_pre_bits) {
> > -		case 7:
> > -			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
> > -			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
> > -		case 6:
> > -			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
> > -		default:
> > -			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
> > -		}
> > -
> >  		for (i = 0; i < used_lrs; i++)
> >  			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
> >  	} else {
> > @@ -364,6 +308,72 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >  		     ICC_SRE_EL2);
> >  }
> >  
> > +void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v3_cpu_if *cpu_if;
> > +	u64 val;
> > +	u32 nr_pre_bits;
> > +
> > +	vcpu = kern_hyp_va(vcpu);
> > +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +	val = read_gicreg(ICH_VTR_EL2);
> > +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
> > +		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
> > +	case 6:
> > +		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
> > +	default:
> > +		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
> > +	}
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
> > +		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
> > +	case 6:
> > +		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
> > +	default:
> > +		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
> > +	}
> > +}
> > +
> > +void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v3_cpu_if *cpu_if;
> > +	u64 val;
> > +	u32 nr_pre_bits;
> > +
> > +	vcpu = kern_hyp_va(vcpu);
> > +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +	val = read_gicreg(ICH_VTR_EL2);
> > +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
> > +	case 6:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
> > +	default:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
> > +	}
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
> > +	case 6:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
> > +	default:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
> > +	}
> > +}
> > +
> >  void __hyp_text __vgic_v3_init_lrs(void)
> >  {
> >  	int max_lr_idx = vtr_to_max_lr_idx(read_gicreg(ICH_VTR_EL2));
> > diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> > index 1e5f3eb6973d..ca7cfee9f353 100644
> > --- a/virt/kvm/arm/vgic/vgic-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-v2.c
> > @@ -446,7 +446,6 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm *kvm = vcpu->kvm;
> >  	struct vgic_dist *vgic = &kvm->arch.vgic;
> > -	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> >  	void __iomem *base = vgic->vctrl_base;
> >  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> >  
> > @@ -454,11 +453,8 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
> >  		return;
> >  
> >  	if (used_lrs) {
> > -		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
> >  		save_lrs(vcpu, base);
> >  		writel_relaxed(0, base + GICH_HCR);
> > -	} else {
> > -		cpu_if->vgic_apr = 0;
> >  	}
> >  }
> >  
> > @@ -476,7 +472,6 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
> >  
> >  	if (used_lrs) {
> >  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
> > -		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
> >  		for (i = 0; i < used_lrs; i++) {
> >  			writel_relaxed(cpu_if->vgic_lr[i],
> >  				       base + GICH_LR0 + (i * 4));
> > @@ -490,6 +485,7 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
> >  	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
> >  
> >  	writel_relaxed(cpu_if->vgic_vmcr, vgic->vctrl_base + GICH_VMCR);
> > +	writel_relaxed(cpu_if->vgic_apr, vgic->vctrl_base + GICH_APR);
> >  }
> >  
> >  void vgic_v2_put(struct kvm_vcpu *vcpu)
> > @@ -498,4 +494,5 @@ void vgic_v2_put(struct kvm_vcpu *vcpu)
> >  	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
> >  
> >  	cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
> > +	cpu_if->vgic_apr = readl_relaxed(vgic->vctrl_base + GICH_APR);
> >  }
> > diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> > index b76e21f3e6bd..4bafcd1e6bb8 100644
> > --- a/virt/kvm/arm/vgic/vgic-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-v3.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/kvm.h>
> >  #include <linux/kvm_host.h>
> >  #include <kvm/arm_vgic.h>
> > +#include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/kvm_asm.h>
> >  
> > @@ -587,6 +588,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
> >  	 */
> >  	if (likely(cpu_if->vgic_sre))
> >  		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
> > +
> > +	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
> >  }
> >  
> >  void vgic_v3_put(struct kvm_vcpu *vcpu)
> > @@ -595,4 +598,6 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
> >  
> >  	if (likely(cpu_if->vgic_sre))
> >  		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
> > +
> > +	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
> >  }
> > 
> 
> An unfortunate consequence of the save/restore de-aggregation process in
> this series is that we end-up doing quite a few EL2 calls in the !VHE
> case. We should probably think of consolidating those behind a single
> EL2 call if they have a measurable impact.

We could, but the trap to EL2 (without saving all GP regs beyond the
normal calling convention) is really cheap, so I don't think it *is*
that bad, but it *feels* bad.  Also, few of these are in the criticial
path, right?

I'll admit that I haven't measured non-VHE GICv3 impact of this series
(only non-VHE GICv2 which saw a small improvement).

> 
> In the meantime:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks,
-Christoffer
