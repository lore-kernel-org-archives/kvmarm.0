Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A606F2C0F81
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758273770; cv=none; b=CG/xysOaf/wmlf/Jfx2XCZ5SgTb+KPG+oDMUDwIylC/eanHa8Mh2J8VGb7hGocdJp0+5ltazFY/kIDoBfzGRe9fNFolqLsnQsNwJ4FjvRFhZLUi1DHCuSJ1xQ2BRPsKuHRjJlmgYqvCcaaLKzLOb8gVWWp6jj8T3489OYhPFI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758273770; c=relaxed/simple;
	bh=0ZQCC4VWhyf8uMZ7nGXEpvjFC2ryEIPI0vytiwsSrKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=brZztDEHmMaepeBw9pyaf6nZL8uv56D0tb1+Jggi9IDcSO/v0WuHW4iyk1x3CxFZPCSq2Z7+QQpqMEIGOXjA4EJ2kng7FMx8MTRLTxGmbcBn1n6khfc398DUYkl3xIdowPiJR/cOKyIhQyXCrMHQe4ucF+IDk32rAJKGDmPXCbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C17E4169E;
	Fri, 19 Sep 2025 02:22:38 -0700 (PDT)
Received: from [10.163.44.14] (unknown [10.163.44.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F4963F66E;
	Fri, 19 Sep 2025 02:22:43 -0700 (PDT)
Message-ID: <554e507a-1a68-4ae9-9345-5aea0a81ba2b@arm.com>
Date: Fri, 19 Sep 2025 14:52:40 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] arm64/sysreg: Replace TCR_EL1 field macros
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250907123000.414181-1-anshuman.khandual@arm.com>
 <20250907123000.414181-3-anshuman.khandual@arm.com>
 <aMv2J1hRQm_f4WAP@willie-the-truck>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aMv2J1hRQm_f4WAP@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/09/25 5:38 PM, Will Deacon wrote:
> On Sun, Sep 07, 2025 at 06:00:00PM +0530, Anshuman Khandual wrote:
>> This just replaces all used TCR_EL1 field macros with tools sysreg variant
>> based fields and subsequently drops them from the header (pgtable-hwdef.h)
>> and moves all required macros into KVM header (asm/kvm_arm.h) for continued
>> usage in KVM.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in V4:
>>
>> - Dropped all unused TCR_XXX macros while moving into KVM header
>>
>>  arch/arm64/include/asm/assembler.h     |  6 +-
>>  arch/arm64/include/asm/cputype.h       |  2 +-
>>  arch/arm64/include/asm/kvm_arm.h       | 43 +++++++++++
>>  arch/arm64/include/asm/mmu_context.h   |  4 +-
>>  arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
>>  arch/arm64/include/asm/pgtable-prot.h  |  2 +-
>>  arch/arm64/kernel/cpufeature.c         |  4 +-
>>  arch/arm64/kernel/pi/map_kernel.c      |  8 +--
>>  arch/arm64/kernel/vmcore_info.c        |  2 +-
>>  arch/arm64/mm/proc.S                   | 36 ++++++----
>>  tools/arch/arm64/include/asm/cputype.h |  2 +-
> 
> Please don't mix tools/ patches with arch patches. You probably want to keep
> the KVM one separate as well.

Sure, will split these changes in the following order.

- arm64 tool sysreg update for TCR_EL1
- Tools header update for TCR_NFD0/1
- Kernel update
- KVM specific update i.e header macro movement
