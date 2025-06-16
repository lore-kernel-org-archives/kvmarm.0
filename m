Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504BA1F4701
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 07:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750058057; cv=none; b=tHIIiOX1q2WxMjGQuhbcAonHnKjOUnEF3Wwmj5FBqFeFmcDaLS5hND7zYp1OMI8F/50EgRURQadKda+xp+zL8pmtDanpfI9UIvYjNBxXKsxLqeDkldDtxDtfAIDm/q6w1QNL2bvWVc/+TP+TXNe7uTX0FwKxgl6hnjmkCeGQoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750058057; c=relaxed/simple;
	bh=5B+m8LJRszE/eOQ7rN2wxVR0e0sQd7dvBxHZtcWiquo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdFgzZZouxPVUXvnmKmCmKg+jK1U5xbO8FXlB5uuNnca04r01osZheZVOMPZrW15gYAWsTpu9WrwfC3VCKYrMrXO3dq0SBeWSF5hC7zVrAuqZzuZbXsZPuGVYQMOlLnfNqL3n4RiBc+e3hbWkOD/sv+cc9KF2Z5gHFZkLmoe83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DtBFM9QI; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DtBFM9QI"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4a58ef58a38so293401cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750058054; x=1750662854; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4dscraCi99Sxb2AdbSI/1exeAb4GQbHQ2olocOXtjo=;
        b=DtBFM9QI1/lK7IVtpugmHmJZoRVVpismt6IoF8/LuzOm8H9AmpZja3XcUuyDyGnxrX
         UUkngKWHhxpAYLADNOUGn2bQ29tvSk6Y3tqUwjiUc9I7tZqTmpyGYOdR8RWH19qJrkJS
         /Wr06UMY2G0rKTYFVEs5JjrbjXk8KZPFQxb/w8wssLQhSybPlV+BZxtAYStD4APKT/hS
         oJmyWOIuVmW60X1k+LV4ySIcQw9+LK+G3Tdss3hso91z4EX2baTCgs/DZAh/iuAL5ewI
         DXVLJitzY9ghk1133Bp7c7IWO14N6IZ7hbuGhemO4rVp58hBGef5h4YKJv+ZXYH2i9tH
         K/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750058054; x=1750662854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4dscraCi99Sxb2AdbSI/1exeAb4GQbHQ2olocOXtjo=;
        b=rE+blxHddKokf36INYL4Fl1atNTULjSwAE/menMPU8l8VZd5lHR0viO7r0+pp/wROx
         UNqbrFNNW6h0F+tsmPJa15dzXTNvhcrSAF8GqAfFB5Qv5FxkG2d495yP1r0PwTX/i9uJ
         WwvlA2VfYgBYtjWli2Lbfk4klbf5/rgYDAG8+a5OK9ffEuOcasgYZXcX3+Ixd2x0c7nZ
         03vzKZ7qroI1LY8eYfGpcfFTslt+kzsZrNyigOFCED4yV8rgJ07xLMyr7MVLzI8c4OX+
         S0ZlL/CAJBGj5lWbcYRjrKOLssRW3lqE2Mvooo2Uoxaj+IRSkfGhhJ39s+CoV4twD07z
         wdAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhT/yMC+xQaxoHn+ShfZCcIzKdXuiwG5WpoTPd25WRjSmdZq7hXHpypHlv5dKTP7Pw7v6cXvQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjVdVjYkBtNMobCE64DvNbFwjuKyXHGNzPg4uEUmKBZu+4keON
	lmvwUHqhncpz7XYpbAgc9EutwRbS9B0hr9Wc8tWwdOA8e6NZGbCq0qrYVY2J4n8qhe2XLhJGnLr
	9YnMibvGoRcCXV/cmDqD9lD+CH4jmRbT0598fljVX
X-Gm-Gg: ASbGncuoxuqTve6Ee67ql5hpsE5AUZuBn3eeui0oX58HfbYy/9Uved2ptC3k4EJ3Xas
	kNOhW+BXDQBsR8tKk/wo0Pv6mBjXFA5hbnaYm9qhkZwpD1NQ5nArSaWeO0SxaYIzT+ulu/gKyER
	V7ZzUmrLLcn6uxR9ATtPh/LsqwMGdr/Z0SytCd1TtGmWuEXTHP3NSb/w==
