Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E717E303DED
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751636603; cv=fail; b=L4a0f6JpPMrNtzs5WZGRsed7ZBbiMpP6oORVLRFCl+25npgGATpMIII5gkYHn4xf3ZqHa2gKhdZ197in7ERJhqjrwbRVkyM09cM1ESKJkWw1RWAs7Q5eZXmoEwSa7k+dj7SNDa1Ylm3vTRvI6Ej2+4LB8qcNZ3jKd4P/KEh+uzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751636603; c=relaxed/simple;
	bh=QKi77sLaOk2tFEidLdFVz6pVOqS9Jq5rg44eAiXQfys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MKgIEhicDIu0T/poGagxxNcvOfypLf18piPtsOPu7ZT779Aqp6CLAygo8UuJjJFwInaj94J7lWWLGWHh/05b5BLouDioTCQFo/AjoeubuAOK5dkCHHc9hfCqP1zlNYiGc4eX9YHJERLgBqOaNOuEjDzDyq9gcWrG/eXNr+da0/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9rvoK4N; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9rvoK4N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWrfcY8LGq2PHG+1raMnYKw0q4tDbg3PDYA+SNPfwCWSY+jBacM+ACSL+yL1WGEVC8oZmdYUfXSSpxoJPJoAfnm3a3oTck3ww/J8+3mb/s0XaBtH+SsE9jurBynhI89EGLkhahetu/MUdnAuVFWcwIZM2QXZNS1KgtsAqn8/5dNGkwqOz8j13Oc2pcedjoG49z6LHrgHgDXxQJOl/WDD3ZsDdoqbnLNXQTVQsFMlBNVtGvLwZy//nKW5a5PX9LWOQCqCAB7IMVdnq9yvyf8fBw5M/l46v9Gb23H6Z7XjykU8oLmLCQwTNaov40Og2EOLi17KITrfT4diFf+ReY08zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdGrHKDNpR4tDbbw1GYnxWHteCJ/TKd7eCw0psRkUsU=;
 b=qeAkUbc6MEpPhr6WAa4G7qrDvtW84FZPiydwU+oDA+0z5yshfb/+HclDjGEULNbDPW68ejNAfg30t491/sfUJ53b1GVXThuWL0XwMeSWklA6ULTwR1YiLAGgCWxuqQRKe7BnxWKpDt7NEYplOA3Dy8cBcwjBJKeHu+Lct2iGnZNN8hrDlEsbSVyJxSRAdJKeMqURJ0GmTxXd2PPUySm0w/YfiyVphSj076Rf5G44MHN/NhgOfu+bhYICyngnFKOghSi5TdCLjBLdtYWGzSX3Yd3Z5vSAh9er2fem3MOy60Ws9yJHXXkVhu8vH026BYa4U27auxzXaO3nAhI+ZUotkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdGrHKDNpR4tDbbw1GYnxWHteCJ/TKd7eCw0psRkUsU=;
 b=D9rvoK4NDvsq8tcT0BGUrJi8DcfG5fGnpwBbalzn0TJIkYJqq+5aVOOcW1GO6Q03snUSNA6ArM2ybaq98LP9QQW8aLrxFAk7z6ZIJm87JqXmL6nus0WTQ+qnc5REq+UyLDjrF76NeBJKc1IR0NdFYKStPIhEqOVahOT7GbOudLOXE62Ja1MRSiYic1t4HpVUF1cQ4fyP0Itk8xCB+H3BvqxPwPubwAG38zum0N4siL/b/yDT4snd7QOp7F1Q1Icpw3+QV6vYG2WAcWy1m6UMoAGPT1nHuDUD6y6i6GLKXwWtQ/2KeZpKTUtOh9xRPCEa0gsAOXVqhFoZRvzIYGeYAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF183341E5B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 4 Jul
 2025 13:43:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 13:43:10 +0000
Date: Fri, 4 Jul 2025 10:43:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	ddutile@redhat.com, seanjc@google.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, kjaju@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
	dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	tabba@google.com, qperret@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v9 2/6] KVM: arm64: Update the check to detect device
 memory
