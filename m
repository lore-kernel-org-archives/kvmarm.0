From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 7/7] arm64: kvm: handle SEI notification and inject
 virtual SError
Date: Tue, 22 Aug 2017 08:57:42 +0100
Message-ID: <20170822085742.0000732b@huawei.com>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
 <1503065517-7920-8-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1503065517-7920-8-git-send-email-gengdongjiu@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 18 Aug 2017 22:11:57 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> After receive SError, KVM firstly call memory failure to
> deal with the Error. If memory failure wants user space to
> handle it, it will notify user space. This patch adds support
> to userspace that injects virtual SError with specified
> syndrome. This syndrome value will be set to the VSESR_EL2.
> VSESR_EL2 is a new RAS extensions register which provides the
> syndrome value reported to software on taking a virtual SError
> interrupt exception.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Quanming Wu <wuquanming@huawei.com>

Content seems fine, some real nitpicks inline.

> ---
>  arch/arm/include/asm/kvm_host.h      |  2 ++
>  arch/arm/kvm/guest.c                 |  5 +++++
>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
>  arch/arm64/include/asm/kvm_host.h    |  2 ++
>  arch/arm64/include/asm/sysreg.h      |  3 +++
>  arch/arm64/include/asm/system_misc.h |  1 +
>  arch/arm64/kvm/guest.c               | 13 +++++++++++++
>  arch/arm64/kvm/handle_exit.c         | 21 +++++++++++++++++++--
>  arch/arm64/kvm/hyp/switch.c          | 14 ++++++++++++++
>  include/uapi/linux/kvm.h             |  2 ++
>  virt/kvm/arm/arm.c                   |  7 +++++++
>  11 files changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 127e2dd2e21c..bdb6ea690257 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -244,6 +244,8 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
>  int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		int exception_index);
>  
> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
> +
>  static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
>  				       unsigned long hyp_stack_ptr,
>  				       unsigned long vector_ptr)
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 1e0784ebbfd6..c23df72d9bec 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -248,6 +248,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  

Perhaps a comment here on why the stub doesn't do anything?
Obvious in the context of this patch, but perhaps not when someone is looking
at this out of context.

> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
> +{
> +	return 0;
> +}
> +
>  int __attribute_const__ kvm_target_cpu(void)
>  {
>  	switch (read_cpuid_part()) {
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 47983db27de2..74213bd539dc 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -155,6 +155,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
>  	return vcpu->arch.fault.esr_el2;
>  }
>  
> +static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.fault.vsesr_el2;
> +}
> +
> +static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
> +{
> +	vcpu->arch.fault.vsesr_el2 = val;
> +}
> +
>  static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>  {
>  	u32 esr = kvm_vcpu_get_hsr(vcpu);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d68630007b14..57b011261597 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -88,6 +88,7 @@ struct kvm_vcpu_fault_info {
>  	u32 esr_el2;		/* Hyp Syndrom Register */
>  	u64 far_el2;		/* Hyp Fault Address Register */
>  	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
> +	u32 vsesr_el2;		/* Virtual SError Exception Syndrome Register */
>  };
>  
>  /*
> @@ -381,6 +382,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
>  
>  static inline void __cpu_init_stage2(void)
>  {
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 35b786b43ee4..06059eef0f5d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -86,6 +86,9 @@
>  #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
>  #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
>  
> +/* virtual SError exception syndrome register in armv8.2 */
> +#define REG_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
> +
>  #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
>  				      (!!x)<<8 | 0x1f)
>  #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> index 07aa8e3c5630..7d07aeb02bc4 100644
> --- a/arch/arm64/include/asm/system_misc.h
> +++ b/arch/arm64/include/asm/system_misc.h
> @@ -57,6 +57,7 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>  })
>  
>  int handle_guest_sea(phys_addr_t addr, unsigned int esr);
> +int handle_guest_sei(phys_addr_t addr, unsigned int esr);
>  
>  #endif	/* __ASSEMBLY__ */
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cb383c310f18..3cbe91e76c0e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -312,6 +312,19 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  
> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
> +{
> +	u64 reg = *syndrome;
> +
> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
> +		/* set vsesr_el2[24:0] with value that user space specified */
> +		kvm_vcpu_set_vsesr(vcpu, reg & ESR_ELx_ISS_MASK);
> +
> +	/* inject virtual system Error or asynchronous abort */
> +	kvm_inject_vabt(vcpu);

Nitpick, but blank line here would make it ever so slightly more readable.

> +	return 0;
> +}
> +
>  int __attribute_const__ kvm_target_cpu(void)
>  {
>  	unsigned long implementor = read_cpuid_implementor();
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 17d8a1677a0b..7ddeff30c7b9 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -28,6 +28,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_psci.h>
> +#include <asm/system_misc.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -178,6 +179,22 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>  	return arm_exit_handlers[hsr_ec];
>  }
>  
> +static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +
> +	if (handle_guest_sei((unsigned long)fault_ipa,
> +			kvm_vcpu_get_hsr(vcpu))) {
> +		kvm_err("Failed to handle guest SEI, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
> +				kvm_vcpu_trap_get_class(vcpu),
> +				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> +				(unsigned long)kvm_vcpu_get_hsr(vcpu));
> +
> +		kvm_inject_vabt(vcpu);
> +	}

