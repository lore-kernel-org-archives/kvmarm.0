Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50927344D88
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770913357; cv=fail; b=lx0l3PKr7q++sPbnzfKixpQWifJhsO4ehOHvzIpZD2D8A3H5yEVb1jh+uM6XcqGV98oPGHcr2ZS2+DCKfY+hxQ/lI2HnCIlWwseAcnfg2/LB0iM+hic6/tnnn09odUtO6wQgB4snCXG3HDIHsMEg7yYEvb3AkgKsFXrx96N2sds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770913357; c=relaxed/simple;
	bh=+mf02zxbu6y1a1empjXlu0r+u+P5DmDD9N8ET/6sSyM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3j18sWwtnt9ZrNxTsDRqnOga6syi2lxEY+qOMxvVgH93sE9FTF27VkqTQUg1aq1WCNijYWsxCk4HNr5yTLcwl8RRG9mHOp5qdHKrlbeWx0z/5K92PKLgIKJkGBTXBsDPz7DXX65uhmY5RZBHro4V8go7xAL4ASXcFqC5Mp5t80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xa3HiMKF; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xa3HiMKF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770913355; x=1802449355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+mf02zxbu6y1a1empjXlu0r+u+P5DmDD9N8ET/6sSyM=;
  b=Xa3HiMKFIjz2QHhlZwAveLGFVTUHPVpuNVETgc+4A5iaYPykRYJzpjtQ
   nH7GuXA2xxMu+K8lz9wvv+Udimsj1qYkC4A5BfhNPUCbJaMuUStbQKEv2
   RPz4qOfJapJlfLaR0R57l6vdV5njFKo1qPunuZXbbZAqdQiTTTQ67tVVo
   LVD8e0u149w5+8OEojpSN38fOG5NYvwx+5EwPBWD4YKSbZnzHTFccTHKQ
   HS4Oig8I/W6zR3Jcg/oHQ+gpRg4P9iNsHow2JuSGFF6TMMur7+qs9YbkG
   OsyhpYxVVWeWEbu0Mb1DyhDfTaxE4ZEWYgWG8AgYdyqSrQ+J+CFghIabN
   Q==;
X-CSE-ConnectionGUID: 1C7PJSHGRT67y4YM4dzTBg==
X-CSE-MsgGUID: +qCXVzpvRG++8hXMuT8C/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="71990701"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="71990701"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:22:34 -0800
X-CSE-ConnectionGUID: 4W3UUazvQi+DKsZ3r9AJTg==
X-CSE-MsgGUID: KK6sPY5GTkOII+fPN84NLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="212132018"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:22:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 08:22:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 08:22:33 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 08:22:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmB4Nzcvld5BhA/a1YTasPscmEhCpmxbg0Lbz2WKBjfN2irP/MR+exc9Lny1fPw9QLyuTrTjVrcjcDVH1P1Xk0jmhVzSEHeUjsaEpAMMRe0wnlFcl6RcbtUbCXxX39wqkTwDHwkebeaqQnBFY36bSXKkkVzsHP3jDp5FE7rliDQWP4H3eQ/BdohvXOyyzhzj6w9Q4GzHwXfqgMrRCloBvazchnTV8Yy5H74fQFuJ5n5C9GxN5hRzFzDJPoOqMuZpb3KmyAzMky/FMYcJk+8pxccUvCZI8Cn84f7GEzyqVz80RftV2pMU7iGLHQybx7ilX/HCz81GoMT1K6uVnHWCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/c11k+A3tuJZAFlWKLVomwyjCyfOG1GWWUK0JvgYF0A=;
 b=lNhL9fVBMkYHcOFeCPte3Z3dkjLiFgIHwxq4L6zFjpVnork78FK1DS7Tm3AsLqFqoJSTpeOPtzBNq+AQ/ITP9c5a/dGN10ZtP9d8QFZtt0V5PUv9nFs8hMFUlm5oEsAhP0rjgk7qffv9YEXsRPc9+F5P3XBzYs0QU2Eogc2PaUzk66wHIAKfFoWxWaayUlb+vMYI29zawVVBMpwPbi8UiUa5/ye9SuU1QW+Xwlu9liqtfn0akCdfxadNL0yCzuJW7/IaoHeS9MGbjks4rkwDLHpTmjEd414StST4bORpsnxccLQVINBgv4sphoocB+9ONi4Qa5P9dvMubThhd+5HIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 16:22:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Thu, 12 Feb 2026
 16:22:31 +0000
