Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72A48A8BB
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284555; cv=none; b=JeyULT5vFWxtIsX1DOHW8Wa3iL1jyCYzyckv6ju9IMicMUz6f+TSyT4rswKtuWVfNtU+kvyKt2JWoWFhOGiWXDczd97XSrk2qLqfAupmfaPnZOvaY4TZo5VDltFkD88BPcHYoDvd4GpgEJzIOslL3U3NrzFxDuWzWvWYw0HVXA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284555; c=relaxed/simple;
	bh=vw8qH8NH5NGnUxf9s/ujX0clA/aKzxDFmfPs08i5E6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lx8EOEyI14CFWnnYjJElFWeZ8cEP9gzdoT4VO/Kh145ZGB69g/yRlfOWFCoumwIO27wtNymkBWLEYFUlxpcaJsV+VmGqjGsEKva7rqwlGuYIaWFDwt0vKWOKo7sIyTMWlIexHWIDYS7e+RWCbRbkyi6dT0zNNmhSXy+6Mr7iSnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PO57/nGN; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PO57/nGN"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90cc372d6b2so1424396d6.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 10:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788284552; x=1788889352; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wSpPsrjUbmiSavh9ORSXd1N82cCUzjhFeagQI6oMt/A=;
        b=PO57/nGNNi897V4t5Do6Zm9Elt/lV9Ta9RjOogFm1cmlWiDmTaqaZho91hiB4JkaEv
         zH1uS6msUXKPsA7TIJxWNt7VJbVjA0JjhlJcqwPbBxQrphuXxYAH0CLJNVVhjiBHsYqG
         NOYv/qjn6EfGreT2u6H9kvAxDfXKgdCJ1Wrxc5A0MC/YhR9N6uKqvVYToYvl/4ajjOIp
         fQF6DyJrJzCB24S0SZFMkgD1tw9xVwdIKXr31xBrx6+6clQYy37BGaXo7tF2ruSHh2/d
         2gNTXnSk3to8eczVDX8fLgnP83G70cCphlybP4ktx066OLc5SVz6P8j+JMsBUgrznBuZ
         Slnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788284552; x=1788889352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wSpPsrjUbmiSavh9ORSXd1N82cCUzjhFeagQI6oMt/A=;
        b=G6GGXPIBpj1S4PGYJ4mROUm/3JQzkd0PcLUfPstcmuD7CYbMvgz/AAMC/lLohYXHio
         rw6rynqGv3MS7espC4mW0tilgI6XZyoE/bh/MdC3nW0c6ZU5rKaf/7CvWaY2ITe62VQ6
         8Z0R280R0jleFe6mAcm9aXEnlcjTG1LE94tPUyB4axmdO8Jtv/Dn8jd1wepol7SG6coV
         UklaXDLlLpCzQu//pF4QeU+8ZUITLo1aL+IGvEzX289lYwRP3cZYZ7omHLii8xKHFYNd
         iW971tAci18EyP3E1syI2N4lft4Y2yTLQYBQcFk4/H4ZIMMN6+zPl+repAfB9IpuwTJ0
         /8rw==
X-Forwarded-Encrypted: i=1; AHgh+RpQbJXYg7jmJ7qNCUFCUzNYXwMAe/zxERPMNATyiP75o0wJmSLpg5U3i6KXNzdjm/gXDOWaQO4=@lists.linux.dev
X-Gm-Message-State: AFuF++nEwwNCpJYb8syIiBMlZKhAvpbOQ1FZtLf7H92ztq+B7uMtwx8T
	1eiBZF0lRUtQg1bYy/f4FcFAY55btpVtbjOODnS/vuT2UHoRWCaIq3jzj7Nid9B01cs=
X-Gm-Gg: AYBFou1BHFI/kDEHnVwTgEFMmMusrzh50Q+bxhkzUfr8Tel8mOcwLDRDeq/3RQZPldr
	BHGvGybx0kEzWXtpZq1wEr25jvITzKELjw3UaaaBIuSF07Ly8cBtLDcOL5u70BgKG2HOPsyXj/k
	CdlfxXXG2B6eluf1hvqeUl7guWiLoYyBFCUQ6Rdzx+ivJPlkg3NbSvl+HhTlrCnmq/02w0dAcIY
	OGSpTW4jN8YFHE5qr5rnGEAXpaNjPOvEPj1EkNqCk44E2eNrKUzQ2w8q5LFUzAS3MnqkshoLt3K
	FZ6bjOVlkx2BcoIoWNURRJUB6slSTZHVk5laUPsUvIbJMpbWKZ0YV82xof8Whohj8uBmpIO8FHY
	Damo71ixfvEYMxpt4oKMcTnisfZQf1MWwzjjIfp0IV7blAsBcBy0S2KtXsrFfhWtOm5tpWPGyW/
	ZN7oDut3fYw8Um6YwzqKUW3iQ5qq+oq1PeNOJyDqinjJE30vI1hDuSJ0UbuLa0cT+FOTRsfiRSe
	Rn27Pu1aIH3KRDgT2IR14F8QQBojFVIhb6ox5whQEjDhuUYom5WpvgY
