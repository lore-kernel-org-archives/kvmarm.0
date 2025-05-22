Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5909D4594A
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747930514; cv=none; b=leUn1qh8Cf+jOwwayjRAgkcG+xQGSyVBg7w41tkTOvHoE3ucCDAJYPkspPVgnKs933/xMykYXkGz6HltlXSFDlMMWig8EV8SPvMfce4EVx8ZQXTV7inT+GcBCHlPPYFAcF2OGJsTPBeX/PTKPOT7Muug3ztsUoy2DkeHJqgpAyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747930514; c=relaxed/simple;
	bh=B86oQzXDGwPGfXAvGevtUP+BpvzTXxAlz1S8MFh34Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4O0+sVXLayAAnXQym913ogFHPeUuwnSuJdivn0OqCrtoTLKcifHawioCzcs/8bmF/y68kprIuyZ2k1r8fcNxLnKIwq+Whi9kaDU5W/gU9yB6Ge2ZxNz1zpmGUt3f6+A8AXDLWVkIv6Wyo/Gktr6j6nnWzKrQQ4hFvagN9sdQwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 312CA1A2D;
	Thu, 22 May 2025 09:14:56 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9E8D3F5A1;
	Thu, 22 May 2025 09:15:07 -0700 (PDT)
Date: Thu, 22 May 2025 17:15:02 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v22 2/5] arm64: el2_setup.h: Make __init_el2_fgt labels
 consistent, again
Message-ID: <aC9NhvYzajduVm7y@e133380.arm.com>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>

On Tue, May 20, 2025 at 05:27:37PM -0500, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> Commit 5b39db6037e7 ("arm64: el2_setup.h: Rename some labels to be more
> diff-friendly") reworked the labels in __init_el2_fgt to say what's
> skipped rather than what the target location is. The exception was
> "set_fgt_" which is where registers are written. In reviewing the BRBE
> additions, Will suggested "set_debug_fgt_" where HDFGxTR_EL2 are
> written. Doing that would partially revert commit 5b39db6037e7 undoing
> the goal of minimizing additions here, but it would follow the
> convention for labels where registers are written.
> 
> So let's do both. Branches that skip something go to a "skip" label and
> places that set registers have a "set" label. This results in some
> double labels, but it makes things entirely consistent.
> 
> While we're here, the SME skip label was incorrectly named, so fix it.
> 
> Reported-by: Will Deacon <will@kernel.org>
> Cc: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> This one can be applied even if the rest of the series is not.
> 
> v22:
>  - New patch
> ---
>  arch/arm64/include/asm/el2_setup.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index ebceaae3c749..30f57b0334a3 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -204,19 +204,21 @@
>  	orr	x0, x0, #(1 << 62)
>  
>  .Lskip_spe_fgt_\@:
> +
> +.Lset_debug_fgt_\@:

Dangling label?  There doesn't seem to be any branch to it in this
series, unless I've missed something.

[...]

Cheers
---Dave
