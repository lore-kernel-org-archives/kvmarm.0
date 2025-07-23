Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541BC2F49FA
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753279726; cv=none; b=K0N8yEmWFsKY60YMNL2RetO4uQ+ftVwKvldcAqqnoYpBZag0qc6z47AiL5JFjQJW5IWv2RWVpl4C9h1VkD7wolfIVkarQ6QvPGLesfrzjA1186HpY74aYBHLFK6cpD8kUO/yC/8ooK5R898FZxNjyXzA/xEhkmPQNF71tSkE1Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753279726; c=relaxed/simple;
	bh=tq5Kf8dwR7CYoLdEJRggmZPGMKe1UsIP7+oXnldstQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMOJixVwj4n0IIIvhVrKXwb3A7PMj/n/E1/28LwYN1tzzXYfX4kssaESdzhrkYGY8j2w6akGD0Y7N2zCZxH3i9c/WExjxeFT5xjkMsnesxBfUrbgl4n+BStRE32zYYONeyjpJxNL3fIAuN9y42QY6VGHTYGN6FIXF//Kv7JGnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oIT1q7LC; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oIT1q7LC"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235e389599fso219835ad.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 07:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753279723; x=1753884523; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=oIT1q7LCD8pAn4vXabaqDVZybfN0kZHZ8PmPD6B6yE/x0vJN1Dr+ldFJ4BaJBgqpey
         j4qieO6ZuIJ8owcMXnJr017ud9SYsVefI+CmIZ91TS0S62nFDHGOUqptAzQ+Dmyuhf+d
         /y6eTJXaUgDJBxK1X8d1etvD4lt4fS9F2YkIyjt6T76TBdSqtRwxh0xnl7WP0mboWh8i
         WtVnXh1FjDKRsB7Ug9R7lt4uckH4eT8nUQ+dW4Lwj7natgdWh+IU53zVHMrbenD+PQWI
         u7cHdCJZ97RApLazytlFyrjXmCGdM0ScyhxmgjDtHcFhY120F8qi0CnmZG+qNnoPD14e
         K1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279723; x=1753884523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=NGJFLIHt7VeTgSWQASMVEBlQkCYw2Y1xi8WDEPbPkZhpegiKH68EnPbXGkWOC7zWQQ
         CdQNVHk35qIpKMl6bGI3xwe58KF4jafZk3yTM3bJ1dQSOzNVlg9n7huUMKK1T8iYogH8
         4cbQevXiQ1u3+vS2kBdcdH5J4zdpZ6OgblcdIMDKa8sFr47EKcvyl4UPplV6S9Q57aXc
         DmF8jqzUktyxJ8sa+X4rkgKKzG+MRtH/2So+1GEPNWNjajkgoZQC0l4YSi7ybzcEdy1o
         KS90NgRjtXwGPdTRtvPjO3sPedPa6WL69gpiTLtbzTXO1PwHdfb1PAXZ7VoyCBndxyJl
         QPtA==
X-Forwarded-Encrypted: i=1; AJvYcCW6L7LbFg7GusdSSDyOQwWZ4iSPQzSylja1AxxEkBabU5ClqY3LzhjATnzWTy/n66QXBXSNEaU=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywe13DvBUzzHIjZ5BxK2hG8NmjxI58ZNyoO6xr7YMReOTcEAS5O
	MR1n35xIwx7NaucoF3IjD1WK7jSvrPCy2i9YNwDKO9p7W7Mw6VxvGTJjPcvy/mcFEftRtpQbYeY
	NyuFSwLvRFKlzQm5aby70C20eR8oFh58+gSK8w29w
X-Gm-Gg: ASbGncsF5lYjwo4UXREH8outDiN3Bc+zcY5GMqA7dpJAC5SHra+jBiMJjocpEXJJryD
	k3tJZzYBwisECW9bT2s2Mn0/khYySqMzT0mF0tQCUwGNO2HNwJWQ+6MGmxGzsDRJpqKvcdCIwUT
	kKYMBX6ynWLB4j+l7moZO13K2nuBFAcD5EOgrgZIpA/UpCnAHTettd5qwfDT7jZGNe6KrRICT8j
	a84mjAeXgQQpAZug4k95REgU0Y3idzYRYmqTaeG
