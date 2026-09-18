Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D917502D7D;
	Fri, 18 Sep 2026 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746013; cv=fail; b=oQa5AzFao+89MIIdcjg81BY0XfbCQU1OxsHJEnDtqa/cExmHpuQc0VNlT0BHhmxhpJng8ULmOzOtBjgArEclEzKCjumv+PQ04fzRRpl0v256wG3OZGL4qbJa11MZGNPI3FLY3tJdsxHetF0OSRBI1s8K/C8QW324P/Ti70XZXhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746013; c=relaxed/simple;
	bh=4ydLx4xsBr5j0lmpJR5zCZVkiSjiB1fshoN7wZTladc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rAtD/u3FKn0+lcNOJRiV+BdiFSohoxwOPlMBNSxS81eWzE2sGXdahbUb2Uqhf72Z8F+kp+lP13RfhhCEVbgyR/FqnGw3W9HykPBNin6qHK7Qev8NSh2OxHKlOp1rfQ+kzDCyb4e0PDwve7WZtW8T6+YH4KiFDwN8AxysBCn8/1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PxVg7uY7; arc=fail smtp.client-ip=40.93.196.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PxVg7uY7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgnyZWzxVCagYI0Whl+pgi66n4GHhRJhBbMqJ5Dz6xM/o1xneS+T+u46RVwLkDL+ryZhs0Os6JzhqakOF9ssZ4afa2DMnIJ3Y25A4e7SesqHjXT05ahyCX9g5lhFkbJFaeObZWAobxDE9FRBNM/C3JJODs8WSXmsShSckk/PFoAtNHlcRq7/lq/YeDaefVcL23y2TiyzTBpvu40KvJVcKDzVSa0aelD3DaQoNpAIUbu2+wh1wca1NjokpBh6+1vAW/o5AqxJAz9fdHCmJr/nrdvyrsu5fUglYkEt1Yh4RibeOHx/dcOi4vhEoCqCigYntsEX9vLyCzau4b4041maSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFbBxOaScdg6xEZQzkaCwNVv4e/dbfNEJxqr2f2h0kE=;
 b=c/9K2k7LV1YsVkefWFUVPrDQXWEMfO7SiDKf6AC0IbmFejlld9t73sDZeH/OxumGjGlfCQq56+Ll4fCalCWamTXMTOuihXwfrkJ5YAQkopI9xcI8oromSju2sBvaOdtRdgO5AtsmzQKyXEd9h34Jfd0kJdnhzq+X6nNnAZI2+nH1zPJWlsuAWfzTbIreQSBp2dcpK7v1FCrB+AM1rdGm/2B2mB1GFDnniI7aJNLH7rMy4Tr/hNLfh4RknOJyKGpG6tEC9QQ1JGUaV8Qc28+WWXsRZogV9Xb98PJ4Li3wJU5f0u2z/DW+GmvxlDt9RWwzkZ8WzPO0f5d4VySiqyBXfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFbBxOaScdg6xEZQzkaCwNVv4e/dbfNEJxqr2f2h0kE=;
 b=PxVg7uY7SHh9yWNo49lrjDllvG5uiaJTylEagW8xkdmSWDYJeh82bHuyrBXNq9356whlLrYaSWt3XbWdiuVnz+5cqAY+alkjuIJvu+rVf653DfgdPwG89k5XnKHxRo2tcYI1Ad5sTALvRaOaFKqBRLr6lQU/8N92+xRVI0Fczoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB6954.namprd12.prod.outlook.com (2603:10b6:510:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 15:40:01 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 15:40:01 +0000
Message-ID: <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
Date: Fri, 18 Sep 2026 17:39:55 +0200
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260918153642.GD11599@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0198.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e5f8145-6547-4ea3-13e7-08df159b19f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	PrB+xNUTQGRU4uLJug36sX53OJM1AMgcO7g96fYn4i8RevpaiZvv3l3JpfwApQlgujV2hGGWpNBiBboc+qKzIZ+MfCNvv4c32O4LTQ4QcIYHUcBmQUMOZ00KAlIkgY9FMixKqGMjWWJEzWkUCKg6+vvRmYBjVH7LjPHywThTj00+I4wt+NfJuTnnl+ifrgOkL1AwMEqgXxl5L62B7gVLSQI+kzZ7Hl99IvZsxiF63JMu0EjB2oOLDqdGKAMyC8weE2aZewHr2TBGsU/8LfWWgLM7pwE1dPUrVsb8x0Ug/HVLnPPGZLVh2U2VpWUMxFR9XXGjyG/VDwajxbE8VLyK8M7ZIurIWNFpNZahBgaphQ1alMpXzOzfchdEZm1kOQLiCirNo5m6s0FaUEHCiWyCVzSAqAZ1CTo4i6uOK/d9XzVRcy+QAtDXvs1Qy1za+hnaCNh/qjdCZzDdD6eunBU5kWHJ5YZ2ekJH8Ud7NOl+xGSplQYKYM2hobEh7Zyuh9ccQ9YrotQJv89MNzideoQ+8K5zGntvT6cOwYjNufu1DAdlag2NEhpqrEznjtBmOj4HPlTplacesyffGp70NQxQPM1DOXHOk7iX/zKSw6IcsbnoYvMAiuvYP7NeJ8KANNei6Pk8qBmGny2apvHhSTy8HcFTme/wQgwdQScy3rQji7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFkwOVlEaUErUjJKTjVHT1diWm5zNkF3TUU1a1NaWEJrRzVmSUZGZWZHbXBF?=
 =?utf-8?B?Qnd1b1orRUxYYUhET0lUcC91cFRRcnBUZ1pzR1FTSkJHL0pWb2p2b1NBc01n?=
 =?utf-8?B?c3gxSFJiNmNDblBKZ3ViNkdGc0R5NXNFb0NSRTJjd1AzWnRQL2s5VEhUL0lh?=
 =?utf-8?B?anQrT0QyVVdPWlF3bStnb0lrOEZ3VUJidXh5ZTZFMy9PeTdtRHhIWUlhTlh6?=
 =?utf-8?B?Q3ZmS2RJSkdDSVJraXpPU2JzcmV6QThHdzM0NkxJM251QjNROWxLelZRSUVt?=
 =?utf-8?B?ZjZWelA1SEE0eENqVEZva0NUdUhMSEc3R1hiWG5wUUFrb0NTdjRRRjYweDE5?=
 =?utf-8?B?dTFENU9TOFg5djE3THVZZ1FlV29DcUhOaGdvRnFmcUlMR1RGS003aHM0TGxN?=
 =?utf-8?B?eXV6cjFINnJFK1hOMzhOOUtuT0xrT3FtRUZJeGhvbjFqUm1HQ0RxcnM1TXBp?=
 =?utf-8?B?Rm9IOHo1MDI3b09DRytOT3NIZ29scTBuVzhMQVUyS1JkL3NzL2VBMzQ4bzZt?=
 =?utf-8?B?ZEN1N3RxNVM1eDBDQnQxenYxbDVhenEwREx0WmNnUlpjTGthbDVYQVMyZUc3?=
 =?utf-8?B?cE96WDlLYXJ2SkVwWnlSWld2ZEYvd1I5YVpLNnBxeUpmTjlkZGZuV3dEWng3?=
 =?utf-8?B?YTR2ckNXbUF2VjdpNXhHRTI3VG91SnhXYXRqcnAvT0dvQlBZQ0FZdzl4Zmd5?=
 =?utf-8?B?VkNYZXEwbFpqVkdOMEtYWHl0SEhHQUZMbWpicWZRVHk4UGR6SVJCcUpsc2RP?=
 =?utf-8?B?REhCSHhHb3lWL2ZXVEVlSGhvaHZoVVc2WDBoQ2R4NVZKL3p6bUJ4V1EybnhV?=
 =?utf-8?B?L0NVL09tcTk4YVk0c2lYaGJESnFqQUZqbUk1TDBCcS9RTjBUdisrcTRyK2dP?=
 =?utf-8?B?Y3EwTEZ2eTNkSmZQQUQzSUJUbmxMQU91N2dpSUNkdDBQd2JRUGJRV2xySThu?=
 =?utf-8?B?M1dNUWt5NmpxS3JwU252UnBRencvTkxORmNpdUNLQ2o2Z2N4SExCUkhwamov?=
 =?utf-8?B?MVhjUjBpTW5XU0tTOGdsMUFzN044a2RjUk9OZmFSQlluVGdFaGx4aXcyQkw5?=
 =?utf-8?B?cG11L056VVN2aUljK0FDWEREVUUwRjhNenZWUmFrTklqeStLSEdtTDJqb3dE?=
 =?utf-8?B?ZVhveUZTQUNENUlwKzN1d0IzZ2V0enpOL3cxVi81N0JPYmpwZXlON2pTV3Yv?=
 =?utf-8?B?U1JOS3ZyTE5VT1BqZVk1MEtJYWpaTWRUWEZUYnYzaVlCWGdLM3NaTTB5MnZz?=
 =?utf-8?B?eFRDYU43eTBnTXBxajU5SHFmTzIrdCtjL0ZCNlNWVEU4SWorYmU3ZjloUkxr?=
 =?utf-8?B?d2tpblV6MmsrVmJnT0xOamd2dmhBYTFEZEtQeE80SWR4U2QyMkp0dVcrUk41?=
 =?utf-8?B?SEZwSUVxbVZQSjhvdVQxM1pjL1BNZC9JRDRMNXozSVdsVFMwQUprejgwckxn?=
 =?utf-8?B?SEZtUFZXdVg3bi8zREFuMW5pV2xvZmlYbUFNbHBGaFEvVFZlTXhwQjV0Z0Z4?=
 =?utf-8?B?aytDZ2hqRjVaL2xoc0hoTGxzNGZ1bWJPUUFzT2NJRkVZUi9ZWkpJUHVlZjZN?=
 =?utf-8?B?dDJianJ1dUthUkU1aHNFU2lndERvcEt5eUUrVGdTZUViYnZpam91bXZ5eUJE?=
 =?utf-8?B?UUJvSHlrNVdNNUFQempjQ3pETGQ0WnVJQ2lJeVZ0ckFlRnRrOTJPbFVIalEz?=
 =?utf-8?B?M0llNzZWUHNoS00xeC9XM21TYkNJVzNxUEpYNDhNSkM4UkJ4TEZwSXNWdzRB?=
 =?utf-8?B?Y2QrMWErU0lkRHZjVTh0YlVqRkVwd3VVeW5BcExMY2xReTRTVTBTRkdnTkxC?=
 =?utf-8?B?a0NXbjlIQnY1YzNDTFBzTEJzSXJWaEl0R1VBQmR2YmpaTVZFSWVxYnNxWUJ0?=
 =?utf-8?B?U09UT2pENGdJV0dHZU9QbHpFOHRPZ0RCN2dVdlo2bTlla1RKMElCQnhscUYx?=
 =?utf-8?B?VzM0VThBV1dtM1dZUFhEcjBtcHk2bFpzNUFmU3dFY0pWdm9ra0F1SFI3ak9w?=
 =?utf-8?B?TFhYWGZqSXFBQnBkenNiQTRPR3RuOWc5Mmk0OUJxTC8zYXdmTmlRMWV3cDB5?=
 =?utf-8?B?R2NzMUQyTXR2cHNhcDVwOC9DcVY5YjFaYmxQUHkvc2V0MURiRnFvWDRKYjZt?=
 =?utf-8?B?WHFoTTRGYUdlMTVRempyNHRWOFMxNFJuNDRFc21sUjQ5OVBWVVdjQTNQS2xP?=
 =?utf-8?B?V1lIdXVYaXNTSWdxQ3FFYkdqcnlGWTZRZjdSSDcwNUl5cUN1VFJ2UFE5cCt5?=
 =?utf-8?B?ckltM1BIL1FUVW9Wcm1ITjZleCtjd1lKeGxGSTRnYkllOFJtQTJmN2lIVVA0?=
 =?utf-8?Q?bjwNx0n6gInVqG3K4Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5f8145-6547-4ea3-13e7-08df159b19f1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 15:40:01.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUwnyzJHxu5QKshFRMuQ90q34KRYn7MvnIAUVq7wBS3D3IvS6fhtfWGkdQdtqhJD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6954

On 9/18/26 17:36, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 05:23:32PM +0200, Christian König wrote:
>> On 9/18/26 17:16, Catalin Marinas wrote:
>>> First, none of the DMA-BUF maintainers have been cc'ed. It might be fine
>>> for an RFC but this series got to version 6. We need their feedback.
>>
>> Yeah, thanks for doing this.
>>> On Fri, Sep 04, 2026 at 04:04:50PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>>> The system heap can allocate buffers that are decrypted and shared with the
>>>> host. For confidential-computing guests, those shared buffers must cover
>>>> whole shared-buffer granule; otherwise a userspace mmap of the dma-buf may
>>>> expose only part of a host-managed granule and allow unintended access to
>>>> adjacent private memory.
>>>>
>>>> Require cc-shared system-heap allocations to have a size aligned to
>>>> mem_cc_shared_granule_size(), and allocate pages at least as large as the
>>>> required granule. Keep the allocation bounded by the existing heap orders,
>>>> but fall back to an exact minimum-order allocation when the required
>>>> granule is not one of the preferred heap orders.
>>
>> Uff, I don't think we can do that.
>>
>> That is massively platform specific behavior in a non platform
>> specific code.
> 
> What we really need is an allocator API that does all this for the caller.
> 
> It has been pointed out a few times, Aneesh maybe you need to try to
> tackle that?
> 
> dmabuf heap just wants
> 
> 'allocate me an array of shared folios totaling XX bytes'

Yeah, I know at least two other use cases for that as well.

> Arch code can figure out how to do it. If some ARM configs only give
> order 4 folios or whatever then dmabuf heap doesn't care.

The fundamental problem is that DMA allocations are highly architecture and device specific while Linux memory allocation APIs are generic.

Christian.

> 
> And solve the double/triple zeroing problem.
> 
> Jason

