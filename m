Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D6219C54E
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 10:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734519257; cv=none; b=P6dTS8YR9mRicxgFTAKACwTwYPerpNPE7mQso3+oajT56etfzFkHCbPQhbAlNI/Gs7lpT0CugKExrUNKHi7QZ+IEXcVpQk86LLl8Tkh9QPuMwHPRpe4IM64PdJ5QS8C/3B5jBoC2Bu+Nix6e6njK9mst0inWGNw1sWvTsxuIehk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734519257; c=relaxed/simple;
	bh=NHhMNuW2EiwvueFElihpfQgQ7pzG52tOYWKzHykEpeo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eKPT2NHU92suGSdXTcNUE/xQTc6t482UluvaLImCWHgIlmve1u6xVAZAlP0ZgDqOMJo561Y36RKacNdkf8Nq0g4K7WCDNFcUIt+9gOcVCWM8rxZoVJsibiPlh4ICZT0lntXR3lgTzmVdcxnJRJ6X2rwODPZIebLNYQmLiKzvYXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YCr7H3BwMz6K99B;
	Wed, 18 Dec 2024 18:50:35 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 034B6140AA7;
	Wed, 18 Dec 2024 18:54:11 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.195.247.46) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 18 Dec 2024 11:54:02 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v4 0/3] KVM: arm64: Errata management for VM Live migration
Date: Wed, 18 Dec 2024 10:53:42 +0000
Message-ID: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 frapeml500008.china.huawei.com (7.182.85.71)

Hi,

v3 --> v4(Minor updates)
https://lore.kernel.org/kvmarm/20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com/

 -Changed MIDR/REVIDR to 64 bits based on feedback from Connie
  and Marc(Patch #3).
 -Added R-by tags from Sebastian (Thanks!).

Thanks,
Shameer

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

