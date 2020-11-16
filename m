Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF89EC4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C55E22245
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="fuyl7aAN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C55E22245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C5A4C288;
	Mon, 16 Nov 2020 15:43:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NxEIJbiZhUar; Mon, 16 Nov 2020 15:43:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 908234C270;
	Mon, 16 Nov 2020 15:43:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6812F4C228
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DXpI+5F7SQim for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:50 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CBD74C246
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:50 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id d142so590198wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qG/HoneOc994OJu++CpnomVnwB4P/ZTLebHJA4Q7lT4=;
 b=fuyl7aANEA8fwOLCn2RRwgCPg5sH4c3V57+KawyAxxoLb7efdJQZXGdT9w5DVinpSN
 p2cAZJJWwFiJGbY03YsNvgLfePDdDVDyDPwOMDf/VM7RYux4B6QAjpaMrNMdIhM2JrsN
 F8/TRQQH4URgM1anQ1ZAltLVCT4z9ckQp5p08BYXpuYeiA5tS7vX6pKlf9hEYaW2vPc8
 LWhKPK+b9hxepoECbGLi31tWLqhNOzvRoPIjHvF/XPajEqHh29e1qKoQCVrXM+XHJ+ZV
 ayVTPHi56g7rqfkgAjMCABWTBv39onhqdO/kne03yfewB09hmJUpxDdqQNE33LiVwuUS
 t7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qG/HoneOc994OJu++CpnomVnwB4P/ZTLebHJA4Q7lT4=;
 b=t15qQ5RrBQFmrlF1ivnB9rplbXLw05KVrCWe5TDraVZd3b5GN+PXr9BNmnEBZ9wFDa
 6g8VhGo9reLHtP1XJBpucy+dR9nGxj867i1FeFl6XhR3ybZ1O6X7xa8wZXdbjJlWZSmA
 RwXS4GVrEaO36IK9UB2bq7n4dj16PI+4zMgHLr2aeGcPSfG8ngWSxaX/M2GMBRKHbxZ6
 iyXL0rU3knU7X9H/uA3QUDi33IurrQDhQ97ZXgl4ngqASXYckl33y/e+xdiU1qJDowgm
 /+XdHOOfCWK1cCI6lvvGvFLqsyt3EmP5tu4zbaRkCyVZF6Tc3gTleWfIKWj39kQPvk1S
 XTEg==
X-Gm-Message-State: AOAM5339ftrz4ykijD9+9IKQSBNSsjNaAUJWROSJFOnAznhixBgTb1Ec
 5qS02InJMesV6n2CVzwgDxj/RKRcYA9D+E6GQPU=
X-Google-Smtp-Source: ABdhPJxfClLB31DdeOwu1p+YEOfV5ZETCzlEf+2nxs/8En6SPZQsIjrNlyxxoKIEEk3UhvuOE17GgQ==
X-Received: by 2002:a1c:2586:: with SMTP id l128mr656447wml.149.1605559428664; 
 Mon, 16 Nov 2020 12:43:48 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id f17sm562523wmh.10.2020.11.16.12.43.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:47 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 12/24] kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
Date: Mon, 16 Nov 2020 20:43:06 +0000
Message-Id: <20201116204318.63987-13-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Add a handler of PSCI SMCs in nVHE hyp code. The handler is initialized
with the version used by the host's PSCI driver and the function IDs it
was configured with. If the SMC function ID matches one of the
configured PSCI calls (for v0.1) or falls into the PSCI function ID
range (for v0.2+), the SMC is handled by the PSCI handler. For now, all
SMCs return PSCI_RET_NOT_SUPPORTED.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h     |   4 ++
 arch/arm64/kvm/arm.c                 |  14 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile     |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |   6 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 104 +++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci-relay.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a3289071f3d8..95a2bbbcc7e1 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -96,6 +96,10 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
+#endif
+
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cdd7981ea560..7d2270eeecfb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/psci.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -1514,6 +1515,18 @@ static void init_cpu_logical_map(void)
 		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
 }
 
