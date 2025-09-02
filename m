Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998E82DC341
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756818839; cv=none; b=K3A1/G2ltrQYZ5zCpzfhYmiv4HW5s2b71wpMRZJzvN2kD39U8xzziiAnGIXfULYyd8SnpexN8CU/kzpoWjCTrAHfXELc1KCcy5/auozlVBjV3Abxs5hZafyH4kcA+p84VQxVxgSRD5H3lZwsfg6KEiBXj+Xm6op00t3afYnmWw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756818839; c=relaxed/simple;
	bh=oNDrNCMzJQa52lyxpnMrLN7H9DSJkbtstJlhzv3paqs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DKugm4l2ckxq1NIVHCTpKSAsjTMR8jqx9gtjEZU5lM/qMGYTLRy9LJw2V91BnSUvjX+rqjqbih20Uwt4DWj4q16y8QGOXFHRwRmjmKqQCSzXFSIIkkIOf++R/wy2fcGkef7HH5o+/2VktGLX+mK5M/Gmuaen+PymCuNZxf2wOrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65FF026BE;
	Tue,  2 Sep 2025 06:13:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E1013F694;
	Tue,  2 Sep 2025 06:13:55 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: [PATCH v2 0/2] KVM: arm64: VHE: Debug fixes
Date: Tue,  2 Sep 2025 14:08:31 +0100
Message-ID: <20250902130833.338216-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the patch that zeroes PMSCR_EL1 [1] at boot, hopefully now it's
not as bad.

Picked up another fix - patch #2 ("KVM: arm64: VHE: Save and restore host
MDCR_EL2 value correctly") is new.

[1] https://lore.kernel.org/kvmarm/20241106122654.38234-1-alexandru.elisei@arm.com/

Alexandru Elisei (2):
  KVM: arm64: VHE: Initialize PMSCR_EL1
  KVM: arm64: VHE: Save and restore host MDCR_EL2 value correctly

 arch/arm64/kvm/debug.c                  | 20 ++++++++++++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 -----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 ++++++
 3 files changed, 22 insertions(+), 9 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.51.0

