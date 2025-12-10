Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1901F3BA4
	for <kvmarm@lists.linux.dev>; Wed, 10 Dec 2025 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372877; cv=none; b=TZzIwcdRDrVOCLrarHzELywTZnewAfrAXbjLG2vbzpDRCTf8bUH/C3bVq7p3SD5Ox7AMmm9ZyQGK3HL1pqCYc1X4T+aWB/roWvM/CBV/DxgwVuFjb/ErV8cBLJFnVnY/S5UtRr+IjBtFFXZOVXGFYvvtFCDlbebptQyKgzTL9T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372877; c=relaxed/simple;
	bh=ScfYyzsiQzIphyUj421fzrQExm+0/MuSzpaVsn9s8uI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ojIKDab+KZsF2gA9+yiznULy+uC7zcqUau1bVbDX7q8jXBi2+XNeljp2Ioo66AOyXG+xLVihCzCLZth00Cs5aEK+3lscHg+JxEM90H5NTdQSuoeg9P7YLxwfOtRhROBtSt746Ar/IqVpsF9/3wUldrYb59NLpBgLhhPqz2YflGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B45D153B;
	Wed, 10 Dec 2025 05:21:06 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B44203F762;
	Wed, 10 Dec 2025 05:21:11 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/2] KVM: arm64: pKVM fixes
Date: Wed, 10 Dec 2025 13:21:00 +0000
Message-ID: <20251210132102.137631-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to [1], when trying to run an unprotected VM on FVP with S1PIE enabled
and kvm-arm.mode=protected, writes to PIRE0_EL1 made by the guest in
__cpu_setup() are trapped by KVM and the BUG_ON(!r->access) is hit. That's
because HFGWTR_EL2.nPIRE0_EL1 is an inverse polarity trap and the FGT values for
the unprotected pKVM VCPU weren't being propagated from kvm_arch_vcpu_load().

Couldn't figure out how to run a protected pKVM VM, so that's untested.

Patch #2 is just a minor fixup for something I found by code inspection when I
trying to figure out how unprotected pKVM works.

[1] https://lore.kernel.org/all/20251112102853.47759-1-alexandru.elisei@arm.com/

Alexandru Elisei (2):
  KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
  KVM: arm64: Remove extra argument for
    __pvkm_host_{share,unshare}_hyp()

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  1 -
 arch/arm64/kvm/mmu.c               |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)


base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.52.0

