From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 67/85] arm64: insn: Allow ADD/SUB (immediate) with LSL #12
Date: Wed, 28 Mar 2018 13:52:36 +0100
Message-ID: <20180328125254.31380-68-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221A84A0C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:59:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gmn1vHVR8ld8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:58:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4CB4A03B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:33 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The encoder for ADD/SUB (immediate) can only cope with 12bit
immediates, while there is an encoding for a 12bit immediate shifted
by 12 bits to the left.

Let's fix this small oversight by allowing the LSL_12 bit to be set.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/insn.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 2929adaad587..816d03c4c913 100644
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
