Return-Path: <SRS0=Brgg=X4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DF0C10F14
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 17:24:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18C7920830
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 17:24:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18C7920830
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59A264A782;
	Thu,  3 Oct 2019 13:24:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C24-DOEduq4I; Thu,  3 Oct 2019 13:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA084A764;
	Thu,  3 Oct 2019 13:24:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFE7A4A764
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 13:24:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UaaFD2JbuaWX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Oct 2019 13:24:20 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C08274A758
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 13:24:20 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iG4ps-0003xB-EA; Thu, 03 Oct 2019 19:24:16 +0200
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: pmu: Fix cycle counter truncation on counter stop
Date: Thu,  3 Oct 2019 18:24:00 +0100
Message-Id: <20191003172400.21157-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 james.morse@arm.com, andrew.murray@arm.com, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
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

When a counter is disabled, its value is sampled before the event
is being disabled, and the value written back in the shadow register.

In that process, the value gets truncated to 32bit, which is adequate
for any counter but the cycle counter, which can be configured to
hold a 64bit value. This obviously results in a corrupted counter,
and things like "perf record -e cycles" not working at all when
run in a guest...

Make the truncation conditional on the counter not being 64bit.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Cc: Andrew Murray <andrew.murray@arm.com>
Reported-by: Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 362a01886bab..d716aef2bae9 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -206,9 +206,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
 		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
 	} else {
+		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+			counter = lower_32_bits(counter);
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
-		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
+		__vcpu_sys_reg(vcpu, reg) = counter;
 	}
 
 	kvm_pmu_release_perf_event(pmc);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
