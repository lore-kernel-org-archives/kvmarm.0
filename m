Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82103A6400;
	Mon, 27 Apr 2026 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280044; cv=none; b=aUEDQ5QpBui1H1G0E5kGFTxJEDUYYFYfOKxWKtr81U1HgBVjgzN+BJwLwVjFvfX7hpQEljPGNra9pcJMQbfVwykE3/BSqpscFtZs82X3fS4OqYOEk74lAshzVZAMfth7WRV7rSFl6iLBSRpMRvEewweFdhEZrojrELOhwEWCknU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280044; c=relaxed/simple;
	bh=aJCU8h1BrfUXy6jl/UuakpwoAjiM2FONCie7ThUrOe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/t15fmFxjnAQVJSPnXyYLznQCJeouBe9g9J+MyL8cdaF1RfolaJFYyyt4NFkv4DUJJkK1XLCdaSWa4Cjwxm5VXXzpcsmgkO8L5Ct8+8K3YhCmjyT0/kNGEQhwhQHpfYRDVAVtm/b6fUBUh7PYBQUfKOiDMEpFThfd94VrPjQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrnRTEyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrnRTEyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916EBC19425;
	Mon, 27 Apr 2026 08:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280043;
	bh=aJCU8h1BrfUXy6jl/UuakpwoAjiM2FONCie7ThUrOe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrnRTEyUBnKrj/e5XD9rXKAJHgYM4SX36e7695s6ms+tXbdmm2iqzC+KKO0tCqiAm
	 j52Db13t3YIgYTUsNSpOi3lE/ns3WFEXDgnvlodSA6HOcu/k/YbN2FDWRjfxCi9QFr
	 sPC9TUCHgtd+6ebevqy2hy+izeW0xZstwHSRy/4XRKHGBBY5a3Bi6w0+a+mZvT28al
	 sWJXGjUrRYlOmo7FRxoPMHP+Qp/lsQcQ84q3AznivR5nh4vx8qgYUUbAXYhMWNJY6n
	 j/YOuvK/HV3q0x336OS+3nef5vcUMthlzEb2WVrt1EwpxiZSAr4see5AeVL/dMfTlw
	 l5LyGDmwxOa/Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 01/16] iommu/arm-smmu-v3: Discover RME support and realm IRQ topology
Date: Mon, 27 Apr 2026 14:23:29 +0530
Message-ID: <20260427085344.941627-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect RME-capable SMMUv3 instances from IDR0.RME_IMPL and record the
capability in arm_smmu_device.

When RMM is active, query RMI_PSMMU_INFO to discover how realm-side
notifications are delivered. For pSMMUs that expose realm interrupts, store
the reported evtq/gerror/priq IRQs, reserve extra MSI vectors when RMM uses
MSI delivery, and register threaded handlers that acknowledge notifications
through RMI_PSMMU_IRQ_NOTIFY / RMI_PSMMU_EVENT_CONSUME.

Also add the RMI command/structure definitions needed for PSMMU_INFO and
interrupt notification, along with arm_smmu_device state for the physical
base address and realm IRQs.

If RMM reports a CMDQ sync interrupt requirement, keep the IRQ plumbing
but leave ARM_SMMU_FEAT_RME disabled.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h             |  52 ++++++++
 arch/arm64/include/asm/rmi_smc.h              |  32 ++++-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c | 124 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  81 +++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  10 ++
 6 files changed, 297 insertions(+), 4 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index c82d4d9cbc06..75eb59d4fa84 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -811,4 +811,56 @@ static inline unsigned long rmi_pdev_stream_disconnect(unsigned long pdev1_phys,
 	return res.a0;
 }
 
