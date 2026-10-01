Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037B747140E
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863043; cv=none; b=IDQzpDY6BxJhhzuaVe4k/HVvd9p/z/a7epMU95JS7w1oOl8Wxl+CkdHMtBCqvtkSLr2nA3C0Iey9zT3p2gZ6Pvr1f1uTdu+TzpRammUQXIxddpZLX2WLEypX/8csV9F0tXZbsZBlBfyvhjuajJKziUCzrL+gfy90hJAsxb+VMz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863043; c=relaxed/simple;
	bh=7LRmeL2aZdsgLBivLTyfL6P6xPAh8rIwxSP5UYb2qbo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qQbFFk9zIqyy8cF4Dj5UAAJtgutbvqYWo9P1lM1quLERlVG/KVO885z2ZuvtYd8QTbR3cGLeQFK3Swu2R6FqVGHTYjedYI+m1AbxDjNWpxY1S8wNexlLsWboKWhw5lUYJynSDA5Mvmfo9O3ccP5sJB4rdZIFE0m5NpTPHfDM3qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TndGKWAT; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TndGKWAT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7LRmeL2aZdsgLBivLTyfL6P6xPAh8rIwxSP5UYb2qbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863036; v=1; x=1791467836;
 b=TndGKWATG2SngtKPIbxX1iLl1H55HzSlXpcuMmbBxrKTbrsZNjoYivoVGJ5z5MjbjDvSJ0bq
 L2Shi1C1zmb4os0qPKVr8dMe8bQxLBmsWdn+BCcPTotRqgjwb6d8n073BuLNMB87At4hrP/P7sf
 rxQRb4Uk87iaXZbPggzO/Q34=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d6b035d067cc9da9;
	Thu, 01 Oct 2026 13:57:15 +0000
X-Mizu-Trace-ID: d6b035d067cc9da9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 00/18] KVM: arm64: Confine protected VM vCPU state to EL2
Date: Thu,  1 Oct 2026 14:56:53 +0100
Message-Id: <20261001135711.1640520-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v3 [1]:
  - A protected vCPU that EL2 holds powered off reads as
    KVM_MP_STATE_UNINITIALIZED, in place of a new bool. (Marc)
  - The marshalling and PSCI patches access the host copy through the
    vCPU accessors, with every assignment on one line. (Marc)
  - The PC adjustment pair is kvm_adjust_pc_get()/put() and tests for
    the hyp vCPU directly. (Marc)
  - CPU_OFF clears the reset flag before its release of OFF, CPU_ON's
    relaxed cmpxchg is ordered by its control dependency, and the
    CPU_ON rollback stores OFF with a release. pkvm_reset_vcpu()
    carries the CPU_ON/CPU_OFF sequence as a comment and drops its
    WARN_ON(). (Vincent, Will)
  - Collected Reviewed-bys.

Following the vCPU state-sync series [3], this series completes the
job for protected VMs: a protected guest's register state stays at
EL2, and the host sees only what handling each exit requires.

EL2 marshals a protected vCPU's state per exception class instead of
copying the whole context both ways. It owns the vCPU's trap
configuration, system register reset and HVC handling, and implements
PSCI itself: AFFINITY_INFO is left to the host, and CPU_ON and CPU_OFF
are resolved at EL2 with the host only scheduling the target or
stopping it. A protected guest's TRNG calls, which the host handled
until now, return NOT_SUPPORTED until TRNG for protected guests
follows. EL2 implements PSCI 1.1, so a protected guest also loses the
functions the host supports above that version, SYSTEM_OFF2 included.
Host ioctls that would reach the state EL2 owns fail with -EPERM, so a
protected VM's state isn't save/restorable. All of this is scoped
to KVM_VM_TYPE_ARM_PROTECTED, and pkvm.rst describes the resulting API.

The kvmtool changes that go with this are posted separately [4].

