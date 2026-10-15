Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA293E1CE4
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 16:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792082678; cv=fail; b=PMkLn95IqhdRoXtRsWBYHhxdpY1hifMNR4BvWVo3f4JJBaxFJt2T369xyXWn6bXXL4WkozgZQ5wm9722R7pDPQ92jf8p1gzBxCYdUElfS8GZrqn5bDJqCCqKUy8vJ17R0IS7fd99eudrj8jo5x4J/Dcpkxj5qUyfXlFtZmXTI0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792082678; c=relaxed/simple;
	bh=sVa9WgN9tkedcC16CiqvBHB9ML479SSzymVdlCj1EXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CakzWJljIcOfaVufRMTHmt3TuIUY+BHntks9750bycE9qdvDYVYlIHxOlnud7lCEq/gUKaTAeBvYS3yJ9oYTR84Nuw4EkjN7yMpK2EOO/fY9j4c26lZmHzb3kAmzMSjBY26+GouN0wXiMOio3aql7ADtpK4wA4d8RK7il2onqis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XRMgTzqI; arc=fail smtp.client-ip=52.101.193.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XRMgTzqI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FX4AYPYssWSwvpBBbpC+5mjlT3xcNZktyzrI4ueb1QTDAE0qkZlqW8/LdrXh524zTxW0i/C+Rooy5VvFCWVaGmPgvwUFoMQMoCDasBAlK2CNJjxF/E/98CP3HvgNLavSoYWquNH/BtgX958PeITMdFBQ/GfT2zgnyEnqt6qLi2BW0b6btekjRz8GTBk7hkVDe48eyBx0OX17mfNNZ7sLeI1ek5wuB5EYIDe2oH8SwYvXmxtRg3ScKQEyNaMCVGhWmBtwT4QYls/EtmxqxEDB2TOoKSu3hLzrX3zm+ln2Mo2KD/0gf2D2Qj3v/VsE+FHzBhadwoiwgEI0ufjAlV2cIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hr1d07j0iHjsZ1/mYswjWcTbQf3Ve7B6C6K1TyQLL4A=;
 b=S+zbOtJiFVPAVnMF+nMJt3BqO3gwEl7FHWpmvAv9nn9X1zP1nZHdoklbd2NgI685JnFJXOoj5xHQ/kmbXFcUTMhe2KYpMiVtnRXXfkDJfB6Z+72B2SwJ5L4HmD2TF8ijMu696pI+e0BScMQ0EWGeVdnZ6BFmchxncFHfssZQr3o2X2TiD1tCKAf1/n8cP6P1BfISCwIOJv3yauuoW/wA1IAw+Om9ZeCCbfaMbrkTeGqowlu5rr3duFsCUlK7Po0u6my9pfjWnSGHY9vgAGZ+yYPwVsYnVzo4oRf+tErtAw+w0d/iC950z+N8Lo8UhjY91bC+mAu/cwphUwSEhsGeng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hr1d07j0iHjsZ1/mYswjWcTbQf3Ve7B6C6K1TyQLL4A=;
 b=XRMgTzqI6ZPJ87NNs3PiayKyZZshJgwx3S36xI7oSqMLFD9dDWZxmbtGm/KlB8DL6MQVn6BslnbLErbF/seM8hnvKDDoRQQoc1H4ccpkRsPIdTnb4JcGs0qDJlHYZx/PnRN767jISG5ZiDvqhpwkPVZQmeCtu2h3qDFUTsW0F271JaGKsxTqSC4ikOd3Y+1an+hqkYBWLmEzmE8lyCpKJ2JyvGzvVkhuUhDN7m3ff+GyZaqBN0PT08HpGFmhTCEFH0g+EQ6erWVaJX8cvRfVhicZlQa3ilkqNo0TYhYXCqUwLvmGb/D1Y/6ImRw5Y2p4LACRH1Vb+7H0CFEM1cEhmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ5PPFEB07C8E34.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9a8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 16:44:22 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 16:44:22 +0000
Date: Thu, 15 Oct 2026 13:44:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the
 CPU MMU
