Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB06C35273
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:25:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7599D40BF0;
	Mon,  7 Feb 2022 10:25:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f6NKFkqoRtPy; Mon,  7 Feb 2022 10:25:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4243449F15;
	Mon,  7 Feb 2022 10:25:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 141CA400DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uec29qinnE6g for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:25:41 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E134F40BF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 78B6A6149F;
 Mon,  7 Feb 2022 15:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767BAC36AE9;
 Mon,  7 Feb 2022 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247540;
 bh=jFThs8TIOLg+EbxAyGgsmB8MI+17nKceITt5cYnyHpQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EA4G4UUIs7cBnvxnbreQBVRMR3payU5TsxXONpPJSj+YKa/qe9IgmWAGVtxMQU08i
 jZWbHYN711ZNnVTDFKMeExUR96oSXJQrEeySD4K92UUt6zj/u9AVrD3ZfHEy9KPkcW
 SXUluFElIMcgAZ4CR3N1riclVhSh5DT2G5LIIyAWp7RiJcC2EZ6FNL61jeKddQghX6
 JdNFIsQh3hahprpwb3cmEcciaQPC9jTt3HFARoVZuzFxPX4pREspjg0/XkJDgybbcE
 SISDwcB7BOP0+fxwAkdw8JK6MPhFRA8eEUwpjcd/++7Vxe6LEUKIE7hSTYddJySKQn
 JVpemlR1cOEag==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 38/40] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Mon,  7 Feb 2022 15:21:07 +0000
Message-Id: <20220207152109.197566-39-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; h=from:subject;
 bh=jFThs8TIOLg+EbxAyGgsmB8MI+17nKceITt5cYnyHpQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjigRLh4yVraxBgm1y3ALioGMZBGQeZKxFRW6ba
 XV+hKAOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE44gAKCRAk1otyXVSH0HuzB/
 9WjAynKDalpcIRLwuHtG92CavjIal+k3EbR+PndbzgukVbA0eL0TgwTXnZVBZOv8704RBJ+fAFDg65
 ZUTZ/zm/xq3AB57V5gDyO4finnj0qMri8ssD8IsLZuzd0qoHIoAh5/tByW8qaD2G9jJby8NYxj8pdx
 UCp4q4JUoBMr+9O02fqMPdL84FVq7jTi2K7P0nCBcfg7NeXI+4QmHGUIjizEffkUQr/rMEdzf0P47t
 CtiAQrVRflp/3U7Fz24OzDojfqjyok/5RErX+cWaiJ/d2gL/d5nL0GrtdBAZCtOBYwtCjD7kHZ5NPG
 /i6tIS5aSLTCe3DC/iNM3rw/IB9KuO
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
index 4bd333768cc4..509b875cb7bb 100644
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
