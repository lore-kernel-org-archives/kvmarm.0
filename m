From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 9/9] KVM: arm/arm64: vgic: Improve sync_hwstate performance
Date: Mon, 20 Mar 2017 11:58:18 +0100
Message-ID: <20170320105818.20481-10-cdall@linaro.org>
References: <20170320105818.20481-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78D8C40C75
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g5GDkoZzTuaF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 06:56:50 -0400 (EDT)
Received: from mail-wr0-f169.google.com (mail-wr0-f169.google.com
 [209.85.128.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85F3E40A95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:50 -0400 (EDT)
Received: by mail-wr0-f169.google.com with SMTP id l37so89628770wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 03:58:35 -0700 (PDT)
In-Reply-To: <20170320105818.20481-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to call any functions to fold LRs when we don't use any
LRs and we don't need to mess with overflow flags, take spinlocks, or
prune the AP list if the AP list is empty.

Note: list_empty is a single atomic read (uses READ_ONCE) and can
therefore check if a list is empty or not without the need to take the
spinlock protecting the list.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 093873e..8ecb009 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -639,15 +639,18 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	/* An empty ap_list_head implies used_lrs == 0 */
+	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
 
 	vgic_clear_uie(vcpu);
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
 
-	/* Make sure we can fast-path in flush_hwstate */
-	vgic_cpu->used_lrs = 0;
+	if (vgic_cpu->used_lrs) {
+		vgic_fold_lr_state(vcpu);
+		vgic_cpu->used_lrs = 0;
+	}
+
+	vgic_prune_ap_list(vcpu);
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
-- 
2.9.0
