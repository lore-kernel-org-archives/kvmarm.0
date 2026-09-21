Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B34494817;
	Mon, 21 Sep 2026 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992364; cv=fail; b=oaj2AdqqQyew61VOE45gT2ORDSbUJzh4KFVMjDNu+vj5FZ+449u1DQi5uq8xy3ifkYx3ewsx0b9kh8pFuUPMTYOJT+u1o2GzRyDv9kO0p3CZyfpKsOY1O7SBjd4xrX6/2Q/mAQzkm2F5HbHVHa1zsJ4876TzMmFV3o5t5Ga8Gjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992364; c=relaxed/simple;
	bh=1d9/uH6WYIJ5zIbiMvLFy+rkpmdpoxfgVuQnyFf0kc4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SWgzDfonAPOldLX9YeBqyb+FjCTxQcVOoe+8a+Rv+UgdNNZwipjlArRXmDCQFqE4/xUon8mY0eM54HBuZBoWRftispngneYo5kC1vNVWgdjlwgdG6B5Sms6tzZxfOKqQbRVpRUkL7sxVmV/i5y1IkCWbTdvlLANw50aW5+zzr/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kzkzurJQ; arc=fail smtp.client-ip=52.101.56.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kzkzurJQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJ4MUiUMIqhixQ5OcZhZmd4nkm75+bPBxDXElq5WM9xuL8MmNlxnBqhYry/65gRn6uFAPhK4zrYard/i7JOMWxxiKEEm0bnIPYE3ybtEIwXihcWn3Ozj4KccTZsFt1yPBrsgah3ND6k//xcArBXNtpkMcPADg+64lkjuEAjre3ltqfX/nwXGuJNDT9yTRjNU8tOSAsDO6DUNVFedwvooWMlqnz1Y5HLQLQtW0WeT9ivvRhZ17Dw8s5YM9/z/DM0OCXBh5+WQY3FbsuBHlzjA4bY2kO9RO2W18j2ddeq/BlAZNnhalx+F6lHbMB37fVGPly1ZY3iT4pxC3ILCM5/r1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNQhr9rBu8mM55aNRKf1YFcvj8FACeOm4a2xF69xTOA=;
 b=aBLwltYUZKGobhQz2a0UZiiHBd4+prq0e0+RvPlY6C1PRC65XKWZPCQdj7pA+cQkoCgzizuEo5LaxpcTR4kvSiIa7XZUBxZIRQxd3dgT7v2Ge6zQPYBxD3v+BSUVYWlibOmvC01NbIrHDmg/Jts25+ZYOc5a13NrCrngrEY6BgJw0bk5HKQaDb//6RHFagohNstveQHyafm2dQIpbEg5WoPfrRRPvpIn6TGd7ZYHI1l+kQoqBSz5CGNfXcK5q+fiQQd76KWLaIGi5IG7hPxExb/Xg8NwrSMxwOqe1C9SrKX4jGcxGN/3bBv9L+qMzCujjODYW5ybOjgfONuoE3wDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNQhr9rBu8mM55aNRKf1YFcvj8FACeOm4a2xF69xTOA=;
 b=kzkzurJQvd8A5VemSSyHp9V/f560vCO1P0dXG1KGlYUBE2vLhmICQpqz22PPG9t/0YMQgwTEzBSlrL9A3nr+6V7/OpX11h0Kc0F7pqNezVgWsELxlJRgZsKn+Xgcp48xlSG9fjp7+fjVn7Z8KIZ5jXDwXYsH14umJF3peuxf5HQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by SA1PR12MB8699.namprd12.prod.outlook.com (2603:10b6:806:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:05:55 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:05:55 +0000
Message-ID: <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
Date: Mon, 21 Sep 2026 14:05:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, "T.J. Mercier" <tjmercier@google.com>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260921115141.GJ11599@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|SA1PR12MB8699:EE_
X-MS-Office365-Filtering-Correlation-Id: f3df9640-2f4e-4285-aa8a-08df17d8b0bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lE6Fvf8xU4bqEidO/nRwKsmR7oxVTUjb76KqVddB6imaBwstJGfURirHusMParUB9gnaig6fqwBaPbMCaVz3CcNltuL5lzvstDUDkCmrx+BRCKetiA5F/KPJh5eetN/xfhdnz974eJJ+hLgkkw28c6sbP0HEkyhiknJFtWJbLySFrQiNdyXZ8W48LZM1AZ/6qe8EiKquVhgZohfjTgxLVIGTZoTIUdl9Ou6/JD+IHeqKWWhFCrtMg7E8j1RENArl/cu6fzlX2GmjvWLqfvq/cg+frmPF5GwJRU6SvG2JSgA20pRDYbD08eMkSjFiNiW2qvCy3XrEdygZhWty2pk9FnipJPmfZVZM33Q06tbrqKCSQ0AJDCZfXNOpFPZx65XauegGJ/hapvhtx1FNyy6hw79poRggpxtfhcPt6AFUDKeYmA5qEJ6YXv+UF0rYAmxPw+MMPBsqUEHtjl0A4MLq5gbAaQcOFNXgfSK9iHaKefOobgltNiKRBoYnv5gJbJJL6Tin45XqI+iZe3880dvjASZahncyTOdyr4crRK8dafWMyq3DcAH0apTU6ahAFNoHomQO4DwDkd1qJ+v81Dw07bUTWPUrbfD5ms0NNvRj6aYlmR336yI6LvNgb+IxiVxPSNqXIYBEfI562CSpZ6P1fdnJ858H9/LSYZBtoyaAPkE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXdwZ3c5bEtrYU5EQzcrMXQ0NEdPcVJmbjB4cmI2TXJMaDRQTmoyd1VPdUhn?=
 =?utf-8?B?RVBHajZVSjJHMUZwckJTb1VRazdpSzhXd3RLbXdxZmlHVnFQZjIxMDMySUhY?=
 =?utf-8?B?aHowVCtEakNFRDJWazNtOG5yNmJyUWp0b3ZwU1NsM2twRjF1NS9LQkxGR0wx?=
 =?utf-8?B?TVhxdDJmR0RCUVFDZmN6d3hpd0V1SThYZmlmTkljc1pCd0hJd0NOQlVoR3Fh?=
 =?utf-8?B?aFRVcm1YdUM4K3VjazZlVkE2ZTVGc3JEN2h6ZzNJa25kVHRPT2dXQ25KQmZF?=
 =?utf-8?B?YjIzKzNNTVlHZzlueXMyS3p1ZjROYjJZYzEycGdkRmFvK3BTcVVxclI4cFF2?=
 =?utf-8?B?bE45M0FGTlJNaG9aakFHOGlwWm1mTUNGbDJmWllnSGY5enhGdnBGR3dPQ2lj?=
 =?utf-8?B?WFdlWEN1ZkVzVktpd0l4b1JZU0pVQWRFM1ZuSW9XTXRZYjlseTBuUUoxZnJh?=
 =?utf-8?B?QTF6dmpGOTU3dllIeUhoOWFOYlYvcmllbkNIbFladWxIUjRaajFXWWNVdUNL?=
 =?utf-8?B?RXFQZkNCOVduem5yR2JuL0d0OGZKL2FmUnp2cDlQMVpXNWZaa0xwS2lGR0No?=
 =?utf-8?B?NlVXb0dWQVByOW90Z0RzelhTSHJPSTlGVUEyMlJmRDdnK2ZIczJjc1hFRDQw?=
 =?utf-8?B?UStpMFQzVUUyNUtDc2FGZ1hTVWExYWRWNEJGTkswSUtQN3pLOWRMYWs4U2FU?=
 =?utf-8?B?U3RpQUJjUURkREZoK1JFaHhRNWFvMjBYNGlpbXMwaWRKNHBCOFR6dzFyVlZs?=
 =?utf-8?B?TllnZkR6T3VPWVhCOVBtdEFjWGJLWXRJNmI1UVJmZUJxQmxRaGN4ZnBlWVk0?=
 =?utf-8?B?NFlPV3diWXlwd2JmdlNQaVlXK1lDNXU5U1dYMmY1TTZQTkY2YUsrb01nRHlS?=
 =?utf-8?B?U1ZyVUdNNjl0cFFnSGdQZ2RueGh3NHo4d1lsWW1lOEFCdjJTTnBuNllYV0hK?=
 =?utf-8?B?YTBtUlVsZmJzcHRLQWFWaW5mdENtajdqT0VzeTEzRWluZHNZakRDSjlzWE9r?=
 =?utf-8?B?M3VpUTVYQ3VoZk44YXd6Q09ZQUhITThLWFYvdVB5Njh6ZjZVbXdhRS9HSnZP?=
 =?utf-8?B?aDIyS2dsdTBLOFhuUDhhd0ZxelN6QTQ1UUJocjl1aUtTM004L2p0TkZkZ25B?=
 =?utf-8?B?WStTY1FoSzFpMHFDcDR5Y2F3RUpxUm95VXFzMGhic3RiZVBRcjBBMTF1azd0?=
 =?utf-8?B?STRqTHpKNC9DT2pQN0lrYWN6V3FXY2ZVeUpiUkROTEdzMEVXeDJ1cXczS1Bu?=
 =?utf-8?B?bUQrdVVXcWltMWdZNjBxaFVGVER2K0trWjZtUkd2MmJ4TmFBMlFLYi8zenVU?=
 =?utf-8?B?ZWY2QUNNaHJNWFAyNXpMTzdCL0t3aEh3OFBGRkNCcEs5YU9lTnlnR0tSVGJz?=
 =?utf-8?B?aFFadVdsaGVCN2o5NXUxbWttWXRJdVRFc3A3d0hDN0tXNG9rNCtjM2p3czBS?=
 =?utf-8?B?ck9rL3JlSXpsY1RMVjRGSVBUS2p3cExWRmhuODJRYmxyNkY3RjlDYXpTSVhy?=
 =?utf-8?B?ZHdZeTFoVGFIOWdxK1FCNlRNTjZyUnd2SXZ5REYzU2tiUG96aExMcHJKenFE?=
 =?utf-8?B?aGVKVFpGMGNIT0dJVmRidjhvOU42V01jM2JtODV2cWgwWlAxc1A1QTg5Q3RU?=
 =?utf-8?B?QkJONXpHRHlTTUNWSmdneHA3UFdacEVteittZytDWThqcVlxWDhiUFVnOVox?=
 =?utf-8?B?N1Voai9kVDI5ZzgxYy9MMk02d1Qra00zMS95c1dLRzdSaDZ3SGN4U2RXM1F0?=
 =?utf-8?B?S09YckxsUDVTQlJOZktYK3JVaVl1bDVxTUp5dG94R0NTUDRjRCsveDJPOUo1?=
 =?utf-8?B?Q2FMNTlXUjZPdlN1VjQwVW5NRG5KUEl6Z1M0YlAxWkRXdUVnMmh0ZFhubFNM?=
 =?utf-8?B?cU53em5Ka1BtRm9XQ0dQMXY0Vm8wRUw5WlJnM29Lc0hlM0hQY1dvdDBSVStT?=
 =?utf-8?B?bEJXQWhOQUxKa3JScElacFFLOGJheVMwb1VJQzVpRWpJNkpuS0JhLzROaWJi?=
 =?utf-8?B?VXZDS2pCMmU4amlPdEo3eGN6TEY0eWs4ZmQxLzZTM01kalpJT2hpaVJzN01R?=
 =?utf-8?B?T2w4amU2N2xjRFhmdGRieVdkM0RrOHFPb1hUUHhNQ0MrMnVuODBSNkcwQVBr?=
 =?utf-8?B?allzSXJjcW0zRzRVRXV5TzhsT2JwbkZUb2VwRjNnaXl2YXpqRTZnUnZteDlI?=
 =?utf-8?B?d29LRU5pN2JSUW5zS2htNU1MVzVHZmc0bjdNS2orVlJMWUJtU0NNUmQ4Vmx3?=
 =?utf-8?B?cER4T1JpNkh0Q25pSHU4OU1ZaTYxbSszeXVZTW5vUUd3MkRLVnJXWnhuMDlj?=
 =?utf-8?Q?GUri9FZNMkGqfVbNnh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3df9640-2f4e-4285-aa8a-08df17d8b0bd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:05:55.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHrl+eD0PyPLy9xD3nSE/EV5GyxyY+A7zNneLgqoZ7IMiP6mvBos13iBRYCU0lER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8699

On 9/21/26 13:51, Jason Gunthorpe wrote:
> On Mon, Sep 21, 2026 at 11:07:17AM +0200, Christian König wrote:
>> On 9/18/26 18:53, Jason Gunthorpe wrote:
>>> On Fri, Sep 18, 2026 at 05:39:55PM +0200, Christian König wrote:
>>>
>>>>> Arch code can figure out how to do it. If some ARM configs only give
>>>>> order 4 folios or whatever then dmabuf heap doesn't care.
>>>>
>>>> The fundamental problem is that DMA allocations are highly
>>>> architecture and device specific while Linux memory allocation APIs
>>>> are generic.
>>>
>>> This isn't a dma allocation, this is a memory allocation.
>>
>> No, I mean this is a DMA-buf heaps allocation. It is a DMA
>> allocation, we just don't know for which device.
> 
> So? How is it any different from the existing alloc pages?

That you need to specify that this is for DMA without encryption.

>> So ideally we should use resources which work for most devices in
>> the system.
> 
> Which this does.
> 
>> If a device has special allocation requirements (CMA,
>> restricted addressing etc...) we need a specialized DMA-buf heaps
>> for it.
> 
> Those things don't really intersect with CC, but if they did their are
> already heap names to request those, someone can add some shared
> restricted CMA option if they need someday ?
> 
>> That userspace provides this cc_shared flag is a NO-GO to begin
>> with.
> 
> What do you mean? We discussed this with the heap maintainers and we
> all agreed this was a kind of heap just like any of the other kinds of
> heaps that userspace can request.
> 
> It is *exactly* the "special allocation requirements" you are talking
> about above.

I only see a fraction of the patch set (because no DMA-buf maintainer was CCed) and to me it looked like the cc_shared flag was added as an additional parameter to the allocation and not a separate heap created.

If that is not the case then it is actually the correct approach.

Christian.

> 
> Jason

