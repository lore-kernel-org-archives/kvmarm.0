Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010068.outbound.protection.outlook.com [52.101.228.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AF2628D
	for <kvmarm@lists.linux.dev>; Sun,  5 Apr 2026 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775391113; cv=fail; b=GHkGZ9nFnUo0yHtHKcQU3wJZawW4LtmxMNvHzDL7/tLGaNGi+Y5yaQ6PuqOJ876x46gbdiCipVgWNG08nJk0u3JS5ZLcEotYDGL3cu3bSvA/xfuII/teLBLpMr2dBGG9UH1nAjyylq5/OT1Pva1fnz7p5bKML/wYEky0LDIKtso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775391113; c=relaxed/simple;
	bh=okgCJUooem5DOO2RV8/KrlRtf8Li7A/XP+wWP/9U4gI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hr9PrG0whRYfqfJ2NxehCnMY8bLYl/N6OZ5ZdBQKyyz9fuMgoIdUzmhwgp89LUyX68nYa/4mKMUgnWT2AyKzQVp96FKwbD40N2j7l1ml31Zwe/rLd5YrFwLcG26il5YkuWzkO9L49bOHNhZMna2aAuE9zjy/EFDWtqqGZ/6Oyus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com; spf=pass smtp.mailfrom=bp.renesas.com; dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b=DbPo04wC; arc=fail smtp.client-ip=52.101.228.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b="DbPo04wC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0DYO13zhfgBVOXb0q7tlNkvLTYaKqOaypiCLMlT3dmk5IkbMmtB+cpqcYrE/0te/B8djuKwbzc33+1akQJ2/UjaG0B2xlqjwlcJbZeyE1SBj0XLOFmSJ0+bBe+NRKrmyGJV5p2mR7D5OV1KfXR76Ljfp26yXSwwIyqVLAX7AMypcT5t5VEiPWGAicB1f8/efa+TVzA4IzSeHa/jBz51Q6Q3VRYmf7XH7cYLH1crVFqKjkjXQH3JP+mTMlfWy5jGR/T7nUFOWiSUV5BuahLnBZ+EaxiPn4SThU4pJHMoT1rvj6Xz4V3Ebye5w0oJzx49Bc1agTXDu3Umfeps47E5rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5n5hiJRdTRMl2SjoiViHhBNXYkxBfSJ0KH4JW0pkDN8=;
 b=HSNL8RG/TQpCWvWsdSRher5zuymPjTH3FlNPeWdtuc31dg5/0VzSlekKnDSAq0ql3VmpWMFN5MzBEh7UuaTeXwPmOnAlU1iKoUcPyI9ySCJM8EpEZYBOQZaD7nNnXQGdZK6iZrsO0x8b4igtKwZid3vDrZr2sp6v7x1adCtBsokqTFy/69S5Tv0DCC0qZ0WMShnrCF8Sn+np6qwulbf3/Qwn2CQhe1cwuo8VNDfl7J+m8VeyKJttDQtZNwtHd9q9uwh2GlvZYTK33U804ikrLH1SxElyLRZm2eTQ2ihwSFk9trHP9GVWEHwhaD2yaxrdgzHdOfGMlwPR/7JxcubyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5n5hiJRdTRMl2SjoiViHhBNXYkxBfSJ0KH4JW0pkDN8=;
 b=DbPo04wCHbtf/gQ6RShKsSOnU5inCG6YdIf33K/iLrI70O1yaLh3xbLX0uqAho77SXvo+4JcIsyCyH4d2SFBKL8ld1uj3rlOqe5u94qmBvc3xyL1jFhns5UGIgmMUY8G3FEv1OwfXpSQjoCUm1cBGgToQJkkyS8YMwl9en7t+ak=
Received: from TYCPR01MB11332.jpnprd01.prod.outlook.com (2603:1096:400:3c0::7)
 by OSCPR01MB15842.jpnprd01.prod.outlook.com (2603:1096:604:3e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Sun, 5 Apr
 2026 12:11:49 +0000
Received: from TYCPR01MB11332.jpnprd01.prod.outlook.com
 ([fe80::2511:10cd:e497:4d97]) by TYCPR01MB11332.jpnprd01.prod.outlook.com
 ([fe80::2511:10cd:e497:4d97%5]) with mapi id 15.20.9769.020; Sun, 5 Apr 2026
 12:11:49 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "nathan@kernel.org"
	<nathan@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
	"sascha.bischoff@arm.com" <sascha.bischoff@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "will@kernel.org" <will@kernel.org>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: RE: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Thread-Topic: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Thread-Index: AdzE9EEcnOJjNTRNRVW2tIMxyY+9wgAAPErQ
Date: Sun, 5 Apr 2026 12:11:49 +0000
Message-ID:
 <TYCPR01MB11332F04E5FEA8361A6D462FA865CA@TYCPR01MB11332.jpnprd01.prod.outlook.com>
References:
 <TYCPR01MB11332B30F4C3BC3C61E21B5B9865CA@TYCPR01MB11332.jpnprd01.prod.outlook.com>
In-Reply-To:
 <TYCPR01MB11332B30F4C3BC3C61E21B5B9865CA@TYCPR01MB11332.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11332:EE_|OSCPR01MB15842:EE_
x-ms-office365-filtering-correlation-id: fd28a91e-20aa-43ab-fc93-08de930c8404
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 Ub1xcPz+1QGEqImhclOeCYGCT+CL2aGR1ePSfxb7g6rWCLUXFAJRr9qTbo6LnIK6LRwMApK3/3Zukjo1pZ1Hj+nNUDncNHr8CUAxk4nK4MZf3Y4L4TTfJfFpYiOeHCFHRxrxkm5qtzPLSQ5b58nfDKc/CveD1vfrOyoxHnsjQD613gtpxOI1CUnsl8+Q7GjUwBzNidmF2HvAU0IoVUa5aAvULt8guu1f+eu4Pq/Tmow/UTsTK0OEVPLxpdUUqH5lqG98yNPWgm7YAzizESwYL6UYkokRlVqAPK78uKefXX/ypJTN/BwOBYYwwpFZcp0PE7oc6vY9S4ovOc9wyDxtQhrsvZ7LzltpNh8aroNNEuzzeqojWUIhCL2cF0OR/nH6LHUZL6TfMchfQvr/vNCjdufuRIUltVoe5ERvm569iJ5ydyjGjkzCYTskEKhBUV66x588maN9UaB6KBLsNBjRcX+ShvQG8EIZeGvDIlF2h9CF1XdoPTXs63HjKtwPGYXA8dqPoYoT0aSoj6nS/VC/6jWsYrpH5UcPH1RSj2vghRqX6xGeJjhuNmWpeWtLSGTR2cRJ4uO/vG6bofxBb1VTEwssl6GaadjBdhhveKmiwdgHqDX+YZX8dkVF0HD7SBzHpOe0svstqezoDgY2Ho7UsGI+HlwvyGQKNLuipeGpGGl5cjiqNK96WGWr+HdTX50yO9oJFhtNywO8rM6W4jhHmcYXZiVoXv6hEau77ZXDdhTY3busMYvFIFwri2GcbJ2PrdkOkOmDuNK4stH57y6XYbHZ9HhrlW4RtKcj6slpQpo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11332.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?kBmat2sXiz4sPUsW2rN5or6NhrYw00DSqEYpRRvl26OVZqN5hj6LXMrmvJrS?=
 =?us-ascii?Q?a2p3fJ6a3QiB2WH4J1GYiqB6YTMdIPfgGx0f5hksiM8Lfb0a8aeaZzcTR/ky?=
 =?us-ascii?Q?KTvndSTDzbHC4UXOckMrXoTw8IU6nvgn6o1cJex1q7Y7WCBSkb3wq+TA6ANS?=
 =?us-ascii?Q?6nzs/KSiY5JEI7xjEEVEVgaaRen/SK7i67BqmbX60cosMlWGGTo+2bARUbiX?=
 =?us-ascii?Q?Dv2Z8fL8vUSqSUrokOqkx8mcxH3sjVmmUVxg833N4pTiYPFHCU9SFRUBNo7/?=
 =?us-ascii?Q?71N9NRSCTBH3ZOUSD5rj9YBcZ+0QEiV2eNhcgcaUSoWXeweCIQit1XOV/lEF?=
 =?us-ascii?Q?VJNTRJzF1Vsnu2xQPP/J3XfbAr/OYDOMW5p82g6AmFYuPvZAcJTUILkbspCA?=
 =?us-ascii?Q?5PUaHXDX0NAqG6JWNdJfFoLwsjp7V+DP/LVOaKdw4kQ2wjEYP9F/wpkb9cvy?=
 =?us-ascii?Q?e/Qs4vouco9rnVW/NHQtR7CT61/Xg//T7wP3lASrCdT2AlG3KSDriOP7M/5R?=
 =?us-ascii?Q?WCapJJsK/kX6t8ITe/CUVIsKnyq0PmRNP+t8MfuNUwuj0qIDj6ct4azHXJe+?=
 =?us-ascii?Q?kj/n8OIDrI0L8tUsQqxhq4Qt8L62fGbmwHnSOJHTv7XZaWlZJaEV9XdU0aXm?=
 =?us-ascii?Q?vE9L88UW04f4bnMgXjXBYclu5QxTrfcioymScIodE7RhB4JQSVuSN/FQbEwX?=
 =?us-ascii?Q?588eaqhDt6+bcQigBftDNokNQiW6a5OelzYLK4RIeCp2kasLqe5FKaXNB4M+?=
 =?us-ascii?Q?Wc+00WFf+09GFhxMY5mQ4gJ5juOJEv18LZxB0aa7gkvD935dMR+Sn9zJ382L?=
 =?us-ascii?Q?goirWT5VsgsAkd0mgURCTqtcb2NVQm0+v3SNxIa0+6Vw4ygiGorNxBXiLxOh?=
 =?us-ascii?Q?oCMxcVbXovOYgIyc15EWn/OWTFJxTL7F2D676x6y+qnIoMjFnfVxvMXhsaDp?=
 =?us-ascii?Q?knl8f9qcu2L6kfm4BjSirpMkLtnn3xoplQkX4C/M8yfue11M/k3RKraruyAV?=
 =?us-ascii?Q?j93WhfZLDHu5UntATswQo5/0Ae45VyRo7WgafuN5pmBS3xz4Uo/aIVTGB4t8?=
 =?us-ascii?Q?W2BiNb1N9GSXEayiIw6j7jUezG/VFhzbtyMTSIl9nWzZoFFAagKp45cETKI+?=
 =?us-ascii?Q?de5buJ5mPucMX/Dgt7S2hm/TDj9appSCSTBMspgUADXAgI/1nx37lZTpeueA?=
 =?us-ascii?Q?oLRBVIlLYa0vi7xQw9xqZK6Eq8Lk63moSddYWchBrsELZDlqK4+fegnYAc5h?=
 =?us-ascii?Q?5zbm21/MqYE3jFjti9ooOJM9L0gmcdX5fwyW4KwnTDbe3UmwGa0mtej2h2aB?=
 =?us-ascii?Q?1K4lupkQKyBwkTJpPKaKfkn69gXwBMa5yNANAE21OxvVlAiukV+eRF2rGFVo?=
 =?us-ascii?Q?FYk5dGEq01T6/6dEGlDnf4r/4lMDRvdFu31+fTEgu0cdJ71DrB2TtErqQ+GZ?=
 =?us-ascii?Q?orpeVleHPqMssOCoofrZDUv3fKXMYAGx4gCXkxuMkEYAfOHRjvgt2VPNydAY?=
 =?us-ascii?Q?xmovCaXfhzAZ34Z4OgCin3l8XKS8BcQmoTrVPt/27fI7yPg/RMFNhL1b8kvJ?=
 =?us-ascii?Q?Pthw3m1tNfQdrVpRi5Zu0c6+wtTydVsT7HbrSiNZu8UmlzDthKtmBm5ZN+vI?=
 =?us-ascii?Q?uoTfg/Vq/uhsSkWSWsHMPBEu1XfqsQB+nu7gzY8ZOHHoGQB6NL3MvJwh9qPW?=
 =?us-ascii?Q?Hf+6GlnU5wyYhCU5uE8glLRflhdr3Ci5v1M/+ZZoIl7UPOmm7iKaEIpTqXMQ?=
 =?us-ascii?Q?tZk/RS3Dow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11332.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd28a91e-20aa-43ab-fc93-08de930c8404
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 12:11:49.6690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: usag7dH5OlphvN4jIV1m+LJ0gGZ7O/lj2ZzUhzqTgXafqODoXdldAbqWwWf8Ku73mu/27U8MvQhzl9V6Hi2PFZeqQVNXaSYUCy6DFvtKNOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB15842

Hi Marc,

> -----Original Message-----
> From: Biju Das
> Sent: 05 April 2026 13:09
> Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
>=20
>=20
> Hi,
>=20
> > Hi Marc,
> >
> > On Wed, Apr 01, 2026 at 06:00:17PM +0100, Marc Zyngier wrote:
> > > As we are missing ID_AA64PFR2_EL1.GCIE from the kernel feature set,
> > > userspace cannot write ID_AA64PFR2_EL1 with GCIE set, even if we are
> > > on a GICv5 host.
> > >
> > > Add the required field description.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kernel/cpufeature.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/arm64/kernel/cpufeature.c
> > > b/arch/arm64/kernel/cpufeature.c index 32c2dbcc0c641..5bca6e064ca72
> > > 100644
> > > --- a/arch/arm64/kernel/cpufeature.c
> > > +++ b/arch/arm64/kernel/cpufeature.c
> > > @@ -327,6 +327,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr=
2[] =3D {
> > >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2=
_EL1_FPMR_SHIFT, 4, 0),
> > >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64P=
FR2_EL1_MTEFAR_SHIFT, 4,
> ID_AA64PFR2_EL1_MTEFAR_NI),
> > >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE,
> > > ID_AA64PFR2_EL1_MTESTOREONLY_SHIFT, 4,
> > > ID_AA64PFR2_EL1_MTESTOREONLY_NI),
> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
> > > +ID_AA64PFR2_EL1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
> > >  	ARM64_FTR_END,
> > >  };
> > >
> > > --
> > > 2.47.3
> > >
> >
> > After this change in -next as commit 899ff451fcee ("KVM: arm64:
> > Advertise ID_AA64PFR2_EL1.GCIE"), I am seeing a warning on boot in my
> > simple QEMU boot tests.
> >
> >   $ make -skj"$(nproc)" ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-
> > mrproper virtconfig Image.gz
> >
> >   $ curl -LSs
> > https://github.com/ClangBuiltLinux/boot-utils/releases/download/202411
> > 20-044434/arm64-rootfs.cpio.zst | zstd -d >rootfs.cpio
> >
> >   $ qemu-system-aarch64 \
> >       -display none \
> >       -nodefaults \
> >       -machine virt,gic-version=3Dmax \
> >       -append 'console=3DttyAMA0 earlycon' \
> >       -kernel arch/arm64/boot/Image.gz \
> >       -initrd rootfs.cpio \
> >       -cpu host \
> >       -enable-kvm \
> >       -m 1G \
> >       -smp 8 \
> >       -serial mon:stdio
> >   [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x413fd0c1=
]
> >   [    0.000000] Linux version 7.0.0-rc4-00058-g899ff451fcee (nathan@aa=
dp) (aarch64-linux-gcc (GCC)
> 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEMPT Sat Apr  4 06:55:05 MS=
T 2026
> >   ...
> >   [    0.000000] ------------[ cut here ]------------
> >   [    0.000000] SYS_ID_AA64PFR2_EL1 has feature overlap at shift 12
> >   [    0.000000] WARNING: arch/arm64/kernel/cpufeature.c:986 at init_cp=
u_features+0xbc/0x344, CPU#0:
> swapper/0
> >   [    0.000000] Modules linked in:
> >   [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.0.0-r=
c4-00058-g899ff451fcee #1
> PREEMPT
> >   [    0.000000] Hardware name: linux,dummy-virt (DT)
> >   [    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
> >   [    0.000000] pc : init_cpu_features+0xbc/0x344
> >   [    0.000000] lr : init_cpu_features+0xbc/0x344
> >   [    0.000000] sp : ffffcd0982373db0
> >   [    0.000000] x29: ffffcd0982373db0 x28: 0000000000000010 x27: ffffc=
d0981c63878
> >   [    0.000000] x26: 0000000000000018 x25: ffffcd0982013f38 x24: ffffc=
d0981c69068
> >   [    0.000000] x23: ffffcd0981c635f0 x22: ffffcd0982388640 x21: 00000=
00000000003
> >   [    0.000000] x20: 0000000000000017 x19: ffffcd09824c9308 x18: 00000=
0000000000a
> >   [    0.000000] x17: 5d305b203837205d x16: 305b203737205d30 x15: 00000=
00000000000
> >   [    0.000000] x14: 0000000000000000 x13: 3231207466696873 x12: 20746=
12070616c72
> >   [    0.000000] x11: 0000000000000058 x10: 0000000000000018 x9 : ffffc=
d0982396598
> >   [    0.000000] x8 : 0000000000057fa8 x7 : 000000000000002a x6 : ffffc=
d09823ee598
> >   [    0.000000] x5 : ffffcd09823ee598 x4 : 0000000000000000 x3 : 00000=
00000000000
> >   [    0.000000] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffc=
d09823852c0
> >   [    0.000000] Call trace:
> >   [    0.000000]  init_cpu_features+0xbc/0x344 (P)
> >   [    0.000000]  cpuinfo_store_boot_cpu+0x48/0x54
> >   [    0.000000]  smp_prepare_boot_cpu+0x28/0x38
> >   [    0.000000]  start_kernel+0x248/0x780
> >   [    0.000000]  __primary_switched+0x88/0x90
> >   [    0.000000] ---[ end trace 0000000000000000 ]---
> >   ...
> >   ```
> >
> > Is this expected? I assume not, hence the report. If there is any
> > information I can provide or patches I can test, I am more than happy
> > to do so.
>=20
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c index
> 5bca6e064ca72..1bfaa96881dab 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -325,9 +325,9 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] =
=3D {
>=20
>  static const struct arm64_ftr_bits ftr_id_aa64pfr2[] =3D {
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1=
_FPMR_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
> +ID_AA64PFR2_EL1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_=
EL1_MTEFAR_SHIFT, 4,
> ID_AA64PFR2_EL1_MTEFAR_NI),
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_=
EL1_MTESTOREONLY_SHIFT, 4,
> ID_AA64PFR2_EL1_MTESTOREONLY_NI),
> -	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_=
GCIE_SHIFT, 4,
> ID_AA64PFR2_EL1_GCIE_NI),
>  	ARM64_FTR_END,
>  };
>=20
> The below next-20260403 warning on RZ/G3L SMARC EVK is fixed by the above=
 code.
>=20
> [    0.000000] Call trace:
> [    0.000000]  init_cpu_features+0xb8/0x2fc (P)
> [    0.000000]  cpuinfo_store_boot_cpu+0x48/0x54
> [    0.000000]  smp_prepare_boot_cpu+0x24/0x30
> [    0.000000]  start_kernel+0x230/0x6a4
> [    0.000000]  __primary_switched+0x88/0x90
>=20

I just tested your patch

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>

Cheers,
Biju
