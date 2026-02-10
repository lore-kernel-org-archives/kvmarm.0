Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DC733A9E5
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 23:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766801; cv=fail; b=Mj3htHWppCMlT8ATFp//yTTpu0beCVDjPbBjG78IR4Qmdl4ZK+1rp9io8kZbCjH1qCQt3gE+2uKnCgGn/Sh+LmtJwFbXM6M5p/b/X44fRaPVeM/aNFFlRFnp0ORbu2UxScRxnCsT5LLWwRuRH7NTCcQjrjipeNKqvauTFD5ldNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766801; c=relaxed/simple;
	bh=xgJNUKmgmm7l7OFmqW690eqoaIWsUVngNSrv24qSyfw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VrmW4b/aiXYaDZ9XpAJRDe+WT5Po1d2BwXSCfyb7Z+UhYNHUsOEDbdmN3w55zFeqCnhyzPnCen7SJ2BYmF30eWGQWuoWSxiMSqQNoc9mXdNChGQYF/RE52Dxka80lXvXyd1nAiMNjNhlFkV5ueQ3JsCUnE4cF7+TzRrDzOgnLSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I75dhibv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I75dhibv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770766800; x=1802302800;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xgJNUKmgmm7l7OFmqW690eqoaIWsUVngNSrv24qSyfw=;
  b=I75dhibvnqrPEJAj78DYsWXoS50Xn8Hm5uDU6uqvyV/Spl71WLtBf2Ex
   0BCNwQVRsr9ofZktMjSpMJ+RBvORyPrFGiSwWNE1YiXMF6NQFHcOf6Pgz
   kxCzkzJljZ3FJYlUJM7eP5S7vL9eJzV3QCFA/fqOLwWbH7Q8d2DDRPaFM
   g3CbVHcvSWCwT26VOczIlJUyNY8SSnMelbdb97gPxw8ahWj3ss13LkRIX
   2J1Qncgi09o29Kd470TDXZH5kGKf7LqiE/zcAGo1b8xPDnH0E5wX16I3U
   perW+64sS81p6nvGDBLY4FeJFkiUJ9elbo+eRpYgsN6NANKFa289wyacQ
   g==;
