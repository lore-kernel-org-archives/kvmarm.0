Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8116BC43217
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:16:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AA74B904;
	Thu, 20 Oct 2022 05:16:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 58pHYLIoQFuU; Thu, 20 Oct 2022 05:16:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 082B14B981;
	Thu, 20 Oct 2022 05:16:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2652A4B904
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SJmVYPOe-0Re for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:16:45 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 486BB4B972
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:44 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C7CE861A77;
 Thu, 20 Oct 2022 09:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E184C433C1;
 Thu, 20 Oct 2022 09:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666257403;
 bh=aLcbmyX/kgZvgaopcNcriA4ZyIsxFlgipcGUgzsXUfs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oTCKgkNEk8Z0FKLsnxSj5WaHmv+AE3/EupRmztvJQZ71/vwlS/sa9xRqp/hC683WI
 jJ0+QXBbIpHBn1q86vDT4v0HV9syQkYELj0anKweTu3B4NMjtWdZMSjB/xBkpbkAKT
 jyLCAjgJLX0zHPHz+9eE/zQ9jxmu7wJEEXUBAL44JdmEN8CAAsur8HF8KQSf/HdMvb
 wudtP9RWwbloSoKM+8DC1MKpKdSJ0hEiKKvj8AjOcakt4Pke10sMTU1W74yftEO2Fb
 Jk9m4gAJBDfyyuOixv33//Dv243NrT3jtt+viwm2djhnXskIkgHGQs9tuVVOC9UiId
 gYQK+Zr0GTXEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWb-000Buf-Bg;
 Thu, 20 Oct 2022 10:07:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/17] KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
Date: Thu, 20 Oct 2022 10:07:21 +0100
Message-Id: <20221020090727.3669908-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

When using hVHE, we end-up with two TTBRs at EL2. That's great,
but we're not quite ready for this just yet.

Disable TTBR1_EL2 by setting TCR_EL2.EPD1 so that we only
translate via TTBR0_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 85df7ce0b051..cf0f15f4d69a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1548,7 +1548,13 @@ static void cpu_prepare_hyp_mode(int cpu)
 	 *
 	 * So use the same T0SZ value we use for the ID map.
 	 */
-	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
+	tcr = read_sysreg(tcr_el1);
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr |= TCR_EPD1_MASK;
+	} else {
+		tcr &= TCR_EL2_MASK;
+		tcr |= TCR_EL2_RES1;
+	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
