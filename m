Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB22080C7
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744042548; cv=fail; b=qg0H8Ma/baY8lqcChvsQG6/REYHHBbXXiSM4Hn+UNAOVxPm7m6MeTonvoBZ/BI7TfiBtq0+ZWWt88TIVpw/NOxN/RGmgwEhuzeRmcwy6nlbriuWhez7G82JYkdxR/nafhdZua2ZDdbwMyec1+6JtS7+gKSNRDlDqCobpxwLHI1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744042548; c=relaxed/simple;
	bh=1XzkfanFJ4xNve1FESpBuofWNpQvms721X+PixNF328=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VogvK4/j8lliVXHF6mEEYAigPyOFh9lI23ri3lDJF8OWpyw4rC61/L7Fnic9D5k9lSy4exW+4Ur4PmfWV9+hFBtekAg80/fY76laT97/49+9r4WUzmRozxlhjEjdQYLmrPdPq4xoZiBNe2i2jaLR/9aF2F6azaMtFKLDXP/LjGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LVub7KMr; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LVub7KMr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RWt4cLCInHkIiCgxomvdJc2PLgpKiLRc+PBEiX5aIXek3SA/FJn5eHXzJg6h0++uNF83wuCA5G1B7rgkUPXVdKSSxaMsRttawv/ERSQv4x2JuNVTYqtTft5mHBVSBkzGqDLkC5pW7FrILxJ6CzYY40rCkvOf7dOJtQWXlrgsUgdZr3coS7dzQSNmMIELDwAazRUyiiODBpR+nk51MxuD0f4D3IrX5YIglBJFimc2g6n9UsS/FuKZI3FhqRhFpkWX6GsUZzcl0v009HGPmPAWSVl+9j1csjTNkAevgD+XAINHYhvVPGTUAsoEGtpUFq+pI8Rr7/XgCcIuqSupK3vZKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXGPvK6db58R/LB+Pa3fc3KBfSmxm1Php8wvzz8K0NE=;
 b=yyvsyN8JpONVtEngjXMsOz8oAsFtzQebZwE7KH9VJNgdMRsxwZvLNNan4k5i6IszBosmt76CVuKvOkaJ0J/dLIWwKi8wX6YSLX6eJrXGG98TtHVnHx0cfCwlKi/u60RQGfIB1WkA826SYBjsz9eBYgA6a7QxLTZIvFLhZBDST1/mvyq5z6Cs1xt4rPEdTfjvfutj6rzlZE0TldctsFgyo7BiVB/lVHCbPvi5Dx9yRvpBD07VXSImqf4n60RKUM+Fbl+UH+ShglEK5+D9ooi7rHC/fqLuxiq4yY95VQXf38+bEc/L85fITN4KZfRGm7EEMJ7ihWWKtTDIs2BfD7v9PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXGPvK6db58R/LB+Pa3fc3KBfSmxm1Php8wvzz8K0NE=;
 b=LVub7KMrp0NyY6faLSHp3uGExQ0hWAFjtZqOdB19Q0hCo32O2fAhCMD3a53kUgcmG6NhnfUXyBiwKgFhoX6yImv24RXcqnyVXb1OR3hipkbuwGMan5RnPdJWN8EDHKMwwPkoWJo+NpFesS6FyYIMzWnFYzYkIfd8JkX7CCoUzaJWDB9KMKIRU2WVCnnw/uinaKs0r76lDgIX6g+LB0jOehHYF/lTsszkHseMVHQuc9NFMbbnRZhPd7tY0O59BaHkJu9/okZDhTFeHfIMMHblnb2ExkhV3t1L/wm5CDdfbpjC7Kw/NP+z8mDEZQN2HZ/ADn5eLrqdArAGEEFQdz8F+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9206.namprd12.prod.outlook.com (2603:10b6:408:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 16:15:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Mon, 7 Apr 2025
 16:15:42 +0000
Date: Mon, 7 Apr 2025 13:15:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250407161540.GG1557073@nvidia.com>
References: <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com>
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com>
 <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_PtKWnMPzwPb4sp@google.com>
X-ClientProxiedBy: BLAPR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:208:32f::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9206:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f9a0b4-803f-49d2-1def-08dd75ef71cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GTwUvmvJvRS9UqAprqjf3cf6UDOKaS0LYCGZAy+yN/ebrYlAbftedBEkX1EK?=
 =?us-ascii?Q?WDP9u6u2kkcGhkbf674Tgm/wQii25oeqsYCw8cacoEAviKWKIP2ACpy6opd6?=
 =?us-ascii?Q?I6tud+DwDJCAyyXrWRfSCkqzWhIDAtvXLSEYeEZvknmIfP3MIBO7LVqGavS4?=
 =?us-ascii?Q?ATn70Y33+Mm1tnP8dicvMAw/4GNZpkzIBPRgvaVrocsKar1h6wXqyaVvbyJJ?=
 =?us-ascii?Q?smJ/q2E9cg9gnN04b5E+0PzaZbqEnDHC/TxXp4ZsuPdLoyGoe7CCEyNfbyHD?=
 =?us-ascii?Q?iRGoW4FyOXt6LWvn07KAplPc83LOTUu1/tJlZ2VHFGcIO1yHtuCHupeQA+la?=
 =?us-ascii?Q?VQOLI4TR9S1idwTDWKoyFDTPHaUs6jevuTR9E92pbW4U1d9bi23gUZuqhrSE?=
 =?us-ascii?Q?WmheZRWrXMb7xDcvxdYXUEUwtWJiwprrUwD1YoQMpy2UfPB4R3HRgpn81xV1?=
 =?us-ascii?Q?wxTfAswt03A6fEWZ8HD60q02ax7dKLEGbcgJSXJEP7WlHVKZc6uuq76JVxzW?=
 =?us-ascii?Q?QGfCW2q5K+nAyEXNjkj7zj08X0PtFP8JSqKtaYVYGCNc4Z0TIXwORI3Q+I6I?=
 =?us-ascii?Q?O6vmZ51qjepGb1Wf6WrQi3XxjjsCfuz33ztesI4q1gs6myHfnTxc+327Jpmp?=
 =?us-ascii?Q?Pc3PaUBJ90wnpz2H6aSukoX7ewzLcTvqG75JWtEGtIHTyaZPTv4mvULdjfLw?=
 =?us-ascii?Q?fSlOX0oI0ikVZHTqpcMnlKT0a1T5k7vipla32em9h8odY40xnU3wNjU59lRh?=
 =?us-ascii?Q?R8eeFwZw84ne8CCms1vk5Cg4lIj53DF+xqJx0W7dYv2YuBOIZVxyrU5oDvbP?=
 =?us-ascii?Q?iT2SPSzAfvEtcg0Slzmyxrx4ffyfirAxFloAKfmybuAwjJd/VUN7wJJ6WQeG?=
 =?us-ascii?Q?VpKFATu7L35aTZdW4Ckv/Gqw720+ca8jT47SQF71khQ5vOLrb6uUUz8fxrvc?=
 =?us-ascii?Q?9cBKB08xYlKbTF/uFAXCW0LhNkorAonOykGEg7JbdAQU6EZ0MKOhsMMOKnOS?=
 =?us-ascii?Q?IbWv/QMzLi/Or4/p4pt5oDNd0ysm+jKrdWqTGsP9LGQFbc94fost/hXSUJU7?=
 =?us-ascii?Q?zbE6NWYSJk9/1te5Of9OgHnTxM2ajBrOX7vfKZuLqo7xtIiS+1mrQk3VKcEv?=
 =?us-ascii?Q?UudNmej45LpsFlRHatvbQnH1Oo3z46N9r5zY2XYt5kRQIMYFHlD9c++r0OUV?=
 =?us-ascii?Q?PvYHIVlVXWe+dO10b+9Rdg74GLiTeF2y81fpJdMOlbOocYMEp42TZbThBLXp?=
 =?us-ascii?Q?NtHOqgea5/NJghK5sWFPcG7nwpyQzIXJpR9dIqSsI5082oSTaT0EiRL22FBF?=
 =?us-ascii?Q?QMzlMgNrGtZRyLebRNXnBPNkW48yLcqwjLLYvFH8Rauf5lHvA3kRYqi9q8BM?=
 =?us-ascii?Q?azxGVrMN/vEnVLV0ZkDJLL+OBbhy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xWSD1+esiR8vng3+gv0OIG18Q2uCYczwU7KzG4a575Wgq0tBRdiAGotJJSBi?=
 =?us-ascii?Q?h2fTp3uhejVX6lnpw8m3olxzkRqLivr66N6XEn5x/ST6f2Ejh4hzidazFuBZ?=
 =?us-ascii?Q?8WxKkce6r4otauWif3kCT2pwxC4CkR0neFY8Z0p89YVuo8Y19YjQjEFa+85+?=
 =?us-ascii?Q?3WGfwnVYGR+tKdAmiL3hicxFYVfRUMZQyeM1u7/sUG3Y51uHkdm0+KO/+9//?=
 =?us-ascii?Q?Ch4SDQE45pwjOkGFMiuvpAnIVPSAgJwjI6zrZU5RzgIvIp6xY4j9zCfHUCu0?=
 =?us-ascii?Q?77Ib/NH+NJ23WvfoYdC+xxpWT1/ym5eavWoIkIH/OC+mcPFAabOZw9R96LWf?=
 =?us-ascii?Q?TuPE5FOlHdlxWzhz2pMvkvpqH6KdD2DtRBvGu9hdMFHDKEKzvSaqfJw5Mueo?=
 =?us-ascii?Q?0gpUDpJGYc/KxiuF/P1zHmxyXnY9i6XgYHHkgA7LcWWOBG3o+4chxwo57Mmq?=
 =?us-ascii?Q?CANOPc63g5bkM+taXHLhnL9AQ6Lf9t8dlMVbpJSLlvrRfpEWghbXYPsEHsD1?=
 =?us-ascii?Q?nFzWH19apvZNaX/GEuEd7ny0Al4XQBG5tcmcSDBPSIrNZd5GdTxWJUejshdE?=
 =?us-ascii?Q?w5pagy7L3StEkU/QBMtIxUkweAHD4I5vc+v46L78aAtbEqbMmthVn6ZqAmFK?=
 =?us-ascii?Q?2un3B7yNISP0c761/LCfL8B4y9kY58t/jvQYu3v0RCMu4thPh1betU/WdAqu?=
 =?us-ascii?Q?2aD3d16B9fHX97ihaDTFAB3CFmLFOyUuBmJibLztweBrqZkoRTeI6IGAVGGQ?=
 =?us-ascii?Q?ENP4XxCh/GM6GhSJRM2SOaXlG7sjNPe+I6F3xuCCtU8FBnlr9wvcyLSzVfpo?=
 =?us-ascii?Q?CAikJmMHeGSpCCDyIhfyjhsoKnBTKCwTOpD2nYaBOmLmtj/UFIrL18ooiTpy?=
 =?us-ascii?Q?7wCLtfp+4HGmMbWJ4dS1rzBAeUWvotOQLbOG6vXEzTbk9kZjd6epl5FEk8JZ?=
 =?us-ascii?Q?xg88h5ghuNQvE3tbZvRgJ5AHTcbqZ8tukz0yJB6OeFyZ0X9ruvCTwo+IB6k+?=
 =?us-ascii?Q?Bq++L94EaU9SGLp+oKafP2L8qIxxlGyGEqGRo5sVLAJ5Wph4s3MCbY9fv5y7?=
 =?us-ascii?Q?1iyKdiFutK/LhgBnYR18DVv9q4BPFsGH2/ljAGddVfnA4dfTzD+bqNfpmz7L?=
 =?us-ascii?Q?pkHCvU+G9uBFTQU6d+D6vah/GerZZZpidxmRQMdVlp0Xj7GAhLdq2pqAxqSr?=
 =?us-ascii?Q?p6eEHB6TPQFjE5X4e+WN2fobpRsg757lXeCVgq5HRz9fzZX6YL4uBTXE08kK?=
 =?us-ascii?Q?FALgTO6m5chvr+WT+IaLoE+VyLsgvZyi1JEngfbTYOAGdKgcwTa91jRZaZmV?=
 =?us-ascii?Q?wcW1txzQsBYW5sjuMhK49PxZNA+YncadIUcxXkzam3P5omwCtPJUlgEPv32Q?=
 =?us-ascii?Q?jyyFjd3Bxb7lkGvuNEk4ieC948sqINhTdbd7KqQuYtvFsRQvfGcXAGASHfi7?=
 =?us-ascii?Q?7Y9VwNejmRiqQbjQP7jixP6z36osvSksh5N1s/Tr4s/D/V/0hZKxZyV/jI+e?=
 =?us-ascii?Q?GHT0/OwtXpvCHnEyGsxuECnbOcOJO1h53U8G0qTRFZLrGs9BcR35p1+4K5zT?=
 =?us-ascii?Q?TJcv/M0YYf8TCeOSEj24eR9yWRuRY9pY70spLAYu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f9a0b4-803f-49d2-1def-08dd75ef71cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 16:15:42.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LsZJmmhXtOUVyb9tUnboN0NbCKYcMCgJ03ABMbaZrcJGEeED+oRSPhjMLbPFZ9gb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9206

On Mon, Apr 07, 2025 at 08:20:09AM -0700, Sean Christopherson wrote:
> On Mon, Mar 31, 2025, Jason Gunthorpe wrote:
> > On Wed, Mar 26, 2025 at 11:24:32AM -0700, Sean Christopherson wrote:
> > > > I don't know how you reconcile the lack of host mapping and cache
> > > > maintenance. The latter cannot take place without the former.
> > > 
> > > I assume cache maintenance only requires _a_ mapping to the physical memory.
> > > With guest_memfd, KVM has the pfn (which happens to always be struct page memory
> > > today), and so can establish a VA=>PA mapping as needed.
> > 
> > This is why we are forcing FWB in this work, because we don't have a
> > VA mapping and KVM doesn't have the code to create one on demand.
> 
> I don't follow.  As it exists today, guest_memfd doesn't touch the direct map,
> i.e. there's already a kernel mapping, KVM doesn't need to create one.

This is not about guest_memfd..

When ARM KVM copies a PTE from a VMA's PTE into the S2 it may find
that the physical address does not have a struct page, in which case
it assumes the worst that it is not in the kmap and cannot be cache
flushed.

Jason
