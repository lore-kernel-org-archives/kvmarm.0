Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB11A184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBCCC433C1;
	Sat, 12 Nov 2022 15:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266270;
	bh=BQ7I6eN+6GZ/o5t5Vk4K6cshxfRrAyFnFSi5m4uTojg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rsw0aabbBIrmC4/S/C6JJwUcKSz7Ji5GOqkBGBfjZhjrySrGoHh7KpzHdWhhRIxN7
	 NGPl00ZlnExi/TzP2xv94T1nwOGoxUaOIwaPFGPu7Oh1oV7jnshVtxrqJGGeuzekYO
	 v5lm+5RJ1S5GJSDMgVXML4YZI1ZBzu58g4NUFZFqergjUzQLXKpgh9pyWMe3RVZxUY
	 v3AEa01pmdjhNieRDRFPcvOZ4sT5pjUszxOP0FS1jsyhhY5qc4KeBCpXPxE/xE8QpH
	 3hZ/7FiQHl6CcFLkNF9UrA5CiluNNuQuY2zh1/cw1vXPeKEJQ18nnu5WOw4h50NSY2
	 x10IVwWSMvcTw==
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
Subject: [PATCH v2 03/14] arm64/sysreg: Add definition of ISR_EL1
Date: Sat, 12 Nov 2022 15:16:57 +0000
Message-Id: <20221112151708.175147-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=701; i=broonie@kernel.org; h=from:subject; bh=BQ7I6eN+6GZ/o5t5Vk4K6cshxfRrAyFnFSi5m4uTojg=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7joOOLN0FUshrdiNy93qhEC4keUgDrC3s0fn6P4 8eod0BiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+46AAKCRAk1otyXVSH0D5/B/ 47ok/13qm7w5flwldiCm+v13vfeH5VIGXqc4O2M3xJQg2wMXgFY0dql1G+athbEUI0UGmloDBLQlm6 AtWzy3fxaPTHmZnnp289+34bYRjeltlMqVpjbjy8b723EK0pnN/PmQwTiG0o/0dcljPrF9Cj4Zg4xl GCuy7+ZO1tk2EqFE8BXPVFBbc4Nli0NrATrrBRHq0PnOj3BKzS6V3IBjRcShNZ3YGkK2bzKcY5wJgK qXBxW8ge8QJ2EPNnACivbOBdO1ja4OrhMazYbFb7KoIOITFP7TxfoEpkFAuS81RpQfjumKCLdI385l /lOr76aPfVQlcIUOw6OeB7XLVM8t+j
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Add a definition of ISR_EL1 as per DDI0487I.a. This register was not
previously defined in sysreg.h, no functional changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 5d0d2498c635..3660e680b7f5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1079,6 +1079,16 @@ Res0	15:8
 Field	7:0	LR
 EndSysreg
 
+Sysreg	ISR_EL1	3	0	12	1	0
+Res0	63:11
+Field	10	IS
+Field	9	FS
+Field	8	A
+Field	7	I
+Field	6	F
+Res0	5:0
+EndSysreg
+
 Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
 Res0	63:24
 Field	23:0	INTID
-- 
2.30.2

