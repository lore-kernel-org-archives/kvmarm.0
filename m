From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 1/8] arm64: KVM: Use static keys for selecting the GIC
 backend
Date: Fri, 9 Sep 2016 10:33:37 +0100
Message-ID: <57D281F1.5000902@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-2-git-send-email-vladimir.murzin@arm.com>
 <57D27EA7.2040500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D56B40BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 05:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72Crvy7xXiME for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 05:25:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9FA240B58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 05:25:08 -0400 (EDT)
In-Reply-To: <57D27EA7.2040500@arm.com>
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

Hi Marc,

On 09/09/16 10:19, Marc Zyngier wrote:
> Hi Vladimir,
> 
...
>>  
>> +extern struct static_key_false kvm_gicv3_cpuif;
> 
> I think we should follow the model set by kvm_vgic_global_state, which
> is declared in arm_vgic.h. Even better, we should *embed* the static key
> in this structure. This will reduce the clutter and we wouldn't have to
> deal with all the section stuff (the hyp_data thing is a good cleanup,
> but I'd like to see it as a separate patch if possible).

Yes, it is what I was thinking about too, but was not sure about which
way to go, so hyp_data seemed me something we might reuse latter.
However, I agree that we can defer hyp_data thing...

> 
>> +
>> +static inline bool kvm_arm_support_gicv3_cpuif(void)
>> +{
>> +	if (IS_ENABLED(CONFIG_ARM_GIC_V3))
>> +		return !!cpuid_feature_extract(CPUID_EXT_PFR1, 28);
>> +	else
>> +		return false;
>> +}
>> +
>>  #endif /* __ARM_KVM_HOST_H__ */
>> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
>> index 6eaff28..bd9434e 100644
>> --- a/arch/arm/include/asm/kvm_hyp.h
>> +++ b/arch/arm/include/asm/kvm_hyp.h
>> @@ -23,8 +23,6 @@
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/vfp.h>
>>  
>> -#define __hyp_text __section(.hyp.text) notrace
>> -
>>  #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
>>  	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
>>  #define __ACCESS_CP15_64(Op1, CRm)		\
>> diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
>> index a2e75b8..e61a809 100644
>> --- a/arch/arm/include/asm/virt.h
>> +++ b/arch/arm/include/asm/virt.h
>> @@ -28,6 +28,9 @@
>>   */
>>  #define BOOT_CPU_MODE_MISMATCH	PSR_N_BIT
>>  
>> +#define __hyp_text __section(.hyp.text) notrace
>> +#define __hyp_data __section(.hyp.data)
>> +
>>  #ifndef __ASSEMBLY__
>>  #include <asm/cacheflush.h>
>>  
>> @@ -87,6 +90,11 @@ extern char __hyp_idmap_text_end[];
>>  /* The section containing the hypervisor text */
>>  extern char __hyp_text_start[];
>>  extern char __hyp_text_end[];
>> +
>> +/* The section containing the hypervisor data */
>> +extern char __hyp_data_start[];
>> +extern char __hyp_data_end[];
>> +
>>  #endif
>>  
>>  #endif /* __ASSEMBLY__ */
>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index d24e5dd..6d53824 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -25,6 +25,11 @@
>>  	*(.hyp.text)							\
>>  	VMLINUX_SYMBOL(__hyp_text_end) = .;
>>  
>> +#define HYPERVISOR_DATA							\
>> +	VMLINUX_SYMBOL(__hyp_data_start) = .;				\
>> +	*(.hyp.data)							\
>> +	VMLINUX_SYMBOL(__hyp_data_end) = .;
>> +
>>  #define IDMAP_TEXT							\
>>  	ALIGN_FUNCTION();						\
>>  	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
>> @@ -256,6 +261,7 @@ SECTIONS
>>  		 */
>>  		DATA_DATA
>>  		CONSTRUCTORS
>> +		HYPERVISOR_DATA
> 
> If you follow my idea of of embedding the static key, we can defer all
> of this to another patch set.

I'm happy with your idea, so I'll drop this hunk.

> 
>>  
>>  		_edata = .;
>>  	}
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 75f130e..f966763 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/mman.h>
>>  #include <linux/sched.h>
>>  #include <linux/kvm.h>
>> +#include <linux/irqchip/arm-gic-v3.h>
>>  #include <trace/events/kvm.h>
>>  #include <kvm/arm_pmu.h>
>>  
>> @@ -68,6 +69,9 @@ static bool vgic_present;
>>  
>>  static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
>>  
>> +/* GIC system register CPU interface */
>> +__hyp_data DEFINE_STATIC_KEY_FALSE(kvm_gicv3_cpuif);
>> +
>>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>>  {
>>  	BUG_ON(preemptible());
>> @@ -1178,6 +1182,14 @@ static int init_common_resources(void)
>>  		return -ENOMEM;
>>  	}
>>  
>> +	if (kvm_arm_support_gicv3_cpuif()) {
> 
> Why do we need to check this? If we identify a GICv3 (as exposed by the
> host GIC driver), let's just use that.

True, will drop this.

> 
>> +		if (!gic_enable_sre())
>> +			kvm_info("GIC CPU interface present but disabled by higher exception level\n");
> 
> Do you really want to try and enable SRE there? It feels wrong, as it
> will already have been enabled by the host driver. Also, we don't
> support having GICv3 in a non-SRE configuration (firmware must expose a
> GICv2 in that case).
> 
>> +
>> +		static_branch_enable(&kvm_gicv3_cpuif);
>> +		kvm_info("GIC system register CPU interface\n");
>> +	}
> 
> Can this whole hunk be moved to the vgic initialization instead?
> 

