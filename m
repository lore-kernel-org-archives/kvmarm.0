Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9483B19A9
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 21:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783028968; cv=none; b=CNHKJ5YbPiqSJFZisIbCd3Oe0fV7vCsO5g9F3p6V43cD65Y9bIyumXQIt2Z+v3+C7e/03ebf7I2ammvRVNis0ZYXEs4zOIoOXLRGJVBNc0oyeugmAN0wHTXUbETtuTl65n66EZnu6Bk3D+sCv63v/KtKspoIPR0N/u989cMXMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783028968; c=relaxed/simple;
	bh=eQ/r81yq7SBHVmjU6sNi5AKmD7P2Gx79kRYPEcoBKn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOEotNPtlRYfpVp+749lA0cvsevVnbKjLyWxtXTfbjVlygoljoe3XzS1fjndpAk418lQioMYAKdxqJGmhS7dduiGSjNXsaLTa278n9UluvNe0WznTv9Xuf4H0KX6cP6Nt9bt8d4ILdL5S4lXbYqutSPimGYcVwjZtnd4aXaUcZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=COj5PHM+; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="COj5PHM+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783028968; x=1814564968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eQ/r81yq7SBHVmjU6sNi5AKmD7P2Gx79kRYPEcoBKn4=;
  b=COj5PHM+pXEByKDdK3N2zJtLAaujtA5as+RzV7qcHycHr/DYA3AwMVPq
   h3L4Ic/iOIcUsQwlhXuSLfWU42DL1kDCPtUi76T1KQnvSnTQwNtcOON5G
   3Db1+NJHTMG9/RKUXb9/YtYgX5jg+j0mG/W4OmF9OMskDWnuTZx/yCDUM
   s4HRpGLQbV+l+gpqbKlGMIgFWivoDewQvSYNy5+Z9K46DnGTtaaU0PxUV
   Cq1r8ncqW2V9g+4BCLxvx5FoowYyrGOK2JeI6AeUPLCUevgssmRbqOfpq
   zQEvSqnq4VYnU5lbpZA4x2NXCAOXuV+1eaIt+wirgsGe9hv/znJ1bdHTU
   w==;
X-CSE-ConnectionGUID: go7h+TCdS16+MtsMOyy+Tw==
X-CSE-MsgGUID: JCwFnP0AQCeSZXad+0cPsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="249536182"
X-IronPort-AV: E=Sophos;i="6.25,144,1779116400"; 
   d="scan'208";a="249536182"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 06:48:17 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id A00801C1C707
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 21:48:15 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 58718148AD36
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 21:48:15 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 7205640260E;
	Thu,  2 Jul 2026 21:48:10 +0000 (UTC)
Date: Fri, 3 Jul 2026 06:48:07 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: ptdump: Introduce the shadow ptdump
 file
Message-ID: <akbcl8vFrpq40qUM@sm-arm-grace07>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-7-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630121005.1130996-7-weilin.chang@arm.com>

