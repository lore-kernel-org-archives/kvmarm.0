Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0D428937D
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427296; cv=fail; b=bG2KUwTGsN1V8+0SSIO1Hcfalex6g6NlHNjAUFM/HwS9G+Yj7kOf4tAh6EsfjdH135UopPrdUKUawvhe8tEw0jj1bmxe5tZyyYJ822hPwU0sd3d5ajBYoSSY1pyeCTh9ESO9s79PsZsLGUEJ/3VEPZyL1zR2/fE4Fz5xRMAtJGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427296; c=relaxed/simple;
	bh=hJt002X7BbFgoryZuiyMn2QR9sk1z/bRfNGyX/2cMH0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hf7n/+Ilv/9E9tsL6eTS8E9Z2m772YsGVcoIxQLOKyHqRZLeVpAaW98EZoR3n4TX+1MBPzYOtUODfwN1l3rWyEmI7qiD88G1sO9R9Mwgsh4ZpGTdshFFrw5tm144t44hsVGSD3I1VVNH5ItYwswZNwpWHOZ3bbT1a3A+0qrL6Gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EH6QHFKZ; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EH6QHFKZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745427295; x=1776963295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJt002X7BbFgoryZuiyMn2QR9sk1z/bRfNGyX/2cMH0=;
  b=EH6QHFKZKy3rWgwtBkiBUaoO1v32C2IccvIqrzkoO+b7dlic7P3jnaSA
   3SwlCiTZozBuDHFLDQuo+01FKcO3k2evq/QaJ+oZTjNXXy7ZBBLcHqYew
   k0sUzGsu3AncuwyUg2Iw9cuJuBP0xrARXUOaS6nGN1O2K9NYmAeLBYHrz
   Km6PgkmIa1HCVL+AZzp+P79jaR8pX/H03BBC+XDJbeW2ZwSXXWPfwaKpD
   A6r1IaM5ZhuvWVUi04IOChh6prf9AZNyH1wnhU0XIahKlb69tQL4Aco5I
   1+Qmb56LQ8jOqSG7arFwXeBa5qkGaxKO/N/LwpADmYE4nPhZGa0t8b9Sa
   g==;
X-CSE-ConnectionGUID: XBBc6jjET0SFPKIUy4OajA==
X-CSE-MsgGUID: pG/z/4wfQuWw5FYHMva30Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="34647550"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="34647550"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 09:54:54 -0700
X-CSE-ConnectionGUID: 21y+VRHoT9Wx19esdOEA9g==
X-CSE-MsgGUID: lPKb1lo5STe2FURaqt6QdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="155583950"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 09:54:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Apr 2025 09:54:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 23 Apr 2025 09:54:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 23 Apr 2025 09:54:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7RTyF/RIGSxjhb1wgF4Amo/+ndOMOxU230DZ+gECGRu5HS5BIQProXsBAhwVSe8aneX8RaO0PutRReJB8LOBUeB0tdQVlLhxR5960ru2G+gawH6SvX8GWhtYE+OZMMvaAcxRtbnRYZo0CP6OJLLbYbRRjgnchwpIGx2HGuM4A18EBxm38cyUBUzYQBqEkeaMOPzjphkCuDc73gWDT8T1EADdU+doYu0NOX5XCTgGVLDI8C+YDY8hjZYT3uHuS9stQVebVWWD6rjatQbYpk9FFA+a1h264OwpkyE71uY2VQT7HXxIJCUxznJuByhgg78FiSx0DM8rT55ywYt2uthqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlXdCX07iWnHjZpFQP7nJiws80IrKxlljalxc3exK2M=;
 b=pI6e/6q+vpzVKkzBoyZ3JBA6Z4ODCrgJeLrviXyNtSAjf3NMPtXwMwW3oiSnkSMO82CgtJgmTpGVRQYArbCSzOC3h9ZZyj99DdsZYF7QV2tZBQvydvBk2zwKD+NqZQFGckd31MQc9xX5VEOx63K3rzfHr0ziEmDMjaqenMB6CXwvqDpYsxdcMjZHxSG54f9h3eF8ibkgphu/89qUZZSpAq4E5aBjBtw5FOuhH4OAFaNczvn/FNHq085W/ESM40qoc/xYEmRKRloHb2alCZyRjjQnCvS5E5cvZqinDcQrVXtMVJfNLhpQMpUA8p6IK8MRHj4WPaKaX2aEx1t4Tz0sZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4964.namprd11.prod.outlook.com (2603:10b6:303:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Wed, 23 Apr
 2025 16:54:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::7de8:e1b1:a3b:b8a8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::7de8:e1b1:a3b:b8a8%4]) with mapi id 15.20.8655.025; Wed, 23 Apr 2025
 16:54:49 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>, Luo Jie
	<quic_luoj@quicinc.com>
