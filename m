From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 1/7] arm64: KVM: Move kvm_vcpu_get_condition out of emulate.c
Date: Tue,  6 Sep 2016 09:28:41 +0100
Message-ID: <1473150527-4729-2-git-send-email-marc.zyngier@arm.com>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to make emulate.c more generic, move the arch-specific
manupulation bits out of emulate.c.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 arch/arm64/kvm/emulate.c             | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4cdeae3..b336434d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -147,6 +147,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_hsr(vcpu);
+
+	if (esr & ESR_ELx_CV)
+		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
+
+	return -1;
+}
+
 static inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.far_el2;
diff --git a/arch/arm64/kvm/emulate.c b/arch/arm64/kvm/emulate.c
index f87d8fb..40098ad 100644
--- a/arch/arm64/kvm/emulate.c
+++ b/arch/arm64/kvm/emulate.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include <asm/esr.h>
 #include <asm/kvm_emulate.h>
 
 /*
@@ -52,16 +51,6 @@ static const unsigned short cc_map[16] = {
 	0			/* NV                     */
 };
 
-static int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
-{
-	u32 esr = kvm_vcpu_get_hsr(vcpu);
-
-	if (esr & ESR_ELx_CV)
-		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
-
-	return -1;
-}
-
 /*
  * Check if a trapped instruction should have been executed or not.
  */
-- 
2.1.4

