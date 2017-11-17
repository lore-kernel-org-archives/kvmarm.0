From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [RFC PATCH v2 4/5] ACPI/IORT: Support paravirtualized IOMMU
Date: Fri, 17 Nov 2017 18:52:10 +0000
Message-ID: <20171117185211.32593-5-jean-philippe.brucker@arm.com>
References: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
Return-path: <virtio-dev-return-2699-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
To: iommu@lists.linux-foundation.org, devel@acpica.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org
Cc: jasowang@redhat.com, mst@redhat.com, lv.zheng@intel.com, robert.moore@intel.com, joro@8bytes.org, alex.williamson@redhat.com, sudeep.holla@arm.com, hanjun.guo@linaro.org, lorenzo.pieralisi@arm.com, lenb@kernel.org, rjw@rjwysocki.net, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, eric.auger@redhat.com, bharat.bhushan@nxp.com, Jayachandran.Nair@cavium.com, ashok.raj@intel.com, peterx@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

To describe the virtual topology in relation to a virtio-iommu device,
ACPI-based systems use a "paravirtualized IOMMU" IORT node. Add support
for it.

This is a RFC because the IORT specification doesn't describe the
paravirtualized node at the moment, it is only provided as an example in
the virtio-iommu spec. What we need to do first is confirm that x86
kernels are able to use the IORT driver with the virtio-iommu. There isn't
anything specific to arm64 in the driver but there might be other blockers
we're not aware of (I know for example that x86 also requires custom DMA
ops rather than iommu-dma ones, but it's unrelated) so this needs to be
tested on the x86 prototype.

Rationale: virtio-iommu requires an ACPI table to be passed between host
and guest that describes its relation to PCI and platform endpoints in the
virtual system. A table that maps PCI RIDs and integrated devices to IOMMU
device IDs, telling the IOMMU driver which endpoints it manages.

As far as I'm aware, there are three existing tables that solve this
problem: Intel DMAR, AMD IVRS and ARM IORT. The first two are specific to
Intel VT-d and AMD IOMMU respectively, while the third describes multiple
remapping devices -- currently only ARM IOMMUs and MSI controllers, but it
is easy to extend.

IORT table and drivers are easiest to extend and they do the job, so
rather than introducing a fourth solution to solve a generic problem,
reuse what exists.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/acpi/arm64/iort.c | 95 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/iommu/Kconfig     |  1 +
 include/acpi/actbl2.h     | 18 ++++++++-
 3 files changed, 106 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index fde279b0a6d8..c7132e4a0560 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -29,7 +29,8 @@
 #define IORT_TYPE_MASK(type)	(1 << (type))
 #define IORT_MSI_TYPE		(1 << ACPI_IORT_NODE_ITS_GROUP)
 #define IORT_IOMMU_TYPE		((1 << ACPI_IORT_NODE_SMMU) |	\
-				(1 << ACPI_IORT_NODE_SMMU_V3))
+				(1 << ACPI_IORT_NODE_SMMU_V3) | \
+				(1 << ACPI_IORT_NODE_PARAVIRT))
 
 /* Until ACPICA headers cover IORT rev. C */
 #ifndef ACPI_IORT_SMMU_V3_CAVIUM_CN99XX
@@ -616,6 +617,8 @@ static inline bool iort_iommu_driver_enabled(u8 type)
 		return IS_BUILTIN(CONFIG_ARM_SMMU_V3);
 	case ACPI_IORT_NODE_SMMU:
 		return IS_BUILTIN(CONFIG_ARM_SMMU);
+	case ACPI_IORT_NODE_PARAVIRT:
+		return IS_BUILTIN(CONFIG_VIRTIO_IOMMU);
 	default:
 		pr_warn("IORT node type %u does not describe an SMMU\n", type);
 		return false;
@@ -1062,6 +1065,48 @@ static bool __init arm_smmu_is_coherent(struct acpi_iort_node *node)
 	return smmu->flags & ACPI_IORT_SMMU_COHERENT_WALK;
 }
 
