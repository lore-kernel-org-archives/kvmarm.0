Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21E9C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:55:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 883304B200;
	Fri,  8 Apr 2022 07:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7qCnu8n1Dosz; Fri,  8 Apr 2022 07:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 600C04B0C5;
	Fri,  8 Apr 2022 07:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 131894B139
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6LnzSxlKwc0S for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:55:41 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEDD94B150
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 506DD62062;
 Fri,  8 Apr 2022 11:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2452BC385B3;
 Fri,  8 Apr 2022 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418939;
 bh=qKDOMK2ID+zmqv53Rpn11UftbZJdFvdso5J8RTIVUVE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oPAl7zQ45jEZd58PPzcyQcpuAL9b39Ez7O6q5En9coJ0kYp9f9jv5wMLLDikoWzui
 IDdkN4henXworg0e5IMnaF6EFv/Qs3WBOYW7oZQi6vLwJ/3PCduJsjNN4rIB5wRdkl
 MeHipZxSMiiupducY1IMCaBk1JqSKXAw9vJFtR4Lf+ijSb5xsVPynx6GIbavUB6i8f
 eIraK9S68DqbKrXDuRF193TRekLmvwWGBQVDtP4GWj8XjXW7G39JDnrdogorW0E7l5
 fk5D7XIatbBHEHV4Y9H3VbXmm5iHiWWm8YjI/G1z6p5dQVMZDd2cWpqEZITnFb9yc0
 ntzdcIHy7YgnA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 06/39] arm64/sme: Manually encode SME instructions
Date: Fri,  8 Apr 2022 12:42:55 +0100
Message-Id: <20220408114328.1401034-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3826; h=from:subject;
 bh=qKDOMK2ID+zmqv53Rpn11UftbZJdFvdso5J8RTIVUVE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/EOWqaNfh5ImR3063vdeoZEMMpcF8hy6OxTVEy
 +oaR6/+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfxAAKCRAk1otyXVSH0IBmB/
 0b5p+VCokGWVhHk3GGTOWgt7Lq/il+sqiVCpZvX3hiSFiUkmzCGn4JcB/IVOdunvbJeISJ2+yOYVGv
 Heos5saNwBYbsG7EiozgMYmlNtCt/wesUJdxOZCMFurv7DXnOwyr0SQ6qrxIoM83Fk0W0o/+PGtCYk
 f2nU4OgvTxhyCm5UTQ+yGh4zuowfMEbjQwhTRaoeKlTTC15xIky9Wy9FfxexQOITHmHcXaqWPyxN/8
 EadU9uFIG9bYRBQ1AKwyhC9qElwVQ3GceKrG2Pi8le0Du4zDl1qqnNMgX7LwARYLxTRAo14wc8rcHx
 BBFhjIAwJm1Z+LdPNSgiPgs3lbONGF
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

As with SVE rather than impose ambitious toolchain requirements for SME
we manually encode the few instructions which we require in order to
perform the work the kernel needs to do. The instructions used to save
and restore context are provided as assembler macros while those for
entering and leaving streaming mode are done in asm volatile blocks
since they are expected to be used from C.

We could do the SMSTART and SMSTOP operations with read/modify/write
cycles on SVCR but using the aliases provided for individual field
accesses should be slightly faster. These instructions are aliases for
MSR but since our minimum toolchain requirements are old enough to mean
that we can't use the sX_X_cX_cX_X form and they always use xzr rather
than taking a value like write_sysreg_s() wants we just use .inst.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/fpsimd.h       | 25 +++++++++++++
 arch/arm64/include/asm/fpsimdmacros.h | 54 +++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index cb24385e3632..6e2dc9dcbf49 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -249,6 +249,31 @@ static inline void sve_setup(void) { }
 
 #endif /* ! CONFIG_ARM64_SVE */
 
+#ifdef CONFIG_ARM64_SME
+
+static inline void sme_smstart_sm(void)
+{
+	asm volatile(__msr_s(SYS_SVCR_SMSTART_SM_EL0, "xzr"));
+}
+
+static inline void sme_smstop_sm(void)
+{
+	asm volatile(__msr_s(SYS_SVCR_SMSTOP_SM_EL0, "xzr"));
+}
+
+static inline void sme_smstop(void)
+{
+	asm volatile(__msr_s(SYS_SVCR_SMSTOP_SMZA_EL0, "xzr"));
+}
+
+#else
+
+static inline void sme_smstart_sm(void) { }
+static inline void sme_smstop_sm(void) { }
+static inline void sme_smstop(void) { }
+
+#endif /* ! CONFIG_ARM64_SME */
+
 /* For use by EFI runtime services calls only */
 extern void __efi_fpsimd_begin(void);
 extern void __efi_fpsimd_end(void);
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index 2509d7dde55a..2e9a33155081 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -93,6 +93,12 @@
 	.endif
 .endm
 
+.macro _sme_check_wv v
+	.if (\v) < 12 || (\v) > 15
+		.error "Bad vector select register \v."
+	.endif
+.endm
+
 /* SVE instruction encodings for non-SVE-capable assemblers */
 /* (pre binutils 2.28, all kernel capable clang versions support SVE) */
 
@@ -174,6 +180,54 @@
 		| (\np)
 .endm
 
+/* SME instruction encodings for non-SME-capable assemblers */
+/* (pre binutils 2.38/LLVM 13) */
+
+/* RDSVL X\nx, #\imm */
+.macro _sme_rdsvl nx, imm
+	_check_general_reg \nx
+	_check_num (\imm), -0x20, 0x1f
+	.inst	0x04bf5800			\
+		| (\nx)				\
+		| (((\imm) & 0x3f) << 5)
+.endm
+
+/*
+ * STR (vector from ZA array):
+ *	STR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
+ */
+.macro _sme_str_zav nw, nxbase, offset=0
+	_sme_check_wv \nw
+	_check_general_reg \nxbase
+	_check_num (\offset), -0x100, 0xff
+	.inst	0xe1200000			\
+		| (((\nw) & 3) << 13)		\
+		| ((\nxbase) << 5)		\
+		| ((\offset) & 7)
+.endm
+
+/*
+ * LDR (vector to ZA array):
+ *	LDR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
+ */
+.macro _sme_ldr_zav nw, nxbase, offset=0
+	_sme_check_wv \nw
+	_check_general_reg \nxbase
+	_check_num (\offset), -0x100, 0xff
+	.inst	0xe1000000			\
+		| (((\nw) & 3) << 13)		\
+		| ((\nxbase) << 5)		\
+		| ((\offset) & 7)
+.endm
+
+/*
+ * Zero the entire ZA array
+ *	ZERO ZA
+ */
+.macro zero_za
+	.inst 0xc00800ff
+.endm
+
 .macro __for from:req, to:req
 	.if (\from) == (\to)
 		_for__body %\from
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
