Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE27022F16E
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 07:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479029; cv=none; b=EKhoBw8rIBjuMtoqPoYupk3m96FCS+x8XbXfGBY6P9PBd6c7LVe75AAvPDZVlDo8ps1wY2gwnrS+N/mE4+fDwPiQiddeH92B86FSGZU/89FKwEU805NI2fb2yW0sMnpNUvUFsVI5RAmWxl7IO5yfKxpJSKH9TlJl/0sRxVDOM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479029; c=relaxed/simple;
	bh=72mcn/0aA36J4IDVjbzyIq+5WtdsSwvXzhtQrJVppjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e2dIXxYAxQylS/k1c+WYsQrh19GqB+MkwmHPmyDuh7qMxvs1bySmMlcC2HFW8IBAGbgY1kOedOQBb9bTlCJYSQ4x7IPKkei0xWd0WjBNsaMFGohiwibzdNCKU3NwJsIwpP7EzQLEy5V4u3DgkxuuRpOubijSs0BDubN6CbUcSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sy6wEhPP; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sy6wEhPP"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab3855fca3so612751cf.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 00:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752479026; x=1753083826; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c3n8ur35WlJXxN48wV7a1ksueuqBtEVY/pvsx7vZS2c=;
        b=sy6wEhPPpQWy/ux1qKB8x7W4JG/JyJ8KiK3CYoZ8+iZ+yYpQMCfCBF06m8qMZiphrA
         SJCZUldOojMOr3oEwcMPM7Jwz3MPP/+8s5AhrXqid8MudSV/lks0vCAoU+jNAcXdFMo8
         lbY1+Onw4tvsKqe8T9SVL5+I49DPJT/zizuDKwBYgCXovdlA1DPN91rg892mRfylY+lk
         bektra5j91/w9/mB9qbOzmyNnn8T9zuGvKeJ04Nz3j8GobnlO30zTuI0Pr7hqrYXIYOl
         J9xTPuhBt26Kpr6Vc72rUoyHrMYpbbrIJ2K+BLanwIPZ1cMTSEhHDqXbMRC/+WzM2jpc
         0DEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752479026; x=1753083826;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3n8ur35WlJXxN48wV7a1ksueuqBtEVY/pvsx7vZS2c=;
        b=w+VoZuTPvd4AQaXx36klfgo63ViBjr5NRNhoPhD+aNyrkgVaXlQINfH99bkjyC8hwa
         6Tk56vZG8UE9B+oVDDFNkjRmuNIZo2JyU/shoyBLG+JU2KUBDiHcZjBeG9DHLWuc1qn3
         UZb8yzOR+DqEmnTHa3k64T8fidqFTwGYOV/gf2vqqrao3mxjEF2UcpdF/5LHaxsxl8ig
         IuqlCVu2l5GG0GdDppIniMSot2aLdgYTVyKLP36PPUs6OhK3hS1Gbu7Vq9I3S7vql0LV
         w4gtITdZT2hPmuclqKIpLTNq/M7664TOALeIl9qubWgeO4Ec9omdVHWLCqFlV+4jvdRl
         qTzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXCXIfsWusFpd2Bsyc56B01iK0ir6ivr+rNSOpZrjoGlB55K3aX2sAAVark96Mf3le9ZUAi2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRYgRWYsNNO7suuJZkYvOboRN7BlkXoYUog60M+5T1MQMe5gQp
	xDtSICvrdLD69dbxG88ZrkS5Mz+GAkVwqPY1qAGs9EPnoI0JMxUSfkiBV4NoMjBByqz2Fhfs0LG
	0M4KxLzHnm70E7MzCV4l76sP7ulgZ91MGpSsN0o2s
X-Gm-Gg: ASbGncuQkZvE9ZUAc9myfNqt94ZIcwqDyTzGuqgirB6nXtM6fhS5MPA5Ff4iPZ4UFNZ
	1PM4m3p7+4LO4VV3A7s6imbrueUhDKeBGO0QaMKSVTHtN1trstTP7Nan0mYLq7FA4W6aBAguCi3
	Odf3gJYBuDkqtHg4tLnhN5wiu3ufyRM8GTyo6QDqVotrLMfSKkLXuSpIxZp9cIy5cV8LB0PlaM1
	YpsnIY=
X-Google-Smtp-Source: AGHT+IHZIX9RI0TnyvMf+ARf3WYRNyQhLo11e35YR15synL7j0UDgLvWSoCAnl1yZlle4Zkk5jSk1V0g6QRxltnOhdE=
X-Received: by 2002:ac8:7fc6:0:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4ab544362a6mr4595061cf.3.1752479023731; Mon, 14 Jul 2025
 00:43:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com> <20250709105946.4009897-17-tabba@google.com>
 <865xfyadjv.wl-maz@kernel.org>
