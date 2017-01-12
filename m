From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 06/13] KVM: arm64: ITS: Expose ITT_Entry_Size in GITS_TYPER
Date: Thu, 12 Jan 2017 16:56:46 +0100
Message-ID: <1484236613-24633-7-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

An ITT_Entry_Size of 2x8Bytes is reported to the guest
to provision for ITTE state storage.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/linux/irqchip/arm-gic-v3.h | 1 +
 virt/kvm/arm/vgic/vgic-its.c       | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 170e00a..8cfd81bc 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -233,6 +233,7 @@
 #define GITS_CTLR_QUIESCENT		(1U << 31)
 
 #define GITS_TYPER_PLPIS		(1UL << 0)
+#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
 #define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index e174220..96378b8 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -33,6 +33,8 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+#define ITTE_SIZE 16
+
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
  * If this LPI is already mapped on another ITS, we increase its refcount
@@ -399,6 +401,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 	 */
 	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
 	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
+	reg |= ITTE_SIZE << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
 
 	return extract_bytes(reg, addr & 7, len);
 }
-- 
2.5.5

