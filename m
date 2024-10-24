Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA302757FC
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762837; cv=none; b=OI4Elv46fy9U132YKPVcOWNeiFVgiDoREg4s4/49Pfu1L+xqGC4aI13iHfvXjaLSvCY0WUZVTzVmYI4AM3XU2/wLa3BPdiKocAaodWjfmm10tQ+/MuxV7jw8UOpywqqCHFEs26PvW/Z1z+xFFBFRug3BkCvISil7TtnXS5wOoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762837; c=relaxed/simple;
	bh=ttaRqGo6vaAGjCsstiXRWbO6aKPyLN7lnVTcd3oa+6Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aOEsDJXkrkdLlUi1ZmPPTSWnfhv0K0HvZ4Z4jb/If4rFQH2OGZVg+YlfHJBQVvsAWxF60iXUw0WxnPFn517wlJrFeY4u8LcF7zc/raRT4zdgtNwaJ54q0/7FfvPjjy5prqxapgO6S/N5oTVwuQhtoXmOAIoR3WTxsYCLwpqX8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ14R4V3Cz6LDBr;
	Thu, 24 Oct 2024 17:35:51 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 46297140B2F;
	Thu, 24 Oct 2024 17:40:33 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 11:40:26 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 0/3] KVM: arm64: Errata management for VM Live migration
Date: Thu, 24 Oct 2024 10:40:09 +0100
Message-ID: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
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

This is another attempt on this based on the feedback received
for RFC v1. Thanks for all the discussions and suggestions.

Changes from RFC v1[0]:
 -Introduced hypercalls to retrieve target CPUs info from user space VMM.
  see patch #1 for details.
 -Patch #2 uses the hypercall to retrieve the target CPU info if any.
 -Use the target CPUs MIDR/REVIDR in errata enablement. See patch #3.

Sanity tested on a HiSilicon ARM64 platform using a hacked Qemu that can
handle the above-mentioned hypercalls.

Please take a look and let me know if this is in the right direction or
not.

Also TBD:
1. Do we need some way of notifying the userspace VMM in case the Guest
   fails to update target CPUs?
2. Usage of synthetic MIDR mentioned in RFC v1 discussion. How do we
   envision the synthetic MIDR to be used/supported?
   1. VMM writes synthetic MIDR to KVM(SET_ONE_REG)
   2. Uses Guest hypercall to update the target CPUs info.

   If this is the case what happens if an old Guest (without hypercall
   support) is used?  VMM will abort the Guest if no hypercall is 
   received but a synthetic MIDR is set?

Thanks,
Shameer

[0]https://lore.kernel.org/kvmarm/20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com/

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
  KVM: arm64: Add hypercall support for retrieving migration targets
  KVM: arm64: Use hypercall to retrieve any migration targets
  KVM: arm64: Enable errata based on migration target CPUs

 Documentation/virt/kvm/arm/hypercalls.rst | 77 +++++++++++++++++++++++
 arch/arm64/include/asm/cpufeature.h       |  7 +++
 arch/arm64/include/asm/paravirt.h         |  3 +
 arch/arm64/kernel/cpu_errata.c            | 49 ++++++++++++---
 arch/arm64/kernel/cpufeature.c            |  3 +
 arch/arm64/kernel/paravirt.c              | 48 ++++++++++++++
 include/linux/arm-smccc.h                 | 13 ++++
 7 files changed, 190 insertions(+), 10 deletions(-)

-- 
2.45.2

