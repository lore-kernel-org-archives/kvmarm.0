Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71575C433E9
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F38BF650A3
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F38BF650A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 920A54B453;
	Fri,  5 Mar 2021 13:53:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z0-nuRy3Mj+H; Fri,  5 Mar 2021 13:53:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DCD14B710;
	Fri,  5 Mar 2021 13:53:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92454B6D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cwjlhisFxmtU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 13:53:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F0484B6DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:06 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B3DA3650A7;
 Fri,  5 Mar 2021 18:53:05 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lIFZQ-00HYFA-0s; Fri, 05 Mar 2021 18:53:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7/8] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
Date: Fri,  5 Mar 2021 18:52:53 +0000
Message-Id: <20210305185254.3730990-8-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com,
 suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Howard Zhang <Howard.Zhang@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

It looks like we have broken firmware out there that wrongly advertises
a GICv2 compatibility interface, despite the CPUs not being able to deal
with it.

To work around this, check that the CPU initialising KVM is actually able
to switch to MMIO instead of system registers, and use that as a
precondition to enable GICv2 compatibility in KVM.

Note that the detection happens on a single CPU. If the firmware is
lying *and* that the CPUs are asymetric, all hope is lost anyway.

Reported-by: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 35 +++++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 005daa0c9dd7..ee3682b9873c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -408,11 +408,42 @@ void __vgic_v3_init_lrs(void)
 /*
  * Return the GIC CPU configuration:
  * - [31:0]  ICH_VTR_EL2
- * - [63:32] RES0
+ * - [62:32] RES0
+ * - [63]    MMIO (GICv2) capable
  */
 u64 __vgic_v3_get_gic_config(void)
 {
-	return read_gicreg(ICH_VTR_EL2);
+	u64 val, sre = read_gicreg(ICC_SRE_EL1);
+	unsigned long flags = 0;
+
+	/*
+	 * To check whether we have a MMIO-based (GICv2 compatible)
+	 * CPU interface, we need to disable the system register
+	 * view. To do that safely, we have to prevent any interrupt
+	 * from firing (which would be deadly).
+	 *
+	 * Note that this only makes sense on VHE, as interrupts are
+	 * already masked for nVHE as part of the exception entry to
+	 * EL2.
+	 */
+	if (has_vhe())
+		flags = local_daif_save();
+
+	write_gicreg(0, ICC_SRE_EL1);
+	isb();
+
+	val = read_gicreg(ICC_SRE_EL1);
+
+	write_gicreg(sre, ICC_SRE_EL1);
+	isb();
+
+	if (has_vhe())
+		local_daif_restore(flags);
+
+	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
+	val |= read_gicreg(ICH_VTR_EL2);
+
+	return val;
 }
 
 u64 __vgic_v3_read_vmcr(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index c3e6c3fd333b..6f530925a231 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -575,8 +575,10 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	bool has_v2;
 	int ret;
 
+	has_v2 = ich_vtr_el2 >> 63;
 	ich_vtr_el2 = (u32)ich_vtr_el2;
 
 	/*
@@ -596,13 +598,15 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 			 gicv4_enable ? "en" : "dis");
 	}
 
+	kvm_vgic_global_state.vcpu_base = 0;
+
 	if (!info->vcpu.start) {
 		kvm_info("GICv3: no GICV resource entry\n");
-		kvm_vgic_global_state.vcpu_base = 0;
+	} else if (!has_v2) {
+		pr_warn(FW_BUG "CPU interface incapable of MMIO access\n");
 	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)info->vcpu.start);
-		kvm_vgic_global_state.vcpu_base = 0;
 	} else {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
