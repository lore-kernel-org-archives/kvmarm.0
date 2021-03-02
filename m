Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D1DC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 08:35:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A38C864DE4
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 08:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A38C864DE4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54B84B545;
	Tue,  2 Mar 2021 03:35:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aeGzrFAb7Lg4; Tue,  2 Mar 2021 03:35:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A074B56E;
	Tue,  2 Mar 2021 03:35:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF0044B545
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 03:35:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BL9jxpDPfjfH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 03:35:30 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DE464B51E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 03:35:30 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqVlY4HmHz16Fdw;
 Tue,  2 Mar 2021 16:33:45 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 16:35:16 +0800
Subject: Re: [PATCH v14 05/13] iommu/smmuv3: Implement
 attach/detach_pasid_table
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <tn@semihalf.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-6-eric.auger@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
Date: Tue, 2 Mar 2021 16:35:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-6-eric.auger@redhat.com>
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

On 2021/2/24 4:56, Eric Auger wrote:
> On attach_pasid_table() we program STE S1 related info set
> by the guest into the actual physical STEs. At minimum
> we need to program the context descriptor GPA and compute
> whether the stage1 is translated/bypassed or aborted.
> 
> On detach, the stage 1 config is unset and the abort flag is
> unset.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
[...]

> +
> +		/*
> +		 * we currently support a single CD so s1fmt and s1dss
> +		 * fields are also ignored
> +		 */
> +		if (cfg->pasid_bits)
> +			goto out;
> +
> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
only the "cdtab_dma" field of "cdcfg" is set, we are not able to locate a specific cd using arm_smmu_get_cd_ptr().

Maybe we'd better use a specialized function to fill other fields of "cdcfg" or add a sanity check in arm_smmu_get_cd_ptr()
to prevent calling it under nested mode?

As now we just call arm_smmu_get_cd_ptr() during finalise_s1(), no problem found. Just a suggestion ;-)

Thanks,
Keqian


> +		smmu_domain->s1_cfg.set = true;
> +		smmu_domain->abort = false;
> +		break;
> +	default:
> +		goto out;
> +	}
> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
> +		arm_smmu_install_ste_for_dev(master);
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +	ret = 0;
> +out:
> +	mutex_unlock(&smmu_domain->init_mutex);
> +	return ret;
> +}
> +
> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
> +{
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_master *master;
> +	unsigned long flags;
> +
> +	mutex_lock(&smmu_domain->init_mutex);
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		goto unlock;
> +
> +	smmu_domain->s1_cfg.set = false;
> +	smmu_domain->abort = false;
> +
> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
> +		arm_smmu_install_ste_for_dev(master);
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +
> +unlock:
> +	mutex_unlock(&smmu_domain->init_mutex);
> +}
> +
>  static bool arm_smmu_dev_has_feature(struct device *dev,
>  				     enum iommu_dev_features feat)
>  {
> @@ -2939,6 +3026,8 @@ static struct iommu_ops arm_smmu_ops = {
>  	.of_xlate		= arm_smmu_of_xlate,
>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>  	.put_resv_regions	= generic_iommu_put_resv_regions,
> +	.attach_pasid_table	= arm_smmu_attach_pasid_table,
> +	.detach_pasid_table	= arm_smmu_detach_pasid_table,
>  	.dev_has_feat		= arm_smmu_dev_has_feature,
>  	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>  	.dev_enable_feat	= arm_smmu_dev_enable_feature,
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
