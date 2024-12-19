Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023123.outbound.protection.outlook.com [40.93.201.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6801221DBA
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600625; cv=fail; b=Rv18hdIa1pRZBc1Dl+r0qSEvPrZF5MHYmsA2WqhUFMZJi1q2AwHYlGPhsH2ugVaI1tWTXZkyyK4KvbqLas14m8OumI++movLyBUXVP0QpOadBBlNN0j5ICwCNT3gJ0VF+u4+Fba7I+XcQHznc8EyhKxS9Ds0rIaUzyQJz/gJndU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600625; c=relaxed/simple;
	bh=6C4iuil3jhC3Wp/GhEfFtxKxSiE9P8S7QgQV+k24l3w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cuCmKHkyz7edblQSaBhRSqyb1qMIgEn1Z7Zslo4VxbFlLedxLXViw4+FVUminR01E4H9Us9lVOeTmR+7Bfb5VjstWbV3kVflDX2AYWs6s4Z2m9ZW2oWHrN4DJgKXeCDrZT4/MbvebtgxwNmEXe25diN5n+34C80UBI8SLiXchwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=InNBvkwS; arc=fail smtp.client-ip=40.93.201.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="InNBvkwS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9onQsnnjHlQSmixXbtZcw4MBwlNgt9SvEqaJDHM5Vcva7dCo0jjevAy74p2QbGADJgoN34tTrDHQQWqK7dU7ARcKI10ruL8ZgGbJxEKMXk3DKaDfaajmXuXvuYdEZ8h7dgaUyyU7RzBhFmU6YDetYLXjnjaGsPyH5Z1w4EahjQ+yjV3vg6rUHJG/0m8WDhsomAC6KQ3EOpQEJej9Wl9avoxVpsRDJilVorhbYkGxNCNZr/UI2fdWeZqco4eN0tGvpH6hCWtyeQZi/eCcF9xqcM1AEnwItWlR5s2pELGC1Jk7cH/KEn7zV92bSBtfE3+iHdHV1CFfTXTmf81dmsj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6STbcGUVrV02yV+VIfRfMGpByw1tF7jI3uvnLYM21/k=;
 b=DqYUTMZDftqDUr0AqrYRBQRE2bsQwBVMM5x5+PVJE1IoLwIn/SzYOWade3J1pbEKA4xSQDtzgNfo+j/TEJ8yZlyY9xN3yYQButeouoPtM3XiUwqiLkD8Sm6sK563ZMS8MKqIHVhApsmdHHLO31Vy4wDRjkqHHQqJ+9JuCHklopHfKvryutxAYjdPhHp9P1mzOfvdiZDNMYHpsS8t+2y4pvpDKVAZMO5dJ9QH7C/2l1Ms/LTvuEHq15YLR3cdkCpB1NWP1ZwfO3vM5zvokXSCQeyEWdRgq68EY5CM1WhHyHDFARLQY67g+VwiGfDhfeIg3OuRH1Q0Lwx31j/xcdeD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6STbcGUVrV02yV+VIfRfMGpByw1tF7jI3uvnLYM21/k=;
 b=InNBvkwSBql+uVSZiVPG0mt3moENizyonOUKPt0dnKdaoGW5F8ov6fS3rUHX8KFbGgU6HVmKSuS7KRu0E0QwDhoTzTBT9F28VWtooWJc7ah+6+NohzEkxppuNUP68+MoakVd7mA81ayxprFQJl2Qkjx35it9EblSF3FffVpupxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BN0PR01MB6832.prod.exchangelabs.com (2603:10b6:408:160::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.13; Thu, 19 Dec 2024 09:30:20 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%5]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 09:30:20 +0000
Message-ID: <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
Date: Thu, 19 Dec 2024 15:00:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>
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
 <8be59ff3-6a68-48e1-8181-0ce4b2e7180f@os.amperecomputing.com>
 <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BN0PR01MB6832:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cacdac-64e0-4ef3-95d7-08dd200fc178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk5DMEs1RFg0VE95cXJXczZTNkFjc1VQRWVSbEF3TmxmcVQxM205NTMvMlRG?=
 =?utf-8?B?OEYyd08xQlhUa0laV3gyYnVSRGJ3TVNQNW5Td3JLV2ZUWkpFZDVYRitEc2JR?=
 =?utf-8?B?UHBGRmxhWm56VHM4dnQwbi94bkdSVEp1RFh2S3RTRVBUa1ZUQlB3WUw2RHN4?=
 =?utf-8?B?ZWdMZmRrVis3bEVzd1FoVFVqVjN5MHVSalVZK2JOdzljM0tXd3E0MGxGZkxa?=
 =?utf-8?B?V0YxRTkxTUhzWWRjNmQrK3dDRzBaWCtKbzhWTVgyV0V4OHc3ckkxb1NGa2Nt?=
 =?utf-8?B?dW5sUStoS2FaaE9yRXYwdzdYYkh6QXhIamYvMUJCT290QTJZUHlNM25qTDRj?=
 =?utf-8?B?YVJSQ0o2RUV5ekFNTmNDVCtGYWlyZ1Rhb0l3UGJUMGVWRWVXRGFwYUFCTW9w?=
 =?utf-8?B?cnNDT09XSHJ3WDE4ckNwYTkwU0tzci9LSXZEbU9Gd1VGMDdSUGJiY1hUU0RP?=
 =?utf-8?B?Si9INEFFR2RjK2pIWXIvS1lBZXJYVEZFOXJCcE5OSWRFZGNMcGZ5ZXh4OUo5?=
 =?utf-8?B?QngreUthSlJVNitwcXF3NndwN0VYNHVoYTZnTkl4d1FqRU8xL256TVZtSWhx?=
 =?utf-8?B?YTdmZklGamdPbVhLZXk1cmdEZEJ5SHdvdGhTZ0FUb2pQSEZUeFZYcWFmOXFD?=
 =?utf-8?B?em4rR2cwN1pBWTcxNXpMQitrdHU3cHFFWVY2dGlucGl3d0ZnRG1yQTVvTUhG?=
 =?utf-8?B?SFZvcGpYcGZ5dG41NGVwYWx2dlFaTFJnRVBzM2lwQlMxaC9ZNUYweTQ0dEZ6?=
 =?utf-8?B?SUtYYTZ3N1NvMVYxaFJXQTB6YUY3eHEzamRYY1dkb3B5QUk4K1ZUdEFQZEd6?=
 =?utf-8?B?Mm42azdJTjNoSTdVZHpiY0UwZGZlSGc1QjIzc3hYMzNxUDV2NzNreXl4SEk1?=
 =?utf-8?B?eitIaW1YZ09FeUNlaXhyQWkrSG54bDEzOERIcUpJUzRXdzFOeUREa0FKd2Rr?=
 =?utf-8?B?Y1VQcEZWQlU1VXNjSVpUcVNKWVhqQzM2WVJ3V21yZ1A2bkVRK3NpWFFteCtI?=
 =?utf-8?B?TU1NMXNjaSt0U0k3aWF1STROYzRpL0lpeUNlays5Vys4YkVKZGpvWXhNbHM0?=
 =?utf-8?B?ZFBwUDQxWlY2UXVQNHdjVzd2b1FnQVFJb0lNV1dNNW1sMVVUS0xjc2E1NWtW?=
 =?utf-8?B?NkFGb29GZlNnYlZFZDlNWm9oRFBxWm9uMlNWclNDNWNmc2xXZlNwdDMzZ3lk?=
 =?utf-8?B?UEcwU3VVZEtaRTdZblByelJYb3c1dGtBdUJ2WTlhVFl2SjFGb0p3bUpSM0Ja?=
 =?utf-8?B?WUJUbk1OZkEzM0lJbDIwUzVncmJxT3dpSVMxQmFHaVNmeGduQVd0TUJ3OFVr?=
 =?utf-8?B?K2k4cHRBejhtWCt6UEk5Y0d1OXZuLzFvd1lGaUhMb1EzUGIyZUZWK3F2NFNY?=
 =?utf-8?B?Z1p5Y0pKWmQwOCtaMHRBZW1rRG1ZdXJnT2tTK21QZVBrRkhQc1R6Y0VRNW1Z?=
 =?utf-8?B?eU52cWJjR3FHdmgxM0drcStTOUdFYWUxQ2VZQ2szN3JJRzRaL2x6S09zSkxS?=
 =?utf-8?B?c01CU1R2SS9aZk5PZ0pJSVE5UEhIUGdVY3FpUVJrcURick80SjhBR1ZPNXpW?=
 =?utf-8?B?RGZpME82c2ZZeVp3ZzlzYlFjTHc0Z0V5b2s3Z1FtbzJYSFZnRmtrS3FDS2dV?=
 =?utf-8?B?VEtSdFlyRnBVK1M1T3A4Rzlub1VaeFlEbGVhL1h2WGcydG94ejUrUDNKUjc0?=
 =?utf-8?B?MThGUzNZZ0w5blZGWmYwQ0JQckJIanRaZXkvRU9mb2tQUE9pQ1NXMmlReEE4?=
 =?utf-8?B?aHlZc3VJL3l1b0Mxa2htZkZHS0tGNDBFS1o3UkVPSEFyNm85bDVGYk8zMCtk?=
 =?utf-8?B?WnAwc25jSWgvTS9rbDg3VU9oZXlCNURSRCtWVGRldnFxdUorbGt3azZ4QkxW?=
 =?utf-8?Q?CVzY9Ajfye5m3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1R6ZXFpVWJVcjZSOVdDRW0rUjlnWUFUUzVnbTh3Q2RyU1Rsajh2TTBkd2pa?=
 =?utf-8?B?UTlZYjBaWDJNMEs4ZlF3SjRaUW16dlFQc3NTRkFNaVI3WFdVNG02em1EczY2?=
 =?utf-8?B?cGJGaVVBMHJ5WC9rUTY5WWVLY0kwaHVEamtzai9mcFdPcFVuemYvTkVRVnp2?=
 =?utf-8?B?SFFSUU9VYlVjRzYxUlBReWRpWk5BaEdRbTduRFduU0I1aWUrdFFVR2ZIQ1BL?=
 =?utf-8?B?Y0NQcGxEU0toWGpEVE8wTERyUHpMUDg0dW9BYys2S21MRWdRT2RXL0czenJr?=
 =?utf-8?B?M1JXSjRIRlZoVEQrZFZIOUo4WXd6T2xKN1U3LzJoS0RPZHBPZVJkMWQyRCtJ?=
 =?utf-8?B?dUJYS3JhbU8zS0NuaXkvd3A5T0UvMVU3S3RYNmg0UWF6TVhiKzNVMlFjK3Bt?=
 =?utf-8?B?T1FRZ0tKc3daREtHaW1TV3FOaEkwWU1pbFNweUQ0Q3lZNHBlU3VkZjdxTmNj?=
 =?utf-8?B?clVJSFdXQnprYVZZcFVkVEZ2T3F4bmZ5ZktHMWlSdmY0Rkp5UWJFZzFYSTRQ?=
 =?utf-8?B?ZlZqeHU5Sm93TExDeC9WempZemhDcXg1TDB0ZnREYXNDV3FZWnpMZFNFaXhw?=
 =?utf-8?B?SmhLcUpGZExCTlJlNEord21nVENDZTZheTFJNDkrQjJ3L0ozVTV4bXJPdnlW?=
 =?utf-8?B?ZWJGTHArWDEvaWliTmY0U3psVlNDUG5yQ2VFTVk1UXJOQ0FHbU9wOC9ZYjZl?=
 =?utf-8?B?bzJmaDAyZUhZU0J6TnBHbUNyWHRrTnRqWkFUQ1oyQnQ0L0VHN1hBUUpwM1M4?=
 =?utf-8?B?N1lVSytCcUc0clFMSkRVZ1N3T2FFSDRIU2oyaFJkRGxVVk9iRG83Nlh4QnhH?=
 =?utf-8?B?SHlDSk1VK2ZtRlRiZUVsNlI1VHhKbUNzWXJXc2sxTWpiWlU4aVBaMWJtWXl5?=
 =?utf-8?B?S29VbjZSMUNxN0ZmQUplUFFCdDBvcm55ek9mT3JZTklJdDF3c2pGakRVUGVM?=
 =?utf-8?B?aWVDd1ppOHVYUGw2dE9Ba3ZPZVF1bEg3TjFsY293aUlsT0hmRzd6RExDNmc4?=
 =?utf-8?B?SXVQZEw4dFFDbUE1c2JRU1NUU1ZReHk5SWxydGdJQVMwbmN6cXZqcnJQYVNz?=
 =?utf-8?B?ZXRqNG9uNWNBYklqZVNGUFhad2ozWVFUZkptWFV5MjBJaUFlcjFkZ1F5bElR?=
 =?utf-8?B?eVJkTWhvT2o1YVRha1pLTHdLaTBxMUVLYVdFeXdkSEhMWEVLV3A3N3AzYkto?=
 =?utf-8?B?dmluSkhiWXd4ZThyd21DaTdZMlhnNldKN2VTbXhnSVVHUElJQ01IelBVT29a?=
 =?utf-8?B?MVR5RHErMk9MSG1sNkx3c1VDejNQa1YvN1Iyd3RHRzNWdGxwaERJYW13cVJr?=
 =?utf-8?B?eFZLK0J1Zm44NnVvR0JOcHlEaUJTcERiK01RMnZBZUZuOE4wdHBpUVlJcUR0?=
 =?utf-8?B?UWc0VlBuWDVNM3REMU1MYUNadkpVdkNsU1JEdjMvSDZ6R1kySUtNRkk0TThL?=
 =?utf-8?B?aEw1VTA0YXYrVjlCcEJjYUhVYTZmUlduNldrbk5SRmlxMExQMEw1WGdnSWFL?=
 =?utf-8?B?Szh2Unk3L01DZXpyNGprUXZpZzJQZ2Q5V0YzUXJpMm1nRTJ2aUNaYzhxM29o?=
 =?utf-8?B?bFJva2NKYlBEQTBHWjdnSkVwaU9pb0ZzRjhUL0JHQWxvTWkvaHRYRENxTUpG?=
 =?utf-8?B?VERBNnNMd2xvbGJxQzRTaFV6SjQrTWlDd0ptcGNKdVZlLzVYVk1HVXBOU29Y?=
 =?utf-8?B?NDRmMUg4ejhlMnBXNnBrMVlIN2xCT1ZwSVc3ejlxWXh1WVZ1aUNlUW1yS2po?=
 =?utf-8?B?NnZNdENuNThUSEFPd2U4eEkwLzNLdVBlT0IzcGVEaStzcFhyNjBjRUc2QzdL?=
 =?utf-8?B?SXBkTWczMzhLL0NBcWdJdnV1T0t5Y3VBZmhPTHNNa3VkZzRMbXpPbFpOZkl3?=
 =?utf-8?B?V2FGSFV0dnFRWVhua0MveitDd3IyY01SWEdtcFcyRndtZWtFZjNMS2lWZDls?=
 =?utf-8?B?aGUraFhXMnJ6VGhhak9tUkxsUHRXTWxSTkMyRW42azBPNHo4eUNHVnlTNjBF?=
 =?utf-8?B?UGFqQzZBWU93Wi9qNFhQNDVHamlTM1ozUDJnVzIvL09sdG9GQmRqZ0hwajZh?=
 =?utf-8?B?QzQ4ZGtWYkE5SmwrVkplWk1KSUJGRnByQWszT2FPd0lQcjN4cXpyVjU5Ty9O?=
 =?utf-8?B?V2NJVXZhcXREZmJBd0hxY1d5aGJwN01JK0RucEZRU052Y3F6NkNCSnc4dmJX?=
 =?utf-8?Q?3ao97VyVmZnJ9nSnkQV0SbaF5KE3WR8Nxp88X4IjliHY?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cacdac-64e0-4ef3-95d7-08dd200fc178
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 09:30:20.0284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfggLP0ZnmzpD/uyOzJKbmsancTPp5pLbNRYC9v2Wb1gOVJoJbBBqDQ9m20nQKgQp7ks2mrHwxxSrTI9t0diUS8u5wBoK9LKwbVrY+qutR16XSOeBKncxdzY8uI4l5kx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6832



On 09-12-2024 11:04 pm, Eric Auger wrote:
> Hi Marc,
> 
> On 12/9/24 18:30, Marc Zyngier wrote:
>> On Mon, 09 Dec 2024 16:46:30 +0000,
>> Eric Auger <eauger@redhat.com> wrote:
>>>
>>> Hi,
>>>
>>> On 12/9/24 16:39, Ganapatrao Kulkarni wrote:
>>>>
>>>>
>>>> On 09-12-2024 06:50 pm, Marc Zyngier wrote:
>>>>> On Mon, 09 Dec 2024 12:25:34 +0000,
>>>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>>>>>
>>>>>>>> During automated testing of Nested Virtualization using avocado-vt,
>>>>>>>
>>>>>>> Which is not merged upstream. So what branch are you using? Based on
>>>>>>> what kernel version? On what HW? With which virtualisation features?
>>>>>>>
>>>>>>
>>>>>> Testing is done on Ampere's AmpereOne platform using 6.10 based kernel
>>>>>> with NV patches from your repo.
>>>>>
>>>>> Grmbl... *Which* patches? At least give me the SHA1 of the branch,
>>>>> because I have no idea what you are running. And 6.10 is definitely
>>>>> not something I care about. If you're using the NV patches, the
>>>>> *minimum* you should run is 6.13-rc1, because that's what the current
>>>>> code is based on.
>>>>>
>>>>
>>>> I tried 6.13-rc1 based nv-next branch today, which failed to boot
>>>> UEFI as L1. Yet to debug this.
>>>
>>> I confirm am stuck with the same issue with nv-next on AmpereOne.
>>
>> All I can say is that it Works For Me (TM) on M2 and Snapdragon, using
>> kvmtool, a fresh EDK2 built by Ard, and with the guest running purely
>> VHE (FEAT_E2H0 not implemented).
>>
>> I haven't tried QEMU, I don't have an AmpereOne. I have also spent way
>> too much time on this recently. So I'm afraid people interested in
>> making this particular combination work will have to debug it.
> 
> yes I do agree. I am currently setting up kvmtool to double check and I
> will debug the qemu issue.

I could boot Guest-hypervisor using QEMU with -bios and nv-next as L0 
with edk2 (QEMU_EFI.fd) built from upstream tree and fedora-41 as 
Guest-Hypervisor.

The issue was disappeared when upgraded from fc39 to fc41. Same was 
experienced with the kvmtool boot as well(KVMTOOL_EFI.fd).

-- 
Thanks,
Ganapat/GK

