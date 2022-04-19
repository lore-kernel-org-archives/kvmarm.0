Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA6DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:23:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B7049E08;
	Tue, 19 Apr 2022 07:23:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XohR4Fz66-EB; Tue, 19 Apr 2022 07:23:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843D04B1F3;
	Tue, 19 Apr 2022 07:23:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CBF4B1D8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:23:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpUSJbp+g3QA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:23:53 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D7F349E08
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:23:53 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BB8E6B8184E;
 Tue, 19 Apr 2022 11:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F4C385BE;
 Tue, 19 Apr 2022 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367431;
 bh=qKDOMK2ID+zmqv53Rpn11UftbZJdFvdso5J8RTIVUVE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tIXigwyEVxRIj88uFl1Tdey80PDveDXko8IxC8AqkjgCn2DQGuiXez3Nz0LxL2ljN
 bkCpZaM3ZscNS2ZqGCqXc966SbM+HtCmNxhcW5i4QYdsDQA8ADOfRUOQSRd+dNbaxt
 6VORKBNCxhjF/RW09IksqDCDO0ROGQI6PZtPMJXMPik/drBhjnp/5Hd6XRrie/UY7T
 YNtkFh6SLwP9f7tuyS1T+PSOjv58xhhWicp1qqP98F0rYXTZr8h9Mud6Sxd0g7pEww
 M0+OkLaDQhDSiQVug/LDQAQjm7k73dbaXR9NOrAIb2A0+7AUVujvRn8tD/mFkMtvR8
 VbaXYuOir69/Q==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 06/39] arm64/sme: Manually encode SME instructions
Date: Tue, 19 Apr 2022 12:22:14 +0100
Message-Id: <20220419112247.711548-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3826; h=from:subject;
 bh=qKDOMK2ID+zmqv53Rpn11UftbZJdFvdso5J8RTIVUVE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXptsOWqaNfh5ImR3063vdeoZEMMpcF8hy6OxTVEy
 +oaR6/+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bbAAKCRAk1otyXVSH0F9sB/
 9wsZbynIlpRlwESQW/ZVL4so78zIpDq1yqtdn6wLUYIOjVDsVwWwQzSlgrLVuJaTV2Ct8ttw52H7ru
 vOv2as+j8uXCXryym0MvUZBs+ADuvf+El2DKk4ds6F8BrRKb7zPjrEgFN5vDcuUYlXrjxI8ytRpw+D
 S1+JCvJyf9x7q/Qt7COx8F7jsKxbc0qPw9CUna8t7UjsNquTzSCYy2LI2LPCRbkfHe6KCriBo8Jij5
 LjWL7P4neX9ttfFGRxTRGGrrYc2xm44WOCKqEDAqXoVGxm9FabZoUJgLsSd9UWUq9QHvOF1wZvBx43
 Dr9bS7wOSvtRmWJI4Rg64EBjWZYgvZ
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
