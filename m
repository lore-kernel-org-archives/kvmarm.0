Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6983FC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 238966109E
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 238966109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6A74B162;
	Wed, 13 Oct 2021 08:04:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dLHWTrupfLbO; Wed, 13 Oct 2021 08:04:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F604B176;
	Wed, 13 Oct 2021 08:04:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E87814B099
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CGaTud7G0H19 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 08:04:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CDE24B125
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:02 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3D724610F9;
 Wed, 13 Oct 2021 12:04:02 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1maczI-00GTgY-FQ; Wed, 13 Oct 2021 13:04:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 19/22] KVM: arm64: pkvm: Consolidate include files
Date: Wed, 13 Oct 2021 13:03:43 +0100
Message-Id: <20211013120346.2926621-9-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

kvm_fixed_config.h is pkvm specific, and would be better placed
near its users. At the same time, include/nvhe/sys_regs.h is now
almost empty.

Merge the two into arch/arm64/kvm/hyp/include/nvhe/fixed_config.h.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../hyp/include/nvhe/fixed_config.h}            |  5 +++++
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h      | 17 -----------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                  |  3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c                 |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                |  3 +--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c              |  3 +--
 6 files changed, 9 insertions(+), 24 deletions(-)
 rename arch/arm64/{include/asm/kvm_fixed_config.h => kvm/hyp/include/nvhe/fixed_config.h} (96%)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h

diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
similarity index 96%
rename from arch/arm64/include/asm/kvm_fixed_config.h
rename to arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 0ed06923f7e9..747fc79ae784 100644
--- a/arch/arm64/include/asm/kvm_fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -192,4 +192,9 @@
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_I8MM) \
 	)
 
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+int kvm_check_pvm_sysreg_table(void);
+void inject_undef64(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
deleted file mode 100644
index 8adc13227b1a..000000000000
--- a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Google LLC
- * Author: Fuad Tabba <tabba@google.com>
- */
-
-#ifndef __ARM64_KVM_NVHE_SYS_REGS_H__
-#define __ARM64_KVM_NVHE_SYS_REGS_H__
-
-#include <asm/kvm_host.h>
-
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
-bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
-int kvm_check_pvm_sysreg_table(void);
-void inject_undef64(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM64_KVM_NVHE_SYS_REGS_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 62377fa8a4cb..99c8d8b73e70 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -6,8 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
-#include <asm/kvm_fixed_config.h>
-#include <nvhe/sys_regs.h>
+#include <nvhe/fixed_config.h>
 #include <nvhe/trap_handler.h>
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c85ff64e63f2..862c7b514e20 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,11 +10,11 @@
 #include <asm/kvm_pgtable.h>
 
 #include <nvhe/early_alloc.h>
+#include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
-#include <nvhe/sys_regs.h>
 #include <nvhe/trap_handler.h>
 
 struct hyp_pool hpool;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 481c365ef144..317dba6a018d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,7 +20,6 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -28,8 +27,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
-#include <nvhe/sys_regs.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a341bd8ef252..052f885e65b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -7,12 +7,11 @@
 #include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_mmu.h>
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/sys_regs.h>
+#include <nvhe/fixed_config.h>
 
 #include "../../sys_regs.h"
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
