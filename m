Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FFD76908;
	Thu,  8 Feb 2024 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405646; cv=none; b=l+oCscE6EjT1+TWWkD8jQywr8+Bz0ftALO5U1UNXoDLeAEHHKwZOLBr+NK+mAfcij36lTt+1FVmHLWZsndhmsn+KMuyb9m3Vs1Dl5GupFBOajYH2+b8DeJ3nOx2OuyE3dOpSiGFRJy0LYpveCsm9TePbpEuzNl79+be6HEes71Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405646; c=relaxed/simple;
	bh=8BfyqnrLs4LwrLAGTMIGN2PpFP3Ol1yzVSrwSbGQez4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RiM4EByV7xpQChN2OAMkWdluiFSKezmb9droY2b8FPGC7WB2qUufntQYY3f55ERC/hCjb7v0reTCdFUiMTmY4r/yeuM8bINScL4l2Nvea8CU+bq76kKARE64f4ELtJZOGQMOfsjZ31wt8T+Z7hQR5juIaGg7NepLkF7o4trUuwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0vy00GNz67nmT;
	Thu,  8 Feb 2024 23:17:17 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id E33C9140595;
	Thu,  8 Feb 2024 23:20:39 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:20:33 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for stage 2
Date: Thu, 8 Feb 2024 15:18:30 +0000
Message-ID: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

Hi,

On an ARM64 system with a SMMUv3 implementation that fully supports
Broadcast TLB Maintenance(BTM) feature as part of the Distributed
Virtual Memory(DVM) protocol, the CPU TLB invalidate instructions are
received by SMMUv3. This is very useful when the SMMUv3 shares the
page tables with the CPU(eg: Guest SVA use case). For this to work,
the SMMUv3 must use the same VMID that is allocated by KVM to configure
the nested stage 2(S2) translations.

An earlier proposal sent out[1] a while back resulted in changing the
ARM64/KVM VMID allocator similar to the ASID allocator to make it
better suited for this.

This RFC adds,
 -Support for pinned KVM VMID.
 -Support associating KVM pointer and iommufd ctx.
 -Changes to domain_alloc_user() to receive a kvm pointer.
 -Configure SMMUV3 S2 using KVM VMID
 -Finally enable BTM only if SMMUV3 supports S1 translation. This
  is to make sure that PAGING domains always use S1 and S2 is only
  used for nested domains with a valid KVM. The idea is to make sure
  when BTM is enabled in Guest, we use KVM VMID for S2.

Not sure I miss any explicit TLB invalidations with any use case
that may configure a S2 with a private VMID that matches a KVM
one.

This is based on Jason's ongoing SMMUv3 refactor series[2].

Please take a look and let me know.

Thanks,
Shameer

1. https://lore.kernel.org/linux-arm-kernel/20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com/
2. https://lore.kernel.org/linux-arm-kernel/0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com/

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Enable broadcast TLB maintenance

Shameer Kolothum (6):
  KVM: Add generic infrastructure to support pinned VMIDs
  KVM: arm64: Introduce support to pin VMIDs
  KVM: arm64: Add interfaces for pinned VMID support
  iommufd: Associate kvm pointer to iommufd ctx
  iommu: Pass in kvm pointer to domain_alloc_user
  iommu/arm-smmu-v3: Use KVM VMID for s2 stage

 arch/arm64/include/asm/kvm_host.h           |  3 +
 arch/arm64/kvm/Kconfig                      |  1 +
 arch/arm64/kvm/arm.c                        | 14 ++++
 arch/arm64/kvm/vmid.c                       | 84 ++++++++++++++++++++-
 drivers/iommu/amd/iommu.c                   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 42 +++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +
 drivers/iommu/intel/iommu.c                 |  1 +
 drivers/iommu/iommufd/hw_pagetable.c        |  5 +-
 drivers/iommu/iommufd/iommufd_private.h     |  3 +
 drivers/iommu/iommufd/main.c                | 14 ++++
 drivers/iommu/iommufd/selftest.c            |  1 +
 drivers/vfio/device_cdev.c                  |  3 +
 include/linux/iommu.h                       |  3 +-
 include/linux/iommufd.h                     |  7 ++
 include/linux/kvm_host.h                    | 18 +++++
 virt/kvm/Kconfig                            |  3 +
 virt/kvm/kvm_main.c                         | 23 ++++++
 18 files changed, 218 insertions(+), 11 deletions(-)

-- 
2.34.1

