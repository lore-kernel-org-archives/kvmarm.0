From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 51/52] KVM: arm/arm64: GICv4: Use pending_last as a
 scheduling hint
Date: Wed, 28 Jun 2017 16:04:10 +0100
Message-ID: <20170628150411.15846-52-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75ED749C4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vm8+GRy0-EIp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A3849C74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:55 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

When a vPE exits, the pending_last flag is set when there are
pending VLPIs stored in the pending table. Similarily, we set
this flag when a doorbell interrupt fires, as it indicates the
same condition.

Let's update kvm_vgic_vcpu_pending_irq() to account for that
flag as well, making a vcpu runnable when set.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 2106e4c06a12..9ab52108989d 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -785,6 +785,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
 
+	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
+		return true;
+
 	spin_lock(&vgic_cpu->ap_list_lock);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-- 
2.11.0
