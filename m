Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2972C1B270
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxgOtxzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01306C433BA;
	Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700483867;
	bh=lynjrJEz/BHjtI6s1T8jQIpyNGuzaukrA+2hTJuP2Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxgOtxzgBfL3MrT+WDvbYYZ+8lmrpyKaunIiejSDZ+81ZgUXpmxcIvpCsWFwGPP1o
	 ZqF3C0z1pnUJqAGcg+1ttwo5jVsjAegnmkTL/hYiVD6LepakHsreVwYiz7XH2RFq5G
	 LjQDBwUDEvqcxWU+JE4VlZrh9N1H54HVjsP9LWGQ9mcYmcmJLUJTp73Kbffecln3dG
	 GwGjq2yTzLkBdBJ9V/rUMxKTKAEBU2YNcBXYVymjHSOr4/8cPUF6MpcYft2A/piMtp
	 gkTrVD4KjmKandlBdCsT4M0m9yizUDLBmiznb2wyjB/P2JDfOkGGX2DREw0wzNLIfE
	 tb5xEMYmKG/nQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r53X6-00EjJv-UR;
	Mon, 20 Nov 2023 12:37:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 06/13] arm64: cpufeature: Detect E2H0 not being implemented
Date: Mon, 20 Nov 2023 12:37:14 +0000
Message-Id: <20231120123721.851738-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120123721.851738-1-maz@kernel.org>
References: <20231120123721.851738-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_E2H0 is a new feature that indicates whether or not HCR_EL2.E2H
can be set to 0. Amusingly, this feature is set to 0 when implemented,
and otherwise negative.

Add a new capability and detection infrastructure to detect the
absence of FEAT_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 41db7f993eef..e0d64e8b4851 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2787,6 +2787,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
 	},
+	{
+		.desc = "FEAT_E2H0 not implemented",
+		.capability = ARM64_HCR_E2H_RES1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b98c38288a9d..8866ea9bf995 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_TIDCP1
 HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
+HCR_E2H_RES1
 HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
-- 
2.39.2

