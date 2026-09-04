Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011014.outbound.protection.outlook.com [40.107.130.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580883BF679
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522311; cv=fail; b=u7JNI7dLbXq3KXFq7ebqNVVz2wuhfoXD6S2NcnV+uRlzsavSUc3XFpZM2oo96XYT1xn4n14KgAccMDN27tofmr6rj47W/w8gn26kyHUvYDnPFsyF9Id+RhFuXhApyvfrBTTEhPdmLDBgnFrVyVpKsef0OB+87vEsbQRUrk3G2J8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522311; c=relaxed/simple;
	bh=B4KVBOu1HdMIzJUXZZKBe9xU0XD4oCEgYIyls/+rGUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e3HzgsbfzVVVMx99o5FK1np28KX0sOa/u5TxPrmu0+dxlzC5T5gaFPpjEpyVaBlXMfCep2ZS85yFFHyznhwhjudhl09i695RWGBn6guQdAv1mz/bKlpxx184yRRP47frqosDgjg0E1LTkWExbkuXrbSLbIy6CobVxskLAbhTT7I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Gd16eEfn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Gd16eEfn; arc=fail smtp.client-ip=40.107.130.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Gd16eEfn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Gd16eEfn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fpfzuipg898BOT/Isg20oRr2T2oe63ktcNYqu/QWDOvKACcxTHllX++zUPHxO90f1FERcfViCEqU23t/HuahPfwStecsuEtOHkDjYSBUjf6lQCUdoIqBk+upSFNbLdIck3znHnV8eCJ2PYJIngfhn+q6kz2RVF7u04tqG9Rntxf15leGeXMhbaFAxuk8UhP1NQDIs3B3URDwc3n9cDIOhATiY1sCc4vj32qItofQydqBDiOJl4WFE9wxy8x3dWHn/cUG/uPKF+FiMyTV3Qb/D6opZt8oQmblbZe+3utzqxoiGQAs7W1Wzx7L9d46eUFSCp9dWQNCVRTyLb2tp8Sttg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bia4vLIniLUi3EE9XpK7u5TI1z39zR78GfpT16rI8Ws=;
 b=Any2nYfVgcetJVUDkjmMh4RBBl5gBRgSqwTmSn9eU1kqZr/rD+xDe5nNpeWltKxM04X/zrQQtjOUwrZw78ygtV0EMN12XsQC988GNypbq/FR1SafpVAt8PUus+HyTrPFqHPTcDfOORDNAplT9blbGKFM7VsnUrRWE5y7qaXMMIG4Y6F/yF3bVVJk0i55cs/Wgj5Yc0pKKRk0BTQQsN5mwTvGZqFRHkoV8nmeIvQJlrnI3KV/BywWjRh/H6NsK5PeSsJJI4xYt5eu4VEvanvepU9geyfAyBpvDZcNUjzkqL/gUIeLIszZhRy1otk4rkzzOLdqeZoElcPelDyQhOvOQQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bia4vLIniLUi3EE9XpK7u5TI1z39zR78GfpT16rI8Ws=;
 b=Gd16eEfnPff8epBhWZIAJWuC7HJoZPtBlDdpNYxRbGPaxaOkbCXpP20P/3VShE7E1b0umnbS04U2u1zSUE/EyrPXDuHxEHDkRwPZFI5iQP9OLQqDJE121cfwPHw6sfqllCdvCcLbQ3FvVLhKLYB5ugpyy+7FXTecZkvREo57MOo=
Received: from AS4PR10CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::12)
 by AS8PR08MB8350.eurprd08.prod.outlook.com (2603:10a6:20b:56c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:45:00 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::8e) by AS4PR10CA0009.outlook.office365.com
 (2603:10a6:20b:5dc::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:45:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQXKA+EyliMcaG2jGSFoljMcIqmdkLW4g1Rxzj8A16RijDTFMkou7E5fNGg7nqs+qbzbhl/K8U4VQo1ftREOSMoJbwdW42pmgwkatHvAszq0ifh183nx1ajtNMO1Xi8uCzcr/wgqJqflS4hB3ofVahwTsHHPU1P7z7J2TfcoYKTLY6Sj8Oz+CIKLl2Nb9lsnEhm008c0UMeLlKHV8HNSTM1C2F56zezA1ysRUV+veZg6chGp+1TXzuiHRcb0fpqoxDJVuBIOKTWcYhUjMXtxDuINOrELlK9I4MJcyv7HfXeL7sQ0ez1gk0z13LHO3Cb+heaTCy8nD2SWQkc3a1nEjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bia4vLIniLUi3EE9XpK7u5TI1z39zR78GfpT16rI8Ws=;
 b=FmNFd5SyDWCFUJ7cwi7//24WJOBdPGFvx20j/OEXd6THfZ93HLlxMJZ1UbPpAvRmBfCM1TsgVOXsHdIEGcKCdF09Q9BtpIVyxzDYFHhGIuc3VZB+Tn5DHl1+3tFoHWba34WO63RBVtq9KfKspEYxhuQlJ8Kg+z00YthP6VaHmYYOrjlFhPhuQ6ryeeutFNv1nH3+aCl6dSiW4cqCoJ4F9SL3w2SGDgbXxF36F9SNq/9dGGspwnNAyj0dDCxBAVZp4L8CChQSYhmD1HmcXyMrCsUvnCDmv9YSuDH2pPH8ntZ4YYtULe2IdO4Xbcy7VPB1pHYhqfY0HriHcMfovogYpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bia4vLIniLUi3EE9XpK7u5TI1z39zR78GfpT16rI8Ws=;
 b=Gd16eEfnPff8epBhWZIAJWuC7HJoZPtBlDdpNYxRbGPaxaOkbCXpP20P/3VShE7E1b0umnbS04U2u1zSUE/EyrPXDuHxEHDkRwPZFI5iQP9OLQqDJE121cfwPHw6sfqllCdvCcLbQ3FvVLhKLYB5ugpyy+7FXTecZkvREo57MOo=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:44:26 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:44:26 +0000
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
Subject: [PATCH v6 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v6 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHdPGK8wO+EspwR/EeTmAk0lwfCpg==
Date: Fri, 4 Sep 2026 11:44:25 +0000
Message-ID: <20260904113404.4051341-21-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|AM4PEPF00027A63:EE_|AS8PR08MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b65f206-5818-4275-0bd2-08df0a79f31b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|5023799004|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 e97Yos0Y+9G3IDwqIp9Ar1xLMAZ7ds8UoAuasYEBF8lXZN3HX3d1IbMHIcKtvsXjXD3qAuZThS2yLwUdBMyGMI67DZG2vXcYgeZ3lUOIO2qysd7PupqAcMPk2jl/0OUqU+dVOjlSbgsGREdrwfopgWbvqAoZJMn5LFUXICVcPLNEVKVkC0x+tOYvtPeSUj+1CNzcqRjsZVjA8IrLQfMQ8+wxTA1EaxpAK2E4717Dt67yqA3m9JsFzn1U1A+whX1aW26LsfmTsbIbzWjEAhZ9X2z0mCAzpPxIFcAHigZEQrAeWbSqWK1DzuUnNKFN/4SklkxsVLVxiw8fLRQl1jRjOm/tYFbTq7Deh0woTGp6rcfjqNhFRf9/ivSGJJqxhlNYWNAUc3nFcY61de1O6H3jAGt7xwyNxujvFh/M0JzoSSj62IDVe58PFbTr8UbhDJ8tU7dsy035R+8DT/vmoMmJvz08TO/5FwiznRb3cuUsD8Jgh4ZHSQPGVXPLkgG+8M4qcGCVY8rIaVeKcYveDWrapvikKuCXZeTzOoDShC7Ecq6ZYs2FjBQQysR36AzrRwtS1aCmWk/EL77EG3Uhaifvbx8yjdHVd25aDaY0/aKZjOSs/85Zu45gOu7ajjphu4rTL0iSWRwojM9US+jMximQZ8yTrtlDb6JQvHsEfPTCxJsYJ+RhzJYkKOykEL9wPnt/Uboyto1n0fVODTJkqLdeS5JB8CkJ0wI8p2b1RUaBVlA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(5023799004)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 y0+y/SQngQRcUN+ggwdgYInqpIaD43k9huvsu5Y+pOZKsQGezOx3X6rN15mgBcy/U6LCP3VsBlLpu8U9VFctELMIGFiROfb+RTEytn/GfQuEpVJozBIfybxXf/iz3o0HELLWDkFZzhIQUtcLnnQEoK5hpYq9lSf9NY6Lx/2Y0c+RwygLb1+kcZx/OkyGzUCDT29tV6fN4PLWjKHtY0l6yoyUJYE2BXaQqDmjuz0ZbcNiwwwvB7KjAO1bar5cK0fomODNYWjWZti1CN/3W9p5fQkzbS3az8FrCs4FoW0AivlBTzLNs2+FnS6Eb+X5bLMz1lD/mso/3AuljL+DZ09Bcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	88d7156d-8697-45ad-0e91-08df0a79df1f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|35042699022|1800799024|14060799003|376014|5023799004|56012099006|10067099003|6133799003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3h7ah6i2hPThC2bwZdE809PeN+aIv+VdamsoaDut0f5SxbyMH5oIwQHdUYVGD3rQwjjcN9OCCgzNMgaoTLIyoX7laAqgY3epK32IVXrd2FPIbn8fSVXWqtANHtIe2qqUQUDA+7AWwIXLmM601elq4Z4yAWr32kyxhENPQQBoCeFKQwu/oVhEjZzhr2J14rKwHc5vYf84dhoZrnuT5lEcuhX/3DP3NdXNKabU4BDACKkYsPHddROzwsmjBAMYcuVJP96Y9mWMpVgq/v8pTW93ZJUIJPNng6OyJiC3Oy4mW+ro8V0CcjZjD0O6JvgnOnGkK+uWSbYHX9TsYUsEQokTmTrjy65iEKsyNCJrFTChqKiHhMgfE0GDD0qZd8JsjVkz+jPPJm868zyO20xoaMepWTfS8FD3M4p17+IKlqREoMfxYm8cCCWYPmyo19Ca3GbesXpT7pLEVtki/pH4MBv2/ItgTW1eQjZg1aWohMn/dTmyPrgC0Js2KYxcWGR43ZS7YVTFYViMfx1WgUfCAEv3acYdfLw7jpIlEeY7lQESz119ZjH5g/sjmGXa0F3ekS+WHizVIaiZDSAfWUc3dqamfs6MOvqC4LapDgYqe6ttr4KiBd/hHGBAcCql2cJ8A40JMxniVyWf0KblXoRioUnQRhswqjzYy6oIes89FcNCccU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(35042699022)(1800799024)(14060799003)(376014)(5023799004)(56012099006)(10067099003)(6133799003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M1VKDK6wu6ayZoseqNprSEWy0njrpN5QH0WF+ztcAO1SlKB1thA8l5cMgXEzdw0e5rnQmqWcyGfn2gQv/OJ46kdPf0gIqEs2pKn+yohUb//va1R6jKn3ZvXx9NhjaeJzytxZqGcc6ukP2PNqsH7uziBGztb/OtRR9phjH/Hu5hd53PgUEqTdLTriWhyPKaA27it5Af/wi5+eBwbCFYycI5rumROGnDA5eU8a37UP9iJ4Lfe5ptBcvp5D2VpTrHMRJqvLKG1w8kCi7iRbc16E43Z/atnllZHyVL9dcdChDN34sPbKeOQCqu+uF7JjMsZnmMUwQlh59/hdw0NGNxyYC4dpEaFIsS328DoPrxPBtCrXjbl1TyKy83hFKzA/86nO+ai53AmW1fwt9H3KcPjx9e6vmRQ+vC8nmlEwOzSRKDLzpIdaUAH5u7DbvxNt549c
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:44:59.4887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b65f206-5818-4275-0bd2-08df0a79f31b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8350

In order to properly support GICv5-based VMs in KVM, emulate the
CONFIG_FRAME for a virtual IRS. This emulation needs to handle guest
accesses to the MMIO region and mimic the behaviour of a real IRS.

Introduce an IODEV for the GICv5 IRS and an associated initialisation
function that sets up the SPIs and initial IRS state. The MMIO
emulation allows the guest to query the IRS_IDx registers, manipulate
SPIs, configure ISTs, and so forth.

Allow 32-bit accesses to the 64-bit IRS registers in addition to
64-bit accesses. Reconstruct IRS_IST_BASER for reads and merge partial
writes so that updating either word preserves the other half.

The emulation tracks selector state across MMIO accesses. For example,
a guest writes IRS_PE_SELR to select a PE by IAFFID. This is the VPE
ID for a VM, but the guest does not know this. If the guest reads
IRS_PE_STATUSR, KVM checks whether that IAFFID selects a valid VPE and
sets the V bit accordingly. IRS_PE_CR0 is accepted as write-ignored
because KVM does not support 1-of-N routing.

The same selector and status register model is exposed for SPIs.

Track the state of IRS_CR0.IRSEN and introduce KVM_REQ_RELOAD_GICv5 to
reload the GICv5 context of running vCPUs when it changes. Only make
the request when the enable state changes, avoiding unnecessary IPIs
for writes that leave it unchanged.

The LPI IST requires KVM to perform actions on behalf of the guest.
Treat changes to IRS_IST_BASER.Valid as the lifetime of the guest's
IST. On an Invalid-to-Valid transition, validate IRS_IST_CFGR,
allocate a shadow host IST, and assign it to the physical IRS through
the VMTE. On a Valid-to-Invalid transition, invalidate and free the
host IST. Ignore guest address changes while the BASER remains valid,
and prevent changes to IRS_IST_CFGR during that time.

As far as the guest is concerned, the IST memory it provided is being
used by the hardware, but the physical IRS uses the host shadow IST
instead.

This change provides the core IRS IODEV and MMIO emulation, but does
not plumb the device into the rest of KVM yet. The CoreSight
identification registers are added separately.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/arm.c                 |   8 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c    | 793 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  16 +
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 include/kvm/arm_vgic.h               |   1 +
 8 files changed, 823 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 27fe0cd5b2d7a..1afaf88f21db1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -55,6 +55,7 @@
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RELOAD_GICv5		KVM_ARCH_REQ(12)
=20
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |=
 \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 431de9b145ca1..92dda57c08766 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..0bce2b4cb7cc9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1159,6 +1159,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu=
)
 			preempt_enable();
 		}
=20
+		if (kvm_check_request(KVM_REQ_RELOAD_GICv5, vcpu)) {
+			/* The IRS enable bit was changed */
+			preempt_disable();
+			vgic_v5_put(vcpu);
+			vgic_v5_load(vcpu);
+			preempt_enable();
+		}
+
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_vcpu_reload_pmu(vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
new file mode 100644
index 0000000000000..76f5f40ecc1ce
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -0,0 +1,793 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_dist *vgic_v5_get_vgic(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.vgic;
+}
+
+static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct kvm_vcpu *target_vcpu;
+	u8 vpe_id_bits;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		value =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, irs->idr0.domain);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_PA_RANGE, irs->idr0.pa_range);
+		if (irs->idr0.virt)
+			value |=3D GICV5_IRS_IDR0_VIRT;
+		if (irs->idr0.setlpi)
+			value |=3D GICV5_IRS_IDR0_SETLPI;
+		if (irs->idr0.mec)
+			value |=3D GICV5_IRS_IDR0_MEC;
+		if (irs->idr0.mpam)
+			value |=3D GICV5_IRS_IDR0_MPAM;
+		if (irs->idr0.swe)
+			value |=3D GICV5_IRS_IDR0_SWE;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_IRSID, irs->idr0.irs_id);
+		break;
+	case GICV5_IRS_IDR1:
+		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
+				   atomic_read(&vcpu->kvm->online_vcpus));
+		/*
+		 * IRS_IDR1 encodes IAFFID_BITS as N - 1.
+		 */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority_b=
its);
+		break;
+	case GICV5_IRS_IDR2:
+		value =3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD_SZ, irs->idr2.istmd_sz);
+		if (irs->idr2.istmd)
+			value |=3D GICV5_IRS_IDR2_ISTMD;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_L2SZ, irs->idr2.ist_l2sz);
+		if (irs->idr2.ist_levels)
+			value |=3D GICV5_IRS_IDR2_IST_LEVELS;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, irs->idr2.min_lpi_=
id_bits);
+		value |=3D GICV5_IRS_IDR2_LPI;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ID_BITS, irs->idr2.id_bits);
+		break;
+	case GICV5_IRS_IDR5:
+		value =3D FIELD_PREP(GICV5_IRS_IDR5_SPI_RANGE, irs->idr5.spi_range);
+		break;
+	case GICV5_IRS_IDR6:
+		value =3D FIELD_PREP(GICV5_IRS_IDR6_SPI_IRS_RANGE, irs->idr6.spi_irs_ran=
ge);
+		break;
+	case GICV5_IRS_IDR7:
+		value =3D FIELD_PREP(GICV5_IRS_IDR7_SPI_BASE, irs->idr7.spi_base);
+		break;
+	case GICV5_IRS_IIDR:
+		/* Revision, Variant, ProductID are implementation defined */
+		value =3D FIELD_PREP(GICV5_IRS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_VARIANT, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_REVISION, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_IMPLEMENTER, IMPLEMENTER_ARM);
+		break;
+	case GICV5_IRS_AIDR:
+		value =3D FIELD_PREP(GICV5_IRS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_IRS);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_IRS_CR0:
+		/*
+		 * The IRS is ALWAYS idle as we handle things instantaneously
+		 * from a guest's viewpoint.
+		 */
+		value =3D GICV5_IRS_CR0_IDLE;
+		if (READ_ONCE(vcpu->kvm->arch.vgic.enabled))
+			value |=3D GICV5_IRS_CR0_IRSEN;
+		break;
+	case GICV5_IRS_CR1:
+		if (irs->cr1.vped_wa)
+			value |=3D GICV5_IRS_CR1_VPED_WA;
+		if (irs->cr1.vped_ra)
+			value |=3D GICV5_IRS_CR1_VPED_RA;
+		if (irs->cr1.vmd_wa)
+			value |=3D GICV5_IRS_CR1_VMD_WA;
+		if (irs->cr1.vmd_ra)
+			value |=3D GICV5_IRS_CR1_VMD_RA;
+		if (irs->cr1.vpet_ra)
+			value |=3D GICV5_IRS_CR1_VPET_RA;
+		if (irs->cr1.vmt_ra)
+			value |=3D GICV5_IRS_CR1_VMT_RA;
+		if (irs->cr1.ist_wa)
+			value |=3D GICV5_IRS_CR1_IST_WA;
+		if (irs->cr1.ist_ra)
+			value |=3D GICV5_IRS_CR1_IST_RA;
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IC, irs->cr1.ic);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_OC, irs->cr1.oc);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_SH, irs->cr1.sh);
+		break;
+	case GICV5_IRS_SYNC_STATUSR:
+		value =3D GICV5_IRS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_IRS_PE_SELR:
+		value =3D FIELD_PREP(GICV5_IRS_PE_SELR_IAFFID,
+				   READ_ONCE(irs->pe_selr.iaffid));
+		break;
+	case GICV5_IRS_PE_STATUSR:
+		/* We assume that the PE is Online if present. Always IDLE too */
+		value =3D GICV5_IRS_PE_STATUSR_IDLE;
+
+		/* Set ONLINE and V if IAFFID selects a present PE */
+		if (kvm_get_vcpu_by_id(vcpu->kvm,
+				       READ_ONCE(irs->pe_selr.iaffid))) {
+			value |=3D GICV5_IRS_PE_STATUSR_ONLINE;
+			value |=3D GICV5_IRS_PE_STATUSR_V;
+		}
+		break;
+	case GICV5_IRS_PE_CR0: {
+		u32 iaffid =3D READ_ONCE(irs->pe_selr.iaffid);
+
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, iaffid);
+		if (!target_vcpu) {
+			kvm_debug("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\=
n",
+				  iaffid);
+			break;
+		}
+
+		value =3D GICV5_IRS_PE_CR0_DPS;
+		break;
+	}
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_IRS_CR0:
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
+			bool was_enabled =3D vgic->enabled;
+
+			WRITE_ONCE(vgic->enabled, !!(val & GICV5_IRS_CR0_IRSEN));
+
+			/* Reload other vCPUs on an edge */
+			if (was_enabled !=3D !!(val & GICV5_IRS_CR0_IRSEN))
+				kvm_make_all_cpus_request(vcpu->kvm,
+							  KVM_REQ_RELOAD_GICv5);
+		}
+		return;
+	case GICV5_IRS_CR1:
+		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
+		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
+		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
+		irs->cr1.ist_ra =3D !!(val & GICV5_IRS_CR1_IST_RA);
+		irs->cr1.ist_wa =3D !!(val & GICV5_IRS_CR1_IST_WA);
+		irs->cr1.vmt_ra =3D !!(val & GICV5_IRS_CR1_VMT_RA);
+		irs->cr1.vpet_ra =3D !!(val & GICV5_IRS_CR1_VPET_RA);
+		irs->cr1.vmd_ra =3D !!(val & GICV5_IRS_CR1_VMD_RA);
+		irs->cr1.vmd_wa =3D !!(val & GICV5_IRS_CR1_VMD_WA);
+		irs->cr1.vped_ra =3D !!(val & GICV5_IRS_CR1_VPED_RA);
+		irs->cr1.vped_wa =3D !!(val & GICV5_IRS_CR1_VPED_WA);
+		return;
+	case GICV5_IRS_PE_SELR:
+		WRITE_ONCE(irs->pe_selr.iaffid,
+			   FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val));
+		return;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * We actually have nothing to do here as we don't support
+		 * 1-of-N routing. The only thing that the guest can correctly
+		 * write here is 0x1. However, there's no way to fault if it
+		 * writes something else. This is effectively a WI in our case,
+		 * but we keep it here for the purposes of documenting it.
+		 */
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_is_spi_selr_valid(struct vgic_v5_irs *irs, u32 id)
+{
+	/* Invalid - we don't have any SPIs at all */
+	if (irs->idr5.spi_range =3D=3D 0)
+		return false;
+
+	/* Invalid - we don't have any on this IRS */
+	if (irs->idr6.spi_irs_range =3D=3D 0)
+		return false;
+
+	/* Invalid - ID is less than min */
+	if (id < irs->idr7.spi_base)
+		return false;
+
+	/* Invalid - ID is greater than max */
+	if (id >=3D (irs->idr7.spi_base + irs->idr6.spi_irs_range))
+		return false;
+
+	return true;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_spi(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		/* Return whatever was last written */
+		value =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, READ_ONCE(irs->spi_selr.id))=
;
+		break;
+	case GICV5_IRS_SPI_STATUSR:
+		/* We assume that we can always claim to be idle */
+		value =3D GICV5_IRS_SPI_STATUSR_IDLE;
+		if (vgic_v5_is_spi_selr_valid(irs, READ_ONCE(irs->spi_selr.id)))
+			value |=3D GICV5_IRS_SPI_STATUSR_V;
+		break;
+	case GICV5_IRS_SPI_DOMAINR:
+		value =3D FIELD_PREP(GICV5_IRS_SPI_DOMAINR_DOMAIN,
+				   GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE);
+		break;
+	case GICV5_IRS_SPI_CFGR: {
+		u32 id =3D READ_ONCE(irs->spi_selr.id);
+
+		if (!vgic_v5_is_spi_selr_valid(irs, id)) {
+			/* Fault with IRS_SPI_SELR; return 0*/
+			value =3D 0;
+			break;
+		}
+
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(id));
+		if (!irq) {
+			kvm_debug_ratelimited("Guest trying to access SPI not backed by KVM\n")=
;
+			value =3D 0;
+			break;
+		}
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				value =3D GICV5_IRS_SPI_CFGR_TM;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		break;
+	}
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		WRITE_ONCE(irs->spi_selr.id,
+			   FIELD_GET(GICV5_IRS_SPI_SELR_ID, val));
+		return;
+	case GICV5_IRS_SPI_CFGR: {
+		u32 id =3D READ_ONCE(irs->spi_selr.id);
+
+		if (!vgic_v5_is_spi_selr_valid(irs, id))
+			return;
+
+		/*
+		 * Find KVM's representation of the interrupt - we need to make
+		 * sure that KVM's view agrees with the guest's, else interrupt
+		 * injection won't work properly for level-triggered interrupts
+		 * (we fail to handle the clearing of the pending state if KVM
+		 * thinks that the interrupt is edge-triggered, which is the
+		 * default.)
+		 */
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(id));
+		if (!irq)
+			return;
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (val & GICV5_IRS_SPI_CFGR_TM)
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			else
+				irq->config =3D VGIC_CONFIG_EDGE;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs *irs)
+{
+	unsigned int expected_istsz;
+
+	if (irs->ist_cfgr.lpi_id_bits < irs->idr2.min_lpi_id_bits ||
+	    irs->ist_cfgr.lpi_id_bits > irs->idr2.id_bits)
+		return false;
+
+	if (!irs->idr2.istmd)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+	else if (irs->ist_cfgr.lpi_id_bits >=3D irs->idr2.istmd_sz)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+	else
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+
+	if (irs->ist_cfgr.istsz !=3D expected_istsz)
+		return false;
+
+	if (irs->ist_cfgr.structure && !irs->idr2.ist_levels)
+		return false;
+
+	if (!irs->ist_cfgr.structure)
+		return true;
+
+	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
+}
+
+static u64 vgic_v5_read_irs_ist_baser(struct vgic_v5_irs *irs)
+{
+	u64 value;
+
+	value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	if (irs->ist_baser.valid)
+		value |=3D GICV5_IRS_IST_BASER_VALID;
+
+	return value;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	case GICV5_IRS_IST_CFGR:
+		if (irs->ist_cfgr.structure)
+			value |=3D GICV5_IRS_IST_CFGR_STRUCTURE;
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, irs->ist_cfgr.istsz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_L2SZ, irs->ist_cfgr.l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, irs->ist_cfgr.lpi_=
id_bits);
+		break;
+	case GICV5_IRS_IST_BASER:
+	case GICV5_IRS_IST_BASER + 4:
+		value =3D vgic_v5_read_irs_ist_baser(irs);
+		return extract_bytes(value, offset & 7, len);
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+
+	switch (offset) {
+	case GICV5_IRS_IST_CFGR:
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
+			if (irs->ist_baser.valid)
+				return;
+
+			irs->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS,=
 val);
