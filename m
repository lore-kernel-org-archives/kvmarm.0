From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 20/20] iommu/smmuv3: Report non recoverable faults
Date: Tue, 18 Sep 2018 16:24:57 +0200
Message-ID: <20180918142457.3325-21-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

When a stage 1 related fault event is read from the event queue,
let's propagate it to potential external fault listeners, ie. users
who registered a fault handler.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 124 ++++++++++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index d9d300ab62a5..948fc82fc4ce 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -178,6 +178,26 @@
 #define ARM_SMMU_PRIQ_IRQ_CFG1		0xd8
 #define ARM_SMMU_PRIQ_IRQ_CFG2		0xdc
 
+/* Events */
+#define ARM_SMMU_EVT_F_UUT		0x01
+#define ARM_SMMU_EVT_C_BAD_STREAMID	0x02
+#define ARM_SMMU_EVT_F_STE_FETCH	0x03
+#define ARM_SMMU_EVT_C_BAD_STE		0x04
+#define ARM_SMMU_EVT_F_BAD_ATS_TREQ	0x05
+#define ARM_SMMU_EVT_F_STREAM_DISABLED	0x06
+#define ARM_SMMU_EVT_F_TRANSL_FORBIDDEN	0x07
+#define ARM_SMMU_EVT_C_BAD_SUBSTREAMID	0x08
+#define ARM_SMMU_EVT_F_CD_FETCH		0x09
+#define ARM_SMMU_EVT_C_BAD_CD		0x0a
+#define ARM_SMMU_EVT_F_WALK_EABT	0x0b
+#define ARM_SMMU_EVT_F_TRANSLATION	0x10
+#define ARM_SMMU_EVT_F_ADDR_SIZE	0x11
+#define ARM_SMMU_EVT_F_ACCESS		0x12
+#define ARM_SMMU_EVT_F_PERMISSION	0x13
+#define ARM_SMMU_EVT_F_TLB_CONFLICT	0x20
+#define ARM_SMMU_EVT_F_CFG_CONFLICT	0x21
+#define ARM_SMMU_EVT_E_PAGE_REQUEST	0x24
+
 /* Common MSI config fields */
 #define MSI_CFG0_ADDR_MASK		GENMASK_ULL(51, 2)
 #define MSI_CFG2_SH			GENMASK(5, 4)
@@ -343,6 +363,11 @@
 #define EVTQ_MAX_SZ_SHIFT		7
 
 #define EVTQ_0_ID			GENMASK_ULL(7, 0)
+#define EVTQ_0_SUBSTREAMID		GENMASK_ULL(31, 12)
+#define EVTQ_0_STREAMID			GENMASK_ULL(63, 32)
+#define EVTQ_1_S2			GENMASK_ULL(39, 39)
+#define EVTQ_1_CLASS			GENMASK_ULL(40, 41)
+#define EVTQ_3_FETCH_ADDR		GENMASK_ULL(51, 3)
 
 /* PRI queue */
 #define PRIQ_ENT_DWORDS			2
@@ -1250,7 +1275,6 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	return 0;
 }
 
-__maybe_unused
 static struct arm_smmu_master_data *
 arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 {
@@ -1276,24 +1300,102 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 	return master;
 }
 
