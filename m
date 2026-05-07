Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073D238BF6A
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778144319; cv=fail; b=Er2NtrtfCP+GrUNv8ix2AKfSatnMdGTA/T6B9FjVPP1YHHgj4g5NIncag+D2fdzQcQHWlYaKaqMkCM0q25EyzV20Fpzy6uByAuZN5FMEkP0Kavqid3T7L6IC8FhSeYFLFxfCGRp2DsUztfzaBOESi1xjsGrGT4m985KIaANp6B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778144319; c=relaxed/simple;
	bh=TVfxsmjMrtQOHHOpMS0I7R2PvkrNUfKVzG9r4CMAad0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oBI0cBcwXQiim7FGMlDgCOEmBObgXoA63K9VHPf99DgLxx+bwu//Oqx8YCE14YHiVOW/v6f/hqwVhZV/623Q6zVjoobhQz/bnDYgiXXXUAcAizFbU4AAZous4bgz6Y0vuDfNGr2FhrKdgvTaoqXvgaGk9AKY/TdrfMp061weHDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kU8dUvZC; arc=fail smtp.client-ip=40.93.198.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kU8dUvZC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFvIBufYIG2Xthz3bClhIIaFJRZtjAqvqrA6avxiw/FuSBr8Pn5B4e5NsKaZufd5v5sMCwFgc2niochDMS5g2WVQtTh+GQb0kMD15TVpDkO6MzVlDF2MGpwumXmU7SXmYI2U3lgzoF755ZlPFMRHsr3WO3JbH0dC5sqYNMkyU+p0RulkiFPYRrtUiH3I+GBIsxIqVW6huqBvyxvMh8qJ9HNc7x8KYhs2nC/UNDZvODsWjYSyxCcTGCn3sxpzJJJ8aoftlygIai7bNFkdm7dfsWlUGigXmx1S6NR/HcbSQiJWzyhB3oaywlSVbaa/FgIyKJvxBiqZLe/vzPa1VeKhWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lH61pDQFPJR2pG9h6b9tMI0EYYwZnuhPqzzLiqUm1hA=;
 b=HSTRPMRG8qVpfxa2hELbGCeKvZb3O/xVeLZHiRVUORBw7t9vAQRiXow29TgGntcehjle5WScZQJPjSj7/WGZnPPL4O/b67A0cr4Ovq1cSR6wQle7HHth+Uiz8VrmSnfa7+txKIluA5f0EXDLdcjyHe0j48WsgDPshtixel9LaOXwMI2y2Hxr+U9gjbtNwn1VCxuukJpGIhFKEPYoX9VQAJt82cviFlYMDPrdChRrpkjogmOfhD+Ep/ST7kTOFEuU6sn2bVQUyg20DlqPCrijfsctVLSy2badUebEX30wqOoFKDYBV2Sz+Vn5xr2tqS/U15YFgALBqfSK5TBwb7PRaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lH61pDQFPJR2pG9h6b9tMI0EYYwZnuhPqzzLiqUm1hA=;
 b=kU8dUvZC6Uno+rp3rzTDrKFzx0PaoHbPmQfsEWaTleX3fPnTgXCEqckBGS2ZeunnYjAb/z/K6qCtV8WpAJFXmxQ8bFOOH3akOOV4g10cuSbqJw4pFq7HcoXFyb3Wf7aJ9HvQQ4j6l/HQagT7jx/dYQZR/14gXQTT8rpiORERydeEsP3uPEdE7RXMbcP+mzD6tWVP9eJkuvFoHThDRoX4LvR817mkRpuxyKu7CT/IZniGxfNZBluByyO0NVfH9tM3OtFfvOVdDtshgBV+vlfO9a2Y0qJvRnON04TrIxA5uOwHbf6vDOHKMhDEPY1kf9ibLia18l1+T/TJCCaUSu4MtA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by IA0PPF316EEACD8.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 7 May
 2026 08:58:26 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 08:58:26 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"sebott@redhat.com" <sebott@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"armbru@redhat.com" <armbru@redhat.com>, "berrange@redhat.com"
	<berrange@redhat.com>, "abologna@redhat.com" <abologna@redhat.com>,
	"jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: RE: [PATCH v4 04/17] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [PATCH v4 04/17] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHc2s+MiFtk51uQsEegmd8nk0SKf7YCRxvQ
