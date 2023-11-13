Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F1422F07
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caHPe0cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CFC433C9;
	Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897425;
	bh=FnZ4kYwF2iimP4yf8r3esEh3L5uELbTgTCOPS2apUzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caHPe0cKcuYSII5oXODMM9WHkTo24echQm5r7/micpY6XTdiQzi0vJZwPbrZ/94AR
	 u1yq/olZmDsuju/RdsQR5sDxP47jnfYO+yYz2rg+wMji/EXsLuJfgLjLOi0mIk6xD1
	 HAGSfzrRZCjH6FS1Kf9ARNDM3FQKcjk8lVlvR7vqADyrPczvYg/LUYVJFuF/RFGWF5
	 kosFA8mepCPn0A12GfNnCt7fQXF39tY8SZne7o9SAqr9hwh6Y1oWkTb4cuKYfvjc73
	 tZiRzFjHFznJlVSZ8/dvuUA1H1Yqiy/Uq4FVlkrXcyCu+Kh+N6xLO+obthcNjmoOL4
	 GT97gduAEO1zg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayN-00CkQ4-0W;
	Mon, 13 Nov 2023 17:43:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 06/12] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
Date: Mon, 13 Nov 2023 17:42:38 +0000
Message-Id: <20231113174244.3026520-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A variant of FEAT_E2H0 not being implemented exists in the form of
HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
only VHE is supported on the host and nested guests).

Add the necessary infrastructure for this new CPU capability.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e0d64e8b4851..a733c9a83f83 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2794,6 +2794,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI)
 	},
+	{
+		.desc = "FEAT_E2H0 not implemented (NV1 RES0)",
+		.capability = ARM64_HCR_NV1_RES0,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 8866ea9bf995..fea24bcd6252 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -53,6 +53,7 @@ HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HCR_E2H_RES1
+HCR_NV1_RES0
 HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
-- 
2.39.2

