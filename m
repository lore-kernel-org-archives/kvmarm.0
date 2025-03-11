Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8021E32C3
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 03:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741664548; cv=fail; b=lN1dfgg/83z5x0toXCKHyBPEGLctIKYPpAqJgFBwugnrn2YQE2bfC4bU/jZGnEoQgRNYg3kLnfTY+Blg0CwcTrYsxlFhFWCmMQ6rXb1XAwc/IqD7AHEkzBQmAFOftkP1f4kqS0xbAoBwfU7GGlaEAEXIm1MPC0TSWs7JH636SQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741664548; c=relaxed/simple;
	bh=vVCV8Vtsj75KXlY0DbO+X/af2vslO0ZpJGUxOhioCRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hesEZ/hqL+/y/YJ5mGCoFETKZnRo+1q8VZzfs7K66OqiOgGx/67O/UKdFpMEdGw4T+s0G9KgLEozHQK0ZutDW1Maf08Nibo2nf+Ong7qEOTHTWp0BOTXQrmQSjvuPxYX1afTPPHz4InS2VfQ+y7T/ZbSluR0hOR0qa5r+QCGYgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ag/nQ9O3; arc=fail smtp.client-ip=40.107.96.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ag/nQ9O3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGV2q45nv9JvrdtM7ORDZMBEdte+K9Y4lJy7Aumsyhce9DBkpKIItxPyfDdx9HrlIq2jEvPaUP6FT6B/2byNSozEHdISWcx6Wb41Sxk1KMYDBnSjze/ghCGNYQPw/C/wfYfJ4h4NycaWx1IfXR0MKmBC2Axxu6RsiY+YD1TGDfLVKU860cH68LR/D6s0ZzieBpx35tVEhKXL7/AoKK4YYP2b2h5zP3qQF1R9Fbr2lyYSwHxyRO3h3r798O3aRvkYMJMA0Bdjk20ynSqH/EsLWOy6vz/0xO9ifL0icoaertrS0dqCTjEXNJswtqG/1uwzLzXt1q42d9dTvGwFXrL19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVCV8Vtsj75KXlY0DbO+X/af2vslO0ZpJGUxOhioCRM=;
 b=hlW89OFhh7i54L+vNLYkegFURqfUj/xYFoFCPvT2vXDka2ZsLXhRBE3ux7ilM4PESBxeh3ResZbExjdtcaz2Z9mESA0VPo5V4g/Ti9si6ozFxli9ktMvKoJWEcPvG9dgkMK1cBFTGWHNF0a5csrg50Sa+KktrbWiG4qYKmI77m4Ct4m4gcNW6SkXdXSkuTgNHiqNA3ikqe4ux71BnxaV/wV97sQduZ0h1dKO9hbGW0pJAyU4PhUSq2YvqMU/dDyk8l0eEb1/3zMaZtBNGGbF9cED1xa8nmYotGKvhoIw1vOVwViH7y2yoSdbhil5vCkOiZA28HRIe3tp0qLgA7qGbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVCV8Vtsj75KXlY0DbO+X/af2vslO0ZpJGUxOhioCRM=;
 b=ag/nQ9O3QcQNpdPaK7bjknIH2fk7lxWKjjxlHdtrreQJ5xdiyhpjaBx2mzNDxt7ZlEVgAUHlHEBi1u4juKawGw/po8XBKIMzAgr2PFyE3qc2Zi7h/Dzv0P7O2v9fb0l1X6pJBuoITS9MJTfA1KK2eZDs6wMn4pTUakra/jIrIFCJLoG5A1twZUBDS/uQgAllT2ZPeVjHdBp+g/J7VGesa2sUhsWs081RNEjDfwl2k2rON/pLfIhqyneQq4VQ8vu3kriYqgnUVC6M6hSNf1mMuil57Lp4p2FqgagvxyMMCgy5lAy3xz7dZe/964INEQVkezVSgIA1duUkDFAzMUAJ1A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 03:42:24 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 03:42:24 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com"
	<david@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "sebastianene@google.com"
	<sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com"
	<tabba@google.com>, "qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeA=
