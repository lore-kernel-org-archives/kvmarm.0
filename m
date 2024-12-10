Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB38319C546
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733846319; cv=none; b=RxVpEA+MJdH+2PUyIiWsBjNC506x3+fdiXojZmn5O+T70Ps7kv69zhPJoQ0qX2E0lqYcq8cdi/r7L6pMK7HBSAa5qgSSQ6m8VT9DtUii9zDY46UiKbZYmHAwUx1PRQmHPKZVWN6U4VZw3OEKLpNmvMNKFcmdjOWxX2DzUvx+QVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733846319; c=relaxed/simple;
	bh=atrWVkB9CFuZWZrKela5abtLnqz5FGFSiAK4ZHTzOFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwinkTXrGUWGkfE6ysoFa/cMrrmu61gdBtg7gVvVsB4x/J7LgVR0xi/Cs14M7tMhcMr4vbzJ//pMs/jNFoBMSrM0oOWUn4rA/CiPkq5/zoekvyw6qWWkyGbI5TgEl404zxX9FNrwLS/81zcfgZfK8hcCLPwRYtKAMwTUyPtXOkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WetLbRq6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WetLbRq6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434e5e71a08so47965e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733846316; x=1734451116; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gog3UmjAGM8ds1F2V/1cTPHpF/LSt2pJ8Fb+2K5pOrQ=;
        b=WetLbRq65Grcga5qT+kJySHNM7w9KUjAxerV3LmGZF2HO3XiumTHv7PFPMBl66DUHQ
         y++Qnn80rehkpyVOk48tVh56oTm8yT7Rzs5LKot78o3zOW0g3d5qQq+3AaNRDjjzMdL+
         VCN9uYc+A/1Pf8eot0DAElvJoGeilsIZ7bnEaWoJnPlaVMVbwKs9nMeIobmwGYlYGlL4
         PneqortHAYFWsMRlb8T4TzG3ZcsFuwWLDREcY2GiToO00uiteKT2mYFMmOXwtlouOeCV
         JIz/igETXyeWVFedvTVVGyDiivQ8t8OjjrOpyATjsnlZKg2Jt5kCHb8DzBJAInpQ3aeV
         9xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733846316; x=1734451116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gog3UmjAGM8ds1F2V/1cTPHpF/LSt2pJ8Fb+2K5pOrQ=;
        b=a9ZYZEL0EkINn4XxOIRV8eZGa8qd+vRjxfr+oa9qpe980UTbRAC8TdJom1WJdQ5W5D
         0e6rUyAGsXdYj7++2LmjOIxasoJZXQ6khLigCKiQ/bHBWhS6d3frQTDAN4NDKAaJWVJv
         4BOfdfxCKLj+Y9Fb2BpLeovgGBaOh004hCqJdSusy2ifXhoF7ehH/NENe7FA/a2SQ+3w
         /9oU3lixrV6/SpPcc9QWeunE8kOT9MDtV1QJxxbSVUrD+aYaRoZ3+VNCJdW/X+oB+ym5
         cur0oJtpFAau3eDU2De7/csKH1SOPJm9S23JZhdJraO9ysJMHhnA9Ps1+lT5qar6CuyC
         JLKA==
X-Forwarded-Encrypted: i=1; AJvYcCW4zRH/i3c+I3bJcQmF/DO/pWOWMG34z2qgggt8Wy+mRck4BDxsS9BiSF4lw4DX0FNCtvaIfCY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz51f1mFevfcUJ29Ghg8A4oSBzPP0BbJIDHayqjz0s+7unOToJg
	jTKYBc5zS7DarJ8pox928MXPvQVp65waoJdfJQSqU/t3q7a7tGCe/tkXbaRl3Lhaq77WcuepRR5
	S7fhQMQJGPoN2mpeIDlsabkoUjQ2UPXC07OsK
X-Gm-Gg: ASbGncshUM2BG1OyZmBajQrY1UIIeDQF9OXgKE77xxOo9dVSlYf19ezXs5YvaYZ70Sx
	NjXTS76hlWHyDUhcC4LaZ0kQec8Oa5apwNxI4wMIQoYQNY34sDMZ13jaTaxu3jRU=
