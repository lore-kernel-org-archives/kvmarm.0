Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012051.outbound.protection.outlook.com [52.101.66.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2F441DE1F
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890504; cv=fail; b=qNanWGgJ9Gi80sJWwdmY1vcNuTiGT0yWf3y6q278KYtFrc0dXrE++S/X4UUaHEjtIbqG7JTZKEHogzHa/sL82Pc4uJbutbLqVAP9fIGZzgK6ZQNnJpeSC+gS/pR2s6eI3WsjQ2YIi55WwYxNlhpzkGW0nED8MzN/eEjSQSPszdc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890504; c=relaxed/simple;
	bh=I2LI95vkdNsxX+cK/ILcmjeTJUje4VDSs8pTLNtjp/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P5jUUsvrz3hRBlIH6neykJNnA3T1e07dVW5XBg1BlvnuKwz2pSFVuOewW0IzW0nmeBodXxufRnuxZhXHe1LOks2VOuQp1DW9E/++1o33tcOcvAGfi3ZE6se8lSWRPOucxVhRyZQ7rbwKkew/yHxlqnV0i9ifliIYBB3LSe/FUgg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XnBUxK8c; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XnBUxK8c; arc=fail smtp.client-ip=52.101.66.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XnBUxK8c";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XnBUxK8c"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L8gv3fhsChu6T7Nix3gVe/X2PAZEoLQrZ0Sd37gE9/KTPo3sx0BuDsFocI7MGdYQbXhLuyUQouFqxty7a+fwmHPjSJOkE8vS+dnquhpvS9ucvBCMVYc/bCZUVhpEGLsluoo+aUTusrp1VbWnlaqjMTmti4OCxMvkXy+xsFR1bypJWXWHvXstgd+wZuscxP2/jXN97k3T/Kc6l/3V236BbMDnH8gdT5vXZLWJ4iJWcGWzgcFraos1sSosu7mnqVxeovDG29SDDGonzv0oIi10cpys3jhvQbgDBVeoXAnXL0JdlBewBNRGaL1QBDAKX3XEFrxX8WSzPp4wP8pgrN2fKg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prolnkIpZPQ6+rAOMr5Ydpa4sXgjlTcZ/ruJbfwzf1g=;
 b=J2R0zZxBz2EMfXqf20uD+STC44y9LSzH7GkXGRKJleanPUNlWU8+53A0cVlFhOnDYaCfkHkvmAWfR/ttb69UGXHvvg582A0+1yu70aAXohlYqCtwDFUFaEGr/SJ5IUCqWK1z79XrV0FXRirrYP+HaH8YH0sYiw6d0h4hSqCAXVqzn4EvlIm15bxO0YyjCkgeoJ2279elxwL/LjKBqnMe89pDV+Hts2hSq5OUqEc0LR3mSaJLpFLPL6TmLf5GvzgQ90SKKEcpxdFK6nmjn42SZWVM8ufgyB0e5KBdMX3WOyt5QvzPzhUzcgWCbrG4Ri33n4Ez5q0XqYzuxflL9yd6Ew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prolnkIpZPQ6+rAOMr5Ydpa4sXgjlTcZ/ruJbfwzf1g=;
 b=XnBUxK8cHd8aCRazAOnUxIx/vg0T3Y2UBIhsPurwj/F6O8wAZ46Vg0C/fvV9GXQcVQdbsZo0RCYlsvukt73CpKLTM7KttUWEc+0EfDj8V5SahTPYRvPSAnq50Wia0m3Edwa/+mSOa/BSiUMdPQkBtmw8dwLalA6C8WaUNEsQO+M=
Received: from AM9P250CA0002.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::7)
 by MRWPR08MB11236.eurprd08.prod.outlook.com (2603:10a6:501:74::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:54 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:20b:21c:cafe::3d) by AM9P250CA0002.outlook.office365.com
 (2603:10a6:20b:21c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:54:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:54:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGIspZVBp3NtUcP3P4lycIvfvNW1Od4McLQH2aTeiPjnXIxvAr1KKCAWCI1PM284YMkXTzloA+/mQ9gCzuHB0srn8RPOjR8BXCAtzQbHnSjg1gMNKe5mgXZo4RlaiyGmg6HG/AdPLOo0i6HLPK/FX0hx0OKDUiMiTBsbfU8RMam6XcZa4kqNrgKKc5da+WErf13ZXARSOnkQb8KbmDsQ+ulyV0XEq4UqlyUTvX8VfHX2FHFog3VgTjvFqxvq6ef09t7pamK+QGiapBbqW1qYLCf5YeOOd9/Gdp5UUD/ZGamOrLLJDxXzn5JUyP4BMkZIF/COf2plXT0JF8AS3M0AMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prolnkIpZPQ6+rAOMr5Ydpa4sXgjlTcZ/ruJbfwzf1g=;
 b=eOOch67RzbA6/YMIkuK9mx8KD4yRyGO0GZ+QZjW+25oinuMS3ftFxZyIui+ahXpuPnMyMCEOu6oLrqo6+WcEGUyG+hQuZSrruiFPOU/UqotI/VMPNFrgpidSCOQ01CmH6BCvqo5nWDfz/PSX8uFulAlMl9gAhUwoNNoJAcbgQA8ct3HMPJsVvLUIHkJb6xy4sQwotampHdlmSYnV1K+yjXWAx1QeOYBVhbhLbRm1sP0KrHB5JFEVJzxgW++ZneLvL3ujlq5icf5RdGnHaNoanEjqr9z36c/mLrmPnG0+deGh49aV2JJYoQp0GB0ML+lnF/pFHq/+oWhn2F9Ipke8Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prolnkIpZPQ6+rAOMr5Ydpa4sXgjlTcZ/ruJbfwzf1g=;
 b=XnBUxK8cHd8aCRazAOnUxIx/vg0T3Y2UBIhsPurwj/F6O8wAZ46Vg0C/fvV9GXQcVQdbsZo0RCYlsvukt73CpKLTM7KttUWEc+0EfDj8V5SahTPYRvPSAnq50Wia0m3Edwa/+mSOa/BSiUMdPQkBtmw8dwLalA6C8WaUNEsQO+M=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:53:49 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:53:49 +0000
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
Subject: [PATCH v4 21/48] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v4 21/48] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHdG1q14d82r7gsMUOas+jNLPHi0A==
Date: Fri, 24 Jul 2026 10:53:49 +0000
Message-ID: <20260724104819.1296803-22-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AMS1EPF00000047:EE_|MRWPR08MB11236:EE_
X-MS-Office365-Filtering-Correlation-Id: 78db7e65-a9a3-4dbc-7477-08dee971fe0a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 7G0tyvlk0GjdfmWprB7gJqkfcJZYoHPWFgbgsJGAL/+9h8fyyoHbRTqxJ+pMpwHwXr/FtwcNReEwpXw0yVU9NXw4z2i6BzzV8qY2G11N0Ep3c0KbI9OtStRGU5PIfyEjJkgr82CHXBmxMW3LHJpavq0ivqVIHvCGeBWeTASZffFUQSL+4yzgGcFiAqUgBN9JklfhAvvLoSGURQh62+bK9sFnHqyEMYynNnNiNC9oIrmpK5D7LqHpU9MhVe7s/BL2GBqwRI0TQsNdu8ofIvLkl1mZHJjmgLDB6vHRjrZEs+7kh9h4D8c1ycuqvALRs5te2SvExogy0PFQ3+os6UL6A2Ii8zrOcK+x8F5OppV8CtAusR0Ho4/Ts/jngCgouMMUhCL/KPxA/gwT4QJPSpmEYvXLzN81uBG64UrNrZXu6qkgzqnUa3XmxtIkrEv8LkVfXfZBHfaMTA9CIJBgXXuWo5yYrSRkaCSCM7TQQxHr5bJJRdz6a6pe/YX+AXqzmNyYHH+BLGuiKqTdLRM8dseWG2yeCubGE+MqlBVlQg0MGOzEupbopRD3HwZINhu7t9/dKWNgEYlS5DLWDyqDNVDUZD/XazJ+7iCJvMD++pjyo53/0lLjgb/dwKHXL5+kxVn7N+YXH3/83msHOoRoMzBnrmebUyXCZ/CEnQBayyUAlOxqjPL+YGfYLSlGy1NvEvqhXBJ8TFsaeuSCtZ0E/3pwNH5Ld5u/dsjbj/a2tpYekME=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 boXw2PJq58jnfoHN5/9QXw1w81D9PH9MvjN8Y8m/tPpTAc200LWexKMgRhiQ6MHr4daJNxPe/2OAvAYfq5sb32r3XRAH1z0HJUhgVI6Ewsi03kxzHoRtLQcRFGhwW8IdHyTYT19heUZW5Z2P9msbqkzdEKOdstDzc9sGbFbTzJG0oKp4e1/j3Rp5hn2LG38ocTU8x8upQgIJoL1iWdA7K/eSk4K9vdA8Lb0L3nJoLGKsJVyR7KIW76u+VU+3N6rd7izmO1Fh1liEgRlHzIB1sdOKnZ83dxcGCnxEFfH38p4QsEVFHksLh/xFlLZI5XP1znGp1hg8GfFwblNZPr1tTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a6c895d8-a057-4056-c458-08dee971d7ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|35042699022|14060799003|23010399003|376014|82310400026|10067099003|56012099006|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r3z9hDutoLY+1jm0UcI6oZZB0paawp1UXicgAWTqkvSWJL8roslXeg94OQCoC8TPJxpq/5hLk2Fvvy19E1BeTxRhp/TfmcldRMuvYyNa1Am8JFMEv1lQUb0RL7dOFWTn0EPBY/EwX1dKc+zLp4VsVVSULd43gomJIqTuLTVHhKkANKc+4Nyzo+jb4h9bGDU5Egr3MBQuD1kkqspG/VjJyQxgndq+Dsm2AfaaqVSTtlR49oiIMUfdas8osmD5SkC7gRY9jL4A3bIGNXJLgnrtarp93TFEqGVDaxS/hGP9wf4nf3kqgzlaCgjJM04uZeIjuA5wlZyWKjObDwfzKibsLM9pXZK1pJe5XL6YBRwTcFCL3iK65HMXl8jmfDa8UbeLSMnjz5BV1IUhTpQpmwHMrwbHuFXq3KAcKbm/5+4DSnaUGkdKAnjs1ntVDDn0VgVhpR2cg/qMooTo9YGbr2kpNjdNNnpE1C1uQaTxf3sFGL2AJ2IW3NpGJKll8VGcCf1dUYMw1eK8pcrhDkk9L71CxILLEH6g+6S7cQthsAYGNQEmCgw25a7RT0xHR0n2SUwc91RAS+9X/G0pmILBftlk8IfQbY1QJtk6anhcd/KYhhQrk1TKoSLKIlOTeEEIg37EY1zJ/1ly2fpV6pXRCx71mmNLEDr0lUj2wVHb+JlJtvO+PB3aUpqF0k//M1YOSb5vuwGo/7KwsgRVnowA6DLQSw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(35042699022)(14060799003)(23010399003)(376014)(82310400026)(10067099003)(56012099006)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Rh2Qvk3Ns9sQ5adNXelrjE+50/dkFlKuACZkYQIx8+jSXYp7VoXy3p4ac1EcUtW6ZwNK02u6S58eH3Ro7AuTkInkRxz0VGosiWZN4AL93soegwZITpMzrT18LpTfvx6pzeF2QJ7hbmEi+2Ztgx5d420am9BjD5wKdoEDEsJqiK4YFz58e/aQunjGuf0IiFMaHmcngtqAgpWW+yP3pBt0HpIVX7LXm+Ky1r0Xc2ojqKtD5aMrrIFWLITj10nv3WfL8lRHBFtiRHdcf6JlrLl0/pek4YrWdVaai1vp6YVyB4MushQtc06+8HxX1SvX3hs79X9YCeFq/URwddCjeiUrH87g7x3qidXkARlGeyKZo0wBJcAIIjSzn+2xStROt4TgRSh50TTjPzvj1mxLJBNcQXCmxz520flo1bWy6RXEQPyv7YArUTIFd41d7v4wmuNH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:54:53.4859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78db7e65-a9a3-4dbc-7477-08dee971fe0a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11236

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. Without this, KVM can only
provide the CPU-local PPI state and cannot expose the IRS-backed SPI
and LPI configuration expected by a GICv5 guest.

