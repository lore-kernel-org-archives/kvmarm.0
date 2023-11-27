Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B656101F2
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKw+rIBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D46C433C8;
	Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085569;
	bh=Fvq0Qx5/5FcSO63oLeAsntiv8dxmQE9SUWOgpOd3RWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKw+rIBF5UboEDItj2MuJzY5ReJ7mbzOYXCH1OMkTtfSrwMnJHC8oh78PKe5kTOB9
	 j40JDprsKgINcyk5oLA6tSw6fQbjViwegUrfgohagbidQK8nPjknwbT+L8UXA7IanT
	 ga/g9/xpwWw7gU09HSYoe9gTRZqaQzmILsdYntiSDn3YAcdXiLZMHmWSgh0vP0Fx8b
	 PvFLOuHkiTtsoYbZkahTvYiXEz20zCkkTPKt0ya0+YesTf+LqKLvKYCB2O/T8JNrkY
	 sH0UrrpbqrT/9iGYm54A8sUcC5BfEo1rSLRNrDsDoFNY2/ZZ1arwEJIx3pRCQBLYQP
	 ucsh/SD2mE+NQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3y-00GleL-8o;
	Mon, 27 Nov 2023 11:46:07 +0000
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
Subject: [PATCH v3 11/13] arm64: Add MIDR-based overrides for ID_AA64MMFR4_EL1.E2H0
Date: Mon, 27 Nov 2023 11:45:57 +0000
Message-Id: <20231127114559.990314-12-maz@kernel.org>
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

None the Apple M1/M2 CPUs effectively implement E2H=0, and M2
doesn't correctly implement NV1=1 (the EL2 S1 PTW seems to barf
on the nVHE format).

Override ID_AA64MMFR4_EL1.E2H0 for these CPUs to reflect what they
actually support.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 57c145bf50b7..f7be459e5ff3 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -326,7 +326,43 @@ struct midr_override_data {
 	const struct midr_range	ranges[];
 };
 
+static const struct midr_override_data e2h0_ni __initconst = {
+	/*
+	 * These CPUs predate FEAT_E2H0, but have HCR_EL2.E2H RES1
+	 * anyway.
+	 */
+	.feature	= "id_aa64mmfr4.e2h0=0xf",
+	.ranges	= {
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
+		{}
+	},
+};
+
+static const struct midr_override_data e2h0_nv1_ni __initconst = {
+	/*
+	 * These CPUs predate FEAT_E2H0, but have both HCR_EL2.E2H
+	 * RES1 and a non-functional HCR_EL2.NV1.
+	 */
+	.feature	= "id_aa64mmfr4.e2h0=0xe",
+	.ranges	= {
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+		{}
+	},
+};
+
 static const struct midr_override_data * const midr_ovr_data[] __initconst = {
+	&e2h0_ni,
+	&e2h0_nv1_ni,
 };
 
 static void __init apply_midr_overrides(void)
-- 
2.39.2

