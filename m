From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/27] arm/arm64: KVM: Introduce kvm_call_hyp_ret()
Date: Fri, 22 Feb 2019 16:25:40 +0000
Message-ID: <20190222162605.5054-3-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1FF4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:27:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ovL3-ovqkV36 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:27:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6E84A37D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:27:02 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Until now, we haven't differentiated between HYP calls that
have a return value and those who don't. As we're about to
change this, introduce kvm_call_hyp_ret(), and change all
call sites that actually make use of a return value.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 3 +++
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/debug.c            | 2 +-
 virt/kvm/arm/arm.c                | 2 +-
 virt/kvm/arm/vgic/vgic-v3.c       | 4 ++--
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ca56537b61bc..023c9f2b1eea 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -214,7 +214,10 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+
 unsigned long kvm_call_hyp(void *hypfn, ...);
+#define kvm_call_hyp_ret(f, ...) kvm_call_hyp(f, ##__VA_ARGS__)
+
 void force_vm_exit(const cpumask_t *mask);
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7732d0ba4e60..e54cb7c88a4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -371,6 +371,7 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
 #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
+#define kvm_call_hyp_ret(f, ...) kvm_call_hyp(f, ##__VA_ARGS__)
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f39801e4136c..fd917d6d12af 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -76,7 +76,7 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 void kvm_arm_init_debug(void)
 {
-	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
+	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
 }
 
 /**
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9e350fd34504..4d55f98f97f7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -765,7 +765,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			ret = kvm_vcpu_run_vhe(vcpu);
 			kvm_arm_vhe_guest_exit();
 		} else {
-			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
+			ret = kvm_call_hyp_ret(__kvm_vcpu_run_nvhe, vcpu);
 		}
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9c0dd234ebe8..67f98151c88d 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -589,7 +589,7 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	u32 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_ich_vtr_el2);
 	int ret;
 
 	/*
@@ -679,7 +679,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	if (likely(cpu_if->vgic_sre))
-		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
+		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
 
 	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
 
-- 
2.20.1