Message-ID: <20250704134307.GD1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-3-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621042111.3992-3-ankita@nvidia.com>
X-ClientProxiedBy: BYAPR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:40::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF183341E5B:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fcd4b28-dfa7-4718-7be2-08ddbb00b6f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WJMAXAxbwOEY/iFUVc3L5W+EqhtkzVigAiPNBaUjXSeOYi8PyKd5B5LwV5Bw?=
 =?us-ascii?Q?JtsckEM2tI81o9dSp+mGe1jULWs2V8hSKkp6DgyWO7dmnb8q1u76+WZ4NEA9?=
 =?us-ascii?Q?D4W+hotsiuDv4tWZE75ynsxw0GNW6pCGD/CTbEVt7tD77tOnO1qGAa7xBjf/?=
 =?us-ascii?Q?pL3qOFf0CApGjE0Rh1eaz1tfnDwfLMPUOo3QnVwyAr2xZNzVGSrqVJRLDjwf?=
 =?us-ascii?Q?Yu59I9cLY5gB8ePsAbaS/mxZMZRY7JD/S/OmsT18feADaM3l9c1v71YnteJk?=
 =?us-ascii?Q?HT/x8BH03l/ip3vEbrvh2UcGkVbINzpT2m7KdE66dK5uRr4/9rMX1f0VtK28?=
 =?us-ascii?Q?qqfq2jT6j2yGEl1k2GwhXJKNyVuskdeWpeoDUrlM9E+Ih3kOPPNQJ5eF1iMH?=
 =?us-ascii?Q?Ofeo6A75bvsR76I3/uftoqDw0JLrJtCtjy053KB/dEHRD/orjN+eAx7f8IjE?=
 =?us-ascii?Q?4I0ZBp8z8vHYhG5RFVrKki28Yjx7dD8FeQkRdya1TEPVLSMy6jRxLuRsni+F?=
 =?us-ascii?Q?yckexBaGDiGwfJNBy+dolY/7WCaZVEcQO4jHmCggbGLqIrwqQZFdntfUasM/?=
 =?us-ascii?Q?jAjDS204mbUgTuDoY1H8nlsSE11893m3JrUnJQ0z3vYxErjHuzTi1oT7kr4+?=
 =?us-ascii?Q?DTuuzA9ZMI5PMEDeMRCbV+QGxHLGb1IeoMl3DAhVwZRQb52y9G5rIiQCRjRk?=
 =?us-ascii?Q?yhv1BEadBWwxDaOrk6ZefeNiUzwt7BkkNPJF+7YoYoBHLOPD1hjsgrjWSh6T?=
 =?us-ascii?Q?kIoj7JSEKEhcPBKSaZ3ZR/Xo9gWtmFHHSXHsv/YMT5SbTm/P1PWLROI6QBjL?=
 =?us-ascii?Q?A+trMeiInOP0yZ441wSF/RuFdlAWJqw1bc2Hmf+su5/wjq9ZAzbIzhbUrT7l?=
 =?us-ascii?Q?zIHW8XFotbZgulCIU7V9XtbZ1M9+J91cCuD5+0flwwJ6BNLl/kGrHwqmKQlL?=
 =?us-ascii?Q?HchBAR9Lw0hqdX5YMLwvNAsvu1tDZgUPFGS0jLxkZWcLIAa/tQ+U7b1JKxxZ?=
 =?us-ascii?Q?381ykf+1COnGwW8m5bJZDKPYn2kxmFFMvw9CU4Zc8JT1cTtG5ZIZ/wE31s1V?=
 =?us-ascii?Q?usI/jJe2ld0DhG2H5kWBIs/dF/odLqRJIbY9NRzeHGaamKD4Us1wJeNIjpBJ?=
 =?us-ascii?Q?Fxm9g6D8da9H5jlXmi6isvy5FhGiy0xgqF3yNE07WMmMpqaQOFU5Q6U3YHaN?=
 =?us-ascii?Q?oPEfDjUsfDBEw/d8ZXGEqRj0feby/i+a0BBJPjnpHZ4caFhyyTkTaXhzcPra?=
 =?us-ascii?Q?VzNCQUgy8GT3BfrDvkyf0YivXEbwO30tpn+l8sxgX/ByDGZVvKHFrNmgkkkO?=
 =?us-ascii?Q?922cxrl9YppFdtl5RPsW6OEKo+73HNIOYWQisaW6CYMNF1HYhUMEEjD1IUzE?=
 =?us-ascii?Q?vGrRu3258VwyvNi8svxQN3Eb30jAjqfdbhMlZPbzfY8IhZ3u0McYqfjlYB2p?=
 =?us-ascii?Q?35aDYL/Da1c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sh0BdnHEvPnKYw7zEpPLkrC8FnPekqzDE3ZY7zitpEfAwpVwLzP5lEe4fHgP?=
 =?us-ascii?Q?y0EQ0XMg2eOV8iqTu74ixpwsi9b6EaEJnuAqgICdI+to8n0uVGxHA6xOXOXS?=
 =?us-ascii?Q?qm33vzehJyr4lbz9x86SvHiRLgS4iS3idNhqyfxedn7UCT/oe5PFV5X9lJu0?=
 =?us-ascii?Q?/kPeBghh9cHmXP23iqp3wh5MWnaW7QejTTGVlL17ML32+YwqZPaaf0OinZMO?=
 =?us-ascii?Q?gs+mlmhMiHDiCQOl/xVTQpVNYOoS9kJUQPYynEwcmCT02l6qXde80l1flUo3?=
 =?us-ascii?Q?/B9rG0TnWZS6Ra8qMHusrNWTQ+4JnTgmU0khNIUqDtGa+S2sS8VcuD6wLM73?=
 =?us-ascii?Q?gQ0MrPv8+wxDsaRk2yAPAwmPQZyVuTNwfZiQSHRljiZS63Ysp6FuYY7Sr5GI?=
 =?us-ascii?Q?Mn74LkX1Xkx/mYfISq9kBndVM9aMCeD7GzMpJbXwzBgmVJNo42LnrD/Vu+g6?=
 =?us-ascii?Q?olEoqMJGPmFqGtcteygBWzJYWV2JpdIGg82apOK5pCLu0qijLe4nJ+NDEF9w?=
 =?us-ascii?Q?ivrNmIiNABBu9Vo+2ITdDB3kRpSvQFxteC7deDxk71lkctl5ZbgCyGCL/rI8?=
 =?us-ascii?Q?Jd0jc0/lSs94gLIr/AHrr0aceYKY8mTq0ztq7xrpLVFt/Srm7sLnlhT7i/rM?=
 =?us-ascii?Q?QbohFFcn3PHcbQ8qkAaJUReF1mJDRiICRJpPjg5Mr37V0op/8/ni5Jmi2I4M?=
 =?us-ascii?Q?WAXyZCjrM1/oPeAw4CSkB3/MFtThsa8Mb7dl4QStjvsgznyLsoWdz6L4LyBj?=
 =?us-ascii?Q?MWIg3AzLgN9PxSv0cIVramosFllLg6J4OsWYRs8omhZHQyyuKUuSdx7smmJF?=
 =?us-ascii?Q?f5Unpl/xdths9L7R88RxkA7STKQSNF9F4Y1+SPicS7xCqqhsv+XoD3KUKJJi?=
 =?us-ascii?Q?eC9s+Rm/sRJJvlUhp7Mftweg2PM/LHa8Hc77jz6quf9oyszKNWepMWf7YOcN?=
 =?us-ascii?Q?bwmmwZ5X36UyHLPHvkZknhNZLgOhEEb4wQTmdg8DECQpWCSEm3dGeRtUSr2h?=
 =?us-ascii?Q?st+7ux1gxJoYZEiUB5UoakzpW6Jj8fKRjOXkaxYFvEzQZPUjExSuIyhTyM2C?=
 =?us-ascii?Q?gb3lzs2ElacUd0Zo/AUiv+6S/gWh45AbbnuGZh4EcGQCqzuDFJShfebEDW0+?=
 =?us-ascii?Q?+rrOHKH7cttnEUB8V5ZCcKxsvvwwrsTJhryV7eg6jUUQTaQtMfIOlJnzOWrV?=
 =?us-ascii?Q?UUm5M0tDUmuMbYtF2ndjs4PqBt4BCNYVLPqb1awuTpiUnRNyXg/DzwVvm0i/?=
 =?us-ascii?Q?hqI9izZxh0mufRNCeAz1Po/f647puHMUDj1m6DnZ40VbMlt9I0ZbeIBnB4Y0?=
 =?us-ascii?Q?K6Ibgl347re+KbGdfWVFqQq+nUTxMi6/V487CxRnsKZ45EjbID7qRw1WAGVd?=
 =?us-ascii?Q?95r4kNzMydsN5Pm5XtgRXZZ2+EeEZBay1Voufj8cxSGaU5zGYVym0m/tTUiK?=
 =?us-ascii?Q?EQUSzwTxcVJ4ZK6lEQ08OCJ7uIayQjb2rM+PsEbS6PWSXwgjA4XYRhGe80QH?=
 =?us-ascii?Q?RRYmKz72F+VEfvYOyumtYP6rNTcnsFBOJZk3QWx1jGkwXoJaVqCQHof68Is7?=
 =?us-ascii?Q?GFlBkwpZBRZgau/91kIvk0NqOoBkVjGF1ZWc0VlP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fcd4b28-dfa7-4718-7be2-08ddbb00b6f2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 13:43:10.3938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1l9zYml2yarEjgeYm2ZrG8ugHgkQ+xpQpVeTkMOqz/o9bK2n0pt96ri1//QoCOl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF183341E5B

On Sat, Jun 21, 2025 at 04:21:07AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, the kvm_is_device_pfn() detects if the memory is kernel
> mapped through pfn_is_map_memory. It thus implies whether KVM can
> use Cache Maintenance Operations (CMOs) on that PFN. It is a bit
> of a misnomer as it does not necessarily detect whether a PFN
> is for a device memory. Moreover, the function is only used at
> one place.
> 
> It would be better to directly call pfn_is_map_memory. Moreover
> we should restrict this call to VM_PFNMAP or VM_MIXEDMAP. Otherwise
> the VMA has struct pages in it and mapped in the kernel VA.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/kvm/mmu.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Non PFMAP or MIXEDMAP VMA's must always contain normal pages which are
struct page backed, have KVA's and are cachable.

So we should always be able to go from phys to KVA to do a CMO.

Jason
