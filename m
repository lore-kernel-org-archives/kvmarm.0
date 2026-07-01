Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E96373BE4
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782927362; cv=none; b=bQ5TOBsa+X/qufYbtthlklhX8nQKs/1CzQwWg+iVI+vtdIFhWKgwJT2bDMQGdJhPUwDgnzfYkA6ahSDU0Z22H4H5gobdumSHfvHamcP36QgQPxYEP+0rBh/KQknq/IbDMZ76geSTq7NBi+osylBxAzdBzfT8CxXl7EScWt+R9mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782927362; c=relaxed/simple;
	bh=tUVjgnoCXK425hJ9lnJj9A/8pGEa+OPuvDAnVXgMXvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfp6BRDPqRSCCNFmxYmEOIAx37W5RhhonbOghaIE6csNi1IMqCCs4l7Sb8Fz2+ZyiZjuMGqYkjni81Iu42SEOrp/paIDw0xXvB5BR8aGiz8gV+Tz9bertApFmL9TO1BTaHnDXTmrMXSkLhWPWA8oIMH5nGLeKbJ4xx29E6lgHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aYSfjKWg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aYSfjKWg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70A97455B;
	Wed,  1 Jul 2026 10:35:55 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4F103F85F;
	Wed,  1 Jul 2026 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782927359; bh=tUVjgnoCXK425hJ9lnJj9A/8pGEa+OPuvDAnVXgMXvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aYSfjKWghVCshUScZy3e0nWr9yRnuSNXSPRfOYH30kUO0/+sBa1dCNwsOpNToP5Zz
	 8p3tKf7Xv8D8o6goUBvUnvkdhaGYGUw46dhm/uHc0BY7dqPGLTrwzaE0vsRD95FGwN
	 IJGlD4zOdj0BIEDEdThQ328NQSuocKvfVuor7SSw=
Date: Wed, 1 Jul 2026 18:35:41 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: ptdump: Introduce the shadow ptdump
 file
Message-ID: <w6ffknve2o3l5pgk7mblovsu5xzjwsgf7qyjd66nqwbtsea4ue@h5wj26fbb6kb>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-7-weilin.chang@arm.com>
 <akUyI3Z9JbggzE5P@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akUyI3Z9JbggzE5P@LeoBrasDK>

On Wed, Jul 01, 2026 at 04:28:35PM +0100, Leonardo Bras wrote:
> On Tue, Jun 30, 2026 at 01:10:05PM +0100, Wei-Lin Chang wrote:
> > Create a ptdump file for all shadow page tables. It will dump out all
> > valid shadow page tables at the time of request, with the mmu's index,
> > guest VTCR_EL2, VTTBR_EL2, and whether the guest stage-2 is enabled or
> > not.
> > 
> > Also detach the nested mmu array under the mmu_lock in
> > kvm_arch_flush_shadow_all() so readers cannot race with the array being
> > removed, then free the old array after dropping the lock.
> 
> Out of curiosity: why drop the lock before kfree'ing ?

Because kvfree() can sleep! :)

Thanks,
Wei-Lin Chang

> 
> Thanks!
> Leo
> 
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/kvm/nested.c | 12 ++++++--
> >  arch/arm64/kvm/ptdump.c | 61 ++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 69 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 6435efd65cb5..17a180ddf6ca 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1283,6 +1283,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
> >  
> >  void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  {
> > +	struct kvm_s2_mmu *mmus;
> >  	int i;
> >  
> >  	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> > @@ -1291,9 +1292,14 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
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
> >  	kvm_uninit_stage2_mmu(kvm);
> >  }
> >  
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index 40f93b7c7ad9..1649eaa75798 100644
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
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +
> >  static int kvm_ptdump_guest_open(struct inode *m, struct file *file,
> >  				 int (*show)(struct seq_file *, void *))
> >  {
> > @@ -212,6 +256,11 @@ static int kvm_ptdump_guest_canonical_open(struct inode *m, struct file *file)
> >  	return kvm_ptdump_guest_open(m, file, kvm_ptdump_guest_canonical_show);
> >  }
> >  
> > +static int kvm_ptdump_guest_nested_open(struct inode *m, struct file *file)
> > +{
> > +	return kvm_ptdump_guest_open(m, file, kvm_ptdump_guest_nested_show);
> > +}
> > +
> >  static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
> >  {
> >  	struct kvm *kvm = m->i_private;
> > @@ -230,6 +279,13 @@ static const struct file_operations kvm_ptdump_guest_canonical_fops = {
> >  	.release	= kvm_ptdump_guest_close,
> >  };
> >  
> > +static const struct file_operations kvm_ptdump_guest_nested_fops = {
> > +	.open		= kvm_ptdump_guest_nested_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= kvm_ptdump_guest_close,
> > +};
> > +
> >  static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
> >  {
> >  	struct kvm *kvm = m->private;
> > @@ -307,6 +363,9 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
> >  			    kvm, &kvm_pgtable_range_fops);
> >  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
> >  			    kvm, &kvm_pgtable_levels_fops);
> > -	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> > +	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT)) {
> >  		kvm->arch.debugfs_nv_dentry = debugfs_create_dir("nested", kvm->debugfs_dentry);
> > +		debugfs_create_file("shadow_page_tables", 0400, kvm->arch.debugfs_nv_dentry,
> > +				    kvm, &kvm_ptdump_guest_nested_fops);
> > +	}
> >  }
> > -- 
> > 2.43.0
> > 
