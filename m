Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537F1D0E15
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 10:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728644237; cv=none; b=fXHsRrFhXJeh9vZQxn+Rp7Lj3woZK4o/BdIHhifBfDBAfdwJga/KuCiV/L4AfaMMyAwG4Umt1/4PIo5ImUJsGKq+8Q7V5jsR/65Bw+LKgAuYKIB5Wd/YV+jew+opFzALNM9jBl4+9RTUBtg90/8+pg0KmPwE4hZ2fZbvNnq7Fjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728644237; c=relaxed/simple;
	bh=gOXbP6QT3FFsLYtueuohzk4aWDtrEbSScRQmDbQdSN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OvXIHiAeOz1Nv/xCon444XcNpkwVxl2YkPasc383Cg4MOPkipUqfAFJ17hu8iwVMCZq2bg4aDjRX5/e+8j3LUylTF8nFUq6IPo2TnbI5kOhzIafOpGVjJhpIeF9HRCZRCudG7xgtyF7P26g2OA6w4nlW4WniwGk9EH2aQ2eNHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XQ3PD25Pfz6L7DK;
	Fri, 11 Oct 2024 18:52:48 +0800 (CST)
Received: from frapeml100005.china.huawei.com (unknown [7.182.85.132])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AF5F14010C;
	Fri, 11 Oct 2024 18:57:10 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 12:57:10 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 11 Oct 2024 12:57:10 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "cohuck@redhat.com"
	<cohuck@redhat.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Topic: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Index: AQHbG7LLpfYBbF3MrkilC6zl/kSmBLKBOjEAgAAlJIA=
Date: Fri, 11 Oct 2024 10:57:10 +0000
Message-ID: <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org>
In-Reply-To: <86jzef53iz.wl-maz@kernel.org>
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
> From: Marc Zyngier <maz@kernel.org>
> Sent: Friday, October 11, 2024 11:37 AM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; oliver.upton@linux.dev;
> catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
> cohuck@redhat.com; eric.auger@redhat.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
> migration
>=20
> Hi Shameer,
>=20
> Thanks for getting the ball rolling on this one, much appreciated.
>=20
> On Fri, 11 Oct 2024 08:50:47 +0100,
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> >
> > Hi,
> >
> > On ARM64 platforms most of the errata workarounds are based on CPU
> > MIDR/REVIDR values and a number of these workarounds need to be
> > implemented by the Guest kernel as well. This creates a problem when
> > Guest needs to be migrated to a platform that differs in these
> > MIDR/REVIDR values even if the VMM can come up with a common
> minimum
> > feature list for the Guest using the recently introduced "Writable
> > ID registers" support.
> >
> > (This is roughly based on a discussion I had with Marc and Oliver
> > at KVM forum. Marc outlined his idea for a solution and this is an
> > attempt to implement it. Thanks to both and I take all the blame
> > if this is nowhere near what is intended/required)
> >
> > This RFC proposes a solution to handle the above issue by introducing
> > the following,
> >
> > 1. A new VM IOCTL,
> >    KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct
> kvm_arm_migrn_cpus)
> >    This can be used by the userspace(VMM) to set the target CPUs the
> >    Guest will run in its lifetime. See patch #2
> > 2. Add hypercall support for Guest kernel to retrieve any migration
> >    errata bitmap(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA)
> >    The above will return the bitmaps in R0-R3 registers. See patch #4
> > 3. The "capability" field in struct arm64_cpu_capabilities is a generat=
ed
> >    one at present and may get renumbered or reordered. Hence, we can't
> use
> >    this directly for migration errata bitmaps. Instead, introduced
> >    "migartion_safe_cap", which has to be set statically for any
> >    erratum that needs to be enabled and is safe for migration
> >    purposes. See patches 3 & 6.
> > 4. Rest of the patches includes the plumbing required to populate the
> >    errata bitmap based on the target CPUs set by the VMM and update the
> >    system_cap based on it.
> >
> > ToDos:-
> >   -We still need a way to  handle the error in setting the invariant
> >    registers(MIDR/REVIDR/AIDR) during Guest migration. Perhaps we can
> >    handle it in userspace?
> > -  Possibly we could do better to avoid the additional
> "migartion_safe_cap" use.
> >    Suggestions welcome.
> >   -There are errata that require more than MIDR/REVIDR, eg: CTR_EL0.
> >    How to handle those?
> >   -Check for locking requirements if any.
> >
> > This is lightly tested on a HiSilicon ARM64 platform.
> >
> > Please take a look and let me know your thoughts.
>=20
> Having eyeballed this very superficially, I think we can do something
> simpler, and maybe more future-proof:

Thanks Marc for taking a look and the quick feedback.

>=20
> - I don't think KVM should be concerned about the description of the
>   target CPUs. The hypercall you defined is the right thing to do,
>   but the VMM should completely handle it. That's an implementation
>   detail, but it would make things much simpler.

Ok. So does that mean the hypercall will use some sort of shared memory
to retrieve the list of target CPUs from VMM?
=20
> - I don't think the "errata bitmap" works. That's a construct that is
>   specific to Linux, and that cannot be supported for other OSs. It
>   also limits the described issues to those the host knows, instead of
>   the guest. The host doesn't have a clue what the guest really wants.
>   Really, the guest should have enough information to decide what to
>   do based on its own view of the ID registers and the list of CPUs it
>   runs on.

Yes. "errata bitmap" is specific to Linux. So if we go with the above=20
hypercall-->VMM path and get the target CPU list, Guest can directly
use that.

>=20
> - To answer your question about CTR_EL0: KVM should (and does)
>   sanitise that register by trapping it. This should be the default
>   behaviour for things that need to be mitigated outside of
>   MIDR/REVIDR.

Ok. Make sense and simplifies things.

Please let me know whether my understanding on hypercall<->VMM is=20
correct or not. I can take a look at that route.

Thanks,
Shameer

