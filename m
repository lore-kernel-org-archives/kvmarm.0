Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25F04D135;
	Fri,  9 Feb 2024 13:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707486859; cv=none; b=UIcDhZRDCNee8I62JxKI+mnXU4tNIrzFhdFGCjfbm3DiOvt+SasX5N3a5IVzELB5Xama6dosbg2+GgnnHoeZsDR23JIwg4nS2GDuByWr21GcQXZLyZG8M5zwPqj2Mzn2UzSjpTMdEQOr3QTsGEOmFAE1R+zJzUpT3TeeIU7XMFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707486859; c=relaxed/simple;
	bh=wGQ6YWEERNvpDAZ4j33/ujdxeP5Z2Kc+Pd9cA3dtAbE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UNSVwA7klOtHG41xW1iFPkSr5CUc9m5tF6vltLc0d/2DgkqDxBB7o5goI6BVz9Gdhyk7Zzx57pPw+BhJ05kNn+1h9L4E+BzLGsLYb/0Nd30Fwgnj986JC6GMJnMz3w83SiQZInUfzAaT2rNFvI7f6F9qKUkJlkx55vzSomskQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TWZxC2CFCz6JB14;
	Fri,  9 Feb 2024 21:50:23 +0800 (CST)
Received: from lhrpeml500002.china.huawei.com (unknown [7.191.160.78])
	by mail.maildlp.com (Postfix) with ESMTPS id C046E140595;
	Fri,  9 Feb 2024 21:54:08 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 9 Feb 2024 13:54:08 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Fri, 9 Feb 2024 13:54:08 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Thread-Topic: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Thread-Index: AQHaWqKd0D2tjroZbEixT8fjcriLLrEB6UwAgAAfllA=
Date: Fri, 9 Feb 2024 13:54:08 +0000
Message-ID: <1f0e938bbf684fe69ad7050b8cb3cc29@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240209115824.GA2922446@myrica>
In-Reply-To: <20240209115824.GA2922446@myrica>
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
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Friday, February 9, 2024 11:58 AM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; jgg@ziepe.ca; alex.williamson@redhat.com;
> maz@kernel.org; oliver.upton@linux.dev; will@kernel.org;
> robin.murphy@arm.com; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM
> VMID for stage 2
>=20
> Hi Shameer,
>=20
> On Thu, Feb 08, 2024 at 03:18:30PM +0000, Shameer Kolothum wrote:
> > Hi,
> >
> > On an ARM64 system with a SMMUv3 implementation that fully supports
> > Broadcast TLB Maintenance(BTM) feature as part of the Distributed
> > Virtual Memory(DVM) protocol, the CPU TLB invalidate instructions are
> > received by SMMUv3. This is very useful when the SMMUv3 shares the
> > page tables with the CPU(eg: Guest SVA use case). For this to work,
> > the SMMUv3 must use the same VMID that is allocated by KVM to
> configure
> > the nested stage 2(S2) translations.
>=20
> The series makes sense to me. Maybe a little more detail to help the KVM
> maintainers understand why we need something like this even though the s2
> page tables aren't shared between CPU and SMMU:

Thanks Jean for the nice write up. I will use this for next revisions of th=
is series.

Shameer
