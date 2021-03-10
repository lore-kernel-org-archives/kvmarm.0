Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA9BC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 16:47:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F3B264DE7
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 16:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F3B264DE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E567F4B618;
	Wed, 10 Mar 2021 11:47:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K86kJ3MdV-Op; Wed, 10 Mar 2021 11:47:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB5B4B614;
	Wed, 10 Mar 2021 11:47:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6234B600
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 11:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R9pw8zkJu40I for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 11:47:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887954B557
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 11:47:11 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB7E21FB;
 Wed, 10 Mar 2021 08:47:10 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 512933F800;
 Wed, 10 Mar 2021 08:47:08 -0800 (PST)
Subject: Re: [PATCH v9 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
To: Marc Zyngier <maz@kernel.org>
References: <20210301142315.30920-1-steven.price@arm.com>
 <20210301142315.30920-6-steven.price@arm.com> <87ft14xl9e.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <9f90acc8-54b1-460a-dc25-d2d84e70c9d1@arm.com>
Date: Wed, 10 Mar 2021 16:47:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87ft14xl9e.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/03/2021 17:57, Marc Zyngier wrote:
> On Mon, 01 Mar 2021 14:23:14 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The VMM may not wish to have it's own mapping of guest memory mapped
>> with PROT_MTE because this causes problems if the VMM has tag checking
>> enabled (the guest controls the tags in physical RAM and it's unlikely
>> the tags are correct for the VMM).
>>
>> Instead add a new ioctl which allows the VMM to easily read/write the
>> tags from guest memory, allowing the VMM's mapping to be non-PROT_MTE
>> while the VMM can still read/write the tags for the purpose of
>> migration.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/uapi/asm/kvm.h | 13 +++++++
>>   arch/arm64/kvm/arm.c              | 57 +++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h          |  1 +
>>   3 files changed, 71 insertions(+)
>>
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 24223adae150..5fc2534ac5df 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -184,6 +184,19 @@ struct kvm_vcpu_events {
>>   	__u32 reserved[12];
>>   };
>>   
>> +struct kvm_arm_copy_mte_tags {
>> +	__u64 guest_ipa;
>> +	__u64 length;
>> +	union {
>> +		void __user *addr;
>> +		__u64 padding;
>> +	};
>> +	__u64 flags;
> 
> I'd be keen on a couple of reserved __64s. Just in case...

Fair enough, I'll add a __u64 reserved[2];

>> +};
>> +
>> +#define KVM_ARM_TAGS_TO_GUEST		0
>> +#define KVM_ARM_TAGS_FROM_GUEST		1
>> +
>>   /* If you need to interpret the index values, here is the key: */
>>   #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
>>   #define KVM_REG_ARM_COPROC_SHIFT	16
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 46bf319f6cb7..01d404833e24 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1297,6 +1297,53 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>>   	}
>>   }
>>   
>> +static int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> +				      struct kvm_arm_copy_mte_tags *copy_tags)
>> +{
>> +	gpa_t guest_ipa = copy_tags->guest_ipa;
>> +	size_t length = copy_tags->length;
>> +	void __user *tags = copy_tags->addr;
>> +	gpa_t gfn;
>> +	bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
>> +
>> +	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
>> +		return -EINVAL;
>> +
>> +	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>> +		return -EINVAL;
> 
> It is a bit odd to require userspace to provide a page-aligned
> addr/size, as it now has to find out about the kernel's page
> size. MTE_GRANULE_SIZE-aligned values would make more sense. Is there
> an underlying reason for this?

No fundamental reason, my thoughts were:

  * It's likely user space is naturally going to be using page-aligned 
quantities during migration, so it already has to care about this.

  * It makes the loop below easier.

  * It's easy to relax the restriction in the future if it becomes a 
problem, much harder to tighten it without breaking anything.

But I can switch to MTE_GRANULE_SIZE if you'd prefer, let me know.

>> +
>> +	gfn = gpa_to_gfn(guest_ipa);
>> +
>> +	while (length > 0) {
>> +		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
>> +		void *maddr;
>> +		unsigned long num_tags = PAGE_SIZE / MTE_GRANULE_SIZE;
>> +
>> +		if (is_error_noslot_pfn(pfn))
>> +			return -ENOENT;
>> +
>> +		maddr = page_address(pfn_to_page(pfn));
>> +
>> +		if (!write) {
>> +			num_tags = mte_copy_tags_to_user(tags, maddr, num_tags);
>> +			kvm_release_pfn_clean(pfn);
>> +		} else {
>> +			num_tags = mte_copy_tags_from_user(maddr, tags,
>> +							   num_tags);
>> +			kvm_release_pfn_dirty(pfn);
>> +		}
>> +
> 
> Is it actually safe to do this without holding any lock, without
> checking anything against the mmu_notifier_seq? What if the pages are
> being swapped out? Or the memslot removed from under your feet?
> 
> It looks... dangerous. Do you even want to allow this while vcpus are
> actually running?

Umm... yeah I'm not sure how I managed to forgot the locks. This should 
be holding kvm->slots_lock to prevent the slot going under our feet. I 
was surprised that lockdep didn't catch that, until I noticed I'd 
disabled it and discovered why (the model makes it incredibly slow). 
However I've done a run with it enabled now - and with the 
kvm->slots_lock taken it's happy.

gfn_to_pfn_prot() internally calls a variant of get_user_pages() - so 
swapping out shouldn't be a problem.

In terms of running with the vcpus running - given this is going to be 
used for migration I think that's pretty much a requirement. We want to 
be able to dump the tags while executing to enable early transfer of the 
memory.

Steve

>> +		if (num_tags != PAGE_SIZE / MTE_GRANULE_SIZE)
>> +			return -EFAULT;
>> +
>> +		gfn++;
>> +		tags += num_tags;
>> +		length -= PAGE_SIZE;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   long kvm_arch_vm_ioctl(struct file *filp,
>>   		       unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -1333,6 +1380,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>   
>>   		return 0;
>>   	}
>> +	case KVM_ARM_MTE_COPY_TAGS: {
>> +		struct kvm_arm_copy_mte_tags copy_tags;
>> +
>> +		if (!kvm_has_mte(kvm))
>> +			return -EINVAL;
>> +
>> +		if (copy_from_user(&copy_tags, argp, sizeof(copy_tags)))
>> +			return -EFAULT;
>> +		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
>> +	}
>>   	default:
>>   		return -EINVAL;
>>   	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 05618a4abf7e..b75af0f9ba55 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1423,6 +1423,7 @@ struct kvm_s390_ucas_mapping {
>>   /* Available with KVM_CAP_PMU_EVENT_FILTER */
>>   #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
>>   #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
>> +#define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
>>   
>>   /* ioctl for vm fd */
>>   #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
>> -- 
>> 2.20.1
>>
>>
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
