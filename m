Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8107FC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 13:15:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA1E76144C
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 13:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA1E76144C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EF1A4B4A2;
	Wed, 21 Apr 2021 09:15:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u4Wno+ks9ZLn; Wed, 21 Apr 2021 09:15:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F274B4A4;
	Wed, 21 Apr 2021 09:15:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B7D4B4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:15:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6r7GDhazR+hM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 09:15:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3992B4B45B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:15:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99CBC11B3;
 Wed, 21 Apr 2021 06:15:06 -0700 (PDT)
Received: from [192.168.0.130] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB8C73F774;
 Wed, 21 Apr 2021 06:15:02 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-5-rppt@kernel.org>
 <66d50afe-77e6-70ee-6b51-5db28a086c68@arm.com> <YIAZYVI/HZWBr7BI@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <c9c4c4cc-fd4d-8bba-dd14-fa5d52161f9d@arm.com>
Date: Wed, 21 Apr 2021 18:45:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YIAZYVI/HZWBr7BI@kernel.org>
Content-Language: en-US
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 4/21/21 5:54 PM, Mike Rapoport wrote:
> On Wed, Apr 21, 2021 at 04:36:46PM +0530, Anshuman Khandual wrote:
>>
>> On 4/21/21 12:21 PM, Mike Rapoport wrote:
>>> From: Mike Rapoport <rppt@linux.ibm.com>
>>>
>>> The arm64's version of pfn_valid() differs from the generic because of two
>>> reasons:
>>>
>>> * Parts of the memory map are freed during boot. This makes it necessary to
>>>   verify that there is actual physical memory that corresponds to a pfn
>>>   which is done by querying memblock.
>>>
>>> * There are NOMAP memory regions. These regions are not mapped in the
>>>   linear map and until the previous commit the struct pages representing
>>>   these areas had default values.
>>>
>>> As the consequence of absence of the special treatment of NOMAP regions in
>>> the memory map it was necessary to use memblock_is_map_memory() in
>>> pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
>>> generic mm functionality would not treat a NOMAP page as a normal page.
>>>
>>> Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
>>> the rest of core mm will treat them as unusable memory and thus
>>> pfn_valid_within() is no longer required at all and can be disabled by
>>> removing CONFIG_HOLES_IN_ZONE on arm64.
>>
>> This makes sense.
>>
>>>
>>> pfn_valid() can be slightly simplified by replacing
>>> memblock_is_map_memory() with memblock_is_memory().
>>>
>>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>>> ---
>>>  arch/arm64/Kconfig   | 3 ---
>>>  arch/arm64/mm/init.c | 4 ++--
>>>  2 files changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index e4e1b6550115..58e439046d05 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>>>  	def_bool y
>>>  	depends on NUMA
>>>  
>>> -config HOLES_IN_ZONE
>>> -	def_bool y
>>> -
>>
>> Right.
>>
>>>  source "kernel/Kconfig.hz"
>>>  
>>>  config ARCH_SPARSEMEM_ENABLE
>>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>>> index dc03bdc12c0f..eb3f56fb8c7c 100644
>>> --- a/arch/arm64/mm/init.c
>>> +++ b/arch/arm64/mm/init.c
>>> @@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
>>>  
>>>  	/*
>>>  	 * ZONE_DEVICE memory does not have the memblock entries.
>>> -	 * memblock_is_map_memory() check for ZONE_DEVICE based
>>> +	 * memblock_is_memory() check for ZONE_DEVICE based
>>>  	 * addresses will always fail. Even the normal hotplugged
>>>  	 * memory will never have MEMBLOCK_NOMAP flag set in their
>>>  	 * memblock entries. Skip memblock search for all non early
>>> @@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
>>>  		return pfn_section_valid(ms, pfn);
>>>  }
>>>  #endif
>>> -	return memblock_is_map_memory(addr);
>>> +	return memblock_is_memory(addr);
>>
>> Wondering if MEMBLOCK_NOMAP is now being treated similarly to other
>> memory pfns for page table walking purpose but with PageReserved(),
>> why memblock_is_memory() is still required ? At this point, should
>> not we just return valid for early_section() memory. As pfn_valid()
>> now just implies that pfn has a struct page backing which has been
>> already verified with valid_section() etc.
> 
> memblock_is_memory() is required because arm64 frees unused parts of the
> memory map. So, for instance, if we have 64M out of 128M populated in a
> section the section based calculation would return 1 for a pfn in the
> second half of the section, but there would be no memory map there.

Understood.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
