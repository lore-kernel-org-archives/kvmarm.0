From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 57/95] arm64: KVM: Move __cpu_init_stage2 after kvm_call_hyp
Date: Wed,  9 Mar 2016 07:30:51 +0000
Message-ID: <1457508689-19672-58-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F1F49B71
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIH7Sxv4r3GE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B62CD49B65
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:25 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to ease the merge with the rest of the arm64 tree, move the
definition of __cpu_init_stage2() after what will be the new kvm_call_hyp.
Hopefully the resolution of the merge conflict will be obvious.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 43688d9..31fe7d6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -333,11 +333,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 		     hyp_stack_ptr, vector_ptr);
 }
 
-static inline void __cpu_init_stage2(void)
-{
-	kvm_call_hyp(__init_stage2_translation);
-}
-
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
@@ -349,4 +344,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+/* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
+
+static inline void __cpu_init_stage2(void)
+{
+	kvm_call_hyp(__init_stage2_translation);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.1.4
