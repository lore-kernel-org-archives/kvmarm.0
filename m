Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D620123FC7D
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945079; cv=fail; b=LKeDgBnyepB5DXNzcSf3dnhrdzCTDt6lnF7yMHVrO8Q1WcO5CYBqJWFSHVHdPbSLs6XNArNpCpTr9TC+Bgp1Wutp4M49RKbKQOnhM99/H7C1UZTyDml2z0QnWbUMkWPaLz5lacocZ+uk6gQSVx13/27D9dzwBhDF4vhsEqi1vlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945079; c=relaxed/simple;
	bh=ojmEVBY4QejLIAqDJzf7vdr9J5vfRBaV1Z6b898lN74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LSaWF4KS+2kJRC5VAuWEgOU1S/7ga00VmjWkSVDCIMAj+ZuVMunw71bq6mHGVFcYIj9Yeo4DqETToVTSaRHVad/vziEua6VZh6Br9LUEw8esjfh9+uzQeGBhax2XgVZT6VBnInA1guf8mFVSuwfW+hIFcNbpTDeuxzGCyR+T5lI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EUOJ+GjG; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EUOJ+GjG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J5gWfL7RgdingLxpa8byK6wOlaMabBcg7YOmOWuC9FcNCS6vqp8yGgJo+cP794Ad7BUtYlDLop6KyyPFK32yYn0slYrj5nR/A5JOk7vJMnFfAahtbivfOG10wSt1TPrkMG60MP2LsHWRN8l0YjoaT92kslsZlpBp/k7cqjMMga8PiCd4TDRRsf2Pfaqjfi49dZ0d+fN+mwkVi6V5NT2UH+ea5LD0BP0FqPBTMjf5gItmfh8RYQfPL2DdseU4ExVzbRVVCJ8dua/VJPShVr/icfWoEEUDeJBXvTB+Ita6xnesedKks6BKcpCr9u9XH9H7ly21aUhrMKBiT2IzWO8eLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPQh6sf+hYrB6m0AWe8dVd2+PLKT2eVV27xTMbuMDBk=;
 b=pHW2F1Jkdi6not3c24MYHynQ9wj1JHLypEy8YPufm1hw33x35DBZ4eLhiYv0z/kVj1TKzkGUE6l6HNqBb51dCFAfMcnzKbGWrIHWED3HXT0Q3Z39TLbw5Mok43iigo7OLmb3aYiYvfUJ9dFHW0NBy8mSVACYgII0Tpsj+ClJ9Ioh+gIl3gV2wmpA19eA1MWAXHku5yjIdDTIXRp/M1l1+uHe41kXvod//fFxCCe8Uwari4ducSB8mOdhYHf0yaiNLXd3KeieRohLNiAoBKBVN9ciAIFqDqXlSXF8sXKcrt8DRKpRe3kIXc01QM3cY0/ppN7rKFbtY0fBG7EBbMKDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPQh6sf+hYrB6m0AWe8dVd2+PLKT2eVV27xTMbuMDBk=;
 b=EUOJ+GjGEpVes6CeD8nIYatEiOQuKQ20NgVHMWWxV9ohATv9Fiso2sBfLC3Nmh8sOfqRJH88rcAwy6TKfpAOtR2txlHbxgaeNAL/idLKHhLywYut+nhKMHAU1CpPU5UyhFT9qiTiSyRMAx8akrzUuaUQkroeLGx0adP48v4X/9hFKaFiI2nUaidC0gNcbRiScdfnMR1G9jlxAt5s+UVHp5jJIHQbaqvIbU6O1cNJ/0xZcurGhK4OEdsgrOIWTUljJu5xb9G5I0xCyIrb6+sodDcFoxbP9RV1vJ9z/0ipkgvPydDfBGe3yfI196gbV0lcN5Ba0e9fs1JE6zUdqwQOAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF4C71815F9.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::992) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Tue, 29 Apr
 2025 16:44:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 16:44:31 +0000
Date: Tue, 29 Apr 2025 13:44:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
Message-ID: <20250429164430.GD2260709@nvidia.com>
References: <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com>
 <20250429141437.GC2260709@nvidia.com>
 <aBD4RsUZp-BmcLwC@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBD4RsUZp-BmcLwC@arm.com>
