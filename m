Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AF426ED48
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136476; cv=none; b=pT5NGupfZp+87S4ljW998ZNSfH4i4lViE79H3zy0TxbiNQrTgWMoetR1ZHe1WYffjuCzlaRZHJkqKB7I2Enb1ostPYgzDa91PoxVAIoh5rj9c1QY5BJSyaAVDv1YjRa6z5ECLRy+UrHq32S6xVSWuqPs7fOL32IBqfZhetmxKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136476; c=relaxed/simple;
	bh=08o3xJHvneu40Xvjp5Y2tZZv2aZ889CV29E6EfiH1kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKB1Lcimto1yPdKCLoZPKQQ+gzmpOtzGz+Xz27JgErlQzr2C7ZFvAUHtu0xXXaJjQ0CBQo5ec941iPbddAgWUQgw+MNZMrM4ryIqM6MbK3xGU6612npOOZg773LRMRQRAmuimf2JLSjkzdr7aj0H3vmNGC51Xh6WhXshIucf/1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C492E1BB2;
	Fri, 14 Nov 2025 08:07:46 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4254E3F5A1;
	Fri, 14 Nov 2025 08:07:52 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 08/35] HACK! KVM: arm64: Enable SPE virtualization only in VHE mode
Date: Fri, 14 Nov 2025 16:06:49 +0000
Message-ID: <20251114160717.163230-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RFC only.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/spe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 7e38f7d9075b..101258b55053 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -24,8 +24,8 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 {
 	struct arm_spu_entry *entry;
 
-	/* TODO: pKVM support */
-	if (is_protected_kvm_enabled())
+	/* TODO: pKVM and nVHE support */
+	if (is_protected_kvm_enabled() || !has_vhe())
 		return;
 
 	guard(mutex)(&arm_spus_lock);
-- 
2.51.2

