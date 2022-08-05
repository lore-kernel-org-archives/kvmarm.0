Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6480EC25B08
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 13:58:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CE7A4E910;
	Fri,  5 Aug 2022 09:58:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VkZzTMKcNSjc; Fri,  5 Aug 2022 09:58:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8814E90C;
	Fri,  5 Aug 2022 09:58:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0524E8E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O4Ky-CFUnPjH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 09:58:22 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A17FE4E8BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B677260CF3;
 Fri,  5 Aug 2022 13:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875ACC433D7;
 Fri,  5 Aug 2022 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1659707901;
 bh=p/KgIJgXT4aiUUsO7J7PNMFAD/KKFxDIkGl2LFuMnT8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aJ4wEfd3GIG7nOXQBHMHobN3jO/LmboU3vmtXnc1tOIEN/fYZ2vMzJDRWD2nq7kXk
 JH6TT0i/A3F9tyQbX/65mJxS5Zhk9GD6W86KIkgo9kMWFPJk6Vo9zMrT7aU+wP5XGT
 UzhuLVh7r2VeWYJEQC0pbWIucMULB4ezes3lQQXxGzYBvwOs6jDyJfD4IqQb/8eA/B
 89ZsM5ekOIxlr849rGzloXqBk2db/lOUgswK2amR8Kt8yzWWA/klUDmDYUlyoFqgoq
 ob1uz/33UQ+TrQBeLxbsF1P4kNFLcLCELW9OTgia7S8gehD9p8vskgiVwkzJyLwb5K
 qg6DnZkOIru9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oJxqF-001AeL-Lr;
 Fri, 05 Aug 2022 14:58:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 2/9] KVM: arm64: PMU: Distinguish between 64bit counter and
 64bit overflow
Date: Fri,  5 Aug 2022 14:58:06 +0100
Message-Id: <20220805135813.2102034-3-maz@kernel.org>
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

The PMU architecture makes a subtle difference between a 64bit
counter and a counter that has a 64bit overflow. This is for example
the case of the cycle counter, which can generate an overflow on
a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
done on 64 bits.

Use this distinction in the few cases where it matters in the code,
as we will reuse this with PMUv3p5 long counters.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4986e8b3ea6c..9040d3c80096 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -48,6 +48,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
  * @select_idx: The counter index
  */
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	return (select_idx == ARMV8_PMU_CYCLE_IDX);
+}
+
+static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
 		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
@@ -55,7 +60,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 
 static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
 {
-	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
+	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
+		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
 }
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
@@ -95,7 +101,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	if (select_idx != ARMV8_PMU_CYCLE_IDX)
+	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -447,7 +453,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	 */
 	period = -(local64_read(&perf_event->count));
 
-	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+	if (!kvm_pmu_idx_has_64bit_overflow(vcpu, pmc->idx))
 		period &= GENMASK(31, 0);
 
 	local64_set(&perf_event->hw.period_left, 0);
@@ -577,7 +583,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
 
 	/* The initial sample period (overflow count) of an event. */
-	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
+	if (kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
 		attr.sample_period = (-counter) & GENMASK(63, 0);
 	else
 		attr.sample_period = (-counter) & GENMASK(31, 0);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
