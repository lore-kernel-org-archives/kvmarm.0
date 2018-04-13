From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 10/12] KVM: arm/arm64: Add KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri, 13 Apr 2018 10:20:56 +0200
Message-ID: <1523607658-9166-11-git-send-email-eric.auger@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This new attribute allows the userspace to set the base address
of a reditributor region, relaxing the constraint of having all
consecutive redistibutor frames contiguous.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm/include/uapi/asm/kvm.h   | 7 ++++---
 arch/arm64/include/uapi/asm/kvm.h | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 2ba95d6..11725bb 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -88,9 +88,10 @@ struct kvm_regs {
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
 /* Supported VGICv3 address types  */
-#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
-#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
-#define KVM_VGIC_ITS_ADDR_TYPE		4
+#define KVM_VGIC_V3_ADDR_TYPE_DIST		2
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST		3
+#define KVM_VGIC_ITS_ADDR_TYPE			4
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9abbf30..ef8ad3b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -88,9 +88,10 @@ struct kvm_regs {
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
 /* Supported VGICv3 address types  */
-#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
-#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
-#define KVM_VGIC_ITS_ADDR_TYPE		4
+#define KVM_VGIC_V3_ADDR_TYPE_DIST		2
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST		3
+#define KVM_VGIC_ITS_ADDR_TYPE			4
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
-- 
2.5.5
