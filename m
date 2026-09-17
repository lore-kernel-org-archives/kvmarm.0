Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A35384244;
	Thu, 17 Sep 2026 02:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789611931; cv=fail; b=rVcirzVGIVwL/Sj8uRQ6Jbmbcmb+fFYaUsCQ1UJja4vabDganQ60AgZ9gcGJxNk2oBO74+uqS0Od+0ZxZqOwY42U919GtsgCiGDbbEnud1Iz3nTHlJYNjOTVR5heHmfNOydo9Q+igYn1xlBysGtyIedq/kTQiPWlYbYHoMcsxZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789611931; c=relaxed/simple;
	bh=HTlN9hVHSfvxdMtpPjHb3RErFKOXZ/HGY8z3zUFRxUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pAmvxPa7bhwgHnmLJlXl/4PE6GSv2fFbcm456N1AFDRwoi4M7+bJl7feCtFe8SEivZ5SQqRalOUeiXdSZBYPSvOkJvFXT3AkPSnBft3t88PHpuQ0/FsEWRnXtoPx/zudm7JuTYHmXP41wAuYZdJu0oCo81UG86lO7vI4ZS/08mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVECRFpL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVECRFpL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789611929; x=1821147929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HTlN9hVHSfvxdMtpPjHb3RErFKOXZ/HGY8z3zUFRxUY=;
  b=WVECRFpL4TRhNNFcBl3k2t5RoclRsI3ia6Z61z1uFBv71Ih4akxGVkyG
   2a2729rHK1x9Oi4fe/vaee7grKPrvqbyY3B/Iaic7J6BGPw91RJJcHvuk
   mex6fdGpjUjImeAHis0jz2xRwnOkUngmEcQ/bhUF2+FrTSHRSY6zJj8NT
   CKQ+LUIF5hUQHG+oZbp9HxTqxsqgWN4J6gqVRzxNr5ygeYMPZlTvoURMp
   tiI9yQ1dDxQp/FWgFJQLN09XjJbARTjdXzk8hye+4NOU/STC2aHsy0AII
   4LRYDEpJk+Ak81UVs8YYoUU5rFFsz5oxeOOXQN+otVkCoZSuNIjtoH4/U
   w==;
X-CSE-ConnectionGUID: 7Y3VJbVxTs2973lPlMkfFQ==
X-CSE-MsgGUID: ZIPqNq+xQAeSCnMYalsr9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90130460"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90130460"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 19:25:29 -0700
X-CSE-ConnectionGUID: 4RoIlqOqSr2U0J0cEMzUuA==
X-CSE-MsgGUID: 541HeQ8GRpC4TL07RhNQVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="303421010"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 19:25:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 19:25:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 19:25:27 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 19:25:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXe620JVgiVLnleXj8wqa6MCM0m3heoBhDDgrw1GK0sUZremEkREln1Uig3UOxqSIIVXNCwRptVYbf6pQikHpxSR5khovfXSwusyib3WcTxMaSxDdURoz7mJAcForLqSKIbLWucA5/+Gd8E+tbvcxofZP2skDmQZP49F7u10NE62xYanAn5UTsEPxdDNZqKXWvioWoYDDCxz3138oCBcD+a8JQJqQPOrDCV/MHM1zBFLUhWZSKWd9H5UMO5Ap7PQr9qde0o3z/rS45UKygvspdllsgpoGvP909cfj9xiPPDeieyIU7O55VD4ozQ0wGrpjlRyBOr/NxifeEBn2qb+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APtTanFntzPhLhlrhV+AIjfBXJKP+oouKDWA55/QksI=;
 b=T/vNNIZr/ZJFJEjBnofvXuiTP3N3i0meS99Y5DN0Nv4lXW0gflRPvIYFP+XLvtnAfiAsKuFmLJuzdCiB4RQfPjNWSzeEdra0DDF3/I3dr9eAwXWq3wkJjjtjXGnjIyQDVkQ/Kj4gDvunQp+ckkUwqJEDtv6NbNmMlM9hzZf6ZG/yzMZxfSxBBGurTpkW/R2FG50LdFCGQq87DcWCAqc9du3Pbn4Th3ixPMFlgI94TFhXm0SBzuYgjtXnw1XpSAQ9o0rTQUpa/EFSrJom11WPGQ/GBlR3UoLLQDwOve0xnHo8f0on5E/p+efhSxIFSlIYRahHlqn1NXs/c4hZnAQr/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by SA1PR11MB6615.namprd11.prod.outlook.com (2603:10b6:806:256::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 02:25:23 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%4]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 02:25:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, Nicolin Chen
	<nicolinc@nvidia.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>, "Robin
 Murphy" <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>, "Steven
 Price" <steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: RE: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Thread-Topic: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Thread-Index: AQHdN/EwiLvbaU+6lE2MX0oxJV5il7a5dWsAgAAN2ICAAErrgIABNM4AgAA3CgCAABBnAIAAON+AgAB6EYCAAGKGgIAAwE4AgAXLI4CAADRDAIAC9yOAgAAr2QCAAS/H0IAAYpMAgAdUwACAAJbEAIABAFjwgACARwCAANT88A==
