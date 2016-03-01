From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 11/17] msi: msi_compose wrapper
Date: Tue,  1 Mar 2016 18:27:51 +0000
Message-ID: <1456856877-4817-12-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1B8410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X1EmhCnfqwhK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 13:21:41 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0A3341390
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:40 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id l68so50626371wml.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 10:28:48 -0800 (PST)
In-Reply-To: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently the MSI message is composed by directly calling
irq_chip_compose_msi_msg and erased by setting the memory to zero.

On some platforms, we will need to complexify this composition to
properly handle MSI emission through IOMMU. Also we will need to track
when the MSI message is erased.

We propose to introduce a common wrapper for actual composition and
erasure, msi_compose.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v4 -> v5:
- just introduce the msi-compose wrapper without adding new
  functionalities

v3 -> v4:
- that code was formely in irq-gic-common.c
  "irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI frame when needed"
  also the [un]mapping was done in irq_write_msi_msg; now done on compose

v2 -> v3:
- protect iova/addr manipulation with CONFIG_ARCH_DMA_ADDR_T_64BIT and
  CONFIG_PHYS_ADDR_T_64BIT
- only expose gic_pci_msi_domain_write_msg in case CONFIG_IOMMU_API &
  CONFIG_PCI_MSI_IRQ_DOMAIN are set.
- gic_set/unset_msi_addr duly become static
---
 kernel/irq/msi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 9b0ba4a..72bf4d6 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -55,6 +55,19 @@ static inline void irq_chip_write_msi_msg(struct irq_data *data,
 	data->chip->irq_write_msi_msg(data, msg);
 }
 
+static int msi_compose(struct irq_data *irq_data,
+		       struct msi_msg *msg, bool erase)
+{
+	int ret = 0;
+
+	if (erase)
+		memset(msg, 0, sizeof(*msg));
+	else
+		ret = irq_chip_compose_msi_msg(irq_data, msg);
+
+	return ret;
+}
+
 /**
  * msi_domain_set_affinity - Generic affinity setter function for MSI domains
  * @irq_data:	The irq data associated to the interrupt
@@ -73,7 +86,7 @@ int msi_domain_set_affinity(struct irq_data *irq_data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		BUG_ON(msi_compose(irq_data, &msg, false));
 		irq_chip_write_msi_msg(irq_data, &msg);
 	}
 
@@ -85,7 +98,7 @@ static void msi_domain_activate(struct irq_domain *domain,
 {
 	struct msi_msg msg;
 
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	BUG_ON(msi_compose(irq_data, &msg, false));
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
@@ -94,7 +107,7 @@ static void msi_domain_deactivate(struct irq_domain *domain,
 {
 	struct msi_msg msg;
 
-	memset(&msg, 0, sizeof(msg));
+	msi_compose(irq_data, &msg, true);
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
-- 
1.9.1
