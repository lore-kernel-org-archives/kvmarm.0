Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020129.outbound.protection.outlook.com [52.101.56.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADA1BEF9A
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733758789; cv=fail; b=m7kICSU4SlBpInGqlbqS8+szwKMfqBQ7e/OxKRy6ZAEWOK+uM2zhduO1iMovwvnd4AUgIYcJou+YNSESH4CO65n1+uBZCnUzbdc+EikYA60H/N/+OqusBYCf4+xMlvlxcXCoGcP1nhWxqeYk03yzWHTbgKKJALAkyLghdLns4No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733758789; c=relaxed/simple;
	bh=mChLEy9EB4l/zD/cmNVi4cVg7OljRkS28aNZ0MOYmAg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b0OzgpY7qwChcAXpNRMlFzgSS7pTQjY0tOBoa2RDXWJBrNZJPcfNDS8BxzmQIxvZ6og3E0Zx5gcPR0CxNDUCWXSLXFuxSqvTnh2OCPJWVk4GIhh8PJs6/Hgl2Mx273ypNV33Zb8c13O0/ZRanfElb0CHlAxzW5KCwtj3/eYWXms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=QYbIcwG6; arc=fail smtp.client-ip=52.101.56.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="QYbIcwG6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZOw+pV9dOA97YM0XSoJkM0w/I1f3UzQYTk/eWobdK2b1OMpWwsovnUNfL3Dm5UE3hJu5PlWmlz/aOmqsYsjNDu4KODT5jGy86ip1xaQeV9k9567nEQxR3EUL2Y7iOeKvwlOTkOUpF501Sx5dWxfTjId9daTav2F2NkHuu0+dUEI8lPjeN3DnQCfGfFGNttRXCbiZCDom188nhJ9K21hCjL7a2ADB4kuJ+QAxBXO04mINRDrFlv7elypL6IfnCbHrPXH2NNpFn9ZLeNNv8h7swbRVfWWLUl0wS3sopW17jomOEYmq8sT4wtScJ2VfzFVK6O8/k/er7YwQ/cmCTVM0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlklUqAUjlZg1IzGStcSBMWZ93GpNhU/2RXYu15FMHI=;
 b=eMZjzdKuiagvzKqJjGj4CfHaqAouCY/ZE1Cj+s5hQFq1LMcYzqf0nSC8qjZcX5WQr+FuC82mQtmP0LQ4b6IM07BRa5CG1didsziiXscXyTifhsm0l39W+/SnlrPgjig8iuBVRTgKQRi7z3fHcX13btZKlM9s0s8tChHALs5hEoTa1k8bjy9PaVzUgA9ZAIw6HodT2LC6jIKskQhpoQe5NOUy8MjhtCNhErN1+PxXJ8ymzpZWl4MvFE9OvBxk42CIm3w1cRbn+8OPuIQo0VPgA5Htqn0rG0T/KDe9QaZ6qi7JJYl1U9O3swnyGmvjD6AVlerlpeUX7pA+r+tk6LbQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlklUqAUjlZg1IzGStcSBMWZ93GpNhU/2RXYu15FMHI=;
 b=QYbIcwG6Wjj/wuLxAVlz7XUCEw3g4NdFKSeCQyeZzO0h+O8xo4WRk9hfxVNWgIVpAn6z7uPZYgSTNtiseGrrgGpyi+fY2dqzTIWJGBTpjgteFPOjCp5p03OMcuoq25OkgqHNVVyZ+1MUm07m7+gA5LfPC6+4PHDfY5OgYwdT/3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CH3PR01MB8594.prod.exchangelabs.com (2603:10b6:610:175::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.20; Mon, 9 Dec 2024 15:39:41 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%5]) with mapi id 15.20.8251.008; Mon, 9 Dec 2024
 15:39:36 +0000
Message-ID: <8be59ff3-6a68-48e1-8181-0ce4b2e7180f@os.amperecomputing.com>
Date: Mon, 9 Dec 2024 21:09:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <20241209053201.339939-1-gankulkarni@os.amperecomputing.com>
 <867c89tc4q.wl-maz@kernel.org>
 <c5b1c3d7-56ca-4afc-a831-045dba4beffa@os.amperecomputing.com>
 <865xntt2kv.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <865xntt2kv.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0065.apcprd02.prod.outlook.com
 (2603:1096:4:54::29) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CH3PR01MB8594:EE_
