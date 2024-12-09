Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641C221DA6
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 11:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733745215; cv=none; b=gfyJoMHRIj73VluK17mh2T+qRO2P/JtEjlxZrrEuI22uw1z3vymT5y/Ot8HK8wwHHilLxvRsFmBWFt+8FIQfdfAK8ZZ2XeXlWMkoMhKIfq7iE2CTC6k50V0QGq3YCzzZgkBxc4eEn4T0GGhunX8K4pwqtp1/xuM9+0BYd2HIINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733745215; c=relaxed/simple;
	bh=xNPD/w2SVdW20hGvi26Wm1cEJMYIW/iYuwcRnJiyjqo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nwZsNizQOKJOV1gbxgQCpsdmMRY3oZ7Oeo65eYr1I9Mh8YlNdKDZAzYUT/4/aAydgUr8J1bmZKgYySGX5oHT5SYJZ8Cevtk+W3z3w4w/6bLoHb0A/z3f7DsVPph2/+XN3OPL9XiqRBr35LhwM3FvlN3NdYW6UeCJ/ILo7Ed0iug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y6Krq3fC4z6GC3Q;
	Mon,  9 Dec 2024 19:48:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A73C140A30;
	Mon,  9 Dec 2024 19:53:30 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 12:53:23 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v3 0/3] KVM: arm64: Errata management for VM Live migration
Date: Mon, 9 Dec 2024 11:53:08 +0000
Message-ID: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

Hi,

Changes from RFC v2[1]:

 -Addressed comments from Oliver(Thanks!).
 -Using implementation CPUs MIDR/REVIDR when it is set for
  _midr_range() functions(Patch 1 & 3)
 -New hypercall for retrieving implementation CPUs(Patch #2).
 -Dropped RFC.

Sanity tested on a HiSilicon ARM64 platform using a hacked Qemu that can
handle the above hypercall.

Thanks,
Shameer
[1] https://lore.kernel.org/kvmarm/20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com/

Changes from RFC v1:
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

Shameer Kolothum (3):
  arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
  KVM: arm64: Introduce hypercall support for retrieving target
    implementations
  arm64: paravirt: Enable errata based on implementation CPUs

 Documentation/virt/kvm/arm/hypercalls.rst | 30 +++++++++++++
 arch/arm64/include/asm/cputype.h          | 51 ++++++++++++++++-------
 arch/arm64/include/asm/mmu.h              |  3 +-
 arch/arm64/include/asm/paravirt.h         |  3 ++
 arch/arm64/kernel/cpu_errata.c            | 37 +++++++++++-----
 arch/arm64/kernel/cpufeature.c            |  8 ++--
 arch/arm64/kernel/image-vars.h            |  2 +
 arch/arm64/kernel/paravirt.c              | 31 ++++++++++++++
 arch/arm64/kernel/proton-pack.c           | 17 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c             |  2 +-
 drivers/clocksource/arm_arch_timer.c      |  2 +-
 include/linux/arm-smccc.h                 |  7 ++++
 12 files changed, 152 insertions(+), 41 deletions(-)

-- 
2.47.0

