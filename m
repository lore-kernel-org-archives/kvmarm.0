From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 12/15] msi: export msi_get_domain_info
Date: Thu, 11 Feb 2016 14:34:19 +0000
Message-ID: <1455201262-5259-13-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B2C49AAF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nbY8jA-aoPoZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:47 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBEDE499E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:46 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id g62so23927792wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:42 -0800 (PST)
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

We plan to use msi_get_domain_info in VFIO module so let's export it.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/msi.h | 4 ++++
 kernel/irq/msi.c    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 03eda72..df19315 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -323,6 +323,10 @@ static inline struct irq_domain *pci_msi_get_device_domain(struct pci_dev *pdev)
 {
 	return NULL;
 }
+static struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
+{
+	return NULL;
+}
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
 #endif /* LINUX_MSI_H */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 38e89ce..9b0ba4a 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -400,5 +400,6 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
 {
 	return (struct msi_domain_info *)domain->host_data;
 }
+EXPORT_SYMBOL_GPL(msi_get_domain_info);
 
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
-- 
1.9.1
