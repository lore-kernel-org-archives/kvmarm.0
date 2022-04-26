Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B3AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 09:34:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7114B16F;
	Tue, 26 Apr 2022 05:34:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hZpLI1uR1Yzp; Tue, 26 Apr 2022 05:34:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A734B1A9;
	Tue, 26 Apr 2022 05:34:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4FB04B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:34:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-be04wjkfaT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 05:34:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 616BC49EE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:34:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6F5123A;
 Tue, 26 Apr 2022 02:34:53 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1E843F73B;
 Tue, 26 Apr 2022 02:34:52 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH RESEND 2/2] KVM/arm64: Print emulated register table name when
 it is unsorted
Date: Tue, 26 Apr 2022 10:34:39 +0100
Message-Id: <20220426093439.12159-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426093439.12159-1-alexandru.elisei@arm.com>
References: <20220426093439.12159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

When a sysreg table entry is out-of-order, KVM attempts to print the
address of the table:

[    0.143881] kvm [1]: sys_reg table (____ptrval____) out of order (0)

Printing the name of the table instead of a pointer is more helpful in this
case:

[    0.143881] kvm [1]: sys_reg table sys_reg_descs out of order (0)

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 57302048afd0..7b62a2daf056 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2188,18 +2188,18 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 };
 
 static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
-			       bool is_32)
+			       const char *table_name, bool is_32)
 {
 	unsigned int i;
 
 	for (i = 0; i < n; i++) {
 		if (!is_32 && table[i].reg && !table[i].reset) {
-			kvm_err("sys_reg table %p entry %d lacks reset\n", table, i);
+			kvm_err("sys_reg table %s entry %d lacks reset\n", table_name, i);
 			return false;
 		}
 
 		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
-			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
+			kvm_err("sys_reg table %s out of order (%d)\n", table_name, i - 1);
 			return false;
 		}
 	}
@@ -2866,12 +2866,14 @@ int kvm_sys_reg_table_init(void)
 	struct sys_reg_desc clidr;
 
 	/* Make sure tables are unique and in order. */
-	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
-	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
-	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
-	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
-	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
-	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
+	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs),
+				    "sys_reg_descs", false);
+	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), "cp14_regs", true);
+	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), "cp14_64_regs", true);
+	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), "cp15_regs", true);
+	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), "cp15_64_regs", true);
+	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs),
+				    "invariant_sys_regs", false);
 
 	if (!valid)
 		return -EINVAL;
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
