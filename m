Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FED2DCF6E
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116333; cv=none; b=YH6MeJARAjxiAeI+tY0aOERJWnirPp60N9IzLd88XcCqFvT5oz5amj9BCttuk51TuL63g37h8WsyRnhTVk28QJmp5ssZhEwEui5LhmT/+EB1FK814MXBCFAic6+5YzhRlY8i7EduJy5gpIUhkv47+ecj1s1kjLDpyNPtVJk7rRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116333; c=relaxed/simple;
	bh=+70v7JsD6OXZVclUcpO6YzlSGpJUsHkQNcB/kd2Vn7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lh5A7S3E6CNdBjzfkIs0MRdH0X70sAUiwXQjT2UuvAbpB13WehWvcmRkxF64y0Q56nNspQT1XFovabcEj1ZzlYf5zdfhhNv6IEomjbwKyB1a5EdTLLkT+IT8Jcl2gP8+X1WQ1QWtt8tOKheJKPpI2Bq6GUPIdfSvUqwpdE3dveA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vN5VJGTw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vN5VJGTw"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2356ce55d33so75054075ad.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 09:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116331; x=1753721131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAOibZEvB75yoGxnODpftmDSDVcEbsFLE1qXCbwGYCg=;
        b=vN5VJGTw2u2CuyzM3NBrjgwDMWpYh35uaJ1mfenbuZH3641nwRu0W+sBXpDD2p/C92
         eXEP+xVEq7ZMYwzuQwPYYzdoUYzuZlASSygF8qvV9fuRnXiz+OG7pGcEe6u1FxuHq6Eh
         1nHkFFUw5nQtnZMQRV4M+7CVc9cj54ZnvBCbtv42jhnPfv4DYVzezgDGIUTLdz48ewXj
         PwcD5BO9ArBfihpi+fUViTwSPpuczCJ5kf+lN4tzpGhvzXOyj4x1mzdV1l9TGLYS7xON
         4q799hWHikppCQLmqZ0qdl8M2niukkSFgPfM546B7D7LSuEdCrwpMGG1mU7jYXg+Hkb/
         qIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116331; x=1753721131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yAOibZEvB75yoGxnODpftmDSDVcEbsFLE1qXCbwGYCg=;
        b=j7V2wWSN99cbNRzctkYCVrwH1dKrY8fUBFSY8kkdD3Ii1W1P4f8LdyJAJg/bN0bnNU
         ZjKHcs/COBb+FeEbE+40nm7Cgh7NFS8450MRXa7Pofcnw7arDzhYu+X8Pc+i+6o1rXpx
         1fZYs1Kefs6gJY/OswCItBAv+GMuvHUItwn1de0q3M8nm4V4qDMBvSTguxoUzdyNLCs4
         KFqmxy/tvYa8jitzb9ItxfBoNLPUBc+LvByZtn7PFR6rLI6pFQ9bYVbQrchmilG+X7OH
         mR/SydH4Z2zOQamGwfv3tyhywRB4uXlefKU7BvULzLuL7wvQy+el5lLx6234q9MAtmtu
         Xh+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3mU1p8iq9MpPZ6A5oE0MJN7N/5OWHURMOUEk0Hv5/WhxODS1y1SfV2oHG/iUjQUgMcf06+Yo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtoAnbZ4yhK7KzV6+/a6PtLZtSBSlfL+mXOAvwfiQyrfLFrc3V
	FJEiA+9hxQIbsYLekpwqDx1nUJ74wSB+vVxkcxPFA08HiXPlHo3MQ9PsVs9ivLXa29AaUG65LNG
	5yt8rxw==
X-Google-Smtp-Source: AGHT+IHu1HfCgvYEV3fuK82lq6nrK2dBiNzDor9LvjKKktGOdzxraTRt3N+GgvdklqDV8NTxdW/4WHyUTmU=
X-Received: from plbkn4.prod.google.com ([2002:a17:903:784:b0:23c:7695:dcc5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebcb:b0:234:e8db:432d
 with SMTP id d9443c01a7336-23e3035cbe7mr243642325ad.39.1753116331166; Mon, 21
 Jul 2025 09:45:31 -0700 (PDT)
Date: Mon, 21 Jul 2025 09:45:29 -0700
In-Reply-To: <20250717162731.446579-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-5-tabba@google.com>
Message-ID: <aH5uqeQqvzgJOCN0@google.com>
Subject: Re: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> Introduce a new boolean member, supports_gmem, to kvm->arch.
> 
> Previously, the has_private_mem boolean within kvm->arch was implicitly
> used to indicate whether guest_memfd was supported for a KVM instance.
> However, with the broader support for guest_memfd, it's not exclusively
> for private or confidential memory. Therefore, it's necessary to
> distinguish between a VM's general guest_memfd capabilities and its
> support for private memory.
> 
> This new supports_gmem member will now explicitly indicate guest_memfd
> support for a given VM, allowing has_private_mem to represent only
> support for private memory.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

NAK, this introduces unnecessary potential for bugs, e.g. KVM will get a false
negative if kvm_arch_supports_gmem() is invoked before kvm_x86_ops.vm_init().

Patch 2 makes this a moot point because kvm_arch_supports_gmem() can simply go away.

> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/svm/svm.c          | 1 +
>  arch/x86/kvm/vmx/tdx.c          | 1 +
>  arch/x86/kvm/x86.c              | 4 ++--
>  4 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index bde811b2d303..938b5be03d33 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1348,6 +1348,7 @@ struct kvm_arch {
>  	u8 mmu_valid_gen;
>  	u8 vm_type;
>  	bool has_private_mem;
> +	bool supports_gmem;
>  	bool has_protected_state;
>  	bool pre_fault_allowed;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> @@ -2277,7 +2278,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> -#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
> +#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
>  #else
>  #define kvm_arch_has_private_mem(kvm) false
>  #define kvm_arch_supports_gmem(kvm) false
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab9b947dbf4f..d1c484eaa8ad 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5181,6 +5181,7 @@ static int svm_vm_init(struct kvm *kvm)
>  		to_kvm_sev_info(kvm)->need_init = true;
>  
>  		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
> +		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
>  		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
>  	}
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f31ccdeb905b..a3db6df245ee 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -632,6 +632,7 @@ int tdx_vm_init(struct kvm *kvm)
>  
>  	kvm->arch.has_protected_state = true;
>  	kvm->arch.has_private_mem = true;
> +	kvm->arch.supports_gmem = true;
>  	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 357b9e3a6cef..adbdc2cc97d4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12780,8 +12780,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  		return -EINVAL;
>  
>  	kvm->arch.vm_type = type;
> -	kvm->arch.has_private_mem =
> -		(type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
>  	/* Decided by the vendor code for other VM types.  */
>  	kvm->arch.pre_fault_allowed =
>  		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 
