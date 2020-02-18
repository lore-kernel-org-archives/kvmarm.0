Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE28C3404B
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33EB324687
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33EB324687
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D273D4AF3D;
	Tue, 18 Feb 2020 14:59:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SErPrvd0oNOK; Tue, 18 Feb 2020 14:58:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1D04AF5D;
	Tue, 18 Feb 2020 14:58:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D8F4AF30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:58:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E-x7RIz4KSI2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:58:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C514AF3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:58:56 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 241B4FEC;
 Tue, 18 Feb 2020 11:58:56 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98B4F3F68F;
 Tue, 18 Feb 2020 11:58:55 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 01/18] arm64: crypto: Modernize some extra assembly annotations
Date: Tue, 18 Feb 2020 19:58:25 +0000
Message-Id: <20200218195842.34156-2-broonie@kernel.org>
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

A couple of functions were missed in the modernisation of assembly macros,
update them too.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 084c6a30b03a..6b958dcdf136 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -587,20 +587,20 @@ CPU_LE(	rev		w8, w8		)
 	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
 	 *			  int rounds, u8 tag)
 	 */
-ENTRY(pmull_gcm_encrypt)
+SYM_FUNC_START(pmull_gcm_encrypt)
 	pmull_gcm_do_crypt	1
-ENDPROC(pmull_gcm_encrypt)
+SYM_FUNC_END(pmull_gcm_encrypt)
 
 	/*
 	 * void pmull_gcm_decrypt(int blocks, u8 dst[], const u8 src[],
 	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
 	 *			  int rounds, u8 tag)
 	 */
-ENTRY(pmull_gcm_decrypt)
+SYM_FUNC_START(pmull_gcm_decrypt)
 	pmull_gcm_do_crypt	0
-ENDPROC(pmull_gcm_decrypt)
+SYM_FUNC_END(pmull_gcm_decrypt)
 
-pmull_gcm_ghash_4x:
+SYM_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
 	movi		MASK.16b, #0xe1
 	shl		MASK.2d, MASK.2d, #57
 
@@ -681,9 +681,9 @@ pmull_gcm_ghash_4x:
 	eor		XL.16b, XL.16b, T2.16b
 
 	ret
-ENDPROC(pmull_gcm_ghash_4x)
+SYM_FUNC_END(pmull_gcm_ghash_4x)
 
-pmull_gcm_enc_4x:
+SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	ld1		{KS0.16b}, [x5]			// load upper counter
 	sub		w10, w8, #4
 	sub		w11, w8, #3
@@ -746,7 +746,7 @@ pmull_gcm_enc_4x:
 	eor		INP3.16b, INP3.16b, KS3.16b
 
 	ret
-ENDPROC(pmull_gcm_enc_4x)
+SYM_FUNC_END(pmull_gcm_enc_4x)
 
 	.section	".rodata", "a"
 	.align		6
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
