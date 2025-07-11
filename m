Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91990A920
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 11:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752232199; cv=none; b=HFINT86L4inlYP3LvVsolEaq3MwFRm/Nl+qHvDeHFOx5qqnCyNSao2kHTzdXFw7QHtL8kkkmmj3x9o622ain6Gd5pTThgaCo3cG8YRGxrUuZwu4nsscjOsgnB6llj2YxnYs5D3hlaPaf+pPg/+jtsnNWn+dnD95Lzp/F26ORvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752232199; c=relaxed/simple;
	bh=85A02jJf5WEx+s1nM2l46kcEE5hoPxUVck5YTP4i3e0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mf/l1tZETFSjfG2P1KizNH0mUaFcQWybRsm4QArOzULY45laDjmHpDGF2kk+fZ1i25mNBgo00EgVbL8udLLcCGAlqqDKwxcJY5+g8rQZ0IZXT1rMnLgtfiOoerZ7t7ByHuBVKhMbGaWG2shEZvBQe6lM2MfdyPwhzFcMjbGvI0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pIf7k9Dc; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pIf7k9Dc"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3855fca3so148401cf.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 04:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752232196; x=1752836996; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1adRS81oh+n8n4i/QBjxAv/fs2/9/zd1hp4GUeUvO78=;
        b=pIf7k9Dc/qWwZ0MJI2qaUxOEaLyPw5/5y1o3/36bpSilbLrOedf4x1RVcarjIi1kSH
         ra1lIgG8NHV2FlBqQLQnJw65pm32gChPZGGDKA6ziik7/TYvnk7U5PJmcNI7COG+MA05
         pYxg5o51LdFir1YCP2X4DAvOj4DyVcc1kjIYHxlPJDrGjiR8UvFPyAsu8vMX9HDfzSg7
         wvJ/Zp8NNNahtcsCWcCoeUAEZF8++JLIJVpv1+ACzpIkqVHWuiKPhmg/XAfMxUy04JAS
         9F2sbogcekOF3AcWBPiYf2cN45B9TxwC2Xy454CAuaZjjg+hR5pGedYgbE6zkYCLsHTV
         1CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752232196; x=1752836996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1adRS81oh+n8n4i/QBjxAv/fs2/9/zd1hp4GUeUvO78=;
        b=BR27jApFHppb+A/zwKU/Dgz/16UZSvCuCZdFb8nRvtId1G8IQwcuc6J2HAMzZ8cUjk
         Dv7MX1h+Ylj/0CKRrhbwmRSRVugiW9oClq7fQ6Ao4WFj2d6x43iBGVluM6Jvkf/FLrIH
         8/hsqbyhUL//suDuMA7/tgt3oapqeEdqvWTcYQUOt0HbpPIdtKDqpPD1cLmI7rWbxfvH
         +1yknaBfuw06uKtYxg0NxVboTxveij8G5x9HBkiWKnZdAhics+pqwW+pWZFa+cdN1KWM
         Fq19zM5WJmwp1cLvsuCcOvxkpYnVSVryJnHwMWHgrpqveDSvgBXSvNl/noDb1NeKqJ+G
         lC3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2rgUt37lz26Cfsg0Tg1MXCV76tYS9kh8tGckDZhn272SCf8YWe2Tu/4ny2uw6qaGuIkKDxds=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy16baW4ReI6wRHh/VwTZSbmLXvpkJnghC37JKXm1DFOecMuhK3
	1A7qxrLLh9/Kt5J/tO+IYRLROQMk1hGvIAASAbWtPGKIisCEw86F+1ta/HQwroMhxg+empaA6d7
	mBciq0ZjLL5iyTkuxFfcsfmsZqgx3EibxCamFYRkH
X-Gm-Gg: ASbGncvWLMVGldxVEXPKy2+HAqNlKnUceRaj9N1JyjHguSlLPWT3RkWyIeA/7Dga9GF
	vaEl1fY27pW4fzmBAJfws0uEVweUKW3+41wkMk5omqQ5iVDEvkSydOdshYHGvCFxGGJrd970cas
	n6/pc5c1WAwJB8Va5h1R54wKSeVxjs9op2ssdH2oPodjdrGh3mI51XfgjPyp2RdrIJ4BiaRidHD
	3WSd1U=
X-Google-Smtp-Source: AGHT+IGBKlguTczLsGN7D7jbMA8nnKKR5d3w/jJqmzY0oTVBdGcJ/buS8qD/dIqG5s4GGMRAPLRGdxeOmdIRAnouGp8=
X-Received: by 2002:a05:622a:a916:b0:4a9:8b69:6537 with SMTP id
 d75a77b69052e-4a9fbf275d9mr2923021cf.22.1752232195939; Fri, 11 Jul 2025
 04:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com> <20250709105946.4009897-15-tabba@google.com>
 <6fc1edd4-8a3c-4cba-8779-461a16b5126e@redhat.com>
In-Reply-To: <6fc1edd4-8a3c-4cba-8779-461a16b5126e@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 12:09:19 +0100
X-Gm-Features: Ac12FXzb-fN6GfwAX5mOcl0uP18BvI0qeajeteMMtilzL-SP9ogjqoPftjSQs3k
Message-ID: <CA+EHjTyX5BEFUSBh0HFgrpfu16MprZuYiSp6N8mDt1C5XyYYwA@mail.gmail.com>
Subject: Re: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Fri, 11 Jul 2025 at 10:45, David Hildenbrand <david@redhat.com> wrote:
>
> On 09.07.25 12:59, Fuad Tabba wrote:
> > Enable host userspace mmap support for guest_memfd-backed memory when
> > running KVM with the KVM_X86_DEFAULT_VM type:
> >
> > * Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
> >    the architecture-specific kvm_arch_supports_gmem_mmap() macro,
> >    specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
> >    This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
> >    the default VM type can leverage guest_memfd mmap functionality on
> >    x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
> >    primarily for private memory and rely on hardware-enforced privacy,
> >    from accidentally exposing guest memory via host userspace mappings.
> >
> > * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
> >    CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
> >    This ensures that the necessary code for guest_memfd mmap support
> >    (introduced earlier) is compiled into the kernel for x86. This Kconfig
> >    option acts as a system-wide gate for the guest_memfd mmap capability.
> >    It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
> >    and then layers the mmap capability on top specifically for the
> >    default VM.
> >
> > These changes make guest_memfd a more versatile memory backing for
> > standard KVM guests, allowing VMMs to use a unified guest_memfd model
> > for both private (CoCo) and non-private (default) VMs. This is a
> > prerequisite for use cases such as running Firecracker guests entirely
> > backed by guest_memfd and implementing direct map removal for non-CoCo
> > VMs.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 9 +++++++++
> >   arch/x86/kvm/Kconfig            | 1 +
> >   arch/x86/kvm/x86.c              | 3 ++-
> >   3 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4c764faa12f3..4c89feaa1910 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2273,9 +2273,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >   #ifdef CONFIG_KVM_GMEM
> >   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> >   #define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > +      (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
> >   #else
> >   #define kvm_arch_has_private_mem(kvm) false
> >   #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_mmap(kvm) false
> >   #endif
> >
> >   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index df1fdbb4024b..239637b663dc 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -47,6 +47,7 @@ config KVM_X86
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_PRE_FAULT_MEMORY
> >       select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> > +     select KVM_GMEM_SUPPORTS_MMAP
> >       select KVM_WERROR if WERROR
>
> Given the error, likely we want to limit to 64BIT.
>
> select KVM_GMEM_SUPPORTS_MMAP if X86_64

Will do.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>
