Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086DB293C6E
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752653796; cv=none; b=Wf28ts34X73C8IYmyZP5mudbLUJVHJVbQs1i6bWU3/+ZCwkTX94hO3CCzwT0wTrKlO7PXml0I6AlajUz0F6ebOn+5R0b2aluAamMcey0IvYQZ4dMPZUc2b5J2fqaycpz2HDGV4qvPWAbAKJTrbNts+RQZvEBZxbT6Qz4qwrWdvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752653796; c=relaxed/simple;
	bh=YJKcl4vj24HGH7v5er3kH32Ci+TJCFAsMQP2JUMKGVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJMzhpoX+JeIKAVcjm8TtNEjrYgdoaw7lnaUOdOVH3I/P76naoBoBxdgVVY5KInUaC3xOQBM+i3a1tnzXClmJMGkwsXbj2zBrruUdLL387Z6hiZDLTy+r59iaPlnnX4BktvHeP4fOMYtbUP67J2e3ZV/9MDjlVRZCOEb3DYyd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpvDcu8A; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpvDcu8A"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso132141cf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 01:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752653792; x=1753258592; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mnAy+noFgCnHDKld1AWpZeCpzVxC9Cw5tuqijnucVtI=;
        b=tpvDcu8AAqwav0aS4Qiw8KXq4gI0Tuih6COw/fAsdoAQqUuhle3Vz1ZSwOOTI0f2nG
         HeYISW0FkXNGpmWD1qrbDc1EfuHQgPpnUFMyeF3Syg6O9WGIbJ/nLesCENZ/2UX2AtRz
         Z56lyUqjBEQMspbkNeEXyst8Ce8A5h5HkeEudKNO5YlX/0UDXG1rQCeMP/mvuXbhBQe4
         zHZ6e2oRFOgBjAqS0/5ypAvfbsRsenOUg7Bs86FytYhQ4wnFG/acKloUbZVEoWaQgg1x
         1JkMRPcHNanFrwkD7EzAKFpoxspuQsqFrKCsZai8el/gxz1zMj23tVQTxDoriMgq0Gkl
         /pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752653792; x=1753258592;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mnAy+noFgCnHDKld1AWpZeCpzVxC9Cw5tuqijnucVtI=;
        b=fLz2hpbO8W4s7QUT5yPm2/PnlFwQlmtwAqez1jxUbecGaayRpeEGowMxalhhnfPkIj
         J/mJTiGnBtoiJthdwN8AnoAoSXp1Aftdd1Ryd5O/79LGbcklhwu+AI7N6OHGR8QJEusA
         X1WA+aLZEKg/Qpls5dlpXVijVRKPU7C/BopDi9h4Ve3MGT6oS8NuODcg/sSP9Ya4bOx5
         7pOKgHYNwvT93VZeqcMiAsIykNJGe1ClJOQUWkSNm61CI7oK8wqDOxwxj7dEnho9Du2V
         sp6LimNM5UzeruURtF3lJycPxj74Jaj8T1tqbz3jIWWvFY9JzfhpTq0EHSz/cFCA6zBT
         Ok3A==
X-Forwarded-Encrypted: i=1; AJvYcCVXLYgRjm9fUJRFizpzvfE6hhr3eqY6GGdVju89eA7i/oo3DUFl69GvQ8TgscnkF5pjqBZxMTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbagmOI0HGMEDNzppMKhd3X8nbYAHlvrSLN9IsLY8bEu/YwZXt
	EjT5GFZhOdYet/pvaa9DdLjzThYqJJFGWaE8GnHBvn9KxsF/X+OqgHZ5XP73W7TyeXYVom+nUV3
	Xp4cQ0oQVeQMeONyWUn91Cu9EMQGUBnZEbPOE0NHw
X-Gm-Gg: ASbGncsgqW4Ipa5ffsJmZCz0pyS9h1CMqRtphYE0sek9NaQqg07Xn0JWzfeYVV7zT1K
	kl7Y1fK+96QunZD9K6aMbCiDQ0o/KPvHd8A97aZPAHbaNIoTm4Ae0qw19xjSwGx2lui22aU/wuo
	7r9e0ZMsCYIKknnEvN5if5G5PBZMkAzrTjH0LJ/ISGRBpJYQUMnRjHLjrOgyaIbfXZ+we7GAQgp
	PXK/fndFVZcyl9Fv+NGw8M6TlX00kWjQXrAgR1+de5N850=
X-Google-Smtp-Source: AGHT+IGVoq0ga5qSenXVZ+UZRsJYQFZIpqNzCrbFRCRBi/h2oDDFH7C/AuHlq8c+No+9wOmjYwhA7tNPCVL404pkr1s=
X-Received: by 2002:a05:622a:758e:b0:4a8:19d5:e9bb with SMTP id
 d75a77b69052e-4ab97dc8f23mr1362021cf.13.1752653791542; Wed, 16 Jul 2025
 01:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-9-tabba@google.com>
 <e1470c54-fe2b-4fdf-9b4b-ce9ef0d04a1b@intel.com>
