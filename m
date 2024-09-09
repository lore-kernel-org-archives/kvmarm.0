Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BBE1B9B50
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886060; cv=none; b=Il18PulYdqkmXYuTkgP/Lp1nvNJr1WqaQ2Nl0RCmVQJ4S00rq20wQ1tsBqth/V3Uab0iNB2CFoLLhK5Uq222YQSkywXFp7E/hlrWesFZW8MHpDQiwyhmlwiS3+cJopkqtbaoL/sLa7T3Oc8rZmIzYORzfeNQCopTJngRkrXw/Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886060; c=relaxed/simple;
	bh=GNNUx7/Gw+vesUQbfarr9gvTXiMt4QErQCEA6J8CJF0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9chZIWp5V3oP2tc4lN5Vn8kXjGkcqBG8ja5PRyN51dd0/aHldhWu7w1UFvd2FMdbvtlSyIyhFeS9ek2YiMxM5GBliYRttsJTjVxrTUdoYRBDp7eHyljJzMHbC4vgKe10O3rM3MckUw7B+xXBtHrRff21sdBgyIOCW3maftI5l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IQNJe7VV; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQNJe7VV"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-374b385b146so1867363f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725886057; x=1726490857; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Qh0Buj26VPt7o3soq7cdfVmyH4HC9Sx5cxY7g+Xi6I=;
        b=IQNJe7VVLfjE++EcZBbPBr+Q0qrQBNMvSdbsqopsmQZ7MCIw4ekY9EyAXEMyp4mBjX
         EFWnwvo9zwyHxBqALFpnVfLrn8uDRktV0uytBfk0d4aZT7O2i09zDeTg42pdzWe0TL0H
         3heEFJJ6+cWFK2Id9buU7dL5zyATByo87ArMerKQ6syoT/d457bSlbcKY7oCbQgS+28h
         M8X17vt5VnVMRdgjxQHSqcII3of0gEo0kEcEeC7nStuIR3d15jdieuP6/V1f8fxTTqI7
         P9X2z9L5AMhJukrUvOGXVZQoUPiguOz44dAMXPMm6rNPG6YxVCBew42TZdQdXTuj1gRz
         ih3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886057; x=1726490857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Qh0Buj26VPt7o3soq7cdfVmyH4HC9Sx5cxY7g+Xi6I=;
        b=tP11tcey6Cx00cmZhJvCrxRdvSqr1n3/M/30eq3FQjb3yxfkblJ/4YNUwWjF2oWtWF
         YhAM6BkbX29oWrrc6yhA1noVU0l+Fuq156qk04XbzFuA1hQzAT/moEl2iogt9X7GMx7H
         Xd8irol6RvbkH+9Dnpe2NnUAREdY52G/DR8T8/w2hbn3NJJPu/GRc5BV4sJ07MHvnv9l
         fey2PM7NfCwtKwgjVPcQIlnuWOp+wZfDc5PICIqqFkyKi2S4n7yN7qH3G3h0n7Ok5Bui
         2GTxx2yqaNPdoCfJauIeTweDA7tILcxfJz6lTuV1tvf8G50nxIp2p1HyobfqZNNY1Jxr
         tvkw==
X-Gm-Message-State: AOJu0YwAXw3MB49+XCWC7097X9Bb/VAGVz5iBPf2DcihA5b3JsWy18GT
	+UhJe4DNoo47KmnZZptGrO3rylQEDyVIsWgGUSSuAsP14xleUNNeTLdjdOrWygjwAozCkDlvv9T
	u21Mtb1MSCT7WuKWsKrJeE6skRQ==
X-Google-Smtp-Source: AGHT+IFrv0rLDSOUyf6zXDI606xTRZ7fv0Nwzc81o52OBg6AUGVDlns9tuVUU3FDCSkjPXyyiudbP0Q4hvSoN0F+igM=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:68:fe9:ac10:f1b7])
 (user=sebastianene job=sendgmr) by 2002:a05:6000:184f:b0:374:cade:3806 with
 SMTP id ffacd0b85a97d-378895c5256mr15705f8f.2.1725886056876; Mon, 09 Sep 2024
 05:47:36 -0700 (PDT)
Date: Mon,  9 Sep 2024 12:47:21 +0000
In-Reply-To: <20240909124721.1672199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240909124721.1672199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909124721.1672199-6-sebastianene@google.com>
Subject: [PATCH v10 5/5] KVM: arm64: Register ptdump with debugfs on guest creation
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
functionality specific to KVM. Introduce the PTDUMP_STAGE2_DEBUGFS config.

When a guest is created, register a new file entry under the guest
debugfs dir which allows userspace to show the contents of the guest
stage-2 pagetables when accessed.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   6 +
 arch/arm64/kvm/Kconfig            |  17 ++
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/arm.c              |   1 +
 arch/arm64/kvm/ptdump.c           | 268 ++++++++++++++++++++++++++++++
 5 files changed, 293 insertions(+)
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
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8304eb342be9..ead632ad01b4 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -66,4 +66,21 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config PTDUMP_STAGE2_DEBUGFS
+	bool "Present the stage-2 pagetables to debugfs"
+	depends on KVM
+	depends on DEBUG_KERNEL
+	depends on DEBUG_FS
+	depends on GENERIC_PTDUMP
+	select PTDUMP_CORE
+	default n
+	help
+	  Say Y here if you want to show the stage-2 kernel pagetables
+	  layout in a debugfs file. This information is only useful for kernel developers
+	  who are working in architecture specific areas of the kernel.
+	  It is probably not a good idea to enable this feature in a production
+	  kernel.
+
+	  If in doubt, say N.
+
 endif # VIRTUALIZATION
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
index 000000000000..e29604a864b7
--- /dev/null
+++ b/arch/arm64/kvm/ptdump.c
@@ -0,0 +1,268 @@
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
+#include <asm/kvm_host.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/ptdump.h>
+
+#define MARKERS_LEN		2
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
+		snprintf(level[i].name, sizeof(level[i].name), "%u", i);
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
+		goto err_with_kvm_ref;
+	}
+
+	ret = single_open(file, kvm_ptdump_guest_show, st);
+	if (!ret)
+		return 0;
+
+	kfree(st);
+err_with_kvm_ref:
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
+static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
+{
+	struct kvm_pgtable *pgtable = m->private;
+
+	seq_printf(m, "%2u\n", pgtable->ia_bits);
+	return 0;
+}
+
+static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
+{
+	struct kvm_pgtable *pgtable = m->private;
+
+	seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - pgtable->start_level);
+	return 0;
+}
+
+static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
+				    int (*show)(struct seq_file *, void *))
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
+	ret = single_open(file, show, pgtable);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+	return ret;
+}
+
+static int kvm_pgtable_range_open(struct inode *m, struct file *file)
+{
+	return kvm_pgtable_debugfs_open(m, file, kvm_pgtable_range_show);
+}
+
+static int kvm_pgtable_levels_open(struct inode *m, struct file *file)
+{
+	return kvm_pgtable_debugfs_open(m, file, kvm_pgtable_levels_show);
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
+static const struct file_operations kvm_pgtable_range_fops = {
+	.open		= kvm_pgtable_range_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_pgtable_debugfs_close,
+};
+
+static const struct file_operations kvm_pgtable_levels_fops = {
+	.open		= kvm_pgtable_levels_open,
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
+			    &kvm_pgtable_range_fops);
+	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_pgtable_levels_fops);
+}
-- 
2.46.0.469.g59c65b2a67-goog

