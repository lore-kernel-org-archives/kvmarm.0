Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D199C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E384B11A;
	Thu,  3 Feb 2022 12:42:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YXOICfEgp76c; Thu,  3 Feb 2022 12:42:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9184B139;
	Thu,  3 Feb 2022 12:42:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8864B129
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cSfwXYKE4Ndn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:05 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90DD84B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:05 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 i28-20020a056e021d1c00b002bdb4d7a848so652926ila.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eNO0KOJWga9XORILDX/6xRydNTZFNjDRV4Q2RutcMDE=;
 b=GBv1qQNEjxsI0j7Wx8ZWFo2Xf9aA/iwwbdY4D2ib9NMc5RAyaEI9xPszBHc6PgzJqp
 e89C+vu8i0F1WihIzj64EqPHI91Yl9RWma4jftvX9hpYd3X0d3vsINZyjzavb/31i4Y4
 tU0xthBX8swm8n22k5vrparcbSuj14DCfjU1+IE5P4dyv/ajs/q91caTVB0ubh23/+z0
 bPz4j1lD1lQSybPZDQyXCTwn4AvlXJlfNXWnz9a6Q0BylSt3q0DPGJS70uAZHGcVUV+7
 ppxLCN1QaWZ1mFkt5u2uGJLfQ9zg/kdVkF4MhTABNmsTPRLNo8bxOrMjK42JXjsuGDtc
 HK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eNO0KOJWga9XORILDX/6xRydNTZFNjDRV4Q2RutcMDE=;
 b=hTKXPvFUh80SHIkEIBWNVgaqNO9FLmcTCh3CJlq6lkYLrBZizvnFIBOw0jh4YGG+dC
 w0Oem5SH/y/KwUP9lS0oQw/nr35O38Y8v5b07HeqOhWBG7ybWu0l6zpfeszpoABLUebt
 6xt/xX3d0Z/2InSz4p3HQLbZ+JFilNy48lrybxIB3r/j4Z9rNTtdx3p/WlizcGS1HCzC
 PZTclsjOQTlmVuyFs+hW6ZFxTw84lQzxiYgIDs4KRQfDeyALe4ira0KGBpDa1pTLhUFj
 PpzOfuD7feVtOxbeD+SUEUT4Dx3IUyE6xdz2fv8/QNAvh3jXlMpP7m/ibB+qCzFqGC/x
 cYTw==
X-Gm-Message-State: AOAM533xOaWjGHUnMy0tE8U6ppTLLXx0moY2uBnbaBOc7Exf36+v4mB+
 d6Vfb+b30vLsTFATNFWeSzwNGePveMaY8dRosi/+L49afZmSz1lt9Z+bjUKOLZTKXQIkcxaMPHM
 de/R1hKJC2kigFSurARXa0vIMvNbP/1gKnwYa7K6YfyEnrdgOZF4U7JPVNNlQgScfIX5bJw==
X-Google-Smtp-Source: ABdhPJzBadVawvG3pIMPz85Q8F2QVyG0XJIbz1c+pZ3R9l8pHkHxELFQ925oh8/bg6lkUKCHM5LsTt5xPbw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:188c:: with SMTP id
 o12mr11609950ilu.44.1643910124940; Thu, 03 Feb 2022 09:42:04 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:55 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-3-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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

An upcoming change to KVM will emulate the OS Lock from the PoV of the
guest. Add OSLSR_EL1 to the cpu context and handle reads using the
stored value. Define some mnemonics for for handling the OSLM field and
use them to make the reset value of OSLSR_EL1 more readable.

Wire up a custom handler for writes from userspace and prevent any of
the invariant bits from changing. Note that the OSLK bit is not
invariant and will be made writable by the aforementioned change.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/sysreg.h   |  5 +++++
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..cc1cc40d89f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -171,6 +171,7 @@ enum vcpu_sysreg {
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+	OSLSR_EL1,	/* OS Lock Status Register */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
 	/* Performance Monitors Registers */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 898bee0004ae..abc85eaa453d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -129,7 +129,12 @@
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+#define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
+#define SYS_OSLSR_OSLM_NI		0
+#define SYS_OSLSR_OSLM_IMPLEMENTED	BIT(3)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85208acd273d..b8286c31e01c 100644
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
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1,
+		SYS_OSLSR_OSLM_IMPLEMENTED, .set_user = set_oslsr_el1, },
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
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
