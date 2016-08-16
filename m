From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: Document workaround for Cortex-A72 erratum #853709
Date: Tue, 16 Aug 2016 15:03:01 +0100
Message-ID: <1471356182-26034-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53B848531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 09:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ibvjkt3YsZiK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 09:55:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4EA41AF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 09:55:42 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We already have a workaround for Cortex-A57 erratum #852523,
but Cortex-A72 r0p0 to r0p2 do suffer from the same issue
(known as erratum #853709).

Let's document the fact that we already handle this.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.1.4
