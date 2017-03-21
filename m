From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 02/10] KVM: arm/arm64: vgic: Avoid flushing vgic state when
 there's no pending IRQ
Date: Tue, 21 Mar 2017 22:10:51 +0100
Message-ID: <20170321211059.8719-3-cdall@linaro.org>
References: <20170321211059.8719-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0224C40C41
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fJYTpdeRKYsp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 17:09:16 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 198C940C54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:15 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id u108so119562237wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:11:03 -0700 (PDT)
In-Reply-To: <20170321211059.8719-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shih-Wei Li <shihwei@cs.columbia.edu>

We do not need to flush vgic states in each world switch unless
there is pending IRQ queued to the vgic's ap list. We can thus reduce
the overhead by not grabbing the spinlock and not making the extra
function call to vgic_flush_lr_state.

Note: list_empty is a single atomic read (uses READ_ONCE) and can
therefore check if a list is empty or not without the need to take the
spinlock protecting the list.

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Changes since v1:
 - Added comment in kvm_vgic_flush_hwstate

 virt/kvm/arm/vgic/vgic.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 2ac0def..1043291 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -637,12 +637,17 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
 	vgic_process_maintenance_interrupt(vcpu);
 	vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
+
+	/* Make sure we can fast-path in flush_hwstate */
+	vgic_cpu->used_lrs = 0;
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
@@ -651,6 +656,18 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
+	/*
+	 * If there are no virtual interrupts active or pending for this
+	 * VCPU, then there is no work to do and we can bail out without
+	 * taking any lock.  There is a potential race with someone injecting
+	 * interrupts to the VCPU, but it is a benign race as the VCPU will
+	 * either observe the new interrupt before or after doing this check,
+	 * and introducing additional synchronization mechanism doesn't change
+	 * this.
+	 */
+	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
+		return;
+
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
-- 
2.9.0
