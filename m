Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC2FC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 10:34:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A4E49F5B;
	Thu, 28 Apr 2022 06:34:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rOhPgGHPldhI; Thu, 28 Apr 2022 06:34:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EAC7400CF;
	Thu, 28 Apr 2022 06:34:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C744B28F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 06:34:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U+DEF-os79fu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 06:34:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2434B230
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 06:34:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FF3D1474;
 Thu, 28 Apr 2022 03:34:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D8E13F774;
 Thu, 28 Apr 2022 03:34:22 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/2] KVM/arm64: Print emulated register table name when it
 is unsorted
Date: Thu, 28 Apr 2022 11:34:05 +0100
Message-Id: <20220428103405.70884-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428103405.70884-1-alexandru.elisei@arm.com>
References: <20220428103405.70884-1-alexandru.elisei@arm.com>
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

[    0.143911] kvm [1]: sys_reg table (____ptrval____) out of order (1)

Printing the name of the table instead of a pointer is more helpful in this
case. The message has also been slightly tweaked to be point out the
offending entry (and to match the missing reset error message):

[    0.143891] kvm [1]: sys_reg table sys_reg_descs+0x50/0x7490 entry 1 out of order

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 57302048afd0..a84a556eeb8f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2194,12 +2194,12 @@ static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 
 	for (i = 0; i < n; i++) {
 		if (!is_32 && table[i].reg && !table[i].reset) {
-			kvm_err("sys_reg table %p entry %d lacks reset\n", table, i);
+			kvm_err("sys_reg table %pS entry %d lacks reset\n", &table[i], i);
 			return false;
 		}
 
 		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
-			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
+			kvm_err("sys_reg table %pS entry %d out of order\n", &table[i - 1], i - 1);
 			return false;
 		}
 	}
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
