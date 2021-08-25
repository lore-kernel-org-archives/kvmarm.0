Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208BFC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C905B61153
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C905B61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FAD04B1F5;
	Wed, 25 Aug 2021 12:18:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8CGi8Gl5M1QX; Wed, 25 Aug 2021 12:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C76044B28B;
	Wed, 25 Aug 2021 12:17:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 341CF4B266
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zuLxYaFjTuEu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6834B294
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4B271063;
 Wed, 25 Aug 2021 09:17:37 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84A1A3F66F;
 Wed, 25 Aug 2021 09:17:36 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 16/39] KVM: arm64: Make SPE available when at least one
 CPU supports it
Date: Wed, 25 Aug 2021 17:17:52 +0100
Message-Id: <20210825161815.266051-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

KVM SPE emulation requires at least one physical CPU to support SPE.
Initialize the cpumask of PEs that support SPE the first time
KVM_CAP_ARM_SPE is queried or when the first virtual machine is created,
whichever comes first.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/Makefile          |  1 +
 arch/arm64/kvm/arm.c             |  4 ++++
 arch/arm64/kvm/spe.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/spe.c

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
new file mode 100644
index 000000000000..328115ce0b48
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#ifndef __ARM64_KVM_SPE_H__
+#define __ARM64_KVM_SPE_H__
+
+#ifdef CONFIG_KVM_ARM_SPE
+DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static __always_inline bool kvm_supports_spe(void)
+{
+	return static_branch_likely(&kvm_spe_available);
+}
+
+void kvm_spe_init_supported_cpus(void);
+void kvm_spe_vm_init(struct kvm *kvm);
+#else
+#define kvm_supports_spe()	(false)
+
+static inline void kvm_spe_init_supported_cpus(void) {}
+static inline void kvm_spe_vm_init(struct kvm *kvm) {}
+#endif /* CONFIG_KVM_ARM_SPE */
+
+#endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..86092a0f8367 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+kvm-$(CONFIG_KVM_ARM_SPE)     += spe.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 22544eb367f3..82cb7b5b3b45 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -35,6 +35,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_spe.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
@@ -180,6 +181,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 
+	kvm_spe_vm_init(kvm);
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
@@ -305,6 +308,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SPE:
+		kvm_spe_init_supported_cpus();
 		r = 0;
 		break;
 	default:
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
new file mode 100644
index 000000000000..83f92245f881
--- /dev/null
+++ b/arch/arm64/kvm/spe.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#include <linux/cpumask.h>
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+
+#include <asm/kvm_spe.h>
+
+DEFINE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static const cpumask_t *supported_cpus;
+
+void kvm_spe_init_supported_cpus(void)
+{
+	if (likely(supported_cpus))
+		return;
+
+	supported_cpus = arm_spe_pmu_supported_cpus();
+	BUG_ON(!supported_cpus);
+
+	if (!cpumask_empty(supported_cpus))
+		static_branch_enable(&kvm_spe_available);
+}
+
+void kvm_spe_vm_init(struct kvm *kvm)
+{
+	/* Set supported_cpus if it isn't already initialized. */
+	kvm_spe_init_supported_cpus();
+}
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
