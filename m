From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/5] arm64: alternative: Allow immediate branch as alternative
 instruction
Date: Thu, 19 Mar 2015 13:59:33 +0000
Message-ID: <1426773576-14062-3-git-send-email-marc.zyngier@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2038249276
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qDZKqHSeXajt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 09:53:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A2F49275
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:09 -0400 (EDT)
In-Reply-To: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <dave.martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since all immediate branches are PC-relative on Aarch64, these
instructions cannot be used as an alternative with the simplistic
approach we currently have (the immediate has been computed from
the .altinstr_replacement section, and end-up being completely off
if we insert it directly).

This patch handles the b and bl instructions in a different way,
using the insn framework to recompute the immediate, and generate
the right displacement.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/alternative.c | 55 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index ad7821d..ac13c58 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -24,6 +24,7 @@
 #include <asm/cacheflush.h>
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
+#include <asm/insn.h>
 #include <linux/stop_machine.h>
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
@@ -33,6 +34,48 @@ struct alt_region {
 	struct alt_instr *end;
 };
 
+/*
+ * Decode the imm field of a b/bl instruction, and return the byte
+ * offset as a signed value (so it can be used when computing a new
+ * branch target).
+ */
+static s32 get_branch_offset(u32 insn)
+{
+	s32 imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
+
+	/* sign-extend the immediate before turning it into a byte offset */
+	return (imm << 6) >> 4;
+}
+
+static u32 get_alt_insn(u8 *insnptr, u8 *altinsnptr)
+{
+	u32 insn;
+
+	aarch64_insn_read(altinsnptr, &insn);
+
+	/* Stop the world on instructions we don't support... */
+	BUG_ON(aarch64_insn_is_cbz(insn));
+	BUG_ON(aarch64_insn_is_cbnz(insn));
+	BUG_ON(aarch64_insn_is_bcond(insn));
+	/* ... and there is probably more. */
+
+	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn)) {
+		enum aarch64_insn_branch_type type;
+		unsigned long target;
+
+		if (aarch64_insn_is_b(insn))
+			type = AARCH64_INSN_BRANCH_NOLINK;
+		else
+			type = AARCH64_INSN_BRANCH_LINK;
+
+		target = (unsigned long)altinsnptr + get_branch_offset(insn);
+		insn = aarch64_insn_gen_branch_imm((unsigned long)insnptr,
+						   target, type);
+	}
+
+	return insn;
+}
+
 static int __apply_alternatives(void *alt_region)
 {
 	struct alt_instr *alt;
@@ -40,16 +83,24 @@ static int __apply_alternatives(void *alt_region)
 	u8 *origptr, *replptr;
 
 	for (alt = region->begin; alt < region->end; alt++) {
+		u32 insn;
+		int i;
+
 		if (!cpus_have_cap(alt->cpufeature))
 			continue;
 
-		BUG_ON(alt->alt_len > alt->orig_len);
+		BUG_ON(alt->alt_len != alt->orig_len);
 
 		pr_info_once("patching kernel code\n");
 
 		origptr = (u8 *)&alt->orig_offset + alt->orig_offset;
 		replptr = (u8 *)&alt->alt_offset + alt->alt_offset;
-		memcpy(origptr, replptr, alt->alt_len);
+
+		for (i = 0; i < alt->alt_len; i += sizeof(insn)) {
+			insn = get_alt_insn(origptr + i, replptr + i);
+			*(u32 *)(origptr + i) = insn;
+		}
+
 		flush_icache_range((uintptr_t)origptr,
 				   (uintptr_t)(origptr + alt->alt_len));
 	}
-- 
2.1.4
