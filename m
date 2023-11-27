Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F471A710
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noNwu23k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A11C433CC;
	Mon, 27 Nov 2023 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085567;
	bh=HhSotA3vRVZkMJz+bs52JYjxX6yqRZHYA/aP1DuwyDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noNwu23km4xQTwlg47RqkRE1ZFxitipsNyb6nZM6f8w8EXFSRqZD0AcpBIWkxVI0J
	 asoI3Hr3SuBgmYRHpSit1rdqvI2APUnFpVnmpvkf5B4E5or2cSnQnHuDLNt6Gbp94Q
	 ub9SBpw8ZpGddO6kiB2bYRCGrT32gZe/J2IFfKtBiQnZF0YtpHgNnHME9TxJxZbKMq
	 THYrsf66ggF/Pxr2Ja01qORegji8mPllBHh5yWC3VRUB4ITUzS6g2AuDN4ZrPyVJ1Z
	 O5izk6IIRPpTMtEzuETWeyiZGANt9X0FSK762qRpIHYY1CFB/wLtf08jfOfoXJU3Mj
	 vbEquAL0fllvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3x-00GleL-CR;
	Mon, 27 Nov 2023 11:46:05 +0000
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
Subject: [PATCH v3 07/13] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
Date: Mon, 27 Nov 2023 11:45:53 +0000
Message-Id: <20231127114559.990314-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
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

A variant of FEAT_E2H0 not being implemented exists in the form of
HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
only VHE is supported on the host and nested guests).

Add the necessary infrastructure for this new CPU capability.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ef9811f7bb7..64a026cc5cec 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2793,6 +2793,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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

