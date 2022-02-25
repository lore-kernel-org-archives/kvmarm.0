Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C30C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C3534B9E0;
	Fri, 25 Feb 2022 12:36:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kYnqx2Tsy+Ts; Fri, 25 Feb 2022 12:36:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90FD54B92D;
	Fri, 25 Feb 2022 12:36:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5104B92A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WcG00AMnT2-P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:36:43 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48F1E4B940
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:43 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C87EEB832CB;
 Fri, 25 Feb 2022 17:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBC2C36AE2;
 Fri, 25 Feb 2022 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810600;
 bh=u8ThAjRPQXl5naPEmM1t6kvpEaCuO/njq9kA/2bUkaU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dwUoIrn6wAqx7hGh+P7FnEsoowpTtf9FfEdDTed87J5eHtdqLBuUC4GHxBY/ERT0c
 iINQfrfDXtUn5y3GS0sdtEL7EZc7aFC/slTARZJxv7LMi276F9s9QhNpqLHuen1siq
 x0r80PSKQF/thMZagOqxf9fDShZGCyxS2cILBwfekbu7Cu9Wmt/9X9sq4C7mwdvc+u
 e8YsOm2Jm1tmAe3fA+F+zBBcUIy8k1fbwAwobQ7fGhyxCS/DCJiJYLR/pI/w5+Qs8e
 OOSUOjb9++zTqLSZyDmqOlcmDAKCP1tWPRd7Pi8A4oAfbfy4yaPR9/HWmpFdFo+2bX
 wGf6+cbFy08HQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 35/40] kselftest/arm64: signal: Handle ZA signal context
 in core code
Date: Fri, 25 Feb 2022 16:59:18 +0000
Message-Id: <20220225165923.1474372-36-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3326; h=from:subject;
 bh=u8ThAjRPQXl5naPEmM1t6kvpEaCuO/njq9kA/2bUkaU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrl9fuiv18mtve43r9hrrzXEZhd5PyjxxmEE7XI
 5a/zK2SJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK5QAKCRAk1otyXVSH0DqOB/
 0Y5dkA5d/bfH3DCkFZFcrzVM4z1rtJIsbhdpV+sobkNtRt6lQLkoaelfTYAYsL2MZ2h44Hy78aN83k
 upjMN2/ur1EEiAumoBVtMWPQeeYq1y10jQjdJGVAMEHrcDxElijHhtboApuPgciyOMR/KS7/tFB1ku
 K5RfCZDoMt5lN3he2KPfJIJi+Z7e2ZZqYwI1LZbbu633cWEOtnwVZNii6/9tEPRaCVIXaJMqBBB+Cx
 OVaBrR8FGtUOb16FfmbOakhl6VDmputUABhNc+G/j0vMsVCyCwN3o0eFy1Au1IdKfDLGnsfASUlH5A
 VQ6xgsnbR4oa97hW+jIuHc9q+VB5F7
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

As part of the generic code for signal handling test cases we parse all
signal frames to make sure they have at least the basic form we expect
and that there are no unexpected frames present in the signal context.
Add coverage of the ZA signal frame to this code.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 .../arm64/signal/testcases/testcases.c        | 36 +++++++++++++++++++
 .../arm64/signal/testcases/testcases.h        |  3 +-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 8c2a57fc2f9c..84c36bee4d82 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -75,6 +75,31 @@ bool validate_sve_context(struct sve_context *sve, char **err)
 	return true;
 }
 
+bool validate_za_context(struct za_context *za, char **err)
+{
+	/* Size will be rounded up to a multiple of 16 bytes */
+	size_t regs_size
+		= ((ZA_SIG_CONTEXT_SIZE(sve_vq_from_vl(za->vl)) + 15) / 16) * 16;
+
+	if (!za || !err)
+		return false;
+
+	/* Either a bare za_context or a za_context followed by regs data */
+	if ((za->head.size != sizeof(struct za_context)) &&
+	    (za->head.size != regs_size)) {
+		*err = "bad size for ZA context";
+		return false;
+	}
+
+	if (!sve_vl_valid(za->vl)) {
+		*err = "SME VL in ZA context invalid";
+
+		return false;
+	}
+
+	return true;
+}
+
 bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 {
 	bool terminated = false;
@@ -82,6 +107,7 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 	int flags = 0;
 	struct extra_context *extra = NULL;
 	struct sve_context *sve = NULL;
+	struct za_context *za = NULL;
 	struct _aarch64_ctx *head =
 		(struct _aarch64_ctx *)uc->uc_mcontext.__reserved;
 
@@ -120,6 +146,13 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 			sve = (struct sve_context *)head;
 			flags |= SVE_CTX;
 			break;
+		case ZA_MAGIC:
+			if (flags & ZA_CTX)
+				*err = "Multiple ZA_MAGIC";
+			/* Size is validated in validate_za_context() */
+			za = (struct za_context *)head;
+			flags |= ZA_CTX;
+			break;
 		case EXTRA_MAGIC:
 			if (flags & EXTRA_CTX)
 				*err = "Multiple EXTRA_MAGIC";
@@ -165,6 +198,9 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 		if (flags & SVE_CTX)
 			if (!validate_sve_context(sve, err))
 				return false;
+		if (flags & ZA_CTX)
+			if (!validate_za_context(za, err))
+				return false;
 
 		head = GET_RESV_NEXT_HEAD(head);
 	}
diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.h b/tools/testing/selftests/arm64/signal/testcases/testcases.h
index ad884c135314..49f1d5de7b5b 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.h
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.h
@@ -16,7 +16,8 @@
 
 #define FPSIMD_CTX	(1 << 0)
 #define SVE_CTX		(1 << 1)
-#define EXTRA_CTX	(1 << 2)
+#define ZA_CTX		(1 << 2)
+#define EXTRA_CTX	(1 << 3)
 
 #define KSFT_BAD_MAGIC	0xdeadbeef
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
