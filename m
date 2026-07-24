Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50A431A52
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890564; cv=fail; b=Ngc4GyXKUrjI1PwmiPm4l4ccV5NWrsJsB5sAZTk2ZO1MaGCAeEVlvU5YSsiFT1oWLR5j3jOmPr5SDEDW9TuAIAfzTtIJpZTI/g+C0TZryy42D+oN5HTvNALvjAHVJmnyubRZHTCskJprpsLrqXy/w5C6cCmC6z8O/NMEHm+QwJ4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890564; c=relaxed/simple;
	bh=lHe4ype7H23qHJnMRmav1whO8llfPidp/fiSlg4eISE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kwdsx6gFWcdFksvKbwTvdDwSM4d4RK66qkHSXN7UIGc1t6hSZgZirMPcDmsyyQlMzrJ1uLVO9wYqyhZgyUw4AwW0mHuZ2+j/cWRoJHxz35DPT5Po2dEmutTd7tTTSWanG+bTUX3DpLuAWaYDIRcuOC6r5U7lrf76qgfko1PLU/8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B+4VU6mO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B+4VU6mO; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B+4VU6mO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B+4VU6mO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oxNetDjskVWr0tJMOTYXoC8vjyK3xmrFRb3zlr9rLIYA8yzw3Olazpc1AtffV8YgFtmCQtr57GAEHUmteH5Ik1JU15XlEwBOQceyDkgvBrFI+Hftr4MjRbJPoix3TtsOzWgwWc6hy7kobxMydKzLO0b55g0T4+bW1RDh8VYK69zWvPDJdCTb/HU/QQV8zFFY3RRGprDfi6GHZfAAqd3ntEPCL0U9RqgrdbOOO8MRZ3ye1+lTdb9qqQP33oks0aqFQN4bX2e1A9dZa+zU9MpGLN87R0vOvUIJ3d375FIuyCmzUvTO5pqa69kgYOZ7cf/YAC+2HW8DSyQJNFUuV1XxPg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZf3sVIhXB4oInKSbckgfLCAJtio+/JJGHjPXUV/mh0=;
 b=ZN+p/FIXxc3xuOr6ZQcR+sQ1CTvwTB087mLkisqR+UpXPcZSyssXeQU69riuSx63ZALhvsrty0fv9vn4rBljboift33b86dTup3wiEc+U5VaT5R4yayqsud591twX7ViWr5spVGBiChV3ytV3Z/1hj+5RtFxEJkuaebfYO10hu8QNqXcSdXk4vIoaS0jgxTqD0tYMJx8zQ9OqoG0VD8RSU+Fm+tIDPMKB1jRd5ZVLFekzK9uMVC+RLA+a5TulF+Cb915Ww8sB8Ox7CNRZ1sE6XgHo+IMCcrHorR285FMmCUDslCzlQiIrXDizKsGezTb1k6JufYz9dsYgTpeC2UTrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZf3sVIhXB4oInKSbckgfLCAJtio+/JJGHjPXUV/mh0=;
 b=B+4VU6mO9iKQRMCnjhjwOgkvmD78xGkf7tICpISBhy/Vpw4HvNh3eCrMaFmJg6IIGErCx3AqnlzwMUJbbZJ0KccN/6oGOcNq2cGueI5UaExWGVhEjNgNzJj2Ii0dbAAo8kFCgCcqrSjhTufInzS9VJlmYfF72QDNttEigWF20Nc=
