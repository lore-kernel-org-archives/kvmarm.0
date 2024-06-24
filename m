Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B2A107A0;
	Mon, 24 Jun 2024 19:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719256437; cv=none; b=s25pnT/8/6b9MMle2fRPMOiYpleZjt9Q/odZQgTD6HK3J/KDa/AkWWX9cYB696wiGGx8pzrme7Av24tZUQsY0fxpYgSVNbppsdZvhyE6f7g2imfG/E7OOTY2KgpdxfAcBtCpF/GWbdBTmLm/AsJt5Nc+Wx36S22TuP3UwrIoF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719256437; c=relaxed/simple;
	bh=z3PDUGZC6iCD1Qe3Gcyso8NfHdibgOXYAUFbjLgQnAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hODJ2zrq6uXqIOVTil0CArgZ61hcnll1f0D2b3x55o7zqzy0mdLAkyycrX+ff8jE7vytHFP2QQsAufGAIx00nXtwCONwTGiR1CrH05+7FIzjS6ywRsGTbhxJFiwz457YUgQghNLxPz4hKmmWc8107jyt8alRiQmqeIzCsvUdpnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4W7HgP6qvKz6JB7Q;
	Tue, 25 Jun 2024 03:13:37 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id 31898140A9C;
	Tue, 25 Jun 2024 03:13:51 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 20:13:50 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 24 Jun 2024 20:13:50 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Topic: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Index: AQHaWqKlcIYRddkjikqD0bNybpIgU7EAlXwAgNdSbACAAAQhgIAADRaAgAAidCA=
Date: Mon, 24 Jun 2024 19:13:50 +0000
Message-ID: <521e42c61230413c8160ecf370c41937@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca> <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca> <Znmy3QPAUIX9SnGx@google.com>
In-Reply-To: <Znmy3QPAUIX9SnGx@google.com>
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
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, June 24, 2024 6:55 PM
> To: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; alex.williamson@redhat.com; maz@kernel.org;
> oliver.upton@linux.dev; will@kernel.org; robin.murphy@arm.com; jean-
> philippe@linaro.org; Jonathan Cameron <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd
> ctx
>=20
> On Mon, Jun 24, 2024, Jason Gunthorpe wrote:
> > On Mon, Jun 24, 2024 at 09:53:00AM -0700, Sean Christopherson wrote:
> > > If kvm_pinned_vmid_{get,put}() are implemented directly by KVM ARM,
> then I don't
> > > have any immediate concerns, as KVM ARM is a long, long way from
> being able to
> > > isolate KVM from the core kernel.
> >
> > I think that is a reasonable thing, I also don't really see VMID as
> > being general. We will have to figure out how to ensure that the KVM
> > FD we got is an ARM KVM FD..
>=20
> Isn't the caller in ARM specific code?  I was assuming
> kvm_pinned_vmid_{get,put}()
> would simply not exist for non-ARM builds.

The caller is in ARM specific code(SMMUv3 driver). But at present, the kvm =
pointer
is passed to it by IOMMUFD during nested domain allocation time. And IOMMUF=
D
gets the kvm pointer from VFIO during device bind operation.

Not sure,, how this flow is going to be in  the new IOMMUFD VIOMMU object m=
odel
Jason referred. If not through IOMMUFD, SMMUv3 has to have a way to figure =
out
the KVM associated with the device. =20

>=20
> > > That said, I find the on-demand pinning to be very odd.  IIUC, if KVM=
 runs
> out
> > > of pinnable VMIDs, attaching a device to the KVM+iommu will fail.  Fa=
iling
> an
> > > iommufd operation because of a (potentially transient) KVM resource
> issue is
> > > rather unpleasant.
> >
> > It is kind of subtle, but the only thing that will consume VMIDs is
> > IOMMUFD operations that are working with nested translation but not
> > providing KVMs. This is a pretty small blast radius - ie a specific
> > qemu will fail to start - that I think we can tolerate it.
> >
> > More normal iommu operation will not require VMIDs so things like
> > driver attaching/etc is fine.
> >
> > > And assuming that pinnable VMIDs are a somewhat scarce resource, it
> wouldn't
> > > suprise me if someone wanted to add cgroup integration, e.g. similar =
to
> the
> > > misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an
> SEV ASID
> > > is analagous to an ARM VMID).
> >
> > Yeah, but if someone is using such a cgroup then I expect they will
> > also have an up to date VMM that doesn't trigger this VMID allocation
> > in the first place...
>=20
> I suspect we're talking about two different things.  Either that, or I am=
 really
> lost.
>=20
> > > Rather than on-demand pinning, would it make sense to have KVM
> provide an ioctl()
> > > (or capability, or VM type) to let userspace pin a VM's VMID?  That w=
ould
> allow
> > > for a much saner failure mode, and I suspect would be cleaner in gene=
ral
> for iommufd.
> >
> > The point of this mechanism is to support using this iommufd feature
> > without a KVM at all. We could instead prevent this directly 100% of
> > the time, but it means that HW with this BTM capability would not run
> > the legacy VMMs at all, so I'm not that keen on it..
> >
> > When a KVM is present then the iommu needs to adopt the VMID of KVM,
> > and that should have a mechanism to ensure the VMID is valid so long
> > as the IOMMU is using it (eg because the KVM FD is open)
>=20
> Right, and that's what I'm referring to as "on-demand pinning".  For the
> IOMMU
> to adopt a KVM VMID, the VMID needs to be pinned (or KVM would need to
> notify
> the IOMMU every time the VMID changed), i.e. every KVM+IOMMU pair pins
> a VMID
> that is managed by KVM.
>=20
> Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=
=3D0.
> Which
> seems odd.

See patch 3, kvm_arch_pinned_vmid_get() return -EINVAL if VMID =3D=3D 0. Fo=
r ARM64/KVM
VMID 0 is always reserved and never allocated for a Guest.

Thanks,
Shameer


