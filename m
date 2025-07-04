Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC45307AE4
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751636719; cv=fail; b=fDvaZa4dFhVJTKKuidBgu2H2OCCWy3BDJERaXHd0Mx+ddvQ3fcsC6vdnlPVSQLxvgscgbi5KDHLAhBVnrQ637hb0kE0R71v81KbgUuXYu2r75b0hObAJaKWDx/Yau3tDU3AhKvxgPgV/QK5cI485y7mQQ6stnwkjBiUe7aw6uX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751636719; c=relaxed/simple;
	bh=ommLjHfQbtkWfv2yg3iX9LoVQyRFr1MQoP5aP1IJiDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dd0ff9P1L6kjOxiZMNgVWec3uabFglmkwesqVGzcEpv8tTioCn/tQZDvoF5UJUKBwXMR/om1n8UP6+xffko4W4lVL8hkNq+6Ekv+hnhlQGSZsN3b2dosnRHHsxgpQiLnAvicClgMykY9A15VqyXH7Qqk3vS2wkImUubk4M6A2uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DKLLIzpy; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DKLLIzpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ST74v9PSGCLDDgN/xIEFKDu0a3gC8dj0csW3WCeADcml8ZPqoUb0YPQh5jXPlsvf124Ws1I+Ti+f2FdEKa+BgXZtOZkTS4NIjkXrUdUWdHYo21j3Jiqw0LnO+HzB9zNrKyuCdclYqRlK9MSx4E8KH6ujvp9QSLG7/faoYlf1qCvVwQk0yNYLcXpOccAcITf//4N2o6zKe0Ixlv00LbyCf2WV6lewsMVgRDZu6gpQOgY8Qt2d3Twy+TjwivFYfS+gCvD+X01XtIqhygyWPNII61/bk4AjFmyFbQoAI87WpDETbqlsgRJlYP3KZEVTjoFu/YCfUJMytgYW0dkOm60s0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4F59YWI1xQnJ1GA0ZJANTiDOjotzWCUaeoshEf0/MZc=;
 b=rQMPgLj4aSC5EKJlp1V6Uz0ttt/cXqtPjr1Lu9oot/7AHJueDyhRAYbpY0+8/8gPKqTkikkQeBlo1NXKg2rUELKXSMYfH9gwoyB5UlMi+WcUllKkqcV3QDjmgQxzb6e5flZc0/AJIieF2RYptRaSIJZiXpWu1hHGPbZ01nxzSnBRjm+IdgdXYZD9e91z+wgR1DWK41SCD5MHCN01tbBBM1rqUhSjS7Z8cDD4Ccbh2H8C8v8lAlq+pc0TLns5SJS+WNHBdHp1xZ0HjJUK6ftJTgfnsU868RwzStndwwMZlYa8jyXkdF/5guo/Lmmjx2iCCX05KEZOEmKUa+ooFG31Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F59YWI1xQnJ1GA0ZJANTiDOjotzWCUaeoshEf0/MZc=;
 b=DKLLIzpyZlgn6IBN+VKK2GNH7n4vQxhqC97+KtCMz5GahoauZHly86xOLc9r+HSf9WsgnOENBs5VUtCP27aja0g9bfpO3EKC33mqgbghxQgVDrVgQjeWjZwp0J11ChuTC2v0bFZG0dgh3DACEdyfYfFLxG1C+Vy2bd73cLamIbs1DRcyvAzBfDu8w9ldfFQ5Z3fsIsXU5M/h8pkUBzrn5vdKlL2GokqOGBDQsWG3deizIUa6b26Fia8iNOeCNdhuHn5GLptrTjZFjK7Nv0QvJrOd59dtnwOOXBU4XogK5KsRCbf2gMAJE50ITJHwPKerbmjzK7s0xgTjCGIl7e6rLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF183341E5B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 4 Jul
 2025 13:45:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 13:45:14 +0000
