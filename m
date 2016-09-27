From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 10/50] arm64: KVM: Move kvm_vcpu_get_condition out of emulate.c
Date: Tue, 27 Sep 2016 20:05:18 +0200
Message-ID: <20160927180558.14699-11-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2994E49B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Ut6UII+3rhF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:33 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4117A49B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:33 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id w84so190345289wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:56 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to make emulate.c more generic, move the arch-specific
manupulation bits out of emulate.c.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.9.0
