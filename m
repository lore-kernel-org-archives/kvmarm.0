Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE25F23774
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050918; cv=fail; b=sy2Ys/S6ErsWeMcqEQppveFNEb6BmuKmpdQ68ySpEA+3TB1TmIbSIyyW6wJsSw3KGBbbtNQB43J+iFpHcJJMi4Jr/mN//gXMGqkw467ZrzK3IsbrBJVJgGY0oUkNgyJ1ZSudxfmMNJeSkuCXuzPd3AC9FNVkjIIStQqI6768ihQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050918; c=relaxed/simple;
	bh=Ho1z1PtR/KZD4QG5sxbyEAD+GM6DrtRJGLOupE2ewPE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DQunpB5uIZqGwrTpnJUk0hm0TkWJ2jTBJAI/s86+XryMQVTaM7gE2THvJom7r4s2AG0fh1jdsydbTflnfpYJmDcOa+ixNg5niaTjK2kjtwf4KAAlq8Eq/x7ThsjKYgWtGXzvYsiWMQRvcL0pFn2zKXjao18q+zv3EsPBJy8/Yf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eM5hF8D1; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eM5hF8D1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozdY8bbE6XDmNPaExnruUO6wSdgbeRFObO98XGvttTbZS3WJhltxQopLtbdHOTq+7mqOOlVg12wlGzb4sWzub3MN3x7vWN4zBkiwpqAwwjKySwtVBLA5oeDv1Ul9OUA8fLl0CRPfDvHjamNsXEs3ZV8JxMUvNed178X8rHJbyQ1t8cTx7mx7Y54gasxL1VM8Oy2DjYaqkfL6v7HNMxom1eQet9d61JHLoNODXVlZXobO6/bm5gZkqb3yHsvBCXpP5WUwJ6uckqs1T/8jqnDpLk3XKPUwNaQ0y2loO7I0pq9ZN9Clk0R2B3D2whkrRhazZwAW7pnASk9YDadkFRO7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ho1z1PtR/KZD4QG5sxbyEAD+GM6DrtRJGLOupE2ewPE=;
 b=UGF8TAsYMd1oVax1h51WpeFVhBdgWoDBgILwhppadO0otaoNAGUhXkOXgZONO/453LkXxa70TSdZYj1yxWYjvCYGdBLyYhcq2+rCNlMlmyUGVG40Kf5CtpupKR1ssrVMGCJdaClDtTUU+Ue38BlTlYg4ARtmM+1i46P2N/z6Y8VtiQEYeM9oI6cfM7Z/pmVuHtiGzdnfXQQJ+2RcWxJvJPFjt6QiSxWuvyHFI4mLwfpBWPFmv85LiPHzHgThdKYym/8oxsaRO+pCJtTIaZ3NdoG6uq9+ssaEudVUSA/4XVl69U7i4SxlayresY8wFE/q6sl400hxybIHX8aMnS5O9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho1z1PtR/KZD4QG5sxbyEAD+GM6DrtRJGLOupE2ewPE=;
 b=eM5hF8D1JE8V0h1MrhBgijJ4YhgfpnzbuWMrv/ID9F0lvdWaYga4kLWVsbvooIuRQInAEh2ehlq1hhxoQyFPyZdJpDrT1zSvWlJRlKAAXFR5HWg+TogIJSUzMhNKug27E7EJ6LwxHYea/7hVmrs/JrRvjtDNyvTnMP6qan2yZuy0Po3P1wqu0XfEqSFobIcQSrvU4Qw8OLhF2GJ/DQG5HWmubNP0PIwxKPV74wDomvvtqLcEOhJjLabsHOk9wHoFCYogi0bsvh2lSvYZWLmL5PY3OX3lz8etnQaTs3gC+W0zKaLwU3eGuS9Wjh2VxJKgVMqH63kXgYjsOg+Afm5k4w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA1PR12MB8539.namprd12.prod.outlook.com (2603:10b6:208:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Sat, 24 May
 2025 01:41:53 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8769.022; Sat, 24 May 2025
 01:41:50 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com"
	<david@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
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
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v5 2/5] KVM: arm64: New function to determine hardware
 cache management support
