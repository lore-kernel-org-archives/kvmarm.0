Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8CC2376A
	for <kvmarm@lists.linux.dev>; Thu, 27 Jun 2024 05:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719467594; cv=none; b=TFADzw0MN0c2KEVHwyZOtWmh55JXhF23OlGhPcWlVEL8kKb+sU2JypkNTewMgLvO6+zpzXdcTnuRWNXe7sx1YMmydcUJ22PeL6MT8HMz7+8v3BUBfWgWb87+V3UCcHzQ4GAQKhyQkEBqJ+W5vypIlKHut0Oa2604/Rl2O4ox/HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719467594; c=relaxed/simple;
	bh=LtfJVn/zBNB45Oqgv6+R9DcVS1Ch7Szo9+0AZ9ig5GU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=h8wfT5mPxwFd19muXr7TC7o3NVDqYV7IFTaeRCBa8AvilOoOBj07DwnPHx80Myocj94gqbC/UT4H2EUZaec0UlSaYxrz3PjZkohibyCkc42gUwMzkKFz4jk1EWgzS0mc7nK0tn8rv9PH9omMz4DYDJ8d4Wl+7JLQdsz69uyZcXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A21E367;
	Wed, 26 Jun 2024 22:53:36 -0700 (PDT)
Received: from [10.163.47.90] (unknown [10.163.47.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B5E03F6A8;
	Wed, 26 Jun 2024 22:53:07 -0700 (PDT)
Message-ID: <1259a298-f038-4b29-99ea-9158d2f26cfd@arm.com>
Date: Thu, 27 Jun 2024 11:23:04 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] arm64: Drop
 ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, ryan.roberts@arm.com, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240613102710.3295108-1-anshuman.khandual@arm.com>
 <ba9b51db-5e8a-4e89-ad6a-046133dfc657@arm.com>
Content-Language: en-US
In-Reply-To: <ba9b51db-5e8a-4e89-ad6a-046133dfc657@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/24 08:54, Anshuman Khandual wrote:
> 
> 
> On 6/13/24 15:57, Anshuman Khandual wrote:
>> This series replaces custom macros usage for ID_AA64PFR0_EL1_ELx_64BIT_ONLY
>> and ID_AA64PFR0_EL1_ELx_32BIT_64BIT fields, thus finally just dropping them
>> off completely. This series applies on v6.10-rc3
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>>
>> Changes in V2:
>>
>> - Replaced FIELD_PREP() with SYS_FIELD_PREP_ENUM() as per Marc
> 
> Gentle ping, any updates for this series ?

Gentle ping again, any updates on this ?

> 
>>
>> Changes in V1:
>>
>> https://lore.kernel.org/all/20240418053804.2573071-1-anshuman.khandual@arm.com/
>>
>> Anshuman Khandual (2):
>>   KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
>>   arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1
>>
>>  arch/arm64/include/asm/cpufeature.h            |  4 ++--
>>  arch/arm64/include/asm/sysreg.h                |  4 ----
>>  arch/arm64/kernel/cpufeature.c                 |  4 ++--
>>  arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 10 +++++-----
>>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 |  4 ++--
>>  arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  2 +-
>>  6 files changed, 12 insertions(+), 16 deletions(-)
>>
> 