Message-ID: <20261015164421.GD13920@nvidia.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-13-ryan.roberts@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015142552.4128028-13-ryan.roberts@arm.com>
X-ClientProxiedBy: YT4PR01CA0076.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::20) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ5PPFEB07C8E34:EE_
X-MS-Office365-Filtering-Correlation-Id: 911a89db-7b2a-446a-3745-08df2adb9089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|4143699003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	adb8kNHofnTpQOTVIABfTIoQVRxGUSJxWgCJvVm2mngpyYF5I2W9OyJ1YSlMwHLHyN3VQPWh+fXHzG7brOnSqMN78VYQBly/EtKXt9q0n1kOYkENSlPjBgZKLf0pE4Zh3YSuvrnztmk9hZ876IcZgAv3RnwCsJy6hYi8tBlm7VYhAyzuslRMi08aneWLrjqLmJk67VfHFggBjhW92IUpMY/CY/i+R6/wec6QN+E5zNXGrTBknAgpHGPWUTa1hXf3pwEClyGePyd0i4VBOn3cB3rOnEhgGsuxRI6jm6NeWHa2P6eQFD9KzJlH4oFrxkFmwRwcfNSF+s8hebt6HzUADsHsnGs9ztZCmQtJBHEU4hQf6H/mbJkwed8D6qUmp8sDzdzLakmApOWK0qdnz1ALPRCYpqOa+6SuY4udW3CRV5iHTjibm0OmJ1gy+qYJX/lFpUijiDVaiYCFtqVX5po62aDtjadAN0EypFR50RO0wV+JSfq/7oobn/9RQ+iHzSv7jf+G1APXzWsJk2cKyMmFZHeC8N4s27fxjkgh6og5xY8XoFwLLsGKG78rHO3z3oZ3ZVucvVle1goDaibXV+jE9xgOaJJnRd9YplIWBkCFLhpx9kVUp4uQ67IFan5DSnxX07m5bKN6//Wg92tuc010gMAE9TPjK8n1/UvsSUouOTE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IZkB/TqDr0yRuEhMxY3jMM5/QMbln1bqa2b0xBRo9939+L5AS6hihOWzW+yB?=
 =?us-ascii?Q?rNUnVyjEaqxREy6DPdY5vow+3VFBavNBY7E5AjBCpsODd/qCcNdIgxMT66uZ?=
 =?us-ascii?Q?GlqtCe/HshTkB9cBD24wB+OCQYQiC5UKaI7e7vuJMkefUs0o2UKip9dhLIEb?=
 =?us-ascii?Q?W5BXB2LQIvlPsctQ1zVsem6ABao8dCy3CAyDbT9L9KSwGsYCiCbxTKMyP1uG?=
 =?us-ascii?Q?XJR5CwxuqmaEKJVyLp5mlda5M2sFF4uNIYaU1FNJ/QlchbivH8ykoQE9c/5f?=
 =?us-ascii?Q?FzZkTgBOVMArjSLyWHmL9UcD0ENk0mS8yLQFj0DPL3mpI6wKF7UK5Oo8Znf+?=
 =?us-ascii?Q?scmq0DLM0JEq1hfbLp7iAY6jJpERalPHWXjP9VAXTvvqIJrBYpKAJMzeHS+9?=
 =?us-ascii?Q?2seWOKJ2xSZwwXFCIrju0P1MIWGWauOmyyufsvVpIpCklOMrEBWOUihtQX/a?=
 =?us-ascii?Q?tdd+6eqLlJ2/j/h2mdcdbpOuNmUqLFLxCE2SXRSoZeD9rMyUzOleCgaNqttk?=
 =?us-ascii?Q?W8No0RVDtu7LK/PD+45GDoZDfK9Cuy/SzmRAKLDixYspJlbF11guDhgXLhIH?=
 =?us-ascii?Q?qwFRVZnH5GQQNUUHTAdPrQNA7OYYFCzNkgWLOMxgXb+tsLog9lhG0wE7wfID?=
 =?us-ascii?Q?yW3QHcotOskBPVyEIwvMN6SLw0n1OWnVyQ4AHcthdszp+UOncof2jFtswWfM?=
 =?us-ascii?Q?joXcKB/ARLQi5IXN1XpCFLds/SY8JCONLV+u4kG3+Dv3mT03BOPzeuRkKGan?=
 =?us-ascii?Q?3GW8N/ZtCS3JJh8olRQW0ttqy41DX2Q4HlzP3PFVVI3rXo1C5Fg6ysOfkn0+?=
 =?us-ascii?Q?kFPwEf1sTic60F8n/0fDQyqdPn3Gn/0ssSqdQWsMUG/nMvLkHaZlps2VSCcm?=
 =?us-ascii?Q?VflU51Q4ePTEyfBl4OGPBn+hBLyREqwreCPQfIa9OKPE22o2IogvpCRJS87Z?=
 =?us-ascii?Q?MROjh+U/0oBclJxgppfwQFhVzDUtTpQDNoyNft0/hilyTaY0WpogpKE4+HlR?=
 =?us-ascii?Q?8axIugJ6qnTIeRx8ggJwJt99B94xq7kCd4RAik8lX8cGBFByEL44Pn2VtWi+?=
 =?us-ascii?Q?sxTR8ElwnvfYnJKqnyenVcECqKoqlR0wVdZuDy2l1Y3XP3KvhNmkrh7TDCnf?=
 =?us-ascii?Q?HyXGy8mZYMXd7S4ltKENKfoYWfgzc8PkquXwuT6+CX46nR1CeEvbpNNp1h07?=
 =?us-ascii?Q?RsTvR2nI3o/FE3Qnw1onNY8ADdyWUaqGOG6gNUW8tsSZH/PQOpQpQS86r6Dm?=
 =?us-ascii?Q?qw0v+dJ4nLYTvk0ylX+ClFljF4VrDt3aaCut37gXSZLLjUEA0XSCC2SC681d?=
 =?us-ascii?Q?v4zhVjeWEXesuEC5zO5MhBU8ns0JBfwF25LvI35bQPSFPpsiz6bovuEXXAk4?=
 =?us-ascii?Q?LxnIK4n3I/AXviOU4P0UiRPxaCnVXHQj1m79GHM5us3qc5gtcyPu3WcRIHSq?=
 =?us-ascii?Q?ReDKQ4GIEwWOPUav240/JQlwOhqSdqV5fdc8yc2ETYBPmAoWIn4+9+mG5fpA?=
 =?us-ascii?Q?fZViklSJ4RixbYfEmlwECOG+5tnFCgHICfNghErHrXGX5GrYJMUrTi9miOjT?=
 =?us-ascii?Q?VZzHjW+5kqM3M9rnj9fXX7Pz3TjrqAMIlxvUZDUSbh2couUGkdirFVx2G/J+?=
 =?us-ascii?Q?ntfpHQYtjJomgnLGNS7MOfqj8vrUoR3mwWHskb24CvdKBfAXR+h3leWBLoD9?=
 =?us-ascii?Q?yI1SbNLbWSkDK9Ia1ecELLua+UDKKJS1vkZ0jyhG+mlEp+XR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911a89db-7b2a-446a-3745-08df2adb9089
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 16:44:22.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYYwcHGqQ11GDAyTvG793otN8JBc9yNV3zsVCc1HJFdriSCMIHYBjwNXDOKzE65A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFEB07C8E34

On Thu, Oct 15, 2026 at 03:25:46PM +0100, Ryan Roberts wrote:
> From: Jean-Philippe Brucker <jpb@kernel.org>
> 
> Support devices that are attached to a CPU and perform DMA through a
> MMU. They do not have an IOMMU and do not use a VFIO container.
> The VMM needs device-specific knowledge in order to create a virtual
> device (device tree, ACPI tables), so it also knows not to allocate a
> container.

I'm not so excited to see new things built on top of the group
interface.

Maybe in this case you just don't have to do a bind operation on the
cdev to an iommufd? That feels kind of natural if you don't use a
iommufd

However.. you still have to affirm which single mm is the mm that the
device is going to be doing DMA against. The process the opens the fd
should not be forced to be the mm that it gets linked to.

From that perspective maybe you should create an iommufd and a special
"SVA" IOAS that it can attach to. This is more complicated but it
makes the mm linkage and blocking beahvior explicit and controlled by
userspace.

Jason