Date: Thu, 17 Sep 2026 02:25:23 +0000
Message-ID: <CO1PR11MB48351F4B766EF6A574291A118CB82@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca> <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
 <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260910124632.GB4083318@ziepe.ca>
 <CO1PR11MB4835FF972283C09D7D683DAE8CBA2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260915134318.GB3196566@ziepe.ca>
 <CO1PR11MB4835562E7714F368E669D3B48CB92@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260916123954.GC3196566@ziepe.ca>
In-Reply-To: <20260916123954.GC3196566@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|SA1PR11MB6615:EE_
x-ms-office365-filtering-correlation-id: 1195efdb-1534-4076-d435-08df1462ed67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|6133799003|22082099003|18002099003|3023799007|38070700021|4143699003|11063799006|5023799004|10067099003|56012099006;
x-microsoft-antispam-message-info: /YlKA3LyBgTessyQ1+r4bDoCIhO1Gee5AIEhUH2opYUykeY2FaT9mp2LHh3KfFF7PSzJp1ay2/1Qt7zcQ0979M5SadtQ+iA/tM84ZYlWUnhtBbb8PoYvg8VnK3G16od6S8uLUMeWcdN3OTyHbE9zHDEBmOKJiHPnO+tl2oqxHhS22WV1lU2L/+n9UrChkBUvFoep2fgsow/IghSRV/S56IU1E7Dmjr3DMOLVj1+6tv/KgDgKUB3Y9u4DtAWRJRM7aP7mzrJGIjKuMkFBH6JhLrNdqcjRdha+PTyQPV3aMx6yhySHIB8DbADpI56z0C4zVVVJIoGSjjjVqFiSQgmwBZErD5SZGnpuBW6u4knkslzzfy4kpKJsa2ZaQJwVp59VhV8Z7jyz1w6+Yjo60bkldt70+uS04t6vNDZUXGwahaomPkxrMBBlT2jEmWtyWcf699AAFKrXdEqkharo+A8dysHMBgVSwaLa3JuhVtIWQEYxUJOwAB+CH4VpJeBkjA4hFuBWoBhOpPEWNHQoom5Z4WQP/+dQ6PTB2gi7zm1XTTKchC47EGC33bdAslbDm+OlGpHuVUKmZpvlhyvTtyL0DTmBq0IXVXf0Y6GkQ2swMPfT10DzYcRAREanNwsnBGuLIU4err9IYrvQCBP9YI5eutg2leF8IchbKsP+kl3k1CeQi6sdojaqwUfBxaWBaS4YNVif8AEnNI9IUu2PI6YuHqrI4phYqh+TVQTsPnmSVUU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(6133799003)(22082099003)(18002099003)(3023799007)(38070700021)(4143699003)(11063799006)(5023799004)(10067099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?muoKohrgjhpEv/332okj2Xc9FQSUkBkQw1vaxktPbUAGrEDig3fhpUPT6pIQ?=
 =?us-ascii?Q?lUfLQHFQrPVmMglnxA6HBayyuEiKsbo5q9mo9ST0JVEwbjOdbsINV+72YP47?=
 =?us-ascii?Q?T4ZFNINxTRLjVyryur09jKv2W7bzIMnJlgakUIUGyjDRikyoIuyO1RFtGQrR?=
 =?us-ascii?Q?axeb5njzBo5t1QjTLNZA28qQZ8Ih3GlZUGF0RAIE/EQnncEl9UOG/zcJawL/?=
 =?us-ascii?Q?ew5nJY35rgL8BLqE+beUewM70poY5CriMMdANwy09KNMvXvFewZmvxSZCwNM?=
 =?us-ascii?Q?iLv7OCY2wePMmHrMS6aAtNiO+XrDOFEEY1/ysxRR4PXj2I/2Dv9D7awHD8Sn?=
 =?us-ascii?Q?qRp2wTPRVFLYeQzSfSbafoOeUY/KwuZbNev7R21xS93JUIjNvZfQweCp1dN1?=
 =?us-ascii?Q?otG1IanCoy/kf1E5L/WcK+jIeEdnnRNR8nJIcB7oByW0IJnbkSRr6Ze1Vbsx?=
 =?us-ascii?Q?k+nOSGCcl3CluqAdHHgm20oinBH/oxaHLQfKh650oemNnlOfzgn87Dc67gGy?=
 =?us-ascii?Q?U0fVfT2Jb4rjVWYmR+Inn3TtgeOyGeq5BUbXTmoCczzJMvDBp4K4UyY2QUDK?=
 =?us-ascii?Q?rrdYhWqK6aFV3aDbwyXzurQOfoQtlx9aIBsQEF6W6oDTcxDR/9Z/HObZRyXH?=
 =?us-ascii?Q?jBldz9zYQ2Fy14t7BdkV1qPnoCwm+g06EgRaeJOotqJRaQgVanSH6GtbCnfD?=
 =?us-ascii?Q?d3+JlDgpmE5XNuj5U274uErPURej6X1qz+fV0hPAJC5rgxcXUtUFFQ2IRhwg?=
 =?us-ascii?Q?RS3Uf8H2Z+uWlajtmJ73U659+TF5yzVGYUJE/U9bWklCEmTGEmW7DSotpS3q?=
 =?us-ascii?Q?G8tvyIW2NkSv5oS0a+1DScJYmMfzoxnkKmZ5diZoAIsJOdABH0NjhYhSNgvA?=
 =?us-ascii?Q?xEayAPaLbhopnAgOVuuU/kSbJUTGIYZxyUeO4vDef4CQ4LvRSMuce4QYKECw?=
 =?us-ascii?Q?RvKCSNNC+KguwNVEFjMijX+gB3HPuFzYaq4KudX9MRlxpdcx3St7RpeUGGFq?=
 =?us-ascii?Q?105rjdKwrlev3si7Y7WPW4k0a98zLXo5BuVkvqGn6qoxFEnptxD6iNGhXscZ?=
 =?us-ascii?Q?lasJaCxrghp+HiWWNXQ4LdPXeGlBf2uTvxkdyRAecTarPkSb1w25mV+CAgHH?=
 =?us-ascii?Q?CDnudIRFKOFcii08oLHasMy8vgDWzYZy6fbG6i9cUx0AEVOnFEhjvAltK1SV?=
 =?us-ascii?Q?v+tVfkmUnsy8H86GcH3oMjOd9tCWx+Benm0R5gP1/+16syTp71plMgSCqgWM?=
 =?us-ascii?Q?frtqhw7HXH3lBNA29wLBV99xm4sgO5f6rguHX7S2V7O7tM2REmTXiAuhxdXZ?=
 =?us-ascii?Q?jTqwjajA4qRe2cMCDzQFOqyyCX4Hv27NSHEQjx5NFFb0wu2DiEC6uX3lbdrl?=
 =?us-ascii?Q?iRKbEXJK+zOd4m4KTgN4/txH7w02n3a7tI/32AcHOXF+6yXbmrS7AUuQpzQv?=
 =?us-ascii?Q?LStbhEk8LPbIy36ItjGWQS0RjvqMm+wKJDq57s7128haLIUlK/cuovqT4JJu?=
 =?us-ascii?Q?k5iykLxjDWkeurK+G+pl+AaMcCHQCyb6RM+HtgYMEbE3D3BTAPLZ2yvY05ah?=
 =?us-ascii?Q?7qc62/WnTTYdtCRdqPKZYtczmXV/6C5lV4frROuQs0bgR/viqL2FKRpTZlIc?=
 =?us-ascii?Q?EJc2O6Zst49F3XZYnJfNnWjjgTxh9en8f20FA5oipYsPysh8L402sAAbTGj+?=
 =?us-ascii?Q?CkklZ9d7JsQdDu92SCm2nfiLpTYecQB42JjxF+NIwkb7eVQbDWG1HIBwe5ya?=
 =?us-ascii?Q?/sUywtAbow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: zyy6tNDujCPUEQHvCSHWEMv5cWh/tDTdIJiM6PBt+ZFm1lyrWoT0XFUnrJmGjidmfcRVUeQnlFdID0UCE+XRobNAW7KD62tCk5CgTtHer36grL+8fN1v0EpZS82tTwJeU7XbeztRh0XIgdeFAxfvuWMbqnOgfp/MmyJBYAGuYUDAftTD8sbMbijferCVkKOsKmcgmvcrAGhTimZ4SAxq91tAwDfYvoIhlbmdFA2+e+6A+iNitwe5OaNF2wgGd0ecZ7M+GOxUDAlttxa6DsepeMskF2qKHd9P3DmmI4YIbam3PP1PQiH9+GK1YcZQi4lQmJS2hUQ3V7dJEfNvM51pPg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1195efdb-1534-4076-d435-08df1462ed67
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2026 02:25:23.1366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDXY9g5cVti59J4V9O008ND3TOwZwCm0rdpt9zkRQX8a9CFH5BO8AA0ixzs1nQ/RE0lfdG75NAbxX4CIFYfQiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6615
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, September 16, 2026 8:40 PM
>=20
> On Wed, Sep 16, 2026 at 05:54:57AM +0000, Tian, Kevin wrote:
> > > At least for ARM there is effectively no entanglement with the actual
> > > host iommu driver. The viommu is entirely provided by software in the
> > > RMM world, so it can have its own dedicated driver. In ARM T=3D1
> > > transactions are alwayus routed to the RMM's iommu and there is no
> > > relation to the host.
> > >
> > > I am interested how Intel works here, but I thought it was similar.
> >
> > Largely yes. Main difference at Intel side is that TDX still relies on =
the
> > host to initiate iotlb invalidation (upon notification from KVM on S-EP=
T
> > change). Currently we put this logic in intel-iommu driver but it's mor=
e
> > about wrapping invalidation info and passing it to the firmware. Moving
> > it into the tsm driver should be straightforward.
> >
> > Maybe there'll be other subtle connections to host iommu driver but
> > it doesn't sound a hard problem to solve.
>=20
> Okay, so I saw the driver posting for basic iommu support, can we try
> to rework that to be split out like Aneesh is doing so everything
> about TDX calls lives in tsm and intel iommu only provides a small API
> surface to exchange whatever details are needed to bootstrap TDX
> module?

Yeah that makes sense.

>=20
> > > AMD is different and I suspect AMD will have to continue to use the
> > > viommu from the AMD iommu driver, but I am not sure.
> >
> > ARM/Intel may support guest viommu in the future.
>=20
> ARM supports guest viommu today, it is in the public spec. Secure

sure, I meant the secure part. :)

