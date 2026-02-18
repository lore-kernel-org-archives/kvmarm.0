Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7894923909C
	for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771435035; cv=fail; b=NzGXWxNBlm+LDtiZq1Z4BY7Dqyy2AectS3uCXed+spd4udbaYKWt2Fvuiz0ODG4Gn0C+pj+f5xtuUaJtCPgK3vgfnZeDVbyNE2lFKdYySlnQYfyXoJCa3RcgYa7WwjYyy0G65VEIubZMW6pWubWSQ6C+fIO/Pyzg9lZMfXSb8lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771435035; c=relaxed/simple;
	bh=dm6dO4W6rYR554ZTfOcsA1jecHtyLV+Y0yGyHj4KbSU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sVEI7YsqJnRrpTJxCPPlQo3iKUCPanHdetU0XpkBjxz/pnnLfCb9za79QloX7uLsQToT+S2J23bgdDw+6dMrvijpPmEXq1XXJewSdkwOuxdd8SfEITOc1gbYwwKbMsr0sNuktoI5D77YsTJVspVlP2IizCvwEzfuW9QJMh5tskk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+N58ZDj; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+N58ZDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771435033; x=1802971033;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dm6dO4W6rYR554ZTfOcsA1jecHtyLV+Y0yGyHj4KbSU=;
  b=e+N58ZDjJIzRps13rPI9QpulcTa5pFRkl/ig0FK+BzCdt61I6Ki3f7gs
   f6V1XmkAF7jBHK/8fJP9bVN6+nNPcd/ADypSE15q6SwhwReDPVsKM8iSR
   ca6Nu7yHD+KSiaaNCr2g0nt1jz7GsivK+5Vk3MoDJKX47PZ4o6GAs+mIQ
   OU3rwQRp3o01rOxz6rHw/87p7t+a4gS7MCIFdgiOZ9aZ8ApOH1Uq8A6+E
   naUZNEDhVjuGsbRKoJ+Bk31YobejxIV16gXR+DEeUPVP3pRCdSNeWjNNP
   tlBDnKGoulAjsqEoSIXUiXl2lD2yERYL8NQfVCx1QamNsitazJCBLK8yk
   A==;
X-CSE-ConnectionGUID: NhH7fm76S9i8H0NBnQ79eQ==
X-CSE-MsgGUID: +yeku4IRSQWvIPYiU0FqHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="90100482"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="90100482"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 09:17:12 -0800
X-CSE-ConnectionGUID: ImtdXErQRySg4S/AoIhIUA==
X-CSE-MsgGUID: NCyk5ErtRRyU0Dx7mGX6vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="251943371"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 09:17:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 09:17:11 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 09:17:11 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 09:17:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bH3Zd0rE6zWmJmsObjV0nbszXlt4AVkztdGfugamMLVdppI7Z3bC6mt8lospZI+tsAynFP8VgzDrskBd9oGMCe3vGZvc0O3x3rYbcVdebuZ3t0fWtNF7dZ5vA4DQDq8EDkCEs0jvImZ4pyWxYyF5lRfzi6D0PgiIu0938GY6DCdt7NsWftkAXHkbttDFm+QMUky8ULekLN05Jzhh/af3mrW9ggsrwNXb3HSnvQFl5ag9sj6It88Rj7gZo8mgisPptb4qICo+4Q4MOnFqOPCgK9fs/Y7g2tWhSUm/Ka+ULdzV2FmPHgkV1MvFhotZv9AdWI7B73eL5lhZHp80bzrwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjhpVNC/LZAZ/Ec5MyM5RSRzEVKKCmakbswQKqAC8B0=;
 b=tWSbmgK9W2JPp2i8RnYjb7Fmp4ObrT+Ma/kY+z5QNHTqNkbkC30zL36ENSbeEY/oXCMqF6jVb8I+TfspnGoPIkBuZ41BzTkUeDEaBmt+IA1FoWhciX3jIZfa2y9bW/JtgYqEOWkL6dMBlJWDmcV28R/1GaLKDhkUGj7VylPj6AOclH0guthyqkjgM/DYvt/WwiHb5G/0wWOM3Rdzdkp7JISlWU937i7ydGHGY6kQuNLjjS8mqO6f/L0KnGA8VmWROtm7w25trk2PlXLiQpoqCQ2lH1BR1CX8hCdAv1kBH8wiSztO3VHLp8An5mzM7ehVHhdyyNvGlv9NDDMs7vWHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5183.namprd11.prod.outlook.com (2603:10b6:a03:2d9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 17:17:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 17:17:09 +0000
Message-ID: <f8c30b58-0a53-46f9-8838-e7f03a42b174@intel.com>
Date: Wed, 18 Feb 2026 09:17:03 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/41] arm_mpam: resctrl: Add support for 'MB' resource
To: Ben Horgan <ben.horgan@arm.com>, Zeng Heng <zengheng4@huawei.com>,
	<james.morse@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <kobak@nvidia.com>,
	<lcherian@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <peternewman@google.com>,
	<punit.agrawal@oss.qualcomm.com>, <quic_jiles@quicinc.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-27-ben.horgan@arm.com>
 <20260205165018.0000089c@huawei.com>
 <f6f865bc-319c-8944-9989-4fd83a59d4b8@huawei.com>
 <61684bd8-8156-4fe1-8033-eaa12c6d3437@arm.com>
 <1acf06d1-08af-4b05-82e7-655c8ef7cf0e@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <1acf06d1-08af-4b05-82e7-655c8ef7cf0e@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:303:86::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5183:EE_
