Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B989922EFC
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXyEW/bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D58C433CD;
	Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897425;
	bh=MtPSu5LUzrRw8/ng+e1jkKKFUThsGpUNJoMyASnhWfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXyEW/bF2OqunvYtWjlnOoR6s9h+kG37I1JUPKYWU7NkLWlI41efy9eCs9hkZNAjx
	 XP6CtFf96laIT6U1xN5y2KsaFDzcOiA9LYerkYTMjVgbZImSW9YAS+dWyKQ1lA8ao/
	 eOZgmmNyR4NwligNEiNIWQxTTSXVV/gj5X0MftO9v8RFkbxQGnzhbomNIRQ+O+vr/e
	 /PmysSJaTJINXC7bX9qE3eHb+Kg4m7WKzQVvj3wTTp+eQYkrCtVxM7EPpTwW2nSOy7
	 M02PZuq1nhXtl/9SlbPmiN1uEQsqthoMzY7RNOgIS+NTKT2nQ5XY0QthhMnhwepEvm
	 pmj5jpngHEsQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayN-00CkQ4-NR;
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
Subject: [PATCH 10/12] arm64: Add MIDR-based overrides for ID_AA64MMFR4_EL1.E2H0
Date: Mon, 13 Nov 2023 17:42:42 +0000
Message-Id: <20231113174244.3026520-11-maz@kernel.org>
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

None the Apple M1/M2 CPUs effectively implement E2H=0, and M2
doesn't correctly implement NV1=1 (the EL2 S1 PTW seems to barf
on the nVHE format).

Override ID_AA64MMFR4_EL1.E2H0 for these CPUs to reflect what they
actually support.

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

