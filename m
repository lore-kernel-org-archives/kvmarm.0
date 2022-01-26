Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417F1C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:32:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF2F4B0F1;
	Wed, 26 Jan 2022 10:32:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8757eBmUh3Ip; Wed, 26 Jan 2022 10:32:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D796B4B0DF;
	Wed, 26 Jan 2022 10:32:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D384B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0YGa5vgrrNS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:32:47 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2858F4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:47 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8F139618D3;
 Wed, 26 Jan 2022 15:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E4EC340E9;
 Wed, 26 Jan 2022 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643211166;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KHwjbQRWRnrBgUU7VnH4HwgMC0wUnmRv1nutfz8fgs46/8Na/7zB5mcWQIY/U98HS
 fYSDE0k6eifKSAyr5OAmiBgLGfRtv6JrwYraea7fRewJhKg8RIbCut2IvYZZq33MQO
 mYGmb0BNpANqvczNYK/g6dXKaZ4SHoI/61hrPZXrIuJXoe+FhzJoIiyV/tLhm44Ddy
 g+N3Oa4OjS460oCakVL9MwJoy6CxXSYwbWFrWxa8htbjDwZ0LZshEDDs+xaGv7mv5X
 Rir5M6+NjWZK1gu4/b/hKBBv1V8UAVlOWetrsJqpbMgVMNy4u6gtjtbQn/UA7ZVjKn
 CWAA2VT40om7w==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v10 37/39] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Wed, 26 Jan 2022 15:27:47 +0000
Message-Id: <20220126152749.233712-38-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126152749.233712-1-broonie@kernel.org>
References: <20220126152749.233712-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; h=from:subject;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WhyKqGPNGZXH7z6iwfnPdNtlzhXYbjCCRcGKiz8
 vwxyiyiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFocgAKCRAk1otyXVSH0MzTB/
 40+l9PdyJyNwSWKkAQTjBS2CPl2JqgTo/FBRvlXhV4ZoedXN9pRfwUrwif9DXJBPRyGxRgnEevRIw0
 l3A1nYQyDZT69HQWfDkbzp3lGKpbSImc0XQo1j9xxQrZM+6br01f4YVGDFh5Qoy2kA659wU3lS/OsZ
 J/aVI67Eq/9ru7ocZU9WPSKv123ZU2VxBVHmHgP2HpPnvqtV0Ersgh5EVARrU9vl58FPu9O9bRjRh5
 cP2QBc00gUf/p7f8S0diSaXvrB36mbxYrGw2FK1hYAYezlgBpFMQ8hKEftHkXheSiu4Jv3Jy7CpACy
 NPLTq7N1IwLOCDTMQ9Gt9mXSro15eR
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
