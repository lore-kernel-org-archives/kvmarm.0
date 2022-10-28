Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FD3C38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 11:16:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4318B49673;
	Fri, 28 Oct 2022 07:16:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e0DP-ZjhgjAT; Fri, 28 Oct 2022 07:16:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE8E49EC4;
	Fri, 28 Oct 2022 07:16:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1936405AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:16:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2PeBO5F-uByl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 07:16:32 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF78543C8C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:16:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 47EDC627C2;
 Fri, 28 Oct 2022 11:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7462C433C1;
 Fri, 28 Oct 2022 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666955791;
 bh=/w3KQ4ekRSwyFLr5poURdPuohsmeyxZIMN9hwP3KB9c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EE/9K5kkUA+bl/IuQ3v1Ncivdi6gSGVgUnlZLFq8bhIRzNYeZOcKpbgCJ3dPPvhH3
 I0Ub/aW1u2z9WdjYnR+qXmSYP1btH3Ia94iUX+9gZsFVk1oeDJMqjeMTvXvfskoMhE
 WiE/U2aqKH3Irl4hyWcpHWrGwX+eD51TwJKNEc0rWY313ZBVTGFfJTI5RjZsx8ClsL
 tRSMgvEdizwhvCTv+brkuntkdD5ycyFuP9KpN6s9PBqtWJzXdVEHpuWcceTgzarcit
 OBRbrA+sEQg0ebMfMw60G/ojyIxOR0ZoXw2aUszHyCBT+QIwK9n3S9Rys0BYzuJEdV
 RCZXIxMzWF0xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN0A-002E4C-Ku;
 Fri, 28 Oct 2022 11:54:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 14/14] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the
 guest
Date: Fri, 28 Oct 2022 11:54:02 +0100
Message-Id: <20221028105402.2030192-15-maz@kernel.org>
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

Now that the infrastructure is in place, bump the PMU support up
to PMUv3p5.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index dc163e1a1fcf..26293f842b0f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1059,6 +1059,6 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	tmp = cpuid_feature_cap_perfmon_field(tmp,
 					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-					      ID_AA64DFR0_EL1_PMUVer_V3P4);
+					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
