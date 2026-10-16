Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074317D6
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161743; cv=fail; b=qdQ+8NC9tYbBrZYT3JcMdCmjNBqVMcgrr1boUC4d3KpFg4cLJrxA/svH+sIio+uecuuluVGfxAdelBxaM/NjgEQ/fiVfBZ/oJ2GxRQGtkUNrSsi9s/BClKDaN9BSgCHW2g6TL0AOuF9QJ+qQtvT6T7OEN1oZ948GyAPj2AqAIr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161743; c=relaxed/simple;
	bh=KBGfTGdcJ57X7uho9dnSm0pskpKmrgoXHa0KjqwkEjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AlymOHYWwbumlu74xmmPTFLTLCX8/2o8UulcgzzqxLOlobEVPijoPRRz7LCOsppD949s5AhV5WgPEKchptJeJrxtY5N1K/HWFIbrHAZH7mPLfs+5pyfzNEPO9CCGP2KILqSn/921613pEdJBhup4QPf0DP0glyI5BgAAtKIwqVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o9tnFaAC; arc=fail smtp.client-ip=40.93.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o9tnFaAC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeNhcAJwZCtD+888P71e24/2/1UVvUWiKxMvlpDPRqfhNeH5jbSTDmfaBLrSvdWkLBaCdC/6LhM+ZvaoUv+VKuXBbm1GoIDEwL4tBWT+raT76n1mHYmIlz+6Wixay6H3xMGuat2eXSLvxIj2GadtUPRteGco4KhQa+yHDzjiFW2sI57zXaTkTwR4tjUdAJbOUCMTxuv3D1Wi2/5FFNHEyl/rTYZMgfMgBgTY+mTEIrLEqqG0PWRqbSwoqjqIPm1Jfu/z6+TIldKutlZZaZaYk606KAGoY08sDBe9d6LTYmWiNnWP51U1Q9y8Eu1VXCncji9hwopOv8OE8KQX5TFDWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeo4UlR7k9ii5pcApr0byuh6zl14tsTVmNFEH/do4mk=;
 b=b6lk8pr+SfzFlRcvenjLJH+fKa1pmvlifOm0lGXGFDEPAlKpPjZWaSRRx0BsLLPi2doEHrWE1fddot7FknVAIwVlK7s1R43NfCosOBMzeHyqgmaLEowQ60roJHnIq6UjMmbdG7lVtrifiBtgToGbifL6Z8XzkoEMd8yoOr/AF3Qn1VP2qSots5DCNeUpAM7fltsrblpqBYgdsvZt6Ae8Ha9ncd+MbMbA0HCu1FNSg1il+ZFF5KuaCkSfbFncUtiMUDjvdxPtF97zX+FjsnGs8Q2MLT/RyFO8rmvQv+gJh8Ob/D/Kxnr2EqrqLkMKszqPnw37yufYU1ruxz3oOVC4AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeo4UlR7k9ii5pcApr0byuh6zl14tsTVmNFEH/do4mk=;
 b=o9tnFaACfjoSIlktuB3ZYXPWvycrGNZZY9Z7bMX4coHABx4AFS/91ZFKp1UuRggOCenQAAwMX7GHpXozHMyKxaVHkRkR3mzgho3V0cPppcaO/RbqydF613JElm4zqe0cUUBniqoZhI3Nc2+Z7YBGepntMVf69EMyJQxBhLiNQ/Czsd2Mb0rjrSFfIwjDMWWZR8CWaNnhcpCpYN6HpRM5VrV2qjqRtbzeL6ydySxpZUvO42xQqMCAmSKBWqbHTZx1BBVFRUzbZUKGG5LsxOCmfX38MOni7qAxDIy7q5W/SrUnclnRa16kHfWmPXQjK7iBF0/S1yLYXQrz0880/yxN4A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH1PR12MB9696.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 14:42:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 14:42:03 +0000
