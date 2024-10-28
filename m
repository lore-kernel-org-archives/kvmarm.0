Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E70B4C83
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 12:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730118917; cv=none; b=pYxlbgcdTWb/mNHaGX9UJvfUCeYJZb8H4Jt9juxIXMS0uEINFffGzkJanFFejCUHTShlkc52doXd0nIyEMNUYCar/8QPDEtTYmHv5K24GeP7LmzQ/4kD4bKvDP3OK3ySW93hZJEmlCMeY3o656wgxKUgr2ZWQRLQMHdlAdJQxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730118917; c=relaxed/simple;
	bh=r0C/cPFTpdcZy9uuWyhxTqt65EuGV5PQhBjhiGln6Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aj09R8nO9C5KL/cU/IB0umiZviEaoZzn2Fk+lDMwbpdRpu1k3JjfuH8u3vcUIjXjhdK0ON5Qs6c/ngA9lHYn+YyilOhOjkWfiwmQWHdk+KuMuzQfaR0lw6uHnpWY6dLHFjJgr0QOocDCr6RzF8NvyaqHXXU3hY4cViNjxm9OUPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29BE5497;
	Mon, 28 Oct 2024 05:35:45 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E2FB3F73B;
	Mon, 28 Oct 2024 05:35:13 -0700 (PDT)
Date: Mon, 28 Oct 2024 12:35:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <Zx-E_8SFV74s6xN8@J2N7QTR9R3>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-3-anshuman.khandual@arm.com>
 <ZxfOeqyb3RvsdYbU@J2N7QTR9R3>
 <72700154-cbf4-4a0a-b6e2-6f0709dec0ce@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72700154-cbf4-4a0a-b6e2-6f0709dec0ce@arm.com>

On Wed, Oct 23, 2024 at 11:42:37AM +0530, Anshuman Khandual wrote:
> 
> 
> On 10/22/24 21:40, Mark Rutland wrote:
> > On Tue, Oct 01, 2024 at 10:06:01AM +0530, Anshuman Khandual wrote:
> >> Fine grained trap control for MDSELR_EL1 register needs to be configured in
> >> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
> >> is also present. This adds a new helper __init_el2_fgt2() initializing this
> >> new FEAT_FGT2 based fine grained registers.
> >>
> >> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
> >> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
> >> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
> >>
> >> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.
> > 
> > [...]
> > 
> >> +  For CPUs with FEAT_Debugv8p9 extension present:
> >> +
> >> +  - If the kernel is entered at EL1 and EL2 is present:
> >> +
> >> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> >> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> >> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
> >> +
> >> +  - If EL3 is present:
> >> +
> >> +    - MDCR_EL3.TDA (bit 9) must be initialized to 0b0
> > 
> > AFAICT we need TDA==0 this regardless of FEAT_Debugv8p9 (and e.g. we need
> 
> That's because MDCR_EL3.TDA=0, enables access to many other debug registers
> beside FEAT_Debugv8p9, which are currently used and hence this MDCR_EL3.TDA
> =0 requirement is a not a new one but rather a missing one instead ?

Yes, that's why I said we need it regardless; it's an existing
requirement that wasn't documented.

> 
> > MDCR_EL3.TPM==0 where FEAT_PMUv3 is implemented), so we should probably
> > check if there's anything else we haven't yet documented in MDCR_EL3.
> 
> Will scan through MDCR_EL3 register and match it with existing documentation
> i.e Documentation/arch/arm64/booting.rst. If there are some missing MDCR_EL3
> fields which should be mentioned, will add them via a separate pre-requisite
> patch ?

Yes please.

Mark.
