Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011019.outbound.protection.outlook.com [40.93.194.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C450930FF3C
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 23:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519264; cv=fail; b=WKyfiNAdzry8BEcdJ37ty621U7QnWCK3Amr4+rv43ousqj4kuam5M63NztIJl5wjrWEpQ9N1u3P5sSqyi4nhKm64rcrO7nv/5nX7i2ednnsj0jl7c1+zmAUqjSLZK3vbiESIMj6dSiyHMFy6zoFuhK1XR+FWGT12DEuNkhS8Or4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519264; c=relaxed/simple;
	bh=i0LXK3kb2gBX42kYenBH9FWJP0FBXYeDPJc/hiD8TTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YG15wHtBBR0ikCB5jtxEzHmOfoHJukR9Y9en/NcHi0YBcLFTGXZLNfmy/15CAFADmF/r+gRrWXpjDsflhDlDlIpi/qZNMDL+1LCxELHPaM2k6x+22/Sj5IjS5oszuz4AuwaM8Cgrj+YYYp7WOd1enuKTDzEjYjuHI5OKE+tjeMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YJz0+kaw; arc=fail smtp.client-ip=40.93.194.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YJz0+kaw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvJxUlqtZGNh/iQMhLZA5no7LT/q/zKlV2YeK6lFhclbsMmMV4egO53PknXxSt0vD1fUO9a41hbVQQMymWpLCc/a2SkL11BuOyP3eBTK1tu3EK0Dy4+vYg5SqVHHvF8cmthVbk5cT4zYJgObOVYn6riKVR4d43j6dpxPrnguzX2JLf6LOsmxqq+iSvfClV1e7IcKDQI7uDcLAGvZAnyRXihGQRp6N3icULKVRLNBDCKl9YcrO6kwKp4O/CdVvYllUL/nWIqDi23AguSqHtxoo7HSjZ/2J/FX5SmBuc88WFB4Bh+bJjqgoWlhzUJIRN8dwXwdABnMfAQxQBGbJZwfbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaTJr1HFM4sMHAzzUSeXCYZJRvOA64vdwnaFBY2BqQk=;
 b=FPLhBPccxrLOw3LqFFfZuxBv2BWUilpeKXAsYomw2Dfy1ccNSoJelx2NPAdevUgnJoT1Oe00PdA+4XU4LPfOzUSiOxGwPw2sf/Pxg9aSI3Fq5abLRemTcGiwjT0KrWVtbbHIuw920DJ9T6uxoo+FpaihsPsF5g1ksphPacx9eln0QYCo23FI7sfyBpad7MR9LtQk29S79B/U5rDSsxmr1GPLarC5mRj0L3VcC3GjoYYrEkQmjPQQlfaZmP4182XfNTpbia0Zhq8ktbEng0MdorTcKWfqG597Bh1ChpnPmIqmGSlIQUkohTite513rQyS8tnKJy5f0GMtVTNEDa+gDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaTJr1HFM4sMHAzzUSeXCYZJRvOA64vdwnaFBY2BqQk=;
 b=YJz0+kawQOtcHbQ0f3VYILCGFk7RzR3cdxf1fEdL8nD4JDHro5jmkP0SoW5+6WzNCrtR8WRzMllummpKnWEYAqb+YCnHGnnxXbN8MbhT7Ns39LzsTfXm2Gqe9frWiFj3clvsHuCXmZwXRxt5SZlinJDsnLI4pAljATw27rA1MUgivWUgMbefsONy5FddNoL8tfg55BOT8D9JWtYNsYInMglKQS/brhHIr3RZgm6WM0XfofvL8jemHNZe8GsQvTAfZShUY/Afjxfm/LrKJDZmSVW9aUyGIdFW1TsQIM15ZBbORctxD5G7haVNj/eUrD7/hbmxmCvjh2A4Sx3kr2z7sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 DS0PR12MB7677.namprd12.prod.outlook.com (2603:10b6:8:136::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.4; Thu, 15 Jan 2026 23:20:59 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%7]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 23:20:58 +0000
Message-ID: <23f08379-301d-4ffc-bf6f-d6a7bb952724@nvidia.com>
Date: Thu, 15 Jan 2026 15:20:55 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 45/47] arm_mpam: Add workaround for T241-MPAM-4
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-46-ben.horgan@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20260112165914.4086692-46-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::22) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|DS0PR12MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: d590a08a-d2d7-4ca3-1dbd-08de548cbd8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V09Ed2Q0c2NiaHNHc0hZV0pkVXFucU9ienpqbEFLWTAvSjlPSmYxMUtyS2Zn?=
 =?utf-8?B?U3VucnRldDREQmtSeVpMYXRjSTh2bHBSL2prSEk4c2gvay9aZjZmUTRyWnFw?=
 =?utf-8?B?bUFvZXlKYXV2MVRQcUNWZWovRGxqem9OSmtpa1g5T1FpRnF4NGhObW56WjVZ?=
 =?utf-8?B?ZGN6YTRJMlBTcko1RC84eEt5c1FDNTBpbnZicXIyRjVWM3NNRUFsRWpMRWw4?=
 =?utf-8?B?MG5XZ05JLzdIeVM5enFkTUk2QWl6UlBwNVdmbEtzQjBsSGI4dFNEZHM0Zjlj?=
 =?utf-8?B?OU51UVp0Y08ybE85QmQ1YWxzdy81dVNhMTN6L3lJUEMxaWs2d3A5RFk0Y1JD?=
 =?utf-8?B?RCs3cFpWd1YzaEJ3MTBpWG5XbGF2dUR4aVNQSVJtcjBWQnhWQTVrNWVNT3dW?=
 =?utf-8?B?MkkwVSttUjdHamMrYU51S2tGSExYRUNpRG1EZFNwTy9BNkJRVHRjQ3RxeGpj?=
 =?utf-8?B?WmFnZHRkNWNVTXZKb0R3VDkvSGVzQlQ1d2ZFV1EvZnQ0NGZ6VlFOUHJSUkcy?=
 =?utf-8?B?MTVLbjBQNzcva3FZT1U1ZEkwamwwRXlnbGN2Y2hsK2I0U0Y5THJwTkFwTlFh?=
 =?utf-8?B?WWFqK0VRMHJ2cHAwZzVwaEhCOXUzMkovUTBGalFGdGNsY3ZpSmpUWjdjUmFO?=
 =?utf-8?B?ZHlMNTBRU0JMaFU1c3FQN2tTQWNsYUdOY1p3ZzMzRDN2NnF4Q0gxRjhsUVpj?=
 =?utf-8?B?aUUxT0l4Uzg1NFlOWERRempDOUZ5ZXg3dWppTy94SDAxeU1YbUk2M0Z1ck50?=
 =?utf-8?B?a0lWcjBEVVVhaFZMVUlEb2dsTFp5QVhTT09MeDJ0T2ViTU1MNnZSMEQxOVhJ?=
 =?utf-8?B?QkZXT2g4K1U3TGhrWStkL2xyQXJhRC9uNTV2MVBkalVJdWtUUGg0YS9PRDNa?=
 =?utf-8?B?czY5bTVzOERFNDczUW5pYTk3QmRpNURVWllxL1dsNXhaYnQwdzBqL05uK1Zv?=
 =?utf-8?B?Vy91Q2ttRGVNR3kwcTZUSmNQQjF1YVhjNjBOSzlXWjRkQjBiWUhLeGl4M3E2?=
 =?utf-8?B?WlZmUlJPUHZNUzFZOW1ZbEFKdVI1VW94eHNmMmhGYkRXbTFnc2NwNm5HNXlx?=
 =?utf-8?B?ZW1PUTVjellRUFo2ZFpzczlPVHZ6TEtkeFVCRWlLdm5yVGw0ZWdqck5vbkJu?=
 =?utf-8?B?WUJMV01wSkFIZ05aNmJ4VGx1b29tQ0VnRUxSQklUWmNselZwWjJJUm1QcWNU?=
 =?utf-8?B?L0N2MHpkNGRoM3FuaTcwVHA5SUZqT3ZCMWFPbkVuQVA4bEZWaVl3ZXQ4M1h6?=
 =?utf-8?B?aFdiRGJhdVZ6Mi9Td1Bhak9nVjh2TFMybzlMM1Q1VHd0bHdKZ2tVNk1YUFk0?=
 =?utf-8?B?VlQrWWRJV01qcHJ5VWNlSE9oa2R3eDZKdmliK1FpOGdkWERsWXFWVm9Pem1z?=
 =?utf-8?B?UW9DTWdzV3hOU3VCWkd3c1BOS1ZNMlBJMjFZcjdxZERmazB6QzhocVMwRnlm?=
 =?utf-8?B?UmxTOWV2L25rVElMd1dTQ3c1V21ySHBJRCtUa1lUWUVEbnFJdFdGUDJzaDQx?=
 =?utf-8?B?SmlEaVhjOEVmWC9iTWd3UFZjTk1sNDc4ZnlMTEQrUzZvTmFyL3Z1TGxmRUQ2?=
 =?utf-8?B?b2lhT2UvVU1wcnIvK0ZwMW1rNjd5VzZ4dmF1Z09COXVWclNWR1BHazFKbDBX?=
 =?utf-8?B?eVRpQURvb0xoWi9EMVVPZHlmdlowdUNIZ2dvYVhlTDk5V2FDVGx5VDMxY3l1?=
 =?utf-8?B?QVdRUnk5M01sWnltTHlZSTNXWEw0QTh6MjYweEE5eFZUcDJQV1JnaktXSzA4?=
 =?utf-8?B?V1h5ODJkcDBGa0wwaEJyTjF5ck5qTzZISVcxVXdWUEQvZUxtT1pRb0g2K2x3?=
 =?utf-8?B?aEtNeVhOYTFmZXFtSFRQQ3hXZCtFS2p4STBhbEhIQjU4cmhTT1R4bDNwWnRz?=
 =?utf-8?B?QU1VZVN2TkcwLzNDeWptTjhHejhJbjU0S2Izc1VJeDJxdmdobmIydjhDOUY1?=
 =?utf-8?B?RGx5dWdLZGtQeUlXdkFOSVp1cXJqRDBmaFltalBMNHJqNFoyaWdlRFVITk02?=
 =?utf-8?B?b2tpNktIdXRqT1BObzJsdUJFeTdmWkZmMkhCV09UTUR3SW9NV2NuTVFEc3Jl?=
 =?utf-8?B?ZEcyZE1pYjhnb1d5cDlLMmpLdDlITy9mSGc5OFNMbXNJeDRkcjRSbXdUWXNF?=
 =?utf-8?Q?Sc9U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFJsMjc4NnUyRDBJMUNlc0t2dVFHb1lHM2gvQk9SNG5yalBUeGFOWStjSnhp?=
 =?utf-8?B?RDAyditKZ05Fa25ydkorL2g0VERqN2cvNWpudEluTHlLeFpkL25BM2p3R3Jk?=
 =?utf-8?B?ZG5IN0lXT0F6eDdjb0ZLMWxHNmVIOFN6NHpaUzc1Vm85RXpOYkNOVjhkSXpR?=
 =?utf-8?B?SU45R1hVK0xWcXhhOUdLZWZoTENuTitaTGFkZzc5bllBYmt5bnNYeTN4am9V?=
 =?utf-8?B?UFJZSENVNW1iTStFODgwRm9lZDJhOWpLalNtaHZpWDVtdy8xdUNvL0pPUU56?=
 =?utf-8?B?aXgwaGZ5bUhXc2VVLy9oRVhhRGRyVW1TR1l0V0dEQ2V4M1dEendQSGpUcE5u?=
 =?utf-8?B?RE1lZVpwQWl0dll2K2tjaXJqTTlpNURId0cySDBBWUpFZVEzSnNycHpGWVZG?=
 =?utf-8?B?OTNUdGpaRitrajR2L3Z2YWlEYVdIMkZySHluK0NaRHExcDRoWWR1NVg0ZElm?=
 =?utf-8?B?RGI0MWNUSmdxQVpIN2k4ODh6RWpnaVhCTVdnSnNCQmNxTERQMkl1Rm8xaW9C?=
 =?utf-8?B?NnB0VkJ3UExEZE1TVUJqMS9HRmlwTDI0N0xXakhud0x4L1NnQTYyL3dPWXZl?=
 =?utf-8?B?MVRrR1kzcHNuWFNVSnU2YVU1akZPdU5iU3hGWStLTW1uUXRHcmdHSVp6WlNL?=
 =?utf-8?B?US9PdGl2VG1YVGJZcVlDaUdHMFgwNDJhZjFadkl1QlZCK2tnazJFTjZ6VmJj?=
 =?utf-8?B?QlJDZWJwQlVPYVZYNnRtV1ZLdlFMaVhZRWdyMmJZQzlOWmIyWWRZdXlScTRV?=
 =?utf-8?B?MnhUTmdZR2FZaERIcGZISlhueDNJZUtORHVCVnpmaVBQV1hkV0FyQTY2MVpx?=
 =?utf-8?B?RWF5TFVPR1BWSURkK1lVRnRlZ3BMdzBWQk0yYnJpMFdjZG9NZ2pGRjU4b2oy?=
 =?utf-8?B?ajkwYmZlSTRzQ3NCamVUZnUxUEQ1VU9MQlA5YmpCTEw0aUhockp1VHlYeE16?=
 =?utf-8?B?cG9BQUJuQ2JxdHg5Uk5QZ3ZJTEE3M1gxd0p0VnB2QWJ3cjdXdDM0cDlKZSsr?=
 =?utf-8?B?RFdKc2pGZ3BMQXczVXVxZmcwUk91K0luakx4dFh0OVJNN3BxSjVVb2FXbm92?=
 =?utf-8?B?M1FDZTV6ZHlTMVFGdUttOW1nWVMrRE1JOUN5YU1OdHVCYmRtQTRZZnNNcktL?=
 =?utf-8?B?MEh6cm9ycVZhcm43NGJpRnA1UXJ3QXhqRWUycHhMbmsrODlsVC9ZY1paT2RM?=
 =?utf-8?B?NTdZNGZydWZ1bnNqRXpuSnRUN3RjTmFhZ0Rqd29XdUtIUllTY2NuUUdSYjVI?=
 =?utf-8?B?VXJCamhOVmt4d2JmbHNEdEt2SFpHN21yTmNka1VDNXhlTGlkM01jbmZwbWlq?=
 =?utf-8?B?YW5nalMxeUZlVWNRWnh1ZU9Qa25qTEd6L2dieWRRUU1LK0RRZi9pemJ0clIz?=
 =?utf-8?B?YzhCWjZ6VEo0TUFQVDR0aEVMdTBTNnJJZFk5dFFnSjRFM2VQZUdnYkdSUW1B?=
 =?utf-8?B?dWFnSnQ1aWh2eUR0MGlsNVVKbzBzcVVOTFRmU0kxNkU1NUthaXA3QjI4OVlC?=
 =?utf-8?B?Wm9xcWsvWGJYUHp1aktLL3dONzJ1OW9vY0h2MWR4QkkzQ3hteG03U1FHTVlr?=
 =?utf-8?B?RVNTeHJYVmROMWw1dWNqMmlnaW9jb2lSRm5jR2FCdnlKdTBQTGJPWkk2d0dF?=
 =?utf-8?B?TFQ3T2E1MXcyUGR6aFQ3TWFJTGFHSXZtUC95ZTd0aW9FVXdxaytvMlkwU0pI?=
 =?utf-8?B?cDIwdTVNTzRSQzBHMmErRmZoRDdaM2hzOVBIOCtUM0FNQVhGQXdpNEU2MkFu?=
 =?utf-8?B?MGhXaCtZTTZVR2t3U1FndFUxWUE1WUZVWFFuamdFb25NSzdySktjYjRYTDFv?=
 =?utf-8?B?ZDZ5MVZiSVVHbnZhazkzUFAvK2VHczFoOTJQVFdFQld0a2taSDdwckpNZzV1?=
 =?utf-8?B?bDF5dWlhejdDSXFGMVgrb01tVFdoNEVaT0VnOHpNSFIrY05NZjBoMVZFdU4r?=
 =?utf-8?B?RXc5V2YrbWZHV01VMkVzSFJ2UFVUTjM4aXdZaHhLRDJBeEJqdFFJN3B0ekxr?=
 =?utf-8?B?eG5XMFlPbFZiWlZodnJFQmliL2VpUzQ3OURyNFdRd01CclFydUxmbzBkdnVK?=
 =?utf-8?B?UXUrbmtvK0I2Uk8xVlMyZUY1UE05cWdNeUs0U0IyRlo1T1VUU25HdERQMDBJ?=
 =?utf-8?B?dTZUbFBiUXRrRE0rQnJMckZicWRqYWlHaWg0a3JiME9iMEgvTjNyTkswNUpS?=
 =?utf-8?B?K1l3MDd2Um1kZkFEZ05FZGFoQUtXWk1DOWdnTmROM1loS00zYkh6V1BGV0xp?=
 =?utf-8?B?OUlMK3FHdS9UaUFrcW1mbFlEU2NiZzF0VjdUc1gvN1NzTmRIdnE0dWl3WUlD?=
 =?utf-8?B?VnRZTEVDa3VmbCs1a0kvSjVzQmJaVTNrRGxSUW1RWEJWdktoSmsxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d590a08a-d2d7-4ca3-1dbd-08de548cbd8e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 23:20:58.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRmfZJaAgl/DqUC7csd8kDoqjLHJyDhXc8xdFj9cMk4cTXJT/wrgzQE6/SvaCfic2Muj8OM1udjmKTaZIvYLVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7677

