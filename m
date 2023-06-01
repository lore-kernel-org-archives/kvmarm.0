Received: from out-52.mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6005539B
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 07:32:46 +0000 (UTC)
Date: Thu, 1 Jun 2023 07:32:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685604764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uPY17dV5CAXzTnODjmRi5LAFgEH+A7orbrD/mEtbrII=;
	b=niAfa2hzGp6/9yevLwa+LGmlh5GUkxdOpvczkmQcaR/P9E93AWmCmI2Rv5vXdHKSXYCM9u
	Wp++Su6gGAItUJ3rhinMBcqkGb+RF2ggHzEIz9YIyqq6QB9kkNcNFk3hedqw9+c2zOITax
	zrSSkMTOApkSmORjkIdxiW7DOqRtikU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 05/17] arm64: Don't enable VHE for the kernel if
 OVERRIDE_HVHE is set
Message-ID: <ZHhJmJU/m//uTI9n@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143348.4072074-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 26, 2023 at 03:33:36PM +0100, Marc Zyngier wrote:
> If the OVERRIDE_HVHE SW override is set (as a precursor of
> the KVM_HVHE capability), do not enable VHE for the kernel
> and drop to EL1 as if VHE was either disabled or unavailable.
> 
> Further changes will enable VHE at EL2 only, with the kernel
> still running at EL1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 9439240c3fcf..5c71e1019545 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
>  	tbnz	x1, #0, 1f
>  
>  	// Needs to be VHE capable, obviously
> -	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
> +	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
> +
> +0:	// Check whether we only want the hypervisor to run VHE, not the kernel
> +	adr_l	x1, arm64_sw_feature_override
> +	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
> +	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
> +	and	x2, x2, x1

nit: is applying the mask even necessary? I get it in the context of an
overlay on top of an ID register, but the software features are more of
a synthetic ID register in their own right.

Same nit applies to the kaslr case as well.

> +	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
> +	cbz	x2, 2f
>  
>  1:	mov_q	x0, HVC_STUB_ERR
>  	eret
> -- 
> 2.34.1
> 

-- 
Thanks,
Oliver
