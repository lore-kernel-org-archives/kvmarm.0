Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4352644C50B;
	Tue, 15 Sep 2026 07:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789456448; cv=fail; b=lGVj+AbqxXVkc20QGseftcR6GGkaLobqQjvO7qCp01udgbzTv92jpETGNqJETBR/ZaYXdVHtsk51YkwoI5ugU6JloSPGcDIgiOSe3GA+zHTmn/hMNF6yP0zBDcixrIfyW+xZzgJKzrTphVzvbSh1rRtbKap+L4d6E8q0TgdRo98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789456448; c=relaxed/simple;
	bh=8+eZ/YcGjovkIDASQZhIV6LCWucQifmNex0NP1WaIOU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ceX+XcM+tntJ0Vx9639epNVVZUEgbrHvoVOg5+IC+MubOQATdiB43Z0gFpep0yDpnP9BXyEfGz3g8g8YzitBiTVw/MiSIfyBhOkmN6AdiA8dGyl2tP1Rc/i2fBhzk+1/AU5zl8dojgMA6Bkdx+Vhrizun0dClXZ0Xc2ELXOykyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLrOvCWB; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLrOvCWB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789456445; x=1820992445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8+eZ/YcGjovkIDASQZhIV6LCWucQifmNex0NP1WaIOU=;
  b=jLrOvCWBML/uWMWe2CDjaYo9wbf/J3yYhDvQYUKptWyHNWAhhKXqiTsB
   i7+JffeUFcRKgolAVKe02G3r1oKUZEnspeZMiBWoaZcl28j9XwXz4x0S9
   mQnXQ7PXlH8tA57Wgo2iSPjlf7Gb5tMfifXKM/bmv3zYzwAzvg77WlO5A
   /SnR40kBjYYqnqblAnSp4GECgvaJglpJlLS3xz/3HzvJ5tyaiSiOvSPEp
   4nE974eT+7NXWbCf34bCxUDDx8GNpKIp0gTCg6lnQ8blQB1MNW0kdi/5k
   3Dz/OftdGoXul5k7V63qUipeZmdq7QAr9cdFNDKkiWAIqL23qvuKTMPJ9
   A==;
X-CSE-ConnectionGUID: S6ok09eCQF2I+4f8GZQaIw==
X-CSE-MsgGUID: wTVlTcyXQgSsBW664I5luw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90017515"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90017515"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 00:13:53 -0700
X-CSE-ConnectionGUID: ZpkBgf0MRFuxtSRCvuPYxQ==
X-CSE-MsgGUID: VawudWrPSFSeU3qtrKcjPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="1265136"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 00:13:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 00:13:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 15 Sep 2026 00:13:52 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 00:13:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hfgn/vWMZCPvxPzDDO/OEdoqfko6/oEapKDLKXCEABgkp7kZOWwfqmo7lz76Vfd6AyjMqJy0mqw6kLz5ns80cwrgf/+W2Xq6AMte80nZRprTnjpQDvrHuKA1C0lu6/IY2fCiFD5xunUN68mLD5kbPD4WYl0+6Kig0pIcfrnU15i0Qyb4srJfr8V8EsNsSlnfEa2KNm+8Bd9ojXtwyD5OSVpWNNQN2+K+Ht9f9zPCdqPQ+uxJ0iYNF95lWxe9KJZK628E62zh1g6TiUV6JDZlTSOeXngdOdRA0GW5/ldp3To7epPEB4f3siSp/XojLQ5I7Q+gKnXlTNxXnxQrdbNA0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbNOasXWbzPkkqmxbT65HMNUahAEOPSbzU0f+llInqk=;
 b=Ch269PDuufUL4PCeQFLxPTMDcHRPwBk4GxLaWX8ql2X6WcIwYPZty1Dlu6eOmaBpJv3WsiQT0tnqNtWGm4NV8TPmh6OOQgevJGNvfhDwF2gd/w52dDLLX2hLxSZ/FpVcgYDNbQ6Xvm6vKJrEKnnYkmN2aZU/gCw/JJLmy0gdJyraS73O9x7xMLTPzDzhEBpwYcuE9uFwvf5KYwEmmUb7ibJALN/PhISxntMbaOyaEdAcw1V2ndOW0PL1AP28zWJr7/Wd+7o68pjqiV0eUR/Joz2J519Y82YnNa/iRYacMTYD3JWUaETqtFaKIxxPZGXal7zBW7+k398cy/3qdUOv4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by IA1PR11MB6539.namprd11.prod.outlook.com (2603:10b6:208:3a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 07:13:48 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%4]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 07:13:48 +0000
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
Thread-Index: AQHdN/EwiLvbaU+6lE2MX0oxJV5il7a5dWsAgAAN2ICAAErrgIABNM4AgAA3CgCAABBnAIAAON+AgAB6EYCAAGKGgIAAwE4AgAXLI4CAADRDAIAC9yOAgAAr2QCAAS/H0IAAYpMAgAdUwAA=
Date: Tue, 15 Sep 2026 07:13:48 +0000
Message-ID: <CO1PR11MB4835FF972283C09D7D683DAE8CBA2@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <yq5aik4nztdt.fsf@kernel.org> <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca> <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca> <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
 <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260910124632.GB4083318@ziepe.ca>
