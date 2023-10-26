Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A40883A;
	Thu, 26 Oct 2023 12:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUJ9b4fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B8CC433C8;
	Thu, 26 Oct 2023 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324398;
	bh=/C6uYsNf+k2NYJmRn5HC5d00qPbiUk6gpp6lP4Wus70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EUJ9b4fHPp3NmHoLuIb88u3yL123ulXXTz8mujws9Nvs7FXm0ek73iIlGFF8lh4Nr
	 e/whfA+AvR4Fp2ezXzfdeJLxQBgqoF+WSGQAP2IaLud+oswU7x4Leg0IL+wVCg/Shc
	 8I8c6bRC7FqrdU17LGJeTP1gt8NJFBMAGjvd3Q/bnuLCVo0RX0O1UGUIplQFxgUBK2
	 j6qSr4pOp9he+ibX1SENsyure3AZqr8I262GKRrDehY1CUv7gFTYFjjT+owxn7lENW
	 uBo5NLBHAPUNj1VpBVdYB4igB67u355AjMXRoJr313OhSkRkaiPNVEcBr+xEJTtuBG
	 /7UraLii886ow==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:16 +0100
Subject: [PATCH 02/21] arm64/sysreg: Update ID_AA64ISAR2_EL1 defintion for
 DDI0601 2023-09
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-2-8470dd989bb2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1340; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/C6uYsNf+k2NYJmRn5HC5d00qPbiUk6gpp6lP4Wus70=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+V17IIomDsq6mCMkzj7i309UYGqYyGh1zX2T6k
 nCRjH1aJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpflQAKCRAk1otyXVSH0AOkB/
 43X75EYFjRwcuVXX39Xv05Sa90HaJ801YZGPlMrODCNF59tx26HSQ8zz/8ttHJRSN++ro0N3DoRhwi
 SN4BgwpET5XQYtZ+GKA0nkJXntCc7MEWki9fnkR7j0zCnlsEMukScx9/spVWVc4Sk/pRbVh9TdjMkk
 IX6mg9pHgvRuRsicEkGGTLDjblxL8INuv2ERRxmaviQeTrW8CzFfCZyYAyEWehBMS27xSm7gZYA46k
 GScd4LXFgaxzDFeWNVmS3+UntLG5MlokoB9/7y9IokOtjqRkjxRBiehitDE9CIZvRHtSnIhY40d+Sz
 /9L3Yt1nsp3ZYE+yWsgFdBng60vJwU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

DDI0601 2023-09 defines some new fields in previously RES0 space in
ID_AA64ISAR2_EL1, together with one new enum value. Update the system
register definition to reflect this.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 0ea93d166f48..fcca3a3714b0 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1359,7 +1359,14 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64ISAR2_EL1	3	0	0	6	2
-Res0	63:56
+UnsignedEnum	63:60	ATS1A
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	LUT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	55:52	CSSC
 	0b0000	NI
 	0b0001	IMP
@@ -1368,7 +1375,19 @@ UnsignedEnum	51:48	RPRFM
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Res0	47:32
+Res0	47:44
+UnsignedEnum	43:40	PRFMSLC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	39:36	SYSINSTR_128
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	SYSREG_128
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	31:28	CLRBHB
 	0b0000	NI
 	0b0001	IMP
@@ -1392,6 +1411,7 @@ UnsignedEnum	15:12	APA3
 	0b0011	PAuth2
 	0b0100	FPAC
 	0b0101	FPACCOMBINE
+	0b0110	PAUTH_LR
 EndEnum
 UnsignedEnum	11:8	GPA3
 	0b0000	NI

-- 
2.30.2

