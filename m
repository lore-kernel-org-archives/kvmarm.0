Return-Path: <SRS0=5CXi=JM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAF7C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 09:31:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB26161158
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 09:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB26161158
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26C754B63A;
	Thu, 15 Apr 2021 05:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ITYUSqM6SVa; Thu, 15 Apr 2021 05:31:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7EB4B646;
	Thu, 15 Apr 2021 05:31:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECBA54B626
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 05:31:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v17ypZHRkVb0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Apr 2021 05:31:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A254B455
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 05:31:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618479091;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=phkRKYasHy2ON2Zd+AYnzw9m/3bL2pWoEajZ+S+eLjE=;
 b=UHVBgssU6AtMt7bHKsoNjGWZmLb2dNLpL302eS/pWSek+cSANzQYV+T5IF5/6J8TY3XYK9
 oGUUZTiXJVLBmXGkoT9uyfn2IYP61rhRDkv/FkfDp4d7J8WZKq9kOSpPzEBM/YRFhSEhTM
 UCRPfAOEIqko7TFJbvhXa55fXK1c8DU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-We74jQ1HNMadSc7uBlTm7w-1; Thu, 15 Apr 2021 05:31:30 -0400
X-MC-Unique: We74jQ1HNMadSc7uBlTm7w-1
Received: by mail-wm1-f70.google.com with SMTP id
 i5-20020a05600c3545b029010c8bb11782so2685381wmq.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 02:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=phkRKYasHy2ON2Zd+AYnzw9m/3bL2pWoEajZ+S+eLjE=;
 b=eAP7E7n+sNOOhkLTjRFYKKRJgMYOt6XGLe/z8K+Ks/lSycDTAfp8IRa6JNd/LeZlb1
 TbXnQw3rnT1LQryDeWn/4c3mecylFZYv79LRi0Din3GOEvBPkc5c73rl3KvksBW8D6vu
 rft9A9TT8W99fodSa29fxuSOS1aRamlY5f7VqEGIB8tWN+oGWtQiHQFH6B7OkvWj4XE3
 F5Regt4G12tkDFigqF0GOyNekcJCVj8BGTzsViAHS1Z+N1KvsL+zhbveMsALrrhpkepV
 fuc6rezPTRzGCMGXzc3NyiK7eJ0UMkHUYx1x9yUurR4zaKds3chvovYxr6G8Vo6E23GK
 lcmw==
X-Gm-Message-State: AOAM530+ZP8IoiqvNS2ZBMaucTPVOThZaQ6jvm77Oe2hSlCziz5vV6Eu
 0mFYvD4mf2kyV+gxbKSB1FHCUCct26HqgUvCj54iLpTZdpmGQpTEs0nd97zxSRi/He8O2nnbhzy
 TqC+DwcX4bENkIWFou//udpAL
X-Received: by 2002:adf:8b45:: with SMTP id v5mr2406844wra.398.1618479088794; 
 Thu, 15 Apr 2021 02:31:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfQSnAXznxI2JGkIgFlRINBs/MudcZie1Vu3F7EQtZ3n7ewfaKl4lNqKpS1JUJMayw6nDijQ==
X-Received: by 2002:adf:8b45:: with SMTP id v5mr2406812wra.398.1618479088514; 
 Thu, 15 Apr 2021 02:31:28 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6392.dip0.t-ipconnect.de. [91.12.99.146])
 by smtp.gmail.com with ESMTPSA id
 t19sm1746813wmq.14.2021.04.15.02.31.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 15 Apr 2021 02:31:27 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 2/3] arm64: decouple check whether pfn is normal
 memory from pfn_valid()
To: Mike Rapoport <rppt@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-3-rppt@kernel.org>
 <4a788546-b854-fd35-644a-f1d9075a9a78@arm.com>
 <9c0956f0-494e-5c6b-bdc2-d4213afd5e2f@redhat.com>
 <YHdQtmuxpqi4wCE/@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <62161846-4f03-e4b1-ae0b-fdf96f78d97c@redhat.com>
