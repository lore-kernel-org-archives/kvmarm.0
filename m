From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 1/5] arm64: insn: Add aarch64_insn_decode_immediate
Date: Thu, 26 Mar 2015 22:48:24 +0000
Message-ID: <1427410108-16253-2-git-send-email-marc.zyngier@arm.com>
References: <1427410108-16253-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 676B449DE4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 18:41:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IRHbLp1MAvsn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 18:41:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FABF49DDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 18:41:49 -0400 (EDT)
In-Reply-To: <1427410108-16253-1-git-send-email-marc.zyngier@arm.com>
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

Patching an instruction sometimes requires extracting the immediate
field from this instruction. To facilitate this, and avoid
potential duplication of code, add aarch64_insn_decode_immediate
as the reciprocal to aarch64_insn_encode_immediate.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/insn.h |  1 +
 arch/arm64/kernel/insn.c      | 81 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index d2f4942..f81b328 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -285,6 +285,7 @@ bool aarch64_insn_is_nop(u32 insn);
 int aarch64_insn_read(void *addr, u32 *insnp);
 int aarch64_insn_write(void *addr, u32 insn);
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
+u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
 u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index c8eca88..9249020 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -265,23 +265,13 @@ int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
 	return aarch64_insn_patch_text_sync(addrs, insns, cnt);
 }
 
-u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
-				  u32 insn, u64 imm)
+static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
+						u32 *maskp, int *shiftp)
 {
-	u32 immlo, immhi, lomask, himask, mask;
+	u32 mask;
 	int shift;
 
 	switch (type) {
-	case AARCH64_INSN_IMM_ADR:
-		lomask = 0x3;
-		himask = 0x7ffff;
-		immlo = imm & lomask;
-		imm >>= 2;
-		immhi = imm & himask;
-		imm = (immlo << 24) | (immhi);
-		mask = (lomask << 24) | (himask);
-		shift = 5;
-		break;
 	case AARCH64_INSN_IMM_26:
 		mask = BIT(26) - 1;
 		shift = 0;
@@ -320,9 +310,68 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 		shift = 16;
 		break;
 	default:
-		pr_err("aarch64_insn_encode_immediate: unknown immediate encoding %d\n",
-			type);
-		return 0;
+		return -EINVAL;
+	}
+
+	*maskp = mask;
+	*shiftp = shift;
+
+	return 0;
+}
+
+#define ADR_IMM_HILOSPLIT	2
+#define ADR_IMM_SIZE		SZ_2M
+#define ADR_IMM_LOMASK		((1 << ADR_IMM_HILOSPLIT) - 1)
+#define ADR_IMM_HIMASK		((ADR_IMM_SIZE >> ADR_IMM_HILOSPLIT) - 1)
+#define ADR_IMM_LOSHIFT		29
+#define ADR_IMM_HISHIFT		5
+
+u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
+{
+	u32 immlo, immhi, mask;
+	int shift;
+
+	switch (type) {
+	case AARCH64_INSN_IMM_ADR:
+		shift = 0;
+		immlo = (insn >> ADR_IMM_LOSHIFT) & ADR_IMM_LOMASK;
+		immhi = (insn >> ADR_IMM_HISHIFT) & ADR_IMM_HIMASK;
+		insn = (immhi << ADR_IMM_HILOSPLIT) | immlo;
+		mask = ADR_IMM_SIZE - 1;
+		break;
+	default:
+		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
+			pr_err("aarch64_insn_decode_immediate: unknown immediate encoding %d\n",
+			       type);
+			return 0;
+		}
+	}
+
+	return (insn >> shift) & mask;
+}
+
+u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
+				  u32 insn, u64 imm)
+{
+	u32 immlo, immhi, mask;
+	int shift;
+
+	switch (type) {
+	case AARCH64_INSN_IMM_ADR:
+		shift = 0;
+		immlo = (imm & ADR_IMM_LOMASK) << ADR_IMM_LOSHIFT;
+		imm >>= ADR_IMM_HILOSPLIT;
+		immhi = (imm & ADR_IMM_HIMASK) << ADR_IMM_HISHIFT;
+		imm = immlo | immhi;
+		mask = ((ADR_IMM_LOMASK << ADR_IMM_LOSHIFT) |
+			(ADR_IMM_HIMASK << ADR_IMM_HISHIFT));
+		break;
+	default:
+		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
+			pr_err("aarch64_insn_encode_immediate: unknown immediate encoding %d\n",
+			       type);
+			return 0;
+		}
 	}
 
 	/* Update the immediate field. */
-- 
2.1.4
