Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F78C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 16:41:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E947749F14;
	Mon, 14 Mar 2022 12:41:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id muS99oDtl6Pc; Mon, 14 Mar 2022 12:41:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0AA40BED;
	Mon, 14 Mar 2022 12:41:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7546F49EC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VgJhI-HWkW1k for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 12:40:58 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3437149ED5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:40:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BAE2C60AF5;
 Mon, 14 Mar 2022 16:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2830EC36AE2;
 Mon, 14 Mar 2022 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647276057;
 bh=ZWtAY23Xb95QLutpD0WIyDlallLPbNinEqh3WUhRRGg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MqenvIp2dF3mLhIyesuCWlFwlloYTv9oK2TkHcW5S9lbgQI7jMRYGD5RCrADyTMax
 hV+c8K5oIsUp/c6GOqm/zucp9yd1rq/Fv8w6clMenrHRG3s9ZibVCWC29bKUOLWf9/
 FLrj6P5uZLJC/0HR+k6AyS2qT0w9gGp8qqUx1FzBGGHMbDAXTgo0HUzmxjmZxX391y
 +L7MOTVpvUDEprb9Pr9DP2bn/A2K3TiuN5b5H3acHQqPGMcuDU/MH3/CC4ocDTj1bT
 si2ofGSvrCBzTWCt7zGTgGCmOhk0LxCBugUmcyWtHJlzYH47CDRUDGOcvn4ISgzz/+
 6+dMRDlx2GDKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nTnkd-00EPS0-59; Mon, 14 Mar 2022 16:40:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/4] KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR,
 CES} as a new GICD_IIDR revision
Date: Mon, 14 Mar 2022 16:40:44 +0000
Message-Id: <20220314164044.772709-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220314164044.772709-1-maz@kernel.org>
References: <20220314164044.772709-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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

Since adversising GICR_CTLR.{IC,CES} is directly observable from
a guest, we need to make it selectable from userspace.

For that, bump the default GICD_IIDR revision and let userspace
downgrade it to the previous default. For GICv2, the two distributor
revisions are strictly equivalent.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  7 ++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 18 +++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 23 +++++++++++++++++++++--
 include/kvm/arm_vgic.h             |  3 +++
 4 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fc00304fe7d8..f84e04f334c6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -319,7 +319,12 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
-	dist->implementation_rev = 2;
+	/*
+	 * If userspace didn't set the GIC implementation revision,
+	 * default to the latest and greatest. You know want it.
+	 */
+	if (!dist->implementation_rev)
+		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 	dist->initialized = true;
 
 out:
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 12e4c223e6b8..f2246c4ca812 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -73,9 +73,13 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len,
 					   unsigned long val)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u32 reg;
+
 	switch (addr & 0x0c) {
 	case GIC_DIST_IIDR:
-		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
+		reg = vgic_mmio_read_v2_misc(vcpu, addr, len);
+		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
 			return -EINVAL;
 
 		/*
@@ -87,8 +91,16 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 		 * migration from old kernels to new kernels with legacy
 		 * userspace.
 		 */
-		vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
-		return 0;
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		switch (reg) {
+		case KVM_VGIC_IMP_REV_2:
+		case KVM_VGIC_IMP_REV_3:
+			dist->v2_groups_user_writable = true;
+			dist->implementation_rev = reg;
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	}
 
 	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a6be403996c6..4c8e4f83e3d1 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -155,13 +155,27 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 					   unsigned long val)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u32 reg;
 
 	switch (addr & 0x0c) {
 	case GICD_TYPER2:
-	case GICD_IIDR:
 		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
 			return -EINVAL;
 		return 0;
+	case GICD_IIDR:
+		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
+		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
+			return -EINVAL;
+
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		switch (reg) {
+		case KVM_VGIC_IMP_REV_2:
+		case KVM_VGIC_IMP_REV_3:
+			dist->implementation_rev = reg;
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
 		if (!kvm_vgic_global_state.has_gicv4_1)
@@ -232,8 +246,13 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	unsigned long val;
+
+	val = atomic_read(&vgic_cpu->ctlr);
+	if (vcpu->kvm->arch.vgic.implementation_rev >= KVM_VGIC_IMP_REV_3)
+		val |= GICR_CTLR_IR | GICR_CTLR_CES;
 
-	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
+	return val;
 }
 
 static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 401236f97cf2..2d8f2e90edc2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -231,6 +231,9 @@ struct vgic_dist {
 
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
+#define KVM_VGIC_IMP_REV_2	2 /* GICv2 restorable groups */
+#define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
+#define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
 
 	/* Userspace can write to GICv2 IGROUPR */
 	bool			v2_groups_user_writable;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
