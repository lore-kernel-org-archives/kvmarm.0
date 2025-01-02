Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9B612E7E;
	Thu,  2 Jan 2025 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735833845; cv=none; b=l5kwwL3kI0a30VGRJcyzlneHjLI3vfFuLjV8AaaxSPPTmUcz6YvfRsVlVv6bpxL5Xx0UEHRpJk0NxXWWh9WbB5WKXz2EpBWzomAXRua1//1vh7x7PTNwq61FeWm/1SH0Z76Vh63nBYzSAeJA5FPyeOyNnAQTIkAa/kjCaOeDSxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735833845; c=relaxed/simple;
	bh=xwig0kXXTHkd3gdQwpBR4SSkQ+n/TFnuZZXhFs5e0+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOKOvpzb69x4rozQMZZcbB9SMLCqfjB4zLtR+cjfI0mSdMvE3838572soDYheCqhu1SDWGCAMWVo54ukZtVoQob3Bs6AFS0C4hyyynnq2rl3t/JrNQyLoEo88tzIdWP/+1VBcOodjPwaOTCz+1jULWRXmcTpswWz+zJORl3NdpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOVXCxUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOVXCxUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD2C4CED0;
	Thu,  2 Jan 2025 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735833845;
	bh=xwig0kXXTHkd3gdQwpBR4SSkQ+n/TFnuZZXhFs5e0+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOVXCxUyMHGJzaL9r9qX4oZNqTL2oLMAXt2KYg5hsFBaFG381U8IkfKCpBm66ERyy
	 lFqQ/CvMKK9hpJlgC2ksQhSYDKvCbgjBXaf1cNdlNOWVmO5wUpuxnggkLEkiv+NErb
	 n5nV1uJiQPQAPm18mWtuD/Tl3gBVlCx5wkd3kh1T9yVSIh6RQRDVXBU7wFJg91WDYP
	 jOoCiA3rd6iw7j4jGQRW7j6IdZYBbwDCF63D/WX5xioGF/XL5LRryAme83I5ghz6WB
	 Lo35stosQ+u5FiYOvhZ8IhMJWATCusH5Md/cl5/mYsTVamBpaijcclLhE5/Mnsp/vo
	 /SX/6r/7vQcww==
Date: Thu, 2 Jan 2025 10:04:02 -0600
From: Rob Herring <robh@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Message-ID: <20250102160402.GB3990035-robh@kernel.org>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241220072240.1003352-1-anshuman.khandual@arm.com>

On Fri, Dec 20, 2024 at 12:52:33PM +0530, Anshuman Khandual wrote:
> This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> being used in the kernel. This is required to prevent their EL1 access trap
> into EL2.
> 
> PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> for now as it does not get accessed in the kernel, and there is no plan for
> its access from user space.
> 
> I have taken the liberty to pick up all the review tags for patches related
> to tools sysreg update from the KVM FGT2 V2 patch series posted earlier.
> 
> https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
> 
> Rob had earler mentioned about FEAT_FGT2 based trap control requirement for
> FEAT_PMUv3p9 registers that are currently being used in kernel. The context
> can be found here.
> 
> https://lore.kernel.org/all/20241216234251.GA629562-robh@kernel.org/
> 
> This series is based on v6.13-rc3
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <robh@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: kvmarm@lists.linux.dev
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> 
> Anshuman Khandual (7):
>   arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
>   arm64/sysreg: Add register fields for HDFGRTR2_EL2
>   arm64/sysreg: Add register fields for HDFGWTR2_EL2
>   arm64/sysreg: Add register fields for HFGITR2_EL2
>   arm64/sysreg: Add register fields for HFGRTR2_EL2
>   arm64/sysreg: Add register fields for HFGWTR2_EL2
>   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9

In case it is not clear, this series should be applied to 6.13 as the 2 
PMUv3p9 features already landed in 6.13 (per counter EL0 control) and 
6.12 (ICNTR). 

Rob
