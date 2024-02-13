Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244131427A
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 00:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707784978; cv=none; b=DS9yhEsPFLYHgi7clR/ten6l/vEgAobYm+EOkBopXJg0gbvDj6oV92RKKMitdOlrVrvwEzyFrQH31V12EbC7FjUlTFOJvJzfCbrVALjT+aPLu1V58lv2kt5j0wqPz8ymJ3AGt9o542zOIHg8CrY+6+S2cUNpha/tXsuSiJWBHjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707784978; c=relaxed/simple;
	bh=gA+Xa+6Y55zqiI5qoWy1ShV/7lsLMAtAaXTKnsocFSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYNJQ0WGbiZk7pZWzgaBkFhSl6N46rPNU9wO7cD9jbENqM0bj6JwS6RaYuhdk7Hcz5qjgt/GnoQZOGqRRWqLrtAGaMGQdL4dW60h1Djt/1cF1oNUjAHKrlAB+uPMria8mTqd8B/OarwRDQ95Thx3CwCnl0HMF2w2/y5jTHEocXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GEodXVkh; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GEodXVkh"
Date: Tue, 13 Feb 2024 00:42:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707784974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TwpWpfgSn2V8FzZ4B5TLWeTd3gflXQaSg0MZWBteRl4=;
	b=GEodXVkhqQR2cOLcZYgqK9nRLMsHwHXzZjWTbSs+ez3mlRMczU+1o0dHrnwwz2F2mcTBFL
	VUT1uaR+MmKRFCbvJjk+iBohYOwnr5skHIXm/vuqjbU2ywNpQGJzdypw5yn/t2UpXXkZxg
	mCo4XDnUu7lVjgrqX5Js/FbykrVaRXM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, rananta@google.com,
	ricarkol@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com
Subject: Re: [PATCH v5 4/4] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <Zcq7AoII8qLWwjsu@linux.dev>
References: <20240207144832.1017815-2-sebastianene@google.com>
 <20240207144832.1017815-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207144832.1017815-6-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 07, 2024 at 02:48:33PM +0000, Sebastian Ene wrote:
