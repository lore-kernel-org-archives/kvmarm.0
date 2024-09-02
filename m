Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C9A149E03
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 05:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725254840; cv=none; b=Lh0wMoUm6Vv4Nog3co2ctO1p3FqndfFs306EcI9jQloUMQllqetm8lU4/NQyXGcK3+DHo0PiW2QhHUyuxmksj1OqloSSOklXCZ/gd82AMDScHzVHUjDeKvNDFGWhH6ON/ULQnXaCx1pKmULPVqZpMDxeEwMpG+mc8PdLgEiguFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725254840; c=relaxed/simple;
	bh=mOalP1s06ufDZDNa7UKPXhpI7xGisBVPErXcnRpqtsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoITsKYfyCxhxhQFM0XtUsdbG0pIzIJJeoTXX8qTDw72wxoVVPyOdXNV3jlUJHBGQMzk2TiDC16g/FFNHWQIBOubvI//p6Q1DKkGn9WGTd0CySkzHTTDjjY9aMH1MBd/5ILbyVR9BnBfoB+2MldABX4VbA7NAqIQYaF3e4xMa9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b2TeinN4; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b2TeinN4"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso53765e9.0
        for <kvmarm@lists.linux.dev>; Sun, 01 Sep 2024 22:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725254837; x=1725859637; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPAZWrmrGqYJRTALvwCP6O+jbuAqmwxij0yx0v1S6JA=;
        b=b2TeinN4n4zgT1/60v1J6nj9efd4uHov3pxgP4YHlctKEO4ejSxwkFN3xQpYVJV4Dh
         BvcU4V7PWQ5Dzzx7vGo6wQhRjuEGgVanyxz5xVLAqZTl5ofcHYt0Fn6b7zwGhMgsCRue
         AMiZvlm+MDumh3lXgtakwRmRjUGZQENf0+8xuSpOOZZ4vdq/Zbx3WnqUb6om1dPUZQIr
         wtog/T2EKGGJu+glX44tPhGbGs7WmCUt/EZ/6LPi+M/wRQpAd5xAAAXg5gnJbO+sADvC
         J3e0xEPHuqBL1RE8ZGUihjbeHhtzv58BzZ2voJ8N3VLQViIenYhSUxQt3C5ACQOzP8Au
         VsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725254837; x=1725859637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPAZWrmrGqYJRTALvwCP6O+jbuAqmwxij0yx0v1S6JA=;
        b=cLMi5U1vd2wlQzf/PMy6t0rxmNeeBG+p6SyfTJbsVRLamWiZE3+xOoVQE4r5hd08h6
         zfypZ11GGJacR/oUpFvmd+xkEL26OiLxbcbxeJsljc0s8gzVIeuyninKG7z/tnrEvr/a
         gxUTqTt07FfUIJ8Tuoyi2Euh77o0BHXvq5gqISCjSsKdGdxAurlJcSuqMHOl8wfyfS+e
         ZMdxM/TUIP9+kwd/uNnrVExOjEz/oWiOp47luxIB/fC7laHXIhV6oEX9kygFam7E+uwe
         IgxswW9PTsvwuoqN5JwBsF3eqKHgZ1gdp9/Dh1RgtimKT164J/XCiLYhFJWg3SOYBRKF
         QrTw==
X-Forwarded-Encrypted: i=1; AJvYcCUSF1nLcgAHhM9XjcqxtJIKCBHMcsbxVQzIcr0mDTNNhIrZsrHp0xw3vQud4u9Cr7EVa5dtrbw=@lists.linux.dev
X-Gm-Message-State: AOJu0YybOn3NvB1x6PlnIcocd95Vch/KqZCh/LHtC2T319LhKrobrLjO
	fZ1gEHLKX+7z1SyAj97TypTxDnQv3FKYxjO08nn1e5YoiUblaR+2mDaM62ljKQ==
X-Google-Smtp-Source: AGHT+IHdw/BqX+mHnD3hROHXMBRW98sj0O2ulUKzz3lT5C6YWUdAEOkOSSPxP6ksFN+3AYubbnEO3A==
X-Received: by 2002:a05:600c:c15:b0:42b:8ff7:9cfe with SMTP id 5b1f17b1804b1-42c787683a2mr1717805e9.1.1725254836304;
        Sun, 01 Sep 2024 22:27:16 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374b9859486sm7078112f8f.111.2024.09.01.22.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 22:27:15 -0700 (PDT)
Date: Mon, 2 Sep 2024 05:27:13 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, akpm@linux-foundation.org,
	alexghiti@rivosinc.com, ankita@nvidia.com, ardb@kernel.org,
	catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
	james.morse@arm.com, mark.rutland@arm.com, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 4/5] KVM: arm64: Register ptdump with debugfs on guest
 creation
