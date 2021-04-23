Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139C9C433B4
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 08:31:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B9496145D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 08:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B9496145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C8B4B397;
	Fri, 23 Apr 2021 04:31:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VfyONHxGyHzA; Fri, 23 Apr 2021 04:31:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6A34B37F;
	Fri, 23 Apr 2021 04:31:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDEC64B366
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:31:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cXtu9PEok5Dk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 04:31:15 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 339E44B314
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:31:14 -0400 (EDT)
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FRS872hQ1zWb1D;
 Fri, 23 Apr 2021 16:27:19 +0800 (CST)
Received: from dggpeml100024.china.huawei.com (7.185.36.115) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 23 Apr 2021 16:31:09 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggpeml100024.china.huawei.com (7.185.36.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:31:08 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Fri, 23 Apr 2021 09:31:06 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v4 00/16] kvm/arm: Align the VMID allocation with the
 arm64 ASID one
Thread-Topic: [PATCH v4 00/16] kvm/arm: Align the VMID allocation with the
 arm64 ASID one
Thread-Index: AQHXMSCyInFjZI/53EW8vK01de3czarAsIkAgAENuIA=
Date: Fri, 23 Apr 2021 08:31:06 +0000
Message-ID: <acb761853cb1494a9eb2c345ddd9afd4@huawei.com>
References: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
 <20210422160846.GB2214@willie-the-truck>
In-Reply-To: <20210422160846.GB2214@willie-the-truck>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.94.116]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "julien@xen.org" <julien@xen.org>, "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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



> -----Original Message-----
> From: Will Deacon [mailto:will@kernel.org]
> Sent: 22 April 2021 18:09
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org; julien@xen.org; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [PATCH v4 00/16] kvm/arm: Align the VMID allocation with the
> arm64 ASID one
> 
> On Wed, Apr 14, 2021 at 12:22:56PM +0100, Shameer Kolothum wrote:
> > Hi,
> >
> > This is an attempt to revive this series originally posted by
> > Julien Grall[1]. The main motive to work on this now is because
> > of the requirement to have Pinned KVM VMIDs and the RFC discussion
> > for the same basically suggested[2] to have a common/better vmid
> > allocator for KVM which this series provides.
> >
> > Major Changes from v3:
> >
> > -Changes related to Pinned ASID support.
> > -Changes to take care KPTI related bits reservation.
> > -Dropped support for 32 bit KVM.
> > -Rebase to 5.12-rc7
> >
> > Individual patches have change history for any major changes
> > from v3.
> >
> > Tests were performed on a HiSilicon D06 platform and so far not observed
> > any regressions.
> >
> > For ASID allocation,
> >
> > Avg of 10 runs(hackbench -s 512 -l 200 -g 300 -f 25 -P),
> > 5.12-rc7: Time:18.8119
> > 5.12-rc7+v4: Time: 18.459
> >
> > ~1.8% improvement.
> >
> > For KVM VMID,
> >
> > The measurement was made with maxcpus set to 8 and with the
> > number of VMID limited to 4-bit. The test involves running
> > concurrently 40 guests with 2 vCPUs. Each guest will then
> > execute hackbench 5 times before exiting.
> >
> > The performance difference between the current algo and the
> > new one are(ag. of 10 runs):
> >     - 1.9% less exit from the guest
> >     - 0.7% faster
> >
> > For complete series, please see,
> >  https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4
> >
> > Please take a look and let me know your feedback.
> 
> Although I think aligning the two algorithms makes sense, I'm not completely
> sold on the need to abstract all this into a library and whether the
> additional indirection is justified.
> 
> It would be great to compare this approach with one where portions of the
> code are duplicated into a separate VMID allocator. Have you tried that to
> see what it looks like? Doesn't need to be a proper patch set, but comparing
> the end result might help to evaluate the proposal here.

Ok. I will give it a go and get back.

Thanks,
Shameer
	
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
