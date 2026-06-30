Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2869E385D9E
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782822480; cv=none; b=MopLLeOrj7scoa2ot3X3D7qZFZgazotedVadPoiZAsTy26dBkGcu7yb6/JiIAzDe/cszAUNc35Ndh9Z1PMFj3jIw32LdAmMUYHMNroyIx8YWu6TuRpeyvnJqSnQwVIEfbb91SkBclc6j9GsmqCxWBAtmpQ8BDD0U6VKmp0II6XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782822480; c=relaxed/simple;
	bh=6udNjVB7je6ej1rSJ0BjqDObZeP8O3HZWLaxvyVUJ2c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BmZFP2r4PRt2YVRF4LFU6FSKp/JLIleaClo91KXeWFVv5NXtyHaOv0bszmzlAxnU+trGNLXKiXSG0GbUqdCO5GhNzro81I/nQbmTv4ecPPWP6HN2LoYAGj5D1FjEQ4vGgpMAnPJ5zUbtG3SyjdBV/dbnQIin4FMuVK9vcV/I4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxDqclXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxDqclXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891011F00A3A;
	Tue, 30 Jun 2026 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782822478;
	bh=79mJY+ljokItEcS+P1gqzURPK/rKtKOIU642l8hGFDM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lxDqclXK7fKEJ09bneEMHDC7kPrB7BK9opOJAEh22N1ur43fBWyAaqEuaD+Nyz/6N
	 gukepdIzi+lOAEblyFxEFUDNUeDpcI64RqvPFYDOBEjAiymm8M4TCS84cBB+u/9pGc
	 Cq7A5bRj7O4yLPzjepMMjVCJ/17PDeitAH5MNkgmhEHXOlNZuioWrCOgsJaqXy+BrA
	 8ofnB9dl4CHkzyMVEEImGLcEp30xa+YMmE4asDUjw7W1pXbU9xpIhID/Ih+0uHDgAS
	 t2WA5Ugtba7BY6K4tcJ0b74PUi5MYpkHaRc0TyP1rsxFvGQev9PaT2zs+BGXZgzCT+
	 A8+h3JP8mcgcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/6] KVM: arm64: ptdump: Introduce the shadow ptdump
 file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260630121005.1130996-7-weilin.chang@arm.com>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-7-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 12:27:58 +0000
Message-Id: <20260630122758.891011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Concurrent reallocation of nested_mmus array leads to Use-After-Fr=
ee in kvm_ptdump_guest_nested_show().
- [High] If kvm_ptdump_parser_init() fails, st->kvm is left as NULL, causin=
g a kernel panic on subsequent debugfs reads.
- [Medium] Missing note_page_flush() causes the last contiguous block of pa=
ge table entries to be silently dropped.

Pre-existing issues:
- [Critical] kvm_arch_flush_shadow_all() frees the nested_mmus array even i=
f active VCPUs hold references to its elements.
- [High] Unprotected iteration over nested_mmus in kvm_arch_flush_shadow_al=
l() races with array reallocation.
--

commit 4dce12b467bf2d3540834dccee1f3e623af43d42
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: ptdump: Introduce the shadow ptdump file

This commit creates a ptdump file for shadow page tables used in nested
virtualization. It dumps all valid shadow page tables, their mmu index,
VTCR_EL2, VTTBR_EL2, and stage-2 enablement status. It also modifies
kvm_arch_flush_shadow_all() to detach the nested mmu array under mmu_lock.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index efd5d21c7ac75..cbf7143819669 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1184,6 +1184,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
> =20
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	struct kvm_s2_mmu *mmus;
>  	int i;
> =20
>  	for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {

[Severity: High]
This is a pre-existing issue, but can this loop race with array reallocatio=
n?

If a concurrent thread calls KVM_ARM_VCPU_INIT to initialize a new nested
vCPU, kvm_vcpu_init_nested() expands the array via kvrealloc() holding
only kvm->arch.config_lock. Since this loop doesn't hold config_lock or
mmu_lock, could it dereference the array while or after it is freed?

>  		struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> =20
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))
>  			kvm_free_stage2_pgd(mmu);
>  	}
> -	kvfree(kvm->arch.nested_mmus);
> -	kvm->arch.nested_mmus =3D NULL;
> -	kvm->arch.nested_mmus_size =3D 0;
> +
> +	scoped_guard(write_lock, &kvm->mmu_lock) {
> +		mmus =3D kvm->arch.nested_mmus;
> +		kvm->arch.nested_mmus =3D NULL;
> +		kvm->arch.nested_mmus_size =3D 0;
> +	}
> +
> +	kvfree(mmus);

