From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH] kvm: arm/arm64: vgic: Fix the sequence principle about vgic
 save/restore.
Date: Mon, 5 Jun 2017 18:30:04 +0800
Message-ID: <1496658604-20036-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA8D40C47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 06:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IDVWwy5CUHoI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 06:26:29 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0304440BE3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 06:26:28 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

At present, take GICv3 as as an example, our implementation is that, the operation
of the recovery ICH_HCR register is prior to the recovery of ICH_LRn registers in vgic
state restore. Thus, the ICH_LRn registers are 0, and if ICH_HCR.UIE is configured to 1,
a large number of unnecessary maintenance interrupts will be triggered.

So, We have to make sure the sequence that ICH_LRn early than ICH_HCR when restore state,
and the other way round when save state.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 5 ++---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a3f18d3..2ed5df1 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -70,12 +70,11 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 		return;
 
 	if (used_lrs) {
+		writel_relaxed(0, base + GICH_HCR);
 		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
 
 		save_elrsr(vcpu, base);
 		save_lrs(vcpu, base);
-
-		writel_relaxed(0, base + GICH_HCR);
 	} else {
 		cpu_if->vgic_elrsr = ~0UL;
 		cpu_if->vgic_apr = 0;
@@ -96,12 +95,12 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 		return;
 
 	if (used_lrs) {
-		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
 		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
 		for (i = 0; i < used_lrs; i++) {
 			writel_relaxed(cpu_if->vgic_lr[i],
 				       base + GICH_LR0 + (i * 4));
 		}
+		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
 	}
 }
 
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 32c3295..b625884 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -220,8 +220,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 	if (used_lrs) {
-		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
-
 		switch (nr_pre_bits) {
 		case 7:
 			write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
@@ -244,6 +242,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 
 		for (i = 0; i < used_lrs; i++)
 			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
+
+		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 	}
 
 	/*
-- 
1.8.3.1
