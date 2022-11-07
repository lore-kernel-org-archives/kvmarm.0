Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBA1C43219
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 08:55:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 790FA4B887;
	Mon,  7 Nov 2022 03:55:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uDKFjNfC7CAB; Mon,  7 Nov 2022 03:55:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A21344B8E3;
	Mon,  7 Nov 2022 03:55:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 294464B8C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 03:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kchbQ7mX5+y1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 03:54:59 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93A4A4B8B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 03:54:59 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 102F460F64;
 Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7002C43145;
 Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667811298;
 bh=MNXh2D3/U/f8f4P2vjjOKj5aW0mVW7lffQpLgwH4/Rs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IjAOVcgt067lhhgS4kWCAQ5nBuuvO/ylfbO+Miz4jpgiyT8GdeY3Tpdnl88VGMItj
 gD9gfKIDC0UoRTV92hl1GiUgY6aBT9QwncDCbsTSxX0LVzmf+i+FzjEoqVbs6mY/bl
 m020kuEa9VNVqcTlYnPCSZrVuOzQeVtqmy8mhFfDgb939EBouyENLWTAL2MkSEoq/P
 0w5Q0BxQ90m2AKKD3qOo0NHIIy/TWKrb+oRRvIbVo0eLVZuFLWNf2JaolAgRVze8b7
 FKyH1j2XKbeb6AUcz9Q9qWmJVk7H1CuG9sefPgLxZgZWVZkmXfpHl73qVKeqJckKxz
 U9F2anzg64Wdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1orxuD-004KxX-0G;
 Mon, 07 Nov 2022 08:54:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v3 07/14] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Date: Mon,  7 Nov 2022 08:54:28 +0000
Message-Id: <20221107085435.2581641-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
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

In order to reduce the boilerplate code, add two helpers returning
the counter register index (resp. the event register) in the vcpu
register file from the counter index.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8f6462cbc408..44ad0fdba4db 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -77,6 +77,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
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
@@ -91,8 +101,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return 0;
 
-	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(select_idx);
 	counter = __vcpu_sys_reg(vcpu, reg);
 
 	/*
@@ -122,8 +131,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
+	reg = counter_index_to_reg(select_idx);
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 
 	/* Recreate the perf event to reflect the updated sample_period */
@@ -158,10 +166,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 
 	val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		reg = PMCCNTR_EL0;
-	else
-		reg = PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(pmc->idx);
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
@@ -406,16 +411,16 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		u64 type, reg;
 
 		/* Filter on event type */
-		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		type = __vcpu_sys_reg(vcpu, counter_index_to_evtreg(i));
 		type &= kvm_pmu_event_mask(vcpu->kvm);
 		if (type != event)
 			continue;
 
 		/* Increment this counter */
-		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
 		if (!kvm_pmu_idx_is_64bit(vcpu, i))
 			reg = lower_32_bits(reg);
-		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
 
 		/* No overflow? move on */
 		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
@@ -551,8 +556,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
 
-	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
+	reg = counter_index_to_evtreg(select_idx);
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
@@ -634,8 +638,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
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
