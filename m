Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8636164A
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769018357; cv=fail; b=H0AaKwEOg+1yGtTSDfcB/UVvbNx+Nv7qjHYWGPnyEmK4lokl5qF01RIffcvnDPLHvwJU6ppXI40uBtaP0lFIXQF0qHddiHWxx5oaIa54ojpLf6GNpSqR2ur42RHyRh/UQNxBADaLQHPrJLI+p4P9qxQg8TWR2/Qpr9dBrJaKfKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769018357; c=relaxed/simple;
	bh=4eq3Z0aHUBR7XnLTED9EOxEvfPvR6fDG4h7J1jWfX08=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m84ElXCRif7MMvDp4YGz2A3mz20efNQbXt4323b5dD8TnzczIGgayrA5dAtHZM3CotElnIdI2+TqEGPYiYuEcmG2wXFN3ofN8CfwJOMWLk3vBUL+CjAhay4FnuPAIhPSovmZYmAlg0HzrLE/vmMX7snTtgP/YLOmu+l6+Msjtmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QRjuwFQi; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QRjuwFQi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769018356; x=1800554356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4eq3Z0aHUBR7XnLTED9EOxEvfPvR6fDG4h7J1jWfX08=;
  b=QRjuwFQiyif8EIPgEIfmWssAp+EhrQ8fmjay2TnhBebxphCehj5u8ndM
   jqBivQPvtB1iBqcdxYt5Y9JDihLqkNt4lpCYce5dK4XhcLzJQuWD9HGhw
   LJB21B/J1F2qmiC/1gURhJ8NjV/2rV2u901TnVbDmFNG5YPZPLcSJIED/
   ibpI6gf6ZJ47qS2T7LPdtQjQBTWtqfSuTtdMKAuErJuqgu9JKnZctS1qO
   EnIGEPfvQ8AdJHpQSq4CwJMb9UdOGDnlMsCLPpT7zmMWRuDKbsP2ASseh
   jVZ5pHie+oQIl8HuQXhATs4pMJ2rGTSZO2mOe5zFoTxZaWTUF+lLVp+LC
   g==;
