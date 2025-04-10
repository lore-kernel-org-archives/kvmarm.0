Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020092.outbound.protection.outlook.com [52.101.51.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6927B26A1B9
	for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744291382; cv=fail; b=QjvRq1c+u32d3ParbMqMxGy2PGkATzAJoJsGGQP2yt0M3ifXcnMoW4bh4nfXZpnqkgFeq1yPtUzjTPPHGMBoeAJVF+O/gmGDI35/lPNVweRVE0GqmIrGeGWCVIl/NIFK+jxFNZEcIM32dXM2GJEShUqws0dKEaCr2ZyDCtdsuZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744291382; c=relaxed/simple;
	bh=CXm03aaRjByfvg4KpYUEDgs2ZqlyXFhMaSjj59tdL48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tDg1FnIlte9ieqvLOHmGjBAetDkHir2Rb488+ZzvJzMZRZmcEYEPhgPtFbv4/6L5SHPAlKwVD64bDBJj8B3XJt7j7SLfkRIbm+wMRn1K7nAizWu2sb6gajtpU223o7FneiHSkkMFhWc7OhQhn3M1TjRuhcmu+7wmgs5yLYHGK/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=iAfLYpDS; arc=fail smtp.client-ip=52.101.51.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="iAfLYpDS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eogUi1M2uZmkOj09acLg/mz8u7/XUdgKc7Z6wcDFihvF2xYmoj/kjRGDAECDb+HePMi3JjbJYeytSQIQUSuo3uBUe7rwFEsOQPjbGYjpT3v7mz1q0eGv1OpjYrv0nJg6CNJ+dOEsqWzo+7ACrUYZXakHkkRx7qZ0WKrAzwBFTbhNUWm23u3jBIg7pb6v4sTbVufWOKYKojy1oRL6vptxAbvqEQsYrceWAP/NKVDfm6g6wAuBwEsHayEjH5VRbjgRebfCqICnrPPgJSkZtsWFfngQKcUoAF/ux780siwkyxdcDqFAWpSETQcsZRyKOk/zqoLaRjrVDafc/euZUI8ilQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hw6qWiOQz7qnL3QPfL/pX0Wf6VztGnHKDpSJiDKfQIE=;
 b=jWJJyK/X+UiiMq3uO0DvbB21WdXrmw5TFRFJkQ+RXW6WHqnJtgQ3cNAzxI70owMFUXPFs9yib6II2LP9N6zZQ+Je3y5yqkkBEq9HwcJVkC/1D78C9jBrfrh0pw8Ob2FUluaSTywAo/ocE0KGwXgnUkGhbZyyrFwZie8HgdJHHEu5/RpYNHIC+8Ja4UJyJ4JIUvWvF72IUhbQf+DmT8Bqe0+Bja/atfrQ8KhiMBTnkwyIPK/FtJW26uwwzNnXFfFGCraph6zqjeJYHpcWp31g4b7ouMbbuuLleI/XqrbTApgOB3N3BCYjlDJ7Htb+us88GiOUydlWP9/U8GuMaUgLdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw6qWiOQz7qnL3QPfL/pX0Wf6VztGnHKDpSJiDKfQIE=;
 b=iAfLYpDSgNe0gsOUeBsToSE/IgdxmTn24U31pR2LP71dZG5eBWIUVbys0HPsikhzb6B2RalBdFl+zoNZjexq0ZKzYkSLOwtzWzk0fonR6IWzoKZoylm1+bY29YUcd7/r1xG8aRLCoPxXmoaP/tTfitO5uW1MDGnPjnLi6fevBqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB7073.prod.exchangelabs.com (2603:10b6:208:35c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.23; Thu, 10 Apr 2025 13:22:54 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8632.024; Thu, 10 Apr 2025
 13:22:52 +0000
Message-ID: <91339d4d-38d7-4512-9fda-339bb4c2a3f4@os.amperecomputing.com>
Date: Thu, 10 Apr 2025 18:52:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Forward hvc traps if originated from
 nested VM
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, darren@os.amperecomputing.com
References: <20250410070743.1072583-1-gankulkarni@os.amperecomputing.com>
 <86mscolc0b.wl-maz@kernel.org>
 <4d1bdea5-43c3-4ca9-9275-feadf158e86e@os.amperecomputing.com>
 <86jz7sl25r.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86jz7sl25r.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: ad574ee4-e8a0-4753-30d7-08dd7832cbd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDZkQVZHMUQ0ZXZKRVJ6NG9XSnUyNkJpSERFd2ZZemcvbzZGQlpSNFkxQlUw?=
 =?utf-8?B?UStvYmlCcXBrNUpTcWFNbGlhcVlzYU1XUXJLaWd0ajRxSjNIeEdWeUowUVh0?=
 =?utf-8?B?UEFxbjJrMmRWM2drN1lrSzFnRGt0OUt3YVRjRWw1U3Q0M1ByS2ZVZS9NMGw3?=
 =?utf-8?B?aWMvUFR3ZXFERFVDWlplK2RRTUJIODlDeVFPVUlPR09PcWgwVTNLVlJ4Wk1n?=
 =?utf-8?B?YjVod2daNW1nWG1wZlFOcDZqaTY4bE5PcllSTFF5TE9VVHZlQnZrbCt6b242?=
 =?utf-8?B?M3ZxbldmWjRqZkFvYU1PWnVQZEwwQ2UzeXUrdGJNUHV2OUZEejhoUjZjdE9P?=
 =?utf-8?B?eHRDSW1aSWhGcm1ZcnpuL2VJM21RVDZJYnk1YnRtK09IOHcrY2I2UVVzYmVt?=
 =?utf-8?B?RzBuSE12ejNOVHN3N2RvR3ZESGpLcWRFVU5pOWs0S0pwVWduQmJTZVJFaWhH?=
 =?utf-8?B?dG5WVjZZSDMzc3NQTEVybENOSXlYWWhvQjBpYmhLZmpTbGNEMmZPSE1XNi8y?=
 =?utf-8?B?ZXg5ZG5XdHVKL1dpRDU4WDdXVi9HdFROdEgwa1p4VXphV3BVZWdGWVVKRmlR?=
 =?utf-8?B?akhrSDdmN3QzeC8xcnhBcGpsYm95d21jUHNZaXVUZDZvZEh0dTg2Q0I4bitp?=
 =?utf-8?B?N2NIdGNxL2VGczJmR3V5clpPYTdOcFBTbURVRkN0bnV3SW0vYTVYaVFsS2da?=
 =?utf-8?B?Tm04ZnlDdG9vVGJQT2dNUThURUFHRy9DVFZHdkdWOWt0U084MmpFS2R0dVlq?=
 =?utf-8?B?UW1vY2N6aURSbXYwTS85bWNvK2xhTDZ0aStORjZxQ051RUZyamZaNmlsK0ZL?=
 =?utf-8?B?blI0YTdPTDJqVEM4QzVRamIvVmhsMDVzY1Vlc3JjQUFkTkFwa2M0NVNQV3J4?=
 =?utf-8?B?eUN0Nmhyb3VWYzk3Rlprd0pNQWxHWERKWWxNZVBTbGZlUHdEVDU1a0JydjRI?=
 =?utf-8?B?a1BPZWk5VjllRVU2bDNONjFSNzc1N0ZGZFhaMWE1S0NhKzJlNGJRV0ttb1E2?=
 =?utf-8?B?NVJGR1JoakZFb3RUa2xYQThVaTNtSnd3MnYzai9vZjZBTmUwSWQxdWY0bEZr?=
 =?utf-8?B?MHBnN1BJYVJYWUEvNm5CT0dLR0Z2eGNSZW84YlRUZ2lRK3pMclZxM1FOdVlW?=
 =?utf-8?B?SkphOFdYSFQ4aGd2bmRYVzloMVBSMG1qRVl0cGcvOGRFOFB4M01qSXZSOGdM?=
 =?utf-8?B?ek9ZaUc4MzhRMVFKYXJsU3lpcC9DeTdOblo3R1NSU09jZUo0QlpTUWtJREVR?=
 =?utf-8?B?bFRrOFpXUXNlR2xodmFzbmczbTRhVE43Ti83OGd1N2k2SG5MbmQ2TWlYZjBv?=
 =?utf-8?B?RFgwWHZrSm5OakJ2MXV4N0dMOE1DVnd0L3RnNHhHM1J1cTZld3k0enEzWHRp?=
 =?utf-8?B?WlVia1ZTbzFkRVVyWm56MFdFR0R1WXQ1ejFxU0dNR1RiZ0RHWnZwRURScTVs?=
 =?utf-8?B?RUFpOFpHWFp2U3VsemRrd1ZIc1lXSmI1Mi9wRGJPRmdOeGdXajI5RmFId0d2?=
 =?utf-8?B?VXNLV2Y0Ty9YdmxaZFpmUjV3QlV6aUFQUlFUdHdNTzJPRXJSK1ZrWkFkbklY?=
 =?utf-8?B?cnRxcm1PWE1pdGE1b1o0SStaUjZKZTA2K1lWZFJydmxQb2lodUlPa2s2SUhq?=
 =?utf-8?B?dE9DN1dkMnJETUphbTZ3VDkzYmdUd1lOUHMyMnZRc1ZXYWZTam1IYUcxbUFZ?=
 =?utf-8?B?bUxMRUVqcjFBZkU5OElwUGlEODUrZzhETVFtVTN3aGxjUStaK21VTEt1MFJG?=
 =?utf-8?B?L2pSSEpOQ3U5TVo2djdzSWNpYkdYbkJnek5rWldiTlBhQnBDeXIyUWN4bGht?=
 =?utf-8?B?blJENVFiMU1PVGJBMHFheGJOWGVXWENkOFN2cEJHWjVOQi9Xc2llRHBsb1hQ?=
 =?utf-8?Q?NnqF8+x0QVt0w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVZjeE9sUzVicWJOR3FidUVCWWRwUXRYZGhDQ2JsZlAzM2tKaVNMb3Y1dVN4?=
 =?utf-8?B?THZRU1ErNWdxVTBUQkRUV0JXeEF2ZFBYR3htbW5iYlh3L1c2QUhaUThXeTht?=
 =?utf-8?B?cmkvbStaNUdHZ1dkU3lDL29yeWJ4bGMva01xYkVZMXVLZmsxOG9DSkxvY1Nh?=
 =?utf-8?B?cEh1dWYzYmxPQUFPTjBvRDBkczRQTjg3WWZTZ0VUcFArRVNvUGRQNVJwdU15?=
 =?utf-8?B?Rzk4YUEvbnQvQ0U4YTEwQ1IrM3RNQUxHZ2NyVlAvWlhyc0pNbnlYMTRRTHZl?=
 =?utf-8?B?NDJyakdEenlOZTk5bzczT04rYjA1eFJUUlpBbnpNVDNKejBxdENYR1ZQa0lH?=
 =?utf-8?B?VjRLSno4cnJqMnRqelFHWjFCM0VnT08rR0RIcW4zU2pFUGVxQU50eE5JdFdv?=
 =?utf-8?B?ZlRFTW5Kc2E4ZDdBRi9MQldWWUUyRDN2MlZJQTE0SlZhdml5ODMvRFhZQ0hj?=
 =?utf-8?B?S3QyYzN6MjRrN3pEWjFoVnZpZlNNLzR6dW9NamZ4UU1oUXV4SEpKeitsMVY3?=
 =?utf-8?B?eGxWQ2NXcGo2NXA5bDRGTWhJUUU4NHRiVG5LTy8zbDhtQ0pmaGQxdUVSTVlP?=
 =?utf-8?B?NDliM1F0dm1aazNPN05mbFlFdGNWSFpiZzR1NWQwUmpMV05WMnA4dGtVM3R6?=
 =?utf-8?B?d09GempITlpiVk5JTFB2VU16dzVXVzN5di91WGpuclhvd3FTdWdXVmZabWRh?=
 =?utf-8?B?UUt0aGI0cVdxWk1SanVxMjNrZE5OcE80TWpnQXkyQW5oNlZ6cEt3NWY5a1JY?=
 =?utf-8?B?T2l3NXhHOWxCeTMvRk8vRnpFUm1uSVZydE0yWVpMN0tzV2hrWi84d0tFZ1hC?=
 =?utf-8?B?L1hjUSs1ZTI3NlJJdk5kT3B4ait4aEE3aDlxTHFBNmNjdU5sUTRrMDg0QmhI?=
 =?utf-8?B?K01xT0MyKy9YNFhHdHNyMzZ5cHAwbld6bW45Y0pCcWY2WUE4eUlaYlBVemlZ?=
 =?utf-8?B?N2Q1eUNKK2g0L0VDNzlQU0xIeUZEejV5dU5YYldPOFlDNy9ZS3ZpcjNiRlox?=
 =?utf-8?B?UVQ4WVJVZjJnaUdwZjN2U2ZGMjhrV1pGM3JEYkdGelVERmtyaG5QZzMzVzZr?=
 =?utf-8?B?LzBveCt0SUxQZWR1T0RnN0UzMWQyZXFrOU1vYkdpOFV1WnpwaVRyLzRXeXJt?=
 =?utf-8?B?MmxCY0dpOVcvaWdHMkVBbkNGUE9TMFJVdHRJREpZTTEvVjFZOXNLWlpoYkVB?=
 =?utf-8?B?c2I0cGxIekxOaSsvdyszckUyMEV6YjgzWkZTeitqTFdtNUtZMjlFZ0VUL09S?=
 =?utf-8?B?SnVpNWpOa0p3a01rZVRnUDVuM0VMQ3F6WkdhalpaK1hLMTN3MlFzWnBXM3h4?=
 =?utf-8?B?ZzNEOGNZSmhuaVJyUkxwNHAzV1BXejZiSG5oRnNWaTVaNmREVUVTRkhkUVYv?=
 =?utf-8?B?Q3ZhaGZBNEhUTUhRSTZrYmlQTHcrMUltV3JldWd0ZFdTOHU1YVBqQjFoa1dD?=
 =?utf-8?B?S0ZDZlVVRW8wUENmbXlKVnpNK1hXRjVjMWVvTHRTMUdmVUpHQzhDK2NoU1gx?=
 =?utf-8?B?YXdUWnFqZVZlNXg0K0xwTXJUMmYxQi82Q1dyQk5KWTdqQUk4NEtTQTJaYW1B?=
 =?utf-8?B?dVJrejNocnhnZFNBbDJBK3YwRGkwc1RhQ21YVkpOanhSK2p3SDVDNUhRWlVJ?=
 =?utf-8?B?d0Fsckl3SjJPV055ejdVRy83UFEyNGE5RCswUEIzUldaRWozNDcxZTZCRXIv?=
 =?utf-8?B?Y0NyZDMyakpyQnV0V1lycXFJWWorMzFlL244a1FQYllrVFRsbVZ5UGhhck5a?=
 =?utf-8?B?S2wrdmV1Q1RySmZqRklTSFFkTmJWL3ZQN3JUN1doYUl2ZmRHcVhsdU5uTUx6?=
 =?utf-8?B?QytEVmp0SDdFQkZpYkU2eWc1RUluZmVaWlBMbGVkQ2JJbzdFQnNZMzlzeWh6?=
 =?utf-8?B?Vm9NV3Zta3BYK09YMUREUEN2QW03bXZNSGI4YUxzK1cxbEJGdjJjRldzeEtZ?=
 =?utf-8?B?Q1NtTmVERVBYV29zMm9PUllzUGxwclptQXU2SjJzUkFFOUZHUnYzd2dWYmxL?=
 =?utf-8?B?R0ZTaVRNYkM5Z1FGWTVwS2h2ek92clIrR1pydCs3MjZHQUxRS2dJOWpBWWdz?=
 =?utf-8?B?Z0tVbG1YUzJLWE9aRHdWa0k2enlQdVplQWZUd2hNNzRPeTQ2K1VwaFg0ckJY?=
 =?utf-8?B?UWFZOWdhUk96aTB4dEJGbFdHK1M2YStqajRseno0V2xodS9xNUJmamhnaVE1?=
 =?utf-8?Q?HD10yIz6WPuLhN+cTM+jH+E=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad574ee4-e8a0-4753-30d7-08dd7832cbd7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 13:22:52.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kDUzgbkQI/02XbIzaAaZA8Nafko9joDY1h4hpjNXtHmMWFp4n9y94hxLNhua3RDvqCC5DxKtaItPYafPUNnl6YQkGVx/KdhHEGZ240ZnazrPnXXC8mrTh0/q1C+AIUF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7073



On 10-04-2025 04:22 pm, Marc Zyngier wrote:
> On Thu, 10 Apr 2025 11:20:24 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 10-04-2025 12:49 pm, Marc Zyngier wrote:
>>> On Thu, 10 Apr 2025 08:07:43 +0100,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> It was discovered while trying selftest(smccc_filter) that the
>>>> hvc trap is getting forwarded to guest hypervisor even if it is
>>>> originated from itself.
>>>>
>>>> HVC traps from guest hypervisor should be handled by the host
>>>> hypervisor and traps originating from nested VM should be
>>>> forwarded. Adding check to forward only if the hvc is trapped
>>>> from the nested VM.
>>>
>>> I disagree. HVC from EL2 must be routed to the same EL2. HVC from EL1
>>> must be routed to the EL2 controlling EL1.
>>
>> Thanks, Understood, In NV case, hvc has to be forwarded to L1
>> irrespective of it origin (L1 or L2). Need to add hvc handler in the
>> smccc_filter.c for the vm (when run as L1), so that it is handled and
>> returns with required args set.
> 
> Why? This test checks under which conditions an HVC/SMC gets routed to
> userspace. What does it even mean to test HVC if it doesn't make it
> outside of the guest itself?

smccc_filter.c has 2 tests (test_filter_denied and 
test_filter_fwd_to_user), which runs the vm(guest_code).

I was trying to modify test_filter_denied to run in vEL2, which led to 
this patch/discussion. I agree, it does not makes sense to run this test 
for vEL2.

test_filter_fwd_to_user is not feasible to run in vEL2.
Thanks for the feedback.

BTW, I could add hvc handler and run test_filter_denied in vEL2.

-- 
Thanks,
Ganapat/GK

