Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D33D230274;
	Tue, 18 Feb 2025 09:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739872391; cv=fail; b=A5TECKXE05p3c7CDHxUW6oWkk2V5td8osVcp2Lyf2l7bKHQY9AE3deBTxLJFVppOc2sasChWhh6PkfkIWsfeTDQ5Q/GgXKBPgNsH9h2Jj7Ay8ouRZ49bjGNC6heKdvl/va2yy/o+eRpJkcpss/wkcsVIBIIAQgefgFbSprvvFS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739872391; c=relaxed/simple;
	bh=GV+td4JjY3sY9QgF0vQWkKAOgL9OK+oC8lQU+bFftVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qy9g6DvD2BCiwGbnv+AnNdY1q5tKXMnyzYV4WsLVPaP5BLkqc1MhrpkP7ycifg4T3kO5FwucQxtMV5nX17VItkUyDEmAhe4jYwoNkT0emgYFtDsFvm10msF2z234nnS2zzN4cn/92ty0JeE9+W37/FW/F1RNpkTOmF8hqYy1NRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKsESpzv; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKsESpzv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739872390; x=1771408390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GV+td4JjY3sY9QgF0vQWkKAOgL9OK+oC8lQU+bFftVI=;
  b=kKsESpzvSjWT5As7aiE7YcdJ6Hwk04a/KBmL4SS6fzwxDs6MDtSQ4Yf4
   Z0gb81uQblPfePzoDiqgSiEOR7cmaQ5nd/ZRlGKZwxBH6n1947mprI6uz
   Y4LP0wZUU5P/jOVxltmbZXz4xWwxmUIPjenBYnG7WyRQeszdqb9z88ygu
   ECofDLcS4o7UAaos6nP+G3deql4LNR2gLYZGSG+4KadsEIhjISftX8TIG
   q5/qXaMEIGyeX7o1O2j96u/LRgzPppwQ7XlvXp1XE5Pn1rHSDTUp7gkSy
   mOWHmgDlij9+VfHXhthaWXj1FYQBHiVH6RcL0YFB7DGoJ1NimpvqlyCHS
   Q==;
X-CSE-ConnectionGUID: stsV49+gSfSsBtAMwy3IgQ==
X-CSE-MsgGUID: XiYbiSsDRkGLpjsG7cDmPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40582309"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="40582309"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:53:08 -0800
X-CSE-ConnectionGUID: cgh/AItgQ/ejkJdvSMZKIQ==
X-CSE-MsgGUID: ysdp42tMQsqZFsIZMujZ+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114816145"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:53:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Feb 2025 01:53:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 01:53:07 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 01:53:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzzhDfcud401u1ZfLcAfzucFDXvQKHFB4YoicREKMw3xG/c/vG4vFvKtxP6X041kdT9c0XCnoNy6LhhWO8B12zYOYFyvlE3C4H7KYG7y7LEf7z7WRHCSljbw62oAqbVF/Hvd3maDEcygKf6XLExHjE4Z0ldUqze0UJX+M1pgNPjUmrz55nRRQ6ddegyO/LLaJi1R2GwjXUxQdocmaHXECJNVOd5sKDj8bbuQ0X7ispRS+Ui/M0lRHgEPH+QohMsc9R7Z2XQ0aaUqT/v/ArVvdjAvSg/4DJ83Op9NiKs+T/XGDo1TisgeVVQkcoLxOkxotLyLsMn6fg8f+yzESa68ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GV+td4JjY3sY9QgF0vQWkKAOgL9OK+oC8lQU+bFftVI=;
 b=H9yt3UehRAHXFIURSdrJzwQFmxRyUtQ+kGMfksqwbKPzcgNDngrnlK47AZCOZu1e/Vxsi0hGgaA/hzjRqY9FjLCMBnpitws1dNg73EvzulcfE6rO5YHCy6jcA4VUCvWdRbBsBaA98LsobdyIvS6Imy4pzf45LjfTYzgoQboIgDzWbmVEHSxrxNVa3CSQyoc6R5h/iJkbAUoDXlXX+xusg/TrCGJOOBqpH/fu2pnvVwjJUGSJ4NyL/XyzFyhDqcqNdF4OWFQS9AEj5WLYwyIajxSEOH/5y9hcWjU9d1W0hM1cjs0FmNcznfEdNFa0YM6l0Um+xIH1BIvlrxcGV71BwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM4PR11MB7760.namprd11.prod.outlook.com (2603:10b6:8:100::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.20; Tue, 18 Feb
 2025 09:52:36 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%4]) with mapi id 15.20.8466.013; Tue, 18 Feb 2025
 09:52:35 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Mostafa Saleh <smostafa@google.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "iommu@lists.linux.dev"
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
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAxQMeCACaTxAIABW9IggAmzHoCAHz9pUA==
Date: Tue, 18 Feb 2025 09:52:35 +0000
Message-ID: <BL1PR11MB52712D24A6FBA940B3F867AB8CFA2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca> <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca> <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DWag7ZKCPl1Eje@google.com>
 <BN9PR11MB5276B783D518DB354BF58A3C8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5odLXPZPAwu4oqe@google.com>