Hi, Shanker and Ben,

On 1/12/26 08:59, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> In the T241 implementation of memory-bandwidth partitioning, in the absence
> of contention for bandwidth, the minimum bandwidth setting can affect the
> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
> absence of contention can settle to any value between the values of
> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
> zero (below 0.78125%), once a core enters a throttled state, it will never
> leave that state.
> 
> The first issue is not a concern if the MPAM software allows to program
> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.

When MBW_MIN=1, min mem bw can be very low when contention. This may 
drop mem access performance. Is it possible to set MBW_MIN bigger so 
that ensure the floor of mem access is high?

Thanks.

-Fenghua

> 
> In the scenario where the resctrl doesn't support the MBW_MIN interface via
> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of contention,
> software should configure a relatively narrow gap between MBW_MIN and
> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
> 
> [ morse: Added as second quirk, adapted to use the new intermediate values
> in mpam_extend_config() ]
> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> Handling when reset_mbw_min is set
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 ++
>   drivers/resctrl/mpam_devices.c              | 34 +++++++++++++++++++--
>   drivers/resctrl/mpam_internal.h             |  1 +
>   3 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index 4e86b85fe3d6..b18bc704d4a1 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -248,6 +248,8 @@ stable kernels.
>   +----------------+-----------------+-----------------+-----------------------------+
>   | NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
>   +----------------+-----------------+-----------------+-----------------------------+
> +| NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/A                         |
> ++----------------+-----------------+-----------------+-----------------------------+
>   +----------------+-----------------+-----------------+-----------------------------+
>   | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
>   +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index bdf13a22d98f..884ca6a6d8f3 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -679,6 +679,12 @@ static const struct mpam_quirk mpam_quirks[] = {
>   	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
>   	.workaround = T241_SCRUB_SHADOW_REGS,
>   	},
> +	{
> +	/* NVIDIA t241 erratum T241-MPAM-4 */
> +	.iidr       = MPAM_IIDR_NVIDIA_T241,
> +	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
> +	.workaround = T241_FORCE_MBW_MIN_TO_ONE,
> +	},
>   	{ NULL } /* Sentinel */
>   };
>   
> @@ -1464,6 +1470,17 @@ static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
>   		mpam_apply_t241_erratum(ris, partid);
>   }
>   
> +static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
> +{
> +	u16 max_hw_value, min_hw_granule, res0_bits;
> +
> +	res0_bits = 16 - props->bwa_wd;
> +	max_hw_value = ((1 << props->bwa_wd) - 1) << res0_bits;
> +	min_hw_granule = ~max_hw_value;
> +
> +	return min_hw_granule + 1;
> +}
> +
>   /* Called via IPI. Call while holding an SRCU reference */
>   static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>   				      struct mpam_config *cfg)
> @@ -1508,10 +1525,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>   
>   	if (mpam_has_feature(mpam_feat_mbw_min, rprops) &&
>   	    mpam_has_feature(mpam_feat_mbw_min, cfg)) {
> -		if (cfg->reset_mbw_min)
> -			mpam_write_partsel_reg(msc, MBW_MIN, 0);
> -		else
> +		if (cfg->reset_mbw_min) {
> +			u16 reset = 0;
> +
> +			if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, msc))
> +				reset = mpam_wa_t241_force_mbw_min_to_one(rprops);
> +			mpam_write_partsel_reg(msc, MBW_MIN, reset);
> +		} else {
>   			mpam_write_partsel_reg(msc, MBW_MIN, cfg->mbw_min);
> +		}
>   	}
>   
>   	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
> @@ -2570,6 +2592,12 @@ static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg
>   		cfg->mbw_min = max(min, min_hw_granule);
>   		mpam_set_feature(mpam_feat_mbw_min, cfg);
>   	}
> +
> +	if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, class) &&
> +	    cfg->mbw_min <= min_hw_granule) {
> +		cfg->mbw_min = min_hw_granule + 1;
> +		mpam_set_feature(mpam_feat_mbw_min, cfg);
> +	}
>   }
>   
>   static void mpam_reset_component_cfg(struct mpam_component *comp)
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 9d15d37d4b5a..7b4566814945 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -224,6 +224,7 @@ struct mpam_props {
>   /* Workaround bits for msc->quirks */
>   enum mpam_device_quirks {
>   	T241_SCRUB_SHADOW_REGS,
> +	T241_FORCE_MBW_MIN_TO_ONE,
>   	MPAM_QUIRK_LAST
>   };
>   

