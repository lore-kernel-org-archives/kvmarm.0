Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60E6C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:07:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F964B97E;
	Thu, 20 Oct 2022 05:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ip9wjRdgRpco; Thu, 20 Oct 2022 05:07:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 839414B96D;
	Thu, 20 Oct 2022 05:07:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E054B94D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FkJVpYPL-Myz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:07:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 399554B916
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8C25C61A77;
 Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF67C43144;
 Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666256858;
 bh=xyiyg9il/ViIF4bM3FJ9Dsfm9mqVqIoR7isfo23/NMs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tAbIEMlGW44lpBy4A+Jy0Xv5KOgwSHnfozq6Kwr/9VVOntb+tOyDQV03qTIrlIJ8Y
 l/MnIdIr5P7PEIHhwY4K2D30+Mbq713bwK/QtmVGXp3mi2kWkvMS0ySnStahPxnDDf
 R/OwUTMIojl0j9DQbhGulf05qRL9qmRLyeJmPNAY9C9d0TrRTpZl6SFR2uk/wvCbQ0
 L0H+u77VaYd3aj0d1ut1KtLpl9kP/JoARYZICVBPipLG3db0R4Hrn8kk9VeF3cO7qb
 oUZ3w/db57sG/5hO7PxtP2f5fyk9HyLa2tLw1CErlGWQAdyhmhHChiweSqB3SSPPv0
 uah1VH+mkq/sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWZ-000Buf-T2;
 Thu, 20 Oct 2022 10:07:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/17] arm64: Allow EL1 physical timer access when running VHE
Date: Thu, 20 Oct 2022 10:07:15 +0100
Message-Id: <20221020090727.3669908-6-maz@kernel.org>
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

To initialise the timer access from EL2 when HCR_EL2.E2H is set,
we must make use the CNTHCTL_EL2 formap used is appropriate.

This amounts to shifting the timer/counter enable bits by 10
to the left.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 668569adf4d3..fa1045f709bb 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -34,6 +34,11 @@
  */
 .macro __init_el2_timers
 	mov	x0, #3				// Enable EL1 physical timers
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .LnVHE_\@
+	lsl	x0, x0, #10
+.LnVHE_\@:
 	msr	cnthctl_el2, x0
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