Message-ID: <6cc8f43c-33fa-4ab8-a107-5dc7ddb88b45@intel.com>
Date: Thu, 12 Feb 2026 08:22:27 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/41] arm_mpam: resctrl: Pick the caches we will use
 as resctrl resources
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
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>, <zengheng4@huawei.com>,
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-16-ben.horgan@arm.com>
 <c8d53e59-5661-4ac2-bc8f-0661cde59967@intel.com>
 <aYxieS3Pycm5UthH@e134344.arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aYxieS3Pycm5UthH@e134344.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:303:83::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: f450e1dd-c70c-4e82-fc9e-08de6a52ebd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1FUQ25RSFNVNkZTcEhuNzZlKzNjV1M4ZytsbDhIQkF0bGlRTXJVSm9qcWhM?=
 =?utf-8?B?UVFCSkhDdXJNS0hqV0ttOFJBdDNBeTNaelRLeHcrMXhzSTQ3MTZzak05dzFu?=
 =?utf-8?B?cVNQc3lsTktMeEw0bVhteGVBT1gzTGdDWWs5TXJ6T293TjhLVjVWa0tZKzg0?=
 =?utf-8?B?THlIZk1XeUltMkhhYkg4T1ZnSHRPOHBvQ2pKSzAvQWQ3Tm9JbjhyVUhiK0FI?=
 =?utf-8?B?K3dpOXVkekdUcStQcmtNcDdyQSt6WFk4ZUxyWmR4aWk2NlFvYWZaOVBPaTF0?=
 =?utf-8?B?VnFXRkRxcTlWZTdocWora3FrZ2YrR1dvM3NVSzlCUXFWcnhvQzlzcDhuQVN6?=
 =?utf-8?B?ZGVkQjFzTDFRZnVDMllYRjRVZXA1OGVSMlBjSE5MMXk1anZqZnBacGdTKzg0?=
 =?utf-8?B?ZURIK2ZIL0c1NEJ4dkxnTXpKQm05MGV1YnBQdFNNcHR0M1cvTEZXcXBGcUlP?=
 =?utf-8?B?eFVVOUNHUjB1ZE4ycFlDeVprWHM1Q2pSbklYUDRiNW9kK1ZLY1R0SG9XcEtR?=
 =?utf-8?B?YlR1RmVEVzMwbnlsZHdQaDY2azEyZzBaejYrajgyNHFwcGFwQlp4QjZJcXpR?=
 =?utf-8?B?SUNXZlRFSGZqcXNFcVBXNkZCUVRWbEZ6Z25yNWFjSm1ERCtJazRpd2VPYXNo?=
 =?utf-8?B?b2hXVmlEWnVTOEtYczRpOVBXNU9vaWpDc0pzb2pCdVhLYWREaEVwaHZLSDdS?=
 =?utf-8?B?TzB5WkZ3VUhXODhRdTJxVzd6YjlzTFBqTzhuaGlOSGZxSVBldUgrUU9idkdF?=
 =?utf-8?B?ODF2blpCMFI2RGVVYlBZcmJiS3hmMElWRVNPaUdPemR0dlYzOGxDSjJTS1VJ?=
 =?utf-8?B?dkxUbGFDeG1WMGN2Mk1ibC9hV1F3RFlCZERSKzBtMzByODlUUHM4bjNmYkFx?=
 =?utf-8?B?Rm5VWWVPQUlCQkdETG91ZllCOEl4anFPTEFaWWdpR0Jwa2JvTU4xa0VnK1Uy?=
 =?utf-8?B?dHkxOEtkWVVKNnplRjZFVVFLVDUwQWdJazVneTNUNERhSHp6NktGY2RUREpw?=
 =?utf-8?B?OGlmY1FpUnFsd2dEVTI3ZCtJTEduNm1hN0c4RnR3ei9SUER0OUNWTGxQTDRI?=
 =?utf-8?B?TzRhRUx6VUgwYzN4Nkg2cEdDeGlyYlJ4dFJlVkRMdU5sSGhQN092Q3ZrczlM?=
 =?utf-8?B?ODdJRytmWnM5VWxQb1g1aGIrY1NRK01qVUZiZDdEN0ZkVGhkcXhEeDZsWVc0?=
 =?utf-8?B?TVhLN0ZmRmtHcjJ5N0ZZdC9WVkk3OTNoTTdLc3lFeDhXUjB4bjgzcDRqUjY4?=
 =?utf-8?B?TUdURTNLT2JYS3pOeWJSMjhvdmowOXFWRHNZOFhuL0tKRUpNM3BOMFlaOHNn?=
 =?utf-8?B?ZG83eTE1bUZjczB2QXdObnZUcnBjUnd0cy9ONXhhMFY0TXhybmtmcFJ2NFcz?=
 =?utf-8?B?cDZUK2k1dGhJZGlqY0ZwSXpWMHNFSXl5SU13cGtqWk92QkoxUEZOWlFNMkg0?=
 =?utf-8?B?NTdaMzA4dklPMXFtdEcwT2hkK0dpK2ljeW91czZIN0xpZEJ1L1Rsd2xJRFY5?=
 =?utf-8?B?MmRXb0NoRlJHZTlPSy9KR0h2WkxTS3orTHd6Mi9pT3dMNEIxeTh5UG16UFhz?=
 =?utf-8?B?S284dk05TWg5WFl1TzdjQ3FtVWlpMGtzSGg1YWllb0tmQlExRkJxelFNRnc2?=
 =?utf-8?B?d1VMcTR6NkNHdFlRbUpFbG5tWHFXUm44TVlKUjFKZGRyOWJFQlpoTmdJU2o3?=
 =?utf-8?B?aWpRdzZreEFWcStWSDdtSjRYKzI5Y3lDY1NYM015REowYzNVWGgvSHBhcGto?=
 =?utf-8?B?Z1ozbTByWGVkNm9VTUNKMFFTeURGQnluK2szZlR2SFNXMGxwb0ZmRGZIZUpp?=
 =?utf-8?B?dFZMSjBtdjdHUTB2eUlQNzJpZ0hReEJTczhvbmNiYTlUK2pNeGc1N0FuQ1Zh?=
 =?utf-8?B?RnYyNzZyeFB6WVd2MnRMVXpyMERacVhIanBDMEtuQ3A4dmdEc3VocVJUVURB?=
 =?utf-8?B?bThZbHd1VDYzYTcrNTl5V1YwSmJrdW1Pb2RiNmEwK2pmdzZTdkI2alNpN2R5?=
 =?utf-8?B?bFZPNmtGNElYVndUWXBsSzdaS2NCRE5NZXFDazVvZElBOUVuRFhCeXF0MWh4?=
 =?utf-8?B?NFE3VWo0RFJyT3dwZnhRLzUveC9VSy8ycmpuRTRUVmpNTHovZHBjZWdYcG12?=
 =?utf-8?Q?VvNE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFBnVzd4Y3oyTnExNm15WmZieXdVYWFCMjFhTGZ1S2s1dmIxMTI4SjdLTUN5?=
 =?utf-8?B?OXdnS1ZHM2E3azlXbkx5VXNmVUJ4aE91ZXZSUzExeGp1SXVDQ2FTTmlMa2hj?=
 =?utf-8?B?SVI0bCtXWTdiTkRTSnpKNEcvVlU4RGRGa3ZQY2NFaDFXMHZJQis4NmZ0blVi?=
 =?utf-8?B?cmgwWVlOMzk2Vnc3bTIzVWluYkFaakRoK1ZpZTJDdlBoS2FMYXdQY21OMHZQ?=
 =?utf-8?B?WERaNWdJelN4N2ZpOE80QUhhUzZMa1ZvazlTRmcvOFovbVdIRzZaRHZZaTdQ?=
 =?utf-8?B?WHlJODNFR0RkckFRK3dRY0NXR0ZuRUNBbENLZnFpajR4aFk3elVvM0hUaXJX?=
 =?utf-8?B?Y0hNTkhOa211cllhMFFuYmh2Zm5jSEVOVTB5OS8vSXMzRkg4UncvR0NvZFVz?=
 =?utf-8?B?MHJLM0VjWjVpTjZnb2NEOEllSyszQ0YwODZJU1RZZ0YwYlFBbGtIUWZNY2VB?=
 =?utf-8?B?NnJDeHlMWU1OVWMva2Y5RmRGZlFqWHVDbmtMMm9CWmRSNlhZcitsazljTGt0?=
 =?utf-8?B?TzVlaFFKc0pDOHFCT2hMMjRJWm0xMHRVb1VjTFp2cTUxNlkrUmc3ejRQS1Np?=
 =?utf-8?B?K1p2ZyttZXFvL093QXJwT29KMlYwRXpobmEzOUhBNnY3ZVRXdUpubGozK2RS?=
 =?utf-8?B?ZWx3YkVwRVVQdnR2b3Y4aFl4ZVM5dWVvbWN5SkxVdndBUGlnUlFlaHB2bE9W?=
 =?utf-8?B?eC9lRStKOU9CSitWdFdpbUtkYWhSQnJROEtZQWN1dG0xU29WbFFyOWprRDhw?=
 =?utf-8?B?L2M0L3RaVU4xVEEwb0ZUMSs3L3FEdTBoV3lDN3VMMXdxZTF1bEpLRDc0OGxR?=
 =?utf-8?B?bnk5Ny9xSjIxd3JXNm94Y2phZERvc0FXcmx2Ymg5Y3hNR1pvNVg0YnFRN0tJ?=
 =?utf-8?B?TnZGSEgxTHN1TlNRQ1BTMG9tK04wWEdqbTNsYUhpbS9ETFAwdFFDTGsrbTIv?=
 =?utf-8?B?c3JrZmFkeURtVllYbmIvZFI4SHo3Z2tFdHdCSGh6NWVCOG83UUpFL1R3OEdw?=
 =?utf-8?B?dkZZTzZzNWZIMFRjR3hyMzVRQVY2NlhlRkxjMW1rTnlzWnh5b1dNLzdqWVlm?=
 =?utf-8?B?d29ucExKNkhPQyswUytiU2M5UWJXaVN0ZFh4RTd6dEhpRmhHQWlxN0JzMDhE?=
 =?utf-8?B?NiszZ3B0SlIxOGpsRnNqdmVuMUNncS83N0ZlVkFtV2JUbm40aExJZVhoOGZy?=
 =?utf-8?B?dE50TDU4T1MvaFVIUWhaTUlHNk9kaUxmZUd5aEpVYVhRMmVZbjVUa0I4bDdj?=
 =?utf-8?B?VXJ0OVMyN0ZydDArZzhhUHYrNHNUQWtkZGUvZ1MxMmJ6Qi81ZXB4WHNCUDkr?=
 =?utf-8?B?ZVgxNGVxVU1XcTZ4emRtZWdFbXNNQWM2UU1Rc0lEUTJxU3pZNWc3V3FXelFM?=
 =?utf-8?B?ZVZxU2ZoQ3RkSWRleGRVMm1pc081MUdHc0dmelRkQk1zdkNYV1Z3RFJhYlNq?=
 =?utf-8?B?Y0JPWjVWOGcyOWtoYkVCblpZMnBzQlFWaGJwdFB2b01XQ1p0azkybVY0V01Z?=
 =?utf-8?B?RThCdjd0RGVKZ1VYSTBWdk5OdnZpQUcwcDdubEZVS1B5UmxPTU1YQ0NYNTJi?=
 =?utf-8?B?QjQrTWc3TVpYNlRBM1diZVpydG1sS1N0NEtKOFFjck5XdlpZVGVFblNNeWFE?=
 =?utf-8?B?V0ZFU1F4eHlKdXljeEhmcWw3THdXZEtJd0ZpUTBLS3dsNG9MMnAwUGh4b0VQ?=
 =?utf-8?B?L2hIZ0ZtWnhVSTJFNmRxRkdFMFdMRDdNTU1PZHlLYWNRdG40cnRzZm5WaENC?=
 =?utf-8?B?ZXBSVFlxbkFWUi9xcVNrZ3JobU9hWGZLN3h6Q21udDNhNzYyc2JkWi9XdWty?=
 =?utf-8?B?VFhRcHF2ejZWcm1iZVNCQWhidktHUTRWNGxSM0xhMmk1WTloaDdNTEFKU0J4?=
 =?utf-8?B?UmNjL1ZBdVk2dzBzeXhQSHYwNmFETGJXWU1CWWlhNVNSeFVpWUZ3YmU2Q1dQ?=
 =?utf-8?B?Uy9YV2ZjM1NrRU0rU240MzN6RU81T3NNRWJockkrUnVQMGoycFFHM0NTYmF1?=
 =?utf-8?B?TDU1aEw4a2ozdllrRVRhV2dqenIxQlllK0dDSnVaQVlEanBxVkRBZ2NXWVVG?=
 =?utf-8?B?SVZzVG82anM2cnFXRWlLc1Z0cUxyb3RtN2pNSVY2VnloNElVekxhV3lEOFFo?=
 =?utf-8?B?N3NDRVRKS1JyVFZjZVZCclFtMkl4SGJCaXNnTHRJcFlPdFJjMnZjNWh3MUhM?=
 =?utf-8?B?aURIQk9WK1RXSzRvQk56RDNEbU5MQ285azFCVDY3VWRoVlJibVZ1QmovWFdu?=
 =?utf-8?B?cFdJZjQvcmE4YjNTR3JBVGVORmZ0V1hXU295bmM1bnpEcEJ2K1FYcUxDZGlQ?=
 =?utf-8?B?T0tzN0VYR1BSeEJlaEhVZk5VaGtvNmtOR1NIRmp2VjJqMVllK3ZCT2tScXov?=
 =?utf-8?Q?JuJUv6qAOvCe9me4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f450e1dd-c70c-4e82-fc9e-08de6a52ebd2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:22:31.2532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajwmBM37/SNj+R45XN7i8ghZGnXp0roChaqtn7UGhvmgktDR4n5t1qW1wbX8hom4Iagl5KB5cVqPX/XIAVs1QKZiZOeUh48HwG5GRHC9f9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