Date: Fri, 16 Oct 2026 11:42:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jean-Philippe Brucker <jpb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
Message-ID: <20261016144202.GG13920@nvidia.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-16-ryan.roberts@arm.com>
 <20261015164102.GC13920@nvidia.com>
 <CABCqBse_aZL-EH0us2uA5X10q6E4WP02MoHTYf+M9ezRZr26WQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCqBse_aZL-EH0us2uA5X10q6E4WP02MoHTYf+M9ezRZr26WQ@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0215.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH1PR12MB9696:EE_
X-MS-Office365-Filtering-Correlation-Id: c078ee85-1e09-4269-1428-08df2b93a4e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|56012099006|5023799004|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	luTy4I5MeNJoC2lX1K1KwquUU+RrCSez7DMm1K8AH2i/Cl+7n3VgkrMQkUWuU2ktIRbugWSUiaCdIQ39a2ZRL/dzE1S9n+/HEqjEAMrSJwWB9L3BaZwfjfGEOpEvJPmkdtBgZHNTFVgCvLh2xEkuRxD+elWq4jAjiwhMkk+5VkzvcQ5fUkBHl1kd1IFEZrXyJ7uKd/7joYLlBHD7UzCe2FZIms54Lsr+qVqd+h13X9Ah23Xi9kMSeRU6CFWBb4oJeEIvTAyDG80n8P5yGssRfOsNNWSMl48twMclorPdBhdqhQ9SVNWgOAUVavwxLFkWNIagI41c5y5CMY/sJLLt7qHQvcspysN+H1Z914B/G+XD+jS7i8HpGYv+lP6O/4L0xRWeGYqlGXJjim0jbpWZSYBj/MsibhTGf+BWMSYZMbbwDiUROfpnLJYu53nQrmAxmU1W8d2RE9AHZ6rJ5LjeoTTITg1sNFvG3eqr+7WfzcbTDKiIduJTLVdKODGuAydMQjmtqV+jUpQ/Fg68Ng0ZSTPALo9HbVXj8g1g995BkKk+ZZIj1WjTH98oGUWMQrPJEvMfBZtTF/ZqkyEv3spq2nuUkqQf6JJMpE5khn+OJc8+uEySi0QvIkZwPNJ1rTThcC5gdPQ/S3JSS1zS0L4cBwvK2QQkCpOsA9JjKhyhlDs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(56012099006)(5023799004)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4qGvtiRciud8Qja3vBAYUVRggMSOleDBs07xQia/qu3pXXU2+ehHMStAZP+j?=
 =?us-ascii?Q?8Ke6rDsEFs84uqzJTLrOvY28yRzxZbRO1nsTQVMvfjzP3ItMfSYuxkJhxKjH?=
 =?us-ascii?Q?360gtiMcTHmx2aAklby5ZBj5iB4ex0ar+iZdn33xGMYUlz+ol2bpqjUBZgu0?=
 =?us-ascii?Q?Snqo6pib+iBAwKhTB6q+TQsAsXbqmZAJITqTjIKH/pr8vUWPs3EySS3Jkk7M?=
 =?us-ascii?Q?6cK6Mx/SPEUUK919NykhZwNY9Az9qliEhorp2l4mi0psxwcjTtw8t+LFMLeV?=
 =?us-ascii?Q?XhiM8BPbJIg8tDV47EVOaEG7hEai/SNAArPktpIT/saXhjiJ9bj5BOM6KFD6?=
 =?us-ascii?Q?mJFc5lpCZTi8yfSvvJQcqCtQnYKqkSEqtFKMB2HDr5QmN3E75yiXra5uVOEm?=
 =?us-ascii?Q?g0ZyqmZS+VTUOQLHP1NVYGo82p9w+0jLZBsxlvlQXAJ67uZo4OUWosmTSU9X?=
 =?us-ascii?Q?azzQoroIIfft8wBiLd/YTtAuA4g0vsD+VcqfczdbKQJZTBLa0REMOfx/PBZV?=
 =?us-ascii?Q?Q4+d8MqWI84HwGUL0o8anD4dVI7OyM29U07amUyW0X0Lxv2PTxQGYC1Snt6Q?=
 =?us-ascii?Q?JXtckzPQCVMhMhejfnE8mO5fP6+WP9fvWylGq4HqrMh9U3h4pWG6fkO3mDiS?=
 =?us-ascii?Q?tWXtoi0R6iJTxox2aZljoei7i+M3NXue0zMa0RgPo2qEl0eFApZHwXsGBzRA?=
 =?us-ascii?Q?XB1FAa/RMW9GWFY9LUwRhopw8EO40LFZd957uLerDE3xX8v0ynkwiGU1hLjR?=
 =?us-ascii?Q?UW4cI0iNjBIkIEbDpoGu+UMS9c3ymdBOrfV8QR57xsoSq6j8zMZEx2n2ySQT?=
 =?us-ascii?Q?8mWR4WqX06Xo8NouCOR5x5J2P9fYKTzO0MprW/pU1WM7mmlbhGJ/TbCUanzL?=
 =?us-ascii?Q?YpzTnRiVeOgg+N56dRCCFfxQcA1xZZLKqXku3XdJ3S6BVlsZOljmwa95p0tH?=
 =?us-ascii?Q?3iv+fUjr8RuPsVkhqRCbJvkrgTIqv5HwTRQtDzZ5zf3mkYr4kyUrzGQUVmF2?=
 =?us-ascii?Q?YssdCR+gDhpVJsq6V4lADae0hyu/B1SuhBDD5k+KgHSZVuk8oykF8i38Qmu0?=
 =?us-ascii?Q?MtyiNbsvRvXTctEtMs8A/H7e5uqmEdzmA2xWEfKNo+sLVcP+GrpIOA9a3WQg?=
 =?us-ascii?Q?oDygiyZrCRLjbyrcX/431CA63kwd7wSrPRv+4RDiDabjT4ZtjmLMdfp63qaA?=
 =?us-ascii?Q?J4lt2X7Nq5h/8T7o4/mNUUeKDQlCFVBRno3334wCXc/qOm+FwbUqR6MENHwR?=
 =?us-ascii?Q?w1cQ4y7fyQj72voSXw3GzYFKm3m7WZ9UiLvVgRUuHEjAhmfOb2PdSkxc8kTZ?=
 =?us-ascii?Q?sthPiJUJJZ6CKPqUao7zdDxG1UATmhWV4ltLHG+5eiBTrj71tAwNt34Yygg4?=
 =?us-ascii?Q?n+6uMhK5N/SA/Xvvcce/DpTSYXEhm5vZI+lGLEpMrsXj/oqgg+phDuB9Jtnd?=
 =?us-ascii?Q?Ly+A7u/wkjKKdVaeag82JtM4xEzowQzeX3t4vbiQODchu0n5Dd1Uj9mk9TyD?=
 =?us-ascii?Q?lLbCYyHPqgN1Zz8wCz1ZuVyaocBZ3GnwJW00OZevw1Oq6ciO+QZp/BaT8EoV?=
 =?us-ascii?Q?W5GYPGtFJZuD5Js3MvSTAviskF0QjmLxWJZa4+KF4fwaMAjTqL8ZfOgvSXXb?=
 =?us-ascii?Q?rPXEr4kGDws54L8sDpB6pe+7dYSWawjvd1zOkvZDNqQxG4GKXbqAG6+fHC1X?=
 =?us-ascii?Q?CK3a069aDVf5FVgCuP3HColxswijIiAt0oax0JzzlYPEfkS4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c078ee85-1e09-4269-1428-08df2b93a4e3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 14:42:03.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jDHCnPjEGqPTqWVP8aaAt5ndfR4m9ntZLf5wWnohvVckKkpEIQwNF/eXomr0Ijj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9696

On Fri, Oct 16, 2026 at 03:22:00PM +0100, Jean-Philippe Brucker wrote:
> On Thu, 15 Oct 2026 at 17:41, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > I think I said this last time, please don't use vfio mdev for
> > anything. There is nothing mediated about this.
> 
> We don't multiplex a device between guests, but the host driver must
> control part of the device registers while the remainder is assigned to
> a guest. The host configures accelerator access, stage-2 translation,
> handles CPUHP and context save/restore. So we can't bind the device to
> vfio-platform.

That's fine, you can make a proper vfio-cla driver.

Jason
