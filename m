Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D30EFA3744
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 10:54:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2B348A48;
	Fri, 28 Oct 2022 06:54:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p0aSUhtF8XCO; Fri, 28 Oct 2022 06:54:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5CD49EED;
	Fri, 28 Oct 2022 06:54:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B3C440B65
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDco+URfqvVb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 06:54:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7732C40403
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E703562793;
 Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF58C43140;
 Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666954454;
 bh=K2X563RbVS1OM58x/YhfoVroBF5xoDrdh5uLOVn7/T0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aSvyu4Xnav/CNn9qCsKdCPtRdQgjPQQgMfKRgMIfBOYnJf9nRZR1T/ThsWNPHqXvT
 qe2uni7rkZgTQPQXOiCt7bIT/r3u97JtpW6j2q7dcbgbDNu92WPbKh873zuwXn4iZl
 LK70FJ5uJaDS0YjwofvwOM9xPqlA6SVeUH9Q5XboTINYTzK/HS8FLULLtNFn0aZ6f3
 cWfq9aTzlC/BT+nTB5WLuFNVynBXCZeYOgFr6iV5NiGge4/6kSv8/MZz8QBLG6+Ywx
 cf2JnyzkuUIpR3zGyTCcRl/P7tUiECc+a1p0ANG1C6u/thO6+AIPKP5CVhdffXccvL
 ioLx9FLVZyJ0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN08-002E4C-C7;
 Fri, 28 Oct 2022 11:54:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 05/14] KVM: arm64: PMU: Narrow the overflow checking when
 required
Date: Fri, 28 Oct 2022 11:53:53 +0100
Message-Id: <20221028105402.2030192-6-maz@kernel.org>
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

For 64bit counters that overflow on a 32bit boundary, make
sure we only check the bottom 32bit to generate a CHAIN event.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3724acefc07b..39a04ae424d1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -419,7 +419,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
-		if (reg) /* No overflow? move on */
+		/* No overflow? move on */
+		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
 			continue;
 
 		/* Mark overflow */
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
