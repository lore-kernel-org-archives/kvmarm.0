Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59075C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 13 Nov 2022 16:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C64874B8EB;
	Sun, 13 Nov 2022 11:46:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MRvjtn0tqY+I; Sun, 13 Nov 2022 11:46:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C264B91B;
	Sun, 13 Nov 2022 11:46:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E2B4B915
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 11:46:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gkemiPJlth1T for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Nov 2022 11:46:34 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 064F94B8E3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 11:46:34 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 07A3260B3F;
 Sun, 13 Nov 2022 16:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF96C433D6;
 Sun, 13 Nov 2022 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668357992;
 bh=3V6vrRrhta2ubq0lpISi1AC/ZQTjSSL6jwZVKvTpgaY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mD2PmhqgOuTwCETtloXpVQ8ALOCRD4OYVOxdkVS8ar1v0Y7vhzEP683MnxNdppwLi
 2I6pjyVpyln/gNND938dwwTd5qVgI+nHWqx87m1eMjSa6T7wS8D9s5B6mByBzW2rFd
 SBr83i0iXV/SwkfnsUr4VaKhBnhZzmmKeLaPI3sHZOjR/csw2eX16YPZx94P1Cl26F
 jdCLXn3tBlR+YMrNQpS7Vn8zyEnWrpaogC1Mab0ujmI8GXI3nSQV28qK0S7ep54IiH
 RQdEPvPX+I7fyI9ZdXN4KcFF2m/ox0V04ys5Pf3YHxulOUM1hXGkZCBRiBiusLitdN
 q5dRYGH/QVkNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ouG0Q-005oYZ-MY;
 Sun, 13 Nov 2022 16:38:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v4 14/16] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the
 guest
Date: Sun, 13 Nov 2022 16:38:30 +0000
Message-Id: <20221113163832.3154370-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
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
index c37cc67ff1d7..b7a5f75d008d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1057,6 +1057,6 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
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
