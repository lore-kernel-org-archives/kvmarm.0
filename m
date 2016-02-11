From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 11/15] msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
Date: Thu, 11 Feb 2016 14:34:18 +0000
Message-ID: <1455201262-5259-12-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA5A49A0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JUJzZSP-fSNx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:42 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7D3049B74
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:42 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id p63so75967549wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:38 -0800 (PST)
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
List-Id: kvmarm@lists.cs.columbia.edu

Let's introduce a new msi_domain_info flag value, MSI_FLAG_IRQ_REMAPPING
meant to tell the domain supports IRQ REMAPPING, also known as Interrupt
Translation Service. On Intel HW this capability is abstracted on IOMMU
side while on ARM it is abstracted on MSI controller side.

GICv3 ITS HW is the first HW advertising that feature.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 1 +
 include/linux/msi.h              | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3447549..a5e0d8b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1544,6 +1544,7 @@ static int its_probe(struct device_node *node, struct irq_domain *parent)
 		inner_domain->parent = parent;
 		inner_domain->bus_token = DOMAIN_BUS_NEXUS;
 		info->ops = &its_msi_domain_ops;
+		info->flags |= MSI_FLAG_IRQ_REMAPPING;
 		info->data = its;
 		inner_domain->host_data = info;
 	}
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
