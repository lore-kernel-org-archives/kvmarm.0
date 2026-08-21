Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F320936A36E
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 03:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787282413; cv=fail; b=qeoMnjN3Vh9ayQSQgy6LPXs010SDovP4aBLiiXipydqmRpna2/DUS67vykZKmDr3kkJeFPoz5HU4w5gdjesZvBggLu7q21/8M7U8YYgOVasDvHOWJWMTsbAH8R+O0VQMa4h71wNu2b/LEbkqnwu5oOIo4SL2Bkb46RAp3amAK9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787282413; c=relaxed/simple;
	bh=cd2uguk9UB5FLxJUWQFX5NjUl7nw+ci7/CvKCZ/Ty/Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Okd2ns3zxBPr405SUMKkjLV48zCu2FLqoT47QkTodE9H8PupHbPOz6/7N3sbImq6Cu4V+YhLeVc4q1oCvp6UXaGfgz+Y47uFCtQ1aiNhAwSj/8QQBTK3obyH4Haykw2rMZZAbYk4RucBxz9WFuMoXJkdQhxlxd/rmQp9cMUBFwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VAsI5K0e; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAsI5K0e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787282409; x=1818818409;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=cd2uguk9UB5FLxJUWQFX5NjUl7nw+ci7/CvKCZ/Ty/Q=;
  b=VAsI5K0evJinZ8TiDtjqQ03aJU5Oz7ANyR4QoCAYWwqpaJW5J7eZlloS
   zhT2ezeZbjuJKn5wwFtoTjqUDP/ut0H7GJCyR7mtD3wc8kI3GcGi9hILy
   gpLvvqcEclmoq9KXs1o+c5aEpyEtUZV00o4eOrmgWSfIQPR3BbIEvGHaZ
   upUtgrvDKLc/ZhgvBT+6PQgab0hUnDWp+Ql43vctVbitJrWHh8CaVIhEG
   Cs+o/4+gaDC1PREYlyys9wxwiOqDvQk5nGPEEwi5Eg27+dDMaq7Co2rNR
   ABojYaMd3uc0ZVdlrW7pHYrfxeM9+Waxg08TE9IJAwHhGC4uPnwTnJ2ui
   A==;
