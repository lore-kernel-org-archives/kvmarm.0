Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B7519CD0F
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748370; cv=none; b=CV25r//7AWljr48gWqkWYXqVb+fY90GnCvk/w3WWVjqz/V5yMcnA/cCxZ3yfo9b5BR8V1s3bNNPx/nq4pAAodH151ECaS8UAaa2M6I9r3vHHVTFxZIuJaMuCfmnLNKAVUHC6le187XADwc6pAqCqEtv9DETxotnGIdvZjdOxd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748370; c=relaxed/simple;
	bh=z2p1RVuzWCFkdtKCAz/1qFqpK2ISUcxi9DnlSlJe3uo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VVXjgD3iu93/joDerQuqSMzS+P+ln9eNZSHoOYpyOY8PA6NnQPz2E0RSc/nT/deiiJoIc91l0D/WyCaPtjmtRmwFc9oabZ1HTvng7/GL5MpzA9Dxd8hOEhRhMohapU3oAaRT5b3YEdvLA4UMxEJ0EvYJLSgZ9Y0+XbPthW2OhB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MjNSp9dn; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MjNSp9dn"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ac83a71d45so95982997b3.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 01:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724748368; x=1725353168; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I83ViSc79idei070aXXCqbHDAqJCF9Bk2zTKeUxiNYQ=;
        b=MjNSp9dngnngISVcnwt9LcHNG7iP6Y1y3Qvzk5BUpQW5stN/cvGMByWgv/KFCuzzc9
         bSau06nKyShTJu9YUyi+VXY1AKYYh49OItDfyk39x+bcq3H0X5RZf7McpY96Psv5UY+l
         v4LEWpKIrTxBcQOlsAeExHYxfcZawpKNNfJYlTdApNFnL/YBuJldIBcTO0tMD87AnHn4
         yI/IlL/esALKeKwRPlpGH6Gl9PISF+dmzeCsw0k2ZhNFJGGYdKg6bUgECvPy60u8/yc3
         A/eeJglvHvWr0PrXBp4Bk8LjNgM7q8jkrTxf7DWLok9piVdXBW2jn7xLkfFcQZMirGys
         RB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748368; x=1725353168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I83ViSc79idei070aXXCqbHDAqJCF9Bk2zTKeUxiNYQ=;
        b=H+nAeFquTGeXmlJmPVEFH8Z95DIWmcualGc5rlTvjmvMJln6vyeoOw3VQffVr8dUv9
         nB0oHVLIRf0RWcYSYWEHW3YjhZfwmlMN35wdIueXXKZ8ow42wsJqyCEjqF1MUI7eehhk
         byOsbP781OOv8lOtb6U0UoCKzCF1rsLfMkanDVPYg1yuk8XgsBgXgTEajJViKnXOvFOG
         FuVBgXNT5H6ybBXDOcXXTvi16ruX/CJ9oMCUuWY00wNWirgNhBaxJ8mUUvETOrbUBRPT
         HTN4WE7HzyGqd76RbsSD85Vf67yrcUFK661COIAfC3NuZntPkyDDBs5LhEaIi99+97WN
         zlqQ==
X-Gm-Message-State: AOJu0YyEuByHQ2GnLs27IhUm81BU52Xjme8vE5DS7f9Rfcr17+tuHE82
	beZx2WWszxxnSuBH4DAX+yrQ+FnIAi0hd57hLb+Gq5ldsDYETrkLst9hy1hEK7vUr0pfiv3OXb+
	XrqkHyTiJpGQ1RxCp4igPnMJLGg==
X-Google-Smtp-Source: AGHT+IFxiVGmxV1SeAk+rQ6esRUKQhSaio0jNBDqtfLxXEnyCJ7jXIY6+34UXYrhIaHuXVBZH+t7RQIgxN3TiCrDbaI=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a81:7e46:0:b0:664:c5e0:6574 with SMTP
 id 00721157ae682-6cfbbbd63c4mr960687b3.9.1724748367933; Tue, 27 Aug 2024
 01:46:07 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:45:47 +0000
In-Reply-To: <20240827084549.45731-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240827084549.45731-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240827084549.45731-5-sebastianene@google.com>
Subject: [PATCH v9 4/5] KVM: arm64: Register ptdump with debugfs on guest creation
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

