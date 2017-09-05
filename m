From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 4/5] KVM: arm/arm64: Extract GICv3 max APRn index calculation
Date: Tue,  5 Sep 2017 17:41:05 +0200
Message-ID: <20170905154106.2945-5-cdall@linaro.org>
References: <20170905154106.2945-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170905154106.2945-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to access the APRs from the GICv2 uaccess interface,
make this logic generally available.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 23 +++--------------------
 virt/kvm/arm/vgic/vgic.h         | 16 ++++++++++++++++
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 116786d..c77d508 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -208,29 +208,12 @@ static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
 static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r, u8 apr)
 {
-	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
 	u8 idx = r->Op2 & 3;
 
-	/*
-	 * num_pri_bits are initialized with HW supported values.
-	 * We can rely safely on num_pri_bits even if VM has not
-	 * restored ICC_CTLR_EL1 before restoring APnR registers.
-	 */
-	switch (vgic_v3_cpu->num_pri_bits) {
-	case 7:
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
-		break;
-	case 6:
-		if (idx > 1)
-			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
-		break;
-	default:
-		if (idx > 0)
-			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
-	}
+	if (idx > vgic_v3_max_apr_idx(vcpu))
+		goto err;
 
+	vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 	return true;
 err:
 	if (!p->is_write)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index bba7fa2..bf9ceab 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -220,4 +220,20 @@ int vgic_debug_destroy(struct kvm *kvm);
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
 
+static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
+
+	/*
+	 * num_pri_bits are initialized with HW supported values.
+	 * We can rely safely on num_pri_bits even if VM has not
+	 * restored ICC_CTLR_EL1 before restoring APnR registers.
+	 */
+	switch (cpu_if->num_pri_bits) {
+	case 7: return 3;
+	case 6: return 1;
+	default: return 0;
+	}
+}
+
 #endif
-- 
2.9.0
