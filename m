From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [RFC PATCH 0/6] vfio: Add interface to map MSI pages
Date: Wed, 30 Sep 2015 20:27:40 +0530
Message-ID: <1443625060-24396-1-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF9A410BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:22:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rZ26VYsYaic4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:22:48 -0400 (EDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0110.outbound.protection.outlook.com [157.56.111.110])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14A0540FA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:22:47 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc: marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch series add the interface to map MSI pages in iommu
for msi-capable device pass-through using vfio.

First patch adds a generic interface to set reserved iova regions.
These reserved regions can be used for mapping physical address.
Follow-up patches uses these reserved iova for mapping msi-pages.

This patch series does not provide interface to let user-space know
how many minimum reserved iova regions are required on a given platform.
This interface can be added once this patches series get reviewed and will
be in acceptable state.

Bharat Bhushan (6):
  vfio: Add interface for add/del reserved iova region
  iommu: Add interface to get msi-pages mapping attributes
  vfio: Extend iommu-info to return MSIs automap state
  vfio: Add interface to iommu-map/unmap MSI pages
  vfio-pci: Create iommu mapping for msi interrupt
  arm-smmu: Allow to set iommu mapping for MSI

 drivers/iommu/arm-smmu.c          |   8 +
 drivers/iommu/fsl_pamu_domain.c   |   3 +
 drivers/iommu/iommu.c             |  14 ++
 drivers/vfio/pci/vfio_pci_intrs.c |  36 +++-
 drivers/vfio/vfio.c               |  52 ++++++
 drivers/vfio/vfio_iommu_type1.c   | 344 +++++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h             |   9 +-
 include/linux/vfio.h              |   9 +-
 include/uapi/linux/vfio.h         |  46 +++++
 9 files changed, 516 insertions(+), 5 deletions(-)

-- 
1.9.3
