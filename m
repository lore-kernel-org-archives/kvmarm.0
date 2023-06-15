Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42415EAF5
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686859315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8IbbP+x6BA+CbR8PuWf9bFHgUN9aUhHhdqxdWI7RMB0=;
	b=JmsjmywGsEXTvqlagnrTp4dTikQzGg8tIJpyvzFF27Qg5wcScpdimw0uE53DwbEe4yTs7o
	QiXtTw+qCQeLH6NRgue/3ZBM7Etbv0ydU5LIRwHdQHZv6qjhmt9A4CBjnbrIB9rn1SUaoO
	vkkgPPsXGPDmply/ICt2I6l1vsfrXTU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-EPyH7XG2OtGMAcBmPehFhA-1; Thu, 15 Jun 2023 16:01:52 -0400
X-MC-Unique: EPyH7XG2OtGMAcBmPehFhA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62fea7a5de9so158846d6.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 13:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686859311; x=1689451311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IbbP+x6BA+CbR8PuWf9bFHgUN9aUhHhdqxdWI7RMB0=;
        b=KKTm1ARXqhzLNuQUd4UGHIO7YUbySLDvVzHZZLdtLTF8UM3uZkF6U8ezmULRUJ5TSc
         sOs+7LQ9gMWkrU3j/1jQNIwTUiMB3m7P42KzzgvXXNsLNjrW/GceC4cIvYopWiKVIPOJ
         CWdlc63m8VAOb9Z8CcS5Tv5mgSvisMAV3l07OVdMO0kLAWujNVFyFjW3sDg1JZhvGQHv
         yjtRDGcj/k7pKlW0bjL511cab7T9oLaNhsolke7saPRKxh4QoRu+Qc/HnDBvlVx8poeP
         QRJgOee5xdOVza2/nXphuA0PelJ7bycmqOurZTn/krxICSSlQm5Pvf9mg0bqbdr8161h
         0PRA==
X-Gm-Message-State: AC+VfDxk42CixGqxrN5yv9KGT4Z4heRH1IOVNG0OVURq+OnGYOggtj0d
	qAagzFtfkTa0wLX/RizBK/3t+f1+H8DZzdeDA+aJ4bD345/7CCRebcP4anL5TFiNRsK2v/g+DhA
	3RkmDaw7gyu9U9Udv
X-Received: by 2002:ad4:5de8:0:b0:626:2305:6073 with SMTP id jn8-20020ad45de8000000b0062623056073mr13825qvb.4.1686859311724;
        Thu, 15 Jun 2023 13:01:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4RMNRmKAg6OyzyvKUac88wdq6WG114AHscBN3XdznQNbojY/IbUhU0k7xX72rv1YrIiRdnew==
X-Received: by 2002:ad4:5de8:0:b0:626:2305:6073 with SMTP id jn8-20020ad45de8000000b0062623056073mr13790qvb.4.1686859311408;
        Thu, 15 Jun 2023 13:01:51 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id hr6-20020a05621423c600b006263735a9adsm6122536qvb.112.2023.06.15.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 13:01:50 -0700 (PDT)
Date: Thu, 15 Jun 2023 16:01:49 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, mtosatti@redhat.com, maz@kernel.org,
	will@kernel.org, c.dall@virtualopensystems.com, david@redhat.com,
	aarcange@redhat.com, shahuang@redhat.com, hshuai@redhat.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Message-ID: <ZItuLYyDt10U/ytb@x1n>
References: <20230615054259.14911-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Jun 15, 2023 at 03:42:59PM +1000, Gavin Shan wrote:
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
>   CPU-A                    CPU-B
>   -----                    -----
>                            ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                            kvm_vm_ioctl_set_memory_region
>                            kvm_set_memory_region
>                            __kvm_set_memory_region
>                            kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                              kvm_invalidate_memslot
>                                kvm_copy_memslot
>                                kvm_replace_memslot
>                                kvm_swap_active_memslots        (A)
>                                kvm_arch_flush_shadow_memslot   (B)
>   same page sharing by KSM
>   kvm_mmu_notifier_invalidate_range_start
>         :
>   kvm_mmu_notifier_change_pte
>     kvm_handle_hva_range
>     __kvm_handle_hva_range
>     kvm_set_spte_gfn            (C)
>         :
>   kvm_mmu_notifier_invalidate_range_end
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
>     suggested by Sean. Improved changelog to describe how the fixes
>     tag is given.

True.. FWIW:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

