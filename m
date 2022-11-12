Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B171C01
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CF7C4347C;
	Sat, 12 Nov 2022 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266275;
	bh=Xq08mhoup342EiZ9bYeTaFofVY8FR10JeSgIAY6YAdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9jONzeNWKDrEoOKg9ozqXT6SP/hkb4l9cU5WpCCFPZAZGfQxkH1bjG4cvZMjOHlQ
	 jpd2Nn/fbKtzjkRmAFytgzNmy95Vha+L74e/rjgIQmkjd7KE9HI3oinX7mQdBiCHnK
	 4lJsamOUbo4eAJOXpuSh/eYAZ1aERCO9brhcPOP2a8VQxDXGmR2H5lxJI/jkF5OJR5
	 Di3zgLkANcXxzS6e2mE78lpyr21pGOV8rSCDZNLF2XEA7hN2VGVacYnPyNTzwLjVwH
	 fS6oOGAjEfoAi/PY6dpPw2MjSv3aqf8nio//dTbLNec3CobFTZ+6Eyj6I7ABp2MPHd
	 CYqb26mndSp7g==
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
Subject: [PATCH v2 05/14] arm64/asm: Introduce assembly macros for managing ALLINT
Date: Sat, 12 Nov 2022 15:16:59 +0000
Message-Id: <20221112151708.175147-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1206; i=broonie@kernel.org; h=from:subject; bh=Xq08mhoup342EiZ9bYeTaFofVY8FR10JeSgIAY6YAdU=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jqY7S43ZCtooFkOcWMZlvWaRGZwDrK8Cff1sxZ X4Zn+CyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+46gAKCRAk1otyXVSH0I08B/ 0TOihpKb/dkI9f6q+hcwxPZLOFjsUhvcimBt+0vZ4I0WCNO6JQNmwglLUiY2QlH2z5har91PEtR8BX +nKC1Q4Ndlgnjquuqmgtvy841B9uJixc4FrEeK7UFRZT+CqDsGIBU+w+R7ycrSmqDvh2iBrwUPchXJ KI2Y1IcXS51+70QEXSHd0KjryYNbd75bbPVeyKBRIa44+NJnHEV2ZEi9GuMpa0HF6gqHoxORXwVOsZ +Qi7FlC2JJXIAvhM8k2dv7KBX0QJfQZCsicoYPnZ+IMDl4+UpbwC52XxjBDALvCZo6vRzp+pvNZttx Csi5y5RABygRavYpbLR68LY/5o0gbv
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

In order to allow assembly code to ensure that not even superpriorty
interrupts can preempt it provide macros for enabling and disabling
ALLINT.ALLINT.  This is not integrated into the existing DAIF macros
since we do not always wish to manage ALLINT along with DAIF and the
use of DAIF in the naming of the existing macros might lead to surprises
if ALLINT is also managed.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index e5957a53be39..88d9779a83c0 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -34,6 +34,22 @@
 	wx\n	.req	w\n
 	.endr
 
+	.macro	disable_allint
+#ifdef CONFIG_ARM64_NMI
+alternative_if ARM64_HAS_NMI
+	msr_s	SYS_ALLINT_SET, xzr
+alternative_else_nop_endif
+#endif
+	.endm
+
+	.macro	enable_allint
+#ifdef CONFIG_ARM64_NMI
+alternative_if ARM64_HAS_NMI
+	msr_s	SYS_ALLINT_CLR, xzr
+alternative_else_nop_endif
+#endif
+	.endm
+
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
 	msr	daifset, #0xf
-- 
2.30.2

