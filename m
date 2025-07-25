Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442471D63C7
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753451588; cv=none; b=TiEyPkwJrNNR0K1uIPYpOykmwIACW6WPj/RdTsvsBn1dei7CkJUr1MshPj6qhiY+b3Lq8UZTXukhyAtd3CSOfyhFrcXE0fs1USF6mnzunNKVyRmHuiz/7UCsDHiUAYoLY0lMTICTzHnAl1vwzKuqf6e7yhPMAf4MMHG8UNlnN1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753451588; c=relaxed/simple;
	bh=N87jvq3BUY2gPXiuHgKyY6u8QFonP5K7Oiq3uLPHJa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JCsiVECXIhU5vIMa9wjPkNqrsOQMsgOJ3k6/aSuxGcnKujQ1r/8jCwB9SHeCeBDSEDLXifvrju7L2mZvv4HliIDrbAnt08tz9oggkulPNOgv/O6TI8Ll7niZ/szWUF/wG0akqq0B6NlUVgZJACtgy1peQTwNYRO0sLNf3ex1gX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E2SkudtI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E2SkudtI"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31332dc2b59so2181146a91.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 06:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753451585; x=1754056385; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=E2SkudtI8J5FDSKDuikfkywxFrwAEy/1VIF6SmmnZD8+F53L4CwMqMwPdabYLpQUG+
         +pNlhRje5CsJVrr+5NwjqjtT2SV/z6Y1vYS6D7kS/9M65h51qcsem6qrQpljz0j99OyQ
         m2VCUDB2kOrlgEkgU2iYe6UAz8oWiAMGujrUeJYWyFcQIfnas4ScJb1Rme+tOhrc+IH4
         PgsL/dSqBX9RnIi7K9s+iV/MkVC5sc69MzV/b2A7j3YBkEcv5uOyS/B2aUGDAn5IPpER
         F1DIcURJ4c25ZVuTxSQbX9u18EjE0W+OjU6+7DQv2tOoWGkgevYqrft7yVI+Ge6+KGQi
         nGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753451585; x=1754056385;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=mBa9Vdp4NQOtFze/TfmmJQ7rkRvhpACaaXZRGWLW0Jt7gBoc36v/Sd1Og5AB6pUOl5
         5/o1jRsJA4PrmpN3fC8XFg2aoLDzftXjrAeSIXppyJQwXgwnt5INORIrX8N5YRkzOVLi
         jULBAp9svY+UfgTzUNie6VVpbstuNzMClLUdOMYoly/lqKGkiMMmpp+EJB6HQVHPrn8l
         f9WIqfXktqNtZcD0aBhmDmuK7dG8rp6uqm/j3BZEbGy/srwHupEGDP7OtxAyQnSg5rco
         D8Xbm55VgYVq10Q5uNty8QOHtqlo853XtUhT4aciEDFapLJSmhAiOWemfVm912qQyZc1
         mvlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnDhwUC2mH/RdW60kDUzkbDdbuT4nqNpLLDshf7IvMOMaZY5Butk6aFecAIhw5jhj/62nY/EU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMVyyEbcyoNQryj8rq+VJHRDJk0yKUvDmkLEd6l3vGsEvWKKQF
	l5eiRt8ZmHgOlUnazvggWb/1YqNzcS3X7k+dIhv7YO/pKVCv2qRfcbCxG4XHJxaObLro6iZM+6v
	7tjmB8A==
X-Google-Smtp-Source: AGHT+IFjGdSbLTJQeXBeF3KPsF2x5fp/wtnoZ2iNYJbBIB/HYs8Zqa8zIKSNCWliwPnicno1k0gnFATv6p4=
X-Received: from pjbsp12.prod.google.com ([2002:a17:90b:52cc:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5804:b0:311:f99e:7f4e
 with SMTP id 98e67ed59e1d1-31e779fa061mr2853030a91.16.1753451584187; Fri, 25
 Jul 2025 06:53:04 -0700 (PDT)
Date: Fri, 25 Jul 2025 06:53:02 -0700
In-Reply-To: <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOMPpTWKWoM_O5J@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *=
fault,
> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, st=
ruct kvm_page_fault *fault,
> >  	if (max_level =3D=3D PG_LEVEL_4K)
> >  		return PG_LEVEL_4K;
> > =20
> > -	if (is_private)
> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> > +							is_private);
> >  	else
> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>=20
> No change required now, would like to point out that in this change
> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
> shared pages, guest_memfd will be the only source of truth.

It's not an assumption, it's a hard requirement.

> This holds now because shared pages are always split to 4K, but if
> shared pages become larger, might mapping in the host actually turn out
> to be smaller?

Yes, the host userspace mappens could be smaller, and supporting that scena=
rio is
very explicitly one of the design goals of guest_memfd.  From commit a7800a=
a80ea4
("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory=
"):

 : A guest-first memory subsystem allows for optimizations and enhancements
 : that are kludgy or outright infeasible to implement/support in a generic
 : memory subsystem.  With guest_memfd, guest protections and mapping sizes
 : are fully decoupled from host userspace mappings.   E.g. KVM currently
 : doesn't support mapping memory as writable in the guest without it also
 : being writable in host userspace, as KVM's ABI uses VMA protections to
 : define the allow guest protection.  Userspace can fudge this by
 : establishing two mappings, a writable mapping for the guest and readable
 : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
 :=20
 : Similarly, KVM currently requires the guest mapping size to be a strict
 : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t supp=
ort
 : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
 : mapping.  Decoupling the mappings sizes would allow userspace to precise=
ly
 : map only what is needed without impacting guest performance, e.g. to
 : harden against unintentional accesses to guest memory.
