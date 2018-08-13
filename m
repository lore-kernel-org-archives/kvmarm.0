From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 30/37] KVM: arm/arm64: vgic-v3: Add core support for Group0
 SGIs
Date: Mon, 13 Aug 2018 15:57:48 +0100
Message-ID: <20180813145755.16566-31-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 020BC4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1gbpMVNZ6Rsc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:26 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D881C4A205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:25 -0400 (EDT)
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

Although vgic-v3 now supports Group0 interrupts, it still doesn't
deal with Group0 SGIs. As usually with the GIC, nothing is simple:

- ICC_SGI1R can signal SGIs of both groups, since GICD_CTLR.DS==1
  with KVM (as per 8.1.10, Non-secure EL1 access)

- ICC_SGI0R can only generate Group0 SGIs

- ICC_ASGI1R sees its scope refocussed to generate only Group0
  SGIs (as per the note at the bottom of Table 8-14)

We only support Group1 SGIs so far, so no material change.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c            |  2 +-
 arch/arm64/kvm/sys_regs.c        |  2 +-
 include/kvm/arm_vgic.h           |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 19 +++++++++++++++----
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3a02e76699a6..b17c52608a19 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -253,7 +253,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	reg = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
 	reg |= *vcpu_reg(vcpu, p->Rt1) ;
 
-	vgic_v3_dispatch_sgi(vcpu, reg);
+	vgic_v3_dispatch_sgi(vcpu, reg, true);
 
 	return true;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e04aacb2a24c..aba6755c816d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -255,7 +255,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	vgic_v3_dispatch_sgi(vcpu, p->regval);
+	vgic_v3_dispatch_sgi(vcpu, p->regval, true);
 
 	return true;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c134790be32c..4f31f96bbfab 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -373,7 +373,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);
 
-void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
+void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1);
 
 /**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 88e78b582139..a2a175b08b17 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -900,7 +900,8 @@ static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
 /**
  * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
  * @vcpu: The VCPU requesting a SGI
- * @reg: The value written into the ICC_SGI1R_EL1 register by that VCPU
+ * @reg: The value written into ICC_{ASGI1,SGI0,SGI1}R by that VCPU
+ * @allow_group1: Does the sysreg access allow generation of G1 SGIs
  *
  * With GICv3 (and ARE=1) CPUs trigger SGIs by writing to a system register.
  * This will trap in sys_regs.c and call this function.
@@ -910,7 +911,7 @@ static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
  * check for matching ones. If this bit is set, we signal all, but not the
  * calling VCPU.
  */
-void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
+void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *c_vcpu;
@@ -959,9 +960,19 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
 		spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		/*
+		 * An access targetting Group0 SGIs can only generate
+		 * those, while an access targetting Group1 SGIs can
+		 * generate interrupts of either group.
+		 */
+		if (!irq->group || allow_group1) {
+			irq->pending_latch = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		} else {
+			spin_unlock_irqrestore(&irq->irq_lock, flags);
+		}
+
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
-- 
2.18.0
