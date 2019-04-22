From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 26/98] arm64: KVM: Always set ICH_HCR_EL2.EN if
 GICv4 is enabled
Date: Mon, 22 Apr 2019 15:40:53 -0400
Message-ID: <20190422194205.10404-26-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E314A44D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pK4XsoSmJ6-y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Apr 2019 15:42:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 530B84A409
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:42:43 -0400 (EDT)
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Sasha Levin <sashal@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit ca71228b42a96908eca7658861eafacd227856c9 ]

The normal interrupt flow is not to enable the vgic when no virtual
interrupt is to be injected (i.e. the LRs are empty). But when a guest
is likely to use GICv4 for LPIs, we absolutely need to switch it on
at all times. Otherwise, VLPIs only get delivered when there is something
in the LRs, which doesn't happen very often.

Reported-by: Nianyao Tang <tangnianyao@huawei.com>
Tested-by: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c |  4 ++--
 virt/kvm/arm/vgic/vgic.c      | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 9652c453480f..3c3f7cda95c7 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -222,7 +222,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (used_lrs) {
+	if (used_lrs || cpu_if->its_vpe.its_vm) {
 		int i;
 		u32 elrsr;
 
@@ -247,7 +247,7 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	int i;
 
-	if (used_lrs) {
+	if (used_lrs || cpu_if->its_vpe.its_vm) {
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++)
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index abd9c7352677..3af69f2a3866 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -867,15 +867,21 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * either observe the new interrupt before or after doing this check,
 	 * and introducing additional synchronization mechanism doesn't change
 	 * this.
+	 *
+	 * Note that we still need to go through the whole thing if anything
+	 * can be directly injected (GICv4).
 	 */
-	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
+	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
+	    !vgic_supports_direct_msis(vcpu->kvm))
 		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
-	raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
-	vgic_flush_lr_state(vcpu);
-	raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	if (!list_empty(&vcpu->arch.vgic_cpu.ap_list_head)) {
+		raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		vgic_flush_lr_state(vcpu);
+		raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	}
 
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
-- 
2.19.1
