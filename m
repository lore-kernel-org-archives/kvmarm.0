From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 07/27] arm64/sve: Check SVE virtualisability
Date: Thu, 4 Apr 2019 23:21:04 +0200
Message-ID: <20190404212104.qhtklabh7mzwapje@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6FEE4A41A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 17:21:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p45l5ypxRnle for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 17:21:10 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B38C4A319
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 17:21:10 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553864452-15080-8-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:32PM +0000, Dave Martin wrote:
> Due to the way the effective SVE vector length is controlled and
> trapped at different exception levels, certain mismatches in the
> sets of vector lengths supported by different physical CPUs in the
> system may prevent straightforward virtualisation of SVE at parity
> with the host.
> 
> This patch analyses the extent to which SVE can be virtualised
> safely without interfering with migration of vcpus between physical
> CPUs, and rejects late secondary CPUs that would erode the
> situation further.
> 
> It is left up to KVM to decide what to do with this information.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> 
> ---
> 
> QUESTION: The final structure of this code makes it quite natural to
> clamp the vector length for KVM guests to the maximum value supportable
> across all CPUs; such a value is guaranteed to exist, but may be
> surprisingly small on a given hardware platform.
> 
> Should we be stricter and actually refuse to support KVM at all on such
> hardware?  This may help to force people to fix Linux (or the
> architecture) if/when this issue comes up.

Blocking KVM would be too harsh, since the users of the host may not
care about guests with SVE, but still care about guests.

> 
> For now, I stick with pr_warn() and make do with a limited SVE vector
> length for guests.

I think that's probably the best we can do.

