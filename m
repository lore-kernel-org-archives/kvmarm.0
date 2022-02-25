Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198D1C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62104B9C5;
	Fri, 25 Feb 2022 12:36:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVcT6u5OYZ1z; Fri, 25 Feb 2022 12:36:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25FD04B9B3;
	Fri, 25 Feb 2022 12:36:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E04C4B9E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hMF1EuQpvfin for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:36:53 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FAC64B9BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:53 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9205861DC2;
 Fri, 25 Feb 2022 17:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9665EC340E7;
 Fri, 25 Feb 2022 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810612;
 bh=VP39Sz8xXdHTR332ZEKFGAMy73sHTB6WA1vSUKKqVTM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uLwEJHz6LPfzVX6VN6gjuePxis0loLzKfT5svJRBB/NuqEaIv6bTfezEbBBLXJp6/
 WIpMRmynB2tWxtIr0sGR4wSPLJlSmQ98MKvuo3pVItShrREUYOKSR0r7/dRk+xwcl8
 VEitsxLQHbL3562G8DWDVjRLW84aHvGKU93aoPVduqpQZEMSDiMAzYIROp75WA+Udd
 qolZf7EPDJZSc5LumvFYTIjP/uzhOo8vus+UADyWEXz5/iMLOb1M3INYzRLCA9sS7z
 j2pozxqHkyztrPSCbQMw8UuJCAi1+2LfXgPv1EGbo/25SNqM0Z249rA8b0UUw0Qrtv
 CQfVNZUxBY1Fw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 38/40] kselftest/arm64: Add streaming SVE to SVE ptrace
 tests
Date: Fri, 25 Feb 2022 16:59:21 +0000
Message-Id: <20220225165923.1474372-39-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1379; h=from:subject;
 bh=VP39Sz8xXdHTR332ZEKFGAMy73sHTB6WA1vSUKKqVTM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrovzSbVxpDH05TM1MgmmY9SCvhJIZDosEanwhi
 FPBbfBeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK6AAKCRAk1otyXVSH0BXRB/
 9iTdobqL8RmN2epeBE6bXWRXNnxQLW2YvP7LVmLgE3DARQw3BXMALJgJkjsqeRWF6eAH/IWv7fXzJM
 +bjqicF/y8vH5SRwxZynLYY/i3xsINiNVc8R2CBf1T/+IihWpE2nTfTbu27MW/PLGFcbKTS2TPLrQg
 T3152cyad6uSrOTfXViEwBAw78ZiKLyCsUkyyIkmun8TZmwuD+xfGU++nj6QYzNTged/yei7KuG6W9
 USol5QQGR3QJXBPMhQG8M8i7b098AC7eoisJEwvd/qA7QyV+JjDGz/PI9Uu+Sh/xR3fExmo1IrTkuE
 dnIJs+1d9YfNdDVQh5FkZMOxKlChfq
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
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
