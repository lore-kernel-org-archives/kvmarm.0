Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8564E27F160
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 09:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749203339; cv=none; b=o3cpLcZtdYHGLYcDGPDyei3fx4wHG1owYCdH2Zu34NMEjr+7+Jg3qlG8vZHmaekBQ+pqqQkcTcCzf33W+PG1ZvckDUupmCa2ACqbtL/sxTGGSTexWW04vAwlkAvqhsoT1D2pliLOX74GYGFE0gU2N53vrBVY3DlrYBgC8d/mhCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749203339; c=relaxed/simple;
	bh=YKrpoWufmzB3xu8DloFpS79I3uBwj1qNWUgY+1KOZtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V//fUvKXnLfsXPSfaQ/1P7iguaNDkwZpEHt6sN4rWaL0ycsHXweXyM+3QZm97VYjUeOfKM4gkBjLIyhxgEySb0/qMgGds4hNRnykE5YmsK5NSIqrfyyrS0hJvRqjk4k6wZMiErWjgFTALF8CJzpD+kDqOdJ2chOXMncVv+/hJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=25Wq07tj; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="25Wq07tj"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a5ac8fae12so349571cf.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 02:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749203335; x=1749808135; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LCDKfsXlZzurcM1ezkFJ6H0HklmVMiMXd+AkoFUM1Qc=;
        b=25Wq07tjkuM6WqCWaZzIxfWXevITfIWqwOHf5c9kWsqU6eFojsAohkOLee12pNZQSj
         TN5PjWvVp/ex1wMvxn2ioaNOmfHyGCq7o/FjnCSHIpF53YgAYBRebMoxhh61/EYK2u1v
         im65N5sv/fkmCu9qBJ4kyWgqGJwGwk+T/1kM9YwletXnSPlVSeDEI+AUGlLDharTGYc7
         jut0vzqmQjjULMWNk0jm4kRB+r+4KkRMAvdt7RNPKHcMX6FQ705JGR6WjJqyC05bZod6
         h5vtadbOO59EhOA0ecMgPl3qofl5lZiDEReqhrk8NI+MxVna9A5eyof2ZyPfyrVZ7H0I
         YwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749203335; x=1749808135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCDKfsXlZzurcM1ezkFJ6H0HklmVMiMXd+AkoFUM1Qc=;
        b=qk0NWNh/pFg8uNrBjQ1OQiXt0LpeYiER5V7a6KVAWMKTJT0NOlnxjpf/tZB1KYLBhb
         FLpzhI171/OCBAqrrdLaHdUvDfDib8GJBqDIaKNIdGHxUrm8Zqc1DwaiPOJx31oQhEmw
         yg+MHhzqfwUXhgg9FFJVpas49U60W9yOB19Fy5ADWLlbBjalW27HG935fvGte9Y0nmzb
         /mBNSToQR8LiB2Q629zueQ2uiuYNgboLO/tDaL2Hb8L9L9W9NiHZq1f+iVQnQhZrAY6S
         2ev2jxyo9WaIssnp9XbGXGFUlqBIveRPEoUGd1+JQ8kQzqSSBxL2LmbKOv3MpVQkF0FV
         /YZg==
X-Forwarded-Encrypted: i=1; AJvYcCWSSOXVaNA1t8Kw9A/q/kpdiNyvf4ILA/u6WiMoud1dBzjlmQmejmE3szyljqxJbGVO2Bw0UjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzowoWtevb6+KSF1zDNxEfGVBsr8U3tR7fh2r49DLq4fhMzaw1V
	c0zACTePXa8W0MScE0DPqJmJb/tG6S0YkTfuuoK/A1oXzuPZ0RdshQS12YbtrdVbJGtnsBVo0BM
	hLVOGix2FR9lvKQsmhVJxiRVZaY+JUzlB7fzYIxX0
X-Gm-Gg: ASbGnct64Ptf0lFCYwj3QUBproBGH5g0zk3zp262stjnbENlHeRsyZsaKG5fSb8pZ+X
	3Z2XBa9HiIStntF5GWrhWdHsaX6jgIbpF+tGRAw5PRPeG94SrLEGCFUslO5GEFUdWBw/dmsmFt8
	PtdBBP8av/Jg0K0J9yuMlcw0HGerKgof7Ix4ugpwyXq80=
X-Google-Smtp-Source: AGHT+IG6E/J9MfX2i8oW0aNRitzNLiDBnW8BoUvZFi+PsgUTsFLCcluC/1qihGgfccxw0D/xPEa7YdyrZSgObmD9Gpk=
X-Received: by 2002:a05:622a:3d2:b0:4a4:ead0:92c4 with SMTP id
 d75a77b69052e-4a643a2d4camr2437051cf.5.1749203334828; Fri, 06 Jun 2025
 02:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-12-tabba@google.com>
 <aa9701b7-a550-46bf-bb2f-b73462671c7d@redhat.com>
In-Reply-To: <aa9701b7-a550-46bf-bb2f-b73462671c7d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 10:48:18 +0100
X-Gm-Features: AX0GCFsIRwALL9qxco1UxN6YH4tCXZf-K_YUSzqBvF-siNiwfomILhB3vusRSbI
Message-ID: <CA+EHjTwVHg=-uPwDuQ+UF-XbwTR87WtvCWcbwb9HdQJwcDY86Q@mail.gmail.com>
Subject: Re: [PATCH v11 11/18] KVM: x86: Consult guest_memfd when computing max_mapping_level
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

On Fri, 6 Jun 2025 at 10:14, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 17:37, Fuad Tabba wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > This patch adds kvm_gmem_max_mapping_level(), which always returns
> > PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> >
> > When guest_memfd supports shared memory, max_mapping_level (especially
> > when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> > from recover_huge_pages_range()) should take input from
> > guest_memfd.
> >
> > Input from guest_memfd should be taken in these cases:
> >
> > + if the memslot supports shared memory (guest_memfd is used for
> >    shared memory, or in future both shared and private memory) or
> > + if the memslot is only used for private memory and that gfn is
> >    private.
> >
> > If the memslot doesn't use guest_memfd, figure out the
> > max_mapping_level using the host page tables like before.
> >
> > This patch also refactors and inlines the other call to
> > __kvm_mmu_max_mapping_level().
> >
> > In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> > provided (if applicable) in fault->max_level. Hence, there is no need
> > to query guest_memfd.
> >
> > lpage_info is queried like before, and then if the fault is not from
> > guest_memfd, adjust fault->req_level based on input from host page
> > tables.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Co-developed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
>
> [...]
>
> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   {
> >       return false;
> > @@ -2561,6 +2565,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                    gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> >                    int *max_order);
> > +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
> >   #else
> >   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >                                  struct kvm_memory_slot *slot, gfn_t gfn,
> > @@ -2570,6 +2575,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >       KVM_BUG_ON(1, kvm);
> >       return -EIO;
> >   }
> > +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> > +                                      gfn_t gfn)
> > +{
> > +     BUG();
> > +     return 0;
>
> As raised, no BUG(). If this is unreachable for these configs,
>
> BUILD_BUG() might do.
>

Ack.

> Apart from that
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>
