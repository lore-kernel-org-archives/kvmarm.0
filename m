Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A65621ADA4
	for <kvmarm@lists.linux.dev>; Mon, 31 Mar 2025 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743432284; cv=fail; b=stMEeaLZ70qsc3zDsn2aHbeQL+WNBVSc67Clio/KHAt3LGMiZp35poPmdrsQeyUQAuMr+PY2JMf+mMNmTFpcSCixR7o1oEDcptdHP8y2sejgwgox8KWY4m4WX+1cMzrqcsrhbRgM9mL0go/GJGGFuHK+FyDN9Tfg8yP6zCUOqVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743432284; c=relaxed/simple;
	bh=911AwIb/CLWKdc6DSEnd31NOI5IBzaVagNrnpplTcYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qna5xrq1NewXV+NreM0vJcvW7DVMO6W9ovseQnr9ig7Lh9CAWeX6YEtfJDj06dCHbUuEjc6RL1XrOl76txlHFUFSkBSKeDFkah9sDa1DeKzeWRPTNMWjJv7JtZ+461k0O4Yq28VgePjfDeS83B9zpeafzJA9JU0RQtoQl3eXd+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WIW8MXqi; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WIW8MXqi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahdq2rznK1+Cfhq5XSNcCEsRf7Jeze8vW5aKEAMwoX0aFRQaqca3vPaBKHHTYIUDH7y/Z92FkMRsYTnsUSCqfbNW8w8PU7Q+SZtTgaJgZeHx5fzwqb4HsSlPAEIPPWAfZ3ZMU4+XFzEmf02myCEZzUfH1wyO/uX4Y0aBTAiR32KG082tcSVNdc2CWZK1xU092AZtoTwrGSjrWsZVQkBD4GC37Csj/QjylmcUNik/q5NFQhzPT/f2WcO1RA4ypTAPfyPe6N1xlsjJuJn+PvbYxjDKE6o/2B9/wPYeS8p/nS6NxMlnKsyGrnjc2D8z0/eDOezU8Mf6nvNRcBARVXUE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlBal7a6oB4nI+VbN34rcn/mU7YEyIyu9Djj/qwib8I=;
 b=dyBQdhb0cFkY3965zIZ6DjCWGiR3MF/ezJH7jPvBBrgayzk2ABiTN6277xvgzSxbRg+GLFdEEvY22OUTtWTVKQxuXUw1XnJjiWoJqILBqR9/wzJS6+Kr/bQn6D8ZaQdCUN8u+6Q24QrYGvlVj6tsCcN1enB3Ao9PUhvAmbPn5DmgFulhSmgKP0Ho3ZQ5vWaSXDjTb14vUDEUxrkq53YmijCZ2Jn6X9Dj1LkLV1HD1hwhpJqyJwXw7uLkitdxKURrGdjJq1DM+8SN5A55WChF2ADhWmdHfDobJmk4bYmt5tGyJVoNKKvqLd9yFbmIN+DaucOuWd6FZiH172jy2BZvDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlBal7a6oB4nI+VbN34rcn/mU7YEyIyu9Djj/qwib8I=;
 b=WIW8MXqi2+NmLerc6uapQnEwoCGNn9tqwHJfkHr4+rh2S28djUGVX/s/v6/Pj1clNO+4IDD3ULMjqTISGeCPn3BB2H4fsjUy+eZ+VPj5h9stQQg+IJZsAI2pkq997wv6Rx7VAqOfX7McM8PHjIMbP+ffy0/LiKuTu+xv4VJxL96bZT+q2hycHi+Q7J9DBVACMn1IQR8n1vKalbFzwVMPB57cdKvqMKAmRjLQUKLpdfy3/myygqZ6irw9B1Ql7QzyVfaPzuaxour4yFjaH7wB3U6Wryya25oz9pX5EhELk0f8Oc21QnxsJkLpZ4kzQsnvHthVwKrYsL2RpIILnS4cSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 14:44:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 14:44:38 +0000
