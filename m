Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FA3C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:57:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFAA84B267;
	Fri,  8 Apr 2022 07:57:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uOGO5h-pS0s6; Fri,  8 Apr 2022 07:57:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 851524B261;
	Fri,  8 Apr 2022 07:57:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 195674B26C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zhmxvmhBU2K5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:57:09 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E4B949F20
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 644B662050;
 Fri,  8 Apr 2022 11:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE37C385A1;
 Fri,  8 Apr 2022 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649419027;
 bh=gpXYwwHjBWECYd9glOg05wFHftQryu8V/UpzngQGl4Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qTIjKnqMpfQxYBRzSXWkSn5ASzsE2m6o2vPofai7dtcuXJ3syAYxkhVffWdutI4cS
 leqdURAz4aLSlR/2G4vLDC/3+QeRqRVmFu1DasTvxub65KZ/JATJ/jNdkFYU9YGiNn
 q0at/nPQaX/elLteiMZdDk6tGe05nDFVjYSbiXAcyrO3GUAxwN2JaNjSORGuJhfn8i
 emv8TxvW1rju/NpDeasNKkPN+B5pNVWfNWHgliao62VSKsb2v7em0kmlVH2XWvQH/W
 TdVUWvVx7VX/+0OXmgFNgXdPJQ65zczwte3L8B8/uvY1By0xZ1ySN4yis9aCUdhguN
 DySvSvOZdHVug==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 28/39] kselftest/arm64: Add manual encodings for SME
 instructions
Date: Fri,  8 Apr 2022 12:43:17 +0100
Message-Id: <20220408114328.1401034-29-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1715; h=from:subject;
 bh=gpXYwwHjBWECYd9glOg05wFHftQryu8V/UpzngQGl4Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/VghFiAICiyGmVpz7+92Crrpgc79fXtr+9TOpN
 2gK/qxKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAf1QAKCRAk1otyXVSH0P4jB/
 9OcwOzpShaEt1yP+r/4CDqd0n/Ys5lZaNN4Um+/2+TaTYZ4R+P5tKuhs8ZWnB2UipmGToScR2n/Vs3
 4GkRKeqiAZjWIdhgZGfRJeRW6zw5voatePmNAzUDUe232e/IQJT/I03T/vVia2/noNMUIjUg94jgaL
 ina9jzFldZfgiexi+Of8885P/zq81phV8rdmOd4NPzVodreEhrygqm6r+Y6CPwoG4EVNIfLItXKHXa
 NcuN9lMQYum8Zp4M4+bOeiJ5pRpWyWD9p5l4hUsus8+MmseALdKqbcoDQQ/pMr7ck9UK6RI+d4Yq0n
 KK18tWpyoG7PFLYi2ao9KdvIOpQzJm
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
