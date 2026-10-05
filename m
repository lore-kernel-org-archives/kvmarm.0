Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9AD373BE7;
	Mon,  5 Oct 2026 10:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194840; cv=fail; b=XZTr3AhmvX/cGUaBIU8iRWydonnWDR79k5zx+27UQvCgeTCDvCHUyg7fX0nooY7+VTV3W9aIzSfeFttcITLuH7VPe57DiZW5Xdf7joEmWX+/NKl1++4GEhe4nqslI27GEdcSNrte4Rp2Wh5EU2IvuNZfphXImwH2N8XpOoRwihg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194840; c=relaxed/simple;
	bh=F2hAvLo6lfWRgJVCTuKeMKASUywU9SwmlDwnDsJ4Ct8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qKRx7oJRpJzKe2ykpQ2lje0LpdJpAekU/8w0GT9D62EnsOnIXDh0VfAJqKdhvdh/svwDvKFuw1OdzkkAwb/cHjb1PjMoDeWPAVjJSmvKXTn6lBeOGLNGvfevucHgnIFAAX+qY7EJQbb/kgTFbQUZdew6hDa0mmh9S3FjdiJ2HpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pA7tl/VD; arc=fail smtp.client-ip=40.93.195.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pA7tl/VD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jJkJvjoM8fbHUMHciQJHkFYw/yek/zNCzo1RMIBZVNaGbfEWZHYpVuF1MnlCqoB5vFRrmoGTpPnr3bwE2+Z6XPPhuYk6JbhlaeOUggBLIQ8sSyoAsC+npM0nDDt7BRQ1MHrXKf9talcVHN2VESNHa+Gj5ZAoKr4CEPQF/2yOOvB2ZNUfcMVksZ8CwVDYzR+hnAE8QVdtvXg6DQPtESQQB9hiiZm0zSHzfXNRxCa9g/JFzcfG3fuuBIyfNOC/YU4HEzxEsJbJhVNwoK/2qufnpTkHTBzYhbS0bDQcZEtpfKNGhX3B6xPfFy6fhxS3RU73ukxukJ5+ToURWxoAAvmxwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gOnsLghsCEMz+7bDShl30zp9mLRzE7NZojV+0FmlW0=;
 b=dA3gPAvMhQs+SMHhnlh1QZdhz7PuhAIqf4Rf/4ITDnJez3OgIJdPDMc5majmvM7au+tlNlAyaowzBPreNg6bZq6bI3x12ZzgY+DEMrX+1gp6/DJ+IEllMqKNegitBYSMlm56VejWSmFS7VVgd7Fp7MX1W70N38jPUZHQdQDYO6iS1CEZSclpmEs4V4GMQKO2AWBNpuDOwdJt7iSxeZ41CMPBusDj9TmHPgob4iEflAUdZNzrkuFpCRmQQm28DQTXuI2YP25E3NmontKfmMOIiZeSCMF3hJhKIIzjd5pBmSx8829VO0quwmGo5kEZC3ufM8udNA1uGSZ/F+riGWGt+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gOnsLghsCEMz+7bDShl30zp9mLRzE7NZojV+0FmlW0=;
 b=pA7tl/VDQikGtfD2pzzXoNzH8VvLCxt2TZP6I5A6dJma+c51Iq1ZafZTcN9mwOuxQZBKZxZPZ48+JijcJFKnggAPuMDOWroaI+K4CnahLZuy2MXTIeWR5f7UKlDxlqNQIJcrb6jB8qhQ1tfpGSx8sK5AgrdrWYn6A6CaEqTUgq0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 10:07:14 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 10:07:14 +0000
Message-ID: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com>
Date: Mon, 5 Oct 2026 12:07:00 +0200
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
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261005095552.52748-1-griffoul@gmail.com>
 <20261005095552.52748-3-griffoul@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261005095552.52748-3-griffoul@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::28) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BY5PR12MB4228:EE_
