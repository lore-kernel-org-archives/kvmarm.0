Return-Path: <SRS0=MRwa=HJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8604C433E6
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 01:57:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7F2364E8C
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 01:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7F2364E8C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24BCB4B50F;
	Sat,  6 Feb 2021 20:57:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCp46h9DyKq8; Sat,  6 Feb 2021 20:57:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F422A4B4CE;
	Sat,  6 Feb 2021 20:57:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14AB54B478
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Feb 2021 20:57:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aA9StGP+bT0X for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Feb 2021 20:57:03 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A2C74B473
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Feb 2021 20:57:03 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DYC0p1g6Yz7hJb;
 Sun,  7 Feb 2021 09:55:38 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 09:56:49 +0800
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
To: Robin Murphy <robin.murphy@arm.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
 <5ada4a8b-8852-f83c-040a-9ef5dac51de2@arm.com>
 <94375ed6-1e25-b592-8bb0-e433e7a09b4c@arm.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e3ace87c-a57f-ede9-834a-8bbbcced728a@huawei.com>
Date: Sun, 7 Feb 2021 09:56:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <94375ed6-1e25-b592-8bb0-e433e7a09b4c@arm.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>, lushenming@huawei.com,
 Kirti Wankhede <kwankhede@nvidia.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

On 2021/2/6 0:11, Robin Murphy wrote:
> On 2021-02-05 11:48, Robin Murphy wrote:
>> On 2021-02-05 09:13, Keqian Zhu wrote:
>>> Hi Robin and Jean,
>>>
>>> On 2021/2/5 3:50, Robin Murphy wrote:
>>>> On 2021-01-28 15:17, Keqian Zhu wrote:
>>>>> From: jiangkunkun <jiangkunkun@huawei.com>
>>>>>
>>>>> The SMMU which supports HTTU (Hardware Translation Table Update) can
>>>>> update the access flag and the dirty state of TTD by hardware. It is
>>>>> essential to track dirty pages of DMA.
>>>>>
>>>>> This adds feature detection, none functional change.
>>>>>
>>>>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>>>>> ---
>>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++++
>>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++++++++
>>>>>    include/linux/io-pgtable.h                  |  1 +
>>>>>    3 files changed, 25 insertions(+)
>>>>>
>>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> index 8ca7415d785d..0f0fe71cc10d 100644
>>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> @@ -1987,6 +1987,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>>>>>            .pgsize_bitmap    = smmu->pgsize_bitmap,
>>>>>            .ias        = ias,
>>>>>            .oas        = oas,
>>>>> +        .httu_hd    = smmu->features & ARM_SMMU_FEAT_HTTU_HD,
>>>>>            .coherent_walk    = smmu->features & ARM_SMMU_FEAT_COHERENCY,
>>>>>            .tlb        = &arm_smmu_flush_ops,
>>>>>            .iommu_dev    = smmu->dev,
>>>>> @@ -3224,6 +3225,21 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>>>>>        if (reg & IDR0_HYP)
>>>>>            smmu->features |= ARM_SMMU_FEAT_HYP;
>>>>>    +    switch (FIELD_GET(IDR0_HTTU, reg)) {
>>>>
>>>> We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
>>> Robin, Thanks for pointing it out.
>>>
>>> Jean, I see that the IORT HTTU flag overrides the hardware register info unconditionally. I have some concern about it:
>>>
>>> If the override flag has HTTU but hardware doesn't support it, then driver will use this feature but receive access fault or permission fault from SMMU unexpectedly.
>>> 1) If IOPF is not supported, then kernel can not work normally.
>>> 2) If IOPF is supported, kernel will perform useless actions, such as HTTU based dma dirty tracking (this series).
>>
>> Yes, if the IORT describes the SMMU incorrectly, things will not work well. Just like if it describes the wrong base address or the wrong interrupt numbers, things will also not work well. The point is that incorrect firmware can be updated in the field fairly easily; incorrect hardware can not.
>>
>> Say the SMMU designer hard-codes the ID register field to 0x2 because the SMMU itself is capable of HTTU, and they assume it's always going to be wired up coherently, but then a customer integrates it to a non-coherent interconnect. Firmware needs to override that value to prevent an OS thinking that the claimed HTTU capability is ever going to work.
>>
>> Or say the SMMU *is* integrated correctly, but due to an erratum discovered later in the interconnect or SMMU itself, it turns out DBM doesn't always work reliably, but AF is still OK. Firmware needs to downgrade the indicated level of support from that which was intended to that which works reliably.
>>
>> Or say someone forgets to set an integration tieoff so their SMMU reports 0x0 even though it and the interconnect *can* happily support HTTU. In that case, firmware may want to upgrade the value to *allow* an OS to use HTTU despite the ID register being wrong.
>>
>>> As the IORT spec doesn't give an explicit explanation for HTTU override, can we comprehend it as a mask for HTTU related hardware register?
>>> So the logic becomes: smmu->feature = HTTU override & IDR0_HTTU;
>>
>> No, it literally states that the OS must use the value of the firmware field *instead* of the value from the hardware field.
> 
> Oops, apologies for an oversight there - I've been reviewing IORT spec updates lately so naturally had the newest version open already. Turns out these descriptions were only clarified in the most recent release, so if you were looking at an older document they *were* horribly vague.
Yep, my local version is E which was released at July 2020. I download the version E.a just now, thanks. ;-)

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