X-CSE-ConnectionGUID: c1u5oWPoTgKGgLRROl0Hrw==
X-CSE-MsgGUID: vsYdFfgnRE2fWx3dqrihGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87595831"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="87595831"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:20:06 -0700
X-CSE-ConnectionGUID: sWcT2JDXQYOoyRRqfGNmbw==
X-CSE-MsgGUID: cpnxZn47RmKo8apL2bDhOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="264920506"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:20:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 20:20:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 20:20:06 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 20:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERugc1w1SKbS2ezsevtzYp/3GY9pxAiI5LDG9RNBbLXWrod22JYmniWMjpnFpNnDhplxAzBPcJqRmLD6/U16E3NLBmzk0Cgn9XDFRnQvME/TifJAJNstTYGHK4cava9i8a/1h6ARQIhq5VICk7aKRmvEMuZWwwkFc4vAdDkJJbkYCnNEDiiyYFcJhhlRQlDQ3kkN8RqVv/wPdRCFSnCUkc1zFBBUg+CXRaBjKwsqw/zwvNyTcaAE3CCCRYmEyH/v8gZD8z5WZkdyYhsHT8VqcqWX8ANFceYqcFBsxzuVoJHWc9oEM9CA4iCbIKGbhyV/aezXpYOSg4dqfy110FluxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4irVj/n/HZz+b0MFf+2Vf9YnSgv12zYihGNH9HeDDE=;
 b=Zh2dOu5Y8dfjMOcSEZfZMISUhbT7Wl8iH4lQD1XWvjCUvVnBfXvZBjSNYmyblTwD/0oVZy72ma4hbvk9Dq2obi+KGahX1SZrFLXNxEPKdQHhHkQ0SzXaAcPKly78uQ6xRXMbV26tXum4dJe6iSw1pxU72gnr+e1INwnwr56MkW/vV7gVIOVXnBEHIvm2S41l4MOAEumFreVxUvVQ5vVMjaJ6IGC1OtID+PCIHsMpdsnTw2o65UyRJJH6Y4xOv94czRbzksM0L50fn74xEYcYV82KgpIblclQqSeXmshOr5JlNsG6GToYAOw5qodR6jxz5rdsZHMNKKMsou5wOMOXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by LV8PR11MB8463.namprd11.prod.outlook.com (2603:10b6:408:1ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 03:19:50 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 03:19:48 +0000
Date: Fri, 21 Aug 2026 11:19:24 +0800
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
Message-ID: <aofDvFeASNE0ihkv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
 <aoVut/h1u7HdFxkR@yzhao56-desk.sh.intel.com>
 <CAEvNRgFFs2BC7m8YH7RnQSysU+eDqOjQpqAxL09mwJgrT_iYww@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgFFs2BC7m8YH7RnQSysU+eDqOjQpqAxL09mwJgrT_iYww@mail.gmail.com>
X-ClientProxiedBy: TPYP295CA0040.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::12) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|LV8PR11MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c711a31-29c5-44dd-1e6c-08deff330e85
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|56012099006|4143699003|11063799006|3023799007|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: T3vKudCmMVsl+h7q6ySMf/fZPgWEgYoK9QPNtnGOpEilq+qLcQUBVZv+uwzoRgmaDuyruSI/dcGOODnW3iYCDfU8+6YNKV26wPkmtVqh+IBZGoDqN5IE1rAm+T/44+tU3K+QHa+F5HoY5eHFwaeHS2gsZQdrL/2umuaS9O4EnvtGF3ZdsWkot6ej7JCHZP99xCzRP5daxtlIMLg/ilvGLdyk1+hc4Qwe5879ie2SOFGGd7HkNZzd+lGeS4wMb0nnH5lsyFGNsQ1kFDiPyxL0r/9VG9KhCmMYfSkpf4Yl7PI8X4MXyfAP6eADnyFWWhE+EW4ZFHzPUiNVDki2i9IgVXpXbVmvjZml6hgcrUirUYq0OwRhroTZdjhwL7/5ymZ++12l7UNQ3kA5iyys46W9yC8USd9s5i4IHLZRtQafy7zuhyXtCB34u9w2FN8NW0nPygPCcPcGB8kRMOr55gAb1HqjDAl/5hendvmL9zzTToVJhvfCPKsJXQx5sH9bpcEaN5ssNiyk9aWte2KNe3Xlq9F+V9iJtT0puqhpsWoSn+TENm59VqZ3boClY94znW2t/ck+LIWm78BL2LBAOyz832RxIDTkewHZcVCvmuQoBHF9XmGwY/sTLZmrFqFe6dww9LTmm6H5/WoQq8eRhZE4HLjKjVX30b/Sp4zjyqi0yDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(56012099006)(4143699003)(11063799006)(3023799007)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mFowjQKV41zrnVOd8vwDI+l1xKrzC7Om/FyN9zGlaX5ptq5QAIs25uGARL10?=
 =?us-ascii?Q?Xbs+/Ilcx+2jjMwRpU1q1EMr3+f3WNda19mjVIHL3EWpo8TjHx4RRzLnnRnq?=
 =?us-ascii?Q?dEGRr6sEuAHl4dw7CMQiLvNV1Ai2q6xOAz5nMURfOuM7xSVhb4imsolQmFt8?=
 =?us-ascii?Q?9RAUPPzFNQSfb1ze6p7cUHFv79XmbYgXowgnX4gA5lVtaKRJBbiku6usbJIk?=
 =?us-ascii?Q?iJafzWQHzDdMZxF6sUXocTJGkx6xRJMhs45bt/gwv35YbEmpNDULEaklJaeV?=
 =?us-ascii?Q?gZXFUjps3kVAB6JotN6XoMGAenSrbSDJccyqP4mhWW0TW/ZT33ZSEdaHiehP?=
 =?us-ascii?Q?IXAgBclFucLPdDttGVNDL4g3n5IkjyGoq+vwUV0o0NVm6I2tLiUI67+NDKCF?=
 =?us-ascii?Q?D6S5eEivlColf9R+N9XLewOoGdnFmEjHXAv5L9UJran++aIFve5A2030I+JL?=
 =?us-ascii?Q?h37yTZ4U6fzyrzFKDi2U/xqJI4grvoYtUgngAUEu1HXNYVjrYEMBeg390eKk?=
 =?us-ascii?Q?Shk/EPs/hNVjxxM+mhD8ZYCSk89rPlKuRmugnGJ628nRBl+qZ7CXzswE1gc0?=
 =?us-ascii?Q?PVbUvWhjQvRwkQ2/GVESaUPI9Q2bcJ1Q9VMnrUPcAjWQtFcB2i2oorDlLKaP?=
 =?us-ascii?Q?/4P6Kngc/6XYg2pE6B5M0XyyiCE+TNt86TLuGzjlJjN0/1ds9aNEDy+1PtMs?=
 =?us-ascii?Q?Xbz6d/p6YUXN/vxmvITEArS9f6P61ki2ony0apNsHcZz/X97uWesMvPyIhpT?=
 =?us-ascii?Q?SV8cRo0PGq0XeqpYq5jjmruuiMt4pgfAH1caPw6TbLLNqZ//92AnhWLUd+bF?=
 =?us-ascii?Q?Z0io2eBreTZ3XJaIj26kNHXTgthi4RhUIGf7ig0aezA7JP1ZZVUghw3ucHe7?=
 =?us-ascii?Q?7YRftOqpB4AEvnG03P06c82UL9Gcjd0oWHsNqAeUZbu9nj9O44rEgKscetTH?=
 =?us-ascii?Q?xoYo31YTynQuxAHRlZ7dY/U/0j2TOQPKY0ZvdfGAVMJ4lJshx3O9jFZ3sn3L?=
 =?us-ascii?Q?1EG2Ka8zLgsZh4YaAnlbC2y5c2wftwEwbouoICImLyFZnlveg6VKKIqTCYtw?=
 =?us-ascii?Q?orum+tI/3SqXOkZQhYYPsfNWNp24+Xf3Fu1cu6n6vISxqXTjBCRHr7JA6FfJ?=
 =?us-ascii?Q?ToJIlIUTj4CaITEArKId/219q+17u/AuOkBOLFrIIHBdH3y3gCBTf34zu4G9?=
 =?us-ascii?Q?fFW1gwWIYR95nQTxPE98KD+fAZP8YTDfzF2N5IsQ/ofpVx305bdjvf5Fyary?=
 =?us-ascii?Q?mkSKBM8Z1K3Fr0l2fW4NScahtQi6A7N4GGxYcZClr/mgOX+NuuguLjYS2K+/?=
 =?us-ascii?Q?c/Yl+6hfwPnz43BEyRcfhgqo9SoNj9OhPRv6kdl7V26jIgpah0ZC2N6gwsr+?=
 =?us-ascii?Q?w+G3ovaUwXqDfGHzg3p/b+iHMWpgKyYaHXs1pl1Ir9lK50pUyLv/ImmrZQxb?=
 =?us-ascii?Q?Xcdg5IGSWE9wUY4tBPJ4bINxZtdp2j6LATs2WQyJZ8aJ6ypnHrXbDe2zvaUq?=
 =?us-ascii?Q?Qvltn8kUcSYVgKzbni7+NBzl78L+yMrIU4ZIvYRKliQ5Q5M3mRBEMU1N3+2r?=
 =?us-ascii?Q?SAg4W66rSAPe/hU6lNMGaw7hZy7dFG94t6xWKw75Q1IX2Xe1HvNVOVSrmdCm?=
 =?us-ascii?Q?vnL5RTuY7LqSHPXH5jt1la97Hqyn0pIcG9As8K2+9xdJx0yk7uTgmWrorN3e?=
 =?us-ascii?Q?2AfYTOrgocSelAvVjPdmmyXLP2kkCtjKXsvzypfnk90QAKzpFR0K1rNH3Om2?=
 =?us-ascii?Q?itRIq95Cew=3D=3D?=
