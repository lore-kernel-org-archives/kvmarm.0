Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF97C43219
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A01E4B215;
	Tue, 14 Dec 2021 12:28:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lpi2Lm3JSHZo; Tue, 14 Dec 2021 12:28:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C264B22C;
	Tue, 14 Dec 2021 12:28:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAC84B21E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TS-u-5Sd3nhI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:19 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 992184B1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:19 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 i20-20020a0566022c9400b005ec5bb1e85eso18404358iow.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dkE80KJZU2BKakse2hQ7jV87ahQ5YomadoMUm+qJz2M=;
 b=TOAhrySHSGJuV+NGGLD4vDz6yAho4RCIclHYD49tWwn5F2L4+vnHDhRvePecRxm+BE
 soyKilcS3/H742ylFOr0Lt/Ip1YdlLudQRguDLHR2utNKT0tkobG3pV9QpdLmk9YLR2m
 xt2MpJeDyyoxICHRQBjAurQ2Be/tQAniONeA6mwSpykAdKOK5U+B6t+RUolDLvbTFyEJ
 YcgbfutesxYsPYSGrQTZM/Z8ixvO4A1Xia9MpchQkmxbMvwKmftpg69WzwD4KtQGM0kX
 venbV1JsmylOzQoiBNtufwRRrGTahtV44gKDeOumxuL1OnKu8Ao2ZrcfW1zZlPvY1Asl
 hrrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dkE80KJZU2BKakse2hQ7jV87ahQ5YomadoMUm+qJz2M=;
 b=AKNm2aZdY/lQC5tpJ7blnEDUg565QGUhFzsphJLrkny2HqqfbJhrnmj29cDKfILtdR
 +ap36YDteDl0s1wBN+wmtIYakmz15TYpt92wbQRgiXTbx8OObPENV3WpY1pU3kP7e5Vk
 f2p4OdmWCB16qI5ooN+2pABympByLhiCwcxV1qYGjOns8fnjRNwDKQe2AYWX4/PPTDjq
 NSaylBO4G9R9dMdZpySNp720K+AlG1oIWLRWW/XG1bfcWY6u0/JXb9N2VKsMZRAZEbK/
 YK3PcthIrAOwns6WRcOtHBTHdhHuticsKos/G/KoNNMtlkac4wUaiRQ/JAVxI6gk9ADI
 xhww==
X-Gm-Message-State: AOAM530GTew/+ANJCGSWnuFDHQjWON0waRWXo28LBQCObmnCnKuSDEt8
 3krN5Esmqnh3i3RQUh3X97THWCgO0OcXi1jWVArmKHyvfxGBgsHMutXzPiIfUd0NrLQOWAGKLd3
 YczupLodTOcDB/fwDuZ4YoNdG8ndC7PYlcAEWHsC6VNetVcQ7j43pFaEMnrc6R4mCfCpalQ==
X-Google-Smtp-Source: ABdhPJwlx+badFHXeudBOY0/DTEsOaO58kXH+u/oQcvLDqtXYpjKkq51uR0VlpbCCin+GDh54GlcWnJ4Q1k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1484:: with SMTP id
 a4mr4544883iow.35.1639502899090; Tue, 14 Dec 2021 09:28:19 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:08 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-3-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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

Wire up a custom handler for writes from userspace and prevent any of
the invariant bits from changing.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..53fc8a6eaf1c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -172,8 +172,10 @@ enum vcpu_sysreg {
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+	OSLSR_EL1,	/* OS Lock Status Register */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
+
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
 	PMSELR_EL0,	/* Event Counter Selection Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 11b4212c2036..7bf350b3d9cd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,12 +291,28 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
+	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
-	} else {
-		p->regval = (1 << 3);
-		return true;
-	}
+
+	p->regval = __vcpu_sys_reg(vcpu, r->reg);
+	return true;
+}
+
+static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			 const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u64 id = sys_reg_to_index(rd);
+	u64 val;
+	int err;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	if (val != rd->val)
+		return -EINVAL;
+
+	return 0;
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
@@ -1448,7 +1464,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1923,7 +1940,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
