Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2DCC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 07:42:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BD1B64DE7
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 07:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BD1B64DE7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B41144B5A7;
	Tue,  2 Mar 2021 02:42:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SIWBiohf3DtA; Tue,  2 Mar 2021 02:42:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A55984B5A6;
	Tue,  2 Mar 2021 02:42:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C72654B5A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 02:42:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f9bXiSh9jOse for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 02:42:31 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C34484B56B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 02:42:30 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqTZP1nWGz16FVl;
 Tue,  2 Mar 2021 15:40:45 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 15:42:18 +0800
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
To: Robin Murphy <robin.murphy@arm.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>, "Will
 Deacon" <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 "Marc Zyngier" <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <3b347f75-2e53-1f89-a76d-1f328766cf5f@huawei.com>
Date: Tue, 2 Mar 2021 15:42:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
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

I am going to send v2 at next week, to addresses these issues reported by you. Many thanks!
And do you have any further comments on patch #4 #5 and #6?

Thanks,
Keqian

On 2021/2/5 3:50, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> The SMMU which supports HTTU (Hardware Translation Table Update) can
>> update the access flag and the dirty state of TTD by hardware. It is
>> essential to track dirty pages of DMA.
>>
>> This adds feature detection, none functional change.
>>
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++++
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++++++++
>>   include/linux/io-pgtable.h                  |  1 +
>>   3 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 8ca7415d785d..0f0fe71cc10d 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1987,6 +1987,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>>           .pgsize_bitmap    = smmu->pgsize_bitmap,
>>           .ias        = ias,
>>           .oas        = oas,
>> +        .httu_hd    = smmu->features & ARM_SMMU_FEAT_HTTU_HD,
>>           .coherent_walk    = smmu->features & ARM_SMMU_FEAT_COHERENCY,
>>           .tlb        = &arm_smmu_flush_ops,
>>           .iommu_dev    = smmu->dev,
>> @@ -3224,6 +3225,21 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>>       if (reg & IDR0_HYP)
>>           smmu->features |= ARM_SMMU_FEAT_HYP;
>>   +    switch (FIELD_GET(IDR0_HTTU, reg)) {
> 
> We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
> 
>> +    case IDR0_HTTU_NONE:
>> +        break;
>> +    case IDR0_HTTU_HA:
>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
>> +        break;
>> +    case IDR0_HTTU_HAD:
>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HD;
>> +        break;
>> +    default:
>> +        dev_err(smmu->dev, "unknown/unsupported HTTU!\n");
>> +        return -ENXIO;
>> +    }
>> +
>>       /*
>>        * The coherency feature as set by FW is used in preference to the ID
>>        * register, but warn on mismatch.
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> index 96c2e9565e00..e91bea44519e 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> @@ -33,6 +33,10 @@
>>   #define IDR0_ASID16            (1 << 12)
>>   #define IDR0_ATS            (1 << 10)
>>   #define IDR0_HYP            (1 << 9)
>> +#define IDR0_HTTU            GENMASK(7, 6)
>> +#define IDR0_HTTU_NONE            0
>> +#define IDR0_HTTU_HA            1
>> +#define IDR0_HTTU_HAD            2
>>   #define IDR0_COHACC            (1 << 4)
>>   #define IDR0_TTF            GENMASK(3, 2)
>>   #define IDR0_TTF_AARCH64        2
>> @@ -286,6 +290,8 @@
>>   #define CTXDESC_CD_0_TCR_TBI0        (1ULL << 38)
>>     #define CTXDESC_CD_0_AA64        (1UL << 41)
>> +#define CTXDESC_CD_0_HD            (1UL << 42)
>> +#define CTXDESC_CD_0_HA            (1UL << 43)
>>   #define CTXDESC_CD_0_S            (1UL << 44)
>>   #define CTXDESC_CD_0_R            (1UL << 45)
>>   #define CTXDESC_CD_0_A            (1UL << 46)
>> @@ -604,6 +610,8 @@ struct arm_smmu_device {
>>   #define ARM_SMMU_FEAT_RANGE_INV        (1 << 15)
>>   #define ARM_SMMU_FEAT_BTM        (1 << 16)
>>   #define ARM_SMMU_FEAT_SVA        (1 << 17)
>> +#define ARM_SMMU_FEAT_HTTU_HA        (1 << 18)
>> +#define ARM_SMMU_FEAT_HTTU_HD        (1 << 19)
>>       u32                features;
>>     #define ARM_SMMU_OPT_SKIP_PREFETCH    (1 << 0)
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index ea727eb1a1a9..1a00ea8562c7 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -97,6 +97,7 @@ struct io_pgtable_cfg {
>>       unsigned long            pgsize_bitmap;
>>       unsigned int            ias;
>>       unsigned int            oas;
>> +    bool                httu_hd;
> 
> This is very specific to the AArch64 stage 1 format, not a generic capability - I think it should be a quirk flag rather than a common field.
> 
> Robin.
> 
> [1] https://jpbrucker.net/git/linux/commit/?h=sva/current&id=1ef7d512fb9082450dfe0d22ca4f7e35625a097b
> 
>>       bool                coherent_walk;
>>       const struct iommu_flush_ops    *tlb;
>>       struct device            *iommu_dev;
>>
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
