Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FBE4B1293;
	Mon,  5 Oct 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212035; cv=fail; b=WkY4wVXv4HHbjMNpXR1AZYJsCt3PQgFQAocLEcfKrkRokXBxd6nX99ekFlfUoHsFIcOgwsxPcEWfmZ7v6dlpzlRovZzzqLvVus0B2daJ6zZNX73C8EC3iXJr6QMpsNAiUydyqd54pqROB0PzHvXssKxxONarPdiVwusuE5Y5Q4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212035; c=relaxed/simple;
	bh=hGdULoe/W2dbSVyhiNd/guNApPkDuDmLF1WFcRKixlw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P8iaSUhJE3dWPV+Yx++pxdJu5Fpd7IvkgAj/6PQdgW2Jynt/M0EnoAGr/OSefLruMhUHJ2KuCT3G3cCkyE/4v3iLIGzbd4HILeONeNX1X7ep9EA5qBU67W5kxH2a/R30zpOhUJG5udLBrztWYbjzCLFtT3SbzcvUvyMFT02oBrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wIGvIAAW; arc=fail smtp.client-ip=52.101.85.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wIGvIAAW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pw3lf1bFTBSStJfEdjrCIrBSNkTC6D00dtZfizWfRjPoZMA0eRKpzx2msy2tRNMK+xukBQxSlG7JzIBafsMqmMV3IVurp+FSPKTLbamM/bkPgJr8grYFsHtVJDEiGRly4a7EX2wWcXw812kxm9yNzqtPheFwa3LV+0e3pFdVwvVSf+DnpO/6/E8/HS77jfjBI7WtRyzUD8u0xw/KrcvmUeSWzSHuCskK4Y0oX7KwqMW1b3eZWQJiwcgicvXBbaWWGChJHixNSK57919HYjamRfZpOLIc4ApGaSQbpA9fm6p31E0rsiSKfIfd/IQaEXyC2ECUoGXIhLdgHltWHbOghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhYYD7fuqcEAqP8b+0LuUdhivoZIMdrxyhMC5z2p9gw=;
 b=ORZq6mJpMNo8JqZweAKESr2IUbYSuWZQJX6/oC1KXTgmHsuQmF3JzhlPN1kLNI7LBmiRPybhtslCSYJlzb4jc0xVoNfmrfUvJJj/nExXl1/ON+cvwCtciD8AcsEhWg/u47z7I7aEPNB2VVKjuUZyMSnBAAW33+Fmyz/+T+ZS4Fuy5WyISTKxIGnTf2DcDmBJ1yKyoOlpabk9zH0SFJOigEtvl/ljILckBLj6RuIT8jIL0HIaqQfKwWJZcnmT2qyaFz5fX6970HgrNI6Qvs2HToD9s9ERxajS4CVBWhTYBmSKEWdplWK8JsT6/M46URq8zDd0TZ1Mx/l6xl2bJgx8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhYYD7fuqcEAqP8b+0LuUdhivoZIMdrxyhMC5z2p9gw=;
 b=wIGvIAAWRpVTelaHn5Xf4TclnHJYErRu37kJxH+pnH/xAOt0jRFJFktlzFAUi2Fq0pLTUcBifmyk5OtHjOF+OZRqxas9t1uckJhfAgzdOapw3RaaKL3OBoqPUbOYu3dbM0NIvr2S9lmN4PR6M1a5ucw4jNdIOYlXouKDwLGOTEo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BL1PR12MB5729.namprd12.prod.outlook.com (2603:10b6:208:384::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Mon, 5 Oct
 2026 14:53:47 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 14:53:46 +0000
Message-ID: <f0077cec-10fe-400a-b229-f7434e297364@amd.com>
Date: Mon, 5 Oct 2026 16:53:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/6] dma-buf: Add get_phys() to describe a physical
 run
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Ackerley Tng <ackerleytng@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Alex Williamson <alex@shazbot.org>,
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
References: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com>
 <20261005132046.30025-1-griffoul@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261005132046.30025-1-griffoul@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT2PR01CA0021.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::26) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BL1PR12MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 5180c871-a821-4b99-440d-08df22f07562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|56012099006|6133799003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UMx0b+52OJCYLOf3oRoulDZIGT5QrLnzOPNMCapQVSyRURB5fCSysSsCDls0m/nsgU+Rewv0hwM6sGISOslSxlDf+V1525NPxJ3b6a3KpwPI2G614zfLeZpctlIy7hrtl4VH53G2goXj7KlcD2XMdgVHRRxZ+QF7cH9zYnN5PbCbBXDOLzm6a7KZuOScVS41NpxCR7fijpnvixJNIipadhiZDk4yTqIbuj+Oimh3R/UrIelVMAXFSvaLP34R+oCB7yihEiuv8FBHn1PMGc4AFBe6iGt69gntVEx7Z/f1JN53fQ+8yytRU4X91Ox3DBfYowNwGYcAtLF/40KTzNC7HH9OvoDlF33Cfc1WpX6zYDE8oW5hZ9LJK5qnBG+G1GWbbqqeKBZJmYt8Gujq7MJc1ehEJ3bscl9n8/JRFjEJmWRUaHr4mfgUzX7tBNUVkY/uj6w2DoVeeldjKURa5CE0pox0qOcLBcJRdczt6Nz+yOJsMU8QQXHjqzMwdla9J4G5BYx2QTklmlfQSiCK+hQ/6QudiHQMd+5G+J3jORC5BCXzmyU9jOdJcCYzLcFKA4X+VZCRb5UGKckeTYm6JKBj7sV0kJ5o6wm19Yv+0O1SAqpzwOkZ7Fjx3vuZGdHl8P53
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUZnZzlQU0J0SkJkUTdIYzlWSEhvRHJ3VlVBbE80Z1A1L0lTU1ZLTll4bmVi?=
 =?utf-8?B?a211M0o0QkVyMWxhM0JKZGNCQnJmTEFzRk9ON0k3eTRadU1zQVZYUTB5bW8z?=
 =?utf-8?B?eDhaQ0FnVDlsRUM2VUJWRTJZa2pBSlJMQWhrbmNWZ1Z6ZTJuNUkxdFNMeU4y?=
 =?utf-8?B?M2hOUHY1bEtUWHNlOSt6cm5XcXNmSjByNHcwd1VvNlEvSVZsamdVdmFxS3Ax?=
 =?utf-8?B?c05sUkQvWjhOVWV0M1ExQkoxT2ZrTzF6RmhPNVVBNWtzMFkwaDhQejllZnc3?=
 =?utf-8?B?OXNSbG41L2hvdSs3OVlUTlo3ZmR6T29XbVNUOEwvU1BxVmNjK1V5dmhpSUEz?=
 =?utf-8?B?OWRwNk1ubWcra3VrVitDRTNwVUtpaVhDY284RFFKc3pjdUtmcWlHQjJUVFRM?=
 =?utf-8?B?Y2xhLzNyT0VRUDlZd3V4ai9ld0pISFl4Mi9Jc0lFcFZ0bk1QZ0d6ZVdOZjRt?=
 =?utf-8?B?a3NBUHUxbTQyRTliZk84TktrMG1WaUFyNEdZNzcrS0trNTZLdUNJQ3hXQnh0?=
 =?utf-8?B?Z2hHQTZNL1BwVUZaTWhXTEc3dm1hbXZ1UFZLWUNSUGRsTjcxV2FWNm9CMnBB?=
 =?utf-8?B?WjBuUEI0VUo2YXVyUVM1UjgyZFNRMGlmUnQ2aVZNNDZsMWFvOHVDU2dYYXlp?=
 =?utf-8?B?VzV0Sm1QRGRNQzBwNHI1aFVyaW1HQjhNRmlPcUpiZHpoWWp0cHpJUWNBYWJ4?=
 =?utf-8?B?RjJXdW9yUmQ5ZWFKazlMSTlHZVpnMTZaV3l3VEs5czNYQitiWGJOZi9admRy?=
 =?utf-8?B?SmpVSkphclViTldydnc3Y0VjNU5tU2l3akVSUG9TQW9qY2h4dG9uOWhBdWh0?=
 =?utf-8?B?WEk0UjhqWHEybUpqNEl5Ly93dGVsYXJwVHU5QVAzU2puVWRxZGUvV3g3b2dp?=
 =?utf-8?B?WkZ4a1kvc3VsSldKWUNEYXFFYkZqaDlqV1l2aDRkc3VxMmg1N2t1dEdMalhV?=
 =?utf-8?B?a3MrRWEzL3JtdmFQYVcvY05PSmtML1VkVnk0OUt2UUJRekJybDdZSDVnS1V5?=
 =?utf-8?B?YXJPWStxbWRyTVhyQWYwbDlkcTA5bXhEbkR2ZWRobXFuV29UVFY1c1FRbDlB?=
 =?utf-8?B?eTg1dThBMzVwNHdldTdCM0ZsR1lQajBleEtPcUtHcW1NZnJXeFRielMwa1c5?=
 =?utf-8?B?MkxMZFJLZ2UxeHJzRHNFL1hSY2RSSEpzMEgwRDFTakR6VGVQOFVaQS94OEhN?=
 =?utf-8?B?WDVLMjhoNG51Uk93YWQwVGVDT1V5cGd2UlEzd0dBRkU0VmRESjRQTERrUXB6?=
 =?utf-8?B?RVBVMDhvMER5M003RzRPVWJWNGU2ejlqZzNDR3lSWUVsVmh1dGRXdlJlWUpz?=
 =?utf-8?B?djJRQ3QwZzNwditmVmRCZ0cvZHVQMHdqd3RvMnZDSzVPT2lMZWVJMEhTSWFz?=
 =?utf-8?B?LzRmcFp4bGFiaXBZTENuV2VnWVJBTWpNcyttR1BCeDUzRElrc0NyL3F3eVFK?=
 =?utf-8?B?N0ttaVJYdFNqbHRoSTVVZnA2OFBibEUwRTduR3BtU0h0NHlMaHVLZ0F3dUQ2?=
 =?utf-8?B?bUlFM3dBakdDbEpxSWh2T1gxeFFnekFyVEZYYUxQSm5DNFhVNmxYcUpXdWxK?=
 =?utf-8?B?dDNpV1Yray8ycXdVaVBqeFk2Qzlpd1NBclVsLzRleVJWV25nQVpkN1cwTVBJ?=
 =?utf-8?B?OEQ4RFFqSGc2bWhuZXVCeVM1eDZWUjVPV0pkcVlmMkNOSHh5T2ZoYjd4c2Y1?=
 =?utf-8?B?U2hxc0xBNWRhTFlrYnVpZW85ZzRGMFFNaTk0Y0V4VjdQQXd4MWNUYWtMdkNK?=
 =?utf-8?B?UFNZMXNIS3RIN25BQWVmWVA3dGZTV3AxQnRjQTRNY3NXM2w1YmJaL1duZTBE?=
 =?utf-8?B?VmN0LzlUVVlHWThyZm5pSFVCMG9GMDFqMWVnRWN0YkZZcmFLOUNLK2MreWtq?=
 =?utf-8?B?RUtQaUt6TTJ5aHllWE84T3J4ZzV0T2dpaEs3a1Y1SnY3MlNxUmdxZjNNc1dP?=
 =?utf-8?B?R0pwc1NFNnRFVzQ0VW1YVDNwVlF2eXBwelpIT3NZK3M0a2pEWUsxL3dLZU9X?=
 =?utf-8?B?YjNpN1lVTGNIQzZMLzVCT1FqTGt1Tm5NVFhoZU1wOUtMYitMaUkzSm9LbWFz?=
 =?utf-8?B?M2lkSzBOTkpiSHViNlR5dHBGVitrMmRBVDIySHl5LzhzQVZzUEt0R1NWbUVM?=
 =?utf-8?B?TDVpeFQwdnZCK3dwS1N6T3RnclF0K2JJcnZUWmhoZDJ0WlVTbWJJMFdhNENZ?=
 =?utf-8?B?L2Q1a082VHk1bGswVXdwYzdsY1VESkFOeUw2ZzlyM0pBTTluT25EcmVKN2hC?=
 =?utf-8?B?RlVMRE9udVFBbDJLUVBkSGVURTNob1RlekNkTmFKRjR0SmRlVzhMdTNhYmF3?=
 =?utf-8?Q?Hc0M7qWAY2qZQ8+ci9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5180c871-a821-4b99-440d-08df22f07562
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 14:53:46.8740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmtdD0x3b82LYedWJRCPE8uRkJn8eUSChFoy8OXHpB8cABCoDWbN6dYWy0C+wQk+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5729

