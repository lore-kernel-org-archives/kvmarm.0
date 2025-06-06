Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FAC3234
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 07:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749195151; cv=none; b=iU5a0LV7/sdSQz8A5Skt7FocmGEXJKSl/QalnuBPVC9bGJbwNumGGNGGUriyAbwZtIpsJ9+PxWuSlaQsgwr4tjIPaKsuF2QV2NHxe+WglNgrJrZVkPlKHwVWqCp4EBCmZezbDEomv/l79tUI7gk4dD6mMIf4/PIj8byPb/mRKaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749195151; c=relaxed/simple;
	bh=OU19RnKagnqkf8XnYXLJNZp/nY3+adAcR/V1vK/aJwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s/OcUKS+AkMH4OJXwW4mOUGnfRUG5ZYr9RZE/JjIaymHcQNOogvL3ERm5emhYENrDMbKDM7EHIxYHT6MCmR+aG6Cqbcewc5HOBfMmze4SWnsOotbdktfRp1X59gfqblciWTFHcxkDgOva6R2ERIvml5rY25ChpQL/gLhUj2W+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+hP/iTA; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+hP/iTA"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47e9fea29easo250851cf.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749195148; x=1749799948; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7kvMY5ZW2Vp5tdjNn8It/0HBAvvjd3PqQU3fhP/KrU=;
        b=x+hP/iTA37biRy7WeKqXIGjflCQLaYAzjglV/HTQB7Wy7Ls4Ea7d668hIiGPNm4vet
         icdKbWNzK1FISAMCzXevRhrTDwYxa46Xn8quMLX5ssgJ2VgRZyNspNOE5tg2qoZbF3/E
         ITfwoxnk1okHJoSc1Vh/GU9hqzMN5txnTVcCASJVDKk2b6VjxrGN3uT5N562+P71z9Yq
         KcKbad2ZOh0PBd0VK7L9SQKQmC1uk8vt1TsmM+I/yrKy7oZGrTxzo55escwmBr0mK37K
         Ei0tdSRw8HZZK2Z/XDJX8C9BDETnS+bpIpONtnrTAMXbEfOjb/V+6rONxomK7DNVWovs
         4hBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749195148; x=1749799948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7kvMY5ZW2Vp5tdjNn8It/0HBAvvjd3PqQU3fhP/KrU=;
        b=Z8XodlXwLdFXee2VywBHm/N4nE6cd2Juar6Brad+Jg1TaeMkcMyEuhQZL2M4D4gaxE
         jJn0+g4fWFIQW8uTlf4Q08lIJtbLyIqh1q1Cg6F7bKu2W9Zq7ODgEpxtuOkLNObUj7Q1
         pf52Q6DlZjuNrFPV9R0Rf6NVp31VbU86AMqEYlGtbT9+8Awf3SFNT8Fz3l3j+6+S9a+P
         HYOSNSkRbq0K/9CwpMXzadFw9twvDjK1Sy6jxHVpDBxZp/zFywHEoGAt5OMO73NjUfIt
         p8gRY1FuW0pMgFb9b2qF2ei+SjToavRolyxLtzrCGkzCDndev2wWqvt5xwkyVZ8bj1Ey
         ZAoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA4PBVFABKpaMT+X3i5HiBWlh7OEOi14x/t0KCykzrKSZDRKUm5wh4vtkkfcJLbHdbsF/SBCQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoO+u52ZUUbcmWbu6Cn5bxEqU8IwNDi6UN8/tfnNmwZmMmCE1w
	O3bnwzwTHBbqerBpWjftcyPwMERFa3AJoVISBlp6ksQP9zVXfuedR6B7fIAyBzj+plwPHipEoV5
	hkfe8bw6kVDRjArR6XoAqnfbtL9yFUn+JloedE1CX
X-Gm-Gg: ASbGncv+nDYDGyaCgfzUMyctfH3PxNeq2qSIO6ztjao7dUl4yMzYdIqcMBHsTtmwjdl
	epQKBsBsuuBxWN7DeCn+pFeDYCRHt+WZOYARdYR7Glek3DZfynpDu3pVoTnUWa2DLmGdbvNlin0
	I6e1dk92TVk2UbZsnep4gbvX160eErlXvisQhjZz+CeiI=
X-Google-Smtp-Source: AGHT+IERI6/rZZc+T/Y/BCqimMsrHrMBugbnphXsLYAS4v8oVORX4EwdR5wAo6IhPMIeThscJU2dXoYklEdFCyQufTc=
X-Received: by 2002:a05:622a:2517:b0:480:dde:aa4c with SMTP id
 d75a77b69052e-4a5baa657e2mr2990431cf.4.1749195147273; Fri, 06 Jun 2025
 00:32:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-15-tabba@google.com>
 <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