X-Exchange-RoutingPolicyChecked: UrXXsj8/8VA7Pa9ASha1OgBdzqmHp+5ITyiYuGpzz/wnkpUp2bxjUuLAmsj2Hhlk1Kv82YUhG9v/gVE/7+NgGaqa0oHktzMWU/65ixUKnM2YrdNlAxmrvgWqGSvwntLjKSATXYxXgSmmpOEvCQ/iFxXpnfZ5lZkhPBi5TXRumaYX7n0eGhFHlVpqmdAcb5Lnt6Mq1anYdORpfyqRdKBrXO8pzPHhgs0IEUM34aJeSkBBu/qhMC/l0ZhdpyRzjiTWrvxIB2MQ70hsMh4YvE6Pz9fp7vyKj87H/7tvcSXxJ3DGuLTijLAt0iCM+YbZHOczJFD0JDGKepdHgAnpoFulqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c711a31-29c5-44dd-1e6c-08deff330e85
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 03:19:48.6228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGiGrhVB7JX8AHIKyB8tKZ2cs3MoYrjKBtbtBf2xukGGjhzmzmB9w+Wgt2kKdwfgvGUGJfLqp+qG5tdziVq1uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8463
X-OriginatorOrg: intel.com

On Thu, Aug 20, 2026 at 07:47:51AM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Tue, Aug 18, 2026 at 09:15:55AM +0000, Ackerley Tng wrote:
> >> From: Sean Christopherson <seanjc@google.com>
> >>
> >> KVM currently expects guest_memfd PFN lookups to return a refcounted
> >> struct page, which callers hold across fault handling.
> >>
> >> Holding a page reference across fault handling is problematic for
> >> guest_memfd. In-place memory conversions between confidential
> >> computing shared and private states inspect folio refcounts to ensure
> >> exclusive ownership by guest_memfd. A concurrent guest page fault
> >> taking a reference on the folio causes conversions to fail due to an
> >> elevated refcount.
> > Nit:
> > As this series is based on kvm-x86/next, where there's no in-place memory
> > conversion yet, kvm_gmem_get_pfn() does not hold shared filemap invalidate lock.
> >
> > However, the benefit of dropping the folio reference immediately before
> > returning from the guest_memfd PFN lookup -- preventing conversion failures due
> > to an elevated refcount -- should be effective only if the reference is dropped
> > before releasing the shared filemap invalidate lock.
> >
> > Do we need to make this info clear, since I think it's important? :)
> >
> 
> Is this what you meant?
> 
>   In-place conversions uses the filemap_invalidate_lock() for
>   synchronization of shared/private state. In kvm_gmem_get_pfn(), the
>   PFN needs to be prepared according to its shared/private state. Hence,
>   the filemap_invalidate_lock() is held while guest_memfd gets a folio
>   and decides to make private before returning a PFN.
> 
>   In kvm_gmem_get_pfn(), the folio refcount is dropped before releasing
>   filemap_invalidate_lock(). This ensures that a competing conversion
>   grabbing the filemap_invalidate_lock() will never see an elevated
>   refcount due to guest_memfd's folio-getting process.
> 
> It seems a bit weird to fit this into the commit message for this
> patch. I think I could put the above two paragraphs into the patch that
> introduces the filemap_invalidate_lock in kvm_gmem_get_pfn()?
Ok. Makes sense.

