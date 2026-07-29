Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB92E1459FA;
	Wed, 29 Jul 2026 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318667; cv=none; b=Nomaeg7VU3Op7o8GZqXduNMBC3TNisM3KKsLDfD2nbIcvIC1GVNkdCSmjxzOvEZLGCGF8H9WjEcoM99lTrklTKBvcW5AtJXupdDAyWF9s4LBmAyR2AIw9/d5UwLQpwnlx+LjVPCVivFSqcNAOnMUSvrTiOuV3Xb+R4SCCMP/KIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318667; c=relaxed/simple;
	bh=xhCfsCTnrpZ7cm3Cc7vEYpyzc7P6px6L3efdTJ2scgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHpxbxUdXyhQLh9sLtdxQu/ni7bCILKTkxyb5KsIwDJSDbqCNGiE2Ma/Zxa9dI0sIcrjT9PPnqnyC2v3uvp0uSkaImLxggLs43WzgGei28Oj+kNSk3qlKeBikJ4H94d1C8t6Pte7/nSg7L5NMriG25lRMXs3mlZFLPAIH71enfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b/J7xyvs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b/J7xyvs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E253815A1;
	Wed, 29 Jul 2026 02:51:00 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2567E3F86F;
	Wed, 29 Jul 2026 02:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785318664; bh=xhCfsCTnrpZ7cm3Cc7vEYpyzc7P6px6L3efdTJ2scgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b/J7xyvseFDBmIilD46xPWheXnDynfrK63MR/YfHtOt3zDGspKWX0efH0QDwqvPmA
	 YRM4gFfCUKWDx8PwzV8O5tPkkT/EnkxIK0PQTgEwaenvg6Vz269tx4kEPya6cmDoK1
	 45QHI+twKMpFLdI50B7ODUU9bgIHMOULXRrDHZIc=
Date: Wed, 29 Jul 2026 10:50:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Message-ID: <amnNAJC4yHVsZaN8@J2N7QTR9R3.cambridge.arm.com>
References: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>

On Wed, Jul 29, 2026 at 11:28:52AM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
> suffers from a serious cache coherency issue (ERR050104). The upper
> bits, above bit 35, of the ARADDR and ACADDR buses within the Arm A53
> subsystem have been incorrectly connected. This causes some TLBI and IC
> maintenance operations exchanged between the A53 and A72 core clusters
> to be corrupted.
> 
> The workaround requires:
> 
>   - Downgrading targeted TLBI operations to broadcast-all variants.
>     Instead of patching the low-level __TLBI_1 macro (which interferes
>     with the REPEAT_TLBI workaround and causes excessive over-
>     invalidation), redirect high-level TLB flush functions
>     (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
>     __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.
> 
>   - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
>     invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
>     in user_cache_maint_handler with SCTLR_EL1.UCI=0).
> 
>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
>     for guests without the proper devicetree.
> 
>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>     does not support broadcast TLB.
> 
> SoC detection uses devicetree compatible string "fsl,imx8qm" since the
> boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0) are not unique to this
> SoC.
> 
> [1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

[...]

> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
> +		__tlbi(vmalle1is);
> +	} else {
> +		switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
> +		case TLBF_NONE:
> +			__flush_s1_tlb_range_op(vae1is, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		case TLBF_NOWALKCACHE:
> +			__flush_s1_tlb_range_op(vale1is, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		case TLBF_NOBROADCAST:
> +			/* Combination unused */
> +			BUG();
> +			break;
> +		case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
> +			__flush_s1_tlb_range_op(vale1, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		}
>  	}

Are you sure the workaround needs to be applied for the TLBF_NOBROADCAST
cases? The NXP document lists non-broadcast TLBI instructions, but I
strongly suspect that's in error, as those shouldn't result in
transactions over the core's external interfaces.

[...]

> @@ -585,6 +585,12 @@ static void user_cache_maint_handler(unsigned long esr, struct pt_regs *regs)
>  		__user_cache_maint("dc civac", address, ret);
>  		break;
>  	case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:	/* IC IVAU */
> +		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104)) {
> +			/* ERR050104: upgrade IC IVAU to IC IALLUIS */
> +			asm volatile("ic ialluis");
> +			ret = 0;
> +			break;
> +		}
>  		__user_cache_maint("ic ivau", address, ret);
>  		break;

This doesn't address my feedback on v1:

  https://lore.kernel.org/all/ZIHisLL9FXlbuMLJ@FVFF77S0Q05N/

... which I see Sashiko has also spotted.

Please make this:

	 case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:     /* IC IVAU */
	 	__user_cache_maint("ic ivau", address, ret)
		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104) && !ret)
			asm volatile("ic ialluis");
		break;

If there's a reason that doesn't work, please explain that reason.

Mark.
