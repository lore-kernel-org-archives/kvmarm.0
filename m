Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CD6366051
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782918053; cv=none; b=JGQw2IoYqnGbgOSGmLvxsrJ5QiUiUZuzP6CepSxZnappfueWdG6TPSHNsM0Yp4D3fqxyPdxlFyqUKLIHTYjHCX42XDreNtDrpdRjq79G+ZIF9a0z32YlRwryT8euag5b/IJ57Kd/IjqSGwA+na9V6Zzh3AV4/8YRqlGr0m+XDU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782918053; c=relaxed/simple;
	bh=1tBpbtauY31MpOCadF4QZFHUFEmduYVt/xowXA5+NRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=RxsMjhX/RPxQyu5FuNRFgkxv1futmwTSARsSBnivQoEsaHRCoyKQF5dr0ENYqiBP5OSF4aCw4kQDIz8YWbkppNBBjWNe41aJVisz7EWY1FKrstpYf+0ynUZaydLY9pl9GqiUM+wgBtIZcLPZGbOAAwvHdXlFZAn7e9QmLUVBah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ve+im/gb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ve+im/gb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6734F2309;
	Wed,  1 Jul 2026 08:00:45 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 861233F85F;
	Wed,  1 Jul 2026 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782918049; bh=1tBpbtauY31MpOCadF4QZFHUFEmduYVt/xowXA5+NRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve+im/gbWHAgIKdjnicMRWA9PKd2f4Wgpy8dVWGVMGEbHG/6KAPAEDPJB9QmcOxih
	 arxD1lfj/7uZcphvmjzqmRwWDxv0yMMYKOEGjN95pSJUakVPZT9om8oHyMaSBX0F+W
	 ggvYHX9kWK5EiCmaRvFyLh9i3EZe1YZCJpBGKbWg=
From: Leonardo Bras <leo.bras@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
Date: Wed,  1 Jul 2026 16:00:41 +0100
Message-ID: <akUrmfQnKmIXTigs@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260630121005.1130996-4-weilin.chang@arm.com>
References: <20260630121005.1130996-1-weilin.chang@arm.com> <20260630121005.1130996-4-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Wei Lin,

On Tue, Jun 30, 2026 at 01:10:02PM +0100, Wei-Lin Chang wrote:
> ptdump files can still be read after the pgt of the canonical mmu is
> freed, if they are opened before the VM debugfs directory is removed.
> This triggers UAF in places where we cache the pgt pointer or access it
> without checking its validity.
> 
> Check the pgt is still alive under the mmu_lock before accessing the
> pgt.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260623142443.648972-1-weilin.chang@arm.com?part=1
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/kvm/ptdump.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index d5aa9eff08d1..752d8e0cd25c 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -115,13 +115,21 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
>  static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
>  {
>  	struct kvm_ptdump_guest_state *st;
> -	struct kvm_pgtable *pgtable = kvm->arch.mmu.pgt;
> +	struct kvm_pgtable *pgtable;
>  	int ret;
>  
>  	st = kzalloc_obj(struct kvm_ptdump_guest_state, GFP_KERNEL_ACCOUNT);
>  	if (!st)
>  		return ERR_PTR(-ENOMEM);
>  
> +	guard(write_lock)(&kvm->mmu_lock);
> +	if (!kvm->arch.mmu.pgt) {
> +		kfree(st);
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	pgtable = kvm->arch.mmu.pgt;
> +
>  	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
>  	if (ret) {
>  		kfree(st);
> @@ -137,7 +145,6 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
>  
>  static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>  {
> -	int ret;
>  	struct kvm_ptdump_guest_state *st = m->private;
>  	struct kvm *kvm = st->kvm;
>  	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> @@ -154,11 +161,11 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>  		.seq		= m,
>  	};
>  
> -	write_lock(&kvm->mmu_lock);
> -	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> -	write_unlock(&kvm->mmu_lock);
> +	guard(write_lock)(&kvm->mmu_lock);
> +	if (mmu->pgt)
> +		return kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);

IIUC, that's the same behavior, right?
Just changed to look about the same with the rest of this file?

>  
> -	return ret;
> +	return 0;
>  }

So if the pgt does not exist anymore, it returns zero. Is that the desired 
behavior?

I guess it's aligned with the idea of single file mentioned in the cover, 
right?

>  
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> @@ -206,17 +213,23 @@ static const struct file_operations kvm_ptdump_guest_fops = {
>  
>  static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
>  {
> -	struct kvm_pgtable *pgtable = m->private;
> +	struct kvm *kvm = m->private;
> +
> +	guard(write_lock)(&kvm->mmu_lock);
> +	if (kvm->arch.mmu.pgt)
> +		seq_printf(m, "%2u\n", kvm->arch.mmu.pgt->ia_bits);
>  
> -	seq_printf(m, "%2u\n", pgtable->ia_bits);
>  	return 0;
>  }
>  
>  static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
>  {
> -	struct kvm_pgtable *pgtable = m->private;
> +	struct kvm *kvm = m->private;
> +
> +	guard(write_lock)(&kvm->mmu_lock);
> +	if (kvm->arch.mmu.pgt)
> +		seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - kvm->arch.mmu.pgt->start_level);
>  
> -	seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - pgtable->start_level);
>  	return 0;
>  }
>  
> @@ -224,15 +237,12 @@ static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
>  				    int (*show)(struct seq_file *, void *))
>  {
>  	struct kvm *kvm = m->i_private;
> -	struct kvm_pgtable *pgtable;
>  	int ret;
>  
>  	if (!kvm_get_kvm_safe(kvm))
>  		return -ENOENT;
>  
> -	pgtable = kvm->arch.mmu.pgt;
> -
> -	ret = single_open(file, show, pgtable);
> +	ret = single_open(file, show, kvm);

Maybe this change is more related with the previous patch?

>  	if (ret < 0)
>  		kvm_put_kvm(kvm);
>  	return ret;
> -- 
> 2.43.0
> 

Thanks!
Leo
