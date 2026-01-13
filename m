Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4424A05D
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 23:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768346204; cv=fail; b=BEhdqI24si6F26R3Q3uouNr8ZkuEhgnGV8yrkXoqSp+nru9sTbKkFmpRMgekIJOZ15h7RjlwdlCbcrA01Tqvl8lelZH2k325gS/hjuv1l858Mz85Io0fF6BidA4Mz+LDsKOGeMaI/Qbwp4thAChRbti3AENVbV8ZlcnQAXbZu7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768346204; c=relaxed/simple;
	bh=XadCUqe2ZWQefF2MdQbFZRap9Sg68KpW7m+TQr3QmYY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OCdiac4EjHOY3JzrIUGAIGVSTKE+1Gp62nRUXzcMzjaJ4VbddEczIfu2OdFjQ4xJCMC/ES31/50V+C+euTKupTC0FlFi7oXYTyXR/J+hcTBgnpBbGV9wiwJtC9MGMnqlw72ZQwHlJiRvclxsacAmrvNl16KdooJnLFoezbSHakE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gzqg6NSv; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzqg6NSv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768346202; x=1799882202;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XadCUqe2ZWQefF2MdQbFZRap9Sg68KpW7m+TQr3QmYY=;
  b=gzqg6NSvBBYOpeueryMsEJv5IpqEyFIP7v9DS6UJ2DT2MGx0h20OOT1k
   JLm0CQVYs7gWK8ImpL2yAuibcEUrYVMill14ZS9IVwszocWa378d8134l
   ycgtNj2Wqh/4jPazCOQRN+tlFUE1H30Ju9auGKcy7H5CWZCMp9kD80uGy
   JkJR39h46hpk/Kafwda7yCAR1yVMUaareoJnGdKeCDdNBgwWzSCAuC6uH
   3OZFtibTGf4Ac+AEA1ojWO+EVa5yKzHPyyjVJ1bqwGKHGIZ9Ssof1haZc
   RODrZ97dC9XtrSWnvBM4zthHjgapPkNn+YiAFeE/HAgpnEU0XjJzOpENo
   w==;