X-MS-Office365-Filtering-Correlation-Id: 4344c184-6771-4dd2-9565-08dd1867afda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXY2c1d0U2hSS0NId2lVZXg0WmdYeG5QdmNDblI2NUtVU2hYY0cxWnhTK2hl?=
 =?utf-8?B?Z01zRHMyeGhQcUZqa1ZWVWdxb1BUWjJReEZDdTAwOGJGMjI3dHNEbnBkVmNi?=
 =?utf-8?B?eGM3NXh6RGJkNkNVV0IxR0syelZ5d0IvelVzZFVoME9qb2dnNGFLTy9aSVd0?=
 =?utf-8?B?Uld5UkEvYlpEc3lrcWwwVjQvaCtTeFNwejJiYnc5VHhNQThhOHdPTzF3R1pN?=
 =?utf-8?B?M3hSNC9odmRjYmNnOW5pbmVsbm9KcFUyRWt1aTQrMm95RjVCL2JFc01Mc3NM?=
 =?utf-8?B?ZzJZbjJLb1NOaTFNZlBVdGQ4ajZiNHUzZkVJbU1KbXlIUzBGT0FjSW9HRDF4?=
 =?utf-8?B?UVF0N3c1cWRMZVdyU2Z2eXlCV1FTYjhJNWNCQWEycW9jT3JnNWZzT3N1dHd5?=
 =?utf-8?B?c1J0UDRRYVp0cEQ1b3hwbnEzNFR6UkFEZmtJRjE0SXljQTlFWXM5RXNKay83?=
 =?utf-8?B?enN3L2YvbHdwZE9XKzBMeUx4ZEVDY2RSelhLMVpoazU3WWdkWWFKTEJQUUdY?=
 =?utf-8?B?bEMzMnVDSnFXd2xmTGppWnVPY2hiQ09pb1IxUGhIQUtiR3JZZUZwUkNVNStp?=
 =?utf-8?B?QlBxa2IrYktkSUZseTR6NVNxUjFwNndvekFSWk1ob0pOOGtlQmE5RWhUcGFD?=
 =?utf-8?B?dE8yU0hWa2hqOXhoOVg5RDhJcVdyS1hHRFNBN3RFSFRqVm82RUpjbzRjakVo?=
 =?utf-8?B?dkt4d3dRSWFxTTk3YXRqaXQ4Z1Zvcys5QnRzbzZMbVpackVtbkluSzlIdkxC?=
 =?utf-8?B?bDBidk55VHRacjJ2bUJOUFMrT0ovSXo3M0IyeXlxUkJUdEk5bXlTK2pUbm43?=
 =?utf-8?B?L0QvVXpqRUMwbW9lM082SXlTYVQyaDlVc2hkWFEwci85a3pVSldSMm5xVXhE?=
 =?utf-8?B?Q1FlMm9VMnhSQythelBMWFJLdFdKbG5XTkdUUWNYbDNjYkZuREdmT05ZN3Jy?=
 =?utf-8?B?Lys1NDh5NzNvOHRwT0xWK2dXOEhOaE51RDRpR1JxOVdlTzNIUTFQTDJqRGwv?=
 =?utf-8?B?N09COE0yOU8wS2kyY1hhSjM2aU96U2ZQMGhSMUVnNFlzTHExb01HVit2QnE4?=
 =?utf-8?B?YzZuOU5JelpXSTZhb2FoZ3h2U0Q0OG8yaTNhYTJOM2F1dWpWRUptYzc1Q2xK?=
 =?utf-8?B?T3pIZS9tNkpkTXhZblFYbHJuVFk5M21hNithc1gxbTU4dFQzemQrNVpFSVI1?=
 =?utf-8?B?bjU2UFM4eXk0VHgwSFRxek45cENCdVdadHZJZldRUXE0eWRLdlQzUzcyRTl6?=
 =?utf-8?B?ZVhHOSs1eUZETHlzSTIvRXhkRG5pQmM4NWFsNjkrVXBTT3dQa2t3UG9Jc1M3?=
 =?utf-8?B?Vko4YUlOQW41UWxrREZjaXBUMGtncnFxek1FTm9YblE5eTE2U25LZ2Q5UWRB?=
 =?utf-8?B?VzRpc0hDWXFGdmlMRzNMT0syeU00WVluWlUreW5QemJ4Vy9EVlNmVEJhTVBj?=
 =?utf-8?B?Wm9yVjM1dU5yRk4zYXRCQ0JKQ1pkNWFyMytpaVNxTHFkMlRwZkdxc2R3eDNj?=
 =?utf-8?B?VzRRU3ZTNTMzbk1XbVV0Z0l6aUIzWFdQQmZTQzZtcDA3U3BvMDI5WWk4L1VN?=
 =?utf-8?B?M0REd0Vwa1Z5bmc4OGtxMmRNMXBRQXJEUVhMVzlQVkVTM0w3dHkvbGw1dEhn?=
 =?utf-8?B?YlZQN2pVeXZpSzRLRFdZT1YwVVBqdVlSeWl0d3hkZ3BUNTBYK3BXdnIwa1dp?=
 =?utf-8?B?ejlRM3Y5ZUZhYTN4Q0JJeHNuR2JTaG5udm8rZngxZnNBYnNwQktBM1ZrREtz?=
 =?utf-8?B?MmpQd21LWXM0ck5raFNkZkxHbWVUOXY4bDczdnU2VXBXWHhNMHc3RjhhT2di?=
 =?utf-8?Q?8kVK/Ooj2sH8WGfnf8FUimsj8GlSiGNfmWoQA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDBxVEJLa2JKZTRjeG9MR01CTy82NXJCQTJCcnp2VmtDOVBXdW53Z0VDeDRI?=
 =?utf-8?B?bFZrMjFIU1diNHkwYUFaOG1WVEV0amVvNHkrU1I4cGVzaUUya0hESTR3dkhu?=
 =?utf-8?B?M3Q2Y0lLL1YvZG5wYVB6eE55Tm1qNVJwS3Y4ZS9QazVUcWttUG82S1RqT1Y5?=
 =?utf-8?B?cm0xZk9VajdXL1o5dzdIa21SZ1NzS0FWdEw1d1JsMjBqU2dZZGc3TUwrZ2U0?=
 =?utf-8?B?NFd1UlJOOEt3ZGFDK2FrM3BxdVNoNVdGdmN4YnZhN21rYStuN1NaWUhwNTk5?=
 =?utf-8?B?ZHB1blpvbXZmbDRsQnNIQ1lidXRYTGxDUVduaEJWZXV5V0JscW5HQ04zVVBp?=
 =?utf-8?B?bzhiN01WTFBKUXUvKzlkeDVSeGpJeWM2UXp4cUVJa0pRM29jTXpvU1duU3Z2?=
 =?utf-8?B?eUxZMzdESGVKSXBUSHd4Z3ZPaERUUGdRVkg2VXNaRmd6UmFRdk9ZTCsvWVVE?=
 =?utf-8?B?Tk80eTM1SEhaa0ZHVWJWWi9ZOUNLOEFKa0I1L2ExYytaWVdrQTBxRk9OYUpz?=
 =?utf-8?B?MmhObnRlUlJDNy9FaUZUNCt5SHlMUGFsb3dWV2tkUStCb09TZEZ4bU1FQmw5?=
 =?utf-8?B?bEdpbjBLZ2tYdzdlbGRjOGVqN3lCajJqUW5ZSFgwajU3d1BQaUJ0YzBGWlov?=
 =?utf-8?B?cWl6a2tWWWtudXhnUkp2aldNOVdaTFVlZGI0Z3p6SW5kRHptcmFGMG1tRG9P?=
 =?utf-8?B?SCsxa2Q3OCtleVJsOTNOTlpxZmlzL2lDdmJGYTlEV282UTZ0d0YwenlaNmlE?=
 =?utf-8?B?UXFsRGZCUVJoYnJZbTFSV1lzSTlPd3Vlbk5hbmZvdHdqbzBDSVlzeXpNbm5i?=
 =?utf-8?B?RjVsL3dpMVA1VWZnbEVZTkkxZUdUckgyaWVRTnVCWHdNNmtnN0R1NHJMWVIr?=
 =?utf-8?B?K3hLU2hXNnpQZmZvQkRjMlNhS3AvMVVYN0RTZzg4WjBqNFFJNTJmbTdpY3E2?=
 =?utf-8?B?bDZERUtLaURETGVqd0J5WHJVbCtPV1o4NFBpQlJuaVM5eXZFVXlpdmtycVF6?=
 =?utf-8?B?WE1tUFdGUE5QMmR5bVRHTkJYSStpRWxvK3o2OG84QTJlWFFpN3ZjUHkwVy8r?=
 =?utf-8?B?eFl6RDhJVisyeXJicFpIeUx4QVg1d25tSVd6L3ViQ09UaDNWeU9xbHM2ZzRl?=
 =?utf-8?B?UFR6L1JDQTdLdzVUa2JzNktJeUFtQzl3SUpYODY0ZHEzVitvTTlnTlhsKy82?=
 =?utf-8?B?NjdRbnB3cFNtM0tKNldtdnp4WGhTRWh3MXFSektwcTFsV0FUUGdTRzVEUnFM?=
 =?utf-8?B?dG9xWEhxTm12cXhxdzJTNnJGbnY4dkRqTVV6LzZRcTBDaHVjNFJmU3ZHd05Y?=
 =?utf-8?B?ZmwzRWYxcHdOYkNBNW1IaVVIa01zWVpQZ3NqaFJKQUNjZnV1MTVHTUFRcEw3?=
 =?utf-8?B?ZEdXbFA0bjdZUmo5cHl4OEVsNytzZm85NHVHOEhNd2VtZWZ5RS95a0w5c2tS?=
 =?utf-8?B?bTd6bWwyKzBubmJZVk0wU1pMYVRFc2FJWkgyRU55ZXVVTWlpNXFmSncwQ2x5?=
 =?utf-8?B?NDhnd3JIWjZTRnRDei9QT2ZwbjdvNm9lNXZib2huVDZTREpLYmFhQUw1N0JD?=
 =?utf-8?B?WEc2NjNNMDQwRjBQOWNlakpmK0hSR2FzQUdMcDlNLzZ1bkwrVWd6cUV5WUhC?=
 =?utf-8?B?VHBERFpBWC9yL0ZEKzFnZTdiby9NTUhDU2N3NW1SYXBuUWI3ZzdPQkR0N3VK?=
 =?utf-8?B?NGNTa1U0cE9NakZyMFpFTnR4Y3Q2RVFtb2pubFpUek4vNjlLUFpQQVNrRHBS?=
 =?utf-8?B?RzdISDVIRGZxeUlZbjFrcm5BNjd1S2Q4WG9yWk5KWXJFZlptVUhmKzhvc1pJ?=
 =?utf-8?B?aW1SZm5OU0Vlc1FwbHU2bXloZmJORE5ONDBId3RuNFlSSTdlRUUrVEU5T0dY?=
 =?utf-8?B?SStLeE5sOXg0eWZXaFpvN2k4dU53Rk1oRGY3c3ZhRkU5WlorMlBoV2FvcWUr?=
 =?utf-8?B?MmFkV2RocEowYW9KUmRNMFVBL3JUellOVlZPYXFURXhiTUtWc1F5WVRxdE4z?=
 =?utf-8?B?OHFPcHJicjNBUTFMQVVXVnh0WkVKZVAxd2Q5RnJQYXU3cXBteSt4eFpkS2I5?=
 =?utf-8?B?enhDNGpiUzNGM0JlTG4vWkt4anNxL0NEclpYWWZsZkFWazNzZlRuMWQ2S0F2?=
 =?utf-8?B?eTM4dTBGbkV2cjA5UE5EUitwNUVxYW13MFR5UFdwTS9GUDB3UVRONEtiTGZN?=
 =?utf-8?Q?v1QStcgWCCdcQZxwHQV4py6TZZkrvJ9aq2jbCIF0bbgH?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4344c184-6771-4dd2-9565-08dd1867afda
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 15:39:36.8944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSt1N+KRLOPjBG0RINtLqxUlfDS829fbV5iIuk5Vxx9SMsx7BjxiiLSRsEhksdyfGStafewl0umGSs+Nm+OekBCjqHkKvea/FrkKe3N2mQqdsgceaJ8tbMLJvqXNe90w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8594



