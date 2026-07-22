Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E187147143F;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706183; cv=none; b=ux+zfmf3r4NiiRdVweyaUvauBoFmuTvUQIN5pGTI0eFfOgZvW77Nt6+nwcq+PJ4BcwdM58ICqaeu8nD9buowUH0DIZAmjeG1lJSKysfSQ3xZPiFyaYolNg0qRLi9WL3IWBxrZMS9Up5Ghw3HjnmWHMKQszF1zrX9l6LieAsAfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706183; c=relaxed/simple;
	bh=I+50Lsc4CfIsNb/Gr6JuNAVEajtxVGGWW+qdCUg7RfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdRXpeFG8HW/W1/I+aP695Xvb/j9IbxUReuM2brLr6cL6H5rgYhq/DFe+dCE0dNJYqxzmdlh1Oa+wK0tOF6jdxli4i2mkAaDKQ8uQBTp09h43nYCBmkiyyELGauQALZSos3tESWNmk3enT3hGfnl5rvlzVlyea67+xtvh7zJmyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1ZoXlDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1ZoXlDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B91F01559;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706181;
	bh=whHpJ36OI1bAClZaUTHR3b4xJe/NWRnqvq/wOSxIZAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1ZoXlDyNva2/c8afoX2lQD+4zVgg2utFnbauV56l6yl5VkoDoPbcikWsd+tSHSDT
	 TmH/e0qFsNapNdtYjWX/6bFhIXdoIE4ZMzaxE2KSeNCBSihRV/wipxiQ4t0BMAnPe3
	 w97NlrZYSEWO8stidDyRK2SnMhngG+dOAhwzTsdZ2+XYTK1DH95W0Cf4z4fwAh5hgG
	 K5GPwmMWIwdyv8Kl1+JWZfxZt4us+kj6Gaane8EWOIFC9Pb8qAPt9eW3WMSbwN+nA8
	 0SGjYYHHr4oZJrx4DQgGKpm32hNvC3mZaGteTSSUfo7Rgrnjp3aorkowRds7OlgKqt
	 Gt0sQQ9XXRB1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbY-00000007VfN-0ZEf;
	Wed, 22 Jul 2026 07:43:00 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 26/28] KVM: arm64: Add FEAT_NV3 detection
Date: Wed, 22 Jul 2026 08:42:32 +0100
Message-ID: <20260722074234.3330999-27-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that everything is in place to engage the FEAT_NV3 fast-path,
add the detection code to cpufeature.c.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c9c124b0ccc8e..6ae1c816e2010 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
 	},
+	{
+		.desc = "FEAT_NV3",
+		.capability = ARM64_HAS_NV3,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV3)
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.47.3

