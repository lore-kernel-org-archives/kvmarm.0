Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDC93F1AD3
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 08:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787129558; cv=fail; b=nAtjD2bIfScmfAzWzA6qEsGolhAItRe1EFsVW+dnXcbcx85o+sdqI5cCGiBdMJDnv92pi7Y6S5GbN7fXwKoQuJzKDvPPuJfBCAMonfebZNmaHaYtDYyTBqkS/A7z3+ROpcD5u2hUqzVW0VCtEwcRYSTuP0uzoldYeN+BClusxrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787129558; c=relaxed/simple;
	bh=wJjiYylTMeZWJcR+sQIrp5aILWBoOPqNadpim0kzwjY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rgmcMWqgyD4vQMJSLzKuzDltBE/AGv4XwzUuly3zhiOJ4dqXuZfNvt9VCAbw1Em4zaJvCtReJCYC61w23XQLAK2FrxqvfPOtdKVh59OeOq6FtHr1vV5jS1W7U0UMX707qYNP+5odQfxquci7pJGT9JWNyE/+YnAvtxM2QHtGP9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FX0uHroi; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FX0uHroi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787129557; x=1818665557;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wJjiYylTMeZWJcR+sQIrp5aILWBoOPqNadpim0kzwjY=;
  b=FX0uHroiDn9iScDh91oMvxLpCMs/ApmYRdS4lBx6pDBQ7CEyxLtJvM3M
   LjeCF3N2japiCyL//IY+KsIOp10tF0wkT7mv52uAU0ML2xXf8p23hiP+v
   ExiFjSl/ZgqQdN7vVKqdKjr4d9Yq8DWywQQoR5yHpu0FmeHXyPKzlfegE
   S1LO7x3hFjn7JfeLEnKl8d+mPtqeckfgB5QwqpPArhGHieMNkDHX+U757
   aK84y0h/cAa1OfNRJp1so28csSJGwxryq2tk+9IiBxB3GTlN86CeCujzf
   SsWOQ99Gm0l4c43PD31vDB8Or2k85xZR1ADq31UCDr73VddfUWoEkPjhl
   A==;
X-CSE-ConnectionGUID: x/N6FJDaS1aSp2MxAFO5bg==
X-CSE-MsgGUID: VGoIMYK2Qnah56mIHo2VWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="98230774"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="98230774"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 01:52:36 -0700
X-CSE-ConnectionGUID: /3L/UOqgTtGul801X8hPHw==
X-CSE-MsgGUID: InkprnOhR2i0eV4HK9y8kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="265037903"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 01:52:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 01:52:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 19 Aug 2026 01:52:33 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.67) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 01:52:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSofDQzT/GT0lX2fSsj3+hI291Ofse0U8wu7nScpHBVC26z4s8bNYw2dYKNgxVD9wA8SD1MFeI+97ZC1u4SGz7gUM/CwUHb43B51NKV99xg4oTZRta/+HAl6X/OAz34xYJcCeAoJEsdrK/SQOmNuB+OIPI0CH/qjYq38ghJAhZaZg1ro92siW3rBCJlIw6QvXvhnoDcez9rPumQUS3yEDfrjTP2s5T7NHXx+tkhriF4pdmtIn1htrMo9DXTJIySHdaR0de0J4l0Gas9UKMOB0keVy9lP5OaNK+N7RRJbbajhzAFNsmg4M0pe5UNBJOH5pJ6OUAxARFtleVX8afISkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uU6f12BIUhdbdVWhMaHoKtu8LYK2CiOIoKpWZ9NT0g=;
 b=VvGScA0vLTyqAyMB1yUjrAGwhUd9IfotvyQmH3pzZ/G290q26IyNgK49yD12j1RtaLP1AGSgy6Tvk4BJ8X2ukBnTVoBBmQXD4KmqNB1ZMv14dQ2TT0QHXXHfY9EBlog38PP480kTy+LuAriu3CBJyHgjNyepAk1kidH/g726lmQl323r91xsLzwWB3GuVvBvFOZ5MYvBsci790HKjl0rQUXnIDHt6eJILmDCZBsGnOoDp6RbTibXWU95N6IECGtmXjMeBxBHXVEUbO3QTFhFqzQORa0grihvF9641oJSG2RkLpXjIctdikgNQrKAJ4QDoxfsSPve7KZaC7pb/zopog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 08:52:28 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 08:52:28 +0000
Date: Wed, 19 Aug 2026 16:52:07 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Michael Roth
	<michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, David Hildenbrand
	<david@kernel.org>, Fuad Tabba <tabba@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
