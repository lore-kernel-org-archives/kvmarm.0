Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488D3F7A9A;
	Thu, 24 Sep 2026 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790274416; cv=fail; b=Ch+p7Cf7Z/n6HoQA6h9Uw4G1dlVIxqb+zwaaYWkBceNgzYL1vzBglbCBeolnQS6q/Elg32pO6tR6+2ttr10JeQpEnlln9Rm2c+KlsnFD21hzt7py3U+VW0t6jxX592Fz6VLwkcLgIE0pcOmjw5xwvaogNN/qtsxj7nxMp3UQa6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790274416; c=relaxed/simple;
	bh=h9jhGS8NtUBq0zs6MgfONAnCSPH2FDBSUTad5zPMXrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kciqOJN7ufJldl1psP9QiqAvYMuUh3QdQNxusQETW2MjfRqT1Y99EZcSHcDCWu8cTGT5AkXAMOxJ5nbKdfHNEUgnuw/+HsxEdZZ9xCNncADe4eNcXWXzOxvON77UBrd3u+BV3VH+5lNxlhvYCFqlxzWuwXuB9MKd8zdN3yPEfr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O8ny68Xg; arc=fail smtp.client-ip=52.101.48.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O8ny68Xg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TqEwCwU+1G/m1kHFAivjGqguzxY4dIDkyiHLeXvzGnU7Rl86WO99upUiCFCZ7V2squHmeH70mEoxXEcIy1lOYZicBTSdoGwfqvtH/ujnwOVqJa5w8dxALfNITN8MyoM1oNTey/4ZD5a+lDFSNwfSceVB5tHanNQyAOxbJ2W6NdoT9UsCIdtBNj9nBT+4p6d1iRF5FMd2LQnN1nw4jaJ+luwrxlfoPhhqdYYF0FElnS9QrcDIlDnixHyYNs1oBBA0BpzstvNu2YXgCSvaczF/y1TBixXlSXzLX9kdJf44Jcffmaikn+idM8ZO597GD3hsFkkhRcd4i26WpJKtLFJpLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYjtCOk6adHxJHjYr4tvhIzdDAh9mt3SDAKveVZMI6I=;
 b=wTtRN7V1aetLRmQPj2baIDYxU/TcJnd31eVAgYXdM2wOtiYys7rvF6YStGrcQ3BuXVAgenOmTwxTvMCSFVq/rvY3B5Hz8dY8LS8Cqi+36Mqc/RM0Ym11T7JiM54cA3eLPxSgs2JlE0LgRb9EHsQ5umFr9PEs3vaNhycMhsl/wgImlwZK6Ky33OHZrFc25+weET+2v7y+jYjTXkvuw9mj66eSuRJ38z2L2z9oQmIvdP/kmpK/1IPpKnkJnXHeXwqC+evJvb9X8dgNMniT1Uc32T/z7SBeuJuZhZbmR8ej04uumcos/aFGMjzLmLut9IYkyZJR5fZHbxpcRtP4grMZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYjtCOk6adHxJHjYr4tvhIzdDAh9mt3SDAKveVZMI6I=;
 b=O8ny68XgyAgxzts6EGVQSHlkjufjpYnPNw7d/GuxjxpKGCbTDJdt+Q+AC2ZA3IQdyDAIxtjvEQGHpmeoVkk1yK5g+CNNwz5B96L+ECeG2eegFHoNeLTyoF7MpYcAFENDj3ONcQVF1ycAX4ffMOBzccR5ctcN8zmaIJmtmADGPQFirX4X7EaCo0o0VXAld17k+WPq9Qz/l2AOW6XltxJ82KDIuhFlNHmdMlYcUDJ/154C4NzgwNXVY/0Ur4ZyfCgrY5xGmQYeBmU4gHiT6lv5w7NNs930I5BWOYMM8t7MVy3jn/qV8d0e6k+FkOSD6OHsom/3b7N+9/Lz0Ei6FveoIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4279.namprd12.prod.outlook.com
 (2603:10b6:610:af::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Thu, 24 Sep
 2026 18:26:50 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 18:26:50 +0000
Date: Thu, 24 Sep 2026 15:26:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, dri-devel@lists.freedesktop.org,
	media-ci@linuxtv.org, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v8 01/14] mm: Add an allocator for CoCo shared memory
Message-ID: <20260924182643.GC9354@nvidia.com>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-2-aneesh.kumar@kernel.org>
 <20260924101907.5C6261F000FF@smtp.kernel.org>
 <yq5a1pai4tlc.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a1pai4tlc.fsf@kernel.org>
