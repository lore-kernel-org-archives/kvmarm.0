Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013033.outbound.protection.outlook.com [40.107.159.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C223B6C13
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357818; cv=fail; b=b/iMRkS44bFLIMzwvg/vzvYLs3We59e8l8hQd3Gi51HJBrWBFbssz4c4kcY6hF+ZFcbc+bpaTd8218JACqFXn73PERZDuvY7zV3WqWhuWi4sXQyRX7QIroJGgikL9srAfykm24KROh2TNXi+vf4ckDMPbG0YjpD5zLQ5pQIneps=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357818; c=relaxed/simple;
	bh=/KjJJtRv+Kd/9+kocQMDNH1Ho5+3bw2LNYZPTfVbWoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fmek/CgfR5M0lMhzTXt8mURLsg2pQm73Oi3Wkj/vp91oySQxe5mpTMtG+NAT/ZMt/iEzYMteWMTl3brOqrw96zgdpLPAibkCJ1Xib4Uqn9hSgrHKM3/Y2iLAdbXoXYy8+l6lBwqLCc5dqmhUOY6ncqrIFub1xSs1IdlNnVaJDTs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iNptT2DA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iNptT2DA; arc=fail smtp.client-ip=40.107.159.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iNptT2DA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iNptT2DA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Nld4rpnKbHmsJoZPRIOzBy8w9qyLFWlOR3HlNUzrc2+/8jrG9UGFgXQh78zWYEI8rrFCnFYVE/YDO5aybbOjZnN8EQTyhc99ELtsMgz3U0ZYfh6H+kXf3SZJy+Z5wlYM//J8qkqhfuPOVnlNFbvHxiRUOYBOwZ5dM6Jdf6cZgOchXVe5Mpz9/M7axMFRFzjII034wLlGEhaYtUCqZxwIv+nG6+KzFJD+3xm6YG+zyvVyfsO8o48ual/4n6gNwzJO6UsEAJz1GqsMQD3GlEUXa8EyfwmcTygC6pOx9yG0zdLYTjQoQNyc+BxXKST8ASKAfYoBU8/eWOdi9QZIyJkpgg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZjbuF0CjDl54tJIBGgH1xCfEn9RmXHSZeyDuF0pb5k=;
 b=FuAu8X3GcLlaE7wXoPQIirdRDS53sdCHN5bXrE4qHDmdDpm0oAiGnQ6eCMxdeirZRcfUiV1rYFJP8kF9D+f/CLqjm5/HfToXI/nLzooKR0mOpLcOxxQ3Ja1cqRMb5ytRBDsFmQjN3BXpyB01zH5GFA3I32/bDFFRyGa6MBOdMs1o7sxlK8sFdC3cINfiQ8PJ7S5Pt6CCnXuFkMeqvJnYio9lshvzmWzW4R4/WAwLm5y1LgviXisHL8qEJWlQQzQ04D5n7rxAKBJHfgEqqcpnFlcxDl9vmjq1k8IsDp4IG7xuA0ca9JE9WL4HBV71XFcYHm2Z+aqCXQNYSKI8v+B0DQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZjbuF0CjDl54tJIBGgH1xCfEn9RmXHSZeyDuF0pb5k=;
 b=iNptT2DA3+scdrrcf0BldFee9qbuFOjakR1/E7tSmfwWvtyPno9JytV1azzSwQYPe5LHumCX8Y1uj3LXMl7tmdE1+gWsAGQ0N231xbKGbi3Rc1W8dtUcz6tnAe/b6tpDc7OtQOh1Z9vbR1/HgOHp/RT8bP4bNshCW0lQ+/eB6iM=
Received: from AM9P193CA0004.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::9)
 by AS4PR08MB8117.eurprd08.prod.outlook.com (2603:10a6:20b:589::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:30:11 +0000
Received: from AMS0EPF00000195.eurprd05.prod.outlook.com
 (2603:10a6:20b:21e:cafe::2b) by AM9P193CA0004.outlook.office365.com
 (2603:10a6:20b:21e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 10:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000195.mail.protection.outlook.com (10.167.16.215) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Mon, 10 Aug 2026 10:30:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gE0IyytSl+CtPgvYlVn6Fyi1qi+HOQ10f5+LVKYW4neiJgybTSvTZNuf9zvxoh5NJGJAHPQD1qAaYOFiBqHxktL/Ihb76tGfUgGv1rOiFxXlVHDshVXdfqWYTDXmJkitoNLUuA/Q59aCO2YPAjb77ztLt27jAlNVSVRd9ctur2zAbbOAtNY1uTYwQFUEcV9DDdFIKdyxjAV8y4jwfaBekA83c9JACygbFHLkSa1XvknFOvM1On7wn4ukQx6N/VVEtV7Uf3+ZUVNkKzJeKgV0XJG2lhDjPFN8ECAb2rip9SoSikEIvl7m6x9Z1v+6cK2ziT3G9xSxzH1OEF0Ur+drfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZjbuF0CjDl54tJIBGgH1xCfEn9RmXHSZeyDuF0pb5k=;
 b=cc9AOt4BNCdk+aawVp7nihqZS+NDzDmYqJjEAX71ne8hASvmPGMvJEO5BOoOjjCR5EYPs6q2b/3YRSaVJ2zgXJ+FI1ALIyBLboi1wko4PR67BB8uGmNfo1P422B4jqgf1aAIQQ62LgjN2/jHR4O1n4KyVIxZxB89VpxoT5mteXFyIJTTlDZlekj61Wc73zVdstbX6ALBVMBClgKwSQEsAAS+2NaSU6iasq2CCr8hzBEAaPW7acSAaWV+8k/aqqsasWL6Pe+7W+hDoGLvUGTX4Az18WIdH4yPkP7f7QpGDU7G4584Ec/28D8alBFPZzgQuyz0s/OxHOW2zcFBg0yIFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZjbuF0CjDl54tJIBGgH1xCfEn9RmXHSZeyDuF0pb5k=;
 b=iNptT2DA3+scdrrcf0BldFee9qbuFOjakR1/E7tSmfwWvtyPno9JytV1azzSwQYPe5LHumCX8Y1uj3LXMl7tmdE1+gWsAGQ0N231xbKGbi3Rc1W8dtUcz6tnAe/b6tpDc7OtQOh1Z9vbR1/HgOHp/RT8bP4bNshCW0lQ+/eB6iM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM9PR08MB6179.eurprd08.prod.outlook.com (2603:10a6:20b:2da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:29:39 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:29:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Thread-Topic: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Thread-Index: AQHdKLMlod7tzVDC5EqI7uHOH0KrTQ==
Date: Mon, 10 Aug 2026 10:29:39 +0000
Message-ID: <20260810102652.758719-6-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|AM9PR08MB6179:EE_|AMS0EPF00000195:EE_|AS4PR08MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 98333db5-365f-4582-bcea-08def6ca5b84
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|3023799007|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 y8oxcQzGoRp/K3Ij+rotrIs27Ak8NVvNAkqdAF1Lh2picD/CEBBQ/O9Mwd2veAossjfwWNn2E5W2KkSuDL3XBHc3lDas5IFsezOf3UvMnqMCYK9Wbrr08+eo38k9ZeOWo2m8ZvVS1hKJizB5l6GbZxGNeOeg5J03ORH5xrdMq5JqxUotqGA6mBYLvRYrjr0i/6QGOgj0dooa79LNhY3JPZa1oXxnfpiNADMdufIfZpEF6sUDJHhVxLTrQTKeM9b268U/HxFhT/U1hRVOvNswq2c3lLWx05sGjbrNupo8WhZUx9OubznzSWAljBG8XwRReDMctD+p984ThfOpoc+d8Ea/9rVMq7pwMcBWfEhLhS6B/b0t4I06J9F/6hkNzQ6jhX6Ow0AwsdtmHWI/rthsjLPDhIiqkOXYFyglJcytpSnVCtvbn6qE/rBF0mPRxAF/jdNjOUG+qMEjIqEH+2QlOlEuhaLAM28GU0TnlG5VnPEQoIBdYych3I9/jgCpm9zcD36/i6wmxW7miUYe0yFYR5QgNdptYdGFEyM3ivy8ZEuHASgGHKQuIuVbsmRD70TJ+hAxr/uTB0F2LjdmF2KuT/Qharn3+aA/9mCNI0mG+9RD7ElOiTzbEH3nPZ5cqZ3ES3+j3eNzlRhA0fVtM5blRCi3iwIi2VQDo3YxFK+wfgk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(3023799007)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MhqqhlZbyAcmIZH5DdYG7cZJeOHNGfoznC1Cdeg1YTgYBF9SgZaShGJzyZBoBcD8l8FUYWRbVT4zj4rMcMRJS9df6/CXlVUEzur1ykjid1csozWSMsoS58eIZKKDhcVTD20oLtkZxCCT8RF7QrMguKU+4cjqJHer4EoMpSvNueBjSaFbgn11dFXaENhKrb2WiL52+9mKDVuW1sjCb244lMVfd3m/clzgMprj9a1iUejUl0Hjn22rOV1Dhzt7Yk0LoZbmMokwAkqZvxGrvizL6cs3kpKvJ2rhLldSFcGOBfekDB5z5wLVF3MaaeASLuheD6+Qpraq4YndoGae9T+trg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6179
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000195.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	221fbc80-896e-4272-a800-08def6ca4857
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|1800799024|23010399003|82310400026|14060799003|36860700016|11063799006|56012099006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZpYrOaoxy4EpiKOPwprNQvv0Zb67SCnY3n9bbRkZyPyMqzityqUcYw7g5KV32vK+DLECbqB/V8k5nXcORX37MNG8AhzLKqBpzL8mE3S5MaekFoBIseyD8AmyoII8LYEyZMuqe/xpOluzPP3AMWavflVJSsRH78bClkfyLw2OKHo5irQBLuyuipyXFrT4TkueCgqgdw0uyBA0aGDnZBjuFotsLH7Z/kLNTwu3EeOCqX/hTFfwCMqvwqR+YFpsXFUXBrk7qERQgOA62V0hP9AuVkuhLjb1w7sfXW3atkfSb98LfFIF2mziaWQM2NVI4ydtwJ/NX2b853vhxXW7yB2sY4m19mf5nVx+7Mm4dDAXyiCTGOMv8yxRoPMv0s6K9QECIZHutBE8yH1LZEO1eb1jDi974f9ZdeOzT7+EYzj/4SquvleAgHFOvH4gbnO+Jqw4wIkwpN2XKgolAMBaGZiVWwzr+FqTB3JvAFRKjkIMko1dn4RaUyJBolu9Qz7s5aBpItZPhLyo95Fw1y10hsM8f27QdRWSi9UEc/fCXUov61ofcAADdKPnjgh8H0phkjH0aBiMTpsaQnu8fUVoeMy3AbNi+85OLsYKnxS9jghmJjYDIGFZ7s6hbQ0FV7qs/Gxwq7lUQbfpCTMKBCr2L4JsbQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(11063799006)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JuWyrSYkySQFRAT/DCrSb63tMJ0MovzjW73jT3QTsLny13vAMaYkogan9cPIax+niDDSUHaBuCOzA6Lu8ERhtyuNh0Oocvu9tiegulxmji+8/T33Js6nWjQSUfunFYVH6LYaMsBmplLWmYIiXZA2Uo8pLC1qcevogAlyYWIdhXVEpzfjWVgT7tyCeW0gMtMjjfQ5NpfaHDylr0TvwK8nlq9dJk5prGl/1/QNFHa/fPSBLQ5I5yUel4BLIyN62wIUHKz6bppldoM/Kr+dHSMfeWCw5foI+qpSHzuHIr42BkcE11H53KXXLekL7Mvo2ENq6F3A2Pu1HZYaFUDRir0e62BQu6M5Zobycp//lKwZBrSW4SwIEeIwU4Y1CQSqpRFVr1Y9b9x0Ie6Xftq2nLXiZqMGEjSQrv1J5lreUjLUapUsvDBmTemtcSHSMTS/qDun
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:30:11.1561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98333db5-365f-4582-bcea-08def6ca5b84
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000195.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8117

GICv5 supports up to 128 PPIs. In KVM, we have chosen to only support
the first 64 which correspond to the architected set of PPIs.

The GICv5 PPI helper checks only the encoded interrupt type (the top
bits of the interrupt ID). An encoded PPI with an ID outside KVM's
supported private-interrupt range therefore reaches the lookup, where
array_index_nospec() clamps it to zero and aliases private IRQ 0.

Reject out-of-range GICv5 PPI IDs before looking up the private IRQ.

Fixes: 4d591252bacb ("KVM: arm64: gic-v5: Implement PPI interrupt injection=
")
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D27
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 352d52bd6315c..b25303d9919fd 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -118,6 +118,8 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcp=
u, u32 intid)
 		switch (type) {
 		case KVM_DEV_TYPE_ARM_VGIC_V5:
 			intid =3D vgic_v5_get_hwirq_id(intid);
+			if (intid >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return NULL;
 			intid =3D array_index_nospec(intid, VGIC_V5_NR_PRIVATE_IRQS);
 			break;
 		default:
--=20
2.34.1