Again, ever so slightly more readable with a blank line here.

> +	return 0;
> +}
> +
>  /*
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
>   * proper exit to userspace.
> @@ -201,7 +218,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			*vcpu_pc(vcpu) -= adj;
>  		}
>  
> -		kvm_inject_vabt(vcpu);
> +		kvm_handle_guest_sei(vcpu);
>  		return 1;
>  	}
>  
> @@ -211,7 +228,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	case ARM_EXCEPTION_IRQ:
>  		return 1;
>  	case ARM_EXCEPTION_EL1_SERROR:
> -		kvm_inject_vabt(vcpu);
> +		kvm_handle_guest_sei(vcpu);
>  		return 1;
>  	case ARM_EXCEPTION_TRAP:
>  		/*
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index c6f17c7675ad..a73346141cf3 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -42,6 +42,13 @@ bool __hyp_text __fpsimd_enabled(void)
>  	return __fpsimd_is_enabled()();
>  }
>  
> +static void __hyp_text __sysreg_set_vsesr(struct kvm_vcpu *vcpu)
> +{
> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
> +			(vcpu->arch.hcr_el2 & HCR_VSE))
> +		write_sysreg_s(vcpu->arch.fault.vsesr_el2, REG_VSESR_EL2);
> +}
> +
>  static void __hyp_text __activate_traps_vhe(void)
>  {
>  	u64 val;
> @@ -86,6 +93,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  		isb();
>  	}
>  	write_sysreg(val, hcr_el2);
> +
> +	/*
> +	 * If the virtual SError interrupt is taken to EL1 using AArch64,
> +	 * then VSESR_EL2 provides the syndrome value reported in ESR_EL1.
> +	 */
> +	__sysreg_set_vsesr(vcpu);
> +
>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
>  	/*
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5a2a338cae57..d3fa4c60c9dc 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1356,6 +1356,8 @@ struct kvm_s390_ucas_mapping {
>  /* Available with KVM_CAP_S390_CMMA_MIGRATION */
>  #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
> +#define KVM_ARM_SEI		_IO(KVMIO,   0xb10)
> +
>  
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a39a1e161e63..dbaaf206ace2 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1022,6 +1022,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			return -EFAULT;
>  		return kvm_arm_vcpu_has_attr(vcpu, &attr);
>  	}
> +	case KVM_ARM_SEI: {
> +		u64 syndrome;
> +
> +		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
> +			return -EFAULT;
> +		return kvm_vcpu_ioctl_sei(vcpu, &syndrome);
> +	}
>  	default:
>  		return -EINVAL;
>  	}

