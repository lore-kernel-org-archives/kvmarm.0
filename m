Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D415BE
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 01:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686535168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y05pr+votN47QvIShcS+kviUeyaUDFFJfeTqyxPwFpM=;
	b=ZoadJBaT+5oQxUcRl1u+giDrTZusJRbjE0XkzGaDlV6PdajYlJJjM3EDzavgb9I8ra/uL7
	/iU96H1OkGIdn5XPkiT9p/aGZVSbaYlarHLsatlcYU+NRWieBoWuN+LvqLaJoqROrZT9eO
	AvDvq2yx2tYUnsukefBdvYe7n3Y7LcQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-a8wHL60aMAGOOyesAO4Jxw-1; Sun, 11 Jun 2023 21:59:27 -0400
X-MC-Unique: a8wHL60aMAGOOyesAO4Jxw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-53fe625f145so653060a12.1
        for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 18:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686535166; x=1689127166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y05pr+votN47QvIShcS+kviUeyaUDFFJfeTqyxPwFpM=;
        b=UPaPiZTkn1pO1Bd3nOijHYpZwhhvFEvwaYox0V+LbCCWlfifq5MC3W7y84icH+3z0C
         +IBd3PgV1cQQxOC+rM7d2ukFwGgHkeP6SyYjKl4ZR6jFn9bo+Gm23FBsFG0++zGtE33N
         VxQr3eDT+GLJGHDGvkzi8gSO4ejWUfbD+R1EkwARDUgBRWbWlF74psh3n2jPrSIqb0Tf
         HiMzj15swKt+MORCeMu7RWI6JLgmwHGgcP56r1euDNikbFSKBgcmhHEYoMuISqIh8Z23
         HSVjA3lEjq2ATQTF/iMBsy7jVDfa7Vb1aZ3wwb5/z0lU/c6f7Wj3Z8fSiU/7jgM4urlC
         0QhQ==
X-Gm-Message-State: AC+VfDyR/7j+tM9g+VkTYFBkFDIPkKuUu3/BBxIBhgCEXXGmaHAO6+lu
	Q0dCxGzzDkp7Ekn3HYXocaCH0hqgs2v2bOzbQAs5MOVPDmiBcNajPnZB4z47C9ng4gvr6P584gw
	scQgsbAFozygd//Tw
X-Received: by 2002:a17:902:f682:b0:1b3:d4bb:3515 with SMTP id l2-20020a170902f68200b001b3d4bb3515mr806618plg.0.1686535166159;
        Sun, 11 Jun 2023 18:59:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5wPwlyQ4MLs702LYE6rbIR57V967YGWGq5GUPUOx/3xf7DxXBcnC7QWtnpq1K1li7nppB8Wg==
X-Received: by 2002:a17:902:f682:b0:1b3:d4bb:3515 with SMTP id l2-20020a170902f68200b001b3d4bb3515mr806611plg.0.1686535165829;
        Sun, 11 Jun 2023 18:59:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n18-20020a170902d2d200b001aad4be4503sm6942445plc.2.2023.06.11.18.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 18:59:25 -0700 (PDT)
Message-ID: <2f92e6d1-c191-1d36-7488-e1bae9ce1d40@redhat.com>
Date: Mon, 12 Jun 2023 09:59:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 maz@kernel.org, seanjc@google.com, oliver.upton@linux.dev,
 aarcange@redhat.com, peterx@redhat.com, david@redhat.com, hshuai@redhat.com,
 zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20230609100420.521351-1-gshan@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609100420.521351-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/9/23 18:04, Gavin Shan wrote:
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
>      __kvm_handle_hva_range       (C)
>          :
>    kvm_mmu_notifier_invalidate_range_end
> 
> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping so that the read request for the pflash's status
> is forwarded to QEMU and emulated by it. In this way, the correct pflash's
> status can be returned from QEMU to break the infinite loop in the edk2
> firmware.
> 
> Cc: stable@vger.kernel.org # v5.13+
> Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v2: Improved changelog suggested by Marc
> ---
>   virt/kvm/kvm_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..7f81a3a209b6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>   			unsigned long hva_start, hva_end;
>   
>   			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> +			if (slot->flags & KVM_MEMSLOT_INVALID)
> +				continue;
> +
>   			hva_start = max(range->start, slot->userspace_addr);
>   			hva_end = min(range->end, slot->userspace_addr +
>   						  (slot->npages << PAGE_SHIFT));

-- 
Shaoqin

