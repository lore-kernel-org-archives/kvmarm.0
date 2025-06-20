Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC8284662
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424836; cv=fail; b=fVz+nQ0qxEQRBQACh3HVI3LPvEvP9w+MgrGOaMNcT+QTKRjK1Muvs5oI6cUxLR/arjoZtXBAs4+Aewzn9kSVrnF/QaDWn2HieSBrBMkY6mToMHZHk5bWDeWQ9evgawsgJmdaVdsSHDGPzv1XgZUsfQxv0Ew9OFmeeOOeBUL8wno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424836; c=relaxed/simple;
	bh=m1t3FQjArK03V6Wmc8f++josn2HLLdyk2+QU4DBpIGA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GkZp5bi4nXADb5gg7NZD5LwuYFjrZYsgCfb/X7FEo8+3eQyf7LqntWHk9HTovtKudXKqb1n8ODJvZWQz5kwBxLwLvtJrNiLObxFGxsodYfmk1Ix8HGMP/t1aTupkkl7WDCxQbfKeI0uTrWVoouasdWBF7TInOsgpkfIX4nKmlwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a3crMln8; arc=fail smtp.client-ip=40.107.102.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a3crMln8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCjnKu31+brTkZAW7zaVlVq0recJCLbjBteAMh2EPw4RDv6NMDPV5ppPf6cMmWBXMhx4QQQn8WPfEuZvhKKY4pNzYhk4fB6NR6KVSIy+SNF+NehseY3irzQT+0ygkE9lVHUmjJvtfN5NvZpmjLXEjyXdwMVRheD78hUz1pPWaL5Wms0c58vjuSjJ0u9TUY5pFt6X6FHEhcRmmxSXXSLJ4aYemWvmlUc09FNmLdrhnIVtKuZGgKy5S3pVwwEjTnhCpa6VTBWhT/+H/VrkDPXO22wXn1UYJIB76c/H0fGHd9scbh53dYWwzXLcnbqw6JKHaHhzkDPozreldPajYXAK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1t3FQjArK03V6Wmc8f++josn2HLLdyk2+QU4DBpIGA=;
 b=ACDrMFHduz9lS2qqDQUe5oE4Csxz2JWXWDQi+dESfrD54kA3t7P80kRkhsc/BFNCm29g3jt/MD26zvtTKtsqMlG/fBU7gdae9WQttcxi/H9/cnyU/bDlpw8dqwrVvEtR0kXM5HNCu8g3ngYDqrz8Y07p1OL5HnrSN4B9V2et56eW8ydqT3vPek40Ti4ZXZkO42HJZLkMSFL6iL2r6RpXkfFY6G81F23Q93DImh2lYcD3+TUnfbNJ04d8CUkLIXM3q2IVZBRfei83p9n2UHJaswLlhEKvRZ0YNtL7zUk0DJrq9TFqbX2aAVQcL3PlM1i1vOYa6JlhLvJPAichK8HKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1t3FQjArK03V6Wmc8f++josn2HLLdyk2+QU4DBpIGA=;
 b=a3crMln8hJOzEE5Yu7dgnmwC/LW+U69QBOXaGea+oALZo2ayQ4E/R338XMwh2SxuPiyX9vhJeJplb5yvXXFlE5DkdkhWMGIYusPmSwy0gE/PPGY4idyf8ry4oUu9iyXkoRFs+JzJJGmwgBo4vkKteg+ww8lMMj6SoMRzDwy4xFU8V8SRz8A2aFw299WVr1HzfjLNQa8Zvf6clYW9N+92nlF2+7P2ZdnipMBHL/QZspkvqFyq3cmnGI50HiJb+wWsd3qbNGqEqRro6ApKlynIDQXucI/hDbec1LwE/H7m0En0ZzuWvmw896ebcDS4pMhPvmnwNo+7tdWa9IDNh4FpAg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB7725.namprd12.prod.outlook.com (2603:10b6:8:136::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.38; Fri, 20 Jun
 2025 13:07:11 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8813.024; Fri, 20 Jun 2025
 13:07:11 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com"
	<david@redhat.com>, "ddutile@redhat.com" <ddutile@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, Krishnakant
 Jaju <kjaju@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
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
Subject: Re: [PATCH v8 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v8 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHb4dw9amMJ5optCEO4w/yrXTpqpLQL96MAgAAIIvU=
Date: Fri, 20 Jun 2025 13:07:11 +0000
Message-ID:
 <SA1PR12MB7199F040DF62057947664992B07CA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250620120946.2991-1-ankita@nvidia.com>
 <20250620120946.2991-6-ankita@nvidia.com> <20250620122016.GD17127@nvidia.com>
In-Reply-To: <20250620122016.GD17127@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB7725:EE_
x-ms-office365-filtering-correlation-id: 875a1856-3dc0-4ae5-62b4-08ddaffb5e71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ZIebkZI2FBaUWG0s/mclHMactKiZxUm6d5lWYa8tPTkzhBwoW9SdaDtk4V?=
 =?iso-8859-1?Q?5FnUXj9F+Y90+qE3KvQ5TbwMjdYw2YRy1PQUZuhyXpgWJjVPwHAezBzYIP?=
 =?iso-8859-1?Q?LkX4ITeJNOuRJ4ZgeD2JYiDpZ/sCRIA8+u2ghEjpUeWrCRGuB8ST+JMNCr?=
 =?iso-8859-1?Q?LzNq3ZBATi+NOQ0N8a7Dzv7HeSdxJM3mUsGf8YzYMdWMFxXvHYUCsx0W2E?=
 =?iso-8859-1?Q?GoTE00yXp56c1lecerJOT35LScaCrKgry+5po4bjzBYGxgmauJtA5v/3PN?=
 =?iso-8859-1?Q?UbMgHP5SBpfO+VgaWPEjkNnYiJFQmgiqR4TlW/8AM2L9j9imOa4vKX9S82?=
 =?iso-8859-1?Q?7zTUy5dfl22BmjqjaSf1T54qsIAQBI5uKDpZP4aCMQEb7LD8mXzKbzKh9G?=
 =?iso-8859-1?Q?B1fEPibxGqLr5qS+RVZKuEzp6h60RWzymfGDFzyLlm54nNkkbbD9LAMBRi?=
 =?iso-8859-1?Q?n25iy7gt+shvDceTDx3iII2uwhW4pdvT3huLF7qGFcOZnxdpC9lTPFr7ve?=
 =?iso-8859-1?Q?IMytQ38kWD2d/2dUpO8RjQJVXEV8SQiT7G6+tQfVNWOQt1wCke437pVfv2?=
 =?iso-8859-1?Q?npyEGGOiJivbDC9HnDgPYmxrtDcLekuZjNeY25dB4C/xr0UAXDG3qaO/ZD?=
 =?iso-8859-1?Q?+HCQNlzABFfIH+ad0Kz8Psn1e8VFUhqA3vdZetVOmE07EvYGrZJ3UhLF5o?=
 =?iso-8859-1?Q?6XmGkdbcxj2l9wHRyYPhEw7wmeRx6MtPpWdL/53RKoMNjeQCMKFTvQeH8H?=
 =?iso-8859-1?Q?shYXvtfv6AN4CqgOTttqr0T7zZKdUn2KmjKJAAUTQfFmdouHGJBnZKqFBI?=
 =?iso-8859-1?Q?1VlD32GnTtiv7kFc95tga+TPQq4uw5JL2jc+yKfom/md8mXWyFxa3bAxYe?=
 =?iso-8859-1?Q?L2UoPKRvIZh9ixe7iuqHK91h7cDDNY0VKII1bo8pctW3Ug27yupnaCDusG?=
 =?iso-8859-1?Q?Czf5Tp2WAZfplrZUwurVhJ6670YNVKd6mCifphvtLalKfEyvtNmTfAF4t4?=
 =?iso-8859-1?Q?oPfHRKjY8NhG+Hy/OQD3os9ux4dcBTQiMiL8a7wfM4tOmGDTNWSEuYjnbq?=
 =?iso-8859-1?Q?MoypTSvVsEvBTitG/lWYqVQwQhYcyoZT44VksQEEkf94WEdJlRXa8G5QFI?=
 =?iso-8859-1?Q?cLD21JVi87ThwdLkVts+elUllkWFIOIhoJibPgQ3GHMyIu1DTbAAX7MOMN?=
 =?iso-8859-1?Q?+yZfu5lFYo0PU0INftmIiD/VFqyVxaJ0+FJ6PiEaboQJs4JYjUhQTHghtr?=
 =?iso-8859-1?Q?mfbN9rBYX7rhZCg7Q5jhvs+7h+rwtYFy3TKnxH5JDVpCJknjRi3+umfIw+?=
 =?iso-8859-1?Q?BsjbAIjUhChUZviIahZv5Jc+26x4UefYZbCO+5Dz2kcaevl7gTvPayIcZU?=
 =?iso-8859-1?Q?j5LD+gwBmKkXBn0z2+5n7zuVmJ0I8VVoycf3C+ofuHyaBft+BWg3B+b2p2?=
 =?iso-8859-1?Q?mo9w75+b9Jk2TGHAt2PjVqmjhGNAO0J8YoX7NUav3Is1/yZzUnXBkZK6S+?=
 =?iso-8859-1?Q?pHR8dMU9WTNU3cWI044GAOGm2pU6K3sfZ37OzD0PCXDFOm6beJAl/Tg7EO?=
 =?iso-8859-1?Q?lH1VlUU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ofMrgz9TMMndPCHCL5Pjt2vhSNU00WLGA042deBG+FcR3PrxkGmlzyijpg?=
 =?iso-8859-1?Q?q4lUm0hNErXwJBWGIy55Ya/3XSBltDCZ4VLx5unelrw/QsS+VFOQ5SKeUR?=
 =?iso-8859-1?Q?8jADuo/Run7BbFz+8GY6Bsc3Z3E+2Uo5XuDUq71jMNKub5k9F4tGQ8J0S7?=
 =?iso-8859-1?Q?fwBnzrTLbpzSbafjnSeZrTW/z1G/FxCWLBf30Fumn7jiGfWmJ9YnDNYo7R?=
 =?iso-8859-1?Q?6YnccfQfij3ej1WTRPqHzgq2N32/KhF7G6dvcEDEd4bsWnnpnTHnPBqumX?=
 =?iso-8859-1?Q?k6KKpBVz6Yn/T+cTOtjhSaYGovUqwpXj9+cqlw58rA/dBPVhbprNuXM6US?=
 =?iso-8859-1?Q?S2UDztIeBnKeKYh7AD6NlOz8YZejk8YunI5p6UMuPNjwhIyO4NrvERKe2L?=
 =?iso-8859-1?Q?D8FF+ShraEiJNbQt81QIrrG3Up25Mjah1jz9ev2aFziOnGufQfecP+CEeW?=
 =?iso-8859-1?Q?lrgWAYNDN9ZrLsqvbW+aTNsx+qvNcPgi8TkWdwwstNgtCRgpjFG92eWwuF?=
 =?iso-8859-1?Q?nXj35o8LsG3bEMgAlT7sDwHFOanJBCh76fyB0jFEhb8mUrYdcySxaijSQZ?=
 =?iso-8859-1?Q?TFd3pr3KCByCvL/yuzCgoJ7jLC4Ezsz89IoJnm/JsgQUYDZlsb++df1i+8?=
 =?iso-8859-1?Q?F96hKdtX4ZeDo5FOOIEUcINtisW3/bm7AyTKAz42shlV69t9U/wc4cRUv9?=
 =?iso-8859-1?Q?o1pGfpPu9b8xBLWkgjoB4eeS32VTp6p5SAUCBHFpFA8/l3juRiXUaq1Vdc?=
 =?iso-8859-1?Q?sDq6myvQLtGnq+AXs2JdsuaiZakf/JYT6V6JjdP+mv5Hg7JIUs0+l5yjoB?=
 =?iso-8859-1?Q?dEDmT71tczQCtgOdQLiMm5PPODLrIfkPsAjkuQryGBYE12dDQnd9mxtDKX?=
 =?iso-8859-1?Q?rtqeClTdHQrxq7rc0u8eCkH01Rswb8y+iN11ZieS1+eGgeu198nxEtTKTL?=
 =?iso-8859-1?Q?/iSk2aDop1J0xiF5e+V3I7YV9al60NycKarzeAAFJiSrQid8wwveeVR4GY?=
 =?iso-8859-1?Q?9BGDGdxEVT3bmuSganTD53PMwhiRXRqw0l0Rmh1qUqLQVpsRkTZ0aSFFU2?=
 =?iso-8859-1?Q?Yyx08HYLuay/rME8gywZda8hD9e1uUL8q3xYxQiDhBLlk55Qb5l7YczAbi?=
 =?iso-8859-1?Q?BIeJ20tNZTAZPJjzw/+O7hRR7B+JQoJP7RNEeCb++mrTbWIdNVFqRlfokb?=
 =?iso-8859-1?Q?XiQ27t/lwlwZ0LSREWfF6PTEPr2bfo7Nsahe+kwptzqfL9kSYz5mi7c4Bs?=
 =?iso-8859-1?Q?B3b+8IRWgQpW/eXsO2OOYU97EfI35UOErObMbm73UGYSo0vO0849O9Np9q?=
 =?iso-8859-1?Q?XkVmADJhI3eUkQ2Ni73XMWqGGuPgbmH1sBBk4Yk0qt3LCd3XR7r+0KziVz?=
 =?iso-8859-1?Q?wk6TZ0IImq2U8/PryV5mw+m6nAiQk1eMaIEGW03PXxjUqObGck47oz1cSv?=
 =?iso-8859-1?Q?K3ESjfiEnsX89Xz5/DUJ4sNxf6XvP3tWnjTTyEqHYqVsNe7a9UCsLCmXOl?=
 =?iso-8859-1?Q?o+hyTU8oX0SXIc3qtyxpDIEjpcxq1xl4oDpaLEvpOM4QuiZts+b1O8dSXy?=
 =?iso-8859-1?Q?GuJKFMjg1IYTaMVjjW9FKAU+asKgqfAkJzY+BewtRAJQQMKA/mvzhK06+f?=
 =?iso-8859-1?Q?nnNlCMhUFuu3w=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 875a1856-3dc0-4ae5-62b4-08ddaffb5e71
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 13:07:11.2154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ChGsExu4SojojWYtz72czCAB1Fv8vSLNpi4pR8CaqKB4TU1jtW9c7iIll81pJLMbJROmy1ngVzKZmKPz8rJyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7725

>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s2_force_noncacheable =3D true;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool cacheable_pfnmap =3D false;=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (vm_flags & VM_PFNMAP) {=0A=
>=0A=
> I think this same logic works equally well for MIXEDMAP. A cachable=0A=
> MIXEDMAP should follow the same rules for PFNMAP for the non-normal=0A=
> pages within it. IOW, just remove this if, it was already done above.=0A=
=0A=
I see. Sure, I'll update to remove the check.=0A=
=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * COW V=
M_PFNMAP is possible when doing a MAP_PRIVATE=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * /dev/=
mem mapping on systems that allow such mapping.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Rejec=
t such case.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
>=0A=
> This is where a COW mapping come from, but it doesn't explain why KVM=0A=
> has a problem here?=0A=
=0A=
Actually I am not entirely sure of the reason. My read on that was that COW=
 of=0A=
PFNMAP is a normal page backed by struct page that doesn't follow linearity=
.=0A=
Not sure if that conflicts with user_mem_abort() assumptions. Will need=0A=
David's take on that.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_vma=
_cacheable)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 cacheable_pfnmap =3D true;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (cacheable_pfnmap) {=0A=
>=0A=
> If the vm_flags test is removed then this is just is_vma_cacheable=0A=
=0A=
Thanks for catching that. We shouldn't need this variable.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * ARM64=
 KVM relies on kernel VA mapping to the PFN to=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * perfo=
rm cache maintenance as the CMO instructions work on=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * virtu=
al addresses. VM_PFNMAP region are not necessarily=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * mappe=
d to a KVA and hence the presence of hardware features=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * S2FWB=
 and CACHE DIC is mandatory for cache maintenance.=0A=
>=0A=
> "are mandatory to avoid any cache maintenance"=0A=
=0A=
Right, thanks.=0A=
=0A=
> Jason=
