Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42800FA3746
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 10:54:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2CE149F38;
	Fri, 28 Oct 2022 06:54:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WNXC7NCvCAPN; Fri, 28 Oct 2022 06:54:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8664965C;
	Fri, 28 Oct 2022 06:54:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA3F410AD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cfVLkShyNIg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9954E413E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9F255B82959;
 Fri, 28 Oct 2022 10:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EBCC4347C;
 Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666954454;
 bh=0lZ//3BHR5+56dy8d+BEO9s/7eEiHz5+gPDQ0l6HjH4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WRPCxDOX7PbJxRW5K8++iPzGKPsTxXqs0amvpFxQ9CAKo6RW+en/wtPwa4BOy9gEJ
 6Y8qPqSDgFsm63ZAK3WR4VqTIP3GB/SrVukcKfFlvFwcEhbreSLhAdJQWVpk7jZxp1
 13c6ZHskETytIOz+J5jdEEuc2XZdfngEVNT4GKVJqNXa5KEYPh70UzqajtLbJSRbJv
 hsSpJfrrnp1kwYjIzSEwNJuJNHC7EurDmWqoI8b3D0KbfWSgJqIOUyXTYGxlqR/S1C
 YLTUTzWksyIQ5UtXuvrtSVn98hIwwofefqPdzOiOO1mqxSQtpoQLEEmDfFfsquSrYS
 hCIzK61zWy3Ew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN08-002E4C-JX;
 Fri, 28 Oct 2022 11:54:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 06/14] KVM: arm64: PMU: Only narrow counters that are not
 64bit wide
Date: Fri, 28 Oct 2022 11:53:54 +0100
Message-Id: <20221028105402.2030192-7-maz@kernel.org>
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

The current PMU emulation sometimes narrows counters to 32bit
if the counter isn't the cycle counter. As this is going to
change with PMUv3p5 where the counters are all 64bit, fix
the couple of cases where this happens unconditionally.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 39a04ae424d1..8f6462cbc408 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -151,20 +151,17 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  */
 static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
-	u64 counter, reg, val;
+	u64 reg, val;
 
 	if (!pmc->perf_event)
 		return;
 
-	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+	val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
+	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		reg = PMCCNTR_EL0;
-		val = counter;
-	} else {
+	else
 		reg = PMEVCNTR0_EL0 + pmc->idx;
-		val = lower_32_bits(counter);
-	}
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
@@ -416,7 +413,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 
 		/* Increment this counter */
 		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
-		reg = lower_32_bits(reg);
+		if (!kvm_pmu_idx_is_64bit(vcpu, i))
+			reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
 		/* No overflow? move on */
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
