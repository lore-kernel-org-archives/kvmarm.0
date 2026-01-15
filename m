Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD13D1CC2
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768503358; cv=fail; b=r7Kt1/aJGP/8ZLNzMV/TKH1jMKVaVlBzwqelc+V73hpvGEu0+8dFQ1rmRyMG+PAhf5ApfTVgHIgNkVzFQrnfr7VcYZj5g935SEwmbvVoqTkcnWI2qxCtA6WVCZv9V9YMEn68z05eH0YmgWZlgaYUCqKpb3ZuMFb73Lr1yXrHnHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768503358; c=relaxed/simple;
	bh=MD4EC4wBX1hoKk+AnzYVboEgn0c6EFTZJ+xFc1ftwnw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RFhfNUtkMyeJmBrodKnMw1WZOikODZR1JnwhoV7dhFZUas7J0QWuaNhh0UWGBNZ7YM7AF6F92vXQ4MipwD4h0HYLBDXKZHGULk19+HOY3Qts1neZ9UudXY0O0WvOAH2+/spgOgDgmJ42ufJCWe9YpXjvf5poEupnZ6JyMS7D02o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qha3nXcU; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qha3nXcU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768503354; x=1800039354;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MD4EC4wBX1hoKk+AnzYVboEgn0c6EFTZJ+xFc1ftwnw=;
  b=Qha3nXcUf0cdK7RmCqGHQQcN2oZfsrJ8z9QdX1AsYEPBuVbyGCCjRC5v
   4T/tznoJu3ySEy9fOWtLHvBuRSkAgF8h7e4UxaUd9gjyj56wEhkLpRz0m
   0E3Y8+MxDevWikR85K/8TCOukWe7M5W6PyL6jiD6PuFeFLncVFWxzR813
   mEJ0esEfjC2YfjlMjmRaVvg5MSb+VPM3Eo1Rf/SYA2ELE8eOXJmxdMxQU
   sY/BSWW2Vzj/qygQUSdhOpL09Avnr9jSb2FLewZcSi6y+tkBZXI1iXtvI
   BckrIWty/djghxYDrKeKj3fSmimNi3zokzWBs6ZHTm9rWKCGzn19SnOWc
   A==;
