From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 07/14] msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
Date: Fri, 26 Feb 2016 17:35:47 +0000
Message-ID: <1456508154-2253-8-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18627412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RyQCqd9hAGhY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:29 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1862941390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:29 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id a4so79227469wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:21 -0800 (PST)
In-Reply-To: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
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

Let's introduce a new msi_domain_info flag value, MSI_FLAG_IRQ_REMAPPING
meant to tell the domain supports IRQ REMAPPING, also known as Interrupt
Translation Service. On Intel HW this capability is abstracted on IOMMU
side while on ARM it is abstracted on MSI controller side.

GICv3 ITS HW is the first HW advertising that feature.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/irqchip/irq-gic-v3-its-pci-msi.c | 3 ++-
 include/linux/msi.h                      | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its-pci-msi.c b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
index aee60ed..8223765 100644
--- a/drivers/irqchip/irq-gic-v3-its-pci-msi.c
+++ b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
@@ -96,7 +96,8 @@ static struct msi_domain_ops its_pci_msi_ops = {
 
 static struct msi_domain_info its_pci_msi_domain_info = {
 	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		   MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX),
+		   MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX |
+		   MSI_FLAG_IRQ_REMAPPING),
 	.ops	= &its_pci_msi_ops,
 	.chip	= &its_msi_irq_chip,
 };
diff --git a/include/linux/msi.h b/include/linux/msi.h
index a2a0068..03eda72 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -261,6 +261,8 @@ enum {
 	MSI_FLAG_MULTI_PCI_MSI		= (1 << 3),
 	/* Support PCI MSIX interrupts */
 	MSI_FLAG_PCI_MSIX		= (1 << 4),
+	/* Support MSI IRQ remapping service */
+	MSI_FLAG_IRQ_REMAPPING		= (1 << 5),
 };
 
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
-- 
1.9.1
