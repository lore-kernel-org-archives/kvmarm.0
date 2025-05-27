Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91377A927
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 00:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748305618; cv=fail; b=BY5lKjPDZV0fVC1F0C7qBk8haDqdNaFIuvATPbhBitGSEZEdZWfyKXzBUPmnjanpevMW5Cr83uyW7nS+r/txyuxdDebKZL+DjAuBZHAoGXbXHjlMCZoklLlrEjSZsvUqV7w1l/W2tu4vs5qnfkBRp+b1fE3+fGJcB6ZrD1ZfVd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748305618; c=relaxed/simple;
	bh=VbApvsYX6X8aPMEqHChw1c893I63MXW5MOn454NHWFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kyg5q2KON9OZoKZ+u3oLnF8Yke0OwjDbQlVlcM8F+PKvK1T60Ap5O+aJVdYRZFEV1ysRqXz4QBHMZd/tZn5IY/XJ2awANF22VowM5YW62KluC0uN3JN3xKji4xF+npQxX3dXcW1srQ3FIZyUYwgVUt6WZTcW5wNIQ7A+gtXmh3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bdB7fzk6; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bdB7fzk6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmrdC1MoexWj/DJ74NLsr7438pgTHrNyE2iC37agFh8tdc0QNMbo/bKfUg7BHmNEos/hArYlos/zBRN9Wkz4Uhrw2x8QEmgeUNgQitp/BVB/JZdmtTohq61yfsULVaRWbQ3uSZKIT4PO749SIFQaNluH/cIIQabW496FxXrKZGEy6jKHBPH6DX6QJ4H2UHQ02dOiHzAy9jkTqNNHufWYdhfgtxzeRUYFf/Fd8ih3aa1hCwfIYm4JrNY3okHAq1r/LJqU5a+bdQwk97zv6lwW31sgldDnu23ipoZVA5d0XxUfwnu92rGcmy8gbQv4nE6rLXV2RthpelFCYjkeZYN4Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShDM+clk9upwE1ueL8ra8iP2EoLjVi6f+vUqU3Cdw3I=;
 b=E+vnrmxr3HI3E93Bs3oFLryzXJad7mLa+YmdP4lxP3ZgdBYctZ64VPBqeXgly0XI19a9ug3p0DNJyJbncBk0tIxGAJH30E34/ew1lbog0ZVvzgwwxHQVlRffRaVDHOW7MjhXhZGZ6zY+5BRh9Fjiex5Q9d8H55c4MzRNJFjnoKMYYjaZIuDKUAE5QXuOVdDfM5WCfqJKb1HzEQFWJZ51zpwkTZ/ClzhRmBkoPlEUVwS72MIZlQ59O9pXmFLm3NvpJV1UcLGiFNZ9hVygnMxFs1Dyxd37yeKnLizM/uSV6TG8MvQHLRSPnqEjdMDWQgiSue2pkRg1aMyiHnIBelTsLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShDM+clk9upwE1ueL8ra8iP2EoLjVi6f+vUqU3Cdw3I=;
 b=bdB7fzk65roXFattWEHSHNNFyV3+qfFCgoq12cBcpXfLiNOTIinWk+ORwEt07y5OGvnmshrRrj1Xp5dZYNS5yJD/IN4W0dbuBsiARJFufNHt1gzt6koqxJziFXMuk9s0LHf1GttqUwZr7iY6ZfDFQIrCPq0JMl91UwP+J6iqHoFjCqTaHWeIs9VhB3wXpQGlAFcStpLaSRHV5de1ejOqWvDxTz7Z3UUXhAMkBO90mJx86gEySrczAGhCOXBxIpM3xhCG2yJ9kepR7IGQITICjShqOMyExBSpgMvCglGpoPogH3/dFkKZ2Rr+x/9qIgNvUFehMeoW9Y3xIiJzqCzNRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 00:26:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 00:26:53 +0000
Date: Mon, 26 May 2025 21:26:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v6 3/5] kvm: arm64: New memslot flag to indicate
 cacheable mapping
