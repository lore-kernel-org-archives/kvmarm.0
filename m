Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018872EF283
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750264726; cv=fail; b=OogT2aQmroOQ2z63YGaSwNB9YfZghVyagYyAViIXaL6LiheIgL3Ufx++pGVE+hXlV9DQgC2gWWLXM1a4ENkl8QdlU+/ADRvh0Cfp2kJbPmSE3eU+r8OAKlfwK5pX4k3UgcNvydE94JFlQBcKpFbWXrjXGYZVCcpECT3cCHc71og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750264726; c=relaxed/simple;
	bh=YvL7Hwagcqrne6VZ6ipTKsjm2LqHJxeCGBYvGT4uHN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kNKkvpRQImRnko0tbHue2+OY9JqjYtm97vy2mjqQn5hcFKcmJq0wR8PmX/XpWCMXmOdJM2iNKOCmQ/PsW8gQMPopegIQQc5tuvSsBsa0pzpV9udnOzdUw0suajv7EYjL3kx8xJy5gSgrPR4UC0C8KikzMSaVsmh0DaQugkgIBYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PSzJ+soZ; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PSzJ+soZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKcSpF1ZZwWSicWMJmCCtW8E3wDNmhyt8v1ph2r2cXFRjxtmINTxE1pFj8sHv1JuZo7RdIP9akCC3Zvs9y7I5ksW53NR9UvK/CuGz4lWlWLips0UgdZDSPz/6LFRjmdgk8/1yhoHsz/GWvy1SjNHfL5KCrzxKHELJ4wYb4MvM2KLRI8Ar6u92hrEnhuwlcd/3lR8Lm7Uc0xK10FvUhLfDNJVuIiyIA+DtSacJeb6LS+LafK0ZEcEsAzrvS7aAhLLTp6fn19tinsoFXWt+j+hzH4RFkWgNjVAOfMdEY+bOYgIwEGNpEl/Gpxa3ZPvY195CL7SAlJSjiDbgOtQ+h7AdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOajdZt/ejrVdsfdCPGAfx3kLSIoH8Ol2VufSOgDnEY=;
 b=cmtFaFz0ENzcztRLHpyrMzYt6rrh6YwiJVF7Zg2ivTsjzMiKmGlSiZJhF67K0sf4tHxmU1yhBnmMYeqtnCAuaFh9UdoDZaMk9qqQiATDMQJuUQk/dzyhzx3NXI2oyzdtb4P+iqQH1rLzzdCPMddoVHCM+sX9anPy1+OSNCrE/ib6izfm6v3qnf86cp3Kwpwh2bPYkqOIfdj/mOH35Z0ZkXQvWzr4equlAr7izcbHykivueSUaQECiDlQzwlYbXTdgpxbmP5TyMdApkwYTD9iZDQ8F4dQ1UCzr3HYOJSjChl8QZNCkEulmRNSxALqB6if6qHwgcVMSj1lCpuJoNRnhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOajdZt/ejrVdsfdCPGAfx3kLSIoH8Ol2VufSOgDnEY=;
 b=PSzJ+soZR8KSwsP1aCOAC2Y/gxOxpno/+CoAsOTHPqGSyo/pwuGpT0rKbK4tq9u/oGjNzhWCUKniGGium69z661X4d3a20b7DF93ozrv4eO8B+3//eVmpx6jfRbXe5FZizfZeVOnkbBw92WpcRaHgbyXSRUWpRPC4gdewjw3nd0nyE0AbVuR9M1NskqsTIuIap9dHKk7/8YYmkylx3K4roTtYat33kh4ZYtt4R6AtgdBg8CXunoUOlO38upZb0ChrhU7k1wQGQtXJQPTqTTBMpTY3L3hazjH069fkCUDtv8jOazjECm3ci5eJWukrxCLldYPIc4E+5QMX8MV+5U1iA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB7197.namprd12.prod.outlook.com (2603:10b6:806:2bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Wed, 18 Jun
 2025 16:38:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 16:38:38 +0000
Date: Wed, 18 Jun 2025 13:38:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, david@redhat.com, ddutile@redhat.com,
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
Subject: Re: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250618163836.GA1629589@nvidia.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-5-ankita@nvidia.com>
 <aFLqiAyXZLoOTepi@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFLqiAyXZLoOTepi@arm.com>
X-ClientProxiedBy: YT1PR01CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2452f8-c77b-48a6-2bd5-08ddae86931d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TFPEnPdJhAbdTgTNRz4CKdkSlDW1nFs9YxhN30EhLC8RF5TU01zKr5qOoSoG?=
 =?us-ascii?Q?n7MPtx82UhXFVzutakW98ExmQDw/NAoaigL6uns00jxiQcNegGlZBShmAgAf?=
 =?us-ascii?Q?3IePaF+0tX7xRs3OCA6l+aXhFj+Bk50gt++HoIY2SaqqNjrSjzvam2QFCcvH?=
 =?us-ascii?Q?FaaltyR5O6OfXNaesO6SqLbTXyKxQMzIKnZlEOHPJok8bDB7SMADawvHriWb?=
 =?us-ascii?Q?bgf1PXObdoaD48vK09f36wUK9UTDkyeAcodt8jvwGOrhx2oVRlRGGBctxDBV?=
 =?us-ascii?Q?4iETp+2hzev/uDNPiXzsjV7dKkOJKkdHuTlLNcsVRGjlDwqDXRlZ0maWfv2i?=
 =?us-ascii?Q?zKm53JhA/jjYQiwWDbt7AqNRFKjp6KFaGkCKesw5v6hPJudq+LFHyJ/AL58g?=
 =?us-ascii?Q?+bGAkMasgAHnlyAHbEduuT5YlrNY8P3MUzpGsh3l/hXmFEz903/T0aZRsbmO?=
 =?us-ascii?Q?O4+BxMjkbDveHKDSr65GJFhcMzB3ShaudXyzQlpDF5WME+ErfskDTMgDq6Zn?=
 =?us-ascii?Q?ZojbX9+WFSluGgAsOwgPg1i4xnz+Tje+Gdh7Hd2K/P2KkpQI5hHnPV+D+GLs?=
 =?us-ascii?Q?rJdUhWFtg33kNmuxY+L5xR0Leit1jmkCrmsB4QKzwOCB2tRiBDn27r1lwDYL?=
 =?us-ascii?Q?QVf9mUI+fU0uYAnB6gbcFnjbkHjCVShD9LChfwZN/qu0YHtQNaxR3hAuPbqo?=
 =?us-ascii?Q?6V8BaDUE3A89C0J8LuBEZcSI5gM5mCXpHopCwP75TXTn4rtMqMhOf73uf+tN?=
 =?us-ascii?Q?Pz1VQEN9jvvJXw9IJnhm4MuI1jRE80rErAOEad9sMpVpIindczb/a9+YbS1t?=
 =?us-ascii?Q?eaT4aTgkwKsNaXh9DJVBbMIDMcBYliNQ6KzHLrshCfQpcd54z5ZtdSKSNEXD?=
 =?us-ascii?Q?YB0ZR2m30McXqWE1AQ/Djg9AqfLvsiJqxotzyusbFDgx6eXGUbptBzxfmSQ9?=
 =?us-ascii?Q?GUmywBo0esmdGgbgv2R7HLddMn8+MpnCRXqvnmFyqsq/pDB/yK0cBJU/w3h9?=
 =?us-ascii?Q?GBbfsu4o+75HS3l94HLOxIpW21sd0Cwl5a5JpqjhC2xwUlBOxDT06ZXNYRDx?=
 =?us-ascii?Q?xNcfiLQKq8tpX5R+jrSWzkDp5kpe2sR/eb8JpTWtC3GuR8+KUKmnNkilF7mb?=
 =?us-ascii?Q?QP0bG/VDCuBdhfDuaOL8d44+NdV/0omM+tFu3cxA/GtS/SmgR0OeRscbT2y7?=
 =?us-ascii?Q?77yl4Y4gZ+ezhRO46xcg7DeeOHRCS63H569BihuGMq2qNC0BVfyoAT94rtY1?=
 =?us-ascii?Q?V7UoF3Cloa3G8xcEpoGua4gDwAgRH1CfBXwuxgiV8ZDnpPEr3lh8Mds8+Erb?=
 =?us-ascii?Q?xPDFApWyywPl7YTBKvqtFs7sAALrFWTmJhNzhACrQ22ZQwFMCvqPrCaJuvoQ?=
 =?us-ascii?Q?A01Zj4T5pBC6tGB7hj6IAjGDUcpJ154wY048Kif3kJgWdcAkCnwMwbqwTaO8?=
 =?us-ascii?Q?CGCpUhse6k0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?La6nAv2NFpdm4Sox/FI2LEOVklja15Klg+BUPOmzAZkmSJpSKuyHJLWb3vXW?=
 =?us-ascii?Q?t/vkaYu31k8H3gsF58uBVOD1Di8njuGZoDkFhmcB3lljMQ9PAEGA3l486in4?=
 =?us-ascii?Q?VKXnhItAK0QRPjzsKOdqAeFFLLJ+E2LdoQCVsO+1Rfl8NwU6fLRURC1/CWrX?=
 =?us-ascii?Q?RuxUcSjg9JLObZYOkeMnOKtjn6B4/upkWWGcn+DnAGgTG7Yiv60qQ2xffR+a?=
 =?us-ascii?Q?4YPuHj6QJSCxmu/gG2rQMHYR6eDZtdq8PGmFv3asSuXlXPUuPkVa5HjsLeD7?=
 =?us-ascii?Q?N7yOYVu1Wyie7CdB1HhIzvjQ88wdC44XZwrTW/OpcuGHnem2QmeoZvG9fDAq?=
 =?us-ascii?Q?A2oorYwjSKo/4+wlQwMeO6sJH1HtKZCFCvAvD8ZJ8DR2KLqHZfuFBbLr0+sh?=
 =?us-ascii?Q?NKWDLu0lbawpgfSNAV3v+qq5Z7sKUof7DE7QQrQjmY2Ci2Mzb6yf/3mJpEGA?=
 =?us-ascii?Q?riq5VS22Jl1aMWx0X2cl3p0Wu2scYKMGBlJuP9oUJwNwJ3NSFRmoG38SaOx9?=
 =?us-ascii?Q?4oaH55xH9bbj9S1K3AZbUnVwGMIeB5ksIOxNAYmp75LCw+3CjOWY1lr68sZz?=
 =?us-ascii?Q?20KrIC9hddd+Ge++Ch0IgX6rg1WGyAPr/gladvunNLhVce4wF61j/m0azWbt?=
 =?us-ascii?Q?F0DUz9hBk4JXm/HEnrzfBY9dVOxor2Ylh8PSPw6I7D2p4WlDKWt19pLTlRNe?=
 =?us-ascii?Q?PL8L3cKGbWSvb1/59Cvf6njpsW1JqOK92L3IwjBF6ONp8dPdFNmiQDObvC75?=
 =?us-ascii?Q?x3YN4Z7XtzrKgX2IZ7H9b/cJDHDe4TfDd9skigokAAdYiiNcLKHgDXoolQiN?=
 =?us-ascii?Q?bJeQZjz8qMtKzlLXvMbjJ10cu3inJEt/Nv3HwHvA01GSJoUutZMmjygpHGi3?=
 =?us-ascii?Q?B9sGbDkKLg+thZrSjOQF8cHYbg8xM2ESUEkjmIT1etczn5gxWFeIBReAPyNe?=
 =?us-ascii?Q?zV1j29LTKOTXmyz6HiSCt8BIWFHP6V0jtJWO2fZuALbYRsm1GhKWPiwTeDI4?=
 =?us-ascii?Q?x3geBGEIzC544gcP419mv7baSJsleVzDGZ6ePQ/FdSICn4ttwo5KvLMx6qfl?=
 =?us-ascii?Q?q5CytcWyGjr74v+rG2KNhvISa/hjgN17ccwDyp+oB96G+CFgz93DyLZdFIMP?=
 =?us-ascii?Q?Il1rYVQf+SvL6oR+571p3Zp7KXYgrYxIJgAH9MMxWjCYN+5HxTwrRNg5v7Am?=
 =?us-ascii?Q?txiNRwWPnTfPXGs1ojHKTCf8XsuwlTq86sTUkyxQ1dBsGhi4w9NhyTnWiMGD?=
 =?us-ascii?Q?YdiPHThrXyJdyGDJxCuy+o6OHhbvbh8Dl4e9LJZ2284Nbt24rnUg5K3wb+Bs?=
 =?us-ascii?Q?ZY0s5q7zWfyzw1lw8aDLPNsky31FAx98/HjPBCdp5GxQUhkFjF4z3H0ypDs5?=
 =?us-ascii?Q?BRJJIsyM9dcZnFJFwM/1ONmnSgJCbaaM/oT/q0blBn7cabDODMBpLOylBgsO?=
 =?us-ascii?Q?0V6AtTL1tWCYXNEWYv8GLkhjP1EeW4tU38fBa/hW6f2Rl7LEjX41F+yIeF+S?=
 =?us-ascii?Q?QR9Pfgw4FxrG2LnaW/9vK69hQB9nKvTS8tcXMP7zgjVjODY+pn/XOYvBGJxB?=
 =?us-ascii?Q?c3x6Q1NW2uPPsmfv80lllmSnpardgQxfFr5Uonem?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2452f8-c77b-48a6-2bd5-08ddae86931d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 16:38:37.8153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRRNmku6icFn6bYUDoUNMeeIhxPTOOJtEZ9nMsCxhaZim4KTvj5GEsMBXi1RgkHU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7197

On Wed, Jun 18, 2025 at 05:34:16PM +0100, Catalin Marinas wrote:
> > +		 *
> > +		 * Do not set device as the device memory is cacheable. Note
> > +		 * that such mapping is safe as the KVM S2 will have the same
> > +		 * Normal memory type as the VMA has in the S1.
> >  		 */
> > -		disable_cmo = true;
> > +		if (!is_vma_cacheable)
> > +			disable_cmo = true;
> 
> I'm tempted to stick to the 'device' variable name. Or something like
> s2_noncacheable. As I commented, it's not just about disabling CMOs.

I think it would be clearer to have two concepts/variable then because
the cases where it is really about preventing cachable access to
prevent aborts are not linked to the logic that checks pfn valid. We
have to detect those cases separately (through the VMA flags was it?).

Having these two things together is IMHO confusing..

Jason
