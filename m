From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH] arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2
Date: Thu,  1 Sep 2016 15:29:03 +0100
Message-ID: <1472740143-40061-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3C940F9B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:21:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id avt4cXdvLxoD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 10:21:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80D48407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:21:10 -0400 (EDT)
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

SCTLR_EL2.SPAN bit controls what happens with the PSTATE.PAN bit on an
exception. However, this bit has no effect on the PSTATE.PAN when
HCR_EL2.E2H or HCR_EL2.TGE is unset. Thus when VHE is used and
exception taken from a guest PSTATE.PAN bit left unchanged and we
continue with a value guest has set.

To address that always reset PSTATE.PAN on entry from EL1.

Fixes: 1f364c8c48a0 ("arm64: VHE: Add support for running Linux in EL2 mode")

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/entry.S |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index ce9e5e5..eaf08d3 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -98,6 +98,8 @@ ENTRY(__guest_exit)
 	// x4-x29,lr: vcpu regs
 	// vcpu x0-x3 on the stack
 
+	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+
 	add	x2, x0, #VCPU_CONTEXT
 
 	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
-- 
1.7.9.5
