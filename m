From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 08/13] iommu/arm-smmu-v3: Link domains and devices
Date: Thu, 23 Aug 2018 14:17:31 +0200
Message-ID: <1535026656-8450-9-git-send-email-eric.auger__11161.1021952287$1535038714$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7D34A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUASsXuGpb8P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:11 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B68D4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:11 -0400 (EDT)
In-Reply-To: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jean-philippe.brucker@arm.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu"@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When removing a mapping from a domain, we need to send an invalidation to
all devices that might have stored it in their Address Translation Cache
(ATC). In addition with SVM, we'll need to invalidate context descriptors
of all devices attached to a live domain.

Maintain a list of devices in each domain, protected by a spinlock. It is
updated every time we attach or detach devices to and from domains.

It needs to be a spinlock because we'll invalidate ATC entries from
within hardirq-safe contexts, but it may be possible to relax the read
side with RCU later.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/iommu/arm-smmu-v3.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 22bdabd..19c085d 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -595,6 +595,11 @@ struct arm_smmu_device {
 struct arm_smmu_master_data {
 	struct arm_smmu_device		*smmu;
 	struct arm_smmu_strtab_ent	ste;
+
+	struct arm_smmu_domain		*domain;
+	struct list_head		list; /* domain->devices */
+
+	struct device			*dev;
 };
 
 /* SMMU private data for an IOMMU domain */
@@ -618,6 +623,9 @@ struct arm_smmu_domain {
 	};
 
 	struct iommu_domain		domain;
+
+	struct list_head		devices;
+	spinlock_t			devices_lock;
 };
 
 struct arm_smmu_option_prop {
@@ -1470,6 +1478,9 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	}
 
 	mutex_init(&smmu_domain->init_mutex);
+	INIT_LIST_HEAD(&smmu_domain->devices);
+	spin_lock_init(&smmu_domain->devices_lock);
+
 	return &smmu_domain->domain;
 }
 
@@ -1685,7 +1696,17 @@ static void arm_smmu_install_ste_for_dev(struct iommu_fwspec *fwspec)
 
 static void arm_smmu_detach_dev(struct device *dev)
 {
+	unsigned long flags;
 	struct arm_smmu_master_data *master = dev->iommu_fwspec->iommu_priv;
+	struct arm_smmu_domain *smmu_domain = master->domain;
+
+	if (smmu_domain) {
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		list_del(&master->list);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+		master->domain = NULL;
+	}
 
 	master->ste.assigned = false;
 	arm_smmu_install_ste_for_dev(dev->iommu_fwspec);
@@ -1694,6 +1715,7 @@ static void arm_smmu_detach_dev(struct device *dev)
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
+	unsigned long flags;
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master_data *master;
@@ -1729,6 +1751,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	ste->assigned = true;
+	master->domain = smmu_domain;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_add(&master->list, &smmu_domain->devices);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_BYPASS) {
 		ste->s1_cfg = NULL;
@@ -1847,6 +1874,7 @@ static int arm_smmu_add_device(struct device *dev)
 			return -ENOMEM;
 
 		master->smmu = smmu;
+		master->dev = dev;
 		fwspec->iommu_priv = master;
 	}
 
-- 
2.5.5
