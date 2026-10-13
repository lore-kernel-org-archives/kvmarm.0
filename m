Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28AE4F6481;
	Tue, 13 Oct 2026 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893652; cv=fail; b=sx7Xb+ev8Vagmz/cmvUF9QUlL+SKR9AKZhcgajsG7Az5BwOU7praodPQxObPUTVZi+j3WOQBowM+wRY76FDh48+S7YpZ1zRE/EGFlS/PyTwJLdbUOuIIY2NT8L/Fg39gKvdk0JPxdvOyccqRqhZ2VNKCHB+d1/1Q8ZKnANCAhj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893652; c=relaxed/simple;
	bh=Fj61HSDi7dH4ji6dCfH/4t1BzBCSWTHDA/GYdv+thb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gf2W8HFxial2ZkU/AvYXUBfaDXZdy3BStn7VxKHpm6NkE5ca3bZ+XZDHz/FffAGbbIy1LSaQ71VU522q6HYBfuUXOF5eFmvtRJlMEZuwl4NSc0t5mDZEagTYQdMS/IDmWByHy7DgesgTMaW9ONJmugQsBUYhf9X6yq1HbIeWTxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LlHKGM3l; arc=fail smtp.client-ip=40.93.196.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LlHKGM3l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlnJ4/L21XMljEvQvnJpTOxHrgoQab+IWZufirYhVUrf+0orUQ9QaUyPtmXZ7EjUNUE4BL5NYzYjzQhJXGPXJoTA+EI2wWTaphl5TRZHIgxLlSZTj7zyoLVgTMcD/oT/iuQ/1HGN33E2GSj7Hri6Xx760T7vQ6Du3fRzc9Aqcw4w5n6rLa3NZThHl6ZYBAKMylCb/3NFX+L1404IZ5pnv6hRIT8Zj4Y5iXtuQD5aE2QOD0X9lRZLfozNzM66brEJheJEDjZiytWrAKjztrLyoUIsOm5MFDkP0stjszZb5+6IWlemzU9ZRsPhbRLljxCM3Q7vdUTBxnZdHliOIvftfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZXVFUreUQYzKlk0D3KeTjavvLtHdXZFDqcCrAnC3+8=;
 b=mPNMFfHExAkzqkmM08rAwkHM3hMrSMaO1t+tWy6LU479FwTXdXQWi0Zh4Y4okoB7oVykz1xPqPUdqHl4heV0mzciyx9LTEiD0n5XQ+kDr17q15/MpLJTKb0am03glUhN33W84X38npdDsp3unVxL+ilJ190zp+WUhPBm1rhm/9NUn4dWLIwefJntBTPl36A4PTzS4l4BINh+gfNVRt+KVRgJBpEbW+wdjRRQGRmOR+9Ebx76mI9u49VVV6OEdguCpi8VhdZet5FOIrrH1wJZGGLSQj3WAA0NpU+d9Eg8TKMmqUYpbnB4THG+LV+DCKxda4SLVeNDBjfEp7gP4N17pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZXVFUreUQYzKlk0D3KeTjavvLtHdXZFDqcCrAnC3+8=;
 b=LlHKGM3ljva9+QOSUi/iR3DZ9m8XnYpD65+yIvU6NQ7c3Bt/r+lIH/LI6nS/tmsgyDrJPYPW9U2tkeL5Htbjz565vLpFrL4zO9tqmwzY1skBVwzeVqpIiY6BW0vKaLI42lAN0oZ0pDRdf9UnTfWI50Lh9JoHPIDgUNc3J1fAB1QDzi8dx9vE4Lwlc+xabFr176Qu84LvA8mBYb89lw830tbHjsFYi6/Xp1uLTsTAKY0VNQSA2I05ZGUrYF6lQyXWQbd8DtnuTHziWjtJNwYMrCt7lSUOzgSIO9/rcLITpcfzy1Ne7NbTjt2yWMMklulJeP4I+fo4OM+SlJRO5brgZg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH5PR12MB953872.namprd12.prod.outlook.com
 (2603:10b6:510:501::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Tue, 13 Oct
 2026 12:14:07 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 12:14:07 +0000
Date: Tue, 13 Oct 2026 09:14:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, dri-devel@lists.freedesktop.org,
	media-ci@linuxtv.org, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v8 01/14] mm: Add an allocator for CoCo shared memory
Message-ID: <20261013121405.GQ13920@nvidia.com>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-2-aneesh.kumar@kernel.org>
 <20260924101907.5C6261F000FF@smtp.kernel.org>
 <yq5a1pai4tlc.fsf@kernel.org>
 <20260924182643.GC9354@nvidia.com>
 <yq5a33uary4z.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a33uary4z.fsf@kernel.org>
