Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B607AC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 16:07:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F6C564F19
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 16:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F6C564F19
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 311594B30B;
	Thu, 25 Feb 2021 11:07:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6rKbTLaXHmCw; Thu, 25 Feb 2021 11:07:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065414B30C;
	Thu, 25 Feb 2021 11:07:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D414B30A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2021 11:07:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GL9agaMvTAmi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2021 11:07:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE224B2DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2021 11:07:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614269223;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1LjfCkqGhjloMYZKBFmWZZAZ1X89bZmtu6olw3t+15Q=;
 b=WHxbHvmrRiCQ2CbWAejgu1ct4k/4T0C8/QFGnAzxnuM3vfh6GyNlsn18PsCxtF+fwMj3hU
 EQqYLTIhEI4yh1BlHwvotNRHJXGR00/b0MwCPbu2fFQ6cf4CSoEv8OoSBgAcO4gEpJhenV
 LOHAIhC7HJP4rWT83GiMt22b3DbClPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-zc3gSELKMEeARuR0H5u4MA-1; Thu, 25 Feb 2021 11:06:54 -0500
X-MC-Unique: zc3gSELKMEeARuR0H5u4MA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A64AE86A064;
 Thu, 25 Feb 2021 16:06:50 +0000 (UTC)
Received: from [10.36.112.150] (ovpn-112-150.ams2.redhat.com [10.36.112.150])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72AC110013D6;
 Thu, 25 Feb 2021 16:06:39 +0000 (UTC)
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, maz@kernel.org,
 robin.murphy@arm.com, joro@8bytes.org, alex.williamson@redhat.com,
 tn@semihalf.com, zhukeqian1@huawei.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
Date: Thu, 25 Feb 2021 17:06:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org
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

Hi Shameer, all

On 2/23/21 9:56 PM, Eric Auger wrote:
> This series brings the IOMMU part of HW nested paging support
> in the SMMUv3. The VFIO part is submitted separately.
> 
> This is based on Jean-Philippe's
> [PATCH v12 00/10] iommu: I/O page faults for SMMUv3
> https://lore.kernel.org/linux-arm-kernel/YBfij71tyYvh8LhB@myrica/T/
> 
> The IOMMU API is extended to support 2 new API functionalities:
> 1) pass the guest stage 1 configuration
> 2) pass stage 1 MSI bindings
> 
> Then those capabilities gets implemented in the SMMUv3 driver.
> 
> The virtualizer passes information through the VFIO user API
> which cascades them to the iommu subsystem. This allows the guest
> to own stage 1 tables and context descriptors (so-called PASID
> table) while the host owns stage 2 tables and main configuration
> structures (STE).
> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> https://github.com/eauger/linux/tree/v5.11-stallv12-2stage-v14
> (including the VFIO part in its last version: v12)

As committed, I have rebased the iommu + vfio part on top of Jean's
sva/current (5.11-rc4).

https://github.com/eauger/linux/tree/jean_sva_current_2stage_v14

I have not tested the SVA bits but I have tested there is no regression
from my pov.

From the QEMU perspective is works off the shelf with that branch but if
you want to use other SVA related IOCTLs please remind of updating the
linux headers.

Again thank you to all of you who reviewed and tested the previous version.

Thanks

Eric
> 
> The VFIO series is sent separately.
> 
> History:
> 
> Previous version (v13):
> https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
> 
> v13 -> v14:
> - Took into account all received comments I think. Great
>   thanks to all the testers for their effort and sometimes
>   fixes. I am really grateful to you!
> - numerous fixes including guest running in
>   noiommu, iommu.strict=0, iommu.passthrough=on,
>   enable_unsafe_noiommu_mode
> 
> v12 -> v13:
> - fixed compilation issue with CONFIG_ARM_SMMU_V3_SVA
>   reported by Shameer. This urged me to revisit patch 4 into
>   iommu/smmuv3: Allow s1 and s2 configs to coexist where
>   s1_cfg and s2_cfg are not dynamically allocated anymore.
>   Instead I use a new set field in existing structs
> - fixed 2 others config checks
> - Updated "iommu/arm-smmu-v3: Maintain a SID->device structure"
>   according to the last version
> 
> v11 -> v12:
> - rebase on top of v5.10-rc4
> 
> Eric Auger (13):
>   iommu: Introduce attach/detach_pasid_table API
>   iommu: Introduce bind/unbind_guest_msi
>   iommu/smmuv3: Allow s1 and s2 configs to coexist
>   iommu/smmuv3: Get prepared for nested stage support
>   iommu/smmuv3: Implement attach/detach_pasid_table
>   iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>   iommu/smmuv3: Implement cache_invalidate
>   dma-iommu: Implement NESTED_MSI cookie
>   iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
>   iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI
>     regions
>   iommu/smmuv3: Implement bind/unbind_guest_msi
>   iommu/smmuv3: report additional recoverable faults
>   iommu/smmuv3: Accept configs with more than one context descriptor
> 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 444 ++++++++++++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 +-
>  drivers/iommu/dma-iommu.c                   | 142 ++++++-
>  drivers/iommu/iommu.c                       | 106 +++++
>  include/linux/dma-iommu.h                   |  16 +
>  include/linux/iommu.h                       |  47 +++
>  include/uapi/linux/iommu.h                  |  54 +++
>  7 files changed, 781 insertions(+), 42 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