In-Reply-To: <Z5odLXPZPAwu4oqe@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DM4PR11MB7760:EE_
x-ms-office365-filtering-correlation-id: 807e84c8-e426-4d82-6e51-08dd5001f8db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b3JFdUFNakorRTQzTml5bm41M1pVTXF4UnRURFlsNHFWY0lVZVVWUjBxRVYv?=
 =?utf-8?B?ZDBnODBIOFhUbVhIZkh1bzZYV2tzWktNQUhZNjFYOFJqMFpOQ2x6MEFLanEv?=
 =?utf-8?B?dE91YzNYYVhIdmdmR3ZLZlBZbG5BMFhIWEZON1FPZWZoVDZzZmpSaDFVU2hO?=
 =?utf-8?B?RTBqT1NTTXV1Q0FCS0JoaGxzS0JuZDE3NmxaTnNWSlVtWFljQkFPaWdKY1g1?=
 =?utf-8?B?dVVwRzlWZDJpcDlCNFhDdHZsZmVQQzBkb1VXNGYxZWM2T05IblUxaXlyRWJG?=
 =?utf-8?B?SkkrSEVkUWh1NC9VMXNVZnVsMnJHcmtXQUFVajVwa1ZENTY1TDV1UGRBRUhJ?=
 =?utf-8?B?N1hxVEFST2IrZTUrNnZvSUI1Vk9qejE0UjZQRHgrZkNWU0xja05QSTl5eXIy?=
 =?utf-8?B?RVdSUUFjcnk2b2ErWXltRkl1NENMRW9BTE1BclMxckJXcDhVL0xlUHdTb1M2?=
 =?utf-8?B?TFdSRVdFL2pkOHNUNlFZSmVid3Y0aVJEQ0pYb2xEb2kwOUNhRVpIaG14R29N?=
 =?utf-8?B?VnlKUURubk5IUkpIYmFiSk5Oc0k3S0VYVktpa3NqR0ZJRHJkY3ROVllENjlQ?=
 =?utf-8?B?UG5aa2dGWmE5bHpSTTY1bklmYjZWS1pQbXpuTDYvWjR4ZFEyby9FaXVnazJS?=
 =?utf-8?B?eGZRZHU0NkdJRXBLVytHNnZrWnVNNk5sYW05NHZOSy9LWlgxMDhKclprMlkz?=
 =?utf-8?B?akphaUJFRmd4NEVhNzFwY0FOcWhVYnE5MDRrL21BSTgzOFVDQWpwVFQ4TjNk?=
 =?utf-8?B?cHdFUFdOZ3ppYXpIdEphOTNxMjJRcC9pdUtSYml2KzVqZzVtbDcyaTNCcVBW?=
 =?utf-8?B?VWFQYkUzZlZuS0xVckxCdzBPcUV1MDh6MGlDTi9wdy9iRzdvTFRtaVN0OGFV?=
 =?utf-8?B?ZURQVEdMU3YvNEU4ZTB4NHpZWVYwZ1lzQXI1ZFFWMmlJTE5oNTNGeFFJQnlB?=
 =?utf-8?B?UktnekRoOC9FZjc3U0Qwb0kzRTNudjFnc0dydW42Yk1zbmRqRDhpcE13N0Ir?=
 =?utf-8?B?dHp1NHVQOXoxWUI1MEk5K2QvNjgwNEE3eHM1dm5xNFZUQmd0TlVZYXVFeXRk?=
 =?utf-8?B?b0YrVUpyMW5Ra3pRWmQxTzROSHpiS1RPdWIwQytaaEpSZ3ZobThVbThqN1hh?=
 =?utf-8?B?YXVqRUhBQ1ErR2FDL3ZuY2pyR1RlMFdaK1p5dHhEaWhjeUJ1MXZHY3FNNld1?=
 =?utf-8?B?RlEyRmw1V2YwUFVTaW9DTERsQVJOdmJNbU02eEhKRDF4L3FTc2VpSjRTUXUy?=
 =?utf-8?B?Z3FhVWRablR5cTI4cnhwYmozTWdoUHJrU0FaRDVuU2RkaENwc2hEUmFkZ1U2?=
 =?utf-8?B?OC9QOWJLU3VmckxUUk01a0kwUGNTc2thTlluUjhYVmRWSnFrVUx2RnpKMEhw?=
 =?utf-8?B?VGhtUnMybFN4L041SnhES2tla2dVVi9wVjJwNHRMZFJlQ1l5Nm9sWGYxSmhl?=
 =?utf-8?B?YjJ1T0xpYWFtWjM0MnJjYVhRZ1pxY2Rza21zV0VPUVJxSXEwcndnWHcxVHlt?=
 =?utf-8?B?bHF5U3F5U0IrUnlBeStnMEN3OThGR0tiK0ZKbHppMW0yU3ZxTDJJV0t3a0lx?=
 =?utf-8?B?STBtdldUWG82SEozZ09XVXhmd0oyUGVNd1pBRlRiTGtDQTEyVEtxQlkrSzE5?=
 =?utf-8?B?MzFVOW5yRjBWSnAzekZoQ2l4Vm8vUTFTU2JxTGpqb2pZQ0ZCeit6WGxlZ3Q4?=
 =?utf-8?B?SVBWMDVDYW1ycTd2cGN3QkxFWVFkSmdGNS9uc0g3dUQ4V3RnUDIvcjVYQ0E0?=
 =?utf-8?B?MkNESGtjMDBaeUdyc3Y4aGFsZ0pQNVpMWC9OKzEvaisyQ1R1MmJIVDYwTFZw?=
 =?utf-8?B?QjBOQ3JYVnp3bHp6VTB4d0Z6UGYyUlhyT0FIdUo1Z2t4N0VIMDcyTUhDdnNG?=
 =?utf-8?B?bDlyaVBLVDBVQmc2TFIvWllhUkkrV3Y4S21qTXhjVVZMbzI1S0E0ZnRQWm5v?=
 =?utf-8?Q?4kUXN5bvVHxFH4susJtAHBJVjZv4OrWz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3NXOUprTEVFaEZWWXFOS0l1K00vM2Mzelh4Y1R2TWRRM1ozcjZTeU9uZWJu?=
 =?utf-8?B?eFBtMFMwOXhCMW5UeWxHb3A2T3RTdTJkTjlFZW9sOHhjTkU0MkVUVE00YXBF?=
 =?utf-8?B?aGlBTktuOGZ4S2xKRzBaSG45MEJaOWVCamZDQXlJeGcxRE5VVjV4dXhZd1Fh?=
 =?utf-8?B?dW5JQUFmazFnWmV6cWk3cXFpWlJaTUR1V3VDVi9MdHhSdzdTQllJUkc1WDlt?=
 =?utf-8?B?RW5VR05EZHRORzQ4QzdicjV1SXdwZlZGaVZab1kvUTFUMTcrMG1kR2thbWRo?=
 =?utf-8?B?T1EwcTVoL3pJaklVZFNyM2VIRlkva2ZRTG1YQWNtRFhpY0V3dzJTdEpoNG1R?=
 =?utf-8?B?SklJQXVVc2NSc05kNG1kTTJrMkwwM0kxNXRXSDRIVm1lTXUrSE5MaHJpTU9M?=
 =?utf-8?B?YVhaSU5UK0hVeTROaFhVOUV2ci80M0FvWUtrOTAvUG9ZNDlIejFZS2k2MW5Z?=
 =?utf-8?B?MTRuT1dEU2NIU0l6Zi9LNCtZdFJiTWtwaTRya1NtQUxVWkhkaXhyWUJkSlRl?=
 =?utf-8?B?anJIU0t6c3VvTEh5b3gvMlc2OVJER0pJTkZEaUkyZUpDLzZsc013cStHN3lq?=
 =?utf-8?B?aEd5d1lDdFkzdWxGMC9LbjM1N0VUUENoQWxHS01VeEhOYmQ2Vm9OWk1Takgw?=
 =?utf-8?B?ZVNHL3cvMlBidzZWdWExMmptZWtGUW0zRlZwQmVnUE5vdDBJb3ZoMmV1cUZI?=
 =?utf-8?B?NFQ3b1ZoSHZpZ0U1M1F6SmtaL0xXcXVwRUJrbXQyeVF1NTV6ZTVPeXZNNXh4?=
 =?utf-8?B?QjRBMDNWV3VOWUU3SXhlTWZKME5QdC81M1dpclVRbnN5Qmt5S2RZemUycDZp?=
 =?utf-8?B?NEgyVUZSMElqa2JOZ0RwUmR0K0k4N2tHUU1pM05Nd0lNWVlCSTkrQmJmaE5x?=
 =?utf-8?B?QlU5cDh3MDYwdUNIMHBtSnpnd1BFKzhVZW1KR0t6VXRKZGdlQXJWSnBUZ0h4?=
 =?utf-8?B?SkExR2U4RURuci9DMEk3NGpBLzAyOEsvbTdBdithKzhsQ0d2VzJ1Ny84c1FB?=
 =?utf-8?B?WVJIbVlQSVIwQjc1V1pjTVVDWUNYTXNET3BrUU9MLzFaL1l6aUlZOEtmOGxI?=
 =?utf-8?B?akZXM1FtdmtjaUk0TFhOWWFxQ0JLVVcyL3psbndoRm10TW43RVNHanp0MW52?=
 =?utf-8?B?cWFRL0x1OHlkRElaQnVPNzh2dGZMU21EZEloK0VHcGJ3MEorM21IYklOakpH?=
 =?utf-8?B?L0ozTncrbE5JdGlianllR2RhZ1l0bjNXRWp4d0d1MmF5M0VXUzhlKzhHZklV?=
 =?utf-8?B?N3ppb3hTSzZqT3QzYVVLMnJVTGVwbmNZbncyTGpoanRJdWhBQ0pyM0xVdTZT?=
 =?utf-8?B?bjl4cHZheWZiWnRkR0g5M2dKaHltRmhmMjdwOERKcnFpWW80OTNnL3lUVktB?=
 =?utf-8?B?R01yMFd4TWxVaW90SkwyYlpUbEtHa21nQkJuR0U0WnVEWVk1RXBCV3ZQendH?=
 =?utf-8?B?eDBOYUtIR0Y5TFFhNVlJYm00QjEzRUhINUVyT1BzM0lpZmJ4bmxQUTBtRk85?=
 =?utf-8?B?RDhLemlpYTVXTmV3VGZTZmRxMlhnZjljazBkUTQyTTdwcUo0c2Vmd2dzL09E?=
 =?utf-8?B?VkRMc1hIZFJQUVFXOXcwb291eTE4MHJiTmFMamFQTy9ESzZvcmo5SGVWWVQw?=
 =?utf-8?B?V1A3QTdIZ3grb2RnYXQrMjJHMVFqQWFwYjFWVWJDSXJaVVNZWlhpRXVTZHNw?=
 =?utf-8?B?Mzlrb1NoTWxZcjZlbHFZb2tEODgvK1FGY2g1N2UrL2V1b051TjdkUjQ5TjNz?=
 =?utf-8?B?cFEzdVB3QmJreDl4VWlyalRaNWdYRmU2Nml2cFhad2svS0VoNWZnS0dvVW0x?=
 =?utf-8?B?L28vR0NXNnk5YmxrSXNuQ2JSWEJRYXE4TXJHandVa3l4U2NERDNhY1VmNGtt?=
 =?utf-8?B?R201SlJ3c0JvTHEveU0weUJzc1VUQnR2ZWV5ZkhuQXBFQzdaQWlJaXoxb3Fu?=
 =?utf-8?B?WGl3NzdHdDBmcVlBTVMvMW1HZzhyWTAxbGY3b1BkWTEybDBYcFFvNDRsOTk1?=
 =?utf-8?B?UkpBTzFiWmhBUVllY1JWM09CdEdTQW1jRWMwaCszbnA3NjZhR0o1VW9OZXcx?=
 =?utf-8?B?RkI1VXUrZlhhdUZsUlU5elpEY0RtUXl6YkpDenEwN2NDOW1USDBpbnFqMzl6?=
 =?utf-8?Q?4D19Qw/xrnOJVkkW5IkGs499g?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 807e84c8-e426-4d82-6e51-08dd5001f8db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2025 09:52:35.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ge2CCRAXPa7bpTMrZTO35uu9AYEK4GF2uXdb8UHsatF+4kbxEDNOs4l/rQuYjgABIhFPat9NXj9TL+L42piBQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7760
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgMjksIDIwMjUgODoyMSBQTQ0KPiANCj4gT24gVGh1LCBKYW4gMjMsIDIw
MjUgYXQgMDg6MjU6MTNBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4NCj4gPiBUaGUg
bGVhcm5pbmcgaGVyZSB3b3VsZCBiZSBiZW5lZmljaWFsIHRvIHRoZSBkZXNpZ24gaW4gb3RoZXIg
cEtWTQ0KPiA+IGNvbXBvbmVudHMsIGUuZy4gd2hlbiBwb3J0aW5nIHBLVk0gdG8geDg2LiBDdXJy
ZW50bHkgS1ZNIHg4NiBpcw0KPiA+IG1vbm90aGV0aWMuIE1haW50YWluaW5nIHBLVk0gdW5kZXIg
S1ZNL3g4NiB3b3VsZCBiZSBhIG11Y2gNCj4gPiBiaWdnZXIgY2hhbGxlbmdlIHRoYW4gZG9pbmcg
aXQgdW5kZXIgS1ZNL2FybS4gVGhlcmUgd2lsbCBhbHNvIGJlDQo+ID4gcXVlc3Rpb24gYWJvdXQg
d2hhdCBjYW4gYmUgc2hhcmVkIGFuZCBob3cgdG8gYmV0dGVyIG1haW50YWluDQo+ID4gdGhlIHBL
Vk0gc3BlY2lmaWMgbG9naWMgaW4gS1ZNL3g4Ni4NCj4gPg0KPiA+IE92ZXJhbGwgbXkgZ3V0LWZl
ZWxpbmcgaXMgdGhhdCB0aGUgcEtWTSBzcGVjaWZpYyBjb2RlIG11c3QgYmUgc21hbGwNCj4gPiBl
bm91Z2ggb3RoZXJ3aXNlIG1haW50YWluaW5nIGEgcnVuLXRpbWUgaXJyZWxldmFudCBwcm9qZWN0
IGluIHRoZQ0KPiA+IGtlcm5lbCByZXBvIHdvdWxkIGJlIHF1ZXN0aW9uYWJsZS4g8J+Yig0KPiA+
DQo+IA0KPiBJIGFtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCwgYnV0IEkgZG9u4oCZdCBzZWUgaG93
IHBLVk0gaXMgaXJyZWxldmFudCwNCj4gaXTigJlzIGEgbW9kZSBpbiBLVk0gKGp1c3QgbGlrZSwg
bnZoZS9odmhlIHdoZXJlIHRoZXkgcnVuIGluIDIgZXhjZXB0aW9uDQo+IGxldmVscykgYW5kIGNh
buKAmXQgYmUgc2VwYXJhdGVkIGZyb20gdGhlIGtlcm5lbCBhcyB0aGF0IGRlZmVhdHMgdGhlDQo+
IHBvaW50IG9mIEtWTSwgdGhhdCBtZWFucyB0aGF0IGFsbCBoeXBlcmNhbGxzIGhhdmUgdG8gYmUg
c3RhYmxlIEFCSSwNCj4gc2FtZSBmb3IgdGhlIHNoYXJlZCBkYXRhLCBzaGFyZWQgc3RydWN0cywg
dHlwZXMuLi4NCj4gDQoNClllcyBwS1ZNIGRvZXNuJ3QgZmF2b3Igc3RhYmxlIEFCSS4gTXkgcG9p
bnQgd2FzIG1vcmUgb24gdGhlIHBhcnQNCnRoYXQgbnZoZSBpcyBhIGhhcmR3YXJlIGxpbWl0YXRp
b24gc28ga3ZtLWFybSBhbHJlYWR5IGNvcGVkIHdpdGggaXQNCmZyb20gZGF5IG9uZSB0aGVuIGFk
ZGluZyB0aGUgY29uY2VwdCBvZiBwS1ZNIGF0b3Agd2FzIHJlbGF0aXZlbHkNCmVhc3ksIGJ1dCBj
aGFuZ2luZyBvdGhlciBzdWJzeXN0ZW1zIHRvIHN1cHBvcnQgdGhpcyBzcGxpdCBtb2RlbA0KanVz
dCBmb3IgcEtWTSBhZGRzIG1vcmUgbWFpbnRlbmFuY2UgYnVyZGVuLiBUaGVuIHRoZSBtYWludGFp
bmVycw0KbWF5IGNoYWxsZW5nZSB0aGUgdmFsdWUgb2Ygc3VwcG9ydGluZyBwS1ZNIGlmIHRoZSBz
aXplIG9mIG1haW50YWluaW5nDQp0aGUgc3BsaXQgbW9kZWwgYmVjb21lcyB0b28gbGFyZ2UuLi4g
QW55d2F5IHdlIHdpbGwgc2VlIGhvdyBpdA0KdHVybnMgb3V0IHdpdGggbW9yZSBkaXNjdXNzaW9u
cyBvbiB5b3VyIG5leHQgdmVyc2lvbi4NCg==
