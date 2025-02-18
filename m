Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16D51ADC81
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739864458; cv=none; b=Mm6Wxkpv5TjAOysB6D6rWvwmJSWQr4ztCXwLr1+BpH/uXjd6X0rhqY2vsInsSp6GPbGe1J2F2j3z9wXhD5VaOu/2n6yk27u8fDYfVDKk2bv+Nhhk2hisVo2tk9GdrQJRgEv3GtN8dx11G/5PnEZYKOlA1OUsaVpFHwI4/d8CAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739864458; c=relaxed/simple;
	bh=NU3The1APhQsLBU7n9+PEhO2idSxzQOTpZ79T4UM9+4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nL7Y/x+PSOfFbj1KxcK6Bx+bvV5F2DtLvycw+HaAUTNPdxikHAl4XzE+U6tyYYt2EgwB2CvC7eSUSW9pXkN5He68XBUIx5U+659vJb2/CEt65LNjgQ51906tFIgY5oKoCLwvQfclRzd05wpm75BbLr0SvcjAoJWPawE8RwcwIGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Yxrwj6pG9z6M4Rv;
	Tue, 18 Feb 2025 15:38:13 +0800 (CST)
Received: from frapeml100007.china.huawei.com (unknown [7.182.85.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 45E66140B2F;
	Tue, 18 Feb 2025 15:40:48 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Feb 2025 08:40:47 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 18 Feb 2025 08:40:47 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>
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
Subject: RE: [PATCH v7 4/5] smccc/kvm_guest: Enable errata based on
 implementation CPUs
Thread-Topic: [PATCH v7 4/5] smccc/kvm_guest: Enable errata based on
 implementation CPUs
Thread-Index: AQHbfvRxSJOyGnvtKEOdLroufJhHY7NG57AAgAAIvwCABcIT8A==
Date: Tue, 18 Feb 2025 07:40:47 +0000
Message-ID: <0557f193756f45daac4349c30d8f2f8f@huawei.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
	<20250214151343.61348-5-shameerali.kolothum.thodi@huawei.com>
	<10831a79-a21f-dc40-a374-81b300d26dac@redhat.com>
 <86mseoscif.wl-maz@kernel.org>
In-Reply-To: <86mseoscif.wl-maz@kernel.org>
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
> Sent: Friday, February 14, 2025 4:43 PM
> To: Sebastian Ott <sebott@redhat.com>
> Cc: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
> oliver.upton@linux.dev; catalin.marinas@arm.com; will@kernel.org;
> mark.rutland@arm.com; cohuck@redhat.com; eric.auger@redhat.com;
> yuzenghui <yuzenghui@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>; jiangkunkun <jiangkunkun@huawei.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v7 4/5] smccc/kvm_guest: Enable errata based on
> implementation CPUs
>=20
> On Fri, 14 Feb 2025 16:12:02 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
> >
> > On Fri, 14 Feb 2025, Shameer Kolothum wrote:
> > > +++ b/arch/arm64/kernel/cpu_errata.c
> > > @@ -14,6 +14,9 @@
> > > #include <asm/kvm_asm.h>
> > > #include <asm/smp_plat.h>
> > >
> > > +u32 target_impl_cpu_num;
> > > +struct target_impl_cpu *target_impl_cpus;
> >
> > These should be exported (for configs using
> > CONFIG_CORESIGHT_SOURCE_ETM4X=3Dm)

Thanks Sebastian. I missed that.

>=20
> It might be better to make is_midr_in_range() out of line, and export
> that. This could allow making the data static (by implementing a
> couple of additional accessors).

Ok. I will give it a go.

Thanks,
Shameer


