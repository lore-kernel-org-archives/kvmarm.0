From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 35/50] arm64: KVM: Inject a vSerror if detecting a bad GICV
 access at EL2
Date: Tue, 27 Sep 2016 20:05:43 +0200
Message-ID: <20160927180558.14699-36-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD61C49B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e0YIVqTnayJ9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:02 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 036D749B7C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:58 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id w84so190366775wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:21 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If, when proxying a GICV access at EL2, we detect that the guest is
doing something silly, report an EL1 SError instead ofgnoring the
access.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/switch.c      | 18 +++++++++++++++---
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 21 ++++++++++++++++-----
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 88ec3ac..b18e852 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,7 @@ typeof(orig) * __hyp_text fname(void)					\
 
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
-bool __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
+int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8b81cc6..731519c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -311,9 +311,21 @@ again:
 			!kvm_vcpu_dabt_isextabt(vcpu) &&
 			!kvm_vcpu_dabt_iss1tw(vcpu);
 
-		if (valid && __vgic_v2_perform_cpuif_access(vcpu)) {
-			__skip_instr(vcpu);
-			goto again;
+		if (valid) {
+			int ret = __vgic_v2_perform_cpuif_access(vcpu);
+
+			if (ret == 1) {
+				__skip_instr(vcpu);
+				goto again;
+			}
+
+			if (ret == -1) {
+				/* Promote an illegal access to an SError */
+				__skip_instr(vcpu);
+				exit_code = ARM_EXCEPTION_EL1_SERROR;
+			}
+
+			/* 0 falls through to be handler out of EL2 */
 		}
 	}
 
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a052f20..c8aeb7b 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -170,7 +170,18 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_ARM64
-bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
+/*
+ * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
+ *				     guest.
+ *
+ * @vcpu: the offending vcpu
+ *
+ * Returns:
+ *  1: GICV access successfully performed
+ *  0: Not a GICV access
+ * -1: Illegal GICV access
+ */
+int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
@@ -185,15 +196,15 @@ bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
 	    fault_ipa >= (vgic->vgic_cpu_base + KVM_VGIC_V2_CPU_SIZE))
-		return false;
+		return 0;
 
 	/* Reject anything but a 32bit access */
 	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32))
-		return false;
+		return -1;
 
 	/* Not aligned? Don't bother */
 	if (fault_ipa & 3)
-		return false;
+		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
 	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
@@ -210,6 +221,6 @@ bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 							       sizeof(u32)));
 	}
 
-	return true;
+	return 1;
 }
 #endif
-- 
2.9.0
