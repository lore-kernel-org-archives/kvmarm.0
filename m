Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E700729405
	for <kvmarm@lists.linux.dev>; Sat, 22 Mar 2025 03:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742615493; cv=none; b=iSOZlyO9eT8nkuCg/ABl03/BkeQpFOYtVKUfbIWxGRXGfSmYcc2wJbx8DXmI22ZMAjRRLwRvuwqMzrJVwiuDK/8p45I4kICCxKoUKsda0h3Xj5IsUrRDIPkr85WbPhGVurE/7xZFTohQtI+swKInQvoGxIpRWevvxldb61boUvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742615493; c=relaxed/simple;
	bh=02WrvHsOfQhcL/BORu8PlTubY86zzCr9LziW66YhE2w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uGbICk8A8kSotcitoDCewSVBaOzu2rlNBLLfPNgeXPK0BmqFcB9hZxw0VrvD0/8pHNm7cYHEHOMF+BsisxcKvF7ZxciSqhgemZIEL6wZnBeYRI2EwFofcLw+Q2Cs+JsHGMUNwg5rNUMEZOuc9XgYnrb8bjOCURDhawZfC/3/bPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 324DD106F;
	Fri, 21 Mar 2025 20:51:38 -0700 (PDT)
Received: from entos-yitian-01.. (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 04ADF3F694;
	Fri, 21 Mar 2025 20:51:26 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: pmu: Avoid initializing KVM PMU when KVM is not initialised
Date: Sat, 22 Mar 2025 03:51:15 +0000
Message-Id: <20250322035115.118048-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, `kvm_host_pmu_init()` does not check if KVM has been
successfully initialized before proceeding. This can lead to unintended
behavior if the function is called in an environment where KVM is not
available, e.g., kernel is landed in EL1.

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/pmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7169c1a24dd6..e39c48d12b81 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -227,6 +227,13 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
+	/*
+	 * Prevent unintended behavior where KVM is not available or not
+	 * successfully initialised, e.g., kernel is landed in EL1.
+	 */
+	if (!is_kvm_arm_initialised())
+		return;
+
 	/*
 	 * Check the sanitised PMU version for the system, as KVM does not
 	 * support implementations where PMUv3 exists on a subset of CPUs.
-- 
2.34.1