Thread-Topic: [PATCH v5 2/5] KVM: arm64: New function to determine hardware
 cache management support
Thread-Index: AQHby/msjpV3IbuDy0abJI/Z58zi/7PgmnAAgAABggCAAGWZJg==
Date: Sat, 24 May 2025 01:41:50 +0000
Message-ID:
 <SA1PR12MB719939317BA885F8CD3DF970B09BA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250523154445.3779-1-ankita@nvidia.com>
 <20250523154445.3779-3-ankita@nvidia.com>
 <9ffc7686-0dc0-4978-8cd8-f12a1c148b63@redhat.com>
 <9b429da4-8db6-407e-9721-178e01fd1ebb@redhat.com>
In-Reply-To: <9b429da4-8db6-407e-9721-178e01fd1ebb@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA1PR12MB8539:EE_
x-ms-office365-filtering-correlation-id: d48432c8-98f9-453d-36fd-08dd9a642728
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?l8mNdPzgscEgY1eYUpNLV1TbB5EGY8vXQG1C3fTJjMMISB9q6tWoDITGwW?=
 =?iso-8859-1?Q?F+8QXGkGCieQxi9AIfpzwOc9SE5LNpUZhMrBzE2ou0sJm/ommzYzH8rKuT?=
 =?iso-8859-1?Q?GHDHAbi7QrmVZISHR4h31fdgCNuChjut3zsAdrSm25m5iX2O5Ct5jt++Ox?=
 =?iso-8859-1?Q?lmV6qn206OCPf1rNX3PWlTY0xFem1nsmnip3XuUfqDDOU6rCrWYWLFdOgh?=
 =?iso-8859-1?Q?s1GXshP+y4EqZCU3mxjFfHYlBWcJRRc3kPgP10TZ+fxVcDg4iMekx8ZRzW?=
 =?iso-8859-1?Q?aSF7Hk8Gmh74P47/ZvcW1tYzOJxCMLb+htLeqLmVJBwmCdHVmc5paCiTJo?=
 =?iso-8859-1?Q?x4Ki6vSJz44mI2Suh1NeknwczEAmapjPSMD8EfyyO3curnDkceoiWpcj7a?=
 =?iso-8859-1?Q?IUpv0VMpMYbCGVnCImRlJe9sQRvmd1v/fn95FhLI8UKmJ1bitG9AdXOOHZ?=
 =?iso-8859-1?Q?C0XO9CMhnhWsHAGaBZgN6adfuUCK+kw+omitQHzALCbCV2qOArhRaAY40y?=
 =?iso-8859-1?Q?Rs4xb1XZUkce7+i3SpBlVFJ8vpt/bxvrKxh/UQepHSsI5z+LVZlpZ9Hu6Z?=
 =?iso-8859-1?Q?JWVOW9CdsV5a0NONVAu4wiJ46Xih1tgC/CHpu0qXTuf9j+qOpxBH4Uqu80?=
 =?iso-8859-1?Q?VWwKj65RoYeTB5UGyqlQEi5wMJwKj4UXaQ95CO+RyZOJEO9SkypSjYSjMU?=
 =?iso-8859-1?Q?bxCGBH8nx+Hm6pU0SPhSOCqsyYJea5kazrtO2q11/1u0KAMIDq0GhiGbBU?=
 =?iso-8859-1?Q?cEWixVd/R/I2VO9kc2SWOxPHSmAAZi5tAcjXbfz14JYHPaRxvY6/gWAP8E?=
 =?iso-8859-1?Q?WWSFlQ/r6RKlxT2V3k3ycMncxx5rUKiez/9HWtXsNUIfHqILwxCig4AjyX?=
 =?iso-8859-1?Q?Nn411jev53R3sBmf4AoFekU5Sy3E5/H1wyx1PCLR7z5HedhjbowaMplvKY?=
 =?iso-8859-1?Q?OXDcdGQlRzMYN2aHxTR+FvuGpTCvFkgaKpceCYFAXvZ/tCLqJoTsD+8Ons?=
 =?iso-8859-1?Q?5tDoVam/pjS6YxA7J5XmNgLNNjjw7TxO8nlDlW6aEQRN0C3p/x21ppcmmC?=
 =?iso-8859-1?Q?QjCa53FYsn1iJ8cvQiG3ApJazW57orfFaMqKfbbH/0OFPZC8RbstbD2rdx?=
 =?iso-8859-1?Q?FNCYN0mdh/LWOSsaG7zkz7CmxRn0GDgtFHzuE/Do1NoZwXlVKPfPOo8Y/5?=
 =?iso-8859-1?Q?IsbYMxrWL9aiACkqhCnwMDa1rs3B5WkKTG5/cOFTUCqDbLfTSvEG5bSvIc?=
 =?iso-8859-1?Q?XvdKVX6ki0zZQ99bSwe4MMTZ6YbCzykpjVFNX/gJcoJffOwH1P0fGJZ9rb?=
 =?iso-8859-1?Q?+tUlUuvBYWyqdbcqS0rlWfnRCwXnjQyioq2IAPBZgMZMJeOhDuOJ8+ZRUb?=
 =?iso-8859-1?Q?JD3gOC6UIxunSxVGjwlaIjrueRwgr4Om6Gh83312M2RR7dyvWfBnANfSgA?=
 =?iso-8859-1?Q?aYBuySbPysHwmFNVehMmjNmFK3LZjaQz8I4dBG34uWkhYsEfDvLC9lCbU+?=
 =?iso-8859-1?Q?vIZYCaXz1lNRkNYTDmnYwdFTa/OrUohaSk4JMRchiRKvG9aK0GzLB+5Eu2?=
 =?iso-8859-1?Q?TrB76Pc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?fT2adGvRLPiGqFzQu77BZce/doNsVCZNCze/EsGd0rlo8tFu6jb/fDcvwq?=
 =?iso-8859-1?Q?7MbKUvY/kSuks0/ajP0hepawl7+vaBeytqTDjT1hNm8QcKA5CPq66rWXEL?=
 =?iso-8859-1?Q?UisdDwX7WJWa6U2AknPdb9Afsy3Y0zwoNsSK6Kryr1y0/GwLwDI2MFisjD?=
 =?iso-8859-1?Q?Ys5/+fEgtf1Yq8Z2qr57SsxZTVKqMlR2syYiRU66Ef9uJQT3ky9Uk2fCs/?=
 =?iso-8859-1?Q?qL8Uq9kb2Z/lJnbrenoYq9qLGCb2VOgp1mKfBMNVwPCQlY1qYzfvbmWI/m?=
 =?iso-8859-1?Q?XBMMrs2fjNnEUkNQfUzxm2oAeg4ipkxYEBsTl6K0n6kyvkiACooHZetWlo?=
 =?iso-8859-1?Q?RzBg3rDTbKCd8HyAj+deffETiTnjyezCKOWFquzsqQKQYXj1h1LebZIMBE?=
 =?iso-8859-1?Q?cdNMJNW0d1VR2Hk4Krb0ZM9jphFpIr71CXcHZrtwdHPOIVXNh+M1DIrWlc?=
 =?iso-8859-1?Q?5QfqAvlc/J5jOdPVrW9a+70XvLv8PSr7bILYAtWb0d8r9HdlhzXxgsKDAZ?=
 =?iso-8859-1?Q?eyBvWu3a9PKwWORNDTJUEIf3XmDdrE0H0kNHwrmxdC4+4KdeZ4LWAybJEM?=
 =?iso-8859-1?Q?aevfb+O3f1hboRI9g/GF+odUWJh7KR3zoNZNfZxPZe8MJf+JU+PELcKVk9?=
 =?iso-8859-1?Q?Zi+CXiIbgeILGJYYfiP+WxzCHMSDdnab7AHZZ+c04QuquLo8DnDYvgNUMI?=
 =?iso-8859-1?Q?s3HamM/VPktIdpQnMmbc6klv9su1lgB2hYUog/33EkNd4U1wmudf16j0sG?=
 =?iso-8859-1?Q?QUmyczVVBCfg1S1Rax5l6h3XbIDPipFngtyTu5WMoAcjC8mmGNugEEFos+?=
 =?iso-8859-1?Q?bCNziauKP/k2LM38XGEBvdNNhXRCJVhy1Wz9myyPUiGvKCMcOwCfNGCqd/?=
 =?iso-8859-1?Q?XzQ9u7qYzYXmXbuCRb0kmE/V459Z+9YzIIFbqKWFfduQj8d42x1uARsRRG?=
 =?iso-8859-1?Q?GNudr5ZY+vS2cR8hFOdrpcje8NCPortuaIhsZEVWddfASSMEik7H07KHrJ?=
 =?iso-8859-1?Q?16IQujQF4iHO1oZOAjG3vqv6yJXMBT+IrnteuIONlMlII0yxs02AxwjL0L?=
 =?iso-8859-1?Q?kqJruoSfpnASYNtqU9wo6tCTBh/l8cHlCmZbX4mbCiX2CvEEg2bfUUd/1Q?=
 =?iso-8859-1?Q?ow1U/Jd8X3CPT6cvBLGHtr4YH8lV1jRrYx8UFyahHfwHX70dnnWnAYAPLJ?=
 =?iso-8859-1?Q?nqvYTlEdSCX2NTd4plFGhv/1wl13zzV9o4FreB9dWEZE5Egw139W6HY3r6?=
 =?iso-8859-1?Q?MZnZ1McSMdehNdrTXxYSLosC2WIluIDUgrHNDjfcba/o4LJ2ECYf0fo7aP?=
 =?iso-8859-1?Q?vEvIlenZZ9U9zTL1iI5eZIQnNpetTEmrWsrDB/hZBNO3FpkpMDw8828eMn?=
 =?iso-8859-1?Q?V3RvGcWd5zJ8U/IVZTlnVCO+kk4DplV45Xz2kmba36ZzK0FpnldE7KLM4v?=
 =?iso-8859-1?Q?pPl9l4vHXQEgKmg4C6g1VrpuYrZYtvrW8RqNBds4o11n6HWWmbuy9dQY6S?=
 =?iso-8859-1?Q?yV5QG3HUunwP8Oq6RfmfWc1271DCXWy/t/PrcyUZHB3kH5RA1prXYug4WE?=
 =?iso-8859-1?Q?q1obFb7GMCjphVxNAziE7xkaTbEYvwNH9ugZAo3IfQaS8MWgmUN09UBQG9?=
 =?iso-8859-1?Q?LsU+Q6CgTxYzo=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d48432c8-98f9-453d-36fd-08dd9a642728
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2025 01:41:50.0242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OukeIlEcUhmsUtVF7NfpA+JZB3w/YtZK1MbEs6BH9lCMru4LHYZ3MAytqwCf6ICpY8N1DNy0PeGaFeRVEmkXvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8539

>>> +/* hardware support cache management */=0A=
>>> +bool kvm_arch_supports_cacheable_pfnmap(void);=0A=
>> Won't this cause a build warning on non-ARM builds, b/c there is no=0A=
>> resolution of this function for the other arch's?=0A=
>> Need #ifdef or default-rtn-0 function for arch's that don't have this fu=
nction?=0A=
>>=0A=
>=0A=
> ah, I see you have the weak function in patch 5/5.=0A=
> But I think you have to move that hunk to this patch, so a bisect won't c=
ause=0A=
> a build warning (or failure, depending on how a distro sets -W in its bui=
lds).=0A=
=0A=
Thanks Donald for catching that. Fixed in v6.=
