Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AB615530C
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740146940; cv=none; b=MNDJd7TbwJp+Tk1iYuQYEowLGi9uQhqtwROveaBgbnzcPFoJOuywAOrU+EOYPN66oZnw8iktzQJGyJ2jFaX75918IhGAijc9GLb6PybOMH56DsMIpnA1ZSFD90BPpZcfpMux2R4tWwdJSRX+OWz9U1UBSnUgqXAcpoz5wsj5+Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740146940; c=relaxed/simple;
	bh=la+MVM6rbVoOHkWiJ2jjhRg27gd1FRZ74/VfQeFvGUw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J5xWaV5VFzuUF8YLlzB5IApbhNbJmxavbLKnZC4lCgeJl44UOVZv52AnOTRdGo3upmJLH1aU5JsuzoiO/yREeO8jWlbFHDUD8khKwHIttyin0TpS0YBXJpNffGditC7YKX/Zmq33QiE0Y6AGJNxUHQg2p0VaCy82DBJDUqeVGlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YzsP31c4bz6L72m;
	Fri, 21 Feb 2025 22:06:15 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 614D51400D9;
	Fri, 21 Feb 2025 22:08:54 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Feb 2025 15:08:46 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v8 0/6] KVM: arm64: Errata management for VM Live migration
Date: Fri, 21 Feb 2025 14:02:23 +0000
Message-ID: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

Hi,

v7-->v8
https://lore.kernel.org/kvmarm/20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com/

Changes:
 -Fixed the compile error issue due to CONFIG_CORESIGHT_SOURCE_ETM4X=m
  (Thanks to Sebastian for checking that config)- patch #4
 -Added R-by tags.
 
This can be sanity tested by the Qemu branch here,
https://github.com/hisilicon/qemu/tree/v9.0-nv-rfcv4-vcpu-model-v2-target-cpu-errata
(branch based on Eric's/Connie's NV + custom CPU series)
Eg: to specify target impl CPUs,
-machine virt,.., x-target-impl-cpus=0xMIDR1:0xREVIDR1-0xMIDR2:REVIDR2

Please take a look and let me know your feedback.

Thanks,
Shameer

v6-->v7
https://lore.kernel.org/kvmarm/20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com/

Changes:
 -Introduced KVM_REG_ARM_VENDOR_HYP_BMAP_2 register for new hypercall
  support(patch #3)
 -Added selftest for KVM_REG_ARM_VENDOR_HYP_BMAP_2(patch #5).

v5 --> v6
https://lore.kernel.org/kvmarm/20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com/

-Addressed comments from Oliver,
 -Changed version to 32 bit to match SMCCC_VERSION
 -Don't advertise pKVM hypercalls to guests.
 -Moved hypercall invocation to kvm_guest.c
v4 --> v5
https://lore.kernel.org/kvmarm/20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com/

-Addressed comments from Marc,
 -Added an hypercall to retrieve version and number of supported target
  impl CPUs.
 -Added a check for KVM hypercall services availability.
-Removed R-by tags from Connie & Sebastian as patches 2 & 4 are now
 changed a bit. Please take another look.

v3 --> v4(Minor updates)
https://lore.kernel.org/kvmarm/20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com/

 -Changed MIDR/REVIDR to 64 bits based on feedback from Connie
  and Marc(Patch #3).
 -Added R-by tags from Sebastian (Thanks!).

RFC v2 --> v3
https://lore.kernel.org/kvmarm/20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com/

 -Addressed comments from Oliver(Thanks!).
 -Using implementation CPUs MIDR/REVIDR when it is set for
  _midr_range() functions(Patch 1 & 3)
 -New hypercall for retrieving implementation CPUs(Patch #2).
 -Dropped RFC.

RFC v1 --> RFCv2:
https://lore.kernel.org/kvmarm/20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com/
 -Introduced hypercalls to retrieve target CPUs info from user space VMM.
  see patch #1 for details.
 -Patch #2 uses the hypercall to retrieve the target CPU info if any.
 -Use the target CPUs MIDR/REVIDR in errata enablement. See patch #3.

Background from v1:

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

Shameer Kolothum (6):
  arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
  KVM: arm64: Introduce hypercall support for retrieving target
    implementations
  KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
  arm64: Make  _midr_in_range_list() an exported function
  smccc/kvm_guest: Enable errata based on implementation CPUs
  KVM: selftests: Add test for KVM_REG_ARM_VENDOR_HYP_BMAP_2

 .../virt/kvm/arm/fw-pseudo-registers.rst      | 15 +++-
 Documentation/virt/kvm/arm/hypercalls.rst     | 59 +++++++++++++++
 arch/arm64/include/asm/cputype.h              | 40 +++++-----
 arch/arm64/include/asm/hypervisor.h           |  1 +
 arch/arm64/include/asm/kvm_host.h             |  3 +-
 arch/arm64/include/asm/mmu.h                  |  3 +-
 arch/arm64/include/uapi/asm/kvm.h             | 12 +++
 arch/arm64/kernel/cpu_errata.c                | 73 ++++++++++++++++---
 arch/arm64/kernel/cpufeature.c                |  8 +-
 arch/arm64/kernel/image-vars.h                |  1 +
 arch/arm64/kernel/proton-pack.c               | 17 ++---
 arch/arm64/kvm/hypercalls.c                   | 13 ++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |  2 +-
 drivers/clocksource/arm_arch_timer.c          |  2 +-
 drivers/firmware/smccc/kvm_guest.c            | 64 ++++++++++++++++
 .../coresight/coresight-etm4x-core.c          |  2 +-
 include/linux/arm-smccc.h                     | 15 ++++
 tools/arch/arm64/include/uapi/asm/kvm.h       | 12 +++
 .../selftests/kvm/arm64/get-reg-list.c        |  1 +
 .../testing/selftests/kvm/arm64/hypercalls.c  | 46 +++++++++---
 20 files changed, 327 insertions(+), 62 deletions(-)

-- 
2.47.0

