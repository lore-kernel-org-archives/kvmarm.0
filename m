Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E13A3B6C02;
	Mon, 27 Apr 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297124; cv=fail; b=SmzqigHPFEbRaKVYk7eNp89YQ/2S9dwmnChu/BsYypXuKVU+rpxlxh/W7so7CdsfLwwzPhvge1zmd9xNmiYaiLx3NRID0JYivM9/rzZNV2ETgdp3mtmsEdVG+ek7Zsj2L5/4JJA0DVyO63wkVZYXANcTcw2z145WQzvT6R8CR+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297124; c=relaxed/simple;
	bh=ztL3haqjeaBNRP6uj5kmEc27/cycK7QR7WKxKIAXshQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iX4jBhAliAQUKhFu1Ci936X0ju9XJ2R/3l7qNKGg/eGKv4gzqkCm4y6v8eFCm9ni2IqP43EYc2Gb9N/M6qeYuD5053LOsgCdzZIahmowWAIcx7zRx7TGH2WoVUVOnvHlbt8ok6fzZrXMbusF5gu8iJ9Y1GoUlul3z7GTOndxG2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Snf70S7R; arc=fail smtp.client-ip=52.101.62.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Snf70S7R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTvJKWFhgFv4olQs/mS96cMrXmGSEqtr8Y4XY5zj7p4cMtZXZBMjB11/I438NNRXNtXCisLqCBM1HGvldNL4XAYgfzTFX4j0ccI8R4zDDlKiZ4GrklkOtQc+A5iZluWxFM8OMTCEEcM/TfiY4GNfAZ1hFhGzbfoj1fTj6vMfTfqhFF8QCCCuyg6UNr5B/Wy4cJqSGIr61V7eXDq3rAb2JfzS41VVSQv29pjlA3ja8zN6TC9eLrglyf/r7+TwfuajWMA0ecst9VzbxDF1nfCbfFJpGcAvhcSakKvuB67LpibZIPhK7goTgYlRIvRaQMzAGHcYuHzd8O4qC3wv8tdIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdoF8XoZW86Ck2I+94FE3TwzzF1GaJCnJrn/wWDvjdw=;
 b=gc+Y7jb1FLT6+VlkAkoB4EjxmTSOR7ch5lWIBkNat/3rOQuLyXLIJyrCTgn5qxN9+t+7j1ESFcuujuuthh0rahRSES//W1+yxRwFzHxstNuHmpRIYLlAqzRVamPQYn/rKtQJDTxlVZWeAtph0kDU1lXXlpUaech8nIyUsceYkbN4NF0w+GcvPq18QBND9d+xg5DXHqQBFirxSzrfFPuYBY3PKfLovV7ZUQ1GDOul34hBCGIPw6b/T15qC1BnsdpNI6cqIHxkKS/n9ynhmfUYZR/bgHBQHRr66HtOODNiUFk1kh++WHMY0DupfsLXIOmAX7HK0uko1mYVSh1OKXID3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdoF8XoZW86Ck2I+94FE3TwzzF1GaJCnJrn/wWDvjdw=;
 b=Snf70S7RCcJZoo8JJNIAbwfsFYj8uXUf9UpK4dyUgDbpzGVp0euMLVZypCpogk4YZFjcDb3CnFaf9aB6wrJlt0wNxhmcslQM58amoxf16w42cNXjdg1npqpLcINBuThP/kwFkYiGGm/DEYzmEJ/FowyDMeWw6lVvo+8RIU04CnRz6RDtO6WZ9SDyqhL8cpTS0mefzFeJLQV5Fjd82oIPuLHPPmjaYq4IOKpKAq4zob/iZ5RikW4l4O0Gv+AIiiQQH4jNtu3iRRHrvVcDeNS6NbOqJorlOh4dZhCHpOW7fP3F0GsjSeko1gE8pZykSUfRxfVarykID2WPKsNongWeMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9576.namprd12.prod.outlook.com (2603:10b6:610:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.13; Mon, 27 Apr
 2026 13:38:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 13:38:30 +0000
Date: Mon, 27 Apr 2026 10:38:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
Message-ID: <20260427133829.GA792646@nvidia.com>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-3-aneesh.kumar@kernel.org>
 <86zf2ozrb8.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf2ozrb8.wl-maz@kernel.org>
X-ClientProxiedBy: YT3PR01CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9576:EE_
X-MS-Office365-Filtering-Correlation-Id: f8356d3b-be6e-47e8-d918-08dea46244ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	O1lxIrjM2M08yY1qUwquAGADcoHCDr8mViqgbj1BdlpSLTLXzXKV54xrLkd1/wO0bSGZ6GsLwq/tTLkyUwObeoSRUqdqsKuwIf916hPdH8hFG0+zzp4mWMCQ0DuEq+KY0cWjkgiQ5vfLLOcorBvPNqSTjkqNScPuH71iblPsmY0cLqdNkhl+ua/Egco+0LTC6zJdtQcpYdQpT3OYGOpud4soQ5QA+sTpXiDIxUssUyqwY2JghmxhGelJpsXTQoMBl+iPNOwblSv5476D5twUsjVwvwCnIzPOnjndMAzKO/5mq3VYiyl1se5KFllAGTjMHl54aO6jxM9n3QJ9yzpG16xH+JiQN4zPg6gLXvnGusq7CBouSLI1zzRDS9kRWTXHzyAJWdKMWYFdt6ANExGph5tkmCiVl62jFkTSkZjSOWpkrdG17VjLXZW1q8iv0FPaWKWgk2VXy3wvfZGSgeQxHRBDo4Oxox2buFGNMerSG89eR4ljzATbCotI7NEfDPOhrmLfJTnjXYT/e9lElhNQtvYRtgGo9Mrbg6pGehrFs6bfVq/xAYYDIX9U1fCsP79uXuZvPVDjhknrbcuxXeo1NoojF0xeOsawF/Bce5q9KmeuZqL8+saa9CrU5UcLUpvjwuBpmEy1+ubaBXgecurIb0zS5xUjWkNEqZXyhEiaASSlA0C3rJ8rT7MRh6j7oeLvRZgPeEcdo4Iv+c0iBj55MGx2VQVxQdoiwGZMbo24tfs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/LPG1ZGoeKGC1chfvQrdJOGTnecvqn01DxE3m+uVmtGzK4yClxBlgi+sk8g0?=
 =?us-ascii?Q?J1MoOirGWHLlEcfuwEmbwU05gH02YgCA130niQTiZkKPjEhaqW7Gkgv6Jc8h?=
 =?us-ascii?Q?X9p3FQrmTejcHsnaNr/BoTXyEk98HaxgAyr2luk55xmpvXGZBnFoSk0zXwXF?=
 =?us-ascii?Q?gi1FJ5+kG0gYqNhLHe2O4PIe9anroxKKERpf6jyVx4h8eAjBqV22X+c3hUPw?=
 =?us-ascii?Q?1N1vVCrflB7PfRcolxydIDmhr4FhsTTqLjG1PkwXLaysAHpKJ6PlpYncHQZ6?=
 =?us-ascii?Q?F4A9f+k8vI68WIl90QbYO2ZgqJRE+JO53YfToB28MoZELXEZtBjqTs0uq940?=
 =?us-ascii?Q?HhLKuE1T/wJ8Xy1F2NUOWRsT8vq2r2aVsy4p4xDDpJ396qrtRYpPEAVjdqw/?=
 =?us-ascii?Q?zy2H8wdKTjE/4ww65aJvb9cSK1L7G5yfxSqyZQKw4/4/Vd9fkxegmZZuDv8R?=
 =?us-ascii?Q?qqYkqaS1RXQd5xJPj561Q2nWLzvEFOJaKAFcjKjXWlPKXGje/3KZCCZOzTwb?=
 =?us-ascii?Q?eGkmisroYliLxFq8vL3MUtVUcHBi/gB7o1OiUEzVh7adnyZlS+R5pYvQhC9R?=
 =?us-ascii?Q?LCF4JlrojpryHqh20vU/zzH3VZcaFonA/fHAh+AsMpyYqhlr0xAz8vOxYDcq?=
 =?us-ascii?Q?iEGp9evHhniM2jFe/W7NxfdHM7HfsiEFG5nVslHZVmBLJTVCqoUytwDIpC40?=
 =?us-ascii?Q?kfDde742U9t+oDasbcmHP/iKKGFq2ZF657i719hHukpmfwJxEXFeKnUPcGNV?=
 =?us-ascii?Q?Tg4qV/+gOCktG4ZdCvP88fHWvs46Fw4tx1UZYZQ0AslhHUyvZ/OIBny1Rs7V?=
 =?us-ascii?Q?SN7Hh0N4sE5KDk1Pdf+cWV0LHLjFDP2Z1sS8xN44IbdgAhZArO9KVrwq0fJi?=
 =?us-ascii?Q?ov3rk51+Rl8Yfi4hWYMTaXaSn+xfwFchDj8eJaH5/o9vIxLTyfPPvJ05KgXb?=
 =?us-ascii?Q?xVBt+7kd29+z2qDM/JyQj7KoM0YISOxoIcQ/+9pWo36W7jEJq91JQkbWBdLK?=
 =?us-ascii?Q?JJBlT2DU88Rhdh2ujpGZuLf6l7N6vAuAiX8v+o8iKaYPJLWBlZLMqaBu47ck?=
 =?us-ascii?Q?jEHCmQpZkGI7phf3WJn9p+JUKbEu7xNjBW17WZvKBoUYG1TEboy2RmGCaId9?=
 =?us-ascii?Q?M0L1MH9G1gqqr02u+KdR1Inky7wB35T6dmDq7xqLRPrm6Wpn5QODoS5VYtob?=
 =?us-ascii?Q?O8MFggpMhoezehU3TayBFduc0L4vCMzpkzZ6q9h3pupAebLHjmIM27bRN/xa?=
 =?us-ascii?Q?HNCfmuroISBsLYLFfLHc23Cpdqxrc9WkjeHDYNqXuQ4p3b2FDIF+O83bDiAY?=
 =?us-ascii?Q?9CamHkiuCvXt6Fr/w3/Do4ow0UDPIP+52ayERkzQpMmXvl0Be4XVAo4M1nXj?=
 =?us-ascii?Q?Ro1aEcBrxga5bfb3gpwf8hI9YmQ7z4MzA5g9EFKC0Hvcomijp+nDi1GbatMi?=
 =?us-ascii?Q?MIIafIu3uocGp6dVomqYDdtzshzXCKjbSwEAWWFsobf4yyDWGYDT9W+qY/u1?=
 =?us-ascii?Q?sm9Wc6WKt5pOY03T9ZnM/Sq+i0vwsegz5ULHI6CAfOGRXBU9cj4BhUanAVGG?=
 =?us-ascii?Q?qClFJHP56c2cWGjngvHv8Zt7Ie99LBxezDGeijxUS+V2bIQciEmZ8vNAa0zE?=
 =?us-ascii?Q?2sRF1Keg2GN/uS8R2mqWJZDyijVndt+1IqKfeMJEMTYylg1QZ5b8TRtXQ3zJ?=
 =?us-ascii?Q?533OYnoQAduAzK3FXJnJgiKb/xfjtG2JTdDYfAVSyAgen7jm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8356d3b-be6e-47e8-d918-08dea46244ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 13:38:30.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxolYM3rB+EMahMAV1lcf9+re+U1E4JZ9HyWofky4s5dOeI9+6Eo3Twurex7KigI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9576

On Mon, Apr 27, 2026 at 10:27:23AM +0100, Marc Zyngier wrote:
> > With CCA, although Stage-2 mappings managed by the RMM still operate at a
> > 4K granularity, shared pages must nonetheless be aligned to the
> > host-managed page size and sized as whole host pages to avoid the issues
> > described above.
> 
> I thought that was being fixed, and that there was now a strong
> guarantee that RMM and host are aligned on the page size.

Yes, the RMM and host are supposed to be aligned on page size, but
this means the guest now has this mem_decrypt_granule_size() value
that it has to deal with, and it won't always be 4k.

The spec introduction of RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT is
fixing a defect in earlier RMM specs that just assumed it was always
4k.

AFAIK this is unfixable in ARM's architecture..

> Even more, S2 is totally irrelevant here. The only thing that
> matters is the host page size vs the guest page size. Nothing else.

Yeah

Or rather more specifically the RMM now has
RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT which says exactly the minimum
supported shared/private conversion granule and the VM must obey it.

It doesn't actually matter *WHY* the RMM chooses a size, whatever it
is the guest must follow it.

It would probably be helpful to focus on this a little more, as really
this series is implementing a new RMM feature. It is good to explain
why this feature was added to RMM in the cover letter, but I would
focus the patch commentary on explaining the process of introducing
mem_decrypt_granule_size()

Jason
