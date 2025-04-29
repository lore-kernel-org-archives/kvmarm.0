Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F7F8F77
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950775; cv=fail; b=PWlxRno/ZrY7zupS9qqhBZOz9r77CvkyFvcq3D31O5PdFkO6kKBwAoBfg5F56BMSZQx7fa5HgLrvQumCCOVxJm315TTZrHfXBzobDCmbAM45EZQrtlok7JjGyuFfGGTEQGIcfGEEJK9Gq7Y9HI46EtEdgR/Snd/+ahQ5YpDh0GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950775; c=relaxed/simple;
	bh=VaWtK3uu4FMniVOYbdEd8WJbZ9hITNJ4PH+ocKnR6MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZWUR0xNOndpT+pfIGZdWeF0RqvdnqnQXL/AxnOHRdzgvwBme+ttlkzclMcbID9bg7uBh7ZjK3YcEC/4vQR6cE58on/vSt1CWGLuDhaMtBnMl86DVFdVQYB7HTabmwxz1i1rQS2QhNiNOefBy5h8KEsF7NyZCYh9D2GNIzDtzbew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KSjEmXwe; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KSjEmXwe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8sdjZWybmAhZR3B10wAPQHDk27GdSyhiI5m3ucU6Eg60hERqH9utvBXFe34w8SFGKREFtgPRqaY9l/w9MnejePZGhhjuRnyvTZJ8ONNDQWuabASSBKboGQZ74bRlcVwQsOOe1rbznuZgzYKJdhdiaY1XAj3sRnoGiW4wfSbx3bijBLxJdcw9GhPI1CcZgRmwOqctzLQXfcDsUwg9a4ntZyZgMVGj3OoK9HbOXQ+iqpuojKoB/yVL9UP9ZyQeLWUip/pWFgtWbczlAsMIjRIQPgeNk/rqltqbPTlL5Yx6Kjae2fc8x3EdeQ+qE5JJkVOU1GyNNh5CjUb3IeBOWkYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qq/adGRhq0oL/tasIHhke5WTA9hVcsWTJT0/t4gF9S0=;
 b=vfXyTXgDC45gwqghMsqHDLgLaaZl4NwUUHPyksGXTrsq6FOucOooSc877zPQ5/2vQV80jR2jx9jGFA2CJgflGBfKov/jIQt/p4tM3ZTthBMrLZa+txp8cWWISNDZ6a42WJ9zj6QfRgfuHSrjvG6fXgQgmj21hZWasBVR/fAQuc6tl1BKRWmk8C+3bBb6oLgvYiz8qGeGoDU4u4rLx5pWE1FnoQG3EG7E0+X0i2TfR6EL4SRf71kMH/G6A7gNPdy6e1HxH+RQZiHd5CmuPuyEsIjfvzehcP8MGdAnvfM2i1Cl+BohSHdtMiHz1tHf03KLk9v/0bUChpJAIYDGtdsGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qq/adGRhq0oL/tasIHhke5WTA9hVcsWTJT0/t4gF9S0=;
 b=KSjEmXwebyf79zJADOlw9zVt5XJXkZ3wgEIerzdWF3t2yepnoTelS05ecbPLPU4lUwsEIOupuMfnQLutIfckM2mcyIis7PJumqFr3F6gFtSVTqJH7Ddd8Ukv7TiIRZc6VANgyeTUEoTMvI3EAORVq6+NrW0oJ1KYTIoWJi/PhQXbP+IEyBznB0Cm8VK+YyaO1K2TxbttUmdcSY+bIBd9Fxd5gG/VBXjTKZBeIdm5vnadR2Ig69NZXyGw4pR/TN0zIkCvqRGB8LYRLdTvnQObUw4zC9EcPqNI8Wu7PBaLmyzDAhQguuzUfv33iFjVH/8qG5331y9PDOba7LrrpANHbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB9445.namprd12.prod.outlook.com (2603:10b6:8:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Tue, 29 Apr
 2025 18:19:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 18:19:28 +0000
Date: Tue, 29 Apr 2025 15:19:26 -0300
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
Message-ID: <20250429181926.GE2260709@nvidia.com>
References: <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com>
 <20250429141437.GC2260709@nvidia.com>
 <aBD4RsUZp-BmcLwC@arm.com>
 <20250429164430.GD2260709@nvidia.com>
 <aBEV5gxYoDFct9PC@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBEV5gxYoDFct9PC@arm.com>
X-ClientProxiedBy: BN0PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:408:e8::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 4221874d-6f45-4334-b11d-08dd874a6061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zgjX+2zOnZBCZru8P6ienFNZ8MX/ZLrm8/to6VpXZCLYG+bGavFYBzWjZ5C9?=
 =?us-ascii?Q?4O26npIKxGRMnHU0n5uYYXVFC7cQ1x6q1aMjtyGePupiXksaCh6KFMOsIgH+?=
 =?us-ascii?Q?5hcXq/tqt29El3+t6Msf7s0lPB0n5CtBlI9KWENbMCYS6uLAcBFAFfNr7mzf?=
 =?us-ascii?Q?T67FRWAjLByV/He7G2RJPMx74NmkEhNOJ9gwPCPMu3CAMjON2stNpQYc5uBE?=
 =?us-ascii?Q?11AgLs/KEBEWnrl3buM9rA/2nyLojpZYBpC1y36kQjRSUgIbxtzCxlejU8tp?=
 =?us-ascii?Q?e+34NPxiL+F6kKuKEMq0aycLGmAG7+4AkOdsI/Z1HFJ7Qnc68IRqVhkcG39n?=
 =?us-ascii?Q?9Pjnc+xN626oOwyLGmuDaf3kqgKUtQnsuPML9sYz0zI8IA2tfMXHzl58Mlpt?=
 =?us-ascii?Q?HAiJa4ihUd5Ktrna5bJtYdxPc+GQjh5qP5lMvZY6H/SaMTLgF4rjqYz1zOWW?=
 =?us-ascii?Q?GLyLUYlOEJrabWxU6RSti8mAPFvMAFwwpSp+lpnNfv226k7P3PYnhZTrK+Pd?=
 =?us-ascii?Q?0X2bKQrwzB4PaHp5Mnvl4E+AbUmNH3FtmC+qyoP0e7P9MuWjOCk2Th2Bh9DJ?=
 =?us-ascii?Q?Lr+u5fxR1DCof8Rae94Uavmc3lzIZCV1mjA2KeTdIGzjPxDeasHnnVR08JwJ?=
 =?us-ascii?Q?ojr8qTAuwiKhi7K09ovjFquUxSFFd4rk0qKyX9O87Rp1ZMPubWzsD4/mlh6e?=
 =?us-ascii?Q?5SN8MnyIazBimIoCxsv860OoNfeCYmHH1IKaBXz7zqXfqcg+xAP6f6WPGrj0?=
 =?us-ascii?Q?q0Uhdduc6phgGtgWTNSwE+366vze7S3xheDih9ETxqrbNKIV69t1SOKts8g3?=
 =?us-ascii?Q?cDh5JD8DKfHPswJDslT7q4wTv2Irn8kJzYJyd+/oCVx6Iv7JWQfTpz7D7vx2?=
 =?us-ascii?Q?3SEnS0WlVkQVzva3PpBRMfwEeexC0do56mBMxt7Gc6jnHEVH3ipEGQmBESsC?=
 =?us-ascii?Q?7TxERn9MTMV2a7IwucBru40onyGebM8dG6gon3ZhXg+en6qrH7guK/sz07t7?=
 =?us-ascii?Q?jWx+VPfQqq1euefHebNAMmU0haxy+ux/FYQGpU0DHEN8gdVGrJlU5cfADLZE?=
 =?us-ascii?Q?6RPX5kN/eTqHUVu6jukg2HRskYvJ4Ef+pe7Ds/m2c6ZVqEZSqQuhXuGJylI2?=
 =?us-ascii?Q?I+H6hL0jc1aoA0xEM1aMP1H2ASF7ZEJS8METOwAJ1FsHsBbTSRwDu9nM+OnU?=
 =?us-ascii?Q?kIFPuKqyMHza95siKGMRFhae7XkcfMSAj04Pb09lLxYQoTy+nLmWrwlAIRzB?=
 =?us-ascii?Q?mrktOlqmBX2uYBcGEiTnHZWC5r2OS2/vEGfUY4GHGgatDALxh8Sbpo7W0Bgg?=
 =?us-ascii?Q?502PvVpd282kZ49fILv3Dl8O3IH5HQmK5b4ChoxyZr9PgrZZABsNeTVHOTVz?=
 =?us-ascii?Q?+eS6FcLZML1fyhIpmet89UdFR2bRUaRlkcevdgM0KDS6cHs/S/eHNXD6XlRT?=
 =?us-ascii?Q?da5xNVtUGoE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AIbPX7f5toxD29eNYI+j1LQZdE1P/UsOD0fvEPUEZzI8WeYgu2MWqFa+YlO9?=
 =?us-ascii?Q?B5hclHHHnwGQega4GVWYKHRAW9T/Iuj3hTFAHVr1w7TZUn11gChPn4IDxkCz?=
 =?us-ascii?Q?3bKlQjz1tUL/TmfN4QWbjNQKH9IHDI+eJhZD9Y4CmjQxUnsThHyNY2EB23L0?=
 =?us-ascii?Q?1/FyBxIB0ZQylKseNX+dhDGfIM27vQj1rQt8AUxNppSOyK93iAA2aNgycWwr?=
 =?us-ascii?Q?zDQiFYhB7hS1FVGucRcoRUjsvMLGeI+rb8rYtDpkG3DwhDZ0/ymliye6uV/e?=
 =?us-ascii?Q?2ZEoo1yfUtOn5vDZmg3Kbj8+H03y9jOGOgbZmXY73WTWVmHdmoMAii5dQ0lH?=
 =?us-ascii?Q?qYdwYlrEYW7K7uZiDwL4ldjw6dJVFUABDzwilfhQgOm/O6o+slehBqosZGL1?=
 =?us-ascii?Q?mm68iNqnuTJA/fhnX7rnNBb4qwi9B7mgzFjgjpDSYy4V7OGqsPHumCiDkZIU?=
 =?us-ascii?Q?gC9Bana2UOJuqxx+fy0FxbBao7fdEU/vBKT/S0yk2G43LWAiPLcKce34nT9a?=
 =?us-ascii?Q?3HkF+VbMnFaNHUr7V7XxtfwH3uOByAtIkMfBdc1JTO0YI0SCHFH5aWdEbgET?=
 =?us-ascii?Q?XHPbDYw/7CzwhPrd7C8VgvAEh0/3scLbgNGvCnoLwHQ59X1jqutDlya6JrpU?=
 =?us-ascii?Q?VtJHjz+Hstdbhx3MhwFWeAcIeek+m1tOYRZCESkQHKP2PlFagD3Qe8YtaRHl?=
 =?us-ascii?Q?i+i+RHHt2TyPZsDW8qy2dYfyqzIctGFYZ3zRDI2pkNs3Il/GXuJVvW88jWov?=
 =?us-ascii?Q?uJPJbRjxyoKQdDJdd58d3WKTH+ToYAP3uTHGvE7T7C22ImupyJFr0VmgnXZ2?=
 =?us-ascii?Q?MWMA5J4kx9hIrsvV0pgYV6O0lCZPBTRWHy45KVcqAwIKiifaOFar6YwCB5U8?=
 =?us-ascii?Q?Ij1UDmQORaVQsnltOwg/rWjWLC2YSGfLWMweXNeNlabKqToK+g2SPqGGeM6I?=
 =?us-ascii?Q?cHKIlHx4srvdo+BUYHCEMom5bIugxj62om94obMgB5W6Mtp6vkJ6xyqVpZ5i?=
 =?us-ascii?Q?Y3ZBD8zn0YFmw656VXgOD6IwatOMJZlhfxLQVeONuIiYDcKOJD6RWMuDrl8A?=
 =?us-ascii?Q?zDSA/o7KPdPeA2Y0XpfC5Xb9sHZl2m+fVFAG9Z3cPIdDGhv5XfBZ86B6yjyx?=
 =?us-ascii?Q?5HcX1hXFToMFiTEWpLXlpcgdUjaVr1cWtHWQ3W8WIu1LbQ5+vLtRu2ZpAIAJ?=
 =?us-ascii?Q?jd66ESGi+GCcOiYk5djYihWvXtUgT+BBSoBaF/69DMa6K4YMFgiNTk7ar/r4?=
 =?us-ascii?Q?OcAokRZxxcw6bpQjzNsEkAJEKPgkKDEDKwhW82fw6h6xd01ndzpwBR17X/DM?=
 =?us-ascii?Q?7ZIMnUrNIGfgS2DLnonEPxEtdXLiTauNjZHpWKoAqO1zdxJRKyPPJet7LA69?=
 =?us-ascii?Q?3/otONxNqQYA83FwhJD0nKkPyZWETj8KuaPLPjINVggIbaqXQBsy3AlQB9Dn?=
 =?us-ascii?Q?OjzzOiFXq/g18CokE6A3NGADDLWWU/LiSvC7frZxIvpbiHQt+2mIdKzR5ef8?=
 =?us-ascii?Q?FNY/wSJg9Go6OeITZWyx68V8Ne3IH3UbyuEsU/uU8BzIlLNEtd8kzZ4Mu/oO?=
 =?us-ascii?Q?oIKnVkXRXz9j1a5PXntsygWUEhLWIO9PssJMTtye?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4221874d-6f45-4334-b11d-08dd874a6061
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 18:19:27.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ttw92R8FloXLwNZ+MVXdGWFv0X9DcZQT3DQYzHyvRik5UmYEURm7NpFKCfPNdox1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9445

On Tue, Apr 29, 2025 at 07:09:42PM +0100, Catalin Marinas wrote:
> On Tue, Apr 29, 2025 at 01:44:30PM -0300, Jason Gunthorpe wrote:
> > On Tue, Apr 29, 2025 at 05:03:18PM +0100, Catalin Marinas wrote:
> > > On Tue, Apr 29, 2025 at 11:14:37AM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Apr 29, 2025 at 02:27:02PM +0100, Catalin Marinas wrote:
> > > > > BTW, we should reject exec mappings as well (they probably fail for S1
> > > > > VFIO since set_pte_at() will try to do cache maintenance).
> > > > 
> > > > To be clear the S2 should leave the mapping as execute allowed
> > > > though. Only the VM knows how it will use this memory and VM's do
> > > > actually execute out of the cachable PFNMAP VMA today. The VM will set
> > > > any execute deny/allow on its S1 table according to how it uses the
> > > > memory.
> > > 
> > > If S2 is executable, wouldn't KVM try to invalidate the I-cache and it
> > > won't have an alias to do this? Unless it doesn't end up in
> > > stage2_map_walker_try_leaf() or the walk has been flagged as skipping
> > > the CMO.
> > 
> > Okay, that does seem to have been overlooked a bit. The answer I got
> > back is:
> > 
> > Cachable PFNMAP is also relying on ARM64_HAS_CACHE_DIC also, simlar to
> > how S2FWB allows KVM to avoid flushing the D cache, that CPU cap
> > allows KVM to avoid flushing the icache and turns icache_inval_pou()
> > into a NOP.
> 
> Another CAP for executable PFNMAP then?

IDK, either that or a more general cap 'support PFNMAP VMAs'?

> I feel like this is a different
> use-case (e.g. more like general purpose CXL attached memory) than the
> GPU one. 

The GPUs we have today pretty much pretend to be CXL attached memory
so they can and do execute from it.

> Unless FWB implies CTR_EL0.DIC (AFAIK, it doesn't) we may be
> restricting some CPUs.

Yes, it will further narrow the CPUs down.

However, we just did this discussion for BBML2 + SMMUv3 SVA. I think
the same argument holds. If someone is crazy enough to build a CPU
with CXLish support and uses an old core without DIC, IDC and S2FWB
then they are going to have a bunch of work to fix the SW to support
it. Right now we know of no system that exists like this..

Jason
