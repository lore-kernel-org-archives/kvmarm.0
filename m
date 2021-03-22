Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED60AC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:24:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C9F061934
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C9F061934
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ED84B38D;
	Mon, 22 Mar 2021 02:24:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6hmLvMQ+Ugfk; Mon, 22 Mar 2021 02:24:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 655E54B2B1;
	Mon, 22 Mar 2021 02:24:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE2C64B252
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:24:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AN6-PJFzA0wS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 02:24:02 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A33604B22C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:24:01 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3ksg4qRZzNq40;
 Mon, 22 Mar 2021 14:21:27 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:23:49 +0800
Subject: Re: [PATCH v14 05/13] iommu/smmuv3: Implement
 attach/detach_pasid_table
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <tn@semihalf.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-6-eric.auger@redhat.com>
 <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
 <31290c71-25d9-2b49-fb4d-7250ed9f70e7@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <0769efb0-0a22-7cb1-b831-ec75845dde98@huawei.com>
Date: Mon, 22 Mar 2021 14:23:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <31290c71-25d9-2b49-fb4d-7250ed9f70e7@redhat.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
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

On 2021/3/19 21:15, Auger Eric wrote:
> Hi Keqian,
> 
> On 3/2/21 9:35 AM, Keqian Zhu wrote:
>> Hi Eric,
>>
>> On 2021/2/24 4:56, Eric Auger wrote:
>>> On attach_pasid_table() we program STE S1 related info set
>>> by the guest into the actual physical STEs. At minimum
>>> we need to program the context descriptor GPA and compute
>>> whether the stage1 is translated/bypassed or aborted.
>>>
>>> On detach, the stage 1 config is unset and the abort flag is
>>> unset.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>> [...]
>>
>>> +
>>> +		/*
>>> +		 * we currently support a single CD so s1fmt and s1dss
>>> +		 * fields are also ignored
>>> +		 */
>>> +		if (cfg->pasid_bits)
>>> +			goto out;
>>> +
>>> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
>> only the "cdtab_dma" field of "cdcfg" is set, we are not able to locate a specific cd using arm_smmu_get_cd_ptr().
>>
>> Maybe we'd better use a specialized function to fill other fields of "cdcfg" or add a sanity check in arm_smmu_get_cd_ptr()
>> to prevent calling it under nested mode?
>>
>> As now we just call arm_smmu_get_cd_ptr() during finalise_s1(), no problem found. Just a suggestion ;-)
> 
> forgive me for the delay. yes I can indeed make sure that code is not
> called in nested mode. Please could you detail why you would need to
> call arm_smmu_get_cd_ptr()?
I accidentally called this function in nested mode when verify the smmu mpam feature. :)

Yes, in nested mode, context descriptor is owned by guest, hypervisor does not need to care about its content.
Maybe we'd better give an explicit comment for arm_smmu_get_cd_ptr() to let coder pay attention to this? :)

Thanks,
Keqian

> 
> Thanks
> 
> Eric
>>
>> Thanks,
>> Keqian
>>
>>
>>> +		smmu_domain->s1_cfg.set = true;
>>> +		smmu_domain->abort = false;
>>> +		break;
>>> +	default:
>>> +		goto out;
>>> +	}
>>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>>> +		arm_smmu_install_ste_for_dev(master);
>>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>>> +	ret = 0;
>>> +out:
>>> +	mutex_unlock(&smmu_domain->init_mutex);
>>> +	return ret;
>>> +}
>>> +
>>> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>>> +{
>>> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>>> +	struct arm_smmu_master *master;
>>> +	unsigned long flags;
>>> +
>>> +	mutex_lock(&smmu_domain->init_mutex);
>>> +
>>> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>>> +		goto unlock;
>>> +
>>> +	smmu_domain->s1_cfg.set = false;
>>> +	smmu_domain->abort = false;
>>> +
>>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>>> +		arm_smmu_install_ste_for_dev(master);
>>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>>> +
>>> +unlock:
>>> +	mutex_unlock(&smmu_domain->init_mutex);
>>> +}
>>> +
>>>  static bool arm_smmu_dev_has_feature(struct device *dev,
>>>  				     enum iommu_dev_features feat)
>>>  {
>>> @@ -2939,6 +3026,8 @@ static struct iommu_ops arm_smmu_ops = {
>>>  	.of_xlate		= arm_smmu_of_xlate,
>>>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>>>  	.put_resv_regions	= generic_iommu_put_resv_regions,
>>> +	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>>> +	.detach_pasid_table	= arm_smmu_detach_pasid_table,
>>>  	.dev_has_feat		= arm_smmu_dev_has_feature,
>>>  	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>>>  	.dev_enable_feat	= arm_smmu_dev_enable_feature,
>>>
>>
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
