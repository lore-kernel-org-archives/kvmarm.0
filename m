Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E85C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:20:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4525C4C418;
	Thu, 14 Jul 2022 11:20:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 36na-MnO7yue; Thu, 14 Jul 2022 11:20:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3344C5EF;
	Thu, 14 Jul 2022 11:20:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 385A54C5BC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j1aPSXrdvep3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:20:38 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04B254C543
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:34 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 47EF1CE288E;
 Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC292C341CE;
 Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812030;
 bh=EZIbFZxkgQ+LV9Ht7OcrMwgab7G8/qq0lLC9OFEhEcg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VUXANxU1nm5F5RWgolaGSwq4rnuuzHIAZl/5q7q/QMnY5hvgGQowkcKIYNGUd3crI
 japnqsu//NrFQPx1Lpgk6URJZpwXt1n7AyJc3zjWaN0Het2u8VPcu0JGbPolaC5RZ9
 +DO3gr1sksBu5zMXzcv1PLNSKkYJsRd1rMCe28tJVgKVCBeGNrLxmSJdV9u3Hz3K2i
 kb4Xmu6j/pCm06KlDpg00nfBmP1qCBRTNpGDdttcTVeety+OooRVymp/AubXTpMbVI
 4IPAyVumiUzykcozP/pIgdkjfl7sfU5UfAtJoeRAX+3r+KCPI8X0z/wsK7iBsHDW1v
 G7ijw79HzzojA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dg-007UVL-Vg;
 Thu, 14 Jul 2022 16:20:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 06/20] KVM: arm64: Get rid of reg_from/to_user()
Date: Thu, 14 Jul 2022 16:20:10 +0100
Message-Id: <20220714152024.1673368-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

These helpers are only used by the invariant stuff now, and while
they pretend to support non-64bit registers, this only serves as
a way to scare the casual reviewer...

Replace these helpers with our good friends get/put_user(), and
don't look back.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 526798524697..379478eecfaa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,8 +44,6 @@
  * 64bit interface.
  */
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -2657,21 +2655,7 @@ static struct sys_reg_desc invariant_sys_regs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
-{
-	if (copy_from_user(val, uaddr, KVM_REG_SIZE(id)) != 0)
-		return -EFAULT;
-	return 0;
-}
-
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
-{
-	if (copy_to_user(uaddr, val, KVM_REG_SIZE(id)) != 0)
-		return -EFAULT;
-	return 0;
-}
-
-static int get_invariant_sys_reg(u64 id, void __user *uaddr)
+static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
 {
 	const struct sys_reg_desc *r;
 
@@ -2680,23 +2664,21 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 	if (!r)
 		return -ENOENT;
 
-	return reg_to_user(uaddr, &r->val, id);
+	return put_user(r->val, uaddr);
 }
 
-static int set_invariant_sys_reg(u64 id, void __user *uaddr)
+static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
 {
 	const struct sys_reg_desc *r;
-	int err;
-	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
+	u64 val;
 
 	r = get_reg_by_id(id, invariant_sys_regs,
 			  ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
+	if (get_user(val, uaddr))
+		return -EFAULT;
 
 	/* This is what we mean by invariant: you can't change it. */
 	if (r->val != val)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
