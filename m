Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013058.outbound.protection.outlook.com [52.101.83.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFBB3D47BD
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936094; cv=fail; b=F3KKCNnUAnf0j+G2Lyhw6lrqx1C2/4hnWnG88aRX2gFk20pQ3QEHZHW38sDDGMhX/1oIhDeSHCwu6w/9P0D+bcw+dQIfbE8RfDoN69j7vyMjcK10WSFvGYKb1mY62IEIJObbhgzNY76URCXbuJmi/GZM5mqI8omaYhgMQ/HY7O4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936094; c=relaxed/simple;
	bh=mvLFyD8kY1v6nw4PbRIGbBYYYHzM20xTJz+J44CJa34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=osJgfqj18zKAMfTS3hoZMXHRQvKArQpKSM0OmKuClbUIYn9GqPrVfU66IS4cNtWV1749cyOAJ2SF3UkmPmVdp6GbB1Bt4sPaVPmPRCPH1Vb7r5gggZoS6rdnLVi/9qRT/fodPGCi55ghLGfNofUQwPcAU6+nLIEEBQd+X1FGAbk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p9ja+hyj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p9ja+hyj; arc=fail smtp.client-ip=52.101.83.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p9ja+hyj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p9ja+hyj"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oG2psftxRLJVljxqKSF431h89uTJa+INV/dv961pX6sWl3OWzqGBqV+BaQwiw4TskB1LCDbv4Ifr48b1gUs5SIvoSKKG4gkfsuMfS1WfqagiaBdKyMVoouEeWkPqWqQEFIOqecYebDpDkpGaH56SrWVa3WBFGBJpP3iPermCsze8n4DTdQaHEKFvrZD8DF7uqY3HlOcDzALDp7M1uxl68ls6ZRqQnt7CCKQL54qPJuxKqvTPfiwFcXa8nidC8UdoSgqTHgtmuiiIEimy/vaXjKBzbytaQlap8AoEt5am/aEEDrPNY6v2x2XBzoq4utIZohwMFlr23YIoSWS1WeUjBA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=uYtoWGQXPhNjfiI5GVeeWqQ8biBKF9G2qoQLe0Dwp8XIwHfzAZZtJfqfSQSGDiCloD/HKqNDZFTLheqH1CarpswRTmTrRY0FDDZOzWXDrduuSi6Ey/cMc2M1z4ZldXxMZp2ajGOc7+6Y0FyR9M53hmoMont4p7f2XXWpXGCEzjo2h93RMrhjdq33LWrwcce5fe0P2vgrrTOt5/rb/gRB1uMdHNm/yVK7Xg7+56e9asA+xYRC9vNhkcCW804h6cE34yY+HdtPUEi+Zx/bXG10mWNpKO6NE5mCh3q4TxxgxUcmiuyXcqnkFvTiXzpz8uaZhiib5Roq8FINdk/IyqdbSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=p9ja+hyjsUcAIe+NQBL4v7C4oyS1/9nhURrFZA+MHr1U1S/yjAcpM0HIxeTUJyCxl1bNUS54L1M6UkKyekB7KmtfdsjChvQL7F36SZNVJ0aNYVUxqFTEp0r3puI1khNz0lDblfOrn2sDWiEXQbPcoyfOz7PXD6w19dZNZd7jQMo=
Received: from AS4PR09CA0018.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::6)
 by VI0PR08MB11667.eurprd08.prod.outlook.com (2603:10a6:800:30b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:01:24 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::66) by AS4PR09CA0018.outlook.office365.com
 (2603:10a6:20b:5d4::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 16:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 16:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCMGU9TYlnLIiIc0FuJVOOpYeN1cUp0goTYDge6+lJrwLBb/PkkVCxw63bTxSNt75/i7fBmJG/KeDMHOvXihaQxHDqfC5yGftqNlMHMw9i3IEB2EOybzSKnBRqgykL2oHnEI5z5VnLPoEztrVk7hHr+04ZGpskvEjM282vGaMFAH9jO6Sm63+cMYrG5iegJVzoI9tx8I6T/kQQXjDs/lOwTvlPdsgIeKCTlfHjfs+sG+MXXyL2VLY6b2/RPMfQX2/cKb764MLo5AV+2Xbp6j0lALvFNej9ksPP+ub7vlrb1ko0e/OpmoNxoCBjummqYAOiqTvSP2g5nag+OtZxxIKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=QQyVT5V22jZ+MRDl/HJuwbwq6YZXp6M9jTCjyvl36mAJ/1c6rGas2rEAAJUNP9dhXKNW598El/Ud0JlCigfG9nQMtgiC31rtg2Yr7JIQT3Oj1BeVsPyJe/zbiTqas0CztwP4EQgPObxJwwFuxn1MuHQuK4BeW3sS4H0NWXpjRCoW3IL8nM5QvyqTDGggmG12wb+7dNiYI2Bv8H69fNcNS8Rmib2fljpRtykFnIQA4u+pVH2efEQKmLz0QTN4I1Zp2JEmrTd4f0UxMn2fDxEIJDI+0r3GbPkTLX9JFs5LF4Uylf4O3BeQ35/hh+Gi3W7nstC4ut3A/LKaH7cvfauB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=p9ja+hyjsUcAIe+NQBL4v7C4oyS1/9nhURrFZA+MHr1U1S/yjAcpM0HIxeTUJyCxl1bNUS54L1M6UkKyekB7KmtfdsjChvQL7F36SZNVJ0aNYVUxqFTEp0r3puI1khNz0lDblfOrn2sDWiEXQbPcoyfOz7PXD6w19dZNZd7jQMo=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 16:00:22 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 16:00:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 41/41] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Topic: [PATCH v7 41/41] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Index: AQHct7l9h33OmUi94U+7YLkly/GF1Q==
