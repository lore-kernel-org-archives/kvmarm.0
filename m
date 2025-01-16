Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C3426AF6;
	Thu, 16 Jan 2025 08:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737017516; cv=fail; b=AbTykkkLHIjQkMaNre4yexIhXWrM+03FgbAlqL5XzvZj7tFQamEoPaZiCkNTmAga98f5lnpI/+2Uy9HLoBq9tWIeaZDjpqy7DKaNjOwC4zj3tSuLdjObLdiZccKkK3uexIKohaWLWmcjeDb3lke5RFp0QTnd0UlxDT3XSHrhG84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737017516; c=relaxed/simple;
	bh=zvxc16OXjwKuL2byN+CTI0o+/lwKQgKKxC0UALUVUSU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rMQR0GBnS8wKCv5Kar3VZQC8syPR1b8YFyqEfGyiLTG9zXNvwAVZoxY2deN9E9DbegPUqf5NgQzGtVPLUPeiyMmvWVCYhnE7NUgztvMiXz6h/UsbMCwnpW4P5kLYp6mwXa1k8U/v14QcGaJVBIIokDJ5Vl5wdJkDHKyPUWQJ0DQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kBT+NI1d; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kBT+NI1d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737017515; x=1768553515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zvxc16OXjwKuL2byN+CTI0o+/lwKQgKKxC0UALUVUSU=;
  b=kBT+NI1d3+OO+lBY1wUt3kVvYYnk2qQTzF2OyTxHBHRaLd+pIWxkXJfq
   /pkEnCQl7pNH2p7f9rBrVhA7w3G3qBaSUrIf6b/vTHTWfyY3Eg5IxN763
   Rx12v6oqcSYZ7+eG/g01jkYqFg7FxuL5BtCo+JiEXeSnkfkfTaY71t7yK
   iHeCnn+tadWoFf0oapj0xxvWqYbLUBDTQ/YzG6lksPhdO4iq/xyoo3Xik
   ooqsz76le9yB84/llCUmLvfFWBzZDi5CdQLYEOWab4f+qA8pqsuwWKb4E
   V/GMiN13vv/7RElg7cnMRclL3fhLRAvz1gkzLhSxmBTxC1/ggDGz6EEsz
   w==;
