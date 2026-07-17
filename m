Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83FD3BD649;
	Fri, 17 Jul 2026 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299955; cv=none; b=eBZBIhwcuYNBYmdHmnGa3IUwd9xGrjzrWh75LQCQSwjLjTgHegr8hpt3M0ueH/K4p3uZ74563D+8sZ4sedgFguOS3FwRK2GC4BhbNJmLfhmfkuk9epBxHPabL4VzkaefZFEn4520LL9X0u7SVwwP0oIsGFpLBc08nuidyzdAKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299955; c=relaxed/simple;
	bh=geTaRSRCfA4B+W8HfR1RTJSb4KA1DesAeGKjhcCy5KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEM63XyROHEoLzBu275w97RL4b1QTmaEwMjxwFuX48RI6/AQy2wqej7vk2+ZucIwz5iGGKljv9PYezFkwj9Tc4tCrhozfbwcnDtMapgdbQ3mv/6/wcUp6h+tfUyjQELvQj0+E2eCQpoKUCG7eGdMMid1TlKEuPOMaAU8HAgSXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q17D4JsG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q17D4JsG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9161A1477;
	Fri, 17 Jul 2026 07:52:21 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3ECA3F7B4;
	Fri, 17 Jul 2026 07:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784299945; bh=geTaRSRCfA4B+W8HfR1RTJSb4KA1DesAeGKjhcCy5KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q17D4JsGFEBL+6sDpWMcunngyC29rqf+fGimEpqOWyidmQn1Ye5b9Ng024IiN8XO1
	 BpSiseiXuS3rkwGilTBd0Mtc+3zJUOqdi4vcGpkDxmGIPUfpSc+LE4KLYjoJ+KoKrd
	 2yX9ouadFjtS1r9vxHfpHw53Lf613JWf8pjSvHzw=
Date: Fri, 17 Jul 2026 15:52:17 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 6/6] KVM: arm64: ptdump: Introduce the shadow ptdump
 file
Message-ID: <i2yajpp7keupxj5ltqv25vccubjx5ux6nkbc6dkdwcnlsuw6jv@xx5euxyk4uip>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-7-weilin.chang@arm.com>
 <20260630122758.891011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260630122758.891011F00A3A@smtp.kernel.org>

On Tue, Jun 30, 2026 at 12:27:58PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [High] Concurrent reallocation of nested_mmus array leads to Use-After-Free in kvm_ptdump_guest_nested_show().
> - [High] If kvm_ptdump_parser_init() fails, st->kvm is left as NULL, causing a kernel panic on subsequent debugfs reads.
> - [Medium] Missing note_page_flush() causes the last contiguous block of page table entries to be silently dropped.
> 
> Pre-existing issues:
> - [Critical] kvm_arch_flush_shadow_all() frees the nested_mmus array even if active VCPUs hold references to its elements.
> - [High] Unprotected iteration over nested_mmus in kvm_arch_flush_shadow_all() races with array reallocation.
> --
> 
> commit 4dce12b467bf2d3540834dccee1f3e623af43d42
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: ptdump: Introduce the shadow ptdump file
> 
> This commit creates a ptdump file for shadow page tables used in nested
> virtualization. It dumps all valid shadow page tables, their mmu index,
> VTCR_EL2, VTTBR_EL2, and stage-2 enablement status. It also modifies
> kvm_arch_flush_shadow_all() to detach the nested mmu array under mmu_lock.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index efd5d21c7ac75..cbf7143819669 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1184,6 +1184,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
> >  
> >  void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  {
> > +	struct kvm_s2_mmu *mmus;
> >  	int i;
> >  
> >  	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> 
> [Severity: High]
> This is a pre-existing issue, but can this loop race with array reallocation?
> 
> If a concurrent thread calls KVM_ARM_VCPU_INIT to initialize a new nested
> vCPU, kvm_vcpu_init_nested() expands the array via kvrealloc() holding
> only kvm->arch.config_lock. Since this loop doesn't hold config_lock or
> mmu_lock, could it dereference the array while or after it is freed?

I don't think so, if a concurrent thread calls KVM_ARM_VCPU_INIT, it
means both the kvm structure and mm_struct is still live, hence
kvm_arch_flush_shadow_all() won't be called, as it is called when kvm
unregisters mmu notifiers (kvm_destroy_vm(), when the last kvm reference
goes), or when the last mmput() happens which call the mmu notifier
release.

> 
> >  		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> >  
> >  		if (!WARN_ON(atomic_read(&mmu->refcnt)))
> >  			kvm_free_stage2_pgd(mmu);
> >  	}
> > -	kvfree(kvm->arch.nested_mmus);
> > -	kvm->arch.nested_mmus = NULL;
> > -	kvm->arch.nested_mmus_size = 0;
> > +
> > +	scoped_guard(write_lock, &kvm->mmu_lock) {
> > +		mmus = kvm->arch.nested_mmus;
> > +		kvm->arch.nested_mmus = NULL;
> > +		kvm->arch.nested_mmus_size = 0;
> > +	}
> > +
> > +	kvfree(mmus);
> 
> [Severity: Critical]
> This is a pre-existing issue, but does this prematurely free the array if 
> active VCPUs hold references?
> 
> If a running vCPU holds a reference to its nested MMU, where atomic_read
> shows refcnt > 0, the loop above skips freeing the page table, but the
> backing array is freed anyway. 
> 
> When the vCPU exits and calls kvm_vcpu_put_hw_mmu(), it will dereference the
> freed pointer. Should the array lifetime be tied to the active references?

