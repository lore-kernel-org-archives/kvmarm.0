Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2FD230BD2
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793473; cv=fail; b=mGyYHXG5xjNeqHNC+pmFEJ7N/OCJSCCa7cYoKMWeVDLyIvlIVO+e8O5NRRZYIxOkEBa454jfgiTKqT80lanVSGscq3onyABfZPn8dfOA79/znaRsZ+0ji9ca0cw3TkJGsVNzwtVJIuw8Pcn8OwMdPQnXhYkCiIWvl98zGEWWU8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793473; c=relaxed/simple;
	bh=07uci2UoD8dBpxN94MVMZYoBhg6rSuhZKCrP9NFZHH0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ICMTQYVMLduUEDlcQmzs8KbluTMxZtvQKZNCCIJ9cEBIelD2hrBe1/0RsaUvAbRmcY798C4D7OsizOYuUHvvFT5KQ0MqxwT64/PL6MIJuSNmZl1aVl/DTvm5zaU2RTfvfx1M8jOAPbxdbSRx9mqFt0KvQg7QYdQknxrfRNnqqUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cu2/snR3; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cu2/snR3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elm7Cs07ximn/G1ooMzPAkY1tMpEDjO0AkSgRb/UF2h6MGqNywObWkMEHd/XJKDeOuWUsCN8QcgAu3R8V3U4kwIck3LGEQTKnbVtn/D1GcoK1byMQxLUkt/pp2uzBbkYi8qg8APfxZZHxKv07HnLevNl6qP3kK18XYjo08yaopwhWSEuVMjV9ZD3XjpLGvk2TGXa9fNRmA9K3eR9fS6kzdUMJtZq2RKkZpvfzove2KRoxd60DyYAsK41kTDN0g+PjhVYiK96h90zpYklRwZB920bL4UPDbeicarzOrFC1wFQ32lcktlBuiLE/0X5Vswj+nWAe+g+iN5qXpdI0cU4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07uci2UoD8dBpxN94MVMZYoBhg6rSuhZKCrP9NFZHH0=;
 b=ghqS1UguBGou4MrF4sSLtMG9zjBdui8LnVA8/YTkPHsU0eUH7SYyQNY0lLD1DBhUBs+WW2p8fFSFZNNmVDQ6IG8xanoQ9xg+e1pdj8GSPg2R/Ilpj9J21R6XOTBX8PjiIEhxB2fW1rTd1R9qjKbtNcmpgb18h9fchE1HNtO552+L6lA67cgpz95zn1nYRvE0Fp4tUu3aH99dLbQbedoxOneKXbw4pST9BS3B5QtzwJNbbsfpW3lXJxP7vfJXr89+sTys6yyc/kkEmgAvPAWkEwDkfQlb8F0KAVuHgRrqJ623zf27VhMtvvhKn1uxKED31rZZGmpuUDNbQl9AgcHxHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07uci2UoD8dBpxN94MVMZYoBhg6rSuhZKCrP9NFZHH0=;
 b=Cu2/snR3jsMWJJA1mwvNeJZHf3w10oyWPgUCK3TkIXNt/MmmYfoQnjJljv93o/cmyzLt+Qlgn2kb6ajTYsfRHbxA3GiMKE4SOmMXNNr8Il7trk9IVyLvzloKDSHIa93i866aT05+bVgW8hQXXGX5n80ZhvJ8fAmlq6o7Vbht2hde0nSsGRxHBVxZziCA1K2oaqWcqcsaeJeLFTWFS6L2+wPrhL1xABc+dgP/ghYaFc8cdVkL/G0b+gakrpTwSU3Q8wxbiBjMbC9yYrIorcIxHU6JYd1aoPR68twj69SzJLTqj+c+mUMKWKV7Jc2lrc4PTCrfu2B49EweoI+qGUVnXA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Wed, 16 Apr
 2025 08:51:06 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%6]) with mapi id 15.20.8655.021; Wed, 16 Apr 2025
 08:51:05 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "sebastianene@google.com"
	<sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com"
	<tabba@google.com>, "qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index:
 AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14ggAFVjACAATjx0YAGtS0AgACvDoCAAOaHAIAANr+AgABucICAAD0IgIAAg/iAgACoeYCAABKYAIAAFAsAgAAouYCACiALVIAAbFcAgAANkACAAAgBgIAAHy6AgAAGMwCAB6GYgIALBt6AgAAPgwCAAAfeAIANn5WY