I'll move it there.

>> +
>>  	return 0;
>>  }
>>  
>> @@ -1297,6 +1309,13 @@ static int init_hyp_mode(void)
>>  		goto out_err;
>>  	}
>>  
>> +	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_start),
>> +				  kvm_ksym_ref(__hyp_data_end), PAGE_HYP);
>> +	if (err) {
>> +		kvm_err("Cannot map hyp data section\n");
>> +		goto out_err;
>> +	}
>> +
>>  	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
>>  				  kvm_ksym_ref(__end_rodata), PAGE_HYP_RO);
>>  	if (err) {
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 3eda975..1da74e8 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -24,6 +24,9 @@
>>  
>>  #include <linux/types.h>
>>  #include <linux/kvm_types.h>
>> +#include <linux/jump_label.h>
>> +
>> +#include <asm/cpufeature.h>
>>  #include <asm/kvm.h>
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_mmio.h>
>> @@ -390,4 +393,16 @@ static inline void __cpu_init_stage2(void)
>>  		  "PARange is %d bits, unsupported configuration!", parange);
>>  }
>>  
>> +extern struct static_key_false kvm_gicv3_cpuif;
>> +
>> +static inline bool kvm_arm_support_gicv3_cpuif(void)
>> +{
>> +	int reg = read_system_reg(SYS_ID_AA64PFR0_EL1);
>> +
>> +	if (IS_ENABLED(CONFIG_ARM_GIC_V3))
>> +		return !!cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_GIC_SHIFT);
>> +
>> +	return false;
>> +}
>> +
>>  #endif /* __ARM64_KVM_HOST_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index cff5105..5c4ac82 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -23,8 +23,6 @@
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/sysreg.h>
>>  
>> -#define __hyp_text __section(.hyp.text) notrace
>> -
>>  #define read_sysreg_elx(r,nvh,vh)					\
>>  	({								\
>>  		u64 reg;						\
>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>> index 1788545..c49426e 100644
>> --- a/arch/arm64/include/asm/virt.h
>> +++ b/arch/arm64/include/asm/virt.h
>> @@ -42,6 +42,9 @@
>>  #define BOOT_CPU_MODE_EL1	(0xe11)
>>  #define BOOT_CPU_MODE_EL2	(0xe12)
>>  
>> +#define __hyp_text __section(.hyp.text) notrace
>> +#define __hyp_data __section(.hyp.data)
>> +
>>  #ifndef __ASSEMBLY__
>>  
>>  #include <asm/ptrace.h>
>> @@ -95,6 +98,10 @@ extern char __hyp_idmap_text_end[];
>>  extern char __hyp_text_start[];
>>  extern char __hyp_text_end[];
>>  
>> +/* The section containing the hypervisor data */
>> +extern char __hyp_data_start[];
>> +extern char __hyp_data_end[];
>> +
>>  #endif /* __ASSEMBLY__ */
>>  
>>  #endif /* ! __ASM__VIRT_H */
>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>> index 659963d..ea94a10 100644
>> --- a/arch/arm64/kernel/vmlinux.lds.S
>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>> @@ -40,6 +40,11 @@ jiffies = jiffies_64;
>>  	*(.hyp.text)					\
>>  	VMLINUX_SYMBOL(__hyp_text_end) = .;
>>  
>> +#define HYPERVISOR_DATA					\
>> +	VMLINUX_SYMBOL(__hyp_data_start) = .;		\
>> +	.hyp.data : {*(.hyp.data)}			\
>> +	VMLINUX_SYMBOL(__hyp_data_end) = .;
>> +
>>  #define IDMAP_TEXT					\
>>  	. = ALIGN(SZ_4K);				\
>>  	VMLINUX_SYMBOL(__idmap_text_start) = .;		\
>> @@ -185,6 +190,7 @@ SECTIONS
>>  	_data = .;
>>  	_sdata = .;
>>  	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
>> +	HYPERVISOR_DATA
>>  	PECOFF_EDATA_PADDING
>>  	_edata = .;
>>  
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 5a84b45..cdc1360 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -126,17 +126,13 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
>>  	write_sysreg(0, vttbr_el2);
>>  }
>>  
>> -static hyp_alternate_select(__vgic_call_save_state,
>> -			    __vgic_v2_save_state, __vgic_v3_save_state,
>> -			    ARM64_HAS_SYSREG_GIC_CPUIF);
>> -
>> -static hyp_alternate_select(__vgic_call_restore_state,
>> -			    __vgic_v2_restore_state, __vgic_v3_restore_state,
>> -			    ARM64_HAS_SYSREG_GIC_CPUIF);
>> -
>>  static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
>>  {
>> -	__vgic_call_save_state()(vcpu);
>> +	if (static_branch_unlikely(&kvm_gicv3_cpuif))
>> +		__vgic_v3_save_state(vcpu);
>> +	else
>> +		__vgic_v2_save_state(vcpu);
>> +
>>  	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
>>  }
>>  
>> @@ -149,7 +145,10 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>>  	val |= vcpu->arch.irq_lines;
>>  	write_sysreg(val, hcr_el2);
>>  
>> -	__vgic_call_restore_state()(vcpu);
>> +	if (static_branch_unlikely(&kvm_gicv3_cpuif))
>> +		__vgic_v3_restore_state(vcpu);
>> +	else
>> +		__vgic_v2_restore_state(vcpu);
>>  }
>>  
>>  static bool __hyp_text __true_value(void)
>>
> 
> Thanks,

Thanks for feedback!

Vladimir

> 
> 	M.
> 
