Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3052D025;
	Thu, 26 Oct 2023 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LO0/MNI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A68C433CD;
	Thu, 26 Oct 2023 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324408;
	bh=StlnPCfdiEmTpFedQBxetyCeCnpVA1cVpZaBcOnDm18=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LO0/MNI6L6M+MuomX40QF1R89KAblQV6tWAxPl5U1HKGIyUe0hLGhFc5qOUlp83O5
	 OYFFyntpnJtlJ0GPdQpxvgQNew/REUuy4LR9YfJMM0iPCkjKJDBB2EbROsSq8abd5b
	 FdAZSiNHdgJqYLzET3wzVFwEQQY4LsuD53Z1vD+DpG9UdBwNgvELnmINZilh6aBNiA
	 vL87+SrFNoW0jOcpziXPscop9/9CHloGH1U1d3+9aDuasEG4REhxFxLiV3H1IlZAYS
	 014Hs8xx3WLlRYP5syWloVDW4cl+OnAya1RMRDY/tcAciLtI20yHp4DJOJ766lTaZb
	 iixhjARLQc+PA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:19 +0100
Subject: [PATCH 05/21] arm64/sysreg: Update ID_AA64SMFR0_EL1 definition for
 DDI0601 2023-09
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-5-8470dd989bb2@kernel.org>
References: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
In-Reply-To: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1275; i=broonie@kernel.org;
 h=from:subject:message-id; bh=StlnPCfdiEmTpFedQBxetyCeCnpVA1cVpZaBcOnDm18=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+YYTYGNwDclkV8Cejs/Nd9eyzj5m/o2YONPdzn
 Dftj5y2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfmAAKCRAk1otyXVSH0PieB/
 9HG1kjUqAW7HNGOatYBFGODvknlGLH3+0WYDFg9AMSiGWdVsoFqBJcD3rzC1BAyUUobOdk3jcIuvJJ
 aj03EBxlHL4l4zPZql170+ACdx6qZz4TV8KIwTzahsx2EMNbSG9kmiSCHBr0m03qTce1vVt//9EnKB
 it40w73rmHEPdKZoLsM1gPLaof/ywCsubOg8YmXarEUNK/jzPhCrc4tOvWpjaGRyzjpAH7QQ3HhIyS
 Y0pONTQQXobneELwsJGTMzT6HuLFf8nqGjngKTkC+pR9HinRWZnMbqNipxxQqfFJRiTExx+Yr+dwdG
 3z3DJlehLEWGg28jpfafIjUa3HlY21
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The 2023-09 release of DDI0601 defines a number of new feature enumeration
fields in ID_AA64SMFR0_EL1. Add these fields.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 057cd85d8c2c..91dd564ee4d3 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1075,7 +1075,11 @@ UnsignedEnum	63	FA64
 	0b0	NI
 	0b1	IMP
 EndEnum
-Res0	62:60
+Res0	62:61
+UnsignedEnum	60	LUTv2
+	0b0	NI
+	0b1	IMP
+EndEnum
 UnsignedEnum	59:56	SMEver
 	0b0000	SME
 	0b0001	SME2
@@ -1103,7 +1107,14 @@ UnsignedEnum	42	F16F16
 	0b0	NI
 	0b1	IMP
 EndEnum
-Res0	41:40
+UnsignedEnum	41	F8F16
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	40	F8F32
+	0b0	NI
+	0b1	IMP
+EndEnum
 UnsignedEnum	39:36	I8I32
 	0b0000	NI
 	0b1111	IMP
@@ -1124,7 +1135,20 @@ UnsignedEnum	32	F32F32
 	0b0	NI
 	0b1	IMP
 EndEnum
-Res0	31:0
+Res0	31
+UnsignedEnum	30	SF8FMA
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	29	SF8DP4
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	28	SF8DP2
+	0b0	NI
+	0b1	IMP
+EndEnum
+Res0	27:0
 EndSysreg
 
 Sysreg	ID_AA64FPFR0_EL1	3	0	0	4	7

-- 
2.30.2

