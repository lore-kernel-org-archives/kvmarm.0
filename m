From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 1/8] vfio: introduce a vfio_dma type field
Date: Tue, 19 Jul 2016 13:11:27 +0000
Message-ID: <1468933894-23250-2-git-send-email-eric.auger@redhat.com>
References: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a vfio_dma type since we will need to discriminate
different types of dma slots:
- VFIO_IOVA_USER: IOVA region used to map user vaddr
- VFIO_IOVA_RESERVED_MSI: IOVA region reserved to map MSI doorbells

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v9 -> v10:
- renamed VFIO_IOVA_RESERVED into VFIO_IOVA_RESERVED_MSI
- explicitly set type to VFIO_IOVA_USER on dma_map

v6 -> v7:
- add VFIO_IOVA_ANY
- do not introduce yet any VFIO_IOVA_RESERVED handling
---
 drivers/vfio/vfio_iommu_type1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ba1942..a9f8b93 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -53,6 +53,12 @@ module_param_named(disable_hugepages,
 MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
 
+enum vfio_iova_type {
+	VFIO_IOVA_USER = 0,	/* standard IOVA used to map user vaddr */
+	VFIO_IOVA_RESERVED_MSI,	/* reserved to map MSI doorbells */
+	VFIO_IOVA_ANY,		/* matches any IOVA type */
+};
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct mutex		lock;
@@ -75,6 +81,7 @@ struct vfio_dma {
 	unsigned long		vaddr;		/* Process virtual addr */
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
+	enum vfio_iova_type	type;		/* type of IOVA */
 };
 
 struct vfio_group {
@@ -607,6 +614,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	dma->iova = iova;
 	dma->vaddr = vaddr;
 	dma->prot = prot;
+	dma->type = VFIO_IOVA_USER;
 
 	/* Insert zero-sized and grow as we map chunks of it */
 	vfio_link_dma(iommu, dma);
-- 
1.9.1