X-ClientProxiedBy: BN8PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:408:94::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF4C71815F9:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3931cc-db05-46b9-dd40-08dd873d1d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6eMp6hsSbwWhI/PLcEpR37EVdCVfp+Ot7/ghykxTgfzt/6IqN5vHeX80cNKO?=
 =?us-ascii?Q?eEjugjsJ+O+pBSmASuHkcG2hTVAwGeahTs0MJyQrBPvQ0zjq5bZ43f+aQp8A?=
 =?us-ascii?Q?M4fqqS1de2XIefgcaRHkgtRA/3Zfulhckxb2MABDdtQP5yCA989WR57RjucF?=
 =?us-ascii?Q?1jrN05cXH1k53V9aV4QWwwoFRyNwj1MmpjitZy/+/VzXSVbZDmA/WNE8N9bS?=
 =?us-ascii?Q?mIFybaklUEQSnud66aCcsVRh411DQo/wLDAF3QBmUOuABzy/sIf5kyddKMvt?=
 =?us-ascii?Q?5xVECoLrAOWn8+pz2MQ892TCBTqWPTlCK2XdSwoE+Jppv2E7j3fCDAyAZltD?=
 =?us-ascii?Q?yGt+JJBSBeECg4zKzV8H/HpKCz2RKCGz5krrmQEl1E086aSplmadx0NXDAFz?=
 =?us-ascii?Q?Ki+NWnFqTJKdxcMh+x8eXTTFpBFYhNuVeVYx1Ib9Is8DkeaIS/IkX07fK7un?=
 =?us-ascii?Q?xa3m85L5L9mSugHzxzLrXU6wnZnxsHE4Cl+vmHBFun8sCdD+iBUFSMFxip0f?=
 =?us-ascii?Q?qTmL0k5JnNtMxDTWiQvufjXf2+hlQToHzLjddu2IQKmC0fF10yvCnR8zsQF3?=
 =?us-ascii?Q?cy3SrHDPAov7rTRPwqSYZW2tbr9bWusqNrc/wTRpNKmlKhqMesxfAPOnZuQn?=
 =?us-ascii?Q?zNRJsQeHGyw0CIqOEFyT6JanH+TbIwtF8yXT83LgdXXlYora82/ohYNuKpzg?=
 =?us-ascii?Q?GJa+2PKOawAqGw3NCz/ihbuNQ362DJfMcsVJopnZzBlR9BdV9Y0LuqBAMpQF?=
 =?us-ascii?Q?0Xva+o7tR69obY2wKDX8eZEEVThAlIg+BEbkeYIpWUVA2D1oUH1KtNk/va0x?=
 =?us-ascii?Q?y6v0AS9oMA1EYOj2whWPnXK2oqkYDxGG1g3/N5TVUDB15CavPbTLbbqB9nOs?=
 =?us-ascii?Q?9a13ydh+wMJlx8LE4vGGU7hcPfoxA8HcNuqn5I+HNUOIetMGh6BuGMFxzrC3?=
 =?us-ascii?Q?3P3DsyS5Djb0jhxSRtoZrnFzOnpyz334zCQ2LZQJC+87UkhqAsr6IppisSiN?=
 =?us-ascii?Q?8CxTqq5dV0xGkuuzr9PQOWeqKCwkq0WjJ3QWQJZ1Ylc3HrmHN+Bpa6NqYWcW?=
 =?us-ascii?Q?s/JVp8xb/6FjCrLZF1UrA1GMbqJFezpXa41GIC4vqNqjpmNmYkFj7Ui4jkSm?=
 =?us-ascii?Q?4UlouYJERJVplnnSS/d2llAKq/OYHs+EzE3jzZppd6M/132ZbTU6shhbToNe?=
 =?us-ascii?Q?Ne4gITCc0v98xq6qei+rqzdpvExOxlEEPLARuA3gNUFofSEogWjUjPPMGpAq?=
 =?us-ascii?Q?4JoCI61LbGeSpdhteoZLVqQS3U1NPFNDCVmQPuYiyb7IXhRRdu2sksxCva7H?=
 =?us-ascii?Q?tuID/ixgNRxTtgVh9Ekp54gAmkSCoWSkQzeW9OdcUtEYMS6kWIXcqu7aLXMv?=
 =?us-ascii?Q?bGRvJm4jugdb+/w4L0EzSqgrimlfLGRt6qWtQMgycs4VEaASBtr7E1xX1ia8?=
 =?us-ascii?Q?ML+Ne39dcns=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?190Gp7FPB6/dNhUoKz0lksiQyH0LXINflibneYrG+qH4AUf2hd+Ge3+20aWA?=
 =?us-ascii?Q?rPCMuimh27tdPmL9+hdiYmzIsGnS57OKJrhv/DboIdQSM0dlW5pnGJV5GEfA?=
 =?us-ascii?Q?5FklQ/lJQiQOV7a7Yte3mgrAM1X4wtGw69SgUDoQX9L4jO3NoRJdDUhmHKGA?=
 =?us-ascii?Q?3p48rSv2cDKu5KLxeiWLxSPmTj38WtNHqixqVlZZ5QsqiRJGgLsS7HqexXMU?=
 =?us-ascii?Q?ZBMr21ldR5xMwNhWWVtqQZJZnBp3EwRREtpEfXQ0p4ZrQ4FEXuMSD5YyJkka?=
 =?us-ascii?Q?OuldsG99vGxMOThoXXfHiCN08Pnd1XZoiXNZU9pYO/v/ouKew63mG34Km30B?=
 =?us-ascii?Q?xXsCwpSLtEcbSBwmKE+OL0tfhYDGNtYjgYUgz+iKZXfqJCK7lwn5EZRSQOUi?=
 =?us-ascii?Q?ptaBWczJb4za6hJkYf2ei+piIvb0F7R6MbLkAKkJsOdERhALYTlADd9x8or2?=
 =?us-ascii?Q?kNFPbiLHjfHe5/wo0x9u5ldB+bFfRBI1S1g48V4ugv3NTg5wdh6jN1M2vzML?=
 =?us-ascii?Q?rXat+85+aEe13RlCkRcpKnNl79/uIVfao2cWx6ELFjSRVIsM48kReS+ggZJl?=
 =?us-ascii?Q?RzE5yMYsQbHcptJlsbbvzoQL51tVTwAGI2eai9l2U6tA8UbXsQA3bfRkd4QB?=
 =?us-ascii?Q?FY4R4yYXgaCRyEyhFf8sYY2Dpi4mwGgNjyQ+YOe5whniTij/yfucAl1Qn+5b?=
 =?us-ascii?Q?HlWlavtDpgTWxfL2XWdUY47MaukhNU/IBIUeVBGDFdfrbQrVlIu/bNdXuf14?=
 =?us-ascii?Q?+h2blehULnAfXWBDlYjoNV/1GX2JmGDcEJfg6Ldi2awslz+ahG8IrZO2khuv?=
 =?us-ascii?Q?TFvGbnP2dIN5xtFBDg/Xdo2aHHEA+fTVb2Iu+V+s78LigPNgoqAi8+/IopkJ?=
 =?us-ascii?Q?NI0HpcsR6C1fjBwvzpfGkAQAwkzYG62CV7v6Zl0iGTm0tdghtgVr6Ic5g2Tz?=
 =?us-ascii?Q?ZoDd96yB+QU9wj9vhRl8WvZ9U7tBfk6ysVhKm5jM0DKbfDRoeZyE6oL0jblN?=
 =?us-ascii?Q?CYCARyH7+yyeqsn2KmcCACCP/A9SzPNWQbeSnZJ5YFD5d68J4m6xXDntyyYj?=
 =?us-ascii?Q?iCOc4F2oj93I24qrQhns8WjZm2a5X3fYfeCAyEqVWOuyRS27Y69fj0tSucxr?=
 =?us-ascii?Q?Ra7+2wc7MLJzZ21W6xy2iGsFywMGhnDwLqt/HZp7WBlIFhZFfIcfJ/1Ml/4R?=
 =?us-ascii?Q?nw/StBbZE0Ro2mg15o6+LXxtfvFoXgTb5jvIvIMk3aA/4D4Wm/oMjso8yosl?=
 =?us-ascii?Q?LaK1IG+kXTNXiC9S7Ks2e/VUX15GcTmB28zinnYnCLqRjkTNneSplTugd44a?=
 =?us-ascii?Q?NZElSXKRp2/GaAx/hHHYD1ODj95gJ+kDCUfoIw6jzh1fkuX+0FMQHstUbAV6?=
 =?us-ascii?Q?7YU/ye04oLVDNIRFQmS0kZEFhA+cP0mUei2N6nkgwro39nDf5jAmxoJrqKES?=
 =?us-ascii?Q?6W3PDab2AatYy0EJEkK4+iUJfrpcu5CCCcqR0JSBVbecgAwUJSKMMnGX+kNu?=
 =?us-ascii?Q?R94dLzTBPXuzLTw5MTCvF5Dn5F/iUxC6UE9s02igYPwUXqzKb+YkzrVSb49C?=
 =?us-ascii?Q?G4wtxNc/QAODN2I9a0SQaT/SdU7WtOkL/chvNSIl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3931cc-db05-46b9-dd40-08dd873d1d73
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 16:44:31.5614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EB7QcKVGHGLVsPyK1BWccKa3ZZjYkuaFQItZJtu5/o+4JlefDbcl0AkBAteIwJGP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4C71815F9

