Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D302EA750
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 08:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654153; cv=none; b=OPxiDzehuHMNwJuCyzP7iMgll0asgBuV+xUBr1rcAtgS7+zAXN3sn9INYBf/Ct+gTZi6wnYTHEObEyTo8UO1nOTVItL/V+DvAUZbyhFuMX6JwR1/nJZFi9Deis1csjenGlWvYVOr38EtSirSzJQtbRxTM+Ynp7oK/Rx1AFSXQR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654153; c=relaxed/simple;
	bh=Efc5zrMmKCLeVwBE7haDRUYt/aVplYzJ7QWqSAKg750=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFu3AyjQz3gA4cGka/mSDQBUYBfTbc5Yw1Uu8XsfsCiC9gdEcNLSWpUuIiONZS2uciLEqvhUCftykgKBt+B1hRtQB4rpM27J1gvb9lelaBrAu008CRPkz/gXFNbV+DNChaGzeUpIu/wp1Unu0tmfETrmDSkvWafpwYjaPQo+SZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vy5ceh4; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vy5ceh4"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab86a29c98so353531cf.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 01:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752654149; x=1753258949; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dB2f+OqBcoUglBgioeCSamv6eJG+MGIr3kIA7svSfaM=;
        b=4vy5ceh4wdNeQ/k1Aut4k+HdFUEmbmzmiTjxywrim7Gbw1A2RCaGG1jvLbJ4AWrB6z
         O7kIcKcohgI2urGE9LtoTRAb8If1shjp5W6V9dKl3VKc3KbkKaDnPQ/9ZxrmyH9GvQuT
         t8zoudeqE9MirqbUEfJQIzj+3093/0qZZ1it3J7MdkcsPcQ9Ihi0h7NKt8RCvJ86Z28b
         yB794nBy6ed4jwLE+JLzdNe6KGGvQHNsriEjsRakmjzmw5FrufLlOW0gCLLDQ96Xrzsc
         Ut1F3IJDky1CSu+MP9hDvf9fpnFqzlRBu0UwjaQffHlptGnAuGVSqFXTwxCTGMdldKKL
         nwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752654149; x=1753258949;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dB2f+OqBcoUglBgioeCSamv6eJG+MGIr3kIA7svSfaM=;
        b=EDZa6V6d5hGdzackEk8UiYYQFdR9hMrnSBFN4BDjLpE+OmeEhmtCg+uCfiNY+fuFhN
         rM8LYCVHMmVKRcn6ON0FqCbx3YRNi2RuxUwtDw0AooNGhW81uC6WiJDe5ox6Za0383cW
         6gL/fhYtftHDsO4aMH89leec9X4NizGzAj2e9NJfTk/7nVsn6H7bxMN3SCKIxMx8Qj72
         FKyhaKWualCS73bnJc/elOpFq+HYrsn8xFrbzxXKyYj+6lPI/Wh6qUQeDeoPztz+lljg
         PF+KFEjtooBMIFH7SZk8s36GFQD+s1xVDmhC7F4IVCYRAsKAm5H1I7ZS0jO+pc/LMUhY
         F4+g==
X-Forwarded-Encrypted: i=1; AJvYcCXy3YDRX+IzWeW1TD3JOvU6swSVy1t6HUs973Bqm1Qm0n89Hp6YA/mvyJTTkHRWkHHPdiumlBw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSQtcNWdEg7zMHxYqVitOtg8AJy+eoVZ4XhKl3GZlnoObkR78p
	mrnjpmDMD8jVZzeTN0ob06/eDs3kKaABphWuBKRGgVo3hXzAJ+mCIxpA3x9rh0zMuyBDcrpMpgQ
	LpBwHLIRNWw1kcT8ZwoNNAYe2IMYpVseEZHBvzFaJ
