Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011036.outbound.protection.outlook.com [52.101.70.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCCE364EAA
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375246; cv=fail; b=hOcqOm3jJsLiYW4A9E0+ngj/tx9O75ddKgAQIU8WDrK9C4OSmOEcliSgOQaUx7FmQJfzGYgM2nJ+n7Bfuc7fChZnKvfT865cHd/lf8LoKIz9CKVtXt+sN8WSd2OGdAMtDdgS5zpj7zAbopEE8dfCxVgMcAY9lDrYZIymLYJFbgs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375246; c=relaxed/simple;
	bh=ed+ZCqTpPYYK6q7CMgkzuD8mfCWieQ6godf359SVEag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ICNX1wWLGv9FV6S6NOFykuBRgOd6jJCfNO8Mk6nKVwbJ7SIVuPq0MdIQGuclItzVGweFF0RFh4enk3EGaAX2M0pxBbXbURVs7j8js54lCK05WKbZV2qG4i1gjuwG7HFFMGvtd9DtsNqXQOHV++WKWXzsXY5f+nYSqt1h0/GLf5s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OBIY6Kp1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OBIY6Kp1; arc=fail smtp.client-ip=52.101.70.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OBIY6Kp1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OBIY6Kp1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=m6GkBVze73GvAAVjA3mezMTT2ALxbZVEm0GPabindp8cbRtr0kXs0pO5QYJrXelh7M3oFkVOvYJ1YM7O56lJgdrgp3efwPd1UnMwzed7zOKeGW1doFBDds0g4IJ701qsS2+JL6QHrwlNuxmPPdX1twST5rxCTVPHnX3IDWYta/OXnkJyrcwgEiIhQle+2+gMVWGcyHpMbS4pR4Lq/oXeLqJGwlmistkTLddvqDnJamzn2xlvv+Nn7JAlUvTC0zdfut8TI6fMjQvPMTCNykuX56YoQbVRu20Eeju7XM8Zvq6dInwlBIBgUqXVlGLGS52NT0XSnZI+/Gu2blAh90nR6A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4GZKy1fhzCjMO+TdtK10b3qkqRxhxPwzHCPkMfnGB8=;
 b=Te0D4fFH4rtPmTNNXzeYfpuBr6OFKNZVdWtK6VSzCluxH6biJuvz7vxX40bRkFygYF81Vl1b9E/vdp2H0BFVi4krKhsacfuQzi5GJR6tGs1n95OE8xxlSjzlPgaeVRpAaLpmQhXaes1Hnk2zIoL1goAwR8L16n5gssr7q1BV9vC5my2O0JsHGTLzD4wAzgqE8DYiRr6HFQgntxj7brYmL5DX+F1ECfS2pJ4UW7LgN4U+q4E0pMJf3PtuTn3BTvwiI0UVfITGS3z+a3WhMU0qRiR272vu3S5LZkpyiBS/UPcpa+zy4gT2hu2srm3lmNYWXZSX6ww5WmaBRxhXhLtm5g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4GZKy1fhzCjMO+TdtK10b3qkqRxhxPwzHCPkMfnGB8=;
 b=OBIY6Kp1ZLIl0Cvg0zBolrzJd26cccQvp2MPJhesnLb74Efn91Y2NpXVxCYjuht4OmCrCDrrryI/h7/lxK7Ezh2Jji8dqnSUzJFuu09Hg0QEwkPdXWLHjUvsE0YD/CwnXpkWJK7HQxBTDemBm3aRR5kNTG5udL/+lgfJSrIQvEA=
Received: from AS4P192CA0009.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::16)
 by AM0PR08MB5347.eurprd08.prod.outlook.com (2603:10a6:208:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:53:57 +0000
Received: from AMS0EPF000001A5.eurprd05.prod.outlook.com
 (2603:10a6:20b:5da:cafe::47) by AS4P192CA0009.outlook.office365.com
 (2603:10a6:20b:5da::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:53:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A5.mail.protection.outlook.com (10.167.16.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo9n1jSt1joCTOHsSt7OR7hHIZ9/F7BZzgbhz/xQUeoL/u891Q4kdJM0plnyv4Myz0ayHAuZHC1h0YInofMgmlPwl1YI5ZQSp+fHCucsYQBmj67+mj0RQJxjgU2WTuuRr/9foURL0wr3Z1LfCzP9MQh/knVXsEJYez17wdO5jWONTlLxGukQ0c6STA1ll71Va6uKvrr9mdcyKTNw6J/ZjJhQyw9b3T5NBHBCbATx4/ANSSqxE/Hxj7F79Vo8zdN4sVu87jhOCrQg/s0Yj/FCcqgIMrXZOF0UEkvQgxk4jPsj2RlPaeBe3/fTQuZJbqrPHRBz7RElzmfKtFLzVG/GOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4GZKy1fhzCjMO+TdtK10b3qkqRxhxPwzHCPkMfnGB8=;
 b=gFE9Rzf0DCWg7YlSqvo+qK5xfXylrFf09wprAyNlgfPL0DXtsEZNQvH0d6qCxge4vpQxL9Q6f1SBZQPFM6vKaF9APdzFURrgDSQY2lTVuKO1SVa1G0p8uFa+HbrFOQOkudB3rT79fVlXLO8mgRC5qhkKYYOf6V7fz9AZvfXSX08qiT70e9dCa3wvbYAkG33vRjJe0vK7a1oQDS5aLioXCa7PBcxwpDF0ikoxcB+IemxyIBvRbigX+/1vKvyKdfFY+B2VCneJ1Wn4N3WaY2IqQV+E4ycQLXKI+fcySJ43cJkiI1Wp/NHzOeHoy1SRKicrdlfzF2ouRBcDpNwn3hwr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4GZKy1fhzCjMO+TdtK10b3qkqRxhxPwzHCPkMfnGB8=;
 b=OBIY6Kp1ZLIl0Cvg0zBolrzJd26cccQvp2MPJhesnLb74Efn91Y2NpXVxCYjuht4OmCrCDrrryI/h7/lxK7Ezh2Jji8dqnSUzJFuu09Hg0QEwkPdXWLHjUvsE0YD/CwnXpkWJK7HQxBTDemBm3aRR5kNTG5udL/+lgfJSrIQvEA=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:52:54 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:52:54 +0000
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
Subject: [PATCH v2 11/39] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH v2 11/39] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHc6TGBbYEQMmLojEKS95D57YWD1g==
Date: Thu, 21 May 2026 14:52:54 +0000
Message-ID: <20260521144846.1899475-12-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|AMS0EPF000001A5:EE_|AM0PR08MB5347:EE_
X-MS-Office365-Filtering-Correlation-Id: c3e6255d-50a0-44ce-6285-08deb748c921
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 haFcenloED1j23GTkh3oqqo9lPj7tlV/HwpOvLA8mq1DXS0tL6ySAS9wh3lOIHtB/XI6E+Jz3PthS3MsMyoGJJFQtGJ/Y3Yh+kJ8HWy3qEWIxUr87qYcBmXWPjOMZPDol2XeZbMi3dFN6K++xzFPRtv33FqL/zw/C8qho8yrrWMvkx7af19MCzj3WM3bBavZFN1ODHs183zK/B4cvuy6hTkoXU8snJH6eWRKehRuEyN8O9J5/Iyy3s/2+US08hkn+zEdTVWD5HjQNoMI4zJ2NaWpEEt1J0kb79gdF+BR99Vrzo7EfJMLUqYgPkbQsC/eUQweU9tFSldzSZo56ehlZilFvF97xWc0xf62Mk3aKtH2rN7C7+hubxxCrGlHU2nneHi0I6+0gL2MsLXLpeckBbn5xxJBn4Es1SevTrYY+S3RG5F/nu1EcsWEk4bNoVokLlW0P9+tBw8J4739MWLGGeq2GKYg6M1MuwlBnOR79jHSRawE4ozzujpHvt9+btYFUFRWVxpjnnMKbFIkBNxMdH2Hg2E/yaG9qzrS37TGlSqsj5JWdRRyEMlG8B/d58a7SkG+rEUBQilMysASe5eAJEd0CGERoCU8bQcOnaUu1XO+7ItbXeZ47AVpS8cXTOFtb0wUb+1L9eZksXtdPNPn+g6NQPpvGq4ix8CIWPDpzwVsOTfj48uaeiY4RO5vRC1YnoDiUxQLrxEzgjWsHUtcZsMW6Gha9Dt4M57nG2KLA4PvqQDStLdXIimmDQWffMqJ
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hKxWd3o7QojuJwuPVMh6+S+1B+BCMWRFoXOIICtSpr2ilUa9elZpdCi441eUj0UI9yMKmM+FQLw3MmTHV0DRyi1rl/2N0vob9VYhZb8WfpVWwPbUfANViO6PkOmF8WlrxkA9rUC84+hRFMJwLvHo8kkOIukFYSnwyotNqoe3EAObbBeKLBJvugLqhm/3pr+CZGRWOaS310D+fwxhL7nK/J8rfdxvs7pKHYttXH7nW6vNQSVFCTyFXFGCB8X0bSjmLX5hPFNomRzy6TptIULVvKBusaALug/5SjGSJDp2ZYK90IGuGEvrHU1+8fkOoBuPNbH/8jnphcyyWJEMJe4S8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	621a2036-113f-4058-a145-08deb748a3aa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|35042699022|14060799003|18002099003|22082099003|56012099003|3023799007|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	8kvLgPmVgVmloNoOPuQz+RJAQHLKOxubRsZIj01V3lUD5Xc89miyF8Y/E8h2Nv42vMWNDfqg1Ef/skzjy1mjh2PixTiiwWeoIJjq3eXecPCHakgOzDIE5K/s8g1O1IH0Y+k4lO1l299Zs40sdk8JgUBxVEjADkKR66TFU6hSZ456qIQvsy9//U9Ov4m6rrl/W3fvvnBlqg+PQwDWG7e/V8tiPpWTputvGnGjlroWDU6atp5WbgPP0lVlWqi8pC/GA8nCqM9z6UGr6+X0kxvH/C06UgYcvcwx9PjKNMCZyR3cfjT8QFyED69IfT0R38kdOgJsFkYF0IO7CelcNceJ0IoetqEnlLTodukRL5aiAdzFKEKjZKvtAYT8/tZQuVc6e58Gacf4C7RrVqJnc5yxZj6Sd31JarIewYJYoBIEbypLQtZVPF8oR66j0NkFwWI4oUF3Zwk/8Zti/hC9jjzbpdp9AXpEYtOYzZixYFwzLgt0rbd0Z398FYt8mG41XLZNUIRLB8RN/vUfc3pm8kHtMjVhQeATLLO5E6P9Z+ikhBYZwYqy9MxY2XO5CkMz1F9TXJEoW6iCmO7wSE4EIH+Dn66kh5KXDMAt4UgCP28lgB3QI2svnTH4ORD2p/TjVhuCFb0heOC5UQ0h5C1879hleaKfcRB4xmB7NfEhKizCgtQDJQhBgOYMyzKnrd2MIkf2qxp+GXpq7c1jwrlbpm6GRIUs1+QyvIXqJh9r8vjUKkA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(35042699022)(14060799003)(18002099003)(22082099003)(56012099003)(3023799007)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8EoWJb3S1RyxumiX6gZIG6f0fvC7qovYg0xIrYXZ1LV7SP6AVtNonAdmTKfergYuVlbaQBSt3nf0e/EC7+nd+hIBQ4eHqcMWfJtrUE8TDVJHIO8v5rbQEATj2TFCSS7gNNj64LmT0ugajRu2yGikRNJqmq5+Hvd2hW1fnXt6n/rtEQsf6rtCSespu0iErm7gVztQOS4GLmtD5B/GKmytY5iKyVAOn8LPVdp+jgCPoj6OIunCjM5eJeRziJf78L3ijZog34Qc5ywcdf55tQOTjwPIxalZYwmJj9sEL63wqeV2mfWqvQGYi7K4FRRx9jVQ/V8AuP43FrJ8EK+eQuS0DQ4kpyTM7Cl1CvHwKDEh/lpwtL6polscMcjMnU/qZJ9iB1nPkjkcjT1CszUaZ/nZtZ2D1RPStGLVPKuzrlJtnAvjbjnMwJRXeK9e+N3pC9SK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:53:57.2153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e6255d-50a0-44ce-6285-08deb748c921
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5347

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc, valid.

The hypervisor is responsible for populating the VMTE for a
VM. However, it is not permitted to write the Valid bit (as the VM
table is already valid). Instead, the VM is made valid via an IRS MMIO
Op. The same applies to the ISTs - they must be made valid via the
host IRS.

This commit adds support for:

* Making level 1 VMTs valid (only), allowing for dynamic level 2 array
  allocation.
* Making VMTEs (VMs) valid or invalid
* Making SPI/LPI ISTs valid or invalid for a specific VM

As part of this commit, the following vcpu_affinity-based commands are
plumbed in:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE (and hence VM) valid
        VMTE_MAKE_INVALID - Make a single VMTE (and hence VM) invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

Note: the lack of SPI_VIST_MAKE_INVALID is intentional.

When successfully probing for a GICv5, the VMT is allocated, and is
made valid via the IRS's MMIO interface. Treat failures while
allocating or assigning the VMT as hard GICv5 probe failures. At that
point the IRS VM table state is a prerequisite for vGICv5 operation,
and falling back to the legacy path would leave the host without a
valid GICv5 VM table setup. Later failures can only fall back once the
IRS VMT state has been successfully cleared.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  58 ++++++---
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   2 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 188 ++++++++++++++++++++++++++-
 3 files changed, 225 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index a1d0f620b7913..5c87c6c27087a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -67,6 +67,21 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
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
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -497,25 +512,6 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
-/*
- * The following set of forward declarations makes the code layout a *litt=
le*
- * clearer as it lets us keep the IST-related code together.
- */
-static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
-				    unsigned int id_bits,
-				    unsigned int istsz);
-static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
-				unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
-				 unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
-					   unsigned int id_bits,
-					   unsigned int istsz,
-					   unsigned int l2_split);
-static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_spi_ist_free(struct kvm *kvm);
-
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -665,6 +661,23 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+phys_addr_t vgic_v5_get_vmt_base(void)
+{
+	phys_addr_t vmt_base;
+
+	if (!vmt_info->two_level)
+		vmt_base =3D virt_to_phys(vmt_info->linear.vmt_base);
+	else
+		vmt_base =3D virt_to_phys(vmt_info->l2.vmt_base);
+
+	return vmt_base;
+}
+
+u8 vgic_v5_vmt_vpe_id_bits(void)
+{
+	return fls(vmt_info->max_vpes) - 1;
+}
+
 /*
  * Assign an already allocated IST to the VM by populating the fields in t=
he
  * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
@@ -723,8 +736,13 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, ph=
ys_addr_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+	if (ret) {
+		WRITE_ONCE(vmte->val[section], 0ULL);
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		return ret;
+	}
=20
-	return ret;
+	return 0;
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 81fed6c5b1559..acd862b8806d1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -82,6 +82,8 @@ static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
=20
 int vgic_v5_vmt_allocate(unsigned int max_vpes);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
+u8 vgic_v5_vmt_vpe_id_bits(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 120eadff9a128..f9578c2a634a4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -10,10 +10,14 @@
 #include <linux/irqdomain.h>
=20
 #include "vgic.h"
+#include "vgic-v5-tables.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
 #define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base);
+static int vgic_v5_irs_clear_vmt(void);
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
@@ -36,11 +40,32 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+/*
+ * The IRS MMIO interface is shared between all VMs, so make sure we don't=
 do
+ * anything stupid!
+ */
+static DEFINE_RAW_SPINLOCK(global_irs_lock);
+
 static u32 irs_readl_relaxed(const u32 reg_offset)
 {
 	return readl_relaxed(irs_caps.irs_base + reg_offset);
 }
