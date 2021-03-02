Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E157BC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D00464F3A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D00464F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C464B650;
	Tue,  2 Mar 2021 10:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BS7PK3yIwRql; Tue,  2 Mar 2021 10:00:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE14F4B649;
	Tue,  2 Mar 2021 10:00:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 773694B66D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-FbF55LtIyI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:30 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D7CA4B64E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:30 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id q24so1320180wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=02sj0LTqbtTGnTkyaLnw9s9OCSKkaVL1IC7xFtrVu+I=;
 b=kMg+U+Xw7UPztIEgGwxp8ej4zksed9nn61/tmYFKd9Kot6UNliiXUFLWe7Hl6eFhKa
 gFiPBs/PkKuSn8NSR5OXGwDNUSxGD3ygLSPmXaDVSgAXgz9/XwpNPzic2kw3nzgbmt1M
 iXSbdI+NYj0e5B1CdYiAlvTT26Hhhe1ycMpRXg5DuuRiX8unpL3UF1NowNzIPRrdITEY
 qIGnWuGclkBbcy/wAbnZpsDgxPmmlHQKQxsm3jgdexP8fS2uWWlX5nyrsIGfmdDen1k+
 AQJiTX/I5tiMF2f/6re4RQgccxrMvyigksNPimTItjsJgaMCI8iBrzykdv9dnT+5gCa6
 L2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=02sj0LTqbtTGnTkyaLnw9s9OCSKkaVL1IC7xFtrVu+I=;
 b=C8XgIk2HSIyWZITW/HvtuVty7S0h5dagE8hGSaVsK+Dj2p2qzQjMiKnsQhI5REgIAS
 BUvkU7QpQHdl2KYqt7nBvcheg9TxHJx23Gmrs6zy2yRiW9kFhda920Qt9CQQlWCQgIIy
 J4tmtzqcEHhv/o57ZFtP62tNwIcJ4fHs752Wuz7gj6aSgSzWLI/39kEzsiNwgeaKg83r
 +A3gcC1TNrKxzSxjdt855puL1MTPxGRa5ZW2LLt9r8vQWtkqE7nGbAWkB9xJjt0NM9oF
 eQArZkcnAsQYHx4mQFPlCnL9IRqrEuW3pE4FIrjx2j9rX4XT6FDbXjYsA+hyzgOFpixj
 Pw6A==
X-Gm-Message-State: AOAM531IIl5RjCa+xqNd262b8Jt2CxEn24AZ/pVYLfH23/mpMliG187l
 mcw4F8p+yGboRieahrsyZdCOO8BNfSep
X-Google-Smtp-Source: ABdhPJyUW2GTOBiNzcvUxp3QcWXsso1W4SzADKlj626x0ZTBaB7QQ69cNw4QBANWnStsF+W5woTPkEz9iXQP
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:2e90:: with SMTP id
 u138mr496449wmu.0.1614697228949; Tue, 02 Mar 2021 07:00:28 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:40 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-11-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 10/32] KVM: arm64: Introduce an early Hyp page allocator
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
