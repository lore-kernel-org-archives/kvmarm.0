From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 1/9] KVM: arm/arm64: vgic: Define GICD_IIDR fields for
 GICv2 and GIv3
Date: Sat, 14 Jul 2018 19:05:32 +0200
Message-ID: <1531587940-2490-2-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40EBE4A0F1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-vt7CfLHZqW for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:08 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02hn0212.outbound.protection.outlook.com [104.47.6.212])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A94D4A10C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:07 -0400 (EDT)
In-Reply-To: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Instead of hardcoding the shifts and masks in the GICD_IIDR register
emulation, let's add the definition of these fields to the GIC header
files and use them.

This will make things more obvious when we're going to bump the revision
in the IIDR when we'll make guest-visible changes to the implementation.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 10 ++++++++++
 include/linux/irqchip/arm-gic.h    | 10 ++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c   |  3 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c   |  3 ++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index cbb872c..b22f9df 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -61,6 +61,16 @@
 #define GICD_CTLR_ENABLE_G1A           (1U << 1)
 #define GICD_CTLR_ENABLE_G1            (1U << 0)

+#define GICD_IIDR_IMPLEMENTER_SHIFT    0
+#define GICD_IIDR_IMPLEMENTER_MASK     (0xfff << GICD_IIDR_IMPLEMENTER_SHIFT)
+#define GICD_IIDR_REVISION_SHIFT       12
+#define GICD_IIDR_REVISION_MASK                (0xf << GICD_IIDR_REVISION_SHIFT)
+#define GICD_IIDR_VARIANT_SHIFT                16
+#define GICD_IIDR_VARIANT_MASK         (0xf << GICD_IIDR_VARIANT_SHIFT)
+#define GICD_IIDR_PRODUCT_ID_SHIFT     24
+#define GICD_IIDR_PRODUCT_ID_MASK      (0xff << GICD_IIDR_PRODUCT_ID_SHIFT)
+
+
 /*
  * In systems with a single security state (what we emulate in KVM)
  * the meaning of the interrupt group enable bits is slightly different
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 68d8b1f..484f5bf 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -71,6 +71,16 @@
                                        (GICD_INT_DEF_PRI << 8) |\
                                        GICD_INT_DEF_PRI)

+#define GICD_IIDR_IMPLEMENTER_SHIFT    0
+#define GICD_IIDR_IMPLEMENTER_MASK     (0xfff << GICD_IIDR_IMPLEMENTER_SHIFT)
+#define GICD_IIDR_REVISION_SHIFT       12
+#define GICD_IIDR_REVISION_MASK                (0xf << GICD_IIDR_REVISION_SHIFT)
+#define GICD_IIDR_VARIANT_SHIFT                16
+#define GICD_IIDR_VARIANT_MASK         (0xf << GICD_IIDR_VARIANT_SHIFT)
+#define GICD_IIDR_PRODUCT_ID_SHIFT     24
+#define GICD_IIDR_PRODUCT_ID_MASK      (0xff << GICD_IIDR_PRODUCT_ID_SHIFT)
+
+
 #define GICH_HCR                       0x0
 #define GICH_VTR                       0x4
 #define GICH_VMCR                      0x8
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index ffc587b..af44e569 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -37,7 +37,8 @@ static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
                value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
                break;
        case GIC_DIST_IIDR:
-               value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+               value = (PRODUCT_ID_KVM << GICD_IIDR_PRODUCT_ID_SHIFT) |
+                       (IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
                break;
        default:
                return 0;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 2877840..c03f424 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -81,7 +81,8 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
                }
                break;
        case GICD_IIDR:
-               value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+               value = (PRODUCT_ID_KVM << GICD_IIDR_PRODUCT_ID_SHIFT) |
+                       (IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
                break;
        default:
                return 0;
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
