Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37983BB665
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780324126; cv=fail; b=im18r/z3alKeibbCeJU9APM3OxlMtqbyYYcUiCikp0RxBAUDDHZRg2+0vxqTTH6uQrCW2FOA32pmuT69VCv3GgTJaZXxGf9ESnEpNE8PdrYsdBBbZt+XftIi8RTJ1szJhZm1qVCdTs/7eAT1Nhouoo70lqBkGja1OjFwcRrIaXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780324126; c=relaxed/simple;
	bh=Y6rKZO/9BxnSK9AwnYexvcQBUJwKWH01Jx68jta3CdQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T/xlFfR+anXOmljtuP9bNW1qTI2Qnn+gDLAGMPV0xW1JvKzb7wyfZZV/cV/35J5iO9furQzk/pwSKeuFbWbKPxNTOUdry6uC7JXOb7jDTbmdy24VKsyoVA4lfcqXfwtV45xnh3V/GMAb+dtaHHaCgOQgIs6dIW8w/4bmzvfeElQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kSGZMRs1; arc=fail smtp.client-ip=40.93.198.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kSGZMRs1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nW++FSqYftM9Nl3bZ5mqhNeilYAlAlz2fBCSB8LPY/G3KLN3+Y1k+wI4uukIvMX4aN6xyLidV/IScg1bQblxeTHZsWgv8qk/rJ3orMPUY6uJF5FfOFAKV7ArB0VOciussNK1GoMKlSNM+Fu6jRSnDtDVgRDTLdHLImW8PcHQZkwmqzVAKIYEGpr61B3DUCaAvdiYu48ZLm/c7+51h77xw7tkSIH9u0VscBOHY7wTqVQKvO7u8OWL/y/iVgAMSmauyXT7HmBdNi8shKLSd9UGy0bkfSRzJAd8Y0MhaEg5KW0yB0EMdiMqOjhTXxpPEXLYOe8XLqjLjZ7qQQdnzeXktw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5Krd50JWKm7Nv+W6yj0xxE4Uocap89M7V6IMlK31Xw=;
 b=qB09HrbbWti94rTUV6SSvbu5Rb5SC6jjGF/ZxVs284ioQCYf6enGkT2s3jlhdW6XY21tvGKKH+Ful72pjtMiJBlPp7GhuLqaBXJOwXx+bgBL5N7l8zpoUR6hKk72XIfvhZVo9UU7xYzCcicI6R7Gnbx32nBS07/0PeQYxoR+rPcyNUlqUM28+4lpF7kEFkPyKC7OlecwrhaWd1xqsnU7CpdcUC7//Fb4vMfeEyCklrYTjHpi/D1F64b7vOQ+8fI7IDhJdxGFrq7GKvf73rbmrX+l3kaORGwHdWLfBYy32d4i6KiEqlfFgbjGrFsRJxok+pS4zd2FcxYXgFkuYj9NfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Krd50JWKm7Nv+W6yj0xxE4Uocap89M7V6IMlK31Xw=;
 b=kSGZMRs1YOWovlZ8HRmlNgIOLuVluj/C9TCtkddY44w7SLZBuuXpUxKWtrcvPAZIm/imLV+4uEGY8Q9MEub7SSC4EmEND5LY4HC7qksRQA7laQ/zbFXyXI+Ni2z9svSa+Q8P08lfJVt0ZhAaPkBq/6H3mbDvjXXMd8o/wGu6PlXo8eWU6W8CTNMc9gnxuD/IIFZ6z3OzhR/bFOd8Sw7XaM2dyDEL0UNXfWUfIOhxmdRCcUejK5TxkTshBxDm2e2y40XmQ0v1G8Qy7/E3ilkk4vK4HVR4E2ZA8+y8D72gZbHGTKpSF8mDevYUlf0bEIJh1qGJiLuzWkSA15EcsTTqtg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SJ5PPF665EE4E73.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::996) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 14:28:34 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 14:28:34 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "shaju.abraham@nutanix.com"
	<shaju.abraham@nutanix.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"sebott@redhat.com" <sebott@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"armbru@redhat.com" <armbru@redhat.com>, "berrange@redhat.com"
	<berrange@redhat.com>, "abologna@redhat.com" <abologna@redhat.com>,
	"jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: RE: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHc55OUFNuVI6hQDUOq6Vpq6dU4HrYp1Uag
Date: Mon, 1 Jun 2026 14:28:34 +0000
Message-ID:
 <CH3PR12MB7548D1CA4348E04A14725645AB152@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-5-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-5-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SJ5PPF665EE4E73:EE_
