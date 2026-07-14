Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEA32FF147
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024201; cv=none; b=Cb5ji/4/ftf+8NKL3GTXUxdIyLGjnLK1XkGwNa2WU1M388WSx459XN6uVT+cBKFKc4PhuswYby7A0bTGssLeuUGizJhwi3kzO/phbyvUGgEiXt7UoZ4Ib/VVyDci6/j0BFvQSE5V3Sen7eJi3n648xsl8MMnz0xaH9EYEHz9nP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024201; c=relaxed/simple;
	bh=uxgtveE3/w1nMLAg4CqNI1BwRhJgSJXZTcbJlghYN78=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s63hRNmqSOBGHtIMzlLc6lyI0Hu4gkt794MhYhFw9LfxdYoQcYK4S1QWYqrExgJaOXlhgoESKAM2VK4AQwBcB+98Bhyy06mUI5CriBqhv/tvRU7AmQbe2XMZDFxgIQvj6zOSrbpnKZYeBpb3IBLXbCw13S5H+PoTuuFAEGpylsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S+q/f9eK; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S+q/f9eK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784024197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IGGPtHL/McwRSrgBlkOgO9CvLa+/+toxJU/7GfFUsLs=;
	b=S+q/f9eK0zAPQ774VDggYx7rcMe2jVvz5a7y/lVfWx0GnCOegyhEeHS7scTpD15E5YYNSd
	kuZWlhVsMDfdQnkmogupsuNcJSFM3x7MQdeIy1sTN2FzMJ/xw6L2G84hDiKjxI95KRqjvA
	/OhhhjvUic5BxnKsCUbkiooVcbu6zOQ=
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
Subject: [PATCH v5 0/8] KVM: arm64: pKVM vCPU state management at EL2 (series A)
Date: Tue, 14 Jul 2026 11:15:53 +0100
Message-Id: <20260714101601.4142645-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v4 [1]:
  - Renamed the sys register accessors: vcpu_{read,write}_sys_reg() are
    now the context-dispatching wrappers valid in any context, and the
    host-only implementations are __vcpu_{read,write}_sysreg_vhe(). This
    avoids introducing a kvm_vcpu_ prefix that would be easy to confuse
    with vcpu_. (Oliver)
  - Dropped Vincent's Reviewed-by on the sys register accessor patch,
    since it changed materially with the rename.
  - Rebased onto v7.2-rc3.

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

Based on v7.2-rc3 (a13c140cc289c).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260706095927.560795-1-fuad.tabba@linux.dev/
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
 arch/arm64/include/asm/kvm_emulate.h |  77 ++++++++
 arch/arm64/include/asm/kvm_host.h    |   6 +-
 arch/arm64/kvm/arm.c                 |   7 +
 arch/arm64/kvm/handle_exit.c         |  23 +++
 arch/arm64/kvm/hyp/exception.c       |  34 +---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 258 +++++++++++++++++++++++----
 arch/arm64/kvm/psci.c                |  30 +---
 arch/arm64/kvm/reset.c               |  60 +------
 arch/arm64/kvm/sys_regs.c            |  18 +-
 arch/arm64/kvm/sys_regs.h            |  19 ++
 include/kvm/arm_psci.h               |  27 +++
 13 files changed, 408 insertions(+), 164 deletions(-)


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.39.5

