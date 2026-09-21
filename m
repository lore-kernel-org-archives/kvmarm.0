Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9DB496D50;
	Mon, 21 Sep 2026 12:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993475; cv=fail; b=d8AHdGkoNCM1+IBWFK+PSyA8S0Dr5sNuFvoA0V2vNGLD0Ctens9Ish3anEwLOU0TkXN9Uin6GEmC5iK0NBbBNjko+NjZaJWfpdZSjT0zBBkUsKCS1kE+5uNAUKTUk7U2nSlt0wUp1Lomt/ph26HeA1DWSzdnNQGLV/HIXebbcwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993475; c=relaxed/simple;
	bh=W8JvNEkyckKpR+piV7BTydusjcCA4C4lZD0t2TCoBbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=otrI5k6mZYR+ykc6WLzmzIYlmFB4+LVs4sGz99IkvrqP9jm6Y+ERlg5zOJxGWXp5SpZiEarPk3iVYXSZu99l4Fp297S9Tgoz7xN6qZ6y5l52DFHRTIa49npoy7LSTpALCvJjgQzEtodWSPMN08NvAOurwQKAu4SBQgku8e5c++g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oEWcd/q1; arc=fail smtp.client-ip=52.101.193.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oEWcd/q1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZZEHssjfAg9NaIdY09ebtBshwKH0o8YnLiMGc8g0fkqP9LiHiFRlXmj1FDqh29mrUYH2E3m98Pg7FpoP+XsH+W3/wQYuMqFbYt3s0JNQExbb99mblWIg+UFYtmJXMVWzb1bidmlG/dkNOl333GuBzw31L3pmBXn3JG4zNEowZnfdv9eQyz+z9YhB0IOizRlDtoLGXp4S0ByyUMXMQRK3cb1tZjRvw6SlNJNk2iQKVCthylAo4O+5oRJvQTosLLvzeVNqrp0Ae47m1ah4BhGL8ietYksVg6OxFG1uT/+/mcznJ08B3D436/6HYwZTxhsUIR8jnOnG5bF7ydPxEy3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJD27SdHjExqbshGBowv6iX/lgun1FP45WS5Ldmazqs=;
 b=UWgG/82/0/KNiLEAdOeabI0FWEd5D5usDtQ0Rnbl1qDfkBwcY5P1cpdioTExs8b0Rvi4H5397kRaKx+zHpAtL1H2TIIoLZrORUXTlOxdVZFfesrrdVvs2s6/aht5YDpvcBN7eAaUawebMpcDuyyBT3Nx27gaQ0oM8pByOkC84Na6y0IeNUgzTAQWSvVBP4wZ+HUnzEK0H26FL0/nkf7s+NY07BzNzj3QzlMoZkF2MyCcizQ8+jBdX36ObX5fEwWF5tqYv6TJLAA86QZZMMba2F5UdIpYlwy7Ugci44N9IBjeqONmy3UZaj3/3FMDyw+MJdrejyG9AgenoCi30ifNHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJD27SdHjExqbshGBowv6iX/lgun1FP45WS5Ldmazqs=;
 b=oEWcd/q13LEi9GcHjlucRo8V1SaUaRuPGnrZ5QWJF1UfKXtnyMVtKOI5G5ybPF5uFcyKomWK9Oh3JKlPHEQrgAww7G15Ho7d5k9sPFm3bQno3hIn6UK2wjWgkOqcqvVE2j2O5Fv5V0woY2ZsmnyvVywq5AsSwSs/ENeOVjAYq9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by CY8PR12MB7098.namprd12.prod.outlook.com (2603:10b6:930:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:24:28 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:24:27 +0000
Message-ID: <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>
Date: Mon, 21 Sep 2026 14:24:21 +0200
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
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
 <20260921121739.GM11599@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260921121739.GM11599@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:208:234::30) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|CY8PR12MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 1747a5d3-1703-4331-08f2-08df17db476b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wEEfVGGSX0O3g9iZ8gyekY4tnnnJ95Cl3wdt6QrxYcvS4OwxswBEoUxKmz1S1kSKxoYhqSBSvaqbTKIPwgbmYbmfy4wDjdA9GnPo+R6hnUDIKbc+FiX9HQeEKg92qggWFmnbzwq0lv9YGls2VmUbCv2semvKAGErx8Uj4jl+i8iXgTtCFfugMx7OFI8nfLWlgsCKWEVf4WUp0nsTA+3s8xQIvOvPDAwJuGatZGg+AjkSbugCGK68vo9+FUVdTgE0aphXCPJQvNWA0ZwvoVRVyIstwAHxviU+EkXcdXkVJ3evqQiSPp/5tMKXuG6IW+zhTMI2Mk1M3vrf8fWFz6Dp2x0JqefwjzNJD5t7SM/H0t7ppBYyag7MtHRbjNbz1EdyvQCg1ouNiqKQREkZdqbyaxEBpqTevl7UrvJ2nUiXjvk4Sxsa4OJcKFH5sgaa4vAhRVThAGJfz9nL78Uin6tmIqB1aPIOzNJzdPR2ORZes08+Qc4gMcBASUcs8u7R56MgZ5U3sYmqN4RvPlFXsKoghlN4V16C7P83wd9newWxoqTJmmVFiPiBRNYGbPV6nFOodeTHZoTulKUYn5OJzCJ03MMgPrK6dFbuFaU4ZTtEzqeGH2p6e+p5PDUQAbjk9oBG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEZiQk1jWmU0dVBXdXVoSkl1RG1rOWNFdm9kQ1JOVjdtU21lckJWdU9tTEdP?=
 =?utf-8?B?K09qd0tJdHNnN25nU3BBT3pUZjRkU0plZkR0Tno0cFlSK1dwdTBvSVF5QjZ3?=
 =?utf-8?B?RThES0pFZVdNeFVPakt1bU5VaHNPM0FMUzgwSEtuUnRlSXhjVUtGTUpmendV?=
 =?utf-8?B?Mnp1Qkh4ZjJKdnNTR0NIT3BnaU1DUkcxU2M3Um9WM3NRemRlRE5sZm9zM0dY?=
 =?utf-8?B?MXE4TS8wSnFET2cydE9Ecm5JeDNndmQwRE1aSW5IVEJoaFFuMEppa3lJM0Fm?=
 =?utf-8?B?YU5BNG9nenNhZ0htdWRYNlBzamU0SlNORlp6SnRzSjdUeVA2WEpiQWNMWHhw?=
 =?utf-8?B?TGdGbUJ1Q2lXWFhuMEJ4TWRVQ3c2bTRFSlBmMVkxWE9CRDMzRHdyMmpHRnJh?=
 =?utf-8?B?ZFJVZHNOWnFtSitPdTlmODQxcDBETFZBRXFhR3ozQ2pYWnErZU0vb0ZxOWJo?=
 =?utf-8?B?WTUyL1pGcU1FNWNTaGZpc1E0SzlLM2pycUNnTllFaEt6amNMRU8wV013NExk?=
 =?utf-8?B?V0x1TmVZVmR6VHhBQUMxeWgvZ1krakszcUxNVnJxNFFQUE9WdUxaOVlqTXow?=
 =?utf-8?B?UnBNRXQ2VjExWVdUQzBOTjRPeDZHRGxSa203dndQTVg2MDBRZnRpVXNBNmZp?=
 =?utf-8?B?Tlh3MFY3QmxseWd4N3d1WDNnYUhPOThVM0l4cmZuN0RmZXR6S0NZRDhaaTNN?=
 =?utf-8?B?ZlpYcmIzQngycmNaWFJFSlhKWnhQdmtjc3BYS0Z0cmdzd3FwcFlRWjQydStZ?=
 =?utf-8?B?eXJoNTR0bElISkF0L2lneVFYV2dYZnE2QUF4VUYzUjFReUtndDJvYUlhVVYr?=
 =?utf-8?B?aVl1cHlpQTdMbStYT0hRVzRrckc4NGRFV3FaaCtYNGtrZ3VGL2dLTUJnZHdp?=
 =?utf-8?B?YmxTak5SNmVORzF3RzRDZ2Qvam1uVmFrcXRCZEN6Wk9oTkpWaW8ycFRheEJO?=
 =?utf-8?B?Szh4aURLUXI2ZWxxY2toTFcxYm1JMTQvR3B5Z0lvTjVOV0t5UnpXQW5SWWdG?=
 =?utf-8?B?ZXBaOTVyL2NqSURDeEc3RjJvdHo1TEhZUVdVdmRtS1FhZFlXRHVGKzJjdGpR?=
 =?utf-8?B?czFLODlvdHhzaHJUelZhKy94VWN1WFdDMWYwVEEybVljaUhPNGNtVFVycktX?=
 =?utf-8?B?ck9mMk4xMUlDdWV1aUNIZnltUEZCNlp5Ky94ciswcW5hUndyM3h2Q0tUVU9E?=
 =?utf-8?B?VkVlNUU3OVdRdGJ0Y1daeFpRRDhJMUpRQjF4VWZ6eDZLYVhKZmhOZFNBc2Ji?=
 =?utf-8?B?TXlaUXNnb3ZMRzEzZFg1VmlhbWs1bGg1NGdEcHA1aFBVeEYxT3VpYStLaE5Y?=
 =?utf-8?B?UXNpTTZ1WlZkem1XOUUyUkUrQXlIeE04Ymx2dmtOZEpGOEE3c2JPeDcvUlhx?=
 =?utf-8?B?eGFHY2tRemYwSEU4bFJuTlk1UzhyaXJhU29UaEU4QjNjSjhhdk4rd25zVXdY?=
 =?utf-8?B?Z2VHdEZ2djdieHBlaVhMeWZrYmN6MWwvR3NGUDBiSXJZQjVKM1dXSFNvQ3RD?=
 =?utf-8?B?eE9zUkZuV2MwaiszWm1ENGNXTjlDUmkxM085QmRpb1ovMjVuWkVJVGFWSm40?=
 =?utf-8?B?OVlDUFFxa3IrUlJhR0dWcVZkRnkxN1c1R0VVKzhxTmEwZ3hHVFFNeWhtcVZu?=
 =?utf-8?B?KzdLcDc2N0ZUZlpYK0I5bHZaSlcvU1RPMXp4Z0lQeGZ3Rkw1SFEvbUhTTkdx?=
 =?utf-8?B?NXEySXNzS3FpYXM3ZFlvaGdOK3VtcXRJVkxtblQ5NFZFVjgrbTU3VlBqRGpk?=
 =?utf-8?B?S0NTUWNPaTJRclcxSkRjNng0MnNjSnFrV3hDVmNHL0t6N3l3akZtWUtRNEF0?=
 =?utf-8?B?WEZWR002a3ZsSjRpaFIxY1IzOGFaL3E3RjdNNksra2NwMTNqZHV0OVNqU1lM?=
 =?utf-8?B?a1FHRVZIWHBGTTREZE1acTBEZWZCWVRwWjk3ekN3UjZ0YzU1amhNK0FVcFdP?=
 =?utf-8?B?dE1GK0RaSmFUVVF5V1FlSmpxa2NwOUNFajJRejEyRXkveDErakJ2OU1kYmdT?=
 =?utf-8?B?UVBBYW0wV0xPczNBTi9HOWFzTENQUlAzcm5zQ3J0eXhCUWF1QVlWeFZJM203?=
 =?utf-8?B?MG5heGtLZDVvUTV4RUNXVFdHOUZQQ0d4d0VrMzVKZFFPeWRKc0dsdjRBQlJh?=
 =?utf-8?B?UU5kRU1DWjJGRHZzb0d2RHV2bEFickdIZng4aDJRVkd0cUlvWUNmaC9WeGsw?=
 =?utf-8?B?MlNnL3hKdmpmWWtPcmR5MWRMM1ZsdXRnUkZGTk1uS0hZZXgyQzRUYVZuaVgw?=
 =?utf-8?B?eVhITDNPd2hFZzRYMUZhYnJ3RTYvT1JvWnl4d0kvZ1lrSSt0a1plaVBPTWUy?=
 =?utf-8?Q?gKCmaPjyLeFcYtu1dO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1747a5d3-1703-4331-08f2-08df17db476b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:24:27.5159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYcgW0Aw4GEuO3a3v2G9z4I5Vf4efVmWfST/wB53rq2Vb9l0Is6l3kuIKbNQw22Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7098