Message-ID: <20250527002652.GM61950@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-4-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524013943.2832-4-ankita@nvidia.com>
X-ClientProxiedBy: BL6PEPF0001641F.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:f) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 9270a877-42ed-45a0-a213-08dd9cb52dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1/VkNG4iFjsItvnXKnm4PcqW2SBOXpPVoHgZ7lp7dAjApRwlIy4ZMt9E8znz?=
 =?us-ascii?Q?USTfJBAG1MrQcOkQ/4TGALfUqB5Gu1R12bj7RoNFjo3LML1bnN/niwVbuXPx?=
 =?us-ascii?Q?+qBfwu4XzMthYvqQXzYTCxSbat61eaioE0spxuP3uZVQADL1Me8ia83d0S1U?=
 =?us-ascii?Q?T8x2M61qCVt3aT38GMKHP6+EQRNOE6+RuNFAq6MEXWbFqNhtqbhx+/C6/aYq?=
 =?us-ascii?Q?us7okptJ5dVJSMmCkWoKu/nUrDlmekUSx31a0Ikg9EAWMTT4PNrTU5uyGvNJ?=
 =?us-ascii?Q?jnjnUyLKbnoos6zLTapPO/RCt1xhfZFKQ2M0ptQ20bQ8Lm9rLK0M5wX0wPeL?=
 =?us-ascii?Q?/AqQWr7GScjPzCAlW7kQX9t0IhZsRvVZEWOEnOSspC12bHfluwmr2fjARxpN?=
 =?us-ascii?Q?gHCDRLlBAsWSsvE9e7zrFOWUj5+LouMGKxLYRzZrRIkDe+oqoV6q/Di0VX90?=
 =?us-ascii?Q?uiQwHWSuY5th28GB5d6e91hljbEulux3sZH7XEeoh7a96a/uXgiB0Fsj0FEr?=
 =?us-ascii?Q?oOia5mP9PeAwqk+BgzQSPuea4LGo/s94ILeKIRqhp+1OHBcS0VkXX4WVyfBD?=
 =?us-ascii?Q?wao4FCj5VJQqOrYI+W0Ozn2Lt+nc03stghFMLlzZC1yO1zflcOaoPlKUArPZ?=
 =?us-ascii?Q?N94MX/oUCL8iqDxIuncwwfdc+QDUzICAqyA5AnV9BDViOIshRje6g5AkqvuT?=
 =?us-ascii?Q?0pTcrZCtvaxasysNGNTyPLzkO6TLkEWV5Si+j6tLUyqWqCTHFZYB4ClSVhWP?=
 =?us-ascii?Q?+f38xHHne5mAovr7sD9cjzRZY0TiWmVGeqtsyqdBPyvcBYRuRpWkjeFJCkpf?=
 =?us-ascii?Q?x5mK4MAoLxexwKswFp3NM1YQKEL3m2RXtcHz4YbKUJpIARogspIunsBGoxX2?=
 =?us-ascii?Q?d9MFy7iRm0GPbxH97e3S5i+JbuIQyBDy9wwOxYSPUga8V2eFFNm99hRMo9iu?=
 =?us-ascii?Q?H52zivh7ubDZpnkysyVIBLstlZGQ5vW6NmJ+i9clAcb/Pya3/yy3DNmXRE37?=
 =?us-ascii?Q?ricqfzKc6dxqB1T9D4iKaKScB9TyH3/QsHgYS5ovFN/v2LtpQUaeeDNlE4j5?=
 =?us-ascii?Q?YIoGTplt2odOrjIMw4m0HpjFm9hGi+lRd49XNvL8elzF4F0cHO5F6qGtuGr8?=
 =?us-ascii?Q?3/VHGTuddGrKLscPPMMNwH1aB+6SodBiViAK/ArBKqxjJ4UCh4Lkco65En4V?=
 =?us-ascii?Q?vKLduKThDPzrGdLAZ1nhsKBUvIh0gihuunXCEQ5ebGk25V2mFcuvIrnJyaeN?=
 =?us-ascii?Q?zZ7H3FkZKJhdx35qAyirZEBdhEZSMFWf9ZVxqDP9Q8N/2On28SHpcxSx1qMd?=
 =?us-ascii?Q?udPCv1cQ5jdJ0IZwgBG2LDVgYSsjmUeQFvW+bXQx7qaSefByJBNqULx5OU5G?=
 =?us-ascii?Q?SgnUWbLzIxYt09dRWlotFpPT4AbUun8DZljr6kR3TcYp3csEzv5dyehyKGk3?=
 =?us-ascii?Q?G1aPCz4Jm/E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lcdSp3MQmWThgsc8SivHHvJUld7NJHGTHFZFPIqF/GVtXtIe72k65l/hzaVo?=
 =?us-ascii?Q?rnmTldKhSvr9OPp0bn1TPd+cBfXdRVnCZU+xW9teVFWVPEe4ciwUDgvpg1/I?=
 =?us-ascii?Q?PqEkfhZpNZCMjmBbEaNUzG8nFx2l+/CJQP/v8obj4yWRtsV0F4jaFM74e+BZ?=
 =?us-ascii?Q?+4p//FBRAIDp6dVshsCIbe5ZgsG63thyFVOL91PAPA72Dmcc9mMVZRSie02K?=
 =?us-ascii?Q?TtYVZ3l0RKwTKPb3OsffAbc5sKKiYRE0bmSNU/0iYVATZYCw7KrN8kTVaGO/?=
 =?us-ascii?Q?7Jt2Hq07lFHuySadxXTP2PDAtkZgO/xIqXadmgBUpdXfaL8kOWcnEtss7tC6?=
 =?us-ascii?Q?KjRX5kafxjX+dDB/KgvALuUau9aqYYtG3zcfOMTeJajiMJvMQiQkwNun3346?=
 =?us-ascii?Q?ArPq2A2GcmlK1fxh67FeHRYszEt70uCHVMYB3EyrFnD7jF40hGPgMM75EV1B?=
 =?us-ascii?Q?dVEf1VgWPWDto1O+jXOpkXXQuTB2i52Xi+5rrSOzubADScrUuqSw08fU1IQc?=
 =?us-ascii?Q?EIK2snqofrrYyv3LXfvFBDhtzc5KMgZqBNr2p4w9ouxPp8to4Iz1eUgTAMTz?=
 =?us-ascii?Q?8CF4f9jeTCUlB6XA0cWEARzbn/DiMtvH8fIgFD7EY3kknGpREl+dEXxs6kPR?=
 =?us-ascii?Q?z9k6sb0yiB72Eg2RJR3KUkWUHTJqoFRbtXkH5/PQgckpUQK7RFmjhmm/ES2h?=
 =?us-ascii?Q?SfbC2Ab7LsPH15Yb9/KtwijCQylITM/Cfk05SFnqNEeyOhWpOVPA/lSoaV2e?=
 =?us-ascii?Q?NCEDorQq1BLk3hlwqmCBgOcEC7ipRbDcXZsQklhr8mHjFNRLtTwA8QtObF9b?=
 =?us-ascii?Q?KqHOp8MrSD+WjOog1TtodJY2NP2LBs651UjFSeIhFNFGKquvLZSgh0Mc3f4Y?=
 =?us-ascii?Q?OkrBV1wxFdtYdHvlD3+6GvsXeaf6YBRLjqM3kZrmqCCSqG9CsrDWQgOFa0Ru?=
 =?us-ascii?Q?xIUkQgxwBoA6Be+XKElT/L2iTstmGjB2OSl3aMqpXXJ0988xiCK7HyRU3hST?=
 =?us-ascii?Q?obIBG01FLzf/v93ONjaoJpoVeYzi8dboDE9NFKroU0vasGpbzUxt+bdUYmv3?=
 =?us-ascii?Q?0djivywKYHQtrN5loiZlIt9Fc52gMHT9bOjakwK7tX4rkj1MX3sku5pyFP/I?=
 =?us-ascii?Q?KCeZhDC394pawbcbbyaPoG7VS2WP2d14/qGRZxM1aH6zuDJjTPYS7ybMqjSd?=
 =?us-ascii?Q?HMlZcSYoL2KpWNSlLDWfq8wq1/jxd3ieNTtAgsUgqRX8t5zO9WdDfz6jnadI?=
 =?us-ascii?Q?wCCCKiSo3MaJ5FEHu41GYkhIIqrKtX8jd/SiNR6aAk3gK5RFPppDBbJp6zTV?=
 =?us-ascii?Q?1gkDfO8Omdoa5SQ79SgRiSIn4iCEjtd8b2P9wp4gr+QYfaUBGRjHUYnIrEc3?=
 =?us-ascii?Q?rodfuVY0dRUWc5VEyf8lIHgTHWMnSO+PjDd6UmQ0WBdgRcLSP72J2pCNlUmM?=
 =?us-ascii?Q?hteikAooTl03lj0u+V8Y+MWgjOEPNI6HGsh3ZCWxMr4qyF2D7J4Xumhvvfh/?=
 =?us-ascii?Q?SQIjqxZG5WYNlIUXV4NBF1tgila/OS4Xp7RpwVUpgbYCMfWiyXRv8DaR4HVa?=
 =?us-ascii?Q?4WAfA6pRotlsq8h9VRpAzr1ZzQa6BxKGx6FeoUeO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9270a877-42ed-45a0-a213-08dd9cb52dc3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 00:26:53.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USznFtW/E5icdPHB8CP8syRDYGy/I8mMIZtLb01lJ9MTj56bQtPGFSHqedGhYMPT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

On Sat, May 24, 2025 at 01:39:41AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Introduce a new memslot flag KVM_MEM_ENABLE_CACHEABLE_PFNMAP
> as a tool for userspace to indicate that it expects a particular
> PFN range to be mapped cacheable.
> 
> This will serve as a guide for the KVM to activate the code that
> allows cacheable PFNMAP.
> 
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  virt/kvm/kvm_main.c      | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

I thought we agreed not to do this? Sean was strongly against it
right?

There is no easy way for VFIO to know to set it, and the kernel will
not allow switching a cachable VMA to non-cachable anyhow.

So all it does is make it harder to create a memslot.

Jason