X-ClientProxiedBy: MN2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:208:23b::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH5PR12MB953872:EE_
X-MS-Office365-Filtering-Correlation-Id: 833b4a40-8d56-44b3-eb43-08df29237ac7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	YIQpo322jGjSbpeHCph3yURzEltYUJUrR/iL+BsLgG1e1Scf9SkVK9keGw1M1xCC+G9FWgkCpkV7Dh3K9Knfk9+epM9ltBCdeU6sggsINF2YcSq/3j2wyRXBjH1FH3vTEt8JfvyV2ilpcV4OiJ8KwAz/8zSkGojndYQuXFwi3ZUD4stxgGxfUgBpTdrK7dTK9aOFshEBhAJokrQfni1JUL1X6yLEUa4GaYxaLKmLGrkm05z38ogNzuKnjOhyMm1YiXGX7BE6o3lXsoXlVD29mJNbxUQFRoyo9jgvc9MIeTGIMR5nkNp+GdWuBQ5zz9IS4NcgO16+2IMkDAvUl7arZ8XoCo6LXnBBeaAJYlm9/iwNjUCVIBj13vxkIQwfeHqRBuQdmQGHVQA5+ZT1rW/f06KMoHPGyZFDmOizXaGoVXrfDpSmcpiL1Hc1VCMfieq5eWhFaN4Wg8ugtMXSqzfpfHsRcBDvwSj4Z3dpcXU3G2beonZS9eff66LtD/o33HjJB902E5Vp4f/3SgUwtSy9w9N8IN79oSNrad9UVTk/Guaw3QFtQPrFiTvJLNOn9U7FvYTE60oXKhqXHWBRs/Awobvdnbno1SehWCeealgcu6QfZ8IxRpICXNo5FnePVJgJgytG4sBF7/MjCftTeH1I7dZ9PHQoX8rN3hfHOBSR2DU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AnPSuYABapPcJuiildimaIrOM2HBOEf+xnUcA2Gz99eXLBKDHWQeRvHfXvgf?=
 =?us-ascii?Q?/1QnJ7euQpC9FoQCxxBre1nqfkoB6Yqhn+2ys6RRuW2+tsPQ7GEqcFdN4u5A?=
 =?us-ascii?Q?+qXx5uWifNLGMLcs1aLzTkfy/7vuoW/P3QfBjv2sXmRLUxM69l125Dx1hHHZ?=
 =?us-ascii?Q?np+C0Cc8VesNFxjdX5Wk839R3pBXbyqYuA3yn1Q+h4Z5rPklFsbUu4JNphUe?=
 =?us-ascii?Q?Mi2teKBvwpF3oFCAtkzUSoJY3AZCqo43VeShDsVcO1jop8ajQCAMa4bPhMOd?=
 =?us-ascii?Q?8XeY9I/p7Y7wutIOfSOJpjFt2Nd3yeUx6zkRNv+U620iXCLlpYamMSlhKQ+N?=
 =?us-ascii?Q?XYuYT+Ua+ccBPEn5lzmdfNlvJ8OWnQ+8LZVyjbc2iyNrU6N7ecRX9L+teLqd?=
 =?us-ascii?Q?sNQBr66u/osG7z58KVz0n4xmhHhf5D6WUYOWW6syg/qbb3vkUR3Pv1QqZ+GS?=
 =?us-ascii?Q?CeH3OEXz1yibxiYKjMh4PVqGydQridbu8XOF/n1Lj4mtOyRzNoImsty4vrPC?=
 =?us-ascii?Q?V/WcbLDl3QwsxKkuJfT6DaArrMbojb3JwUSidsxUltdyNFYboc/Dtvb0LbRz?=
 =?us-ascii?Q?Do7QKn35XlUt3dIP4r0fxhiQJqE4qoqozi6ZDd+L8S+YzGhEv5+MCq+/e+BX?=
 =?us-ascii?Q?GyRH3l5CuIxd28681nSvp6Eq3IAOoL/phgxRIW0aqlGTZcgyT98hXoM+iqnp?=
 =?us-ascii?Q?dAmpzKtXDk0lwQ2LLBUx+ekD0WolKb3sVzuvMqtya7duHTs2kxAW65g4sp1y?=
 =?us-ascii?Q?g6+cm+0s/tX+XODQ14f7uLNgWHmHuPQfzUHqmFuzcM0F8rHQuhCV4AJ/QGX0?=
 =?us-ascii?Q?Ut7Yyc5QJ1P70d+LoZntfR02N9G4JbqEAmBo8ptjBLErPUBXtX/dBtI9O+nZ?=
 =?us-ascii?Q?YiMpCeQikVdctEJjXZSUHNQDB68UcmYwJW5JxRYPrSkeBuSa70Myy8c+HWNO?=
 =?us-ascii?Q?VumuamPvDDQ7gHR9ZXCXMIH/tqHI6pwY1oeN4SSyr6WB+Qw3ut7dcpsUaN2g?=
 =?us-ascii?Q?CH3tAkdq5SP8FvXz1MZcEQaHlwA8vW+GaTbpEpdNT0POtlloKsmTUf+BliMq?=
 =?us-ascii?Q?Rac4wYtVSIU3wcJ029C2pi5KF3BHA+LZOakZZQh0lDYCxe3CM3od+rf42c5K?=
 =?us-ascii?Q?Y4L5s0DDoDw49Eqb5o+s24bYMzzrc+DQ1fFZGmy5hfP0iIYidIIuSHJK3VGL?=
 =?us-ascii?Q?VBk6YyPHqAiDZGLrAja67DqXaDUGjHBBXOs7MHnra2mJJbBO0CvSxVHyQi/V?=
 =?us-ascii?Q?mjafBCoFYnfchi3Oo6axRH/oxqJoqiPWhEFJPnoYPQ3yU1lImr8P8yyIiAPI?=
 =?us-ascii?Q?FJWHRahokPCF09jhXv9moRh6vgbBh/JOSiPclbMiQWBfV+SUW+cMLCJk6vkq?=
 =?us-ascii?Q?WYCEQf47mdOZUF4qdCboxj/alxYMHwOvoMnbompdyxWxVyK9hKg0a+FLrzpp?=
 =?us-ascii?Q?41SIMnJqgHSdEG9e6gprSxCpbnqGXbF/nZ83Tw95EH/2ImJFlXidVJ5NJUwH?=
 =?us-ascii?Q?ijZeVZVcaAWXtkU/dttYysKgm+RG7eR8C8NuLEX5sN5Wwy5URxTcQhevjAQO?=
 =?us-ascii?Q?jGFrzM0ggGMzEXZIp7BSCSC3rGrygvfaxHXGHQD5M09noKqaK6/VSIWOZjfw?=
 =?us-ascii?Q?pGVBIxqzhsZ0h77y3OEcRTf0XeZCxemlMCyK01Xl5bwG+EHcJeN08e83AAfu?=
 =?us-ascii?Q?A2+XFIH0hJhRBO6TVirPsJRaxFo7H4RQeghIdoI1BmZZfQTJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833b4a40-8d56-44b3-eb43-08df29237ac7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 12:14:07.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItEd68c8rPoYGO4e0sHRRzhB8JXgOejTZsXB8sSi/ayMzd6qY6E1EwHw4Jot4i7B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR12MB953872

