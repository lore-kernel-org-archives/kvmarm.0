Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DCFC433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A34546105A
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A34546105A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0286A4B5CE;
	Thu,  1 Apr 2021 02:12:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BVGLooPy081Q; Thu,  1 Apr 2021 02:12:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F2F4B5C6;
	Thu,  1 Apr 2021 02:12:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79CA04B5B6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 02:12:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 985hrULg7wz6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 02:12:13 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FE164B5B7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 02:12:13 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F9t7w29PWz9v7J;
 Thu,  1 Apr 2021 14:10:04 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 14:12:02 +0800
Subject: Re: [PATCH v14 07/13] iommu/smmuv3: Implement cache_invalidate
To: Eric Auger <eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <95a178f0-fc84-b9a2-d824-c09ea91c9d30@huawei.com>
Date: Thu, 1 Apr 2021 14:11:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-8-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com, jean-philippe@linaro.org, yi.l.liu@intel.com,
 wangxingang5@huawei.com, maz@kernel.org, joro@8bytes.org, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, jacob.jun.pan@linux.intel.com, will@kernel.org,
 nicoleotsuka@gmail.com, alex.williamson@redhat.com,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, robin.murphy@arm.com
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

Hi Eric,

On 2021/2/24 4:56, Eric Auger wrote:
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

I didn't find any code where we would emulate the CFGI_CD{_ALL} commands
for guest and invalidate the stale CD entries on the physical side. Is
PASID-cache type designed for that effect?

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
> +		size_t size = info->nb_granules * info->granule_size;
> +		bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
> +
> +		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
> +			return -ENOENT;
> +
> +		if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
> +			break;
> +
> +		arm_smmu_tlb_inv_range_domain(info->addr, size,
> +					      info->granule_size, leaf,
> +					      info->archid, smmu_domain);
> +
> +		arm_smmu_cmdq_issue_sync(smmu);

There is no need to issue one more SYNC.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
