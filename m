Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154501F76CD;
	Fri, 17 Jan 2025 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737097039; cv=fail; b=mXl9d4/isD1Q5tM3C1Zl7WpSClL56r526A/xsxHDcJrmxE/aaosfocxqOV1YPWGrTvLK71l0X6FH1IV4Uf8tqbDFDFwbbPMGwAd2uUEb1xmkZMiS3aEtIHlh8vy8t3Id/LSHMxdjkajCkG8MwZyUfYVbCXIW94tB4uCENDF6vZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737097039; c=relaxed/simple;
	bh=UyN7mbY4ZL+u4pfoNzK2UNe17I9lvIL/UGYPBjeAm90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WXM7knER6MOZIDaswKYJjpJ5fOQKkCu9kkr53yfNHrzbYOgVUrgp+avZm8bQwCTTeCpBk63YguCJOas8Nxm/0Qc6Iwznp5PddOdCn3WMX4z6t1gh4jfSbUwh/vjdkDGmO7JhWuw5V1Q7UE51V5YoYUnl78q8Zu/7Vzgyq9K4JaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbnF5ORE; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbnF5ORE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737097037; x=1768633037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UyN7mbY4ZL+u4pfoNzK2UNe17I9lvIL/UGYPBjeAm90=;
  b=RbnF5OREA+Omov3EuQIh4GlnhJJcozsMYizvieEgoAFiv+N+c/edvheq
   4STSmwIfquA0JIc9GIbu8zMyvyPBCvWiOc5wUrWNV0cKhuZTDgkiYcEpB
   XPWSjxwe9ebZf4ihXNO3JlzWHeWl0A+9to5wh1yB7CRE/ZfUrhaU75ycj
   YgFaCHBNWedffnlFaCm6TCJxQlmsgtKz2FdsibsSf2Qt/q3cnowebVic0
   hModauEZYL3OAgNniIf6DeDBU65PB1pZ/6wN6xRdcVOMjBx6ISAlAN6GZ
   KanCfECIqD32FhWk5TbLOeOTTxczpS1olBWxmnczvBRUbVer/bn8nKugg
   A==;
X-CSE-ConnectionGUID: aOglcZUnT6O6O2jO8JtNyg==
X-CSE-MsgGUID: AlvrCMGcQnCLfd80xTXW+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="37756195"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="37756195"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 22:57:15 -0800
X-CSE-ConnectionGUID: T4XbOP4YR6O7UFzwDw1vIw==
X-CSE-MsgGUID: vAxoUFUQRISq1KJZQkSpFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="110731875"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 22:57:15 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 22:57:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 22:57:14 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 22:57:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFz6tTSkcb4Ec8yxBRxShKbCWmL+oNE9FoYl+Fv8TnVoYwY9TFcxuqNiR3RIUp3zLtiOhlf6wGbc0IAMgXpXxV8KVbSx51DYSeXgTcwlrO/BsW1NHYXWLYcAVTPU0gvgRGvrPWfoekcVbpc4p3R7DqyFpNvaXIR9c0GxK4eoDmzohHAzM+QU4boLjlJ8v8hp5uspjvnkq1UhbYsECFvpvdIHOzArIScZkwZO7aIeYN+DONGiHdqlaqcI3iVFUopW1QNJh8d8ffeweI1f+YmC2G+FngVvv62YzbTUAM/FcJx+afqTFccQuMx616W9FkqVPXQvR+TPi5VUyNgwMslLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyN7mbY4ZL+u4pfoNzK2UNe17I9lvIL/UGYPBjeAm90=;
 b=VlYT8B3Ma7slqwCYLDu18/41U4pjZ76bRXJ3tdpAIVXQCQxypemJ5Tx4AQh3SnjD4sOWTS2kCv6Cf6p306eh1gXXu/+8aZ+i0rdo4MtiZaK7uT7PBeT8xkS8Fl1gRNHvhcjv+iuRWn21RnULPx5omkxD+I2+W4GicqNZqoI98YNSS5vReBtdVRMEw8FavDjmQ7FSpCqzz5Nn/47iPbOZC7sfPYO2J83V/8i5leKZtPop0HNGvTkLoEqLednVSHzWPiC18ZsAEE4f0L5nbl9LqSljaypJ5nKpKwoZO/riVCueF+3gU6SAcAAj/mcZjdMgIKc13gtePKV1amID1uGGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.15; Fri, 17 Jan
 2025 06:57:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.014; Fri, 17 Jan 2025
 06:57:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Mostafa Saleh <smostafa@google.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "robdclark@gmail.com" <robdclark@gmail.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "jean-philippe@linaro.org"
	<jean-philippe@linaro.org>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"vdonnefort@google.com" <vdonnefort@google.com>, "qperret@google.com"
	<qperret@google.com>, "tabba@google.com" <tabba@google.com>,
	"danielmentz@google.com" <danielmentz@google.com>, "tzukui@google.com"
	<tzukui@google.com>