Date: Thu, 15 Apr 2021 11:31:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YHdQtmuxpqi4wCE/@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 14.04.21 22:29, Mike Rapoport wrote:
> On Wed, Apr 14, 2021 at 05:58:26PM +0200, David Hildenbrand wrote:
>> On 08.04.21 07:14, Anshuman Khandual wrote:
>>>
>>> On 4/7/21 10:56 PM, Mike Rapoport wrote:
>>>> From: Mike Rapoport <rppt@linux.ibm.com>
>>>>
>>>> The intended semantics of pfn_valid() is to verify whether there is a
>>>> struct page for the pfn in question and nothing else.
>>>
>>> Should there be a comment affirming this semantics interpretation, above the
>>> generic pfn_valid() in include/linux/mmzone.h ?
>>>
>>>>
>>>> Yet, on arm64 it is used to distinguish memory areas that are mapped in the
>>>> linear map vs those that require ioremap() to access them.
>>>>
>>>> Introduce a dedicated pfn_is_memory() to perform such check and use it
>>>> where appropriate.
>>>>
>>>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>>>> ---
>>>>    arch/arm64/include/asm/memory.h | 2 +-
>>>>    arch/arm64/include/asm/page.h   | 1 +
>>>>    arch/arm64/kvm/mmu.c            | 2 +-
>>>>    arch/arm64/mm/init.c            | 6 ++++++
>>>>    arch/arm64/mm/ioremap.c         | 4 ++--
>>>>    arch/arm64/mm/mmu.c             | 2 +-
>>>>    6 files changed, 12 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
>>>> index 0aabc3be9a75..7e77fdf71b9d 100644
>>>> --- a/arch/arm64/include/asm/memory.h
>>>> +++ b/arch/arm64/include/asm/memory.h
>>>> @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>>>>    #define virt_addr_valid(addr)	({					\
>>>>    	__typeof__(addr) __addr = __tag_reset(addr);			\
>>>> -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
>>>> +	__is_lm_address(__addr) && pfn_is_memory(virt_to_pfn(__addr));	\
>>>>    })
>>>>    void dump_mem_limit(void);
>>>> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>>>> index 012cffc574e8..32b485bcc6ff 100644
>>>> --- a/arch/arm64/include/asm/page.h
>>>> +++ b/arch/arm64/include/asm/page.h
>>>> @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
>>>>    typedef struct page *pgtable_t;
>>>>    extern int pfn_valid(unsigned long);
>>>> +extern int pfn_is_memory(unsigned long);
>>>>    #include <asm/memory.h>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 8711894db8c2..ad2ea65a3937 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>>>>    static bool kvm_is_device_pfn(unsigned long pfn)
>>>>    {
>>>> -	return !pfn_valid(pfn);
>>>> +	return !pfn_is_memory(pfn);
>>>>    }
>>>>    /*
>>>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>>>> index 3685e12aba9b..258b1905ed4a 100644
>>>> --- a/arch/arm64/mm/init.c
>>>> +++ b/arch/arm64/mm/init.c
>>>> @@ -258,6 +258,12 @@ int pfn_valid(unsigned long pfn)
>>>>    }
>>>>    EXPORT_SYMBOL(pfn_valid);
>>>> +int pfn_is_memory(unsigned long pfn)
>>>> +{
>>>> +	return memblock_is_map_memory(PFN_PHYS(pfn));
>>>> +}
>>>> +EXPORT_SYMBOL(pfn_is_memory);> +
>>>
>>> Should not this be generic though ? There is nothing platform or arm64
>>> specific in here. Wondering as pfn_is_memory() just indicates that the
>>> pfn is linear mapped, should not it be renamed as pfn_is_linear_memory()
>>> instead ? Regardless, it's fine either way.
>>
>> TBH, I dislike (generic) pfn_is_memory(). It feels like we're mixing
>> concepts.
> 
> Yeah, at the moment NOMAP is very much arm specific so I'd keep it this way
> for now.
> 
>>   NOMAP memory vs !NOMAP memory; even NOMAP is some kind of memory
>> after all. pfn_is_map_memory() would be more expressive, although still
>> sub-optimal.
>>
>> We'd actually want some kind of arm64-specific pfn_is_system_memory() or the
>> inverse pfn_is_device_memory() -- to be improved.
> 
> In my current version (to be posted soon) I've started with
> pfn_lineary_mapped() but then ended up with pfn_mapped() to make it
> "upward" compatible with architectures that use direct rather than linear
> map :)

And even that is moot. It doesn't tell you if a PFN is *actually* mapped 
(hello secretmem).

I'd suggest to just use memblock_is_map_memory() in arch specific code. 
Then it's clear what we are querying exactly and what the semantics 
might be.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