X-Google-Smtp-Source: AGHT+IG1wUJvyZIRJh+38xWa/njtBgPsxPwQ2fBa2yZ2tXxaoHhgOC8RH8xcoYG60iakVpmgn1JWxhQdZW1hCXmryOM=
X-Received: by 2002:a05:600c:4312:b0:434:c967:e4b5 with SMTP id
 5b1f17b1804b1-43539dcfd43mr1228115e9.1.1733846316052; Tue, 10 Dec 2024
 07:58:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-12-qperret@google.com>
 <CA+EHjTw48LTFt=sKtPwS1rmA=ma6Sj9O-D=17FXoMybqZ7+g5g@mail.gmail.com> <Z1hj49tuma2zZ1zv@google.com>
In-Reply-To: <Z1hj49tuma2zZ1zv@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:57:59 +0000
Message-ID: <CA+EHjTxWQJYWjjcagqwZ2_B7yoUq7OJNwfWkvB_mX35bJLPJXQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/18] KVM: arm64: Introduce __pkvm_host_unshare_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 10 Dec 2024 at 15:53, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 10 Dec 2024 at 14:41:12 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Tue, 3 Dec 2024 at 10:38, Quentin Perret <qperret@google.com> wrote:
> > >
> > > In preparation for letting the host unmap pages from non-protected
> > > guests, introduce a new hypercall implementing the host-unshare-guest
> > > transition.
> > >
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h              |  1 +
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
> > >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  5 ++
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 24 +++++++
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 67 +++++++++++++++++++
> > >  5 files changed, 98 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 449337f5b2a3..0b6c4d325134 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -66,6 +66,7 @@ enum __kvm_host_smccc_func {
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> > > +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
> > >         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index a7976e50f556..e528a42ed60e 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -40,6 +40,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
> > > +int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> >
> > The parameters of share_guest and unshare_guest are quite different. I
> > think that the unshare makes more sense, that it uses the hyp_vm as
> > opposed to the hyp_vcpu. Still, I think that one of the two should
> > change.
>
> Hmm, so that is actually a bit difficult. __pkvm_host_share_guest() is
> guaranteed to always be called when a vCPU is loaded, and it needs to
> use the per-vCPU memcache so we can't just give it the pkvm_hyp_vm as
> is.
>
> And on the other hand, __pkvm_host_unshare_guest() can end up being
> called from MMU notifier where no vCPU is loaded, so it's not clear
> which vCPU it should be using. We also just don't need to access
> per-vCPU data-structures on that path (the unmap call can only free
> page-table pages, which are always put back into the per-guest pool
> directly, not in a memcache).

I understand. That makes sense.

> > >  bool addr_is_memory(phys_addr_t phys);
> > >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > index be52c5b15e21..5dfc9ece9aa5 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > @@ -64,6 +64,11 @@ static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
> > >         return vcpu_is_protected(&hyp_vcpu->vcpu);
> > >  }
> > >
> > > +static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
> > > +{
> > > +       return kvm_vm_is_protected(&hyp_vm->kvm);
> > > +}
> > > +
> > >  void pkvm_hyp_vm_table_init(void *tbl);
> > >
> > >  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index d659462fbf5d..04a9053ae1d5 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -244,6 +244,29 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
> > >         cpu_reg(host_ctxt, 1) =  ret;
> > >  }
> > >
> > > +static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> > > +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> > > +       struct pkvm_hyp_vm *hyp_vm;
> > > +       int ret = -EINVAL;
> > > +
> > > +       if (!is_protected_kvm_enabled())
> > > +               goto out;
> > > +
> > > +       hyp_vm = get_pkvm_hyp_vm(handle);
> > > +       if (!hyp_vm)
> > > +               goto out;
> > > +       if (pkvm_hyp_vm_is_protected(hyp_vm))
> > > +               goto put_hyp_vm;
> >
> > bikeshedding: is -EINVAL the best return value, or might -EPERM be
> > better if the VM is protected?
>
> -EINVAL makes the code marginally simpler, especially given that we have
> this pattern all across hyp-main.c, so I have a minor personal
> preference for keeping it as-is, but no strong opinion really. This
> really shouldn't ever hit at run-time, modulo major bugs or a malicious
> host, so probably not a huge deal if EINVAL isn't particularly accurate.

