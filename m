From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 03/10] genirq/irq: introduce msi_doorbell_info
Date: Tue, 19 Jul 2016 13:02:40 +0000
Message-ID: <1468933367-23159-4-git-send-email-eric.auger@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7857A4011D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:57:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UDh8P97W79t2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 08:57:04 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BB96411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:57:04 -0400 (EDT)
In-Reply-To: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

The purpose is to be able to retrieve the MSI doorbells of an irqchip.
This is now needed since on some platforms those doorbells must be
iommu mapped (in case the MSIs transit through an IOMMU that do not
bypass those transactions).

The assumption is there is a maximum of one doorbell region per cpu. The
doorbell can be global or per cpu.

A doorbell region is characterized by its physical address base, size,
IOMMU protection flag and whether it implements IRQ remapping (aka.
IRQ translation). Those characteristics are shared among all doorbells.

irq_chip msi_doorbell_info callback enables to retrieve the doorbells of
the irqchip.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v10 -> v11:
- disappeared in V10 and restored now. struct irq_chip_msi_doorbell_info
  is identifical to the one in V10 (union, irq_remapping field).

v7 -> v8:
- size and prot now are shared among all doorbells
- doorbells now directly points to a percpu phys_addr_t

v7: creation
---
 include/linux/irq.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4d758a7..2e355d5 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -312,6 +312,18 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
 	return d->hwirq;
 }
 
+/* Describe all the MSI doorbell regions for an irqchip */
+struct irq_chip_msi_doorbell_info {
+	union {
+		phys_addr_t __percpu *percpu_doorbells;
+		phys_addr_t global_doorbell;
+	};
+	bool doorbell_is_percpu;
+	bool irq_remapping;	/* is irq_remapping implemented? */
+	size_t size;				/* size of each doorbell */
+	int prot;				/* iommu protection flag */
+};
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
@@ -349,6 +361,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_get_irqchip_state:	return the internal state of an interrupt
  * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @irq_set_vcpu_affinity:	optional to target a vCPU in a virtual machine
+ * @msi_doorbell_info:	return the MSI doorbell info
  * @ipi_send_single:	send a single IPI to destination cpus
  * @ipi_send_mask:	send an IPI to destination cpus in cpumask
  * @flags:		chip specific flags
@@ -394,7 +407,8 @@ struct irq_chip {
 	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
 
 	int		(*irq_set_vcpu_affinity)(struct irq_data *data, void *vcpu_info);
-
+	struct irq_chip_msi_doorbell_info *(*msi_doorbell_info)(
+							struct irq_data *data);
 	void		(*ipi_send_single)(struct irq_data *data, unsigned int cpu);
 	void		(*ipi_send_mask)(struct irq_data *data, const struct cpumask *dest);
 
-- 
1.9.1