Similar to my comment above, when kvm_arch_flush_shadow_all() is called,
there will be no more mm_struct users, so there can't be any running
vCPUs to race against.

> 
> >  	kvm_uninit_stage2_mmu(kvm);
> >  }
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index 40f93b7c7ad98..1649eaa75798c 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -181,6 +181,50 @@ static int kvm_ptdump_guest_canonical_show(struct seq_file *m, void *unused)
> >  	return 0;
> >  }
> >  
> > +static int kvm_ptdump_guest_nested_show(struct seq_file *m, void *unused)
> > +{
> > +	int ret = 0, i;
> > +	struct kvm_ptdump_guest_state *st = m->private;
> > +	struct kvm *kvm = st->kvm;
> > +	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
> > +		.cb	= kvm_ptdump_visitor,
> > +		.arg	= &st->parser_state,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +	};
> > +
> > +	guard(write_lock)(&kvm->mmu_lock);
> > +
> > +	if (!kvm->arch.nested_mmus)
> > +		return 0;
> > +
> > +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> 
> [Severity: High]
> Is it safe to iterate over the nested_mmus array holding only mmu_lock?
> 
> If userspace reads the debugfs file while a concurrent thread issues a
> KVM_ARM_VCPU_INIT ioctl to initialize a new nested vCPU, kvm_vcpu_init_nested()
> expands the array via kvrealloc() holding only kvm->arch.config_lock:
> 
> kvm_vcpu_init_nested()
>     tmp = kvrealloc(kvm->arch.nested_mmus, ...);
>     swap(kvm->arch.nested_mmus, tmp);
> 
> Could the debugfs reader dereference the array while or after it is freed by
> kvrealloc()?

This should be fixed by ("KVM: arm64: Reassign nested_mmus array behind mmu_lock") [*].

[*]: https://lore.kernel.org/kvmarm/aiKIVVeIr1aAB1yp@v4bel/

> 
> > +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> > +
> > +		if (!mmu->pgt)
> > +			continue;
> > +
> > +		if (kvm_s2_mmu_valid(mmu)) {
> > +			memset(st, 0, sizeof(*st));
> > +			ret = kvm_ptdump_parser_init(st, kvm, mmu->pgt);
> > +			if (ret)
> > +				return ret;
> 
> [Severity: High]
> Does an early return here leave st->kvm as NULL?
> 
> The memset() clears st->kvm. If kvm_ptdump_parser_init() returns an error,
> the function propagates it, leaving st->kvm NULL. 
> 
> If userspace issues another read() on the same file descriptor, seq_read will
> call the show() callback again, which will dereference the NULL st->kvm
> at the mmu_lock acquisition:
> 
> guard(write_lock)(&kvm->mmu_lock);
> 
> Could we restore st->kvm on the error path?

I'll just rearrange kvm_ptdump_parser_init() so that st->kvm is set
before the possible error return.

> 
> > +			st->parser_state = (struct ptdump_pg_state) {
> > +				.marker		= &st->ipa_marker[0],
> > +				.level		= -1,
> > +				.pg_level	= &st->level[0],
> > +				.seq		= m,
> > +			};
> > +			seq_printf(m, "nested mmu %d VTCR: 0x%016llx VTTBR: 0x%016llx s2: %s\n",
> > +				   i, mmu->tlb_vtcr, mmu->tlb_vttbr,
> > +				   mmu->nested_stage2_enabled ? "enabled" : "disabled");
> > +			ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > +			if (ret)
> > +				return ret;
> 
> [Severity: Medium]
> Does the page table walk lack a subsequent call to note_page_flush()?
> 
> The ptdump API requires a final call to note_page_flush() to emit the final
> buffered contiguous block of page table attributes. Because this is missing
> after the kvm_pgtable_walk() completion, does the last block get silently
> dropped from the debugfs output?

Unfortunately yes, we are missing the last row for stage-2 ptdump,
however the fix is not a note_page_flush(), as it uses 0 for the current
address. For stage-2 ptdump we should supply the last address of the
guest IPA space.

However, this is a separate problem and can be fixed after this series.

Thanks,
Wei-Lin Chang

> 
> > +		}
> > +	}
> > +	return ret;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260630121005.1130996-1-weilin.chang@arm.com?part=6
