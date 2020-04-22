Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F138FC55185
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A62DE21582
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yy+sl3Uj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A62DE21582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8BE4B137;
	Wed, 22 Apr 2020 08:21:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S2gcfXPq6cle; Wed, 22 Apr 2020 08:21:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 636A94B1A6;
	Wed, 22 Apr 2020 08:21:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6714B170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bL1W6Lo-4aJc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:21:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 238F04B16D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5003A20784;
 Wed, 22 Apr 2020 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587558081;
 bh=ltfWEr7b6Col4KshTFdZvfSbsWR/3TVT6QbzpRPiUzE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Yy+sl3UjWx1mHaF+CeFdnisUG7BVXK8nXsghKr1cbpDMFHceG4IVvGoloTtyZ5pPv
 LYfz+kWvlpV+WsEFBBfmjFqeqSVO/DqsKZ5po6dccmUXZQbRfHmmmFHNc+z+q3VnHE
 R83zFZL8snwztJnQLoYFP1OlPLbIcJRGRLiQIe8Y=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE3u-005UI7-39; Wed, 22 Apr 2020 13:01:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 12/26] KVM: arm64: Move sysreg reset check to boot time
Date: Wed, 22 Apr 2020 13:00:36 +0100
Message-Id: <20200422120050.3693593-13-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

Our sysreg reset check has become a bit silly, as it only checks whether
a reset callback actually exists for a given sysreg entry, and apply the
method if available. Doing the check at each vcpu reset is pretty dumb,
as the tables never change. It is thus perfectly possible to do the same
checks at boot time.

This also allows us to introduce a sparse sys_regs[] array, something
that will be required with ARMv8.4-NV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 72 +++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9443960b36e4..5bda4af36a0e7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2094,12 +2094,37 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
 };
 
+static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
+			      bool is_32)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		if (!is_32 && table[i].reg && !table[i].reset) {
+			kvm_err("sys_reg table %p entry %d has lacks reset\n",
+				table, i);
+			return 1;
+		}
+
+		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
+			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /* Target specific emulation tables */
 static struct kvm_sys_reg_target_table *target_tables[KVM_ARM_NUM_TARGETS];
 
 void kvm_register_target_sys_reg_table(unsigned int target,
 				       struct kvm_sys_reg_target_table *table)
 {
+	if (check_sysreg_table(table->table64.table, table->table64.num, false) ||
+	    check_sysreg_table(table->table32.table, table->table32.num, true))
+		return;
+
 	target_tables[target] = table;
 }
 
@@ -2385,19 +2410,13 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 }
 
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-				const struct sys_reg_desc *table, size_t num,
-				unsigned long *bmap)
+				const struct sys_reg_desc *table, size_t num)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset) {
-			int reg = table[i].reg;
-
+		if (table[i].reset)
 			table[i].reset(vcpu, &table[i]);
-			if (reg > 0 && reg < NR_SYS_REGS)
-				set_bit(reg, bmap);
-		}
 }
 
 /**
@@ -2853,32 +2872,18 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
-static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n)
-{
-	unsigned int i;
-
-	for (i = 1; i < n; i++) {
-		if (cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
-			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
 	struct sys_reg_desc clidr;
 
 	/* Make sure tables are unique and in order. */
-	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs)));
-	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs)));
-	BUG_ON(check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs)));
-	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
-	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
-	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
+	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false));
+	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true));
+	BUG_ON(check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true));
+	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true));
+	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true));
+	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
@@ -2914,17 +2919,10 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct sys_reg_desc *table;
-	DECLARE_BITMAP(bmap, NR_SYS_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);
+	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num, bmap);
-
-	for (num = 1; num < NR_SYS_REGS; num++) {
-		if (WARN(!test_bit(num, bmap),
-			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
-			break;
-	}
+	reset_sys_reg_descs(vcpu, table, num);
 }
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