Date: Wed, 16 Apr 2025 08:51:05 +0000
Message-ID:
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <Z9s7r2JocpoM_t-m@arm.com>
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com> <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com> <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com> <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com> <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
In-Reply-To: <Z_QAxiEWEyMpfLgL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA0PR12MB7529:EE_
x-ms-office365-filtering-correlation-id: 1b779678-3ac4-4dee-d639-08dd7cc3d302
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?D/ei9qzud9My8U/1mOzCUVuvSIW74zoImA/xPR3VlPOJsivsvLDmfjbajF?=
 =?iso-8859-1?Q?Md8JEQHdvkqiSz2WjpzvWpVag5yDAUVjjeELoBW34XDkglD+dovKgJNr6C?=
 =?iso-8859-1?Q?6QkOTdofbo1VYd9zmD7owrQ2DrihnTQ/it2QAxxONGS0JB6kNEaJMBhmQi?=
 =?iso-8859-1?Q?Qfi/vF4L5Ed3i0JH83zNK15osJ4vHFyo0XqOLd2cV8v1mo03rpe6pYY0Gn?=
 =?iso-8859-1?Q?nxS+o6yXY3DIHHZz2qwVGSiZLrAZRa77BBSpfv0GKN3GES6uj8bmb7lraR?=
 =?iso-8859-1?Q?LTlsSRpijAwU44P/6A5OoIJl7YapuYR2tDUV97cXHB2W/MlLLmf1DMx88k?=
 =?iso-8859-1?Q?yivkb6pmSNFWTgmewHN9jWiW3dKUhOm14AzBj4lGtdql7CwFaYzWdRA8a1?=
 =?iso-8859-1?Q?D5lSAm4VUNOQLZhw/bZo69KCPXakR1myBS0KfGFhzpBIaH5WGFIiu4ZFqd?=
 =?iso-8859-1?Q?CNAd133f5nHzrNfkLL0OY+3jEQr5WXfrTqDUdsr/2p17UkarCvFjPaiOQD?=
 =?iso-8859-1?Q?1onf4dQDvNgc0Lykea/CInnfR4PtsUy2rxwzouqR047Zqh2pV+LAxJrlum?=
 =?iso-8859-1?Q?CnqzKBg6oNi7A7Wnq+GahStXL4osXEOgNQ1Fxp6foi1frqQV3vXNI8UdtO?=
 =?iso-8859-1?Q?fFFB5tCsFy8GzOnG/oDQ7kMX4IyhpjVbPTqAZALlC757Bi4o5yKTSzxcVM?=
 =?iso-8859-1?Q?SyyaNu8S0dgKVIJoKWv2z4q5E80KCzf8aXrkIBWzy8855tdYpuAzYtWUSo?=
 =?iso-8859-1?Q?QLSCohlNRr/blzGkLhGtloyRP8vlgGugDb6iLFIG/ICElDR53fYCr9cFph?=
 =?iso-8859-1?Q?Dp1VJK7DJ/nd1lLewb3PAGfg63z6s+ZArjWi4NkcsWZIpq/4/0wVcbuSPX?=
 =?iso-8859-1?Q?bGTzEUHzzDI+syp0RA64i9pJq+uPdxU66WCmn8HTxB17srQl8/x9eAdxz4?=
 =?iso-8859-1?Q?eO5sU37kovFxLDY0XPDj+fELk2PI+497vunGwoGH5+623fdJQ5qq79QDd3?=
 =?iso-8859-1?Q?C6FHuo73V4f4iYVuYAeLTvhS0MYkZtNOtsBLU0T8tH3+gq9RtxuDdFRg9f?=
 =?iso-8859-1?Q?uFd9KB1F2nQJVc65Tsmx1x/HqJUurcn7cnioCfz8bVx0eYJS6d86nIqEbf?=
 =?iso-8859-1?Q?1DZKd4Moec651EaPTFBmlWHlw2C/K7quYnnMIYW1ivUydlhO2dE9c3H5dt?=
 =?iso-8859-1?Q?z/R59GSuV/vgqq8lYBZ//od9i9bi3f7N8nINzwOp0Hl2CWHcWGB7hxbJJI?=
 =?iso-8859-1?Q?g/ZuByT82rQfNAz5M/HSBo9PhROI813Ms8YlUorrLSr6yVlwt2lBBoqho0?=
 =?iso-8859-1?Q?vYQaERxhApfIFGYndMjaHpYfvlWDXNha32KK5qAIX2WO2TdTzJJbwoU3Zv?=
 =?iso-8859-1?Q?0Pr4Az7ZGYoylgqDWpCgizAe0mZW9DZp0ss3q8WaYC0RkI2gaEBlXPCnWP?=
 =?iso-8859-1?Q?BN8cq2/6G5OWvQoI5C3mJB7zdJldX2azw+9arEqEYGGicfnPwdGvRFbNsa?=
 =?iso-8859-1?Q?ZPOCmzCWhIPe0CMxXYLNNsEjOZ5CyjWCbVYuH6Xegxsg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?IcJk3DhT5hM4TgarFAL85jMMailZcLNo7KyTCvhbKtkshvb16Bk+w48Lzz?=
 =?iso-8859-1?Q?A2An5Lty7Ij6bYAQfdzPwZzar1tn5I5KDhgOJUl2CpjD8z6oTFWuw/Ql9H?=
 =?iso-8859-1?Q?tyTqlt72goPyq1LOc0UAfvLMwroj2kK09UiA07+1jO8kpC9W4Vv5dioB4p?=
 =?iso-8859-1?Q?+OgjzpyPlEWks18KMe3GMEVTWzScx/H0yLnwrNGqR3iR684lIZ1ggmbiCS?=
 =?iso-8859-1?Q?zhHmBeZY5Us8TiZDO1fzV81qPsarfL74DrxUsB1xv/FFUja4GKxz7Lm/u4?=
 =?iso-8859-1?Q?G+y2+FRQzt1S0e/p3PyfNkw40LdLlKOBBweKCo6yBHzO4kzlFUDCf0mRfQ?=
 =?iso-8859-1?Q?e3j7uoGY5PXyuoWOOsqMGihXhjoXcA7BpZiFC26Roa78mJxKEwSRBaR9u9?=
 =?iso-8859-1?Q?aUzxbijF6XrkQZfYbwZmqtzP+GIM0FG9Ge5oTmY8MblmLQ8hVfFdk0XPN0?=
 =?iso-8859-1?Q?Z4fXjhwNkx9/g9paX4uDjZrSe+6J1N8Q0b/CSDMfEACbR1iVVFBn6UA/1W?=
 =?iso-8859-1?Q?Bms8UMujGBzr3pCB1CF3sBdguBvX9ziWDeJCEjvdmI6dCux/SAziJir8d3?=
 =?iso-8859-1?Q?Q8jjQhRLstmbx3Er8nAxW+zybejeGgR13QMHL9r0wpn4lrEP6saDIX2ia2?=
 =?iso-8859-1?Q?H1tTFtwil8dNgGfi0iXV4LxQlISjGVl5Go7yUJjPI/q9/QPmsJ7bsgVWm/?=
 =?iso-8859-1?Q?hYK4OeX8iAKWFstM53cOJHNR1zGchFFBfYB/UXybSCcWyHv5w2QQbOkNxT?=
 =?iso-8859-1?Q?gmko8pfofkVvHXEk4c6gFCzSEB+3IqV1rK3ZTcpqSL6VyUVQ34DgS38P7j?=
 =?iso-8859-1?Q?B6DrYDKegNtWvadndt2ERulLdf2nZrGBkMNzLE9d5e35ZOFM6IFZuzBQzm?=
 =?iso-8859-1?Q?kDPPcT0smrnvSwEn/qP1mbVQj6xvz/wZIb99k1fugYyUfmfvET1T8TFYjK?=
 =?iso-8859-1?Q?FIlzpGMN3j5PPqjaG+cfIhgUpNptRJoI53no3dyI/62peEB3ERg/PXlkvX?=
 =?iso-8859-1?Q?Xl3ZwwdqnmUrNjWPfu1sV4sNTsLlcXC8AtsJmnuE1XptYCgMUu2m8ps5jN?=
 =?iso-8859-1?Q?BDLxxk4w1uqMBUjHMmgUp9i3mgCY/2aIVqscaTM8+FURVYK+mvtzjiYjYU?=
 =?iso-8859-1?Q?sxJBYSBCNPuhEeTQTGZ34zhIk7BuC4SUf82TkrHCXQz92gl/rRJdMWdioE?=
 =?iso-8859-1?Q?gsOXNyPZ4b3x6noif5N1lwmVnJscO7q0qpjGr1hl4wDBzemj3m8LEdsfTw?=
 =?iso-8859-1?Q?HtHJwx6I92beg7d3935i3KkGvqJLL00aRdZ+V7h7E0PB0+b0tyutveixVl?=
 =?iso-8859-1?Q?QyXEcnf8KzcQK+iObreR06NFggO5svM7YM4wE3knegnrzLpC3QqjUS+cEg?=
 =?iso-8859-1?Q?PMoOdN/00fOQFJg/ZCOlz1zCrsAdY3pDJUuzk1TPSDM3ITxZU5CqMCv/+s?=
 =?iso-8859-1?Q?26eGocyF/49V87//dF61v64NqI8m+HH6eG9OXiX+hj0v/5tpOpv2pexO1y?=
 =?iso-8859-1?Q?z85z7iSRrGPXiPqrn1q96w7NDKGyGM8uSFT+1jrwNWY6sRCZyuYqOWIg0g?=
 =?iso-8859-1?Q?llY28EEyyO0ZQs4PSDH6LrmdyKI78KJqaXi1wToDl3o+ci+EeO9qTwpmCs?=
 =?iso-8859-1?Q?hGDo5WcZJEKx8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b779678-3ac4-4dee-d639-08dd7cc3d302
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 08:51:05.6805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0J7CMfd+RxuedKemwXYUacJsHH+DhA777vgCtT8be9JOGNiuFyWLflkKp2vT20UVH7390UhF6Uaa7hTZNYc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529

