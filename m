Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F50C4361A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 18:43:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96CE4217BA
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 18:43:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96CE4217BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8EAF4B1AD;
	Thu,  3 Dec 2020 13:43:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ldVkA7+bIYyk; Thu,  3 Dec 2020 13:43:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 849A24B1BC;
	Thu,  3 Dec 2020 13:43:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 911E74B1AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 13:43:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RLrwcgxj5Q32 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 13:43:09 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B7B24B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 13:43:09 -0500 (EST)
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Cn4Sj3QmgzVgff;
 Fri,  4 Dec 2020 02:42:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 4 Dec 2020 02:42:59 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Thu, 3 Dec 2020 18:42:57 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Auger Eric <eric.auger@redhat.com>, wangxingang <wangxingang5@huawei.com>
Subject: RE: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Topic: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Index: AQHWvZ36CODK3kmCyk2T9hmchYhCqqniWTe/gANqCPA=
Date: Thu, 3 Dec 2020 18:42:57 +0000
Message-ID: <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
In-Reply-To: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.67.109]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: Xieyingtai <xieyingtai@huawei.com>,
 "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 qubingbing <qubingbing@hisilicon.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
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
> From: kvmarm-bounces@lists.cs.columbia.edu
> [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Auger Eric
> Sent: 01 December 2020 13:59
> To: wangxingang <wangxingang5@huawei.com>
> Cc: Xieyingtai <xieyingtai@huawei.com>; jean-philippe@linaro.org;
> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> vivek.gautam@arm.com; alex.williamson@redhat.com;
> zhangfei.gao@linaro.org; robin.murphy@arm.com;
> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com
> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
> unmanaged ASIDs
> 
> Hi Xingang,
> 
> On 12/1/20 2:33 PM, Xingang Wang wrote:
> > Hi Eric
> >
> > On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
> >> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void
> *cookie)
> >> 	 * insertion to guarantee those are observed before the TLBI. Do be
> >> 	 * careful, 007.
> >> 	 */
> >> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> >> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
> >> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
> >> +		cmd.tlbi.asid	= ext_asid;
> >> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
> >> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> >
> > Found a problem here, the cmd for guest stage 1 invalidation is built,
> > but it is not delivered to smmu.
> >
> 
> Thank you for the report. I will fix that soon. With that fixed, have
> you been able to run vSVA on top of the series. Do you need other stuff
> to be fixed at SMMU level? 

I am seeing another issue with this series. This is when you have the vSMMU
in non-strict mode(iommu.strict=0). Any network pass-through dev with iperf run 
will be enough to reproduce the issue. It may randomly stop/hang.

It looks like the .flush_iotlb_all from guest is not propagated down to the host
correctly. I have a temp hack to fix this in Qemu wherein CMDQ_OP_TLBI_NH_ASID
will result in a CACHE_INVALIDATE with IOMMU_INV_GRANU_PASID flag and archid
set.

Please take a look and let me know. 

As I am going to respin soon, please let me
> know what is the best branch to rebase to alleviate your integration.

Please find the latest kernel and Qemu branch with vSVA support added here,

https://github.com/hisilicon/kernel-dev/tree/5.10-rc4-2stage-v13-vsva
https://github.com/hisilicon/qemu/tree/v5.2.0-rc1-2stage-rfcv7-vsva

I have done some basic minimum vSVA tests on a HiSilicon D06 board with
a zip dev that supports STALL. All looks good so far apart from the issues
that have been already reported/discussed.

The kernel branch is actually a rebase of sva/uacce related patches from a
Linaro branch here,

https://github.com/Linaro/linux-kernel-uadk/tree/uacce-devel-5.10

I think going forward it will be good(if possible) to respin your series on top of
a sva branch with STALL/PRI support added. 

Hi Jean/zhangfei,
Is it possible to have a branch with minimum required SVA/UACCE related patches
that are already public and can be a "stable" candidate for future respin of Eric's series?
Please share your thoughts.

Thanks,
Shameer 

> Best Regards
> 
> Eric
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
