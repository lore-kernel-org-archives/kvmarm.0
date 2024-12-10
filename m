Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A571BC09F;
	Tue, 10 Dec 2024 17:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733850329; cv=none; b=d+v5vmitrQDftvmkyMXBJ15yCi9crxmLbJZtzY+Ws32+UyESwt6TN0E+VmLC2oI983ak3at8wGHanYiO38wcbNS0ndTd/IOFC5wwIeCn8BNiS6CihA+EMnz1fWqJWxVP518orLYpcZ71us+olY4ZGVI856ceeBjSHuwECTnguDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733850329; c=relaxed/simple;
	bh=vaU+OdFiuVkaJ6PMcJ/NEkM/VLKOJSMZuqjDER3Bpz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPMRM+srIf6FctEWH0RfzoL7e/clMUa/yzEl2WLQ7EI9gw3GHvSUzwuTr3aVbL13pb8vhM3f57fMTZ1DXSvQvF+Wqbab66P/E2J1xLyO112uqzMFGv4NdDvn7DJpW2RN+ujYwG/Z8RtuAIzNkpdcNG2LchidqqnTQP3zVVxLfxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VV1f8zSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VV1f8zSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DE7C4CED6;
	Tue, 10 Dec 2024 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733850325;
	bh=vaU+OdFiuVkaJ6PMcJ/NEkM/VLKOJSMZuqjDER3Bpz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VV1f8zSKGEMXCGTCBnMhrA+rQFBCZl5bL/h2jdGK8Wcsir+Y9G9PPmgXu8oxBWvTE
	 x7gXi+DeyVO8im7f+lh908tmy23Fbg4xQBZMDTL/nTJ97O7UCmKq+cHZ5gqhKYvd4b
	 q7g1N0FhbNVhu2h28h503mjPz42ul2my6iEtWOV2XzTn6c3KTZ4gbfYFgYR8F1S50Q
	 p0vzgyBCJixO3f7edsXewIg6IND5ZdYsEhTbfz7gFGRPvZdvz2ABIpxtBgjgx2H/3r
	 PPAQitViGoIsCZi25UrbvCf10WC1Kq1+CaIQGRvGBfG8hkkc6sOAmUephMEjXkvagC
	 DLCikw+OPercg==
Date: Tue, 10 Dec 2024 17:05:20 +0000
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20241210170519.GA16075@willie-the-truck>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <20241028053426.2486633-6-anshuman.khandual@arm.com>
 <20241210164144.GA16039@willie-the-truck>
 <Z1hyueAQJTroNIRW@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1hyueAQJTroNIRW@J2N7QTR9R3>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Dec 10, 2024 at 04:56:25PM +0000, Mark Rutland wrote:
> On Tue, Dec 10, 2024 at 04:41:44PM +0000, Will Deacon wrote:
> > On Mon, Oct 28, 2024 at 11:04:24AM +0530, Anshuman Khandual wrote:
> > > +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
> > > +	ARM64_FTR_END,
> > > +};
> > 
> > I think I mentioned this on an earlier series, but it would be useful to
> > see some justification in the commit message as to why some of these
> > features are considered STRICT vs NONSTRICT and why LOWER_SAFE is
> > preferred over EXACT.
> > 
> > For example, why is EBEP strict whereas other PMU-related fields aren't?
> > Why is the CTX_CMPs field treated differently to the same field in DFR0?
> > 
> > I'm not saying the above table is wrong, it just looks arbitrary without
> > the justification.
> 
> FWIW, Anshuman and I discussed that on the v1 thread, after this v2
> thread was posted. Anshuman promised to provide some rationale and make
> some updates in the next version (i.e. v3):
> 
>   https://lore.kernel.org/linux-arm-kernel/8efe902c-8b9f-494a-b9da-430d8ced32ef@arm.com/

Perfect! I'll wait for the v3, then.

Will
