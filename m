From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/8] KVM: arm64: add workaround for Cortex-A57 erratum #852523
Date: Thu, 17 Sep 2015 15:46:04 +0100
Message-ID: <1442501171-24484-2-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Will Deacon <will.deacon@arm.com>

When restoring the system register state for an AArch32 guest at EL2,
writes to DACR32_EL2 may not be correctly synchronised by Cortex-A57,
which can lead to the guest effectively running with junk in the DACR
and running into unexpected domain faults.

This patch works around the issue by re-ordering our restoration of the
AArch32 register aliases so that they happen before the AArch64 system
registers. Ensuring that the registers are restored in this order
guarantees that they will be correctly synchronised by the core.

Cc: <stable@vger.kernel.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 8188f6a..39aa322 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -745,6 +745,9 @@ ENTRY(__kvm_vcpu_run)
 	// Guest context
 	add	x2, x0, #VCPU_CONTEXT
 
+	// We must restore the 32-bit state before the sysregs, thanks
+	// to Cortex-A57 erratum #852523.
+	restore_guest_32bit_state
 	bl __restore_sysregs
 
 	skip_debug_state x3, 1f
@@ -752,7 +755,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x3
 	bl	__restore_debug
 1:
-	restore_guest_32bit_state
 	restore_guest_regs
 
 	// That's it, no more messing around.
-- 
2.1.4

