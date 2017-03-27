From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 6/9] arm64: KVM: Treat sysreg accessors returning false as
 successful
Date: Mon, 27 Mar 2017 17:03:42 +0100
Message-ID: <20170327160345.12402-7-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D2B40C35
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eUOdhxSfrG2g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A0040CC6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:09 -0400 (EDT)
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

Instead of considering that a sysreg accessor has failed when
returning false, let's consider that it is *always* successful
(after all, we won't stand for an incomplete emulation).

The return value now simply indicates whether we should skip
the instruction (because it has now been emulated), or if we
should leave the PC alone if the emulation has injected an
exception.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 49 +++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f80a61af5e88..4e5d4eee8cec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1571,6 +1571,22 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+static void perform_access(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *params,
+			   const struct sys_reg_desc *r)
+{
+	/*
+	 * Not having an accessor means that we have configured a trap
+	 * that we don't know how to handle. This certainly qualifies
+	 * as a gross bug that should be fixed right away.
+	 */
+	BUG_ON(!r->access);
+
+	/* Skip instruction if instructed so */
+	if (likely(r->access(vcpu, params, r)))
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+}
+
 /*
  * emulate_cp --  tries to match a sys_reg access in a handling table, and
  *                call the corresponding trap handler.
@@ -1594,20 +1610,8 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 	r = find_reg(params, table, num);
 
 	if (r) {
-		/*
-		 * Not having an accessor means that we have
-		 * configured a trap that we don't know how to
-		 * handle. This certainly qualifies as a gross bug
-		 * that should be fixed right away.
-		 */
-		BUG_ON(!r->access);
-
-		if (likely(r->access(vcpu, params, r))) {
-			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			/* Handled */
-			return 0;
-		}
+		perform_access(vcpu, params, r);
+		return 0;
 	}
 
 	/* Not handled */
@@ -1777,26 +1781,13 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	if (likely(r)) {
-		/*
-		 * Not having an accessor means that we have
-		 * configured a trap that we don't know how to
-		 * handle. This certainly qualifies as a gross bug
-		 * that should be fixed right away.
-		 */
-		BUG_ON(!r->access);
-
-		if (likely(r->access(vcpu, params, r))) {
-			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			return 1;
-		}
-		/* If access function fails, it should complain. */
+		perform_access(vcpu, params, r);
 	} else {
 		kvm_err("Unsupported guest sys_reg access at: %lx\n",
 			*vcpu_pc(vcpu));
 		print_sys_reg_instr(params);
+		kvm_inject_undefined(vcpu);
 	}
-	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
-- 
2.11.0
