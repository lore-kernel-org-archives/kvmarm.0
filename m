Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E420519BBA
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751648186; cv=fail; b=bikteGls52ETs5M3LOVmmoP3g11B3iZ9FOaccHfAqkCxBhDqgY5IRPSEVHWBns8IMXX6fNLzxAB4LNwchCX9TWp/IpuR2pMt/Uw97VAWzeAYToOIu1hNpwIN1uAIJ6BzP1SK1UqUkQmQBluqhsvBlDSnlnn5Po81k22BkAvkhEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751648186; c=relaxed/simple;
	bh=z1znQ4nhfNAy/Zb0Zx3uv6kcoMdiolFgZxFRF5rah5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FtuD9jInTj74hjlgqnUEOz9KITL3dsOBrkY6UtkQG5BwpvxOjS1xxBWOSf+IqXfqBEM/rOIEoTj/YUkhKByLHLCP4tXhksgUqt+IiVF7EWS6K4DLYVotApUzpuS9J/3wSdHyWbG2Lpq1n8xbgkJTiFM/lckylCBnCpp1WvT8q64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k14Bco/6; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k14Bco/6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMW0vi64rlqC7s/N8JCgoaW4ccw4x3CFFJHeX9cxMRSJazj7Up9MPl74NROWZEej1P0IrU4VCsHk4RISykGlg05sHKIua5Wl+2ZXToU8YcWNmpueOZQhUl4IkeVh/dJPJ+18pqf4tgsYlTIV50QybK/eazViR59HXCW8m0SK4ySLHx5H19IB7N6XncznZCVfBv8ECrZZq57XI4WdE9P7068998vxpewhfi+rFE0GPZFbXhmLyUZwtuZIL89DVvgqq40nDgM/wHM/Kv2xjg5Nq+7WpF8/+bhEKbWblsEZ1VPrXEPaL8azCOcaTyDQRc8XDOEg9U9+7frriAp4KKzbrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gELlUdVkbVu7fe6wiS1jBCD1PqpeBflfBNS5d8C81Ic=;
 b=Ww8ckcZGnG0EHUtkV7YjSN2IQgPVfPLJpRWprYpX0G8M86Zq94Qxb8sp9KWoDKjM5pMHE8cXjNlCdKwEdoZ+V47jOFX2WsNA7+7b8FojI060VllvgzEJIPICDiooRjldjm9OuuGUxGWUe2TObpeYg1cQyL8sS1a0ljTtgO4HB+C/YfXjBZ4Aju9AEwn8bHRe/3Dc4qGd8OrTORXejCMRqIjCgv64hCWqghB89xFcagCucKpLnzEgySPtNdDZG2DUOx59i2IeOJuzC9IdS1HHOBmPQJjmxYE16upLFjvPvxKORfvYkX1+TOqYhxRXkdC1vPcVRgSgsbGcymeoTsxOBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gELlUdVkbVu7fe6wiS1jBCD1PqpeBflfBNS5d8C81Ic=;
 b=k14Bco/6PR6b5zXcS54gyOT0ar1kPt+UMKzpNwTEv2AeGu94VwNSVBE4GfKxg9f97lV6u5fbYyzCyTYuQHd+parHlklDIsZkIPygB3QXjZcj+F7jDTj7rUKbO5Rx/nK3oKpjzimhqkILstHKX+o+fIYZi98RxKwohvYRGO6negGbV+Gjr+9YNW3jg5FBg5SZTsfKfA7Y959l0NgYPVbV9vdOXM74OJw/PGhCcm3NFUkRCn8aD1yXhLjo+7e64OVyxu0Ogi/x1kIIflKDkm+GyDDs1XqFMhu2kdiRPiXoNDCt5fq0SJ4NXr68U1IM201m6Ma0Pu3f1ddxB96fpN7CDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB7822.namprd12.prod.outlook.com (2603:10b6:a03:4ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 4 Jul
 2025 16:56:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 16:56:21 +0000
Date: Fri, 4 Jul 2025 13:56:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>
Subject: Re: [PATCH v9 6/6] KVM: arm64: Expose new KVM cap for cacheable
 PFNMAP
Message-ID: <20250704165618.GP1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-7-ankita@nvidia.com>
 <20250704134413.GE1410929@nvidia.com>
 <29cc7d2a-b174-4ed3-ae1a-22db478c62ec@redhat.com>
 <20250704150442.GI1410929@nvidia.com>
 <SA1PR12MB7199AB9F09DF483AEC41777AB042A@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB7199AB9F09DF483AEC41777AB042A@SA1PR12MB7199.namprd12.prod.outlook.com>
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e06118-7971-42cb-8aad-08ddbb1bb382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uylg3Kp34EjUKVsYHwFw6irrdBasQYZWyp6U1rB/aoHigCHZG2Qe/AcPtQbx?=
 =?us-ascii?Q?v9Nlr5cLvS1EC7fuJpFBqR8o9aORkZsfScLQcTXPXKZ74MIrmJtsSqFXmsN/?=
 =?us-ascii?Q?z8ZWjc9VmC3Qf3cbhw482qEvk6dRu4oHUg+4MEWsBr6PgAtke5c0TgasfKFj?=
 =?us-ascii?Q?BOSMBH2VlmAUP6uYOGyLwu9jsMumtxLt2PwiKktFV3gyPcdU6V2BHKq0CPPZ?=
 =?us-ascii?Q?M5Z9dLhoIKzc6ixfTAlfQsfsTq0sG8YfInn0jsRzjy3fIrfVo92mqatJrhPY?=
 =?us-ascii?Q?QAO2KvPUZZS1XDox4I9VWbvFzbUxdluFBoZhq20Kt13v7CN/TdebA7ISbwIS?=
 =?us-ascii?Q?4Fj8d/B5kksvVzej+noXBGxEG1WjUvRQZCvbG+ptiyICLyCsO6dqUBx5bVc5?=
 =?us-ascii?Q?E+pHbmROoyyazSOfuKnEc6qmcHPrR8ZYeH9WaY8BvMdgEN8YBOS4yUZ2VqIh?=
 =?us-ascii?Q?EAwprP6Ztj1HiW1ptsdjeAdOA7y+4wqagh3AV1bd+GO0GALqzNwMUn8nio2n?=
 =?us-ascii?Q?9Z0p2xP33Jyj+00vPsqKg95/Buab3/tfFDYioE9Xmhq4y1m62gxsVkiieHes?=
 =?us-ascii?Q?ATKPXMyeYyG80voAd1xbD3DBgWpa/B8g+wgOoMwfwiTmfu+csV1UulG3/uPi?=
 =?us-ascii?Q?UMKAcMv6/smZVL1SgIU2yC1BFEtV8jRO183SyS8oTtWqGNlaAbrSezizwS6x?=
 =?us-ascii?Q?smdqCC4zQELEn4vKIV+XJVdQ6+e8FjA/U7YiA/KfuROZUeJnb6WzsnaQAcvs?=
 =?us-ascii?Q?aL9fpTBWTcpFw6wKz3Z7HA7Fr2BRXCvA/bbSNWdiXZiMaTns0kfwzNj0NRdL?=
 =?us-ascii?Q?/jZNF8JUrC/GX3mpLKrYTVkIBbvUOPf6zah8bn4epzMNf0kXPzJakw3ZoyVI?=
 =?us-ascii?Q?Gu54+kNCAjPcnmi3xp/eY4UyvxJtusuAFMJGWxVEv4drpSN1Lz6Tu9DBN3ZA?=
 =?us-ascii?Q?b7qEijllAX3vckXptyGIFp0hUoJOBeRD+cSN7UWLEoG/+b/xzAu0trKHYNg1?=
 =?us-ascii?Q?3LYpWiPtIFDtXaTPUqKuI+Nxd6jH0TYi3cMZiLrD9a3YmBErVBdLsTugCRXd?=
 =?us-ascii?Q?tGNnT5UXODdnB7yfd/IT3d/2qt3B6e8Cy1P22Y3p7RHOPgjPHUgjQGHnmFVx?=
 =?us-ascii?Q?8P+GvplsLXBeGID1wU+9L+09HQ6iUH0Y8EzSgfiQ7ddl0ZADnhq9pRotBeDx?=
 =?us-ascii?Q?QNG77ulmLKQsg8sWCRJJHqTrwfZ5T45kHi+bYecrhcFfGr89F892VAZ6mNaD?=
 =?us-ascii?Q?WvMxVePVewxFuekMwAh94n3ULwpCUym3fjvSEE6xT6JEzfthdQ8z8sSFDC6H?=
 =?us-ascii?Q?ESi06ekRRq7mEIHt4ftYlfjW5z9xYczhZhP65uEySmHk8z85pJYbw2dGeG/C?=
 =?us-ascii?Q?gq9yjOmUL2R3RmPrXmr4aDDO81xE6dBntJjb/DpicENb8LTTLx0sZtqnjK+P?=
 =?us-ascii?Q?1J37q2ipoqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5wL1ItdYecasTp434R93OIHcMiCl8VgZjqAblKya6la6kCAk3s024dj/Os2u?=
 =?us-ascii?Q?Uijx8+OoeivbvtMiX2l3DTQh9g6kNQOvL6H6p6qB6avkiDR41C+ATyKI5U0U?=
 =?us-ascii?Q?f7yEE62CnuuSbvxFw+hZeSgRM6nZryybFbsOGaemAm7VZJ0fTKoMfoHYEgrY?=
 =?us-ascii?Q?PnQapOqh+2QN4kdVrvv6IfrYOsthCI53t5lBLN0eVAzSNYhlzwIJuu9DWNlf?=
 =?us-ascii?Q?wOWdvYXDTjxRR7Gan01lQqxjulw1WDuGDKoxtoBQ0JNQTB/0XvZBCS6I/wIl?=
 =?us-ascii?Q?Bk9ARu2MQYsNlcOT92de5RRaTALr9Gj/ctEMRFFF57nDieuGYQWU2QJ0C8Kj?=
 =?us-ascii?Q?EHz75PbaWD6aRQ4UhhSTakhq7Zth44f74I3giCFe/MNcVjxE+oQmGHZvZ/1n?=
 =?us-ascii?Q?U0AGsn6fTctty0hprPleGYjrZtUwUI3uuTgGpNR7fDAXqKXaZVn51ni5X4kt?=
 =?us-ascii?Q?ssuK5T5IqynWJ3LO+/d6iaOlw0A4uK7d8QCwt3DUAzniDIbROFD2r8FWwGnx?=
 =?us-ascii?Q?DNC97FIYGqPW+NJ41CEVLEo1t9X4bGgpoi4pa2e8d66q4eL2un6YvICv2WqO?=
 =?us-ascii?Q?IRVK972aWfRBH+71fEHmq7xMsJay34OhPcHIG4lKhevZpCEvTKVfTuLODJLX?=
 =?us-ascii?Q?hNkMh8jLG/6qDSSYIjkseS+5cwWQ0zUy3+XD5lCGa3sY3Y8cs2qJX5RSgStv?=
 =?us-ascii?Q?kuLXLukjBPkemr3bXnCMkTv575WlkOQ/6o4gM75GxlTNtLjfimKnqqhvsDD9?=
 =?us-ascii?Q?ZnbXrhIyByy0eovSTWwhCcGE59dIUchtgk5GdVbQ+Llv6iivgAiZeL9NjEop?=
 =?us-ascii?Q?YOzlnfwkgp2BNEU6BT+Jd1g36oVnQc1FnCcntZ27/JqOVyO4uLzDtytHNny7?=
 =?us-ascii?Q?GinQR74N83+x3NI+PnZHEB/XEloCsUTsYUxw5Rns/YhMCOrGMfRAPEcc8uYM?=
 =?us-ascii?Q?iGfXWc1osS66ZCWex6j1DffT5rHSNPxzu/NSUv1SgWpgM4gKuPe/+3SV2NFA?=
 =?us-ascii?Q?ND9BzCqbtWeJN6QvzxGiUd2IO/5iirE5qW0zjINyy+rfpYNxU4UMfpsDp/FS?=
 =?us-ascii?Q?jTIXso1+It5EA7ukw+Ygi1/zB4uYmNJm0W3mXQV/FfrIPAN3t0fsW7zDgph4?=
 =?us-ascii?Q?Iky7VdLWjiTji/VVv7mBUcRHUc6gDVaJiFkeJwmfSd+MpBpHuXjTDV5JpTrL?=
 =?us-ascii?Q?YwdXpWkDvpkMi0mWpy/DW0UM/jmKRiJ5D48fHLOgmocbKJlxaM9ZirIXLv7u?=
 =?us-ascii?Q?VJOeMO4KILvb+9S8eVHkmTheZvH7GVqxOwdyE7xo8eLvtXj7Wt78Iq0xr+58?=
 =?us-ascii?Q?LQsF+XkhrLm88i9Q6lxIzaw7vMYP4oP7n11J552aPYDlOMUHmkGxg977p97A?=
 =?us-ascii?Q?IUeme3/Xge9FPIDl6ZNkTSIcaDF7D5HD0Fx8Es4cdV2hcDI1wPAAXc11/Omq?=
 =?us-ascii?Q?Os8ag2xJjU5PxjD1jollsrxVDOUCm45O0DGhpWAlVAH9LZpjWgAeY3Ev/qQZ?=
 =?us-ascii?Q?Pl9F/0K1YDuYtzlF/eC9q+u4H+J95ibsymNV2rqLV1NxeOLHz6I2cZbd8ZQ3?=
 =?us-ascii?Q?w+7L565RmA0NYoEPX2XkU9jXohIUtwAFTRbmgGtF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e06118-7971-42cb-8aad-08ddbb1bb382
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 16:56:20.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWtHugvSVcGLq566KLDBO9LYx2X10vHNdaL4sPXOtJkJpK8k7fEXKZEv2NAR/fjL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7822

On Fri, Jul 04, 2025 at 04:20:07PM +0000, Ankit Agrawal wrote:
> Thanks Jason and David for reviewing the patch!
> 
> >> >
> >> > I don't know if any VMM will ever use this, but it looks OK
> >>
> >> So, should we defer it to the point where we actually have a use case?
> >>
> >> I mean, patch #4 could be simplified by modifying arm64 code in patch #5
> >> only. No need for a common kvm_arch function etc.
> >
> > IDK, I think Marc and Oliver are right it makes sense to have it, I
> > just don't really see how a VMM would make use of it..
> >
> > Jason
> 
> Right, it was also pointed out that the VMM could make use of it
> for early termination during VM migration between incompatible 
> systems (i.e. across systems with and without FWB and CACHE DIC).

In practice it isn't that useful. 

This is all linked to VFIO so the receiving VMM and system must
already have VFIO load and must already have the VMM told to use the
coherent VFIO mapping.

It would be a serious misconfiguration to setup a VMM as a migration
target when the configuration can't even boot normally - because
memslot creation would fail for the VFIO coherent memory.

Regardless, in such a case the memslot creation should fail and the
migration will abort.

Jason