+			irs->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+			irs->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+			irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		}
+		return;
+	case GICV5_IRS_IST_BASER:
+	case GICV5_IRS_IST_BASER + 4: {
+		u64 baser;
+		bool valid;
+
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+		baser =3D update_64bit_reg(vgic_v5_read_irs_ist_baser(irs),
+					 offset & 4, len, val);
+		valid =3D !!(baser & GICV5_IRS_IST_BASER_VALID);
+
+		/* The address cannot be changed while the IST is valid. */
+		if (irs->ist_baser.valid && valid)
+			return;
+
+		/* Valid -> Invalid */
+		if (irs->ist_baser.valid && !valid) {
+			/* Make the LPI IST invalid and then ... */
+			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
+				break;
+
+			/*
+			 * ... free the host IST if we successfully marked the
+			 * IST as invalid. Frankly, if we failed to make the
+			 * guest's IST as invalid, we're cooked because it means
+			 * that the IRS may still be using the memory that we
+			 * want to free. Hence, we leave it allocated and skip
+			 * the clearing of valid bit in the baser.
+			 */
+			vgic_v5_lpi_ist_free(vcpu->kvm);
+		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+			if (!vgic_v5_ist_cfgr_valid(irs))
+				break;
+
+			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
+				break;
+		}
+
+		/* Now that we've handled the edges, update the valid bit and addr */
+		irs->ist_baser.valid =3D valid;
+		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, baser)
+			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
+	/*
+	 * This is the IRS_CONFIG_FRAME.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
+				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
+				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/*
+	 * The following registers are only for running VMs. They are not yet
+	 * supported as we don't currently support nested, so expose them as
+	 * read-as-zero/write-ignored.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_BASER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_CFGR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_HPPIR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_CR0, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VMTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VPER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/* MEC, MPAM, SWERR - all unimplemented */
+
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_MECID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_PARTID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER0,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+};
+
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
+{
+	dev->regions =3D vgic_v5_irs_registers;
+	dev->nr_regions =3D ARRAY_SIZE(vgic_v5_irs_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	/* We represent both of the IRS frames back to back, so this is 128K */
+	return KVM_VGIC_V5_IRS_SIZE;
+}
+
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address)
+{
+	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->io=
dev;
+	unsigned int len;
+
+	/*
+	 * Design choice: Force MMIO region to be 64k aligned. Simplifies
+	 * pulling out registers.
+	 */
+	if (!IS_ALIGNED(irs_base_address, SZ_64K))
+		return -EINVAL;
+
+	len =3D vgic_v5_init_irs_iodev(io_device);
+
+	io_device->base_addr =3D irs_base_address;
+	io_device->iodev_type =3D IODEV_GICV5_IRS;
+	io_device->redist_vcpu =3D NULL;
+
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, irs_base_address, len,
+				       &io_device->dev);
+}
+
+/**
+ * kvm_vgic_v5_irs_init: initialize the IRS data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	size_t nr_spi_bits;
+	u64 mmfr0;
+	int ret, i;
+
+	/*
+	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
+	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
+	 * is 4 bytes in size (or larger if metadata storage is required), so 16
+	 * entries would be enough for alignment. We require userspace to
+	 * provide at least 32 SPIs, so we always meet alignment requirements.
+	 */
+	if (nr_spis) {
+		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
+				     GFP_KERNEL_ACCOUNT);
+		if (!dist->spis)
+			return -ENOMEM;
+
+		/*
+		 * In the following code we do not take the irq struct lock since
+		 * no other action on irq structs can happen while the VGIC is
+		 * not initialized yet.
+		 */
+		for (i =3D 0; i < nr_spis; i++) {
+			struct vgic_irq *irq =3D &dist->spis[i];
+
+			irq->intid =3D vgic_v5_make_spi(i);
+			INIT_LIST_HEAD(&irq->ap_list);
+			raw_spin_lock_init(&irq->irq_lock);
+			irq->vcpu =3D NULL;
+			irq->target_vcpu =3D vcpu0;
+			refcount_set(&irq->refcount, 0);
+			/*
+			 * The guest controls the enable state, and again it is
+			 * directly handled by the hardware. From our point of
+			 * view it is always enabled.
+			 */
+			irq->enabled =3D 1;
+		}
+
+		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
+
+		ret =3D vgic_v5_spi_ist_alloc(kvm, nr_spi_bits);
+		if (ret) {
+			kfree(dist->spis);
+			dist->spis =3D NULL;
+			return ret;
+		}
+	}
+
+	/* Set sane initial state for the IRS MMIO registers */
+
+	irs->idr0.domain =3D GICV5_IRS_IDR0_INT_DOM_NON_SECURE;
+
+	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	irs->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(mmfr0,
+								  ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	irs->idr0.virt =3D 0;
+	irs->idr0.setlpi =3D 0;
+	irs->idr0.mec =3D 0;
+	irs->idr0.mpam =3D 0;
+	irs->idr0.swe =3D 0;
+	irs->idr0.irs_id =3D 0;
+
+	irs->idr1.priority_bits =3D gicv5_global_data.irs_pri_bits - 1;
+
+	/*
+	 * Support 16-bits of ID space for the IRS. This should be sufficient
+	 * for most applications, and the CPUIF is guaranteed to have at least
+	 * 16-bits of ID space support (we actually present 16-bits there, even
+	 * if the hardware supports more). Warn if the hardware doesn't support
+	 * 16 bits, and use the smaller value. YMMV!
+	 *
+	 * As for the minimum number of ID bits, we match the hardware's
+	 * capability.
+	 */
+	if (vgic_v5_irs_ist_id_bits(&irs_caps) < 16)
+		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
+			vgic_v5_irs_ist_id_bits(&irs_caps));
+
+	irs->idr2.id_bits =3D min(16, vgic_v5_irs_ist_id_bits(&irs_caps));
+	irs->idr2.min_lpi_id_bits =3D vgic_v5_irs_min_lpi_id_bits(&irs_caps);
+
+	/* Only allow the guest to create Linear ISTs - simplifies Save/Restore *=
/
+	irs->idr2.ist_levels =3D 0;
+	irs->idr2.ist_l2sz =3D GICV5_IRS_IST_CFGR_L2SZ_4K;
+	irs->idr2.istmd =3D 0;
+	irs->idr2.istmd_sz =3D 0;
+
+	/* We have a single IRS, only. All SPIs reside here! */
+	irs->idr5.spi_range =3D nr_spis;
+	irs->idr6.spi_irs_range =3D nr_spis;
+	irs->idr7.spi_base =3D 0;
+
+	irs->cr1.sh =3D 0;
+	irs->cr1.oc =3D 0;
+	irs->cr1.ic =3D 0;
+	irs->cr1.ist_ra =3D 0;
+	irs->cr1.ist_wa =3D 0;
+	irs->cr1.vmt_ra =3D 0;
+	irs->cr1.vpet_ra =3D 0;
+	irs->cr1.vmd_ra =3D 0;
+	irs->cr1.vmd_wa =3D 0;
+	irs->cr1.vped_ra =3D 0;
+	irs->cr1.vped_wa =3D 0;
+
+	irs->spi_selr.id =3D -1;
+
+	irs->pe_selr.iaffid =3D -1;
+
+	irs->ist_cfgr.lpi_id_bits =3D 0;
+	irs->ist_cfgr.l2sz =3D 0;
+	irs->ist_cfgr.istsz =3D 0;
+	irs->ist_cfgr.structure =3D 0;
+
+	irs->ist_baser.valid =3D 0;
+	irs->ist_baser.addr =3D 0;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index c028c4fb95e01..c1c43be0add2c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -642,6 +642,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * Provide a way for the IRS MMIO emulation to correctly populate the numb=
er of
+ * IAFFID bits (which correspond to our vpe_id_bits.
+ */
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return 0;
+
+	return vmi->vpe_id_bits;
+}
+
 /* Provide the preallocated VPE descriptor to the hardware via the VPE Tab=
le. */
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 38b6f5269a2aa..e28d39d59f7fb 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -113,6 +113,7 @@ void vgic_v5_release_vm_id(struct kvm *kvm);
=20
 int vgic_v5_vmte_init(struct kvm *kvm);
 int vgic_v5_vmte_release(struct kvm *kvm);
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 42cb205554daa..da682092c658e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -383,6 +383,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
@@ -395,6 +396,7 @@ void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgi=
c_vmcr *vmcr);
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d894c32d09295..ecb0e3526d311 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -40,6 +40,7 @@
  * in KVM for now. At a future stage, this can be bumped up to 128, if req=
uired.
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
+#define VGIC_V5_DEFAULT_NR_SPIS	32
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
