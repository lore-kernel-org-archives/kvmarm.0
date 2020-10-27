Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AC4C388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 12:20:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B26522264
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 12:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B26522264
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD1C4B33C;
	Tue, 27 Oct 2020 08:20:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RV7KGtRbgCgK; Tue, 27 Oct 2020 08:20:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F754B361;
	Tue, 27 Oct 2020 08:20:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C60D4B33B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 08:20:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8NWtJfQlB2q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 08:20:17 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70C334B2E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 08:20:17 -0400 (EDT)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CL9l13sVBz4yfY;
 Tue, 27 Oct 2020 20:20:13 +0800 (CST)
Received: from dggema714-chm.china.huawei.com (10.3.20.78) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 27 Oct 2020 20:20:09 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggema714-chm.china.huawei.com (10.3.20.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 27 Oct 2020 20:20:08 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Tue, 27 Oct 2020 12:20:06 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Auger Eric <eric.auger@redhat.com>, yuzenghui <yuzenghui@huawei.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>
Subject: RE: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
Thread-Topic: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
Thread-Index: AQHWkZy5Y8YDMU7TmE6KILy51b1lHKl2CpqAgDWE0PA=
Date: Tue, 27 Oct 2020 12:20:06 +0000
Message-ID: <cb5835e79b474e30af6702dbee0d46df@huawei.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
 <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
In-Reply-To: <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.24.15]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
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

Hi Eric,

> -----Original Message-----
> From: iommu [mailto:iommu-bounces@lists.linux-foundation.org] On Behalf Of
> Auger Eric
> Sent: 23 September 2020 12:47
> To: yuzenghui <yuzenghui@huawei.com>; eric.auger.pro@gmail.com;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
> yi.l.liu@intel.com; robin.murphy@arm.com
> Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE

...

> > Besides, before going through the whole series [1][2], I'd like to
> > know if this is the latest version of your Nested-Stage-Setup work in
> > case I had missed something.
> >
> > [1]
> > https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
> > [2]
> > https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com
> 
> yes those 2 series are the last ones. Thank you for reviewing.
> 
> FYI, I intend to respin within a week or 2 on top of Jacob's  [PATCH v10 0/7]
> IOMMU user API enhancement. 

Thanks for that. Also is there any plan to respin the related Qemu series as well?
I know dual stage interface proposals are still under discussion, but it would be
nice to have a testable solution based on new interfaces for ARM64 as well.
Happy to help with any tests or verifications.

Please let me know.

Thanks,
Shameer
  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
