Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139077B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 21:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D1BC433D7;
	Thu, 27 Oct 2022 21:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904886;
	bh=ZLcSspCrEAujqgxB3w5RAQ3I8xEQl8NZWfbjj1gmYDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqmHxoloY19+R/xUyVCflXnLqrG/w+fhQPVBurRPTACpQzRAlFuqL54R0ahzhw5HK
	 U5C1L5a1yS/nMLaNh0OoRFi3B+UTdL+cbh9/WR045UHNA9OteRqGq0YAySz70Evhop
	 EeDe3OC++pHbR8EnhmololmBvW8STNVzdyohaAkSoVGJRHaq6/PD4dlpX7cZy+Maol
	 YLuXSmEGemDbI/AHWnm4uqA5jOd4zQBImsPaprULGDEN6KboZZ1Xc/0+GsrlW/txHs
	 0fPAsArnS2FC0MnpxxMSDV7l5Ha+fDdutGXwJ8RSowBsCKXdVfqTrhaRKDMZAGdoON
	 xMV3vTTf+2xbw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 1/2] arm64: booting: Document our requirements for fine grained traps with SME
Date: Thu, 27 Oct 2022 22:04:39 +0100
Message-Id: <20221027210441.814061-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027210441.814061-1-broonie@kernel.org>
References: <20221027210441.814061-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1110; i=broonie@kernel.org; h=from:subject; bh=ZLcSspCrEAujqgxB3w5RAQ3I8xEQl8NZWfbjj1gmYDY=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWvJnOanXYMrPLhinlqShIE5ZFsXdC7kL+FeKnphk wqxrbcOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1ryZwAKCRAk1otyXVSH0GvKB/ 4zeluPJZkJ89ZZnHpBL8n8WZFUjdIR3K2iqdbf0Ex3pYOMKPL6szNgwQMfQHIdCA0gULc8MTBlp3IS 7J5UsLXo3ve5m1eBRSF16/AoIrAVXdkBDLxcdQqUKf9HURH7nl3L6ceZJnZhKHNdlT0ct+UsFJjnQa 05aHSm2tDO+5fHHzhWK4bwdmFbK27W0rExRgNz2mpk4DZ6gtnTD+ECYQunQ7WZ6zFEu9DntCytoUXi AmS5JCtxFC3XwuagM9lwlQx6jeW8pfpJEz81c7BoI5yXnfVB2cYfRO09Lho9on+5TU1BpGaB9jyGUO Jfcv9kqB+gc5v1ci0jjIXYu1NaHPSI
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

With SME we require that fine grained traps on access to TPIDR2_EL0 and
SMPRI_EL1 are disabled but did not document that fact. Add the relevant
register bits.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/arm64/booting.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index 8aefa1001ae5..8c324ad638de 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -340,6 +340,14 @@ Before jumping into the kernel, the following conditions must be met:
     - SMCR_EL2.LEN must be initialised to the same value for all CPUs the
       kernel will execute on.
 
+    - HWFGRTR_EL2.nTPIDR2_EL0 (bit 55) must be initialised to 0b01.
+
+    - HWFGWTR_EL2.nTPIDR2_EL0 (bit 55) must be initialised to 0b01.
+
+    - HWFGRTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
+
+    - HWFGWTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
+
   For CPUs with the Scalable Matrix Extension FA64 feature (FEAT_SME_FA64)
 
   - If EL3 is present:
-- 
2.30.2

