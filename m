Return-Path: <SRS0=gNwE=PR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27200C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A978D610F8
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A978D610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45C624B15C;
	Thu, 28 Oct 2021 20:32:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Evc9opFL-N03; Thu, 28 Oct 2021 20:32:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6754B19A;
	Thu, 28 Oct 2021 20:32:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4356E4B172
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z0fb84wYTcZQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 20:32:44 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6D3F4B160
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:43 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 r3-20020a056830236300b0054d43b72ba5so4348916oth.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 17:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8jHkcukOGs60Vh8sqIk5PEDCEkQaDcCSTeMEW1ZoThU=;
 b=JdhR5KgizbNUUTAjmlYRxJx0EtRpzClBjN8sNGCA4JJO4HHHb6OXPbkGWVWsexwurl
 kRU/OrYOvFTWusWVmdojV2LmmS3eksr37DnFEYydJYDaWiHjFtnAErqEYg97xPlTHxHn
 nLUvfSd9uIXXDeEqhI/d07olbwebG44JjMzSvnmAiFv9ny7vqeJmJcMZCzv9Txyee4A1
 AH50A4MUa8rJlxoiWXiA/FNFIrwGua22jIX3diDsCegQ2R353dFwc0iVF1Ubi2YZ4UDY
 m1tQpzc7VBbKbCWLZcVd52Qs91rPh+JGCvqvxhTGc6bQlM+BZoafUHzt0/wQE/NVWNBr
 1N3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8jHkcukOGs60Vh8sqIk5PEDCEkQaDcCSTeMEW1ZoThU=;
 b=temF4CuwD1wUIaPCRbU2PBc5gGdX8TVt3xEFKbHAU0lRV+vRc/4AdCB3JGYlFBaePw
 QRlLeh6zdWuPzVVu7Gp4xvWL1HtSdcfGLPsMkWdgTTnkLwdxznEMVdNamMY39EwXMGsQ
 +noabz9MBX+dTK09jTojCmQZUooBM/aywTWJo2VlZ4NIzCLZs3Y8Ef4/DOH1bFlK3kRL
 TssPccLNM0U/i7WI4xA2aGpnhwmNV7uRO7Bj9Ek9dISaypdcap0ACT32Fu3wfKUejrb8
 BznZ7QVDSFZFDSIKSJsETbhNSmmV6qBEihRbuqlWJOKTJsTdDd5cYQ3JlRq56DZCtCP6
 aTbQ==
X-Gm-Message-State: AOAM531m73bQsSbVBKPYrui8W4pdVb/4GOee7eN6jhq0mqvklqz79xaV
 z4/GYiU+JiS9j/CiORNf+Ee1jKBEIEUDE7RBEcrnBrCByBOGPqk2Ta8seQ+GiK5ls/dCSiQ1ujD
 w+ivYZeW/IX8wzarj14HSc20OcQSrQ0rb9O7Yxc0s0EDecUhSXfFgHlY4Z4UUTazRdrFhBw==
X-Google-Smtp-Source: ABdhPJyaxDFxxmg122WEeWbg/RrVAHJJLIJnz/MlGJ2fjJIs/pCIhzGPDOjoXFCCGLJwb76Yre8ULKN1ULY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:3e86:: with SMTP id
 l128mr11380539oia.120.1635467563254; 
 Thu, 28 Oct 2021 17:32:43 -0700 (PDT)
Date: Fri, 29 Oct 2021 00:32:01 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-3-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 2/3] KVM: arm64: Allow the guest to change the OS Lock status
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

KVM diverges from the architecture in the way it handles the OSLAR_EL1
register. While the architecture requires that the register be WO and
that the OSLK bit is 1 out of reset, KVM implements the register as
RAZ/WI.

Align KVM with the architecture by permitting writes to OSLAR_EL1. Since
the register is WO, stash the OS Lock status bit in OSLSR_EL1 and
context switch the status between host/guest. Additionally, change the
reset value of the OSLK bit to 1.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  5 +++++
 arch/arm64/kvm/sys_regs.c                  | 22 +++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index de7e14c862e6..a65dab34f85b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -65,6 +65,8 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
+
+	ctxt_sys_reg(ctxt, OSLSR_EL1)	= read_sysreg(oslsr_el1);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -149,6 +151,9 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
+
+	/* restore OSLSR_EL1 by writing the OSLK bit to OSLAR_EL1 */
+	write_sysreg((ctxt_sys_reg(ctxt, OSLSR_EL1) >> 1) & 1, oslar_el1);
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0eb03e7508fe..0840ae081290 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -298,6 +298,22 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 oslsr;
+
+	if (!p->is_write)
+		return read_zero(vcpu, p);
+
+	/* preserve all but the OSLK bit */
+	oslsr = vcpu_read_sys_reg(vcpu, OSLSR_EL1) & ~0x2ull;
+	vcpu_write_sys_reg(vcpu, OSLSR_EL1, oslsr | ((p->regval & 1) << 1));
+	return true;
+}
+
+
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 				   struct sys_reg_params *p,
 				   const struct sys_reg_desc *r)
@@ -1439,8 +1455,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008 },
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1912,7 +1928,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
