Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.229.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795077341;
	b=lGktdtYNbh4rGQzw5AmD3HwBIQ2HxobLZg3SofrO7g2n17YB3vZReQGp9cB0oFm3isOF
	 72JDH5OWw5hH9Q7+EpcneglYrI9fchgZSkA24b8gf/qI9Vzq72hRfnQL8JJygMOH97IUW
	 P7UP6eaaYh6cr0zrHk4yJ/IqpnZfiqcHy3ik6OyvRjefsFflUcohxRDzJLWAz5few0Qr3
	 BRpFbZX9HnD4sflLNtm/vYsmUKh1AL6ivuNgqK1G1EDhqv/YguvcffwcnjMU63cgHEfKM
	 pFzMDPGu/Y8eZ7Tyyqu7agqfHgE+3QJ4dtoNPMFqgnLFOtLoODP9hfTZ7oQ6SIYzFjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077341;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Deferred-Delivery:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=SaYdoqg7mvgHERujdOBkXYQm33qbLayzE7KGVUUNiuw=;
	b=vY4AKNnTVie1raxduoDkcpe7zHhro2a1wctrD80rX/lN6yg6zaNfZnxTtOGh9G2slnna
	 G+OmCwvlrCH3RMX75sxeHu4pDuk2tL8Hs1zfZW0c4x5FZJQkfV/FwZIftEYHUgBVaMPuC
	 eHkK2d3BAMo9dmsyf6lgZsXFfg07SFBO3oOHGG7C0eYptxIdEIiX96zUNL/xjr0uu0DuS
	 5crRwcj4XYzbfZ/1ziBHeAdSgCXtba8MVxDZGJ5Np6H87PxDg+UfZHb+BhHhsOD7/0aDa
	 NcUBEEXoKsvDWcWyZcCwJgLrE/rMOO/GjQ8TBcox3U/ZEz3Q5QMBczuOXlAHesbP8mw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=B5uc7Yan;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.229.63
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010063.outbound.protection.outlook.com [52.101.229.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A9606A330
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 08:35:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E8A9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=B5uc7Yan
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FF92CD0kS/1gI7QeMD4pmgRzw8umTV0Hk2kf3p9lWM0gl3yyTkbOJnATn25gFevtvvqjmUC1ULzzdAJfL0p+waXZNK1WTIrxRrvHGvcvG23UWr5RtgFoIOQVWok0LRnEVkiTuXzPQLolQ6wrAbK313tW5U4V9oPUFGuHHIe0v+s7neO338FWX/T2ZRY07KQ9rG/TqkaAozs8k252+yNZCTMEvtMPgbfQk5Nlz0Qbb8gwSr7nYFg44BHLvhNrm2qNXM6dQUbGkjElRgWywhtGkw8IGZuNWOyDlQ7ERRZsnEE5/0LaSUahExihA6B4nSGbVqUqbWU/VRT0Xf488kVn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaYdoqg7mvgHERujdOBkXYQm33qbLayzE7KGVUUNiuw=;
 b=LveaRtgaFP01XqkHCGfaDwHPrB53/CQraPGyKejfEVzGQHLC5me5pwNm4k34nbNJBCeYbQIgAHjnAqJdaMv8XRBO7EBns5DY7lqtB0uTZeWhPxHobsfOZWwsseaV4rhGyIoNHOC1O6D8aB8+/KzXlP0zypNxQNmsGmXD2QCTFw8pdRpU85UtYK22IvKamkQBIJoKOp3OOwASs8MZXgKYBOnjgnEX4WtY/nmRP9wborduc9fTQEujOXxC0wM5HLGl0d6bX5ajSlG7sZxlJvUFsKQIh81zZaIhFVMi3xMgQoIdrFEpTsWH9RXtuHzOjAM19t9nRAn98ITbWhtPJ7VLFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaYdoqg7mvgHERujdOBkXYQm33qbLayzE7KGVUUNiuw=;
 b=B5uc7Yan+xQrBQi+ik4lbtekPQnfB0Zbpopd1YDI3/nZ/UBFb6VhgXALSINWYhAYH1PHrUcrdw4EUipU4XPkclorAi5Yfo5B+SWktX7Vo8ouz6ogUi7kwO43ZBQBr5zJdsu6gzoi/aZqKLz/3H05xytHMejZYA+YvWrO8CG4WlOmDL7R2Fy9cztDlVoVC83lpBLY54vy98StxoqrJ+AP/95pM9ljALX8Uxlj8/dO3MVMGgQbvehGAcpg6lPXcCoGniygCjpg2drAQeYdkoqNKGWgRmziKdNPvfMEuumggPnMCjABLknkTbxtDYJOFCrX2E75si0wT2XRnfaSPoqv3A==
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com (2603:1096:405:290::6)
 by TY3PR01MB11383.jpnprd01.prod.outlook.com (2603:1096:400:375::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 08:35:36 +0000
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793]) by TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 08:35:36 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Mark Rutland' <mark.rutland@arm.com>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Will Deacon'
	<will@kernel.org>, 'Jonathan Corbet' <corbet@lwn.net>, 'Shuah Khan'
	<skhan@linuxfoundation.org>, 'Randy Dunlap' <rdunlap@infradead.org>, 'Marc
 Zyngier' <maz@kernel.org>, 'Thomas Gleixner' <tglx@kernel.org>, 'Radu Rendec'
	<radu@rendec.net>, 'Oliver Upton' <oupton@kernel.org>, 'Fuad Tabba'
	<fuad.tabba@linux.dev>, 'Joey Gouly' <joey.gouly@arm.com>, 'Steffen Eiden'
	<seiden@linux.ibm.com>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>, 'Zenghui
 Yu' <yuzenghui@huawei.com>, "Kohei Enju (Fujitsu)" <enju.kohei@fujitsu.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-doc@vger.kernel.org'"
	<linux-doc@vger.kernel.org>, "'linux-perf-users@vger.kernel.org'"
	<linux-perf-users@vger.kernel.org>, "'kvmarm@lists.linux.dev'"
	<kvmarm@lists.linux.dev>