+static inline unsigned long rmi_psmmu_info(unsigned long psmmu_phys,
+		unsigned long psmmu_info_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSMMU_INFO,
+			     psmmu_phys, psmmu_info_phys, &res);
+
+	return res.a0;
+}
+
+struct rmi_psmmu_event_details {
+	u64 flags;
+	u64 event_num;
+	u64 stream_id; /* valid only if we have VSMMU event */
+	u64 fetch_addr;
+	u64 input_addr;
+	u64 syndrome;
+};
+
+static inline unsigned long rmi_psmmu_irq_notify(unsigned long psmmu_phys,
+		unsigned long irqs, struct rmi_psmmu_event_details *event)
+{
+	struct arm_smccc_1_2_regs regs = {
+		.a0 = SMC_RMI_PSMMU_IRQ_NOTIFY,
+		.a1 = psmmu_phys,
+		.a2 = irqs,
+	};
+
+	arm_smccc_1_2_invoke(&regs, &regs);
+
+	event->flags      = regs.a1;
+	event->event_num  = regs.a2;
+	event->stream_id  = regs.a3;
+	event->fetch_addr = regs.a4;
+	event->input_addr = regs.a5;
+	event->syndrome   = regs.a6;
+
+	return regs.a0;
+}
+
+static inline unsigned long rmi_psmmu_event_consume(unsigned long psmmu_phys,
+		unsigned long irqs)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSMMU_EVENT_CONSUME,
+			     psmmu_phys, irqs, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 7b16f1540a0e..be1b1e95a937 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -101,7 +101,7 @@
 #define SMC_RMI_PDEV_MEC_UPDATE			SMC_RMI_CALL(0x01ed)
 #define SMC_RMI_VSMMU_EVENT_COMPLETE		SMC_RMI_CALL(0x01ee)
 
-#define SMC_RMI_PSMMU_EVENT_DISCARD		SMC_RMI_CALL(0x01f0)
+#define SMC_RMI_PSMMU_EVENT_CONSUME		SMC_RMI_CALL(0x01f0)
 #define SMC_RMI_GRANULE_RANGE_DELEGATE		SMC_RMI_CALL(0x01f1)
 #define SMC_RMI_GRANULE_RANGE_UNDELEGATE	SMC_RMI_CALL(0x01f2)
 #define SMC_RMI_GPT_L1_CREATE			SMC_RMI_CALL(0x01f3)
@@ -129,6 +129,7 @@
 #define SMC_RMI_OP_MEM_RECLAIM			SMC_RMI_CALL(0x0209)
 #define SMC_RMI_OP_CANCEL			SMC_RMI_CALL(0x020a)
 #define SMC_RMI_PDEV_SET_PROT			SMC_RMI_CALL(0x020b)
+#define SMC_RMI_PSMMU_INFO			SMC_RMI_CALL(0x020e)
 
 #define RMI_ABI_MAJOR_VERSION	2
 #define RMI_ABI_MINOR_VERSION	0
@@ -595,4 +596,33 @@ struct rmi_pdev_stream_params {
 	};
 };
 
