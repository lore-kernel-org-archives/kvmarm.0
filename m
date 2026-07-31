Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011007.outbound.protection.outlook.com [52.101.70.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19F442A179;
	Fri, 31 Jul 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508093; cv=fail; b=hVX5OqIwSwpqYBBKNQth/mQZdqwbks4bC9czCcwEF9s3eH/SvoLXjHjlk9LwRwMVPmknPYd4bWj06+b3naHa3YyP5LSZeV6WUmOUhr6Ux5p2fXiOOweUKo63R1crMTLbALm9B8eAuRDrZ3oz9GYrphWHLfgcw5oOgrh0h/mHw/8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508093; c=relaxed/simple;
	bh=HqIMUXt+DLjQ6+mrP1Dlliu7iVTw3+p4HqdFrcIJoZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c58I/dfpRmlx7D1PSgFI1is0pu6rl+oxs+X7/d3LN/Xn2WutCuQmGTnYDm4vjfYU/gBMgOCCTWUIzy/LdLe6uboOU8MK7BRUjYXR05nbKwKDWVcxZYbkI37aFiNxSTP1uJxndYBhzfPewlD1X18Rzn+XiuDv9qQEP3LVOk/BCes=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fkLsyKYj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fkLsyKYj; arc=fail smtp.client-ip=52.101.70.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fkLsyKYj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fkLsyKYj"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wB2PuSbJJ/jsbe4MaCTSt3JOXdmZLsbwDVqhJKhhMofR2RvID1XzeFlCRWxLoLtu7Q4p8/QiOaFUNLVIOXiFymRSF396by6nan0CpvrOh7wQ2CtyOxcwXQUQvAY/RUqr49xsy2pp9c3R5seqpGkecCyOKtYsWn3ZjCldm2xMCle8jYxvSY2eBHJgLYCMibhVzx+HfvfHX1OfHcXa5Jvwnbe8LCir+pEH0dfp75ORnYBHklZ4Nx69CTcsOLKROJvfZ8kAqEqQEfyGqot6/BTzzx5BveRSKRM8MCuMCp+TZzVGoNMhnK8ko66B/vSWlzeqNQI02biIMuAfcViVY1zXZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqIMUXt+DLjQ6+mrP1Dlliu7iVTw3+p4HqdFrcIJoZk=;
 b=G5PemniZY1ifEB4D1aslVPGaHhsJvxvvd09y0jJGsVG0GKK+JMxIFK++6p+ZjFEvQHX2EvJ6WgqUJhJp0ID0p8bgT3nzfC2L7b1UsN0lVMV7/QhRRWIP7RryaGD9M/6aCv45ukBm0rSHUV5bAyqWacZR5LJxX3xVFDD7/kPtIw99ryG/PM+NmwqaRUAcv82EzrLnxYgwMN/wzA6d5Vc2a792O7iJ6A4oo5lUGvFvlA/Ruv3FUplyMk61hmEXzf9/ZEcBYPFQeVbSMWlefmK72yl4tjJzu9oBjyA4S4t68Ewv8FRO34aAXNwHf3Od/UyynP7AgomXTcS+IO9x+Wr5MQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqIMUXt+DLjQ6+mrP1Dlliu7iVTw3+p4HqdFrcIJoZk=;
 b=fkLsyKYjnYy7d3tIQS1TgCwczqMXSO/+6Z23O2m68qbAhNWruETEAGAgEbnT/Qo8tqsKinaAWatbPq5U9VoJ2Oj3ntZXlfvSiCsduNGrVWgKCeYR4lva8GqZjBLPRvojjlHhuMI+EXPunm7U60xkORhESAXXCw0HvtNxngZTrJ8=
Received: from AS9P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::31)
 by DU0PR08MB9799.eurprd08.prod.outlook.com (2603:10a6:10:444::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:28:06 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:20b:46d:cafe::43) by AS9P194CA0012.outlook.office365.com
 (2603:10a6:20b:46d::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:28:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via
 Frontend Transport; Fri, 31 Jul 2026 14:28:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kkd/jwOyKjkkQA+n9sADQPI7BZLOueF5LOhxjZQ6L12f8TANtspjBRmJsaXLeu+fzJZgIVFEpbX6nprpvXweCgpB7O8GtZhsO36IZXNMDsabU9hQfcII54iybx7x20huBisG+p8I+mZ3LwzrhmcVzDb6N9AMctyHSXJM+Bhuk+n8DQhu8ATb3lHxy+n0kS7PwyqWI+SNEO6nuz8avhR1PI19dAGXsIHshbv7UzeGMdVo4+ZOYdCcV6XLNibxwWeR9JeF4kQXCDoLu8Inhtben6SUcNkWFU6sZvnF529n4k5oWHyq7sJ2NW4SLiCSCSNo9AMY5RFyUOgtC07PpJg9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqIMUXt+DLjQ6+mrP1Dlliu7iVTw3+p4HqdFrcIJoZk=;
 b=pITyd2wu4iDCjS8Fjx9kXjrkDGwMbGTw6464DCA4bPjD1+HHFXQTwj0SMkGHV9E9guH996azy6riW+zfM/uz40xdOIqow6ikQc/cmeBwTNtfzv0IIr0xdWQi+PI+f+qsRG8EvtPv4TbP1mLLEsrCYAeY+zhdiFSCPGH/a0Mw02kfIF+wHFyfIqSQ3QVX566bE6M34Y2WBHygiTL1iC0w225HmTqiaQeGaaYQC239mXBPnwBjevAa/XU7m0zw8qCiZwMr28x1b4w5JKTwhSrPBm884eZrGvC1Er8+41TABB81oZLm34O8lXlFdOXoT8iWKaYTMJyhC/PCAi7+8aCbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqIMUXt+DLjQ6+mrP1Dlliu7iVTw3+p4HqdFrcIJoZk=;
 b=fkLsyKYjnYy7d3tIQS1TgCwczqMXSO/+6Z23O2m68qbAhNWruETEAGAgEbnT/Qo8tqsKinaAWatbPq5U9VoJ2Oj3ntZXlfvSiCsduNGrVWgKCeYR4lva8GqZjBLPRvojjlHhuMI+EXPunm7U60xkORhESAXXCw0HvtNxngZTrJ8=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10413.eurprd08.prod.outlook.com (2603:10a6:10:518::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:27:03 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:27:03 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 31/48] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Topic: [PATCH v4 31/48] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Index: AQHdG1sRI9UGxhYy50u6UOOVmLE1rrZ8k/eAgAsmoQA=
Date: Fri, 31 Jul 2026 14:27:02 +0000
Message-ID: <89f5ac4cbefea1c487b1d3e0c66fa80950d32324.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-32-sascha.bischoff@arm.com>
	 <20260724120955.D9D201F000E9@smtp.kernel.org>
In-Reply-To: <20260724120955.D9D201F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10413:EE_|DU6PEPF00009528:EE_|DU0PR08MB9799:EE_
X-MS-Office365-Filtering-Correlation-Id: b761e3b8-2b17-4185-3ef9-08deef0ff01a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 zvw6mbpPyuIQE4qdfhvlTTz4xFq6VHY3SpFsFCUVRiEf3IpgxNajzki9QafYu29tHa7BA8L4T4M+qkH6voEiaWpECDT2nuf5x1V4As3ILd/s/PkGiZCKvoEwNcEB2/Og+HnBTDKA6/jxqgBrtkFNugFoGpsY1CoXSqtnmc79yNbkOujghl3McJjNGeH1W66brqnaudXaNkD9hdTmb1wv3DI6U+fiYVxO2UWdkFImth6xqJCurnyarbwVcmDKHaKueG2og/nY3I60YUPDXvvydidRwJ/ZzqG6qirwoMJrM7qPlEoTsQwUtvw0h9RhSmjYv4lvSmfbyVvydOqec1mxkca/A6uscJhE41Y7kx59V6N+ZYmB7Rs5Jmf3OIVVirfiS+Ecp6wz+liIb/HLR0ehIqrU9FlIRQcZNFraVHTNi2G3rdFvmsZUeL0+PiE/sJ46NWosO/fFPjRZhKXNjtQ8DrryWb9jmICyuTELRMVTE+9/GI+O7EMP1jpqmJM/bJJc0KnzSwzyatPOs/v6DK/y4OqZT1Vn31zQWYG2mz1HqNqxweihG4Woh8JvlW8P7Olp5Tdo5TzS5wFKVX7+Nghtb1hId7yGLyC+goT5rxmDcL7lSRhpCfwlpUYzXq2I/L4Q2owl7/t45TnTT6XGeYLm8E/x36yo59l19MYrFdhmz3uPXJNXTd3bBArECTId3PhnwNIHEnth3/M2HPXmsodTkxAGXH6s5GgOa6YF+IJXaf4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0864B88E3C754944AE367B3468D880FE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Q4bJT2s2LO24ED+8xTwon2ThsdK+hbIsx4SB7aV2/dewnLjoiWTaxsmeSIC6WpZlWJ8oLASE9nMUsk73G1oHbVuUMxEx9WFMIEu6vtu+YoFNBTGSvhgUAzdKW8gsCl0expFesmHQC/iGkyEepXgce45yO50EuPXpUcRcUiJQW6keyd4JUjtTxxLXVB6uxBxKobzXkqLQ2OFhRSjSX5JtdmtYYTQbFUjCyISaJjCd9lhiNHW4/3Cp9ea/EAfQy6tteRRPenshYhqu2opjIbbRQhePlwaHFglLUcY8CJzMxvLCr5Q+7IQaIu2bkE21x0tSCyNeLX+2UJKU/bjN/fGZlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10413
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c467bd6d-eb8d-4259-e3c3-08deef0fca43
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|82310400026|1800799024|14060799003|35042699022|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KnyDqoSupgAHZFWwBu+ShNYJgj82YA0X41ufr/yPAlPlLd9Ti3WbChB7lMVKDUaiiCZiUnJqEQGfr2kZHZYC+RAhyIA1iA49teRnL2JEhdTFPApxk3i6xlBUYiXIcqJ8NtzNsxDfNjFcgfd8MxA9NQJiKXzXaqKPwatHBtFvR9tVjEdCUVBhgYFOD7ZlEJEJIX4yHe40aWXZURlejkl709AeLk+XHRpage58Je6KGyMl+4tLBRSVVwYFygLjP/7B5OJx2B3CqdGdGDx07KtN8RLKZG5q/vqKgDyG48W50BBcg4HjEtPhi20M5exKbRGpSc8NxPFjJw8XfPfeom54TnD5wp7i+Tm6jpBGe9HQGi+1umre1YBW9n1bSDE3gt5SL66YCoBZGkdG8AMLX2fMYsULfeHByND/WwDQGJq0OfuTc0OOb6BU9JfqbX8ZFpMe55Mz6tyvN16IFbPziH6NFsiejBqjugHwQ/o1zlMkfB+lwDWNwD2xRcFal8ybwddzMFRlgQ8ANShm3oW1WN56i3w6G3md+FhEDppUgXX+X1+U+jp9gkw+Y5hbgqXUkfxobuzLjxAo3ciMZn8R9SuS7TufCyfQY+IwGjp08BFhkPQlaTw0hgf7TCL/BubGOszLxCrVV50prViVwMQytu08iJGdBpFFymYsYByalIHMgkHGL5jVR6zh3+Tw6dy8X000weOQqs4TPjMWn/RBojaj7A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(82310400026)(1800799024)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CeDjzLtBwIBXAJlMpLuDtUVbvDeXpd+DOETvq4J+sSUpb/Vq/frq/3P/6mdnuDUH+pK3xDEU2cBg9np5+26yNqmsr95AuxpX6fEzOHRPtPOZcEyN6oEGn/HTxwYPNPnr0I5J6F9nuaAAdMAL0Zm1jNZmaDlIdpy2qKOxCyThq+xdNAHhgCxw/vsJhLtCDN7SLSbkVUaDmaWwIBFMQhdKxh5dsUpTyXQTeLq1sD1tANVWB9LlEFqY/PYFhy30UkBA5KmbMGA8jfTSmWtgdbwynN89pAzs8zcoLlaJ+IPWziTEF2juCAsW+b9PGMEoQ+UNFHbQ/sVZkZ2TykF9Oic+gJv9rQIHbj1F5foUM2PyhOWKRTYq5mp68smgXM4auQv8TegXzH/RTaZaWA9aQu68sG/QgHwNEUoW/wcZaug+gJ7rsJQ/QERprNzQkd86JjI7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:28:06.3893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b761e3b8-2b17-4185-3ef9-08deef0ff01a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9799

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjA5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gSW5jb3JyZWN0IHByaW9yaXR5IG1hc2sgYElDQ19QUElfUFJJT1JJVFlSX1BSSU9SSVRZX01B
U0tgDQo+IGNvcnJ1cHRzIEdJQ3Y1IFBQSSBwcmlvcml0aWVzIGR1cmluZyBzYXZlL3Jlc3RvcmUu
DQo+IC0gW0hpZ2hdIFJlc3RvcmluZyB0aGUgcGVuZGluZyBzdGF0ZSBvZiBhIGxldmVsLXRyaWdn
ZXJlZCBQUEkNCj4gb3ZlcndyaXRlcyB0aGUgaGFyZHdhcmUgd2lyZSBzdGF0ZSAoYGxpbmVfbGV2
ZWxgKSBpbnN0ZWFkIG9mIHRoZQ0KPiBzb2Z0d2FyZSBsYXRjaCAoYHBlbmRpbmdfbGF0Y2hgKS4N
Cj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMzFdOiBbUEFUQ0ggdjQgMzEvNDhdIEtWTTogYXJtNjQ6
IGdpYy12NTogQWRkIEdJQ3Y1IEVMMQ0KPiBzeXNyZWcgdXNlcnNwYWNlIGFjY2Vzc29ycyAtLS0N
Cj4gY29tbWl0IGJkYjMzMDhiNWU0YzM5MTNkYThiOTNlZjQ5MWRjOTcwMDRmZTNmZjANCj4gQXV0
aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZN
OiBhcm02NDogZ2ljLXY1OiBBZGQgR0lDdjUgRUwxIHN5c3JlZyB1c2Vyc3BhY2UgYWNjZXNzb3Jz
DQo+IA0KPiBOb3cgdGhhdCBLVk0gaXMgYXQgdGhlIHBvaW50IHdoZXJlIGl0IGlzIGFibGUgdG8g
cnVuIG1lYW5pbmdmdWwgVk1zDQo+IHdpdGggR0lDdjUsIGl0IGlzIGltcG9ydGFudCB0byBiZSBh
YmxlIHRvIHNhdmUvcmVzdG9yZSB0aGUgR0lDdjUNCj4gc3RhdGUNCj4gaW4gb3JkZXIgdG8gYWxs
b3cgZm9yIFZNIG1pZ3JhdGlvbi4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMtc3lzLXJlZy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljLXN5cy1yZWctdjUu
Yw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwMC4uNmIy
NTVlYWNiZjYwZA0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92
Z2ljLXN5cy1yZWctdjUuYw0KPiA+IEBAIC0wLDAgKzEsNTE5IEBADQo+ID4gKy8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLyoNCj4gPiArICogQ29weXJpZ2h0
IChDKSAyMDI1LCAyMDI2IEFybSBMdGQuDQo+ID4gKyAqLw0KPiA+ICsNCj4gPiArLyoNCj4gPiAr
ICogVkdJQ3Y1IHN5c3RlbSByZWdpc3RlcnMgaGFuZGxpbmcgZnVuY3Rpb25zIGZvciBBQXJjaDY0
IG1vZGUNCj4gPiArICovDQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0t
Z2ljLXY1Lmg+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgva3ZtLmg+DQo+ID4gKyNpbmNs
dWRlIDxsaW51eC9rdm1faG9zdC5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvd29yZHBhcnQuaD4N
Cj4gPiArDQo+ID4gKyNpbmNsdWRlIDxhc20va3ZtX2VtdWxhdGUuaD4NCj4gPiArDQo+ID4gKyNp
bmNsdWRlICJ2Z2ljL3ZnaWMuaCINCj4gPiArI2luY2x1ZGUgInN5c19yZWdzLmgiDQo+ID4gKw0K
PiA+ICsjZGVmaW5lDQo+ID4gSUNDX1BQSV9QUklPUklUWVJfUFJJT1JJVFlfTUFTSwkJUkVQRUFU
X0JZVEUoMHgxZikNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlzIG1hc2sgY29y
cmVjdGx5IHByZXNlcnZlIHRoZSBwcmlvcml0eSBiaXRzPyBHSUMgcHJpb3JpdHkNCj4gZmllbGRz
IGFyZQ0KPiB0eXBpY2FsbHkgbGVmdC1hbGlnbmVkIGluIHRoZWlyIDgtYml0IGJ5dGVzIChlLmcu
LCB1c2luZyBiaXRzIFs3OjNdLA0KPiB3aGljaA0KPiBjb3JyZXNwb25kcyB0byBhIG1hc2sgb2Yg
MHhmOCkuDQoNClBhc3RpbmcgZGlyZWN0bHkgZnJvbSB0aGUgQS5hIEdJQ3Y1IHNwZWNpZmljYXRp
b24gU2VjdGlvbiA5LjQuNiwgdGhlDQpwcmlvcml0eSBmaWVsZHMgaW4gYW55IG9mIHRoZSBQUEkg
cHJpb3JpdHkgcmVnaXN0ZXJzIGFyZToNCg0KUFJJT1JJVFk8eD4sIGJpdHMgWzYwOjU2LCA1Mjo0
OCwgNDQ6NDAsIDM2OjMyLCAyODoyNCwgMjA6MTYsIDEyOjgsDQo0OjBdLCBmb3IgeCA9IDcgdG8g
MA0KDQpVbmxlc3MgSSdtIHZlcnkgbXVjaCBtaXN0YWtlbiwgdGhhdCdzIDB4MWYgcmVwZWF0ZWQg
Zm9yIGV2ZXJ5IGJ5dGUuDQoNCj4gDQo+IEFwcGx5aW5nIFJFUEVBVF9CWVRFKDB4MWYpIGxhdGVy
IGluIHNldF9naWNfcHBpX3ByaW9yaXR5cigpIGFwcGVhcnMNCj4gdG8NCj4gaXNvbGF0ZSB0aGUg
Ym90dG9tIDUgYml0cyAoaW5jbHVkaW5nIHRoZSBSQVovV0kgYml0cyBbMjowXSkgYW5kIGNsZWFy
DQo+IHRoZQ0KPiB0b3AgdmFsaWQgcHJpb3JpdHkgYml0cywgd2hpY2ggY291bGQgc2lsZW50bHkg
emVybyBvdXQgdGhlIHByaW9yaXRpZXMNCj4gd2hlbiB0aGUNCj4gVk1NIHJlc3RvcmVzIHRoZSBT
WVNfSUNDX1BQSV9QUklPUklUWVI8bj5fRUwxIHJlZ2lzdGVycyBkdXJpbmcNCj4gbWlncmF0aW9u
Lg0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArc3RhdGljIGludCBzZXRfZ2ljX3BwaV9wZW5kcihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gKwkJCcKgwqDCoMKgIGNvbnN0IHN0cnVjdCBzeXNf
cmVnX2Rlc2MgKnIsIHU2NA0KPiA+IHZhbCkNCj4gPiArew0KPiA+ICsJaW50IGksIHN0YXJ0LCBl
bmQsIHJlZyA9IHItPk9wMiAlIDI7DQo+ID4gKw0KPiA+ICsJLyogSWYgd2Ugb25seSBzdXBwb3J0
IGFyY2hpdGVjdGVkIFBQSXMsIHJldHVybiAqLw0KPiA+ICsJaWYgKFZHSUNfVjVfTlJfUFJJVkFU
RV9JUlFTID09IDY0ICYmIHJlZyA9PSAxKQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiAr
CS8qDQo+ID4gKwkgKiBVcGRhdGUgZWFjaCBzdHJ1Y3QgdmdpY19pcnEgd2l0aCB0aGUgcGVuZGlu
ZyBzdGF0ZSwNCj4gPiB0cmVhdGluZyBMZXZlbA0KPiA+ICsJICogYW5kIEVkZ2UgaW50ZXJydXB0
cyBkaWZmZXJlbnRseS4gVGhlIGV4cG9zZWQgUFBJIG1hc2sNCj4gPiBpcyBhcHBsaWVkDQo+ID4g
KwkgKiBsYXRlciwgd2hlbiB2Z2ljX3Y1X2ZpbmFsaXplX3BwaV9zdGF0ZSgpIHJ1bnMgb24gZmly
c3QNCj4gPiBlbnRyeSB0byBlYWNoDQo+ID4gKwkgKiB2Q1BVLiBTZWUgY29tbWVudCBvbiBzZXRf
Z2ljX3BwaV9lbmFibGVyKCkgZm9yIGRldGFpbHMuDQo+ID4gKwkgKi8NCj4gPiArCXN0YXJ0ID0g
cmVnICogNjQ7DQo+ID4gKwllbmQgPSBtaW4oc3RhcnQgKyA2NCwgVkdJQ19WNV9OUl9QUklWQVRF
X0lSUVMpOw0KPiA+ICsJZm9yIChpID0gc3RhcnQ7IGkgPCBlbmQ7IGkrKykgew0KPiA+ICsJCXUz
MiBpbnRpZCA9IHZnaWNfdjVfbWFrZV9wcGkoaSk7DQo+ID4gKwkJc3RydWN0IHZnaWNfaXJxICpp
cnE7DQo+ID4gKw0KPiA+ICsJCWlycSA9IHZnaWNfZ2V0X3ZjcHVfaXJxKHZjcHUsIGludGlkKTsN
Cj4gPiArDQo+ID4gKwkJc2NvcGVkX2d1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlLCAmaXJxLT5p
cnFfbG9jaykNCj4gPiB7DQo+ID4gKwkJCWJvb2wgbGV2ZWwgPSAhISh2YWwgJiBCSVRfVUxMKGkg
LSBzdGFydCkpOw0KPiA+ICsNCj4gPiArCQkJaWYgKGlycS0+Y29uZmlnID09IFZHSUNfQ09ORklH
X0xFVkVMKQ0KPiA+ICsJCQkJaXJxLT5saW5lX2xldmVsID0gbGV2ZWw7DQo+IA0KPiBbU2V2ZXJp
dHk6IEhpZ2hdDQo+IENvdWxkIHRoaXMgY29ycnVwdCB0aGUgaW50ZXJydXB0IHN0YXRlIGR1cmlu
ZyBWTSBtaWdyYXRpb24gYnkgd3JpdGluZw0KPiB0bw0KPiB0aGUgaGFyZHdhcmUgd2lyZSBzdGF0
ZSByYXRoZXIgdGhhbiB0aGUgc29mdHdhcmUgcGVuZGluZyBsYXRjaD8NCj4gDQo+IFRoZSBTWVNf
SUNDX1BQSV9TUEVORFI8bj5fRUwxIHJlc3RvcmUgZnJvbSB1c2Vyc3BhY2UgcmVwcmVzZW50cyB0
aGUNCj4gc29mdHdhcmUNCj4gcGVuZGluZyBzdGF0ZS4gSWYgd2Ugc2V0IGlycS0+bGluZV9sZXZl
bCBoZXJlIGZvciBsZXZlbC10cmlnZ2VyZWQNCj4gaW50ZXJydXB0cywNCj4gaXQgb3ZlcndyaXRl
cyB0aGUgZXBoZW1lcmFsIHBoeXNpY2FsIHdpcmUgc3RhdGUgKHdoaWNoIGdldHMgcmUtDQo+IGV2
YWx1YXRlZCBieQ0KPiBiYWNraW5nIGhhcmR3YXJlLCBsaWtlIHRoZSBhcmNoIHRpbWVyKSBhbmQg
dGhlIHNvZnR3YXJlLXBlbmRlZCBzdGF0ZQ0KPiB3b3VsZCBiZQ0KPiBsb3N0LiBTaG91bGQgdGhp
cyBzZXQgaXJxLT5wZW5kaW5nX2xhdGNoIGZvciBsZXZlbCBpbnRlcnJ1cHRzIGFzDQo+IHdlbGw/
DQoNCk5vLCBJIGRvbid0IHRoaW5rIHRoYXQgd2Ugc2hvdWxkLiBGb3IgdGhpbmdzIGxpa2UgdGhl
IGFyY2ggdGltZXIsDQp0aGF0J3MgdXNpbmcgRFZJIGFueWhvdywgc28gd2UgbWFzayBvZmYgdGhv
c2UgYml0cyBiZWZvcmUgd3JpdGluZyB0aGUNCnN0YXRlIHRvIHRoZSBJQ0hfUFBJXyogcmVnaXN0
ZXJzLg0KDQo+IA0KPiA+ICsJCQllbHNlDQo+ID4gKwkJCQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBs
ZXZlbDsNCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCXZnaWNfcHV0X2lycSh2Y3B1LT5rdm0sIGly
cSk7DQo+ID4gKwl9DQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