Date: Tue, 11 Mar 2025 03:42:23 +0000
Message-ID:
 <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
	<20250310103008.3471-2-ankita@nvidia.com> <861pv5p0c3.wl-maz@kernel.org>
In-Reply-To: <861pv5p0c3.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB7884:EE_
x-ms-office365-filtering-correlation-id: 7ddb1319-7a23-4d3a-c44a-08dd604ebc51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Gk4EMcAp2DmG5dBtoZxcFu/QqzJ2kyN+HuCdGfX13lYV4ILX/nS9DE7a3i?=
 =?iso-8859-1?Q?FuYu3KhyHf+qfSbCnLhKmh197x1Q0q2T3XCBtzScZLhcjpMeWfMfQW14yZ?=
 =?iso-8859-1?Q?bRvIo1RBvV6TBL2n5JBCCognWkyc8sn7bGjPfnTmvr1IPn8wgYFE1R3CPP?=
 =?iso-8859-1?Q?VlItzVA7yYNn1E3mltUtiA72sP3b5wLB3X2PdRM/xj2oF5ycn4qcfeaS5p?=
 =?iso-8859-1?Q?FyVGVOrnemgXgRoPC2rEA2ibMiI074LQTudvfmuEyqK52M1tt5vJC5EmXO?=
 =?iso-8859-1?Q?zMHfHhBlQR3fthUK6Eys3uNnPIOLOvpshxN15YZHTB3xeZJwd+ArE9xj7g?=
 =?iso-8859-1?Q?dpKtAfap2v/jahwbOJSHJZHYhvG9UpeMlYfQHwK7B3bku9hSdk7Ugt3PvA?=
 =?iso-8859-1?Q?XyFW3IGDK6cFHq23ytMOHWCH1srBjIrSgMRPDNdV5P+7RpskolZYBWvSQX?=
 =?iso-8859-1?Q?5Pv4sSmMk8sCLys/U2yYqex/gbEJbXZLSnrBvZKH6kcoBg9hrvHlk7JG6B?=
 =?iso-8859-1?Q?aoc/8MOJeJTEAKodlxOGDeqbKzUvQMUYGvYfEXwtecUK3nj2vRIotgH8OW?=
 =?iso-8859-1?Q?cJbEkG9++bBalC2yHCne2alVWcQMLCfpcjk8XoojKLixbNLZXPckQ25ljx?=
 =?iso-8859-1?Q?gVMNEKP3uD/jE09V7RwJ/tGqEhlJPiPrLKTREJvYe/lBfeB1saLNNfzZow?=
 =?iso-8859-1?Q?tgnMj5RSt4zho+FDS9+hVE/Y3fGIeGjc0dp8ERsuCHkeTMLcyGTnrXZKXb?=
 =?iso-8859-1?Q?6MrZr2rY3VC5yhlw0WtL2wBdEiJdZtyU1CXAR/HwyH7IwJhAv0E7XbrR6y?=
 =?iso-8859-1?Q?rzB9Z1xW3K0ccD3DECwhIvBIJqKuoj2VENsGbtXZaF6vQOdHO/ISb+onVQ?=
 =?iso-8859-1?Q?PgGeAcMubn04faPDaq3WdKmtSMrmfjGSHMfgGW2Ib26m1i9+0Leg1zeonl?=
 =?iso-8859-1?Q?Vw1VX/ceLBTfXUHRVpu2zRkvrJph6bZmxmAw4hMibzc1R/K8cac3HsF3ch?=
 =?iso-8859-1?Q?Kw0pNKV5c1014BFm8kGkCKPB4jIX0QoBqvqK2Vg035F3Xi4AdjEP2RQs57?=
 =?iso-8859-1?Q?sln3St351lJ+fObLD/XjF8SWaEvuHSfXubR+iQpWI0NGAQ+0rJZRazPRQj?=
 =?iso-8859-1?Q?kEZrFNWyt5GwOMlDu/n3BDFQhQzP1SQr5+HmIXPEqEA0mr72UxwxI4VpDm?=
 =?iso-8859-1?Q?XGe1Zw1jrUAoKUC3B1sBQbzXj80Zd8QhIPNfydqK4G6bFadQ0r8qx/diaC?=
 =?iso-8859-1?Q?hyNnlQZclssl0Dv/1odXvR5uM78rghJEZor8qVIBTsnwa3wVdenATwdyJr?=
 =?iso-8859-1?Q?uKlxlczo9yVylQstsLJxvTnMLpg60OhPXxh/gR6C4CzVo52nMI4+ylBCiZ?=
 =?iso-8859-1?Q?c3u1KVK9q5jDrxJQ94JmgjSBGmgJakhdI3xtTb7JwyMBkx/yD/nc0cx1jM?=
 =?iso-8859-1?Q?eO10lmCBX8VIfd0vlTRJWmObFAT/hTRafkZSsNYKM4REMlWwlWMtRvsw3h?=
 =?iso-8859-1?Q?LuWztV2TLIJOabDPBZTQj9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?BoUGDA2qKLRY3t/mWk32Tl3Tir1NNenxZgWD8WgJAMUkH7TSS4xbDIY8ay?=
 =?iso-8859-1?Q?mf3qCa4JjVMVKywk+H4QiWl7IO5Clv6jMof1zLiIhc/SBXknkZU9ts+TkU?=
 =?iso-8859-1?Q?2Qbke+hg3+1DNVcdDOHJnuuA68rjZvkpCLAfdhgtcMYo22vh74XWmpzUGD?=
 =?iso-8859-1?Q?cx+zOOppTDPZKLM0JyPW1iYGTu8+kI595ZjSz1m2cxRPkIq4WELiGD0DL5?=
 =?iso-8859-1?Q?jCZvE39JIWqBM44yxU/g2NrzBVX2ym3Akg45fhpQvU0Fv3fzecr1lpYwAe?=
 =?iso-8859-1?Q?nl//gZHyTii1K3K0Qx94FY2mFc1Jcfy1G8N9aJyJUIfgI8Ed2apfcFT/xY?=
 =?iso-8859-1?Q?LhZMVY2GWJMh5CMEa5kWLEg65X6V1LlL3x+aRdLDdjDjXEUkC4Sz2ewY9t?=
 =?iso-8859-1?Q?u0viQLfryJLTzmJUMeJFJnHlJxEtQEDxPXIvbKA6ECoqpS+QLOMQul08bL?=
 =?iso-8859-1?Q?yy9/6PrIcbMItM1fdZWzTZEfqO22PdEUVTK7sAWesFGjHSPb2CZMKXMX49?=
 =?iso-8859-1?Q?V1H0ovZwbNCv9vKEqSSWqD/1vCg1i4wFbrn9klOdlTFDLjLB18N7emlYMz?=
 =?iso-8859-1?Q?a3TccP80I4Ga1mDWFm1P018qdDJEoq9zeQMehcFWnr6F/+bOkg4MAvPHS8?=
 =?iso-8859-1?Q?DDf9o+WS91EMvGBGCxBs35ez2dBYlZeRhKkuOQe4EPVx+ysAuBcpR0brhW?=
 =?iso-8859-1?Q?aBcsUXAjYsl2YqZ3x+/sF4uONCG71k7NwUfe8FtDheWyt/5BqdHmpru6aj?=
 =?iso-8859-1?Q?mM3KAdW4nOSShYNzRk0jBiPD3lK71f776hCmaSN0YKClqBrQiePkbXJ4R/?=
 =?iso-8859-1?Q?6dorOA27xP4VDB87huHtYdaNXe8aJ+6c8pDd6N/pUJC+LMtO7PEIPOqQwr?=
 =?iso-8859-1?Q?myuH0CEoxpe8hJ5WilVuq2F1RD6o5N7n8Wq5fqq5C4Qt38bcKgv+bJTS+K?=
 =?iso-8859-1?Q?fgOQias68nkqyfEMkQDmhv6mV+8Ul+ksHJ64VRCsJ2o7vqpHwl/8w+iE4O?=
 =?iso-8859-1?Q?8x+8rgA9lEbfeMTrRpFUhUxp1MSTKRWY6CralZGtOfx3oXNT+gnAZo8jMh?=
 =?iso-8859-1?Q?zcCkD0R8momn428g8H2GFp1oAlqKSYld5h8RZX2mXMvznn1BCzDjkllJ6U?=
 =?iso-8859-1?Q?AlLkEiiy8LCeOhvvMlKxfRTj2sjQQgoski/6TyG07cdZnBXaj5hfraU6rz?=
 =?iso-8859-1?Q?EEY+iGLmVkIuPVTaFTK+Sgc5H5u4kT7fejfwAeYwnPyY6pMTsTPMeGJAAu?=
 =?iso-8859-1?Q?/vP93aVm7269Y1DON8eY/DN1j74X37TlpSbKWKk/jdGhySojCVAZLtosL6?=
 =?iso-8859-1?Q?9k/prp+wkbnpwewhgsNJNkMHqmPCNDzqJnenf1eG7frXOacZTYnuRCLvJu?=
 =?iso-8859-1?Q?D5eVr+qJj+EV9GM6nCH2KD2IWyphwUPjNC0bDil5cE5Ra6WXkUSz0+9BEC?=
 =?iso-8859-1?Q?6ETCShrqRXIsbKwEsD8KFE4oDM5o3hmgYp8GgdE0Fx4NMh6/mpOgJ3d500?=
 =?iso-8859-1?Q?OSpg/IqgnatpAvIDN2b0v+pi/+BIb//H2cWC9e7qHLNAB+VSrv27gSkk5B?=
 =?iso-8859-1?Q?w8ko8Fl/D9bmIS1JPBMY/pKvnpUXDaS5WDTvuJaIIF+gqE/j7SFOmhAv4Q?=
 =?iso-8859-1?Q?ND9WGT9VPieaA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddb1319-7a23-4d3a-c44a-08dd604ebc51
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2025 03:42:23.9141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaIfJtIhcf57tkN3zd2DjGQqohLb1cSTwj1KXWyko+4wTHmuWWfcDcXOq9SS2soOl8XrbkREsktiEpSp/PMr4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884

