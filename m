Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013048.outbound.protection.outlook.com [52.101.83.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18440244675
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306826; cv=fail; b=j+KYr1xlSCUheC2j/V54ruMTm1iJb4kcbAdz88ENQAikaVauxH/EIaF6fSNq/A+qButB9UO+UGq3f9/RUqqiQf1A5u8E9MFig4agneuywdmxom8N2JqrSFyfziijwDBDB9pZkqgGDzz6ZSSsXFAhA3lRJTCCgQBHyhmP8MTryjc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306826; c=relaxed/simple;
	bh=v/HAD25VK52NDcT6+clomvrKD8gf8pFIkF/0zUq4Dk0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ejZxT9PssGtdOhkbxj5n02jrC03gZX33WmLOXCCHjskHp/yy6rnytUuPbWVON8Pfedfcw8id9rzEcBYWtBvCjWTgC5kSh/ts/nUo5NA7O+nZvbt+KNqgqVOTn2hcN6jMJ+i+doKWo9lsj3q2YxNC3ldTDMoqg2R8d2WJE+uuVZ8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MvKO5dKq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MvKO5dKq; arc=fail smtp.client-ip=52.101.83.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MvKO5dKq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MvKO5dKq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XdUIg4cwUXPc9pfWuwbby6l/38gTLvtBne+yUZLfFRxGW78R0yg7tU2yIug5dhhAxf2mQ06l7f/zGhKAjyt1/mkMaCrgZaMK1aV0U+wdlD6xvO3YSSWmcIbXr18mr4eowzYMGTz15DbjHgOTvqGTMjAFF+Zc9o+1h10fedqg/DzCA5fX1JihhkGqOn1BOy4IZ2OemEHPdEt7bkXXiQQ9xZZrnJQIp2qc95FKlrjJintO3vI0VyG6LkIZUMqYLNpooZZP47+ixyqFhJunLrADrnlR1nB/BuDivjVVd94ctzEVxtoHL1K7NFsROicwzpxZDU0wtLqCGSSDxGbl7N4F2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxSgJ90E8bd5u2ouuTGCgAVXiP4ksOAIVDwE3LJiGAE=;
 b=fFPYx5tIjq6yZTCj4SH2sHpR0/UmAs4NFDjvH1QRnuu21YyaDLX6Se8WUrgz9IeZkz+UW3Ou83B0snJrv1dMIOp+uk8O00DtfC45B1JW3CeaihiiWg7XG/xuv+VDdXenQV8MbnH2BvkS0bF+Kaosb+1RGNCmpaecUQp4jJ3BRb8uFUat495oxSwD1Jsj6GjDKvW2/NJMIlB0rNl1G05PpX9syCC8oEShbqOW/ZoxUVTHDx1egpUqv3cK8iPsHv0WSa3msMDnaEkcZgM3uCBxFYIswGsuADwiFhOaufC614njE12JVNAKqEnTbakKlfvpZTCDaIJHcWvVin76QG63cA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxSgJ90E8bd5u2ouuTGCgAVXiP4ksOAIVDwE3LJiGAE=;
 b=MvKO5dKqmHCX0++ZBizYLWwumgBcq1mUyWHRw6YFO1ItJOdjAL9IUsSjINMUs/89hYVQfcEZOG2dmiOB0jIcwVPfueiD4G8oEXq0S4mINJeqt2e/sSXegDqUlsKJNCt7tz4ksKh1q5GtRUwBaNCuGPGdGxcTNiFnheLqokzfvew=
Received: from AM6PR10CA0081.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::22)
 by AS2PR08MB8693.eurprd08.prod.outlook.com (2603:10a6:20b:55c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:20:19 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:209:8c:cafe::7e) by AM6PR10CA0081.outlook.office365.com
 (2603:10a6:209:8c::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18 via
 Frontend Transport; Mon, 27 Apr 2026 16:20:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAaMaW5m1Ong2wIXidtw/IixRcYQb0wwscuIi4sKJEu5dDBGicoKBEcfGhx1TM28DYb5wKqE3Wn3tt0jjo7j/SpuH/2/FGeWUGhn22BQ78bmr1BCn7GQP2n6XT79PLdS95xbP92elyCeIFQyhBpWD4M0qOlajj4NAHFn+MtiY81YHbDBzsbM8XOv2AMQOjRAhHf8diV7NDbohFNwnqomKZTGJpuN9V+6e1FVxsdxLPzVOL1nw/do51xxwLq5zTJw6Cxo+Ipx7Masjd3jT2XUYTPcGvj7mmRMEaPPo4Hco+nXV3bd3NmfMb6U3MsP0bGlnmBsR8kyVWxmHghcCbgE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxSgJ90E8bd5u2ouuTGCgAVXiP4ksOAIVDwE3LJiGAE=;
 b=eUkpinf+4jk4Dws4AavpFT9giIHB6HrDa7fbEbTnVfgubxY/p7B083zxZIuzhrXrt43RknsaBfnpCTHIK7xWTd0vCHXmB7ujx2k/tWU/0xVXzs/asM2Gg91S2Verrb++HroD41Ae9jd1VpR4Oq6LvnFtACPGsKX1MaZI9Nd4WnLxn0BDj1OgjSDf9Zs1C1xA8EKKZm5rqwhjH0gsrdDnemClkR9PjQSZJCUcCfLs058RzYctM0ccz+47/i265qxmDL0vwa2PUz05UOQpmn5B5ueGpQqT/a3fFlLQuonW0ssXdRl1jdoXFXpemQRZ3+SCh0/bDokI30Yueeoqaesh/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxSgJ90E8bd5u2ouuTGCgAVXiP4ksOAIVDwE3LJiGAE=;
 b=MvKO5dKqmHCX0++ZBizYLWwumgBcq1mUyWHRw6YFO1ItJOdjAL9IUsSjINMUs/89hYVQfcEZOG2dmiOB0jIcwVPfueiD4G8oEXq0S4mINJeqt2e/sSXegDqUlsKJNCt7tz4ksKh1q5GtRUwBaNCuGPGdGxcTNiFnheLqokzfvew=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:15 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:19:15 +0000
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
Subject: [PATCH 38/43] KVM: arm64: gic-v5: Add VGIC_GRP_IRS_REGS/VGIC_GRP_IST
 to UAPI
Thread-Topic: [PATCH 38/43] KVM: arm64: gic-v5: Add
 VGIC_GRP_IRS_REGS/VGIC_GRP_IST to UAPI
Thread-Index: AQHc1mGXXZfIzo1O406Sr4zasxhY7A==
Date: Mon, 27 Apr 2026 16:19:15 +0000
Message-ID: <20260427160547.3129448-39-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|DU6PEPF00009523:EE_|AS2PR08MB8693:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a0111a7-e450-4134-7a87-08dea478dfa0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 eHhiChKs8r4Ee/G1gfneF7WfTW+/csVbPThM022KicAJa8ABy3dKByXVUMCSCkLY6rJ8CtyaNgNwWARVKzg+1ViSs751gNnkqBbbg4ro9YdLyKgyvfSEZR4SIPFNKGtsBd8WxsnWbzYowkKHiBx/wWldoGDJUDWYDlc0i74DHwMolTd8enxlZTeeJgfOaP9Cq0/zw7fld4MvWfpn51XIHU0Ed/6mVhAsIyu1DGnBBvOzQch4s9HkRRIj+Tuw3jzDVSyHS7IWuJGenlZSdoAA8XiJ4pq5SMaJ2ouy3sI4hZacstJdRuvUPU+d/8gqPrX0lF7q/2CYlQ75uT5iKmy1xLWujYFmKapNr9wDKbw1esRJb9uoMKLwX8pXpmXUG8mjaa0pMZaLPXkEOff+2nquQYPDUgvXtX/W91MKr6scDTnv5KPfQRpr6dd/MqK8ND2lK1jWf3uEo1v9HG8bm8mZ4asBELdAK4Vg5kC+Mt2vdxapTuAktF02e3VLF7Jm6zKbUAHhLWu0HzpxO6mowSTkLA0Zwzm+e1maiYY8mMl610OhL8oIJ6ET4wbrqVjWcTJw68nd6NAJTk+VGiOy94urNzOisf9N59mqLdu5J95HgaVPeNdhFGLj2aDoy6W7MLPfZihzvHSykf8eVpSR0mExoJqosNOh8nqJCDB2fwVaVLvzibEhOxlyTqDh+NLRPvhKY0W2AN/tOJYHJ/AbCn0b+3uvz4RLXorCSWbY5akOXnozmBVD6NDaiL9cC7Q+YHBzAj54b4qpa/NRt7bHbQrY5w84d9gHVXTYuwrgWC9swo4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sgJowyg9IphQfSh4rAbEXLiBn3P0s6CSABGCyAg+LmnPmgg/FFUZQKT7pQur6SMU/vtCu01IUWZd0jk+PnVSvzGlMVsKoQ5XUFj6go+vyTWSwpYPjju0g0t0vj3tE2+4YBFdt234ivrC2MOloSgoThx/E0OOM8MNzSfMHLkMVyZudsJ6DmIJ+SPOb7ZpmrA81RG/1b0aIj1yNH1NDU97Pq/4FS7UqKkmsGzBxnZdy7+B0yTt07SXmPtSuQ1HyubVrND9Y1v4K1vLms5frCspec+dEA3PsKWH4RXgGDdUN0V9sZ0/k986u/9BshHEQ375MZk/986d1X5JcVtm2UOa8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	84e02606-40ad-4393-e32a-08dea478b9e9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700016|14060799003|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vaKz+vUYrlWYDzw0U4P6MRBAQ3RmNAdYKX6KczagHPmzGqtvnaLRNH2x9cXAldIuOW5KikOqbtt+TZOogcJpCY8tdo0r3bnCP2tnUt1W9X4mtbEWptaVETgr4BLnuc+GosjZiYSScGqayjCeRlJdnbTdpE4Weo8pn7cqX+zEIqa9224kRtADZdsXP0tksEYp6Mu6Sry34yn26KQBI2W+zmLvvr07UmVdALYG8YgiAWTpv8/CzeKJlkCNKByIFWQHR7AzJZCJCVlBgxk89CYsPSZTH4TwRFnd074ObpoS7+Dp2N3CWsoQUPI3LlI3a9knJAgPliXnMfKt34QC9tBoz0f3OII2LtnyWN3s5SvNIgMu9vBVX1EnzMzrVccJMm6oOvP33QOKm4BnDTcF0TeJtd60BDtPUdT7dibLzxrAK4lmZoKTiaVZN8fsllimqKbGqVSjHEkguZCGNPCFl2ATyt8UsXt4bQtmKnFMq7utJrYz3JHrF2FPeFK1dlainEOcq5G+BpmdaDz1AXpA7wMbjnglmJ+6ow5DIjVWlL0Xkk0FrY8aCP3bYk1xNNW7x9Uiv3k4jhyU4QCWjkYrmIjOTIqufD+WZsqABoMjVZtVdi0qubplFx3HvsNCfHDqSThmPzCoXmII92TTYGO4u9/XpDw16XZfjnRem1aXRI+dszdJMevrr4AIzPeLSTY30IC822oTcEiyVVJ2FaMkwb5hIWVjFPVa9fxKXMLKNs3V/a6e7X+C6rUsAx6LsFWk1Q/bX0vj78WGlwBjuRsZlfFgWg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OyH3g4jWOsK8EJ1x3k5dtIx2DdFZyDDr0EsMuk9jwYSs6Cz0agUWjSAjBAfhRn3LHWmoWvrVePEFJGh5C+4s6IKVU171itHNTWdKMJmqCMtCjKlgJDUD+cqSiNSHJzoQfamS1BoRN82nFv8ISa+C3suB42yFYc+lHOXWZvlSIMhupH8cmhvJ6nzroLRjsZ4kkwQYUWdbE9sUovN62BNI4kLcAgBYAkMY7w9bN1cnGZ78+8yOgt0m/gPhswWmJJQXvGEy0T4By7cdVZT6dijUQoADGqH9JSysV0LLmrBfl8LC1jEd8mxcZ2P34vztwAIU/fldxP943WVXFfzqrCMxd8ShENQU9wRSnS/maJ4YSSZHIycUZIpde0VvYtK8+ead1Q1YL8exR6rhB7aEpKv7GIJ07peBAETut7WiFy7LXPjJLEDREDLKXu1yOiLzIQtC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:20:18.7077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0111a7-e450-4134-7a87-08dea478dfa0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8693

Add two new VGIC groups for setting/getting the IRS MMIO registers and
the Interrupt State Tables for a guest. These are both GICv5 specific,
and are required as GICv5's MMIO registers and ISTs don't fit into any
existing UAPI interfaces.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 2 ++
 tools/arch/arm64/include/uapi/asm/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index d1b2ca317f586..e2847134df176 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -427,6 +427,8 @@ enum {
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
=20
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..e68d1b097ba9c 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,8 @@ enum {
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
=20
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
--=20
2.34.1