Date: Thu, 7 May 2026 08:58:26 +0000
Message-ID:
 <CH3PR12MB7548456E92BB5137C5B5846FAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-5-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-5-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|IA0PPF316EEACD8:EE_
x-ms-office365-filtering-correlation-id: d7f905d4-9863-4523-c2aa-08deac16ccf6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003|921020|38070700021;
x-microsoft-antispam-message-info:
 6B03lMoYq4/10hnK0KBk6eHWHpwqzLLPehOdrH7HDPSrvmWv7AZwrT6mN413OaxLuyBZf6KwhtnrcqBstQP33p8bv68LrAU0IwMZLWRnBFnIlpH0fbIFRyjNkd7QrfXhwlDsx/nTIHXIlFvmbaqY4gzdykr3OYdFrFGjDOTITT/RzXp0Cb7ddHrrbgZcm7BarRiS3h6dxwkBFItS1aNkq4fnAHuBP/e9I9eiY207IqQHbj5gJjfS2Mu6N4Xb5TVRPotR+01JH3gY6AwQqBluiiLT1yprCEs55mE8chzqIA2XjKv/joGgM70eQ0nGz/shfwcjpLFp8YjM3FxJoGUO6N7rEsOPGIE+gwXgf+p4Nm6jwOp2rEOt9GvDw/6N84qLhxvjaRv/j9h7IXFCvXOiWEEsB4nfeuTYNqc03kqoHxHg6warLWrN03jLlxGnKSA5c/Fg7McV/PHcibTPkEwzqaQ2MG1Uz84pCT6rGfvCoiILyHiZS+BANT3oNZ99OBjHIuo9RAbQ1azP+mi1nUkZqnb8UUjHUzl9OdJ/z5q4XoHP23k88iw+fs3mp6WWjonAOZlEU3mlfTH6apHiXF43WJYiRwQk89hH2lV/QPmh1pjU9zt3Oo+caDOJj2UHWwu5XUCjeJMnkSaFQSTj74bknk26TdgRv3Iu5MR216It7Wskts/zSc8v4sMw1ycGa39n1ylVo82rhoIemnhbQXzqiSqZA6omN2km/Vy8qUpHAEeXVF4rQsVhCX/T4IHv39QNhZ8TptnzOkqKXPDJ5927lA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fpQz5qnQfwXbFHDezwFXXb1KM1yLp8t3Nr5wpgW+N0IrXZ91dMW0NQl47s+x?=
 =?us-ascii?Q?nNHaNyZ+oBemzyuxITcamGtYjqmYwcHVcIF+E1NwW3EmJwtUXIJXtFkIflg9?=
 =?us-ascii?Q?/1cSEb4Ub4aZ3PyoMZnSA2dpqUFA3CuCc41pyG+2VFba2U6C4WWtQuD3wxPl?=
 =?us-ascii?Q?isZikTYXgRosBrfOWEMxYlRzK0s4fYkGfS57+Ma/W63a8084EIvCXd4zA8X9?=
 =?us-ascii?Q?b3nIMT3waUIBnX42Yhw8wy2XQqEln9zqOfD+fQecJ+BGIA0+5bp5T2pj5TOK?=
 =?us-ascii?Q?QSMA/mkoQ9jtpuu7cYycKz27LMlRbVA6T2IMjnPj76VmEJzeZIazpdjk0VUK?=
 =?us-ascii?Q?ApEoPpYYyiuCCP8GcA6BEtrEiKFtn5U4qSt+ykwon/mxBzyreIRi2lPpQXKb?=
 =?us-ascii?Q?ZkIAlt43DP4mbgcprUR2WvQRohc+zd+uSZCcjyqxMB3m3/y0dBLnm4Tp1s4B?=
 =?us-ascii?Q?qUu4w2S+n34o3WjiD2RuSulxDmu7+vxg0sZ5zaeqHVVrSY/uJTy8d/OE4XJo?=
 =?us-ascii?Q?PM+Gmv12VXWmgOxEIron5BsJxTY63zY1pHs4vvTp0RBGFw+6bHdtkogyed33?=
 =?us-ascii?Q?fp2z8PmyDHzJ/JblYsblrnbqGXNAGZlrx8Ct9rFYxnRfyD1OQe6/dhfr/NoC?=
 =?us-ascii?Q?vhcr+skn/HsZd4On0w32C90aDcIuVpSSrSn9BEQpEBlIYO98rJ9GNetIBBLw?=
 =?us-ascii?Q?5uvEtGIIu+mEPtn8EwulyN1GXsBor3QZ1zxPI2HDbe/JGs4tTonWXnDGppZc?=
 =?us-ascii?Q?HSaEptX7wwrda+9szarhi0xLeUJ+GoHWxvXCjumoIVLbGsKWXj0lF9BDpzLP?=
 =?us-ascii?Q?OSxGZpcD2S2ayjQKNywIy1+4/AgDD+gdZg6GN6gZfVXwYNpEzSC+y0B5vy8f?=
 =?us-ascii?Q?mR0Wo/Q2txPUUH0wyChEI0k+kTHec5DYy8inwbMyVyrwGice2VLxfNQ+Vf5o?=
 =?us-ascii?Q?vnrfvxHWkW4+riksUNjkZVbrFUY15P+iC0xVzO2fXmLmmCHC9RYyJkm4Rjq2?=
 =?us-ascii?Q?hNHX6JXX5pEHweSe9HnPb7QEasUy9zk1E6g7Ku8CpxME9smbNdV49WhVNZvY?=
 =?us-ascii?Q?d6c+RGA/MWXERhF56GkUmVm+i9Utqa8O/8Rq9mIMYeRLmqrbL27mu70DuHbP?=
 =?us-ascii?Q?abEc7AsAx5amNeTSEtWOpjCG1EpM7NDJ14yCQEYt7FOhtr8kIeVw2BLEVux6?=
 =?us-ascii?Q?f6VsD/OgB9DnpdJ5O6MNVdSotPorO4hdU63bJgURK2szvXKE1ZPC56TBqauO?=
 =?us-ascii?Q?l7fLM75Y+dsBoXPy7zItnJ8jGYl9aM6H+rPUtaxezAKvFjnD+/1FAGyvEOuh?=
 =?us-ascii?Q?hSW1SEJj5pQgxxQdQbxVmIcZnjW0wmR+lW3VeNhxTmxpetJa76hewdwiQ5Ff?=
 =?us-ascii?Q?0lKXmcsbKF/5B3hSiab4nsgnonsTmK+fPa4rQG8cAOOn7P2GC4yxqMKI9tsF?=
 =?us-ascii?Q?TqwX79d0ZpfiH8vFbM2GsYJLKcz8Ky8CEUCBWOSCUaU41dBYdEWZRBr/h0yY?=
 =?us-ascii?Q?PhwZYO4Upe9UnHhrY8h0+RddTD7/435KI5A39GZEwo5m75oPG7phPL9xhMc/?=
 =?us-ascii?Q?WGcJGKCLs95LO9R446kX8WU3H3ZAikhF6NOcGqnxEqeP8hm3IPN3N7PVxQxU?=
 =?us-ascii?Q?9wSKCjJLyFZLJkbpn45xc5ffv+8kcfvOopflyV0mOLE1xRGgTjAccjorD/tA?=
 =?us-ascii?Q?zTLSbGKXEynijzp9mjNTkHdIlzFvEHCSuX2UESTZrZ5K31GGg0+OMW9vWam9?=
 =?us-ascii?Q?efgINC9kIA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f905d4-9863-4523-c2aa-08deac16ccf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 08:58:26.1147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jsj4sEdN3UxGwQpdY5ONeLhoq0t22JCPuO5YmQ9GuR57TTKr290qrdEtZMQGlVh64TOhvPFMIyo6bXjkBkydwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF316EEACD8



