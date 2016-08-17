From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 09/12] arm64: Document workaround for Cortex-A72 erratum #853709
Date: Wed, 17 Aug 2016 21:38:56 +0200
Message-ID: <20160817193859.15726-10-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We already have a workaround for Cortex-A57 erratum #852523,
but Cortex-A72 r0p0 to r0p2 do suffer from the same issue
(known as erratum #853709).

Let's document the fact that we already handle this.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/arm64/silicon-errata.txt | 1 +
 arch/arm64/kvm/hyp/switch.c            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 4da60b4..ccc6032 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -53,6 +53,7 @@ stable kernels.
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075    |
 | ARM            | Cortex-A57      | #852523         | N/A                     |
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220    |
+| ARM            | Cortex-A72      | #853709         | N/A                     |
 | ARM            | MMU-500         | #841119,#826419 | N/A                     |
 |                |                 |                 |                         |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ae7855f..5a84b45 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -256,7 +256,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to Cortex-A57 erratum #852523.
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_guest_state(guest_ctxt);
-- 
2.9.0

