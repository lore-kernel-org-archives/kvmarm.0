Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020082.outbound.protection.outlook.com [52.101.51.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F1383A5
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 05:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727673522; cv=fail; b=cva+txIplPc+jq4I3bTbSUXKTeLVLUDkqhP4meVm1S3c9X3tRqHRDmIAsuWEWJbhuLKePDBi9ERqf2tJhysy5NBZkeLq9ZkHUaaM7TCor7wuBGZ22MaZgeupx8kLJ8hoDQ6npxscSzULz93cXbrALHYHEvzwRXOzZbNemTkZUEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727673522; c=relaxed/simple;
	bh=89Z+uBC9n+CTebfPpVCiZe3odmXgUn9QiIdAiQv5mdw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kWxvA80gFUPjjHm5H1xbXUKwq96XHnJud/Z+LZ5def1y6zjIeEiIjg3blk6+VjEQHsrA0Fw/qHIgAF55BHKPZB/cLyikVilCkKKX1pr5Ln+YY2x+dqzru/1Qi2l1+fCektqQVb9RIh2l4AjXSpQZ0LxVGJjQ8ffwE/EfAODB4D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=UdmPtWD2; arc=fail smtp.client-ip=52.101.51.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="UdmPtWD2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTkrrQcQ/CauKdT18/p/VbFn1aiIlL1mqFewKQJ0YBj2TxL1AXVAi14yiDLe9/R1Zo2b4xgb9FKaGW0I0A+y/QJHn5f9n2+1a+qkskr1C5evhFvD3PteV+t17u74Tsb7uzSCnHGGuudx2XRm+/pbpltLFHQ/yISn6zdZ0Z/ptARmWpuABjtxnDQ3J65ocoPgyDKliub7pLG4yCqOi0373vYD9NyfJqm9Kqhpw9av/8Q9ntM+lwemr4D9DtO5f1rvFBIpzvIXt6nuZRnx7VVK72XdxpteozjuBax4uE16TVWGRmUR/StplJP0ftEHj9wStJwX1UnwBCPKIkoPOvXE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IC3A433X10j/I7EM8yNkH4Uz75c+rL5RsM+hJdBux2c=;
 b=TcT/44hl1CDX1oDZazqMvUqxnEyHeXA7vLEgFTCKn/xDKvos0nsWOX0iqD2MQ+kvvT+t88SkV0dpqWEQ87IdKeHPn8luQfZSQi3CjRUyNO2LSi7Eu1dGipED1C6H2dBV6FwCr2hKc9eSqivZy07+8303FopgCSe/BRkWPy5H/V8XcwInUKF/Nik7FlKtOLmG2Fwxag9qMNjPG4I/NEW7+M79I86q3vF5+XFpZW88N6USukouAjUv5ER9UWfRb9qLT9ZE1p6ynJiHUjxrkwZUdWITlGAFxBkf1u3fLrFMTl2Vb09/9+taLk2X4Q9IwJmAnZ2EsQk8t7U9DtVPCGsheg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC3A433X10j/I7EM8yNkH4Uz75c+rL5RsM+hJdBux2c=;
 b=UdmPtWD2J0VMMUGYPsujtRSf/FePdV04Sr7Kts8vn0AXTHLLRQjfcTVNf8m/jsm355eK9Of//Sb/cHNBxzrHDqQgCystpt/kJ3n9qbM7wPQPSC7s1IJoSMXmkhRFv+neuP4VsImRNEAz5ohOJNRM6nD0/cfNrJztYM6tV1B1ozQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 DS1PR01MB8846.prod.exchangelabs.com (2603:10b6:8:21d::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.25; Mon, 30 Sep 2024 05:18:36 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.7982.022; Mon, 30 Sep 2024
 05:18:35 +0000
Message-ID: <f9ba0b4c-b7d6-40da-b84f-525cc0bc4a25@os.amperecomputing.com>
Date: Mon, 30 Sep 2024 10:48:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] KVM: arm64: vgic-v4: Occasionally issue VMOVP to an
 unmapped VPE on GICv4.1
