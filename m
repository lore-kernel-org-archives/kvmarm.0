Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD4711712
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351569; cv=fail; b=KnVzre568fwiq/p5tYSVSWsMfAG6EjYl+fk/phqZ8LPbgbKfVZcxDEM3v0GZVvnTwwR9z6M/h3t3Pgp5+72BhnTQa5qUOUCtaR+KDLObMxgp3rsIWZMVEWjiEq/YSxoGccO1khg90x42mP7MGslcZBhdfXWtBe/84VMRwg5QjxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351569; c=relaxed/simple;
	bh=WCVqB6Dbuu4LaL2OwIPzHhKllIPW+cxWDFhh8F1ly+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aOsbz1yHU49hI2AQqRwb7aQYMxHa+iQ7wxbgOWTwoXENbxg0poBIASLuY/C4L/GI87PHy1Y3IyWLP8uc7ksA3oXcMeF32WGuqkiZzXffmy2c33bZFWtALP0Am49rfPZXG/Ou1TxBhdQaC3/iwE58OhnqAfIbjP4eCWasMT+FTtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AbZsCcUw; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AbZsCcUw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1QDW21de76zZmO0SxbpGw8VnrBtzYUyIOmIlcdAQjWoe8CTY1SnNx+QlUb4wjRHJSJ0D6H9H0K3n8elnHk8PAWeY8kt6K2RMpqUUtuj859+NNRJJ/TtSFY50pn9l8KjoR6uC8g/4d4codyCTrTdY9be+H2EvZYgbbXMme4p0Qxe/6zABEEyZHPQL6VvZMmhUs+mYaHjIJPbN8EsXsfr6pfUvTmyaKH0pxuRCj5zWKA2SXySgjPwcy7GCnzLAXIf+Af6v6XHcG5IBEbzu8yFdWiNm2jbqqz/sbUYhC+izlPktgPNCmlZ6kRpOr/LJixw1KEqyUOlKmBS5sNTnhyGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCVqB6Dbuu4LaL2OwIPzHhKllIPW+cxWDFhh8F1ly+g=;
 b=P1QRhyD5bX3A8hdGYBeOgLlyvhSIJ6nZBWPd9jVMQtt+uP1/XMe5Jr7RihiIm0ZVUPrv6utfBABlmnSZ2MSt0bjzkbNgIfz2v7hxI20qSFcgZkJeARsIZDrYt1jD1su6RM2UYcL8vcFzGkNaJvtXpRuNcFYyPnYt02m1LgotZP76iG5yyoUUhtiuvlQkqE7wXId7RGVf/BqafUCKa9X/aZwerC2xGf8rgD8xurE6ZdvHOVMICOixnNzA81Udc1Qi7/N0hnygWN2Zt6zX++EHiZha6cICUQazHY2ZH88654HsWIbqabdbbkrk4dINamAUuqT47WX2n5WX9gRHhEEIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCVqB6Dbuu4LaL2OwIPzHhKllIPW+cxWDFhh8F1ly+g=;
 b=AbZsCcUwYnTTsahXx40tUOb8IT3NV37AHD8Aqp8slXVffGemdE/ELZ7rk+Acq6b28dvhHB+XcBP86atIeUYZT9cq0toI64M7kAZdWI2RCjVIXO2bvO7r7DlvYauYhmksg2gbF8CZDvOG/SDImo2bRoICuURQ96a6jkMXH9SL/KJKhM3Hg2kcCYvPZ8c5J3EccpDkuR5N81G7gQf3jbRZVkoX1JFBICBUPzIZValie9Rt9ETCFcv950li9zQADgHl/Kop/Q/3wO3/enbWvzamFXmnaFRtsqhJxNqSqgTAgSKUCd1rCuoiLoynGZQoIYDZo5rAzJ/9+cAl4wSMP3rxuQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM4PR12MB6448.namprd12.prod.outlook.com (2603:10b6:8:8a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.22; Thu, 19 Jun 2025 16:46:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8813.024; Thu, 19 Jun 2025
 16:46:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHb4B4TbCVSGMT9r0WVitf7qIEAIrQJHW0AgAABNgCAAUSpXIAAQ9yAgAALxX0=
Date: Thu, 19 Jun 2025 16:46:04 +0000
Message-ID:
 <SA1PR12MB719922A99E16FA6BEB78ADB5B07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-5-ankita@nvidia.com> <aFLqiAyXZLoOTepi@arm.com>
 <20250618163836.GA1629589@nvidia.com>
 <SA1PR12MB7199835E63E1EF48C7C7638DB07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
 <18151eb8-60ec-438b-b9fb-026efc8b848d@redhat.com>
In-Reply-To: <18151eb8-60ec-438b-b9fb-026efc8b848d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM4PR12MB6448:EE_
x-ms-office365-filtering-correlation-id: 97bd0594-5d3e-4706-08d0-08ddaf50c812
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?HyZz3O4CDHXlD5yFS4FrgDhbcKmOieP0U+7aGeTx9Kw7pl1dUFtlEh+aLf?=
 =?iso-8859-1?Q?hDozRaPufnkue/iLY9vATRYq0Ws1P1Hv7GWTOMJRFigajGNd9gJbMjj7Ba?=
 =?iso-8859-1?Q?fiWN9tONlxX0CzIhtj5+dvDYBPmh8a0sxXaliiqFM3Kpe57rvg8EdZHj0W?=
 =?iso-8859-1?Q?SWyRxCwvlET95rn2PSYrVT8t4CFKh54c804iRxU4xVCjZiIC3O/LgKYp+t?=
 =?iso-8859-1?Q?wl365W08vKUt+MTp1XYXFomobboWBdP0B9FCjr816sKzjoyF2ajDYMr13b?=
 =?iso-8859-1?Q?kzTAxMMA3Z5GcFbr9svz7Jsc7SzSP+2IPh7suPBHtbak0E3L/0DDTUfyVH?=
 =?iso-8859-1?Q?HOHI4w9A2DiVwHUHYDmGfKSEYdnTRPiRGiXxXDeZF/qCRXBpbGZccbPgyU?=
 =?iso-8859-1?Q?pZS7+nRfx3IUN8k4NS6rQzXniYAeTb+JVuTJOfwRntfACcEu4H2MScIJf3?=
 =?iso-8859-1?Q?xGo0Kru8TcoG6Pxf+rJQs/QeS6+hZlMKOlljgpFb6w9OKBwZPXVs7lZfU7?=
 =?iso-8859-1?Q?1SV4x3vDOOxssSnz/+NfFp1r7hjxKlhbPlEGU1maJsyGLWIPYRT6uD08zt?=
 =?iso-8859-1?Q?+tUIWftmaHuQiWjNTnpLNp/a4zdHMEoBvbBEudiAYUZv7N6yIK4WZeVvJX?=
 =?iso-8859-1?Q?pgsloj3ywCPo+EWgOI6iyiwStLQrZYIsmmVTxRqlj212JTFZJrXr6j2sfK?=
 =?iso-8859-1?Q?wtEEqQH+lOfU9k6ha5eqcD1qN6QRJ8vg5vpdeSwWtFK2nc6wPWwuw6kOEw?=
 =?iso-8859-1?Q?mqDmy2ibHJhlfhNKxhujhyXeXL1CsJOyGGGZWOIZB5A+GUQSHH62HNqwfG?=
 =?iso-8859-1?Q?3L6nBAC+2AhzFUOYEK2vCOdMylIh+1ll7zTzTktfPfM0+sUQFtHdgCm3hp?=
 =?iso-8859-1?Q?Mq7dxLHKjeiTQLYUqmKitZttSZHQqPM7X2x4LlZd5cQPwYJKjVow17itua?=
 =?iso-8859-1?Q?SaXhGDUKbBJvSvxwepGtwmUBCW6NnTOgrG2Y8zQztVzq5F0purlgMYHA6r?=
 =?iso-8859-1?Q?kGEZx4YnKh94QGSNkGQlqoxSQjmm3PPPHoMloNVL81AYgCM401rNVhVa/j?=
 =?iso-8859-1?Q?D9g/QAwsCN2cd6XEr0wi55zlVr4NhapWyKTwORj2bBiTDQuDB8Gj9bcBaX?=
 =?iso-8859-1?Q?n3auQZtUXIGETAzVKFXxAsBTIf5HtKkp29OjX3q11XOLfD/btHRNK4motv?=
 =?iso-8859-1?Q?8rjxvR+r/aH4rYHA23vQAY0qBokpLtesQNxyM4fBYG8dBDl4k5U2kMNUtm?=
 =?iso-8859-1?Q?YclNFRma/LNJSA2R3nAjcmPZbldG/edHFvuMl3te5F/QQkrT8zcmYqwGBi?=
 =?iso-8859-1?Q?efyQb8I7xdkczxmZx7s8BM01Ab5viaGaO3Zhns+n4Z125sTVKNVeIInHz3?=
 =?iso-8859-1?Q?cQFc2cA18aEKPZxP6utISAuTwBxR9DKb14LUAv3FtU/RV1vyJ5gEX8B0FE?=
 =?iso-8859-1?Q?QiBEi06m69iXNhmE4FxkAMLJczmjcSOv2YqIVCcy+csNI6YjqCYsHXwV6b?=
 =?iso-8859-1?Q?jZpNloNZM2IJde7lPy5wrLhr12u+4ZHef2T0bUvGBkWcb7q3RlttU5OEJi?=
 =?iso-8859-1?Q?kKn0Vf0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Pp//15ChRkE6XN0FtmgKqjrxh3rAg00Ryu7307Gx1edvMloR3pAcNmCX4t?=
 =?iso-8859-1?Q?XGIrofqNFwOviks6u7wP7eQTFnPfqqJohL+2ulS/mQkEMtoQvZulOl2rob?=
 =?iso-8859-1?Q?euuJQGVKAxrKTXSxluFgbBRShYqkPioicTwXOgfeRqFHld4MBZ9ZVIv1F0?=
 =?iso-8859-1?Q?618kUKk3uWXKjf/4hE00+bEulC80a8jiDkE7Bb1eCwdTehZlcinxlP5XCV?=
 =?iso-8859-1?Q?D9YJuMTWql+MShruL9XLRoHmsJ+7u8DW9J78sfoc1EA5ZSdig7X23fWg+M?=
 =?iso-8859-1?Q?HjaFEVC8Ph8x709pHMV7VCXZkYk3SCHWpDU3zhyEd5tlmGmetv7VdKfsqA?=
 =?iso-8859-1?Q?L1svBvxj0NnDtOFfSYqCgknGxB++iuON7bTpv6J+T/L9wZ2J7aNvss6ikE?=
 =?iso-8859-1?Q?dkBCbrQuGEEycmSgVVCNZPOZcqu9khIVc/PhaTAMe8O1Jb0N1pxIQaPUNi?=
 =?iso-8859-1?Q?UcywpUqvoNpu5tn8qC7KKp2/3w1jPu12ldTi0nzBwlFhsMB1U0QrmqxETf?=
 =?iso-8859-1?Q?OFJ49gaxTxgJLREw93pa3KpFH1Gkuikc5wo4cOqviwXNaUtgIIu0US955V?=
 =?iso-8859-1?Q?tM0iYoCuAzQShyJORioZkJQzZMt8XNt74OooNfph4L8JX/KMtTuauH9T/U?=
 =?iso-8859-1?Q?mX3HitIPurPb9XKSjRZsyD6/thguvd84gqaanYewdLdeO78AzlWfKo6UQq?=
 =?iso-8859-1?Q?uoA9miVhd24PM412S3AcMYA66uoFbbv/wWTfnKJUTHg5HJ09+eu/hrGx5h?=
 =?iso-8859-1?Q?SYmAYJFeUtbdsaJQpYR1x4vvjd/VCS1S9L4ShoLXWNvOxqhKvXsv+lVxR5?=
 =?iso-8859-1?Q?NczfZubYXP1bNmlyPisiWyzd1drgmtPqnEiK6bL2jNhuu36Gl6cqYtlvCB?=
 =?iso-8859-1?Q?uRNkwZSlllc51aDVWUGSoYrZrX/3V3jWIKaTPiDGkbqof8IAFCVYbukFGw?=
 =?iso-8859-1?Q?M+pJNSLO/U6a5QTIjDkvgrIibLujAeZTE+S4P6sOPWcrVZqAkpNA9bdQJb?=
 =?iso-8859-1?Q?AN3oMvxh2RzZ6i6Xw62Fes4lLnClkX5+9LqH0WBWZwKEID9y6ASzQxh5W2?=
 =?iso-8859-1?Q?bv/D2dT0+R2qA/9tpGVWRbEFFRt+a6wlYv14MK7N+arKNbP6AdoLu+3gvU?=
 =?iso-8859-1?Q?vrm37OeOUq9LHsc3+LcisaDr9uffGreQmSXfMQuyJUabzWydqUYq7c2pir?=
 =?iso-8859-1?Q?KENibHwyKHCjXe9TfZgLWDzO/WfEQw4anjjwliti37QG1ghSTlw/Dx49Bi?=
 =?iso-8859-1?Q?HN5G/MtX+BHpsg7wcNyt0drkTlrzqaoOQGnXjkqDSOPoSvfQz0u/dQkRaE?=
 =?iso-8859-1?Q?2WYYDJTGiNUW12Y+jgKhMlJGdr0RV1YrAY4znR17DuK0j9joIPR6nHuMkG?=
 =?iso-8859-1?Q?ODOH5bntlO3/5WlEhbDoNtq7ybNaSAW4qqZWiIH9edYyt/nNO23cMEsR9U?=
 =?iso-8859-1?Q?AQt1RHyX3J6Re/c6GSfOn2tEzKwT54NXK4yGfhxvHDxSs6jpW6k2u1tPEA?=
 =?iso-8859-1?Q?by86vMSmV2H/At1QYD9lrOxNpsQHX49XU2EBaoex/GwhlplShDEls7Iy/7?=
 =?iso-8859-1?Q?IGh1Bqgr5fgyiqnT62+d+5Cc5FiVDs7saySmAPXEBOu2WiVdXcvGF6R0ju?=
 =?iso-8859-1?Q?Nwy4/1IWV2txQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bd0594-5d3e-4706-08d0-08ddaf50c812
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 16:46:04.4841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jhBD8AG+lo2wac5sGaWhlFqhx6pFkBwHv/kueaUl3K+bDs9HKMDBhO9Eg/PUEKlOvEqS4r4NCXFePWSDQAT9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6448

>> Considering the feedback, I think we may do the following here:=0A=
>> 1. Rename the device variable to S2_noncacheable to represent if the S2 =
is=0A=
>> going to be marked non cacheable. Otherwise S2 will be >mapped NORMAL.=
=0A=
>> 2. Detect what PFN has to be marked S2_noncacheable. If a PFN is not in =
the=0A=
>> kernel map, mark as S2 except for PFNMAP + VMA cacheable.=0A=
>=A0=A0 Q: 'mark as S2 except'... should be 'mark as S2_noncacheable' ?=0A=
=0A=
Yeah, that's correct. Thanks for catching that.=0A=
=0A=
"Detect what PFN has to be marked S2_noncacheable. If a PFN is not in the=
=0A=
kernel map, mark as S2_noncacheable except for PFNMAP + VMA cacheable."=0A=
=0A=
> 3. Prohibit cacheable PFNMAP if hardware doesn't support FWB and CACHE DI=
C.=0A=
> 4. Prohibit S2 non cached mapping for cacheable VMA for all cases, whethe=
r=0A=
> pre-FWB hardware or not.=0A=
