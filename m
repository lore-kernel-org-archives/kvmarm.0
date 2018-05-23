From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCHv4 06/10] arm64: add basic pointer authentication support
Date: Wed, 23 May 2018 09:42:56 +0100
Message-ID: <114d65a8-ffa5-7061-864a-a32aa3baa5c5@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
 <20180503132031.25705-7-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503132031.25705-7-mark.rutland@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,


On 03/05/18 14:20, Mark Rutland wrote:
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey. The kernel maintains an APIAKey value
> for each process (shared by all threads within), which is initialised to
> a random value at exec() time.
> 
> To describe that address authentication instructions are available, the
> ID_AA64ISAR0.{APA,API} fields are exposed to userspace. A new hwcap,
> APIA, is added to describe that the kernel manages APIAKey.
> 
> Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
> and will behave as NOPs. These may be made use of in future patches.
> 
> No support is added for the generic key (APGAKey), though this cannot be
> trapped or made to behave as a NOP. Its presence is not advertised with
> a hwcap.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>


> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> new file mode 100644
> index 000000000000..034877ee28bc
> --- /dev/null
> +++ b/arch/arm64/include/asm/pointer_auth.h

...

> +
> +#define __ptrauth_key_install(k, v)			\
> +do {							\
> +	write_sysreg_s(v.lo, SYS_ ## k ## KEYLO_EL1);	\
> +	write_sysreg_s(v.hi, SYS_ ## k ## KEYHI_EL1);	\
> +} while (0)

I think it might be safer to have parentheses around v, to prevent
something like __ptrauth_key_install(APIA, *key_val) work fine.

> diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
> index 17c65c8f33cb..01f02ac500ae 100644
> --- a/arch/arm64/include/uapi/asm/hwcap.h
> +++ b/arch/arm64/include/uapi/asm/hwcap.h
> @@ -48,5 +48,6 @@
>   #define HWCAP_USCAT		(1 << 25)
>   #define HWCAP_ILRCPC		(1 << 26)
>   #define HWCAP_FLAGM		(1 << 27)
> +#define HWCAP_APIA		(1 << 28)
>   
>   #endif /* _UAPI__ASM_HWCAP_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 01b1a7e7d70f..f418d4cb6691 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1030,6 +1030,11 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
>   #endif
...

> +#ifdef CONFIG_ARM64_PNTR_AUTH
> +	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_APA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
> +#endif

Did you mean CONFIG_ARM64_PTR_AUTH here ?

Cheers

Suzuki
