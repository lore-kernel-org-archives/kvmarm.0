Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010026.outbound.protection.outlook.com [52.101.84.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAA432BCF
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101929; cv=fail; b=gFZS8D7QHhUI0hSkFD1KcTQihuRDycST9bkkUv5mXf0JO22yDyLaPAE9Gf7OMnmeV944Jj12O0tj3cyP1h6aIJcoVP7HIyGH1DgAVYyjja00enB8EyYbHhAb2BkUlt9o5ni9sG6FdzrwgMzdJBLVnCTxyVhCNd4ni6+Vxv/Y2qU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101929; c=relaxed/simple;
	bh=tpVEUFWFo0N5gUA+T39KZP+mLbZEDCDrInv8mZxqHa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bdwC73Z1Qo5D8YBKBqG1YHVEwGUd17+sFf7ziGRJ9XjBfcvs5lNfsqPiWtdujHuzuP4THav9JoHXCejTBh7T5A9T4S6mU+gIXpYJGYg3yIQ6VehtOHJ92pnuitfyUcYFkmLzyJtVhRNQdPW4aVlwWAs1dVrgY3PS3oiIED02soI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IZC5ufSH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IZC5ufSH; arc=fail smtp.client-ip=52.101.84.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IZC5ufSH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IZC5ufSH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y1ZjKK3mZRN1SoS1+9B4eVxj3LgW4adVzHD8oI+5ok1b3vX95PL1xkzdq3avHPjXAPOPM5vCyJcOQetuD7Hgr2fZWXa/VkB+t06cYPuS/BsqcZ0sxwN0HlvLJDO8NX80mCs1uwCIyV1GNHZtdmtnzJ5itw6j09GayoPPd6Sm9kNa2eGeeO60UhMakgiPZYdrvzQIGo3bYwHROdJ34YXEYl/SCip+RZDk+vYFe0wMBrk5cGRn/gI83ydo61uOBTYIeEsUdmc5n6rQo8twzQ3Sq5mEzhy8HesCx504p/HT1JmutdsQxXujbnfVZpDrExmDad2fR9YhsdO9Gcd1CAFgUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=F8EiphApVFK9eeQc+w5XAk1U8+HGM/8LsJ9JY1cl5KjA36eakWT1Av5SUio4mtksH3qHYqW3cYE06W1owsTg27RVItYrBk1EAn/rbrRHVhg2iZyE9W3Tq/2MXOJjmG3csyGYqsazHFKn/O1ImenD/WckMF3bJNLLtC7QTAKNzvN+HPaPCPL9+aFZsPUEaf5z5iOYqfQXu8qunTicEEKEvXF2mthU2ni7QSEJrUpbY6TwU4+rEk1OxMsFO5dBxj7H3lOj/HNS6ibviPIFeKVFCA/+sYb+RZ+9ciIYNh3zpfUJt1NlWkLhJADFJwLspmXtVJqRMX2tMZOdlqN7zD5tnw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=IZC5ufSHRSqLYIAlkkLsghGknDpCSGVqNCp/V3yvXAujp5oahDWUFUoDL57+Mu09vc9US2S5W3IrUUcVJJdzG/wOaI8PrxDfxVzKGOyXILvkyR98aBgOprnyCqSr2Nk0Kk6DiGpX7g7jEDH3pOz556f0cSeKXyf2QkTVcvTvUjg=
Received: from AS8PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:20b:127::16)
 by VI0PR08MB11019.eurprd08.prod.outlook.com (2603:10a6:800:255::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:25:22 +0000
Received: from AM2PEPF0001C715.eurprd05.prod.outlook.com
 (2603:10a6:20b:127:cafe::87) by AS8PR04CA0131.outlook.office365.com
 (2603:10a6:20b:127::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.22 via Frontend Transport; Fri, 7
 Aug 2026 11:25:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C715.mail.protection.outlook.com (10.167.16.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:25:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+EhKV+wSm9kdJGwM2gJqOpki40QOXdSvqNbrT+WWNmNBpuIyO56lS4OF6DD9+6Z1tAwKRd7OsCPI4xqNMlNM/HoutVJD5TbspA78u9ufKEh+Vn5I94CrUzRhHI9VydNgU2TIOMkE5lb0G2DLWwrs5yFoi7TT9eTBFijUeEbOiqMnMv17N1BwC/V2ScN43fAMehgJ+pn8Vsw34s5sp98+MV9l5JhIsIFfcVG8XGnHfT/2rffOYYJToMeuuYA2Y7v4SXUCX2C7ZesUly+4mVQOPXDbLBbgQKJutKzl/5olZD7iv6+ZjsTC8lXPRtffyFmx6TU6ykBNj2sHeG58z9XxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=SU24u0og8hrRXJDHs8ZJFdMC4hXYM8ELyi59yR7dPj+zDZFxFtMHowDBJH34TN8uHfer2zrej55p84EI7tNvwNu9Cog4GyBNKeidk8jRP2rGLNpVp52R3Bn+K6TnFZKgUDjbCDK+HhL0DEwHGMNiLXbX/uuESi+lFVeY+kmm6NL1NzpJN9e6I2ZUEe3fZBZDRy3wAfu9kncfD49vJZCanCpF3ajfsMKC02o3zRo3hLYPmm495cfmmOTQPHbLLMM/5d9Ejgb+0BDompfH+tz6INBDZYJLlJG2+nCF0RajyytV+Py8XzNKU80Fow1Xh8gFfvHlNtiyCE6Hf4ItIu3GZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=IZC5ufSHRSqLYIAlkkLsghGknDpCSGVqNCp/V3yvXAujp5oahDWUFUoDL57+Mu09vc9US2S5W3IrUUcVJJdzG/wOaI8PrxDfxVzKGOyXILvkyR98aBgOprnyCqSr2Nk0Kk6DiGpX7g7jEDH3pOz556f0cSeKXyf2QkTVcvTvUjg=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:24:49 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:24:49 +0000
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
Subject: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selftest to set
 IRS address
Thread-Topic: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selftest
 to set IRS address
Thread-Index: AQHdJl9bI5CcPYzil02d3zJ5lxXw8g==
Date: Fri, 7 Aug 2026 11:24:49 +0000
Message-ID: <20260807111159.429128-25-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|AM2PEPF0001C715:EE_|VI0PR08MB11019:EE_
X-MS-Office365-Filtering-Correlation-Id: ddaa6f30-b00b-4518-6230-08def47691ab
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 UN2d9oLBNZzKLNKdkDb8//UfUel4+3Hqel62Max2NpT0/ektak3+MJ8KQY5JkjoruS3+lqXHWp16SQGGG6AuqW/+sIhweE3LBnStOaoPX7n0KG3ZNoeeDaeSO0Ipy46z0UJfWq65HiP+UxYwhPeUmgm4IBiQmn4SXlI+78BNjtLWcOA7xgFCUNow6jUUVvrZRbIsDK6NNFPd9Vsc5TpKw7UwlUWkA3sNRN6bEyVsbGJvLAQ6yQSO7niW9w7pT6sL9vcxiVGW0G534nNTuojQrk+cL1kZgraSPcwcMfPFlxaEff5kqM2kTjZBtfs1NOEoT4HUq+TsYys98OQUrGe88B2h/21R4P9/MUfKaPCfqJx7xv2PnlJO0QUBK/kNM+z2mZE3pYy9wI7uQCpTHQqGaM8ESKEW0D7xUPzt0TwhVn8ZVJPeJADynplciOdxlH6j2S13C4uIekvZkiOs6O1n1UmWP7TWDeGDAezmVivJXSGFrFguI2gUeggbrAZTkpUO1JnJFjhOH5ZNWWcgCIuWBMSvRgxuYNgT6SzS6RHmoCDc6wojc02Jq7MoM3tUEIBgq5MLqQbjWAmtwl8Q6CMwtj8wj0aPhINex7IxMK2rPFWDQ7o340niPRvVACzM1VfynlBcTAZgYO8QTrZpqMHsCLorR5voJIbnN5v3MyTgF78LYg8l/l6p3wznFQAynDao/vZ/DmxS78H4fCPwIZ2XzxCbed8Jzz5YwKH+IFrbmNU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Kx7/uGDEvc5yUW6R+OM3zo/VNY9k9frCWpipQVrl11X36gwWS6SmRfPsnTIjFe4trkfhbRqGpk3MbnELixhT77neewUnbcA/S0DFVBBuWYptMMck/SCNDXT2MKpXM1xaebYjfBQzPLcH4yCwvnzIM1bxOwLouzmFqOKw5rDb3ysf6tPKsOgFgJ1IqTHL9AKRLHZaj1tWyCeJqzYgEBbAcFY9KvVNO9fdO4C4yr+CcAFLeHQ7ybTxzB94rJ6Kx9PMKKnngpgtuqAIGGmRPKTVwbxllKuIg4Q6DjkP89ltgJooscaZ0YXffGS3iCHDqCSFIrvaE3jcdCoY+CHGTvPvEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c4a971b0-fca9-44a8-027b-08def4767e1b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|376014|35042699022|23010399003|36860700016|18002099003|22082099003|11063799006|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yrka4qqNANSQdl1pLrVQFIdOW28pUME8LWWQVEBvN6ZiqxDns4RTglSn35zNDQYNVjGPbuGGIG1tNwPgiEqqv5FTB7LvMBWrTyKhUWWE2g7FJXSn2tOnny2SKMuyMwYK9JKHAeQ1om7Pfq0ybWb6A1FwpeRwFHwSS3aO6wfE+GkdYjvsiQ3GuPg3YXA1Cjca3YcphNLc0sdC/522uAAhCh6wUxkPsLM0IzeI0HUY1wjkjYiHO3gtZEPKo3nuqioeHln7e1zbOFCdTQW0qGQCUE9OSWGLV5xIk+6RR/7v/fiNvOL/AYPFVm5izObv62F2g8TtpBKhanCVJeFhZOnC3AK2h1Y7XwW4Rbn3Ykyp6vvNFfB2VxU3txS2Dug6Mk+OUhvLO5A+rf3nn9/kYdKkupOtVzBMATVPxkptPywglZ6NHkQyvDZzViYGCKG1YGpLerw6FHOtO1jmL7u1V8ouyI60YNBZSu3d/4zd1rsTj1+8sgo10u5ankC2c7Z/9g26HEpAiWoHzYtMUyuilLhJVQoMJNeCuAfXtYJ2axF3FJPq7ttkA2e9Av5LuBXqoouGhFbmvWhnZacUTNlVNr0tF3djCSIdIqVAECuGfoWlkA62elXuOEQw8mnVs3YRW06/dnY4TzJ19eX6soyi0qiv/7aDs8nGmupYR3M/UeFK8QAdVnYtfrRqTU+MiSgRzBAXN03q9wCE20q8MGeyrK+kmQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(376014)(35042699022)(23010399003)(36860700016)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	stTlsxfQNCL/TIT+8Xv6oCEGhW7mO2oOkK88d3ZJ7Bn1oCYNBYjoJeeeZx8oUdxEGq/1btF+IQSgurmu4gGB86FnJjz3eFHG7P/cBXVXcfCwJtUs3+kWyZl2nT1eyWjynplZASMN7CGBsQ0uitaLGilp2gy5wZCOcuBZVlMjE8q56zV5OLNkRG+lypphlDzZTx5MkmjykrU1Rx7KX/6IZDn93YXgjsF4HnSkVpRkAtkr/tT/JnpAgkus1iPLCk3ATcl2rUVA9Fc0GVai0aNjW5bozPxEMh913Zs345vLE/VcxGBooslkj3tlvqeEvhER4m8JVenevbZD6r2hAdzCdk2iBn+Ts69R0agKQ8yLZXSxGZMWBaGB6JRAYO/KRBW2axZkuV+Ywvd8HQS+LEQ/WCt/oUqt4QbDe83YO5u8NG9HChvGMfPR3Eikz6LTNTyC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:25:21.9554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaa6f30-b00b-4518-6230-08def47691ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11019

This selftest was added before the GICv5 IRS was supported in
KVM. Therefore, there was no address to set, and the specific UAPI
didn't even exist.

Now that the IRS is supported, and setting its address is mandatory
before VGIC resources are mapped, set the emulated IRS GPA before
initialising the VGIC. Running a GICv5 VM will fail if userspace has
not provided the IRS address before the first vCPU run.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c        | 6 ++++++
 tools/testing/selftests/kvm/include/arm64/gic_v5.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 96cfd6bb32f6f..19039a8940568 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -100,6 +100,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	struct ucall uc;
 	u64 user_ppis[2];
 	struct vm_gic v;
+	uint64_t attr;
 	int ret, i;
=20
 	v.gic_dev_type =3D gic_dev_type;
@@ -116,6 +117,11 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
=20
+	/* Set the address of the IRS before initialising the GIC */
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index eb523d9277cf1..c388df8f2a2b4 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -10,6 +10,9 @@
=20
 #include "processor.h"
=20
+/* GIC component base address is guest PA space */
+#define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