X-Received: by 2002:a05:6214:20a6:b0:908:951f:415 with SMTP id 6a1803df08f44-90ce0c5a74dmr432795226d6.13.1788284551550;
        Tue, 01 Sep 2026 10:42:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4515130sm113625086d6.39.2026.09.01.10.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 10:42:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1SVC-0000000C4up-15C8;
	Tue, 01 Sep 2026 14:42:30 -0300
Date: Tue, 1 Sep 2026 14:42:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260901174230.GA2847102@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcHoHKGoI7WNFXp@nvidia.com>

On Tue, Sep 01, 2026 at 10:13:04AM -0700, Nicolin Chen wrote:

> +/**
> + * enum iommu_viommu_arm_realm_vsmmuv3_flags - Flags for ARM SMMUv3 Realm
> + * @IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU: Indicates whether the Realm has
> + *                                             a guest-visible VSMMU instance
> + */
> +enum iommu_viommu_arm_realm_vsmmuv3_flags {
> +	IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU = 1 << 0,
> +};
> +
> +/**
> + * struct iommu_viommu_arm_realm_vsmmuv3 - ARM Realm VSMMUv3 parameters
> + *                                         (IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
> + * @flags: Combination of enum iommu_viommu_arm_realm_vsmmuv3_flags
> + * @reg_base: MMIO base address of the VSMMU in the guest VM
> + * @reg_top: MMIO top address of the VSMMU in the guest VM
> + * @aidr: AIDR register value of the VSMMU in the guest VM
> + * @idr: IDR register values of the VSMMU in the guest VM
> + */
> +struct iommu_viommu_arm_realm_vsmmuv3 {
> +	__aligned_u64 flags;
> +	__aligned_le64 reg_base;
> +	__aligned_le64 reg_top;
> +	__aligned_le64 aidr;
> +	__aligned_le64 idr[7];
> +};

Yeah, broadly what I would expect. Pass everything needed to execute
RMI_VSMMU_CREATE through this struct.

Is there anything more than RMI_VSMMU_CREATE needed from a RMM
perspective? What about that dpt/ats stuff?

> I think this should work. But I still feel awkward that a non-vsmmu
> case has to allocate a viommu object for a set of RMI commands that
> don't need an Realm Descriptor.

It is for the RMI_VDEV_CREATE which needs the RD:

	case IOMMU_VDEVICE_TSM_BIND:
		rc = tsm_bind(vdev->idev->dev, kvm, vdev->virt_id);
		break;

It has to be tied to a vdevice on a viommu to pick up the kvm and
vSID.

If we don't do that we need a new way to get the virt_id and kvm into
the flow, which doesn't really seem worthwhile to me.

> Things could be cleaner if we allow RMI_PSMMU_ACTIVATE and
> RMI_PSMMU_ST_L2_CREATE to be independent on a viommu; then leave
> IOMMU_VIOMMU_TYPE_ARM_SMMUV3 to vsmmu-visiable case.

This is why I asked in the other message if RMM spec is clear that
PSMMU and STE are not required for anything but VDEV_CREATE. If so,
the PDEV create and SPDM stuff is fuly independent.

Which is why I'm saying the split doesn't make sense. PSMMU,
interrupts, STE, VDEV are all related objects that should be managed
together by the SMMUv3 driver. You need a PDEV to create a STE, and
you need a STE to create a VDEV.

PDEV is the SPDM channel and should be managed by the TSM driver.

So, I think the IOMMU_VDEVICE_TSM_BIND is not justified. "BIND" should
happen when the SMMUv3 realm viommu ops create the vdevice. The same
way the vcmdq sets up the VSID tables when the vdevice is created. Is
there a reason to have it in its own command?

Further the implementation of IOMMU_VDEVICE_TSM_BIND in this series
*requires* a viommu to work. So OK, let's lean into that. (to be clear
I am saying delete tsm_bind)

It means the other arches will have to implement viommu APIs in their
iommu drivers before they have really defined their actual secure
vIOMMU definitions. That seems manageable.

Jason