In-Reply-To: <20260910124632.GB4083318@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|IA1PR11MB6539:EE_
x-ms-office365-filtering-correlation-id: 1ab2c4d4-4d77-4d86-9b2f-08df12f8e358
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|38070700021|56012099006|4143699003|5023799004|6133799003|11063799006|18002099003|22082099003|10067099003;
x-microsoft-antispam-message-info: jW9RvOIAfKRESQuSIfKSVLX7FiyXKUwD17CzdvUAT3UhrzEz9Rx+XLmltelOClF7/1t7HH4U9b63PisfMepEOTTmuQ6r5IL1PwrBFEx9QKB2R3kKxUe1D+l8mvyi0mZIifoROoZ6njLzjUs4GFksGN/+S8MGBKCSpygKi6ml0zZlbF+/XRUbj86MtGAsqj6BaunfVIjhC4BG5zudNpjrAj0HdI3qQbSY3OiZHRBohlCXhiBun1K/NNxxSw7YTo3ntgqAk1Vw5DdBwJ17pdw0/mxydRHWzYmhmTt84jL5cZKOn2s8cJ0pSNpII9rMgdVQB1B04HWDPZDyMZ608+b8X0BSdcH1TyTjuolEz981kxdVZYSa0UNszGjHUJZoKHSFSjHmz/gSrFUt/RABVX+PBSi9SIStkYBufmow+HXSExvZ79858gWMSJgQTGRoBVe5MdVs1wbLIy+yO4yBcvTsHbd07qskCSV5l110/SkprDZYx/WFSqAqUfQzRv6+WFtSNh6zCVY1y8yciZuZkTpGf+OBSt8aVmZWMJrLilNz1bO+7pTgjXnGHPO9sTY3T/cAGJNU6dMeFGjA9YGOnN7OHHwNMy1IW7Fd+j1Mq9OiZZjVdQaiCqJZEW9G0i3YgMsjn+WEyXL+jy7PSr6jnKqOyagDtK0RjYUjvQ9wkyGpK1jbjbqYOYCp7+hePCZFbtMEs38f/Hs/L5Xt0ZciIVb6Z4Euq8/Kq3EI9uB2+pwVog4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(38070700021)(56012099006)(4143699003)(5023799004)(6133799003)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OvMLBsY/LsoyS0XRUHvdhURXJuQAUbXLVivyUQ9osXS9C7XL8TQQufva+sgR?=
 =?us-ascii?Q?2ifAHv1V5bZsgrbpzIEujHgEWv/uwomRa8yOWqMlUjvhUMaWYEvap+xxR1jM?=
 =?us-ascii?Q?yC7WHx9ljh1lZzpcad9yVNq44TVCYNI9kkwMtWDs+OVmu3MUm7s1ZqSPxuUq?=
 =?us-ascii?Q?FdoWZSttWLT2Ne4i9FB7yxXfsMr3SzVKLjfPwqV8fNiaxBKqPpgPJ5obLArp?=
 =?us-ascii?Q?egHqeIKxc5xeTvLs6vkyGwe29oXg80dsTl/xorCclO7ejoO+nQCObftDbkOD?=
 =?us-ascii?Q?Ah/bPejjJP79BqaFkwfpMUaxEBI6oKDHWCBLRroZ56lBqozSwx8TxRDpdTzs?=
 =?us-ascii?Q?+uEvxJQOg6AcOG8pZtDSY8nhbgByjH07WLfBvt2vzlcnvu7IwDOBV52by+yJ?=
 =?us-ascii?Q?NFP0MEIIzAIJp9FX6r1R1TN4nGAhbgqWBRD+1eggdOXuwFT83v/IFJYms7Hb?=
 =?us-ascii?Q?gjxv/hnqXxFdV+VBR73xWv+A716r1WGIJQvRIlQ3djG7xpoUn2Pw51jOPFzD?=
 =?us-ascii?Q?2qGNTbv8HVkE6wOrzMX+VlDNRKpAm/x2saw/QmK4tCwMeBRUsPQrGIsOgD9z?=
 =?us-ascii?Q?rEkkdD4G8KqyqMjfHdEneh92phwu8OtnhitZJsYsj8TCKl+nkjej5x0s1N4V?=
 =?us-ascii?Q?UqZA8HG6arTKa/JsNaMUcm1BfJeL8vyL3NRHShY/vta+J02hW8Vylin5nyCj?=
 =?us-ascii?Q?YEthfysAO8IMnMRft4EElbQ1JNco8cMGgPjJm/SmgHrJSq0bCtMzrg8pyllu?=
 =?us-ascii?Q?POfY0ND/Pa3U3tktO8xsYivWgnCzOl7e8c8/pKi/A5EO5m4+mASq2b2nR7b8?=
 =?us-ascii?Q?jnKj629bny4lh8FAXwymSFH0AYwIJHN/OTEZhbdI7NQhjPUxFulUvSPQglmP?=
 =?us-ascii?Q?ZAAjiYf38gjjcoOLL22Y0XZvr6rFIDgNoECPqV4CNlStfzYSjPr5zS7i6fM9?=
 =?us-ascii?Q?IFJ8DNrSEP6lr8Zq7Xlfj6qZUluYGIgsJBwgK5IETWntwAWtVjB8y43oEY5W?=
 =?us-ascii?Q?fGOtnSXdmKwxzyz2jwbbVjeoYVoYpKOJwZwSn5Lm81bdTVZ8FZCvVCfJr7/3?=
 =?us-ascii?Q?nrriUVktZ8u8d8MozRIR9uLE51+/Bsa4KZ/FmnSh5mhn8BLjmM/OHWwGdZux?=
 =?us-ascii?Q?6LBiJuEIJrAXpDJNbo/cr4MRm/uW/6xWzATq2DTVmFN0EygAi5Fa99TXuRAP?=
 =?us-ascii?Q?r9cR1hcMNONpKXtLs2B5cecxEes1t16+ox5C0G8bS3VuMfem1GefYAxnh+Nk?=
 =?us-ascii?Q?OwB15YYSjveJf/ssPOKFFIVcF5H2a53jsG/JeKQj7FPDLgaZ8yRG3v2uhHmU?=
 =?us-ascii?Q?Y3pqpBzu2Ol/+uiqYK2uR7d/kyEDOSXjVFPXQWpFweOcPKLZDveAti1mDDVJ?=
 =?us-ascii?Q?nQNx+oEytql2KdQ9KseWmsEOuYlxhTCj5ka2FHDZDacnielwh3z7CpLZYB8v?=
 =?us-ascii?Q?35oa7BBw9Xsy+qYOJFxwskDMSxOFIDh+oEnIjn4qOEmgInpKb+9eMgWTA78y?=
 =?us-ascii?Q?to0kzirImgH6UXC3SDq4j6Jg5eJI4KtQ1noXSgifOchOCPHVBjvMLARjIhgJ?=
 =?us-ascii?Q?ag8ONFUS8Gumtxq+kIDp2O55M3lWPdr7/Ekjj2ewg6abXCGFkIIL54khsUG5?=
 =?us-ascii?Q?JlPl1tQH/Cm0VC7DTKXjWtgNyRJHjtLrzSCVFRbJjnOnxt5ljbYSHssouQmQ?=
 =?us-ascii?Q?BSbkyKbO2Qt7NL1aykJ8FpNGHt4CHvKC5pxTARADG5B+Zp3jh/YXUWonZvhi?=
 =?us-ascii?Q?yDcJjYhCnA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QYWppZFPlArYJn9+M5ibNha+GPBsG9lx7ABlNUgcAccfIBkc7G868/SxHtAWOZ2O2vug+trhAAMJehwX0AyGte5ZGtEelROTEKR8GbcDHOFyshaHFC5cRbnv07PNcHbmxiBPnGdX1XY4zP9P4ni3lzSn0hBZPVhnLlEhvAncHqrQX5nAogeQQyM+APV+hspOkLz5B8Uc00ojVw1O/+ti4iyeD9vF3gIRD1V3DqA9z0MFFKZhtYKwgPgzeR4wGAUxLwChfZTRNQ6oeAXM/ze/ouNbKQ3GMrartIIvjDXAekzzm6uusIarVaCbMDvJ7mJuKjVE14VFLOysOEdKHFwq4A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab2c4d4-4d77-4d86-9b2f-08df12f8e358
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2026 07:13:48.5267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/V80wFltYLe+yoAirVFo72m5XQhdi3bm/2FCtXobPzAJI6NJiIPN6fEJi2rO55iNOd7KjEx/7h+TeE/F4ginw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6539
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, September 10, 2026 8:47 PM
>=20
> On Thu, Sep 10, 2026 at 09:52:12AM +0000, Tian, Kevin wrote:
> > > The mmio is owned by vfio, there should be a handshake in VFIO to
> > > remove mmio when it becomes private, otherwise I don't think we need
> > > to do anything more?
> >
> > for TDX a callback in VFIO is invoked to revoke the dmabuf.
> >
> > btw I didn't see any dmabuf related in this series (even in a hackish
> > way as Yilun sent out last year). Is it not required by CCA or just
> > skipped now waiting for the framework to be settled?
>=20
> I think just one step at a time :\ I think CCA needs it as well, you
> also cannot safely leave private MMIO floating around the host
> userspace on CCA.