X-CSE-ConnectionGUID: t/PTPxpzQeCv7xNQ0QgEDg==
X-CSE-MsgGUID: It6FoXxlToeGDjm7zB6nXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69563268"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="69563268"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 15:16:41 -0800
X-CSE-ConnectionGUID: NWqIkZu1Q5G3/1ISElY8RA==
X-CSE-MsgGUID: mNvtZXwkR/mW3GUfzRbtew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="209360121"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 15:16:38 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 15:16:15 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 15:16:15 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.4) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 15:16:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGFuBvAt9MSDPTz7CdB8DKC3DJH56CFUa4qa6pY5IiBHBBEOhwofPAKCpk0tpME3iplBp2kyT3DuCmrPnD2pzxLauj2w5+R7qcafV0O9kKb1YoQonW7IpJJ/7WadFDJ5AneICOm/50bho9+slueGPuZFGPBiw3CzennIEfQmOl7XGxURadnR/GHymcLCPUw5VzfkwzvJ88ac7Pw+3OM7k5Tx55kUzk6JfImxzqIx6zn8qniQXzea2F/QWHrzNeuG1mZGrA57U0s1ARmTrIxkm1FBvGFpmhmRz8TpczfjAEAFpihlsa79o3ujGCvfwelmCg6JuEm5+cSjYc4vvIfhhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grIdRM0uyfP1t8KHqJwREeKo5jR3aU987h90BzhWuCc=;
 b=yakJBvRVqn+m94FPwIK+Rat9+xAyVwtcVXS71st+Ec8FuEBXZywsfe/IVqfYxu/9RkyDZB+ZamV6WiH+qHqZTIYTFN5EblLplAp+U0Led6Lk4Lls1GcehWITK76jjbQC6XMar7+7kPMIDgX6LWg6pcYoibyiTrXLUFsgAwKoIST4iJBIexB5vvO13vOJy1oIzVE7yxHWfAePQHaWvB1ygeDHhUNDuB1QUQiOaLlYjSzXtFlonpmPNxafNgILYkQXea2jRcKX7mIaJXAGECIqOsaiqaQi3fMTaRzFCb1d2PveMgWmtCdB+l2TPW9koOn+x2x3KmbbV4S3T2YaNiQuag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by CY8PR11MB7084.namprd11.prod.outlook.com (2603:10b6:930:50::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 23:16:12 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 23:16:12 +0000
Message-ID: <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
Date: Tue, 13 Jan 2026 15:14:29 -0800
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
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260112165914.4086692-29-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0201.namprd04.prod.outlook.com
 (2603:10b6:303:86::26) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|CY8PR11MB7084:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca6042f-a418-4c4a-3581-08de52f9be38
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UXJUUW1mSGZtZmZIeEhxaFNMTGIyK1RjL1ByY1dYaFdwcWpQK3psTjd4UU05?=
 =?utf-8?B?WXZYeUdlL3l4T2J0Y2Uwc001RjhvNzYzOWxrVzFzMHh2ODlmbHBhZFRSMmVN?=
 =?utf-8?B?UGtIZGdlOWtWaWIrTXg0VHliclg3ZGJQWmFnNEdUcXI1RWJQRndFOHhTNi9R?=
 =?utf-8?B?MWRwczlid1R2cVcyMGtwMGFZRUtrSWJScUZSNmdRT1NKM1pYbVNNNUc3NDlZ?=
 =?utf-8?B?cnhZZ091V2lnOWtVNE1kWGdRNzhieGxpVUozRzBIcWNEV3pkMkJtOW91Wktm?=
 =?utf-8?B?YkQ2UExqMGIwOTBKWndsZ1hmdWJZOEdRUGhVcjZmcFN3WXg2UUl4V040SWw1?=
 =?utf-8?B?MVVrVWtKbld0Qm1rZk9TWW8yNTV4c0xNZ3BXcUlib012V2ZxYXRSc2MwT21k?=
 =?utf-8?B?V3FmVzdNWkdGMmpaY25LdVJvM29MUGtQdit0UTFMaVFtOXRyUUg4VVJQaVdH?=
 =?utf-8?B?YmJrdjFablkyNXhwbXhQbHJtZlF6YzY5WU45UlFnTFV4WHQ0Qy85ejhhSTc5?=
 =?utf-8?B?azN0bFpaMWdiN3ZJWUQweEo1eHF2eGdIZm81M1ZzbWFCNHJuMWprR3BPbGpq?=
 =?utf-8?B?UWFtQ05hV2pyamJUWnNreERJcmFYOWZCQkNCa01Yc3VkTkFLZWQ2TERmTktO?=
 =?utf-8?B?djh3WDF6Njk4cmlRZ1RlN0d4QWRCblkvSVdpbkxHODBKWmh4b1M5VmJVMzVX?=
 =?utf-8?B?Rjl1NUNtZ1B2V0FMSDg2MUVhNC9lVzY4N28vd0pmckcxSU1tWjBMdzBDRWFF?=
 =?utf-8?B?VG1ISVdBUjAyRGgzVHgweE0wdHB5dTB4UTN3WThKS2U0aTNRTWJ5UURnZEVN?=
 =?utf-8?B?MXZ6QWUvaEh3aTNQcVpJN3BBUEw4SFp0cFBmWTRCb3hrZ29wbENZR0NqZE1Y?=
 =?utf-8?B?UWxDV1VBSjA3bktkdTFDQkh3TTBFNWVPdTZiODFGL2wwek02UlJROWJVSkVL?=
 =?utf-8?B?SHo4U3g0OFVKTGJPUWsvR2VSMzRIRUU3K2pJMkxLeFJudnlGYWJsR2VWaFlk?=
 =?utf-8?B?Rm9PRG9sL3R5RkUwVVpYb2VwTE1XRGJoNGhqdGlmbUR5eHJDN2EvQU9yL1Q0?=
 =?utf-8?B?KzArYnRVaS9ybUhiUG5hamE4eVhQR2ZRMFlWTTZ3a29qcVV4RDdsLzFUaVJD?=
 =?utf-8?B?RzNRRGJHZ3VzVGZDTWR5bUxzVnMvQ3FmUmNSaEtLMHNieHdIL1NWcFNZNENV?=
 =?utf-8?B?aEFPVVp0K1NsV3d2ei8weFROanpaSVZBMXVRdHZrNmRxTzB0MitReE5TMnF0?=
 =?utf-8?B?MENzdXZ1eU5TcnI2YzEyei9EVFlqQWVFNlh1M0IrcHlWdXBPTXZoYzZZMUVh?=
 =?utf-8?B?aW01QlQxeTVQb3RaVUVrQzVMbXd0elRPYVBDZlVDaFNrZ0tCNWZwcldYU3NC?=
 =?utf-8?B?WkJZVE4vTTZOeWFBZGh3cU4wMzUyV2FLSkgwQWFkUkNQRG5kdC9jcnFZbU5E?=
 =?utf-8?B?SDhvM2x6cXJXSjYyR2xBeGdBR25ONmtaMUQ4eCtNZlluZHpxMTg5cTBBbTYw?=
 =?utf-8?B?c2wzUU5zR1dTeDYxVlhSMmtJZk5ndVRvakkzMEdoVWdFbnlqcmdxSG9LN3Vw?=
 =?utf-8?B?eUFiTFUvbjhWaW9kK2J1MFl2bEtPQXRPY0M2azNrL3lCQ1c3dWdyVFl0NjNk?=
 =?utf-8?B?NWRMYStnSUJoZjdtRTdPZHJpRkd4RmtKazc4K0xCbUFFY29qbk13Y0V5RHdJ?=
 =?utf-8?B?b1o4cXoxam51SWYwd2dLV0xPNkNITmZaU2kxVmFMK0RJam1TNVNCSm13YVBF?=
 =?utf-8?B?cmxOYkpVSWs0V3plcTBESHlQNytoajArbGFFK21pb0xtT2NqVk14MWExc00z?=
 =?utf-8?B?YUErcXpwYTlWaWFjV3RLRStNMlpGTlFKa2ZUNEZsbEgrZHlZN1g0elpla3hu?=
 =?utf-8?B?UWl3QzNpWktxV2VoT0xtcGp2OGpFRERvajNnaTF4UDBvUE40dVhHYVk0bDFG?=
 =?utf-8?B?RU5WRWFoc0laY3NtYUh2SW5oZ3ZtaVNvZVVIWWdFK0xxZTkxcDZTUk5HaU9L?=
 =?utf-8?B?b09QeS9UQVV3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0lxWlB6ZlpWemV2eE9DT3dvQTB4K042RTNRQWRWak1mNW5HazFuVzBzTTZF?=
 =?utf-8?B?M056MDQrWkNXNU5IN1UrZkpZSFlNMElnT3FRZVRSL3RPOXRDZlhFV1VjeGJI?=
 =?utf-8?B?Uk9GR25EZVRsVlhOZGltR0NQejcxYVU5ajgxdzRUY2VlQ2VseGFhNDZ1U2pk?=
 =?utf-8?B?N2pkamFGcTVaVEpnSkJTdjc1dXEvQWVXNmF6ZDZtM0RuaVRiR21nR3pFUVdz?=
 =?utf-8?B?bkhCK0NWQVFxVlVFT0paZDVDdXdzVzJsY2J6eThFOWFFV2NPdWxNL3ozVS9n?=
 =?utf-8?B?RE93Ykc0UHFMSlNjSldiM1kyR2hKbDg3clhneGphQStCaTdrQTdVQzd5RTRC?=
 =?utf-8?B?QWhhWkFrTGErckhROGtVV1N5MHJ4RTg5RXh4VUNiT21HaHk1RXpWR3dTN0d2?=
 =?utf-8?B?U1l1ZzJzckJVenZrU0NJc2drMFFzdXNXT3hraDdFRi9zc1VrS3Mxb2EySjBi?=
 =?utf-8?B?YWc5ZkorZHM1eUdGL0FvRHZweXBtWDBWUjRMaWJ0MDc5MUlqRHJReGNRLzA2?=
 =?utf-8?B?OGxVMnI2WXhaaWx3TExTaTh3WW8yTDVSUXduMzQ1NVl5bWVjMFJ3czBHRVpQ?=
 =?utf-8?B?MHZDMm1NQ1puTlVLZU83ajFPaDlscFlmMlpzajBCb0pEZllSSW9Vem15Y0kw?=
 =?utf-8?B?b3h0TmlEVEJxZFdabGE4RmkrWkdSeU5la2R4TVNsQTRteUxxSzA4TXlVSkFY?=
 =?utf-8?B?b1dLQVpUSWVXemNUSkFkN1R4TFZEemo0Q2dZRUtIYWEzUTJhcTJKOUttU1Rq?=
 =?utf-8?B?aUdFY1VWekZQM0pOc1lhcW1OWGxMYlJIZnQrNTVvenhBTThUaVU3NFhrWlU4?=
 =?utf-8?B?dzdEaGNpNnQ0ME1ITTJhTm0wVDNJT0FvK21wbVMxN09YdDhXT1V5b0ZIYTgz?=
 =?utf-8?B?cXBwT0M2L0dTOEg2YXNpMjhMS2ZGT3VBcDRPbnZmU0Q5QmxudUVYaGpGWm9S?=
 =?utf-8?B?SGsxa1NvOWNRRVdzV0JmTjhoM0FOb3BnQjBrUmZhYnJTVzhsZkFEMXB5NXU5?=
 =?utf-8?B?U01hWEV3YUFYSlRaOGh6OUY5bjJMYnFBOVVHWHZWZWVYQ3FwR2xvZnh3Sk1t?=
 =?utf-8?B?dzdtblBvWTN4TWlSYlBvYjQwOG5Jd2xqbWFyU1pESEhzbTdwWmdSVElBOEVa?=
 =?utf-8?B?cnA5UlBuTHpqcnFsREVWdG9MYldmQ2xPdkxqeEJld3NYdkdSZEUxVVVPK1ky?=
 =?utf-8?B?QURKT0VlNHJ2aThWTUlPSFpxTzk2SVlBVGp1VXJsRzFUeC8rY1ZhOUlkL1F6?=
 =?utf-8?B?SFc1TUdmcjFIMm5nYzNLenV3RERYaUlyODZ4MFlvTWI5dUNyV3ZqZGFVc21z?=
 =?utf-8?B?TnNNeStHQUh3SDBBRFZzY3VySEExZjRjOHZ0Q1V5QXh0YVBpTlRzanMzRzFx?=
 =?utf-8?B?NEQzYU04WGxSVGF0aWFBbWlXUk9TLzVlV2FxNUthYnNvUFZiblJIdTRkK3N4?=
 =?utf-8?B?ZjVNZjk3cDdhOGdnajVNZUpSdzRsL2RzRUpucnJaSFBOQ1d3eDNSa2E5ZnFV?=
 =?utf-8?B?dm9HcWhUSzZoTmRHU2NBeDlKdmpEVTExU0grSjdvWnBVSnRDbXFEcVBoTDV1?=
 =?utf-8?B?dEpNcEwwbnVIYTM2WTAxOGZQOU5ZVmdXMjU0TWRxdGQ0M1RnNEk0V1BrbVZ3?=
 =?utf-8?B?Ykd0NGgrdXAyZnE2ZlJCSElRS3MybGVNenlXSHdhaGtrRUsraWEyNmdSRlp4?=
 =?utf-8?B?eEFpZGdQcjAvUXFUZTVOdFdFUk0rMDQ5NEN6S1QwcVBoMHJ2Q3AwUXRLWXJn?=
 =?utf-8?B?b2VkRGc1dmhxUXZ2RERPcnlsUTVSdzZQSlRkbWFNd2oxNWFCazFjTkhuQ3Iv?=
 =?utf-8?B?YTl5YmNXdjNqTmZiMXdwWlBrZVJNUFZEaEU3K1Q0aHBTM1pZMElGeHBpM0tM?=
 =?utf-8?B?d3d3M3JpTTB1dTh6WTlkelhzclAxcmtjMElTcGw4ZmpQRFRsQTNHOFZJYnBo?=
 =?utf-8?B?Q004dHlsUU9JSnl5NlB4TjBqVWRIYktqaEM1bksyYyt3VnQ2Rm1oUGdLak5i?=
 =?utf-8?B?NDk4NmZBbGJjUC9vb0VVMGNQdVJaaTFmTkxjejRKN0x5VG1TNmcrcVRObFNv?=
 =?utf-8?B?UVdLNWFCWnZhNjg5SzQxcnppNzZ4MTRGbnhrQm5oS1VCWDYzcGpZQXk3dll5?=
 =?utf-8?B?UElyWCtzVEo5eXY1d1VxSGl3MS8rZEhjSkptc0NDRTdtMk00bDJnL3BQUmxY?=
 =?utf-8?B?eTkzMitmVFZOZUlsc1JPUXlZUCtESFFjdHJGUTFjanBiRmtUUklTREo3MzNS?=
 =?utf-8?B?RXl5QjVuQzBEaGVUQlFSdEtkRTM5Uy9aUmRQQktpM0VVN09tQ1dFRUlOMTFn?=
 =?utf-8?B?T1h6Wkl4ZTQyN3V3V1FlK1FhTGYzM3dyejBHTVdFZS9ucXppMWJZMUFFUVNj?=
 =?utf-8?Q?/V2fXJW5wJmvtdLA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca6042f-a418-4c4a-3581-08de52f9be38
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 23:16:12.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpNxlt6ROxq2cbjYnDeookJcHyEwHeZWGgm1Wuk/hObcfmctndg7k5g6L97f4J4TfDj24EGRPUUmIg3NHttXPCJKSFFqH4Go2fGWZXWnI+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7084
X-OriginatorOrg: intel.com

Hi Ben,

On 1/12/26 8:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl exposes a counter via a file named llc_occupancy. This isn't really
> a counter as its value goes up and down, this is a snapshot of the cache
> storage usage monitor.
> 
> Add some picking code to find a cache as close as possible to the L3 that
> supports the CSU monitor.
> 
> If there is an L3, but it doesn't have any controls, force the L3 resource
> to exist. The existing topology_matches_l3() and
> mpam_resctrl_domain_hdr_init() code will ensure this looks like the L3,
> even if the class belongs to a later cache.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Allow csu counters however many partid or pmg there are
> else if -> if
> reduce scope of local variables
> drop has_csu
> 
> Changes since v2:
> return -> break so works for mbwu in later patch
> add for_each_mpam_resctrl_mon
> return error from mpam_resctrl_monitor_init(). It may fail when is abmc
> allocation introduced in a later patch.
> Squashed in patch from Dave Martin:
> https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/
> ---
>  drivers/resctrl/mpam_internal.h |   6 ++
>  drivers/resctrl/mpam_resctrl.c  | 173 +++++++++++++++++++++++++++++++-
>  2 files changed, 174 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index f89ceaf7623d..21cc776e57aa 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -349,6 +349,12 @@ struct mpam_resctrl_res {
>  	struct rdt_resource	resctrl_res;
>  };
>  
> +struct mpam_resctrl_mon {
> +	struct mpam_class	*class;
> +
> +	/* per-class data that resctrl needs will live here */
> +};
> +
>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)
>  {
>  	struct mpam_props *cprops = &class->props;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 7402bf4293b6..5020a5faed96 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -37,6 +37,21 @@ static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
>  /* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
>  static DEFINE_MUTEX(domain_list_lock);
>  
> +/*
> + * The classes we've picked to map to resctrl events.
> + * Resctrl believes all the worlds a Xeon, and these are all on the L3. This
> + * array lets us find the actual class backing the event counters. e.g.
> + * the only memory bandwidth counters may be on the memory controller, but to
> + * make use of them, we pretend they are on L3.
> + * Class pointer may be NULL.
> + */
> +static struct mpam_resctrl_mon mpam_resctrl_counters[QOS_NUM_EVENTS];
> +
> +#define for_each_mpam_resctrl_mon(mon, eventid)					\
> +	for (eventid = 0, mon = &mpam_resctrl_counters[eventid];		\
> +	     eventid < QOS_NUM_EVENTS;						\
> +	     eventid++, mon = &mpam_resctrl_counters[eventid])
> +

Reading the above loop and how it is used to call mpam_resctrl_monitor_init() for every event
it looks like there is an implicit assumption that MPAM supports all events known to
resctrl.

Please consider the most recent resctrl feature "telemetry monitoring" currently queued
for inclusion: https://lore.kernel.org/lkml/20251217172121.12030-1-tony.luck@intel.com/

(You can find latest resctrl code queued for inclusion on the x86/cache branch of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git)

New telemetry monitoring introduces several new events known to resctrl. Specifically, here
is how enum resctrl_event_id looks at the moment:

/* Event IDs */                                                                 
enum resctrl_event_id {                                                         
	/* Must match value of first event below */                             
	QOS_FIRST_EVENT			= 0x01,                                 
                                                                                
	/*                                                                      
	 * These values match those used to program IA32_QM_EVTSEL before       
	 * reading IA32_QM_CTR on RDT systems.                                  
	 */                                                                     
	QOS_L3_OCCUP_EVENT_ID		= 0x01,                                 
	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,                                 
	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,                                 
                                                                                
	/* Intel Telemetry Events */                                            
	PMT_EVENT_ENERGY,                                                       
	PMT_EVENT_ACTIVITY,                                                     
	PMT_EVENT_STALLS_LLC_HIT,                                               
	PMT_EVENT_C1_RES,                                                       
	PMT_EVENT_UNHALTED_CORE_CYCLES,                                         
	PMT_EVENT_STALLS_LLC_MISS,                                              
	PMT_EVENT_AUTO_C6_RES,                                                  
	PMT_EVENT_UNHALTED_REF_CYCLES,                                          
	PMT_EVENT_UOPS_RETIRED,                                                 
                                                                                
	/* Must be the last */                                                  
	QOS_NUM_EVENTS,                                                         
};                                     

...

> @@ -582,6 +677,57 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
>  	return comp->comp_id;
>  }
>  
> +static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
> +				     enum resctrl_event_id type)
> +{
> +	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
> +	struct rdt_resource *l3 = &res->resctrl_res;
> +
> +	lockdep_assert_cpus_held();
> +
> +	/* There also needs to be an L3 cache present */
> +	if (get_cpu_cacheinfo_id(smp_processor_id(), 3) == -1)
> +		return 0;
> +
> +	/*
> +	 * If there are no MPAM resources on L3, force it into existence.
> +	 * topology_matches_l3() already ensures this looks like the L3.
> +	 * The domain-ids will be fixed up by mpam_resctrl_domain_hdr_init().
> +	 */
> +	if (!res->class) {
> +		pr_warn_once("Faking L3 MSC to enable counters.\n");
> +		res->class = mpam_resctrl_counters[type].class;
> +	}
> +
> +	/* Called multiple times!, once per event type */
> +	if (exposed_mon_capable) {
> +		l3->mon_capable = true;
> +
> +		/* Setting name is necessary on monitor only platforms */
> +		l3->name = "L3";
> +		l3->mon_scope = RESCTRL_L3_CACHE;
> +
> +		resctrl_enable_mon_event(type);

btw, the telemetry work also changed this function prototype to be:
	bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
				      unsigned int binary_bits, void *arch_priv);

If I understand correctly resctrl_enable_mon_event() will be called for every event in 
enum resctrl_event_id which now contains events that may not actually be supported. I think it
may be safer to be specific in which events MPAM wants to enable.

> +
> +		/*
> +		 * Unfortunately, num_rmid doesn't mean anything for
> +		 * mpam, and its exposed to user-space!
> +		 *

The idea of adding a per MON group "num_mon_groups" file has been floated a couple of
times now. I have not heard any objections against doing something like this.
https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/

> +		 * num-rmid is supposed to mean the minimum number of
> +		 * monitoring groups that can exist simultaneously, including
> +		 * the default monitoring group for each control group.
> +		 *
> +		 * For mpam, each control group has its own pmg/rmid space, so
> +		 * it is not appropriate to advertise the whole rmid_idx space
> +		 * here.  But the pmgs corresponding to the parent control
> +		 * group can be allocated freely:
> +		 */
> +		l3->mon.num_rmid = mpam_pmg_max + 1;
> +	}
> +
> +	return 0;
> +}
> +

Reinette

