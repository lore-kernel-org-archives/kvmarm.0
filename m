Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B440207217
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633124; cv=none; b=qVzESEKKzR+T8qxEF/bO5474u8jXiXULBZLrLFTNl1IOvWhvDwJALBcbiowYZ74tqbM3KuPW7ORD9+QCx9OGVqA3hk2Iaiqx2U5rhGKnBWuQemC+oojcMJAl+OX1a4TxXPRXalkqxAkHFHeiVuw8pOEq+623PswTpS2GZU9P2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633124; c=relaxed/simple;
	bh=RD1DeZxUHYauOV9i7JWRxTvPfKBqX5McIk6QbsCvjk0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jUwFmnsz5M/V6vAWprgKSrLeEqDYJMBGPRwuh7MQ3IKhmhAe6d5xO2WS978Fghrvsv/oIntbH1Vf13w4gEzdAiZjoZSWry1OhkovR49fNVpbAOzdPfEvwWGXRCsYxDREQsuXpkq854k/g7XDBXxVxugN59jU/QDPXkXiqro3tnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzN71WsMz6JB3Q;
	Fri, 11 Oct 2024 15:51:35 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 17143140AE5;
	Fri, 11 Oct 2024 15:51:58 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:51:51 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live migration
Date: Fri, 11 Oct 2024 08:50:47 +0100
Message-ID: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

Hi,

On ARM64 platforms most of the errata workarounds are based on CPU
MIDR/REVIDR values and a number of these workarounds need to be
implemented by the Guest kernel as well. This creates a problem when
Guest needs to be migrated to a platform that differs in these
MIDR/REVIDR values even if the VMM can come up with a common minimum
feature list for the Guest using the recently introduced "Writable
ID registers" support.

(This is roughly based on a discussion I had with Marc and Oliver
at KVM forum. Marc outlined his idea for a solution and this is an
attempt to implement it. Thanks to both and I take all the blame
if this is nowhere near what is intended/required)

This RFC proposes a solution to handle the above issue by introducing
the following,

1. A new VM IOCTL,
   KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct kvm_arm_migrn_cpus)
   This can be used by the userspace(VMM) to set the target CPUs the
   Guest will run in its lifetime. See patch #2
2. Add hypercall support for Guest kernel to retrieve any migration
   errata bitmap(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA)
   The above will return the bitmaps in R0-R3 registers. See patch #4
3. The "capability" field in struct arm64_cpu_capabilities is a generated
   one at present and may get renumbered or reordered. Hence, we can't use
   this directly for migration errata bitmaps. Instead, introduced
   "migartion_safe_cap", which has to be set statically for any
   erratum that needs to be enabled and is safe for migration
   purposes. See patches 3 & 6.
4. Rest of the patches includes the plumbing required to populate the
   errata bitmap based on the target CPUs set by the VMM and update the
   system_cap based on it.

ToDos:-
  -We still need a way to  handle the error in setting the invariant
   registers(MIDR/REVIDR/AIDR) during Guest migration. Perhaps we can
   handle it in userspace?
-  Possibly we could do better to avoid the additional "migartion_safe_cap" use.
   Suggestions welcome.
  -There are errata that require more than MIDR/REVIDR, eg: CTR_EL0.
   How to handle those?
  -Check for locking requirements if any.

This is lightly tested on a HiSilicon ARM64 platform.

Please take a look and let me know your thoughts.

Thanks,
Shameer

Shameer Kolothum (6):
  arm64: Modify callback matches() fn to take a target info
  KVM: arm64: Add support for VMM to set migration target
  KVM: arm64: Introduce a helper to retrieve errata
  KVM: arm64: Add hypercall support for retrieving migration errata
    bitmap
  arm64: Use hypercall to check for any migration related errata
  arm64: errata: Set migration_safe_cap for MIDR based errata

 arch/arm64/include/asm/cpu_migrn_errata.h |  42 +++++++
 arch/arm64/include/asm/cpufeature.h       |  15 ++-
 arch/arm64/include/asm/kvm_host.h         |   3 +
 arch/arm64/include/asm/paravirt.h         |   4 +
 arch/arm64/include/asm/spectre.h          |   8 +-
 arch/arm64/include/uapi/asm/kvm.h         |  13 ++
 arch/arm64/kernel/cpu_errata.c            | 113 ++++++++++++++----
 arch/arm64/kernel/cpufeature.c            | 138 +++++++++++++++-------
 arch/arm64/kernel/paravirt.c              |  18 +++
 arch/arm64/kernel/proton-pack.c           |  13 +-
 arch/arm64/kvm/arm.c                      |  38 ++++++
 arch/arm64/kvm/hypercalls.c               |  20 ++++
 include/linux/arm-smccc.h                 |   8 +-
 include/uapi/linux/kvm.h                  |   2 +
 14 files changed, 361 insertions(+), 74 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpu_migrn_errata.h

-- 
2.45.2