CC: Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Julia Lawall <Julia.Lawall@inria.fr>, "Nicolas
 Palix" <nicolas.palix@imag.fr>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cocci@inria.fr" <cocci@inria.fr>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "andrew@lunn.ch" <andrew@lunn.ch>,
	"quic_kkumarcs@quicinc.com" <quic_kkumarcs@quicinc.com>,
	"quic_linchen@quicinc.com" <quic_linchen@quicinc.com>,
	"quic_leiwei@quicinc.com" <quic_leiwei@quicinc.com>,
	"quic_suruchia@quicinc.com" <quic_suruchia@quicinc.com>,
	"quic_pavir@quicinc.com" <quic_pavir@quicinc.com>
Subject: RE: [cocci] [PATCH v3 3/6] arm64: tlb: Convert the opencoded field
 modify
Thread-Topic: [cocci] [PATCH v3 3/6] arm64: tlb: Convert the opencoded field
 modify
Thread-Index: AQHbtCzwqS29KFwsakalRi4XUJvnbbOoH9IAgAlX/7A=
Date: Wed, 23 Apr 2025 16:54:49 +0000
Message-ID: <CO1PR11MB5089C0773E3AEAD4BB0A1AFFD6BA2@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-3-6f7992aafcb7@quicinc.com>
 <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