+static int __init paravirt_count_resources(struct acpi_iort_node *node)
+{
+	struct acpi_iort_pviommu *pviommu;
+
+	pviommu = (struct acpi_iort_pviommu *)node->node_data;
+
+	/* Mem + IRQs */
+	return 1 + pviommu->interrupt_count;
+}
+
+static void __init paravirt_init_resources(struct resource *res,
+					   struct acpi_iort_node *node)
+{
+	int i;
+	int num_res = 0;
+	int hw_irq, trigger;
+	struct acpi_iort_pviommu *pviommu;
+
+	pviommu = (struct acpi_iort_pviommu *)node->node_data;
+
+	res[num_res].start = pviommu->base_address;
+	res[num_res].end = pviommu->base_address + pviommu->span - 1;
+	res[num_res].flags = IORESOURCE_MEM;
+	num_res++;
+
+	for (i = 0; i < pviommu->interrupt_count; i++) {
+		hw_irq = IORT_IRQ_MASK(pviommu->interrupts[i]);
+		trigger = IORT_IRQ_TRIGGER_MASK(pviommu->interrupts[i]);
+
+		acpi_iort_register_irq(hw_irq, "pviommu", trigger, &res[num_res++]);
+	}
+}
+
+static bool __init paravirt_is_coherent(struct acpi_iort_node *node)
+{
+	struct acpi_iort_pviommu *pviommu;
+
+	pviommu = (struct acpi_iort_pviommu *)node->node_data;
+
+	return pviommu->flags & ACPI_IORT_NODE_PV_CACHE_COHERENT;
+}
+
 struct iort_iommu_config {
 	const char *name;
 	int (*iommu_init)(struct acpi_iort_node *node);
@@ -1088,6 +1133,13 @@ static const struct iort_iommu_config iort_arm_smmu_cfg __initconst = {
 	.iommu_init_resources = arm_smmu_init_resources
 };
 
+static const struct iort_iommu_config iort_paravirt_cfg __initconst = {
+	.name = "pviommu",
+	.iommu_is_coherent = paravirt_is_coherent,
+	.iommu_count_resources = paravirt_count_resources,
+	.iommu_init_resources = paravirt_init_resources
+};
+
 static __init
 const struct iort_iommu_config *iort_get_iommu_cfg(struct acpi_iort_node *node)
 {
@@ -1096,18 +1148,22 @@ const struct iort_iommu_config *iort_get_iommu_cfg(struct acpi_iort_node *node)
 		return &iort_arm_smmu_v3_cfg;
 	case ACPI_IORT_NODE_SMMU:
 		return &iort_arm_smmu_cfg;
+	case ACPI_IORT_NODE_PARAVIRT:
+		return &iort_paravirt_cfg;
 	default:
 		return NULL;
 	}
 }
 
 /**
- * iort_add_smmu_platform_device() - Allocate a platform device for SMMU
- * @node: Pointer to SMMU ACPI IORT node
+ * iort_add_iommu_platform_device() - Allocate a platform device for an IOMMU
+ * @node: Pointer to IOMMU ACPI IORT node
+ * @name: Base name of the device
  *
  * Returns: 0 on success, <0 failure
  */
-static int __init iort_add_smmu_platform_device(struct acpi_iort_node *node)
+static int __init iort_add_iommu_platform_device(struct acpi_iort_node *node,
+						 const char *name)
 {
 	struct fwnode_handle *fwnode;
 	struct platform_device *pdev;
@@ -1119,7 +1175,7 @@ static int __init iort_add_smmu_platform_device(struct acpi_iort_node *node)
 	if (!ops)
 		return -ENODEV;
 
-	pdev = platform_device_alloc(ops->name, PLATFORM_DEVID_AUTO);
+	pdev = platform_device_alloc(name, PLATFORM_DEVID_AUTO);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -1189,6 +1245,28 @@ static int __init iort_add_smmu_platform_device(struct acpi_iort_node *node)
 	return ret;
 }
 
