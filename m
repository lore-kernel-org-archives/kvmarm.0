Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9238D39E177;
	Wed, 23 Sep 2026 11:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164521; cv=fail; b=Gi+YsQRu9DWUZDYCAfi3YU2U4o6oYmwGN3YhmB+fqwgGNlO4aludvD/Ku3tP8LxNBRg0E8xIW3IGRr/Luja2Jzn7lZeylRVEzi6JjWW0nM1Q7NtHwMO/gsvyZdooz0w+dob4pkjMhuEwFH026yiwByFY/m5sJjC9Qv3v3Lg+wbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164521; c=relaxed/simple;
	bh=HWmd2CuUQjPYOHU5ZR55dTQYMMzkXYRv6imTTzw1cVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oUJPCcdlyOuY3ZcmyvSLBQ7R7oLnMsxQYyJydXfRqItJU7m9E/TombvQGjcxTeHMyAzp8/rpZrMT/mXQaQ1TPPe2WMv64hud5FNoRL7oa6TedZS07NWfPrlDKFCpuWoQ8FAt8sGoLor/pMKxcYS51ia1nhckz/96rTdyFOOUO3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RtbzKI1w; arc=fail smtp.client-ip=52.101.56.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RtbzKI1w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoCmvdMYg1GEldYeu9JwjjXLZQrPiT4ZNeIKZSfDuaoVwh9+Xb7QHgrFUV3+PFOdoRA/lgA4JdhZkhiaS+50JF+3ol5DoqPqOtdqT0ygXlzEw7+Qzzv/H8bt4SZ3D1S56amz74cHfp/Cv18d9ZYSsEF1xcil0yJWBBosJ2n/CzDFGbH5awdXaPfLzQ21TdMijzvlGX6GC9/0O7QFj/aJkOF/6vOb1i1ksqhF1+7DDPwjJdXsz9x07k/miu/sEilXx5QNiEBoxKjxmRY5ewmDhvqbOVm2KA5YwC5a7Rxf6H6vxPjvYJ9SUyZZShLL2r2iTxKd+7BGZd1bTSxwFzMbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qje7R6igkbEw8YoDnFVsmsG0A4S47nuN8/jSYIHUws=;
 b=LTCs3bKdPjAiFuQ6gqEmw4wnHnII8dMSKkUa+oX4Mq3sv5/kLRRQ1HXtblsTojTx0N25O7mOMC9+RO5eW7VDD+9nSVfW2q/bPUYMhTxBhm4cPPCzB3LeY2b4dIKqQmYtkMHL0KGO6QVFtmTGuqIYvLZBohj0cTK083gx9sY8/EEKJgQFqnTO8WOcpqASGWjZSR+BY9ZhigLQe2OlPUR6zV7C3Agzhd/76lOJaaLZ4ie+ChsFkc4o+9+v/sv3g2e3Uc02Su7cNctGgcJx+UUzzfcm1TWe3n2f4cOtOpDYKZJwDIjkqgoofI+edwP8y4EE3t1F3H7ps+T5LFeoJO3rOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qje7R6igkbEw8YoDnFVsmsG0A4S47nuN8/jSYIHUws=;
 b=RtbzKI1wD3BCkbRBe+4WO290voGRuEb1qQi949hZFxpeAsqbCFCermxZ0d4yY6Jo1CErFiJdDXQ8fqpix2u5TNXEWyOBTCktGmpQ49p3Pai/l+pCiQE8tYI8XFreHub7c0Zl9oOoYDOkwF6WgXvKrQzjNUJAgHiktJ25cy8W1vxkuAoH4bGyxwHeJ7SXMwhltx88YEA3CDDUcXFAiFw/sAnVfkEZ/Cj6IW7/OVxfUEVkmOy4uMfFGaU4SSytP6cEwejToExA4vTYPe1QG735NpxWYhmQDkPQWUlWll75ZEhnGrvtv954Hu/2VD05AY3OBu9aHo3nl0QM8M63/0dmRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS6PR12MB152050.namprd12.prod.outlook.com
 (2603:10b6:8:410::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 11:55:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 11:55:03 +0000
Date: Wed, 23 Sep 2026 08:55:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260923115501.GD2545495@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
 <20260922214818.GA2545495@nvidia.com>
 <arOmSxqRxhd717Xy@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOmSxqRxhd717Xy@google.com>
X-ClientProxiedBy: SN7PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:806:122::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS6PR12MB152050:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f36226-3394-406a-24e1-08df196980bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	j9R2vW/rqd8T8HIHCHOKmDW5rKFKNiygAid2TXnO0edOKhvUEEnroIIEd5MG2/btP8aY46+nMNSDkSBDYUlHfP+QvxkvxkLg+/bUnucQdYUzJvghHtP77BtS24nLeqwleKLpMyIUcWEr1cVKHvUorClet/7GV83loOSws7nZfopswafG1xlUC43hZtg6GsXQ4Mg4YLZvFp7LlSRedfhaUMsLesPWS47FnV5Vo6F1lgKV1/SOYTc7QLopl4THrcxvLapVYv1PnRCyiJG1GmZPwCD9l1Oq7i+kJT/TffrrgwfE3hifVYtemuzSrwdWRMjLVHrxTPvmUFSUUlDaWjinAjdV/SAj7ix8eGsvmlcB9pCIbwuL5OCGrz91sR72xPhCPol9PBurrINTuS4QFpjBQacCwrd/ZnqaJ1RtXB8Y2JrKOR497ZBUaSMMxKgk+h91EYgOrqjxkblbNQhXM+u0Gc5CZVJ5LJ1Zp9pher6YBSBHm9SZB6efsqlG6aWkSi7hXQC3LaGbxZKGJTjpqXwZYLlia9KVfWISbUllCPXWX/LFGDD4n/lzfTTuFvz+lXB//t74fYMDYs7HV5T3nIGYh0MMrf+7fZ1VMNSOvV4yswYzvm3+Nq8msWFfnVxP/L8nvbMsDnKOTgM/9pwelnMhW2fOlYsqqtUw/LcEckwVrUk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tjv9d1MNspQMAdOQ786A3irD6L92rq4cqZKcmn9ITb6w7cyUA+IN470LRDlb?=
 =?us-ascii?Q?VO98t4ogtBgqD0S3EQMFX9Q0/ckbzS3wNBiwNs0ALZpy64kkxWVb4s0DiJ14?=
 =?us-ascii?Q?M4+wCu2rxChAFJsJbYwSn3vaH/3Yp8Jl1xWAUZ9/hbMMBUL/QJXMpfst7cLo?=
 =?us-ascii?Q?EKutWAkQk6rSX4AtPOuo3/ux6ao2/cD6PY2ziCTn1cp3u7YgY3jULsGxx46G?=
 =?us-ascii?Q?OJk7kCP+cuEqBoZ+a2Yhp1TeCWrWX98jZjLLYEyJ+hZ1bvddvqNDGjQTNLns?=
 =?us-ascii?Q?rIszfbXoQR+s6w/vqVXRUJrgFt2PyNs4KoEF37ih2zVjjoC/acBax9lzTRpg?=
 =?us-ascii?Q?RTM+PGNG297nMdpwpo8g6EFBcyu+of5Py0w6Ml++Tb1RV4hm6PjJRoi1fy8e?=
 =?us-ascii?Q?8tAyaDWCUEEyctYoPuf5d/lQyBDnLsaPF1CIdHA+bpVUlHDACp1RQ+dg1j3Z?=
 =?us-ascii?Q?SvVxa32yE+iniKS3snuLw9oMLk12J/LBRdKyjityRuAMsFf5vgzrvtunu44B?=
 =?us-ascii?Q?Nrb/ax5r+HMxb0JAp/sYTYOBT7LA6kVGmTHnLUlj1tsrh2fcnJqJjW5atybs?=
 =?us-ascii?Q?9ld4n83qBBRF6JTBQjDFYhjmPNRhU/yZsYR6XZZVsXWtwRccqryd9+WeuQbf?=
 =?us-ascii?Q?DVqvdVKZ2JZpNeuICvvkhBj1kZIw5xVQWOkxxCskzydxhplySl8Vgmi0uNGc?=
 =?us-ascii?Q?yLxpgCwDAJUuJhbBE/FGEymKP0/1Z8H2qb+m3EyKDLsCTq96TviV5SVRCgi8?=
 =?us-ascii?Q?QsoZbvhoxxWzjjsxjxI7zp+0/5/eP9cEWw1w9VNEoqmRD5YATYmmmdb61e5a?=
 =?us-ascii?Q?baAOKZkF4FYLEiTSQqccqpP+iSHiR6GymgSUA3Qbh1TeWPg0cHHAayAFyYDw?=
 =?us-ascii?Q?6GDwpZsNuxns1geve4qMSbS1WHZiKxq+v4ELJuwMGKOQPU/9zNTFd3KX7SND?=
 =?us-ascii?Q?zGkLzdCzhng9UJz2GEMVq/NM79Md7fzSQvRczSeHQzavO9V0Jw2LzIJFNXNI?=
 =?us-ascii?Q?1PTYD5S4MSrKJK7/1lhQ0wl5bI3fjKeHV/Bj4kWdmsIg5IgSaVKgCUwKGy4b?=
 =?us-ascii?Q?yWdflhU/yJdzFjAn0RiJcUFdINrjYpACIf2z7MSCLvA8pvuF8TKfVAHt8Q3M?=
 =?us-ascii?Q?S2fsUL+Kq5uXs2ixZ5ZjrVla8LoolyXX9HepVcKzSXWP0ftDQFMR2g4c63qj?=
 =?us-ascii?Q?4lYSqSIVOiQXQOhIish1kI5ZBQrigTeUH+KWwZ4VAmknpP1RK45Rq6bA83oU?=
 =?us-ascii?Q?Y0/pYCKJOR5Z5kAL1RW30oc0ILFWs4Qmu9hdhrX1BUjHflZsauc7Khu1a9Qt?=
 =?us-ascii?Q?HB3wP2uUqfEa93IP6C9iWuCoWj4R6iydfmT0f4jNDRXe69sibA7zi7isPdLg?=
 =?us-ascii?Q?7lrgtp9maA9Prx7Aw+Fz0dXpKoRXSuflUaC8C1up9DY0L5VLllmJjafl9uQT?=
 =?us-ascii?Q?AUEHXYUvW1pjCz7jYe8egTZnOo1d9LBsiUxDPCOxUU8+LjtP2j9NhoTKj8ex?=
 =?us-ascii?Q?uOt4KVEj6dXldQURIcrp2mNVUYz3dAeab7H3LnsQG4Td7Fn++0gXd8+uRfCS?=
 =?us-ascii?Q?m30MWLUAikCMcwtEULgdxh3GTBrgsHHn+H7BAix/UXSsA98TLsQegLZ/NGYg?=
 =?us-ascii?Q?JmnBTOEhCo4+uOMH5a68Ame4pNPLCgNjyCq594POv2Z1j1jTbsHIGodi5jNE?=
 =?us-ascii?Q?imwlXCbXGu+GMavUoc4wHNonDfx/E0OClrwF8VZBYVRB7Pdg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f36226-3394-406a-24e1-08df196980bb
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 11:55:03.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYBsKU0YKYUmPUOYFcFY631nJEoIXDkgFKFBj9xyOpiVdEzc4fUAoE3UWm5txAw+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB152050

On Wed, Sep 23, 2026 at 10:13:31AM +0000, Mostafa Saleh wrote:
> > If kvm doesn't want to dev_err log that's fine, we should able to
> > #define that away too shouldn't we? And maybe it does want to log?
> 
> The hypervisor can not print to the kernel console, so dev_err()
> will not compile, I'd rather keep that outside and let the caller
> decide what is a probe failure and print it's own message that keeping
> the code and stubbing dev_err().

I'd rather stub the dev_err than split it like this. Every driver
should still do these checks, it doesn't entirely make sense to omit
them from the pkvm flow.. No print, fine (and really, pkvm has no
tracing, printing or anything?)

As a stube I'd do something like arm_smmu_err(smmu, "blah"); pkvm can
do whatever with that.

Jason
