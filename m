Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625E8C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 12:51:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12CD64B131;
	Fri, 28 Jan 2022 07:51:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fcLnnzx4mqxs; Fri, 28 Jan 2022 07:51:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 742E54B22C;
	Fri, 28 Jan 2022 07:51:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7279D4B1E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:51:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ppeyr9F4En+E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 07:51:06 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C15F4B204
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:51:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C68A861CAE;
 Fri, 28 Jan 2022 12:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB0C340E0;
 Fri, 28 Jan 2022 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643374265;
 bh=QNYfQ4nWJsQi/3DRoVVwcKktckvbvFtn7+vYhA9xY+A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dEbCaksIdXBWaJsSkmn2KfgiyUZ//G6xsgB69pskssWpYSo8a4Z6cTo3VyE75I20a
 4dvRuD69yoHSothHmadr27suIwwJCzsS94A3PQ0bKHt6zqGKi6AubOE8OYDkB1Uvic
 cjxSRfQlHWfdrnmNWzKSM09dAzLMJRMAYY6yyAwaGYuxyiFp/eSFQBzE/C9jnoJRgb
 uC31Bh7ngmXQxPbDRRXkc80oSB6pNdH/gL3I3fdVjxv52kBVxQNIszZn4yv/+5yEcm
 3Z49vBIxKUYJ4kW062dEP/3nlgdDnIRjys4fKOfhom0VdCAWswcok2sEWhvI5ehzxH
 3sYcW2Gd6IvXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nDQEF-003njR-5y; Fri, 28 Jan 2022 12:19:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v6 33/64] KVM: arm64: nv: Hide RAS from nested guests
Date: Fri, 28 Jan 2022 12:18:41 +0000
Message-Id: <20220128121912.509006-34-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com,
 linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com,
 miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>, mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

We don't want to expose complicated features to guests until we have
a good grasp on the basic CPU emulation. So let's pretend that RAS,
doesn't exist in a nested guest. We already hide the feature bits,
let's now make sure VDISR_EL1 will UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ebcdf2714b73..5e8876177ce6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2212,6 +2212,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
