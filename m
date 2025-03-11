Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E182566F4
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 12:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741694845; cv=fail; b=E7u69YIVRvSUpRuSZNpaUTEozmJugsbJkjg7C/EjA+tQjYN+vsFjh1Y1LhEmGo1DjS3iCG5JgQ9sZh7n3AmRjePyM0CpatKFprcQgU9eYSQ9nUEbS2u7qLZeBnuoplqU100URMTroaKD2QkUGxVafxdhwnCVSRbYuFfQnQYfAxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741694845; c=relaxed/simple;
	bh=yWHAnmaZLe3h54gv8vLdraj2L5V9SwEnoCMyG4oCeNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HFLnc+e9GVHre8bQ1LXQc1kHc4z39ZHZSOvjtvhovph6v2i/vLTrwBhrDz5maSByJX/7cAMuEI9PhL+oEbiMHu6RDnThfmlp2vhhgDE2iT0pnrIeD0wfqgYDBndItvkI7qna0MOCrQ9cFTsGm5Ej1giREmsqnUYOtbtpKIytE6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ug1N1o6s; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ug1N1o6s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzEiTedFgskjgKUpsRawcx3P2V1CtnhxV9Wg/SDmKodn5Sseb1PGpa41VbXf/5AxZqkkOwOsQyarZab4TpMb9Q2xOO4CpCLQe3rjfkn1qrhKhM1opzBZ5fizW90h5vgozMnOUacgLDgZi3F7LvY7CCrjIifCPBCbpPwtiMIVCYD2gSEUzbmvnG+tU8YqWuHyZkJBX8XgANZAgx0KfCXAQ1jfZEuFgmdFQy+w9vnydtBdUOmB4vfUAXhQ19CHtNFjkvxHD9oOLtkOhKHVka+h9z4wARdZoeoKLJWiG0nOrIaaA0gUyEsKp4JfwWMGvzGVqfvOGpgRT7MZJg84v76vrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWHAnmaZLe3h54gv8vLdraj2L5V9SwEnoCMyG4oCeNQ=;
 b=doJIh8bB/lb+buvNY8KYkS2csVQhkoybcHAzQXBtx2XyUKjKoDyL7Vsa3r/cxQS1tD/iUnKER4Nq1eHV9PTMjB+QsVXCDcqFlHqMLinVlRtJcGWIsR85YUole6d0sfy44RK9iQonqlhTmIGLlRw+rk1b3c/UiBsFAfIluaCRyWGhFlatvhvO0qXICI3h1e15KqJi8MfdK2U8kqaYQt5uCONBBgNAYu0BPguJqvXzClDAg3EZg9PHS5K8gZx01wW5/kiKvBLSBDaQGJkOuM9e5oNBWc5S+U5sq6xsOJMcowGRAPlBPi9YqRPt3duxdmw6ewe93GA4kL7S+l8X/9wQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWHAnmaZLe3h54gv8vLdraj2L5V9SwEnoCMyG4oCeNQ=;
 b=ug1N1o6ssYA8ZRnSk/78A0c7M52CUdKcTWUa1fRKYDZ6ozOhXHr1ZHjYw6V4tnBv1YLtIZ2y45OuDE7q0UiQv30kNPXiR/MEt6gcG3YCLy9YRUZp9S264J3Nb0MzKAoZgyCcVFTiJOrEz81wKnQnl4cvQvQPIQC8SAI6zDSL4PrqpGuY5C41CY+iGmWziJHKbZCwSrOT2nveCdbs4vrvGIR1vSRekHswgf9S3XRvaMFGcyRZy9r3Rbl0Rj1ijZXb23bsz6l7CZ9L4uD7hszx7NmBfhbrY2fTMsYhsWOWKpIVbgvZqKULfzWInkX4fqaPba45pSrvRJQgfRXqSV7d1w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 12:07:20 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 12:07:20 +0000
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
Thread-Index: AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14g
Date: Tue, 11 Mar 2025 12:07:20 +0000
Message-ID:
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
	<20250310103008.3471-2-ankita@nvidia.com>	<861pv5p0c3.wl-maz@kernel.org>
	<SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