X-MS-Office365-Filtering-Correlation-Id: cf1da59e-37b0-49d5-edf5-08de6f118c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WC92ancxLzd4MnMvWkcxbHhTVnIyOFNQeTEwRisralduYm80SXREQUZQMGt3?=
 =?utf-8?B?MFc5MUM1YmRsSkxGSFFyOVlTZGFMYmc5WFRQREpvK2FYbVJBUDVockloWEZE?=
 =?utf-8?B?VFhMd1o4WGdIWmpXbGxDcG9xMm9LV0daLzBVZGF3blg5NmFrMk1nVGlCR2Vi?=
 =?utf-8?B?SGZMM1NjcXNaWlo1SHlzS0Zsb3dRbkw0Q3FJVU1rdkphTGZrQkgxbG9tMEpJ?=
 =?utf-8?B?YU4xS1cyeGNuYS9IdkxxRjIwanRkVzkzRGFJN05VQWl1QUJWTWRvNkFLWlRB?=
 =?utf-8?B?OVlxQmFJU0hDaU5NZkZxbXBhWVNnWkxXNXJ4eFM4eDAwRVVuNGk1ci9zWEJo?=
 =?utf-8?B?aW5MblpXYytYcEhzNHpabEcwWFFIbFZ4VUNUV2N1eHFTa3BQZlEzam4vcm5v?=
 =?utf-8?B?V2ozYkRVQ2JEaHpNQWRZaVJaYzJIc0llM0V2WTdVN2hQcEFZR1hKZlNYYk9t?=
 =?utf-8?B?TFNYUk5hdUlRbUJhY1VmZXJPdk1lWTJ6L3hFdVRjQ2pLYUpyT1V1TnpSL1Fo?=
 =?utf-8?B?dUdOWCt2WGdMV0psK0R6TTJPL01JaVlwd0N2TUlmZlJTOUtrSnBrVldhckNo?=
 =?utf-8?B?ZS9WeXkzQWRlOFdwV0QzTENRYWdWdFNzVm5ZSUVBQmdkRE92VWxCa2lzS0JR?=
 =?utf-8?B?UmNjN2E1dUJNM0puQVloR0RWNDlUQzZjM0tmK2RsNGs5Vmx4c0QxZnIyeTFN?=
 =?utf-8?B?eWlBY01CbGJYUk83dTh3ajQvWkx5UTZMbDVCekhRejFLc0lhT3RtbnJKRS9P?=
 =?utf-8?B?UWtZaWJ6RGZUYjRDMVlYK01SNFZ6VWNta1YrOFZPSnNRRlVHZkgyaTE4UDQ5?=
 =?utf-8?B?bW5UNXUrUU9qNVFyWkZXOGdiUE9KZ0prVVRhUGN3bTVqRHBMTFBCbUhjQUVi?=
 =?utf-8?B?bjBvWjFkNGI2enFCdlJ5bmlGOWVzWEpiTlZ2eTVMeVdTWHpvUG9aUERIRGpm?=
 =?utf-8?B?VVJEQXZ6WmdNYkRoQjVQYzYzZlBNR21lcDJ6dm11QW9NVmpUamFsTlY1TnIz?=
 =?utf-8?B?dVhvb2k5U2ozT1lEUnR2WHBWUGFUKytxNDR5SVg2aW1peXFGZGtDRUg0ODF6?=
 =?utf-8?B?YXAwamZocTNVYW4xcWlINUlvcHVXK3I1c04rV2NnUThqditQbFg5aXVUaWZM?=
 =?utf-8?B?NWZYaHEySGhwc21qSXdyY0xYQzZlUUIzUUt5MVk1aDVIeFo4WlZ3aWZnSWVN?=
 =?utf-8?B?RWlublhneU5iRnNteDY3VE1JaXo4MGtjWkwrNDNENHJKbW9rd3FicVhhczNI?=
 =?utf-8?B?VFhNN3lqYmcvNEdNOVhubVB4QzBHaFV2UnQ3TU5MS0tMbkVLN21JMXpnbkJx?=
 =?utf-8?B?TTE1RGxCYURzWGVjNElGVDQ5YnJvWERCdGhxdFIrakFWaU8zNzVnaUl5bWpw?=
 =?utf-8?B?NFFteXE3T3k2YW5UN3FmOWFITzdzSGp4bXN6N1c4Mm5NK3dpVFhhRGdnY2w1?=
 =?utf-8?B?ZHJJSW15ZmNWbDhyV3pyQ2w5dTNMQWxMaDJYS2J4Mm54L0JFaGlSYno5bG9I?=
 =?utf-8?B?SHhjdzc5QlZHMDQzMk9sc2lRbTllcjc3aE1JREJnNGtIdEgvb21JdjJlVEFC?=
 =?utf-8?B?VWJHYmVLR0hIdm9HTlA2NVVhcmsvQndBMC9Nb2NVWGZjWnd6YkZNZmN3U3Js?=
 =?utf-8?B?SWpZL1RDSkxRSVoraGhadTUyZng1MElsU1c5V01TMlo0N3FGL0pMcWVyaW9H?=
 =?utf-8?B?V2diNU01czcybjJRVVdkZHdiRFNlNHViQTdaV3krR0cwcFF4dzR5d3h4Mkh4?=
 =?utf-8?B?RUxFSFgyQVRsNktLRGYzVlhpSWRoM21ITVMreHpOLzJUUnZEUmtjaGZsdUho?=
 =?utf-8?B?MUVCaFFOT1JHYXdZdDIxaDg0aFRnenBtU2ozckwxZFIrN0RjbjAxa3hhNTc3?=
 =?utf-8?B?c0JZcnN0QUhFbzViYU9waFYyaWdvYno2UGEwS1NMTSsrV0ZxZzJUWnprUUk4?=
 =?utf-8?B?Q21uc2pJeFJ2dUpNWlBBd1BrbmZFSmNYei80dzdEYjdxd3B5TEN6aFFlS0Jk?=
 =?utf-8?B?VkR3eVgrSmZBTUNoTEI5NEc2ZERLMy9DV21BSlRHcFdObFZwb0ZDaThyZEdW?=
 =?utf-8?B?SExVdUNDSC9QMmpCOFpET2tVdmlwTEJpYmZpU2YwcXUwRkQ4OXpXK0JGVkNZ?=
 =?utf-8?Q?IaiM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YllpS0ZMWjk5d2g2WDFkd1lXVjgwVllpWTVxTXVlckduQWxpVzJuN2lsbkFL?=
 =?utf-8?B?Y0xBS2NVWkZUNTUxSXVib3FKbTFKdlIybzJUVzVRM3ZMakpaUU5wOVJjZXd1?=
 =?utf-8?B?Z2tIYjhuclNVb0NGeHpBaUZhajFiWjFYVHlzckVaVloza2tsTm45dmpXUHdI?=
 =?utf-8?B?aWN5OGpDVHNjbnByUHE3RUpJUk96NlJYM2NFWm1wK3p0MW1ZMVlzbm9tZHJ4?=
 =?utf-8?B?V1RzL0VzbFl1dTgxaCtiWGtobVVnVUc3QUpZeUhDTTdPQUlqTkxjbnJ4c2d6?=
 =?utf-8?B?VkFwVnJIQ3VpL2hndGhtaXZzbVVveGZEZVFDbWwxN3k3bmhIU0s3QTN2VmpR?=
 =?utf-8?B?M1VoR0RucitzeFhFQTlMWWJMZTdPT0JLSWMyL21kQkYwQW40RmxnS0xCQm10?=
 =?utf-8?B?amdwZU50YUROM0d4VGN2UUlZWjBHRlhnY2R5Wmt2MjhmSlUxaW1tUGF5UTdT?=
 =?utf-8?B?RHZXN1pLVjdCWVBDOTJ4bEhvVGR4NDIwbnBkcDhhNHE1QXVvMzBha1pkbzhi?=
 =?utf-8?B?WEtiQkgrYmluanZpNDlCaUNCQUFhQ01lVnZNZkJENEZxQmt5OW9ISHdCZXpl?=
 =?utf-8?B?OVhGQVRBTHlJZkk5eFV1aFlKcVUzaGdlaXY2dGlXQ2psTFNsd25MS2ZNMlpu?=
 =?utf-8?B?SUNhUzZ6YnlhSVh2ZVMwb1Y1NEdwaW5aakV5RXlIZWFNcnA2TVRrRk81RDVN?=
 =?utf-8?B?eTY4K2VjN3BabGkzMzF3S3Nxa0kwNnN2T1IweENiTHBrSWJtV3Y4L1lLRE5B?=
 =?utf-8?B?Y1R1Ty9rU05kTTZRbXNDNG1KdTZSdzJMcVkvdEdQNFNQZ0E3TkZkR0ozTU1T?=
 =?utf-8?B?TW84cXN6UjJaZjhpd3hWOFdxajU5QlgvQjI2c25vTGIwbHZBbEFlVlN5cHlr?=
 =?utf-8?B?R3pyWlpLZVhNaE1vdkFCUVRnYVlYNEs1aVdqYXd0cEhjTXBaU2VoUmMrNldr?=
 =?utf-8?B?UWg1UU5Ka291UXJJcVhaejFOSjU0a0RPMFNZZ0d0d21QODdkaFlaZGtBVWtj?=
 =?utf-8?B?RWdwNmRBQjhPSmIyaEMrS1lvRXllSCtHYWF1eWlwUFJ4SHQxZEJLUmFJcjhK?=
 =?utf-8?B?aDBiZjRyK01YSWUvV0o4NWUxZXpzVnk3ZmNhV0dUcENaQ3FVMFNmdTUrRnZn?=
 =?utf-8?B?R2ZNaEdmdjZ0SVdHVGM0UFg4YVJOcWMzSWUzVHBERExxN0d6NHlFVnhOU085?=
 =?utf-8?B?dEhVZDNKL3FpL1pnWFFVcml5bkJXM0p1V0tJNzFEWTNUUk1vL1BKUDN6MUM0?=
 =?utf-8?B?MkZyY0tTMG9sY0h6VjZpNHFuS2lhOXNJejl4OTZ3RGd5aTNNOEJtQjNWVlpi?=
 =?utf-8?B?aGxmalFQakVsaG15d0NtaUROSkJIOHkwZEwxakMzR0NUSnJ4OTNPNzFqN090?=
 =?utf-8?B?MmY0dkh6alBYdGREVUZ6N1BCZEk5K1NpS3ZLVm1vZVlwZ1ZETW85RGFqWXVK?=
 =?utf-8?B?SmJ4ZHFoNmhlaVltckJXbEU4N1FCTVRKYzVqbFdzN2Rxd1VUQU8wZU9JNXdZ?=
 =?utf-8?B?UXNzcFo2WmFUam9Fa0J6bmsxUkZ0VzN6QnRNSDlUMks3NTRkYnFsS3d4Ritw?=
 =?utf-8?B?N2VxRDBrUWZPUHZLU1p5a3FPUURDSlY4aURRdlFXUnRtZitxYk00WWRkMHJi?=
 =?utf-8?B?MTZEZzg4MzNpdDZqclhwanA1WU9YTndxa29WSS9LSGJXbkRjRnRlUFl6UTU5?=
 =?utf-8?B?Z2VEMzFoMzJLU1k0c2FoQVpJbmVpMCsxVUlMaWRoWE9JQmZVNUxTT2VpdjdZ?=
 =?utf-8?B?RVR2ay9jeTA3VGs1cXJ3Qy9wbEtqcXdlcHAyS0lSOUhwbFYvK0d4cE5rc3V0?=
 =?utf-8?B?YWlNbmJGa1pnQ0VMN0dzMllBcGdwY1R2TkhJVG04RlQrUUt1aWNjNXJUODJ3?=
 =?utf-8?B?cDY3NEo0WVZnelU3eFpGY0NOS2JDTk5NdXI3T3M2bVhDMms1dExOVUZkc1pB?=
 =?utf-8?B?TExnS0FMYjV6eE05bkxtRHZlQTlZU1FYWDNlSnAyV1FVbGhqOGZHSE5RczN1?=
 =?utf-8?B?aU1ZTU9UTkRtUVRQdVlJMmMyd2N2bUdPZmxvZHFHdjYrL0tPMmNqWlRlV0ZE?=
 =?utf-8?B?UzUzbHB6cUNPMm16Z0pwVUozaUlMRHpURUpHZ1FIU1hITWU3VlIyWlpIcHN2?=
 =?utf-8?B?YWM2Y0REM0xhUkpqSGVxZnlEWmZTcHc3NnEwQ3UxSnY3cFdsNm9tVG5pZFJX?=
 =?utf-8?B?Z1JkU1NmRUdxa1JkOXEway8wKzF6T3NpS2JQTGw0enV3dTU2UHlHSEtKZ2tX?=
 =?utf-8?B?WVk5Nm9TMjV2NjF0WWNmR1RaT3hWVnQrMXdieDIvTDBISnk5QkhWZVZEZW9Z?=
 =?utf-8?B?RTNPblB2a2lIRDdqMEh2cVljbjJycTZPMW9yaytQRUo0TytQUmpZSDJjYml3?=
 =?utf-8?Q?AQJa8fL2NIYrz+Q4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf1da59e-37b0-49d5-edf5-08de6f118c13
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 17:17:09.0590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LImwkbq0CBvEOAZ7x70DdLMUk68N6zecI9+mkj1BBJUUzopdcQQ6G4POTpnAyd0cXp6NsnA5RJm8eLGi24eUdedB+KxZWtGekVGc84gsZVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5183
X-OriginatorOrg: intel.com



On 2/18/26 8:22 AM, Ben Horgan wrote:
> 
> Fenghua gave a talk at LPC on supporting cpu-less numa nodes in resctrl
> so is likely to have some patches/ideas around measuring bandwidth at
> memory controllers.

One idea on how to accommodate this from resctrl side:
https://lore.kernel.org/lkml/fb1e2686-237b-4536-acd6-15159abafcba@intel.com/

Reinette
