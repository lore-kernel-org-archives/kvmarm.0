Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426CC1F4190
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 23:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753141847; cv=none; b=E9NB8lyLTGg2w+9N53+BqZBCCMC4/LhgHdsLMks9MBRUHUJhVRx03zEHPbvXpqH3xXDY6rZG+2wZX8T926sV5ZsgfhzGeavFSYE4wt4PKeH827F/6IoRGHgsoCRWw4LiHIq+ivRPZND3UC6BbS22NRIyIsLXNGdl+1i8t2mV4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753141847; c=relaxed/simple;
	bh=X76sqgXUjd4+zPeFBazIpld1nyyNRqan5r6plQcLZq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C63UxFuhy8c0OUCez1KleEZc+VMXYTW/TX0K+yqzFd51Zm75m4AWrBQi5UnGOWd6FUjJsbxjYsu+aDBvfzJlhlhYZc+Xd4bLwcnrjibpfPilfJpcxec94i+I3FF1f2+kJHe2ohN5OYG2xyECkaBkC1QYuMWAjtKh6i+LaTnheqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLb8WOtG; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLb8WOtG"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235e389599fso90525ad.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753141845; x=1753746645; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=gLb8WOtGDk6XopgRUog5OVIx5bc/+DgnAVTMr4+GtPwn7uAPw6vYYtj3BB+jf/zvTM
         /OmlkIEYz+NE4/Ji6P8iEvCD+R2j7Rs/IFLgYfU3GGyqLNHDPb+mUTkdW1wAATtRv/7d
         zghOpZy100TwWHXP3Qg74hfCB49GiK9zM4pVfg31f2JabyI8hTmyl2rQoGnd11ltOxBF
         fEVzYcGzk9IYEHYdFfm0YUzwZuqwNITo1016v7UnZ3X4+Wu4qpdEAL1IqnpmcChMPPR8
         dImF/FPyQ5RLnAOFUkGFPCYazKmnrcHFnIs873fBH0jUaUZO+blcq4EC7+KPeyWAYqag
         UcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753141845; x=1753746645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=nFofmN1IVPavuQjn1MG4bX2udH9kaKkWzt1E7EdJ/KxyOs3DnRCXnNshAeqwhDZmWB
         2D+mlN4uv4PWBzbVQ5N6aE/i6uXXW4kIPycGdRcDJhJGO7nz7Bn9WZL4rie/XEqDd7Ia
         qI+BouqxA6fUoAI8rlOF1TBo/E9+6/vSby6FYLL42rM4ykBFO2d+OLXi9KD/1cHyBdf5
         AH/7xYuEuH4NlQ1y92bN1MEXS5MLp1Jhb0Ulim+V5rXBVIoO4nAeg5T5r9ZoyuiV55/j
         J3Otm+jC31pVkCmNoOuyNmMFmOdq1jTRsN3Fgn/0gHCAhxmKixGwBHvzIekTph/n65Bo
         KaJA==
X-Forwarded-Encrypted: i=1; AJvYcCUnbxyt7aK6mBf0fjYpYKI/pIK5ymQb8IzOoWoejGhnqJn3XUeKLyhlpnNudBzU9ZCm0bPPTeA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH1HV5loXSO8er0smKcAajoabkzmv3yKQQg1Ff3lwoKfmG0Xg0
	GyV4wOm7goBYeFzTKM0MGzo73w230VMCt/X6YwYMQuqnaBjnJz7aPsWV9wOtPZt/wcKxjkJ0Axv
	uZqTtWhgP7p19wIutn6hWCgwJ3YC2iKkZtS22V7fA
X-Gm-Gg: ASbGncvJ4CGAs30XRCOU+oE+PzSPSE985zed/kUODk2uLufLKZJalKP608F3/UMHsC3
	yte92WeUvK/oU1Z74pj71Ne7Ir7s+qz5JSK0h/vGsmB8dc9qJ07/gHKZzo0HDDgCtkfKq53OZf7
	4hrCBLpqg6oWGIX7NsHvrBqibH7CM8rzNwMy3VhXUm0CTuuliO9O2OeU9y3qLhOEphK2w6qVAei
	chl16OJZRhIQjq/+HmJ2eixXgNtdu1TFZaczoyXvJbf38kF
X-Google-Smtp-Source: AGHT+IH3YiQMKqSdvOi3Hl2chQEQjKBZYYncsqU52df1Cul+060EhTbwEXWwh9jGrpqKQQvBZjZc/wdEQOaLY9BZwWk=
X-Received: by 2002:a17:902:e5ca:b0:215:65f3:27ef with SMTP id
 d9443c01a7336-23f8b590f46mr1250935ad.12.1753141844936; Mon, 21 Jul 2025
 16:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com>
In-Reply-To: <aH69a_CVJU0-P9wY@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 16:50:32 -0700
X-Gm-Features: Ac12FXzatYxpj7dOmCOTU3y6raVwJgub7Hc67jtCHL8r3j1EPu7lx3yUXCqmwaM
Message-ID: <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
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

On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > >
> > > > > > 2) KVM fetches shared faults through userspace page tables and =
not
> > > > > > guest_memfd directly.
> > > > >
> > > > > This is also irrelevant.  KVM _already_ supports resolving shared=
 faults through
> > > > > userspace page tables.  That support won't go away as KVM will al=
ways need/want
> > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (=
even for TDX).
> >
> > As a combination of [1] and [2], I believe we are saying that for
> > memslots backed by mappable guest_memfd files, KVM will always serve
> > both shared/private faults using kvm_gmem_get_pfn().
>
> No, KVM can't guarantee that with taking and holding mmap_lock across hva=
_to_pfn(),
> and as I mentioned earlier in the thread, that's a non-starter for me.

I think what you mean is that if KVM wants to enforce the behavior
that VMAs passed by the userspace are backed by the same guest_memfd
file as passed in the memslot then KVM will need to hold mmap_lock
across hva_to_pfn() to verify that.

What I understand from the implementation of [1] & [2], all guest
faults on a memslot backed by mappable guest_memfd will pass the
fault_from_gmem() check and so will be routed to guest_memfd i.e.
hva_to_pfn path is skipped for any guest faults. If userspace passes
in VMA mapped by a different guest_memfd file then the guest and
userspace will have a different view of the memory for shared faults.

[1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com/
[2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com/

>
> For a memslot without a valid slot->gmem.file, slot->userspace_addr will =
be used
> to resolve faults and access guest memory.  By design, KVM has no knowled=
ge of
> what lies behind userspace_addr (arm64 and other architectures peek at th=
e VMA,
> but x86 does not).  So we can't say that mmap()'d guest_memfd instance wi=
ll *only*
> go through kvm_gmem_get_pfn().
>
>
