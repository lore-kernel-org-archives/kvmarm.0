Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2E62D2498
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010920; cv=none; b=U/TlKcN3p53XvTXwN14CXrF/cuNCvFBkuNSoIkVff+g/F8V4GgXM2ljTUaHG2vQ3mtLZwO4tIv1Wmch43HuLVUZ8w8WLmWJVW7aYJWQ0KEgpdV5RYH2A6Iw0EUDVG/BD5NJfE71oKNNvzAN6md7YrKkj4NYfQBNbZ1EXp9RHl4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010920; c=relaxed/simple;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIt53LFpKoTfA+zUNzRqA5EQg3prMTE4TMIummBsEnYtXrxiQgmvIWwvrOap7ZAN7sIGByPLL48sJ+EtWMlUcv3+ooVsbN/qRVs6lfI4g9dkBFMELRBi+j/vIwFrf6xeyYOtTaNre2VESGzYfzP8imPXgoCuOQyaLOIZjfTfhCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiXlk6PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiXlk6PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEA0C4AF09;
	Mon, 24 Nov 2025 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010919;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiXlk6PWIIzxsr1W1g61UEuN8OjUdZbwE12sgUBLke1DvOJ8ysAatt1Ir+hajZoeG
	 mE6p4rDgZNa6+Duc7xnD/aiuXj8Hwdl2XVwF4JjbyTUbYk3dJq8TUsJ3V2AEGr59+8
	 wEkDmMTd/wVDDn/PA/b4+FTG1lnpDg/w3eMv5xHdpv7lSLTRHmeEW1AdI/xuS/b9Gl
	 ZxPBUzd/CSJ0sy2FxKa8ampIlLyxawPINH0/Mc5kuhl1uB9+h5LMtzYEyCYuuiuv91
	 XdfIrS24IxUTsndow99Otr4+6cXLdofitMJInmnTV/3OYJWYA4xOBa5ZuvB9x0CJ/C
	 DVzUGG9CEaP7Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 01/15] arm64: Detect FEAT_XNX
Date: Mon, 24 Nov 2025 11:01:43 -0800
Message-ID: <20251124190158.177318-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect the feature in anticipation of using it in KVM.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ed401ff79e3..aa3ecae252d3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3088,6 +3088,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_GICV5_LEGACY,
 		.matches = test_has_gicv5_legacy,
 	},
+	{
+		.desc = "XNX",
+		.capability = ARM64_HAS_XNX,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, XNX, IMP)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1b32c1232d28..ee74199107d3 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -64,6 +64,7 @@ HAS_TLB_RANGE
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
+HAS_XNX
 HAFT
 HW_DBM
 KVM_HVHE
-- 
2.47.3

