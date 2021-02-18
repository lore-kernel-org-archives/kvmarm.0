Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B762C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 01:17:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A00564E45
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 01:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A00564E45
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC0E4B41A;
	Wed, 17 Feb 2021 20:17:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id szAS9OvVRF3x; Wed, 17 Feb 2021 20:17:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7484B433;
	Wed, 17 Feb 2021 20:17:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77ABE4B407
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 20:17:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G471RkGhyBDP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2021 20:17:20 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFEF94B3FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 20:17:19 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DgxbD5cy2zlLmm;
 Thu, 18 Feb 2021 09:15:20 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Feb 2021 09:17:06 +0800
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
To: Yi Sun <yi.y.sun@linux.intel.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
 <20210207095630.GA28580@yi.y.sun>
 <407d28db-1f86-8d4f-ab15-3c3ac56bbe7f@huawei.com>
 <20210209115744.GB28580@yi.y.sun>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <811dac11-a530-3218-9819-cea628ccefbc@huawei.com>
Date: Thu, 18 Feb 2021 09:17:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210209115744.GB28580@yi.y.sun>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 kevin.tian@intel.com, yan.y.zhao@intel.com, Alex
 Williamson <alex.williamson@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 lushenming@huawei.com, iommu@lists.linux-foundation.org,
 Robin Murphy <robin.murphy@arm.com>, baolu.lu@linux.intel.com
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

Hi Yi,

On 2021/2/9 19:57, Yi Sun wrote:
> On 21-02-07 18:40:36, Keqian Zhu wrote:
>> Hi Yi,
>>
>> On 2021/2/7 17:56, Yi Sun wrote:
>>> Hi,
>>>
>>> On 21-01-28 23:17:41, Keqian Zhu wrote:
>>>
>>> [...]
>>>
>>>> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
>>>> +				     struct vfio_dma *dma)
>>>> +{
>>>> +	struct vfio_domain *d;
>>>> +
>>>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>>>> +		/* Go through all domain anyway even if we fail */
>>>> +		iommu_split_block(d->domain, dma->iova, dma->size);
>>>> +	}
>>>> +}
>>>
>>> This should be a switch to prepare for dirty log start. Per Intel
>>> Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
>>> It enables Accessed/Dirty Flags in second-level paging entries.
>>> So, a generic iommu interface here is better. For Intel iommu, it
>>> enables SLADE. For ARM, it splits block.
>> Indeed, a generic interface name is better.
>>
>> The vendor iommu driver plays vendor's specific actions to start dirty log, and Intel iommu and ARM smmu may differ. Besides, we may add more actions in ARM smmu driver in future.
>>
>> One question: Though I am not familiar with Intel iommu, I think it also should split block mapping besides enable SLADE. Right?
>>
> I am not familiar with ARM smmu. :) So I want to clarify if the block
> in smmu is big page, e.g. 2M page? Intel Vtd manages the memory per
Yes, for ARM, the "block" is big page :).

> page, 4KB/2MB/1GB. There are two ways to manage dirty pages.
> 1. Keep default granularity. Just set SLADE to enable the dirty track.
> 2. Split big page to 4KB to get finer granularity.
According to your statement, I see that VT-D's SLADE behaves like smmu HTTU. They are both based on page-table.

Right, we should give more freedom to iommu vendor driver, so a generic interface is better.
1) As you said, set SLADE when enable dirty log.
2) IOMMUs of other architecture may has completely different dirty tracking mechanism.

> 
> But question about the second solution is if it can benefit the user
> space, e.g. live migration. If my understanding about smmu block (i.e.
> the big page) is correct, have you collected some performance data to
> prove that the split can improve performance? Thanks!
The purpose of splitting block mapping is to reduce the amount of dirty bytes, which depends on actual DMA transaction.
Take an extreme example, if DMA writes one byte, under 1G mapping, the dirty amount reported to userspace is 1G, but under 4K mapping, the dirty amount is just 4K.

I will detail the commit message in v2.

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
