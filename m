Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4121137860
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVdHQPgt"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5cf4696e202so38357877b3.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702907991; x=1703512791; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gY15YxDdKSZ0D8Iy0CW6yGr0u1mIBXiISHgw6mfVrxM=;
        b=zVdHQPgt4C506qOiH/aVAsDxnraYbMF4Z4amCMlcdrmWemZNT6dl3MAKjAI8aSa0EG
         6jORVBXCeJ4EqSRe70+vo9WxoNuyHKWG3C3rdE8RT+tuXsMD1ClX1Q6s1IWtvxynJW5g
         2fB2B459+f55tEBdDXTkMZe16ofihvTtoVh58WCZSBVZuouXhopClzhjU0PQDIEznoIX
         hxUHOWyTut1HtLw5LhGerg5P0ghSqMCdhxoDgqTIluVcNaZITteB6HbH8bGyk4ZnQoKs
         YU0C6MzecZ5xnvg4Xt1JwZ3YxTsqgGrUxhybiPEUDK2Pnsrd8qY/oEf+FlK/RkjsZaG9
         SWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702907991; x=1703512791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gY15YxDdKSZ0D8Iy0CW6yGr0u1mIBXiISHgw6mfVrxM=;
        b=utB5S7l9rGL7PdPn/lVjgAdW3cpU4NWvVKj8WwMLAyksT1VPfMK6+rhZYREFeZe9Ks
         ZWncYpuBsv3iOY0RL65kjzNchoQ6xvcdBDHwkMabfQViFnYt9OO9otXqxBlT9b5ckPA3
         TUhNB6Eo054rjUl+1+eDNu9KWjzxNjfk0I/eTG8eR8CUTMpOKX64R5AGacVGsY9WZn8P
         Jm3AQ+qoDdqyG+l0G2ocDk21BuFzG6sDBbcLFAn+rexuSGbtGDMGUDd1kYBK1uIVy9UG
         ES0U3KNowKIhPt/Hy6jCtmQCckhFDW01dXFQQ0P348umfBmxfaCsE8HIS3aLUo81bBA1
         e80g==
X-Gm-Message-State: AOJu0YxJxVG9NJlx4bDoID7eYTutu5X6Ag/qoD8TfCF0dsAcUJmnzpHY
	e5GtU/yRhSeWTwSJaMpEh7+UFbfGGu4hF6OqPaU=
X-Google-Smtp-Source: AGHT+IHDTm4uPycg4NnOmmmHO8eB8Hxe6SvZg93QYIJIsVaMcke5f0Zbhd+84fF7mn/7zDbMIdfM8WX0GvJvBINN+B4=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:690c:385:b0:5d3:a348:b0c0 with
 SMTP id bh5-20020a05690c038500b005d3a348b0c0mr2399920ywb.5.1702907991281;
 Mon, 18 Dec 2023 05:59:51 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:52 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-4-sebastianene@google.com>
Subject: [PATCH v4 02/10] KVM: arm64: Add ptdump registration with debugfs for
 the stage-2 pagetables
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

