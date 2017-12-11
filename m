From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 16/19] arm64: insn: Allow ADD/SUB (immediate) with LSL #12
Date: Mon, 11 Dec 2017 14:49:34 +0000
Message-ID: <20171211144937.4537-17-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E41A49DF7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7d5uxHwrt2Tc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:46:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D41E149DD3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:51 -0500 (EST)
In-Reply-To: <20171211144937.4537-1-marc.zyngier@arm.com>
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

The encoder for ADD/SUB (immediate) can only cope with 12bit
immediates, while there is an encoding for a 12bit immediate shifted
by 12 bits to the left.

Let's fix this small oversight by allowing the LSL_12 bit to be set.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/insn.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index af29fc3e09a9..b8fb2d89b3a6 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -35,6 +35,7 @@
 
 #define AARCH64_INSN_SF_BIT	BIT(31)
 #define AARCH64_INSN_N_BIT	BIT(22)
+#define AARCH64_INSN_LSL_12	BIT(22)
 
 static int aarch64_insn_encoding_class[] = {
 	AARCH64_INSN_CLS_UNKNOWN,
@@ -903,9 +904,18 @@ u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
 		return AARCH64_BREAK_FAULT;
 	}
 
+	/* We can't encode more than a 24bit value (12bit + 12bit shift) */
+	if (imm & ~(BIT(24) - 1))
+		goto out;
+
+	/* If we have something in the top 12 bits... */
 	if (imm & ~(SZ_4K - 1)) {
-		pr_err("%s: invalid immediate encoding %d\n", __func__, imm);
-		return AARCH64_BREAK_FAULT;
+		/* ... and in the low 12 bits -> error */
+		if (imm & (SZ_4K - 1))
+			goto out;
+
+		imm >>= 12;
+		insn |= AARCH64_INSN_LSL_12;
 	}
 
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, dst);
@@ -913,6 +923,10 @@ u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, src);
 
 	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_12, insn, imm);
+
+out:
+	pr_err("%s: invalid immediate encoding %d\n", __func__, imm);
+	return AARCH64_BREAK_FAULT;
 }
 
 u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,
-- 
2.14.2