Message-ID: <ZtVMsaEbgACLTBjM@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-5-sebastianene@google.com>
 <ZtGd9UEudn8Z0IlG@google.com>
 <865xriw161.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xriw161.wl-maz@kernel.org>

On Fri, Aug 30, 2024 at 03:11:34PM +0100, Marc Zyngier wrote:
> On Fri, 30 Aug 2024 11:24:53 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Hi Seb,
> > 
> > Thanks for the respin.
> > 
> > On Tue, Aug 27, 2024 at 08:45:47AM +0000, Sebastian Ene wrote:
> > > While arch/*/mem/ptdump handles the kernel pagetable dumping code,
> > > introduce KVM/ptdump to show the guest stage-2 pagetables. The
> > > separation is necessary because most of the definitions from the
> > > stage-2 pagetable reside in the KVM path and we will be invoking
> > > functionality specific to KVM.
> > > 
> > > When a guest is created, register a new file entry under the guest
> > > debugfs dir which allows userspace to show the contents of the guest
> > > stage-2 pagetables when accessed.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > 
> > I only have some nits, otherwise:
> > 
> > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |   6 +
> > >  arch/arm64/kvm/Makefile           |   1 +
> > >  arch/arm64/kvm/arm.c              |   1 +
> > >  arch/arm64/kvm/ptdump.c           | 247 ++++++++++++++++++++++++++++++
> > >  4 files changed, 255 insertions(+)
> > >  create mode 100644 arch/arm64/kvm/ptdump.c
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index a33f5996ca9f..4acd589f086b 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -1473,4 +1473,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
> > >  		(pa + pi + pa3) == 1;					\
> > >  	})
> > >  
> > > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > > +void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> > > +#else
> > > +static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> > > +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> > > +
> > >  #endif /* __ARM64_KVM_HOST_H__ */
> > > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > > index 86a629aaf0a1..e4233b323a73 100644
> > > --- a/arch/arm64/kvm/Makefile
> > > +++ b/arch/arm64/kvm/Makefile
> > > @@ -27,6 +27,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> > >  
> > >  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> > >  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> > > +kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
> > >  
> > >  always-y := hyp_constants.h hyp-constants.s
> > >  
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 9bef7638342e..b9fd928d3477 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -228,6 +228,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> > >  void kvm_arch_create_vm_debugfs(struct kvm *kvm)
> > >  {
> > >  	kvm_sys_regs_create_debugfs(kvm);
> > > +	kvm_s2_ptdump_create_debugfs(kvm);
> > >  }
> > >  
> > >  static void kvm_destroy_mpidr_data(struct kvm *kvm)
> > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > new file mode 100644
> > > index 000000000000..e72a928d4445
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/ptdump.c
> > > @@ -0,0 +1,247 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Debug helper used to dump the stage-2 pagetables of the system and their
> > > + * associated permissions.
> > > + *
> > > + * Copyright (C) Google, 2024
> > > + * Author: Sebastian Ene <sebastianene@google.com>
> > > + */
> > > +#include <linux/debugfs.h>
> > > +#include <linux/kvm_host.h>
> > > +#include <linux/seq_file.h>
> > > +
> > > +#include <asm/kvm_pgtable.h>
> > > +#include <asm/kvm_host.h>
> > 
> > nit: I believe you wanted to follow the alphabetical order, if that is the case,
> > kvm_host.h then kvm_pgtable.h
> > 
> > > +#include <asm/ptdump.h>
> > > +
> > > +
> > 
> > nit: don't think double empty are a rule, I would remove it.
> > 
> > > +#define MARKERS_LEN		(2)
> > 
> > nit: The brackets are not necessary for MARKERS_LEN.
> > 
> > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > +
> > > +struct kvm_ptdump_guest_state {
> > > +	struct kvm		*kvm;
> > > +	struct ptdump_pg_state	parser_state;
> > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > +	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
> > > +	struct ptdump_range	range[MARKERS_LEN];
> > > +};
> > > +
> > > +static const struct ptdump_prot_bits stage2_pte_bits[] = {
> > > +	{
> > > +		.mask	= PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= " ",
> > > +		.clear	= "F",
> > 
> > This is effectively never used because an invalid PTE is 0 and note_page() won't
> > print it. This probably can be removed?
> 
> Yeah, I can't see how we are going to trigger that one given that
> PTE_VALID must be set, and that we only print something if the bit is
> clear.
> 
> Seb?

When (pte_prot & mask == val) we print .set (which is empty), otherwise we
print .clear (This is from dump_prot). Invalid non-zero PTEs should be
printed in this case.

> 
> >
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.set	= "R",
> > > +		.clear	= " ",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > > +		.set	= "W",
> > > +		.clear	= " ",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= " ",
> > > +		.clear	= "X",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > +		.set	= "AF",
> > > +		.clear	= "  ",
> > > +	}, {
> > > +		.mask	= PTE_TABLE_BIT | PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= "BLK",
> > > +		.clear	= "   ",
> > > +	},
> > > +};
> > > +
> > > +static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> > > +			      enum kvm_pgtable_walk_flags visit)
> > > +{
> > > +	struct ptdump_pg_state *st = ctx->arg;
> > > +	struct ptdump_state *pt_st = &st->ptdump;
> > > +
> > > +	note_page(pt_st, ctx->addr, ctx->level, ctx->old);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> > > +{
> > > +	u32 i;
> > > +	u64 mask;
> > > +
> > > +	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
> > > +		return -EINVAL;
> > > +
> > > +	mask = 0;
> > > +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> > > +		mask |= stage2_pte_bits[i].mask;
> > > +
> > > +	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> > > +		snprintf(level[i].name, sizeof(level[i].name), "%d", i);
> > 
> > %u, i being unsigned.
> > 
> > > +
> > > +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> > > +		level[i].bits	= stage2_pte_bits;
> > > +		level[i].mask	= mask;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
> > > +{
> > > +	struct kvm_ptdump_guest_state *st;
> > > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > > +	struct kvm_pgtable *pgtable = mmu->pgt;
> > > +	int ret;
> > > +
> > > +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> > > +	if (!st)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> > > +	if (ret) {
> > > +		kfree(st);
> > > +		return ERR_PTR(ret);
> > > +	}
> > > +
> > > +	st->ipa_marker[0].name		= "Guest IPA";
> > > +	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> > > +	st->range[0].end		= BIT(pgtable->ia_bits);
> > > +
> > > +	st->kvm				= kvm;
> > > +	st->parser_state = (struct ptdump_pg_state) {
> > > +		.marker		= &st->ipa_marker[0],
> > > +		.level		= -1,
> > > +		.pg_level	= &st->level[0],
> > > +		.ptdump.range	= &st->range[0],
> > > +		.start_address	= 0,
> > > +	};
> > > +
> > > +	return st;
> > > +}
> > > +
> > > +static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> > > +{
> > > +	int ret;
> > > +	struct kvm_ptdump_guest_state *st = m->private;
> > > +	struct kvm *kvm = st->kvm;
> > > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > > +	struct ptdump_pg_state *parser_state = &st->parser_state;
> > > +	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
> > > +		.cb	= kvm_ptdump_visitor,
> > > +		.arg	= parser_state,
> > > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > > +	};
> > > +
> > > +	parser_state->seq = m;
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > > +	write_unlock(&kvm->mmu_lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > > +{
> > > +	struct kvm *kvm = m->i_private;
> > > +	struct kvm_ptdump_guest_state *st;
> > > +	int ret;
> > > +
> > > +	if (!kvm_get_kvm_safe(kvm))
> > > +		return -ENOENT;
> > > +
> > > +	st = kvm_ptdump_parser_create(kvm);
> > > +	if (IS_ERR(st)) {
> > > +		ret = PTR_ERR(st);
> > > +		goto free_with_kvm_ref;
> > > +	}
> > > +
> > > +	ret = single_open(file, kvm_ptdump_guest_show, st);
> > > +	if (!ret)
> > > +		return 0;
> > > +
> > > +	kfree(st);
> > > +free_with_kvm_ref:
> > 
> > nit: I believe kfree understands IS_ERR() so you could have a simple "err:"
> > label covering all the error path.
> 
> I couldn't find such handling in kfree(). Could you point be to it?
> 
> > 
> > > +	kvm_put_kvm(kvm);
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
> > > +{
> > > +	struct kvm *kvm = m->i_private;
> > > +	void *st = ((struct seq_file *)file->private_data)->private;
> > > +
> > > +	kfree(st);
> > > +	kvm_put_kvm(kvm);
> > > +
> > > +	return single_release(m, file);
> > > +}
> > > +
> > > +static const struct file_operations kvm_ptdump_guest_fops = {
> > > +	.open		= kvm_ptdump_guest_open,
> > > +	.read		= seq_read,
> > > +	.llseek		= seq_lseek,
> > > +	.release	= kvm_ptdump_guest_close,
> > > +};
> > > +
> > > +static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
> > > +{
> > > +	const struct file *file = m->file;
> > > +	struct kvm_pgtable *pgtable = m->private;
> > > +
> > > +	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
> 
> I really dislike this sort of construct, and I'd rather we pick the
> correct callback by construction rather than relying on a string
> comparison. See below for a suggestion.
> 

Thanks for the feedback and for the suggestion. Let me try to re-write
this as indicated.

> > > +		seq_printf(m, "%2u\n", pgtable->ia_bits);
> > > +	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
> > > +		seq_printf(m, "%1d\n", KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
> > 
> > nit: KVM_PGTABLE_MAX_LEVELS - pgtable->start_level ?
> > 
> > > +	return 0;
> > > +}
> > > +
> > > +static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
> > > +{
> > > +	struct kvm *kvm = m->i_private;
> > > +	struct kvm_pgtable *pgtable;
> > > +	int ret;
> > > +
> > > +	if (!kvm_get_kvm_safe(kvm))
> > > +		return -ENOENT;
> > > +
> > > +	pgtable = kvm->arch.mmu.pgt;
> > > +
> > > +	ret = single_open(file, kvm_pgtable_debugfs_show, pgtable);
> > > +	if (ret < 0)
> > > +		kvm_put_kvm(kvm);
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
> > > +{
> > > +	struct kvm *kvm = m->i_private;
> > > +
> > > +	kvm_put_kvm(kvm);
> > > +	return single_release(m, file);
> > > +}
> > > +
> > > +static const struct file_operations kvm_pgtable_debugfs_fops = {
> > > +	.open		= kvm_pgtable_debugfs_open,
> > > +	.read		= seq_read,
> > > +	.llseek		= seq_lseek,
> > > +	.release	= kvm_pgtable_debugfs_close,
> > > +};
> > > +
> > > +void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
> > > +{
> > > +	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> > > +			    kvm, &kvm_ptdump_guest_fops);
> > > +	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
> > > +			    &kvm_pgtable_debugfs_fops);
> > > +	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
> > > +			    kvm, &kvm_pgtable_debugfs_fops);
> > > +}
> 
> I'd expect something like this instead:
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index e72a928d4445..c11ea355aa51 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -192,19 +191,24 @@ static const struct file_operations kvm_ptdump_guest_fops = {
>  	.release	= kvm_ptdump_guest_close,
>  };
>  
> -static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
> +static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
> +{
> +	struct kvm_pgtable *pgtable = m->private;
> +
> +	seq_printf(m, "%2u\n", pgtable->ia_bits);
> +	return 0;
> +}
> +
> +static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
>  {
> -	const struct file *file = m->file;
>  	struct kvm_pgtable *pgtable = m->private;
>  
> -	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
> -		seq_printf(m, "%2u\n", pgtable->ia_bits);
> -	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
> -		seq_printf(m, "%1d\n", KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
> +	seq_printf(m, "%1d\n", KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
>  	return 0;
>  }
>  
> -static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
> +static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
> +				    int (*show)(struct seq_file *, void *))
>  {
>  	struct kvm *kvm = m->i_private;
>  	struct kvm_pgtable *pgtable;
> @@ -215,12 +219,22 @@ static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
>  
>  	pgtable = kvm->arch.mmu.pgt;
>  
> -	ret = single_open(file, kvm_pgtable_debugfs_show, pgtable);
> +	ret = single_open(file, show, pgtable);
>  	if (ret < 0)
>  		kvm_put_kvm(kvm);
>  	return ret;
>  }
>  
> +static int kvm_pgtable_range_open(struct inode *m, struct file *file)
> +{
> +	return kvm_pgtable_debugfs_open(m, file, kvm_pgtable_range_show);
> +}
> +
> +static int kvm_pgtable_levels_open(struct inode *m, struct file *file)
> +{
> +	return kvm_pgtable_debugfs_open(m, file, kvm_pgtable_levels_show);
> +}
> +
>  static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
>  {
>  	struct kvm *kvm = m->i_private;
> @@ -229,8 +243,15 @@ static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
>  	return single_release(m, file);
>  }
>  
> -static const struct file_operations kvm_pgtable_debugfs_fops = {
> -	.open		= kvm_pgtable_debugfs_open,
> +static const struct file_operations kvm_pgtable_range_fops = {
> +	.open		= kvm_pgtable_range_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_pgtable_debugfs_close,
> +};
> +
> +static const struct file_operations kvm_pgtable_levels_fops = {
> +	.open		= kvm_pgtable_levels_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
>  	.release	= kvm_pgtable_debugfs_close,
> @@ -241,7 +262,7 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
>  			    kvm, &kvm_ptdump_guest_fops);
>  	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
> -			    &kvm_pgtable_debugfs_fops);
> +			    &kvm_pgtable_range_fops);
>  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
> -			    kvm, &kvm_pgtable_debugfs_fops);
> +			    kvm, &kvm_pgtable_levels_fops);
>  }
> 
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Seb


> -- 
> Without deviation from the norm, progress is not possible.
