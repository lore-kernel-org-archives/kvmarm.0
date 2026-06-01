Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8473AD528
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322882; cv=fail; b=WPkW6C+2QIxEP32jO8CRfHZ1Bu+hHjzPr5kn9Ap7qH42XB9MPZ7tUtj/1i4rljiwd3rftnOB/CkEY2WRDTdaGC+bwlVjiV9UhkWel5/P5Xo7rrAG7fAL6yxjBVETKN11Blwz91Rr1YiOFqHhVDOVBUXf1ys8LnGZ0oXHUKlzI3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322882; c=relaxed/simple;
	bh=IWrI3Bac8tA1I5y5Dj/lcInqwNxXsJjafwWOhJ/Xckg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWTbXBf01iKG2U4lPNN4jnw5Nat34Bef9h0gn4niVGmKe0i9T9t4qdIXmH4GDTJKuBNAD7WkEgI8gvt6ZFjeLHXnpA32lSLwXKxC8OIhQzmomd5d0dt6i4ueMWHV99CfffM4Tg7tLmnwTsZZuMTULrBiqtl8DvoNE0OjMsLVFIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DGrhKjar; arc=fail smtp.client-ip=40.107.208.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DGrhKjar"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0Y012D2P8lBo5m96BYvhra4h0vrO6JaiIIsP/icbnz/e+g9Mi7Ewv9ZV8OgUhb/YRfO40awQppCmNtpLR1TfPv2kqLWbW3UTyftmtLuBAMLQG9JIJ02W54MY+QtoYVabnTUaUC2nDj3wik51FwjfC34h7HoOugQlFLcnn/3Ygw1upDzrj/C2mt85KX8g8hmBeIxIfnLfU31pPYK6/NQzqrRvwynKrIimpAavpJdOiwcTa52TkE6MSPBkHxB9q08mZoYQvh43ImRpI+UQwX9pajuxU+yoLoCMRAz3sJLqXBDICek1j/9uPpvIOplXV4atWhvuNcN0qH9c0Fg6NECEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWrI3Bac8tA1I5y5Dj/lcInqwNxXsJjafwWOhJ/Xckg=;
 b=Sh9vC75akQdidiKE4/vky0ZfXZp7DYVD+q42eZ7fSS53BCUm6kt/H6zebZSX/4hwwhok26MtM99Gvrg4GVuNaX8N8rwDohzxBE6jJSMlHnvdzg32cEfwECXuiuqUwY560ThDS4u/2OlSUi2Kb6S/O91Q9MnYreEFcycDLRJdqZYXzLy6347LsVhiZkMJNBnCOusnctv0vYaB0B9WfsBGHWpWdwp+svk9+LmLMbFghqPs/7nbaazj01EnUapxtFHDXmowjIAXe+s28sNMASuMdwavyiW9L34p5AZu8VZov95LIYtkYBUMotsfP88G8ejZ7EWItjdK1DKtBgGaDPzc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWrI3Bac8tA1I5y5Dj/lcInqwNxXsJjafwWOhJ/Xckg=;
 b=DGrhKjarhW+VXR3oO8eQ/gLAmLoldjjsuexNIyjozptdxoqUCi5gpZpVTA19mUa6PQv8J1ZxK4EsbHyvrivJpL3G/D8sTkvqEqJr3D1pTPEIoodyItlhpKqwMkkVss3/eX6gI61XY5TdF+ICTTxzdQa/FPfinxY/X7Q/zU8WVYPF7zJl497ZISRTGnc0gysXJqvSogadaBgiPufSVBFYUOI8hkP2n/Mp6WB7CZDYNjEhxEYOnx/JS/rO/RT2yfh5Fr8oqOx8Ik3CFa5aRDqj3EXn1i2VYoLe2i5lACU81fqad93k7WOpVd05oF8dFYPK6lfWTqPRPvNEt84zK+wGjg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by PH8PR12MB6891.namprd12.prod.outlook.com (2603:10b6:510:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 14:07:56 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 14:07:56 +0000
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
Subject: RE: [PATCH v5 02/18] target/arm/cpu-sysregs.h.inc: Sort by name
 alphabetical order
Thread-Topic: [PATCH v5 02/18] target/arm/cpu-sysregs.h.inc: Sort by name
 alphabetical order
Thread-Index: AQHc55ONGl8PIkrj+0ixGAHPXgwFObYp0Jpw
Date: Mon, 1 Jun 2026 14:07:55 +0000
Message-ID:
 <CH3PR12MB754850345F12560F717787FEAB152@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-3-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-3-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|PH8PR12MB6891:EE_
x-ms-office365-filtering-correlation-id: 05bcc9da-bbc7-480e-96b6-08debfe72dbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|921020|18002099003|22082099003|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info:
 f9QB03Vey4BQ0VwPVyjYm+VQmuEpK4uj0ePqNH8jh9l+7t2SESGfHQU7eM1ZqLMXRHs3j0uGNQq0DVwio7JUMbcJwOZ6bstbUIdupegxMwzKiVaRX4uL9WuXzsg3cT1DnQdZJdROYvRyNaktNkKQ5kLUsqK4c78M6xgVeIm4NeaicioTmXsJzGojEU++rHAE/QTbXxKN6Il8axuTC1FiBBmIWcDqb14kdHwcERUbxY2loG8ygUpo51JZBD8H1nGHj4Ouz8D8W6KAtR3P3vGi+xXHY1aCddOVwMR5C7cDDTQdIshiGetkJ/Yy8AknoefBJE/Ada6UMWc0VBvSU29OXyROKaVYkslDZR22ygOU4zFtFMTWEgzogUebVTxuh2Wbfz+sI1u12q4/C5nwV6ZLup3JGjh7LT09jwV9P1KIQgL2rR9Gkja8LCuthWzQZQG9xpazSF2CHpxqz4zJqbwEZ344ARVuv1LrVKUSPcHFBGov8h5UgZN8lQB0YXcooTfttwg8zjiVE38/GyQFt8OZ+X16WmDGhmWBK2i5jtVdlwCThG4m6wTGdhSamULp049dZpiridDI8FGdquAvDDBZoHIp0C0uBpvUKs4xs/RUuBe56jFTgEHmYSnoel0FlTT+T22YPPOVo/ybnAkWDMLECdPaxRRLnSOPoEgwDKC5d/cKAM4cvqkIKCjhNjCmHMcYEaPT0R01In2FXxecbNH0/QpmSeR7gc3YcJA3DLLNnKTL0IUHY2PO/938KZfRS/zFCXEt48vFeuYSXy1VijrEfA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fldOjcE/C+6hMu2iwFNDWuYe08v9gnge94mvf+ZsSBf7YrsbfUQ553YrtMxJ?=
 =?us-ascii?Q?MGyzBFwjzpA+ORKmR1LF5p37/EOgOMbWEUkILIzjrqkAQO2+FISQaT+NQagt?=
 =?us-ascii?Q?vGPrH4I+OnvgUknS00jlClcyorYHfOOV8I4tdnXYtTiqPDAK4c3H/TPLbA1y?=
 =?us-ascii?Q?IK2KdbV974w1HdBCYry6oTcdE9+4x8bPc1Pz08pd7CSQclS1M2vlQtxGmHdR?=
 =?us-ascii?Q?uK1nfu75HurxZIeQVelaMkmXogh6LZboQfblEYhZT/i3BOjDQK3tNDlQppWy?=
 =?us-ascii?Q?yo7je1/nD3F8sqv7b3Cdor2vrPfpPbgbHKASjN3Wi66CTWIFje1dsrYlbvK5?=
 =?us-ascii?Q?VhrXRQeeTphG+E8W6qTe+qtKVAVGOcBIWBFPX3Q0WosMU89s7MTUc6gsPP0Z?=
 =?us-ascii?Q?GE9VTi3AWZ8TAhF8w8hgFEoO5npjaFoGHOPnG9zb7+VfGkC3eu+gE5x0WS2+?=
 =?us-ascii?Q?jm6TrlQ/JVZmYk8w54ETIQHrt+Q3XMWeySdPuxWVeBbvjN/ziMmK96Yf+XZz?=
 =?us-ascii?Q?QuO7ToF6EDx6J0v+VxgM854Pe5JwaPwHWgyfL0YjWNmrZjgKudwYPfCwwxoO?=
 =?us-ascii?Q?mPFbw9FB24HXiGcXk71GPzBFLYSRmQk9XTKHZbvK1UsD327BvBEmB7y/xgLJ?=
 =?us-ascii?Q?4WiTMWWJ9l28Q/XQXgUEgwQ/PZOqHFGjQgBQXbo2ibLYNlJMfuFYcMBDFwEN?=
 =?us-ascii?Q?daUSizMGqEd45hvm9XRo7eHJNtp4oeJt5kmoXbZtXXohGDErrtawCY9sVlme?=
 =?us-ascii?Q?dgv0XJZsdUpctPYd21KBEr44AXnWe/ANqmlU3arAsRHNLT/bn7OD7y6eX9PM?=
 =?us-ascii?Q?Yf6k9rFojoZETp97MDv/eOveq2ryffBdDzB+yU1tgiA5Fwb8EF3TytZtXSMg?=
 =?us-ascii?Q?dSL8U9wbvrDilC5A8LhkrXMYWXbshyQPdBIBjnqJPNH1BHCfxddvPTEV3X7Q?=
 =?us-ascii?Q?UAmvLedGokPjYOLxS4TWRsdb4NbDWfDDj79Cw189GDXmuPsVRUi0TngEfC85?=
 =?us-ascii?Q?LPOxr9NWt6T9An9ZgrVSokIjAsjo01Z7x9hpNkwOyCzPBekNnoUl2cb0IkAw?=
 =?us-ascii?Q?Tm1UXFk72V1mmHcoPm5nPnCt5z/91QxooEJrwfxPP59Z22EnkBwEOVnkZHfH?=
 =?us-ascii?Q?5QaTeqv4s7ByzZbqmaVRk97xrAW0ZSE2ERX38RIC0HfwmS1KfOstXQ9Cave0?=
 =?us-ascii?Q?XV7QPvRtIHp7muq7FrUgIM4Gc8fz+JM7xp3N2LnDVaKVbxy/iYKw/qGeG8qu?=
 =?us-ascii?Q?zBuc5jRa6FtgnZT5Yc5lcpuZpyOSMijB89qXhbKFNrAYyXBhHGmm40ikbUh0?=
 =?us-ascii?Q?Wbdwl52X4uQ3WZpTfjJ4tNJGjCxlYzIEIr+KVl4OHnVsLT/Y98fo4L6ur7GW?=
 =?us-ascii?Q?yC2XngaML+YaBuM2vHUgbRCjPBhkMlATjO5yLTRksyT3rBvqpDh/J5VQRHyn?=
 =?us-ascii?Q?phhBVYMms2R/bGNb8eozd3pLFuHqFKx+QfH9iLR4LsMLt7glmE1QMh7/YIvq?=
 =?us-ascii?Q?ZBOOgwIDS9ceNLDNQI/oYjPdbqMIftEWLFpJtXjqpnCRw/7VE35QEN9ho3LY?=
 =?us-ascii?Q?9FiBsiEPe5l1n8YYVyrhOpaVRMMRRfQG/5RwVtYsVAB4Jty4OXE0dT7ddv87?=
 =?us-ascii?Q?9ajnANRXWLrJH0ZHxr5XVIpGEMCJR33T21f2jTPt4W1qxDDIpr1b7DW6SXR0?=
 =?us-ascii?Q?72spa+32sp0AgqJTTv1NHtNMolcTSDUX+T8ygiwdvqlCWXfZbaN+y1+f5WIh?=
 =?us-ascii?Q?2eP87FVtWg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bcc9da-bbc7-480e-96b6-08debfe72dbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2026 14:07:55.8351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlY/Cu7JeOGu7H39/3h4A+ptEvlpy2SGPggCizjXqcavGkNBe5AlRROP4JGHzdX/xte8CcIalntbRZ+1iQdDqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6891



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
> Subject: [PATCH v5 02/18] target/arm/cpu-sysregs.h.inc: Sort by name
> alphabetical order
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> Sort by register name alphabetical order. This will allow to
> easily diff with the future content, automatically generated.
>=20
> No functional change intended.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>

Thanks,
Shameer