While arch/*/mem/ptdump handles the kernel pagetable dumping code,
introduce KVM/ptdump to show the guest stage-2 pagetables. The
separation is necessary because most of the definitions from the
stage-2 pagetable reside in the KVM path and we will be invoking
functionality specific to KVM.

When a guest is created, register a new file entry under the guest
debugfs dir which allows userspace to show the contents of the guest
stage-2 pagetables when accessed.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   6 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/arm.c              |   1 +
 arch/arm64/kvm/ptdump.c           | 247 ++++++++++++++++++++++++++++++
 4 files changed, 255 insertions(+)
 create mode 100644 arch/arm64/kvm/ptdump.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..4acd589f086b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1473,4 +1473,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
+#else
+static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
+#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 86a629aaf0a1..e4233b323a73 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -27,6 +27,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
+kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bef7638342e..b9fd928d3477 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -228,6 +228,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 void kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 	kvm_sys_regs_create_debugfs(kvm);
+	kvm_s2_ptdump_create_debugfs(kvm);
 }
 
 static void kvm_destroy_mpidr_data(struct kvm *kvm)
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
new file mode 100644
index 000000000000..e72a928d4445
--- /dev/null
+++ b/arch/arm64/kvm/ptdump.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Debug helper used to dump the stage-2 pagetables of the system and their
+ * associated permissions.
+ *
+ * Copyright (C) Google, 2024
+ * Author: Sebastian Ene <sebastianene@google.com>
+ */
+#include <linux/debugfs.h>
+#include <linux/kvm_host.h>
+#include <linux/seq_file.h>
+
+#include <asm/kvm_pgtable.h>
+#include <asm/kvm_host.h>
+#include <asm/ptdump.h>
+
+
+#define MARKERS_LEN		(2)
+#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
+
+struct kvm_ptdump_guest_state {
+	struct kvm		*kvm;
+	struct ptdump_pg_state	parser_state;
+	struct addr_marker	ipa_marker[MARKERS_LEN];
+	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
+	struct ptdump_range	range[MARKERS_LEN];
+};
+
+static const struct ptdump_prot_bits stage2_pte_bits[] = {
+	{
+		.mask	= PTE_VALID,
+		.val	= PTE_VALID,
+		.set	= " ",
+		.clear	= "F",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
+		.set	= "R",
+		.clear	= " ",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
+		.set	= "W",
+		.clear	= " ",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
+		.val	= PTE_VALID,
+		.set	= " ",
+		.clear	= "X",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
+		.set	= "AF",
+		.clear	= "  ",
+	}, {
+		.mask	= PTE_TABLE_BIT | PTE_VALID,
+		.val	= PTE_VALID,
+		.set	= "BLK",
+		.clear	= "   ",
+	},
+};
+
+static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
+{
+	struct ptdump_pg_state *st = ctx->arg;
+	struct ptdump_state *pt_st = &st->ptdump;
+
+	note_page(pt_st, ctx->addr, ctx->level, ctx->old);
+
+	return 0;
+}
+
+static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
+{
+	u32 i;
+	u64 mask;
+
+	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
+		return -EINVAL;
+
+	mask = 0;
+	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
+		mask |= stage2_pte_bits[i].mask;
+
+	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
+		snprintf(level[i].name, sizeof(level[i].name), "%d", i);
+
+		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
+		level[i].bits	= stage2_pte_bits;
+		level[i].mask	= mask;
+	}
+
+	return 0;
+}
+
+static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
+{
+	struct kvm_ptdump_guest_state *st;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct kvm_pgtable *pgtable = mmu->pgt;
+	int ret;
+
+	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
+	if (!st)
+		return ERR_PTR(-ENOMEM);
+
+	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
+	if (ret) {
+		kfree(st);
+		return ERR_PTR(ret);
+	}
+
+	st->ipa_marker[0].name		= "Guest IPA";
+	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
+	st->range[0].end		= BIT(pgtable->ia_bits);
+
+	st->kvm				= kvm;
+	st->parser_state = (struct ptdump_pg_state) {
+		.marker		= &st->ipa_marker[0],
+		.level		= -1,
+		.pg_level	= &st->level[0],
+		.ptdump.range	= &st->range[0],
+		.start_address	= 0,
+	};
+
+	return st;
+}
+
+static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
+{
+	int ret;
+	struct kvm_ptdump_guest_state *st = m->private;
+	struct kvm *kvm = st->kvm;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct ptdump_pg_state *parser_state = &st->parser_state;
+	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
+		.cb	= kvm_ptdump_visitor,
+		.arg	= parser_state,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	parser_state->seq = m;
+
+	write_lock(&kvm->mmu_lock);
+	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
+	write_unlock(&kvm->mmu_lock);
+
+	return ret;
+}
+
+static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+	struct kvm_ptdump_guest_state *st;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	st = kvm_ptdump_parser_create(kvm);
+	if (IS_ERR(st)) {
+		ret = PTR_ERR(st);
+		goto free_with_kvm_ref;
+	}
+
+	ret = single_open(file, kvm_ptdump_guest_show, st);
+	if (!ret)
+		return 0;
+
+	kfree(st);
+free_with_kvm_ref:
+	kvm_put_kvm(kvm);
+	return ret;
+}
+
+static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+	void *st = ((struct seq_file *)file->private_data)->private;
+
+	kfree(st);
+	kvm_put_kvm(kvm);
+
+	return single_release(m, file);
+}
+
+static const struct file_operations kvm_ptdump_guest_fops = {
+	.open		= kvm_ptdump_guest_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_ptdump_guest_close,
+};
+
+static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
+{
+	const struct file *file = m->file;
+	struct kvm_pgtable *pgtable = m->private;
+
+	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
+		seq_printf(m, "%2u\n", pgtable->ia_bits);
+	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
+		seq_printf(m, "%1d\n", KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
+	return 0;
+}
+
+static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+	struct kvm_pgtable *pgtable;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	pgtable = kvm->arch.mmu.pgt;
+
+	ret = single_open(file, kvm_pgtable_debugfs_show, pgtable);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+	return ret;
+}
+
+static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+
+	kvm_put_kvm(kvm);
+	return single_release(m, file);
+}
+
+static const struct file_operations kvm_pgtable_debugfs_fops = {
+	.open		= kvm_pgtable_debugfs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_pgtable_debugfs_close,
+};
+
+void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
+{
+	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_ptdump_guest_fops);
+	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
+			    &kvm_pgtable_debugfs_fops);
+	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_pgtable_debugfs_fops);
+}
-- 
2.46.0.295.g3b9ea8a38a-goog