> Define a set of attributes used by the ptdump parser to display the
> properties of a guest memory region covered by a pagetable descriptor.
> Build a description of the pagetable levels and initialize the parser
> with this configuration.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/ptdump.c | 156 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 156 insertions(+)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index a4e984da8aa7..60725d46f17b 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -14,6 +14,69 @@
>  #include <kvm_ptdump.h>
>  
>  
> +#define ADDR_MARKER_LEN		(2)
> +#define MARKER_MSG_LEN		(32)
> +
> +static const struct prot_bits stage2_pte_bits[] = {
> +	{
> +		.mask	= PTE_VALID,
> +		.val	= PTE_VALID,
> +		.set	= " ",
> +		.clear	= "F",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> +		.set	= "XN",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> +		.set	= "R",
> +		.clear	= " ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> +		.set	= "W",
> +		.clear	= " ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> +		.set	= "AF",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= PTE_NG,
> +		.val	= PTE_NG,
> +		.set	= "FnXS",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= PTE_CONT | PTE_VALID,
> +		.val	= PTE_CONT | PTE_VALID,
> +		.set	= "CON",
> +		.clear	= "   ",
> +	}, {
> +		.mask	= PTE_TABLE_BIT,
> +		.val	= PTE_TABLE_BIT,
> +		.set	= "   ",
> +		.clear	= "BLK",

<snip>

> +	}, {
> +		.mask	= KVM_PGTABLE_PROT_SW0,
> +		.val	= KVM_PGTABLE_PROT_SW0,
> +		.set	= "SW0", /* PKVM_PAGE_SHARED_OWNED */
> +	}, {
> +		.mask   = KVM_PGTABLE_PROT_SW1,
> +		.val	= KVM_PGTABLE_PROT_SW1,
> +		.set	= "SW1", /* PKVM_PAGE_SHARED_BORROWED */
> +	}, {
> +		.mask	= KVM_PGTABLE_PROT_SW2,
> +		.val	= KVM_PGTABLE_PROT_SW2,
> +		.set	= "SW2",
> +	}, {
> +		.mask   = KVM_PGTABLE_PROT_SW3,
> +		.val	= KVM_PGTABLE_PROT_SW3,
> +		.set	= "SW3",
> +	},

</snip>

These bits are never set in a 'normal' stage-2 PTE, does it make sense
to carry descriptors for them here? In contexts where the SW bits are
used it might be more useful if the ptdump used the specific meaning of
the bit (e.g. OWNED, BORROWED, etc) instead of the generic SW%d.

That can all wait for when the pKVM bits come into play though.

> +};
> +
>  static int kvm_ptdump_guest_open(struct inode *inode, struct file *file);
>  static int kvm_ptdump_guest_show(struct seq_file *m, void *);
>  
> @@ -52,6 +115,94 @@ static int kvm_ptdump_show_common(struct seq_file *m,
>  	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
>  }
>  
> +static void kvm_ptdump_build_levels(struct pg_level *level, u32 start_lvl)
> +{
> +	static const char * const level_names[] = {"PGD", "PUD", "PMD", "PTE"};
> +	u32 i = 0;
> +	u64 mask_lvl = 0;

nit: _lvl adds nothing to this, and actually confused me for a sec as
to whether the mask changed per level.

> +	if (start_lvl > 2) {
> +		pr_err("invalid start_lvl %u\n", start_lvl);
> +		return;
> +	}

Can't we get something like -EINVAL out here and fail initialization?
Otherwise breadcrumbs like this pr_err() are hard to connect to a
specific failure.

> +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> +		mask_lvl |= stage2_pte_bits[i].mask;
> +
> +	for (i = start_lvl; i <= KVM_PGTABLE_LAST_LEVEL; i++) {
> +		level[i].name = level_names[i];
> +		level[i].num = ARRAY_SIZE(stage2_pte_bits);
> +		level[i].bits = stage2_pte_bits;
> +		level[i].mask = mask_lvl;
> +	}
> +
> +	if (start_lvl > 0)
> +		level[start_lvl].name = level_names[0];
> +}
> +
> +static int kvm_ptdump_parser_init(struct pg_state *st,
> +				  struct kvm_pgtable *pgtable,
> +				  struct seq_file *m)
> +{
> +	struct addr_marker *ipa_addr_marker;
> +	char *marker_msg;
> +	struct pg_level *level_descr;
> +	struct ptdump_range *range;
> +
> +	ipa_addr_marker = kzalloc(sizeof(struct addr_marker) * ADDR_MARKER_LEN,
> +				  GFP_KERNEL_ACCOUNT);
> +	if (!ipa_addr_marker)
> +		return -ENOMEM;
> +
> +	marker_msg = kzalloc(MARKER_MSG_LEN, GFP_KERNEL_ACCOUNT);
> +	if (!marker_msg)
> +		goto free_with_marker;
> +
> +	level_descr = kzalloc(sizeof(struct pg_level) * (KVM_PGTABLE_LAST_LEVEL + 1),
> +			      GFP_KERNEL_ACCOUNT);
> +	if (!level_descr)
> +		goto free_with_msg;
> +
> +	range = kzalloc(sizeof(struct ptdump_range) * ADDR_MARKER_LEN,
> +			GFP_KERNEL_ACCOUNT);
> +	if (!range)
> +		goto free_with_level;
> +
> +	kvm_ptdump_build_levels(level_descr, pgtable->start_level);
> +
> +	snprintf(marker_msg, MARKER_MSG_LEN, "IPA bits %2u start lvl %1d",
> +		 pgtable->ia_bits, pgtable->start_level);
> +
> +	ipa_addr_marker[0].name = marker_msg;

Is the dynamic name worth the added complexity? I see nothing wrong with
exposing additional debugfs files for simple attributes like the IPA
range and page table levels.

I know it isn't *that* much, just looking for every opportunity to
simplify further.

> +	ipa_addr_marker[1].start_address = BIT(pgtable->ia_bits);
> +	range[0].end = BIT(pgtable->ia_bits);
> +
> +	st->seq = m;
> +	st->marker = ipa_addr_marker;
> +	st->level = -1,
> +	st->pg_level = level_descr,
> +	st->ptdump.range = range;
> +	return 0;
> +
> +free_with_level:
> +	kfree(level_descr);
> +free_with_msg:
> +	kfree(marker_msg);
> +free_with_marker:
> +	kfree(ipa_addr_marker);
> +	return -ENOMEM;
> +}
> +
> +static void kvm_ptdump_parser_teardown(struct pg_state *st)
> +{
> +	const struct addr_marker *ipa_addr_marker = st->marker;
> +
> +	kfree(ipa_addr_marker[0].name);
> +	kfree(ipa_addr_marker);
> +	kfree(st->pg_level);
> +	kfree(st->ptdump.range);
> +}
> +
>  static int kvm_ptdump_guest_show(struct seq_file *m, void *)
>  {
>  	struct kvm *guest_kvm = m->private;
> @@ -59,10 +210,15 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *)
>  	struct pg_state parser_state = {0};
>  	int ret;
>  
> +	ret = kvm_ptdump_parser_init(&parser_state, mmu->pgt, m);
> +	if (ret)
> +		return ret;
> +

Can this be done at open(), or am I missing something?

>  	write_lock(&guest_kvm->mmu_lock);
>  	ret = kvm_ptdump_show_common(m, mmu->pgt, &parser_state);
>  	write_unlock(&guest_kvm->mmu_lock);
>  
> +	kvm_ptdump_parser_teardown(&parser_state);

Same question here, can this happen at close()? I guess you'll need a
struct to encapsulate pg_state and a pointer to the VM at least.

Actually, come to think of it, if you embed all of the data you need for
the walker into a structure you can just do a single allocation for it
upfront.

-- 
Thanks,
Oliver
