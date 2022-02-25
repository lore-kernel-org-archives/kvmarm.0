Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814D6C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:34:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE594B90D;
	Fri, 25 Feb 2022 12:34:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fkKHAXtoL1Xg; Fri, 25 Feb 2022 12:34:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1BF4B953;
	Fri, 25 Feb 2022 12:34:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A504B89F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:34:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1PZESigOKhlL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:34:40 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C21E4B8BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:34:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6487EB832CB;
 Fri, 25 Feb 2022 17:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B5C340E7;
 Fri, 25 Feb 2022 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810478;
 bh=fRMcQGt9qOd9tKyRQTKXjy5IY/TfQbpa6gESCexPdaM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ys+rIwNeFsoa8Iqop1srsvcWOPPUm5CX1Z/5lFm5A/cva9CRnq4PoIHniCBxGsEly
 82+sa03vTZjidhe3Bgn5wSWTI2pSG7GjQrag7gny1wwzieS64GIrO+tLvnsBNVXYVq
 1QPs2ItBAgxjQF2G+wThHqBIm3sM1zqRqQGY98GyyOApj5zj+PXrww8clXgDiUWpaY
 ndc9c0cKYQI3PWILcssqG1MgveeZKMuXjVXz/vBv5N8UoYflXjGdbSlkeOzqnlOPCv
 eZsWyeUMWJ0pQ55LqCsz7RxfXYZm3fpBxDrLqk8v51Vm/dX/+2HTbytj9HTcd0Ng/3
 /pKTQW2SjWBIQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 04/40] kselftest/arm64: Remove local ARRAY_SIZE()
 definitions
Date: Fri, 25 Feb 2022 16:58:47 +0000
Message-Id: <20220225165923.1474372-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1371; h=from:subject;
 bh=fRMcQGt9qOd9tKyRQTKXjy5IY/TfQbpa6gESCexPdaM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrNKAPxCaTE6j9X46xndFOJFEoYQVRk9ykKAar8
 SCU4WF6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkKzQAKCRAk1otyXVSH0LLmB/
 4itWufojjDOWzlLsiLGiSHFkOQoYE+v0SpbmA52Kus2RzLry6YjuIczlaiYgmyFWI5VEXGFNe0hTqc
 6Ns2U9aQF2BhB3AHQeKHQd09DrumME9y/r9yZ4Zql7co4e6Vloe8AnqoI54r8xNrxGAgC2UWJo2V59
 SIUAhhEajyGpDE7oLntbB9HGDJRi8YOAoEOBc76T8XXYsgaxp5QCXVixD0FNXtgXTad0qitFXeIYnH
 RSitWjDUl56HMOIqauEbT9GDHdP/44taqCf3g0PJQ50HazYS1PzVf4pCBwc4JF+llswIX7jEspFDZx
 Y+oFaZklQ6f7Fu+/HgPlldBmyH4Bid
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

An ARRAY_SIZE() has been added to kselftest.h so remove the local versions
in some of the arm64 selftests.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/abi/syscall-abi.c | 1 -
 tools/testing/selftests/arm64/fp/sve-ptrace.c   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/syscall-abi.c b/tools/testing/selftests/arm64/abi/syscall-abi.c
index d8eeeafb50dc..1e13b7523918 100644
--- a/tools/testing/selftests/arm64/abi/syscall-abi.c
+++ b/tools/testing/selftests/arm64/abi/syscall-abi.c
@@ -18,7 +18,6 @@
 
 #include "../../kselftest.h"
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
 #define NUM_VL ((SVE_VQ_MAX - SVE_VQ_MIN) + 1)
 
 extern void do_syscall(int sve_vl);
diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index a3c1e67441f9..4bd333768cc4 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -21,8 +21,6 @@
 
 #include "../../kselftest.h"
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
-
 /* <linux/elf.h> and <sys/auxv.h> don't like each other, so: */
 #ifndef NT_ARM_SVE
 #define NT_ARM_SVE 0x405
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
