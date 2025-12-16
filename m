Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA6D2F12BF
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881080; cv=none; b=ep7QwWPMAWTfDwwh2DcU6TVqsdM8Uegjrih8fijyJG6n4nrztGtmIcFnSK0W7gboJVAriq8jKsR2KQFcn9g+m7dKh8G46bHFVgxGgodbx79Qa4zFyzMWB9X/NEu+gj/oMconx78wRT9kqQuLrTKxS54Ryx4gu/alTcM/Ka7fAN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881080; c=relaxed/simple;
	bh=dIXH18udrPF2FXt+7uXwn5a7/drqTbrdBU66SFBk5k8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=APQGhFaKF36I7lSXMJznyoob8ClwubkQeorcsxO2vsVmbpwEj857ZD67n9+0HYWNw2FMRxFdzcOnEwYAh9pU3xICGfJ5/0Ep78MA7Tiu/PR6lxDD8jU2/RBneGjF7FZMtRV18TSdXGGjgpSO0RRR4jXp1KyFC34sxTbhiiKxrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25208FEC;
	Tue, 16 Dec 2025 02:31:10 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEFD23F694;
	Tue, 16 Dec 2025 02:31:15 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 0/4] KVM: arm64: pKVM fixes
Date: Tue, 16 Dec 2025 10:30:49 +0000
Message-ID: <20251216103053.47224-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 can be found at [1].

Similar to [2], when trying to run an unprotected VM on FVP with S1PIE enabled
and kvm-arm.mode=protected, writes to PIRE0_EL1 made by the guest in
__cpu_setup() are trapped by KVM and the BUG_ON(!r->access) is hit. That's
because HFGWTR_EL2.nPIRE0_EL1 is an inverse polarity trap and the FGT values for
the unprotected pKVM VCPU weren't being propagated from kvm_arch_vcpu_load().

Couldn't figure out how to run a protected pKVM VM, so that's untested.

Changelog v2->v3:
* Gathered Reviewed-by tags, thanks!
* In patch #2, KVM now calls bad_trap() instead of KVM_BUG(). Also changed patch
  subject to match.

[1] https://lore.kernel.org/kvmarm/20251215114409.212512-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/all/20251112102853.47759-1-alexandru.elisei@arm.com/

Alexandru Elisei (4):
  KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
  KVM: arm64: Inject UNDEF for a register trap without accessor
  KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
  KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()

 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 arch/arm64/kvm/mmu.c                    | 4 ++--
 arch/arm64/kvm/sys_regs.c               | 5 ++++-
 7 files changed, 12 insertions(+), 7 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