To: Kunkun Jiang <jiangkunkun@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 wanghaibin.wang@huawei.com, tangnianyao@huawei.com, wangzhou1@hisilicon.com
References: <c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0114.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::12) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|DS1PR01MB8846:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fdc1bb-8f3c-41a1-275c-08dce10f5563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTRNb3BzLzRGUCtNM2NoRkh5cXBNbm85VEJuYmpXQlpxWkxiU09FUWduVDl6?=
 =?utf-8?B?cjM4ZFJoS0ExdTVXSTAzb1dzK3NBc1NSRDhZZmRnUHQxd1A2QndXUE4zZUF6?=
 =?utf-8?B?dHg4USs3VE5haVBtVzh1UkpIQzd5dHpnenpuT2pUNk5vS0ZTWnlXYmJUNjdP?=
 =?utf-8?B?MmoxSnFYcEhuNGlJbWlTL2pTMlFYSm9wY1BMNU16YlB5dmNrL2Rxc2oyLzJi?=
 =?utf-8?B?OHZrMmpWTjcxbTZTamxGdVFkOEVaVkxLZCt1aVRvY2Urc21NaE40MmtVVUVI?=
 =?utf-8?B?YVRrVmxQNWUxR2dmZHJBWTlZQWllMDh2RXpIMytTazcyRkhUYW5YaURtZUl2?=
 =?utf-8?B?Zkd4ZXRxT1ZzenNXdk8xZWw3aGpKTktsVkRUVk1zK0ZUd3BENDhqeEh6UG5M?=
 =?utf-8?B?R25LVloxc3d1QkxMM2lOWTRTUW1ndGx2cHBYcjRXRlFRNlFCeHlUTk9PaDlM?=
 =?utf-8?B?Rmdoc1pabjE5bTVTTFhMUjhqcWV0elZKeXlUdnBoOFJrSC9lWXI2VXgxOWNk?=
 =?utf-8?B?aTRIZW00MldxaGRWdkZtZEJ3Y3RLd1V0eFVxdVBndlppc0V4c0lRY2pSMHgz?=
 =?utf-8?B?MkJPYVVqbEh4VWh0SEFFSEVXZHh5OGV0eWxScjdUbDBZNU1RZTdtaWNCcWUr?=
 =?utf-8?B?Q1VvMngwa2xXSGVYR2dYVTd2Z2lCdzhwZFQzejRWdlpKakpMUkRRNXdySWgz?=
 =?utf-8?B?VkNLRmZkc2s3SURETGFTSHBJUHM5TkFGQ3l5QVRXN2RtM1grSW43TEEwRUhq?=
 =?utf-8?B?TzFuUnlmN09XWlh0QXRZRmNhdDhNQUpGdHlLY2N0dm5ac0V4TkQydGR0THhz?=
 =?utf-8?B?M1VBWU51TlhrTGsveVdTaEVxTGdqdXV2WFBLVnc4YnVGdUwzVUxETnB4VFln?=
 =?utf-8?B?NVI2REZuR1oxM05KTTRxNWlwQ2RpYUR1K09sRXl4b2ZmaHNoelJ1bHdnb0g5?=
 =?utf-8?B?MjE4ZGNlc3gxTXlXbTNDL2srLzA5NFZ2L3ZmKzJyQndWR2hjSjNoREtBbmo3?=
 =?utf-8?B?c201Tm1NWmdVVVpxTDNXMytPalo4dWVXYTZuZDR2L0s3ZW1wWCtMcldqL3B2?=
 =?utf-8?B?UkJLU24rekdCWlB3NWhEeHZBUVo4VElXNDJaTDFDSm41dTAybHYwOVhyOWg3?=
 =?utf-8?B?eEY2VEZIdlVPUTdMVWxvVWFDbkJnLzYzTFhDdE1iRzd0d0IyTzAvVUJvTURw?=
 =?utf-8?B?OHliY3I5NksyeTJqWXlVYUNDTWJBVy9vUHljMmdFSHhiaEpFaEc0VEZMS1lK?=
 =?utf-8?B?cFlxSjdGMlpiOGZaNUk0eWtTOFVPUnpGUEthVTljVFJYakxiSUxNSkZEeU9q?=
 =?utf-8?B?VW1DTnp0WXg4a1BETzk4UmNCYkpWQVFiVElzVWdEbkJlUTlFWkNEZGIyWTho?=
 =?utf-8?B?WWgyYlZBOGNwNHdLdXJzbnFuWGhPUGFMdkxnMkU3RGtYSWpHR21NTStBaG9l?=
 =?utf-8?B?U1dMSkw4b2FGQ0JCaDZ1ZWo4N1ZaalF4dDkzV1J3U0NBR25YM2hRQnhMakNO?=
 =?utf-8?B?YVB3QUJBWS80QUcybmdyU1E3eVQ4K29uUkRhUnhZdmtSMUdyN0NpdTRrS05x?=
 =?utf-8?B?UUJpUDJpZkxsc2p2b2VEbHlDVi93NGlYVVhFYjNWdEs5SktwT25MSk5WS0xR?=
 =?utf-8?B?SEZXUm1NaU9QUWNNQURsQmZLUEFZbnArTExseE1zRDJ6a3lBcTJTanpWbVEz?=
 =?utf-8?B?Q3BlUTA2Z0lrL2xEbjUvUTdySklwaW8vZXZ6VnZENnBFMFNXM1lCazcvcjlu?=
 =?utf-8?B?SElwb1Z1UWJYZ0NDZkI2aWNJcGc0LzNxRHhWZUNMMXFiYnlHSUhXa0VwSS9t?=
 =?utf-8?B?cEk3LzVNOGUyditTQWRrUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFIzc0dLSWhyWkQ1NDdpYmhKL2VwRjhSWU5tVEFYdGNpVUhPQ09jbjljTTdZ?=
 =?utf-8?B?aHNWQnUzekgwWmhzY2hVSlRNdElLR0tudVpxTnhtdTdHVmljemdNN3c5Zm5q?=
 =?utf-8?B?YTljNStyVXh6L0luMzJTNUhxaVZ5cjFmTGtzTWxzQXdWY0tnQ3dNNVJDaVVY?=
 =?utf-8?B?MFJ5Y2MveHp0elhrMDR3d0RWUUN3SmE2ZGUzZFJvNmpRcVYyOEZTZ1ZlY0xv?=
 =?utf-8?B?UlBDZnJwNzJVMEY1SFQyYWRGNTJRVFM0MVhVdHE0SUs4M2RzS2x1NjcvN2Zi?=
 =?utf-8?B?bHpNcEZ3dk9peG9WZzVzZ3NMWE8zdytHVmtvSldkZW15VktyZkNSdFB4ODdi?=
 =?utf-8?B?WDFoaVJhdXFKOWt4Y2xvdi9FZllodEZlUkx4blRvUSt4amtWYXJmanA4N1pp?=
 =?utf-8?B?MXc1T3dNM2MyYUJ5b1NaeDVON2ZhZjNuYTA3WWl5bGlwTW5uR2dHNTBSb2lu?=
 =?utf-8?B?WmxjM0xtQ2pXVVZqL0ErZDJJVVhubFdJbzkvSHdQaTFLS2lBdzBvWnJIVy9s?=
 =?utf-8?B?Uk5GaFlzM3QxU1U5NUI5S2tIdVlQQUR6Sy9pRkJTeWpMNHlxS3NGVEFXK1Zu?=
 =?utf-8?B?Q2syL0RwRzh5S3MvMW5zK3pxUEIva3hBbjdhMHI0b1ZwV2MzT08yb3ZXRmM0?=
 =?utf-8?B?Mnp6cTZmSE01d0tvYnA4cldUOW1BTXJZeUdEdUpKdDhQNGNrSmNZOEYrY1Fw?=
 =?utf-8?B?ZGRUa0kzMWZLZ3ZhdTNxVSsvWXpKMU9CZWw1WlRxWXlxVTd5Yk1lQXZoYVRF?=
 =?utf-8?B?c3B5cDE3bmVIM25vcjg1OGFCUGxOcngyZDJGYUxDMDlwU0d1alRmcGdJbkxH?=
 =?utf-8?B?ZS9sTUJqYk1LL1Y4MGhmOS9YNStJbll1eTBQenhRODJlZlMzTnBPOVM3NGx6?=
 =?utf-8?B?S2V3UklDcGIvbGVLUzBqQXJhUG9OSUdvRVErRW9NMkxhaDlHT0FSVkdQbVo2?=
 =?utf-8?B?Wlh5Q1RQeG1MQ3ZGNHN2R3NVY0ZLOG5mellLbTBTVmRhZkVIaTQ2cWFWYTJR?=
 =?utf-8?B?L3RGVEp2a1hWMk5GTEs4blN6RnBZRjhXamkrU0N5MUhxbUFEd3N6ei9iMjBD?=
 =?utf-8?B?c2dic2VoVHZHK0R6bk5rbnpZekFCdWxIekg4ZzNxQjBNa2M3NXR0TEJPV0p5?=
 =?utf-8?B?MzJFZTVPT2R4TDlSUDBSRENUanRNZzZGTFphMlZaaFpGL2E3QkQ4Y0RCYmZr?=
 =?utf-8?B?azBUU21pcTNkanpwSGV0S2p4dklPMmEyMFJnZHYydmlBb2NZWjB5eEFoRXVV?=
 =?utf-8?B?anZiUmZBSi9SWlRidzhWS3IyWlBZWXVPRVdIVEZmNHFhZGtSSWR1bU54Z25U?=
 =?utf-8?B?RzBKbkNQT1NIcmg4WHBQVWtFRGhmbEt6d0UveDc1aDVONmkrSjlvYkpobVhB?=
 =?utf-8?B?SE4rc3BXNG5FNlhRYmRLMU1vais2Y0ZpN1FiTGlPZkdoSnlpdUVZN013eUhs?=
 =?utf-8?B?aXM0c1lDOUU5cThyRGtWdzBtRG50ZHZ2aHZHMTlRS2VjMnlZRmg1a09WcWVl?=
 =?utf-8?B?RG16WFRmOXB6WmVnelhCRjhtbDNkNHorbVZ1UjArdjlBVktnbEFzN1laRnRn?=
 =?utf-8?B?cEk2R2ZvUU5ISDUza2ZxSkNPRnN4c0FYdFpabXVCWTlhVXAveVRJcWRHclYz?=
 =?utf-8?B?WGQwUXNCd2FtVGt1MWJKbHg1bnZ2ZENyemFiWVlxLzRYekEyaDRmQWtqOHpL?=
 =?utf-8?B?Z2tsQVNYcjJ5dUtVSWUvRDVSOTlTZWE5WEdGM2xnWHo5Y0p2b3gzV3FNdy9p?=
 =?utf-8?B?YTh1WGJ6cXJoajNnUmFqeFZVQlJ1cVdudWluTGI0ekgvd0p1enpBNWs2U0dY?=
 =?utf-8?B?UW1PbnViUTROWUFrR2hiSkZKY0EwM1FQbnNJQzZHS2ZzVW9qTmVoWFRrU0xW?=
 =?utf-8?B?MzlQM3hGUlg1ekY3WkVEcnM4ZS9BRnE2QVE0M0hibWQ5RWVtODVFUFFsWFJm?=
 =?utf-8?B?TlFYQXlSTE81L2NBUTdkT091dFNPdGhVM3hQUnpnRWFna3BWeFBoRzk2TEhm?=
 =?utf-8?B?bFZzVlAvbEh0bHRoVUlXQXNCVlhMQUgzSVhlUUVoejFFL0ZUN0x5VmVVbDlQ?=
 =?utf-8?B?WUcvRzdPL1l1QlhISEY5QkhsaU5RcHY5Q0UvdFV5SEVXaHRLU2xYMkMyRHcz?=
 =?utf-8?B?dldSMXNYZ0xSZkYyMnVOVFBRVnBwcXBtSzkybEF4Z05JaWh5Tk1yZmhnMVc0?=
 =?utf-8?Q?8/6zKgaUb298I1Iq/sUm5JQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fdc1bb-8f3c-41a1-275c-08dce10f5563
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 05:18:35.4498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9kzLtdQ4mB2abj3GH0k5yC7XReMXefZGuh6SZEK/4JJPYFmP+qRXlnX9dKkqQDBE4BpoiKXPEmA+asonTtu5WBkJl2RZZ7I/2dP2FFYwVghJDvIvcKdvD1D40jm6EuS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR01MB8846