X-CSE-ConnectionGUID: wei9V3OsRHSestgWUK7c8A==
X-CSE-MsgGUID: gHu/fj8ySuSHvvvZVrvbZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41154126"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="41154126"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 00:51:41 -0800
X-CSE-ConnectionGUID: tulwb5QlQ1OadJWpFZZwSA==
X-CSE-MsgGUID: tHDhSxy8QGaa8TM5ynwt2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="106002514"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 00:51:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 00:51:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 00:51:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 00:51:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ju196W4tVZnYB1wS6QTe+FidtleZjMBKhtVFPRntCpOGCmZyetzU72Ny2jJz4HEnv00bo/b3aq1Y9k1fBHsdQg1bNAtkUXmB416yFplMgVg3YUQgiE1rAhv6Bq2DEAsCIO4fOsqPAKlo89hhe+7iLLetWl2CTmWTGcDyJ6R7561eyo1V0SlUh8Ozs27c1JUcRcKVI48PTWy394twpqOCP3ADGY4L9C/WXwaP6DMxzPSqqDg5wEO05K/T2FHzrgdC7s8zbzovhc0zy577/U+fenWyZI+rL5V+IfWQ/zxEW+x65fzVvad110025ijKgzN4P+MBxYgIiSkKfnMiPYxLow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvxc16OXjwKuL2byN+CTI0o+/lwKQgKKxC0UALUVUSU=;
 b=HWeEuJaALIk7JzGIDJKFhC1owg1wmTq9zh8myMGr15wRuuGpXXsDXgTF6mpRnhOV2Qx47+byw4Jsa9JwMb+/ggLsma1DyokBVPP0WKZZLvqBzNFEiMUqGut0xYxNRzCByUkiNOlq/gOicgYi/t/emg7VubTZ2+FjErvNgM5zO7M2/xGHKv7gv8LA4snOQkMdfJiSZ+gdfdRYemnKNoC5GOHHRzzo57zAvyaiw7AWaWc5VL1jHmZ1sRsr5l5u5nSOPmaekjvfjRf0j1MoOYQji7GhmHetwm21SqOKKnlPkDF3LuvyARRgcMGAiemoRjZbAO6rKR5R9u7vmvWX0/C6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4568.namprd11.prod.outlook.com (2603:10b6:208:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 08:51:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 08:51:11 +0000
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
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAxQMeA=
Date: Thu, 16 Jan 2025 08:51:11 +0000
Message-ID: <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4568:EE_
x-ms-office365-filtering-correlation-id: 773ad6af-8d1a-429b-2e77-08dd360aed23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OVhvRjRTVVZsOFJ5MkJLRURyU3M3L1RYbE92WEhxdG9nQytWQlJMQjVyUFNM?=
 =?utf-8?B?WStpMVh6NkFQbzdGSEJpYjJmS1dPbkpHZ0lOcUsvcWVQaVdDQzFDQ1o3WGFB?=
 =?utf-8?B?MzZNUlZWNG1MQmJ2MEpkaVVXSDFPOEhpOENQYWNxRFlvT1JyK1dzZ2VDSERj?=
 =?utf-8?B?L0NBOEgrbmFBMFloVWlhVmZ1MXRseHNacWtPT1FZY2hHU2Flb2JETCtZUGZW?=
 =?utf-8?B?OUZQN1JDV2tBdDBRQ01qSDhTRVNETTh2MkhmdkU4bVJrazYrZm5CZlk4ekdE?=
 =?utf-8?B?WTB3V1lXaG1qcmNlbHdpVmhUMTBWNjYzeVVqeUNkaklLNGpIR0ZuS1VTYUxL?=
 =?utf-8?B?b0g0bEp2WW5lS3NKN00xUWpiaUxqZitCQTF5bjBXQlJWa0NpN2dobFptc0hP?=
 =?utf-8?B?bmFXUnF2ZjZiL1hPZXdpZmxUb3MzL1RjUTgxSHhZN1NiOTlTQnRrUDhDbWFn?=
 =?utf-8?B?ZXJjRjIyTmt1MWN3dFpaYWM5ZklkeW56T214cjRKUU5SRmN0dmhZcWJRQWYy?=
 =?utf-8?B?NjNjRkFBQjZCVHRFaHNFSG53bE5YWk9ROFFOOEt6bDhkN084QzBsYW1WY01L?=
 =?utf-8?B?ckU2cVlmUUIzbzZzN3k0b2w1U0F5dVZScGdaL1hXZFRvbGREczE1ZDNvOUlt?=
 =?utf-8?B?aDE0M1NlRmlOQjVBT2pFUzVhUFIySFhVMWNLOW9BVmtIVWNBWkVnRXYvK1pR?=
 =?utf-8?B?cjRHR091NXFkYmI0MTllS1dwRmwwbkowYVAxMTgxVWUzOTEvUUtwUkJqeXFQ?=
 =?utf-8?B?TlB3UmhldkZUb1JCbEN5ZFY2ZDNmY1VncjN4S0dNdlYydXNYR3JUZU1lNVN6?=
 =?utf-8?B?eGdZWHJXQzVxYmlIdUZWNGdVVTBObi9lcTE3NHF5cWZzMnk0MGFjQ2R2SUk0?=
 =?utf-8?B?QkE0RTd6R1l2QUdHdEpxMHpuaitZb1pidityRWJPRGRCWXhwOCtmUVdWbWJD?=
 =?utf-8?B?eXdQUExUM1YrNkRWeWtUNHFVakIvYnNDRVQ3S3I1M1RhR0dRZjRKWGxkWG5E?=
 =?utf-8?B?ZmEvbEUxUTZkL0JkSjhQWnR3QVpLWmpicnNFODZ2bTRPSHpPZk1BRnBzMXpO?=
 =?utf-8?B?anpQZVFYbEREaHZkZk95dGt3WkczY1laNTJHWTgrTmpjbmkrcU0vZjYrN0NL?=
 =?utf-8?B?MUc5VlUzdnNUVEFaNGIxUUNhdUszRExOZkp1eVh0QXJlYkxRMDIvWW1OSzhk?=
 =?utf-8?B?UFo0angyVzAwYlBLYnNIaE01Z3QyWjVyQkVMYUpYeEVxS29ydEdWV2g3RE8y?=
 =?utf-8?B?M2hoK1hYM3Zieit0NVZ6Y1ozUFplUkxiZk9GQmU5d0xycXZiblZrVWlJeS9l?=
 =?utf-8?B?dUt4cSt5MTlTdlZFWHMzek53elpmNDFDTlFpek4yRGpVbGdnejRDT2JDVWtH?=
 =?utf-8?B?MmQzUThMeTBOcjFXSDZqcDdlWm8xODUxcEcvYmFnaWgvdXliR2gzQ1NwWXMr?=
 =?utf-8?B?MDBWNTgwdmFBUmdGYmZsclE0Nk5VSUVzNm1JVmxaaFNTS2VHSUNLOVVIMi9Z?=
 =?utf-8?B?V1d3TkVxWjhjWDNDT3FyQytEb2NVRlVxT0xMNXBqcWVGczIzL3dHU3EvT1dv?=
 =?utf-8?B?b1pONXQ2QkV1dHV6R2UwSFk2aUF3eDJ1VUhDd0NpVmxFSzdod1AraTB4UC93?=
 =?utf-8?B?NFdlRkJ4N0t2S3BJMHRWQk8xQUx2bFk3U1o0SzY1MDkzNWVtNEtxUHZvUlRK?=
 =?utf-8?B?VGdTYXZGUXBFNTZ4Zk05Lzc5Q3crSEZJQVVOb1FuMnM4eVhKYlN3QnM5ditv?=
 =?utf-8?B?WnQ0UmFkUFd6K0xqaE1rVnJiOGN4QThiSWpUeklLWmdKRkVIb3lHZnpqb0RQ?=
 =?utf-8?B?eHNBNGE5ZUFpeGZNWHk4djVjN05IWG0vL0ErMVZyU3ZBNGx3K3MxemFpZEdn?=
 =?utf-8?B?c0YxQmJOSkVjVXkrODlLWWk4WEsybGFFSzhIWlYvYmJGNVo4bS9oS21QSTM5?=
 =?utf-8?Q?ZAEfW2rUAxUMIgdDSYWkBO7ytoJe7fd5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWlLbnNaMXdKT0RWMzlONEh0QnZoUHplbVhjUTE3Y0p1MFJFZDNGZWxNMVlV?=
 =?utf-8?B?anFTenhmTE5zUFJ1RDNkR2xWQ3owVmZxR3oveWxhZE5neW9rdzlYaWNXRmE5?=
 =?utf-8?B?YmxFQ0hPeTR6VWQwQWZOWDlXQVdsWnBvM2J3L3lMVW4va0pwSVZTWVJ6eHhY?=
 =?utf-8?B?dzl5WGRIeVZiYWdJeHFLSG1zZHQ2bU1JUThSU3FBaXRhQlE0cU5xb21tYUly?=
 =?utf-8?B?YnhGeGVKTnhEM0tYVXcrRU5PejZVdFZHY3k3SGpsMDh5ZjY4TFp1VVUyS1ZV?=
 =?utf-8?B?WHlILzllaEExTVFaVDMwN1BPTC92eTBzZEljZVlvR0J2bTVRZHRVaTFIK01Q?=
 =?utf-8?B?TFlQa00wRC8vOUZrSjZacG5zVk5xams4N2hFMk1tU1pwTFNiM2RocytEZ0Z4?=
 =?utf-8?B?SFkxTVArcXJSWHAyNFcwRmUrT1lXVkRUMGdXdkdERUY2RUNpTU5jV1RZaUpP?=
 =?utf-8?B?MVVYUEVrTHVhbmdrR0toUmdEVmZ1QURMQ0FZTWIwZW5XNXdpMXFwczN0WWpj?=
 =?utf-8?B?MGY2N01Ldy9CMmFuZUM5QllBSE4wUnhjM0RxZE5mRS9JZGZmU0NJN3RvN3hK?=
 =?utf-8?B?YUpadUQzay8vSVJJaXBxcE5rVFk2MjBWcUpmZE9xU3V0NFhrTUNVZWd0cTl2?=
 =?utf-8?B?T1gydm9rK0c0cE1jWE5wNnhzVDJlakZETFIvR3ZTSG5FQVEzQVdMUzJ3NVkz?=
 =?utf-8?B?bFRGR3p3dGlndEVnVU1hZ3VjNnluV3U1cnJYRnJWUERUWkxudjNJSHE2cHhE?=
 =?utf-8?B?dFhMbVJyS1o4V1V4cUN2MUhOSkJySTFLSUJyRVlPTGNoZmR0UklDaGtnYTk1?=
 =?utf-8?B?WUFFQ1ZJYVRMSFBNV2UweTUxK3pvY25WdmNRZzNuMFpHZnd3RlMrM0h5cHRh?=
 =?utf-8?B?M1hzNm5xQXdkVjdYNWdiQWFzSUptSHREaHc3a2RONWM1TUx1U0RNYjZDZ3N6?=
 =?utf-8?B?ZTdMbjNCTXNLMCtPREo5MTQ3WHRTT0ZaMFl3cVB4TXZYYlJCMDNiSXU1ekR1?=
 =?utf-8?B?QzNQTW1wU3VkVlB3azFiOGgyK0Y0OVQ0NWNNV2g4Vlp4VTNNMXdEUUdpNkcv?=
 =?utf-8?B?NFphMVRrbEptNWI1WGZjT0dLVGM3MUtQSDE5Mzd6RTFiSExzU01PYnJsN0d5?=
 =?utf-8?B?a01hZnRwOGNieWROdXE4N0s1WmFHb3ZxcnVoRTM3eWsrV1RYM2JMTXMwQnZm?=
 =?utf-8?B?eDQrY3VrbFVOK0dhZTd5YTlRY2tNSDdnU0hKUjFjYk4xTjdweHh1RlkxMHEy?=
 =?utf-8?B?QTJxNGx2eHZoYytGVmRYVHlJckFuS0xCMGtyVTVLZ1F4TlFkOG9MdGd6Y1JQ?=
 =?utf-8?B?dTgwZkNCU1VOWGkweE5HN0daRXVyekJFVnBQd2xHWmx3aUZCQStwek5Ra3B6?=
 =?utf-8?B?TmFWNURuU1NRMzYydENUK3pMdGNlSWRCd0FvTWlLTXBQL2JGV3ltQ2gvZ3hK?=
 =?utf-8?B?NVB6YzBBM21hZFU5SGt3UERHVUs5QXF4T0d5TlZ5V0YzdDNxanArYkhURm9N?=
 =?utf-8?B?MjUvT00zcVhqYjNmdExEdFZLTjBYSHNKc1hiWElsRHZTUzNtYTloRnM2d0xH?=
 =?utf-8?B?UGZLdFhFTlFvZURsL0lFTlVkeHJGR2hhOXhUeTdhcFFWS0w3eUJsNysxMWR3?=
 =?utf-8?B?NEJXOW05NnU4a2MybVlYRVRicHl4SUZsSnA4VUQ2eGV6Vkh5RkRrQnJnV3RK?=
 =?utf-8?B?TEkzK2s5YldWNG1Ic3NkZHE0UXhvRGVNMFVHN1J3ZUpFSHJWL2FaNVNjVVM4?=
 =?utf-8?B?azB1aTdsOWZSK3pxcEFVbFBtQllzcWE0NldPODN6MlViNFlxUmtSTythV1dp?=
 =?utf-8?B?S1lWbDNHa2tnZ1FMcldkQUt0WkU0Mi9FU3RtVEtQd0UwbmVCbGxIZmd6Q2Fw?=
 =?utf-8?B?MUhEOTVaT3M4QTNEVXdkeVJWaW5XNlI5WHRId3VMQjJWeklXOFRQMFpBcmJT?=
 =?utf-8?B?alF3Uk9nbUtlMXkyZTNRR0prdngyRmc3TGJ6VXV4STUyVnlLait0eElCTmxH?=
 =?utf-8?B?ODcycERtRUVSbDN1b0VjTHgwYkx6KzM0eG1TQ2pRNG5VeGJPbWV0bTVEU3JT?=
 =?utf-8?B?WHAvZlh5OEtHWTBvalNTQjZBWkQzSm9JL0wvWG1Ddk5UUDl6THg0MDZXSW05?=
 =?utf-8?Q?b/1rGAJnIxDQM4u2klXWlFRtc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 773ad6af-8d1a-429b-2e77-08dd360aed23
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 08:51:11.2099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lEaMaHHTeEDj73DHnYgkUJVBXo/HBveDYLliObonf2mERqnjVEZpTpEFK4HeSEPWPkEfp78H9XSCgI+jUC+OsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4568
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgOCwgMjAyNSA4OjEwIFBNDQo+IA0KPiBPbiBUaHUsIEphbiAwMiwgMjAy
NSBhdCAwNDoxNjoxNFBNIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4gT24gRnJp
LCBEZWMgMTMsIDIwMjQgYXQgMDc6Mzk6MDRQTSArMDAwMCwgTW9zdGFmYSBTYWxlaCB3cm90ZToN
Cj4gPiA+IEkgYW0gb3BlbiB0byBhbnkgc3VnZ2VzdGlvbnMsIGJ1dCBJIGJlbGlldmUgYW55IHNv
bHV0aW9uIGNvbnNpZGVyZWQgZm9yDQo+ID4gPiBtZXJnZSwgc2hvdWxkIGhhdmUgZW5vdWdoIGZl
YXR1cmVzIHRvIGJlIHVzYWJsZSBvbiBhY3R1YWwgc3lzdGVtcw0KPiAodHJhbnNsYXRpbmcNCj4g
PiA+IElPTU1VIGNhbiBiZSB1c2VkIGZvciBleGFtcGxlKSBzbyBlaXRoZXIgcGFyYS12aXJ0IGFz
IHRoaXMgc2VyaWVzIG9yIGZ1bGwNCj4gPiA+IG5lc3RpbmcgYXMgdGhlIFBvQyBhYm92ZSAob3Ig
bWF5YmUgYm90aD8pLCB3aGljaCBJTU8gY29tZXMgZG93biB0bw0KPiB0aGUNCj4gPiA+IHRyYWRl
LW9mZiBtZW50aW9uZWQgYWJvdmUuDQo+ID4NCj4gPiBJTUhPIG5vLCB5b3UgY2FuIGhhdmUgYSBj
b21wbGV0ZWx5IHVzYWJsZSBzb2x1dGlvbiB3aXRob3V0IGhvc3QvZ3Vlc3QNCj4gPiBjb250cm9s
bGVkIHRyYW5zbGF0aW9uLiBUaGlzIGlzIGVxdWl2aWxhbnQgdG8gYSBiYXJlIG1ldGFsIHN5c3Rl
bSB3aXRoDQo+ID4gbm8gSU9NTVUgSFcuIFRoaXMgZXhpc3RzIGFuZCBpcyBzdGlsbCBicm9hZGx5
IHVzZWZ1bC4gVGhlIG1ham9yaXR5IG9mDQo+ID4gY2xvdWQgVk1zIG91dCB0aGVyZSBhcmUgaW4g
dGhpcyBjb25maWd1cmF0aW9uLg0KPiA+DQo+ID4gVGhhdCBpcyB0aGUgc2ltcGxlc3Qvc21hbGxl
c3QgdGhpbmcgdG8gc3RhcnQgd2l0aC4gQWRkaW5nIGhvc3QvZ3Vlc3QNCj4gPiBjb250cm9sbGVk
IHRyYW5zbGF0aW9uIGlzIGEgYnVpbGQtb24tdG9wIGV4Y2VyY2lzZSB0aGF0IHNlZW1zIHRvIGhh
dmUNCj4gPiBhIGxvdCBvZiBvcHRpb25zIGFuZCBwZW9wbGUgbWF5IGVuZCB1cCB3YW50aW5nIHRv
IGRvIGFsbCBvZiB0aGVtLg0KPiA+DQo+ID4gSSBkb24ndCB0aGluayB5b3UgbmVlZCB0byBzaG93
IHRoYXQgaG9zdC9ndWVzdCBjb250cm9sbGVkIHRyYW5zbGF0aW9uDQo+ID4gaXMgcG9zc2libGUg
dG8gbWFrZSBwcm9ncmVzcywgb2YgY291cnNlIGl0IGlzIHBvc3NpYmxlLiBKdXN0IGdldHRpbmcN
Cj4gPiB0byB0aGUgcG9pbnQgd2hlcmUgcGt2bSBjYW4gb3duIHRoZSBTTU1VIEhXIGFuZCBwcm92
aWRlIERNQQ0KPiBpc29sYXRpb24NCj4gPiBiZXR3ZWVuIGFsbCBvZiBpdCdzIGRpcmVjdCBob3N0
L2d1ZXN0IGlzIGEgZ29vZCBzdGVwLg0KPiANCj4gTXkgcGxhbiB3YXMgYmFzaWNhbGx5Og0KPiAx
KSBGaW5pc2ggYW5kIHNlbmQgbmVzdGVkIFNNTVV2MyBhcyBSRkMsIHdpdGggbW9yZSBpbnNpZ2h0
cyBhYm91dA0KPiAgICBwZXJmb3JtYW5jZSBhbmQgY29tcGxleGl0eSB0cmFkZS1vZmZzIG9mIGJv
dGggYXBwcm9hY2hlcy4NCj4gDQo+IDIpIERpc2N1c3MgbmV4dCBzdGVwcyBmb3IgdGhlIHVwc3Ry
ZWFtIHNvbHV0aW9uIGluIGFuIHVwY29taW5nIGNvbmZlcmVuY2UNCj4gICAgKGxpa2UgTFBDIG9y
IGVhcmxpZXIgaWYgcG9zc2libGUpIGFuZCB3b3JrIG9uIHVwc3RyZWFtaW5nIGl0Lg0KPiANCj4g
MykgV29yayBvbiBndWVzdCBkZXZpY2UgcGFzc3Rocm91Z2ggYW5kIElPTU1VIHN1cHBvcnQuDQo+
IA0KPiBJIGFtIG9wZW4gdG8gZ3JhZHVhbGx5IHVwc3RyZWFtIHRoaXMgYXMgeW91IG1lbnRpb25l
ZCB3aGVyZSBhcyBhIGZpcnN0DQo+IHN0ZXAgcEtWTSB3b3VsZCBlc3RhYmxpc2ggRE1BIGlzb2xh
dGlvbiB3aXRob3V0IHRyYW5zbGF0aW9uIGZvciBob3N0LA0KPiB0aGF0IHNob3VsZCBiZSBlbm91
Z2ggdG8gaGF2ZSBmdW5jdGlvbmFsIHBLVk0gYW5kIHJ1biBwcm90ZWN0ZWQNCj4gd29ya2xvYWRz
Lg0KDQpEb2VzIHRoYXQgYXBwcm9hY2ggYXNzdW1lIHN0YXJ0aW5nIGZyb20gYSBmdWxsLWZsZWRn
ZWQgU01NVSBkcml2ZXIgDQppbnNpZGUgcEtWTSBvciBkbyB3ZSBzdGlsbCBleHBlY3QgdGhlIGhv
c3QgdG8gZW51bWVyYXRlL2luaXRpYWxpemUNCnRoZSBodyAoYnV0IHNraXAgYW55IHRyYW5zbGF0
aW9uKSBzbyB0aGUgcEtWTSBwYXJ0IGNhbiBmb2N1cyBvbmx5DQpvbiBtYW5hZ2luZyB0cmFuc2xh
dGlvbj8NCg0KSSdtIGN1cmlvdXMgYWJvdXQgdGhlIGJ1cmRlbiBvZiBtYWludGFpbmluZyBhbm90
aGVyIElPTU1VDQpzdWJzeXN0ZW0gdW5kZXIgdGhlIEtWTSBkaXJlY3RvcnkuIEl0J3Mgbm90IGJ1
aWx0IGludG8gdGhlIGhvc3Qga2VybmVsDQppbWFnZSwgYnV0IGhvc3RlZCBpbiB0aGUgc2FtZSBr
ZXJuZWwgcmVwby4gVGhpcyBzZXJpZXMgdHJpZWQgdG8NCnJlZHVjZSB0aGUgZHVwbGljYXRpb24g
dmlhIGlvLXBndGFibGUtYXJtIGJ1dCBzdGlsbCBjb25zaWRlcmFibGUgDQpkdXBsaWNhdGlvbiBl
eGlzdHMgKH4yMDAwTE9DIGluIHBLVk0pLiBUaGUgd291bGQgYmUgdmVyeSBjb25mdXNpbmcNCm1v
dmluZyBmb3J3YXJkIGFuZCBoYXJkIHRvIG1haW50YWluIGUuZy4gZW5zdXJlIGJ1Z3MgZml4ZWQg
aW4NCmJvdGggc2lkZXMuDQoNClRoZSBDUFUgc2lkZSBpcyBhIGRpZmZlcmVudCBzdG9yeS4gaWl1
YyBLVk0tQVJNIGlzIGEgc3BsaXQgZHJpdmVyIG1vZGVsIA0KZnJvbSBkYXkgb25lIGZvciBuVkhF
LiBJdCdzIGtlcHQgZXZlbiBmb3IgVkhFIHdpdGggZGlmZmVyZW5jZSBvbmx5DQpvbiB1c2luZyBo
eXBlcmNhbGwgdnMgdXNpbmcgZGlyZWN0IGZ1bmN0aW9uIGNhbGwuIHBLVk0gaXMgYWRkZWQgDQpp
bmNyZW1lbnRhbGx5IG9uIHRvcCBvZiBuVkhFIGhlbmNlIGl0J3MgbmF0dXJhbCB0byBtYWludGFp
biB0aGUNCiBwS1ZNIGxvZ2ljIGluIHRoZSBrZXJuZWwgcmVwby4gTm8gZHVwbGljYXRpb24uDQoN
CkJ1dCB0aGVyZSBpcyBubyBzdWNoIHRoaW5nIGluIHRoZSBJT01NVSBzaWRlLiBQcm9iYWJseSB3
ZSdkIHdhbnQgdG8NCnRyeSByZXVzaW5nIHRoZSBlbnRpcmUgSU9NTVUgc3ViLXN5c3RlbSBpbiBw
S1ZNIGlmIGl0J3MgYWdyZWVkDQp0byB1c2UgZnVsbC1mbGVkZ2VkIGRyaXZlcnMgaW4gcEtWTS4g
T3IgaWYgY29udGludWluZyB0aGUgc3BsaXQtZHJpdmVyDQptb2RlbCBzaG91bGQgd2UgdHJ5IHNw
bGl0dGluZyB0aGUgZXhpc3RpbmcgZHJpdmVycyBpbnRvIHR3byBwYXJ0cyB0aGVuDQpjb25uZWN0
aW5nIHR3byB0b2dldGhlciB2aWEgZnVuY3Rpb24gY2FsbCBvbiBuYXRpdmUgYW5kIHZpYSBoeXBl
cmNhbGwNCmluIHBLVk0gKHNpbWlsYXIgdG8gaG93IEtWTS1BUk0gZG9lcyk/DQoNClRoYW5rcw0K
S2V2aW4NCg==
