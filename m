Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96383B27D6
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322988; cv=fail; b=cdvAmue75/Nc7hblsXRa5efWpxwGMFE6Pf6+duHHtnlBOaxokqOejdUsZHWQbP19FM6RIsuuDK7ZkUSrvdRZBO7fsHc71BdKTghd6gksTQU5c4pOm88cBJ49YZ3r5c2D32g7URINeAasKewgO9pIj7tNlJiGEbRu7LRZMJPqH64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322988; c=relaxed/simple;
	bh=FzRcqJZjpvxV0X1Gs7UJ6LCpm+F/3zkulvo+1Lc0KZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c68O/rDPc7zrmZRGIemjdsi7bFdEbZqVO1xv9SrQhAevyO5Nt/iuAVwG43opROCV6E2iOmwjbKW1z8Be/poUys6oYL/I7wryl4WnlxiKQ2FUYRRKxkwrXXtmGQNaWfbhDX+MYvtZWvZfwI2pLg54ST4p0GSme0bvvTpawikhilo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ArYYFW+Y; arc=fail smtp.client-ip=52.101.201.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ArYYFW+Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvYCG5vT02dwzGLLPT0l8SwcM4F+H8IB7uyymD0D+Kcr0t6hQsooMvQ55Mo5JPL9Q9Jcykxqw3A7EuIaipG1B1IxSBU90yhaNNCwf1uhfKulnziJa1qFljspYE5ZFViR6a5CkjozwnuOY5nVVMsfDI6RR0hr+qpyyiBH3xLP9MtFyTgaZO1XGAAHDKYWT2wjv2ieFoA9MnTVeCzm70dvmrjUohWF2IyaWkgIf9R/J8MHC59bX5w8oeB2IRCJ35xq4GHxkb04BMxocJFIfjdbxmbjtlZ/gXMt3MdSWX17NQV6RVnB3vHMBXLC4/UbrU1t36RSwQ03/OU+EOrYuww0IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FzRcqJZjpvxV0X1Gs7UJ6LCpm+F/3zkulvo+1Lc0KZw=;
 b=AiZdBtMdk0Pw4wnTPFktrwjJuiLKXbQDFIKBWQyKfcWP6RBBoIwaWWOynnhML+/2pITEyyn4XB3acgGZ8joqU1dzCPcz++r8s8JOL/11IfiyY9U8aHJC/5oRpkctlhDpbgQBokOuV8Owt8FiQ1yRPiSNS7GRZbPcg2XUF8uqAXNGlhOQTN+Rctr5vnrkmjCzFZe5kqXdD8jwqWpGzIoYHIZ99MGf4B7Eaf6QB6wzIflpjRb8gF9LuN/9+YLmjT6TOacgbRSt486MwxiiGkISqRI7thPIHsTjXfu3GmZSGRhLCIKqC+E0Kbgm8+mpTKExMoO8s3s3pcgz/1XLP9Z6jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzRcqJZjpvxV0X1Gs7UJ6LCpm+F/3zkulvo+1Lc0KZw=;
 b=ArYYFW+YDkUR1JixNVRu9IwKOjfLQ9/OiAaZ9Ms6KNoBTQeyAwX1xA8YhmAcBgshUXWCfsg9pj7mxyaexeKjtJGreW1sq+UCM0+21082Z3cpFo+6yUHacELLEJhTHJEsPwNcolCWD1bLmMr+eWapnkNb0xcRVS9ThQA68lH+JrEd8hvsxEFF0hPTSewwAPf9ZHTCIWG2eLZFOHiBuXusjqdKK2CvhtHm9wBI7HI3dWJSnLRhMNEiIT2Kro5oy0XnV9Foge+eAEPGu2KP97B9hkKH8EUYaoGw/ODWgWAVH+xOkaryU2oYpHSOKD2qhY2aClRlSnVgU1+NMNtiCdIOUQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by MW4PR12MB8610.namprd12.prod.outlook.com (2603:10b6:303:1ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 14:09:42 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 14:09:42 +0000
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
Subject: RE: [PATCH v5 03/18] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
Thread-Topic: [PATCH v5 03/18] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
Thread-Index: AQHc55OSIQrbkzCnZECMCWq0LLpFvrYp0VWg
Date: Mon, 1 Jun 2026 14:09:42 +0000
Message-ID:
 <CH3PR12MB75486126A2B70E920E666EE0AB152@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-4-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-4-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|MW4PR12MB8610:EE_
x-ms-office365-filtering-correlation-id: 74310fcd-468b-4194-6661-08debfe76d5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|4143699003|11063799006|56012099006|921020|38070700021;
x-microsoft-antispam-message-info:
 QVExqpYuxe1UBQXwnPl5gwgPjsB2Cr4NG+rv6GSCWsD5Bvnl4LsLmbJ95BkXPvkjYHiREoo5YTnM3cv2vlZtXkFVql0hTsiAoPdhmFnukwwVONCEkMvAtjhPvqdq9F+BvvyVD2PEn5s3/YXFqW6+zpXchVUVt6dQ9xOJiCRdcTfKTS/s+aIq313S23/9jAAXT6S1/m54G0v33IdwrD89gPpwUaCGRHuyZ1LFRffZqvh/RJbL8e3GTElT4TwJlAzf9fsARYw3sm2LnoH7SljDRREgOgpzQrbPh4aToYctpkTgYlZrNZcIA4roDWij626sh4EwPrc0308P4zwFOse/bs2cZAdp5lkXHiYqVbT45FkLh7AadYVZmrVf8PMnMB0NX6Sg8whcg/zbkwFmgyRPB5Dk4EYt+YOlL4GjD4Dhk6xjmptZEUq0HeFcvwzxBt/Dj6UJo0xIh+CXmciNpwlQmP0cTIFp5+8G2qvof6j3D8yJZHBP5m0JJlvJkxHQtwS/Z/7mEbcqYczHQQlNkzubjA5Chr9LNKdS1737Z1HztCI4dt7P4au9WneHcGaAxR1b1xSswNOpsv+GhqRzNMss/Kj33WbvVAj8SIrqmKETBqcpR+mXoQeIiA+bP5BmUvy004I/R4PFG8CTVUfAabKzqZZRb8FulvJG952xgpx9a9fyl19AcHj8NiTJpZcLD2+QzOPOdY7KNEnhlTrvhEHworveTqOTLOFGJup+oeno/9CsE6Z5uVqHKj5ZNVHuBLjyxBh2hn/JTYFnVS/VNuui9Q==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?agWTVBjfu/Op2nG0rI+Fq0NkJiqV0gsRsmna6XJ1zSYfUlolvVFGLmwjFgoq?=
 =?us-ascii?Q?3jrWrufgyGpWGD+9fWwoCFa9GqfJmQhmtFXmwtNUy5+rzq3KoAatQDnKjbJG?=
 =?us-ascii?Q?RDTQMhznacVw6siIWV2dsmxCr5UkoONRxB6SOT/RQC/NfNRYLl7WTotBKqUS?=
 =?us-ascii?Q?k/mFc6FexA6Cl1OypPKjTclULiXZPjHu+4K+LC1J9zY5QVfoGmSATxpi3XOq?=
 =?us-ascii?Q?7BMFlWK5MaWnkJ7OgaKk2vlSTMEXog5kz5dbFLGC0f1GwpzMoDhs6oAIzaQp?=
 =?us-ascii?Q?V/2owVi2W1ebvRmeamGZvOkTffeKVl7r/hCSYQ6k14386L+9X0wS6l2stZo9?=
 =?us-ascii?Q?Q0bXzjvgq1MPbxfFRi814lXMg1qb9R31ewbRYbCtqTJVpBRe39kqL3PjLkV+?=
 =?us-ascii?Q?u7Qk898SNUxJZ9OGmyFme2EfCBPtR0f13QYb3pk6kjDD2Stor4qYcOlFORTg?=
 =?us-ascii?Q?EspsxPqe0U9C1z+2fGFXhufpAKTM7a9aOhXNDwLk50sCzN70sLZP7Gz60jit?=
 =?us-ascii?Q?i07Iy/H/BA3+XskgkM6IQ3jZn5049MwUR2ZoePv5LmWw6Y2VHGOKJxfrMRVD?=
 =?us-ascii?Q?7Vf+R202IoWdJtFeBCgDZpjo426rQ+pn+SkamDbSGic1gRQYZJOoiiPoqQYB?=
 =?us-ascii?Q?dYFITfRGfQ4d21bmzqSXcDH/11wRqqTh/+daDcN6uxJKPZWmHPNBfL5JBg8L?=
 =?us-ascii?Q?v454Kz6YbZ/ugMZl+I/bXvVHjrIvEx51VbAgV/f0EhVjmkeXrGwQ0UaLP+e1?=
 =?us-ascii?Q?2fpj5EgeHQyXaEOeeSUg4f3nIErB47cahVB1utrqmijqtCEN2xjuValt61HC?=
 =?us-ascii?Q?XkXHIaXnbBPPjsqWkJtzHAjiT9Odbljaz3D8w7B6+Wa3fNoAvcTU6KFEzR8w?=
 =?us-ascii?Q?eFcIAia8U8h3JmRx1M/rYQQ4LuRtWgujy7V4TWoKwaEnn2pcCFU4nKQG3o9B?=
 =?us-ascii?Q?3Jc8SEY5BD8CUrqFNmHCTzo81DqJyHxd+6w35VpS04P2xXNAU4cCxJ1230Ft?=
 =?us-ascii?Q?YQZI00Wu5iX7VqO53SPeaPe1eQ9GKaTPfxK8YKOvUXhf5kZXReo8O9XoGoZ/?=
 =?us-ascii?Q?EalDIPR69p35wg0Zl0fP5diUH60QfyzS2Fz/SUBokkAqBSzgc5eu44EjMmot?=
 =?us-ascii?Q?XpeM34aXA8UWg5GVTiDxqJ+DHGJHEspiop0dEe1iWJlRxmcOWIBhV1IlF3JI?=
 =?us-ascii?Q?OtNLy3SUe25TGYwi78sv9hfBG5qE8GLFANsYM8BjZCfVOKChzIsRsQ0T6btS?=
 =?us-ascii?Q?MxMWlz1JMAdIaqwNvl4vhf7xEyXClYez2cN0Cuy1/7ewFFG/0RfNWURcb4AC?=
 =?us-ascii?Q?GJYE/O0LeJ+ElSJpV2kLHURkJNoyiLihG1ipCt2mLtxrRBEqhWXCLeyYl1HL?=
 =?us-ascii?Q?f2NfyPvFf9m3NDFzQ08T8m6aIzJ1emiKk41rpuMSo/10HFgGgbvv0pckE8sC?=
 =?us-ascii?Q?P6j5Ws4teqiFTqcZQTmG7i4xrQP1/uLXxsc+c4mqj7tReA27pTD6o5AtvN6u?=
 =?us-ascii?Q?hRoQJJG3RssoD6P1H0nRq8Rumf5fEywTDNt4Hte/+ESS2CcOm+E6S2+L2Ryz?=
 =?us-ascii?Q?m14EbAnx71/ujLjeW26baCcKcRdEZxBZNRpBUBmu6DibPKj7RLPK5wcbBtf8?=
 =?us-ascii?Q?5uSWJq8JV2CLRVeSyiyfiGzhnwsvidtoHIP3lwctHoVotGabUIzMBGV9GJZj?=
 =?us-ascii?Q?uadMqZrA+h1YmWSlYIsdIAzIhNADdG4v/3RpBHI/deII3HYwWdHYkLISxkRB?=
 =?us-ascii?Q?7Lje44w0PA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 74310fcd-468b-4194-6661-08debfe76d5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2026 14:09:42.4956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PS2zCd+DvS0xVadsV2vzNsaRcgaLDj2z6xd4ddAl3iZprjq3CSOJBrf5qtxb2KlNpHENWym7BfEeDl4snhfBDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8610



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
> Subject: [PATCH v5 03/18] target/arm/cpu-sysregs.h.inc: Update with
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

Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>

Thanks,
Shameer
