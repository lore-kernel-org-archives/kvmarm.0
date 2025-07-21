Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464F317C21E
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119102; cv=none; b=sd3C//P49uCsclrdngTdy4TDOWVMPtTv+lSIdZJQP0lqxQLh/mIj6mMGcQklx+Slvo8Kxi3RLn1LcLBODqVKirPmVFgzLwJYgnx4JjfjGdEQ1O6KXzeADVyGM3LNikM+Dr+pjQreHSIdzK3Uo3EWHr9GrpPyvcxwjZrnS5s+VS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119102; c=relaxed/simple;
	bh=dkm0lyEKR/hUProV5PxXFoXmxP1JWKqe20DkCmt225w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHLh855w0eppLVJWe99bRB5tOBKBxBwPJYc6CN5qsq8HYBk2NY6xuM+tPKBMW9vE7xhO8ZsFj1biBY0W56G0GXhLx7anSmWgDjOXuf5dpSNdmwHhi33sKeS0MG++VSGiqr4Wvdthgwgj/8J4LwNqjY/FXK1yseu0D+Wf+MTU4hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2DqRHNFG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2DqRHNFG"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e0c573531so3394280a12.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753119100; x=1753723900; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RSln/MKxaz6pbnhToBUcsd5CJU17vyymHtLzt6u7vIs=;
        b=2DqRHNFGj/N1M7lTFnY+ZBWw81QEzrT9e4JwaKIr8gzGvaKbTDoqRY7cAwHo9ZRYCJ
         PhxgAAZ/csH8ZELWuCPIkAAGkT/CLsLRSkVxbWEqwIoYHCqryHQHTHjfucFER+ZPLGza
         QjYjbVK/zl2OuYuEmMD7vvUD6+X1Bt172X/qTQQg0n/+Bzju9KUtT/+7o64FMXkh6Yfh
         FyU/FiBfBTijcrHv0OjN2Cu4JuI2bABTGNlrcN7pJ+793NjGes0l8pLUUojGzpIoK5yc
         UNzOVIM///KHVsNq8ldVJm8+Ok9mdx7Vg+WgaoxmbJpk2fFZW891kBf7qpCzzXpObetz
         NvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753119100; x=1753723900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSln/MKxaz6pbnhToBUcsd5CJU17vyymHtLzt6u7vIs=;
        b=hvfKC9a0xyAQPObmXan+WKPbPJlp44M0nMtP5kqi209+83qjh2eOQNnwFdCbOAG8Os
         WdE8ZWPIwTSDQfAXejDE0AGK8fpL77JGGMsSmpZ9lgyqPT2AocgpiOegEPwL0xv3xo1p
         nn4itqEAEuereG4I2B3tYebkw446ZgAxLahb8HlyJIqUs5n0LvTS9ZZCikPUh9uwqBRp
         psniwtWkDrNC4Vqc7VJh6daDy/xHQXZBz5vl4s9XgTH6aAUvN5kQsg/M+BnZK2vDsFP/
         mB7oDG5m1Bj2fDe7p0Oi1jufj65M+d9b7FNvq9Yew1NfbFb1ur4ss3YZYPTnNzouzzQe
         NLDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfVn8sSba7AmsH+Igp1y8hp5Lg3A9zJlFXXFlU8XXaUNd3P09J2ekEX1oVM8mZUsqiGxFBMhY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMpQchNAiegUNwgN27G81NFFgZEtyFsj91QJXeO3ahz1oC0AjZ
	n8vOBYTghrX0PuZicIxfxMatNlZCnJY9IM/3G4Lc2Fe8l3Iln4utuZiHTyJfvR2MTUA/8+Yxisl
	KE9aeQg==
X-Google-Smtp-Source: AGHT+IHKvmg6wx/J1JbCtyV7n/8+lPoe0UGP9o7wTaBYQtOLo2cMF1vbrd7+a3IA2/sXmgwXQiNECYqTZBw=
X-Received: from pjtu4.prod.google.com ([2002:a17:90a:c884:b0:313:1c10:3595])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00b:b0:312:639:a06a
 with SMTP id 98e67ed59e1d1-31c9e79383bmr30253550a91.31.1753119100498; Mon, 21
 Jul 2025 10:31:40 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:31:38 -0700
In-Reply-To: <20250717162731.446579-20-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-20-tabba@google.com>
Message-ID: <aH55ehVij1_dzZWO@google.com>
Subject: Re: [PATCH v15 19/21] KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
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
> Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
> signals to userspace that a KVM instance supports host userspace mapping
> of guest_memfd-backed memory.
> 
> The availability of this capability is determined per architecture, and
> its enablement for a specific guest_memfd instance is controlled by the
> GUEST_MEMFD_FLAG_MMAP flag at creation time.
> 
> Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
> capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
> information regarding support for mmap in guest_memfd.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 9 +++++++++
>  include/uapi/linux/kvm.h       | 1 +
>  virt/kvm/kvm_main.c            | 4 ++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 43ed57e048a8..5169066b53b2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
>  guest_memfd range is not allowed (any number of memory regions can be bound to
>  a single guest_memfd file, but the bound ranges must not overlap).
>  
> +When the capability KVM_CAP_GMEM_MMAP is supported, the 'flags' field supports
> +GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation enables mmap()
> +and faulting of guest_memfd memory to host userspace.
> +
> +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> +guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> +consumed from guest_memfd, regardless of whether it is a shared or a private
> +fault.
> +
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
>  4.143 KVM_PRE_FAULT_MEMORY
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3beafbf306af..698dd407980f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -960,6 +960,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_GMEM_MMAP 243

KVM_CAP_GUEST_MEMFD_MMAP please.  I definitely don't want "gmem" in any of the
uAPI.

>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 46bddac1dacd..f1ac872e01e9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
>  		return !kvm || kvm_arch_supports_gmem(kvm);
> +#endif
> +#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
> +	case KVM_CAP_GMEM_MMAP:

As alluded to in my feedback in patch 2, this should be inside CONFIG_KVM_GUEST_MEMFD.

> +		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
>  #endif
>  	default:
>  		break;
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 
