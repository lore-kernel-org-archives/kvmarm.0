From: Jia He <hejianet@gmail.com>
Subject: [PATCH 1/2] KVM: arm/arm64: vgic: move DEBUG_SPINLOCK_BUG_ON to vgic.h
Date: Fri,  3 Aug 2018 21:57:03 +0800
Message-ID: <1533304624-43250-1-git-send-email-jia.he@hxt-semitech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Jia He <hejianet@gmail.com>, Andre Przywara <andre.przywara@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is to let DEBUG_SPINLOCK_BUG_ON be commonly used in vgic-v2 and
vgic-v3.

Signed-off-by: Jia He <jia.he@hxt-semitech.com>
---
 virt/kvm/arm/vgic/vgic.c | 6 ------
 virt/kvm/arm/vgic/vgic.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 33c8325..c22cea6 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -28,12 +28,6 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-#ifdef CONFIG_DEBUG_SPINLOCK
-#define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
-#else
-#define DEBUG_SPINLOCK_BUG_ON(p)
-#endif
-
 struct vgic_global kvm_vgic_global_state __ro_after_init = {
 	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
 };
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index ead00b2..ea51fcc 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -103,6 +103,12 @@
 #define KVM_VGIC_V3_RDIST_COUNT_MASK	GENMASK_ULL(63, 52)
 #define KVM_VGIC_V3_RDIST_COUNT_SHIFT	52
 
+#ifdef CONFIG_DEBUG_SPINLOCK
+#define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
+#else
+#define DEBUG_SPINLOCK_BUG_ON(p)
+#endif
+
 /* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
-- 
1.8.3.1