On 09-12-2024 06:50 pm, Marc Zyngier wrote:
> On Mon, 09 Dec 2024 12:25:34 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> During automated testing of Nested Virtualization using avocado-vt,
>>>
>>> Which is not merged upstream. So what branch are you using? Based on
>>> what kernel version? On what HW? With which virtualisation features?
>>>
>>
>> Testing is done on Ampere's AmpereOne platform using 6.10 based kernel
>> with NV patches from your repo.
> 
> Grmbl... *Which* patches? At least give me the SHA1 of the branch,
> because I have no idea what you are running. And 6.10 is definitely
> not something I care about. If you're using the NV patches, the
> *minimum* you should run is 6.13-rc1, because that's what the current
> code is based on.
> 

I tried 6.13-rc1 based nv-next branch today, which failed to boot
UEFI as L1. Yet to debug this.


QEMU from Eric's repo is used for the testing.
https://github.com/eauger/qemu/tree/v9.0-nv-rfcv3

> Also, does this machine have FEAT_ECV?

Yes!
> 
>>
>>>> it has been observed that during some boot test iterations,
>>>> the Guest-Hypervisor boot was getting crashed with a
>>>> synchronous exception while it is still booting EDK2.
>>>>
>>>> The test is launching Multiple instances of Guest-Hypervisor boot
>>>
>>> Is the multiple instance aspect really relevant to the reproduction of
>>> the problem?
>>
>> Not really, but it requires multiple attempts/iterations to hit the
>> issue. Even with automated test, it was seen at some iteration out of
>> 10 to 15 iterations.
>>
>>>
>>>> and while booting, QEMU monitor issued the command "info register"
>>>> at regular intervals to take a register dump. To execute this
>>>> command, QEMU stops the run and does the register read of various
>>>> registers. While resuming the run, the function kvm_arm_timer_write()
>>>> writes back the saved CNTV_CTL_EL0 register with ISTATUS cleared always
>>>
>>> It is userspace that causes this write-back, right? AFAICT, KVM never
>>> does that on its own.
>>>
>>>> and resulting in the loss of pending interrupt for emulated timers.
>>>
>>> How does a missing interrupt result in a synchronous exception in
>>> EDK2? In my experience, EDK2 panics if it sees spurious interrupts,
>>> not when it is missing interrupts (it just locks up, which is
>>> expected).
>>
>> Not sure, why it is hitting exception, rather than hang at EDK2.
>> However, EDK2 timer handler code is ignoring the interrupt since
>> ISTATUS is not set and not moving CVAL forward.
> 
> How is EDK2 getting this exception? Is this injected by KVM? Or is
> that some EDK2 bug?
> 
>>
>>>
>>>> In hardware based timers, ISTATUS is a RO/WI bit and gets set by the
>>>> h/w, if the condition is still met. However, in Nested-Virtualization
>>>> case, the Guest-Hypervisor's EDK2 is using an emulated virtual timer
>>>> and losing ISTATUS state and the interrupt forever.
>>>
>>> Why is this specific to NV? Can't the same thing happen to the
>>> physical timer in a non-VHE configuration?
>>>
>>
>> You mean, emulated v-timer in non-VHE boot?
> 
> Emulated *physical* timer.
> 
>> It might impact non-VHE case as well, not tried though.
> 
> Can you please try?

