Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD72D949A
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753105535; cv=none; b=SvlumlTgT8cedGzfW280aDraKqgLDkZ1Ou0YwmldZPCzjykle0Hz1ILOiSClIHAUECZ/+AobgqAkezzGJCN9mFKdVz8fS+JOr3da8eZepz8FDeAgiTN45ZqQiE4HDArrowDPku4/9eANIetudvopPZvR5doqds0VZB6KyWPWZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753105535; c=relaxed/simple;
	bh=xS8FHRQqRz1nSiwIVN6mTqgxMWHxF+OgzCsTtwKG9q8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B739w7NUTAzIG//AyjFoUThR9M4bnSqOHn6NAXIwEU3/okHykC0TnOSi3KpSgQK/RcXFEy8+9OGfEAbXkEN6IYX/XIs6/ZxMl2RSy6wM6iZhgeILeXFaRzCSXZzZpSZZGwko4q9bJ9HCdgZgbJkj0kLoHPUuOiXiJDTm2EAMm7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2nI0E0eR; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2nI0E0eR"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23dd9ae5aacso243875ad.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753105533; x=1753710333; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQBY4/lqxzZEDnjripdA0AMheXR9IyeEye91HdZllXE=;
        b=2nI0E0eR4687L//Z4dc8ckQGPac2765hwx31gNrWYA7ftMsv+1WSq2Gvz2PP5wOFac
         99RQJQ24a4xQovLL5EivuwhxpG5HEiDale45unCrQhKHXGXkkzsZ2bhKNzeo0Ll6684g
         Kj3KOvquA3OLIyIY+3Zzu/DEVuttb1hwpz4jyInbvhukg2T5Nju7aCHxopqtkX9yq3WR
         Qzvamyn3oRVcycum/SEGkwbZ4rfbfEOhJGdQpMin6ghOwEVCHjdQoTnv30IpeIIA5auP
         bpgtpdSxiKerULbEKt4rSo+/gdeuK/6uUZ+VB7/Cvsyn8ELquLX7kVEV4spjH/Nz/u/y
         Z7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753105533; x=1753710333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQBY4/lqxzZEDnjripdA0AMheXR9IyeEye91HdZllXE=;
        b=hq8Fu0svEFtCNNjooFLQYqGb365RXRahKA9wB2P5Q0WezfaNtRaoctnZDeRtflUOWt
         6cHZ5VJ1w6KezO1oiGxM4O6kHdc6KCatrN/ymDQYlRdqqh6pMEvUid9lrjmzsqT9bfiN
         IFIm93OFibV6kqL0p00G/2RW7xWOVTsHhf7X9dPJMHsLnFrzRbCv2ift86E4Pu5/6C4X
         2GNJTBGhktTK246v6VGKmRkttAt8qwZDo3Dm3f/RjJBkCGMLLKuk+DmWKkyWdzct4zFy
         0Tg9EnhvXk4uwl/xTpthDQmyROh7/uT2kxnXBlGYNO0H9rwRGIP/7x5XIga1iCgWzczc
         BG4g==
X-Forwarded-Encrypted: i=1; AJvYcCWh8gWFkPezf1vY1SzIkFkl0w/Tx9sRV5MFvrrLWk1pE9et7OiONfnJU4cDBTJhNYmZW36xXyE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8AsHN5wjx/OBvE07VHu3ZdFXnSHCPtQwERYned4GBWANdnVal
	kdJICnLSciqu85VYiYr/cHQHsBy/WAYLFwEBBJkIfDuwIYLXXnfAMZ52qPHNCHIHG0xTSqbY4fB
	YqhOOyKMvmq5F1BDvsWrS63krAL70/rfOOSnh6Rwg
X-Gm-Gg: ASbGncvRGeCoiys4fhPh6V7J3HxNdp9ksfAv9DFMoW9oVRgeOVuE7Ye44WZsFDUzeRk
	bcCg8TYlkbkCdJ+Jk2Iv5cpUen/1OSMCwe3keB0muddLydYzKzOZY37weCEqgdHreorKm4QAvWN
	VcU+5OkIS3eEyCzGdUZsaM0rCTRP3xLgW8COWIJx/3REDbJkSyb6VGjt5TFmsbGu+zh/3LerQRP
	EJY6jZPrfPAIwYKixCIDOo6d2T5Ge3wdKNiPqce
X-Google-Smtp-Source: AGHT+IHgNq4HFEWMWRcmuIn4waZQ8L7YkPL51NiUKU8DKiTWVp4UcwGMr4KoSHwclm773Kr4g3s26lBtxz0ISLcojo0=
X-Received: by 2002:a17:903:3c30:b0:23c:7be2:59d0 with SMTP id
 d9443c01a7336-23f72bde123mr4371025ad.23.1753105532950; Mon, 21 Jul 2025
 06:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
In-Reply-To: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 06:45:20 -0700
X-Gm-Features: Ac12FXxBtzFRH5FT7AkkjtuMY19h9DQ20jtILflp5xgXgKiIQbsSMqanr3p0fog
Message-ID: <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 5:22=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backin=
g private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping en=
abled.
> > + */
> > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > +      (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM)
>
> I want to share the findings when I do the POC to enable gmem mmap in QEM=
U.
>
> Actually, QEMU can use gmem with mmap support as the normal memory even
> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
> on KVM_SET_USER_MEMORY_REGION2.
>
> Since the gmem is mmapable, QEMU can pass the userspace addr got from
> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
> works well for non-coco VMs on x86.
>
> Then it seems feasible to use gmem with mmap for the shared memory of
> TDX, and an additional gmem without mmap for the private memory. i.e.,
> For struct kvm_userspace_memory_region, the @userspace_addr is passed
> with the uaddr returned from gmem0 with mmap, while @guest_memfd is
> passed with another gmem1 fd without mmap.
>
> However, it fails actually, because the kvm_arch_suports_gmem_mmap()
> returns false for TDX VMs, which means userspace cannot allocate gmem
> with mmap just for shared memory for TDX.

Why do you want such a usecase to work?

If kvm allows mappable guest_memfd files for TDX VMs without
conversion support, userspace will be able to use those for backing
private memory unless:
1) KVM checks at binding time if the guest_memfd passed during memslot
creation is not a mappable one and doesn't enforce "not mappable"
requirement for TDX VMs at creation time.
2) KVM fetches shared faults through userspace page tables and not
guest_memfd directly.

I don't see value in trying to go out of way to support such a usecase.

>
> SO my question is do we want to support such case?