> -----Original Message-----
> From: Eric Auger <eric.auger@redhat.com>
> Sent: 03 May 2026 08:33
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; richard.henderson@linaro.org;
> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
> <skolothumtho@nvidia.com>; philmd@linaro.org
> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
> jdenemar@redhat.com
> Subject: [PATCH v4 04/17] arm/cpu: Add infra to handle generated ID regis=
ter
> definitions
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> The known ID regs are populated in a new initialization function
> named initialize_cpu_sysreg_properties(). That code will be
> automatically generated from AARCHMRS Registers.json. For the
> time being let's just describe a single id reg, CTR_EL0. In this
> description we only care about non RES/RAZ fields, ie. named fields.
>=20
> The registers are populated in an array indexed by ARMIDRegisterIdx
> and their fields are added in a sorted list.
>=20
> [CH: adapted to reworked register storage]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-idregs.h            | 59 ++++++++++++++++++++++++++++++
>  target/arm/cpu-sysreg-properties.c | 30 +++++++++++++++
>  target/arm/cpu64.c                 |  3 ++
>  target/arm/meson.build             |  3 +-
>  4 files changed, 94 insertions(+), 1 deletion(-)
>  create mode 100644 target/arm/cpu-idregs.h
>  create mode 100644 target/arm/cpu-sysreg-properties.c
>=20
> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
> new file mode 100644
> index 0000000000..4a9034594d
> --- /dev/null
> +++ b/target/arm/cpu-idregs.h
> @@ -0,0 +1,59 @@
> +/*
> + * handle ID registers and their fields
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +#ifndef ARM_CPU_CUSTOM_H
> +#define ARM_CPU_CUSTOM_H

ARM_CPU_IDREGS_H ?

> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "cpu.h"
> +#include "cpu-sysregs.h"
> +
> +typedef struct ARM64SysRegField {
> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
> +    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
> +    int lower; /* lowest bit number of the field in the register */
> +    int upper; /* highest bit number */
> +} ARM64SysRegField;
> +
> +typedef struct ARM64SysReg {
> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
> +    ARMSysRegs sysreg;
> +    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
> +    GList *fields; /* list of named fields, excluding RES* */
> +} ARM64SysReg;
> +
> +void initialize_cpu_sysreg_properties(void);
> +
> +/*
> + * List of exposed ID regs (automatically populated from AARCHMRS
> Registers.json)
> + */
> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
> +
> +/* Allocate a new field and insert it at the head of the @reg list */

