Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519962E093B
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116276; cv=none; b=Beq3gI0qsfanJMdoo/S3dPSPSxVyG9/Flh6EBkX6qLbudcSQ15WUoGGEL0UBmdJo+upoV6Dvv46Eu1WOWKgEGkIo5Vaa80jbcVPDXLcyIhTjS4eG8WpCkqEAJuWo4cg7LFUTCRi236geBgRDHcpH45DwW6EbgAJizZ94xHXHkfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116276; c=relaxed/simple;
	bh=dxma/JmZ6o/YZ5FlfOynVEJl94kUhfodB6bptkyLfbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpYBGjPuSmqprleuYjQwizgLm0cW556YsPdOJA2bb65eFJlwSFt/cJjjMX6stdbi73YjVKMokAnjd74j57FaPQw8H8GougxCLPYWx2qVI8FGzoybmbB1Tvrih62gfSZEKg/cibvoKwGuqCglL9UCCFVNy0WS1Ioz7yg+OoBHfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ei0aI/lH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ei0aI/lH"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso6791025a91.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 09:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116275; x=1753721075; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4x9weyqk5iszgR+emVch9BaS5KFFqt0IQ3wLvBJxPdc=;
        b=ei0aI/lHOTXuZaqulh90PYPVrGwgt0XK7XKK/oHJ/i0RgASBull3RbXDZRjIovXGMB
         QcdpHBBMBqVsRZlM5wCgxkuGcuKrL2IQZ1KEAoe2ecOw5U2R7hOt6unc5D5Gtr8R+tfq
         EjoUb3W3wy9CUc+hRzXVU+4af+BHC90liyj5j6nuoqBNddJGDL6KakgGIkw5QLyIhKnJ
         GalACfuyh+M0pFmBJBNRS2/Pd9s46rQh5Fd5+SjHNCuhDjQUH3jCsAHNJFKBx6P2W2gc
         xWKBWO2CvdERDDNelKBvROc9SoR/kDGLRYRniY9b2rt4ezv3OFo2ZMg6jD1ep4BHBtIV
         QAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116275; x=1753721075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4x9weyqk5iszgR+emVch9BaS5KFFqt0IQ3wLvBJxPdc=;
        b=uE0UAFen1Z47N56JqCbkL925MpfX16aQP5G998kYKHeMLkbpvj6XY1hFBj/QttsMb8
         +GS9hkCC+e3RFx/5DrQO1s/IgKssMpIaB//VTzCzc+Z2YINhO4KYenUZUkCewYANZMFy
         Wk0tGTa6D187cJgOyhmNhDVXRbDEDC+PLwEa3X8pNP6JSptR2GkcdTcdrJ/73tmSaVKV
         IQpWaIKWa2QcvvYZuoiL8fBQc0rPdVZnJC8xRZm7EXl6/ajBC/MZ7eNltf4Oxd39DK1+
         9mt13/DAvBlh081YRDYZm0XbxdGGAF7C2L5K8+FtrhU5vGETKIoauGkl8yONwb3VIani
         nGgA==
X-Forwarded-Encrypted: i=1; AJvYcCXxc+Ggd0LFQa9d0pOKnAAJjIrqv/2zjUso2iBkA8PApY4b1h3SG0b9rh7uJ3a4NlZ/5odJ9OI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaUX3DwIyiLL4jlfsIjdDMdnls4TmK15n1eZQY7LZeW+Doajee
	jwsNTfmyXjxZhLwAnjHl7JfvnBUR0XLa7l33uTx5eXF0XF576Dpmu6u3qhCxNC2ymUGxL4W8ru0
	+glHA5w==
X-Google-Smtp-Source: AGHT+IHLtmM9b2ohCo6v8xL5lzq5k6sLkOhmrbwVm3iSaR1J0L8EXLNkJNiYHZYz68JZXhiAQifqzelMv8o=
X-Received: from pjk13.prod.google.com ([2002:a17:90b:558d:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00c:b0:311:c1ec:7d05
 with SMTP id 98e67ed59e1d1-31caf92238dmr25136631a91.35.1753116274516; Mon, 21
 Jul 2025 09:44:34 -0700 (PDT)
Date: Mon, 21 Jul 2025 09:44:33 -0700
In-Reply-To: <20250717162731.446579-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
Message-ID: <aH5ucRmtSjzJcaxf@google.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
> Introduce kvm_arch_supports_gmem() to explicitly indicate whether an
> architecture supports guest_memfd.
> 
> Previously, kvm_arch_has_private_mem() was used to check for guest_memfd
> support. However, this conflated guest_memfd with "private" memory,
> implying that guest_memfd was exclusively for CoCo VMs or other private
> memory use cases.
> 
> With the expansion of guest_memfd to support non-private memory, such as
> shared host mappings, it is necessary to decouple these concepts. The
> new kvm_arch_supports_gmem() function provides a clear way to check for
> guest_memfd support.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++-
>  include/linux/kvm_host.h        | 11 +++++++++++
>  virt/kvm/kvm_main.c             |  4 ++--
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index acb25f935d84..bde811b2d303 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2277,8 +2277,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)

Don't support/use macros, just make kvm_arch_supports_gmem() a "normal" arch hook.
kvm_arch_has_private_mem() is a macro so that kvm_arch_nr_memslot_as_ids() can
resolve to a compile-time constant when CONFIG_KVM_GMEM is false, and so that it's
a trivial check when true.

kvm_arch_supports_gmem() is only ever used in slow paths, check_memory_region_flags()
and kvm_vm_ioctl_check_extension_generic().  Of course, after my suggestions from
patch 2, it goes away completely.

>  #else
>  #define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_supports_gmem(kvm) false

This is silly.  It adds code to x86 *and* makes the generic code more complex.
Again, a moot point in the end, but for future reference this isn't a pattern we
should encourage.
