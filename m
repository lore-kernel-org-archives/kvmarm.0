Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D4C1D5CE0
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730118839; cv=none; b=Xk7r5AAJ2GDJA2UOBhqUI8iUREz2RbiP7Whe1uYqtHOISofxwbd/7N88gYRSMDt62OxqG+smxWbqD7FZqeUT7sjPSEfgJoy4aYkT5R8Tvdp4OrOIi03zfwUtAZpyvlYb0cgQ82ZLk44XImgrw/LerfTAjZ7WgO2fS9ZbXXn6FAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730118839; c=relaxed/simple;
	bh=vfrObvnJXXHQraRw1B1SpIKAxVyhi1xIz9oC0vghcas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgfbNYVL8esq4FlmQZHC56x/zw7Z+xn/T9rOulsOrhYM/A3Me2h24dIxACFJhQ9IQ6wSx7s4ZRUEPmQZty4g50YtJBS19+pIgC3pTenmU2suOghwIVVS8ZmvEyULQnQXjICyZXy1J7S392WjtZYZE9zdwmHLW+B+9w6mYR0YsSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C253E497;
	Mon, 28 Oct 2024 05:34:26 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 421A03F73B;
	Mon, 28 Oct 2024 05:33:55 -0700 (PDT)
Date: Mon, 28 Oct 2024 12:33:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/3] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
Message-ID: <Zx-EqqkQL_FQMRuu@J2N7QTR9R3>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-2-anshuman.khandual@arm.com>
 <ZxfLEqlbGLnK15sf@J2N7QTR9R3>
 <2c51de68-fcca-4457-b8e9-b488d8030738@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c51de68-fcca-4457-b8e9-b488d8030738@arm.com>

On Wed, Oct 23, 2024 at 11:18:12AM +0530, Anshuman Khandual wrote:
> 
> 
> On 10/22/24 21:26, Mark Rutland wrote:
> > On Tue, Oct 01, 2024 at 10:06:00AM +0530, Anshuman Khandual wrote:
> >> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
> >> ftr_raz[] array which is now redundant. These register fields will be used
> >> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
> >> later.

> >> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
> >> +	ARM64_FTR_END,
> >> +};
> >> +
> > 
> > Is there some general principle that has been applied here? e.g. is this
> > STRICT unless we know of variation in practice?
> 
> Yes, that's correct. STRICT unless there is a known variation in practice.

Please mention that somewhere, e.g. in the commit message.

> > e.g. it seems a bit odd that ABLE cannot vary while the number of
> > breakpoints can...
> But all these (ABL_CMPs, CTX_CMPs, WRPs, BRPs) are marked as FTR_NONSTRICT.
> Would not that allow ABL_CMPs to vary as well ?

I asked about ABLE, not ABL_CMPs.

ABL_CMPs is marked as FTR_NONSTRICT, but ABLE is marked as FTR_STRICT.

> Although the existing break-point numbers are currently marked FTR_STRICT,
> should they be changed first ?
> 
> static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
> 	...................
> 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_WRPs_SHIFT, 4, 0),
>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_BRPs_SHIFT, 4, 0),
> 	...................
> }

My point was that the above didn't seem to be logically consistent; I
think you didn't handle ABLE as you should have.

Mark.