X-CSE-ConnectionGUID: FYAOr6wqSrGTXLfq+2dNAw==
X-CSE-MsgGUID: N3shr62+QNOXzVqg5KVS1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80928250"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80928250"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 10:55:51 -0800
X-CSE-ConnectionGUID: 9bCYubVKSvabrv/iknCE1A==
X-CSE-MsgGUID: PjQo5pNrSr+h+K2HFFKYLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209512491"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 10:55:49 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 10:55:48 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 10:55:48 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 10:55:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyWuzuVjfKeeaSBA9RorygMk0j1l5sCvWuR36S/AlWtUtK2niiiGrZnmv2PEzV5D8rs+jedVNfDEOHn0PGfirq+WFfkwDpnOE45/AuJEOWUoLPl0xfU5xwYyP8XRcopJ2z1XYnqNUfYeoiTeD/Ek86T+2sdQtFJ3Le9PbeMyG01XzMexH+pqGAyV4GMdXxN7fHR1AVsN77j2I4VV0yWYtLOJRlk/OUWs0r32qX5DAfEm1B1whQzj8rA77sLYwtQRZEGN1pjayHeLsuuUWAsvHpJWi3fYSuBYA4ecRvW4p/a0z6sNHFz6q3OUOT+VdScL4sgz3fu8/Sfyza5uxH+Qog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLGQyLz9MAJTRz+MF6IxHuP/nanpAdl1YTlmaihqucw=;
 b=mV5gYcLGfK0e29gjIJAHWISHPf6ZcuNGZS25TMWhCWZjsP5CIsJEG9kWRlIrYJ4Y5b56R+pEjU16OKm7S1owAsmg8TyvW3bSGtYbZA5wEoaqoU/oMFv92R5rxPgKeMx3vfSZF+rGGaIy8afKrZ0HD0FMx8bXQN+CdE/b21CURl9QUgQbg0hgOswAzUmTJXTvQQNWWnk/xuUxPYixkdHGzuEUbyKZNKLCo47I1xNOl1Qir9kkzB7013n6oIyNk/zyAfsosYbkWdFyjYhLrmVx+RP6AV8dqnUpuWjdxZPlVMQ2TzpCfXp5UseJP6Ert+RM2etwuQYqDpztANoNTWZmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6775.namprd11.prod.outlook.com (2603:10b6:806:264::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 15 Jan
 2026 18:55:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 18:55:42 +0000
Message-ID: <f2e9d7e2-1f99-45e4-9cf9-49e1ce2f08e9@intel.com>
Date: Thu, 15 Jan 2026 10:54:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/47] arm_mpam: resctrl: Add support for csu counters
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <rohit.mathew@arm.com>,
	<scott@os.amperecomputing.com>, <sdonthineni@nvidia.com>,
	<tan.shaopeng@fujitsu.com>, <xhao@linux.alibaba.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-29-ben.horgan@arm.com>
 <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
 <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: ea922b32-7d8f-44d4-257d-08de5467aee8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eXVqZmtIaWg3bkNFQlp4SGwyeW95SkZudFZZZ2pQazRnRWxpU2FMdUR0d2Fy?=
 =?utf-8?B?dWUvSTE2bXFieGNBSjkvZHJucFdReFpjSm9kZlJuYTJlY3VBSUVlSkN0SC9X?=
 =?utf-8?B?TFo2eFU2SGs2U1VWaGUyYjF2ZHdhU3JtV2tsU01IYnRoT29BY1FQNnJiV3RF?=
 =?utf-8?B?bVJvMVBhRWpvQVU4ZDQ2QmpSYUZYeGQ3MVozcHdSS3NGbUR6N0ExSmQ5R0Zl?=
 =?utf-8?B?eWdKL1g5bVRKUy9FWmRtdXo0ckRRZlR3dXB5SmZ6ZXZFYzA1U0RXRkdwL3lt?=
 =?utf-8?B?YjRnbFZhQlRMcmlHb1JZTFlFaG8xTXlpeThmbm9USi9CVUtBVTIxT0FuK2hH?=
 =?utf-8?B?VlllaFBEakhLWEZiQ2hTQnVuK2RGOWlsT3hPVktNVjN2SkxHNlJibFpDRkVJ?=
 =?utf-8?B?YlJOZkZ3SnhtNEl0T04zUFR6c25QQWk2R0lyOG1SbUViTTA3L3hvSHZmMGp1?=
 =?utf-8?B?aXBtbys0dmJPZ09aSTN5eXdKTVp2eEFPZHlqMmQva0cwQjFYemNlNHZWZnp4?=
 =?utf-8?B?ZWxtT2FOZ0h3cER0cS9lOGlZTHNSNS9McnFhSDFlTkE5bldydU5hT3RDWEF5?=
 =?utf-8?B?c0lqQTI1ODl0YjNsVjgxanA0UmxSKy9vZzYyVW5HZGZYMDhGVVgrU2U3dVhj?=
 =?utf-8?B?ak96Q2M1OUxGanZ5SWFLbFVvUmRETjFFelR6ZWZaYXMrbzVHdTJpRjlQNzhZ?=
 =?utf-8?B?Tmh5dXBKS2VraWczNGhPMFNtbnlyWUhMejUyMk56OXg3YU00eVpZcDRJckZG?=
 =?utf-8?B?bzJUUjNyc3ZoeEJla0g0REpadUtLZVZtbzNHeCtPQnhUNTI0TEx1cWZKMk1x?=
 =?utf-8?B?R0dMWEJSdStET1krRUFsaStqRmdFYmJCY1ZGeEt3dXdYbmN3dWZaSkI0UnZH?=
 =?utf-8?B?UmpqckZ3K0Q1Y1ZmaWNDQnphbk0ydjR4NS8vZG9HQUhtdXFHbE9zRVY2SzJv?=
 =?utf-8?B?ZXBOaVpyQjV1OEhGN1lQTWswS0U2eGF6TzRJSXpGWS9sUmxCak5DNFRIUE5s?=
 =?utf-8?B?QklSU1VQUC9yaXlLT3IrT3Npb0twUE03UWM4cmoxdGh6SURHQjl1WW5ZaW9z?=
 =?utf-8?B?Vko5T3RSQmRML21ZY0RWemhqWWVMVjlHdmRxVUlsdHNuRENNa1pnMWRHSVlI?=
 =?utf-8?B?WG8wSzYvWUVoOTg0d3lNbmRnNHNVbE9kdDc2MzVLOWFCT0ZPTFhtNUpLMGln?=
 =?utf-8?B?N0szNVNacERueVp5dG5IRmNsN2lGampham5UMFVKc3k1andoRFBtWjFnR0N5?=
 =?utf-8?B?cTUzRWtSS1pEQ0hYOUNJT3JJbXNteGZPSzB1YUUxR3Z0ZHJYZGFmRGFJMVcx?=
 =?utf-8?B?SlNhOUJBOENEc0Jpa2R2eGRuSTliM1ZiQUJrOVpUQ1NFVDBLZ0tRQnJFY1hX?=
 =?utf-8?B?WGdmdnVQVm8wWFpjZVE5clc5b0tjS3BhV0xlSGl5d2lZNVlTQ1EzWFYraEFl?=
 =?utf-8?B?R0FkK3BLVit3ZGovbkFYTGRSWlBNbjhhZzNDeGhlRGs2alNVZ1U2MEN5ejU2?=
 =?utf-8?B?blQraDcxMXNHc1NQNVJleW40NVBYQ09LcmlhdW5CWENrVmhvQWRDWTBOREk0?=
 =?utf-8?B?amJRSjlhc25hTjBRNGFQdkVlaUY3TFJTQUsvNjM1STUrVUJZbkxuVDlNRDZo?=
 =?utf-8?B?N0x3eUF1UjdyeFRsZDFwaHdGSk9PNVk4cXVKa0c5eG5IaU5VNzJ0aDJNbmFQ?=
 =?utf-8?B?OFB1cDdVM3NLeGN4cXd1NTJ1K2NWVWdEL1huTXVrNGJSaE04cG1PY2lMcUdJ?=
 =?utf-8?B?akZBUVJHVTBZem5kOG10TkpuRUw2c3h2OVdNdnF2K3VtWlczVmZsSE4rSjVY?=
 =?utf-8?B?aGF4Nkw2UzAvZ01JRkhuUnFqbEFrNWs3ZzcvWkVrOUdpbGVrM3cvaUdPQ1JV?=
 =?utf-8?B?T1g0YWIwRnhVeDRyYVdTbGhieTAvVXJzS2pqVE9KL3hYOGpEQXN1NVRHUVUw?=
 =?utf-8?B?L0Z2ZXIrWDZCRVBaQ2RDZm5nMG1CQlJJa29PWWwvVmREc2Rkc2xtWCt6WHlW?=
 =?utf-8?B?c1NwbkFOZnNsWXJESFZTSFM3eVkvejNJWFVqSG4vY20rUm5TYVVLVXdzS0Uz?=
 =?utf-8?B?V09ZbmlaelRxSzI4ZUpvV01rZUlWTUFhejRvNkJQZXk0aTVzNE5CS3BhaDI3?=
 =?utf-8?Q?YTN/FnI/z8ZhBoMith2I6xanw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UElRK0J4VjB4YUJDRWlhbzZHOHNkWmZIdFhrNnNFK0xFZS91dm51emwyTG1X?=
 =?utf-8?B?c1FzVUJrL2xOdnZiRXhwK1ZYTTAxaTEvNXpzdnA0MFZha1ZzWnJxaXNNZEl4?=
 =?utf-8?B?NUVhd3lYRlFDUzJrYVBuekMyUXJBbkg2WGx3d3Bld2NVWGwzWEVwSVh6L1NY?=
 =?utf-8?B?RGVWTGVTdTJpcnBFVVE3N2tBNUwzakFicmwyRVZ0TGVJcmRTK2dKWFM5YjRZ?=
 =?utf-8?B?WmZmRUZML0JzUlVtUmFhRmRzM1JpcEw0RUFjdUJEK3JQcUlhYW8waVVkSGNy?=
 =?utf-8?B?TUZtQWVNcHR2UjF4MFYxYzg4OXhjM0dEdnkybzFBSEVYRzJKV0tFUDBMTjVa?=
 =?utf-8?B?WmRuSWcwMUZ2bTMwYVdLWllOSkpjaDJXTUxQLytreDVGb0JqdHpHbktKcmpJ?=
 =?utf-8?B?Q0w4SHBMN0FUS1QzSkpNdlgxMGo0bGF1UTlsRElvNUhlWDZySWNsMWllS2Zn?=
 =?utf-8?B?aG4vTTcvczVyVk1ZMjdFZVAzcVRCYkZwdEs1MmNHVHpyaEN1U0ErYTdQUnNH?=
 =?utf-8?B?SEFFaXhrTGh0Sm42YmNlV0pDeFA2aWY0WTlmTzRMSHl0aHdMTWN0M3BzWHJX?=
 =?utf-8?B?ZmdoMVFxOGxDOThwenhJajEyWi9aUHZad3QxelNnbXJTUTdWMFVOQ1FDaDdi?=
 =?utf-8?B?WDFKZTBwUUJ6NDRORVZsTHRGNk9EOXlXYWZNbUhLVWJrL1R5dldWY2FXZm9z?=
 =?utf-8?B?Q1M4WWhXQ2Y4cHNkMm5ScCtad0RXNWZDWHUyams3aG5vU0llTE5rMDJpdmsv?=
 =?utf-8?B?ejBPanlENTZmL3hoL3dIbHlTWVM2S0c3RDZxTCtxYU4rc2t6cktCVy8xZGZS?=
 =?utf-8?B?cnRzdVA4WW9DZDZGY3JSTDZxMjl0eUJDSmY3S0hOSTRUZ1JhSVJ2SjU5WVJr?=
 =?utf-8?B?UlZiSldCSkdybDVkeDFORmE0RDdwNFhLVTA2YmNBUVlFMWRuTFJxY0xXTFhu?=
 =?utf-8?B?NlFmTjVvNXJJeWdzOXRESE9RQkhSNGRqRlF3QnhDazRXQXJETmFUV2dtSEZV?=
 =?utf-8?B?eFBBZ09ZTWVYQ3NYVFcxWGFpR2ZsVkNMeDRia1ZoNXFkSmgyYUVVbVd6MnlX?=
 =?utf-8?B?YVJTV1EwN010aFNJTU11TXIxK2x4c05DalJGaFVnTVMwaE12ZlFWQkJGQk9H?=
 =?utf-8?B?TjVNbXFMbC96MXJxUW5xaG11cUtQZVdjdUFRd1c4RVE0cDJDZnRGVEdaekRt?=
 =?utf-8?B?Qm1QeEpQVjdHRE9VSCsyejBmVnN1YXBRa0RLWHJlNC9PRStQYVIrOXoybU12?=
 =?utf-8?B?dkpTVm5CTUpaUjkwR1VTV1RUUHNGSk9hNHhGdWUyOGpwbTlKb0FiRjlvUytR?=
 =?utf-8?B?NFhDdWdWaUdMbk4wa1N4dEFTYzhGKzd6VFpUQmdaN28vOUJDTkZuZDBad3BF?=
 =?utf-8?B?YklVUHI1bmNHRWdCTm03ZjlBd2tmQTRyNW5JQ2FTWVVmbmhkWTdEU2VTRUxY?=
 =?utf-8?B?TWMwcG1ZQ0lVNmZrWk1HZGY3RHk0ZzNLWm45Vm9iUys4amFGR1FlMm1MMFlz?=
 =?utf-8?B?cXh5Tm5hdllWSkpSdkNCWlFkUmV6UzVOVVhRVTZiNExVVWRSdis0Tm1GR21K?=
 =?utf-8?B?N2pwa3Fucm1NQU1aTEhzUVlWMFhMbzNOV203cm94OVV1ekRXZG9OS09wOFNG?=
 =?utf-8?B?bzdBb1ltam9LVTExT0hWdHg1Z1hwRFV0ZFcxOWVnZWs1SWVjajczMWtETkZL?=
 =?utf-8?B?d2xTYlRjU3RYTVlKalM3NWgwZkkvdmZxa09WMitGSVdtdjdNWko4MjFpOU5w?=
 =?utf-8?B?NzZOZFE1UENJUVpBVXlORDdvT0QwaWREL3dzWFVUVFpXbUV5QStsOEkvV2ds?=
 =?utf-8?B?UUpIUjRWVmRGeW56NU9vd2RPU1Z4WU5aR3VvUm9BcGR6YTgvcE1FUjB0WjVL?=
 =?utf-8?B?S0RzbGljTDNDajk4dGswbmRXN2FwUHRjZXRCQ2RKMm04UmhxRE5BeUZxbENH?=
 =?utf-8?B?YXcwQ3FwT2FHaXJRZkI5MUxNSjdkdkZaVTRpQXN0Zkg2eENpWHhFSisxVUdW?=
 =?utf-8?B?dDVQRDc4ZFZ4cnh4MWI1ZVNTOG1zOHh4ME9NRGtWY0Ria0NUdCtTSmVhd3BJ?=
 =?utf-8?B?N0RxcnF2WGhGdlgwWi9xK2xsWmttYnpnVWZIcmF0SzR6bk9xdVBiQWszc0FT?=
 =?utf-8?B?U2owTWw2NHljZGgxTERSTGZRS3RLTGduc0N4alZyeEJsa2I2aVVJNFpWckxO?=
 =?utf-8?B?TFVIQ2p4YmhlSHRaYUs5UldsWWhDS1NTWWcxci8yTXl2THQxLzB4VGxLcFpy?=
 =?utf-8?B?Rm9sT3I3b2kzTzI3UUZJTjE3eTdwbUtpdU1CcHFVVWZTRUZWajBpNncyUFYy?=
 =?utf-8?B?Zkt3VkVwSGdSTldMYVl0Nkp3T0M1QkZpNVJQMTB2aUdvY2pKMzRWZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea922b32-7d8f-44d4-257d-08de5467aee8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:55:42.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 266fURtxAu/6VqFNg2aN5wR8nXbpZES9OOGi87qbqljivtpplZeGXKQxR4vNykYtLAxOBhw6SNkDSGbh1wTkE7TDcSTh+EQLfo1AcNKos3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6775
