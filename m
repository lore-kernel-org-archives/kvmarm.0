Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011019.outbound.protection.outlook.com [52.101.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AD94334A4
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890576; cv=fail; b=ccUJZ2QX4bTxKqUzh0X/3A8/+d9U+tsOCYSaIjQkuJtFCak7e3VncIrGy0/p0gZgaA9fHGwuDRKD28ure2PF0OwW2iy3xwcdmKGNi0IdNSyewH6NjxJ9r35t/8iJ9Zp0yxRovyMRQWKhHSFlVWoLxLp+BibVfXut9DfTcMEk9J4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890576; c=relaxed/simple;
	bh=/Dztk1ObWmErQkBbnsoB+2DuAPcUIDMbJJDsL0HA0D0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U4v+/Gmy9+Fm39xVWyfRXZLcCQcsDIvCB6Rrc1pYfHJnvBPVmgQGFKAzhWpfm7NrkWpfwgQd5JNREWh/thaE2NU43Pg1PCwnVxOl0iDTN+3l3/9HmpYgiIWO6JS6Yby7bAB8n9pGM8kzoYLqfNmM5smLyPz+1dcvR2cipjd26E0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pcd68BSw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pcd68BSw; arc=fail smtp.client-ip=52.101.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pcd68BSw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pcd68BSw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=b93GsyuyD6LxrqPrUvgbL/H+g7aXye+v5KBA5iObKXkas9SAMuF1drgtdr2SnXhANjZi0utwQncrkjNRiCX6fcuP6nekSo+TpqDO6tFSzDWTD1MKxZg8esK1vetbH7PKGPikQi4albRg2FrcPbN80jxFGO4E93t4mPzghuLJ8JXSPf6iaAKMCsuplbuIHVynSWtgF65akHnJ8KGyVp9cv0D3e17yAVZ7cSNuZ8Ob3LX93LHgMGyCTVzcZoiB5mqD7YhhAwZIHEmS4CNAonbojAOS1tz6ZrpHCGoA/ENUYTk+n+lom1/tuwIC4Q2yNJJC4F+v2kFQbbje36Jci6SWvg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CR5Cd0qVWUu1BEGWSAo4HUhVuKMl9W9e3VzK1huksT8=;
 b=d9C5Mua0lNoCw53TKOMpGOYz+n3vZRgqvDcmCaQnrSQQjpdnK25/+oYpEO7IA+S/LB4NWgSek1Qsz5SR7yfp+B6Xw8q9Ccs2K8enQdE9v2zvMFzplJXZQXbg5bAIgY6jh7kswUmdHBXnHqFU1tQn0tIDmUCtsx1TAR3xa3ByQQGhHcY2Pq6OLqWy4Ka4bQ0vAzetQ/s+A3MkiKr5B7G+y2kJaFyUAQTFU3VbEu9rkI2NAl5YHlqQWiPcmQVC1JwklkMRPgTfEcITB3GGt0qDIXWTlxlEt5mjgbBxKNHtSa4Sxm0uPqEhsw7Yfj5+zqEPQtAUfdBDBEl/deqArLl5Og==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CR5Cd0qVWUu1BEGWSAo4HUhVuKMl9W9e3VzK1huksT8=;
 b=pcd68BSwoAgLb2+K+nq3F8jVPZTgy49QydtPsk/sX/TIIAg4DyYng3+c5v+zbwZfUIin0q4fhS3MjQcmsTiZ/g8sq8sLtoaCVPH3ffUf17SOSuw5tsoQa3ibLTBXFq1/IOmicmYYXC/PFTCmHy0f3qZdNQwvNFSBzsuRy0e/T6I=
Received: from DU7PR01CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::26) by AS2PR08MB9391.eurprd08.prod.outlook.com
 (2603:10a6:20b:595::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:56:09 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::20) by DU7PR01CA0024.outlook.office365.com
 (2603:10a6:10:50f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:56:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:56:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpw+N6EEoffNG5SBCujRQHc1SQ3G8CubFZfTkfztlRtXMQJpmoSNGAtU6rzFVPYYmciFshccbUa/c6YHph6VolaJOUi5PZdyCpH4caWBHNoBlJV0vghigoBQhr97QQTYqcTMeDBwopwYypPtJKAlwRFx/iJSLK8HwH4sxoGZXg8ftZIx1MSpd1KyKoBBnt1iqBkS8Z9i2VnGob/mOUq6660xHvnIL+EaqGYTjliCg/skHIlMDRYh1ZUzYykQcVvX9bqeTdm35uMyCBOHqvEIrGKYJxf/y6+Zr0/1P1I9yxgz5Pf8k8t9h2w0z8vE43BqJvwjAcqnL2+u6xMUkDxZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CR5Cd0qVWUu1BEGWSAo4HUhVuKMl9W9e3VzK1huksT8=;
 b=keE1adjUxeDILUxM/o4ca4EzGegNQhvl3JXwef/5CPxQY+sAQku14HX1d00gNuWbBnEbnaTFhfvzVzNfAl0e3GcKvQb2rY6rN1WlTSM97z2+iOoSciniwWHB+NzFuAZVrGEIs1ftwL6cjPgw9TZMmX4LaCuDjBKuRQ3YYY8E/+7hIoeCz4bjx7j/doEu5k1EokWU5ePPthX6nOiCQU4qaBRXpZX1XPSdi0xY+LLje8/5XF61D0SXSanBq+/JRxFUuGGIeyTw37pBNXAvwsKyXv6C0OpKjKiSA7zBE1fUJMsmLtMBXSQfh3ajSFh5Sui6fMJcigUG8JgLy6jCUzAxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CR5Cd0qVWUu1BEGWSAo4HUhVuKMl9W9e3VzK1huksT8=;
 b=pcd68BSwoAgLb2+K+nq3F8jVPZTgy49QydtPsk/sX/TIIAg4DyYng3+c5v+zbwZfUIin0q4fhS3MjQcmsTiZ/g8sq8sLtoaCVPH3ffUf17SOSuw5tsoQa3ibLTBXFq1/IOmicmYYXC/PFTCmHy0f3qZdNQwvNFSBzsuRy0e/T6I=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:06 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:55:06 +0000
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
Subject: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_state() to
 irq_op
Thread-Topic: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Index: AQHdG1rjcUTOwBdDKUyvswmGyjM5zg==
Date: Fri, 24 Jul 2026 10:55:06 +0000
Message-ID: <20260724104819.1296803-27-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DB5PEPF00014B97:EE_|AS2PR08MB9391:EE_
X-MS-Office365-Filtering-Correlation-Id: 40291c48-256c-4e4b-2141-08dee9722b2c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 xa3YEjWIH7fyF2BROacXjC2iwiUuM6452CT6+c3o8CvxAjg3E38edP8ohgsP5e6jG6VPQLTjFNSh2LtfeA1szywE9OACvhUoPYjXredIHzR43/eKC4pSCKF1qSgRdin7L9G++42dCaqH6R5iCB+lpOVkNwkNXDHHT80um1b58kI6x9Sr8r2+5FSuqUHHrhQS+zDXvMyvnw2YILpfDNipmUN+tFeRHYKKGfMwodD+TvgbGCIQF+5LQSkGDzLCpMd/scswC5pnaE6sfy2uSwwdIiGF7kbHchxmtZ1eCCNu5xGEYkG3S8F9ZdcO6ri8CQDUCVFbkgVXu+TGit4R/50Qtm7VZ3vjIjTDCpJurg3kEN/m937l2BiXaRB+l6IYnVfTosHusXEMitXkrrD0QhZ3XQGfUevKDqkomcv1eU8JPgJ8I+szznPkZurodCytsJxx2UEEfH41a1Ei8jLxjQapB9N8eocBXtQLciUqBiNxR+Hi3v4kA/+2g53UYW2xBgGVsD58Q/3wSO34yaVrPp6P2xmD5lyx0VIoScEXttYmQEu9x/UBZlGrCTU2M8Gn1SXMFegKDn6w/tDfh+PLoFY52ICvlOso2xwcXZn7m6gyKOoSyXwg8nNVvr6TedCubBm7B0WS83Uwvh/N6kXWK/Pr4nG7uYuRPtP/fyBAwgt2KQpPKBK+z2Kuw5FTHfSB2yLI8G/GGubWRei7MPolLlk/l5KjOgjNwW4ZigkkLKqZQ5Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 p2uyML+CzrcHHjkIwMWtq0xIzRPlarL+pEZyws8fD2qp4BKJ5TdXgwgInSe0cSe1tlCUf6Rs2fnWsZEeYi8AZf8shPeDR2QXaxjfof1m6DUrm5bMroj7FMAs3JO+pg2LLtrPGGjZ/zeVgCTGc+fCsGu4Qy5Ow6fQHHMktpnwxy62dNtcPm1ZKmB/ILS4vHnKjNBBW6tCya1ABEkE5X9Pyl464v/ZBiu0jMMWAeZDWEGm+yFeARx2zOfvyWHd1e2VO4ne0Z3A9gaWdc6LCvKY8lPUxDYB6f77CDAVOTdkGSXnViF3v7AeegFLukjRHGb5mEpgUfzraoim12kvFOtAaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c7c7f67d-ae39-4247-db12-08dee97205bb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700016|82310400026|35042699022|23010399003|1800799024|11063799006|3023799007|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	X98wf7DzkUJu6mMaBau567fe8ac3XhG/2wjbYkryvk7uZPCuY6NQTFKgUlgyedbbb2+JnLI3Hs9/sQRtU2bQuBgIWbfOuli5XUsxQN1puPCVLPxtt23gCF072SWtvgx4iWUkU/DxbV3cCan1J9G3jjCSch0NE656SYnEn4vE3W/t7+WkbZphwdD6OeRzy5VC3oiWspnhOnWwpLJfZYXbzU1exO0uur/mJTCD6ICxvTp3iAUMxrR7az2bwtW9e3aih29Bp52/fJzSYoEU/OPtY6TSt1StXz9a8uhdPQI8bsQROvBO5VrJ52W5/i5Ku3VoRK6jp5RaDuf+gzNTjsGd54VzUm3mhSH1jgsKQ7lIsM5Of6GckO9jyGsOUCiIHSirhXmp5pQ/5VCofsBZgMtWOlYdqD6nCVdlxPrwmzQqYZ7+aX2vnf0X3aPgilmupyfk7teu/YNWdQVqn7IDFzmeU7QVV2niUOXrcnE7GbEEB722/HnG4oXC0IWmqDraPSY1nTnJEYk7uQty0EShaWNaNl/lRUR2m0aSs2er21u9nA/oR089wnBBDgbDv6Lde3y4HGLy9wXD4NpeY2kQBdqn9Yv5b8YpkPHjf+tT1c3baEO7dLOhqYlTPNk2tNWYSPEvlIhB84j+4ibxtkgWa8XGnBWYWaPewt4HGMYd/HKNfJ/pnToUhMJRXXoa7J8FeLcI3uRvlkQqD9gXWT4lVgnxiw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700016)(82310400026)(35042699022)(23010399003)(1800799024)(11063799006)(3023799007)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e5vBcxevfanHLRdmec5LJOvPn4afZg4oEvkq61HlmUXnKr1LQrEVgPB8x7NQzmdnE16oDGt4jxijg5Un8MSZDkyAneOFyMPir97GHREKGTcvU1nBK2YAQGyWCYO1U0Z11bNh5P2oawa88Py+2Swj39AgKEFuY9SVpRCxy98nYTlCG+7ZTEWXev3QU73PaeCJmb7HV9wL4/Vkfs2td6wxBjlYw4rAiekBc/NFqxZed0/U4m/lqGLjKvnnBfGpcFhYRJ2+BSSUnaUOLE4irv/SjK3ElNnakzoBjJo1ynC6qR1LQRwTvn13NL0ClbBs3tNK+Z7n7KUNCVPDf7/I3caxfIuU6gSnqF5T2F7hk4LODglS4kknvIvpAiekwEtEnsOsAXTE5mG9HGlMgdzkrTdqRUkjNJAFlNl1kb1/ObYn2oJNvE4H8yRCMKQv6j9hw++m
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:56:09.2029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40291c48-256c-4e4b-2141-08dee9722b2c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9391

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself manages parts of the interrupt lifecycle. This means that
pending state can be directly communicated to the hardware instead of
being represented only in the VGIC shadow state.

In order to accommodate cases where the hardware handles pending state
directly, add a new set_pending_state() function pointer to
irq_ops. The intent is for this to be used after the VGIC shadow
pending state has changed, allowing the backend to mirror the updated
state into hardware.

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 47315c3fe120e..69e0965846aaf 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -564,6 +564,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index af926f9384b65..dc09ed1a2612c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -251,6 +251,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly update hardware pending state after the
+	 * VGIC shadow pending state has changed.
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