On 9/21/26 14:17, Jason Gunthorpe wrote:
...
>>>> That userspace provides this cc_shared flag is a NO-GO to begin
>>>> with.
>>>
>>> What do you mean? We discussed this with the heap maintainers and we
>>> all agreed this was a kind of heap just like any of the other kinds of
>>> heaps that userspace can request.
>>>
>>> It is *exactly* the "special allocation requirements" you are talking
>>> about above.
>>
>> I only see a fraction of the patch set (because no DMA-buf
>> maintainer was CCed) and to me it looked like the cc_shared flag was
>> added as an additional parameter to the allocation and not a
>> separate heap created.
> 
> ?
> 
> It was merged months ago, and you were CC'd:
> 
> https://lore.kernel.org/all/20260325192352.437608-1-jiri@resnulli.us/

Ah! I though the flag was added in this patch set.

> 
> It follows the design the dma heaps maintiners guided to create a new
> named heap:
> 
> +	exp_info.name = "system_cc_shared";
> +	exp_info.priv = &system_heap_cc_shared_priv;
> 
> Along side the normal heap:
> 
>  	exp_info.name = "system";
> 
> It is identical to "system" except the pages are "CC shared" meaning
> the hypervisor and every DMA device can access them.
> 
> This series is just adjusting the rules around how
> set_memory_decrypted() works. It isn't changing any uAPI or adding
> anything new to dmabuf heaps.

Yeah that was absolutely not clear to me since I only got added to this single patch.

I also don't see where mem_cc_shared_granule_size is added?

> Yes, it ends up as a flag in the internal code flow, that is just how
> it got coded..

In that case this is probably ok as it is.

Christian.

> 
> Jason