It says insert at the head...

> +static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char
> *name,
> +                                     uint8_t min, uint8_t max) {
> +
> +     ARM64SysRegField *field =3D g_new0(ARM64SysRegField, 1);
> +
> +     field->name =3D name;
> +     field->lower =3D min;
> +     field->upper =3D max;
> +     field->index =3D reg->index;
> +
> +     reg->fields =3D g_list_append(reg->fields, field);

But this is adding to the tail, right?

> +     return reg->fields;

Don't think the return is used anywhere.

Thanks,
Shameer

> +}
> +
> +static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
> +{
> +        ARM64SysReg *reg =3D &arm64_id_regs[index];
> +
> +        reg->index =3D index;
> +        reg->sysreg =3D id_register_sysreg[index];
> +        return reg;
> +}
> +
> +#endif
> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-
> properties.c
> new file mode 100644
> index 0000000000..5cc06c8f24
> --- /dev/null
> +++ b/target/arm/cpu-sysreg-properties.c
> @@ -0,0 +1,30 @@
> +/*
> + * QEMU ARM CPU SYSREG PROPERTIES
> + * will be automatically generated
> + *
> + * Copyright (c) Red Hat, Inc. 2026
> + *
> + */
> +
> + /* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#include "cpu-idregs.h"
> +
> +ARM64SysReg arm64_id_regs[NUM_ID_IDX];
> +
> +void initialize_cpu_sysreg_properties(void)
> +{
> +    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
> +    /* CTR_EL0 */
> +    ARM64SysReg *CTR_EL0 =3D arm64_sysreg_get(CTR_EL0_IDX);
> +    CTR_EL0->name =3D "CTR_EL0";
> +    arm64_sysreg_add_field(CTR_EL0, "TminLine", 32, 37);
> +    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
> +    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
> +    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
> +    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
> +    arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
> +    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
> +    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
> +}
> +
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index a93ad2da5a..b940842d9e 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -37,6 +37,7 @@
>  #include "hw/core/qdev-properties.h"
>  #include "internals.h"
>  #include "cpu-features.h"
> +#include "cpu-idregs.h"
>=20
>  /* convert between <register>_IDX and SYS_<register> */
>  #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
> @@ -906,6 +907,8 @@ static void aarch64_cpu_register_types(void)
>  {
>      size_t i;
>=20
> +    initialize_cpu_sysreg_properties();
> +
>      for (i =3D 0; i < ARRAY_SIZE(aarch64_cpus); ++i) {
>          arm_cpu_register(&aarch64_cpus[i]);
>      }
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index 192ac7c31e..e2f740e48f 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -9,7 +9,8 @@ arm_user_ss.add(files('gdbstub.c'))
>=20
>  arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
>    'cpu64.c',
> -  'gdbstub64.c'
> +  'gdbstub64.c',
> +  'cpu-sysreg-properties.c',
>  ))
>=20
>  arm_common_ss.add(files(
> --
> 2.53.0

