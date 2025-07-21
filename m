Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3A42DAFCF
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753117002; cv=none; b=evvBlcVM+7SJUWOWTzUAy1tm5UoA4cMg3utdB+tdenbVbPq1ZWi7krhuXVMgLdyleJnhyfitTmIEPJ+2Av4+BqmJADx0L6RuLuIFOYoY4gBJnWSF5hzTD3jMXq+lkOj77+H/MSx5BrBhjQff7qL9gGP4hnitt46aq0IrARcfOYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753117002; c=relaxed/simple;
	bh=GZWMVgrSUKEKBGuwg9R/osmV4nS3gmyVSRor5N4D7dE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTJ6XE/ixt4X7WPX3GrniS3RTF50aZVIzMHdwqJoK9LHnTd4wE1n/h6eRb4OT1Mhp+poFdmBik8PiPcMrALNgGDmfXsuZ4cvsMdGeShswIveObZ9kw+VJ+YEru9RBAkd4c+JpRZfdvYBsRvEFjaItjZiBUQ21JTDdTRLSsZ/SVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fVRufOfb; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fVRufOfb"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso21831cf.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 09:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116999; x=1753721799; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9vKM6AvsA9Y3YwBsR3x4mie39GKynDf2YD9Y+tfOPdI=;
        b=fVRufOfbNvI/5MkAQFKjJ2QZzESp5ceiojiJOIqrAJX+mEkr2iWNglR8jbKrErz5U4
         ySJyw+Do12XFNma5zmN7As8aQjqRJhXGTShNBjOO+ohd24+nPIn9qCAh1O5dkBWeI6BU
         8U185Pf6rWgSHz5+w4SliwvDqfIxe0WU/WkC9FhAamQbYRyb8B+fbETmqL5rgKTRocQA
         QiGtop91Z7dG1pjm8H7x3pdRcNPINSSD8xpqwlZ3XO1/nvoCMH5wMkMjWTzVRzt4HvPj
         YGczEF6OIs18NUDpGUlDFO3tfkFjYVi5O2gDzx4ai3186gRA6HSc8SEVtoaL+cqP9ZiI
         4pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116999; x=1753721799;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vKM6AvsA9Y3YwBsR3x4mie39GKynDf2YD9Y+tfOPdI=;
        b=Blqxa2eMAY4gLfuh5HzT2BZ4Xh+TzJtrxT1oxg3szUv15FzAxgik+qKDycm0+dId9Q
         Nxw18UCd3GMLb5VX4kDN30acERuxTHrVdWk6mpkvDki1NloWC3uicpMl1C9HAHGeMdMq
         37BvmxB8Y1pKUg53z/E25JycdEaF8J7i74slhHf5jjji6zvjXRuiCvB/69zOyqWJOYPF
         x9eGAvR9kiYa9/L7Q5zQnXKiF9UCUVXDqEXYazYcRp7iXNGHU2PrhHyrS4vme0XiB3Gq
         wlW9nkUzPVvyXGsWmRrS/TTv3pYjLwpAfP0uZFLymj2SlG7C90ZzU4xKloEvmfoVV/uk
         nc5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX84eciAjCUIKmK6eDT1IIIP+fdnpYATovm+ck5uEVFqeczOSdlXUzKapxW9gIIG20GA7nR7L8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyp3DLCFJuTYQT3imD3zWrgKcHHfLk5As2MBAO6Ucbrns7t5KQm
	jdxN9umNhynf9aU3AVrbb2oD7Hfr8J+4rufnpNtDYAVrBECvSQXg3hzfe/8JePvyGmxjEcWrBG4
	UBymrRrevrgSVrenMlqt0PTnkfhAy0A8axPHE+CL3
X-Gm-Gg: ASbGncsEJjX53U1R5f/PrSJRaAT0aZ2Lgdyb3E9RxzoFZC5WtykzHlErYNmz6NFfu+o
	9Hp/zkErlVWkkE2YBt7gvkp7sa9zD2UggpMN19dB2DX4msuy1HQ+0wV9vNUPEs8eOnJx1uGS24b
	1Kt/aANphRNsctLZKwo36GSEs4uZEu+A/8jKhcjsh8PjBfIpcUkRHMAybWX+kk4JPAArTvPIQzC
	FSzKGg=
X-Google-Smtp-Source: AGHT+IGgrjTvrPK9P3TS4lLZ8wE2lXlXTwd3sGct4UbwYyHLNBIv72yU2tsfIEw1OuaYcbv/aKSNeOsfq6NLKb3VZkI=
X-Received: by 2002:ac8:5756:0:b0:4a5:9b0f:a150 with SMTP id
 d75a77b69052e-4ae5b7bd536mr404521cf.16.1753116998305; Mon, 21 Jul 2025
 09:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-14-tabba@google.com>
 <aH5vNqPrUFgtZCqU@google.com>
In-Reply-To: <aH5vNqPrUFgtZCqU@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 17:56:01 +0100
X-Gm-Features: Ac12FXwfcBSTsqXm-o6oPVt5T-88WCwPmRjt4OeCKsUE5_mbRL4h4uTl6xq_Qmc
Message-ID: <CA+EHjTwRSPhC5JQs3nMG_OWevNuDGTtz-ZJNWHt4qwTWLV7Ovw@mail.gmail.com>
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Jul 2025 at 17:47, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > Update the KVM MMU fault handler to service guest page faults
> > for memory slots backed by guest_memfd with mmap support. For such
> > slots, the MMU must always fault in pages directly from guest_memfd,
> > bypassing the host's userspace_addr.
> >
> > This ensures that guest_memfd-backed memory is always handled through
> > the guest_memfd specific faulting path, regardless of whether it's for
> > private or non-private (shared) use cases.
> >
> > Additionally, rename kvm_mmu_faultin_pfn_private() to
> > kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
> > pages from guest_memfd for both private and non-private memory,
> > accommodating the new use cases.
> >
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Co-developed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 94be15cde6da..ad5f337b496c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
> >                                r == RET_PF_RETRY, fault->map_writable);
> >  }
> >
> > -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > -                                    struct kvm_page_fault *fault)
> > +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> > +                                 struct kvm_page_fault *fault)
> >  {
> >       int max_order, r;
> >
> > @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >       return RET_PF_CONTINUE;
> >  }
> >
> > +static bool fault_from_gmem(struct kvm_page_fault *fault)
>
> Drop the helper.  It has exactly one caller, and it makes the code *harder* to
> read, e.g. raises the question of what "from gmem" even means.  If a separate
> series follows and needs/justifies this helper, then it can/should be added then.

Ack.

Cheers,
/fuad

> > +{
> > +     return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
> > +}
> > +
> >  static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >                                struct kvm_page_fault *fault)
> >  {
> >       unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >
> > -     if (fault->is_private)
> > -             return kvm_mmu_faultin_pfn_private(vcpu, fault);
> > +     if (fault_from_gmem(fault))
> > +             return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >
> >       foll |= FOLL_NOWAIT;
> >       fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >
