Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8EB3B5305
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074487; cv=none; b=I+PoQPqSYpZJD1gM4EA8ovQXKNxeUMroqRjfxMka49Cn9JdYzSr0f3QQS4ppDBRuK+eSnnpZTmOpJScj15O6OA1JpJVPRbFDu1Ry540oXb4TGj5gM7UZd9cX29Iz9qqND4j7s5OyOflBDWsB2njU82Irc6tvqff2flY0J058rTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074487; c=relaxed/simple;
	bh=HCfaiQ70wDFRE9iE7hAdyxdatvon4JcTAsPQjZG1BnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0Mqbg8MbUHckyotOAS6XLgxKdu1/CbxOMs6hWckfBLlXcpmOvC284uFkqHb+iLDAcV/vlxLqoZYDtKDvMFRQ+TJMaYMXJdZE60RBX2BIwCwd5MVzucMRnzYIgcsFZyRBQhPzx0Td3VzTnGEinw+hREn+S0JzN2hnmrNqOkDdKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FhdgFc7m; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FhdgFc7m"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E2181F91;
	Fri,  3 Jul 2026 03:28:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11C553F905;
	Fri,  3 Jul 2026 03:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783074485; bh=HCfaiQ70wDFRE9iE7hAdyxdatvon4JcTAsPQjZG1BnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FhdgFc7m0+X94gzv10Bb3P3XVYELZ7ey/aqt8urO0IQxMb8K1w46DpvxF4JsXg8/x
	 L2GY3bCek9PXtG0GR4A2UCqgKELuPcjckiuHLErhDC6FwupKW8mmeqIMVyBTW8ckG/
	 Gj+zLIcvhJJ2/Dbpr259d9FeiOPzSB1RqjIZZfUo=
Date: Fri, 3 Jul 2026 11:27:47 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: ptdump: Introduce the shadow ptdump
 file
Message-ID: <scnwtpvy2gkkzwjmweiaiiinxx7xtisbpjjlrtf2nxkraqqpg3@haaa3d3ll4et>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-7-weilin.chang@arm.com>
 <akbcl8vFrpq40qUM@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akbcl8vFrpq40qUM@sm-arm-grace07>

On Fri, Jul 03, 2026 at 06:48:07AM +0900, Itaru Kitayama wrote:
> On Tue, Jun 30, 2026 at 01:10:05PM +0100, Wei-Lin Chang wrote:
> > Create a ptdump file for all shadow page tables. It will dump out all
> > valid shadow page tables at the time of request, with the mmu's index,
> > guest VTCR_EL2, VTTBR_EL2, and whether the guest stage-2 is enabled or
> > not.
> > 
> > Also detach the nested mmu array under the mmu_lock in
> > kvm_arch_flush_shadow_all() so readers cannot race with the array being
> > removed, then free the old array after dropping the lock.
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
> 
> This header information in the debugfs "shadow_page_tables" file, under
> the nested directory is showing guest hypervisor's configuration while
> the file is designed to show nested guest's shadwo stage 2 translation
> tables layouts owned by Host EL2 hypervisor. Is this intentional?

Yes, this is intentional. Here we are exposing guest hypervisor VTCR,
VTTBR, s2 enabled or not, because that is how the host hypervisor
distinguishes between different nested mmus (lookup_s2_mmu()).

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
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
