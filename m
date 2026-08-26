Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011015.outbound.protection.outlook.com [40.107.208.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540AC3EC2F8;
	Wed, 26 Aug 2026 12:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747009; cv=fail; b=I2pAISLctXhKSD4zDPFE42II7uP+UNIgWA0Hfb9F/5dIhDk2TTdzf1xhcH8lKsqww/u7vGqwJysvp/uJfSzIGcBTy0VSQmPwHC+iMWNWJe1Y2e4FsspAc35I+RjKSDQmEXA6XhsKuoOZ+ZA9kK+Ywo5doW1o5QE68RDzCMkgeR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747009; c=relaxed/simple;
	bh=qfGyNf0kXdGS2a/tlSsUKkwvjZ8BHWtbG9tIGpyNyZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nQoD232xZ94X05ylrufTq4Jw5gsqggeXYUmgfZvkmLEBwihIEzoCJWgZamWDJFxf5yKBuXMGTk7JwGIJi7uKeUMem8cyoGmF18DCH0EJUSKST+I6yGpPzHnssiRDRyhXdRHwQmyuIL66Ljbr9Cj/YaCVTRw2KrrDpIzZ2+YM5sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pwss7j3W; arc=fail smtp.client-ip=40.107.208.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pwss7j3W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JL8jM2xzoWySD56U+XoDq5OByqbZSHMohg7MTvqU7OU/Ndvd3gH0KlbwQoE6VlgDuaOV1EM0mibmSWJL+ADnjPi1mVd5MBnMA+pGB8Z7KH1xqxmsKpOzBRyT8dBrfF+lnVMUqqY1qMr1Q4i5YceXjbFO13IE/JDcZu6LC6y/dWlRzL4YYPtvGt8aiCRmutMMLVT3tMG/hHRmowcARSdLV642OsX00uzYqStodKeAo7FTgxLYXvITwHUULen4I9teIROlcDz8B8UvUXth+2ghmlbINiU0xmIy463eA57ZyWRz5I8+H6i1AZJLxOgsKAKE54Vs5o8Zpw2biexeBBf0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV6HSnqkuJTQJI3dzxxBIX/V4EEiZXFxX+3DqkDc3Sk=;
 b=fP1HOk+p5cy6JbohsCHGGjG6xaJJsbZF9oj296bnQqbveDqdX0bo4tUNA8UWdVwk8Ih3rwjtA5A9V1G1jBLNjvfVEwZjS2rLlqIU+2cw7GbM/b1YIV+1ex/HmpZKROU/zdIreiH+mYgMPE/9QdoozW45klaQz8aIZ24d/IgudN7vAJejetlPe6FZA17rGeSevY+KZUU/e/cBSBLa5xeKu/fikE85DMNnYY0cCT1z2iN4oR/Ydd5fu8mlk3eUw5Gun6PqNlT6YCAafDWO/3OdDGst6WOI5icRG1Suxq5A3fPqXvdFwWQ2TGoD6GvvIKpP91kqYjFMOcZKs7iLlFNHQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV6HSnqkuJTQJI3dzxxBIX/V4EEiZXFxX+3DqkDc3Sk=;
 b=Pwss7j3W6lCEUWy9QJLiVxdg+ON3TcqJzkZ3nYoJ6aEvqnNBpzB5uAooCbGf1PwyQtKLrtQOKE8ANo8F2rqpXbuRJOmcp5+0Wk1lduwFPzNTnddVMs5LiWyejIWpuUznWyQJOeIMprUv4YDKkPukvGCt05tOeXSAUCtRBpqzyCzWdMvgcP8yaXe7nLFsHgok/N/Dpe91ZwMysSmxnPIw5phdB1k+VMiUWyDl5qf26nJ3uVn044ISFSYJunZ4G7wmLw72Hj/kjbQ62Ofl3pT2EzE/YFHmHFDAOhWOFtQY8m3CrtegYbvABsavPAVmBblVb//o9PPAZQEeHCDU+c3+1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 12:23:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 12:23:20 +0000
Date: Wed, 26 Aug 2026 09:23:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 00/24] KVM: arm64: SMMUv3 driver for pKVM (trap and
 emulate)
