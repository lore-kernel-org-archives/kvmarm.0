Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013049.outbound.protection.outlook.com [40.107.162.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDCF41DE15
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890396; cv=fail; b=irZ/Oh1V3lNAGEAzCG+e/mqJieN6bc/hvjLTkBI4DBHxq1wh9LiPm1DFCz1xrpi8WLX9mqfpVBzU9RR8cTdus6ijAzfsLZv+nm7puRPFRnsXsRgtUSOE9Be+EErxr8XEAXiVUuKBkRdvjj3c3xnQkT/vXXnNnGgshAyZiYBFHEk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890396; c=relaxed/simple;
	bh=n4+4DnsOmM6xs9mManpzJXfhwDQgKcwjms8IryGNzO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nO2hDLvJwUKIEWSZOn9Jz+NHt8rReJ2k9DKQNI0OMkEFk0PdZk/pB39qQiTLkyGOSHmt0Xd4Z3bUiJzwrSpnLCj6TZksMZnOIeMRVxft0N8f6VRQKFrMDK3fUY0xARxmj4GwwcIl5anSDCJs43HpE4gyb4ChjYmmsOIfdqHIYzw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ra2m4GWE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ra2m4GWE; arc=fail smtp.client-ip=40.107.162.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ra2m4GWE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ra2m4GWE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CVfJAcD+ISFbUqBfZ0eSgc5a/ANuSAYNAHeojboAsoIHFBiKkz4Y3xeY5RQSiP7gwORV6zvr/MHT4pd5AQv+SLe84xCjXnQQJCNDRtDBaC5AHc1Ts63+92xu4BPg0fIApwRdJv9vbarKRP7hZi8sBC2IhrXIIOqmlrNQ29DJ9isdMzUHsOhi+oEAWMkTUm2k2+8LV0NvxHe+8Tt/AQNFMpEOlIRJiiXZ/j7I3+esS5p+mDa5uKTNcWEL6S+it0aVZfcKjg7I9R8bQ8ibmpB+w4olaMO16+0sF8jjhBV11q/GFkG7tgPEce9bksD4KzoSpsohj0RWuzo9tjcttyVgxA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0oIVl++mUEaMvYnthnYTiPvFW0Dz+82oHZs4et8vYw=;
 b=BF57ThvzsFZsdGB03lwhFVArmKTnB8CcabOxSWLLz4rSi3EkxYxRcNOEjFZGS+HxckpPSp5BdNb2nB9/LuA7fG9FkzWJbaQJ2DoizWSFVIX4PHxX+iKntw7SulrgAKR2HmTed23L8IgHoQC/n3ZiodIVzDYSsZGq+1kZtBF2m6aQO+ks1C6Zis2uJkg8aY9k9XEfOIi+aFFDYVmbjwhOSeddpkWt6bW4C4f8zNTTffwPbtFZ2aqdiszIgqR6v6Y6UYLhkeVS7ye52mErTp0QXjSN+hXoBfn/CBSgonpXLeBs5pYffLncCmotP4+lJzUly9j+OSfSkY+eEGdNVJOtfA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0oIVl++mUEaMvYnthnYTiPvFW0Dz+82oHZs4et8vYw=;
 b=Ra2m4GWEREVSFCiHVPghdHg6eyQjNC5iL00tnZrnTd2BwGWXLWPCmQGdmPLNMwfhtVhj8H52Fe9BHAWATfEhk1twLxr7CN1JqBkbKkWAZsk7JZxwruTTvATjIboRbgdD/u+imfA1HuaxC+3F46A6/mluTqap0XmZQkdGE8vYvSw=
Received: from AM0PR02CA0190.eurprd02.prod.outlook.com (2603:10a6:20b:28e::27)
 by GVXPR08MB7848.eurprd08.prod.outlook.com (2603:10a6:150:16::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:53:05 +0000
Received: from AMS1EPF00000091.eurprd05.prod.outlook.com
 (2603:10a6:20b:28e:cafe::b) by AM0PR02CA0190.outlook.office365.com
 (2603:10a6:20b:28e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:53:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000091.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:53:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTNCkEjzQaNJwL2JM59OZtIapJEi7gndWWXGppwJmEdUHHVqw1gd/eUcEopCDziyouCh95jF0hFNjIKKcvnQ2z0YEgHRelyrrPrTuAJE7Q+GIDBgyhCbis+kCDKNQksBm1oHNZnhfL6DzeUntPlzgkZAbuXhMoMcNo7wvvRCKhwrP/cHdinZHTZLCIS/kZ6KN3yQPlqr4vLFCmkYag5ZjZ3fG/CE/ErlhJNAwHdC6i/EFlPwktMPJqe/u5poVS6duogeaA5s0/GnxjQ9EjGcfZ/DqhHWJaldlP/ASuX12DFlftqx9SOUAP4oqzLGcCfu1eWGNbNnCdBUjKNiS1Nh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0oIVl++mUEaMvYnthnYTiPvFW0Dz+82oHZs4et8vYw=;
 b=RVAuEn3Ee72JyQxT/F40iL7d03BmkZdeR056THC+x3KVTw0YJOKTC/6JNRLRwFxe72h0yavwJa7xpHFb1/kfUga09r/Evq/IC44s2WzkCH91X34IhxogCswSjzRsngERGKbvU0omEl0+G2jDNEShRoaA/FuuG/lLkUVvBgxFvM6L9tZhr6bko7CX5SqiK//Zisw3APunBHU4qzMsiAXp7KHtG6L4Mf3tUg+b4ufBpImAl3wzDvcuAIPBHKTDorE6NHbLJ8X70Zlfz7dyxMUfuNTTEAD20ZnpANlWWEWNqO1XyUvAbKMwBz7zMiPUmr8xq6XO8fdHGE+9zEMky+6ZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0oIVl++mUEaMvYnthnYTiPvFW0Dz+82oHZs4et8vYw=;
 b=Ra2m4GWEREVSFCiHVPghdHg6eyQjNC5iL00tnZrnTd2BwGWXLWPCmQGdmPLNMwfhtVhj8H52Fe9BHAWATfEhk1twLxr7CN1JqBkbKkWAZsk7JZxwruTTvATjIboRbgdD/u+imfA1HuaxC+3F46A6/mluTqap0XmZQkdGE8vYvSw=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:01 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:52:01 +0000
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
Subject: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
Thread-Topic: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdG1p0GiroGuGSGkuA65XJ2pMBfQ==
Date: Fri, 24 Jul 2026 10:52:00 +0000
Message-ID: <20260724104819.1296803-15-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|AMS1EPF00000091:EE_|GVXPR08MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc174e9-5b25-417e-18d8-08dee971bd1a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|5023799004|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 pAkPBFM85lL+80uPioKgk+5Hnxwc4DfYhKq6k5VEh98y68+c20VQHsdLm1Yf/NOEZyxnutct3x81bLCPfKOKCaBGlit2hQw7lDryQp+tQ256XYUJcUZz8hn/TjpENBxJA/+fM0A6wZEmth2U21bke1xOBS8KafWYNvY0/uWftG5pxFosrg2L/7Lq5Afs827qq0o/MaKcmq/W8lFEQvRjmRbpjGEFcjvvdoO5vgCrVrKJBwQG9PGsDPzPLHa7Qylxo3f8nyaj4onmx4y8alx+qnBdzAEmORo6FWCJNGkWt/BSImimpBW6fhHO/RWO0Cxddk6wsfJg3teT2oBMYoeIUS4mAldtNaXmGrOqgCclcQDGIv765bJXMaUw0IhDra67gZau3IWCaCDzBDfbY0Oj+az3XgY8ECrDhbl/f/Di2pmKl1cnq3ISlnAo/jbM7Pvx2MBlYNtZS3Bm1TIiUHvQkR8alwuKZyG5DwF/8AsX892OHnPrrrr/ZjGp8EKB1mexXxj7MNWHxYvSdvSTr9IotgFIBNB8igjp1o5FvhPJQEX3Yj6ALmkB3243aavm7SSrN0CAqRB3DSd2D1fZorf5VO4ntokIln1rF5LJwWhtvGrojrHmbdDXyvPBPr12ectj0aoSy7A6jpuTMMCcAc6gwRT4kzPCNl/fr1hta+V/Loy2qgvs7CiIzcmL+QTAI0JBkqyQXflvyWRihoY62a9Q3jWcbS7kMq9K78TmGHPTS0A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BfDAePkKT7BmcBGDP9GquQ5zGryS0zqfpToGRN7txBPMxbDeyDecx1axXJdKaYTykVlcJuGiT0L+bXh/8ApfNF6z3jM4aBpSYZp/A/5+R5CMzJKAC4TNdWpFheifWjMChGfsypNw710SBGAhyJwKqQoPhHJi6vFYhMet408iZLGN3ADW+BhRJjqsL7X7FlOFE90S0nltVWaGdcEG2r2g2yZrMxi5O5G2QIOurWC1Zmevqu32nW6T7w4TCMvDPIcgVtCUpIzcOksx5g6wVQHE+4Rx1nutivKpSw5nkHnlKfgCzd9lQwdBHoNfiCtUrgAUy8J7jsz+aaMEl+ssV+yHbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000091.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2b34cfc0-e3f1-4f2f-be74-08dee971972b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|35042699022|36860700016|376014|14060799003|6133799003|56012099006|11063799006|10067099003|5023799004|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	SMBDNdnnYYx/cby+EsdNpefU2N/BezlfY1+BSGN2LXrMM3Blz41v7ZRRDjPLic4/tTWbu6RrXuEHS3udI0haUEdelzJK2c/JyX/0SZrgbsVk2jlpVfWRmiN+SvjcC36psX5S36LNc4JKlA6Q3Gjkzw/4NU5cQkIEludTjX6p5Sw5DPl+KXYnJmqfV0qw8LhkzpRoc1vmlWIsknxHX2k5rdlLEJjBDM/r31drG1+czBZ7eAJp9X+5CbpqB6YHmpxc8rJDy7kmtmhMnM/YL+4lEsL41z8SjrOn/DpldEZwrMcjiQuxzwEFOm9juOu9lPz/hsTO/3kDwmWVI8AWlb9YGksi2p4a999wMyEGmnHmRC3E/MaM1UkqWJQCtN4TR874pCtan9X4f1hxYmGaf/gDQ11AY3ZlZwqZfWLmDt49444Tmwwni7UiqbJ4ifjV84b+aqEzO8Q/wi0/ID5ylIEOmEyni9CylyRxHfDmsiYtjpyX2uGiqvaNbgX3bMq1K6imsAE077CtmFHYggmVOzAr1ZQYjJWsk1rW5GSqWQF2IOq8yDe+Fs3Quja4Dq1zOBgbEKkSztl13Yqe39vpxn2W0rpS46do37iVWQbk0hHrqAh3cTmxqyqBHSjC4vtFI661UrHd2f4Mr0TQ22Nd/8a6IAXEKcBGhG4qWjbQnqw58jnNALEIqrQtB+XtqzjCSEdliwlxeyIQLThLHmDtHDnKpQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(35042699022)(36860700016)(376014)(14060799003)(6133799003)(56012099006)(11063799006)(10067099003)(5023799004)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mubxzr4S2TNETdvJMhD3KbWPUSAVWlchDCjvtHBkoP3g5jeZuQi/ZM15ehXuY96ieKHCx1NBc54JhbH32xXqjpM9gbbbTnwoKIR3URImdvfmcd/2FhwXjpJHrwwEeiXqADXvD4gd0waXLsvUHwGQZInQHJakwyucpK717ETESu5B54oHg0Jm5kuFvrYZY5mRZc4rApDjjxo3NJB68G/ZQXgC4XKR7R/TbNuJlN9Wlyhj/mM5VheBLGXZ/3dSmEPtbvWGZmeQ+sAcJcQYvR9o8sjwaCU4W8ECE5pDsBY+vYPcU7GQ5kQfvaePvsaf6qH6XnJqWooL/kCyevptWJEY9Bxp/uqcRmUe5Go2Ycf5jgTeMuDKJ7iPtfKo59w5VxE4vB8WZGcS10SRHyEOVD7gAQg+2H/JCsLzXZtPNzTDYCrGZ4E7sdSjLLTU2O21VzI6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:53:04.5381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc174e9-5b25-417e-18d8-08dee971bd1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000091.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7848

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts.

Allocate a VM ID during vgic_v5_init(). The VM ID is also the index
into the VM table, so allocating it selects the VMTE slot that will be
used for the lifetime of the VM.

Create a per-VM VPE doorbell irq domain, allocate one doorbell
interrupt per vcpu, request the interrupts, and keep the doorbell IRQ
number in the vcpu's GICv5 state. The doorbell handler itself marks
the VPE doorbell as fired, raises KVM_REQ_IRQ_PENDING, and kicks the
target vcpu so that KVM can re-evaluate pending interrupt state.

With the VM ID and doorbells in place, initialise the VMTE backing
state, including the VM descriptor and VPE table. The doorbells have
to exist before making the VMTE valid, as they provide the IRQ-side
conduit used by the IRS commands. Make the VMTE valid via the IRS,
then allocate the VPE state for each vcpu.

Add vgic_v5_teardown() to unwind the state in the reverse order. Make
the VMTE invalid, free the VPE state, release the VMTE backing state,
free the doorbell IRQs and irq domain, and finally release the VM ID
so that the VMTE slot can be reused by a later VM. If the hardware
invalidation or VMTE release fails, still free the software doorbells
and domain, but keep the VM ID allocated so that the VMTE slot is not
reused while hardware-visible state may remain.

On init failure, call the same teardown path so that partially created
state is unwound consistently.

As part of resetting VCPUs mark them as valid in the VM VPE
Table. This informs the IRS that a specific VPE may be made resident,
and without this the IRS will treat the VPE as invalid.

Also introduce a wrapper around the VPE doorbells -
vgic_v5_send_command(). This takes a struct kvm_vcpu pointer, and the
command to run, and triggers the function bound to the command via
that vcpu's doorbell. This is a convenience function to simplify the
code.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 170 ++++++++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 826c2284a1453..4a62aa7d6505a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -406,6 +406,23 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_cmd=
 cmd)
+{
+	return irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
@@ -582,33 +599,117 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
+		return;
+}
+
+static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int db;
+
+	for (i =3D 0; i < nr_dbs; i++) {
+		vcpu =3D kvm_get_vcpu(kvm, i);
+		db =3D vgic_v5_vpe_db(vcpu);
+		if (!db)
+			continue;
+
+		free_irq(db, vcpu);
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
+	}
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base,
+				     atomic_read(&kvm->online_vcpus));
+		vm->vpe_db_base =3D 0;
+	}
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	bool release_vm_id =3D true;
+	unsigned long i;
+	int rc;
+
+	/*
+	 * If the VM's ID isn't valid, then we either failed init very early or
+	 * we've been called a second time. Nothing to do here in either case.
+	 */
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc) {
+			kvm_err("could not make VMTE invalid\n");
+			release_vm_id =3D false;
+			goto out_free_doorbells;
+		}
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu)) {
+				kvm_err("Failed to free VPE\n");
+				release_vm_id =3D false;
+			}
+		}
+
+		if (vgic_v5_vmte_release(kvm)) {
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+			release_vm_id =3D false;
+		}
+	}
+
+out_free_doorbells:
+	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	/*
+	 * We only release the VM ID itself if we didn't fail earlier. It does
+	 * mean that we might lose the VM ID (and associated VMTE, etc), but
+	 * given that we've failed to tear them down correctly there's no way to
+	 * safely reuse them. The VM ID allocating IDA will make sure we don't
+	 * accidentally reuse this partially torn down state.
+	 */
+	if (release_vm_id)
+		vgic_v5_release_vm_id(kvm);
 }
=20
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
 int vgic_v5_init(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	int nr_vcpus, ret =3D 0;
+	unsigned int db_virq;
+	unsigned long i;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
-	ret =3D vgic_v5_create_per_vm_domain(kvm);
-	if (ret)
-		return ret;
-
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -617,7 +718,56 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		goto err;
+
+	db_virq =3D kvm->arch.vgic.gicv5_vm.vpe_db_base;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			goto err;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		goto err;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto err;
+
+	/* Loop over all VPEs, allocate/populate their data structures */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
+
+err:
+	/*
+	 * Explicitly tear everything down on failure. The teardown function is
+	 * written to handle any partial state we might have, so we don't need
+	 * to do any clean-up first. Teardown will be called a second time on VM
+	 * destruction, but that's fine - it is better to leave things in a
+	 * clean state now, and doubly so because userspace could actually go
+	 * and retry init.
+	 */
+	vgic_v5_teardown(kvm);
+
+	return ret;
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
--=20
2.34.1
