Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A34825B6;
	Thu, 10 Sep 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050920; cv=fail; b=eM9egxfdUxfSDNB0J32Sqds5GQvpniDZ+f0tARocpoEchsxFZne2RCm6xCt4xgMb+8qBND2YhPZfXNSV5u3kmQkReYJ6S06o0gbIIYBXc4vvM26G0VBtSvQO1rtccFDtRm53OZY9nqg7047yzHTRscCJdnZafKWWZpuzbuf9Oho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050920; c=relaxed/simple;
	bh=kjcrgnB/gaLCvNcFN+vkDu1BRe4ecmW6WUtgaZhNDmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lGWtUBifdVhTmjlD2bo4KOI0Q3CbKmZXbiSuoZyB7IbUEp2UZRQGtQQn4wUrcJPR1owySiHqzfLd41VMQHhPa28lOmV6AjOnJJu1UjJlWpI5NDgyO96Rk4xEUMzuDYEN8Okd5P5KAC8Yna69O91UuJcLrYU07TO13wyM2byaAvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f2OwnqIu; arc=fail smtp.client-ip=40.93.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f2OwnqIu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zjxtkdl8dYBTOYC0Z5F+08YPlVpRsXNrcCJPggS4lq+DcX5Upum93jGqBcyCYYHQbr9AsF9G6HH0mUQTFNNc1ypQrc5G8ZlGfeWWYvUuQFIrqPufOTyrc9gORiAvne4jIWzhdFxnH3f02sWsD9056k0YB2Ihd1jvg8tXM6hMgx2kB4zpuba8pWeqgvUcVnUjHZZTB0Bf8d2h2F1/dVvomaHoT3ngR/XZb8x87fXWkmFFMQjxK6xabtm1pYcwUrAVNhqVeqUoIq4HrbLCuN8J2+BqnVN51vE3b6JhDX72N/6j55nzy5tFEkv2rt4fwxO/K1p3F7A3KENrRhyq9YcHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGaDNeCAQw6LA8Ce6lgx49Gtju8XahkrrOV+TIgPgFg=;
 b=L16RLmjn5uvgFGRdyv3uFRkn8Y7mrMmypzjy2NxB70jX7I6b+77ZaA5iqEmkOQ4Qvx31VwC/kCjuwApTWc2C5I+Qi228eeCJMcWm7cqlOHTtvZuVxbhUHS+I3sYjM72KSCBXCOgK6kgmIN6vZEVA1cfG8Xu2+KHVpDfTdaBR/ZnwrH2Gi7st0Ku+zA3pvdkXv4ragy7PfjkDBy+JuPtdkHvJRJiR4fsbDATnvVmDdPWLb/xN1Y9nXKnyDmkumVhFD8kZM7+fYLjD/x8B5emVzAe/6a36mIaeMyOGFdPAlvNGwQwJ94RAaqud4drM1aLH5vUzb3olN0N3BcJIaZCjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGaDNeCAQw6LA8Ce6lgx49Gtju8XahkrrOV+TIgPgFg=;
 b=f2OwnqIup0agPSiuaOnj2H/Rsx+cgcZjn+ZI+yT0dTapY9bTv2dkS8JLEFlkXZE2hGORK1XU4QzRjptQQeHHpLTib0atyT9fG4n7YI5bM3Ai/HLUfQkAveFLYU+RuHAfZV8yGVg6tQPkkkI/iiDmvlDbaqfjW1s329yP9nmUULnAjLptG4BiKn7fhyM7hFM5nFHHci76O5WKrm1tQcjJ7x5mSIxrIY9nlgyZFldPhuJnm1hoXtJ1/YtOGc4Yv1okfY50ZvW2c86srbk2lR2OGRrHjPIOoX+wM0qCw6ZSzYPe0OCh5zIIyhGmAzWr/WXXbiixd+Ta6/CuARasGvcX4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 14:34:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 14:34:49 +0000
