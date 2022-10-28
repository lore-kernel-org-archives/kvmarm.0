Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76981FA3740
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 11:16:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31C1349673;
	Fri, 28 Oct 2022 07:16:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tmRamZBH3k7V; Fri, 28 Oct 2022 07:16:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C26C4A49C;
	Fri, 28 Oct 2022 07:16:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A6048A48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rDeYDdj5l+SN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 07:16:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30EA5407EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:16:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B08BB627C0;
 Fri, 28 Oct 2022 11:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA08C433D7;
 Fri, 28 Oct 2022 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666955798;
 bh=fE2j6SLmDCP9twYIE3kegzSGYsqWuhNfTVWicAFlrzA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PL+nMlKa1sBrdojvm7BpAesJXyMuUFPrgLxKb8yo33hAtHTfnhgcnbO2BOrOtcKcD
 EFdQda53u/fPdACj1npO0Q+/M7mSMt4xr9URe6Ee1M0cBby/hmwkkowGYtV4ZkkTw4
 XjPUF8zjUJjl8ukP8TQs5MArBPrYn6k8bmdMZI0woxLI4S6wEPjoKEroc7BS2ZdRQZ
 TzDyk2vzo8s5kScbKb4LqaT1NnPr1Nunblf77EjJs+nw9J/9B/5mX0kKYgnwhoouuJ
 7k8Hr7O+9eiRXx988/Gdm+yua9oeSYD96kSD3rKZgBTax5PmMKlyubCo6hwJCq7H9e
 IYKda/EwYDjfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN0A-002E4C-5d;
 Fri, 28 Oct 2022 11:54:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 12/14] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be set
 from userspace
Date: Fri, 28 Oct 2022 11:54:00 +0100
Message-Id: <20221028105402.2030192-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Allow userspace to write ID_DFR0_EL1, on the condition that only
the PerfMon field can be altered and be something that is compatible
with what was computed for the AArch64 view of the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 53 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4fa14b4ae2a6..603d2b43e8ce 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1075,6 +1075,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static u8 perfmon_to_pmuver(u8 perfmon)
+{
+	switch (perfmon) {
+	case ID_DFR0_PERFMON_8_0:
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+	case ID_DFR0_PERFMON_IMP_DEF:
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	default:
+		/* Anything ARMv8.1+ has the same value. For now. */
+		return perfmon;
+	}
+}
+
 static u8 pmuver_to_perfmon(u8 pmuver)
 {
 	switch (pmuver) {
@@ -1281,6 +1294,42 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_desc *rd,
+			   u64 val)
+{
+	u8 perfmon, host_perfmon = 0;
+
+	if (system_supports_32bit_el0())
+		host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+
+	/*
+	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
+	 * it doesn't promise more than what the HW gives us on the
+	 * AArch64 side (as everything is emulated with that), and
+	 * that this is a PMUv3.
+	 */
+	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_PERFMON), val);
+	if ((perfmon != ID_DFR0_PERFMON_IMP_DEF && perfmon > host_perfmon) ||
+	    (perfmon != 0 && perfmon < ID_DFR0_PERFMON_8_0))
+		return -EINVAL;
+
+	/* We already have a PMU, don't try to disable it... */
+	if (kvm_vcpu_has_pmu(vcpu) &&
+	    (perfmon == 0 || perfmon == ID_DFR0_PERFMON_IMP_DEF))
+		return -EINVAL;
+
+	/* We can only differ with PerfMon, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+	if (val)
+		return -EINVAL;
+
+	vcpu->kvm->arch.dfr0_pmuver = perfmon_to_pmuver(perfmon);
+
+	return 0;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1502,7 +1551,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	AA32_ID_SANITISED(ID_DFR0_EL1),
+	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
+	  .visibility = aa32_id_visibility, },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
