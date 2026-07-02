Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD233382C7;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008187; cv=none; b=t7FUJD8e1tI3BwpJBEiD8tc7u3LFCJpttt5Xuuub/twLC++Vb8sdMErR6r/zoKAbivZXTlJg3TeSR3AjVei0K9TV1PrUaKeToKWinbTZBPdXpLsqJ4shFFcIBfgfza2JgNV1E6BAclmdw+hMq+6ttr7aw82N/MUp9/EU+Fc3d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008187; c=relaxed/simple;
	bh=I+50Lsc4CfIsNb/Gr6JuNAVEajtxVGGWW+qdCUg7RfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxR7FVf2YfxkFDbBN6YFlIgQl3RvJPM/HQ84WziEbdYaF/AzWompiGddsDpNC/Hyj/RkzsFtMjuJF3bXZgDGQA8BIugYLlfSstia2pkOrg0nh1TORyoaVtwvjEp7jcqsv0QgyJSQQ5c5mWFpTbje9I4pOGdTxt4kKRbbaREJVDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dm3HDKMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dm3HDKMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9FA1F01559;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008185;
	bh=whHpJ36OI1bAClZaUTHR3b4xJe/NWRnqvq/wOSxIZAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm3HDKMo5I7SCRzVbeCAvh80M0blEDPp8JzeP5dZ0xd2b8Y1dl8XJ0f63aHATD743
	 gUCWC0kJ6GJIvUUgQnHwQe0D68v1BodFLjK61wJKw+UZCvVCZn/a7YScOObLRr+juq
	 iJlDNCBiRtpnoFKYpXniCx/bIWH1iOH3Tq4Ip679qKYYd7EqRqoqiNOTtGxDcSPJhP
	 UKEmO56MCxKHxSwmhcYQWZg6H+z50ykNxCyzJhgzgw/6eL7WXsDZTsVn+mZUS79lsv
	 7mhhmnO5UXsPGel94rTpln8O0lwbodY4tlZx8l4xOw8lenUnAGfM6hY3dHAs04O4Ss
	 gorA3VwZEDDIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsV-00000000ojd-1gRt;
	Thu, 02 Jul 2026 16:03:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 26/28] KVM: arm64: Add FEAT_NV3 detection
Date: Thu,  2 Jul 2026 17:02:46 +0100
Message-ID: <20260702160248.1377250-27-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
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