Sure, I will try non-VHE as well.
> 
> [...]
> 
>>> But overall, this very much looks like it is only papering over the
>>> real issue, which is that the *emulation* should regenerate the
>>> pending bit, and not rely on the userspace interface.
>>>
>>> As far as I can tell, we already correctly compute the status bit on
>>> read (read_timer_ctl()), so the guest should always observe something
>>> consistent when it traps. We also *never* use the status bit as an
>>> input to the emulation, and always recompute it from scratch (it is
>>> only there for the benefit of the guest or userspace).
>>>
>>
>> For emulated timers, we are not asserting again by calling
>> kvm_timer_update_irq in timer_emulate() until the level is down and
>> ready for trigger again. This was done to fix high rate of spurious
>> interrupts getting generated to V-Timer. Hence we are not able to
>> recover, if once ISTATUS is lost.
> 
> Again, a trapping read should see the correct value, since we populate
> that bit at read time.
> 
>>> So I can't see how upstream is broken in at the moment, and you need
>>> to explain how this actually triggers. Ideally, with a standalone
>>> reproducer or a selftest.
>>
>> We could reproduce the issue with the simple test/script.
>> On one shell, launch L1 using qemu with add-on option
>>
>> "-monitor unix:gh_monitor,server,nowait
>>
>> On another shell, while L1 boots and still in UEFI, run repeatedly the
>> command (or put in a while 1 loop script)
>>
>> "echo "info registers" | socat - unix-connect:gh_monitor >
>> /tmp/info_registers"
>>
>> With above steps we were able to hit the issue within few attempts.
> 
> That's not a standalone reproducer. QEMU doesn't support NV, and
> kvmtool doesn't have this sort of interface. I was asking for a bit of
> C code that I could run directly, not something that requires me to
> drag even more experimental code.
> 
> So here's my current guess, since you don't give me the needed
> information. For what you describe to happen, I can only see two
> possibilities:
> 
> - either your HW doesn't have FEAT_ECV, in which case the guest
>    directly reads from memory
> 

