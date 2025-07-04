Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF361547C9
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641489; cv=fail; b=LKwCegPDRp8lauIPThqoQNDaPuHt+dao3jzqNYfZXOOCn6jor+mx+TavV+d+wqLPeaB7caCqU0Re4wQeBwS5pnBzYcCIihFPtGr6GAXRdfod6T+P9Scl4FxkuJgHqAswvtobfbmVIGigRULUWgU1onDCpV3Ys4sQuFpbjjjG8iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641489; c=relaxed/simple;
	bh=SpC+SV7dhHjR8JuTkWS7a00jXUu1AZxLPQNMPI3jtGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XBweuwhVQmIMEYeOiOmMA48DyvHLhTpyas+SicRsGNfBcXetWX9mHPT7SrrSbcjLDXAJ6gnSn0mM26F5FBD1g4SmD+QC3t5l/hNeTwgmWiBvxuctLSVszaUik51zu9JjdEVX/7DNrHUUpRs/xWkef7BDo3EL9tRkNRmchBS63HU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WdKLKeL9; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WdKLKeL9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIMayfKnd6orYtWduPvZxsjZ+BDxUMXtpXFHTkaOka42b2rfPIULYVLaH/pcLmawEbKxBH0oNGcfTsj4kmxtJgKAz62NiUp5N0UVnjeGUv1/XYPQ7nwI5CxZ1MxQ5ZLixYJqrhRWePER/drXe+8YU87+K6tvtUd8EP9UoB8k+MGc+mIM1QGomwZoU4q/6vdsvCo2aXxSqOHvKL2pGgbjoihu0x+LUN7EhGu5xz3J305qFdGrOd4NhH9lFW6xtJ6XraCtnM9of0y3w6adTUkbS6gyCmTUTAHt2siWWZAyozpPTGsmA93M5xfy9AU0xDSj0HU6Rk++xigyZOAqj7GX6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YdLrtcWjC8TXgcV8EEsUT1uJOEj/REERA7ISvmB188=;
 b=sL4BhRzaAYGDaGNr/vrg2/PF7MUrKGI7zfLPHU8CQSjSSiExo9U8JMRWONoHILbmLvAEGj3huhD3zeor6Z3Hq9t/rNM7+W4rpRdPm1nZlbq4FScGQMAiMlQ20MNO0m8UujsiS2OjP3otzmPYyjZyb3sArUn6L/sJ7XIapetIA3jGIJsclyWn9HZb/X3EJgTdU6JwGls4rgwzJOw/7rZkhf5TvhUB5bp68basI1xpFTdQLQRLizsfztXiECGirXxl7U1PrRGckhrJi3SLNAJxcB1YMQ7dV31MgTE91K5Riq851LxIASuyExcqJwBjHBfNfocDdrvEdHOFTtjXqwOugQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YdLrtcWjC8TXgcV8EEsUT1uJOEj/REERA7ISvmB188=;
 b=WdKLKeL9jlks6aMhpWXckiilMjm9j3LaVCOqG7RHu86AkBKeL195BotsUhHqG+47snh9s66DbErMz2tV4lwxYQLVpvtvha578xBaU6ufwbm8PKK+91/IvqVSWEYf7NBJRwc59NA7VERKa8ZC15tIXUdctBPjMfjefEzwVdHQU060/TtcqshDbvvP1s0qPii+a3cbgspzH5Al+TiNz1D53PcD2t0/tuGak8qwtVez4JI9N75cJrjr/GqIy41geeIMvjhhEEi5/cgXvzdRwJGWgRR/6F/Nf9K+MBec3CKTiS3AK166xP70YEQTkXGc2QQvxZHubx1Pgfp7uQ8JlC/tQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6468.namprd12.prod.outlook.com (2603:10b6:510:1f4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Fri, 4 Jul
 2025 15:04:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 15:04:44 +0000
Date: Fri, 4 Jul 2025 12:04:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, ddutile@redhat.com,
	seanjc@google.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v9 6/6] KVM: arm64: Expose new KVM cap for cacheable
 PFNMAP
