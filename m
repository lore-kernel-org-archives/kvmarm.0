Return-Path: <SRS0=p5Xi=DA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BABC4741F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:28:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 335C6235FC
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 335C6235FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C534B319;
	Wed, 23 Sep 2020 07:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OiyMNgIlpfcO; Wed, 23 Sep 2020 07:28:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590414B306;
	Wed, 23 Sep 2020 07:28:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E00064B29C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:28:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nGv+sEdUw5r9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Sep 2020 07:28:00 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2D8F4B156
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:27:59 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id E9297626864E5F774AE4;
 Wed, 23 Sep 2020 19:27:55 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 19:27:47 +0800
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <jacob.jun.pan@linux.intel.com>,
 <yi.l.liu@intel.com>, <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
Date: Wed, 23 Sep 2020 19:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200320161911.27494-2-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
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

On 2020/3/21 0:19, Eric Auger wrote:
> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
> 
> This patch adds an VFIO_IOMMU_SET_PASID_TABLE ioctl
> which aims to pass the virtual iommu guest configuration
> to the host. This latter takes the form of the so-called
> PASID table.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a177bf2c6683..bfacbd876ee1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2172,6 +2172,43 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>   	return ret;
>   }
>   
> +static void
> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +	mutex_unlock(&iommu->lock);
> +}
> +
> +static int
> +vfio_attach_pasid_table(struct vfio_iommu *iommu,
> +			struct vfio_iommu_type1_set_pasid_table *ustruct)
> +{
> +	struct vfio_domain *d;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
> +		if (ret)
> +			goto unwind;
> +	}
> +	goto unlock;
> +unwind:
> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>   static long vfio_iommu_type1_ioctl(void *iommu_data,
>   				   unsigned int cmd, unsigned long arg)
>   {
> @@ -2276,6 +2313,25 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>   
>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>   			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_SET_PASID_TABLE) {
> +		struct vfio_iommu_type1_set_pasid_table ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table,
> +				    config);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (ustruct.flags & VFIO_PASID_TABLE_FLAG_SET)
> +			return vfio_attach_pasid_table(iommu, &ustruct);
> +		else if (ustruct.flags & VFIO_PASID_TABLE_FLAG_UNSET) {
> +			vfio_detach_pasid_table(iommu);
> +			return 0;
> +		} else
> +			return -EINVAL;

Nit:

What if user-space blindly set both flags? Should we check that only one
flag is allowed to be set at this stage, and return error otherwise?

Besides, before going through the whole series [1][2], I'd like to know
if this is the latest version of your Nested-Stage-Setup work in case I
had missed something.

[1] https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
[2] https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
