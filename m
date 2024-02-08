Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42387D41C;
	Thu,  8 Feb 2024 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707410223; cv=none; b=JPvpNzHaNhIP83AOI1gYWUeeQ7ObgOIodWN/GxUw+yFeJ9ExxeUvVivdrsQxN0zjWAQPEgmv6UNBbLMjdbpRFquhgIDhvSQRb7pqIb+kGeCidNwWAfPXDAg7yKHO75reo1QHVD6R6wKaMMDGFxhYyWhUR7VPh3QMh5XjxjKO434=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707410223; c=relaxed/simple;
	bh=hIfdAZuVO2RLuBK1t9y0eMkKCzfVQC/5tP19xRJuS8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aO8C4te3DjHx0qdC5jkXy/SBmg8OA74ugh0dHItTf3NPLWvjIH47TzpcFKuR51hjCkw3S+SMy2q/W70tTLFDfeCmz4zl5/BTfBlySmpEegiHy2NAOMuJbr4ipj3e1LxVjvgZVxL2rEF00QoZ5FJ2NoX2sBvo3jqUOfT3vo33oo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW2bz5zqxz6K5vk;
	Fri,  9 Feb 2024 00:33:35 +0800 (CST)
Received: from lhrpeml100002.china.huawei.com (unknown [7.191.160.241])
	by mail.maildlp.com (Postfix) with ESMTPS id DCCB4140595;
	Fri,  9 Feb 2024 00:36:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100002.china.huawei.com (7.191.160.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 16:36:57 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Thu, 8 Feb 2024 16:36:57 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2 stage
Thread-Topic: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2 stage
Thread-Index: AQHaWqKqc1WLEJmeWESanxfd3VFGjLEAmkKAgAABL7CAAAZQgIAAAKSg
Date: Thu, 8 Feb 2024 16:36:57 +0000
Message-ID: <d94a9c134e5148889f60ee07f14239d7@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-7-shameerali.kolothum.thodi@huawei.com>
 <20240208155915.GR31743@ziepe.ca>
 <8bfca4c5bfe7424691efdae0f686ece4@huawei.com>
 <20240208162605.GU31743@ziepe.ca>
In-Reply-To: <20240208162605.GU31743@ziepe.ca>
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
> Sent: Thursday, February 8, 2024 4:26 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; alex.williamson@redhat.com; maz@kernel.org;
> oliver.upton@linux.dev; will@kernel.org; robin.murphy@arm.com; jean-
> philippe@linaro.org; Jonathan Cameron <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2
> stage
>=20
> On Thu, Feb 08, 2024 at 04:14:07PM +0000, Shameerali Kolothum Thodi wrote=
:
> > > >  #include <linux/of.h>
> > > > @@ -2399,9 +2400,13 @@ int arm_smmu_domain_alloc_id(struct
> > > arm_smmu_device *smmu,
> > > >  	} else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S2) {
> > > >  		int vmid;
> > > >
> > > > -		/* Reserve VMID 0 for stage-2 bypass STEs */
> > > > -		vmid =3D ida_alloc_range(&smmu->vmid_map, 1,
> > > > -				       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
> > > > +		if (smmu_domain->kvm) {
> > > > +			vmid =3D kvm_pinned_vmid_get(smmu_domain->kvm);
> > > > +		} else {
> > > > +			/* Reserve VMID 0 for stage-2 bypass STEs */
> > > > +			vmid =3D ida_alloc_range(&smmu->vmid_map, 1,
> > > > +					       (1 << smmu->vmid_bits) - 1,
> > > GFP_KERNEL);
> > > > +		}
> > >
> > > We cannot allow the two different STEs to be programmed with the same
> > > VMID but different translations, so somehow the two allocators have t=
o
> > > work together.
> >
> > My idea was, we only set smmu_domain->kvm in the nested parent case
> > and that means SMMUv3 supports both S1 & S2. So all the non-nested
> domains
> > are using S1.
>=20
> Okay, that is what I was thinking to get to.
>=20
> The logic needs to reflect this directly though:
>=20
> /*
>  * There can only be one allocator for VMIDs active at once. If BTM is
>  * turned on then KVM's allocator always supplies the VMID, and the
>  * VMID is matched by CPU invalidation of the KVM S2. Right now there
>  * is no API to get an unused VMID from KVM so this also means BTM system=
s
>  * cannot support S2 without an associated KVM.
>  */
> if ((smmu->feature & ARM_SMMU_FEAT_BTM)) {
>    if (!smmu_domain->kvm)
>       vmid =3D -EOPNOTSUPP;
>    else
>        vmid =3D kvm_pinned_vmid_get(smmu_domain->kvm);
> } else {
> 	/* Reserve VMID 0 for stage-2 bypass STEs */
> 	vmid =3D ida_alloc_range(&smmu->vmid_map, 1,
> 		       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
> }
>=20
> (and matching change to the free side)
>=20
> > This is what I was trying to do. But not sure we have systems out there=
 where
> > only S2  is supported and that may require a private VMID without KVM.
>=20
> iommufd can ask for a nesting parent without supplying a KVM fd, which
> would cause vmid aliasing between the two allocators. That needs to be
> blocked as above

Ah..That's right. Missed that case where KVM can be NULL, but still there i=
s a=20
request for nested domain.

Thanks,
Shameer
