Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010016.outbound.protection.outlook.com [52.101.69.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0408133987F
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375816; cv=fail; b=VbHtgw/yYWrZqXNMckmDVE6Bqec5132s8bbjBhVcE5S8FLrjIGiHCK7GzQrgjS0BQLya7U83XDm1Zr5c2vNcYwM+D30QVcHtNvN3Et+Nz9uzoDo2nDkr3AdjO98v2EqHk2hxFVvwufssya5VWCdLA2Ma+rad0mfPzlhgxw6W15Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375816; c=relaxed/simple;
	bh=VkhdOipL2FxH6MFlsVB3UR6E3dnGs7GFLrbJIBk1OW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R/BTuU/3T3CtKj6CrWEpp9reBZxxYP/LgRBeYo3FCTlEp8ke0GZhQp5PWGkZhRH3CxvpDU59cQ7Zg/mt9XWRF20XxA4wfDYuA4R08wL0DEmtwClk0On5p7ImILglCrUwjDNb7VlgWtQopeIbfcWPlK1tR2lXnJVZtoeIjHvUztI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jGm/5QyW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jGm/5QyW; arc=fail smtp.client-ip=52.101.69.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jGm/5QyW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jGm/5QyW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=VmUrNz4wm9vS7+bzGsHEd33/bjox7QAo2Z4zZp1UBk/NaPle2rMAk1WmCl1thJWuGe1P+z4MTVpgBLZtl1JAxJ/1mkbkct3jetsMPs/kCh5TE5/lnMlOkyrf7q7glbJ1Yv3LzfjUUTNMBHznPRw3kN4o701J9bXlAE7CjlYXRkKuDLM8lSznqwkyVAAJF6zfV1aJGZpnvo6AopwzkARtxRadCFVE7cotJg4+UiSWK2NtTrnruHU23oe2pPIY8ocrEGBo7e6VeKA02lYjiSWzzDTEWJHUENajPswuMVEQcuDCvRreLFUzQuhoFqRaTE//u5vE4zJNoGVIZzraCoLd3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=l0sXSsUfDqhxGJJBi8VpPj+oy/2M8XI9WGR7onM9b2uxlXyyqEDTnZRPGDANPFzZmGRDPav2zU7JuVe43i8iWLIaLEelWZcCqgC62kMupxb1Rxi8c4uEdE2kMa43S+F1WlZRuIhlqYol3OH0dVkDYc9yWgNLWYXGV78pzngr5BHlhW0ZKjkNzWNqcsTwGITdT9Ga7VbeQyJWXdPJFSo0wUSif6IdlmW7NWiYW4XhBNvja414ic+IIoZoLY2/EzYXLF05CO3x/+YLzzdxsDpf96LvQ/14+drAFuFKian73jpe01geJvczRlJtB6hhBQyslxoptkvt/ToNj1iqlNmUhQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=jGm/5QyWNZGEGEp9wF9vw4ySw3UzxxTdFftesK5o22Iga9NU9E+RWxIgOoy8Dzqzq3QhuYYzMEIPwJPRfoxeqGotPt5O8LeqrFgUanw9A1cxZ4CjVsRLH52bEn2BBxXw7S2pHMBTYiUVEd4RtkVRpWpSOpI8TXrHgpZaf1il5Tc=
Received: from AM8P191CA0014.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::19)
 by AS8PR08MB8467.eurprd08.prod.outlook.com (2603:10a6:20b:567::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:03:17 +0000
Received: from AMS1EPF00000092.eurprd05.prod.outlook.com
 (2603:10a6:20b:21a:cafe::7f) by AM8P191CA0014.outlook.office365.com
 (2603:10a6:20b:21a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:03:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000092.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dMlUSwh0hi9AmR3LdjAj+2WtPN62q58cnrhTCdgZxfo1gjLMc+Dk7wL74eE+PTVSanYH1bd8zHfAuzsynO+mkUxmyZYxGPP27VSaf0053GKrCCk6XZtQbVkyN30cmay2YGCvoT0De/YOukXLWgbcLfeqVhsoMEmY755tG9JhUopBPM/cJ9dYYVINk6Lwpzw7WMJdZYNsXICsELLar7oFPTBxGRkyM8J2OSvm6a4Cd+aW8BMymPKwfxvsSmYAiaV2J+vLRY4GTAV1NM5epUV1D16o3tDMFmtaAZyAR3kTYhQBYziZjE/m1I2iKsf2mJDfJRqvIHERqyFtgylrF9cOwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=UAduDLjjDjzkMuoiw3d0gYlvGpaJvNudKzFMmLr0rpN56oq4/d1EoiXY1QcUWjwbpNMHrwrdE/dCX7ILHDwoLteI0XY4YkptQL0YWeg0QlJHbdTPf4Y9xQX5Vn8VuXsuVo6pR0gfkE0X6M8e7rYzqSyyD1AzLjFNE8DyMZyWCG3BMhpcsXvabaUf0tEgveCICLbb2HjqWPu5G+jqv5BDKkHZFqQKW0+5hG2TgUjf9HBmyyZqFitDN0OBdsrShUVQBbdvF2J4rymB4vRG66dDB//TLq+itFDi+Oo1+OT3gDdXYzZw1Nf/y2pGrSaZZ6iNndiJOphJ5a4RQfVMtTEplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=jGm/5QyWNZGEGEp9wF9vw4ySw3UzxxTdFftesK5o22Iga9NU9E+RWxIgOoy8Dzqzq3QhuYYzMEIPwJPRfoxeqGotPt5O8LeqrFgUanw9A1cxZ4CjVsRLH52bEn2BBxXw7S2pHMBTYiUVEd4RtkVRpWpSOpI8TXrHgpZaf1il5Tc=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:02:13 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:02:13 +0000
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
Subject: [PATCH v2 38/39] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v2 38/39] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHc6TLOvy6okmtQ2kiMf8CsWY1mkw==
Date: Thu, 21 May 2026 15:02:13 +0000
Message-ID: <20260521144846.1899475-39-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AMS1EPF00000092:EE_|AS8PR08MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a8a8bae-686b-421e-f5c2-08deb74a1709
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 Eot76/iTJbrgZU7YIisMpZbmpsV5dVPVDhaNtKCiC4emARYZFYT9tf//RHujYy62a3Cdgn73O/bSFn/7CwgjSNTBKsm6NJm4uiCcZpBw5kWSszaz+VBEFr5GvPaB7TcnoyM1bgAYhFDGaiaGKK/FCLCQHB/4JIJGTO+RdqBTE0PCcpK/dn1iuR2huOFNJEMDPnnyN6surb2Jrq27HqFm2o74rmRHlSiJc16nUxuAPPg9ATq/k4WEPRmbGdYiW8zltRqBpJLtbFR5mKSWUoammfcZLDwewtKVR4Ro9MpP+UZiNZvxgGo972USGb1IKt7vbpEUz5Zmw99jGFd+ZvmKlEHAAzk72qkcJ22tozEXc1dZ6vPdob1JRy+bGfZWOeXLLf1gcy+8CpRtdL1JhLPqnWltzAuvMjK9SoSVvTePyf195qrf5zrz1gsKCymchwVUW1EX6ad2OwqdE7I3bOoEB5hY0/rrKfixnFzUifT66+1TLnk+yaKQtrC84crnhzgBxZYUK2eQQDEiKaOSwzLyu9welL1XvqwX91u1yPqornNEKHTogwHFfuBuw4I0lkZfALW0j7MMa9y3yrZcfKHOI7uHnWu/vC+neQJem6zNV2HDsRZGODznao/Twh6Lg+1M8lzKcHXDdyeL3x0zqpZHhTHFIrdq1fwnpTQvQoik/28jCyIixz0jDlMhjWK91ngfjg7740Oyp6LekK1oOc08f/f7PYe/EprqG6Va+hSLi5z6R2p78F3h8zl4OqU1EiR4
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 dE1hss/FjPIw8ggvNOvOyKpZiC8a6C34g0e2mkPZyMBkOhhOM3AuYlhk3sHusTciQTohVL3m8wBLzHruZ/HDTTXyYRXTUIcTtGyFBkIQMPTOywctMgMAcqYfnsPDVhHb7FNJhZ/cJYZbMhpTjnYA+ToP+Bj3pUyVtHq03EW7XFH6ymygZ+FInaXA818JfW9cSXYL+o6Gz8SPx8D6doO+fkDMUKlZ6q47NrUcnbgavMTyb/5CQYaCCfpUtoY+y/82C7sGg/1B6j0/M9QiZv/XSeNc1CPIsWg/Q6Hr9gasrUyyDLwRCRZZc1cmESgiX4I81mq/Wki5neudftJckxhmfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000092.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5ba1e11d-1fcf-4380-19c8-08deb749f0fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|376014|36860700016|1800799024|11063799006|22082099003|18002099003|56012099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mXraG30TNRnPT6g5mpTVzkivvVz8EinQ8UWToEZ4/Vtt4X5PwwxIkd5BctgwDW8PPZunOuV7RcNhUpE7iRuIzzx5LrYYhF+6DELMVFrpkeVqBM4sJ+7E/hQSLWQGtWXbIp4/jsvHM6hgQDQboaOpVK/2YlPV7yu1wbwLleWjPwg8M3PZW9V9SBqN8VmqmwiCwzQa55+Wdc59Vfa+MVh9gt672RDCdRuRtB4eu5KR1bgxW6D41QsOaqPW5uW4cLK+Gi0Sqscpou0OZX81UYZW6JHyth3sHW2Ga8CpvifnrtojyLBOjaGioXf+fexEPYOCbf1yCFWnM5qsH1UjKNBYq8+GUpNo8YndCY99UMGvnOu+GWTwc7wlG1dO5Gk5CMpobUdpKPw+8MYlt+s6O9L8ZoHFHp2GD0r0/iBJmxIW15J2/II57dEM7sXN4mn/5rot2lOpObKot7xOHDSMp01mH+dKq5wKDY1QZKMA5VKveV/YFkf8TSFAj2am+/Bsf2Vqys+3OHEQoz5g9NClH88d1X01S9P+bp8yyEcOVgWucAD2g/DZGq6J5eZ/lAh5oJQzGUHJTRD+dEYCElIXCSK7O7Bmw8tE83IS0UKgiDqQA3LsAyEGqOgvLPzv2OU5pqw9s7vh80mq+60GSOkj5zfCJr/usiMOa35tBl95AyL1Y8a0+R42nVWeV2Dum1ve8FjZO8Gz/a1t8K/j7bEdXEOJTw1uSFas4yazDkt/TWyVprw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(376014)(36860700016)(1800799024)(11063799006)(22082099003)(18002099003)(56012099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4LLbdTZN5ME0V7UmPEQPRKEWt1TWcjW7qIXINSTzmg29oJU7esItCxwjIxnHOvWe/iPiinhuf6eJZxiVj2L03RXHanuefaS+t/xzF3JdTlfAKB6GtT621VIAiT9Z+8JqRlYJppRaDSEkBD4eFKk9E8/L11TdGRu2rJa3vsRQfyrN9ySJeEL35kTF+Oqa+g1FunN+45p4SXmbwB7Cr31LSkIDmbZrdNLrXjLcFirRfwgh5+WtrQkhGPYW6Y/DBrI+JC4HR+MVV6x0hc/Aulphnkzv5EQxoRCk9ISTqMWspcjDVEXkbB74GfsxH02N2CRo8j3lz9qlGoFg1KJ/gx3bhifB0qyFjZXNm8/X13vDZ3rGneUBk9qadUUBE1PZOTZnn2d7nLp/PqwNqqgi7IBsCtYRgK9bWE71wGm+/Nfo2k7dXHlnGzvjKHwwtiK6cuol
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:03:17.4203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8a8bae-686b-421e-f5c2-08deb74a1709
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8467

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 217a1ecfbdc5f..0ee0fe9308fc9 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -177,3 +177,58 @@ Groups:
              64-bit aligned for 64-bit registers
     -EBUSY   VGIC is not initialized, or one or more VCPUs are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs), or to restore them. A get operation saves IST s=
tate,
+      and a set operation restores IST state. kvm_device_attr.attr is rese=
rved
+      and must be zero.
+
+      The VGIC must be initialized before using this interface. Restore mu=
st be
+      performed before the VM has run. For restore, userspace must have al=
ready
+      restored the IRS state and guest memory needed to describe and back =
any
+      guest LPI IST.
+
+      Saving first asks the IRS to save and quiesce the VM so that interru=
pt
+      state has been written back to the ISTs. KVM checks that the VM rema=
ins
+      quiesced while copying out the SPI and LPI IST state.
+
+      The LPI IST is written to or read from guest-allocated memory. KVM a=
ssumes
+      that the guest has provisioned a linear virtual IST through IRS_IST_=
CFGR
+      and IRS_IST_BASER, and uses that guest memory as the LPI IST migrati=
on
+      storage. If the guest has not enabled an LPI IST, there is no LPI IS=
T
+      state to save or restore.
+
+      The SPI IST has no guest-owned backing memory, so userspace must pro=
vide a
+      buffer through kvm_device_attr.addr for both get and set operations.=
 The
+      buffer contains one little-endian 32-bit IST entry per exposed SPI, =
in SPI
+      number order. Its size is:
+
+        nr_spis * sizeof(__u32)
+
+      where nr_spis is the value returned by KVM_DEV_ARM_VGIC_GRP_NR_IRQS =
for
+      the VGICv5 device. For VGICv5 this value is the number of SPIs, not =
the
+      total number of interrupts. Since VGICv5 currently exposes at least =
32
+      SPIs, kvm_device_attr.addr must be non-zero.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, the VGIC is not initiali=
zed,
+                   restore was requested after the VM has run, an LPI IST
+                   already exists, or the save operation completed but the=
 VM
+                   did not remain quiesced
+      -EINVAL      A userspace SPI IST buffer was not supplied when one is
+                   required, or an internal VM table operation rejected th=
e VM
+                   state
+      -ENOENT      A userspace SPI IST buffer was supplied, but there is n=
o SPI
+                   IST to serialise/unserialise
+      -EFAULT      Invalid user pointer for attr->addr, or the guest memor=
y
+                   backing the LPI IST could not be accessed
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while allocating the host LP=
I IST
+                   or tracking pending interrupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
