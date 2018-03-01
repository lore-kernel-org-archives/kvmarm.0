From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 11/23] arm64; insn: Add encoder for the EXTR instruction
Date: Thu,  1 Mar 2018 15:55:26 +0000
Message-ID: <20180301155538.26860-12-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DE34069D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wbRarRZj8iUJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:49:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B388D49E47
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:09 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add an encoder for the EXTR instruction, which also implements the ROR
variant (where Rn == Rm).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/insn.h |  6 ++++++
 arch/arm64/kernel/insn.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 815b35bc53ed..f62c56b1793f 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -319,6 +319,7 @@ __AARCH64_INSN_FUNCS(and_imm,	0x7F800000, 0x12000000)
 __AARCH64_INSN_FUNCS(orr_imm,	0x7F800000, 0x32000000)
 __AARCH64_INSN_FUNCS(eor_imm,	0x7F800000, 0x52000000)
 __AARCH64_INSN_FUNCS(ands_imm,	0x7F800000, 0x72000000)
+__AARCH64_INSN_FUNCS(extr,	0x7FA00000, 0x13800000)
 __AARCH64_INSN_FUNCS(b,		0xFC000000, 0x14000000)
 __AARCH64_INSN_FUNCS(bl,	0xFC000000, 0x94000000)
 __AARCH64_INSN_FUNCS(cbz,	0x7F000000, 0x34000000)
@@ -433,6 +434,11 @@ u32 aarch64_insn_gen_logical_immediate(enum aarch64_insn_logic_type type,
 				       enum aarch64_insn_register Rn,
 				       enum aarch64_insn_register Rd,
 				       u64 imm);
+u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
+			  enum aarch64_insn_register Rm,
+			  enum aarch64_insn_register Rn,
+			  enum aarch64_insn_register Rd,
+			  u8 lsb);
 u32 aarch64_insn_gen_prefetch(enum aarch64_insn_register base,
 			      enum aarch64_insn_prfm_type type,
 			      enum aarch64_insn_prfm_target target,
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 72cb1721c63f..59669d7d4383 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1621,3 +1621,35 @@ u32 aarch64_insn_gen_logical_immediate(enum aarch64_insn_logic_type type,
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
 	return aarch64_encode_immediate(imm, variant, insn);
 }
+
+u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
+			  enum aarch64_insn_register Rm,
+			  enum aarch64_insn_register Rn,
+			  enum aarch64_insn_register Rd,
+			  u8 lsb)
+{
+	u32 insn;
+
+	insn = aarch64_insn_get_extr_value();
+
+	switch (variant) {
+	case AARCH64_INSN_VARIANT_32BIT:
+		if (lsb > 31)
+			return AARCH64_BREAK_FAULT;
+		break;
+	case AARCH64_INSN_VARIANT_64BIT:
+		if (lsb > 63)
+			return AARCH64_BREAK_FAULT;
+		insn |= AARCH64_INSN_SF_BIT;
+		insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_N, insn, 1);
+		break;
+	default:
+		pr_err("%s: unknown variant encoding %d\n", __func__, variant);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_S, insn, lsb);
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, Rd);
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
+	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RM, insn, Rm);
+}
-- 
2.14.2
