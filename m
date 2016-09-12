From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 8/8] ARM: KVM: Support vgic-v3
Date: Mon, 12 Sep 2016 10:23:36 +0100
Message-ID: <57D67418.9050704@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-9-git-send-email-vladimir.murzin@arm.com>
 <57D2E746.7080300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 372E740F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:15:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTfzEl2MxP5p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:15:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D339D40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:14:58 -0400 (EDT)
In-Reply-To: <57D2E746.7080300@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 17:45, Marc Zyngier wrote:
> On 08/09/16 17:06, Vladimir Murzin wrote:
>> This patch allows to build and use vgic-v3 in 32-bit mode.
>>

snip...

>> diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
>> index af25c32..f93f6bd 100644
>> --- a/arch/arm/include/asm/arch_gicv3.h
>> +++ b/arch/arm/include/asm/arch_gicv3.h
>> @@ -96,6 +96,70 @@
>>  #define ICH_AP1R2			__AP1Rx(2)
>>  #define ICH_AP1R3			__AP1Rx(3)
>>  
>> +/* A32-to-A64 mappings used by VGIC save/restore */
>> +
>> +#define CPUIF_MAP(a32, a64)			\
>> +static inline void write_ ## a64(u32 val)	\
>> +{						\
>> +	write_sysreg(val, a32);			\
>> +}						\
>> +static inline u32 read_ ## a64(void)		\
>> +{						\
>> +	return read_sysreg(a32); 		\
>> +}						\
>> +
>> +#define CPUIF_MAP_LO_HI(a32lo, a32hi, a64)	\
>> +static inline void write_ ## a64(u64 val)	\
>> +{						\
>> +	write_sysreg((u32)val, a32lo);		\
>> +	write_sysreg((u32)(val >> 32), a32hi);	\
> 
> Please use {lower,upper}_32_bits, which make the casting/shifting go away.
> 

Will do.

>> +}						\
>> +static inline u64 read_ ## a64(void)		\
>> +{						\
>> +	u64 val = read_sysreg(a32lo);		\
>> +						\
>> +	val |=	(u64)read_sysreg(a32hi) << 32;	\
>> +						\
>> +	return val; 				\
>> +}
>> +
>> +CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
>> +CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
>> +CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
>> +CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
>> +CPUIF_MAP(ICH_ELSR, ICH_ELSR_EL2)
>> +CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
>> +CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
>> +CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
>> +CPUIF_MAP(ICH_AP0R1, ICH_AP0R1_EL2)
>> +CPUIF_MAP(ICH_AP0R0, ICH_AP0R0_EL2)
>> +CPUIF_MAP(ICH_AP1R3, ICH_AP1R3_EL2)
>> +CPUIF_MAP(ICH_AP1R2, ICH_AP1R2_EL2)
>> +CPUIF_MAP(ICH_AP1R1, ICH_AP1R1_EL2)
>> +CPUIF_MAP(ICH_AP1R0, ICH_AP1R0_EL2)
>> +CPUIF_MAP(ICC_HSRE, ICC_SRE_EL2)
>> +CPUIF_MAP(ICC_SRE, ICC_SRE_EL1)
>> +
>> +CPUIF_MAP_LO_HI(ICH_LR15, ICH_LRC15, ICH_LR15_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR14, ICH_LRC14, ICH_LR14_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR13, ICH_LRC13, ICH_LR13_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR12, ICH_LRC12, ICH_LR12_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR11, ICH_LRC11, ICH_LR11_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR10, ICH_LRC10, ICH_LR10_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR9, ICH_LRC9, ICH_LR9_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR8, ICH_LRC8, ICH_LR8_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR7, ICH_LRC7, ICH_LR7_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR6, ICH_LRC6, ICH_LR6_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR5, ICH_LRC5, ICH_LR5_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR4, ICH_LRC4, ICH_LR4_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR3, ICH_LRC3, ICH_LR3_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR2, ICH_LRC2, ICH_LR2_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR1, ICH_LRC1, ICH_LR1_EL2)
>> +CPUIF_MAP_LO_HI(ICH_LR0, ICH_LRC0, ICH_LR0_EL2)
>> +
>> +#define read_gicreg(r)                 read_##r()
>> +#define write_gicreg(v, r)             write_##r(v)
>> +
> 
> Can you make this change a separate patch? It will make it easier to
> merge if I can ack it as a standalone change. It will also give the last
> patch a fantastic diffstat... ;-)
> 

Yes, I can ;)

snip...

>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index 1bb2b79..10c0244 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -228,6 +228,36 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
>>  	return true;
>>  }
>>  
>> +static bool access_gic_sgi(struct kvm_vcpu *vcpu,
>> +			   const struct coproc_params *p,
>> +			   const struct coproc_reg *r)
>> +{
>> +	u64 reg;
>> +
>> +	if (!p->is_write)
>> +		return read_from_write_only(vcpu, p);
>> +
>> +	reg = *vcpu_reg(vcpu, p->Rt2);
>> +	reg <<= 32;
> 
> nit: can you write this as
> 
> 	reg = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
> 
> which I find easier to read...
> 

I'll rewrite it.

snip...

>> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
>> index 8dfa5f7..3023bb5 100644
>> --- a/arch/arm/kvm/hyp/Makefile
>> +++ b/arch/arm/kvm/hyp/Makefile
>> @@ -5,6 +5,7 @@
>>  KVM=../../../../virt/kvm
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
>> +obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
>>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
>> index b13caa9..8409dd5 100644
>> --- a/arch/arm/kvm/hyp/switch.c
>> +++ b/arch/arm/kvm/hyp/switch.c
>> @@ -14,6 +14,7 @@

> 
> It otherwise looks good to me.
> 

Thanks for feedback!

Cheers
Vladimir

> Thanks,
> 
> 	M.
> 
