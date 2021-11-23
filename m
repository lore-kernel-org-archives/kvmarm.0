Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586A6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 21:01:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 074A54B128;
	Tue, 23 Nov 2021 16:01:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fZ4WzKIM8bEN; Tue, 23 Nov 2021 16:01:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA724B125;
	Tue, 23 Nov 2021 16:01:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A804B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mvbeEdf+PsH6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 16:01:18 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B82654B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:18 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 x6-20020a056e021bc600b00292aa8bec6cso190869ilv.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3r/HSQlSMaGqGuO6qlyByqylj4w37aYh03CWLKihWyE=;
 b=I8o6vjAywpa6ruSUYX/8rdQEeBmRUvrZry6knOs03Fgu95sSJgIAGoEOAm5r52PDyM
 OPUu6j2D962rPDVnZCg/PcPaiRpKDm27kqyLUztlCTLwup2hcjFYHG7RZ4r4CJHzjpjo
 47XmcQns0NFxIW4y+Tam+CSpz0of/dHbWg06/kEztW/6TQd9Jtg184l9TrwZiJG22i8G
 Ya24YTmfCQKVw8J7RVMbFS7QOLYgstBAxVflKJRtxOBJKbsWMs2c3RD6WxijeZUXsOTA
 k0aYjkpMBXtBcwytCiuXiX9UvwE4imWn/KbfC7lMdFNzMHklDMH/bAN/hYO5xQ3AAg4g
 2e2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3r/HSQlSMaGqGuO6qlyByqylj4w37aYh03CWLKihWyE=;
 b=sdvOgdyV3WY7b08XvJfJupHdqw29vsq2AX4VdxRrTaXV7yT9D/hayaythEEJFSXb+k
 HMC7xYG27Rdy+Epswa7Y1ZDfTLBB8AT8NBG3ygkxZtNYcLty6Y2xXDhaoEB9kJF74ttj
 lMYNDeaP04n47/RuPZT7eCG9BgrvWMrlLw9pH8K3yK74bsiXcDxPFlseCcII9UQ+qlyu
 uQHyywsPwdifJjJPjuNHtJz1VuB/uPwH19jPSUxMDgmD6sEueQkAquoxMdGndQNO0dYH
 mMy1bzqVoVh2WJIzt8IpigRsdY2Seqi5MMvE3AvteUuADiVE41B6iJBBAW/nNrwrbjSB
 S/Xg==
X-Gm-Message-State: AOAM532AXcAO3W5vyJCzksB188pCSE57A+PW4ea9O19qjAgNm7vL/1/E
 vcFlg10QKG1TzpGUFU5Cg0lEEigKbmRnqR8UVNDDk70phFUl7qlP/6iooBv2M0ajhyEu20zot8Z
 Ak4H5DLGRr37Xaw3kbzxVYhASSR3NBEUK5bVIR95TxGqpvmltmh9REyvMnM6qyZdP75HP6w==
X-Google-Smtp-Source: ABdhPJyC0nmrb9p3Fph5PiHQgzCf4XqAVV9qwdGI+BZkjpGMX0GXawApszVLVF40+DN93mTIiNXihq0S8Bg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:2146:: with SMTP id
 d6mr7996051ilv.45.1637701278015; Tue, 23 Nov 2021 13:01:18 -0800 (PST)
Date: Tue, 23 Nov 2021 21:01:05 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-3-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
