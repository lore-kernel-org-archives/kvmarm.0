Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63717C00140
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 13:58:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C604E8BB;
	Fri,  5 Aug 2022 09:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YEhCt18uqmhw; Fri,  5 Aug 2022 09:58:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEB894E9B7;
	Fri,  5 Aug 2022 09:58:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3AB4E8E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQd-fbDE98Bm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 09:58:23 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 064854E8F1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6D7B960C2D;
 Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E135C43470;
 Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1659707902;
 bh=tPPi/35u1+xAH7VI+tXRgYdfvc0e14/fq4K2Ct/AA4o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=O1GnaESsDeiGOSakSMTr02xZJFklIxuwNvPPfxSn7/zj22vrAKVheIwJzR3Ht1eDK
 q7Lad747oXBA+TBslvCa1M5apAHrsb2E5bB8zZloEirVvCHepw5GAmTLkMIKPShGAD
 5hQIiUqPL6GX5P5W8XNkuyhly5E1CVLZWEMsybVQHKaSJ7KSrXG6FZhF0N6U3nkhrq
 BESAXk/VdULk0L3n2o4+v/BxXR0OfOOVcrSZgMNzSCjcTgNgte3r5QvnpOAlBWtoVd
 xTo05OCDp54GmhquZ0ELVSC3CuWEvzz4zovQl1mCdEgWhIMaqXRhxpD4QQhQpKrNbs
 2YPGPSnMpLM2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oJxqG-001AeL-2c;
 Fri, 05 Aug 2022 14:58:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Date: Fri,  5 Aug 2022 14:58:08 +0100
Message-Id: <20220805135813.2102034-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 ricarkol@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

In order to reduce the boilerplate code, add two helpers returning
the counter register index (resp. the event register) in the vcpu
register file from the counter index.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0ab6f59f433c..9be485d23416 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
 	return container_of(vcpu_arch, struct kvm_vcpu, arch);
 }
 
+static u32 counter_index_to_reg(u64 idx)
+{
+	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
+}
+
+static u32 counter_index_to_evtreg(u64 idx)
+{
+	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
+}
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -89,8 +99,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return 0;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(select_idx);
 	counter = __vcpu_sys_reg(vcpu, reg);
 
 	/*
@@ -120,8 +129,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
+	reg = counter_index_to_reg(select_idx);
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 
 	/* Recreate the perf event to reflect the updated sample_period */
@@ -156,10 +164,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 
 	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		reg = PMCCNTR_EL0;
-	else
-		reg = PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(pmc->idx);
 
 	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
 		counter = lower_32_bits(counter);
@@ -540,8 +545,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
+	reg = counter_index_to_evtreg(select_idx);
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
@@ -627,8 +631,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+	reg = counter_index_to_evtreg(select_idx);
 
 	__vcpu_sys_reg(vcpu, reg) = data & mask;
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
