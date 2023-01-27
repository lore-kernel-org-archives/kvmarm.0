Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B1A7B;
	Fri, 27 Jan 2023 11:29:51 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC59F1595;
	Fri, 27 Jan 2023 03:30:32 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8133F3F64C;
	Fri, 27 Jan 2023 03:29:48 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev
Subject: [RFC PATCH 03/28] arm64: RME: Add wrappers for RMI calls
Date: Fri, 27 Jan 2023 11:29:07 +0000
Message-Id: <20230127112932.38045-4-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wrappers make the call sites easier to read and deal with the
boiler plate of handling the error codes from the RMM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/rmi_cmds.h | 259 ++++++++++++++++++++++++++++++
 1 file changed, 259 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
new file mode 100644
index 000000000000..d5468ee46f35
--- /dev/null
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -0,0 +1,259 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_RMI_CMDS_H
+#define __ASM_RMI_CMDS_H
+
+#include <linux/arm-smccc.h>
+
+#include <asm/rmi_smc.h>
+
+struct rtt_entry {
+	unsigned long walk_level;
+	unsigned long desc;
+	int state;
+	bool ripas;
+};
+
+static inline int rmi_data_create(unsigned long data, unsigned long rd,
+				  unsigned long map_addr, unsigned long src,
+				  unsigned long flags)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, data, rd, map_addr, src,
+			     flags, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_data_create_unknown(unsigned long data,
+					  unsigned long rd,
+					  unsigned long map_addr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, data, rd, map_addr,
+			     &res);
+
+	return res.a0;
+}
+
+static inline int rmi_data_destroy(unsigned long rd, unsigned long map_addr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, map_addr, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_features(unsigned long index, unsigned long *out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
+
+	*out = res.a1;
+	return res.a0;
+}
+
+static inline int rmi_granule_delegate(unsigned long phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_granule_undelegate(unsigned long phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_psci_complete(unsigned long calling_rec,
+				    unsigned long target_rec)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
+			     &res);
+
+	return res.a0;
+}
+
+static inline int rmi_realm_activate(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_realm_destroy(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
+
+	*aux_count = res.a1;
+	return res.a0;
+}
+
+static inline int rmi_rec_create(unsigned long rec, unsigned long rd,
+				 unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rec, rd, params_ptr, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rec_destroy(unsigned long rec)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_create(unsigned long rtt, unsigned long rd,
+				 unsigned long map_addr, unsigned long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rtt, rd, map_addr, level,
+			     &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_destroy(unsigned long rtt, unsigned long rd,
+				  unsigned long map_addr, unsigned long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rtt, rd, map_addr, level,
+			     &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_fold(unsigned long rtt, unsigned long rd,
+			       unsigned long map_addr, unsigned long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rtt, rd, map_addr, level, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long map_addr,
+				     unsigned long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, map_addr, level, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_map_unprotected(unsigned long rd,
+					  unsigned long map_addr,
+					  unsigned long level,
+					  unsigned long desc)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, map_addr, level,
+			     desc, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long map_addr,
+				     unsigned long level, struct rtt_entry *rtt)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_READ_ENTRY,
+		rd, map_addr, level
+	};
+
+	arm_smccc_1_2_smc(&regs, &regs);
+
+	rtt->walk_level = regs.a1;
+	rtt->state = regs.a2 & 0xFF;
+	rtt->desc = regs.a3;
+	rtt->ripas = regs.a4 & 1;
+
+	return regs.a0;
+}
+
+static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
+				    unsigned long map_addr, unsigned long level,
+				    unsigned long ripas)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, map_addr, level,
+			     ripas, &res);
+
+	return res.a0;
+}
+
+static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
+					    unsigned long map_addr,
+					    unsigned long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, map_addr,
+			     level, &res);
+
+	return res.a0;
+}
+
+static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
+{
+	return rtt->desc & GENMASK(47, 12);
+}
+
+#endif
-- 
2.34.1