Allocate the per-VM emulated IRS state when creating a virtual GICv5,
and initialise it from vgic_v5_init(). If userspace has not provided a
number of SPIs, use the GICv5 default of 32. The IRS init path
allocates the SPI state, initialises the virtual IRS register state,
and creates the backing SPI IST when SPIs are present.

Keep the per-VM IRS object alive for the lifetime of the virtual GICv5.
vgic_v5_teardown() only unwinds resources allocated by vgic_v5_init(), so
failed initialisation can be retried, while kvm_vgic_dist_destroy() frees
the IRS object during final VGIC destruction.

This gives virtual GICv5s the IRS backing required for SPIs and LPIs,
rather than being limited to PPIs, only. Further patches add support for
SPI injection and lifecycle tracking.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 59 +++++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c   |  8 ++++-
 2 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 94632fd90b728..aa883507d00d1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -174,28 +174,48 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			break;
 	}
=20
-	if (ret) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
-			kfree(vgic_cpu->private_irqs);
-			vgic_cpu->private_irqs =3D NULL;
-		}
-
-		kvm->arch.vgic.vgic_model =3D 0;
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_private_irqs;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			ret =3D -ENOMEM;
+			goto out_free_private_irqs;
+		}
+
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
+
+	goto out_unlock;
+
+out_free_private_irqs:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+
+		kfree(vgic_cpu->private_irqs);
+		vgic_cpu->private_irqs =3D NULL;
+	}
+
+	kvm->arch.vgic.vgic_model =3D 0;
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -467,6 +487,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
@@ -512,6 +535,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		vgic_v5_teardown(kvm);
+		kfree(dist->vgic_v5_irs_data);
+		dist->vgic_v5_irs_data =3D NULL;
 		break;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 8ef53cac32414..4042d468431b1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -684,7 +684,8 @@ void vgic_v5_teardown(struct kvm *kvm)
=20
 /*
  * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
- * doorbells, allocate VPET and populate for each VPE.
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
  *
  * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
  * our conduit for communication with the IRS, which means we need to have=
 those
@@ -754,6 +755,11 @@ int vgic_v5_init(struct kvm *kvm)
 			goto err;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+	if (ret)
+		goto err;
+
 	return 0;
=20
 err:
--=20
2.34.1
