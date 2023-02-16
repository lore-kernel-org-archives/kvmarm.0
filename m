Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016B746B
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7800C4339C;
	Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557309;
	bh=QRffr5dG9qV+Mk/7oMoWKSJpm06ScxM7lQsl0hcQHQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0R0zd7+N/6xpobqzQnhapJnYFt46DAkYc0odAZ4v0nt/ErKM+/Sd4rCOd74GyZnX
	 1pw7fVoUZLBToyGjRlME6h6rsEP3GNFobmzkv0RRQFrJIgIn5Q2BxaTWm0UyBo+XMY
	 WIkGY6mMYIxcVTvdf4HpHZ7Q8rHKiqxsoNbiXejlj3lRBDXRINEXTIasvB+azXwT4U
	 c6dbjvv5k1O3l1hxK1UE7VNoWytl5hBi29kV4i7J+oLUvh9ic7uOk5MNFNOrxhiyaa
	 D1uTIt9Fc9kXW7xkLANjtqWcFpNczz+2//0WkWBQIC09P+gg079CjinsuzPOFt/3nc
	 NtjTDDY72K6gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8t-00AuwB-Kp;
	Thu, 16 Feb 2023 14:21:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	dwmw2@infradead.org
Subject: [PATCH 02/16] arm64: Add HAS_ECV_CNTPOFF capability
Date: Thu, 16 Feb 2023 14:21:09 +0000
Message-Id: <20230216142123.2638675-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the probing code for the FEAT_ECV variant that implements CNTPOFF_EL2.
Why is it optional is a mystery, but let's try and detect it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 23bd2a926b74..36852f96898d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2186,6 +2186,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (CNTPOFF)",
+		.capability = ARM64_HAS_ECV_CNTPOFF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.field_pos = ID_AA64MMFR0_EL1_ECV_SHIFT,
+		.field_width = 4,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = 2,
+	},
 #ifdef CONFIG_ARM64_PAN
 	{
 		.desc = "Privileged Access Never",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 82c7e579a8ba..6a26a4678406 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -23,6 +23,7 @@ HAS_DCPOP
 HAS_DIT
 HAS_E0PD
 HAS_ECV
+HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
-- 
2.34.1

