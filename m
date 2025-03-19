Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E84918DF93;
	Wed, 19 Mar 2025 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405563; cv=none; b=PJKUq/T17JOVtUrSTIBqbsvV4HzrNcNBaF91aaGKu3xyiIW240uBg/PBXHEp+ahGf6U7WhaX+356XHNmGxLUonr68nSxTQSbu3lSDPoldqKpaW+zMo6Ym3xuJbYSIBePie7fAjGc/0zA2XahPwcrSrKpSlGcYvDh+i1ErdtOnis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405563; c=relaxed/simple;
	bh=tg2pJBNECZeF8c6n5hBKnp0GypgufHB36EhTIl3JHq4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Lvl5etAKEixvlFh8TQ0V0DzG6/r53Miwv6vwOZxmdAjgUQW5UnxdSLlFwXBD61rn+DlZcsavIjjSZCF/HEb5YRYgJJmil05M/d3rJ3Hif01N5ptST1y+hdZe3j+TR7IaDW4O8qVT+9IYSvRik8+PCvecWLftxBIwisN3F/RgHaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZHwdT20mwz6L5JL;
	Thu, 20 Mar 2025 01:27:41 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8AC831402A5;
	Thu, 20 Mar 2025 01:32:32 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Mar 2025 18:32:25 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: <linuxarm@huawei.com>, <kevin.tian@intel.com>, <jgg@ziepe.ca>,
	<alex.williamson@redhat.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<will@kernel.org>, <robin.murphy@arm.com>, <nicolinc@nvidia.com>,
	<jean-philippe@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 0/5] iommu/arm-smmu-v3: Use pinned KVM VMID for stage 2
Date: Wed, 19 Mar 2025 17:31:57 +0000
Message-ID: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
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

Hi All,

Changes from RFCv2[0]

-Based on feedback received, removed generic KVM APIs for pinned_vmid_
 {get,put}() and are now implemented directly by KVM ARM.
-struct kvm * is now associated with struct iommufd_device and the association
 is established when idev is first allocated during iommufd_device_bind().
-This is now based on Nicolin's recent series[1], which decouples the vmid
 from S2 parent domains and is assigned during viommu/vSMMU alloc time.
-Added additional checks to make sure when BTM is enabled, kvm is mandatory.
-At the moment, kvm_get_kvm_safe()/kvm_put_kvm() is used inside the smmuv3
 driver and not in iommufd as iommufd is not a user of kvm and is just
 passed through.

ToDo:
-May be we need to check both KVM and SMMUv3 has the same number of VMID
bits supported. Not sure we have systems like that out there.

Why we require this(Thanks to Jean for the nice write-up below):

---
* When enabling BTM in the SMMU, all TLB invalidations to the
  inner-shareable domain issued by the CPU are taken into account by the
  SMMU. That includes for example the TLBI IPAS2E1IS from
  __kvm_tlb_flush_vmid_range().

* BTM is enabled globally in the SMMU CR2 register. If we enable BTM for
  host SVA, then it also affects KVM.

* Stage-1 TLB entries in the SMMU have a bit (ASET) saying "this entry
  is private and does not participate in BTM", which we set for private
  SMMU address spaces.

  Annoyingly, the stage-2 TLB entries do not have it. With BTM all VMIDs
  are shared between CPU and SMMU.

* So, if the SMMU driver allocates VMID privately and we enable BTM, then
  CPU invalidations will remove unrelated SMMU TLB entries. Instead, the
  SMMU driver needs to coordinate with KVM on VMID allocation.

* Private stage-2 address spaces in the SMMU would need to allocate VMIDs
  that aren't used by KVM, but that's not a use-case at the moment:

  - For assigning devices to a host process or to a VM, we use private
    stage-1 mappings. stage-2 will be used to enable nesting translation,
    and will typically mirror the KVM stage-2 since it pins the guest
    address space.

  - If the SMMU doesn't support stage-1, the driver falls back to stage-2
    for private address spaces. For such an implementation we disable BTM.
---

This is sanity tested on a HiSilicon platform and the complete branch is
available here[2].

Please take a look and let me know your feedback.

Thanks,
Shameer
[0] https://lore.kernel.org/kvmarm/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
[1] https://lore.kernel.org/linux-iommu/cover.1741150594.git.nicolinc@nvidia.com/
[2] https://github.com/hisilicon/kernel-dev/tree/smmuv3_vmid-v1-with-rmr-vmid-v3-ext

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Enable broadcast TLB maintenance

Shameer Kolothum (4):
  KVM: arm64: Introduce support to pin VMIDs
  iommufd/device: Associate a kvm pointer to iommufd_device
  iommu/arm-smmu-v3-iommufd: Pass in kvm pointer to viommu_alloc
  iommu/arm-smmu-v3-iommufd: Use KVM VMID for s2 stage

 arch/arm64/include/asm/kvm_host.h             |  3 +
 arch/arm64/kvm/vmid.c                         | 76 ++++++++++++++++++-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 54 ++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +
 drivers/iommu/iommufd/device.c                |  5 +-
 drivers/iommu/iommufd/iommufd_private.h       |  2 +
 drivers/iommu/iommufd/viommu.c                |  3 +-
 drivers/vfio/iommufd.c                        |  2 +-
 include/linux/iommu.h                         |  4 +-
 include/linux/iommufd.h                       |  4 +-
 11 files changed, 168 insertions(+), 12 deletions(-)

-- 
2.47.0

