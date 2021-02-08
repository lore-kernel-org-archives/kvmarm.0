Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B40C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 01:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DFC464E85
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 01:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFC464E85
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BCC14B616;
	Sun,  7 Feb 2021 20:17:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bl0QXLMK6CKp; Sun,  7 Feb 2021 20:17:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3B04B60D;
	Sun,  7 Feb 2021 20:17:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0651E4B608
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 20:17:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOXmdj8MLy6Z for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Feb 2021 20:17:12 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52B844B41F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 20:17:12 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYp4L2PQtz16578;
 Mon,  8 Feb 2021 09:15:46 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 09:17:02 +0800
Subject: Re: [RFC PATCH 06/11] iommu/arm-smmu-v3: Scan leaf TTD to sync
 hardware dirty log
To: Robin Murphy <robin.murphy@arm.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-7-zhukeqian1@huawei.com>
 <2a731fe7-5879-8d89-7b96-d7385117b869@arm.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <02286125-408e-6f42-18e1-c761033cb9b2@huawei.com>
Date: Mon, 8 Feb 2021 09:17:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <2a731fe7-5879-8d89-7b96-d7385117b869@arm.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Cornelia
 Huck <cohuck@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 lushenming@huawei.com, Alex Williamson <alex.williamson@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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



On 2021/2/5 3:52, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> During dirty log tracking, user will try to retrieve dirty log from
>> iommu if it supports hardware dirty log. This adds a new interface
[...]

>>   static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>>   {
>>       unsigned long granule, page_sizes;
>> @@ -957,6 +1046,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>>           .iova_to_phys    = arm_lpae_iova_to_phys,
>>           .split_block    = arm_lpae_split_block,
>>           .merge_page    = arm_lpae_merge_page,
>> +        .sync_dirty_log    = arm_lpae_sync_dirty_log,
>>       };
>>         return data;
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index f1261da11ea8..69f268069282 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2822,6 +2822,47 @@ size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_merge_page);
>>   +int iommu_sync_dirty_log(struct iommu_domain *domain, unsigned long iova,
>> +             size_t size, unsigned long *bitmap,
>> +             unsigned long base_iova, unsigned long bitmap_pgshift)
>> +{
>> +    const struct iommu_ops *ops = domain->ops;
>> +    unsigned int min_pagesz;
>> +    size_t pgsize;
>> +    int ret;
>> +
>> +    min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
>> +
>> +    if (!IS_ALIGNED(iova | size, min_pagesz)) {
>> +        pr_err("unaligned: iova 0x%lx size 0x%zx min_pagesz 0x%x\n",
>> +               iova, size, min_pagesz);
>> +        return -EINVAL;
>> +    }
>> +
>> +    if (!ops || !ops->sync_dirty_log) {
>> +        pr_err("don't support sync dirty log\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    while (size) {
>> +        pgsize = iommu_pgsize(domain, iova, size);
>> +
>> +        ret = ops->sync_dirty_log(domain, iova, pgsize,
>> +                      bitmap, base_iova, bitmap_pgshift);
> 
> Once again, we have a worst-of-both-worlds iteration that doesn't make much sense. iommu_pgsize() essentially tells you the best supported size that an IOVA range *can* be mapped with, but we're iterating a range that's already mapped, so we don't know if it's relevant, and either way it may not bear any relation to the granularity of the bitmap, which is presumably what actually matters.
> 
> Logically, either we should iterate at the bitmap granularity here, and the driver just says whether the given iova chunk contains any dirty pages or not, or we just pass everything through to the driver and let it do the whole job itself. Doing a little bit of both is just an overcomplicated mess.
> 
> I'm skimming patch #7 and pretty much the same comments apply, so I can't be bothered to repeat them there...
> 
> Robin.
Sorry that I missed these comments...

As I clarified in #4, due to unsuitable variable name, the @pgsize actually is the max size that meets alignment acquirement and fits into the pgsize_bitmap.

All iommu interfaces acquire the @size fits into pgsize_bitmap to simplify their implementation. And the logic is very similar to "unmap" here.

Thanks,
Keqian

> 
>> +        if (ret)
>> +            break;
>> +
>> +        pr_debug("dirty_log_sync: iova 0x%lx pagesz 0x%zx\n", iova,
>> +             pgsize);
>> +
>> +        iova += pgsize;
>> +        size -= pgsize;
>> +    }
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_sync_dirty_log);
>> +
>>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>>   {
>>       const struct iommu_ops *ops = dev->bus->iommu_ops;
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 754b62a1bbaf..f44551e4a454 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -166,6 +166,10 @@ struct io_pgtable_ops {
>>                     size_t size);
>>       size_t (*merge_page)(struct io_pgtable_ops *ops, unsigned long iova,
>>                    phys_addr_t phys, size_t size, int prot);
>> +    int (*sync_dirty_log)(struct io_pgtable_ops *ops,
>> +                  unsigned long iova, size_t size,
>> +                  unsigned long *bitmap, unsigned long base_iova,
>> +                  unsigned long bitmap_pgshift);
>>   };
>>     /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index ac2b0b1bce0f..8069c8375e63 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -262,6 +262,10 @@ struct iommu_ops {
>>                     size_t size);
>>       size_t (*merge_page)(struct iommu_domain *domain, unsigned long iova,
>>                    phys_addr_t phys, size_t size, int prot);
>> +    int (*sync_dirty_log)(struct iommu_domain *domain,
>> +                  unsigned long iova, size_t size,
>> +                  unsigned long *bitmap, unsigned long base_iova,
>> +                  unsigned long bitmap_pgshift);
>>         /* Request/Free a list of reserved regions for a device */
>>       void (*get_resv_regions)(struct device *dev, struct list_head *list);
>> @@ -517,6 +521,10 @@ extern size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>>                   size_t size);
>>   extern size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>>                      size_t size, int prot);
>> +extern int iommu_sync_dirty_log(struct iommu_domain *domain, unsigned long iova,
>> +                size_t size, unsigned long *bitmap,
>> +                unsigned long base_iova,
>> +                unsigned long bitmap_pgshift);
>>     /* Window handling function prototypes */
>>   extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
>> @@ -923,6 +931,15 @@ static inline size_t iommu_merge_page(struct iommu_domain *domain,
>>       return -EINVAL;
>>   }
>>   +static inline int iommu_sync_dirty_log(struct iommu_domain *domain,
>> +                       unsigned long iova, size_t size,
>> +                       unsigned long *bitmap,
>> +                       unsigned long base_iova,
>> +                       unsigned long pgshift)
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
