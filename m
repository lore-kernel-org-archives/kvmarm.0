Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8597195
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 05:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725255098; cv=none; b=Q94Z2C65DHhJ+dBLVo+ichmP6yvgr9CE1yCx86O1AgpvHDVtC98GfETNeJuLkO3MYShejwmT03Op81jjGhzgzcVQiGwjDZUbmlp1nzqedWt+V/CG1UpyXw1oT6YGCFpmbuXJoB2y0LtKcxRj+Ygq/K1eNUqOjv5BBrmU6vF+qyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725255098; c=relaxed/simple;
	bh=6LFcuXz5you6xwxRQu1dTiocaGIf4Nal44ToUiNwv9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG5Kt7rjRPYN8pskml2mVHXmffjjVZcW0IGQJG+zcPpzOwJGUV9bImEvloT7S3sfCPMEj08Mj+tS3XceqmtU401ppPQQRuXrXq1BxivhZi0JO+OQ/ogR0kHuUBZwO15yzkUmJBCwkO6X0GLPainfkZsh8Wm1rB0o4rJ0FhJpvP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WzrqPYpT; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WzrqPYpT"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso53935e9.0
        for <kvmarm@lists.linux.dev>; Sun, 01 Sep 2024 22:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725255094; x=1725859894; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fuP3sA2mHPQmE8xDQ8PnCtcPNlxmhvMJ+f3RT1WsH/o=;
        b=WzrqPYpTj6gJNKsimexTebIkJy+dr1h0t1bHoMG3HhyxH3iAjL1K+dW6JEUpX6MlC6
         77LLLZSmuCLzA8VRKrc+V1MKho6uZI5GYiN2mNuuHh3neDlx9NtqTS/itm3cLtWvhBK4
         fo+eCDrDa451H4kBAAI7lHi5ZK4mHij+o4uGQasElGUj2SfgcUYtSiPC0q9eyWBSsfL8
         bxKGbZtLeSk0OFKhCsw5i9hZ2OxFXg+rALjlCY1FETV2dAKjbZaOfotjh0zbL5Nb94Ad
         t8IACFNy6law/OcUezl8XpdnWJkFBh99eEiiKn1jX4WAJ/2vPdg/3jQOUfPxq7SkKgmr
         QILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725255094; x=1725859894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuP3sA2mHPQmE8xDQ8PnCtcPNlxmhvMJ+f3RT1WsH/o=;
        b=boqdf5PZL1o7D2yOXHmTTxJgywLTEIYYOOdH/pFUF6r8/hGhg5QBRP22FCYeO9wKSs
         6I2giurUTmXziQVt1Qohaeel8cYvF/aDvoXgWAu8LGk8BtZtFHPPwP0uUv6q1VIcUk+1
         qcrhxu431LEqCwxJgbv7trHQyrz9kV2YX63hdSJIhzmIkaaWYHsLPhTxINQZGckJ3/0i
         TrHFii3WyZT/qytqScm/m9Xtp7Fk008qsviMyDSCWH6waYZTNWe+gkzYXH9uN0BOrl+G
         KshTPpA6fKSbbFYBUE99K4PdRAKK9S4QKoLsZDV7DL5K2vrFgvAL/GQP8dAGpftlwg1U
         d6Dw==
X-Forwarded-Encrypted: i=1; AJvYcCU58zxsHcey8OE2v6Gn4a+gePMj3XbA601Sld04LkOnQUXO/6czLhwgV20FtN5LxZtHxND64kA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+lAFfdEwJDvdgYgoh6K62ehuRDwFRYlR4wcMgq8dmD/fdigd1
	Euf613kiAF66sJCT10JYtrgTZ13KHe/X06c9nQKHNL3oMupuZTS+7VpwQJJrcw==
X-Google-Smtp-Source: AGHT+IEGuvxrZ87Ft8qzSNqILyBxB6gaWy1w3BABLr19h8u2JyTxmmBciKGdpCbbGgRt+NhZaw3o9A==
X-Received: by 2002:a05:600c:4e4f:b0:42b:a04f:6eca with SMTP id 5b1f17b1804b1-42c3940e1e7mr1952785e9.6.1725255093565;
        Sun, 01 Sep 2024 22:31:33 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374badc581csm6450421f8f.0.2024.09.01.22.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 22:31:33 -0700 (PDT)
Date: Mon, 2 Sep 2024 05:31:31 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 4/5] KVM: arm64: Register ptdump with debugfs on guest
 creation
Message-ID: <ZtVNs_pzsbYIWr4l@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-5-sebastianene@google.com>
 <ZtGd9UEudn8Z0IlG@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtGd9UEudn8Z0IlG@google.com>

