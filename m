Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792522958;
	b=nFvMrutgXFTtinehN0t2c9JszAyKGH3zoyJeSlfW7fGrhRCwW4iFh6/3zb18ao/1+eBB
	 eLAj0ESp6dEP04hRuEWBlgToQfvFPHp1xld6K24k99tSj1/J5Jw2Iwd7hjoyMqlre9maS
	 uSp4BweIuS4bUPrM9Jw+aFbVxP5aRRcIYBDsI+4X28iArKtcKbnA7Mn8Im9xYMcOBcLud
	 Jo+Haln2UtSvXFsOwZVW0mRn8xqoT0sC2xz+ZHDHiEwxfpSJKLXF7PzeLybGDburgkVlq
	 NRA6L/fGgMFyJfLebUnAmKYnbma58hSXshZL24NLpluzkPEFIK8QmUoyFIZOUtTaStg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792522958;
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
	bh=o8b3OgxVByjyZ1QTNSKv/fqFxFO5o7MmOoJFw3cjiAQ=;
	b=iFoiIVDenqrQzIS+eyRMT5sKx1FjWbR2gldeQOpAnPCZc+eo1OtHyxUzTKXwFINM/81k
	 u/RxueV7vgZTDc18WB8omhSDsu1HPThHkeJSGtrzgTvAXtlNQVwN8tKqvDDUT5jZH65Cv
	 WdMtMGp3u8sHHBk6+xMyzFhki2H1+GJWS4cJei3GgyGuTQRI+46iw0TX9ZV/JkGbLwyvK
	 gWUnjQfO3qC3RBS29TClgamVX44I4olpfWrrdwEsBC+fV/gzULQMm/z5c3Ps7SoDewW1T
	 gqTjafbiTi0l4U1w0Bf+nee7XgoGaqi/1wkUWz0JhH9UAAgNvmNLUnOP7IpOqn9kTnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="qK/ArID0";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.65
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC37B606A31C;
	Tue, 20 Oct 2026 19:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC37B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qK/ArID0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgvrYkvz7U9kN/2kHhh6hW6JWSRWS8vpZymUsO0NGEpVPmyIwlI380AplcQen8JbEl0RcDGmv//0YaG5vvt9fx1ZSlYs0+fT21Y5ehnwrCSmjBT7VVHKFkTJdtB4QsyPwFUodLgULFXZ4RXAvydnSL4NCtZ3SOE/I6IDB/qbJiNAmuQYf3otuu6leEW3A2/GBe/J5q5OkACN06ppk1kVRhDsO/t5iJ9U/0FlYi1t20rNd3KANhGUbEZIXUEHPw/RyFelSfhCYFhN1wLI6G8hlJ+wv351WNPeedOFPtgD4JCj3VaBgglUhc0xeEm3k76oqHOLSJcAGQx9vpwzSyIo3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8b3OgxVByjyZ1QTNSKv/fqFxFO5o7MmOoJFw3cjiAQ=;
 b=cR6Jotktc0RMVbLwb0LU/Vdyayyvt48SkFnVrSFVWqX1R5N3elz10wg0sHSdZAAprwqjbdfC8nW5nsVNf3SGQW21rdACGU8Q1agpKGuZFLKQjDgppRI9e5QZ56P8eCtYpN8fgTPohG46naVYVTIYz/7K1JvvUWErL/XSGWyqw5UFWlJxX/WsVSbDKIkkqXmG+YWhdaZR/mDytlawEL8znDphUlKdR6E5hEXcqU6oxdugYIW0nONMMo2d3bwWqZrXRUUhlgsvGlQFGD18xQ6YuFeimUSGRQWvBfGUWiEoAj+ZK5iEk5ox5uJnO5jJlv5SlwKaEliIkQFIou1+mpE7dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8b3OgxVByjyZ1QTNSKv/fqFxFO5o7MmOoJFw3cjiAQ=;
 b=qK/ArID0crEVyVhrZaLJI/x5Rw5zzKRt9/qHxkMgG0cmjDT3/U9Y/fp3QEYWVQwGPL2OYEEyaKY2DVOsb1Tr+HREvFZL2/NjBhZn8N+WoZP1I7mTpYrUcy+I01L44JYkG8pqQvq79Ibb66WSga8LndSuar+prRD5NpV08rmbC9sP5s8na0yBEiM1zeHTln7fQF9jieeBaZcL93GEt7XWc/CJhaoIkg1+HO9XGmOR7e1G80yTfHEuhIoZYEfYGdxSPayfUqNgDeDRnJCyBL7PxZMTkj0EFWags9gi4vPrqfkH6KqsQ5T5uqc6TI0RIzoV9CnZ9036XwAPb2WBaUSDmw==