X-CSE-ConnectionGUID: +7OcbSvbRyuscX/nobsd0w==
X-CSE-MsgGUID: /bJsakS/R1SaNGeImVS0uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="59475392"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="59475392"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 15:39:59 -0800
X-CSE-ConnectionGUID: jZd+wizEQJ2eaH1uPRa7Og==
X-CSE-MsgGUID: +u79lyAySYiVcT0j0jykfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212102490"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 15:39:59 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 15:39:58 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 15:39:58 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 15:39:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nhj0wyu/ezN/fkKq1e8ZEz/Id9vQKlRYrTwsR2ow7H0RbYZtQ+4ukTcgSCnnyc0ltgYa3Bgmgt7Y91OTHYd8nT9Gg4tCd7kKr9YYKfu0yJ5Mxp86BaKDWhQEHtApvOOO4CXobed1+TaL9c2LmrW2Z/u7xeoCYGQlD4TOKe/SYbvN3Ra4CD6L+geb+hJeRaf2Z67E+tkzC3Nuc2e2wNXH4rs/zF2lRqTlw9KGLQKZHXHBKmQSL0xiXjdxdcmkP7pwcgeEuxqjnWpZSUO37jnusk5BzyEIuhwfrmBaBWTqfKyKr6r7/zSqmtSv3NY7ZELdIfYTMgVqn1Q9YAP+i+eOhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sbdgXOZgWOodGDvQbAeOuUVQ9OiZTQ7JF/wf39fv/Y=;
 b=ND+EYPHLcZrauawNoJ8FbpAzyzyAlOii2HiaupKBmLIyhZ8qK7XrnGQDOQZSFqUNjcm1dVNaNhZd/6Fk1XZFv/JCi2lZN4X4s+GvhiTcRaI7d4eck1NzCj5chJuH/YNpWPMY2Wu/ARMRMUQYCkb7uwf3sQOVF8+c/WT+RFVatUy07fM8iMKVEXYxtPjVg+55B/7bwf+QVKJGHKcGloNwo5EgOZAPfPMxzSk58HSTKu1zktji/XbIuAC7WCN3v/Cj6prCddEywJAMl5dTQmdkM5Qr6anmj0nqdQ1GMcpN2G9rksyFEOkE6A3qdYd0qs6i+suz+3vJcGW9rkMsvm+JFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5135.namprd11.prod.outlook.com (2603:10b6:a03:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 23:39:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 23:39:55 +0000
Message-ID: <c8d53e59-5661-4ac2-bc8f-0661cde59967@intel.com>
Date: Tue, 10 Feb 2026 15:39:51 -0800
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
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260203214342.584712-16-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:303:83::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f77f1e-3735-4f91-5516-08de68fdb1a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHdpbGp4c0Q1azJQUE5RQkpXU01TZVVLNFoxZGhyNUtuZ0VtbTVzdVh6UFhR?=
 =?utf-8?B?eWpiclJLMVFRa3AxR3UvVUUrb0xGUVh5Yjd6ajZhRHhPVkxuV2kwZ2c3OEl0?=
 =?utf-8?B?K3NKbTBybUt0OE5wdjNteVN6RlBWZ2hER2tzUTJndHhHc3ZwclI0dWRDRFBD?=
 =?utf-8?B?bFF0MldTQ3BjT0UwQWNtZ1VURDh2MWRJTVJBTlQvV1kwbUYycEpSTng0S1B2?=
 =?utf-8?B?NXBnL3NzSUdDTG5jaGs0ZFA3QmNyNFdRWmVGSnFUUjB3VjFrK1lnY3o4L0Jy?=
 =?utf-8?B?a2ZqNzMwYUxXQ21YRkN3bFhNY1hqa3pSTXVtSWhsL3ZZN3hCL1lHWnZ0Qkd1?=
 =?utf-8?B?L3M0bllEUms2YXlqVzEwb2oxM1owMlJocGNDUnJycGlhVDg0TlViTXJ5UTBG?=
 =?utf-8?B?cU01bHNXUjdmbDB5U2N6d3dZNFB4UWlNSzRveERzNlk1VVJ6clljSzVmQVlj?=
 =?utf-8?B?OXBpbVF3Ny9XUzVvVnpOM3l0LzVaOGdYOHBlNHdVWFhSRDhjcTRtWlArM3BT?=
 =?utf-8?B?WXJtL3h1MERoVnNjVlFDTlM4QWJZcUY2MFZsS1RyTFRCU3g2cmw3cC80WWFG?=
 =?utf-8?B?cWkvcmd0MG50MXIyTnpMTFlDTzFLeHE1WlZ4U2J2d2FmaHJhWVNkMkp6UDg1?=
 =?utf-8?B?Z0tBT1BMTzR5NnROUXU3c2luMTlGcVJLTDVwMEYyLzhuZTdsQldRSzY3cWd2?=
 =?utf-8?B?ZTdKL0o1dDNzNk42QTF6a25ETFJXOXpWaGJrOFhBSnNxUFRrNElCNGNhWnZ2?=
 =?utf-8?B?cVJZbzNIVkNqbXYxWVowR29WWkRadkRYMTQxVWg2NGtoNTJzZU5WUjFKaFRO?=
 =?utf-8?B?Nm9FQ2VTWVBpckptY3k3VzJwS3BTWHZGNGtkR2lmRlNKeFkvalNnYVcxZTBZ?=
 =?utf-8?B?NE1GWk9iRWJHQlVpc0RNalI5ckdPSVJOR1I5VHdRQmJkK1htSHJ4eDRUUWVk?=
 =?utf-8?B?RzFTdzE4ckd0ajQrYmlOSWZ2ZHpIWjAwc0l3MUFlQ1p6UjV2MG1IVE9NeDV4?=
 =?utf-8?B?MkNyMlFlSWR6N0VWVzEzUjU5d25aVlJwZFErR2lHZ3FlWENjaW4xN0JLVmY1?=
 =?utf-8?B?bVNiOGNQWU5jUlRiRVRIK0F1Wkx6bnBPTXVuZ09XMUdUb0ltUVJYZ3ZlNW4r?=
 =?utf-8?B?dDY0VGJyaVRQNUh4U2toRkcxYTRIQkxtaWlYdElwWEx4Y2VwWmd2VjJQbEV3?=
 =?utf-8?B?TVBaTjBqK3lmd1R0TkpHZnNzaWJ6QVMxWkRSUFJIbnE5TlZSTzNrYnhVanJG?=
 =?utf-8?B?TDhwRWM1WXU1Zlp3Z3Z1cGxqTFNZR1hRSUxzamIvMVhkd1BiK1BtN1A5VHA3?=
 =?utf-8?B?WUZFWHN5cHRyZGZhSHN0dXVDTlgyOE1RbzAySlVLaGplRjI3R250bDlGN3BW?=
 =?utf-8?B?NENHeEdveHhrSHdlRHZxWkF0bHRrTzdvcy9CRE5vYitPZ2VDdGJvaG9HTkJX?=
 =?utf-8?B?MlBRMC8yeDFFeUhuYTdFR21LOWVqc2ZZM1J5ekJycVFmMHlsZ3dIczU4Mk1o?=
 =?utf-8?B?T21rV0Vvb2k3MlF4VElrc0p1OXF1SVF5V2Z5MXQ3WkszNVd1bmFheUN5Ymly?=
 =?utf-8?B?SFZHNUJobXlNTG9pWlRVYmI3bWRHNjdHYW50empiUG5vWHZ5NUxWQ0x4SHE2?=
 =?utf-8?B?dllzSXhBRW9SblZ0VEl3aWEyK200Wm9YQk9qQldVK0hVODZ0WTdZbE9qMlo5?=
 =?utf-8?B?YSsybC9rTm5uSllGdmVVVEJtc3hXc1JvOGZnbUpnQURzMmRQcWd6M1R5Vi9F?=
 =?utf-8?B?NklBRGVMaWpLcXRJZ00xZlFGbEhNdDhMbkhwK0dXQk5Mc2lOb24zNzZlckl0?=
 =?utf-8?B?RkYxUWg0WlhZRVFwdXpSelV0bE9RK1B6UnpqcjVnc0hqWkZvMC9BV3JrYWwy?=
 =?utf-8?B?U2IrdkNweDU0OHlyVWZJdjM3Ti9rQWZxdUZGdk9leFVpUERUOW5OV0tiYzRQ?=
 =?utf-8?B?MTVHa0dvL2RwSGh4dCtPTGlyVUdXZzZMOTQ0Z0gyRFA4SlVQdTEyS0tKczA5?=
 =?utf-8?B?c0ViWlM4TkFuL1FNM2ltQ0dEUDNRbWFZbmFGMTJxNExVbWxRZ3F2TUFETStl?=
 =?utf-8?B?bFhsRFhCLzFYYmZqVSs4UjA2SnVQMzZHaWRuZ3UwNXBnVml0LzhHeGM4YlVq?=
 =?utf-8?Q?CGu4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cStReXU1QXdIMHEwRUlsMTlTbVdGSmhaTGFQRzFQQkkzVGorQTBNVWRaaTNz?=
 =?utf-8?B?c00wZ1BQUDB6NXZVOUllUHE4T24rOUxnN2h5RGVya09ha2ZtS2N5QmpWV1FH?=
 =?utf-8?B?ZmFQaWpXQnBUMTBkeHoyZURsTEI3S1FTTEdkTWk4VTFYNjduOWpvTUZXYVlG?=
 =?utf-8?B?MC96VXpKeFNJdWNPMzlyZHBnT2NZR245c3BNbFJVOHlxemxVa0h2WkdqQVZi?=
 =?utf-8?B?Sy83S3BmVm9YYk5SZ1dPcEZDN0ZKVzR2NFNNNzhMeXF6NG92THRvbWVTVHRF?=
 =?utf-8?B?dDdzTjRqRXRUUFoySEVFRHpZTCtWTitnTTlnaUdCV1c3bGRnY3E0MjF3Q3B4?=
 =?utf-8?B?QkNqbksybkU1QlROMGNkY0g5VUpzdWZ6aWVicnFGU0psRWhubzJ2NlNuYTJp?=
 =?utf-8?B?OWNxRUF0Z0RvaWpRaDVtMXY3TVNUaHJ0Tk9reG1WbVI4dXlWV2ZOanBWL2VK?=
 =?utf-8?B?Wm4zekNYYVpLVksrZTlldnRrWXZacFY2WGhkTjY5ZWNCK0dkcWEzbE5RYSsy?=
 =?utf-8?B?b1h0YnZBcm1ZQlNOWDVDako5Ry9LUVBBTW1KSVNNT2YwWVRrL2hsUGJMeXJ4?=
 =?utf-8?B?ek5wRlp4Vm9qb3JTdWw2RUxHa0VMV1BmTWo3WVl5N3dVRmlGUGUzWUU3UHJ2?=
 =?utf-8?B?bmM1YkhmVXlSRkFmWGd0YmJobTEweXhpYXBjaEk0RHI1cFMzK213SEZldDJq?=
 =?utf-8?B?amFLVmlpT0lXaGxWd0VzMHkyWlhYSWd3aVllWFM4UG9qRDk4b2JtMXdLUHdL?=
 =?utf-8?B?Umx5aVNJTTB0NFVUVlRhZHYyRE9XeXpOcVlTTGhNY1JVYlZGY2xNWlU2cUxj?=
 =?utf-8?B?dTRsWVFscVBuMVA2WVcxYlpOYzhISlFMajBrUG04MmFDNEJhNGRNOE51KzlQ?=
 =?utf-8?B?d2hodytyaWF6aERVc0N1RzVNaVdjQjF6bEpLTEhZMlI4Wm5uRlNPaERiVUhP?=
 =?utf-8?B?aU1hSW9MTGY3YmtLVEJRS2loRzFrYzBRR052TFFkdjZPNXFmYThkWitmSGpk?=
 =?utf-8?B?aHJrT0RPVTRpdUVxclJIQW9CS1lQQ3FZK0FmeHJrbHkzdUdoOXpIdlBrTWhZ?=
 =?utf-8?B?aVdTOU5JdTNJSmdadFI1VllRQUFLdjJCSUE2TW9KR2JTMXVZMjVxUzgyS1NR?=
 =?utf-8?B?VGVxUWpjV0xsM0JKUXRrSVc1d1cydjRyM281RGxLcG5lNHBtU0ZKb0ZFckNG?=
 =?utf-8?B?bDNmb2I4Z2xvREhIK3NjcnJIaThIOXFjNk4vbXhXd0tycVdDN2E4bHVRRDZO?=
 =?utf-8?B?Q29XWEJIU2FBWDFpNEQ1S2ozVlphVExkTWNJMitPaTR5ZkNtc3RGY1BRN05F?=
 =?utf-8?B?SUJHUzd5cnhWT2Y2UHlHREhHNS9CRlRVV3UvNXZ2OUM3VlNtQUcxM1lqeFVL?=
 =?utf-8?B?eGFidXVHWjJqUmJrR1hyZVdnckEyN0h0TjBWdnNlaEgwbVlzN3lZT0JDMUo0?=
 =?utf-8?B?R2xTWDVKcGp2M2R1bVgwR3djbUd1UVpYbTZ6cE83QVQrYTlFdXcvdGhoeU1K?=
 =?utf-8?B?TGJZWUpzQ1JiWmdGTGtjeE80SFVBazMyb1BqUlRvMzV5RE81RDJ5ckhOZFRp?=
 =?utf-8?B?bWE0S0hYMnNXN0NCT1Urcm5DMGNwZ2tJR0lrMlpuN2k1SEpFQkxEM0ZRcE42?=
 =?utf-8?B?UzJlNGJvdE9UTFlVL2EyV3F6STFmaDJza0M1K1FWeEdSdVBFTVZJQ1djTng5?=
 =?utf-8?B?VkxGRjZsMDB6dTNmOXhaaS9mNFhBcy85L2Z6cnptL0NDa1BSM1JLSy9hdEJ4?=
 =?utf-8?B?eEYwenppUDRMZHd6K3lLSTZtSHpKMGxmYWRoSDJ0ZDluVmpaU1IxTGMwWHhR?=
 =?utf-8?B?YUtXaVA2NlN5bXR4aHRCZGwzS0ZsaElNRGlPM0c0OXdOLzJpZVBNL0dZZDkv?=
 =?utf-8?B?cWhCL2JTYm9qT0VtQ0sxS2Q2MXpTV201TzExWk1YbWtDaDM2R3Y0ZjBBTnJW?=
 =?utf-8?B?dmNrdUtNdGdvNzVyWFVTakwvcStTaXgyekY2eDV5MUo0QVpTejBnN09va0Jn?=
 =?utf-8?B?U3RkSjM0anA1U21yZVlKd0NJVC9iSWRpQmxCbktKdFEzWTlWa0pLTzF3M09T?=
 =?utf-8?B?RW53R2hCRG1nU1VYd2d0TnJKcUFWNVVMWlRnb216THlCTXBDRjkyb1VCdnFO?=
 =?utf-8?B?S0FkdnNqaEdTRWl3ZGVERmNEU2NMTGJVTHp3TVNkN2M4UDhheDRRdzVxRXV4?=
 =?utf-8?B?RjVUUGJOUVkrZDlaMzVqMjZhQm5sTjhwdWVnT0hUTzNpTmxWSCtYUVc5emw0?=
 =?utf-8?B?S1ZUczAxN0dSNWFISUtFbEFnMUtVTlV2VWdTTzJCZWo0N280QUlxNElyUXMz?=
 =?utf-8?B?TjBwcVdUZEplcldjcjNyNzJEdXBpbTZYSytFUXlkZmxHYmtUUG9pdzNFK25w?=
 =?utf-8?Q?/WSWewoidMwNqjAM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f77f1e-3735-4f91-5516-08de68fdb1a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 23:39:55.0985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZLjaOi1kQysChAFYtY0gaN9Pa6NyprjxBtioaMt8oRyJsl6obUN0NDF4eKos6ElzVbE3G7FSQaK48bkLV7u+fkJH5empqoSQ10x/SsHUow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5135
X-OriginatorOrg: intel.com

Hi Ben,

On 2/3/26 1:43 PM, Ben Horgan wrote:
...
> +
>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
>  {
> -	/* TODO: initialise the resctrl resources */
> +	struct mpam_class *class = res->class;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L2:
> +	case RDT_RESOURCE_L3:
> +		r->alloc_capable = true;
> +		r->schema_fmt = RESCTRL_SCHEMA_BITMAP;
> +		r->cache.arch_has_sparse_bitmasks = true;
> +
> +		r->cache.cbm_len = class->props.cpbm_wd;
> +		/* mpam_devices will reject empty bitmaps */
> +		r->cache.min_cbm_bits = 1;
> +
> +		if (r->rid == RDT_RESOURCE_L2) {
> +			r->name = "L2";

This code is fine but highlights that resctrl fs should not let the
arch need to do this since this name is used as part of user interface.

> +			r->ctrl_scope = RESCTRL_L2_CACHE;
> +		} else {
> +			r->name = "L3";
> +			r->ctrl_scope = RESCTRL_L3_CACHE;
> +		}
> +
> +		/*
> +		 * Which bits are shared with other ...things...
> +		 * Unknown devices use partid-0 which uses all the bitmap
> +		 * fields. Until we configured the SMMU and GIC not to do this
> +		 * 'all the bits' is the correct answer here.
> +		 */
> +		r->cache.shareable_bits = resctrl_get_default_ctrl(r);

I would like to recommend one style change to set r->alloc_capable as the final
setting. This is the setting that informs resctrl fs that this resource needs
attention. The reason I recommend this to be done last is if/when a future
change adds some configuration here that may fail then it should not fail with
r->alloc_capable as true while partially initialized.

> +		break;
> +	default:
> +		return -EINVAL;
> +	}
>  
>  	return 0;
>  }
> @@ -324,7 +409,8 @@ int mpam_resctrl_setup(void)
>  		res->resctrl_res.rid = rid;
>  	}
>  
> -	/* TODO: pick MPAM classes to map to resctrl resources */
> +	/* Find some classes to use for controls */
> +	mpam_resctrl_pick_caches();
>  
>  	/* Initialise the resctrl structures from the classes */
>  	for_each_mpam_resctrl_control(res, rid) {

Reinette
