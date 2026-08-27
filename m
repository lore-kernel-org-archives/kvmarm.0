Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368894307A0;
	Thu, 27 Aug 2026 11:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787831593; cv=fail; b=uR2FkymUK5VMp8vimN7phguv8/Dju4APRkunesIiZIej6ZuloElCLEFT0tIYPI28PCCsHgMhW4TZD9jQd9bbLYETrardbM7HeroLyF9/xbgdCExWys3Ca2MnlpD4sIc5MtQJgdhCNW3W8zxo9ejjjsj2+ksJcN9ECWRQGjC8Wk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787831593; c=relaxed/simple;
	bh=feChhrwfa9ghFaJps4f0lvPrp1Fej52FKUPe85kStvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lkG4gqoTMk0Vpvz4rqbLkwQL+i5PJDPZSUupgIBNVn5mYaJlxRWJSj10O4sn/7ZVyYYHFvpUr4XyIv7cfIp+fTGRacdSNR2Pu9ZZF9onf7YrLNwghCG0O76JbhLV+AUJUjwYvpTo90DsLLSrU48LIlS4dwlgwL28ixVzYgOYLCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sIQMXh0s; arc=fail smtp.client-ip=40.107.209.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sIQMXh0s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lS1xDxJYdconieEJWrCFk3Wo2485/xRmDZjlDRqifdzwx1Jej10lnSPxeOZa2LsgU5D/PzYl9pNCy3SbzZGPXotwduKD9typWIBntVr3M4cg1c2xd3HGsJi/9FgE/U3eTymlkdxMKBKdAFZoxDlwNkUnLwUok/7CbjYXZpg1JnX7jDlZeA0R5WAggBMPv5p8dhkhFfCmrjALAdoNocfh10K7oU9brHyZCtEEhSe86w8rTM79GyMBzI9yhVz7FuseNr75ToAGSETlx502Q1Xl7vkbDnQFARWPbUu0OWa22iVBSYupxl9i04S5tspDEWLm/s+rLndkTV1DnqRL6Lq5zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hyh+KYKnE0BhQOXQyzfXMIgHl8Q9ekBp0P0Eubn8uw=;
 b=Me5n6QdpggguKJBkwwHqfrrX+RTnRnk3v5PNZOrsxsKeqwA3/Msa4HruD5hGlRIudyQ9HjHlo/Xzk6VnfzcKH8huZnEb6HEc+KhOMkiM17Nwq09P7U+uVMR9C2MUs2R1tqOYkyiF43TQiI5IqDsU3eFs5Itj5uSLxPWNt969LxdMMBszE3Av7D759ukrAZCBvQ0iYkQQJDiJeM3DwMuU1jeRW10uqJLJpMzDiFtmnTZbAsyeE1iHJkNV4RdqFYh800HI3Jb8eJ1t8uoaRovG+MTcOKRD19gd0buF5keGgoh5hbTZ6MFyWjIK1GB7Mq6lqvMYTo22+IixtaLJ89CIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hyh+KYKnE0BhQOXQyzfXMIgHl8Q9ekBp0P0Eubn8uw=;
 b=sIQMXh0sZMSoRispAylZq4/tAiStpY0GRoxNMeAvXkQ0LBDF+Jry4ywlV6MJGH6GxWHfUQ3lgnUaLskEajDWzSIzWhvEVB86tBQoxQC2PnWkReBytqc75eZk0UezaSTaXEG1t9RR+Ybj6dWgXlUhZNPxCd1wH/OrDPfusAWVD4Cumd4+ehgy7Asm3UXkDw+yz+VXhngyOJdy7P2B5UqjuqMNwOt8xJEEg5NPhZvdoa1Fzm0yz/SoEncoLmh5xJz8SuUe+A0+bBtgsdsZaLaaihAMd2Er9Q4PhdhSsCsklqr2uiaIUB5JWw8ggR96XvJutrMXWo1qQDmZpmRq7eG9RA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 11:53:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 11:53:07 +0000
Date: Thu, 27 Aug 2026 08:53:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 23/24] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <20260827115306.GP3325090@nvidia.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-24-smostafa@google.com>
 <178769159057.3356902.13161185498161727294.b4-review@b4>
 <ao6puxVSNsLC8aql@google.com>
 <20260826123831.GA3667628@nvidia.com>
 <apALwh7sRMsn7WS-@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apALwh7sRMsn7WS-@google.com>
