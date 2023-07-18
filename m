Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1217F0
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 02:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689648443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cwQB/fbfOKqBwcYRAl53xVtw+hDeV12CsqqmWxF/Uhs=;
	b=GL6GRABJPLljevFMKlvCIlnlfETS2sl7ibtRDeg3mkdXaJC8733eKVHf+rAob4cTmOg4x5
	ChmvpidT6Lno1wozsxiqTw9l8rb/wVQ9uvgGsAO4Fp1uB2eTQnlJjFLfa07pWb98i5oM1Z
	VgBGLLdUENT97bxztrmR5+S1r3lrpFw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-zTsTlYD7MqC0sVGZZPGuXw-1; Mon, 17 Jul 2023 22:47:19 -0400
X-MC-Unique: zTsTlYD7MqC0sVGZZPGuXw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1bb1dfabc17so1645745ad.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 19:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689648438; x=1690253238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwQB/fbfOKqBwcYRAl53xVtw+hDeV12CsqqmWxF/Uhs=;
        b=krluDmt4Y3OA+ubJCv8rSmyJG6MZ4eennbq5AeHenYJcHoXN/ViizA5hFuHahjaR0s
         ipHF6qWBAMv2ISc5OfFo/RxKNcLnrc2cjApAgoOl/OCoY3yMZ3/5ryp21lds57MLvZNU
         1+KLvCCykRGEpuhgPfr2P0i848LrgYdEPUlBdQ6cF5vs89zafaxdYEjzNdtoyRzg7Kap
         LYF8wkLMzPPzXE9YCv1CZ0w4U9m0/0p39bZs1dIQ6Gwxw0d5oo3tTRS6EszEFGN8n4Ru
         X/9G03UTJjRLNh7t9N6xY6/w4PQbdyT/s3+MaeVDgjjIl/2mXH28bofg8Ay38PZA4L/T
         Pmng==
X-Gm-Message-State: ABy/qLbEZ8YGoJSh6Ixn/yLPit3MIvVhESj8kFNGiuczbgW1C6J8LLEA
	f/tqXQSPdTsxJghGDmY0f7LmKv0OhLVXMLGwUwn00t/ACb+WT92GqeyViFmW1TlHF0+0Wt/VBRQ
	LVPseMF/nY2poK+t0
X-Received: by 2002:a17:902:e549:b0:1b8:a8e5:e8bc with SMTP id n9-20020a170902e54900b001b8a8e5e8bcmr18120498plf.6.1689648438514;
        Mon, 17 Jul 2023 19:47:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEAYrcvz0bb1bVxwgWvPIxVNsIIeg8/Nu7iZOSs+l2yBQAAQaQ8RJT1nC3Kt00+K0crHQ8CTQ==
X-Received: by 2002:a17:902:e549:b0:1b8:a8e5:e8bc with SMTP id n9-20020a170902e54900b001b8a8e5e8bcmr18120464plf.6.1689648438131;
        Mon, 17 Jul 2023 19:47:18 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ja10-20020a170902efca00b001bb34ae3f47sm568891plb.122.2023.07.17.19.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 19:47:17 -0700 (PDT)
Message-ID: <489cafab-ca71-a13b-a0cd-75b35016ef1b@redhat.com>
Date: Tue, 18 Jul 2023 10:47:11 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 04/11] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-5-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-5-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> range-based TLB invalidation where the range is defined by the memslot.
> Now that kvm_flush_remote_tlbs_range() can be called from common code we
> can just use that and drop a bunch of duplicate code from the arch
> directories.
> 
> Note this adds a lockdep assertion for slots_lock being held when
> calling kvm_flush_remote_tlbs_memslot(), which was previously only
> asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
> but they all hold the slots_lock, so the lockdep assertion continues to
> hold true.
> 
> Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
> kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/arm.c     |  6 ------
>   arch/mips/kvm/mips.c     | 10 ++--------
>   arch/riscv/kvm/mmu.c     |  6 ------
>   arch/x86/kvm/mmu/mmu.c   | 16 +---------------
>   arch/x86/kvm/x86.c       |  2 +-
>   include/linux/kvm_host.h |  7 +++----
>   virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
>   7 files changed, 23 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c2c14059f6a8..ed7bef4d970b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1525,12 +1525,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>   					struct kvm_arm_device_addr *dev_addr)
>   {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 4b7bc39a4173..231ac052b506 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -199,7 +199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   	/* Flush slot from GPA */
>   	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>   			      slot->base_gfn + slot->npages - 1);
> -	kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +	kvm_flush_remote_tlbs_memslot(kvm, slot);
>   	spin_unlock(&kvm->mmu_lock);
>   }
>   
> @@ -235,7 +235,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
>   					new->base_gfn + new->npages - 1);
>   		if (needs_flush)
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +			kvm_flush_remote_tlbs_memslot(kvm, new);
>   		spin_unlock(&kvm->mmu_lock);
>   	}
>   }
> @@ -987,12 +987,6 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 1;
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   {
>   	int r;
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f2eb47925806..97e129620686 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   {
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
>   {
>   }
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index aaa5e336703a..b320a4254a2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6669,7 +6669,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>   	 */
>   	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
>   			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_flush_remote_tlbs_memslot(kvm, slot);
>   }
>   
>   void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> @@ -6688,20 +6688,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   	}
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	/*
> -	 * All current use cases for flushing the TLBs for a specific memslot
> -	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
> -	 * The interaction between the various operations on memslot must be
> -	 * serialized by slots_locks to ensure the TLB flush from one operation
> -	 * is observed by any other operation on the same memslot.
> -	 */
> -	lockdep_assert_held(&kvm->slots_lock);
> -	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> -}
> -
>   void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6b9bea62fb8..faeb2e307b36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12751,7 +12751,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>   		 * See is_writable_pte() for more details (the case involving
>   		 * access-tracked SPTEs is particularly relevant).
>   		 */
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +		kvm_flush_remote_tlbs_memslot(kvm, new);
>   	}
>   }
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a731967b24ff..45899ce9ed31 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1360,6 +1360,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
>   
>   void kvm_flush_remote_tlbs(struct kvm *kvm);
>   void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +				   const struct kvm_memory_slot *memslot);
>   
>   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>   int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> @@ -1388,10 +1390,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   					unsigned long mask);
>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
>   
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot);
> -#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> +#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
>   int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>   		      int *is_dirty, struct kvm_memory_slot **memslot);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 804470fccac7..58213cc4b9b9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -379,6 +379,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
>   	kvm_flush_remote_tlbs(kvm);
>   }
>   
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +				   const struct kvm_memory_slot *memslot)
> +{
> +	/*
> +	 * All current use cases for flushing the TLBs for a specific memslot
> +	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
> +	 * The interaction between the various operations on memslot must be
> +	 * serialized by slots_locks to ensure the TLB flush from one operation
> +	 * is observed by any other operation on the same memslot.
> +	 */
> +	lockdep_assert_held(&kvm->slots_lock);
> +	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> +}
> +
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {
>   	kvm_arch_flush_shadow_all(kvm);
> @@ -2191,7 +2205,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>   	}
>   
>   	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +		kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   
>   	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>   		return -EFAULT;
> @@ -2308,7 +2322,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>   	KVM_MMU_UNLOCK(kvm);
>   
>   	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +		kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   
>   	return 0;
>   }

-- 
Shaoqin

