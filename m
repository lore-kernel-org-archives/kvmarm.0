From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 54/55] KVM: arm/arm64: Adjust virtual offset considering nesting
Date: Mon,  9 Jan 2017 01:24:50 -0500
Message-ID: <1483943091-1364-55-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D799A40838
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d4LKg86cPlj2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:25:03 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F90C406F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:58 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXwS017320
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:40 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 077BC84
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:40 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id C065284
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:39 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QdYQ058052
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:39 -0500
Received: by mail-qt0-f198.google.com with SMTP id l7so63082534qtd.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:39 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The guest hypervisor sets cntvoff_el2 for its VM (i.e. nested VM).  Note
that physical/virtual counter value in the guest hypervisor's point of
view is already offsetted by the virtual offset set by the host
hypervisor.  Therefore, the correct offset we need to write to the
cntvoff_el2 is the sum of offset the host hypervisor initially has for
the VM and virtual offset the guest hypervisor sets for the nested VM.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_emulate.h   | 6 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
 virt/kvm/arm/arch_timer.c            | 3 ++-
 virt/kvm/arm/hyp/timer-sr.c          | 5 ++++-
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index dde5335..c7a690f 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -324,4 +324,10 @@ static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+/* Return the guest hypervisor's cntvoff value */
+static inline u64 kvm_get_vcntvoff(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 17f4855..0aaa4ca 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -385,4 +385,10 @@ static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
 #endif
 }
 
+/* Return the guest hypervisor's cntvoff value */
+static inline u64 kvm_get_vcntvoff(struct kvm_vcpu *vcpu)
+{
+	return vcpu_el2_reg(vcpu, CNTVOFF_EL2);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 7a161f8..e393939 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -24,6 +24,7 @@
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/arch_timer.h>
+#include <asm/kvm_emulate.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -102,7 +103,7 @@ static u64 kvm_timer_cntvoff(struct kvm_vcpu *vcpu,
 			     struct arch_timer_context *timer_ctx)
 {
 	if (timer_ctx == vcpu_vtimer(vcpu))
-		return vcpu->kvm->arch.timer.cntvoff;
+		return vcpu->kvm->arch.timer.cntvoff + kvm_get_vcntvoff(vcpu);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 4bbd36c..66dab01 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_emulate.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
@@ -49,6 +50,7 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
+	u64 cntvoff;
 
 	/*
 	 * Disallow physical timer access for the guest
@@ -60,7 +62,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(val, cnthctl_el2);
 
 	if (vtimer->enabled) {
-		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
+		cntvoff = kvm->arch.timer.cntvoff + kvm_get_vcntvoff(vcpu);
+		write_sysreg(cntvoff, cntvoff_el2);
 		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
 		isb();
 		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
-- 
1.9.1
