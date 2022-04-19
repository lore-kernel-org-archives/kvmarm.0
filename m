Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE24EC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:25:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A424D4B22C;
	Tue, 19 Apr 2022 07:25:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2p6AgnyiZSRe; Tue, 19 Apr 2022 07:25:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEE34A193;
	Tue, 19 Apr 2022 07:25:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60FCE40B6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sxjw+eoMQvT5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:25:24 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3648E4B20E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6F14BB817FB;
 Tue, 19 Apr 2022 11:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FAAC385A5;
 Tue, 19 Apr 2022 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367522;
 bh=gpXYwwHjBWECYd9glOg05wFHftQryu8V/UpzngQGl4Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qEzzxLjdiOogtWlbfRAL/EU2RwJrbiZZrvq45nNHrRWJ6alH6nJAl4QNYqnuPa/Lc
 Q4xk6WWtg/BbZx9RhME4hqD6JrHtjQfK3eosQHALGdjwBTIqfEjBG3wVbzAMOpAh86
 f5sRvOxZUKe31TzPQQw/JDY6YSdaeJvDUTJ1L9q7QgJqtporpvDBFaJ8hkj17fp4uV
 K+Rej2jJ6DDA1UMoOgST2IYueYV60onN/C+hbqv/QKecSWmRHep8QgDYlptaxE2K2S
 s80+xzylOp3jXk+JOk6nurFevx3dREzb0MWZErOuAMFQenq8dWerMEeyAnPsSflMiF
 kJ0f9al1VQDeg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 28/39] kselftest/arm64: Add manual encodings for SME
 instructions
Date: Tue, 19 Apr 2022 12:22:36 +0100
Message-Id: <20220419112247.711548-29-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1715; h=from:subject;
 bh=gpXYwwHjBWECYd9glOg05wFHftQryu8V/UpzngQGl4Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXpt9ghFiAICiyGmVpz7+92Crrpgc79fXtr+9TOpN
 2gK/qxKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bfQAKCRAk1otyXVSH0PHDB/
 4vFkeVNZoQKR+0RdQCX55npyDQalLwxRinrjb+VgVuIvV+MEdSJVPgx9RRwMTwy94DMwPDS9ue2iGe
 KCaexD0jRGIDxoVGEdmHRYwjmA7FnODZwCCpRUzqQ9xp7pLzP0xzoRCw8KjtMY3eaQXmEOB7D8NSeJ
 vDUC1P9vhz+fa/bBXbZudALuSqLSQzaonlG4tW8eEOVttQYJkVPHYVcBGHSZ/H76BHWBVKiOYQzyDB
 Z4PwqCwnbG8fv4x25Yva6md72SUaVOETAsZpWX++am0FusNFgGUG96N/HUagNxsMAcISoFAKThFgF6
 EtrgMKepiPPTgjsnhaL3AMRcYLt5w3
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

As for the kernel so that we don't have ambitious toolchain requirements
to build the tests manually encode some of the SVE instructions.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 tools/testing/selftests/arm64/fp/sme-inst.h | 51 +++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 tools/testing/selftests/arm64/fp/sme-inst.h

diff --git a/tools/testing/selftests/arm64/fp/sme-inst.h b/tools/testing/selftests/arm64/fp/sme-inst.h
new file mode 100644
index 000000000000..7191e53ca1c0
--- /dev/null
+++ b/tools/testing/selftests/arm64/fp/sme-inst.h
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (C) 2021-2 ARM Limited.
+// Original author: Mark Brown <broonie@kernel.org>
+
+#ifndef SME_INST_H
+#define SME_INST_H
+
+/*
+ * RDSVL X\nx, #\imm
+ */
+.macro rdsvl nx, imm
+	.inst	0x4bf5800			\
+		| (\imm << 5)			\
+		| (\nx)
+.endm
+
+.macro smstop
+	msr	S0_3_C4_C6_3, xzr
+.endm
+
+.macro smstart_za
+	msr	S0_3_C4_C5_3, xzr
+.endm
+
+.macro smstart_sm
+	msr	S0_3_C4_C3_3, xzr
+.endm
+
+/*
+ * LDR (vector to ZA array):
+ *	LDR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
+ */
+.macro _ldr_za nw, nxbase, offset=0
+	.inst	0xe1000000			\
+		| (((\nw) & 3) << 13)		\
+		| ((\nxbase) << 5)		\
+		| ((\offset) & 7)
+.endm
+
+/*
+ * STR (vector from ZA array):
+ *	STR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
+ */
+.macro _str_za nw, nxbase, offset=0
+	.inst	0xe1200000			\
+		| (((\nw) & 3) << 13)		\
+		| ((\nxbase) << 5)		\
+		| ((\offset) & 7)
+.endm
+
+#endif
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
