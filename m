Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED53442373;
	Mon,  5 Oct 2026 10:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194946; cv=fail; b=NibhwE2g9RYisrcy5PaT2X0cSu7c0tZ0qAFGDxl6TxKPU3Uh0xxh7cWbEOhC6mGGycpcw2P86yAEKhwKBpUnTu/SooHVV665DXTCvDuxoWCcVSDVAzQyZcoLU1m2uupMC2BcukCovmBv37fAsHPWGnPTwOuajcz3Di3Dd8uwlpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194946; c=relaxed/simple;
	bh=b+tx8K95LDpM5KSkY/UelrSRpaqt9uo2EW3FiP90WwI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uGIPvbMF3uD4gQT71oLIqcdQYUMkTbRWKbKJ74YvHr2zEp3DmraE0D5weFX7uLuODC2alyO/P8baTOehfe+if6AgLaIneg3vVp/bFu4av7FOm+6k70ol4+V0phhTTl6Xub+kVz4nEtUBWCE5WvU6tuv+5o8XQbpjLzlDymCSzZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iU+b86M2; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iU+b86M2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3ILky1M5EvunATQtP6LL1IT6Iu+/xU3FlPOD5JgiB3X5/pXx1OcKDyGU4blvuLblq7kXNfcPaPIba0VZp3sBEppebJZVAZO3HlkEcCyPy0IJv0REyLNjfQk32c5Vz2HS6JLddowR66+W5zgCdoelXr2PMjbvLKUZmORR3924YRM1Sx2nqxiTAnCppJmEsH6gXSF2pCHPolS9kk3DoAg30oVe9eHMSocyhWeo1e6iDJMRdIjrLSw0W2h8f9ZnipVIA9J3/G4GwRgV2V3kcSnxVPF8wI1DE5cH1vu3nDqI4c4U5wNqnvANmUh9E8D7IDL6cBBjxAGmXECmAw7ioaWeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRuchyLASPNs/Idu1XzTq6YGjzxyPtWok/wuyzbhaUw=;
 b=dZp1uf81F0z1hcTyZ40w/nk2Al5Fkcf25+7dY+3cbndnxSQehQN2X2rLULodtk47nrPMekJZGmrnhha9WhskY+pBfU1VtiV+E3bbIsL1GMVQH/boHbbYv7Y//attyV38r1MXSc5DoddJ16y3571PGq5Vfzhoscq/aUYu7VyPiLGU72KSghxdj964N3AJNPAVj84x+DZt4UA8/qjmXbzpdhm9ChpwtgiWYcR/RNti2VuqJKsFODzPagz1CPQ4t+nrPkJ2sspEUfW+Rkmb5qPI2telrxtU3sjpwH+K4zz3wMzSioy3hwBnX4tyChVJnHHo+mn3e4TdsLKfmU2S0wtgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRuchyLASPNs/Idu1XzTq6YGjzxyPtWok/wuyzbhaUw=;
 b=iU+b86M23XPv08q/GW3BRpEKWrTPeCz61MDZMZPqvWaSBpqWSdOXMevuy+ULMc8gEtcQgCwKdsPQpmVeZsCMaWYbrQy4tOayx4solxnCMWN50fRbIKclUx/7EamKf4j+YvXev5JHk+yxxM0WNXQp3lGgwPsik1EEhPYTmrk0Kf8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 10:08:59 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 10:08:59 +0000
