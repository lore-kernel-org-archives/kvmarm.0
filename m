Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01723537CD;
	Fri, 11 Sep 2026 14:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137075; cv=fail; b=q5ElSuMwQuu7QUgDWToS0CyKRQaJLgymGfsncGF8ANGFbSs770z6VLK6OPRxOYjL1jrRAD2/I80ZCTjKLDHAu4hQHZw4Zqg+tMXP0Pnbg0G2CYN9bQCLh2Ylb6HxWLMkiK2WT2rGFWpJ0Zui4xlDtK4W8iglWzeq1KyHeGFBMx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137075; c=relaxed/simple;
	bh=W7SyiPxJscMxBroKi0U5ZuqPCVLZ/q0QyP8hcKQzDJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R8Z8NI34mk0XWRds2+D5WN707D+JG7RvgwBhGC0vPZKNN0KvghZC3L59gpM/CwErArZYXMfh9oIF3U0W0dW9++72HsDKaPBtF0YPkPpveo6SsvXwWFOZ6yRhQwBCOzXtrUGfCs5W67GQY0a1lhRo8tjKSjmhuZXgnNrPoaa5+i4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D1rBB3gg; arc=fail smtp.client-ip=52.101.56.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D1rBB3gg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JatsJRqu1DoHoOvTrc8FauQKfwRXHbMCKMglcFr7kTTZgUkOtgQ0z1ZyXCWYV3oeGb5V/PwqlVE8ShlCazZcMoz30r+2dmC2pslOpAGzZrJP8WE5rRExP82KRgK9rueFGRD7aNx6/KjZ7YsOWZ6qzJW4g5ag+lWnG60EhncqtwAa5kyhWE2f6ZUpQMLhJetGRucshxdXMCdJz0ZyF5mmFTnbN6gMT7eAC8ERyksRoSjn8ulcn+lm9BEXkNQRFsJ2Dxm9+YLP8N6+EGmh1M5dnM9L/6cuQUnFAtm2cB3BopudozRS2SdnuWt7CyonKI4bIrNiC+vYFPKlhz5d5rKzSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JWgc0q+12jv5kIAv32LIGY1YmVkec7CyzTR2C4Uiww=;
 b=v8ITyOfPqPPRpPbroVLIZ7h1mKvepjv9kKDxObeBnqnqP/LA9L1QJUY4tRna0qb2dhcAoFbRKqrMVXam5xCG6aUxvaNN1cJCxZ0HyLD20Nfxs8J0eSBFXheaP2Qw9uxD+tXs6OHHzwYtXl0EMiKArzySarPYVBTA4V0mG0mgW/qoiBiBOkfMkjsNvXE4Vu89MRJtMK328C7n1StcKH56a50yZZd2+172ZkPe3/JAhUKGKGxBNE92VoaVQp/k0xryQEoyYjD8SyITLIq4h00HMZsojNu26zkptt3BzneawKNQfhIE6IQdDW970v2pBMV6nHJATT3yTj5CmSYipH3t+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JWgc0q+12jv5kIAv32LIGY1YmVkec7CyzTR2C4Uiww=;
 b=D1rBB3ggJiSYfIrSwUwUiQBSGXKNiDSNqdbUAp6Mfgsl8JOcrC4Z7s+sl7TdyjY8jiB0230W2AFgUML5z5JxEdBzDIzUmPi8xLsUemyG6WfDdiMOXJ0YyXlwufOOoqHt1D3dVV1JyWR6yvKzt6rLDek5tFOHJaRcCf1owkTLfxpk9g73MHICgef6YSUVnMd9yf4XXR1smCUV2RrzBgRm2Jq1+JZhMRmguXM5wF012cZWaSmZbScTSVA6yhilCeo9nPP9bWFJ2YVQC6RFWHoIOibBFH8evAkNt8Jbag96A3sO2f0B2V0hGICTw5Rn6vzT5pGVHmmt+MSPni0amHl9Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS7PR12MB8252.namprd12.prod.outlook.com
 (2603:10b6:8:ee::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 14:30:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:30:56 +0000
Date: Fri, 11 Sep 2026 11:30:55 -0300
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
Message-ID: <20260911143055.GI3968357@nvidia.com>
References: <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
 <aqMgjXfTJ8u3n7Kj@google.com>
 <20260910221832.GH3968357@nvidia.com>
 <aqMyXE-fD-UN6w5L@google.com>
 <20260910225728.GB857650@nvidia.com>
 <aqQF0gz3Q2weDyEd@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQF0gz3Q2weDyEd@google.com>
X-ClientProxiedBy: YT4PR01CA0209.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::6) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS7PR12MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: a6b36284-652c-4b5a-e818-08df10114ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	SXp8vPtbTfaMZVLqOqy3IAF0OFu3bMCVGn6CpsMkK/4RtsuMjPTr9zH+dhhmblSe/5E2N4nSJCKno7QmigSF/kc43w+9TZPA9pLOP14LYd2lf3JMHGXfaasbgOtq+yoY5/NsO6jrVAeT8+9UsTCiay0jiynEvQ8vG3pylW//pNojBLyBJdz7ioUKnLVnB1cqPBPjjUdr22DkzXzc/p5+sYqcjjEj1ZIYTzxS7WdR8JskY6/A/j+Z/dp6b0RpERjXkR8VSGy8FbRqkw+NrUs4RMaCZ8hZ9fuj9Wif5TuW/m7tuvAuviaWwRpE6s6rKXGQiO3aRyTjBG1xWWekmp8xW5hVghi2gN8frfQJJ1mZda45MUx3fJZBrOWX0KGOb6XGW913tLpxlLIn4X42sormcXBPNc/vaThGePKkACOXoRBHHFTINJIdRqxXYGDW0R/Xs4GPuH+XcMtpeVCE9wd6pCfVysKVeTiN+I6a9AYbrSvqT9biSk+RrfRVeDY5Du6gAZqH52GLfPjBkp9CTHjr+r+toWwo8RSo3AIO0mwam+Id9sgHvCF5b5eyXwq6dpJo7RYPWtrntrwxU9jf5K6gnHHJ1rPZ1/HjKJWqX4bZSbbLzSqe0OS9xp56hLohcoIszK3ffL1yC2WlTtuJF3f65oQLp0CAjoop8vVeb3DrK6s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ghB2DcEsdWgi62cVM61E9/HCSdw1IZLsmUrF8vvQo8mSPNVs9tjTqbxYY4XP?=
 =?us-ascii?Q?VFI3YjSpwQGKVN7itFHcnQjFmiHcdKp/GRrkL4A/uK/VBrQg3sc2EBIDW8qV?=
 =?us-ascii?Q?J6NYE0/vDdvczHaBraxmXICk0/eX+Sycjkn6dWpekYklN4+WUhRPoFdhCVUO?=
 =?us-ascii?Q?+reoDNZCfzCsUxHtF2X91YskRAFVcvcN5roaUXZYPaG9RPmXaomauGQgPNXs?=
 =?us-ascii?Q?JZVPsist2AE6oCXx6OkM/764f+zEPPPWD6X5PURagxPT85eDEXlx3FwdKyQ+?=
 =?us-ascii?Q?sBBxFnyWvxwNSbx3F/jAd7/M81lBF3Lbvxtb25b6ra3oaNClJQmxYjoUPDbh?=
 =?us-ascii?Q?B+g2ru9uTy34dahO2DoEuO8BNU/P4PiOQ22zIZzP6BfeWVtrDSwSV38waXb8?=
 =?us-ascii?Q?fNbh+xWX1UJ1ERJradrhGmGst4mZWyzV6XUmysU+xPJjgiBROAf67n2Gv31E?=
 =?us-ascii?Q?10+pl/WYLU6r6ydm5ymd8MGq1IwedO4i77ivihcgxeJJEgvNWPJ371Xd3Dln?=
 =?us-ascii?Q?xtABfJ8USf8C1/YDOUPwWucArc6uEyMvbF4TjGen//bv+JfNlsyUXfrZ95Ne?=
 =?us-ascii?Q?S/YwX4Q+uWITjM7jmtUEtEsmoBKCmWGeaNL/ZErtFwzSwY/dZQda9EbAg/sd?=
 =?us-ascii?Q?0+sdhWZ4Cne6NcdjsLixnEKUNqpNALIrcV/5CJc7mlXorptfuCxWhNaBeh5L?=
 =?us-ascii?Q?ZMkhBRiP+Xe+PGffgoAcvRjCWQq650TNbgYEjrVRyhtFxvRzLMA+rPUJ6dKL?=
 =?us-ascii?Q?M25uBDpJnwatwxt9T6gbPT/DPKnDg5oQVmTeA6L/DSMj0+qnVOlToEWO1UHp?=
 =?us-ascii?Q?88fdz5s166tEm6ckyKmfrikSaom6NsZsjjfcAZBg33QhIv4Ll5as7kyf4E7X?=
 =?us-ascii?Q?mvKnwSWNEZCRoCLBoerJJbpxjd/OvrHvP2oFcNBuy+Lzy/CPPLK52wzILGD9?=
 =?us-ascii?Q?YLp7w586tOPux7TqBWteTsqr8fokN0hAFtsJWyNGb9aeIk26pyiIhPxBXFrk?=
 =?us-ascii?Q?HI2RBhSvV6B9i8xUGTw29+FE6kqSV8mmBEmgy/3GwOxFV5f9jmqK0aNRRIWF?=
 =?us-ascii?Q?yFrBAy6uvtW/jt89xHVOAmoT/skHAuBBCQ/VvZGYTCM0o/6vXvhsGmoNURaS?=
 =?us-ascii?Q?4/mlpNETDtZeYinnj7ZrKhpbSsytxxoJUqgLb/yXjNSgMmTIAYF8HeMuGlwI?=
 =?us-ascii?Q?p2Cfwu6NXmg8I6T+lRb7nVMBRfIJvRNKQosQULqS0rxnY8FinrwFPsOxxeWJ?=
 =?us-ascii?Q?+MMaSLIPdbgp6UJ1dHcbQWvzNv1rgxLH2IPsUvOBApIuA3hIbAT3wuwfYWja?=
 =?us-ascii?Q?Sm+O4nC76wV2azqgTikZtGz/S8CXU7TR3SIkqqQCwicRDwjMWYML5lI1f5Tf?=
 =?us-ascii?Q?mYwuVBBlUSL5OtTTJ+pVekR68FgBQwRLLMwvH0HRLL0hwb4lyQ+Mnwn2lpm9?=
 =?us-ascii?Q?x/TyXt98o6uhIskuUfsowxyBKbpFC2tL6bj0aYRMGvxastydhCJXj5RwMhpS?=
 =?us-ascii?Q?1t8tS/ncXwVldlJKNERbAfKtkqOFbwoBhJ2o61mxgpjmk497R0k+WzUUFVqV?=
 =?us-ascii?Q?cmWYzQUgTVgo4wfvOWBtvxLtlL6rwp60q12Ifh/JAhvRhVtABKPJqwCxC2xd?=
 =?us-ascii?Q?Y1ZR6U22XEqFH/BHUGtTtsh4whUIMIm0ZGVL7kihMiU2tTROuJtQOjwoe8oY?=
 =?us-ascii?Q?UgMu2qwgq3SggZlyFY+GcHk+Wo2xnu51BPUPjT6j4Um/YwQG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b36284-652c-4b5a-e818-08df10114ac4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:30:56.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fepAJgBwHzlnlaplDdx21RzSTHuRRaAOoEUjIOR801XfaDEqdtz6pCjdlrZMAWCB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8252

