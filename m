From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 1/7] arm64: cpufeature: Detect CPU RAS Extentions
Date: Tue, 22 Aug 2017 08:54:35 +0100
Message-ID: <20170822085435.00005ca0@huawei.com>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
 <1503065517-7920-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503065517-7920-2-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 18 Aug 2017 22:11:51 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> From: Xie XiuQi <xiexiuqi@huawei.com>
> 
> ARM's v8.2 Extentions add support for Reliability, Availability and
> Serviceability (RAS). On CPUs with these extensions system software

extensions, system software

> can use additional barriers to isolate errors and determine if faults
> are pending.
> 
> Add cpufeature detection and a barrier in the context-switch code.
> There is no need to use alternatives for this as CPUs that don't
> support this feature will treat the instruction as a nop.
> 
> Platform level RAS support may require additional firmware support.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> [Rebased, added esb and config option, reworded commit message]
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/Kconfig               | 16 ++++++++++++++++
>  arch/arm64/include/asm/barrier.h |  1 +
>  arch/arm64/include/asm/cpucaps.h |  3 ++-
>  arch/arm64/include/asm/sysreg.h  |  2 ++
>  arch/arm64/kernel/cpufeature.c   | 13 +++++++++++++
>  arch/arm64/kernel/process.c      |  3 +++
>  6 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index dfd908630631..4d87aa963d83 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -960,6 +960,22 @@ config ARM64_UAO
>  	  regular load/store instructions if the cpu does not implement the
>  	  feature.
>  
> +config ARM64_RAS_EXTN
> +	bool "Enable support for RAS CPU Extensions"
> +	default y
> +	help
> +	  CPUs that support the Reliability, Availability and Serviceability
> +	  (RAS) Extensions, part of ARMv8.2 are able to track faults and
> +	  errors, classify them and report them to software.
> +
> +	  On CPUs with these extensions system software can use additional
> +	  barriers to determine if faults are pending and read the
> +	  classification from a new set of registers.
> +
> +	  Selecting this feature will allow the kernel to use these barriers
> +	  and access the new registers if the system supports the extension.
> +	  Platform RAS features may additionally depend on firmware support.
> +
>  endmenu
>  
>  config ARM64_MODULE_CMODEL_LARGE
> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
> index 0fe7e43b7fbc..8b0a0eb67625 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -30,6 +30,7 @@
>  #define isb()		asm volatile("isb" : : : "memory")
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
> +#define esb()		asm volatile("hint #16"  : : : "memory")
>  
>  #define mb()		dsb(sy)
>  #define rmb()		dsb(ld)
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 8d2272c6822c..f93bf77f1f74 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -39,7 +39,8 @@
>  #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
>  #define ARM64_WORKAROUND_858921			19
>  #define ARM64_WORKAROUND_CAVIUM_30115		20
> +#define ARM64_HAS_RAS_EXTN			21
>  
> -#define ARM64_NCAPS				21
> +#define ARM64_NCAPS				22
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 248339e4aaf5..35b786b43ee4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -331,6 +331,7 @@
>  #define ID_AA64ISAR1_JSCVT_SHIFT	12
>  
>  /* id_aa64pfr0 */
> +#define ID_AA64PFR0_RAS_SHIFT		28
>  #define ID_AA64PFR0_GIC_SHIFT		24
>  #define ID_AA64PFR0_ASIMD_SHIFT		20
>  #define ID_AA64PFR0_FP_SHIFT		16
> @@ -339,6 +340,7 @@
>  #define ID_AA64PFR0_EL1_SHIFT		4
>  #define ID_AA64PFR0_EL0_SHIFT		0
>  
> +#define ID_AA64PFR0_RAS_V1		0x1
>  #define ID_AA64PFR0_FP_NI		0xf
>  #define ID_AA64PFR0_FP_SUPPORTED	0x0
>  #define ID_AA64PFR0_ASIMD_NI		0xf
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9f9e0064c8c1..a807ab55ee10 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -124,6 +124,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
>  };
>  
>  static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_RAS_SHIFT, 4, 0),
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
>  	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
>  	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
> @@ -888,6 +889,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.min_field_value = 0,
>  		.matches = has_no_fpsimd,
>  	},
> +#ifdef CONFIG_ARM64_RAS_EXTN
> +	{
> +		.desc = "RAS Extension Support",
> +		.capability = ARM64_HAS_RAS_EXTN,
> +		.def_scope = SCOPE_SYSTEM,
> +		.matches = has_cpuid_feature,
> +		.sys_reg = SYS_ID_AA64PFR0_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64PFR0_RAS_SHIFT,
> +		.min_field_value = ID_AA64PFR0_RAS_V1,
> +	},
> +#endif /* CONFIG_ARM64_RAS_EXTN */
>  	{},
>  };
>  
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 659ae8094ed5..2def5ce75867 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -363,6 +363,9 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>  	 */
>  	dsb(ish);
>  
> +	/* Deliver any pending SError from prev */
> +	esb();
> +
>  	/* the actual thread switch */
>  	last = cpu_switch_to(prev, next);
>  
