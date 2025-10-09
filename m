Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282DD2AD0D
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 13:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014833; cv=none; b=IKYZLmnFOWifT03PKMR8t81XJSB8Xzo/ebyeHO9ELqfeDWCew8R9nB3T+I2IC+FB+bUuVOs9Vr8bjBGNzR9aFNuTpNNLGKabzJKD9WNNFmHMSsxZMzM3XCoN0e9MyRnTJGv48lL/SjJs/IhEhbuexsYCnSbiSKkDCc7QqgjEKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014833; c=relaxed/simple;
	bh=4BeadEdq46vRlMZAJa6rcoRGrBfWWzjnGnkKDvo9nkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJGmaOQUju/Ykzy4SFQxatGrtLWiLwvjgBtl1SxwbQl60Yg3ZhhY/UOG5N6+qsjsmoR1Pe79H0C4KCtpGMneqkSDWn/i6B+jxriJMFLM+CTBxDadyQi3b69r54gOxOCkp7gzIGnk5kSSY3ksWT8JtbQeVvOnuplkDZhtBNiZBsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EF59176A;
	Thu,  9 Oct 2025 06:00:21 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8E423F59E;
	Thu,  9 Oct 2025 06:00:27 -0700 (PDT)
Date: Thu, 9 Oct 2025 14:00:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Message-ID: <aOex5rmMU5Q-vvss@J2N7QTR9R3>
References: <20251009121239.29370-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009121239.29370-1-maz@kernel.org>

On Thu, Oct 09, 2025 at 01:12:39PM +0100, Marc Zyngier wrote:
> We currently have two ways to identify CPUs that only implement FEAT_VHE
> and not FEAT_E2H0:
> 
> - either they advertise it via ID_AA64MMFR4_EL1.E2H0,
> - or the HCR_EL2.E2H bit is RAO/WI
> 
> However, there is a third category of "cpus" that fall between these
> two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
> an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
> is zero.
> 
> A consequence of this is that on systems such as Neoverse V2, a NV
> guest cannot reliably detect that it is in a VHE-only configuration
> (E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
> best effort to repaint the id register.
> 
> Replace the RAO/WI test by a sequence that makes use of the VHE
> register remnapping between EL1 and EL2 to detect this situation,
> and work out whether we get the VHE behaviour even after having
> set HCR_EL2.E2H to 0.
> 
> This solves the NV problem, and provides a more reliable acid test
> for CPUs that do not completely follow the letter of the architecture
> while providing a RES1 behaviour for HCR_EL2.E2H.
> 
> Suggested-by: Marc Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com
> ---
>  arch/arm64/include/asm/el2_setup.h | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 46033027510cc..b7640e2c20503 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -24,22 +24,40 @@
>  	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
>  	 * can reset into an UNKNOWN state and might not read as 1 until it has
>  	 * been initialized explicitly.
> -	 *
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
> -	 * don't advertise it (they predate this relaxation).
> -	 *
>  	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
>  	 * indicating whether the CPU is running in E2H mode.
>  	 */
>  	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
>  	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
>  	cmp	x1, #0
> -	b.ge	.LnVHE_\@
> +	b.lt	.LnE2H0_\@
>  

> +	/*
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but don't
> +	 * advertise it (they predate this relaxation). Check for an
> +	 * essential VHE property (system register remapping) to decide
> +	 * whether we're effectively VHE-only or not.
> +	 *
> +	 * This is also useful for for NV guests on CPUs that can't trap
> +	 * ID_AA64MMFR4_EL1 as they don't have FEAT_FGT.
> +	 */

Would you be happy to elaborate this comment to:

	/*
	 * Unfortunately, HCR_EL2.E2H can be RES1 even if not advertised
	 * as such via ID_AA64MMFR4_EL1.E2H0:
	 *
	 * - Fruity CPUs predate the !FEAT_E2H0 relaxation, and seem to
	 *   have HCR_EL2.E2H implemented as RAO/WI.
	 *
	 * - On CPUs that lack FEAT_FGT, a hypervisor can't trap guest
	 *   reads of ID_AA64MMFR4_EL1 to advertise !FEAT_E2H0. NV
	 *   guests on these hosts can write to HCR_EL2.E2H without
	 *   trapping to the hypervisor, but these writes have no
	 *   functional effect.
	 *
	 * Handle both cases by checking for an essential VHE property
	 * (system register remapping) to decide whether we're
	 * effectively VHE-only or not.
	 */

Other than that, this all looks good to me:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> +	msr_hcr_el2 x0		// Setup HCR_EL2 as nVHE
> +	isb
> +	mov	x1, #1		// Write something to FAR_EL1
> +	msr	far_el1, x1
> +	isb
> +	mov	x1, #2		// Try to overwrite it via FAR_EL2
> +	msr	far_el2, x1
> +	isb
> +	mrs	x1, far_el1	// If we see the latest write in FAR_EL1,
> +	cmp	x1, #2		// we can safely assume we are VHE only.
> +	b.ne	.LnVHE_\@	// Otherwise, we know that nVHE works.
> +
> +.LnE2H0_\@:
>  	orr	x0, x0, #HCR_E2H
> -.LnVHE_\@:
>  	msr_hcr_el2 x0
>  	isb
> +.LnVHE_\@:
>  .endm
>  
>  .macro __init_el2_sctlr
> -- 
> 2.47.3
> 
> 
