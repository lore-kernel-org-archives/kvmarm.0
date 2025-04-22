Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AD529009F
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745341412; cv=fail; b=MTtxHNYrXM3vjREKEES6rBolHz64Rpr/zrzbqY72QgIgdgWxqe+4W+LTAy4o3bRk+Wm2wAtX8CCFnLrld+8/XktKQgtqPmOWV37YEPMoHIBgFNOHhXfafCI6NRop2QQfUzAfm8NdYs0ZB0bbeY6QuA/FQhlZsy06d8a8Ww3910w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745341412; c=relaxed/simple;
	bh=vO+iKB9aX3BTiVJ8my+ui44avKRN9fszyYpM9Jfl9oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WD9GiHM1XA6TaVpkj50LeEOonGy2s/sEjj7byOtb4jYOahG/1ZwWoPhLscCV8EmJ9a4gzVTPRCMF1Cd+3Qkb4kexIBKJZ80XiUw0KYuwBJuVdAKfycipOx1/U5souNg5W5f7HxntOPPB6YBc5dV8qdXCWUuRRxJThghTsZ6+Fh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=suH50vtC; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="suH50vtC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzDQzHzHcTsV/vu42XXE1aDzlR/hBhfhRhxFrHHU3WhRNA9DWh3ZB1fxh5Gyy99LHYhxS3GItkyYTeEMyIbcWy10hkm7X7YR2brooJaCVZHtoFWeCmv6+sup1H3ruZV44f4gG6i0V3WwHyBwD4+M34XexZ+D9WaUJCKHIwZlQAjDwhIiPFNx7qnb7/1uHMQXdWve6u//3tWuAYX6AwmF2q2ls2u3hfbfEx8mh9mKb6MYKsLpLnfCe92Mc4Wxcr9zYDw3JaklZssCRme8tMI3RENrWYWfDEdMu2Hlu1oQacDxn9ub8LIRP2I+PxkioZ/wNFsPIsrcLbdqDb7L8HxDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO+iKB9aX3BTiVJ8my+ui44avKRN9fszyYpM9Jfl9oQ=;
 b=ML7s3SVnoHpBuJlwSwUACXiSWcFMKtreTcmn9NWh+v1gku8PggYvMQ2CsS9lrh6irtWWF7RK3IaKH5v6s9z0Nv2ol5WE5CSBaxMrCbAFh3HWttlRSZSy2Z8EzOO+GmpNTge7W1DxsE+fO9JP+hC5sf6dEBpniHJklPGEgHy1cfRDChPuYcyRDoBNHluRhN+jh1sSK8DL9wxdoesUwe4gMsbD4Tmb4x3PcjD3jASNgzR41ja6JpW/TJrRRMo41gd7zZQFxT1Dno5k95+or9xu2iIywKZYCxlr/5cSIx5KtZOF2npSjDVxMfljrx+jyJ8FvrAQBzSUi4bRWzy1lkA+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO+iKB9aX3BTiVJ8my+ui44avKRN9fszyYpM9Jfl9oQ=;
 b=suH50vtCmPHAsOU556oOS3IP9tbD7KXUqjXHqI13tN32NfeaeSI5DXWC4ryVsivSrkCTPbN2kukSP33pjZkFilz8k/mJz8gqjdS7Af/Cez7D5KqqlTmRlqqs8gFpsGjc9u3/Lsy+SM+TARBs+QODtaO3yylFafoyqV0q2h6hiZzzvOWh4otCmGMCEe3Ei1/E9c699TP6s8cELL+gbccFTaLs5f8ti+kZnc1CzL79J/rOZvWR3nzYqMuORn6/AqawKyOp4ymUqOY5t+FsPBBpnhkS4pTf+VUVExxORAslAR2k6ZbPfri5VBjWaMDVy6CmyY34wY/zRJCJeCgS1dBXlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5658.namprd12.prod.outlook.com (2603:10b6:806:235::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.26; Tue, 22 Apr
 2025 17:03:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 17:03:25 +0000
Date: Tue, 22 Apr 2025 14:03:24 -0300
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
Message-ID: <20250422170324.GB1645809@nvidia.com>
References: <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAfI2GR1__-1KQHn@arm.com>
X-ClientProxiedBy: LV3P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: 011922c8-215f-42d3-d587-08dd81bf9872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H4irA2XIVHBzdn1GZVeu3+E64+zt+IchPlJOp9l9x2JNaIxo7X8MAnTa/ppN?=
 =?us-ascii?Q?T93EhkFjc/Om14++M+DpU1IlVpEkdgSt0Dc+w1q2ddGTn2qmnDyW7eXn/hCK?=
 =?us-ascii?Q?px3xtlbACjLuiTZOUVrIhZlAqoEJ7Fkxdfzgm8JGrDhN5uBKeoskbOCa1ed+?=
 =?us-ascii?Q?zDK/JC013geiGK9tjG10z/YTnlzQ3X/Pbp6ZUypiqSxsXDFuSkYAjewpCeNK?=
 =?us-ascii?Q?e4avI/e/loFQuWE625wUx4neuDZbpR1v6kfKGQuN5ZF2szf5BNzcfPupGZ1S?=
 =?us-ascii?Q?+r0naNuctK9BKkNBOth7TrU4Ru4s1wQQo/RFBEXBOTDAZ8Z0qSAXiOo/+rQx?=
 =?us-ascii?Q?FP/e/7jNx45kE/NEiqelOdkGeaNVArmZuU69r7bPkTRZOMFkLJJuVbOg3Uwg?=
 =?us-ascii?Q?z4VaWeakPLmhDWvscQ1dKI3GP91vgILjj+g0K7ETKBvXu/U6H9GPCzPzCWzO?=
 =?us-ascii?Q?qgGnz2KQ6/OXO/dbzQnrrMC+RFpnC935LqTntbWFkR41OliDZe5XwrdhuhaC?=
 =?us-ascii?Q?wgraEOOHNbLl2iTMx09K35VkCXOqJed8PoTu/N0m7Mfx16gLb1/g3Vg2BlsP?=
 =?us-ascii?Q?uAyEhnx4k+Ux3YEEgBMnB7Jy+wRjF4tCU1qx1ufuxFfA/cPDcAtC7dhgYYo3?=
 =?us-ascii?Q?lRwi0Lpq2vl1rsZn/eriOFBpRFb2+XqKIj8Zi1yZ6j0GYy+rourNWb7eJnm0?=
 =?us-ascii?Q?P0IK+NMxwX3jxxmxUJ3tTRM9wH1ouVOf+v/3BtEvcJ8NiCD3U+3txrHtd48a?=
 =?us-ascii?Q?ES7qVHS4jrGrAkxeAqmrwy+HhvNhFoVZ+RcllM+yxngL09t1gp4ZcfSRjUaa?=
 =?us-ascii?Q?dqYOA2X82EJ5ZiJxjtEXaCGiWhjcb3PHlRrppbDNx8y2oQTLVByar4WF6c5h?=
 =?us-ascii?Q?Ev1z5omP6aOorzcF11O4eTvUrYIGinvEVu0Q1o0xPOMawM3grYpF7EivSYHF?=
 =?us-ascii?Q?TfKisQG/IP95Uqu4L++ZFchDlQ6d6s8ZJF5sL3/LMbuncbtqhEYOnZE5DdKp?=
 =?us-ascii?Q?knTzbdbYDDGWsSyYOLD0CYqk/8o7v8LHZIRx4MV52Yb6zing91Pw3PtyVjeV?=
 =?us-ascii?Q?nobgpSVqU/m3asQ96V1TnkGeDMoC6r6SNlHF+G1M2UVh9hsqsEmCoRZyYp8H?=
 =?us-ascii?Q?ViS7QyxUbK+1/yQBuUYky3rOOUHrBmEDxjUPT9NwzL56HCpzkcI+yM8p/V9B?=
 =?us-ascii?Q?DqqY1hQhyA5+oNNnMt1BP+5CTl0o9PJ/vXjqspK/Jv0zK5rsIf1XHZQ7skYA?=
 =?us-ascii?Q?T32nZK96sxxOVKtSg7u8VqBF+3GVMMmbyl+vGT+iRAy8TiVHNNmZN/v+hm6/?=
 =?us-ascii?Q?k3xF2CYqjUunsrh0QaTo8h4CfHxFyHehjlwXaB6lBtg+sW900shRWjEbX2B5?=
 =?us-ascii?Q?x3nAC6OEOz2y+61b7gmpKL8djSFHdR14d/wWUo2uKWYG1rwYjAWkB4T9j7Um?=
 =?us-ascii?Q?vMVVe/zApIE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9mECcBgtptrUvxBdy3kSZWdkseoy4pvd3kvi3QfAlKhODT6dhY/sjJRtaWI?=
 =?us-ascii?Q?VwtimLwlK7kqTI16cSKhafhQtkegwB6ZQdqcNbBLpfF0IsL420dRiJcGlr8Q?=
 =?us-ascii?Q?3Ciab7gdkF+TbmqbAmrcJbVYvfrVjYkSx10M+qS9uoK8YH0wkbNkiypCGX55?=
 =?us-ascii?Q?L87PjrrkMlAHJMUh47Dio6DY36e+0hJqEIWUxh0l5lq+lc11jUfvZom3HetF?=
 =?us-ascii?Q?DFHjo0WaGHlWxAsWmRrqJyEu4brNRfosXOrgpgxNj1bJDqLj5QQhuNGIOF2a?=
 =?us-ascii?Q?2hkFeC+XEr8lqOjPyq9+z1l9FSN3JsePfdariAZMnF+4im41UKMnKw0BkNbV?=
 =?us-ascii?Q?MOYULjMz1tS0bXItaDdPt1VrvHJ5Uln+u2phwJ4zHhhluqfslihGhiF7nOO6?=
 =?us-ascii?Q?xxLdvTD+f7Hd9dckhtcZ4wAUxqZAsgl3wr4aaSjTKUyXInWlZWfei9Q92eIU?=
 =?us-ascii?Q?T/D3EEML+mt/Pc1sdxnK2IgoAsmfGGguYsvvX68atv/bXXvASmofbd0X81IQ?=
 =?us-ascii?Q?0fJzfDO7UQwhLVUSF3YpZOJ3r3QxQGzBwb7kVATMQwqZ81KWWlEVu8eQlFTs?=
 =?us-ascii?Q?cIjCIDOskXseCAIdlhJrWC/r5U0Yh7ToKF34x/g3VAH589zaYJdxFb+1yp4S?=
 =?us-ascii?Q?uxAYUdXkSiaC+0Vruy/31j+YIhLX22+DVp0jMxshZt5VIoxNXMktkRgal8Q5?=
 =?us-ascii?Q?qeIzgfA922vTWUbMdP2td5DUAoTgkMCEPZ0KJyAV7oprzl6n1nId8n8ruL6T?=
 =?us-ascii?Q?W4xbO/ZLwF7aOT6DeQNeDEVY3YVZQPDINNE/wBOUcf/i61K1zKpLbvnV6OUR?=
 =?us-ascii?Q?xre2/vFRtcKvapLF/YW0btoVOf+zCCk4vNqP6HnStvWSvC04p1aTxLYazxLV?=
 =?us-ascii?Q?k1jTcTVCtIX24QZtgs3bOqkFbj05FlE5AOeqi2yZRTJSUnhjrDewyRw9iE01?=
 =?us-ascii?Q?It7poJ6NJGI4a+LjwY5IZT5fDihEir/z/lqBsH8mClWbC0S2TMfa0aeBW6B/?=
 =?us-ascii?Q?NsnUVgWChJVyqtoYAvAkhGlJcksG0r0QVTrgPeQTyFtAy5cbsnezBYM56EYc?=
 =?us-ascii?Q?to0vFlSwLh1rvQodKMPubwaMstALK1ixVKTHPMJyz5GM1rP3OUBN60+ftEAm?=
 =?us-ascii?Q?tybCC2ki7YhE5S5BImWx8MY3fgjQoqPWKPVLSCDFrkp1xZHoEbeEXS5OOIyf?=
 =?us-ascii?Q?dvksFpW3110YvMFu764BYD9t+sFmaKeBwoFogWcCCQVOhkDJE012RFkdllzX?=
 =?us-ascii?Q?aDUel6ck4W5cbY9RmUigifpJPhAbhFDWw4WLYQKPqzpcCfMceibKG0zCKA4R?=
 =?us-ascii?Q?5fvjMxwRO4rXaISb1ixmbtLSOrZtwwcU+itMrjkAG8yxvBjTaW/Gcf9WkweE?=
 =?us-ascii?Q?EjBISxl6o09VlglGR5npwFDuFWVgZPx1V0BAYZRyk5mbq3tBLXq7fIjHgfGR?=
 =?us-ascii?Q?z5v798ASR0vncXYT9rRIQMx1fM3n+yyz0s2C+UAJfKX/EB6nI1jSv6UPJEb6?=
 =?us-ascii?Q?bXIhZjuTZML3hlWnQ5lkC3UKaCnBEbWYCTCW6eI1AVc+dnX597gc2Ex0ZNcX?=
 =?us-ascii?Q?qasPnVrDcimYXqRRYZWFUoaZDdPlis9eSYVtO+Zx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011922c8-215f-42d3-d587-08dd81bf9872
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 17:03:25.6006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRE4t7fWxLvvwe8IosZjeqUHYF0HmNqSA68VWLiW4GTuLyHXmy1R+sna2saUatO1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5658

On Tue, Apr 22, 2025 at 05:50:32PM +0100, Catalin Marinas wrote:

> So, for the above, the VMM needs to know that it somehow got into such
> situation. If it knows the device (VFIO) capabilities and that the user
> mapping is Cacheable, coupled with the new KVM CAP, it can infer that
> Stage 2 will be S2FWB, no need for a memory slot flag.

So long as the memslot creation fails for cachable PFNMAP without
S2FWB the VMM is fine. qemu will begin its first steps to startup the
migration destination and immediately fail. The migration will be
aborted before it even gets started on the source side.

As I said before, the present situation requires the site's
orchestration to manage compatibility for live migration of VFIO
devices. We only expect that the migration will abort early if the
site has made a configuration error.

> have such information, maybe a new memory slot flag can be used to probe
> what Stage 2 mapping is going to be: ask for KVM_MEM_PFNMAP_WB. If it
> fails, Stage 2 is Device/NC and can attempt again with the WB flag.
> It's a bit of a stretch for the KVM API but IIUC there's no option to
> query the properties of a memory slot.

I don't know of any use case for something like this. If VFIO gives
the VMM a cachable mapping there is no fallback to WB.

The operator could use a different VFIO device, one that doesn't need
cachable, but the VMM can't flip the VFIO device between modes on the
fly.

Jason