Subject: RE: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Topic: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Index: AQHdXVVbzJOi/425oUyzsr9T2p9p/LcAE4mAgAADN9CAABKyAIA1E50g
Date: Thu, 19 Nov 2026 08:35:18 +0000
Deferred-Delivery: Thu, 19 Nov 2026 08:35:18 +0000
Message-ID:
 <TY7PR01MB157464850021326AF18C13C5DE5792@TY7PR01MB15746.jpnprd01.prod.outlook.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-3-fc7ede7f9f48@fujitsu.com>
 <atIT0dmeqAXLoThW@J2N7QTR9R3.cambridge.arm.com>
 <OSCPR01MB1573944ED57DC682897594F06E59B2@OSCPR01MB15739.jpnprd01.prod.outlook.com>
 <atImMmlBmOYlY5T2@J2N7QTR9R3.cambridge.arm.com>
In-Reply-To: <atImMmlBmOYlY5T2@J2N7QTR9R3.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=2c15a8f2-253b-4374-986c-294c68c2040b;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2026-11-19T07:59:21Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Tag=10,
 0, 1, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7PR01MB15746:EE_|TY3PR01MB11383:EE_
x-ms-office365-filtering-correlation-id: a4417432-3efd-4d0a-db05-08df4618154c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|6133799003|1580799027|11063799006|4143699003|5023799004|56012099006|10067099003|261026140227099003|261026121527099003|261028144727099003|261021123027099003|261022105027099003|261021121427099003|261022075727099003|261102123227099003|38070700021;
x-microsoft-antispam-message-info:
 +ssU2MuIkDt7ZF/Dpoi3KaNg2W9H5wIfQaWfeltxGPxnux1Keb1NcQbGAIDUD+jln/k/FU1iD2Mylr1eMbJQHe/1Eixqv4bSQCG6mlC4Bpu7TlSPS18TS7HBVprXsADkN7LI5408fu3udq+qiMnhT3rP8UyKMrK00Iw071cVbgjp8spQJqlnqbXCYzOkNoE12ia3dH1cUbT3thkDLFzpJMKna0Pl3dqae8Tsp2ig4V8BPcvl/zR7DGHnhh3yct5H9xQk5nrpkjpSXuR72frCG9AA0qZbXtXyw7OS/2wrbl9xTOo7yEufUECNw8GmSFjkf7v2KXWZ1RTBwtY84TYWMttGrq75C7ybCTrbWzOv9F37yqaWKV6aiX27T1/o3PCeBn+ox8Gew96ApK9kI/fRFH1yfAaJcaE9IpKPoXTfC8C1VREFYFZl4Jd8Y3IaUcxqOQ92btPnFDvGn26ZTEWc6EvrohbUXPrtbaKuiskAuAyBUZb5WtIatTnjfuFbcr/ZU+b/7fDuUjt0sdRLhxVyamrOM+cmKnwkDwH+MBFqHddoOlWPWjeYR2lG4UL+c2uytl1yfyNVstI2YmXNnOTVp4UInFJB6+5gb3rAjWizU4vhdAJY+ChHhhSYcWGCphp7YanqwaE0Le547c2LWV77E9ROkaqVktHndjdZsgsLl926wHJgGcaP4CNIdPTz3bboimnVDrqNe+as9zUWPNOp3HfWpBpOsxi+IDJyLrMORzOHKpN9qL1MpxpGH0BJU6MS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7PR01MB15746.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(6133799003)(1580799027)(11063799006)(4143699003)(5023799004)(56012099006)(10067099003)(261026140227099003)(261026121527099003)(261028144727099003)(261021123027099003)(261022105027099003)(261021121427099003)(261022075727099003)(261102123227099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?NTEzT3g4bHh0M0JsOWVIWWZROTd6dU93YlVOa1J6Vlo0U2R4a2FzM2Jj?=
 =?iso-2022-jp?B?NVdMcGlqMjdwN09Ydmt0bFV1bHlsblEva3MvUTZyQmhEaGhQRWJIS21E?=
 =?iso-2022-jp?B?Q2V4cG9xbFE5UlFFa0tRODJYVXBpSjdORTUvdElpMm42RGwzQk9yQlFs?=
 =?iso-2022-jp?B?STZLOVhWb2ZlTzFDYzJ1KzZOMlRJNUg4VDAvTmdGWUhnVVlLVklMakkz?=
 =?iso-2022-jp?B?bDRDU0pWMmNLOUgvZk9rVXdkTjdxNEFHVWQ3YkQ4N1BrT2FYVW9HdlEv?=
 =?iso-2022-jp?B?UHRZYUUwb2RTd3ZYUUJkY3dpcWhNZzNYRmt2eENGKy9mVWp1ZlJybXBa?=
 =?iso-2022-jp?B?UGZVY25QMGxpNHJsOWtZa1BZUEJwZjBMNEdaNVM1cnIvejFJZEQrdFdk?=
 =?iso-2022-jp?B?eitESXoyOFhFaEl6cnJjY2s3a1BRaFpVNkFKMmlQZ29xK084OGFBMEpp?=
 =?iso-2022-jp?B?dHFhc0xTT1ptcy9zb2xQNXhPYkZFY0U5L2t6UEVTalYrMXl5NWxUN2tu?=
 =?iso-2022-jp?B?NXA3bW1ndVBkR1lzSVBZWkRMMWJrZzZQeFhRR3RFT3NIbk9ZdXJpZU5a?=
 =?iso-2022-jp?B?Q2JMWnd4YUpVTEc3TlFGSXBxeWh3ZnM5Sm9VaEV2Tm5QV2lCQXBwbnA1?=
 =?iso-2022-jp?B?RDZLak1uTnR2YW54LzVlS2lMeTl5d0VRNnJ0QXBTSFdZUkliQUQvejRp?=
 =?iso-2022-jp?B?RWRhaHNhQjRBUGZZMTdqN0lRR2hvVUxsNVo4Y3pHL0l1ZUEzcm9aelhl?=
 =?iso-2022-jp?B?eVc3amxTN2tVR0R3S2s4OU56VGNQNTVyZVltK0RoVWswQndPUkd6YVc1?=
 =?iso-2022-jp?B?UFV6QTdjTmtMUFZzQStjS1IyUXd2OGR0VDBSRDNhOTJpbURGbjVINFMr?=
 =?iso-2022-jp?B?UmNUMllOOTBZNVJMS2JkUUliUHRYOTlhMHpsUzZJVmdvcExRTlNsY1V3?=
 =?iso-2022-jp?B?Mk5rQi9ET3BYZTRqYXcvMWw4VmF6TXpsN3hPWmRqV3c5WjRnREhLanBJ?=
 =?iso-2022-jp?B?bHVxK25VenRlL1E5aVk5UERnWGg5L21KQWxRUkxxNDNjZHhWblIwUW5U?=
 =?iso-2022-jp?B?MkVOYmV1dUJBY1c3Y2hSTDF1SlIvTGZzNlRGeTVVbmE1NFZpVmtkN1Bq?=
 =?iso-2022-jp?B?SXhyd1hUTzBjNWNwemptNCtGUDgvN3lDa0Y3SDVSck1DVERNdzkrS1hJ?=
 =?iso-2022-jp?B?bVhiY05nVW81V0R4eDNua25lak9OcmQ5UDlOUTJxeDZsL3JNZ0JvVHZ5?=
 =?iso-2022-jp?B?RjhwZktraDF0L1BFNk9HSEk0ZEl2NkdwQm9WeTlDd0VJK0lnOHU0ejUy?=
 =?iso-2022-jp?B?SUYzWTdMdldsdCtkdkRTS2tkWUQ0U0h6WGtKWjRLcml4VWp3YlpkeTQx?=
 =?iso-2022-jp?B?UHVoMDNvemkrUzBJSVhsUXoxRy9FV3pXV2hiY2ZzZ3MvYmpjdlBmQlBq?=
 =?iso-2022-jp?B?amZ1NlRtc0VKSHdzOElnRlE3MDJ1cVhtTURRd2NwKzFKOVltZXVuSFpW?=
 =?iso-2022-jp?B?OWkrUlcrRkJNUXF6Q1NUREVXMWY1YlNpZEV2UXpHdGRXaDRMRnBIUlBn?=
 =?iso-2022-jp?B?Q0tkUVV3anoxQU8rUlpzblc4SmFxWW9PKzF5UzVsdU82UW9ZQWFzMXRt?=
 =?iso-2022-jp?B?aCtzRCtsTGp5WmVxbUp2dDRjSW5TOGJZOFJsV2N5TUwrUllMWUN3S3hM?=
 =?iso-2022-jp?B?MGNMUnBBNnZWSmlzVWdUTWxYbWhCS0JUNzRiQ3czZTdBSHBlSTdhL3Bm?=
 =?iso-2022-jp?B?ZitEQm1mUkFDckYxNWdnOGdGdkVCVkF0clNYWXNPQVBuZGo2NEFqVGZJ?=
 =?iso-2022-jp?B?UjMzZmE3RDFYeWt2cXRzdTRjVEZpNVFrMjlseEpEdnZ3aUR6a3ZaNXNH?=
 =?iso-2022-jp?B?S0tWU25qc2VzRlNsNDBLSDlyZ0FZM2RaQlNpOXFQN0pOQ1Z0VURsTXFi?=
 =?iso-2022-jp?B?SnBLeVQvaG1oZnVVZWhVTWFWK09kdE4wanFxYkF3ZHRwTk9sODk5aTR3?=
 =?iso-2022-jp?B?SXpnRGsrREFUbzRBN0hUR1RkYm1NT2pROHhPdjByaEpiVndwZDdTL2N1?=
 =?iso-2022-jp?B?TkQ3L0kwWStTU2Z2Vk9ZbStJNzdkWFRmS01kWHZ2QTRnK3VKRlB5T2NZ?=
 =?iso-2022-jp?B?Y2pRM3J5bDAxUmsxRGhKM1ZCZDd6cXdPbS9HL0ttc2txaC9zMTFFNEtK?=
 =?iso-2022-jp?B?cmRTZCttQnlqYW1yQk91MG1kRGVFTlRUaWRjWnFLZzZCVlcvNmtLbjk4?=
 =?iso-2022-jp?B?K2IzL0MyeXNaaEN0bEdpRk5vbDhMcnN5SjhrQThYU0dZTUJsMEZBTURi?=
 =?iso-2022-jp?B?cUYyZXdBWDB0UUxvY21Ha3hYSWlkK1ZrTVlRKzVTcmRJRUxpUG43c1Nh?=
 =?iso-2022-jp?B?VmlGd0hCdEZoOEpVZStFZEplZlJ5RGNnT3BhWmVudFJLQ2kza21lbHZq?=
 =?iso-2022-jp?B?NWhzVGtMejJJL3ZacllxMWhia1FQY3lKY3IrQW1FODNoaURveDJFenNC?=
 =?iso-2022-jp?B?OUtMZ1kwR0V0Y2NtYm5MWEh0b2NhdGsxL2dnUDZmV0ZtMUdqQjdxaHN5?=
 =?iso-2022-jp?B?Nm13UXNXWT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mrVISuhmmveSPcAtmcaCMf7LkqFl2QCVwTHleBAkU9mmomTmZWSa2bEvMKPERmy2GiQURmtpIL1n5phP/kmB1u/6hJeBo5RZbAJja6py0hjnzcacnv2lyifdnWjUNoChDaJIA2o+MWrlOg0Aasj6g+tY5YljELMQL4O6gB0Ve2Ag9uT6r8PN+KMA69OBrmwy4yioI4Wi6zytO/ia3+pg4QuvymBKNkb2QcLzAxERVknhah675mkFckQqBwikujHabOOG5QZBAaI4nyju9m9WBnUWwC+bMPQvIt8oEoUlX6NKInxTa6Z5TvxJOfPmbP81qvHSX8s35/cd8BWW7lgemQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7PR01MB15746.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4417432-3efd-4d0a-db05-08df4618154c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 08:35:36.0288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWiTR0ZhX6uy4GKKbL1Yn8nSJAbKw1zZJn7f0gnUCfIj/dUNQtll2f4HZCfaHILXjAFGXFibnhOHp300tOz1FCxcLC1g63UnemtefFqI2fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11383

> Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MON=
AKA Erratum E#030002
>=20
> On Fri, Oct 16, 2026 at 01:00:13PM +0000, Tomohiro Misono (Fujitsu) wrote=
:
> > > Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU=
-MONAKA Erratum E#030002
> > >
> > > On Fri, Oct 16, 2026 at 07:00:47PM +0900, Tomohiro Misono wrote:
> > > > FUJITSU-MONAKA Erratum E#030002 affects FUJITSU-MONAKA CPU.
> > > >
> > > > On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
> > > > stopped at a value just before overflow, an overflow might still
> > > > be incorrectly detected, resulting interrupt storm in some case.
> > > >
> > > > For example, if the following conditions are met:
> > > >   1) Running perf to count an event in user space only
> > > >   2) The event can also occur in kernel space
> > > >   3) The counter value is set just before the overflow
> > > >      (when using the -F option, initial counter value is -1)
> > > >
> > > > when the kernel is about to return to user space after enabling
> > > > the count, an overflow interrupt is incorrectly triggered by an
> > > > event that occurred in kernel space. Since the counter value is
> > > > not updated (correctly), the interrupt handler does nothing and
> > > > returns with the same condition. This leads to another wrong interr=
upt
> > > > and results in an interrupt storm and eventually a softlockup.
> > >
> > > I don't fully understand this.
> > >
> > > Surely the relevant PMOVS{CLR,SET}[n] bit set as if the counter n
> > > overflowed?
> > >
> > > If that bit is set, the handler will certainly do *something*.
> > >
> > > If that bit is not set, the interrupt shouldn't be asserted at all. W=
hen
> > > does it get de-asserted?
> >
> > Sorry, my explanation wasn't clear. The interrupt will be de-asserted
> > as usual.
>=20
> I'm trying to work out which of the following happens due to the
> erratum:
>=20
> (a) When the erratum occurs, the HW sets a bit in PMOVS*. An overflow
>     interrupt is asserted because PMOVS* is non-zero. The overflow
>     handler will see that bit was set in PMOVS*. Clearing PMOVS*
>     de-asserts the interrupt as usual.
>=20
> (b) When the erratum occurs, the HW does not set a bit in PMOVS*, and
>     asserts an overflow interrupt even if PMOVS* is clear.  The overflow
>     handler might not see a bit set in PMOVS*.
>=20
> (c) Something else.
>=20
> Can you pleaes confirm what HW does with PMOVS* when the erratum occurs?
> I assume (a), but you haven't explicitly stated that so far.
>=20
> > The problem is that armpmu_event_set_period() will not update the count=
er
> > value if, for example, the counter is -1. Therefore, false overflow det=
ection will continue.
> > With this patch, armpmu_event_set_period() will force the counter to -6=
 so that
> > false overflow detection won't occur in the kernel, since the maximum e=
vent
> > count at a time is 5.
>=20
> I expected that were this to occur a number of times in quick
> succession, the core perf code would throttle the event, and adjust the
> period.

I think what you mean here is throttling in perf_event_overflow(), but this=
 will
not be called in this case.

In armv8pmu_handle_irq():
```
        if (!armpmu_event_set_period(event))
                continue;
        ...
        perf_event_overflow(event, &data, regs);
```
perf_event_overflow() will be called only when armpmu_event_set_period() re=
turns non-0,=20
which means delta between the previous counter value and reading counter va=
lue indicates
an overflow (and therefore new sample should be created).
With this errata, the counter value is not updated, so armpmu_event_set_per=
iod() returns 0.

I will send a v3 shortly. Please let me know if anything is wrong.

Regards,
Tomohiro Misono
