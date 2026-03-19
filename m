Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012024.outbound.protection.outlook.com [52.101.66.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5553F0754
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935876; cv=fail; b=jCDSok4lpsMqCClwqPBGw5BJT0n/OgPwu2UWNfW3v2ZzTbAdRLXslrbCCOOPuV51ZLpSNt3DTH4OSH0xGgLXbVPJ4c0dtojN9Ghdk/3qsSMIpQ9UwCbdVq64zNGZNMuBNEWAA94bve172QsgjiF8vkglupbWoMdrHJyfovTBkTk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935876; c=relaxed/simple;
	bh=SyWFYTTwVW1IhRftYhWlRUUkLNhQSRXVqSEyZEeIh0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iE7elyKd1M5KisHpqaJz1c2X7E8/kuCtTiKYEu9eBp42Na6/JIn/BU09cdCG2wtbFfQXmp3CDovqZRSX3KqXGIoVFM0Q7C1VLQ6SwUTo2dN3y2a2vjqY8BNHIlfeA35e6zO6oSaEJ2q0qbQuo+AyaeHW87eru4Shewu2ku8LuvY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GpkzBBan; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GpkzBBan; arc=fail smtp.client-ip=52.101.66.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GpkzBBan";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GpkzBBan"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CgKEGQIKwyuc3OTaBlOWH30pBZgtpIvlgJNIcitPQXitl+QL8CaNmggmb3hUT58Lf/gEPBi9zn29gtUR/1ymziE0l2Zy3gV84TZ4FntGk/QOD9XXEv6bcSjtleEb0e9Llziecxu+jR7bz+ab4LL7aZvopORjXFlEl42depXPy3kDmLJYzhYaSra4LUKAdGzFdPi5bGE6SPdeEHVSBGXfqHNZbDq8gkV9jChcTif6f7jhZ/8ru43Ai0pai4azHOGLnvYfrsmU3y46vKR152hUBT0zrNQBNWjB641Zuh9MLRPmgwKL01CupIlbBLIJ204hCHuUaHWp2suNJZOY96MZXQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mh41h+E1eoTbhBBJ/geTtMosTpaDNwpcIre+P8bbi9Q=;
 b=kj9r7yFG+Ja8FgfxuED2l9fxxrevZH0an3VMdlwBr1wTDGctT859qaFugkoNtMd+uZl3BGd8+fTrVwyceoCuBHyrAmOQbAE9mNRPXJ3nXxfXWQuzAYKq65Mfd1QjM+lkZ/SoydPVA/XTej0dsrI6593Yu6UnbIkKZZhvQWvqIJkKyRv2j48JZLg+b2NMqbR6mNs0iuQyDJC77maR9j0hMhM/QSW636NwkYnjuFTtHqEXdoLXx+aid4kCGkZgAxH3UowNoCvPM7V0rjS+JKWOz3CCJYOufUSYfhqy2NLf97hptfAQA+lEAKc0Vd3d/oQASYocLM84BBu9pr3ftH+Jsg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mh41h+E1eoTbhBBJ/geTtMosTpaDNwpcIre+P8bbi9Q=;
 b=GpkzBBanOwU2sFuvu2UycS+2DmiblusXces7ZGy0MwKBckkYCnW6Pm1piSRAyPyP/7shjJe82wCzpsVUmFgAjUv/YlwlUgRbWmoJZmvvaWYUsb5KstP4d/cb3kjhI87H+QFwhI6UGHoS9ELFQaHC9cO6TfH971e2NATEIpkCiYU=
Received: from DUZP191CA0039.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f8::13)
 by DU0PR08MB7810.eurprd08.prod.outlook.com (2603:10a6:10:3b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.17; Thu, 19 Mar
 2026 15:57:48 +0000
Received: from DU6PEPF0000A7E0.eurprd02.prod.outlook.com
 (2603:10a6:10:4f8:cafe::13) by DUZP191CA0039.outlook.office365.com
 (2603:10a6:10:4f8::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:57:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E0.mail.protection.outlook.com (10.167.8.39) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Thu, 19 Mar 2026 15:57:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OdHhrhau4i+UwNHkI3e6bP72aXuIIezL+Ld5maNmpmCsslJUnqGTDcbR5pUvnhmx2q0fHvg4l8eQUuSSLCygADFXE3sPD25JLyOZTut8edzT27dOUEHxkoeyUryPC8ZvDNdZyjFmO0Fwfu7INke449ebxGTQB5NiOnZvyeCd9zdbOuyCfmqmnPyUfk5xd0PCzxDmojjo157YV7H+0HU+8k7IeuZgH0i9lSHjXAywJ/TFNpb5alnOmWIA3sGh2WlOo8hRNLRu23uH7YtR9MueJZsz/jLUqsKQCO1pDxWv+kxfg5zHKosAVIirY+NrBpYshLBFwXVa1ShcMcuEaJuVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mh41h+E1eoTbhBBJ/geTtMosTpaDNwpcIre+P8bbi9Q=;
 b=WawHLUTJR+zwYg96vM5KmpKdpMhgfVLtTC/KCixoeXtnK+/bI74e3ot/t/ddP1TlblIg/qbOYYGRQJ7sgasYPI9jRVXZWkg+zzsyBy9TtDC3zH1Z7xvqgXyeXELK78Pypeixzci/xoLH/Wg86ZtX0KJNhg115rCtxDViFvBKN0tYnNEIdQ1of3T0pidlVKpfLzw3RE9Ua6f89otjXkEvd18aCNXknPnRz81bY/SeupE+754KAAFhnsOZtE7C+hZI353+LnUVPZDHmrM3RGPqElg4u7WnrC9riOvadrnudisSVq0oQZ20sb5fyj3QrwieOiAYtEtHtobje17T14UW2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mh41h+E1eoTbhBBJ/geTtMosTpaDNwpcIre+P8bbi9Q=;
 b=GpkzBBanOwU2sFuvu2UycS+2DmiblusXces7ZGy0MwKBckkYCnW6Pm1piSRAyPyP/7shjJe82wCzpsVUmFgAjUv/YlwlUgRbWmoJZmvvaWYUsb5KstP4d/cb3kjhI87H+QFwhI6UGHoS9ELFQaHC9cO6TfH971e2NATEIpkCiYU=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:45 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:56:44 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 27/41] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH v7 27/41] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHct7j7xvexZUB/bkqAiZU+P4eoOA==