> guest vSMMU is entirely handled inside the RMM and has no connection
> to the host iommu driver. It is a <100 line ++ on top of Aneesh's
> work, Nicolin posted a draft at one point in those threads.
>=20
> I anticipate a future intel guest T=3D1 viommu should be the same.

I expect so.

>=20
> Thus I expect Intel/ARM to have two viommus, one that handles the T=3D1
> stream owned by the TSM driver and implemented entirely by calling
> TDX/RMM.

and this one is special, not tying to existing IOAS/HWPT/attach/detach/etc.
semantics.

>=20
> One that handles the T=3D0 stream owned by the iommu driver - and it
> already exists.

sounds a clear split.

>=20
> > So AMD's case is a good reference.
>=20
> I think, AMD is completely different. I keep forgetting thier thing,
> but IIRC they have a secure DTE but instead of having the secure word
> control the translation it controls the RMP and you end up using the
> host's translation for T=3D1 traffic. This is fundamentally different
> from how Intel and ARM are doing it where the actually IOVA translate
> is under the control of the secure world.

that reminds me...

>=20
> Both Intel and ARM put the S-EPT into the iommu HW directly.
>=20
> So, I expect Intel to have an API similar to ARM. When you create the
> TSM viommu you tell it if the TDX module should create a secure guest
> visible VT-d emulation. TDX module has to perform the entire emulation
> because it must be trusted. Existing viommu ops should cover the
> remaining to register pdevices as vdevices, provide the vBDF and so
> on.