In-Reply-To: <86r033olwv.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4223:EE_
x-ms-office365-filtering-correlation-id: 29d2fab7-aefd-403c-8066-08dd60954694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?mFQCAfEDa7z6XFZXVja7Ogf7k/FPbwqBfjEO3X8QWNaJ6rkcGzL2vtEXtq?=
 =?iso-8859-1?Q?xVck/hQ97X3PaNUJQjF/AkGPvEZWEGrqe7js3Yw66Exrwx8Rd4K/J1s/0X?=
 =?iso-8859-1?Q?HCUAx145dnfJWMfOhFF0mPr5GcL8FitiP0+dpY/248mzx2Rr1iKugv/sqG?=
 =?iso-8859-1?Q?W07yltFgYpTDs4YIZb+AwSGesUy1+bwOUZxeTmZzT6S9a9zdBTdd/FG8Oc?=
 =?iso-8859-1?Q?zkpI9iuGzRaLCQ05YWU6Y9nk2i1MY5aVU3kFJoIYfdinJSzTKOVNMqM68Y?=
 =?iso-8859-1?Q?98vZ/2MJS2MVHdirS/L/y61GURr0BFIBdhkPjXcKlyIZTrHZfId6ZAeqjr?=
 =?iso-8859-1?Q?AN7bjfhbZXj3C7hCcCntUGSwrksxQUdSIqLWtK0wMQDUB6hfRq9A4oM8kF?=
 =?iso-8859-1?Q?zwDVf2q96FkPZytm3DsbVv+PxpCw5R2W1zwE3iL8I5Eabu+Z37vXblPHFv?=
 =?iso-8859-1?Q?BYhUVEIRYUXwVAggwscZ9Sp7QpIOjy5wHnLQalUUV6zZAxLknaaEKrqdvv?=
 =?iso-8859-1?Q?Q7ZBtMoXA5P53gur4iXrIBru9T+xQnxKbhjZvIs+A+XypNJ/YW7ZSV+c0g?=
 =?iso-8859-1?Q?3etRnJRO/QQiCzx1X+aItRic5i7e6S/PvS64GOKpdfnhGgg4otmfpsOHEs?=
 =?iso-8859-1?Q?CVp6DT8XOedRXm2cn3eV8nQgXWKFqKEPv1YYvcWsL1VA4HuHlzxUyp3R8m?=
 =?iso-8859-1?Q?RMXRbtLNYZig0OZgXX1S+Rd+TU5niJ3ZoP/0p2ydmxvMHILYYftqow+CZo?=
 =?iso-8859-1?Q?ECuXzd3OZ02rdzTD+WfWrx+ydG3OMcqQpvZ6SWCTx9mWrt0mHr2hrbAkOC?=
 =?iso-8859-1?Q?CNWU9SfWM7wgTKmGyrl6v0O6k4tyrosu8nFyCBMJaIYxIsxtuxp0K+cSvj?=
 =?iso-8859-1?Q?MjocEswRsf16MKoQJxKexHMO0O2naG7maNPGrfmVCrEF/+hMYw9U2Tym8A?=
 =?iso-8859-1?Q?LA6bIW1FQTv2mG8k25XyWT3agKyLcKZoXqEMagoFqYWZegnRlp+dp6sLe7?=
 =?iso-8859-1?Q?V7qyfc/kRYd2Nk5Pp9SrJhAvgN1PXdUymIvFp9gb8hVKV+s+l0AOxerzWq?=
 =?iso-8859-1?Q?QKynEA3FPIqXk6KlKJNNKecaS4SGSSTNLVnwueYbBNK5elSis2PncwzzHR?=
 =?iso-8859-1?Q?cEQd7jIyVyQcv4jjQBW79utJkEDYXX9kMlQQCF41BjuD0wzravaMkL+7zz?=
 =?iso-8859-1?Q?n5wIhVxKX8NDhrIRmODf+9HM9dCSBQ/SESrlawpUPfi4IMEwYEI4StgMHp?=
 =?iso-8859-1?Q?/r46gVGmJhoxFmHQ8sF9g+G/hMcLLFhf88zxH/A3ZM/DaCLNH3MZRaTStU?=
 =?iso-8859-1?Q?vk/qnKaRnn5McOhE5qA6HD+fndtit5Lk57x2KzFRoi1OBE9/Q+QO/WVoWn?=
 =?iso-8859-1?Q?rNANvnvaP4v90t2R6u2p71CdirVOAFYlWtgxqLSKE3XdA+VRqj2kOHrH3+?=
 =?iso-8859-1?Q?9jlDVVO+xoQitIVY0jeOTZ9FarewyCakyk/GHoyx+B//RKNg0D3urQJjh5?=
 =?iso-8859-1?Q?rWLVGRea6nzpBFce3Yojk8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?vdw18QFYyavyKczGxQWEWp9UAAG3nik8/cBjDNBEpR/MV+DbCEh8D+6PPt?=
 =?iso-8859-1?Q?cczb/5YjVIqeR+r8qcOaYccKka0Vr8MGSASRas6TDXmFB/6t0mIMNOzF4h?=
 =?iso-8859-1?Q?NnQ/vbA6NiUu1d9DHnR68rGGPTehc/F6m/TU3TdtFvH+hfgz8lfkfv5i2o?=
 =?iso-8859-1?Q?C897dAHjUj70Fod84BeurDK4f6P3pDbV55dfWpt6we9pqh8yL8w+7e+g4G?=
 =?iso-8859-1?Q?547RHhfydwpzVzzuUf0pdBnNSxXPjKJ+X9+CJRZLlZMypXr2tPAGHDQx9U?=
 =?iso-8859-1?Q?TxAYoKUkAhTMAcjbr25326rJkPR/NY7BJw5v4TACao2lLmODCye7VbSfYv?=
 =?iso-8859-1?Q?x4WaywpWdKUKhmA76DKfXJ8qHLUbXRRqavYawHwq93NEK6Bp8ZjzA6AbWq?=
 =?iso-8859-1?Q?qowEpF583Ab9g67lODWtW+wmbbCiwCSuPZItfKIWlSWqKjQElp2zRS7wfR?=
 =?iso-8859-1?Q?Tsl6NXHOMSghFDugiktly4PqUhedGruTR8hxFgGaxVyAJd1+bgR6fSMWT/?=
 =?iso-8859-1?Q?PMxTJ43pdtIoKaKhhzzFFnTAaKBgyNnBz8omyyD027lOKw7KOa2fucIjQz?=
 =?iso-8859-1?Q?xz8scqJIGSN+/V2AUVZEyRgNk+nifirGJfODzfnK+C0yvEE2S+qHyAfRmY?=
 =?iso-8859-1?Q?1jBj9klAim+SRVuYYt3i7IiXHPd4CWgN5UVaAvtctCzjyWLDFFI6Kj8u61?=
 =?iso-8859-1?Q?CEH0xotK5iBnThBK4uB9Utf4Tk2R3XuQhx8uByEtDKohyzyl+757sA0Fvp?=
 =?iso-8859-1?Q?pS66aoP33beYy0r8AYirGQwJ0vZBvXPzgmNzOnZtzqeGceAHRcDYT2JzCb?=
 =?iso-8859-1?Q?I2EfVVFEL0ud0qFco+fNN1lE20c5tXmN1itMV0bXMrg7uPDRDfkqNYp05E?=
 =?iso-8859-1?Q?IswO00bcsCNTG14xr80u9Hag81F6Q/KoAOYNZEOdxsChOJ29aPTp1QI+Ic?=
 =?iso-8859-1?Q?bbC6ojWqTByqlopqSwacyF9xpGNb8uicQRz7+skzpJ5HmQTEjvZ/R8FEMP?=
 =?iso-8859-1?Q?PMpj2j8A9H9p/IDAjfaP64M2Piwv20TnR764VvXm9IwzHj3sGuDp8Hh0kc?=
 =?iso-8859-1?Q?jY3E7EGfb1pheAJ/xmsrIlLbL+kPUqid7FdLyWnbajd4zy06KhXj+vVKe9?=
 =?iso-8859-1?Q?UfyTv80Su21MVqOoQT40KkW6GJAXea02y+ZMhp3tfTOaqBL7P+P4aANFjc?=
 =?iso-8859-1?Q?RyoNWvWXRE43LphowI0ooeModozgBgpwHDe44GdHnwR8pvBgFrfJzytZC4?=
 =?iso-8859-1?Q?o9WKSi6E1raWOQCGzOlPlURS3l5RMN+Qwj6HhsWytChAr9m4VcMOWwdefF?=
 =?iso-8859-1?Q?TMCtwgzmea6DZG4wO1YpHSgoh2yrvEdSuK7/gSoXVqx2RhOMvVXnvpAIKd?=
 =?iso-8859-1?Q?CJJ3Av9xQ1LQo0ZC0KQ5nbzPUAeRfXmuaAV/202MMJjU6ScjkKioedrP/0?=
 =?iso-8859-1?Q?15HEir3tKJLVO6H01EZ01lfuDwOrydxnX8naNFOxNTyPvy5CmZ2UfROHP5?=
 =?iso-8859-1?Q?YbSV3j0Ofd2Xm/iBPkzG4dHsmYhrLXUzSHpU6wqsUhemKnKcIiR7z0HZOM?=
 =?iso-8859-1?Q?gyBVW+htlET9J94fi0Ie5SK97mR4JS7du60dPKMo62nm9E9J+lk0XKXsko?=
 =?iso-8859-1?Q?EUGMxASv5iw7U=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d2fab7-aefd-403c-8066-08dd60954694
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2025 12:07:20.6890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZvqco0S7Xi5Scq29lSIQdJVTX1ORgMMZnSjqx3AUZUCkCXAgIuN35ioZl42dfi30Z1sbm2KJMXoz6BWbpG66A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223

