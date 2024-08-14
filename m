Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD0013AA32
	for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 09:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723627041; cv=none; b=ZmcQVHYfm+GgiJDtqKpD/cc3mFaK5WY0mEBRh6THjI5+WelNYavNLa4KtJTAfxrOSf53LnFCNxUSynbaYQ18POPYVGYadWaGen8hJTfi9goM4HrnNhoItQan8nj+Nvi6sVwmVjJKZTwz/J1Q5GuQapeGQsNl0tq1aE6WoBDPpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723627041; c=relaxed/simple;
	bh=WJwi6yHYSwrdh0FNJ6uXg0YK0eD/DkdKs5FzxvuinI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GBvfqllrvANeXzEVmXVqV0CdlBuYlr4V8DSZ8IhfO4PTe0bmpoT+SXkyYZ5lJiN8st1Ig4ghG6VK7/EYEH2Sphf3yOkxS3vyyHapAPZHSVZ5UER9dNrx/faZC+T05z0HSgPDg1lRLxmsjAIgungF+nb25U93OIFaB1FUJhcporQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WkMw52DDTz1S7sK;
	Wed, 14 Aug 2024 17:12:21 +0800 (CST)
Received: from dggems701-chm.china.huawei.com (unknown [10.3.19.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F48214013B;
	Wed, 14 Aug 2024 17:17:13 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 17:17:12 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 14 Aug 2024 10:17:10 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, yuzenghui
	<yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, Linuxarm
	<linuxarm@huawei.com>, "reijiw@google.com" <reijiw@google.com>
Subject: RE: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1
 writable from userspace
Thread-Topic: [PATCH] KVM: arm64: Make the exposed feature bits in
 AA64DFR0_EL1 writable from userspace
Thread-Index: AQHa7Y1+WzkgTs0yNU+rMcrsz2HCl7IlbzSAgAEG32A=
Date: Wed, 14 Aug 2024 09:17:10 +0000
Message-ID: <b2dad37ac5464384abe4edf76cb6b546@huawei.com>
References: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com>
 <86v804z3lk.wl-maz@kernel.org>
In-Reply-To: <86v804z3lk.wl-maz@kernel.org>
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
> Sent: Tuesday, August 13, 2024 7:21 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; linux-arm-kernel@lists.infradead.org;
> will@kernel.org; catalin.marinas@arm.com; oliver.upton@linux.dev;
> james.morse@arm.com; suzuki.poulose@arm.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH] KVM: arm64: Make the exposed feature bits in
> AA64DFR0_EL1 writable from userspace
>=20
> On Tue, 13 Aug 2024 15:28:35 +0100,
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> >
> > KVM exposes the OS double lock feature bit to Guests but returns
> > RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
> > systems where this feature support differ. Add support to make this
> > feature writable from userspace by setting the mask bit. While at it,
> > set the mask bits for other exposed features in the AA64DFR0_EL1
> > register as well.
> >
> > Also update the selftest to cover these fields.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >    This is based on the discussion here(Thanks to Oliver),
> >    https://lore.kernel.org/all/ZrVSlbVwnaMDShah@linux.dev/
> > ---
> >  arch/arm64/kvm/sys_regs.c                         | 6 +++++-
> >  tools/testing/selftests/kvm/aarch64/set_id_regs.c | 4 ++++
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c90324060436..adb49d681052 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2376,7 +2376,11 @@ static const struct sys_reg_desc sys_reg_descs[]
> =3D {
> >  	  .get_user =3D get_id_reg,
> >  	  .set_user =3D set_id_aa64dfr0_el1,
> >  	  .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -	  .val =3D ID_AA64DFR0_EL1_PMUVer_MASK |
> > +	  .val =3D ID_AA64DFR0_EL1_DoubleLock_MASK |
> > +		 ID_AA64DFR0_EL1_CTX_CMPs_MASK |
> > +		 ID_AA64DFR0_EL1_WRPs_MASK |
> > +		 ID_AA64DFR0_EL1_BRPs_MASK |
>=20
>=20
> I think this is going to cause some troubles.
>=20
> The issue is that context-aware breakpoints are the highest-numbered
> breakpoints, right after the normal breakpoints (D2.8.3 "Breakpoint
> types and linking of breakpoints"). So if you reduce the number of
> normal breakpoints, you shift the context-aware ones down, and
> everything breaks.

Thanks Marc for explaining this. I was not aware of this one.

> I really don't see how you can safely do that without completely
> changing the way we handle the debug registers.

Looks like Reji has attempted to do this a while back,=20
https://lore.kernel.org/kvm/20220419065544.3616948-13-reijiw@google.com/

I guess that one is trying to address the problem you described above, righ=
t?
Though, not clear to me what happened  afterwards to these patches in the s=
eries.

Coming back to this patch, we don't have a requirement now to make the
breakpoints writable for migration. The only concern is OS Double lock feat=
ure.=20
Not sure anyone has a high priority requirement to make the other features
writable or not. Will it be acceptable if I resent this patch with just OS =
Double Lock
being writable?(Sorry If I sound selfish, but at least some progress can be=
 made soon).

Thanks,
Shameer
