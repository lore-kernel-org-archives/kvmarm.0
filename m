Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010069.outbound.protection.outlook.com [52.101.228.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B8814AD20
	for <kvmarm@lists.linux.dev>; Sun,  5 Apr 2026 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775390923; cv=fail; b=WDXD11L+Oo+mR21tLd7I3VhYqZYi9mgImkJ4rOY/GH2c7BLGZwQAPar7KAoeK6kcteOMfUqPRMGyMFKL9GCY/gVmnOdDV2Kqm1BG2EWZrW6gMMwvWsjY6BjP2kmQ5aFOvjESts87PO9oTQhwFjA8IvB/oslTyfmkbINdvvinJQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775390923; c=relaxed/simple;
	bh=ZnJqba+j2BObxtG7MlDhp7TF98hWQ/XwdUcsE9Si1Ys=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=usHeBLPZBsgz9JtoZ+jr/s/BdPFeALIQy9F/druf7opEAdaJM6UTfRplzDtZbn0uxFxy2QNVurmXuvkMy8jCtBy/amlNMUPzKX/Up5kie2KWSu7xv0+wYIG2EbpbsBz4zYB3jqzK3lCXkpmwNsMmnbkJFsLsj5uyPEmteDALXZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com; spf=pass smtp.mailfrom=bp.renesas.com; dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b=CXMKZ3ox; arc=fail smtp.client-ip=52.101.228.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b="CXMKZ3ox"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6KO/oHov3X/vYggsxFQSjV5IfQQ4Ayy7Fz0/QliaKzmy/b58MAbTd4AcXlzQ2HZDrfw18FdgCmd9wkM83XfNCo8LdKBhwbfNhBtJyP1+AiJwpy0ncjDo3cgciacg6qe3A2vzzWBSaSZSTCFaWgiUkhyzHIcigW/IiGaHUlGS21sI2OsmzZDZpv0RjMbrNsqE5Gfmwn5JH9dBz0aR49ayT9nWwCIU6TGWjw4cyhxbapTRwlvtlyX1aG3YhcCdQbxCc7XE24W4WZfBxfKYL7NOJr4ZyVtcB0vVmM+jz0v1Pf9F6TuWGfZVovLcvQ/3DKHJ/0rJNYfwG2BW7bAzwCraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggftAJOO2Q/hdUWZIlkoY49rjbirGrtZJfs0S8jcRVc=;
 b=tmruY90uzl92foMEHwTqabvUgtgQc7o04UCowWB699f8uGmvYxIER/XHETVjM7QWG/vd3gk4Iz+4Z8zxHoMcQZIihEn4vN6xvWZkBYTFIkCukqthwG9tr56Cfy4SvCsxy3g7UvVwM6ltpQqH+31ZduuFc//7cikcfnpgniFwD5ZqlrxJRCCcfUGQX/ZY/DV/R/8zp23yeYvsVnNChHz4f7yk/UJGtJK0RutvwCzKT3dkrWbo9ajikvDGF1fYqZTCpd7E7A2XwCege0Cw9pTpQapn5QstvCIW3kGtX5CAlwIlEnwHOD0CdRs338Dct92InQsvZ5bf5QUNZcNExgPtlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggftAJOO2Q/hdUWZIlkoY49rjbirGrtZJfs0S8jcRVc=;
 b=CXMKZ3oxXv3ED5MfhWcafoF/an80IgNWNYd5eJLVAaSyzLtPWIsFrgzoc2uoePvH/VPk3QBhYEY048AUBQ3DR4QvJX2s14C2FIqXXwmnTu1RM/z24mB5BsYh+QUkrI551LqhIpTmXKtDuXDbLQacN1Yuj+I5YwUKRPkIqYWd0xM=
Received: from TYCPR01MB11332.jpnprd01.prod.outlook.com (2603:1096:400:3c0::7)
 by OSCPR01MB15842.jpnprd01.prod.outlook.com (2603:1096:604:3e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Sun, 5 Apr
 2026 12:08:37 +0000
Received: from TYCPR01MB11332.jpnprd01.prod.outlook.com
 ([fe80::2511:10cd:e497:4d97]) by TYCPR01MB11332.jpnprd01.prod.outlook.com
 ([fe80::2511:10cd:e497:4d97%5]) with mapi id 15.20.9769.020; Sun, 5 Apr 2026
 12:08:34 +0000
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
Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Thread-Topic: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Thread-Index: AdzE9EEcnOJjNTRNRVW2tIMxyY+9wg==
Date: Sun, 5 Apr 2026 12:08:34 +0000
Message-ID:
 <TYCPR01MB11332B30F4C3BC3C61E21B5B9865CA@TYCPR01MB11332.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11332:EE_|OSCPR01MB15842:EE_
x-ms-office365-filtering-correlation-id: 100d1323-ad10-4135-575d-08de930c0f99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 C1gKv5Zp0ElDZkW709m5nequLCylhS+H4DjYflhFa2VTM8Ib88GwuISkthL+GBsspWa2z/dFDoc4wvd2dvmFa/B422sAyArh0bHKClQ79LMDYJYciTWVgTgL8VkgUoICH0gGWkbsLaiUnKtmA5Dk/jR8+sT4V6hFAmpp6yrMcXobxS0Hj94whQvNzWck/9855QoBV3NVnRRliYiHk+fzSeT+i4CiyS3Fe/GFiKunHQ8br+W3xxqZZCjM38psj2yCsEK0ec3g6rgKQt2K2A5zD2a13ZOWl1yimpmfVXM2wFoAgO24Hkn2qreOR3cC5PHMEfZIYHn7m5MeMDj0+5JoHybXs5vbtakdLrNNim4+TWfx4PtlNpYZo/h1dtPB3T+zserEFSPvB3ITDLbOK21kc27w8CI5fuIQF1vZn9m5sgxvpMKMv48znd/FamniQhVYkjbmCILUdeF9t/xdhf9gbSmd/nZHSk2oiSZRXt+5y31fZErxYdt0IdfKLoxUAoU3LRajmOyXQ0Tj82UGG2F4v2mObAvbeY4qiaX1J04TNTobDpKLzAVp4R7pFEEjhoLrhT7sW9t0yQrmZAZNLd0AGmUPljbxJ1Tkqe6yqQvIAK0DgP5k44gChkAKqHsh2OL5TJdnZnfGD6xnEk9vh+7ZkslwXGzfA3zMbWZXPPE2mI3QDxXgkJrLZCtJPk5ExxmaHq+inOM5ndK12yjDNSACE8tOTShnHGDusoqMP4mbdWytYL0domiW2bRoydQO06DIAsJ/8Jkd04pg6hU/GMBDTM4Qxlt6HGfN6gnKTJU1K3E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11332.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?u0PY2E4JjjN8rf8Hh7rU77tccANUMWLMwiDMdhHfK1HvX/LhMpVMA0k9tQsz?=
 =?us-ascii?Q?P8jDKiTT4xHerKlY6+hkpODLrZGBHdIVqiCCDVoBv/yIStaGySHs4nX6vMqB?=
 =?us-ascii?Q?Gw6UqJZclN/Zk3YJeFcnSlPVdOOAo2jtOaz0ZMRposOptmg7tCobltZEOIAj?=
 =?us-ascii?Q?uxciPZ8DsCa4ri3XMa6a1iG3gzcofyTzwSiKXDm/Ghj9WFRhhNFvFxDYurcI?=
 =?us-ascii?Q?TVrYmv8w7Ej90IQxZiFhkBG//o29MEnN47vz3z8Zn+pYNwMYmeZQmYZ1RWRH?=
 =?us-ascii?Q?Su64ZecN+UGCT8Ev1QHuNDrRlD/K+rX5bAsKxGdst66ssrp/Bwz4Q+pC/F7L?=
 =?us-ascii?Q?vWlHcDys+qLPsrAWXH3dYEV5ZETLINpJVps7dUEIYF5PTlQhQCnIvpVHltoM?=
 =?us-ascii?Q?1qrOxvuKs/c9KqGcULLIz2aD2AQ2G7vX13owMOs9A9YA5hsdr0pF3FPHzYM+?=
 =?us-ascii?Q?sABsBe3iP/rvuZOwWm850uBkvIerDEV5JlA+7/CQBTiWb/dQhp6QxP7Cpmgx?=
 =?us-ascii?Q?Lqj/eOSDmg8H2Tb7UkbcbHe+Wgc0Td6Qgbq6eQDcLFDkmrlEKTxi8pmupOJc?=
 =?us-ascii?Q?PaMmq6W8xxH32W02X3AN8/ilGYVzz+ZvpaJj6rabbJuIDnkQBeO9ok4I+c0h?=
 =?us-ascii?Q?R8xPsDYztSgW+CzwpD4jGlodQ1tdzXOQOfejmnjJ46rWPU3CFCdr/AborWf7?=
 =?us-ascii?Q?G/Ac+v/9MuEtuxYVTu1/gNfRRi5Zl0VNTfQPErUG7m6WiszuH0D8Mm/n7O/g?=
 =?us-ascii?Q?WmcOq7fd+f30L2aRNK6HQhdIjlCu7uo5ZSJOIr0HC0qZ9UKaApRZ1b/23eyL?=
 =?us-ascii?Q?pt9+wWl/MSRVjXSI24DSVMe6ctGxIMoF4DgSjfR/CKUxwsD5qq06w1/4MElS?=
 =?us-ascii?Q?fYaH86NLmJ2uZntzNomUAtMlcOASmWXgjig6T6Jy4lqQyZpcJu49kjWCbg4H?=
 =?us-ascii?Q?dfhqFr0BsKEVupRHQrh5kkXBrSezMNb5VFR/Oi6qrkM9Ll/Lph+j3xkYPuUT?=
 =?us-ascii?Q?ADnzOANp0Z2kB94RaqV0sLmbjpz6yPUSqtdRYsWw9T0ixabFHnbDKFDdvwYk?=
 =?us-ascii?Q?CCVbARkp2hVy9uCpcVUFcD8pFYtOPstLU6DML8ga212+jXB6dt9gwUuJGzph?=
 =?us-ascii?Q?qgK6q7bMIXOr9BWWhLYfiwYzJi/QuCdSKzBJfwXw5lQDVM9iXHdSR81KzJMT?=
 =?us-ascii?Q?GUA18VnHfPyuElZPUx7BqZTRlqgSb7o2/93U6PKyJXgYPvwFTYDmuaR2WbJl?=
 =?us-ascii?Q?hlVh5YQdWu0Nj4/UFN/d/Afpp/xv4lAU344j7B7dqANcAe6WJpIg03QSwFHD?=
 =?us-ascii?Q?VmqY0XBOaieXXyedU5qlQlwKClOpZCB8q8uSKKE6j5PRf+2i3/LkOlV1CZ+l?=
 =?us-ascii?Q?Ntd3nFZ7zC2r0LK3xkIXBuGAT6JfHuQVZAzdEFtm2oqrP6MaM3BxWO6X4cHt?=
 =?us-ascii?Q?gMNQf9dcYHUPjwsTO9EUV9CzN4ISZLH33N7QH/wTqa+bn4fJauxd4/ADicHS?=
 =?us-ascii?Q?xXZoGKeY3jp06OdYYlstf+0hhClzd79hktih04mfvsNhfTboSRSVcL0XBdoR?=
 =?us-ascii?Q?JKagte/6+o1F/6loZ1UAUfgXZwVHVnmuPmzijqKXkW+/WKOgzITkUUMGZQef?=
 =?us-ascii?Q?ow7MpcyT8bAoIGfKy9dozoRxGM9eQZMam6Z64zeuEnwDiqea++n8dBPFEKvZ?=
 =?us-ascii?Q?z/3TlKFT0GU6pptPPGgBESQBcHhk5GmxzJ3bMoY8vzsyeBpN1h+MBjvCAkaI?=
 =?us-ascii?Q?P8sjVJ+uvQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 100d1323-ad10-4135-575d-08de930c0f99
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 12:08:34.3653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPEVH4XFh7a2+EydkIrwKHwDx7wKRmFa22GySDk+PaF/7nEZPnakwKQ9Pix+txFKDtbObSweFLpUPa57fRuYaxLA8y2fj2U8njgQYlAu/qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB15842


Hi,
=20
> Hi Marc,
>=20
> On Wed, Apr 01, 2026 at 06:00:17PM +0100, Marc Zyngier wrote:
> > As we are missing ID_AA64PFR2_EL1.GCIE from the kernel feature set,
> > userspace cannot write ID_AA64PFR2_EL1 with GCIE set, even if we are
> > on a GICv5 host.
> >=20
> > Add the required field description.
> >=20
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kernel/cpufeature.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index 32c2dbcc0c641..5bca6e064ca72 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -327,6 +327,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr2[=
] =3D {
> >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_E=
L1_FPMR_SHIFT, 4, 0),
> >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR=
2_EL1_MTEFAR_SHIFT, 4, ID_AA64PFR2_EL1_MTEFAR_NI),
> >  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR=
2_EL1_MTESTOREONLY_SHIFT, 4, ID_AA64PFR2_EL1_MTESTOREONLY_NI),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL=
1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
> >  	ARM64_FTR_END,
> >  };
> > =20
> > --=20
> > 2.47.3
> >=20
>=20
> After this change in -next as commit 899ff451fcee ("KVM: arm64:
> Advertise ID_AA64PFR2_EL1.GCIE"), I am seeing a warning on boot in my
> simple QEMU boot tests.
>=20
>   $ make -skj"$(nproc)" ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux- mrpro=
per virtconfig Image.gz
>=20
>   $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/down=
load/20241120-044434/arm64-rootfs.cpio.zst | zstd -d >rootfs.cpio
>=20
>   $ qemu-system-aarch64 \
>       -display none \
>       -nodefaults \
>       -machine virt,gic-version=3Dmax \
>       -append 'console=3DttyAMA0 earlycon' \
>       -kernel arch/arm64/boot/Image.gz \
>       -initrd rootfs.cpio \
>       -cpu host \
>       -enable-kvm \
>       -m 1G \
>       -smp 8 \
>       -serial mon:stdio
>   [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x413fd0c1]
>   [    0.000000] Linux version 7.0.0-rc4-00058-g899ff451fcee (nathan@aadp=
) (aarch64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEM=
PT Sat Apr  4 06:55:05 MST 2026
>   ...
>   [    0.000000] ------------[ cut here ]------------
>   [    0.000000] SYS_ID_AA64PFR2_EL1 has feature overlap at shift 12
>   [    0.000000] WARNING: arch/arm64/kernel/cpufeature.c:986 at init_cpu_=
features+0xbc/0x344, CPU#0: swapper/0
>   [    0.000000] Modules linked in:
>   [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.0.0-rc4=
-00058-g899ff451fcee #1 PREEMPT
>   [    0.000000] Hardware name: linux,dummy-virt (DT)
>   [    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
>   [    0.000000] pc : init_cpu_features+0xbc/0x344
>   [    0.000000] lr : init_cpu_features+0xbc/0x344
>   [    0.000000] sp : ffffcd0982373db0
>   [    0.000000] x29: ffffcd0982373db0 x28: 0000000000000010 x27: ffffcd0=
981c63878
>   [    0.000000] x26: 0000000000000018 x25: ffffcd0982013f38 x24: ffffcd0=
981c69068
>   [    0.000000] x23: ffffcd0981c635f0 x22: ffffcd0982388640 x21: 0000000=
000000003
>   [    0.000000] x20: 0000000000000017 x19: ffffcd09824c9308 x18: 0000000=
00000000a
>   [    0.000000] x17: 5d305b203837205d x16: 305b203737205d30 x15: 0000000=
000000000
>   [    0.000000] x14: 0000000000000000 x13: 3231207466696873 x12: 2074612=
070616c72
>   [    0.000000] x11: 0000000000000058 x10: 0000000000000018 x9 : ffffcd0=
982396598
>   [    0.000000] x8 : 0000000000057fa8 x7 : 000000000000002a x6 : ffffcd0=
9823ee598
>   [    0.000000] x5 : ffffcd09823ee598 x4 : 0000000000000000 x3 : 0000000=
000000000
>   [    0.000000] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffcd0=
9823852c0
>   [    0.000000] Call trace:
>   [    0.000000]  init_cpu_features+0xbc/0x344 (P)
>   [    0.000000]  cpuinfo_store_boot_cpu+0x48/0x54
>   [    0.000000]  smp_prepare_boot_cpu+0x28/0x38
>   [    0.000000]  start_kernel+0x248/0x780
>   [    0.000000]  __primary_switched+0x88/0x90
>   [    0.000000] ---[ end trace 0000000000000000 ]---
>   ...
>   ```
>=20
> Is this expected? I assume not, hence the report. If there is any
> information I can provide or patches I can test, I am more than happy to
> do so.

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.=
c
index 5bca6e064ca72..1bfaa96881dab 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -325,9 +325,9 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] =
=3D {
=20
 static const struct arm64_ftr_bits ftr_id_aa64pfr2[] =3D {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_F=
PMR_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_GC=
IE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL=
1_MTEFAR_SHIFT, 4, ID_AA64PFR2_EL1_MTEFAR_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL=
1_MTESTOREONLY_SHIFT, 4, ID_AA64PFR2_EL1_MTESTOREONLY_NI),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_GC=
IE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
 	ARM64_FTR_END,
 };

The below next-20260403 warning on RZ/G3L SMARC EVK is fixed by the above c=
ode.=20

[    0.000000] Call trace:
[    0.000000]  init_cpu_features+0xb8/0x2fc (P)
[    0.000000]  cpuinfo_store_boot_cpu+0x48/0x54
[    0.000000]  smp_prepare_boot_cpu+0x24/0x30
[    0.000000]  start_kernel+0x230/0x6a4
[    0.000000]  __primary_switched+0x88/0x90


Cheers,
Biju
