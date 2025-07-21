Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AB92D5C6C
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753101723; cv=none; b=N/qw0dR9F/KnYPGDifS4WQsbmyIykdiGsnu+X0y2Ky9yVaG6iVeJn0f5pwD2W/4sKb1Lh2Usxx+YOV0fHW+fI7mu2xmBnUg8/EI5o9UdK8WIDN5zyqdnCTZNDGge1Giu4MVRKRxtPcYTvBAp9Xc2IhYX1uYgD1kmboomDuxvfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753101723; c=relaxed/simple;
	bh=FH6NOtN844idHZdK0Ri+r5hjSZq61hkeGP1rVZSSTzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IpAoQ1R7934BWcGSU6EwzDgirTiPlXEfX183/0TaPvkBWVpwF8QxDwFkkveAL6daAAPDgpGylukd67RsLOZSbEMhXS4wb8NPvfMDtFmAcL/2HepWOAwGmGAB+MJP3cobDBcHqM8PotekPnCf7SaWFhAUOdNY54Dvo8ttnhfjaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g4TD/lgr; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g4TD/lgr"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso713531cf.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753101721; x=1753706521; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rIS8RtGx3BM3yP3QF7bgfk7fFz/ztOEu+IhwOpSASZw=;
        b=g4TD/lgra17w8isXhc6ARS5JGTDe5guy2fg6DmE++IRpDp2p2fhYuliZxB7PZeH2fR
         EUDWBsvHPlwTs+JCVjc5Yz6Rh2+XSlYyQ7UwLnf+o/4eLYFeaS7jD/XdQmOEcWRD1P3x
         XOXXjnY/fc5i73HLVpiILEhOCBKx+pTM5LaxJnkxiryNWGra351AjqdAkdPNRR11mtFg
         AEYNA23Ul8d6fjo12a60KDOIT9KcVUiPdwDPw9wr/k/68/XkXk9SZoK7Fnoh+W1MU6KE
         UYxD+6As5vR1BG+dr/EOX9uIAThzEjr/BABj7IHu7MczGAYqIFyToHBEqYH1ivJ1DYZi
         6keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753101721; x=1753706521;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rIS8RtGx3BM3yP3QF7bgfk7fFz/ztOEu+IhwOpSASZw=;
        b=aEGozCbvJYbtFKmHnvY6WciLntHylC21/hgKxW1WRYWeWZASM+/BIR9ivBqNfF/nCo
         8R9Wfan+T6GyZNcqgQ9GE2kGukgUaz/lSOUQJZOF2L31m0ktXsokWmmfKkZammS6tbgI
         TYQ7uXTKqwiVfihzYK9c/yJBhjeA+L4/xKArjmv24MnlHKzMeFImb7unDoUS61x7SHUB
         CQ+ZJ9a9u0yM92LUW+BVUY4O6E3wMQIs3fKR0lOPyKpgeR02409RSBdE0y07Gy+c62bl
         SnnN7KmX5mO3mZuO8bBZMmwhRPwZThPz6ln2aaUuZOM/F/kIX5Qyx/vTLLFXbIKP5l5x
         PNrw==
X-Forwarded-Encrypted: i=1; AJvYcCX3npVB3zBMmPRtkm0peFxOmPFzFxLr2dYbbvX5D0yUxIAMql3oUVmBck7qUSJsXfzSsIbqeM8=@lists.linux.dev
X-Gm-Message-State: AOJu0YweKrbhZT1ywt4Jo43jxc8HOvAx7230IKybVhUiZ8GD6anhjd/Q
	KIv/pT3jCCJrhtYnyTpKGwlZGeTlYpmU08r4gQ9f2lNVdnM2CCtRIw14WTP+4y9gufEyz2hzfv1
	xnIdsZ7p0kfXt72/0zznzF2eXSVdLxyP5pQJptQWm
X-Gm-Gg: ASbGncvnOu6eVR1+JULIE7K+eQPwlQzGvgoP3u+Rg6iyX62B2qHM2P1z/NdcpcXwsIb
	KpwvjcbFlwy2NinrBG+E3frFHRVIQngZ4TmRlbuc+3fUHs3EC/GTZhrjwpF//Q1weT0AgCA6FfD
	0LTaV6mjHn7KuLf+8mT9u2/OW137w1Y0YGWkqHNbpj5XHIP21yZ6Z41RTbtQKh9zGMZOrnD7MdK
	0C70/g=
X-Google-Smtp-Source: AGHT+IHICvOHUdMlgc+MwG4TRplOdK0+NsvYnQSN7a8Q94vN9K19Iv4njTMi3Vqu6DpIpL1LZ7OPxQ3JKDjs7jxoPb4=
X-Received: by 2002:a05:622a:8c19:b0:4ab:54d2:3666 with SMTP id
 d75a77b69052e-4abc2b37a63mr6227901cf.25.1753101720495; Mon, 21 Jul 2025
 05:42:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
In-Reply-To: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 13:41:23 +0100
X-Gm-Features: Ac12FXwLO_dne2w1dGUUYLFktGe9s64wr0cEuXbxIsFFA8S3s8yrvlEfzoVjAQI
Message-ID: <CA+EHjTxUpLU3-3dQY8O_SoQCmA8LR1y6w759xfYwisfxHec4aQ@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
Content-Type: text/plain; charset="UTF-8"

Hi Xiaoyao,

On Mon, 21 Jul 2025 at 13:22, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > +      (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>
> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
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
>
> SO my question is do we want to support such case?

Thanks for sharing this. To answer your question, no, we explicitly do
not want to support this feature for TDX, since TDX uses a completely
different paradigm.

Cheers,
/fuad
