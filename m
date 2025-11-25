Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28A218596
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092374; cv=none; b=hFbWeQkdm55H/4VZoYCAN6CQhrWVwfSEw5LFPraaIWKJg/pQbB2XF4O+XcFCWJ3+hhy7P1CFOhjAZfcNhxqIf2q1TGvyBc/TV0d3RDoLSXUtj7JLrojFDnAWuJDFqh9F04Ncv8Ljm/rWOBw5e2gCBo3dIj8dcWmDKHFHqq7D/RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092374; c=relaxed/simple;
	bh=Qbox7/Q69vV2ZqoPXL7NY02Ztiyfhv/0qmeL08HQFyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWU5K1ZVVkr7h8fdaaIqLjQXCjNl1ngJoUkbqYk1ABbRWMRd7ZPDAZsvuW6cJRahhWg1+TsUL6eaLIBOsRaKsRhwYJA4xWSIoPID/9JM1CaSSGpczWbjLt6yod65KsabZ2HSh+R5AxVbDVcXiDwSpzJlaYVQQlYraP6X/Htm5vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXL/LD02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXL/LD02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA078C16AAE;
	Tue, 25 Nov 2025 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764092374;
	bh=Qbox7/Q69vV2ZqoPXL7NY02Ztiyfhv/0qmeL08HQFyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kXL/LD02xa/VB0hwKyhXVPW0jQ54Pjn3k1T3x/+AN5ZPEWW14AzO2rQBGgXzs1Ufe
	 yt803w7eyjr7vHPOHLwmEQgG+DANTm7ACcF3IPORKFgWmnmP6oZQcTC0PmO7Z3NG75
	 dl4z3kQ8ALFOn1YnYCA6XpwqTFZJM1v5gh2Cj595OLRxBRljuJbnUMe7oWUfcmpCKb
	 PJwRLa+hsrFkH0vQd9aGG9FsdxFk1wOz1sTccv2x03e++J1UQe4E5Z1Jp0YA6sXPT/
	 m+quhtz/gpdBqYtGUcon6+//RBAyN9Wo1kr8iXcNFFf4uz6bWwdHJn6et4FhEJfH55
	 FDBnd8MGjd6ig==
Date: Tue, 25 Nov 2025 10:39:29 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 04/15] KVM: arm64: Teach ptdump about FEAT_XNX
 permissions
Message-ID: <20251125173929.GA3256322@ax162>
References: <20251124190158.177318-1-oupton@kernel.org>
 <20251124190158.177318-5-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124190158.177318-5-oupton@kernel.org>

Hi Oliver,

On Mon, Nov 24, 2025 at 11:01:46AM -0800, Oliver Upton wrote:
> Although KVM doesn't make direct use of the feature, guest hypervisors
> can use FEAT_XNX which influences the permissions of the shadow stage-2.
> Update ptdump to separately print the privileged and unprivileged
> execute permissions.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/ptdump.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index dc5acfb00af9..bd722383d0e3 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -31,27 +31,46 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>  		.val	= PTE_VALID,
>  		.set	= " ",
>  		.clear	= "F",
> -	}, {
> +	},
> +	{
>  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
>  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
>  		.set	= "R",
>  		.clear	= " ",
> -	}, {
> +	},
> +	{
>  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>  		.set	= "W",
>  		.clear	= " ",
> -	}, {
> +	},
> +	{
>  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> -		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> -		.set	= "NX",
> -		.clear	= "x ",
> -	}, {
> +		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b00),
> +		.set	= "px ux ",
> +	},
> +	{
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> +		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b01),
> +		.set	= "PXNux ",
> +	},
> +	{
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> +		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10),
> +		.set	= "PXNUXN",
> +	},
> +	{
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> +		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b11),
> +		.set	= "px UXN",
> +	},
> +	{
>  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
>  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
>  		.set	= "AF",
>  		.clear	= "  ",
> -	}, {
> +	},
> +	{
>  		.mask	= PMD_TYPE_MASK,
>  		.val	= PMD_TYPE_SECT,
>  		.set	= "BLK",
> -- 
> 2.47.3
> 

This change as commit 81e9fe5c6f25 ("KVM: arm64: Teach ptdump about
FEAT_XNX permissions") in -next does not build for me.

GCC 15.2.0

  In file included from arch/arm64/include/asm/sysreg.h:1155,
                   from arch/arm64/include/asm/memory.h:219,
                   from arch/arm64/include/asm/thread_info.h:17,
                   from include/linux/thread_info.h:60,
                   from arch/arm64/include/asm/preempt.h:5,
                   from include/linux/preempt.h:79,
                   from include/linux/spinlock.h:56,
                   from include/linux/wait.h:9,
                   from include/linux/wait_bit.h:8,
                   from include/linux/fs.h:7,
                   from include/linux/debugfs.h:15,
                   from arch/arm64/kvm/ptdump.c:9:
  include/linux/bitfield.h:114:9: error: braced-group within expression allowed only inside a function
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:49:27: note: in expansion of macro 'FIELD_PREP'
     49 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b00),
        |                           ^~~~~~~~~~
  include/linux/bitfield.h:114:9: error: braced-group within expression allowed only inside a function
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:54:27: note: in expansion of macro 'FIELD_PREP'
     54 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b01),
        |                           ^~~~~~~~~~
  include/linux/bitfield.h:114:9: error: braced-group within expression allowed only inside a function
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:59:27: note: in expansion of macro 'FIELD_PREP'
     59 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10),
        |                           ^~~~~~~~~~
  include/linux/bitfield.h:114:9: error: braced-group within expression allowed only inside a function
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:64:27: note: in expansion of macro 'FIELD_PREP'
     64 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b11),
        |                           ^~~~~~~~~~

clang 21.1.6:

  arch/arm64/kvm/ptdump.c:49:10: error: statement expression not allowed at file scope
     49 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b00),
        |                           ^
  include/linux/bitfield.h:114:2: note: expanded from macro 'FIELD_PREP'
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:54:10: error: statement expression not allowed at file scope
     54 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b01),
        |                           ^
  include/linux/bitfield.h:114:2: note: expanded from macro 'FIELD_PREP'
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:59:10: error: statement expression not allowed at file scope
     59 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10),
        |                           ^
  include/linux/bitfield.h:114:2: note: expanded from macro 'FIELD_PREP'
    114 |         ({                                                              \
        |         ^
  arch/arm64/kvm/ptdump.c:64:10: error: statement expression not allowed at file scope
     64 |                 .val    = FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b11),
        |                           ^
  include/linux/bitfield.h:114:2: note: expanded from macro 'FIELD_PREP'
    114 |         ({                                                              \
        |         ^

Cheers,
Nathan
