Return-Path: <SRS0=xA+Y=WP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC57C3A5A0
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 14:04:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91C7620989
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 14:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91C7620989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8FC4A5B7;
	Mon, 19 Aug 2019 10:04:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IjLmUV2xtiuS; Mon, 19 Aug 2019 10:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF384A5CF;
	Mon, 19 Aug 2019 10:04:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D1F4A5C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 10:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K4kW-ZaGNmJQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Aug 2019 10:04:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D72C24A5CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 10:04:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90980360;
 Mon, 19 Aug 2019 07:04:48 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5953F3F718;
 Mon, 19 Aug 2019 07:04:46 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/9] KVM: arm/arm64: Factor out hypercall handling from
 PSCI code
Date: Mon, 19 Aug 2019 15:04:29 +0100
Message-Id: <20190819140436.12207-3-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819140436.12207-1-steven.price@arm.com>
References: <20190819140436.12207-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

We currently intertwine the KVM PSCI implementation with the general
dispatch of hypercall handling, which makes perfect sense because PSCI
is the only category of hypercalls we support.

However, as we are about to support additional hypercalls, factor out
this functionality into a separate hypercall handler file.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[steven.price@arm.com: rebased]
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm/kvm/Makefile        |  2 +-
 arch/arm/kvm/handle_exit.c   |  2 +-
 arch/arm64/kvm/Makefile      |  1 +
 arch/arm64/kvm/handle_exit.c |  4 +-
 include/kvm/arm_hypercalls.h | 43 ++++++++++++++++++
 include/kvm/arm_psci.h       |  2 +-
 virt/kvm/arm/hypercalls.c    | 59 +++++++++++++++++++++++++
 virt/kvm/arm/psci.c          | 84 +-----------------------------------
 8 files changed, 110 insertions(+), 87 deletions(-)
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 531e59f5be9c..ef4d01088efc 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -23,7 +23,7 @@ obj-y += kvm-arm.o init.o interrupts.o
 obj-y += handle_exit.o guest.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o   vgic-v3-coproc.o
 obj-y += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
-obj-y += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
+obj-y += $(KVM)/arm/psci.o $(KVM)/arm/perf.o $(KVM)/arm/hypercalls.o
 obj-y += $(KVM)/arm/aarch32.o
 
 obj-y += $(KVM)/arm/vgic/vgic.o
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 2a6a1394d26e..e58a89d2f13f 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -9,7 +9,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
-#include <kvm/arm_psci.h>
+#include <kvm/arm_hypercalls.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3ac1a64d2fb9..73dce4d47d47 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 706cca23f0d2..aacfc55de44c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -11,8 +11,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/esr.h>
 #include <asm/exception.h>
 #include <asm/kvm_asm.h>
@@ -22,6 +20,8 @@
 #include <asm/debug-monitors.h>
 #include <asm/traps.h>
 
+#include <kvm/arm_hypercalls.h>
+
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
new file mode 100644
index 000000000000..35a5abcc4ca3
--- /dev/null
+++ b/include/kvm/arm_hypercalls.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019 Arm Ltd. */
+
+#ifndef __KVM_ARM_HYPERCALLS_H
+#define __KVM_ARM_HYPERCALLS_H
+
+#include <asm/kvm_emulate.h>
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+
+static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 0);
+}
+
+static inline unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 1);
+}
+
+static inline unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 2);
+}
+
+static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 3);
+}
+
+static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
+			     unsigned long a0,
+			     unsigned long a1,
+			     unsigned long a2,
+			     unsigned long a3)
+{
+	vcpu_set_reg(vcpu, 0, a0);
+	vcpu_set_reg(vcpu, 1, a1);
+	vcpu_set_reg(vcpu, 2, a2);
+	vcpu_set_reg(vcpu, 3, a3);
+}
+
+#endif
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 632e78bdef4d..5b58bd2fe088 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -40,7 +40,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
 }
 
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+int kvm_psci_call(struct kvm_vcpu *vcpu);
 
 struct kvm_one_reg;
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
new file mode 100644
index 000000000000..f875241bd030
--- /dev/null
+++ b/virt/kvm/arm/hypercalls.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Arm Ltd.
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_psci.h>
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func_id = smccc_get_function(vcpu);
+	u32 val = SMCCC_RET_NOT_SUPPORTED;
+	u32 feature;
+
+	switch (func_id) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		val = ARM_SMCCC_VERSION_1_1;
+		break;
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_SMCCC_ARCH_WORKAROUND_1:
+			switch (kvm_arm_harden_branch_predictor()) {
+			case KVM_BP_HARDEN_UNKNOWN:
+				break;
+			case KVM_BP_HARDEN_WA_NEEDED:
+				val = SMCCC_RET_SUCCESS;
+				break;
+			case KVM_BP_HARDEN_NOT_REQUIRED:
+				val = SMCCC_RET_NOT_REQUIRED;
+				break;
+			}
+			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_2:
+			switch (kvm_arm_have_ssbd()) {
+			case KVM_SSBD_FORCE_DISABLE:
+			case KVM_SSBD_UNKNOWN:
+				break;
+			case KVM_SSBD_KERNEL:
+				val = SMCCC_RET_SUCCESS;
+				break;
+			case KVM_SSBD_FORCE_ENABLE:
+			case KVM_SSBD_MITIGATED:
+				val = SMCCC_RET_NOT_REQUIRED;
+				break;
+			}
+			break;
+		}
+		break;
+	default:
+		return kvm_psci_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 87927f7e1ee7..17e2bdd4b76f 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_host.h>
 
 #include <kvm/arm_psci.h>
