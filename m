Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010002.outbound.protection.outlook.com [52.101.84.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250BA366050
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747938; cv=fail; b=ESro33ybM6jvDzXKNlXsCr+zqjm/K9a7ve7U67bNI+QYpvLmjIcWnY5FIt6MY43cgRgmxGEtMpaKhWJeS+mRaRXSbInejmWEAi7acJ6kykmsv3Hh+zmXF9AznmjVdLTxXLS2GNMeHeUdYte+gsKIBsUm4AfEx8w4e9T/ZETLOUo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747938; c=relaxed/simple;
	bh=e1t80HaGWTVWZdVf9uaX2YH6mRkJItOYhYvXTGhz3UU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fyOJbRsnvx4yfZqLtFhsOcAGDRb2v/AS2EK9B2gldcxogrTtEWcpY8R6cPL+DBXtYmPvw9P1OuRK+KGp2Y85DmNCyei86WNl4hxY43F+f2SL8DyWLaisPtWUGpevFag3gJTfpSLZRmrGH+BpGq+ZqZfAZuAp+DyUWHsO/u8D6FE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jwFJg928; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jwFJg928; arc=fail smtp.client-ip=52.101.84.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jwFJg928";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jwFJg928"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZM8yFU2eeXGUZ3cITh4SVuLVUKa366cd4wtkSqkIM7nXbIOhjDWHT5+zb2WXjjiLLy21BdFqJbp6yG7ljCgeAs1wrjLT6Urgog2YgM4evn4zS0N+nHrfenBz0WgOzjRkyTbFX5ysgpTdy8PAUhuf8knCnkuhajktD+Y/N5vDbpt2tykSk7zrmpPTbZtYN5JtNeu4fsuMw8ZN+veFuzKOXxAItyodZskjZ7BStxC0bPauag7dlAKfJJI5NceHmUWch1P9wtKiSYcX6NmueCjHwDpsrHi1FLUunVWh2vZy5k/lwU7aXS2I/4iqsKMD4YDrpJh1gnGPLGoakD8o8KL4Tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMhfaXuqgfJe9a3yBtOJWmg9kZICN+y6NBE8Tf0HwKY=;
 b=eLAKvMn1UGfPLetjZDWxhDItl5EfVliFvafQONEIzvNPhmltTuHCF4fxVCaDvIo9NT04fKitCi+wiK7IRS8pyYHMozYlOECivaku4Pebgw0+HflV16LzLWkYJfVG67IP/oQ1LCGYjYYodBKVWEOdNY9Xo+AJinEQPwOmBaoLORszdmEDeoJNoPqlCs6Q8BGMZzoZFyhrsWtKMZX3NlVhIgKeC0Ydny21KQgZkKPOp/y9HHyqUuKGNBltwSSt+Q39bykzza0y2BVVJ+YpkWGPTyTZqZxinzttXyZhYwojn6oPKtxuo8li9of4vJ2EkvD7eFcsMz4zd1RxgabcQnBU/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMhfaXuqgfJe9a3yBtOJWmg9kZICN+y6NBE8Tf0HwKY=;
 b=jwFJg928OA0GRvKHXsjytLoSYXI6q6dMxAbPF1PuDhrQtSGMtxv7BWolXTuYtQQ1nyCYzGWs6MxU1ZRIBp2ILZHB6hPLQUQiwKLQXm30W+WurHg/Lsd1vsTVzO4zXKBzcNbP7o2LM0lAae3+ShoK0RZXKeQREZO3/QsZwNkgimk=
Received: from DUZPR01CA0325.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::22) by PAWPR08MB10043.eurprd08.prod.outlook.com
 (2603:10a6:102:363::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.18; Tue, 17 Mar
 2026 11:45:29 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:4ba:cafe::7a) by DUZPR01CA0325.outlook.office365.com
 (2603:10a6:10:4ba::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:45:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Tue, 17 Mar 2026 11:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TseUGzo/tnNGj4qWRyL/C9AZam8bPcYA+JyZAojXcNGv7TuxJTUUSuB7SZ6GcreO6OXOXCm6UbJvTceONJzWg6IV6+/aYuvCbEbh5ZQIqdzmO4RcFi/e5ClUaEe5+h75MJnC0Rp6Wj1Dx3uUquNRLt34DIUejYwNx/hSfgfsse5cw2e5ZVyQMllueDUbSF+Ju0KEv/6UyyfvTq2ma9yvsOmj8SpmM3pj8vRqajeNz74BkFBS4saxgXoeZVCeteox9Bt8EMC4Lc4vjZb/7ZNEVFRfSZ6MQOOmHtpM6mp8Y1rvcgO8jE+uUFusSvD9Yz7uuOKu+M+p9DfRT6MhBcCfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMhfaXuqgfJe9a3yBtOJWmg9kZICN+y6NBE8Tf0HwKY=;
 b=QCkrS9hTqwO2hc/FFCg2eL0po3OPG4k6hWwrQBgN6Z9c6OLkk7hQ0uj8tSaUiwimps4WPwHGXH6ZKgsbSgus8MGvUhe/ZVDVKMDpGkyQi0SJlYv659E5uDVz8lV8HsziXyB1SPQlMn6pkES06I087DCZcHGNfTWdZq7TsuCs4erB3Mcy0FFg6DV1O099zYqR0OLO6GcJbNKmP0+/eUhFvfiD5aDOrmzPERKeDcip3VSzpjH0ob6CjocOCM80fBrrOa6NFZtKVsMEpbnRUxKZKIQ4n61MhgIBMtRk04yQbbFmGd/zTqDjuVMG/IWWz+90cuqF2QxQN2y94VhYBcchqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMhfaXuqgfJe9a3yBtOJWmg9kZICN+y6NBE8Tf0HwKY=;
 b=jwFJg928OA0GRvKHXsjytLoSYXI6q6dMxAbPF1PuDhrQtSGMtxv7BWolXTuYtQQ1nyCYzGWs6MxU1ZRIBp2ILZHB6hPLQUQiwKLQXm30W+WurHg/Lsd1vsTVzO4zXKBzcNbP7o2LM0lAae3+ShoK0RZXKeQREZO3/QsZwNkgimk=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:44:24 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:44:24 +0000
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
Subject: [PATCH v6 17/39] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v6 17/39] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHctgNmcgFNk8KN7EGVPT+zu81mqg==
Date: Tue, 17 Mar 2026 11:44:23 +0000
Message-ID: <20260317113949.2548118-18-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DB1PEPF0003922F:EE_|PAWPR08MB10043:EE_
X-MS-Office365-Filtering-Correlation-Id: e66ec0a3-b77f-4bdb-59a6-08de841aaee2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 YgO6TYL3g5Sz06czdb/AQ6I8LglnI4cyBE1ZqojlA+3Z9PMspkRrV4DNZEaTOq6TzM66ZhYaPyLBLL06nMbmgvSx+N0pHgc6jfcBBIH6XCaVsKK3QQ4KxEg56YNd55fLnfWOS0ooLpSJMbQkfod8BS/24sT1t6y0jNCMzKKNZOFZTSLUBzKT/epsWlYAVfiYCCLiebe0RHzx+5RntkmBOlvMvuWhsrpAdcoaNg6y4/Z1jjhInfNHDnJZYdq+YHJgT9tZoD2xqplmwmdyOyAN8aEGsr0Fx2SffVUZ0KGsECJOR2HVBCYSFMBlLpCBmq/4gEVz+sfAYGdyA2ZNzQHB5R9xLZPXcxyL8E7E/8aeW13bTCg2IWMmoWaF8QrzsPSnnDaPPU7MpIrTPjH6Quw/x+3VCaJifUVrIC/6UIsbyP5heOzhe3zE5/R3tHXuX/Y0l7SO9kDn1DoPkQ9Tje9sCSX15fhUkARtcWgjF4HgLnI+vnQtpIYCsGbcLa6QnNQ8NlJJm+ceSXrIWHyzbhDi+6s28XY5LxKBf03SQu6ahqRCx7tAE8xQp5jhSqmYNUiTvgORdmMLeFOmgswPoJinFvXfCB6LSfO41bQlyYzgRXrRrvKimLVpjLlnAbSz8Pl1OWxuCnyoLMIVOqm+sZNBD0IT87bkjpg2H4sL+hqP5Y4B/GblvOupR8SjMzp1TSeizpkhwgG6+nt7FS+wHCMGiK8L85MmXWFms0gCGHEwnnfmygYNZ9TtXCzl0pE43dGzPdHdPWaUgmN5vxM+marlfFC7z/Oj6PNxROxcO/H0Hwo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Fbuh5T356gL+K3DDpxUnCKmx++qjeI2MZtZqD3socIFix3gYlU10ubTRvNWieniOAQR3eV5THIl1/vFGhSOwiQYOiwEoXJgX/IY1zO4RP1JxKeqm/5cdOGAX/fpatwsXuDfxum1uYb8ZnnJCBlEfkPTJd55cSAM0ZuM+ObG2/ed6YUKmGbm5iWc8zrMcMpqIf06GBMVJuCZe0iWmDJYGHU37h//HtszMz29aoCFGnlJ+GnnCVVgSYCbqJX4c/k6C3nBO56xi0k2tjGtfTuhskpE8VwoqsuzZa7aZq+G6FGCosJDS0kBxpBb/QQTNh86zBOXlI/nafkNARobV2SyNYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25acd95b-9d29-4348-b1a6-08de841a8996
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|35042699022|82310400026|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LK/V8R8mG3XgiPK7fLioDYS4dRYk8gcNs7WDCpAf9jCLjQqYtxk3fv1036SE83Q6rB4f5R4GuzC75YRpfyWkKSDboU5FV3PjNPeyM0TGSTRpi+9eFBTwUD2h7FCO4eLnAQmr+D84TlCeW2BJFCfPGcqEqanerrF8vBJ9lpe7T3UJj8Q//g1O+wc0l1RbKxovlIi7pG3UAzgTHW110AdMb9cAUnPtyqxWQxwjZmwyvv5X3vCihostwiCejO7GlNfo1tAvOX0D8gCpXSBlVL2ICMnmCApM2DzGMvomZ8KUOqKb4TVFN3gCpdpJ8PIV7XFYjQjmqOcvMJ2sq1diXnslOyNzQNJ1vZoHUTdZo/YF/xshOkbamTGZDyVO+xn+sbizOr7R4ndSdA0c20Ua7ou7Uo+lGNLF9htiyDQA+dhN/72ze75olN5pHoJcnXaxPyR9xixgCyNd8eFhZJ0WG1yzDXKCAcajOAKool0Lo7Ik6ywRrN7ODjmlGZKiUhuUO1HDqVsPxpJq71XvuUJj2lG3pUubmX5E+NPfnN6ON6uU79p6bneV/D5MrNPuSiViwhBG6hurAZgA4U/3GtJWUTwGe7kpwil45HVdj7y2i7T6y7YAOad5TarzYvm21/S25fw4I9hOdDCkDmqIh4gSwqydgBnfUE7xYbXGE3291RbV0ntXn391IPKKPV6PVrbjxaB1JSBUA7ccojiiIXH+92ngow4mpWNt3Ss0y6DQzYRBZj+rvvWaHRDyK2+jTOtyqKMdrr8bxNRcV0MQySw/afDClQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(35042699022)(82310400026)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n+8KBBHMfXIY3VnScqaZV7xX046yZbOI5ZScPhnuKdQAa8troRN4AcyfC5Ti6tlSH7+AyNzrJQX7ctH3NrTMEkC8NnSb4AVQfXHXheSuKrPxzvQE/hXXpbX7y53lRS8Uf6/9p6T71M9hGt/j0xNtf3TBKJliEFAXndWI9J5p2vLAM/Y7sV5YXDbY5DZubVBE+rq7QLVjNdSSpjS0KX7HlTN9tYEZTUFPIzosWqiqxy6QuE3gexAXL2seYHUQ/A0o7kwrLNITiGPRPWGpu1m3wAv5onM2dG2D3EoQqPZ43IbmYfQ35TZhbZBG7oCKX06tuDo1n/rbt3rBk1uy8OnEHp4M+72rjMY78hABn82a884aTc92M5KS2BK4fZ97hF/B0/xq9zGwWcqLjMBcGl9Cv/TQT9Yl3avJUSAkCI+oPxRGmGTJ4aQymwqkn5pNgDr5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:45:27.0191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e66ec0a3-b77f-4bdb-59a6-08de841aaee2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10043

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered. This mask is global to the VM as all VCPUs PPI
configurations must match.

In addition, the PPI HMR is calculated.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arm.c          |  4 ++++
 arch/arm64/kvm/vgic/vgic-v5.c | 35 +++++++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h        | 24 ++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index aa69fd5b372fd..5bbc1adb705e2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -934,6 +934,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 41317e1d94a2f..07f416fbc4bc8 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,41 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0;
+	int i;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	/* The PPI state for all VCPUs should be the same. Pick the first. */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+
+	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+		const u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+
+		/* Expose PPIs with an owner or the SW_PPI, only */
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, 1);
+				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			}
+		}
+
+		vgic_put_irq(vcpu0->kvm, irq);
+	}
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b27bfc463a311..fdad0263499ba 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -326,6 +326,23 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+struct vgic_v5_vm {
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset is a
+	 * combination of the PPIs that are actually implemented and what we
+	 * actually choose to expose.
+	 */
+	DECLARE_BITMAP(vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * The HMR itself is handled by the hardware, but we still need to have
+	 * a mask that we can use when merging in pending state (only the state
+	 * of Edge PPIs is merged back in from the guest an the HMR provides a
+	 * convenient way to do that).
+	 */
+	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -398,6 +415,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct vgic_v5_vm	gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
@@ -588,6 +610,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
--=20
2.34.1