On Fri, Aug 30, 2024 at 11:24:53AM +0100, Vincent Donnefort wrote:
> Hi Seb,
> 
> Thanks for the respin.
> 
> On Tue, Aug 27, 2024 at 08:45:47AM +0000, Sebastian Ene wrote:
> > While arch/*/mem/ptdump handles the kernel pagetable dumping code,
> > introduce KVM/ptdump to show the guest stage-2 pagetables. The
> > separation is necessary because most of the definitions from the
> > stage-2 pagetable reside in the KVM path and we will be invoking
> > functionality specific to KVM.
> > 
> > When a guest is created, register a new file entry under the guest
> > debugfs dir which allows userspace to show the contents of the guest
> > stage-2 pagetables when accessed.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> 
> I only have some nits, otherwise:

Hello Vincent,

> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> 

Thanks for giving me consistent feedback on the series. I will
incorporate your latest suggestions in my patch series and add the tag.

> > ---
> >  arch/arm64/include/asm/kvm_host.h |   6 +
> >  arch/arm64/kvm/Makefile           |   1 +
> >  arch/arm64/kvm/arm.c              |   1 +
> >  arch/arm64/kvm/ptdump.c           | 247 ++++++++++++++++++++++++++++++
> >  4 files changed, 255 insertions(+)
> >  create mode 100644 arch/arm64/kvm/ptdump.c
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a33f5996ca9f..4acd589f086b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1473,4 +1473,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
> >  		(pa + pi + pa3) == 1;					\
> >  	})
> >  
> > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > +void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> > +#else
> > +static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> > +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 86a629aaf0a1..e4233b323a73 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -27,6 +27,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> >  
> >  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> >  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> > +kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
> >  
> >  always-y := hyp_constants.h hyp-constants.s
> >  
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9bef7638342e..b9fd928d3477 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -228,6 +228,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> >  void kvm_arch_create_vm_debugfs(struct kvm *kvm)
> >  {
> >  	kvm_sys_regs_create_debugfs(kvm);
> > +	kvm_s2_ptdump_create_debugfs(kvm);
> >  }
> >  
> >  static void kvm_destroy_mpidr_data(struct kvm *kvm)
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > new file mode 100644
> > index 000000000000..e72a928d4445
> > --- /dev/null
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -0,0 +1,247 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Debug helper used to dump the stage-2 pagetables of the system and their
> > + * associated permissions.
> > + *
> > + * Copyright (C) Google, 2024
> > + * Author: Sebastian Ene <sebastianene@google.com>
> > + */
> > +#include <linux/debugfs.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/seq_file.h>
> > +
> > +#include <asm/kvm_pgtable.h>
> > +#include <asm/kvm_host.h>
> 
> nit: I believe you wanted to follow the alphabetical order, if that is the case,
> kvm_host.h then kvm_pgtable.h
> 
> > +#include <asm/ptdump.h>
> > +
> > +
> 
> nit: don't think double empty are a rule, I would remove it.
> 

Ack.

