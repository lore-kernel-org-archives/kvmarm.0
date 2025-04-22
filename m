Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD6C296152
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 16:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338437; cv=fail; b=CJyq1+GgVZJaYrxF0vnrN9INivaUgoLY3vy5ZFlsy+VT/+GU7pnFdR+bdlQbT1H/mcHH48rChCmvmMXoT0kJVEO0dA9WuQEidg2+O8EyRMw5n9/wltcVFhVKNZvvUfpp8nhweHLQNhCFy2h+BuRZyZBLsoYbwbMILCllkkNtKgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338437; c=relaxed/simple;
	bh=4m/9a/tkppTA7NXlt5DTFwmZGM7wTgmwFWZADKLbwvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TJxQBpz48vPILXkRf98ZVGNHejxLY8nw8gfYwZOYFM+pbb1dVD4VzSlVNxRqAMkV7cfLYIloAwwogOVM2kxbQ3ApT8K2lZjntyi13mKx79qdYsn9rqjYeUVvSz+r/71tqaMKzVddZmn6jUSPLTtPAsjTL9JZPSdhLD4Y9/uyJQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H6YcDuaK; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H6YcDuaK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QssGmpUT4bhMi9CDiUrtHDttplMLLIjaNOgGFvVji3QStthfsNnW+R72z8OB8XlfESKGfaNC0FBtp+8ubZdD3i8StQpSbxoS+q95q0GRJjr48L52M33uIbEKn0kVQqtPNJkpqou+lWbN8sFseKtKidImOzUH98TWSieeEGtykIcZLQX4nfY0K/uxF7GetsWy35BkqdVExnt99aTSjVj3tv0keAgZbTcoca8Nq4tqowmLb7wPlKYpEHOGK973f8TZ0hqGHhbOhIqSgrIPxqLzqU5PgCwIj2XoPubAp3U43mLjrmaV6Wlhhrvt1WU+8jzQoxvwIIEm1AN6cKPWHg21cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=la7FTdPfh+IT1f5g9jTPhDumlG/7bS8IC83+A6TxD+E=;
 b=sEcvnaJ93RZ5zvDWbOGEx0nEuJrlianeqmvISDfJo1IdzD8TimrxXcU0I4Wby1C4QirYJpvTHTgj3eHPwkCg+9GwFXe5kWyRV5KV/3qVsvSWRJ6BLlVN6tYVQcmO2bvN3M9OcglMcPw4ajniL5fboy1JHZwx4Ha0pe4Fs+NqIiqAbxocEVdrxUtAB86NKWZ794ma0eYJbjjzM90EnWiu4GBfg5k1i8MIh5VSJdCIYtRbFZuIXiek29CyXwxEr2n2MQ8M1A5pvMyr79iRFypXImwfU8b/XPIH3FPIB1mBwrKEaSOYYv+KKhpjsXwHbBhllNPAuFAUqNynDHF18e9f5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la7FTdPfh+IT1f5g9jTPhDumlG/7bS8IC83+A6TxD+E=;
 b=H6YcDuaKY4SHHqzTkyPQdDo1whPg6KNHimizPmWZZGsmD65naWi3fTIGwcq816AzKbzpGmbM9iNfePoF4PwvUmxw6UWLB7uQvyLoKoqy9kB1tdIvBF9fFNBd99l09AzdQDeoc38amNDtluWnF7knr/d8mwrJEgB6Uv73WIMr85O03aZKNQGHjPOPtasrp7OZHGQujqc1gu90nDfldkufAM02z5FIMepdSII4LiVSBrbzglRCjoH3t+qtX7gC5A5fyxraVwhfUi2OY5dNN0s1D6XSFiNCtnSKf3cfml4bTjuAWLAV55TovliqCREXALD/vGlajnMCGJEsefecwX22qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7130.namprd12.prod.outlook.com (2603:10b6:806:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 16:13:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 16:13:51 +0000
Date: Tue, 22 Apr 2025 10:54:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
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
Message-ID: <20250422135452.GL823903@nvidia.com>
References: <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAdKCGCuwlUeUXKY@linux.dev>
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: aa14d737-988d-49f1-4e00-08dd81b8abe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n0FpgyfRV1s9SiK0Dx0zN8D9bNWBkId2Iqa5F8wiK/32oDaTeG97+Zrp1LfG?=
 =?us-ascii?Q?r6dRAnFOL/NGAwkTLM1mPCz5kQtF+g7d2dcEtFQI5cwLQgWC+4ZgF0GHmii6?=
 =?us-ascii?Q?32GymXgs76TtBUvQGxWGpQ75/35Q37GkLqhAf4n/CpdEajiRMkWREUAKUQOK?=
 =?us-ascii?Q?nURS2CanAFZ3PHpOQ+NsxEedgM5SlskRwsVCouaGbMBQ0b4Sshh5h8jTFC2m?=
 =?us-ascii?Q?+QUaxsJh2SJd2P61Idm2YKSVRd6NCM+svNWlcZ+m4dJy3XnbWzaJvlludYhh?=
 =?us-ascii?Q?hkSZ0LP60EB0ZsPIoq2WAlO4DRseavAa2xNOV3S04dToBKnqJCMLxS4ETNCF?=
 =?us-ascii?Q?TmA9mC2tyi+1XrGdo30aFOp2WYypbkarYqbh5bpw/zorUQ3ih5+KOUBJY/qU?=
 =?us-ascii?Q?sPKl/Op8NCIEYCnvJfk4f9rG3WWGDNIaaxqvwn3D+4zQJMCPAicb7s+UtNE+?=
 =?us-ascii?Q?iQ2+fPha1/8jRHTxvLn6KEDOlPI1XxoqDq6tCD/ha/04/uhsAyBaLWsG6X7N?=
 =?us-ascii?Q?FBdtJTYtxM/SC5N2ytmiC6KVGxS5k+1rUcVMB/0pfcA8+Zv0aL2lDEDR/fZA?=
 =?us-ascii?Q?nusmoYCxz2+biMfTP3UMr7PaaQV95hX8EkfHcz25vkQehqIGGO/vm3t5kwPN?=
 =?us-ascii?Q?iY6iIFnq32xMeBt+1zfaDTeEeTrW0YoavyZkR0rG7fupZysNIgu/nef+QlFd?=
 =?us-ascii?Q?QBQhHUX5k166PcotR6CkWQAf5SdBxPM1kdlEC6DTOYhUKKtMIi9otHVob4is?=
 =?us-ascii?Q?1idRdTR5+Dg30uMhaKL4K61C+iXgO3Bw01TX8EIgUTxi4i3KFmuXPtT2fSx3?=
 =?us-ascii?Q?+HVQ3Hqz5+Mnv4bcs3GgBB1M9Qzkor5pwgr+764tpUxs9nGbS4oco1fEq/zS?=
 =?us-ascii?Q?mybv1FJ2zfpINp1VW3IX7P6yRS4spoZMi009Wqjq08shd/q5nBevkkxksDsn?=
 =?us-ascii?Q?bwLZaJ7O8wr0itELijtlc2t8FwvpL/GqDVPzFxRXgvjmr61u45uYZq8cD4V+?=
 =?us-ascii?Q?8+F5Zs9MXgAXKEvB3ZaBVALi5smfrziRNodS+b45Xxr0e0wn+QJ5YNDBOlj+?=
 =?us-ascii?Q?PARA6j8yrh3OG2GCurCkC/aI70PpqT0lHQTeodh4ZrpNo+peJQEl7TQhndyF?=
 =?us-ascii?Q?4VcpdtupCIpOI15lVbGHDSiduJF7aC+rAKfjna4MV6XSt7DwXhTWFaWHhT4P?=
 =?us-ascii?Q?CHcmGzO7txqLJJgzLFc1v8MD0fSp0HElTTlDPwqP9xmtgn6tFnlMGjEb128h?=
 =?us-ascii?Q?aloCI3L2GYfSSVyJFikYfderJgOdrS7Yvr3MwRtrvln3h9UmfOoaOcvwuUd2?=
 =?us-ascii?Q?AfASLfkI0TTcD+PMK1YYeQvPKTGz0Ti9iL0F6GCQ28oKMiPC6IVJinZxqTmX?=
 =?us-ascii?Q?JOsg4v88PRqmFlKc3Z5dTmssbtqawrgtXDlTDe4arh6pqx3/YbvdL18+qeE0?=
 =?us-ascii?Q?NMye7mWlu9E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iQrOjMla4YZae+SNy5uzl0fIg74MBgrzwADyOtToBCIhMWDf0UdXIMJgkX5t?=
 =?us-ascii?Q?/fym5u5F1yc6XpTO1xpw/UHvwUjrNuhdca1odJxKuWg52RbhNQmSSRonRoZ8?=
 =?us-ascii?Q?OGGIdClSlueTZl/bMGvYr1uzagA/jr6BmFSecbq5euvqCNBiXUqiZ296Ywei?=
 =?us-ascii?Q?6oCpxM/De9+VmGh/EutplScF8KRfsQgbWDaonpmlENgvYPrQodjME6iPof1/?=
 =?us-ascii?Q?THlSmodpTcTJzvcR6LhtSxchOM6EyjCqwyXR+LDwt1BmqTG7Uw3BO+TpSkPz?=
 =?us-ascii?Q?8s7O1g1P7uNxYsHthe3DfU6MCXW0zljM2Jy92RJG0j6iTDygoQTBRnZI8heS?=
 =?us-ascii?Q?JbBK+6p7wWbufG+bqGJ+s8HUvcoYDicE9suP+wmosuA1DLD/IdeBb4NzulGY?=
 =?us-ascii?Q?gR0H+FU866wbfoesb3PijmuTrnMGol77LRz6+g11zy0m9usJ3McJ0gcuxuvs?=
 =?us-ascii?Q?wn6s6AOX71eSCP1rQegaz+3+UjmgweMv8lJSTqrRyYYJcmuxUZ43Hwxi5PQ2?=
 =?us-ascii?Q?WgBP3/hixxRZZvgHf+iOfJMlTSHCnt/Jn3n8L9NO8EA5aUKVLxBXzAmazJ9X?=
 =?us-ascii?Q?UteuwN5vCgQPu77p9RjjneCKJd8unw/ZMWnremRqGqHhJ0xiv4PR5bOZRX6+?=
 =?us-ascii?Q?3phCz+JAvCQVEF63ZwaDAMJjMeUWxup6JaLnH4tdLclyKpb/5qRTRi0ONa6v?=
 =?us-ascii?Q?AhaulwBlK+vX2Ho/ARmRUjYOJGqwVtCkAlyQraqSbdZ/YLPM56h2yPQ1pnqx?=
 =?us-ascii?Q?e//W05ay7ZbLzkuhMOC/YQASe9IqCWp2sxmNEoUgoJzZkfgs8p2pHQ3W3zqV?=
 =?us-ascii?Q?92dgxq2t+Xoxedg9/IMmlBLBZJpJ4oLCyD+6VMHZqTfMHZG6J8ku3jEehO67?=
 =?us-ascii?Q?SPvc24/8E35oC8aoNmwUcbZLsiUuHanD/Zr8LrpA9SP1evuW9I35BhJVz2xb?=
 =?us-ascii?Q?vNcCJqhctA1ZcF7RqG9Jj9bqaoc/WXTl4aT/enfkEBlEUHxkVntfnFv3Wwp0?=
 =?us-ascii?Q?AlAGV0tl7rFbe467C7jZsdLEhQFtvQ/zztOZ7ijmzaeBjAFc3XVXhnP8Ep/2?=
 =?us-ascii?Q?tlaC0Og+LzM3bBJLckHRABrlHy+StQ+0XNwYrHFmEeAJMuZ7HC2gmBxXV6lr?=
 =?us-ascii?Q?tXz6BP6cvIE3gPwHOY7T3QGw3qzC/hp2rhL/KmaiYXe3IhcbDnhZ/LXJvm/M?=
 =?us-ascii?Q?3wzjKHvVgEvckjlBXgUbn5gRVfDY7ouBQT8Ob3hkjrRbGKzBVZKJ4Rkfp1lB?=
 =?us-ascii?Q?/+bcwsK5szBb/DiF3q71IiixuyvrSdIEarKQNgNHhyKYoUw/RsLvP6O972ob?=
 =?us-ascii?Q?b5NnXPn+B26XO4X/IcshQdwQVzmYmovZbwtnupf/xVxQrWFDYSFA5gNj9ycg?=
 =?us-ascii?Q?YtF87WotZP8HU8qvbA+VBRP1r3crgj0+03M4+Wuo3PkV1U4gbMCZcnguG82p?=
 =?us-ascii?Q?R/SliiTCEMWDJgjPiRKrfa0BXBiST33QO5kYJhuDFgXumU2dk8acXRx2bE04?=
 =?us-ascii?Q?L25f3MtjUq1PJzALxYiqsrVYvV7CXLrIFSzVkgDf1Rr6dKA1Mhl7x3dWor89?=
 =?us-ascii?Q?1Y/AVHvtRpwqPYtPM97HAEw9pY35qZyDvE/YaVdU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa14d737-988d-49f1-4e00-08dd81b8abe5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 16:13:51.6818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxuHdK4R98Ole5KV+eQIHhnBFU9sQAxCCSW44bhJrkbkbs0aSXRW3hB9nii37Npm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7130

On Tue, Apr 22, 2025 at 12:49:28AM -0700, Oliver Upton wrote:
> The reality is that userspace is an equal participant in remaining coherent with
> the guest. Whether or not FWB is employed for a particular region of IPA
> space is useful information for userspace deciding what it needs to do to access guest
> memory. Ignoring the Nvidia widget for a second, userspace also needs to know this for
> 'normal', kernel-managed memory so it understands what CMOs may be necessary when (for
> example) doing live migration of the VM.

Really? How does it work today then? Is this another existing problem?
Userspace is doing CMOs during live migration that are not necessary?

> So this KVM CAP needs to be paired with a memslot flag.
> 
>  - The capability says KVM is able to enforce Write-Back at stage-2

Sure

>  - The memslot flag says userspace expects a particular GFN range to guarantee
>    Write-Back semantics. This can be applied to 'normal', kernel-managed memory
>    and PFNMAP thingies that have cacheable attributes at host stage-1.

Userspace doesn't actaully know if it has a cachable mapping from VFIO
though :(

I don't really see a point in this. If the KVM has the cap then
userspace should assume the S2FWB behavior for all cachable memslots.

What should happen if you have S2FWB but don't pass the flag? For
normal kernel memory it should still use S2FWB. Thus for cachable
PFNMAP it makes sense that it should also still use S2FWB without the
flag?

So, if you set the flag and don't have S2FWB it will fail the memslot,
but then why not just rely on userspace to read the CAP and not create
the memslot in the first place?

If you don't set the flag then it should go ahead and use S2FWB anyhow
and not fail anyhow..

It doesn't make alot of sense to me and brings more complexity to
force userspace to discover the cachability of the VFIO side.

>  - Under no situation do we allow userspace to create non-cacheable mapping at
>    stage-2 for something PFNMAP cacheable at stage-1.

Yes. memslot creation should fail, and page fault should fail.

Jason
