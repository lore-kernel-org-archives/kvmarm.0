Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011035.outbound.protection.outlook.com [52.101.65.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB0F427FA8
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890733; cv=fail; b=aOqImCwMjTw/K4ZWdd+wXh99GBNNiIZMd/RuoN2+qXpc9z6JAVbNXb9C1+0zYwqhdzEVOrpNyQtPlwivZDhnIDjxEDCjsfQLrd3UX5BBDUSzkz7sDlBQj6cCvqUBvbWOXRpX5avVLWbq8rZAmRI4SEph4PWmVGmwTSBpMpLQ4RQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890733; c=relaxed/simple;
	bh=TpiHd7q+JkO6C2MpGRmFAgvmoO6vZitmwmZXIDYBHYA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QLDUV6jJJNARRvB9KBdJdy2sY92KbC1zbcpEbcfMQe5fabc979NJVfNvlxQbT3jjYaGIL30/4NA3vhiV34aSnaXDIJvoiQPzJUxssezWIc7ZoSU0DmF6l1+gDPZUQlH7wQED91pRoJgC/L0Fmkh+Wwr1rVDERCRG6RZek/ChBwA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eILop6fE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eILop6fE; arc=fail smtp.client-ip=52.101.65.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eILop6fE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eILop6fE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aJkyX1jEPqDg0tfWpxktPqbl6fT/64pVz0aw212KG8YtC1NN8K64yrRw98F8rs7gWszswXnquL+5RyTfClzhpGJpagu/ykDMEBrOTJQy1pbHp53qPkIFp7+F/gANPcBawDaKCXnm5a220GtWc5ROlGDoHEXqirxHFj5cu3U1jNmdXZuTKmTh2Rlj6JcvTkV/Xa+4UA0Yrk1kW6mmMo6smDHDnKMnJNH2lsnCCGt+b35RqC90f6eNdtm8ZYuhrAgfOBljbGq/+7NCsg4V5wQrtmZhXPw5YkZsIcERJsMtLmQvTqMg08y89ljTvJZwRdyLHLQavugP5/IdeCDjFeN3yw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZ0krJAYqkpNuazE0dWB+JX+zIsqz1SUTUiNMBwyhBI=;
 b=jIsGA/f4fRCWCH2mQDj/h2LXmXzT8AuwsMW37xEL+8e6vBQoFM5aC2vbI+uweIhlpnxRSvJTjjRian2fs5u5+KUm7xm9saio6RWc935ksrpV+HBg+IRPS/ol39ewCEjtFV7BrHSa2kEE7xISy66NEQ8XIKMfgaNeipeytrq95nIQdyltzO8UUWYkIaCandnZjDV8Gh4XpIWhSS2MQ4YCHufQE6+1AC7b1/kjqKn2JKslPr7pnzSRUyhOaInE3Z9lfnvA04p5yXbPfXsvFjYBkm4cJFUuScLo5iXJOHOqbdxgLaaLaSbL0EE77+c0PNC7eaQPTdBmyR6TnYo6aWZrEQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ0krJAYqkpNuazE0dWB+JX+zIsqz1SUTUiNMBwyhBI=;
 b=eILop6fEv63ev3661JCMpoD6wP31Lhrl8WmHTtg+MhYoPHrpj4qqeziMnKNaDTskspmEv2GFgGfJDVaEsdNxk+cuR/6ZtqH8A/GfMAUzWcilAim5M5dwLRcZv48aAES68PatY20oMf86A859DY1jqcLMV8UO++p6nWhHdVgStxo=
Received: from AS4P250CA0002.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::20)
 by DB9PR08MB11403.eurprd08.prod.outlook.com (2603:10a6:10:60d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:45 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5df:cafe::74) by AS4P250CA0002.outlook.office365.com
 (2603:10a6:20b:5df::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:58:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:58:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzFtpZC+uwCURz0OJXyB/1/cHwaHzWMJLW8jZpRfsZFrlmdAC/LAJECY5b1GU/oDOIzfw+MqtQxvtfzMNhlXF7XRwB7h0H/OntEPQE9jU+9WDhw+cQOETKerca0uZdl67ijHHtZP6jHcvKpf4x2n/E7QIA7N2PerIMBXa6ycQWxlBePUCBsu1RNEPiEAvIJHYhUFbnA/FPTAYdWE+d/dB2GBGhi0SALlUJRWnTr/Px0uR7LExvTV73HhY5NFNNUfKfE+9t7fDIrZ9htX4wgmWaByiNUtUMopSEhnKYYAmMEAiEsx067+iFIUT6NH3kxMM3kCtW6j4ozkTv06Qoa0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZ0krJAYqkpNuazE0dWB+JX+zIsqz1SUTUiNMBwyhBI=;
 b=biH9Yw9SeHTjGEEw0b8BK1AnJIY+9ZHhAwuFx+r/GQ015upejV1f82N4XiaeOeh9qaYXKkNEy6c+yAX+OW3AKGAeuF/SvICaBe+NXiCUEAJUTS3cSE9/5jNPrClcDBQ7Gx9SWRSH2SGisLEwYc1VJB6/dT35y+DjON48EUwoOwUt78pgYE2dXkr4MdVa7u345HhQkGpfvMB68ONnZqAvKOPXP0QcfP3Lq0YeMX2Vtyi9G0YQmN99gVJsD6LZdMwOlhWjrE8+dclMfpYfTgM21hDkdXjk81tBnA9mGzEZHVpaDGawJudHpK0zBslGDXwJNGSNdVEvwOiSVDxb9kvtOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ0krJAYqkpNuazE0dWB+JX+zIsqz1SUTUiNMBwyhBI=;
 b=eILop6fEv63ev3661JCMpoD6wP31Lhrl8WmHTtg+MhYoPHrpj4qqeziMnKNaDTskspmEv2GFgGfJDVaEsdNxk+cuR/6ZtqH8A/GfMAUzWcilAim5M5dwLRcZv48aAES68PatY20oMf86A859DY1jqcLMV8UO++p6nWhHdVgStxo=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:57:42 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:57:41 +0000
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
Subject: [PATCH v4 36/48] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v4 36/48] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdG1s/rFNHVDnuL0OAF4fDbpC3YQ==
Date: Fri, 24 Jul 2026 10:57:41 +0000
Message-ID: <20260724104819.1296803-37-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS0EPF00000194:EE_|DB9PR08MB11403:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b6cd99c-f0ce-4a17-81fa-08dee97287ba
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 3bUh8/fdAbdRv4OCEMmT8Mj0A5+ZyzqvwZeukGUfURhgCi3Hj2iiUqLNEpobX5nlohYkthnydWwhG9NMjSsUP/rkCfa0Yea7AbLO2kgpQ9CNQh+xXEleTJQ1LeXXJI1Ylx8ulHYzzskQ7r7NF17fb2ncKAxfLXXDgrQa920Yzl1jJ7RG0VbhFvEM1n2wAAQ+URk4Rjvp9k/R2PrxDIofxtxbGP8hOrLmzoEm+MOQJv/+wE6aMSNa5hswwtVezthYnG/qwcW17Lne0k5qvzr3a1fyYPzuwfcHvYAlglmW3OfBr0yG8ntxUVkjNa9m10F/E4kPBR24dvAqOM+gRX9dVsZ9CTYj20CqGBxvFkWLJ0V5XJY30mNAafyOs+j75Z0mWmemROizNu3r2qR5CxEQzBGP1E08MgQCo1LI7YLgeDVn4iL20wT5/dxhc0ZPvM9YRCUQcNJJewtexmw2mJiBjhDwRWVpJt1ibHkeMw3CuotWfb+FZxrnS51/LmfLxjwESa9q/oKWtEu3gfeLqqAFXAfbfcgAHJhJhwgRVqv6/sjl5Op65M/pYqRn/wweJEsPrWdqZ5pagNWhU5kF215jlEsr6dzMlpQ7rcvo/jtr8+OkGlgBAAE5cBdEhZbKScBRI41HP7hVeIFAxmKWSCz4n37kCw2k8lNTQziPqGNkD7G33ruewbENE6TTcLermppacAV8CFBRZKqxdJ+vYMeJAJ36dqpWwUI+aCxxx7mOZPo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MMteWQbm6JI0sdSoKApjtTTFIM/+kkSFZ/k+yhecUfOgEKqkpFIp2h+PtjU/8WaApGaa5/7jd9oUI4fjdEO6HWuhi37kNOEZap8utzp0GRoJF73hRj6ODS8MQi5cQCbLNbpbKsDsJt2P3Ms7HjEy4fTNCac5G/eGtLoo+TuiDLy3Ss55zUSzKeW/sMbtiJ2ZtafbTBaYvHi6aUb/7txTU/EbRXEQeVuSX+0ZXF9cT+oHEMF1KH12YA9K3t2nOBI9JAUvKbwjLqD+ohsYYchESOBqRzFk7ye/ze1STnzDYoBvzby64I1JQkkhGL/bFg+sEVXCQS2FxaTpuBV25Xq0MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b1ed1696-1fe5-42dd-1911-08dee9726256
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|1800799024|82310400026|36860700016|35042699022|376014|22082099003|18002099003|11063799006|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	t5SyA2aaX9IznmzoscRYOggHoWRiGKnTt/16MKy1R34ZE72BjshjOezsfpGBdb0dh55T0mHMyZnp63YhrXTWplsy+ZEjuh1zjmo91FEN7Je6+wvLAEfTn1944Li0rPYYMQ52LbmAcZDDqwt7WqTS1XO7xDgDUzHTYTbVN9rvJ1H+JYMV5fBiHU/h5FD8HxITpYUbpBRvMEyQ85Ul5DT5iB/PjPf0upssXTH4g4cLI1eCS+nfsZXOR3w3gkZhC9Mg/REG5R8f7ery6yP59hmriDH0Q02PejaSuGkkssYaUcYKq+a0xotSodepCOr6j9WgdD2RalU5np72fdRWRB52JdFi4fQE2zre1+2olzmgRGQegC69mjW4ZsYfJcC1bsZY9/SXyKOd7+wXlLL4myzSUqxpCGOkv+TjhiTOsBe8yN8Szlb1A/GlmHawt9LB6roCefoqRss2UtNYVTPi0ddTVdG1XmVn3xmQy2FJQwcp6ZJ6huDRGc+XxDrno5vY+KF0Z8PRyX2yLxVBwH7hUs83/uBEP8UrVQ6MSonvXwLHiSt7YsCHfYEmBQKilQRRE6eA20Ec0+Q95vs6wz3jC6n/3AVe+/vvZI69Dt2ZzwpjzN/ohm/ljo8VurIMYf2HUBk0O6qBjI7xU5qGKqkAbXIYxglyNitJqTuzTCTCgwv7p/WXxlNGAMh9zvC9ya3ih53lWKBv4w/r2zpJM+10feXs2A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(1800799024)(82310400026)(36860700016)(35042699022)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u/kAArICRAaPl6lhRm2cYsHa9ensbnmDcR6N+xmkscQzpHMkJUcaADPk1eZBI25IPIcJNcHxj7eGLIez1q4J4KM5rR2Io+z8OnmgUdK4Xip5VH3sk5qGSeMyo/fern4B7QkwIK+9qRakiSGTV1mien63CiUWzv5e7ueLN7TVG5gEwnI4o/uHMC8IjwLmy2zmsTqdI9aTZS9hXiQlXv4OepLuYW2f34ZnZ6Orw5sH/dcu6fu/yzdtEAQFoltPmowzPAPIww9cEW/W0iEY+ghprRCDVIO1zESNGTfx6GxHhSSXaAUPY8zGw9KFEYVoonQs1tl8chqLV7bcOUV39ZDjnyeFuJu8WnMp9K4UwKXgI6LhxFKGBs5kZOpSD/7ScotZRnksaF2iH+EquMM7rdiCLJEAx3D4wfDNLHLh4XooDmCrsyggIEyBBSi8a1MHNfvK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:58:44.4882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6cd99c-f0ce-4a17-81fa-08dee97287ba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11403

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
read and writes of the system registers, albeit operating on a
different set of registers, of course.

Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for GICv5 in the VGICv5
documentation, explicitly calling out the registers it operates
on. The main body of documentation has been directly copied from the
VGICv3 documentation as it has identical operation.

