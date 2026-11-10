Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335137;
	b=s+YKYq7w7IYkJMqMzdGUTpcf4Tfx4i5T5W4X4bjWOLvaPUGGTIRPPQfZVFhu63G/U+l0
	 3UMtISwIPH2CgMi/FwfA8Muggaig7gotNOOA4WyVWh+7oSuwUUQwfc6xRCvP2qVFZ2PEa
	 Xsb24nWf3XmrOhQIj5Ap5+MhGQufpqWa6k5zUHcMJFFqYLGT7hSbg07ywRFxIsRuibZ6G
	 YTHZIEdu007D9qtF/lh7CXZBVWLXXFR8SY1UhOOi0Qv7HZUpvqrUIKU7aK0Y0BUoyoI90
	 Uxh0eQQrYPhxx0+pMNF8ADd487lSxebZXoN0EFziZpCQnXa2bLfluR2Ql+kLDnhIyiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335137;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1SGAWMv2ieK2/7euegJpE1Q4w/hUrKGOv7EraMv1AjE=;
	b=NCwoEckY7KXPrgabRcji4uoVBGTzlJRZeO09ivdq/PGFRedL2Vh1NIU7QS+y8ErpRPyg
	 6oOm1UJe/v4VnbRFCanLOmfF1Umc2p1HjERVG59f01l+ShM+8n/mlxCTpGB92BTbSkejc
	 TtAZMsUvG5PSkOQCeTMNftPncvXNZxLyx+QhTKDB8w+a+kj6WfyZ73LlpeGcpiZlOfBNV
	 MKzZHRQvVciaIrhrqIjYRxN6jblrjFLQj7lg8gQQgt8mCHMBCWCSErzLlBJI17jhbKGE2
	 RCdDnrjKmMvHTlGkcdndkYr3qfvAb+ye1PuNgAcr7Yez2+Y05BtN62CV65WIfMVRB2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=crU2b8lv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.62
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012062.outbound.protection.outlook.com [40.93.195.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93663606A325;
	Tue, 10 Nov 2026 18:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93663606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=crU2b8lv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2ta4w1ywSy+w79Vj1D3/0V8khtZPr4ZTPwmhIoejxoYAyoIKfuGa+QCegIcaG438rjaHU5qsZ0cpGJjKUSZeT+Ewru31jmT5CttG1ydqkfbXHZzp5C8HspnEr9nuD43XZ83Tfv2trMKKL7P5E3Iz9HGL/81sK73Oj2Z4c35c3Eeob/VSV8IjwgyK7HhLAMmMq1EAsIXLzj9CEeGHH7zo3cN216YHxnpJ+65WdnweAxDG4gjNkS0YquqosgPAcNwaJxvkS/Ngqy2lGxTRTlzPWnIX6zu7zHZcHzAqKGpDsFxAhQ57PlM4Uf77D4LGV8gzI5cGk3LUpwYIK2sC4mbXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SGAWMv2ieK2/7euegJpE1Q4w/hUrKGOv7EraMv1AjE=;
 b=BQXSVP1p3CrpJUWOIbLp+pCw6ruCemi3aiBF5m7p+T4YfPEXQryHbn+Jwl7JNf5Ww7kGK5Gv4v/E2Fliqf5L07m/AopZZaU5ULLwJvCqFkrwPkjmHkUdTkIhRk5/8cdsB2g4S1okpSKsbgLlTRphUWrEu0CfD8sbnDcNeZUSlIlsTVYADOMcW3MFYguln5EnkqJDqQ3y4r139gxuQTqDJpnPHLNBg0w40f0+QqKmZatAX1Qw2XpXVIpjmHFClOFiuLgsTfSmYxpfjOgyfdhCoujoNT9zCpO4JGOB3RiDahDYkIa6DKnIA57MR4CROrMxzP/s29wL9Xj0IGL6MNR0CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SGAWMv2ieK2/7euegJpE1Q4w/hUrKGOv7EraMv1AjE=;
 b=crU2b8lvsjlMbpsHx8sCwblDTd22gBZXMidIbg+/vXKVMxutGTH/8v93A3UTxDPT5RPCV6YahE9JnKGz+uMaAM+D3ylDl+PCFb6QYI0KWuaCMuq5QCRvELaXP/N9rwYTrrDZe1BL7yRCOb1ZjF0PAi+i3FUCwHtPCbVB3koDab7pJacbV51H4HWx0DLXSCex+UWPsnccap0ee1qjenJxkiaEkWaHzKkg1n1qHI3fKUg7RqXK9jZCQCoWMmqJqzrM3wNOx2PWRy0dAjyLbb2XVyI+WGdxOY2vwlQWyyd46ZYmlYVRX0qaCh63OVeSOMBlYXNLP/i6gYxFBEA9k0dmKA==
Received: from DS1P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:44c::19) by
 LV1PR12MB399762.namprd12.prod.outlook.com (2603:10b6:408:50f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:25:30 +0000
Received: from BN5PEPF00046987.namprd02.prod.outlook.com
 (2603:10b6:8:44c:cafe::ad) by DS1P220CA0024.outlook.office365.com
 (2603:10b6:8:44c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:25:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN5PEPF00046987.mail.protection.outlook.com (10.167.245.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:25:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:25:03 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:25:03 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 10 Nov 2026 10:25:01 -0800
Date: Tue, 10 Nov 2026 10:24:58 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avNhekBYqiiZ9IM2@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
 <avJidXM9yQOX4VBJ@nvidia.com>
 <avL016l_xASN5paR@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <avL016l_xASN5paR@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF00046987:EE_|LV1PR12MB399762:EE_
X-MS-Office365-Filtering-Correlation-Id: ca06cb32-3698-40b9-50e6-08df3f58005f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|23010399003|4143699003|11063799006|56012099006|261021135927099003|261021121427099003|261022105027099003|261022075727099003|10067099003|261026121527099003|261028144727099003|261009223027099003|261102123227099003|261026140227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	6S6QdI1Lq8ryb3ctJ4/D8Sx0+kYFLo0cV1gE4MgQ1VCSZfRHa5ZoLHmDZHie9QnEy3WcC8hhUOoyrJK3mJUeCVZKxTEXtpXrEaWxmv0e3HQ7COUJQaTz8sKsATU4WTWVOGYk+hOzl/EN7+XGRcSxgkTqbhOsnfop6IoUW6/KPXxjcaYVOsZTkKOjJJfy/CR3H9g5JaL3ceVG+riYF0Rem9oHgFsxT11ZzXjOryK0F/Q1hhDa4migqSIxXcGdOBG1T444QFphz90JCtb2Kj6Txp6gLpE1oQFwEvMJ0DpHY1VemCtHdvcgJXJGV8lIFCuh/GxgPZu4gv8wAVLsSqx57Yvj6N2OCSGTGU/A19c2m8pmfwcDP9dijpN1myXAZOwFTgfisiWz5aQnKemGREtPx8zTs7ceYOOGJhJoXGDN4vlvmGgw3QPajz/vOcYs/CzTEE9HX3xabzq5bT5E6p5kp9/D+TU04fYqu6+5XGV9s6r5HgIq4QOdOZDA5KbSW+QNvaKr4aMXFlqUB/DtFZw0GUaDXTlqW1jtjSifoRAPKXCbk3FHb0e4Eq1BMS+GuyKZy6FVL+GGSxvdzScYCGxoFaj6QpUtMoo0tIvG0LljuBCOEiV64+yXIWVPia9fNFsBlzzxWnJXlmt2Eb3V8hhR8vVq/pRo49hRUuND3bhb/xnlkWM6YMxJ2QB/hH8Vi+ertP9HSfe2Xk3iwgpXrV9y8w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(23010399003)(4143699003)(11063799006)(56012099006)(261021135927099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(261026121527099003)(261028144727099003)(261009223027099003)(261102123227099003)(261026140227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V9xa4ytZMB7MaVuIbrpPJNHNDDilADb08ROUavpEVlCMEhSqto16sJRjO69o6vlong3IrUtT4rd2u7OsEdYYnxm5xw4J9Ok4ecmorGDTZISNqbhK/XhTLfCwLCBDRntB01cSHpgPn9q8HBzr/wa9i4Oc4JiseFw4wO6fB7EUyHVMYip37B2T/9xwDAuC+LxxEPcWlAJ0dVLAlzNkwgbaLF2ZNM67DE9JXpyMzbx2F4cxgpGFznGIm5XfTBUBX/Fna+u41M+6CLomSyUrY4J/ouqYYcjVh2OJgNT4zHsEKa8uVx34ikM1vtYFezFpTU20TCTCGfu3kMFUhML4hlm8pY8+tMEAClTQpFdgWBfwXApWLyhek0E7h89hLqaja3NZpRW0SlCIOhIpNbMQJSKFe0sJfegf/4fobBN2ptbGFmVY0/eWHrrOj58ZkyrSuSrd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:25:30.4057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca06cb32-3698-40b9-50e6-08df3f58005f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF00046987.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB399762

On Tue, Nov 10, 2026 at 10:41:27AM +0000, Mostafa Saleh wrote:
> On Mon, Nov 09, 2026 at 04:16:53PM -0800, Nicolin Chen wrote:
> > On Mon, Nov 09, 2026 at 10:47:46AM +0000, Mostafa Saleh wrote:
> > > On Thu, Nov 05, 2026 at 01:06:18PM -0800, Nicolin Chen wrote:
> > > > On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> > > > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > > > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > > > > +/*
> > > > > + * Two devices are involved: the aux device bound to this driver, and the
> > > > > + * physical platform device bound to the pKVM init driver, which only uses it
> > > > > + * for discovery. This driver keeps using the platform device, as it carries
> > > > > + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> > > > > + * the IRQs.
> > > > 
> > > > It would be nicer to have a diagram or so to show the co-relationship
> > > > among different devices and drivers.
> > > > 
> > > > I assume the regular arm-smmu-v3 driver is a part of the picture too,
> > > > when the pkvm driver binding fails?
> > > > 
> > > 
> > > I can add some ASCII diagram.
> > > If pKVM driver fails, no aux devices are created and the main driver
> > > probes the platform SMMUv3 devices as usual.
> > 
> > I didn't check closely, but would it be safe to do so?
> > 
> > Is pkvm aware of the missing SMMU device and handling it properly?
> > 
> > When pkvm is enabled and the SMMU device is supposed to be a pkvm
> > device, should it not fall back to the main driver?
> 
> If pKVM fails to init for any reason (unsupported layout or non-coherent
> HW) the SMMU will be bound to the main driver so the system remains
> functional.
> 
> However, pKVM will not be safe in that case regarding DMA isolation
> as the status quo.
> In Android, in that case, pKVM clears the FW (called pvmfw) that loads
> the protected VM and authenticate it so any protected VM knows the
> system is not trusted. This part is not upstream yet. [1]

You might want to double check a dual-SMMU case, where one gets
accepted by pkvm driver and the other fails and so bound to the
main driver.

It seems the pkvm driver would still pkvm_iommu_register_driver
and carry on with an untrusted SMMU. Would it also clear the FW
and mark the system as not trusted?

Nicolin
