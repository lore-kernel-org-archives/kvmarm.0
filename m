Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4802C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 15:58:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AFDD61163
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 15:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AFDD61163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 977E84B58D;
	Thu, 20 May 2021 11:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dMK7TnomsU8B; Thu, 20 May 2021 11:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411714B5C7;
	Thu, 20 May 2021 11:58:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C06E4B545
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 11:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxYHCYOc7ZXl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 11:58:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C43434B58D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 11:58:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 563B131B;
 Thu, 20 May 2021 08:58:05 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 804E03F73B;
 Thu, 20 May 2021 08:58:02 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 7/8] KVM: arm64: ioctl to fetch/store tags in a guest
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-8-steven.price@arm.com> <20210520120556.GC12251@arm.com>
Message-ID: <dd5ab3a0-5a74-b145-2485-d6d871be945b@arm.com>
Date: Thu, 20 May 2021 16:58:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520120556.GC12251@arm.com>
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

On 20/05/2021 13:05, Catalin Marinas wrote:
> On Mon, May 17, 2021 at 01:32:38PM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 24223adae150..b3edde68bc3e 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -184,6 +184,17 @@ struct kvm_vcpu_events {
>>  	__u32 reserved[12];
>>  };
>>  
>> +struct kvm_arm_copy_mte_tags {
>> +	__u64 guest_ipa;
>> +	__u64 length;
>> +	void __user *addr;
>> +	__u64 flags;
>> +	__u64 reserved[2];
> 
> I forgot the past discussions, what's the reserved for? Future
> expansion?

Yes - for future expansion. Marc asked for them[1]:

> I'd be keen on a couple of reserved __64s. Just in case...

[1] https://lore.kernel.org/r/87ft14xl9e.wl-maz%40kernel.org

>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index e89a5e275e25..4b6c83beb75d 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1309,6 +1309,65 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>>  	}
>>  }
>>  
>> +static int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> +				      struct kvm_arm_copy_mte_tags *copy_tags)
>> +{
>> +	gpa_t guest_ipa = copy_tags->guest_ipa;
>> +	size_t length = copy_tags->length;
>> +	void __user *tags = copy_tags->addr;
>> +	gpa_t gfn;
>> +	bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
>> +	int ret = 0;
>> +
>> +	if (copy_tags->reserved[0] || copy_tags->reserved[1])
>> +		return -EINVAL;
>> +
>> +	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
>> +		return -EINVAL;
>> +
>> +	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>> +		return -EINVAL;
>> +
>> +	gfn = gpa_to_gfn(guest_ipa);
>> +
>> +	mutex_lock(&kvm->slots_lock);
>> +
>> +	while (length > 0) {
>> +		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
>> +		void *maddr;
>> +		unsigned long num_tags = PAGE_SIZE / MTE_GRANULE_SIZE;
>> +
>> +		if (is_error_noslot_pfn(pfn)) {
>> +			ret = -EFAULT;
>> +			goto out;
>> +		}
>> +
>> +		maddr = page_address(pfn_to_page(pfn));
>> +
>> +		if (!write) {
>> +			num_tags = mte_copy_tags_to_user(tags, maddr, num_tags);
>> +			kvm_release_pfn_clean(pfn);
> 
> Do we need to check if PG_mte_tagged is set? If the page was not faulted
> into the guest address space but the VMM has the page, does the
> gfn_to_pfn_prot() guarantee that a kvm_set_spte_gfn() was called? If
> not, this may read stale tags.

Ah, I hadn't thought about that... No I don't believe gfn_to_pfn_prot()
will fault it into the guest.

>> +		} else {
>> +			num_tags = mte_copy_tags_from_user(maddr, tags,
>> +							   num_tags);
>> +			kvm_release_pfn_dirty(pfn);
>> +		}
> 
> Same question here, if the we can't guarantee the stage 2 pte being set,
> we'd need to set PG_mte_tagged.

This is arguably worse as we'll be writing tags into the guest but
without setting PG_mte_tagged - so they'll be lost when the guest then
faults the pages in. Which sounds like it should break migration.

I think the below should be safe, and avoids the overhead of setting the
flag just for reads.

Thanks,

Steve

----8<----
		page = pfn_to_page(pfn);
		maddr = page_address(page);

		if (!write) {
			if (test_bit(PG_mte_tagged, &page->flags))
				num_tags = mte_copy_tags_to_user(tags, maddr,
							MTE_GRANULES_PER_PAGE);
			else
				/* No tags in memory, so write zeros */
				num_tags = MTE_GRANULES_PER_PAGE -
					clear_user(tag, MTE_GRANULES_PER_PAGE);
			kvm_release_pfn_clean(pfn);
		} else {
			num_tags = mte_copy_tags_from_user(maddr, tags,
							MTE_GRANULES_PER_PAGE);
			kvm_release_pfn_dirty(pfn);
		}

		if (num_tags != MTE_GRANULES_PER_PAGE) {
			ret = -EFAULT;
			goto out;
		}

		if (write)
			test_and_set_bit(PG_mte_tagged, &page->flags);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
