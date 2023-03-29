Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5023710E3
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 04:50:52 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1a273b3b466so9855ad.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 21:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680065451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMKbYfJvfPn8OhLKIq7+3kjU4mVXW1gjBFDJdfKxGPY=;
        b=BJwoAvT/1xWo/Ivydhw+aCRfco2DfLYLCBlMntoiV7cIlJEViFX9vJBR7pkaZnZO//
         azKx16TqI81pGr7Nk9+ticGYcNUlFsL/7kD+i25ZvPhz3VbPFT3Gf+prB9UiBL3+vBKZ
         XZsLrZ2omTLP/3nhCAiyErL0XOA77aLXcn3Fz20hUH347TJGoX13fMJH9FRQUBsJldsV
         f6slcjfk2qqwwDQeuYpKHajbBDP5jma0BFZ0IO9E9V6Ba51M5m9jp+2SNaPovwH4CuR9
         ViWkAzSS4xuZwSt7DDlZXQk+iwstTBZZVz3RihZbNozwTDSOizOwLt4LKLF97wMbH+9t
         +bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680065451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMKbYfJvfPn8OhLKIq7+3kjU4mVXW1gjBFDJdfKxGPY=;
        b=7dehBj9i1OjkgjxY+cAiDMT2ua4898JIubjP9pJeieN6MNEGu0pcMGakMfAV0aGtNr
         fJm4C+exliSaVe9CPang+nboqXmYojXqA7dcBqU+tB42H1XNxc2dNwHigqvuYOmmnGa/
         zlBFapwyeg1ES2kntu8TxngfhWDsJ6PMR6wwukxF+gJjssp46KJCdDBiZk0xUI2Na4Dk
         dFp0kf/k/H5GWUVuAivQKyNcjDNGOstjwo9g4cZO1pl8hfGUWwBbUzo+lfSTd4+AGNeJ
         2zFnBdNkXtFM+bZ98W06eZcxV7nOLA+rVTmi34TlD6jmFJKUFXdoktD8djMiLDnamHB4
         i2tw==
X-Gm-Message-State: AAQBX9c36gMm0J3K5u5We2i/fi9Sxfxq1vdvaUAZUidh8dd0UYvWbB1b
	CP8lPMXO5wXKYF5eWoqxeHjMGKPxOdgIGuXE8EczSA==
X-Google-Smtp-Source: AKy350bXnCpONpk2prcoJtHoGxgZkKoBYk6y65s/zCoegLKB/gbO6zyCy6h31/BuhmsG7NwgQK16HQ==
X-Received: by 2002:a17:902:eb13:b0:19c:c5d4:afd2 with SMTP id l19-20020a170902eb1300b0019cc5d4afd2mr117077plb.11.1680065451458;
        Tue, 28 Mar 2023 21:50:51 -0700 (PDT)
Received: from google.com (132.111.125.34.bc.googleusercontent.com. [34.125.111.132])
        by smtp.gmail.com with ESMTPSA id qb2-20020a17090b280200b00240015b837fsm4116349pjb.2.2023.03.28.21.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:50:50 -0700 (PDT)
Date: Tue, 28 Mar 2023 21:50:46 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Message-ID: <20230329045046.anwujgkede7h2hi5@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-9-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307034555.39733-9-ricarkol@google.com>

Hi Ricardo,

On Tue, Mar 07, 2023 at 03:45:51AM +0000, Ricardo Koller wrote:
> Add a capability for userspace to specify the eager split chunk size.
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  Documentation/virt/kvm/api.rst    | 26 ++++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++++++++
>  arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c              |  3 +++
>  include/uapi/linux/kvm.h          |  1 +
>  5 files changed, 71 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..872dae7cfbe0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8380,6 +8380,32 @@ structure.
>  When getting the Modified Change Topology Report value, the attr->addr
>  must point to a byte where the value will be stored or retrieved from.
>  
> +8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +---------------------------------------
> +
> +:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +:Architectures: arm64
> +:Type: vm
> +:Parameters: arg[0] is the new chunk size.
> +:Returns: 0 on success, -EINVAL if any memslot has been created.
> +
> +This capability sets the chunk size used in Eager Page Splitting.
> +
> +Eager Page Splitting improves the performance of dirty-logging (used
> +in live migrations) when guest memory is backed by huge-pages.  This
> +optimization is enabled by default on arm64. It avoids splitting
> +huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
> +enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
> +memory region), or when using KVM_CLEAR_DIRTY_LOG.
> +
> +The chunk size specifies how many pages to break at a time, using a
> +single allocation for each chunk. Bigger the chunk size, more pages
> +need to be allocated ahead of time. A good heuristic is to pick the
> +size of the huge-pages as the chunk size.
> +
> +If the chunk size (arg[0]) is zero, then no eager page splitting is
> +performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1892a8f6032..b7755d0cbd4d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -158,6 +158,25 @@ struct kvm_s2_mmu {
>  	/* The last vcpu id that ran on each physical CPU */
>  	int __percpu *last_vcpu_ran;
>  
> +#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
> +	/*
> +	 * Memory cache used to split
> +	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
> +	 * is used to allocate stage2 page tables while splitting huge
> +	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE

Nit: s/EAGER_PAGE_SPLIT_CHUNK_SIZE/EAGER_SPLIT_CHUNK_SIZE/ ?
(or 'split_page_chunk_size' to make the comment consistent
with the field name?)


> +	 * influences both the capacity of the split page cache, and
> +	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> +	 * too high.
> +	 *
> +	 * A good heuristic to pick CHUNK_SIZE is that it should be
> +	 * the size of the huge-pages backing guest memory. If not
> +	 * known, the PMD size (usually 2M) is a good guess.
> +	 *
> +	 * Protected by kvm->slots_lock.
> +	 */
> +	struct kvm_mmu_memory_cache split_page_cache;
> +	uint64_t split_page_chunk_size;
> +
>  	struct kvm_arch *arch;
>  };
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..3468fee223ae 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -91,6 +91,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>  		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		mutex_lock(&kvm->lock);

Do we need to hold kvm->lock here ?

Thanks,
Reiji


> +		mutex_lock(&kvm->slots_lock);
> +		/*
> +		 * To keep things simple, allow changing the chunk
> +		 * size only if there are no memslots created.
> +		 */
> +		if (!kvm_are_all_memslots_empty(kvm)) {
> +			r = -EINVAL;
> +		} else {
> +			r = 0;
> +			kvm->arch.mmu.split_page_chunk_size = cap->args[0];
> +		}
> +		mutex_unlock(&kvm->slots_lock);
> +		mutex_unlock(&kvm->lock);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -288,6 +304,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>  		r = system_has_full_ptr_auth();
>  		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		if (kvm)
> +			r = kvm->arch.mmu.split_page_chunk_size;
> +		else
> +			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a2800e5c4271..898985b09321 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>  
> +	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> +	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>  	mmu->pgt = pgt;
>  	mmu->pgd_phys = __pa(pgt->pgd);
>  	return 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d77aef872a0a..af43acdc7901 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>  #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> +#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
> 
