Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8445B1EEE0;
	Thu, 23 Jan 2025 08:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620720; cv=fail; b=b0j3FlfTnQnDLF1A3CsKDNYPjOCQB9o9oY65iqq2ABrjTYcG2a/EvMzj4OZgQYWA48DRfGrraoLf4gXSyecYXbwSsWkYbnC1uYYPEM7kMKntssERMwH1YHkAtogFP6FXp0OjQgUydb0QrFqyP9nLby3NkNAKM9PSPOABPH324uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620720; c=relaxed/simple;
	bh=evEIQAetfr6DWCnqS0w82q7MC59aqxLFbQqFI6v0oLg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FI+3gFh+4lahnpREnDShUOGq2py9PrZz5TceAmCCt4tCa/SvYBKNWXCl4Bzzr/OMCV/eFRVrUNmjRErVo8PGJh0NygVJwbFu6afbz1nr1YRvLGwHgym2atSzSofQ8bJLEdL7Fw3/ZyTBx8g6VwLnti5nBhSm0xHgfDl8opNn3zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+0uxg8e; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+0uxg8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737620718; x=1769156718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=evEIQAetfr6DWCnqS0w82q7MC59aqxLFbQqFI6v0oLg=;
  b=i+0uxg8eHGGplzMQkThV5vAphxdmdG59QwKijwmHPXZd41NquauHCfnr
   xXJQO+B/nAdQOQu8llXtSfcDQPAjdKo5xprlHwLLb3taLFclZkQfv4fXC
   J35tyNL/tKCcPYNxqdSjKKtZuHmXkhRgM9fkSw2Eum+eUYXpT097EPU48
   azja5D4n0NORDmnv88489klDCUDDGTUApPCb9Zqwebqa11k28CIQluzGf
   EUUPjKF3zCavOz4G57DpKsgx0CQa4cw2409oH8E6kKk0TzNaN7+JbZ0dj
   mW6iPgewqtuTVbhcqCRUGkT3sVQOqe/Edfdo0JSlfU5Bc7PAaXOvhYNcd
   A==;
