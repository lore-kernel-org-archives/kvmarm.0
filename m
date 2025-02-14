Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751C4185B48
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 07:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739517588; cv=none; b=oEL/rzOywIgwBExhuRq6ffuHUBLBPlluTRhzGqzdtLIN7oznibvntdY2IULxfwgpY163iGnPs4hvAW9CLuyvutwLyyiJZc2a544x1aZi5d6+ByN7C6WMxodHJjSEhJhKjB7xPGJQgzF5BHFnKdrgmljpCiYDyQCmYuk1qseWKfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739517588; c=relaxed/simple;
	bh=9pXcTWQFvAqk3KhX6fq3T9qPy653aQkkM4y4ypTJt/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K9v3NPLO0laJ36v4RvIzbJmhOHqRVykV0zi2Sykvl53+LusZHpZj9rHwG8oudQpCCcWyLVYv3AOijSYj78667l7xTQNFUI59PhAR+HFhfl20769Et4JLHvfApbwsbKdhT/7C2xrAZAgdNsYQdBL4zfGT9WehGGgtdRn9hie7trs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B87B2113E;
	Thu, 13 Feb 2025 23:20:05 -0800 (PST)
Received: from [10.163.37.128] (unknown [10.163.37.128])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01C283F58B;
	Thu, 13 Feb 2025 23:19:35 -0800 (PST)
Message-ID: <8ebbc47f-c56a-49a0-bf04-930b0a9e84e8@arm.com>
Date: Fri, 14 Feb 2025 12:49:33 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: Rename GENERIC_PTDUMP and PTDUMP_CORE
To: Steven Price <steven.price@arm.com>, linux-mm@kvack.org
Cc: christophe.leroy@csgroup.eu, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20250213040934.3245750-1-anshuman.khandual@arm.com>
 <20250213040934.3245750-5-anshuman.khandual@arm.com>
 <8e75c5ff-a97b-4a6f-9c8b-ac2598eafe60@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <8e75c5ff-a97b-4a6f-9c8b-ac2598eafe60@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/13/25 16:53, Steven Price wrote:
> On 13/02/2025 04:09, Anshuman Khandual wrote:
>> Platforms subscribe into generic ptdump implementation via GENERIC_PTDUMP.
>> But generic ptdump gets enabled via PTDUMP_CORE. These configs combination
>> is confusing as they sound very similar and does not differentiate between
>> platform's feature subscription and feature enablement for ptdump. Rename
>> the configs as ARCH_HAS_PTDUMP and PTDUMP making it more clear and improve
>> readability.
> 
> I'm not going to bikeshed over the naming, but a few points below.
> 
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Paul Walmsley <paul.walmsley@sifive.com>
>> Cc: Palmer Dabbelt <palmer@dabbelt.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: linux-riscv@lists.infradead.org
>> Cc: linux-s390@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  Documentation/arch/arm64/ptdump.rst       |  4 ++--
>>  arch/arm64/Kconfig                        |  2 +-
>>  arch/arm64/include/asm/ptdump.h           |  4 ++--
>>  arch/arm64/kvm/Kconfig                    |  4 ++--
>>  arch/arm64/mm/Makefile                    |  2 +-
>>  arch/powerpc/Kconfig                      |  2 +-
>>  arch/powerpc/configs/mpc885_ads_defconfig |  2 +-
>>  arch/powerpc/mm/Makefile                  |  2 +-
>>  arch/riscv/Kconfig                        |  2 +-
>>  arch/riscv/mm/Makefile                    |  2 +-
>>  arch/s390/Kconfig                         |  2 +-
>>  arch/s390/mm/Makefile                     |  2 +-
>>  arch/x86/Kconfig                          |  2 +-
>>  arch/x86/Kconfig.debug                    |  2 +-
>>  arch/x86/mm/Makefile                      |  2 +-
>>  mm/Kconfig.debug                          | 12 ++++++------
>>  mm/Makefile                               |  2 +-
>>  17 files changed, 25 insertions(+), 25 deletions(-)
>>
>> diff --git a/Documentation/arch/arm64/ptdump.rst b/Documentation/arch/arm64/ptdump.rst
>> index 5dcfc5d7cddf..a2e527377da3 100644
>> --- a/Documentation/arch/arm64/ptdump.rst
>> +++ b/Documentation/arch/arm64/ptdump.rst
>> @@ -22,8 +22,8 @@ offlining of memory being accessed by the ptdump code.
>>  In order to dump the kernel page tables, enable the following
>>  configurations and mount debugfs::
>>  
>> - CONFIG_GENERIC_PTDUMP=y
>> - CONFIG_PTDUMP_CORE=y
>> + CONFIG_ARCH_HAS_PTDUMP=y
>> + CONFIG_PTDUMP=y
>>   CONFIG_PTDUMP_DEBUGFS=y
> 
> I think we should drop CONFIG_GENERIC_PTDUMP/CONFIG_ARCH_HAS_PTDUMP from
> this list. It's not a user-selectable symbol so there's no need to be
> documenting it here.

Sure, will fold that in here.

> 
>>  
>>   mount -t debugfs nodev /sys/kernel/debug
> [...]
>> diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
>> index 77306be62e9e..db005618690b 100644
>> --- a/arch/powerpc/configs/mpc885_ads_defconfig
>> +++ b/arch/powerpc/configs/mpc885_ads_defconfig
>> @@ -78,4 +78,4 @@ CONFIG_DEBUG_VM_PGTABLE=y
>>  CONFIG_DETECT_HUNG_TASK=y
>>  CONFIG_BDI_SWITCH=y
>>  CONFIG_PPC_EARLY_DEBUG=y
>> -CONFIG_GENERIC_PTDUMP=y
>> +CONFIG_PTDUMP=y
> 
> I'd suggest dropp this from the defconfig too, just like patch 1 dropped
> it from debug.config.

Agreed.
