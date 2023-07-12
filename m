Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE45441F
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 12:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6350C433CD;
	Wed, 12 Jul 2023 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689166235;
	bh=2TPlkK4s3o6JJoqvuWHa9PtqQqdLZPeL4s4GeumoUM8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eIwHHQFnYDljV1CtMsc7jna+P0djQyyiq9KE4FycAz2zSbe+TliRv1gh/Z9boYHXn
	 7Mfwf7jjihXb+y5SwnTD1scSsDsn1ld54r+PfT1+kHD073hGPEJGXSRfEeqBZ9iRu4
	 cj4YagSonxfl2yqu2XRQ7TzK9uXs9vV/mOBRUy0I7aIwgq23KhxoE3Kci9cTJIuVRO
	 9XXHNSUmITbf0ej/xU3Qym6K6JktiDcN7RLKzhO8iRZg5NOpzkZPtwuzdAQyGR/4NT
	 T9nI1XSIPsNo6Cub+q8PLJQoAdB2LhhxDpZ1forgsl8KJ2pI/vU2of4xbPj5LRqmRj
	 ++ljSWzdBiQIA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Jul 2023 13:50:11 +0100
Subject: [PATCH v5 1/2] arm64: Add feature detection for fine grained traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230712-kvm-arm64-fgt-v5-1-dae3ec236288@kernel.org>
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
In-Reply-To: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1520; i=broonie@kernel.org;
 h=from:subject:message-id; bh=2TPlkK4s3o6JJoqvuWHa9PtqQqdLZPeL4s4GeumoUM8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkrqGUFMScFdMsV/Ai5BTiePpaR8rUn7d5sKRAEY34
 FP2QINqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6hlAAKCRAk1otyXVSH0JK1B/
 0Th23b616sC2fbPBjgH8wliUNkrtWPfAZxdPlmC7X6DMcDRHGvQUe8axk4TzqvmlR4sEfvynMT/7aU
 EY6uWzTSl+Gw/+3RBJsIBp0Dy8qHNLq5hDa33BA8V7iNgT/dav28CH/qprWCbMyn3XFlQozSOB1gpE
 wcaplQsnIqRPtAuWPQaUekaP8cPex6lYnUmhq4Dg1h/3Vc8Kq7hKik6U89CZ36+bfwOCYks2UXt3Vp
 ECX0tmV9lMmo+42gDF0X95EHVT3bwkAEZIg/K9wVPhXv2t6WHetRgcNwLcfaVG/aY9tUO516TPzggL
 bSJWckISdjI8siLqRtO0wc1rlbz2Pz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow us to have shared code for managing fine grained traps
for KVM guests add it as a detected feature rather than relying on it
being a dependency of other features.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f9d456fe132d..0768f98c49cc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2627,6 +2627,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
 	},
+	{
+		.desc = "Fine Grained Traps",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
+		.field_width = 4,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index c80ed4f3cbce..c3f06fdef609 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -26,6 +26,7 @@ HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_EVT
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5

-- 
2.30.2

