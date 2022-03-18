Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FE2C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 05:03:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BA949ECB;
	Fri, 18 Mar 2022 01:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ryWU6dgftldr; Fri, 18 Mar 2022 01:03:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96CE040CDE;
	Fri, 18 Mar 2022 01:03:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E0D40B78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:03:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2m796ViRZdAX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 01:03:51 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2848D40B41
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:03:51 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id n15so6191063plh.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 22:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :references:from:in-reply-to:content-transfer-encoding;
 bh=4ih7n004nQWlVsoSJhLNCfTTq+AS0JbqXkaNnwGbseg=;
 b=tJfkV22f2OYy9qGTj/RiMQ3geg4QfKu0LQRUFwGdVS/9G/LBIdg3l3AK2W96SrQ9aK
 eYCChMwFErYhPrKvJpdqRwj1vtia2kKUrWyVkBYKGTkyS3P1ZJDmQO3nwpTYauxm+rKW
 0xLKKCXxCGCg+ncNf+g6SXcnvlSpGKRifCBiM2M44L1l4/sog0oRxA7sFa2Invq69Xdn
 n7Qyj/j/GvDHFE3T+J/7uGeXfSTAYDvMyuaHeEULF+8HUSPmAzAseXcRzB6VfoyBKyg0
 3OYU7a7HkzFhiFD/jpT6cgxJU4EEDQlyaDM4TO9cLj17yclbv1Aus7i+5OY8Ll2CNstX
 xsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=4ih7n004nQWlVsoSJhLNCfTTq+AS0JbqXkaNnwGbseg=;
 b=Uxo9Wwq4ZfMkBX45GHD/IdjhPwYvRjoGXGX7WE3I819dKbz+BUh0yp6XmzrAPddXNQ
 3zSS5Vb3Bw80iu1h/4TzVRkt21TjptwaRTuaUuJP0VhETT5O3CdZ87VajFyveLdli0GV
 bKwcq/6mJ1nKXvud1WSDw2yDI/Owf48NJFCx9BPJLn0vI3VOQVjgyBugmbdjSP29VWEV
 eiHKqvJ+44tBZ0Ff7KXOat0bCamMF2egI7Lx991a1NW36zqlLvwK8xkNPJbXiLiuUCRK
 TVyUXdnFx5qxtTNE/HdyqTjh964/S0oT08EV4CmMUfuEPQXMnsMMzhJaJsZ/qy4gETLK
 q4wg==
X-Gm-Message-State: AOAM532wKwkosx4E6GX8H+mdglVw7TX1LTwp9UpfridwGcw6X+J0vkTI
 GZtdAzv+earpy5gp5P5EpvSD2g==
X-Google-Smtp-Source: ABdhPJwsmnxgcDNSHRkP6oqX5wjpiHpuqfKbk7ZWm+7Fy71fwAPlmXtZzOMXJomPFl8TWzuuPe64fw==
X-Received: by 2002:a17:902:7797:b0:154:b6d:31f2 with SMTP id
 o23-20020a170902779700b001540b6d31f2mr1775261pll.39.1647579829949; 
 Thu, 17 Mar 2022 22:03:49 -0700 (PDT)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 bh3-20020a056a02020300b00378b62df320sm6544803pgb.73.2022.03.17.22.03.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 17 Mar 2022 22:03:49 -0700 (PDT)
Message-ID: <8edcae54-b7e2-1159-5cfe-74e395ab535b@google.com>
Date: Thu, 17 Mar 2022 22:03:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v5 06/38] KVM: arm64: Delay tag scrubbing for locked
 memslots until a VCPU runs
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-7-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
In-Reply-To: <20211117153842.302159-7-alexandru.elisei@arm.com>
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

Hi Alex,

