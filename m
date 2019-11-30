Return-Path: <SRS0=6x6p=ZW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4D8C432C0
	for <kvmarm@archiver.kernel.org>; Sat, 30 Nov 2019 03:16:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEEFB2075C
	for <kvmarm@archiver.kernel.org>; Sat, 30 Nov 2019 03:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEEFB2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2704A522;
	Fri, 29 Nov 2019 22:16:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gvlD+a389rPo; Fri, 29 Nov 2019 22:16:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B4F14ACFA;
	Fri, 29 Nov 2019 22:16:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7834AC6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 22:16:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h9rlayCfHnU9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 22:16:02 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68DD84A522
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 22:16:02 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 4D0FFA083DCA239A0AD2;
 Sat, 30 Nov 2019 11:15:57 +0800 (CST)
Received: from linux-XCyijm.huawei.com (10.175.104.212) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Sat, 30 Nov 2019 11:15:49 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm/arm64: change gicv3_cpuif to static likely branch
Date: Sat, 30 Nov 2019 11:14:43 +0800
Message-ID: <20191130031443.41696-1-guoheyi@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
X-Originating-IP: [10.175.104.212]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Heyi Guo <guoheyi@huawei.com>,
 Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Platforms running hypervisor nowadays are normally powerful servers
which at least support GICv3, so it should be better to switch
kvm_vgic_global_state.gicv3_cpuif to static likely branch, which can
reduce two "b" instructions to a single "nop" for GICv3 branches.

We don't update arm32 specific code for they may still only have
GICv2.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c   | 4 ++--
 include/kvm/arm_vgic.h        | 2 +-
 virt/kvm/arm/vgic/vgic-init.c | 9 +++++----
 virt/kvm/arm/vgic/vgic.c      | 9 +++++----
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 799e84a40335..57e7d314211a 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -219,7 +219,7 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+	if (static_branch_likely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(vcpu);
 		__vgic_v3_deactivate_traps(vcpu);
 	}
@@ -228,7 +228,7 @@ static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 /* Restore VGICv3 state on non_VEH systems */
 static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+	if (static_branch_likely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(vcpu);
 		__vgic_v3_restore_state(vcpu);
 	}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index af4f09c02bf1..474e73dd3112 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -72,7 +72,7 @@ struct vgic_global {
 	bool			has_gicv4;
 
 	/* GIC system register CPU interface */
-	struct static_key_false gicv3_cpuif;
+	struct static_key_true gicv3_cpuif;
 
 	u32			ich_vtr_el2;
 };
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6f50c429196d..b03e5c8e1731 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -509,13 +509,14 @@ int kvm_vgic_hyp_init(void)
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
+		if (!ret) {
+			static_branch_disable(
+				&kvm_vgic_global_state.gicv3_cpuif);
+			kvm_info("GIC system register CPU interface disabled\n");
+		}
 		break;
 	case GIC_V3:
 		ret = vgic_v3_probe(gic_kvm_info);
-		if (!ret) {
-			static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
-			kvm_info("GIC system register CPU interface enabled\n");
-		}
 		break;
 	default:
 		ret = -ENODEV;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 45a870cb63f5..9dafeeb1457b 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -18,7 +18,7 @@
 #include "trace.h"
 
 struct vgic_global kvm_vgic_global_state __ro_after_init = {
-	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
+	.gicv3_cpuif = STATIC_KEY_TRUE_INIT,
 };
 
 /*
@@ -841,12 +841,13 @@ static inline bool can_access_vgic_from_kernel(void)
 	 * memory-mapped, and VHE systems can access GICv3 EL2 system
 	 * registers.
 	 */
-	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
+	return !static_branch_likely(&kvm_vgic_global_state.gicv3_cpuif) ||
+	       has_vhe();
 }
 
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (!static_branch_likely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(vcpu);
@@ -873,7 +874,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (!static_branch_likely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(vcpu);
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