Message-ID: <20260826122318.GI3325090@nvidia.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <178769159057.3356902.1232440069489543145.b4-review@b4>
 <ao6nvupFg7neLqbN@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao6nvupFg7neLqbN@google.com>
X-ClientProxiedBy: SJ0PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8131:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c1f1de-0efc-403f-3bc7-08df036cd0f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MMEezEtBDPLyncg8rSAN2KM+ZHbZmKwduW5m6eEHjJmup73zs4ZLOf8MVIG2Jvh+GOPgvMepck5R7gfEBh7Y5/Ig917vLxoClhU5ISjX6DWjQeuUefQL+0bZdCGDznjpqnrMSR5cMlU0F4OJM+gQ16zcpNVIJVdUzWvPAnd0yXD2M519JC0aJh/dmDxjmwvcdSZB5OZjL1K4OEzQYYppFFQvo9lH+vv52nzqDP8FJiJmPHHeUD9w8Dew4vJa7UcfdVzrISPBe9v0s3ihI6AVvPQcERqNUT5MXAhbrvinujCc7DyiKSEKyuTQLO+j9TAvRrx/SFLs/UrGw5QOAwHH2lE7xwYgzZCHdPRhuESe3IzBxqZHnwKwfdcVfs4OENZoNv953KC4bnaDcbthr0ryti4X4K9gzmEjQpa9GMdYXUbLNdTDvUIC5xRS2Y/vxLsoPA3Gvef/yucFs9Y19Ufdw7PwX7ccuZw9k4B8dXi4NS8l1+ai/rDQqrVQd6uEz7NeuqkEYt044WeJXUmi9wIt+bSuBvWOrgs4xjR5uuOuIXWnB000aZAGeF6yrQFd5lDtkf03wNFU5/IO9kA8XVa0WwiRGgX23lalymZabPhMfxMchkczsu/AID2/QnHO0MioRqvR9DK0/Q7ARtnF13/bxkB6j9YktmN2hFpCF26F+mU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4BAFvTOC+szduNKdQvb1S3XjJeLU8gI9Ck6NccowFD2GM2ulIp+/esRUvBe?=
 =?us-ascii?Q?5ozyXASiCYw5H1C1chz4aheo3jKQPlYniKyVMaN8iPPKsJv9t9blrIfhMyeT?=
 =?us-ascii?Q?SWF1jjlEq2F/yDdVx/Au6M1iBu+AMO7mGNJX5YE/KeghLbzXpgZkHU+cQg75?=
 =?us-ascii?Q?Rgs8OG32dRUtbGb5SYn1PX4QQ8ImVdXgM7VDmYbe965/Xc4o6UYFbV3j5V4K?=
 =?us-ascii?Q?J0dXibaBgfGsJvtjzVQltkjAQvA5XGyk2DAAlX4ZicDCuEfdeoMNttz+jSUz?=
 =?us-ascii?Q?4gLOih6NaF3fQk4YjsgcWGXPDuToFmOdBW2uN/S0KxLM31Ni8Qr4DigEe03I?=
 =?us-ascii?Q?4S9RRfCdCJnkejLbEkW0/0P+FLEHrb+qk8HZ5xvP6K8+x7Ocx3QzwU/pFnj2?=
 =?us-ascii?Q?b4CeZWSYvqcBL3eIE2MxWVoZVuSndXUv5MbAlpTdjaf0qOsejC/93ksxOI+6?=
 =?us-ascii?Q?xZggGN+iWfvAPjTGleRCXIFKzn+Tz5o34ZEJI8IoqCMTZIl3bNnVkmU2xTvz?=
 =?us-ascii?Q?rBdeFTczFAZP+f4HwTvBP2XJ8hoggysmizaNV/f1te8kxcnRMf7KZnIYDLjp?=
 =?us-ascii?Q?Hhbkfh7vTOg0EhhM9zzPivA1wFCJgFu4pEiEdObcEtOn+sGEnunwkEeLcOzl?=
 =?us-ascii?Q?piqRGisyPPPTw61rP9x5oyp39iSCvhJieGRTGztEI1eM57FZX0FeIFiNVyIv?=
 =?us-ascii?Q?FrhTP6t7eGYOAwRgr8GAd33mKEULI62Sq9AjuTd2IbG3JZLcylBduoPyzFzb?=
 =?us-ascii?Q?iLTAklrOqyJtmZtePBjfDzxjrFXna3qw0Z/PDqrfqpSw2RZ0gc4PS+7syJQK?=
 =?us-ascii?Q?EZ3RA/Vc6bnPZiHvhwC15hglKT2xV1FEsMs9nYkfCh/o4n9IOSq968vv0ptS?=
 =?us-ascii?Q?OUTFDxCvCDbCbKvjgjKHJlIttHfS+k5BgOH1Slrig4A96zSl5VshoOcbhWEu?=
 =?us-ascii?Q?yxg1aj0QwD9nH/FjOtkrht10S5X1dhS3PYKSL+oKdEJzdYzPx/+I6cEcvok1?=
 =?us-ascii?Q?uTaeFlllOrFJGj+ZcNQ7AsQmEI1D7/AG+zxbu9+BgBb05r0/h7WNKI/fzsZu?=
 =?us-ascii?Q?zp1SmI0pWUvzJU1RXt0uZiL/982DhMNCmSXn4DALYoGWhJb8+3/YlQeQZ7EX?=
 =?us-ascii?Q?ctK9703dUdpNc1DFwUm2C+Xmsi2YjjDQ96cyaIunv3LxA9WvJy46499JC5+V?=
 =?us-ascii?Q?Oh8bveyRFdNLPZydzIaygrjCOk5Eh++L0kY2O7SdC8dkjtDTYFvRPUEqAQtG?=
 =?us-ascii?Q?G1xvmwh3zYDnS977VJlGMHgwQwS6m9VUSh93RQp7fazBsYOnGEmAPeu3a2OA?=
 =?us-ascii?Q?JHWKJXBdWqC3SDBIMCNeXUSDhN6L3oG2ri+Bh5i53lT4JzSCSLE+bRpIg9M2?=
 =?us-ascii?Q?VHvT9XiUZvH9nO69fyBHoLh0BE7QtE7G1sqUgCsOoDXMK6duPi612wB2cHCI?=
 =?us-ascii?Q?y+YiE7SwKSJtLLa22wDBWp6jAwWOFC81HyFZ+VyeegZeQ1eLXSyhaqyj8zX5?=
 =?us-ascii?Q?dcg0FuBiu9IEvo4DRmPM2T7DyHCfZwMOouuSJC/JHZ/mFbBYm1KqdBUUYwgU?=
 =?us-ascii?Q?bRKWxS0kraRh3F8ocDhm6Yt1Bp6EYhJwnXEAdKrSvwaWh3cuY6+A/ae4KtVF?=
 =?us-ascii?Q?Rd82xVXOwRJOhc9LWximfudfQZ16BoJho9mxF/Hs1DzGU66VrqapqiFEWb+Q?=
 =?us-ascii?Q?5KThtZxVBkZn4A+Xo8WBlX3tPXaC31KxnMdPpdcz1VPIjCj+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c1f1de-0efc-403f-3bc7-08df036cd0f8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 12:23:20.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZNO8r5ihYIILJOnojqR2YwYSTP40uLiZIjOftAVsqo69ZwgaaskJ8IdoJt4cIms
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8131

On Wed, Aug 26, 2026 at 08:45:50AM +0000, Mostafa Saleh wrote:
> On Tue, Aug 25, 2026 at 05:59:50PM -0300, Jason Gunthorpe wrote:
> > > This is v7 of pKVM SMMUv3 support with trap and emulate
> > 
> > I tried to compile it:
> > 
> > ld.lld-21: error: undefined symbol: __kvm_nvhe_iova_bitmap_set
> > >>> referenced by __kvm_nvhe_io-pgtable-arm.c
> > >>>               arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o:(__kvm_nvhe_visit_dirty) in archive vmlinux.a
> > 
> > I think it is because I have CONFIG_IOMMUFD turned on.
> > 
> > -#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER)
> > +#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && !IS_ENABLED(__KVM_NVHE_HYPERVISOR__)
> >  struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
> > 
> > ?
> 
> Ah, I don't think I tested that config, sorry about that, I will fix
> it in the next version, I think I will just stub it in the hypervisor
> if possible.

I tried and failed, getting the include order right did not happen,
since this non-inline non-static declaration tends to conflict.

Jason
