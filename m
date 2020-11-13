Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECFEC6369E
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03EB422226
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="riZ/QyU+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03EB422226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A07894B626;
	Fri, 13 Nov 2020 13:26:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ma2TZDW4Fuvm; Fri, 13 Nov 2020 13:26:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BCF4B8E9;
	Fri, 13 Nov 2020 13:26:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 355224B614
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EpJndkjLKbo2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48A3E4B60C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4A10D2074B;
 Fri, 13 Nov 2020 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291978;
 bh=yeLt3nqD1e41ZnMR7XCTopnao0wO6yUaD1zjpERGPFg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=riZ/QyU++0GCZfImskdEDD1g5xZEAsgyBKPpbHX8INDflaVbu4TWHBkJGT8wFQrcS
 OKHFi1pIO+TS1YAlfDlPmVV6Cxqs4ZMX4xaSrjHcODLaBMBwr5E33vjp10Py2Aachn
 lUId5tI+2N6O8se/g9z90oT0DVT+48ALpzd+MIDM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm4-00APrY-Gt; Fri, 13 Nov 2020 18:26:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 2/8] KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU
 support
Date: Fri, 13 Nov 2020 18:25:56 +0000
Message-Id: <20201113182602.471776-3-maz@kernel.org>
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

We always expose the HW view of PMU in ID_AA64FDR0_EL1.PMUver,
even when the PMU feature is disabled, while the architecture
says that FEAT_PMUv3 not being implemented should result in this
field being zero.

Let's follow the architecture's guidance.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2e1d745f067..6629cfde2838 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,10 +1070,15 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
 	} else if (id == SYS_ID_AA64DFR0_EL1) {
+		u64 cap = 0;
+
 		/* Limit guests to PMUv3 for ARMv8.1 */
+		if (kvm_vcpu_has_pmu(vcpu))
+			cap = ID_AA64DFR0_PMUVER_8_1;
+
 		val = cpuid_feature_cap_perfmon_field(val,
 						ID_AA64DFR0_PMUVER_SHIFT,
-						ID_AA64DFR0_PMUVER_8_1);
+						cap);
 	} else if (id == SYS_ID_DFR0_EL1) {
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
