Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010003.outbound.protection.outlook.com [52.101.69.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27443B0AE6
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 10:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357699; cv=fail; b=StVJmAx6bMnQKl3KaUXIxTu6gw3/z7odgPCHErT4P1ptqZR/izM0RkG7BVswsJlees3c20Zko3Xg6fSBAXZsaQcgl7/NROwPm0fuHidFH+N9za4GDSi88J2ytMO7UkqvXbHMBiMhlmnbpnXh9CxyUjX2qECGKS0xkUQxyT6Gm0o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357699; c=relaxed/simple;
	bh=5o2O6IjAJNBjiB2Tmr//mkoJDk631EkX0LLRRTDPejM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DGTIwXB0RVy433oesYi9kdQLJPS5in+zVnsLkt0p8d0WxiQQOhpkGbkjnd5vwVZfiIRSk6aZivQku2XQ3s5gr06aykxQXwQerqTEVd7qlU8ojstrtD0A+IcZtG+cjsrN58jz6eGfmirj3uShPumpVEEuQ5hELNXNen9tJ0tXhPs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=funyyTRa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=funyyTRa; arc=fail smtp.client-ip=52.101.69.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="funyyTRa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="funyyTRa"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sH5LOqpClNuTAaQN/n8KFQscUk+NElTTrCLp7cxqBc6AH11bWTbKgvPRKGuPeo+qxcCWJmClWutRM31IMVdlzDyBiZasph5ShD2dkrUHNkuvW6fd1XVH5lArZgxsQoWuZquuzlnZIIhju7AJI27NO2OgwP1qoPvuXxyD/raDe8M/s664c5hOJEGYm/mBzXn61d0YjIbCS3yvc+OcmUgVHHUY5Wqw3kVxidnD+aiJR9/s1bI3YtWPL/3U7CY9K4s7+FUQt+p+YUmHXmXE1F933kM+2gSEDCdEm90FqAI6FxgVCyMsMyI7YlpU6a12wS29rWMrTd8UjSoxZYcEzdQsoA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31KnLnwb2KVGhEi7IU0Syl3xF5WJofTJ6fI6XSrxU2A=;
 b=rr08KtL+cRgLB4s5srTDyOPa3xOcjfoykY+/ZRjzMWVPLqnPhmXx7pNaf4IhpNP20XGFme3CTW/T9qCBrjeeqOAPCzb7WVlz8hsgGswidgmToL7asbiy5qH0D7+5X7De/ZlMc3fjjksX+PbZvQx9ZeC4wLqnBViUveOu3wDrkoGpcjgz8t58y428ioyPbw1Iwf+Gf1klFqOzq6zN0xYq0Cde7jbP15tRI38IHgUDsRVXpXmy3sOLknsOm6DOZnLH66jLrtNDJVPBlWweqeJQalGLql135tGj87wk96IO3//8LOES3+s0qKRGUy9nd/UFUESOgTWbwXH3Ze3sPkLHqg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31KnLnwb2KVGhEi7IU0Syl3xF5WJofTJ6fI6XSrxU2A=;
 b=funyyTRa53MRT4wh7CZiUvG1YmvbjAtXfall1OHM7A48+wdynmhHBSjzjaMfITKQbFDkIwSeR3ziyElsubm0fW7AndrreM3lTCrrB/8MD63sAeJDHHXK4QSWi1q/kSQFnuEzyTv5jpxosUbSXxNOUOnNRdFqOwonNe45MmQxwVk=
Received: from DUZPR01CA0292.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::14) by PAWPR08MB10089.eurprd08.prod.outlook.com
 (2603:10a6:102:365::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:28:09 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::96) by DUZPR01CA0292.outlook.office365.com
 (2603:10a6:10:4b7::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 10:28:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 10 Aug 2026 10:28:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4UdaZkLogohM8E2cL4BbiXMulqH5E4Y40dPYBL72gsCBnHMqvXaMrOxR14bJ9Ce5aqB76S/yRobkE/lTE35UActx6alKvnMtnAVOfCAu0PUmwy5aRBO6p8AHIu4lqXqDy4NKXghuRbXnfmJsNJDm+pnDMnl6eODQwUpzc63CSrSkv6YPADnWGacqyfYCeitPH3omOMxbqhoAfDFkxIn2XCeNj86nXKtIj3o0C1CtHg9JzpRKkPx7Xa4JLjlyESNtq0Bdj6BZJ6lDIG4foy+OpEMPIwzfQAQpbqPk1QSKQSGnj4Y9UUH5jbXYBKoCA+/nOuB/9NH0AbEL8kws+IsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31KnLnwb2KVGhEi7IU0Syl3xF5WJofTJ6fI6XSrxU2A=;
 b=yg18LCgqNba5LdDCpURQAa2cxqgMZqYlzzFy6fBhvegYuXxY0ic1seHeb9plA8ruxB9w1uFqSXQOVPdkpV2+XHhtBmSDhwpLXg0qtgwF/mAH5a+I2rMklbntNyP8MKkOJpB094nJ8bSFDrdXnpe2YLOZMm+F5TYhXb4NgvdAHPi3MJ1ltCMsKIR4Gi6/zaGGZ0ocfRoxA4gJNePj189CQMQhaS17yImKNIRXmg/Ql7VNNUcj5LIIg2I2169QENRI6oND0H6eWsjA0Dd0BDNXY+0ynp7XBEpZYplAjYBpdYtZqYBx2zoz3wNvrBt+6j/rt2xthxzNP0NI7cHTX5oIww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31KnLnwb2KVGhEi7IU0Syl3xF5WJofTJ6fI6XSrxU2A=;
 b=funyyTRa53MRT4wh7CZiUvG1YmvbjAtXfall1OHM7A48+wdynmhHBSjzjaMfITKQbFDkIwSeR3ziyElsubm0fW7AndrreM3lTCrrB/8MD63sAeJDHHXK4QSWi1q/kSQFnuEzyTv5jpxosUbSXxNOUOnNRdFqOwonNe45MmQxwVk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM9PR08MB6179.eurprd08.prod.outlook.com (2603:10a6:20b:2da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:27:37 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:27:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH 1/5] KVM: arm64: vgic: Free gic_kvm_info on initialization
 failure
Thread-Topic: [PATCH 1/5] KVM: arm64: vgic: Free gic_kvm_info on
 initialization failure
Thread-Index: AQHdKLLdRw1/dBT6IUi/lMrM/2CqSg==
Date: Mon, 10 Aug 2026 10:27:37 +0000
Message-ID: <20260810102652.758719-2-sascha.bischoff@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
In-Reply-To: <20260810102652.758719-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM9PR08MB6179:EE_|DU2PEPF00028D07:EE_|PAWPR08MB10089:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c4a6572-1b07-49ef-e500-08def6ca12e9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 jVPGPHyL4LlMV/2JELFbQ955CW7lehP0IcoPB+azxMxjYkjhrTzfHvWQZ3I7EN/UmAty+u8lhwQW7rweW4bPFyq7hyDSvPeebGnGwzH9fizV1KW9rHd8hGns+3fDQ0fKKK0GHipp8zZw0ue7UEr/njcv0s0RapW5B5OWzRIyeHvpIjkewJjHEy56frqaqREyC9Pbmr6p03vRBbJiru236XHp95a9R0jV2/fG0M27Spk+LxTILwnArc32pGX9vMUpGHzNKVgffXpVUqtzQD/iAwDRS5PKne4/lbLC8RnvK0a1LkTTiYKFg1Qwti+zx5QeBnIpuwkKM1/IxVF92oxwdYlNeXmCJBtoK9PEQ0lAGAbgS6JA+A2dux1zujbqL7/XAPy2raIo2yl9Gek5/T66A6dVVb9zGVW8lEoqolIuqX96QZTVoiG2PyKn8HnrMxfcPyXWlwPJkjoLazZ6OMpp5McHt9u1dyZLkIoC4ctopgxX7Gbm4dBu/fY+FUMO6xDjExxwEN0SWkuhY8lU+NOuIgJNZVztQPJWxGXSslyXfsxQqDoPTdVCrEakL7L2PWwmtSkepLWgeFe0z1s6PHgIdirFZ29qzLEXAVZ6MKB1HcS7FT6fxZciCJk36b00TkOivjkjuWedcjlqyLMuuMcrGOrS5lQS3EronqgUv+o2QuM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 G8Wme0SXcoma9xz3XPksrilbJhu0qDSVLiPRaUCFWUsCOKV9UNywAp4XlrZ0II80gvcAmaKYxOIDtRpbmM/tqG6DN6T0Bsrohqz/PEjI+vy7V85uGcaNlJk4YXBgKopHM04X9IBIan0eANSqdNOtoioZjUBH1ysdctsNXb8qblGofEcvx7lVNMxFBO6L/8ySpdkq8A5Er+3TctHllvGmNRW4hDUgh64pGIuNsHpiTwdruzAVDI34X6Brib64HQxd8m1Zohu3jqKAPecho3BqoSoLZr4RJV+2FSgzN3rcuYYW/l8iC0qZ7WYggV6uHRDCk5FXnvMJAzVWEo+bM7XYXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6179
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5d729798-ff66-44dc-49e3-08def6c9ffa7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|1800799024|376014|14060799003|23010399003|82310400026|18002099003|22082099003|11063799006|56012099006|10067099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	8H+8LH45/oUTSRWTvF2l0aZXM772bSkyDxKTsizwE9u6g8VzpbRlq0nwwj4mxJFzzdvW0H651qRkdv8o1eSFrLzvZf3bRCUB6OYBPrpUeFhcpO1Bqs3Cl75caZW8tP6WuUM0agZ2pXytaouyQlT2oHWxsFC+93F/e2IkBpiOqa8LJ3EKdQO9VcpJ7RcepEKLQzMSDeuA3AAFy12ttwYD45t4bFLeUg3cUfduP9Kenh485BX43CAQgmT5iYzqadeA9HzcxFq/7k5p7emvc8IJc/C5CE4PWSiHcxtmf3F2dZxXkLob8vKCSKRLSN6lwDf0ZkTyIwPy8olB3VOtXiD5egCVZekO+vFhXPhJUqGpWJ+jTldhDgVLmD0JOi/7REVuaXrZo7UEnVJKMn9rOZMMNdD75glkg+G54Kj2vDDL8bb7ORfGltbY+yy5fNdOEJHD8IalnCYJ2K0xr3hybZcHksJMfpXDaq3c/4C/TB4itBP2wK9dbz5Hzhybigu0HRCKZk9Kxed8tDibeCSTkbbzLuDoRiLp4QURBwfuHPGoylHnqwTgFej/lyJOPwPK294yi2p9Rdn6X3ep3tnViGT1rCV6MlIMizpU2PJD/jSBSyJju99/UlpV89I3Wc3Wk9WDo+zwIZczX2xHdcnmIfzcCQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(1800799024)(376014)(14060799003)(23010399003)(82310400026)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	r8S1IqaCjQB2u1HwuxTM4KO7h7lPG4qeMJtfiw/TaaJZ+7LNO38da3/YpIP9A9Vw8vPcLpoZiJUJugx84ijVfsbGMP5e/Jf9a29g+nZfQ9WyiaFXsqxTEjwqVKM5VKyiNSFqN/WytAw8iUFVwKyKrPJb5PIIDjDu7/Wf7jw0Fs8npnXivheXyYghLPJPj7Tl8cPi4474BFawiwbLrvdP6uHzThtyhk3FB3MUkzc557zQwLqqJ08NW7RD0dZA1PcMhhwsrF0mal3oQlqRltTeKeNxMS469p82jAbrohDSD1ShQ44/zCXzLGCMdhQ0DRpbeLyN2HEKjvdkZm1SsJauYN/XenNAdeBBz1Ij6Db8jPctg8RK9drvcGo9fsmEspDS1Qp98qudNJX0CgDg3JH32H7zva/GKve4/mfQwRAmdWBIThVb08UdRiVNQcNyMdK/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:28:09.3307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4a6572-1b07-49ef-e500-08def6ca12e9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10089

vgic_set_kvm_info() allocates gic_kvm_info for use by
kvm_vgic_hyp_init(). When a maintenance interrupt is mandatory but not
provided, kvm_vgic_hyp_init() returns -ENXIO before reaching the
common cleanup path, leaking said allocation.

Route this error through that cleanup path so that gic_kvm_info is
freed and the global pointer is cleared.

Fixes: 0e5cb7770684 ("irqchip/gic: Split vGIC probing information from the =
GIC code")
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D1
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 907057881b26a..65e203d6a2cf4 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -787,7 +787,8 @@ int kvm_vgic_hyp_init(void)
=20
 	if (has_mask && !gic_kvm_info->maint_irq) {
 		kvm_err("No vgic maintenance irq\n");
-		return -ENXIO;
+		ret =3D -ENXIO;
+		goto out_free;
 	}
=20
 	/*
@@ -820,6 +821,7 @@ int kvm_vgic_hyp_init(void)
=20
 	kvm_vgic_global_state.maint_irq =3D gic_kvm_info->maint_irq;
=20
+out_free:
 	kfree(gic_kvm_info);
 	gic_kvm_info =3D NULL;
=20
--=20
2.34.1
