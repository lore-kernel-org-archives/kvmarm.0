Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA21981732
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 01:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751248616; cv=fail; b=UUjVXNvL8/iuK2O9ZMvP9WbhgA45lPDLu43MrSpgq4cmeRLITgWEnBzUWfxsV1Ye9IDtoQjVkGd9kdfYy0FYHMhDJHYe7qaW5oV72+Qdv+1Y7oEJX4pC0dCZgQMoldZMLEo/AY38ZUNLkvCVMfGtu5rExiZ3oCiO2tNWepJFuhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751248616; c=relaxed/simple;
	bh=3XhyF4ZlMZkMRSwsydlEyi79UioGAo8fc7rQ4s0CjVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PSp3+DzmIQ9oBg+O16oUeuQdqxY0FX25rLOpzbdN+YdB9fllrk/J+x+j2pJ1FBUEQ1XU2AwblxpDYmPS053JxPVcp6QWg0gKeryArnZUD6N+2o1mb57zTuf9WpmtWoINKkRmumjFhxVn0rvnUgtjfQDjaONKcm4o9q5zgxdDJ3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qb36+cjN; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qb36+cjN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RujOSJ69VrCTL10ODjwva2fjrUM04wYwfRXXy9MpGiM/ZpbLYe3lGojg3lKNG3segg+bXHfZERrerc+OIF2YORcc+Lt4rsGcXD/6InCCSj1nPbiYIVTQUP2m1wqDP9m7AezbdIyfIHqGUKo8tT1gJoHQ90R/Zly9R7AncPTYlFFUJGtekbQaWORe5ABlratASu4rwjxIff17UbA56leY6AwdIXDalKfKGZoAOyMbu5f2s7msJAs/GV1jtBHymaxP0AjeJlJEAoeRmkNuxtdbvKz6vMJZYj27dEMgednkqBm8EaWARTOZo4vkkUN2XW3VhDTfV+hLnrqwqfjKOGym9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XhyF4ZlMZkMRSwsydlEyi79UioGAo8fc7rQ4s0CjVM=;
 b=UvQ6j/Blx9QyvBxaGu1ZZ3XJCoHedY8jd5FlDCBlwtRu2fEymBFmeiuH4BptY/cu6+GvrpMuPd3evBzkhcJWYtE59FW28CyQoasbwk4Q4xmrpYqS+PVzpbH/SNb3dl0BSohBbckMq0FlUI4yprYlCF2dS5N61tSyLjJN0PiqfzXY9y+oaPLjl89Rh1qBxSHKDJFIswKky17+Q3LVDKy3O40Fi3zO9nUVbmzDap9baaRR8e6vUS7KjJIOze997XKJOXnrFiGs9U4m3zvsBBAXZ1V0fLvBhP3u+EsL9YOTnetQdGz5xxU/KGR7ZT9pBOj17aUI27Zzada4xBMmuF/hJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XhyF4ZlMZkMRSwsydlEyi79UioGAo8fc7rQ4s0CjVM=;
 b=qb36+cjNYNwFJ0dmgsnQTDWeSJ02I9ianUGX166LsCLfVcPxRVbmmVsabMHyWwVna+YaHPm0l7kErzX87Ex5Q0pqyaM8xB/7tij57Iad87iU+1qS8eKQV+0kwapiP1pD4drOONedoP24rPvAvRaGc5+9lhXSrffa98zSKD6pIqef7nI+1sXpTRJLs6YWM5nxg6Kso100embdOLKVjgpwTDvQm9wg4por1Ayshls9e4AOLHl4OvLe0hr6PJQzatmq80ct97/9s00WCITftU515KeqYMdjf/iEnkOMIuRgCv9mgo2tNbPYWvGeJkTdVu5rM1nYNvKmgx8AEOpOPkTQhQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BL4PR12MB9479.namprd12.prod.outlook.com (2603:10b6:208:58e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Mon, 30 Jun
 2025 01:56:43 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8857.026; Mon, 30 Jun 2025
 01:56:43 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Will Deacon <will@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "seanjc@google.com"
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
	<maobibo@loongson.cn>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Topic: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Index: AQHb4mPxjWlRs11/jE+VoBag5SVF8LQXD9QAgAPuwNg=
Date: Mon, 30 Jun 2025 01:56:43 +0000
Message-ID:
 <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com> <aF6hamOI7YVDP1Cp@willie-the-truck>
In-Reply-To: <aF6hamOI7YVDP1Cp@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BL4PR12MB9479:EE_
x-ms-office365-filtering-correlation-id: 1696734e-ec93-4c8f-79fc-08ddb7795ce4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WMAvOiT7ssIFWwsUdDl0Qu0GozP1CmDQvF7GFlBfUlmSwHEWWgR7bg+TuR?=
 =?iso-8859-1?Q?gnbTEtlzgCy4MxJLa/6oJpV1WTd3s6bD7g/djY/Q1xjJvDfnsmv2fhdFQ/?=
 =?iso-8859-1?Q?I+rUuw+FDpIUSB9BOjJigYxNvBps9aFE5yRlXPA2F5LrGbDi0BsrDltc4X?=
 =?iso-8859-1?Q?pX9MxQ7l1Ib173i6ZuT/b3J2+Z7WZFI7NGLcHSONP4Qw785wDF8elx7x1q?=
 =?iso-8859-1?Q?O7ISbFBHfYEcoxNJgGZOnsak++jad0J5m044Q9K2VM7VFXKJn5NVNruncK?=
 =?iso-8859-1?Q?dU7KJ9uPz/b/FEeUoClNZWdzbDPsfm9GzRyEMMTpUtWg2Nsur5tvIAtFxr?=
 =?iso-8859-1?Q?rTLoeIrWSVmmKxP4VSkjrDdRvdzIbngAfLF+MlECAXPo6ps+g5QB/IYKnf?=
 =?iso-8859-1?Q?Vuysac+ykvVoKlwL1/PKcdkzWix7CPytL2aXLTjdVFKxfHoEZn/wdzSW5I?=
 =?iso-8859-1?Q?hGv4NiVxG9cjy32A//nbD+P+M63LTwL+iwa/MxUYKkIKIJoD+IMTXjS1li?=
 =?iso-8859-1?Q?BRf3XKKzCAAl9mEldnULWY6vqCT0Y5t/pm0o7PLYeKE8ENHsQwRhkqFmdM?=
 =?iso-8859-1?Q?f7RdSZzkiJtxBAnjkOYeQjPjOeEJhZfi/xAC5LTbd4hR3hkWTc49g8T5l+?=
 =?iso-8859-1?Q?Y5Euodg9lycxVgbojzu8yPoX40m05YyamJe9TyO7xKzWv7fGCAOSAgT2u3?=
 =?iso-8859-1?Q?kln+i2s3YPlC3KZ9AOhIJNiF2spctOrrGSITP3c30VcmSUf1kuiSz6Hn6F?=
 =?iso-8859-1?Q?djUKfr0PbK/+qznQF9tBwyUoasZb1dqApetDOQU2RA/kmPYMQN227Y3JDI?=
 =?iso-8859-1?Q?RQZMcbnMoTVNptv1gANUFtKWUvjUTuxV+dMqMJDztwjewq2LBjO2RmRNLI?=
 =?iso-8859-1?Q?VBGOWZiVFuTRxGpNxs9TRcIZWZqXVtlbCpQO0+Fv1P+RYM08FdGryumwsd?=
 =?iso-8859-1?Q?+Y3q4cya4R3Iw/+2GohDpZSse27PiYmFRKrQai994tvePmZ5esZo8b7gaY?=
 =?iso-8859-1?Q?P8QUGzD44Knw+bTjT/ULncKVPUt0zM2Sgr2CPmD0BkxZW/19whIeZVcICB?=
 =?iso-8859-1?Q?zDt90fK5Bub1usYhzmJTBD6GKRFAGh5Vqr4PSpza4pJpJ5hK87LzFEpc9m?=
 =?iso-8859-1?Q?sxGhLj35V/mUtxonr+YqFwEmY4uubF9Hp1x7mmwjZEQqJnWYxTmvFImd+B?=
 =?iso-8859-1?Q?q485P73MEpj3sCXWihZGXKqAVNKz9lPyzORO6y8klnPBkCM+IkHpabCyUK?=
 =?iso-8859-1?Q?vGajZZHGJReF+vxu0tUTpHnq6ZXDu91ytBLLyD3gY2OdDTkb/yPKa4xYWM?=
 =?iso-8859-1?Q?BuQRa+Pmj8osCHCa46prHU1UYffN756hPNfzlnGdbWMSZtCjJto0DHixFT?=
 =?iso-8859-1?Q?2wjdFafsunRzrQI9OeusDfWF1jljNmHw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Jx/EQHXs8GUHaLqrJUMMldAFvlCDvhbieXaCl4hjDFk7i7XfpXia4n6N+t?=
 =?iso-8859-1?Q?3zL2aSMY2luKOWTEixcfYVh76oSbLMCnZO2IJ0dBvV+4FrOC36Yg23dOcj?=
 =?iso-8859-1?Q?NNAnAds8ciy2ZpehJlvImYzy83PJYh2kOlFpTeZwJJXpmTRM063MFOySm+?=
 =?iso-8859-1?Q?d9Ivo1WX6AFyRqmrLO8Hpb5I9ibNNvUzvLCXJpU0BrZby6rlh5RHj2TlVv?=
 =?iso-8859-1?Q?AaQ2//xuCXZZJquJOmN8y1Fv6sOPCvu9eyddomk1MUKOhR9Z5N0OqY7YH5?=
 =?iso-8859-1?Q?xDctyMR8OOewgZPFYM89UxII411ey30LxKsOcuosUQEttvfCn50bZQLmRr?=
 =?iso-8859-1?Q?bG7CVrXN7VFVkEYiqXNAbhPQXRDZsPd7UElbSNJ2Q3dvH3dcFIpbkQ8vOX?=
 =?iso-8859-1?Q?5PFBtdfu+rS4HkprcmYaiZulAbPDHaNc+vrIfW+kN7d+lQ9JVGqEPcP4FK?=
 =?iso-8859-1?Q?SGwqfiBOR++4vDrLRNJxzvS1WgfjvIxWrP3sNLvFeojFCljZn5Gxhk8PUm?=
 =?iso-8859-1?Q?YJvt6ksK44cqNRlu1MPVWkaGxFAFY/hNJ1IC0mJNmH3AB+WV6fqkCH2ZdV?=
 =?iso-8859-1?Q?qAbAO3/ktRjY4pfCD7MRsKBXLj9uDzWhuZ/Pq4oaQmzkx6OKZ6mN7lPTYD?=
 =?iso-8859-1?Q?/Vka33RMl/sg6LoHJNMtrfL1O6/r3nWHksAW3cGJl89tTuHGOkqPMpzMA6?=
 =?iso-8859-1?Q?JxWXJxjsib18tH75+SMz222zsLXXPD+sFMKrKfUCf26NTfB+pwUQC7JeiM?=
 =?iso-8859-1?Q?SjYG1rJwthAazXbDLSrC6O1emmtlN81VMayE3LyEapTfG/xmq1h39u5GVz?=
 =?iso-8859-1?Q?WvE7HPVAmwJ9ASYiByvbXUZn84q89NTuIgbJHktzmEBGcQoNCRp7r7XcLa?=
 =?iso-8859-1?Q?5eFPAXY0xfux8wq+aqD1w1WPGYgFQgQJTzjkhztaOvGypNFUqKnD1uUM2H?=
 =?iso-8859-1?Q?NuXc1qP5bfINk+JmMlgPG4VsaxHp+cGQQEc8OWPuHKRenpEkVC0GlXQpbb?=
 =?iso-8859-1?Q?59nSjo2MisuXAJCBOn9+5nLOhfSLSWhW+X2M9l6HkrpV8OCa0j4Z7M74l+?=
 =?iso-8859-1?Q?oNwPTeVlHT1yAhUEBJpdu0RjxGIouzZK7RbM/KWoOpWZD2EZLIuiMlz5Iv?=
 =?iso-8859-1?Q?5uAy1w8gWRbc1BMPzLaVGR1/RwW2I0RivPddh5yhAvsrOhDy1zytoNJhaL?=
 =?iso-8859-1?Q?SBwNFkeuEKKYm+5/tEr0/8zmXdRWBqrprNZRCx8K0ye5KrpkcOydELtU9u?=
 =?iso-8859-1?Q?yTQwvvIsUvSnAsHJwKRC3bapkbDDNCg4vJMudMAxIP1EATz58Une3JJFcB?=
 =?iso-8859-1?Q?IeDb0dHOHzN4XsisWKFpzcXsY8jErrgNAepJwNnbvKKF1VNbYZ+OiGmO/m?=
 =?iso-8859-1?Q?rgSmjjwak2mFtkRLm8rYhE2IpZ43Tws+Qj2jquiJ0MLPAj1zaZ4NBQZqry?=
 =?iso-8859-1?Q?zaVTfsGrRMO1Xx9rPo5rSq24/Wt+fCpMGgfjp99EOeYKvPB1d+eg2Xv56v?=
 =?iso-8859-1?Q?aX+hF6NODlAD1dehaf5j4Mifl209h339lV7NPWPTzdAjxQ4s4/bITEle7z?=
 =?iso-8859-1?Q?2i2Uw00H8LDnxvBdatpE6TsSuN7tzjmo+CgvzcOGZl2NFmKousL9DVZ7kR?=
 =?iso-8859-1?Q?TSesUNdy0Qr0U=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1696734e-ec93-4c8f-79fc-08ddb7795ce4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 01:56:43.3620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8jgqDHQOUQRY8rTNFhpu+hBRpJYdTEhnuD4VxXwB8kbxtYyc4ozj/ufTncxxHENI90RpBvaES7S/62UtZyIurA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9479

> Sorry for the drive-by comment, but I was looking at this old series from=
=0A=
> Paolo (look at the cover letter and patch 5):=0A=
>=0A=
> https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com=0A=
>=0A=
> in which he points out that the arm64 get_vma_page_shift() function=0A=
> incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which=
=0A=
> may not be the case if a driver calls remap_pfn_range() to mess around=0A=
> with mappings within the VMA. I think that implies that the optimisation=
=0A=
> in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device=0A=
> MMIO") is unsound.=0A=
=0A=
Hm yeah, that does seem problematic. Perhaps we need a new=0A=
vma flag that could help the driver communicate to the KVM that the=0A=
mapping is contiguous and it can go ahead with the optimization?=0A=
E.g. something similar to VM_ALLOW_ANY_UNCACHED.=0A=
=0A=
> But it got me thinking -- given that remap_pfn_range() also takes a 'prot=
'=0A=
> argument, how do we ensure that this is reflected in the guest? It feels=
=0A=
> a bit dodgy to rely on drivers always passing 'vma->vm_page_prot'.=0A=
>=0A=
> Will=0A=
=0A=
The driver use the vm_page_prot sent through the VMM VMA and may=0A=
update some flags. Is your question that if we can trust the driver doing=
=0A=
the right thing and properly map through remap_pfn_range so as to not=0A=
conflict with VMM (vma->vm_page_prot)?=0A=
