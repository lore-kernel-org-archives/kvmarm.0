Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CE114AD19
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708615169; cv=none; b=GeFLZ7Ietc6wIobdQ3qB7SYemXv3vbiv4t2Mjkoiis5Fm9gW7+OsXDwCoe6Ko68X2310aZUeWaznWpvoaXz/JtG+jpnEvKWPSueOig2FC2QAZunFlw/VKwsnG+3wjdrPhCftWlcD8Lmt5sce5poheeXDpsSFMcmDnP9ICjjM3hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708615169; c=relaxed/simple;
	bh=BJue+4GJSqk5WpSNMGudyhvHONZNOvQkW6x7cgxI604=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVX7QZRsV4uHqVWC11ESJmn+cNI3ahWNURGK71KsfxJUMPA062blPjUw2gghotzag3Oy8ndGF+VofFqK7AgduNDIfy/la5ZsJDuJC3WcA7kxj+zz5mCnNQcvHXpcJ2gtYnQaUC2lsGrA9u+h9tcIn1nzOgwYAUAknBx0P1Xzs/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1H7xZPNa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1H7xZPNa"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4120933b710so61905e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708615166; x=1709219966; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wylv6vXEtUdi6Bcb5avU2yV6NCNR7pjMD098XS01Joc=;
        b=1H7xZPNaOVhgYBiMabvSBCb20F8eZIi/xvkYlfDtiwwZQKaoqx6aQSTSAZjEXm4Yn5
         plh+1e6ZXXNEqQ5jH2wWb51KmYHqTZTexFSdcFC9oO/Nj0nVO8zN+DCNkfbaVuOlzHxm
         5WuT0sKzh4bHZL7YlT2CF7ACyKc9MvPZFqXKvZThuf7UmiRBCRVF6ZZzO7ivIidGM83m
         vLvKpCXYQZX9sao44t+xpSLPGlBFla1n32zu4Z88oGRA81Yu/jt4v1GmZlME3jQ+hXCv
         EkEbDwNkrylko0Srl4vagm22LGGC2umxMSSw3UnPI+VBPNbmnhrvqHThHVU+0IXl+DLu
         28tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708615166; x=1709219966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wylv6vXEtUdi6Bcb5avU2yV6NCNR7pjMD098XS01Joc=;
        b=mkxOFyb9oCKiTLEiVIOtePjEcqwUnvAkqEQfrgC75aC2HuYHP4yS/NS5Qhp2xnqFpN
         Z4roC1rm/rr/Y20+2RyhcQf0bj3fldAtw13HwFwp5UXSI54XR7Dz1JWWRTKRtnAvsBGD
         1zWASqOXCiz/7666POBlmOm1/TvRFCIB/ia3NPvOli4zLJVi4ZjVKeJ95DX4Od0ThAhF
         8ioPaVLbvUSWx1KFN9N65/so+RQj3TX+TR0L3HJw3u5AR8uD17PR9S5v3jAupBqeG/Ll
         u7oOfBGzPkKgkZBALUfAn9QWcbQWnJ0zRkHqRXe9wrRut7CQgaZcZg8dQ1S9GzPPUOOM
         7J4g==
X-Gm-Message-State: AOJu0Yxr7CVxySbt7b46cKQjMw/ed4YOepLbOl6KENYGFWTAmGBtcd22
	C38u9lJPh+ES6zvn7gM3oW+PTqj+2M+QMqwHXX3esZiD96N/7c3QPTDiQ3GtIw==
X-Google-Smtp-Source: AGHT+IFAAaTEm3lXZegn3XxVb3u12ViYu3B/HVTEqaxNxbW8lSDpmbQNkCKoWLXbfgIjLhjZ5xHhGw==
X-Received: by 2002:a05:600c:a017:b0:412:5616:d3d with SMTP id jg23-20020a05600ca01700b0041256160d3dmr385275wmb.7.1708615165506;
        Thu, 22 Feb 2024 07:19:25 -0800 (PST)
Received: from google.com (161.126.77.34.bc.googleusercontent.com. [34.77.126.161])
        by smtp.gmail.com with ESMTPSA id q4-20020adfab04000000b0033cf637eea2sm20823457wrc.29.2024.02.22.07.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 07:19:24 -0800 (PST)