X-ClientProxiedBy: PH0PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:510:5::30) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a34f821-22a7-4024-cd32-08df1a69666d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|11063799006|6133799003|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ocLA9wnCSHXb43iTcGyGY+XUOWdeGbghAeIKFTNX2n1JozIPozf/c4Jb78JbicIb3MVB0+WvFmGcsyOVRvJPftqulSQ/9qbyZSjhDmQHMdcykI3iCHFO7/K/jsyIM8CZz8EViJ7MqwpJiMaFknSGRPTaGWRmyUHxPlBmiJzNDSTpi8i1qitzEEYuzNIT8IFgBwn81Nz1ij5xiMfdyfG/5hotuo61z4/8pS/CkKq6R1yL7KKyGQt3121oZfqa7Rg27dIjipaMxBE5BNrRI+Qcg64TCJnv/eUDyucQwF5u5vG2GgTRfEf2mjuhNexKiBRzkNN1umfvf5+ryYjZ81uO5ZguJ02gzpXycjiZ1JprMPfdf03q/K1aacWQYTOlpxb5HcoN/psZ7xQQWZTe2dfAsgS1wIXLOFD3oVXhkTBhIqTSQbsPTKbM/f7qp7YAdt1RhXIp64nMcR31u19cth96wXrxi+f/PhYMYM7VB7MDVsMl9k1YpGYSRVIKpZfK21f72tFB7WZExo8aLql5XSkz0SXDWWApQ7cZqLZZYv7YIVi7KkeRXBIXCg2VULj7gsAyM6lf6lfFXaWfaMji2wegleiFMjqdm6J8k/fA12jYrhodlCx+xSejAdUX174mnOD7GMJgBQVG3yN/EDl+zVECkVgG6LaCBXRCF0dg1wBT4qI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(11063799006)(6133799003)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i12alCYJyJqSqdP5qN2Sv4e/GGoAD/FRjLlQhGT6howbosCGqpizPFu+wnWF?=
 =?us-ascii?Q?FSyetW2A37TWEoVpSgmv8S4gmB8U7Pv2CX0UAQV92LIwGnWb1We6yMjce2ID?=
 =?us-ascii?Q?6l5W4faGyFPgODHgPH60Xy4lO4xIHJ0fJ1QK70/cDNsOHpMS+4umiYm6+oM/?=
 =?us-ascii?Q?/9Gn5+DO1ocQg66FoDdjSdWjNGCizEqT4V+51HBVDGf07cDUF8WpHfRLD9dH?=
 =?us-ascii?Q?Ii5xx3psI/rXsvZp2hXdNzLptea9A1vanU7H/VtjSHCQJMi/6FGjQwg1IR2I?=
 =?us-ascii?Q?Qpi4rZL7Y1xUUb2/uA1rij30Ycmbw4EOle3H5hEV0qZCBVK4t34+TqqzGoof?=
 =?us-ascii?Q?iqbIAP9Q4tMNzqC3qhBJmVopz68CANVFfzjpwX92PRXOzySqaGvVY3aySjss?=
 =?us-ascii?Q?SdVpN4VVhYBNvUFK3Q+PBIMMaFSIKQp/R0fsyveSZtAf9Hecb82UAh1FUyto?=
 =?us-ascii?Q?U/hDrEKyPGzl5WyHNBDSU2mzfVgO1YWpXt3yLmLcV1hty2cDFXpkDYgJbltx?=
 =?us-ascii?Q?Oskv4cCqnioC33SDxaAyaj/FjG1Tqlt4eDedAUfijRI/D/ITc6CeRKykkEw5?=
 =?us-ascii?Q?J0UJvABg4QYPqB5HoDbOZqxnYcnAQ0YkyU8WnD1E5eTtrl2oVDPlvenBriWZ?=
 =?us-ascii?Q?R1PSVjcdLFSdwUnFRQjYGedPbExDABnOQnSuZ8xyHMqTu5MFHQOdCC4Njx/P?=
 =?us-ascii?Q?3uiVe7XRWO++mOkd4XROfjY1jOUh9n6YBNPZIPhcQ/LdQ++Ue2aId7jxWjl2?=
 =?us-ascii?Q?/gxeP4tdANFrc0mD5iNeA2A5bjHXio4yUzdvr55pNX9Cw5MiHiqEJMWQn4xp?=
 =?us-ascii?Q?Ws6gAThgVQ1oQuYD35Er3Z+SabLvRm6g+ercHO7WHtPoQIVaVbHEjstQq0L7?=
 =?us-ascii?Q?GqPf1JgdvQo3iZWQfoK0nnodDkd4cE4jEzuPQSLSPxN8paSO6Vie/CuV9hcS?=
 =?us-ascii?Q?cZpbvkXHzSt25YZSeqdtSJP9IR0hPjSiDo499TN6zhnFC/+3fQ+SQ71efhqB?=
 =?us-ascii?Q?mVEXOVy0iwU/v+ZDxGz2B5S949uEENvocf6TSTdih8aHmjzEBCgtB1eJBEED?=
 =?us-ascii?Q?l+OASnwcPWcdnCG9B4P08D8ogMiWt3L6MRrCNNt/vINshxNCH+GQ4iCphWAO?=
 =?us-ascii?Q?flgfFi1aZG8w9I+gOJTjld1QtNnLGImt/ZEeu6ozpt1CguG4diJ2OJzDkMT4?=
 =?us-ascii?Q?JiNiVFzrVjZSQfrGNf8OYbtJfdz6yZ9nkJcc7WGpGVSUIbznsOi5aUPoRKZm?=
 =?us-ascii?Q?+WkKNg32EINnF6lARdm7NGBS6QGaGfga6w5mftIYY+gkhsoxUax+cwEWgv8p?=
 =?us-ascii?Q?LTjiz0jvYrl+yzXdvJQGz842pbUN7X/Upgf4tx0IZsgJiNWiqfnuG4OK50rk?=
 =?us-ascii?Q?vUKW1AoJM8Bj/5A3wIQkwcGHpKN9HaE2ynmtpiYKFKKSEH+6rouPUAUtNxtV?=
 =?us-ascii?Q?DcPWCRDpj3Zvdyr9NACIj7c8k7bq7vIi4ylMZPsXz7INQrxeOIANtMZTlti1?=
 =?us-ascii?Q?3icYFCwrGTptv9yryxC4Fh1PPfzTAXolbxXlcE+RiI6gW1JKSTFZ389jEB98?=
 =?us-ascii?Q?uUefksYJkaUgR8etn7KlAodczS55vEgzbZEjqPeZGz1tc3iyWnjHt7IeJCuI?=
 =?us-ascii?Q?ufUBleM+Aj13G55af5KCqwgJBl16CCWcUgCQ1LUtIif3VvxOJIVKC0U5uKPz?=
 =?us-ascii?Q?vBA8fjdC2TnRs0pjGMMuY5MCgbze3URb0on54Jjzn9GjQfEr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a34f821-22a7-4024-cd32-08df1a69666d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 18:26:50.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21XRIfLarhyeL+4wgvh3ddZy0FIYrZUVchxkzduusJC6QKWJJFZvvuUn2CMkN5ql
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4279

