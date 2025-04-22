Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0D214A74
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 23:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745364967; cv=fail; b=oGOJUk9j15rgj2XQIz/AWEfuPJmWeFUYPoR805jV8ixnITzHDVaeWxp/Dp4Ulosv8h0BZ/B5YuA+fJcOilx1g6T4CwaRS7vQB8X7ZKMgLDJVBQmeIKRKC2hD7YZx6A3emq7Cs5G1/V08Jj/1xmNFCKj0L2YL8YJ+hL73aLK4Ipg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745364967; c=relaxed/simple;
	bh=40RDSTmnKNdi+97Sw4ZGlW43Z2kFkX9fuinbhv8wR8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sp/ETN+uS1l3aHdoTRFg0z9iGhVpMXIjk3bLMAnnorxlzLd7ZCYd0rwESDNUEiVm/CBqz7FRDwYyOHGXjZjm4QJUYq7Ou35l+TZe3jLGmuqeeA1cjFzTJvbonVLTr6nyJzLWNY+lwbnxDvHZCep+qIbmkKQzVrKPfAFbBiu6J0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YwV+Ee9J; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YwV+Ee9J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b00a+D2U6U0ku1AMpbcitEQLoseK1+PbZmztu6hLOFjLQ1cnS+h9C6zH8a2h5n0/S4wJrjyHRgLNbw7JWoUADo5u7pI+Lmshj9h0L6KQ/qNjuqHOX5G2Vw7i2XKeGsLCACwu/9HA4pfreQ1iujlOwTxSMTmgcdIC+WI+NJFDiAyqYLzuxwMAIUkdGUrU1GhxqriG4nl7kkO1U11o3vJZiFSL+hrqy5NcEboVjCwn1CEIHxIouQkdWErJkkfXHMYLsJhpIa6+BSbWPyUww9BRh+4FPbhk7jDsJlA6gbVSnqL8nzi6WFJ2ncTPt8YP4XH6KUBTgVdz/EYiMNif0+90cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlygJG8kSWtI1KaCbzDPKc6kOHVZQjMz3VIqH+Xkceg=;
 b=MDSEacMHReG23dRn+7SXCBzLFOiJOvdSVc/Afghs1ESKch+HUGreF+2yD5Mx+zIywxQ2DzeMUTPl5eSedKqfBJ3PTTEYaYgqF2s3/xn55Zw7xABq1czH43i1z5qTil5/33lEbZLbYzRHnkNS0qXS7kjDKHa7bCgBOfoxiOOjEF8/MquiB8yogyuIM65t2jSkE71LMjGVGKyb0ZUfzmK80Kt/6qxyU320CWB2khZdiFZnMZC1YymwMsvX8tmir8txIT3KTt+BrwfVmPKJmWATj5OY4wMldVYs9UjVwT8GBXNJO7k1H2FEDHYMR5JsO88QzbR1ntoCQdvJRz1fQ0/Mww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlygJG8kSWtI1KaCbzDPKc6kOHVZQjMz3VIqH+Xkceg=;
 b=YwV+Ee9J31HEhhIFtiXCk2Q9FjKBa0bWL54iXRIXaPtNluGBkarqSQq6Bow9q+Bcz+XTai53BFQYAhbmKF2yVi6EG3WyZdTfDSOTHqSTy6tlD6WS4nWrtWVzj18MLERVlkIdw7PunAECWMtnP4ADGYF9Flt1M9pWVGO7eI9ZLeNbQiiE2xiyKixZhDEkvjTIQo1QcK8HyfmX1hD95h15cDR5YxYpffkXRyz57umwrqxXqwO2+RLPNRs9FoiYrx9POdEzTdtv8plw5xARq3KnLKubwDr7gqMQlzkYgBdQHMt4peEuWitdqtoiuHZ8NxdYtmlanOmug9FsS8kuP6m78Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8407.namprd12.prod.outlook.com (2603:10b6:208:3d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 23:35:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 23:35:58 +0000
Date: Tue, 22 Apr 2025 20:35:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
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
Message-ID: <20250422233556.GB1648741@nvidia.com>
References: <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAgJ8g8Gbb06quSM@linux.dev>
X-ClientProxiedBy: MN0PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:208:530::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8407:EE_
X-MS-Office365-Filtering-Correlation-Id: 2deeafad-6380-42f3-4b09-08dd81f66ef3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wFUOLerbKKVxL/ebfLnMIv/ADXb2Q9JEHWyNMLqOuNWyXYsLJrut7FeSSPs2?=
 =?us-ascii?Q?rtKh8vqJDvxJLAQAljT0wnJZAJYL4jxC5QYJX9PuDJGebca0olxTQjwWTPvF?=
 =?us-ascii?Q?9e1weMlZAa1C3blEo4/1qkVAWpDZsQtkFF6IN+ttJEGdn/4CX9jt9HPSOfog?=
 =?us-ascii?Q?Ahcd+588Qt7pHey1sxcdMOj2B60ZRX1i8lESVx56zoll7lbu7r+LqFVmEAF+?=
 =?us-ascii?Q?emFR0lfs5J8UBbxkIqn8OJH/T9VaN8GdQMj5quDpA97pLgtz5Z8DhuvR4ujk?=
 =?us-ascii?Q?LGy3PBxVWY1LqdyblleYeqJy2rrAPZgaDNWGb1RQofeelPylkACPatCeaxvY?=
 =?us-ascii?Q?kOPrSYRd9yslzOs5rNU8SCZcXHIOjLwLUnSo0uWMEtEA8faOdHWj8LjQ/wUt?=
 =?us-ascii?Q?vc2HZAySTLuBdfVV9ciXp4xjrBriXS83oHdluXdYIG200Z+dyjk/r2LZRhGE?=
 =?us-ascii?Q?geUNlXKGcXefNKlAtyQSWdhyuH7iyB6DN2Pfkp+7sTm1TMlsHITxXvZQwc4c?=
 =?us-ascii?Q?gzEVH0YeAVIURqaTy1XD4VlFLqPZkIrq5AvcLuyWbJg2eMQWsaRxoqHYeWXe?=
 =?us-ascii?Q?i0oGL5Zk5KjjWfWhivV4EfK0fxq8JX76lOpg8nLOy3dBs8eGKTdJhGee+4KY?=
 =?us-ascii?Q?YoGqQCbbOs8qHWD13qhjR7fp8s2joimiTYxxOx43pjehBRpZq/eJMHjSSDKX?=
 =?us-ascii?Q?JL5BDDa5Zvw84JQKxS18yAbzI0WNefFmGJQApELy0o2xP0VP74kj2tg44Vc3?=
 =?us-ascii?Q?oyH2A1ThZJwcoNCa36g9k6r6WWKKxjsezApFlcHFSzUCPKdJN99rNXoZi1V/?=
 =?us-ascii?Q?aMBGfkEwiEW+8WitxuA35wWd7dAWwvQfQzD+jpBBQpz8rxcJels2tyv8ZZ+Q?=
 =?us-ascii?Q?Cm9s0wajI1zu14M5p7MOMKDcCWJmgRKJJIuAVA7PxegLCznr1axM5SYO21zu?=
 =?us-ascii?Q?bHe7hboPqwYKDe8J1IHz5yaukACmdseDHUTapwoVJ+wqnaTM6610TkMHWYeZ?=
 =?us-ascii?Q?xOpguhWIh/mBfvnuOqwjE/cuhUXHzAz9XkMXHuvVAgQn1Xr9s7S5QuzApjqB?=
 =?us-ascii?Q?0ea9EXdARLakmYYnUwQS89X7miisrkZ0OSAm0niTk6xaQPegelWgCWQn4Gdc?=
 =?us-ascii?Q?h/EOXV1iNB006VENw08jyBxO0xOCTXMc6+Tfr64wX43CDJWXuXKshg9nV9U5?=
 =?us-ascii?Q?VOSF80qqlrfvpsHcwP/8Nu2sxWD3iCmtarPqNOLp774FiRzFIr6uo4aa8bdY?=
 =?us-ascii?Q?n0DLVKlLMmhGhzbArW1oqjGfQzTbfT2lACmbroH18akz2DuRiBmYRBf9GqmM?=
 =?us-ascii?Q?2Tpt0EyJ/1lP1j21b4srleVRONX6rxJVq3RW+EZxfTTl0iraiIUlJPpWpslD?=
 =?us-ascii?Q?KuqfhaJymBo+NQgSf0iKuXU76hOuS044nM6QG0C7AI+BTO27G0DfwrZToooi?=
 =?us-ascii?Q?h8fyc3nXsvg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PeQq2H1WXdzKei0NZbjUlczjYgjj0+oZcnMXV7XtmBglzwMeUnNVYt4mCxhQ?=
 =?us-ascii?Q?qNqdyCOH7E9h2Diab7KArKbB9jWztxrXf/OfMo5ncdunKnB1kZ2fldfP3eKI?=
 =?us-ascii?Q?+uDFo2Eb6Be97Z/4ZeTXDQoSgvW/gfFUWXd3kYPYsk1MdCKWDXoqmL4wBveJ?=
 =?us-ascii?Q?Za8yUgpPCvC9wxek2H/hP2fRcXAr+cigWjl/1D3HbL2zhIuT5G2/a4HYiadv?=
 =?us-ascii?Q?r3Kq+sc13Ht7VIKSdPMsta3q7Sx0Pg6iU4WBARh5EJyiah9IFWJlvO4cDSCj?=
 =?us-ascii?Q?BmmxaZkEQumUQTr1Ucxd+8UBSGHrGTo4g4PGQAJtrMgm7B9hCAxOyAcvGEVz?=
 =?us-ascii?Q?BJIWRd5rEXUYDPnjysu3WKj7F/CGsahYrsDNk5qLuaXZD3Zxw/OUoTmXSjR1?=
 =?us-ascii?Q?ZkuG2SUuFjyiGdM4iJXY731YGXa/xPpQrBr8OmOnkmgAt9IqcHgKW2YNRPG4?=
 =?us-ascii?Q?xelYePc9gs/OnY2n/ObC3z2epqqVqFZsCxKk1O/MxnaRoeCNYa7vqRql4ex6?=
 =?us-ascii?Q?WIj7LM5YEunUgySqXNNz9mQMjKhDwaVyT2gm7IfvbAdjvMXv5ESViJFi07b9?=
 =?us-ascii?Q?t7rekYC6iO8bCZj8rnOfWcLn1hQH2iLo97nq01sNnFMtgGXhNpadu/lYx+ZD?=
 =?us-ascii?Q?eAYcUzOPK2G8wKXzl+MX4KHnErKWCwXN6w3kCvOhIKC6FmEJPRikeKY2wC7w?=
 =?us-ascii?Q?6v4Tj5+mY/VoAIFb4QLCO86aCcK9kwO3JC3EJ/jRDObyzBO4xY/Lzcnl5fev?=
 =?us-ascii?Q?CHxyGEtx9yb9/GUtariWEjrkZVp175WgWMwYI2aDm5Otn6ILxP58J65y6zMk?=
 =?us-ascii?Q?yKbmQFVo4XbN3awuamPEgHixzFQ3B8fyDKW2MuZtpq5QcJTr/oSUrhee6xz7?=
 =?us-ascii?Q?4gjU63Zu3v+n0ypVbwPYJXtxj8alzDaRk8LvfNvYBGW1mk4MhfY80ib82RaM?=
 =?us-ascii?Q?U4hYxmXWi/lR8PIe9frtvfrng/EQfH4FnTrMPxX5gK41lyN3DMhJPE+3WTtI?=
 =?us-ascii?Q?sl3QyfV9xlA45Svmm/4phbvwU8/eY2fpOE2pWynhg6FBNYUvl1ibihpNOyf9?=
 =?us-ascii?Q?bEPu7hRnQowSemVPAFW7R+UOCzn5pGfLmc48hNQPV3NnjrWNrgX5vfvz9Lb+?=
 =?us-ascii?Q?DVcCXxm+fEzablZnf9Bcsz9b7Tg/dtAVpIcPuimPBOAwE61KcUdEy6bo6QJy?=
 =?us-ascii?Q?Xg9TTdsIAWVgTqqvkoXliEeLUrpqhFoC7IGHCENgd87skcuLEP5yUR3xPhrS?=
 =?us-ascii?Q?sr4TN/1FgGXNF2NfyERHRa02r2m4Pp8hY5Sos8oG5estud4xdGC8qaNOXr3C?=
 =?us-ascii?Q?l2R6Y8ngHqTZh05wQPAB7V7SYo4L4SsQN+VHqVFm52lhikUS9UdvGmUE2iYd?=
 =?us-ascii?Q?anW2UT9pG18op1MYm2IQKY/p/BSdO1t7tgjxhdjOAFD1TdhHinyK0l70xgNQ?=
 =?us-ascii?Q?+DNzlBJUh9nGrTAym3B3srSG3Y0vkr4mHsMF0dVUfEaOeCfHjLjphlpBK4YV?=
 =?us-ascii?Q?YPKJYqLtyRHUqq7uuZ4exGOUQj23xrJoIKaHfz1wB6UwSjOsXpqlnQOfLhVu?=
 =?us-ascii?Q?B+tJjnNQCDSpr9lI+202M75JhO5lLzCkJmm7AG6Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2deeafad-6380-42f3-4b09-08dd81f66ef3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 23:35:58.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6NmobJ1rYOVoncfNDFAKdbJioU7o5hnr4FrB0wvIzH2/xrKcIF3YrMuFU/t89MI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8407

On Tue, Apr 22, 2025 at 02:28:18PM -0700, Oliver Upton wrote:
> So, if a VMM wants to do migration of VMs on !S2FWB correctly, it'd
> probably want to know it can elide CMOs on something that actually bears
> the feature.

OK

> > >  - The memslot flag says userspace expects a particular GFN range to guarantee
> > >    Write-Back semantics. This can be applied to 'normal', kernel-managed memory
> > >    and PFNMAP thingies that have cacheable attributes at host stage-1.
> > 
> > Userspace doesn't actaully know if it has a cachable mapping from VFIO
> > though :(
> 
> That seems like a shortcoming on the VFIO side, not a KVM issue. What if
> userspace wants to do atomics on some VFIO mapping, doesn't it need to
> know that it has something with WB?

VFIO is almost always un cachable. So far there is only one device
merged, and CXL is coming, that would even support/require cachable.

VFIO always had this sort of programming model where the userspace
needs to know details about the device it is using so it hasn't really
been an issue so far that the kernel doesn't tell the userspace what
cachability it got.. We could add it but now we are adding new kernel
code, qemu code and kvm code that is actually pretty pointless.

> > I don't really see a point in this. If the KVM has the cap then
> > userspace should assume the S2FWB behavior for all cachable memslots.
> 
> Wait, so userspace simultaneously doesn't know the cacheability at host
> stage-1 but *does* for stage-2? 

No, it doesn't know either. The point is the VMM doesn't care about
any of this. It just wants to connect KVM to VFIO and have the kernel
internally negotiate the details of how that works.

There is zero value in the VMM being aware that KVM/VFIO is using
cachable or non-cachable mappings because it will never touch this
memory anyhow, and arguably it would be happier if it wasn't even in a
VMA in the first place.

> This is why I contend that userspace needs a mechanism to discover
> the memory attributes on a given memslot.  Without it there's no way
> of knowing what's a cacheable memslot.

If it cares about this then it should know by virtue of having put a
cachable VMA into the memslot.

> Along those lines, how is the VMM going to describe that cacheable
> PFNMAP region to the guest?

Heh. It creates a virtual PCI device in the guest and the space is
mapped to a virtual BAR. When the guest driver binds to this device it
will map the virtual BAR as cachable instead of as IO because it knows
to do that based on the vPCI device ID.

If something goes weird and the guest tries to use UC instead of
cachable the S2FWB will block it and the guest will probably
malfunction.

CXL will probably have the VMM understand things a bit more and will
generate the various ACPI tables CXL uses.

> > What should happen if you have S2FWB but don't pass the flag? For
> > normal kernel memory it should still use S2FWB. Thus for cachable
> > PFNMAP it makes sense that it should also still use S2FWB without the
> > flag?
> 
> For kernel-managed memory, I agree. Accepting the flag for a memslot
> containing such memory would solely be for discoverability.
> 
> OTOH, cacheable PFNMAP is a new feature and I see no issue compelling
> the use of a new bit with it.

Feels weird to me. Now the VMM has to discover if the KVM supports the
new flag and only use it on new KVM versions just to accomplish..
nothing?

> The entire reason I'm dragging my feet about this is I'm concerned we've
> papered over the complexity of memory attributes (regardless of
> provenance) for way too long. KVM's done enough to make this dance 'work'
> in the context of kernel-managed memory, but adding more implicit KVM
> behavior for cacheable thingies makes the KVM UAPI even more
> unintelligible (as if it weren't already).

It is very complex.. I'm not sure adding a flag in this case is making
it any simpler though.

If you had a flag from day 0 that said 'this is a MMIO mapping do MMIO
stuff' that would be alot clearer about how it should be used.

But here we have a flag that doesn't seem well defined. When should
the VMM set this flag?

> So this flag isn't about giving userspace any degree of control over
> memory attributes. Just a way to know for things it _expects_ to be
> treated as cacheable can be guaranteed to use cacheable attributes in
> the VM.

Can you get some agreement with Sean? He seems very strongly opposed to
this direction. 

Jason