X-CSE-ConnectionGUID: 3TvG2hFbTMmblMhqwm7k2g==
X-CSE-MsgGUID: xVMuDyywQaeNVUMPZivzsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="38274048"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="38274048"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 00:25:16 -0800
X-CSE-ConnectionGUID: F6lfqMWvSceNU9G0Aauk7g==
X-CSE-MsgGUID: BCMajHlTTkW+5yIdIRcCxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="107995170"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 00:25:16 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 00:25:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 00:25:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 00:25:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTFVCVs71TdI3oePZb/ecZR3HR6OMXGGL15IRtBn4JnwZozkulbKYH+e9kmRnTq9oUoAHkc+aagH26WZLnZ7PYq81Yl6MR/XgDTWsWopuqolz6GKZmtUdopIxm4kHS7uLll/AyCfS2QRrCMhGQZFIvjNmVWq9Q2Nh0yLLWqXx6ipZ0OQcTC/LJiX3nY5s15kGZKMnUUlQbzUzSnsVOhDBrBFHiNw7RllbGE7JDYkmdy1ugJkxi1eEisJ0VZ53w0l+DNEmrLqSpG3CKK4lMZ9EXPuPHrHu+gCzE2cnRJxfl0W8O70tHkLBZJmHkWbUErjPTv9ZxWSrIzozDnYZfVUfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evEIQAetfr6DWCnqS0w82q7MC59aqxLFbQqFI6v0oLg=;
 b=xO3Bcd8y5MzxFhl+woZzqgljjQt2Nf467fYmM7ENLhRd7jqK8qhNNk20aoRcznHLLLWNqTGgSYBUUWBmGOiIWT+X7zM0s6eJya3n/kWVZX1GGXUdG+1778esxaJydVVszTCk71kMlFt1qhHe3xZNmTiND7YjUip54SAVVi5CZbnOgJFUsHwlXRef4zVGpDIsLej9dQ/wUGDmvRAZ2TrS854DAQ4M28SDKZJ/M1LUdx83rcpnn1XMBTbhZ2kINQ5t8SV2Cx8QFkuEdJHguh8aK+UytHZbX0pCu81r4OhzUYcDc0Jq73c0c7T33FbijYZ9CQUuugm2mAxmbe//IxjDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6264.namprd11.prod.outlook.com (2603:10b6:8:a5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.16; Thu, 23 Jan 2025 08:25:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Thu, 23 Jan 2025
 08:25:13 +0000
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
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAxQMeCACaTxAIABW9Ig
Date: Thu, 23 Jan 2025 08:25:13 +0000
Message-ID: <BN9PR11MB5276B783D518DB354BF58A3C8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca> <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca> <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DWag7ZKCPl1Eje@google.com>
In-Reply-To: <Z5DWag7ZKCPl1Eje@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6264:EE_
x-ms-office365-filtering-correlation-id: a632260a-3b5f-4c7f-fb1b-08dd3b8775b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUNtS3o1TkdRRm5KNktRV2VXSFMxQkt2SjVVWUhpQmk4Ky9WaUFIS0dzaFRj?=
 =?utf-8?B?YzJhVENsemxWQzJwREsyZkJ4eE0wTnFWV2Frb3RIVi9DRlFORVE1bzBYaEpP?=
 =?utf-8?B?QTR4UUx6UDNSMi9LdzNwQmxHSFVQZ1ZQOERJSmZUQk1uSUtIQ2ptanJuNnU0?=
 =?utf-8?B?WUltbTVaeENSbW9mZGpQTVF5U2w5bmpjYWEwUWp5TXI0alBEUWo0dWwvTDBC?=
 =?utf-8?B?MzFFeWJLaU8yYkhoYXRKWXlnZjZVdHN2WlpKbC83eVpzYzJTME5IN0txaU1U?=
 =?utf-8?B?TnZ1N2VRcDBwWGRtUlVlNHprZUVzSFc5WlAvcHlzTHBsQjVDMkN0VTZzMFJ6?=
 =?utf-8?B?NmZXTCtWdHJHUFJnUXFMbjY1UFR3Q1l2aEplb2tuWXAyWnc2TlZ3Nk5XRklm?=
 =?utf-8?B?RWhIN3hkMm9OSzR3Tzk5NEdlWUg0SGk3dUNINXFkZHlVaVdxaWQxRkJHcmNs?=
 =?utf-8?B?dXBadng3WHpKOFZXSlhuU0ExenhvQ0dERi9FUXFwdmlLenFFNjYySndoS05o?=
 =?utf-8?B?ZVJ5U2lUeHNtS1BtTEJybVRIK0Q2SU5qem9SdmR2b01TRVJwY3JwSHBhQkdZ?=
 =?utf-8?B?Z1FJMTlCRlF2VERDaXpEQVBnVTBiTk5nQzgxVHc5OFBuRzRwVjBybmx0Ym1Z?=
 =?utf-8?B?dXNYbGwvRWJNVkFNQ1VCTVlSNzBOWGhxT2poRDZyUWlOc3orMDRYZVhabUh4?=
 =?utf-8?B?RUhTWlhEaHIxbE1ZNlkzUU9UWWNXZzRqb01Sd3BheGhObzdHNDNoN0wvQXAx?=
 =?utf-8?B?aVpZVXBBNzZPcFJBM0ZOaDdaYkdhYnYyUzA2dktQbHo4YUJ6N3hNcVN1aGND?=
 =?utf-8?B?bll1L2JQaW9meVgzcUVNdE1nalVOaFAvTDBCYVFLZUxPL0ZUa0JvM0pPYmZK?=
 =?utf-8?B?N3Jtb21sQklpTGZRdWcvOEg1bWMra3pDZGJ4ZGhtaVU4YmxrZTdUWGJoWUo5?=
 =?utf-8?B?eWsrOFBFdzcwRGlseUpkSTlBYm8xL1NLaEp0a01kWk1PQTVnZWpJUnhwWmtB?=
 =?utf-8?B?SWc3NnpiemZDeDJYY3NtbjdEN3dnaUd5bGRIUWFZcmN4bTFxSldnQnp4czRi?=
 =?utf-8?B?ODFtekJ6bnZMalorSFhTZjdrMktxL1FrZnhiRlM1Wm1tQUxST25IaEhvVVoy?=
 =?utf-8?B?d01iQU4vazF4S2dFbGxhSnJkR0xzL0pNbHJ0MjFjQ1NqR2kzdERtcjlReTNX?=
 =?utf-8?B?UHluOUFXck0xZ2VsdUt6cXB0OHNZWnRQSVd0alo5QmpYSndSa215ZzNiUk05?=
 =?utf-8?B?L3BSa3IyL0tkQlYrTnRVdXVjOUorZXpkL3RhejFURmM4MmdNOGE3SjRIbHdx?=
 =?utf-8?B?aXBHSlpVQ0xGOGh0VHYvcGhWQmRWOTBTanJEMUhQS0lWNUVRdXZTdnFQU3pv?=
 =?utf-8?B?WEkrZGdkTHM4OE5Kb204OW9STTJRZHFjcEpVemFTZUhoZlpUdFoxS2crNllo?=
 =?utf-8?B?U1ZhZHhhYlNlMHY3RnZIV0FDVGU1Ym41WGRvMWhIUUx4NThHRFJ0MytxTTV2?=
 =?utf-8?B?S3pPeXcrbzFXZ2NUdm40Z1ZMeS9FZnhaWU0zMm4rODBWMDVZemJxSHFqbzNh?=
 =?utf-8?B?SXRiTkxBNER5dkhRS0ozSVM4SEFuSHQzamlJZ1h0ZmVlSE83Zk9IYW41QmZ6?=
 =?utf-8?B?OW9saHRBOUE4OGgzaUpaMFNyZDhnMnFBbGZaWUs2RVBzK0gzM0VPRWprdUgx?=
 =?utf-8?B?QzFNbEtjS1FHZTJubldkSlYzOHlZZkNlMWNJK0FmcHdlWVF1VWtRbUk5RWlR?=
 =?utf-8?B?Rk5vNmROT0tCdVB1TnZjVElXSTNvcDk3Z05HTjRmZkZrT0g0ZUk1b0ZEOEdm?=
 =?utf-8?B?NS80RHVmMEU5Wkw1OUpZdk1KU3dXd3BMQlFQSFVvcFo5c21ucS9DN3d4Mk1Z?=
 =?utf-8?B?TWdvWUEvVWRYWEFhUUNxSThJNThsTGFjUlQ4c2NrNHk3QlZ5VUdscHZNVVNj?=
 =?utf-8?Q?RrlFIZt3b0CocLcW30I6odTDme7BchIO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djFvWmxGaEQxK2VEKzF1UTd5blZqMWRhOE9qNWhRblBkM3Bhazk5Z1VCQ3BU?=
 =?utf-8?B?T0UwMUVLeDJtajNySXF6bGszU05qcDEyZFcrK1BPSzFXdmx0akpRMmpGSklw?=
 =?utf-8?B?ZkVEZEg1aWJaSW9VdEhzTkhNM2N2TFhmUktpNDJyWExSbkdHQWFQa1U2VzUv?=
 =?utf-8?B?MWZoS1hEVXV3VTRtNWxlclQyVk91TU5YaVdpNmJhQU5FZUQrU2Nxb3RUczJU?=
 =?utf-8?B?TXl2K3dhVGJPN0ttcmozbUp0K29ueFFjcnYzK0c5T28xU3A5MUFWUDlCL09p?=
 =?utf-8?B?dDkwMnc3YTZkcTZNNUJzL2l6ZElVV3NhQk5uQ29pcnZDdytIM1pFSTlCMlpE?=
 =?utf-8?B?SnNNMjNja285Y2RLWjJlMndBOFJZdkZiYkJtV1JuRFluMjRUWjhCVnZybDVC?=
 =?utf-8?B?UHVLMHlOYkJiMjdmZ1lVT3lTU09jU082TGZQQks0aEVCWmpwQW9uS2pudTl5?=
 =?utf-8?B?Q2dFNVZnUTZhZU4zVTFTS0RPSG5ESjlMOW5hYlF6eWg1VTF0dWd6NDRnWXY5?=
 =?utf-8?B?L1FRVm45VitncnA4S2NmN084bzZzemE1WEJCMVZFV0U4VnRZQ296cWg3ekdr?=
 =?utf-8?B?bG5iSHFHRGJUSndlbzBQOFUrSHN5RU9TcXUyRjBlQXZGNFhYV1F0S0hVdE5n?=
 =?utf-8?B?c0JnOEg5MHVIelhwZjBCbDBybDYwbkUzcUJSV1JYNWd5aDNEcTRFVTFVSGdl?=
 =?utf-8?B?a3Z2TWhHR2Y2ZTNSSHVSSmNOQVN5Y0RJWmdxMkVOSWNOUGFYeTBDcjlGczVs?=
 =?utf-8?B?SUhKcStJeTYzMmtQZGtBVWZTTTZ4eXZvYlY3bEpqMGtnWGdKcUNSWVlIRURx?=
 =?utf-8?B?QzdNNk05Q0pOd0tsWUx4VTNNYXFDbm5wbXpxZ2s3TjBDbldZL2V1azY5ZUZO?=
 =?utf-8?B?RTB3cXZyY0JBTlkvcUJuUWFOQjFyVG5YMDF4Tm5sOTd2WFlxazRCTE1rOFcw?=
 =?utf-8?B?aUtqbFN1U0thYUlTSHRVOWEvY25kajFMam9wc1Rzc2QxUHlCa052V1p0UkZZ?=
 =?utf-8?B?bjN3QU1JTTZpVlcrKzVxS2pNTTUyTmkyS0RHLytGempTRzdhZWFXeWlvNStD?=
 =?utf-8?B?eXoxRjJKZ3oxUzl1YmRHTG4vT1FFbGlRc0pHVlFld09WRjRXdmRzSVBqOTBI?=
 =?utf-8?B?cEQxKzZGS3A5emdCamNHaWNDemVhWWhxcmZZK2xBUkZweU5Vc0VsQzRwcER4?=
 =?utf-8?B?b2JIbjVDcnVGUlMwZUNRV3VxVy9JbDU1MDlQa3pzUmFzL2QxNkdMYzRSNHZR?=
 =?utf-8?B?VUpRWHM4NWN3K3FpVWdNMkFUZldJRytUMjlKWFNINXp5cHpkWkdTNDRvdjg2?=
 =?utf-8?B?N3hzNzI0NXpPU1hZMEUrc1p1U1lGY2dtMEc4S0FlWkpOT0FRVjU5MUFvcE55?=
 =?utf-8?B?cC9IYUhyTkk4Zmh6SlpyZGt5Y2g5U1MrOTYwOEh5QWU3UUpKR21neVYwZ0tl?=
 =?utf-8?B?Q2E1aUsyajVORzNTd0lJVVgyczFHNTB1Yysvc29TMWwyTVB4TUk3aHc2T3JT?=
 =?utf-8?B?cmRENTBRN3pYT09qcGRRR3NmaVA4V3A5bUNFcVdxVGtheTlwb2lKZGs3dTY5?=
 =?utf-8?B?NlVyN29hb1lXYmw1cTNQVU0wZVd5cFE5QzdyLzFOb2JNRkpBKzdOdHVnb2di?=
 =?utf-8?B?L1M4cVVIa3pZbTBWajN0VEFHVHNCVDhiaEZFOXFOcktZTWIwSmV6ek5RTTFD?=
 =?utf-8?B?eUxvSUlsY0RQQ29sTmhzR1NtLzlLeE9HWUoybC9hTGVFNWsxcGFGbjlMMU5R?=
 =?utf-8?B?Y25WV1NIMlBhQ1VXTzBUS0ZKQlBKWGlVMXpkK3lQckFNS29CRHQxS08vQWEr?=
 =?utf-8?B?U1RPemNmV3ozdytmcUZXdUV4ekxkQ0xNeDRPdW8xMnoveXROb0o2ZG5oVktY?=
 =?utf-8?B?d2FDNCtVTDZvSHZYcDdyUG5iYWFyMjZZNjVMRXdNdmRVRlo0dDlwRW1QTXBU?=
 =?utf-8?B?Y05KUVNjK296WkEwT2ltNFBQN1FBbXVOdC93b3lHMXVmSWE5YnlBMHBJb2tV?=
 =?utf-8?B?bUY5Sk1IZUE5RFpyMUFIZE9NTVE3cUVxamxxbFg4YmlZTDhyY1dkRVBHYlpU?=
 =?utf-8?B?V2hSRDI2RytIR0hoODZGRFpvdFRVZk1XckxtemdIT1Vybis0UXhyMmVrMEtt?=
 =?utf-8?Q?3PPifLkVM0RDV+t0O9G0SfqbX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a632260a-3b5f-4c7f-fb1b-08dd3b8775b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 08:25:13.7065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0HgBBUjk73aMnoK3xZUDk2CYW+BIna9bzR7oBqQevJ5te+OAIsX+b+LcP7dUa7SoevPCnYq2uS+TsboTt1Ikg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6264
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgMjIsIDIwMjUgNzoyOSBQTQ0KPiANCj4gSGkgS2V2aW4sDQo+IA0KPiBP
biBUaHUsIEphbiAxNiwgMjAyNSBhdCAwODo1MToxMUFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90
ZToNCj4gPiA+IEZyb206IE1vc3RhZmEgU2FsZWggPHNtb3N0YWZhQGdvb2dsZS5jb20+DQo+ID4g
PiBTZW50OiBXZWRuZXNkYXksIEphbnVhcnkgOCwgMjAyNSA4OjEwIFBNDQo+ID4gPg0KPiA+ID4g
TXkgcGxhbiB3YXMgYmFzaWNhbGx5Og0KPiA+ID4gMSkgRmluaXNoIGFuZCBzZW5kIG5lc3RlZCBT
TU1VdjMgYXMgUkZDLCB3aXRoIG1vcmUgaW5zaWdodHMgYWJvdXQNCj4gPiA+ICAgIHBlcmZvcm1h
bmNlIGFuZCBjb21wbGV4aXR5IHRyYWRlLW9mZnMgb2YgYm90aCBhcHByb2FjaGVzLg0KPiA+ID4N
Cj4gPiA+IDIpIERpc2N1c3MgbmV4dCBzdGVwcyBmb3IgdGhlIHVwc3RyZWFtIHNvbHV0aW9uIGlu
IGFuIHVwY29taW5nDQo+IGNvbmZlcmVuY2UNCj4gPiA+ICAgIChsaWtlIExQQyBvciBlYXJsaWVy
IGlmIHBvc3NpYmxlKSBhbmQgd29yayBvbiB1cHN0cmVhbWluZyBpdC4NCj4gPiA+DQo+ID4gPiAz
KSBXb3JrIG9uIGd1ZXN0IGRldmljZSBwYXNzdGhyb3VnaCBhbmQgSU9NTVUgc3VwcG9ydC4NCj4g
PiA+DQo+ID4gPiBJIGFtIG9wZW4gdG8gZ3JhZHVhbGx5IHVwc3RyZWFtIHRoaXMgYXMgeW91IG1l
bnRpb25lZCB3aGVyZSBhcyBhIGZpcnN0DQo+ID4gPiBzdGVwIHBLVk0gd291bGQgZXN0YWJsaXNo
IERNQSBpc29sYXRpb24gd2l0aG91dCB0cmFuc2xhdGlvbiBmb3IgaG9zdCwNCj4gPiA+IHRoYXQg
c2hvdWxkIGJlIGVub3VnaCB0byBoYXZlIGZ1bmN0aW9uYWwgcEtWTSBhbmQgcnVuIHByb3RlY3Rl
ZA0KPiA+ID4gd29ya2xvYWRzLg0KPiA+DQo+ID4gRG9lcyB0aGF0IGFwcHJvYWNoIGFzc3VtZSBz
dGFydGluZyBmcm9tIGEgZnVsbC1mbGVkZ2VkIFNNTVUgZHJpdmVyDQo+ID4gaW5zaWRlIHBLVk0g
b3IgZG8gd2Ugc3RpbGwgZXhwZWN0IHRoZSBob3N0IHRvIGVudW1lcmF0ZS9pbml0aWFsaXplDQo+
ID4gdGhlIGh3IChidXQgc2tpcCBhbnkgdHJhbnNsYXRpb24pIHNvIHRoZSBwS1ZNIHBhcnQgY2Fu
IGZvY3VzIG9ubHkNCj4gPiBvbiBtYW5hZ2luZyB0cmFuc2xhdGlvbj8NCj4gDQo+IEkgaGF2ZSBi
ZWVuIHRoaW5raW5nIGFib3V0IHRoaXMsIGFuZCBJIHRoaW5rIG1vc3Qgb2YgdGhlIGluaXRpYWxp
emF0aW9uDQo+IHdvbuKAmXQgYmUgY2hhbmdlZCwgYW5kIHdlIHdvdWxkIGRvIGFueSBwb3NzaWJs
ZSBpbml0aWFsaXphdGlvbiBpbiB0aGUNCj4ga2VybmVsIGF2b2lkaW5nIGNvbXBsZXhpdHkgaW4g
dGhlIGh5cGVydmlzb3IgKHBhcnNpbmcNCj4gZGV2aWNlLXRyZWUvYWNwaS4uLikgYWxzbyB0aGF0
IG1ha2VzIGNvZGUgcmUtdXNlIGVhc2llciBpZiBib3RoIGRyaXZlcnMNCj4gZG8gdGhhdCBpbiB0
aGUga2VybmVsIHNwYWNlLg0KDQp5ZWFoIHRoYXQnZCBtYWtlIHNlbnNlIGZvciBub3cuIA0KDQo+
IA0KPiA+DQo+ID4gSSdtIGN1cmlvdXMgYWJvdXQgdGhlIGJ1cmRlbiBvZiBtYWludGFpbmluZyBh
bm90aGVyIElPTU1VDQo+ID4gc3Vic3lzdGVtIHVuZGVyIHRoZSBLVk0gZGlyZWN0b3J5LiBJdCdz
IG5vdCBidWlsdCBpbnRvIHRoZSBob3N0IGtlcm5lbA0KPiA+IGltYWdlLCBidXQgaG9zdGVkIGlu
IHRoZSBzYW1lIGtlcm5lbCByZXBvLiBUaGlzIHNlcmllcyB0cmllZCB0bw0KPiA+IHJlZHVjZSB0
aGUgZHVwbGljYXRpb24gdmlhIGlvLXBndGFibGUtYXJtIGJ1dCBzdGlsbCBjb25zaWRlcmFibGUN
Cj4gPiBkdXBsaWNhdGlvbiBleGlzdHMgKH4yMDAwTE9DIGluIHBLVk0pLiBUaGUgd291bGQgYmUg
dmVyeSBjb25mdXNpbmcNCj4gPiBtb3ZpbmcgZm9yd2FyZCBhbmQgaGFyZCB0byBtYWludGFpbiBl
LmcuIGVuc3VyZSBidWdzIGZpeGVkIGluDQo+ID4gYm90aCBzaWRlcy4NCj4gDQo+IEtWTSBJT01N
VSBzdWJzeXN0ZW0gaXMgdmVyeSBkaWZmZXJlbnQgZnJvbSB0aGUgb25lIGtlcm5lbCwgaXTigJlz
IGFib3V0DQo+IHBhcmF2aXJ0dWFsdGlvbiBhbmQgYWJzdHJhY3Rpb24sIEkgdHJpZWQgbXkgYmVz
dCB0byBtYWtlIHN1cmUgYWxsDQo+IHBvc3NpYmxlIGNvZGUgY2FuIGJlIHJlLXVzZWQgYnkgc3Bs
aXR0aW5nIGFybS1zbW11LXYzLWNvbW1vbi5jIGFuZA0KPiBpby1wZ3RhYmxlLWFybS1jb21tb24u
YyBhbmQgZXZlbiByZS11c2luZyBpb21tdV9pb3RsYl9nYXRoZXIgZnJvbSB0aGUNCj4gaW9tbXUg
Y29kZS4NCj4gU28gbXkgZ3Vlc3MsIHRoZXJlIHdvbid0IGJlIG11Y2ggb2YgdGhhdCBlZmZvcnQg
YXMgdGhlcmUgaXMgbm8NCj4gZHVwbGljYXRpb24gaW4gbG9naWMuDQoNCkknbSBub3Qgc3VyZSBo
b3cgZGlmZmVyZW50IGl0IGlzLiBJbiBjb25jZXB0IGl0IHN0aWxsIG1hbmFnZXMgaW9tbXUNCm1h
cHBpbmdzLCBqdXN0IHdpdGggYWRkaXRpb25hbCByZXN0cmljdGlvbnMuIEJlYXIgbWUgdGhhdCBJ
IGhhdmVuJ3QNCmxvb2tlZCBpbnRvIHRoZSBkZXRhaWwgb2YgdGhlIDIwMDBMT0MgZHJpdmVyIGlu
IHBLVk0gc21tdSBkcml2ZXIuIA0KYnV0IHRoZSBzaXplIGRvZXMgc2NhcmUgbWUsIGVzcGVjaWFs
bHkgY29uc2lkZXJpbmcgdGhlIGNhc2Ugd2hlbg0Kb3RoZXIgdmVuZG9ycyBhcmUgc3VwcG9ydGVk
IGxhdGVyLg0KDQpMZXQncyBrZWVwIGl0IGluIG1pbmQgYW5kIHJlLWNoZWNrIGFmdGVyIHlvdSBo
YXZlIHYzLiBJdCdzIHNpbXBsZXIgaGVuY2UNCnN1cHBvc2UgdGhlIGFjdHVhbCBkaWZmZXJlbmNl
IGJldHdlZW4gYSBwS1ZNIGlvbW11IGRyaXZlciBhbmQNCmEgbm9ybWFsIGtlcm5lbCBJT01NVSBk
cml2ZXIgY2FuIGJlIGp1ZGdlZCBtb3JlIGVhc2lseSB0aGFuIG5vdy4NCg0KVGhlIGxlYXJuaW5n
IGhlcmUgd291bGQgYmUgYmVuZWZpY2lhbCB0byB0aGUgZGVzaWduIGluIG90aGVyIHBLVk0NCmNv
bXBvbmVudHMsIGUuZy4gd2hlbiBwb3J0aW5nIHBLVk0gdG8geDg2LiBDdXJyZW50bHkgS1ZNIHg4
NiBpcyANCm1vbm90aGV0aWMuIE1haW50YWluaW5nIHBLVk0gdW5kZXIgS1ZNL3g4NiB3b3VsZCBi
ZSBhIG11Y2gNCmJpZ2dlciBjaGFsbGVuZ2UgdGhhbiBkb2luZyBpdCB1bmRlciBLVk0vYXJtLiBU
aGVyZSB3aWxsIGFsc28gYmUNCnF1ZXN0aW9uIGFib3V0IHdoYXQgY2FuIGJlIHNoYXJlZCBhbmQg
aG93IHRvIGJldHRlciBtYWludGFpbg0KdGhlIHBLVk0gc3BlY2lmaWMgbG9naWMgaW4gS1ZNL3g4
Ni4NCg0KT3ZlcmFsbCBteSBndXQtZmVlbGluZyBpcyB0aGF0IHRoZSBwS1ZNIHNwZWNpZmljIGNv
ZGUgbXVzdCBiZSBzbWFsbA0KZW5vdWdoIG90aGVyd2lzZSBtYWludGFpbmluZyBhIHJ1bi10aW1l
IGlycmVsZXZhbnQgcHJvamVjdCBpbiB0aGUNCmtlcm5lbCByZXBvIHdvdWxkIGJlIHF1ZXN0aW9u
YWJsZS4g8J+Yig0KDQo=
