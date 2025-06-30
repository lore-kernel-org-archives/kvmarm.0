Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43B1DFCE
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 12:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751286310; cv=fail; b=l1A3xdL8mwLvvhAsvhRywfX7k0f9mdvfXQ9NzXnxN+1U2kybRdR0ax0XVCFdcEn1zqK32hrPl4uoRSrIOQRaeZXRQB8HVh5NsxmQJOiEcBCBeSvum7SgtaQ+b2sP35jwhRGq3dr9qGtESsBn3YztjKId+A/4pIRKkkhn2H3BXcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751286310; c=relaxed/simple;
	bh=hy++2eEmr4gCc9Txan0SEWSA+8bpM7MdKIc7XMNzYk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Aa33cyqdelaEfCjEAMKiqdbKioMXWm6z8JeOr5HkE3Zq8+6RSJmDuQiTgwVHf5i7+bhpMRc7n+vdm2Y4HJx7AESbKEhH4btM/aWtZ7nL9wrbJ0wytFixOLkT3LMc1tLJM/BbmEdjYp9PICVBJTEql8muVSiGuBWdqGG1xtOp9+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ToFxU9Qw; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ToFxU9Qw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YR1u9EGBRqFyBMooQkaV16yhbSm93ToeNEg6iGWqLKkVrU94ORaOJkRDnhQa80HQpw6NEf3kuVdm1E4Eh3K4z+5aKa6ztAc8YPUusmPrQtoTxIubdoSLj7fmcuAsx3yZV+cbOkje1FiYGrlP+tiPgVxLB2wjfelwdgiRlPnRvS8x8lyK0EpAdP4vTt5A2XMOt9DbnBN1ontuUoq9eb8hJoJVyubUrKnCf+gerplCDrvB+6gadVrzybhL1QFXIUDM8x592NBFFxK+mX6M8nna2rUjSMFIi55YkUPmVY9PAFQ06SITJ1WgM7SOxK2LjC1/up4ah4WhBwi4rMv5r98C3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCmwF58Dzf5Un5j2db4gCPLtY4aprNw+u7//7Sv7+Oc=;
 b=FLGDZJ5VJfJywKyo6dWPSp122m9q/pdSv4MCSbBeSjKzd5EHrUYI590p7GgwtRaSrgdCG0Pl5Wme+8UCJOZ1SdgiOKo/LQivfHnj+PcrVG/NS1Uw1sc/ZPXzNJItg5p7ocbTn6Bk8+1YvEmHZ2zkdzhmJQwT6Dkb9CPvj/F72s2MaLskR2M6VIKkkJWfFG0zTdkH4VXEfcOqW36qYJp2f+mo7Sfx/o91I7594S7wNkTq0du8Z612fhTLNq+j0nSurDBdSLGOlCY1GRGTdfHZLeE91HFA4V0b+Zj1QPC1FWvZyhEHLT5AHcZt8mZCI52ZCam9bGGDjzZcq0hJKcDiJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCmwF58Dzf5Un5j2db4gCPLtY4aprNw+u7//7Sv7+Oc=;
 b=ToFxU9QwX1rcSeqpAGCvMxmHTLHxGnccSFXr/t1NBDCJWTiSgxSiQ2V1bacS5Awu+Q3ctfB6gsjcpyxcTvLJQyZIATxVm3sUXaOf2xtkoWhUN9Xf3leRSZ8rs10Jlul4g3MrQ9UjV9IiItg3d4zScLFGxNqbs2OxaHp2kp8vciMvBnFFVy9d2tpm7RTkDxasxUarOMxKOYZUMVPyamWnU199a7li4xvvd52DzXS+rEsiGZaJY0gp96agbSDox0qGI9aMpEVvx3gbVSEmRGeys5i3OIAa+jUQLYGQLb+xzg8svvSSfTXZZmUwIm9U/VUU78VjwKs5NYzQhM91vHRbfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYYPR12MB8938.namprd12.prod.outlook.com (2603:10b6:930:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 12:25:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 12:25:04 +0000
Date: Mon, 30 Jun 2025 09:25:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Will Deacon <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
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
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <20250630122501.GQ167785@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
 <aF6hamOI7YVDP1Cp@willie-the-truck>
 <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYYPR12MB8938:EE_
X-MS-Office365-Filtering-Correlation-Id: 893c323f-a711-4abb-1203-08ddb7d123a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0kLRhggSFlWBERjczMuF0JVnMJ7ycxW9J0R90nmNnXflxDED2OC4QLzI5Zl9?=
 =?us-ascii?Q?rfrCpDt6RwOtzySgXDHwaddxSAaI8LlB5ghQAKrv3EUzK+4nm2FUCJSgWbBH?=
 =?us-ascii?Q?LxOIQHhPWjLfSlN0G8JeK4X6M/LL+5vSqYgdedGGIMyeX49SxFUgXTPoBMvz?=
 =?us-ascii?Q?OxdJN3UACT/0GOXeGhotpaywihh8IK68IL54aRLD1t09d27mtTXoiqckVFQz?=
 =?us-ascii?Q?tYBPpoL3XAro2nOZaPcdVNPFphAPm7ljwuEM3OKRIq2iJ+WPQCCYyD12xn0U?=
 =?us-ascii?Q?wzzfeN378w9iOQRit70o3bh4cT3Omga/LGcH6O9Z4tvy69ZXFK3bU54OZd0u?=
 =?us-ascii?Q?DPWSxcMYeiwPxL6V931uRiSc2Nee7bu1wq9VuF2khJKpCboNCdp5hBtdUGlu?=
 =?us-ascii?Q?6OVDK44Z8+1zJ+4od+umDRVhjtLN2d8G8HcxkcEKIJukD00Y7xFeA5IaNVKC?=
 =?us-ascii?Q?Mk53NcJaPpFjX8PBQwGEjsCrCgREcYpHNEpsJ98x64f79c6BZvrWJdt4vcvv?=
 =?us-ascii?Q?7BWWUMb/ONsCNh/ILCOA7bcIX7AOP5bVzIx74eAvF9O0+Y0h1/c+7BptIq/r?=
 =?us-ascii?Q?vYVM91y/vNXcHqj+9E396LvMg3hsDp1898Ugn+gVCub2sby8eYK+LyVlWZpW?=
 =?us-ascii?Q?f90GohVXr84N6GO8BXUUU8LK9K3yBWtBrfb4eYtXjVjslRcVPBXdckYM0QpI?=
 =?us-ascii?Q?dIoq031FGPJh7wDt/NvPiKEZhW84u4sxkVtSMydp0lHW79cqr2NJG120ALvS?=
 =?us-ascii?Q?SqNvUkw04oFkrkSdm0zvOk9snVxFo2NeOg5PEVnSF8RfiH4sftPYMTJH5k+/?=
 =?us-ascii?Q?kjurYfJ+eDZ0GBRONOJvjVkYgFPylRwVg4lWWfgybRDyqnHYiIR8Yf0zYar/?=
 =?us-ascii?Q?hyAW5OOxk5ywyOhi1ddUshHbgDxjxQeQOvatNZhI5LQEcnnuZVoe3D9kXyVq?=
 =?us-ascii?Q?QkrtcwC0VasaO+t2iucDjn6hAGZuejD5aQNPRf4s+6oTDpU0C1zHl3LqcP0a?=
 =?us-ascii?Q?Lm1qQ0rF3AIPvGxXMm2EqJLVLFzlx5gyIyF2sXe039W3zlXL1ApXyBp2wT85?=
 =?us-ascii?Q?dnZ1OtcsVLYcOWBeLusxGMM2O8PraaRnx9PLtDlBtvjYRRw/5D5h442rHtM5?=
 =?us-ascii?Q?9NF8Ad3uslVnfe3WVjz1tYGjFBIOBVJdhJCmTxaC35zAHp6enpV5upbGzkuy?=
 =?us-ascii?Q?7QXjo3hsYqE9Jj4Ngtvrx9buqBSSue1QR18aJbHCYDEWddIJV/x6aC1i6U8w?=
 =?us-ascii?Q?bFycQNIQTZdBFnvgOZ3RV8uVDlVJQOJ9q8JZVYtAL+IsUOTmb4inHoJNkcPe?=
 =?us-ascii?Q?Ms3h00YueI0rMo692m3jCJutE0n4KqP9lPP40u3Dyvva/7z3JC1165T5H7XS?=
 =?us-ascii?Q?QQklmwNzLAHJ1J7oLHZ2HF5KPUpOW1W4X/Uj5zYBLDWvp5aw8rriDpWvXfxl?=
 =?us-ascii?Q?CQbvsp8x6Fg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sb98AhdIQiHcJw8BF03YT/PvNkQJjK2MugyqJOomiX2pKILyEZ84IMMWDyE8?=
 =?us-ascii?Q?mNA71lHIsyEp7QWhpwHdFoY+ZgtIyVRXtldUxO75bxe18+k5G+J+3jQsJLQi?=
 =?us-ascii?Q?laq9H15O464azYQWNMqT+4H0Ac6wlaWFzAZb0OOLdFEqP7872dSx7Pn0Fi/l?=
 =?us-ascii?Q?wcNEISmIm9bkqjrU5/CBXK2bwl3Zi+r96A53K+Oh/gP6M7tX3A3d67vzceiC?=
 =?us-ascii?Q?SwUf7RYqI3VFbsJcFeCEdmDMqbH6msXT4XKLbkjKufCqsC97tUxDn/FgIqoB?=
 =?us-ascii?Q?IPkn1Qg+N0pTnckNDijxH5UCj0jZI0/eVhC4TvyNPUB5tMxlUYfuX6kg2KrU?=
 =?us-ascii?Q?TPg7jkBmOXLvYT+98RmdC0CbRM8VwWFFKzDCA8gTQKG5VIi8sHaFyQc++ZjZ?=
 =?us-ascii?Q?Ru+zvcPbTYdOdz6GjrLiAERnJR+KQR5vT0d9wvHCDT1+IxNLM0ocWr3iDxtp?=
 =?us-ascii?Q?ClCoDLKL/haJcdFH4lGK5uIvsENs0GqHcf2LhNpRivz/2xxNhmblkEwBjhcl?=
 =?us-ascii?Q?UWyKmxWIFMYUj8yVs3eQCkLUKpPgVgasf+CXtS1pW8q6bNLy+E6QX/ZkbbmS?=
 =?us-ascii?Q?vaObVPssoutVKEb1lc6vDA5u4I8s/zWzocNKYNYbuitkONXdtzybP+uBjXiJ?=
 =?us-ascii?Q?dgmPaBuCmYaWe31Ws2qXijWS7ROgPS8IhBgetmLIFQKylJVA802iXJD2D4ji?=
 =?us-ascii?Q?grac1L2e6FYRJP/PcWFX0rJ42pQtd6AsXCqMTAgA4O0SeXE9q9h2zHisZRPz?=
 =?us-ascii?Q?c14VWjvIzBdOIn8KJHjrTcmPoMGCmolS5jL3injzjr7nmHkyTKhvJqIzw/T3?=
 =?us-ascii?Q?80HjZGsh8XS+EY1e4UQx/y4K5Eihbs1aUguFWoFjqO316S5lpx/oFrWslaZV?=
 =?us-ascii?Q?vLOSTqHggMZvC8hmAsN8WWphc5eYR1EwZGtI0h4XNQgf4hwA1EiGx+tSrmWi?=
 =?us-ascii?Q?9hTpYyQEmZxaXXHQgwRtwJIenmVE5lH1PMdv2u/Qm1kPjU2Y6DGoPdD96GOF?=
 =?us-ascii?Q?bm43jGCUri3CxvIqjrpQ7B8ItsGN6kCy8nd122EX0Ki7gaf2LgdOT8aRfv/z?=
 =?us-ascii?Q?BLLOMg9KoP+4v7FshlMjEiiEjpoK/YXRGY5WvzAu6V98qHZjwd2zD8A54Rwa?=
 =?us-ascii?Q?UNItNmfUFVIXhEW5dkxpWxBz0ohpuOhDZZ0Bp7Lov95mSgqSS4Vf4deDQt9D?=
 =?us-ascii?Q?RDzrBp8/wURLV+h82wYipCLVIoyNkD+bnG1rkVhv4KufjYIgSpybUuC31O6u?=
 =?us-ascii?Q?gpyunE9UMMo4VEQbPBI431Bnej0zqtdou4GKF8rYZL3l51ic/w9tCExvIEYq?=
 =?us-ascii?Q?qFZoeRd/fFMJSKgl40EPc5lZVr8esaDGG1W55i31g6W4WInEVIn0eNwqMTcU?=
 =?us-ascii?Q?D6KdAnSImKzmZDFyWVqV2D7LHm7/O40dbMTngYfazL/XCclVJfw2rbA1tStm?=
 =?us-ascii?Q?1Xnob439OAkGVS8wMmUok9X1mwgmNwd3q9qhRvo2a7pBQhsG0Jnqwni6vJon?=
 =?us-ascii?Q?BPEwZxQ5LA3IVb+ZXY2jInmt5ORXDhFQ6En6c/MNdiLOoOXSRmwCet+feQuK?=
 =?us-ascii?Q?00G3CmL8tVXzsDlC04w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 893c323f-a711-4abb-1203-08ddb7d123a7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 12:25:04.5542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDt+Tja0/sLNf+Yx0DBdFIQfMzkB8vtRjstMrhszIO3vz24LTPrjg3T1QWUBKUfi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8938

On Mon, Jun 30, 2025 at 01:56:43AM +0000, Ankit Agrawal wrote:
> > Sorry for the drive-by comment, but I was looking at this old series from
> > Paolo (look at the cover letter and patch 5):
> >
> > https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com
> >
> > in which he points out that the arm64 get_vma_page_shift() function
> > incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which
> > may not be the case if a driver calls remap_pfn_range() to mess around
> > with mappings within the VMA. I think that implies that the optimisation
> > in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device
> > MMIO") is unsound.
> 
> Hm yeah, that does seem problematic. Perhaps we need a new
> vma flag that could help the driver communicate to the KVM that the
> mapping is contiguous and it can go ahead with the optimization?
> E.g. something similar to VM_ALLOW_ANY_UNCACHED.

I think Paolo has the right direction - remove any attempts by KVM to
expand contiguity, it should only copy the primary's PTEs and rely on
the primary to discover contiguity. No new flags.

Instead we need to keep pushing forward with Peter Xu's work to have
PFNMAPs use large PTEs. I believe ARM still has some missing parts for
full support bot overall it is a far better direction.

> > But it got me thinking -- given that remap_pfn_range() also takes a 'prot'
> > argument, how do we ensure that this is reflected in the guest? It feels
> > a bit dodgy to rely on drivers always passing 'vma->vm_page_prot'.

But broadly, if you take that perspective KVM as a misdesign..  KVM
should be getting the VMA's PTE so that the S2 PTE can duplicate the
page-by-page flags, instead of only copying the writable bit.

So, let's call this out of scope for this series. ARM64 KVM does not
support page-by-page cachability, it never has, and there is no known
use case right now.. The only user of VMA_CACHED PFNMAPs is being
consistent.

Jason
