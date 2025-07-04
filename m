Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D8288CAA
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751646014; cv=fail; b=KgyAfjbCv5DMAyf4ki6qAYQlXhMFgOQzvQ1PYSlSkW86JRRucE4JzpZrKOjIwpYGjJlSOydTjTD6y1KxA9aZWU0Qd/ylVm/CIE1/2DJVoVEdN8xxh7nG+1b/TWLVVt/yrfKVLQAX35EhALUI3DXjpTzjHMQ69Nri5opZulOpvgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751646014; c=relaxed/simple;
	bh=Iv0/ku5mI4wUaI4wavA/6eXM2T6u81pAIXMVUhqK17o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XW58AjSgT/owUo6JexHf5Zw9CWPMf4/4o75IE8XvEjsR9mrv45vOJcB9cmSIeFXVUNqrsaHawCIbxEWSq8LpVJfavpk9IWR3nqsIfPXmjZfLqY4/Wjtwn+Bp8MRhmf3/ouLmouFbcnF8NRHhETeQU7sqmryqZKhXVkCAh4XNeCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i+iw0Fvc; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i+iw0Fvc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l6cbqxy88Riyh8Zr38PLfCDEPjlzv63rgCTv+EBOhXu6GHnY7FiJ4uhnRIHC8wUbeLZjJknVTXz/XoNGpynIbtVg4mCiBsdX+1EyA+1gL11i6QlrhnsZql7E5AcPHWosGU0rU0aWA4/AFg/ylNFnsc221T9gQva/9qRcFJNkJ3zxxWP/1U3wOvQKC2hU2/j1M85T7k9RDyVXABfTKvrvNOA/psbFMDK/5wArvbUHD0//swCQP6O6xNobuxKnrWcZ9andYZQSUkPTlxv44l63trWMK5Uk/+8aTJQmHftDL7DYQ2LfM4f6Bapyn3q0ukYZuVMhR/8wqn6TCOPyoA1FaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iv0/ku5mI4wUaI4wavA/6eXM2T6u81pAIXMVUhqK17o=;
 b=V7VAtgtDQGldbfxqHL92X5tpLNLDueuf0Dmx3DsacX2L8im1Y6De7f8KoYXDil6gYOyAmPvNL7tluMfkfpxMaOftAI5KraXtZFnL4vLotj7ubCJNqy7iLPU4lho0PfQIMVo6ejCYmRlTeODy5tButJ3IvhWUZkklsx7MdthHTFpeQmHvp/EfXHD0iXpeCnvxk5hfhvwCh6sVa8oiaKx4UMSs+uj3VOvmz5RcNsdH/XXovNcpjT21qrKjx5TTupgdpT+RIrvZTTYYhjvruMZBLRA8LVGdgi7SONJ3vCIxDeuIWuHcBjy5O9kNLYQrkNtC6GEkPBoeOUNPtTD6r/6j4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iv0/ku5mI4wUaI4wavA/6eXM2T6u81pAIXMVUhqK17o=;
 b=i+iw0Fvc2UfQn34s4v3rHMx6SDs4Vp3m0W7hj/x+2LncUcN0ruBGWod4uw/G8ZQJYxuoYTkVnMgksH8Ay4US4U/VgooJ3hU9uoABliFpq0C2SQHtkUV7NQAKThsjMPSLNc33En+s8vxom69NK597xtyATcrPLiDETmO3cbYjGA0XLF60fPj6HUo0UtpSA33Y0gwT/8VLkQUttVvUhfEZHs/UmJMnF5ORuDUHM/a2+NedXw5tJkYfIzFv0YQjdQCiwyLwf55yWFYmR31Lqa3WiIrb0uAtp9eUVrL2fwl7bT3P7Ad+hX53oVv6l53nTROo8HpaAP1J9XXYzdGEmHBC7Q==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Fri, 4 Jul
 2025 16:20:07 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8901.018; Fri, 4 Jul 2025
 16:20:07 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@redhat.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "ddutile@redhat.com"
	<ddutile@redhat.com>, "seanjc@google.com" <seanjc@google.com>, Aniket Agashe
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
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v9 6/6] KVM: arm64: Expose new KVM cap for cacheable
 PFNMAP
