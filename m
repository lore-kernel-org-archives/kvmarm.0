Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B2A20C48C
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 12:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742302680; cv=fail; b=kCd7acu0mARcLEzfzeAzrhRe0vPGcVDW2ZQOHmX4G7ygsWimrqhdRzg7GZy4FKFt4wAx0pWEN2rC4qlk7WgFKhSAJNPAK5z8oUTCTiID8oPaKzrHf5NnMvMb3tPLpFUKoJZeoxOwMClWC81Vb/tnrAtLtVx/Hl3AV6IOcu1G95k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742302680; c=relaxed/simple;
	bh=fPeFfOJEBvT0+aP5cqFivDvGrqG6Btr6+ZqIuCpRaPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XFWYgmPT2OpN/4DVJupnFdobL9olkuGAfD2w/PMIJnbJBiZn6LtuC4zRy40PnDtSd3xVC0lclVSchMjL5l0ikgD+MWFj/TGnyEORSDyr0IhrUrBLFZlthFx5xlOfrIRjOdpNZo2TvcZ7ttuSjXPTz1s23fqCa5VudJmKlkpwumA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eVckRc7I; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eVckRc7I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QHMzymI0vCjWB7vxOShainc2cKvp0Zqci7FvZm8wPG3Qpmu1vFhfrnU6IKr1QPBbq/5sSDT3C5zF6wfhfrBQ4JPXOgIgWambKFP/GxBR/Niu2m0zsDMsTgZEZkYUjPVzkvyMG4DqzXzSZlA9yCDkT/9hMR8PN0HwP+JmAJ/BOLIvzzme44Zm0KNxDu254jthco1L1li2pIrNNBowqb/Tz2Fm5e7btFyY8LhD+myKrgmKaNC/MpnJ9+mtGxJ43HOf+c4S0dHhUIAhlYgdPmPY5wwy/Lqhh3QaXoemGDA/cu+AgJ2KZB3H3WbEz1JVX4ygVSGiKNif2DvF2igjtumWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPeFfOJEBvT0+aP5cqFivDvGrqG6Btr6+ZqIuCpRaPc=;
 b=aNIwX3k4Jaq/0/e1Rd26yRLtJ9Dxk8x5xWOqELTe/WKWZ8jyayWjfYcDXnRABTej/lkwNK/kDGgUFC7CSviCR8Kt6iE1UBlEZSydil48tZgSHrnRnBZD81rlMPAnXHPPDZQ+kKVnRf5JYVhs87otSdHkqsS4r25k8a7eaWBc1LvSBFKVQpsv91+8sEpChZDyXtyHigxxGKv2+Kf+f73z2v5i1PBk2tdHHcoBn5u/1gTG9OyEoVhOGu9k/jlH5Onz23+z9qbZahmYLhS7M+ID4ys0iNOjKLkLasKNtWlmt1LGsbmZTrjXILzu9GMW/Y5fFxsC4DCi2W9PjPawBKTBBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPeFfOJEBvT0+aP5cqFivDvGrqG6Btr6+ZqIuCpRaPc=;
 b=eVckRc7IHngqE9QKqM/oCpwXN8gBKbulSuLbbqs0WGpwqeHs8gRJLWov8gVjrR8JZKMLxQN2BgRMnnJLaExVqJHtzRRr9YDXkyCVYKps8y47P8PGoaIp2VKULb1UHAYGtspL411rAdVaJM6loJYi2pJC9t0wtqi2e8pXhWSwZAfLNQuBYyoI0wgvjGK4YSXqX1AM2Kqw5oPpPoXSORnuKyDW0NHCFQJ2ADEAzd78Z+/reakupY93WMijUKss0Z/+o7aAUvSSKZ1jMlzDhaNTv47uXhG9tBM1pO791NQLSjA2RmO1ScXdEL69G+1qkUQ/jcFh/tbPQY/2O6iVMWoG/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 12:57:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Tue, 18 Mar 2025
 12:57:52 +0000
Date: Tue, 18 Mar 2025 09:57:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Cc: ankita@nvidia.com, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
	dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250318125751.GQ9311@nvidia.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
 <20250310103008.3471-2-ankita@nvidia.com>
 <861pv5p0c3.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pv5p0c3.wl-maz@kernel.org>