Hi Kunkun,

On 29-09-2024 12:48 pm, Kunkun Jiang wrote:
> Hi all,
> 
> I found a problem with occasionally issuing VMOVP to an unmapped VPE on 
> GICv4.1. In my test environment, operating an unmapped VPE will generate 
> RAS, so I found this problem. The detailed analysis is as follows.
> 

May I know, what specific RAS errors you are getting?

> The vgic_v4_teardown() will be executed when VM is destroyed to free the 
> GICv4 data structures. The code is as follows:
>> /**
>>  * vgic_v4_teardown - Free the GICv4 data structures
>>  * @kvm:        Pointer to the VM being destroyed
>>  */
>> void vgic_v4_teardown(struct kvm *kvm)
>> {
>>         struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
>>         int i;
>>
>>         lockdep_assert_held(&kvm->arch.config_lock);
>>
>>         if (!its_vm->vpes)
>>                 return;
>>
>>         for (i = 0; i < its_vm->nr_vpes; i++) {
>>                 struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
>>                 int irq = its_vm->vpes[i]->irq;
>>
>>                 irq_clear_status_flags(irq, DB_IRQ_FLAGS);
>>                 free_irq(irq, vcpu);
>>         }
>>
>>         its_free_vcpu_irqs(its_vm);
>>         kfree(its_vm->vpes);
>>         its_vm->nr_vpes = 0;
>>         its_vm->vpes = NULL;
>> }
> 
> [1] In irq_clear_status_flags(irq, DB_IRQ_FLAGS), the status flags of a 
> doorbell are cleared. DB_IRQ_FLAGS contains IRQ_NO_BALANCING. So after 
> this,the irqbalance.service can schedule the doorbell.
> [2] In free_irq(), the VPE is unmaped.
> [3] In its_free_vcpu_irqs(its_vm), unregister_irq_proc() is called to 
> delete the contents in /proc/irq/xx/ of the doorbell.
> 
> For VPEs in large-scale VM, there is a centain time window between [2] 
> and [3]. The irqbalance.service got a chance to schedule the doorbell. 
> Therefore, the VMOVP is issued to an unmapped VPE.
> 
> I tried not clearing IRQ_NO_BALANCING and the problem was solved. But 
> it's not clear if there's any other problem with doing so.
> 
> Thanks,
> Kunkun Jiang
> 
> 
> 
> 
> 

-- 
Thanks,
Ganapat/GK
