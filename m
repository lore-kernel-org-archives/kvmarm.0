Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011006.outbound.protection.outlook.com [40.107.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A034750F
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306200; cv=fail; b=M0IAxAhLeSiAOeP/nbRbosw3faIozwA9p4rZgMVRuy70TP/xQt94MVvdXiONxvBfOnacbo5KQOAZXbSwqPDfaq4lyvZNqZpOd+ZZ4yWBT0TrjcHJM58n1DiWqmQINCI9cuqPCk6useP3Yq9YZb6HycIoCzhsH6TSUJXjGC7s5GA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306200; c=relaxed/simple;
	bh=WWg1QwUVKXy1tTri8YoYXmqiT34EdDW0RPkyJ5p7lH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IjxBM+o71+EQ9f7u/+IOqe49rdeqWAPPny41GIzrh0Sy4gvfXOsLmrfAvVTUot+Db78eo1gzXxvnO8LDC44L7UOHrSIpCgXBjq7gtD/772dgmIL1+lKAzYgRvncGG27fNvnIUN+P9U3R/YVOSSOG+3QcWU2BALVWSuS9ipynDEs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NrnxSUZs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NrnxSUZs; arc=fail smtp.client-ip=40.107.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NrnxSUZs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NrnxSUZs"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ntQn1/VWdCXqa84JcJ5K6g8XWCD0Px+p9k+S1/fGqN65dJUjBRqM0KFbYaeLyGAEGDAcH7wBJM7iLPPV+fMn9xIdRB3DZlV2VjJHW/E3iMV45QjFDFPaeGQ4PGaXDePKfwmJaYC8ODx8BvgKPcGKfQKuPXwPFr1M/dmmzWzs5+Bgsv2XdR2HmETLNoX1iLt1Xz5aFPousHXVuRzidpDsl2szun3StJ9Xq+OrvJ/mFoOJzpUvIK1EV1DzPfM66my4cN9U8IDJ2j4Ns6GQuuEHrob9c/5IJQ4lMH3GyamOPyOqZJ4h0zl9kR9eQTbZuge6yRBl0FE505tX5LeRNkIYAQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Led/J/CnM5On+LIdDSBBHpgq3YKTAWf42uVcCJ9vFrc=;
 b=xDBbcScYEU22sMfJ0h0tZhOInt3lO6r+p/tyW6EUi4bJwksskKXOJPO+26vwB3l+TmHXVmQxFwzQBAwf9Y2d6DzP81iZwRwjn1rmtYebBrLoSLZljnbPmVrBfYkfkGtklnjMZa5C25Rs+dyq4Th2MMKJcG5j+H5Pjgwjr4flPyAwICfCXSW6Y0ZzFeH3S7AMvgKV5Js3vJilmvOwoHWPtOKwWJFXoe5CXCW6rxSVcKpE7AHFZz+/ztoZpclGwr0sn167tMCU8oh+Wisps1AlDiNoVwnqAA0hT5xsODWKLjv7F0VKWHt2cZp8steh4+GGPMNR/rE09afteG0lWEdtWg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Led/J/CnM5On+LIdDSBBHpgq3YKTAWf42uVcCJ9vFrc=;
 b=NrnxSUZsvGE4+sfvEb11Pri2Ubvrk89Bnoz2M+VxqRRhXBPjzgpAKcmjnWl8VpxEWpGOWqfbJFCnp+k5uFOfTXgFE0nk3dBL0lnqRaaiPbe915rDJnF+1HmFW4mk8RZZF1RISAQWmUGCrqVVXNUEVsQkwZRg+789Hv8XsbQRcxg=
Received: from DUZPR01CA0151.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::13) by DU0PR08MB8140.eurprd08.prod.outlook.com
 (2603:10a6:10:3ef::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:09:49 +0000
Received: from DB1PEPF000509E3.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::70) by DUZPR01CA0151.outlook.office365.com
 (2603:10a6:10:4bd::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:09:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E3.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:09:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CD7NQ6+c549gRijilY1b3woV7eEglHgLVw2TkIkS2T49ogTq4WQ7NrJ2QjAjJK5OlfIR+XWGun8af/mdanoqlZA/BBBCVTniNNcEq/3YH3uF4gKqmoCnHlLd6opBlCyuTa/EplP2BuVV8ebjDAiywT7I89zvGW2p2Ykuad0TLzU0oxvnPZpG0SBOyW7+igQl4zMJV6n8qAgTf+iQGMszz5VQ03hKiUuJo/gK3ftJsHPtKboEK5oo3i6qWhM7Kcaodz5P+eNfOvU02X5lswIO/kVFoLFLnErC+z4oxYtZONM4Vpwyc2b8nOlR8XyhcmrXd2FHFWiQ+p7rCopgl3/qzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Led/J/CnM5On+LIdDSBBHpgq3YKTAWf42uVcCJ9vFrc=;
 b=QB57xbKdsuO8RsCzHNAsJ39n2kFwBzI31N4QB4cdf9Cajcp6Je/beFA2JwRXEbEp7AZIwbY//I5IgENCJErEqgBBIw3bi8I5sypYC8DGrUlhq5fwjbN+OM/dNtc3cUwH2Jj8AI9Yw71oucQIjCj+736CPjqJ3Ta0Yi2s2Qn14+Yj5DRoJ8WWggaFZ5vsoMVnwc43gytRWlST9zOAS2btcanQWQqskl7mCb55XOaY35G7GbWbVkVWz4kkUFX0vzBpvAuuMleBM+1KdLO2YAF4PKYdgA7mDvQPleVRc4UmEYRZQRx4fMzAuFsavCPe7c36h49USAt42eS/iS+ryaWjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Led/J/CnM5On+LIdDSBBHpgq3YKTAWf42uVcCJ9vFrc=;
 b=NrnxSUZsvGE4+sfvEb11Pri2Ubvrk89Bnoz2M+VxqRRhXBPjzgpAKcmjnWl8VpxEWpGOWqfbJFCnp+k5uFOfTXgFE0nk3dBL0lnqRaaiPbe915rDJnF+1HmFW4mk8RZZF1RISAQWmUGCrqVVXNUEVsQkwZRg+789Hv8XsbQRcxg=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:08:46 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:08:46 +0000
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
Subject: [PATCH 08/43] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Topic: [PATCH 08/43] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Index: AQHc1mAgkLZPjqF1+0af8hrzLVYjaQ==
Date: Mon, 27 Apr 2026 16:08:46 +0000
Message-ID: <20260427160547.3129448-9-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB1PEPF000509E3:EE_|DU0PR08MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: e2df8494-5561-4254-9c0b-08dea4776831
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|18096099003;
X-Microsoft-Antispam-Message-Info-Original:
 JaoQ//7qRMG3TnsU7C1ToI5Pm/zeCnt8ckKM8tj0jlfPgxkM0e1ubvLWJvLoo64lTi6TneSPC66utFNeSI5EM7F+Pr4/rctHTRnLL+igTEHc1PN3dMn+TeyUKR/FjYZYPyY3IlyXDuNZX7fM5BmrE0w7UCXqBhyuggNF/TEPzlvBFN+KiqMGho4NKr4UGEscsFdbP4WJiTLI1SbYHONOJgBHF3FmTj9Ir/dYCOTTR2Nu0bPEN4d+Ef5WW0Axr2i1EvjFZlwHfNDULuE3YGQactu200AkOzbOTIMK0GcLnZbOTO3yGeR/WLM6JlhMF+p62UFnLKTVgAoPrjIJ+2kIb+VUpCrgIfjsc4LkwSY3wlIoBj2Kv/USHCWotklM2wrkpdHIJX05nl+eXYW1q7Jsiz5duoE4z8rudZo0fRkeEkVGdmGGTw0ChE52uVk38Y1tarhRyMp/i7n1VBaqBn60KWWDDiPw0UY7HpKd6gDG6E5YVnfAYiCUxqAkOmCcNbPy6g0XyUGK2RP8m28+HU3LTkYqwDAYXmfZ+BmBDvTcqePKSqQeMcWDhx80OItRraIWYwFKel+j9ABUBxBO5s6lEV86wonAody10Cj0GfUuuQPm3GJP9DholtDk9D19iAtaeHnQNuqDoMSWlO2M51W/7FZISSei2R4ffejK60gYjci2/EKhYILSX7SwkpfAguAw1HtBG53p1uwfYKeyOjeR1Gh4RSmtl9A3phsD4YsC4axSS9NfmweBU7pC+c/8aoyurGNiOXqdJ6VAxmkcWh7gZn6OpDKafqpuOlTki07L8lI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(18096099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 aWlbbdfWib1MVTHuxsSpXoIVXbPlYE+yN6oCjftiWZHvNgKTKJEtPPxwTDee0zsRG3UO94YnnXl8zoYkTCZlj/y49+zvp38dvwhZ/yc7LbnfC1BWLtJZePenqHvIplMwIuegOexfJrUPVxWHeTkSAXLWRMh/0Z2SxgiqVWjlnVL/bPzHpaT+Tqj1e2wXlPMkCg42WiXHbNHM2tiYbbdpFJ3fhqA9G6KVIr5mRHwFi14F5qE+KpF4FfMdYbLwS0JX5o1UgkokBuNJl6arUafpoLzt5EBaKJbHif1uBfUz4dU/2kXgzX/pUgMJGEvJMTSdDuXuZ4fWBkv5GylQvfGFBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	853fce4d-72ff-48c3-e868-08dea47742d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|1800799024|82310400026|18096099003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tDNSKMzCpxWK+PbxDjRHlFK27Xq9XURQtVZeWmL5U7B2rgEi3cCyL/ryPINbL3X/ttRfOiLXZZK6Jl0qWVNh2SFeU90owf9wvnbp8NFJooSGAIUj4LyBIioz84ulC3sevCO8mNMukxTh/zcZehztLCGe/rlUQtgxBA/z0Hzycz+S91OnsCKiqp/MCjlaVQNNvgncoWP6lC/cA83PKd/mJLskPoiU/ECZG2c5Ll8UNU8r91/OHK63XAN3caYbobiColDLqMm5aSC1gKtjahaktbB7f4yJcehBDnopYhyT7+PuEGTb8CIV/6EvoMtDdFjL3GyKDWeJf1n8vz8QlaI2NudY+XBx2ull5P8U4rZMS/9YZnrVb/mg3Uj3ulfoRW72TeNgzGeZk1BIfT4eznGlyKsfybnZK0KuyTlBIThhZN/F7Q2VbTqnDnXGXgT5hE/q+OrkDP6hYhgWhKv1sdAdlMM/LTiYVF0CDDFPJRM9HIONPjwYuPG5yh4uu53fWZpMQmWiWwJzKbmGoM0Nz41HhUbgJ1aExYmVTBfbTIrZZFsCedO7+BoUp6UhS8K1fIogBF5xVHUAu6/9YibHQ4BD7QLq81oErZLufh1inBW/GMO3FmBi7Q/cVbMW9D42lQ/THAVM7FP2YyCEbyFVPPlbpOmUBN1g4MM/RauoGoiUiixCK091XLDhnwtGzf0w/oj1zeOkztfWsHelLcgBdjX3kPvRMVVbkUIzNKxMDo/W6ys3CtSMrZbXlP3x6jH/cL0WxFU1ITpk8JeMFXX7jCjImw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(1800799024)(82310400026)(18096099003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ztjK09n1hAlruOoX4j/l5rQXo/7mbj/QjXyX5ucwtPour3LjKOZDqWqz2A/fJqoUHh9KFvfIUQZCC1NXX9pyXh/F7XNxsKB5irZlmXYS03YI66zKOIsE6AvXvHEueEcuJo4jlI9rmoITF2TezXVY5NRsnPICE9CKvjPAMcP8wneparo1vdTCZWZspYyQ0c1B5xrN51svsm8VephTkPjgCfs6WEa0dSLz+bYrfzSmmewArqESU8kxyYCPMOXPq6d9wMnM56mJYnko31whbRARBEsrB2ujSVAAyRXMAKgfQm41NMoVPRoNWAyawwMBvGGVQBef3G466UM4e9j/QF5tHi789DjAkNHiNsgOQRDJbhNnmawRbtSyHN3AQPVXpeLGf9oJ9IzcLdqZgWLg7OoWKzm0IyGNDgW/c1aPzJpi1erSMaaDRdrEDjUcrxKXqv1J
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:09:48.8250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2df8494-5561-4254-9c0b-08dea4776831
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8140

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the
host's IRS via the VMTE.

On a host GICv5 system, SPIs do not require any up-front memory
allocation prior to their use, unlike LPIs which require the OS to
allocate an IST. For a GICv5 guest, the same holds from the guest's
point of view - the SPIs should require no explicit memory allocation
by the guest. This means that the hypervisor must provision the memory
which it passed to the IRS for managing a guest's SPI state.

In light of the above, the hypervisor allocates the SPI IST prior to
running the guest for the first time. As only a small number of SPIs
are expected, this is always allocated as a linear IST. The host is
responsible for freeing this memory on guest teardown.

For LPIs, the OS needs to provision memory for state tracking. This
applies to both hosts and guests, and so the guest will provision some
memory for the LPI IST. However, this is not directly used by
KVM. Instead, KVM allocates a shadow LPI IST which is passed to the
IRS (in the VMTE). Again, on guest teardown, the hypervisor must free
this memory again. The LPI IST is allocated as a two level structure,
as many more LPIs are expected than SPIs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 531 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  22 ++
 include/linux/irqchip/arm-gic-v5.h   |   3 +
 3 files changed, 556 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 502d05d46cccf..de905f37b61a5 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -501,6 +501,25 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
+/*
+ * The following set of forward declarations makes the code layout a *litt=
le*
+ * clearer as it lets us keep the IST-related code together.
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -531,6 +550,18 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	kfree(vmi->vmd_base);
 	kfree(vmi->vpet_base);
=20
+	/* If we have an LPI IST, free it */
+	if (vmi->h_lpi_ist)
+		ret =3D vgic_v5_lpi_ist_free(kvm);
+	if (ret)
+		return ret;
+
+	/* If we have an SPI IST, free it */
+	if (vmi->h_spi_ist)
+		ret =3D vgic_v5_spi_ist_free(kvm);
+	if (ret)
+		return ret;
+
 	xa_erase(&vm_info, vm_id);
 	kfree(vmi);
=20
@@ -634,3 +665,503 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+/*
+ * Assign an already allocated IST to the VM by populating the fields in t=
he
+ * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
+ * if the paths to reach it might be vastly different.
+ */
+int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+			    bool two_level, unsigned int id_bits,
+			    unsigned int l2sz, unsigned int istsz,
+			    bool spi_ist)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct gicv5_cmd_info cmd_info;
+	struct vmtl2_entry *vmte;
+	unsigned int section;
+	u64 tmp;
+	int ret;
+
+	section =3D spi_ist ? GICV5_VMTEL2_SPI_SECTION : GICV5_VMTEL2_LPI_SECTION=
;
+
+	if (ist_base & ~GICV5_VMTEL2E_IST_ADDR) {
+		kvm_err("IST alignment issue! Address: 0x%llx, Mask 0x%llx\n",
+			ist_base, GICV5_VMTEL2E_IST_ADDR);
+		return -EINVAL;
+	}
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	/* Bail if already allocated - something is broken! */
+	if (FIELD_GET(GICV5_VMTEL2E_IST_VALID, vmte->val[section])) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+		return -EINVAL;
+	}
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
+			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_STRUCTURE, two_level);
+
+	WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, false);
+
+	/* Finally, mark the entry as valid */
+	cmd_info.cmd_type =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID=
;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd_info);
+
+	/* Any cached entries we now have are stale! */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), false, true);
+
+	return ret;
+}
+
+/*
+ * Helper to determine the correct l2sz to use based on the combination of
+ * PAGE_SIZE and whatever hardware supports.
+ */
+static unsigned int vgic_v5_ist_l2sz(void)
+{
+	switch (PAGE_SIZE) {
+	case SZ_64K:
+		if (gicv5_host_ist_caps.ist_l2sz & 0x4)
+			return GICV5_IRS_IST_CFGR_L2SZ_64K;
+		fallthrough;
+	case SZ_4K:
+		if (gicv5_host_ist_caps.ist_l2sz & 0x1)
+			return GICV5_IRS_IST_CFGR_L2SZ_4K;
+		fallthrough;
+	case SZ_16K:
+		if (gicv5_host_ist_caps.ist_l2sz & 0x2)
+			return GICV5_IRS_IST_CFGR_L2SZ_16K;
+		break;
+	}
+
+	if (gicv5_host_ist_caps.ist_l2sz & 0x1)
+		return GICV5_IRS_IST_CFGR_L2SZ_4K;
+
+	return GICV5_IRS_IST_CFGR_L2SZ_64K;
+}
+
+/* Helper to determine ISTE size based on metadata requirements */
+static unsigned int vgic_v5_ist_istsz(unsigned int id_bits)
+{
+	if (!gicv5_host_ist_caps.istmd)
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (id_bits >=3D gicv5_host_ist_caps.istmd_sz)
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+/*
+ * Allocate a Linear IST - always used for SPIs and potentially LPIs.
+ *
+ * The calculation for n has been taken from the GICv5 spec.
+ *
+ * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2() =
of the
+ * size).
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits, unsigned int istsz)
+{
+	const size_t n =3D id_bits + 1 + istsz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+	u32 l1sz;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	/*
+	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
+	 */
+	l1sz =3D BIT(n + 1);
+	ist =3D kzalloc(l1sz, GFP_KERNEL);
+	if (!ist)
+		return -ENOMEM;
+
+	if (spi_ist) {
+		vmi->h_spi_ist =3D ist;
+	} else {
+		vmi->h_lpi_ist_structure =3D false;
+		vmi->h_lpi_ist =3D ist;
+	}
+
+	vgic_v5_clean_inval(ist, l1sz, true, true);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level IST - LPI, only.
+ *
+ * The calculations for n, l1_size have been taken from the GICv5 spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	const u32 l1_size =3D BIT(n + 1);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ist =3D kzalloc(l1_size, GFP_KERNEL);
+	if (!ist)
+		return -ENOMEM;
+
+	vmi->h_lpi_ist_structure =3D true;
+	vmi->h_lpi_ist =3D ist;
+
+	vgic_v5_clean_inval(ist, l1_size, true, true);
+
+	return 0;
+}
+
+/*
+ * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
+ *
+ * The calculations for n, l1_entries, l2_size have been taken from the GI=
Cv5
+ * spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	const size_t l2_size =3D BIT(11 + (2 * l2sz) + 1);
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l2ist;
+	__le64 *l1ist;
+	int index;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	l1ist =3D vmi->h_lpi_ist;
+
+	/*
+	 * Allocate the storage for the pointers to the L2 ISTs (used when
+	 * freeing later).
+	 */
+	vmi->h_lpi_l2_ists =3D kzalloc_objs(*vmi->h_lpi_l2_ists, l1_entries,
+					  GFP_KERNEL);
+	if (!vmi->h_lpi_l2_ists)
+		return -ENOMEM;
+
+	/* Allocate the L2 IST for each L1 IST entry */
+	for (index =3D 0; index < l1_entries; ++index) {
+		l2ist =3D kzalloc(l2_size, GFP_KERNEL);
+		if (!l2ist) {
+			while (--index >=3D 0)
+				kfree(vmi->h_lpi_l2_ists[index]);
+
+			kfree(vmi->h_lpi_l2_ists);
+			vmi->h_lpi_l2_ists =3D NULL;
+
+			return -ENOMEM;
+		}
+
+		/*
+		 * We are not doing on-demand allocation of the L2 ISTs, and are
+		 * instead provisioning the whole IST up front. This means that
+		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
+		 * the overall IST is not yet valid.
+		 */
+		l1ist[index] =3D cpu_to_le64(
+			virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
+			GICV5_ISTL1E_VALID;
+
+		vmi->h_lpi_l2_ists[index] =3D l2ist;
+
+		vgic_v5_clean_inval(l2ist, l2_size, true, true);
+	}
+
+	/* Handle CMOs for the whole L1 IST in one go */
+	vgic_v5_clean_inval(l1ist, l1_entries * sizeof(*l1ist), true, false);
+
+	return 0;
+}
+
+/* Allocate a two-level IST - LPIs, only */
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int i=
d_bits,
+					   unsigned int istsz, unsigned int l2sz)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	/*
+	 * Allocate the L1 IST first, then all of the L2s. Everything
+	 * is preallocated and we do no on-demand IST allocation. This
+	 * is to avoid needing to track if and when the guest is doing
+	 * on-demand IST allocation.
+	 */
+	ret =3D vgic_v5_alloc_l1_ist(kvm, id_bits, istsz, l2sz);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_alloc_l2_ists(kvm, id_bits, istsz, l2sz);
+	if (ret) {
+		/* Free the L1 IST again */
+		vmi =3D xa_load(&vm_info, vm_id);
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D 0;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vgic_v5_free_allocated_lpi_ist(struct vgic_v5_vm_info *vmi,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2sz)
+{
+	if (!vmi->h_lpi_ist_structure) {
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D NULL;
+		return;
+	}
+
+	if (vmi->h_lpi_l2_ists) {
+		const size_t n =3D max(2, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+		const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		int index;
+
+		for (index =3D 0; index < l1_entries; ++index)
+			kfree(vmi->h_lpi_l2_ists[index]);
+
+		kfree(vmi->h_lpi_l2_ists);
+		vmi->h_lpi_l2_ists =3D NULL;
+	}
+
+	kfree(vmi->h_lpi_ist);
+	vmi->h_lpi_ist =3D NULL;
+}
+
+void vgic_v5_free_allocated_spi_ist(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return;
+
+	kfree(vmi->h_spi_ist);
+	vmi->h_spi_ist =3D NULL;
+}
+
+/*
+ * Free a Linear IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	struct vgic_v5_vm_info *vmi;
+	int section, ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	if (spi) {
+		section =3D GICV5_VMTEL2_SPI_SECTION;
+		vgic_v5_free_allocated_spi_ist(kvm);
+	} else {
+		section =3D GICV5_VMTEL2_LPI_SECTION;
+		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
+	}
+
+	/* The VM should be dead here, so we can just zero the VMT section */
+	WRITE_ONCE(vmte->val[section], 0ULL);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+
+	return 0;
+}
+
+/*
+ * Free a Two-Level IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
+{
+	unsigned int id_bits, istsz, l2sz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l1ist, tmp;
+	struct vmtl2_entry *vmte;
+	int section, l1_entries;
+	size_t n;
+	int ret;
+
+	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
+	if (spi)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	section =3D GICV5_VMTEL2_LPI_SECTION;
+	l1ist =3D vmi->h_lpi_ist;
+
+	if (!vmi->h_lpi_ist_structure)
+		return -EINVAL;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	/* Calculation for n taken from the GICv5 specification */
+	n =3D  max(2, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1);
+	l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+
+	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	/* The VM must be dead, so we can just zero the VMT section */
+	WRITE_ONCE(vmte->val[section], 0ULL);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+
+	return 0;
+}
+
+/*
+ * Allocate an IST for SPIs.
+ *
+ * We don't anticipate a large number of SPIs being allocated. Therefore, =
we
+ * always allocate a Linear IST for SPIs. This will need to be revisited s=
hould
+ * that assumption no longer hold.
+ */
+int vgic_v5_spi_ist_allocate(struct kvm *kvm, phys_addr_t *base_addr,
+			     unsigned int id_bits, unsigned int istsz)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	ret =3D vgic_v5_alloc_linear_ist(kvm, true, id_bits, istsz);
+	if (ret)
+		return ret;
+
+	*base_addr =3D virt_to_phys(vmi->h_spi_ist);
+
+	return 0;
+}
+
+/*
+ * Free the IST for SPIs. Should only happen once the VM is dead.
+ */
+static int vgic_v5_spi_ist_free(struct kvm *kvm)
+{
+	return vgic_v5_linear_ist_free(kvm, true);
+}
+
+/*
+ * Allocate an IST for LPIs.
+ *
+ * Unlike with SPIs, we anticipate that the guest will allocate a relative=
ly
+ * large number of LPIs. Therefore, while we support doing a linear LPI IS=
T, it
+ * is expected that LPI ISTs will be two-level.
+ */
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	unsigned int istsz, l2sz;
+	phys_addr_t phys_addr;
+	bool two_level;
+	int ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+	l2sz =3D vgic_v5_ist_l2sz();
+
+	/*
+	 * Determine if we want to create a Linear or a Two-Level IST.
+	 *
+	 * If we require more than one page for the IST, create a Two-Level IST
+	 * (if the host supports it, which is likely).
+	 *
+	 * Note: GICv5's istsz is not the size of the ISTEs in log2(bytes). It
+	 * is 2 less, hence the +2 below.
+	 */
+	two_level =3D gicv5_host_ist_caps.ist_levels &&
+		id_bits > PAGE_SHIFT - (2 + istsz);
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_linear_ist(kvm, false /* LPIs, not SPIs */,
+					       id_bits, istsz);
+	else
+		ret =3D vgic_v5_alloc_two_level_lpi_ist(kvm, id_bits, istsz,
+						      l2sz);
+
+	if (ret)
+		return ret;
+
+	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
+	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
+				      istsz, false);
+	if (ret)
+		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	return ret;
+}
+
+/* Free the LPI IST again */
+int vgic_v5_lpi_ist_free(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist_structure)
+		return vgic_v5_linear_ist_free(kvm, false);
+	else
+		return vgic_v5_two_level_ist_free(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 5501a44308362..37e220cda1987 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -54,6 +54,13 @@ struct vmtl2_entry {
 #define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
 #define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
=20
+/*
+ * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
+ * the VMTE (0-based).
+ */
+#define GICV5_VMTEL2_LPI_SECTION	2
+#define GICV5_VMTEL2_SPI_SECTION	3
+
 /* Virtual PE Table Entry */
 typedef __le64 vpe_entry;
 #define GICV5_VPE_VALID			BIT_ULL(0)
@@ -66,6 +73,12 @@ struct vgic_v5_vm_info {
 	vpe_entry __iomem	*vpet_base;
 	void __iomem		**vped_ptrs;
 	u8			vpe_id_bits;
+
+	/* Tracking for the hyp-owned ISTs */
+	bool			h_lpi_ist_structure;
+	__le64			*h_lpi_ist;
+	__le64			**h_lpi_l2_ists;
+	__le64			*h_spi_ist;
 };
=20
 struct vgic_v5_vmt {
@@ -146,4 +159,13 @@ int vgic_v5_vmte_release(struct kvm *kvm);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+			    bool two_level, unsigned int id_bits,
+			    unsigned int l2sz, unsigned int istsz, bool spi_ist);
+int vgic_v5_spi_ist_allocate(struct kvm *kvm, phys_addr_t *base_addr,
+			     unsigned int id_bits, unsigned int istsz);
+void vgic_v5_free_allocated_spi_ist(struct kvm *kvm);
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_free(struct kvm *kvm);
+
 #endif
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 89579ee04f5d1..ccec0a045927c 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -450,6 +450,9 @@ enum gicv5_vcpu_info_cmd_type {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
+	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
+	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
=20
 struct gicv5_cmd_info {
--=20
2.34.1