We do have the FEAT_ECV on AmpereOne, I was the one reported/fixed bug 
with FEAT_ECV(CNTPOFF offset issue) in the past.

> - or you are running with something like this patch [1], and we serve
>    the guest by reading from memory very early, without returning to
>    the bulk of the emulation code

I see the kernel I am testing has this patch[1].
> 
> In either case, we only publish the updated status if the current IRQ
> state is different from the computed output of the timer while
> performing the emulation.
> 
> So if you were writing back a status bit set to 0 while the interrupt
> was already pending, we'd deliver an interrupt, but not recompute the
> status. The guest would consider the interrupt as spurious, not touch
> the timer, and we'd never make forward progress. Rinse, repeat.
> 
> Assuming I got the analysis right, 

Yes, this is what I tried to explain. LR shows pending, but UEFI is not 
consuming and treating it as spurious since ISTATUS is not set.

it would only be a matter of
> hoisting the publication of the status into timer_emulate(), so that
> it is made up to date on load.
> 
> Please give the fixup below a go.
> 

Sure, I will give a try with below diff and let you know tomorrow.
This should work, I remember, this was the one of the option/fix that we 
tried as fix while debugging.

> 
> [1] https://lore.kernel.org/all/20241202172134.384923-6-maz@kernel.org/
> 
>  From 2bbd6f9b41a20ad573376c20c158ff3c12db5009 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 9 Dec 2024 10:58:08 +0000
> Subject: [PATCH] fixup! KVM: arm64: nv: Publish emulated timer interrupt state
>   in the in-memory state
> 
> ---
>   arch/arm64/kvm/arch_timer.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 895f09658ef83..91bda986c344b 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -432,25 +432,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   {
>   	int ret;
>   
> -	/*
> -	 * Paper over NV2 brokenness by publishing the interrupt status
> -	 * bit. This still results in a poor quality of emulation (guest
> -	 * writes will have no effect until the next exit).
> -	 *
> -	 * But hey, it's fast, right?
> -	 */
> -	if (is_hyp_ctxt(vcpu) &&
> -	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
> -		u32 ctl = timer_get_ctl(timer_ctx);
> -
> -		if (new_level)
> -			ctl |= ARCH_TIMER_CTRL_IT_STAT;
> -		else
> -			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
> -
> -		timer_set_ctl(timer_ctx, ctl);
> -	}
> -
>   	timer_ctx->irq.level = new_level;
>   	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
>   				   timer_ctx->irq.level);
> @@ -471,6 +452,19 @@ static void timer_emulate(struct arch_timer_context *ctx)
>   
>   	trace_kvm_timer_emulate(ctx, should_fire);
>   
> +	/*
> +	 * Paper over NV2 brokenness by publishing the interrupt status
> +	 * bit. This still results in a poor quality of emulation (guest
> +	 * writes will have no effect until the next exit).
> +	 *
> +	 * But hey, it's fast, right?
> +	 */
> +	if (is_hyp_ctxt(ctx->vcpu)) {
> +		unsigned long val = timer_get_ctl(ctx);
> +		__assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &val, should_fire);
> +		timer_set_ctl(ctx, val);
> +	}
> +
>   	if (should_fire != ctx->irq.level) {
>   		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
>   		return;

-- 
Thanks,
Ganapat/GK

