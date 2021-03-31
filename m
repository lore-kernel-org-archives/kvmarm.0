Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B76DC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F159C619B9
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F159C619B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 487394B3FB;
	Wed, 31 Mar 2021 05:33:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sX4BnXamP8NS; Wed, 31 Mar 2021 05:33:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20DC54B3F2;
	Wed, 31 Mar 2021 05:33:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 086054B3F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9QXbHTU1+wOZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 05:33:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6F8C4B3D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:33:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617183185;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=C1knNxXYrju/mC8ezKpQGTAG13wYdrEgV2y7PJgAQew=;
 b=H9/QyZGRFmPmENz/I6gWBX2rX19rGoyuseDqe3HnbPH3AqrIFos3bxt3p/S9xCf8HcBnFj
 RPexwh7joCavRH3dypNwBpbRYXFOxE76OMn0ULvw69TBKmP4y6GFmi2d+s2AbNVVQfNv0N
 H8Mhgv/GhL/ma20UYxxMYD4GuvJlemw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-UD-lwE1yNmCk07pomI1HXg-1; Wed, 31 Mar 2021 05:33:01 -0400
X-MC-Unique: UD-lwE1yNmCk07pomI1HXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B96D190B2AD;
 Wed, 31 Mar 2021 09:32:58 +0000 (UTC)
Received: from [10.36.113.60] (ovpn-113-60.ams2.redhat.com [10.36.113.60])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B93AB5D9CC;
 Wed, 31 Mar 2021 09:32:47 +0000 (UTC)
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
Date: Wed, 31 Mar 2021 11:32:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210331092109.GA21921@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: qemu-devel@nongnu.org, Marc Zyngier <maz@kernel.org>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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

On 31.03.21 11:21, Catalin Marinas wrote:
> On Wed, Mar 31, 2021 at 09:34:44AM +0200, David Hildenbrand wrote:
>> On 30.03.21 12:30, Catalin Marinas wrote:
>>> On Mon, Mar 29, 2021 at 05:06:51PM +0100, Steven Price wrote:
>>>> On 28/03/2021 13:21, Catalin Marinas wrote:
>>>>> On Sat, Mar 27, 2021 at 03:23:24PM +0000, Catalin Marinas wrote:
>>>>>> On Fri, Mar 12, 2021 at 03:18:58PM +0000, Steven Price wrote:
>>>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>>>> index 77cb2d28f2a4..b31b7a821f90 100644
>>>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>>>> @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>>>>     	if (vma_pagesize == PAGE_SIZE && !force_pte)
>>>>>>>     		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>>>>>>     							   &pfn, &fault_ipa);
>>>>>>> +
>>>>>>> +	if (fault_status != FSC_PERM && kvm_has_mte(kvm) && pfn_valid(pfn)) {
>>>>>>> +		/*
>>>>>>> +		 * VM will be able to see the page's tags, so we must ensure
>>>>>>> +		 * they have been initialised. if PG_mte_tagged is set, tags
>>>>>>> +		 * have already been initialised.
>>>>>>> +		 */
>>>>>>> +		struct page *page = pfn_to_page(pfn);
>>>>>>> +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
>>>>>>> +
>>>>>>> +		for (i = 0; i < nr_pages; i++, page++) {
>>>>>>> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>>>>>>> +				mte_clear_page_tags(page_address(page));
>>>>>>> +		}
>>>>>>> +	}
>>>>>>
>>>>>> This pfn_valid() check may be problematic. Following commit eeb0753ba27b
>>>>>> ("arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory"), it returns
>>>>>> true for ZONE_DEVICE memory but such memory is allowed not to support
>>>>>> MTE.
>>>>>
>>>>> Some more thinking, this should be safe as any ZONE_DEVICE would be
>>>>> mapped as untagged memory in the kernel linear map. It could be slightly
>>>>> inefficient if it unnecessarily tries to clear tags in ZONE_DEVICE,
>>>>> untagged memory. Another overhead is pfn_valid() which will likely end
>>>>> up calling memblock_is_map_memory().
>>>>>
>>>>> However, the bigger issue is that Stage 2 cannot disable tagging for
>>>>> Stage 1 unless the memory is Non-cacheable or Device at S2. Is there a
>>>>> way to detect what gets mapped in the guest as Normal Cacheable memory
>>>>> and make sure it's only early memory or hotplug but no ZONE_DEVICE (or
>>>>> something else like on-chip memory)?  If we can't guarantee that all
>>>>> Cacheable memory given to a guest supports tags, we should disable the
>>>>> feature altogether.
>>>>
>>>> In stage 2 I believe we only have two types of mapping - 'normal' or
>>>> DEVICE_nGnRE (see stage2_map_set_prot_attr()). Filtering out the latter is a
>>>> case of checking the 'device' variable, and makes sense to avoid the
>>>> overhead you describe.
>>>>
>>>> This should also guarantee that all stage-2 cacheable memory supports tags,
>>>> as kvm_is_device_pfn() is simply !pfn_valid(), and pfn_valid() should only
>>>> be true for memory that Linux considers "normal".
>>
>> If you think "normal" == "normal System RAM", that's wrong; see below.
> 
> By "normal" I think both Steven and I meant the Normal Cacheable memory
> attribute (another being the Device memory attribute).
> 
>>> That's the problem. With Anshuman's commit I mentioned above,
>>> pfn_valid() returns true for ZONE_DEVICE mappings (e.g. persistent
>>> memory, not talking about some I/O mapping that requires Device_nGnRE).
>>> So kvm_is_device_pfn() is false for such memory and it may be mapped as
>>> Normal but it is not guaranteed to support tagging.
>>
>> pfn_valid() means "there is a struct page"; if you do pfn_to_page() and
>> touch the page, you won't fault. So Anshuman's commit is correct.
> 
> I agree.
> 
>> pfn_to_online_page() means, "there is a struct page and it's system RAM
>> that's in use; the memmap has a sane content"
> 
> Does pfn_to_online_page() returns a valid struct page pointer for
> ZONE_DEVICE pages? IIUC, these are not guaranteed to be system RAM, for
> some definition of system RAM (I assume NVDIMM != system RAM). For
> example, pmem_attach_disk() calls devm_memremap_pages() and this would
> use the Normal Cacheable memory attribute without necessarily being
> system RAM.

No, not for ZONE_DEVICE.

However, if you expose PMEM via dax/kmem as System RAM to the system (-> 
add_memory_driver_managed()), then PMEM (managed via ZONE_NOMRAL or 
ZONE_MOVABLE) would work with pfn_to_online_page() -- as the system 
thinks it's "ordinary system RAM" and the memory is managed by the buddy.

> 
> So if pfn_valid() is not equivalent to system RAM, we have a potential
> issue with MTE. Even if "system RAM" includes NVDIMMs, we still have
> this issue and we may need a new term to describe MTE-safe memory. In
> the kernel we assume MTE-safe all pages that can be mapped as
> MAP_ANONYMOUS and I don't think these include ZONE_DEVICE pages.
> 
> Thanks.
> 


-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
