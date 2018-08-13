From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/37] KVM: arm/arm64: Enable adaptative WFE trapping
Date: Mon, 13 Aug 2018 15:57:25 +0100
Message-ID: <20180813145755.16566-8-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFDF94A1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xxnU4AEODX7A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634814A213
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:12 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Trapping blocking WFE is extremely beneficial in situations where
the system is oversubscribed, as it allows another thread to run
while being blocked. In a non-oversubscribed environment, this is
the complete opposite, and trapping WFE is just unnecessary overhead.

Let's only enable WFE trapping if the CPU has more than a single task
to run (that is, more than just the vcpu thread).

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 10 ++++++++++
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 virt/kvm/arm/arm.c                   |  6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 6493bd479ddc..b50fe8380868 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -107,6 +107,16 @@ static inline unsigned long *vcpu_hcr(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr;
 }
 
+static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr &= ~HCR_TWE;
+}
+
+static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr |= HCR_TWE;
+}
+
 static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 {
 	return 1;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index dd98fdf33d99..bfefdd9a72eb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -83,6 +83,16 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
+static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+}
+
+static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= HCR_TWE;
+}
+
 static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 {
 	vcpu->arch.vsesr_el2 = vsesr;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 04e554cae3a2..8e66b89a3db2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -30,6 +30,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
+#include <linux/sched/stat.h>
 #include <trace/events/kvm.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
@@ -380,6 +381,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+
+	if (single_task_running())
+		vcpu_clear_wfe_traps(vcpu);
+	else
+		vcpu_set_wfe_traps(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.18.0