Date: Thu, 22 Feb 2024 15:19:23 +0000
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org,
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com
Subject: Re: [PATCH v6 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <Zddl-_Em-pFteJXW@google.com>
References: <20240220151035.327199-1-sebastianene@google.com>
 <20240220151035.327199-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220151035.327199-6-sebastianene@google.com>

On Tue, Feb 20, 2024 at 03:10:34PM +0000, Sebastian Ene wrote:
> Define a set of attributes used by the ptdump parser to display the
> properties of a guest memory region covered by a pagetable descriptor.
> Build a description of the pagetable levels and initialize the parser
> with this configuration.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/ptdump.c | 146 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 139 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 9b04c24bb9be..2c4e0c122d23 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -14,6 +14,61 @@
>  #include <kvm_ptdump.h>
>  
>  
> +#define MARKERS_LEN		(2)
> +#define KVM_PGTABLE_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> +
> +struct kvm_ptdump_guest_state {
> +	struct kvm		*kvm;
> +	struct pg_state		parser_state;
> +	struct addr_marker	ipa_marker[MARKERS_LEN];
> +	struct pg_level		level[KVM_PGTABLE_LEVELS];
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
> +	},
> +};
> +
>  static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
>  			      enum kvm_pgtable_walk_flags visit)
>  {
> @@ -37,15 +92,78 @@ static int kvm_ptdump_show_common(struct seq_file *m,
>  	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
>  }
>  
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
> +
> +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> +		mask |= stage2_pte_bits[i].mask;
> +
> +	for (i = start_lvl; i <= KVM_PGTABLE_LAST_LEVEL; i++) {
> +		level[i].name	= level_names[i];
> +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> +		level[i].bits	= stage2_pte_bits;
> +		level[i].mask	= mask;
> +	}
> +
> +	if (start_lvl > 0)
> +		level[start_lvl].name = level_names[0];
> +
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
> +
> +	st->ipa_marker[0].name		= "Guest IPA";
> +	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> +	st->range[0].end		= BIT(pgtable->ia_bits);
> +
> +	st->kvm				= kvm;
> +	st->parser_state = (struct pg_state) {
> +		.marker		= &st->ipa_marker[0],
> +		.level		= -1,
> +		.pg_level	= &st->level[0],
> +		.ptdump.range	= &st->range[0],
> +	};
> +
> +	return st;
> +free_with_state:
> +	kfree(st);
> +	return NULL;
> +}
> +
>  static int kvm_ptdump_guest_show(struct seq_file *m, void *)
>  {
> -	struct kvm *kvm = m->private;
> +	struct kvm_ptdump_guest_state *st = m->private;
> +	struct kvm *kvm = st->kvm;
>  	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> -	struct pg_state parser_state = {0};
>  	int ret;
>  
> +	st->parser_state.seq = m;
> +
>  	write_lock(&kvm->mmu_lock);
> -	ret = kvm_ptdump_show_common(m, mmu->pgt, &parser_state);
> +	ret = kvm_ptdump_show_common(m, mmu->pgt, &st->parser_state);
>  	write_unlock(&kvm->mmu_lock);
>  
>  	return ret;
> @@ -54,22 +172,36 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *)
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
>  {
>  	struct kvm *kvm = m->i_private;
> +	struct kvm_ptdump_guest_state *st;
>  	int ret;
>  
> -	if (!kvm_get_kvm_safe(kvm))
> -		return -ENOENT;

FIXME: Keep kvm_get_kvm_safe before invoking kvm_ptdump_parser_init to
avoid UAF if kvm gets destroyed.

> +	st = kvm_ptdump_parser_init(kvm);
> +	if (!st)
> +		return -ENOMEM;
>  
> -	ret = single_open(file, kvm_ptdump_guest_show, m->i_private);
> +	if (!kvm_get_kvm_safe(kvm)) {
> +		ret = -ENOENT;
> +		goto free_with_state;
> +	}
> +
> +	ret = single_open(file, kvm_ptdump_guest_show, st);
>  	if (ret < 0)
> -		kvm_put_kvm(kvm);
> +		goto free_with_kvm_ref;
>  
>  	return ret;
> +free_with_kvm_ref:
> +	kvm_put_kvm(kvm);
> +free_with_state:
> +	kfree(st);
> +	return ret;
>  }
>  
>  static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
>  {
>  	struct kvm *kvm = m->i_private;
> +	void *st = ((struct seq_file *)file->private_data)->private;
>  
> +	kfree(st);
>  	kvm_put_kvm(kvm);
>  	return single_release(m, file);
>  }
> -- 
> 2.44.0.rc0.258.g7320e95886-goog
> 