On Tue, Jun 30, 2026 at 01:10:05PM +0100, Wei-Lin Chang wrote:
> Create a ptdump file for all shadow page tables. It will dump out all
> valid shadow page tables at the time of request, with the mmu's index,
> guest VTCR_EL2, VTTBR_EL2, and whether the guest stage-2 is enabled or
> not.
> 
> Also detach the nested mmu array under the mmu_lock in
> kvm_arch_flush_shadow_all() so readers cannot race with the array being
> removed, then free the old array after dropping the lock.
> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/kvm/nested.c | 12 ++++++--
>  arch/arm64/kvm/ptdump.c | 61 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 6435efd65cb5..17a180ddf6ca 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1283,6 +1283,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	struct kvm_s2_mmu *mmus;
>  	int i;
>  
>  	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> @@ -1291,9 +1292,14 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))
>  			kvm_free_stage2_pgd(mmu);
>  	}
> -	kvfree(kvm->arch.nested_mmus);
> -	kvm->arch.nested_mmus = NULL;
> -	kvm->arch.nested_mmus_size = 0;
> +
> +	scoped_guard(write_lock, &kvm->mmu_lock) {
> +		mmus = kvm->arch.nested_mmus;
> +		kvm->arch.nested_mmus = NULL;
> +		kvm->arch.nested_mmus_size = 0;
> +	}
> +
> +	kvfree(mmus);
>  	kvm_uninit_stage2_mmu(kvm);
>  }
>  
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 40f93b7c7ad9..1649eaa75798 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -181,6 +181,50 @@ static int kvm_ptdump_guest_canonical_show(struct seq_file *m, void *unused)
>  	return 0;
>  }
>  
> +static int kvm_ptdump_guest_nested_show(struct seq_file *m, void *unused)
> +{
> +	int ret = 0, i;
> +	struct kvm_ptdump_guest_state *st = m->private;
> +	struct kvm *kvm = st->kvm;
> +	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
> +		.cb	= kvm_ptdump_visitor,
> +		.arg	= &st->parser_state,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	guard(write_lock)(&kvm->mmu_lock);
> +
> +	if (!kvm->arch.nested_mmus)
> +		return 0;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (!mmu->pgt)
> +			continue;
> +
> +		if (kvm_s2_mmu_valid(mmu)) {
> +			memset(st, 0, sizeof(*st));
> +			ret = kvm_ptdump_parser_init(st, kvm, mmu->pgt);
> +			if (ret)
> +				return ret;
> +			st->parser_state = (struct ptdump_pg_state) {
> +				.marker		= &st->ipa_marker[0],
> +				.level		= -1,
> +				.pg_level	= &st->level[0],
> +				.seq		= m,
> +			};
> +			seq_printf(m, "nested mmu %d VTCR: 0x%016llx VTTBR: 0x%016llx s2: %s\n",
> +				   i, mmu->tlb_vtcr, mmu->tlb_vttbr,
> +				   mmu->nested_stage2_enabled ? "enabled" : "disabled");

This header information in the debugfs "shadow_page_tables" file, under
the nested directory is showing guest hypervisor's configuration while
the file is designed to show nested guest's shadwo stage 2 translation
tables layouts owned by Host EL2 hypervisor. Is this intentional?

Thanks,
Itaru.

> +			ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file,
>  				 int (*show)(struct seq_file *, void *))
>  {
> @@ -212,6 +256,11 @@ static int kvm_ptdump_guest_canonical_open(struct inode *m, struct file *file)
>  	return kvm_ptdump_guest_open(m, file, kvm_ptdump_guest_canonical_show);
>  }
>  
> +static int kvm_ptdump_guest_nested_open(struct inode *m, struct file *file)
> +{
> +	return kvm_ptdump_guest_open(m, file, kvm_ptdump_guest_nested_show);
> +}
> +
>  static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
>  {
>  	struct kvm *kvm = m->i_private;
> @@ -230,6 +279,13 @@ static const struct file_operations kvm_ptdump_guest_canonical_fops = {
>  	.release	= kvm_ptdump_guest_close,
>  };
>  
> +static const struct file_operations kvm_ptdump_guest_nested_fops = {
> +	.open		= kvm_ptdump_guest_nested_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_ptdump_guest_close,
> +};
> +
>  static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
>  {
>  	struct kvm *kvm = m->private;
> @@ -307,6 +363,9 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  			    kvm, &kvm_pgtable_range_fops);
>  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
>  			    kvm, &kvm_pgtable_levels_fops);
> -	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT)) {
>  		kvm->arch.debugfs_nv_dentry = debugfs_create_dir("nested", kvm->debugfs_dentry);
> +		debugfs_create_file("shadow_page_tables", 0400, kvm->arch.debugfs_nv_dentry,
> +				    kvm, &kvm_ptdump_guest_nested_fops);
> +	}
>  }
> -- 
> 2.43.0
> 
