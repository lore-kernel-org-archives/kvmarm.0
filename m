Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275DDC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B51ED64F68
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B51ED64F68
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A694B3AF;
	Fri, 19 Mar 2021 06:02:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HiLxyJWe0ECw; Fri, 19 Mar 2021 06:02:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D014B67F;
	Fri, 19 Mar 2021 06:02:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5874B6B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id plQ0WnxhLqHb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:12 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20B3F4B611
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:12 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id w10so8102110wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/O7aUiBDNsDlC5JEdHFVg6as0eZObhOTRgLXX/tsqoQ=;
 b=WNNJZE8qr37DbOFirQKPXh0ilrsL35bpotEEfPL4GIDnAGf83WSEoYAFSKyVDQg4Dv
 uH0PSU3A/mTBU/ymqhA/7TJHxHLLuEw0Z9JKZDj1tQ0vKRR7GPQ52+MU0hwODcMecVZh
 YNo29OAzVgbgW6CCD/cwVoe/Hvx8Kunr4LS94Cm4X/8TQTlpbFtfzLpibxT5kizmLxLH
 yPrDgQpcaLnG0y5elHe+X00nuogIHS0pX6vJ5Q565khsEygcTfCbYGG5BaRjFfiCMqkB
 qFahk60ObHZ+kSFhim3xoBSywr+B4uvmXEgwEgXliwMj3ukSXmJaAHFXAeYh5HT2+iXK
 a1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/O7aUiBDNsDlC5JEdHFVg6as0eZObhOTRgLXX/tsqoQ=;
 b=Ibmtxaq7FjPlDb/m8LJAV6ASI70Aqn2hHjkUhVx972CXsoZ7H766OBvbnJKMIMRlJ9
 L/gCq1Isr99VqQfHU271jSBIMllm4IQD0u8BStZT//WNl2QM3yYRpe0hrj41QhLCvoFb
 avlBoZr+sorSYedkhukDQmDSm3JZzE3lDbpSDnHIZWl2ypcklGwk2kVoX75KVSzy2+wQ
 iWUK/wtHV06rHxW/tpX/OsZciMmDkEdTNEulBhFJmvPWlXWoIXF+HWPfg0c1qSMSMweh
 7kvCXzpKHdMRYBzSDBZ5g3IQ9Xngpe633fEgf2cbHkSbq+U3kyEvaL7gqhrGZ2GHMW5w
 vkug==
X-Gm-Message-State: AOAM533cQ2GeWPOsVVk8FAnumX0B70uYv+Ogdr1msmAYx3IP9pb12eb/
 GT7c39INPqzIv4pheIzQDhOGNQPjqAuG
X-Google-Smtp-Source: ABdhPJy7h2Z9frkRy50wNm9TkLnxcRuB4brqwVdWaAeCo3ystEpzQq7HI2RVdi5BxK/zXyY0afEp5oSdIpy9
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:190a:: with SMTP id
 j10mr2947925wmq.140.1616148131289; Fri, 19 Mar 2021 03:02:11 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:18 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-11-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 10/38] KVM: arm64: Introduce an early Hyp page allocator
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

With nVHE, the host currently creates all stage 1 hypervisor mappings at
EL1 during boot, installs them at EL2, and extends them as required
(e.g. when creating a new VM). But in a world where the host is no
longer trusted, it cannot have full control over the code mapped in the
hypervisor.

In preparation for enabling the hypervisor to create its own stage 1
mappings during boot, introduce an early page allocator, with minimal
functionality. This allocator is designed to be used only during early
bootstrap of the hyp code when memory protection is enabled, which will
then switch to using a full-fledged page allocator after init.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 14 +++++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      | 24 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile              |  2 +-
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 54 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |  4 +-
 5 files changed, 94 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/early_alloc.c

diff --git a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
new file mode 100644
index 000000000000..dc61aaa56f31
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_HYP_EARLY_ALLOC_H
+#define __KVM_HYP_EARLY_ALLOC_H
+
+#include <asm/kvm_pgtable.h>
+
+void hyp_early_alloc_init(void *virt, unsigned long size);
+unsigned long hyp_early_alloc_nr_used_pages(void);
+void *hyp_early_alloc_page(void *arg);
+void *hyp_early_alloc_contig(unsigned int nr_pages);
+
+extern struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
+
+#endif /* __KVM_HYP_EARLY_ALLOC_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
new file mode 100644
index 000000000000..3e49eaa7e682
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_HYP_MEMORY_H
+#define __KVM_HYP_MEMORY_H
+
+#include <asm/page.h>
+
+#include <linux/types.h>
+
+extern s64 hyp_physvirt_offset;
+
+#define __hyp_pa(virt)	((phys_addr_t)(virt) + hyp_physvirt_offset)
+#define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
+
+static inline void *hyp_phys_to_virt(phys_addr_t phys)
+{
+	return __hyp_va(phys);
+}
+
+static inline phys_addr_t hyp_virt_to_phys(void *addr)
+{
+	return __hyp_pa(addr);
+}
+
+#endif /* __KVM_HYP_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index bc98f8e3d1da..24ff99e2eac5 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,7 +13,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
new file mode 100644
index 000000000000..1306c430ab87
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <asm/kvm_pgtable.h>
+
+#include <nvhe/early_alloc.h>
+#include <nvhe/memory.h>
+
+struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
+s64 __ro_after_init hyp_physvirt_offset;
+
+static unsigned long base;
+static unsigned long end;
+static unsigned long cur;
+
+unsigned long hyp_early_alloc_nr_used_pages(void)
+{
+	return (cur - base) >> PAGE_SHIFT;
+}
+
+void *hyp_early_alloc_contig(unsigned int nr_pages)
+{
+	unsigned long size = (nr_pages << PAGE_SHIFT);
+	void *ret = (void *)cur;
+
+	if (!nr_pages)
+		return NULL;
+
+	if (end - cur < size)
+		return NULL;
+
+	cur += size;
+	memset(ret, 0, size);
+
+	return ret;
+}
+
+void *hyp_early_alloc_page(void *arg)
+{
+	return hyp_early_alloc_contig(1);
+}
+
+void hyp_early_alloc_init(void *virt, unsigned long size)
+{
+	base = cur = (unsigned long)virt;
+	end = base + size;
+
+	hyp_early_alloc_mm_ops.zalloc_page = hyp_early_alloc_page;
+	hyp_early_alloc_mm_ops.phys_to_virt = hyp_phys_to_virt;
+	hyp_early_alloc_mm_ops.virt_to_phys = hyp_virt_to_phys;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 63de71c0481e..08508783ec3d 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -11,6 +11,7 @@
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
+#include <nvhe/memory.h>
 #include <nvhe/trap_handler.h>
 
 void kvm_hyp_cpu_entry(unsigned long r0);
@@ -20,9 +21,6 @@ void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 
 /* Config options set by the host. */
 struct kvm_host_psci_config __ro_after_init kvm_host_psci_config;
-s64 __ro_after_init hyp_physvirt_offset;
-
-#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
 #define INVALID_CPU_ID	UINT_MAX
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
