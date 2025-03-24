Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973DF14F98
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 02:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742783742; cv=none; b=V+YYXdirmooHpOQse8jYSjr5jfT3qGFXmvPetrUqIy0f0ANCWkvSPnVXPXJ3ATd6Rp2Jrh4B2mz4/TSRN4rGpN9QbZWnkhryTsRRaeG2GS3wgkxmuHivyJdD66MD/ESykmVedJGQLQ3oGwOgxUkKLcv52HknFkk1cPqzS5EAGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742783742; c=relaxed/simple;
	bh=WXP6pAWdo0VZuP3UbIqZt/JoWchYvGMkSjCSQIDez5I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dM8RMThVMt6qQbZmSTH1JCCOF+nlGCvNNofHJjfkFgeQqj8iHhmSeX7LnS2D2XGSets5ND9atqCN6QzmFoYGqunFE14H35oDU3qgV4u/jdMrmxF3bOJJsUlxwCNpFm/MuVCxfL83EsYs3FaGdo5w1VsZCgvVbs/yigwEQN6cuoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 175B5106F;
	Sun, 23 Mar 2025 19:35:45 -0700 (PDT)
Received: from entos-yitian-01.. (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9AB443F63F;
	Sun, 23 Mar 2025 19:35:34 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v2] KVM: arm64: Skip the KVM pmu initialization when hyp is unavailable
Date: Mon, 24 Mar 2025 02:34:50 +0000
Message-Id: <20250324023450.109312-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Hyp mode is unavailable (e.g., the kernel boots from EL1), skip the
unnecessary KVM pmu initialization.

Signed-off-by: Jia He <justin.he@arm.com>
---
v2: 
 - Utilize is_hyp_mode_available() for improved accuracy when detecting the
 guest VM case, as it accounts for scenarios where the kernel boots from EL1.

 arch/arm64/kvm/pmu-emul.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac..81b1a84ee1b3 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -779,6 +779,13 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
+	/*
+	 * When Hyp mode is unavailable (e.g., the kernel boots from EL1),
+	 * skip the unnecessary KVM PMU initialization.
+	 */
+	if (!is_hyp_mode_available())
+		return;
+
 	/*
 	 * Check the sanitised PMU version for the system, as KVM does not
 	 * support implementations where PMUv3 exists on a subset of CPUs.
-- 
2.34.1

