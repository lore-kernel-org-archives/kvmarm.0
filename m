Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59167220F2A
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270884; cv=none; b=EJx4WRqrv9xTOu4LkIQABtO6LCnHnPDgfCu6kT9oCTCQxYvobSSUspDH1zKSNWXOfWIwjHiq8KVGfXmZj9D5GY9gnZEh+cm8MSlGWtmoSciEOu59AdhdBV1iMvJ97ToqaNk42kgSf1ePyau/5o5/9AB0x1g4UT5v9tVmCYRutIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270884; c=relaxed/simple;
	bh=0PgIaOQG6u3KOrgNFaZXzQa3bUV78WX2rDWBVVuBqLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEE0qg6rUTWX/ydxwXGwL6BvdOf0WKqnozEUDUQFSRBIhM901T+oWJp2aZCEGzTCptw1SQvrlRFH+z12YXPgvdh7dr3TmALA6zPSUW8oWff8CPoX48jISOIVbteOS13FBDz7eqE6TWOKwDLAF6zwM/oqr7bIeZxAm3Yj1Ax9Ptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eg0pLqyu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eg0pLqyu"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a5ac8fae12so693961cf.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 01:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751270881; x=1751875681; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mi/OKB+QroqPI8Z8OCA75lN3eu0FgzMHtdVq7qnuW3M=;
        b=Eg0pLqyuwFqzL3SbVApA0Y6dpqidmnYZDe7DE4rlzYwgW6bsCV5RpURmFLcBZT9BBw
         IiD3C95uWaBvDQQmr8K3Z2L8CEDThXRO7jGBWuHEM7SLSk/dppkNeAVkXTJbtoLj/wbu
         gYRYUR9WSeUtm1uuXzvShudovst+5rkBapoub/eO6C598ck7uJI7jGR87QwHrcu2xWb2
         WMITw/WoLOMoAyk5eCffwySB17FzzjrjLrYXuvpQnXejKQpobGgzYUcu1BUOhh0jXAxG
         Rz7nEA5jh+PwOhkohZvF7vu53dAappYKSb8sQMJ0m+hnHujt6Ec8Gc8igr69pDdlZAPy
         VdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270881; x=1751875681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mi/OKB+QroqPI8Z8OCA75lN3eu0FgzMHtdVq7qnuW3M=;
        b=RnjpvTsF7J0Fi9Djpc3azeeYFjV0xfuuoPWVE7mzCG0oCoEMd2HJuduid6cKFkmolQ
         ZI/r4fFuVsSKOzIfxsfYYHz7LpK3vRvGNuL+XRqUjsffRj58GdNGZLD5iSGCdK7v+uUx
         YIoaOrjWD6WdMcoRnVM56i2vQ5DVB7wp+v49E9+kMOJS+UHaFQDwPvexOj1ZP/4rfoXw
         jVg/HYDBABconGsowgZMqqNKddrLTOVYMeVvGXWNUYQ8gUs3FSngvYtDTqPu23MuA7IZ
         4x3HakDkkBUkqJSLCti4IlMNywumohlM+vXmgvMKyKj2erDBEZ9djDtTI1oLK/7Gro2k
         Eyqg==
X-Forwarded-Encrypted: i=1; AJvYcCU6MVw22ARk52ffbUOGPB0nxVtbR919HdoXOXny+uM0ngcPLM7RFFdccC8JtizjDflkt1y17ys=@lists.linux.dev
X-Gm-Message-State: AOJu0YxImuoJEtLs+lHlBVnlQ0IU4Y4t5i0vF2bMJ4dFrgi01A2eLdXs
	N3Q4ECpz1OfEPrwxE6nWyH6yeEdmQC8ImDD9ixk1sV+YG84tDlfQtrvvouWtXuUSFtzVITab8yE
	mKc403Z5CJNuEba7NTHktlEGkEcXOz5MeRx8x24+3
X-Gm-Gg: ASbGncui8v4hW6rUXHUyt8f6iyFGCbiqNMvUF1oN+C4YWvJQ0uV+V1edJ5L+Rgoz5nF
	pnlqEzWoX2IIaDumrJXHb5xjordAj4y+x2+MJjPKq2iqIr9NbU16N+/T9YNa43e4q9NeZImKhDY
	mNgyyT3B+hLX3k22JKTjIrt27rGBltth9I640OOMrRRvFbw+kqDRYRtoD3K7csdfVu7KMNAiZi
X-Google-Smtp-Source: AGHT+IFQ+H4ctfiCA8/zL6DD6zbPcIGQ0L/p+jZyxVns9qRr/+12U+JsgC2TXDqtvwf6SRug7NRYv389tASYM/vG9wA=
X-Received: by 2002:ac8:5e08:0:b0:4a7:6ad9:39b4 with SMTP id
 d75a77b69052e-4a808ffbdf0mr5418201cf.25.1751270880560; Mon, 30 Jun 2025
 01:08:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 30 Jun 2025 09:07:23 +0100
