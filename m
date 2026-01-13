Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC252F3608
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768342775; cv=fail; b=UpCsrmA1xzv2+xd+lRPnsj/g9A8tWEjkWld3YgM9MWjkcwOuQysZR/YnBe8CdaJYvoKaweS6ko6ykvng6eSqBeuwkA0M2LMWZAbznPMg+Fbb5HtUveS1J1VlxJToFPZFnN91mVEvLJcyd7vmrVHtAXdKWsUOvLPMolMqA7xtFvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768342775; c=relaxed/simple;
	bh=qL9gcuo8umnhxF+PTeU5/x5XH7Evu5gmXADmbtKl7u4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i/dlIur26igCtw5K1FL8MWZahIaaDhgS2oY4cWAb4ol7ASmQWCGg5DVF0fWz0BQi23PEWp6Sb1cYE8c8tvv/iqXqmTh4++WjVnavhBuMwM9Zml7tZvabT48L9D0KswSBTHUhIUGTx5lXWp4DQQ7eZoFB3u3hhSIMGEShFI69qXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWtwiC+m; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWtwiC+m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768342774; x=1799878774;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qL9gcuo8umnhxF+PTeU5/x5XH7Evu5gmXADmbtKl7u4=;
  b=cWtwiC+mVJ2fJXghmWvD6bkKjRr4iJxUOO84Z8cmjVfRvFmw4g203Qf7
   vEFNxPZj65SdIUezH7JxBIAZAnaMlnbBQASGEb77Vwr51GkevrmFJauez
   CsqXVe+ap2cwb8ZOd+qyxJgq1IqyfRgA9532iypAvByp313xkidIOVm7U
   qC97Ggm2HZIm0ZoIRHbrRtAprg8WEOIv2jRMSNaWzNLIAQ2x4LZm+o4Av
   wqbfS2y6Lb3Hy2nQe5UtUuRrVNYI3uzeE3P8+fqUmwrdTzWXOBPlC3+xe
   zfrJjqpJbaFwHZfrOPxFBx3xf1QushHu0ro4JLMrIgsVUOn1EhJ1lsfmK
   Q==;
X-CSE-ConnectionGUID: ofBefmzsTFyBGojng6R9+Q==
X-CSE-MsgGUID: YvM+27atQAqgp3buMwGP1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="80360290"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="80360290"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 14:19:33 -0800
X-CSE-ConnectionGUID: Jz4jOFKAQcq7+REO+HqMbQ==
X-CSE-MsgGUID: 9AJ0epMKTYWlyqoeBJDKZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="209030668"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 14:19:33 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 14:19:31 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 14:19:31 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 14:19:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkNgEzqi5GNlVKSbxAbxNBR6Ar9drUvivO9vMJ7kOR44/lnA9VTjaTWwHxoN44QPQbGH+23e0bBNRMNVjZkIXvg70HERoedwHla1kUhFxNKm/ILOeUHS2VO+7qi/IZdjD8OtfBUFu3h1ahsTE86ZNK7Y4E/QI/ZPcJDnvEnis0T2vKK9lTDgfwAdfTJU8aAav2ZVe7R7rVC2yhKWCrde+bVO2zrc7cAYIjW1IYtHznJbWrcBCmVxiQBGvv8py8U7moUNdB9NQh90uvwx0SWMK+1p5ylkKaW0paZ1oKpMfsUH7YHv7M+kCrbPaXjnE9BLHWPR+JQx6Ef5WZ7mDV+OyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/U0fWtnqJfPO9QOGMxWQYPMN3lnCTPVy72s8Zg4oSI=;
 b=ZlP6JMN9APjZXQ3kk5A3EaSIXzjCFe1BdhThMEOV2l0WlmNmNRIozWg73s86erYIt1z3NlN9tt90glticmU+gWnVu/JWGDxdJ9quaP3RhJY7xs1+Ab9dToVxh1N6/BbOPOU61JTvh7h70CvKrRNwzwj1ejsu+KKLk5kBM6vjsVr3Mr1suixg9mh37dG9SrWCPC//iB+Wf1BWusfktA9pYz44H+C4OLqk4xcgXSNWYrHW/c7CfGYyUvO6w9OktN0XhpnFkwiZbE+vaHQHdxxCuqOlOf5BSJvOpf9jYAxXghazb0ZpbvsjiUWZjJ4qvG7UP2j0/Vrgr0M2Wa/g7dI2tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by CY8PR11MB7265.namprd11.prod.outlook.com (2603:10b6:930:98::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 22:19:29 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 22:19:28 +0000
