From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 09/10] KVM: arm/arm64: vgic: Don't check vgic_initialized
 in sync/flush
Date: Tue, 21 Mar 2017 22:10:58 +0100
Message-ID: <20170321211059.8719-10-cdall@linaro.org>
References: <20170321211059.8719-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E422240C43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFxzOoqWjNDv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 17:09:24 -0400 (EDT)
Received: from mail-wr0-f176.google.com (mail-wr0-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EFFD40C44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:23 -0400 (EDT)
Received: by mail-wr0-f176.google.com with SMTP id u108so119563639wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:11:10 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now when we do an early init of the static parts of the VGIC data
structures, we can do things like checking if the AP lists are empty
directly without having to explicitly check if the vgic is initialized
and reduce a bit of work in our critical path.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Changes since v1:
 - Moved note about checking list_empty to other patch commit message
 - Removed check in both sync/flush in this patch

 virt/kvm/arm/vgic/vgic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index b64b143..04a405a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -633,9 +633,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
-		return;
-
 	vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
 
@@ -646,9 +643,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
-		return;
-
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
-- 
2.9.0
