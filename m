Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010071.outbound.protection.outlook.com [52.101.84.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FEC31283E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375348; cv=fail; b=nXrgOE4663xzw4+pZrv0y2Nc6xjNiu2dSWmnJz/+L2oMuAnL9jYBIm9UYB+sRrMyuoX83Os5cpnkEndMX+Hm1C+mYxQ9Dveqyu2iRj6pcL2n0BVF8Ooh8qLH6tpVmX/2gua6dCGzizSEh8o3lwKRpXndTHaAdA8koueC9rulE2E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375348; c=relaxed/simple;
	bh=LD19dG1uJ2dZB292q/LFIZlP1OvCLRN9EcB4A8mfwCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ho23bd86tKfe7B8RTD7pEYyAci+4edSu0Hxv/KeF1qIKG0w/43W0Cxdyteut7tQshodtGPbI8vR+gXhIexVMXKiWBUCAecoU73TdeB+vyrU0tv6qW4rtpCUqFfnIzIYZjzn+tiQSAMwdFBGx/sh/gNGsrFNAPydPuERqlU8/u60=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nIn3gFhO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nIn3gFhO; arc=fail smtp.client-ip=52.101.84.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nIn3gFhO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nIn3gFhO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=D3XwvoKwmUkzJEtiF+oRXYXjFP5ERKVllEenl0MwY7NH3R6p4tYQ4mT2bICpBh1As9vh4bpHRKtgORfwLv762r0XgeLlrWQUDKdUSlrihbpVTdTOwt8l04RaCd8OKXMTrcKlL+wxjCJLmkCc5RiUKEkHRriOgE7WSwYWd9FUk0VTc6EDgm+P7W8mjq11k19zj0Znx9xCddv0QafTs+i8bJetgnrtvcM+alPeQOLm433QBho6nRNf6ne06J2b5bD2qxxMEtZHDhC95JetK/n0/YOInaF9GX8JqeumeK0gGPKhIhao2pDTLsWu2zHo1QAqqsXifC39XU76QrXbqR9UXQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYr8mkrdW2cIO5LNn5bqYjb9AuV44LTES7mG7NRVJO8=;
 b=nlwFb/yWuMZBno2lwQCnaB/5tq+1cYk5S0/2seIXaPZ+7EO4suB22yO733lT2k1/W+g/ut1DgvLqJjHSKRPdv+St8OMbnFO2cOR4WheteOnW5NNMLHtNxV/KOUqA7UiifhI2Z8zhbeXQc6TuX9OwKQ+v7xsRoHaZiXmyY7d/X8J/tTVFvS9t4jsIe3bK9D8EcYFxYvcc/sOPeAAKjI10OqTQ79oDVg3yyMRcTLrXBHMVASQFONfnEaF/k6zOmyKp6pEzLhl2haIMeu9cKrHGIa50yReVlonroFo7DIWNpGo0ZvvJDSeGlNMTlExOMt1VWJnCI28Q2Uj1SltpvlrD0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYr8mkrdW2cIO5LNn5bqYjb9AuV44LTES7mG7NRVJO8=;
 b=nIn3gFhOIP7wBy+MxsvgxAZLxZZilFGrhMxdr6w5IZLWwRAGqudrevTbT3Ofo6fwrtLxkp7LQZPYbqVv+t1TbIkaBwVRdRkCUdCnJ1f5mXea4T9wrmMVn/XxmziCRlTLlfRRSfo+1/HyzOdyg5BjZK4AAhk1YF89mgV4oaMtt+Y=
Received: from DU2PR04CA0220.eurprd04.prod.outlook.com (2603:10a6:10:2b1::15)
 by AS8PR08MB6405.eurprd08.prod.outlook.com (2603:10a6:20b:332::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:55:41 +0000
Received: from DB1PEPF00039233.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::8c) by DU2PR04CA0220.outlook.office365.com
 (2603:10a6:10:2b1::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:55:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039233.mail.protection.outlook.com (10.167.8.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Thu, 21 May 2026 14:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmzlWFr3ucOrqSo4lJZU176z18+rGfdTv89h60WQbgPwNJT8XwbugCYuRJ3zobI2fjQOVQUME8ES7FUA6qAu3HLQWZE+P9/SY5Cie5tR5tjG/OvJA//b7ID0XX01s0NrUrieqU+d//M1Xcwp8gpkbrDPwqYIHQDnUOacApAdligmOOVqwr8qGYlflLZY9DNYRSkQeVjOXrO7m1i1iJVS5dfhTk976zATL6yb7vvmOsgBWfaRD+Q0TpmoT1MPv6hQoxv39MtrNibcS/S/8Wis46YY+Mmw+hPx6UhXyS1R1fI+okU0Ci0cXjAPU6G2fO8wCyZE+/SuFMZMUtHbUZRwQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYr8mkrdW2cIO5LNn5bqYjb9AuV44LTES7mG7NRVJO8=;
 b=NqWxeZdqYATigVubPVJpDqYUfsF1n0XrYg7QOKOEM58U31WrB6b3iZdsYi1aynt2NpQt9aSEsHxPN1SvxAWWTX9PhH6lpMJPvAP+idkppC9Yp4Uqp2rgTB6Y2wf+1PRs+aXevn4FKGn5H7oyW8OJv5r6hLnBD9AvDRyWKRzTQejF40iWwvGOP/GJGQZ8Gwm+MfemoeCIZtyeaoWJ2xhhMLAxsPqRcEeuWNOoEpTEziS6MeIS7AykCx7n5wnszRcYwtQmRcYgblPTcWMF+1QU6HgpjaM+p4/fJZPnLkOKoVqXfp44VVe+NWduCk/LZC0Uualrby1WFDU4MAS6IB8wwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYr8mkrdW2cIO5LNn5bqYjb9AuV44LTES7mG7NRVJO8=;
 b=nIn3gFhOIP7wBy+MxsvgxAZLxZZilFGrhMxdr6w5IZLWwRAGqudrevTbT3Ofo6fwrtLxkp7LQZPYbqVv+t1TbIkaBwVRdRkCUdCnJ1f5mXea4T9wrmMVn/XxmziCRlTLlfRRSfo+1/HyzOdyg5BjZK4AAhk1YF89mgV4oaMtt+Y=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:54:37 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:54:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 16/39] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v2 16/39] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHc6TG+37TEaXm1bECtK0RRlrUSzw==
Date: Thu, 21 May 2026 14:54:37 +0000
Message-ID: <20260521144846.1899475-17-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|DB1PEPF00039233:EE_|AS8PR08MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: 523c80f2-6428-419e-8677-08deb7490754
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 46YdbtfpW6a0Huige1y82BMunVEgmLM33fOvXa+QDItFMWJwYeiM/9z08/hFXzTyccGJU1oqACQEsseyFPsU4uyP6VzwJ0Q+wmGh4W83xY+8bLeSymlu/IVVW5eQ7N0Tw1kS6XXMackJyEalKM+ftpOJ58U4Cb05LqSMHpCxJjWFyQvGrdhFlrdMtG1Ad+tRHw3Dg5VuOE89Mu8q/jJDVvTsJc7RSL6aY4JDcxrOzr8F71suIwgd3NpOzKN6EIoggoZ3SUMSJ+K14vAd6hkr1XpPDSj8Qqs/L1A6QlNROhkGbkKL8x7LKYCgYUelnU8v7gF2THv1zzY0YPbCY+jyvJ3vSa15sNxkYnrGa3cmi2P8Fnx3gcO0WLrNZQj72Y/Y+VN3QXbgZcBqlFW81gKq85XqIuWJFWzWRxJs5OhWd4KoDdgPVnP9AihWQCfYypohACYp42PiRGWH2MXw57EH6m8Vw6OREFxECS91oiyIHuZ9lUHCd71EOwjl/5d54Pq0go6t6R1XZL1u/H9NIDL9G4Znsrwi6WIZI+xh/v2IPq097KrX6Qk0I83brnXwZL4aXWj/buTEaqhhEl7Q1mZ7z3uZ4tsT93KsLx6K9pfJsTelKA+4k70pfVWSTroXe63F8lI+GnqjYemZvWy1ckAQc8hWk3FEt4sovQ+KDSINdoKwFFnAWu0fnIgU/Gqn4uNbdsv+utpf/2iRBpBE+QQK39ZjSQIe2o2X9WWRkTlwQ6KO8Od0Jo+ooDxISn5r8nsv
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 DUlLgzZNJyCYXBTBYVl0tFohwZXhHqNH9tThH5y/DfKvPPHytdYGMoN6cChNYK5Wylt++/nLtIkBPJRTSb2XCCcV8ZtzQYHRHWokFa8Bt2l9u2DLmbEZrX3ZkOOpwQkXhezk+z7WRkZBTuy0yYzTqMgs1P8mDO3nc3XpL5uUna34EV/WinKM1HVVAFy4u4dCKAdLfbQFpArl3ZAqJXG/wgwcFf1YjcavI6Q5mn8oSsWR3ysHbvbnhILw6MP6dW/YgKooLUtP5rxHNHCAgAtLoRpTgNGwTv6ofm70FsCAgkRhhNtpT5HM7nc4dYyt4dDA/K8+XvnFiXalLX2ss0flVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2842ce5b-297d-4fdc-aa92-08deb748e124
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|36860700016|35042699022|376014|18002099003|22082099003|56012099003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	xvv5SdKyG3jo86xOukA8zu/IM5fTO6V0dF52jWPGCjnzOmUHzrQqa/EuBGxLGxVqxj/nJ3BbE3V66m/ZhR+1cTp4Rld0oDRN3RdVb1wvXthIsal5RmNpFZX63UPNXenbh+JRKwNpsS5GmiSDBnAPzjs0/6wO6ZxaEv+16zJfat7yzszFiQ56eMbasjIjQgALdBolNTqFOyKWTcM19SxiATx5ret/B5HyvUs7d4MqPpj3Sv2jA+JUNVGTFNqrEA19b48NnR9pswUWIrhQ0rai/pom8pIL45Eku3i4c2d9AKgdbh/L2boCXeLuGMYcM4rabN4QyA0R88iAbZVD37ytybp7i4ukJlYVFgYJBZGth8x957vB8vn158hpMu5ZA3hWNC4efYNDFAWffJZGahe8Y3c83ms56kTyNNbmrGuCY1GMOAtHI+3+/jVoodd5LgCLNDqjbF0f0FsU/lrpxfR8nRE3dRHqv4wp175MOpaC0jYKkXcVNKRyHzr2gHKghP3r3IOinmojHck/uigth+3gkd7zMxERSuCtceq/CYmPQn/KphChCeC+MKO7wiGnixM0mIT2k9ki1GWbbDy3KM5L5xz9sGHpDwYvZF0reAAezaGpXnJMHs3dM8UxzEaSeHKjniBwcrAhbzZF8pjloQTpvm1S5J4QIc/gAldOdowZg+thrgSZL2QNxOanViLTUjhCqDTrvn3YnZjmnjQOMIwuFFONzz9PLmGreZJ4acYOf0g=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(36860700016)(35042699022)(376014)(18002099003)(22082099003)(56012099003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oqizGC06HlRvhO1RITsTImUwFfA4WMryNkBokGJenDFqLs2x+4Q/ZIxtVDrZ7NUvNgHUNhf5bis2xnV0TOTjK3iytnCysapSodv8fGlB1uJWuS4vhxVZaPWLZhiGjBPRyZql6C0FdQA/XaMLU9mMW3aT/1nlJy1NJK56SYPMcx0f3rsFuLOSX08kn+8rEpXHIhTNXYzeP/+APCWZ2xpgyESkW8XiBeSppKWUcScelyS4L4igpcvsWukQX+eDCQGyBmLI6eL9bzkvC/ydDiPl2njQDNgv14XVg6enZpKgnRDarwUHRaoZHqcD2HC0RUHjct6jUQHzdoHRa4Ax1Ib1tSTUnl4rLZgiS9mToUHkx6h2jFcshyV1+iOswCEBQyJ71seUEsWB5IaQ71iloT9AywKcJsWSxaB3NxPlQRQ3zMVQGHRXFbRJnOtOHr7A63rS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:55:41.5591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 523c80f2-6428-419e-8677-08deb7490754
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6405

When a GICv5 VPE is made non-resident as part of the vcpu entering
WFI, request a VPE doorbell so that KVM can be notified when a
suitable SPI or LPI becomes pending for that VPE.

Program the doorbell priority mask, DBPM, from the effective virtual
priority mask before making the VPE non-resident. DBPM is the priority
threshold used by the GICv5 hardware to decide whether a pending SPI
or LPI is allowed to signal the VPE doorbell. This allows hardware to
signal the doorbell only for interrupts that the vcpu can actually
take, and avoids waking it for interrupts masked by the guest priority
state. If no interrupt can be signalled to the vcpu, leave the
doorbell request clear.

Make the doorbell interrupt affine to the current CPU before
requesting it. This nudges the wakeup back towards the CPU that last
ran the vcpu, where the relevant state is more likely to be cache-hot,
while also spreading doorbell interrupts across host PEs as different
vcpus enter WFI on different CPUs.

Clear stale db_fired state before making the VPE non-resident. Any
previous doorbell notification has already been consumed by this
point, and clearing it before the non-resident transition ensures that
a newly fired doorbell is observed.

Finally, teach kvm_vgic_vcpu_pending_irq() to report pending work for
a GICv5 vcpu when its VPE doorbell has fired, in addition to the
existing pending-PPI check.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c |  9 ++++++++
 arch/arm64/kvm/vgic/vgic-v5.c   | 40 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  6 ++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f064045a31aee..46992a6c2cacb 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_=
if)
=20
 void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
 {
+	/*
+	 * Clear the db_fired state to ensure that we're ready for the next
+	 * doorbell when it is requested. If a doorbell firing caused us to
+	 * enter the guest, then we've already consumed that state at this
+	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
+	 * racing with the doorbell firing and setting the state true again.
+	 */
+	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
+
 	/*
 	 * Make as non-resident before actually making non-resident. Avoids race
 	 * with doorbell arriving.
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 25590cf5ebee1..b966495901cc4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1079,6 +1079,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
+	if (vcpu_get_flag(vcpu, IN_WFI)) {
+		u32 priority_mask;
+		int dbpm;
+
+		/*
+		 * Find the virtual running priority and use this to calculate
+		 * the doorbell priority mask. We combine the highest active
+		 * priority and the CPU's priority mask. The guest can't handle
+		 * interrupts with priorities less than or equal to the virtual
+		 * running priority, so there's literally no point in waking the
+		 * guest for these.
+		 *
+		 * The priority needs to be higher than the mask to signal, so
+		 * pick the next higher priority (subtract 1).
+		 */
+		priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+		/*
+		 * Request a doorbell *unless* the priority is 0, indicating
+		 * that no interrupt can wake the CPU up.
+		 */
+		if (priority_mask) {
+			int db_irq =3D vgic_v5_vpe_db(vcpu);
+			struct irq_data *d =3D irq_get_irq_data(db_irq);
+			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
+			int cpu =3D smp_processor_id();
+
+			dbpm =3D priority_mask - 1;
+			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
+						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
+
+			/*
+			 * Make the doorbell affine to this CPU, if it isn't
+			 * already. Actively check the cpumask first as it is
+			 * cheaper than changing the affinity every time.
+			 */
+			if (!cpumask_test_cpu(cpu, aff))
+				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));
+		}
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b697678d68b01..d56e87a0d2acc 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1229,8 +1229,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (vgic_is_v5(vcpu->kvm))
+	if (vgic_is_v5(vcpu->kvm)) {
+		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
+			return true;
+
 		return vgic_v5_has_pending_ppi(vcpu);
+	}
=20
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
--=20
2.34.1
