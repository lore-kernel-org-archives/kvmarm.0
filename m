Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5794E381EB0;
	Wed, 15 Jul 2026 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125686; cv=none; b=s2hutuXPdH01DbonNvIImy+mm6mMiljha/WT1lbpjy6lkHoEnxYoLzBwHhadKVFmt1jDEile8S7pKH+rZiEEhWNQuVwuPKJQI+qGUszESKCMHNn4tJ3X/Y/QrBwY2hIeeW36Eppu/bSYBp2DzWEN4PrFBp/kZIsic9OoFjlRW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125686; c=relaxed/simple;
	bh=NWOsNN7l8W9YwPA6xfIL/7P4wLBRe755MxPlY7PfirM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYILSZW8STX+f1LpN70bErk2u8r4wgl0PrU4+aTztEGHo989x8ZDzXsPAwXfepRdf7VmrngSXaWqR0EKRACU8zf/Dot3nC1mOcu0NuMb+UQbtFI4BEXyxTYJw2Hy9cqZ93u6r9Xk+6aIzLremXUDZBAxRVahX8dfoY9NBaEcWc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mphvvR75; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mphvvR75"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75EF8153B;
	Wed, 15 Jul 2026 07:28:00 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 181143F7B4;
	Wed, 15 Jul 2026 07:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125684; bh=NWOsNN7l8W9YwPA6xfIL/7P4wLBRe755MxPlY7PfirM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mphvvR75ooi1yaJNM10+H/UaryGV0V3IrcPsl+RkTGRFmqzU/vqhkgF2hwntEMN4P
	 cf7cKqvbAMo2z/NCUonu6UbysD2AwUEl9Q+k9p74Hv4MWM3FrFzuYysx/uZp5Z2yp2
	 z+FnKUYEwiXqKHE4ftNMGdXFczelrmbbaT6pRY8k=
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
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI calls
Date: Wed, 15 Jul 2026 15:27:33 +0100
Message-ID: <20260715142739.80398-3-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142739.80398-1-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wrappers make the call sites easier to read and deal with the
boilerplate of handling the error codes from the RMM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes from v14:
 * Update to RMM v2.0-bet2 spec.
 * Move SRO related wrappers to a later patch due to dependencies.
 * Common wrappers are split into include/linux/arm-rmi-cmds.h.
Changes from v13:
 * Update to RMM v2.0-bet1 spec including some SRO support (there still
   some FIXMEs where SRO support is incomplete).
Changes from v12:
 * Update to RMM v2.0 specification
Changes from v8:
 * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
   rmi_rtt_read_entry() for consistency.
Changes from v7:
 * Minor renaming of parameters and updated comments
Changes from v5:
 * Further improve comments
Changes from v4:
 * Improve comments
Changes from v2:
 * Make output arguments optional.
 * Mask RIPAS value rmi_rtt_read_entry()
 * Drop unused rmi_rtt_get_phys()
---
 arch/arm64/include/asm/rmi_cmds.h | 67 +++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      | 91 +++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 include/linux/arm-rmi-cmds.h

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
new file mode 100644
index 000000000000..7eb2c8d7f7fa
--- /dev/null
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#ifndef __ASM_RMI_CMDS_H
+#define __ASM_RMI_CMDS_H
+
+#include <linux/arm-rmi-cmds.h>
+#include <linux/arm-smccc-rmi.h>
+
+/**
+ * rmi_psci_complete() - Complete pending PSCI command
+ * @calling_rec: PA of the calling REC
+ * @status: Status of the PSCI request
+ *
+ * Completes a pending PSCI command.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_psci_complete(unsigned long calling_rec,
+				    unsigned long status)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, status, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_activate() - Active a realm
+ * @rd: PA of the RD
+ *
+ * Mark a realm as Active signalling that creation is complete and allowing
+ * execution of the realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_activate(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rec_enter() - Enter a REC
+ * @rec: PA of the target REC
+ * @run_ptr: PA of RecRun structure
+ *
+ * Starts (or continues) execution within a REC.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
+
+	return res.a0;
+}
+
+#endif /* __ASM_RMI_CMDS_H */
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
new file mode 100644
index 000000000000..c038c1d685fa
--- /dev/null
+++ b/include/linux/arm-rmi-cmds.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef __LINUX_ARM_RMI_CMDS_H_
+#define __LINUX_ARM_RMI_CMDS_H_
+
+#include <linux/arm-smccc-rmi.h>
+#include <linux/bug.h>
+#include <linux/types.h>
+
+#include <asm/page.h>
+
+struct rtt_entry {
+	unsigned long walk_level;
+	unsigned long desc;
+	int state;
+	int ripas;
+};
+
+unsigned long rmi_feat_reg(unsigned long id);
+
+bool is_rmi_available(void);
+
+/**
+ * rmi_rmm_config_set() - Configure the RMM
+ * @cfg_ptr: PA of a struct rmm_config
+ *
+ * Sets configuration options on the RMM.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
+ * @start: Base PA of the tracking region
+ * @end: End of the PA region
+ * @out_category: Memory category
+ * @out_state: Tracking region state
+ * @out_top: Top of the memory region
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_tracking_get(unsigned long start,
+					   unsigned long end,
+					   unsigned long *out_category,
+					   unsigned long *out_state,
+					   unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_TRACKING_GET, start, end, &res);
+
+	if (out_category)
+		*out_category = res.a1;
+	if (out_state)
+		*out_state = res.a2;
+	if (out_top)
+		*out_top = res.a3;
+
+	return res.a0;
+}
+
+/**
+ * rmi_features() - Read feature register
+ * @index: Feature register index
+ * @out: Feature register value is written to this pointer
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_features(unsigned long index, unsigned long *out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
+
+	if (out)
+		*out = res.a1;
+	return res.a0;
+}
+
+#endif
-- 
2.43.0