+#include <kvm/arm_hypercalls.h>
 
 /*
  * This is an implementation of the Power State Coordination Interface
@@ -23,38 +24,6 @@
 
 #define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
 
-static u32 smccc_get_function(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 0);
-}
-
-static unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 1);
-}
-
-static unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 2);
-}
-
-static unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 3);
-}
-
-static void smccc_set_retval(struct kvm_vcpu *vcpu,
-			     unsigned long a0,
-			     unsigned long a1,
-			     unsigned long a2,
-			     unsigned long a3)
-{
-	vcpu_set_reg(vcpu, 0, a0);
-	vcpu_set_reg(vcpu, 1, a1);
-	vcpu_set_reg(vcpu, 2, a2);
-	vcpu_set_reg(vcpu, 3, a3);
-}
-
 static unsigned long psci_affinity_mask(unsigned long affinity_level)
 {
 	if (affinity_level <= 3)
@@ -373,7 +342,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  * Errors:
  * -EINVAL: Unrecognized PSCI function
  */
-static int kvm_psci_call(struct kvm_vcpu *vcpu)
+int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
 	case KVM_ARM_PSCI_1_0:
@@ -387,55 +356,6 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
 	};
 }
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
-{
-	u32 func_id = smccc_get_function(vcpu);
-	u32 val = SMCCC_RET_NOT_SUPPORTED;
-	u32 feature;
-
-	switch (func_id) {
-	case ARM_SMCCC_VERSION_FUNC_ID:
-		val = ARM_SMCCC_VERSION_1_1;
-		break;
-	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-		feature = smccc_get_arg1(vcpu);
-		switch(feature) {
-		case ARM_SMCCC_ARCH_WORKAROUND_1:
-			switch (kvm_arm_harden_branch_predictor()) {
-			case KVM_BP_HARDEN_UNKNOWN:
-				break;
-			case KVM_BP_HARDEN_WA_NEEDED:
-				val = SMCCC_RET_SUCCESS;
-				break;
-			case KVM_BP_HARDEN_NOT_REQUIRED:
-				val = SMCCC_RET_NOT_REQUIRED;
-				break;
-			}
-			break;
-		case ARM_SMCCC_ARCH_WORKAROUND_2:
-			switch (kvm_arm_have_ssbd()) {
-			case KVM_SSBD_FORCE_DISABLE:
-			case KVM_SSBD_UNKNOWN:
-				break;
-			case KVM_SSBD_KERNEL:
-				val = SMCCC_RET_SUCCESS;
-				break;
-			case KVM_SSBD_FORCE_ENABLE:
-			case KVM_SSBD_MITIGATED:
-				val = SMCCC_RET_NOT_REQUIRED;
-				break;
-			}
-			break;
-		}
-		break;
-	default:
-		return kvm_psci_call(vcpu);
-	}
-
-	smccc_set_retval(vcpu, val, 0, 0, 0);
-	return 1;
-}
-
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
 	return 3;		/* PSCI version and two workaround registers */
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
