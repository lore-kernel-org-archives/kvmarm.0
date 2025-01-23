Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9420B81F;
	Thu, 23 Jan 2025 08:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620021; cv=fail; b=P9P+lAwgLnl9e4HWAhW3MNfJPXl/L7VXsmqoCuyTY6T7Eu4IIO+A3Y/CwjD52I5latimYfsMxuwghkG9trwn4mGMR682omx1lJiX68W04PLn23+jRp2WtOlU+upZWAH2rUree/oaG22TbQL5/cBoW4+bVYNPsBuZrODYjZ4fuzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620021; c=relaxed/simple;
	bh=ku5M3inoXybdmXPIYzoL4q5+WGeuJRpllVKtSOuKiqQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D/13iVKHKPxaATQWviLV3ikakvy5seQz5SMV89Bry+SUbjr8839HRZYEwnWpbm3u0/H0FyvoWBm4ftdOPiYo277F6cmiKE6UWK8pSw11ykeG5HnqNM591kpwOIsL2m6CQTydrnQH9ccex2s6zpwSzOXQyUD/L7nsuVOeNjPm0ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsB90ZLX; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsB90ZLX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737620020; x=1769156020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ku5M3inoXybdmXPIYzoL4q5+WGeuJRpllVKtSOuKiqQ=;
  b=KsB90ZLXsw0O8Dc8mO06LpFVL5QFEXoZuvffsNmy5aot1GsGnnQHAUZM
   mmqnoDb4B5JajGeQ2HaP3d4eAHFiaSRDz5byUBco4tWX0fBjxENcdA3Y7
   iuMYGFczj6UNVih64pBrZQtvDOWdw499KnSwH3NgAPcvg8qER4m/v+IGt
   QVmDuDzk7OhS7iuteJTAghdfiJFsP6HVKGksLjkVApHAYW6dF/5pF82KP
   1DwDVTksQU4hzAITiuxSG1wV8w46aS4JQeCMqfuuIioniJEyUq/88AHUH
   nM5fjcLkKC3NCjwbpVC2Y95rz144waXG5X992BNSUpXuu9+3JuoA5a/Pr
   A==;
