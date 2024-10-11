Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D55218D90
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728653093; cv=none; b=qdnt28mi+KBsMYQO5t3KDTwmOVbyGioB2ReOXk4gfYwr1xxWEi9ni6WYa3JcVCH4Cqw3irXnCN2dhqQl6haV9oajqsTf1+9o/BRKBSI2wejmK023DhtKiK8nkkjHCPZEX3Q/mIsKneXhU1X00u5oRCASy5NssOY1qlaFgGDwW6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728653093; c=relaxed/simple;
	bh=np4/hIzUsk1/W3lSTHEriU5nOtZuWqrsViQztPhkVVk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T0nem3gVRCl4xAQqq/BzRk+Q152z8iKUppkvgiPv6VkXNBf741Y3gULl82ySCtmFppkt0vRgnNe9hWFfhKHf2dn3MbzJAvch7d1MzQ4sYwJBJn9q1f+PrLOyjXoKVYfHKZgg3CmSa+y2oGYLm1pfhzsHwTgGQabbpVoqVdqsiWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XQ6kz73mbz6K5tM;
	Fri, 11 Oct 2024 21:23:23 +0800 (CST)
Received: from frapeml100005.china.huawei.com (unknown [7.182.85.132])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BF6D140A78;
	Fri, 11 Oct 2024 21:24:48 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 15:24:47 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 11 Oct 2024 15:24:47 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Cornelia Huck <cohuck@redhat.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, yuzenghui
	<yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, jiangkunkun
	<jiangkunkun@huawei.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Topic: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Index: AQHbG7LLpfYBbF3MrkilC6zl/kSmBLKBZvgAgAAh/jA=
Date: Fri, 11 Oct 2024 13:24:47 +0000
Message-ID: <54afcc8182d341d8ab294d8a54c1fbf3@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <87jzeerd6z.fsf@redhat.com>
In-Reply-To: <87jzeerd6z.fsf@redhat.com>
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
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, October 11, 2024 2:18 PM
> To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
> maz@kernel.org; oliver.upton@linux.dev
> Cc: catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
> eric.auger@redhat.com; yuzenghui <yuzenghui@huawei.com>; Wangzhou
> (B) <wangzhou1@hisilicon.com>; jiangkunkun
> <jiangkunkun@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
> migration
>=20
> On Fri, Oct 11 2024, Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com> wrote:
>=20
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
> So, I've only taken a very quick look at it, but IIUC, the idea is for
> the VMM to do the following:
> - figure out where we want to possibly run


Yes.

> - figure out the least common denominator for writable features

Yes

> - tell KVM about the possible target cpu resp. the errata it wants

This might change as per Marc's comments. VMM has to handle hypercall
directly and provide the target CPU list to Guest.

> - build a frankencpu via the writable id reg infrastructure, fiddling
>   with invariant handling as needed?

That is my idea of handling the invariant registers. If the VMM has provide=
d a list of=20
target CPUs for the Guest,  make sure the incoming CPU is part of the list=
=20
during migration and ignore invariant(MIDR/REVIDR) reg SET errors.

Thanks,
Shameer
