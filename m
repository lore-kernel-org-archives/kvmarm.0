Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3594432B136
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369984; cv=none; b=sIVx9DAetozTf1re8oKiLPBd4ta3PahM5G3eq2mGEFxybsm8/6/CFH02Fx+w9SJSH2JCdhHRyvoDp/7+1SNK2pgELmYYuMMyz6dKE2wohtiy/QcnhZDHU+uiz6mdkTjqZEsdFa2RAKXnwhA6PgCf85l33XCbvOI5hmDST7N1uQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369984; c=relaxed/simple;
	bh=kYdhN/MlUx+0O0SIVY7aJPIl6AU8mwgy1D2BewCH+ak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BFpp4zzfC9HjZpFmQf6b5i+/XZUpk89BjHUp7uGah6Ot2B2rvkaXbzLUfSBw38INZKwEwL7T6N55EWv+NAwhgk2JZSBvkB/PvkV2xyIzrNPu83oqdI8GAGE1ht/YOkIET2sukkJrWoTumUVbZLC2YDvS22bblm9Uw7oSzQfPMtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m38GDavR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m38GDavR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 327291C00;
	Thu, 21 May 2026 06:26:16 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EBE7C3F7B4;
	Thu, 21 May 2026 06:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369981; bh=kYdhN/MlUx+0O0SIVY7aJPIl6AU8mwgy1D2BewCH+ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m38GDavRblkVeRCA08ta2DxID1YgmY9tCbpV/Dh1PZg1+He61CpO9eEtfGFRaFzpm
	 PJJS/FHxoZzHCc7L3qjSbxMYg0RovtJRg5aBYS0r6iEhHBk71o2tofTiezkd4e1+Pd
	 ZaVlIJOCdWSM5Ih0zYWcES2rlcPsoFWUO4eMZLfk=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 07/18] arm64: fpsimd: Use assembler for SVE instructions
Date: Thu, 21 May 2026 14:25:45 +0100
Message-Id: <20260521132556.584676-8-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Historically we supported assemblers which could not assemble SVE
instructions. We dropped support for such assemblers in commit:

  118c40b7b503 ("kbuild: require gcc-8 and binutils-2.30")

Since that commit, all supported assemblers (binutils and LLVM) are
capable of assembling SVE instructions, and there's no need for us to
manually encode SVE instructions.

Rely on the assembler to encode SVE instructions, and remove the manual
encoding. The various _sve_<insn> macros are kept for now, and will be
cleaned up in subsequent patches.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimdmacros.h | 64 +++++++--------------------
 1 file changed, 16 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index adf33d2da40c3..1122eea6daacf 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -99,85 +99,53 @@
 	.endif
 .endm
 
-/* SVE instruction encodings for non-SVE-capable assemblers */
-/* (pre binutils 2.28, all kernel capable clang versions support SVE) */
+/* Deprecated macros for SVE instructions */
 
 /* STR (vector): STR Z\nz, [X\nxbase, #\offset, MUL VL] */
 .macro _sve_str_v nz, nxbase, offset=0
-	_sve_check_zreg \nz
-	_check_general_reg \nxbase
-	_check_num (\offset), -0x100, 0xff
-	.inst	0xe5804000			\
-		| (\nz)				\
-		| ((\nxbase) << 5)		\
-		| (((\offset) & 7) << 10)	\
-		| (((\offset) & 0x1f8) << 13)
+	.arch_extension sve
+	str	z\nz, [X\nxbase, #\offset, MUL VL]
 .endm
 
 /* LDR (vector): LDR Z\nz, [X\nxbase, #\offset, MUL VL] */
 .macro _sve_ldr_v nz, nxbase, offset=0
-	_sve_check_zreg \nz
-	_check_general_reg \nxbase
-	_check_num (\offset), -0x100, 0xff
-	.inst	0x85804000			\
-		| (\nz)				\
-		| ((\nxbase) << 5)		\
-		| (((\offset) & 7) << 10)	\
-		| (((\offset) & 0x1f8) << 13)
+	.arch_extension sve
+	ldr	z\nz, [X\nxbase, #\offset, MUL VL]
 .endm
 
 /* STR (predicate): STR P\np, [X\nxbase, #\offset, MUL VL] */
 .macro _sve_str_p np, nxbase, offset=0
-	_sve_check_preg \np
-	_check_general_reg \nxbase
-	_check_num (\offset), -0x100, 0xff
-	.inst	0xe5800000			\
-		| (\np)				\
-		| ((\nxbase) << 5)		\
-		| (((\offset) & 7) << 10)	\
-		| (((\offset) & 0x1f8) << 13)
+	.arch_extension sve
+	str	p\np, [X\nxbase, #\offset, MUL VL]
 .endm
 
 /* LDR (predicate): LDR P\np, [X\nxbase, #\offset, MUL VL] */
 .macro _sve_ldr_p np, nxbase, offset=0
-	_sve_check_preg \np
-	_check_general_reg \nxbase
-	_check_num (\offset), -0x100, 0xff
-	.inst	0x85800000			\
-		| (\np)				\
-		| ((\nxbase) << 5)		\
-		| (((\offset) & 7) << 10)	\
-		| (((\offset) & 0x1f8) << 13)
+	.arch_extension sve
+	ldr p\np, [x\nxbase, #\offset, MUL VL]
 .endm
 
 /* RDVL X\nx, #\imm */
 .macro _sve_rdvl nx, imm
-	_check_general_reg \nx
-	_check_num (\imm), -0x20, 0x1f
-	.inst	0x04bf5000			\
-		| (\nx)				\
-		| (((\imm) & 0x3f) << 5)
+	.arch_extension sve
+	rdvl x\nx, #\imm
 .endm
 
 /* RDFFR (unpredicated): RDFFR P\np.B */
 .macro _sve_rdffr np
-	_sve_check_preg \np
-	.inst	0x2519f000			\
-		| (\np)
+	.arch_extension sve
+	rdffr p\np\().b
 .endm
 
 /* WRFFR P\np.B */
 .macro _sve_wrffr np
-	_sve_check_preg \np
-	.inst	0x25289000			\
-		| ((\np) << 5)
+	wrffr p\np\().b
 .endm
 
 /* PFALSE P\np.B */
 .macro _sve_pfalse np
-	_sve_check_preg \np
-	.inst	0x2518e400			\
-		| (\np)
+	.arch_extension sve
+	pfalse	p\np\().b
 .endm
 
 /* SME instruction encodings for non-SME-capable assemblers */
-- 
2.30.2

