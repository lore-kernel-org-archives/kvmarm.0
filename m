Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13ED1C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:57:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2364A193;
	Fri,  8 Apr 2022 07:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wLZObffRJrVT; Fri,  8 Apr 2022 07:57:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6D04B28F;
	Fri,  8 Apr 2022 07:57:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FC54B2A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0pS2+Li5rf+O for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:57:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5ED4849EC3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 74463B82A8B;
 Fri,  8 Apr 2022 11:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F70C385A3;
 Fri,  8 Apr 2022 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649419061;
 bh=fXwWFB6jpNtZae17QXbW3zbq8KuNTW7OX2FF8Uha5Gg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=X92WI7z4RGG0VunIHRyEp1idvjJC5w39+Qvo2uDLOIOHl22mECCvQg5DiBV8uY9yB
 60rEC/Z5OYMLL8yZvWmZDH76HpuEC6eHZsLoEQeSsOk8I6JP7u1qZO2S7wxkhj/046
 /yOIFhEoqiDzmggUfh+fbXCwZxJklPIvmF9gcHHDOaUKUfw2exXsyITggjWJ1gZVpz
 7z1ziny8rb3nrdK+NSesol+KCLLEKy3r+cFK5Y8WjjB8V5x5qaAW+nvnBOtCN32qe0
 eFOj9ijyxu93f/L+dhUkZ5O2s2LORzOpx/42gvmYSl106bPFaZdOPZSoJLrohJH6At
 r3Da5gtOxsrwA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 36/39] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Fri,  8 Apr 2022 12:43:25 +0100
Message-Id: <20220408114328.1401034-37-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1379; h=from:subject;
 bh=fXwWFB6jpNtZae17QXbW3zbq8KuNTW7OX2FF8Uha5Gg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/bazFhET/VUe/nNfuFBfkZb5fRXDAX4kKR1kYv
 hE3ThlSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAf2wAKCRAk1otyXVSH0GkMB/
 9mF487zFtWpdx5GykcBjgpGduiVWvApMYQf6xeNVOrUOEqdFa5uMl0KiERfCRnnXZ4UQg90hiam7Q+
 iZFbeW5ftjHWfnZ05yc1MXP9lF0O3uhSM5M1BVMprh2JzE0PnL8psYbvXPR7wT3PT+XAWWZQix7P/v
 ApxQJecxhdRS7z6kD1OhwUCWfHjaXD6LS0HpvWW/WST5Dm9aec1y9clFRJJMIyUwXjy1J/W0X++alD
 8bgow2WQ0UgKc3VrF9VJTIbLCiAUrjBlp4ZXDcA4bnOX/GguNsHCmPfL3JZ5tJuKzza8Nv4BCBOqTH
 TrZI8YyI1qkR1uNojmulngJF2xn4qC
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

In order to allow ptrace of streaming mode SVE registers we have added a
new regset for streaming mode which in isolation offers the same ABI as
regular SVE with a different vector type. Add this to the array of regsets
we handle, together with additional tests for the interoperation of the
two regsets.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index c2564480b750..df45e4f9465c 100644
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
 
 #define VL_TESTS (((SVE_VQ_MAX - SVE_VQ_MIN) + 1) * 4)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
