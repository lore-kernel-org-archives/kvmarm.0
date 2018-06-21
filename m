From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v2 5/5] vfio: Allow type-1 IOMMU instantiation for ARM
Date: Thu, 21 Jun 2018 20:06:55 +0100
Message-ID: <20180621190655.56391-6-jean-philippe.brucker@arm.com>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
Return-path: <virtio-dev-return-4474-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
To: iommu@lists.linux-foundation.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, devicetree@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: joro@8bytes.org, alex.williamson@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, mst@redhat.com, jasowang@redhat.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, eric.auger@redhat.com, peterx@redhat.com, bharat.bhushan@nxp.com, tnowicki@caviumnetworks.com, jayachandran.nair@cavium.com, kevin.tian@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

ARM platforms may implement several kinds of IOMMUs (various SMMU or
SMMUv3 implementations, virtio-iommu). They are all type-1, so
automatically select VFIO_IOMMU_TYPE1 on ARM if IOMMU is selected.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index c84333eb5eb5..9de5ed38da83 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -21,7 +21,7 @@ config VFIO_VIRQFD
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
-	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM_SMMU || ARM_SMMU_V3)
+	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
 	select ANON_INODES
 	help
 	  VFIO provides a framework for secure userspace device drivers.
-- 
2.17.0
