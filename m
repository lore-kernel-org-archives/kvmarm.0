Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F39B762FC
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441904; cv=none; b=knCeiGrmOEB07Dk+NBbPh3Rzs24T0hs/NKTSSASHR9mdsh97Wo5K65q0CCuL0RqFK/77OaAj+zsunSumZjrndDdTPQsILZeqL/2mVIiLSS8ZHQoCHjGPoToyIBiME7pIshA4PZtBadpuEBVA+gmdUrri3LHANqPEu1FLxTGPST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441904; c=relaxed/simple;
	bh=jMavhYRCsq8TrG+5Wn0f9GwDD+Uua09tmUtXiDesIR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KEVnUJn1Ffew65gnlVsITW5a999H9VLKa81MK6aHFoL60Fxly7wy/dQ0R4N9Tl7IIO6A0moYNcn4Kv6pILg1x1su5A88HdNt0nPavDo7II/eamHjgd4nkmzWRT+tZ6lqgh89D6cgNvxKMCWYyE0dgov88LzsZGI4uN75nsa7/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNfV5iBk; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNfV5iBk"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so4654781276.2
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 07:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708441901; x=1709046701; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p126ZMPv5yWICgYljgBmVza3JvKiPG+UvgFwItLei+8=;
        b=KNfV5iBkPiUIZKu5JgvS7O1nLeh+owGBkoiSdBlIwhHTJRi0a23pZoqK5wR8hP5cK0
         sgWmbXMT41YCoVrg44jSb0zG758jPNhv+5pWoVBouNeV/dOa08VLgWyGAmFiztAWsKfM
         4s3ke4iBbHZV1CLtF6++2OSVtt3NonEEd2tzB6DVauMByorF90yJuPeG7aoix2OUUju+
         CxF4D10IH5t3H63kqefr9Qp6iYwYTfjAHE3uAPjSimmffViJf1GTINUjICdXcZFXHNBZ
         rA+FFfstyu0WB3H4oXg/oAcUhmXtyxNwAhPUFsFwXHg3PsXifQmmj5LKq3wnOx1Tc1rJ
         i5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441901; x=1709046701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p126ZMPv5yWICgYljgBmVza3JvKiPG+UvgFwItLei+8=;
        b=BHqfBtW7TERnjwaecebV8BDsxhkfcjc+GzUzAAfzM7cOgLCMV3NlvaU3idhLz810uE
         5Zma41sjBMaxYCbOZ16cpgvL218AloMuQ3q75A92i+WR8vKB68F/+zRAn7b2lOB4DBy+
         zsD8Vikys/Lx8szGlo60VQwrVtLLd35ZUKkM3cxT+0z4yrhzwMWssVYX4vQcxd3vb0D3
         HdiVtCPQNcomEfxYU8NURpCXKEDPMS4fKDp31FypHud8pziPl8eqg5Gdom6yUV5Yg9Xe
         TOHKfjvy7X83VhV8YGYmpDOr5wlxoD4p9YS3IGz41/opPsMmnhUQuLS5Kra0Wkc08O4f
         FDzw==
X-Gm-Message-State: AOJu0YwG+qacxrKC9lLi3779i74r07iNK1FqsCN5KlIErOrE3uL0K8mP
	WNonLuLA0XtCU70d7iR4jskRZwGUnEf70K8bQat2lBN1/4FolUq5OXwotP+auy0tpgfJlI7tVJN
	yBN3mNPidmUEh608+GDTEEKoGUg==
X-Google-Smtp-Source: AGHT+IE3sSuv/dqK0KEJjDx/stMRwGi5ma0Itm9NZVnsN0igBCefepX70yH15VkcvRaIoYNQr+yi/UxL6YOdOcrG7KI=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:100a:b0:dc6:c94e:fb85 with
 SMTP id w10-20020a056902100a00b00dc6c94efb85mr573440ybt.2.1708441901684; Tue,
 20 Feb 2024 07:11:41 -0800 (PST)
Date: Tue, 20 Feb 2024 15:10:33 +0000
In-Reply-To: <20240220151035.327199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240220151035.327199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220151035.327199-5-sebastianene@google.com>
Subject: [PATCH v6 4/6] KVM: arm64: Register ptdump with debugfs on guest creation
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev, 
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com, 
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