Date: Mon, 31 Mar 2025 11:44:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Message-ID: <20250331144437.GE10839@nvidia.com>
References: <Z9sItt8BIgvbBY8M@arm.com>
 <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com>
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com>
 <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <Z-RMzYHOzc36H7yR@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-RMzYHOzc36H7yR@linux.dev>
X-ClientProxiedBy: MN2PR16CA0036.namprd16.prod.outlook.com
 (2603:10b6:208:134::49) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ef912a-c977-40bc-e388-08dd70628fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jzv0yHpBc6AsjT4kMJwf7ZqJARkeKPOaoxbtGwb1qw3TqIEbNe4A//d+Lt6S?=
 =?us-ascii?Q?J1fZK4YxduGyfVAAJJfVV6W7+Sj+cRV9r2+lZgSX6KeI/adMtQn6vsTjq0UZ?=
 =?us-ascii?Q?d1VoemI0rx/d/Gy/HOe5He+NFmBir2RFgSfgoegdje12XfpT+MB8n0VmFqTX?=
 =?us-ascii?Q?Ox6Nu9KxaX4cwQ+lk+tyLJpnZRU6iMXooyPpcOXbLrgh4NNRE6NRmiuEgCHd?=
 =?us-ascii?Q?VkBljIrXQZzhr66w/mz63ELHTPYpH/z9PCgXrF5mnM8PC37spw3OHYuDMvW6?=
 =?us-ascii?Q?Uws9bVJLDrTFol36nE6DqnRfK3n8ASJw1ZMHGly7iRGJuJVD8E9F0gpIZlPT?=
 =?us-ascii?Q?JdW2ypBcgCaq9DmkULELH8xhHwAFHXhPUY+xfSsACKrUyWrBHgY7KMMzkSWD?=
 =?us-ascii?Q?F8gn8CBReAZoEuhiMKBTZTfg5+UK02Z3/rYhK9KG7LEs1eeKHGkRqz/R3oiP?=
 =?us-ascii?Q?MriFtTY3Q3uRBTLKb6TRHWOm3szzd0gvgv+6zz6rRkT8EUFYnl/GUeYq2pH5?=
 =?us-ascii?Q?5DAVMB7yKrWz/Rlht8XylVPjMShO2zgSmTMK686srBvDx5tonG1ztm3t9098?=
 =?us-ascii?Q?fCyaTkwBx0I333E2rfmY3wGpb3nPOnJntUvefc5AbLn2C/BUdw3BWHr+6dQU?=
 =?us-ascii?Q?oYjCKTNvmQmIK9Ko9eWj32R59eiykTMMOsHWmj7899oI0gVvbV1cK2vIgBZV?=
 =?us-ascii?Q?RpKryKTtIDWc2GBXSuXKaDFcFGBA4toU6vG1rZ2aVtCV537LEkIAa4pPidfG?=
 =?us-ascii?Q?LDiyvrlP6w8ixGzOtcZ2gGGEhUau6+/uT727R0+uDDg2/jtq47GtSx5ZXmdR?=
 =?us-ascii?Q?fLeSpqQ/MLO43Q46iereABR/kUKi6k7fevN1b/mOd12993W21fOtnMsDNz/y?=
 =?us-ascii?Q?qmR8q4IMU1xMNFRwgV/9fFu3bQ6JThQCOjD+QLme9ONIRNjnBoiGUeWmU0/g?=
 =?us-ascii?Q?8MAIpZVFronlkYzMrhuaKc6Dnu6xI05P1Mx9h2+Xa9Xked+AytmtpLxRCKsw?=
 =?us-ascii?Q?wGEnowS3Lmrtfu4bsUPU56MS922v7dgdpG0zmtQQ3wqPk20G0dGbJAnuS2EN?=
 =?us-ascii?Q?T6pT4FPAl8S2/IGnKDZL9+plP1toWKcIZzmz/VU2022U7bzX2aRtTfUy4hbJ?=
 =?us-ascii?Q?QhLP4NTWW3nuD5QSiRoSQ3p4UfcVF3qvqr2ga2rE9b6IfXqAMiD41rr4f7Nj?=
 =?us-ascii?Q?lrzJdoRY0i1vjJyxEBuwmN1EHOt1L/JGLrpwzUgdLaURn7ndkh4ZuJsvJE42?=
 =?us-ascii?Q?HInxIN6pkOG3Ikg47wuMhw2hA7wUEMlkJBkNK5NHbU3m8zZCYb1CLgx5imJy?=
 =?us-ascii?Q?y+g23viPChLJ5At9u2H2Oz5LEX4qjBK9OQzwnovcCb0AM/nhPs8LHD/A73wN?=
 =?us-ascii?Q?qxlzwO0rxBVHGvLAtFKDHIJFhfEv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sUA+Xs7NNTx+Iumt7PCqWNYshOqlrmdBq/FOCxZvgtgI2UKXTO5q9rx/3opr?=
 =?us-ascii?Q?/PSt1HCgj8mz/aLlGfpX5r+lsHEKZZ8uffdbDx0zAbEg1IpUL92bYkRjN+yH?=
 =?us-ascii?Q?xaxkSnaQWRv3KX4eOEOmrSlzRIktfbEtCb0bkClqma9/zsTXB+sIjjuqZLIs?=
 =?us-ascii?Q?XA9jrbKK09m/vBJHXYLyVWMVbTlb91yrWShbxsomJVxjnKPy/MLPCcwOGolZ?=
 =?us-ascii?Q?f4zwtzohsKcHfz5EgzEr5nUX1yt8ywM325bQlfhZ3rLkYJhTECWLNQyfXIY+?=
 =?us-ascii?Q?44E+NfMMuzis0mbFSAg3vtHFCIIVtZz+9lTQj1bNz4OaJUNkoNSoH7D5K1fc?=
 =?us-ascii?Q?NbR2y2e6Bahfun9oRHgqOSgg8IAVtXtS/jlKRpPWub36NTbKMwuCXH7++DSu?=
 =?us-ascii?Q?UL8B4lTlgbQ7+3YRmyc/u0XfDH+TB2lwcdAz5irZ+xgCZHV93gSVbP1P1XlC?=
 =?us-ascii?Q?qtpAVnsDbq5Hi9h1FbyhKc0jst2pBwG49yj+mdnT2XbDGQKoRkppmVp5lvvY?=
 =?us-ascii?Q?J/Ko1budhQCNTLHObrJxh5J2bhD3ZvWilSv7YOXeu6fyLFAWvpJ9GDvPpk0l?=
 =?us-ascii?Q?XYi/rzHMb6MPfzK8f8OsJyB5Fz/SWolHR3AOTjuCkhj0YFMq3TzwgnbpMGqa?=
 =?us-ascii?Q?cWuqmkD3Gx2Z8AjW96Lb+lg6IWafwdD17NeHQ9CBKCM+YtCBh7pXfGiNL0x9?=
 =?us-ascii?Q?rB2883aOO6tdOSifLX+9UG7XttKoiVjCJduw1gEo5UaQoccymyuOHJgVs9Pt?=
 =?us-ascii?Q?X+OLkis25p8Pe2YFQC/G1qIxa6Ept1VEO8TR6KD+qunzGdgHmHFvp8PfSr61?=
 =?us-ascii?Q?6xEBegZBmFiFaRPqH9ylAdBIU4TSwv8/Ps1uX1bXDNnzLxso79rmTIirxBa7?=
 =?us-ascii?Q?ea4/V0B1phRuks2pDaiSBwzuphqwKMs/PDapLMpAvG900aNkSf3+fUu+omgW?=
 =?us-ascii?Q?mBRapxkBcy8FRSadphK+luwoF1TJedqd9Ygkg0+r3MhChMCYDF6WGhywk8xd?=
 =?us-ascii?Q?xAs3DpkabtC5KRmYh4Q2/EXo8GwCtmjJew88BxGdvuQtSjPJ7nmia1XGMoWt?=
 =?us-ascii?Q?yy2Oo6kNbzCSiMk/U1aLYkAHLUxYaJrvb8FtcF1b7ih8SldNQGHWfB19hjQZ?=
 =?us-ascii?Q?WDz8vMmGNlDZ50MBzUYYmTl18ZNO2CXi+8J1BL73mWpnkzb38G1oyz5vFKyU?=
 =?us-ascii?Q?YjLZnisgyNpko8wlAGvx9Z0SclojZ3PLgh0PNthyHXlWRhKT+K3sMOMbVpbX?=
 =?us-ascii?Q?y7Pi99BvcnakOLdeGFJLzeGCdsWR9JRlJISMvb1W30WoRQMTKFohWi+T+CHk?=
 =?us-ascii?Q?A6FSCF/cYLgZsjpesFNgtsQkIzXoaS1nPpXMEaAY6XlQoH3Ef4kmksjx3gft?=
 =?us-ascii?Q?AEnDGVbdJVBEUDYFpsZ4qePFSyYX+cMSnytmBEVBgK1Swcj8OA62SooFgpoW?=
 =?us-ascii?Q?oU/Tc5Je74gh0sZ65e/aH1+jiW0BjEMznI272Ry+d0AcNGywz3h19xM3xhYL?=
 =?us-ascii?Q?/84CFd8h7cqhTLhdfXQ29fKf5V+ujEIqpTGN7ZVBx1INv4PJiELnM/411PIQ?=
 =?us-ascii?Q?B83LJ74wi/WlJj0brx3GROR7srHT3RxbdEhIkpdr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ef912a-c977-40bc-e388-08dd70628fdd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 14:44:38.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Hzx/bnf3iq7E5OynG529CzyOrd25tTETvVOmwxf6ovkO3NBjK9jPRwbt4umfyC3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634

