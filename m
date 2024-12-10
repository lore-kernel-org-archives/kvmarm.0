Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9771622FDF6
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733845901; cv=none; b=twKAyDnn4Yuj30eAIyqyWrNlkgfxeFehAG92Pb/+gd0GPiRyDtuV2BxWZ0peziGawbO7p7z0wOPg/wI87kdEPKydoJc5qXecAejulve1sN/56Qp02MwHqKDB9QN8oDZfVZtBN0NJ5eZ4rmZvYdrZWO0hQ0in9cbuEr6lo1jyiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733845901; c=relaxed/simple;
	bh=amxCp0EMopBa0Wj63+gMPBfKt4QhOLvi+csF+moVuAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AR24AC2spcGaWZkzUnCt/tWCcNoEZCzs4+nibqv5NY3cA5rUw8Hg12dWbkyNJ+jVskd/eRxvXJy0QmwAljcWn9Hje15JMkReINob0LqHp27YZQRqOk1iPaW2SQ7kgwPDdVz8QQjkbwWMFufTPBwuhXidGWnchw3RDx3S6AeSl3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2A9YHQJx; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2A9YHQJx"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so47035e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733845898; x=1734450698; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/5ZtRjw8dpmQ1elEprrvLW2MOsxcGpgWmlHcpBGqqms=;
        b=2A9YHQJxYGqvDvRCVrYzRUu1cZuO9pYzqy0n5du4xOHPXEVzL3JdxE7WC9q4YWlDEj
         zXoNaC3b3bATaU5L/ggHBkHv3jX3TkxoUsWz0K8E/SbXyjjElXq9uVemjyIE1HHzKNRm
         SMRZDgkWkoLkgNJO4rPyzNdx34ecMbviXu6+7Z2J2JkZJmuivx9h8IF33HPWqx2gVdUD
         9kSOtgI39tH0PYAzM9Ep7oQhsUm4eANwu/RMfCQilsZscOR6RmKKwdlTMA6uV2HITMnT
         J7oVYLtCuBWL6kod+LASBsY7JQM3wctNDb8Vgo+SzO+g37MiGtnyfsp/9UK+ZnUNLz29
         daVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733845898; x=1734450698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5ZtRjw8dpmQ1elEprrvLW2MOsxcGpgWmlHcpBGqqms=;
        b=hmakQdGgCK1RPn6CmfsX3O2pK8MDy6G8mqDSdus8an5euzMnBOEiyF9qEMYItS7gqg
         fV8dAkvSSrEFOW0Sm5IMLycVCKS+erhdJpDSLfK4OThD6h2Ek3+jOY7ZdUhu2xO65u6h
         k0NGIOnwtehHQhbzKILdzLoIWO+Gx6zJ3VhR+sUcPXo9qluyD6dxfXACgsxSvNsj+TwE
         U467M/L+8dNiokIdKXdB0UvPtSdqXDCr0ah1oe3yLGqLchSWnA6ddnjZkzpKL9pw+3ic
         cOSCGkUFkLqFgBBoHZAzIY50q+MJydtk15DSkkHteC/K0lOtVEQBtLH2mpSstlSR+DBT
         Hfrg==
X-Forwarded-Encrypted: i=1; AJvYcCXgW8LVJFYISTnZlMieLo1yCaVFJtWTcGoBRRrQh23h7hyQSB2pTQP7qra3mSm6tz/GcWO1X4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJf9ji7xcpBJsvPOFkzrb93/VfwyIfh7ktGX/IuDZVsrWI4zPp
	abZ0lr//HvzOQ5/V+r4tjqdIoLr9kqC4J8UktOHBHoP/uEw0MMkKz+TVJ+vBRFTVEC6aM2e5bRu
	bdw4m08tHKgC0NrtjFGaever+0lH57BJkj4w7
X-Gm-Gg: ASbGnctBswIwhsk6rrmMj3B2RXV33aSmzOhbb6sAKH1hW0ruzb2lz19OtSmc7lekjiS
	KEKyGIaYAkz1qpoAUglWYSV6wWlQaydmZ161FwxgngIpvwvFuJVtH4h61gdMX7H4=
X-Google-Smtp-Source: AGHT+IG6nRSYR4cad9Jq/EKiLYzlmi/rBd9oike3yrjEW/0ELMD7DAWluxCMhksYS3Mn1ekR//nxyidNJvgQjdhF6ww=
X-Received: by 2002:a05:600c:12c3:b0:434:9d0b:bd7c with SMTP id
 5b1f17b1804b1-43539dcf4a4mr1249075e9.3.1733845897727; Tue, 10 Dec 2024
 07:51:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com> <Z1hhHRdpCZcLs046@google.com>