X-OriginatorOrg: intel.com

Hi Ben,

On 1/15/26 7:43 AM, Ben Horgan wrote:
> On 1/13/26 23:14, Reinette Chatre wrote:
>> On 1/12/26 8:58 AM, Ben Horgan wrote:
...
>>> +
>>> +		/*
>>> +		 * Unfortunately, num_rmid doesn't mean anything for
>>> +		 * mpam, and its exposed to user-space!
>>> +		 *
>>
>> The idea of adding a per MON group "num_mon_groups" file has been floated a couple of
>> times now. I have not heard any objections against doing something like this.
>> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
>> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/
> 
> Hmm, I see now that 'num_rmid' is documented as an upper bound and so
> neither 1 or mpam_pmg_max + 1 agree with the documentation.
> 
> "
> "num_rmids":
> 		The number of RMIDs available. This is the
> 		upper bound for how many "CTRL_MON" + "MON"
> 		groups can be created.
> "

Please note that this documentation has been refactored (without changing its
meaning). The above quoted text is specific to L3 monitoring and with the
addition of telemetry monitoring the relevant text now reads:
	The upper bound for how many "CTRL_MON" + "MON" can be created                  
	is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.  

> 
> So, if I understand correctly you're proposing setting
> num_rmids = num_pmg * num_partids on arm platforms and that in the
> interim this can then be used to calculate the num_pmg by calculating
> num_closid/num_rmid but that a per CTRL_MON num_mon_groups should be
> added to make this consistent across architectures?

Yes for num_rmids = num_pmg * num_partids. The motivation for this is that to me
this looks like the value that best matches the num_rmids documentation. I understand
the RMID vs PMG is difficult so my proposal is certainly not set in stone and I would like to
hear motivation for different interpretations. "calculating num_pmg" is not obvious
though. I interpret "num_pmg" here as number of monitor groups per control group and on
an Arm system this is indeed num_closid/num_rmids (if num_rmids = num_pmg * num_partids)
but on x86 it is just num_rmids. Having user space depend on such computation to determine how
many monitor groups per control group would thus require that user space knows whether the
underlying system is Arm or x86 and would go against goal of having resctrl as a generic interface.

The way forward may be to deprecate (somehow) num_rmids and transition to something
like "num_mon_groups" but it is currently vague how "num_mon_groups" may look like. That thread 
(https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/) fizzled
out after raising a few options how it may look.

Another proposal was to add a "mon_id_includes_control_id" to use as another "guide" to
determine how many monitoring groups can be created but at the time it seemed an intermediary
step for user to determine the number of monitor groups that resctrl can also provide.
https://lore.kernel.org/lkml/CALPaoChad6=xqz+BQQd=dB915xhj1gusmcrS9ya+T2GyhTQc5Q@mail.gmail.com/

Making this consistent across architectures is the goal since resctrl aims to be
a generic interface. Users should not need to do things like infer which system they
are running on by looking at output of resctrl files as mentioned.

fwiw ...  there seems to be a usage by Google to compare num_rmids to num_closids to determine
how to interact with resctrl:
https://lore.kernel.org/lkml/CALPaoCgSO7HzK9BjyM8yL50oPyq9kBj64Nkgyo1WEJrWy5uHUg@mail.gmail.com/

Reinette