Message-ID: <20250704150442.GI1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-7-ankita@nvidia.com>
 <20250704134413.GE1410929@nvidia.com>
 <29cc7d2a-b174-4ed3-ae1a-22db478c62ec@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29cc7d2a-b174-4ed3-ae1a-22db478c62ec@redhat.com>
X-ClientProxiedBy: MN2PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:208:239::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b64b77e-6709-4d4d-876a-08ddbb0c1bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YIolxF4JAz3rsdJGpiQavif1w80pfwXc0cpLXeXz3G8r1t79IHl8DwJxmzMs?=
 =?us-ascii?Q?/dKqKTDxJ9aPSR92luod5/xk+LItpYclh+XQGQ7FFBqflHIVKA664KkEJ25v?=
 =?us-ascii?Q?y2NVD1tESL4g47GJrEDZArpnzvMvdgyEbtI9m1QkMM5Y1W73/+u1cTgS5F5m?=
 =?us-ascii?Q?NvCq1u8zVruvAwuBfvkp9FaTFyX1ej/vzPhcFNns92E+1yrxxvEFxIEy3vK/?=
 =?us-ascii?Q?qCBIaa3UpoDlnTJR+/e7FLwVuMZTBTA4HhC4lJZsz3FjDVexP+OLYKTpEgic?=
 =?us-ascii?Q?fBkPZ8ahYzJC/OtvMGbwuv8iyfYncuXTReNEm4TY3vHeBQ6X96X5MObMZxDQ?=
 =?us-ascii?Q?yJFLA2r/b/653CdveJ8wCWJTcIIS4Hl8FodzAwGAWpSKOrjy63uAYfUxUT2j?=
 =?us-ascii?Q?5BKPMu4EwCeid+WmchH34oBbKkjKmZNXVLjnlcsZ0/wNAfxzEK6S2q6bm//y?=
 =?us-ascii?Q?CY2uCnPY1VExJlT6lW99wKuz3hzULfkg3Vog9vnOmNHvg9QyAL21Ewfn92ZW?=
 =?us-ascii?Q?t3Qgz5VSIUn0AbtmpJuDRRR8iOgJdHIY+ulzPIUqDR8CdcaQ0EyXxBwrQW4S?=
 =?us-ascii?Q?uDlQJ1GUvxo7AH0Eq4NrBtkvv+j1SSZzbc3u7D9G8xPLSssBqbvLNM5RKGVD?=
 =?us-ascii?Q?Mh0823hjZGYJeiZZPUmYkHh5DPOmri8QI1OnXgkCjfndGpdsFnZkMUGWo1bd?=
 =?us-ascii?Q?y7VMJQIql9LpY2exkZm+/D/viAfvGKdZi83yqbvFzVB6ZUaIN8K0nUShvSJj?=
 =?us-ascii?Q?mQcNUvs61GMei252wIdh/aA0zh+SvvT4+Ke3U1JSaPQu7uf7x0NJHvNHzVIB?=
 =?us-ascii?Q?cDxB41drqU9jrjQ8ljGxvYtYx3hMJV/lglpdaqH64Sg4rIRbNjH2JR2vnQmn?=
 =?us-ascii?Q?+0ngVChUcVTNchvS5SSpTZViq/1rhPzlVNBMCsAn3rEpSd0gyyeQDa5NEURD?=
 =?us-ascii?Q?5YKt+lRDp3oASxO9ATFTWfGydpIGoxdLrP11g/72+iaFxmEAl1dZ+BQtzeXl?=
 =?us-ascii?Q?0EqLvbH256YnTtIVrO6fOSOjFFt1/ZlpBBjA29JAgfM3eRseV6rTbaSo/1De?=
 =?us-ascii?Q?iodFuQ7RwD/v+NaO+V1/uujQxvCHpUg77I0eNzAwE6n7kP0YrLQWuV3AVqVf?=
 =?us-ascii?Q?B3aLlOlrfELdT7jlozq5Jk8qFqXPiwWWXSeZk3UesGx2wivoYcV+EIZV+pxm?=
 =?us-ascii?Q?lnNVc4NKckM0Wsy3WJUeT0U8HYxjGyj2QFGuHmjQn0UnwS9AIKqu8oJGeazC?=
 =?us-ascii?Q?9pqq7Xpv+TUeK5hbeKzmQMnMMnLobreRbutx603P5FE5LODIW511D4q22cg+?=
 =?us-ascii?Q?flLfAL8sliQX0nBTkDCfN5Y9i3WeGkenpLYSqAnOyv/XbhQNXoT/j7Be8/Ih?=
 =?us-ascii?Q?YGbRYd7xpMR9xwSGxi9NjEoDaiThjIXjehPu1S7VlSra7P+PVNTT0+hT66TE?=
 =?us-ascii?Q?iKtu2Bw2Zd4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ufrEhsHO4ZE33ZvKpTQ1Zr1LhdhbfFSMPCGpTnnDRmBkchg8R24y0oRa+arD?=
 =?us-ascii?Q?kHB+A+nhlL9tPy5px/LxCiZLBpOaa6X1pYXXOVTZfX65F/Bo9WcFlm7aCkbU?=
 =?us-ascii?Q?ViGJS2tUrwcc56++vMV9b5/nZap5P0cna/G7NiMeTsJ+F6lm/Lk4mGwWrqax?=
 =?us-ascii?Q?fNSpLPGTjdJb93RIO57x9EjY1DzCBQb6UC3p8MpIaeNQSEi5qr+V954a8IBV?=
 =?us-ascii?Q?8UZz0/QdZczx/qSL541fWc1T5yGpe4d9pgpiYjkRl/T78mZLmgTrWA31FTdg?=
 =?us-ascii?Q?MFcXxXknquXDxo9ApKaZUjWG3dN+9nadopAQO6Krw+SHISrnpU5dpSOjEunU?=
 =?us-ascii?Q?xpRrzjywziKZjzB6dyKygWIGkZuomMPMY1KxAuAyn37/lLgys1JWCgt4wCFb?=
 =?us-ascii?Q?NGIP0FMFdwjLpl285fzz4jecj08Ytwb0e5TW1Un12Zq5BYi2vDj32+WsQeLL?=
 =?us-ascii?Q?UyJuzx0NsilU84DNFpF0tgw3zP0cFE6FRPI0ta6jiuUSGv2S49u2l10cJtTr?=
 =?us-ascii?Q?ipI3EBSJafnpI6dNuBY4/iI9y0Smn8LSNaIAUTkl/YCANeyaJ+Y0U1J/o26J?=
 =?us-ascii?Q?5VV4IDzTrgydBH6tUYcoqnW2MTE44JFfMzs74vg+0R7NWWK5DsA9VWFGfgf7?=
 =?us-ascii?Q?a2kAQ9f35wkPDqFJmOaaEwzFqSkfIZs8lQeYkiXBaVNU+XYjIraLAGk2j9hD?=
 =?us-ascii?Q?aCJ+x6s7cfUZhg7UPLDBXcjp7lHi8jpe0UAtC201O0pK71/Z7+5TyfE75jgd?=
 =?us-ascii?Q?OpJfhwyFH22asBmSzc6yzdkVcnHDVOaxcl/LkdKAv9hJmoqyFrvL5A3u6Rag?=
 =?us-ascii?Q?FHbuo2GweWKNwH3Nc905OPIrLJZvvuRA2AdR4VdqDnrVMfUUMFIZhx6wrr59?=
 =?us-ascii?Q?szM/lAv6DWWN+EllN6OsXS9gAaBFbbogYLYjgjMnm7XASNppQmQx9dRvRAqO?=
 =?us-ascii?Q?kZ1ZmD7IfWtG183nVrSghuLrmBs09c0dv0MT8UyrEq8YHwqS2KMYbmAalAz7?=
 =?us-ascii?Q?SnLju/fPnqHonUSFEatfjWSBrNyRiCMzHm7Np217uT41NzS8QTAuxqlj1Ija?=
 =?us-ascii?Q?SWI79Rej5Fic/Wo1wVNEnpIYwivQFL/7KVIhro3AdlnzacqhjeS01XliobK1?=
 =?us-ascii?Q?0bQ/bG6/BgocnI2B8Kku3cgCN4KpPVGcwPNeUiOLZyY0yVi7+SKna3mtbd5g?=
 =?us-ascii?Q?YcWHVYmLubA0nllq0EDsRfCppqQqlR14mV8YIJsiknpWsfOgqy4JCiN6RLmG?=
 =?us-ascii?Q?CfpasCx3x5R+946UzJGoM63/vpas24iNWc2liiZHpdMK3pQjXpnIUdOXeTPu?=
 =?us-ascii?Q?HTPyDgRI/gAh46oKnpaL2zFolLI50jcaOnMena0x0TQIk9A2W2aLHjHnCT2C?=
 =?us-ascii?Q?7LpcNc7C3VFZvIf0q4/i9QHsBdMlO6vrtTnyzOneUagGZKuHciE+hkJ4uGgi?=
 =?us-ascii?Q?/SvQcYHoALBqYUiY48peRIG5UVlGT0kwqAQJyFhtMBuGkbCFIuOTIhkJGXEb?=
 =?us-ascii?Q?XyYQppVuKbBntY47bE37AHijePA9/ff8dNeGi1Zay0uinE4mpjwrMFveeBUQ?=
 =?us-ascii?Q?y9UJv2vtg1Sq+Rv3WBRoPsLbXfqsIPzLSVleO5gw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b64b77e-6709-4d4d-876a-08ddbb0c1bad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 15:04:43.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4m57VUMCSivSGqGx+2H7IFonh/On1B0vgrVI3X86WK6/RBU170+dU2Jo0zhN6ZNe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6468