Good to know

>=20
> > So viommu will become the abstraction point for tsm operations and
> > directly talks to the tsm driver instead of going through the merged
> > tsm_ops (bind/unbind/guest_req).
>=20
> More precisely for what was being called the TDI - ie it is the
> abstraction point for the host side of a guest virtual PCI device.
>=20
> iommufd vdevice already represents this, so we use it again.
>=20
> > currently what tsm_ops provides additionally is more about synchronizat=
ion
> > with connect/disconnect, otherwise just calls into underlying tsm drive=
r. As
> > long as viommu creation holds a reference to tsm then disconnection is
> > blocked then it's safe.
>=20
> Yes, this already has to be true or our lifecylce model is
> nonsense. Once the iommufd creates the vdevice the guest is running
> and we cannot disconnect it without unplugging it from the guest. Thus
> the locking can rely on that. Within an iommufd ioctl context the vdev
> and underlying connection must be stable.

btw looks a related suggestion is having the tsm driver (arm-cca-host
here) implement the viommu ops while leaving the original smmu driver
largely intact, and "obtain the viommu through tsm_ops not through
iommu_ops".

It's not super clear to me about the implication behind after reading
related discussions and what the "obtain" part means.=20

Could you help elaborate this part?

The old way is kind of:

vdevice_tsm_ops -> tsm_ops -> tsm driver -> iommu driver

