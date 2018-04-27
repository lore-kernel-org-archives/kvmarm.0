From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 12/12] KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512
Date: Fri, 27 Apr 2018 16:15:05 +0200
Message-ID: <1524838505-3823-13-git-send-email-eric.auger@redhat.com>
References: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Let's raise the number of supported vcpus along with
vgic v3 now that HW is looming with more physical CPUs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e5c16d1..a9a9f4a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -28,7 +28,7 @@
 
 #include <linux/irqchip/arm-gic-v4.h>
 
-#define VGIC_V3_MAX_CPUS	255
+#define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
 #define VGIC_NR_SGIS		16
-- 
2.5.5
