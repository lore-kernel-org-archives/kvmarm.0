Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AA4C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:25:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC314B278;
	Tue, 19 Apr 2022 07:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u-HLypcIoyTI; Tue, 19 Apr 2022 07:25:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54E54B25F;
	Tue, 19 Apr 2022 07:25:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D064B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vZBtqB2EKt03 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:25:55 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA78149EFE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 41848612D2;
 Tue, 19 Apr 2022 11:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1392CC385A5;
 Tue, 19 Apr 2022 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367554;
 bh=fXwWFB6jpNtZae17QXbW3zbq8KuNTW7OX2FF8Uha5Gg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uGdpVz0HW9soNTs6KH5vmk9pb8aaGwykmCzjFg0KnU1Mrjr9K9xqANpDLNhSkB3jT
 1YHcZ1K0AsmMHTFFbka/tP/HQwCKLevaH+tMZrJ8DnKdmKGifVu9Gi/I7mZst5fYvY
 M/D0gJ2GZtkcUT2U/ljHqDfFnDJW7JoLBcJoW+dkuRJJ8bK5U46n2CipVNJHT+LzkS
 cIWQJG3T3FuEEKxgfpiOSHFlrf3JI9obumj5wCBDsQQvmkaOCFown9h7ij52TH/Tei
 hkLQGuDdnu6+98alnWMoqbUdZa27j+kJVN+dIBQJZuwoNCR4m9vsVjCghOyogrXN/L
 /veExeHiXkFLA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 36/39] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Tue, 19 Apr 2022 12:22:44 +0100
Message-Id: <20220419112247.711548-37-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1379; h=from:subject;
 bh=fXwWFB6jpNtZae17QXbW3zbq8KuNTW7OX2FF8Uha5Gg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXpuEazFhET/VUe/nNfuFBfkZb5fRXDAX4kKR1kYv
 hE3ThlSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bhAAKCRAk1otyXVSH0CceB/
 9mJqF4FiCJ1aDXY1lXBa+avoX7xgzV52r17/43gGWLUsmTahx8EFy/phMLZGXBONkpuMmSNE893Y1O
 G1Ljmv1hr3woB3blVKRNnJmE8gq9EKeH6jLQQwbbMLKut2lw0N0L0zCkorDX99wR7XBKN7xm/0Z0en
 JhwNkjjaHtVoTGRsjKbeNjeqvclrALoatptJoly+VsIvJny6RuFei/RRTjeSPYRjndNnJv+2+8eipg
 1ZFf+VKtYne/HKbk4Iay8ikg06vmiZn0SkQH1Fj7zHh3eXl/8XdL1SJVgq4QXpMbwNP+xSoQ7tVhOT
 af76OyGi9NI78Jgcic51XUGJzXdv9m
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
