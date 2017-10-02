From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 6/5] KVM: arm/arm64: make kvm_vgic_vcpu_pending_irq static
Date: Mon,  2 Oct 2017 10:31:33 +0200
Message-ID: <20171002083133.24051-1-drjones@redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A85A49C3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 04:31:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KSmu5+sT76gk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 04:31:19 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D412405F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 04:31:19 -0400 (EDT)
In-Reply-To: <20170929113041.24371-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that the only caller of kvm_vgic_vcpu_pending_irq() is in the
vgic code, let's make it private in order to discourage it's use
outside, as checking the IRQ_PENDING VCPU request is likely the
right thing for non-vgic code to do. Also, remove a vgic prototype
that was mistakenly introduced with 0919e84c0fc1, and along for the
ride ever since.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/kvm/arm_vgic.h   | 3 ---
 virt/kvm/arm/vgic/vgic.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 34dba516ef24..aade132d2a30 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -311,8 +311,6 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
-int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 
@@ -322,7 +320,6 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu);
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index fed717e07938..72a16259beec 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -730,7 +730,7 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		vgic_v3_put(vcpu);
 }
 
-int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
+static int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
-- 
2.13.5
