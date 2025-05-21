Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7F2EEBD
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747788610; cv=fail; b=jHKOXs/sEeJD3jQ7P9UqgaxPNJz2oGvLLYRn/eEdJwyfoNugGNBxcERsuXLpzRPKQC9pkn8I1B+fOvDXFqmxDkbLeoFL4+Bzpn6r4KHR6Q4EC47TO+QTYvvfyuE5QlCxmQuCvhs3kLUVJFMAjwNfOPD1Qzv7/cAt+esRSULDDk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747788610; c=relaxed/simple;
	bh=jJd3nYd8E64J6agrPCdlacxjnCh9G6XBv3vT4HVuXbo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NujjXhdzKe7/Sg/2ITn4w2KL+fHpQODXWoKNID4cSOLG9vFBdUX54FoJNwl6iQzQe0MSSQqaDlADJNW6Xnx4EixxH+RvodoSs4HmG0ON4oZAv6n0dZbVHJOPqVxOlpSDTYYMyKI8T+LrC8frSgJccsE4NFppHmOx8f3PYHZSl7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ea9/KcBO; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ea9/KcBO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yw0z0xq216vWn/Q2QF+genEXLFqjtCj0ImSbFEcW+sd18SJUOseE88uh8QfOFxNQxtNdnz0qeGbvXYW1N5j4RhcJ5QGMacObjT50/yjE/NC85zrS5SCYzUBi4i9bPrStmTarGDFkPiVHaf1II7I28qu0p/lOhN0dsNOVVjh6mQ0HNACIGHYDFqnpQMztB6WYmfMuRItTDLPYKa3oIHF5rvYPnikkK+0vWgoah1QWf+fptSJZraEG4NUrRziWPi0BTgo8Vjoh8icCkTotXCW7n4liku/vhLWTlydb1aQHAggus06ZRzcaG0nvM4FpOj4pSALq1ssZ/zCJjezWqj5yWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJd3nYd8E64J6agrPCdlacxjnCh9G6XBv3vT4HVuXbo=;
 b=vCFyCW1UYlntbTHzN0f8P38bYnacTxkMC4Zs4IpnXw85uDrTTjLtYyNgLFT0HVfldpOzUqLKSPCHz1R1aiQjsD1frUmsyjPXmOPHmHXSROTeJ/rm/eDgooTk020XuNHHtlLirtMutimNie3mA3vLGU3VUJdyngwqdlDd+1Lvf2Q5g5++Adwg39A2CppYzry1btAXQNh2LE9fPMJw+Nlo6YENy20i/mop5AN//czrDOom36ofu6AbGJgVNX3xHI0KIqAOZEeMkyqDOuoZISgB9pObgrhQU0FWhL5jijk01iG0wP8PrkbDC+t4YPRbb+N9gYcJKe8miVPgtOmWsjzEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJd3nYd8E64J6agrPCdlacxjnCh9G6XBv3vT4HVuXbo=;
 b=ea9/KcBOJ+SLU3LiwnLUzxD/2C1JdNRkqYFuWgsIE06nKRtvBePPql4reRjPSaN29jmYHCd/+igL653GSl2wVijBy9nC+vPvlD7iVYnMWsV1uExhFuw8ZLU4914Uh1EZlveLUp7b2S0ATUKR2GiN2kBf77zKifrmo+p8vOLPfX+rd5ibFP9kKlgwl5LyS/UIFk5hN82/MzvxFya40mQQCgsIOYtkkt5TcDnadNpMNmO6VlhRXjqobGTF1HaT2KVxbwJDgru27DKEDrzH/9tUmFk6D0jhuPFGHE2o9qBEmfjebG9HkYqovuULhg5zYw3HVKqibZci010WQDFpv74PgQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BN7PPF34483F4BA.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6cb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 21 May
 2025 00:50:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8699.026; Wed, 21 May 2025
 00:50:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
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
Subject: Re: [PATCH v4 2/5] KVM: arm64: Make stage2_has_fwb global scope
Thread-Topic: [PATCH v4 2/5] KVM: arm64: Make stage2_has_fwb global scope
Thread-Index: AQHbx7hvOdgz+9+13kGMQ9RdIeZ6vbPbnvsAgAClaTE=
Date: Wed, 21 May 2025 00:50:04 +0000
Message-ID:
 <SA1PR12MB71996C0BCE42A80D60D9384CB09EA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
 <20250518054754.5345-3-ankita@nvidia.com> <aCyX2nJzBXmQarAJ@linux.dev>
