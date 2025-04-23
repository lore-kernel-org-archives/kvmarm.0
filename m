Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0D2E406
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 13:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413411; cv=fail; b=nSiKxz5cSos8C4RhpsKR7lcFl7BpXOpwcvspHmJKoo3IRHGolHYemivsSFUevMDMOy60bUhhnP9pwvb2ZRms31Q9Trd7N07wL+CScPzQohn6L3H7j/C9cwR3naXlBUBiQfW6X62lyHfmjVNIZ5giTFF5J5bwWEuws9zMDo4aEJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413411; c=relaxed/simple;
	bh=81QLPnyJbTc0dqrYV3+GR80Tu8I5e/LoYKIpgEqZRMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rNJDrbo+C7timsqoiZ72jkNkVvmLy++nAV/ITnufoTU8o1t/YwA9Xwp4gfKCjXwQJzrvQXmAAjPWSRLRuc06mxk69L7WWyjH5fkVMv42dy4NXKWKWBhRQYzttpvUQmi6u2KViKD3ob1HPa29r6NEoBCPaV9kliGc6RqB4rH+A1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QYbEL+XJ; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QYbEL+XJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O5QeDa8elCQzy5GxrqXnG9ZT9EWOToUnBNnA07zfCPJFHc+hbrTG87t+vJrz7kbIkXjUOvLFZpLkPiS/Uq2b2gy+x+rybnjLKJZAtuRlvq+sjem2py2Bzb5nnKFpEISWedI0bQFKCSLKNX8OpT7cW5o6oWX5vXIwDYYri7b9SYdwr/gbjBGMeCtkLiHNDgBejUkje6uCVs+RBqoG/yQoSaNOZKJayIriRIKygj8rw7i3b2CTdiaG+oxJC8BGxXMe6RGa7jVsWVV3pv+ZBa5/ZHAiChTWphG7knOogLmvaWWsv0szlIrGAh7IB37yBvYTZBjXNfXaBhjZTNJsT6tOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XVYf442+e4KG/VeWMJgr4ZmkzuTTIH/e9UqvvGl9Cw=;
 b=rniXrl22HiDFM06tT0YJLtAkUALGT/MfyTYqQxv7hAFGYfjx/IECnzi1ePGv8EPXowF+Kv8b4JioE/FYBwMSKO32GM6kL6CET67x+RzZIwMk8JTlYsJqRM8yXewmuKNJl+GubUvmqdniB4RXrYHIoloZnt3w2jgXSgO0lZ3G1T1YZm8ZjbY1OmMhtzkc0EP/ahNOFuNNuC+3r+t0N0UBLWkClMivWQMfDxZ5op5nWNU0ZwBlw4fK/pLGqWmliMg0mwqf13eq0uronRdxkxPerObmHI/lCehghVrPoX2HF+rnpuvIFo+/jZ6UpAQ3k+Xo884dt19m0NTeIfh1d2APkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XVYf442+e4KG/VeWMJgr4ZmkzuTTIH/e9UqvvGl9Cw=;
 b=QYbEL+XJDMwtqfS4m2Aww2pctMvGLbwcusb4mENDN3SoUYKQkpW2cddyDtrzUQCwnaNDloaB6eDYcJ4HRpiVJMCeZMVfDXF2SdTpyOWBoLgqu1fLp4bbkStOJURwuioE69JpyGQmOXn++jXwKw97WGS/yguXY19fk0qF5q158KbNIA5eaekmOLltdLDOn+EIdcsM72EqLSSgoSwNL1Kino0lOJ6sRzLOC5McPkeWYL59u55gDXfOZfR4t+tSJx1kfORuWeM/x+UmNKST8a2zovtwAoFqZAnqxkrQCZREbpmj7tAyUCGYG0hkzzu9nHPmB0ZJn8y/wHXIl4uQkxXvxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB9037.namprd12.prod.outlook.com (2603:10b6:8:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 13:03:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Wed, 23 Apr 2025
 13:03:25 +0000
Date: Wed, 23 Apr 2025 10:03:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
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
Message-ID: <20250423130323.GE1648741@nvidia.com>
References: <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAjci3rddHt_R_x3@arm.com>
X-ClientProxiedBy: BN9PR03CA0503.namprd03.prod.outlook.com
 (2603:10b6:408:130::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: 05154efc-b049-40d9-334e-08dd82673b6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L5FrntzLZUuAieEo5bttQ+z+wfaDj5iK754u1bCU7cf9hWc/cORuMauD2A4m?=
 =?us-ascii?Q?wOOMh+CMYpWaO3UGNCRJXFDjcqoYXYD7CTCqzxuBSIWQ3KTlJj7/0gf/JPWs?=
 =?us-ascii?Q?7fwHwz628FWRAR7IaAqnqDHIwdW0k54T6zGwXDrV/vHx1zoY/BtK4nqibCOC?=
 =?us-ascii?Q?1a9smPm2NIrlKTHqCSG8q9n8rFF81544/Of6MR6WrbwNl4Zh/k1dmi1Qmc2d?=
 =?us-ascii?Q?jfEYDtMJ4+RBJXwpfSHsfkSzQKW8qyoX/2m+qV/Ko/cAZidOuJyszE41MDBW?=
 =?us-ascii?Q?FYfzaqYOridMlSUs9OWgwy9rRSyHUkiqleyid3da8pSMNMNTbevl7qaM5wUk?=
 =?us-ascii?Q?dZ5UYlvP3+NQt7WHdE8kiGdQGnQRZpGcqMLMue06rILkfuhH7PrMMp8bRfsO?=
 =?us-ascii?Q?9TP3rWftif52pRn2Al1yNziPb+zSeW7P1NT6vaTuykLOFVbNW6scWXwuCrpl?=
 =?us-ascii?Q?86oEIV8kYl1VMaQf53BKXmjyGpaJGCrFEiH5weg3kZHD5cbdKt7KKX53WGKd?=
 =?us-ascii?Q?KTeV4Xosh5pq4/vkRJfrlCg9GDt/zsY/MU8ch4LL+NtfnlNlMwsjub1SNFMR?=
 =?us-ascii?Q?KeyiAk7nyBtR1KE/dC3vRr5R19uPAItqpTF7gj6wFCnAAWHjKjZzVNjrXvaG?=
 =?us-ascii?Q?jOuUzaLs8+V99DzjIvhqc3OZbH3giCb7t5b2o/VuWr698XpUPgsSgIsVKtgO?=
 =?us-ascii?Q?1FQlo+MPyqkwPNcwFVV4FYXGU/iRA+kv7/doWEuFpI0nAc5z+ytkcPQ/DKN/?=
 =?us-ascii?Q?P9GHIQtesicgksVg2PgWQ29u3nL3hagnPeKjtcaNbGF6pFtwsRQtV6ibP7AL?=
 =?us-ascii?Q?rYnPs5CQzlnSaQtNNfZglknQfUgXUnstrJC4nXeNei/dDOPGnmRzaxBKV+g7?=
 =?us-ascii?Q?ozfK3Yrq3gV0q+U01+RGicKkiQYrMRW6IGGGIWFLx5nlaKUgpYPXDS4Fmyjv?=
 =?us-ascii?Q?DkUpCBSwB2feX2gkNN1y6DaOXi3Pvmt4EbTEByJinLUD0Gs5DuWxeZ0cQ16c?=
 =?us-ascii?Q?AihqRMd1BS3KdGuQhlS8Oni/F/207ohdqpKGrVDfI4VDpEZtqeKX2Xb4+GMS?=
 =?us-ascii?Q?/QZkJqt6O8cGn30xJp/XScOeyjMMM6dBPdlBCp/PGZYfOIQTQrg3SKo1Wkbp?=
 =?us-ascii?Q?VTLl8H58s0UwJIp6Cvi/C4l4w5trm6P+e2L7cmDa5veS9DUhavXG27JfaWj9?=
 =?us-ascii?Q?s5YsjqhhE25jAF0h5AWm6O8LgqhCTbAOokVp5nsLJLqEqOfdw4C9YftxF+Zg?=
 =?us-ascii?Q?tV+L71sy39mQ9TGSq7gYiPAEPP7A/T6yzqud3xiU5iqOqgjDLX5bHaDvqFWy?=
 =?us-ascii?Q?Wx+fB16Nty90JSQ9OeSmu7ULHYG/FaWEXHDK8YTMCNeXC4zfaWocQDcAbp7E?=
 =?us-ascii?Q?rqaCVvJeSiJ9GMSG2roUTCNkl1Y+JMc6qFtMLZQwe3oPjHSB4UNGm/JFTA6Y?=
 =?us-ascii?Q?6BJ0R90RvYg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/hc+9vRRyTKDi4H52oz7dT2DgRqjQLpSN2Q0D32U0bAbt8C4fD2sUJnkvPhY?=
 =?us-ascii?Q?uP7ltuol4f3Le5YgV4zI4TDc3LN25TQ3w3Cxgot8HYvcSQmAq9uhjgxJQvQ5?=
 =?us-ascii?Q?0OmfeDv3zGB7csPXDLUZIhWV1bfB53HfBwayfPqHHdI0UrjvdmG5RV5OcczO?=
 =?us-ascii?Q?TcDtVJnUwfCfxpCkiUhFZljzQkmoItES87GbTWalX3hO95r26bJffgKyXWLz?=
 =?us-ascii?Q?47i1OxmQ/zuVuA7vso+DYajbVbMiBFVgh5NnxmVFxL7YY9oZJT+8Se7Tit5O?=
 =?us-ascii?Q?7zfW+5mhJrOKHwLKsSRWio0nSmaV6PZkCoAMTxw3nxr8Pcs5wQ6XKeYz8FCY?=
 =?us-ascii?Q?nAS7wVmZsAGZ3gzP+htDViih0+vvQ0VjAoK5YxVUqP1O1OgfcviatthS4lT/?=
 =?us-ascii?Q?MXWokiKE8OR9wb4M2UKj5+EHTTCa0gWP5wRcsnPr6FJLiytl6LancErNgnOQ?=
 =?us-ascii?Q?NQpXbCMDiXiZQmDkfNS9PPRqK2/lodSoBCQkU8YknTIZAQ/tT7gRnAGYeDhH?=
 =?us-ascii?Q?zcpYkzV0L5UimRlhqqkqJHwJoFYtMuakwnaATbxm65AJZeRXFLEsmMxLvt3D?=
 =?us-ascii?Q?84x2VQsi9lpXhr4LwWJ5sFPrL1ok9QUx1HQMzdQENcbW8MzzlKKmifd6UdEt?=
 =?us-ascii?Q?cUlkQ1G0NOZANV8jJgaHAgX6J3ANAuSONmM2E4iy5Jd1rrMpk70IlLSpqz+w?=
 =?us-ascii?Q?nLWA9OvJSyMoWM8p8YK8DfO7kKpsXEbVLVsPoiWGzto0rrAKu1pgud87KUNO?=
 =?us-ascii?Q?ZQLDKKQxs+tLJUP7K8ZcZFzevD7RIl//aP4U304/dUTr3q71v5Ds2uS4LoEg?=
 =?us-ascii?Q?/iVYZRzw7M8RVxS7k+I9iAseewbOCdmIlC4L7J6qHAswbmOAggpVeXzywA1v?=
 =?us-ascii?Q?4nTYx1Y0jplUiu6fU8i/0VsNLvQEhxmGzq9tVkI5Ck+BfZk7ZZndhse+1IqN?=
 =?us-ascii?Q?UjTWC9VPpMJmfyuZWGsCjXFqhZ9d4y2XmFrdqFuoAZGTaTg9lueCjjOK6EwR?=
 =?us-ascii?Q?189E8PBdYkR8f7JLYoEmzzblGv8DHHOE1dsDnwQV5RADikf0H9cNviM8+mex?=
 =?us-ascii?Q?U/d3CU3tP6kwk80BgGgz1oDNKBELH209SLr2yOCB6ZKJaToFInMO5LiXXQW8?=
 =?us-ascii?Q?mT2KNBkjvicVblo7dAWqkKRuzEtDzaogzy1bqH3AqG8Gsyjn5VfdvZ5A/v93?=
 =?us-ascii?Q?Pr8yhkG58idOdksPEKlt8cObWpzVWTbr41RjMfFOfuEBxeHxzNQvrGadzfVj?=
 =?us-ascii?Q?mi5ENbRR/Wpoo/pVLZH8XpnMDWktktPFb9Vnt0vdSvaYdPOj4OuYBDjOSXgf?=
 =?us-ascii?Q?WOTm98AQ5LcBVXKlnKWFIDNXksfLQEJExKXoG3hViNFy1WeM0OtV1vy0ayHg?=
 =?us-ascii?Q?gPOIaOWvKWv5JVBGTopzpvphN9Ze3Cx2Y+wPKwjgMm/LUYUUu0vn/Z5Ehgn1?=
 =?us-ascii?Q?Hh99rwo7GCIINbB2cRwAZCu5j8g0DHdj3zSBasPyvn53eejN+X6arfIHmx90?=
 =?us-ascii?Q?rZ2NxsPLkVL2DDdSgQIn0V2xGB9MVTjvBohar9eSu4uIFIGbHfdDMT81zuNX?=
 =?us-ascii?Q?ftjF+SI5No9ZbeX1YRXeAE1c0/9NCcnd8WsUV1A9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05154efc-b049-40d9-334e-08dd82673b6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:03:24.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Jud8Pw7mCdH+Z4cgak4ff2BNYYVQlDGF23kkRJaIdfAXYIcMv+8qhDyJFLKkZph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9037

On Wed, Apr 23, 2025 at 01:26:51PM +0100, Catalin Marinas wrote:

> Ah, good point. So we want a strict cacheable mapping even if there is
> no user/VMM mapping alias. Is it because KVM cannot do cache maintenance
> on the PFNMAP or because the device does not support other memory types?
> Both valid reasons though.

Lack of cache maintenance is the main problem for the vfio-grace device

> In this case KVM still needs to know the properties of the device. Not
> sure how it could best do this without a vma.

Well, the idea I hope to succeed with would annotate this kind of
information inside the page list that would be exchanged through the
FD.

There is an monstrous thread here about this topic:

https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/

I can't find it in the huge thread but I did explain some thoughts on
how it could work

Jason 
