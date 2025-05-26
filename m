Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7B1C28E
	for <kvmarm@lists.linux.dev>; Mon, 26 May 2025 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748273122; cv=fail; b=nSHhuOtmgFN1IbMMZRbXa0Xb1qhDaK1Ed6vPEH3Sg1JbnsUwov83YF+bxH+5mqALjgvET6ZALyzyXN4hhdKwFfxZJVLeF9OFpGjxWqI4XU8+sU4GARA8TeW8zoXshyJFADaHZGmNBXBs1IcrLvYI6Eto9WulZKoJGmRSKPnYexw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748273122; c=relaxed/simple;
	bh=rmIS8wtQXqv8IKCwQKWeQJK7Kc/Vj7RshakdSwUqZXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XgjOxJ/Mw0rieqPKjuWN9TckFN9YyjZ8SDOO2dmLXjE1Q2tvxAlqAckUinjNJMXCsJ+CO7loVT9IF6pOgP9Zp+fozy343jIK9tRbMz1/+WM6ZWcYFNAAuPT37F5HqXtSc2xuf9sCw3+REfbadnZ1803Dap6YapgPbleGcq4m8Z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BMP3HtoY; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BMP3HtoY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmSJLwa0ATjSxV1a+IpmgrBw3IZhD8VwWsjouyxm4oEwM6LM0x7LRj1wxKwHAA3wlNdR7MFQDEPr0XZSWIz/TCF9aTAHW24O6JW8I3dX//OqpC/zBWsHLaMuc6W8J6dA75T6KGE8ivQSDQk/d3uuaWZ5hEY6eb+dzVfeDCALKMxqzF70ZLGPZX9pqdPEw+4wKIOiPT/NxoOxKoRLv8IG3XI/51sxYN/Sb9Yh//r0OYm00bqrJuKeMwWQ9h/8l5myKSqm7PXV74TX5IT6A/aqZQrGr4EEmCBkwSaP+EfRWfaY+wfONAvsEIqWRqylPQKpot6eiENcL4eQscchg9wMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxYF3M/XgAVOApER89yPb5OmdJsTfSeYm1HWWw5CeHI=;
 b=NiTfrHDHVypYmx6eDJbdUXTZTXAi/vKHu5YHVF2Bn3owZptPQZD5g7j85Ke3L/Y3azAxoF5FC+PWgbbqxch5iLbDptM9Z3R+hNXdWKtyxdWSll/QddeHEd6NA3CAaXzF6aJ0kfSVjL1PwvxYGH+U1AF8j8WgemaBw9suDAWyTdVx2+atNWw8d/dNJxaJr0aO4m5eV4SrZvjhXykuUWrRNuMPIgLKuFTyvZAz4mma20BIzm/ruld49mIXCSJ1A160Oho/6HSPCT7x4+K9eAW8svl3VttmTFuVBm/vC1ZYDOncyY05yAYGlJ+Fecjoi2D2ia0Nd8/98tMenpSnn48b3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxYF3M/XgAVOApER89yPb5OmdJsTfSeYm1HWWw5CeHI=;
 b=BMP3HtoYhEcXjbT183HlFsjZFwIzGbS4TvxRGz3K0mLQVZKR5zbw1VDVwu9xEViA/kTzplAB/k8aTJ3Wmi2BL0svNpUo0UrsLy976HHoPlRNT2FHVBUozq5PIBph2jdGhQG+ZyP2+eD9PP8PRY0dHByB3qrwhcf+WaiCVzaz3VmlsQYwk5o2NEqQ/i62tBxPGiBvHIxpKBmzF29D8WBz7JBvGc10NYJBeWXmMOy1OTAdDW2dMLAtNx6kLYgUq7IjIHtVwNac0jykn3aVmx0TZ3/Am32Qx8NlWXmikbJtkxD4znwGNWvWfaslhplpqne2tIInpchdP0GIFZzN1u4vLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Mon, 26 May
 2025 15:25:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 15:25:16 +0000