x-ms-office365-filtering-correlation-id: 3fd20259-044d-4728-da72-08debfea1000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|38070700021|18002099003|22082099003|6133799003|56012099006|4143699003|11063799006;
x-microsoft-antispam-message-info:
 QzvUXYONa394rQn6o8tYpDUwQvIaxxlC6LHxyswlUpi3AnC7Qi9m6UZ3jN4rHjjw88ZD2pogK5Q+xFnVHETOj/YJxBldZS3UpCY5myWjnyuKbPyyq5rVJ1DtoqSvK5XjNlX0W8yeuhyhQwA0WUWyvYZmxEc4CFBcucFv9kj18tcfpS1vxtfr25KgVQMcMTb+9X5AdngTAueCNNueKt5KgE2nCo/2cTbVlmKDmavrk7yUU0Eoe2mFY6QYi/ebDxKJv07iXHMPLM9NTdFq6SwswP0X/6ZAVXChIcbLg2jDbL4aVu+gZUbzvBP3AG8JaR9bID258w2UVxywgaEuNkyRe543z7i+yuGQdDBRvLHbN8fRgyIY7lFjQ/9OVRELjrGXFLxz7nGJOGcBU+ndVzuNFM53v6k/V7qPWrg6SP0fK+4kthQKlmPvR1jJ6T3486ssLhHg+zFx2GbS3GYHSMcb/gmXgzkIaopXbiIY6FALfxdnZND0mS6PEcLsaGgtqZTTvOxX93WDWRZMqdc2BWjMyGGRNFEhVCChBEKWL4wsrX2+UVuAqNulxyZdj/J69cSuJga5fX3YQsyqqfqjeN3McDtwa355c0LlbcH2krRou3hMshY+zeA/0YX9Wqh3MoE/IV6ST6JGlROzh9xZi8/xn9YLf+I+la7nxqX3dh0D5CIOGiqiV9i//WtCz9vgEs3uIP6QSFrflFU1KqA+pDjhFxU+9/7+zNkZZWAqlT08BUdpehiTmPCarNg1fOLwk4zlS0QrZfVyw2xRkvAJGTopDQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(38070700021)(18002099003)(22082099003)(6133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Dam/c97DNxD5hOU/xoUwfF8ngAErnxopiU6Z52IwpzZnSB+iI2O455bahqig?=
 =?us-ascii?Q?uhcWsX7wPo4poxic53mbQLBeyYVw09vyAn2qT0trOspTx2mQoifk04m8+jjY?=
 =?us-ascii?Q?1gVQvEmTRilhSSclGFUaPdK0cTbgLhK01lYbIQ6FJ0b3nBvOoiORKeHYVap1?=
 =?us-ascii?Q?bCVG55MqpNywm2W17pRd8GFqOG2QowocDBrogfmwdsfMvDoXqke8z64ngB2O?=
 =?us-ascii?Q?n4xoUUwXf7f8722aQAj+CqrMR8060dtNUowJuEXXBGQI95VX7D1GnpzYeHfH?=
 =?us-ascii?Q?YjUMM8UmpugmxzZ9RS9SCpt4QAKRZon+w6pOcj6158cF/3OIOCeswHwPhX8E?=
 =?us-ascii?Q?teHG47xxd3tuVuIolZIzSGpYib3GechprLNaUSHMhgmn1bQbBAORhvYj2Hpn?=
 =?us-ascii?Q?IkpSX8HTkfnUzox1SkpHXwsZHkBvG/4pZAukrucBk3aJQGp/r8gHhMtL7cuf?=
 =?us-ascii?Q?lcqtIM1WJvR+4Iys1SXpv1OWGB9Cp1S5mTvOiHle+iBpTKLzJ/WAuvW3pgqm?=
 =?us-ascii?Q?JgmNGi+lEOkNdjVXj1AefJigIBLZewDy0sm5OxfEBkVLcgar1NypfvndAzTo?=
 =?us-ascii?Q?VsmUAks2c6t8PBHANH5zzAm8HKGPmMRUPeB9vqZKbVj9t8ewIFw+wwXeTK2s?=
 =?us-ascii?Q?HT4GsYUULH5PwtUqHtxBn8YXjXALukaBL/yQBGsL/G8bCsvgMvyB6zmM+ugD?=
 =?us-ascii?Q?z75czg41wL7+XriGbE192uHC+gjYClx0txUqhMWaLseXG6r5lxJrPBXkLRAN?=
 =?us-ascii?Q?KsLSNX8/GALBd8ZzmGH4kW8jxo67uXiY5Hy48UEYGdVWaf5lXuoQ0vSt8QLh?=
 =?us-ascii?Q?L4KB5thKuOGTrBZY2JLuc+42ay3Yy+x0hms0K8mvSWwqDELc2aLUNxbDHplY?=
 =?us-ascii?Q?O661pDn1uDZIjxYPAFQtpnCaGCcg9HpbD18KPKWOhB1yVAo3xXIUIdDHytQY?=
 =?us-ascii?Q?K+n5knbE22wbLA0zakNlkXZ4WW90AKSdA3nXy2MCrfPoHTcHhpisW2DVFjHa?=
 =?us-ascii?Q?Qqu9OuADhZzhiR/ZqrBdgtxXcnwSTOcCH4oK9Va1/3UlOhqucqzRCzgwebUS?=
 =?us-ascii?Q?7wbtV6T8DeqXLn+/S9FzhpQG8PzLY++C6/sUpEMPg0nztQ8FuT5bmqo19jqO?=
 =?us-ascii?Q?Z4uohAurO9E+OVAjcoIchzORISv+LRbSoENwfUzK+tTaZflEGaVpF+9Alx0v?=
 =?us-ascii?Q?rf6yDZOmwiUvmaCN6vwRd1jNfsBQiChHaJkZ2ZBrVrZQesioMhxcyLxqaf/Z?=
 =?us-ascii?Q?bkQzPI1RtpA3wo5SHHWRw9QMO2sImP4rbzBWENBASbHJc9nVna77Yfj/7Bzh?=
 =?us-ascii?Q?wag3yZi5zZtLJGiAJLsxL4c/VyTqd1NASklwi+G+9wAnyzJcrhKsjhfpqQcH?=
 =?us-ascii?Q?mKF50tJLC1/VWa4nu/30vn3SLck8x6S2ZH3eC/1E5KUaAmJIHJKp2Av3mR/C?=
 =?us-ascii?Q?3K71mKbrOZFV+GSO5QdQY/YKFvBRXR9rpzKpqSY+t/rd1QPQx9DUKwycZAYi?=
 =?us-ascii?Q?XNUw7u7kfMnq3DHemMMT+3cetKa+GuDDJyId0eP+xKq0QASrlK2zvWHpfhrn?=
 =?us-ascii?Q?vOYzVWbtAgm0wf4setreYIB+mO7TXxdQGWlQ/w5jGlk5KrT1W/WWyN3qLw7X?=
 =?us-ascii?Q?IlVP2Jj3hFvDEAj88ystLYhaHHUjZC2EOW6iZ5aTBhBvzHqCLdNweVeTQYPl?=
 =?us-ascii?Q?d/AdgW0LxJuzXaEUsK3ecbYkhPGWtq/9Z/uORAqJhiJK9TG6psO6uaNmDK/8?=
 =?us-ascii?Q?/ng7iyvIWw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd20259-044d-4728-da72-08debfea1000
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2026 14:28:34.4623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBwNFJIiwXE58cpT4E/QSozo+kNpmEoWo1zojqYAfZdlg5W/GtfwZMdrdBb94wKOHismvLi82J81UWjoqtoHGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF665EE4E73


