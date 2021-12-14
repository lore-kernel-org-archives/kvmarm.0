Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1D9C4321E
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B01E4B217;
	Tue, 14 Dec 2021 12:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0TkaLz1p9fLM; Tue, 14 Dec 2021 12:28:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D914B21C;
	Tue, 14 Dec 2021 12:28:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63D74B1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6ibgtYkVUi1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:21 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E1A84B21A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:20 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 d27-20020a25addb000000b005c2355d9052so37641102ybe.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CnCGzCYE1Jp0ccvw5GdrZXd9S5GY17k/2+AkR8b+f3U=;
 b=JqmnUyDmZv8NDbsX+KT61C1HiK40r92cnQ71J8DegUkBMlbvIGpJMPfyMUzIX2mAMi
 ykbqhoJBy+Oo4r3Nmn3y/A5XleGTngiMdeti7+tyEjD4bSm3zFFb97VAnPtwhHAwDK3f
 Vu3YWkyYRlgJL+yRynYQ61lzU/KWvZ9T9r7PZc1tEUA3YU6azONq/QbY0EJe0Ny/qTgb
 x7x7vFzZeOdCarffSlvZUqkPxpwUx9/Pk0+4J8wtDBAttgKyUAhjqPrNnUCXBQWR+51h
 vsoQOCtcrXUGe/gS9FITd4EtmIJFWQnVmpq/w0Mp+pSDGNrLOd4e9fAswZv21dQqYtw7
 blHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CnCGzCYE1Jp0ccvw5GdrZXd9S5GY17k/2+AkR8b+f3U=;
 b=64clTFhBAGZffXSCI8vkRn0b6yw0ZMvjI6M3X9V1O42HVKzbUbToDdyISQOt5U+gGn
 Idj5Jjo/goPDVcqd8Lv85Stg3O0OnX3nRS+JOMdYqk3myi/UbIiJ28Us/3fc93IJ4SHY
 l4c1vyMelAQf0dIBvJ2UwPCzBT2im3we8qyWSbDf1sPV3IXxMeXoxZ6YJok51TfPk+kk
 KW14PPPGYIQQqcR9fUc09MQ+xWLN8UCLPerCK3h5nmWHzJR3KMn/nYtf2OG40L0wgW6G
 pMk/B35+HucpnUAiLMFMpZIg8T6okS234pe4ymjZdg3BVRqeWC+HBSKRpRn8hNazUbXD
 faZA==
X-Gm-Message-State: AOAM533MeVb878n9md0uRw1W3fdtkBz8tZ7jLf4HqXjPmdJnl5G6k65w
 tYGdkWN0dMvtMKmvdDwSS16vhzorO94miuoVqYZFPS8knLR2SG8Eo+GbmR10mo7m7FyCBjWkTA2
 8NYIEdrMMicONG9rGGwehpl1oHIMkqco1Co/y19UHBT83OtHSNy1R3nG4bGV3fmt9zsi3TA==
X-Google-Smtp-Source: ABdhPJzAsUEylnvZJCE0SInf4OnMrGWQsjC+orgNExLoeP/ikgqZwPBpXbNkG6p75hxZJfaLJ7xLmhDMFc0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:ecc:: with SMTP id
 a12mr345048ybs.347.1639502900086; 
 Tue, 14 Dec 2021 09:28:20 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:09 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-4-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 3/6] KVM: arm64: Allow guest to set the OSLK bit
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

Allow writes to OSLAR and forward the OSLK bit to OSLSR. Do nothing with
the value for now.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  9 ++++++++
 arch/arm64/kvm/sys_regs.c       | 39 ++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16b3f1a1d468..46f800bda045 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -129,7 +129,16 @@
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
+#define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
+#define SYS_OSLSR_OSLM			BIT(3)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7bf350b3d9cd..5188a74095e3 100644
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
@@ -309,9 +331,14 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if (err)
 		return err;
 
-	if (val != rd->val)
+	/*
+	 * The only modifiable bit is the OSLK bit. Refuse the write if
+	 * userspace attempts to change any other bit in the register.
+	 */
+	if ((val & ~SYS_OSLSR_OSLK) != SYS_OSLSR_OSLM)
 		return -EINVAL;
 
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
 	return 0;
 }
 
@@ -1180,10 +1207,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
-static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1463,8 +1486,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, SYS_OSLSR_OSLM,
 		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
@@ -1937,7 +1960,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