In-Reply-To: <e1470c54-fe2b-4fdf-9b4b-ce9ef0d04a1b@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 09:15:55 +0100
X-Gm-Features: Ac12FXxETsFaclWR-WjxOoLNq6pE7Ay4UcwynELirUbeDNGKOnsmgp7urN-OGDw
Message-ID: <CA+EHjTyGN3XcjXbWPLer0_1Hvg7HGD0E+ULibwk7ObOKKRNPfw@mail.gmail.com>
Subject: Re: [PATCH v14 08/21] KVM: guest_memfd: Allow host to map guest_memfd pages
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

On Wed, 16 Jul 2025 at 06:40, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> > Introduce the core infrastructure to enable host userspace to mmap()
> > guest_memfd-backed memory. This is needed for several evolving KVM use
> > cases:
> >
> > * Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
> >    entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
> >    provides a unified memory management model and simplifies guest memory
> >    handling.
> >
> > * Direct map removal for enhanced security: This is an important step
> >    for direct map removal of guest memory [2]. By allowing host userspace
> >    to fault in guest_memfd pages directly, we can avoid maintaining host
> >    kernel direct maps of guest memory. This provides additional hardening
> >    against Spectre-like transient execution attacks by removing a
> >    potential attack surface within the kernel.
> >
> > * Future guest_memfd features: This also lays the groundwork for future
> >    enhancements to guest_memfd, such as supporting huge pages and
> >    enabling in-place sharing of guest memory with the host for CoCo
> >    platforms that permit it [3].
> >
> > Therefore, enable the basic mmap and fault handling logic within
> > guest_memfd. However, this functionality is not yet exposed to userspace
> > and remains inactive until two conditions are met in subsequent patches:
> >
> > * Kconfig Gate (CONFIG_KVM_GMEM_SUPPORTS_MMAP): A new Kconfig option,
> >    KVM_GMEM_SUPPORTS_MMAP, is introduced later in this series.
>
> Well, KVM_GMEM_SUPPORTS_MMAP is actually introduced by *this* patch, not
> other patches later.
>
> > This
> >    option gates the compilation and availability of this mmap
> >    functionality at a system level.
>
> Well, at least from this patch, it doesn't gate the compilation.

You're right. This commit changed a bit, and I should have updated the
commit message.

>
> > While the code changes in this patch
> >    might seem small, the Kconfig option is introduced to explicitly
> >    signal the intent to enable this new capability and to provide a clear
> >    compile-time switch for it. It also helps ensure that the necessary
> >    architecture-specific glue (like kvm_arch_supports_gmem_mmap) is
> >    properly defined.
> >
> > * Per-instance opt-in (GUEST_MEMFD_FLAG_MMAP): On a per-instance basis,
> >    this functionality is enabled by the guest_memfd flag
> >    GUEST_MEMFD_FLAG_MMAP, which will be set in the KVM_CREATE_GUEST_MEMFD
> >    ioctl. This flag is crucial because when host userspace maps
> >    guest_memfd pages, KVM must *not* manage the these memory regions in
> >    the same way it does for traditional KVM memory slots. The presence of
> >    GUEST_MEMFD_FLAG_MMAP on a guest_memfd instance allows mmap() and
> >    faulting of guest_memfd memory to host userspace. Additionally, it
> >    informs KVM to always consume guest faults to this memory from
> >    guest_memfd, regardless of whether it is a shared or a private fault.
> >    This opt-in mechanism ensures compatibility and prevents conflicts
> >    with existing KVM memory management. This is a per-guest_memfd flag
> >    rather than a per-memslot or per-VM capability because the ability to
> >    mmap directly applies to the specific guest_memfd object, regardless
> >    of how it might be used within various memory slots or VMs.
> >
> > [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> > [2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> > [3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/linux/kvm_host.h | 13 +++++++
> >   include/uapi/linux/kvm.h |  1 +
> >   virt/kvm/Kconfig         |  4 +++
> >   virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
> >   4 files changed, 91 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1ec71648824c..9ac21985f3b5 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -740,6 +740,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >   }
> >   #endif
> >
> > +/*
> > + * Returns true if this VM supports mmap() in guest_memfd.
> > + *
> > + * Arch code must define kvm_arch_supports_gmem_mmap if support for guest_memfd
> > + * is enabled.
>
> It describes the similar requirement as kvm_arch_has_private_mem and
> kvm_arch_supports_gmem, but it doesn't have the check of
>
>         && !IS_ENABLED(CONFIG_KVM_GMEM)
>
> So it's straightforward for people to wonder why.
>
> I would suggest just adding the check of !IS_ENABLED(CONFIG_KVM_GMEM)
> like what for kvm_arch_has_private_mem and kvm_arch_supports_gmem. So it
> will get compilation error if any ARCH enables CONFIG_KVM_GMEM without
> defining kvm_arch_supports_gmem_mmap.

Thanks!
/fuad

>
> > + */
> > +#if !defined(kvm_arch_supports_gmem_mmap)
> > +static inline bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
