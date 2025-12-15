Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479EF332EB6
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799066; cv=none; b=WHZtL9vL+vFX3gdmNU59Ta+mv3sa/oTe/BE4KVAKHWWWiHxdlVsuiQkDII3qwyvw6fvq9XET+8jvQDCsmkDPCVNKsOZNzkZp7oU1WCyKAZJb4aoD877BFc2IRzr+D0HtJ8AkGYwfu98oreTLGBy9GJZpsKqVc72NK5oTMO2goZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799066; c=relaxed/simple;
	bh=j90w0TrFwVTxQjyXxe8nXVFdwOmJh3xMZ5Mwkujpao0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JKAX+TlZXrv7fYkkEc/YzuI1RbLsMuGRwU+LqT9TuQfMhMw0lzBY1XJSoiUu+tH6HaoYFTbo8c7p8fN20xUCk4qQEMe+VvlOuV0SdKxdQWNP6UMk6iXvDs+mIG6Qg0BdZOXq4b/Be+3pfGe52N6la5dYYrB2eQGiu37r3YzZAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43C1B497;
	Mon, 15 Dec 2025 03:44:17 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 930783F73B;
	Mon, 15 Dec 2025 03:44:22 -0800 (PST)
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
Subject: [PATCH v2 0/4] KVM: arm64: pKVM fixes
Date: Mon, 15 Dec 2025 11:44:05 +0000
Message-ID: <20251215114409.212512-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 can be found at [1].

Similar to [2], when trying to run an unprotected VM on FVP with S1PIE enabled
and kvm-arm.mode=protected, writes to PIRE0_EL1 made by the guest in
__cpu_setup() are trapped by KVM and the BUG_ON(!r->access) is hit. That's
because HFGWTR_EL2.nPIRE0_EL1 is an inverse polarity trap and the FGT values for
the unprotected pKVM VCPU weren't being propagated from kvm_arch_vcpu_load().

Couldn't figure out how to run a protected pKVM VM, so that's untested.

New in this iteration is #2 ("KVM: arm64: Print register encoding if there's no
accessor") because I realized that the first thing I did when I hit the
BUG_ON(!r->access) (for this series and for the fix at [2]) was to print the
encoding for the register.  Thought that it might be more useful in the future
to do this by default.

Patch #4 ("KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()") is
also new - found it by code inspection while debugging something unrelated.

Changelog
=========

v1->v2:
* Rebased on top of v6.19-rc1.
* Added tags to patch #1 ("KVM: arm64: Copy FGT traps to unprotected pKVM
  VCPU on VCPU load") - thanks!
* Removed local variables 'hyp_kvm_vcpu' and 'host_vcpu' in patch #1.
* Patch #2 and #4 are new.
* Patch #3 ("KVM: arm64: Remove extra argument for
  __pvkm_host_{share,unshare}_hyp()") now properly fixes
  __pkvm_host_unshare_hyp().

[1] https://lore.kernel.org/kvmarm/20251210132102.137631-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/all/20251112102853.47759-1-alexandru.elisei@arm.com/

Alexandru Elisei (4):
  KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
  KVM: arm64: Print register encoding if there's no accessor
  KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
  KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()

 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 arch/arm64/kvm/mmu.c                    | 4 ++--
 arch/arm64/kvm/sys_regs.c               | 8 +++++++-
 7 files changed, 15 insertions(+), 7 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