Message-ID: <a48260d0-108c-470f-be72-1fd5235cf136@intel.com>
Date: Tue, 13 Jan 2026 14:18:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/47] arm_mpam: resctrl: Add support for 'MB' resource
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
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>, Zeng Heng
	<zengheng4@huawei.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-28-ben.horgan@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260112165914.4086692-28-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:303:87::27) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|CY8PR11MB7265:EE_
X-MS-Office365-Filtering-Correlation-Id: 87cc2b7c-65f5-4535-420a-08de52f1d13d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amRZVTlnODZydWtIRVF3Qjhid3FPUEpERzdLODZMNEVZTEV3WFBRdUgrZEZN?=
 =?utf-8?B?ZHRUMnRiUURsb2lJd1hod0RtenhDMW40czI3TFF2bURBdkpQa3l1N2pPNnIw?=
 =?utf-8?B?U0p6WTRkTG1UYnNnbzd6WHg4QktpME4xSUFNZEdOR2tPZnFDM3ZPL2pkcGY2?=
 =?utf-8?B?bjBndXlwZGxiVE43R3hQZEh6WVVEVFA5UWNpMldVU3VwbWN3QkNnRTJDcVov?=
 =?utf-8?B?U0xaMzd0NUEyVGYrSjJIRTlhenEwV0JtVGx4WXNQYjRxVDFJZG1XeEVhRTM0?=
 =?utf-8?B?YWo4SFFuM3dobjBmLytEQnZuQTRKUzJJb2xJbE5NanNTdWFsRUdQZlZkaVBH?=
 =?utf-8?B?TEJyNEwybFVaNVhmelRWbnV0WnV6TWladEVnd3RMMzBDbmhMTy9tNk9GRXZ4?=
 =?utf-8?B?YVQxb0N4U0FPR2dObDZEaTdoZHFNMkxyeU5XUjhEMGtNVWZObnFOK3oyc0lQ?=
 =?utf-8?B?WTJrc1FFYWZDN3kzUmlTN3gvMFJlV1FORUwra0srYWpzek42WWZQZUxmZGxw?=
 =?utf-8?B?eWtyblF0SjAzWG9IUjdVWGVEN3p6Q2pRdXVWYXlDa1ZaZFluK0lPQlRnMlRD?=
 =?utf-8?B?SnY1YnZvUnVWcTFwZDFHTnhzS0lsZUE0TFdzK1NrNEk4L21YblFjRnNiS0tw?=
 =?utf-8?B?OEpCQk1DS1ZTcGZZZEFQK3Q2YzZQb3RKd0hwV2ovSlFnMFViRytxalkyc3NV?=
 =?utf-8?B?MWs2MlBWVkxZWDY3bVhhQlZ1b2pmQTJUSy90dkJYWlN1V29mMS9YMWdyblFT?=
 =?utf-8?B?aXAwVzRxdTk4UEdQR3JwNzFDdktVRlBCUis5N0NRMlFxQmpLemtSSjkxTFVU?=
 =?utf-8?B?aW44WnNhZ2daVVV1THd6bFVqOWFOVUluVDdGbExWc3EzTy9lZzNuV0RDV3pJ?=
 =?utf-8?B?aUlPUXY0SndTTFd0M2g5aHVXOFZSekJmZTF3ejZkRVF1MjhzR3lSOXRUNUR2?=
 =?utf-8?B?NmlMNkhjeUxTbHh3bGUzM0xwQ3BBandxK0ZQdFJtR1dYZnFTVmsrMFlCQTRq?=
 =?utf-8?B?MDJYZUF1eElpblN0RTV3Wlp4d3B6MmNJbHhZWWl2VDZzU0o0czYraWRwU1d3?=
 =?utf-8?B?emxKVW9oQ1RPb0VPSGw3VkhqWVRCQ1AzcXJMbGJ3OGx1ME8zNUxjcjByOStE?=
 =?utf-8?B?MjNxMGV5cUFLTUVuMmtRd2NBTm1YeW5oVmpmeitWUVZWL3RqL09DUE51UzZO?=
 =?utf-8?B?WkFpaytoM0JzZERibWxkV1A2TmtPdzM3emZqa3VXSGhJNkVRWXFqcDRvRmtp?=
 =?utf-8?B?bTN0azdkUWl0TmRMTEI5RkN6Vy91eFRkbFhoVFJCWWlyK3VwbnllblNOejZB?=
 =?utf-8?B?UmxqRCtVRFlyd1diNzhFbkJna3BuUVhjQ1NRd21sR3UzaWpiQVJuN1JxZHJH?=
 =?utf-8?B?WGdmK0ZWT3RCVDBUbkxxNys0MGxodTZDWi9FMDNqUHFnYnJvS2g4Y2VsTEd1?=
 =?utf-8?B?R20xcXRSN2RJRFNnTTluVEJUS0gzaE5teCtFS0NVbTh4Yk44OHVDUDdLUytz?=
 =?utf-8?B?dis1TFFXa09oS1NVaHlaM0FoYWhEVnZyR3BNWmI1M1BDUnhmSEsvVjJ5NGk3?=
 =?utf-8?B?YXVOa0RyeGk2c3NWblBOdjdzdWd2V2V5MWhGSlB4TE8xSHhVWEdRYjBvczBN?=
 =?utf-8?B?QXhFd2Zkb2pPRFI0em0yZ0JydE9BQ29iNExXU2k0YXd3cHdBZFpXbU5xVEhO?=
 =?utf-8?B?U3h0ZkkvWkRxNFdzck5TcFR0UnByU0RUVGJPUi9nU0h3ZXFIZUo4VjNzSmZQ?=
 =?utf-8?B?K0VjOERIL0ZWeUdOcVZ2d1pITFpQMHNkQWx1WjdBdmdVYU9YdFFwTFlMbmlK?=
 =?utf-8?B?WmdtUHdJZnVUMWVlM3RoM0p1dUluSXVLdjdVMEJ2cTdFQnp6UmVNTC9iUFdH?=
 =?utf-8?B?VkpWM2V3QVo1Q0xsZHJhQmphUkJ1NmVrYncxTnEzSnlSRUMvMDBlUC9jdWtL?=
 =?utf-8?B?V1NqNVNSNlZNQ0tmMUp3MWZpdWtHTWlTL2Z1UnlTYnJPYzl0T05CeGJrTW5R?=
 =?utf-8?B?Mzh4WmxhcWFBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkU1SFF1RGZtUFVLUDBaOCtMUGF5VGZSZGdVSkp6dkUrRDI0VXRaUXBuRmNw?=
 =?utf-8?B?OVZ6Wk81SitDNnFVV0xiMjVrc1RUYlRKUEZyaEZGSFpTcUJ1S29Wa25SVkdE?=
 =?utf-8?B?bXlMYnNLcjhPenllcnp0a0s3YnpVd2czSHU5dHppZ1ZtOXpFa1FHM2YvL3hh?=
 =?utf-8?B?V01YbEtkNEVySGw5bTVZMHRpY3BYbU0yMWp1cUk3SkQrUHJsSlNEckJ4dUk4?=
 =?utf-8?B?Tk1tdDhtZysxcTd6WWRQdkJMVitsU1J0Zzhad0E3aFdxeW1CZHVxQW5LZkFB?=
 =?utf-8?B?ZXhmVkZFRUY5N0Mvc3N5aG9TeXdENjY4ZWFacHQydzNNS3Q4UVBOa1dZN0Vq?=
 =?utf-8?B?elV5L2I0SEFUSGs1akxHWHpmajVPN3Z2SDZhYjZxdGdpdm5iVmhmNjJDdGp1?=
 =?utf-8?B?OFpMYlNXQ3IvZjE1bU9ZcFlUanNaMy9OME5EZTZyai9SYURtSW1BdGtiMndQ?=
 =?utf-8?B?NytBOTZvK29PcG1uRW1vZVlnY2ZMSUFwUzRQV3VyS0cvcXpOcVRnVGpmbW4v?=
 =?utf-8?B?T3ZzRitXNUFiUjdsUmY0MGZOaGdSRkZrM0RDaFhaMjBDbVg3NkJ2QjlpSEQw?=
 =?utf-8?B?U1hXLzFlcWZseGJnbEhjN3BKMEw4cHo1NnQwTW5yd21Seno2K2tzT0VRUnV5?=
 =?utf-8?B?ODZkT1BrTkRBcVJIVkozSkRCY1YwT3RNVkdJV3RIK09MQkp3T0lVTEJvalVh?=
 =?utf-8?B?NmttN3QzTjJ1U1IxMnhNUVhXUnAyUjh5RmYwdjIwM3d1NTBWSUZRejlpMkph?=
 =?utf-8?B?eS9haWcxQkdxajFjdUErc0xHeXVGWDZUUUsyd0grZ20rS3E4WjR2SVZPenh0?=
 =?utf-8?B?ZXdLNlZCU25uNVBqVmRCZTFqWXNXTS96eWltejdSVCsra3J2dzdZeUJBOWVh?=
 =?utf-8?B?bXlJeEZadXcweUJQQVR2bzljUXhxc2ZYVnBNR3FvMlJMSkwzZFlNMlh1OGpR?=
 =?utf-8?B?ZkpaVXZmQTBwMHBLaUc3cHlVVTRSRGp2U2FHclFUWUdDVnhYMTNBWXhnMTRt?=
 =?utf-8?B?dlF0WkQxRWtUQW8xd25vd3VQWCs2cG5Vb1NaaStHWFA2NkliQUIxVWNDOUFm?=
 =?utf-8?B?eEROZXc5ODVMUmx2V3lHUEFNaGYyaXA4VndxVmJ0RkMxSlRkN2taandZZHla?=
 =?utf-8?B?dWsvVk1FZXoxSDB5RDdMWlErdmM0MVc3MTJCcnBKdHlwdVk5aGROT0FMZEZh?=
 =?utf-8?B?MTJKT2I3cm4zQVdWTk5SWFFoaEVvZnd1ek9YK2xOeVpua0E0bng2VWdnZlJL?=
 =?utf-8?B?V2JJTUR5cjcvSVE2WGF4L3NyZFdwUzVabGFaN01VSnQ5OStLcTRCU1JRYWdq?=
 =?utf-8?B?ZCs5UVVoWC9UZk11WDdFTmhNODNMYkJUN21qL2Mzd1I0VTdyS1RzeWhHQS8v?=
 =?utf-8?B?WU91U0lDa3J3VGpXMmw3OHFCME5jZzRJOXFwanhUcy9CQkk1ZldicncwL3Nk?=
 =?utf-8?B?SVJjTFVRaW9oNTNsdDVKa3E0QnA0T2tnTExvdUhJUDVyVlhaQnNTT0YySCtl?=
 =?utf-8?B?S2pWakR1cE93d21rQlR1Q29HNElLejNVLzRYOVhjOU9zdDZiaUloZzdiNCt6?=
 =?utf-8?B?RFFkdTJEc3pCNGpXaUIrZS92a05jTnRTTENFakw2NFAwK3VxOW12akVMTldI?=
 =?utf-8?B?NGs5VmRuS3hPNUJwUkFldnNORkhSQ2NGVlp3Q1hqU2lta2I1M0ppYmtiNk9J?=
 =?utf-8?B?akdqYWR0cHYzOXowSnIvKzNLOXpvRitMZ1ZFK2NkSnFsQmh6UUJqRlZaY3RL?=
 =?utf-8?B?RGVFUFFSQVh5NDF1amwwVjdkMFBFcGZoWTNxRVM3UGpjeFRINURhRTVBOEc2?=
 =?utf-8?B?Vkp1b2lobkV2WTAraExRQnc3RFZ2aG9IMFNHVGhXdXhIVmswOWo1cEk0TDd6?=
 =?utf-8?B?cllFamN2elF2WG95VnU0ZVo0UWxBK3Erck5URTUwUXJrUEZJU3dkWjJ2S2Zn?=
 =?utf-8?B?bkF1QVFtcjl3ai81eTg2czRxYjhLcitXSTU0RGxxZmhQYlNGVGJTWSs2enNj?=
 =?utf-8?B?SlVMQmtoQjlkTm04RjJtbjFpUUFuZlF0Z0xyQXZMbGx5MDdtNlZYMkRPMjg2?=
 =?utf-8?B?Vk5mbXlrVlphU3l6UEhhZUZQUCsyMWxDd21Demh1MXdlczlSUzk1b0QxS3RK?=
 =?utf-8?B?LzAwdGM1aGI3bEZvRmRJNTB1d3oydnh0TVdUd1dmME15TlBMeExiYnNsQXpl?=
 =?utf-8?B?aGV1Z0VRRjlYRWt5Z2lYVnpaOWRPWjg4QkpFWXdQS1lZY0FTZWdFMENGbUhX?=
 =?utf-8?B?WXlaWVo0MEJ6QitPM2pZdXhXVmtLdXlXTWQvc1ZGMjVxVHpLS3JIVG1QUVRT?=
 =?utf-8?B?Q0pLOG9GcEpkaUNsbm82a1hPbld3SjJEcGtkMktkWEp0RE1Ga0hKbWI1UzhG?=
 =?utf-8?Q?zddy4xQO4paKkVCQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cc2b7c-65f5-4535-420a-08de52f1d13d
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 22:19:28.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF+QgsleYNJESBeFe+gozNNERAvlV4tpytqJfW75E9SaTRiZlm0jwkjPncJ1tMsX0dAfafMKIat1Vl8IoqsC1PaOaVpjR0G8xPW2TD5kcSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7265
X-OriginatorOrg: intel.com

Hi Ben,

On 1/12/26 8:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl supports 'MB', as a percentage throttling of traffic somewhere
> after the L3. This is the control that mba_sc uses, so ideally the class
> chosen should be as close as possible to the counters used for mba_local.

fyi ... [1] enabled total memory bandwidth to also be used as input to
software controller and additionally enabled user space to set per resource group
which memory bandwidth event is used as input to the software controller.

Reinette

[1] https://lore.kernel.org/all/20241206163148.83828-1-tony.luck@intel.com/


