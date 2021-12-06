Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5DEC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 10:49:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 572C24B0BA;
	Mon,  6 Dec 2021 05:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ivobWxOldrnR; Mon,  6 Dec 2021 05:49:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B0CC4B08F;
	Mon,  6 Dec 2021 05:49:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A05B14B08F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 05:49:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9TJ93JbnE2f3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 05:49:03 -0500 (EST)
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56BCA4B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 05:49:03 -0500 (EST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
 id BB60137E; Mon,  6 Dec 2021 11:48:57 +0100 (CET)
Date: Mon, 6 Dec 2021 11:48:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <Ya3qd6mT/DpceSm8@8bytes.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211027104428.1059740-2-eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, vdumpa@nvidia.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
 jean-philippe@linaro.org, yi.l.liu@intel.com, ashok.raj@intel.com,
 maz@kernel.org, vsethi@nvidia.com, nicolinc@nvidia.com,
 zhangfei.gao@linaro.org, sumitg@nvidia.com, kevin.tian@intel.com,
 jacob.jun.pan@linux.intel.com, will@kernel.org, nicoleotsuka@gmail.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, chenxiang66@hisilicon.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

This Signed-of-by chain looks dubious, you are the author but the last
one in the chain?

> +int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
> +				  void __user *uinfo)
> +{

[...]

> +	if (pasid_table_data.format == IOMMU_PASID_FORMAT_SMMUV3 &&
> +	    pasid_table_data.argsz <
> +		offsetofend(struct iommu_pasid_table_config, vendor_data.smmuv3))
> +		return -EINVAL;

This check looks like it belongs in driver specific code.

Regards,

	Joerg

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