Received: from DU2PR04CA0071.eurprd04.prod.outlook.com (2603:10a6:10:232::16)
 by GV1PR08MB7874.eurprd08.prod.outlook.com (2603:10a6:150:5d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:54 +0000
Received: from DU2PEPF0001E9C2.eurprd03.prod.outlook.com
 (2603:10a6:10:232:cafe::71) by DU2PR04CA0071.outlook.office365.com
 (2603:10a6:10:232::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:55:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C2.mail.protection.outlook.com (10.167.8.71) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via
 Frontend Transport; Fri, 24 Jul 2026 10:55:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epga3CHNMjJft1EgPG++8Z33j6XSv36BYz2NZu71K0e8pgMLfbHxVvqntjxDf1gbKV3QQDmXJGLjm4eSkCaE3Gjs5/HS2qvXE4vXtk2IHaQLRNv+9ZNS7uu95rasnPYHgR43lysxhI8QBNiMCQFGntUaXQ73xK/rQGp69BZA+CgQCHLv0DoT4kqNh0XODipWSttu+X7B7XXtexMy5fFmHCv0GS3FDobKRFbWa1PQi2PFa0kp3nRnkX8l6dd/kbZJQfywQT2yeo4HnJ58RaCLFtmHdUWYf/j/XnrEDTrQv10dT1rnpAATipMFsMQrmwph1TMiwuJxN4hJCkeyox2PRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZf3sVIhXB4oInKSbckgfLCAJtio+/JJGHjPXUV/mh0=;
 b=Ff67OvyQLJ9zafB9KAsgDlpb7RvIz+euRSW8CJfrpRrhbPC4WQWwZAg/EayCm+qMPDjAUymMnsi7nD79p2mYwfu6eGF0xX6N4hd9yESXXKnG/3a/RPdnaEWStgcdDuC+N2Er63FPfFTGhoHqQ7D46g8YRCuuIvpyjjNBONcgwyBWQtvi+RDbjB7UT0QJaTn6nc2kqxRzm0Peu+dpMLvg7pglTpRMZVzLlTHl9dwQRXuL5OwaUBdgnJhdZP8OCkIemjHduhS1f21L2AsYUzgJ6MulT+esfTCXhvMmjmPf+OCNhFEQXClOKXoXC2H74f8XLmsl7S6MFLBwLfZcDvpLYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZf3sVIhXB4oInKSbckgfLCAJtio+/JJGHjPXUV/mh0=;
 b=B+4VU6mO9iKQRMCnjhjwOgkvmD78xGkf7tICpISBhy/Vpw4HvNh3eCrMaFmJg6IIGErCx3AqnlzwMUJbbZJ0KccN/6oGOcNq2cGueI5UaExWGVhEjNgNzJj2Ii0dbAAo8kFCgCcqrSjhTufInzS9VJlmYfF72QDNttEigWF20Nc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:51 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:54:51 +0000
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
Subject: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Topic: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Index: AQHdG1rZRY3AS5YnW0yTpN5a5H3V1Q==
Date: Fri, 24 Jul 2026 10:54:50 +0000
Message-ID: <20260724104819.1296803-26-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DU2PEPF0001E9C2:EE_|GV1PR08MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 75dce7d0-e85f-45dd-5b45-08dee97221de
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 jw5ySjbHLyV7/nPlgcRy4MQyC8g8LCkyeRlr5OVSF2UO3+W2hcBLLWx34pWf4DeE2tlwlmBHENMnMi7NmubbUY9nMQ9VqohKRhBrlm9XBX7Wd+byTB7eoVU3+fVT0UInCCl3A0Axy6RGVMAhuQugS44bqwIZx/Fn9xIVJjnUq/okcj9KLdeYAQ8bnsdLtP8Cwp1cWkjE7y01rlwrdLC51iSK0pr/PPJ02JhxyPEXBiqYY3eQr2XtysxtBaYCyHCFASFBeWDcJsZlvRu72XPUwkEFXgHH7ZyyqnHAAYKQkJXGa6SZsOfb2yz5dAVpfAGbcVyZnhwY6/dZ1YLN2cOWrwslewVvgRwCsVLlU0W5QxUXzTad6MmE7tEJg+xhCgyVMbMeJXHFbpLo1bq+JN1al6Yg4znTq7weAX/oASHe7TLdbjvlaBM9YwhWRrRkwOCkGo/w3BCbE0axm4iFax+DYNH/+PmGobl2Z8J8D3Enf5kAb0EWlMnGGxSmE5PThZ0QbWiBxJVOLmRvvQSGBg29XgBbQezJddqDGyMwDtRXHR2eAW6uTuHCD5YTXQYo9QJcTFEYWoZ3QAiHUI1vW2rYHfi5M571lF4qnLShfSUm+oMOjZjgCa2SlcJnmHWzQ+SwIvFDXXz9zSzJZWixd/LZVwJprxNIWT3fSEU+wB5+NKQrxPd7xIKruPVe7t/IzdhBxI5/kiuKdvKMV7ckzfKeGoi6vXpKfrtJJaYFOJ+DQx8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 e7eIxmYzNtNrRhtuesDR9ajB+UhPoiSGUuB4hJ+Z/2wuhAWAjNH/n1nl0fi8uQKCiLfb45AtFB07VqfW6JwhoctX81aTWC1JC+9BB05SoWMscI6eYaFr28L6WrO6LDXf16zFZQGStOo6FCrdEFMPMSHmg8qSCPBu3KCMYy8pPgzxqRFCH+jijKt/BIpngjngJAQkZLQbrl0eGjpw/BPnFyULpjZnbZUDg0/x2IWnuTacdzbgaHEK+/7s0QzQpAIJzl2AY41v3FLF29sOGR+xdgdKZtwVzYebRBhkj/q5LG2MOuCv6hMN7TbraDbw3kKWzLLRxWB/7W2ZIkpatBIa4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cf831cd4-d823-404e-b04d-08dee971fc7d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|35042699022|14060799003|1800799024|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	kFYcdMMXLieP4zMFjAsAco7YTAUKhQr0hU8S1Jm8uhpEk3AqA/OqC1VivgQkV8f45LZlktLJ2RfVinr9su1dOLNXAwpLTr8lgNHYeh0wOGb8MfXgNTA/Wc+jzbuyuRPOPOCx6AJJdveEOqN39Lu6O7waxWE8PZzuUUOwW42KGv1oyyhhc5Ayi43ZpWAddHPdk5kk8pugSplTMPbCCrDG+IXCv2a5spqzcnxkwAw0jXf992Rhc/LpUykYZwL2h7fuB8ibVNG1bJREUMl+TYfUugN32/7MDo6Px16PgvlgS/q6P/cuGX5uVjckky3iIQU+HUg0rJPb+/7xHu3j73H1vkSx0oNRA6d1E86NxfK6fxpOxXKrC2iBLxJajeHVZsVLcXFPA0Jqhf7bA91Rw82/nGBphObfm7i7SEoc0h+BZe5FHWrHaty+k1OFWmzMmJYmh4rxKg4l+CS+e7JepB4AFz0bV0YtnBEtGXM/HbYttCshGLikOp5J3pBmlmvUxEk0TVO0E0x7IDWwAgZi6oTB1uzpDOD2mSs5zqPByzjWp85cmK8pJax2RcG0fsmi5DvFjmpZpZ0J4Lx1UKg6N/Dd8iVUC4LS4MLYDwD7AaLy2UKxEJj+4XWyQLKIxMgXz6WZH5BzjQ7xzmAeTZOiLo5Ji4R/g+5wKwtYmjhdlpI3S5yKyh8BxNBRmYiPegQaE39g3tS+rI4hwD1f+Q1YX1D68g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(35042699022)(14060799003)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YYBGRxABVYItY8ZqL+mamvYJ1AjL5WWRKZXZnjiKw53hgLXUZYsgH41pGK/QOXy+2GiguRT8LQ8bIaOE/0wWimpgS8sO3ruGk1KlO/zmN6Bq8iBvF2G1RvjYT/tYsuPgzJ6gblh09A5WTg/qa6j4CxQuvPVR53GF+lP3J/RSCQtDrk4TUUHD2eU2KDMR50ouRb4KuqETClTXtd6+G8tiLSyWEo65uVkGGYXINdY/bOhbJEOiP1iRCHrAbg2Qh28PWfXEGtw3EW7Q0DuhDsTKcyQqm29zDO/hdCHC/NyRf4K0GVl7qdwaGW805Ii9CZY2wCqEKwLmmZbirCYy32q2qn4T+w0Yd34Rkj2WMA6C9VR5Tkwx6BMmb6N1PUekmCh+dPKT8/pZcR+i0H2Gwdcc1ExGlr0pgpXDHhHV+8yGwRqdvmEqDuP1mTVWjD9PZHfB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:55:53.5976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75dce7d0-e85f-45dd-5b45-08dee97221de
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7874

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these would
limit the number of interrupts significantly. Instead, SPI and LPI
pending state can be managed from the hypervisor using the GIC VDPEND
instruction. This provides a way to set an SPI or LPI for a VM as
pending or non-pending, i.e., to inject interrupts into a guest.

This system instruction is only executable from EL2, and therefore must
be wrapped in a hypercall for NVHE/hVHE configurations.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 ++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 10 ++++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index d9ff9c2999aa7..36808ed0e9afe 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 8fcbbff719cce..8e2f0280c0cc5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,7 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 09756f71df08e..8f9cc3cd422aa 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -719,6 +719,15 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -754,6 +763,7 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 46992a6c2cacb..94746317ca79f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -149,3 +149,13 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
--=20
2.34.1
