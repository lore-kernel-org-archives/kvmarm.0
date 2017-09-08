From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/2] KVM: arm/arm64: Fix vgic_mmio_change_active with
 PREEMPT_RT
Date: Fri,  8 Sep 2017 07:52:19 -0700
Message-ID: <1504882339-42520-3-git-send-email-christoffer.dall@linaro.org>
References: <1504882339-42520-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70E3C49C5E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:50:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yxKHVeWCkvJ8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 10:50:46 -0400 (EDT)
Received: from mail-pg0-f50.google.com (mail-pg0-f50.google.com [74.125.83.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CF7B49C6D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:50:46 -0400 (EDT)
Received: by mail-pg0-f50.google.com with SMTP id q68so5236994pgq.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Sep 2017 07:53:16 -0700 (PDT)
In-Reply-To: <1504882339-42520-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, hemk976@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

Getting a per-CPU variable requires a non-preemptible context and we
were relying on a normal spinlock to disable preemption as well.  This
asusmption breaks with PREEMPT_RT and was observed on v4.9 using
PREEMPT_RT.

This change moves the spinlock tighter around the critical section
accessing the IRQ structure protected by the lock and uses a separate
preemption disabled section for determining the requesting VCPU.  There
should be no change in functionality of performance degradation on
non-RT.

Fixes: 370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")
Cc: stable@vger.kernel.org
Cc: Jintack Lim <jintack@cs.columbia.edu>
Reported-by: Hemanth Kumar <hemk976@gmail.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index c1e4bdd..7377f97 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -181,7 +181,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
 	struct kvm_vcpu *requester_vcpu;
-	spin_lock(&irq->irq_lock);
 
 	/*
 	 * The vcpu parameter here can mean multiple things depending on how
@@ -195,8 +194,19 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * NULL, which is fine, because we guarantee that no VCPUs are running
 	 * when accessing VGIC state from user space so irq->vcpu->cpu is
 	 * always -1.
+	 *
+	 * We have to temporarily disable preemption to read the per-CPU
+	 * variable.  It doesn't matter if we actually get preempted
+	 * after enabling preemption because we only need to figure out if
+	 * this thread is a running VCPU thread, and in that case for which
+	 * VCPU.  If we're migrated the preempt notifiers will migrate the
+	 * running VCPU pointer with us.
 	 */
+	preempt_disable();
 	requester_vcpu = kvm_arm_get_running_vcpu();
+	preempt_enable();
+
+	spin_lock(&irq->irq_lock);
 
 	/*
 	 * If this virtual IRQ was written into a list register, we
-- 
2.7.4
