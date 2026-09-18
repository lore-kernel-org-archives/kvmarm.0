Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA2E50277C;
	Fri, 18 Sep 2026 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745026; cv=fail; b=VfFrptllxa+tIQ3zw3owuSyDaH5w6YJEFESS5FdSVnMvpPvTQCfH07MRHQgrnDEYuWxBouoDcOOEpUx9MQVGhh4o7WclHWKMjPB7ILeMIL7VOQYj2aoejHhO4RTENX4JHrApDAnNDRr4SSEYHV6B6Sfw8RCkQgpIU9z7RO9fJfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745026; c=relaxed/simple;
	bh=xViq7zdASak9kWDNmx+3gPCMi05Bw761UdRIEilmVKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DObLSQCrhf2rwQ01C2j1Zpw1ZK8G1+H1ynn4Cplqdei4McWwmlpHJkQA+JVFcbMXTRdQ+tTOeVJ/RLPSm+nHCECvoIhveBpPmCEp9xoFsk3SavmyMz8Xkxoz4TOjZSghKJygZHTsVsM7D8Y0byqbXWM9N3Cd8XqYoQIPvduns14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e7+nWHkF; arc=fail smtp.client-ip=40.93.195.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e7+nWHkF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s7ZfUdd5HHiW6pUjUNNmy7DvqJZM4RYntHvWvvt5vpTZWWcob0AXtegwj6hMZM3EGxMNoZ7yVLNFnsnPJXl3PUD9LL885VQJGnY8ogcNrStvL08Qi2MDl4ZmZkvC75HbB8qOMaYuzimjyu9LQF1ncqBuK/yfU644cNOXmIK1N8T6PAN9FfKSF7SOyqP6ogxHcrCyKlbb5hLlzYw4W1AjTOfzm4cTD0rXlY0rloQgvD40BoXDawtyII5nz8EmX3wGU0jbRf5XcMFCOUJk6fVgicP8g/pzu2qcstDeWlYomF7N9gFHE39vxT3rcGcE2/3sVKNkWaOIP5IYYEA1Sbj4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8Zv5TBPNyEFHc5wUzOU6C5JU8jClmUyr8X0Da0LvnM=;
 b=TG2H5GdTZBaHE4Rn20CP8zIXNy9U5+c5hWeKZf5ia+kkQx0KQ1c4kZzsNWENMLIUynEjXmbUszdkTqrg0bDgwGKsvjK4QVe9g59/6ELSdcot921TK/VpStFUHwzpSZTxvd8ychuvDDTa1CVo2GuKYqUe4WMTKuh0ZnEY1twY8QaFNbyLYgD/oIiD82i++E0P8ZOJSNGfUfh5fTHdWNftcM9FUGxD5uvVcyPo1yjtI2kGUr+myVAmAZJx9VV1fuUdVV0PcE7cKYMk5WzGVwy6gHlR35PUKE9SwJhwpLhSrOIViPE83xYxjlwy58MO5zpxMRRzAXW4BJB3/wbCAL/fEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8Zv5TBPNyEFHc5wUzOU6C5JU8jClmUyr8X0Da0LvnM=;
 b=e7+nWHkFKxEs4xjclsVDiyYvOw/7y7ZG2JOMhNxYcVAZDVdDLhj2uJTT0sp+TEBhiHFqUlwFDq5hsKkH56sFsfqL2uxkNYWK12afL1B+1yoylIDbW/FCOpA7cuWN0ULJwyb92/UnSo5m9FYFzFo5r++J7IaByPwx+ngyjPFbHPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW3PR12MB4442.namprd12.prod.outlook.com (2603:10b6:303:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 15:23:37 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 15:23:37 +0000
Message-ID: <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
Date: Fri, 18 Sep 2026 17:23:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
To: Catalin Marinas <catalin.marinas@arm.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, "T.J. Mercier" <tjmercier@google.com>
References: <aq1V3oeDdvXobt8J@arm.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <aq1V3oeDdvXobt8J@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW3PR12MB4442:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c21178-2935-4c17-2af9-08df1598cfd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9QRZpg1ESsyFKWkH+5GD5lwJXKhfvKSo18efzukus27ugsy2Xs/Fu/7r23KR8PuVykP2FKvSB8/8nxtn26PdOgANFMBMM8xwPyGnunL7X7aH2ZBOpjrzXrjLC8BzG6e+82BfDbyiEDO7Z3IC2QQyqgGNPqjVquEXyaGg2C0zWEk3yFU4NGHI5uMUyp6WtoisJHmFA/FGitcG08181Bhko4aT6AMmMhcd4RxuvI2UeZtn5ibMB15WrOk05jPjF7IriWaP/Mf3VzZgPpe/nd+oRjOf9q0yrnGp1urRxnxMp59vONzRdLa8r+Jos3odOX8myMhLMfodN+Aj+ZZlbl8AQduc/XtLjen6dBfrdothIthpHB2vm8khHzwUYe5GalCaQw9Dg06J3zMtblGzLnAJ1BPfKafIhcXp9HsJxqjEHju7L9QcNbm6DMhCBGxkHdgne+4n8AC6vsaACsRegcLpH/1yeKfVuE9l+J1A44tagv3PAdDrNtVXe+s5fSabEFLSSQYYn26LhBp8JB3VmzaYuMFUvwQN2ClUk9TRn/pibsZdhZNX0mgHYDrrfAWjLrLwsU7s+aJVCbOyeMQo0g6/4gL2lp9ivhHyP9dmAmGwJVJVBnw7KSw0w2FCkz1j561yTs6R/s+zto/IX5mtpZaZV/H2eTPJMu6oIA4nk0f3r7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUJDVFNUeTNFZHRyZFJPS01VdUx6RzErSDVIWW5Qak93anZLZHpoVW1ZYUpj?=
 =?utf-8?B?QXZ5T1lTa25rRlBPTHZsVGJQZGZQQjc2U1hUYU5jSnhpSytwaVJpMmpzdW9r?=
 =?utf-8?B?K0l0SmJ2aHZBTnZjaWRiNktrWjRRT0FISjJZSGJOSEZJNi9nYjQzcEJiL010?=
 =?utf-8?B?WFNreU51L3JLYjg3eGNJMWFZZnVYRVpTeWNtb2JHc0FiWU9hZnZVSXJHY21D?=
 =?utf-8?B?V0RBcDI5ZDFmdjNuSjI1YWxVNEhvZjNkZ3BHVGhrNjNQNmNMeGlkSldLa2o4?=
 =?utf-8?B?emU4YUJ4TEZXS0t0Njd4dCtmcGFKY1c0amtZak82ZWlaT29ZZ0taN29WMGRC?=
 =?utf-8?B?dmUreDNZY21LSnVVelc4QkFGNlZPNUl3clZvdnR6cU1yYi9WWVlzTVRSUlZL?=
 =?utf-8?B?dXErR1BkWk5kZExPSEM5U1VZblhDSlJ4b0pTa2pIMnJ5akp5MHlNV1BmSHFN?=
 =?utf-8?B?c1VIRFNRTFRFQTJZekg5WncvVW5MWGdwZzdDQVRpVGpNUGV1MXE0RGRlYWVw?=
 =?utf-8?B?Qjh1aHhmaHRmdUcvQk1vaWoxU1dIYmdFa2J6MzQ5ZFdlZWQ4ZXRmVTNiOXA3?=
 =?utf-8?B?SWo5NGU4YTJpSEY1QVBwYkl5Rnl4WldqODJVaWpNbTNQVkkzd2pJN08wOU8v?=
 =?utf-8?B?NkUvMWVZM05rYjhMc0NyT2c5eER5SDE3TzdrcnBpVzV3MnhaNERvc0VDUHNQ?=
 =?utf-8?B?Z1dKVTV5dFdNR1V4S2grQVIxcm1KVWQzWFB1YXdLR1BEUE5Wd1dSUklzOUp3?=
 =?utf-8?B?RWJFaStnMUJzWU5iZjhLTVJFNzA4bkV2aFhLVGhyQncwVTBkNi9xSkgxanUw?=
 =?utf-8?B?QmpmRXhnekV3L0JDWmNXYTExeU9GZ3Z6T2V3OFhHOHdWbklWUVV1MXV4alpn?=
 =?utf-8?B?Nlh6UjA5MUkrMmpIazNyOWY3Q1B0L3BXYUQ3Nmh5RFM4bGl5MVYvNzJXSXo4?=
 =?utf-8?B?TURTRjFqeWpJSlBQcGN2RXJHMGZEWmlGMGw5RnBsaXZ3alhidFU5ZndtRWpk?=
 =?utf-8?B?MjFEYVg2TDlObS85UHJ5RjREd0ZTUDZCRFdGZldBNjg1QnpvaVJXSldDajJI?=
 =?utf-8?B?S3ZrVit5eHV6dW5GT0UrNTRXL1B1dEtueVNYSHRTL0h2b3RkbW1tMXpKcUZy?=
 =?utf-8?B?Y1RYcDdQeWhmakhVSFJmdUk2UHhMbGJxMlgxeDQ3b2hJcG5GK3dobjF1VUly?=
 =?utf-8?B?d1VKalBMeXAvdFpiOVd4dEE3Umh1T2FHeDE0amZ4QVFJTmZUNXBMOXowTXcx?=
 =?utf-8?B?bTJuNExWVHhMYm5QODVIVnJUTnUzR2ZnWGpocWJnNFFWZ2U0bFBxRjI3UUhm?=
 =?utf-8?B?cHcxVEpRTW9qZm9FdXV2a1FGRmQ1V1dwUDZrazUzZHlCclorUmhraHRLeVQx?=
 =?utf-8?B?a0wxTWFsVjY0cGFQRXlPUjdyOTJoWHYzaFVXSlNCM25UMW5wNFloaDJpVlBF?=
 =?utf-8?B?Y090VnBybnJ6ZkptN0FmNjRTUU9ucm5lTzgrY1l1OU9tUUZVaWpLbFhQbGpW?=
 =?utf-8?B?ZytUMnhuakZyZkYwcEhkYVc3TzIvcGZmYnVLa0lWMC9hREluMGFlaXNDQUpT?=
 =?utf-8?B?blR0OSs3aTh6UTJUdmRsSVNlWnZwdWErSzdaK2lPQm94MEZsbWo0VFVFVS82?=
 =?utf-8?B?ZUlXQk9XQ2cydGMrdWtlRko4eEJHUnhtRXU4SXVBQk9CeHNnbTBzVU9tY1g1?=
 =?utf-8?B?eWhIclV5L2xSL0VtTzBWSHJYS1dHNDR6UVNMak9wMWxhVVdWZWdpTXhYajgz?=
 =?utf-8?B?c05YN2JsaXEyRTl3QWd6elpRYXhFdjNVTlFJanBuZElpZWd4NDhmU2xweE12?=
 =?utf-8?B?TFByWE96bDlMODRvbDZFcnhZK2t3VEw0OTNRR3YxZzQvMG5uRHZlT25MNDRj?=
 =?utf-8?B?OUFEQ09sdjdKNGl4UVRMeUltMElGYkY4Z05ZeFVOUjcySE05U0swM1FXT3U1?=
 =?utf-8?B?S1ZmcS9oWWpqSVF5bFVTRGtZeVVsTG1vV3hsa043bGMzUU5jampLVStJWE9l?=
 =?utf-8?B?ZmJPWDV2ZEtkYVo1cHlnWVhRODJ2ZmNiTnRaN2EzcVFuSGoxNTJpVFdnbVUy?=
 =?utf-8?B?VmdyUnlnMTJ5UnVTUkxnUXlZaUY5RGdESUpYZS9YbXNyTlpjZU5VWWtxUXZm?=
 =?utf-8?B?cXFBMVlUUXBUTkNjOUJMcC94SUNBaFJ6c2xmYXFLN2ZmY1pld0xrSWR3ZUFh?=
 =?utf-8?B?Vk9tbUtPcnRMVU1YdE9WNUg3dkpqTVdXNk1VV204blQ1aG0yTVNwSXovV3Y4?=
 =?utf-8?B?c3l1dTVzN3YwVE5RcWlkalB2Yy9kNXlmMU1ocTJ4QzRzbFAyWmhyR1doV1F1?=
 =?utf-8?Q?r15hC43LoXYMYoD+bD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c21178-2935-4c17-2af9-08df1598cfd8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 15:23:37.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3Q4zDZETqKadT+q0wgEDbDaPceJt4fXR/MgVrG/jUWz3d6DE++cQMFY56KeXTDA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4442

On 9/18/26 17:16, Catalin Marinas wrote:
> First, none of the DMA-BUF maintainers have been cc'ed. It might be fine
> for an RFC but this series got to version 6. We need their feedback.

Yeah, thanks for doing this.
> On Fri, Sep 04, 2026 at 04:04:50PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> The system heap can allocate buffers that are decrypted and shared with the
>> host. For confidential-computing guests, those shared buffers must cover
>> whole shared-buffer granule; otherwise a userspace mmap of the dma-buf may
>> expose only part of a host-managed granule and allow unintended access to
>> adjacent private memory.
>>
>> Require cc-shared system-heap allocations to have a size aligned to
>> mem_cc_shared_granule_size(), and allocate pages at least as large as the
>> required granule. Keep the allocation bounded by the existing heap orders,
>> but fall back to an exact minimum-order allocation when the required
>> granule is not one of the preferred heap orders.

Uff, I don't think we can do that.

That is massively platform specific behavior in a non platform specific code.

When the architecture can only expose unencrypted memory in larger chunks than the only real alternative is to use bounce buffers and those are incompatible with DMA-buf.

Additional to that you can trivially circumvent this with a memfd and udmabuf, so you most likely don't win anything with that.

Regards,
Christian.

>>
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  drivers/dma-buf/heaps/system_heap.c | 50 +++++++++++++++++++++++------
>>  1 file changed, 41 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
>> index c8959eadc71d..9cbfcebe2088 100644
>> --- a/drivers/dma-buf/heaps/system_heap.c
>> +++ b/drivers/dma-buf/heaps/system_heap.c
>> @@ -55,7 +55,6 @@ struct dma_heap_attachment {
>>  #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
>>  				| __GFP_NORETRY) & ~__GFP_RECLAIM) \
>>  				| __GFP_COMP)
>> -static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
>>  /*
>>   * The selection of the orders used for allocation (1MB, 64K, 4K) is designed
>>   * to match with the sizes often found in IOMMUs. Using order 4 pages instead
>> @@ -375,26 +374,44 @@ static const struct dma_buf_ops system_heap_buf_ops = {
>>  	.release = system_heap_dma_buf_release,
>>  };
>>  
>> +static struct page *system_heap_alloc_order(unsigned int order)
>> +{
>> +	gfp_t flags = order ? HIGH_ORDER_GFP : LOW_ORDER_GFP;
>> +
>> +	if (mem_accounting)
>> +		flags |= __GFP_ACCOUNT;
>> +
>> +	return alloc_pages(flags, order);
>> +}
>> +
>>  static struct page *alloc_largest_available(unsigned long size,
>> -					    unsigned int max_order)
>> +					    unsigned int max_order,
>> +					    unsigned int min_order)
>>  {
>>  	struct page *page;
>>  	int i;
>> -	gfp_t flags;
>>  
>>  	for (i = 0; i < NUM_ORDERS; i++) {
>>  		if (size <  (PAGE_SIZE << orders[i]))
>>  			continue;
>> -		if (max_order < orders[i])
>> +
>> +		if (max_order < orders[i] || orders[i] < min_order)
>>  			continue;
>> -		flags = order_flags[i];
>> -		if (mem_accounting)
>> -			flags |= __GFP_ACCOUNT;
>> -		page = alloc_pages(flags, orders[i]);
>> +
>> +		page = system_heap_alloc_order(orders[i]);
>>  		if (!page)
>>  			continue;
>>  		return page;
>>  	}
>> +	/*
>> +	 * The required minimum order might not be one of the preferred heap
>> +	 * orders. Allocate exactly min_order when it does not exceed the
>> +	 * remaining size.
>> +	 */
>> +	if (min_order && min_order <= max_order &&
>> +	    size >= (PAGE_SIZE << min_order))
>> +		return system_heap_alloc_order(min_order);
>> +
>>  	return NULL;
>>  }
>>  
>> @@ -409,6 +426,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>  	unsigned int max_order = orders[0];
>>  	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
>>  	bool cc_shared = priv->cc_shared;
>> +	unsigned int min_order = 0;
>> +	size_t cc_granule_size;
>>  	struct dma_buf *dmabuf;
>>  	struct sg_table *table;
>>  	struct scatterlist *sg;
>> @@ -425,6 +444,18 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>  	buffer->heap = heap;
>>  	buffer->len = len;
>>  	buffer->cc_shared = cc_shared;
>> +	if (cc_shared_buffer(buffer)) {
>> +		cc_granule_size = mem_cc_shared_granule_size();
>> +		if (!IS_ALIGNED(len, cc_granule_size)) {
>> +			ret = -EINVAL;
>> +			goto free_buffer;
>> +		}
>> +		min_order = get_order(cc_granule_size);
>> +		if (min_order > max_order) {
>> +			ret = -EINVAL;
>> +			goto free_buffer;
>> +		}
>> +	}
>>  
>>  	INIT_LIST_HEAD(&pages);
> 
> You need to get a proper base so that Sashiko can review this series. I
> ran it through Claude and the above is wrong to go to free_buffer which
> walks over the pages list that has not been initialised yet.
> 
> Another issue, I'm just copying it verbatim:
> 
> drivers/dma-buf/heaps/system_heap.c:379 (patch 7/9)
> system_heap_alloc_order() picks "order ? HIGH_ORDER_GFP :
> LOW_ORDER_GFP".  HIGH_ORDER_GFP clears __GFP_RECLAIM and sets
> __GFP_NORETRY, which was fine while orders 8/4 always had order 0 as a
> fallback.  The new min_order fallback at line 411 has no smaller order
> to fall back to - it is the mandatory minimum.  On a 16K-page host with
> a 4K-page guest, min_order = get_order(SZ_16K) = 2, which is not in
> orders[] = {8, 4, 0}, and order 0 is filtered out by "orders[i] <
> min_order".  Every tail allocation below 64K therefore goes through the
> non-reclaiming fallback and returns -ENOMEM under pressure that ordinary
> reclaim would have cleared.  Note any fix must keep __GFP_COMP:
> compound_order()/page_size() are used on the result
> (system_heap_set_page_decrypted(), the free paths and sg_set_page()).
> 