In-Reply-To: <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 08:31:50 +0100
X-Gm-Features: AX0GCFt0ub1lyERvNyPbCD_BOwFtXCNX4pHBzmnsUAgp6hMKn_u9cHKW_CPEy3g
Message-ID: <CA+EHjTx-RKrn5Bwi9daTx-VAHLLxPpjo+wYMhi9MysWtvsM97w@mail.gmail.com>
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: James Houghton <jthoughton@google.com>
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
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 5 Jun 2025 at 18:21, James Houghton <jthoughton@google.com> wrote:
>
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> >
> > Add arm64 support for handling guest page faults on guest_memfd backed
> > memslots. Until guest_memfd supports huge pages, the fault granule is
> > restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Hi Fuad, sorry for not getting back to you on v10. I like this patch
> much better than the v9 version, thank you! Some small notes below.
>
> > ---
> >  arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 90 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index ce80be116a30..f14925fe6144 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm=
_s2_trans *nested,
> >         *prot |=3D kvm_encode_nested_level(nested);
> >  }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT=
 | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                     struct kvm_s2_trans *nested,
> > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +       bool logging, write_fault, exec_fault, writable;
> > +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT=
_FLAGS;
> > +       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> > +       struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> > +       struct page *page;
> > +       struct kvm *kvm =3D vcpu->kvm;
> > +       void *memcache;
> > +       kvm_pfn_t pfn;
> > +       gfn_t gfn;
> > +       int ret;
> > +
> > +       ret =3D prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (nested)
> > +               gfn =3D kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +       else
> > +               gfn =3D fault_ipa >> PAGE_SHIFT;
> > +
> > +       logging =3D memslot_is_logging(memslot);
>
> AFAICT, `logging` will always be `false` for now, so we can simplify
> this function quite a bit. And IMHO, it *should* be simplified, as it
> cannot be tested.

Ack.

> > +       write_fault =3D kvm_is_write_fault(vcpu);
> > +       exec_fault =3D kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +       if (write_fault && exec_fault) {
> > +               kvm_err("Simultaneous write and execution fault\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       if (is_perm && !write_fault && !exec_fault) {
> > +               kvm_err("Unexpected L2 read permission error\n");
> > +               return -EFAULT;
> > +       }
>
> I think, ideally, these above checks should be put into a separate
> function and shared with user_mem_abort(). (The VM_BUG_ON(write_fault
> && exec_fault) that user_mem_abort() does seems fine to me, I don't see a
> real need to change it to -EFAULT.)

I would like to do that, however, I didn't want to change
user_mem_abort(), and regarding the VM_BUG_ON, see David's feedback to
V10:

https://lore.kernel.org/all/ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com=
/



> > +
> > +       ret =3D kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +       if (ret) {
> > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZ=
E,
> > +                                             write_fault, exec_fault, =
false);
> > +               return ret;
> > +       }
> > +
> > +       writable =3D !(memslot->flags & KVM_MEM_READONLY) &&
> > +                  (!logging || write_fault);
> > +
> > +       if (nested)
> > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +       if (writable)
> > +               prot |=3D KVM_PGTABLE_PROT_W;
> > +
> > +       if (exec_fault ||
> > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +            (!nested || kvm_s2_trans_executable(nested))))
> > +               prot |=3D KVM_PGTABLE_PROT_X;
> > +
> > +       kvm_fault_lock(kvm);
> > +       if (is_perm) {
> > +               /*
> > +                * Drop the SW bits in favour of those stored in the
> > +                * PTE, which will be preserved.
> > +                */
> > +               prot &=3D ~KVM_NV_GUEST_MAP_SZ;
> > +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt,=
 fault_ipa, prot, flags);
>
> I think you should drop this `is_perm` path, as it is an optimization
> for dirty logging, which we don't currently do. :)
>
> When we want to add dirty logging support, we probably ought to move
> this mapping code (the lines kvm_fault_lock() and kvm_fault_unlock())
> into its own function and share it with user_mem_abort().

Ack.

> > +       } else {
> > +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_i=
pa, PAGE_SIZE,
> > +                                            __pfn_to_phys(pfn), prot,
> > +                                            memcache, flags);
> > +       }
> > +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +       kvm_fault_unlock(kvm);
> > +
> > +       if (writable && !ret)
> > +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +       return ret !=3D -EAGAIN ? ret : 0;
> > +}
> > +
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa=
,
> >                           struct kvm_s2_trans *nested,
> >                           struct kvm_memory_slot *memslot, unsigned lon=
g hva,
> > @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt;
> >         struct page *page;
> > -       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_HANDLE_F=
AULT | KVM_PGTABLE_WALK_SHARED;
> > +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT=
_FLAGS;
> >
> >         if (fault_is_perm)
> >                 fault_granule =3D kvm_vcpu_trap_get_perm_fault_granule(=
vcpu);
> > @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu=
)
> >                 goto out_unlock;
> >         }
> >
> > -       ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > -                            esr_fsc_is_permission_fault(esr));
> > +       if (kvm_slot_has_gmem(memslot))
> > +               ret =3D gmem_abort(vcpu, fault_ipa, nested, memslot,
> > +                                esr_fsc_is_permission_fault(esr));
> > +       else
> > +               ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot=
, hva,
> > +                                    esr_fsc_is_permission_fault(esr));
>
> I like this split! Thank you!

Thank you for your reviews!

Cheers,
/fuad

>
> >         if (ret =3D=3D 0)
> >                 ret =3D 1;
> >  out:
> > --
> > 2.49.0.1266.g31b7d2e469-goog
> >
