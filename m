From: Amit Kachhap <amit.kachhap@arm.com>
Subject: Re: [RFC 15/17] arm64: enable ptrauth earlier
Date: Sat, 6 Oct 2018 18:21:01 +0530
Message-ID: <fdf0373e-064d-f46a-fa76-9cd9b75d724b@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-16-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-16-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/05/2018 02:17 PM, Kristina Martsenko wrote:
> When the kernel is compiled with pointer auth instructions, the boot CPU
> needs to start using pointer auth very early, so change the cpucap to
> account for this.
> 
> A function that enables pointer auth cannot return, so inline such
> functions or compile them without pointer auth.
> 
> Do not use the cpu_enable callback, to avoid compiling the whole
> callchain down to cpu_enable without pointer auth.
> 
> Note the change in behavior: if the boot CPU has pointer auth and a late
> CPU does not, we panic. Until now we would have just disabled pointer
> auth in this case.
> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> ---
>   arch/arm64/include/asm/cpufeature.h   |  9 +++++++++
>   arch/arm64/include/asm/pointer_auth.h | 18 ++++++++++++++++++
>   arch/arm64/kernel/cpufeature.c        | 14 ++++----------
>   arch/arm64/kernel/smp.c               |  7 ++++++-
>   4 files changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 1717ba1db35d..af4ca92a5fa9 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -292,6 +292,15 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
>    */
>   #define ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE ARM64_CPUCAP_SCOPE_BOOT_CPU
>   
> +/*
> + * CPU feature used early in the boot based on the boot CPU. It is safe for a
> + * late CPU to have this feature even though the boot CPU hasn't enabled it,
> + * although the feature will not be used by Linux in this case. If the boot CPU
> + * has enabled this feature already, then every late CPU must have it.
> + */
> +#define ARM64_CPUCAP_BOOT_CPU_FEATURE			\
> +	 (ARM64_CPUCAP_SCOPE_BOOT_CPU | ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU)
> +
>   struct arm64_cpu_capabilities {
>   	const char *desc;
>   	u16 capability;
> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> index e60f225d9fa2..0634f06c3af2 100644
> --- a/arch/arm64/include/asm/pointer_auth.h
> +++ b/arch/arm64/include/asm/pointer_auth.h
> @@ -11,6 +11,13 @@
>   
>   #ifdef CONFIG_ARM64_PTR_AUTH
>   /*
> + * Compile the function without pointer authentication instructions. This
> + * allows pointer authentication to be enabled/disabled within the function
> + * (but leaves the function unprotected by pointer authentication).
> + */
> +#define __no_ptrauth	__attribute__((target("sign-return-address=none")))
> +
> +/*
>    * Each key is a 128-bit quantity which is split across a pair of 64-bit
>    * registers (Lo and Hi).
>    */
> @@ -51,6 +58,15 @@ static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
>   	__ptrauth_key_install(APIA, keys->apia);
>   }
>   
> +static __always_inline void ptrauth_cpu_enable(void)
> +{
> +	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
> +		return;
> +
> +	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ENIA);
> +	isb();
> +}
> +
>   /*
>    * The EL0 pointer bits used by a pointer authentication code.
>    * This is dependent on TBI0 being enabled, or bits 63:56 would also apply.
> @@ -71,8 +87,10 @@ static inline unsigned long ptrauth_strip_insn_pac(unsigned long ptr)
>   	ptrauth_keys_init(&(tsk)->thread_info.keys_user)
>   
>   #else /* CONFIG_ARM64_PTR_AUTH */
> +#define __no_ptrauth
>   #define ptrauth_strip_insn_pac(lr)	(lr)
>   #define ptrauth_task_init_user(tsk)
> +#define ptrauth_cpu_enable(tsk)
>   #endif /* CONFIG_ARM64_PTR_AUTH */
>   
>   #endif /* __ASM_POINTER_AUTH_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 3157685aa56a..380ee01145e8 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1040,15 +1040,10 @@ static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
>   }
>   
>   #ifdef CONFIG_ARM64_PTR_AUTH
> -static void cpu_enable_address_auth(struct arm64_cpu_capabilities const *cap)
> -{
> -	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ENIA);
> -}
> -
>   static bool has_address_auth(const struct arm64_cpu_capabilities *entry,
>   			     int __unused)
>   {
> -	u64 isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
> +	u64 isar1 = read_sysreg(id_aa64isar1_el1);
>   	bool api, apa;
>   
>   	apa = cpuid_feature_extract_unsigned_field(isar1,
> @@ -1251,7 +1246,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   	{
>   		.desc = "Address authentication (architected algorithm)",
>   		.capability = ARM64_HAS_ADDRESS_AUTH_ARCH,
> -		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
>   		.sys_reg = SYS_ID_AA64ISAR1_EL1,
>   		.sign = FTR_UNSIGNED,
>   		.field_pos = ID_AA64ISAR1_APA_SHIFT,
> @@ -1261,7 +1256,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   	{
>   		.desc = "Address authentication (IMP DEF algorithm)",
>   		.capability = ARM64_HAS_ADDRESS_AUTH_IMP_DEF,
> -		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
>   		.sys_reg = SYS_ID_AA64ISAR1_EL1,
>   		.sign = FTR_UNSIGNED,
>   		.field_pos = ID_AA64ISAR1_API_SHIFT,
> @@ -1270,9 +1265,8 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   	},
>   	{
>   		.capability = ARM64_HAS_ADDRESS_AUTH,
> -		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
>   		.matches = has_address_auth,
> -		.cpu_enable = cpu_enable_address_auth,
>   	},
>   #endif /* CONFIG_ARM64_PTR_AUTH */
>   	{},
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 25fcd22a4bb2..09690024dce8 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -53,6 +53,7 @@
>   #include <asm/numa.h>
>   #include <asm/pgtable.h>
>   #include <asm/pgalloc.h>
> +#include <asm/pointer_auth.h>
>   #include <asm/processor.h>
>   #include <asm/smp_plat.h>
>   #include <asm/sections.h>
> @@ -211,6 +212,8 @@ asmlinkage notrace void secondary_start_kernel(void)
This function secondary_start_kernel attribute can be set to 
__no_ptrauth for better redability as below, although no functionality 
is broken as this function does not return.
>   	 */
>   	check_local_cpu_capabilities();
>   
> +	ptrauth_cpu_enable();
There are some function calls before so wondering if pointer 
authentication and cpu capabilities check required by ptrauth can be 
moved still up.
> +
>   	if (cpu_ops[cpu]->cpu_postboot)
>   		cpu_ops[cpu]->cpu_postboot();
>   
> @@ -405,7 +408,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
>   	mark_linear_text_alias_ro();
>   }
>   
> -void __init smp_prepare_boot_cpu(void)
> +void __init __no_ptrauth smp_prepare_boot_cpu(void)
>   {
>   	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
>   	/*
> @@ -414,6 +417,8 @@ void __init smp_prepare_boot_cpu(void)
>   	 */
>   	jump_label_init();
>   	cpuinfo_store_boot_cpu();
> +
> +	ptrauth_cpu_enable();
>   }
>   
>   static u64 __init of_get_cpu_mpidr(struct device_node *dn)
> 
