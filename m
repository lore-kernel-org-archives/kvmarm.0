From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] arm64: KVM: Do not update PC if the trap handler has updated it
Date: Tue, 22 Dec 2015 09:55:18 +0000
Message-ID: <1450778118-12715-3-git-send-email-marc.zyngier@arm.com>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Assuming we trap a system register, and decide that the access is
illegal, we will inject an exception in the guest. In this
case, we shouldn't increment the PC, or the vcpu will miss the
first instruction of the handler, leading to a mildly confused
guest.

Solve this by snapshoting PC before the access is performed,
and checking if it has moved or not before incrementing it.

Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 73 +++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2650e8..9c87e0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -966,6 +966,39 @@ static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
 	return NULL;
 }
 
+/* Perform the sysreg access, returns 0 on success */
+static int access_sys_reg(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *params,
+			  const struct sys_reg_desc *r)
+{
+	u64 pc = *vcpu_pc(vcpu);
+
+	if (unlikely(!r))
+		return -1;
+
+	/*
+	 * Not having an accessor means that we have configured a trap
+	 * that we don't know how to handle. This certainly qualifies
+	 * as a gross bug that should be fixed right away.
+	 */
+	BUG_ON(!r->access);
+
+	if (likely(r->access(vcpu, params, r))) {
+		/*
+		 * Skip the instruction if it was emulated without PC
+		 * having changed. This allows us to detect a fault
+		 * being injected (incrementing the PC here would
+		 * cause the vcpu to skip the first instruction of its
+		 * fault handler).
+		 */
+		if (pc == *vcpu_pc(vcpu))
+			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		return 0;
+	}
+
+	return -1;
+}
+
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	kvm_inject_undefined(vcpu);
@@ -994,26 +1027,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 
 	r = find_reg(params, table, num);
 
-	if (r) {
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
-		}
-
-		/* Handled */
-		return 0;
-	}
-
-	/* Not handled */
-	return -1;
+	return access_sys_reg(vcpu, params, r);
 }
 
 static void unhandled_cp_access(struct kvm_vcpu *vcpu,
@@ -1178,27 +1192,12 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	if (!r)
 		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-	if (likely(r)) {
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
-	} else {
+	if (access_sys_reg(vcpu, params, r)) {
 		kvm_err("Unsupported guest sys_reg access at: %lx\n",
 			*vcpu_pc(vcpu));
 		print_sys_reg_instr(params);
+		kvm_inject_undefined(vcpu);
 	}
-	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
-- 
2.1.4