On Fri, Sep 11, 2026 at 06:44:50AM -0700, Sean Christopherson wrote:
> On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > On Thu, Sep 10, 2026 at 03:42:36PM -0700, Sean Christopherson wrote:
> > > On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > > > Sean's initial email was asking for strict never-break ABI compatability
> > > > rules on top, and that is what I've been reacting to.
> > > 
> > > No, I was never asking for that.  I think we just have a different interpretation
> > > of ABI, or rather are talking about different pieces of ABI.
> > > 
> > > I am still asking for never-break serialization format compatibility, i.e. the
> > > more literal save/restore ABI.  I'm not asking for full backwards/forwards
> > > compatibility across all kernels version, i.e. the higher level "kernel" ABI.
> > > 
> > > To phrase things differently: I am a-ok if kernels are inherently incompatible
> > > because they fundamentally operate differently and/or support different features.
> > > I am not ok if we end up with incompatible kernels because the save/restore
> > > interfaces and payloads are poorly designed, lack abstraction, etc.  
> > 
> > I can more agree with this, it is mostly what I thought we'd end up
> > doing anyhow with version numbers and growing the structs not
> > replacing them.
> > 
> > So you still end up with a version label (string I guess?) because we
> > can break it from time to time, 
>    
> Why bother with a label/string?  I don't understand what it buys us; I see only
> pain.  Make the features discoverable and punt on all of the "is this pile of
> insanity my company has created compatible with this other pile of insanity?" to
> layers above the kernel.

It is one layer above, the serialization ends up with 10 memfds a
couple iommus, kvm, pci device, etc, etch. Each one starts with a
string label saying what it even is - to dispatch it to the proper
de-serialization code, then some detail about where it is (eg a handle
to recover a FD later) and then the actual object serialization
data itself.

So the features are fine to handle the ABI within the object and a
memfd-v1, memfd-v2 is fine to handle labeling the object within the
stream and gives us an option to reboot the ABI if some reason comes
up someday.

If features are a perfect success then we will never need to go beyond
memfd-v1. I'm just saying we should have the option and plan for it.

Jason
