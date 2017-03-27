From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 9/9] arm: KVM: Treat CP15 accessors returning false as
 successful
Date: Mon, 27 Mar 2017 17:03:45 +0100
Message-ID: <20170327160345.12402-10-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38ACE40C4A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0w-OhRXllswm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFAB740C50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:12 -0400 (EDT)
In-Reply-To: <20170327160345.12402-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Instead of considering that a CP15 accessor has failed when
returning false, let's consider that it is *always* successful
(after all, we won't stand for an incomplete emulation).

The return value now simply indicates whether we should skip
the instruction (because it has now been emulated), or if we
should leave the PC alone if the emulation has injected an
exception.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 519aac12b365..2c14b69511e9 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -520,15 +520,15 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			return 1;
 		}
-		/* If access function fails, it should complain. */
 	} else {
+		/* If access function fails, it should complain. */
 		kvm_err("Unsupported guest CP15 access at: %08lx\n",
 			*vcpu_pc(vcpu));
 		print_cp_instr(params);
+		kvm_inject_undefined(vcpu);
 	}
-	kvm_inject_undefined(vcpu);
+
 	return 1;
 }
 
-- 
2.11.0