Date: Thu, 19 Mar 2026 16:00:21 +0000
Message-ID: <20260319154937.3619520-42-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|AM3PEPF0000A794:EE_|VI0PR08MB11667:EE_
X-MS-Office365-Filtering-Correlation-Id: 43c77f40-b395-4f1e-43bd-08de85d0c57d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 vknDKutFUhOOLOsGKqq+ToWpS3V50rgvhzHAe7ehBAwIJb5pNRe/mZTo3fZ9fT6K2RPU9C6GNzc16dCYWGs4QgCDAY7WiFknqY8ci/MJs5HJIzS/CecPFS7RoovaIhOWd3MZ5vSJC+TihO/Us+dBUQWR5/tOG7DYOu06qivJmYYzf0KF78sg/p6PHuzro3lgsAOvIfIJdo5RKDjIfya1ZwbKaCjGPZvYHSTYGchIysMcfA8+21eoZs6K9Hn6vdYynIR3G0KN4JIevN7JBA5j/eF3Lc8Nlr0FxAbAN8526lo5p3J85QVum+YIALuCQ+z/xHr1eukbTmuiB0aC61WJJLnpEDWzqeYwG1MBtZlHKGgZMA5Qh7fKhX3lJDifFVIVMQLN+MTU9suCgJ3dm8fgXWihmKQpGYSv2QOoOIIQqWa//4jttTMWPh3Yrc3jvdJY1Wh26nfwuiS/TIhO7Vm55nbLCB6moTIptK+653Xy1a8kqaW4VR+0kIpkXur1A6y6Tye4u/B8GVCUmDDBYaXMKSi+V9/BNmJUGmR8PCoixdtj5fWeDcmBGS09gRKP3AtABrWO517Wi26gIZPMOmFXHo31je7pTOCcGd2VwPq6GhKJ7qCSb9D1XvPnrQYe0g7tU25W6rHs8DBwXJHmROxJYxYH+gukSKdyW+efuTYqS/6WNwRJZJExXfgGwfh7qlXZ4l18GidRq1HAt/4Kmdlm9VWT8lH9mnE2WIkwUOnEQtJbvsnlyJPt78dyHpPBlcxYIGjxbWxQhna8+ZgUOGIsRbI+gv/2x3cuHhvz5hHwNaI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NRWR1ojNTDKUzxNdW+hdWCH2kjNZt4061ksv/yk3uDnktwcPuE8DNbhQ6680sDUQlBxABvh+E+lcHmFn6/LDNuPSLCWPf/zCHIKddhCqsZ+AQRjBEyjoNpwYLRf+BpjYW2idMi+aN96lLwMyZSbXIgFIpr0/+hhaiWKJ9V8RM1U6z5Zr2JQ8TQ2iDckU9GtmLirX1Idb8Prea89C6ph7dMFF+qryoRvyer3AeZM04KT/WvzcYTl3Vn2sW94OjXPLgHqLOOzY9ihf9YBz5EnFDhrIfhj7x9lyIeIQuwDeDxAZk4uBgva0zEr9r2LHSXFOBhLDgiix20ldC7LwfCozGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1d317a6d-1045-4c1d-3901-08de85d0a029
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|14060799003|35042699022|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ORaZmAOVFBWKgPIXk8sIZQWtOFMop6HxB4aXOjNmSW5CZg0bN4TnADuV8/45eD75dY3HhtnbBKeLuwCtZFhOp79H9DTqXadyfJv7rZagJxpxCmntLYPwl9aUybKkO3o1l1ugcP64iHT2OHy7upfXnAJsPA1YkFN5KgVG243EgQQkWLief9jkhWR/zWa8MrMy3naPb9bKBGzl4AUZI0l+Y8vrXCgYiVsTqV2md44r6m+d1lGSOGBKnVKiturG9i2tkNcg/9Qb/fgFOBioSwzKKaCTqwUowqQMpoRqZq9IhDx+1cF6eRBVJHd/7paCBQztTr0fJM7YnnINK8xycsVOd63pSzBe5QkIlmlXoEE3gVYtqztkOQtC7y8j/2xA8PffnLEDsoFoPJS4dwfMzx9qv5Yj7gokDqNAgv1dxYQ7L21jI9L3x/W1ljap+vRNX3Ql00Ynto0DPt9y1EeoD4IleVhqdhMXQ0qH2BAf5sW2OQheF5Nud3OdjuS/x16+kYbt0Ss4CdJFFHPhAjmNU12MpArjahFdDLTnLfaMjMcSeD1M/M2fIbt+tDXu0MOfmmsJkwHpeOK/jKPaHnII5ndqHvtibxjMf6AXw+nz7NxYgjk2Il6y08GkvZPSF77s0tFBNQajugzDSetFezed8PVi6N8TBkIodhMQ2rLqFx3lRc/5nk2WQRIcV88lVvshIuYsdQwViq8ekqPeEdZNZgnF4MohSzqm6fPRdMH0BUMzOkQ9qYBbRzDqlTZ20bCYSXW20HrA4dxM2bCpidnoNwYpjA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(14060799003)(35042699022)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kBFPUAfx21KtyoAD2KvyrpdYGTkrqK/MMBtBt2g4++SPZ6AHwrVZ2Rq2iGcXZ4U4HPsPI4z0S8o6xLH01UQuRs5MxNgnuih+yLBQjjunqBNPjkSTPjlWdjqa+uQo5peEw9Ti9qk+kVh9QDKsqhZhQLD7mO9WENR0zfJmoBO+nf2eFEUaA/iX+2VCyYEv929EDDMLgTD94fwu/4MRDRMTkKrkalRs8Cvm7k7JJjqd22ZAHgSaaIBqH4uPJDPWY3te8s8YkVBhfka0QSVAc9TFs4G5BX/ezWAcHubDW5dICJqQ9UldJErCkXCEXNAQDdYK24jtMlUnHB6DKCUb0VEXxZ2jZdvzUulsYO88BUPq83af0fZwd3oYm6831+GahexnagefT95fK+Hs5XMS1jVhnKHRL0i2cHgpBKnP3FpCDwYiDlYQCQN0WURDzwv5VuaZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:01:24.5095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c77f40-b395-4f1e-43bd-08de85d0c57d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11667