X-Gm-Gg: ASbGncv0TKNy7iMD/iHflDA9MI3esc8XjU8NxyS7IUipVK3MQLCwn6t3Y8SMy9VFIDP
	MNCyRgeS3oj9uccoCAM0DxNEurc0XlrdbR24uzu+iTuM1MYbfNJEL3w3XUMW7IAXmT4sbRnFMoo
	td0mXvIgzt5nm1cqtcbeALSRexUYdguXoZy22Soe+2keH/U/v2HiHLIaSn/LYOYmfuHA==
X-Google-Smtp-Source: AGHT+IES4Fs0eOXrBME9Gvkd38f9cRIFgxFUNysGwp74hEleIZ8Dk5yv42MjL8flX2EK/oextm+FVG3Xg4ndC+z5lzA=
X-Received: by 2002:a05:622a:5a10:b0:4a5:9b0f:9a54 with SMTP id
 d75a77b69052e-4ab954d873amr1943711cf.18.1752654146282; Wed, 16 Jul 2025
 01:22:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-10-tabba@google.com>
 <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com>
In-Reply-To: <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 09:21:49 +0100
X-Gm-Features: Ac12FXyuF2E-PHHtVYmQgJuetruwFH7AKGsFMN-bVKy3sXgyo2DVZ-InUCrcF3w
Message-ID: <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
Subject: Re: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
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

On Wed, 16 Jul 2025 at 07:11, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> > Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> > memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> > supports host userspace mmap operations. It's strictly for KVM's
> > internal use.
>
> I would expect some clarification of why naming it with
> KVM_MEMSLOT_GMEM_ONLY, not something like KVM_MEMSLOT_GMEM_MMAP_ENABLED
>
> There was a patch to check the userspace_addr of the memslot refers to
> the same memory as guest memfd[1], but that patch was dropped. Without
> the background that when guest memfd is mmapable, userspace doesn't need
> to provide separate memory via userspace_addr, it's hard to understand
> and accept the name of GMEM_ONLY.

The commit message could have clarified this a bit more. Regarding the
rationale for the naming, there have been various threads and live
discussions in the biweekly guest_memfd meeting . Instead of rehashing
the discussion here, I can refer you to a couple [1, 2].

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.a15es1buok51
[2] https://lore.kernel.org/all/aFwChljXL5QJYLM_@google.com/

Thanks,
/fuad

> [1] https://lore.kernel.org/all/20250513163438.3942405-9-tabba@google.com/
>
> > This optimization avoids repeatedly checking the underlying guest_memfd
> > file for mmap support, which would otherwise require taking and
> > releasing a reference on the file for each check. By caching this
> > information directly in the memslot, we reduce overhead and simplify the
> > logic involved in handling guest_memfd-backed pages for host mappings.
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/linux/kvm_host.h | 11 ++++++++++-
> >   virt/kvm/guest_memfd.c   |  2 ++
> >   2 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 9ac21985f3b5..d2218ec57ceb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -54,7 +54,8 @@
> >    * used in kvm, other bits are visible for userspace which are defined in
> >    * include/uapi/linux/kvm.h.
> >    */
> > -#define KVM_MEMSLOT_INVALID  (1UL << 16)
> > +#define KVM_MEMSLOT_INVALID                  (1UL << 16)
> > +#define KVM_MEMSLOT_GMEM_ONLY                        (1UL << 17)
> >
> >   /*
> >    * Bit 63 of the memslot generation number is an "update in-progress flag",
> > @@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> >               vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
> >   }
> >
> > +static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
> > +{
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
> > +             return false;
> > +
> > +     return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
> > +}
> > +
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >   {
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 07a4b165471d..2b00f8796a15 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >        */
> >       WRITE_ONCE(slot->gmem.file, file);
> >       slot->gmem.pgoff = start;
> > +     if (kvm_gmem_supports_mmap(inode))
> > +             slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> >
> >       xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> >       filemap_invalidate_unlock(inode->i_mapping);
>
