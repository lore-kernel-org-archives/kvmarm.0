Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C80438FF5
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752044; cv=none; b=lj+IpWUPj9mo/VX3fBCR1f7r4LxSE7FtDMFn2AisL79U/kaBNp+UBd7AiIEG9K5CaIWx2r4Gzkt3DNzPdI09VusvR3l/0auCboWoJrp0FqLn/FG+gFr1oIZKFTFnJqhWLUR0Cq80VqbKCCNTiTEz0b4t7yUshZJzTK9gbnBktM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752044; c=relaxed/simple;
	bh=XpmnCyDIJBzMs6VGI8ZKugfCk3Um6Y22mdoXwUhpgjc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Cx5Ln+gy+ZGF2nxTElxWaMVmOwp0tL60GDhfvH1xiiKLHE9z9pVIfZSyO/tcBGDWC/GWms/L0FChdt4unC1XQdlSldqh2QEzgaTDvI8cQMXaA0Wky9b9bcUCqKbcapO/JV07/WlYl6+JngcIcxtpA6jiHRlyr6qQ54nOrFNzKLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=tBrkrIaW; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="tBrkrIaW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784752043; x=1816288043;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wu1rvS/0NtqSzL/yTwSllD7b6h2XEg4CeDcgPIqUCJ8=;
  b=tBrkrIaWJa2BbILajvg7jStgcNYb9g7hluDrixrmFw0sP+qRCYAu45Md
   ZpN8X4LoyLoM70qxx0QlbBHMI0xlR3WrZ6lcb8eg3ueik+TZ4XSyc3wmc
   QCT9JSvRGtGxZlSpLvt+mc5L7f7CICgKvq6VNbns12c6O7/X7f60OhIvm
   LfnbylVZck/NVvHFPRYFOHRqn5I3r6D/8NBkCdFC+zKZrjyGYcMHT3qff
   br/iN0SDEWIMHBWPlXccG5Y79d7u4c+iVNdtVsW2m7yKPVFGXWDwK+gdi
   C+cjj0uZV/2TImmOFZwEf/9TTjLGiW8LAeJt6UIQpGZynoZkxNpjW1knZ
   g==;
X-CSE-ConnectionGUID: /9kOpMd8QuKjjawR+ASmog==
X-CSE-MsgGUID: Ix+wXZq9QRmXc4xYsHurFw==
X-IronPort-AV: E=Sophos;i="6.25,179,1779148800"; 
   d="scan'208";a="24168920"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 20:27:23 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:8212]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.115:2525] with esmtp (Farcaster)
 id 98f78049-842d-4f6a-b8e7-386b30f86096; Wed, 22 Jul 2026 20:27:22 +0000 (UTC)
X-Farcaster-Flow-ID: 98f78049-842d-4f6a-b8e7-386b30f86096
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 20:27:22 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 20:27:22 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Haris
 Okanovic" <harisokn@amazon.com>, Geoff Blake <blakgeof@amazon.com>,
	"Stanislav Spassov" <stanspas@amazon.de>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Wed, 22 Jul 2026 20:26:58 +0000
Message-ID: <20260722202702.4165917-1-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Today when the perf tool runs in a guest on cores with PMUv3p4, it fails
to parse the default metrics with "Failure to read '#slots'", since perf
can only read 0 from sysfs caps/slots, which is backed by PMMIR_EL1.SLOTS
that KVM traps as RAZ/WI.

Taking into account backward compatibility and heterogeneous systems, the
exposure of PMMIR_EL1.SLOTS is gated behind a new vCPU feature flag:

- Patch 1 exposes PMMIR_EL1.SLOTS of the selected PMU under the (as yet
  unsettable) KVM_ARM_VCPU_PMU_V3_STRICT flag, and adds userspace get/set
  for PMMIR_EL1 so that SLOTS can be reset to 0 for backward
  compatibility.
- Patch 2 stops masking STALL_SLOT* in PMCEID1 under the flag.
- Patch 3 makes strict-mode userspace configure the number of event
  counters via the KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS attribute rather
  than PMCR_EL0.N, whose meaning is context-dependent under NV.
- Patch 4 adds the KVM_ARM_VCPU_PMU_V3_STRICT flag itself: when set, KVM
  does not create a default PMU during vCPU init, and the VMM must select
  one explicitly via KVM_ARM_VCPU_PMU_V3_SET_PMU before the first
  KVM_RUN. This flips the gate on and can serve as an umbrella flag for
  future PMUv3 UAPI changes.

When the flag is not set, behaviors are unchanged.

v2: https://lore.kernel.org/r/20260702190421.420992-1-congkai@amazon.com
v1: https://lore.kernel.org/r/20260601193954.2103455-1-congkai@amazon.com

v2 -> v3 changes:
 - Reordered so the KVM_ARM_VCPU_PMU_V3_STRICT flag / KVM_CAP exposure
   comes last (now patch 4), after the flag-guarded behavior patches.
 - Reworked on top of Oliver Upton's refinements (thanks!):
   * Move the NULL-arm_pmu check into kvm_arm_pmu_v3_init() (returns
     -ENXIO) instead of failing at the first KVM_RUN, and report zero
     counters from kvm_arm_pmu_get_max_counters() before a PMU is set.
   * Documentation and -ENXIO ordering notes for the PMU device
     attributes (SET_PMU must precede INIT/FILTER).
 - New patch (Oliver): ignore userspace writes to PMCR_EL0.N under the
   strict flag and require the KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
   attribute, since PMCR_EL0.N is context-dependent under NV.
 - Advertise the KVM_CAP_ARM_PMU_V3_STRICT capability.
 - Documentation fixes in api.rst (the flag Requires KVM_ARM_VCPU_PMU_V3).

Congkai Tan (3):
  KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
  KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAPI
  KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature

Oliver Upton (1):
  KVM: arm64: Ignore writes to PMCR_EL0.N when using strict UAPI

 Documentation/virt/kvm/api.rst                | 11 ++++
 Documentation/virt/kvm/devices/vcpu.rst       | 11 +++-
 arch/arm64/include/asm/kvm_host.h             |  5 +-
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          | 19 ++++--
 arch/arm64/kvm/pmu-emul.c                     | 54 ++++++++++++----
 arch/arm64/kvm/sys_regs.c                     | 64 ++++++++++++++++++-
 include/kvm/arm_pmu.h                         |  4 ++
 include/uapi/linux/kvm.h                      |  1 +
 .../selftests/kvm/arm64/get-reg-list.c        |  1 +
 10 files changed, 149 insertions(+), 22 deletions(-)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.50.1

