Return-Path: <SRS0=MRwa=HJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E13C433DB
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 12:13:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B747F64E44
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 12:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B747F64E44
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388B24B423;
	Sun,  7 Feb 2021 07:13:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C93VgIuxObb0; Sun,  7 Feb 2021 07:13:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1ADE4B447;
	Sun,  7 Feb 2021 07:13:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D16B14B427
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 07:13:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V2HNGh9ZtaD4 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Feb 2021 07:13:31 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 489FB4B423
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 07:13:31 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYSgh1VZ9zlH6k;
 Sun,  7 Feb 2021 20:11:44 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 20:13:19 +0800
Subject: Re: [RFC PATCH 05/11] iommu/arm-smmu-v3: Merge a span of page to
 block descriptor
To: Robin Murphy <robin.murphy@arm.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>, "Will
 Deacon" <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 "Marc Zyngier" <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-6-zhukeqian1@huawei.com>
 <af03aa13-9fd1-d7d1-6e55-fd59ff9d0688@arm.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <682f6b24-ecfb-d462-0d1f-5c3ba53136c0@huawei.com>
Date: Sun, 7 Feb 2021 20:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <af03aa13-9fd1-d7d1-6e55-fd59ff9d0688@arm.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Cornelia Huck <cohuck@redhat.com>, lushenming@huawei.com,
 Kirti Wankhede <kwankhede@nvidia.com>
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

Hi Robin,

On 2021/2/5 3:52, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> When stop dirty log tracking, we need to recover all block descriptors
>> which are splited when start dirty log tracking. This adds a new
>> interface named merge_page in iommu layer and arm smmuv3 implements it,
>> which reinstall block mappings and unmap the span of page mappings.
>>
>> It's caller's duty to find contiuous physical memory.
>>
>> During merging page, other interfaces are not expected to be working,
>> so race condition does not exist. And we flush all iotlbs after the merge
>> procedure is completed to ease the pressure of iommu, as we will merge a
>> huge range of page mappings in general.
> 
> Again, I think we need better reasoning than "race conditions don't exist because we don't expect them to exist".
Sure, because they can't. ;-)

> 
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 ++++++
>>   drivers/iommu/io-pgtable-arm.c              | 78 +++++++++++++++++++++
>>   drivers/iommu/iommu.c                       | 75 ++++++++++++++++++++
>>   include/linux/io-pgtable.h                  |  2 +
>>   include/linux/iommu.h                       | 10 +++
>>   5 files changed, 185 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 5469f4fca820..2434519e4bb6 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2529,6 +2529,25 @@ static size_t arm_smmu_split_block(struct iommu_domain *domain,
>>       return ops->split_block(ops, iova, size);
>>   }
[...]

>> +
>> +size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>> +            size_t size, int prot)
>> +{
>> +    phys_addr_t phys;
>> +    dma_addr_t p, i;
>> +    size_t cont_size, merged_size;
>> +    size_t merged = 0;
>> +
>> +    while (size) {
>> +        phys = iommu_iova_to_phys(domain, iova);
>> +        cont_size = PAGE_SIZE;
>> +        p = phys + cont_size;
>> +        i = iova + cont_size;
>> +
>> +        while (cont_size < size && p == iommu_iova_to_phys(domain, i)) {
>> +            p += PAGE_SIZE;
>> +            i += PAGE_SIZE;
>> +            cont_size += PAGE_SIZE;
>> +        }
>> +
>> +        merged_size = __iommu_merge_page(domain, iova, phys, cont_size,
>> +                prot);
> 
> This is incredibly silly. The amount of time you'll spend just on walking the tables in all those iova_to_phys() calls is probably significantly more than it would take the low-level pagetable code to do the entire operation for itself. At this level, any knowledge of how mappings are actually constructed is lost once __iommu_map() returns, so we just don't know, and for this operation in particular there seems little point in trying to guess - the driver backend still has to figure out whether something we *think* might me mergeable actually is, so it's better off doing the entire operation in a single pass by itself.
>
> There's especially little point in starting all this work *before* checking that it's even possible...
>
> Robin.

Well, this looks silly indeed. But the iova->phys info is only stored in pgtable. It seems that there is no other method to find continuous physical address :-( (actually, the vfio_iommu_replay() has similar logic).

We put the finding procedure of continuous physical address in common iommu layer, because this is a common logic for all types of iommu driver.

If a vendor iommu driver thinks (iova, phys, cont_size) is not merge-able, it can make its own decision to map them. This keeps same as iommu_map(), which provides (iova, paddr, pgsize) to vendor driver, and vendor driver can make its own decision to map them.

Do I understand your idea correctly?

Thanks,
Keqian
> 
>> +        iova += merged_size;
>> +        size -= merged_size;
>> +        merged += merged_size;
>> +
>> +        if (merged_size != cont_size)
>> +            break;
>> +    }
>> +    iommu_flush_iotlb_all(domain);
>> +
>> +    return merged;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_merge_page);
>> +
>>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>>   {
>>       const struct iommu_ops *ops = dev->bus->iommu_ops;
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index b87c6f4ecaa2..754b62a1bbaf 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -164,6 +164,8 @@ struct io_pgtable_ops {
>>                       unsigned long iova);
>>       size_t (*split_block)(struct io_pgtable_ops *ops, unsigned long iova,
>>                     size_t size);
>> +    size_t (*merge_page)(struct io_pgtable_ops *ops, unsigned long iova,
>> +                 phys_addr_t phys, size_t size, int prot);
>>   };
>>     /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index abeb811098a5..ac2b0b1bce0f 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -260,6 +260,8 @@ struct iommu_ops {
>>                      enum iommu_attr attr, void *data);
>>       size_t (*split_block)(struct iommu_domain *domain, unsigned long iova,
>>                     size_t size);
>> +    size_t (*merge_page)(struct iommu_domain *domain, unsigned long iova,
>> +                 phys_addr_t phys, size_t size, int prot);
>>         /* Request/Free a list of reserved regions for a device */
>>       void (*get_resv_regions)(struct device *dev, struct list_head *list);
>> @@ -513,6 +515,8 @@ extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
>>                    void *data);
>>   extern size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>>                   size_t size);
>> +extern size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>> +                   size_t size, int prot);
>>     /* Window handling function prototypes */
>>   extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
>> @@ -913,6 +917,12 @@ static inline size_t iommu_split_block(struct iommu_domain *domain,
>>       return 0;
>>   }
>>   +static inline size_t iommu_merge_page(struct iommu_domain *domain,
>> +                      unsigned long iova, size_t size, int prot)
>> +{
>> +    return -EINVAL;
>> +}
>> +
>>   static inline int  iommu_device_register(struct iommu_device *iommu)
>>   {
>>       return -ENODEV;
>>
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
