From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 6/7] ARM: KVM: Get ready to use vgic-v3
Date: Tue, 6 Sep 2016 18:49:26 +0200
Message-ID: <20160906164926.GE23592@cbox>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-7-git-send-email-vladimir.murzin@arm.com>
 <20160905112920.GK26366@cbox> <57CEC0C7.6090603@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B36040B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:38:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ULlkoMekoPnh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 12:38:33 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7CCB407AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:38:33 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id i204so44681149wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 09:46:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57CEC0C7.6090603@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 02:12:39PM +0100, Vladimir Murzin wrote:
> On 05/09/16 12:29, Christoffer Dall wrote:
> > On Tue, Aug 16, 2016 at 11:46:57AM +0100, Vladimir Murzin wrote:
> >> We need to take care we have everything vgic-v3 expects from us before
> >> a quantum leap:
> >> - provide required macros via uapi.h
> >> - handle access to GICv3 cpu interface from the guest
> >> - provide mapping between arm64 version of GICv3 cpu registers and arm's
> >>
> >> The later is handled via redirection of read{write}_gicreg() and
> > 
> > 'The latter'
> > 
> 
> Fixed.
> 
> >> required mainly because 64-bit wide ICH_LR is split in two 32-bit
> >> halves (ICH_LR and ICH_LRC) accessed independently.
> >>
> >> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> >> ---
> >>  arch/arm/include/asm/arch_gicv3.h |   64 +++++++++++++++++++++++++++++++++++++
> >>  arch/arm/include/asm/kvm_asm.h    |    3 ++
> >>  arch/arm/include/uapi/asm/kvm.h   |    7 ++++
> >>  arch/arm/kvm/coproc.c             |   36 +++++++++++++++++++++
> >>  4 files changed, 110 insertions(+)
> >>
> >> diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
> >> index af25c32..f93f6bd 100644
> >> --- a/arch/arm/include/asm/arch_gicv3.h
> >> +++ b/arch/arm/include/asm/arch_gicv3.h
> >> @@ -96,6 +96,70 @@
> >>  #define ICH_AP1R2			__AP1Rx(2)
> >>  #define ICH_AP1R3			__AP1Rx(3)
> >>  
> >> +/* A32-to-A64 mappings used by VGIC save/restore */
> >> +
> >> +#define CPUIF_MAP(a32, a64)			\
> >> +static inline void write_ ## a64(u32 val)	\
> >> +{						\
> >> +	write_sysreg(val, a32);			\
> >> +}						\
> >> +static inline u32 read_ ## a64(void)		\
> >> +{						\
> >> +	return read_sysreg(a32); 		\
> >> +}						\
> >> +
> >> +#define CPUIF_MAP_LO_HI(a32lo, a32hi, a64)	\
> >> +static inline void write_ ## a64(u64 val)	\
> >> +{						\
> >> +	write_sysreg((u32)val, a32lo);		\
> >> +	write_sysreg((u32)(val >> 32), a32hi);	\
> >> +}						\
> >> +static inline u64 read_ ## a64(void)		\
> >> +{						\
> >> +	u64 val = read_sysreg(a32lo);		\
> >> +						\
> >> +	val |=	(u64)read_sysreg(a32hi) << 32;	\
> >> +						\
> >> +	return val; 				\
> >> +}
> > 
> > I really don't like that we're defining new functions using a macro.
> 
> I can expand it manually if think it'd look better. I can also suggest
> to prefix generated functions with underscore.
> 

I understand the desire to avoid manually writing all these static
functions.

> > 
> > Why can't you just do whatever series of actions and/or type
> > conversions using familiar tricks such as 'do { foo; } while (0);'
> > and so on ?
> 
> Probably, because I don't how to apply these tricks here to keep
> virt/kvm/arm/hyp/vgic-v3-sr.c unchanged. If you have something
> particular in mind, please, suggest!
> 

Hmmm, no I see now what you're doing, by defining all those static
inlines, you're effectively creating a mapping with a function for each
register mapping the 32-bit to the 64-bit accessors.

I guess this makes sense and that is probably why you call this _MAP.

I wish there were a good/better/cleaner way to do this, but I can live
with it.

Thanks,
-Christoffer


