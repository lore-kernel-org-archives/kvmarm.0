Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A4B3D75DB
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 10:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778495590; cv=none; b=KP3QGSx0p5RNfXhbXKUHxmCXMrDad7ux6HAsqCJ/igcSVzHhaNSWToOzqnoNut7d3WPgtEZLA4Eem1u3CByehkFlC9Ubza+Ha/Ic06Sn4awtnqFNSM47wGAmB1TLs+pZ7DtGytZcAmUJYJLzp4mxYp/xfzcpPqgR9Wspn5EiLi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778495590; c=relaxed/simple;
	bh=1zz4iLlSqYaMCJbIXCtz3FcQ975CxkzT/YCCW/dIHjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpNJh9ObKZDnGdGLHsnl6q7MJ2YX7RKSHZ5tgBUteBpFRJJdQutbizTxF3gIOslruZYHrTK+eVv/1osLbZgEoWz+KlexTV6+5a5rMOHEqlMjPMmaSjmo2/8yvjwiT6itASAYVGnZ015Q4wDBipAPtKi9Yc24E6l8zMDI2a5BFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O7ITqkFu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O7ITqkFu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD44816F2;
	Mon, 11 May 2026 03:33:02 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F6913F7B4;
	Mon, 11 May 2026 03:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778495588; bh=1zz4iLlSqYaMCJbIXCtz3FcQ975CxkzT/YCCW/dIHjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O7ITqkFurFuZ39Lwji9sC3GZKl/uLGBGRadYsCOz6TCBeQ6JyE4TxYQl3HPrOy1Ok
	 tmz2tGrWARYyWqYgV/BXEhy6202SV/JSuCbRjSPq4XXYhqqVi6OmRZKIWlmmJoXqwH
	 cLsH18Zz4yGDg1Kaj/BYZPQRnSB5j7UOpJCVAAeo=
Date: Mon, 11 May 2026 11:32:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 04/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Message-ID: <agGwWE2hcj9O4EGu@J2N7QTR9R3.cambridge.arm.com>
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
> all CPUs in the system, implement similar checks to those for SVE. 

So far so good.

> Since unlike SVE there are no specific vector lengths that are
> architecturally required the handling is subtly different, we report a
> system where this happens with a maximum vector length of
> SME_VQ_INVALID.

I think something went wrong during copyediting here.

A system where *what* happens?

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

Does using (SME_VQ_MAX + 1) for this make something easier than if we
used 0?

My thinking is that 0 will be easier/clearer overall, since we can write
checks of the form:

	if (!info->max_virtualisable_vl) {
		/* SME is not virtualisable */
	}

... or:

	if (some_vl <= max_virtualisable_vl) {
		/* Check properties of a virtualisable VL */
	}

... and there's less scope for error.

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

I don't think this is right.

This test tells us that all VLs implemented by boot CPUs are
virtualisable. That set of VLs doesn't necessarily include the
architectural maximum VL.

IIUC that's not a problem for KVM, since KVM enforces that a guest's
maximum VL is an implemented VL. However, this is a problem for
vec_verify_vq_map().

Consider the case where all boot CPUs support only 128-bit, but later we
try to online a CPU that supports 128-bit and 256-bit. That CPU will be
rejected by vec_verify_vq_map().

Note that this isn't broken for SVE today as sve_setup() follows this up
with:

	if (info->max_virtualisable_vl > info->max_vl)
		info->max_virtualisable_vl = info->max_vl;

... but that won't be sufficient for streaming mode VLs given there's no
guarantee that smaller streaming VLs are implemented.

> +	else if (b == SVE_VQ_MAX - 1)
> +		/* No virtualisable VLs */
> +		info->max_virtualisable_vl = sve_vl_from_vq(SME_VQ_INVALID);

Similarly, I think this is broken for vec_verify_vq_map(). Consider a
case with two boot CPUs, where one boot CPU only supports 128-bit, and
the other boot cpu only supports 256-bit. If either CPU is hotplugged
out and then back in, it will be rejected by vec_verify_vq_map().

We don't have a similar problem for SVE since that's not architecturally
possible.

> +	else
> +		info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b +  1));

This looks suspicious.

At this point we know that 'b' represents the smallest VL which is
partially supported. The next bit is almost never a power of two, is not
guaranteed to be an implemented VL, and is not guaranteed to be larger
than an implemented VL.

Imagine you have two CPUs:

* CPU x supports 128-bit.
* CPU y supports 128-bit and 512-bit.

The algorithm above will find 512-bit as the smallest partically
supported VL. For that, VQ==4 and b==12.

If max_virtualisable_vl is chosen as b+1, then that's b==13 and VQ==3,
which corresponds to a (not architecturally supported) 384-bit VL, which
is bigger than the architecturally-valid 256 bit VL that neither CPU
supports.

As with the other cases above, that's broken for vec_verify_vq_map(),
but I think KVM will gracefully handle this.

To solve all of the above, I think what we actually want to do is find
the largest uniformly implemented VL which is smaller than the smallest
partially implemented VL.

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

If we used 0 instead of (SME_VQ_MAX + 1), this would just be:

	if (info->max_virtualisable_vl < info->max_vl)
		pr_warn(...);

As above, I think using 0 would be preferable.

Mark.

>  }
>  
>  void sme_suspend_exit(void)
> 
> -- 
> 2.47.3
> 