X-Google-Smtp-Source: AGHT+IGTqBd89Hz2FU5+XDL1Pa3oPTMlfNKSx7fc+kyEKrz2+R2DB3L/Vg2Q/bKXh/ftc4wQ1ninLLDh9ZPqaALt4Zs=
X-Received: by 2002:a17:903:1a2e:b0:235:e8da:8e1 with SMTP id
 d9443c01a7336-23f978e11f0mr3711085ad.18.1753279722891; Wed, 23 Jul 2025
 07:08:42 -0700 (PDT)
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
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com>
In-Reply-To: <aH-hxiD2DwovFpqg@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 23 Jul 2025 07:08:30 -0700
X-Gm-Features: Ac12FXwpJ1aG0BseZ1JbWyOGHq9d8eSgResVmgCZ2LYsmpKUxZNm4vyPGOyUMSQ
Message-ID: <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
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

On Tue, Jul 22, 2025 at 7:35=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > > > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > >
> > > > > > > > 2) KVM fetches shared faults through userspace page tables =
and not
> > > > > > > > guest_memfd directly.
> > > > > > >
> > > > > > > This is also irrelevant.  KVM _already_ supports resolving sh=
ared faults through
> > > > > > > userspace page tables.  That support won't go away as KVM wil=
l always need/want
> > > > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the gue=
st (even for TDX).
> > > >
> > > > As a combination of [1] and [2], I believe we are saying that for
> > > > memslots backed by mappable guest_memfd files, KVM will always serv=
e
> > > > both shared/private faults using kvm_gmem_get_pfn().
> > >
> > > No, KVM can't guarantee that with taking and holding mmap_lock across=
 hva_to_pfn(),
> > > and as I mentioned earlier in the thread, that's a non-starter for me=
.
> >
> > I think what you mean is that if KVM wants to enforce the behavior
> > that VMAs passed by the userspace are backed by the same guest_memfd
> > file as passed in the memslot then KVM will need to hold mmap_lock
> > across hva_to_pfn() to verify that.
>
> No, I'm talking about the case where userspace creates a memslot *without=
*
> KVM_MEM_GUEST_MEMFD, but with userspace_addr pointing at a mmap()'d guest=
_memfd
> instance.  That is the scenario Xiaoyao brought up:
>
>  : Actually, QEMU can use gmem with mmap support as the normal memory eve=
n
>  : without passing the gmem fd to kvm_userspace_memory_region2.guest_memf=
d
>  : on KVM_SET_USER_MEMORY_REGION2.
>  :
>  : ...
>  :
>  : However, it fails actually, because the kvm_arch_suports_gmem_mmap()
>  : returns false for TDX VMs, which means userspace cannot allocate gmem
>  : with mmap just for shared memory for TDX.

Ok, yeah. I completely misjudged the usecase that Xiaoyao brought up.
You are right.

These are two different scenarios that I mixed up:
1) Userspace brings a non-mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2) : This is the legacy case that needs
separate memory to back userspace_addr. As Sean mentioned, userspace
should be able to bring VMAs backed by any mappable files including
guest_memfd except mappable guest_memfd is not supported for SNP/TDX
VMs today, that support will come in stage2. KVM doesn't need to
enforce anything here as we can be sure that VMAs and unmappable
guest_memfd are pointing to different physical ranges.

2) Userspace brings a mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
faults via guest_memfd so if userspace brings in VMAs that point to
different physical memory then there would be a discrepancy between
what guest and userspace/KVM (going through HVAs) sees for shared
memory ranges. I am not sure if KVM needs to enforce anything here,
IMO it's the problem between userspace and guest to resolve. One thing
we may need to resolve is that invalidations of KVM EPT/NPT tables for
shared ranges should be triggered only by guest_memfd invalidations
(This is something we need to resolve when conversions will be
supported on guest_memfd i.e. not for this series, but the next
stage).
