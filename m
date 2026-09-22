Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011027.outbound.protection.outlook.com [52.101.57.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD2E41A575;
	Tue, 22 Sep 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100497; cv=fail; b=lZHoAxUdNGdwp0uUV9TyVTaIBn7BrVloa31mAxLtw5spDPWhNSm3HJvA8uT7WJ54/I8h/6IDwHQttoUiKWMSvDwOPXUkU69SJsDkcPvQtkpjReyt2d03eMjIq8wF9xHfwDjRgZ2Kz5yANgA44rhTrB+HscbvTujHLHKHS17wK30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100497; c=relaxed/simple;
	bh=clkUJp7AU9dapoTN48M0L2B1nHNe/WL/BYHOO9/9LAE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaZyDw8kRHDHJ5RfrnH92RFKKnrWmcnJfQheDiadNl5VzZkPw+7X8LYg7+Ta2XB6ozVrJIUKc2t3Ny8uboa2plteXKNQNbm8/DR8U4XDIFrNlbgeDOxoLoi/4sq51/sLOl6ySihv9abYOG4ApCHL+I9r67+9eOcwN3H2Rey/Be8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NkPmMGUq; arc=fail smtp.client-ip=52.101.57.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NkPmMGUq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGGd4adTf3dcWeMQwjAKneYGtL3iyWqZomblfzxXN0lxq4PczxurLK4napx9oKnwxjRVIgSA3h8PDywVGhqOyvJA7TTPiutxmtyTgJIP6WCEUr6CLtOLnuqnQSd6a1/NTTETS2X7elyCwF5wG0D1xzI4SdvFU8RXJr6ljlMWycqIE6rznfbFgiFrwphmhJX5M8tu7WU7MLK8vb30SXR/YXuUdjI7CTm7aA5m0Z8jW/Y239vZoNXmLF5isXVA4grTuTGXGEqFbOX50BCkCV8p0xFoCUDRPOWTLPi3oHFGs3QimbKfooW/gMS63WnsOVT5jX/c4ENGudlG58hfjEgOFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vP+yZ6CuPux1IREGIyRsDuJtb/YVOpEFKLWIiLb0uU=;
 b=lhZUFsa2qm4YXAU5dZgYHBiueMCAxqIrGUd+VOvXA0mnH2MzK31bpB3oopjdSvXJHHUnmNR13F4QaZRS8flZoJ8Y6l3FOFgaqv6QYynrmUNlj84qqF3ZIUtVQO1WgxY7GPwNDgAxQ6ePLnatEkky5YWat6n5QghGgMdtj5niJPauPS00LnAoJfizsVjqm0t2iwhu+6aymNCbwahzKjAqhd9rFn3lYP7Q9Vzd3i0QGV8YGFDGG+dUVOp5lB5NBkJE7uLjNEffn0sAhT3zej8BWKVNeomiQV6rSYynMjase+ImMU6KwnRfZLv2LdS6gKrkdcTFT4Ke1/Yu3m3lpYh37g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vP+yZ6CuPux1IREGIyRsDuJtb/YVOpEFKLWIiLb0uU=;
 b=NkPmMGUqZ4YsQIxom/pOcu3HFJHCt2hNvorRa4jY1suS7jy1PiYH2HUwuHd/py/u4yVKP+opAkumsRdu2mYT30+7v7oEUis+xhWMV9OkT9nI7NEUHE61qTbKYo+RIiUaUps5U3EQZpuJ1DKRdTtF6MtJZX/ayxVmpt8CNZaEEOFIw8TXEys3+5ihogBXTaeatgEXMA9eEOGzpd4Q4Bi/SXNwySV7l2P/5N71ZnDRw0/YBhOnx+c+1lcUVUx8C9/N1bRu71z43hn4i1cS6R/V/3PV1ctTHC1Ip21qKwGPqdf+awM5b9w0VC2X/37kpiHTFQmE3J92WgvXalOXjkB7lg==
Received: from MN2PR22CA0020.namprd22.prod.outlook.com (2603:10b6:208:238::25)
 by PH0PR12MB7984.namprd12.prod.outlook.com (2603:10b6:510:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Tue, 22 Sep
 2026 18:08:10 +0000
Received: from BN6PEPF00000071.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::6f) by MN2PR22CA0020.outlook.office365.com
 (2603:10b6:208:238::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 18:08:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN6PEPF00000071.mail.protection.outlook.com (10.167.248.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 18:08:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:07:28 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:07:28 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 11:07:21 -0700
Date: Tue, 22 Sep 2026 11:07:18 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 00/25] KVM: arm64: SMMUv3 driver for pKVM (trap and
 emulate)
Message-ID: <arLD1qj8E+tE2MYw@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000071:EE_|PH0PR12MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: a5788847-d4a0-43ee-0cd6-08df18d47558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|7416014|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	WMb5lgJa2vojHqcsEAqN5I+m77YsAb+W5nLf+WnWP1+KRqa6H7SLsNaRu2ebPgqIJrVI2nKdS1GQkdtFZE/bA+z58g4FoAQgh3Zg9OONu7ddqk1fOsmPmAla6QDMnNc2AWHDUzaKLbWJ+yW7w3jZNV7GDFe3TnhWIaWZpU2jkqS2Adki39URoL/PiCHDNv5M0S2Fa2L8S52Tvz1ltV0i5P9XUhqh/Vnai8X6pKI8v4xa2wlo7U+VRrABmKsGjBIThkmm2ryIc/FQRnJ/9bW9WS5mC8Iqc+1JHESSoFC6QeT6efwX6U7zGQWhv/N5LMRfaoVXHvsYX7refCHxtJOj/yRzTrTz/bKWuhtPyQwOI2yTuCZRmpJaCz9TXvkiuA1OBXcgmgJKvh3HUko5VBMEDz03ftIEe3s692yEPjT7uN7L/Gf227+X7YwVyTKeQyi2iHcWEzGA4IlWacFgb+48EtKOgMEGqk63KYHt8Cn4C3LOYUR7SJ/C/E8AgLIY5/LApuX62tSWg2ct4060yNBaw63YhPDDu1w9r86f2mhu4IVSbMAcgvyvbQ6hBLvQCVAYr8gaB5d+bZcuVk/Fj1hZmW2Ucyf6eMI08OOo3oFTKXpz7KsssIiQK0Qqnh7k+x1jPdDhrqTiR9v1DsCi4XrCZG3QepG7DCuRGp1+xtDUAkt+dJzVeQA4DZzIyDq2mt5X04qRF4x7YTMwno7yYgVykg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wtEsNFKNhHw5RtOoKBmnxwqrqUk3nc0koEBqtgvNvjuclXVwZ5c6KiZectWP0MMKaW42QcZfnvOc1HK2+wKLUIio6gt4F9CbOXxhR6e5kilqRAqpAqhJsqHJSjQrgxTyz33jkJHhQYSn0cfP7o+lZS68eN52zo69IuQ9Y+PgIlKc7kN57P0uctzSfA71560NW7nuh2ZOH9HTRoPCY51SAqn4wm6EJX5O4u/WUw8+e9yuQm+oFURDSwalwj+5g+NMekBOyTvi+uOvSDLjw1NZtKZmLtOCmv0jVaibXb5jFmh+nSwlcxv2wFovF6Qy9kkBuCJotnur1A50a5Ht3yvI82MRDMCn98eJ22cy5sqGp5+mvl5Fov1zT7RbJzw9M24Ei3ia6SaPKhCHBtmnnPqscLOp0h4zCAt5XRhyrIF01Lz+IlPdhwG4otSOLNOevnmM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:08:08.8883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5788847-d4a0-43ee-0cd6-08df18d47558
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000071.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7984

On Tue, Sep 22, 2026 at 01:12:33PM +0000, Mostafa Saleh wrote:
> Notes about Sashiko
> ===================
> I ran Sashiko locally and it was helpful in discovering problems in
> the series. However, it still shows large number of critical and high
> severity issues, I went through them and I believe they are false
> positives, mainly because (in the order of frequently reported):
> - It doesn't understand WARNs are fatal in the hypervisor.
> - It doesn't understand that a malicious host can DoS the system and
>   pKVM doesn't guarantee availability
> - It doesn't understand the SMMUv3 spec and makes stuff up (eg. about
>   CMD_SYC CS field it makes up an non-existent encoding or wrong
>   semantics for the gbpa register)

Just my two cents here:

From my experience, making commit messages or inline notes slightly
clearer against the findings that Sashiko reported could simply help
it understand things better and mute most of the false positives.

Otherwise, the number of the findings is a bit scaring; reviewers
would have to go through the long list of findings to check whether
each of them fits into one of the false-positive categories :-/

> - It seems to look at one patch at a time and not the whole series, and
>   as the series is written in a way to be bisectable that confuses it.

Yea, that happens too. Usually I would add a line at the end of the
commit message "a subsequent change will do X", which could clarify.

Nicolin
