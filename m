Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F031E3768;
	Tue,  7 Jan 2025 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736252025; cv=none; b=HaBpV+1S27gmFsENSq8c/WZyFDes+eLZIAEpqr3glsLTI8MQJ0Zja0LsMP9xIHQ48ZMiV+Rj8P2HCLfPZ+2RJhTJmomxbEbIuV28AFDdd4wzDcyV54KTsQgyul0YctlDl5wB7lF0WApOlB9hBxdux/sP93q6u7p5/NmPcJmvrjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736252025; c=relaxed/simple;
	bh=Rr8N3nfmbgf1QQlVa1CLDPfJ/ryDS+FZiURDeZGBMVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LO0OOyMim6N5bAlTOgiFnns6nssc/mAxiWrH/zpGo5TKQGT7ZWnX+hLf3McQ6OfENDA/0inNvbLLw9e878SHcqo7sKEEBmQGO5ymptqLBNe0OfrqgbXRpMv/o/0sUf+4otSDl+jjk3qpYpNAGl5+4EuY1AlqJ3EA42Xdp8Y8Sg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6044C4CED6;
	Tue,  7 Jan 2025 12:13:42 +0000 (UTC)
Date: Tue, 7 Jan 2025 12:13:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Message-ID: <Z30adHnQ7ZFaU9UR@arm.com>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102160402.GB3990035-robh@kernel.org>

On Thu, Jan 02, 2025 at 10:04:02AM -0600, Rob Herring wrote:
> On Fri, Dec 20, 2024 at 12:52:33PM +0530, Anshuman Khandual wrote:
> > This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> > registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> > being used in the kernel. This is required to prevent their EL1 access trap
> > into EL2.
> > 
> > PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> > for now as it does not get accessed in the kernel, and there is no plan for
> > its access from user space.
> > 
> > I have taken the liberty to pick up all the review tags for patches related
> > to tools sysreg update from the KVM FGT2 V2 patch series posted earlier.
> > 
> > https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
> > 
> > Rob had earler mentioned about FEAT_FGT2 based trap control requirement for
> > FEAT_PMUv3p9 registers that are currently being used in kernel. The context
> > can be found here.
> > 
> > https://lore.kernel.org/all/20241216234251.GA629562-robh@kernel.org/
> > 
> > This series is based on v6.13-rc3
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Mark Brown <robh@kernel.org>
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: kvmarm@lists.linux.dev
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > 
> > Anshuman Khandual (7):
> >   arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
> >   arm64/sysreg: Add register fields for HDFGRTR2_EL2
> >   arm64/sysreg: Add register fields for HDFGWTR2_EL2
> >   arm64/sysreg: Add register fields for HFGITR2_EL2
> >   arm64/sysreg: Add register fields for HFGRTR2_EL2
> >   arm64/sysreg: Add register fields for HFGWTR2_EL2
> >   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> 
> In case it is not clear, this series should be applied to 6.13 as the 2 
> PMUv3p9 features already landed in 6.13 (per counter EL0 control) and 
> 6.12 (ICNTR). 

So is this a fix that needs backporting to 6.12 or 6.13, e.g. fix for
d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction
counter")? It's pretty late in the cycle to take the series for 6.13.

But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL1 and
than traps it at EL2?

-- 
Catalin
