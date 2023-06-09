Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E674B1993B
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686333847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAp0pJ+sm+Y3KQgNoeZPqvSvGD8UdvXtUGa2VdIgLpc=;
	b=XQ8VXUnxHwB/jKbn4OTxmDZOnlZjoGnh7csllOlt5xwCs2SAv0eSl6TD01CYuQ54B1TmpJ
	bbTPaXbrPGCIDDtkTFljkH4O0C2AXQdK0YWXoCkUXul68VVFJbkWdmeTzISLl9i1x3kzN+
	RB+VHqtMbIItgHYazWEggDsSfpKnzsg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-GpM8z2-IOwmfLNI-TSFIFw-1; Fri, 09 Jun 2023 14:04:04 -0400
X-MC-Unique: GpM8z2-IOwmfLNI-TSFIFw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-75eb82ada06so45521085a.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686333843; x=1688925843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zAp0pJ+sm+Y3KQgNoeZPqvSvGD8UdvXtUGa2VdIgLpc=;
        b=aN1hCn+evkb44IOr44wADywAWnElld81a35DinejZz6Sfs/CVfvxibo1scy0yETqhd
         ufcfn+C9mOAkhNViB7uBNhlfIukEy5RbcXkRVpP7Vs7GGOCKRilJnpE4f5XfctqaRacK
         oGBybST0OU9aRSaWJzP4ZyQSUJ+f53WNOBHwneaeZjw7c6ya5bY/ScFqaHaGAOVxxrtb
         2L7XJGNl9JWoNSmxY8J2Q+pBn0KcpDpOCDfsYMg4o6NimU2mbjGNV19/TMwkt4k6sQQo
         j604OrvGqN5C9vxXvkEKaWXrWtikIZ9YlfKxe/ZUQz67GOZP382jg2ikPiAqfsXTrsGx
         Mr2w==
X-Gm-Message-State: AC+VfDzbPKgt0FIz4uc1GVv3Tl6p6ov0jaD5UU+TAP+kJjDMlt5oueNR
	p2+mSsu6bw80neaYzg2BAzTGrSasXZ9X3jwfLvavMulE5OY2sSECdcaVdTBPiglorSmoIRqtZrx
	iag/xiOyBstmPLEQL
X-Received: by 2002:a05:620a:2541:b0:75b:23a1:69e2 with SMTP id s1-20020a05620a254100b0075b23a169e2mr2352395qko.2.1686333843403;
        Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4RtNMoxDtjGYkQZW5n83BGYz2gukU3kZCJd9ZjCOGjHFFrwfCXZgSNY8VDEKzXausmue5/Hg==
X-Received: by 2002:a05:620a:2541:b0:75b:23a1:69e2 with SMTP id s1-20020a05620a254100b0075b23a169e2mr2352373qko.2.1686333843126;
        Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id o12-20020a05620a15cc00b0075b17afcc1esm1177922qkm.115.2023.06.09.11.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:04:02 -0700 (PDT)
Date: Fri, 9 Jun 2023 14:04:00 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
	seanjc@google.com, oliver.upton@linux.dev, aarcange@redhat.com,
	david@redhat.com, hshuai@redhat.com, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v2] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Message-ID: <ZINpkOCYoDBQYhdq@x1n>
References: <20230609100420.521351-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230609100420.521351-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Jun 09, 2023 at 08:04:20PM +1000, Gavin Shan wrote:
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
>     __kvm_handle_hva_range       (C)
>         :
>   kvm_mmu_notifier_invalidate_range_end
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

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

