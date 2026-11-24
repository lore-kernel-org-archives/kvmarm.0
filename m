Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554744;
	b=bvEYO88Aym+OtIU/Y0wrlDL1ncm2HV/5P7gyyKxuOca2L+7F2P245bYvR1ZyBwWMVZLO
	 /NsSPgdR1KAkXArUJWDBYhyU/3tW13XWXuewQuabZB7US6jEye3fczGWuz7Ez5vhqMrua
	 abbAsq5W/y0mFzSHkiKb5nnAJQL7w92xUGGiwTSrdc+vSNYPQjfDYs0fdgERa9kzRVowq
	 NsB9hdP2nxpNH36jruFEffaZppGJ/PKe/oYHl6uVy57E12KpFZ96YSzCYGkXG7j9oAkrz
	 Snno/QXK4tyBDDCY7z8w9hE5KM7qtkO35QhOBIvmvsKCSwhieCuDTsjBB2xeXf6LnTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554744;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=UXPZzRd65PuUqkEnfaUg4mJbz5uQiXFHRvy/e7CdfDM=;
	b=tIHS8Z5W5guXB0r8Lc1NluQi2goQlBDo223a0i0E0yHw06hyorBBhKA5+TfQxk/xnAbl
	 WwrOGHabFHZ9Rp8OQs0KcLQ6r46k8Ime/kLDiBkGRQ7171JEf/pwAV1xk05hCqnwLQU54
	 699vZPqbUuO1+IH+0MM7C733h1fp1VllmYPpUorN/xXUTSTo5zhQPHr1jLvpJVKWv9VGr
	 aTt4gkrd5Neu/vc8JzqMmt8FedWLPcE9l8aU0OEMzuMYS+u22Ghviwov4Ut+6lZCARi+Z
	 5kbhUORYNTey8NN5JseZ6G8L1ufYMBZQXdPXJFJ5Y8XO/Cn1+dul84+lFkB6W/SJWQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dh1FqUWd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.16
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A0606A329
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D27A0606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dh1FqUWd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdjtER6TREl1pXNdAC3qcy3ERxYJeYu/na9g5rgXaM5k90UNglWPstTUl+qmMkl0oqnCG6OU6zqe6gE7ZKrYPunLEiUWtT8fuqo6B+VJj6lVXjereYbt+O8+WyMDtuHaOzkGBrAexF8q4oNw2OMiz2QkFXAZ102O6XNbOhJTE9JLDznaE/2SLyP57vu38F3Bt1oRuAM41d0F/5G285mJ0mNOoHFO4tPTt6WNvzCyab9Tw3NeNHeH9yDsE5dtCRRoYLaAkVFkBn3U0b9NPnQmBx2M0lHa8jQVBjNTvQCUUiIfUSEliUFP4l39RhsMQASM7OItq0niMffl6rNVWE13pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXPZzRd65PuUqkEnfaUg4mJbz5uQiXFHRvy/e7CdfDM=;
 b=V1Z0w5Lw5xTP0+9vYTEusi5SIkmFkLPO59du5fdjA460FgkkLG3dySmCOTP8S2iahyCL0qVMt/yVPSoTx5UOfln/zShPapMLA2X9LOdzQGMwpwslrZmes4WNvoWX646/QZVRGbRxm8ZY3e/5ovSXp01KUiF+JGtQCINZiVIyAH+2BGoQc1rr3MXbXABZ4m+3lbdxx0dLqVs+rVUKs5fjJz5W6+lJLiZmoCjHnplD1B7RhVTCMpJEp1h0VgMbZs3XzGuezZA8jpB9shETjW7G1keaLV0/emcymGU0GRl6xfsb5eVKp2/tKh5T/Qghv+pKM5MufGYZ37GHWjRSbWrr2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXPZzRd65PuUqkEnfaUg4mJbz5uQiXFHRvy/e7CdfDM=;
 b=dh1FqUWd6kRVYhLU7YhrLMwHhRVu153sKRBUYET6dpyZJM2B3LGtdZMaQ8iLSUQ2KQYCe5clZBOMQuMNr+rVi675sB4f7sjyr77P9iqyUxnE0dpHkZ2QHQHsaf+vIW7yxIkSuoXpk6WegMxC4NVCcqbUzJ7RUWthRmHYPA5ZXRuFY1h1ZmAkqvAhRinfFVeXGSVkpkMHnilbbFEfdGVFK/CRPZxSo2sQa60lcHWWqKSgZYVLzshcPGuxOQ5DtH39dufmn/fFMMPjt/HdEBXwnlY014/mHhNGcYfZLCGmpoOXEyOTUOilIAM7ZET5ud94IyFKr78gsC+oF0WVhcPPUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by IA4PR12MB015138.namprd12.prod.outlook.com (2603:10b6:207:12a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 21:12:20 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 21:12:20 +0000
From: Nathan Chen <nathanc@nvidia.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Tom Matthias <tmatthias@nvidia.com>,
	Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Julian Miller <julianmiller@nvidia.com>
Subject: [RFC PATCH 0/6] KVM: arm64: nv: Grow the shadow S2 MMU pool on demand
Date: Tue, 24 Nov 2026 13:12:12 -0800
Message-ID: <20261124211218.2751086-1-nathanc@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:303:16d::14) To DM4PR12MB5390.namprd12.prod.outlook.com
 (2603:10b6:5:389::15)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:EE_|IA4PR12MB015138:EE_
