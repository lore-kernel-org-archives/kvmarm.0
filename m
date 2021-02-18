Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A7FC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 08:44:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B3C764E68
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 08:44:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B3C764E68
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC99A4B276;
	Thu, 18 Feb 2021 03:44:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sUQiUC7kzyhg; Thu, 18 Feb 2021 03:44:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8164B280;
	Thu, 18 Feb 2021 03:44:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A29414B26E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 03:44:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZh+XkMxoL4J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 03:44:02 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC22F4B276
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 03:43:57 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dh7WF1DQPzjMg3;
 Thu, 18 Feb 2021 16:42:33 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Feb 2021 16:43:44 +0800
Subject: Re: [PATCH v13 02/15] iommu: Introduce bind/unbind_guest_msi
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <joro@8bytes.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
 <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-3-eric.auger@redhat.com>
 <6a70d93d-329f-4129-bd90-03f8589c5de4@huawei.com>
 <1ef4f5ae-9ca6-7c6d-f8a9-31240e5688c2@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <bc7b223e-7c30-9baa-85e3-2195e03dfe48@huawei.com>
Date: Thu, 18 Feb 2021 16:43:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1ef4f5ae-9ca6-7c6d-f8a9-31240e5688c2@redhat.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
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

Hi Eric,

On 2021/2/12 16:55, Auger Eric wrote:
> Hi Keqian,
> 
> On 2/1/21 12:52 PM, Keqian Zhu wrote:
>> Hi Eric,
>>
>> On 2020/11/18 19:21, Eric Auger wrote:
>>> On ARM, MSI are translated by the SMMU. An IOVA is allocated
>>> for each MSI doorbell. If both the host and the guest are exposed
>>> with SMMUs, we end up with 2 different IOVAs allocated by each.
>>> guest allocates an IOVA (gIOVA) to map onto the guest MSI
>>> doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
>>> onto the physical doorbell (hDB).
>>>
>>> So we end up with 2 untied mappings:
>>>          S1            S2
>>> gIOVA    ->    gDB
>>>               hIOVA    ->    hDB
>>>
>>> Currently the PCI device is programmed by the host with hIOVA
>>> as MSI doorbell. So this does not work.
>>>
>>> This patch introduces an API to pass gIOVA/gDB to the host so
>>> that gIOVA can be reused by the host instead of re-allocating
>>> a new IOVA. So the goal is to create the following nested mapping:
>> Does the gDB can be reused under non-nested mode?
> 
> Under non nested mode the hIOVA is allocated within the MSI reserved
> region exposed by the SMMU driver, [0x8000000, 80fffff]. see
> iommu_dma_prepare_msi/iommu_dma_get_msi_page in dma_iommu.c. this hIOVA
> is programmed in the physical device so that the physical SMMU
> translates it into the physical doorbell (hDB = host physical ITS
So, AFAIU, under non-nested mode, at smmu side, we reuse the workflow of non-virtualization scenario.

> doorbell). The gDB is not used at pIOMMU programming level. It is only
> used when setting up the KVM irq route.
> 
> Hope this answers your question.
Thanks for your explanation!
> 

Thanks,
Keqian

>>
>>>
>>>          S1            S2
>>> gIOVA    ->    gDB     ->    hDB
>>>
>>> and program the PCI device with gIOVA MSI doorbell.
>>>
>>> In case we have several devices attached to this nested domain
>>> (devices belonging to the same group), they cannot be isolated
>>> on guest side either. So they should also end up in the same domain
>>> on guest side. We will enforce that all the devices attached to
>>> the host iommu domain use the same physical doorbell and similarly
>>> a single virtual doorbell mapping gets registered (1 single
>>> virtual doorbell is used on guest as well).
>>>
>> [...]
>>
>>> + *
>>> + * The associated IOVA can be reused by the host to create a nested
>>> + * stage2 binding mapping translating into the physical doorbell used
>>> + * by the devices attached to the domain.
>>> + *
>>> + * All devices within the domain must share the same physical doorbell.
>>> + * A single MSI GIOVA/GPA mapping can be attached to an iommu_domain.
>>> + */
>>> +
>>> +int iommu_bind_guest_msi(struct iommu_domain *domain,
>>> +			 dma_addr_t giova, phys_addr_t gpa, size_t size)
>>> +{
>>> +	if (unlikely(!domain->ops->bind_guest_msi))
>>> +		return -ENODEV;
>>> +
>>> +	return domain->ops->bind_guest_msi(domain, giova, gpa, size);
>>> +}
>>> +EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
>>> +
>>> +void iommu_unbind_guest_msi(struct iommu_domain *domain,
>>> +			    dma_addr_t iova)
>> nit: s/iova/giova
> sure
>>
>>> +{
>>> +	if (unlikely(!domain->ops->unbind_guest_msi))
>>> +		return;
>>> +
>>> +	domain->ops->unbind_guest_msi(domain, iova);
>>> +}
>>> +EXPORT_SYMBOL_GPL(iommu_unbind_guest_msi);
>>> +
>> [...]
>>
>> Thanks,
>> Keqian
>>
> 
> Thanks
> 
> Eric
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