X-CSE-ConnectionGUID: Kn91nRp4R1u0bPGZXg7XMw==
X-CSE-MsgGUID: v9CbIR1hTKigWXTN0hdFSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="25706905"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="25706905"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 00:13:39 -0800
X-CSE-ConnectionGUID: jHrR79zPQzmu+Z5rJLS64A==
X-CSE-MsgGUID: peJ2pLahTAi/pk1X9mGMCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="107935864"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 00:13:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 00:13:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 00:13:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 00:13:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=an6WumaYT65ybs9v23GlMJS3OU59Bwb7A/U+ZZ9Zif4RWT607jMgW9xQMBSWjIef71FNWMurKi9ol7vEF1/yERldFnffF1T1j2YBmJPnXHjDh/WSdZleTyOR3xjD3xozgR+4j63hCqBWvpTzpD91oWJZe/KWKkm61U3sQQ94buAelZSdENjLP1NmZAZJXh6ljIkFV/MyNToTsDaqTslhTg73gw510fllSqoSSj00PLogjuVCvcS5pB2NGQ2SC7vHLpSV3V5givIO4QPdacakBZXuAQ6Gf0H46hdADDHxZV2rjW1VPltkkHmD4M45VoGsAqBkjGjxzdlUJetAdJUe4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ku5M3inoXybdmXPIYzoL4q5+WGeuJRpllVKtSOuKiqQ=;
 b=WmepX0vMWbNGaJTrEAEIKA9oSyLHPbUk6uWw9XuA335dbsSUEku1XjBXIXF/CSTUwKlDjjYV2axiIeWfA/VKLROtsgw5DfTvm7h/pfStWQlIRQ++kTWRgSNPmc+L9eAB134UJXAyltSQCPeN8d3t7UncCoC0o5DWO27GS5/P05lsn9HVAwV79FUp6okoPLVOHnOg3TgRrr5KdF1nPxg+dFzDBbBPbwJieBRSYnl+Q01EpDVXBGmHkWOJo1hdqt4dfIClYg1ZaI719NAkJ07yt50l6cOYasFvSwo0X4TTVIpQFKkeVIiNLZkKu9Br648PmZIab4iwu9LNKj6LvU3zMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5798.namprd11.prod.outlook.com (2603:10b6:303:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Thu, 23 Jan
 2025 08:13:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Thu, 23 Jan 2025
 08:13:34 +0000
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
Thread-Index: AQHbTMDMIzUpKICXy0GU653cUdGA+rLjAh+AgAGRtACAH3kDAIAI5hqAgAwvyuCAANmegIAAwowAgAgiZACAAWB5MA==
Date: Thu, 23 Jan 2025 08:13:34 +0000
Message-ID: <BN9PR11MB52760945FBCF542F77DCF4CA8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca> <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca> <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DQuNn3GoU1vYPV@google.com>
In-Reply-To: <Z5DQuNn3GoU1vYPV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5798:EE_
x-ms-office365-filtering-correlation-id: 283af27b-b5bf-474e-99ef-08dd3b85d513
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K1QvdWltTzlpYWdRNzlIRHFFcGtDbjlJSitQU0ZZaHpGSXN0M1dvRFltRWVh?=
 =?utf-8?B?bWIyVU1EamZhNCt4YlRrK3ZJSU1nd2FkZ1RlTytDMFQ4OS9mKytYY1pTamp6?=
 =?utf-8?B?Q0d0ZmpTMmNmOXp2MzJQdHJVRkhNMXh5YTFqR040ZVd5SU9QMmUxWnhpSGhl?=
 =?utf-8?B?V2F6TlJFRG1mc0xHL1FGVlQyY2MreDN2a2xMcDJlUGdyRUlCajRpc3dBSWxR?=
 =?utf-8?B?MC9FWTNJNFBmK3I5bUFxekgyU21GUW0xSFpxMHhDMGZBOUNpd3pZWVZUdGh6?=
 =?utf-8?B?ek5IQWpOSlpza3hzVlVnNWZ0cVlHOW4xai8wTGtmMlZFM0NLYmVObVdjbDZR?=
 =?utf-8?B?alIzSUcrcDRKZ0l4RXVNWXZKYyt3OXh3SExnNm1nQmZmOFNYbWRmZUQ3N0dk?=
 =?utf-8?B?VXRwTktpSTRvTTZVN3loUFh3NDk3dkNVdFFjYlRsY01NMzBtSWxWVkVYbnZz?=
 =?utf-8?B?cW9LaHdQVWU2VGMrYXhEVzR4MVF0WFhRTTgra0NEbXVQOVVuTGxzOW5uSVNL?=
 =?utf-8?B?cS9sWGsyT3UvNXk0ZjFUaTRKMmVVTUxqQmt4Y1B3ZzFGdGhIOWdYYjBvbERT?=
 =?utf-8?B?T1pXcHAraFREQVF3TG43aUp6ejE4WDBwMnl2WlVydldpa2FuclRjbkdSdXJs?=
 =?utf-8?B?Yklhc2JVWVNudGtLMmVkVXNzM2ZjRXhVUFdpWXlKR0Z4emwyNFRVdE11eHpr?=
 =?utf-8?B?L0VveER2U0hsQ1l1QlVPUEdEU1pIZGFSeitkcWJCZ0JBQmMvUE1XclN2RGFy?=
 =?utf-8?B?c1VMdDMrcE1WV20xRVJMei9iN0ZtakxVblNxTnlQVEhyWHhCRWtHRS8vMWdF?=
 =?utf-8?B?Yy9aVytFMHQ2WCtsaDZYcnh4SHZQRGxWNmQ4S2N4ejJjeitjV2RvMnlxNGlX?=
 =?utf-8?B?a283cWxHUkl6N0ZjQkdWTFA1SERNYURVZThWWXF0MFNoRUNKY1BsTm1KTi8x?=
 =?utf-8?B?ZzhheFNCOE0rYVI3c05NT3B1cE5JS1ZLUGw5SUpHNnRCenNZNlJqek1LUFNW?=
 =?utf-8?B?dlo0dEJKUkdDQWluVkdEMGVmYjk2ZC9qVVBsZUxXcVpndGxBR3BIRE1aK3Y2?=
 =?utf-8?B?NnVqczdJM3JjRHlHb25wZm9hY0tuaktKWmV1bEhyVXVNS3gzRWVxZWRFZlhD?=
 =?utf-8?B?YTBFaGUyZElRZVVzMk43M3NSOTZkOEJ4RCs2STNnLzBHQW9XZWNvZTUyVUE3?=
 =?utf-8?B?RFNnNWxhb0dwQ1dZQlFVWUhVTWJxUW1PWXNMeGVsV25qL3M0WUFacTVpdjhL?=
 =?utf-8?B?QlFnUTBWNDJTVDRNdXl0NWNwMnVhQ095azFsRHZXTTU5aVd4akhIa2VzcnhS?=
 =?utf-8?B?VStpRkxvbnJ0SHFPSUtDaUE4TkJZNzVMWllyRzR6cFY0UlRGMExmT2xzOWtp?=
 =?utf-8?B?RzEvT1MrSW9td0ROMGRsM3haTXFNYkowejRnTVVnYzNYRlAvWXh6cGR6RFBt?=
 =?utf-8?B?WHQ2ZWZLWGl4a1I0UUZLcUpZVzBhazlIa1JVREhZZWErTjFNWjVXTVRVa2pB?=
 =?utf-8?B?UWI2Y1hOMzBuN0xUNW5PUFVvZ1R3ejV3b2VFKzkvWEZPcHF5ZENOTUU2S3M5?=
 =?utf-8?B?OEdpb29wSUZtT0cvZVdoNzgrZXk3YjRPd0tmS3dpeUc2THI5bjlRZENRZjA5?=
 =?utf-8?B?QzlWY1Vlam9UMmovZDh1M3ZWVnIwdEUvRm1wbkxUQVpmZ3BSY0EwMy9JMUE5?=
 =?utf-8?B?SjlBYlVkNGZ2TUdSZUU4YWM1bTV1L0ZSY090WDhJWjY1UEU0SlF5VEZlSWNN?=
 =?utf-8?B?QWRYUGxGVXd2bW5QNmtKellhcG9RMHRGTU04RWFsTDVSdGxiSUR0WG9UOGxE?=
 =?utf-8?B?Vi9mWGgvUHpxT3NaeHVXbVNybzEzZCtFZ2xnczZhcExkSzd0aU9DUUlsakx0?=
 =?utf-8?B?YmZ4ZzVSbDl2WElqM2ZHN1lMSXYyaDNyelVFQkNQR09uNnNHUzZLL2dzV0xR?=
 =?utf-8?Q?tD0c8UKGJUoOo+FdQCEfR0fcFhpLgnxF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGl0dGhUMm1FOUx5cHMyWU9BSzBJZ3dlN3pudXlkM1hEZ0UyRG8zUmpUQk1Z?=
 =?utf-8?B?OEJ4dTNuMmpESmY4czdhcnN6T0RoYVVXd1M0TzBRWjJYdVg3U296NmZaTVNp?=
 =?utf-8?B?a3hhb3RTQmFZcTVRV3llYVc0Ly9SODJMajlDVEpadXc0eUNTT2Rnbm1CSU5X?=
 =?utf-8?B?MkxKUHc3MU5Pb09HRjB2ckl6NWcwSGc0dWJlbHh0SUdYQnVKTVBtaWpBR3Bz?=
 =?utf-8?B?SGROM2dyK25sNmpnbmJvRkZUUVFBb3BRZXAvUnJld0lxdW5SclFsVXA3dUll?=
 =?utf-8?B?U1ZUZUlURGNINDdYZXhPMHlRSERWQ1ViMllSWXVJdHEzenRsV2JsQkMrbjNH?=
 =?utf-8?B?cFd3QVJoS0dPbktQQnE2TXZ6WlNuNllTSGhic3JkR1ptWFN4aXRrYTNEblN5?=
 =?utf-8?B?c0MxMlJ3VGFQY3p0aW1IUGtPczVCNU9FZHQ1OTY0RU5PdExDdklnY29Dd3Jy?=
 =?utf-8?B?VEczMEZGZVFtakdqTGF4ZFp1bEJKa0xYNEx5WlhNbGlFUXV5bGlSblYrV1Zl?=
 =?utf-8?B?YlArd2lEZThTT0gvQmZYZzRIMnFhMUpqUEM0SnhZNSs0czlRNkdlc21MOFlG?=
 =?utf-8?B?WlhCVDY5NEVFOW9vOVNwYUZRNEpOcVRWaTFRQTBhME52VjlBWVk5V2pCbE1E?=
 =?utf-8?B?TWN1cVlhdGhwbnd3TndXcE5ZUXNnT2xZQzB2azFEK3R2YmRqcFpnMklOR1FS?=
 =?utf-8?B?MFRtWFJzSkhyYTlWakRGbSsrZy8xUHdtaWIwRE90V1R3SmVoOHlzT0FwVVVl?=
 =?utf-8?B?Ni9KMFpSK2FQejJhb2xMUHI1UUpmK1RaQmMxYkc2Tnp3QS9aSi94cFF3OU5k?=
 =?utf-8?B?Y1A1Q0NxeW8vRitYK21wNEFSQ3F1bXI0RHZBNkduVHVLTkdVOW5VSmR4ekVj?=
 =?utf-8?B?WVJKZnQxeVRsbTV6L0sxQXlkZWc1eUNUWFQwZjZUMHpxNWN3QlM4Y09FUkZi?=
 =?utf-8?B?blFybnc0aXpXTjQ4WXA5b3VjSHBVL2hmZjdjSWpValRCeXRVbFgvTUdkWnlI?=
 =?utf-8?B?WFFTZ2NtYU1BU2tuOStRbzd2USs1SytObXh4ZXdKOWRjdWF4U1dYR3BnVjBX?=
 =?utf-8?B?aEkzV0xlc3VQNHFnLzNmU1lQWWYzRksyYVZGZnhqeUNiMkEwOWsra2wwVndB?=
 =?utf-8?B?WjlyNFZqbXYyWHRYU2trNDlOeUlDbzNKTU03VVpKRE0wSHdrWDhJTHZZdGZp?=
 =?utf-8?B?V2hhWmxrVlA5T25FOStEdFkyU0wxUEZyUUM5VmluaTBjZWxXL1g1TU5jZ05I?=
 =?utf-8?B?dWt6d2xvMGRjMXlGRVNidXROTnNMTWlnWXhZOW5NOE4rbWl3MThpS01iOTI0?=
 =?utf-8?B?SmE3Qmx0RHVtcGlIYkNGTnVzam5mOU9RZzZsdFVVd3RleWIvOGlxem9MZldY?=
 =?utf-8?B?ZWN2THptaVdEWFhad3dzbk9OQ3I3ejRVU0tCUCszVG4xb1BGQ3lxMDV5UXhE?=
 =?utf-8?B?SGErNGZ3elFVRmFpb09hUW1rUjZrRTNLMmVwUEhrUHNteFpUS1dLdFNIWm9V?=
 =?utf-8?B?QU91blVQT01uSDl2Y0RRdDlZTDV6MHNobFl4dlFOc2RkSzgzT20wOWZweHpE?=
 =?utf-8?B?ZHp5NjNPSWdrL3dGVHlqRi91bWtKajc5UXQrYXRnQ2RZa1hnTER0bmVKYkVQ?=
 =?utf-8?B?VjUrMER3RzQxd21aK01meEFmRXhKeUxRYU9jQmd5blVESk0remtFMStaamRQ?=
 =?utf-8?B?Y2ZxbENVTHYzNGwzT2laRTBTeTlnL290eXNXUTZxSTJYUUlJZlhjZ0pQU3R3?=
 =?utf-8?B?eVJJd1Q5dmtRK1hQaUQ0bkhjbFdsUmRva3hDR2FjMmpjQXFqNjBITUZqdWw5?=
 =?utf-8?B?ZWtMZTFwcHFEK21VdnBmdmR5MnpBeFpLR0hSUW43aCtLaHB2Y2E0L0Rva2lV?=
 =?utf-8?B?c0dxT3hGcGUrRW5qVmovK0VsT1NZU0VmTktUSDFIVWxUcm5DUmRiRVhRd3hU?=
 =?utf-8?B?c2kxczdxMFlWMnhCcUVKeVluZXZMa3RmUkoxVk9UVG83WGRqUWRHeFUvbS9h?=
 =?utf-8?B?ZFQ3YnNFV2hCRlZSR3BaTjM3SUpNSXdjSVAxaEpSRFNXdzdiMnA3emF6eU1I?=
 =?utf-8?B?ZVNUcnlzMU1NUXBZbWJmb2VqWWVBOEVYMGpGQVNlQlBVK1RmRS8vR1E1YVFu?=
 =?utf-8?Q?oR1cVxHbHvt13oYscWgQbXnW9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 283af27b-b5bf-474e-99ef-08dd3b85d513
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 08:13:34.7960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PjHkeOwiknABQRwichJEgIdc1hizRs1/ftDYbFCLWkb2tr8MK1Pgh5eS+JFqfvXqWoGXT9zFLZlNB7iR3DhKtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5798
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgMjIsIDIwMjUgNzowNCBQTQ0KPiANCj4gT24gRnJpLCBKYW4gMTcsIDIw
MjUgYXQgMDY6NTc6MTJBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBK
YXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgSmFudWFy
eSAxNywgMjAyNSAzOjE1IEFNDQo+ID4gPg0KPiA+ID4gT24gVGh1LCBKYW4gMTYsIDIwMjUgYXQg
MDY6Mzk6MzFBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiA+ID4gRnJvbTogTW9z
dGFmYSBTYWxlaCA8c21vc3RhZmFAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gPiBTZW50OiBXZWRuZXNk
YXksIEphbnVhcnkgOCwgMjAyNSA4OjEwIFBNDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBUaHUs
IEphbiAwMiwgMjAyNSBhdCAwNDoxNjoxNFBNIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+ID4gPiA+ID4gPiBPbiBGcmksIERlYyAxMywgMjAyNCBhdCAwNzozOTowNFBNICswMDAwLCBN
b3N0YWZhIFNhbGVoIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBZZWFoLCBTVkEgaXMgdHJpY2t5LCBJ
IGd1ZXNzIGZvciB0aGF0IHdlIHdvdWxkIGhhdmUgdG8gdXNlIG5lc3RpbmcsDQo+ID4gPiA+ID4g
PiA+IGJ1dCB0YmgsIEkgZG9u4oCZdCB0aGluayBpdOKAmXMgYSBkZWFsIGJyZWFrZXIgZm9yIG5v
dy4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBBZ2FpbiwgaXQgZGVwZW5kcyB3aGF0IHlvdXIg
YWN0dWFsIHVzZSBjYXNlIGZvciB0cmFuc2xhdGlvbiBpcyBpbnNpZGUNCj4gPiA+ID4gPiA+IHRo
ZSBob3N0L2d1ZXN0IGVudmlyb25tZW50cy4gSXQgd291bGQgYmUgZ29vZCB0byBjbGVhcmx5IHNw
ZWxsIHRoaXMNCj4gb3V0Li4NCj4gPiA+ID4gPiA+IFRoZXJlIGFyZSBmZXcgZHJpdmVycyB0aGF0
IGRpcmVjdGx5IG1hbnB1bGF0ZSB0aGUgaW9tbXVfZG9tYWlucw0KPiBvZiBhDQo+ID4gPiA+ID4g
PiBkZXZpY2UuIGEgZmV3IGdwdXMsIGF0aDF4IHdpcmVsZXNzLCBzb21lIHRlZ3JhIHN0dWZmLCAi
dmVudXMiLiBXaGljaA0KPiA+ID4gPiA+ID4gb2YgdGhvc2UgYXJlIHlvdSB0YXJnZXR0aW5nPw0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0
aGlzIHBvaW50IGFib3V0IG1hbmlwdWxhdGluZyBkb21haW5zLg0KPiA+ID4gPiA+IEFGQUlLLCBT
VkEgaXMgbm90IHRoYXQgY29tbW9uLCBpbmNsdWRpbmcgbW9iaWxlIHNwYWNlcyBidXQgSSBjYW4g
YmUNCj4gPiA+IHdyb25nLA0KPiA+ID4gPiA+IHRoYXTigJlzIHdoeSBpdOKAmXMgbm90IGEgcHJp
b3JpdHkgaGVyZS4NCj4gPiA+ID4NCj4gPiA+ID4gTmVzdGVkIHRyYW5zbGF0aW9uIGlzIHJlcXVp
cmVkIGJleW9uZCBTVkEuIEEgc2NlbmFyaW8gd2hpY2ggcmVxdWlyZXMNCj4gPiA+ID4gYSB2SU9N
TVUgYW5kIG11bHRpcGxlIGRldmljZSBkb21haW5zIHdpdGhpbiB0aGUgZ3Vlc3Qgd291bGQgbGlr
ZSB0bw0KPiA+ID4gPiBlbWJyYWNlIG5lc3RpbmcuIEVzcGVjaWFsbHkgZm9yIEFSTSB2U01NVSBu
ZXN0aW5nIGlzIGEgbXVzdC4NCj4gDQo+IFdlIGNhbiBzdGlsbCBkbyBwYXJhLXZpcnR1YWxpemF0
aW9uIGZvciBndWVzdHMgdGhlIHNhbWUgd2F5IHdlIGRvIGZvciB0aGUNCj4gaG9zdCBhbmQgdXNl
IGEgc2luZ2xlIHN0YWdlIElPTU1VLg0KDQpzYW1lIHdheSBidXQgYm90aCByZXF1aXJlIGEgbmVz
dGVkIHNldHVwLg0KDQpJbiBjb25jZXB0IHRoZXJlIGFyZSB0d28gbGF5ZXJzIG9mIGFkZHJlc3Mg
dHJhbnNsYXRpb25zOiBHVkEtPkdQQSB2aWENCmd1ZXN0IHBhZ2UgdGFibGUsIGFuZCBHUEEtPkhQ
QSB2aWEgcEtWTSBwYWdlIHRhYmxlLg0KDQpUaGUgZGlmZmVyZW5jZSBiZXR3ZWVuIGhvc3QvZ3Vl
c3QgaXMganVzdCBvbiB0aGUgR1BBIG1hcHBpbmcuIEZvciBob3N0DQppdCdzIDE6MSB3aXRoIGFk
ZGl0aW9uYWwgaGFyZGVuaW5nIGZvciB3aGljaCBwb3J0aW9uIGNhbiBiZSBtYXBwZWQgYW5kDQp3
aGljaCBjYW5ub3QuIEZvciBndWVzdCBpdCdzIG5vbi1pZGVudGljYWwgd2l0aCB0aGUgbWFwcGlu
ZyBlc3RhYmxpc2hlZA0KZnJvbSB0aGUgaG9zdC4NCg0KQSBuZXN0ZWQgdHJhbnNsYXRpb24gbmF0
dXJhbGx5IGZpdHMgdGhhdCBjb25jZXB0dWFsIGxheWVycy4NCg0KVXNpbmcgYSBzaW5nbGUtc3Rh
Z2UgSU9NTVUgbWVhbnMgeW91IG5lZWQgdG8gY29tYmluZSB0d28gbGF5ZXJzDQppbnRvIG9uZSBs
YXllciBpLmUuIEdWQS0+SFBBIGJ5IHJlbW92aW5nIEdQQS4gVGhlbiB5b3UgaGF2ZSB0bw0KcGFy
YXZpcnQgZ3Vlc3QgcGFnZSB0YWJsZSBzbyBldmVyeSBndWVzdCBQVEUgY2hhbmdlIGlzIGludGVy
Y2VwdGVkDQp0byByZXBsYWNlIEdQQSB3aXRoIEhQQS4NCg0KRG9pbmcgc28gY29tcGxldGVseSBr
aWxscyB0aGUgYmVuZWZpdCBvZiBTVkEsIHdoaWNoIGlzIHdoeSBKYXNvbiBzYWlkDQphIG5vLWdv
Lg0KDQo+IA0KPiA+ID4NCj4gPiA+IFJpZ2h0LCBpZiB5b3UgbmVlZCBhbiBpb21tdSBkb21haW4g
aW4gdGhlIGd1ZXN0IHRoZXJlIGFyZSBvbmx5IHRocmVlDQo+ID4gPiBtYWluc3RyZWFtIHdheXMg
dG8gZ2V0IHRoaXMgaW4gTGludXg6DQo+ID4gPiAgMSkgVXNlIHRoZSBETUEgQVBJIGFuZCBoYXZl
IHRoZSBpb21tdSBncm91cCBiZSB0cmFuc2xhdGluZy4gVGhpcyBpcw0KPiA+ID4gICAgIG9wdGlv
bmFsIGluIHRoYXQgdGhlIERNQSBBUEkgdXN1YWxseSBzdXBwb3J0cyBpZGVudGl0eSBhcyBhbiBv
cHRpb24uDQo+ID4gPiAgMikgQSBkcml2ZXIgZGlyZWN0bHkgY2FsbHMgaW9tbXVfcGFnaW5nX2Rv
bWFpbl9hbGxvYygpIGFuZCBtYW51YWxseQ0KPiA+ID4gICAgIGF0dGFjaGVzIGl0IHRvIHNvbWUg
ZGV2aWNlLCBhbmQgZG9lcyBub3QgdXNlIHRoZSBETUEgQVBJLiBNeSBsaXN0DQo+ID4gPiAgICAg
YWJvdmUgb2YgYXRoMXgvZXRjIGFyZSBleGFtcGxlcyBkb2luZyB0aGlzDQo+ID4gPiAgMykgVXNl
IFZGSU8NCj4gPiA+DQo+ID4gPiBNeSByZW1hcmsgdG8gTW9zdGFmYSBpcyB0byBiZSBzcGVjaWZp
Yywgd2hpY2ggb2YgdGhlIGFib3ZlIGRvIHlvdSB3YW50DQo+ID4gPiB0byBkbyBpbiB5b3VyIG1v
YmlsZSBndWVzdCAoYW5kIHdoYXQgZHJpdmVyIGV4YWN0bHkgaWYgIzIpIGFuZCB3aHkuDQo+ID4g
Pg0KPiA+ID4gVGhpcyB3aWxsIGhlbHAgaW5mb3JtIHdoYXQgdGhlIHBlcmZvcm1hbmNlIHByb2Zp
bGUgbG9va3MgbGlrZSBhbmQNCj4gPiA+IGd1aWRlIGlmIG5lc3RpbmcvcGFyYSB2aXJ0IGlzIGFw
cHJvcHJpYXRlLg0KPiA+DQo+IA0KPiBBRkFJSywgdGhlIG1vc3QgY29tbW9uIHVzZSBjYXNlcyB3
b3VsZCBiZToNCj4gLSBEZXZpY2VzIHVzaW5nIERNQSBBUEkgYmVjYXVzZSBpdCByZXF1aXJlcyBh
IGxvdCBvZiBtZW1vcnkgdG8gYmUNCj4gICBjb250aWd1b3VzIGluIElPVkEsIHdoaWNoIGlzIGhh
cmQgdG8gZG8gd2l0aCBpZGVudGl0eQ0KPiAtIERldmljZXMgd2l0aCBzZWN1cml0eSByZXF1aXJl
bWVudHMvY29uc3RyYWludHMgdG8gYmUgaXNvbGF0ZWQgZnJvbSB0aGUNCj4gICByZXN0IG9mIHRo
ZSBzeXN0ZW0sIGFsc28gdXNpbmcgRE1BIEFQSQ0KPiAtIFZGSU8gaXMgc29tZXRoaW5nIHdlIGFy
ZSBsb29raW5nIGF0IHRoZSBtb21lbnQgYW5kIGhhdmUgcHJvdG90eXBlZCB3aXRoDQo+ICAgcEtW
TSwgYW5kIGl0IHNob3VsZCBiZSBzdXBwb3J0ZWQgc29vbiBpbiBBbmRyb2lkIChvbmx5IGZvciBw
bGF0Zm9ybQ0KPiAgIGRldmljZXMgZm9yIG5vdykNCg0Kd2hhdCByZWFsbHkgbWF0dGVycyBpcyB0
aGUgZnJlcXVlbmN5IG9mIG1hcC91bm1hcC4NCg0KPiANCj4gPiBZZWFoIHRoYXQgcGFydCB3b3Vs
ZCBiZSBjcml0aWNhbCB0byBoZWxwIGRlY2lkZSB3aGljaCByb3V0ZSB0byBwdXJzdWUNCj4gPiBm
aXJzdC4gRXZlbiB3aGVuIGFsbCBvcHRpb25zIG1pZ2h0IGJlIHJlcXVpcmVkIGluIHRoZSBlbmQg
d2hlbiBwS1ZNDQo+ID4gaXMgc2NhbGVkIHRvIG1vcmUgc2NlbmFyaW9zLCBhcyB5b3UgbWVudGlv
bmVkIGluIGFub3RoZXIgbWFpbCwgYSBzdGFnaW5nDQo+ID4gYXBwcm9hY2ggd291bGQgYmUgbXVj
aCBwcmVmZXJyYWJsZSB0byBldm9sdmUuDQo+IA0KPiBJIGFncmVlIHRoYXQgd291bGQgcHJvYmFi
bHkgYmUgdGhlIGNhc2UuIEkgd2lsbCB3b3JrIG9uIG1vcmUgc3RhZ2luZw0KPiBhcHByb2FjaCBm
b3IgdjMsIG1vc3RseSB3aXRob3V0IHRoZSBwdiBwYXJ0IGFzIEphc29uIHN1Z2dlc3RlZC4NCj4g
DQo+ID4NCj4gPiBUaGUgcHJvcy9jb25zIGJldHdlZW4gbmVzdGluZy9wYXJhIHZpcnQgaXMgY2xl
YXIgLSBtb3JlIHN0YXRpYyB0aGUNCj4gPiBtYXBwaW5nIGlzLCBtb3JlIGdhaW4gZnJvbSB0aGUg
cGFyYSBhcHByb2FjaCBkdWUgdG8gbGVzcyBwYWdpbmcNCj4gPiB3YWxraW5nIGFuZCBzbWFsbGVy
IHRsYiBmb290cHJpbnQsIHdoaWxlIHZpY2UgdmVyc2EgbmVzdGluZyBwZXJmb3Jtcw0KPiA+IG11
Y2ggYmV0dGVyIGJ5IGF2b2lkaW5nIGZyZXF1ZW50IHBhcmEgY2FsbHMgb24gcGFnZSB0YWJsZSBt
Z210LiDwn5iKDQo+IA0KPiBJIGFtIGFsc28gd29ya2luZyB0byBnZXQgdGhlIG51bWJlcnMgZm9y
IGJvdGggY2FzZXMgc28gd2Uga25vdw0KPiB0aGUgb3JkZXIgb2YgbWFnbml0dWRlIG9mIGVhY2gg
Y2FzZSwgYXMgSSBndWVzcyBpdCB3b24ndCBiZSBhcyBjbGVhcg0KPiBmb3IgbGFyZ2Ugc3lzdGVt
cyB3aXRoIG1hbnkgRE1BIGluaXRpYXRvcnMgd2hhdCBhcHByb2FjaCBpcyBiZXN0Lg0KPiANCj4g
DQoNClRoYXQnZCBiZSBncmVhdCENCg==
