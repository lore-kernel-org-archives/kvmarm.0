Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137B4C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BA4322244
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HwVGV83S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BA4322244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493694C0EC;
	Thu, 26 Nov 2020 10:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t2lGTz1VE1Hk; Thu, 26 Nov 2020 10:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8AF84C0B0;
	Thu, 26 Nov 2020 10:55:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FBDC4B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dhe5quS8OrnA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:58 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23F464C0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:58 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id i2so2642291wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=96Y1Pg8NboBYaC6v7mMq4UlUhEivDMpMpRFkrQ3cNDg=;
 b=HwVGV83SA1pu0EkNWbTp3SpTcyRYOohY63MbncNrkmkpg6bhNUNdS9EwDWsj4Ce67U
 sX5d/patePE2huLGqwQ6Jie1Q1vG6nL70ED1869nNdm/tCnLnbOUUuaYuYxRvLqWTWlA
 n+pKGCOOAOUj9OioMDgZ7dFik62hQ4KtzRO8SEpOreGSG4WJdXWKsjeWr0PpEZJ31KQ0
 uyakkl+o8i8hSlOLz7STTfHEfJv8cyfx/WkL14oX8ruk6bAw7+AQ7Rq5PEW1A0HMgDKU
 jphMf3l5iWH8GZG+N9JC+Q0uwPhBd/wdTIHnjLR53pqRZ9C0utsotAEPqbV8Rdju9kFI
 hegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=96Y1Pg8NboBYaC6v7mMq4UlUhEivDMpMpRFkrQ3cNDg=;
 b=cqCjnl7pbqCXCOJFUU76zOPD6aHvWTLVZSxnaIYgVhDc0s6h4ipOTSshV5HpMZIzls
 sP5FoYDWBTHKAKA94tNVqeLqu/PR5OQMfzQ0qd3nO5EUePOLoXFmlbirDXhf4NJ067s3
 ZKdGL2FTDq4bvI5M/6yi2azcsSgv6mpXDZU6QMrzE3h2hyS/F7UxPras8h+XaXKl9wBv
 C93EZnieuIegR4UHhJWMALzRsKIWSZRtcu+KKUjoRgPwxE3KCPxhOZDWgzwJQDKhIuHy
 Ifc9/WYV7VIScTgQPALoUZrW99kddjGOOqrDdGk7YJkuFv8l+WOKYmZBY+vqexGW7KTk
 P4LQ==
X-Gm-Message-State: AOAM530nQZ0+ZoeZy8PnZEz/bmVWsl44aENQ09PwcuQre69CWMpLMIat
 fHHV1F3rrrxvuBW99YGCaGDTbaYeo2MnIPiM
X-Google-Smtp-Source: ABdhPJxZM90ubqSRiYq0ls0OqUo2eyyMniWNiLiTqx8tmAhlFoXELKzvYp156Crsd8Y4IBGxE+f1vA==
X-Received: by 2002:a5d:570d:: with SMTP id a13mr4513622wrv.193.1606406096673; 
 Thu, 26 Nov 2020 07:54:56 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id o4sm8751771wmh.33.2020.11.26.07.54.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:55 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 14/23] kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
Date: Thu, 26 Nov 2020 15:54:12 +0000
Message-Id: <20201126155421.14901-15-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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
 arch/arm64/kvm/arm.c                          |  29 ++++-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |  18 +++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  10 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          | 103 ++++++++++++++++++
 6 files changed, 158 insertions(+), 6 deletions(-)
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
index bb3c541d3ddb..7a17b5048454 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/psci.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -62,6 +63,8 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+extern u32 kvm_nvhe_sym(kvm_host_psci_version);
+extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -1547,6 +1550,26 @@ static void init_cpu_logical_map(void)
 		kvm_nvhe_sym(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
 }
 
+static bool init_psci_relay(void)
+{
+	int i;
+
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
+	for (i = 0; i < PSCI_FN_MAX; ++i)
+		kvm_nvhe_sym(kvm_host_psci_function_id)[i] = psci_get_function_id(i);
+
+	return true;
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1719,9 +1742,13 @@ static int init_hyp_mode(void)
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
index 000000000000..92d34675acdb
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Trap handler helpers.
+ *
+ * Copyright (C) 2020 - Google LLC
+ * Author: Marc Zyngier <dbrazdil@google.com>
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
index 000000000000..44a9fb462d24
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -0,0 +1,103 @@
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
+u32 __ro_after_init kvm_host_psci_version;
+u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
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
