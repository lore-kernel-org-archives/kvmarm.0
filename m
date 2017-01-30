From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: cacheinfo: add support for alternative
 format of CCSIDR_EL1
Date: Mon, 30 Jan 2017 16:47:26 +0000
Message-ID: <ad552a58-4acd-f2ab-7d40-124b40c6c014@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE61240A1C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:47:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qltr8cOcN4KL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 11:47:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 880E440190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:47:12 -0500 (EST)
In-Reply-To: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 16:25, Sudeep Holla wrote:
> The number of sets described for each cache level in the CCSIDR is
> limited to 32K and the associativity is limited to 1024 ways.
>
> As part of the ARM8.3 extensions, an alternative format for the
> CCSIDR_EL1 is introduced for AArch64, and for AArch32, a new CCSIDR2
> register is introduced to hold the upper 32 bits of this information,
> and the CCSIDR register format is changed. An identification registers
> are also added to identify the presence for this functionality.
>
> This patch adds support for the alternative format of CCSIDR_EL1.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/include/asm/cachetype.h  | 58 +++++++++++++++++++++++--------------
>  arch/arm64/include/asm/cpufeature.h |  9 ++++++
>  arch/arm64/include/asm/sysreg.h     |  1 +
>  arch/arm64/kernel/cacheinfo.c       | 26 ++++++++++++-----
>  arch/arm64/kernel/cpufeature.c      |  1 +
>  5 files changed, 67 insertions(+), 28 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cachetype.h b/arch/arm64/include/asm/cachetype.h
> index f5588692f1d4..180b3288aa3f 100644
> --- a/arch/arm64/include/asm/cachetype.h
> +++ b/arch/arm64/include/asm/cachetype.h
> @@ -40,9 +40,17 @@
>  extern unsigned long __icache_flags;
>
>  /*
> - * NumSets, bits[27:13] - (Number of sets in cache) - 1
> - * Associativity, bits[12:3] - (Associativity of cache) - 1
> - * LineSize, bits[2:0] - (Log2(Number of words in cache line)) - 2
> + * +---------------+---------+---------+------------------------------+
> + * | Property      |   v1    |    v2   | Calculation                  |
> + * +---------------+---------+---------+------------------------------+
> + * | Attributes    | [31:28] |    NA   |                              |
> + * +---------------+---------+---------+------------------------------+
> + * | NumSets       | [27:13] | [55:32] | Number of sets in cache - 1  |
> + * +---------------+---------+---------+------------------------------+
> + * | Associativity | [12: 3] | [23: 3] | Associativity of cache - 1   |
> + * +---------------+---------+---------+------------------------------+
> + * | LineSize      | [ 2: 0] | [ 2: 0] | Log2(Words in cache line) - 2|
> + * +---------------+---------+---------+------------------------------+
>   */
>  #define CCSIDR_EL1_WRITE_THROUGH	BIT(31)
>  #define CCSIDR_EL1_WRITE_BACK		BIT(30)
> @@ -50,19 +58,32 @@ extern unsigned long __icache_flags;
>  #define CCSIDR_EL1_WRITE_ALLOCATE	BIT(28)
>  #define CCSIDR_EL1_LINESIZE_MASK	0x7
>  #define CCSIDR_EL1_LINESIZE(x)		((x) & CCSIDR_EL1_LINESIZE_MASK)
> -#define CCSIDR_EL1_ASSOCIATIVITY_SHIFT	3
> -#define CCSIDR_EL1_ASSOCIATIVITY_MASK	0x3ff
> -#define CCSIDR_EL1_ASSOCIATIVITY(x)	\
> -	(((x) >> CCSIDR_EL1_ASSOCIATIVITY_SHIFT) & CCSIDR_EL1_ASSOCIATIVITY_MASK)
> -#define CCSIDR_EL1_NUMSETS_SHIFT	13
> -#define CCSIDR_EL1_NUMSETS_MASK		0x7fff
> -#define CCSIDR_EL1_NUMSETS(x) \
> -	(((x) >> CCSIDR_EL1_NUMSETS_SHIFT) & CCSIDR_EL1_NUMSETS_MASK)
> -
> -#define CACHE_LINESIZE(x)	(16 << CCSIDR_EL1_LINESIZE(x))
> -#define CACHE_NUMSETS(x)	(CCSIDR_EL1_NUMSETS(x) + 1)
> -#define CACHE_ASSOCIATIVITY(x)	(CCSIDR_EL1_ASSOCIATIVITY(x) + 1)
> -
> +#define CCSIDR_EL1_V1_ASSOCIATIVITY_SHIFT	3
> +#define CCSIDR_EL1_V1_ASSOCIATIVITY_MASK	0x3ff
> +#define CCSIDR_EL1_V2_ASSOCIATIVITY_SHIFT	3
> +#define CCSIDR_EL1_V2_ASSOCIATIVITY_MASK	0x1fffff
> +#define CCSIDR_EL1_V1_NUMSETS_SHIFT		13
> +#define CCSIDR_EL1_V1_NUMSETS_MASK		0x7fff
> +#define CCSIDR_EL1_V2_NUMSETS_SHIFT		32
> +#define CCSIDR_EL1_V2_NUMSETS_MASK		0xffffff
> +
> +#define CCSIDR_EL1_V1_ATTRIBUTE_MASK		0xf0000000
> +#define CCSIDR_EL1_V2_ATTRIBUTE_MASK		0x0	/* Not supported */
> +#define CCSIDR_EL1_ATTRIBUTES(v, x)	((x) & CCSIDR_EL1_V##v##_ATTRIBUTE_MASK)
> +#define CCSIDR_EL1_ASSOCIATIVITY(v, x) \
> +	(((x) >> CCSIDR_EL1_V##v##_ASSOCIATIVITY_SHIFT) & CCSIDR_EL1_V##v##_ASSOCIATIVITY_MASK)
> +#define CCSIDR_EL1_NUMSETS(v, x) \
> +	(((x) >> CCSIDR_EL1_V##v##_NUMSETS_SHIFT) & CCSIDR_EL1_V##v##_NUMSETS_MASK)
> +
> +#define CACHE_LINESIZE(x)		(16 << CCSIDR_EL1_LINESIZE(x))
> +#define CACHE_NUMSETS_V1(x)		(CCSIDR_EL1_NUMSETS(1, x) + 1)
> +#define CACHE_ASSOCIATIVITY_V1(x)	(CCSIDR_EL1_ASSOCIATIVITY(1, x) + 1)
> +#define CACHE_ATTRIBUTES_V1(x)		(CCSIDR_EL1_ATTRIBUTES(1, x))
> +#define CACHE_NUMSETS_V2(x)		(CCSIDR_EL1_NUMSETS(2, x) + 1)
> +#define CACHE_ASSOCIATIVITY_V2(x)	(CCSIDR_EL1_ASSOCIATIVITY(2, x) + 1)
> +#define CACHE_ATTRIBUTES_V2(x)		(CCSIDR_EL1_ATTRIBUTES(2, x))
> +
> +extern int icache_get_numsets(void);
>  extern u64 __attribute_const__ cache_get_ccsidr(u64 csselr);
>
>  /* Helpers for Level 1 Instruction cache csselr = 1L */
> @@ -71,11 +92,6 @@ static inline int icache_get_linesize(void)
>  	return CACHE_LINESIZE(cache_get_ccsidr(1L));
>  }
>
> -static inline int icache_get_numsets(void)
> -{
> -	return CACHE_NUMSETS(cache_get_ccsidr(1L));
> -}
> -
>  /*
>   * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
>   * permitted in the I-cache.
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index b4989df48670..076a22ade503 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -185,6 +185,11 @@ static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
>  	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
>  }
>
> +static inline bool id_aa64mmfr2_ccsidr_64b_format(u64 mmfr2)
> +{
> +	return cpuid_feature_extract_unsigned_field(mmfr2, ID_AA64MMFR2_CCIDX_SHIFT) == 0x1;
> +}
> +
>  void __init setup_cpu_features(void);
>
>  void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
> @@ -224,6 +229,10 @@ static inline bool system_uses_ttbr0_pan(void)
>  		!cpus_have_cap(ARM64_HAS_PAN);
>  }
>
> +static inline bool cpu_supports_ccsidr_64b_format(void)
> +{
> +	return id_aa64mmfr2_ccsidr_64b_format(read_system_reg(SYS_ID_AA64MMFR2_EL1));

read_system_reg() gives you the system wide safe value for the register, which could
be different from that of the current CPU. You have to use read_sysreg_s(), to read
a register on the CPU (which aren't yet recognized by GAS).

Sorry, the names are a bit confusing, which can easily cause such issues. May be we should
rename some of them.

> +}
>  #endif /* __ASSEMBLY__ */
>
>  #endif
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 98ae03f8eedd..c72dfe8807ca 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -183,6 +183,7 @@
>  #define ID_AA64MMFR1_VMIDBITS_16	2
>
>  /* id_aa64mmfr2 */
> +#define ID_AA64MMFR2_CCIDX_SHIFT	20
>  #define ID_AA64MMFR2_LVA_SHIFT		16
>  #define ID_AA64MMFR2_IESB_SHIFT		12
>  #define ID_AA64MMFR2_LSM_SHIFT		8
> diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
> index 3f2250fc391b..888b38f1709f 100644
> --- a/arch/arm64/kernel/cacheinfo.c
> +++ b/arch/arm64/kernel/cacheinfo.c
> @@ -43,6 +43,13 @@ static inline enum cache_type get_cache_type(int level)
>  	return CLIDR_CTYPE(clidr, level);
>  }
>
> +int icache_get_numsets(void)

Could this be static ? I could not see it used anywhere else outside this file.

Suzuki