Message-ID: <189054b2-3899-429f-b5fb-5be6917f7960@amd.com>
Date: Mon, 5 Oct 2026 12:08:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/6] dma-buf: Add ranged mapping invalidation
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
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261005095552.52748-1-griffoul@gmail.com>
 <20261005095552.52748-4-griffoul@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261005095552.52748-4-griffoul@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0304.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BY5PR12MB4228:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cefb0a-155e-4bd5-fb0d-08df22c8aca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	aKS7Plx6L4aE2cwQY4Kl8/biwQ+YvW9UckTYYYjPmFbIbga+HbrKCXwwqgAt4NaEGs4SWPOt4yyoc5UrszxWnm4hOnVmdRm5Koir+eXUBwvkgvSvLJ/PmZ/z/kBLUApd/nSwGBkA6dzUYuYhiyDJnn0nTw6KFEnBRt6Bgi1QKCoW96YgwLJ7uO6ZgLzSt50yiB4Vzc1dJxN8CdtieOB1QvaGjnvRM6IskuYzIirFpWMyH08cjcI+gbR/j+h7UTLbB/fBnqKOqjjM72cBdfmkk/1mrigsAN/Tua47pj7xpcpYXTWvn5ACl5RVPySjbFI/3pSzmd1jEAe+HcNbG7Jcgr0eqfQjRU7qTEaaCxEfTfZU6EG//V0BnaR318cAUB7ODylrukN7Hxb97TGkDj468l+/MoblIaWJlxJT3skxiqvve3FZAXY/sMMEjlhZtdQNJKNfWMkWHqK3Nb1Dy8HngZDIoiHF61Uv0zxQ4QDRva3dGNfOgCWTe4HIgf9nCcvnWfY8jJ9z32wouVX6SQ/ycSzZ9Dw5WJqi1kWx0mExOghfVysZA+9xEqwLVKBPn6y96jrJg4Vv8cmmXbzRZfpt1eTbe40wZHHFPsMkfZXFHemqC8gLmL5/sF8Nw4wfu1uw6TE790LGK9q5ANBVJxfhsE5JzUlB16wpd7+R645t0Tk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnZab3ZLTk1zOW4rM2hUeE45K0pMZXE1c3pSZXdidG9meDFWMkVuclc4YVlJ?=
 =?utf-8?B?SHF4MUJMdTVDcUt0b3phR0lnRWJtRWtnV292bWs0eG9oazFKUld2cXp4NnNC?=
 =?utf-8?B?UGNUaUtndHhIOWhFTUhmdTBkdDR1ejZ4VkNHeGVTLzhnUVErQ2VWMVk4LzBm?=
 =?utf-8?B?bUcvN0o0Zy9xRmNUZUtXQ3cybWhwZkMvQXZ4VzlwV1JUbEVFckNJNVFrTVk2?=
 =?utf-8?B?U3ZUZStMU01QK3VFWHNpTnlrdXZVWGNRK1VDSFd6cTE1ZmxQSXlPWDZTOGVT?=
 =?utf-8?B?SjI1akh4RTBueU1pcUZkSForalpTWHIrb3FNRXVHZ2Z4VHpvUUJKbHR2THB5?=
 =?utf-8?B?cTBPaWxRQkRXbVB3cGU1M2NCbnJTYm14VDVLd1VnV2JJdzAzOHoyaHBLRktH?=
 =?utf-8?B?Ky8xdnBlc3hLbElwdUZFUUpTdkVxQk5hZ0lqTEJYQW1hUUJKbWdjcytQUm50?=
 =?utf-8?B?T3JZYlZKa1JRWS9LUHZoVURqUUJpTVBKblpxWU5JZjdEVDVtU3M1bkFDMEM2?=
 =?utf-8?B?Y0MyM0NTOWM0blJlbXcxN0tDS2VtRFlQL1lObjFGbjV3SFY0c3RDRURXU0tu?=
 =?utf-8?B?OGtZRUlENjd6ODFhcmhzMDhiaCtSSDlQZGF2bUxXVHIxQksvN2JLWi9NaEQv?=
 =?utf-8?B?NjA4VUtuWVc2bmpVUWxPMG8xWnBjQkZCODFZMXZxbFVTbkl2VU10cXBnUHZu?=
 =?utf-8?B?M080RlljNnpuY2FOR200TnZIM3ZKb2d2eE8yemh1T29xejN3L1E1Q1BvRklI?=
 =?utf-8?B?cXNKRlh6amdoOS9OVE52M1NYVFZrb04wMW9wdXJkV0hTcG9HQkM5M2hFYTNW?=
 =?utf-8?B?ZTdzMWNNWURpNHNMWW9QemcxNWw0QUxVWjVCY0RXYzR5QkFCMWdCTGYvUmFG?=
 =?utf-8?B?UVk3QTJjT2QyVXdCbUhqSFBSN2lYUWF3MnJxQzNqVzE1YjVNc2kzODdDeExw?=
 =?utf-8?B?R3F3NGJKdUpwak9va1hndERuc3hOeHFqd3Y4RW5WN28waC8wdzFuMEtlaXpY?=
 =?utf-8?B?Z2oraEUyTjBuVW1adWJzS1ZITkhJditIWm5PMHRUa08wZnNHYnBSLzRVT3k5?=
 =?utf-8?B?T0hRVDdGL2NDcy81YzhCQlhRUkpNTFBzVGVWYm5GY29seEZsNEk5RURSRlRs?=
 =?utf-8?B?RFFSZmhLVHU1aEwwUTU5RjRXSEJmNVcrYnd3TWN5TnhKbXZrMWJsajJjaGNS?=
 =?utf-8?B?REZzSTNVTmszY29KMjFFcC9pbzcrQVk3d2w1TXhVMStTOVRGWGtRdW0ySW1M?=
 =?utf-8?B?ckx3cGFHbG9Qb0JNMkFxTVR4aE9pQ1MyUERTYVN2a01UeU1Fa0ZDRVpXTGNP?=
 =?utf-8?B?b3RXSHBLQlJpbndHWERkOHRlenFEaXhWNHNDVlY1ajFmZVFiSWlYOFg4ZW5U?=
 =?utf-8?B?YUF0Zmp5TXh3SkVqa1dMZXVVTEYzZ2hjbHFSMFM3aC9Dd2FwR2dYSEtDOE5o?=
 =?utf-8?B?bmt1VWVDZ0t4M1FuakdoR0xFVjVxYzRmc0hoQk9aNWVhYkFqOXNuQlA3RlJa?=
 =?utf-8?B?UXo5RUFBUXlzeTRJOUdsRUVJekg3dkd0YkNlM3BKdUE3L1YxNnRMUTM2Q1NH?=
 =?utf-8?B?enIxUGtMNkhJcHNjWXV2bEIwakp2RFZwOUQwSEtVbGJDQWVTclhnbGJDdmxL?=
 =?utf-8?B?UExlZE0ySzd1bHZKY0VqbGFiVkZVbzl0L1NoV0RCMjRZaFJ5Rjk0TnpBeU1q?=
 =?utf-8?B?V2ZHRXMvR1JhVFl6TzluTkxmQUNmbjg2eVNhOE13NFVSSTRQVUhnNmhNRmNo?=
 =?utf-8?B?TmpDRGdqa1JaY1psTFNPL0oxcmtkcWRlenNYamxMNHphMVJaQ1c2cGFVZDht?=
 =?utf-8?B?UDZTc1JIbmtYMGxINXE4bDBZR0Q2SUp0L29LbUxMdE5rcGY1NUFRUW1qY00w?=
 =?utf-8?B?NExZQ3NyTlByejFvVk1PNjlLcUVmYmhoYjcwbGJJVlk1QWh4UzZrTFFOWWNH?=
 =?utf-8?B?WFlEWUJ3MS94REZ6Z3d0a1QrOENqWU1NMk1LeWp3bGs1ZldMRnBobjRReXFU?=
 =?utf-8?B?V0k2clZNRzdvSjJLa2QzdUxpTU9SVzdBOXMyMml6YUFQZlJBRjFscmdYVDNW?=
 =?utf-8?B?Z3B2TjBvdUFhWklOaVl5eWJtVW13SW1qa0Zpd2hjb0U3cnNRWjFYQ1o2bjYv?=
 =?utf-8?B?c1VVN012cVdCUWtlaXQ0cVpsRFpiSERIRERVYzNRd1UwcGo5alZ6WkpxZTha?=
 =?utf-8?B?YWI4U21yNHduK2RFQ2pxK1Vaak0xVzE2R3JqTkhDa1lMS0ZzbFgvSDBaaVBr?=
 =?utf-8?B?eWNyZzUyK1k2czR4VjlHNVMzamFvOEV2Yjl5VTVlNlJMaWtGNEJvQkw5aFRP?=
 =?utf-8?Q?0B9+nKmnBkEpZMvJ56?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cefb0a-155e-4bd5-fb0d-08df22c8aca4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 10:08:59.6509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJl+UFqf0sYUVm4UPyg78W8ujOjnfVAn24iraIuxrxj9SmFrtYLh67EZcYWDlmw+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228

