Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9227CF25;
	Thu,  8 Feb 2024 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707408857; cv=none; b=KoKtmxprVIY29yirwsXnqJq+r0W8w3svnZsh+E/AtLK7wja6Y7ggeV8j8JLBV992ISo8Z+mIC+jGHzr06r+kCsGkXELadJMABcxp5N8nJP25p50sYpDDhxNTqb2FSx9yZ0ItFD8mSEVKCljzdWO/PtmWyGc89l827uCc81CrQko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707408857; c=relaxed/simple;
	bh=KYM8oNAyXlsUC0D2a/fciYs6bPr/4AqixOk6WBOioss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cK+wo/8617Zr2Grnn4vi3joZ/Mh1AyP4rV0PLnfY/LkLoWEaMHgJdO3u3av0x+KtPKEf+3IdmltJX70lXBrUS5isP3K4M3M6He60KfMJaasgsU5uGziYos9U2hBmkevlUJufHBePk0S340eCacam6xy3YDDpwK1thAXg/Ud+gfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW25f0rGCz67HRc;
	Fri,  9 Feb 2024 00:10:46 +0800 (CST)
Received: from lhrpeml100006.china.huawei.com (unknown [7.191.160.224])
	by mail.maildlp.com (Postfix) with ESMTPS id 26A5C140B2F;
	Fri,  9 Feb 2024 00:14:08 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100006.china.huawei.com (7.191.160.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 16:14:07 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Thu, 8 Feb 2024 16:14:07 +0000
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
Thread-Index: AQHaWqKqc1WLEJmeWESanxfd3VFGjLEAmkKAgAABL7A=
Date: Thu, 8 Feb 2024 16:14:07 +0000
Message-ID: <8bfca4c5bfe7424691efdae0f686ece4@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-7-shameerali.kolothum.thodi@huawei.com>
 <20240208155915.GR31743@ziepe.ca>
In-Reply-To: <20240208155915.GR31743@ziepe.ca>
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
> Sent: Thursday, February 8, 2024 3:59 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; alex.williamson@redhat.com; maz@kernel.org;
> oliver.upton@linux.dev; will@kernel.org; robin.murphy@arm.com; jean-
> philippe@linaro.org; Jonathan Cameron <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2
> stage
>=20
> On Thu, Feb 08, 2024 at 03:18:36PM +0000, Shameer Kolothum wrote:
> > If kvm is available make use of kvm pinned VMID interfaces to
> > set the s2 stage VMID for nested domains.
> >
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 18 +++++++++++++-----
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index b41d77787a2f..18e3e04b50f4 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/io-pgtable.h>
> >  #include <linux/iopoll.h>
> > +#include <linux/kvm_host.h>
> >  #include <linux/module.h>
> >  #include <linux/msi.h>
> >  #include <linux/of.h>
> > @@ -2399,9 +2400,13 @@ int arm_smmu_domain_alloc_id(struct
> arm_smmu_device *smmu,
> >  	} else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S2) {
> >  		int vmid;
> >
> > -		/* Reserve VMID 0 for stage-2 bypass STEs */
> > -		vmid =3D ida_alloc_range(&smmu->vmid_map, 1,
> > -				       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
> > +		if (smmu_domain->kvm) {
> > +			vmid =3D kvm_pinned_vmid_get(smmu_domain->kvm);
> > +		} else {
> > +			/* Reserve VMID 0 for stage-2 bypass STEs */
> > +			vmid =3D ida_alloc_range(&smmu->vmid_map, 1,
> > +					       (1 << smmu->vmid_bits) - 1,
> GFP_KERNEL);
> > +		}
>=20
> We cannot allow the two different STEs to be programmed with the same
> VMID but different translations, so somehow the two allocators have to
> work together.

My idea was, we only set smmu_domain->kvm in the nested parent case
and that means SMMUv3 supports both S1 & S2. So all the non-nested domains
are using S1.

>=20
> This is why the SVA BTM code has that complex ASID reassignment logic
> so it can get away with two allocators. However ASID also has SMMU HW
> ASET support to opt-in to the BTM broadcast.
>=20
> My suggestion is to avoid two allocators and make iommu instances that
> support BTM always use the KVM owned VMID allocator by forbidding a S2
> domain from being created with a NULL KVM.

This is what I was trying to do. But not sure we have systems out there whe=
re
only S2  is supported and that may require a private VMID without KVM.

>=20
> IOW all the DMA API/etc will use S1 domains and the only way to get to
> a S2 is to allocate a nesting parent via iommufd - for BTM systems
> only.
>=20
> Since the S2 can't opt-out of the BTM broadcast this means the VMIDs
> are cleanly assigned and we never get an issue where the KVM TLBI's
> are flushing an unrelated S2.

In the last patch we only enable BTM if only S1 is supported. Meaning we wi=
ll
always have a KVM VMID associated for S2(if it supports that).=20

Did I miss something here?

Thanks,
Shameer