Patches 1 to 3 go out separately: the HCR_EL2.VSE fix [5], and the
host vCPU VM read and pin fixes, patches 4 and 5 of the host hypercall
fixes series [2]. None of the three is part of this series. They're
carried so the series applies as is and Sashiko can run on it.

The KVM_ARM_PREFERRED_TARGET documentation fix [6] went out just ahead
of v1. Nothing here depends on it to apply, but patch 18 documents vCPU
feature availability as something the capabilities report, while
api.rst 4.83 still points userspace at a bitmap that has always been
empty.

The series is structured as follows:

  01:     The HCR_EL2.VSE fix, posted separately.
  02-03:  The host vCPU VM read and pin fixes, posted separately.
  04:     Steal time disabled for protected VMs.
  05-06:  Per-exception-class entry handlers; EL2 owns a protected
          vCPU's trap configuration.
  07-09:  Timer state, system register reset and HVC handling at EL2.
  10-11:  PSCI at EL2, and the KVM_ARM_VCPU_INIT and PSCI version
          restrictions.
  12-14:  Host PC adjustments blocked; an UNDEF at EL2 for exit
          classes the host doesn't emulate; per-class state
          marshalling.
  15-16:  Host changes to private state, and host power-on of a vCPU
          EL2 holds powered off, rejected.
  17:     Capability allowlist.
  18:     Documentation.

Still to come: selftests, TRNG, self-hosted debug and SVE for protected
guests, and much more, as separate series.

Based on v7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914113338.159227-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260915123846.2317931-1-fuad.tabba@linux.dev/
[3] https://lore.kernel.org/all/20260729131823.2021516-1-fuad.tabba@linux.dev/
[4] https://lore.kernel.org/all/20260831192406.1341841-1-fuad.tabba@linux.dev/
[5] https://lore.kernel.org/all/20260829071120.2522788-1-fuad.tabba@linux.dev/
[6] https://lore.kernel.org/all/20260831162815.269851-1-fuad.tabba@linux.dev/

Fuad Tabba (16):
  KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
  KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
  KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
  KVM: arm64: Disable steal time for protected VMs
  KVM: arm64: Skip fixed-feature state flush for protected vCPUs
  KVM: arm64: Add system register reset framework for protected VMs
  KVM: arm64: Implement HVC handling for protected guests at EL2
  KVM: arm64: Handle PSCI calls for protected VMs at EL2
  KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected
    VMs
  KVM: arm64: Prevent host PC adjustments for protected vCPUs
  KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
  KVM: arm64: Add per-EC entry/exit state marshalling for protected
    guests
  KVM: arm64: Reject host access to protected VM private state
  KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
  KVM: arm64: Advertise the capabilities that protected VMs support
  KVM: arm64: Document the protected VM userspace API

Marc Zyngier (2):
  KVM: arm64: Introduce per-EC entry handlers for pKVM
  KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives

 Documentation/virt/kvm/api.rst                |  27 +-
 .../virt/kvm/arm/fw-pseudo-registers.rst      |   2 +
 Documentation/virt/kvm/arm/pkvm.rst           | 164 ++++-
 Documentation/virt/kvm/devices/vcpu.rst       |   3 +-
 arch/arm64/include/asm/kvm_host.h             |  22 +-
 arch/arm64/include/asm/kvm_hyp.h              |   4 +
 arch/arm64/include/asm/kvm_pkvm.h             |  33 +
 arch/arm64/kvm/arm.c                          |  76 ++-
 arch/arm64/kvm/guest.c                        |  11 +
 arch/arm64/kvm/hyp/exception.c                |  26 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h    |  48 ++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  20 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 595 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 422 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |  29 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  60 ++
 arch/arm64/kvm/hypercalls.c                   |   7 +
 arch/arm64/kvm/pkvm.c                         |  21 +-
 arch/arm64/kvm/psci.c                         |  11 +-
 arch/arm64/kvm/pvtime.c                       |  10 +-
 20 files changed, 1503 insertions(+), 88 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