then it will become:

viommu_ops (tsm related) -> tsm_driver

where tsm driver will fully handle tsm related viommu_ops?

>=20
> > and IOMMU_VDEVICE_TSM_BIND will be removed.
>=20
> Replaced, the same logical operations should flow through the viommu
> command ioctl
>=20
> > Seems originally this series
> > does SMC_RMI_VDEV_CREATE and SMC_RMI_VDEV_LOCK both in tsm
> > bind op. Then the proposal is moving them all to vdevice creation time =
so
> > no separate bind step is required.
>=20
> Hmm, lock still should be guest visible on CCA, and the device has to
> start up in the guest as TDISP unlocked. I'm not 100% on the RMI side
> of the flow, but this does not look right.
>=20
> VDEV create should be done before the realm is started. We need this
> setup right because Linux VM is going to validate the vdev during boot
> if it is affiliated to a vSMMU. lock should be done only when
> requested by the guest. The guest must start with a normal unlocked
> T=3D0 PCI device.

Okay then this part is aligned cross all vendors. Thanks for clarification!

>=20
> > Does it mean that ARM CCA is essentially an early-bind model i.e. the T=
DI
> > starts in locked state from guest p.o.v.?
>=20
> No
>=20
> > but https://lore.kernel.org/all/yq5aecfbzjyk.fsf@kernel.org/ seems to
> indicate
> > that guest_req() still handles the bind request from the guest:
> >
> > "
> > - cca_tsm_guest_req() now handles TSM_REQ_SET_TDI_STATE requests for
> >    the unlocked, locked, and running states.
> > "
>=20
> Right the guest side request to lock should come that way.
>=20
> >
> > a bit confusing, but maybe due to stale info cited from different timin=
g...
> >
> > for TDX we're currently pursuing a late-bind model (i.e. TDI starts in =
shared
> > state in guest), so a separate bind interface is still necessary. We co=
uld look
> > at whether it should be an explicit @bind viommu op or carried by
> > @guest_req (say, if most preparation works can be moved to vdevice
> creation).
>=20
> It should go over the viommu command ioctl. It looked like there was
> alway some iommu specific format to the command in the tsm version of
> this, so that is the appropriate way.
>=20
> > btw per past discussions VFIO should block some operations (reset, etc.=
)
> > while a TDI is locked. Do we expect a callback into VFIO to notify the =
locked
> > state, or require VFIO's own interface to place a cdev into a special s=
tate
> > which prevents sensitive operations even before binding it to iommufd
> > (and allow creating TDI vdevice only on such idevice)?
>=20
> At a minimum I think we have to synchronize with vfio, somehow, that
> when the device enforces its private MMIO so it can unmap it. Thay may
> be an argument we need a few standard viommu ops so the core code can
> capture lock/unlocks and do this prep work. Or maybe a special cdev
> state is simpler.
>=20
> This should be figured out before any uapi is settled.

Agree

>=20
> I don't know about reset, that sounds like something the pci core
> should deal with?
>=20

yes the pci core sounds a better place to handle it.

btw I held the impression of blocked operations from past discussion [1].
Initial attempt tried to proactively unbind the TDI upon any operations=20
which may transit the TDI to the ERROR state. Then the suggestion at
the moment was:

" But now the suggestion is never let VFIO do unbind, instead VFIO
should block these operations when device is bound. "

[1] https://lore.kernel.org/all/aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050/