In-Reply-To: <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CO1PR11MB4964:EE_
x-ms-office365-filtering-correlation-id: 19c76e5c-80f5-4778-b522-08dd82878f52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?qIE++vV/Df1p+4CAMmsisJy5hv3JRBAjC6UjQ9S2R4ttlz8EndphGfZc+pzD?=
 =?us-ascii?Q?alABT9lGKmUhKKRSaUSfZxY4N2NzYimiXNXOUqmM7Kroq1HKH4oepP1IuNGX?=
 =?us-ascii?Q?gaoe4l2vwbhsG3nrX3KnSxQX6ozC0Xnd2H+tfz+pj0SSoPUwvE6hbFEhjuiM?=
 =?us-ascii?Q?8BJiDyjdkYO4yKf2iEAfGVK31BlZ20f8WUw6Wq1on2AncJzHcW4acUeY/u0h?=
 =?us-ascii?Q?TbjYSzNzC8JvVCcY3TIbK55Nc/iaNFzrSy3I2QyWWY9kMyI6g/cLHPtoZ6jW?=
 =?us-ascii?Q?/+n4PhrLXACpKEAg5BwGAg0CMhO25eDbdpWkfB2iX3gseYkc68keraXmOQA2?=
 =?us-ascii?Q?dSLKPkZ9Rv4W8Kf4rc9t2cCMpffG5xEPYx8DsLqo7wFeJcbztCXp/fNbjHmB?=
 =?us-ascii?Q?nyno7kw6bjQiBXUc5iyPgUOP6mccf+RMey1F5LwfWBUcoeLqZngbgun6GW/O?=
 =?us-ascii?Q?hNZs4v1PVrm/NGXnx/aSwT+6uZ9RmKZnBY0kZKc4KyGur55/N8/54Uw4AnG6?=
 =?us-ascii?Q?TptxzXXF4Bz/eS2q/hFEbOSeFYUU0WQA7n0Q1CCu9hKHP5ivK2c20UFyWxIa?=
 =?us-ascii?Q?OkYnquYGOM5/vTdjqnjratlzM8uQJzq4knrVj0TqKSLc/sNWhtYC6tePhpJp?=
 =?us-ascii?Q?4H9DVFliommLjaqrqeK2sucgQop84FwFBgpAhdgdRz5gCfkdAoBrHAUlDj8S?=
 =?us-ascii?Q?cBhvOrzXRVhmeMnakdBGDFNRpyhNcZFd/BjMa72iTPQ1fQ0LmbLin5D787rD?=
 =?us-ascii?Q?tPWn6JKMy/aPtyFxLZSnnFrl6IfNfMU3mhRwm8xY02QR8RxEaM2oDy+hV78n?=
 =?us-ascii?Q?CClfsXXEpSLvD2r2vgm0Q4uj57te1pBMzIURkygWjs90UUlMewH4zVx2CwjW?=
 =?us-ascii?Q?sQPPKtLHJsVKoSoE3C9KJf45c9paNuZT6g/L1dA71VorV9d0VJ0FTexmLH/4?=
 =?us-ascii?Q?b+Sx/0s1a55H4WJ9K/id5eI7jxTsWvxnvR4QihoAI7F6KFIrRub2Dp61uq+u?=
 =?us-ascii?Q?RBaZw6l6w3LiOmNiBAuRS0NPejZQ/ryytops6VvS00ePJntjbVghxmAS8OSL?=
 =?us-ascii?Q?/WuN/TrlDYtCIG515Td03/ZvDSOtO8u1v1Fj19Yqjh297T1lxk/0jW5OK07a?=
 =?us-ascii?Q?b6g9N1xCV1jCmcV2GunG9gl0jPmFiFW41x2B/OHvHnnQvUFxzWLGQc/5RmfM?=
 =?us-ascii?Q?Js+aJ/U1duTHjy/e15yfbDFkK/S6j644OBuMiwwHk2YHJCOx65HWZHrkMz7D?=
 =?us-ascii?Q?2yZv4RsMzUZfl7p8jzkZNz39H3znT8/ZeVPpzr5XlThQc5E3suB8QmnSXg3x?=
 =?us-ascii?Q?vSNNBIV6OxnhwKrw8WqLHLT6QSPh60qHziH/RVXpja90cQaVS88rL2P6lFhy?=
 =?us-ascii?Q?uxRDzRWnWqjclNQkQAzNznEfaNfrvYZFqmbVyQ0i3+KbDHJRVQx9QECN9a3z?=
 =?us-ascii?Q?Sa4Lkrii2Yw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V2g81FA3otGQLU65kArODHqUFZwkjPyUcwW8SxKymL5a0JUm8vFG31bIw9r6?=
 =?us-ascii?Q?z1MFlYLKdqVcG6dnvhZmkFRwl28aJw5+UzApzwakUW/j4rFsO4v150QP9tGV?=
 =?us-ascii?Q?XU0MBhR/I2DKLpTpTRL3drq5q0zAtjRaBJsVYHH4v2FsRTPKTRqrT2slLj6A?=
 =?us-ascii?Q?Vdwp5XFFasdKVyV5CaICqk/O/nBxpbMWawtzob9f+9dZKJucVxJRk3ZGvKgB?=
 =?us-ascii?Q?6O+tz7SmAr+q88iRS00yHTP4uGds0vxOCGrHIG2sTdYj7uldyG110zNgPl8o?=
 =?us-ascii?Q?A6ocrdC4K++VSq5j7qcz7TLHCJPh/gDDMIvdle6epPWPcVSHstI2mtvlakI7?=
 =?us-ascii?Q?4UCORuW0yE2YsJXX5Nu6vR3xhOHZESpUqqeIE3V8J1W14dS4WUpYQEsBZNuh?=
 =?us-ascii?Q?qlgZ5GqGds0EC3x1qvdiXnNGtO47MXofrqtt2MNGSJikfmToXKXHapz24QUt?=
 =?us-ascii?Q?cvKs637+1PLvYGVAqy8ihOTqoBttDLwFXG+SJn2fWSV2VGLWmGClp5j6WrMZ?=
 =?us-ascii?Q?eDs/rMLAqMQttZYqiEaVbjIIXzeI8erI6LGe94wpcd7lHsZ6pQpx690+OwM6?=
 =?us-ascii?Q?hxBxrpfDm/hAfoUyUL9jgpHZZnUIsVPqTNy4oc1VG5Fzn31AmQtngnw8aiwF?=
 =?us-ascii?Q?nZ2RaX4pcTPgONkOhR0JUx16OigtfDuykV8CLvxtYEQtU6TqMbVqPIoGhgFC?=
 =?us-ascii?Q?e9KyPsue8DajpS3Fno6wlzhjAktnN6KhaTzeVhxlzREJ+IjpjWNETJh9upTi?=
 =?us-ascii?Q?/CsPItqhG/TZWiRGYuLIC7mH6thSUxUfIFsfmqKrydKIltgTlA5MEQkH5Dr5?=
 =?us-ascii?Q?CHzYU2g8NClPYZ/1JGoEWoioLE4LhMRlGDSpi2pPtqI8cutmgpoZfw/9JaOG?=
 =?us-ascii?Q?otOMgcnd52LkwS+Z+YBtZ+xS4rNHxQVM3vMET2PuW/oAapTlVFmnvxFVtyaD?=
 =?us-ascii?Q?QUsnxcl8Y9LWFUe3QxaUxGy/jLHsZ9n35s+VnUpMezWyH9TrBPIDM/iM5jm4?=
 =?us-ascii?Q?SDXsxfBi/YjI3epsG2fLyZHyUo98l8vp1uU4cK1YVFYcZX4cgAKazCtr1cWC?=
 =?us-ascii?Q?Bq/DOoTLkDr3Lchvwck2NBqF+rt29WbR0tGd5pARugj5DXOV5Xo1r68mltv1?=
 =?us-ascii?Q?VTwYCRvA8MmSKRHT1R3xN5xy3+ISxiSRfAunaRsDlteR+vrAVGelI6CmQ+V7?=
 =?us-ascii?Q?Jzb2X9rsC5wvR2V8tutOHymEZikZurWviZpz5lDw2z4Yr6F5shYVqFB0ACTS?=
 =?us-ascii?Q?pxDx8JgY9/G644Iea8FHXhGTncwlQoDexcqGeCC6oeXVbi4yiw8qoY+BDFaK?=
 =?us-ascii?Q?WW7k46QPid8OCGmQ3jK18eDruEihrFeEaRPpQaMKw2I1p0wM6GOOma/HmreN?=
 =?us-ascii?Q?KXu/RAVOkOzEfLaQL6c8lc5l+61TwBccMJ3JaE+OylFylT2g6CSKy3gWvSw3?=
 =?us-ascii?Q?twp9gicdFhQDUw0GQHHDjQ0Niv+AkWMQZtLvenNKrp16vcdQO4L/kwJYyD+1?=
 =?us-ascii?Q?g+spQsmEcXGYY2G7piRs66o5gbqiQD9JaisAhh0gyfDg9ET/l1TROU49FqPS?=
 =?us-ascii?Q?JWyyCY1qezsQjlz60+q664+BkmKCCEjU9+eLB1JL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c76e5c-80f5-4778-b522-08dd82878f52
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 16:54:49.2831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /K4hZQdpBNtob6cKgh+RDtaoaH/3raBOtPO+IHmYp7MkWzcG7REBuJ7ljJVmUkZezqjU9e34vDEC7zlFqmg44vh1BwmInXlWfIQeBMWEKMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4964
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: cocci-request@inria.fr <cocci-request@inria.fr> On Behalf Of Russel=
l King
> (Oracle)
> Sent: Thursday, April 17, 2025 11:11 AM
> To: Luo Jie <quic_luoj@quicinc.com>
> Cc: Yury Norov <yury.norov@gmail.com>; Rasmus Villemoes
> <linux@rasmusvillemoes.dk>; Julia Lawall <Julia.Lawall@inria.fr>; Nicolas=
 Palix
