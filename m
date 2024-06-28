Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB5768EC
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719609507; cv=none; b=DbY8+Ya0jjNzFKrUoM7BbXmQuqJQBDnvQNSPnppWp0HxkWp7y2RsjjiJ8J+/WFyCKWza2MhX1sDfwYYK62MGoZ+7E/dE4ryRGAUKPmya/5dxh23xHNZKoBwTgTR5jjGiuwawLCDFfCmlO6q64icr3qRmtgInr3NKPLUY5HjX51c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719609507; c=relaxed/simple;
	bh=BoFZDuqPzGP40r4KEUuGHvfn6bb2wtaddf0wdcA3lzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTtTt90LG2UAnjZhJumtL4dKIh1HprsDetkciP8LmTxcDghQ5/C3o4+q27tKFceSvS7pEmQPKqm5fdp/m1SVhTCZ6q3mHnACM9qWF5UShVsd9P2t8SeZ8GA2vM8dmFTna7N2aXa2TBzHK3iguqaI6Fol8LggpVpCfbfvJWPzX0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YVmM27N0; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YVmM27N0"
X-Envelope-To: sebastianene@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719609503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLFP/6n6TmQFjaJH2t9PIEjVSqPuh54BsTLyCUC8RSI=;
	b=YVmM27N0679cDACz5KF6MA8iFPbbDxxnz/WCFjirVh5/zUhCa9y9hhyCJkhv0aHLRtdfOm
	Pp2Aa2N/di7yC62YGCgTIABkcS0wCBsjouiG9qaP9iPZjBuJcb3qFtzE0YogBYJLdcEAcA
	uV4dwgERknKjnetYQlbk1QX+YEVdoDo=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: alexghiti@rivosinc.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: ardb@kernel.org
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: christophe.leroy@csgroup.eu
X-Envelope-To: james.morse@arm.com
X-Envelope-To: vdonnefort@google.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: kernel-team@android.com
Date: Fri, 28 Jun 2024 21:18:16 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <Zn8omLmCSIHun1uq@linux.dev>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621123230.1085265-6-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Seb,

On Fri, Jun 21, 2024 at 12:32:29PM +0000, Sebastian Ene wrote:
> Define a set of attributes used by the ptdump parser to display the
> properties of a guest memory region covered by a pagetable descriptor.
> Build a description of the pagetable levels and initialize the parser
> with this configuration.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

This patch should come *before* patch 4, no point in exposing the
debugfs file if we aren't ready to handle it yet.

> ---
>  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 137 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 36dc7662729f..cc1d4fdddc6e 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -14,6 +14,61 @@
>  #include <kvm_ptdump.h>
>  
>  
> +#define MARKERS_LEN		(2)
> +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> +
> +struct kvm_ptdump_guest_state {
> +	struct kvm		*kvm;
> +	struct pg_state		parser_state;
> +	struct addr_marker	ipa_marker[MARKERS_LEN];
> +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> +	struct ptdump_range	range[MARKERS_LEN];
> +};
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

<snip>

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

</snip>

Neither of these bits are used at stage-2, why have descriptors for
them?

> +static int kvm_ptdump_build_levels(struct pg_level *level, u32 start_lvl)
> +{
> +	static const char * const level_names[] = {"PGD", "PUD", "PMD", "PTE"};
> +	u32 i = 0;
> +	u64 mask = 0;
> +
> +	if (start_lvl > 2) {
> +		pr_err("invalid start_lvl %u\n", start_lvl);
> +		return -EINVAL;
> +	}

	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
		return -EINVAL;

> +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> +		mask |= stage2_pte_bits[i].mask;
> +
> +	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> +		strscpy(level[i].name, level_names[i], sizeof(level[i].name));
> +
> +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> +		level[i].bits	= stage2_pte_bits;
> +		level[i].mask	= mask;
> +	}
> +
> +	if (start_lvl > 0)
> +		strscpy(level[start_lvl].name, level_names[0], sizeof(level_names[0]));

This should pass the size of @dst, not the source. This becomes slightly
more self-documenting if you use a literal for "PGD" here too.

		strscpy(level[start_lvl].name, "PGD", sizeof(level[start_lvl].name));

> +	return 0;
> +}
> +
> +static struct kvm_ptdump_guest_state
> +*kvm_ptdump_parser_init(struct kvm *kvm)
> +{
> +	struct kvm_ptdump_guest_state *st;
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> +	struct kvm_pgtable *pgtable = mmu->pgt;
> +	int ret;
> +
> +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> +	if (!st)
> +		return NULL;
> +
> +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> +	if (ret)
> +		goto free_with_state;

I don't see any value in the use of goto here, as there isn't any sort
of cascading initialization / cleanup. This also presents an opportunity
to get an error back out to the caller.

	if (ret) {
		kfree(st);
		return ERR_PTR(ret);
	}

> @@ -57,22 +176,34 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
>  {
>  	struct kvm *kvm = m->i_private;
> +	struct kvm_ptdump_guest_state *st;
>  	int ret;
>  
>  	if (!kvm_get_kvm_safe(kvm))
>  		return -ENOENT;
>  
> -	ret = single_open(file, kvm_ptdump_guest_show, m->i_private);
> -	if (ret < 0)
> -		kvm_put_kvm(kvm);
> +	st = kvm_ptdump_parser_init(kvm);
> +	if (!st) {
> +		ret = -ENOMEM;
> +		goto free_with_kvm_ref;
> +	}

(with the earlier suggestion)

	st = kvm_ptdump_parser_init(kvm);
	if (IS_ERR(st)) {
		ret = PTR_ERR(st);
		goto free_with_kvm_ref;
	}

Otherwise genuine KVM bugs (-EINVAL) are getting lumped into ENOMEM.

-- 
Thanks,
Oliver