Hi, summarizing the discussion so far and outlining the next steps. The key=
 points=0A=
are as follows:=0A=
1. KVM cap to expose whether the kernel supports mapping cacheable PFNMAP:=
=0A=
If the host doesn't have FWB, then the capability doesn't exist. Jason, Oli=
ver, Caitlin=0A=
and Sean points that this may not be required as userspace do not have=0A=
much choice anyways. KVM has to follow the PTEs and userspace cannot ask=0A=
for something different. However, Marc points that enumerating FWB support=
=0A=
would allow userspace to discover the support and prevent live-migration=0A=
across FWB and non-FWB hosts. Jason suggested that this may still be fine a=
s=0A=
we have already built in VFIO side protection where a live migration can be=
=0A=
attempted and then fail because of late-detected HW incompatibilities.=0A=
=0A=
2. New memslot flag that VMM passes at memslot registration:=0A=
Discussion point that this is not necessary and KVM should just follow the=
=0A=
VMA pgprot.=0A=
=0A=
3. Fallback path handling for PFNMAP when the FWB is not set:=0A=
Discussion points that there shouldn't be any fallback path and the memslot=
=0A=
should just fail. i.e. KVM should not allow degrading cachable to non-cacha=
ble=0A=
when it can't do flushing. This is to prevent the potential security issue=
=0A=
pointed by Jason (S1 cacheable, S2 noncacheable).=0A=
=0A=
=0A=
So AIU, the next step is to send out the updated series with the following =
patches:=0A=
1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_reg=
ion)=0A=
and during fault handling (user_mem_abort()).=0A=
=0A=
2. Enable support for cacheable PFN maps if S2FWB is enabled by following=
=0A=
the vma pgprot (this patch).=0A=
=0A=
3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to false=
=0A=
for !FWB), pending maintainers' feedback on the necessity of this capabilit=
y.=0A=
=0A=
Please let me know if there are any inaccuracies.=0A=
=0A=
Thanks=0A=
Ankit Agrawal=0A=
=0A=