In-Reply-To: <Z1hhHRdpCZcLs046@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:51:01 +0000
Message-ID: <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
Subject: Re: [PATCH v2 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 10 Dec 2024 at 13:58:42 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Tue, 3 Dec 2024 at 10:37, Quentin Perret <qperret@google.com> wrote:
> > >
> > > In preparation for handling guest stage-2 mappings at EL2, introduce a
> > > new pKVM hypercall allowing to share pages with non-protected guests.
> > >
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h              |  1 +
> > >  arch/arm64/include/asm/kvm_host.h             |  3 +
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
> > >  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  2 +
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 34 +++++++++
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 70 +++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  7 ++
> > >  7 files changed, 118 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 89c0fac69551..449337f5b2a3 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -65,6 +65,7 @@ enum __kvm_host_smccc_func {
> > >         /* Hypercalls available after pKVM finalisation */
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> > > +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index e18e9244d17a..f75988e3515b 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -771,6 +771,9 @@ struct kvm_vcpu_arch {
> > >         /* Cache some mmu pages needed inside spinlock regions */
> > >         struct kvm_mmu_memory_cache mmu_page_cache;
> > >
> > > +       /* Pages to be donated to pkvm/EL2 if it runs out */
> >
> > Runs out of what? :) I'm being facetious, it's just that the comment
> > is a bit unclear.
>
>         /* Pages to top-up the pKVM/EL2 guest pool */
>
> Is that any better?
>
> > > +       struct kvm_hyp_memcache pkvm_memcache;
> > > +
> > >         /* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> > >         u64 vsesr_el2;
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index 25038ac705d8..a7976e50f556 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -39,6 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > > +int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
> > >
> > >  bool addr_is_memory(phys_addr_t phys);
> > >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > index 08f3a0416d4c..457318215155 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > @@ -47,6 +47,8 @@ struct hyp_page {
> > >
> > >         /* Host (non-meta) state. Guarded by the host stage-2 lock. */
> > >         enum pkvm_page_state host_state : 8;
> > > +
> > > +       u32 host_share_guest_count;
> > >  };
> > >
> > >  extern u64 __hyp_vmemmap;
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index 95d78db315b3..d659462fbf5d 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -211,6 +211,39 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> > >         cpu_reg(host_ctxt, 1) =  ret;
> > >  }
> > >
> > > +static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +       struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > > +
> > > +       return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
> > > +                              host_vcpu->arch.pkvm_memcache.nr_pages,
> > > +                              &host_vcpu->arch.pkvm_memcache);
> > > +}
> > > +
> > > +static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +       DECLARE_REG(u64, pfn, host_ctxt, 1);
> > > +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> > > +       DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
> > > +       struct pkvm_hyp_vcpu *hyp_vcpu;
> > > +       int ret = -EINVAL;
> > > +
> > > +       if (!is_protected_kvm_enabled())
> > > +               goto out;
> > > +
> > > +       hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > > +       if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > > +               goto out;
> > > +
> > > +       ret = pkvm_refill_memcache(hyp_vcpu);
> > > +       if (ret)
> > > +               goto out;
> > > +
> > > +       ret = __pkvm_host_share_guest(pfn, gfn, hyp_vcpu, prot);
> > > +out:
> > > +       cpu_reg(host_ctxt, 1) =  ret;
> > > +}
> > > +
> > >  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> > >  {
> > >         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> > > @@ -420,6 +453,7 @@ static const hcall_t host_hcall[] = {
> > >
> > >         HANDLE_FUNC(__pkvm_host_share_hyp),
> > >         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> > > +       HANDLE_FUNC(__pkvm_host_share_guest),
> > >         HANDLE_FUNC(__kvm_adjust_pc),
> > >         HANDLE_FUNC(__kvm_vcpu_run),
> > >         HANDLE_FUNC(__kvm_flush_vm_context),
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 1595081c4f6b..a69d7212b64c 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -861,6 +861,27 @@ static int hyp_complete_donation(u64 addr,
> > >         return pkvm_create_mappings_locked(start, end, prot);
> > >  }
> > >
> > > +static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
> > > +{
> > > +       if (!kvm_pte_valid(pte))
> > > +               return PKVM_NOPAGE;
> > > +
> > > +       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> > > +}
> > > +
> > > +static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
> > > +                                         u64 size, enum pkvm_page_state state)
> > > +{
> > > +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > > +       struct check_walk_data d = {
> > > +               .desired        = state,
> > > +               .get_page_state = guest_get_page_state,
> > > +       };
> > > +
> > > +       hyp_assert_lock_held(&vm->lock);
> > > +       return check_page_state_range(&vm->pgt, addr, size, &d);
> > > +}
> > > +
> > >  static int check_share(struct pkvm_mem_share *share)
> > >  {
> > >         const struct pkvm_mem_transition *tx = &share->tx;
> > > @@ -1343,3 +1364,52 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
> > >
> > >         return ret;
> > >  }
> > > +
> > > +int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
> > > +                           enum kvm_pgtable_prot prot)
> > > +{
> > > +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > > +       u64 phys = hyp_pfn_to_phys(pfn);
> > > +       u64 ipa = hyp_pfn_to_phys(gfn);
> > > +       struct hyp_page *page;
> > > +       int ret;
> > > +
> > > +       if (prot & ~KVM_PGTABLE_PROT_RWX)
> > > +               return -EINVAL;
> > > +
> > > +       ret = range_is_allowed_memory(phys, phys + PAGE_SIZE);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       host_lock_component();
> > > +       guest_lock_component(vm);
> > > +
> > > +       ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
> > > +       if (ret)
> > > +               goto unlock;
> > > +
> > > +       page = hyp_phys_to_page(phys);
> > > +       switch (page->host_state) {
> > > +       case PKVM_PAGE_OWNED:
> > > +               WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
> > > +               break;
> > > +       case PKVM_PAGE_SHARED_OWNED:
> > > +               /* Only host to np-guest multi-sharing is tolerated */
> >
> > Initially I thought the comment was related to the warning below,
> > which confused me.
>
> It actually is about the warning below :-)
>
> > Now I think what you're trying to say is that we'll
> > allow the share, and the (unrelated to the comment) warning is to
> > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > count.
>
> So, the only case where the host should ever attempt do use
> __pkvm_host_share_guest() on a page that is already shared is for a page
> already shared *with an np-guest*. The page->host_share_guest_count being
> elevated is the easiest way to check that the page is indeed in that
> state, hence the warning.
>
> If for example the host was trying to share with an np-guest a page that
> is currently shared with the hypervisor, that check would fail. We can
> discuss whether or not we would want to allow it, but for now there is
> strictly no need for it so I went with the restrictive option. We can
> relax that constraint later if need be.
>
> > I think what you should have here, which would work better with the
> > comment, is something like:
> >
> >                 /* Only host to np-guest multi-sharing is tolerated */
> > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > +                       return -EPERM;
> >
> > That would even make the comment unnecessary.
>
> I would prefer not adding this here, handle___pkvm_host_share_guest() in
> hyp-main.c already does that for us.

I understand now, and I agree that an additional check isn't
necessary. Could you clarify the comment though? It's the word "only"
that threw me off, since to me it implied that the check was enforcing
the word "only". Maybe:

>                 /* Tolerate host to np-guest multi-sharing. */


Thanks,
/fuad

> >
> > > +               WARN_ON(!page->host_share_guest_count);
> > > +               break;
> > > +       default:
> > > +               ret = -EPERM;
> > > +               goto unlock;
> > > +       }
> > > +
> > > +       WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> > > +                                      pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
> > > +                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> > > +       page->host_share_guest_count++;
> > > +
> > > +unlock:
> > > +       guest_unlock_component(vm);
> > > +       host_unlock_component();
> > > +
> > > +       return ret;
> > > +}
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > index d5c23449a64c..d6c61a5e7b6e 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -795,6 +795,13 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
> > >         /* Push the metadata pages to the teardown memcache */
> > >         for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
> > >                 struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
> > > +               struct kvm_hyp_memcache *vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
> > > +
> > > +               while (vcpu_mc->nr_pages) {
> > > +                       void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
> >
> > nit: newline
> >
> > Cheers,
> > /fuad
> >
> >
> >
> > > +                       push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> > > +                       unmap_donated_memory_noclear(addr, PAGE_SIZE);
> > > +               }
> > >
> > >                 teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> > >         }
> > > --
> > > 2.47.0.338.g60cca15819-goog
> > >