In-Reply-To: <aCyX2nJzBXmQarAJ@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BN7PPF34483F4BA:EE_
x-ms-office365-filtering-correlation-id: 59779cf8-68ea-4255-1e31-08dd98016cc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Zw0gODNTNIDW5OEuEj3UIqT6GkVZqXvd4bPkRFJUBG8ZA9XIMGJMQzpIpu?=
 =?iso-8859-1?Q?yj/pia0MCHwg5jlCOP6nTYBgHlZRjUMzYj/GJK4xS9UKtjPh6zr8uDFVVb?=
 =?iso-8859-1?Q?XYxJLgiQoOO3/sNpUnOdKhVdD0os3c/gARO4ZujncHRi7I/X90PljthpZq?=
 =?iso-8859-1?Q?+rbsnSyiyHHGEYHdhFWvAwLHlCJLZeWbAa3+/T8UgVGd8Iw+qZHQqEG9uq?=
 =?iso-8859-1?Q?CG7VBL9/VK8jgaSW15WzJmjgWWD/32BcFuekyAcOO+4KRUHu+TpBRqMph6?=
 =?iso-8859-1?Q?sGXg7TIMsH7j0UmF68HCPLGhKL0rqQgE1HHoNpIcwxOsuDllY0RTeqFjMV?=
 =?iso-8859-1?Q?4F2UhHlNVcglMHzxznPTW/EwI18maBd/OnzqSJOgXDpc7q/DxdxCO5GG++?=
 =?iso-8859-1?Q?VVt5hncfIh4Xr4KeXgWehfpESgIpkfQDicGdjTsgp57MZsDFRwx3c/O/43?=
 =?iso-8859-1?Q?vetoOnGDlLeVHN7j2QgFC5UuqdbtURVDMHhhXyt24g3AbeTR0BaPskY8ZN?=
 =?iso-8859-1?Q?dTIJXh9DBcYAW9m35v7nRxIF5Sbj+du+GJ2embIPtIGJkzopzDzM5sD+4V?=
 =?iso-8859-1?Q?j+Eym0OIzOtUHCVMj3z93F0ubl234t/wzw3C8LuNcSusPwQ/5hmZlkHtqW?=
 =?iso-8859-1?Q?mm8BexIYeTFlTgLZj8enYZiVdk489V08cKJ7CkwEHssJNtIYruHsWWim0R?=
 =?iso-8859-1?Q?M4aLQtjtLmL2sulHjscwD0f79hWxJq/snc4wH1Mkol5v43TZAmpTGZm0Mz?=
 =?iso-8859-1?Q?XDiKe5Q8BGyAXJK7OARIgnGgo76v3gEZG6lnrdKqf3q36VHkkEFkXvo7UL?=
 =?iso-8859-1?Q?TJCtP7jFCmojDYmoN/ftM84u5xxr4A58K+CEbJFlxMid36YHZuk2N1Dqpl?=
 =?iso-8859-1?Q?NBsdIxNctLASnD28db5Gi9ah14G40LE2d28RCEDzjEXwdSpjbd7v57biC6?=
 =?iso-8859-1?Q?4HHTeB8yTxVSIK8qqvtmWek/btKfuzlutSBFGCLJWf5MkyNWQ14QukDjtO?=
 =?iso-8859-1?Q?xeafp1hfq85T+u/AdNP0ZCOq2+k/8KYd/Jlv0TJ3657fTpSe/UReOiheCB?=
 =?iso-8859-1?Q?F7TrdzSR0aoQQCeZZUOoOf6M4675Op8LpkhJWL/BhEs/LHPhqpTlUzMheG?=
 =?iso-8859-1?Q?ov9WeamOgGWgMGv/VZM8OpGNPK2W1wcCTJGXL0X5/4jHsS8G2RzkXE36B3?=
 =?iso-8859-1?Q?eRKn/Y9NOu2pzSxeVso22NkRKNNWpSLixvNIhCQ+yfMt/NUaI+Ss+xlLcX?=
 =?iso-8859-1?Q?dz5JtSqrV8Uhc9vLaV+AxJk22FQIcSm5jX091ZMC06y+MuJXxSYXiLeBHz?=
 =?iso-8859-1?Q?wpBOUJYfH7ptFCrwRLMUiA3F61d4cnlnx2nvTeTqvwpmoMsW9YEsVjOo7U?=
 =?iso-8859-1?Q?2wTOo440CXHwbrueH2uU67vAex7TxDUdUHQiYhQlbXfEtss+V3JbR4Z2+n?=
 =?iso-8859-1?Q?a1YaFgvl0FRbWNLN5qGPS2w6/EBFljOgnxzosCuYggufdBnMCJwTNpG+MD?=
 =?iso-8859-1?Q?cARG+AafPoUVpSvD+nJOnsYQx2orMb9Q302rSrBBcxeqtspUXkGJsZV0wH?=
 =?iso-8859-1?Q?zeCCmZI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Z4GdNVJDByORACkYCHu4MbqomAkuvC0S/iln8EfsuqRD2GGwB5JcBVQqES?=
 =?iso-8859-1?Q?Dd103rnbJKsnd1pG15u9o490IOuPNZ5eDQ+dSKmZYlBLKZV+7GSkQhLInF?=
 =?iso-8859-1?Q?P9hQkwRgcmYpdjX8UZWwg9wLetFLdH09A93DZv5tVD1Wkxr5dv1F2MdoGy?=
 =?iso-8859-1?Q?BPQTgCn6nC8KMeSAE3GXWIQfwbpa0tqUqMn/q4KX0C2w/r07SQM/u4Bp95?=
 =?iso-8859-1?Q?zBR4/XldVVBc8E9XS0MGWpVH1Lt4VE3uSVN9LDkvY2n/ciSyu3Y8NTvquZ?=
 =?iso-8859-1?Q?ShqsprfEN8YnOyXKDmObs2b/A0CFyzb6IUyWRbVpdwM/Iqfm+l5SLJD0+F?=
 =?iso-8859-1?Q?/+igRO5v9G1qbRbbUGFHMou1dSnEXHIRf1F/tnIf3weN/CVOIc7uB0kfh+?=
 =?iso-8859-1?Q?uqQtlfpv/h8O9l9ZG2H9AANJG89oDenpX2odHm484lleM+9jjO3/Zc1y/7?=
 =?iso-8859-1?Q?N6bTN1pki8DrsjeGGiaBRNEKjK6AHPUTLzLpj7kI4ooCjiw6W31JnHpTGn?=
 =?iso-8859-1?Q?Q3gKfLeF1Qpx1P/KXa1BQJaEcyffWOqR2WvzV3UwCKF5JirVqE4lEzJSiL?=
 =?iso-8859-1?Q?gNm1YdIXxR/vItNE1uqWw3EgQOn/XS9JOob59SVdkeaj10TYCb1x1ViZ45?=
 =?iso-8859-1?Q?uCj86Q6WkXQ23TRYPdwtnNUPUaoqaqrXem1n+2Mz86kB8xM99ueKAUhqfE?=
 =?iso-8859-1?Q?9x0EwP5AkYAcuRz/ojJgRiki2sudNpzRaAc5xiwB+RhHqVQsimxKZbOI+E?=
 =?iso-8859-1?Q?fTt2aJfy31uYtpdBm4fsbkVF0M8nspajxoUTiNtpRwdJRFd+NQlYvh6byU?=
 =?iso-8859-1?Q?fyXtIsjcEnXO0+BCnyNd86dk0fSkWhzrbb2/E9/Pss7O66InsN/7hOGXYT?=
 =?iso-8859-1?Q?/Dk+/qoJ3d7ocQN2Y25QXWDb0mG60/iGogDsNPpxv/5yXgB68yrTHBWkdu?=
 =?iso-8859-1?Q?FoKkpMTT8BPwtRh/kl0WpuN5kSe2ZfEtUgjJDM+/+bDYh0GT+OyUDC0iLt?=
 =?iso-8859-1?Q?zto43oWul9yi8namhG6+vsKxS3X4JK+iWhx4gXmVZqR8+cjg7AbycJAO8R?=
 =?iso-8859-1?Q?S1tJoh89X25U+BReXyYgYos/eE7TtPyTqg6WwdNzJMC0s6l2oYnkcb5vjC?=
 =?iso-8859-1?Q?vGGzn8gn2esn+WCx0Rh4Ef+xodCKykGwlGZBT+Q8eFphaVymot9cNUIDGO?=
 =?iso-8859-1?Q?DZT5xYD57rcJhgTLJhje3s8DFAsuvOZScvklbZDF2OKu1a0MrqGcFWnRvB?=
 =?iso-8859-1?Q?6HsWQtAreAFbX87nOLA9LbYHiw3uNvM4OzXx0En4VYIeXtMPYQYsXn8DiZ?=
 =?iso-8859-1?Q?K31ivPRD3UQZ9J+OAPMpYeiqDFaQUOvjLjiWbiJ5UAexgpqDfkZ04U0WwM?=
 =?iso-8859-1?Q?tOxxqVUpdj0Ho2Q4/mJPnNJrd8OGo5gz0iL10tDwHT5YY9fi+8JHVoqGz1?=
 =?iso-8859-1?Q?1y2vYz2dfHaEHpGdwCOS4etNyBjo0zV6/Sgbm6iTGxJoM12V6yBFbdPhX4?=
 =?iso-8859-1?Q?1WazpgCqc8b95iQ9CypoVIQv8a1Y/+AD/PxCPRPf3aWkEttcSd1Z3REIr/?=
 =?iso-8859-1?Q?BthXfKKWCOJ8i+18Xh7yD0TPyE0HCleDiTGLg6ePL/Z+wImg6asKUzI5Ea?=
 =?iso-8859-1?Q?Ntn+SOIJQl7To=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 59779cf8-68ea-4255-1e31-08dd98016cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 00:50:04.3422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X5wmu7lj7j6CBlm8Y4aNwiF0MrnLTsGWJbyVHKBr5b0sZZ5rkHB7Ln6QCH0IURC3ZoLOnbbyygZ3vR4UV4HCyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF34483F4BA

>>=0A=
>> Change the scope of stage2_has_fwb as it will be used in=0A=
>> broader KVM code to determine whether the FWB feature is=0A=
>> supported by the hardware.=0A=
>=0A=
> Please just use the cpucap directly outside of the page table code. The=
=0A=
> only non-FWB stage-2 that KVM maintains on a FEAT_S2FWB machine is for=0A=
> the host when using protected mode. I don't anticipate that changing any=
=0A=
> time soon.=0A=
=0A=
Thanks Oliver for reviewing the change.=0A=
=0A=
I'll remove this patch and make the change to use=0A=
cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) instead of stage2_has_fwb()=0A=
in the next version.=0A=
=0A=
> Thanks,=0A=
> Oliver=0A=
=0A=
=0A=
=0A=
=0A=
