Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78428C38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 10:54:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366D749ED7;
	Fri, 28 Oct 2022 06:54:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YQNLv7VNlYZR; Fri, 28 Oct 2022 06:54:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A927B4B0B4;
	Fri, 28 Oct 2022 06:54:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC7340E00
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GGQeUMzEGt4h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12C8240BFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8957C627A5;
 Fri, 28 Oct 2022 10:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE23C43143;
 Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666954455;
 bh=1MGy/QeMLxL2CeOt6PAMUGtVNnUoFMhc4YFKjn7bA+o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=h4ACI/Mj5M2N8ZC1wrtD4q8bCqZrdFtkrek7AN03aqylYrgNEsD5/+tOwGXBfwq5K
 nno+clWWlJIYBDIb1NVBS+P5EbAfL0tGbnwE4O/ek6VbOdKIUN5GPCsXENoGwF8eHG
 CclVR+6Oeid+9p/inBODaOZ5Vc0RQ2IM18+6TUsFosU/heK20ZDJ085+G1UaQZyYcx
 Ud+Q6BIvWWAGLq+MZ9hqCJJm8f25hbygfVggQUcuLDcMlWBQim+hfXSwUJ5LC5Uphm
 6IHcrLO44WHgURsEPZ+JhqgNWDus4Fki64dafgjEv2BAzCA1Q7Q7n31S4a2z2e+i3/
 hbTEX8H8F8U7w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN09-002E4C-2t;
 Fri, 28 Oct 2022 11:54:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 08/14] KVM: arm64: PMU: Simplify setting a counter to a
 specific value
Date: Fri, 28 Oct 2022 11:53:56 +0100
Message-Id: <20221028105402.2030192-9-maz@kernel.org>
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

kvm_pmu_set_counter_value() is pretty odd, as it tries to update
the counter value while taking into account the value that is
currently held by the running perf counter.

This is not only complicated, this is quite wrong. Nowhere in
the architecture is it said that the counter would be offset
by something that is pending. The counter should be updated
with the value set by SW, and start counting from there if
required.

Remove the odd computation and just assign the provided value
after having released the perf event (which is then restarted).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 44ad0fdba4db..03b761a63f5f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -23,6 +23,7 @@ static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 
 static u32 kvm_pmu_event_mask(struct kvm *kvm)
 {
@@ -131,8 +132,10 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
+	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
+
 	reg = counter_index_to_reg(select_idx);
-	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+	__vcpu_sys_reg(vcpu, reg) = val;
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(vcpu, select_idx);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