X-Google-Smtp-Source: AGHT+IHRP1CpUCig8F7p0iqSMmnDgYVd+hSQrG9KB86uiC6pnZNQNaE6PPvaROhLDIFwY0y51UIij5JffUL2jbFDWys=
X-Received: by 2002:ac8:58c8:0:b0:4a5:9b0f:a150 with SMTP id
 d75a77b69052e-4a73d63d978mr5025451cf.16.1750058053808; Mon, 16 Jun 2025
 00:14:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-5-tabba@google.com>
 <aEyLlbyMmNEBCAVj@google.com>
In-Reply-To: <aEyLlbyMmNEBCAVj@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Jun 2025 08:13:37 +0100
X-Gm-Features: AX0GCFulb2IhkWValvX9vFqGHI2nVg_Dnrs5LCKRKWUrkMeevUaVx5iPDic8k40
Message-ID: <CA+EHjTz=j==9evN7n1sGfTwxi5DKSr5k0yzXhDGzvwk7UawSGA@mail.gmail.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
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
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Fri, 13 Jun 2025 at 21:35, Sean Christopherson <seanjc@google.com> wrote=
:
>
> On Wed, Jun 11, 2025, Fuad Tabba wrote:
> > The bool has_private_mem is used to indicate whether guest_memfd is
> > supported.
>
> No?  This is at best weird, and at worst flat out wrong:
>
>         if (kvm->arch.supports_gmem &&
>             fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))
>                 return false;
>
> ditto for this code:
>
>         if (kvm_arch_supports_gmem(vcpu->kvm) &&
>             kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))i
>                 error_code |=3D PFERR_PRIVATE_ACCESS;
>
> and for the memory_attributes code.  E.g. IIRC, with guest_memfd() mmap s=
upport,
> private vs. shared will become a property of the guest_memfd inode, i.e. =
this will
> become wrong:
>
> static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> {
>         if (!kvm || kvm_arch_supports_gmem(kvm))
>                 return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>
>         return 0;
> }
>
> Instead of renaming kvm_arch_has_private_mem() =3D> kvm_arch_supports_gme=
m(), *add*
> kvm_arch_supports_gmem() and then kill off kvm_arch_has_private_mem() onc=
e non-x86
> usage is gone (i.e. query kvm->arch.has_private_mem directly).
>
> And then rather than rename has_private_mem, either add supports_gmem or =
do what
> you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the =
VM type.

Will do.

To make sure we're on the same page, we should add `supports_gmem` and
keep `has_private_mem`, and continue using it for x86 code by querying
it directly once the helpers are added.

> > Rename it to supports_gmem to make its meaning clearer and to decouple =
memory
> > being private from guest_memfd.
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 4 ++--
> >  arch/x86/kvm/mmu/mmu.c          | 2 +-
> >  arch/x86/kvm/svm/svm.c          | 4 ++--
> >  arch/x86/kvm/x86.c              | 3 +--
> >  4 files changed, 6 insertions(+), 7 deletions(-)
>
> This missed the usage in TDX (it's not a staleness problem, because this =
series
> was based on 6.16-rc1, which has the relevant code).
>
> arch/x86/kvm/vmx/tdx.c: In function =E2=80=98tdx_vm_init=E2=80=99:
> arch/x86/kvm/vmx/tdx.c:627:18: error: =E2=80=98struct kvm_arch=E2=80=99 h=
as no member named =E2=80=98has_private_mem=E2=80=99
>   627 |         kvm->arch.has_private_mem =3D true;
>       |                  ^
> make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1

I did test and run this before submitting the series. Building it on
x86 with x86_64_defconfig and with allmodconfig pass (I obviously
missed TDX though, apologies for that). I should have grepped for
has_private_mem. That said, if I understood your suggestion correctly,
this problem wouldn't happen again.

Cheers,
/fuad
