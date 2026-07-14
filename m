Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5975143FD3E;
	Tue, 14 Jul 2026 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020616; cv=none; b=NF53rePhR346c9uk7YkSpqZdyY1o9h/THfbdm2JNkpcBy2HvvbThIRc3qUbIW3WU5RH4pN+w4/p+IE0nlyM++YGabkphrQqk7Te5N/8FJlqz2NsAz7ouzaEolhABPnp19iG17TTiAKB0EbIXLyBLWmYTVsk6M5WCF3G2bXns7ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020616; c=relaxed/simple;
	bh=I+50Lsc4CfIsNb/Gr6JuNAVEajtxVGGWW+qdCUg7RfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvW26EIqtgTmlrM7gIjXf1NUu0gSzSaXNsQjxIanLmpm0jvG2aNNePggqJjE2EbKhzN9Ifp9yrQ9dYs6osIQn6DI9pujv8BaR6xd6jI5WlkFyfHpUcO/bZwCsxRtkC7P9U1lcBgDFVAVwug9A2hjo6Edp1Chp1/6F74/aAJHaKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gxh0Iljc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gxh0Iljc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339F91F00A3D;
	Tue, 14 Jul 2026 09:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020614;
	bh=whHpJ36OI1bAClZaUTHR3b4xJe/NWRnqvq/wOSxIZAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gxh0Iljc1oJhFiio18Ouh41Y36fLRg9DZqzzvhcrgXH+RIwA4OWzNCkV2e6iFwf58
	 m1cHD/AnL4GqNG8gUB9c3pREAKc4cxpENSKgGyytMvvurBUay/QZ57VSDPwjMGTuVK
	 B8Iuqx4cRmSUcEAsX1IgM/G2X/oAQ/4zodEO/tQTpjV1D0N0yi5CE0FOVll0pyLykJ
	 PJDXWyri3s5vgp203KBnkckJhOm936J9/tbzKL6ZpZc6KYYisSVWaQ0+d3/dp8r9BN
	 3TG5XmXwRuQCN+ghc0c9Eq70WHFEvlrJDajxsFGk6GWblxMmT+NKaC9WILKI7ZMq2Q
	 aj8uHnnpNYgXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZG0-00000004ny1-26iz;
	Tue, 14 Jul 2026 09:16:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 26/28] KVM: arm64: Add FEAT_NV3 detection
Date: Tue, 14 Jul 2026 10:16:39 +0100
Message-ID: <20260714091641.1970822-27-maz@kernel.org>
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

