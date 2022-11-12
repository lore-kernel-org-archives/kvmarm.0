Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5434D1C01
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A942C43140;
	Sat, 12 Nov 2022 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266273;
	bh=x4bmiErZJ7SZyMFRSsk5JKsWnPXrlyR9WZE/FfpAobo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n834n9xYigEzQcnS+ISbZw8BAZX3MMSaT/TL5F0yozxQ7/5Sr0a9zWwUY7fwAtl4l
	 d8FuXt6qIZKAEbOAJNA+ZwfpNLd2tjtKWBwxA9NzcVZ2ah9QD89ZlE4bxSsLymELVJ
	 6UA5WkXSXOJb+R+ohhUX0AMwtt3Wt1ov6tGUwyvyvHWD66T+phAcqndUBqOd2zGlVB
	 I+QTn4gw2rKKC3aLEEU10X5MOTydMa7YyopHtIFDDTsBD67V39mWy+F76B4pID2HzU
	 d6ypTnzgMEdRcZeVmkrL5qPfPGtRy6n+vFpWzYHpBV39B3QmYS8kE62lOYOZxkHBds
	 Uds97/4b6L7IQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 04/14] arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
Date: Sat, 12 Nov 2022 15:16:58 +0000
Message-Id: <20221112151708.175147-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2341; i=broonie@kernel.org; h=from:subject; bh=x4bmiErZJ7SZyMFRSsk5JKsWnPXrlyR9WZE/FfpAobo=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jpAQOBqUkutL7vHrnFr1g+2sG1otffMzqRe+hO UMSeKw+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+46QAKCRAk1otyXVSH0P5LB/ 0Wag/kVRLMLup8h6WKe999vdDlGGMOfNSdxCPL+3yyNwXR2cKYYRgin2ePDt9K5ejmvvF6iwvXa2eT sLboNoGQIDLYgcPSCDc8BfGmIhkd3g8HPThYS4SFbGqWKX+bvbw69Ji1082rnd2JlnuSAw+7lsUhkc IQiT75UxrsRgof5dZXR8Q/72ZLeE2MXch2CY+Z+3zxCXjdPaVARmyQ5CnfySPeEJU9vDoQzYXskDiC Sg6Ot8FQr9h9r5vMttkE7K+XZaayK4my6JmCGynFl4GhVzUdL0QexXEQgZt9V2GXLjs1KIiyk22m/z kWmZBoFTB1QAFD5Z+ijbLaUFU/v/tG
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Encodings are provided for ALLINT which allow setting of ALLINT.ALLINT
using an immediate rather than requiring that a register be loaded with
the value to write. Since these don't currently fit within the scheme we
have for sysreg generation add manual encodings like we currently do for
other similar registers such as SVCR.

Since it is required that these immediate versions be encoded with xzr
as the source register provide asm wrapper which ensure this is the
case.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/daifflags.h |  1 +
 arch/arm64/include/asm/nmi.h       | 18 ++++++++++++++++++
 arch/arm64/include/asm/sysreg.h    |  2 ++
 3 files changed, 21 insertions(+)
 create mode 100644 arch/arm64/include/asm/nmi.h

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 55f57dfa8e2f..b3bed2004342 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -141,4 +141,5 @@ static inline void local_daif_inherit(struct pt_regs *regs)
 	 */
 	write_sysreg(flags, daif);
 }
+
 #endif
diff --git a/arch/arm64/include/asm/nmi.h b/arch/arm64/include/asm/nmi.h
new file mode 100644
index 000000000000..067e2554e144
--- /dev/null
+++ b/arch/arm64/include/asm/nmi.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 ARM Ltd.
+ */
+#ifndef __ASM_NMI_H
+#define __ASM_NMI_H
+
+static __always_inline void _allint_clear(void)
+{
+	asm volatile(__msr_s(SYS_ALLINT_CLR, "xzr"));
+}
+
+static __always_inline void _allint_set(void)
+{
+	asm volatile(__msr_s(SYS_ALLINT_SET, "xzr"));
+}
+
+#endif
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..0c07b740c750 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -126,6 +126,8 @@
  * System registers, organised loosely by encoding but grouped together
  * where the architected name contains an index. e.g. ID_MMFR<n>_EL1.
  */
+#define SYS_ALLINT_CLR			sys_reg(0, 1, 4, 0, 0)
+#define SYS_ALLINT_SET			sys_reg(0, 1, 4, 1, 0)
 #define SYS_SVCR_SMSTOP_SM_EL0		sys_reg(0, 3, 4, 2, 3)
 #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
 #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
-- 
2.30.2

