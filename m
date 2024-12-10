Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8512309B9
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849793; cv=none; b=piuLBPZiiR6QgoQ5v3DgSBb2TPkdhvFrERtRKxBJtKG51GkKohZkI0u8Cd/mffVsUKpGq1UFwn0V2BpJpHHvZJnzGooo7Z60u9flvxLdTYGbQoxyOQdMLQd+fLqi8Of7HgIzwSG9NoAfpijgnFiNirOX9X9XOafmvKNZ8NcDxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849793; c=relaxed/simple;
	bh=nf893GV9pe9ICJS5zpYSXpY52UVhEnchtBK7YZAzJ+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4F/rg0pilTPAaK7BVhLmkPp9m6yUPleKQwkht89NCIuSZx9e/MSNEq4gbaY+YIr0eE2JzkYCaNNDBqVwon0VwU7kPLJ81F9Vs1TrZuXueUp5p0jjViGDqxBnv4NCBRWq4fvIn4oXo5w0KzFJmxdRZ/eep4I0s9UN/yK+UZPqOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A69091007;
	Tue, 10 Dec 2024 08:56:58 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 917773F58B;
	Tue, 10 Dec 2024 08:56:28 -0800 (PST)
Date: Tue, 10 Dec 2024 16:56:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH V2 5/7] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
Message-ID: <Z1hyueAQJTroNIRW@J2N7QTR9R3>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <20241028053426.2486633-6-anshuman.khandual@arm.com>
 <20241210164144.GA16039@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210164144.GA16039@willie-the-truck>

On Tue, Dec 10, 2024 at 04:41:44PM +0000, Will Deacon wrote:
> On Mon, Oct 28, 2024 at 11:04:24AM +0530, Anshuman Khandual wrote:
> > +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
> > +	ARM64_FTR_END,
> > +};
> 
> I think I mentioned this on an earlier series, but it would be useful to
> see some justification in the commit message as to why some of these
> features are considered STRICT vs NONSTRICT and why LOWER_SAFE is
> preferred over EXACT.
> 
> For example, why is EBEP strict whereas other PMU-related fields aren't?
> Why is the CTX_CMPs field treated differently to the same field in DFR0?
> 
> I'm not saying the above table is wrong, it just looks arbitrary without
> the justification.

FWIW, Anshuman and I discussed that on the v1 thread, after this v2
thread was posted. Anshuman promised to provide some rationale and make
some updates in the next version (i.e. v3):

  https://lore.kernel.org/linux-arm-kernel/8efe902c-8b9f-494a-b9da-430d8ced32ef@arm.com/

Mark.
