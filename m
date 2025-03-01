Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAD1A5B97;
	Sat,  1 Mar 2025 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740827494; cv=none; b=mwoRAL9/cU9zFA++RpWgOjej8JKIK53lrsq9G62XWweYQvL0ufSSek0jlyK35q2L/DBxhc9ozGTX8iYJ9irBrzhigkI90e9dVezJdB9auOtKouNEBVrImq/lKuRG1HIK7nHPt6gGkC5SX1y6fEWi0IybZa8r3tegQjn0X3+VgHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740827494; c=relaxed/simple;
	bh=Q+8vlTP1yrkRXVX7m0rJxoU5f+w7nVOSau+kxa2PpS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GcN1uFOrUzrHGm3aVxPclL4iLl2D3xiqJmWE/wNwPjhZdFLxVgjKcsif0cvVQ4rCpXl9x/Ka+fFB9GugFeyYYZ5/TCJGYWpV2YwP/APqGpPb77YWDk+z8KJBElc+I3FhRfXgKw02CmAA9e0zGdENwVIIL5h7uzrgrqP9uiJL4Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A370C4CEDD;
	Sat,  1 Mar 2025 11:11:31 +0000 (UTC)
Date: Sat, 1 Mar 2025 11:11:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
Message-ID: <Z8LrYBD7WHjOnJgT@arm.com>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
 <20250301075849.GA28249@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250301075849.GA28249@willie-the-truck>

On Sat, Mar 01, 2025 at 07:58:50AM +0000, Will Deacon wrote:
> On Mon, Feb 03, 2025 at 10:38:21AM +0530, Anshuman Khandual wrote:
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
> > This series is based on v6.14-rc1
> > 
> > Changes in V2:
> > 
> > - Rebased on v6.14-rc1
> > - Updated tools sysreg patches with latest DDI0601 2024-12 definitions
> > - Updated document version as DDI0601 2024-12 in all commit messages
> > - Added latest tags from Rob Herring for the last patch
> 
> I know these have been applied already but, fwiw, patches 1-6 look correct
> when compared against the .xml:
> 
> Acked-by: Will Deacon <will@kernel.org>

Thanks Will.

> I presume Catalin will drop/replace the last patch.

I dropped it already, I'll queue the new one.

-- 
Catalin
