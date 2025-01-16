Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17E199FC1;
	Thu, 16 Jan 2025 06:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737009577; cv=fail; b=aRC+dKAFZP7hrvU1pYBXcDqw88aAcGNFUn/UBscl/oqGAhx292R7FNMgk4j8dSb5cdWPafqPSk4IU9dy2nDEllO06ARoiH0GQXGHDc31cAgvYN5yNZustYXwxVdmAoVDLlPI2aI4vNPxNUP25IoRpyMpivKjuSAlYz8FKrlmul8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737009577; c=relaxed/simple;
	bh=iET/cqMTwv68Mi0hNv9T/zhpQsXjcZXbQ1XkgROW3uo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KDuaE2QTx00yrW5i+f+0JNJtN24dRNNPPzO1f4C7Oz8g7kcof4q0o9VxIA2CxETsmlJyCvQrRnUTIbiK+il0ppeM268Cq8ImRemsKKBPeYGlUeugCu5b+6WJmTl95SNLXJtPobYgIvXVIefQJgzyGVibcNejKfwUB2xopMl1vK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrleCrca; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrleCrca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737009575; x=1768545575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iET/cqMTwv68Mi0hNv9T/zhpQsXjcZXbQ1XkgROW3uo=;
  b=FrleCrca2l1eOiy8LHzagA4p9Ia+ZLyXsELJQtgAaxzlnS7+SnZbNOmH
   IfeIab8CsE5HRluj9t2TG+WIBDHqt3I94MIFoMH60o0YS+zH6cRcE6DYg
   rBtJ7LfT0VdnRV75EJl/9pBctVDv5SfNnaK7MICHBooWmVJqOzZ+nCqov
   tD3/U7UPJdXYW0fGbtN3jPENui6OB55zU9v6CUzbzjDxPNhhjVqxTZjoL
   7pvCc1lkVXpaS/h/TrrfPfPXIOpjJ4oSVRrxnswrAHn0U+OtM4mTRPJd7
   rE1qg4LHH6L/emVavyPjdugoQwMZng3h7GqR1GPFTViStrCCYl8I1ewU8
   Q==;
