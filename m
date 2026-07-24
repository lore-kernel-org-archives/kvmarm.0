Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011012.outbound.protection.outlook.com [52.101.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF03B42C1
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890608; cv=fail; b=cuxbqJ9znhNuehUQX7UZsrD2fgoR99NCPDZqeqfjv+zylXCz7xhqSm6kbW2tjlqFVuHYIC7fSWCDflaUYqILOR2sWldf491nA8o8iR2gQfNOUAJLQ0FgTjqebS1sgoKFpLlPBgKkl7niYdKpt7x1RtDYbbqoH1Ql9jLWBOn3ms8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890608; c=relaxed/simple;
	bh=6Miz/wBxPoYxxk15SnFJHjlMMVrgAdCyRDMPCQjOuYU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nClOl19KhHtD47PcB3XvtqAR/7TwvwZsQYNYdr59t1Mrdk8s/2fMtj5yf4F27xb4w5RT8lxXcZaMKl4mKSRjXmNWPQHY6Yg3ekZ7Z93H1Zcy09PjsTjJ/nPAC6cgctRi61qcThmGitb/ob6m3tpgAJ6e4d0gL6FkpXNhi5TOQzc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LTWwVUUH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LTWwVUUH; arc=fail smtp.client-ip=52.101.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LTWwVUUH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LTWwVUUH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gSzW/mDSsf52IB063oeiBb0M+Hb4wSzZ7OIUHld9DnPeTaJJ2OZ8DAiK0HFAntVvw1vDiNjhSXqX9GdoKqtYVh6ylvSMcop0F+S0WA16Ij4dNEC8xZKz4yg1LHQ0KlufGSQlwZaeTQKZOkZrHAMKPGfUJOVLEIvMUjK2WhGppOC6UsF1ds8LG+7FmR92xleCs4H0jtjpjqI3QPEs54Tqg+myDo0aNxcePmkuhkLgftDmYpspRSuqumZTgjvXCVyOQAoYlZSJE6D+BExgB6D9hYMclvtUDMHQPFsNhDBnVoSTlJqj7TjVOCuA72w8mWfH3lRwNA81ePesOhHm1oCc5g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66lOWpAaK5zKFUU0Vgsd6LoN5fMkPghGE4qHVN9x9b0=;
 b=tyaMz/OQnFxBHU67xlIklgMYfE30TsyizhG/rfmLrLFEudu9M/Xpa5cic6JDCGQ8PBFnzTil/V09zHUwIqd0lupptnZWPJHqGMJkIeceqNSvx4HXgV0a7wglKEurNMxZhP1JxbFzVhtnGezORWtku/bns5pCX8SgYSzijhgdQ2qRLLWIPiDmk6J53sXElFCmhjcQKCv/VjE2GWviaz0+UBpcLZs0g3bE6xFnDO07j1sl4fluJ99vpjeLta5wm26LEdyahrFRpVuXbkE4EjHWmZQMX1uCqALOxmmklSgDVRYd5pHOZY0TXi5j9TbZ4S+X4fAFaIOm0IoCAjui6mMSvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66lOWpAaK5zKFUU0Vgsd6LoN5fMkPghGE4qHVN9x9b0=;
 b=LTWwVUUHYFrEHQAnTUm2OMD+2ghUL4TZshwMZPXmz65vDtoYNr+sKULIDVPHExqih2lYFco9yrhKKaEYF98Le0IYDuluol+CnIrqUhMbXEuYE/Kow5wQ4Rd+mwM+NMD+0mynJ4N3lbL6w6BP/N68fcSp2HtY09GZqaPhNqoYd4o=
Received: from AS4PR10CA0012.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::15)
 by GVXPR08MB11034.eurprd08.prod.outlook.com (2603:10a6:150:1fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:56:41 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::8f) by AS4PR10CA0012.outlook.office365.com
 (2603:10a6:20b:5dc::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:56:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ue1FQLZ0qwM90Av7/+WCbVbSnCWUHqgsbiygiDTdj86alvdml9P+7rAr6gmar42t1VsaMdI2zNdbh3sXxeYWNwOXBot34BZoENdgXz8QxYyzrF5BdupCjUjhKqDGN2EE+8I03LDX9adbdQWJXkcR8pc9f4/hPcSrN6wW6SoCNZDpExBif0DcvdfLtiFY2FKSQ+riRX1JembR0GyiMHs3uBTTDlyKL/jLUa1HLKb6iWczL1UdooVhgtHCo64CFu8JB/TYmF8tiEKUk/VnlqmTtvnyGkzgxuaYahajR1TiZgKJ66s8H15Go0PmklAgaTfjUtgk/Ql6tMElUOxseMqjSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66lOWpAaK5zKFUU0Vgsd6LoN5fMkPghGE4qHVN9x9b0=;
 b=lwk0UwO8XpJzUM/C/1ULCe4JKPoHTcC68Ho2CcPNU7WWQ7fiqta5Ddy0n0K7NZezs7luQEFcLQHDI4BJBIe0i9itQMTHc9LJoVf1NKlCxyFhwZcoaos0GRlybLFTK3i1mcgEJIZeUMnhnufDE4bbd1tqZzIcwpk+9WOQ2A+JRJauA8L21kQzqqyac6rIZk5tr5Mn/MKQaeJDTJZHjnHFlYccpvtMF8/72MkHC3RshEcSpx1lqG+dUendoUz1naQ28If/xNKWuEOyu2+zxnKSc8h0XfyENdtByh/hHRy5E+C9/tG/lFB6vGxYKBbRdfYbrsxKniewJTW1o3p/j9dOVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66lOWpAaK5zKFUU0Vgsd6LoN5fMkPghGE4qHVN9x9b0=;
 b=LTWwVUUHYFrEHQAnTUm2OMD+2ghUL4TZshwMZPXmz65vDtoYNr+sKULIDVPHExqih2lYFco9yrhKKaEYF98Le0IYDuluol+CnIrqUhMbXEuYE/Kow5wQ4Rd+mwM+NMD+0mynJ4N3lbL6w6BP/N68fcSp2HtY09GZqaPhNqoYd4o=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:37 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:55:37 +0000
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
Subject: [PATCH v4 28/48] Documentation: KVM: Extend VGICv5 device attribute
 docs
Thread-Topic: [PATCH v4 28/48] Documentation: KVM: Extend VGICv5 device
 attribute docs
Thread-Index: AQHdG1r1ukur+BDIska7apvlMVZsIg==
Date: Fri, 24 Jul 2026 10:55:37 +0000
Message-ID: <20260724104819.1296803-29-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AM3PEPF0000A793:EE_|GVXPR08MB11034:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf2ea02-1a4e-4a8d-4e05-08dee9723deb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Pi16PNMoK99FhsvXfed0kX7ouA1JPO6hj5e0ZDIRllffa/WTHuwUTbpwWW7fyf93QcMZaQyeuV54KbPSP1C6tY0R6kMVfwkUymLWpCwEurtkR1qp6sHXvU8RKOmZVjxcibMTa9FxdcAvGQH58ghwXctTM18Zf1DDGi2edRBHIkGJV3vs/7agR7ojgzX8T00RmH0ZMik8ru4sOyzARqXzMDpyejgixxZ5adRo4R2x7MycB3c+vKxa3P8a32vJF+RxbicN4jJCexFNtKROm1Ru8AkFOxsftWbNhqaYDkhV0TWUEnTw5c6aHrsXebDiQPScNSa/vVXkkhJvAe2NwSnYczyPEsEyWkyfd1imaQwYxTviLE044qJOeRZG3SxXr5COSR6DvMI4ysJH/CmpUuRN5qyTCYFaeAJaI3L3ra8dQnjgheN91gr532fqTB+7KpPbNZPzYHa7Ovk4k/CS9/Y/jVhGmJeGQYyi3TcLkikMmJNOk0AFCWfcJD8UKz3X8wSNDe7wzxKn3e6hVa1EehqaIzJEjIqII+vlAZAvvpujk8xit48/cIJtXvrDMMIqntGCRw0lCcC47flBYz+H1jWbPAa6D1/U0tdJlun+XoF1A8sXu02ldqErL6ESA0WUvK7oUTVqBCEbAwi58RaZRxi3xzMJ1TuY2vu5Odze5rhBW/o9CZzSRvD5RL63TaNGbNJwkw1fEo2hHWQo+xkTibFAHIHdf0OY7yE6d0kCRchhF2Q=
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
 jGegsaAVoXMYSRoUDEvFB+NrqwK3YjgDQuZXRaBgQmxfIlbY0x0rJBgVop2xd9eAoE4lNTq1ecz+VxqYf29eX2MDXgyggGWsMXjKTIuJgm7394L1BlpymOWD0EZa6uNo9W/zYe0DmiiR1fe10oe3rp9PaMyx4w0koEDL+bgFEKDzNbfEv709J2//LG+bRFL0xsWQkd5nfHUKpmTpgJkS1yNOtE0N7h7/tSPjNFhleGp6PdfCfmuyQaK3Pb6vOkVUfvigsI4YSVp8nEywBuNy3GxrnoJMkjhKPnDnW5H1DM4m5JMxXVNYIHgqy3klpCAkPPhzM7Ld+tPyWjPW6umomA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bdf5c493-0ef8-4eba-cdd8-08dee9721836
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|30052699003|82310400026|1800799024|14060799003|23010399003|35042699022|6133799003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	r6ILzOy9OPmdHtI4702O8LDCAZV7c2JySkF1qVux2yMCxS78c2kzTOJWwpDl5DTkFFq9MLeK8VIaqW7LN3XhwijcwfBxBLBBRQv8hgT10xzZvx5eNlB7sv8YxXbMZ6ZTQ8H9SjuW2Ibnc7aMp2zP+SM00V3iz+E9oPweB3bhQt2FmZjlcCPgiEzCgP9KrDeZ7Ax+7u4SNDnitJTURLf7lM71EuIf+mCW/bkBGO9WSoYbsP5K1hm3JGLZn9zNPFOEQ4gYFfK44yZpCDE0WU8+28or9kdEE6b3NJhrH0WN/OTxe9VmdxFmI+XlR7yhMcA8joTiIdZkce1bjdCRn2ZtcbjF2y5f+C2277CdCPWvPQ2s0QhdYxs34WnIgAIMSc4pmTciJ/Ce1lALozNNR9a7dlbZCYCQM2VQGFnhrzqK0kJlYEZYZEgrGp8rWD6ZB/DGToBL8BYhl7aUJbG4pwHLGtQoBNzOTsqwpM5gH4SR6/ka4lkhU8BXGmzZLCz2fqAQUL8Ul5DKC2vXTw3HG4XzIttBljYxsgqF7ClcXJPIfRyYyHz3DvAtBuW16DxFrjd8wSj3SJ/nxsJ+2Nn4sJQNLXSQ8JyXQO3dBG1P34EqS0hKlaUieW6UX2h/U/d8hi9anVs1r0nEpG7EpNIM05STI8sEpVJ4NAaQQYiwjkBCYc+tLVOi7/A9iqMun9vDxbO9TuB0L9jnGpi/QvrtQNmTxg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(30052699003)(82310400026)(1800799024)(14060799003)(23010399003)(35042699022)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+4DkRlrg3lJ0Fi4wsdCzLu1CUmhGofwussZgc/rM7y41DIt7Pel0ACQiT0Agi0Th2KO+ZbSQfGvZ7h3cKooAnAPc3t7tcuCLWp0BFVdgrvb+D8T16K/eFKucmRHjo41j48bBGPV4cR60Rx42Fs1o6bFzKTptayfk3VHy/mQulcUUCTzrHeQVBH0yFzlP94RjXywFjef+jN1ndYIZA0iHOsTLFPo3SzBg1w8lcD/iskFPSFZ7TaRreFXr4XwrSjd0xFdtK+owEhZbghsDP59kz2B5u9Wazx9CJLEEvWq/SUnfKHiChSFF43KFnOhIpmoAKwoK3UyEwYWGbJUe107o2QhkmOdwTaUO5+aKfS1Oz25DuUuS2dUq5B9/SV9GUWpTnz+xF4XGV/dTZjHkxxHV1p4oFV9tEGPvL+pol2DNW/foBjtMN8576tje+2n2FXxN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:56:40.6619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf2ea02-1a4e-4a8d-4e05-08dee9723deb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11034

Document the GICv5 IRS address attribute and its GPA layout
requirements. The IRS region must be 64K aligned and covers a 128K
range.

Also document the GICv5-specific interpretation of
KVM_DEV_ARM_VGIC_GRP_NR_IRQS. Unlike GICv2/v3, the value describes
only the number of SPIs exposed by the IRS and does not include SGIs
or PPIs.  The supported range starts at 32 SPIs, is configured in
multiples of 32, and defaults to 32 when userspace leaves it unset.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 70b9162755c7e..6dc02ca8f6fea 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64 KBytes in size.
+
+      Setting the address of the IRS in GPA space is mandatory before VGIC
+      resources are mapped, as the IRS is responsible for handling SPIs an=
d
+      LPIs. Failure to set the IRS address before the first vCPU run resul=
ts in
+      an error.
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+   Attributes:
+
+    A value describing the number of SPIs for this GIC instance. This is
+    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or PP=
Is.
+    The value ranges from 32 to KVM's VGICv5 maximum of 65536 SPIs, in
+    increments of 32. If userspace does not set this attribute, KVM uses 3=
2
+    SPIs by default.
+
+    kvm_device_attr.addr points to a __u32 value.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