On 10/5/26 11:55, Fred Griffoul wrote:
> From: Fred Griffoul <fgriffo@amazon.co.uk>
> 
> dma_buf_invalidate_mappings() tells every importer that the whole
> buffer changed. An exporter that changes one part of its memory cannot
> say which bytes changed, so importers throw away mappings that are
> still valid.
> 
> Add an exporter helper that invalidates a byte range, and an importer
> callback that receives it. The callback means that the address, the
> attributes or the backing of the range changed. If part of the range is
> no longer backed, get_phys() returns -ENOENT for it. Importers must stop
> using their old answer before the callback returns. Importers that do
> not implement the callback still receive a whole-buffer invalidation.

Yeah that is exactly one of the reasons why we don't allow that.

Clear NAK to the whole approach. See the reply to patch #2 for a detailed description.

Regards,
Christian.

> 
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  drivers/dma-buf/dma-buf.c | 30 ++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h   | 16 ++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 66b85d53ed22..e7010163eb2f 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1389,6 +1389,36 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
>  }
>  EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
> 
> +/**
> + * dma_buf_invalidate_mappings_range - notify attachments that a range changed
> + * @dmabuf: buffer whose layout changed
> + * @offset: first changed byte
> + * @length: number of changed bytes
> + *
> + * Importers with a ranged callback stop using their old mappings of the range
> + * before returning. Other importers receive the existing whole-buffer
> + * callback, which is correct but coarser. The reservation lock must be held.
> + */
> +void dma_buf_invalidate_mappings_range(struct dma_buf *dmabuf,
> +                                      unsigned long offset,
> +                                      unsigned long length)
> +{
> +       struct dma_buf_attachment *attach;
> +
> +       dma_resv_assert_held(dmabuf->resv);
> +       list_for_each_entry(attach, &dmabuf->attachments, node) {
> +               const struct dma_buf_attach_ops *ops = attach->importer_ops;
> +
> +               if (!ops)
> +                       continue;
> +               if (ops->invalidate_mappings_range)
> +                       ops->invalidate_mappings_range(attach, offset, length);
> +               else if (ops->invalidate_mappings)
> +                       ops->invalidate_mappings(attach);
> +       }
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings_range, "DMA_BUF");
> +
>  /**
>   * dma_buf_get_phys - describe the run that starts at an offset
>   * @attach: attachment to query
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index b223962e20c2..55c3fe60a0ba 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -485,6 +485,19 @@ struct dma_buf_attach_ops {
>          * required behavior.
>          */
>         void (*invalidate_mappings)(struct dma_buf_attachment *attach);
> +
> +       /**
> +        * @invalidate_mappings_range: [optional] a byte range changed
> +        *
> +        * The exporter changed the address, attributes or backing of
> +        * [@offset, @offset + @length). The importer must stop using its old
> +        * answer for that range before returning.
> +        * Importers without this callback receive @invalidate_mappings for
> +        * the whole buffer instead.
> +        */
> +       void (*invalidate_mappings_range)(struct dma_buf_attachment *attach,
> +                                         unsigned long offset,
> +                                         unsigned long length);
>  };
> 
>  /**
> @@ -600,6 +613,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>                                 enum dma_data_direction);
>  void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
> +void dma_buf_invalidate_mappings_range(struct dma_buf *dma_buf,
> +                                      unsigned long offset,
> +                                      unsigned long length);
>  bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
>  /* bits 0-7: memory type (a value, not flags) */
>  #define DMA_BUF_PHYS_ATTR_TYPE_MASK    GENMASK(7, 0)
> --
> 2.47.3
> 