> > 
> >> +
> >> +CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
> >> +CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
> >> +CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
> >> +CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
> >> +CPUIF_MAP(ICH_ELSR, ICH_ELSR_EL2)
> >> +CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
> >> +CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
> >> +CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
> >> +CPUIF_MAP(ICH_AP0R1, ICH_AP0R1_EL2)
> >> +CPUIF_MAP(ICH_AP0R0, ICH_AP0R0_EL2)
> >> +CPUIF_MAP(ICH_AP1R3, ICH_AP1R3_EL2)
> >> +CPUIF_MAP(ICH_AP1R2, ICH_AP1R2_EL2)
> >> +CPUIF_MAP(ICH_AP1R1, ICH_AP1R1_EL2)
> >> +CPUIF_MAP(ICH_AP1R0, ICH_AP1R0_EL2)
> >> +CPUIF_MAP(ICC_HSRE, ICC_SRE_EL2)
> >> +CPUIF_MAP(ICC_SRE, ICC_SRE_EL1)
> >> +
> >> +CPUIF_MAP_LO_HI(ICH_LR15, ICH_LRC15, ICH_LR15_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR14, ICH_LRC14, ICH_LR14_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR13, ICH_LRC13, ICH_LR13_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR12, ICH_LRC12, ICH_LR12_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR11, ICH_LRC11, ICH_LR11_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR10, ICH_LRC10, ICH_LR10_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR9, ICH_LRC9, ICH_LR9_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR8, ICH_LRC8, ICH_LR8_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR7, ICH_LRC7, ICH_LR7_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR6, ICH_LRC6, ICH_LR6_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR5, ICH_LRC5, ICH_LR5_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR4, ICH_LRC4, ICH_LR4_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR3, ICH_LRC3, ICH_LR3_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR2, ICH_LRC2, ICH_LR2_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR1, ICH_LRC1, ICH_LR1_EL2)
> >> +CPUIF_MAP_LO_HI(ICH_LR0, ICH_LRC0, ICH_LR0_EL2)
> >> +
> >> +#define read_gicreg(r)                 read_##r()
> >> +#define write_gicreg(v, r)             write_##r(v)
> >> +
> >>  /* Low-level accessors */
> >>  
> >>  static inline void gic_write_eoir(u32 irq)
> >> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> >> index 58faff5..dfccf94 100644
> >> --- a/arch/arm/include/asm/kvm_asm.h
> >> +++ b/arch/arm/include/asm/kvm_asm.h
> >> @@ -68,6 +68,9 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >>  extern void __init_stage2_translation(void);
> >>  
> >>  extern void __kvm_hyp_reset(unsigned long);
> >> +
> >> +extern u64 __vgic_v3_get_ich_vtr_el2(void);
> >> +extern void __vgic_v3_init_lrs(void);
> >>  #endif
> >>  
> >>  #endif /* __ARM_KVM_ASM_H__ */
> >> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> >> index a2b3eb3..b38c10c 100644
> >> --- a/arch/arm/include/uapi/asm/kvm.h
> >> +++ b/arch/arm/include/uapi/asm/kvm.h
> >> @@ -84,6 +84,13 @@ struct kvm_regs {
> >>  #define KVM_VGIC_V2_DIST_SIZE		0x1000
> >>  #define KVM_VGIC_V2_CPU_SIZE		0x2000
> >>  
> >> +/* Supported VGICv3 address types  */
> >> +#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
> >> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> >> +
> >> +#define KVM_VGIC_V3_DIST_SIZE		SZ_64K
> >> +#define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> >> +
> >>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
> >>  #define KVM_ARM_VCPU_PSCI_0_2		1 /* CPU uses PSCI v0.2 */
> >>  
> >> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> >> index 1bb2b79..10c0244 100644
> >> --- a/arch/arm/kvm/coproc.c
> >> +++ b/arch/arm/kvm/coproc.c
> >> @@ -228,6 +228,36 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
> >>  	return true;
> >>  }
> >>  
> >> +static bool access_gic_sgi(struct kvm_vcpu *vcpu,
> >> +			   const struct coproc_params *p,
> >> +			   const struct coproc_reg *r)
> >> +{
> >> +	u64 reg;
> >> +
> >> +	if (!p->is_write)
> >> +		return read_from_write_only(vcpu, p);
> >> +
> >> +	reg = *vcpu_reg(vcpu, p->Rt2);
> >> +	reg <<= 32;
> >> +	reg |= *vcpu_reg(vcpu, p->Rt1) ;
> >> +
> >> +	vgic_v3_dispatch_sgi(vcpu, reg);
> >> +
> >> +	return true;
> >> +}
> >> +
> >> +static bool access_gic_sre(struct kvm_vcpu *vcpu,
> >> +			   const struct coproc_params *p,
> >> +			   const struct coproc_reg *r)
> >> +{
> >> +	if (p->is_write)
> >> +		return ignore_write(vcpu, p);
> >> +
> >> +	*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
> >> +
> >> +	return true;
> >> +}
> >> +
> >>  /*
> >>   * We could trap ID_DFR0 and tell the guest we don't support performance
> >>   * monitoring.  Unfortunately the patch to make the kernel check ID_DFR0 was
> >> @@ -361,10 +391,16 @@ static const struct coproc_reg cp15_regs[] = {
> >>  	{ CRn(10), CRm( 3), Op1( 0), Op2( 1), is32,
> >>  			access_vm_reg, reset_unknown, c10_AMAIR1},
> >>  
> >> +	/* ICC_SGI1R */
> >> +	{ CRm64(12), Op1( 0), is64, access_gic_sgi},
> >> +
> >>  	/* VBAR: swapped by interrupt.S. */
> >>  	{ CRn(12), CRm( 0), Op1( 0), Op2( 0), is32,
> >>  			NULL, reset_val, c12_VBAR, 0x00000000 },
> >>  
> >> +	/* ICC_SRE */
> >> +	{ CRn(12), CRm(12), Op1( 0), Op2(5), is32, access_gic_sre },
> >> +
> >>  	/* CONTEXTIDR/TPIDRURW/TPIDRURO/TPIDRPRW: swapped by interrupt.S. */
> >>  	{ CRn(13), CRm( 0), Op1( 0), Op2( 1), is32,
> >>  			access_vm_reg, reset_val, c13_CID, 0x00000000 },
> >> -- 
> >> 1.7.9.5
> >>
> > 
> > Otherwise this looks correct.
> 
> Thanks
> Vladimir
> 
> > 
> > Thanks,
> > -Christoffer
> > 
> > 
> 
