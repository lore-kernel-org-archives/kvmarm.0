From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/19] arm64: KVM: Allow an exit code to be tagged with an SError
Date: Tue,  6 Sep 2016 14:02:05 +0100
Message-ID: <1473166937-15271-8-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Similarily to EL1, an asynchronous abort can be triggered whilst
running at EL2. But instead of making that a new error code,
we need to communicate it to the rest of KVM together with
the exit reason. So let's hijack a single bit that allows the
exception code to be tagged with a "pending SError" information.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d177e7e..18f7465 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -20,6 +20,10 @@
 
 #include <asm/virt.h>
 
+#define ARM_EXIT_WITH_SERROR_BIT  31
+#define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_SERROR_BIT))
+#define ARM_SERROR_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_SERROR_BIT))
+
 #define ARM_EXCEPTION_IRQ	  0
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
-- 
2.1.4

