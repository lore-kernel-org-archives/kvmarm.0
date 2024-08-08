Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AB555769
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723140643; cv=none; b=UJ6yLIy+KexkI9rYSyigiGkXmLkSMfDji9nJVEdkOYJuGmMZqCxmH9XHGst+QdFfWKgsIJvIybj/Ay0CLNWbaatJIdL5yb6z7cda5eMxjRgyF6qCwbj+FzJGGp+/18WwTPWcD3IXRIfD12eZDf44JItoxSzThuvXuTUq4J4pLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723140643; c=relaxed/simple;
	bh=xvODetN8C4yo+bJ9dNJJjO7XiuiV2qIuty8/Snojry8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mDpepKCJzEdzE7J4tMkBG7VJSZ0wWlX1nuS990zj0I7DPWeqMY/ckL5hgffih0mmnLnJMpBld2zNE/tI4GPCD8VTJoIQGVKeLmnOVl8RMGf/RQ++7GK/Xt0bLNlgpm+ILB+VlbeM1SD2bhMGyxNDse2zwZ97oWTtFgxydlEPp/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wfw5k2rM1zDqW1;
	Fri,  9 Aug 2024 02:08:42 +0800 (CST)
Received: from dggems701-chm.china.huawei.com (unknown [10.3.19.178])
	by mail.maildlp.com (Postfix) with ESMTPS id DAFA0180AE5;
	Fri,  9 Aug 2024 02:10:36 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 02:10:35 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 8 Aug 2024 19:10:33 +0100
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
Subject: RE: [PATCH] KVM: arm64: Disable OS double lock visibility by default
 and ignore VMM writes
Thread-Topic: [PATCH] KVM: arm64: Disable OS double lock visibility by default
 and ignore VMM writes
Thread-Index: AQHa6ZLiWjeeh1HBGka45Wu/S0A0I7IdkAQAgAAWKlA=
Date: Thu, 8 Aug 2024 18:10:33 +0000
Message-ID: <f81365c28d1b4ae1a5e9c2345d24b2c7@huawei.com>
References: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
 <ZrUC5O8XUuvlLJcc@linux.dev>
In-Reply-To: <ZrUC5O8XUuvlLJcc@linux.dev>
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

Hi Oliver,

> -----Original Message-----
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Thursday, August 8, 2024 6:40 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; linux-arm-kernel@lists.infradead.org;
> maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; suzuki.poulose@arm.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH] KVM: arm64: Disable OS double lock visibility by def=
ault
> and ignore VMM writes
>=20
> Hi Shameer,
>=20
> I find myself asking *why* we need this, could you share some details
> on the issue you're encountering?

Sorry, I missed the why part. Mainly for VM migration purposes as we have s=
ystems
with DoubleLock implemented and not implemented(with DebugVer 8.2).

>=20
> Indeed, RAZ/WI is not a faithful implementation of FEAT_DoubleLock, but
> I wouldn't expect it to be used in a VM in the first place.
>=20
> On Thu, Aug 08, 2024 at 01:57:11PM +0100, Shameer Kolothum wrote:
> > KVM exposes the OS double lock feature bit to Guests but returns
> > RAZ/WI on Guest OSDLR_EL1 access. Make sure we are hiding OS double
> > lock from Guests now. However we can't hide DoubleLock if the reported
> > DebugVer is < 8.2. So report a minimum DebugVer of 8.2 to Guests.
>=20
> What if a user wanted to virtualize an exact CPU model that only
> implemented v8.0?

Yeah. I was a bit concerned as mentioned below of bumping up DebugVer to 8.=
2.
But then I found a similar attempt you made a while back,
https://lore.kernel.org/linux-arm-kernel/20211029003202.158161-1-oupton@goo=
gle.com/T/#meee94d87db3f8042156557dbf9743bb03cf0aaa9

>=20
> > All this may break migration from the older kernels. Take care of
> > that by ignoring VMM writes for these values.
>=20
> Ignoring userspace writes is a pretty big hammer. In situations where
> KVM had advertised a feature that was outright not supported (e.g. IMP DE=
F
> PMUs) it _might_ make sense. But with this change we're messing with a
> CPU feature we *do* support.

The concern here is for the DebugVer I guess. But if VMs are not making use=
 of
any 8.0 specific features(as I understand it, only external debugger suppor=
t is the
difference), then is that an issue?
=20
> Would allowing userspace to downgrade ID_AA664DFR0_EL1.DoubleLock to
> 0b1111 be enough?

Yeah. Could I guess. But then we need to check the DebugVer matches to 8.2 =
or not
as well.

Idea was, is there any point in exposing  features that are not supported o=
r used
by VMs in the first place.

Thanks,
Shameer