> > +#define MARKERS_LEN		(2)
> 
> nit: The brackets are not necessary for MARKERS_LEN.
> 
> > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > +
> > +struct kvm_ptdump_guest_state {
> > +	struct kvm		*kvm;
> > +	struct ptdump_pg_state	parser_state;
> > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > +	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
> > +	struct ptdump_range	range[MARKERS_LEN];
> > +};
> > +
> > +static const struct ptdump_prot_bits stage2_pte_bits[] = {
> > +	{
> > +		.mask	= PTE_VALID,
> > +		.val	= PTE_VALID,
> > +		.set	= " ",
> > +		.clear	= "F",
> 
> This is effectively never used because an invalid PTE is 0 and note_page() won't
> print it. This probably can be removed?
> 

Please see my previous reply to this. I would keep it around as it
should print out non-zero invalid PTEs.

> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > +		.set	= "R",
> > +		.clear	= " ",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > +		.set	= "W",
> > +		.clear	= " ",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > +		.val	= PTE_VALID,
> > +		.set	= " ",
> > +		.clear	= "X",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > +		.set	= "AF",
> > +		.clear	= "  ",
> > +	}, {
> > +		.mask	= PTE_TABLE_BIT | PTE_VALID,
> > +		.val	= PTE_VALID,
> > +		.set	= "BLK",
> > +		.clear	= "   ",
> > +	},
> > +};
> > +
> > +static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> > +			      enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct ptdump_pg_state *st = ctx->arg;
> > +	struct ptdump_state *pt_st = &st->ptdump;
> > +
> > +	note_page(pt_st, ctx->addr, ctx->level, ctx->old);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> > +{
> > +	u32 i;
> > +	u64 mask;
> > +
> > +	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
> > +		return -EINVAL;
> > +
> > +	mask = 0;
> > +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> > +		mask |= stage2_pte_bits[i].mask;
> > +
> > +	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> > +		snprintf(level[i].name, sizeof(level[i].name), "%d", i);
> 
> %u, i being unsigned.

Ack.

> 
> > +
> > +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> > +		level[i].bits	= stage2_pte_bits;
> > +		level[i].mask	= mask;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
> > +{
> > +	struct kvm_ptdump_guest_state *st;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +	struct kvm_pgtable *pgtable = mmu->pgt;
> > +	int ret;
> > +
> > +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> > +	if (!st)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> > +	if (ret) {
> > +		kfree(st);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	st->ipa_marker[0].name		= "Guest IPA";
> > +	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> > +	st->range[0].end		= BIT(pgtable->ia_bits);
> > +
> > +	st->kvm				= kvm;
> > +	st->parser_state = (struct ptdump_pg_state) {
> > +		.marker		= &st->ipa_marker[0],
> > +		.level		= -1,
> > +		.pg_level	= &st->level[0],
> > +		.ptdump.range	= &st->range[0],
> > +		.start_address	= 0,
> > +	};
> > +
> > +	return st;
> > +}
> > +
> > +static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> > +{
> > +	int ret;
> > +	struct kvm_ptdump_guest_state *st = m->private;
> > +	struct kvm *kvm = st->kvm;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +	struct ptdump_pg_state *parser_state = &st->parser_state;
> > +	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
> > +		.cb	= kvm_ptdump_visitor,
> > +		.arg	= parser_state,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +	};
> > +
> > +	parser_state->seq = m;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > +	write_unlock(&kvm->mmu_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > +{
> > +	struct kvm *kvm = m->i_private;
> > +	struct kvm_ptdump_guest_state *st;
> > +	int ret;
> > +
> > +	if (!kvm_get_kvm_safe(kvm))
> > +		return -ENOENT;
> > +
> > +	st = kvm_ptdump_parser_create(kvm);
> > +	if (IS_ERR(st)) {
> > +		ret = PTR_ERR(st);
> > +		goto free_with_kvm_ref;
> > +	}
> > +
> > +	ret = single_open(file, kvm_ptdump_guest_show, st);
> > +	if (!ret)
> > +		return 0;
> > +
> > +	kfree(st);
> > +free_with_kvm_ref:
> 
> nit: I believe kfree understands IS_ERR() so you could have a simple "err:"
> label covering all the error path.
> 
> > +	kvm_put_kvm(kvm);
> > +	return ret;
> > +}
> > +
> > +static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
> > +{
> > +	struct kvm *kvm = m->i_private;
> > +	void *st = ((struct seq_file *)file->private_data)->private;
> > +
> > +	kfree(st);
> > +	kvm_put_kvm(kvm);
> > +
> > +	return single_release(m, file);
> > +}
> > +
> > +static const struct file_operations kvm_ptdump_guest_fops = {
> > +	.open		= kvm_ptdump_guest_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= kvm_ptdump_guest_close,
> > +};
> > +
> > +static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
> > +{
> > +	const struct file *file = m->file;
> > +	struct kvm_pgtable *pgtable = m->private;
> > +
> > +	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
> > +		seq_printf(m, "%2u\n", pgtable->ia_bits);
> > +	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
> > +		seq_printf(m, "%1d\n", KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
> 
> nit: KVM_PGTABLE_MAX_LEVELS - pgtable->start_level ?

Yes, we can use this one.

> 
> > +	return 0;
> > +}
> > +
> > +static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
> > +{
> > +	struct kvm *kvm = m->i_private;
> > +	struct kvm_pgtable *pgtable;
> > +	int ret;
> > +
> > +	if (!kvm_get_kvm_safe(kvm))
> > +		return -ENOENT;
> > +
> > +	pgtable = kvm->arch.mmu.pgt;
> > +
> > +	ret = single_open(file, kvm_pgtable_debugfs_show, pgtable);
> > +	if (ret < 0)
> > +		kvm_put_kvm(kvm);
> > +	return ret;
> > +}
> > +
> > +static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
> > +{
> > +	struct kvm *kvm = m->i_private;
> > +
> > +	kvm_put_kvm(kvm);
> > +	return single_release(m, file);
> > +}
> > +
> > +static const struct file_operations kvm_pgtable_debugfs_fops = {
> > +	.open		= kvm_pgtable_debugfs_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= kvm_pgtable_debugfs_close,
> > +};
> > +
> > +void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
> > +{
> > +	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> > +			    kvm, &kvm_ptdump_guest_fops);
> > +	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
> > +			    &kvm_pgtable_debugfs_fops);
> > +	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
> > +			    kvm, &kvm_pgtable_debugfs_fops);
> > +}
> > -- 
> > 2.46.0.295.g3b9ea8a38a-goog
> > 
