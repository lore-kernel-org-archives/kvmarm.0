Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE99C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 12:06:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18E69611AB
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 12:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18E69611AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FBC64B45C;
	Thu, 20 May 2021 08:06:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AHat8SUcW-OY; Thu, 20 May 2021 08:06:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7410E4B478;
	Thu, 20 May 2021 08:06:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F734B460
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 08:06:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QlWjuDWFcoNS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 08:06:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E83994B45C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 08:06:02 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E1661059;
 Thu, 20 May 2021 12:05:58 +0000 (UTC)
Date: Thu, 20 May 2021 13:05:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 7/8] KVM: arm64: ioctl to fetch/store tags in a guest
Message-ID: <20210520120556.GC12251@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-8-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210517123239.8025-8-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Mon, May 17, 2021 at 01:32:38PM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 24223adae150..b3edde68bc3e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,17 @@ struct kvm_vcpu_events {
>  	__u32 reserved[12];
>  };
>  
> +struct kvm_arm_copy_mte_tags {
> +	__u64 guest_ipa;
> +	__u64 length;
> +	void __user *addr;
> +	__u64 flags;
> +	__u64 reserved[2];

I forgot the past discussions, what's the reserved for? Future
expansion?

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e89a5e275e25..4b6c83beb75d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1309,6 +1309,65 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>  	}
>  }
>  
> +static int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> +				      struct kvm_arm_copy_mte_tags *copy_tags)
> +{
> +	gpa_t guest_ipa = copy_tags->guest_ipa;
> +	size_t length = copy_tags->length;
> +	void __user *tags = copy_tags->addr;
> +	gpa_t gfn;
> +	bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
> +	int ret = 0;
> +
> +	if (copy_tags->reserved[0] || copy_tags->reserved[1])
> +		return -EINVAL;
> +
> +	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
> +		return -EINVAL;
> +
> +	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	gfn = gpa_to_gfn(guest_ipa);
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	while (length > 0) {
> +		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
> +		void *maddr;
> +		unsigned long num_tags = PAGE_SIZE / MTE_GRANULE_SIZE;
> +
> +		if (is_error_noslot_pfn(pfn)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		maddr = page_address(pfn_to_page(pfn));
> +
> +		if (!write) {
> +			num_tags = mte_copy_tags_to_user(tags, maddr, num_tags);
> +			kvm_release_pfn_clean(pfn);

Do we need to check if PG_mte_tagged is set? If the page was not faulted
into the guest address space but the VMM has the page, does the
gfn_to_pfn_prot() guarantee that a kvm_set_spte_gfn() was called? If
not, this may read stale tags.

> +		} else {
> +			num_tags = mte_copy_tags_from_user(maddr, tags,
> +							   num_tags);
> +			kvm_release_pfn_dirty(pfn);
> +		}

Same question here, if the we can't guarantee the stage 2 pte being set,
we'd need to set PG_mte_tagged.

> +
> +		if (num_tags != PAGE_SIZE / MTE_GRANULE_SIZE) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		gfn++;
> +		tags += num_tags;
> +		length -= PAGE_SIZE;
> +	}
> +
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +	return ret;
> +}
> +

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