> <nicolas.palix@imag.fr>; Catalin Marinas <catalin.marinas@arm.com>; Will
> Deacon <will@kernel.org>; Marc Zyngier <maz@kernel.org>; Oliver Upton
> <oliver.upton@linux.dev>; Joey Gouly <joey.gouly@arm.com>; Suzuki K Poulo=
se
> <suzuki.poulose@arm.com>; Zenghui Yu <yuzenghui@huawei.com>; linux-
> kernel@vger.kernel.org; cocci@inria.fr; linux-arm-kernel@lists.infradead.=
org;
> kvmarm@lists.linux.dev; andrew@lunn.ch; quic_kkumarcs@quicinc.com;
> quic_linchen@quicinc.com; quic_leiwei@quicinc.com;
> quic_suruchia@quicinc.com; quic_pavir@quicinc.com
> Subject: Re: [cocci] [PATCH v3 3/6] arm64: tlb: Convert the opencoded fie=
ld
> modify
>=20
> On Thu, Apr 17, 2025 at 06:47:10PM +0800, Luo Jie wrote:
> > Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> > - reg &=3D ~MASK;
> > - reg |=3D FIELD_PREP(MASK, val);
> > The semantic patch that makes this change is available
> > in scripts/coccinelle/misc/field_modify.cocci.
> >
> > More information about semantic patching is available at
> > https://coccinelle.gitlabpages.inria.fr/website
> >
> > Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> > ---
> >  arch/arm64/include/asm/tlbflush.h | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/tlbflush.h
> b/arch/arm64/include/asm/tlbflush.h
> > index eba1a98657f1..0d250ef4161c 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -112,8 +112,7 @@ static inline unsigned long get_trans_granule(void)
> >  	    level >=3D 0 && level <=3D 3) {					\
> >  		u64 ttl =3D level & 3;					\
> >  		ttl |=3D get_trans_granule() << 2;			\
> > -		arg &=3D ~TLBI_TTL_MASK;					\
> > -		arg |=3D FIELD_PREP(TLBI_TTL_MASK, ttl);			\
> > +		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);			\
>=20
> This could equally be:
> 		arg =3D u64_replace_bits(arg, ttl, TLBI_TTL_MASK);
>=20
> which already exists, so doesn't require a new macro to be introduced.
>=20

I had been looking for something like this the other day but was grepping f=
or "FIELD_REPLACE" and similar which didn't find things.. Neat to know it e=
xists already :D

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
