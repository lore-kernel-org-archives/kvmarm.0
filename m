Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E51B41F359
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 08:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633523; cv=none; b=cfK5qhg8Inov/Ls7EFZFoS41GqugzhXrujr7yKJOVt1ZgECuYsh8+IPNivq8hOdAoxEL8uWehEnbfXRdaFLWKuZOwE2ib3x4lW7cQPOu3sTvRDIAhalqyRZ/Ka0XH16+hx607u5Ce6SN43w0XIwFNPnCyR7HDwiUgr4cpngGuh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633523; c=relaxed/simple;
	bh=35hqnEQTx0tBDmeegi18g3vXNhGhUb6uyDPINysVZzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArmcVI//v5x0AkxY33771mY5Y20gfRHd8rj4RXvvJEa2GYYojFtPCBh/2WGgXLQytghzHmIxtlxJF3BXx5JHia8xJMmZo/PB4nSZBOh/dorstp8J0BdFx93Y/+wMpjHRTTaiJdNbpvAAwL9QgrHgxnnKZnHBjrGfVPQ4L03ig2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bQFjLw0h; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bQFjLw0h"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b91369d18so4044605e9.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 01:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789633516; x=1790238316; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WwuqijA5uNlk2wAlQ6PUNXgJqRDsKikQxqT1KiBmnQg=;
        b=bQFjLw0hxChAkbFlLN8LXZ1k/wO7sgP6CnIWYgz1LDc7M1pvY6PCPwoJXX5d95+50b
         sjGIrAHDyoyIw7kH8rFD+fgo5eB/QetMFYISnGbP/u9bkyhlPG9j6MFZPhWGRqFN6mLG
         54T53Wo0VcT0pwqQg9rd++zUa9ZqgFnbuKrQp32/WhWqhBePs1eQVCs7LNtW4oKZBRFm
         T6+fqcaI++/BZDFQjuCOAoMq4qMp0k+tNCk3Hj+qscA6oKWWiFq1xc2uiTEgmB/A//QZ
         yHXYubMCv/J99eovvNhBdFbMK/pXPMU16M8CBrV1MlhivjAEBHkqk2hcnx4aTyxIG6Y0
         CQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633516; x=1790238316;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WwuqijA5uNlk2wAlQ6PUNXgJqRDsKikQxqT1KiBmnQg=;
        b=0rFblaoooPuLwtYnzmgQNZ5vwPP3BEwuZijXFngRBAYdoo8GdrLw6zDCfzwp6CsyZn
         JEVhBNLePfR1fPkpkaVhZff9iAhkBnJrGZ8GN5ooZ0py2gk3tFZYPlzWEyRjuiWdICA7
         VY/Rsc4PHZG/o1Tchxs7ml7/9x8QgdUPojVNxBR1RNtvLMj5WYc9zlyY9/34Eig59xGt
         nDIN6pvw18B6bLGxzXxXfNEnreKY6w1WsQWi5eBRWtTij92I2TyoGtOP/rzDJ4rXneEn
         Hz9NOuR1TqX3ohPTRpzpxoZaLH6ufgNg4Td01grDIdq8rKOiuFcZAfKQfFYtI3E3dn4Y
         24Qg==
X-Forwarded-Encrypted: i=1; AKwUvBx2d4nHXSqeYoOJtCQsjmVtTQLHNz56jViIMyD9YihCKLIyxynKs15Xa0HcSiEpUd1lEiqdHOE=@lists.linux.dev
X-Gm-Message-State: AFuF++nfWg3Er5kTrkirGqDkLVGEYFG9sPBcg0UoahKKNoEpmlsrRSQk
	ldOM4vge7U8IzQdOixc5DBG9CLnS4ComwDCyeeOO4q9mORYG4OperVrp7EWFEc59oA==
X-Gm-Gg: AYBFou1opqsnEU76DEuPNXuZqDlHOIMEN8DhIfyHGR9uUnQIvkeyXPqA/RVkB21hZ40
	aUGYPXPLQNBt/53CTrfr2aqP35redBzsOvRYxbb1KDWDaHLYF9hNpEVX5hi2G/LJpcuBuKKDM1m
	RRcuR8irq/lr12La8tUNMeUblc1eJ4hZdOHp6SxTberyeDDWlO/8QFN+yrHaJ23zbqvF1cDPMxx
	LE7gBt9/kVXS5yXn/u7l5fbVzr6Bo013scp+iXuelABAhl6hIu8MmP01O9BeIyqJh8481ICldaR
	QBP3gHB5pl6V0ddX+i6zma0akiQScFUhfqpa23UNBmwGFiLHMvnfy07QEhrlUUETxbnXHRObfN3
	/kOmbsfS3dP8D3Czguhv58rScKeQJdXLjHxx4HE0eZipunA5JbiMH7kVh/VvHq09i/HxrzG7Gkt
	BftuGdLDyW3fCgfrLY0Jx8NHHL7XrOIMEWL1EMQ8FQt6Je71/5gE1tfVhpqqygUfaCseDiAaSUr
	zS8r57QvRPbdMgJaiC+AH9S3D++czOHCd8V3lUfqdM=
X-Received: by 2002:a05:600c:4691:b0:49c:fc6e:a3da with SMTP id 5b1f17b1804b1-49eb733cb1amr69230185e9.25.1789633515867;
        Thu, 17 Sep 2026 01:25:15 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbda77d6fsm39883065e9.0.2026.09.17.01.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:25:15 -0700 (PDT)
