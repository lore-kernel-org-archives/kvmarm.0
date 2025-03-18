Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C0121ABD6
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 23:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742339362; cv=fail; b=Q2+W7oY6Jwmtvj4vfvsJl6/7SaSKstyG4lf6kPvF6K7Yn8mf32lv5Hv36G2mQNt5+pi0s1K2ip8PebmntE2+HAfIhQ1M9tH7N+6HtBUJi6X7H/lmvhTsXEDVsKLLfXWxHrI5fTF6u5l4KWRegJW91fIsE9zGX1V4W41M4jSu2lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742339362; c=relaxed/simple;
	bh=3uSzXukMaDNhPF4U3va1/tF0cEtoOenWKXde+sDdzbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fInGqBF7g0J5gAYGSXrJQODUy8Wz0StgVsBasYPzkiXLkFSZ5cWf8AVL24LQlvxNLNIvUK+XgHVt+Q9u/ix9PtxYqySMuvrNSp3EMq1yWcukIjcN/9w04FMmlHcyNypP8Saepctz/cuacuUm+MTxQp+vGVWaO056uXq4MNkX8/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ejj7+wXF; arc=fail smtp.client-ip=40.107.96.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ejj7+wXF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AahutjXrMLWj36u49dazQcM3tI4s47JpbR6mw1NyzhgnvvLjUkkrEgWnAuKEg8o+vQqqMjIN/Qji+8xYLBN+BJUYc+TdNdu0IVv6dMAiOyIu0m5NCWxUJyxrw4/Grr5kBrFCbyLO6le0CNxbZUqdT2m16P48fE3M5LMk0ftth86C/rxcm13D/gFBBc2atk+y1nGWjnPkNlJBZYjuHd2y7IeAZUQjcE8ABDK6DxALcYQD/MrXWTh9hXc48VGI+CwpWfjn3aS1A+kl2l2KbKdTRrGE7D0UzrC/oMs0XnEScQCrwd6NXHOnQ9XEd7o1LoRcrov5NfSWzuGUnTp6yHW1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdF9DSrOj/15EDaWHDARUOXVewe1fPI36Dl3IUSjh0k=;
 b=h155+DBHetJxnm6fexqr9bYhomuiS6QGgcWaydFdHu0MwFTGz4yIk2C1pnKGtRUsEalu8Bt8yzd+Bj5elHP+Dz8pdm1KO0a8N/1uMrYah5Scyr6IHS2l62G9A1FbcoJtIDnCsPp9wfnC/NTFwQgdzbPeQxQy+Lrq2d35Tl3gBiPII6VApH5DJw5o2WmXO6w2hn3C7z9PA1yPIwQPxOUECT6+wmyHknq/yx1X7E1ZgsFAJi43rQdMQJ1gMlAak/bzycZtFqJBWJ+4hNEK5cvUljWF+Urri/1zzYd7kx9/8JeZ/0i3hZqNDRh95GVrNTGLTP+cY+EjUbCRQvvcOWMbhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdF9DSrOj/15EDaWHDARUOXVewe1fPI36Dl3IUSjh0k=;
 b=ejj7+wXFzxtd0ML/pL9ZACnESiuvGneEdcIi4BDfOsA9XKRIG7vjefeqYqE/fKTfrce/WnkVNd2nXmt+48heXTLd8iHqAZKNzqILONhiLRpHnVndun99nxEO0QchDpiUaiiuYeRZ/eQ8PGNVSzYbBFbvatlckU0dMtuvxSOHUS3gC3emYcjgSMUVGVL0G16YviYjd+blh0SulgmExn8ytHauVgl2bAgZ7tACqHXusbHjEGA00fbSO1h7dNUkkPDfoqVHpNqBVVGKYWpAW3uORwcvIVeJaSPLAg6TAvKZKvlGIADXvn50QgBvq3FVWbrqqO7qrABLXoCI82A4B2PYNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6463.namprd12.prod.outlook.com (2603:10b6:8:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 23:09:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Tue, 18 Mar 2025
 23:09:10 +0000
Date: Tue, 18 Mar 2025 20:09:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
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
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250318230909.GD9311@nvidia.com>
References: <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9nJ42PllG8a7AY7@linux.dev>
X-ClientProxiedBy: BL0PR1501CA0008.namprd15.prod.outlook.com
 (2603:10b6:207:17::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6463:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b423fb1-76ee-4a94-2367-08dd6671e421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PAy90IGu2s3gWblk2hbHFT9DFxUVJpGDydm+Zia2GmJudYWWf5b9s0bHjhZh?=
 =?us-ascii?Q?NUZnOjlIWCfCtrxsnNOXop+tIJc7w3XUpc94ASaUskFVvQkR0gE0IHcVhaIR?=
 =?us-ascii?Q?AXIhn4gNNC4RlJGrfQJ+VkYSiieFJ794hKDvy8aEY0xxHzfsdS364EtxlIe6?=
 =?us-ascii?Q?Crka27YoKNTT+A4ntFqul1GPdNpJrWlg0HKPkdkSwnXGXaU6cicdy+et7wQl?=
 =?us-ascii?Q?QYoglK8X9qz+V3Txtq+BmihyemvNuMcMOR3IctSrYOm4JepnovMCMOHaL2V3?=
 =?us-ascii?Q?DfRehWKHe7cv/K+ivy+w8hpTS5xLawlzezxe7ZFsMu7eU8TlYuEMVW7bQSZN?=
 =?us-ascii?Q?izOJHLvaHcrwEm3iktbtYuAOeDbSYwzPAvl2gZ0yFyNy5FzOBQgkYGeCWPeO?=
 =?us-ascii?Q?13q/iQVzs8gKR0tqQplLEEgrTCBdLTgGYM1Ot/4MpZKXxsS60ModM/PoaeJd?=
 =?us-ascii?Q?U9qNNxhM/tBXsGx4rtHQ3lwTnUrIbaSCePe6bktSgkBOc6novu7XufAWwtEY?=
 =?us-ascii?Q?W5N8o4mvgMJbSjs/O7Yo+KIHYWLR7GNbr8XW72WTWCyIOJF58MINYhBKIe3y?=
 =?us-ascii?Q?yzVUbAa9xRKpbS9BoZyPrB7VHYCrT23L20pi1whV3lB5/Cd3I3eI9Sm4ew9E?=
 =?us-ascii?Q?uRqgrScQ/RZ6u2dXFddFAcxw8V03AprTT+fx9je3ssE8gY99/DwZGSDqq42Q?=
 =?us-ascii?Q?xVZwiXv0wPEMUyADTzNg7SfBPZbAZlatQfc4dw2GnY+l8XmH1oW/YYvpZQt6?=
 =?us-ascii?Q?hQGTqPeAjnE8goMjtfvJkIv0AUMn7i021uCUg/oaVUdKo1P9bomBPPbLcTHG?=
 =?us-ascii?Q?3R8Xp9eGBT7eDTlOKlGSLzgQshX3r/vvjGqOZr+fDCsw4vUbzIjr4SRPtTRZ?=
 =?us-ascii?Q?GIiihloNSuVXohRnGPLdAgsBNiFVE79zzAoNj7zm25vL6wSjAPUoe/NJOzrt?=
 =?us-ascii?Q?1anADgmLAjZdXM7lNVetbjxt5FAyetUEF7kn68gQhTwuELcAFdd6EB3PekoU?=
 =?us-ascii?Q?LnLGOJrWSJm/DuM5DIxwL8xtBxob4PwVkWE/KREGm2YtbXWprV06jOV7Kp7U?=
 =?us-ascii?Q?O4eQ2C1CwrXYPi+1+xMgG3PKtoqIXaUiJ9xV+Xrf7sHSeTh1F+d8aLMAs9rX?=
 =?us-ascii?Q?4JhHO1KBc+rn6s7Hp31ITjBsLd0lEvNpFlfLyYrMXc4Z2nHCiwz7jZyvD6H2?=
 =?us-ascii?Q?L7pGaN1C4m3QQ+5bavAQgDy2HsM5gDoSXT8fTG4Zb65O/w3uQdpHpGZvt60h?=
 =?us-ascii?Q?lXsvbLwFCy8dd1ZLoJ2NnzX/MLiUgJaWH9eSdx0SE5gXD9smWnExAurTyEv/?=
 =?us-ascii?Q?93GGw3s9DmuzpM//bzU5XPoApFDh/ALlZYq8oJNqUtKsFCvSZLxPykztT/67?=
 =?us-ascii?Q?NhrWLP41LL6YS59wUFn90EKTaqjt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oPcO6b46s3njUlWrT40l1omPp3YO7xnStHkqypfIyauju/9fdlnENwFlrJ/v?=
 =?us-ascii?Q?KiNaug5GNx1cxDuF9X0qgalCb5XvIVZZ357wtt9CwBq66wXJuB0fT6yIWLVV?=
 =?us-ascii?Q?m0pkZyS8UZNnwj4ULaqpJ1typ1ySHKh3hABL39UKXUbzGQ5lpCrQSZBXisNw?=
 =?us-ascii?Q?Hi31Rnc5eiiJet/JAWO+cLIVMql3Z+RIjpEPtCbsLwfRtFLIXsnvosgWnvDG?=
 =?us-ascii?Q?z4Zlv5Tj6gsKJruEe6tAh3YpBdSLu5sKmcsOimgSMa7G5TDhZB9e22Wtz+6C?=
 =?us-ascii?Q?m4cawY7lMyyHsFh5fQotrD5K+9gQF+Z6reafsYXJ6/54VX6pj8o9UTYcLKwm?=
 =?us-ascii?Q?SyCncBFTL9DG6j0G18FMc5QRzLA7UxWHE6Ij/qoZEwQYbdvx1ZICGay7DCrM?=
 =?us-ascii?Q?S4WSOe0cltVtKYG40JzpbJSILzGQUBPr9sD1ZghRvH+S8m5LtVkwL+eP2rfB?=
 =?us-ascii?Q?hqbCCpIi4lqcE2t5yKVLNkBF8ocybv4qxSYHwFAeetf2M9wekk6ldeKIKQNp?=
 =?us-ascii?Q?kGMDdZ66L7/iFwMU+eW2e4Sgnr00oA7eXRw7dhVzyd37gXXa8c9Lhqy0rGVo?=
 =?us-ascii?Q?y8UxYdoVBUgRAQGZlt/paaJRS8oBnqHMQg312J44ab2Hlp9HeIMENLF5HmGE?=
 =?us-ascii?Q?ZG4stw4C1pufbXpxE+RZ/nIiZIWaiVTVCOKMKtyQB/vZAPVbC/76q9klYnJA?=
 =?us-ascii?Q?RYMoOefWa9M10aurzOLDMThWxo/BELOkr1xhAPynMDAsTUUIL7TQ6Q2o/6Ie?=
 =?us-ascii?Q?eze+ZvuN3k6LZznQ2G8p/QmBLt/m4p6b7Ec8ZkJESY84SBN/LyH3HCzFBSYE?=
 =?us-ascii?Q?aCqKDZXteyfI7XHGAi/DjgX0GsR8od7+jAa9/K18YY4krc8lGpyKg9RN8WYO?=
 =?us-ascii?Q?d/y43tPBu4591j+ygLKPtbmE7WifiHfboWjC1ta8UqsYV7EVBUbLe5MXznv5?=
 =?us-ascii?Q?vL5vrAE+ifs+idpOyG3xcNDJ8ZkVeCpYrnl0GIk3fZ7C0FJSDr9H3S6HW0sl?=
 =?us-ascii?Q?Xk0AIJi6vZl8de4cgxgWgzMA8bo63EuVEs+ePgQENyD/+aU+uoJl3TFH+KrJ?=
 =?us-ascii?Q?623hakknSEQ3jUkNmljxdqnmHlVor1VPh8E19RabdFFt0l127AwgktkXyVO5?=
 =?us-ascii?Q?GoiWSuv8RbIsTWJQ1NK/g2Rm35rh6byWpGXnN9xrp1Z8KiLO3khunKeSmY2z?=
 =?us-ascii?Q?J/xIJHCVMz2kf4ZfhPwH262f1rHiQ2PwNmYOrDcvQ8CwoGbHSr6jvkPXzQIX?=
 =?us-ascii?Q?+QX9gkTLzpk18h791WB6j4SoqZ307fYk8UsixcjFXXzYRE9ixea7rgr1LbT8?=
 =?us-ascii?Q?jdy+kEKXaB+GSFwoZQyTJ4yM33bU1HXOE2oQrPjVGX36kpIPaPsFHPxxYMKN?=
 =?us-ascii?Q?5+9i0I4JXTp+pU2p4eqWaB7rjAHuFunwlBHYm+le7sDELN+elt+XHvROW1yf?=
 =?us-ascii?Q?TQwyIe2QFLFyR2pjJPK4t01Az5YyRUDhc2S0SFDNqaPSexsnhTSAudEI/VIH?=
 =?us-ascii?Q?Z4qmfSOUtIAWSKlFX+xNOfOvk+lIQceMVt+2gDHD7e3eQU9bSktLW2HQ8V9I?=
 =?us-ascii?Q?hwhDpxvRnynPOIpaA/o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b423fb1-76ee-4a94-2367-08dd6671e421
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 23:09:10.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0ST0C7KBdPmNj8c6pCu9I7IPvp9RRzpnDq/WkR/pRNIWiaOLpwKZDPRlfyEc/uP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6463

On Tue, Mar 18, 2025 at 12:30:43PM -0700, Oliver Upton wrote:
> On Tue, Mar 18, 2025 at 09:55:27AM -0300, Jason Gunthorpe wrote:
> > On Tue, Mar 18, 2025 at 09:39:30AM +0000, Marc Zyngier wrote:
> > 
> > > The memslot must also be created with a new flag ((2c) in the taxonomy
> > > above) that carries the "Please map VM_PFNMAP VMAs as cacheable". This
> > > flag is only allowed if (1) is valid.
> > > 
> > > This results in the following behaviours:
> > > 
> > > - If the VMM creates the memslot with the cacheable attribute without
> > >   (1) being advertised, we fail.
> > > 
> > > - If the VMM creates the memslot without the cacheable attribute, we
> > >   map as NC, as it is today.
> > 
> > Is that OK though?
> > 
> > Now we have the MM page tables mapping this memory as cachable but KVM
> > and the guest is accessing it as non-cached.
> > 
> > I thought ARM tried hard to avoid creating such mismatches? This is
> > why the pgprot flags were used to drive this, not an opt-in flag. To
> > prevent userspace from forcing a mismatch.
> 
> It's far more problematic the other way around, e.g. the host knows that
> something needs a Device-* attribute and the VM has done something
> cacheable. The endpoint for that PA could, for example, fall over when
> lines pulled in by the guest are written back, which of course can't
> always be traced back to the offending VM.
> 
> OTOH, if the host knows that a PA is cacheable and the guest does
> something non-cacheable, you 'just' have to deal with the usual
> mismatched attributes problem as laid out in the ARM ARM.

I think the issue is that KVM doesn't do that usual stuff (ie cache
flushing) for memory that doesn't have a struct page backing.

So nothing in the hypervisor does any cache flushing and I belive you
end up with a situation where the VMM could have zero'd this cachable
memory using cachable stores to sanitize it across VMs and then KVM
can put that memory into the VM as uncached and the VM could then
access stale non-zeroed data from a prior VM. Yes? This is a security
problem.

As I understand things KVM must either do the cache flushing, or must
not allow mismatched attributes, as a matter of security.

This is why FWB comes into the picture because KVM cannot do the cache
flushing of PFNMAP VMAs. So we force the MM and KVM S2 to be cachable
and use S2 FWB to prevent the guest from ever making it
uncachable. Thus the cache flushes are not required and everything is
security safe.

So I think the logic we want here in the fault handler is to:
  Get the mm's PTE
  If it is cachable:
    Check if it has a struct page:
       Yes - KVM flushes it and can use a non-FWB path
       No - KVM either fails to install it, or installs it using FWB
           to force cachability. KVM never allows degrading cachable
	   to non-cachable when it can't do flushing.
  Not cachable:
    Install it with Normal-NC as was previously discussed and merged

> Userspace should be stating intentions on the memslot with the sort of
> mapping that it wants to create, and a memslot flag to say "I allow
> cacheable mappings" seems to fit the bill.

I'm not sure about this, I don't see that the userspace has any
choice. As above, KVM has to follow whatever is in the PTEs, the
userspace can't ask for something different here. At best you could
make non-struct page cachable memory always fail unless the flag is
given - but why?

It seems sufficient for fast fail to check if the VMA has PFNMAP and
pgprot cachable then !FEAT_FWB fails the memslot. There is no real
recovery from this, the VMM is doing something that cannot be
supported.

>  - Stage-2 faults serviced w/ a non-cacheable mapping if flag is not
>    set

As above, I think this creates a bug :\

Jason
