From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 10/19] KVM: arm/arm64: debug: Introduce helper for single-step
Date: Mon,  4 Dec 2017 15:03:39 +0100
Message-ID: <20171204140348.21965-8-cdall@kernel.org>
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

After emulating instructions we may want return to user-space to handle
single-step debugging. Introduce a helper function, which, if
single-step is enabled, sets the run structure for return and returns
true.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 21 +++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 242151ea6908..a9f7d3f47134 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -285,6 +285,11 @@ static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_arm_handle_step_debug(struct kvm_vcpu *vcpu,
+					     struct kvm_run *run)
+{
+	return false;
+}
 
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 674912d7a571..ea6cb5b24258 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -370,6 +370,7 @@ void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+bool kvm_arm_handle_step_debug(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index dbadfaf850a7..fa63b28c65e0 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -221,3 +221,24 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 		}
 	}
 }
+
+
+/*
+ * After successfully emulating an instruction, we might want to
+ * return to user space with a KVM_EXIT_DEBUG. We can only do this
+ * once the emulation is complete, though, so for userspace emulations
+ * we have to wait until we have re-entered KVM before calling this
+ * helper.
+ *
+ * Return true (and set exit_reason) to return to userspace or false
+ * if no further action is required.
+ */
+bool kvm_arm_handle_step_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		run->exit_reason = KVM_EXIT_DEBUG;
+		run->debug.arch.hsr = ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
+		return true;
+	}
+	return false;
+}
-- 
2.14.2