X-ClientProxiedBy: BN9PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:408:f7::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: d61cc493-315b-46d0-b069-08df0431c2b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|5023799004|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IVJHSbmGMv3FeAa8obfAJlxiXAcdRvnejIQUEnchSYTYHqXqq2J2WY4VE3Yf2XhwAX/T2v6zFxFSIJmLFJInl3SgdTfsqSRpq6cJ4lVOhASUWTWTKscF2fBAojp6UfR4XNMBGdpEAtmo6XVJWvYcD8l9Benx3UBP+qlzV2JtkHwNYJG/+fjuWmgGQ1FYzSGPR9r3SEWmuhFWgqT2Nbn8/7s6rGO9Sdxj2SDn7x1ri+zx0f3ue4jd889PfkCE9oGHAM2oovBQoUtymr6mrrjoea5pvrRQGHgMZSYtdIjLWv1Do7SuBA9y9i3dpxHfZ3ElN+aVPYzEyvPak0LdHrIwkIABVW3m66uiCP6StVKxAwuvk8PSP3NlmZzsMNplLyQOvp/W6u5TQTKYM5gLTHIG+aajtOxjjp+qXZXu0/MSZH19LhkTHqo9EgEoEqLZvuK36tT2Lu1GXa7LYqq5PYZXB+qto4tmZL/1ufQk2HPQe9fyF9vntpKAb7tDF3XWy7bpuNA8lYCADDUeYihlFPJ1fxiSW6VsFxkslos/leNfv0zS0YMLrWhE68pNs5dlwqnX7qBwaajGm63R8kvhCb+PyHLsMdQRG+ekISQtaIEETqr0tAJP879HK9mKExhBo0pxkD8JpkPHmC41HBYeG/Ja+oP57ZhEDp+RnKJzVijFa6k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RwcfljmSxoSpRYT+iKRjLKHMvKQKvPBig2gdN+sk8mlIX80m8blY4+0d7xXC?=
 =?us-ascii?Q?vcjRueiiDPIzWKM1rVV5SOu3OFQ/WfIOBygSRRDKQAtakfM6x7q9bG9Fm4t3?=
 =?us-ascii?Q?+9vz03cPYsXHg55ajd9XhWbjXlamvJkwO97ghfFI1yQxHoQEirCRYFLPg3h7?=
 =?us-ascii?Q?nV4ZRvroeBeYRzRD6WbTZdqYMD1BV1WdaTOIfNLr/Iz0/4LZhtU5qQM/1EWd?=
 =?us-ascii?Q?TTibal0oCoUB0tCMkz/3uPwLtBpWa6jCxwieN8ZzkmqM2qmQLWLW/JiiFlhD?=
 =?us-ascii?Q?ozYYMXPkFbDbQOw/HrOQuBaO4Md+ITZYe7A3CKx2czdkF/4Ou46Yv9IYZTE+?=
 =?us-ascii?Q?qYcpiataa9ZDargFD2Qkv9NQfN3h+Bs7s/jwXOESiVEhbKXSSF7OPs2SVMdA?=
 =?us-ascii?Q?GRVYKGcEu8ocbGlrZWIyJkdXSSlG9CJZ0hJo+uo9/RaZr09KDYk3/82WeD9t?=
 =?us-ascii?Q?nYp3KTwJE3idvz9iE4jDdZgtk1JPnN8yk1wUxKL6Cb4RY84LbIkDGQMwKnMX?=
 =?us-ascii?Q?6FvZJ63vt4vyWFjSVf+fYdoJFAWEjaFfaMwVXRyj/AHPznc5ryMT10yC4oFO?=
 =?us-ascii?Q?uUBkIvcE9U5RjQpZJSRcfqcF54ywP7culJjvpsZBmwlc+dtwg766zj1UH+MH?=
 =?us-ascii?Q?w3ImIRI9l9lKda5UlT2yOi16pUmH+F6dAFlxhE/T6jbTydPD/M1Il5b7gQwJ?=
 =?us-ascii?Q?8QW91g+C3vHGVr8zzbteG1+PIyjw46UfIMBiyFPFmHCvV6Wdwo1sH63hfy++?=
 =?us-ascii?Q?fWbdZ+qI8S8wzKrHYhwcAeKYy2AMqXZlbnEQyoJDmdoqQJZBAgvolbZTe+qL?=
 =?us-ascii?Q?dBuQGrMwVFdUYS71PeXMY4u8A6tfbA6mQoirT4gdViL9ZnrQ8j2Caw6ErDFJ?=
 =?us-ascii?Q?7dDIHM+WRpj05Vm03z2l6uOJhf/z1gp96yXJcM59DdCuR1iAvV6ww6ry6plp?=
 =?us-ascii?Q?rzP/g2RUuHEs8A4bkL4XimRBS046C5Hq2Mo5kbC36Bw/HXMqkIAUvXRBX6G/?=
 =?us-ascii?Q?3JrOovKqUXxdVe+mwJRQ40qJeAZxR0hKN/gn8owoAtzglbq3LUDIsIKqYrQi?=
 =?us-ascii?Q?XyuUZlo+E4S7tco0OzuclEZaNCkmMB0tPPBhtfcyuNrSzJIEST0HKxiGfXGT?=
 =?us-ascii?Q?j8KIxwKvHmg4T/NHP1WCMjXpM7Rd7JN0tvU3NBUesZKFPIMu+Yqin5uah5R2?=
 =?us-ascii?Q?Rz7YG+djXfts69LM3xG5K68k/LKaeY0RDIN/1sTVk6ssHOIRfVqXcWXiJ85f?=
 =?us-ascii?Q?F/wRSM71nybqzTfbDozL4LijXs6oB/X5Sus0e1l5nQxpfkJGs6BKebitbXpO?=
 =?us-ascii?Q?MUdY4n7dnP86TKWvFtYuZ/vcvoBBXZFTZUyGscrXUXmDRsHHegp3xm9KE+3a?=
 =?us-ascii?Q?OHA2E8qPoi6Y0gKO/kks7qVXOfs98UEM9bPtDSHcYRG4jSq7vXc5XrKfocdd?=
 =?us-ascii?Q?lqN/l74EBgEsFImcu5CveEtJe67w6z43cffnRnVPuNU65BaayyRRW4oaRH0W?=
 =?us-ascii?Q?DyTKZaNmdkoIDgfKW3B9qc1Nw5e70kqyFfiDuoul56sNvtk2e4GqdodH6r/5?=
 =?us-ascii?Q?3YqXY85mbwZjCrTkhDqR5YkzHL083M1H92d54nTSr665fBu6kvSsLoZ/zohz?=
 =?us-ascii?Q?FuAe5a3qsyCW8QUnv0AMFQpKsHGlC2vfUBIXC0adCFbbpiMAi6hZN3/FCNv1?=
 =?us-ascii?Q?OWC9133/CvmjMxe+UMMzAtQWwIfGgUaceoyjb51hZRngFSAf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61cc493-315b-46d0-b069-08df0431c2b6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 11:53:07.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLEfxtRuMUdSTDYGBOhh291foEAmnQ2kvD1rnpVBOsE4KvpBikLmFHWcGUWvxgNX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687

On Thu, Aug 27, 2026 at 10:04:50AM +0000, Mostafa Saleh wrote:

> From S1DSS (nested in HW) to bypass (S2 in HW), the kernel STE writer
> will do a hitless update by writing DWORD 0 => CFGI => DOWRD1-3 => CFGI
> The hypervisor will transition Nested to S2 only on the first CFGI which
> is safe.

It gets tricky to reason about since the guest kernel doesn't know
about the S2 items that are changing also when it builds the
sequence.

IIRC there are also some annoying corner cases about illegal or
unpredictable STE/CDs that have caused trouble before too.

> > We really don't need two versions of this stuf, just use the
> > programmer we know it is right at this point.
> 
> The problem with that it needs to pull a lot of code out of the
> SMMUv3 driver which has things as struct arm_smmu_master.

The master is only used by the sync op to generate the correct
invalidation, you can just #define it to whatever kvm's struct is.

Lu had a series that moved this code to be properly general which
would be even better, but it seems to have got forgotten

> I will need to check how that can work, but I will try to avoid
> that, specially this is not a generic STE writer it has quite
> small transitions which shouldn't change in the future.

We've already had problems here on the viommu code, I think this is
too optimistic. I don't really want to think about a second version of
this :)

Jason
