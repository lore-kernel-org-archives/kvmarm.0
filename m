From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 09/13] KVM: arm/arm64: vgic: support irqfd injection of a
 mapped IRQ
Date: Thu, 19 Nov 2015 14:53:59 +0000
Message-ID: <1447944843-17731-10-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51168499E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jCZfgxD1g8Ln for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:46 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AC5849969
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:46 -0500 (EST)
Received: by wmec201 with SMTP id c201so121307484wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:25 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Up to now irqfd injection was only possible for unmapped IRQ. This
patch adds support for injecting mapped interrupts.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index dba8eb6..e96f79e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2476,13 +2476,21 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
 int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 		u32 irq, int level, bool line_status)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+	struct irq_phys_map *map;
+	int vcpu_id;
 
 	trace_kvm_set_irq(irq, level, irq_source_id);
 
 	BUG_ON(!vgic_initialized(kvm));
 
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	vcpu_id = dist->irq_spi_cpu[irq];
+	map = vgic_irq_map_search(kvm_get_vcpu(kvm, vcpu_id), spi);
+	if (!map)
+		return kvm_vgic_inject_irq(kvm, vcpu_id, spi, level);
+	else
+		return kvm_vgic_inject_mapped_irq(kvm, vcpu_id, map, level);
 }
 
 /* MSI not implemented yet */
-- 
1.9.1
