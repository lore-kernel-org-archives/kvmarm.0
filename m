Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75B275861
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145421; cv=none; b=sypYu1P+V6zDMojv2FWLPNAjoV1VD6b/djTWaUIZ7zyU7N74dF5crRx2BhOxugwDjNNW7UbVg379HEp0K3qwJvjfjrwqZSuNPaHrUy7ZhyHs0VglEyyX0dbhCEjVeW4ssCsBXxdXXBa/MXnrTnvXADuEY63DJGLQAtcQVnVgFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145421; c=relaxed/simple;
	bh=6IbE76cGNJM5qHpMo9ixtF0wChLEBepSlKgRGQcpAhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kYApjAz/F39tI+UZxTKAF66af1C38AFvI2ILwPE3uZ/M0uCe/YBVDHm1TjF8ft5WNWS7VmaejsUdktWgDUzaPqtps8+5W1XcDr2l/98DW8GN+Azd2H9fgg9FxcvMt/NX6ryUp8nwE8XnSbMPiBKUhHcFAXbfdRzl9/a334SMtzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2QClBZB; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2QClBZB"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4a58ef58a38so21851cf.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749145419; x=1749750219; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z2CqoZ0AEAzoUtqdrcArln2L/gsL8eatF4pYDcOE/Uc=;
        b=x2QClBZBfPicyiyyticvML3gZ63wsyB7luGNIKxC93RgdF6vTuJWvjZUBM0uQbPjrI
         LWeMO8+T0NpPHLI6EqZm0GGzn/XA/kWb0X69YEDUdvnGvM6Cix3pqZZEpCq6YX94yxQm
         UT1Ax7sBEoYO5iVE/KzgYHZeeDmUTC7pb+nyzwnSPqbb82wuExMZf17cXa0ftNVPAL6C
         z1lAie4B5Z2dVCUoN3GsNqNc9grb7IbxI6rGngau+b+TmFQ3h9dQJwRCuiWFZJlvmuTh
         b6wjdvCHBUAGpRy1JuoxbnRnIP2ClOUEu86VZRRyl+JSwUCCTliE3pnd7cpogUg5WeE6
         yTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749145419; x=1749750219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2CqoZ0AEAzoUtqdrcArln2L/gsL8eatF4pYDcOE/Uc=;
        b=lm21tJ8g9+0YvwMHpl3iOXFPYHTNQTZ4TgEkrkuaBwjm2QIOyRwJ5PX5MP6YW6YBVf
         usfH2bxfRVa/5NDnTDp6ypCxbtJIgNqxpIcOggm1Kdqg4bLzV4Fxpymy8/p0+EUMAMg7
         Osnp/QpZg1VV1Qau63VUxGApMVjyroMpLHqA6vf6x8EpGBDnXEzgnEbxnnRVfZX4lIuO
         895AX4ZU4E/DujXzRCONpSIz+9KjZAwZqBu1CCRiXtNcDmCWa9kd+1rumMjZ/VCWV81b
         0tcZDqGE5DntKRMsomKhRx7wWggm2kxS1JEfMmjA55Uvb6ciHLPLSYXWwo8MQgUcty1k
         OHQw==
X-Forwarded-Encrypted: i=1; AJvYcCWYx2yiI3smMNwbu2YR6CVCDap5+0siboEC8/so3BtDznMh7IsOEyaYhpb4nBR6ElVNIM47w28=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywv+5Eu+HXRYA4QjBWt1eEyxDNSGu2xEy10x8BvF0Rneu6lfAXP
	yRG3vMXyFR/jQmaVbHGrK5Tm1m9LJkPFYCGZQx27K22pUScfbjCYRaz4Ciigpl+328+0sjtSpjZ
	orbhXXCS0X3r29DTZr06VGFsQVmjdEeGv5Bfyipn6
X-Gm-Gg: ASbGnctoA36/WqECkMKpDSneimYDp4GOEmppIRqOID3hcB6wcl8QnUzBKJ+nRnknxbo
	bLwic1q/TPsqKubWY7HX5xNNPoDZhfBLypVwTPvz8XmlwqHxf02iY8ZdftXVnBhqhFcYQeEv1sD
	S92YudZ4WT7YeoxW0j1xQdcMYQvoB7R3HOYdhp0lLRj5A=
X-Google-Smtp-Source: AGHT+IExAG9FOhA/JYGGXSBKDCzqV2Xo5C2y6Ta3UELn/eRIfFUiL+Rqeg9GPUYw/hiNAJoKYymR8PDaqjOB4BS/zFM=
X-Received: by 2002:ac8:5c8f:0:b0:494:763e:d971 with SMTP id
 d75a77b69052e-4a5b0e31c8bmr4317101cf.23.1749145418575; Thu, 05 Jun 2025
 10:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com> <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
 <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com>
In-Reply-To: <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 18:43:02 +0100
X-Gm-Features: AX0GCFvljLgP25GVDAuLamDWQ4LY_vKhcAYVWztfS80gbr2QcR5zJxfpTOOCjHo
Message-ID: <CA+EHjTw-dgn+QbHd5aCxjLXCGamx7eTr75qcFm+o16qyVydnBQ@mail.gmail.com>
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

On Thu, 5 Jun 2025 at 18:35, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 18:11, Fuad Tabba wrote:
> > On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.06.25 17:37, Fuad Tabba wrote:
> >>> Define the architecture-specific macro to enable shared memory support
> >>> in guest_memfd for relevant software-only VM types, specifically
> >>> KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >>>
> >>> Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> >>> enabled.
> >>>
> >>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >>>    arch/x86/kvm/Kconfig            |  1 +
> >>>    arch/x86/kvm/x86.c              |  3 ++-
> >>>    3 files changed, 13 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>> index 709cc2a7ba66..ce9ad4cd93c5 100644
> >>> --- a/arch/x86/include/asm/kvm_host.h
> >>> +++ b/arch/x86/include/asm/kvm_host.h
> >>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >>>
> >>>    #ifdef CONFIG_KVM_GMEM
> >>>    #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> >>> +
> >>> +/*
> >>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> >>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> >>> + */
> >>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> >>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> >>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> >>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >>>    #else
> >>>    #define kvm_arch_supports_gmem(kvm) false
> >>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >>>    #endif
> >>>
> >>>    #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> >>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> >>> index b37258253543..fdf24b50af9d 100644
> >>> --- a/arch/x86/kvm/Kconfig
> >>> +++ b/arch/x86/kvm/Kconfig
> >>> @@ -47,6 +47,7 @@ config KVM_X86
> >>>        select KVM_GENERIC_HARDWARE_ENABLING
> >>>        select KVM_GENERIC_PRE_FAULT_MEMORY
> >>>        select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> >>> +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >>>        select KVM_WERROR if WERROR
> >>
> >> Is $subject and this still true, given that it's now also supported for
> >> KVM_X86_DEFAULT_VM?
> >
> > True, just not the whole truth :)
> >
> > I guess a better one would be, for Software VMs (remove protected)?
>
> Now I am curious, what is a Hardware VM? :)

The opposite of a software one! ;) i.e., hardware-supported CoCo,
e.g., TDX, CCA...

Cheers,
/fuad
> --
> Cheers,
>
> David / dhildenb
>
