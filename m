Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379B7C43461
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 13:12:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F5CF6144D
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 13:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F5CF6144D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD204B4B4;
	Wed, 21 Apr 2021 09:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vgRz5Wbzz0b4; Wed, 21 Apr 2021 09:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82F7B4B4A0;
	Wed, 21 Apr 2021 09:12:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7CD4B4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dnEIEIW0Ek4c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 09:12:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1004B447
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:12:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AA4F11B3;
 Wed, 21 Apr 2021 06:12:45 -0700 (PDT)
Received: from [192.168.0.130] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6693B3F774;
 Wed, 21 Apr 2021 06:12:41 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] arm64: decouple check whether pfn is in linear map
 from pfn_valid()
To: Mike Rapoport <rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-4-rppt@kernel.org>
 <0a7cc0d4-5d3d-7d6d-f4c3-bb2965b810e6@arm.com> <YIAYYcWtuwszHMux@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <2f9fb38c-0125-feca-4e15-3d443f3635e4@arm.com>
Date: Wed, 21 Apr 2021 18:43:28 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YIAYYcWtuwszHMux@kernel.org>
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

On 4/21/21 5:49 PM, Mike Rapoport wrote:
> On Wed, Apr 21, 2021 at 04:29:48PM +0530, Anshuman Khandual wrote:
>>
>> On 4/21/21 12:21 PM, Mike Rapoport wrote:
>>> From: Mike Rapoport <rppt@linux.ibm.com>
>>>
>>> The intended semantics of pfn_valid() is to verify whether there is a
>>> struct page for the pfn in question and nothing else.
>>>
>>> Yet, on arm64 it is used to distinguish memory areas that are mapped in the
>>> linear map vs those that require ioremap() to access them.
>>>
>>> Introduce a dedicated pfn_is_map_memory() wrapper for
>>> memblock_is_map_memory() to perform such check and use it where
>>> appropriate.
>>>
>>> Using a wrapper allows to avoid cyclic include dependencies.
>>>
>>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>>> ---
>>>  arch/arm64/include/asm/memory.h |  2 +-
>>>  arch/arm64/include/asm/page.h   |  1 +
>>>  arch/arm64/kvm/mmu.c            |  2 +-
>>>  arch/arm64/mm/init.c            | 11 +++++++++++
>>>  arch/arm64/mm/ioremap.c         |  4 ++--
>>>  arch/arm64/mm/mmu.c             |  2 +-
>>>  6 files changed, 17 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
>>> index 0aabc3be9a75..194f9f993d30 100644
>>> --- a/arch/arm64/include/asm/memory.h
>>> +++ b/arch/arm64/include/asm/memory.h
>>> @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>>>  
>>>  #define virt_addr_valid(addr)	({					\
>>>  	__typeof__(addr) __addr = __tag_reset(addr);			\
>>> -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
>>> +	__is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));	\
>>>  })
>>>  
>>>  void dump_mem_limit(void);
>>> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>>> index 012cffc574e8..99a6da91f870 100644
>>> --- a/arch/arm64/include/asm/page.h
>>> +++ b/arch/arm64/include/asm/page.h
>>> @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
>>>  typedef struct page *pgtable_t;
>>>  
>>>  extern int pfn_valid(unsigned long);
>>> +extern int pfn_is_map_memory(unsigned long);
>>
>> Check patch is complaining about this.
>>
>> WARNING: function definition argument 'unsigned long' should also have an identifier name
>> #50: FILE: arch/arm64/include/asm/page.h:41:
>> +extern int pfn_is_map_memory(unsigned long);
>>
>>
>>>  
>>>  #include <asm/memory.h>
>>>  
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 8711894db8c2..23dd99e29b23 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>>>  
>>>  static bool kvm_is_device_pfn(unsigned long pfn)
>>>  {
>>> -	return !pfn_valid(pfn);
>>> +	return !pfn_is_map_memory(pfn);
>>>  }
>>>  
>>>  /*
>>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>>> index 3685e12aba9b..dc03bdc12c0f 100644
>>> --- a/arch/arm64/mm/init.c
>>> +++ b/arch/arm64/mm/init.c
>>> @@ -258,6 +258,17 @@ int pfn_valid(unsigned long pfn)
>>>  }
>>>  EXPORT_SYMBOL(pfn_valid);
>>>  
>>> +int pfn_is_map_memory(unsigned long pfn)
>>> +{
>>> +	phys_addr_t addr = PFN_PHYS(pfn);
>>> +
>>
>> Should also bring with it, the comment regarding upper bits in
>> the pfn from arm64 pfn_valid().
> 
> I think a reference to the comment in pfn_valid() will suffice.

Okay.

> 
> BTW, I wonder how is that other architectures do not need this check?

Trying to move that into generic pfn_valid() in mmzone.h, will resend
the RFC patch after this series.

https://patchwork.kernel.org/project/linux-mm/patch/1615174073-10520-1-git-send-email-anshuman.khandual@arm.com/

>  
>>> +	if (PHYS_PFN(addr) != pfn)
>>> +		return 0;
>>> +	
>>
>>  ^^^^^ trailing spaces here.
>>
>> ERROR: trailing whitespace
>> #81: FILE: arch/arm64/mm/init.c:263:
>> +^I$
> 
> Oops :)
>  
>>> +	return memblock_is_map_memory(addr);
>>> +}
>>> +EXPORT_SYMBOL(pfn_is_map_memory);
>>> +
>>
>> Is the EXPORT_SYMBOL() required to build drivers which will use
>> pfn_is_map_memory() but currently use pfn_valid() ?
> 
> Yes, this is required for virt_addr_valid() that is used by modules.
> 

There will be two adjacent EXPORT_SYMBOLS(), one for pfn_valid() and
one for pfn_is_map_memory(). But its okay I guess, cant help it.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
