Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011015.outbound.protection.outlook.com [40.107.130.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4485E312831
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375208; cv=fail; b=DUabOe64HkC5oCOsJNaXaEgCkh6QRC+vNz/JY6zIw0pd93DFLMh7ElSyiWf56fRAIiEiDfmEklfTltHs7ev+LAMISY3aT6WmEn0X1aO/qsRTQXzbR8iTAjCDKzYElI/jXiRMdGnw3l5JKGg+EnyQaBVu4HkvNZ66TvYCTD0e2LE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375208; c=relaxed/simple;
	bh=pdOMKxxfaCDVqyD62Rrj2HTdIGlzrWQdZgaNce3Yl5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N/shgl6ULFiUM2fllmPyHGXJZkuRj8yEXTBgvcwDS5CdWy1XinpQ+1DcCUmThtkdDbS8o6rYTDn6F+g45mo+SeCIzZP4Tmn32391FeJGzK3btH8qjBzWqOiQ3jhhoZX3Hg8mWZfkW4S1lm5XxHKRflc7WDAahwKyRRR/rNJHh28=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fe3fMOjr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fe3fMOjr; arc=fail smtp.client-ip=40.107.130.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fe3fMOjr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fe3fMOjr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=Llu6nGJWFBrQm6QcDMqRXedDLBTGPT67YpG0cuxv/WtZ8K6YDoDVh1Fino2KBdz52NyiTsxt3wlp1741DHw0mOQ/+p+qn44fGS0koAV9tQX6qLUrq8lIcng13g3yrDJzNOfy3Lk65ChuzjZEL4HAdv4GLems7MFoCNnkZ2J9whtoGCvo+vx/X24MhW1j67++yOe8TwHDRctny1vtJzRkbMBZ59BHmzon4VDJxIXnMM+A9fep2L5BBMRAfCF9MhuqAtVzcufZUFFwiHrdSXFrZDlh6ogGsQjRdHCa+Y4SLRDsP7YREXVJtraBcG3kfk+xhSZVtFwG5SGtGVGChznZaw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBN+og0r+3RJ3LMGlhEHRF6+YXlNS+QqlddQW44TPe8=;
 b=NUfkPbz1aVIIp9hkW1yG+gWo10yXuy5PcJXw/S6uCT6akIFp2cH0RNkd/w4zbeS5B2QmGObDc3B4HJYyz630Mu6qdn3nqTIr6WfpjrVr46aIvpkDaXtBvMFxrvZ8ELKpeWwqf6cVvTZLmrkLPw1/9m8M2WUYqE3vcyMK+TQ/j9eSQMqSJlMw/LDuDnUuSAQfyzxcuxHeurtKd+knBfnro7KK/gcAZnXYL4kkFZ5r7ZEs3odmylA9NNiAQlt/q3aq9h9DlTrpQbxUJbypJkulo9DX35fMLyfs+hAYhbYm8//7qws+FkF/rzcep3ZDVJkcrAWaigV7IHq3AyLpiqifrg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBN+og0r+3RJ3LMGlhEHRF6+YXlNS+QqlddQW44TPe8=;
 b=Fe3fMOjrg9eeU8V6vByuDpIpaGEa+l+IgQ3EbMtIwFjrWdgJiv5WJ3uRyTqk79lNPzVUQlMpGMmUZr2Db3jmDqC2uwoFdoag4v1AivztZ0Kve5P2UpYBzHisf/CadxO0p+oFcw/Fww8QretMdKb/9OOyhp7Xp/9UYM3/Cy1mKQA=
Received: from DU7P189CA0010.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:552::12)
 by AM8PR08MB6467.eurprd08.prod.outlook.com (2603:10a6:20b:316::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:53:18 +0000
Received: from DB1PEPF000509F5.eurprd02.prod.outlook.com
 (2603:10a6:10:552:cafe::38) by DU7P189CA0010.outlook.office365.com
 (2603:10a6:10:552::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:53:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F5.mail.protection.outlook.com (10.167.242.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:53:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+9IdBT3U6RQHYNSXE47eVXS/TbUgoUpUuGg03WMvVIjVV3KsIAKutQWm9uG5mo5R94Ocx35zIorWnUbGFi0FILfH0UCkUh+bVt07xDWNy2O9imvcxPP9aV8FlhakDN6o+AShO51JztuBj6e4/Q+Y+DL4hO/iW50XydSRvStv/jKA7InU0eSHHZxWyWWx788NZXOsvohHvrlVHf5q3htkiQloxx3NS0LYWu9e+yJWChNjDtYDRstnjxxycI/Q6MZh7QG1NAyYsYkOOBjGKctWG6sEUKmOWK5G+cCZnPDOtWcmB2+afbFaFdHTeezEdfz9DiQVGWwpeLs5l6uxpH/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBN+og0r+3RJ3LMGlhEHRF6+YXlNS+QqlddQW44TPe8=;
 b=iQScBaI8CiWagexDq9uMAuyh653wgjK6EFNlnSTe1sNW+ELHHhN6kFVIp0W+BYry3MBwskRlEbH2v+5n4r/GPHh4H+PkBx7wyclrME0n1vwYQAa2CVqRuszqDVNuj7aZl34+qogeq8nl+7CIjkfJoxWdDunqXgjuZHsh2d1ln682YFFCoCp86mR3E6V0vQKJtWG2xMN8b4iuw8FcCjExfTz4BqjXsWs286hq/4jXVsKbPYEEzaPlw47Tpaqs/BxlG2hqNQ23UDCfkHmiJ6A26IK1MijmYsFpcuP80cenqtyhcQVyc8BfhwyrYqIRzxpbMJ6/BPGC4FFd63ptcawGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBN+og0r+3RJ3LMGlhEHRF6+YXlNS+QqlddQW44TPe8=;
 b=Fe3fMOjrg9eeU8V6vByuDpIpaGEa+l+IgQ3EbMtIwFjrWdgJiv5WJ3uRyTqk79lNPzVUQlMpGMmUZr2Db3jmDqC2uwoFdoag4v1AivztZ0Kve5P2UpYBzHisf/CadxO0p+oFcw/Fww8QretMdKb/9OOyhp7Xp/9UYM3/Cy1mKQA=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:52:14 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:52:13 +0000
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
Subject: [PATCH v2 09/39] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Thread-Topic: [PATCH v2 09/39] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Thread-Index: AQHc6TFoHafAWaq8RUiEn3Ve9445Yw==
Date: Thu, 21 May 2026 14:52:13 +0000
Message-ID: <20260521144846.1899475-10-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DB1PEPF000509F5:EE_|AM8PR08MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 6293a744-e636-43b7-57e9-08deb748b17c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 atiQWYwTNoBv1G172+njF1ljuinx8qSnyOYMmZpBSJGgg4DErgbh+wvb1lQ/7veFmsTjFRxZ1oBQrA9vZeWaioUBKD/A7MBVMQySFR/sbai2idFFFKGsn5T55jeu0dyJqlRN9LxdZFecoZYiAiSzVTppLgS1/x4eog+TD/uMfCXCnqoL7MObkOqoYJvM38xodmxu+hWu4xO8OhSXTnOTPItDvJHuAVZLuFVnW4zu4DWj0bvwFnFQF7cpyiUs1DxGRyXRtQLhNeeB1AIfXv3sn+5e70d7d/5otwNOpUmVYP0/hOB+9ZW9vcWPDF0kpj4wEPZnjS90wLaq4f0Mf6iVWGlAjwp0E9b8pxJpWju/2VSavVUIxNfkEaWsq2S3D/HpYIsBc1a02wDYQ7aAI1ciPp1FJhXHaGYA2K7huWJElPJ76ZiWphaOKTOjHvc1xq1qYucKHq7RmsmyoDoY47maelsnJXlWafShLLQstocfgdLAEz9VA/5pbXWJIA7rPUQEmcYPR8jIChWHY25IWOo8Ja5qttGoyNs2Ean1cVyczz49YQTAXSVF/FAOGV0OASz8rW/0tfgvBbp5mxHMmtjNLdifMI1T1KgLHOzhjt5jiyD0tsbwxoSJ4BW2YJ8ZRfZjL9CPequBvpHx3IvdRpDXgn2kTrNDOB16XhavdWGMDb4/OWvVUhQGyahyvJb3t21WYh0vXFreGRqF9wEx71TrKUcfE7ecCcjLJzCUpIXp9HCJAysKhqHm9jacxJRHY6Qn
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(3023799007)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 q4iYQQZccb7LBhfa3tPRl6gutG2AvlkwhRBnB1uH4PR9rq1s65y1NbuFOa30cT5N/gaxaVmnIF4PrSg4wJMoQ59IEirO0Anu7CYaU65KTb/ttz32aFKxmC8SIxO/ojcLkgv+aR+A/OJXVo553Oa/jVdSJK3pm/wr5DNWJ/a9EUipRfJS2FRUh+cPUjqdvU4TUraACN334voK4F5zxSd9CRnYiYOi8spQTQUVywzeirWo03SptsEOkSyV47TSObBsY+45zdKM39RzCBHU9L/40eXbv2ipBiLPpK7x9VCtYXjy2AbFFgDjuy3m3oQ3ynGKwhC0mrG8JUA5qozkKAFNzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bbf43773-8ba6-43ae-5afb-08deb7488b0f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700016|1800799024|35042699022|82310400026|18002099003|22082099003|56012099003|11063799006|5023799004|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	ftnrp9p3uV/2PUug4tqosqicx2A/FKy9JMsyPBRUNp8MACmnLIIT/acDdvlZ92XVmo96Yhl7w/KXaZ7CmIQ0eB4cW0r7x3l0+37Vah4wiX8Iypxp+VNScKodo9TR54ZgT6JO7K2QTHUxjrovd9c6w1kHFnK+Bd0rBgQx66KVrBZoCNTvSTgsBNCNrhO3C9axa92697+yJrzQk3JGM5zY4bVbqR5YYgg2MCgDfBXWe3zOVF38rvJDlyEqK5VoCbdWVtrQonTPqIeWGEBXxS4Z6KY8tsEGuZ/khG/MDKwqwHDpvA/2f7NQPcHJzgnsoGLK2g4oqVIK1ubbmv8fMzGU9KcTuTS6neAIkJ8zD0ObIRav3zDEbqakvzgx8ezyKQiJdLyYyuV78KgtnRZVxmvtwO4Qga26QbxOYb1Hud8KM5pwG14juoBh/6jY/oWPWbojjJaWsgmzBMEtd1NQYSta9NBUoCq2Ux66+4ILWDAINOPUwjFQBoJlfHDCkIrh55W2QK8fmOZxOgxRYBuvIAP9k+Om1mGjYKhDzrk4fn3e1jMGi9LC0hxf9dggLyJen+dY5x3KLVN1HItJPF82OHkEIONRGR5QxTGv32ifi9d6YpQDKChAJzpgIvSzwHFLReDk+4vAqvycQ8sxI4Y3q1HHZ3Lo0DbQftCKxpsKwQOPkIG0JlN4iYExkHT2KaATyq7/go1ah53eUdexwy9/NNo0in82gDmkqW5vNWk/tMC+O2M=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700016)(1800799024)(35042699022)(82310400026)(18002099003)(22082099003)(56012099003)(11063799006)(5023799004)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zHdVW9Zjed/HLttiqXByBeZE7f59UeSNtHM3aUpm1+mJY4SfwQ93PB6hPvy1/yqEdTYjS1tKSu/FnopWG3KtO8ULGPiBeCI8AMphEkUKJbINKW3x/Uzg1b1Fr23AuSeLK3ZUgmjJC+xMmWcUmFQZ3pFFUgBi9sd2h5LEM4OLIxQ2UNygosU4VVH7n6P7zEY/dpZFpKYoE8iyY3tKobsUpwZxuIZiH1YPDE24z6hP6UBxAMcGK/HkDtZzp2G5uBngUER+2mHx8hQxzh9mDbNLA7Mc3zU13bW/iuZ7hINjl+IP7Th1+5Ba2vEX1bEQNDVyG8v+HyJ423WCHSZytC59P3seE1GIC2RZzKN2sdD2iiJXeQNL+JkQgA9DdFKnrv5ugQvLp1C3adk1QN8WkGPHPq5n7SeoIfn2hXFWC6BVdyGngRZnY8wTjH4M0i0VFWda
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:53:17.5324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6293a744-e636-43b7-57e9-08deb748b17c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6467

GICv5 uses a set of in-memory tables to track and manage VM
state. These must be allocated by the hypervisor, and provided to the
IRS to use.

The VMT (Virtual Machine Table) is a linear or two level table
comprising VMT Entries (VMTE). Each VMTE describes the state for a
single VM. This state includes things such as the SPI and LPI IST
configuration (coming in a future commit), an implementation-defined
VM Descriptor, and a VPE Table (VPET).

The VPET contains one entry per VPE belonging to a VM, and is used to
mark a VPE as valid, as well as providing the address of an
implementation-defined VPE Descriptor, which is used by the hardware
to track and manage VPE state.

This commit adds support for allocating the VMT, and managing the
VMTEs. The VMTEs can be initialised or released for re-use. Allocation
and tracking of unused VMTEs is handled with an IDA.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c      |   2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 625 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  76 ++++
 arch/arm64/kvm/vgic/vgic-v5.c        |  15 +
 drivers/irqchip/irq-gic-v5-irs.c     |  12 +-
 include/kvm/arm_vgic.h               |   4 +
 include/linux/irqchip/arm-gic-v5.h   |  14 +-
 8 files changed, 740 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..431de9b145ca1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 625d352756fcf..079a57c2b18f6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -154,6 +154,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
 	}
=20
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
new file mode 100644
index 0000000000000..e9b92893b4e1f
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -0,0 +1,625 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#include <kvm/arm_vgic.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_v5_vmt *vmt_info;
+/* Serialises lazy installation of shared second-level VMTs. */
+static DEFINE_MUTEX(vmt_l2_lock);
+static DEFINE_XARRAY(vm_info);
+
+/* Level 1 Virtual Machine Table Entry */
+#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
+/* Note that there is no shift for the address by design */
+#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
+
+#define GICV5_VMTEL2E_SIZE		32ULL
+/* An L2 table (two-level VMT) is ALWAYS 4kB! */
+#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
+#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2=
E_SIZE)
+
+/*
+ * As the L2 VMTE is a large data structure, we are splitting it into 4 pa=
rts.
+ * We only mask and shift WITHIN each part for simplicity.
+ */
+/* First 64-bit chunk */
+#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
+/* Second 64-bit chunk */
+#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
+#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
+/* Third & fourth 64-bit chunks (the encodings are the same for each) */
+#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
+#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
+#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
+#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
+#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
+
+/* Virtual PE Table Entry */
+#define GICV5_VPE_VALID			BIT_ULL(0)
+/* Note that there is no shift for the address by design. */
+#define GICV5_VPED_ADDR_SHIFT		3ULL
+#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
+
+/*
+ * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
+ * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
+ * manage our cached data explicitly.
+ *
+ * This helper is used to handle both coherent and non-coherent IRSes, and
+ * handles all combinations of cleaning and invalidating to the PoC.
+ */
+static void vgic_v5_clean_inval(void *va, size_t size)
+{
+	unsigned long base =3D (unsigned long)va;
+
+	dsb(ishst);
+
+	if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
+		dcache_clean_inval_poc(base, base + size);
+}
+
+/*
+ * Create a linear VM Table. Directly using the number of entries supplied=
 as
+ * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
+ * the GICv5 requirements for the IRS_VMT_BASER.
+ */
+static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
+{
+	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
+						 num_entries);
+	if (!vmt_info->linear.vmt_base)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->linear.vmt_base,
+			    num_entries * sizeof(struct vmtl2_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level VM table. The second-level VM t=
ables
+ * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
+ */
+static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
+{
+	/*
+	 * Each L2 VMT array is always 4k-sized (covering 128 VMs). This is
+	 * mandated by the GICv5 specification (GICv5 EAC0 Specification rule
+	 * D_LSPBK). Hence, round up the number of entries to be at least 128
+	 * (or the next highest power of two as we give the HW the number of VM
+	 * ID bits).
+	 */
+	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
+		num_entries =3D GICV5_VMT_L2_TABLE_ENTRIES;
+	num_entries =3D roundup_pow_of_two(num_entries);
+
+	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
+	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
+					     vmt_info->l2.num_l1_ents);
+	if (!vmt_info->l2.vmt_base)
+		return -ENOMEM;
+
+	vmt_info->l2.l2ptrs =3D kzalloc_objs(*vmt_info->l2.l2ptrs,
+					   vmt_info->l2.num_l1_ents,
+					   GFP_KERNEL);
+	if (!vmt_info->l2.l2ptrs) {
+		kfree(vmt_info->l2.vmt_base);
+		return -ENOMEM;
+	}
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base,
+			    vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate a second level VMT, if required. This can be called eagerly, a=
nd
+ * will only perform the allocation if required.
+ */
+static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd =3D VMT_L2_MAP;
+	struct vmtl2_entry *l2_table;
+	unsigned int l1_index;
+	int ret;
+
+	/* Nothing to do if we have linear tables! */
+	if (!vmt_info->two_level)
+		return 0;
+
+	/*
+	 * We have 4k-sized L2 tables - this is mandated by the spec for
+	 * two-level VMTs (GICv5 EAC0 Specification rule D_LSPBK). This means
+	 * that we have 128 entries per L1 VMTE.
+	 */
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+
+	guard(mutex)(&vmt_l2_lock);
+
+	/* Already valid? Great! */
+	if (vmt_info->l2.l2ptrs[l1_index])
+		return 0;
+
+	l2_table =3D kzalloc_objs(*l2_table, GICV5_VMT_L2_TABLE_ENTRIES);
+	if (!l2_table)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE);
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry));
+
+	WRITE_ONCE(vmt_info->l2.vmt_base[l1_index],
+		   cpu_to_le64(virt_to_phys(l2_table)));
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry));
+
+	/*
+	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
+	 * conduit for interacting with the host's IRS. In the current case,
+	 * this lets us resolve the VM ID to pass to the hardware.
+	 */
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	/* We've failed to make the L2 VMT valid - things are very broken! */
+	if (ret) {
+		/* Remove the pointer from L1 table */
+		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
+
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+		kfree(l2_table);
+
+		return ret;
+	}
+
+	vmt_info->l2.l2ptrs[l1_index] =3D l2_table;
+
+	return 0;
+}
+
+/*
+ * Allocate the top-level VMT. This can either be linear or two-level.
+ */
+int vgic_v5_vmt_allocate(unsigned int max_vpes)
+{
+	int ret;
+
+	/* Allocate the tracking structure */
+	vmt_info =3D kzalloc_obj(*vmt_info, GFP_KERNEL);
+	if (!vmt_info)
+		return -ENOMEM;
+
+	ida_init(&vmt_info->vm_id_ida);
+	vmt_info->max_vpes =3D max_vpes;
+	vmt_info->vmd_size =3D irs_caps.vmd_size;
+	vmt_info->vped_size =3D irs_caps.vped_size;
+	vmt_info->two_level =3D irs_caps.two_level_vmt_support;
+	vmt_info->num_entries =3D irs_caps.max_vms;
+
+	if (vmt_info->two_level)
+		ret =3D vgic_v5_alloc_vmt_two_level(vmt_info->num_entries);
+	else
+		ret =3D vgic_v5_alloc_vmt_linear(vmt_info->num_entries);
+
+	/* If anything failed, free our tracking structure before returning */
+	if (ret) {
+		kfree(vmt_info);
+		vmt_info =3D NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * Free the VMT and associated tracking structures. This isn't strictly ex=
pected
+ * to be called in general operation, but instead exists for completeness.
+ */
+int vgic_v5_vmt_free(void)
+{
+	if (!vmt_info)
+		return 0;
+
+	if (!vmt_info->two_level) {
+		kfree(vmt_info->linear.vmt_base);
+	} else {
+		/* Free the L2 tables; kfree(NULL) is safe */
+		for (int i =3D 0; i < vmt_info->l2.num_l1_ents; ++i)
+			kfree(vmt_info->l2.l2ptrs[i]);
+		kfree(vmt_info->l2.l2ptrs);
+
+		/* And now free the L1 table */
+		kfree(vmt_info->l2.vmt_base);
+	}
+
+	ida_destroy(&vmt_info->vm_id_ida);
+	kfree(vmt_info);
+	vmt_info =3D NULL;
+
+	return 0;
+}
+
+/*
+ * Look up a VMT Entry by VM ID.
+ */
+static struct vmtl2_entry *vgic_v5_get_l2_vmte(u16 vm_id)
+{
+	unsigned int l1_index, l2_index;
+	struct vmtl2_entry *l2_table;
+
+	if (!vmt_info->two_level)
+		return &vmt_info->linear.vmt_base[vm_id];
+
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+	l2_index =3D vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
+
+	if (l1_index >=3D vmt_info->l2.num_l1_ents)
+		return ERR_PTR(-E2BIG);
+
+	if (!vmt_info->l2.l2ptrs[l1_index])
+		return ERR_PTR(-EINVAL);
+
+	l2_table =3D vmt_info->l2.l2ptrs[l1_index];
+	return &l2_table[l2_index];
+}
+
+/*
+ * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
+ */
+static int vgic_v5_reset_vmte(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/*
+	 * The VMT is normal memory shared with the IRS. Invalidate before
+	 * rewriting the entry so that cacheline-granular maintenance cannot
+	 * later push stale data for neighbouring IRS-visible state back to
+	 * memory.
+	 */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	/*
+	 * Prevent the compiler from eliding the individual VMTE
+	 * stores. Ordering and visibility to the IRS are provided by the
+	 * surrounding cache maintenance and command protocol, not by
+	 * WRITE_ONCE().
+	 *
+	 * The same compiler-access constraint applies to READ_ONCE() users in
+	 * this file: when inspecting IRS-visible table entries, read the field
+	 * exactly once and prevent the compiler from reusing, merging or
+	 * tearing the access. Coherency and freshness for non-coherent IRSes
+	 * still come from the surrounding cache maintenance.
+	 */
+	WRITE_ONCE(vmte->val[0], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[1], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[2], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[3], cpu_to_le64(0ULL));
+
+	/* And make our write visible to the IRS (if non-coherent) */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/*
+ * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
+ * structure. If we're out of VM IDs, the IDA catches that, and we return =
the
+ * error (-ENOSPC). If we've previously allocated a VM ID, we catch that t=
oo and
+ * return -EBUSY.
+ */
+int vgic_v5_allocate_vm_id(struct kvm *kvm)
+{
+	int id;
+
+	if (kvm->arch.vgic.gicv5_vm.vm_id !=3D VGIC_V5_VM_ID_INVAL)
+		return -EBUSY;
+
+	id =3D ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
+			   GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	kvm->arch.vgic.gicv5_vm.vm_id =3D id;
+
+	return 0;
+}
+
+/*
+ * Release the VM ID to allow it to be reallocated in the future.
+ */
+void vgic_v5_release_vm_id(struct kvm *kvm)
+{
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
+	kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
+}
+
+/*
+ * Initialise an entry in the VMT based on the index of the VM.
+ *
+ * Note: We don't mark the VMTE as valid as this needs to be done by
+ * the hardware.
+ */
+int vgic_v5_vmte_init(struct kvm *kvm)
+{
+	int nr_cpus =3D atomic_read(&kvm->online_vcpus);
+	struct vgic_v5_vm_info *vmi =3D NULL;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	void **vped_ptrs =3D NULL;
+	vpe_entry *vpet =3D NULL;
+	void *vmd =3D NULL;
+	int ret;
+	u64 tmp;
+
+	if (nr_cpus > vmt_info->max_vpes)
+		return -E2BIG;
+
+	/*
+	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
+	 * VMTs, this is a NOP.
+	 */
+	ret =3D vgic_v5_alloc_l2_vmt(kvm);
+	if (ret)
+		return ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* If the entry is already valid, something went wrong */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EINVAL;
+
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	vmi =3D kzalloc_obj(*vmi);
+	if (!vmi) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
+	if (ret)
+		goto out_fail;
+
+	/* Allocate and assign the VM Descriptor, if required. */
+	if (vmt_info->vmd_size !=3D 0) {
+		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
+		if (!vmd) {
+			ret =3D -ENOMEM;
+			goto out_fail;
+		}
+
+		/* Stash the VA so we can free it later */
+		vmi->vmd_base =3D vmd;
+
+		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
+				 virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(tmp));
+	}
+
+	/*
+	 * Allocate and assign the VPE Table. Round up the number of CPUs to a
+	 * whole power of two as we cannot describe non-powers-of-two in the
+	 * VMTE field as it conveys the number of ID bits used and not the
+	 * number of vPEs.
+	 *
+	 * The IRS encodes the number of IAFFID bits as N - 1, so a VM with a
+	 * single vCPU must still allocate two VPET entries and expose 1 bit.
+	 */
+	nr_cpus =3D max(2UL, roundup_pow_of_two(nr_cpus));
+	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
+
+	vpet =3D kzalloc_objs(*vpet, nr_cpus);
+	if (!vpet) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	/* Stash the VA so we can free it later */
+	vmi->vpet_base =3D vpet;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
+			 virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
+	WRITE_ONCE(vmte->val[1], cpu_to_le64(tmp));
+
+	vped_ptrs =3D kzalloc_objs(*vped_ptrs, nr_cpus, GFP_KERNEL);
+	if (!vped_ptrs) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+	vmi->vped_ptrs =3D vped_ptrs;
+
+	if (vmd)
+		vgic_v5_clean_inval(vmd, vmt_info->vmd_size);
+	vgic_v5_clean_inval(vpet, sizeof(*vpet) * nr_cpus);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D true;
+
+	return 0;
+
+out_fail:
+	/* kfree(NULL) is safe so we can just kfree() at leisure */
+	kfree(vmd);
+	kfree(vpet);
+	kfree(vped_ptrs);
+	if (vmi)
+		xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+	vgic_v5_reset_vmte(kvm);
+
+	return ret;
+}
+
+/*
+ * Release the VMT Entry, freeing up any allocated data structures before
+ * zeroing the VMTE.
+ *
+ * The VMTE must be marked as invalid before it is released.
+ */
+int vgic_v5_vmte_release(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Reject if the VMTE has not been marked as invalid! */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		goto no_vmi;
+
+	for (int i =3D 0; i < BIT(vmi->vpe_id_bits); i++)
+		kfree(vmi->vped_ptrs[i]);
+	kfree(vmi->vped_ptrs);
+	kfree(vmi->vpet_base);
+	kfree(vmi->vmd_base);
+
+	xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+no_vmi:
+	/*
+	 * If we didn't get far enough into allocating a VMTE to create the VM
+	 * info structure, then we just zero the VMTE and move on. There's
+	 * nothing else we can realistically do here.
+	 */
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D false;
+
+	return 0;
+}
+
+/*
+ * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
+ */
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	vpe_entry tmp, *vpet_base;
+	void *vped;
+
+	/* Make sure we're not over what the hardware supports */
+	if (vpe_id >=3D vmt_info->max_vpes)
+		return -E2BIG;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+
+	/* If the VPETE for this CPU is already valid we've gone wrong */
+	vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base));
+	if (le64_to_cpu(READ_ONCE(vpet_base[vpe_id])) & GICV5_VPE_VALID)
+		return -EBUSY;
+
+	/* Alloc VPE Descriptor. Only used by IRS. */
+	vped =3D kzalloc(vmt_info->vped_size, GFP_KERNEL);
+	if (!vped)
+		return -ENOMEM;
+
+	vmi->vped_ptrs[vpe_id] =3D vped;
+
+	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR=
_SHIFT);
+	WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+
+	vgic_v5_clean_inval(vped, vmt_info->vped_size);
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+
+	return 0;
+}
+
+/*
+ * Free the memory allocated for the VPE descriptor.
+ */
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet_base;
+	void *vped;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EBUSY;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+	WRITE_ONCE(vpet_base[vpe_id], 0ULL);
+
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+
+	/* Free VPE Descriptor. Only used by IRS. */
+	vped =3D vmi->vped_ptrs[vpe_id];
+	vmi->vped_ptrs[vpe_id] =3D NULL;
+	kfree(vped);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
new file mode 100644
index 0000000000000..3ca5bc7214fc9
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#ifndef __KVM_ARM_VGICV5_TABLES_H__
+#define __KVM_ARM_VGICV5_TABLES_H__
+
+#include <linux/idr.h>
+#include <linux/irqchip/arm-gic-v5.h>
+
+/* Level 1 Virtual Machine Table Entry */
+typedef __le64 vmtl1_entry;
+
+/* Level 2 Virtual Machine Table Entry */
+struct vmtl2_entry {
+	__le64 val[4];
+};
+
+/* Virtual PE Table Entry */
+typedef __le64 vpe_entry;
+
+struct vgic_v5_vm_info {
+	void __iomem		*vmd_base;
+	vpe_entry __iomem	*vpet_base;
+	void __iomem		**vped_ptrs;
+	u8			vpe_id_bits;
+};
+
+struct vgic_v5_vmt {
+	union {
+		struct {
+			struct vmtl2_entry *vmt_base;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			vmtl1_entry *vmt_base;
+			struct vmtl2_entry **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+	bool		two_level;
+	unsigned int	num_entries;
+	unsigned int	max_vpes;
+	size_t		vmd_size;
+	size_t		vped_size;
+	struct ida	vm_id_ida;
+};
+
+static inline u16 vgic_v5_vm_id(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv5_vm.vm_id;
+}
+
+static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id;
+}
+
+static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
+}
+
+int vgic_v5_vmt_allocate(unsigned int max_vpes);
+int vgic_v5_vmt_free(void);
+
+int vgic_v5_allocate_vm_id(struct kvm *kvm);
+void vgic_v5_release_vm_id(struct kvm *kvm);
+
+int vgic_v5_vmte_init(struct kvm *kvm);
+int vgic_v5_vmte_release(struct kvm *kvm);
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 52924408ca990..adfe0b207ef40 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -153,6 +153,20 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
+{
+	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+
+	switch (*cmd) {
+	case VMT_L2_MAP:
+	case VMTE_MAKE_VALID:
+	case VMTE_MAKE_INVALID:
+		/* Not yet implemented */
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
@@ -164,6 +178,7 @@ static const struct irq_chip vgic_v5_db_irq_chip =3D {
 	.irq_set_affinity =3D irq_chip_set_affinity_parent,
 	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
 	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.irq_set_vcpu_affinity =3D vgic_v5_db_set_vcpu_affinity,
 	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
 		 IRQCHIP_MASK_ON_SUSPEND,
 };
diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index 607e066821b52..70502b07ec8d7 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -269,24 +269,24 @@ int gicv5_irs_iste_alloc(const u32 lpi)
  * itself is not supported) again serves to make it easier to find physica=
lly
  * contiguous blocks of memory.
  */
-static unsigned int gicv5_irs_l2_sz(u32 idr2)
+unsigned int gicv5_irs_l2_sz(u32 l2sz)
 {
 	switch (PAGE_SIZE) {
 	case SZ_64K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_64K;
 		fallthrough;
 	case SZ_4K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_4K;
 		fallthrough;
 	case SZ_16K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_16K;
 		break;
 	}
=20
-	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 		return GICV5_IRS_IST_CFGR_L2SZ_4K;
=20
 	return GICV5_IRS_IST_CFGR_L2SZ_64K;
@@ -334,7 +334,7 @@ static int __init gicv5_irs_init_ist(struct gicv5_irs_c=
hip_data *irs_data)
 	lpi_id_bits =3D min(lpi_id_bits, gicv5_global_data.cpuif_id_bits);
=20
 	if (two_levels)
-		l2sz =3D gicv5_irs_l2_sz(idr2);
+		l2sz =3D gicv5_irs_l2_sz(FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr2));
=20
 	istmd =3D !!FIELD_GET(GICV5_IRS_IDR2_ISTMD, idr2);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bff2b7c896d55..ba32cd71fe0a7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -374,6 +374,8 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+#define VGIC_V5_VM_ID_INVAL		(-1)
+
 struct vgic_v5_vm {
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
@@ -396,6 +398,8 @@ struct vgic_v5_vm {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
 	int			vpe_db_base;
+	u32			vm_id;
+	bool			vmte_allocated;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 1702b57527dee..64e31068d9d17 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -159,9 +159,9 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(0), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(1), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(2), (r))
=20
 #define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
 #define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
@@ -573,6 +573,7 @@ int gicv5_irs_cpu_to_iaffid(int cpu_id, u16 *iaffid);
 struct gicv5_irs_chip_data *gicv5_irs_lookup_by_spi_id(u32 spi_id);
 int gicv5_spi_irq_set_type(struct irq_data *d, unsigned int type);
 int gicv5_irs_iste_alloc(u32 lpi);
+unsigned int gicv5_irs_l2_sz(u32 l2sz);
 void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
@@ -617,4 +618,11 @@ void gicv5_deinit_lpis(void);
=20
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
+
+enum gicv5_vcpu_cmd {
+	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
+	VMTE_MAKE_VALID,	/* Make the VMTE valid */
+	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+};
+
 #endif
--=20
2.34.1
