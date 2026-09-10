Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013033.outbound.protection.outlook.com [40.107.201.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD64F53ECEF;
	Thu, 10 Sep 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789060356; cv=fail; b=V/eKQuuYeCabhrpzJ9HVYFbIaBTteMp/SOiptm8djOVEK6EZaN8dLvftm53Xan/D+pYsq4doLpCYCPHaK5rlpj5dgyt8smQVW9t4+H+3C/7JCj0vXDTeN5Esj9aH3h+4vTO9ZQbSKBLqkZj+zISOeYFESBblyhwD6GQo/21ZvUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789060356; c=relaxed/simple;
	bh=mOkj8KfjzFNhpZfTh0Mg2iH3bMwNHqF28slsrW2Pqx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SA48TLQuaHGhQcVWaGQOmVApP7cwFpXLeYS1TkbVdCXM1dl2NDY5/GWGbEnI8haZafYyjxp8+UZn9AYDDP+cTWeWmffINNvCtUrQ5kTY6YcsvXWHsETG2yc4No4/SkumpqdQICpj72E32W8PHbzAFcoHLDu+5fPr+ecw/ljMJl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RcGWYLNs; arc=fail smtp.client-ip=40.107.201.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RcGWYLNs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7WvY/hQLeK1mELkx1Ir/mI1yoolyBz9LoS8kEqxCxNyhvLMTWHTmCZsSZBMPHPiznex37osU6tsd7skZtfXgpiRwMaJEhx/wbWSmATVBHE/9GeYYPgjf9pPfleehyK9CniIPxOKJIND8+xs0dcjRVdFS5XOkjJZP1A6DyZbiWkFGdg0l34GqR9hvWoxG6ShJBXhl15y2zsnjfDlUctebjWzmuMRDPuzvxp9a8W0wTE3Q4djKI1ZPjO6Nl8EGweZMkBStnsq1eY3BnshaQO4GyH9Uy+4oY5+IZtPUkve22LdWZoM33LbHy2tSvYFmrtL71bMHKGzbtpQ1J8VNkS3bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7tMA52PfXUUwFSViKt8NC1NiassUU0VI3kSP2XbenY=;
 b=cTBMqnhdQmcQtZy3jUwNv3OM/RxiBPI9yasfI6Bk1Uxq7gWn94LMdlGIBMIaObonWVouXl3pkNWkmYIfBY9sm9KxyKlzAMqvKYiO/NVa2xGrF5/ZYU7iZQUXHQmJKCP8eeabKOAISE8un7euMNqUexWiZhZfPGsLMvFZIX0Ov6LA2WAjOM7MguLY0ZGcHdVjvVNWJpD3s4s99GDqs2b/QUfFeUZ9d9KfeQxPUWfrlcSQ0XOk29O0Gg22Y0voavJBosErfbjZ98SqfcZ3ZuKCCU7QENMBx4PwSRAxT9XH77xRsX63UnC1Y5wXzNd6uZDb0GQp8VHG7bn4kua50vDfFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7tMA52PfXUUwFSViKt8NC1NiassUU0VI3kSP2XbenY=;
 b=RcGWYLNs1X7GvJmf1+PAHtmFIHz9OBDpwzMtHpErV3C0LOSruwewEmAyy3q0rdHYf7u11TyYr5wFSXbVKQRP9iz4RzUNVlpKM0w23EV0PbvmYeC2jLGoKM1lBNdWhlpdfWOU6+4W+YPvk0ROILJ7lhDtkS+b5Dc56aHTj+7u/5FDzsJ/Vv9RkWJSTD+16K/SPmBVLIpAtJxKZ3J2IApCEsrFvzEFYj6jRq/oR3IvtvIsi2EI35ZfbqYwdD8RP1zlIORSLdkeuWPRC5A8KXwTMjgTEVASNKE7f3vGMI7JmlT3wOFALujzMCrUTTx3qcObNNhlGcvx1RG1NxPxHd7gjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:12:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 17:12:12 +0000
Date: Thu, 10 Sep 2026 14:12:10 -0300
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
Message-ID: <20260910171210.GF3968357@nvidia.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqLOWkuVKccR-I7W@google.com>
X-ClientProxiedBy: CH0PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:610:118::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d6e78ae-31bc-4215-ed82-08df0f5ea73f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	GKQccKKe63WIeMQodEr1ChpdjstsQwwo3mgXmpgJ8KCe2Dh34FxJytuK5U5IlFyNR6UQQ+7sZvfDIDX8+I4g4myAMUJnHBa12AbufDNiqVf6v5GYXt5eBypXBMUuNLCL/LXXxTHmSKJO3jSad+C3La54HE92szCQgXjSiiTAKQLv3weE34zTwgiQ2s1Dn6866+Y+LGOps4aHe16nStsGYBHlSBBXI7LCMAGxyOqnhjxsI8YkNFGeofkwJL9VNGx87eXMplMdvH6TLa5KD9YqodmPoavfwBs8waT2PK5Uh42nCqXZpresxfhmJVFX7NQBDhiozjsecdOYfp6g0ZC0lzoea42JFgJK3/9/UUm5ZcaoxibtN1D6+DJgJphxQ9de4CxYYdtV38NS3mPhUqX04i2h9Q3uQCu0TIHaguNuuThaKIp3v6jkAs+J5PAW8Vc3jIWvwTl6TVmqVlbJshpkDzauEcNdZFJODAwd25gRJq2gQvs7HjfQy8eTFz0GTDd8XsOJgqx5HJh99MW+K2lwbz8ro0T6bWvaHfMAt9c8e9lecSm4Vv0B2lmG0bQStISVuMdL0aDRroF5G7qfcKUu6A4WNpAzEm+DGPogUL22mVQ0o1tGeVQ9168GGPjV5QxcKFOkvT6cR9Zqf8DF2qHSzaTQx0Twh4IDxgiCQNh/m1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?//bM3Afhm6tWeD55iMTwEtIEjrtpn7/llKkHijhqXiadIPQjebLiuJw9Afmb?=
 =?us-ascii?Q?WUdAKtnetQactYlUsRoGw8chgfVhmEzvaLP0UemehCwR1cK4GTqCRMwZmPy1?=
 =?us-ascii?Q?0KBPeYazOMMnApnIKlgDta0wkvh9J0FB2YY/Lmap7y4aTG8wB2KS3L9XqTaN?=
 =?us-ascii?Q?b7sH8hzHuhCL/is9SZzmXcZO1KvcU76vCOw97M3kRZSj7BzFuAs1X6WTqqm1?=
 =?us-ascii?Q?F4GManZNSo79KK8ri3+E1PQHNbHTQ3iy9JUIYAGiFw3NBt9PSKZFuMBzAoYk?=
 =?us-ascii?Q?MzXAXt9QxXjh2swZuz2U6vP5JGmwbLKuO03qEJFDclrU6cjKTwSc77mc4M3l?=
 =?us-ascii?Q?RDin4Zrk6AFgWqH13tCGq6n1wWq3Rt5AsJpK60vNeBvPSer0AsT8k90ufKJ6?=
 =?us-ascii?Q?MfkZp9CGgN697Z3ShkmPAUNKWxeq5wiyBzW2I5SLZ9DwRw4nxe123yZdMceM?=
 =?us-ascii?Q?QlcQEZOKN2a0AGXWx9z1Ws8xQ8jpayCKBL5V3m2ez0VS5PPgS1lPURKGYYhF?=
 =?us-ascii?Q?SzsiWJBUaz0bMkCP9yp8DvR+q8atAwmUS8D+0pat1HsP7yVJo4jeGVdrJYIy?=
 =?us-ascii?Q?KeD6QxDwJEutcdz1fOiy5D+yBj7IaV09piGVmJvWh1n94+EdlEyo5pRol4HX?=
 =?us-ascii?Q?c2YevB9sXKtHLh4smWTb/DYf2ztk7KCo/s7DM/NBIYTimN7hGAA4msPik9Bs?=
 =?us-ascii?Q?mUGXpUd6ZEDk2FOwLJzia3RR7SJF5LXMDDfRGjLL6PMU0p0bS2gIfvHOCOFV?=
 =?us-ascii?Q?0h5ZmCvFZAw+0YeqXxj6YN3S6U9EWLALS3Tcl81bRA1GaRSArYx6lXxt+uD7?=
 =?us-ascii?Q?0/mORqkUc/SXECmyAwUwZLne0lvRxbaQJpVTFYFSlbFOp0Mj+80BBqn0K5CN?=
 =?us-ascii?Q?pW6SrlSXUHPoN8pOcaofDcdt/t67+GzMl4/7+gGX7fpSu3bKH2gkGlpnloVN?=
 =?us-ascii?Q?fgqjdbvPbaz7mV5SSAGmYOWCDCnM/TMSlrMgbip+BdNC6H5iAlByoV0RrK/+?=
 =?us-ascii?Q?Zq3BnY1L3J4gxA1edHD/U+PZK5FB4Y7PTqFUIUyPA+Woj+y+7nc0TkP9mGoJ?=
 =?us-ascii?Q?/FbvRltJ1soaM/IbMyYXvkUnESap7C/MBcz633GDs986DMxnDKdF6X1d9AXA?=
 =?us-ascii?Q?qIG/m2AK52yWvPuLl2OIO+ieC42j5LOPWcS5GI0b2sAbW+sOIgVZTtzz1Cwa?=
 =?us-ascii?Q?1utBxWtAJZECS0stXVVfYq0lUgm5XAlBiCcefIUu/+CPB3TgOOynBp5es+3S?=
 =?us-ascii?Q?EB1ho8YIwot0lD9DSlwg34okMT8rzD78KHyzJCBaf1kVSnj5ObWfd4SCj3cS?=
 =?us-ascii?Q?1SPkTSnqHHSxWMxL97Q32MuJqF3Z8ZboFHvoF6X+sz69x/DrutVHdGWfHpx/?=
 =?us-ascii?Q?qwqKFT8WK5kj3ivxRFYAQkB7zQZSQLWq/NrObaE8TyoC4J1rF3Fy3O2/AZuW?=
 =?us-ascii?Q?hBxjcpVb0otBLcoc4FVO26pEpg3xKXP3ZCpYtdHsc6G+qg4NBv7q1XjNBjyV?=
 =?us-ascii?Q?Knhj++8Oy7yhJi2OC/HXNADRWKv4w0z5DbxWsyTC6YG98eUzIiMvEqB0E8CE?=
 =?us-ascii?Q?B60BlR9Ed8l+sbT7m5oQGAipBB1kKullYIYMTWU8fqH5sejOy4US3qXWu48m?=
 =?us-ascii?Q?yitxaJ7DNKj2TJucpjTI/zvdwg+6ggSFd41Jctf0tmLVVikoq7SNp8X3wlwn?=
 =?us-ascii?Q?im9Lkg4odRhvFhRMse7c416Hlpq/6ruOKVL4YOqb4b8j+EII?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6e78ae-31bc-4215-ed82-08df0f5ea73f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:12:11.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jy2mFyLKp5VkZYd66lrkn8GJLcfymEeIAcdGzDgsO7SncAeXDFDy/hGzq6ek9uTV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435

On Thu, Sep 10, 2026 at 08:35:54AM -0700, Sean Christopherson wrote:

> I guess maybe we have a different definition of ABI? 
> 
> I'm not saying that upstream has to be 100% forwards and backwards compatible.
> I'm saying the serialization payload itself should communicate what features are
> effectively required.  I.e. *if* there are incompatibilities, they should be
> naturally expressed in the serialization format, not communicated out-of-band
> through magic numbers.

The ABI strings were introduced specifically because extension makes
the actual compatibility indeterminate by userspace. 

Keep in mind the actual goal here. Someone has kernel A and they need
to blind kexec into kernel B and NOT have the machine explode, or all
the VMs sitting on it lost.

Meaning you must have a way to determine before the kexec if kernel A
is producing something B will *accept*. Accept is not "parse and fail
with EOPNOTSUPP" like most uapi schems. Aceept means bring in and
actually fully support and use.

So how do you solve this problem? You MUST declare in some kind of
manifest exactly what ABIs are supported, in some way.

> The scenario you describe fits exactly with what I am proposing.  

It does not. What is really wanted here is to tell kernel A to only
support ABI 1 for memfd and so kernel A will fail to serialize if it
cannot do it because a newer seal flag was used.

We do not want to succeed to serialize then fail to accept after
kexec and have a dead machine.

This is not anything like a normal uapi compatability problem.

> actually starts using the new sealing flag, the CSP can downgrade to
> older kernels at will.  And if the user cares about downgrading,
> then they need to prevent the flag from being used until the new
> kernel is rollback-safe and deployed to enough hosts to prevent
> stockout.

Yeah, CSP broadly has to do exactly this across a wide range of
topics. It is a further reason why this feature is not exactly usable
by a "mainstream" user :\

> > This is why I think the very idea we can support any version pair is
> > too much to ask for. We should focus on supporting a small set of
> > version pairs and not making it too invasive or hard in the kernel or
> > on the maintainers.
> >
> > Thus live update within a stable branch only is my proposal for
> > upstream support.
> > 
> > If it really succeeds at that and it becomes very popular, then let's
> > discuss upstreaming doing additional version combinations.
>
> Why on earth would we have version numbers in the first place?  IMO, monotically
> increasing version numbers are flat out the worst way to communicate
> features.

As above, discoverablility is a key requirement.

Each version number is a very specific upstream defined ABI, in the
sense if kernel A emits version X and kernel B accepts version X then
kexec *must* work.

You can make some manifest in other more complicated ways, but I'm
deeply skeptical that is really going to bring any value. It feels
like it is just increasing the testing matrix :\
 
> > > I could see things like HugeTLB not working if someone booted the kernel with
> > > support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
> > > But to me, those sorts of things fall into the "well yeah, don't do that" category.
> > 
> > Okay, how about worse, todays kernel has hugetlbfs and there are
> > patches around to luo serialize that. Lots and lots of talks about a
> > post-hugetlbfs world out there.
> 
> And?  Adding a compatibility layer to a future kernel so that it
> understands an incoming HugeTLBFS payload should be trivial.

From my experience that's optimistic :(

> > Do we want to constrain what is possible to ensure we accomodate this
> > hugetlbfs serialization? I vote no.
> 
> In what way is providing strong ABI guarantees for individual components
> constraining HugeTBLFS serialization?

I bet it will. Other things we've looked at seemed to be like that.
Even the above about "yall screwed up" with memfd has the problem
already. I don't believe we can ever do this so right that it won't be
constraining to the kernel internals.

> > Do we want to reject the hugetlbfs serialization until we have a year
> > of debate outlining every possible ABI scenario? I also vote no.
> 
> That's a bit of a strawman argument.  Is designing a forward-looking ABI easy?
> No, but IMO "a year" is a massive exaggeration of the effort required to come up
> with a scheme that can survive a variety of plausible upgrade/downgrade scenarios.

Have you tried to get anything merged into the kernel lately? I've got
lots of uncontroversial stuff pushed out past 4 months already. Some
luo patches are close to a year already and don't even have any
controversy.

> And again, I'm not saying we have to support infinite compatibility.  

Okay, I said same stable branch only, do you have some wider
limitation in mind?

> > Should we make a downgrade round trip a downstream problem? I think
> > so!
> 
> Hard NAK.  There will inevitably be boundaries that cannot be crossed, but I am
> not at all ok punting on downgrades.  To me, that's basically saying "we want to
> add just enough support upstream so that it's not too painful to carry full support
> out-of-tree".  That completely goes against the spirit of open source and upstream
> Linux, and I want no part of it.

I generally agree with you sentiment, but I think this is a unique
case. I've asked around a fair bit, this is sufficiently complicated,
requires alot of userspace that the CSPs are not open sourcing so has
a very minimal usage foot print out side their world. I found one
other possible user that might be more open source oriented..

So, if I was feeling unreasonable I'd say stay out of the upstream
kernel entirely.

Though, I think this could grow and maybe some open source ecosystem
will develop around it. I don't know. I'm willing to give it a
chance.

HOWEVER upstream is not some kind of free outsourcing for the CSP's
proprietary forks! Do not ask maintainers to do significant and
burdensome work that only a CSP is ever going to consume and can only
really work in a closed proprietary environment. There is no "spirit
of open source" in that kind of demand. I will be NAKing anything like
that in my subsystems, I am not signing up to do live update stable
ABI so the CSPs alone can have a better proprietary product.

This is how I come to my conclusion that upstream should support same
stable branch only at this point. It minimizes the burden, it is a
decent trail of the technology, and if things go well with a quality
open ecosystem then sure, upstream can change its mind.

Jason
