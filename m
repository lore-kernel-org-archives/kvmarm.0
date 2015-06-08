From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/10] KVM: arm/arm64: vgic: Convert struct vgic_lr to use bitfields
Date: Mon,  8 Jun 2015 18:03:58 +0100
Message-ID: <1433783045-8002-4-git-send-email-marc.zyngier@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to cram more information in the vgic_lr structure
(HW interrupt number and additional state information), we switch
to a layout similar to the HW's:

- use bitfields to save space (we don't need more than 10 bits
  to represent the irq numbers)
- source CPU and HW interrupt can share the same field, as
  a SGI doesn't have a physical line.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 133ea00..4f9fa1d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -95,11 +95,15 @@ enum vgic_type {
 #define LR_STATE_ACTIVE		(1 << 1)
 #define LR_STATE_MASK		(3 << 0)
 #define LR_EOI_INT		(1 << 2)
+#define LR_HW			(1 << 3)
 
 struct vgic_lr {
-	u16	irq;
-	u8	source;
-	u8	state;
+	unsigned irq:10;
+	union {
+		unsigned hwirq:10;
+		unsigned source:8;
+	};
+	unsigned state:4;
 };
 
 struct vgic_vmcr {
-- 
2.1.4

