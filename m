From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 11/19] kvm: arm64: handle single-stepping trapped instructions
Date: Mon,  4 Dec 2017 15:03:40 +0100
Message-ID: <20171204140348.21965-9-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Alex Bennée <alex.bennee@linaro.org>

If we are using guest debug to single-step the guest, we need to ensure
that we exit after emulating the instruction. This only affects
instructions completely emulated by the kernel. For instructions
emulated in userspace, we need to exit and return to complete the
emulation.

The kvm_arm_handle_step_debug() helper sets up the necessary exit
state if needed.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 49 +++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b71247995469..029c28dd25e9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -186,6 +186,40 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+/*
+ * We may be single-stepping an emulated instruction. If the emulation
+ * has been completed in the kernel, we can return to userspace with a
+ * KVM_EXIT_DEBUG, otherwise userspace needs to complete its
+ * emulation first.
+ */
+static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int handled;
+
+	/*
+	 * See ARM ARM B1.14.1: "Hyp traps on instructions
+	 * that fail their condition code check"
+	 */
+	if (!kvm_condition_valid(vcpu)) {
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		handled = 1;
+	} else {
+		exit_handle_fn exit_handler;
+
+		exit_handler = kvm_get_exit_handler(vcpu);
+		handled = exit_handler(vcpu, run);
+	}
+
+	/*
+	 * kvm_arm_handle_step_debug() sets the exit_reason on the kvm_run
+	 * structure if we need to return to userspace.
+	 */
+	if (handled > 0 && kvm_arm_handle_step_debug(vcpu, run))
+		handled = 0;
+
+	return handled;
+}
+
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -193,8 +227,6 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		       int exception_index)
 {
-	exit_handle_fn exit_handler;
-
 	if (ARM_SERROR_PENDING(exception_index)) {
 		u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
 
@@ -222,18 +254,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		kvm_inject_vabt(vcpu);
 		return 1;
 	case ARM_EXCEPTION_TRAP:
-		/*
-		 * See ARM ARM B1.14.1: "Hyp traps on instructions
-		 * that fail their condition code check"
-		 */
-		if (!kvm_condition_valid(vcpu)) {
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			return 1;
-		}
-
-		exit_handler = kvm_get_exit_handler(vcpu);
-
-		return exit_handler(vcpu, run);
+		return handle_trap_exceptions(vcpu, run);
 	case ARM_EXCEPTION_HYP_GONE:
 		/*
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
-- 
2.14.2