X-MS-Office365-Filtering-Correlation-Id: ad7b2fdd-373d-4250-8abe-08df22c86da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	b9jt3GFVu1iZWmfs9cTx0+roBQru8XklkLy2L0jpBqXHrn07YKADlDKMLjobuOzw+d/tFxr0RndPqO1cl355M8j3+3K0YqlLmgHicl4POnwD/8kQfByaD+OwYGghSJDxUPLgnhpywdWmD7Y7kpkMrFiflY8rNxdSMM4o6RhcGK7vu477XGyvXH1quFbGJnKahEMcNPexDiwHKbaUvCBiT8HgHqc5lEeie1wzi2GdAjKoOi4hbzy5xq4Y8Zfla13cRYHCmKjsOTKHDF61x3iElERuQVlXGANpRJJaRLMpFoAGMzwy3y7Y1ga2YcN1iCY+0uEg/CaGRxesFnDE77DlrMpU3jmvkPBfoc1YkPEVflT6rthe8GqsArlZuaNNUJVTp+pFDCDZHiotMimXJDmgaoz+x9ueNWKMdVZJ0m6VExTbeR15dH2y0NHOQcjfQLfov7hno6Tcd2dfes9D9qVUndfX2uw8/A8dNzVRHyzmExLG6vqR6YJBQNY7nM1ekuf2dlO2bIej/knVMHyi0Dq7lb2t/7sv4U3qWqz0AiyA6fxWyYktRAycITJUV+XjzmVWFXjEJmC7XOkLsBJqRq0N6CRC8qb8IPqsM8VEwCXS+8kwfaAeDyCwwiulLdQKi8/2IJARUEmk/ZenyYvztBzTZqTf1WVrgh72PwPVphzG0LM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzRQQVBLTXREbWFQaUJBN2cxS0s0VFh3L3ZINGhDWnZheHpUYm1jRCsxNm4z?=
 =?utf-8?B?OE5ZMnJrN2FtZVJXS2R0aVFUdkVIZzFTOHB4dEt0ZW4wVkdrOEhVMUJOend1?=
 =?utf-8?B?K0hBZ0w1UjU5dEVOUUdQekVFUEJNcnBuN1E3RWFxVWkyOVAxT0JhS3c4b0p4?=
 =?utf-8?B?VDRCRjgyQnB6b3I4Q2lYTUpuQXhNNXVJQmlIb3JwZWFxTHFRcldrRytKVTI2?=
 =?utf-8?B?MEpCOGcya09SOHE0M2ZGeTZHMUZFYlZjNVJHVTZ2WVlpcVNQU3ZjakVZaHNS?=
 =?utf-8?B?dmVxbVZ5OVhya2FsL3N0VVV6Nll5bkwvbGt6OSt0T3VVR0FwTjg1VVB0a0dQ?=
 =?utf-8?B?Ymx3dnd0b1I4WnNsYy85T0ZCYkU3STJMVytHc0VkcVdCWkRWcWRPZEZZejA4?=
 =?utf-8?B?RFZKNEFTYTh6eDNUUTgvRkM3Q1czWndHM3NvZzkwN3M0QlF5MlZjdmFMMlhm?=
 =?utf-8?B?ZlFUR3Y3Nyt5Z1lqT1Z0ck5zQlVLdXdmMTNIRUI0QlArdEdSNy9lY0N4bXhn?=
 =?utf-8?B?M0F6MkhBZ3dGWFFzQ1VnWW1JdC9RZ04ydWI5cnBCZnd3R2tOOGxpU1hzUGgv?=
 =?utf-8?B?ZHlrckpZODU2R3BpcXd6aWJrQml2L1dnN1pmdUlrUnZaODAxbXpVd2lKNVl3?=
 =?utf-8?B?aW5nWFFhZk1ta3pqWXZzZ2t4cFBid0RnOWVDVGs5UVJ4cWFldHhNYkhxRHpX?=
 =?utf-8?B?NTQ5ZTFGUVB6OU5aQmdaRDhIT0tJZkc5K1FlK1ZjdWVrdDU5T1hRK0NvNitP?=
 =?utf-8?B?MTlOc2N4WHFyY1gyOXBTc0VkY3ZudGwwR1J1bVdnVWJWN0JJRVFwcGpCOEtx?=
 =?utf-8?B?YXB4L0VYdjFyMmoxSjE3QjZFZ1JQeGQ1aFd3M3o0bnlMVDBYNTA3aXZ3cFhD?=
 =?utf-8?B?TE5Za0hHK1hXVmxIc2NyN2d2WVFscWtOanlqQ2l4NGZZcGsrWmtsdXFUaUZv?=
 =?utf-8?B?T0dKNlJydW9PdDNESy9hUFJQWXRndjgxOXVZV2pyTEExSGw2M3kvczVuT3Z0?=
 =?utf-8?B?c3dxckN3UUkzcVM3RWpzbEZXMkdVRjZvNWNuN2p2aWlNWHZnVXI3UzRmUW1W?=
 =?utf-8?B?RUxvbjVLMklueFZzUnBZc0ZxaFZzSXQ3NDBUWnZyR25mVHRGck9XNzJDd0li?=
 =?utf-8?B?MmFsc1NUd1I4bjYyWG1Rc3lIWDNPTmQ0SVdIV2RKQUNiM0d2a1NJemVEMjUw?=
 =?utf-8?B?Z29KRDlxT2pwVjlRKzVlYnE3ai9ZalVQelZLaFdWbmY5MlpuRS9KQTRBQkxi?=
 =?utf-8?B?VUJZUHg4aHhrQW5ZM01hWHJ2MnYvd3ZLNjBxdE9STnp4c1lnb0NUdmliYmdt?=
 =?utf-8?B?aEhDaHVPMFFPSm1SNDd4Umw4OE05Y01Zb0hSaitNVlcvdHo5cmtCSzQzcStL?=
 =?utf-8?B?bjl3Z3VnMzV3N1BjblZYd1psL2tsU1FGWFpHS0x6amJQWkFVOFRacUM4K2F2?=
 =?utf-8?B?NDA3NHBCeUxxaDA5RlJ1eEw1RUxuZ2p1NGRxeDNjM0ZwRUF5c1NseXRNNVRX?=
 =?utf-8?B?QnVWc3BDY3FUNUN6NUU1eVFhTDdpRnRKWi80V0RZYWFKYlFSZ3A4MTc3WDhH?=
 =?utf-8?B?TXFiV0R4S20zUmIvcTVGMEhGRktQOXdXSjJKQVkxcmtLWmpCVDRLVWpnOHgz?=
 =?utf-8?B?N2hJbHB4dGxqRVJ6T3dXcHNZbzU4K1hQOXVUK0RhTDhUUmlwZVdhdHpVVllZ?=
 =?utf-8?B?anNHVFNSR0lqVGY1K01RTDFFU0tmRnpJTC8yYTYwQldSeFhlN2xZUGVCQ1VB?=
 =?utf-8?B?VDhnZDZRQlBuc2Jjd3NaOUp4Y1lZeGt6dUpIZVppeUs3WEQxL0hJdm5pa1Fj?=
 =?utf-8?B?bmhLajMvMFRDS2svT3VRazg3M0ZQM1AxOFVnOElSODF4NVhKbzVMdkt4Q2FQ?=
 =?utf-8?B?NldBRFQydTVzM1g0eVFoMjZPRmcvVFBoYWg1MjBZUjMxaDdIMC9yZmdMenht?=
 =?utf-8?B?c081T25wQ2xRMFRwbjdidnlSeXBNT3gyVmd5VzRTcnBmQ2EyeU9ubHlQUHZY?=
 =?utf-8?B?dUZGODZReGNsNmR5dE5UQ0hmR3VhSkIxYzhBRzViL2xjYVZXREJQbUdSWFE1?=
 =?utf-8?B?RytqcUJqVGVrelVKUEZDaVI2VFNVTW54eUs5T05qMnZPMjdnZzE1V08wNGJr?=
 =?utf-8?B?WlQ5bFA3UGtqODhnMDN1Tk5aa0h3bEkzNCs2TGh5SWdKcTRPMlBmSzRoUUo1?=
 =?utf-8?B?UHlPOTEzbFRTRWdxZ1EwUXZHdWdtT0gybTVGMi8xVmh5SGh1SnN6OTRsVDEy?=
 =?utf-8?B?Y1RON1ZITlpUNng0OCtsNGs2cURwTEREejExbGNVSWRRWFNRc010TlNNV1di?=
 =?utf-8?B?aUpVSjl2WDhUR09vcXlRMmdydytUTHFRb1ZhWE45T05oRi8xQ1hlQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7b2fdd-373d-4250-8abe-08df22c86da4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 10:07:14.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRZfLc4MSdh5YS9o11NKChEjOtZ6r6/YMiPIU9wluTFfCzWvBTOoR55AKd175yQg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228