Date: Thu, 19 Mar 2026 15:56:43 +0000
Message-ID: <20260319154937.3619520-28-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|DU6PEPF0000A7E0:EE_|DU0PR08MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: adb9bd61-b301-4149-857f-08de85d04486
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 AdFMx4zNzL60wnvbMIfJPx5PUa0/oSs4A7gCUa/eMlChgbgaS9EJil6ZieNaBA3rGxBGY5czN9rUtSa2KbJ5orLtzwmcHcn+SuMB59z0HT4nb2PeD67156NPs3gVMwkegWmAm8ZO9O7KjXQLNygyM4iCInc7RN+5zqjE/7COEsUBsAoIrH3Elyc6Fr9ocRTiYZq8f5gIJEgPXcXwHr2I0mL4LM6FF4TZYqZo7Hq37VKfmuhj7ZOoqyYzmkx3qdG6L+oV65WhrrpGOABRQOq7z75Og0monVWMuA+nMzjaK43eQ0/xZpZ7M5EF6BCWBnYAvbrAnHMaCgzuRLwmcjkePiQnGZDsNkfL18n80xmtTLSGaLGYwxyj1R8PjlZ6CDpySmW5OtdK9zMbuH7U7BfmVRGnLJoVVJ8mGPDLmVuzL+DsHwEeMs8yV8gndNmrvg9JdwqtUJ9DASnTLrbs5M92ueCYAbK0UL+7EHqD2V6sJsZW6p6mh0wx+PbDrM3YW2x3Ki/zf/ztr7E7d6TK/OzaoCqkEVndTQCRia+YCK8pC+exHRZQT6aGYOxJzY/H1NfcqlAxXL1qrNkqoU9I/Yq1MD6eyT4S9FQ0QDtjKC+jy9Zd0Z15ZORQznUYQHhIicnQUllFzwiSJQog6yIxThKYNAxCc5Xe1ZfnbwrQLJouKRzJby1VPIpuLEkOFlYTrduZ5MvP9iWlc4RLkwpchgmqhLsATrJuCF/SV3x7FHHUn/C4m+8v/6lWgDyR48FaWzZVeqRuToq9nFJtj/8X6kn/kHb2HSvmUAWG1aPgq/00IEk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AS2Osq3d32Gg7x3zV4yPyDQ4Q4R0RMhMf5WKI9vDNmh+L8VLUOzj5vuTqlFT9fcU/3xh3JzvvoF1BhZYeRRrAWUTHlD8sb5FCbAa5uYFws2uHrLto3fL683IV/ZDtl8qp6MxHpE1hEq8I7Q2SEzYZEnUhO79JbGxyihXsa6ZVVnAIS/PWxM36O7cdTCrwUmU42Bj32Dsmc9PXjh1kFmMv8RfwtaNvCynxQbkZQuNZmXCWrlpdS2OTDKD226azJbjpmt7rAz4tEQqxgwwrzknDnh6lxmvIBuBgITrEYnpSITFGzEv+pIeY5lGUxYUFsB/tK2UUx6wen2bTLVb1/lRDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ae5b61db-81d1-4fa8-1180-08de85d01e3f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|14060799003|82310400026|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	upIz2lW70zdpbbmvsE8BOMH1pOXDC/P0CJ7Q0n8OqRBal68SEXQBlabz0DwvmGLXGYAbnJj0HuOpx0tyXkupXSaIkTeZqRHR9XiQmEbf4vZPT0YoH4ZNcjLsSKIOat2UIEBSDEoXiRFVKgcOBLidDOXr+BscgSd9EmWv8ret4p6LB62JDJIqnGkdcS/zDLvZDhglUUek8KL3qGMbWCLXlc1MhsJ8mB/JGMQK+aGtybNpvISfSxMCSz7dUUGJXUyXKHflHRsx474AzUXC9VGlbm4/H5ckO8PcbfBk/uFCwQZByGqtIpRJVgQ+02VBPZ2H13qAulJQuXD2erd8W0IR7W+BH8396ggzpylCEOqSqjwRpQyqod0uNdKXYk2GRh2DHmuayMSi+U4RRwGnVjF4V0n2JO4NEpES0o/iEi4w+75soM6ev80BLEvRW4tkMuKmQHZb6lCfF2+glYMRDKWCzO4UZXu2DuhqRjCjCEgK1T1/roKSs2H52HFsnvyxcdCviKek/Jq+ha2a20iw++o87dKld0Km7D3aUWIIPv6fNNjUCmu+2WBklXPNLFexfaUgblaBeuqYhuuf3BtzwZlPWXXs2eMi1/grm/OWtGxc0m9cdk4lbCnj489kcdUnUdOIoIi2op4TEioYH4PowER15vxPFMcVDq0bKmLbli5+hODXZYAX62lpohg+D1U+g7LI8zYWlBigzvLcD1c514m953Ozr7wWX5sRF1wzjds3J5mVy8bkOKtJ6UUyz2uldFiePAOb59ha24qU6CwhqY+YHw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(14060799003)(82310400026)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zXCZlSdfLTOG2t9G3kCPJ7KkhZJn2Z6d9z7kPDs+UMLARxp6Qr4ceR1fwbL1nkaGcFXNUO6F6QTIcPQPSJGZ3LI7YOQhdLRREcofM6RlhULKyedcr7ChY+dDQMcmx/oCmgJyNZiTniMrEjiyW/YBsOFCKGctyPonftOrqhKHXK7AD6NMh2uIOeOTyNz3gN4k/csKxmZadI1kl29iXxWaSHPJFkmQpTmDfjUFcxKiibuCOtYZIZgCMyBR/RCuci/FcW1eLotpvM51sM+WHbylhqXLR24QO1qk2Tu66z7AKZIPwXgnnVjnGkTA77eaPkKoQoMbpmfzE/thHTa5M4uyq/jCdwbTEwPwU/pwoXZ5gVbLivbD1sdjtUlKGiHDUUSbO1wkiPKW0cg/AtE4vtmhKiJ00AHMDZMkuqV22M9cara78YoA9T0XmLcYLzD6l8bR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:57:48.1544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adb9bd61-b301-4149-857f-08de85d04486
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7810

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

In order to use vgic_is_v5(), the kvm/arm_vgic.h header is added to
kvm/arm.c.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restriction will by
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 22 +++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 032516783e962..03d87d9b97d94 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5514e0c4e5cfb..b28ab0efde2fe 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,9 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_vgic.h>
+
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #include "sys_regs.h"
=20
@@ -1479,16 +1482,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (vgic_is_v5(kvm)) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num =3D vgic_v5_make_ppi(irq_num);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (vgic_is_v5(kvm)) {
+			/* Build a GICv5-style IntID here */
+			irq_num =3D vgic_v5_make_spi(irq_num);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 9ac0ff60aa8a5..1e9fe8764584d 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1
