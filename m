Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDD5A842
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIjziPMn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40c25973861so25117505e9.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 06:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702908009; x=1703512809; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rhLwUQ1ywrBkBuwEQIDGD2rpJ8EK3ecZScs+lwiHfY=;
        b=DIjziPMn54aMc7Uc7LVohM4ku0VSog096tVkelJ59nh+YUZ/A5UGUSQx60XfZ09+3x
         7k6L6yZ14jWStsP02EO1Wj26ej7qvo8DM8nUCNcvHvJvcVnTtquWdYPbMZgYoxLNNWBU
         2ZCf/mIv2Iq7g5GuQu5ALWv11AIDoGIu8hfufo91upLynC3yoRAcBSxyXRqv4++lw65k
         gy3vZuUcAVuORbeXz0D+pgUn5kPQDRBNKm7AGVJZbTKMwUjPaGRSeYe/wR4bB9ojt5Uc
         bcxl4HFFftcGCNxy/JbQtIlf0oX7Npmr7ZX5ppRmQ9eg2xkCjNG6+vLl9WdCtDke3V/J
         6l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702908009; x=1703512809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rhLwUQ1ywrBkBuwEQIDGD2rpJ8EK3ecZScs+lwiHfY=;
        b=XTjMg+svlI2YtX2HdaWQ97BV8y7xcjLFgq6RQTzz+xNlmDUZTBBMe5LPC1dyPqAQPZ
         ODnugi5+BHPiX0WSNylIRO0yF03Wu+zfiezhirY7/BLJYuSH6B0L7EPRaRrQJTXQ34O7
         DjcnGC7F/EdpLClc98FkzX2jCIWiEr7i8VYLdiGPD2oWTbEtr47kcstf/GDVUA2b0K5W
         pcRb3hHTL1JAr6Jp93kVCI+WDOV/ol+QVEc0lyIcS5cRJQ/bIax+BdF4CIkLcvLPgRED
         bS4dXJHgJiz2GWVo1PXpPohztvSqvmIuaX4UEDNt7A3nvnXdccruHtU5wHzSA52B1pgp
         mIqg==
X-Gm-Message-State: AOJu0YxG4f3ZWkowYxXqorUNQ5YqnKdYHGFo7FWzmOmAWwfxRDFLDv5y
	Grfz9vf5GUIUgcn4dRa6dG6EiUNK5Ps5jMVqkqQ=
X-Google-Smtp-Source: AGHT+IHEoseKyYRphf3NMbsIOuRZOeFVPDEEXSm6Ts7CS70/UVcEBiTuIn3NWzoz1j965+zBJY2oLLctkSjyPvjToeI=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3b95:b0:407:8ee2:998c with
 SMTP id n21-20020a05600c3b9500b004078ee2998cmr167649wms.3.1702908009341; Mon,
 18 Dec 2023 06:00:09 -0800 (PST)
Date: Mon, 18 Dec 2023 13:59:00 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-12-sebastianene@google.com>
Subject: [PATCH v4 10/10] arm64: ptdump: Add guest stage-2 pagetables dumping
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

Register a debugfs file on guest creation to be able to view their
second translation tables with ptdump. This assumes that the host is in
control of the guest stage-2 and has direct access to the pagetables.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/debug.c      |  6 ++++++
 arch/arm64/kvm/kvm_ptdump.h |  3 +++
 arch/arm64/kvm/ptdump.c     | 35 ++++++++++++++++++++++++++++++++---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 8725291cb..7c4c2902d 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
+#include <kvm_ptdump.h>
 
 #include "trace.h"
 
@@ -342,3 +343,8 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 }
+
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return kvm_ptdump_register_guest(kvm);
+}
diff --git a/arch/arm64/kvm/kvm_ptdump.h b/arch/arm64/kvm/kvm_ptdump.h
index 98b595ce8..5f5a455d0 100644
--- a/arch/arm64/kvm/kvm_ptdump.h
+++ b/arch/arm64/kvm/kvm_ptdump.h
@@ -6,13 +6,16 @@
 #ifndef __KVM_PTDUMP_H
 #define __KVM_PTDUMP_H
 
+#include <linux/kvm_host.h>
 #include <asm/ptdump.h>
 
 
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 void kvm_ptdump_register_host(void);
+int kvm_ptdump_register_guest(struct kvm *kvm);
 #else
 static inline void kvm_ptdump_register_host(void) { }
+static inline int kvm_ptdump_register_guest(struct kvm *kvm) { return -1; }
 #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
 
 #endif /* __KVM_PTDUMP_H */
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 4296e739f..62a753d6b 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -181,6 +181,8 @@ static int kvm_ptdump_open(struct inode *inode, struct file *file)
 		info = reg->get_ptdump_info(reg);
 		if (!info)
 			return -ENOMEM;
+	} else {
+		info = inode->i_private;
 	}
 
 	if (!reg->show_ptdump_info)
@@ -239,15 +241,14 @@ static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-static int kvm_ptdump_show(struct seq_file *m, void *)
+static int kvm_ptdump_show_common(struct seq_file *m,
+				  struct kvm_pgtable *pgtable)
 {
 	u64 ipa_size;
 	char ipa_description[32];
 	struct pg_state st;
 	struct addr_marker ipa_addr_markers[3] = {0};
 	struct pg_level pg_level_descr[KVM_PGTABLE_MAX_LEVELS] = {0};
-	struct kvm_pgtable_snapshot *snapshot = m->private;
-	struct kvm_pgtable *pgtable = &snapshot->pgtable;
 	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
 		.cb	= kvm_ptdump_visitor,
 		.arg	= &st,
@@ -282,6 +283,26 @@ static int kvm_ptdump_show(struct seq_file *m, void *)
 	return kvm_pgtable_walk(pgtable, 0, ipa_size, &walker);
 }
 
+static int kvm_host_ptdump_show(struct seq_file *m, void *)
+{
+	struct kvm_pgtable_snapshot *snapshot = m->private;
+
+	return kvm_ptdump_show_common(m, &snapshot->pgtable);
+}
+
+static int kvm_ptdump_show(struct seq_file *m, void *)
+{
+	struct kvm *guest_kvm = m->private;
+	struct kvm_s2_mmu *mmu = &guest_kvm->arch.mmu;
+	int ret;
+
+	write_lock(&guest_kvm->mmu_lock);
+	ret = kvm_ptdump_show_common(m, mmu->pgt);
+	write_unlock(&guest_kvm->mmu_lock);
+
+	return ret;
+}
+
 static void kvm_ptdump_debugfs_register(struct kvm_ptdump_register *reg,
 					const char *name, struct dentry *parent)
 {
@@ -393,11 +414,19 @@ void kvm_ptdump_register_host(void)
 
 	host_reg.get_ptdump_info = kvm_host_get_ptdump_info;
 	host_reg.put_ptdump_info = kvm_host_put_ptdump_info;
+	host_reg.show_ptdump_info = kvm_host_ptdump_show;
 
 	kvm_ptdump_debugfs_register(&host_reg, "host_page_tables",
 				    kvm_debugfs_dir);
 }
 
+int kvm_ptdump_register_guest(struct kvm *kvm)
+{
+	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_ptdump_fops);
+	return 0;
+}
+
 static int __init kvm_host_ptdump_init(void)
 {
 	host_reg.priv = (void *)host_s2_pgtable_pages();
-- 
2.43.0.472.g3155946c3a-goog

