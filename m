Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539C8C00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85E2022268
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jeit1NMH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85E2022268
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1054B505;
	Mon,  2 Nov 2020 14:16:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t+LZZQnC2HnT; Mon,  2 Nov 2020 14:16:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B87DC4B57E;
	Mon,  2 Nov 2020 14:16:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C544B540
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xYg0wyr3AEjL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 14:16:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D3574B4E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:17 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D25C022268;
 Mon,  2 Nov 2020 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604344576;
 bh=/vSypgHV3ppGf3VM+3b9Uw3XIcZP+Wgme9h2xxf4rZk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Jeit1NMHhX4xxwzPds+AWo/WCs7knZm/wlcZzqEKKmDomnYeQkAHx89yAyZOvJgOh
 A9QTftl8eyR8VgstIFAL7SFsnPGmQ0Z0R1Oz8Dpiy2/T1LWSuzSCX8JzumwiaUuAmr
 roc9B0thDHMJ0rj+myJXbYJKk1+F1RUBByRuP1lI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZfJO-006nxn-2w; Mon, 02 Nov 2020 19:16:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/8] KVM: arm64: Add AArch32 mapping annotation
Date: Mon,  2 Nov 2020 19:16:03 +0000
Message-Id: <20201102191609.265711-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

In order to deal with the few AArch32 system registers that map to
only a particular half of their AArch64 counterpart (such as DFAR
and IFAR being colocated in FAR_EL1), let's add an optional annotation
to the sysreg descriptor structure, indicating whether a register
maps to the upper or lower 32bits of a register.

Nothing is using these annotation yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..259864c3c76b 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -27,6 +27,12 @@ struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
 
+	enum {
+		AA32_ZEROHIGH,
+		AA32_LO,
+		AA32_HI,
+	} aarch32_map;
+
 	/* MRS/MSR instruction which accesses it. */
 	u8	Op0;
 	u8	Op1;
@@ -153,6 +159,7 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  const struct sys_reg_desc table[],
 					  unsigned int num);
 
+#define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
 #define CRn(_x)		.CRn = _x
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