Date: Mon, 26 May 2025 12:25:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <20250526152514.GE9786@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-2-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524013943.2832-2-ankita@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:208:329::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: d7476602-25ac-4a91-4b57-08dd9c698411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HmMKpggfeXvyHCpvXH+ZLVcDIBnIZtFDFyHknA9DaX7BqouZ1X+p4fqeD6hn?=
 =?us-ascii?Q?Ivl0FKxSNo6tp+3ZARsFBJ/uHwSYAAc6TtAOOvyRTfJzxY/3dTZepbkUT8CO?=
 =?us-ascii?Q?mHizSV1T/xHPz1u8up7Gp1G5Lmw7E1Wx9nTuqbEiDZxDOLHd/z/YAuqbjSMG?=
 =?us-ascii?Q?veKCgx0hsYmEuFX1ljkSmrm85+f2A/ST6VIHOX49671QR2loMBgrg4MrVUzf?=
 =?us-ascii?Q?C3kUBOlXe4/tlBe7qgRQtL6vF7hrN4mpnQAhYhoWZ4JSvgm7sr7t17UGYsLL?=
 =?us-ascii?Q?ZQbHn/bXgptA7z5Xr8R8OgbUxmZ46PYZ8Tq6xpEuA3PYI4iwKDN0IEdDYXJ7?=
 =?us-ascii?Q?DxShXFWeO1i+RgvNjTivdqQsVY87tt3BaaK8OfjD75bVaea6vwQLtLNeL1MT?=
 =?us-ascii?Q?QKKD/qjxD+2J8JXYM8tMKbCgPWK62q5OvLb1BDec/jc3c+PNwk3EJKzMBgoJ?=
 =?us-ascii?Q?bxAkZ/G9l8TRJRvTA1VYkvLuZZjUd1KAaieyViaUhcgVdgJ9a7jNQN/IslDS?=
 =?us-ascii?Q?ZNzzbdGHWjEjxSvof8pGLXMOPmwdmfRNvF+04cw00PxknbEyuKQwBEGP96v5?=
 =?us-ascii?Q?117zRies9G8n6nbEcqnSsGHaHC2jEtppnpGo3Emv1Z5g06WN6R3f+LkZMlmp?=
 =?us-ascii?Q?LxVFwm0MWlNsmwyNdOUeKDjT1loQN7eD0pEBMSV67V5kpLwEvR3LdBodWbc2?=
 =?us-ascii?Q?TjAWwciBVP967QGhWb4o403oYe7O8Bx+gX/Bxzwvqpvs7JxfBGynoGLzWINw?=
 =?us-ascii?Q?XR2nom4gf+I5fRjoyuIxRG50DEJ5AEHTbcpT5c5DW0HX1pgvGJVXj1/EZEMu?=
 =?us-ascii?Q?pIaYV11nWzPLvrBeWJHMHquqo5gNmMd9oRx0ZtEGrcZdPu49qYlQfIhysNKI?=
 =?us-ascii?Q?tkoFy3n6iKGVkRltr5doJXszSDJCr5R/4od7daBAyz9ZSedZeV/6N7Phba01?=
 =?us-ascii?Q?hP24XHdUe1kDOCMP6luoj72z/hqMy4hhKECbNiLL99I3ZJKsuwXaNTDASVHM?=
 =?us-ascii?Q?5hZwmSl3Pu+Dma7M9/hgrIf1j3ZHpPGvM9GH66VxQeR8d9wW7EcZeHSxDCNv?=
 =?us-ascii?Q?QhiqiXLEw5kAvS17IPCuE3VQIAKFz0l+JSfUk8V8DdDALvfWw1SfnmQpk8Y7?=
 =?us-ascii?Q?CLi9mpNX0KLh13Yqzr7TkMoOz7IYP57+Rje4uDBPjRMz7B3CMR6ZkKzJjues?=
 =?us-ascii?Q?IqYr7GQAmELstFCMCdx78wBfwo/CvPlRWgETdL5dFyzkTZBEFGBP3iOeJIxm?=
 =?us-ascii?Q?PZKKCvabVzAad3ikxnz1rjV+urrQnAVCtMNoRA5oOlz7VYBoEwKqc8z/LSca?=
 =?us-ascii?Q?frdhl33pptNzxElkpZUGv5ETKYqAK/GTAX8ZyhGobXISh6mnWSpViIwoUqNp?=
 =?us-ascii?Q?c+yrLxxAqN+GOOqnjRZXJdNdvcxEMSPwbigxRsWg+7x8fXqxyg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+v/7nd7jL+FE/yrC5e9aqZEg79n4fFRAQ59YHz40ty2iMBkC1C0vPhr4g8zk?=
 =?us-ascii?Q?t+V4+Jp2dwsktLW6FnBSIJwRGITdaIfVq6Z8VQtwU0ofti3SJaAhQKl0U2O6?=
 =?us-ascii?Q?bVq2N9RhyaP3YKPt+h/oIVGdHX2QprjTY1d5bIxge19BI2cJYEs0kLbVnV0a?=
 =?us-ascii?Q?J92k1XqSJuGXzUzE+gX+KXUWuclAe7MIGSiPvGBSNfUzZj0T5WGzJAdTPKa5?=
 =?us-ascii?Q?WPHFulPVHuAMXTgyiNRp5DaO/BCeyh6iTC2NDH1UKxCZUxePFeGueptiByS5?=
 =?us-ascii?Q?4vsj/UHMtTNOsurhduLwiXhRdQNP+8NDHBi+ieg73oWXRnbqhD9ne54btBHa?=
 =?us-ascii?Q?NxOHItFSZU2mMLC4JAsZzExsWwnnBO7tTGUp9iDosr7n40svaRVC7+kb/Cma?=
 =?us-ascii?Q?tJ+W3wpqKNeAzNg0R2YSC25Cm8JjX3fXhAjx26ijS8itPNtx0smss3uICgMe?=
 =?us-ascii?Q?jMVXI/KLZeStAmk1y+kZ1BKkl1zUW43AoVRMqfxBPOKYje7QCowL8exSd1y5?=
 =?us-ascii?Q?7wC39nsoMTI3F/r1o+fwz2DvM9QNoxEHCUKPAzaDbDx4DjDzojUvP26P2oiN?=
 =?us-ascii?Q?o7/VXU3wY+/QWYakpomjXMV2GHv5P9nuvag9ph9zvuFF7eG7yttzCQ6cnfBR?=
 =?us-ascii?Q?S/FSsXYCHvKvXEjACmG8ghUikP/bhxLXtGj7uQK+Yu1UvUT0iGAKu8INzc6W?=
 =?us-ascii?Q?mO60xBbuCzGUssXbhaW1hqW2141U7X2a94DLxMzur13L4Kdqy2km6bHxzShG?=
 =?us-ascii?Q?fKXDPZBfhp3yRIgEVnh6MV1IJCi58p7XMkWpKaH9h2fxdSxzjYSZg7DE44xR?=
 =?us-ascii?Q?7fsgdL6ieuqySPJjofdJ6IUJ1vjMHBP4HrIqIRq4wfsVLcG8p197zy1IhayY?=
 =?us-ascii?Q?7DlKErSevGh8UerDItBPg9YC43sGZ+OEqQpgijQyUrYMuAuvdCNSA6795B3F?=
 =?us-ascii?Q?8uVaRARFEBIVytX8QthfrBlnKu3THIqiHNSJOqbic8QO37AKzUM2Wisg+a/8?=
 =?us-ascii?Q?l2Cf8BrFm8I/063+9r5Jw1OpC3RFvMgYZAB64puUg17MLKhLCsXD7B2w1o1J?=
 =?us-ascii?Q?0B3q3Y704plo5TgTKMCBr5FRyWjSvx3uJUyM4j9LU2hcli+03lFWZq31nSTL?=
 =?us-ascii?Q?EiKT936rxO7ac+ZZPQxUXpD97MMQzLABve1j4eAG7iYwXs56i7e8Eds7tJoi?=
 =?us-ascii?Q?OT4tXwO5BuIFqdMYIojtUbwONZhn6GEoE2lFXCkPqFkEKO6sL7RGdlgTFsBJ?=
 =?us-ascii?Q?uKub4LWKxbgeR0jxch+RZFEe8AYkFKW4kmGM12n4XevKlOzGEvtKVtWH9G+n?=
 =?us-ascii?Q?fGNGDY5rMOmTmsC7NjAzjjsMS5DjHWDwy/mf/kQr/Mf53hl7yXjV0bUkH4Hg?=
 =?us-ascii?Q?csLkWKwpLDmdpfZ6G/mvRBEh6d+8JzvStzS8EvK7Kwr7R8AGB7EkksJv20t9?=
 =?us-ascii?Q?yEgQPR7rTTLYNfwV4f0sWG75s+DoiQgDkCWk+j+T+iqNHOlrFkZHrjEnlvy/?=
 =?us-ascii?Q?5m0p/GqkggsNGidnALYkvQh0BvBvdJ62hk95hgnFaKqOucW24ppBpXPGwr1y?=
 =?us-ascii?Q?X4C0S6y4FGOKUST2KmY11+iaHyH3EaSwsV4f9WOS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7476602-25ac-4a91-4b57-08dd9c698411
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 15:25:16.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXsRJ24x/BykNC7yH78kAYzT9nrQ+gFbyML5d72U0BO/RnxDW93FmsG+7dmOlf6G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981

On Sat, May 24, 2025 at 01:39:39AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Fixes a security bug due to mismatched attributes between S1 and
> S2 mapping.
> 
> Currently, it is possible for a region to be cacheable in S1, but
> mapped

"cachable in the userspace VMA"

Jason
