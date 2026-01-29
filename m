Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCD5359FA1
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 22:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724896; cv=fail; b=c7Ass1EciTYlXlTcoA8q2orQonY1ZK2eZRNZWKDxJfHVV/Pqje/BDtHxHwfSQXIFmND0GJnHIR6a4POXrbGh7TX5UNPDAVirLShdV4XlBDXreHnkcQ7rv4lNn6gKCgwlogelX8t6cU8vhczXkJw6adZn77Uhh86OsaCfQAbZKhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724896; c=relaxed/simple;
	bh=dzryPMaVO20+a1fBOZFpxd6G1nc1nWXgMvey69nUnMM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FklE7Eb1qi1ql6gf/wR0R/67FEItyHB8vFJhPIdAoWgkf+4I/6PVDc2l8H0Iwvc67qydo5Ie8CLJUz2FrknWZT855Qqx8qzNpkbVSTYct/u2kFymkQLolzstFgBDKg34mKh5nfphyMwSCWkMbvuGEAW4+sOoC6axJ7QyhlFOjOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hWPSo5r9; arc=fail smtp.client-ip=52.101.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hWPSo5r9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ew2hTu/CTO199lf241J52drJDmXl3tE+D91Aigftkvd+b6YEQFT1uqn1QMXEuxe8Ew/C2+DKGwR0C6lUwOQyK/KToNk5OADeu5EzewFII4mSGhzT/BDEGpCsx7tlRwgZ8XJTuEMSBoh6yI1ra9ARVaWdk7Dflbb7zh73zxc8j8xDhw/eqe9CRDfW2Uj2Bh5iDVMJ4sJKuled6aH1dyseiBVAZ69j7huaHk2LalDXmuYWW93wyb2lXVATARsZ6rk6b3ohOxM5ZOEMA2kH/Je5JQUyP86yWXG1NvmAaoFropsg0oGpMJXmk2j6bngIyxQ2nGRYj+mOf/bH+K10bTXYgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIO2vkcc105CXrUqKP18Scogmb7ApAsJL4lhnxlB/GM=;
 b=eQnyhl90z27j5Mcei7W5XEpc2s5pOVkhAR0b5o45Bnjvgj5UNKxy5cPFyvOZMNZP9ZbhTei0RJYk+3/QekD+fqIHQ5RMa5+D+XPUWtVwj9aW6anuv7otai13agOc0+vskoVd7MyptpfKrUtzEICaiIiBAXF7YViOwPWF88PYRGyFKTBSee5nK9lYrK1fPilpXnkp9CkPZUBY6MHRtjAqeZG3bLzh1ZN+yrHP4hfhqU311oK+jBk4jMfEfxRLR2lWNVFa2v89oz3riMrVLACOPHbqwOzdDzDWk2mAwWQsfoaJApw9V9fwn4RoWPdL+dtGXcV/KZyLITb1YU7kEnuozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIO2vkcc105CXrUqKP18Scogmb7ApAsJL4lhnxlB/GM=;
 b=hWPSo5r9DiiMDDi0mymoiWBKjseved78/TsQsY75CUgdjTkvTrKzGCopUVKMcjlY+4PZPyB6UiEPGzDGWpO3tJZ9db6RIhYlLOB5JkRkt7tRHXRMjRO8ATxbUVrBirbMW37AkPMJ5tRalv29rMhmrQSMFu77KElIpd6s7ZApNdxCPWRz1ZT8cLT/8h230LwIO79t12IXZeTUIiPZpSRGxqS7emChSGAdAb1P6VlO1swkrsok2l/ZJV3Z04UZpaQPa8q54rp0y9KTUIPfFmjTCzyb4uv4pb62lCJpr4EQEyxwchT2q3oS39UvzS5y3/djruJXBI7BOE1G1uMlHlXQcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 SN7PR12MB7131.namprd12.prod.outlook.com (2603:10b6:806:2a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Thu, 29 Jan 2026 22:14:48 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%7]) with mapi id 15.20.9542.010; Thu, 29 Jan 2026
 22:14:48 +0000
