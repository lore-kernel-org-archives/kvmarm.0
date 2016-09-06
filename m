From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/19] arm64: KVM: Add exception code to report EL1 asynchronous aborts
Date: Tue,  6 Sep 2016 14:02:02 +0100
Message-ID: <1473166937-15271-5-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So far, we don't have a code to indicate that we've taken an
asynchronous abort from EL1. Let's add one.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7561f63..d177e7e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -21,9 +21,10 @@
 #include <asm/virt.h>
 
 #define ARM_EXCEPTION_IRQ	  0
-#define ARM_EXCEPTION_TRAP	  1
+#define ARM_EXCEPTION_EL1_SERROR  1
+#define ARM_EXCEPTION_TRAP	  2
 /* The hyp-stub will return this for any kvm_call_hyp() call */
-#define ARM_EXCEPTION_HYP_GONE	  2
+#define ARM_EXCEPTION_HYP_GONE	  3
 
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
-- 
2.1.4