One key thing to note is that for two sets of GICv5 registers - those
pertaining to Active and Pending state - the operation of the
interface is different to how the actual registers operate. Both of
these registers have C and S variants (to set and clear bits) in
hardware. However for this interface, we ONLY implement the S variant,
AND treat it as a raw write. This simplifies the act of reading or
writing the state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 6dc02ca8f6fea..50d8030e2c804 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -75,3 +75,77 @@ Groups:
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+      values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information i=
n the
+    architecture defined MPIDR, and the field is encoded as follows::
+
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fie=
lds
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero)::
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers =
for the
+    CPU specified by the mpidr field.
+
+    The available registers are:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1    ICC_PPI_CACTIVER0_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER0_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SACTIVER1_EL1    ICC_PPI_CACTIVER1_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER1_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SPENDR0_EL1      ICC_PPI_CPENDR0_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR0_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_SPENDR1_EL1      ICC_PPI_CPENDR1_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR1_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_PRIORITYR0_EL1
+    ICC_PPI_PRIORITYR1_EL1
+    ICC_PPI_PRIORITYR2_EL1
+    ICC_PPI_PRIORITYR3_EL1
+    ICC_PPI_PRIORITYR4_EL1
+    ICC_PPI_PRIORITYR5_EL1
+    ICC_PPI_PRIORITYR6_EL1
+    ICC_PPI_PRIORITYR7_EL1
+    ICC_PPI_PRIORITYR8_EL1
+    ICC_PPI_PRIORITYR9_EL1
+    ICC_PPI_PRIORITYR10_EL1
+    ICC_PPI_PRIORITYR11_EL1
+    ICC_PPI_PRIORITYR12_EL1
+    ICC_PPI_PRIORITYR13_EL1
+    ICC_PPI_PRIORITYR14_EL1
+    ICC_PPI_PRIORITYR15_EL1
+    ICC_APR_EL1
+    ICC_CR0_EL1
+    ICC_PCR_EL1
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Getting or setting this register is not supported
+    -EBUSY   VCPU is running, or write attempted after a VCPU has run
+    -EINVAL  Invalid mpidr or register value supplied
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