In-Reply-To: <865xfyadjv.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Jul 2025 08:42:00 +0100
X-Gm-Features: Ac12FXyjoYpzT_P-oaUrzRgkOcTbxS1Ta0rucFG3EteXkZMxtRhRlP_YmBV37o0
Message-ID: <CA+EHjTyJGWJ0Pj-jPjriFjy3JHpVUa0PW0vQz4o8UPdLbMV7pg@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,


On Fri, 11 Jul 2025 at 17:38, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 09 Jul 2025 11:59:42 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Add arm64 architecture support for handling guest page faults on memory
> > slots backed by guest_memfd.
> >
> > This change introduces a new function, gmem_abort(), which encapsulates
> > the fault handling logic specific to guest_memfd-backed memory. The
> > kvm_handle_guest_abort() entry point is updated to dispatch to
> > gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> > determined by kvm_slot_has_gmem()).
> >
> > Until guest_memfd gains support for huge pages, the fault granule for
> > these memory regions is restricted to PAGE_SIZE.
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 79 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 58662e0ef13e..71f8b53683e7 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >       *prot |= kvm_encode_nested_level(nested);
> >  }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                   struct kvm_s2_trans *nested,
> > +                   struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +     bool write_fault, exec_fault, writable;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +     struct page *page;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     void *memcache;
> > +     kvm_pfn_t pfn;
> > +     gfn_t gfn;
> > +     int ret;
> > +
> > +     ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (nested)
> > +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +     else
> > +             gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +     write_fault = kvm_is_write_fault(vcpu);
> > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +     if (write_fault && exec_fault) {
> > +             kvm_err("Simultaneous write and execution fault\n");
> > +             return -EFAULT;
> > +     }
>
> I don't think we need to cargo-cult this stuff. This cannot happen
> architecturally (data and instruction aborts are two different
> exceptions, so you can't have both at the same time), and is only
> there because we were young and foolish when we wrote this crap.
>
> Now that we (the royal We) are only foolish, we can save a few bits by
> dropping it. Or turn it into a VM_BUG_ON() if you really want to keep
> it.

Will do, but if you agree, I'll go with a VM_WARN_ON_ONCE() since
VM_BUG_ON is going away [1][2]

[1] https://lore.kernel.org/all/b247be59-c76e-4eb8-8a6a-f0129e330b11@redhat.com/
[2] https://lore.kernel.org/all/20250604140544.688711-1-david@redhat.com/T/#u


> > +
> > +     if (is_perm && !write_fault && !exec_fault) {
> > +             kvm_err("Unexpected L2 read permission error\n");
> > +             return -EFAULT;
> > +     }
>
> Again, this is copying something that was always a bit crap:
>
> - it's not an "error", it's a permission fault
> - it's not "L2", it's "stage-2"
>
> But this should equally be turned into an assertion, ideally in a
> single spot. See below for the usual untested hack.

Will do, but like above, with VM_WARN_ON_ONCE() if you agree.

Thanks!
/fuad

> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b92ce4d9b4e01..c79dc8fd45d5a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1540,16 +1540,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>
>         write_fault = kvm_is_write_fault(vcpu);
>         exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> -
> -       if (write_fault && exec_fault) {
> -               kvm_err("Simultaneous write and execution fault\n");
> -               return -EFAULT;
> -       }
> -
> -       if (is_perm && !write_fault && !exec_fault) {
> -               kvm_err("Unexpected L2 read permission error\n");
> -               return -EFAULT;
> -       }
> +       VM_BUG_ON(write_fault && exec_fault);
>
>         ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
>         if (ret) {
> @@ -1616,11 +1607,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>         VM_BUG_ON(write_fault && exec_fault);
>
> -       if (fault_is_perm && !write_fault && !exec_fault) {
> -               kvm_err("Unexpected L2 read permission error\n");
> -               return -EFAULT;
> -       }
> -
>         /*
>          * Permission faults just need to update the existing leaf entry,
>          * and so normally don't require allocations from the memcache. The
> @@ -2035,6 +2021,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
>
> +       VM_BUG_ON(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +                 !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> +
>         if (kvm_slot_has_gmem(memslot))
>                 ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
>                                  esr_fsc_is_permission_fault(esr));
>
> --
> Without deviation from the norm, progress is not possible.
