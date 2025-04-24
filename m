Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68A01C6FEA
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508258; cv=fail; b=RDK6ydwwfno8GSUlItHj9qQVgZYLUEiBTkAlM3LZ9/PaSHPq4R3vgE7QcTFP2XomLC/ScVl3X/UquO4y7UkzOo442LCfN5mP0RT2HIS4t/0aI56iLx2lFMN3LPplZP9TccxxaHJDzH+/SNDDwRz8AjZk2xD4fUWamQqgrkfoN7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508258; c=relaxed/simple;
	bh=i1XKhiqyh9lSJQx4mSw3v8TUM1/CY/MQ6wOMZ7Mjt6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rYOD0JFZ9M6v6Mpw1xc/0cgOuc1TxAdn29eC6seYdSH8PY+irR+aB8BctHxLRwORScKpJiERuWlU/BpRI9Z3R3vCp5d4Ls1yLVKpv9ctyQokOVJ+7Ud6M9IURuG2BmSe3CxRkRcQ4mUd1bm7gR1UIXQJWVnhCqplpLKWTr+ZvIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cPPodkX0; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cPPodkX0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745508257; x=1777044257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i1XKhiqyh9lSJQx4mSw3v8TUM1/CY/MQ6wOMZ7Mjt6c=;
  b=cPPodkX0yGi5AO8S35H116mzm2oPpaD/SMn6mh5g7F95yplRCEJazNAQ
   bR6jQHgyXkkz5lONnPD7t9PjTudyuu6Em0P3GIO3vbKLYZxy9hcPDWIlR
   BpZPPs+byVx/9hzIo2x4F7zQyQ8PmvXnNEWp+XBU+VoeJfoGDdeML4iXo
   qSrO0uMAPBAsD+pZpVa6FQd4bMnnVKmsGf0ngNhemSjVGQ/dzez2SrLck
   PUR4ogOeYNYOYnuagM0MZ8rFupA+HOIU8GPj99GDgIi5DIF6AS8MFOEro
   RVPjakw2Vhfhj9AwD9AS2a8JzlhyL8vi+EbMrl1p2dcKudwbUYpc8McAL
   A==;
X-CSE-ConnectionGUID: /4i3yhiqQVuLP74rf6ocvQ==
X-CSE-MsgGUID: IG9pTcjmTP+MkwD07fhf3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="46864663"
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="46864663"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 08:24:14 -0700
X-CSE-ConnectionGUID: X4chSc92SseO7WUEHG++BQ==
X-CSE-MsgGUID: tZ3w1560QdSla1JuKd11FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="169862474"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 08:24:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 08:24:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 08:24:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 08:24:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yWOhKoMgcc1sWCCFUu7fdilvKo5X9oPJt7xoqyYHaCO4errH9A0U5lHHg0i684pWMNvUZexCK641Smc5VwGvljiBWMky5fPu2wTYml0/rpbVnLUBcKnfeXTf4mSP9yfSafVXzVJ2aoY1Fe9z+sqAyw6cxu2Sz+DGw39Xwd9PBts1B5UVEYPM8Qv6GZ0+bk3AecRdzTipj25TKu1Zh+1kvpo7S1juiro6vboUXoMB+Y5csDeN7vqdqTGyih9zx0GYxqcuPC/uirXBr77kNwY1T91B2HYP2j0Lt55X9jKJ8tATt0T1gXg0eboEBbST4wE+OlI4cbDtzgroQaYbssh5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8/gLHYIIBDXwab+DrY1rc98eAMI2ts8Ml0d5JaX2t4=;
 b=v6Z9mTBnpAVQCIZEnoTYGxHaNvYVr8yx/bNPEZZiSDR14TxWvMwWO7bL8kHzHeHGkLmkdGeobItIl734HS6yK4qJCw0Q1XxUicqKoWH+D8Fugm/u0o4v20rEx7NQOPRtzgMIC8jY+IXxXnkuFiikNHfooFLc34CDzWW3SVTPqHYlXByprZ6UgMTiMwXhkoKeP6p1WLcfKXOCohY/NUMMerQp5dBsezqY0lujYDHLClOIk8ug4+ny/QoIqyRQtczZWz6PyvdhtrfxPVFjUPu7J6zcmZ0eUh9BExnaIVexLctLRwSag+gEiWb+OST05Pq+r44htMMday2RfK4TkcgRvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by SA1PR11MB7085.namprd11.prod.outlook.com (2603:10b6:806:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 15:24:08 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::215b:e85e:1973:8189]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::215b:e85e:1973:8189%3]) with mapi id 15.20.8655.025; Thu, 24 Apr 2025
 15:24:08 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Jie Luo <quic_luoj@quicinc.com>, "Russell King (Oracle)"
	<linux@armlinux.org.uk>
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
Thread-Index: AQHbtCzwqS29KFwsakalRi4XUJvnbbOoH9IAgAkbb4CAAbUNYA==
Date: Thu, 24 Apr 2025 15:24:08 +0000
Message-ID: <PH0PR11MB50957B606B76490E205923F8D6852@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-3-6f7992aafcb7@quicinc.com>
 <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
 <2b7ca78e-18f8-41bf-979d-8d502f6f8fe1@quicinc.com>
