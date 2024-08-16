Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC63F3F9D5
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 06:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723790248; cv=none; b=jgH9zao6DppJaWWPtmOsAhs4OXmtHlsUgQ8qx3IRDZDkSzuqHrzs5zh168xehdcEi1fM57YW2GeEDtmp6glSrNEUzA/eo/USZlRdljtOYAwCLzEv5ydRL8xc/VxyVA+sCqk4bug1d2ELfac9LGzhJROdxE5jY2zXegVIWwMe3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723790248; c=relaxed/simple;
	bh=yOeZ68dIgpjrjF9ocnzcq2Nsk/ZIXDuKvt9XjHZtG3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pg24OtTWB4xonjmlvCXflFtcrXh1GMMfJIDQoBKkM8Iz9oGZsyHGnnS8C07PzPbyTLhKe1QSXCb/t2rfYH3b76rDGGJF0+SUCTZy/THbYKsy/VFmnMU1TSXJX2pR34AAe/29tw9urdBvpvRZsr8XbcUUNnJtkN9I97T4gkdPPnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WlXH24vkZz20lpm;
	Fri, 16 Aug 2024 14:32:46 +0800 (CST)
Received: from dggems703-chm.china.huawei.com (unknown [10.3.19.180])
	by mail.maildlp.com (Postfix) with ESMTPS id A51B114010C;
	Fri, 16 Aug 2024 14:37:22 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 14:37:21 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 16 Aug 2024 07:37:19 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, yuzenghui
	<yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, Linuxarm
	<linuxarm@huawei.com>
Subject: RE: [PATCH v2] KVM: arm64: Make the exposed feature bits in
 AA64DFR0_EL1 writable from userspace
Thread-Topic: [PATCH v2] KVM: arm64: Make the exposed feature bits in
 AA64DFR0_EL1 writable from userspace
Thread-Index: AQHa7zbh7/PdHGyJpUSDMKRE5tsnxbIohcUAgADndSA=
Date: Fri, 16 Aug 2024 06:37:19 +0000
Message-ID: <4476eb0e278c446892d7325712de2432@huawei.com>
References: <20240815155954.85480-1-shameerali.kolothum.thodi@huawei.com>
 <Zr49_ticsFzHOJq8@linux.dev>
In-Reply-To: <Zr49_ticsFzHOJq8@linux.dev>
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
> Sent: Thursday, August 15, 2024 6:42 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; linux-arm-kernel@lists.infradead.org;
> maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; suzuki.poulose@arm.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v2] KVM: arm64: Make the exposed feature bits in
> AA64DFR0_EL1 writable from userspace
>=20
> On Thu, Aug 15, 2024 at 04:59:54PM +0100, Shameer Kolothum wrote:
> > KVM exposes the OS double lock feature bit to Guests but returns
> > RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
> > systems where this feature differ. Add support to make this feature
> > writable from userspace by setting the mask bit. While at it, set the
> > mask bits for the exposed WRPs(Number of Watchpoints) as well.
> > Also update the selftest to cover these fields.
> >
> > However we still can't make BRPs and CTX_CMPs fields writable, because
> > as per ARM ARM DDI 0487K.a, section G2.8.2 Breakpoint types and
> > linking of breakpoints, highest numbered breakpoints must be context
> > aware breakpoints. And it will be problematic if userspace decreases
> > the number of non-context aware breakpoints as it will make the
> > context aware breakpoints for the guest mapped to a wrong one.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >    v1 --> v2:
> >    Removed making BRPs and CTX_CMPs writable.
> >    v1:
> > https://lore.kernel.org/all/20240813142835.77180-1-shameerali.kolothum
> > .thodi@huawei.com/
> > ---
> >  arch/arm64/kvm/sys_regs.c                         | 13 ++++++++++++-
> >  tools/testing/selftests/kvm/aarch64/set_id_regs.c |  2 ++
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c90324060436..e77cd6d1abb5 100644=02
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2376,7 +2376,18 @@ static const struct sys_reg_desc sys_reg_descs[]
> =3D {
> >  	  .get_user =3D get_id_reg,
> >  	  .set_user =3D set_id_aa64dfr0_el1,
> >  	  .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -	  .val =3D ID_AA64DFR0_EL1_PMUVer_MASK |
> > +	/*
> > +	 * We can't still make BRPs and CTX_CMPx writable as highest
> > +	 * numbered breakpoints must be context aware breakpoints(ARM
> ARM
> > +	 * DDI 0487K.a, section G2.8.2 Breakpoint types and linking of
> > +	 * breakpoints). Hence, if the number of non-context aware
> breakpoints
> > +	 * for the Guest is decreased by userspace, that will be problematic
> > +	 * as KVM will map context aware breakpoints for the vCPU to
> different
> > +	 * numbered breakpoints for the pCPU.
>=20
> A few minor nitpicks:
>=20
>  - BRPs counts the total number of breakpoints, not just the non-context
>    aware BRPs
>=20
>  - KVM doesn't do any register mapping at all, which is why we disallow
>    changing the breakpoints altogether

Ok. I will update the commit log and comment here.
>=20
>  - The citation is for the AArch32 view of the debug architecture, not
>    AArch64.

Oops, my bad..indeed it is section D2.8.3.

> Perhaps use this wording:
>=20
> 	/*
> 	 * Prior to FEAT_Debugv8.9, the architecture defines context-aware
> 	 * breakpoints (CTX_CMPs) as the highest numbered breakpoints
> (BRPs).
> 	 * KVM does not trap + emulate the breakpoint registers, and as such
> 	 * cannot support a layout that misaligns with the underlying
> hardware.
> 	 * While it may be possible to describe a subset that aligns with
> 	 * hardware, just prevent changes to BRPs and CTX_CMPs altogether
> for
> 	 * simplicity.
> 	 *
> 	 * See DDI0487K.a, section D2.8.3 Breakpoint types and linking
> 	 * of breakpoints for more details.
> 	 */
>=20
> Besides that, LGTM:
>=20
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks. I will respin with the updates.

Shameer
=20