Date: Fri, 4 Jul 2025 10:45:12 -0300
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
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <20250704134512.GF1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621042111.3992-4-ankita@nvidia.com>
X-ClientProxiedBy: BYAPR06CA0057.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF183341E5B:EE_
X-MS-Office365-Filtering-Correlation-Id: 808c0c4f-378c-4846-a6ea-08ddbb010121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oue9dZXKASh/eOcZKK+PSOXDDxvs//vDjGZL80pzon9vHGb9LLJC47UeMTJk?=
 =?us-ascii?Q?08ROF32CPuHQVOihmwvOK2hGincUo/eeD8+lPafXw0lmxU6/bazqVZKtslKK?=
 =?us-ascii?Q?RnBRVnZWus2G2G/5CJsu4o1dQTlp85CoCgx1F0y8yORAmiiGwSMJFb3dUJ6C?=
 =?us-ascii?Q?GDR39u9A6BbBYFHfEXwTnt9Z1OQjqHSFdB9Cmy4z1EuDxlVOnVYSzXyAxL2f?=
 =?us-ascii?Q?0z6Yd/itbwQ3M+Alvvu7anGHKb0K7sWGiwyBKv2avFgj1ok6q3wTndN6kFjT?=
 =?us-ascii?Q?yWYfCbJv+SCJJ+z6VbwxBjSJbzQXNQk8rzqx6IGJ9cVtiBPrsuOHpW2+1l+k?=
 =?us-ascii?Q?pbSmfPwRo7dBcxnZmCk1Pe5Zn4whX7GNcxG/fKcenidFbhuHMvvy/aSsRk9P?=
 =?us-ascii?Q?2UhJ4TvIr3bIPD6jRER6iV0T2V9B5xR5W9RFtx13XY073YlK1QFsfQmkvgyi?=
 =?us-ascii?Q?jyiCyGFMd0KoLDxzMgQEFvwAQY1HwVV7VI1k7RnZcLEzBKleaeO9INVWhdDM?=
 =?us-ascii?Q?0HooZyBn1D/tF3X6RPLOqIQpNvVS5uqP3hJhnl2HkvVoh8akKAD0BxRW5NqE?=
 =?us-ascii?Q?EWC46qxalnRmAKZ2YsWZ+tdvrMtuL1U/7UJV03mye5xqCnM6fXosL+wp2zDi?=
 =?us-ascii?Q?JBgIf2Jekh9r4/V+kkU3m0/+duPycB+YKLTVmFXPG9YB/lldUgwe7XAoqDqc?=
 =?us-ascii?Q?wX2c2yIXubabL6xWyd2iZqgSFX9MGE86uFgzb4ZligId6WrEQhVhM1h7IGkP?=
 =?us-ascii?Q?lkFLwAYPBmVTcJKLGc1WBJuPjsTbTXRBlsjHIkCIJUq4aYdadHa5cURo5tor?=
 =?us-ascii?Q?tchbtEL8bAJON6O+aTYwJM0W5sEG+o00KO36Ks63OGIyqNvBavGx6d4Io8yo?=
 =?us-ascii?Q?0ZI/1dFvpC4nL8lz+Y/fd1tFBpX/eESPpqu/UrcanHjsNSyYBfZtlV5vA+CK?=
 =?us-ascii?Q?Ve06n/XhrfYfXE7LCF9mJVjWXokYkgy8qbdHcg0HbNbRCwiYbgVyVjbX18gp?=
 =?us-ascii?Q?3M9lLj8KbekXBupdO5usw/uNyD+UvZtjVxPsNpK8DAHRSW5AG6dSA0q7tM/L?=
 =?us-ascii?Q?l+erdhP96P6Jz30dx6TcPMFDO7EDaWrtB0/1xZ1x+Ew12H3SQLT1FMHTP6RG?=
 =?us-ascii?Q?cD/ny2aJ8pPN54LEoCWxqMXv2JfV878Tn2djb+wVR2/AC8xgI5epbGWeomPr?=
 =?us-ascii?Q?UsQ2Ehe4lCmlCBUym4DEsW85cn9NVGbCRPH63/6jNBMRuX+A6Sp/yx0mlUSO?=
 =?us-ascii?Q?2lCEwtB3CqGb9t/BC/MqNTb82UCqkD7Zp98HAJsacW9+ofcV+uahuGUiMltO?=
 =?us-ascii?Q?CLEY+m0VC5zfuxJhV9RWUb2rDRrxg8NM/Ov9vSzBfw/lk0QkfzoQCD7bMVKy?=
 =?us-ascii?Q?35aDTz3aMVME8hhdgnxTD9IwF5RJkJ1BBeCtQGx2jphJ8SZ6HtxLk1MjI7uS?=
 =?us-ascii?Q?Wk40zmZhDDo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BBVThXbXYXgZUnndd9n/A8J5IzanKZACsoCLix2D0CgTyGE2kBmAD/bTbbct?=
 =?us-ascii?Q?CTBHwUkOpNojPpvoUVbdK4qofrzw5K7B36XMRenyErSkZt4cmgcSBSV820y9?=
 =?us-ascii?Q?2hxmhs+I64wfpTXb6UGDTevZXlgkBtHP36HNHFOWPc44gn7iCFqcSWPuvnSW?=
 =?us-ascii?Q?35sUlx6BVxls9NRauY/4VkTo8yYncHq08aYM9J9IgEIl/neO3VCkMr/XIysE?=
 =?us-ascii?Q?UCFWJZYPDzEjGTsQFv6GBrPm6Ukb0RJvzzVKdUVpqVbDl8+JwacYbankmwEr?=
 =?us-ascii?Q?envdYc5pzlNWtiY84yWQiODB8jRupfQ0+CA4JHKZzSsRtDPbOSiudkT/J7ZB?=
 =?us-ascii?Q?g6E4RAfs7zqtn+Qjvcv5La8ZAlbIdgQRR9Y+KJ+HkaLbudogFjyFZcfax/oA?=
 =?us-ascii?Q?O52H2O3Lyz6bBYxoeVkyNA0xkCEXG8emcKE6OLfHXBP1RLY4ike2MxrWBOd9?=
 =?us-ascii?Q?9SZZPZJzp+RoXQ5rMZy+cd4rGLqIWkdKDaD88LIOZ0PCzIEgBp4RTeWNJSUa?=
 =?us-ascii?Q?kPun0a4wyZJw7l96/qBuZgfXYPPo01gNcyVb1TZ04bTEHcR1t/UWbZFEjnxa?=
 =?us-ascii?Q?r29tTHyWwDVEAi3A3TgeI9HnGllA5cExCTTo3x9dnW9RgFmraVSWkWkb2WH6?=
 =?us-ascii?Q?wGGeFgy2Y3wMc+I9tlj10dTdfl7rh8h4zQ6nlrBKPTD73+4DqYkb1+GfrwqB?=
 =?us-ascii?Q?AAjcX+3tW2E3vejGCxfZq9KbPTVWLs1rLaZVzcj4E3swqSYcJEGMP3X/1TFR?=
 =?us-ascii?Q?njR2fUn0CsVlmyDZKB9boKWPdy3NGyTyObreVXRJ9OAHEKSm+or5eOto8Juz?=
 =?us-ascii?Q?Tp8Tv1QF0asuGrt1jQznh50Pgvq3iCYa+LbXKssacwzIJiQwRIYFSN77G0TI?=
 =?us-ascii?Q?ZvFrnqvYEe4+90axlPq0ro453uxn4GL3DnY/U+NCe/6389Rvb0t8b7ww45tk?=
 =?us-ascii?Q?wyZw13kFvx5ETtc2sShWBef2dVVAig2LMNcKYFM/gMSX+OHGV2RCMioYbqt+?=
 =?us-ascii?Q?u7/NOfup9b7l1l+M4BXSUVPZncHhUi3bHdcSehBoDGspfE8ec2TAgXxKZgmY?=
 =?us-ascii?Q?YbzaHPMqE1Vyq1joyEMqTX4McG4bZAJ9jNOzNJgxibvDqUakQrh9b+MiB9vU?=
 =?us-ascii?Q?Ci5nxo2tlS7JYoSIqcfuD4iD/2R5mBokb1EAfGVXQNCT+aJpkoiDx2lAeiuj?=
 =?us-ascii?Q?30kuWIeV84779MPWxdZB+BTVCHa1s8L0lc5Bpe48SJzM0SBX+uu6r18LKHxw?=
 =?us-ascii?Q?e/nVU04XyKd+BkS9oUwf0oqLyAIvehCx07MQh5nE0Wt7fqxGNd8VqHbeJZLO?=
 =?us-ascii?Q?FB9x0U+j7Yw3BCf16ZHCPeHYAf19+e+i4pJ24/lu+8WWVugrxUjtMawlfwV/?=
 =?us-ascii?Q?/57fn+ddLuk4H4l+OolrcEddk2IrUyiA6aYbhsjEIY8vfLAYOpbsJyuQ3ZSS?=
 =?us-ascii?Q?FLmzBR3HRF0pnAP3xDjS5yZJC1fSO9cVxpQhrqQ77OO/5A76UZpjTYFfIw3k?=
 =?us-ascii?Q?yHp9Lmu6IMNiOwqsx4T2/ovKfQLq9jbBcP/lMvoT7OqY0+d/ofNayguxVvSi?=
 =?us-ascii?Q?cvxeWnCLAMPerl/E+Fcr4rNLP0ajh8ApJv5PdYEx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808c0c4f-378c-4846-a6ea-08ddbb010121
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 13:45:14.8342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00QPFaTGPqlSu77qwELFGRdwFCpQLAVr3bEJsCcTHLmpmrIX32gb+8V2BeYJNJtB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF183341E5B

On Sat, Jun 21, 2025 at 04:21:08AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Fixes a security bug due to mismatched attributes between S1 and
> S2 mapping.
> 
> Currently, it is possible for a region to be cacheable in the userspace
> VMA, but mapped non cached in S2. This creates a potential issue where
> the VMM may sanitize cacheable memory across VMs using cacheable stores,
> ensuring it is zeroed. However, if KVM subsequently assigns this memory
> to a VM as uncached, the VM could end up accessing stale, non-zeroed data
> from a previous VM, leading to unintended data exposure. This is a security
> risk.
> 
> Block such mismatch attributes case by returning EINVAL when userspace
> try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.
> 
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Sean Christopherson <seanjc@google.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/kvm/mmu.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)

Looks straightforward now

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