X-OriginatorOrg: intel.com

Hi Ben,

On 2/11/26 3:05 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On Tue, Feb 10, 2026 at 03:39:51PM -0800, Reinette Chatre wrote:
>> Hi Ben,
>>
>> On 2/3/26 1:43 PM, Ben Horgan wrote:
>> ...
>>> +
>>>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
>>>  {
>>> -	/* TODO: initialise the resctrl resources */
>>> +	struct mpam_class *class = res->class;
>>> +	struct rdt_resource *r = &res->resctrl_res;
>>> +
>>> +	switch (r->rid) {
>>> +	case RDT_RESOURCE_L2:
>>> +	case RDT_RESOURCE_L3:
>>> +		r->alloc_capable = true;
>>> +		r->schema_fmt = RESCTRL_SCHEMA_BITMAP;
>>> +		r->cache.arch_has_sparse_bitmasks = true;
>>> +
>>> +		r->cache.cbm_len = class->props.cpbm_wd;
>>> +		/* mpam_devices will reject empty bitmaps */
>>> +		r->cache.min_cbm_bits = 1;
>>> +
>>> +		if (r->rid == RDT_RESOURCE_L2) {
>>> +			r->name = "L2";
>>
>> This code is fine but highlights that resctrl fs should not let the
>> arch need to do this since this name is used as part of user interface.
> 
> Yes, not ideal but I don't think it's urgent to tidy this up.

I agree. This code is fine. I just shared an observation.

Reinette

