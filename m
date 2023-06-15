Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B525EDF
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 08:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686819185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjUU9ZIccsBnD/tga66pDtvz51Usi0faNl1rzgCxArw=;
	b=g42BcAl/l3i1TAgfTOtRY0vEGP4NywwpcgewjucYLgT0CSEuIFdECWKaj3JQDCR9CHNQgr
	sKSChyuWbU/gEYY+BUxyi9D0hT5FhGACBxeG70//2au4QDuMh+WcglBgP+hjJq/rIUSs6y
	p80ZzoYq8tsB5XqwXuVIoY0lpA3OZrs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-AEJr9njcOymllGGbs-KsQw-1; Thu, 15 Jun 2023 04:53:03 -0400
X-MC-Unique: AEJr9njcOymllGGbs-KsQw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30fb1f3c30aso2226137f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 01:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686819182; x=1689411182;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjUU9ZIccsBnD/tga66pDtvz51Usi0faNl1rzgCxArw=;
        b=fLM5Q0ocXlqqWdcZlqDEi5054fL7/kpC1eyAKINsm1Zysa+Eg4nw0zseFw4LUM9b1a
         UHEmXxG7oc3SCBEYNiVJ9pnTjxkaWLhGSu+VWqZKbNHmoFfnH2udk5FeTeaLZF8lXWB4
         rYbh4Q05D/ZfdqF+LcnRDYocxzjbJMwNoGe6CBcvihql2YMYi3K4skKdpfYBIGz+IhYp
         OORvbNehYOfs+TmAJD0jl4hbRir90MYh0HCKrrffK2C8pJVfuvZOiq9VBpdMYDwoStGN
         MBnNp8iJ5DPXx6pbG8TKXz8a4aCp1MujEl/NeOWeb1kRmFHFvvqghYvEs0/WsZTJj/4u
         aR2g==
X-Gm-Message-State: AC+VfDyam2g4eDBMLFpQxK8N0WfAHi+kfRbv3gNs1I3LTz2NOJJUUPAM
	L3//OlAc1brcdfFJkFrjJKg+rFFoLXY9Za8T8bU+Sk/40pHmelS02buvdFQzul3Vgl9dZc6AsuE
	1BYiMPvk9LynjlTPZ
X-Received: by 2002:a5d:5107:0:b0:30a:782a:7f97 with SMTP id s7-20020a5d5107000000b0030a782a7f97mr9969801wrt.12.1686819182435;
        Thu, 15 Jun 2023 01:53:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4aYlrTy5DWLWDAfJHCU9pIC2oBBngBvJVkKo3JbdV8LjiX6XZQ3THbsPRGGqKexFHlyZky4Q==
X-Received: by 2002:a5d:5107:0:b0:30a:782a:7f97 with SMTP id s7-20020a5d5107000000b0030a782a7f97mr9969783wrt.12.1686819182011;
        Thu, 15 Jun 2023 01:53:02 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id h4-20020adffa84000000b0030647d1f34bsm20347917wrr.1.2023.06.15.01.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 01:53:01 -0700 (PDT)
Message-ID: <855fa10d-1211-d3d9-40a3-01a1ceaa33db@redhat.com>
Date: Thu, 15 Jun 2023 10:53:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, mtosatti@redhat.com, maz@kernel.org, will@kernel.org,
 c.dall@virtualopensystems.com, peterx@redhat.com, aarcange@redhat.com,
 shahuang@redhat.com, hshuai@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com
References: <20230615054259.14911-1-gshan@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.06.23 07:42, Gavin Shan wrote:
> We run into guest hang in edk2 firmware when KSM is kept as running on
> the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
> device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
> buffered write. The status is returned by reading the memory region of
> the pflash device and the read request should have been forwarded to QEMU
> and emulated by it. Unfortunately, the read request is covered by an
> illegal stage2 mapping when the guest hang issue occurs. The read request
> is completed with QEMU bypassed and wrong status is fetched. The edk2
> firmware runs into an infinite loop with the wrong status.
> 
> The illegal stage2 mapping is populated due to same page sharing by KSM
> at (C) even the associated memory slot has been marked as invalid at (B)
> when the memory slot is requested to be deleted. It's notable that the
> active and inactive memory slots can't be swapped when we're in the middle
> of kvm_mmu_notifier_change_pte() because kvm->mn_active_invalidate_count
> is elevated, and kvm_swap_active_memslots() will busy loop until it reaches
> to zero again. Besides, the swapping from the active to the inactive memory
> slots is also avoided by holding &kvm->srcu in __kvm_handle_hva_range(),
> corresponding to synchronize_srcu_expedited() in kvm_swap_active_memslots().
> 
>    CPU-A                    CPU-B
>    -----                    -----
>                             ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                             kvm_vm_ioctl_set_memory_region
>                             kvm_set_memory_region
>                             __kvm_set_memory_region
>                             kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                               kvm_invalidate_memslot
>                                 kvm_copy_memslot
>                                 kvm_replace_memslot
>                                 kvm_swap_active_memslots        (A)
>                                 kvm_arch_flush_shadow_memslot   (B)
>    same page sharing by KSM
>    kvm_mmu_notifier_invalidate_range_start
>          :
>    kvm_mmu_notifier_change_pte
>      kvm_handle_hva_range
>      __kvm_handle_hva_range
>      kvm_set_spte_gfn            (C)
>          :
>    kvm_mmu_notifier_invalidate_range_end
> 
> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping so that the read request for the pflash's status
> is forwarded to QEMU and emulated by it. In this way, the correct pflash's
> status can be returned from QEMU to break the infinite loop in the edk2
> firmware.
> 
> We tried a git-bisect and the first problematic commit is cd4c71835228 ("
> KVM: arm64: Convert to the gfn-based MMU notifier callbacks"). With this,
> clean_dcache_guest_page() is called after the memory slots are iterated
> in kvm_mmu_notifier_change_pte(). clean_dcache_guest_page() is called
> before the iteration on the memory slots before this commit. This change
> literally enlarges the racy window between kvm_mmu_notifier_change_pte()
> and memory slot removal so that we're able to reproduce the issue in a
> practical test case. However, the issue exists since commit d5d8184d35c9
> ("KVM: ARM: Memory virtualization setup").
> 
> Cc: stable@vger.kernel.org # v3.9+
> Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
> v3: Skip the invalid memory slots in change_pte() MMU notifier only,
>      suggested by Sean. Improved changelog to describe how the fixes
>      tag is given.
> ---
>   virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..65f94f592ff8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -686,6 +686,24 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>   
>   	return __kvm_handle_hva_range(kvm, &range);
>   }
> +
> +static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	/*
> +	 * Skipping invalid memslots is correct if and only change_pte() is
> +	 * surrounded by invalidate_range_{start,end}(), which is currently
> +	 * guaranteed by the primary MMU.  If that ever changes, KVM needs to
> +	 * unmap the memslot instead of skipping the memslot to ensure that KVM
> +	 * doesn't hold references to the old PFN.
> +	 */
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> +
> +	if (range->slot->flags & KVM_MEMSLOT_INVALID)
> +		return false;
> +
> +	return kvm_set_spte_gfn(kvm, range);
> +}
> +
>   static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   					struct mm_struct *mm,
>   					unsigned long address,
> @@ -707,7 +725,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
>   		return;
>   
> -	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
>   }
>   
>   void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,

Makes perfect sense to me as well

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

