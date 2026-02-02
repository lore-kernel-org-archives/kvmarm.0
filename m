Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012010.outbound.protection.outlook.com [40.107.209.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B4437F0FD
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770050072; cv=fail; b=QUxPEAW7QHg8UZdGfUIjZxzvFoIh3gKXAB3AtelnDXCFwc7tS/USOOq6J71vPYgiUJhIwaL7OMRqKU/f8xLiAwCG5MZUT9kgaB9MHgTNsheQGda++Embukmw3dhfaHVKpmfME7MxrtAQQ7h5OaZrTPqawsTzc7wceRJbX65qg5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770050072; c=relaxed/simple;
	bh=xx44l08CwyrkVlS44RHyjzqo6z2/7fuYfD9UzVG+1sQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aPek6AlR8hgJfChlrBMeqMNoDPI7yhs28zdULSDIX8EN0bMFHc0c3RFUdMUngHkZTrWwxZBILs1IaijaBnAQtUxv0h9Xvx//t+4KEI1kGpDhhJepG8objmOyi+cWgTYFjqsTNLjhODzUffw+WIpDvrzxi/rxZbL1BPm2cDYzCG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F9/vJimX; arc=fail smtp.client-ip=40.107.209.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F9/vJimX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSqTRA4FykuAaHtgxst0s876cujlK33lNN5T/IKm9bIsqQDhsp+B6Z2Qt2qegIrS6Kru/4Cvoumm4lUp6FdvsqrNye1D5s94vpo7VQLNELH5uHXGeOuL2paDltBGw+2Gr6hqHHn53oDCpbXAJbRI/Q25E6P6mdsG37yQ3ZOmmwyQIBpzP0xt4VLoIx/qxEBLu7NGo6pO/D2SdI/hS+O5udaUS8+uSTJfz8TyHzArX3gwyDO3iZqnkZRMtJbzTw6CzlzlUrdl16TjuD5KfOHZkH/eTeOst9Gv+4sV+HVunmfCa5naqK8m5ClOmMYFi+Ysnc1ZOVbxqN0em9Wfj/JHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl7EkXOgD+100zX4ZW3J3Gvk5e9W9WMYinY4EGQNL5c=;
 b=ghcNLk9yrMu/TLH1jCHwOYdtOpvN0Xb2QybpPQSlFDXxIEKFipYmpNJy9UuU4U3jQ0MherZyuOsp9Jxkmw3Kju9pGTGxvIgiXW+mI/TxHFDaA+QJpILQRRjwJ/QSQZmgjshmvFg1KbnkA+Ci5ciZzDts1x6ekIxfEDA2fEK2zclSppIldj7ORcjPJzJzEMaLKMCZYTFYXJXWg3J0+7VPIZXnUCecYI2SYqPB0dy6cOKQFTXZF2DcugTfOL3w5ixpR7P/l+Lb2PVli9ASDV/Mtxcgdt5DJbMZN7TJ6jCjOHgcfdhS7mQkYIo/3J/7j5tvWo6X41gSLBPRx1vHiLJlWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl7EkXOgD+100zX4ZW3J3Gvk5e9W9WMYinY4EGQNL5c=;
 b=F9/vJimXZp3nJRV4LADwlwepXKdOR9WuHKvoXJ2pnniJTLDqUSKVQkyU9lvsc2rt+XBfGe/rbLseGQ1+gpCWovpSnvtm/Zs7002tnhYZBteMQ0hUnDvLQaG+yLnm06RPihh/1GeDCYge79nSH2Cg1zsZpQoau9CP6somLmCZNEkeiXhOv7hU2yBGoNAZkiV31YzUrIFNxt0aMpB4SQnX4fkSJhGIgjbc3Jq/eEwJYt69CmC+Zlb9AQSNIMLtqhIwDtpkq5xOc1y8XdVcBVC+c9UD3gp6j8UHTtNLoTg/7m42zZwRsPunjXso3XuMXJKpP0rY1LC3G9e5eUW6bctzWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9506.namprd12.prod.outlook.com (2603:10b6:208:590::12)
 by CH1PR12MB9696.namprd12.prod.outlook.com (2603:10b6:610:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 16:34:21 +0000
Received: from BL4PR12MB9506.namprd12.prod.outlook.com
 ([fe80::1250:4d33:ce3a:82af]) by BL4PR12MB9506.namprd12.prod.outlook.com
 ([fe80::1250:4d33:ce3a:82af%3]) with mapi id 15.20.9564.008; Mon, 2 Feb 2026
 16:34:21 +0000
Message-ID: <ca45ea06-53fa-4010-86c6-66213243b636@nvidia.com>
Date: Mon, 2 Feb 2026 10:34:18 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
To: Ben Horgan <ben.horgan@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, tan.shaopeng@fujitsu.com,
 xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Zeng Heng <zengheng4@huawei.com>, jasjits@nvidia.com,
 Jason Sequeira <jsequeira@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-42-ben.horgan@arm.com>
 <20260113153938.00007d6e@huawei.com>
 <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
 <9e01328f-7f28-4b43-aaf4-59d3ce80c268@nvidia.com>
 <3ae02b5b-22ab-4778-a29d-709ca3163f58@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <3ae02b5b-22ab-4778-a29d-709ca3163f58@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::30) To BL4PR12MB9506.namprd12.prod.outlook.com
 (2603:10b6:208:590::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9506:EE_|CH1PR12MB9696:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bf22cc9-e189-4092-d465-08de6278eb09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzBBRU9VczhTUzEvUmlBdjRXT2RXMUs5ZGxSSElKOG5aTVlib3p0c3RBNjlP?=
 =?utf-8?B?RlB2WkVBbmptYkMwd2I0SWYxZGltOGRKZ3dkSjd6ellOR21JWEdSeVpmSnli?=
 =?utf-8?B?Mzh4ai9BM1lYVzNnb0VVL0FIUVAwTVZxTXUwRGdLdkZsTmdLK0JjSlRCcGow?=
 =?utf-8?B?ajN4dEdOTFpMVnE5SXl4aEF2MEd1Nmw2U2dKckdOdjZQUFZQY3Q0b0VtOWlq?=
 =?utf-8?B?ZG1jNG1NT3RCSUN1K2Nqa0lVVTJWMTBwVWFFTXZia3kwTTVMbUt0R3ZIbFRz?=
 =?utf-8?B?VHpsaWplNW5QOGo3TDZmMGcrWjMzbGJudGNZZ0lMQlVGbnRYZTVrdnE2bGdF?=
 =?utf-8?B?YUFNbjQwWTRWUVR2NTl1amQrUFRCSUNrSGY2bkxIN1pEWmpWUVhLaGRGMmFX?=
 =?utf-8?B?elMrZ0lvNld3SUd2WjVXMUJHemg1ZXI5NmFNOEh1ZzVqMmk5N3NLcHl6aTlE?=
 =?utf-8?B?dW1VWVJubS9vdkVwSUJHaDA5V3U3YjdhZjdOT2Vpdk8zdjBjSHlrVjVVcU42?=
 =?utf-8?B?RFF1MXdLb2R0d3k1eDBCV28zZlFIdlI4b2hoV1cyVzAyYllZTTJ6bThpVEh1?=
 =?utf-8?B?a1FlMjJSWDRkZjFoOFZ6Z3FLajRnZkxOTlZLOUlpeXd1NWhlZzBnOEdCVXAx?=
 =?utf-8?B?bFptWjVqQVBzUzIwSHVUNEkvZGFtbk5wRmxUV052ZDFmbnVXY2NmWWsrUjZJ?=
 =?utf-8?B?WnZRV3JrT3I1UWFJbEROdWtnbGkySWNqa0pZWHV2eE92K3pYVStGblhtQkJF?=
 =?utf-8?B?bUpDTXlab01aMGwyQ2JwUTdNU0VveDBHZ2NLSWNFK3cxblZVTkRPcGw4ekRr?=
 =?utf-8?B?WXhxNkpwOWxkRjE2K0NCbWxDZ2MreVczTTlTTDd1d0VEb3RsTjJ3bTFGanh0?=
 =?utf-8?B?MUMyZlMzTzNRVE9CSnRFdzhheTNEMERXbWdXMWlWUTh1VkJlRWZBM1d3b2ZL?=
 =?utf-8?B?ZU9Ob1VmelgyMjJaTWNaeG5NbFdLVXJwdXZrcGR6Ym8wMHJnalV2OXJjWEQ0?=
 =?utf-8?B?MVlkZzZWWnFxVHZqSXRYSlZiOUYrVW9vVEVVS0NNcEhFanJRNkxDZUtaV3l4?=
 =?utf-8?B?SVlNTHFuamJzZWNsWUlYMHQ1ZzBZdXJMTWVaNFc2bVg2SCsvY2JHUGZmZE5W?=
 =?utf-8?B?Y3FlTWU3VDB1TDJEOVl2OXNiWHlGaWZIMzBYOVZxMnRSWHVtcDE0Z3poajN2?=
 =?utf-8?B?SzBtajdqbXRmVzNsUUFvOU9PWjBjaVRmSnNXUnZjbXFzeGI1UGR6SEUxd0dH?=
 =?utf-8?B?MlVLOVZtcURHMThmNXFnY1NNd210cWkrdHAwUEVxd1FzV3VQQkxseU1hY3J0?=
 =?utf-8?B?S1Q5UnhvTmhSODJueER0NUMzTkJVRi8xWm5GV25adzgwZWdOT1pIc05zQWZz?=
 =?utf-8?B?ZDE0Z0xqOUFkT3VLaXVQaXM0ZVZ2d1lPVmFEWDRjKzBoaHdaRlhNNldNQlhs?=
 =?utf-8?B?dHk1aVZyY3pBZnJnN28vcjQxNXRvOXpYSmkvNit5UkoweGJPNHZmNXRLcThO?=
 =?utf-8?B?UXNlSE5ibTAzL1ZiU29Mc0xTcVRscldhQ09PQ0hNa2RxY05PSmMwdlViYTFt?=
 =?utf-8?B?VDg3UW11Sk5CSW16QWRZUmtpQ0tndmc2UnlUeS94OGFIS2hsWG8zSnpFZ3pm?=
 =?utf-8?B?eWx6VFFyYS9pakNoWnJCMXhJNFdOTUtTcC9mcXBJSklJZThvMEV1Q3hTRmlF?=
 =?utf-8?B?bmdoYWc5eTNOeXkxaWl3QnRKY0xNeEtwT1hHS3ppQ2ZVTkNjOGx5ZmpXZW84?=
 =?utf-8?B?VWc4VXBHZzU4UllZZThyQWdRaThFUWJpVjZTc3pIZEgrSmplQXhXSnJFV3lB?=
 =?utf-8?B?RDJKbURnMEVsUTZKWTVCdjk5VmNzTmxRQnhycklwTEo0WlRpNE5EZGorakZv?=
 =?utf-8?B?LzJQY25BUzBYTERDSjZXQzhUMklPdmRzZjgzZUVsYWRxMlRXU1JVTmN2UmhC?=
 =?utf-8?B?WWt4SmM0MlYwWXZlTGE5S2ZwTjg2dU1QZVdySWFjUTJqZVBrZThEdElWVzBE?=
 =?utf-8?B?dGkwOGl0UVRDQmNqcVJFSXpiVllYcUtKL2ZNcHVLaVZ0T0dQWlBVd3QrUFgw?=
 =?utf-8?B?cGNMbnRFeCt5SHBEQUZ4V3FzbnZ3Z0xlSDZzc295dTFueDFVNXlTZDVxaTlE?=
 =?utf-8?Q?3ukY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2lMZEpqRjNLQi84Si9ETkcybm5HcUhoTnhNd0p0Mm1WZFN2STZ3SmYzUGpj?=
 =?utf-8?B?Mzc1SzhFVUhjbm1CSkgxdDRqUkZOdGxIWmlIcFNsMmhKQ3VqUXo2RkdCUVNL?=
 =?utf-8?B?Z3dBUVdTQjJVRHFkLzMvazNqREpqajN4MWxvNW5jWUVIdkNoSzhzTUpnWHNT?=
 =?utf-8?B?VDRUYzNFclpGL1NYcjZhMVVnNk9VRnNQL3dRc2xDQ0VuTjYrWktmd1VqQU1J?=
 =?utf-8?B?RUhudzBMdVRzSzF2NXJHRUttQURaNTNTRm85SWJoZUxuTy91bklWem41cFpQ?=
 =?utf-8?B?Z1BVeVhFdFBPaTIxaWJteFI4aFpjbmFNeHI1SkNIYzNiSGh6ZUFiK2RBanhL?=
 =?utf-8?B?MmtqalFTVXI1RWE4Mlg0MDUybUNsRDNJeWQ0OEgrczg3dVhRd0hMWThYQ1hN?=
 =?utf-8?B?WDRhMGI4L1hoR2JnaDYwbW50d2taRm1KUmNISS9qdkVCWis3a3ZGamdQY1lR?=
 =?utf-8?B?c1lKeGk4QVdGcGtaQlRnQy9GaG1mZHpEVk1lZkM4VERGT0k4b3JJV2dFVzZT?=
 =?utf-8?B?dnJiNkc4dVplZFc2ZCt2b1lRdUEySkZzZEJ6a2FkREZMWTZVSjRWVUpqdlpk?=
 =?utf-8?B?NW1CSmZ3TDRjbURHQ0szTzNXZTJheXM1UHdhVkFBVlNjd09OSmRjUFhVTmQ3?=
 =?utf-8?B?ZjBOdmpBMzl6SDJHYWN5eTNsWnp3bDYzc3FLeWlaR21JY0hERWpHVXBqWmNo?=
 =?utf-8?B?Q1dRbG1CczFHUU56NG9NdFdJT2NqbjIwamhzUmF6RGlQbkwwZlF1M1BEQVFK?=
 =?utf-8?B?b1h0MWo0Zy8zSjZKS21DVGdmUE5kdE51M0Z4MmhBOTlBSG9GamRiNCtHalU1?=
 =?utf-8?B?T3JmNk5BcFJ4QU4rNkhCS3RmdFdNVDh4VHZPV0xiK3JaaVQzY1FLbk1xSWhi?=
 =?utf-8?B?dDU2ek9icGJ6ZExVL1VnQlBPdjRuajh0THhBeXZvRlh6Y2w0TDlmNmg5SkpB?=
 =?utf-8?B?RmE2QkJ3WFB1Sjl0ejJieE13QnEvZUhTSEhFL0JESmdVUEFSNkZOVmRqU0lM?=
 =?utf-8?B?UzNqVE5ISkE2QzNvTDdYSk1WaFhyL1dRSStvaXU4b0hwS1VDZ3dPdXN6VjRT?=
 =?utf-8?B?OU1JVzdtOVVPOFZwWHZFZzFCUWxQdktIeGxQOGYwZEJKb2d4WVprRitpdGQ5?=
 =?utf-8?B?UDdlcWFSVmtFN1dlb1QycVZLaXVsNmJEWmpkUDNuSzEyUlRtRlBaeFlFQzdU?=
 =?utf-8?B?Wm1iNCtyQVNCenNNajJidkV6eEVkV3pSLzduUlMxQk1sRzRpVCsrK2FmcnBv?=
 =?utf-8?B?L3JYamlBY0lmMlV5bmRxNnZ1TEt3aDhKSGlEOW5Xc2pDQmVpN3VKM2UxWWN2?=
 =?utf-8?B?dnY3eEtoVWVwdytGeng0Q1QweUxkZ1FFVy9iWHZLOUxJOVIveXdwS1E0Y3pl?=
 =?utf-8?B?Mjcrbm1FUFArZ3dVNjZWR2NabWpUOTA5NmVTN1pjL2pwUGlHd1YxN1poWnVu?=
 =?utf-8?B?V3hXZE1udC80eVRTRmdvQllZUGVEck9oeFZKWkZFeE9TKzF5c0dETDdRblE3?=
 =?utf-8?B?K2RUM05BQzJOZ3dZUlZmcWs4ZDMveGVqRy8xck05VngvSEFYcDdkZXNaaDd4?=
 =?utf-8?B?YnFiWTNKT3JDaWZkVEJ6K1lSR2dMN21TejR2bDFuM1BHVHJzbGZybno3NVdq?=
 =?utf-8?B?MUwyY2F1bEVyYkI4SzZOcU9ySXNZbW5mWHVTdVVoa1ZQYUVmNlpxMnBXTXpj?=
 =?utf-8?B?UGMySUMxbEFFMjIzeVRRcVFLU3J0V2ZkQ1Z6aDFWZk42bksvZjlVTUlCTmx3?=
 =?utf-8?B?aEk5VlF3U21lbXJ4ZjZiRG9tTGVXYWliU2xBaTNjanJCU2VqcUNabzBWemRP?=
 =?utf-8?B?MUsxWEo1ajc2WGdlanZTWVZTUU1nNDZyeU5PNndaSVN1eDN2Y04yZHFsSjVG?=
 =?utf-8?B?OGVjR0EvOUlISFZ3WFBCVUR2QVkxeHU5emFESDI1eDBiUW9UNythakljbDhP?=
 =?utf-8?B?REpBdGlaSjl6SXhTRkprMHRiSmlvOWxTRnBCWkx3SmdsWGIxZTFZclVvR0U2?=
 =?utf-8?B?REluak1tdzE1dGhHOUdXKzRWM2xJSGRWV0EveWd1a1JKeXlQQ0w1ZlhpVE05?=
 =?utf-8?B?SlJDTXVxQVhWNjVtdmtBSzl2dUFaSTVMaUpqeUZpcmRGOFUvVHZyQVlmWm0v?=
 =?utf-8?B?MVhpNnhaNjh2TnZyUmZoajkxWmplMVpYaXRtMUMxU2pJMFFQQlBaLzVpc2lW?=
 =?utf-8?B?V0tOK254T3RLL1hsaDJ3Mi9QN1FUWHlSdDFCWnVoWjVHdjlkZys0bUVhVUFq?=
 =?utf-8?B?NzUwY2tLNUp0UHVNVEQ5YmFtMGVOZTMvZ1JHeisrZDF1Rmk5eC9ROG4vVkZI?=
 =?utf-8?B?Yml4Tmw3bEtzMDdrNzlzT0pySzRqdEVGczFOQVVyNkdYKzBuTHUwdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf22cc9-e189-4092-d465-08de6278eb09
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 16:34:21.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6Q1vRQYR9L6M3aClKYhDELd2cstVheil1wJ/1pAtT+hRFBmgHh4Wx9S2nwKA15+Qen5Wna7/yeO9aRHRXjP1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9696

Hi Ben,

On 2/2/2026 4:21 AM, Ben Horgan wrote:
> External email: Use caution opening links or attachments
>
>
> Hi Shanker,
>
> On 1/31/26 02:30, Shanker Donthineni wrote:
>> Hi Ben,
>>
>> On 1/30/2026 8:17 AM, Ben Horgan wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> Hi Fenghua, Jonathan,
>>>
>>> On 1/13/26 15:39, Jonathan Cameron wrote:
>>>> On Mon, 12 Jan 2026 16:59:08 +0000
>>>> Ben Horgan <ben.horgan@arm.com> wrote:
>>>>
>>>>> From: James Morse <james.morse@arm.com>
>>>>>
>>>>> MPAM supports a minimum and maximum control for memory bandwidth. The
>>>>> purpose of the minimum control is to give priority to tasks that are
>>>>> below
>>>>> their minimum value. Resctrl only provides one value for the bandwidth
>>>>> configuration, which is used for the maximum.
>>>>>
>>>>>
>>>>> Hence, I'll drop this patch, and update the mbw_min default to be
>>>>> 0xFFFF
>>>>> and for the value not to change even if mbw_max changes. I think this
>>>>> leaves us in the best position going forward without any heuristics
>>>>> that
>>>>> may come back to bite us later when proper support for a schema
>>>>> supporting mbw_min is added to resctrl.
>> Background: I previouslyshared original fix(seecodesnippet below) with
>> James Morse
>> ~2 years ago to address the errata, which explicitly recommends usinga
>> 5% gap for
>> mitigation of the Hardware issue (the problem described in commit text
>> of T241-MPAM-4)
>>
>> For some reason theoriginalimplementationwas splitinto two patches:
>>    - Generic change applicable toall chips
>>    - Specific fixfor Graceerrata T241-MPAM-4
>> Issue: Dropping this patch impacts[PATCH v3 45/47] forthe errata fix. If
>> removalis
>> necessary, please mergethis changeinto the T241-MPAM-4-specific patch.
>
> What's the behaviour on T241 when MBW_MIN is always 0xFFFF?

Memory bandwidth throttling will not function correctly. The MPAM hardware
monitors MIN and MAX values for each active partition to maintain memory
bandwidth usage between MBW_MIN and MBW_MAX. Therefore, MBW_MIN must be
less than MBW_MAX (IMO, setting MBW_MIN to always 0xFFFF is incorrect)

Grace errata T241-MPAM-4 has two issues:
- MBW_MIN must be greater than 0 (WAR set to one when when it's zero) - In the Grace implementation of memory-bandwidth partitioning (MPAM),
    in the absence of contention for bandwidth, the minimum bandwidth
    setting can affect the amount of achieved bandwidth. Specifically,
    the achieved bandwidth in the absence of contention can settle to any
    value between the values of MIN and MAX. This means if the gap between
    MIN and MAX is large then the BW can settle closer to MIN. To achieve
    BW closer to MAX in the absence of contention, software should configure
    a relatively narrow gap between MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.
    The recommendation is to use a 5% gap, corresponding to an absolute
    difference of (0xFFFF * 0.05) = 0xCCC between MPAMCFG_MBW_MIN and
    MPAMCFG_MBW_MAX.

> I'm worried if we make a policy decision of how to set MBW_MIN based on
> MBW_MAX for this platform then we won't be able to support a
> configurable MBW_MIN in the future for this platform.

Yes, we can't support generic programmable MBW_MIN for Grace chip. The 
currentresctrl interface doesnot exposeMBW_MIN, preventingusers from 
configuring the recommended5% gap. Without this interfacesupport, 
theonly wayto applytheworkaround is through driver-level changes.

>   As when MBW_MIN
> support is added in resctrl the user's configuration for this platform
> would change meaning on kernel upgrade.

What is the timelineforaddingMBW_MIN support? We have two options.
  Option-A: Keep the current WAR 5% gap and don't allow users to program MBW_MIN.
  Option-B:Remove the5% gap workaround and relyon usersto program MBW_MIN           
   accordingto the Grace recommendations whentheinterfacebecomes available.

We'll prefer option-B.

Thanks,
Shanker