Subject: RE: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Thread-Topic: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAwvyuCAANmegIAAwowA
Date: Fri, 17 Jan 2025 06:57:12 +0000
Message-ID: <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca> <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca> <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
In-Reply-To: <20250116191455.GC674319@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB8123:EE_
x-ms-office365-filtering-correlation-id: c3b83af8-2042-4d02-c614-08dd36c42b3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OHkxSkxiQXM4cms5UlA3YjdVSnkwUWI5d09qZE5YNGp6WlVUSnA1ZmhWWnFm?=
 =?utf-8?B?V2ExQzJxOCtJa2ZqMlJjSjdZK3UvWU8vNXlTTS9Zc0x1Rm11QVpZek9uQkxr?=
 =?utf-8?B?NHJxRDQ3dThaMm1CaW1lNnFVempqalBBSUI3T25jWS9pUUxQTjNKRzdBNzV2?=
 =?utf-8?B?UFlPTHVhVjBJWXQwS2ExRjVxTG91YW9XMjVhYlpieTZsSDlWNmV6MGFTU3Ax?=
 =?utf-8?B?RjN2eWROVVptNjNreHRNbzF4V2RrcnFldytDQ2Ewc0lvaUd2YzQ0TUFnZXR6?=
 =?utf-8?B?dFNLTDd1enBsaE9TNFBhSzVUc1FWSXZnc3hrYU1jcmRVNEpIVEF0LzBCa015?=
 =?utf-8?B?QVc0NVJkV0JtMVk1VlpZOHZlQURCbDNOSEF1cERrbWpSMlBQQlpiNWVlOVFj?=
 =?utf-8?B?Zk9DUTEyMmtUQ2pOaUlMOENZSXI4V3F5UU9weEtMRzNkY2p1VUpKSEgxVUE4?=
 =?utf-8?B?OFBHSFd1REIvaTdmT05YZ1R0ZXMvaUV3Yll2STFDRVNjdU1xTkNNenAxVzNo?=
 =?utf-8?B?TnFpcjJDTmNWS0g1TUhHSG9Qc3JxcjBWeFUzVkljdnFEbEZvL0tBa0hvL2xX?=
 =?utf-8?B?dXN0aHZDMFJpTHAwNjFQNGdPQU5SdXo0b1V2OFhYWnRocEN5VDJMdHk0SEhJ?=
 =?utf-8?B?UmVXUEszeFBpcUtoOFh2UUN2ajNRRGszYm52ZytaUzRaZENWMERaSVAvOW1E?=
 =?utf-8?B?Sk1YRWRMT0ZqSzh3WGNDdmxGekxtenJkNTM1OTkxODMwVkRNNXJWTlNQUEk3?=
 =?utf-8?B?eE5scjQvdUx4Z1BaL090SllzdnRheWJIbFRyUWE2RjFMcXpCV2I4bndTcjZt?=
 =?utf-8?B?YS9LekNTclBCdFdzeDZZZ3ovMDFSenp6UTJPYmhvTkd2ekgzLzAvVTZ4a1Zw?=
 =?utf-8?B?OExBaEoyNHFIa0tQdTBjbW8rNDdTY2ZKMHpEeUZvSm0zTEFXcDYyQ2VnMkkr?=
 =?utf-8?B?S0E1R2pqV3RrcU5PRUtuWmFTZWI1QWJtaDUyY2dxdUt2anR5K3NTTktJSTgv?=
 =?utf-8?B?TVBNMW9VSCtSOGZpOVdhbUNvTmpMNWhOMmVXaHR5dzA3dldKL3NIRnQyUWYw?=
 =?utf-8?B?VFVxKzBsdi82Q3BIYzh6S1o5UysxdE5xK21YN1FwckorN01ad1BPblg1Z1JR?=
 =?utf-8?B?TU1kNFNQWWtLbW4vRHZISUxFVlVUN2UwTHBEWjVQdkp2dUpidDgzUm5pMytz?=
 =?utf-8?B?VlRSK2xhY0pPOW9ENUlrMHFSN2FYcnZ6QU9lOEhvVXlyRjNIT1dRQXRYTDN2?=
 =?utf-8?B?MkYxVkJLRWR0bkY2NHpnYWpKa0JxT0UrTCtzL05LUXNWbUcvYkx3NG00TkpW?=
 =?utf-8?B?cGRTTTJFL1QzMmRiYmNLZEpEcjQ5enFUZ01yekpXUEdDSUVUMnJURllIU0J5?=
 =?utf-8?B?RWpLNVVBank2K1ZvdmhGeENzTkRVMXc3SzlBWnZhQVJ0TllxT3V5Q2haTkM5?=
 =?utf-8?B?cGo3bGlxL2Y5NzNwMGUxWWtFNnU4Q0VQcHMrcTdSdU9QamlGenpmenpnb3A5?=
 =?utf-8?B?dkUxcEdEZlUwcVRxaTgxVHpkZjdkbHljVHAwNmlWK2Y5Q2dMMllScEtEYTJu?=
 =?utf-8?B?N1hqUkQzeDNiUGhWNy9ONXEzY0Q4QTdJQXlTem4wTHJsOHZMVEJLNmxYNWxH?=
 =?utf-8?B?MGpXd2djQ2paaUVFQzBlc1pEbXYvUUxabldCNWp2MUtTTlRGOWxvNnRUWUhQ?=
 =?utf-8?B?YnJWeW5FRmlvQlZ5clpuQlhpeDhPUStkbXh3V2RYN3lQVjRKL01OTXVHR1I4?=
 =?utf-8?B?OEZPbmYvR2RmK2UzUk1LY1B1cWhzY3k5NU5PejVsQWZpRERRVkFtNGZDTnQ3?=
 =?utf-8?B?aDF3SkZKdTFKSm1BRlJxbjg2QkdpTnhqd2xCQ2VGZXVTZEdQemhYNFZpbGkz?=
 =?utf-8?B?WHhLNUswQXlra2hMNE9HVzZ1Nm1HMGNxQk9OeU8xZDZid0tsN2NTckVkMEho?=
 =?utf-8?Q?vc+2iwZpv/lsII0hxGq52bDrLeYn/3jm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFRxdTFUQ3EvNExKZTFUOHJUbnFRTTlrZW1MU1dQMlJsMXhCN1R2NDFjMDhl?=
 =?utf-8?B?cTJYTkpaSzl5blZjNVpwMGRrRUV5NU95OTN4bU12dkNqMG8vVi9maVcwa1g4?=
 =?utf-8?B?b0lxRWN1UTFrVmtSbkgvSUlNcXpHZVdQSnpsS1R6MEcvNHVxSFBpRWVjRkh4?=
 =?utf-8?B?VTA0TGlBN3l3U0IzTHd2ZHcxQmR6MWRSNmlmKzZ1ZmdSOTdIUHpqNWlrQVRu?=
 =?utf-8?B?b2tiNlBXVnU3Y1Q0QXdwbEVQMEZyOHNCZG94VDdPOEJjRDZCTUY0UkpDUE1O?=
 =?utf-8?B?YjNadk9vV05vNlBWUm1Ea0NTbHQzc0NSQ0pLa2k0ZDA2cHdZSlNYSWhNZUU4?=
 =?utf-8?B?Y2dxbndKY3J1cXo0NUY5T2QxWXc5WXovWVdiY2NySmRWbWU3dFpOS3NZNTMz?=
 =?utf-8?B?NUtkd25hUE9DdXRXL000SHBxYkZqanRRSDBDN0tNVEttcko4dDZNTlVvK0dI?=
 =?utf-8?B?QmpseHhIb0RsaGV4R2RrOHVVQUZvamlrUGRWM0E1TjlrMWgxcVg4M2xvTTZJ?=
 =?utf-8?B?WS9CTXJJZW9NbWRzVkNpU3VnaGYxTXJqN2NkZmEyeXRFR0FhMFlHZW1qT1pO?=
 =?utf-8?B?VUp0RmVKQmZCOHpmR1MwRHR2NG5jMDhCUTA2cC94OTdRWUZMalhEYTIrNE5O?=
 =?utf-8?B?L29aWVdKUUFtS0UzUHllbjV6cEdFY25PeStObExzcy9rWXpxNzh2UDVCdkQz?=
 =?utf-8?B?R3BZR1hOK0FMRlBmQ3dvdFJYNXBqZjNwajU5SXljQVE4VEFGbmlkTXdodWR3?=
 =?utf-8?B?djlIVkprVU44Y250M01YclVUVllVbGRYNnhFMGgvMzMyUkhKWWxmR0FRNUxY?=
 =?utf-8?B?aFF4aytIWTc3a2FsNWYwVGltSUluTGJIN2ZxM09PWkFNV2U2a2xpTkJuOVNn?=
 =?utf-8?B?cnRaeGNpVm5rZjdMTnlGbXdTd3h5WEd2dVJ1NXJNSG1IaytZS2xIWlVERG9J?=
 =?utf-8?B?RngrQ3ZDYlJLTGhkY1VCcWpVbkNDcnlSakQxL21xK0ZGWFg5UzRMRW9qVmdy?=
 =?utf-8?B?M1JnVEpRSHpMSUdhZ3dlWEJGZU1DZFU4TnJlamZ1eUQrdGhLYzRDZnhIRnIz?=
 =?utf-8?B?OS9xZWYzbFdKSXlYTExCMnh3SlJ1MjNENzVlQ3pGTzJ4V0RZdnh2c3JoNkhW?=
 =?utf-8?B?SVJ2a0V4MlI5Y0JMbXh1clRlUTQ0WmltQTcwN3NRWERCUXNJL3hnajUwV2hH?=
 =?utf-8?B?OGtuN2locDhZazRiems2RGU0S1lwVFNmM1kvN0szS3d1V0psL0ovQVNjRG5E?=
 =?utf-8?B?Ti9nNG1uZUp0VXAxLzlkVW9Zc0UyU3M0aWJUdTlGL1JwZ3E3V29xQUJ2ejB2?=
 =?utf-8?B?UFJvcUVKUFRyZEsrWWlKWUxIanBCemVwQ0JvOGRxR1JEdkp5dzBZamx2OVlw?=
 =?utf-8?B?Z1lYVkVHQXZIYTk5MjZMeE10TlJ1cVZyQXVjcy8zQU5wQml3VEwvZDlwaHpv?=
 =?utf-8?B?NTJNa3NhbWpZZStseEo4cnRESTVucFFWVTRCeG5FTFBSdGd3bEZYZGZyY3J5?=
 =?utf-8?B?bnV1bThUeUFtRlkyVjFhL1NCKzZzT0drMEtERStjVnNRQW9oWUVUMEpJeTJL?=
 =?utf-8?B?VDBkUUloN3dDL0JrVUExMnVZSnJKQXJ3WUYwSUtQQTdUTUJ2SDZVK2cwVkZk?=
 =?utf-8?B?YmxNK1VORS82aXdnaUdsV3E2Y0hYbTNaK0sySGU2eFk4a1hTL1JBTTRSdDFa?=
 =?utf-8?B?NHgrR1ZTdHVvZWdvY1hXeW1JSnZkQmEvQjQzZ0Vyd2FFWXQzeEtLMXpKYnJx?=
 =?utf-8?B?S0laZS9xRlhKblA3d3NYRkphZTIyK2tQV0dIdFlLZjVSRnkxLzVHUFJmMUVR?=
 =?utf-8?B?MlYxbWNYWjBzSXZjVERWdWlXWnVDWkJuNkNFelM1bGpQZ3FqT1IrcVdkQkdw?=
 =?utf-8?B?RStDMHZvS1pUVFlyeW5ueGpOU01ldkJYb2pTajR6ZnJNL2d5V0NsbG81bTI0?=
 =?utf-8?B?VE1Qd0plZGphNGNGbW9KQ2FlNU9ZZHJQMm1HZmh6SVJxS245UHdTcFdIUCs4?=
 =?utf-8?B?N3VVTEdWN2YraUdOOXNwVkxFUlU5M1VTWE9Sc1F6SVNrbXNYRWJDcVZOWGJF?=
 =?utf-8?B?RERkSXZyWTh2MEt3TnZwOHZ4TWpsOHlxYVBlWUFrMXNmdk9FSlpzK3NtR3o4?=
 =?utf-8?Q?+Rw7D6dd5rHwg5NaVkEtMOaFl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b83af8-2042-4d02-c614-08dd36c42b3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 06:57:12.3324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C8RoCU+pVSyftM0WUgy/8XvtJcQPrZ9+HrZ9llwCiCzbCRykOXmjkUsU6t1IKorPUi38lMKxJcWkpuzMwXnrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gU2VudDogRnJpZGF5LCBK
