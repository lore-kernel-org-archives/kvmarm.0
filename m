Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CEE2C08B2;
	Thu, 18 Sep 2025 12:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758197293; cv=none; b=AoT2KRNSw2+3+DdEfHT7l1u8lCIRNZ6Q28MsJo5OiX72bJP7qrzEbSjsraqicMHEgOmoR2jw+RTjTEZjJhp3Tgrtd135C3kB8r6CeOqbUqkh3leP7+emWTcz7RQFLk1Y/BSLbmglk6EbQIPq0NHIcXXn2HIuiRBmxHtpeQiOAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758197293; c=relaxed/simple;
	bh=PbmNRrE13pJ1wWoztpIKlTco1UBVTpVaWVXoqFvxRj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXJgztgTM0hJ76AxvdKAMVIDAXa+qK+rBnZWgBvZ8xwI3loAG6dqYmVk5H9Q31RaBmuksxbwRjRGMGpaULf2K+B7daESH2BmAaRrf1tLIfZy+9IJwEe/NZGLXGcSw3pNRcNgbdby6KNwuo48MZP7Bx+g8pR3OJvJh+aO0frVLVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqVnMIZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqVnMIZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03D1C4CEE7;
	Thu, 18 Sep 2025 12:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758197292;
	bh=PbmNRrE13pJ1wWoztpIKlTco1UBVTpVaWVXoqFvxRj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqVnMIZTI8xG0T0TF0wEOzyt12pdgcdOW4aXbRJSnvea/xTlD0jPA/sWWJbMWGbA4
	 F9e+5+BQkXvfV/PDOuy8Wjbfxk1ClU2XyVJpiudhdz7aV5buvjGKWDwou7/rb6750C
	 1qs7d/aLL5GwMRv9kRmy5ElwRh44hNfoeTu+z7XVJtE/G+O4Iwii92TRl1lCbpSTXp
	 gel8VgiPjcQy2t+PN4yHFxSz6dcAYyI0etNqdaj8Wui2urZn268tO5Bs7zu8JPfR+H
	 vcrqXCUCyeMk3vyBjDIvPIrBTadObXHrNpXEY+uMdJ9zuxRqVuIPPsX7paDUzoR0Wt
	 tANCc2mPwwYVg==
Date: Thu, 18 Sep 2025 13:08:07 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 2/2] arm64/sysreg: Replace TCR_EL1 field macros
Message-ID: <aMv2J1hRQm_f4WAP@willie-the-truck>
References: <20250907123000.414181-1-anshuman.khandual@arm.com>
 <20250907123000.414181-3-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250907123000.414181-3-anshuman.khandual@arm.com>

On Sun, Sep 07, 2025 at 06:00:00PM +0530, Anshuman Khandual wrote:
> This just replaces all used TCR_EL1 field macros with tools sysreg variant
> based fields and subsequently drops them from the header (pgtable-hwdef.h)
> and moves all required macros into KVM header (asm/kvm_arm.h) for continued
> usage in KVM.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: kvmarm@lists.linux.dev
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V4:
> 
> - Dropped all unused TCR_XXX macros while moving into KVM header
> 
>  arch/arm64/include/asm/assembler.h     |  6 +-
>  arch/arm64/include/asm/cputype.h       |  2 +-
>  arch/arm64/include/asm/kvm_arm.h       | 43 +++++++++++
>  arch/arm64/include/asm/mmu_context.h   |  4 +-
>  arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
>  arch/arm64/include/asm/pgtable-prot.h  |  2 +-
>  arch/arm64/kernel/cpufeature.c         |  4 +-
>  arch/arm64/kernel/pi/map_kernel.c      |  8 +--
>  arch/arm64/kernel/vmcore_info.c        |  2 +-
>  arch/arm64/mm/proc.S                   | 36 ++++++----
>  tools/arch/arm64/include/asm/cputype.h |  2 +-

Please don't mix tools/ patches with arch patches. You probably want to keep
the KVM one separate as well.

Will