On Tue, Apr 29, 2025 at 05:03:18PM +0100, Catalin Marinas wrote:
> On Tue, Apr 29, 2025 at 11:14:37AM -0300, Jason Gunthorpe wrote:
> > On Tue, Apr 29, 2025 at 02:27:02PM +0100, Catalin Marinas wrote:
> > > BTW, we should reject exec mappings as well (they probably fail for S1
> > > VFIO since set_pte_at() will try to do cache maintenance).
> > 
> > To be clear the S2 should leave the mapping as execute allowed
> > though. Only the VM knows how it will use this memory and VM's do
> > actually execute out of the cachable PFNMAP VMA today. The VM will set
> > any execute deny/allow on its S1 table according to how it uses the
> > memory.
> 
> If S2 is executable, wouldn't KVM try to invalidate the I-cache and it
> won't have an alias to do this? Unless it doesn't end up in
> stage2_map_walker_try_leaf() or the walk has been flagged as skipping
> the CMO.

Okay, that does seem to have been overlooked a bit. The answer I got
back is:

Cachable PFNMAP is also relying on ARM64_HAS_CACHE_DIC also, simlar to
how S2FWB allows KVM to avoid flushing the D cache, that CPU cap
allows KVM to avoid flushing the icache and turns icache_inval_pou()
into a NOP.

Ankit, you should add that check as well..

Thanks,
Jason