> 
> Changes since v5:
> 
>  * pr_info() about the presence of unvirtualisable vector lengths in
>    sve_setup() upgrade to pr_warn(), for consistency with
>    sve_verify_vq_map().
> ---
>  arch/arm64/include/asm/fpsimd.h |  1 +
>  arch/arm64/kernel/cpufeature.c  |  2 +-
>  arch/arm64/kernel/fpsimd.c      | 86 ++++++++++++++++++++++++++++++++++-------
>  3 files changed, 73 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index dd1ad39..964adc9 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -87,6 +87,7 @@ extern void sve_kernel_enable(const struct arm64_cpu_capabilities *__unused);
>  extern u64 read_zcr_features(void);
>  
>  extern int __ro_after_init sve_max_vl;
> +extern int __ro_after_init sve_max_virtualisable_vl;
>  
>  #ifdef CONFIG_ARM64_SVE
>  
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 4061de1..7f8cc51 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1863,7 +1863,7 @@ static void verify_sve_features(void)
>  	unsigned int len = zcr & ZCR_ELx_LEN_MASK;
>  
>  	if (len < safe_len || sve_verify_vq_map()) {
> -		pr_crit("CPU%d: SVE: required vector length(s) missing\n",
> +		pr_crit("CPU%d: SVE: vector length support mismatch\n",
>  			smp_processor_id());
>  		cpu_die_early();
>  	}
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index f59ea67..b219796a 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/bitmap.h>
> +#include <linux/bitops.h>
>  #include <linux/bottom_half.h>
>  #include <linux/bug.h>
>  #include <linux/cache.h>
> @@ -48,6 +49,7 @@
>  #include <asm/sigcontext.h>
>  #include <asm/sysreg.h>
>  #include <asm/traps.h>
> +#include <asm/virt.h>
>  
>  #define FPEXC_IOF	(1 << 0)
>  #define FPEXC_DZF	(1 << 1)
> @@ -130,14 +132,18 @@ static int sve_default_vl = -1;
>  
>  /* Maximum supported vector length across all CPUs (initially poisoned) */
>  int __ro_after_init sve_max_vl = SVE_VL_MIN;
> +int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
>  /* Set of available vector lengths, as vq_to_bit(vq): */
>  static __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
> +/* Set of vector lengths present on at least one cpu: */
> +static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
>  static void __percpu *efi_sve_state;
>  
>  #else /* ! CONFIG_ARM64_SVE */
>  
>  /* Dummy declaration for code that will be optimised out: */
>  extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
> +extern __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
>  extern void __percpu *efi_sve_state;
>  
>  #endif /* ! CONFIG_ARM64_SVE */
> @@ -623,12 +629,6 @@ int sve_get_current_vl(void)
>  	return sve_prctl_status(0);
>  }
>  
> -/*
> - * Bitmap for temporary storage of the per-CPU set of supported vector lengths
> - * during secondary boot.
> - */
> -static DECLARE_BITMAP(sve_secondary_vq_map, SVE_VQ_MAX);
> -
>  static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
>  {
>  	unsigned int vq, vl;
> @@ -654,6 +654,7 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
>  void __init sve_init_vq_map(void)
>  {
>  	sve_probe_vqs(sve_vq_map);
> +	bitmap_copy(sve_vq_partial_map, sve_vq_map, SVE_VQ_MAX);
>  }
>  
>  /*
> @@ -663,8 +664,11 @@ void __init sve_init_vq_map(void)
>   */
>  void sve_update_vq_map(void)
>  {
> -	sve_probe_vqs(sve_secondary_vq_map);
> -	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +
> +	sve_probe_vqs(tmp_map);
> +	bitmap_and(sve_vq_map, sve_vq_map, tmp_map, SVE_VQ_MAX);
> +	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, tmp_map, SVE_VQ_MAX);
>  }
>  
>  /*
> @@ -673,18 +677,48 @@ void sve_update_vq_map(void)
>   */
>  int sve_verify_vq_map(void)
>  {
> -	int ret = 0;
> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +	unsigned long b;
>  
> -	sve_probe_vqs(sve_secondary_vq_map);
> -	bitmap_andnot(sve_secondary_vq_map, sve_vq_map, sve_secondary_vq_map,
> -		      SVE_VQ_MAX);
> -	if (!bitmap_empty(sve_secondary_vq_map, SVE_VQ_MAX)) {
> +	sve_probe_vqs(tmp_map);
> +
> +	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
> +	if (bitmap_intersects(tmp_map, sve_vq_map, SVE_VQ_MAX)) {
>  		pr_warn("SVE: cpu%d: Required vector length(s) missing\n",
>  			smp_processor_id());
> -		ret = -EINVAL;
> +		return -EINVAL;
>  	}
>  
> -	return ret;
> +	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
> +		return 0;
> +
> +	/*
> +	 * For KVM, it is necessary to ensure that this CPU doesn't
> +	 * support any vector length that guests may have probed as
> +	 * unsupported.
> +	 */
> +
> +	/* Recover the set of supported VQs: */
> +	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
> +	/* Find VQs supported that are not globally supported: */
> +	bitmap_andnot(tmp_map, tmp_map, sve_vq_map, SVE_VQ_MAX);
> +
> +	/* Find the lowest such VQ, if any: */
> +	b = find_last_bit(tmp_map, SVE_VQ_MAX);
> +	if (b >= SVE_VQ_MAX)
> +		return 0; /* no mismatches */
> +
> +	/*
> +	 * Mismatches above sve_max_virtualisable_vl are fine, since
> +	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
> +	 */
> +	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
> +		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
> +			smp_processor_id());
> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }
>  
>  static void __init sve_efi_setup(void)
> @@ -751,6 +785,8 @@ u64 read_zcr_features(void)
>  void __init sve_setup(void)
>  {
>  	u64 zcr;
> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +	unsigned long b;
>  
>  	if (!system_supports_sve())
>  		return;
> @@ -779,11 +815,31 @@ void __init sve_setup(void)
>  	 */
>  	sve_default_vl = find_supported_vector_length(64);
>  
> +	bitmap_andnot(tmp_map, sve_vq_partial_map, sve_vq_map,
> +		      SVE_VQ_MAX);
> +
> +	b = find_last_bit(tmp_map, SVE_VQ_MAX);
> +	if (b >= SVE_VQ_MAX)
> +		/* No non-virtualisable VLs found */
> +		sve_max_virtualisable_vl = SVE_VQ_MAX;
> +	else if (WARN_ON(b == SVE_VQ_MAX - 1))
> +		/* No virtualisable VLs?  This is architecturally forbidden. */
> +		sve_max_virtualisable_vl = SVE_VQ_MIN;
> +	else /* b + 1 < SVE_VQ_MAX */
> +		sve_max_virtualisable_vl = sve_vl_from_vq(bit_to_vq(b + 1));
> +
> +	if (sve_max_virtualisable_vl > sve_max_vl)
> +		sve_max_virtualisable_vl = sve_max_vl;
> +
>  	pr_info("SVE: maximum available vector length %u bytes per vector\n",
>  		sve_max_vl);
>  	pr_info("SVE: default vector length %u bytes per vector\n",
>  		sve_default_vl);
>  
> +	/* KVM decides whether to support mismatched systems. Just warn here: */
> +	if (sve_max_virtualisable_vl < sve_max_vl)
> +		pr_warn("SVE: unvirtualisable vector lengths present\n");
> +
>  	sve_efi_setup();
>  }
>  
> -- 
> 2.1.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