+#define RMI_PSMMU_IRQCFG_IRQ_DISABLED	0x0
+#define RMI_PSMMU_IRQCFG_IRQ_WIRED	0x1
+#define RMI_PSMMU_IRQCFG_IRQ_MSI	0x2
+#define RMI_PSMMU_IRQCFG_MASK		GENMASK(1, 0)
+struct rmi_psmmu_info {
+	union {
+		struct {
+			u64 flags;
+			union {
+				u32 gerror_intr_num;
+				u8 padding1[8];
+			};
+			union {
+				u32 eventq_intr_num;
+				u8 padding2[8];
+			};
+			union {
+				u32 priq_intr_num;
+				u8 padding3[8];
+			};
+			union {
+				u32 cmdq_sync_intr_num;
+				u8 padding4[8];
+			};
+		};
+		u8 padding5[0x1000];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 493a659cc66b..23bd794ebeda 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
-arm_smmu_v3-y := arm-smmu-v3.o
+arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-realm.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
new file mode 100644
index 000000000000..fec1a32de53c
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <linux/interrupt.h>
+#include <asm/rmi_smc.h>
+#include <asm/rmi_cmds.h>
+
+#include "arm-smmu-v3.h"
+
+#define	RMI_PSMMU_IRQ_GERROR	BIT(0)
+#define	RMI_PSMMU_IRQ_EVENTQ	BIT(1)
+#define	RMI_PSMMU_IRQ_PRIQ	BIT(2)
+#define	RMI_PSMMU_IRQ_CMDQ	BIT(3)
+
+#define	RMI_PSMMU_IRQ_EVENT_NONE	0
+#define	RMI_PSMMU_IRQ_EVENT_ERROR	1
+#define	RMI_PSMMU_IRQ_EVENT_PSMMU	2
+#define	RMI_PSMMU_IRQ_EVENT_VSMMU	3
+#define RMI_PSMMU_IRQ_EVENT_MASK	GENMASK(2, 1)
+#define RMI_PSMMU_IRQ_EVENT_SHIFT	1
+#define RMI_PSMMU_IRQ_EVENT_PENDING	0x1
+
+static irqreturn_t arm_smmu_realm_notify_thread(int irq, void *dev)
+{
+	int rmi_psmmu_event;
+	unsigned long notify_flags;
+	struct arm_smmu_device *smmu = dev;
+	struct rmi_psmmu_event_details event;
+
+	if (irq == smmu->realm_evtq_irq)
+		notify_flags =  RMI_PSMMU_IRQ_EVENTQ;
+	else if (irq == smmu->realm_gerr_irq)
+		notify_flags =  RMI_PSMMU_IRQ_GERROR;
+	else if (irq == smmu->realm_pri_irq)
+		notify_flags =  RMI_PSMMU_IRQ_PRIQ;
+	else
+		return IRQ_HANDLED;
+
+	do {
+		if (rmi_psmmu_irq_notify(smmu->base_phys,
+					 notify_flags, &event)) {
+			dev_warn(smmu->dev,
+				 "failed to notify RMM of a SMMU event\n");
+			/* there is nothing much we could do. Mark it handled. */
+			return IRQ_HANDLED;
+		}
+		rmi_psmmu_event = (event.flags & RMI_PSMMU_IRQ_EVENT_MASK) >>
+				  RMI_PSMMU_IRQ_EVENT_SHIFT;
+		switch (rmi_psmmu_event) {
+		case RMI_PSMMU_IRQ_EVENT_NONE:
+			break;
+		case RMI_PSMMU_IRQ_EVENT_ERROR:
+			dev_warn(smmu->dev, "SMMU Error reported\n");
+			rmi_psmmu_event_consume(smmu->base_phys, notify_flags);
+			break;
+		case RMI_PSMMU_IRQ_EVENT_PSMMU:
+			dev_warn(smmu->dev,
+				 "SMMU event (event num: 0x%llx syndrome 0x%llx "
+				 "fetch_addr 0x%llx input_addr 0x%llx) reported\n",
+				 event.event_num, event.syndrome,
+				 event.fetch_addr, event.input_addr);
+			rmi_psmmu_event_consume(smmu->base_phys, notify_flags);
+			break;
+		case RMI_PSMMU_IRQ_EVENT_VSMMU:
+			dev_warn(smmu->dev, "Wrong VSMMU event on stream 0x%llx, ignoring\n",
+				 event.stream_id);
+			rmi_psmmu_event_consume(smmu->base_phys, notify_flags);
+			break;
+		}
+
+	} while (event.flags & RMI_PSMMU_IRQ_EVENT_PENDING);
+
+	return IRQ_HANDLED;
+}
+
+void arm_smmu_setup_realm_irqs(struct arm_smmu_device *smmu)
+{
+	int irq, ret;
+
+	irq = smmu->realm_evtq_irq;
+	if (irq) {
+		ret = devm_request_threaded_irq(smmu->dev, irq, NULL,
+						arm_smmu_realm_notify_thread,
+						IRQF_ONESHOT,
+						"arm-smmu-v3-realm-evtq",
+						smmu);
+		if (ret < 0)
+			dev_warn(smmu->dev, "failed to enable realm evtq irq\n");
+	} else {
+		dev_warn(smmu->dev, "no realm evtq irq - events will not be reported!\n");
+	}
+
+	irq = smmu->realm_gerr_irq;
+	if (irq) {
+		ret = devm_request_threaded_irq(smmu->dev, irq, NULL,
+						arm_smmu_realm_notify_thread,
+						IRQF_ONESHOT,
+						"arm-smmu-v3-realm-gerror",
+						smmu);
+		if (ret < 0)
+			dev_warn(smmu->dev, "failed to enable realm gerror irq\n");
+	} else {
+		dev_warn(smmu->dev, "no realm gerr irq - errors will not be reported!\n");
+	}
+
+	if (smmu->features & ARM_SMMU_FEAT_PRI) {
+		irq = smmu->realm_pri_irq;
+		if (irq) {
+
+			ret = devm_request_threaded_irq(smmu->dev, irq, NULL,
+							arm_smmu_realm_notify_thread,
+							IRQF_ONESHOT,
+							"arm-smmu-v3-realm-priq",
+							smmu);
+			if (ret < 0)
+				dev_warn(smmu->dev,
+					 "failed to enable realm priq irq\n");
+		} else {
+			dev_warn(smmu->dev, "no realm priq irq - PRI will be broken\n");
+		}
+	}
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4d00d796f078..d5b9ab95beea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,6 +29,9 @@
 #include <linux/string_choices.h>
 #include <kunit/visibility.h>
 #include <uapi/linux/iommufd.h>
+#include <linux/irq.h>
+#include <linux/msi.h>
+#include <asm/rmi_cmds.h>
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
@@ -4000,10 +4003,20 @@ static void arm_smmu_free_msis(void *data)
 
 static void arm_smmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
+	int max_config_index = GERROR_MSI_INDEX;
 	phys_addr_t doorbell;
 	struct device *dev = msi_desc_to_dev(desc);
 	struct arm_smmu_device *smmu = dev_get_drvdata(dev);
-	phys_addr_t *cfg = arm_smmu_msi_cfg[desc->msi_index];
+	phys_addr_t *cfg;
+
+	if (smmu->features & ARM_SMMU_FEAT_PRI)
+		max_config_index = PRIQ_MSI_INDEX;
+
+	/* Don't try to config for Realm interrupts. */
+	if (desc->msi_index > max_config_index)
+		return;
+
+	cfg = arm_smmu_msi_cfg[desc->msi_index];
 
 	doorbell = (((u64)msg->address_hi) << 32) | msg->address_lo;
 	doorbell &= MSI_CFG0_ADDR_MASK;
@@ -4015,6 +4028,7 @@ static void arm_smmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 
 static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 {
+	int irq_index;
 	int ret, nvec = ARM_SMMU_MAX_MSIS;
 	struct device *dev = smmu->dev;
 
@@ -4035,6 +4049,13 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 		return;
 	}
 
+	/*
+	 * Request for realm side non secure interrupts too. Should this be condition
+	 * on non-secure gic?
+	 */
+	if (smmu->features & ARM_SMMU_FEAT_RME_MSI)
+		nvec = nvec * 2;
+
 	/* Allocate MSIs for evtq, gerror and priq. Ignore cmdq */
 	ret = platform_device_msi_init_and_alloc_irqs(dev, nvec, arm_smmu_write_msi_msg);
 	if (ret) {
@@ -4044,7 +4065,19 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 
 	smmu->evtq.q.irq = msi_get_virq(dev, EVTQ_MSI_INDEX);
 	smmu->gerr_irq = msi_get_virq(dev, GERROR_MSI_INDEX);
-	smmu->priq.q.irq = msi_get_virq(dev, PRIQ_MSI_INDEX);
+	irq_index = 2;
+	if (smmu->features & ARM_SMMU_FEAT_PRI) {
+		smmu->priq.q.irq = msi_get_virq(dev, PRIQ_MSI_INDEX);
+		irq_index++;
+	}
+
+	if (smmu->features & ARM_SMMU_FEAT_RME_MSI) {
+		smmu->realm_evtq_irq = msi_get_virq(dev, irq_index++);
+		smmu->realm_gerr_irq = msi_get_virq(dev, irq_index++);
+		// fixme, we should check for pri rmm capability
+		if (smmu->features & ARM_SMMU_FEAT_PRI)
+			smmu->realm_pri_irq = msi_get_virq(dev, irq_index++);
+	}
 
 	/* Add callback to free MSIs on teardown */
 	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
@@ -4094,6 +4127,9 @@ static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
 			dev_warn(smmu->dev, "no priq irq - PRI will be broken\n");
 		}
 	}
+
+	if (smmu->features & ARM_SMMU_FEAT_RME_IRQ)
+		arm_smmu_setup_realm_irqs(smmu);
 }
 
 static int arm_smmu_setup_irqs(struct arm_smmu_device *smmu)
@@ -4464,6 +4500,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	smmu->asid_bits = reg & IDR0_ASID16 ? 16 : 8;
 	smmu->vmid_bits = reg & IDR0_VMID16 ? 16 : 8;
 
+	if (reg & IDR0_RME_IMPL)
+		smmu->features |= ARM_SMMU_FEAT_RME;
+
 	/* IDR1 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
 	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL)) {
@@ -4852,6 +4891,7 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	ioaddr = res->start;
+	smmu->base_phys = ioaddr;
 
 	/*
 	 * Don't map the IMPLEMENTATION DEFINED regions, since they may contain
@@ -4893,6 +4933,43 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (rmm_is_active()) {
+		struct rmi_psmmu_info *psmmu_info;
+
+		psmmu_info = (struct rmi_psmmu_info *)get_zeroed_page(GFP_KERNEL);
+		if (!psmmu_info)
+			goto skip_rmm_config;
+
+		if (rmi_psmmu_info(smmu->base_phys, virt_to_phys(psmmu_info)))
+			smmu->features &= ~ARM_SMMU_FEAT_RME;
+
+		if ((psmmu_info->flags & RMI_PSMMU_IRQCFG_MASK) ==
+		    RMI_PSMMU_IRQCFG_IRQ_DISABLED) {
+			free_page((unsigned long)psmmu_info);
+			goto skip_rmm_config;
+		}
+
+		smmu->features |= ARM_SMMU_FEAT_RME_IRQ;
+
+		if ((psmmu_info->flags & RMI_PSMMU_IRQCFG_MASK) ==
+		    RMI_PSMMU_IRQCFG_IRQ_WIRED) {
+			smmu->realm_gerr_irq = psmmu_info->gerror_intr_num;
+			smmu->realm_evtq_irq = psmmu_info->eventq_intr_num;
+			smmu->realm_pri_irq = psmmu_info->priq_intr_num;
+
+			/* Disable RME FEAT because RMM need cmdq sync interrupt*/
+			if (psmmu_info->cmdq_sync_intr_num)
+				smmu->features &= ~ARM_SMMU_FEAT_RME;
+
+		} else if ((psmmu_info->flags & RMI_PSMMU_IRQCFG_MASK) ==
+			   RMI_PSMMU_IRQCFG_IRQ_MSI) {
+			smmu->features |= ARM_SMMU_FEAT_RME_MSI;
+		}
+
+		free_page((unsigned long)psmmu_info);
+	}
+skip_rmm_config:
+
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3c6d65d36164..6680516b571b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -20,6 +20,7 @@ struct arm_vsmmu;
 
 /* MMIO registers */
 #define ARM_SMMU_IDR0			0x0
