Return-Path: <SRS0=4dlz=WB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603EFC0650F
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 12:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F70A2086D
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 12:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F70A2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BADCB4A53B;
	Mon,  5 Aug 2019 08:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fVuWqetT9zJn; Mon,  5 Aug 2019 08:16:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5B04A53D;
	Mon,  5 Aug 2019 08:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A7A4A4E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 08:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZPTppG7Vn9x for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Aug 2019 08:16:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D0A4A540
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 08:16:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D94B21597;
 Mon,  5 Aug 2019 05:16:19 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC6473F77D;
 Mon,  5 Aug 2019 05:16:18 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] KVM: arm: Don't write junk to CP15 registers on reset
Date: Mon,  5 Aug 2019 13:15:55 +0100
Message-Id: <20190805121555.130897-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805121555.130897-1-maz@kernel.org>
References: <20190805121555.130897-1-maz@kernel.org>
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

At the moment, the way we reset CP15 registers is mildly insane:
We write junk to them, call the reset functions, and then check that
we have something else in them.

The "fun" thing is that this can happen while the guest is running
(PSCI, for example). If anything in KVM has to evaluate the state
of a CP15 register while junk is in there, bad thing may happen.

Let's stop doing that. Instead, we track that we have called a
reset function for that register, and assume that the reset
function has done something.

In the end, the very need of this reset check is pretty dubious,
as it doesn't check everything (a lot of the CP15 reg leave outside
of the cp15_regs[] array). It may well be axed in the near future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/kvm/coproc.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index d2806bcff8bb..07745ee022a1 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -651,13 +651,22 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 static void reset_coproc_regs(struct kvm_vcpu *vcpu,
-			      const struct coproc_reg *table, size_t num)
+			      const struct coproc_reg *table, size_t num,
+			      unsigned long *bmap)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset)
+		if (table[i].reset) {
+			int reg = table[i].reg;
+
 			table[i].reset(vcpu, &table[i]);
+			if (reg > 0 && reg < NR_CP15_REGS) {
+				set_bit(reg, bmap);
+				if (table[i].is_64bit)
+					set_bit(reg + 1, bmap);
+			}
+		}
 }
 
 static struct coproc_params decode_32bit_hsr(struct kvm_vcpu *vcpu)
@@ -1432,17 +1441,15 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct coproc_reg *table;
-
-	/* Catch someone adding a register without putting in reset entry. */
-	memset(vcpu->arch.ctxt.cp15, 0x42, sizeof(vcpu->arch.ctxt.cp15));
+	DECLARE_BITMAP(bmap, NR_CP15_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_coproc_regs(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
+	reset_coproc_regs(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs), bmap);
 
 	table = get_target_table(vcpu->arch.target, &num);
-	reset_coproc_regs(vcpu, table, num);
+	reset_coproc_regs(vcpu, table, num, bmap);
 
 	for (num = 1; num < NR_CP15_REGS; num++)
-		WARN(vcpu_cp15(vcpu, num) == 0x42424242,
+		WARN(!test_bit(num, bmap),
 		     "Didn't reset vcpu_cp15(vcpu, %zi)", num);
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