Message-ID: <e10fa678-9564-4e09-a848-fac22e1c9a64@nvidia.com>
Date: Thu, 29 Jan 2026 14:14:45 -0800
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
 <23f08379-301d-4ffc-bf6f-d6a7bb952724@nvidia.com>
 <e38cb392-ff29-4008-aa4f-e9d7166836f0@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <e38cb392-ff29-4008-aa4f-e9d7166836f0@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|SN7PR12MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 524f6bfb-aa0d-44be-4e69-08de5f83d095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2VxZjZ4bnZvc0paeFBUNEVRS0Rvb3pHUVVJTjhhRzBwT1dLdng0dkZiNjhI?=
 =?utf-8?B?cXczWUQrQVNoODVZSHovRnhjQUxrRkZlTUVtbS9jU05zN3crTnJLeExZZEtJ?=
 =?utf-8?B?cnFZbHlhWDcvelBkcTVhWncwRU1rRGxMaEI2cHNyRCtZcXF2SldpQXRSbnJk?=
 =?utf-8?B?RGk2TkF6UjMrN1VCRFRTSkMyYk90YUphVndJYm5RODNBWHg4MXdldW83VWUy?=
 =?utf-8?B?N0xqSkxiZGdEVHh1WjlhbkJLZDhkL2dVbDJQM2x1SDcxOWZSeVZlcEVqdjY3?=
 =?utf-8?B?eDMzL3NqeTY5ZHFWNlRqZXNaSlVnV1gwRGgzTFI4dGZPbUoyck1TdXFRU1d3?=
 =?utf-8?B?L1k3UEI5VUVhUkpueVh5UXd2ME9XSnc5OWVpQURrUXVra3lWU2FmaXBEVTFm?=
 =?utf-8?B?QytpR1J6T0szRlBBRm1XdWExNU9kekdPTnhrRVBBQU5ENlNkM3htNHVCUkYx?=
 =?utf-8?B?RURHWGF0MFYzZ2hjUzE1WG9ocG9sTjVYeUxVaHBtaWhsM0VOcFp5UWZQZkFO?=
 =?utf-8?B?M0JYZHcyeGx6cXBCMWZma0Z0ZjJwRmtNelc5ajNwRWpuNGRaSjNLTnZVWmxZ?=
 =?utf-8?B?MTBMQ3o3QlVQb2JROC9XY3A5NXNERmc0SEJsU0hBSmdsaGhiUzBDdGg1K3g2?=
 =?utf-8?B?SHorM3JnYUJUNytXc2hIZjlRN3lxQnJzcmRnMFVBL1k2MnZVSUJRemRTYmlS?=
 =?utf-8?B?ZGZIem5VcEU1c1M4d1Q1Y3ZoV1hjcFk1ZG4rK1hjZHpDQzBoZmhCTHM4U0Z6?=
 =?utf-8?B?cldJcmdWK3JaQkl4OFVYamNTRGpKcm1oWDVhYVl6Rjl2Y0JSVWpVNHpWNDBG?=
 =?utf-8?B?czdoaXY5WDhmQTRvcHJlR0pNQWlGcUgrNWJYOG9ZWGY4emc1RXBFd2wxVjkw?=
 =?utf-8?B?WHlYMWdzYkRkZ2p0ZjhiMnRsZVRkdnQrTFVLMHJDN1hXbU56b1ltRWdBL1I5?=
 =?utf-8?B?TndHQlVJWW5FRi9mQTVEdEhsaTJnOUd2enF0VEpZbzYraXRSNWI1c1JkUHJ0?=
 =?utf-8?B?UzEzNjhHRzJtdk1sZlpJcWp0QVhrSVdGWlVqNWo3d0hjRlpOVnk2S25Dd212?=
 =?utf-8?B?UW9LR0hGa2RwUUhiOCszaU9FL3ZwY2d1b0ZHZ1lhaEsyUmN6SHpUMlZxeFJX?=
 =?utf-8?B?WnVtM1I3d3kxTFZTejZMaDgxQVl5S0xEWlBmTDZON3VWVVRsUXpJekRFUEMr?=
 =?utf-8?B?RmRVb2dZZzJLekNQUXFxNHdwbWdMcHgvdVMwcFZzVDlBWEUzdFNmbEJTM20y?=
 =?utf-8?B?dVZUZytpNktEbEpFTzdnaTEvRGZwTHNYYkhGWWtrdEtGZU5JTGxIL2RLQ2xL?=
 =?utf-8?B?ZGgvOEluampEVVVLQk9XTGVJSkpIOTRwQmV0ZkYvTHk0cjVRYTVIWE53VnNX?=
 =?utf-8?B?L3lTYlF5cUNXcVpoTU9Sd0plRjMwbm1GdVBGTG4xMmNUTlczZG01eHM3Nmkx?=
 =?utf-8?B?M1kzY2hYWiswYm9mSnQyMUxiMEp2S2FaaUFPa1NhUlFWSkQwTkJnTkV1d0Vt?=
 =?utf-8?B?UEl5c1lhOUw5R1kyODhGd2xwMWcxSVlSK0JYcGhrRFlSbEw2NUdVdzA2ZTJ4?=
 =?utf-8?B?MXMrZU9yWHA2UExSbHdyUUpDUVlFcklnVzdZVEhQc1J2THRISEFBaG9Ibnpw?=
 =?utf-8?B?a1JoeXd2V0RSaWFMdlk2T1dKMHRkUXpweUxCa3hQc2J0MFNZaTUxQmdvUDZS?=
 =?utf-8?B?ekFkTUY5T3paM0xDd2Q3ZnRucE1WdlBqaUdnWS9tdUFIbmJuODBzOGxyU3BN?=
 =?utf-8?B?alZwRkZvWXFKVnR1ZldkTlFubmpnM3M0Vk9leEl3UC9URVJvV2JQdzh4NGl6?=
 =?utf-8?B?Y2dRZncxSHVpZVF6YU5FTkovS3BTYk9zVzQ3dWUxUmJ0L0Zma0FrY3RNdnN1?=
 =?utf-8?B?REtyc1dxL2o2U2NLeVY1c2FTOW8wUlphOFByOVFzQjZCRWhYcXhxcWIwQ1ls?=
 =?utf-8?B?SmNlcjJSMm9YMGhUaHhIMXhKcmcwU1BrSTd0bm5IYlYzQzllRytVaGgrcGZr?=
 =?utf-8?B?Zk9NbHBjL0U5SFpKRUhIL0V6ckVBQXVnRFVEdnlBRUxwTHJrVWJhbEZlNVNU?=
 =?utf-8?B?OUUwcU9MVm9oZUJuZU1zOEdDSVFNR00zNUdoR1VHK1VHUG5naVM4NEswS1dX?=
 =?utf-8?Q?ssRE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFFvMXhVSVRURWVsYUpWSmk4RGNHNGNvVVB1d056NGRvbXYzNmVUeUsxcVl3?=
 =?utf-8?B?bXFlRlhhODJ2bk95NEo1YVpGdVpNQjg0blN5NVBXczJLSEJQaFJWN1c5L051?=
 =?utf-8?B?MzJGSUFpZWEvMXhFdk96WlpMU2dVa2h0ZHMwUk5yV01rK3l5YnRmYm9LYjYr?=
 =?utf-8?B?Q01BSmk0ZnRxeHF6OGRuS0w0eDBUSjlMTlFvNHZOL1lUSXhzMzVnd3cvVjYx?=
 =?utf-8?B?Zmw4VWFUclA0b3JnRnh6VmtXNkNONVlYR2Jld20xYkljWitiNytLTXdyTzV0?=
 =?utf-8?B?UUpoNkdXemJFbXp1dk5uQUhveDROSW8vZkcvK0VoOE1qdlp0b3FULzJ4WDFE?=
 =?utf-8?B?YlRQaTJXUzBmamxkYlR3MEMyNG1RdFEreERkV3hxYjNrRUtKeUlrNWd6b2VQ?=
 =?utf-8?B?ZWp1WlpnZTgrWXVJSS94VlZkdndleWtlMXIyNGlRYUIrd0dQMXhmdGVqWnEy?=
 =?utf-8?B?TTBLTXpLTHcrcVFzc0ljeThSamFOVmZ0VjAvN1F5SENDSENlTUduTGJJV1pR?=
 =?utf-8?B?anAyaVhUb1UyOHgzaEtXam1MRUg0Zlo2WDRFVWh3ajI3eHJsckc3RFdZSjNk?=
 =?utf-8?B?akZSdkwzemRMWVNxTFF6Mko4WU1MY2V2TlpqOWZqRXdvMHV1Kyt4bUd4Mldi?=
 =?utf-8?B?OEhqU0JaYjNHYkdza2wyTkJXeEMzd083a2xqTy91elFkV2x2MDJnenRmQ3Ey?=
 =?utf-8?B?NVUrOEFCZ1FNd2ozTWhmZ3Q5Z2RiRjZUenRNcUgrSFZxaFYyQm5RWVFOZFln?=
 =?utf-8?B?N0ZLVGxGSGJVL2ZVMnQrSlhxNWN3VWdsRFo5cHBGT2t0SVdDUXk3MU9lY3gx?=
 =?utf-8?B?OVZkQStPeWRYVmJYUTFJZFcrak80YlpHVER3OHVvSmROZW9Ha1NOeHE0bGlM?=
 =?utf-8?B?ancwNWorV3JNTzBMOEJEWm53eEpvNXlRY3ZaSkk0TmJ5a1B5ZjBCVFFoMFlh?=
 =?utf-8?B?bnNqTzRGZURwMWM0dDdzZEpYV1ZuLzJVUiszRnU0bWNQUWVUYXZuS2YyZm5t?=
 =?utf-8?B?NEg3OUxjaWl4c294T09Ucmdna1hBQ3Q4VEpxNkJObXpNZ2VtWFNQdWlSNE9l?=
 =?utf-8?B?SjlINlFOd3Z6d0wxRTVZUFlyUit4V3dXV3dpbGxTVTEzNyt1RjFDVE9LdG0v?=
 =?utf-8?B?MVIvMjcyNld1VmpuN0tvVW9LS0N1Ti9QVGpDMVBrM2RhZWI1Z2VhRjFRQis3?=
 =?utf-8?B?M0dJVFlOZnpRL01BbUJsNi9Wa09uMEhqMGtIWjlBcWFRN1JiWitTLzF2ZVNh?=
 =?utf-8?B?RWMwZ1hOZTlPU1ZSNnBadGM3RXpVQXR5OGVEVUtUQ1lHMHF3OU1IbU1lZXVO?=
 =?utf-8?B?THEwclhyYnJLOGQ0ZEhOTXJhTWF1UmZaeU5uOGhxdDFCMy90TVZzNEpZK0ZK?=
 =?utf-8?B?K1BTOUFkd1h1c1lPTW0wUnFCa0RVbzZUZTR0Rmxma0hKSlFzZTV0K1g5dXFv?=
 =?utf-8?B?MnU0TENRVG54UkRLNmQxYVE4YzJwWXdCTUM2WGV5cCtLbWorWlJqSmRwQUJ3?=
 =?utf-8?B?MXpnRTA1SFZRTitHU3pQNk4vVjdRS0dxUUp3N28vV25ZUGtJKzhEblVLY2VW?=
 =?utf-8?B?cU9Obm00MmprR3QwSkR6TGFBSjBKcnhEKzJxWHkwNks2Tmw4Z1hXV2xaRkd1?=
 =?utf-8?B?S1JHRlF0RHRiQkNNY3NKc0s4UWt0c1RnRWI3Y2lZU2tObFJ2K3NCTWhuWXFq?=
 =?utf-8?B?VEgyOXZJU3lCeW5FWjBqNlN2RzdOZXpwN3A2YjA5cDNoRjdrWmhyL3FBbEZ1?=
 =?utf-8?B?QSt0SWcxaUhMbTB5T2RzYnQ3ODZuazJmc1NuZVVIUU1XbzNtdm13ZllBR0F2?=
 =?utf-8?B?Y0hKMlhQL2tzNTQrY0MrallmeSs1YlhWWVE0eVQ2TFEyOTY1ckRQUThXa3RZ?=
 =?utf-8?B?anVPWUxxeE90Uk1hd3FLRHlpSWdONGxBdHdmYXZSaWt4KzRiaW9CYlZrcUFp?=
 =?utf-8?B?ZnZWQTgxVFQxRmd5WDAxUHdoYXJtd0FkUnkrd1Z2NW14Q09CNmRGME5nQTla?=
 =?utf-8?B?UzNIT2ROb1A0N05nWE1VS21wQVowcHpVYnh1SWp3M214L1lmQWdNaVJTNXNZ?=
 =?utf-8?B?aFdRc0J4WkdtbjhTQWdrOGtkSDZtZlM3bVB0NStFYjdDT2hOU0MraHNxdk1K?=
 =?utf-8?B?OVVaRnRnd01VWkZUNk5nS09QQzl4NnFmT1NoSkJqKzZxM1ZWc1h0WVFqVGtr?=
 =?utf-8?B?WmdlT1pRY29FbXI4Qm1tUHRqV3BjaERvYjJBcUVhVXp3STVTZlJ1SXZQaVd2?=
 =?utf-8?B?RnNWaStUajRIWjFQdG9MUmJ2QmMxZm1BdjJSWUpiS29BVzl5d1RNRE9YZjRG?=
 =?utf-8?B?aDJsczU4MkdGUW9jTnhYM3ZpazRrN2cvQTBGSUF3MlYxRnRPdXkwUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 524f6bfb-aa0d-44be-4e69-08de5f83d095
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 22:14:48.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysZSwAAWlnSkRo5vUE12hbDFIM9K/n2iT9vntCkj4BbnhmGLC0UNNOZHZxcO7VjRobCq2OZr0hVYhwXXD6dm+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7131

