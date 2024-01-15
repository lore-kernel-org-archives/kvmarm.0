Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510E210796
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xcWZocRL"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50edf4f4aa4so4897e87.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 06:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705329233; x=1705934033; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3074nJdUxwGh74if2bgwl0WhHx2TaEYyKeVYnV6RTR0=;
        b=xcWZocRLI3k5HRa5K+3rEdQrq0+AayP1RsS2nS0DXHVP6zOFUdOf4aH8kPFrV3m/tj
         vdJXXi3VdYiW3NvgnyTryd5M0YpKUMMsbzKg69fuhrLkwOI/32pIqI60oZun3Cx4zdHG
         /RxMn+8EK7IewV6Qdk3TufKQsj45fZuN2XtNVhmxdTKAsz3LYwX+xuyWYpdCNCcUm79C
         kZd55cg4okY7lTX4xv/m0SqAqt956dNJ7ID+D35mO4EAg58XEiO6Vx5y7yIQtIl59d9l
         SkB7mOd5dw9JH7vnMOUL/z0/mtcTQg8GgdLVBaVK42k4tW2qOoIfuiUS0AoFXnCe+q2b
         +FKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705329233; x=1705934033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3074nJdUxwGh74if2bgwl0WhHx2TaEYyKeVYnV6RTR0=;
        b=ohaUaesz6sOhYlIGWI1tStUomY2CyH/ISuILS1vw6U50bG6i22QAKjhrukHX/pZJOg
         nwc0bOdltQ7tZWTBHUmhxst5iY65cxu5UdqYnDnnf5JhlRWFDDDoHYid/XhWtfOkOZEG
         vXpsP4YM7l35eIahehn7tjl95niVYtyyeygZH6Zmp4F1lPX9FeITkdyD+7FGe3mpDhCP
         7NICVai4YjF5qatygtoKcXX5i4w0j05iELz+Fs5hrqzbSUwECpKqNw79weuNuRUgRzDo
         OFFS/43WpvlsmMVyJIHKhvKoaHoXmTQOHnM998VDUXrOZ1sMO+pf9CuwymyF0hWiV114
         4JZA==
X-Gm-Message-State: AOJu0YzxINtKc+ydKGEFastu19S+2Qf7eO261ZWF9ZL+cu6Cr1tzfs15
	zYjA5YahjjWKe2OCv2sNuHxpKFTJu0OW
X-Google-Smtp-Source: AGHT+IGLIGAhu4rPYAOpIuokHbTPnSZ1UJer5j1S0DwMiyemD4L6ZtwfZq6sG9jJNINcYk8Ix1hLhg==
X-Received: by 2002:a05:6512:3b09:b0:50e:78fa:5193 with SMTP id f9-20020a0565123b0900b0050e78fa5193mr424562lfv.2.1705329233127;
        Mon, 15 Jan 2024 06:33:53 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id i6-20020adff306000000b003377e22ffdcsm12038621wro.85.2024.01.15.06.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 06:33:52 -0800 (PST)
Date: Mon, 15 Jan 2024 14:33:50 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, smostafa@google.com, dbrazdil@google.com,
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 12/45] KVM: arm64: pkvm: Unify
 pkvm_pkvm_teardown_donated_memory()
Message-ID: <ZaVCTuM7KDSWqqaE@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-13-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-13-jean-philippe@linaro.org>

On Wed, Feb 01, 2023 at 12:52:56PM +0000, Jean-Philippe Brucker wrote:

Hi Jean,

> Tearing down donated memory requires clearing the memory, pushing the
> pages into the reclaim memcache, and moving the mapping into the host
> stage-2. Keep these operations in a single function.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  3 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 50 +++++++------------
>  3 files changed, 22 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index d4f4ffbb7dbb..021825aee854 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -86,6 +86,8 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc);
>  
>  void *pkvm_map_donated_memory(unsigned long host_va, size_t size);
>  void pkvm_unmap_donated_memory(void *va, size_t size);
> +void pkvm_teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr,
> +				  size_t dirty_size);
>  
>  static __always_inline void __load_host_stage2(void)
>  {
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 410361f41e38..cad5736026d5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -314,8 +314,7 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>  	addr = hyp_alloc_pages(&vm->pool, 0);
>  	while (addr) {
>  		memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
> -		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> -		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
> +		pkvm_teardown_donated_memory(mc, addr, 0);
>  		addr = hyp_alloc_pages(&vm->pool, 0);
>  	}
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index a3711979bbd3..c51a8a592849 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -602,27 +602,28 @@ void *pkvm_map_donated_memory(unsigned long host_va, size_t size)
>  	return va;
>  }
>  
> -static void __unmap_donated_memory(void *va, size_t size)
> +void pkvm_teardown_donated_memory(struct kvm_hyp_memcache *mc, void *va,
> +				  size_t dirty_size)
>  {
> -	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
> -				       PAGE_ALIGN(size) >> PAGE_SHIFT));
> -}
> +	size_t size = max(PAGE_ALIGN(dirty_size), PAGE_SIZE);
>  
> -void pkvm_unmap_donated_memory(void *va, size_t size)
> -{
>  	if (!va)
>  		return;
>  
> -	memset(va, 0, size);
> -	__unmap_donated_memory(va, size);
> +	memset(va, 0, dirty_size);
> +
> +	if (mc) {
> +		for (void *start = va; start < va + size; start += PAGE_SIZE)
> +			push_hyp_memcache(mc, start, hyp_virt_to_phys);
> +	}
> +
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
> +				       size >> PAGE_SHIFT));
>  }
>  
> -static void unmap_donated_memory_noclear(void *va, size_t size)
> +void pkvm_unmap_donated_memory(void *va, size_t size)
>  {
> -	if (!va)
> -		return;
> -
> -	__unmap_donated_memory(va, size);
> +	pkvm_teardown_donated_memory(NULL, va, size);
>  }
>  
>  /*
> @@ -759,18 +760,6 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  	return ret;
>  }
>  
> -static void
> -teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
> -{
> -	size = PAGE_ALIGN(size);
> -	memset(addr, 0, size);
> -
> -	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
> -		push_hyp_memcache(mc, start, hyp_virt_to_phys);
> -
> -	unmap_donated_memory_noclear(addr, size);
> -}
> -
>  int __pkvm_teardown_vm(pkvm_handle_t handle)
>  {
>  	size_t vm_size, last_ran_size;
> @@ -813,19 +802,18 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>  		vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
>  		while (vcpu_mc->nr_pages) {
>  			addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
> -			push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> -			unmap_donated_memory_noclear(addr, PAGE_SIZE);
> +			pkvm_teardown_donated_memory(mc, addr, 0);

Here we probably need to pass PAGE_SIZE as an argument instead of "0"
to make sure that we clear out the content of the page before tearing it
down.

>  		}
>  
> -		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> +		pkvm_teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>  	}
>  
>  	last_ran_size = pkvm_get_last_ran_size();
> -	teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
> -				last_ran_size);
> +	pkvm_teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
> +				     last_ran_size);
>  
>  	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> -	teardown_donated_memory(mc, hyp_vm, vm_size);
> +	pkvm_teardown_donated_memory(mc, hyp_vm, vm_size);
>  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>  	return 0;
>  
> -- 
> 2.39.0
>

Thanks,
Seb
