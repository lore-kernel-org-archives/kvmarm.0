Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A582D9EC4
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778143551; cv=fail; b=Dic0vgrXoFSmv1/g16keC9AEag9vTUEZKT4+fdRhrtp4b9N1DRMXDRakiJvhSxzPI/U1tuoXkDKZhA0V1mL+9vjMKv4stNMrgpmJ2OchcZiwh9/KZ/1ASa7A0fNN68VRUmC0SvLEk8y6qagcQDetAbay5TnyVXFS6ODDByGOHo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778143551; c=relaxed/simple;
	bh=uO6snAbPLReUUGsNyeIHlqIzgTSyeHeeCcXsK6LN5D8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KKu4BbVDSJMhf5pHYugwcu8Gtm5PYP7XBo+EGTyjuMVQ8uZOAIdWWL8Mudo032hkgTbhEzz4jLz302bz+ZPXUOLXzcf61a6iVvFZxnO3losUT5VT0fudSnt/NO33kZ6cQ6UhFNCNe8cEl2zy2IpuRNIQuUzjNjTiNc3Lu4k3vGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Aw/m/02T; arc=fail smtp.client-ip=52.101.62.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Aw/m/02T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwz1mzHGE1OoPsjS2SUMKP70onGDUw/EySoidSGBWLdRpXRflP1TW0tba+2gZ4UeWpOUcTXq7M+El9tVPA3eqbn24ovniZTWDjHtI6Xy73POnO2g+9NKmJ+Qha9fLpy/pUPkVRcmu7EBazRzroOntEkuqZS8r0K5o7LuvTYNyxWz2lDehRWo7P9szs4z0Y83DJFDYYhtaEli7gs3OBk8qLvOUfdLdPbBJfLm/0Udk+XvvkqOC6Ex+KnlopNcXqokcbmPUjd1/J2HKET5OMdYebECuj1BgTzSun206YuNfz+tlO/PVOSF0MtaFtZObdupXWY9qhdmGkW2XsN5Ztp2Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C65F4yEOBpTzTS2xE5EtGl3GpKchtCQzsPCq98pyfUc=;
 b=fd6wD0NzD2QbLdNulHgTvhpcDIa0lSEosjmQdS4RdDFXGkWu39eZlsOKWua9XpvLFD6mFF9Z/5zIUx+61CVWq5AOAL/4qfdEKKAKclRnoT9Bdt/zVbP/kQM4lmBQXrZszk9LyAencqUZcAP4mJUFDyB+mXfP1N+20RiXulnwVMYk1882BqVxgJXIz9A3znhWE51FW4XpOjK/mmpYWU4tkJiUtYOO0S5xzQVypb+GtFRKXPP3ubJlDK53LZniMpEHccIdNToC+Ca0G8lJCR2LSxS+xM1RNkqu3DG14KSo9t5wLQ1py6fit7nPt6GepuyEAO2aiZIVywU1+Rs/N/BqfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C65F4yEOBpTzTS2xE5EtGl3GpKchtCQzsPCq98pyfUc=;
 b=Aw/m/02T50ZXeSccyy/G2Z4Tq+57DEh/MY46k7SEPVwqir0LA/zNGKOE1IMMEf06gKXVVOrxCb0mz3hVThBA2JKiXk6a4d9g3hxrkGEpp9LjN7JDMk0lPl+KC06IPDorsCBUDnhxzDkS0S1p5L1khHPaaLKoHiD1Lc1RxrSbEi4VOn66XYUlQvXFR9+GMYVJdo6JqdbNHTSuGcWX8fMk3qpeWV2qaSHcxqJfQhMV4xlSOe9Z8OXPXMOsc/jWgvoX9Z9I0X3VLuykYGOYPkGNcODIT3Y1/QYNDVkCjQG0tOxGj0uSkv53QE5QtKhZyinD4oByBUJ19XJKys2FwdpdFg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SA1PR12MB6749.namprd12.prod.outlook.com (2603:10b6:806:255::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 08:45:39 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 08:45:38 +0000
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
Subject: RE: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
Thread-Topic: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
Thread-Index: AQHc2s+ISBxURh23/U6mjL5mBISdArYCRMOQ
Date: Thu, 7 May 2026 08:45:38 +0000
Message-ID:
 <CH3PR12MB7548C2AB4989FEF96C247D47AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-4-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-4-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SA1PR12MB6749:EE_
x-ms-office365-filtering-correlation-id: e26d35c4-26e8-453b-ad95-08deac150391
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|38070700021|22082099003|921020|18002099003;
x-microsoft-antispam-message-info:
 GH0as6MrgV9Nm7cw7ZUJn6LQDXyXM/kVnnpoHMnRGLq9S7U0CBWAsXXJbSCByUTsW5wEoxZW5Cvs1p7MdaseoH3lLVU5AMXRfI9J9VtHk3WMBGxLgR2g9YJbmdgEXauC5/pndpApq/VNQW/n2Pbmy5lnTRfm+uSJFwgTEUe9tYATIeSh90TX29c5eh6stl4W32ElECBehbcFKqCDc99YvO9PN3827UpBEZqMrf5DR3/lW4GWv6YKF3J+bkBeP6t5reGM+Vyvso/uSPYqxGTX7uNs8JgbeZ4UhtXfOiCTROWMRYLoG3WwvxjWz/BcbvxnawwvRa8nG2chcP5gCOhLDe2AiZRd1AGPWn5W7LNGc1LBAvRt52zm6GY6/hHTKz4TRSai5z+56PCEFKgiY6ovd0f9cyuYWAj0toLWI3AeHJ62eiTwgClDQyybguNA/sZIdNaGMN7R5ZdLsoclqeLofojq2Mw8079w4504kO/0mvObupPEfu2HFZXa8oc1HAqb7kkj1IRsYJ5GtdOr9wAJtOQ0YND95Nf61/YJphOEFEzcIRD4VKaCb3XUeFuowsZIU7wpAZIlaaQGd++mQo4WFVcp68/3pk2rznPr82+oqJYsil3NoPbgCm9CmhEyzFZ7Cgcs0zrxqU2UEFHDsuBN8GV13zpndo6nfjSNR7XIGgjeW2oshXQ06xwf7/R5Bq9BVBvSVn7c0NneoMbBBn4U9Wv374zebIlLiq4Sqs6e/6zeLDw1RBZjxeOngjn/W/0PAZsVkRVtItW+GS6W1Fw26g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(38070700021)(22082099003)(921020)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?d+a8XPIG2fkL2akgiy94bzLVL001hUwKW3F6e32QYDXx8TXUp0kbbRzXLFsA?=
 =?us-ascii?Q?8VI6gP7k3raoJ1uoWA8hcwpVc34e5k14jTn4d7XfcbHGvsfRrBtFZl7l03Pm?=
 =?us-ascii?Q?Ao8uTdl7JEd69riZU+fxXCUTTt+GZPBlLihvLLJnRmoetJ/nR5ylRQKNDnNU?=
 =?us-ascii?Q?6jsc3Yw40YrQ9mmwM00p6tV0/nDMqwPpcu8CajL620Z2P1gERxmpdhFczjua?=
 =?us-ascii?Q?6t7mGAUJYiniTFs+vzBDxR21mZJ/UfaO98fwXe47VPmCNwr58Wwb3IanVukf?=
 =?us-ascii?Q?X8BBGiW6kFAJGhYwP0FCAhjUOt5LxjD38yOle8l4xX6Pq8CGuW0Y+VaMQPQs?=
 =?us-ascii?Q?+hkFdzP12MrPCdKCU6mYVvLUvKdRIWIAOEMTuM0CPHiiIVVJJY4kqEunyEPb?=
 =?us-ascii?Q?QnUsrQoZu2NHF+IRH97p+pG+BZp2IpPtUmtMnt/e4MiF1W3c7mCk9vG/fNi5?=
 =?us-ascii?Q?h6IkqHBMxDxJVikMLg9k6lEoQlIvHxN7pMD1Y7qw2qGYN5NbseV4tOAANt2l?=
 =?us-ascii?Q?JEYWRmJbkwIr5Z33Z+EYCqXUbwXO2y3j+5EO2nBqDCGYEVpAxb3bvKsvnb32?=
 =?us-ascii?Q?neTRwIqB4pL5i0JrhlBs8z9EGt4onPT+eEGytFm8yXJ2MQVl5tPya4V/CR8b?=
 =?us-ascii?Q?Yz7Y3DOgv1Axy9uDgUiFo3Zo78NfShVUyX7Rq08FWoa2Pc6evnuq0P1GEuc9?=
 =?us-ascii?Q?zeqFfeUEoQMUydqoswau8OMgepqc648gP/1ka1wgt4mEKhAoQkUwjxfh8LDQ?=
 =?us-ascii?Q?NSwxn7aQvQ2qu0S6jWL5ekrKCn7LHyeIvSQIkJm+059nRgrR0HDWvyW7EJa1?=
 =?us-ascii?Q?yUYciVgODLW2MCs+QPryDGtsD/2fcQ1XDvUeFbh0/dSmtYfNOk57tBSXKWKM?=
 =?us-ascii?Q?A1GeesdWHupY7A1CP0C178PijNkCtimMuM0xaoeMIbxD7EXLW+WiJ7myEWf+?=
 =?us-ascii?Q?Rd1DbGlKR8vumWRQsPSY6IXlfwYJdF9KSY+FtQIUd2Xc2RhK1Jg4boSCaOPu?=
 =?us-ascii?Q?gMh+0Ap/P9DOM7QJvNOrm4UsyUliDyFCXagD07Z2HbBRMd7nOoq3qAF9MkOR?=
 =?us-ascii?Q?wxNgYe1HS3PC/QY6yMrDfi/PLSFTS2U2TorV8ZkZhaK+nfSVIZAXjmPL+lgu?=
 =?us-ascii?Q?yA1eX1RzmOnqYiz8mAlAhvonSESFkwaclS81osK5kgu3MdLLtx1TPDJYUiNN?=
 =?us-ascii?Q?ZRNX3IQHS9Ef13hqP71nAXv7HLUrlI09v/bLKoZQ2jwFv+rCS0hcCH6KDydz?=
 =?us-ascii?Q?2uv4qxbKfooTfXMcoCEc16TkwMmHvYOtIvh1mz9SAEYt7oYt1NZUSJjWUGfT?=
 =?us-ascii?Q?Bruz7jC3RKeKmsYuk5Yw/U500DuRTyJ9WP7NTcVm0fX88Eusj0vV+FmMqQdp?=
 =?us-ascii?Q?TfPLNtwGmctsbbZz3t0wRJ65sMB/EH0gwfCarxVjpEUoF7CG9RzVKzm0Sh1m?=
 =?us-ascii?Q?csspWuQlKJDdqlVXk3Krln8QRj/cK5RnZqm6w+jm9J72h0fGxYaZ1DU1jwiH?=
 =?us-ascii?Q?U7L4guyacQBI/qoGd80jlQ9eergRceV0JoFldfkYd5P2Zb97Z6EMs4P6I07i?=
 =?us-ascii?Q?wruoNqTCxfyi1kEGFDy9/JuydQ+DwX6g1CrhMFaOhsZ37bW4NCFvmNktRfat?=
 =?us-ascii?Q?zEyAWOpIQjTz9HWZ4AnEagUG2aQmX4WAQB+I7IOQpgocDHUKpsxKApzZCVh6?=
 =?us-ascii?Q?DqbJ+2V6IcefgwGBnHkqp7Y/p9Exn7iN8Z/GwHTDlhu3nC08Rs6v8byEqnTo?=
 =?us-ascii?Q?4AHywRbxVA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e26d35c4-26e8-453b-ad95-08deac150391
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 08:45:38.7295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJ7Qvv52MzrBI4c2bgmOckX2aD3Wa6FuB5GZSOOEJvRI9PSxo+EKiyJT5Xx2JFzQunooLwE2kmgwkeiJ4jJP1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6749



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
> Subject: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
> automatic generation
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
> based on "AARCHMRS containing the JSON files for Arm A-profile
> architecture (2026-03)" Registers.json file.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> Message-ID: <20251208163751.611186-4-eric.auger@redhat.com>
> ---
>  target/arm/cpu-sysregs.h.inc | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
> index d61f0d0a19..2188cd7be0 100644
> --- a/target/arm/cpu-sysregs.h.inc
> +++ b/target/arm/cpu-sysregs.h.inc
> @@ -1,15 +1,25 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-
> header.py */
> +/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
> +
> +DEF(AIDR_EL1, 3, 1, 0, 0, 7)
> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
>  DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
>  DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>  DEF(CTR_EL0, 3, 3, 0, 0, 1)
>  DEF(DCZID_EL0, 3, 3, 0, 0, 7)
> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>  DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>  DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>  DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>  DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>  DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>  DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>  DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
>  DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
>  DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
>  DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
> @@ -39,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>  DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>  DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>  DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
> +DEF(MIDR_EL1, 3, 0, 0, 0, 0)
> +DEF(MPIDR_EL1, 3, 0, 0, 0, 5)

Do we need MPIDR_EL1 as well? Is this considered as a feature ID
register and is writable? I don't think so.

Thanks,
Shameer

>  DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>  DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>  DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
> +DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
> --
> 2.53.0