X-CSE-ConnectionGUID: d/xUPc6DRy+yGlJ9uwnZ/w==
X-CSE-MsgGUID: NVWPPXP5TyScdeVh61+hkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41315759"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="41315759"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:39:35 -0800
X-CSE-ConnectionGUID: Upx3WsYOTlCnoZGpeKWsfw==
X-CSE-MsgGUID: 37Sb7fA3TxqI8Ox3L0L9KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105845342"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 22:39:35 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 22:39:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 22:39:34 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 22:39:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T98X4HUbrErWShkUaNRsE2MVDvLLUEj3IzWpfuEKwXLAt2a4J6kvk0wdv5Bo4qK4NDFDYSK9y90BTlUzE9hlTygjEhlg/J9NdFwxOX9OPrN+w88Yz2JSG4uYQKqLiR22LodVRwZvxFzs+zSUkpwleOVcyBygYfbgCXXHIVgEKX4+DEmAYTLr5j8ER4jAAZsRUuCHPTfmg3rLfmCkz7H9ImX/rUns1V+giaUbnzL3LmdEZIZimdjK89lZwlJsQ1BXTDlQ2N08ayae/AExVD4dZfmS0ki+zBXJ+68DN51abnocMVUB3uM8382ribT4imTYXbPIhmme2PzT7blAhPbfRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iET/cqMTwv68Mi0hNv9T/zhpQsXjcZXbQ1XkgROW3uo=;
 b=oCS+ATASa5gT1maQbCiIf/p2vF6jPoluDpnpzOdZ7Zerc+VBKzMmUwczWHw2KpNfv8NpE1aIR6AcCHifK0jRrRCs9heUWpxXOFUEUGSjrnTDaPHiridW3wTbDR3GWNOlVR9Ou/eMSVGu6JjpqmYQjDjbnt0qJnpmVOZ28k5AGDxHCtPeZm1+OjwGNNfD5xYIBh8wPWc+ZuwWOLPQePETSXLoWCbo39AgFqhO1K3xmJvI5pMcn1TxG/O4WmCwNZRq1x5aSKhLMRjS8UJghzWj8FxU/C4lmD6ryCjIkjQO9P5mdwh2ZKnzAON4Khnlct//U9RN9IjNUBq8/K+VqzaJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6243.namprd11.prod.outlook.com (2603:10b6:208:3e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 06:39:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 06:39:31 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
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
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAwvyuA=
Date: Thu, 16 Jan 2025 06:39:31 +0000
Message-ID: <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca> <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca> <Z35rEeSVwfZVA9IF@google.com>
In-Reply-To: <Z35rEeSVwfZVA9IF@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6243:EE_
x-ms-office365-filtering-correlation-id: 7e0113c7-9882-4fa3-d6e9-08dd35f888a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bWxEMzh3K3BKcklML3FvbU9nRDlCV1FHRjByS1BQV0k3eWRCTkdUNE50YzdG?=
 =?utf-8?B?T2swcENvaTVqSFZTQjhhT1FxMHVUT1ArbHo5UGNuRHNVSHFwWFZVZVdSQTA5?=
 =?utf-8?B?emJuMmhabFlnM2REajBsejl2Unpnb1pxVjFOeVVZL3RUQi9kVDB2NS95Tnpy?=
 =?utf-8?B?UHREV2NkK05zWkZrSzVDR3dtRjNGcWluMDJmZzJ4cHZtcDZkZDdKZE9vQW5i?=
 =?utf-8?B?RE9scHNQVUJac3ZEZjZDZDlWbWhXMlY4Q0ZvSlFnNHZzVXBJbmlHWFZVL2JR?=
 =?utf-8?B?UWUxb3pybVFKQlZZRkVveklSNEJvcC8yWndlNEphR00vZEVOR2RRM1JpTXZ3?=
 =?utf-8?B?dGgvUTY4eHNmaVpjRzlkN05xMURZRmQyN2RtUWtqWXNTTVE5NWRMcm4xUW5X?=
 =?utf-8?B?d3NPRXRlNjhmU0FxNEVnekZBd0xSbnk1ZWx1RmJPRnVGNE9HOUdGSGFnVFVn?=
 =?utf-8?B?dkd6OVFIZGd2S0Q2RlY3MWdrbmpoRDljVnVYR2dkWFhDanZsanh1TFZSMTNW?=
 =?utf-8?B?RVo1bEY3U2dKYnhpNFV6VUNPT3hSOWEwUFZuY0NobWtZaWRFUmk3djNqNFl5?=
 =?utf-8?B?OHhxSkl6RjlERnNvOE9laGhGVDFJdE02eFltUitrb2dTTG0zMksyUWt5VnM2?=
 =?utf-8?B?YjAvL1FNMVAxVTlVaDdNYndLUXRYZVU1ZUdCWG5CNUhmanB5WHkvcFduMTA1?=
 =?utf-8?B?bDdMSENXdURIQ2FSTFVxUWwydUdrU1J0WU9BSzdSbnp4cTVIaE5LVFNwLytu?=
 =?utf-8?B?TXhJS0w0S0xxRXViOCt5R0lqMXd5a3d5ZmpzeWJUbGJsejJCdktaQkNKUDhu?=
 =?utf-8?B?aXd0c25KNnpzaEFCTzN5WW1UR0Z2Q0xVaVVBMHFLb2J4SEs4WDYxbVlJK1Fn?=
 =?utf-8?B?b3BpeFpnUnpYOVljekMrOVpHakJIT3RMUEpsR2h1Tk1CL3QwYldOOVRNOWNn?=
 =?utf-8?B?UFA1dTkzeE5IMktHbG1NVExweDFyZ292eTJEVVd3Wk5uTTZBNllBUU9FeDdj?=
 =?utf-8?B?cGRFVDQvdzBFUitZY1F5MmNaWXVtL0JwQnJ1dTl3WkVJMExWY1BPOE9VZEVR?=
 =?utf-8?B?QjVnNlJLajEyc243ejM5UUVPYTg2ejNaSFVtZjRpMC9UUVhjcUdJaDZmSjNl?=
 =?utf-8?B?WlRkbFFmbC9xYVpKK2pVVUhjRTVyeXFjaUJzZExSdVo4OXhGZUl3U1BIUzhq?=
 =?utf-8?B?OXpja1BYSmFxYzJ5S09IRC8vQ3h6RWdWV3lIeTFRL3IyM2hNalc4eG0vOVc1?=
 =?utf-8?B?UjhpWktXVFV2VGdXUS9WOTBmdWNLZmRYbUt3T2E5dzcxcncrK01yK254UUI1?=
 =?utf-8?B?TW9QemVNNlVEZVJDMWIwWjZ0OGtCOVUwQ0phTmdsK2ZSZ3VubFJYcUFwRldX?=
 =?utf-8?B?R3hva3IzbDJrN0VnSy9YVzl6RjVJa0xLSlNZQ1FKUldwMHdvTzg2Ym1WeFFs?=
 =?utf-8?B?TGN0THJSZy93dzZLazFPTTN0MGxYSWJPeFVGVkk0Y3lVMzFzYVdWQjhSMXFJ?=
 =?utf-8?B?bm1Xb3NsRE9vakV0SHpFWnZZQmhRc2FrNVBDaVVLZktwVHZxcExxdlZlaW1r?=
 =?utf-8?B?MFlIWEJLdW5pRUFxK3k5UVB1NHZCNHJrT2xSU1hNYnY2a2JwY2dOWjRueGpJ?=
 =?utf-8?B?eEZ6RGhuRWg3bWJvZWdQTW9JM1QrUWpiZXFVWElaMFVTeERPSXlWRVVOZW1Y?=
 =?utf-8?B?ZittTlBZUHVnZmlua3dOMTZ4aXVTcFpkN2pheXdwQ296MmtTUG9OSVZIc0NB?=
 =?utf-8?B?SVRlWldITkViNFFWUk5SWVVqbzZsYkxJRUwyajlWU25SV2ZTR2FvQW40TVN1?=
 =?utf-8?B?WXZ2WjFuUlNVQ3VEdlNvKzF2cUozYVZ3dDNzZFZEQnRVUVpHZmlVTzZlR3Ns?=
 =?utf-8?B?UW42WnAzdmxsMy9TRGFhY3BaUEJWeld3ZnREMWZrU2xqRTlVdFhoNThRN3Yr?=
 =?utf-8?Q?bDB43ypokVt1/lkd7ut1vsA3Aw7WX5xo?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWdsM3lLUW1QOG8zVUp4cXh2T1J4QlN3OWlPc2MwYWZZTm92N2JTK0MwWHJV?=
 =?utf-8?B?OGlkT2QvbWZLbWo0dzE5dzhkMUloM1ovdGkxNDJueUlJREV4cGRjOXlBR3RS?=
 =?utf-8?B?dDQrcGVHZmNoM0luSmEwcXMwNFBJc1dKS1FGT2M3SlZLSHdZOUlCZlpZekE1?=
 =?utf-8?B?Rjd2R2VnZm9DSS9sMmNHOTY5akxaT1ZDMVJpeit2eDlINFd0czJnVzVCME8w?=
 =?utf-8?B?S3VDcUl3UmlFbFdWOXNISWxKUjMzUG9VNTgxYTg5R0dmVmJOeitGSUk0UzJt?=
 =?utf-8?B?MXpEYWxJNFJmV0dtQ3o3RjZqYjdPS2xSVE41a29rUm5XNjlqVzJQZFBTOFNq?=
 =?utf-8?B?VlhaY0txaSt2RHdZaE1kN2g0dWlucWc5SkZXejVyK0RLTHFCWmFFd2FPQVFO?=
 =?utf-8?B?RUZHbDRiR2ZEMGtlYTRUUTErdzFpRlJBbExUaXR2UTZ5NjljbFZlL3Z0WUJQ?=
 =?utf-8?B?WXRWYXdTL3VRMDkvb1VKZW1XMWlZYTVBdFRjbkZVQlcyTzRvUmJQSjhsVUJ4?=
 =?utf-8?B?eVIyUk53RWt2R3djK0w5NG90VExRL2U5blQvQkFWT05oQkdydjBUdlJBL1Y0?=
 =?utf-8?B?WDVZQU1tUHFzL1YxQUg4bDk1SHBLcnZ6YVhJQjZhT2pGaEF0OWVIU3g0RmVX?=
 =?utf-8?B?Ty9GYWZKOG85eDdPdW1EbFRFWGw2K0xUcHg3K0xldnVGSGVLaXlBL2JVWE83?=
 =?utf-8?B?QUp6Tlp2b0dWbkVjenB0NUtIenlVeElzOFMrUWJ4ZHFEMmhaQVIzSkFkclBx?=
 =?utf-8?B?d2R1MWZESWI1TkxDYzJWQ1hXWVRBUXlCaGxtdEU2aWJKTnNQSXg1VUErVUN5?=
 =?utf-8?B?N1haT0JWV3Y5L1NscjB6bG83TWN3ODZ5d084VEVNa2FFS01DbjFMSDZnZUVs?=
 =?utf-8?B?TStPWFhPekg2MzEwa1I0cHo1ZmhoYW5IdW9FZEdTd0U1LzBCNzFHcWUwY3Nt?=
 =?utf-8?B?Q2E4TmdGdEdFZmVUWFBCZVg5djJrMUJOcnVMVEI1K3plUnd2TGdyNWpUcFFr?=
 =?utf-8?B?N2dXcFNSaWZ2ejFRVU5sRHhyUUdyUDBveGJlZjhVMVY2a0xRNTRqQVRTUjVk?=
 =?utf-8?B?ZlBVNXU3OSt3QmNEeWNGRGZONktTTkFHc0tzSHhiTXY0dnZ1UzFaaUdCKzNh?=
 =?utf-8?B?dy95T1FFVUdpOTJ3NjhvSFhRbmJHcTU3MWN5dVZzRzVRMEdZOU9QSyt1cU9O?=
 =?utf-8?B?cFc5WDBIUmhsblZGQ1dNWEpmRGNneUNURDJVdEFaRGJrVzc4bGRlcStJVlIv?=
 =?utf-8?B?VHh5VWliYjJMQklIb0hUUWIzVWFkVGJPMmVwM0NrNUN6bFZhaWJUOStINmU4?=
 =?utf-8?B?SkdOdGUrWHRGS3RpV3JpMEJkUmNpWlhjWVZrQVhOQzZmdUMwVDBDZVA4OHYz?=
 =?utf-8?B?WDdiZGNBMldTaHZTM1VBSTNoaE5zVjVUSWFDMFVzRjZCdGk2Q1c3NkpMb1FO?=
 =?utf-8?B?OXRjZFRjdGMwdFE4QWJBRWtZZzR2WkFJL3d1STVJUkVObU1HaGQ4OCtrdVlY?=
 =?utf-8?B?Q3FqVkNDQ2k0WmlWczZjK1lzcUwwQWNuaFVnTlVhTWdTUU9LanZUSE5pMHAr?=
 =?utf-8?B?aFJqL0Z0V1JrWWQyUmxtMGd3KzgzKzFLZ2FtckhLWEwzN21jSzZrV3Z1VGVi?=
 =?utf-8?B?STc5a1FydXYwY3dCOXFtUzF1ek5yRnR3RlhMNHFEYkV3ZTRZa2x2MFM1U3Vs?=
 =?utf-8?B?Rnd0TS83d2ZSOWlyTEVqRWdIcllIRlFnbUdQbVc3RWZPQVFCbXY1QnBjRFRa?=
 =?utf-8?B?alpFTmEzWHpDbjBtZEd6bTkvZ1ZXZzQ0MFcwZ1UwKzFranBhdkRHaWVpSkJt?=
 =?utf-8?B?Tyt4SFV6Z3pGYVJRVUtwRnlTdWNXcUh6bG5lazRRaC9Fc251Wmp4ZXU3R1po?=
 =?utf-8?B?UkxheTRrVmdub2pZQ3BjdUQwbGk4QTMyRGpWSDNOMjlpNlA1SUoxTXd1ckhL?=
 =?utf-8?B?UitKeFJXeDhydnVQdGF2ZWxsNUludnpxRUxHYTZ6c1pqOWIxTXBLcXFTSU9s?=
 =?utf-8?B?NVhXOGJwQ0dGVjViTG12ZExXYVhqTVFBMmd3c0Nad2FIWG9ydldsUGZpekRU?=
 =?utf-8?B?QTBNN3c2QW91amFWN1VwTDYyUkhqajdtWGZZa2d5U3FkVGVZMVRIRVlCZmRu?=
 =?utf-8?Q?qEiX6rVRDtnffhjyJof3nElx6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0113c7-9882-4fa3-d6e9-08dd35f888a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 06:39:31.6800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H8I6fz3SayCjgOxa8WYvpsplmjrTcsiC8pS00Vru6jlhGDQj+kPCsZSSHIE4vJBfKNjgU60VRgFkMGBDGLzfvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6243
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgOCwgMjAyNSA4OjEwIFBNDQo+IA0KPiBPbiBUaHUsIEphbiAwMiwgMjAy
NSBhdCAwNDoxNjoxNFBNIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4gT24gRnJp
LCBEZWMgMTMsIDIwMjQgYXQgMDc6Mzk6MDRQTSArMDAwMCwgTW9zdGFmYSBTYWxlaCB3cm90ZToN
Cj4gPiA+IFllYWgsIFNWQSBpcyB0cmlja3ksIEkgZ3Vlc3MgZm9yIHRoYXQgd2Ugd291bGQgaGF2
ZSB0byB1c2UgbmVzdGluZywNCj4gPiA+IGJ1dCB0YmgsIEkgZG9u4oCZdCB0aGluayBpdOKAmXMg
YSBkZWFsIGJyZWFrZXIgZm9yIG5vdy4NCj4gPg0KPiA+IEFnYWluLCBpdCBkZXBlbmRzIHdoYXQg
eW91ciBhY3R1YWwgdXNlIGNhc2UgZm9yIHRyYW5zbGF0aW9uIGlzIGluc2lkZQ0KPiA+IHRoZSBo
b3N0L2d1ZXN0IGVudmlyb25tZW50cy4gSXQgd291bGQgYmUgZ29vZCB0byBjbGVhcmx5IHNwZWxs
IHRoaXMgb3V0Li4NCj4gPiBUaGVyZSBhcmUgZmV3IGRyaXZlcnMgdGhhdCBkaXJlY3RseSBtYW5w
dWxhdGUgdGhlIGlvbW11X2RvbWFpbnMgb2YgYQ0KPiA+IGRldmljZS4gYSBmZXcgZ3B1cywgYXRo
MXggd2lyZWxlc3MsIHNvbWUgdGVncmEgc3R1ZmYsICJ2ZW51cyIuIFdoaWNoDQo+ID4gb2YgdGhv
c2UgYXJlIHlvdSB0YXJnZXR0aW5nPw0KPiA+DQo+IA0KPiBOb3Qgc3VyZSBJIHVuZGVyc3RhbmQg
dGhpcyBwb2ludCBhYm91dCBtYW5pcHVsYXRpbmcgZG9tYWlucy4NCj4gQUZBSUssIFNWQSBpcyBu
b3QgdGhhdCBjb21tb24sIGluY2x1ZGluZyBtb2JpbGUgc3BhY2VzIGJ1dCBJIGNhbiBiZSB3cm9u
ZywNCj4gdGhhdOKAmXMgd2h5IGl04oCZcyBub3QgYSBwcmlvcml0eSBoZXJlLg0KDQpOZXN0ZWQg
dHJhbnNsYXRpb24gaXMgcmVxdWlyZWQgYmV5b25kIFNWQS4gQSBzY2VuYXJpbyB3aGljaCByZXF1
aXJlcw0KYSB2SU9NTVUgYW5kIG11bHRpcGxlIGRldmljZSBkb21haW5zIHdpdGhpbiB0aGUgZ3Vl
c3Qgd291bGQgbGlrZSB0bw0KZW1icmFjZSBuZXN0aW5nLiBFc3BlY2lhbGx5IGZvciBBUk0gdlNN
TVUgbmVzdGluZyBpcyBhIG11c3QuDQoNCkJ1dCBJJ20gbm90IHN1cmUgdGhhdCBJIGdvdCBKYXNv
bidzIHBvaW50IGFib3V0ICIgdGhlcmUgaXMgbm8gd2F5IHRvIGdldA0KU1ZBIHN1cHBvcnQgd2l0
aCBwYXJhLXZpcnR1YWxpemF0aW9uLiIgdmlydGlvLWlvbW11IGlzIGEgcGFyYS12aXJ0dWFsaXpl
ZA0KbW9kZWwgYW5kIFNWQSBzdXBwb3J0IGlzIGluIGl0cyBwbGFuLiBUaGUgbWFpbiByZXF1aXJl
bWVudCBpcyB0byBwYXNzDQp0aGUgYmFzZSBwb2ludGVyIG9mIHRoZSBndWVzdCBDUFUgcGFnZSB0
YWJsZSB0byBiYWNrZW5kIGFuZCBQUkkgZmF1bHRzLw0KcmVzcG9uc2VzIGJhY2sgZm9ydGguDQo=
