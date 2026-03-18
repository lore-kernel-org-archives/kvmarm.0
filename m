Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF803064AE;
	Wed, 18 Mar 2026 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773854961; cv=none; b=RllqlqDa8N58zR1RABxVBRwxnuzpuBU+FgYUn1Je+6cP6+wyqK1HlyMUhHd3RhTNk57sARVFQ+bxGxPeerBhr1Ym42EUJk1i8GUk4GFKbsuKiKN0CLwR/7ApYmPSjgbB5yAY5SPRsnrtMrR0AdHDTECS4rkKr78IYa/qUxLed7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773854961; c=relaxed/simple;
	bh=OoWBoRjX5YwXNai1Ank9CYLDZQ6fMoAqcKmDftRaaRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KL0D0H3M4PVE3fAQV2Nnn642pHec8XUFJvdj1n6uozK7HafSS4IkBdaQJSLj7sVUl5YixZQyPWpGDkz4dC+GBv+zWGACWOWAqDDpQpa5MDHCQQKJSIwnH/QpArGMf8UEgkBvq+nlneArPJ1gvZ8FgSazhW/EyaUn1XSxvSOCfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlpulkqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlpulkqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDE1C19421;
	Wed, 18 Mar 2026 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773854960;
	bh=OoWBoRjX5YwXNai1Ank9CYLDZQ6fMoAqcKmDftRaaRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dlpulkqYw6bC8ONGLy9by34iYHRu/Y+TJ5MBJvqO6oxkE9/DviOl3VCHswzNZJiXo
	 zbnNpdxWv0LupNNiR7h+8Gk8K3SjXAOLlz/rVcSCZTsVkYZZ1+9lvzoZjnT0583DGQ
	 k1eG6VdvmFin8kn6G3YJFlfPHSw1TuAfdZSNrF8jIWKiq3WNagwo3+mTmEfWPesxbu
	 Hp10+6quf1Sf05zvV7HfWSqarppnlqD32a3X/iObyes9hGSAkc0lcR82cGx/yhpWjQ
	 47ww32nHN9wPGdjPxldIsGojV6DZaduTDaZQ5K/MTTzM4ILhayW0C2aIRTqx8eXfqa
	 47HQZ2YLI8l6w==
Date: Wed, 18 Mar 2026 17:29:33 +0000
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 04/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Message-ID: <20260318172933.GB2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-4-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-4-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:56PM +0000, Mark Brown wrote:
> As with SVE we can only virtualise SME vector lengths that are supported by
> all CPUs in the system, implement similar checks to those for SVE. Since
> unlike SVE there are no specific vector lengths that are architecturally
> required the handling is subtly different, we report a system where this
> happens with a maximum vector length of SME_VQ_INVALID.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h |  2 ++
>  arch/arm64/kernel/fpsimd.c      | 21 ++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index e97729aa3b2f..0cd8a866e844 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -69,6 +69,8 @@ static inline void cpacr_restore(unsigned long cpacr)
>  #define ARCH_SVE_VQ_MAX ((ZCR_ELx_LEN_MASK >> ZCR_ELx_LEN_SHIFT) + 1)
>  #define SME_VQ_MAX	((SMCR_ELx_LEN_MASK >> SMCR_ELx_LEN_SHIFT) + 1)
>  
> +#define SME_VQ_INVALID	(SME_VQ_MAX + 1)
> +
>  struct task_struct;
>  
>  extern void fpsimd_save_state(struct user_fpsimd_state *state);
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 2af0e0c5b9f4..49c050ef6db9 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1218,7 +1218,8 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
>  void __init sme_setup(void)
>  {
>  	struct vl_info *info = &vl_info[ARM64_VEC_SME];
> -	int min_bit, max_bit;
> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +	int min_bit, max_bit, b;
>  
>  	if (!system_supports_sme())
>  		return;
> @@ -1249,12 +1250,30 @@ void __init sme_setup(void)
>  	 */
>  	set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
>  
> +	bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
> +		      SVE_VQ_MAX);
> +
> +	b = find_last_bit(tmp_map, SVE_VQ_MAX);
> +	if (b >= SVE_VQ_MAX)
> +		/* All VLs virtualisable */
> +		info->max_virtualisable_vl = sve_vl_from_vq(ARCH_SVE_VQ_MAX);
> +	else if (b == SVE_VQ_MAX - 1)
> +		/* No virtualisable VLs */
> +		info->max_virtualisable_vl = sve_vl_from_vq(SME_VQ_INVALID);
> +	else
> +		info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b +  1));

nit: "b + 1"

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>

> +
>  	pr_info("SME: minimum available vector length %u bytes per vector\n",
>  		info->min_vl);
>  	pr_info("SME: maximum available vector length %u bytes per vector\n",
>  		info->max_vl);
>  	pr_info("SME: default vector length %u bytes per vector\n",
>  		get_sme_default_vl());
> +
> +	/* KVM decides whether to support mismatched systems. Just warn here: */
> +	if (info->max_virtualisable_vl < info->max_vl ||
> +	    info->max_virtualisable_vl == sve_vl_from_vq(SME_VQ_INVALID))
> +		pr_warn("SME: unvirtualisable vector lengths present\n");
>  }
>  
>  void sme_suspend_exit(void)
> 
> -- 
> 2.47.3
> 
> 