Thread-Topic: [PATCH v9 6/6] KVM: arm64: Expose new KVM cap for cacheable
 PFNMAP
Thread-Index: AQHb4mP2pJdwzIX63ESIo/O5CRPnN7QiDqyAgAAIuwCAAA3BAIAADBWE
Date: Fri, 4 Jul 2025 16:20:07 +0000
Message-ID:
 <SA1PR12MB7199AB9F09DF483AEC41777AB042A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-7-ankita@nvidia.com>
 <20250704134413.GE1410929@nvidia.com>
 <29cc7d2a-b174-4ed3-ae1a-22db478c62ec@redhat.com>
 <20250704150442.GI1410929@nvidia.com>
In-Reply-To: <20250704150442.GI1410929@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB8692:EE_
x-ms-office365-filtering-correlation-id: b64473b2-55de-4dd0-4859-08ddbb16a423
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4+JzDn6E6a34IF2RwgeEJPVwx908/0MM9fVzEvhQ4s0zZA2S+CEVJH6KQj?=
 =?iso-8859-1?Q?bzXkcVoNZt7yNoAGYyvisJ2osQ1jrF6HHOluqTmanZLcTBu3aNXd5HIgwq?=
 =?iso-8859-1?Q?un0zG0f6zrKS5y7+RkhDsROlkjptcWomCmD+DF6Dg/yAAI32MO8oKwpLvO?=
 =?iso-8859-1?Q?6pFDMKlYiUWVBlCJa/hBimoCEqYH60AESfNBerCrNVMsczFHcp47Cm+ERl?=
 =?iso-8859-1?Q?HFGetSgdgrge8gyWnUO6aufXrVKMjDmryB6YufIcIE7T6WEcqWOJt/MX0b?=
 =?iso-8859-1?Q?BuwP1bW8OuvKzHzVULAHmKNKyXHt4ZX3L1fCYZq/6lqnATm/oTMFdcsCfv?=
 =?iso-8859-1?Q?CPGTGUbkRC6O8MQ1KrgectkJ3nYZbk9GIKbgisALSJWF2Uxi92vvTBMYEn?=
 =?iso-8859-1?Q?KPHPavfW3NZ9zNtHEQqlNl9GWNgRlYiMJNIh2CeG41/BZe5P+KAYuJoqHw?=
 =?iso-8859-1?Q?VLdwaYI5qOS6wCptpVFCt3ZDK1LKupkPspbME3MhhUMn9NVK448P0p6q/c?=
 =?iso-8859-1?Q?Y/a9rd0PDZza7MGS4oufcJF6aRi2XDCvHtXOizQnCSNpd3xgi+jrKV5jMP?=
 =?iso-8859-1?Q?1SSAozU3YtorZPirB5Zro74HCmtJIYRkBpi130PlX/T77ESRLKYEPkOwIB?=
 =?iso-8859-1?Q?DfyCFOuAduGY5IlRatK/tLzS7rx/o1DhPHE3uGs+oa9ndqQb9jI1fP5J2O?=
 =?iso-8859-1?Q?ENZmJILDGp5+hiE7Xsn7w0bfwyqsGqbWqBZoYqS9nZpW9ZLQp/KysHwkfA?=
 =?iso-8859-1?Q?WHIOWJnGotpcD46NK+K44V2aKa+W+NGXb7DUfkRQaLJhtQ8YDWBpJPeTFb?=
 =?iso-8859-1?Q?pGjZfQhoYBZNtVtj9pG3pmZZNcjGlX0H7/Pfl70rksA/Q9YvMRrvccB2aV?=
 =?iso-8859-1?Q?7Fuezb1RjTYsT3pgQILh35n3Mv3QpbRgeF2NmUv2JPMU4k2Q+5SS5nL2Pl?=
 =?iso-8859-1?Q?KsxYpM9hIKoCoesldBa9SFb9yQ5+XljwW64JTl8PkM+shfiVDBQ+AnlLUG?=
 =?iso-8859-1?Q?KgKb8jT9iQzVX2D1BLY+SOnbHypA9EFlRRpZCWGdP5j4thsZzya4N0hJkm?=
 =?iso-8859-1?Q?OkKRER4kVJ+GBBEymB/MM44oPCdDt//cV84sft7P2gwiCiT+rg6ZioZnXd?=
 =?iso-8859-1?Q?96kqFkN8WSDzuW8xpHVG9mwduz+MPVAHXPtnyrHef6TkNnaAjoke6sp2Cq?=
 =?iso-8859-1?Q?W/hTui0LAMQ9YIT5H4yHBQ5ryDVlxcxf7HJP9U/YBCKeeeUp4iuCWryE1P?=
 =?iso-8859-1?Q?BlKwag2cLuJ6dC5/rlOgpdsW/MIx0PCbgkFVIPQpREJkSpFLE84TSTsY+A?=
 =?iso-8859-1?Q?Vn1rVh87womQP4VcIluEREGVrvKj/xArDgQy3kyVpQAd7UlcTXPbe4GWJQ?=
 =?iso-8859-1?Q?tQ+jsCazL/Yw7x0tVfoYeQF/sGaNYtGAyBXIyM+/4CoHBkLiVuenFbGk3a?=
 =?iso-8859-1?Q?PqZBSGxkuXCZor6NpvQZ2pvTqV+QNqapGvLOFsG2bDst1uui2YwmQYkeyU?=
 =?iso-8859-1?Q?p5XjOx81ep2wa+W9n67eCVufUemPY5n9WART2uJLQhhw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ox1kekyTg/L8i4XBFR0wflIbOlJhIYrn9NMgRAan0rE+wDePQeMmya91eo?=
 =?iso-8859-1?Q?L5LYqFJLtsam2onY+LLcN9ET1jpz7OiV5v42YdbKxEiwI++wOGjz3rSshH?=
 =?iso-8859-1?Q?o3iZtCjLN07UnKay9/R/2DDefz1iY+PjLrpsvVYWdn213UJPRf7/c7JTlk?=
 =?iso-8859-1?Q?qABDskXVNSGElFjkx9f5bSzUteNVTKtVbo0QdHzcC58AhkgU+FC16kil5s?=
 =?iso-8859-1?Q?azg2Zmh4sDgCDjnle63T7FlxmVH091OfxoTxZvrkun9ktJ/XJ3kNL/5b//?=
 =?iso-8859-1?Q?CgclzaWurROZBD4x42c2uEZ2U+lw7ArE30PnrY/8THa/WxhQnWpukA51nz?=
 =?iso-8859-1?Q?L+a/a68cAbLmajkEx7m/Zifm730OsRoRlt9HFbncB2SUnfpJnw81Su3aqa?=
 =?iso-8859-1?Q?z7M89ZphCdKm3oKHEZlG14NLrJr30NU/8+dKGeOUREqImNUP+P84V7z4Vt?=
 =?iso-8859-1?Q?OjFFnp7aaDyMOvcIx3Kiq9BbRYY95os7oxY1PTpD4H3OCMf5/ziibgFS5Y?=
 =?iso-8859-1?Q?U38gwRkxlhygAeBDv3wdm2WzHOq7hkxLOwfFPDzJjvfkb6HPGJZ239zDyo?=
 =?iso-8859-1?Q?Q1QdbsKOWKU7Q2oxxzHz78RICQyh+eGL7vOEYYq1hQc24CmdgIYmdD4X/1?=
 =?iso-8859-1?Q?KDxg/lkfnU310ARVMJGfiI0vO2Ws8RIzAdZaD5x1rmXO3BMkRbSY8dl6lM?=
 =?iso-8859-1?Q?qLZhvhdWawagjW1ZBFjntRkDvu+imqB1/+vYuC75mSNiosIllXlQX0qp8e?=
 =?iso-8859-1?Q?aOkd3686xIk4p/L/bxCxrEQ0/MlwKl58eNJwg1Hg9Vst0n0GcFcaF2cg0o?=
 =?iso-8859-1?Q?Mc2/hHfC4iuYjga5VBdLi260Pw03oaOiPOLWU3Aa0gZ/XzdOSOIAxBvKdR?=
 =?iso-8859-1?Q?Om5QxGhJQ1vHb1Q2IGnaIJpQUR3BKLJ08ZvPbV9lHa7LghNu08MTpHjHzd?=
 =?iso-8859-1?Q?PSkuRDyB+cOM1w3oUMrqz3FPqvGSDOVcJBJCpFApLj7lX21/tBb11esL4M?=
 =?iso-8859-1?Q?uUuDdh9XAVubKWBaEhAJqBfUPZfB2IL2FldF7h1dVGZPgQXokF6sxJTebB?=
 =?iso-8859-1?Q?kwvJ/PGiITJHCCHr1JkY6O59yWMMEu5js4YKPxchZuTsGgEyZr0UCTrXWw?=
 =?iso-8859-1?Q?pBApErNFXGvBRX9YZJYQlCgosWLrDYGBHftXrAf8CylbXAw/QmzF2utsAq?=
 =?iso-8859-1?Q?S0h71Dof/FEOfT9LxQudly8ct1J+eIPRiInaHHeHKyIG2BPiqYNCrlOphm?=
 =?iso-8859-1?Q?JPY0+Cvv/29Dl6ouMjK7nqqscEu5f6HWiKJcOoX/rYvrrXTPA+cQZoJ+j0?=
 =?iso-8859-1?Q?cIxNvrr78q5xuaceMcLZToxaQhPlL4upI2RWWHpxhdlMR/Ud+9xtBTR5ev?=
 =?iso-8859-1?Q?SjFcse6N/EzkiruAOxIKR3ilwls+BVf2pGZqcAOYKLYeZhCcooLRyKMHxw?=
 =?iso-8859-1?Q?HbxsVtWrnb2j2FfBnM0oubRClwF8ejlH9ePDTqNkWvjs+6Vfz4YIBI1CD5?=
 =?iso-8859-1?Q?v13BStptG/pIYE0gss02WnJsDr+oEksZz600q7bRpHOVmu7O9zm+1Dm0Wu?=
 =?iso-8859-1?Q?rY/MAadjn4sIPIi4MvZ+aXJ9lv2H1ktIi8uODaVm93qnEKSwrRQcTq1tiY?=
 =?iso-8859-1?Q?fdsFD1CWjfqg8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b64473b2-55de-4dd0-4859-08ddbb16a423
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2025 16:20:07.3421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9MZ9Np/TawOgey8idMyCN44Haa76Sb+1ZO/PjEqyzM5tjHYVms+7Z/P3trF/33bhjG8wxPMN8dkwsba3mlPrmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692

Thanks Jason and David for reviewing the patch!=0A=
=0A=
>> >=0A=
>> > I don't know if any VMM will ever use this, but it looks OK=0A=
>>=0A=
>> So, should we defer it to the point where we actually have a use case?=
=0A=
>>=0A=
>> I mean, patch #4 could be simplified by modifying arm64 code in patch #5=
=0A=
>> only. No need for a common kvm_arch function etc.=0A=
>=0A=
> IDK, I think Marc and Oliver are right it makes sense to have it, I=0A=
> just don't really see how a VMM would make use of it..=0A=
>=0A=
> Jason=0A=
=0A=
Right, it was also pointed out that the VMM could make use of it=0A=
for early termination during VM migration between incompatible =0A=
systems (i.e. across systems with and without FWB and CACHE DIC).=0A=
=0A=
=0A=
=0A=
