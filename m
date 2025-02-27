Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D461E521C
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740679546; cv=none; b=Z4W9lOji8U0reUnIBG2qC33CGPF9yUYgcqlGP9HXly12qpRogM2cKvPQlovmteQB7UkcqaflS0Z5J4vYHsnYUpU7y/VQiBy36/5UiMi7Hrh9PXgCCBw59t/+xsYquHknO2jzBPNOygzTOuk7GOOltU+A2Fquq4u2sYWctuSpVqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740679546; c=relaxed/simple;
	bh=vPIQOVDK8o/t6nKIg0G5JL+0zQAE6wYBzOgMJ5Xxu0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lv5WX12v76WpbzShpOQdC2nNJyrMPHW42CkE+pOj4YDwxDr7cbW4KogULpNUlIFJNnG389SAzw6ur+j9l2vaj0QacBYSYAlfst2mrchUGVOL0OzWL9Vm5EPFjCnVPKwHv3P+k4VjL6tW1TM0ZBSQMZGzg5WhJhrAoz3WrarJMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 889281516;
	Thu, 27 Feb 2025 10:05:56 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4530D3F5A1;
	Thu, 27 Feb 2025 10:05:39 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: ahmed.genidi@arm.com,
	ben.horgan@arm.com,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	leo.yan@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	will@kernel.org
Subject: [PATCH 0/2] KVM: arm64: PSCI relay fixes
Date: Thu, 27 Feb 2025 18:05:24 +0000
Message-Id: <20250227180526.1204723-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches fix some missing initialization in the PSCI relay code
which can result in host kernel crashes shortly after entering the cold
entry points used by PSCI CPU_ON, CPU_SUSPEND, and SYSTEM_SUSPEND.

The SCTLR_EL1 issue was originally reported by Leo Yan and debugged by
Ahmed Genidi. While looking at Ahmed's patch I spotted a more general
issue with E2H, so I've fixed that up with patch 1, and I've tweaked his
patch accordingly. Any errors there are my fault.

The series is based on v6.14-rc3.

Mark.

Ahmed Genidi (1):
  KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Mark Rutland (1):
  KVM: arm64: Initialize HCR_EL2.E2H early

 arch/arm64/include/asm/el2_setup.h   | 31 +++++++++++++++++++++++-----
 arch/arm64/kernel/head.S             | 22 +++-----------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 10 ++++++---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 4 files changed, 39 insertions(+), 27 deletions(-)

-- 
2.30.2