Date: Thu, 10 Sep 2026 11:34:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, kevin.tian@intel.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <20260910143448.GD3968357@nvidia.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqIAtOoew-_6jw29@google.com>
X-ClientProxiedBy: YT4PR01CA0382.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4d5558-fb52-4dc7-24fd-08df0f48ab01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|56012099006|4143699003|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	W7fL3tR5Qv8XL0OnHzoPpp/xUPIdIJWtgtdh/PlG5QxJLUXiWqzzHcZzx3EvP1kjUMBwkHozof7b7gUKbd6i7yB7K/guW9mbLPeyrJGyC4l+gQoI6cpugJtgpNbmYr0gxAYluCtbpYe3Hllo6JED9MMu+xBRY46esjSKCAjQ/hYvYGBsO+sRbYksweQuHIIrgboxSkGWwG7OZ1rgiJhkNXsa0yLUMruhwLDUHwGWbwfuVoEq3M2boBelIhoZVfygtXiE7gCZVl2a4hYhh7uACEJajQitEED13ow9XPXDeX4YJkpWDRsCaNLoWB49Jy3Mihq9/lsLNm8vfzxypGYNjL1dax+se/vwWJeJ937uxJzPNGBFis7/jFoMc1Zo3kxX9ncEYXaiTCxvkvtVDkCp+jpZSPz56OCqatNX1PqNx7HWOLdh+5AX1P2hhRdn/aVH+gS1EI3xwYHmILXqMzl2mkCYNdmVtLbjZ/u9dGX4u3kJNCHolChEghGZDRoIaNPJ+tlkn7krYO0kUYjVAkyjkUnPx7Q55YUkiqnx1AoL9YSJAWRmlExQWXGF5Fgv3+2aohBrv1KH/afW3UaigKwE+5emk94kmrAuJqrC087ohxlLGgw1EzLfkfvylQJ3L52uXQBELSAunFOjFm0rPdwbwfTN5ccRRNCKhp0OR1eU+Uo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(56012099006)(4143699003)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BxUJYm/AyTtdf7nczxhFfvxNLJvX7diqQcOL/vzoaP5GqS8IFQko4pKWMEXr?=
 =?us-ascii?Q?Ue35tIN8XMV6uCTq12XPgbnqF5lONYa5EAEN6/AffHScg8Oz/6QmKffp8mgU?=
 =?us-ascii?Q?nGHH566LkPbREQau9pJvNxjFDz02RoLKQtBjqhMCVPudbwdum5AQiniww5yR?=
 =?us-ascii?Q?Gr1UQAM1MliXApgR8qc+gM6D4JWOg0pvFkJAsVYVvZRbp5XGKPuqYCuKj+5c?=
 =?us-ascii?Q?GIGq/yULbXW3SNuMGuUiZWyoL1+EP5yhHaOb/gjyCRojXSGKA2u4yIMgYQLP?=
 =?us-ascii?Q?Tirc6yX5G5jjPhJaNs8K0PgnoP4TxPulwBcI6IDCd5cPIT2zMKsKhkZX76fB?=
 =?us-ascii?Q?H0iJMr/KOMPsFdh0BNBtajCH6cq5giuHj2ST3+u5REgbQLMIDGJksP2PykoS?=
 =?us-ascii?Q?Zhgr5aPExVlPhkHohs4p47IAz0eYO/KrPBl/R7/+ODDCxwAdMBX7kRzl719D?=
 =?us-ascii?Q?PRpmtGd0oQNn6Fqr2K7MuI6KjwegOtecEIftF16Q/1oI6UdShvfiPbNP8s90?=
 =?us-ascii?Q?yifS+Bmt7nIo4Hn0owEP7KZEwkA40Sqaz85h12Fg8QUKOSg3c6ct/pz1uSHs?=
 =?us-ascii?Q?p+BxnQ+KtliecNRUD2YEKuFkLc51pmitqFpGW3dEbdNICRbKCeqU5L+SCh5o?=
 =?us-ascii?Q?bmh4vT8byQk0FGiHaEWZbvkvl+zcP7TfLJt9/O/E8rPGe8akq9g6lLkiTqDW?=
 =?us-ascii?Q?bTVYe4eQ03zpPzKaxAXSDnrpCuhABUZ8E0bamwiKyBVU7hstNFkXCfn/rUiY?=
 =?us-ascii?Q?GQP6S4owjIrZeOs2cH9lSAqDxpXCCV6pR/EmGKPjQr8KZK+38+ZVa2GXanVp?=
 =?us-ascii?Q?caZB4Xd2ZCzRQ8F4o+UEnt+5cN5CW1aEXmRGzScYdEjm1xT1wDy69srjw2ae?=
 =?us-ascii?Q?aHe2iQJUpAUnCDghZ53Bv3xF6TS8RI/GUW7q+tuhXZNlz/2J+PEA0uc3UmFo?=
 =?us-ascii?Q?8aC6I2hMP7baVdr7dngiHKg1xbLljrVsfgCZLvRK1CUfVuqOFVrHm7t3O4kU?=
 =?us-ascii?Q?0yRhMJLb/1MJCiHBJA5fK/LlH7tnfR6z43/8U/AHcNxb0IqEyuBSoSpe5SXq?=
 =?us-ascii?Q?8frwLewvQ9+STYb2HlnXY8QrSvmw7LuhXfAwkGpsm07D1nBzCagrpXpV89U2?=
 =?us-ascii?Q?xywDyyN3HSgK15q//5iz22wiEHnx2+3QKtrsdsAZRXnhdtxMg7Jpc8GCPrTk?=
 =?us-ascii?Q?eXW956Vmz4DdTtpmoPM0Hn7EbSzBMQA+y7ltUUzskVgMSeMwqmYd5U6S+J18?=
 =?us-ascii?Q?BlJzF3/ljYILJJtQBqJAEjTDftDJeI6fz+tKDTCnqafajK2OhBcOwWd5vdPK?=
 =?us-ascii?Q?gEikV4AC+8gvkO6HBMdPH5NCU4WuQWIaG76u+giwXAKRiK3Pba02cWLVrtK0?=
 =?us-ascii?Q?hEHCl/icuut9GthhlZ4Ifps6r1hHelgPnsky45IM5waFyIDP/USLzoEtQMjY?=
 =?us-ascii?Q?wCVaCNAUAwPA9lDWHI6e4P9AXHPi2wiejSt5LD01opWojWsGs4VhE39gUXj/?=
 =?us-ascii?Q?rKzGzy27HQ5sIRoSQSbyIraikdF1uW3wqYpdyyc8B/6HRCcP+Pt9ItO4tECi?=
 =?us-ascii?Q?R4LhM2+yxBFevidDjza1zWVkzEzm8BMCC5IUUoobw9FTsg6F0gvfMWqFWtnh?=
 =?us-ascii?Q?w02t1Dsu9OCa+xDOeQgJjDaC171gDzok+E7GGmFe8jR1Qj00T6P3Iq7Lmpye?=
 =?us-ascii?Q?eOSP/bKCudZX8to88/Zjsri66kVICplZYdX1mJZ9gNQrC1Hh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4d5558-fb52-4dc7-24fd-08df0f48ab01
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 14:34:49.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYgWT/OJjholglhzIrpqy/VSfI610wP/Y5/Igt5bs4YpyBamFV68piYlehfnEUhz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