=20
+static void irs_writel_relaxed(const u32 val, const u32 reg_offset)
+{
+	writel_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
+static u64 irs_readq_relaxed(const u32 reg_offset)
+{
+	return readq_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void irs_writeq_relaxed(const u64 val, const u32 reg_offset)
+{
+	writeq_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
 static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
 {
 	u64 idr;
@@ -85,6 +110,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -105,12 +131,49 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
+	 * can't use them all.
+	 */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
+	/*
+	 * GICv5 requires a set of tables to be allocated in order to manage
+	 * VMs. We allocate them in advance here, which alas means that we
+	 * already have to make a decisions regarding the maximum number of VMs
+	 * we want to run. For now, we match the maximum number offered by the
+	 * hardware, but this might not be a wise choice in the long term.
+	 */
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	if (ret) {
+		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've now allocated the VM table, but the host's IRS doesn't know
+	 * about it yet. Provide the base address of the VMT to the IRS, as well
+	 * as the number of ID bits that it covers and the structure used
+	 * (linear/two-level).
+	 */
+	ret =3D vgic_v5_irs_assign_vmt(irs_caps.two_level_vmt_support,
+				     ilog2(irs_caps.max_vms),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		vgic_v5_vmt_free();
+		return -ENODEV;
+	}
+
 	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
 						  VGIC_V5_MAX_CPUS);
=20
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
+		WARN_ON(vgic_v5_irs_clear_vmt());
+		vgic_v5_vmt_free();
 		goto skip_v5;
 	}
=20
@@ -138,12 +201,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
 		kvm_err("Cannot register GICv3-legacy KVM device.\n");
-		return ret;
+		/* vGICv5 should still work */
+		return v5_registered ? 0 : ret;
 	}
=20
 	/* We potentially limit the max VCPUs further than we need to here */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  VGIC_V5_MAX_CPUS);
+						  kvm_vgic_global_state.max_gic_vcpus);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
@@ -153,18 +217,136 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VMT_BASER, IRS_VMAP_L2_VM=
TR,
+ * IRS_VMAP_VMR, IRS_VMAP_VPER, IRS_VMAP_VISTR, IRS_VMAP_L2_VISTR.
+ */
+static int vgic_v5_irs_wait_for_vm_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VMT_STATUSR,
+					GICV5_IRS_VMT_STATUSR_IDLE,
+					NULL);
+}
+
+static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
+{
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(val, offset);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
+				  phys_addr_t vmt_base)
+{
+	u64 vmt_baser;
+	u32 vmt_cfgr;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
+	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
+		return -EBUSY;
+
+	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
+	if (two_level)
+		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
+				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
+
+	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
+
+	/* The base address is intentionally only masked and not shifted */
+	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
+		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
+	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_clear_vmt(void)
+{
+	return vgic_v5_irs_write_vm_mmio_reg(0, GICV5_IRS_VMT_BASER);
+}
+
+static int vgic_v5_irs_vmap_l2_vmt(u16 vm_id)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_VM_ID, vm_id) |
+		GICV5_IRS_VMAP_L2_VMTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_L2_VMTR);
+}
+
+static int __vgic_v5_irs_vmap_vm(u16 vm_id, bool unmap)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VMR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VMR_U, unmap) |
+		GICV5_IRS_VMAP_VMR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VMR);
+}
+
+static int vgic_v5_irs_set_vm_valid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, false);
+}
+
+static int vgic_v5_irs_set_vm_invalid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, true);
+}
+
+static int __vgic_v5_irs_update_vist_validity(u16 vm_id, bool spi_ist, boo=
l unmap)
+{
+	u8 type =3D spi_ist ? 0b011 : 0b010;
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VISTR_TYPE, type) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_U, unmap) |
+		GICV5_IRS_VMAP_VISTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VISTR);
+}
+
+static int vgic_v5_irs_set_vist_valid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, false);
+}
+
+/*
+ * LPI ISTs can be invalidated explicitly. SPI ISTs are invalidated by mak=
ing
+ * the VMTE invalid during teardown.
+ */
+static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
+	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
+		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);
 	case VMTE_MAKE_VALID:
+		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
+		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case SPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, false);
 	case LPI_VIST_MAKE_INVALID:
-		/* Not yet implemented */
+		return vgic_v5_irs_set_vist_invalid(vm->vm_id, false);
 	default:
 		return -EINVAL;
 	}
--=20
2.34.1
