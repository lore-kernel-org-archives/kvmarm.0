Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241B2F37
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412172; cv=fail; b=McVMfIVusP/IQhqL7KqMJrbxXLD6fhCV+TBMxB7+n52y5pzTGl2OipnGvvBXZupCUCJFGR704qpsI47w4w2JNvGJU0J4jAMabKCI/Xj8kgbNGZGoj9hPYZwwZeWcPe4uQcRM4UoV7yHeugwUwnn4cam2/QEGbQdLbt9KrIVRNu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412172; c=relaxed/simple;
	bh=WP0MVsUZqru7woB4KKEUyP1C7stuxxK8EVINef1xXI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GR4wmRsa4QVK6WnggQ6rnU640YMPtRUJUWUlzlIXejb9mi49f4FPmPqVwfdYheiSaGNuRN+8LKf24aXXnPS6ZsBZ6Ep0S63nskyowy6IlMCkZMEN+OQ+s2x59fyAHrK+/yBv0HV7gpR4y2YXNA59IssPAHYcAaD+iDRppyskV/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GD7ZjrFQ; arc=fail smtp.client-ip=40.107.100.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GD7ZjrFQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtylBa9qk+uMmnpDDyoaTUZc7wc4v7sEYC9S9SS0G9EXYla00jVE/HKnRbU6KjgHqoiV89HISF6PPmJ6SXmr8ZQh20W0Xm7HmwFgmqGWJw8CIbPUqfdnMew+cMZADXGdOJ/5eD+gowIF0arevPmURHoDE7fk+n78jgaqRwUtigd6UC2nurgl9+768ZuRkv0nu4X9XzSkQbW6X5H/N4qtRKTeCzcHrHr6slPiaS7TMBRPezKioOex4HL3IH3MsdzTAmHjbJzkkG+4V1YbaPjbtdgJlvAymLwhvG/DB5Np3QpyzJCXl9hKZAw1lIlex/1Y3TeI085JOdaXki69Y3RnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9adPPHfx2VYZl8FjDjZm7DVVat/2qBLkYQutmwbeNMc=;
 b=PeyBAXGnyVNu+HtyRM6bVOon/jtr/y4xrNGwqwof2o+ZrCm/358UOGb5GdKQr4imqswF0XFOvjz16Esbam6aZA6F5pKGdEV12IaXml4WpJAFrOMvnRmV+riG/krxYQeXhBt3s4Z/TYGI1SrP1HvIx0lN1mZ8bMeIN61flG3WoXoRO7QKrLBD7+Obem4a6G+KnfgZBsft9OEX6BaDnF5Nl4mzMy7DzCr/RxNp8XWkvKbmJkGWl+21uVAR1vPEyEnuxyHqHpGhRphFinzEXiHNELKxmm5Xazh+UXyDAQY2JfyUSJ5v+rfGbhLUDXwNwG9HWeCvec9GS8sEauDI+VVlqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9adPPHfx2VYZl8FjDjZm7DVVat/2qBLkYQutmwbeNMc=;
 b=GD7ZjrFQ15/mvg4dFkGUbEi75p3KNspVU5ia3UjRZ1VPoRujSYmgWyIGGfaJy7Pe5mYcN5XtqnISiMzjXxTQ5lFZFHGb/8ZkFQyBw5xFNIwBU1kvGOc+J4CT4DdvtdThUvi6bZ9wgMuhJz5dImATEcZvflpy2KsiwYl41elfhf/4hWYjijOccnnO/f7x0DxUz0Fb5WuJ8LeCIDH8CJQXp4n+h4Zb4l+ykaI7LPHTYZTWKziqBkkYC16ygUDd35C6CWquCHeEeIntgKXTnmJoDTk/YUkY7+xGI9/AW1TfVzMnJiBk8pHqHsIOHJ3bPGJktghE5xQIph0ATtBAFf/rpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS5PPF5C5D42165.namprd12.prod.outlook.com (2603:10b6:f:fc00::64f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 19:22:48 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 19:22:48 +0000
Date: Wed, 19 Mar 2025 16:22:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
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
Message-ID: <20250319192246.GQ9311@nvidia.com>
References: <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
 <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev>
 <20250319170429.GK9311@nvidia.com>
 <Z9sItt8BIgvbBY8M@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9sItt8BIgvbBY8M@arm.com>
X-ClientProxiedBy: BL0PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:207:3c::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS5PPF5C5D42165:EE_
X-MS-Office365-Filtering-Correlation-Id: 4144b879-c15d-4fda-a088-08dd671b6edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i1dwqeUDukyP3yJ8y6uMNc3PbJ2dr+ueLQJJnjkAkqeRQxMASPLOJj4q7iJj?=
 =?us-ascii?Q?/idihp8+tR4gpryBvFr1Mvhv6jaa+/vbZcVGzZIezDEpSaxvdRqXfn5nsAik?=
 =?us-ascii?Q?CjsZ1jtdveR/abaylF96kFh0ks2M/M4czWwPQ+5D8Ej0PqJV2fpltyBLddNq?=
 =?us-ascii?Q?cjzaS2CIB5Ga9ZrRjVCFyafwGN9xubzjbud7VpqRvG/2JKqQvRNSXaf2aQHH?=
 =?us-ascii?Q?IOwPVlVPSTjJIoqYzek1nQIA9BZvPVoH2A99UL+JVaOxtwT40PR36MFvBoVs?=
 =?us-ascii?Q?mKtQukNG5S7uWi3/DkkYfqgkxFq4nMyi/rMvvuLVO+T7/hc09kxE+cL0mjI7?=
 =?us-ascii?Q?XoEp2yEbDObxVBHanid0YX3BaMf68NnVnYTsXbqGWNyI2rYeB/4+jMyx2ZaR?=
 =?us-ascii?Q?6LBEaLWL1nVKZ/DZAKKUAmgg1OO8mr5h5DAXnIN7/hPFFuKc2vUM5X9uTsai?=
 =?us-ascii?Q?Vl7t200I/ce6GbHQK7xtnCFfQg09vSI++FS8D5C6KOdSIYsMqHUVZdUvFiBV?=
 =?us-ascii?Q?RtBWpkcSVM0IK2VO3CXO6NrWhRKth6jPTuXKcvwL2M5t1DD8VDYRdW2OOOxM?=
 =?us-ascii?Q?bAHPQr2sWxhJHmAGY4qxMD7A11yUD9kjSBoDD+V0sPHy8/sdDpjNf7Bj1kfu?=
 =?us-ascii?Q?iTW5hganGYg1RxFMMRj0FpBjo/TNU3V576eq14kBYCfBYaFQb6sNLGxSOKR3?=
 =?us-ascii?Q?xWoGkWMWgOwiywitHtEIrXjEPIvF4BRd8zE6jIVszYMwoQ89WBSt3RN/ooW8?=
 =?us-ascii?Q?BgZn4xvqbSljXs93jj5kT0pw2Yq6hb293IwsgjF02Z/mzC1lNnj8T1WGqC0J?=
 =?us-ascii?Q?x66faj32aU46uvPUsXHX9RzzptdI4bc3WduM4BeEawL5s2Z4MXziSD+c3NLT?=
 =?us-ascii?Q?s+ZkEGPfAcBQiiC9SMBCQ5iQ75g96h5UY0Ats7GDCKYGOBIH5QVm2OzQzGyl?=
 =?us-ascii?Q?rN9ouZ0wJa8zrw1g6REaqrrH1UtGT/NVeWALbXQRfxDr94/LNFW00A/WAOJI?=
 =?us-ascii?Q?ItszhG360p+VT9WICKsO+/zL3h1JeyNy2maPHMpSohJ/IcO5BF9R23qgPTHy?=
 =?us-ascii?Q?0xk1mA320I+WGySZLatOk8ByYgXAZelykDNtEbITaVbCI7VJnvfddXAH5oam?=
 =?us-ascii?Q?LGASIdpHTzquqvWMmS91GKtWhgnseb8UlktvJe0XwcwSRsbPO2JOv2C8g4kI?=
 =?us-ascii?Q?b3jj3nF2aRzqaMt5+EXAZl+tZJmiQsIgBoR+NXHHgjPXISOlNdVnIMmioh9+?=
 =?us-ascii?Q?w/iZREZ+vuRVQazQ3yLw/rJR9m1TRgCfvcn2WBMJjNiYMq2jpR7PZQhz6SwS?=
 =?us-ascii?Q?VYOiBi548ziZx0hAtiBM5zrsBd6w0gR294UiwHsXPSu24U7FZ+wjihMRohlM?=
 =?us-ascii?Q?EWrvMUTkb4jKFvOZrX4lZdnrq4ON?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GCSOj0I0Bi98JtRvlDRVWH2c7swRrI8PiK6OcByO13H3QLWFL+JZmfSIP6VR?=
 =?us-ascii?Q?WAZYE/G6WYD3GKBm8VCvMncBAwhiYaU3X+LrkBuwtjVOJMulF08rOr7KHufO?=
 =?us-ascii?Q?q9A2K738Md4/vZwGt5yvXS2XhZGHJF4N2N1HwnfcZuwTvfTS1fiHlpAXOUO6?=
 =?us-ascii?Q?/A+qy8n9qOiVztT+vEozEnI9bnytsA1hRatWfG2IBlwoW4BZu39bxrsSDLnE?=
 =?us-ascii?Q?uBnhvjAVnk9PIBjAgyKjPBgr2kH9YF1ji76qY+RroX+l4cUkA7nmzDd/Oj7t?=
 =?us-ascii?Q?LWv6DFEyh27kcTUw0LGMGvkgKvGQMfeO8KzMJT838GdrvDDhFPKo4wlI5aPx?=
 =?us-ascii?Q?KjDCGUl/Dz/AjWu6S/ieQhF6iLYYgf8xfhpLQcBR8pBko7nFrH8ZfsBhxOj+?=
 =?us-ascii?Q?jRduR4ODFc9xKfk80AEqOD4da7z+TR9N+e8PPz4l94WCCoBvFIZi0x7e3ob7?=
 =?us-ascii?Q?x3TzZLEKS/uU0lLM9l8CYCnq5OHIaO17sqyN9iOKDxLq+1fWbldgMfCLIeZZ?=
 =?us-ascii?Q?KZGOaP8kqQTphzEMK5iagbv82UHZAs5pmVsGSb6Er5EyUibQL1Rt54Ksp1iw?=
 =?us-ascii?Q?JYLhM+BSNKaNtOBLOn/hzFcACRuCx+FLxsGrB5j/2gZlCb2TZ2GoSl6axmkQ?=
 =?us-ascii?Q?pdplGXN5ZWHjyVioJ3IiOn+iRtRssbIGWm7JNfN4ZmY7xEFr85/GFT1pWifH?=
 =?us-ascii?Q?xQIwy02ara3rjVI20WIPapodzdfG8l/tHizIkmKKPKYn4yNT9dptV/ie3rty?=
 =?us-ascii?Q?to5Mg+mJxdkX3avih2MgAIVagnb3pq9WTp3t0O7GE3QFCdT7Qgn4nDvVzclZ?=
 =?us-ascii?Q?S6cLRpdtXTZ0ZUVaWv4u1RsqhHdRqBsAhJRNluKn511xYfQGtWa8p7hMUxKQ?=
 =?us-ascii?Q?sdaI/nNUY/EnnFQGYpBnOZ9/1QPNsFuhSe/RqH5olwsCA8GG32oD0Uk5HKbI?=
 =?us-ascii?Q?4t6XrQeAjQeZc0qte6ZAg0tYzT4hfPSRr+gyyQGF//pUKERz0bq7xQxNiEVL?=
 =?us-ascii?Q?QMrgXCxOq9bag8omP9lROzWTYeOl58My0R0PCfhALF+3PKdOeFdyUY3gZwb8?=
 =?us-ascii?Q?6YgOx40BJdPnrzUpeAIxynTLvnFenPU/prkfPuwXUr55VSMLQniX69H5cVaE?=
 =?us-ascii?Q?RJg/QFxd6kkeeKZR4dq6NSFzd5vW2yl6KTfTSJLvx/OuuqZK6OLn/x1TSxax?=
 =?us-ascii?Q?8XM3kmBioDvz38lNGa02NDBUgoJMI1AzHiGsfnuUEeydJzQpD3GHgik+mMYv?=
 =?us-ascii?Q?2gv7BlmHQ3bN+dhmIBhIvEyE7OVFNB9pPO9HAf1uHKanJoWP+W0DnTHVNDy6?=
 =?us-ascii?Q?KdmSvH5XLLHCCPbr46LJ1Sg3HZKmJrsCUFef6v1pchapQ8Sm55Nh7mcbj+Jl?=
 =?us-ascii?Q?1pdlQ7VQYfaRMhu4KZi6e2LNKFobuSYEfrbI9yaQ6utQJeAKJKagrAuhQLYT?=
 =?us-ascii?Q?jbx0Dn27Ws/hvf6SrEJqii+jMDMzfCQlsMcQFD6yOHPUusVHcJXG7/Ueeolm?=
 =?us-ascii?Q?8e0E90t7YLoEDAZ47IgR5YdgWlsMVxfGC6jgVWSuLfWMmq/vqgFN7FsAxdCt?=
 =?us-ascii?Q?U0kSwve36YLYt/qiP50=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4144b879-c15d-4fda-a088-08dd671b6edb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 19:22:48.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: slmjaGHBiOC3y7LGLjffTjdC626EXzTJRYQOgl3WG0L6dL6zzxqvnNyOofziEoa6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5C5D42165

On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:
> On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > > crap since we demote to something non-cacheable, and maybe that
> > > deserves fixing first. Hopefully nobody notices that we've taken away
> > > the toys...
> > 
> > Fixing it is either faulting all access attempts or mapping it
> > cachable to the S2 (as this series is trying to do)..
> 
> As I replied earlier, it might be worth doing both - fault on !FWB
> hardware (or rather reject the memslot creation), cacheable S2
> otherwise.

I have no objection, Ankit are you able to make a failure patch?

Jason