+static int __init iort_add_smmu_platform_device(struct acpi_iort_node *node)
+{
+	const struct iort_iommu_config *ops = iort_get_iommu_cfg(node);
+
+	if (!ops)
+		return -ENODEV;
+
+	return iort_add_iommu_platform_device(node, ops->name);
+}
+
+static int __init iort_add_paravirt_platform_device(struct acpi_iort_node *node)
+{
+	struct acpi_iort_pviommu *pviommu;
+
+	pviommu = (struct acpi_iort_pviommu *)node->node_data;
+
+	if (WARN_ON(pviommu->model != ACPI_IORT_NODE_PV_VIRTIO_IOMMU))
+		return -ENODEV;
+
+	return iort_add_iommu_platform_device(node, "virtio-mmio");
+}
+
 static bool __init iort_enable_acs(struct acpi_iort_node *iort_node)
 {
 	if (iort_node->type == ACPI_IORT_NODE_PCI_ROOT_COMPLEX) {
@@ -1250,7 +1328,8 @@ static void __init iort_init_platform_devices(void)
 			acs_enabled = iort_enable_acs(iort_node);
 
 		if ((iort_node->type == ACPI_IORT_NODE_SMMU) ||
-			(iort_node->type == ACPI_IORT_NODE_SMMU_V3)) {
+			(iort_node->type == ACPI_IORT_NODE_SMMU_V3) ||
+			(iort_node->type == ACPI_IORT_NODE_PARAVIRT)) {
 
 			fwnode = acpi_alloc_fwnode_static();
 			if (!fwnode)
@@ -1258,7 +1337,9 @@ static void __init iort_init_platform_devices(void)
 
 			iort_set_fwnode(iort_node, fwnode);
 
-			ret = iort_add_smmu_platform_device(iort_node);
+			ret = iort_node->type == ACPI_IORT_NODE_PARAVIRT ?
+				iort_add_paravirt_platform_device(iort_node) :
+				iort_add_smmu_platform_device(iort_node);
 			if (ret) {
 				iort_delete_fwnode(iort_node);
 				acpi_free_fwnode_static(fwnode);
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 7271e59e8b23..3e28a5d682c3 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -409,6 +409,7 @@ config VIRTIO_IOMMU
 	select IOMMU_API
 	select INTERVAL_TREE
 	select ARM_DMA_USE_IOMMU if ARM
+	select ACPI_IORT
 	help
 	  Para-virtualised IOMMU driver with virtio.
 
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 686b6f8c09dc..23ae5bbc36d1 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -696,7 +696,8 @@ enum acpi_iort_node_type {
 	ACPI_IORT_NODE_NAMED_COMPONENT = 0x01,
 	ACPI_IORT_NODE_PCI_ROOT_COMPLEX = 0x02,
 	ACPI_IORT_NODE_SMMU = 0x03,
-	ACPI_IORT_NODE_SMMU_V3 = 0x04
+	ACPI_IORT_NODE_SMMU_V3 = 0x04,
+	ACPI_IORT_NODE_PARAVIRT = 0x05,
 };
 
 struct acpi_iort_id_mapping {
@@ -824,6 +825,21 @@ struct acpi_iort_smmu_v3 {
 #define ACPI_IORT_SMMU_V3_HTTU_OVERRIDE     (1<<1)
 #define ACPI_IORT_SMMU_V3_PXM_VALID         (1<<3)
 
+struct acpi_iort_pviommu {
+	u64 base_address;
+	u64 span;
+	u32 model;
+	u32 flags;
+	u32 interrupt_count;
+	u64 interrupts[];
+};
+
+enum acpi_iort_paravirt_node_model {
+	ACPI_IORT_NODE_PV_VIRTIO_IOMMU = 0x00,
+};
+
+#define ACPI_IORT_NODE_PV_CACHE_COHERENT    (1<<0)
+
 /*******************************************************************************
  *
  * IVRS - I/O Virtualization Reporting Structure
-- 
2.14.3
