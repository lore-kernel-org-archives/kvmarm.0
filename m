Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40162E6D3B
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167450; cv=none; b=UGGmPgvgZDxcgBei0bHuHJKvIqlZgwd5M/Ujq+Ri3F0XBVjgIoKvR1sW7D0I6RrBLi5W3JGUI8qTYHdRBG84d4CqByxd1h2XQiENZMfrr6II11rZ6eHhSZeCjooGeaXyIbl3mpB4A1McoTd+Qi07XreWYI71aO2rbEm+v3vg9B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167450; c=relaxed/simple;
	bh=Pc8JHBbxvWF1v9D1C2yskMvAYPnDtTgZ6bovL5Q/00o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=taiYaFh66Pj3nRk0Oa5Jjw9tKApTYiHkf9/ByM/PIjxh0uT+mpAmY16bXkCrTfMwyblkBZxr2ZBP8XRUnktOQ5uHG9r0+/aawEMgm+B+VmdkNdm8aIHzPYA8skphyu1e45zRgVmsdUWfh8s/YYoZo6Jx6ey+lnTG9CfGD+U5UB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18B1C150C;
	Tue, 17 Jun 2025 06:37:06 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5D6073F673;
	Tue, 17 Jun 2025 06:37:25 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 0/7] KVM: arm64: trap fixes and cleanup
Date: Tue, 17 Jun 2025 14:37:11 +0100
Message-Id: <20250617133718.4014181-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes some issues with the way KVM manages traps in VHE
mode, with some cleanups/simplifications atop.

Patch 1 fixes a theoretical issue with debug register manipulation,
which has been around forever. This was found by inspection while
working on other fixes.

Patch 2 fixes an issue with NV where a host may take unexpected traps as
a result of a guest hypervisor's configuration of CPTR_EL2.

Patch 5 fixes an issue with NV where a guest hypervisor's configuration
of CPTR_EL2 may not be taken into account when running a guest guest,
incorrectly permitting usage of SVE when this should be trapped to the
guest hypervisor.

The other patches in the series are prepartory work and cleanup.

Originally I intended to simplify/cleanup to kvm_hyp_handle_fpsimd() and
kvm_hyp_save_fpsimd_host(), as discussed with Will on an earlier series:

  https://lore.kernel.org/linux-arm-kernel/20250210161242.GC7568@willie-the-truck/
  https://lore.kernel.org/linux-arm-kernel/Z6owjEPNaJ55e9LM@J2N7QTR9R3/
  https://lore.kernel.org/linux-arm-kernel/20250210180637.GA7926@willie-the-truck/
  https://lore.kernel.org/linux-arm-kernel/Z6pbeIsIMWexiDta@J2N7QTR9R3/

In the process of implementing that, I realised that the CPTR trap
management wasn't quite right for NV, and found the potential issue with
debug register configuration.

I've given the series some light testing on a fast model so far; any
further testing and/or review would be much appreciated.

The series is based on the 'kvmarm-fixes-6.16-2' tag from the kvmarm
tree.

Mark.

Mark Rutland (7):
  KVM: arm64: VHE: Synchronize restore of host debug registers
  KVM: arm64: VHE: Synchronize CPTR trap deactivation
  KVM: arm64: Reorganise CPTR trap manipulation
  KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
  KVM: arm64: Remove ad-hoc CPTR manipulation from
    kvm_hyp_handle_fpsimd()
  KVM: arm64: Remove cpacr_clear_set()
  KVM: arm64: VHE: Centralize ISBs when returning to host

 arch/arm64/include/asm/kvm_emulate.h    |  62 ----------
 arch/arm64/include/asm/kvm_host.h       |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 147 ++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  59 ----------
 arch/arm64/kvm/hyp/vhe/switch.c         | 107 +++--------------
 6 files changed, 158 insertions(+), 228 deletions(-)

-- 
2.30.2

