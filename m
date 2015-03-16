From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 3/5] arm64: KVM: Fix outdated comment about VTCR_EL2.PS
Date: Mon, 16 Mar 2015 13:55:01 +0100
Message-ID: <1426510503-27995-4-git-send-email-christoffer.dall@linaro.org>
References: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Commit 87366d8cf7b3 ("arm64: Add boot time configuration of
Intermediate Physical Address size") removed the hardcoded setting
of VTCR_EL2.PS to use ID_AA64MMFR0_EL1.PARange instead, but didn't
remove the (now rather misleading) comment.

Fix the comments to match reality (at least for the next few minutes).

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 94674eb..54bb4ba 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -129,6 +129,9 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
+ * VTCR_EL2.PS is extracted from ID_AA64MMFR0_EL1.PARange at boot time
+ * (see hyp-init.S).
+ *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together.
  *
@@ -138,7 +141,6 @@
 #ifdef CONFIG_ARM64_64K_PAGES
 /*
  * Stage2 translation configuration:
- * 40bits output (PS = 2)
  * 40bits input  (T0SZ = 24)
  * 64kB pages (TG0 = 1)
  * 2 level page tables (SL = 1)
@@ -150,7 +152,6 @@
 #else
 /*
  * Stage2 translation configuration:
- * 40bits output (PS = 2)
  * 40bits input  (T0SZ = 24)
  * 4kB pages (TG0 = 0)
  * 3 level page tables (SL = 1)
-- 
2.1.2.330.g565301e.dirty

