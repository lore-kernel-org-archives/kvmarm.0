Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF224488211;
	Tue,  1 Sep 2026 17:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283157; cv=fail; b=QTCIJs/xViOxAZoQzUsOLQMSKEYnUsIUpir7GXkm7VfY5MEg6XAZ4ZEO71qZIp7PGJph2rVL8nma+U+QZ6rryEgO3j8h3r3Hl+NTDPrZMVeJYP6eRCBDsHw38S1o6FbD+LST2YJ3UwffRaUO8fgsvTqqVahV3BGbrLQkvpkVDs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283157; c=relaxed/simple;
	bh=pSUNtPf7pte2Uglb3XTVS5/4TgPjU4svIoCQTcxuZp0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSpTk9xyizI7NKbjoyw5lsbNPmylzg98b2sg+MUZBKdKQBZH4QcdWtDccCSY3DYOu1EVUA5R/WQEVeaKOMjIlQGIpMKlTqInPFEuawTLSRowoYaZ9fS8dbUAblaPgcg7aVRyOJ/w/zuhX/KvwNcDHcpVlgjwTornlpN7yukaM7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZPfMiZXo; arc=fail smtp.client-ip=52.101.61.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZPfMiZXo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydvSIX/ryypsRdB8DXtGl+vRPphB1udWgkR4jujdNfGjrfizpvrAeSNaAiMb65SuHaebnjLYBtBd/xCB4uIiFUCffi1tnGNZeP5y60ewyNdm6+RMQ9Rm4F40OwnPoiIuJDB9J3GKjECzjbFVUMQWE6q7439amvryDKylHTZZtIID89KgNbBMHfc0hsIWr4Eam4kIqDPwjo/t7sFqvVwL7Ukjpj95PCT+UjT3AtsnOJCIut/ketByMWB1vAgfq3VvqTTXiJziIqD58mlCAYifOwMl2Ah7lX8Le0ad5RRI15y0w78W48hNPq4p3iiFP5v6nv7jDHgKXlNFK07FIurujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAVQ0TJ93CY8h2ybSXsxvwv4B6V+ikyiH86YZsaq4A0=;
 b=lkfY0bTUjCvRicDVR1TKCwCzY/q7d35YblMLDjrZlolmxnSwv4Ub/Bhc4YXcu35pkSehypu0pID0g1fgYrpv1GfZukHadxFZM56MQPj7/t49DkafQ8v/PyNImfCUbQKiWV8prrcrDi4SrxJUNsoFuzRDOXnAJKUAxxsnGR1FpxB8hPnRtZyimBOwa0G5B04AzyyV6w3R4FHZ3wytxG5Aak8/aHJKRBHSeyFLuDdZs520gj7yI+MMT15CtN5/JmKessBh8tpOp4TCYiv31J3MSu9lby6l4LcZvHZzMAmRIdH6pCkML0135gpTyc1KkdpRcP7EMT575nBPQ9wIVz6hMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAVQ0TJ93CY8h2ybSXsxvwv4B6V+ikyiH86YZsaq4A0=;
 b=ZPfMiZXoSs+BFs1k8tc44CS3Htm3zgS5+Y+/t+rskffpaQCAdtF4zsuxSu2Ns4K55xGC0R7XB6Iv8mK3eXkbEhjBDal7cAWKCPaxfedZsXUC5ho+jKahX5+Vq/JYd+Rn3mpttTxl+9RY3Z3leHcY5cALPi3G0MLxFNWovRyF/IgIuguGKvE8Gp3/qOsUJBo35PbG1ht7qlykfIX9IAJr43/3bcPvJbBOwlGOKiBuT69VlAHde4f6Zip2IseZ/qNNqhDdc6vAjEtVIBcxjKdlwThy+wC9SMTnydMO4/Rj+YPI0FkSjEz9ADEnhBKtujwFyYqewH5SU7KHZlAgudqPgw==
