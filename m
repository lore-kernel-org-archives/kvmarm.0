Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0F9488D92
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331111; cv=none; b=FvU7eaFuKIg8/kMz7UmV7Pi9mvwm6jfyrxEZEexhTaK18FE8eBjLUDXZn4SJhT+nOeZblydqjkXrDybGazvwcKV+a9lZlRqhtmgrCQT/ewudmwKFhzh1k378kLCmhUgT17cjmI2nPzTdLADdXfGs/DY0XbXZVIbGKigcuvACBS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331111; c=relaxed/simple;
	bh=9dDbK3on9QVHOxe7cBaKrpSz8c2EXQ/MLp/I7FV4J9o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cN73DE1HPwzS3x2ItaxJxslvPirqwicSlafrysy7cLeUjYkWgBqsL369DFIFG9Y8ksERYKFi7jn5EwKriGEnQh1fLb+7UitZSq5S4AnzFdOppmGPEIuZpfJeSP8U9UG1ck9XfQtsV/UjAz2axg8Xjni99oZJL7jUykB/NoFDiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LJPW5x5k; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LJPW5x5k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785331107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IqZNdFsmpnlABfXIHHin3yUUsuo0WpmK5RY/s6b0fU8=;
	b=LJPW5x5kUlPeMas8a0CtmleK5E6NlhCZj7I65KCVFvQ+okjPc0L3oMo7u8jmlocm7HVWbn
	/wT3IMAqRUValDLi27teen3XR4xzfP+BNIdIJzRvf+2Kuda+gPLfwqzQKR7EBGtbL1RC/R
	vyNYHf3AFNVQseCvf3jK0UHNFJ9B2Mc=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v7 0/8] KVM: arm64: pKVM vCPU state management at EL2
Date: Wed, 29 Jul 2026 14:18:15 +0100
Message-Id: <20260729131823.2021516-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v6 [1]:
  - Rebased onto v7.2-rc5.
  - Expanded the comment and commit message in patch 8 explaining why PC
    and PSTATE are copied back on every exit. No functional change.
  - Collected Steffen's Reviewed-by on patch 3 (thanks!).

Building on Will's pKVM infrastructure series [2], this series reworks
how pKVM moves vCPU state between the host and EL2, and stops copying a
non-protected guest's state on every world switch.

EL2 gains proper primitives for the state it transfers: vCPU lookup
helpers, and VGIC flush/sync that reduces how much host state EL2
dereferences. The series also moves some preparatory code (such as sys
reg access and PSCI helpers) to shared headers and HYP, and implements
lazy copying of a non-protected guest's register state back to the host
until the host actually needs it, instead of on every exit.

This is the first of two series moving pKVM vCPU state management to
EL2. The follow-up completes the job for protected VMs: state
isolation, PSCI handling at EL2, and the resulting API behaviour.

The series is structured as follows:

  01-04:  Preparatory refactoring (MPIDR, sys reg access, vCPU reset, PSCI
          helpers) to shared headers and HYP.
  05:     Host and hypervisor vCPU lookup primitives.
  06-07:  VGIC: reduce EL2's exposure to host state, add flush/sync primitives.
  08:     Lazy state sync for non-protected guests.

Based on v7.2-rc5 (f5098b6bae761).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260715081238.1891918-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/

Fuad Tabba (5):
  KVM: arm64: Extract MPIDR computation into a shared header
  KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
  KVM: arm64: Factor out reusable vCPU reset helpers
  KVM: arm64: Move PSCI helper functions to a shared header
  KVM: arm64: Implement lazy vCPU state sync for non-protected guests

Marc Zyngier (3):
  KVM: arm64: Add host and hypervisor vCPU lookup primitives
  KVM: arm64: Minimise EL2's exposure of host VGIC state during world
    switch
  KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

 arch/arm64/include/asm/kvm_arm.h     |  12 ++
 arch/arm64/include/asm/kvm_asm.h     |   1 +
 arch/arm64/include/asm/kvm_emulate.h |  63 +++++++
 arch/arm64/include/asm/kvm_host.h    |   2 +
 arch/arm64/kvm/arm.c                 |   7 +
 arch/arm64/kvm/handle_exit.c         |  23 +++
 arch/arm64/kvm/hyp/exception.c       |  34 +---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 261 +++++++++++++++++++++++----
 arch/arm64/kvm/psci.c                |  30 +--
 arch/arm64/kvm/reset.c               |  60 +-----
 arch/arm64/kvm/sys_regs.c            |  14 +-
 arch/arm64/kvm/sys_regs.h            |  19 ++
 include/kvm/arm_psci.h               |  27 +++
 13 files changed, 393 insertions(+), 160 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.39.5