Date: Thu, 17 Sep 2026 09:25:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v3] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
Message-ID: <aquj55DPnqs-AUwM@google.com>
References: <20260915091606.2111217-1-vdonnefort@google.com>
 <CA+EHjTz_c5BS3XgFuv61AtwgxD7WWELwuWZ3crd7_7RMvGA2Gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz_c5BS3XgFuv61AtwgxD7WWELwuWZ3crd7_7RMvGA2Gw@mail.gmail.com>

On Tue, Sep 15, 2026 at 12:17:21PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Tue, 15 Sept 2026 at 10:16, 'Vincent Donnefort' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
> > of pages larger than 4kB") fixed the boot of non-protected VMs on system
> > larger than 4K pages, align the fault IPA down to the page-size for
> > protected VMs.
> >
> > To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
> > as a parameter is aligned to the size of the intended mapping, while
> > HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
> > system page size configuration.
> >
> > Add a check at the start of pkvm_pgtable_stage2_map() as we do not
> > support !PAGE_ALIGNED arguments and ensure callers pass a page-aligned
> > IPA.
> 
> The fix is correct, and I can reproduce the bug. On a 16K-page host an
> unpatched v7.3-rc2 never gets a pVM to a prompt: no guest console
> output at all, a core pegged at 100% when I sampled it a minute in,
> killed at the 120s timeout. A guest_memfd-backed non-protected VM
> times out the same way, while one without guest_memfd boots fine,
> which puts the failure on the two paths you fix. With the patch all
> three boot clean, and 4K still boots both. That is QEMU with kvmtool
> guests; the same three 16K legs also pass on an M4 running pKVM at EL2
> on the silicon.
> 
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> > Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
> 
> A second Fixes: for the gmem_abort() half? a7b57e099592 ("KVM: arm64:
> Handle guest_memfd-backed guest page faults") added that call site,
> and the ranges differ: ea03466e806f is in v7.1, a7b57e099592 in v6.18.
> 
> Should this carry Cc: stable@vger.kernel.org? 08f97454b7fa, the fix
> this one follows, did, and 16K-page hosts are a shipping Android
> configuration.
> 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c  | 12 +++++++-----
> >  arch/arm64/kvm/pkvm.c |  3 +++
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> >
> > Changelog:
> >
> > v3:
> >   - Fix nested case in gmem_abort() (Sashiko)
> >
> > v2: https://lore.kernel.org/all/20260914075839.4019904-1-vdonnefort@google.com/
> >
> >   - Use gfn_to_gpa(gfn)
> >   - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
> >   - Fix gmem_abort() as well (Sashiko)
> >
> > v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9ba86450fe4a..e199dd339583 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1610,6 +1610,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >         bool write_fault, exec_fault;
> >         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> >         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> > +       phys_addr_t ipa = ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE);
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
> >         unsigned long mmu_seq;
> 
> One more in gmem_abort(): the memory fault exit at mmu.c:1647 still
> reports the unaligned address, and that one is userspace-visible.
> 
>     kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>          write_fault, exec_fault, false);
> 
> api.rst defines the range as [gpa, gpa + size), so on a 16K host it
> starts mid-page. gfn_to_gpa(gfn) is the one to use: gfn is what
> kvm_gmem_get_pfn() failed on, and the L1 IPA in the nested case. x86
> passes fault->gfn << PAGE_SHIFT.
> 
> > @@ -1672,12 +1673,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >                  * PTE, which will be preserved.
> >                  */
> >                 prot &= ~KVM_NV_GUEST_MAP_SZ;
> > -               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> > +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, ipa,
> >                                                                  prot, flags);
> >         } else {
> > -               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > -                                                        __pfn_to_phys(pfn), prot,
> > -                                                        memcache, flags);
> > +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, ipa, PAGE_SIZE,
> > +                                                        __pfn_to_phys(pfn),
> > +                                                        prot, memcache, flags);
> >         }
> >
> >  out_unlock:
> > @@ -1710,6 +1711,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >         unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> >         struct kvm_vcpu *vcpu = s2fd->vcpu;
> >         struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +       gfn_t gfn = gpa_to_gfn(s2fd->fault_ipa);
> >         struct mm_struct *mm = current->mm;
> >         struct kvm *kvm = vcpu->kvm;
> >         void *hyp_memcache;
> > @@ -1756,7 +1758,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >         }
> >
> >         write_lock(&kvm->mmu_lock);
> > -       ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > +       ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
> >                                       page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> >                                       hyp_memcache, 0);
> >         write_unlock(&kvm->mmu_lock);
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 8e4c6e4bec12..b7340c430ed6 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >         u64 end = addr + size;
> >         int ret;
> >
> > +       if (!PAGE_ALIGNED(addr | size))
> > +               return -EINVAL;
> > +
> 
> Could this be if (WARN_ON_ONCE(!PAGE_ALIGNED(addr | size)))? The three
> checks just below WARN on the same class of caller bug, and this one
> runs first, so a bad size now returns -EINVAL with no splat.
> 
> With the memory fault exit fixed:
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad

Thanks Fuad,

I'll modify that. Although in the new respin I will also add support for
kvm_s2_fault_vma_info(), which should naturally fix that issue, just like Marc
suggested [1]


[1] https://lore.kernel.org/all/864ifs6xn4.wl-maz@kernel.org/

-- 
Vincent

> 
> >         lockdep_assert_held_write(&kvm->mmu_lock);
> >         mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
> >
> >
> > base-commit: df2908090cda368b01ff43709f51890076c56157
> > --
> > 2.55.0.1032.g73a4cd73de-goog
> >
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
