Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6BEC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:14:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1397B49EDF;
	Wed, 26 Jan 2022 10:14:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NxzWo8h0PMd1; Wed, 26 Jan 2022 10:14:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013ED49ECF;
	Wed, 26 Jan 2022 10:14:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9BAC49B26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:14:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yCZ+CV9c33lN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:14:13 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF3C449EF4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:14:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D4031B81EA8;
 Wed, 26 Jan 2022 15:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383FDC340EB;
 Wed, 26 Jan 2022 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643210051;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UspBiTLX7oA/wP9GC6WdtaGZ6p6ABC3ihVdAn1wAEuQxR7031HUx/7Q6qOVW9EHQG
 ZnNAQxk55sPUOqZWGN3yfV/j8TAyTmQiyn3lPAWQcjqz5VxEMzvq2yvy+15B68GWzO
 vQAH5o8mUOBdWBJLUqPZ9UooD+n6mYI3iu/zyL9GzcEYcMbuj7OzMe/1m/6Xl79twS
 KGGXsriV9t85PcIK+QD+ZAh8mjX9oNRLWe6fYNhZZ+Gv7dUlLdVQGeUcA3H/cCzYja
 GXI9klyRdUijcueJgHzA5LJcz0tOfLi8DYSsTDNArUjkNeNEKHvVwfJGfG0a8e65LJ
 hCRbLPG4wxB2g==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v9 37/40] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Wed, 26 Jan 2022 15:11:17 +0000
Message-Id: <20220126151120.3811248-38-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126151120.3811248-1-broonie@kernel.org>
References: <20220126151120.3811248-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; h=from:subject;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WSUKqGPNGZXH7z6iwfnPdNtlzhXYbjCCRcGKiz8
 vwxyiyiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFklAAKCRAk1otyXVSH0ACqB/
 9H5FbWIzMbqx0jF7effH5vEJmz1AFPrA2WB3HBOBbIaMlvmVGPsk3rjTzrJrv2YhmcvbR4SH5qWjcy
 iNEZuf584MdmuNQf2scMulPNuNY9rjIQu4Rr8CKZSDxN0HWjHYM+irqzzAK7vpCPjSxCJwJ/k5Rkg6
 fOZ02eQLTWJorxtm9EjpzJhGjbhnxQElfc8fsuFP9Z1T2EVhYxIPEW12EawWFbyXbKZxanoZ/Ynk3Z
 83C7JnWCoxNckdqvUcuZ08P/GFqF9FLcAl9s3wU6mHTHWthinLymZlSX1F7WKghIORkiBoLQ8wya+/
 qWlaHX0+sSFYwaezFs0GYsoiSow8WU
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

In order to allow ptrace of streaming mode SVE registers we have added a
new regset for streaming mode which in isolation offers the same ABI as
regular SVE with a different vector type. Add this to the array of regsets
we handle, together with additional tests for the interoperation of the
two regsets.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index 90ba1d6a6781..fb74b11bab71 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -26,6 +26,10 @@
 #define NT_ARM_SVE 0x405
 #endif
 
+#ifndef NT_ARM_SSVE
+#define NT_ARM_SSVE 0x40b
+#endif
+
 struct vec_type {
 	const char *name;
 	unsigned long hwcap_type;
@@ -42,6 +46,13 @@ static const struct vec_type vec_types[] = {
 		.regset = NT_ARM_SVE,
 		.prctl_set = PR_SVE_SET_VL,
 	},
+	{
+		.name = "Streaming SVE",
+		.hwcap_type = AT_HWCAP2,
+		.hwcap = HWCAP2_SME,
+		.regset = NT_ARM_SSVE,
+		.prctl_set = PR_SME_SET_VL,
+	},
 };
 
 #define VL_TESTS (((SVE_VQ_MAX - SVE_VQ_MIN) + 1) * 3)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
