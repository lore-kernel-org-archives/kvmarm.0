Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3E1155753
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742339864; cv=fail; b=SSbIUQKBJtMQJ+M/uk3/i8NPfWmOPGowC2s3sdflXKAFyxFbMW9sbA+7S2R4wXmN+56xwnAAE6r4IJfsf40enFVBMWRD83FGtbxx6qzeF7HEWe5+zd0OAZncm+jwSl3PI3U6O4wOK75v5Aj9vMiGeaFDUvOfUjqFFchWmASPxi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742339864; c=relaxed/simple;
	bh=GSfp5OXrBLdVdavBjTGIz13/XlX9SY07NZcAvQs23BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QIgQYFg5DirJ0pJuuE2s17so6Qt2yQdFgc5ZrCSI4GP/845cqtHZ7t2CxU4Oft0T7NhtJbqHQm1+5mhgiK746zFlXwRQuLcB4YV20a/S1LKgkrwao4CHWmYVVUwseLStNVrgEqKkLVBYGRJVka7F59GClelBFR0KtO6kZwiSKp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y9Pxl2HV; arc=fail smtp.client-ip=40.107.95.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y9Pxl2HV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJr9oH85SQ2mHkh8O+gPt0/qb5VDBRZfJUstvY2YBTESRhviYhDMK3H+FvWVfvX7vRXTxRnDnYNzDDRdL4DYfDzKaa1Xpx9Jh59W4zGaQor6+6/4Ph4VU6PxYwGBDuT4LPXQW6A1a1HqTW/WyJDB2/6kFXZJh7TeRgkUCIXqkOD7Q6jsv1o9n1xIgSAJjKVoAzIJ8U7exOOb4C21cWARGsXmlcRIVuuH1p9xMmxw6Oq4cJXAjDUyxJOv5hwDqX3p58EzbCUVptqVH06LPOWkZZdhLc8GMrV+O26A1DJJcmWfE66I06VrIaDNbRL3vqIpwePdOv6EJQvI6Vi9HaGIrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lICPrZ01HdK5XR2UYIw/O25yJ7/AN8dolXEMiPCdEYM=;
 b=Qowc3r6B26b6SJJsawvFl1azqNClB3+9sgJJB5HWogZhgeIPxOCvZQSottxOGfrKh1rkqgLuDfHK1ZPfPOSR4eaTgYAymWeb67RYWtu+jR6O6jyF32AozzR8UMt2pSsPKZjgMuMDdLtEoTX2qlyxg5YAa06diqn77YDY9EiA/gRJ7Vgf36sbzZtpm3IMWgMWowgHvQVCkYFJrxS3SC0wabb/o+DA9zvqqTnFbHeuzVyxBw5lTK1F0zbJDBxvggNr/igpMyN18Q61HOHW6OWKSnw6Kmd2xiJ0Z0uHGFEBWkcZ/2nD7ppzlFKRlILlOgwvcGTcP9GH7lZoxcq24f58TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lICPrZ01HdK5XR2UYIw/O25yJ7/AN8dolXEMiPCdEYM=;
 b=Y9Pxl2HViTsWXhN4b+IC801cDZOBeCf2FFthjQTaPeqD7+RoCNDvDrxz0TByaZ4grc3UfBsdrT/geS97E7Inb7PDvxwpjVdWjcXh2ZA0/ifuWDPPCgwzm7UXtfH1HWflj6x3jZfXn7NKvI/eO7OmrKpMC0FuuAHEeyZq1o7vMsOvkF8f8zpZkJtIZNq/qXVS36rzSNQlbRPNIlJ/XCriPNrMfnvVnxTEoQuSGbZhLHC+3nOBJ13sPMOme839MMO1zuvBKmp1mR47cAU0xgYlj92wZ0llfgpkxUkmx4SuOhmZXrGm+VRJnKfJWyW8yN9nN/7zPqe3F0mKBeZr7IdY5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6463.namprd12.prod.outlook.com (2603:10b6:8:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 23:17:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Tue, 18 Mar 2025
 23:17:38 +0000
Date: Tue, 18 Mar 2025 20:17:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
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
Message-ID: <20250318231736.GE9311@nvidia.com>
References: <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJH38Em9XEx3U7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9nJH38Em9XEx3U7@arm.com>
X-ClientProxiedBy: BN9PR03CA0900.namprd03.prod.outlook.com
 (2603:10b6:408:13c::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6463:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dbab904-575e-40e9-40dd-08dd667312c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E7ul9AZvhbB7q3NOVX/y7iJ2eUJoPbCYmgVaER6+xqeS7zUroUcWJRPIttBP?=
 =?us-ascii?Q?XqfsiZQe+5LBz1RGbFJGBZxrV0TwqS2sqh9RpPdtLECpC8fzTx76xU7hO13f?=
 =?us-ascii?Q?YaJ/bPr4n6XWrQyemce1gkoAsri71LkUGI/qu0M2ZfAWkIXaNPobGebn2//E?=
 =?us-ascii?Q?sdbFYPUhEd5bPq6GOS3u113EjgZqDXjp42GRWAMPu66Jrm0XXF61fJUYxwr9?=
 =?us-ascii?Q?T9XYt09kYFTA5bT0F1sLGLRarOoZIL7A1GSl6kmmIW162wS06DmurQsxY6im?=
 =?us-ascii?Q?m3/mVKT2k7v9+Ya5zWyROvJSvuomHT9VxQtE1gNzxmRCfNDqW2ELZV1hvbRh?=
 =?us-ascii?Q?M2mV1wfiaujDEEOgxToIobTN/twKRDRfdmcnA29T9zhCCqKGl946gw2uAio9?=
 =?us-ascii?Q?32cm2E6bKd5R+sR16fkPccE4iWeaGx+GTh3iTe4yD64c+bqUt8zuxzJ+XZe+?=
 =?us-ascii?Q?sTRbWnslvsronFVQH52SPE5YHDOAsCd1MGabmDsimYWQGRfRmjSCrtpdLvrt?=
 =?us-ascii?Q?vIabkUVE+oEXQxJtTpvaNJ7O22fzL8uFiD1LPi9leMZGJu+DsuTQQ7sYvDag?=
 =?us-ascii?Q?JWspm1rYVFgo/4itRe/ca4iliwYz95W3M0Km/JUPtYTL6+4Flg8HmjrQdCv/?=
 =?us-ascii?Q?auDZJ/zLstQq02i/hFNMWXFcEh3OMK147rb3djxcQhf63EI4UXPP28g5+Fwg?=
 =?us-ascii?Q?/CRx9UijwZISGhblns8PQLW/D0oIeQ/Z5WFLcKWpryqxGbA63msiuZOfWvdy?=
 =?us-ascii?Q?qXPwIQ68cMqTbfI9tP7r9KU5mfQYXedGFAIvJ3EP/b5G5hnXd90xHOpRNBue?=
 =?us-ascii?Q?dreOt4RuqDIu4/G1AWGItAFaxkdAgGNUfMw6Tc0FQJ4wx3zfhrKIjh13AAly?=
 =?us-ascii?Q?R7XpxqLMeXH/iyogAbRl2AgthNvwe9fH00k6KavHSUrf2+RazDiiDum6X5ZE?=
 =?us-ascii?Q?1Po2av9PxwE/3BE/CjoJRw4diVcTDpyA7gBLZ78qKyVUjOjldFBwmI1ApqyW?=
 =?us-ascii?Q?9Uszxwb5jBIC61LsZjyPzPC/W6l7HXgGq5CkhgzjBqgGgEhbJP9kh6zPIcmY?=
 =?us-ascii?Q?TIAmu8BekHhyPCxMf+dVaPRqO0MOmMzpboPC97HxE94wFJQWMljWVOf0+R/q?=
 =?us-ascii?Q?ITtQW86vbINLWeq3uzLOOK3xPmwwwTH1toOGcwXuZhXiJIblEp484ClCpRuZ?=
 =?us-ascii?Q?3YtTsv9b4lHfu/qMdYP4Qd3pTY+mKEnq+gQhwaBD4Q+V41f7jTClgyz7tAkw?=
 =?us-ascii?Q?V+BMmuwLrqLVBusA1CqMUOS9g+CkhROXmgem5u/y9a8bcOxcosEl+WzE7rN9?=
 =?us-ascii?Q?9bkOBA+hIHIbzS5IfR/VRz4pAvMAp1TtoVv/uwvSa6zQ4V0DgI60CJjwAITS?=
 =?us-ascii?Q?EjSurUMrqGczG951VQZiUOdBNxIa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zvBbl7FyUOx/7V6U0w1oTiEO8iEnAGPjtV3PHRhr7FoziIGhGEOjMLl5VlgS?=
 =?us-ascii?Q?Ruh7URikIqqQRFYIahqrlpNGIc6FM+tvTszktJAdbHsaOWtuyzgmnbWuM/Y8?=
 =?us-ascii?Q?jgXtHyQABa90MlKTTjgzsGp43vkYLMvbd+/kd+iXUtVRoKYMPqvA56XwilyY?=
 =?us-ascii?Q?n/9B1fVM6AiAT8PBVpxFRuujp09ehYfgfI3caGkG1bYv7D4xDFx0LUH8xvsm?=
 =?us-ascii?Q?uUQ+F0ORwxaAEHXHa4Lzwv36IxAN3UkH1kE8dS6Jb+XtoeHYEr+sgpJ5Z4Hb?=
 =?us-ascii?Q?G3JipONDluUhkUPqBzNM0Y/ctcs/SG0o+w2yQxd+7km1aFPxvaetKxectrHZ?=
 =?us-ascii?Q?uALynx4Ki44tlRy1xgkeO+N/DwWb1y1bBlqzuDB9D0dN9JmPACeDMDt1aHj4?=
 =?us-ascii?Q?VZ+TtHPAAKIH7qwAp9QAHWHoZWQzePVGAgOOvNPTGsoOZH8xduJAqzjOaxuz?=
 =?us-ascii?Q?CPCc9Vc1AuJ9S75lLwd3gF8poFiOwXHE7RdcOWbOUkCUkBZUE2U0OKSAwzyQ?=
 =?us-ascii?Q?ikPW7zVQEPqy/zywiegRgReM3kvzHpI9ZBF3iS81FyS8xsetF+aE1640no+F?=
 =?us-ascii?Q?A/6qLnSNO8b73fqjbtSgkkUpEeQm4jWrc4caSWZYJ/PHD5LK2NVC4GOixWK8?=
 =?us-ascii?Q?WxBWL/RxIReFz2ImupW9xB8EVAGAeI5v5phnpiZx+LSBJODNGvY6esRl3nKG?=
 =?us-ascii?Q?4E1jBregZUxJuP1rT1dSW+2BzBzWbPkwuo/eXRyy5/z+6MmHNEwSWjBefIKg?=
 =?us-ascii?Q?3YMrrwpWNEdDV23sy3G9lSz0nTnnj5KlX8ROFpculXjNqLsV1YmCVwRZMODf?=
 =?us-ascii?Q?SEVAfLS8TXpzTFJPgTXwmiVeZ5c8XOt7HHlj+rkv2g+DqZ6jn+Zcr5GYkxPY?=
 =?us-ascii?Q?m8s6F/RQprpje65JVAC0EbDlL06HDf/BVG/PRJeCc/E8gCziCSD2QQ1vn0cT?=
 =?us-ascii?Q?+kkLLCHiHI+99ZGOYGiqvyQOLoKPT2tUAGMj936Dg2aV2bm+MGXY2DdZlseB?=
 =?us-ascii?Q?P/u9C+FQlC+WGXtYKbh1xQR3T8r/20hFWTAIyx/Ux0Y3jy6rfAZdCAyRFq5i?=
 =?us-ascii?Q?G4MIEO9lwzvsSmmBraXxHZMvbJCB8uu+BvlYJIOxpVyYSxzU1G2+bx7uazCr?=
 =?us-ascii?Q?RHBXDzGddke0/WHZWlzTboQNWRqZoxazf71XXBjxpsnZDmnqUbcZiKShWW7J?=
 =?us-ascii?Q?xIBBdRZsOADdTvZm7RN1aHuSA04kB2NiRuS9rMHSe7hEsWWQlvywPxzfTjyC?=
 =?us-ascii?Q?NFxp+mfCm0nVwrfZeOJ9MiP/lCo0fhfNv/FsSZ/z4Nal6NN3uurIyvNpHqj7?=
 =?us-ascii?Q?WKOIHS5G5TiNSU8kMGNg55aOaMLxpcE9WdVAZCA8cZqyt7FIqX0hsK6xih0L?=
 =?us-ascii?Q?31FmXHp8ehM5lSmiNnJAz7mSTmAWu/w9nFTSqe9tP/G9s6M8fNq7XZez6/w4?=
 =?us-ascii?Q?EgT4IWmGoCJM5Zj21RVqwXnaGp9zhlFePy9pz8v2WjlNvN+/8EH2RYkrlLCI?=
 =?us-ascii?Q?tpR/pMKTq9UurTGfPrdE+tDYKIWi7Z7fcAraYk59FjyBCInOZqm+LTOSUZKJ?=
 =?us-ascii?Q?jtDCwMBc36wGI0Qhw+0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbab904-575e-40e9-40dd-08dd667312c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 23:17:38.0705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27TCMWkuWhnEW0j/wEJrtqR16OXW+oadeI5U7sZ5H8iBHA6dtXmiUvpdT6HstF+6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6463

On Tue, Mar 18, 2025 at 07:27:27PM +0000, Catalin Marinas wrote:

> Thinking some more about a KVM capability that the VMM can check, I'm
> not sure what it can do with this. The VMM simply maps something from a
> device and cannot probe the cacheability 

KVM is mirroring the MM's PTEs to the S2's PTEs.

You can think about this differently - KVM currently has a little bug
where the MM's PTE's can say cachable but KVM will mirror it to a S2
PTE that is forced non-cachable. KVM will not do any cache flushing to
make this safe.

Fundamentally that discrepancy is what is being addressed
here. Cachable PTEs in the MM should be mirrored to cachable PTEs in
the S2.

That the issue only arises with non-struct page memory is just part of
the triggering condition..

> I assume with the cacheable pfn mapping, the whole range covered by the
> vma is entirely safe to be mapped as such in user space.

Yes

Jason