X-CSE-ConnectionGUID: G9KGtrE7RjeDJkkbN8r6dQ==
X-CSE-MsgGUID: feQdAEfpQzuFQiF1sp0mjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70164606"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="70164606"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 09:59:15 -0800
X-CSE-ConnectionGUID: U2fQaFkUQsa7yVtoDhzQfA==
X-CSE-MsgGUID: HzA8A92NRSSL0GjOedjjqQ==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 09:59:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 09:59:12 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 09:59:12 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 09:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URYjl4OMSwBzYawkn7US1cYO+iHjQHw1BnCmx+0xWdxpBZR8C7q+WlhRrwh/v0KGH8hRuHyGQGDwuzZM1oiZGG/YcTv1gE+ZdTtGL8HlD1WgGdAfM8nYXz9SpYx3WLPFZXeq2xd5N7ndWmujjXmsgrajQLIgP2fMYcXXU6yK7IuGkMXTgUBSGHVrpE+Syz6vH+XNkXhPoQGEKm5vdZ93XbPmm+61xV6WyxtJBdaJTqpMbzQmZGYS3e8zqsjC5DcdXGPswioX5BjiQZ63BVIW47P4LPJiLGa61A5vNEzB2nwKSTjpG23UNmgqK1hKsEsJoZGqL1o8y/Z2f1WKDv1Rog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXmjM6FtJEaUjTVIgGJJR8eoJa9vpzopaxySSeX5OLI=;
 b=n4KihAnhjgeIKUMhdrgL/c8qlyZmf7bN4aS2aIiQVLtFZkkPsFo7SayoKllg1k/CDe5V96LYJMXXZ6FqMwxXOBjunHwinIcuTEH3pdE0KXiZH+t4nmWJgH6z4bYPLxgJN7xFzN6usK3K2bFVeAPAw0MK8oXe5fvSccO9CgOYWVrXrSLd5xyLoSX1hm5DnmmQrOCacZMk1G1dpYyQ7mZAA0gbDrxfHtdGyJarej0isYaOPozcwmYOmrILoXRMlbnH6Z9PpjSsXx3Ok8Puu4UYnyMd8/OPxiLoXO1hlcxXmBdlNNhZQj4ld57eItbMUxctmOR0A0fbTgTdqePKJ+Fz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7497.namprd11.prod.outlook.com (2603:10b6:510:270::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.13; Wed, 21 Jan
 2026 17:59:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 17:59:08 +0000
Message-ID: <8858c7ee-1af1-4bca-8ea5-ec62c78dcde5@intel.com>
Date: Wed, 21 Jan 2026 09:58:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/47] arm_mpam: resctrl: Add support for csu counters
To: Peter Newman <peternewman@google.com>, Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<punit.agrawal@oss.qualcomm.com>, <quic_jiles@quicinc.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-29-ben.horgan@arm.com>
 <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
 <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
 <f2e9d7e2-1f99-45e4-9cf9-49e1ce2f08e9@intel.com>
 <0eb7fc76-179e-4e55-b13e-78cea775c2ba@arm.com>
 <CALPaoCjK=VoYriKCGUrtTs=xKxkU34nnwxHKjjy6QVbmD99yhw@mail.gmail.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <CALPaoCjK=VoYriKCGUrtTs=xKxkU34nnwxHKjjy6QVbmD99yhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0074.namprd04.prod.outlook.com
 (2603:10b6:303:6b::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c391fb9-f16b-4901-e62f-08de5916c659
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MGVUZU9nYXlUejVqVGhUSEFsRE5kWE9FbUs3S085SVpwbEdZL0h5anQrWUhV?=
 =?utf-8?B?Wlovb1dDczZOaUF6UDZ2WTN2M3o3VTI4TEtBZzMrSERGM0EvNzU0cFN2dTF4?=
 =?utf-8?B?Y3BRWjAvbTB4RW9yeDBEaGgvVUtRSyt2NjV2c1VrNmNJQ2M4Um1xa3kwNkIy?=
 =?utf-8?B?YjdEUFNBZ0RBT01ZNXQ5RkpSODM1MFlwdkhGT1lKWjJndTdqc1grK2RRNTlM?=
 =?utf-8?B?YjlxTUxaWkVNSkVhbm9uUlJMZHk5T3A1eDNKbmp2ekNURmNCLyszek5OMWxr?=
 =?utf-8?B?Z0MvZWp5UU8rajRlTVpldDZwenFnUDVFVTNseDlUY1ZvNmNaTmdjRUcwV0Zz?=
 =?utf-8?B?a3c1SGhMVmRLNUQxdUgzYnlmdWo1RFVZTzhkSlBQYzNXQkgzVUpDTFRtUXd1?=
 =?utf-8?B?NUtvV3ExaWNVSVJzOHN6MU9TT2luT2xuNEF0SnV1NTRaeHA1cWptQXEwSnhx?=
 =?utf-8?B?U1ZUZi9TcU1kZ0VzZ0VaR0JQbzRqbXdTWnB2cmszMVROMGwxZ0xoWGlJeEN5?=
 =?utf-8?B?aXhRTGZ5dVVBY2xPRkx4ZTJLdGduODAwK3lxWk1TYy9vcEFpUXJTKzNIbVQ5?=
 =?utf-8?B?YStpYWpTc2NHRWpUVmR5UFozTC83TC91RmIwVEFxS1VxSXJ3SFU3VjVDcnBm?=
 =?utf-8?B?RFpjQk9ERnJJNWRab1RJMWViWndRL3N4ekFjdGFTUjRUV2ZGYUg3TXVjb1NT?=
 =?utf-8?B?Um1GU1FIdlQ2ek9DU1J1NEZsbGtjeHptY3oxRkdKZXBoSlhjR2pkM1VJcVJ4?=
 =?utf-8?B?SzBFclF4Rjk5aEoyUDJna2U3bnhLRGpTQncyb0RvRFNoVW1wc2VnVi92YjJp?=
 =?utf-8?B?b1RFdVpQZXZRL2J0V1dmQm43SjVjeEpLU1hGZThETVdzV1N3ZVc3V1A3VUp5?=
 =?utf-8?B?K1FSQVByaGlmZC82blNUMDBtMHFEUWpnYVdHWnIweDBJTHRhZmpCaHd2NDZn?=
 =?utf-8?B?YjRMbXdTeGRpRXRuN1ZGZGs0M1R3SmdaaGR4eUNSYmo4eFlrOUwwN0Y3Y20r?=
 =?utf-8?B?Tks5STkzZGxWc0c5OThMbnBqNERCQUtydlEzd2h0a2I3RER2TDMrb2Y0OGlj?=
 =?utf-8?B?YnVPSHhDUTNYTDFCNVVoN0dtMTNQOHd0WXZTTGh5ekxEWnczQkRlT2dmaitF?=
 =?utf-8?B?R2V0eTZEUUpkZUhGeDhBNGlreHo4c3AwUEZxeHRxQnNaZHpTeXFNYnYxNUg2?=
 =?utf-8?B?L0I1Q3VFMDV0UkY0ZGNwTHRSSFJMVU1xRUlSeFpORXZpVERKVEtkOWlCRnla?=
 =?utf-8?B?SEhHNFphVXJ4a3B6ZUZ3NlFMYk5FYzhHKytWb0hVMmE5Mjh5bGZFL1VCZEJE?=
 =?utf-8?B?N0JwSkJCRmlKUWk5Y0taZVdqTmN0eGwyaW9lS0dJR3d2SVcwSXBpcFAzbGds?=
 =?utf-8?B?WTRJUU9qWC9JVXhGMUV3MFFwNW5IUkltSmc5Q0NQazlRM0VMWG8rNnllOThr?=
 =?utf-8?B?MGI0cm5yaUlhd0I0eEFYS2VRK3gySmJOTlB1eU82elVTUDlmay9VbmdyTW9n?=
 =?utf-8?B?aHpRMmU5T2tJRHlFdWdwaDBGZU9uN3BLYjFIQ04rV2pzR3ZMQnBLM09Ya0xH?=
 =?utf-8?B?V25SVVorTU05aVROQVFrUS9iaDFSRGhPR1hTR2F0Z2hIN2VMQUlqM2sxeGJK?=
 =?utf-8?B?Y0MyemhHaVNjdFhBV0dNa3VzZy9WYjdtaHY2Z0puZW1EWUpNSUpwK1lkYXBu?=
 =?utf-8?B?WC9jZ2Z0TTN3QU9HMnROaHpqemRYeldnVjZPVUo3ZHdacWlrU2dzS3Q0bmtP?=
 =?utf-8?B?Y0tzV3NuTlViVlZIWHJxbVpYdE5ZdkU0aG9jUjVpUit6YitpeHN1TEkwZE1D?=
 =?utf-8?B?Q09XRjVPZDFGbjlNdW4vSlhGS0ZjU0lEUjNKU1Q1MTlnaWVkSGhweGYzR0VJ?=
 =?utf-8?B?RE1jdlFnZEJEY1ZuT0RjWmtNMVB4VmorRmhKOGs0RWRuZ1NQaGtyZnJzcG44?=
 =?utf-8?B?VHl3YitXMExZZTltOXVRall5NGxINzRGNXBiMTV2VlkrVnIwY1lLWkxPV1U4?=
 =?utf-8?B?ZDA4ZC8ycjZ6NTBGL01mVTZrNmkwYXBiQ2xHaWFUcElJTjdCWE4wSG1wYlM5?=
 =?utf-8?B?ZU1WazhOK2o4RWpIUFQ2WWNRdjc1ZmRYa1pnVGV6M1lKNVlvYW4zeXcwQldL?=
 =?utf-8?Q?CQwX3nPuB+ohoLhnWAI8ohIOi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlBDdi92bnl3YVI5L082SnhHZUtCMGtKNUFWdzFvbERkL0x1ZWpXek5XaW13?=
 =?utf-8?B?MXhaNEU1aWN5VWlXQ1gwYmJ1WDA4U3pvYndTS0h3RktVMjd2WnRselNPeFM5?=
 =?utf-8?B?Z1k1Vk5sYUtrR2hsakxWWFY5OVRRMHBudUx2d1hlRFI3ME5rOHlRYWRyTENI?=
 =?utf-8?B?SUpha3JuUVJBS3BGbU82ZlkxSWxIN3A2MURUa1RnOHBlVTI5alNHL0JzL2pj?=
 =?utf-8?B?QjVkelZKYWJQREhxZTZBajEyZmZUVk9DS3BhMkNZcThuYWhFUUxhOU92dGsy?=
 =?utf-8?B?ajVWaVJ3UnMzM2Rma1R1U3UwZTR0YThpNHJ5QWg3YUJJVENUNUtsK1I5TTRW?=
 =?utf-8?B?RkxhS2pZd0Q1UGR4ZEhqaDRwTW1xbS9wbWE3VjJEK2lCU3lxc0I4RjV5Z1di?=
 =?utf-8?B?WThra2duY2FvZGh1bC9iVHpiVWxsenRPaERhMVpvRE95RXZ3Y211RTlkSTVk?=
 =?utf-8?B?cHdjVTErL2pNNHF5dGRXbWRVbnhjaGwvNjN0aWNGS3BmUDJISGQ1Y00rbHhw?=
 =?utf-8?B?UUJ5TVFmTDJJbU54N0ljUVVIYXRxaUNyWXlaMklaZFZ6Szc4UWFHbHZXeUlN?=
 =?utf-8?B?VEw0TE1YeDNNRFpDWXdEU0o4UUt6dklQY0ZJai94MVppSlk0YnZtT0E1Y2pq?=
 =?utf-8?B?ZGFxa2cwZExkTytxUENHUjlDakFXZ1kwdmlVTDNrR3dzNlJYSlUxL0tVbFA4?=
 =?utf-8?B?bGVNNFVLbitsS0V1Y0VGQjV6bS9QNVJraGRUYzRtS3J3N0lXTnM0R3Bna2g4?=
 =?utf-8?B?RmluYmdpTVk5VTkzOW9CT2x3S3JsSndSQldzUStvb2lkQksvVjBzWTd2T2d0?=
 =?utf-8?B?TjRzS3JGNVVPRXMxUHQ2OGRqZ0FMd2V2ZnNQVU1HSGY1S1dXOWJnU0M2UThS?=
 =?utf-8?B?bUxxRjdLMHlTZ1p1RzlQeCtpT1FYUGlxaC9mdjlNa0VxeGQreURWZ2xvems3?=
 =?utf-8?B?R0NFdG0yRFJZUWdMTEZEWVBLdGh3Y2ZnWmt0bEJIUmVkSGhLRGtKOWVBRXR3?=
 =?utf-8?B?bnNxa0xOZmw1S1YvN3pycWkyd1ZCNDl4dTFOU0hxVkVvZlVSWGF2TCtqOG1k?=
 =?utf-8?B?RHRCcWdHcXA0dFRMRldKL0REejJtMnpGSjliS0ViWUo4V2ZsejE1SEhvbTZh?=
 =?utf-8?B?aW9SRnhscEpSQngzaU0yN0cyTjNkVnJTNXlza2FLcGZQbXdQeVo4OG8yTmFp?=
 =?utf-8?B?UXIwaXZjL2ZVbkt4SUJSQ0c4SFUyZlcyNHJ6WGkyY1VERWxNMjFoWStWVVBX?=
 =?utf-8?B?blpSRXlXb0pTOVRJUEJ0cnBTZC9YZmJCV24vOFFKMkFBOHIxYmpSTFM2aEw1?=
 =?utf-8?B?Nnp0VXZseGxzajVadWxsZjFBQVJmMWV1a3NkV1dZeXF0SE45Z3ozSkFDWnlJ?=
 =?utf-8?B?bmx5aVZCblNuRk4yekFiZk8raStrZURUaW51U0pTbW1xUStISFdSUENCTUU0?=
 =?utf-8?B?VXVVYXF3SU5JdGxhOGo5amk0YU9PcGErT0xDQXUwTmszRHA3MEMvblBrdWFn?=
 =?utf-8?B?M3NlaTRoY1NMNjZrYWU3clF2TTJsQ21zd3FXcUJsUVdJNkNNZDdZV3dlcnFH?=
 =?utf-8?B?aldYSGZrZGdiZFdPTVpvaXVKV2grUzY0cXJxOXovQURlVEkwNWF3VFpySmt2?=
 =?utf-8?B?elJnLzZobUtLYy9QeUN1V0RYa1pvVUptblBwdGpkY1UzVUE3UjhmZXUzOVVq?=
 =?utf-8?B?UnpwQjg5SzNUT3VUelEvanFEekZjaU1XNDJNMkxCTDBuQzFHT2lXOTVSS1VL?=
 =?utf-8?B?Z2JvS2k2TmRlRWxSYW8xTnhYK0h5NjV4RkZmZ3NkcGRyMFZBMVM5RVpzVnJy?=
 =?utf-8?B?ZFdqaE9SRTMxVjNDanJUa0NVcHE3UjdlN2JBa2pRN1UvSzBVbzZaYXNSWFhj?=
 =?utf-8?B?cmVoVFQ2ZXpVQUhFRjBqVlYvTmkwWDc0Ujl1Vkd0L2dPdHdmUkFwakdIUTM0?=
 =?utf-8?B?SzdJakgrTjJoSU1xODBCaXNJMXJIYzhrN2o2Nnk1dmtoVDJoYmk2a3p2TVhQ?=
 =?utf-8?B?YWVIMDdHc2JTaVBKb20rZHE4VmZMZEtjWDhjbGVmMjBHY2lja3J5MXFzQ0lW?=
 =?utf-8?B?V0czbTY3dmlkcGl5WExhdDJFTUZkQlhMMGUyUkhabGplcDZmNlJ2SElFNVRy?=
 =?utf-8?B?MUc4MkFCUkxPWDlBM0tCTWlQQWhuYlhFZWFVWnAzT2xqY2VsMm0vR0l2TkNu?=
 =?utf-8?B?cjR4YnpSazVQTXJGdDZNL2pQdWpQblB4cnphWnNrSVovY243TUhCZ2NlNTF3?=
 =?utf-8?B?TzlET08xS09wbk9hLzRFbFF4dUQzMHlTWVZHWXdoL3FxSDJSTlA0VjAyMWVp?=
 =?utf-8?B?TUxLRE5PY0ZGSHltMm5YYk5DNi82bTZCK29JRm42WlQvQXhRaXdWT0VqTnFH?=
 =?utf-8?Q?yQA9DV33y2fbq+/c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c391fb9-f16b-4901-e62f-08de5916c659
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 17:59:08.6548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hoEv8ogcaNse3yFoBNNVqli+U8WabCsRlA4bkFL23iLWVEUW+WXwFRhCx4BSqpRbKwTfp/mi3uME8sRF18hdfPDwSzXlCvEAKKBLtdlcoPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7497
X-OriginatorOrg: intel.com

Hi Ben and Peter,

On 1/20/26 7:28 AM, Peter Newman wrote:
> Hi Ben,
> 
> On Fri, Jan 16, 2026 at 11:29 AM Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Reinette, Peter,
>>
>> On 1/15/26 18:54, Reinette Chatre wrote:
>>> Hi Ben,
>>>
>>> On 1/15/26 7:43 AM, Ben Horgan wrote:
>>>> On 1/13/26 23:14, Reinette Chatre wrote:
>>>>> On 1/12/26 8:58 AM, Ben Horgan wrote:
>>> ...
>>>>>> +
>>>>>> +          /*
>>>>>> +           * Unfortunately, num_rmid doesn't mean anything for
>>>>>> +           * mpam, and its exposed to user-space!
>>>>>> +           *
>>>>>
>>>>> The idea of adding a per MON group "num_mon_groups" file has been floated a couple of
>>>>> times now. I have not heard any objections against doing something like this.
>>>>> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
>>>>> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/
>>>>
>>>> Hmm, I see now that 'num_rmid' is documented as an upper bound and so
>>>> neither 1 or mpam_pmg_max + 1 agree with the documentation.
>>>>
>>>> "
>>>> "num_rmids":
>>>>              The number of RMIDs available. This is the
>>>>              upper bound for how many "CTRL_MON" + "MON"
>>>>              groups can be created.
>>>> "
>>>
>>> Please note that this documentation has been refactored (without changing its
>>> meaning). The above quoted text is specific to L3 monitoring and with the
>>> addition of telemetry monitoring the relevant text now reads:
>>>       The upper bound for how many "CTRL_MON" + "MON" can be created
>>>       is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
>>>
>>>>
>>>> So, if I understand correctly you're proposing setting
>>>> num_rmids = num_pmg * num_partids on arm platforms and that in the
>>>> interim this can then be used to calculate the num_pmg by calculating
>>>> num_closid/num_rmid but that a per CTRL_MON num_mon_groups should be
>>>> added to make this consistent across architectures?
>>>
>>> Yes for num_rmids = num_pmg * num_partids.
>>
>> Ok, I don't really see another option.
>>
>> The motivation for this is that to me
>>> this looks like the value that best matches the num_rmids documentation. I understand
>>> the RMID vs PMG is difficult so my proposal is certainly not set in stone and I would like to
>>> hear motivation for different interpretations. "calculating num_pmg" is not obvious
>>> though. I interpret "num_pmg" here as number of monitor groups per control group and on
>>> an Arm system this is indeed num_closid/num_rmids (if num_rmids = num_pmg * num_partids)
>>> but on x86 it is just num_rmids. Having user space depend on such computation to determine how
>>> many monitor groups per control group would thus require that user space knows whether the
>>> underlying system is Arm or x86 and would go against goal of having resctrl as a generic interface.
>>>
>>> The way forward may be to deprecate (somehow) num_rmids and transition to something
>>> like "num_mon_groups" but it is currently vague how "num_mon_groups" may look like. That thread
>>> (https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/) fizzled
>>> out after raising a few options how it may look.
>>>
>>> Another proposal was to add a "mon_id_includes_control_id" to use as another "guide" to
>>> determine how many monitoring groups can be created but at the time it seemed an intermediary
>>> step for user to determine the number of monitor groups that resctrl can also provide.
>>> https://lore.kernel.org/lkml/CALPaoChad6=xqz+BQQd=dB915xhj1gusmcrS9ya+T2GyhTQc5Q@mail.gmail.com/
>>
>> Just thinking about it now but the "mon_id_includes_control_id" option
>> seems the best to me as it is a single bit option that along with
>> "num_rmids" let's you know which monitor groups you can create and if
>> it's sensible to move monitor groups between CTRL MON groups.
>>
>> The "num_mon_groups" per CTRL MON group would also need to be
>> interpreted together with "num_rmid" to know if it is a global or per
>> CTRL MON upper bound. This option also uses multiple files to give the
>> same bit of information.
>>
>>>
>>> Making this consistent across architectures is the goal since resctrl aims to be
>>> a generic interface. Users should not need to do things like infer which system they
>>> are running on by looking at output of resctrl files as mentioned.
>>>
>>> fwiw ...  there seems to be a usage by Google to compare num_rmids to num_closids to determine
>>> how to interact with resctrl:
>>> https://lore.kernel.org/lkml/CALPaoCgSO7HzK9BjyM8yL50oPyq9kBj64Nkgyo1WEJrWy5uHUg@mail.gmail.com/
>>
>> Unfortunately, it looks like we're about to break this heuristic :( At
>> least, until a way to get this information generically in resctrl is
>> decided upon.
> 
> We actually ended up going with the "mon_id_includes_control_id" approach.

Thank you for confirming. I was hoping we could deprecate num_rmids after introducing a
per resource group file but this does not seem to support all the use cases as highlighted by
Ben. 

As I see it, a name like "mon_id_includes_control_id" also implies that "num_rmids", perhaps
linked to a new "num_mon_ids" as Peter suggested in [2], should contain num_pmg * num_partids.

One concern from earlier was that "mon_id_includes_control_id" may be used as a
heuristic for whether monitor groups can be moved or not. Instead I seem to remember that
there was a plan for MPAM to support moving monitor groups, with the caveat that
counters will reset for which resctrl may need another flag.

> The property it represents is rather fundamental to what a monitoring
> group actually is and is a low-level implementation detail that is
> difficult to hide. Google generally needs support for as many
> monitoring IDs as jobs it expects to be able to run on a machine, so
> the number of monitoring groups will be routinely maxed out (and there
> will be some jobs that are forever stuck in the default group because
> no RMIDs were free at the time it started[1])
> 
> Thanks,
> -Peter
> 
> [1] https://lore.kernel.org/lkml/CALPaoCjTwySGX9i7uAtCWLKQpmELKP55xDLJhHmUve8ptsfFTw@mail.gmail.com/

Reinette

[2] https://lore.kernel.org/lkml/CALPaoChad6=xqz+BQQd=dB915xhj1gusmcrS9ya+T2GyhTQc5Q@mail.gmail.com/
