Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FE1E7C3F
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403876; cv=fail; b=hVIHSRRWWmNY7egmmujwNKCGnYgcmOmD34XHybjCgPzzoVWgFgaMcpEHesbczWyM1TXi6yVPcGfp8Z0BpM6LVGOQy93wfQBziW2OlzOPWWnPEg+1TkZVl8dOv6HgQkRr2C5rsdA16DLSA6hQ7+NpVEsrG3f0V/Y5iJLxCbeNMyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403876; c=relaxed/simple;
	bh=bsOU7OLMPkPBPq1qcZQTEPHbacKB+GckxcGlZ36t9sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SX9G4W65FEdAdv6FW0qPusyGIE/u7TWcyzTsm02shtPiUYmLeCora5qoeBJWYDKgQvr2iUAOIrH8MWM/OqGqJV7SlXe/digR4a7AVMsAMmD/qnkugEZ8fqZK1LB1ZmwZvkIiMAL8X5XbXT222AM8UEgs4sxcHNLDOAOAQ0+NZSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qat7b+gn; arc=fail smtp.client-ip=40.107.102.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qat7b+gn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N95EyL+s0taS5p40vt+aUxT+W+umMh4JC8CJRDVron1wMOvDd2+L+R1dR3stzVTNOqXuax8fxmIqzDNt9FUB5leH3UxG0T7aqdwTmeANFxD+898YvKmxmafI4XdhdcATg3PItGsXLS93Q5nPsIMOJlpn3FKcODv1WHw4ENG+vfKj/bGJQo0QBGg57YsIHkX5fuGsx7MYJK9NfyLsNLz0DvtJPPuWhQOCyGVkFfjnC4nnytpXvgITjGJcV45sR9CpsnG8D2FrevKzYed3Rdk0OMJ/5Zh2rnqVAJ06Xl0+NVa+hcWVtRc1iDzmpaTWD/OLG7MZZewryTCVZj2W2Gz5Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsOU7OLMPkPBPq1qcZQTEPHbacKB+GckxcGlZ36t9sQ=;
 b=ZWEs23/BnqFAqcu8sOf5k3qQ52pZd2TMEyEWqMRegRmcq+IsZZ+ySgittu88RcMACST83OyJp9a4DGitYfISweRHt3aqKfwDauk+xYv/MkF5YN8Bee6vUdn3VxCL5RUqUCtGC04Mvtune6RQNvmWIDMDgmmdYcUHxrXTEFzXiosNT7li4IKFwWUe4FT6wd226gnbhFjgWe45qWEEXDVJNHZlj31ABi+8kYzWqX0RxzZ7NdHYPag4X4UP8qeUpBsGj+xdVtNi/CQ7oii/Ix0prPawKHwEicRx4NOiyTu57I3bilpBX+mG0smDS4AsCLgW727ANyHJzPGhTVHhcVRMsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsOU7OLMPkPBPq1qcZQTEPHbacKB+GckxcGlZ36t9sQ=;
 b=qat7b+gn5DRZOmYte9aI4CkjZPsjbyRV0fXgmvBMnDjAC8zSBDgtcsnjIamjCVpowz/q8pS4OgPbmO9BDs4xMTDV9fAOlT7WvUslFbxLJKjuRlBwWr05vk5OPJr3qnD4bnQWvXJjKmy+g70TacmyOg6SF5n1Qss+UDSYeH0CJWczGgG3igrTYdXql0mc8RYmPyyvHblhUACpVHkHKA65OhvpvUjFWlv6bOVaRkYGq/p2bW7/fM/rgQ88kvViFlZ8kxhl93iyd+zUjzSoZEeYxfO4ocFCY+I8Sz0Md3aTqL3VhG7k5b80egqy7xIqJLS/msUBE4xqwVR4gWGP4oHF8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6374.namprd12.prod.outlook.com (2603:10b6:8:a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 17:04:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 17:04:31 +0000
Date: Wed, 19 Mar 2025 14:04:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250319170429.GK9311@nvidia.com>
References: <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
 <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9pryQwy2iwa2bpJ@linux.dev>
X-ClientProxiedBy: MN2PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:208:160::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c1114b6-3424-4e15-442d-08dd67081d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0kcVZvZThnGKfSvJ0PgOeko+XQlgVj535+evrRki0S19W6ndGYFghVJ2hPYL?=
 =?us-ascii?Q?2SM6yYNh3ofGbmPkP6EEGnq260BZH+9I+2xPCLHMC7/aeH2AWP2oaePTP+6D?=
 =?us-ascii?Q?DLQeBekDrgTDu4uKAfEPxnVkHEYblcxeLep5bRB0BhN4nF0sl1DrE2d7x5UH?=
 =?us-ascii?Q?aHS3nqdRCPuVO6Ov57cTwOcERKvCtlWxY2a42HdIVLYNNNqUN77kd72Uibw/?=
 =?us-ascii?Q?p3qJw0fZ1xTOXDHE20LNkmyr2HyoRD4v2Az0E5H5WOuJsMISG/q5E0tz9csS?=
 =?us-ascii?Q?fOLuI0jX9xjZvxQioFxC1uVaOPJ1c0AhsooHbEAfebHmcvBo4xEMq+rTvW6W?=
 =?us-ascii?Q?gZtzdn77sn1oNDDikzlyd/Oiv2zoysUM2JPEtjLhaF5AYhCJ3uI0c4/55eEq?=
 =?us-ascii?Q?kxPw1eIBRUNTOePCl3WKiI9Cie1Yf2xQwSGLcmUzvJDtoWAOgKa+XL7v6r+7?=
 =?us-ascii?Q?DgLg5J9bvVS43RIVsDx3He9lGG/7ukYu7RjQqMq1W40BN6sauCsYch5sCtOb?=
 =?us-ascii?Q?Wv+oPMyF2Ov4Tp3osu90QVcgZsQKmSZAvlyAWLu75QC0MagEAvWZeHWh4UDt?=
 =?us-ascii?Q?+0gyDUoQ/f5SIMtDpFEm8RKVKuGZWYIXPaA5tkCPS/rQbOtqiZyLi6/sLhn8?=
 =?us-ascii?Q?/xTNUIj667S+VAhAPvaudIIHuydFXtLmha7qdXLtrKk4QFoU4HQM0t/ynk6f?=
 =?us-ascii?Q?FNVbpAvoRfv3tV4gXPa8ogEovbWwTfGNiPenWAU79iN1Y2bgpajBpddlc0yG?=
 =?us-ascii?Q?RSYT2cYRoD/qPsjXIhQ9HmZa1wIyq3iLdqJPzhOmsP/cp5Zxd4fFD8KFlmBd?=
 =?us-ascii?Q?Aps2VY63y2cf1kJcwpm0TztLqgV4VrWe74382qQXPm1Nkmkd8KvSy+yQuRkz?=
 =?us-ascii?Q?uj0H7rLiMW0u/ipyLxiZtnqSipPWS5/y29neLaWkFS09MqtHoOsSpdX/B4TK?=
 =?us-ascii?Q?2z4pO/Wh7C6m8XFqWkehwC4bFfAJHW71OCIYPKrtOVjQXUgSIUWxU1GOkBmw?=
 =?us-ascii?Q?eO2deqGQiRBYBLX5ZHbFBaQoDm/C9jZ/GLnPdvauHIIvQKr4wv8nVZsXvgss?=
 =?us-ascii?Q?MEGwvGMucLDr7rB/fYXHShsUU2/Mh66sW2q/J0aE65oKuz075nGEIihe29gh?=
 =?us-ascii?Q?5LjJqY2GvGCwyLm+hjhrUpk53X6Jp7KZsCTOSEJalOqa7jb53VC5xB+jS3On?=
 =?us-ascii?Q?Iq7hdJ969jqA/nStXNHf4FTTC8BGcf2PqQMCcNyjtFPkFzynU2gNKkoC9Dbu?=
 =?us-ascii?Q?Vvkdi2dZ2mURPbCAMdHQ3pAyfqe0CSO5i3OcZ02M9kXUh2iRXCsrO6Isc9/W?=
 =?us-ascii?Q?OahVNEVIGWqaNffcEvTmIjDz+W83YiiNaUvHLvzlvnh7TvzUu/HVfbSz0p8V?=
 =?us-ascii?Q?/Mq3kXiQc2LhiVIi0tcteje189+w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/wxaN6dkksG9+BBefXWYNiR5ZYktlZd5xXWPXoKtlKM37S2qcLPuzAFQyLAV?=
 =?us-ascii?Q?K3o+36AFGH+rWJnwbKzwS6YA3s0XYyv95UuPyxgh18BOOhbtfBdv0+A6tq70?=
 =?us-ascii?Q?dPncJuQ2w4XoNTmBgO0e7hKQfhhw3QGLsfvuQYXbGMfeS49DukYgjKa8JS2Z?=
 =?us-ascii?Q?hXS8/ejHu+nbtWU/P/CyZ0Szfdj2eZjhJby+Y1JQZSshWXwDlLJDOw7816bm?=
 =?us-ascii?Q?Miq3S3sKd3RbEEpPnRgRI8hHaqZtZ6kuAgEopSgVZRsFkhfJOSduVLf05ZIh?=
 =?us-ascii?Q?BR1xS9CP+Br4VUZvNhWEDZtFYs9qNhn9yqCctt66kV4KtGRreZvC5b2uJXKK?=
 =?us-ascii?Q?z53dhNJHL+r8skmBGwIUBAOcZMyedjoMnZcs5uQTSepRShsB1mShEWj4kLzJ?=
 =?us-ascii?Q?rXd/smDysMgI7yxltXdFu6Qln4YIWWZKe+hc7SHNoryIKf3wxPtOwyGZHH8a?=
 =?us-ascii?Q?jeIn0inhW/R0AVTwhRRdsLI5ILHRBYYp02e36ZBWg/BJnl7VeFcE1ACvR2Dy?=
 =?us-ascii?Q?qr/fm+/VIZWuZ3OX+ozORoHOv9QowlvlEhHeaWEcjVQJ5cSgbQpMZ5aw377H?=
 =?us-ascii?Q?vd2wz8FflEUdypfpTA1Vdk62e37WU5s/9KbduOOoaoHy7Rj36GG49PH1yuuM?=
 =?us-ascii?Q?N6BvjaNpuSojKGvCm2BiI+zKc45vPAoEPkadVOc0ImtwrwPSeothPIMEzn4u?=
 =?us-ascii?Q?DIMualfKSGVsNYik5z3tD00fDX1F/n4YJkLCL22vfHtVdGRAJB2TlXFZhCdO?=
 =?us-ascii?Q?hoBY7EPr4ddR7FBqYWt892ugUIDdJwyAV7Q/2NLvVNAyMbGB/WJkDNvpwAeA?=
 =?us-ascii?Q?ETG60ZuYcmdRm1yyo4DsuBp2LbXf/R/Ba8wOjdOy1Mprs+Nx2U0L0UBSfadF?=
 =?us-ascii?Q?+SL/Gg7mNhpyLDByoFejgTFO0+BVevZRehMhI988KmRojffKRBhcZHZoRRbO?=
 =?us-ascii?Q?nQ116ave0puYewnjcnhrCX4EEd0GtsrGwDuRVOKdOEr1aepIzORsedOfNng1?=
 =?us-ascii?Q?Fz04nOGqzoKSFdkuRA65kgXcZAsviidUQi4fp6MwpwgcFEi03tmbeVepPjT1?=
 =?us-ascii?Q?3Da61VNcxqEv2yyP/o5vapm5Uv4xFN8rhPHHE+7mEaMU5Q5oYnbl8rDMDobf?=
 =?us-ascii?Q?Op7W9Ss/O4XZfdZOQGFQN4BdFg1mH7I0dNVZOUhRILkRJAtsHgHwdsGAt8T6?=
 =?us-ascii?Q?Xw+6GNWSGYt4H8JHTpDNxRptvhckyLiREUYivqeaRTWBlfUUhpqnMSr43uNI?=
 =?us-ascii?Q?xSqKvd+38fs1oRWILh6vKD8GXeTd6k173Fi3Lcg3QusuXn/tRASrrU0a9qnN?=
 =?us-ascii?Q?p1P/9kfV7Cs6GGZme6S8ZCBuWQ1S9Z8I1wLHLDZn3+GEaZvpQfcPZw+gpyFp?=
 =?us-ascii?Q?b3p7vxgh/CC98MvadKmb95NUQPMa9K78CJbDDDZGEGkXoXgdXZn/1NpgCPNd?=
 =?us-ascii?Q?kN3oQP7krWGbL9XvNKyB6GlhuurM9mY/zXhnL+YxNPxrNLwb6zeLtAMXT7iS?=
 =?us-ascii?Q?SOwv5NPl3r41EfWy44qk0Qpiw/BQ6v8dGwZVtxRQ+jF9fwtYWcTd53sCHEZg?=
 =?us-ascii?Q?jIGyheiVQK4ocG3na4o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1114b6-3424-4e15-442d-08dd67081d6f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 17:04:31.0145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/O/ctYr11lwc12kHsXLyctyXeZa16Mb1EZRVCTI9OY11Ouo+s3xhTrLdOcjldii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6374

On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:

> You have a very good point that KVM is broken for cacheable PFNMAP'd
> crap since we demote to something non-cacheable, and maybe that
> deserves fixing first. Hopefully nobody notices that we've taken away
> the toys...

Fixing it is either faulting all access attempts or mapping it
cachable to the S2 (as this series is trying to do)..

> We still need to test the VMA flag here to select Normal-NC v. Device.

Yes

> I'm less worried about recovery and more focused on userspace being
> able to understand what happened. Otherwise we may get folks complaining
> about the ioctl failing "randomly" on certain machines.

Even today something like qemu doesn't know that VFIO has created a
cachable mmap, so it would need a bunch more work to feed everything
through as proposed here.

IMHO the semantic should be simple enough, when the memslot is created
determine if KVM can support it at all. non-struct page cacheable
memory requires FWB to support it today.

Maybe tomorrow KVM will learn how to cache flush non-struct page
memory and then everything can support it.

It just seems wrong to be making uAPI based around limitations of the
kernel implementation..

Jason
