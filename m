Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DD1C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD19622201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="aoO/o2Uc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD19622201
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3ED4B7F7;
	Mon,  9 Nov 2020 06:33:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q60rCYAOuBEL; Mon,  9 Nov 2020 06:33:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBC94B720;
	Mon,  9 Nov 2020 06:33:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C4654B759
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BlUQ3dMX-oir for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:13 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10AAE4B6EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:12 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id h2so7657153wmm.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pYieT24U6rTScU/FYH/lP2LhMsKB3zlRaCq2X67+Sqc=;
 b=aoO/o2Uc9KA/zaDyezMsH3ElIneNvZkysxVTHTgI+to/2ZlOP5teBf/B7Uy39aSVJd
 8nekb0GDqhzBKOpLgNAOmcxf9VemCTJro7xA7oGN1T8ryIwZtQB1DjZ596yDARlG375q
 oVzbpLrulf4LfKt1qjv6qm0EilG51Zd3LMpx328Xzsk02wrkPJd56lL6ZU+Quf/1TaRs
 lxpneRVblMPg/PmFsWmcItB2F8n1Ek94BmIg38YFWzHfHBlkfFH+49xa+uAgr9WDjPMu
 n5mbOstt7Fz/1HOJA6fLoR/ycQFilN0NkkvEibuFJ62hTRvGpwWeZIwjCwAxKNQvXMav
 X5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pYieT24U6rTScU/FYH/lP2LhMsKB3zlRaCq2X67+Sqc=;
 b=b1n7ejoA4nMs8UrSsBgEF+5YCOQyR0qSBXb5Ce4Lx5VwyHNXDua+4QGmQKpYwXKbJv
 17U28oD0zdnDgfcpV6YDDyPzytTNGhKpEEVpvpdtv5XVMVBSREAQPpKsDmisMNfl+HbH
 cS517AOIf/Q6XMJb51zGpoOb042yhzzt+vDj/OBtQl7/13JD50aiQmNduwGPcyyALNG0
 xbezx+pIAp7Ousswyvic7s+zj0uYW4ed4AHVUyjSDgFmc+87qP+jwAEyI7SRtLEMdYNr
 bES0SyXjKJyFES1oDQvWVrwzKbLAya3B/nQmnQj3eIxA5Ki4TAj8zASI7lWskEqT4Uij
 dXJg==
X-Gm-Message-State: AOAM532hw8OejTM5IzVV5vCnByX4FszkRU6I28GxzJ3UsHsCmEvtJRW0
 1mOzQwZO3368XuU5mpZ10ZuKKJe8eDzkwqz5
X-Google-Smtp-Source: ABdhPJyz0tqLCCy6FmRE9It1sQ05a59QF/F02zSZWOuxLa+ZMTGA0uDhQdOTn7jSjPuDKoBmcQjL5g==
X-Received: by 2002:a1c:1dc1:: with SMTP id
 d184mr13978801wmd.169.1604921590702; 
 Mon, 09 Nov 2020 03:33:10 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id k84sm12972518wmf.42.2020.11.09.03.33.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:09 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 15/24] kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
Date: Mon,  9 Nov 2020 11:32:24 +0000
Message-Id: <20201109113233.9012-16-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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
 arch/arm64/include/asm/kvm_hyp.h   |   4 ++
 arch/arm64/kvm/arm.c               |  13 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   4 ++
 arch/arm64/kvm/hyp/nvhe/psci.c     | 102 +++++++++++++++++++++++++++++
 include/uapi/linux/psci.h          |   1 +
 6 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci.c

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
index 1a57b6025937..28e3bc056225 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/psci.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -1498,6 +1499,17 @@ static void init_cpu_logical_map(void)
 		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
 }
 
+static void init_psci(void)
+{
+	extern u32 kvm_nvhe_sym(kvm_host_psci_version);
+	extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
+	int i;
+
+	CHOOSE_NVHE_SYM(kvm_host_psci_version) = psci_driver_version();
+	for (i = 0; i < PSCI_FN_MAX; ++i)
+		CHOOSE_NVHE_SYM(kvm_host_psci_function_id)[i] = psci_get_function_id(i);
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1677,6 +1689,7 @@ static int init_hyp_mode(void)
 	}
 
 	init_cpu_logical_map();
+	init_psci();
 
 	return 0;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index c45f440cce51..647b63337a51 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o percpu.o
+	 hyp-main.o percpu.o psci.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8661bc7deaa9..69f34d4f2773 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -134,6 +134,10 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	 */
 	skip_host_instruction();
 
+	/* Try to handle host's PSCI SMCs. */
+	if (kvm_host_psci_handler(host_ctxt))
+		return;
+
 	/* Forward SMC not handled in EL2 to EL3. */
 	forward_host_smc(host_ctxt);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
new file mode 100644
index 000000000000..82d3b2c89658
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -0,0 +1,102 @@
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
+u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
+u32 kvm_host_psci_function_id[PSCI_FN_MAX];
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
+static bool is_psci_0_2_fn_call(u64 func_id)
+{
+	u64 base = func_id & ~PSCI_0_2_FN_ID_MASK;
+
+	return base == PSCI_0_2_FN_BASE || base == PSCI_0_2_FN64_BASE;
+}
+
+static bool is_psci_call(u64 func_id)
+{
+	if (kvm_host_psci_version == PSCI_VERSION(0, 0))
+		return false;
+	else if (kvm_host_psci_version == PSCI_VERSION(0, 1))
+		return is_psci_0_1_call(func_id);
+	else
+		return is_psci_0_2_fn_call(func_id);
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
+	int ret;
+
+	ret = psci_0_2_handler(func_id, host_ctxt);
+	if (ret != PSCI_RET_NOT_SUPPORTED)
+		return ret;
+
+	switch (func_id) {
+	default:
+		return PSCI_RET_NOT_SUPPORTED;
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
+	if (kvm_host_psci_version == PSCI_VERSION(0, 1))
+		ret = psci_0_1_handler(func_id, host_ctxt);
+	else if (kvm_host_psci_version == PSCI_VERSION(0, 2))
+		ret = psci_0_2_handler(func_id, host_ctxt);
+	else if (PSCI_VERSION_MAJOR(kvm_host_psci_version) >= 1)
+		ret = psci_1_0_handler(func_id, host_ctxt);
+	else
+		ret = PSCI_RET_NOT_SUPPORTED;
+
+	host_ctxt->regs.regs[0] = ret;
+	host_ctxt->regs.regs[1] = 0;
+	host_ctxt->regs.regs[2] = 0;
+	host_ctxt->regs.regs[3] = 0;
+	return true;
+}
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 2fcad1dd0b0e..0d52b8dbe8c2 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -29,6 +29,7 @@
 #define PSCI_0_2_FN64_BASE			\
 					(PSCI_0_2_FN_BASE + PSCI_0_2_64BIT)
 #define PSCI_0_2_FN64(n)			(PSCI_0_2_FN64_BASE + (n))
+#define PSCI_0_2_FN_ID_MASK			0xffff
 
 #define PSCI_0_2_FN_PSCI_VERSION		PSCI_0_2_FN(0)
 #define PSCI_0_2_FN_CPU_SUSPEND			PSCI_0_2_FN(1)
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
