From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Wed, 21 Feb 2018 11:12:33 +0000
Message-ID: <20180221111233.gylb6v4yxqnn6gyj@localhost>
References: <1519095546-24420-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1519095546-24420-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Thomas Speier <tspeier@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Philip Elcan <pelcan@codeaurora.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 19, 2018 at 08:59:06PM -0600, Shanker Donthineni wrote:
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index f55fe5b..4061210 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1095,6 +1095,27 @@ config ARM64_RAS_EXTN
>  	  and access the new registers if the system supports the extension.
>  	  Platform RAS features may additionally depend on firmware support.
>  
> +config ARM64_CACHE_IDC
> +	bool "Enable support for DCache clean PoU optimization"
> +	default y
> +	help
> +	  The data cache clean to the point of unification is not required
> +	  for instruction to be data coherence if CTR_EL0.IDC has value 1.
> +
> +	  Selecting this feature will allow the kernel to optimize the POU
> +	  cache maintaince operations where it requires 'DC CVAU'.
> +
> +config ARM64_CACHE_DIC
> +	bool "Enable support for ICache invalidation PoU optimization"
> +	default y
> +	help
> +	  Instruction cache invalidation to the point of unification is not
> +	  required for instruction to be data coherence if CTR_EL0.DIC has
> +	  value 1.
> +
> +	  Selecting this feature will allow the kernel to optimize the POU
> +	  cache maintaince operations where it requires 'IC IVAU'.

A single Kconfig entry is sufficient for both features.

> @@ -864,6 +864,22 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
>  					ID_AA64PFR0_FP_SHIFT) < 0;
>  }
>  
> +#ifdef CONFIG_ARM64_CACHE_IDC
> +static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	return !!(read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_IDC_SHIFT));
> +}
> +#endif
> +
> +#ifdef CONFIG_ARM64_CACHE_DIC
> +static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	return !!(read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_DIC_SHIFT));
> +}
> +#endif

Nitpick: no need for !! since the function type is bool already.

> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index 758bde7..7d37d71 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -50,6 +50,9 @@ ENTRY(flush_icache_range)
>   */
>  ENTRY(__flush_cache_user_range)
>  	uaccess_ttbr0_enable x2, x3, x4
> +alternative_if ARM64_HAS_CACHE_IDC
> +	b	8f
> +alternative_else_nop_endif
>  	dcache_line_size x2, x3
>  	sub	x3, x2, #1
>  	bic	x4, x0, x3
> @@ -60,6 +63,11 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
>  	b.lo	1b
>  	dsb	ish
>  
> +8:
> +alternative_if ARM64_HAS_CACHE_DIC
> +	mov	x0, #0
> +	b	1f
> +alternative_else_nop_endif
>	invalidate_icache_by_line x0, x1, x2, x3, 9f
>	mov	x0, #0
>  1:

You can add another label at mov x0, #0 below this hunk and keep a
single instruction in the alternative path.

However, my worry is that in an implementation with DIC set, we also
skip the DSB/ISB sequence in the invalidate_icache_by_line macro. For
example, in an implementation with transparent PoU, we could have:

	str	<some instr>, [addr]
	// no cache maintenance or barrier
	br	<addr>

Is an ISB required between the instruction store and execution? I would
say yes but maybe Will has a better opinion here.

-- 
Catalin
