Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D176B33062
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749139918; cv=none; b=ntKBYadBmBnZTX6XppvIDa80NAhFexIFDl811HsVpBOnmJvqZpox6uMGKQbdZ47kOB/x76DaFs7Quqa7KgGesOZ7veeqeO8+AwgorHng+5Qb5m44xyl2o7MLGp+VmLhI4bEh1+voLTwb6GItb5/AvKZU1RY79N18bZWPo5JsElw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749139918; c=relaxed/simple;
	bh=6lOtFIHKrjKKY2yPe3PXFI2Tfr8nvEQlzUWoA9G5Tr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYIw2COQbatlmC5wnovQZhByNd4Q5Rkm2LnQXQvz9DZ6W0hs20wY8hDJhxqABEEHonfWpqu+aGGWlm0PzjjXH95xMJLxmBFGtssKGYsFziXNNTtAVtoagogzKvsk58pInMt3CHi1p8O1nrq1whQtxvZAqH4PwOM0hfvUR+LD0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVnAe21n; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVnAe21n"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a58197794eso593561cf.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749139912; x=1749744712; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AVQTBJlbhCkTd304Z8LDEkMLDfW8IzBGu64gE9FirnM=;
        b=zVnAe21n03DYSI4HTuAvWS4NWxj3Iaby0HUXGsr9aVIbiuVeFwt2SOtr5q464l/udf
         7DZQIBUz+kEguRCFonVOHJZj/8ej5vXpN9Z+3usX5XN59jptPkcuvMDNUtlfwXcIj7Rk
         uMm0OO5VmQ9jMvpixjBL701RzYFeAeFidWCPwZJIzb8feWDvsieBrI8fup62kERtFVef
         h/EXlgSYHOqDIz6JN/qw2cIAF5vZNc0boamC//Ar1DYvj7sPyXVocv7I81rcM+SozgZE
         OE6HxSEB0BhfSncutwK2zFoQe/FfGz9w8nCEzqzssT+W7MtXWWfeZAdYKbvup0r9aRoT
         qajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749139912; x=1749744712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVQTBJlbhCkTd304Z8LDEkMLDfW8IzBGu64gE9FirnM=;
        b=rd3iHbONnbbnleHA0pIb9PKqNJJt8t4h/sZvuXgl7ZiyyaTIhsZgclrhH/p7+A6xoY
         M0YKIsQwlIWEvIYtmNS+9HtmlOCGWyg9bqxNGJdw0Ww/C5rVl2/Jxtl3PaBJfVNJ5xbL
         9ouO7iBn8DWHV1Zz6rc43dd0Zpoh+KtI5fdsg/fksOgKUWJzniMGAFY9/R0+c89R5DEj
         96tGvTPHZTs2orSYJGyV0RxpflGeProLmj2ABRCJYcpGw/L4AaHpttifFzC6FBMKb9yU
         LfP1iJnFe6F0LkrUOICGEeA10mmxNZUv6gWU1yI7JdGaAHERUDm3FbhV/K9jKFjceDGu
         3XZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCKf1+2Poael8M8XSn25pdbovXt9s416VJ+JdIhHY8I6r0vRvATR4KroP4FdJFzllQ3R2a0Rc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVuivZSw3XuzRzDuHcbPivO/1BNyoEtpnF56rYIzaZBry+hTcC
	kiMlNjiaOeX4EjyT9l1s0JDQXTBDiWEHHQZJu2bc4IKG0i8nTTtIFmvsLmpYDHZ3Gv4QSUoJWef
	Ejm8/BTbatQslCPQrDbLCgVp35SL6A3y2djJZLy1XyFXK8QCIEw35XzdaqwNN6A==
X-Gm-Gg: ASbGnctao8IfTBIHKpoS1Un+hrguQlN8+oMLWUcllGzYn1iCIxqsMtduG4eS05PD9pw
	kWBzerBfnFEC5oE0y0c0UcJAU2slqG62lPanaOcQ8oMVGG6YdtAuk9bI5ekgVOKqyo2v5xTo+tc
	TtLzyQ+oNPKQhNVcofz5DaukAjYGNIu3Kj60ScWZ+VbOQ=
X-Google-Smtp-Source: AGHT+IGW1AVosxjNsFSIObbIwdEXbd942cmJ5pLbHiwd321kOxoWe+7++7JtO3HfWK1XkI6NzVd1UixGjAX3NzyuEHY=
X-Received: by 2002:a05:622a:1e19:b0:486:a185:3136 with SMTP id
 d75a77b69052e-4a5af3be5femr4553531cf.14.1749139911983; Thu, 05 Jun 2025
 09:11:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com>
In-Reply-To: <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 17:11:15 +0100
X-Gm-Features: AX0GCFvM0cIQHeoKF8w2gaIC3qDuLSImbI5TRY95h3Mg5SfZMXcAsghCvn7NJBM
Message-ID: <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
Subject: Re: [PATCH v11 12/18] KVM: x86: Enable guest_memfd shared memory for
 SW-protected VMs
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

On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 17:37, Fuad Tabba wrote:
> > Define the architecture-specific macro to enable shared memory support
> > in guest_memfd for relevant software-only VM types, specifically
> > KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >
> > Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> > enabled.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >   arch/x86/kvm/Kconfig            |  1 +
> >   arch/x86/kvm/x86.c              |  3 ++-
> >   3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 709cc2a7ba66..ce9ad4cd93c5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >   #ifdef CONFIG_KVM_GMEM
> >   #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >   #else
> >   #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >   #endif
> >
> >   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index b37258253543..fdf24b50af9d 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -47,6 +47,7 @@ config KVM_X86
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_PRE_FAULT_MEMORY
> >       select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> > +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >       select KVM_WERROR if WERROR
>
> Is $subject and this still true, given that it's now also supported for
> KVM_X86_DEFAULT_VM?

True, just not the whole truth :)

I guess a better one would be, for Software VMs (remove protected)?

/fuad
> --
> Cheers,
>
> David / dhildenb
>
