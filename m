Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010007.outbound.protection.outlook.com [52.101.84.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A43B3A6F11
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522248; cv=fail; b=PNIJ8Wng2m1wr+Z9ydsC3sq7ITGrHp8GfoCpVyBAVMqGfgMWEXhrIEkkxOr5wBF53RndJKymVwVJUskqF4ngCfMybWbcs8fvnEs6jNzRaDAFRfTmHyMGaaPFKIevENhrvW1x41szwuq2114RO8tRFPosUnOMEoNrX0HY+8dzCIo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522248; c=relaxed/simple;
	bh=GbWYqBOAi2Mb8UdX7QdoCNOlcG4JGczWkCmwwZ3zf8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I4bPkhjMJMzJdVTBCi4ph4MkU+lfjNj9NdSSmNFFqWXxt6upIfP4aTxybPZHBtKnMdZw7im8U0DNFm9to7W5FMdSrDyqKZ/9FaI4gpFuGjsH2FEB4PR0ZLOE0UTaR8nnJBDW2/fECe71SUlQZrb2QbqAXH4uE+Zxg8gl1Qz1pYs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nxdAE3Qc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nxdAE3Qc; arc=fail smtp.client-ip=52.101.84.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nxdAE3Qc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nxdAE3Qc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uF3fByXs0Tgn9TZxcq3vlRWaM3VKKlGuKz63XcVQs64zhO3L0/V7M7cv82dnz82IFWtKsVVlGzOBCLOmlYSE6CBv9syE9PePDu8uow1V+arbkIZSeODsRBIjlgT2HT/fGNKY+DjgraD2TvWmJkyo3qKo2qcvnt4HonsKA7sAtcTBaUqHbl27Nnyy5mhpDKsahnnl+9kLiWoF9dGcqSN9eqtxUbBhhs1lOye0uBl4UjRv4WUth0YrJRIy0xiS26+84TBg3CMt643+eZ0jFfe6gToLH+AOmVeAUTZMemStxmHbc0MjBSCk+nJpNdYmINDvQE2FLthBQpnjaYWJkEdnWA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar5UuuVmiwyiN51bEewjaTLw8asn0vtBlFDtveq4qMQ=;
 b=fLWd0oSTxw8mXyShTOtekcRaBUe1nWRCfNxacxkmJA4dQGbi8iybdGo1bcwiMUXPf41Pdbczk+b8niIpOlNaSpxJUQV/YNWxCR9SetZ+oEON2LgE2dy1B7qLwQggrj0dYWcBPr8jCWSV9BpQlFaBEIXhs8TFZvWmP8zKuJMD0QUT7OKH4wmky6H5Ag0aPe7/W/Pa6tmwb0lIQZEXoaxLX7ZrQ2/cn1oL9lwh5uwymGNKdjxKwiOIJwD/2T2mdpvJWaXA/0mkM/mfSMUjGJdo7uFwGqMcKGTduEiJVpciojl78/DgrGKR4hdedWn/F9K8/PQXxSwLZvR3gJmRY9T2zg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar5UuuVmiwyiN51bEewjaTLw8asn0vtBlFDtveq4qMQ=;
 b=nxdAE3QcL9MYXMkGRRxtF2maCsdeO1Y88jh4SRyBPANj274Zn05XBGXnoHjhXpr3MCPhkaes3nEHlKbGNKa6x11xc9uN3m57rZTf5EIvhZyp8exeVTDfHOLhqMIYvDzqGlcWQmGSrUxkAQTyXqe+MNvVU2cVAOIFgvpfnTB7l6U=
Received: from AS9PR06CA0642.eurprd06.prod.outlook.com (2603:10a6:20b:46f::13)
 by GV2PR08MB7954.eurprd08.prod.outlook.com (2603:10a6:150:a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:43:58 +0000
Received: from AM2PEPF00070CF9.eurprd02.prod.outlook.com
 (2603:10a6:20b:46f:cafe::9e) by AS9PR06CA0642.outlook.office365.com
 (2603:10a6:20b:46f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF00070CF9.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:43:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBQP1NvPQ07OEy5YQxd3vmgGccFnQrVaYOiVma5fuWPzsrZBJ0+V4phvo3HFpyOfn1LTWduQDYfkguzBQdxnHEAnZppbVMF1Se5uL20npe4m++xiFa1dNJ/W1nSs9ihGew26/04i0rmPBhIOEM5N2CFvJlZhkJISmbwuS6rjCuaIdcianE9L3IwxNhXURVFqlmvnTDf8y42T0Nnau4R+VRxPbrEKxsCMBoNpptJvXPurIW0FseA9Eh1ubgAODoejkbDistok/mR+gU0szdu4NYzbpgORprCgisxtWef1WXhPz4kDfETDsWIAaJM5oHMjk1XpwLB/GFdkvhHTW+sShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar5UuuVmiwyiN51bEewjaTLw8asn0vtBlFDtveq4qMQ=;
 b=IoNKHMCER6MVroVh5HOS7RM00FcfHO8g0Rxd8iaiXobiWeFP2pYOQifgpzdloO8qq4D10RbWVrkKnwXUYX13dCdkrR+Mc2mUsJ91Pj9bbQLgbWC4I4l9CJU27vhs17QkqKdgwcKk8MakrJaTKMGAq2E8I4jQzMUqjoFO9cq3pw9wmMk7NLLGIUzMe9M4uvnGvHOG6jUGIakOBP+LIPNYLDt15x0wgNPzCo45Gx/E2pB3Bc8JMjXYjY0xvu5bzemZk6jEJWkBY58WOqcVJr0+1/EcTlIpTBknrPqSL9RtQ6QDBfU0hn9vaQ2DxVVAczFKHLfqkI9dv0XpV9a23yRoaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar5UuuVmiwyiN51bEewjaTLw8asn0vtBlFDtveq4qMQ=;
 b=nxdAE3QcL9MYXMkGRRxtF2maCsdeO1Y88jh4SRyBPANj274Zn05XBGXnoHjhXpr3MCPhkaes3nEHlKbGNKa6x11xc9uN3m57rZTf5EIvhZyp8exeVTDfHOLhqMIYvDzqGlcWQmGSrUxkAQTyXqe+MNvVU2cVAOIFgvpfnTB7l6U=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:43:25 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:43:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 18/49] KVM: arm64: gic-v5: Add IRS IODEV support to MMIO
 handlers
Thread-Topic: [PATCH v6 18/49] KVM: arm64: gic-v5: Add IRS IODEV support to
 MMIO handlers
Thread-Index: AQHdPGKYrWBNOwipWE6+1qTpNeyEgw==
Date: Fri, 4 Sep 2026 11:43:25 +0000
Message-ID: <20260904113404.4051341-19-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|AM2PEPF00070CF9:EE_|GV2PR08MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: 62e99809-a669-4361-1ccd-08df0a79ce73
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 XR/crZVju9O24grnn/zrjHS7PtS3eBAuFFUfD8TAtidDMbduHnT2SMA3+BVPUPErA/Mw8+xOsBNir1cOx7eZQzlp6rGaunNqezDErZgT9iC5/XlNe2LTu1xBgP6OQoDbxwUvsxxxgJlj7j8h4pdgxKGupscOzvTjz5geQyXczK54dWTer2kzUn38D1o165a2aBSwTjIApJ66r3t4U+WqAqDFuHUIO13H5o03R554nsJseNSPKuZmWZQDRPfpGaCX6c7eLGJymnn0jRiguqLXmhFUydqCZNCo5OuReWe38Dvpwx+1PD/U0DQSouwepYO+k5VYTJLZawoAedgDoAJ5xa6GKxGQz3aDKNx1h3GDGQOJo7ZQqAr2n2x606kSxB+0IVtIa8WbpWoEOflfxAc9ZBANkdVoxBM4XifrvVi2IKi3j/md7xocs7BER7Zr5mSaD30DdMiI7+XBMwhj7WADSsihQc29sBzohxnOxzPu+q60b2b/zxVErr85fHX7IQaZXMpplt6hcGndicfCDjjthvqm2MWdqi15Yzia1ygP3ZdqnFyOIq6Da1BJsHIxHWNk8AHmQzWWaQvmdgTsOqQdljIsDo4MRZVRfwt/7a31Q/DRams5rC1bIONu/fkEKr0VO+TNan8Xhj3wFN/OtLXdVeKkUaRcd+ZJLRhtS8tJ/dznJyLAJRMFR0PcbrJCIfOzQn3C7/A41z2r8nYjl70k0BqJ3gipB6AVtrVJHPyCObU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JzRL6KkJOUAFqQ0vhhtrvsEC/keTv/X4nATdLrmq74ZOLjL9u4eJFArD9sQmO8wlrEZ5Qq7TfqDOJ7ko8yeAqVYsQlkWkZ0dCpOvElQVWnsu5l753iEbrSFqfUooQsPW0azK8lNZRCajMWjtO0e9Av8IRAXlPqSiYuTh2zwzJqLxZaSjz8nd9aPaqYrU3nEXtNpoYQD9rgzcarP4iKmXwWQbbjSrpccwGUT3H1sfriaHP2U9yR6IF44pEunPSrVUpL6jj3yHLCMLMrvrKMUZSrVitSqvsn8PmyUlH+qKC00vQZRuhKd81GT7mnaw9Pa0sZEXuyrlZ2Rylw8o9tbRHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF00070CF9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c12a2b57-63c3-4e83-f77b-08df0a79badc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|35042699022|82310400026|1800799024|36860700016|376014|10067099003|22082099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	kQTfD867+zV824yrWX7iRyIjLuHmrJkDtZZaHVkKOyJxmD+ge+RPAFp1zXT/Q5oJpMpUMXcQAbO09gl9x4IMKKneMtXcDWV0vRjhBuWI2nFEI4XDnm+MjlWq5prDV1wmkf/1OwQc0BavVmAbNHhP8qk1kGpxoFVW2C/RivevWYrC4c21t9ngsek+lT+pl03v/rG1VLW8Cj/PrQuGdK7GYQkT7zX2ab3RBn1VR3iO4NNU8ugRlyOS2aR6iSWFmTOcv67Spltxsxlija8hOIfbsk/gBjkZE2qZp0d+Ay8xrntZnkJqaTwQG834qVoBvYoHF0tZN3ADgn98v67Lv3WjhkYwBhNNxGAf1f4YzK/SYkTco7Wsbv43pFBjC00dteYJsu52tLa6NdMxs6+0WS0y8LXjNPvm3pkUFdiWOpMRIsSYSRb+rX2lTViEYzDCRiqHM5GUH0k6YB0r7qr9wjxn3mVKeENDr7gd6t6X6btnMhku306jDrovHxkdv1DpCOCpo+ja6rZtBJYkD1ODX7v6rU6+hJ/P8SIhhx+/tGo3QoQBVghu0utXS/BdKg8ZfUYoUXTlGC6810c7oWmwxx5VB4Uvdr9qpe1pOPkmZhMjx0uS9VnP2k2BMm/cS6M9iWOHVSwS5nvr/mJZEHxoHVHP5EepZtW/cT5egM8ryafk9Gs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(35042699022)(82310400026)(1800799024)(36860700016)(376014)(10067099003)(22082099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Pz+pH6jz87nYrVFArnnX4Z2IhvapuKZrAHJ6ZhGFvC05jbn4kKhME35wa4DJvsKPZNRU09y/3sFEkAGwBS0Neu8lAs2cHSaN2PeuaWIKO56aDqYXph9EFFZnnCSLI+mmo07zB76Ddq88MPfITNovbeoMALVDS8E2KsGATra6jITngzRTOiKISVk0h6RyCw/Y3GNVj8EN5k+wtMjcU7k98kkWOYgzKHUJBW0dZhyDKuTBIjkoVaFCV1mVep7ZMxB9SUz4mKxtjC2CUWXEwP5XRRSasNRLd1LSbg2s3AmHyMG6Exs0D1Hn/sACBDp+U7nnuc2/M4xkM6ULFyj1j+ZIjrxPjN3FgL+vIzdGCBIwXbq5zrLji+rFbQHI0UzuOtqCmcwaNyBJ6h0GmKc9rU6pgBX++/3fI/B1oszzSnkISEMekIhfW0xKo/3sdFCWcgft
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:43:57.9951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e99809-a669-4361-1ccd-08df0a79ce73
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF00070CF9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7954

In order to support proper VMs (that support more than just PPIs) for
GICv5, it is important to emulate the GICv5 IRS too. The IRS includes
an MMIO interface which is used to interact with and configure the
IRS.

As part of providing the emulated IRS MMIO interface in KVM, extend
enum iodev_type to include a GICv5 IRS device, and extend the MMIO
code to handle reads and writes to that type of IO device. This will
allow the creation of a GICv5 IRS IO Device in KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 ++
 include/kvm/arm_vgic.h          | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index 74d76dec97304..fddb9da0403d5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1065,6 +1065,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, =
struct kvm_io_device *dev,
 	case IODEV_ITS:
 		data =3D region->its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
+	case IODEV_GICV5_IRS:
+		data =3D region->read(vcpu, addr, len);
+		break;
 	}
=20
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -1095,6 +1098,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu,=
 struct kvm_io_device *dev,
 	case IODEV_ITS:
 		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
+	case IODEV_GICV5_IRS:
+		region->write(vcpu, addr, len, data);
+		break;
 	}
=20
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmi=
o.h
index 50dc80220b0f3..38ed730d68ac3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -217,6 +217,8 @@ unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_de=
vice *dev);
=20
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
=20
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev);
+
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b62ae14c6a06c..d894c32d09295 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -310,7 +310,8 @@ enum iodev_type {
 	IODEV_CPUIF,
 	IODEV_DIST,
 	IODEV_REDIST,
-	IODEV_ITS
+	IODEV_ITS,
+	IODEV_GICV5_IRS
 };
=20
 struct vgic_io_device {
--=20
2.34.1