+static void arm_smmu_report_event(struct arm_smmu_device *smmu, u64 *evt)
+{
+	u64 fetch_addr = FIELD_GET(EVTQ_3_FETCH_ADDR, evt[3]);
+	u32 sid = FIELD_GET(EVTQ_0_STREAMID, evt[0]);
+	bool s1 = !FIELD_GET(EVTQ_1_S2, evt[1]);
+	u8 type = FIELD_GET(EVTQ_0_ID, evt[0]);
+	struct arm_smmu_master_data *master;
+	struct iommu_fault_event event;
+	bool propagate = true;
+	u64 addr = evt[2];
+	int i;
+
+	master = arm_smmu_find_master(smmu, sid);
+	if (WARN_ON(!master))
+		return;
+
+	event.fault.type = IOMMU_FAULT_DMA_UNRECOV;
+
+	switch (type) {
+	case ARM_SMMU_EVT_C_BAD_STREAMID:
+		event.fault.reason = IOMMU_FAULT_REASON_SOURCEID_INVALID;
+		break;
+	case ARM_SMMU_EVT_F_STREAM_DISABLED:
+	case ARM_SMMU_EVT_C_BAD_SUBSTREAMID:
+		event.fault.reason = IOMMU_FAULT_REASON_PASID_INVALID;
+		break;
+	case ARM_SMMU_EVT_F_CD_FETCH:
+		event.fault.reason = IOMMU_FAULT_REASON_PASID_FETCH;
+		break;
+	case ARM_SMMU_EVT_F_WALK_EABT:
+		event.fault.reason = IOMMU_FAULT_REASON_WALK_EABT;
+		event.fault.addr = addr;
+		event.fault.fetch_addr = fetch_addr;
+		propagate = s1;
+		break;
+	case ARM_SMMU_EVT_F_TRANSLATION:
+		event.fault.reason = IOMMU_FAULT_REASON_PTE_FETCH;
+		event.fault.addr = addr;
+		event.fault.fetch_addr = fetch_addr;
+		propagate = s1;
+		break;
+	case ARM_SMMU_EVT_F_PERMISSION:
+		event.fault.reason = IOMMU_FAULT_REASON_PERMISSION;
+		event.fault.addr = addr;
+		propagate = s1;
+		break;
+	case ARM_SMMU_EVT_F_ACCESS:
+		event.fault.reason = IOMMU_FAULT_REASON_ACCESS;
+		event.fault.addr = addr;
+		propagate = s1;
+		break;
+	case ARM_SMMU_EVT_C_BAD_STE:
+		event.fault.reason = IOMMU_FAULT_REASON_BAD_DEVICE_CONTEXT_ENTRY;
+		break;
+	case ARM_SMMU_EVT_C_BAD_CD:
+		event.fault.reason = IOMMU_FAULT_REASON_BAD_PASID_ENTRY;
+		break;
+	case ARM_SMMU_EVT_F_ADDR_SIZE:
+		event.fault.reason = IOMMU_FAULT_REASON_OOR_ADDRESS;
+		propagate = s1;
+		break;
+	case ARM_SMMU_EVT_F_STE_FETCH:
+		event.fault.reason = IOMMU_FAULT_REASON_DEVICE_CONTEXT_FETCH;
+		event.fault.fetch_addr = fetch_addr;
+		break;
+	/* End of addition */
+	case ARM_SMMU_EVT_E_PAGE_REQUEST:
+	case ARM_SMMU_EVT_F_TLB_CONFLICT:
+	case ARM_SMMU_EVT_F_CFG_CONFLICT:
+	case ARM_SMMU_EVT_F_BAD_ATS_TREQ:
+	case ARM_SMMU_EVT_F_TRANSL_FORBIDDEN:
+	case ARM_SMMU_EVT_F_UUT:
+	default:
+		event.fault.reason = IOMMU_FAULT_REASON_UNKNOWN;
+	}
+	/* only propagate the error if it relates to stage 1 */
+	if (s1)
+		iommu_report_device_fault(master->dev, &event);
+
+	dev_info(smmu->dev, "event 0x%02x received:\n", type);
+	for (i = 0; i < EVTQ_ENT_DWORDS; ++i) {
+		dev_info(smmu->dev, "\t0x%016llx\n",
+			 (unsigned long long)evt[i]);
+	}
+}
+
 /* IRQ and event handlers */
 static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 {
-	int i;
 	struct arm_smmu_device *smmu = dev;
 	struct arm_smmu_queue *q = &smmu->evtq.q;
 	u64 evt[EVTQ_ENT_DWORDS];
 
 	do {
-		while (!queue_remove_raw(q, evt)) {
-			u8 id = FIELD_GET(EVTQ_0_ID, evt[0]);
-
-			dev_info(smmu->dev, "event 0x%02x received:\n", id);
-			for (i = 0; i < ARRAY_SIZE(evt); ++i)
-				dev_info(smmu->dev, "\t0x%016llx\n",
-					 (unsigned long long)evt[i]);
-
-		}
+		while (!queue_remove_raw(q, evt))
+			arm_smmu_report_event(smmu, evt);
 
 		/*
 		 * Not much we can do on overflow, so scream and pretend we're
-- 
2.17.1
