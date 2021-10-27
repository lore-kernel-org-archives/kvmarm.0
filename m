Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EF9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:45:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9504560F6F
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9504560F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6874B163;
	Wed, 27 Oct 2021 06:45:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e8UjsmK2TBT6; Wed, 27 Oct 2021 06:45:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E8B4B152;
	Wed, 27 Oct 2021 06:45:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5D34B152
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tlCIR2SXQIJp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 06:44:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C56B4B105
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:44:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635331498;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=J5wkNJA4/lA1zpS1Ea7vtbcReRVBjOp0e4WxjwmsxNM=;
 b=Q9a1UPZCKaCZFmVUfK5RIJfbJxCqzL6/Li1SVHPUZH0ipBRFQNvpgsr9bg1R7AgUNVapXU
 A46Y+KYHjs+WIiBYw7kkn/yYtzVNXQbKQ3t4Tz2KZnjJPHKr02CweAm9IDE5tzOtMGw7W+
 6Y1c5y1lYz9m+lOp+DWJLIp2eA6jUuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-kAK16uk_N5C6alI-CsSs_g-1; Wed, 27 Oct 2021 06:44:52 -0400
X-MC-Unique: kAK16uk_N5C6alI-CsSs_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCC5A19200C0;
 Wed, 27 Oct 2021 10:44:48 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 95422100E12D;
 Wed, 27 Oct 2021 10:44:32 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
Subject: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
Date: Wed, 27 Oct 2021 12:44:19 +0200
Message-Id: <20211027104428.1059740-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 chenxiang66@hisilicon.com, maz@kernel.org, vdumpa@nvidia.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, nicolinc@nvidia.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, sumitg@nvidia.com, lushenming@huawei.com,
 wangxingang5@huawei.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This series brings the IOMMU part of HW nested paging support
in the SMMUv3.

The SMMUv3 driver is adapted to support 2 nested stages.

The IOMMU API is extended to convey the guest stage 1
configuration and the hook is implemented in the SMMUv3 driver.

This allows the guest to own the stage 1 tables and context
descriptors (so-called PASID table) while the host owns the
stage 2 tables and main configuration structures (STE).

This work mainly is provided for test purpose as the upper
layer integration is under rework and bound to be based on
/dev/iommu instead of VFIO tunneling. In this version we also get
rid of the MSI BINDING ioctl, assuming the guest enforces
flat mapping of host IOVAs used to bind physical MSI doorbells.
In the current QEMU integration this is achieved by exposing
RMRs to the guest, using Shameer's series [1]. This approach
is RFC as the IORT spec is not really meant to do that
(single mapping flag limitation).

Best Regards

Eric

This series (Host) can be found at:
https://github.com/eauger/linux/tree/v5.15-rc7-nested-v16
This includes a rebased VFIO integration (although not meant
to be upstreamed)

Guest kernel branch can be found at:
https://github.com/eauger/linux/tree/shameer_rmrr_v7
featuring [1]

QEMU integration (still based on VFIO and exposing RMRs)
can be found at:
https://github.com/eauger/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
(use iommu=nested-smmuv3 ARM virt option)

Guest dependency:
[1] [PATCH v7 0/9] ACPI/IORT: Support for IORT RMR node

History:

v15 -> v16:
- guest RIL must support RIL
- additional checks in the cache invalidation hook
- removal of the MSI BINDING ioctl (tentative replacement
  by RMRs)


Eric Auger (9):
  iommu: Introduce attach/detach_pasid_table API
  iommu: Introduce iommu_get_nesting
  iommu/smmuv3: Allow s1 and s2 configs to coexist
  iommu/smmuv3: Get prepared for nested stage support
  iommu/smmuv3: Implement attach/detach_pasid_table
  iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
  iommu/smmuv3: Implement cache_invalidate
  iommu/smmuv3: report additional recoverable faults
  iommu/smmuv3: Disallow nested mode in presence of HW MSI regions

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 383 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |   8 +
 drivers/iommu/intel/iommu.c                 |  13 +
 drivers/iommu/iommu.c                       |  79 ++++
 include/linux/iommu.h                       |  35 ++
 include/uapi/linux/iommu.h                  |  54 +++
 7 files changed, 548 insertions(+), 38 deletions(-)

-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
