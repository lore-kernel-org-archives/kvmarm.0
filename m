From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 08/10] KVM: arm/arm64: vgic: support irqfd injection of a
 forwarded IRQ
Date: Mon, 10 Aug 2015 15:21:02 +0200
Message-ID: <1439212864-12954-9-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3B15A6B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OOEH2014IOA5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:09:04 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42A075A6BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:04 -0400 (EDT)
Received: by wicja10 with SMTP id ja10so36951243wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:22:05 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently irqfd injection relies on kvm_vgic_inject_irq function.
However this function cannot be used anymore for mapped IRQs. So
let's change the implementation to use kvm_vgic_inject_mapped_irq
when the IRQ is forwarded.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index fbd5ba5..03a85b3 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2529,13 +2529,19 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
 int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 		u32 irq, int level, bool line_status)
 {
+	struct irq_phys_map *map;
 	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
 
 	trace_kvm_set_irq(irq, level, irq_source_id);
 
 	BUG_ON(!vgic_initialized(kvm));
 
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	map = vgic_irq_map_search(kvm_get_vcpu(kvm, 0), spi);
+
+	if (!map)
+		return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	else
+		return kvm_vgic_inject_mapped_irq(kvm, 0, map, level);
 }
 
 /* MSI not implemented yet */
-- 
1.9.1
