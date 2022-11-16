Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630E0C43219
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:03:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D6AA4B890;
	Wed, 16 Nov 2022 12:03:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3FdGsYFqMJhu; Wed, 16 Nov 2022 12:03:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBD94B8EA;
	Wed, 16 Nov 2022 12:03:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FB24B866
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAgw0mCBZDJD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:03:47 -0500 (EST)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20D2A4B890
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:46 -0500 (EST)
Received: by mail-ed1-f74.google.com with SMTP id
 z15-20020a05640240cf00b00461b253c220so12802700edb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=fZZ9nc35uC+PPv8tac3bU8mdwXgTzfjwkL8vUzQ9NwQ=;
 b=qV8O+K/zTLPAF039tByJjjB13o4tbDR/HLe8Vwtr+D40AhiWjqtJ1yyXZenCxXvV+V
 s4bW2oK3dR10obJKcxVd/nhY/9WqUXvbN7qEF3L27RjuFcjSmSHjTskOEnXaDzUGVdOL
 WW+sWi5XYVfBaLtyhTxwwn98NMydGrXq8BHqiFjv1Md7+u5ei+uQOJs32wOYHx7ZvLOB
 yPOhVKMgUD2QDN7vwTvCQwXUsucwFW9oG+woqbVYw6mdnjQVqvo69/5Lvq19ziiTPW9Z
 eBeaOH9CJ4dE528fUThpr28Xk309lV0VqU+vCZINuxOK5FgdiVQxEHiJxNp3VED1gkSh
 dosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=fZZ9nc35uC+PPv8tac3bU8mdwXgTzfjwkL8vUzQ9NwQ=;
 b=v0dWJMd0KyXAlhiT/PRO9J/lpKjN+NLeOzkPQAJ9yfbe1WnaUjfSIEc5XeTU0sh8nt
 0cBDRxwvSneMzEUrGCsyEuSJDBnzIp02ptTvYv8pnG4zg+hOTHLFzJuccVn65cH+OXRH
 /r+jEzIVnvUUzr6ivpUKzO0dXMp89NFnlSdrdJJH0oGmsviWBDa0d7K1WXtx5PoBv/W3
 aan6XeXuaJ+qPOuPtf/6ftYcrkVWv20qyh9JF4GmZCvEzskE1VbZB0upvE3Q45QOlk1K
 ANA3CtzZ3dabMgRQzT7++9Q7r8Gy1SNE1TIzCJNNDtjMMnWNVRgniCrgA8akGMFbkKA0
 LbbA==
X-Gm-Message-State: ANoB5pl89aYDF4+GGPXoIanGBhcCgTzOawhO3UdDvdpK2WKOq7b4j5zF
 Inem+rMx8pl85wgiCyV7+3TRrD9sD8qr
X-Google-Smtp-Source: AA0mqf6V9QZ0avo3Anzkl8UZXPDBaVIDSq5WLXxEMDQ0ebrmTMk1CwV5LKuTtKYey0HO2UTF1UnHQg9ZESCa
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:6402:c12:b0:461:9cbd:8fba with SMTP id
 co18-20020a0564020c1200b004619cbd8fbamr20318894edb.19.1668618225263; Wed, 16
 Nov 2022 09:03:45 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:26 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-4-qperret@google.com>
Subject: [PATCH 03/12] KVM: arm64: Block unsafe FF-A calls from the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
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

From: Will Deacon <will@kernel.org>

When KVM is initialised in protected mode, we must take care to filter
certain FFA calls from the host kernel so that the integrity of guest
and hypervisor memory is maintained and is not made available to the
secure world.

As a first step, intercept and block all memory-related FF-A SMC calls
from the host to EL3. This puts the framework in place for handling them
properly.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  16 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile      |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 113 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    |   3 +
 4 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/ffa.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ffa.c

diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
new file mode 100644
index 000000000000..fc09ec671e24
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 - Google LLC
+ * Author: Andrew Walbran <qwandor@google.com>
+ */
+#ifndef __KVM_HYP_FFA_H
+#define __KVM_HYP_FFA_H
+
+#include <asm/kvm_host.h>
+
+#define FFA_MIN_FUNC_NUM 0x60
+#define FFA_MAX_FUNC_NUM 0x7F
+
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
+
+#endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index be0a2bc3e20d..1b34d3ff57f3 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -22,7 +22,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
new file mode 100644
index 000000000000..6ccf935d3b41
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * FF-A v1.0 proxy to filter out invalid memory-sharing SMC calls issued by
+ * the host. FF-A is a slightly more palatable abbreviation of "Arm Firmware
+ * Framework for Arm A-profile", which is specified by Arm in document
+ * number DEN0077.
+ *
+ * Copyright (C) 2022 - Google LLC
+ * Author: Andrew Walbran <qwandor@google.com>
+ *
+ * This driver hooks into the SMC trapping logic for the host and intercepts
+ * all calls falling within the FF-A range. Each call is either:
+ *
+ *	- Forwarded on unmodified to the SPMD at EL3
+ *	- Rejected as "unsupported"
+ *	- Accompanied by a host stage-2 page-table check/update and reissued
+ *
+ * Consequently, any attempts by the host to make guest memory pages
+ * accessible to the secure world using FF-A will be detected either here
+ * (in the case that the memory is already owned by the guest) or during
+ * donation to the guest (in the case that the memory was previously shared
+ * with the secure world).
+ *
+ * To allow the rolling-back of page-table updates and FF-A calls in the
+ * event of failure, operations involving the RXTX buffers are locked for
+ * the duration and are therefore serialised.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/arm_ffa.h>
+#include <nvhe/ffa.h>
+#include <nvhe/trap_handler.h>
+
+static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
+{
+	*res = (struct arm_smccc_res) {
+		.a0	= FFA_ERROR,
+		.a2	= ffa_errno,
+	};
+}
+
+static void ffa_set_retval(struct kvm_cpu_context *ctxt,
+			   struct arm_smccc_res *res)
+{
+	cpu_reg(ctxt, 0) = res->a0;
+	cpu_reg(ctxt, 1) = res->a1;
+	cpu_reg(ctxt, 2) = res->a2;
+	cpu_reg(ctxt, 3) = res->a3;
+}
+
+static bool is_ffa_call(u64 func_id)
+{
+	return ARM_SMCCC_IS_FAST_CALL(func_id) &&
+	       ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
+	       ARM_SMCCC_FUNC_NUM(func_id) >= FFA_MIN_FUNC_NUM &&
+	       ARM_SMCCC_FUNC_NUM(func_id) <= FFA_MAX_FUNC_NUM;
+}
+
+static bool ffa_call_unsupported(u64 func_id)
+{
+	switch (func_id) {
+	/* Unsupported memory management calls */
+	case FFA_FN64_MEM_RETRIEVE_REQ:
+	case FFA_MEM_RETRIEVE_RESP:
+	case FFA_MEM_RELINQUISH:
+	case FFA_MEM_OP_PAUSE:
+	case FFA_MEM_OP_RESUME:
+	case FFA_MEM_FRAG_RX:
+	case FFA_FN64_MEM_DONATE:
+	/* Indirect message passing via RX/TX buffers */
+	case FFA_MSG_SEND:
+	case FFA_MSG_POLL:
+	case FFA_MSG_WAIT:
+	/* 32-bit variants of 64-bit calls */
+	case FFA_MSG_SEND_DIRECT_REQ:
+	case FFA_MSG_SEND_DIRECT_RESP:
+	case FFA_RXTX_MAP:
+	case FFA_MEM_DONATE:
+	case FFA_MEM_RETRIEVE_REQ:
+		return true;
+	}
+
+	return false;
+}
+
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
+	struct arm_smccc_res res;
+
+	if (!is_ffa_call(func_id))
+		return false;
+
+	switch (func_id) {
+	/* Memory management */
+	case FFA_FN64_RXTX_MAP:
+	case FFA_RXTX_UNMAP:
+	case FFA_MEM_SHARE:
+	case FFA_FN64_MEM_SHARE:
+	case FFA_MEM_LEND:
+	case FFA_FN64_MEM_LEND:
+	case FFA_MEM_RECLAIM:
+	case FFA_MEM_FRAG_TX:
+		break;
+	}
+
+	if (!ffa_call_unsupported(func_id))
+		return false; /* Pass through */
+
+	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
+	ffa_set_retval(host_ctxt, &res);
+	return true;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b..223611e43279 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
@@ -373,6 +374,8 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	bool handled;
 
 	handled = kvm_host_psci_handler(host_ctxt);
+	if (!handled)
+		handled = kvm_host_ffa_handler(host_ctxt);
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