On Thu, Sep 24, 2026 at 07:52:39PM +0530, Aneesh Kumar K.V wrote:
> >> +int cc_make_shared(void *addr, size_t size)
> >> +{
> >> +	int ret = cc_validate_transition(addr, size);
> >> +
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT);
> >> +}
> >
> > [Severity: Medium]
> > Will this function be unavailable to dynamically loadable modules since it
> > is missing an EXPORT_SYMBOL_GPL() macro?
> >
> > The commit message states it should be usable by callers managing their own
> > backing memory, but virtio or guest drivers won't be able to link to it
> > without an export.

> >> +
> >> +int cc_make_private(void *addr, size_t size)
> >> +{
> >> +	int ret = cc_validate_transition(addr, size);
> >> +
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	return set_memory_encrypted((unsigned long)addr, size >> PAGE_SHIFT);
> >> +}
> >
> > [Severity: Medium]
> > Does this function also need an EXPORT_SYMBOL_GPL() macro so that modules
> > can successfully link and call it?
> 
> I guess we don't want the cc_make_shared() and cc_make_private() APIs to be
> called by modules. Modules that need CoCo shared memory should use
> alloc_cc_shared_pages().

Indeed, but we may also be over indexing on the cc name given AMD also
uses this for their troubled host memory encryption address limit problem :\

The note about virtio seems a bit strange, these are new functions why
does it think virtio is calling them?

> >> +	/*
> >> +	 * State transitions require a linear-map address and may modify memory.
> >> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> >> +	 */
> >> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> >
> > [Severity: High]
> > Does this code inadvertently leave __GFP_MOVABLE intact if passed by the
> > caller?
> >
> > Pages are returned as shared memory, but they lack migration hooks
> > (movable_operations) to handle encryption state transitions during page
> > migration.
> >
> > If a caller passes __GFP_MOVABLE, the page might be placed in ZONE_MOVABLE.
> > Since the kernel migration code does not know how to handle encryption state
> > transitions, the page cannot be safely migrated. Could this permanently pin
> > the movable zone, thereby breaking memory hot-unplug and compaction?
> 
> I don't think we want CoCo shared memory allocations to be movable, but
> I'm also not sure whether we should filter out all of these GFP flags.

It sounds like we should at least *reject* movable. It is right that
seems incompatible with this, and we have no use case..

> >> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> >> +		return __alloc_cc_shared_pages_node(nid, gfp, requested, mem);
> >> +
> >> +	order = get_order(requested);
> >> +	if (order > MAX_PAGE_ORDER)
> >> +		return -EINVAL;
> >> +
> >> +	if (nid == NUMA_NO_NODE)
> >> +		page = alloc_pages(gfp, order);
> >> +	else
> >> +		page = alloc_pages_node(nid, gfp, order);
> >
> > [Severity: Medium]
> > Can this fallback path inadvertently allocate a highmem page?
> >
> > The function's kernel-doc explicitly guarantees: "A memory-state transition
> > requires a valid linear-map address, so such allocations never come from
> > high memory".
> 
> Only when a private-to-shared transition is required.

IMHO disable the whole thing at kconfig if highmem is enabled. Make
the calls always fail.

Jason