That's fine.

> > > +
> > > +       ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
> > > +put_hyp_vm:
> > > +       put_pkvm_hyp_vm(hyp_vm);
> > > +out:
> > > +       cpu_reg(host_ctxt, 1) =  ret;
> > > +}
> > > +
> > >  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> > >  {
> > >         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> > > @@ -454,6 +477,7 @@ static const hcall_t host_hcall[] = {
> > >         HANDLE_FUNC(__pkvm_host_share_hyp),
> > >         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> > >         HANDLE_FUNC(__pkvm_host_share_guest),
> > > +       HANDLE_FUNC(__pkvm_host_unshare_guest),
> > >         HANDLE_FUNC(__kvm_adjust_pc),
> > >         HANDLE_FUNC(__kvm_vcpu_run),
> > >         HANDLE_FUNC(__kvm_flush_vm_context),
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index a69d7212b64c..aa27a3e42e5e 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -1413,3 +1413,70 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
> > >
> > >         return ret;
> > >  }
> > > +
> > > +static int __check_host_unshare_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
> >
> > nit: sometimes (in this and other patches) you use vm to refer to
> > pkvm_hyp_vm, and other times you use hyp_vm. Makes grepping/searching
> > a bit more tricky.
>
> Ack, I'll do a pass on the series to improve the consistency.

Thanks!
/fuad

> > > +{
> > > +       enum pkvm_page_state state;
> > > +       struct hyp_page *page;
> > > +       kvm_pte_t pte;
> > > +       u64 phys;
> > > +       s8 level;
> > > +       int ret;
> > > +
> > > +       ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> > > +       if (ret)
> > > +               return ret;
> > > +       if (level != KVM_PGTABLE_LAST_LEVEL)
> > > +               return -E2BIG;
> > > +       if (!kvm_pte_valid(pte))
> > > +               return -ENOENT;
> > > +
> > > +       state = guest_get_page_state(pte, ipa);
> > > +       if (state != PKVM_PAGE_SHARED_BORROWED)
> > > +               return -EPERM;
> > > +
> > > +       phys = kvm_pte_to_phys(pte);
> > > +       ret = range_is_allowed_memory(phys, phys + PAGE_SIZE);
> > > +       if (WARN_ON(ret))
> > > +               return ret;
> > > +
> > > +       page = hyp_phys_to_page(phys);
> > > +       if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> > > +               return -EPERM;
> > > +       if (WARN_ON(!page->host_share_guest_count))
> > > +               return -EINVAL;
> > > +
> > > +       *__phys = phys;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm)
> > > +{
> > > +       u64 ipa = hyp_pfn_to_phys(gfn);
> > > +       struct hyp_page *page;
> > > +       u64 phys;
> > > +       int ret;
> > > +
> > > +       host_lock_component();
> > > +       guest_lock_component(hyp_vm);
> > > +
> > > +       ret = __check_host_unshare_guest(hyp_vm, &phys, ipa);
> > > +       if (ret)
> > > +               goto unlock;
> > > +
> > > +       ret = kvm_pgtable_stage2_unmap(&hyp_vm->pgt, ipa, PAGE_SIZE);
> > > +       if (ret)
> > > +               goto unlock;
> > > +
> > > +       page = hyp_phys_to_page(phys);
> > > +       page->host_share_guest_count--;
> > > +       if (!page->host_share_guest_count)
> > > +               WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED));
> > > +
> > > +unlock:
> > > +       guest_unlock_component(hyp_vm);
> > > +       host_unlock_component();
> > > +
> > > +       return ret;
> > > +}
> > > --
> > > 2.47.0.338.g60cca15819-goog
> > >