Hi Eric,

> -----Original Message-----
> From: Eric Auger <eric.auger@redhat.com>
> Sent: 19 May 2026 14:27
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; shaju.abraham@nutanix.com;
> khushit.shah@nutanix.com; yangjinqian1@huawei.com;
> cohuck@redhat.com; richard.henderson@linaro.org; sebott@redhat.com;
> Shameer Kolothum Thodi <skolothumtho@nvidia.com>; philmd@linaro.org
> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
> jdenemar@redhat.com
> Subject: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID regis=
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
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>=20
> ---
>=20
> v4 -> v5
> - ifdef TARGET_ARM_CPU_IDREGS_H
> - s/g_list_append/g_list_prepend
> - void arm64_sysreg_add_field()

Looks like this patch is missing the above and file:
target/arm/cpu-sysreg-properties.c

Please check.

Thanks,
Shameer

> ---
>  target/arm/cpu-idregs.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 target/arm/cpu-idregs.h
>=20
> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
> new file mode 100644
> index 0000000000..664e2d6ddd
> --- /dev/null
> +++ b/target/arm/cpu-idregs.h
> @@ -0,0 +1,33 @@
> +/*
> + * handle ID registers and their fields
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +#ifndef TARGET_ARM_CPU_IDREGS_H
> +#define TARGET_ARM_CPU_IDREGS_H
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "cpu.h"
> +#include "cpu-sysregs.h"
> +
> +typedef struct ARM64SysRegField {
> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
> +    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
> +    int shift; /* lsb of the field in the register */
> +    int length; /* highest bit number */
> +} ARM64SysRegField;
> +
> +typedef struct ARM64SysReg {
> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
> +    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
> +    struct ARM64SysRegField *fields;
> +    uint32_t fields_count;
> +} ARM64SysReg;
> +
> +/*
> + * List of exposed ID regs (automatically populated from AARCHMRS
> Registers.json)
> + */
> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
> +
> +#endif
> --
> 2.53.0

