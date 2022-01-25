Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B71BC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:17:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB62249F2F;
	Mon, 24 Jan 2022 19:17:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjgl26Dt4Zt9; Mon, 24 Jan 2022 19:17:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B42FF49F14;
	Mon, 24 Jan 2022 19:17:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8EBB49DFF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:17:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XKDAjUGiKG45 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:17:44 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B3D749E46
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:17:44 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A4BF1B815E0;
 Tue, 25 Jan 2022 00:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B6AC340EC;
 Tue, 25 Jan 2022 00:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069862;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qwj1jbbqBIBrVFn2Trsk1oswuH1frWSBE1DOgnNFSzVgA6YOHFcZu0lT/05euqeGh
 L859W2KqeW0ScQuHQU8tpJjAaUVW6XZhVPaLuMPdp5B3Uj7QcAazl/MtwMGdlTVoZx
 oeEzDUxViJw8uFHE/UdGqnZGhs+bF4rdAf6XsQWZF6VIJyjwvWoS9aV7XpTAv+WbWR
 F4BOXqQTdnEYii8H+RdJpNWPfZSGHCg7/5y7CJ+iku5ugvn7K2zXg7CTKSCqraVlhO
 VUwRMPeAlvGYjNnAp8hrYqrimGoW6DzCajYMwvIC6d8teEqM9IBeRjghs0YQY9seJQ
 0MLTD5w7EvRxw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 36/38] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Tue, 25 Jan 2022 00:11:12 +0000
Message-Id: <20220125001114.193425-37-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; h=from:subject;
 bh=Oja1/wO9gzdoi99/QIiaS7CVLDJss5+ewa1C/MDEXls=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70AdKqGPNGZXH7z6iwfnPdNtlzhXYbjCCRcGKiz8
 vwxyiyiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9AHQAKCRAk1otyXVSH0CW8B/
 sHzyzP6JW85YBfcAVx+5OnHZ6gaQy9T3EKX4ohWCAVmxGpib4yXSL8uITJ3WfKwK8ZfsYImhRTsqFD
 U+smjVa2WFzscZuZhfeqDlu7uCgvONqrAeGmJXiDIyF2m9rVUVh4iRl2obatBZ9Px+wQt+0BuAYdRc
 pA152WCZl08afynO7U5wBoKg1TPD7xqZSvdCjF8I+8K+S3Ot8M05VOCMoMuSRtnmmfTaPuHeZrmqAp
 q1nx6jmgvRwcqGbVkGrTJVfepApDgm+dG112kuBtXtz52wd3bdqp5y/4s2uh1kbTP7VPTdvFenWjIK
 4xRt6waPcF91AXUdjOUfjrnhmct9iU
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