On Tue, Oct 13, 2026 at 10:32:36AM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Thu, Sep 24, 2026 at 07:52:39PM +0530, Aneesh Kumar K.V wrote:
> 
>  [ ... 67 lines skipped ... ] 
> 
> >
> >> >> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> >> >> +		return __alloc_cc_shared_pages_node(nid, gfp, requested, mem);
> >> >> +
> >> >> +	order = get_order(requested);
> >> >> +	if (order > MAX_PAGE_ORDER)
> >> >> +		return -EINVAL;
> >> >> +
> >> >> +	if (nid == NUMA_NO_NODE)
> >> >> +		page = alloc_pages(gfp, order);
> >> >> +	else
> >> >> +		page = alloc_pages_node(nid, gfp, order);
> >> >
> >> > [Severity: Medium]
> >> > Can this fallback path inadvertently allocate a highmem page?
> >> >
> >> > The function's kernel-doc explicitly guarantees: "A memory-state transition
> >> > requires a valid linear-map address, so such allocations never come from
> >> > high memory".
> >> 
> >> Only when a private-to-shared transition is required.
> >
> > IMHO disable the whole thing at kconfig if highmem is enabled. Make
> > the calls always fail.
> 
> But we also want other kernel subsystems to use alloc_cc_shared_pages()
> when CoCo is not enabled. In other words, usage like the following
> should work even when the kernel is not running as a CoCo guest.

Oh, really? dmabuf heap doesn't want that..

How does GIC even work like this? It makes the memory shared but then
it puts the private IPA into the HW registers? The VMM is supposed to
assume every address is actually a shared IPA and fix it? That's a
little weird..

Anyhow, in that case probably mask off GFP_HIGHMEM at the start of the
function, not allowed, not supported.

Jason
