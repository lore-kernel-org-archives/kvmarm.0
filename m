Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010048.outbound.protection.outlook.com [52.101.56.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169933DA5BE
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778149970; cv=fail; b=TxRQnx1PrxjwvB6fFiMlbfz5+6FxJYq0tG54LJLSqLuk5pRoZ8viZYm+1HU/4vsr6pb0HATqTThqS6SiLEwd1G9c531gCBZ9tQ/aGpajnbwOAarNcdII7HY3A6gKO5NO14LW1EBNdLlSBqLxWJynlWdZ+D9niyt9P8Gh4NtE0Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778149970; c=relaxed/simple;
	bh=NIrFW7aKOOf3ZENCBayoKHwLbToP6EXgX/66gWIWnqI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A7c6MHOIc5vlsKu8BrqOLdDZUUeMR63954qkULWH1J3wF5VOKiHFHwxppbcmKVZXSSVLOUkSh7122K4yq/fvpv0gP9nROqs8oPbkIgd+HScYCBr7/7qzm9gfM7LTbqV70w6gFeGyidE/RV2Wc1JqF5Z+bakIe8qwLJatSbs8B2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=INInXC93; arc=fail smtp.client-ip=52.101.56.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="INInXC93"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYxW9vjYjIytVqyymSbW91vcaS88mGb68dMAPUDPFoDsnixAd9kGq/IdtbTGZ5FG0Ix5FMR8P9pL4cv5mOZmGgk5V0fqwldi/TYPIo0d+uIIuj6nvm+oiCrrQaVVuXXLd3M0neexC8wdJRTN6hNCLVGrP0pi9Gwuu+UEA7ZGwYVNmAriHXCm8Zbdw9VqAJ9Kb6+cJp6DyG0BGmtMvM2s38y7qq/nI+xOAW4arZXc4QJWUGwUoK60C4doUJbFyEjLT4wbJVXipD2l7Yt+/GSrqLBLX5067IT2bwkhzXIEokTINwwr1VlYl70NB8QnN9zH0M1O9XnODOv1eVWwdEMaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPx9GHdc9yMtab1NnzDLpaJPmrPQ26nesEaOeIN3hJ8=;
 b=fw1yVb74dZWRxz3ObJ4DGZw+M4CysqLU45CobciUpqvIOT1xEunLQQfmMuRPqYBMXsuDGjmVePIdORVFqUz4hnXHPMRvReceyPOYSWJes/q7TyQPmed+6TAAKc6ubZey5tJWuLVasm/+8NfXd1G+N93DmqYk8azskw3YOuDMvDCN6jvny4DaGP4qs61GlnSPylY8fJaZARnhk3P6+2TPYAv1wLHH1jsUPdmdbqm9VSVVux11Lp+SIEC2FXxDgxn8DLbcHdJUgZ/OKbbp0DRMKlJDdebtPue5ZCwU/LRZdt9gjmtZynv9DVjN8WOtDwXFDv0+UD4F8qsp7d/52UIqZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPx9GHdc9yMtab1NnzDLpaJPmrPQ26nesEaOeIN3hJ8=;
 b=INInXC93OisER+E4sR+hqctJtVPlFFQtSwCzpZKjjgMZ37I4xCHp6plOkaGBfBS+EAS8a1UPRNcbGSURrnZtCPILeNFY52MnWO4x9J0YV7vLu2PNc3zSLi1SRdLNrOI6/ENXYAhuFfF5Dy/MSrx8UDSIWi6TXN+E2llEUxA+FMBPdrP9FBTpTKKiqR45s6XQ1nj4Lkp2NQumAPbAERr+Wip4XSA4AZXK/EMQEmZgBoCU3pwDylrPCTP+xTN3Bvxc26JveQa1HTvq/in7INQwPu9x95GyQG/tb8UKzJ9MgJhamvTLGhx+Kk4hI+UqbEYYwwJhN6uzphz+QPUvPBLVWw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 10:32:42 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 10:32:41 +0000
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
Subject: RE: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
Thread-Topic: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
Thread-Index: AQHc2s+e8lgn2BsakUWQeUTEPE0vkLYCY67A
Date: Thu, 7 May 2026 10:32:41 +0000
Message-ID:
 <CH3PR12MB7548053696CA900F2A2349BDAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-10-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-10-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DM6PR12MB4140:EE_
x-ms-office365-filtering-correlation-id: f5ebcedc-8f04-465c-b524-08deac23f80e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003|921020|38070700021;
x-microsoft-antispam-message-info:
 ZeMP6Qb6XgpKr31VrsuZtLKqMlithjMjtsivHMLyeWBvzoIVyDhF9Tr7ZF6gMiOPe4JL1YNcX+kZJsh0DFpNJHCbaxd0t1DiPs+zmRB9ZlsZlYyUEf+1IVokX1FojqL6sgY7L6jr5Lc4S2vIm1me7mI9w05XfDzyVIDIIocP8NKNkkgIt6h40PKhTVqOxbJZra/UM57+7+sSk4EzLatW72wzwyIjNupDc8jeXLDeRQyxTpbaoM0KMeAbV8nQtwo/yJcNUTLKlAN4nryU2I5+jaIIcnVfG9W86JQ/jSybN8hCUl5Sv69qPG4qlB6JFWfFC32ud75ILOKpcmdVfUXiiAAzQpya0P96sNuYCd3nq/t2sHeeeekjOqIwbnwEbCRsqoNKoFjAUX23ds4payPho69f0depa56RGttc/+1wvkkmYRO4o7IimwCJRZ6ixoXPZWBQPaB43gbXdobwHvMFJExK1bBPoPnwEhqyqnser7P6L15DkhKWcAI4jQZKl7UbpAokN+yCy1WheMklTFCGTu75wAhCAGAlszgO4noUzY4uwPlv1kZvJR7eOL7+yhfpoO/9JaalDxKx09rYXfVyJ8WwFhc4adKfdKXlwjRwmVrZTxcwyNHVUlD59+HeEw3IyslA2bd4JpzqKOxN0I4SLZdk3fBSq+0/feR0+tAr7XsvVcxYeQCW4ujMVCNOLXmlmHkjBuIF007eLIqsOXLhu/kmQJoSysafO5kVZ/cpvaYQ5RxMa4Wy1YY9/bGZTK8jML061aOYZDd0lFRhX2o/gg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?dK4zxbwbb2UrrCccL8rnOqDeSqhJdjgL0tUQInwX+UpratVDwGBe39sFCxLR?=
 =?us-ascii?Q?BssfSgWzNcI6fPknN90LmMvHFRKRvu2i2Gi0wLcHBheD27b2/bh/b8pfs6sG?=
 =?us-ascii?Q?5HgdarmhvV6OPPBFiVJcAD6Pkm5rD7YakxJD0aUmVy6vruw6s1BUlAgBRkss?=
 =?us-ascii?Q?oTutwMpyMsTnEWsL3jk90x6ha3iKOq66H1jIu2ysMVj7axmIaz/wq5z3zGM/?=
 =?us-ascii?Q?cFRYfiDQXlmZxjCpZ5+cJc/LNm/SIxjGc7gB+iQ6VZUp3pExkqV2Qq2g/+K6?=
 =?us-ascii?Q?hZS7LBZmtxs0Xv439oii/RUctjtb0pynMJzAapSHvNXi8Yg8iTmn496L3/OO?=
 =?us-ascii?Q?Q+C8xi8GQOGQFJhvqgKx7o3RXa1ileG27+MN8prYR+a/Q1l7EVA6769vK3gU?=
 =?us-ascii?Q?BdkUSD49Ta0hDpM1axXhje5JQz1WnlAhmwAVnN0CHtpNlPtuBL0jaPMTVP6i?=
 =?us-ascii?Q?6NXsOfG37DjDovhbE5h8SgPX3so2S74F606B4fqg9HItI9andvnpdvmVKNsG?=
 =?us-ascii?Q?bewoSqHyhnd7XKpq182E4CL8TkVQCl/ci3AogAhFVJAi4KkwAnrRWAH3H9OZ?=
 =?us-ascii?Q?0KSr5bM/gnxEQv73RpF3UxnNkCflAoifO0KxxHrNPc2eKrFXwXpIBIhAhgBs?=
 =?us-ascii?Q?y4mwg3QPIpFnmdGgn5z6NW2WIWpRa/gseLjAgMlJfjUcWj7Dhu5kMafSxlp6?=
 =?us-ascii?Q?CmYyFfwbwnFDEhpesDUbwR4rOt7UkLEq/PxBzZYthYfKYUa9izFr/xbKkCQP?=
 =?us-ascii?Q?2knMmllO9cLbOOa4q0fMMVeh5SNpyQBLb5FF8BNqkrAoICaP6fBKzXYTgkqz?=
 =?us-ascii?Q?In9GSJV3GbNtFoA/eofGdpwwIpxE7JvVUMz05XmgkSn6D2ke4Bd4binr425L?=
 =?us-ascii?Q?OJPIt18EO/OzHlhSCzbsOLZp4L8w5/ty/RJXfWCqZwm/SHYJ4oyXCShlbNAV?=
 =?us-ascii?Q?6+BXYC9sBENp6dKg8D4XDq1TDBxQILghUdH15llm/8c7eV80cnZIOFF/d0I7?=
 =?us-ascii?Q?G01S6aSXafzZdecWXrsCP12sQO2VJchZhYmpphra5p/9QY5Afqei0ICGz9yp?=
 =?us-ascii?Q?8ahXwfIi4dXLltUz9LvLJbOkX7+vHYU0DDxALDG7dsg7s14nTPd4QmbhPMpY?=
 =?us-ascii?Q?Kau7PGPVwgz9WNVr5zuywZ0nNJLtC8Ml7uD5ps0RmPpEpp4mJAuUdv61cOK5?=
 =?us-ascii?Q?jHJYavvtjxTRLYODqccG7ttGzgIDRKI/VQ9+YroA1FzhpKOA1cqJnc95qLTR?=
 =?us-ascii?Q?ciSwe9+1nFn1cztmj0/eoTgEEwR2kBIcKW9DJLVBRMMifAlRLOo0RlBc8cMv?=
 =?us-ascii?Q?HXOWt+hU3WGjGJDkoiiWBN4veuqrAehVvj5UYvTcQRkYS07y8hR/3Nqn1DSn?=
 =?us-ascii?Q?uDv9icSBMguAHms20c+f45wpCWiQ2yOySF5ioQWhrqCct/bFLa/cwhR9eUBC?=
 =?us-ascii?Q?/oyjj7CVS+jPI6TMRwtZAk98Bj+dLh/7pSUxZHYNO8q6JOoPutdo9bflznM8?=
 =?us-ascii?Q?GvvXkjRsHKhEI0e00qJmXqrXcA1R0RitPej4dsY16K619SA90H8yfh+zxfP9?=
 =?us-ascii?Q?ZlYE5s1UIlxgTbOgysYGCVgfF/eJwAXUOUyQx6oQBJnqHGy4yuebNgNGCezv?=
 =?us-ascii?Q?k/Mi5u4kdbY/Vr9YpqtLg/ROL/6J81rrDZQA6sxoW9Dvk1SL4YXssjKqTZhv?=
 =?us-ascii?Q?H6nD6KYNChvTZYPIU+ay7kw2t4epZOmz3oM1rQaZCEQAJ3KuYyL6bZwCDvDN?=
 =?us-ascii?Q?AaP3d3OiXg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ebcedc-8f04-465c-b524-08deac23f80e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 10:32:41.8131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlJjuBvE5BvEpckEFEObx+jL5WC8XxDYccmCWo8Jy/VrkyifPkCL12fSF5VvG6PjIuZ0sQTbBObIsh3BvOPLsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140



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
> Subject: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> From: Cornelia Huck <cohuck@redhat.com>
>=20
> Introduce ARM_FEATURE_ID_RANGE_IDX macro that converts opcodes
> into the index used to access the 3 * 8 * 8 feature id array.
>=20
> KVM_ARM_GET_REG_WRITABLE_MASKS populates writable masks with
> that indexing.
>=20
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  target/arm/cpu.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 2aa22360d2..0ac0fd13cf 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -886,6 +886,13 @@ typedef struct IdRegMap {
>      uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
>  } IdRegMap;
>=20
> +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               =
\
> +        ({                                                              =
\
> +                __u64 __op1 =3D (op1) & 3;                              =
  \
> +                __op1 -=3D (__op1 =3D=3D 3);                            =
      \
> +                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                =
\
> +        })
> +

It looks like this macro is not used anywhere and in next patch it
uses KVM_ARM_FEATURE_ID_RANGE_IDX instead.

Please check.

Thanks,
Shameer


>  /* REG is ID_XXX */
>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       =
\
>      ({                                                                  =
\
> --
> 2.53.0

