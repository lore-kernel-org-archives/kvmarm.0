Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7898CC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:23:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0E649EC1;
	Mon,  7 Feb 2022 10:23:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zLApK8hG-uLG; Mon,  7 Feb 2022 10:23:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E3D49ED2;
	Mon,  7 Feb 2022 10:23:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0360440CDE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uQJRudmBDhCg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:23:42 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8E7049ED2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 0A71EB815A6;
 Mon,  7 Feb 2022 15:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C5C340F2;
 Mon,  7 Feb 2022 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247418;
 bh=HMQHyHN36InZca7SOj753D+ZgRaa/ByOBuanPgEEWxc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RaDkJG5UFzR+PFUH/Cktih1qAaGz1BpcVaXiu+8wx2N8fBhoEUyrqGmsypWqLcyDJ
 wvRGHTEY87NjdSrkt8v43kNU07jhx7qkeQ1bwNAkV4043CoRaksSJT8MWQ2gy/ILIr
 cS13TTYBSYhe5K1Er6zkjv441wvoNk1CAFJlCsJ5ey4rllXuNRdK6fIyflNMUSBLTe
 OaMoTpYjjcprNj/gXImSvJjQizp9HmcMqf39a+Ts+jYUjkvEyUUDZ2gDINzhiYvOy7
 I7ZT9uulLZOh3uThiY6TwEGu4bEE+MeGYwk96fXn+E+dNeVYTa+FyE8iXvkGNGzHtO
 /7EDTkwC/LZiw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 08/40] arm64/sme: Manually encode SME instructions
Date: Mon,  7 Feb 2022 15:20:37 +0000
Message-Id: <20220207152109.197566-9-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3671; h=from:subject;
 bh=HMQHyHN36InZca7SOj753D+ZgRaa/ByOBuanPgEEWxc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjLU4t0P2TtzTYSd2s2Hen3CRw27ngQIyNfDOJC
 4/nuJxWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE4ywAKCRAk1otyXVSH0GAMB/
 9r5CGhL1EtZIHg+mK4TXgNsO7uYuELjxQxQ3n78fLzcDGxMxoR8R44ZqWmgqx6mU1VVelM90wnmmMa
 1+x5JvPphvyA07/N98GXBbNxCHzi9+4KAFEq3DN0p28vywW0dbSU0Yy7vRYiO6Eu4YJpa3O45zOjVR
 +Mb8INezzMfNN7yEwGDBzHg1PchJwSx+Y2Z6hg2x+nEdagqjcdPLmKIa+bfrc17qfFhDeChDyoIpcz
 3IFCV0y4OiCt5Mq1zNz5EMU7EwiDIkalR36gxWbPLQvLdhAnP1ljnvYpSycyehik8Uzj0Cml6go8P3
 E6m+IgUmYExixGQW2ZW2o46Kc5va9k
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
---
 arch/arm64/include/asm/fpsimd.h       | 25 +++++++++++++
 arch/arm64/include/asm/fpsimdmacros.h | 53 +++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index cb24385e3632..c90f7f99a768 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -249,6 +249,31 @@ static inline void sve_setup(void) { }
 
 #endif /* ! CONFIG_ARM64_SVE */
 
+#ifdef CONFIG_ARM64_SME
+
+static inline void sme_smstart_sm(void)
+{
+	asm volatile(".inst 0xd503437f");
+}
+
+static inline void sme_smstop_sm(void)
+{
+	asm volatile(".inst 0xd503427f");
+}
+
+static inline void sme_smstop(void)
+{
+	asm volatile(".inst 0xd503467f");
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
index 2509d7dde55a..11c426ddd62c 100644
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
 
@@ -174,6 +180,53 @@
 		| (\np)
 .endm
 
+/* SME instruction encodings for non-SME-capable assemblers */
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