Thanks Marc for the feedback.=0A=
=0A=
> No, I'm concerned that a well established API (populating a memslot)=0A=
> works in some case and doesn't work in another without a clear=0A=
> indication of *why* we have this behaviour.=0A=
>=0A=
> To me, this indicates that userspace needs to buy in this new=0A=
> behaviour, and that behaviour needs to be advertised by a capability,=0A=
> which is in turn conditional on FWB.=0A=
=0A=
Yes, that makes sense.=0A=
=0A=
>>> Perhaps we can gracefully fall back to the default device mapping=0A=
>>> in such case? But that would cause VM to crash as soon as it makes some=
=0A=
>>> access violating DEVICE_nGnRE.=0A=
>=0A=
> Which would now be a regression...=0A=
> =0A=
> My take is that this cacheable PNFMAP contraption must only be exposed=0A=
> to a guest if FWB is available. We can't prevent someone to do an=0A=
> mmap() behind our back, but we can at least:=0A=
>=0A=
> - tell userspace whether this is supported=0A=
=0A=
For my education, what is an accepted way to communicate this? Please let=
=0A=
me know if there are any relevant examples that you may be aware of.=0A=
=0A=
I suppose just checking for FWB (for PFNMAP) and returning some sort of=0A=
an error on userspace mmap will not be enough of a hint here?=0A=
=0A=
> - only handle the fault if userspace has bought in this mode=0A=
> - report the fault to userspace for it to fix things otherwise=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 M.=0A=
>=0A=
> --=0A=
> Without deviation from the norm, progress is not possible.=