X-ClientProxiedBy: MN0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:52c::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7a0d2f-ce41-4352-df1c-08dd661c7e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UYxYKzSkeswNS8Lgpqba91wMXzbWL0YZoOJZII3MX2Fnx5DcSHiCXmyG30Bq?=
 =?us-ascii?Q?vfqZQ/WK7eMe5ZviBjCa7jLbw6B//XEEBkIbSrFsHEr6LXRJV83u4dvCY28W?=
 =?us-ascii?Q?IGqa8Zy7/cbbj5LeBeJTWuv+RW0svVGlgKqxLtp31vvpyjWGXhfzaeyZffJc?=
 =?us-ascii?Q?D4vX8MqXSpqUy1m2AQ2BtKl2wMp4POfJ3gjEYp8zadfExBI2mcWz7XRTVADE?=
 =?us-ascii?Q?Oi8cT+B6jufiJQawpoTn+4rov2BIXgjf09cL2rfWwqo/ZDbDtftODxvO0XcQ?=
 =?us-ascii?Q?ls/jyGaxpDGpKsT3XRoLud/8P4aCtmhSM5krJDg8i0f/Bid1MjyzUJF24Bnx?=
 =?us-ascii?Q?oxSPpjskFxf47+KBKjBHNCL2/Fc6vX/P/P4pH7bhj45QZBO+Lyv8JFzlzvDZ?=
 =?us-ascii?Q?oTxH5ERg4uShQj6aGAzvxqzvklAymS1ELxEXhtDJlxw8oD0vTC5KAbQ36S8+?=
 =?us-ascii?Q?68bATwMTr4rPW1jQNA+mbMgv017PEP95WDix+M9NZVu8m+rRLI5rCu+EDamJ?=
 =?us-ascii?Q?QC7Rfd34ZYf0eKwgbPJdpWfrkpw4CiWz3O8L+iDqMONsNy2yNB6ZW8ybA0e6?=
 =?us-ascii?Q?vlmclo61TRso3TJfp6imxmR2R4ese+sOecKdIfZ1IGacP+1V6P8hQmG2wScd?=
 =?us-ascii?Q?smf10XejrAIbKZzN29cOm46bydXsHIhGMHtOsKMuElwjuMXUe3SCj8kRMrCA?=
 =?us-ascii?Q?XdN7gTlFwDhXHHpDnzYdLu2mrm70fj4uxFV8GHWcBqgbqeZEjAoCyva4VPQR?=
 =?us-ascii?Q?OSp77bK+oYGn4S+sYj3n3HyEkE62xwAiInKbdDpEYSPYl4JPrBKo3F1sE3Wp?=
 =?us-ascii?Q?8P0qi8Xs2T1PkV43/1LDmXQkuyCWqiMSkXeC+omdtvBBghdqeUqLaBO+VASX?=
 =?us-ascii?Q?l6no2yRyJpIlj8zkmRnr/HMal6gtzFyKvFI7fcVfN+7vXvG1rtdk/WVqn97R?=
 =?us-ascii?Q?A2l4DjuVOIVWvAyHghHgbQo6wr4CItJJvSJga4bBxAIBSLLc0DUhHrPqaOy/?=
 =?us-ascii?Q?nnoHFX5G2BCyJx8cYGUXbhJVzSHSI1TaEKGj9XBnl2W+eL6JFUzPUXvjRzq+?=
 =?us-ascii?Q?sjPvtIjN9b7ahiQFDZs59iUtdUYnbW07jMMWe2lwhjl4O6LKNstfQzEpE2LE?=
 =?us-ascii?Q?fCw6uCaKrBYZd79eHFY9zdQay8NG1h9hYncmSUhZdI1bUiykoIPeh36h4X1K?=
 =?us-ascii?Q?Ou1qv676CGOI99imaxwF1iu66j97kpCZR1FP95IV8kcS/d5Y/W68MkBEiBae?=
 =?us-ascii?Q?vZnRor8fKwMPybJFedXVLCSuKoRXgz8GpS/+QkYrIkxAuhDaLTlJ3l+LfMZF?=
 =?us-ascii?Q?qOoMPen6vA3J+Du574ffB8gVHchO6GVJffPm8DQV0JKYE3zz/Pv56a7QLllu?=
 =?us-ascii?Q?qEhJSYoOOnB0ikppnnzLanb7OuO/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qu+HECatsAbk/Jm6UT19pwuY5FIeDqCn6SDXPZm4wYnWkKOe5tTHWi0SPrNm?=
 =?us-ascii?Q?03yCFEvQyTtd2OLjFDJIO/HerPfUfs0dPuIX/gbnADrjCzE+c/cIBBh2Y4PF?=
 =?us-ascii?Q?Di6MUh8ATzhAZmec0/Yl0bs9p0Zbu+3l8I+RISd2LbZxmorcQMlGvTnEzwvO?=
 =?us-ascii?Q?ZDNSo9sZYy4dupJIicPy5xNC7I9Km9t9tDqpyrfpk0eyH4ldWhd5C6aV6DDi?=
 =?us-ascii?Q?+W5k/fs6SxnGRCelB51MpeuNquoVOGqBi/Xu9az4kcR0nHVWHH2YzNyqVsZ5?=
 =?us-ascii?Q?1ofhzGK+/q5YIKf1CQ/IYFkOy+2bwye3Sy5ahipdIK+d0R/dEe1gZxE66grN?=
 =?us-ascii?Q?7aR77zMe95BJQ6sGdUUOAjRtGsTuePXOnJ0OU5dssml/WZK5CJAIWiET388w?=
 =?us-ascii?Q?76wn9P7mNzVbyz6oO70FeldNLZ5XqJf1anZ9CqmjejOu5mKgBPgpebL2PPS+?=
 =?us-ascii?Q?VFTafYDIDTOtwHXs1wB1IULld9sSYdj4knSdlGK3hkxsi+e3e92AT/gchq5q?=
 =?us-ascii?Q?eiqYwMparrhI5RqOp2xbmsMzQS9q72+jdY/U7WDFbqnGsvYpuGbtVXprAVlP?=
 =?us-ascii?Q?4nIB67wpCx/NPcCVO0DCoWDFWwaK+7hKNRixUt81M0v9Lh3lzWiuyo73/EDw?=
 =?us-ascii?Q?+aFXyuhW2Vp+EP9OiM0CR2dDRHrufpbLRzmFxGvkXA8SrsyD9XT/uBxTDb2U?=
 =?us-ascii?Q?PZ8vQFIoXHE6+HEfSRc71AO6y7ZE7h5oNm2qOG/l4BISr+eRWk+MtNnQZ095?=
 =?us-ascii?Q?3BPp8FlfkIJb4lsnuzdhsh0J1atHgd8MIL/FVYtBs+ju0TQcU5uYPSGwD6QB?=
 =?us-ascii?Q?DTgkYWr+OVDOnUOtcZaMc70+bpOJolmD+oKlJx82jd8Pe9HvboAkTkST36Q2?=
 =?us-ascii?Q?qXDJ1W0p9w25mzO4XLfJ64P+nVSrVSZ8vUyIb5hj9/Eqgca9d+5fQ1SR+PRH?=
 =?us-ascii?Q?icPlALmVNs5FwjGHmZNGmAiXbTHJckcJaV+zXqEa8cew5MuYmtoF71aRZDYr?=
 =?us-ascii?Q?MQl+0BeuIgJv4XYMxLfaH4naQS++6us+fcXl3QtmChL9PoBBleIomCMifJs0?=
 =?us-ascii?Q?r3iuQS04st5OtnMpUNFYikct5js5v6cw7SWlNE9MZm6icYN2AUFpH5RYQ10f?=
 =?us-ascii?Q?C76orY1nwoS/f3vIyhuOEU7JDqYvUw9rS5XsaHwJMDo1J0oxEfCDefIxXh8V?=
 =?us-ascii?Q?9gGxkyvC1aq2+o2GHbBftb3oEhxY50feMk0dZPvjbbEEzae09lLrJ2Zzz4Se?=
 =?us-ascii?Q?0ogPynY5f4bl67l6jdQhOYBUPkYZGOHyr6Qreo2V5vhOtGoIyulzzNhkjvo1?=
 =?us-ascii?Q?qn8/9g3jDgsYtDkuBKuHRgUEq2kBmCi0W8ND43n7jjDdNNKYJAsWhKQ5rnho?=
 =?us-ascii?Q?ztVwDGLT9j63/JdhxRCj0Lie6wnfkcR26VDuFFlHzj5t9qX7qV4nu8LHNP2K?=
 =?us-ascii?Q?2THfvEWcDICIJejgoeL0B9kPiNgofsOOkOHFGUZLN7w4eagnx7o9nhwzFuwj?=
 =?us-ascii?Q?STnbD3X5lLXplgBRkrSGJSBlaiYskQU5PA9IDLhZy+hSFsTjo+soqXQae8jD?=
 =?us-ascii?Q?qs6CsQ6p3a13++3qcv8iHqAqNG5JqA2IFE0Pw4h+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7a0d2f-ce41-4352-df1c-08dd661c7e2c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 12:57:52.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fi5S6VW4HN1C0C2pBLymODhMsIYaS7TXL74jt9hX1uFEsRTaFsi3qBHalviI8HEh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6075

On Mon, Mar 10, 2025 at 11:54:52AM +0000, Marc Zyngier wrote:

> Which brings me to the next point: FWB is not discoverable from
> userspace. How do you expect a VMM to know what it can or cannot do?

If you add a check at memslot creation time then simply fail the
memslot.

There is nothing the VMM can do except completely fail. There is no
alternative path here where a cachable VMA can be safely made
non-cachable for the guest?

Jason
