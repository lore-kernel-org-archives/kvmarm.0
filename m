From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0130/1529] Fix typo
Date: Sat, 21 May 2016 13:53:14 +0200
Message-ID: <20160521115314.6184-1-andrea.gelmini@gelma.net>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 2cdb6b5..4b5c977 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -178,7 +178,7 @@
 /* Hyp System Trap Register */
 #define HSTR_EL2_T(x)	(1 << x)
 
-/* Hyp Coproccessor Trap Register Shifts */
+/* Hyp Coprocessor Trap Register Shifts */
 #define CPTR_EL2_TFP_SHIFT 10
 
 /* Hyp Coprocessor Trap Register */
-- 
2.8.2.534.g1f66975

