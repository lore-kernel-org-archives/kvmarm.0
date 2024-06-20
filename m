Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56DEA2139C7
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 03:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718853870; cv=none; b=VI2xFpIr6KR3XckDSPt/HnDCUYLSG46hygRD6e4+iYFEPJjJ1Djf07pCNgqqG6nOQI6efL8Pb/3T7dYXPUEeGKCPwRgU/Hs+V5DKky++2N4dXxjs5lKanAd8+d5yJBONuRSIIbpykjpD8wUEFBZph0Wcm0nde/xuRnXCEndf9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718853870; c=relaxed/simple;
	bh=zfUyu0pm2IYmWh5JGWUKNrA0MqEBSl7VlMju18XAaGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rgOGQ7FxnTX155o7ivAP+vqOCmV+rZaTpKKTNAiLwD0pf4YbFatltHfon8NqIB0mX6nSk4ea75NZdSBk7ijMa7rzGTxFtsDajmLQarOQtEg9zssdmruTz9CRotW9xxgN1BPDk11CUwYVXHhgjNuZ9sCdjuQPmF6jhYVjfrd7KhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 231F2DA7;
	Wed, 19 Jun 2024 20:24:50 -0700 (PDT)
Received: from [10.163.46.59] (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 150443F73B;
	Wed, 19 Jun 2024 20:24:21 -0700 (PDT)
Message-ID: <ba9b51db-5e8a-4e89-ad6a-046133dfc657@arm.com>
Date: Thu, 20 Jun 2024 08:54:20 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] arm64: Drop
 ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
Content-Language: en-US
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, ryan.roberts@arm.com, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240613102710.3295108-1-anshuman.khandual@arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240613102710.3295108-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/13/24 15:57, Anshuman Khandual wrote:
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

Gentle ping, any updates for this series ?

> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20240418053804.2573071-1-anshuman.khandual@arm.com/
> 
> Anshuman Khandual (2):
>   KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
>   arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1
> 
>  arch/arm64/include/asm/cpufeature.h            |  4 ++--
>  arch/arm64/include/asm/sysreg.h                |  4 ----
>  arch/arm64/kernel/cpufeature.c                 |  4 ++--
>  arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 10 +++++-----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  2 +-
>  6 files changed, 12 insertions(+), 16 deletions(-)
> 
