Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F85CC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DCDF61058
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9DCDF61058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EC624B0BF;
	Sun, 10 Oct 2021 11:09:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ipNiR7fJWcBo; Sun, 10 Oct 2021 11:09:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3518A4B125;
	Sun, 10 Oct 2021 11:09:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B984B0A0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8N0jxvG1jBP1 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E7DD4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3E4616109E;
 Sun, 10 Oct 2021 15:09:25 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZaS3-00FrmD-EK; Sun, 10 Oct 2021 16:09:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/5] KVM: arm64: vgic-v3: Reduce common group trapping to
 ICV_DIR_EL1 when possible
Date: Sun, 10 Oct 2021 16:09:08 +0100
Message-Id: <20211010150910.2911495-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010150910.2911495-1-maz@kernel.org>
References: <20211010150910.2911495-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Joey Gouly <joey.gouly@arm.com>
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

On systems that advertise ICH_VTR_EL2.SEIS, we trap all GICv3 sysreg
accesses from the guest. From a performance perspective, this is OK
as long as the guest doesn't hammer the GICv3 CPU interface.

In most cases, this is fine, unless the guest actively uses
priorities and switches PMR_EL1 very often. Which is exactly what
happens when a Linux guest runs with irqchip.gicv3_pseudo_nmi=1.
In these condition, the performance plumets as we hit PMR each time
we mask/unmask interrupts. Not good.

There is however an opportunity for improvement. Careful reading
of the architecture specification indicates that the only GICv3
sysreg belonging to the common group (which contains the SGI
registers, PMR, DIR, CTLR and RPR) that is allowed to generate
a SError is DIR. Everything else is safe.

It is thus possible to substitute the trapping of all the common
group with just that of DIR if it supported by the implementation.
Yes, that's yet another optional bit of the architecture.
So let's just do that, as it leads to some impressive result on
the M1:

Without this change:
	bash-5.1# /host/home/maz/hackbench 100 process 1000
	Running with 100*40 (== 4000) tasks.
	Time: 56.596

With this change:
	bash-5.1# /host/home/maz/hackbench 100 process 1000
	Running with 100*40 (== 4000) tasks.
	Time: 8.649

which is a pretty convincing result.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/vgic/vgic-v3.c   | 15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..9412a645a1c0 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1152,6 +1152,7 @@
 #define ICH_HCR_TC		(1 << 10)
 #define ICH_HCR_TALL0		(1 << 11)
 #define ICH_HCR_TALL1		(1 << 12)
+#define ICH_HCR_TDIR		(1 << 14)
 #define ICH_HCR_EOIcount_SHIFT	27
 #define ICH_HCR_EOIcount_MASK	(0x1f << ICH_HCR_EOIcount_SHIFT)
 
@@ -1184,6 +1185,8 @@
 #define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
+#define ICH_VTR_TDS_SHIFT	19
+#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ae59e2580bf5..467c22bbade6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -15,6 +15,7 @@
 static bool group0_trap;
 static bool group1_trap;
 static bool common_trap;
+static bool dir_trap;
 static bool gicv4_enable;
 
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
@@ -296,6 +297,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
 	if (common_trap)
 		vgic_v3->vgic_hcr |= ICH_HCR_TC;
+	if (dir_trap)
+		vgic_v3->vgic_hcr |= ICH_HCR_TDIR;
 }
 
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
@@ -676,14 +679,18 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 
 		group0_trap = true;
 		group1_trap = true;
-		common_trap = true;
+		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
+			dir_trap = true;
+		else
+			common_trap = true;
 	}
 
-	if (group0_trap || group1_trap || common_trap) {
-		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
+	if (group0_trap || group1_trap || common_trap | dir_trap) {
+		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s%s], reduced performance)\n",
 			 group0_trap ? "G0" : "",
 			 group1_trap ? "G1" : "",
-			 common_trap ? "C"  : "");
+			 common_trap ? "C"  : "",
+			 dir_trap    ? "D"  : "");
 		static_branch_enable(&vgic_v3_cpuif_trap);
 	}
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
