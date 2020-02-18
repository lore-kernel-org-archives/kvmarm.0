Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A05C34049
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A0C124655
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A0C124655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E96234AF51;
	Tue, 18 Feb 2020 14:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1oH1XUnNcu9; Tue, 18 Feb 2020 14:59:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C45C84AF6F;
	Tue, 18 Feb 2020 14:59:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 330664AF46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J8r89SY-j0id for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2814D4AF3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:58:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C99F101E;
 Tue, 18 Feb 2020 11:58:58 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D21653F68F;
 Tue, 18 Feb 2020 11:58:57 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 02/18] arm64: crypto: Modernize names for AES function macros
Date: Tue, 18 Feb 2020 19:58:26 +0000
Message-Id: <20200218195842.34156-3-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Cc: Ard Biesheuvel <ardb@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org
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

Now that the rest of the code has been converted to the modern START/END
macros the AES_ENTRY() and AES_ENDPROC() macros look out of place and
like they need updating. Rename them to AES_FUNC_START() and AES_FUNC_END()
to line up with the modern style assembly macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce.S    |  4 +--
 arch/arm64/crypto/aes-modes.S | 48 +++++++++++++++++------------------
 arch/arm64/crypto/aes-neon.S  |  4 +--
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 45062553467f..1dc5bbbfeed2 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -9,8 +9,8 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-#define AES_ENTRY(func)		SYM_FUNC_START(ce_ ## func)
-#define AES_ENDPROC(func)	SYM_FUNC_END(ce_ ## func)
+#define AES_FUNC_START(func)		SYM_FUNC_START(ce_ ## func)
+#define AES_FUNC_END(func)		SYM_FUNC_END(ce_ ## func)
 
 	.arch		armv8-a+crypto
 
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 8a2faa42b57e..cf618d8f6cec 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -51,7 +51,7 @@ SYM_FUNC_END(aes_decrypt_block5x)
 	 *		   int blocks)
 	 */
 
