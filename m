Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A507C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 03:09:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B37B961443
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 03:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B37B961443
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05CDA4B919;
	Thu, 13 May 2021 23:09:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eILM2WwdPUAj; Thu, 13 May 2021 23:09:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BFD4B926;
	Thu, 13 May 2021 23:09:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B8F04B919
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 23:09:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrYV4S7lrhIC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 23:09:53 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A42C4B915
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 23:09:53 -0400 (EDT)
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhD2z1kWvz1BMP2;
 Fri, 14 May 2021 11:07:07 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 11:09:48 +0800
Received: from [10.174.185.210] (10.174.185.210) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 11:09:47 +0800
Subject: Re: [PATCH v15 07/12] iommu/smmuv3: Implement cache_invalidate
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <tn@semihalf.com>, <zhukeqian1@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
 <20210411111228.14386-8-eric.auger@redhat.com>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <e6483bc3-192b-9b68-b3e1-641b1bed4bf6@huawei.com>
Date: Fri, 14 May 2021 11:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210411111228.14386-8-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, chenxiang66@hisilicon.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, vdumpa@nvidia.com,
 yi.l.liu@intel.com, vsethi@nvidia.com, zhangfei.gao@linaro.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2021/4/11 19:12, Eric Auger wrote:
> Implement domain-selective, pasid selective and page-selective
> IOTLB invalidations.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v4 -> v15:
> - remove the redundant arm_smmu_cmdq_issue_sync(smmu)
>    in IOMMU_INV_GRANU_ADDR case (Zenghui)
> - if RIL is not supported by the host, make sure the granule_size
>    that is passed by the userspace is supported or fix it
>    (Chenxiang)
>
> v13 -> v14:
> - Add domain invalidation
> - do global inval when asid is not provided with addr
>    granularity
>
> v7 -> v8:
> - ASID based invalidation using iommu_inv_pasid_info
> - check ARCHID/PASID flags in addr based invalidation
> - use __arm_smmu_tlb_inv_context and __arm_smmu_tlb_inv_range_nosync
>
> v6 -> v7
> - check the uapi version
>
> v3 -> v4:
> - adapt to changes in the uapi
> - add support for leaf parameter
> - do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
>    anymore
>
> v2 -> v3:
> - replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync
>
> v1 -> v2:
> - properly pass the asid
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++++++++++++
>   1 file changed, 89 insertions(+)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 56a301fbe75a..bfc112cc0d38 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2961,6 +2961,94 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>   	mutex_unlock(&smmu_domain->init_mutex);
>   }
>   
> +static int
> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			  struct iommu_cache_invalidate_info *inv_info)
> +{
> +	struct arm_smmu_cmdq_ent cmd = {.opcode = CMDQ_OP_TLBI_NSNH_ALL};
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -EINVAL;
> +
> +	if (!smmu)
> +		return -EINVAL;
> +
> +	if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
> +		return -EINVAL;
> +
> +	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
> +	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
> +		return -ENOENT;
> +	}
> +
> +	if (!(inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB))
> +		return -EINVAL;
> +
> +	/* IOTLB invalidation */
> +
> +	switch (inv_info->granularity) {
> +	case IOMMU_INV_GRANU_PASID:
> +	{
> +		struct iommu_inv_pasid_info *info =
> +			&inv_info->granu.pasid_info;
> +
> +		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
> +			return -ENOENT;
> +		if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID))
> +			return -EINVAL;
> +
> +		__arm_smmu_tlb_inv_context(smmu_domain, info->archid);
> +		return 0;
> +	}
> +	case IOMMU_INV_GRANU_ADDR:
> +	{
> +		struct iommu_inv_addr_info *info = &inv_info->granu.addr_info;
> +		size_t granule_size  = info->granule_size;
> +		size_t size = info->nb_granules * info->granule_size;
> +		bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
> +		int tg;
> +
> +		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
> +			return -ENOENT;
> +
> +		if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
> +			break;
> +
> +		tg = __ffs(granule_size);
> +		if (granule_size & ~(1 << tg))
> +			return -EINVAL;
This check looks like to confirm the granule_size is a power of 2.
Does the granule_size have to be a power of 2?
I think it should also be handled correctly, even if the granule_size is 
not a power of 2.
> +		/*
> +		 * When RIL is not supported, make sure the granule size that is
> +		 * passed is supported. In RIL mode, this is enforced in
> +		 * __arm_smmu_tlb_inv_range()
> +		 */
> +		if (!(smmu->features & ARM_SMMU_FEAT_RANGE_INV) &&
> +		    !(granule_size & smmu_domain->domain.pgsize_bitmap)) {
> +			tg = __ffs(smmu_domain->domain.pgsize_bitmap);
> +			granule_size = 1 << tg;
> +			size = size >> tg;
Why does size need to be shifted tg bits to the right?

Thanks,
Kunkun Jiang
> +		}
> +
> +		arm_smmu_tlb_inv_range_domain(info->addr, size,
> +					      granule_size, leaf,
> +					      info->archid, smmu_domain);
> +		return 0;
> +	}
> +	case IOMMU_INV_GRANU_DOMAIN:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Global S1 invalidation */
> +	cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
> +	arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> +	arm_smmu_cmdq_issue_sync(smmu);
> +	return 0;
> +}
> +
>   static bool arm_smmu_dev_has_feature(struct device *dev,
>   				     enum iommu_dev_features feat)
>   {
> @@ -3060,6 +3148,7 @@ static struct iommu_ops arm_smmu_ops = {
>   	.put_resv_regions	= generic_iommu_put_resv_regions,
>   	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>   	.detach_pasid_table	= arm_smmu_detach_pasid_table,
> +	.cache_invalidate	= arm_smmu_cache_invalidate,
>   	.dev_has_feat		= arm_smmu_dev_has_feature,
>   	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>   	.dev_enable_feat	= arm_smmu_dev_enable_feature,


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
