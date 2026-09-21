Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6980C45D911;
	Mon, 21 Sep 2026 09:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981708; cv=fail; b=Nn8pKgqD8LOK1AiYtZ1D7YvDAKLgPKi4eYsDgCljANJDOoE4zM93ohBcKrphogpzrnDgmBJPqlPwHMxXbkaGbzCLH6zqHJqhOilSZgAbNdo2/Xo1o9QR5Fy+CH9Qe+bPkx1aFZiBwNucVrZuXp8DdWbJAp6e/aYKHC5EP49wRsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981708; c=relaxed/simple;
	bh=v0c0RYGPQrimU/LmXUpnH8j9BUzkuYgDc0C6G4/aFtU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UkYTYUgRnEj8EHXrDjoz3u7QoPsL7e9b6VBIkS2q24KlzYUrXYLiX3Q1nSTD2VMh+ghje7ABrMlmUtaBAV8e9i4upqm4l+ibIAdHZdXSbSuZMMSrqPhOpquc1vJCtlV0K6fE4dWs4MU/iZGXGBs02J4VRdmX8hglqEIWEDbS8oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PYlmBdYr; arc=fail smtp.client-ip=52.101.62.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PYlmBdYr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/WOUZej68ld/Yhu0Rs5KR5kvvtPeobr6H69fGhCUlLDSitRX3W0d6fbxvmTDVS41DfyVtNFP1rXV+GE6XRaaM12RgjU9Ugaot54VR/zkjt5495dPiemm60E0O3d/6sZkkxUSaYOPGsoctZWTcJFDKgfClhQeT+fra/r5BsOnxpFDHmWqXDZAPM4qTh1YbN37+iitpVTrN+OvND9FzHv3RF8evBV+TNLYtwoK+BRzQPeAZvg6LBYWQnToLvHArfjq0E6j2PQbqp6+p4y6VbuGWifznuOMvG0tX4vtKcfRlcVT6yHZDPt1ihS4VNBpRhp79KNVERBY8oJteZ8sJteVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHkRUTj1UyJT1ixpSUP7kpMipqYLHtWnC9xoGbPOX0M=;
 b=FfBJTDFIa1tm3V35qAUueIveezTQwGShYnY2dCtM4kJbpTm8Utg5eXCxC8FWo5no0SfqCrT5TofYIFMIGlWmSj5VqrGAYhjprRJslV+60rl7JjDidnq0vUhk1gpF5hAAtBjLGaYyy9dwl+89amulOkgvySTjOCq4W96TsNOZO2BPq6BsSM5BpB9uLy8aI1Hgulm0UpeYZi/2UVz5V+s864DgUUDqHZ2L0Hz3Lrlz22Pujw374zSGFkrGbGvSCSmbh0MKiveAlghpdNfmcdkqcgFrAOO1rzxV3c5dP0ekgW1VXbYS1CiphGikkgYQkv3/TKeIK2bfr13E3AWZZaAuPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHkRUTj1UyJT1ixpSUP7kpMipqYLHtWnC9xoGbPOX0M=;
 b=PYlmBdYroZjMQQIJUHh6j8Fc4EdJrlhFdjt3Xa5/R9W/FH3ItC163Ut0F/NebI8NmQNqmkrJa7x+G9euy41A0+JOyaMtWuTnyTLq5rRveEy7Fkdxlm66lLwy3pz4qe02Ska9stcdSZVDvo/qcvKN0EPZznDGPdYPpGJGm8FBs+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LV8PR12MB9617.namprd12.prod.outlook.com (2603:10b6:408:2a0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 09:07:24 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.011; Mon, 21 Sep 2026
 09:07:24 +0000
Message-ID: <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
Date: Mon, 21 Sep 2026 11:07:17 +0200
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260918165315.GF11599@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LV8PR12MB9617:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f42460d-e4a3-4837-1cae-08df17bfc000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lmq8042duFMjXRoXdDVXX45UDgd28DwjK4pJs63V0YywfPb8dQEPc0KDIOnMAxi0t4FnYiB8VrezTKuoi1UQk0a2NRn+KTA8M+goui+YckBr5FAAKaBDERqat7/k76fvyHJyjhjMFag/DbgZU3Uj6oI+t7hXjhfPYFkFda+tRRvJkxLNdRPFAM25tFndJsEMZxSI5fyHka7SI+WnCso7R0FMfsDlL8VgAVGMOr4rHLk8/88Sw3sb3YZLCyasLWBv2UdSFXSZbYBUnQWaY+u0QXa10njz9UoQxIfwK74IG3Q3lCcEC6vmi63Tqfv/SZ1yZWVLNr1uc40yGHgS/hx3EuDLaoCvC05H+L62tu48/ghlbVi0Vd69kqLSmBr5qcNfV2TolFDUA1aPrGgIhnpxTUCTvfEYwp/PpPfh3FH9+Qxk+5vs0wuSzaf9wP6SpQkFpJX/rv/54H05dphDJ5jWmGVbyP1/UGhAjDIt7RT0hpIwSkbJ9K4pY2jHcO0PvEFUkEckrTdF6Y0xzTS3wKxpKJflvm4BwBpDdk9QLe5d0gwwzzrgrIEtYej1edAwcqRrejLg66dcTB01cqUeVRvMWtUcCC0xRkbFRS9/H5HNphkkcdgL8HWagoWzImjWYy2pRxVz18sFbM5G/WZ8TQnk17FpssHbJnqcRp+sfNsXB4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWl5aUtPQVNuRjM3c21BTFpHd2orMEVLUDBUUTh3TG1qZ250NFdxQzJjcU1K?=
 =?utf-8?B?SmRPWmx0VmhJOGIvZDhQN1Q4SGk1Q3pEbklrK216V1gyMVBjZmxTTU9nRENR?=
 =?utf-8?B?aDliSFhxYmprL1l5Z1FRY2NCN1pVV05mcjFlQUZCRUVObnljN05RbFJ1bDdU?=
 =?utf-8?B?N01pNXk1a3hZOVdpWWk3TDdLZGFud1pRWmhPYjZEY2R0OUZpYXBDc3pBQjRS?=
 =?utf-8?B?dmppMVZ5RE9ZQTROK3pPVlVCeHJVQXhVclllWXBtWFNleVRIMHUxbWpGbE9t?=
 =?utf-8?B?TFFOOUJRY1l6bGc2QStlUDVzQzNuRmpRRUd6a1I2bG9LQmNuanEzNG5NZkNJ?=
 =?utf-8?B?SmZYdjJYUlpreG1icWxUWkx1MVRjNVZ5ZWlER1JSSGtZOFFBR1VCMkVlenRo?=
 =?utf-8?B?THJoQ0hhYUY0aGRDeVc4MG9xalR6OVdpUXdBeUxIandMUFBrdzk4SFJOS2x1?=
 =?utf-8?B?LzlLVitjK1grKzZMZkVoOFkrNmJSWWxJZjMrMmQ3TTZTb0g1OFF6OXZ6SGJO?=
 =?utf-8?B?LzBpVWI2cStnM0FqUE9iNXNhQS9LSWljUWx5SkthcVBVa01jUjhPMlBWTXZj?=
 =?utf-8?B?SGt5blV1VjU1NXgxK2dzenRIN1dCSjlxQVJXR1FVN016QURzWUFPU2EyUlRM?=
 =?utf-8?B?T2haSjcvZURrT3RTUjUyL0ovOTJlWlllUWhDeTVKT3hnK3F3ZkFuT2ZoVnhY?=
 =?utf-8?B?TCtUVG9VaHFSS3lJdWd5aFp2N0JPYnRnbFlzS2FscTk5Q3NhZ3d5TW1sdlNs?=
 =?utf-8?B?SEwzZS80azk0YjZ6bXdNankwN2o2SFB4RWJwOUVjZlE3VG1hMnFDNkpFdkFY?=
 =?utf-8?B?ZVJpdjk4aFFrQ0lxUkorWGVmbElhaUNPVzJBdUJCbDVFbWNlbUxqMXJUWU43?=
 =?utf-8?B?NEordHl0K1ZSYmFiaXNocUYrR1RCdFc1QldrL2JlSjRIOXhSdFd0UXBCdlRY?=
 =?utf-8?B?eDd1dVVVN3lGR3ZMNXBwcm45MlRKZ3lZajJjTnRPMk41WW90Nm1SS0dYZ2Zu?=
 =?utf-8?B?Q1c0bUhNWGY5YWEwUDdTSFgyN1BxTk9IQkUyckdwbUhhYVlCb3lIM2hWalBJ?=
 =?utf-8?B?L2ZtMGM0cVRKT3UvRitMRGlxTklQTHYvWEJCZ2k4cEN0b0RKWEl1TEhiM0FE?=
 =?utf-8?B?blFURWdPY2F1VFVmcWFqdnpaVHRkbXBpQk8ya1JJaG5lQWsvNTd3d1JQdjhG?=
 =?utf-8?B?ekdzb05CZHNMbU5vaENkSzRvRGpldjE1Z3NYS0R5KzU4UVFHZ0tVaGZoT0ox?=
 =?utf-8?B?enhxNVJ0ellrTWZRbEQ2alBiZW54clZDL3NvalJWNkNZbis0VGZqQXhwaVdV?=
 =?utf-8?B?R0t1K1RsZlY1TVFRRGJWUjR5Y0QyeTBXWi9CblFNOWFhR3R2VHFnaU5FaXV3?=
 =?utf-8?B?cC82ZWpZSk43d2N3U1BTZWdvNkZFREdKWkl3Uis3L01acTdWd0YxeXZnOW5H?=
 =?utf-8?B?b3NwT0VsSEpGWmk2QjEyMjEwVXdXWXN2K2JXVk96OXp1QTNSOHZVcy9OejNI?=
 =?utf-8?B?amQ0U0dUMHk3ZGtIQjJjNjJKaHd4cnJPQ09hV3gyd3k1YnYvOHlpZEFBY2hS?=
 =?utf-8?B?ajh6VFBsVFgvZkYwMGZQUVQzbFNjZys2NjdVSVhMSEUwb3FnR0JXN1RiMVhl?=
 =?utf-8?B?KzNkUUJsd2N2YWdUaWNNb2x0cllzRmNoSENIcHdydFY4L0FualNBNmpCRjcr?=
 =?utf-8?B?VDRzbUhpYnp6cml0UlVTK2dDK1VySG82dGFNdUtzdkpkS2l4S0laUU12Vzdt?=
 =?utf-8?B?TGxWV2lNZmZhckVDMTJRZ1lXbFN6N3ZyNU1YSURxaGY2UG0za3dqZm9ta1Mr?=
 =?utf-8?B?RTN3dlNyM2lJSmRnUWYwVDRTMWVlY3FXVVpxK3B0YjZycytyenJzOTdXRm81?=
 =?utf-8?B?V0VNN0pjNEkwbi9lNmxDUTczYzlZbEdIRCt1WlpRS2Q4SzlSZlZQdGJualFt?=
 =?utf-8?B?bmM5ZnI2TEQ1WUs2ZG1IWkk2QjVsMkVzbkg3VWgvdG5LbnRFalBBM0JVSi80?=
 =?utf-8?B?VUJIMkVNNFdLUjVtVjhBdmF4R3IyNlRibXFGOWhJTzRoYjRDVHBxS1krVVhy?=
 =?utf-8?B?TmY0ODRLWFUrbm1Zdkp4Y0pRdjZ3QUN2cnN6bXNHVk1BUGFJUlZ1eDhOSlZ2?=
 =?utf-8?B?MXBVZEZpK2RwNXh6b01xZUJNRm9YMk8yeWZPUEJkRUxBRXVoVTJ6bG9ZMXpq?=
 =?utf-8?B?ZC9OWERzU3diZEVWWE04V3ZWSE1ocU9XTGVWb21WSlo3K2I3RWdZVFErblZi?=
 =?utf-8?B?NTR6MFY5TktmL0JjWTR0TTNsZ0E5SWhOWU04YjlMOEp0d1gwOUV0RlRSdzNP?=
 =?utf-8?Q?7KCLL2e1VULLPA4T83?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f42460d-e4a3-4837-1cae-08df17bfc000
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 09:07:23.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXIFVS5d0eAHCiOUlbyKNZ/c2J+oflcT5dmMc+frmu0YLwuqaOrMIqRchHi+OHxz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9617

On 9/18/26 18:53, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 05:39:55PM +0200, Christian König wrote:
> 
>>> Arch code can figure out how to do it. If some ARM configs only give
>>> order 4 folios or whatever then dmabuf heap doesn't care.
>>
>> The fundamental problem is that DMA allocations are highly
>> architecture and device specific while Linux memory allocation APIs
>> are generic.
> 
> This isn't a dma allocation, this is a memory allocation.

No, I mean this is a DMA-buf heaps allocation. It is a DMA allocation, we just don't know for which device.

So ideally we should use resources which work for most devices in the system. If a device has special allocation requirements (CMA, restricted addressing etc...) we need a specialized DMA-buf heaps for it.

That userspace provides this cc_shared flag is a NO-GO to begin with.

Regards,
Christian.
> We made things so the CC shared folios are DMA mappable through the
> DMA API. From the heap perspective the only difference is passing an
> additional DMA_ATTR_CC_SHARED when DMA mapping the folio.
> 
> Jason