While arch/*/mem/ptdump handles the kernel pagetable dumping code,
introduce KVM/ptdump which deals with the stage-2 pagetables. The
separation is necessary because most of the definitions from the
stage-2 pagetable reside in the KVM path and we will be invoking
functionality **specific** to KVM.

This registers a wrapper on top of debugfs_create_file which allows us
to hook callbacks on the debugfs open/show/close. The callbacks are used
to prepare the display portion of the pagetable dumping code.
Guard this functionality under the newly introduced PTDUMP_STAGE2_DEBUGFS.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/Kconfig      | 13 +++++
 arch/arm64/kvm/Makefile     |  1 +
 arch/arm64/kvm/arm.c        |  2 +
 arch/arm64/kvm/kvm_ptdump.h | 18 +++++++
 arch/arm64/kvm/ptdump.c     | 96 +++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+)
 create mode 100644 arch/arm64/kvm/kvm_ptdump.h
 create mode 100644 arch/arm64/kvm/ptdump.c

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 83c1e09be..0014e55e2 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -71,4 +71,17 @@ config PROTECTED_NVHE_STACKTRACE
 
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
index c0c050e53..190eac175 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1..ee8d7cb67 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -40,6 +40,7 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
+#include <kvm_ptdump.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
@@ -2592,6 +2593,7 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_subs;
 
+	kvm_ptdump_register_host();
 	kvm_arm_initialised = true;
 
 	return 0;
diff --git a/arch/arm64/kvm/kvm_ptdump.h b/arch/arm64/kvm/kvm_ptdump.h
new file mode 100644
index 000000000..98b595ce8
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ptdump.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+//
+// Copyright (C) Google, 2023
+// Author: Sebastian Ene <sebastianene@google.com>
+
+#ifndef __KVM_PTDUMP_H
+#define __KVM_PTDUMP_H
+
+#include <asm/ptdump.h>
+
+
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+void kvm_ptdump_register_host(void);
+#else
+static inline void kvm_ptdump_register_host(void) { }
+#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
+
+#endif /* __KVM_PTDUMP_H */
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
new file mode 100644
index 000000000..5816fc632
--- /dev/null
+++ b/arch/arm64/kvm/ptdump.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Debug helper used to dump the stage-2 pagetables of the system and their
+// associated permissions.
+//
+// Copyright (C) Google, 2023
+// Author: Sebastian Ene <sebastianene@google.com>
+
+#include <linux/debugfs.h>
+#include <linux/kvm_host.h>
+#include <linux/seq_file.h>
+
+#include <asm/kvm_pkvm.h>
+#include <kvm_ptdump.h>
+
+
+struct kvm_ptdump_register {
+	void *(*get_ptdump_info)(struct kvm_ptdump_register *reg);
+	void (*put_ptdump_info)(void *priv);
+	int (*show_ptdump_info)(struct seq_file *m, void *v);
+	void *priv;
+};
+
+static int kvm_ptdump_open(struct inode *inode, struct file *file);
+static int kvm_ptdump_release(struct inode *inode, struct file *file);
+static int kvm_ptdump_show(struct seq_file *m, void *);
+
+static const struct file_operations kvm_ptdump_fops = {
+	.open		= kvm_ptdump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_ptdump_release,
+};
+
+static int kvm_ptdump_open(struct inode *inode, struct file *file)
+{
+	struct kvm_ptdump_register *reg = inode->i_private;
+	void *info = NULL;
+	int ret;
+
+	if (reg->get_ptdump_info) {
+		info = reg->get_ptdump_info(reg);
+		if (!info)
+			return -ENOMEM;
+	}
+
+	if (!reg->show_ptdump_info)
+		reg->show_ptdump_info = kvm_ptdump_show;
+
+	ret = single_open(file, reg->show_ptdump_info, info);
+	if (ret && reg->put_ptdump_info)
+		reg->put_ptdump_info(info);
+
+	return ret;
+}
+
+static int kvm_ptdump_release(struct inode *inode, struct file *file)
+{
+	struct kvm_ptdump_register *reg = inode->i_private;
+	struct seq_file *seq_file = file->private_data;
+
+	if (reg->put_ptdump_info)
+		reg->put_ptdump_info(seq_file->private);
+
+	return 0;
+}
+
+static int kvm_ptdump_show(struct seq_file *m, void *)
+{
+	return -EINVAL;
+}
+
+static void kvm_ptdump_debugfs_register(struct kvm_ptdump_register *reg,
+					const char *name, struct dentry *parent)
+{
+	debugfs_create_file(name, 0400, parent, reg, &kvm_ptdump_fops);
+}
+
+static struct kvm_ptdump_register host_reg;
+
+void kvm_ptdump_register_host(void)
+{
+	if (!is_protected_kvm_enabled())
+		return;
+
+	kvm_ptdump_debugfs_register(&host_reg, "host_page_tables",
+				    kvm_debugfs_dir);
+}
+
+static int __init kvm_host_ptdump_init(void)
+{
+	host_reg.priv = (void *)host_s2_pgtable_pages();
+	return 0;
+}
+
+device_initcall(kvm_host_ptdump_init);
-- 
2.43.0.472.g3155946c3a-goog