will think more along that line.

>=20
> > > How/when the tsm driver links this to a arch specific "bind/unbind"
> > > operation is more up to that driver, but I would expect what is
> > > thought of as "bind" should be the affiliation of the device's T=3D1
> > > stream with the viommu and the target VM. It should not be sensitive
> > > to the TDISP state.
> >
> > Not sure about this part.
> >
> > Each arch has its own definition about the binding flow (about 'how'),
> > but sharing a common step by sending TDISP message to transit the
> > TDI into the CONFIG_LOCKED state upon guest request (i.e. 'when').
>=20
> Sure, the LOCKED command can be relayed from the guest, but that
> shouldn't be called BIND. locked/unlock/run/err is taking a iommufd
> vdev that is already affiliated with the VM to a specific TDISP state
>=20
> > According to the TDISP spec, memory reads/writes with T bit set is
> > accepted only when the TDI is in RUN state (except MSI/MSI-X writes
> > are allowed with T bit set in LOCKED but I don't think any arch support=
s
> > it yet).
>=20
> Sure
>=20
> > So your definition of 'bind' essentially affiliate it to the RUN state?
>=20
> No, it is informing the secure world that a physical PCI function is
> now a virtual PCI function, is a TDI, and is in a certain VM.
>=20
> Outside virtual hotplug this is a permanent action when the VM is
> created.
>=20
> > > That is not prohibited, the TSM driver could do some auto
> > > "bind/unbind" whatever that means triggered by ops or tdisp state
> > > changing under the covers. But this cannot leak out as some kind of
> > > asynchronous vdev destruction.
> >
> > Maybe it'd be clearer using an example e.g. ARM to clarify the
> > suggested split. Or wait for Aneesh's next version...
>=20
> In ARM:
>=20
> BIND is RMI_VDEV_CREATE it links a physical device to a virtual
> device in a realm.

TDX: TDH.TDI.CREATE

>=20
> RMI_VSMMU_CREATE can attach a vSMMU to the realm and there is some way
> to link the VDEV And the VSMMU together

TDX: TDH.DMAR.ADD

>=20
> Some sequence of RMI_VDEV_COMMUNICATE, RMI_VDEV_LOCK,
> RMI_VDEV_UNLOCK
> and a few others manipulate the UNLOCKED/LOCKED/RUN/ERR TDISP state of
> the VDEV.

to locked: TDH.TDI.BIND
to unlocked: TDH.TDI.UNBIND
to RUN: TDH.TDI.START

plus some other commands required around those points

>=20
> I assume TDX has the same general shape, I don't know how you could
> implement this in a radically different way?

yes it's similar.

>=20
> So iommufd viommu create calls RMI_VSMMU_CREATE
>    iommufd vdev create calls RMI_VDEV_CREATE
>    iommufd viommu op ioctl calls the COMMUNICATE/LOCK/UNLOCK
>=20

so in this case BIND is essentially CREATE. Probably link/affiliate is a
clearer name in description to avoid confusion with vendor specific
bind command...