Now that GICv5 is supported, it is important to check that all of the
GICv5 register state is hidden from a guest that doesn't create a
vGICv5.

Rename the no-vgic-v3 selftest to no-vgic, and extend it to check
GICv5 system registers too.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 -----------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 ++++++++++++++++++
 3 files changed, 298 insertions(+), 178 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index 98282acd90407..98da9fa4b8b70 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -179,7 +179,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
-TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 +=3D access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing=
/selftests/kvm/arm64/no-vgic-v3.c
deleted file mode 100644
index 152c34776981a..0000000000000
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ /dev/null
@@ -1,177 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-// Check that, on a GICv3 system, not configuring GICv3 correctly
-// results in all of the sysregs generating an UNDEF exception.
-
-#include <test_util.h>
-#include <kvm_util.h>
-#include <processor.h>
-
-static volatile bool handled;
-
-#define __check_sr_read(r)					\
-	({							\
-		uint64_t val;					\
-								\
-		handled =3D false;				\
-		dsb(sy);					\
-		val =3D read_sysreg_s(SYS_ ## r);			\
-		val;						\
-	})
-
-#define __check_sr_write(r)					\
-	do {							\
-		handled =3D false;				\
-		dsb(sy);					\
-		write_sysreg_s(0, SYS_ ## r);			\
-		isb();						\
-	} while(0)
-
-/* Fatal checks */
-#define check_sr_read(r)					\
-	do {							\
-		__check_sr_read(r);				\
-		__GUEST_ASSERT(handled, #r " no read trap");	\
-	} while(0)
-
-#define check_sr_write(r)					\
-	do {							\
-		__check_sr_write(r);				\
-		__GUEST_ASSERT(handled, #r " no write trap");	\
-	} while(0)
-
-#define check_sr_rw(r)				\
-	do {					\
-		check_sr_read(r);		\
-		check_sr_write(r);		\
-	} while(0)
-
-static void guest_code(void)
-{
-	uint64_t val;
-
-	/*
-	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
-	 * hidden the feature at runtime without any other userspace action.
-	 */
-	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
-				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
-		       "GICv3 wrongly advertised");
-
-	/*
-	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
-	 * Note that we happily access all the APxRn registers without
-	 * checking their existance, as all we want to see is a failure.
-	 */
-	check_sr_rw(ICC_PMR_EL1);
-	check_sr_read(ICC_IAR0_EL1);
-	check_sr_write(ICC_EOIR0_EL1);
-	check_sr_rw(ICC_HPPIR0_EL1);
-	check_sr_rw(ICC_BPR0_EL1);
-	check_sr_rw(ICC_AP0R0_EL1);
-	check_sr_rw(ICC_AP0R1_EL1);
-	check_sr_rw(ICC_AP0R2_EL1);
-	check_sr_rw(ICC_AP0R3_EL1);
-	check_sr_rw(ICC_AP1R0_EL1);
-	check_sr_rw(ICC_AP1R1_EL1);
-	check_sr_rw(ICC_AP1R2_EL1);
-	check_sr_rw(ICC_AP1R3_EL1);
-	check_sr_write(ICC_DIR_EL1);
-	check_sr_read(ICC_RPR_EL1);
-	check_sr_write(ICC_SGI1R_EL1);
-	check_sr_write(ICC_ASGI1R_EL1);
-	check_sr_write(ICC_SGI0R_EL1);
-	check_sr_read(ICC_IAR1_EL1);
-	check_sr_write(ICC_EOIR1_EL1);
-	check_sr_rw(ICC_HPPIR1_EL1);
-	check_sr_rw(ICC_BPR1_EL1);
-	check_sr_rw(ICC_CTLR_EL1);
-	check_sr_rw(ICC_IGRPEN0_EL1);
-	check_sr_rw(ICC_IGRPEN1_EL1);
-
-	/*
-	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
-	 * be RAO/WI. Engage in non-fatal accesses, starting with a
-	 * write of 0 to try and disable SRE, and let's see if it
-	 * sticks.
-	 */
-	__check_sr_write(ICC_SRE_EL1);
-	if (!handled)
-		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
-
-	val =3D __check_sr_read(ICC_SRE_EL1);
-	if (!handled) {
-		__GUEST_ASSERT((val & BIT(0)),
-			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
-		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
-	}
-
-	GUEST_DONE();
-}
-
-static void guest_undef_handler(struct ex_regs *regs)
-{
-	/* Success, we've gracefully exploded! */
-	handled =3D true;
-	regs->pc +=3D 4;
-}
-
-static void test_run_vcpu(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	do {
-		vcpu_run(vcpu);
-
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT(uc);
-			break;
-		case UCALL_PRINTF:
-			printf("%s", uc.buffer);
-			break;
-		case UCALL_DONE:
-			break;
-		default:
-			TEST_FAIL("Unknown ucall %lu", uc.cmd);
-		}
-	} while (uc.cmd !=3D UCALL_DONE);
-}
-
-static void test_guest_no_gicv3(void)
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-
-	/* Create a VM without a GICv3 */
-	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vcpu);
-
-	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
-
-	test_run_vcpu(vcpu);
-
-	kvm_vm_free(vm);
-}
-
-int main(int argc, char *argv[])
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-	uint64_t pfr0;
-
-	test_disable_default_vgic();
-
-	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
-	pfr0 =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
-	__TEST_REQUIRE(FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr0),
-		       "GICv3 not supported.");
-	kvm_vm_free(vm);
-
-	test_guest_no_gicv3();
-
-	return 0;
-}
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/se=
lftests/kvm/arm64/no-vgic.c
new file mode 100644
index 0000000000000..b14686ef17d12
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Check that, on a GICv3-capable system (GICv3 native, or GICv5 with
+// FEAT_GCIE_LEGACY), not configuring GICv3 correctly results in all
+// of the sysregs generating an UNDEF exception. Do the same for GICv5
+// on a GICv5 host.
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#include <arm64/gic_v5.h>
+
+static volatile bool handled;
+
+#define __check_sr_read(r)					\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(SYS_ ## r);			\
+		val;						\
+	})
+
+#define __check_sr_write(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, SYS_ ## r);			\
+		isb();						\
+	} while (0)
+
+#define __check_gicv5_gicr_op(r)				\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(GICV5_OP_GICR_ ## r);	\
+		val;						\
+	})
+
+#define __check_gicv5_gic_op(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, GICV5_OP_GIC_ ## r);		\
+		isb();						\
+	} while (0)
+
+/* Fatal checks */
+#define check_sr_read(r)					\
+	do {							\
+		__check_sr_read(r);				\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_sr_write(r)					\
+	do {							\
+		__check_sr_write(r);				\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+#define check_sr_rw(r)				\
+	do {					\
+		check_sr_read(r);		\
+		check_sr_write(r);		\
+	} while (0)
+
+#define check_gicv5_gicr_op(r)					\
+	do {							\
+		__check_gicv5_gicr_op(r);			\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_gicv5_gic_op(r)					\
+	do {							\
+		__check_gicv5_gic_op(r);			\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+static void guest_code_gicv3(void)
+{
+	uint64_t val;
+
+	/*
+	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
+				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
+		       "GICv3 wrongly advertised");
+
+	/*
+	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
+	 * Note that we happily access all the APxRn registers without
+	 * checking their existence, as all we want to see is a failure.
+	 */
+	check_sr_rw(ICC_PMR_EL1);
+	check_sr_read(ICC_IAR0_EL1);
+	check_sr_write(ICC_EOIR0_EL1);
+	check_sr_rw(ICC_HPPIR0_EL1);
+	check_sr_rw(ICC_BPR0_EL1);
+	check_sr_rw(ICC_AP0R0_EL1);
+	check_sr_rw(ICC_AP0R1_EL1);
+	check_sr_rw(ICC_AP0R2_EL1);
+	check_sr_rw(ICC_AP0R3_EL1);
+	check_sr_rw(ICC_AP1R0_EL1);
+	check_sr_rw(ICC_AP1R1_EL1);
+	check_sr_rw(ICC_AP1R2_EL1);
+	check_sr_rw(ICC_AP1R3_EL1);
+	check_sr_write(ICC_DIR_EL1);
+	check_sr_read(ICC_RPR_EL1);
+	check_sr_write(ICC_SGI1R_EL1);
+	check_sr_write(ICC_ASGI1R_EL1);
+	check_sr_write(ICC_SGI0R_EL1);
+	check_sr_read(ICC_IAR1_EL1);
+	check_sr_write(ICC_EOIR1_EL1);
+	check_sr_rw(ICC_HPPIR1_EL1);
+	check_sr_rw(ICC_BPR1_EL1);
+	check_sr_rw(ICC_CTLR_EL1);
+	check_sr_rw(ICC_IGRPEN0_EL1);
+	check_sr_rw(ICC_IGRPEN1_EL1);
+
+	/*
+	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
+	 * be RAO/WI. Engage in non-fatal accesses, starting with a
+	 * write of 0 to try and disable SRE, and let's see if it
+	 * sticks.
+	 */
+	__check_sr_write(ICC_SRE_EL1);
+	if (!handled)
+		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
+
+	val =3D __check_sr_read(ICC_SRE_EL1);
+	if (!handled) {
+		__GUEST_ASSERT((val & BIT(0)),
+			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
+		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_code_gicv5(void)
+{
+	/*
+	 * Check that we advertise that ID_AA64PFR2_EL1.GCIE =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR2_EL1_GCIE,
+				 read_sysreg_s(SYS_ID_AA64PFR2_EL1)) =3D=3D 0,
+		       "GICv5 wrongly advertised");
+
+	/*
+	 * Try all GICv5 instructions, and fail if we don't get an UNDEF.
+	 */
+	check_gicv5_gic_op(CDAFF);
+	check_gicv5_gic_op(CDDI);
+	check_gicv5_gic_op(CDDIS);
+	check_gicv5_gic_op(CDEOI);
+	check_gicv5_gic_op(CDHM);
+	check_gicv5_gic_op(CDPEND);
+	check_gicv5_gic_op(CDPRI);
+	check_gicv5_gic_op(CDRCFG);
+	check_gicv5_gicr_op(CDIA);
+	check_gicv5_gicr_op(CDNMIA);
+
+	/* Check General System Register acccesses */
+	check_sr_rw(ICC_APR_EL1);
+	check_sr_rw(ICC_CR0_EL1);
+	check_sr_read(ICC_HPPIR_EL1);
+	check_sr_read(ICC_IAFFIDR_EL1);
+	check_sr_rw(ICC_ICSR_EL1);
+	check_sr_read(ICC_IDR0_EL1);
+	check_sr_rw(ICC_PCR_EL1);
+
+	/* Check PPI System Register accessess */
+	check_sr_rw(ICC_PPI_CACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_CACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_CPENDR0_EL1);
+	check_sr_rw(ICC_PPI_CPENDR1_EL1);
+	check_sr_rw(ICC_PPI_SPENDR0_EL1);
+	check_sr_rw(ICC_PPI_SPENDR1_EL1);
+	check_sr_rw(ICC_PPI_ENABLER0_EL1);
+	check_sr_rw(ICC_PPI_ENABLER1_EL1);
+	check_sr_read(ICC_PPI_HMR0_EL1);
+	check_sr_read(ICC_PPI_HMR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR0_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR2_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR3_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR4_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR5_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR6_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR7_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR8_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR9_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR10_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR11_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR12_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR13_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR14_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR15_EL1);
+
+	GUEST_DONE();
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	/* Success, we've gracefully exploded! */
+	handled =3D true;
+	regs->pc +=3D 4;
+}
+
+static void test_run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	} while (uc.cmd !=3D UCALL_DONE);
+}
+
+static void test_guest_no_vgic(void *guest_code)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create a VM without a GIC */
+	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
+
+	test_run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool has_v3, has_v5;
+	uint64_t pfr;
+
+	test_disable_default_vgic();
+
+	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
+	has_v3 =3D !!FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR2_EL1));
+	has_v5 =3D !!FIELD_GET(ID_AA64PFR2_EL1_GCIE, pfr);
+
+	kvm_vm_free(vm);
+
+	__TEST_REQUIRE(has_v3 || has_v5,
+		       "Neither GICv3 nor GICv5 supported.");
+
+	if (has_v3) {
+		pr_info("Testing no-vgic-v3\n");
+		test_guest_no_vgic(guest_code_gicv3);
+	} else {
+		pr_info("No GICv3 support: skipping no-vgic-v3 test\n");
+	}
+
+	if (has_v5) {
+		pr_info("Testing no-vgic-v5\n");
+		test_guest_no_vgic(guest_code_gicv5);
+	} else {
+		pr_info("No GICv5 support: skipping no-vgic-v5 test\n");
+	}
+
+	return 0;
+}
--=20
2.34.1
