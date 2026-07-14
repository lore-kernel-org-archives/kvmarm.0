Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B3343F4A5;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020612; cv=none; b=IbjaCNaysEiQ9DtFCp+VnWC5PK4HuUIeVKitsekxY63ye2WeHGVTQ0JjtajIsKREvJN/Vqoy3OQSwQ/ARt3ak+t0TxE4Icu6Q/U3E4zmtul63PMRzEvMWawvxuctkF6Q5Vr5efzIdmL3pD7vH827hkoRnKDzPgQ5L9/48QQsQNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020612; c=relaxed/simple;
	bh=JZF1hmXV4cFDalm6HnT0iaROTVAoZE37X/FB0a36Uxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHOVasN5q4D+1etLN1Mci+pltIWWH7KjMgZDIezAzi1lZkN9ww/J80nzf70FrqXoneT2gJD7sQS1RaRa24f8IqSAg7ao91tvgi/zVwHtfnqLnBkgpNWEpARJkHeFtkjArNDfUa4i6DV0UvEDYYIeTkb6s1Exf5m+g4DN+yQSC/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASu1WklE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASu1WklE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B6E1F0155D;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020611;
	bh=AhyYZoRfqIfREPPS8CErWw/Y/QryBhe2Y1Mvp9CHj5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASu1WklEkLG1vueXOA1tIeuMuV/2dzafsobc9Kl4kEwzeCaMyoxguLGNS92sGwtB8
	 0aC090uqhBJxjWTB4/Zab+KPqY5ezinAQHTQi+ZrGnbDrAzMcvvvNQWLOv+2zi6pdB
	 5hGd2du4DtwtvpyZiE8G19vGZ1YPH2MC9dXhWHLbGN6gQI9eFMdtxFqtpvjuzEflzf
	 roOsB2cdzLcX3PSDZuNdi0h9pVp5XY9ufWB3WRgZcuQs5LbS5wG+mBfCjECS2uuqeu
	 gAroniZVEvz7ArmtPtqc3xkIfeARYNmRodJ4hOA2Vd7aYY4sk75QGXQPczBrxN+UrE
	 L9zbtn34RSVMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFx-00000004ny1-2938;
	Tue, 14 Jul 2026 09:16:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 12/28] arm64: Add FEAT_NV2p1 detection
Date: Tue, 14 Jul 2026 10:16:25 +0100
Message-ID: <20260714091641.1970822-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the necessary NV2p1 probing to the cpufeature infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120f..c9c124b0ccc8e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2620,6 +2620,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 			{ /* Sentinel */ }
 		},
 	},
+	{
+		.desc = "FEAT_NV2p1",
+		.capability = ARM64_HAS_NV2P1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.47.3

