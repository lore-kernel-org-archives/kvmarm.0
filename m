Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4DC248887
	for <kvmarm@lists.linux.dev>; Mon, 31 Mar 2025 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743433009; cv=fail; b=J7nexGtR610eKIF51JZyoxe9gAo17A6Wv6o/ETXe84ExtWVqNs+txCsaORx0+u4JgWbY8m7Yh67Rdy3b1tf86GYCLAQ4zHMPkfeOdNgoYZr7XpfwWPxYsoT1BUJPeAgXJRlAEQpj4hjIAL1XhA0qDk6D6QFIf1H8DrPifwfQTSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743433009; c=relaxed/simple;
	bh=5FcOwxjGGVF1nZ3XhDUdf/FnwAdgBe7VPzLwPaOiSe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V+5d5KCB9GZRGyVQsoq6d3hX/d28LXeV4fC5R5vXcjpWX2yaR3h1PlTvr5i8DTU0/gG23GGsBAsE9/cbknT2xCLOcyUjR7X4G+ongfoiG+dwf/oopbtTdgS0zLN/0/tfFWr7tay1pNt4Wj2dQ2OHyYaStA+ZdmNVoTJ43c5l2ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wy/OWtXY; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wy/OWtXY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nT+9fzuNbJpcxNG9ZAB88ZlXMCk7H/uDAeZKoib9ThsKAGwQ/t4bHM21aKlrMwymJh3DNAmu3PZz/uUPhDGgWo76PccJD/OEf4xJXMMl405o6Gl9OjH9c/YSI1QDQ3XVwe1yI42qa1RLzNZOeUqUSDGt8iqf3cw6/Pbt/tY1VvoogIwr92icsxme9SeDyzoM5h+QCFuVv7nJGO4lrd7fe6lJ10UycRU5WVsPK0DgE8hwTfm5Bux5+0CqKLdT3eHN0EeDu+UgRQwC89VoI6ZnyU2F7zGLbMk9nbVdT9KP5+XVJ4606C9nLI1cQLfqiquPfo5GuUE0spLkGU/ZT9s9UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+oI+r9YkPUzHm21ZKmquM+OzYYVGtRE6f3C1PDuwsE=;
 b=Pquy0ei++Iz4ZIqEyZtLCkqTp+RIYJFEj03Y3lVSVf231ijx6LofabEdxrc3RIiomDpCEwqW6qST5iKRag09S0heHCdRcLEaz9y9SEhEVCnmTSmgwAftummFjad0eY1Gq9R8WgksDLY43Gdwt2LmUOH2WTAdZSjVpPEykkTB8BPJaevnnA0hJlsEG+3drQHe7kFBWavsqdzPYUV0g09z6ULLOz0QHluDMaQTKqdkHTZJyGLQCVrmfWcTX/KLWNyRVE+YMKRdbqHw96HLODXiyybiKFg9CCOsTkYDe87RzpNq3Nv4HY9rWPONNp1/JRcvFVeOHtTS4HmhB0VsmPg5NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+oI+r9YkPUzHm21ZKmquM+OzYYVGtRE6f3C1PDuwsE=;
 b=Wy/OWtXYQfWqzQjRK5t4PESRoOluhZmbdpx5z740Z6xEoo51FjsfXbfEjL1Gzvu8zDfiqDoCseD9mNJUB1zaZFmnlhr4g/pdmIjelC8RZgkGZ2nay7Ex3ja54xvFxYh9LI/UTiSoz+nOyuoaU6IitAbvoaIR/rrl59lFsRVtJh78VWnr3iKCqzUzu/oxNrt3mqkHvLqjyPilFl7d0QQiILVbRQhZ/E0rUvtV6Tf4u3+WH6kbb+bvXg6PLMwaeFcZeoM6mUMQb4Bi+7MvsY5EIrirlwjGAlgi/I9T3x+eOwL/xnmLC0kSLteu/Z7D381OxExgc932AtnZR33RKlqfqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4104.namprd12.prod.outlook.com (2603:10b6:610:a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 14:56:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 14:56:45 +0000
Date: Mon, 31 Mar 2025 11:56:43 -0300
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
Message-ID: <20250331145643.GF10839@nvidia.com>
References: <20250319170429.GK9311@nvidia.com>
 <Z9sItt8BIgvbBY8M@arm.com>
 <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com>
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com>
 <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-RGYO3QVj5JNjRB@google.com>
X-ClientProxiedBy: MN0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:52c::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4104:EE_
X-MS-Office365-Filtering-Correlation-Id: 11027f4d-037b-4fc4-2016-08dd706440fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qI5hxgCPAkZ3JCt5FSBUJOsWwoB4jeD1iUfd1J6u6oWCXpPXrjz1gNbJ3d/W?=
 =?us-ascii?Q?9V6AR5VcwhiMnVF1HXgQgauTGb1C34CDknVdrdP4IXUZPhSJ0J7bhgNxvCV5?=
 =?us-ascii?Q?UhZhFyQKkQ1DWfs4aDP9I5pAV0nR04KeD8bLQzlriAB1UbZDsc4oHvpvGLar?=
 =?us-ascii?Q?u1mcu5K2tyPGCF49dQJEpA7Si0JdhoeaDgDXEg8eKRuahhnWxPMbgEgOmK+M?=
 =?us-ascii?Q?cNFXJg5+7/a7JAc9PXQqngOxAg1qC7NTWDohWhbFMVLVqPoxnGjruCrlTdyi?=
 =?us-ascii?Q?/cOPgDM6QGeAYkIsGde3NMob5BtbGoamCIac9DED3QUkjR/wVdV5qX9U3OFb?=
 =?us-ascii?Q?xSr0LbdIpXUJntoqYn5qlgUo4vz0L7w/r4KAWkWx3D5yKTkixkI08622OucB?=
 =?us-ascii?Q?OxKxOg9L67uku8r7cK0zl1naiJu6FpQuPaehhlbPon6WuMAfpyjGDhFj4cX5?=
 =?us-ascii?Q?NKaMrBOrUewkhWCGRZJBMPgIgg/RG+CNByaOSpbw9y2VlFcNxbSkFhCPuabI?=
 =?us-ascii?Q?aJuqyUeMoCsPzwPWstWVCzorz8Xz2x0cvUCqenFz3/OI63d6PQH2Daxpgvg1?=
 =?us-ascii?Q?aZtUVsTS5Fq9j9O7pFf0t/ewVWN4Gml61PN9NJGm1QRTg+YkFwXywDHS15GX?=
 =?us-ascii?Q?WOgNJGPGVIKv3F0Nychhvls6FK9AimBZ1zMdN8NnjGkcQOmHDGGKZcmcbR2+?=
 =?us-ascii?Q?+pyjPUGBmcCR9l9aLO6+xeBIHRftQoYB8f2t8EP0pHHWoUu72sNC1CFYFcq2?=
 =?us-ascii?Q?0GYIunpAkvmquuXRfM/lCWdJV9e5Q6SGDwI5uv7OtCrfHmUPomg/E8qVuOEb?=
 =?us-ascii?Q?S4PNqnTUkO9+77xwDy0dqDETY+dqFaZoFyziYaoCSWAS8glqZ0X5RIm4aVzz?=
 =?us-ascii?Q?1O4lSAQU2p7mpjFbu6Z9cOsk/i/FoIn0O9uLWnThXN7NGnLTmIMeULSXGPrA?=
 =?us-ascii?Q?zeB0OQphUoFe/N+B4wgneKucIfYDC49+NrR8N15R4VQ3ybzwgAOTfEI6WO52?=
 =?us-ascii?Q?KJ33uZ1Rji0t4qbgUQ5sGj4o5UBnmwhJdJnmnYz3HfBKNMBcvDgGRTKOls0/?=
 =?us-ascii?Q?M9tU50kJSK36KaTCZev+b3qhn1Yv6wxdFdGUBGfQ8ksB0Mu66BQMtPFMOa9o?=
 =?us-ascii?Q?IBBtH6HJEhLW3GNKc5oGzn+yhMemIV21eUsNGU6Y0vyJjggPxNtH4DGHgQMt?=
 =?us-ascii?Q?RQA2+Lm/eiAc/0cUKvgxcmz7Gb6PBtpEhCdzRQXIPgM+EdQioM3p3uaPcZSJ?=
 =?us-ascii?Q?rzbqoeN5KrUCQH0m5FuTifr0r794vSBYYjkQITm7yG3NZVFqQqH8yDXnpv9D?=
 =?us-ascii?Q?ctdk2bG9r8jXHKD14wPoQSXXMuJIs9G6G6BXzaAUw40laLgMY5gRRh4famBt?=
 =?us-ascii?Q?OMRQDsvP797pMHGkZwjE20XnVidS37xSvlSCoW/cvOVoAflgH5zLWwZfVB1G?=
 =?us-ascii?Q?5VXqFlMDqXs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xApoIWQLtTSVzWAMdQLnS+KDJ9cBZOBWE56o2KIjNIPkYNFnVJkEmjEthDQJ?=
 =?us-ascii?Q?+ut7FcgsPuHp2E/Zp1NRuOvkCJHJ3IsJRXKkfVTWpfnk/FOXbAv5QK4oU587?=
 =?us-ascii?Q?sKvonAhm+zP9DjuDUez1BzNpl8KTWg1vH8F7iaubH2xOXZtsKswofvH+/HBa?=
 =?us-ascii?Q?P0yTBPR16zatdmgYj716wcvoPIPiDdSsw5ZdcNQEAUo9PyDdvm9SvS3rIMMX?=
 =?us-ascii?Q?/DxcWtzQ54N3ptINOSlMBq3ylfmQhYw6YFrK2WLLjnSA4RQv4pQo2/ypbgUD?=
 =?us-ascii?Q?3WRk29pPr0YDc/5lq/+oGXOPy9esJCgEjQ6F+O/5jNkrPZ+buFPsmKLGYr2s?=
 =?us-ascii?Q?oYznDuT9lsPolq04gNjD/uwwBNA/tcnSNp76tGR4rsiQ2xD3MAga8swgH1IQ?=
 =?us-ascii?Q?eMHMJE4N59W4pOS96WUFfa9/baKa/PjdqMnYas8jaRo7MHb45sHnGnFjEbvG?=
 =?us-ascii?Q?Wl4r66qWHs+nljP0++q6G0IAou5QjyIcaDbtcia0PzSQ2TEPf3P6sB7QkRPY?=
 =?us-ascii?Q?ARsWwft+Gf3bmqyxpYe5WOZIBT0aeCpUocWRg1f2RkcZXIcnj2C+10cW7TYt?=
 =?us-ascii?Q?Nq8tQjyeSkSnIZ/xnm9//o8Q/dkR63mxC/ToNdkexX0S7bZRM8Ss+Atl98pD?=
 =?us-ascii?Q?345wK7dn1pIDA6Skkn59kOcLe+vbsVsT3dq0YZOvHh5y+h5wF+RSWKDEU8Ke?=
 =?us-ascii?Q?tRUxNWOHACddrIC4uTfL40MD7u5GXrDp+0ZBXvoOlzd/eX9Wqiz2A/iE/4Za?=
 =?us-ascii?Q?85JcbWaFcxU0Kt6SoglX9/q4RXLnyVW1t0Bvzo/+0yin5ayzi2bCdswd+Xk3?=
 =?us-ascii?Q?Dlw3JXM9Q44JiRId8ZpHBGMNGyY5pCCs6DsOZAVneUxkpIsiwcEshGsM+Otz?=
 =?us-ascii?Q?P7+JBOgLwhuo08IhZgPCNlA4up48CghgsFYmvKTl8jLABsSyxq4JH2hnwMeC?=
 =?us-ascii?Q?dWFAUPHeHeKSc1ewlMTHTdxl99qwD4Y8a42nx89n7dyHigntPavyI7FYcKGP?=
 =?us-ascii?Q?yG3T8SsiYer+KsnbKTi5kKVH2FTR3hW/SeqYEXJsAZnfzXjZaao2nJkNkuRr?=
 =?us-ascii?Q?LWwtB4soxD9qrkPPMqSu1nTIlrDCHKf1fqCWo3xywL4/W43L9dmlYjqC03w9?=
 =?us-ascii?Q?G+ZGc//E18PKRuwSxRK9rHhensJaLI9G+E6MCMRF+LIJNkJNylkgALxdc90m?=
 =?us-ascii?Q?bVyvc0jQcalt6QMUyHMYPukJ7VKNLlw3dGiBn9toz94e64RGhf04ni154oAB?=
 =?us-ascii?Q?HzLG5G+Jec9i8IA3SMJ+k7rs3jZjmIBZYt4tPHUQ67kARHCnBavaA2JTo/Sb?=
 =?us-ascii?Q?/jkYsKVmCyL89b5g812nn038FixhpXyh0TFdR3A927+3DnkQRQWRrr8567xn?=
 =?us-ascii?Q?d5lJ7uLgZ8xZAyQw3pDlE6S/1nzMEGNGJlpcnk4YGuxOO2fSZclIjkSHHqr/?=
 =?us-ascii?Q?kuOvueoJDKLx37zdEhLCTVjIVLsoQO5Te1Hm/A20q8Z+Va+nR5ZIT9QUml0g?=
 =?us-ascii?Q?WwJbvvcmb/iocqETrqIMJ4n8/HtRSr9hDcKSTFYBLHrbjbjpi7vX5V1G9GRf?=
 =?us-ascii?Q?eiMsNS8CpSDcxlCGpv8vNwkokVBJ89TEjDGJTmLV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11027f4d-037b-4fc4-2016-08dd706440fe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 14:56:44.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqZAtyLjV0nSW0y8jZgtIyC0xu36K+78iVxhQ0vjaS340DMr/cbQElfpQb2JMkdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4104

On Wed, Mar 26, 2025 at 11:24:32AM -0700, Sean Christopherson wrote:
> > I don't know how you reconcile the lack of host mapping and cache
> > maintenance. The latter cannot take place without the former.
> 
> I assume cache maintenance only requires _a_ mapping to the physical memory.
> With guest_memfd, KVM has the pfn (which happens to always be struct page memory
> today), and so can establish a VA=>PA mapping as needed.

This is why we are forcing FWB in this work, because we don't have a
VA mapping and KVM doesn't have the code to create one on demand.

IMHO, I strongly suspect that all CCA capable ARM systems will have
FWB, so it may make the most sense to continue that direction when
using guest_memfd. Though I don't know what that would mean for pkvm..

> > > I agree a capability is mandatory if we're adding a memslot flag, but I don't
> > > think it's mandatory if this is all handled through kernel plumbing.
> > 
> > It is mandatory, full stop. Otherwise, userspace is able to migrate a
> > VM from an FWB host to a non-FWB one, start the VM, blow up on the
> > first page fault. That's not an acceptable outcome.

It is fine if you add a protective check during memslot creation. If
qemu asks for a memslot for a cachable VFIO VMA without FWB support
then fail it immediately, and that will safely abort the migration. Do
not delay until page fault time, though still check again at page
fault time.

This is good enough for VFIO device live migration as "try and fail"
broadly matches the other HW compatability checks VFIO device live
migration does today.

> Ah, the safety I'm talking about is the CMO requirement.  IIUC, not doing CMOs
> if the memory is cacheable could result in data corruption, i.e. would be a safety
> issue for the host.  But I missed that you were proposing that the !FWB behavior
> would be to force device mappings.

It only forces device mappings on the VM side, so you still have the
safety issue on the host side where a the VM will see the physical
contents of the memory but the hypervisor doesn't flush or otherwise
to sychronize. Ie data could leak across VM A to B because the cache
was not flushed and A's data is still in physical.

> Agreed, but that doesn't require a memslot flag.  A capability to enumerate that
> KVM can do cacheable mappings for PFNMAP memory would suffice.  And if we want to
> have KVM reject memslots that are cachaeable in the VMA, but would get device in
> stage-2, then we can provide that functionality through the capability, i.e. let
> userspace decide if it wants "fallback to device" vs. "error on creation" on a
> per-VM basis.

I think we must block "fallback to device" as a security fix. So you
only get error on creation an option..

If that means some scenarios start to fail, and we consider that as
important to fix, the fix is to have the S2 be cachable and add the
missing CMOs.

Jason
