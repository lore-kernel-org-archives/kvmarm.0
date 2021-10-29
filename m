Return-Path: <SRS0=gNwE=PR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1520CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D02B61106
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D02B61106
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E733407E7;
	Thu, 28 Oct 2021 20:32:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Glu4E91WNWB; Thu, 28 Oct 2021 20:32:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18524B186;
	Thu, 28 Oct 2021 20:32:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5BD4B192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ojd6BedaFfsO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 20:32:42 -0400 (EDT)
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com
 [209.85.210.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D68874B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:42 -0400 (EDT)
Received: by mail-ot1-f74.google.com with SMTP id
 l17-20020a9d7351000000b0054e7cd8a64dso4397223otk.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/sJBbEboFqrI/MxFIGHyMR9wTr4lxmpL5NLpkV9j8hQ=;
 b=CS2JS7vwBb0zhIoVa/v/R9TXNAMyxaDHa0+R30BfqVftv8Ib04TdU50zJzA+/zP95r
 LVY/dLq68XY1xApshEteH2mXaeynz6bRdH8aOhxFWwVQq86cfvuFfYEuLJcCDXYHorQQ
 MBdvOweKuyeYEOk2XfpMSh9hjycA1O037blIDV4CbL2jP9YGYfyQ0Hksc9zg3IRdEWR+
 OkR4YO4AK+9nmA8SLd2rhR9AZRlmkUkQX/ZliV8doGjv6mAtlv6wrG0JZJMVvIUYHXIP
 uwOtf00tTbn/yxsHw7L6jgh0PYBAuz8JofNLLKjix4GWKWTuPPCxWWXzMtaX9BEjLxr+
 3Sbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/sJBbEboFqrI/MxFIGHyMR9wTr4lxmpL5NLpkV9j8hQ=;
 b=VKX6jPuM3FygRuL0PULCgQ28aLUhHq2WCeDfaMIZHPpZUfvyPHu46W2dXlgegtHM6w
 t1CgibLEFD1DdyxwYewNcvGT6NjcfimtYp2mR/VN8sGX0s3x1CNGCptHxKy+YgICg9EH
 NW8QvDEdDuW9OsCb8lr63MUC1DOBVy8yiMxC5d00+mU9w3VNrjPoXiYtqCWh1g41tCml
 gHf8dPcsB1cQ17mTwOLfqXfOQXBgFd9ovQCrYXjMSS4agYU3vl6Rw7pPwleOp/ry6ICp
 EdKXI9maKf0DhnF4hEhSPfyk3JkjXnUDT7DqC+CNbrkRR8P3IXYf05ZsU/rHnsFfb02I
 h4+A==
X-Gm-Message-State: AOAM530nODWDekU7fy/Jn40Rj+wU1bpTestoVUF6dgnzFQggZhehNDdy
 HbwtZxGtxRaQfW+Q49hGMooN+QLd1eC7cx5inkpSda3dMMlTlOofJq23I4OXt08NLJMjNKXPcxo
 mvMZKtmOEoERyslMhUJy2AeyT0m+NZk5aXplP/OfXyy9G7PJ9dqBGAph1aGpduQHd7yjVYQ==
X-Google-Smtp-Source: ABdhPJy9nXHALTXt4MgBaSGvD9mD2E3itk627BvZ8WCtIIPahARJ3cpAv7JLd0lNeNrT9GzDK78pS6NEvAI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:6ce:: with SMTP id
 m14mr5671351oih.134.1635467562084; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
Date: Fri, 29 Oct 2021 00:32:00 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-2-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 1/3] KVM: arm64: Stash OSLSR_EL1 in the cpu context
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

An upcoming change to KVM will context switch the OS Lock status between
guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
using the stored value.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..c98f65c4a1f7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -172,6 +172,7 @@ enum vcpu_sysreg {
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
+	OSLSR_EL1,	/* OS Lock Status Register */
 
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..0eb03e7508fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,12 +291,11 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
+	if (p->is_write)
 		return ignore_write(vcpu, p);
-	} else {
-		p->regval = (1 << 3);
-		return true;
-	}
+
+	p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+	return true;
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
@@ -1441,7 +1440,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008 },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1916,7 +1915,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