+#define IDR0_RME_IMPL			(1 << 30)
 #define IDR0_ST_LVL			GENMASK(28, 27)
 #define IDR0_ST_LVL_2LVL		1
 #define IDR0_STALL_MODEL		GENMASK(25, 24)
@@ -739,6 +740,7 @@ struct arm_smmu_device {
 	struct device			*impl_dev;
 	const struct arm_smmu_impl_ops	*impl_ops;
 
+	phys_addr_t			base_phys;
 	void __iomem			*base;
 	void __iomem			*page1;
 
@@ -767,6 +769,9 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_HD		(1 << 22)
 #define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 #define ARM_SMMU_FEAT_BBML2		(1 << 24)
+#define ARM_SMMU_FEAT_RME		(1 << 25)
+#define ARM_SMMU_FEAT_RME_IRQ		(1 << 26)
+#define ARM_SMMU_FEAT_RME_MSI		(1 << 27)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
@@ -782,6 +787,9 @@ struct arm_smmu_device {
 
 	int				gerr_irq;
 	int				combined_irq;
+	int				realm_gerr_irq;
+	int				realm_evtq_irq;
+	int				realm_pri_irq;
 
 	unsigned long			oas; /* PA */
 	unsigned long			pgsize_bitmap;
@@ -1096,4 +1104,6 @@ static inline int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster,
 }
 #endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
 
+void arm_smmu_setup_realm_irqs(struct arm_smmu_device *smmu);
+
 #endif /* _ARM_SMMU_V3_H */
-- 
2.43.0