Message-ID: <aoVut/h1u7HdFxkR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
X-ClientProxiedBy: TPYP295CA0020.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::10) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|SA2PR11MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fef3504-9fdc-46ed-bd6f-08defdcf32b3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|3023799007|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: VgrV78dPTeOuV3agLwhBdE5Cr9UbJXex2+jBKhR4MSOOUQpY0PMF7gBlIWfaV42FEwlVkhnL476e1INb8mHZO8v53kvIGW0IemwoksOTRnlaRyuVEAZv9TnB6YJEklh566/6LJBXx3huAjiz+SdgZftpdVlEOypqFx8LhpP0jjtwFhkl2VXuVvz2sKMdSVsYWM46iwgAAYNihPiFHDdYE6M4Nk2ZBaKwQG+jIfe/zM9dV9DO07xuD8XCynAo/mYH8Z8UnhGNm2CVsAuyLt94qiAeqEbiRN8cKPxaXCKV2ogRZn6GVysv7m0hKryGLgoqTP3eYZwloyPEPOEz61MWe7xYYfGDbfV6Z+SU8J0MEvCj0WW4wM7iAxyn99nNrM2srAqA/GHK/9aTzUx4RwY4atINRJFU2ZDkWn3TQxxkrpir/IE1wxASnrTBKrekGdtxhcfgx5FkXrseAT/4KW4I8o/E59fdYZvPYRXeUgP4d8VfwPaoRMQ7UGXE0xqZNmGmpmrLOBfLbIX6Es9t+5gHTF7/HqSy7ZcTko+cJdklPZEWPoovXk6ow412CswwdIrc11iXZh0Sps7cU8EbggBZKdyLSIwkVd3K66SPlCOC6lem8oZ/DcfdhglYsFRlOX/EqXqtr+2/PXzm848dMX39Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(3023799007)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uc3qTdHFLuowx0WmFE+VGgdyI9vaVT9rs+userPX1BYs1mhEdRfSiNIudj5c?=
 =?us-ascii?Q?ROxwwkOe6ihwIvnyeKl4YjMe5x4Fm6dSWk31TkRMWXT05sT59VBfO/EJ7x3j?=
 =?us-ascii?Q?chzAxI/PICwlBXst4tYNpn8B2uKa3gB/uUxMDD/9CIdFpGzXhSE57mibqRLf?=
 =?us-ascii?Q?lsgPVOvEDzscqv+ofvOhRZCGKow8hakBgf172aqHtWXj/1KjY2h7UM+nQfKq?=
 =?us-ascii?Q?cPATQggKeOH2SeNZTD8qZ7mgbVLJ3tNhJrpGFWpwhxOwyBE2aQNwdUt2FV4A?=
 =?us-ascii?Q?nFCpYvEXFaSRpc6r+xJRN1uozVFg8+CmeNll49cPNjJcm0tD+2QKLdEZ+PAR?=
 =?us-ascii?Q?f4PHONhZEWz4OaNZ2TOMv/rhmDhMbNVfrAUEbekeF4u2VoOgcD3h3DaGDKb1?=
 =?us-ascii?Q?TFyOQdnieSM02dE++k+BU5+bj/sGtVFKYSGKgSQIreq4MhoGvOOAKfbPvMYG?=
 =?us-ascii?Q?fzKclnJJoL+rNzT7ypSwOUUDWFOmxEzalf1F8g+uUXEka8BzjvnMjObVwuFb?=
 =?us-ascii?Q?XMfHxx2w9TOHSPPFyOVI/cyA0WMy/5RXK20SW+7Oz1GjnHBfzvDf4DuJ+Cbl?=
 =?us-ascii?Q?uj5fPTh2pQS1mS/KcRy6MfvDa2Ni5IQIF2q+LYPRQpkOBlUX0zg7T7Pt0+GK?=
 =?us-ascii?Q?ZKcikr9ZiY3iCvztOwr7Oh8F0a/7wVE9XcpuLTvHgxuw7ZWucOaOmZ1JHOwW?=
 =?us-ascii?Q?lDENdIZ0+W8s3mEI6qsfoH4XlI0zaIpqK8c5ZXw7mSZRisSh0DJbPoUGQDGU?=
 =?us-ascii?Q?xkXEW9LNsJ24pZCZjEA8YGmNsOMEcuIOcKRYoVK4ZGtBrsB/UtG9JF14rJy8?=
 =?us-ascii?Q?7uF8Asd8bhu+Eza8LHxNSMml+me3R4Y6qfHDHIYwm/f3EZgt/YuEhVvJi48H?=
 =?us-ascii?Q?yE+gEolHz09+WEiYdLQQIBOJbdX9BceKcZ57zdofjkefGC0TDyMNTZHOzqEr?=
 =?us-ascii?Q?w3DbkalT3FiACR//U4HVxYB6DzuGLNgXJdO5yTtNR5xIszXF4+8rnp5BAfh0?=
 =?us-ascii?Q?omMxoIRlPStFV7R6sQOshnIX98b89zkmWGohts8B43TeGvNuOfU/KrTmpLvs?=
 =?us-ascii?Q?18Q1m5YWhQKY3bpngZ5Lm19FiD42CnT/h56kBL8JQ63CtIrTlP+ib/yVTeIF?=
 =?us-ascii?Q?mtmArlFmtljDSGmFfqj8TefASnQeBqfLb6IrA8DyF5NnB4uLREAKpn1wEpBe?=
 =?us-ascii?Q?izq/yzuc2mmbMuiXxEZU+vPPul9SdyZE16VHOxOlh2MeAhwRhmNhzLim2+2r?=
 =?us-ascii?Q?ZcAuGnSCkyCCdEl3YxeTWdwObF8aopJUntxtYG8nxNQc9Phyziz1tGoPIGEM?=
 =?us-ascii?Q?xYjgsKGfEIjx2qbdmZwSH6VB4wlz1QlUOWIGk+55JFIcmIqn8xu4ZBAXQEAM?=
 =?us-ascii?Q?Ob8vQUYkED0K78yoXYkXg7TNPxhLQcRWuGiIn4taqFU1iCoVoV+p9eGHRYdv?=
 =?us-ascii?Q?DxuAIZ1cqVuhKOY4raeqlEtv+q8GvvXtYUdQ2gqvov8LiMC33wuie6q8BQJh?=
 =?us-ascii?Q?d5i87RkMYAUBiUMVyqZSoutEw4YpspPV6F2XsOvIASGMg41JBQKNQMD48GQj?=
 =?us-ascii?Q?YDzkRR/4+k8Jv5JWnq6FwtIEdUuP7xTwPvnqFPAYDJS39DQO+4DBvTSAnSjw?=
 =?us-ascii?Q?7ysMtSjUc0bSMk6oWs3EWPP5UV0s+psOEK/O/XiJdqz4ixwcpKxq/xeWT2XR?=
 =?us-ascii?Q?sawUV/Q3LDAat6JefFwBV0xkssp6uTzitINeNDvsM6RoqpGAFNCkSy4zlFgj?=
 =?us-ascii?Q?Kalqd9vSEw=3D=3D?=
