Return-Path: <SRS0=IlRN=GY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19442C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 10:56:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F731238A1
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 10:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F731238A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F9454B138;
	Thu, 21 Jan 2021 05:56:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oeTIUHTPmxYa; Thu, 21 Jan 2021 05:56:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 729314B148;
	Thu, 21 Jan 2021 05:56:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89CDC4B137
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jan 2021 05:56:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fztvM5LrBd64 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jan 2021 05:56:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A65C4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jan 2021 05:56:43 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2A1D423787;
 Thu, 21 Jan 2021 10:56:42 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l2Xdn-009ATF-Tw; Thu, 21 Jan 2021 10:56:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Filter out v8.1+ events on v8.0 HW
Date: Thu, 21 Jan 2021 10:56:36 +0000
Message-Id: <20210121105636.1478491-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org
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

When running on v8.0 HW, make sure we don't try to advertise
events in the 0x4000-0x403f range.

Cc: stable@vger.kernel.org
Fixes: 88865beca9062 ("KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4ad66a532e38..247422ac78a9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -788,7 +788,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
 	u64 val, mask = 0;
-	int base, i;
+	int base, i, nr_events;
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
@@ -801,13 +801,17 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	if (!bmap)
 		return val;
 
+	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+
 	for (i = 0; i < 32; i += 8) {
 		u64 byte;
 
 		byte = bitmap_get_value8(bmap, base + i);
 		mask |= byte << i;
-		byte = bitmap_get_value8(bmap, 0x4000 + base + i);
-		mask |= byte << (32 + i);
+		if (nr_events >= (0x4000 + base + 32)) {
+			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+			mask |= byte << (32 + i);
+		}
 	}
 
 	return val & mask;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