X-Gm-Features: Ac12FXx4RLRI7Sn1sliQ6WnveLDaQPnxVwQ-ObC_x8hHp0fzJtRLgEA_BEf2o30
Message-ID: <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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

Hi Ackerley,

On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Ackerley Tng <ackerleytng@google.com> writes:
>
> > [...]
>
> >>> +/*
> >>> + * Returns true if the given gfn's private/shared status (in the CoC=
o sense) is
> >>> + * private.
> >>> + *
> >>> + * A return value of false indicates that the gfn is explicitly or i=
mplicitly
> >>> + * shared (i.e., non-CoCo VMs).
> >>> + */
> >>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>  {
> >>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
> >>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE=
_PRIVATE;
> >>> +   struct kvm_memory_slot *slot;
> >>> +
> >>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
> >>> +           return false;
> >>> +
> >>> +   slot =3D gfn_to_memslot(kvm, gfn);
> >>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(s=
lot)) {
> >>> +           /*
> >>> +            * Without in-place conversion support, if a guest_memfd =
memslot
> >>> +            * supports shared memory, then all the slot's memory is
> >>> +            * considered not private, i.e., implicitly shared.
> >>> +            */
> >>> +           return false;
> >>
> >> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclu=
sive with
> >> mappable guest_memfd.  You need to do that no matter what.
> >
> > Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
> > disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
> > out. Where do people think we should check the mutual exclusivity?
> >
> > In kvm_supported_mem_attributes() I'm thiking that we should still allo=
w
> > the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
> > gfn ranges. Or do people think we should just disallow
> > KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot i=
s
> > a guest_memfd-only memslot?
> >
> > If we check mutually exclusivity when handling
> > kvm_vm_set_memory_attributes(), as long as part of the range where
> > KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
> > whose slot is guest_memfd-only, the ioctl will return EINVAL.
> >
>
> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>
> * Fuad brought up a possible use case where within the *same* VM, we
>   want to allow both memslots that supports and does not support mmap in
>   guest_memfd.
> * Shivank suggested a concrete use case for this: the user wants a
>   guest_memfd memslot that supports mmap just so userspace addresses can
>   be used as references for specifying memory policy.
> * Sean then added on that allowing both types of guest_memfd memslots
>   (support and not supporting mmap) will allow the user to have a second
>   layer of protection and ensure that for some memslots, the user
>   expects never to be able to mmap from the memslot.
>
> I agree it will be useful to allow both guest_memfd memslots that
> support and do not support mmap in a single VM.
>
> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
> should not imply that the guest_memfd will provide memory for all guest
> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>
> For the use case Shivank raised, if the user wants a guest_memfd memslot
> that supports mmap just so userspace addresses can be used as references
> for specifying memory policy for legacy Coco VMs where shared memory
> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
> but KVM can't fault shared memory from guest_memfd. Hence,
> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>
> Thinking forward, if we want guest_memfd to provide (no-mmap) protection
> even for non-CoCo VMs (such that perhaps initial VM image is populated
> and then VM memory should never be mmap-ed at all), we will want
> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
> not set.
>
> I propose that we should have a single VM-level flag to solve this (in
> line with Sean's guideline that we should just move towards what we want
> and not support non-existent use cases): something like
> KVM_CAP_PREFER_GMEM.
>
> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>
> * memory for any gfn range in a guest_memfd memslot will be requested
>   from guest_memfd
> * any privacy status queries will also be directed to guest_memfd
> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>
> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
> guest_memfd.
>
> Here's a table that I set up [1]. I believe the proposed
> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
> (columns 1 to 4) correctly.
>
> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710/=
guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20trac=
king.pdf

I'm not sure this naming helps. What does "prefer" imply here? If the
caller from user space does not prefer, does it mean that they
mind/oppose?

Regarding the use case Shivank mentioned, mmaping for policy, while
the use case is a valid one, the raison d'=C3=AAtre of mmap is to map into
user space (i.e., fault it in). I would argue that if you opt into
mmap, you are doing it to be able to access it. To me, that seems like
something that merits its own flag, rather than mmap. Also, I recall
that we said that later on, with inplace conversion, that won't be
even necessary. In other words, this would also be trying to solve a
problem that we haven't yet encountered and that we have a solution
for anyway.

I think that, unless anyone disagrees, is to go ahead with the names
we discussed in the last meeting. They seem to be the ones that make
the most sense for the upcoming use cases.

Cheers,
/fuad



> > [...]
>
