From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] ARM: hyp-stub: Fix Thumb-2 compilation
Date: Thu, 20 Apr 2017 11:16:20 +0100
Message-ID: <20170420101620.1368-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: cdall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
List-Id: kvmarm@lists.cs.columbia.edu

The assembler defaults to emiting the short form of ADR, leading
to an out-of-range immediate. Using the wide version solves this
issue.

Fixes: bc845e4fbbbb ("ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init code")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/hyp-stub.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index d8523cc47a54..ec7e7377d423 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -125,7 +125,7 @@ ENTRY(__hyp_stub_install_secondary)
  * (see safe_svcmode_maskall).
  */
 	@ Now install the hypervisor stub:
-	adr	r7, __hyp_stub_vectors
+	W(adr)	r7, __hyp_stub_vectors
 	mcr	p15, 4, r7, c12, c0, 0	@ set hypervisor vector base (HVBAR)
 
 	@ Disable all traps, so we don't get any nasty surprise
-- 
2.11.0