Received: from MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24) by
 CY5PR12MB6623.namprd12.prod.outlook.com (2603:10b6:930:41::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Tue, 20 Oct 2026 19:02:33 +0000
Received: from BN3PEPF00022BCA.namprd03.prod.outlook.com
 (2603:10b6:208:23f:cafe::60) by MN2PR01CA0055.outlook.office365.com
 (2603:10b6:208:23f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.19 via Frontend Transport; Tue,
 20 Oct 2026 19:02:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BCA.mail.protection.outlook.com (10.167.248.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Tue, 20 Oct 2026 19:02:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 12:02:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 12:02:09 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 20 Oct 2026 12:02:07 -0700
Date: Tue, 20 Oct 2026 12:02:05 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>
Subject: Re: [PATCH v9 03/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <ate6rWNtdS/c0imU@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-4-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-4-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCA:EE_|CY5PR12MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: efc73460-af18-4fee-cbc2-08df2edcb2c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|7416014|10067099003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	hqLynH+0A5yq+nCYlJWB0YL3H5zv+KcMh5i0dxbxvMKoByopMk8GafkcCOBBVYPBZKmW2dgWo6Yqr3gObrmqrK5O+yJUqEOy6S+HNUwW3bjHeI2uB8hBIQB0FcjC1lV67mIlTVGj6BscPXsbtANiHysasEFA/mEkq/J4EQbwQTxoiRFBSWMeMvv03tv0FY0aWLznMVWN3zrHQbrVWRokq85kuviMebslcFrFYfedYvLtqVc6CLz22AJkHdvIcaSPFk6SUmRdnRcwJAn3QDTxp/5xdrwKP78xp4TWVaV3YaeBFAePRu+2kArOBgGTiZ1I8NJUoksuXiAHbWRYzD0OEtxdW/ngg9Aj9qay3S5bql1HnRMQZD4ACayIkSTDqyYKFrlfrLIXL0DejEKEygKh2vaBJ1arZtTNy0qrgYe2gP06eSItyJir5zJnTp0ZvPlQ3loLR5lLfGnXJjHxekD7Z8YFb0ZMbmHGYa6K/+jktG1kRHVka+UnC/1+ypwe6n2s6xz6SRhCPAhzc16N63nB3oDcvYNHMi0s6Uv8hbLXL+8wXk+Da0C5etJLFZ0qDgH/TtX9yWyLLeNoPemYTOdmwu+hM0HjiLFg6SrhtsBsLIqLsX6p418wZDQuBeHBDfhz83IrdANgy9Q3gJzW0Id5jzN4kUE7SeZEiDHJVRFbufvkKNp2lH3pyjUMJh7UBVpmTyOW9vpDa/NI6OqibJqOgg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(7416014)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	//W+e18MRb3QY9C2Kj9fwIZG3lT8FrkiYXhRSkWHC+9ti54QcoraZGHWeWWx4MD8gE+ZJ0YV21BvuokqPYxLshNHsOMvD01TrcTcPuxq5XZh6GFBxZkJ9+9V2g80qzdnzBGD/zLhQ8yxAzQFHHOm4Yk7kFTEt0K/3CJXJGtp/4L6Er884mAhadHz+BO7leOSU3J5AEzdg+YENdWk3l4xDKHWSwvIHIeWlJGze7roHIyUGvyipAScwMjA+aAKk0akwNdwyx5Fe1JoUJ8KrC8ZtkrA/B7MfoO3wyzVCyj5yCbC1bZrcCnXQM5dR6Tc0YYqzmOphWDXhkMYR2/8dXba6gARRjTh4S6EhiNjQiSeza50s2+DKkIG8D7l8JYsDrTMe+DzzN2e1svpHeOEpt63gwt81zapf3eAH3m6wxGTFj3Akv/4bOkzU85CenquDlmz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 19:02:33.4742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efc73460-af18-4fee-cbc2-08df2edcb2c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6623

On Thu, Oct 15, 2026 at 08:08:34PM +0000, Mostafa Saleh wrote:
> The hypervisor SMMUv3 driver needs the same IDR0, IDR3, IDR5 and IIDR
> parsing as the kernel driver, plus the IDR1 checks it depends on
> (embedded implementation, ATTR_TYPES_OVR, StreamID size). Move them to
> arm-smmu-v3-common-lib.c, which will be built for both, and the IIDR
> implementer and product IDs to arm-smmu-v3.h.
> 
> The two drivers use different device structs, so the shared code is
> written against ARM_SMMU_OBJ, which each compilation unit defines. The
> kernel maps it to struct arm_smmu_device. Static asserts check that the
> fields the shared code uses exist with the expected types.
> 
> The validity checks stay with the parsing. dev_err() and dev_info()
> become arm_smmu_err() and arm_smmu_info(), defined per world next to
> ARM_SMMU_OBJ, as the hypervisor cannot print to the console. The
> disable_msipolling module parameter is passed as an argument so the
> hypervisor can opt out, and cpus_have_cap() becomes
> cpus_have_final_cap(), which the hypervisor can use.
> 
> No functional change intended.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
