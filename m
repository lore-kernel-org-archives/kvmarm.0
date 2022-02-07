Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E26C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:23:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 638DD49ED3;
	Mon,  7 Feb 2022 10:23:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i19LAFM41CbO; Mon,  7 Feb 2022 10:23:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA57349EBE;
	Mon,  7 Feb 2022 10:23:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64D2A49E32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BzmPhulgw3HW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:23:27 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5558C411D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:25 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 20B0BB815B1;
 Mon,  7 Feb 2022 15:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACE2C004E1;
 Mon,  7 Feb 2022 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247402;
 bh=+3VTZZuKVlfj3PHcp/aHFz8BbrWQRRO0ZN8yApxFTHo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=S6e39YuVcqxvURE1dDlybDtE6+/O3bPloBPqXpGC4cx3/aJeZ4vFmguknMx1Il73d
 OvBpKGXFrzr2UPbIM278KTNvi5675X2WWDmL5R+I0jGfp9XO2rYrX/YjOgaeI3HCg6
 fZHNWWFivUptT94eAFlZ+iOcO12nVWwlkhGQuTC57BCPxElHettnZh8yV+xwSJwbcf
 sFnV/xXB6XtYRNtgwC+XPmGgktO1kGyA3JqJvOCXkX7Db6P6Pi8I/0jOS2iMMmTiuu
 BeHDypCWwYdXakuwiAwLHogrdV69vbyIr9FwfBfK/NzR5jNwE0UAC1GFmj6ktBQAKv
 TbZlAeeXLa1rw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 04/40] kselftest/arm64: Remove local ARRAY_SIZE()
 definitions
Date: Mon,  7 Feb 2022 15:20:33 +0000
Message-Id: <20220207152109.197566-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1265; h=from:subject;
 bh=+3VTZZuKVlfj3PHcp/aHFz8BbrWQRRO0ZN8yApxFTHo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjIOOkBxtTD0ogV/fD69P5hPnz9SqSHumCqfc4B
 xt2smpWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE4yAAKCRAk1otyXVSH0E07B/
 0TlC/mxicrwg6RnAylCxB3yQzF3z45C3GndS2h6TJbLqyZPgUp8CbANNcL5GJeFd/9LVR3PGKxMwpZ
 NItKAxS7Qv/OT6cOT0puDG+d739swVYdMSbyAddDnIgE9ypjbEwQlOF3/AGk76IX2ETb1vMyOaoJyE
 1s/O5IFipgYeP1AAweotF/4qkGFPCa1t3qb0CdPOtLW52zkhnLZJU3YUmH3FDpmoOq88Ybme80+Dm8
 ckTPs0IjEPj4AG16yXSKeX+7HAzTD3M906CTW3wVljWYPBxaxoUOGIqSLXpkwwZW33uuDLv4/XXi1B
 /iGh/02ipBtMJwOhSeNIUqhDOCr/VM
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
