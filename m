Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0032C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 17:21:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA894B102;
	Wed,  8 Dec 2021 12:21:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UCZ2AqprxQqe; Wed,  8 Dec 2021 12:21:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 123C44B1CB;
	Wed,  8 Dec 2021 12:21:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 163AD4B1C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:21:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VbUM5Zh+LOZr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 12:21:07 -0500 (EST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC42A4B102
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:21:06 -0500 (EST)
Received: by mail-ed1-f43.google.com with SMTP id o20so10713002eds.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 09:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kyzUDdWg/IZru0d+jvuosuGK1ljLUFNTnYN5AnSJDXg=;
 b=hGOd2DXmhiY03/LW8kR4Fzs1XS4MZrOOYMgzFNQlW3QzkFSk0fHm+jEd/hfPuPbUb9
 jSnT9XG/E45e55goXHXwup8OV7EvMpUz5YnNTNX8PbokPB7LTAxr1wb5fQ18JoSR+2dz
 7W1sBx32q6fKcJPqvMKo3QEL8pDUncUpdrqmwNkimOqstmKzRVi1Glo3tl1CAITnwBWr
 SOzmUV4zL1L+qMphMN46Lq9w0u/Dqo94EqVT+RPNai0wEVYekJ/OXqJbzatlyLjAJsHQ
 woH+/w4futuTQIP1iS9rns7q+IdTvoky7d4omWrlfeXiFlBWUcvwxrhrYkDGQtgU0O1M
 tBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kyzUDdWg/IZru0d+jvuosuGK1ljLUFNTnYN5AnSJDXg=;
 b=wPhdC92OvfT06A3DLCF0VUCOHsEMD15SMqZp6Pl1YfOMqPi6k4LPdbH7nb6Os/VvJ2
 8IHFWY8RiKFteevTJwwTxbF17b3i+Nh/gI18ttfxcz26OhEWpbHynPpMmayOSi85MxF4
 oC0VJTothbL+90iYPYsO7Cxy3xSQwlNXSg4pViuKqSsRvfNe45qL2rhHgBYpFcv3ggSk
 quonOXIUT3nqYr1hUcIqMsa3wIlm0TaJ8nb+CbfwaZzkIFiLfqfBselN7em+BruWgGDR
 L1y6aZ+9aO1u1LHuN9EF1HH2nHrnwtJrXPJQ7sdMiM2+qIswUdjanQL+T2MaAn/mdo6A
 nAIg==
X-Gm-Message-State: AOAM531NRS8RPjpQnIi59RBMdbkQE20vLdawxQs/A/S6lomMLDytEKWI
 Hgw2ZIIsdOhnAlD7dbesNsSp5Q==
X-Google-Smtp-Source: ABdhPJyjFzHce2qFbF0BrVsh3LEu7RhsZDOw0Mq4d7N2tuvqt9QjnSMjbiA5jluzcVko/W8H288INw==
X-Received: by 2002:a17:906:b084:: with SMTP id
 x4mr8967385ejy.214.1638984063404; 
 Wed, 08 Dec 2021 09:21:03 -0800 (PST)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net.
 [82.27.106.168])
 by smtp.gmail.com with ESMTPSA id b11sm2484409ede.62.2021.12.08.09.21.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Dec 2021 09:21:02 -0800 (PST)
Date: Wed, 8 Dec 2021 17:20:39 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <YbDpZ0pf7XeZcc7z@myrica>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211208125616.GN6385@nvidia.com>
Cc: kevin.tian@intel.com, lushenming@huawei.com, robin.murphy@arm.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, vivek.gautam@arm.com, maz@kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, zhangfei.gao@linaro.org,
 eric.auger.pro@gmail.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Lu Baolu <baolu.lu@linux.intel.com>
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

On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
> From a progress perspective I would like to start with simple 'page
> tables in userspace', ie no PASID in this step.
> 
> 'page tables in userspace' means an iommufd ioctl to create an
> iommu_domain where the IOMMU HW is directly travesering a
> device-specific page table structure in user space memory. All the HW
> today implements this by using another iommu_domain to allow the IOMMU
> HW DMA access to user memory - ie nesting or multi-stage or whatever.
> 
> This would come along with some ioctls to invalidate the IOTLB.
> 
> I'm imagining this step as a iommu_group->op->create_user_domain()
> driver callback which will create a new kind of domain with
> domain-unique ops. Ie map/unmap related should all be NULL as those
> are impossible operations.
> 
> From there the usual struct device (ie RID) attach/detatch stuff needs
> to take care of routing DMAs to this iommu_domain.
> 
> Step two would be to add the ability for an iommufd using driver to
> request that a RID&PASID is connected to an iommu_domain. This
> connection can be requested for any kind of iommu_domain, kernel owned
> or user owned.
> 
> I don't quite have an answer how exactly the SMMUv3 vs Intel
> difference in PASID routing should be resolved.

In SMMUv3 the user pgd is always stored in the PASID table (actually
called "context descriptor table" but I want to avoid confusion with the
VT-d "context table"). And to access the PASID table, the SMMUv3 first
translate its GPA into a PA using the stage-2 page table. For userspace to
pass individual pgds to the kernel, as opposed to passing whole PASID
tables, the host kernel needs to reserve GPA space and map it in stage-2,
so it can store the PASID table in there. Userspace manages GPA space.

This would be easy for a single pgd. In this case the PASID table has a
single entry and userspace could just pass one GPA page during
registration. However it isn't easily generalized to full PASID support,
because managing a multi-level PASID table will require runtime GPA
allocation, and that API is awkward. That's why we opted for "attach PASID
table" operation rather than "attach page table" (back then the choice was
easy since VT-d used the same concept).

So I think the simplest way to support nesting is still to have separate
modes of operations depending on the hardware.

Thanks,
Jean

> 
> to get answers I'm hoping to start building some sketch RFCs for these
> different things on iommufd, hopefully in January. I'm looking at user
> page tables, PASID, dirty tracking and userspace IO fault handling as
> the main features iommufd must tackle.
> 
> The purpose of the sketches would be to validate that the HW features
> we want to exposed can work will with the choices the base is making.
> 
> Jason
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
