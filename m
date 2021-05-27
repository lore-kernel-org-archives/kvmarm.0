Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4D6C47089
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 07:50:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1332E61358
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 07:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1332E61358
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80C9C4A003;
	Thu, 27 May 2021 03:50:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zs1TJraot+q4; Thu, 27 May 2021 03:50:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1394140CC5;
	Thu, 27 May 2021 03:50:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5013740CC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 03:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3SxyBU6wtMCB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 03:50:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B070C4099E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 03:50:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EC7E11D4;
 Thu, 27 May 2021 00:50:34 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C3F53F73B;
 Thu, 27 May 2021 00:50:31 -0700 (PDT)
Subject: Re: [PATCH v12 7/8] KVM: arm64: ioctl to fetch/store tags in a guest
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-8-steven.price@arm.com> <20210520120556.GC12251@arm.com>
 <dd5ab3a0-5a74-b145-2485-d6d871be945b@arm.com>
 <20210520172713.GF12251@arm.com>
 <5eec330f-63c0-2af8-70f8-ba9b643e2558@arm.com>
 <20210524181129.GI14645@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <58345eca-6e5f-0faa-e47d-e9149d73f6c5@arm.com>
Date: Thu, 27 May 2021 08:50:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524181129.GI14645@arm.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 24/05/2021 19:11, Catalin Marinas wrote:
> On Fri, May 21, 2021 at 10:42:09AM +0100, Steven Price wrote:
>> On 20/05/2021 18:27, Catalin Marinas wrote:
>>> On Thu, May 20, 2021 at 04:58:01PM +0100, Steven Price wrote:
>>>> On 20/05/2021 13:05, Catalin Marinas wrote:
>>>>> On Mon, May 17, 2021 at 01:32:38PM +0100, Steven Price wrote:
>>>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>>>> index e89a5e275e25..4b6c83beb75d 100644
>>>>>> --- a/arch/arm64/kvm/arm.c
>>>>>> +++ b/arch/arm64/kvm/arm.c
>>>>>> @@ -1309,6 +1309,65 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>>>>>>  	}
>>>>>>  }
>>>>>>  
>>>>>> +static int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>>>>>> +				      struct kvm_arm_copy_mte_tags *copy_tags)
>>>>>> +{
>>>>>> +	gpa_t guest_ipa = copy_tags->guest_ipa;
>>>>>> +	size_t length = copy_tags->length;
>>>>>> +	void __user *tags = copy_tags->addr;
>>>>>> +	gpa_t gfn;
>>>>>> +	bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
>>>>>> +	int ret = 0;
>>>>>> +
>>>>>> +	if (copy_tags->reserved[0] || copy_tags->reserved[1])
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	gfn = gpa_to_gfn(guest_ipa);
>>>>>> +
>>>>>> +	mutex_lock(&kvm->slots_lock);
>>>>>> +
>>>>>> +	while (length > 0) {
>>>>>> +		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
>>>>>> +		void *maddr;
>>>>>> +		unsigned long num_tags = PAGE_SIZE / MTE_GRANULE_SIZE;
>>>>>> +
>>>>>> +		if (is_error_noslot_pfn(pfn)) {
>>>>>> +			ret = -EFAULT;
>>>>>> +			goto out;
>>>>>> +		}
>>>>>> +
>>>>>> +		maddr = page_address(pfn_to_page(pfn));
>>>>>> +
>>>>>> +		if (!write) {
>>>>>> +			num_tags = mte_copy_tags_to_user(tags, maddr, num_tags);
>>>>>> +			kvm_release_pfn_clean(pfn);
>>>>>
>>>>> Do we need to check if PG_mte_tagged is set? If the page was not faulted
>>>>> into the guest address space but the VMM has the page, does the
>>>>> gfn_to_pfn_prot() guarantee that a kvm_set_spte_gfn() was called? If
>>>>> not, this may read stale tags.
>>>>
>>>> Ah, I hadn't thought about that... No I don't believe gfn_to_pfn_prot()
>>>> will fault it into the guest.
>>>
>>> It doesn't indeed. What it does is a get_user_pages() but it's not of
>>> much help since the VMM pte wouldn't be tagged (we would have solved
>>> lots of problems if we required PROT_MTE in the VMM...)
>>
>> Sadly it solves some problems and creates others :(
> 
> I had some (random) thoughts on how to make things simpler, maybe. I
> think most of these races would have been solved if we required PROT_MTE
> in the VMM but this has an impact on the VMM if it wants to use MTE
> itself. If such requirement was in place, all KVM needed to do is check
> PG_mte_tagged.
> 
> So what we actually need is a set_pte_at() in the VMM to clear the tags
> and set PG_mte_tagged. Currently, we only do this if the memory type is
> tagged (PROT_MTE) but it's not strictly necessary.
> 
> As an optimisation for normal programs, we don't want to do this all the
> time but the visible behaviour wouldn't change (well, maybe for ptrace
> slightly). However, it doesn't mean we couldn't for a VMM, with an
> opt-in via prctl(). This would add a MMCF_MTE_TAG_INIT bit (couldn't
> think of a better name) to mm_context_t.flags and set_pte_at() would
> behave as if the pte was tagged without actually mapping the memory in
> user space as tagged (protection flags not changed). Pages that don't
> support tagging are still safe, just some unnecessary ignored tag
> writes. This would need to be set before the mmap() for the guest
> memory.
> 
> If we want finer-grained control we'd have to store this information in
> the vma flags, in addition to VM_MTE (e.g. VM_MTE_TAG_INIT) but without
> affecting the actual memory type. The easiest would be another pte bit,
> though we are short on them. A more intrusive (not too bad) approach is
> to introduce a set_pte_at_vma() and read the flags directly in the arch
> code. In most places where set_pte_at() is called on a user mm, the vma
> is also available.
> 
> Anyway, I'm not saying we go this route, just thinking out loud, get
> some opinions.

Does get_user_pages() actually end up calling set_pte_at() normally? If
not then on the normal user_mem_abort() route although we can easily
check VM_MTE_TAG_INIT there's no obvious place to hook in to ensure that
the pages actually allocated have the PG_mte_tagged flag.

I'm also not sure how well this would work with the MMU notifiers path
in KVM. With MMU notifiers (i.e. the VMM replacing a page in the
memslot) there's not even an obvious hook to enforce the VMA flag. So I
think we'd end up with something like the sanitise_mte_tags() function
to at least check that the PG_mte_tagged flag is set on the pages
(assuming that the trigger for the MMU notifier has done the
corresponding set_pte_at()). Admittedly this might close the current
race documented there.

It also feels wrong to me to tie this to a process with prctl(), it
seems much more normal to implement this as a new mprotect() flag as
this is really a memory property not a process property. And I think
we'll find some scary corner cases if we try to associate everything
back to a process - although I can't instantly think of anything that
will actually break.

>>> Another thing I forgot to ask, what's guaranteeing that the page
>>> supports tags? Does this ioctl ensure that it would attempt the tag
>>> copying from some device mapping? Do we need some kvm_is_device_pfn()
>>> check? I guess ZONE_DEVICE memory we just refuse to map in an earlier
>>> patch.
>>
>> Hmm, nothing much. While reads are now fine (the memory won't have
>> PG_mte_tagged), writes could potentially happen on ZONE_DEVICE memory.
> 
> I don't think it's a problem for writes either as the host wouldn't map
> such memory as tagged. It's just that it returns zeros and writes are
> ignored, so we could instead return an error (I haven't checked your
> latest series yet).

The latest series uses pfn_to_online_page() to reject ZONE_DEVICE early.

>>>> 		} else {
>>>> 			num_tags = mte_copy_tags_from_user(maddr, tags,
>>>> 							MTE_GRANULES_PER_PAGE);
>>>> 			kvm_release_pfn_dirty(pfn);
>>>> 		}
>>>>
>>>> 		if (num_tags != MTE_GRANULES_PER_PAGE) {
>>>> 			ret = -EFAULT;
>>>> 			goto out;
>>>> 		}
>>>>
>>>> 		if (write)
>>>> 			test_and_set_bit(PG_mte_tagged, &page->flags);
>>>
>>> I think a set_bit() would do, I doubt it's any more efficient. But why
>>
>> I'd seen test_and_set_bit() used elsewhere (I forget where now) as a
>> slightly more efficient approach. It complies down to a READ_ONCE and a
>> conditional atomic, vs a single non-conditional atomic. But I don't have
>> any actual data on the performance and this isn't a hot path, so I'll
>> switch to the more obvious set_bit().
> 
> Yeah, I think I've seen this as well. Anyway, it's probably lost in the
> noise of tag writing here.
> 

Agreed.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