+static void init_psci_relay(void)
+{
+	extern u32 kvm_nvhe_sym(kvm_host_psci_version);
+	extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
+	int i;
+
+	CHOOSE_NVHE_SYM(kvm_host_psci_version) = psci_ops.get_version
+		? psci_ops.get_version() : PSCI_VERSION(0, 0);
+	for (i = 0; i < PSCI_FN_MAX; ++i)
+		CHOOSE_NVHE_SYM(kvm_host_psci_function_id)[i] = psci_get_function_id(i);
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1693,6 +1706,7 @@ static int init_hyp_mode(void)
 	}
 
 	init_cpu_logical_map();
+	init_psci_relay();
 
 	return 0;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 2d842e009a40..bf62c8e42ab2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o
+	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 71a17af05953..df4acb40dd39 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -120,7 +120,11 @@ static void skip_host_instruction(void)
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 {
-	default_host_smc_handler(host_ctxt);
+	bool handled;
+
+	handled = kvm_host_psci_handler(host_ctxt);
+	if (!handled)
+		default_host_smc_handler(host_ctxt);
 
 	/*
 	 * Unlike HVC, the return address of an SMC is the instruction's PC.
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
new file mode 100644
index 000000000000..d75d3f896bfd
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: David Brazdil <dbrazdil@google.com>
+ */
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <kvm/arm_hypercalls.h>
+#include <linux/arm-smccc.h>
+#include <linux/psci.h>
+#include <kvm/arm_psci.h>
+#include <uapi/linux/psci.h>
+
+/* Config options set by the host. */
+u32 __ro_after_init kvm_host_psci_version = PSCI_VERSION(0, 0);
+u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
+
+static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
+{
+	return host_ctxt->regs.regs[0];
+}
+
+static bool is_psci_0_1_call(u64 func_id)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_host_psci_function_id); ++i) {
+		if (func_id == kvm_host_psci_function_id[i])
+			return true;
+	}
+	return false;
+}
+
+static bool is_psci_0_2_call(u64 func_id)
+{
+	/* SMCCC reserves IDs 0x00-1F with the given 32/64-bit base for PSCI. */
+	return (PSCI_0_2_FN(0) <= func_id && func_id <= PSCI_0_2_FN(31)) ||
+	       (PSCI_0_2_FN64(0) <= func_id && func_id <= PSCI_0_2_FN64(31));
+}
+
+static bool is_psci_call(u64 func_id)
+{
+	switch (kvm_host_psci_version) {
+	case PSCI_VERSION(0, 0):
+		return false;
+	case PSCI_VERSION(0, 1):
+		return is_psci_0_1_call(func_id);
+	default:
+		return is_psci_0_2_call(func_id);
+	}
+}
+
+static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	return PSCI_RET_NOT_SUPPORTED;
+}
+
+static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	switch (func_id) {
+	default:
+		return PSCI_RET_NOT_SUPPORTED;
+	}
+}
+
+static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	switch (func_id) {
+	default:
+		return psci_0_2_handler(func_id, host_ctxt);
+	}
+}
+
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
+{
+	u64 func_id = get_psci_func_id(host_ctxt);
+	unsigned long ret;
+
+	if (!is_psci_call(func_id))
+		return false;
+
+	switch (kvm_host_psci_version) {
+	case PSCI_VERSION(0, 0):
+		ret = PSCI_RET_NOT_SUPPORTED;
+		break;
+	case PSCI_VERSION(0, 1):
+		ret = psci_0_1_handler(func_id, host_ctxt);
+		break;
+	case PSCI_VERSION(0, 2):
+		ret = psci_0_2_handler(func_id, host_ctxt);
+		break;
+	default:
+		ret = psci_1_0_handler(func_id, host_ctxt);
+		break;
+	}
+
+	host_ctxt->regs.regs[0] = ret;
+	host_ctxt->regs.regs[1] = 0;
+	host_ctxt->regs.regs[2] = 0;
+	host_ctxt->regs.regs[3] = 0;
+	return true;
+}
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