YW51YXJ5IDE3LCAyMDI1IDM6MTUgQU0NCj4gDQo+IE9uIFRodSwgSmFuIDE2LCAyMDI1IGF0IDA2
OjM5OjMxQU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogTW9zdGFmYSBT
YWxlaCA8c21vc3RhZmFAZ29vZ2xlLmNvbT4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgSmFudWFy
eSA4LCAyMDI1IDg6MTAgUE0NCj4gPiA+DQo+ID4gPiBPbiBUaHUsIEphbiAwMiwgMjAyNSBhdCAw
NDoxNjoxNFBNIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4gPiA+IE9uIEZyaSwg
RGVjIDEzLCAyMDI0IGF0IDA3OjM5OjA0UE0gKzAwMDAsIE1vc3RhZmEgU2FsZWggd3JvdGU6DQo+
ID4gPiA+ID4gWWVhaCwgU1ZBIGlzIHRyaWNreSwgSSBndWVzcyBmb3IgdGhhdCB3ZSB3b3VsZCBo
YXZlIHRvIHVzZSBuZXN0aW5nLA0KPiA+ID4gPiA+IGJ1dCB0YmgsIEkgZG9u4oCZdCB0aGluayBp
dOKAmXMgYSBkZWFsIGJyZWFrZXIgZm9yIG5vdy4NCj4gPiA+ID4NCj4gPiA+ID4gQWdhaW4sIGl0
IGRlcGVuZHMgd2hhdCB5b3VyIGFjdHVhbCB1c2UgY2FzZSBmb3IgdHJhbnNsYXRpb24gaXMgaW5z
aWRlDQo+ID4gPiA+IHRoZSBob3N0L2d1ZXN0IGVudmlyb25tZW50cy4gSXQgd291bGQgYmUgZ29v
ZCB0byBjbGVhcmx5IHNwZWxsIHRoaXMgb3V0Li4NCj4gPiA+ID4gVGhlcmUgYXJlIGZldyBkcml2
ZXJzIHRoYXQgZGlyZWN0bHkgbWFucHVsYXRlIHRoZSBpb21tdV9kb21haW5zIG9mIGENCj4gPiA+
ID4gZGV2aWNlLiBhIGZldyBncHVzLCBhdGgxeCB3aXJlbGVzcywgc29tZSB0ZWdyYSBzdHVmZiwg
InZlbnVzIi4gV2hpY2gNCj4gPiA+ID4gb2YgdGhvc2UgYXJlIHlvdSB0YXJnZXR0aW5nPw0KPiA+
ID4gPg0KPiA+ID4NCj4gPiA+IE5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0aGlzIHBvaW50IGFib3V0
IG1hbmlwdWxhdGluZyBkb21haW5zLg0KPiA+ID4gQUZBSUssIFNWQSBpcyBub3QgdGhhdCBjb21t
b24sIGluY2x1ZGluZyBtb2JpbGUgc3BhY2VzIGJ1dCBJIGNhbiBiZQ0KPiB3cm9uZywNCj4gPiA+
IHRoYXTigJlzIHdoeSBpdOKAmXMgbm90IGEgcHJpb3JpdHkgaGVyZS4NCj4gPg0KPiA+IE5lc3Rl
ZCB0cmFuc2xhdGlvbiBpcyByZXF1aXJlZCBiZXlvbmQgU1ZBLiBBIHNjZW5hcmlvIHdoaWNoIHJl
cXVpcmVzDQo+ID4gYSB2SU9NTVUgYW5kIG11bHRpcGxlIGRldmljZSBkb21haW5zIHdpdGhpbiB0
aGUgZ3Vlc3Qgd291bGQgbGlrZSB0bw0KPiA+IGVtYnJhY2UgbmVzdGluZy4gRXNwZWNpYWxseSBm
b3IgQVJNIHZTTU1VIG5lc3RpbmcgaXMgYSBtdXN0Lg0KPiANCj4gUmlnaHQsIGlmIHlvdSBuZWVk
IGFuIGlvbW11IGRvbWFpbiBpbiB0aGUgZ3Vlc3QgdGhlcmUgYXJlIG9ubHkgdGhyZWUNCj4gbWFp
bnN0cmVhbSB3YXlzIHRvIGdldCB0aGlzIGluIExpbnV4Og0KPiAgMSkgVXNlIHRoZSBETUEgQVBJ
IGFuZCBoYXZlIHRoZSBpb21tdSBncm91cCBiZSB0cmFuc2xhdGluZy4gVGhpcyBpcw0KPiAgICAg
b3B0aW9uYWwgaW4gdGhhdCB0aGUgRE1BIEFQSSB1c3VhbGx5IHN1cHBvcnRzIGlkZW50aXR5IGFz
IGFuIG9wdGlvbi4NCj4gIDIpIEEgZHJpdmVyIGRpcmVjdGx5IGNhbGxzIGlvbW11X3BhZ2luZ19k
b21haW5fYWxsb2MoKSBhbmQgbWFudWFsbHkNCj4gICAgIGF0dGFjaGVzIGl0IHRvIHNvbWUgZGV2
aWNlLCBhbmQgZG9lcyBub3QgdXNlIHRoZSBETUEgQVBJLiBNeSBsaXN0DQo+ICAgICBhYm92ZSBv
ZiBhdGgxeC9ldGMgYXJlIGV4YW1wbGVzIGRvaW5nIHRoaXMNCj4gIDMpIFVzZSBWRklPDQo+IA0K
PiBNeSByZW1hcmsgdG8gTW9zdGFmYSBpcyB0byBiZSBzcGVjaWZpYywgd2hpY2ggb2YgdGhlIGFi
b3ZlIGRvIHlvdSB3YW50DQo+IHRvIGRvIGluIHlvdXIgbW9iaWxlIGd1ZXN0IChhbmQgd2hhdCBk
cml2ZXIgZXhhY3RseSBpZiAjMikgYW5kIHdoeS4NCj4gDQo+IFRoaXMgd2lsbCBoZWxwIGluZm9y
bSB3aGF0IHRoZSBwZXJmb3JtYW5jZSBwcm9maWxlIGxvb2tzIGxpa2UgYW5kDQo+IGd1aWRlIGlm
IG5lc3RpbmcvcGFyYSB2aXJ0IGlzIGFwcHJvcHJpYXRlLg0KDQpZZWFoIHRoYXQgcGFydCB3b3Vs
ZCBiZSBjcml0aWNhbCB0byBoZWxwIGRlY2lkZSB3aGljaCByb3V0ZSB0byBwdXJzdWUNCmZpcnN0
LiBFdmVuIHdoZW4gYWxsIG9wdGlvbnMgbWlnaHQgYmUgcmVxdWlyZWQgaW4gdGhlIGVuZCB3aGVu
IHBLVk0NCmlzIHNjYWxlZCB0byBtb3JlIHNjZW5hcmlvcywgYXMgeW91IG1lbnRpb25lZCBpbiBh
bm90aGVyIG1haWwsIGEgc3RhZ2luZw0KYXBwcm9hY2ggd291bGQgYmUgbXVjaCBwcmVmZXJyYWJs
ZSB0byBldm9sdmUuDQoNClRoZSBwcm9zL2NvbnMgYmV0d2VlbiBuZXN0aW5nL3BhcmEgdmlydCBp
cyBjbGVhciAtIG1vcmUgc3RhdGljIHRoZSANCm1hcHBpbmcgaXMsIG1vcmUgZ2FpbiBmcm9tIHRo
ZSBwYXJhIGFwcHJvYWNoIGR1ZSB0byBsZXNzIHBhZ2luZyANCndhbGtpbmcgYW5kIHNtYWxsZXIg
dGxiIGZvb3RwcmludCwgd2hpbGUgdmljZSB2ZXJzYSBuZXN0aW5nIHBlcmZvcm1zDQptdWNoIGJl
dHRlciBieSBhdm9pZGluZyBmcmVxdWVudCBwYXJhIGNhbGxzIG9uIHBhZ2UgdGFibGUgbWdtdC4g
8J+Yig0KDQo+IA0KPiA+IEJ1dCBJJ20gbm90IHN1cmUgdGhhdCBJIGdvdCBKYXNvbidzIHBvaW50
IGFib3V0ICIgdGhlcmUgaXMgbm8gd2F5IHRvIGdldA0KPiA+IFNWQSBzdXBwb3J0IHdpdGggcGFy
YS12aXJ0dWFsaXphdGlvbi4iIHZpcnRpby1pb21tdSBpcyBhIHBhcmEtdmlydHVhbGl6ZWQNCj4g
PiBtb2RlbCBhbmQgU1ZBIHN1cHBvcnQgaXMgaW4gaXRzIHBsYW4uIFRoZSBtYWluIHJlcXVpcmVt
ZW50IGlzIHRvIHBhc3MNCj4gPiB0aGUgYmFzZSBwb2ludGVyIG9mIHRoZSBndWVzdCBDUFUgcGFn
ZSB0YWJsZSB0byBiYWNrZW5kIGFuZCBQUkkgZmF1bHRzLw0KPiA+IHJlc3BvbnNlcyBiYWNrIGZv
cnRoLg0KPiANCj4gVGhhdCdzIG5lc3RpbmcsIHlvdSBoYXZlIGEgZnVsbCBwYWdlIHRhYmxlIHVu
ZGVyIHRoZSBjb250cm9sIG9mIHRoZQ0KPiBndWVzdCwgYW5kIHRoZSBndWVzdCBuZWVkcyB0byBo
YXZlIGEgbGV2ZWwgb2YgSFctc3BlY2lmaWMNCj4ga25vd2xlZGdlLiBJdCBpcyBqdXN0IGFuIGFs
dGVybmF0aXZlIHRvIHVzaW5nIHRoZSBuYXRpdmUgbmVzdGluZw0KPiB2SU9NTVUuDQo+IA0KPiBX
aGF0IEkgbWVhbiBieSAicGFyYS12aXJ0dWFsaXphdGlvbiIgaXMgdGhlIGd1ZXN0IGRvZXMgbWFw
L3VubWFwIGNhbGxzDQo+IHRvIHRoZSBoeXBlcnZpc29yIGFuZCBoYXMgbm8gcGFnZSB0YmFsZS4N
Cj4gDQoNClllcywgdGhhdCBzaG91bGQgbmV2ZXIgaGFwcGVuIGZvciBTVkEuDQo=