In-Reply-To: <2b7ca78e-18f8-41bf-979d-8d502f6f8fe1@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5095:EE_|SA1PR11MB7085:EE_
x-ms-office365-filtering-correlation-id: 97cf7960-5499-489e-7d2b-08dd83440eec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ieRK0i+A3um1ILzk3cw5z2yud10fFS+yYlQGXY+sCnJkPI2BtLgo9DVVo7dE?=
 =?us-ascii?Q?PhK8/cR+3gcL78W6cTxKfSyr3Jz2yftgr4wrt7HmRDymneTtLeKJ/80GFWQ6?=
 =?us-ascii?Q?8kThBzlUq9Z9ppE/oAL57KbKz22Ejl0AzJkthAZw9BL5AyUMANaKIh06QYFP?=
 =?us-ascii?Q?gTYTbcGid0LUnEtvIY/cV0KejcbWa+6iXepUIiQ9GS9fK5R5WhGGA4jJ00n4?=
 =?us-ascii?Q?ChFLKbDa0g19ZeyYe0pMCPsm1axcr5OV/FtlLh9ONIdzEHAItURplQPjC51+?=
 =?us-ascii?Q?ThLMMm2QazQf2rbR51giWZC7OgOqYJ24xGuV95iMnhtatjWXJXeBzoZ5o3P2?=
 =?us-ascii?Q?8R++chvFsDkDbKkS89P+reEPnqcLBJLdVqsqMOTv3pOrxc7rlHW4jgbrBxCJ?=
 =?us-ascii?Q?OFa5U+jEF9E19OV8fOMI37i1wG0okbawgxQc4ZHMFboeZPELTraFaHd9dKGP?=
 =?us-ascii?Q?gMTnXzZvSvPoy1ZgWIwfZmxdV5AD2wpKCZrnMlw1bGAw7qWgUOqfEZZD/pSS?=
 =?us-ascii?Q?hAHKC4uJG+vaIcNveRTPZerteAy6ibKqAdEit6Nw+6q2BzIMj/7gIIl1JoXP?=
 =?us-ascii?Q?wxu/d+0j5g13gjehXl2pOp4a/mEoeuJHsBkQyT8RgpUJDNAW7iQ98PhaCmk6?=
 =?us-ascii?Q?/cNGGDgMecNksONxQt6aRhr4xnp6XRd7h9k9Rdko03y/YFNW94t9H8FcW2Fp?=
 =?us-ascii?Q?xeZfkNavjFtnLewy4Ga09uIknNfsIidRi2OAuw7uEP2N0kFdgRFZFSuSsUhK?=
 =?us-ascii?Q?lV2NVhfvhVasBRdXkcgnnWIRUVyCEAIZLdt7U29WkHfehkw/AKXl3Zl/y/Ea?=
 =?us-ascii?Q?AmfLfz2urf/gTmc9cnqET4WfZ3TfcpdQ47hsfQzHnP1jd23ntIvAhndtflPa?=
 =?us-ascii?Q?TnzqLpZF9rTtSF9zVp5xhUopSca9aUYwxWhnvwtg3MK/yn8pZFxvm2jI/ErO?=
 =?us-ascii?Q?EeERReBQett6LODa4OrKEs8v4hbgGNpTjz9NVyGyLlzXwhMj1az8LFidH02g?=
 =?us-ascii?Q?IWVbOA8UDdD/cZNpZzwGouy97S8CNXu53EvYtX0oMVdI+VQhgNyPg/H0gu9Q?=
 =?us-ascii?Q?+HkSmXvZuKpA6rkryxzjG6OijvJQDSRVp8n4GkeRwb2r6Op4J/q5sUYVxKb8?=
 =?us-ascii?Q?CSbmnJHaRDoFDNIeR2IGThnDBIPfdv35imsCLjYL+g1XJUKkJbIIdJvuQXe7?=
 =?us-ascii?Q?Ll3Y+HNbj9RyPhvDp+ZZiPqbEVE5RXZp2Yjx8NVogDCTOzYtKfP2Tjgay/YA?=
 =?us-ascii?Q?/waDVyxEbkKRGbJSnvKLqKQyU1IA0S0a7DoiVR0PbwaD10Sb293yBztCXKvB?=
 =?us-ascii?Q?oqEh9Ers0wCW+ftQib7U27/NwJ7T+FneuRHU8LkCJMQ7phnx8fCMMgNberRE?=
 =?us-ascii?Q?brDw5wxSgJoNH1aY0GQbNo6ijqa2M/MAnDGQMpaWBveY38dZV8Fp83AwB7qm?=
 =?us-ascii?Q?XIp0iqbJHFU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1vhIy2pkzz87YGb/QyTOeowgP2WOtiQpHGhM4dgszwsLs9YLqcenl/O65Qs6?=
 =?us-ascii?Q?ONXSCnhR9wkgO65ktrogoklRxH8osWzt4Up5Qbeow5sKGux/zRZSJAOxZCCW?=
 =?us-ascii?Q?A7K4Zj2qDpyPl8n12jQa1datNvtkxiYurFKf2r1WG28yKhFFLFM+1RjogmGZ?=
 =?us-ascii?Q?qmWPkIV4Bq24MCB/ZPSvUgzh9+9CTTMUZpUlNvcYARGzc/i7j7XkfgVDjMAi?=
 =?us-ascii?Q?m0i9E+EI/9FkXl7GxsXYyGuor77+1b3rHPrzLtGrKDY9Q3x4Kh/A3SdIT54N?=
 =?us-ascii?Q?pkYQOMHzhmmlRcHVS94db/yfYti9oDjr6+F3GkxsO4GupebFB1tjoqledy4n?=
 =?us-ascii?Q?qrwSqejttR/IcU2iymAWVvh/LU904o7/56VypNp4vDkHnv3Y93KvH3boMNYr?=
 =?us-ascii?Q?zGcWZfQt1kdbjLZrv+O5xjbNhy7u66Ee7q0sxxioyiEOU7692t8qzQzoxJjn?=
 =?us-ascii?Q?wd0gkwSK2yT929mhvexOS496xCGG8rwfD/x4G6SaA/7yLu2+1DlsJpu6TWHa?=
 =?us-ascii?Q?hPzS6GeDtGwquh0kct76JoUtrx62LIvY4nVtMebTNB34pNJpvFMoDRZJK/iG?=
 =?us-ascii?Q?ti/QwtVuAEbCwEMSIzWJ55R170mtETTZvucVxXSSz61j0NI3Zky8j0IwroaM?=
 =?us-ascii?Q?UaRv6puAi8apr6DfXkbp2R8qsth4inQMZZYFSMQVxDIp386vkaGKBsRQ2Vxy?=
 =?us-ascii?Q?jj9PgFB9I3lv7mT0IJXP/J/DJkrnp4RZNRY05v2iIYqA04xElLjEwqNeUk/t?=
 =?us-ascii?Q?mYtIumL5FxfpAgvE9SyYDD/NXmVP3kvC5GwrPpvJfJhHqrgHXhHOqrW1A4Jz?=
 =?us-ascii?Q?sg5G1hcNleUdBftKWTNOcYDmweEauQ0b5Lg3tyrghpHgdv5oHwFTuvD0VjS0?=
 =?us-ascii?Q?EwcFf72XnwGxGX5jnMpd2pYm24nWSgoMtqnk3Rbn46kFDuwrKJXbrHd4sbUJ?=
 =?us-ascii?Q?0zX5XdffWLNnleR+0a0pnyeih/p+rOgpZRy6BuE7nryMvozo6uCq5B6CAYdW?=
 =?us-ascii?Q?VjL6/yJIgM4sybs7wAYU+9toV3fUeHukss818w2a9wAP/yQ+Ctbp6jre5UpM?=
 =?us-ascii?Q?iImF+b8Srl2wLisDcYwgCF+at5p/RMR579owU523eEH524rJxMWpUwKKw511?=
 =?us-ascii?Q?OKVHOmUMEvbSPEsChddOKI4YJhNY/6BRKNbhXG5AExCNgobCnhzaFwoAN6hl?=
 =?us-ascii?Q?tsxq+bbyCn4m2TAQ0ROhzdcJWus+j1zwaPVeqgPmPDoqX+z7xIUfJ3kqEcVu?=
 =?us-ascii?Q?07cfrxS0iL9MCdurEQdJ8uzEtO7HMjuKdoghCiwyjsaYVW86xItPT+PGIyLq?=
 =?us-ascii?Q?gpWZGblTdVQwKNcE5fLYGQZkGm2BECYoOnYx364KpzBnNAxmEc4edk++0pJM?=
 =?us-ascii?Q?WUJpjIb2Befm1y8waIVN2WMB9/lO6MWHj0eQ/EbEePeHB4V5SLC/rJ4SNcG3?=
 =?us-ascii?Q?x00WtvQiMBbW1jWAcqgEHdclA75u4lutFHzlneexx0SjhA1wgEdVpDKhcvep?=
 =?us-ascii?Q?d9L3RcuKIlglfQ0BGcEnusf+gaXN6lEC1c0e/YChkqx1qM669vcaH/kVtpNC?=
 =?us-ascii?Q?70dpHgqnCvdnex7Xdh2D0pbIshuw3GoPeMBd6Lo9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cf7960-5499-489e-7d2b-08dd83440eec
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 15:24:08.7851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R/LfsaZNoJND62+TqlbG0a24kqRM2ijdBbIli1a4bt8mhsFloVVl4wCrep4dTmbHtHFkKXE3roKDBe1LlhsfJnhZw74jRzz9IT2CTUWEpRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7085
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: cocci-request@inria.fr <cocci-request@inria.fr> On Behalf Of Jie Lu=
o
> Sent: Wednesday, April 23, 2025 6:16 AM
> To: Russell King (Oracle) <linux@armlinux.org.uk>
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
>=20
>=20
> On 4/18/2025 2:11 AM, Russell King (Oracle) wrote:
> > On Thu, Apr 17, 2025 at 06:47:10PM +0800, Luo Jie wrote:
> >> Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> >> - reg &=3D ~MASK;
> >> - reg |=3D FIELD_PREP(MASK, val);
> >> The semantic patch that makes this change is available
> >> in scripts/coccinelle/misc/field_modify.cocci.
> >>
> >> More information about semantic patching is available at
> >> https://coccinelle.gitlabpages.inria.fr/website
> >>
> >> Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> >> ---
> >>   arch/arm64/include/asm/tlbflush.h | 3 +--
> >>   1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/tlbflush.h
> b/arch/arm64/include/asm/tlbflush.h
> >> index eba1a98657f1..0d250ef4161c 100644
> >> --- a/arch/arm64/include/asm/tlbflush.h
> >> +++ b/arch/arm64/include/asm/tlbflush.h
> >> @@ -112,8 +112,7 @@ static inline unsigned long get_trans_granule(void=
)
> >>   	    level >=3D 0 && level <=3D 3) {					\
> >>   		u64 ttl =3D level & 3;					\
> >>   		ttl |=3D get_trans_granule() << 2;			\
> >> -		arg &=3D ~TLBI_TTL_MASK;					\
> >> -		arg |=3D FIELD_PREP(TLBI_TTL_MASK, ttl);			\
> >> +		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);			\
> >
> > This could equally be:
> > 		arg =3D u64_replace_bits(arg, ttl, TLBI_TTL_MASK);
> >
> > which already exists, so doesn't require a new macro to be introduced.
> >
> Looks like the new macro FIELD_MODIFY() is accepted by Yury, maybe we
> can keep to use FIELD_MODIFY() with this change for better readability?

I'd prefer this version too rather than a pointer that modifies in place. F=
eels like it fits better with the other FIELD macros which don't take point=
ers and return their bits by value.
