Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0994C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A33560C41
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6A33560C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A2644B15B;
	Tue,  2 Nov 2021 05:47:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nmCHHbahP06t; Tue,  2 Nov 2021 05:47:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 835234B1A9;
	Tue,  2 Nov 2021 05:47:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2D084B190
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SdY-tPO8csOK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:47:04 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62CCC4B154
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:03 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 g4-20020a05660226c400b005e14d3f1e6bso13548949ioo.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LW62NaqnzOIPyMSkIbkMT7S/DeS5QsuklZa8PoVQ7Ts=;
 b=R/UakULhkBCZbgzgewMj4LYGsljk3XONwmfkNrEjAIjteagmlKOo4UF2SA7WdVeTSl
 0Ny1s3tjQ10f2WBLLhD1ataKqHZkMAkCOZMUssW6Opwyk1jMZvw5R19QIAoNJjuKNnKw
 42oDFamwIXC/r7dOUEcdglXAseWkrKE16BTwsnnM1Vsrp38xTrwIhKXo+On/29TCtH0o
 lrpyIewcC3C3OAYPDk8xI5TzCTVHl6pdHu/t+g+3OzK5/F/+vSUZNK0voHyXiQEGY0P3
 0EdJPxNWVIvmk8u9BQbWpnEskUwkfrRXvhZ6QBOQJJDNsJYcxZ6Vw3i65S12CDqx+hta
 9QKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LW62NaqnzOIPyMSkIbkMT7S/DeS5QsuklZa8PoVQ7Ts=;
 b=cKOKAxy6GD3KBU3MC2FwRLfvjPcsvFbpozN3E6MWqQ92g2j5AB4h2RDb8py60bhgj9
 riZPven7u5Yxuw306z3hz1fBM2jEQ/tbjAeTvMYfM12zNEElnFLWCDEFfYK9Q1RmFmTR
 7U14Zq8Vfulh3/5CoUxEY0jUgApxvrOjQdkGM6MDOghcKaSxU7haULrkBw4dP4OY2MB4
 Nsls1q0XJB2/w3TRWT7z/vttZOYAM9PasI9I+1R9t2RuAAbV31sUMSj91ROkLAdzgwaz
 c9W3u/O0GFVA7M4eDJsjB5pRpL4nvrQJZlrNZccsjw0XsHdWuY8l49YfAgMkJcy+JEBD
 Sw1Q==
X-Gm-Message-State: AOAM5337AYrlrXoA/PWqb7he4sZm8A4SaBHDUNme1BqKZkPpvoDyHh93
 LTbGh6wuU5Xe2gccuK/wmmzwX7CQsSeuoWG+WHOIP1Ab5y359HTRdgANaE7Jt3I3QHcKkOajefa
 2OePWQGcagDddcwk8PYwAilIYuxUvr3zeysIpRaR2WIczVZhkmm1DvofF3yvGoQVTrPvMbQ==
X-Google-Smtp-Source: ABdhPJyAAd3EZ7PG9zgAtlS9xNQ7IEiF/KnBkc8peoyeSw7zPj/Pr+fPOvN0382WKxo0+yGxzbd0/Ii9uzE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:650f:: with SMTP id
 z15mr19435494iob.27.1635846422770; 
 Tue, 02 Nov 2021 02:47:02 -0700 (PDT)
Date: Tue,  2 Nov 2021 09:46:48 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-4-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 3/6] KVM: arm64: Allow guest to set the OSLK bit
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

Allow writes to OSLAR and forward the OSLK bit to OSLSR. Change the
reset value of the OSLK bit to 1. Allow the value to be migrated by
making OSLSR_EL1.OSLK writable from userspace.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..6ba4dc97b69d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -127,7 +127,13 @@
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
+#define SYS_OSLAR_OSLK			BIT(0)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+
+#define SYS_OSLSR_OSLK			BIT(1)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0326b3df0736..acd8aa2e5a44 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,6 +44,10 @@
  * 64bit interface.
  */
 
+static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
+static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
+static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
+
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 	return trap_raz_wi(vcpu, p, r);
 }
 
+static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 oslsr;
+
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p, r);
+
+	/* Forward the OSLK bit to OSLSR */
+	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
+	if (p->regval & SYS_OSLAR_OSLK)
+		oslsr |= SYS_OSLSR_OSLK;
+
+	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
+	return true;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if (err)
 		return err;
 
-	if (val != rd->val)
+	if ((val | SYS_OSLSR_OSLK) != rd->val)
 		return -EINVAL;
 
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
 	return 0;
 }
 
@@ -1176,10 +1199,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
-static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1456,8 +1475,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A,
 		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
@@ -1930,7 +1949,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
