Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B3714BF92
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768221724; cv=none; b=j0SYKCqRzY+zu6447yUIECaPpbltWXXoejg808WDCBI4Le/iz74VSHSq4LKVgOZM0LKAjAqkxBWrDDM8xYhG32KXJy32Qi3amM0HDEqBkOQfeq8x2sOITEA6+sr2m1hNxus+kbQIX/iUnsn8bZdw32T+LGeEYQkv8mEgmhnLzxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768221724; c=relaxed/simple;
	bh=156pxg3To0Jclr6ygI/YePOmO8C/eVIC2Q1wLolLpGg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVtbBS3kV9mWT+qqPWz5N/bnMHdPOuS+ZTELx9ntsQIO7zGNvf4Osb5LKchTDbi8kzRfqsTSy1orrHONQSP1yFVU6dQWy87ZhaCFNhvEDoFMSMA/VF4Y2UAFA4MwHiF8MrCg2okXvPIES+6Bt6n42+mnUq1FUazJUJVRrUGoM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zD1UjWIC; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zD1UjWIC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TMWrNodyPbH0cxOyXghaAdCqoid1aUqucu2YzK3hs90=;
	b=zD1UjWICSccTtmI2eRKhTbmbc6ZzCS7MrAwECZrg4sM4bW5c6vjY09H0kHYj9d5crjWv1LGzW
	/iwWFNvY42eqIir1KhwPiMGpQMTTn3pJBI8SRFxXI3+i32Lwk0rRThnvYWVWz2UzgIWhupoWjz7
	VhuPm6XGVIM7K27bkERVbls=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dqX5363Y6z1vp0g;
	Mon, 12 Jan 2026 20:39:35 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqX7J1bc9zHnH4f;
	Mon, 12 Jan 2026 20:41:32 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 37D0640086;
	Mon, 12 Jan 2026 20:41:48 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 12:41:44 +0000
Date: Mon, 12 Jan 2026 12:41:43 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, "Suzuki
 Poulose" <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Message-ID: <20260112124143.000009c9@huawei.com>
In-Reply-To: <4117fd5aca061db0857c0fc87f320b01f3347376.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-3-sascha.bischoff@arm.com>
	<20260106180022.00006dcd@huawei.com>
	<cdef264835c24f1e2155cadd5a414fb34d06bca3.camel@arm.com>
	<4117fd5aca061db0857c0fc87f320b01f3347376.camel@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 16:57:18 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> On Wed, 2026-01-07 at 10:55 +0000, Sascha Bischoff wrote:
> > On Tue, 2026-01-06 at 18:00 +0000, Jonathan Cameron wrote: =20
> > > On Fri, 19 Dec 2025 15:52:36 +0000
> > > Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
> > >  =20
> > > > From: Sascha Bischoff <Sascha.Bischoff@arm.com>
> > > >=20
> > > > The VGIC-v3 code relied on hand-written definitions for the
> > > > ICH_VMCR_EL2 register. This register, and the associated fields,
> > > > is
> > > > now generated as part of the sysreg framework. Move to using the
> > > > generated definitions instead of the hand-written ones.
> > > >=20
> > > > There are no functional changes as part of this change.
> > > >=20
> > > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com> =20
> > > Hi Sascha
> > >=20
> > > Happy new year.=A0 There is a bit in here that isn't obviously going
> > > to result in no functional change. I'm too lazy to chase where the
> > > value
> > > goes to check it it's a real bug or not.
> > >=20
> > > Otherwise this is inconsistent on whether the _MASK or define
> > > without
> > > it from the sysreg generated header is used in FIELD_GET() /
> > > FIELD_PREP()
> > >=20
> > > I'd always use the _MASK version. =20
> >=20
> > Hi Jonathan,
> >=20
> > I've updated the code to use the _MASK version.
> >  =20
> Hi Jonathan,
>=20
> I've actually had a change of heart (sorry!). I think it is clearer to
> use the _MASK version when explicitly using the value as a mask, but to
> drop that for the FIELD_x() ops as in that case we're naming a field.
>=20
> I've gone through and made the usage of those consistent.

Fair enough.  I'd have argued that there should never have been both
in the first place in the generated header as the non _MASK ones add
no value. The only argument I can think of is that we don't normally
use _MASK for single bit defines when doing doing it by hand, but such
is life. I do think you are setting yourself up for a world in which new
patches mix these up and you get to post lots of review feedback on it ;)

Jonathan

>=20
> Sascha
>=20
> >  =20

