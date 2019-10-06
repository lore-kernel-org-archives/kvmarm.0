Return-Path: <SRS0=mtSq=X7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C56C4360C
	for <kvmarm@archiver.kernel.org>; Sun,  6 Oct 2019 10:47:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E3F921479
	for <kvmarm@archiver.kernel.org>; Sun,  6 Oct 2019 10:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6Qx4aJw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E3F921479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37F724A80B;
	Sun,  6 Oct 2019 06:47:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X+SVdUX2jwwS; Sun,  6 Oct 2019 06:47:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2AF4A654;
	Sun,  6 Oct 2019 06:47:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D564A541
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Oct 2019 06:47:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k6XYmNHhQz4i for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Oct 2019 06:47:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC1F44A807
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Oct 2019 06:47:02 -0400 (EDT)
Received: from localhost.localdomain (82-132-217-85.dab.02.net [82.132.217.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1640E21479;
 Sun,  6 Oct 2019 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1570358822;
 bh=BP1l8qRwdBHc2b0glDmUNsamGkZG1dNdWAdZx4mn8yc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=h6Qx4aJw/nWwQAC8L/sKrb93GHAkb1BQJqdEWMG8dvovCAmixwSxGvx4AnecyF0Nw
 mKAGSs3M3Yy+o6xRhNodMge8uwM5yGuqYNkOn2un/VMl1TaX7AHmC5p9KZa/vDI4ko
 vH0BxBuzUEBrfz554CNWs9jbo1AJVmzh/Q2zS6xA=
From: maz@kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: pmu: Fix cycle counter truncation
Date: Sun,  6 Oct 2019 11:46:34 +0100
Message-Id: <20191006104636.11194-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191006104636.11194-1-maz@kernel.org>
References: <20191006104636.11194-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

When a counter is disabled, its value is sampled before the event
is being disabled, and the value written back in the shadow register.

In that process, the value gets truncated to 32bit, which is adequate
for any counter but the cycle counter (defined as a 64bit counter).

This obviously results in a corrupted counter, and things like
"perf record -e cycles" not working at all when run in a guest...
A similar, but less critical bug exists in kvm_pmu_get_counter_value.

Make the truncation conditional on the counter not being the cycle
counter, which results in a minor code reorganisation.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Cc: Andrew Murray <andrew.murray@arm.com>
Reported-by: Julien Thierry <julien.thierry.kdev@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 362a01886bab..c30c3a74fc7f 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -146,8 +146,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	if (kvm_pmu_pmc_is_chained(pmc) &&
 	    kvm_pmu_idx_is_high_counter(select_idx))
 		counter = upper_32_bits(counter);
-
-	else if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
+	else if (select_idx != ARMV8_PMU_CYCLE_IDX)
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -193,7 +192,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  */
 static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
-	u64 counter, reg;
+	u64 counter, reg, val;
 
 	pmc = kvm_pmu_get_canonical_pmc(pmc);
 	if (!pmc->perf_event)
@@ -201,16 +200,19 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
-	if (kvm_pmu_pmc_is_chained(pmc)) {
-		reg = PMEVCNTR0_EL0 + pmc->idx;
-		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
-		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
+	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
+		reg = PMCCNTR_EL0;
+		val = counter;
 	} else {
-		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
-		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
+		reg = PMEVCNTR0_EL0 + pmc->idx;
+		val = lower_32_bits(counter);
 	}
 
+	__vcpu_sys_reg(vcpu, reg) = val;
+
+	if (kvm_pmu_pmc_is_chained(pmc))
+		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
+
 	kvm_pmu_release_perf_event(pmc);
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