-AES_ENTRY(aes_ecb_encrypt)
+AES_FUNC_START(aes_ecb_encrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -79,10 +79,10 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 .Lecbencout:
 	ldp		x29, x30, [sp], #16
 	ret
-AES_ENDPROC(aes_ecb_encrypt)
+AES_FUNC_END(aes_ecb_encrypt)
 
 
-AES_ENTRY(aes_ecb_decrypt)
+AES_FUNC_START(aes_ecb_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -110,7 +110,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 .Lecbdecout:
 	ldp		x29, x30, [sp], #16
 	ret
-AES_ENDPROC(aes_ecb_decrypt)
+AES_FUNC_END(aes_ecb_decrypt)
 
 
 	/*
@@ -126,7 +126,7 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 *			 u32 const rk2[]);
 	 */
 
-AES_ENTRY(aes_essiv_cbc_encrypt)
+AES_FUNC_START(aes_essiv_cbc_encrypt)
 	ld1		{v4.16b}, [x5]			/* get iv */
 
 	mov		w8, #14				/* AES-256: 14 rounds */
@@ -135,7 +135,7 @@ AES_ENTRY(aes_essiv_cbc_encrypt)
 	enc_switch_key	w3, x2, x6
 	b		.Lcbcencloop4x
 
-AES_ENTRY(aes_cbc_encrypt)
+AES_FUNC_START(aes_cbc_encrypt)
 	ld1		{v4.16b}, [x5]			/* get iv */
 	enc_prepare	w3, x2, x6
 
@@ -167,10 +167,10 @@ AES_ENTRY(aes_cbc_encrypt)
 .Lcbcencout:
 	st1		{v4.16b}, [x5]			/* return iv */
 	ret
-AES_ENDPROC(aes_cbc_encrypt)
-AES_ENDPROC(aes_essiv_cbc_encrypt)
+AES_FUNC_END(aes_cbc_encrypt)
+AES_FUNC_END(aes_essiv_cbc_encrypt)
 
-AES_ENTRY(aes_essiv_cbc_decrypt)
+AES_FUNC_START(aes_essiv_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -181,7 +181,7 @@ AES_ENTRY(aes_essiv_cbc_decrypt)
 	encrypt_block	cbciv, w8, x6, x7, w9
 	b		.Lessivcbcdecstart
 
-AES_ENTRY(aes_cbc_decrypt)
+AES_FUNC_START(aes_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -238,8 +238,8 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	st1		{cbciv.16b}, [x5]		/* return iv */
 	ldp		x29, x30, [sp], #16
 	ret
-AES_ENDPROC(aes_cbc_decrypt)
-AES_ENDPROC(aes_essiv_cbc_decrypt)
+AES_FUNC_END(aes_cbc_decrypt)
+AES_FUNC_END(aes_essiv_cbc_decrypt)
 
 
 	/*
@@ -249,7 +249,7 @@ AES_ENDPROC(aes_essiv_cbc_decrypt)
 	 *		       int rounds, int bytes, u8 const iv[])
 	 */
 
-AES_ENTRY(aes_cbc_cts_encrypt)
+AES_FUNC_START(aes_cbc_cts_encrypt)
 	adr_l		x8, .Lcts_permute_table
 	sub		x4, x4, #16
 	add		x9, x8, #32
@@ -276,9 +276,9 @@ AES_ENTRY(aes_cbc_cts_encrypt)
 	st1		{v0.16b}, [x4]			/* overlapping stores */
 	st1		{v1.16b}, [x0]
 	ret
-AES_ENDPROC(aes_cbc_cts_encrypt)
+AES_FUNC_END(aes_cbc_cts_encrypt)
 
-AES_ENTRY(aes_cbc_cts_decrypt)
+AES_FUNC_START(aes_cbc_cts_decrypt)
 	adr_l		x8, .Lcts_permute_table
 	sub		x4, x4, #16
 	add		x9, x8, #32
@@ -305,7 +305,7 @@ AES_ENTRY(aes_cbc_cts_decrypt)
 	st1		{v2.16b}, [x4]			/* overlapping stores */
 	st1		{v0.16b}, [x0]
 	ret
-AES_ENDPROC(aes_cbc_cts_decrypt)
+AES_FUNC_END(aes_cbc_cts_decrypt)
 
 	.section	".rodata", "a"
 	.align		6
@@ -324,7 +324,7 @@ AES_ENDPROC(aes_cbc_cts_decrypt)
 	 *		   int blocks, u8 ctr[])
 	 */
 
-AES_ENTRY(aes_ctr_encrypt)
+AES_FUNC_START(aes_ctr_encrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -409,7 +409,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	rev		x7, x7
 	ins		vctr.d[0], x7
 	b		.Lctrcarrydone
-AES_ENDPROC(aes_ctr_encrypt)
+AES_FUNC_END(aes_ctr_encrypt)
 
 
 	/*
@@ -433,7 +433,7 @@ AES_ENDPROC(aes_ctr_encrypt)
 	uzp1		xtsmask.4s, xtsmask.4s, \tmp\().4s
 	.endm
 
-AES_ENTRY(aes_xts_encrypt)
+AES_FUNC_START(aes_xts_encrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -518,9 +518,9 @@ AES_ENTRY(aes_xts_encrypt)
 	st1		{v2.16b}, [x4]			/* overlapping stores */
 	mov		w4, wzr
 	b		.Lxtsencctsout
-AES_ENDPROC(aes_xts_encrypt)
+AES_FUNC_END(aes_xts_encrypt)
 
-AES_ENTRY(aes_xts_decrypt)
+AES_FUNC_START(aes_xts_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
@@ -612,13 +612,13 @@ AES_ENTRY(aes_xts_decrypt)
 	st1		{v2.16b}, [x4]			/* overlapping stores */
 	mov		w4, wzr
 	b		.Lxtsdecctsout
-AES_ENDPROC(aes_xts_decrypt)
+AES_FUNC_END(aes_xts_decrypt)
 
 	/*
 	 * aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 	 *		  int blocks, u8 dg[], int enc_before, int enc_after)
 	 */
-AES_ENTRY(aes_mac_update)
+AES_FUNC_START(aes_mac_update)
 	frame_push	6
 
 	mov		x19, x0
@@ -676,4 +676,4 @@ AES_ENTRY(aes_mac_update)
 	ld1		{v0.16b}, [x23]			/* get dg */
 	enc_prepare	w21, x20, x0
 	b		.Lmacloop4x
-AES_ENDPROC(aes_mac_update)
+AES_FUNC_END(aes_mac_update)
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 247d34ddaab0..e47d3ec2cfb4 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -8,8 +8,8 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-#define AES_ENTRY(func)		SYM_FUNC_START(neon_ ## func)
-#define AES_ENDPROC(func)	SYM_FUNC_END(neon_ ## func)
+#define AES_FUNC_START(func)		SYM_FUNC_START(neon_ ## func)
+#define AES_FUNC_END(func)		SYM_FUNC_END(neon_ ## func)
 
 	xtsmask		.req	v7
 	cbciv		.req	v7
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
