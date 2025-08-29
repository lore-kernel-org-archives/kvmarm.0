Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB33F3081BB
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 10:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462079; cv=none; b=Ki4+41uwXuxHgZiepQZs7uG2G7gpVYXvvK05f7JrKs+qEl976Bv0aiFtMoxLIQcqDMJb+U/0zRPSXIMJKldEone6/pHw0mQVRXtuj3wS7K4VtObg1diBIut8PjrXp4SiCBXKAP+bW67x/1GIwhumTvDknQ0g2KAADTr/u32/mhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462079; c=relaxed/simple;
	bh=GfXLFsP23ocpkdbfOrhclqjT58FXPr0qTTHtyEKMueE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QiQKLdSWzWnagMOU+nYu8fB6rZWV49cADOxljc5372oF8JBj27f2mKmaCCtydUWWDOHbFbiw8Yk4cLgS72/dGsnylV4I2fA0vE9oplnuvz1AbV/81iyui6B+FYfIYXABPS6TMB8vARuqohTjid9T+Otqbxm7EQmEFsRX5zGAE+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF2A31758;
	Fri, 29 Aug 2025 03:07:48 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C09F23F694;
	Fri, 29 Aug 2025 03:07:53 -0700 (PDT)
Date: Fri, 29 Aug 2025 11:07:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v3 1/3] arm64: sysreg: Fix and tidy up sysreg field
 definitions
Message-ID: <aLF78ux6oTQYKnHr@J2N7QTR9R3>
References: <20250829095143.123476-1-tabba@google.com>
 <20250829095143.123476-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829095143.123476-2-tabba@google.com>

On Fri, Aug 29, 2025 at 10:51:41AM +0100, Fuad Tabba wrote:
> Fix the value of ID_PFR1_EL1.Security NSACR_RFR to be 0b0010, as per
> DDI0601/2025-06, which wasn't correctly set when introduced in commit
> 1224308075f1 ("arm64/sysreg: Convert ID_PFR1_EL1 to automatic generation").
> 
> While at it, remove redundant definitions of CPACR_EL12 and
> RCWSMASK_EL1 and fix some typos.
> 
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> Note that NSACR_RFR isn't used in the kernel as far as I could tell, so
> I didn't add a 'Fixes' tag.

Since this is all cleanup, I think that's fine, but were that necessary,
it would be nicer to have the NSACR_RFR fix separate from the other
cleanups.

FWIW, as this stands:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/tools/sysreg | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 696ab1f32a67..f1a012ee0db6 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -31,7 +31,7 @@
>  # Mapping	<name_EL1>
>  # EndSysreg
>  
> -# Where multiple system regsiters are not VHE aliases but share a
> +# Where multiple system registers are not VHE aliases but share a
>  # common layout, a SysregFields block can be used to describe the
>  # shared layout:
>  
> @@ -54,7 +54,7 @@
>  #
>  # In general it is recommended that new enumeration items be named for the
>  # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
> -# item ACCDATA) though it may be more taseful to do something else.
> +# item ACCDATA) though it may be more tasteful to do something else.
>  
>  Sysreg	OSDTRRX_EL1	2	0	0	0	2
>  Res0	63:32
> @@ -474,7 +474,7 @@ EndEnum
>  Enum	7:4	Security
>  	0b0000	NI
>  	0b0001	EL3
> -	0b0001	NSACR_RFR
> +	0b0010	NSACR_RFR
>  EndEnum
>  UnsignedEnum	3:0	ProgMod
>  	0b0000	NI
> @@ -2528,10 +2528,6 @@ Field	17:16	ZEN
>  Res0	15:0
>  EndSysreg
>  
> -Sysreg	CPACR_EL12      3	5	1	0	2
> -Mapping	CPACR_EL1
> -EndSysreg
> -
>  Sysreg	CPACRALIAS_EL1  3	0	1	4	4
>  Mapping	CPACR_EL1
>  EndSysreg
> @@ -2576,10 +2572,6 @@ Sysreg	PFAR_EL12	3	5	6	0	5
>  Mapping	PFAR_EL1
>  EndSysreg
>  
> -Sysreg	RCWSMASK_EL1	3	0	13	0	3
> -Field	63:0	RCWSMASK
> -EndSysreg
> -
>  Sysreg	SCTLR2_EL1      3	0	1	0	3
>  Res0    63:13
>  Field   12      CPTM0
> -- 
> 2.51.0.338.gd7d06c2dae-goog
> 
> 
