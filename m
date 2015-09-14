From: Will Deacon <will.deacon@arm.com>
Subject: [PATCH] KVM: arm64: add workaround for Cortex-A57 erratum #852523
Date: Mon, 14 Sep 2015 16:06:03 +0100
Message-ID: <1442243163-2675-1-git-send-email-will.deacon@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E7F41022
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 11:05:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RaBg1daXH4rq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 11:05:09 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3BB340F90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 11:05:09 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: linux@arm.linux.org.uk, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org
List-Id: kvmarm@lists.cs.columbia.edu

When restoring the system register state for an AArch32 guest at EL2,
writes to DACR32_EL2 may not be correctly synchronised by Cortex-A57,
which can lead to the guest effectively running with junk in the DACR
and running into unexpected domain faults.

This patch works around the issue by re-ordering our restoration of the
AArch32 register aliases so that they happen before the AArch64 system
registers. Ensuring that the registers are restored in this order
guarantees that they will be correctly synchronised by the core.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kvm/hyp.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 3c4f641451bb..c4016d411f4a 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -739,6 +739,9 @@ ENTRY(__kvm_vcpu_run)
 	// Guest context
 	add	x2, x0, #VCPU_CONTEXT
 
+	// We must restore the 32-bit state before the sysregs, thanks
+	// to Cortex-A57 erratum #852523.
+	restore_guest_32bit_state
 	bl __restore_sysregs
 
 	skip_debug_state x3, 1f
@@ -746,7 +749,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x3
 	bl	__restore_debug
 1:
-	restore_guest_32bit_state
 	restore_guest_regs
 
 	// That's it, no more messing around.
-- 
2.1.4
