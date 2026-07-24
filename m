Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010027.outbound.protection.outlook.com [52.101.69.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25756427F93
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890628; cv=fail; b=sRXtEfMy+c9MozujQMweYLzfw6LWMXzUd6XBgiscboNmKx58bW+ZoHj3f4JuS4709XsWJLR7FLqTNfJ1zAPxXqCl328Fasu6QoIMBOT/vO8v3wd6AKX99OV+TeYj6iv/KE1XHYfeLHCoRDrui2eLe5nxbI0Hojr6g/tTP+HhVwk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890628; c=relaxed/simple;
	bh=4dZr6LExdNq+P+OtRywYKoXQ9zUS14EJfEQfjiZxkYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RsqgFpb1uiE2TKYpGdPFJUBeaukKK+x1mAg9STztgia5MbsxF84O5WDY7dKzeV4sKrUZzhqT6ebinajzXXHTc9JM9We+TWEG6KCkrDZWVnPjdkTORPPL10Tnr7r19LcSqjxWGNtOj34ftFkseFSgwBcRQrU4Q1AzYILjFs+0ias=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o1B4UAmq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o1B4UAmq; arc=fail smtp.client-ip=52.101.69.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o1B4UAmq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o1B4UAmq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OR2RFIO85Yzo4iMy/vFjTIgI9yxBNooiAiIF9ezoaPFo6GDL1LkrOJhxVadMY+OjF9DU29BpQTwVZg2IemjNqzSLv+ybd+vwquwpILvPnEm1VZuvYd4cf5DZyV9xWW0Q0x86NpaOnXg4ijuiXo6QmbaGXC3fdjhBOXibODyZZUzIUN2Wbv7vqBKRpMtsuUHeOh10IKKz1gx9ni1Nl2Kh5AploHyL6/VwxQbmNb44DrE/O4kI8sD7yLQm737K1B65RL4KdQfsNJJSEoGgDLfghRayq84oy4B6FRqhke2JJYB3QwNHZmpdY2gr1swSPlMTslFqv8CJp+AY58F8XD+duw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+SVyh725Z24JRFwl9IZRg8BZ452hjL72NlkuFEbpIs=;
 b=R7Z00NAX7Q5yeiBun6OHdrhH8n5ZjwevOhcF3fejChWL5hvq2q2d2hK0uLGcOLP8fWpzZh2vqkkGgOq2pTotstYFRyV552td/cPuEVmJKCnEpXhnbHLGADAdIWE6EZzLGdA0oiJhWXY3H5hNn1W1mNdImyWIoPR3q9Vb4H7zbzKL5o/aEEYS/gy/7SZsXVWID8cxe4r5HtXZ2bkZg5qOoXqTlTbqHzCJOtiouUu48iYgaw9WMnveVf4ggwwondz6kd2iAfd9ToF1qvaI1SxDcgF0L0ugtjOD+hpIayGfH2ufIBWDZa/nwRI3Js+B2hX+ckY0SdAqBWb83rF70E98Iw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+SVyh725Z24JRFwl9IZRg8BZ452hjL72NlkuFEbpIs=;
 b=o1B4UAmqyhARCJAEr93uf7bM9+0iPb3AJp50qqeowbpLxAQp01cOOac6D8wE6vMjcHUpQeVW+P0/+T1XEoKFesqgZ1Yt1Rb6RmvAzyb9MNAAq0R5K74pT6kxpxD8H+Iy+7CDqsmyrNuZi8sW6wYb33yRXwUaseDvi1S7zUkdRS0=
Received: from DU2PR04CA0004.eurprd04.prod.outlook.com (2603:10a6:10:3b::9) by
 GV2PR08MB9423.eurprd08.prod.outlook.com (2603:10a6:150:df::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Fri, 24 Jul 2026 10:56:56 +0000
Received: from DU6PEPF0000A7E1.eurprd02.prod.outlook.com
 (2603:10a6:10:3b:cafe::2d) by DU2PR04CA0004.outlook.office365.com
 (2603:10a6:10:3b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E1.mail.protection.outlook.com (10.167.8.40) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via
 Frontend Transport; Fri, 24 Jul 2026 10:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKnMoq09z2tv6ACZnfJhWT/njKw+jxnjIOxLmE8A30Z2q2pxMMlWe3VgKQxqOsDjrFEAYw1JB1zQwLu1Pld8CfzDZXQmllHCdrP7PdbP8Xejtp/3t4M8xI015FvZdgHfuFM5mlI1EYZQD2dSfy6YRdF+KScTfLqAP1ldrQ1ka8qB6wjazB2UFbO5NOtj+EBnoYZOzNA2DQspcgDvudXhzqb/2Rd+JqHkn23B63Sf3sXOo8AxH+EPubPBwWIWkD5oeqSi5KLt98Q/+/esZCnbd5HrSV7c55dftEJG+XayZk6jxH8L1mbWXpvzisCc6d3Uo+1wdMRAmxbjNVSzF8+EoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+SVyh725Z24JRFwl9IZRg8BZ452hjL72NlkuFEbpIs=;
 b=Z3FqZiVUG0nvQ4GTxS1F2ZyiDq0OZAmHAZWw0g3e9l2sRNDMP0ND5rDBtPqqObylXojeNJhL3ZermNpZcIoOu23y/h4vtrXCbLn3tDjevy8vtLM7cv3mjAuv4QTomjB1ugYEouHCf36Jr+R6vAbRlnush7Hubm7Nzy7mmuEa5jgrJJI+c9bQTyrwGC6GaPNuaDjuv9+GB2ZQt2xOlzu2yM/Ez2yDQBDRkHmv4N//rwlkCDr2M25yE6cfXRYm8hkGcI1y9sb/FBNGukQg41NRGormCdghFiRNTSqVOAvUWPQIjK3ZYCI/dKyHqWdhoKkOe3Nkdy7H0gr47/1wfM9w1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+SVyh725Z24JRFwl9IZRg8BZ452hjL72NlkuFEbpIs=;
 b=o1B4UAmqyhARCJAEr93uf7bM9+0iPb3AJp50qqeowbpLxAQp01cOOac6D8wE6vMjcHUpQeVW+P0/+T1XEoKFesqgZ1Yt1Rb6RmvAzyb9MNAAq0R5K74pT6kxpxD8H+Iy+7CDqsmyrNuZi8sW6wYb33yRXwUaseDvi1S7zUkdRS0=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:53 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:55:53 +0000
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
Subject: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdG1r+UyoBN0GdlECBCdVMmX3QlQ==
Date: Fri, 24 Jul 2026 10:55:52 +0000
Message-ID: <20260724104819.1296803-30-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DU6PEPF0000A7E1:EE_|GV2PR08MB9423:EE_
X-MS-Office365-Filtering-Correlation-Id: 249d0107-4e39-40d1-a1ae-08dee972472e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 J+gIA/Du+/CB00gk5byXAZZ0s5eGDR6IcLK1m95dUuIpRCeDoxNec0CvshPCBPzBA1uSeu8TGU/1JyyAtBkfN1Rz01UTrWSkAhOpH76zRbkv/cQn3/Og8AcW3y3GDDO3Pc1ufcK1BjKWgh09p6iXHHFu/Z7Sk6yvAeMRM9EEdsnyu6XF+iOzPotS1dQQ9S8vJTDtB2YFEQUvCpVNZm/vmTk90VuKjFYaaDQw2JN3rytlPzWetEjk+9xMvtM1iYve7MNAXatTXoLOdjS5acKjMTjLZ9bYDwSWGGW5UBChzU54W4cbeuHgQyNymrSXk1crzRxKsjXFDxbzgnp1F2aWMM4KYYIsis0sHt2lDEZheqgtEZbl2ln9TNxXuvtd0KALGsgLjXEFbL/INf2jXa/fxLHNUnITChe4NzTLSkkE9x5+Qb0wHyBh+f4cNECFXEdfmg/DCAy7jTmkDLNAvkmfQJilfSY1qudAAEgqhKkR0RIpT1dQZZxAIbFzftax74DaAqYJllMDXpfvWNAjdVcRZOicLrcdO0JrRreHQZrxGWtkK2z3R9Zfy9+oxZw4Ghx2Z06ZTibeL6alK/XgIX52BxCxhtLmBxFJNKmPRE8hsmqMBnVhp9aqsEo+S6o7/D0wqeGofkrziHW9MJGAWWmtfVNtPVhEdZZxLSvtMncxSzjW/jhYxUDh1W0UKaLZ8/RhCm4AYDzpow75XtLuCgHXRhRxU1PbJeNGZfQdWbQrqgU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 B8CWYnjgnKIkipGd2udQ0f/igf6E1unEYuHVkkuu9Vsmr/ftrTAFa8PNE4nGCHDDndRGzjTgHlvaGyaY4jAXpl9JCFtuIRTmLQklaj0bOie6sQacItqSbACWaPw7Va8vywXKRrUd/G+7PtfSp70Q8h3BU8CGDxoV6P/97u1FdCmJx/gtXatOgDXnPdwCkgdl8L6NQ3O3+yIPpCbu+hjeyLEOMOWLQir13FCkxIjucbxT+9XaAXLasrUuQqBoYINPYMklRhXcBIqteZEJ7j/CYv7SCSwlywJpt1WQ5pIccrgxVE2IswRQORxJE3HsjXLrH8SiK+6vJegOkRqA9WXQbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	37fd52c4-9242-40d0-5474-08dee9722173
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|35042699022|36860700016|14060799003|22082099003|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QwPoHsGpWuElZEWy1WkyPz6eJoln6W0zCc6xm0WlO43eht8uFib6liaeuQFyO8MDiHCiMjqQpLmjGxhcinMrEYTRexUEcE6f1Gi2BmecPRazWryP1sULwCGKphMzHrZaInLfGwCoG1ob9tNZ/ESqEwSlHeFIZPGBpTKOXov/iJAYJvAiphm13I9n1NO1Op7A+4gz4zHpC58L0qHAp1sypHjHFSfmdH59fleudAWoaplUSITNbgBSU8JLfchHn9DpD0fc7TpIWO9hM7HI0PVLTfMI1qs5VYTyXcdesWRzlHdWAIfG43kG0RfDrbS1XVmUiHK8Yg7b8oZtE8whbT8Nec20KoCC0HSKY5HJNieO4hhEkvJocCXej/gNkBNcwBg+RBz3UcyI3i/cOGTJFDJMkOsZuYvLrMPIYlZZ/3lX0BvIES6sGBMF5vLGirfvQdKIXJ0vkF3bzjzLrViw8mjl/F0Ao4rqxoIf+3P4yQ8uS7A92k4A5GdIX6a1aT5zDy4Mx7EyfluygqIHxeztimWDlrbj3TXfkdreamUxvmrDUOAqFicjIbbFXMS7G3zfkYERaYAaK/o20xI1djQIcpT1eBLh2LRFIIcp8rfNgCOLeENwg2qxVpIuoDCikEEsEJRvijPC7HGIaccYdFWeXrQuq0yOlZUeFvyUd9flvJAUP3DIHtyUUN54M7gSkW+n9u09zHa9L2m+kiHRdH/jd1HT4g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(35042699022)(36860700016)(14060799003)(22082099003)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fTaU9lGkjH3ccEonsJmcjyfDx8OQCJGLv+ZtxtopuxzJ98DKZhQ59WOJyyhbKFj9JJfzWfUN3FtWbvyLvYhBAhw+oDqphxoF/E2kNheIpBGGoQou4eSOY8Pgh/WtLFn669Ik5y9n4a7SGSvGyr+XbWlKF/w49M8gmPZpYMzirliHPaEy8dCQZZE5cGp1CqyPSqaulsiSC52tdUe6Ik0HlaNto4xPFmPmCcXICivSE2ZExY36KmH9SKXcqKInB3fYIXJZGB5Qqslsu4jbWPREsC10Mp/8MKdnhEtLCiM1XqCa+CzjDFjlUu5JRlgjwSa2MfljdkpQwauToLICgKlRIIw/Cmijr/KuZGOUVOPSGEuttrUgDUUslaYpz9eXig5D7WMF8v3ddds/DhINt7eEyKPcvXp6SrN0NdCfaph5DYrJWxKFV6cV8uPEjBhl0U/Z
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:56:56.1999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 249d0107-4e39-40d1-a1ae-08dee972472e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9423

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

Keep IRQCHIP route validation capped to KVM_IRQCHIP_NUM_PINS, as the
common KVM IRQ routing table uses that fixed size for irqchip pins. The
runtime GICv5 SPI range is validated when the route is used for
injection, matching the existing GICv3 behavior.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index 19a1094536e6a..83e84151d7aa2 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -19,9 +19,14 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
 	int ret;
=20
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
=20
@@ -52,8 +57,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
+		if (e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS ||
+		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
 			goto out;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
--=20
2.34.1
