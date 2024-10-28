Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D079E1DEFDC
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730136561; cv=none; b=mku8uxJ8hun+onfKKyQIkAH8KBM/ZAJMuYkBS/wTQR9cwrp2d9yVvhCV6HZRrHSxbwyofSdEIJ9/UR7D8KdQw8v0XRKc0M5BmsyRPGXVY0REu2BKDJqtSUanjiGojjA3DFtMzwMhQ6yo+KkYXTK6AZWDbvq1+wnAFjleXkNmM5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730136561; c=relaxed/simple;
	bh=cUg6txPRUPxMsei/A2V0Htey6gR92wd7KBs9NQZZqy0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bjGXF6UD3YA3a3KHiMVhzBDnuU6097pVlackLxje1XHEbwyWYnna+/CcVKffKmEVod4xzWsFJLMu5Ihvnzwbj6UrJoPnFIcT2/rzfPcPrekl5HcJCwEJr3tHlDRZlG5HUSC9LQdKoP8UNNAR20n4zhsoU7wJ9CUcWlOGusJj5Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XcgMQ0QfCz6K9Zr;
	Tue, 29 Oct 2024 01:28:02 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 10925140B30;
	Tue, 29 Oct 2024 01:29:15 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 18:29:14 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Mon, 28 Oct 2024 18:29:14 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "maz@kernel.org"
	<maz@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, yuzenghui
	<yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, jiangkunkun
	<jiangkunkun@huawei.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on migration
 target CPUs
Thread-Topic: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on migration
 target CPUs
Thread-Index: AQHbJfomCZMu0lx0Uky3XpJwm4Q1tLKWjy0AgAXbpRA=
Date: Mon, 28 Oct 2024 17:29:14 +0000
Message-ID: <0a23971725644a9bbfe7ec60b5e05033@huawei.com>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
 <20241024094012.29452-4-shameerali.kolothum.thodi@huawei.com>
 <Zxr2JMNzOWT3zPWH@linux.dev>
In-Reply-To: <Zxr2JMNzOWT3zPWH@linux.dev>
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
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Friday, October 25, 2024 2:37 AM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; maz@kernel.org; catalin.marinas@arm.com;
> will@kernel.org; mark.rutland@arm.com; cohuck@redhat.com;
> eric.auger@redhat.com; yuzenghui <yuzenghui@huawei.com>; Wangzhou
> (B) <wangzhou1@hisilicon.com>; jiangkunkun <jiangkunkun@huawei.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on
> migration target CPUs
>=20
> nitpick: shortlog shouldn't use a KVM prefix if the patch isn't touching
> KVM.
>=20
> On Thu, Oct 24, 2024 at 10:40:12AM +0100, Shameer Kolothum wrote:
> > If the Guest has migration target CPUs set, enable all errata
> > that are based on target MIDR/REVIDR.
> >
> > Also make sure we call the paravirt helper to retrieve migration
> > targets if any.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
>=20
> I don't know if you saw my suggestion on v1 [*], but it'd be great if we
> can hide the array of implementations from users of is_midr_in_range()
> and friends.

I did see your suggestion but my bad,  misunderstood it and thought that yo=
u are
referring to _midr_range() functions in cpu_errata.c only.
=20
> There's other junk keyed off MIDR (e.g. Spectre) that also needs to be
> aware of all the implementations where the VM might run. The easiest way
> to do that is to stop using a caller-provided MIDR and have
> is_midr_in_range() either walk the array of implementations or read
> MIDR_EL1.

So the suggestion is to use something like this?

bool is_midr_in_range(struct midr_range const *range)
{
        int i;

        for (i =3D 0; i < errata_migrn_target_num; i++) {
                if (midr_is_cpu_model_range(errata_migrn_target_cpus[i].mid=
r,
                                            range->model,
                                            range->rv_min, range->rv_max))
                        return true;
        }

        return midr_is_cpu_model_range(read_cpuid_id(), range->model,
                                       range->rv_min, range->rv_max);
}

Or do we need some kind of hint to these functions to specify which=20
MIDR to use? I think there are at least couple of places where it looks lik=
e
it make sense to do the checking against MIDR_EL1 only.
(eg: has_neoverse_n1_erratum_1542419().

Thanks,
Shameer
