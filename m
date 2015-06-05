From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 1/8] AArch64: Reserve two 64k pages for GIC CPU interface
Date: Fri,  5 Jun 2015 09:37:46 +0100
Message-ID: <1433493473-4002-2-git-send-email-andre.przywara@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com, penberg@kernel.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

On AArch64 system with a GICv2, the GICC range can be aligned
to the last 4k block of a 64k page, ending up straddling two
64k pages. In order not to conflict with the distributor mapping,
allocate two 64k pages to the CPU interface.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/include/kvm/kvm-arch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 2f08a26..4925736 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -2,7 +2,7 @@
 #define KVM__KVM_ARCH_H
 
 #define ARM_GIC_DIST_SIZE	0x10000
-#define ARM_GIC_CPUI_SIZE	0x10000
+#define ARM_GIC_CPUI_SIZE	0x20000
 
 #define ARM_KERN_OFFSET(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
 				0x8000				:	\
-- 
2.3.5