While arch/*/mem/ptdump handles the kernel pagetable dumping code,
introduce KVM/ptdump which shows the guest stage-2 pagetables. The
separation is necessary because most of the definitions from the
stage-2 pagetable reside in the KVM path and we will be invoking
functionality **specific** to KVM.

When a guest is created, register a new file entry under the guest
debugfs dir which allows userspace to show the contents of the guest
stage-2 pagetables when accessed.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/Kconfig      | 13 ++++++
 arch/arm64/kvm/Makefile     |  1 +
 arch/arm64/kvm/debug.c      |  8 ++++
 arch/arm64/kvm/kvm_ptdump.h | 20 +++++++++
 arch/arm64/kvm/ptdump.c     | 88 +++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+)
 create mode 100644 arch/arm64/kvm/kvm_ptdump.h
 create mode 100644 arch/arm64/kvm/ptdump.c

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 27ca89b628a0..83ca07d16cf4 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -67,4 +67,17 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config PTDUMP_STAGE2_DEBUGFS
+       bool "Present the stage-2 pagetables to debugfs"
+       depends on PTDUMP_DEBUGFS && KVM
+       default n
+       help
+         Say Y here if you want to show the stage-2 kernel pagetables
+         layout in a debugfs file. This information is only useful for kernel developers
+         who are working in architecture specific areas of the kernel.
+         It is probably not a good idea to enable this feature in a production
+         kernel.
+
+         If in doubt, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..190eac17538c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 8725291cb00a..ff97af2c0513 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -14,6 +14,8 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 
+#include <kvm_ptdump.h>
+
 #include "trace.h"
 
 /* These are the bits of MDSCR_EL1 we may manipulate */
@@ -342,3 +344,9 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 }
+
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	kvm_ptdump_guest_register(kvm);
+	return 0;
+}
diff --git a/arch/arm64/kvm/kvm_ptdump.h b/arch/arm64/kvm/kvm_ptdump.h
new file mode 100644
index 000000000000..5e8a655605f1
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ptdump.h
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) Google, 2023
+ * Author: Sebastian Ene <sebastianene@google.com>
+ */
+
+#ifndef __KVM_PTDUMP_H
+#define __KVM_PTDUMP_H
+
+#include <linux/kvm_host.h>
+#include <asm/ptdump.h>
+
+
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+void kvm_ptdump_guest_register(struct kvm *kvm);
+#else
+static inline void kvm_ptdump_guest_register(struct kvm *kvm) {}
+#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
+
+#endif /* __KVM_PTDUMP_H */
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
new file mode 100644
index 000000000000..9b04c24bb9be
--- /dev/null
+++ b/arch/arm64/kvm/ptdump.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Debug helper used to dump the stage-2 pagetables of the system and their
+ * associated permissions.
+ *
+ * Copyright (C) Google, 2023
+ * Author: Sebastian Ene <sebastianene@google.com>
+ */
+#include <linux/debugfs.h>
+#include <linux/kvm_host.h>
+#include <linux/seq_file.h>
+
+#include <asm/kvm_pgtable.h>
+#include <kvm_ptdump.h>
+
+
+static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
+{
+	struct pg_state *st = ctx->arg;
+	struct ptdump_state *pt_st = &st->ptdump;
+
+	note_page(pt_st, ctx->addr, ctx->level, ctx->old);
+	return 0;
+}
+
+static int kvm_ptdump_show_common(struct seq_file *m,
+				  struct kvm_pgtable *pgtable,
+				  struct pg_state *parser_state)
+{
+	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
+		.cb     = kvm_ptdump_visitor,
+		.arg	= parser_state,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
+}
+
+static int kvm_ptdump_guest_show(struct seq_file *m, void *)
+{
+	struct kvm *kvm = m->private;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct pg_state parser_state = {0};
+	int ret;
+
+	write_lock(&kvm->mmu_lock);
+	ret = kvm_ptdump_show_common(m, mmu->pgt, &parser_state);
+	write_unlock(&kvm->mmu_lock);
+
+	return ret;
+}
+
+static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	ret = single_open(file, kvm_ptdump_guest_show, m->i_private);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+
+	return ret;
+}
+
+static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+
+	kvm_put_kvm(kvm);
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
+void kvm_ptdump_guest_register(struct kvm *kvm)
+{
+	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_ptdump_guest_fops);
+}
-- 
2.44.0.rc0.258.g7320e95886-goog

