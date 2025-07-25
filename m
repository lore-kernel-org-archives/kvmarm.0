Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8BA2EBBB8
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753461652; cv=none; b=BKXcbPLRpDpNBbUnEiBiapBaDxzNsljP4t/L4kR9y53qXYxoomf4WOZmBl+YkwDGj7QD0jf3v+DIN0+jT2C7kzvNH0JN/dYRjfBtl0sLS3RF/UiNsRnUsijB6jX6MSMZj7mC9veTzLeXePMip83cbmIzfuBJsejg3SMSc6IIBb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753461652; c=relaxed/simple;
	bh=P3KVaroHnVD42PfWcaEs1jq2NjLZSICPGWqBQDxF3M8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cDhw0xOdWZBMdpSj4h6/k5fgMDK/zZ157TBLU4UMNZ73fk1JcF3vZ4Q+kMBuvIa4nIBvXCc42zrjZV/OnJK6Uvifl0C3VcvBoY295v/gxAESJKWQQVwuyUVPeX4RDZlhr+RiW86SndVvHCHYYZr6wmcQvTU3VdKggkrJyXP7pjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Axzd+Bwq; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Axzd+Bwq"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3510c0cfc7so1758652a12.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 09:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753461650; x=1754066450; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0vJgkAubMXXN6o65VTnm8PRheVkeM5gEkAdD1H4GYM=;
        b=Axzd+Bwq4NFuyoSJVA9kiZwETg7LZZKL5X9WHdHXv9qfI6WtPNE0Lu29Xsow7O0nSG
         vcvcewQpEKSdzadklM5UxP/WLnkMAAmEE+ApROKX4jg/yMbZECGvUv6WX8F9n13ub5M0
         lED2TGxKN8ldXd0XLD0SmNKUAJlJqG6jK5QdBBf1ot47FIrQpJyWkz0h5YNNgMJ09oD7
         P7cqT4mb8z5P7WZd/lkmxYihUQU3gqtF0K8tOAMdHasNEPzDrEZyfD2GBEGSuHAqNYZ2
         V5ujtaOxPQeAxfBnvHtXBM1O7kzd0peopv9pjNeMPfmTHtGi7SPqr56YzUp9ovRENSGc
         I1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753461650; x=1754066450;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h0vJgkAubMXXN6o65VTnm8PRheVkeM5gEkAdD1H4GYM=;
        b=P5Zt/lPePLxGthHhATV/LjUgGg+cZ/KTeeRsLlc3uS5orL52E3jWZZPerbqN7fh+3b
         klrAgoY04TaIHEDs2mCwmxBAH/6HCSOz1vHFXb/vecQ6D7+7CvoDSRhAKBVy/XGQP31n
         CMSOJKjFiZKs5QYZfHGO5I97Ap4itwDQPVM/0O2qS3wQq7G9+CGFwlrk4sSfSohZTJov
         KuFsmeAdTNC5EpRQKvgJHfFnH8gdCDsd2Hyp3E8Rl5Wcwxa7gUF7aQYJ2CwfjMH8pFFK
         tv3/bWaEh+9eAAW4A8VQzRwk8wnPdqgyiaFXlWYIvNuGdA3VCn+3WBlRbZJUSLXVStAe
         OpgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRqPGw68RbIvQt0eIWqlI6KIDADnlcLEbhLSaG5Je1LOn8aOVy3jkgm957aVmj9wqcEvZHohE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHiQ70N1ouK/N9VZC7izEL0n2k5FuqoaCJNODGYv3mrH5nuKIU
	9kE529EdwWnvIpvt57Do6QM98nQwwgSM1q+cb6VM3ErYj++1wP1A0hwZws2QUnirV+TiVWP1Bsw
	EliBXjgXrU5anSHLazsJjBZ+CMQ==
X-Google-Smtp-Source: AGHT+IESSUb5A7ox/0yy/1EortQTdLaTQG/uMcj33CzvrGYLDRDtIu6A1gNBwhWuX15U4LdcnVba587BKC1ItwdU2g==
X-Received: from pjbqc8.prod.google.com ([2002:a17:90b:2888:b0:312:26c4:236])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e185:b0:31c:bfb9:fca0 with SMTP id 98e67ed59e1d1-31e77a18508mr3602768a91.4.1753461650340;
 Fri, 25 Jul 2025 09:40:50 -0700 (PDT)
Date: Fri, 25 Jul 2025 09:40:48 -0700
In-Reply-To: <aIOMPpTWKWoM_O5J@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
Message-ID: <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
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

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> Fuad Tabba <tabba@google.com> writes:
>> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault =
*fault,
>> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, s=
truct kvm_page_fault *fault,
>> >  	if (max_level =3D=3D PG_LEVEL_4K)
>> >  		return PG_LEVEL_4K;
>> > =20
>> > -	if (is_private)
>> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gfn)=
;
>> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
>> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
>> > +							is_private);
>> >  	else
>> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>>=20
>> No change required now, would like to point out that in this change
>> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
>> shared pages, guest_memfd will be the only source of truth.
>
> It's not an assumption, it's a hard requirement.
>
>> This holds now because shared pages are always split to 4K, but if
>> shared pages become larger, might mapping in the host actually turn out
>> to be smaller?
>
> Yes, the host userspace mappens could be smaller, and supporting that sce=
nario is
> very explicitly one of the design goals of guest_memfd.  From commit a780=
0aa80ea4
> ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memo=
ry"):
>
>  : A guest-first memory subsystem allows for optimizations and enhancemen=
ts
>  : that are kludgy or outright infeasible to implement/support in a gener=
ic
>  : memory subsystem.  With guest_memfd, guest protections and mapping siz=
es
>  : are fully decoupled from host userspace mappings.   E.g. KVM currently
>  : doesn't support mapping memory as writable in the guest without it als=
o
>  : being writable in host userspace, as KVM's ABI uses VMA protections to
>  : define the allow guest protection.  Userspace can fudge this by
>  : establishing two mappings, a writable mapping for the guest and readab=
le
>  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
>  :=20
>  : Similarly, KVM currently requires the guest mapping size to be a stric=
t
>  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t su=
pport
>  : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
>  : mapping.  Decoupling the mappings sizes would allow userspace to preci=
sely
>  : map only what is needed without impacting guest performance, e.g. to
>  : harden against unintentional accesses to guest memory.

Let me try to understand this better. If/when guest_memfd supports
larger folios for shared pages, and guest_memfd returns a 2M folio from
kvm_gmem_fault_shared(), can the mapping in host userspace turn out
to be 4K?

If that happens, should kvm_gmem_max_mapping_level() return 4K for a
memslot with kvm_memslot_is_gmem_only() =3D=3D true?

The above code would skip host_pfn_mapping_level() and return just what
guest_memfd reports, which is 2M.

Or do you mean that guest_memfd will be the source of truth in that it
must also know/control, in the above scenario, that the host mapping is
also 2M?