Received: from DS1P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:44c::17) by
 DS7PR12MB6094.namprd12.prod.outlook.com (2603:10b6:8:9d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Tue, 1 Sep 2026 17:19:05 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:8:44c:cafe::ab) by DS1P220CA0026.outlook.office365.com
 (2603:10b6:8:44c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Tue, 1
 Sep 2026 17:19:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 17:19:05 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 10:18:36 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 10:18:36 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Tue, 1 Sep 2026 10:18:34 -0700
Date: Tue, 1 Sep 2026 10:18:33 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>, "Robin
 Murphy" <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>, "Steven
 Price" <steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	"Will Deacon" <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <apcI6dnRaGRNdzN1@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <apcHoHKGoI7WNFXp@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS7PR12MB6094:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a96151-1672-40ed-bdaf-08df084d1ffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|23010399003|1800799024|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+BohfrBwIFeE5vj9QuuZkHY65txW7zuWZS/1aGKBXArDcWZY7V9m9oCC4PtmwAUMppwVa1zu98Gx/0s9sdLy0ciQF58RSbDtZa/MglvbIiD/KeshPgY+4viS/yjjXX+CKBKEyU2SMlsX2IAXBN1XJjCDi1i10sI9DExosnhaJiVTOPAzlBxc4lHgTSSbXyu/61z5RsJWOakoJyjYDFmmrD4DagCgnDRtuFVgVuAnVVN4gyJLvBmRcYiznLdL8acvA4MnMAeyI4MssMJ64WkKyMKz9m4oZbPzueou6CCGT4ntewxDPqMGVqdku6LcBouyMUDUezT3YQD4rGwVUh8Qi6lSh+Clj0Jyy3vE5h4cbWhcX/axgUf2fKDWycdnjXyw2r4W/qfNyTKsKoxlFdVt96AN2elhHfskzYhZFrcz+AkN8EZecw1cZ2EURqZg71YZ+wqbIzgCBjjuMGewkmzKN0VOsA2DJpubUoGaqZ1oF4Seet6IltjPdR0V2lxS8xKb+gtTauCvtTZEKwSv3anFJ5fuYrz3pgU2o1XJcp1b+YctubQ6dZEfMXSF7Q2cRUiYOApGLuEDU73VCpk17aJRLeRcJT6w+dFeaE9Clkq31z3ogypzKfq3jDxOHYgIXRHzeR45xLygT9LLDqC9eEBQL1z2ZYTHZNb/541XjqUEU47UDWv/1mShr/FVMuZIwcVMBnOomRmSdiMIxg94BYrJpg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(23010399003)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HruBIGFzd6D5eQUrI0/AX6ItOIyxt+lotmIw8Q0nif9+3Hd+7kSWRHV4T7HVTVASVDJLpVyPdvUkXHgZFC1cz14zgr5U5pzUrnfnlYloVQhuwlo2WQpBAHwHTb43Xhllef8v13FvtDmq3HjjBLQzaqhyjPD09c5kMJlh92TTQNq0gXwecbNuqm8v7CHt14kx0tzOMpVW22wx+eF7uCivmG6giSmAiZVlsRYGFLAN7YymtOMUyeoIBV2vu+k9q7Xzfrwp4H0IWLf3oz+9uObpVdY9Rf+Kjh/tsrgalcF9kwhyReZi5Owikvb2SNOWDBBnk6kh6ZC+W9HfSk6DY+jsommBu2uaoamO6n5jcWqEpcEdMdU5gJ3ZStbD/DfGxWzkoHZz+QoLGJjek4P+juTkw+vWdQajciS8TlFdMH7/JpYeCnvYZ91FeNn1ELMy+3EG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:19:05.0690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a96151-1672-40ed-bdaf-08df084d1ffc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6094

On Tue, Sep 01, 2026 at 10:13:11AM -0700, Nicolin Chen wrote:
> On Tue, Sep 01, 2026 at 11:34:45AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
> > 
> > > @@ -463,14 +460,13 @@
> > >  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
> > >  
> > >  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> > > +		if (arm_smmu_is_realm_viommu(viommu))
> > > +			return arm_realm_smmu_v3_init(viommu, user_data);
> > > +
> > 
> > I think the realm vsmmu is going to require a different info struct
> > than the normal psmmu case, isn't it?
> > 
> > If so it needs its own enum value.
> > 
> > It would be nice to see a draft patch showing how the real vsmmu works
> > on top of the RMM spec for it. If we are using a viommu object then
> > non-vsmmu case should be identical just with an option in the info
> > struct to not create the vsmmu object.
> 
> Actually, the PSMMU-only viommu object in this series only adds a
> type with no viommu data structure.
> 
> I've drafted the vsmmu case on top of the series, so it would add
> a structure reusing the same IOMMU_VIOMMU_TYPE_ARM_SMMUV3 with a
> flag:

Oh. I replied too fast that I didn't notice this is under the
standard IOMMU_VIOMMU_TYPE_ARM_SMMUV3 used by non-secure vSTE.

That doesn't look correct for a no-vsmmu case..

Nicolin
