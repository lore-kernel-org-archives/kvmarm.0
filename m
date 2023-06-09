Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CDA408DE
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:05 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MRsexOrQrwaWEvefVZ6xZbXy5zm8au8XhWoKnKfa56Y=;
	b=crWzPFt+hYkHrtzhlaN/rjae9lKVlw3umdQN3cLe8r1XiblzNuBk8Nmd1zOlmFQYJB0l4V
	jbGyUPKQ2DfqtMG2Q+oIEqrnj+udaNiOu6/wM8eHswReqL6AOQ3XBEw+DFCTMMB4UXlSnX
	6umVRo0Ek16fGU5zWUrCP3BBnNY4Or4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 00/11] Support writable CPU ID registers from userspace
Date: Fri,  9 Jun 2023 19:00:43 +0000
Message-ID: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hello folks,

In the interest of expediting the acceptance of the generalized ID
register infrastructure, I have taken Jing's series and applied fixes
according to the feedback of reviewers and my own interpretation.

The laundry list:
 - Split and reorganize the changes to avoid introducing intermediate
   regressions in the series. Don't want to break bisection! Sadly,
   this requires introducing a bit of churn but to me is an acceptable
   tradeoff.

 - Split up monster changes into more bite-sized chunks.

 - Actually delete the old masking logic when we no longer use it.

 - Reinterpret IMP_DEF PMUs as NI at the time of write

 - Move locking back into ID reg specific code. Let it be known: if you
   want to do custom ->set_user() logic for an ID register, it better
   find its way into set_id_reg().

 - Rewrite kvm_vcpu_set_target() into something that's a bit more
   cognizant of the existence of a bitmap.

 - Prevent userspace from configuring asymmetric vCPU features. Yep,
   this is technically user-visible breakage, but has been a long time
   coming. Asymmetry in KVM has always worked by chance, and is
   inconsistent with the overall handling of asymmetry in the kernel.
   If this breaks you: now's your chance to plead your usecase.

 - Rip out the PMUVer <-> PerfMon bidirectional pipe. Making things
   consistent between the 32bit and 64bit worlds is needlessly
   complicated, and the only thing we care about in KVM is that the
   advertised feature set aligns with the limits of the system/VM.

 - Allow the value of KVM_ARM_VCPU_POWER_OFF to change between calls. It
   doesn't make sense in the context of a VM-wide feature set, and we
   may as well let userspace do whatever it wants with the bit.

 - Opportunistically rewrite sysreg definitions to use the new syntax.

Tested with selftests, kvm-unit-tests, as well as booting an actual VM
with kvmtool + QEMU.

v11: https://lore.kernel.org/kvmarm/20230602005118.2899664-1-jingzhangos@google.com/

Jing Zhang (5):
  KVM: arm64: Reuse fields of sys_reg_desc for idreg
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use arm64_ftr_bits to sanitise ID register writes
  KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1
  KVM: arm64: Use generic sanitisation for ID_AA64PFR0_EL1

Oliver Upton (6):
  KVM: arm64: Separate out feature sanitisation and initialisation
  KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF
  KVM: arm64: Make vCPU feature flags consistent VM-wide
  KVM: arm64: Rewrite IMPDEF PMU version as NI
  KVM: arm64: Handle ID register reads using the VM-wide values
  KVM: arm64: Rip out the vestiges of the 'old' ID register scheme

 arch/arm64/include/asm/cpufeature.h  |   1 +
 arch/arm64/include/asm/kvm_emulate.h |   7 +-
 arch/arm64/include/asm/kvm_host.h    |  45 +--
 arch/arm64/kernel/cpufeature.c       |   2 +-
 arch/arm64/kvm/arm.c                 | 134 +++++---
 arch/arm64/kvm/reset.c               |  58 ----
 arch/arm64/kvm/sys_regs.c            | 493 +++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.h            |  22 +-
 include/kvm/arm_pmu.h                |   8 +-
 9 files changed, 478 insertions(+), 292 deletions(-)


base-commit: 7877cb91f1081754a1487c144d85dc0d2e2e7fc4
-- 
2.41.0.162.gfafddb0af9-goog