On 10/5/26 11:55, Fred Griffoul wrote:
> From: Fred Griffoul <fgriffo@amazon.co.uk>
> 
> iommufd and KVM write physical addresses into their own page tables.
> To do so, they must ask the exporter which frames back an offset of a
> dma-buf, whether that memory is RAM or MMIO, and whether it may be
> written.

Well filling page tables by the importer is an absolutely clear NO-GO for the DMA-buf design, we have gotten down that path already and it took us years to remove this functionality again.

The problem you are facing here is that dma_buf_mmap() doesn't work because you don't have a VMA.

I can understand the reasoning that you don't want to have a VMA, but I don't think that this is a valid justification to add complexity to DMA-buf and especially bring an approach back which we have already deprecated.

A possible solution might be Jasons patch set to directly negotiate exposing PCI BAR regions as DMA-buf, but that certainly needs more discussion.

But the approach outlined here is an absolutely clear NAK from my side.

Regards,
Christian.

> 
> Add a get_phys() operation. The importer passes an offset and a maximum
> length. The exporter reports one run: the frames that start at the
> offset, are backed and physically contiguous, and share one attribute
> word. The run never exceeds the length. The exporter may end it early,
> so importers must not assume that it is the longest possible run.
> 
> get_phys() returns -ENOENT when the byte at the offset is not backed,
> and -ENODEV when the buffer is revoked. The caller holds the
> reservation, and either pins the attachment or handles revocation. A
> reported frame stays valid until an invalidation that covers it
> returns.
> 
> The attribute word holds the memory type and a READONLY flag. Zero
> means writable RAM. Importers refuse unknown types, reserved bits and
> unknown flags, so attributes added later fail safely. Two flag bits are
> reserved: one for holes and one for confidential memory.
> 
> Convert vfio-pci, the iommufd selftest exporter and the KVM sample.
> iommufd behaves as before: it maps a buffer only when one writable run
> covers all of it.
> 
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  drivers/dma-buf/dma-buf.c               |  47 +++++++++++
>  drivers/iommu/iommufd/iommufd_private.h |   8 --
>  drivers/iommu/iommufd/iommufd_test.h    |  16 ++++
>  drivers/iommu/iommufd/pages.c           |  74 ++++-------------
>  drivers/iommu/iommufd/selftest.c        | 106 ++++++++++++++++++++----
>  drivers/vfio/pci/vfio_pci_dmabuf.c      |  58 ++++++-------
>  include/linux/dma-buf.h                 |  54 ++++++++++++
>  include/linux/vfio_pci_core.h           |   3 -
>  samples/kvm/gmem_provider.c             |  39 ++++-----
>  9 files changed, 267 insertions(+), 138 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d504c636dc29..66b85d53ed22 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1389,6 +1389,53 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
>  }
>  EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
> 
> +/**
> + * dma_buf_get_phys - describe the run that starts at an offset
> + * @attach: attachment to query
> + * @offset: first buffer byte to describe
> + * @len: maximum number of bytes to describe
> + * @phys: physical address and length of the run
> + * @attr: DMA_BUF_PHYS_ATTR_* word of the run
> + *
> + * A run is the longest stretch of backed bytes starting at @offset whose
> + * frames are physically contiguous and share one attribute word. On success
> + * *@phys starts at the byte at @offset and covers at most @len bytes; it may
> + * be shorter than the run.
> + *
> + * The dma-buf reservation must be held. The attachment must be pinned or have
> + * revocable importer operations. A frame remains valid until a covering
> + * invalidation callback returns; the exporter must invalidate a changed range
> + * before reusing its old frames.
> + *
> + * Returns:
> + *
> + * 0 on success, -ENOENT if the byte at @offset is not backed, -ENODEV if the
> + * buffer is revoked, -EOPNOTSUPP if the exporter cannot describe itself this
> + * way, or another negative error code.
> + */
> +int dma_buf_get_phys(struct dma_buf_attachment *attach, u64 offset, u64 len,
> +                    struct phys_vec *phys, u32 *attr)
> +{
> +       u64 end;
> +       int ret;
> +
> +       if (WARN_ON_ONCE(!attach || !attach->dmabuf || !phys || !attr))
> +               return -EINVAL;
> +       if (!len || check_add_overflow(offset, len, &end) ||
> +           end > attach->dmabuf->size)
> +               return -EINVAL;
> +
> +       dma_resv_assert_held(attach->dmabuf->resv);
> +       if (!attach->dmabuf->ops->get_phys)
> +               return -EOPNOTSUPP;
> +
> +       ret = attach->dmabuf->ops->get_phys(attach, offset, len, phys, attr);
> +       if (!ret && WARN_ON_ONCE(!phys->len || phys->len > len))
> +               return -EIO;
> +       return ret;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_get_phys, "DMA_BUF");
> +
>  /**
>   * DOC: cpu access
>   *
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 43fbc5bed8de..5cded585c227 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -716,8 +716,6 @@ bool iommufd_should_fail(void);
>  int __init iommufd_test_init(void);
>  void iommufd_test_exit(void);
>  bool iommufd_selftest_is_mock_dev(struct device *dev);
> -int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                    struct phys_vec *phys);
>  #else
>  static inline void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
>                                                  unsigned int ioas_id,
> @@ -739,11 +737,5 @@ static inline bool iommufd_selftest_is_mock_dev(struct device *dev)
>  {
>         return false;
>  }
> -static inline int
> -iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                struct phys_vec *phys)
> -{
> -       return -EOPNOTSUPP;
> -}
>  #endif
>  #endif
> diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
> index 52b78cbcc920..28fd9c43edc4 100644
> --- a/drivers/iommu/iommufd/iommufd_test.h
> +++ b/drivers/iommu/iommufd/iommufd_test.h
> @@ -31,6 +31,8 @@ enum {
>         IOMMU_TEST_OP_PASID_CHECK_HWPT,
>         IOMMU_TEST_OP_DMABUF_GET,
>         IOMMU_TEST_OP_DMABUF_REVOKE,
> +       IOMMU_TEST_OP_MD_CHECK_MAPPED,
> +       IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
>  };
> 
>  enum {
> @@ -193,6 +195,20 @@ struct iommu_test_cmd {
>                         __s32 dmabuf_fd;
>                         __u32 revoked;
>                 } dmabuf_revoke;
> +               struct {
> +                       /*
> +                        * 1: every page in [iova, iova+length) must be mapped;
> +                        * 0: none of them may be. Mixed is an error.
> +                        */
> +                       __u32 mapped;
> +                       __u32 __reserved;
> +                       __aligned_u64 iova;
> +                       __aligned_u64 length;
> +               } check_mapped;
> +               struct {
> +                       __aligned_u64 iova;
> +                       __aligned_u64 out_phys; /* 0 if unmapped */
> +               } iova_to_phys;
>         };
>         __u32 last;
>  };
> diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> index f9b2ae6d7e96..196d1bb330c2 100644
> --- a/drivers/iommu/iommufd/pages.c
> +++ b/drivers/iommu/iommufd/pages.c
> @@ -1463,68 +1463,12 @@ static const struct dma_buf_attach_ops iopt_dmabuf_attach_revoke_ops = {
>         .invalidate_mappings = iopt_revoke_notify,
>  };
> 
> -/*
> - * iommufd and vfio have a circular dependency. Future work for a phys
> - * based private interconnect will remove this.
> - */
> -/*
> - * Look up the exporter's phys accessor for iommufd's private-interconnect
> - * path.  Also fills *is_cpu_ram: true if the exporter's memory is normal
> - * cache-coherent RAM (needs BATCH_CPU_MEMORY / IOMMU_CACHE), false for MMIO
> - * (needs BATCH_MMIO / IOMMU_MMIO).  This will be replaced by a formal
> - * exporter op that returns phys + memory type together.
> - */
> -static int
> -sym_vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                struct phys_vec *phys, bool *is_cpu_ram)
> -{
> -       typeof(&vfio_pci_dma_buf_iommufd_map) fn;
> -       int rc;
> -
> -       rc = iommufd_test_dma_buf_iommufd_map(attachment, phys);
> -       if (rc != -EOPNOTSUPP) {
> -               *is_cpu_ram = false;    /* test hook mimics VFIO MMIO */
> -               return rc;
> -       }
> -
> -       /*
> -        * Prototype: try the sample gmem provider's dma-buf exporter.  This
> -        * mirrors the vfio-pci private-interconnect hook, and (like it) is
> -        * meant to be replaced by a formal negotiated exporter op returning
> -        * phys + memory type.  The provider serves RAM, so mark it CPU_RAM.
> -        */
> -       {
> -               extern int gmem_provider_dma_buf_iommufd_map(
> -                       struct dma_buf_attachment *, struct phys_vec *);
> -               typeof(&gmem_provider_dma_buf_iommufd_map) gfn;
> -
> -               gfn = symbol_get(gmem_provider_dma_buf_iommufd_map);
> -               if (gfn) {
> -                       rc = gfn(attachment, phys);
> -                       symbol_put(gmem_provider_dma_buf_iommufd_map);
> -                       if (rc != -EOPNOTSUPP) {
> -                               *is_cpu_ram = true;
> -                               return rc;
> -                       }
> -               }
> -       }
> -
> -       if (!IS_ENABLED(CONFIG_VFIO_PCI_DMABUF))
> -               return -EOPNOTSUPP;
> -
> -       fn = symbol_get(vfio_pci_dma_buf_iommufd_map);
> -       if (!fn)
> -               return -EOPNOTSUPP;
> -       rc = fn(attachment, phys);
> -       symbol_put(vfio_pci_dma_buf_iommufd_map);
> -       *is_cpu_ram = false;    /* VFIO PCI dma-buf carries BAR (MMIO) memory */
> -       return rc;
> -}
> -
>  static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
>                            struct dma_buf *dmabuf)
>  {
>         struct dma_buf_attachment *attach;
> +       struct phys_vec pv;
> +       u32 attr;
>         int rc;
> 
>         attach = dma_buf_dynamic_attach(dmabuf, iommufd_global_device(),
> @@ -1546,10 +1490,20 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
>         if (rc)
>                 goto err_detach;
> 
> -       rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys,
> -                                             &pages->dmabuf.is_cpu_ram);
> +       /* One backed, writable run covering the buffer: refuse the rest. */
> +       rc = dma_buf_get_phys(attach, 0, dmabuf->size, &pv, &attr);
> +       if (rc == -ENOENT)
> +               rc = -EOPNOTSUPP;
>         if (rc)
>                 goto err_unpin;
> +       if (pv.len != dmabuf->size || !dma_buf_phys_attr_known(attr) ||
> +           (attr & DMA_BUF_PHYS_ATTR_FLAGS_MASK)) {
> +               rc = -EOPNOTSUPP;
> +               goto err_unpin;
> +       }
> +       pages->dmabuf.phys = pv;
> +       pages->dmabuf.is_cpu_ram =
> +               dma_buf_phys_attr_type(attr) == DMA_BUF_PHYS_ATTR_RAM;
> 
>         dma_resv_unlock(dmabuf->resv);
> 
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index af07c642a526..0899272d1e66 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1962,32 +1962,31 @@ static void iommufd_test_dma_buf_release(struct dma_buf *dmabuf)
>         kfree(priv);
>  }
> 
> -static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
> -       .attach = iommufd_test_dma_buf_attach,
> -       .detach = iommufd_test_dma_buf_detach,
> -       .map_dma_buf = iommufd_test_dma_buf_map,
> -       .release = iommufd_test_dma_buf_release,
> -       .unmap_dma_buf = iommufd_test_dma_buf_unmap,
> -};
> -
> -int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                    struct phys_vec *phys)
> +static int iommufd_test_dma_buf_get_phys(struct dma_buf_attachment *attachment,
> +                                        u64 offset, u64 len,
> +                                        struct phys_vec *phys, u32 *attr)
>  {
>         struct iommufd_test_dma_buf *priv = attachment->dmabuf->priv;
> 
>         dma_resv_assert_held(attachment->dmabuf->resv);
> -
> -       if (attachment->dmabuf->ops != &iommufd_test_dmabuf_ops)
> -               return -EOPNOTSUPP;
> -
>         if (priv->revoked)
>                 return -ENODEV;
> 
> -       phys->paddr = virt_to_phys(priv->memory);
> -       phys->len = priv->length;
> +       phys->paddr = virt_to_phys(priv->memory) + offset;
> +       phys->len = len;
> +       *attr = DMA_BUF_PHYS_ATTR_MMIO;
>         return 0;
>  }
> 
> +static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
> +       .attach = iommufd_test_dma_buf_attach,
> +       .detach = iommufd_test_dma_buf_detach,
> +       .map_dma_buf = iommufd_test_dma_buf_map,
> +       .release = iommufd_test_dma_buf_release,
> +       .unmap_dma_buf = iommufd_test_dma_buf_unmap,
> +       .get_phys = iommufd_test_dma_buf_get_phys,
> +};
> +
>  static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
>                                    unsigned int open_flags,
>                                    size_t len)
> @@ -2031,6 +2030,73 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
>         return rc;
>  }
> 
> +/*
> + * Report the physical address the mock domain resolves @iova to, or 0 if
> + * it is unmapped.  Lets a test check that two IOVAs share one frame (a
> + * scratch substitution) without knowing the frame in advance.
> + */
> +static int iommufd_test_md_iova_to_phys(struct iommufd_ucmd *ucmd,
> +                                       unsigned int mockpt_id,
> +                                       unsigned long iova)
> +{
> +       struct iommu_test_cmd *cmd = ucmd->cmd;
> +       struct iommufd_hw_pagetable *hwpt;
> +       struct mock_iommu_domain *mock;
> +       unsigned int page_size;
> +       int rc;
> +
> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
> +       if (IS_ERR(hwpt))
> +               return PTR_ERR(hwpt);
> +
> +       page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
> +       if (iova % page_size) {
> +               rc = -EINVAL;
> +               goto out_put;
> +       }
> +       cmd->iova_to_phys.out_phys =
> +               mock->domain.ops->iova_to_phys(&mock->domain, iova);
> +       rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_put:
> +       iommufd_put_object(ucmd->ictx, &hwpt->obj);
> +       return rc;
> +}
> +
> +static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
> +                                       unsigned int mockpt_id,
> +                                       unsigned long iova, size_t length,
> +                                       bool mapped)
> +{
> +       struct iommufd_hw_pagetable *hwpt;
> +       struct mock_iommu_domain *mock;
> +       unsigned int page_size;
> +       int rc = 0;
> +
> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
> +       if (IS_ERR(hwpt))
> +               return PTR_ERR(hwpt);
> +
> +       page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
> +       if (iova % page_size || length % page_size || !length) {
> +               rc = -EINVAL;
> +               goto out_put;
> +       }
> +
> +       for (; length; length -= page_size, iova += page_size) {
> +               bool is_mapped =
> +                       mock->domain.ops->iova_to_phys(&mock->domain, iova) != 0;
> +
> +               if (is_mapped != mapped) {
> +                       rc = -ENOENT;
> +                       goto out_put;
> +               }
> +       }
> +
> +out_put:
> +       iommufd_put_object(ucmd->ictx, &hwpt->obj);
> +       return rc;
> +}
> +
>  static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
>                                       bool revoked)
>  {
> @@ -2143,6 +2209,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
>                 return iommufd_test_dmabuf_revoke(ucmd,
>                                                   cmd->dmabuf_revoke.dmabuf_fd,
>                                                   cmd->dmabuf_revoke.revoked);
> +       case IOMMU_TEST_OP_MD_CHECK_MAPPED:
> +               return iommufd_test_md_check_mapped(ucmd, cmd->id,
> +                                                   cmd->check_mapped.iova,
> +                                                   cmd->check_mapped.length,
> +                                                   cmd->check_mapped.mapped);
> +       case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
> +               return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
> +                                                   cmd->iova_to_phys.iova);
>         default:
>                 return -EOPNOTSUPP;
>         }
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> index c16f460c01d6..381c3d338e8c 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> @@ -99,46 +99,46 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
>         kfree(priv);
>  }
> 
> -static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> -       .attach = vfio_pci_dma_buf_attach,
> -       .map_dma_buf = vfio_pci_dma_buf_map,
> -       .unmap_dma_buf = vfio_pci_dma_buf_unmap,
> -       .release = vfio_pci_dma_buf_release,
> -};
> -
>  /*
> - * This is a temporary "private interconnect" between VFIO DMABUF and iommufd.
> - * It allows the two co-operating drivers to exchange the physical address of
> - * the BAR. This is to be replaced with a formal DMABUF system for negotiated
> - * interconnect types.
> + * Report the BAR's physical range for importers which program it into their own
> + * translation tables, such as iommufd. A BAR is MMIO, never cache-coherent RAM.
>   *
> - * If this function succeeds the following are true:
> - *  - There is one physical range and it is pointing to MMIO
> - *  - When move_notify is called it means revoke, not move, vfio_dma_buf_map
> - *    will fail if it is currently revoked
> + * When move_notify is called it means revoke, not move, so this fails while
> + * revoked and vfio_dma_buf_map() does the same.
>   */
> -int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                struct phys_vec *phys)
> +static int vfio_pci_dma_buf_get_phys(struct dma_buf_attachment *attachment,
> +                                    u64 offset, u64 len,
> +                                    struct phys_vec *phys, u32 *attr)
>  {
> -       struct vfio_pci_dma_buf *priv;
> +       struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> +       u32 i;
> 
>         dma_resv_assert_held(attachment->dmabuf->resv);
> -
> -       if (attachment->dmabuf->ops != &vfio_pci_dmabuf_ops)
> -               return -EOPNOTSUPP;
> -
> -       priv = attachment->dmabuf->priv;
>         if (priv->revoked)
>                 return -ENODEV;
> 
> -       /* More than one range to iommufd will require proper DMABUF support */
> -       if (priv->nr_ranges != 1)
> -               return -EOPNOTSUPP;
> -
> -       *phys = priv->phys_vec[0];
> +       /* Report from @offset to the end of the BAR range containing it. */
> +       for (i = 0; i < priv->nr_ranges; i++) {
> +               if (offset < priv->phys_vec[i].len)
> +                       break;
> +               offset -= priv->phys_vec[i].len;
> +       }
> +       if (i == priv->nr_ranges)
> +               return -EINVAL;
> +       phys->paddr = priv->phys_vec[i].paddr + offset;
> +       phys->len = min_t(u64, priv->phys_vec[i].len - offset, len);
> +       *attr = DMA_BUF_PHYS_ATTR_MMIO;
>         return 0;
>  }
> -EXPORT_SYMBOL_FOR_MODULES(vfio_pci_dma_buf_iommufd_map, "iommufd");
> +
> +static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> +       .attach = vfio_pci_dma_buf_attach,
> +       .map_dma_buf = vfio_pci_dma_buf_map,
> +       .unmap_dma_buf = vfio_pci_dma_buf_unmap,
> +       .release = vfio_pci_dma_buf_release,
> +       .get_phys = vfio_pci_dma_buf_get_phys,
> +};
> +
> 
>  int vfio_pci_core_fill_phys_vec(struct phys_vec *phys_vec,
>                                 struct vfio_region_dma_range *dma_ranges,
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d1203da56fc5..b223962e20c2 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -13,6 +13,7 @@
>  #ifndef __DMA_BUF_H__
>  #define __DMA_BUF_H__
> 
> +#include <linux/bitfield.h>
>  #include <linux/iosys-map.h>
>  #include <linux/file.h>
>  #include <linux/err.h>
> @@ -23,6 +24,7 @@
>  #include <linux/dma-fence.h>
>  #include <linux/wait.h>
>  #include <linux/pci-p2pdma.h>
> +#include <linux/types.h>
> 
>  struct device;
>  struct dma_buf;
> @@ -182,6 +184,29 @@ struct dma_buf_ops {
>                               struct sg_table *,
>                               enum dma_data_direction);
> 
> +       /**
> +        * @get_phys:
> +        *
> +        * Describe the run that starts at @offset, for an importer that
> +        * programs its own translation tables. A run is the longest stretch
> +        * of backed bytes whose frames are physically contiguous and share
> +        * one attribute word. Report it in *@phys, starting at the byte at
> +        * @offset and clipped at @offset + @len, with its DMA_BUF_PHYS_ATTR_*
> +        * word in *@attr. The exporter may stop before the end of the run;
> +        * importers must not assume the reported run is maximal.
> +        *
> +        * Return 0 on success, -ENOENT if the byte at @offset is not backed,
> +        * -ENODEV if the buffer is revoked, or another negative error. Do not
> +        * wait for memory to become available.
> +        *
> +        * The dma-buf reservation is held. The attachment must be pinned or
> +        * have revocable importer operations. A reported frame remains valid
> +        * until a covering invalidation callback returns; an exporter must
> +        * invalidate every change before reusing an old frame.
> +        */
> +       int (*get_phys)(struct dma_buf_attachment *attach, u64 offset, u64 len,
> +                       struct phys_vec *phys, u32 *attr);
> +
>         /* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
>          * if the call would block.
>          */
> @@ -576,6 +601,35 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>                                 enum dma_data_direction);
>  void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
>  bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
> +/* bits 0-7: memory type (a value, not flags) */
> +#define DMA_BUF_PHYS_ATTR_TYPE_MASK    GENMASK(7, 0)
> +#define DMA_BUF_PHYS_ATTR_RAM          0x00    /* cache-coherent system RAM */
> +#define DMA_BUF_PHYS_ATTR_MMIO         0x01    /* device MMIO, uncached */
> +/* bits 8-15: reserved for a second value field; must be zero */
> +#define DMA_BUF_PHYS_ATTR_RSVD_MASK    GENMASK(15, 8)
> +/* bits 16-31: flags; undefined bits must be zero */
> +#define DMA_BUF_PHYS_ATTR_READONLY     BIT(16)
> +/* BIT(17): reserved (hole, for importers that walk across gaps) */
> +/* BIT(18): reserved (private, for confidential computing) */
> +#define DMA_BUF_PHYS_ATTR_FLAGS_MASK   (DMA_BUF_PHYS_ATTR_READONLY)
> +
> +static inline u32 dma_buf_phys_attr_type(u32 attrs)
> +{
> +       return FIELD_GET(DMA_BUF_PHYS_ATTR_TYPE_MASK, attrs);
> +}
> +
> +static inline bool dma_buf_phys_attr_known(u32 attrs)
> +{
> +       return dma_buf_phys_attr_type(attrs) <= DMA_BUF_PHYS_ATTR_MMIO &&
> +              !(attrs & DMA_BUF_PHYS_ATTR_RSVD_MASK) &&
> +              !(attrs & ~(DMA_BUF_PHYS_ATTR_TYPE_MASK |
> +                         DMA_BUF_PHYS_ATTR_RSVD_MASK |
> +                         DMA_BUF_PHYS_ATTR_FLAGS_MASK));
> +}
> +
> +int dma_buf_get_phys(struct dma_buf_attachment *attach, u64 offset, u64 len,
> +                    struct phys_vec *phys, u32 *attr);
> +
>  int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
>                              enum dma_data_direction dir);
>  int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 9a1674c152aa..2a1d13abdb0c 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -257,7 +257,4 @@ vfio_pci_core_get_iomap(struct vfio_pci_core_device *vdev, unsigned int bar)
>         return vdev->barmap[bar];
>  }
> 
> -int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
> -                                struct phys_vec *phys);
> -
>  #endif /* VFIO_PCI_CORE_H */
> diff --git a/samples/kvm/gmem_provider.c b/samples/kvm/gmem_provider.c
> index 75197c088762..b6824fe5d228 100644
> --- a/samples/kvm/gmem_provider.c
> +++ b/samples/kvm/gmem_provider.c
> @@ -487,35 +487,30 @@ static void gmem_dma_buf_release(struct dma_buf *dmabuf)
>         kfree(priv);
>  }
> 
> -static const struct dma_buf_ops gmem_dma_buf_ops = {
> -       .attach         = gmem_dma_buf_attach,
> -       .map_dma_buf    = gmem_dma_buf_map,
> -       .unmap_dma_buf  = gmem_dma_buf_unmap,
> -       .release        = gmem_dma_buf_release,
> -};
> -
> -/*
> - * Private interconnect for iommufd (mirrors vfio_pci_dma_buf_iommufd_map).
> - * Returns the single contiguous phys range for the exported region so iommufd
> - * can program the IOMMU directly, bypassing the DMA API.
> - */
> -int gmem_provider_dma_buf_iommufd_map(struct dma_buf_attachment *attach,
> -                                     struct phys_vec *phys);
> -int gmem_provider_dma_buf_iommufd_map(struct dma_buf_attachment *attach,
> -                                     struct phys_vec *phys)
> +/* Report this flat sample region through the generic dma-buf operation. */
> +static int gmem_dma_buf_get_phys(struct dma_buf_attachment *attach,
> +                                u64 offset, u64 len,
> +                                struct phys_vec *phys, u32 *attr)
>  {
> -       struct gmem_dmabuf *priv;
> +       struct gmem_dmabuf *priv = attach->dmabuf->priv;
> 
>         dma_resv_assert_held(attach->dmabuf->resv);
> -       if (attach->dmabuf->ops != &gmem_dma_buf_ops)
> -               return -EOPNOTSUPP;
> -       priv = attach->dmabuf->priv;
>         if (priv->revoked)
>                 return -ENODEV;
> -       *phys = priv->phys;
> +
> +       phys->paddr = priv->phys.paddr + offset;
> +       phys->len = len;
> +       *attr = DMA_BUF_PHYS_ATTR_RAM;
>         return 0;
>  }
> -EXPORT_SYMBOL_FOR_MODULES(gmem_provider_dma_buf_iommufd_map, "iommufd");
> +
> +static const struct dma_buf_ops gmem_dma_buf_ops = {
> +       .attach         = gmem_dma_buf_attach,
> +       .map_dma_buf    = gmem_dma_buf_map,
> +       .unmap_dma_buf  = gmem_dma_buf_unmap,
> +       .release        = gmem_dma_buf_release,
> +       .get_phys       = gmem_dma_buf_get_phys,
> +};
> 
>  /* Called with info->dmabufs_lock held on the revoke path. */
>  static void gmem_dma_buf_revoke_all(struct gmem_info *info)
> --
> 2.47.3
> 

