From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/15] arm64: Add ARM64_HYP_OFFSET_LOW capability
Date: Tue,  7 Jun 2016 11:58:23 +0100
Message-ID: <1465297115-13091-4-git-send-email-marc.zyngier@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we need to indicate to the rest of the kernel which region of
the HYP VA space is safe to use, add a capability that will
indicate that KVM should use the [VA_BITS-2:0] range.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 224efe7..d40edbb 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -36,8 +36,9 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
+#define ARM64_HYP_OFFSET_LOW			14
 
-#define ARM64_NCAPS				14
+#define ARM64_NCAPS				15
 
 #ifndef __ASSEMBLY__
 
-- 
2.1.4

