Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C131E52D
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8319C433D2;
	Tue, 23 May 2023 10:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837117;
	bh=/oTLRm1aogTtPaFbw0owDqhBQpTV5RgBbom90E1HaWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkE7Ve3F0UJAcJk9tDBaikctpB4FJrZ+mQt0bMsScWwAmOflx30/8soWoyFj4yDmv
	 hZh20NT4eC5D/9fS4DhbZvRTDRyGXDTMpUVt147KoEnBFcvY4NnjyH6MuznhS51vAP
	 I0tW7tWoZnpAC2hA82UmjUxjMt8imwZ/ifvbEPml3Vi87VOZB788QqYmU5q0FRiAlM
	 srsuXhthJoOJLGp3J8woAeB0lqDf169W8GCuuEdx0AQKpq1WETzA92zNW57tTOcBLz
	 xDa2k18B8vC/1zkowj8hszmTNnBWGpoUg+gVj4qjpmEepiJ6SJb3RJrLY2nXNWkuXn
	 qWQt+XbDKU1VQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Andrew Walbran <qwandor@google.com>
Subject: [PATCH v3 01/10] KVM: arm64: Block unsafe FF-A calls from the host
Date: Tue, 23 May 2023 11:18:18 +0100
Message-Id: <20230523101828.7328-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230523101828.7328-1-will@kernel.org>
References: <20230523101828.7328-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM is initialised in protected mode, we must take care to filter
certain FFA calls from the host kernel so that the integrity of guest
and hypervisor memory is maintained and is not made available to the
secure world.

As a first step, intercept and block all memory-related FF-A SMC calls
from the host to EL3 and don't advertise any FF-A features. This puts
the framework in place for handling them properly.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  16 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile      |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 119 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    |   3 +
 4 files changed, 139 insertions(+), 1 deletion(-)
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
index 530347cdebe3..9ddc025e4b86 100644
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
index 000000000000..302806928a64
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -0,0 +1,119 @@
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
+/*
+ * Is a given FFA function supported, either by forwarding on directly
+ * or by handling at EL2?
+ */
+static bool ffa_call_supported(u64 func_id)
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
+	/* Don't advertise any features just yet */
+	case FFA_FEATURES:
+		return false;
+	}
+
+	return true;
+}
+
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
+	struct arm_smccc_res res;
+
+	/*
+	 * There's no way we can tell what a non-standard SMC call might
+	 * be up to. Ideally, we would terminate these here and return
+	 * an error to the host, but sadly devices make use of custom
+	 * firmware calls for things like power management, debugging,
+	 * RNG access and crash reporting.
+	 *
+	 * Given that the architecture requires us to trust EL3 anyway,
+	 * we forward unrecognised calls on under the assumption that
+	 * the firmware doesn't expose a mechanism to access arbitrary
+	 * non-secure memory. Short of a per-device table of SMCs, this
+	 * is the best we can do.
+	 */
+	if (!is_ffa_call(func_id))
+		return false;
+
+	if (ffa_call_supported(func_id))
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
2.40.1.698.g37aff9b760-goog

