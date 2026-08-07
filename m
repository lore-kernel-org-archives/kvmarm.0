Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011071.outbound.protection.outlook.com [52.101.65.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5D430CF9
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101747; cv=fail; b=L58M0DLJzMDvp51sybZkhiDYXasjenfFV3z89+kTvmPgE/Dn5AsjCLavkaUoocYpdXdmbdYIrxqIC++ZbGl2F7fstrOi9GX41QFGMdSkD0CF6c+wew3rk+q5mTETrav8tCJJn/5XdSY0vhHFLCr3JpAXNrdXXWTmNjgo104MQwI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101747; c=relaxed/simple;
	bh=OZ+oa4zBSzHvPVf0vpxOx7My7OH8JgI2Tap2ZK5qiQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SyLa35VzitXmX757tmjpH6eabpA01shL17WQMqZP7sUkWNVw15uxjMjemcEjyoqrZrZ70zEqEIITMsDiORGHv4zriROKRrtqUlBR+VnAjpSGcf2IZQhjbPNzfhq/oYAPZcIcNU6tcLLnqVHgB0l1DfG0zGt+7FD7Z7+lO3mjGPM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AexWYwTq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AexWYwTq; arc=fail smtp.client-ip=52.101.65.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AexWYwTq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AexWYwTq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=G5RgO/gD3OZhLiD4jHoFtQeH1c106SRCMgCPTwWvmlelTdQpsVwJ9FcCiXs7F+K2JgI2fGkvFe34KQryKHXdkphYJm056KWANuHs9pnsWnNI2M2XEb71AipyaJWj7DvOTKPxrJ8BX28piaHEQyk5nXPnLclRtWHAhKF2bT3Okg3V+fQg1fK6bSRNR3By23hxjwOb5R29+ynOl5MErRiSNWwKyIPWpMJS7O/OYP4WTi495kswcMckP4ktwMWFnWMC35Rtr6mo+gdbguevohgeSweqyvCDDkFkajY0TbW2PiXMRWHTl6TfQhC4IF/+he3J5Cx2sPr7bj7XwiXJoL6jdw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFW06+lQEv/5EB+xuksvV92uCzAIW0f9/mVF0hqBJoU=;
 b=rjmj0rIDacPCikMZqZw3S3cWKeWugkciZKEIJAn9Y/qwla+K0r/GqeUbnMwB8n7R7kakgwDEhY1GbLgfSfskHn62A87/VInutjXK3vMiibMVU7zSWJjNjEFa1hfbwwZcTureU0xXvoVGhbfhXz540Mh6fpDch2H0RJ4bVtSh4nAn0x5mq7+hLCn19Jzv5HSjFZt0LYWsSQhUrlQc2AxrOJUwHLeva5dq2FAfUWI9zpBDzMUJHR5MBkHFQj75amkgYjsIYpXqpfhJDXVZfU5zrNUJmrMO64hQaQb+gp+vDnJSmrvMX398UKpIknemSc7+0giq/rXfDPKMdrbDGI+/qw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFW06+lQEv/5EB+xuksvV92uCzAIW0f9/mVF0hqBJoU=;
 b=AexWYwTq3YAuTb1LEdBpVTg/lRSbcI5X5kGvRlJuSpetO0g133ZXXea9lQBu+m5qH1E+PIuA8oehfPtkm3piX1XbZ1q4T6N9ELBjxuuDsWjylbRi1XfEe4nVDSnf1BEswNNfHQ4gWVbik08qsFH+WWkloBzluBw+PHrHiX38HNk=
Received: from AS4P195CA0027.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::16)
 by DU0PR08MB7737.eurprd08.prod.outlook.com (2603:10a6:10:3bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:22:19 +0000
Received: from AM2PEPF0001C715.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::16) by AS4P195CA0027.outlook.office365.com
 (2603:10a6:20b:5d6::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:22:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C715.mail.protection.outlook.com (10.167.16.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:22:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/4opb77vfnP1wIQgjWufFpCsYFTsYhj7bxP4esEmnbAOokj1CJiAhdAkdXT0b+5WlVOdvS0T+vnynb97w+wuTCz57Ix3qGX+KLpkmKA78FzbS9qRkOLj4a0UCJ/O4ac0H0nbpM0nj/q+hfNrE6uIUAVpJAG0MnDLzTTpiWtFDtIeiI+34pg4x23j+RQVDjFfU47XbzcYt2xt21i7MVzYb9893iT3Ywfmv0DEjBx+BSvnRyOIg5m/f0n3T54E5vM85qtW2/f5yjDqiPOtIJkjtYuLck62w6Zd0RYIuz1uUnXXZjI1nJxgA2wX9Cw9vA1wry/5bh+E0kbDF8soDYVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFW06+lQEv/5EB+xuksvV92uCzAIW0f9/mVF0hqBJoU=;
 b=ZLUrq+IMfk3Td1g+RJGcHPxQeOQPawjY0LM4UB5ssi2l7YpakMJh7GJSIqhEIHZy7qqROLelAFS5p/cJNijaaB4EYkWUkrLnOrgtd81BnzaR5eyWJEy+ehC5dJocygooxGVD6qobWMY2qzrmf+aUIPjo+cJPMJBMd7oazBhP9BBwmLKD2TH7vmY64XRssa/3IQL5tD/jBq54qzp0qsa5PMWD9YIP1gL60cjEVpgB/LalNnuODDKpZoaGcWurp08PqbcAnb8kWcctjkPPEGbC4peSB3hRw5hySOzR9krVMWJ3kDIRY8lA7p47ZwqUatzCIRjXVdw+NvXh8Q0IoKlL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFW06+lQEv/5EB+xuksvV92uCzAIW0f9/mVF0hqBJoU=;
 b=AexWYwTq3YAuTb1LEdBpVTg/lRSbcI5X5kGvRlJuSpetO0g133ZXXea9lQBu+m5qH1E+PIuA8oehfPtkm3piX1XbZ1q4T6N9ELBjxuuDsWjylbRi1XfEe4nVDSnf1BEswNNfHQ4gWVbik08qsFH+WWkloBzluBw+PHrHiX38HNk=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:21:46 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:21:46 +0000
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
Subject: [PATCH v5 18/49] KVM: arm64: gic-v5: Add IRS IODEV support to MMIO
 handlers
Thread-Topic: [PATCH v5 18/49] KVM: arm64: gic-v5: Add IRS IODEV support to
 MMIO handlers
Thread-Index: AQHdJl7un1xSp7DdLUuPbZQC9rqMzA==
Date: Fri, 7 Aug 2026 11:21:45 +0000
Message-ID: <20260807111159.429128-19-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|AM2PEPF0001C715:EE_|DU0PR08MB7737:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a8cff7-728c-4060-2d2b-08def47624b7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 dtD0H82dQHMj3ExowFsfDRl9CuOzlko0AQBoLsYBh22WXdu/q3rnsnhlrfvu4DoBta8ijcnemWeZeEaNTToIyyzWseOD5qD/07+lOT6OQQJE1xS3azWfckKo6XSDFdVfUfRIpWm+iqQ5PiNh3LCheQUzaYNSkxIjx0985U+8S6tnSq17u/xMATf39cKDyFd6ZMdvxXYOR4zcm0ZE/6niSxuca/IEdVYsIaBa0+1RdVfKanpjIMJFPiApNisQaLBewiyjpcOpq3TxbUJnlu0MXg2LN8zqPp/5dIQ7buIXxdO/rJrNq8qwZ3NPL8gipAvohMq4zgBIly5cWsGMcAjc5323qlJ+N0Seo1S8CV5NNKR7K9/xGVCXYzCIZDdKlnVyoX77xpdSHkSRmPoKV2ZxSLgL81MCtQVUEaJyDloAax2KFe+oTheo11/SgB4tCO/F//NuLEUwS8EVtqtzp0t1CBV3U8m1uzZ2zPvW0YAwM0/Y2EAkApNUP8/Jru4L4S5QNYfCVNxIct4ZumaU16eUbqOBXnzfTB2vXEvw2DBYCzBk6aqgL3QdRdAItdWC4rxl4NXp4C2F1Igst0L7bFGrFHlRRJDHISI9+ej2wfGhCkmdJfdwSPi1fW1v99aE8o3JTkWZiqfTJ3d9fh6yFvkf7op+hPVY9Pf5cP6w5L6L15YNhj8ECudYJ5BtQX5+CiZz7iv2bRX7HJIqsuvcuNpaZVUrIrDm9/slPyeZ3Vbh4y0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 h6AZqLAsvRcjGW3Z2aaWSpEElzqhX+M8kiR+PHSmZbmP4msUSecyzTApM6e9+waaTdiF0WPSCby+bD1LMjLMUaNlTSymv1LxedGtjGaIx0E9cmDAJmYPFVscCARUAMAtFfbLDKjlzNKkP2oThqDeqfnA8D3raAI2xWn2ADEOllyU4JQ6DecWHkyxv1l6Ml9/kbP/EuLlWcFaenwipQY9/Sw2JL+E1KrsxHXQgYYyQZm8G4/4zlGjkiK+JQLQp95zsLvrNPn6foaXpcHfJxVO+z4BnPdn20pHi6OA3DUXOpykVaOJB9wPBaZhqaMQel1JqUtVXlEDyKQU0KMzG7pA2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ef1af587-11ce-48b2-6e1d-08def47610e8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|35042699022|14060799003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	A0njM+rKYPjDISNbLFkS+CPagwN8canqq2C3wFlvVqOl6bdTYlH6vjns07kk0uTa0sd4EjCfqGtkU+n5xRZkwcct7g03l8m7Tjuxw23KosP72dNKX7g/a2aezqMgvaOUieKCkb0LxmhdlhFEvTyh/9VXfuyos0hQwoBz2liRW2rleeb0ibs9f9QnE8lmnLzIZHmCriPxDpkxVHyQi4H3WCUB2D2orV61+oQsiBJbYLSsSLpPIzpXrZvYR2gYGd3lfoyNQ317CHh09ylcfheyZdXiCgysGSBcEGps0dAmqu6AHFknwBNfNNT1zwB8cf00nNj+xxZqBeZQkoYdXDFCPe4Q0I9EOhjP0DHzzqOvttrN5bvuU8x0V7JY+VV9W8YDJR2htn/vqwqlyUSRZtXNt9WUpY9sf4nLw+unuxBHfR/DH6AyrnOgfJKodtP9iywiTYs0REE6VzRdANZqZFAM9Ao1LZaEMZXocwzmgBpOVIiaVDQ9occ4SCiag+Uz50yMTfb7iY5WMSqz3McakUy1f1lP6h/BjqQyX9jqgkJA4W5gZ1ljTz09NVhTXcIXWKupr4oLQJvGgYXyW8ek1NdWbYQoyxgxm7Mp+UblZwsIBUkEy3AQw+rB3xOHhP6YVP7BjgHlBD2SAhPNcJJWn1tB1iS4LHi7nnei/vgOUvTaM0INCSWjevIQHhBS1paRGKqFwVrJ7B8WcMjYZfcDYVY1Ww==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(35042699022)(14060799003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l1PmeuqNXHZSwnCqMp68YIj4Sh2NX0VDj/dUcFubbgeYclb2hp2tqX2F8Klj9MhsqVLNuu5fDMv8XuVw3p+s1SVpjBZ8D0TWfKtK/cZniFAo4O0AMfsbWmBqkUbiWsm9paZQ8siMu0OCnwXI41OmWhRV4DJQkLfghr+T/m/sWq9pWQ90Dk7HiXDf4BFyf09gciahW4gS3hRbOhNnov/4mCter9GlfbSfo+rJX8FWEyD0sbnuGBWiP1hx0/aRYa5oUu0PiZPx+MYC8MqbngtDJ2+bymN1ViWkfjdEbB7f+atL/z3ExD2dFo/cKY/Q/PlhadxBXgKkMkxiM2FaLWWTSq/EgU4amDGeNq0r5wrSGYDx04yhMxWFy0ZvHWeboxvZfcP7o9aB0iK/C0LcHAHxYZrHzMVvhi8BUxCFHnxhcsx7+GbFnb263PvX9wQwNG3B
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:22:19.1548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a8cff7-728c-4060-2d2b-08def47624b7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7737

In order to support proper VMs (that support more than just PPIs) for
GICv5, it is important to emulate the GICv5 IRS too. The IRS includes
an MMIO interface which is used to interact with and configure the
IRS.

As part of providing the emulated IRS MMIO interface in KVM, extend
enum iodev_type to include a GICv5 IRS device, and extend the MMIO
code to handle reads and writes to that type of IO device. This will
allow the creation of a GICv5 IRS IO Device in KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 ++
 include/kvm/arm_vgic.h          | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index 74d76dec97304..fddb9da0403d5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1065,6 +1065,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, =
struct kvm_io_device *dev,
 	case IODEV_ITS:
 		data =3D region->its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
+	case IODEV_GICV5_IRS:
+		data =3D region->read(vcpu, addr, len);
+		break;
 	}
=20
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -1095,6 +1098,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu,=
 struct kvm_io_device *dev,
 	case IODEV_ITS:
 		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
+	case IODEV_GICV5_IRS:
+		region->write(vcpu, addr, len, data);
+		break;
 	}
=20
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmi=
o.h
index 50dc80220b0f3..38ed730d68ac3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -217,6 +217,8 @@ unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_de=
vice *dev);
=20
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
=20
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev);
+
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9c5e789978cc1..da15570b11292 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -310,7 +310,8 @@ enum iodev_type {
 	IODEV_CPUIF,
 	IODEV_DIST,
 	IODEV_REDIST,
-	IODEV_ITS
+	IODEV_ITS,
+	IODEV_GICV5_IRS
 };
=20
 struct vgic_io_device {
--=20
2.34.1