Hi, Ben,

On 1/19/26 12:56, Ben Horgan wrote:
> Hi Fenghua,
> 
> On 1/15/26 23:20, Fenghua Yu wrote:
>> Hi, Shanker and Ben,
>>
>> On 1/12/26 08:59, Ben Horgan wrote:
>>> From: Shanker Donthineni <sdonthineni@nvidia.com>
>>>
>>> In the T241 implementation of memory-bandwidth partitioning, in the
>>> absence
>>> of contention for bandwidth, the minimum bandwidth setting can affect the
>>> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
>>> absence of contention can settle to any value between the values of
>>> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
>>> zero (below 0.78125%), once a core enters a throttled state, it will
>>> never
>>> leave that state.
>>>
>>> The first issue is not a concern if the MPAM software allows to program
>>> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
>>> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
>>
>> When MBW_MIN=1, min mem bw can be very low when contention. This may
>> drop mem access performance. Is it possible to set MBW_MIN bigger so
>> that ensure the floor of mem access is high?
> 
> Isn't that a policy decision rather than something we should be putting
> in a quirk framework?

MBW_MIN is 1% or 5% less than MBW_MAX.

The lower MBW_MIN hints hardware to lower mem bandwidth when mem access 
contention. That causes memory performance degradation.

Is it possible to do the following changes to fix the performance issue?
1. By default min mbw is equal to max mbw. So hardware won't lower 
performance unless it's needed. This can fix the current performance issue.
2. Add a new schemata line (e.g. MBI:<id>=x;<id>=y;...) to specify min 
mbw just like max mbw specified by schemata line "MB:...". User can use 
this line to change min mbw per partition per node. This could be added 
in the future.

Thanks.

-Fenghua
