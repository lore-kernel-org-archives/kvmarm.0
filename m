Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C4739EF05;
	Thu, 30 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395461; cv=none; b=VXhzbJuRyOua12wRjl4HIjRUo/H3VnKwnNx62FfvrpE/sWsmfKLs/0IbDU+RRHFCeS/IWG5cnVdu5t81/dOlc/3OaHAsXvTi+vOYd88AHaBLpyE/2HJiq/6+7Em/Wf+SnTMk/iYpXA6jS9nF3vmsfX57Ejbt/uIWQyPL+qGwZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395461; c=relaxed/simple;
	bh=E92GD4p3gX7XN+ukjTVmDB/pJ98hKkE/aeNbkjXvc2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxg9lyNGG6gs7mx6pPkcxRiGdTqVgDHiDPWWmR0YV2hHSxScQTg31n/Hi4hR5UZCM+zi49ZA1r5JYWjxIZUmotJmwLg/Qc3ph3v9OgIJCzTZf4HjwJQu4mmCl5qm3vuHrZXaQt4YZr+fdf0vCaNaC4+OIxctF2P77uYfwgEwPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XD9MLmlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XD9MLmlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE711F01559;
	Thu, 30 Jul 2026 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395452;
	bh=z8cY/iQXo/TDFoSsAUyRfzYopAfoD86sWfH2T0S03zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD9MLmlrVBZfdEOH9WMwmVH22u80Nl/6Mc1d1APYi+25nu4m3SAdlCSq5EIgeLPa3
	 SGcO9eek20QV0zB5m2kK8C9jKF0IPY5NAQPqu5klNs7gD+2eS1prYlhznrqqXpAauL
	 vs5HIoh9leskeR2ZFYOw2m3nYu4Qk0yXIYYZwkn6KIg8TOhs0GUl7fAiC59f9kptvj
	 BRJVuqozGjBlYDMqrEUOTJW9Sj+WWC+cwvmbeg7/6aTCoHdSAjeHfovl50qRCmgpE6
	 9moqO8QCwhiiUv51wJaHiuzvhAPEMw3IHkx3ePshhny6IpaLENvuLP7Bnx+R1WdavR
	 jf6ITrwCZcjKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKuo-0000000AOpW-47OR;
	Thu, 30 Jul 2026 07:10:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 12/29] arm64: Add FEAT_NV2p1 detection
Date: Thu, 30 Jul 2026 08:10:05 +0100
Message-ID: <20260730071022.296811-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the necessary NV2p1 probing to the cpufeature infrastructure.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
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

