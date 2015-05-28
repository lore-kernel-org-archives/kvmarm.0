From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH] KVM: arm64: fix misleading comments in save/restore
Date: Thu, 28 May 2015 10:43:06 +0100
Message-ID: <1432806186-27993-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com
Cc: christoffer.dall@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

The elr_el2 and spsr_el2 registers in fact contain the processor state
before entry into the hypervisor code. In the case of guest state it
could be in either el0 or el1.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
---
 arch/arm64/kvm/hyp.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index d755922..1940a4c 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -50,8 +50,8 @@
 	stp	x29, lr, [x3, #80]
=20
 	mrs	x19, sp_el0
-	mrs	x20, elr_el2		// EL1 PC
-	mrs	x21, spsr_el2		// EL1 pstate
+	mrs	x20, elr_el2		// PC before hyp entry
+	mrs	x21, spsr_el2		// pstate before hyp entry
=20
 	stp	x19, x20, [x3, #96]
 	str	x21, [x3, #112]
@@ -82,8 +82,8 @@
 	ldr	x21, [x3, #16]
=20
 	msr	sp_el0, x19
-	msr	elr_el2, x20 				// EL1 PC
-	msr	spsr_el2, x21 				// EL1 pstate
+	msr	elr_el2, x20 		// PC to restore
+	msr	spsr_el2, x21 		// pstate to restore
=20
 	add	x3, x2, #CPU_XREG_OFFSET(19)
 	ldp	x19, x20, [x3]
--=20
2.4.1

