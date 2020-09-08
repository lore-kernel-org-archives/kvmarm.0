Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8215C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 07:58:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19B102177B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 07:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsPcdtfA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19B102177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75DE64B4BA;
	Tue,  8 Sep 2020 03:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id td36YE0t6nDh; Tue,  8 Sep 2020 03:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8BC4B37C;
	Tue,  8 Sep 2020 03:58:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2144B561
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 03:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VFE7Ww-JstS3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 03:58:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 491FF4B4BA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 03:58:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B9EB621D6C;
 Tue,  8 Sep 2020 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599551928;
 bh=4krfchsT8X0gKS7c3hX0W/WHBUA/yypESIUHYByJQVs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EsPcdtfAX48Jq0P7tQpHEJqqXjA39iEWqHkm1EOZadTHz3xM7CZciJrBBEmLgNpsS
 yJkMVPcZYb9llmSKqwi3UOq6K5oevjY7kL2Q45SxLA4XFKqMMPDqEywioopkzYowrc
 XQKmFXS1d51aRjDy42o2NOarWIXFEB8Z1lh/bXmY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kFYWd-009zhy-9J; Tue, 08 Sep 2020 08:58:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in PCMEID{0,
 1}_EL1
Date: Tue,  8 Sep 2020 08:58:29 +0100
Message-Id: <20200908075830.1161921-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075830.1161921-1-maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com,
 mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, graf@amazon.com,
 Robin Murphy <robin.murphy@arm.com>
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

As we can now hide events from the guest, let's also adjust its view of
PCMEID{0,1}_EL1 so that it can figure out why some common events are not
counting as they should.

The astute user can still look into the TRM for their CPU and find out
they've been cheated, though. Nobody's perfect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c |  5 +----
 include/kvm/arm_pmu.h     |  5 +++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 67a731bafbc9..0458860bade2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -765,6 +765,35 @@ static int kvm_pmu_probe_pmuver(void)
 	return pmuver;
 }
 
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
+	u64 val, mask = 0;
+	int base, i;
+
+	if (!pmceid1) {
+		val = read_sysreg(pmceid0_el0);
+		base = 0;
+	} else {
+		val = read_sysreg(pmceid1_el0);
+		base = 32;
+	}
+
+	if (!bmap)
+		return val;
+
+	for (i = 0; i < 32; i += 8) {
+		u64 byte;
+
+		byte = bitmap_get_value8(bmap, base + i);
+		mask |= byte << i;
+		byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+		mask |= byte << (32 + i);
+	}
+
+	return val & mask;
+}
+
 bool kvm_arm_support_pmu_v3(void)
 {
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 077293b5115f..20ab2a7d37ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -769,10 +769,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (!(p->Op2 & 1))
-		pmceid = read_sysreg(pmceid0_el0);
-	else
-		pmceid = read_sysreg(pmceid1_el0);
+	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
 
 	p->regval = pmceid;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6db030439e29..98cbfe885a53 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -34,6 +34,7 @@ struct kvm_pmu {
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
@@ -108,6 +109,10 @@ static inline int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	return 0;
+}
 #endif
 
 #endif
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
