Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675272D29CA
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745936086; cv=fail; b=NGPHY2z9UxepVgWoJw2I+dRHudDn+eLMCmL7S1xYF7aWl/KXM8uDLQgNthCSOhtC//rA7FenSq5dsNw7nHfdkoYAhYSCyAgWcRIS3DWTGJrudZJiEqSxWQit8n5ss5+ZAp2FfL3VOaUDCra8yjtwQfdO2a0ULRI3tgzc8/8IZFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745936086; c=relaxed/simple;
	bh=LxluroMxF2uHY+DJJ4ucJBcewK+oHM54wW00zohV95k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HYev/GnkOCro2Jv38nVRzel0odkqdxzDMOU/Ttr3HRGJkHWN++1C5XcIPSl8dxlxL0n/DZdUE4KPCy2xvuqcUiMUdsuQvsxFjImUr57eAGfTNv6U2kSpFYwF6B4vGZamnuRrBEQRnOLB2EKTfhJJyD/C6XIZoKTwjKb2EbpZ2Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PN1AEIy8; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PN1AEIy8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2CvIUNyg79RM3x3ktu4lPYCrYSO3+Xzc5xSCw9l+Vp9VpmXfhymVK5JT42EygvnviutCyKzAtEzGCce2Zom2Bz/dyPuyvPH5C4eq2BMncQ/0U/bS53X9tK3aMPa54vAlp86IIwzWSVo7XhwBEP4ezCmJkSsL2QHt72N89P5MKc6CvfRiK7jNJzidz4W/w8G5R2fieMx8JgwTA72CoR4joET8hkH2tET9R4P16CpJRkBeNmAnHx0hJYOd7Bf7AO6aYkBRjbaYmdBm5ARfY7swAsgy0vPazEDAUAD0X1WP1VoYuD5O0jEmaa+s2hsCS1jWrK0rR7jMRAhOUfKU7rQ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxluroMxF2uHY+DJJ4ucJBcewK+oHM54wW00zohV95k=;
 b=yKBkbtoVjotLvnHCP/My3gfqA9JdQwCrsIkrvdQE+SUrWIMbuWDj4TJLPWOCrdkNEXCmGzQifM4RNEo2BvUh6AL713uFdE9xmzrdSiz0b5WWnV10zJ7JUgeQMwN2Nw/M1BRbCU8CC7vgxyLpqXsNDZh5IhJ6HQaHW6S9oc6Gxy5BuFeYxrXuPaNKzqFCfXbIDssaNxqiLxSChHPyT8Au8iux8DUVHX1KmNjOgbxJH4NGdmBobmexOSlD34rHg07vz8w4lukv/V5pl/Y5wEVbTfMSnZBYrb1XlMWIuAr2W+dBwv/ylulpnR5ajllnMKmmRc269/mqic3GFXbapdT1kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxluroMxF2uHY+DJJ4ucJBcewK+oHM54wW00zohV95k=;
 b=PN1AEIy8eXS+/YTtg6shfP5t0gqHZHOfroz8MpvcYdFHUDS9It847RpMb1weTEToPcr0fuMV7VES77wfgrzT20N0skuSGKNs6o45aCpwWe0cvDHrbJI8o3ufxzpT94DwJhzfKz++mwS1lOavZ819zRDYJpySRAvYaaURI1CGeMjw4FGeM1YTnqSZ0QhSHSUq0Buj6u1qYXXLvQfdFjjBtgRXWZKLx8Eot8IVUlyykF1XGSrSwk2/eM6RAfOFYHOxAaQ8Tawmu71acnMeYqvQDnCEloaeJ70psNGZiyoJeNX3vPvxaw0lqihfgGTtU0eIauUj8LmWn3ZCnlRDxp597A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8421.namprd12.prod.outlook.com (2603:10b6:208:40f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 29 Apr
 2025 14:14:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 14:14:38 +0000
Date: Tue, 29 Apr 2025 11:14:37 -0300
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
Message-ID: <20250429141437.GC2260709@nvidia.com>
References: <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBDTpu_ACoXAPoE2@arm.com>
X-ClientProxiedBy: BL1P223CA0044.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: 2518b00e-b040-478e-a88e-08dd87282d24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eMQ0Ux/zym3aBuObBuiafu0954k9GhfnXg01hVk0gZhm31qsH5Bo2DVDaJwD?=
 =?us-ascii?Q?5tRYRmqOdn7DtGDp8gphhPi0n6DoghRkMA0tY76qfaAcv8fGYO9fl+HR9VQz?=
 =?us-ascii?Q?clLx4HFcEHMt0XT4VdVVmnoYzYt/ieW2JygNxd7B1+B9OuSpXobBXNB1nFPH?=
 =?us-ascii?Q?IldZigEErMG3gY09OGnr+utzYJfnH2N4kTtYUCCLdz9/NJ9oI4SICXunfKpl?=
 =?us-ascii?Q?thB1VcDW1dTSTPQod0xD7WSUSyPjPol/iGGc35TIu/7JGvXgPPr3THWl8Zeu?=
 =?us-ascii?Q?l8kGdtZS8eY6UDkf5qRuGKbJU5BvXi9qgCsyAeQJnG7dmw9oF3q8xbtPZoXv?=
 =?us-ascii?Q?GdU0mi+jJB2zYuz7mFBalT2khhInpkfCnHov5CJxOmTwtZ47GauCoRtcxItb?=
 =?us-ascii?Q?56N+obLafOfZtOLjbrqDe3qwgFw5v59HtfUzYM8z8rK79mF22JtznPOsDKBv?=
 =?us-ascii?Q?L3lbNhlIA46ngO0nFUgM+wrYVq2lPPXjU4IgzpjUzZjh9O9m0dOb+69dOzbQ?=
 =?us-ascii?Q?s0s7BO45+PdV31gcNlE7sGVG9FujtQxFWhuvnvCzw8hjU/W75tsjp0xGtgWW?=
 =?us-ascii?Q?ml9B+ET0X65rz1pG3dApgUVzXnLhcdWrM0smAIp2+auiwi92RRbEH91rTia9?=
 =?us-ascii?Q?0QPx5tt/0UtL2zAvzFliSEg2r2N0F5CMQIYc4EovkuVq+9/bKZY6m5fnGWGB?=
 =?us-ascii?Q?PdxquCHGKtjOt60tNSvt4zpQ0f2n3sl0w1SUDyoRlbg1R9TJ32A+lqof7BeF?=
 =?us-ascii?Q?5eGwBHxTg6d7hM9rQPbQeyZEIAiH4EATduJ2fXumb7bP3UEUXOLRwwTQL9gL?=
 =?us-ascii?Q?2YRI4qk4L8cpGfhT/9o5pn0DXfFWOVmkioNQWgQRZm3WmxsSjwNqdpbAUg8r?=
 =?us-ascii?Q?tnD8AZ1rfjBanXyjEB6W80gouBBVC/nFuxSYWtIfGs7u1wPZvvvhggtD42QJ?=
 =?us-ascii?Q?ZvfyK7jevLuo2UeVg7k/2yfKc39K5obVLXhGRJgMAFOa1S7FCzXkBXgwXUbc?=
 =?us-ascii?Q?U6/ovIEF0EipMtBKwqnELOzLvpMOlexPn06D4X2fk+S6lH0riNLcUm4RlIMm?=
 =?us-ascii?Q?jWtvkz3lJ4+l87GSn3zjPPGcrEOdmu2Gh4cScCpZUzgA1ZmYz1JTBZu65i6e?=
 =?us-ascii?Q?T3xytrrRQmVu0Z2GppoOJup/ccHVdMZup6A8DknP8GG4lC+LA2NbG5ROG28W?=
 =?us-ascii?Q?yXiYDhQQCrKGEtbTESFqCe39pa6MvZU4iF/Nbhbs/kX4el3rmqyKtcob0f5i?=
 =?us-ascii?Q?VciQLArb+ITOvWa/U2XIsbQkoYFY6/RUfQo0DqAVCasrsnPM+S1V87bmNDHf?=
 =?us-ascii?Q?lTMGNgfJj2Oj+F0gzD8URolrctz32UDjjmtQ+lZNCF3wCXf+1NOWBW+l8vNN?=
 =?us-ascii?Q?MN8K8SW0D8MLmoiI9lagM1cSuXvEUOx2C55wmZSdE2R+15EPnJTKG6CRFslI?=
 =?us-ascii?Q?4i9DoKVWyUU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Dbvh81Bdegx/3vpIL9ZkGQBrB23LifVjT2uJSpxf6x3QHhA5lP6UlZh6AL5?=
 =?us-ascii?Q?cZkVYen6uC7x1QEy/26oLeDhfzg3nVM2BFlrWYMHQGo8JYWopbvVDU+m4p0+?=
 =?us-ascii?Q?LKd+a5yXvmW88Hyl789wiNvzbw2p+GAlFyzanmxZoQbiA4K92/PeMs8Bv+YY?=
 =?us-ascii?Q?nS/AVrV7koiSQVnM+zKpJYpu6llf2Ps8PDK5EK0INit96sjZhrrgpjuoIq/W?=
 =?us-ascii?Q?O8w94+AwNM+IMhAcHzXTBlGjWZskQ8ZyhlcqOC0uW48W33L+bD51kAauzdnO?=
 =?us-ascii?Q?ckh18yM6mf+ktTTJ0Sw3VAvQpb3FH0fJRax51HaMr7j2QEc6Nx9EOG02l3ld?=
 =?us-ascii?Q?50ntQZgtt/Edc2X4V9wBXEzwv/QOzweJlIDMY/eHXLcvum7jLjb0zYXKtpmW?=
 =?us-ascii?Q?1laqBhkoFu2y9q5j16SdKKdLVFNiSnkUS0Rju7sGCKtFlS/ciSG/kD8y/yQA?=
 =?us-ascii?Q?7KKsDR2kW4bJw+39cy1F+WPBpY+PfrrAMXwV6364z4Cjckpu8cLK4YTpzHaT?=
 =?us-ascii?Q?EZ/QfTTKJrYxen5C3u1SMjsg7ARgHc8n/SV8QzDgWouU4AWN3H2gU1x3tLBN?=
 =?us-ascii?Q?yFj+wvkyylH7W5msKMQwP9hP24ZNK3KCHcE/mQxo1L+ahsXI1jj0uGp8oxDi?=
 =?us-ascii?Q?WP+47KOIgrAfO5pDbGVt4yiOx3grd1cjtocxjGx9azuS3402Mbqx8op1VHMy?=
 =?us-ascii?Q?ZXlfAXU010YFYKJpGy+R7BVudJNzfxVyXkj7kDE4n+N1j7uDzZpVT5/c7bRq?=
 =?us-ascii?Q?yBJ4GFUNPnDMJr3SvkgBoGdjiWWP5Sif6Z0xh3uEgElqEOKbM+mQ7PTrt8sg?=
 =?us-ascii?Q?VQ7fus/+oyngv73bu9O+EvSfwAV7XhgUssoRJs6Zx7o6OfzTPu77J0uLZN3T?=
 =?us-ascii?Q?rMgSm9xA9pQqnXddEOKpo0S8jSreNrbTPAbll/9P1jjqPUTSQkscFf3RsESC?=
 =?us-ascii?Q?4y9E3IAuXQYwqAHTibKd+dEswi7adnFpYCN5FzdCBunKgFuFApOwNOdVFZx0?=
 =?us-ascii?Q?3iAUUlEORX3w0u9ImZJnyQxo+Lb2UV/MVTyHEco/COlUC0kaJHtW8GV48/Hx?=
 =?us-ascii?Q?OHUpsodouBi+bowv6aq0I5IQgDy4Is7HLJ0ke2mbcK76pOM1yzDBve/46bLN?=
 =?us-ascii?Q?9zZzaNgNuMH+dBa528OKIlGwNSKDOm7U3M7TioOCht+pNV60DLmQQUvWxd40?=
 =?us-ascii?Q?kke4DRswsx6jycvgM0Qn3xqMnVMbv22AE+n49wi+nTtCQ4gU4gC3Mi9AFMEn?=
 =?us-ascii?Q?s+581iJ3PrEVxVBIua+ceCfHZPxM907RrPe9vviGzL0BNWpoF3pzfzkpsBRg?=
 =?us-ascii?Q?sVHpqzA0Wy4px0NAGeZcJNnUOfSamaJ24gC6jiAyER5wYLU7gwa5RGZGZRHE?=
 =?us-ascii?Q?A9hPRCdL89YHPbE1aANekMca4pMFj2ZJzvNM4JFxro37q1uh6NEgjyvOnG1b?=
 =?us-ascii?Q?SMAqSRSCKnibwHUgfxOme4mhbvVxY7CJiGSRUMeti20kUnNPvtckT8G43mR8?=
 =?us-ascii?Q?yNP2lkYo7di69KL1jXAoCiwT/8GSvGLp6egg4cN9SMG/qBtVTE9QgnZ9lrcH?=
 =?us-ascii?Q?6PDRfToZcTxcVBHOsKhBzxdizqGSpJdIwLnTr7Is?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2518b00e-b040-478e-a88e-08dd87282d24
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 14:14:38.6020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwSBhQbzANnuwlenNMAVR5EJtDdkwv9Er6wbevhnFgVdlZBvGwoJ1ObkP4PprxIs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8421

On Tue, Apr 29, 2025 at 02:27:02PM +0100, Catalin Marinas wrote:

> BTW, we should reject exec mappings as well (they probably fail for S1
> VFIO since set_pte_at() will try to do cache maintenance).

To be clear the S2 should leave the mapping as execute allowed
though. Only the VM knows how it will use this memory and VM's do
actually execute out of the cachable PFNMAP VMA today. The VM will set
any execute deny/allow on its S1 table according to how it uses the
memory.

Jason