On 10/5/26 15:20, Fred Griffoul wrote:
> On 10/5/26 Christian König wrote:
>> Well filling page tables by the importer is an absolutely clear NO-GO
>> for the DMA-buf design, we have gotten down that path already and it
>> took us years to remove this functionality again.
> 
> Understood, thanks for the quick and clear answers on this patch and on
> patch 3.
> 
>> The problem you are facing here is that dma_buf_mmap() doesn't work
>> because you don't have a VMA.
> 
> Right: the memory has no struct page and is deliberately not mapped in
> the host, so there is no VMA to hand to KVM.
> 
> I'll post a new version of this series. It drops get_phys(), the ranged
> invalidation and the guest_memfd dma-buf import (patches 2-5), and it
> does not touch drivers/dma-buf, as you suggested in the PAL discussion:
> 
>   https://lore.kernel.org/all/c413710b-4c28-4ed8-88ec-aeb8c4482011@amd.com/
> 
> KVM gets its frames through the KVM-private guest_memfd provider
> interface from David's series. iommufd gets them through a private
> interface with the exporter, as it already does for vfio-pci. The new
> version adds a small registry in iommufd for that, which replaces the
> symbol_get() of the sample in David's series. The dma-buf is then only
> the handle and the existing revoke.

Yeah that approach sounds totally sane to me.

We have drivers which stuff all kind of resources, not just memory, into a DMA-buf. That ranges from MMIO BARs to trigger FW operations (doorbells) over full HW blocks (ordered appends, global wave sync etc...) where two or more applications need to share which one is used.

That you then have a exporter private interface is for accessing this is perfectly ok.

The problem you are facing here is more that this is not limited to one driver/module but multiple ones and you don't want module inter dependencies because of the symbols.

So symbol_get() is probably the right thing to do as long as we don't have something like weak symbols or similar.

Regards,
Christian.

> 
> Thanks,
> Fred

