Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FCA1E51E2;
	Tue, 18 Feb 2025 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739905598; cv=none; b=BEYeKGvTWnnfsQimpEBlAOBd4oSrfhkrnE6evy6g3EdQjvl5P6rq7q9JRVdOn1hNglYCCula6hQd/Zc/ebQOOhN8PQgq6wpxbohtoeHuaf4YqtjRvlFu2Za7cKDq1Dyctgx5aj/OyjFWMZCyoGv7nN2c1Vej4Y9dRDJPvXiImtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739905598; c=relaxed/simple;
	bh=qB7LjZjgc6S0n6KRFzoDp+AoaWa0KYgVL3/gchYovO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgMkLvGI7B3pBPO0erD1QetIkcHYn/6QcNXwFX14Ueg3J0Ul85ohdEcEEL9K7pQwdNjtdn2k2Qc3Vygy97nRlj0p803OGXODJAKjLgy9gv99AkB+7m00pwaJn0RHQYginV1g+t8pPWHq/JH20uFHcWnHBSSlkxsZRsFx2cJk43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90369C4CEE2;
	Tue, 18 Feb 2025 19:06:35 +0000 (UTC)
Date: Tue, 18 Feb 2025 19:06:33 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH V2 0/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
Message-ID: <Z7TaOUcjP0kME5ly@arm.com>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
 <173990541533.375660.5963781767181928314.b4-ty@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173990541533.375660.5963781767181928314.b4-ty@arm.com>

On Tue, Feb 18, 2025 at 07:03:49PM +0000, Catalin Marinas wrote:
> On Mon, 03 Feb 2025 10:38:21 +0530, Anshuman Khandual wrote:
> > This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> > registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> > being used in the kernel. This is required to prevent their EL1 access trap
> > into EL2.
> > 
> > PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> > for now as it does not get accessed in the kernel, and there is no plan for
> > its access from user space.
> > 
> > [...]
> 
> Applied to arm64 (for-next/el2-enable-feat-pmuv3p9), thanks!
> 
> [7/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
>       https://git.kernel.org/arm64/c/f134bbc054ae

"b4 ty" ignored the other patches. I applied the sysreg ones to the
arm64 for-next/sysreg branch in case they need to get pulled into other
trees (e.g. KVM). The above patch is on top of the other sysreg patches.

-- 
Catalin
