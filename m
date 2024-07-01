Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C3042056
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719832560; cv=none; b=FZgDtMHZz2H0INKUh7IeVy4g6pwqyFXvMSrJD04ou0p+TQ9o2o5ZRXYJ5/6TdKliJsIBRpbVSUicw/sjXSDHmoSG9BXW7+kmatTyuBL1OW+LKOKaNQSQCxFVRGVHqndIEZZFPpNdOPlzHHmM7/mTA5/nPocRIXrzfxP0J3DH6JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719832560; c=relaxed/simple;
	bh=4ddreTu5LbcKhaTksdZi+sf51LSj3+yN1qf5sdX0dDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=leaw/qq9cooLRLKYFF5I7e1MDRMV8V8xKOANQrIyOYvieQ+npzdCMzqmxcWyerFbSSIDO/qTJRmQMDGeJqn29LKjIStZJ1fuOQMP0x+sEaV3y8z/MNpdbkhWeRrJZHNe5c2ePls7sep3WoR3uPMC5MtIxBL/8qlTTGTmsaZeTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68818339;
	Mon,  1 Jul 2024 04:16:22 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DC2C3F762;
	Mon,  1 Jul 2024 04:15:55 -0700 (PDT)
Date: Mon, 1 Jul 2024 12:15:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/2] arm64: Drop
 ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
Message-ID: <ZoKP5sgACZbGpmck@J2N7QTR9R3>
References: <20240613102710.3295108-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613102710.3295108-1-anshuman.khandual@arm.com>

On Thu, Jun 13, 2024 at 03:57:08PM +0530, Anshuman Khandual wrote:
> This series replaces custom macros usage for ID_AA64PFR0_EL1_ELx_64BIT_ONLY
> and ID_AA64PFR0_EL1_ELx_32BIT_64BIT fields, thus finally just dropping them
> off completely. This series applies on v6.10-rc3
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> 
> Changes in V2:
> 
> - Replaced FIELD_PREP() with SYS_FIELD_PREP_ENUM() as per Marc
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20240418053804.2573071-1-anshuman.khandual@arm.com/
> 
> Anshuman Khandual (2):
>   KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
>   arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1

For the series:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
>  arch/arm64/include/asm/cpufeature.h            |  4 ++--
>  arch/arm64/include/asm/sysreg.h                |  4 ----
>  arch/arm64/kernel/cpufeature.c                 |  4 ++--
>  arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 10 +++++-----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  2 +-
>  6 files changed, 12 insertions(+), 16 deletions(-)
> 
> -- 
> 2.30.2
> 
