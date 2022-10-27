Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36AF7B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 20:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A32C4347C;
	Thu, 27 Oct 2022 20:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904088;
	bh=/AKwgKBPS34TJN9xSbPvH4wu8dyp6VYAWHZyFzMFBnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpVheP2fqZFjtrKGL1aJjo7xXiAV2MuOHnu1RiBvo8XcG6hntz/kBH/weenAzDuxU
	 OmS8OU2u9iZtQIi7wCdWCj7PqIPI1g81E7BU6S7fiU1hqQb5a/QZ88qlA4uwjyasoV
	 Qvda5BKHXFe/jdyXTMC6SNvCBeMnm+kW1O1pXA4yhH8A0B6NFKwkzdVCJDzwkNWuLl
	 MPLF71F9+oyjYcY93wGCzskEZ52NUWBPKaqZoHIdYCyGe2y9yKf6QBLpKUgR/P1td4
	 J0jBKwee97HdxcgmJN/gIZ+/syRPx3JSHatVynP3ETD/Emlanyg///VM81DqFL4Kr2
	 lD0cEHiu4e1+g==
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
Subject: [PATCH v1 1/2] arm64/cpufeature: Add feature detection for fine grained traps
Date: Thu, 27 Oct 2022 21:52:45 +0100
Message-Id: <20221027205246.812586-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027205246.812586-1-broonie@kernel.org>
References: <20221027205246.812586-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1628; i=broonie@kernel.org; h=from:subject; bh=/AKwgKBPS34TJN9xSbPvH4wu8dyp6VYAWHZyFzMFBnQ=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWu+dcWQPnyvrmOR/gKkknxog/b3aiZIuoy/0eD/8 6SZ1pCmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1rvnQAKCRAk1otyXVSH0Bq7B/ 0XDvJXAeTTVFp75Ogtab9ldE7yB0M4JhkrH7Jtf5aFtnIIZQ8cC8M0P85LH0mPs4baIXkbHsm3XV60 9MgzuW2DjWjShxJDDb3JmdLvdCpDZKIDC8GtHg9+mTleu6hhppaRuomchW/OHTKRwbzceAum3xmRbt oreobvdS1qlTNw8hBxYcvAmlIdqbMMAzntXrDaN9mT365GR9mrsv7czL3haFHk1zcLCBz9Mx/5/maY VpFlczMLyKBrui6QnQENiMDsN77FB3ZXWpGnjw5bzCZNWPsLixK6326KysmnWQOed8mIwR3lr8pxkz p+DZoPysXY9ag+FBHHeq69qTJzfpvd
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Virtualisation support for SME depends on FEAT_FGT since it uses fine
grained traps to control access to SMPRI_EL1 and (for nVHE) TPIDR2_EL0
but systems have been encountered which implement SME without VHE. In
order to work around such systems we need to detect the absence of
FEAT_FGT, add detection in the cpufeature code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6062454a9067..8ded72a8ccee 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2590,6 +2590,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Fine Grained Traps",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
+		.field_width = ID_AA64MMFR0_EL1_FGT_WIDTH,
+		.min_field_value = ID_AA64MMFR0_EL1_FGT_IMP,
+		.matches = has_cpuid_feature,
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index f1c0347ec31a..2553c7559412 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -23,6 +23,7 @@ HAS_DCPOP
 HAS_E0PD
 HAS_ECV
 HAS_EPAN
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5
-- 
2.30.2