X-MS-Office365-Filtering-Correlation-Id: 71479670-d0fb-4a96-16d1-08df4a6fa022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|10067099003|261022105027099003|11063799006|5023799004|56012099006|261021121427099003|261022075727099003|261021123027099003|261026121527099003|261028144727099003|261026140227099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bvCA3/x3qy0L8SsCgt0QDH6YFYAZKwkBXA8j68gkdmUE8b9xqgqP2b4HpBxq271n4/nGBWePsigH2HXqeaCs/1DlsF1Pt8DTDUEqyHuDyRqFuntbFqupfk4kfsjLesxLvmykT5DnBTqPn6GHjecjQlnP1ctjzTwxLPXmfimrR6tzwd/rIjMo7k+0O68KT460zTXKgncT4uVBjdOIYoGHKQw+wp65+JyBxAKg6GIkA1Fmtm2PZsHDi+Ls/BUjZsYgjBqDKa55dy0o/Y8taSRpcLUOCH3tEimCoVlVHsS5O3TJKk6ScctYFU5A8kEczuYr8gA9tkZK3+R+hV5gdmMIve/7sLoMmKDuU/CXcLHMm77fXx0PwUk4rPAMsVHtQ+4g/2HTBAXXxYkKhQEPoYuN5yTPOj8Sfyqeo0RaXifU6xehEUoIOiyWseXvq/dmmNlx6nGr3cxxzUiN4kUjGogYk/wThxlTow2YKnfispyFtysUUqnjMtSo7er8HXFcU9oKFgDk6ImbgX0U4URDFZgaldssX/WQWWrBZ0f1m3QoZxO1x+sibim4DB3arOfO66tKs0lM/i7ZtxFh77MIUFWhQKTrl4OQT5CNOsSsTyo7kOvdWUmL0DQEMVALblsdeC2rUPoT2Ar+GTkK0CQFtQ3YAGpdJRnDrqlKaaD1YoL/yWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(10067099003)(261022105027099003)(11063799006)(5023799004)(56012099006)(261021121427099003)(261022075727099003)(261021123027099003)(261026121527099003)(261028144727099003)(261026140227099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r/S/aYxTJXskIe9cHupK2I9UVU1mt96ouRZkR2FVL8B4d+IvdiXIJN5eOlPM?=
 =?us-ascii?Q?rNySz4s8+F96pAEC4fQ7U65eF6DVZAqsrr57pN98+w/4xA/DFmKbT66Dear+?=
 =?us-ascii?Q?N8amn+KQgG16hoZS3n3zE4lQQVVF33+zrBwNWuSQEPjc3Ivtu5OICMr9iWwj?=
 =?us-ascii?Q?VH6DeYTJWzrwKIKDwWSr32rQo6PYlsHBjYFT2iefej0p1IL5IRNvg2g1fLwD?=
 =?us-ascii?Q?QfMQLA8stZH4wFJkF03IIWCDtsivqg046AxVcYuWFsw1tJxOq8ZfbLBSFk6E?=
 =?us-ascii?Q?TrUWALKNEq+Ac8YgwippePJ64O3dzH/bzRa8VZr5yF88ynH+Fgn+USyZQRzG?=
 =?us-ascii?Q?j1+6jWLlCtMxrYj0uUCUqlE05p8JWmvgKdFyLXzpJG6Uf3tXOTBX3+mggfLa?=
 =?us-ascii?Q?wuKZE21jOKjFnsTw/MRqMlQyc/EnqIdqa9L2Jpux+EctlYfLvPsCGzKcpjX/?=
 =?us-ascii?Q?bgPMTl2XvCn7ktrQJeRrEBcHSD9rFbOjJO477XtrUHPHRshrs4RTdECIb+/z?=
 =?us-ascii?Q?OQDliKp651PWKgzycEP/V08SMfMgbGFA4olPAyajjTT216p7bWIV65KEjCjb?=
 =?us-ascii?Q?y5nZaWCKdZmHhy6yYh9V41KDqTU0k7yhksbtrctoBesJXjvPv8m2g0xUDhPG?=
 =?us-ascii?Q?RwzCgjUvDajDBJ2TkZsrGNcc/BRUu7rNmr+htHzj6xygmmyXCSfqaxGN3VEk?=
 =?us-ascii?Q?bcs7SWeUaFISaAB0uQnifj67T0iGEoDOSfBMmX89sfpXp5OjM44CfOLw+89t?=
 =?us-ascii?Q?/FOju3PgAaQQX+sp1Fy3tuZquerttFqnB2PjTC4WV9PyX2REwzqOykj76qYi?=
 =?us-ascii?Q?2c7p2QDBmqWuctluPPsfufIUvrYuUq90AoO4FXS7NSzTWoDIQ9O0OwOLzfOl?=
 =?us-ascii?Q?gyvxo6qEddZKuO9H3kwBkBMkqHRNrDwN8Nr8g1i2MNm4EN58MMAWpHryAJT0?=
 =?us-ascii?Q?OLYDO/zk0BlB/aA+/22+4/8Adt5PYWDSyuDYxiMTVGWM6UKtPq20fMH3jkf3?=
 =?us-ascii?Q?4DDGrX+BmHWU/GRUijpaYpuBAIupdWLX9qvcoln9wrAb1T+mLvlcYiKaVUOk?=
 =?us-ascii?Q?GPezvowSWkoQU9Ncd9WLZUACcSsDm1BxhyibtMP0DlEXrclV+q1yCUkmh/s4?=
 =?us-ascii?Q?V61IKexKKG+uMuxk3CR8OfUObeseZBMWFll0XyJeaLGA8bt1C0+fKFNUPeEj?=
 =?us-ascii?Q?H+ibLlzsCbXZmu/z15ypwT6bRzK1MBf2WHfxFmctY59gQgWioCNuvJH+Pdbb?=
 =?us-ascii?Q?09uBpDuCsfdDQyffBg5sG7+96K+c1M7IeT/Pw4LJ8hmLMnf7flq2GWtUWNqk?=
 =?us-ascii?Q?B2KoSovPDitMEUwBxx3GasqKgu1aI1/BtZQNaBZb9CAJFFLRUQewUpGVyJPX?=
 =?us-ascii?Q?U1NMXOJLI5e3DOXtOKi/MF0RLuZ/rCG7tUNgVvH+eQdhnyV9o+V+tPvsqeTZ?=
 =?us-ascii?Q?ZV29420t2HvKxzZO3g+SxQ+tS6d4XydtouQlaxHf6UoqXrMdDqHwCNAfxswo?=
 =?us-ascii?Q?ts/4syswCri32bTAUGnlBj4Xr0r0rqFxS0ZSk5sBTcd6KAl3eEW9W65mvzIT?=
 =?us-ascii?Q?9nJTga8McyOBdOay3HP/DgzpXy3SSM8pqZK6O+L+RbNb6hCEujWk5AiLuiD/?=
 =?us-ascii?Q?uVzJdktA/TPRdbnNubwil5HOIUS8ahPwP3vZcxRRhKlBljNQ9sUzlS/60Csk?=
 =?us-ascii?Q?nVwfRU3qb/TR5z3t0J8vONCDJksc8uJnd99PXuLFG1JFu8NhBRpe4e9I3M7x?=
 =?us-ascii?Q?BgyMMhV18A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71479670-d0fb-4a96-16d1-08df4a6fa022
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:12:20.0119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+HwaMA3KBI5RPOAVkTp6L74BnHMT9MXnoQFp2jcjlk0ND7wIsXaldfaa8q4N5OxqCIXrvPargv0aNJnfl/YSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB015138

A nested-capable VM gets 2 shadow stage-2 MMUs per vcpu. Once the guest
hypervisor runs more nested VMs than that, nearly every nested context
switch recycles a live MMU and spikes host CPU usage.

This series lets KVM grow the shadow MMU pool on demand when the pool
is too small, up to a host-wide VMID budget. It also parks grown MMUs
on a guest TLBI ALLE1 and when a guest range invalidation leaves them
empty, in order to return unused capacity.

Testing on a 16-bit VMID, 4K pages host with 64-vCPU L1 and idle
2-vCPU Firecracker L2s:

- Ramping to 300 L2s grew the pool 128 -> 192 -> 256 -> 320, with no
  host CPU usage spike observed and no VMID TLB flushes.

- Dropping to 20 L2s and forcing an ALLE1 (an L1 VMID rollover from
  churning ~66K VMs) parked all grown MMUs and returned the budget.
  Ramping back to 300 reactivated them without allocating, with no
  host CPU usage spike observed.

- VM teardown returned the budget, with no warnings in dmesg.

Testing with 14 L2s on a 4-vCPU L1 with 6 L2 guests powered off or
rebooted:

- Firecracker unmaps guest memory before exiting, and L1 issues a TLBI
  RIPAS2E1IS over all of the L2's memory, leaving its shadow MMU empty.
  Patch 6 parked 5 of the 6 MMUs, and the remaining L2 had an MMU from
  the initial pool which should never be parked. This is reclaim on
  range invalidation, not on L2 shutdown, as a range invalidation
  doesn't necessarily mean the nested VM is gone.

Known limitations:

- ALLE1 parking can't tell live idle nested VMs from dead ones. After
  an ALLE1, the remaining L2s found their MMUs parked, and each of
  their vcpus recycled an initial MMU that was empty but still valid,
  doing a whole-IPA unmap. Serialised on mmu_lock, these made L1 spike
  host CPU usage for a brief period. Skipping the unmap of an
  already empty victim would avoid this, but changes the recycle path
  and is left out of this RFC.

- On SIGTERM or SIGKILL, L1 issues no TLBI naming the L2's VMID, while
  it runs or as it is torn down. The leftover MMUs are then only parked
  on an ALLE1, which a Linux guest hypervisor only issues on its own
  VMID rollover.

For SIGTERM and SIGKILL, an alternative I prototyped is a periodic scan
that parks grown MMUs no vcpu used since the previous scan. With a 10s
period, it returned a dead nested VM's budget without taking
MMUs from live idle ones.
However, the scan has to unmap what it parks: after dropping from 300 to
20 L2s, MMU mapping took some time and could delay the vcpus of a busy
L1.

Is parking on ALLE1 and range invalidation good enough to start with,
or would you prefer a periodic scan or another signal for nested VMs
whose VMM is killed?

This series was developed with AI assistance (Anthropic Claude, through
Cursor). It was used for design trade-offs, testing, and adversarial
review of feedback received. I ran the tests on hardware, have reviewed
every change, and take full DCO responsibility for the series.

A branch can be found here with the series applied: 
https://github.com/NathanChenNVIDIA/linux/tree/rfc_alle1_nested_s2_mmu_pool_dynamic_budgeted_kvmarmnext

Nathan Chen (6):
  KVM: arm64: nv: Allocate shadow S2 MMUs in blocks
  KVM: arm64: nv: Pick the shadow S2 MMU to recycle with a clock
  KVM: arm64: Add kvm_arm_vmid_nr_usable()
  KVM: arm64: nv: Grow the shadow S2 MMU pool on demand
  KVM: arm64: nv: Park grown MMUs on ALLE1 and reactivate them on demand
  KVM: arm64: nv: Park shadow S2 MMUs emptied by a guest range
    invalidation

 arch/arm64/include/asm/kvm_host.h   |  25 +-
 arch/arm64/include/asm/kvm_nested.h |   2 +
 arch/arm64/kvm/nested.c             | 350 ++++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c           |   9 +
 arch/arm64/kvm/vmid.c               |  12 +
 5 files changed, 356 insertions(+), 42 deletions(-)


base-commit: 263a8db21f7321d74a9258d17151b295290b5dea
-- 
2.43.0

