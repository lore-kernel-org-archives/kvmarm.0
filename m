Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759331632D9;
	Thu, 20 Mar 2025 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742463051; cv=none; b=O11+t8OLBnES0lC+kMV/zgbIqS6N7EYVOl2F7EGmBqFlupu+OJyqHcHjF75KVF2rYQp/43jYWXQblsGgkhWQ84UH1E2/HaLZZv1g2KqZne5+6JFoZA61O7oy5RrqrfoQlsFTOgDY8HEDCzth+Mze3n2ooHTLW35PmPPKr3AWayY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742463051; c=relaxed/simple;
	bh=DA1VOI0ouj+wlQCQyp6pnfel/4ZUCju3QtZmwpDK7qE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WJWArcfm7nHR1TVzoLm6kkHXLfrEgmoHz88b5apgHVaZU8dYcSbb8/wfhcZQsFfLZz0TU560B1x1pb3cjqTa1pcYmUXhyvr9qUKlXTVYbig35Bp45z+HaooL5dUOIfqN1gZ+vhWejLpNqdQk5tMmDQ0GsOVEYJvOb1hLhrDNcBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZJKwt1Pmrz6M4Yy;
	Thu, 20 Mar 2025 17:27:26 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id F1FD41401F3;
	Thu, 20 Mar 2025 17:30:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Mar 2025 10:30:45 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 20 Mar 2025 10:30:45 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "jean-philippe@linaro.org"
	<jean-philippe@linaro.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v3 4/5] iommu/arm-smmu-v3-iommufd: Use KVM VMID for s2
 stage
Thread-Topic: [RFC PATCH v3 4/5] iommu/arm-smmu-v3-iommufd: Use KVM VMID for
 s2 stage
Thread-Index: AQHbmPZBeq6wgyt4V0G2k2xYLylJd7N7DbQAgACsr4A=
Date: Thu, 20 Mar 2025 09:30:45 +0000
Message-ID: <f654ae10e55e4142acb83eb926bb80b2@huawei.com>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
 <20250319173202.78988-5-shameerali.kolothum.thodi@huawei.com>
 <20250319233946.GF126678@ziepe.ca>
In-Reply-To: <20250319233946.GF126678@ziepe.ca>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, March 19, 2025 11:40 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; alex.williamson@redhat.com; maz@kernel.org;
> oliver.upton@linux.dev; will@kernel.org; robin.murphy@arm.com;
> nicolinc@nvidia.com; jean-philippe@linaro.org; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v3 4/5] iommu/arm-smmu-v3-iommufd: Use KVM
> VMID for s2 stage
>=20
> On Wed, Mar 19, 2025 at 05:32:01PM +0000, Shameer Kolothum wrote:
> > +static int arm_vsmmu_alloc_vmid(struct arm_smmu_device *smmu,
> struct kvm *kvm,
> > +				bool *kvm_used)
> > +{
> > +#ifdef CONFIG_KVM
> > +	/*
> > +	 * There can only be one allocator for VMIDs active at once. If BTM
> is
> > +	 * turned on then KVM's allocator always supplies the VMID, and
> the
> > +	 * VMID is matched by CPU invalidation of the KVM S2. Right now
> there
> > +	 * is no API to get an unused VMID from KVM so this also means
> BTM systems
> > +	 * cannot support S2 without an associated KVM.
> > +	 */
> > +	if ((smmu->features & ARM_SMMU_FEAT_BTM)) {
> > +		int vmid;
> > +
> > +		if (!kvm || !kvm_get_kvm_safe(kvm))
> > +			return -EOPNOTSUPP;
>=20
> Isn't kvm_get_kvm_safe() in modular KVM code most of the time? You can't
> call it like this right?

I think it is safe since KVM is not modular for ARM64. And that is one of t=
he
reasons I thought I will hold the KVM reference here as we don't have to go
through the symbol_get/put calls here. Also IOMMUFD is not using the kvm
pointer at the moment. Probably I should add some comments in IOMMUFD
to make it clear.

However I just realized that in patch #1 I should EXPORT the
kvm_arm_pinned_vmid_get/put functions as smmuv3 driver can be built
modular.=20

>=20
> Per my prior comments, I'm a little nervous to make drivers keep track
> of this refcount instead of the core code but this does seem like it
> could work..
>=20
> I also think you should block using the S2 without a viommu & KVM in
> BTM mode.. Maybe like this:
>=20
> @@ -2938,8 +2938,16 @@ static int arm_smmu_attach_dev(struct
> iommu_domain *domain, struct device *dev)
>                 cdptr =3D arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
>                 if (!cdptr)
>                         return -ENOMEM;
> -       } else if (arm_smmu_ssids_in_use(&master->cd_table))
> -               return -EBUSY;
> +       } else {
> +               if (arm_smmu_ssids_in_use(&master->cd_table))
> +                       return -EBUSY;
> +               /*
> +                * S2 cannot be used when BTM is turned on without a VIOM=
MU
> and
> +                * VMID shared with KVM
> +                */
> +               if (smmu->features & ARM_SMMU_FEAT_BTM)
> +                       return -EOPNOTSUPP;
> +       }
>=20
> That more closely matches how this will eventually work when the VMID
> allocation is properly made to be local to the viommu.

Ok. Will update.

Thanks,
Shameer