On Wed, Sep 09, 2026 at 05:58:28PM -0700, Sean Christopherson wrote:
> On Fri, Sep 04, 2026, Jason Gunthorpe wrote:
> > On Fri, Sep 04, 2026 at 10:24:21PM +0000, David Matlack wrote:
> > 
> > > The proposal here (which is inspired by the KVM UAPI) is to ensure every
> > > LUO ABI struct has 2 properties:
> > > 
> > >  1. A field to encode options/features (e.g. u64 flags).
> > >  2. A way way to grow without breaking backward compatibility (e.g. so
> > >     we can add new fields).
> > > 
> > > Each flag can mean whatever it needs to. e.g. It can indicate the
> > > precence of one or more fields (i.e. new fields in the struct), or it
> > > can mean a field now has a different meaning (i.e. union in the struct).
> > > 
> > > This would enable adding support for new features without breaking
> > > backward compatibility. Downstream users would have to ensure their
> > > kernel does not start using a new feature while it can still rollback to
> > > a version that does not support the new feature.
> > 
> > This was never the biggest problem. The main issue was the functional
> > behaviors of the kernel that cannot be represented simply as data in a
> > struct with some flag bits.
> > 
> > Like for instance kernel A supports memfd folio sizes far larger than
> > kernel B because we fixed MAX_ORDER. You can't fix that just with
> > simplistic flags.
> 
> Can you elaborate on why the folio sizes matter?  Honest question, because I don't
> understand why the serialization format wouldn't express things as "N contiguous
> pages starting at PFN X".  Then the implementation would rebuild its folios as
> appropriate.

That's an idyllic view, yes, but my point is (IIRC) we didn't do
exactly that for memfd.

Sometimes you can do more and more work to try and be more and more
general but this is *alot* of work and even then eventually hits
problematic limits. Like what do you do with the sealing flags? That's
ABI breaking if the successor does not support them, and downgrades
make exactly that possible.

A CSPish user can do things like patch the new sealing flag into their
current kernel (while preventing userspace from using it), ensure
everything is updated to that, then jump ahead to a newer kernel and
enjoy the new flag with full downgrade support. There is so much more
control on their part that makes the problem far more managably simple
that upstream does not get to have.

This is why I think the very idea we can support any version pair is
too much to ask for. We should focus on supporting a small set of
version pairs and not making it too invasive or hard in the kernel or
on the maintainers.

Thus live update within a stable branch only is my proposal for
upstream support.

If it really succeeds at that and it becomes very popular, then let's
discuss upstreaming doing additional version combinations.

> I could see things like HugeTLB not working if someone booted the kernel with
> support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
> But to me, those sorts of things fall into the "well yeah, don't do that" category.

Okay, how about worse, todays kernel has hugetlbfs and there are
patches around to luo serialize that. Lots and lots of talks about a
post-hugetlbfs world out there.

Do we want to constrain what is possible to ensure we accomodate this
hugetlbfs serialization? I vote no. 

Do we want to reject the hugetlbfs serialization until we have a year
of debate outlining every possible ABI scenario? I also vote no.

Should we make a downgrade round trip a downstream problem? I think
so!

Jason
