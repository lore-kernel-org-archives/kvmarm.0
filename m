Return-Path: <SRS0=MRwa=HJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E30C433DB
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 10:40:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58E5A64E44
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 10:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58E5A64E44
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84844B59D;
	Sun,  7 Feb 2021 05:40:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pAFbyfNs7mn9; Sun,  7 Feb 2021 05:40:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8BD4B594;
	Sun,  7 Feb 2021 05:40:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45AF34B594
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 05:40:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-FLxqGTTbqv for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Feb 2021 05:40:48 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F1B54B591
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 05:40:48 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYQdQ19Zzzj95M;
 Sun,  7 Feb 2021 18:39:38 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 18:40:37 +0800
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
To: Yi Sun <yi.y.sun@linux.intel.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
 <20210207095630.GA28580@yi.y.sun>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <407d28db-1f86-8d4f-ab15-3c3ac56bbe7f@huawei.com>
Date: Sun, 7 Feb 2021 18:40:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210207095630.GA28580@yi.y.sun>
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

On 2021/2/7 17:56, Yi Sun wrote:
> Hi,
> 
> On 21-01-28 23:17:41, Keqian Zhu wrote:
> 
> [...]
> 
>> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
>> +				     struct vfio_dma *dma)
>> +{
>> +	struct vfio_domain *d;
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		/* Go through all domain anyway even if we fail */
>> +		iommu_split_block(d->domain, dma->iova, dma->size);
>> +	}
>> +}
> 
> This should be a switch to prepare for dirty log start. Per Intel
> Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
> It enables Accessed/Dirty Flags in second-level paging entries.
> So, a generic iommu interface here is better. For Intel iommu, it
> enables SLADE. For ARM, it splits block.
Indeed, a generic interface name is better.

The vendor iommu driver plays vendor's specific actions to start dirty log, and Intel iommu and ARM smmu may differ. Besides, we may add more actions in ARM smmu driver in future.

One question: Though I am not familiar with Intel iommu, I think it also should split block mapping besides enable SLADE. Right?

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