>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 *=A0 When FWB is unsupported KVM needs to do cache flus=
hes=0A=
>> +=A0=A0=A0=A0=A0 *=A0 (via dcache_clean_inval_poc()) of the underlying m=
emory. This is=0A=
>> +=A0=A0=A0=A0=A0 *=A0 only possible if the memory is already mapped into=
 the kernel map.=0A=
>> +=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0 *=A0 Outright reject as the cacheable device memory is =
not present in=0A=
>> +=A0=A0=A0=A0=A0 *=A0 the kernel map and not suitable for cache manageme=
nt.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 if (cacheable_devmem && !stage2_has_fwb(pgt)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EINVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_unlock;=0A=
>> +=A0=A0=A0=A0 }=0A=
>> +=0A=
>=0A=
> These new error reasons should at least be complemented by an=0A=
> equivalent check at the point where the memslot is registered. It=0A=
=0A=
Understood. I can add such check in kvm_arch_prepare_memory_region().=0A=
=0A=
=0A=
> maybe OK to blindly return an error at fault time (because userspace=0A=
> has messed with the mapping behind our back), but there should at=0A=
> least be something telling a well behaved userspace that there is a=0A=
> bunch of combination we're unwilling to support.=0A=
=0A=
How about WARN_ON() or BUG() for the faulty situation?=0A=
=0A=
=0A=
> Which brings me to the next point: FWB is not discoverable from=0A=
> userspace. How do you expect a VMM to know what it can or cannot do?=0A=
=0A=
Good point. I am not sure if it can. I suppose you are concerned about erro=
r=0A=
during fault handling when !FWB without VMM having any clear indications=0A=
of the cause? Perhaps we can gracefully fall back to the default device map=
ping=0A=
in such case? But that would cause VM to crash as soon as it makes some=0A=
access violating DEVICE_nGnRE.=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 M.=0A=
>=0A=
> --=0A=
> Without deviation from the norm, progress is not possible.=0A=