On 11/17/21 7:38 AM, Alexandru Elisei wrote:
> When an MTE-enabled guest first accesses a physical page, that page must be
> scrubbed for tags. This is normally done by KVM on a translation fault, but
> with locked memslots we will not get translation faults. So far, this has
> been handled by forbidding userspace to enable the MTE capability after
> locking a memslot.
> 
> Remove this constraint by deferring tag cleaning until the first VCPU is
> run, similar to how KVM handles cache maintenance operations.
> 
> When userspace resets a VCPU, KVM again performs cache maintenance
> operations on locked memslots because userspace might have modified the
> guest memory. Clean the tags the next time a VCPU is run for the same
> reason.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  7 ++-
>   arch/arm64/include/asm/kvm_mmu.h  |  2 +-
>   arch/arm64/kvm/arm.c              | 29 ++--------
>   arch/arm64/kvm/mmu.c              | 95 ++++++++++++++++++++++++++-----
>   4 files changed, 91 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5f49a27ce289..0ebdef158020 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -114,9 +114,10 @@ struct kvm_arch_memory_slot {
>   };
>   
>   /* kvm->arch.mmu_pending_ops flags */
> -#define KVM_LOCKED_MEMSLOT_FLUSH_DCACHE	0
> -#define KVM_LOCKED_MEMSLOT_INVAL_ICACHE	1
> -#define KVM_MAX_MMU_PENDING_OPS		2
> +#define KVM_LOCKED_MEMSLOT_FLUSH_DCACHE		0
> +#define KVM_LOCKED_MEMSLOT_INVAL_ICACHE		1
> +#define KVM_LOCKED_MEMSLOT_SANITISE_TAGS	2
> +#define KVM_MAX_MMU_PENDING_OPS			3
>   
>   struct kvm_arch {
>   	struct kvm_s2_mmu mmu;
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index cbf57c474fea..2d2f902000b3 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -222,7 +222,7 @@ int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags);
>   #define kvm_mmu_has_pending_ops(kvm)	\
>   	(!bitmap_empty(&(kvm)->arch.mmu_pending_ops, KVM_MAX_MMU_PENDING_OPS))
>   
> -void kvm_mmu_perform_pending_ops(struct kvm *kvm);
> +int kvm_mmu_perform_pending_ops(struct kvm *kvm);
>   
>   static inline unsigned int kvm_get_vmid_bits(void)
>   {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 96ed48455cdd..13f3af1f2e78 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -106,25 +106,6 @@ static int kvm_lock_user_memory_region_ioctl(struct kvm *kvm,
>   	}
>   }
>   
> -static bool kvm_arm_has_locked_memslots(struct kvm *kvm)
> -{
> -	struct kvm_memslots *slots = kvm_memslots(kvm);
> -	struct kvm_memory_slot *memslot;
> -	bool has_locked_memslots = false;
> -	int idx;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_for_each_memslot(memslot, slots) {
> -		if (memslot->arch.flags & KVM_MEMSLOT_LOCK_MASK) {
> -			has_locked_memslots = true;
> -			break;
> -		}
> -	}
> -	srcu_read_unlock(&kvm->srcu, idx);
> -
> -	return has_locked_memslots;
> -}
> -
>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			    struct kvm_enable_cap *cap)
>   {
> @@ -139,8 +120,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		break;
>   	case KVM_CAP_ARM_MTE:
>   		mutex_lock(&kvm->lock);
> -		if (!system_supports_mte() || kvm->created_vcpus ||
> -		    (kvm_arm_lock_memslot_supported() && kvm_arm_has_locked_memslots(kvm))) {
> +		if (!system_supports_mte() || kvm->created_vcpus) {
>   			r = -EINVAL;
>   		} else {
>   			r = 0;
> @@ -870,8 +850,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   	if (unlikely(!kvm_vcpu_initialized(vcpu)))
>   		return -ENOEXEC;
>   
> -	if (unlikely(kvm_mmu_has_pending_ops(vcpu->kvm)))
> -		kvm_mmu_perform_pending_ops(vcpu->kvm);
> +	if (unlikely(kvm_mmu_has_pending_ops(vcpu->kvm))) {
> +		ret = kvm_mmu_perform_pending_ops(vcpu->kvm);
> +		if (ret)
> +			return ret;
> +	}
>   
>   	ret = kvm_vcpu_first_run_init(vcpu);
>   	if (ret)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 188064c5839c..2491e73e3d31 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -613,6 +613,15 @@ void stage2_unmap_vm(struct kvm *kvm)
>   				&kvm->arch.mmu_pending_ops);
>   			set_bit(KVM_LOCKED_MEMSLOT_INVAL_ICACHE,
>   				&kvm->arch.mmu_pending_ops);
> +			/*
> +			 * stage2_unmap_vm() is called after a VCPU has run, at
> +			 * which point the state of the MTE cap (either enabled
> +			 * or disabled) is final.
> +			 */
> +			if (kvm_has_mte(kvm)) {
> +				set_bit(KVM_LOCKED_MEMSLOT_SANITISE_TAGS,
> +					&kvm->arch.mmu_pending_ops);
> +			}
>   			continue;
>   		}
>   		stage2_unmap_memslot(kvm, memslot);
> @@ -956,6 +965,55 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>   	return 0;
>   }
>   
> +static int sanitise_mte_tags_memslot(struct kvm *kvm,
> +				     struct kvm_memory_slot *memslot)
> +{
> +	unsigned long hva, slot_size, slot_end;
> +	struct kvm_memory_slot_page *entry;
> +	struct page *page;
> +	int ret = 0;
> +
> +	hva = memslot->userspace_addr;
> +	slot_size = memslot->npages << PAGE_SHIFT;
> +	slot_end = hva + slot_size;
> +
> +	/* First check that the VMAs spanning the memslot are not shared... */
> +	do {
> +		struct vm_area_struct *vma;
> +
> +		vma = find_vma_intersection(current->mm, hva, slot_end);
> +		/* The VMAs spanning the memslot must be contiguous. */
> +		if (!vma) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		/*
> +		 * VM_SHARED mappings are not allowed with MTE to avoid races
> +		 * when updating the PG_mte_tagged page flag, see
> +		 * sanitise_mte_tags for more details.
> +		 */
> +		if (vma->vm_flags & VM_SHARED) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		hva = min(slot_end, vma->vm_end);
> +	} while (hva < slot_end);
> +
> +	/* ... then clear the tags. */
> +	list_for_each_entry(entry, &memslot->arch.pages.list, list) {
> +		page = entry->page;
> +		if (!test_bit(PG_mte_tagged, &page->flags)) {
> +			mte_clear_page_tags(page_address(page));
> +			set_bit(PG_mte_tagged, &page->flags);
> +		}
> +	}
> +
> +out:
> +	mmap_read_unlock(current->mm);

This appears unnecessary (taken care by the caller).



> +
> +	return ret;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
>   			  unsigned long fault_status)
> @@ -1325,14 +1383,29 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>    * - Stage 2 tables cannot be freed from under us as long as at least one VCPU
>    *   is live, which means that the VM will be live.
>    */
> -void kvm_mmu_perform_pending_ops(struct kvm *kvm)
> +int kvm_mmu_perform_pending_ops(struct kvm *kvm)
>   {
>   	struct kvm_memory_slot *memslot;
> +	int ret = 0;
>   
>   	mutex_lock(&kvm->slots_lock);
>   	if (!kvm_mmu_has_pending_ops(kvm))
>   		goto out_unlock;
>   
> +	if (kvm_has_mte(kvm) &&
> +	    (test_bit(KVM_LOCKED_MEMSLOT_SANITISE_TAGS, &kvm->arch.mmu_pending_ops))) {
> +		kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
> +			if (!memslot_is_locked(memslot))
> +				continue;
> +			mmap_read_lock(current->mm);
> +			ret = sanitise_mte_tags_memslot(kvm, memslot);
> +			mmap_read_unlock(current->mm);
> +			if (ret)
> +				goto out_unlock;
> +		}
> +		clear_bit(KVM_LOCKED_MEMSLOT_SANITISE_TAGS, &kvm->arch.mmu_pending_ops);
> +	}
> +
>   	if (test_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops)) {
>   		kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
>   			if (!memslot_is_locked(memslot))
> @@ -1349,7 +1422,7 @@ void kvm_mmu_perform_pending_ops(struct kvm *kvm)
>   
>   out_unlock:
>   	mutex_unlock(&kvm->slots_lock);
> -	return;
> +	return ret;
>   }
>   
>   static int try_rlimit_memlock(unsigned long npages)
> @@ -1443,19 +1516,6 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			ret = -ENOMEM;
>   			goto out_err;
>   		}
> -		if (kvm_has_mte(kvm)) {
> -			if (vma->vm_flags & VM_SHARED) {
> -				ret = -EFAULT;
> -			} else {
> -				ret = sanitise_mte_tags(kvm,
> -					page_to_pfn(page_entry->page),
> -					PAGE_SIZE);
> -			}
> -			if (ret) {
> -				mmap_read_unlock(current->mm);
> -				goto out_err;
> -			}
> -		}
>   		mmap_read_unlock(current->mm);
>   
>   		ret = kvm_mmu_topup_memory_cache(&cache, kvm_mmu_cache_min_pages(kvm));
> @@ -1508,6 +1568,11 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   		memslot->arch.flags |= KVM_MEMSLOT_LOCK_WRITE;
>   
>   	set_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops);
> +	/*
> +	 * MTE might be enabled after we lock the memslot, set it here
> +	 * unconditionally.
> +	 */
> +	set_bit(KVM_LOCKED_MEMSLOT_SANITISE_TAGS, &kvm->arch.mmu_pending_ops);


Since this won't be needed when the system doesn't support MTE,
shouldn't the code check if MTE is supported on the system ?

What is the reason to set this here rather than when the mte
is enabled ?
When MTE is not used, once KVM_LOCKED_MEMSLOT_SANITISE_TAGS is set,
it appears that KVM_LOCKED_MEMSLOT_SANITISE_TAGS won't be cleared
until all memslots are unlocked (Correct ?). I would think it
shouldn't be set when unnecessary or should be cleared once it turns
out to be unnecessary.

Thanks,
Reiji


>   
>   	kvm_mmu_free_memory_cache(&cache);
>   
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