On Fri, Jul 04, 2025 at 04:15:28PM +0200, David Hildenbrand wrote:
> On 04.07.25 15:44, Jason Gunthorpe wrote:
> > On Sat, Jun 21, 2025 at 04:21:11AM +0000, ankita@nvidia.com wrote:
> > > From: Ankit Agrawal <ankita@nvidia.com>
> > > 
> > > Introduce a new KVM capability to expose to the userspace whether
> > > cacheable mapping of PFNMAP is supported.
> > > 
> > > The ability to safely do the cacheable mapping of PFNMAP is contingent
> > > on S2FWB and ARM64_HAS_CACHE_DIC. S2FWB allows KVM to avoid flushing
> > > the D cache, ARM64_HAS_CACHE_DIC allows KVM to avoid flushing the icache
> > > and turns icache_inval_pou() into a NOP. The cap would be false if
> > > those requirements are missing and is checked by making use of
> > > kvm_arch_supports_cacheable_pfnmap.
> > > 
> > > This capability would allow userspace to discover the support.
> > > It could for instance be used by userspace to prevent live-migration
> > > across FWB and non-FWB hosts.
> > > 
> > > CC: Catalin Marinas <catalin.marinas@arm.com>
> > > CC: Jason Gunthorpe <jgg@nvidia.com>
> > > CC: Oliver Upton <oliver.upton@linux.dev>
> > > CC: David Hildenbrand <david@redhat.com>
> > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > > ---
> > >   Documentation/virt/kvm/api.rst | 13 ++++++++++++-
> > >   arch/arm64/kvm/arm.c           |  7 +++++++
> > >   include/uapi/linux/kvm.h       |  1 +
> > >   3 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > I don't know if any VMM will ever use this, but it looks OK
> 
> So, should we defer it to the point where we actually have a use case?
> 
> I mean, patch #4 could be simplified by modifying arm64 code in patch #5
> only. No need for a common kvm_arch function etc.

IDK, I think Marc and Oliver are right it makes sense to have it, I
just don't really see how a VMM would make use of it..

Jason