On Wed, Mar 26, 2025 at 11:51:57AM -0700, Oliver Upton wrote:
> 
>  1) If struct page memory, use a cacheable mapping. CMO for non-FWB.
> 
>  2) If cacheable PFNMAP:
>    a) With FWB, use a cacheable mapping
>    b) Without FWB, fail.
> 
>  3) If VM_ALLOW_ANY_UNCACHED, use Normal Non-Cacheable mapping
> 
>  4) Otherwise, Device-nGnRE
> 
> I understand 2b breaks ABI, but the 'typical' VFIO usages fall into (3)
> and (4).

+1 (and +1 to Sean's remark about strictly tracking the VMA as well)

IMHO not doing 2b is a "security" bug today. Catalin suggested we fix
it as a first step to get agreement on this assement and fix. Once
fixed there is no way for KVM to create a S2 with cachable semantics
different from the VMA, or to have missing CMOs.

That simplifies the discussion of adding 2a to strictly track
cachable.

I also don't see a need for a flag here.

> A pedantic but correct live migration / snapshotting implementation
> on non-FWB would need to do CMOs in case the VM used a non-WB
> mapping for memory.

From a live migration perspecive, we have already built in a lot of
things on the VFIO side where a live migration can be attempted and
then fail because of late-detected HW incompatibilities. We've sort of
punted this for now to the orchestrator and operator. There is an
expectation the environment will somehow ensure that live migration
machine pools are sufficiently uniform when using VFIO. It is much
more restricted than normal no-VFIO VM live migration.

Given you can't have VM live migration of MMIO backed Cachable memory
without a VFIO live migration driver, I wouldn't worry too much about
these fine details from the KVM side. If /proc/cpuinfo shows the FWB
that would be approximately similar discoverability to all the other
limitations.

Jason
