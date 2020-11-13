Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC6CC55ABD
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80C7C206E0
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4LYJiFN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80C7C206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB724B8AB;
	Fri, 13 Nov 2020 13:26:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XCdhWk6Iea7t; Fri, 13 Nov 2020 13:26:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57BC64BBC0;
	Fri, 13 Nov 2020 13:26:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4A14B9DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2-oyo83-dzRo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98FC34B5EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BB39D206FB;
 Fri, 13 Nov 2020 18:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291981;
 bh=Gw5jS1fVKa0k38+ciCyXKBNN4xGCb2jxxfZxp9akaxw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=H4LYJiFNh7lEDt35mIZL2a3do2WVbL5iI8kOeL50vrKZQr6e9T5geRlxgUwRF8V3Y
 xVCz0E6YfgG1mwe8LHYZ37OGdXBYYXsZDv55Nzni4+m3esO2eS8HoJ4ZvAEscYjN1W
 AdEozIjd//FsRJ1jaueMHoghL/PAJaKfKPYeueIE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm7-00APrY-ED; Fri, 13 Nov 2020 18:26:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 8/8] KVM: arm64: Get rid of the PMU ready state
Date: Fri, 13 Nov 2020 18:26:02 +0000
Message-Id: <20201113182602.471776-9-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 kernel-team@android.com
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

The PMU ready state has no user left. Goodbye.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 1 -
 include/kvm/arm_pmu.h     | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8806fdc85e8a..643cf819f3c0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -851,7 +851,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 	}
 
 	kvm_pmu_vcpu_reset(vcpu);
-	vcpu->arch.pmu.ready = true;
 
 	return 0;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1d94acd0bc85..fc85f50fa0e9 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -24,13 +24,11 @@ struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
-	bool ready;
 	bool created;
 	bool irq_level;
 	struct irq_work overflow_work;
 };
 
-#define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
@@ -61,7 +59,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
-#define kvm_arm_pmu_v3_ready(v)		(false)
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
