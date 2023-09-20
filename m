Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5083D3BF
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 19:50:47 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695239445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u36CLFE7Of0P0rwCIt+hVWkI368S5yyzMyNNtCtqKEQ=;
	b=PjY68ibaZR2B7bCRmBSaK1GhcVuPiNjntzaizKAPMVDKtc0KnMIPg/p7wMDemRfl1xVPMZ
	M4riS/Zg+F1CvWUfaIZfgRFECgU3+L7DYnBjhkxV12le6ZWQga1ah1sJ6+J5ZRd/ESCqFt
	oQGoWGvDHdahDDLT4zd15LAImfGl0Nc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/8] KVM: arm64: Cleanup + fix to vCPU reset, feature flags
Date: Wed, 20 Sep 2023 19:50:28 +0000
Message-ID: <20230920195036.1169791-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The way we do vCPU feature flag checks is a bit of a scattered mess
between the KVM_ARM_VCPU_INIT ioctl handler and kvm_reset_vcpu(). Let's
move all the feature flag checks up into the ioctl() handler to
eliminate failure paths from kvm_reset_vcpu(), as other usage of this
function no not handle returned errors.

Nobody screamed about the VM-wide feature flag change, so its also a
good time to rip out the vestiges of the vCPU-scoped bitmap.

I also spotted a bug with the NV feature flag where we allow it
regardless of system support.

Oliver Upton (8):
  KVM: arm64: Add generic check for system-supported vCPU features
  KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
  KVM: arm64: Prevent NV feature flag on systems w/o nested virt
  KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Remove unused return value from kvm_reset_vcpu()
  KVM: arm64: Get rid of vCPU-scoped feature bitmap

 arch/arm64/include/asm/kvm_emulate.h | 13 +++---
 arch/arm64/include/asm/kvm_host.h    |  5 +--
 arch/arm64/include/asm/kvm_nested.h  |  3 +-
 arch/arm64/kvm/arch_timer.c          |  4 +-
 arch/arm64/kvm/arm.c                 | 62 +++++++++++++++++++++-------
 arch/arm64/kvm/hypercalls.c          |  2 +-
 arch/arm64/kvm/reset.c               | 56 +++++--------------------
 include/kvm/arm_arch_timer.h         |  2 +-
 include/kvm/arm_pmu.h                |  2 +-
 include/kvm/arm_psci.h               |  2 +-
 10 files changed, 72 insertions(+), 79 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