[Severity: Critical]
This is a pre-existing issue, but does this prematurely free the array if=20
active VCPUs hold references?

If a running vCPU holds a reference to its nested MMU, where atomic_read
shows refcnt > 0, the loop above skips freeing the page table, but the
backing array is freed anyway.=20

When the vCPU exits and calls kvm_vcpu_put_hw_mmu(), it will dereference the
freed pointer. Should the array lifetime be tied to the active references?

>  	kvm_uninit_stage2_mmu(kvm);
>  }

[ ... ]

> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 40f93b7c7ad98..1649eaa75798c 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -181,6 +181,50 @@ static int kvm_ptdump_guest_canonical_show(struct se=
q_file *m, void *unused)
>  	return 0;
>  }
> =20
> +static int kvm_ptdump_guest_nested_show(struct seq_file *m, void *unused)
> +{
> +	int ret =3D 0, i;
> +	struct kvm_ptdump_guest_state *st =3D m->private;
> +	struct kvm *kvm =3D st->kvm;
> +	struct kvm_pgtable_walker walker =3D (struct kvm_pgtable_walker) {
> +		.cb	=3D kvm_ptdump_visitor,
> +		.arg	=3D &st->parser_state,
> +		.flags	=3D KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	guard(write_lock)(&kvm->mmu_lock);
> +
> +	if (!kvm->arch.nested_mmus)
> +		return 0;
> +
> +	for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {

[Severity: High]
Is it safe to iterate over the nested_mmus array holding only mmu_lock?

If userspace reads the debugfs file while a concurrent thread issues a
KVM_ARM_VCPU_INIT ioctl to initialize a new nested vCPU, kvm_vcpu_init_nest=
ed()
expands the array via kvrealloc() holding only kvm->arch.config_lock:

kvm_vcpu_init_nested()
    tmp =3D kvrealloc(kvm->arch.nested_mmus, ...);
    swap(kvm->arch.nested_mmus, tmp);

Could the debugfs reader dereference the array while or after it is freed by
kvrealloc()?

> +		struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> +
> +		if (!mmu->pgt)
> +			continue;
> +
> +		if (kvm_s2_mmu_valid(mmu)) {
> +			memset(st, 0, sizeof(*st));
> +			ret =3D kvm_ptdump_parser_init(st, kvm, mmu->pgt);
> +			if (ret)
> +				return ret;

[Severity: High]
Does an early return here leave st->kvm as NULL?

The memset() clears st->kvm. If kvm_ptdump_parser_init() returns an error,
the function propagates it, leaving st->kvm NULL.=20

If userspace issues another read() on the same file descriptor, seq_read wi=
ll
call the show() callback again, which will dereference the NULL st->kvm
at the mmu_lock acquisition:

guard(write_lock)(&kvm->mmu_lock);

Could we restore st->kvm on the error path?

> +			st->parser_state =3D (struct ptdump_pg_state) {
> +				.marker		=3D &st->ipa_marker[0],
> +				.level		=3D -1,
> +				.pg_level	=3D &st->level[0],
> +				.seq		=3D m,
> +			};
> +			seq_printf(m, "nested mmu %d VTCR: 0x%016llx VTTBR: 0x%016llx s2: %s\=
n",
> +				   i, mmu->tlb_vtcr, mmu->tlb_vttbr,
> +				   mmu->nested_stage2_enabled ? "enabled" : "disabled");
> +			ret =3D kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker=
);
> +			if (ret)
> +				return ret;

[Severity: Medium]
Does the page table walk lack a subsequent call to note_page_flush()?

The ptdump API requires a final call to note_page_flush() to emit the final
buffered contiguous block of page table attributes. Because this is missing
after the kvm_pgtable_walk() completion, does the last block get silently
dropped from the debugfs output?

> +		}
> +	}
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630121005.1130=
996-1-weilin.chang@arm.com?part=3D6
