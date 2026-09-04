Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013048.outbound.protection.outlook.com [52.101.72.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40F946D57E
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522556; cv=fail; b=llLvVqzITQ47pL8+/q6GuKctOXitoU17v0XusTmdpsjFYMHOhj35l0K0wolfJIslOC0yTiKppziBYs4U4UKAdzkHSDu5HMzfQv/hjVjU19XXiYmgHO80KzEoavLYcedHAy+vbP+o4qrfs9NXz+F8hllHZJ1zYH+zC1CUXEs2mEA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522556; c=relaxed/simple;
	bh=g6tvZx1LJgHgXuT3OeDIMZr0dk69sfpSA7Jt8KVwJBQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n7wHfdOO4xzabHAg2GVFw/hHf2uPQkm4WXA6SVN9ZCBuW9GHYarpRdUHaWT9p6rjH2HLzoq0Nud2aXJq6s1myx53tCt0d5uBQlbR7b0TdTDwU/sK/SpJHVhnSkLc7zyh+WbW/6lQS7sOct03nwLn6PUKOKfp/BqFdqYqcvEO3xI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=brApqnUv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=brApqnUv; arc=fail smtp.client-ip=52.101.72.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="brApqnUv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="brApqnUv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f36Fbp/JaR9qe/DFT010WnBIZlyF6N2vM/Rlo/GRYRCus+gJiepsSQlQIzTliBwnKM4rkmmjVQK8arNIrIDeK03hijKfxV/v0kbv/+uKS7ttBlMIaaLykHAfMPR8JUTTxG6zqDXgkwM8Q8IZ18aUIBzjOt+Ylle/5PLUrBOzoY4w8RhmK7AOFATVaYxPxrxstZFhgZTainLMP8vdLTgbNoc/wi7OKPbYisN0iZe0IbKcstnPEHoYtKMMO2RKI42VtgWg35HydITkGgQTh9Ut/msHiEmdWHuGoCmL1RO8oGMR1HuGBVOPPMVNueoWHya1A0CMyqvp3rVOKE9djiYXJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=Gpnem5Kq9i2alLmKIT9v/0+6AVVJdE/F2XMLg/ac2q8iu6aGpx/xFuioh+Cgbs65w0hXg3cRO569tr6lYn++Fy8f2f9IxeV1N5e5qToXA12vaG+Ek2ywHbuT88DtnUfuvSX8pUmAeKBpaLI5cq9FrSLVPM4nikLWutrcUJZmnd1KFGO7pOJsptoaBFrtVLGvTgk9UC7lKtgkrTg2o9ZhZrhlTx7AiySadRq+ZGhbQPKJ3pzpysPRsPz7iy36N7iJifDSDwfHg4mR+nBd4qiIsyZq4NJ3vyOWYspDrgGru5zllczscss+9fd8P4qV1YCRr0wWMt0GYtB7P2FxT0ipBQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=brApqnUvtrSSfQ3ePZ1jYB9txJkxXSeojcKW/LD+hyNcJpVPhAO5h/Dv8ng3neX1q848nquR6KyMgyzEOE0OjsOQ762IrZBbVWxjHTOuFOR+bQ+8NTcEdIwW9U3YBM0OV4PZWCfFId92dJVs9l4djtdokzRGaWn+E8Eea0OlIgE=
Received: from DUZPR01CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::7) by PA6PR08MB10443.eurprd08.prod.outlook.com
 (2603:10a6:102:3cf::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:49:06 +0000
Received: from DB5PEPF00014B99.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::e) by DUZPR01CA0014.outlook.office365.com
 (2603:10a6:10:3c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:49:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B99.mail.protection.outlook.com (10.167.8.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:49:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kl06e/5ftZ4N0TaH0JwkYuZRT5iGDqnXR8fmaB6248by0nF6m9zzLyHWHgW+s+HwBmxV0u4DFeryImhXcQM/bfajNdLfWVZ+uo4mGsO4Ss455lNVackdsccTVaBCAFn77V2/93QpT104VolNbrv7SZEo9KdXNXeHCsJa9p/aVtdOCJnT8RWrBFxj/lFk2kTKe2ou5sYsskUVZrt05ZBRpxpth01tceBeRQH+eO2whaUlf3rLGG9QSNYTVbLhwAL9CrEquxCd/GdeOGUVwMV7QxCdVrRHIAR5wbIIhy9xnDONDwjbHz0itezbrY4llfRvlIMU1fPb/xN9Gd5bK9Q3Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=VOgN/0gYgZFg0AwuQrd47a8ND+voC0L1kCCQm2+OZTOAoJRpGdaGd2ThnnBnmFG/2WIfsuU6pNruzc1URhniXdSUW3s5nDPggV+PtfrhaDgrjtz9P0xXWcw4XXyqeZXKmEmr9xgJNq6U6FqCSlTaFelq2MAnbpSQd62OjbGukhMz7iJ042/MvcweahELqyfg7CMrW47zf9UwrvhDLgzsuuuNAPBcv0YA1GjchSzuBaOGqbaVyMMRwKlL7VGF+z+CKk35D9v9nfyzJX2wRUxZueKmlXIQDFgo5L5az9hFaI+Qm998p1iCHmBGZjHuqK/DwQ/Mr6wwJ/AwOD84gA2icA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=brApqnUvtrSSfQ3ePZ1jYB9txJkxXSeojcKW/LD+hyNcJpVPhAO5h/Dv8ng3neX1q848nquR6KyMgyzEOE0OjsOQ762IrZBbVWxjHTOuFOR+bQ+8NTcEdIwW9U3YBM0OV4PZWCfFId92dJVs9l4djtdokzRGaWn+E8Eea0OlIgE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:48:30 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:48:30 +0000
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
Subject: [PATCH v6 28/49] Documentation: KVM: Extend VGICv5 device attribute
 docs
Thread-Topic: [PATCH v6 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Thread-Index: AQHdPGNO4uZ1dD4RMkG9K3+zu+ujog==
Date: Fri, 4 Sep 2026 11:48:30 +0000
Message-ID: <20260904113404.4051341-29-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|DB5PEPF00014B99:EE_|PA6PR08MB10443:EE_
X-MS-Office365-Filtering-Correlation-Id: af49825a-8ef0-42c4-a912-08df0a7a83e2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 QQkrIpIR8OZWYwZqc8s8qZ5CSyDjQNuV8jBcBk58ouql5wRzC2tjyWrtTAv2KHYic3nt18kwXdNAaJDKgIHeRUEo+LnOgRFIamhYq8sgpJsHhw3E+NlKO/Vf5gsJbxJ9iZVd/oyLPSxbCrLOQcUE5vMza3OBXSdFQU4naAzia82Zp+Fj+yYc1xzvqWNY12cioCI+brZrSJhunwQL0GI/ruyJYrmBH9ZhrCUcYcwuUXhCLaXJ2BK/C6KazzwESsUOryRuna+4H065EGfKGTQl5oR1lQBo1A4fjhULHLyg1iI2BRVjL2MwJnd4/eVbrGFWg6ffSjUBT10BEvtvpzB9IL88UsLnguqQ2iSQPp82Ox3CCLxsfUmMnTF0QQTsvg/Dligfc3zR6BXcb/BcgPG7Ykt3MQiPo82rkniKKGi6OFT6OejPHTOnoHwIMVr9xDDVqVMTKc4Ux9G7qv/NyMiUmuBxWWYQsXzn389xjno7imjEX5THCZkOtsk1M5YjQrodReCD+GNdBgX/byi3OuDp5saJTfuAkWEpnRR0o1NhzPOX8zO2FY/BEVWHmWRfUXNUvEI1ry+Pi1uju0IaxZdBkOaDuOrT3XWY/dcKeFLNPdI0N+gOYXUpmoIkBp1Meokr+UBRKXwbQa9BzWmHFIGZ1/521UaSmeIvqpgNcK5vdu05Y33wFhQZXISqsluey7hdFoOnAocZ6oGqrGFi0Q4M6nWwjlJkgnlQH76ZnkvczLQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 xybHZLwyfPpAdXcuIPnxQVMXoNc1/9sykHdhoTp2Gn6gl/yGC7m/4RO04syEfSUkXoFqAccXQwGxxDyJf7+bI/3+JLW1P/ulrj84Mpaaln2qsnHBroiroSehKYv+JgnIrl3+sqTCrp0Gz8a02lssL6gRQwLthIXcaQkWjoB2dQsap3ytHycTXW66QkiaNq7QWm5mvT1j7SLejt8ZDAKrQRtxomlUl6XXfmiw1GYK7pMlYeAzJKKnITZMrElU3roUvSkIAhY/zzLFIwbV9E7PgGLqdGAATvIU8GIzLxKJDqXCt7ZD6xb13zeTrHP33vf0v3nXHxfTySxHqwEVJJ4OTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c1598669-b145-4b14-2d86-08df0a7a7094
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|1800799024|82310400026|36860700016|14060799003|35042699022|23010399003|376014|18002099003|22082099003|6133799003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	F6gXMw9ZNMd452yFW+tbwMBoDYn34GifGYlT3vFTBgVxzJGGmxZCN9ekEPWDDJLFOBiMvtx/1tGnHzzR/D4SOEMC8q1BfJJnpr3pq9VOwZXhO11EPpJzNMXoos0zjLxR4HFEdOnfVh2kJJ6EYRecpSIBBwZfzWGHtS5oy+VcM0v9lpDDp3oPOyydaS6VjFtzQ95EzNGOv+/0YuqMSzdIGp4Doe5JBpvZIr6CX6VTD3BHP14vP2im8Hx2R26+u6koggtSjGQ78dhC8iPi7IOi0zwnlikG/HKQrlUOgzDOxhMUQNrYj8V5spd6yUjzjU5IyGwStO2Ufx+r2xvaSBNBuSCbH88LIAciIoGgFUWSyNozQAy9NLovduQxKRchcC2RX9aRAVayzGKFaHm/1uwgRhAYR8VXSX341OR84k+WO3oKEd7VRqWQeqW1nPKTWXuTVrQurPtGOtNUsiixSoDmcAiASP84r1P3IxB+PJwXKq/eV2EK2XgbW4ZCHOceZxns4XPmwILIdAGHff/3gCQ+X/dGe6oD4ZEYIwZr+0xW/yJL1Zpom+Bo1o00oO5WqsmAfyDyUgUJyG5FYKBqCdycKpZhiyTZqaFSh+bIKAypZsVGsQfBLr6Tbdyy15YzAona1yWcTDI3lBKSEHbJqjXlTKPVLtX1AYDt583twmp2zlQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(1800799024)(82310400026)(36860700016)(14060799003)(35042699022)(23010399003)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BhEqA2CXXs63UM2twcijrVqDMRc847/vUl2DU0cvjfCQ1z5uj5ZFKPxYtJX6jT2QQvAMRujmoDqt6PXi0eHgbxhb2Hn8E90GJzji0o8oTj/twPvcZi16lPK4Gm7x3HlamDq5ON/YW5zIJjBM6W9ZSva1lO+cesDOOGQQAoKmZ8UfF4P5aeDIbgWi42fbAgJC7SHhEBIagdawpw/hMyiroIBQadZTlkvtKnhM02zYtLNA5ISUqKM5vBfZ27evExpvac/kP8Pwjq5nq+U63wUTiLXJAF+cyF5MDH7wrPuYxvfp9j+A1b46JEoXWCtucgzcBj7Y2uq+Xg/RpGlbQxrK5J52guULmkfGzXVy+2lWQXoFpXnHoLHXENotkz4ucP0wLD2SDqw8RfmbJ64+xC7vXH5mXwlLtSMP4t0LXsT9cziVPqvawIQlJgrSGoPs265E
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:49:02.3831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af49825a-8ef0-42c4-a912-08df0a7a83e2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10443

The VGICv5 documentation still describes the device as supporting PPIs
only. Update the overview to cover PPI, SPI, and LPI interrupts.  PPIs
and SPIs can be injected by in-kernel devices or through KVM_IRQ_LINE,
while LPI pending state is driven by the guest and handled in hardware
through the LPI IST.

Document the GICv5 IRS address attribute and its GPA layout
requirements. The IRS region must be 64K aligned and covers a 128K
range.

Also document the GICv5-specific interpretation of
KVM_DEV_ARM_VGIC_GRP_NR_IRQS. Unlike GICv2 and GICv3, the value
describes only the number of SPIs exposed by the IRS and does not
include SGIs or PPIs. The supported range is 32 through 1024 SPIs in
multiples of 32, and defaults to 32 when userspace leaves it unset.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 70b9162755c7e..c782ea4d4609c 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64 KBytes in size.
+
+      Setting the address of the IRS in GPA space is mandatory before VGIC
+      resources are mapped, as the IRS is responsible for handling SPIs an=
d
+      LPIs. Failure to set the IRS address before the first vCPU run resul=
ts in
+      an error.
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+   Attributes:
+
+    A value describing the number of SPIs for this GIC instance. This is
+    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or PP=
Is.
+    The value ranges from 32 to KVM's VGICv5 maximum of 1024 SPIs, in
+    increments of 32. If userspace does not set this attribute, KVM uses 3=
2
+    SPIs by default.
+
+    kvm_device_attr.addr points to a __u32 value.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