X-Exchange-RoutingPolicyChecked: ZNN2Ihd5aL4oYvHgTZG0lRjQQFdMAgFoVBq/74i5aL1HbKeVLw5a3E7cBo026JIHPuTVAIYlMbH5CIMvH1Sks+pYAx1u2ByGHcznn7y3ybPrTwt7eYf36Xqw4JEsAwrzmuyRrzmebkC1YpY8d2gCq7ryDNYaYKWnOWk3g3UR8ofzboUiIIIUr2ohV24GG/0I96SRp6yeLv0szdJYw+DoXrXxvLfYihEDVlsrNDC+cBgXMdFUyHbkoLG2OuOvgUf5VKU3ohCwjyJEuJP6ZfwtBoVWoetYjvB1kw1yYgAqJu5UZfY6xFreMm9XeUsLti8Pi/MAI6n6ruoOQKwW6TaO2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fef3504-9fdc-46ed-bd6f-08defdcf32b3
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 08:52:28.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOLhszgmozdrhB9Dz5UvfJlxVhG9oivNx14bKKq/qrdvUqFqYA98/Lm0R9874TO+qB13PoTAIegeBcu2+QlVbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-OriginatorOrg: intel.com

On Tue, Aug 18, 2026 at 09:15:55AM +0000, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> KVM currently expects guest_memfd PFN lookups to return a refcounted
> struct page, which callers hold across fault handling.
> 
> Holding a page reference across fault handling is problematic for
> guest_memfd. In-place memory conversions between confidential
> computing shared and private states inspect folio refcounts to ensure
> exclusive ownership by guest_memfd. A concurrent guest page fault
> taking a reference on the folio causes conversions to fail due to an
> elevated refcount.
Nit:
As this series is based on kvm-x86/next, where there's no in-place memory
conversion yet, kvm_gmem_get_pfn() does not hold shared filemap invalidate lock.

However, the benefit of dropping the folio reference immediately before
returning from the guest_memfd PFN lookup -- preventing conversion failures due
to an elevated refcount -- should be effective only if the reference is dropped
before releasing the shared filemap invalidate lock.

Do we need to make this info clear, since I think it's important? :)

> guest_memfd already notifies KVM of page invalidations, so callers
> within KVM only need to respect the MMU invalidation protocol to safely
> rely on guest_memfd for page presence.

Could we also explain why the lack of SetPageDirty() (and mark_page_accessed())
for a gmem page, due to NULL being passed to kvm_release_faultin_page(), is
harmless?

> Furthermore, removing struct page from the guest_memfd PFN lookup moves
> KVM closer toward supporting memory backends that are not backed by
> struct page.
> 
> Drop the folio reference immediately before returning from the
> guest_memfd PFN lookup, and stop returning the struct page pointer.
> 
> For ARM, initialize the local page pointer to NULL so that the shared
> cleanup path that releases fault-in pages safely no-ops for guest_memfd.
> 
> For x86, no additional changes are required in the MMU fault path
> because the page fault tracking structure is zero-initialized at the
> start of page fault handling, ensuring the refcounted page pointer is
> already NULL.
>
Otherwise, except for the missing hunk on arm, LGTM.

Tested-by: Yan Zhao <yan.y.zhao@intel.com> 

