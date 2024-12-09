Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C981A23AF
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752157; cv=none; b=Rc8S/27Ngi5hDb77bqUfhciwLV9MhrBW8G4iD4sntLmRSGxuf6wzT89kzLMmhsfXo2qcP7wa/c1ZMEDj6KKpL1KbAaM3ZlhY6RwjZ4gFtt10mLjHJt4+uH7IhKCK/96LJn4r1cn+tn8GsNTpBlPEoqQSSXVvhTyOYkvn5cRZcao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752157; c=relaxed/simple;
	bh=yQHHP54uQ5+5uU+C5swOowcYCMvlHkfMQqR23g3oSE4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BIEd8umtyzowWX8Fq/wDkZJ41DVREBVM6Pt5WlG3fcekUl+AWzqJsP8/sGtk3cLXlE9avkkaKCuKz8opefz/VbJRWoLq3O0gX0bsxJBwVPRGFDmz7RbHWr2AM5xepOOuxms9IpszJEq9eMaJHvNaCAzxxUFDhB0xtZcxEJoyYlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y6NQF30gvz6GCF3;
	Mon,  9 Dec 2024 21:44:37 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C0A41408F9;
	Mon,  9 Dec 2024 21:49:08 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 14:49:08 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Mon, 9 Dec 2024 14:49:08 +0100
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
Subject: RE: [PATCH v3 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
Thread-Topic: [PATCH v3 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
Thread-Index: AQHbSjI8+ZGtwNDcik6x/q40bpGhkrLdzFoAgAAfO7A=
Date: Mon, 9 Dec 2024 13:49:07 +0000
Message-ID: <d92ea2dcc3b04ebb8bc5ba71bff448bc@huawei.com>
References: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com>
 <20241209115311.40496-4-shameerali.kolothum.thodi@huawei.com>
 <875xnt10oj.fsf@redhat.com>
In-Reply-To: <875xnt10oj.fsf@redhat.com>
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
> Sent: Monday, December 9, 2024 12:49 PM
> To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
> maz@kernel.org; oliver.upton@linux.dev
> Cc: catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
> eric.auger@redhat.com; yuzenghui <yuzenghui@huawei.com>; Wangzhou
> (B) <wangzhou1@hisilicon.com>; jiangkunkun <jiangkunkun@huawei.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v3 3/3] arm64: paravirt: Enable errata based on
> implementation CPUs
>=20
> On Mon, Dec 09 2024, Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com> wrote:
>=20
> > Retrieve any migration target implementation CPUs using the hypercall
> > and enable associated errata.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> > Note:
> >
> > One thing I am not sure here is how to handle the hypercall error.
> > Do we need to fail the Guest boot or just carry on without any
> > target implementation CPU support? At the moment it just carries on.
> >
> > Thanks,
> > Shameer
> > ---
> >  arch/arm64/include/asm/cputype.h  | 25 +++++++++++++++++++++++--
> >  arch/arm64/include/asm/paravirt.h |  3 +++
> >  arch/arm64/kernel/cpu_errata.c    | 20 +++++++++++++++++---
> >  arch/arm64/kernel/cpufeature.c    |  2 ++
> >  arch/arm64/kernel/image-vars.h    |  2 ++
> >  arch/arm64/kernel/paravirt.c      | 31
> +++++++++++++++++++++++++++++++
> >  6 files changed, 78 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/cputype.h
> b/arch/arm64/include/asm/cputype.h
> > index dcf0e1ce892d..9e466f3ae9c6 100644
> > --- a/arch/arm64/include/asm/cputype.h
> > +++ b/arch/arm64/include/asm/cputype.h
> > @@ -265,6 +265,16 @@ struct midr_range {
> >  #define MIDR_REV(m, v, r) MIDR_RANGE(m, v, r, v, r)
> >  #define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
> >
> > +#define MAX_TARGET_IMPL_CPUS 64
> > +
> > +struct target_impl_cpu {
> > +	u32 midr;
> > +	u32 revidr;
> > +};
>=20
> Doesn't this need to be u64 for both (even if the upper bits for
> MIDR_EL1 are reserved?)

Yes, both are u64 as per specification with upper bits reserved. And the=20
external hypercall interface has uint64.

But in kernel, AFAICS, at present all the _midr_range_() functions expect u=
32.
So not sure we gain much now by changing to u64.

Thanks,
Shameer
=20