> >> guest_memfd already notifies KVM of page invalidations, so callers
> >> within KVM only need to respect the MMU invalidation protocol to safely
> >> rely on guest_memfd for page presence.
> >>
> >> Furthermore, removing struct page from the guest_memfd PFN lookup moves
> >> KVM closer toward supporting memory backends that are not backed by
> >> struct page.
> >
> > Could we also explain why the lack of SetPageDirty() (and mark_page_accessed())
> > for a gmem page, due to NULL being passed to kvm_release_faultin_page(), is
> > harmless?
> >
> 
> Sounds good. What do you think of this, continuing from the paragraph
> beginning "Furthermore":
> 
>   Drop the folio reference immediately before returning from the
>   guest_memfd PFN lookup, and stop returning the struct page pointer.
> 
>   ARM's gmem_abort() is guest_memfd specific. Since guest_memfd no longer
>   returns a page pointer, there's also no need to do any
>   freeing. kvm_release_faultin_page() originally also serves to set the page
>   dirty and accessed under some conditions. The dirty and accessed flags
>   don't matter for guest_memfd anyway, so it is safe to just drop the call to
>   kvm_release_faultin_page().
> 
>   For ARM's kvm_translate_vncr(), initialize the local page pointer to NULL
>   so that the shared cleanup path that releases fault-in pages safely no-ops
>   for guest_memfd.
> 
>   For x86, no additional changes are required in the MMU fault path
>   because the page fault tracking structure is zero-initialized at the
>   start of page fault handling, ensuring the refcounted page pointer is
>   already NULL.
LGTM. Thank you!

