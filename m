Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881FB339A8
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793217; cv=fail; b=N0QtYHpJOL262gO784KvawyS0cAeXfHjdUSWD/tRzVwll6mrfP1sE1Cj0xE9Rp92fCxqBGac0C7pO8ass0L3xqpzBZm5ZOcdjmi127F/IgdnaAgGHjc8ib2d2wQQxMj7IR2xban8OpMI/wTcjjjoEII2aTko1k/nj0N9oq+f49c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793217; c=relaxed/simple;
	bh=jqeK2Xe3FGIs2rwn/bNtK3Cs7K06X7gE3nMEtjWyikw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hrWHmUFJ0IvPi64saHl5kuHaNlO9qvNkWlYAvBwygHDtFW3RwJGV5JG5Oka5flEBGGc0TOc5hgJxYQjH110kBZSlyv8CeAJYgehlnQ/X7wsvGAqr9lvCdes1bJtVNSrTGp/jQmPYCzV7FAhOLvCZYsP8PscoqQbXfUdNL/tuzI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pSDa7aKs; arc=fail smtp.client-ip=40.107.237.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pSDa7aKs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywLFaqEUhBk8ffgsl4Kup4DuRss7I/JToCKNHL7KgVknkODdeID2zDLHzDdeltRNhqdQxLTOTHegXsi3NjI56xgUgdEZvMGVMom0lous4q9V8cAttyC7axD2Jmw1YuOHXuH9XX5U+anxXeYbaIXO9unke2CJFJowa0Q8xuEuYd4uIAWxZn6q3RvCf6ME5Bb1H3HySH+P7Jcr4fuEz24tK/hC6uGtytWvcztH465rF0rEsTZyZ5lsj+VLRfEDRsO1bFzR1PPcU+It59gT3N6fH1TX4imQfcTs2P5tGaD3MxBbqoiamKOYlg6wznXNs3mer6CxEoSk203ZYzoiW+wu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqeK2Xe3FGIs2rwn/bNtK3Cs7K06X7gE3nMEtjWyikw=;
 b=Lcr7lpI1TdkcXnkgFdd47cpe4e7qAGL7aDYIOL2cBCIwHF1zQCvxa26yPh6bpVoHEYnKgY9sLEptCjMVH1NFqIT2QdblSVVXywUD1oQIPoOeNELoex7M+DqMr8rfjgzv5KrYofywRJS9tGdZZcPO44Ip7fFsTMgHU7653T7cipdZNG8tPp+oaamDH9XUWJ14qkqGjxJIF5iEe5rjhyKRt+ZX8mlnbTlxBEh8qRtN+D83fy/pD0TOGeUcXIibhyurWGrAV4F8krqrOvklNn0jYoEI12enlCSpx5q8KLQSKgQvciH6u8Vyrn/L6JbKUFLxAiQgjIa7Fa9T63xIP0X1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqeK2Xe3FGIs2rwn/bNtK3Cs7K06X7gE3nMEtjWyikw=;
 b=pSDa7aKs8S2YCTRERVKrc3k+pn5T7zBmwS/LeMS7fPmMLB4oruNwjtm0VV05oXsl+QC1BhjqA7UTpxinPLbstwEPohgSpeXL6Iu1jZomFJBRkluhxp4ZhtkuJAynI/F+fT5mkw8LwSb8G7m4HVyGIgTZ7iP7HsEdJ5G8LsuLpIeSZtrY7WVjO2LZL81T2eFK3bZbt6e+18s2HeEUghS97wZhAcpO6dA9r3r9KgbWMozeiOZG070VtDKWTfF2rDicQYL4pDKg+92/HtstFXibwFvL5c/Y7b/V2vi3MjNO7pI9CZq2EGwOb7vGRkVdNFdccX2meBeutumLiB9ww8o4Nw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA0PR12MB7577.namprd12.prod.outlook.com (2603:10b6:208:43e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Wed, 21 May
 2025 02:06:51 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8699.026; Wed, 21 May 2025
 02:06:51 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>, "qperret@google.com"
	<qperret@google.com>, "seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v4 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Topic: [PATCH v4 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Index: AQHbx7hxcDGXhCOZj0ygOAdfmVH2ObPbxGOAgACDZAI=
Date: Wed, 21 May 2025 02:06:50 +0000
Message-ID:
 <SA1PR12MB71993832D917DF3FFF87D541B09EA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
 <20250518054754.5345-2-ankita@nvidia.com> <aCy3OwBe1HLa4O-7@arm.com>
In-Reply-To: <aCy3OwBe1HLa4O-7@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA0PR12MB7577:EE_
x-ms-office365-filtering-correlation-id: 9362a54b-4efb-4014-5724-08dd980c2685
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?aggQRecADEKaSNVR0BpLEKc/GYsAQhZsnVsTmotQkcY0kYGWDXO2aU975x?=
 =?iso-8859-1?Q?RzR+9IgBz0u84dAOtij6vbqN6PyI/xHHSfA0HxzC1Jpy3V7tWnZ/hs5Aw3?=
 =?iso-8859-1?Q?qTO+3WASplXsy2U1WfJLspoW/E33m8bElM9i8GzHR8SCLBlAaX35OeQ7Ma?=
 =?iso-8859-1?Q?o90DqbrWSm/VAmdFu0RIeTSP58HD+Plvw6XGFeAD2siukXJ5KDEby9nqwk?=
 =?iso-8859-1?Q?uuXkzYhJVF8XvR5Yx9fwAJc1qFIgy1zb2NhhC9B6p0ccK9XKU5FOR8vV55?=
 =?iso-8859-1?Q?Hx5X9ECGyyzno5TF5mJ0Wn+E3UY+9d7e559bjJWxudlQo6BpaAuEHentGC?=
 =?iso-8859-1?Q?ht84fiaWm25MndTdLFEqFKyWdro8vDVSZ/D164md/nOBJeLjMTc1uu5e6L?=
 =?iso-8859-1?Q?tOx1/lCS9XAvNKPXQduuX+Jr4QFg70upK9EbCaaYyPxrRicxSJ9WYo8ZDy?=
 =?iso-8859-1?Q?J9tChZCq0caYL62/8uW/lHXPcA72i+wKl3eeK4r8d9vsE+bDRJk/PuNVZT?=
 =?iso-8859-1?Q?f3sQ/qrpDLwIHS2ZrVtEy0izhg+WYeNZoPUdGVUWZL9IejHqSaMBYrF/hM?=
 =?iso-8859-1?Q?k6uvyG4ZXmUgBEtFIy0S1x1CWJAhI2gXjGQ2iZbPSmAKG3NcSHtsVA6w07?=
 =?iso-8859-1?Q?TtVp6t4bCtc7afWTppZbaYecJH99oGKITwyVzi3hq+WwmWKXZHl9vYeKUh?=
 =?iso-8859-1?Q?5dQhk8dcmdQPIAh4Y2QLOOpAOGxPGnhr+XdxUyT4giNXEbN0amHnpJFXJs?=
 =?iso-8859-1?Q?j4jcKQEI3HEcwFuOKpGUX3mK8MWOTXlH5jQ6HZeW2Tr+TepeIBBT3k51yP?=
 =?iso-8859-1?Q?ZyFYaLj1bCl1oOMT0SSU/a2CJQxD+pfobMUuYSjX0Vurmr+UPDx2b8LJC4?=
 =?iso-8859-1?Q?CE8mMbE4SZyDPNmmJoTo8BZZEXsfcq0C6LAN1BpogyN+o88N1u4Ood5Cs+?=
 =?iso-8859-1?Q?8uF4SAwdQVimvSHNIZ3arnz/Y79Y2HhGVJpCaEwshMC9tQdSZ5lRUp18fE?=
 =?iso-8859-1?Q?gNz+8Pxhn9vsyiwi862nFlhmWd7kurr0WQo8x0lRGBRfYrQ4poJjxQWYsR?=
 =?iso-8859-1?Q?TleX4DiW/9hCttBb5927vx8IX4as9LZUrTvgGlpVFAwAtxok77sCGdqk45?=
 =?iso-8859-1?Q?nMCBiR9M20vFAPudHZ62ZjfceiBDQZSzXOFcIvwJ7Arfpkr4AgklrMctRe?=
 =?iso-8859-1?Q?3QjJGrgaR2n/6o35r5hSm8nZZIRJTMrsan/77S2rV0Jso23kiW2jVlPpSz?=
 =?iso-8859-1?Q?LA2lQvTP02FJuW/7xtWQlyr2dTiPZ7okyfCDnLaVT3ejteAMcSKfbOnJge?=
 =?iso-8859-1?Q?WPqb7tKVCPx9YSpUT0U0SN1mhwUTk/sTCijBOnhI0upXFmW4IUj0c1Onup?=
 =?iso-8859-1?Q?DCU6EG4WjHD9tJkVt0TO0Zd2HHaUfdNy0+eI54OsA5IzctxLNDHtmqLm0C?=
 =?iso-8859-1?Q?fuLGLjT9KPC57g6vRZSXG0CwHTSzpIoZzP5FmXHDLuOZOq/QRyaTfmzghj?=
 =?iso-8859-1?Q?nRL0Ae4/4mnf/ouU/KPfgpfhhfKVOD3n6V9TAtbKubCg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?sxp6WtDXNA8IK4OFkYJ4knPdOSjuSKTko+6EFhpE5cur9wXgdyi/x1KjOo?=
 =?iso-8859-1?Q?DT7W+nWWt4XB+086zpA16O9e7YfSwRld9L16Z3FTkUTYwgmUedhoePfUSI?=
 =?iso-8859-1?Q?MljWIA4p4LWEe4w5o5xgU/cPnv7oKFCGwHIY3VD1A9Q/KC4ylLdixOfy/v?=
 =?iso-8859-1?Q?eYkYJCLMC2DOr/qB8eNCgIDfcs4kI6Jst1p8HvIeEmhA7O6WnVhYMj/OtI?=
 =?iso-8859-1?Q?7R8WAcPMIbtepiZLnOUrk8Y97p4dDyHLAxRNZVOknv0P4W1oxwwuffTz2c?=
 =?iso-8859-1?Q?ts51RgqM+9TPXmgJO8xIoMg5f4/LMSlRXBYMnhhM4HCjuXYLA8ZgqYN0WA?=
 =?iso-8859-1?Q?/udrEPvl6Rox8t0ehcsvOrRZwmMyWPML7CGocACzQN0+mpzJhfkqFXj7nH?=
 =?iso-8859-1?Q?LotmPVAnIdBh87pl9MpQ/xs57KawRXnQMfO/pYMhJaMACEQW3jiez5IPTJ?=
 =?iso-8859-1?Q?ww8GaAj6T/UpeEQfznhF6NCfF91gOvsPTSEtre3Q63Qg1jzTaOQWn/QdAv?=
 =?iso-8859-1?Q?+P5Pswlt2FRtMo8gJ+yrNKvgXhKBctxv1Q7/OKWnzAWaML4af2122vILUN?=
 =?iso-8859-1?Q?ybqkqVIwulBqMz7G4TbqNlauMOjoHGN6RTzg4vVOT/UF0n2K1FFOv2K6wb?=
 =?iso-8859-1?Q?YoOjIpuAvqk4Q8O2HXwxGEYNRwwtfeEw/MgdlrrJu4jgP/hg+0WuSSR6l/?=
 =?iso-8859-1?Q?vKSOKqRXAV5mwFaL4OH8Xkwjvai63W77RHnYl1VEhBICpRjGt7+ztet3hb?=
 =?iso-8859-1?Q?qaARa7UhPyANLMNfJDUaegCQK8bixm6v1f88XxFuQTiknuRhYpUDjCeBr0?=
 =?iso-8859-1?Q?XoiqOPpbVUMmWLVE/x7UnnbETw/FtN8DTtIjWsjH3jSkjU/pR2G8XJlMFK?=
 =?iso-8859-1?Q?JlgVBjFBUho367MWprC2pB0PtorOHJxSi8pFmhpLVdA4UE2XtBv0y18c1k?=
 =?iso-8859-1?Q?OOzMi88Lttuz9FGAxJLkHwLX/mV8PF2WJ3cAKAqZ6YqHnorKZgNGKsyGGR?=
 =?iso-8859-1?Q?gFzCHZUqACCXEftfnj+DTNpvUhXtauxiN5Z8/oVR5XZylusAf5npoSdXay?=
 =?iso-8859-1?Q?jo8zeqcngJhMRZ+nBwt79gHpUWb4Z1EwBrNZAw0E80mlbIBni9xR+g/lvl?=
 =?iso-8859-1?Q?3CbQ44XFHXLqN4rdCMDaQR1OVQJD0Ec96Lq8IbCZm8CvcAVrE7nUWlrZEx?=
 =?iso-8859-1?Q?NTbUTkRORyN0hePaEsIF8FMEeSPX6B1M6nHxOZUBMZfc6Xg3pwhvT30M6F?=
 =?iso-8859-1?Q?WxILeTeteLZWUIQTjs3xnX8eULpZLf3pcYIV2t8mrrL1nkqpihbHpa89GZ?=
 =?iso-8859-1?Q?wM14vytwbRlKzo5IUT2/aKzIHSSCMUfpL807tpJW8QeoDyh6K/pYeOVwOc?=
 =?iso-8859-1?Q?pfpb4OVyilcQZmf+Yjyzdd6DEyjpFgOc9ZbgrUztELtow74eomsddJW2a5?=
 =?iso-8859-1?Q?vpEgtU5Datlw3NRtFlBktD4hRKlfuuiRmjxrq2a4vQzdtOA3JZ1rZzDUsi?=
 =?iso-8859-1?Q?IUhNvvLuLTRBI5kn0Q3/Ep33X1VPg7vinx8lh62Xf0HvF0RF5iiKgBXfwN?=
 =?iso-8859-1?Q?/feWLpZn0Xg5WHgm5j/o6s1dBK2EH+FVxHyzQMUBvpHwwau7WWb+yjLH9S?=
 =?iso-8859-1?Q?va5uBCq546UAo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9362a54b-4efb-4014-5724-08dd980c2685
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 02:06:50.9420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0Vky+oef0O2J8HtVtPMVP8a2YQHll+CngiDlP6ptKVyfnMxJHG3HPHAGmlSGYzF94iilv9I43qudTFDJ7WGew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7577

Thanks Catalin for the comment.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Cacheab=
le PFNMAP is not allowed */=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mappin=
g_type(vma->vm_page_prot) =3D=3D MT_NORMAL) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ret =3D -EINVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 break;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=0A=
> Should we capture MT_NORMAL_TAGGED as well? Presumably no driver sets=0A=
> VM_MTE_ALLOWED but the same could be set about MT_NORMAL in the=0A=
> vm_page_prot.=0A=
>=0A=
> That said, we might as well invert the check, allow if MT_DEVICE_* or=0A=
> MT_NORMAL_NC (the latter based on VM_ALLOW_ANY_UNCACHED).=0A=
=0A=
Ack I can make the change to invert the check here in this patch and simila=
rly=0A=
in 4/5.=0A=
=0A=
> --=0A=
> Catalin=0A=
=0A=
