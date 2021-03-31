Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1334FC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:35:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74560619DB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74560619DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E67114B3E2;
	Wed, 31 Mar 2021 03:34:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lPik6as85Mw2; Wed, 31 Mar 2021 03:34:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 949084B3D2;
	Wed, 31 Mar 2021 03:34:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E874B3B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:34:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wNy4LTgRcRYy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 03:34:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5AB14B3B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:34:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617176095;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Rw79CBvMLi5mEY0tcvp9kTn6CghMbW3t144/yxRDUX4=;
 b=HvURMu1hUDFg7UEMiYVY4j7YvBeOgTeyQEAZ7Q1eG9jmWhni9ntk9RV4nzdd988o4QXnSr
 ezxT42ztPe4w11EqctwdLowVCBvliDNyoRdiFSdqLOg0EEos8qvkqFQGZUyFghuy/2Ctj7
 MujZpK9uFLuHNNZrAE712v83HG/N3Ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-Q4AVGFAoNCuvO8_eHBIvbQ-1; Wed, 31 Mar 2021 03:34:52 -0400
X-MC-Unique: Q4AVGFAoNCuvO8_eHBIvbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87C43108BD09;
 Wed, 31 Mar 2021 07:34:50 +0000 (UTC)
Received: from [10.36.113.60] (ovpn-113-60.ams2.redhat.com [10.36.113.60])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5582D5C5AE;
 Wed, 31 Mar 2021 07:34:45 +0000 (UTC)
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
Date: Wed, 31 Mar 2021 09:34:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330103013.GD18075@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

On 30.03.21 12:30, Catalin Marinas wrote:
> On Mon, Mar 29, 2021 at 05:06:51PM +0100, Steven Price wrote:
>> On 28/03/2021 13:21, Catalin Marinas wrote:
>>> On Sat, Mar 27, 2021 at 03:23:24PM +0000, Catalin Marinas wrote:
>>>> On Fri, Mar 12, 2021 at 03:18:58PM +0000, Steven Price wrote:
>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>> index 77cb2d28f2a4..b31b7a821f90 100644
>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>> @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>>    	if (vma_pagesize == PAGE_SIZE && !force_pte)
>>>>>    		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>>>>    							   &pfn, &fault_ipa);
>>>>> +
>>>>> +	if (fault_status != FSC_PERM && kvm_has_mte(kvm) && pfn_valid(pfn)) {
>>>>> +		/*
>>>>> +		 * VM will be able to see the page's tags, so we must ensure
>>>>> +		 * they have been initialised. if PG_mte_tagged is set, tags
>>>>> +		 * have already been initialised.
>>>>> +		 */
>>>>> +		struct page *page = pfn_to_page(pfn);
>>>>> +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
>>>>> +
>>>>> +		for (i = 0; i < nr_pages; i++, page++) {
>>>>> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>>>>> +				mte_clear_page_tags(page_address(page));
>>>>> +		}
>>>>> +	}
>>>>
>>>> This pfn_valid() check may be problematic. Following commit eeb0753ba27b
>>>> ("arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory"), it returns
>>>> true for ZONE_DEVICE memory but such memory is allowed not to support
>>>> MTE.
>>>
>>> Some more thinking, this should be safe as any ZONE_DEVICE would be
>>> mapped as untagged memory in the kernel linear map. It could be slightly
>>> inefficient if it unnecessarily tries to clear tags in ZONE_DEVICE,
>>> untagged memory. Another overhead is pfn_valid() which will likely end
>>> up calling memblock_is_map_memory().
>>>
>>> However, the bigger issue is that Stage 2 cannot disable tagging for
>>> Stage 1 unless the memory is Non-cacheable or Device at S2. Is there a
>>> way to detect what gets mapped in the guest as Normal Cacheable memory
>>> and make sure it's only early memory or hotplug but no ZONE_DEVICE (or
>>> something else like on-chip memory)?  If we can't guarantee that all
>>> Cacheable memory given to a guest supports tags, we should disable the
>>> feature altogether.
>>
>> In stage 2 I believe we only have two types of mapping - 'normal' or
>> DEVICE_nGnRE (see stage2_map_set_prot_attr()). Filtering out the latter is a
>> case of checking the 'device' variable, and makes sense to avoid the
>> overhead you describe.
>>
>> This should also guarantee that all stage-2 cacheable memory supports tags,
>> as kvm_is_device_pfn() is simply !pfn_valid(), and pfn_valid() should only
>> be true for memory that Linux considers "normal".

If you think "normal" == "normal System RAM", that's wrong; see below.

> 
> That's the problem. With Anshuman's commit I mentioned above,
> pfn_valid() returns true for ZONE_DEVICE mappings (e.g. persistent
> memory, not talking about some I/O mapping that requires Device_nGnRE).
> So kvm_is_device_pfn() is false for such memory and it may be mapped as
> Normal but it is not guaranteed to support tagging.

pfn_valid() means "there is a struct page"; if you do pfn_to_page() and 
touch the page, you won't fault. So Anshuman's commit is correct.

pfn_to_online_page() means, "there is a struct page and it's system RAM 
that's in use; the memmap has a sane content"

> 
> For user MTE, we get away with this as the MAP_ANONYMOUS requirement
> would filter it out while arch_add_memory() will ensure it's mapped as
> untagged in the linear map. See another recent fix for hotplugged
> memory: d15dfd31384b ("arm64: mte: Map hotplugged memory as Normal
> Tagged"). We needed to ensure that ZONE_DEVICE doesn't end up as tagged,
> only hoplugged memory. Both handled via arch_add_memory() in the arch
> code with ZONE_DEVICE starting at devm_memremap_pages().
> 
>>>> I now wonder if we can get a MAP_ANONYMOUS mapping of ZONE_DEVICE pfn
>>>> even without virtualisation.
>>>
>>> I haven't checked all the code paths but I don't think we can get a
>>> MAP_ANONYMOUS mapping of ZONE_DEVICE memory as we normally need a file
>>> descriptor.
>>
>> I certainly hope this is the case - it's the weird corner cases of device
>> drivers that worry me. E.g. I know i915 has a "hidden" mmap behind an ioctl
>> (see i915_gem_mmap_ioctl(), although this case is fine - it's MAP_SHARED).
>> Mali's kbase did something similar in the past.
> 
> I think this should be fine since it's not a MAP_ANONYMOUS (we do allow
> MAP_SHARED to be tagged).
> 


-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
