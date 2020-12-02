Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCEEC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B92222254
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B92222254
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D86AE4B42E;
	Wed,  2 Dec 2020 13:42:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PsKWHPCivzAV; Wed,  2 Dec 2020 13:42:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8384B430;
	Wed,  2 Dec 2020 13:42:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6FB4B2CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Zw2S4kVpVt0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:04 -0500 (EST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EF2A4B443
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:04 -0500 (EST)
Received: by mail-wm1-f51.google.com with SMTP id g185so11112986wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=6AhUStd7TBYIRUbzKUC2M2YnuRgkt1Z1iWT0O/bo9W0=;
 b=SCYRPSh79TxoJZNYfwyvOM/BXZdHbkWon/aDDEt3ZW9Q4oq9R/Dm4W4KJlfMOHwrln
 BiRJLP/i1pQTRQQBGub1VWGlijOCHjhwJ1cUH73e3gxiu3tq5ao5sacWS9lAhhat+lWJ
 Fkziz6mvwdIha5xDHzagmZVUFnmNr/joylWFtwKOeepPe5Dl4XO/WnqCfW5SXoLvxi0C
 CHPbG+V/tuh6ggq8fcWu6tT7w3r06y2gx5rW7+0npJVz6HKSWxrc3h3eWkiARPTZv1hV
 KB1I298E2fte3MlmTytl5cfccjoDq+WdLWpHPOVBeuG1srhhVy8g+0Y3DUDpEWMdOqTU
 u0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6AhUStd7TBYIRUbzKUC2M2YnuRgkt1Z1iWT0O/bo9W0=;
 b=Imxpc0HDqh/R/JzSCFp+dX8j4ZPuzVYvj0RYAoxrZ1K5Rdgldw4qMkhB+2q91dHtv+
 kT4mLxUyGNTF2M7it4VQ7rbCfnj3On5b00l3ZW5KdM7vSskDFK0UO/8e7hAaIctN0axl
 gpEUrEdry4fAgxgpFWqHT3upS0KwnM5/Rn/qivrQmxHxX2oPDdzvUiwutF0/UDXzX+52
 U/wJQFpDfTVVmXmxNiR+zx8iMJ+W83o18SiDKZuzIJwlmAXCbTOZfbDmQ3+NB6+e1VLi
 JOYvTO23lY3hQlbu2BIXnj7ENJrW0UV38LHobms6h3UeR0gG44QXppQfgDnDdvOdtUVZ
 iVlQ==
X-Gm-Message-State: AOAM532vYGVxGBm8fza9Sq3e5TVU37m4W0Ry72JAwZkuTB1XdpveA/K+
 3DeZazuhubbOrfCibRtcffiSpQcX1HUsiQ==
X-Google-Smtp-Source: ABdhPJzrwN/bT6p1dI5tx96H71hjGnZL6cqAMwqfH+7C0aAKLMXtFaO+NLwQmNQoc4uI1EFKzHT1hw==
X-Received: by 2002:a1c:454:: with SMTP id 81mr4498180wme.178.1606934523092;
 Wed, 02 Dec 2020 10:42:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id w17sm3109805wru.82.2020.12.02.10.42.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 16/26] kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
Date: Wed,  2 Dec 2020 18:41:12 +0000
Message-Id: <20201202184122.26046-17-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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
 arch/arm64/include/asm/kvm_hyp.h              |   2 +
 arch/arm64/kvm/arm.c                          |  25 ++++-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |  18 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  10 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          | 100 ++++++++++++++++++
 6 files changed, 151 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci-relay.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index cb25c15e3d8d..c0450828378b 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -93,6 +93,8 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
+
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 09bb4098502b..fda7bfa440d5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/psci.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -64,6 +65,8 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+extern u32 kvm_nvhe_sym(kvm_host_psci_version);
+extern struct psci_0_1_function_ids kvm_nvhe_sym(kvm_host_psci_0_1_function_ids);
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -1600,6 +1603,22 @@ static void init_cpu_logical_map(void)
 		kvm_nvhe_sym(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
 }
 
+static bool init_psci_relay(void)
+{
+	/*
+	 * If PSCI has not been initialized, protected KVM cannot install
+	 * itself on newly booted CPUs.
+	 */
+	if (!psci_ops.get_version) {
+		kvm_err("Cannot initialize protected mode without PSCI\n");
+		return false;
+	}
+
+	kvm_nvhe_sym(kvm_host_psci_version) = psci_ops.get_version();
+	kvm_nvhe_sym(kvm_host_psci_0_1_function_ids) = get_psci_0_1_function_ids();
+	return true;
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1772,9 +1791,13 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
+		if (!init_psci_relay())
+			goto out_err;
+	}
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
new file mode 100644
index 000000000000..1e6d995968a1
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Trap handler helpers.
+ *
+ * Copyright (C) 2020 - Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#ifndef __ARM64_KVM_NVHE_TRAP_HANDLER_H__
+#define __ARM64_KVM_NVHE_TRAP_HANDLER_H__
+
+#include <asm/kvm_host.h>
+
+#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
+#define DECLARE_REG(type, name, ctxt, reg)	\
+				type name = (type)cpu_reg(ctxt, (reg))
+
+#endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index cf11f8182756..1f1e351c5fe2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o
+	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f25680ede080..bde658d51404 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,9 +12,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
-#define DECLARE_REG(type, name, ctxt, reg)	\
-				type name = (type)cpu_reg(ctxt, (reg))
+#include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
@@ -166,7 +164,11 @@ static void skip_host_instruction(void)
 
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
index 000000000000..61375d4571c2
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -0,0 +1,100 @@
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
+#include <nvhe/trap_handler.h>
+
+/* Config options set by the host. */
+__ro_after_init u32 kvm_host_psci_version;
+__ro_after_init struct psci_0_1_function_ids kvm_host_psci_0_1_function_ids;
+
+static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
+
+	return func_id;
+}
+
+static bool is_psci_0_1_call(u64 func_id)
+{
+	return (func_id == kvm_host_psci_0_1_function_ids.cpu_suspend) ||
+	       (func_id == kvm_host_psci_0_1_function_ids.cpu_on) ||
+	       (func_id == kvm_host_psci_0_1_function_ids.cpu_off) ||
+	       (func_id == kvm_host_psci_0_1_function_ids.migrate);
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
+	cpu_reg(host_ctxt, 0) = ret;
+	cpu_reg(host_ctxt, 1) = 0;
+	cpu_reg(host_ctxt, 2) = 0;
+	cpu_reg(host_ctxt, 3) = 0;
+	return true;
+}
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
