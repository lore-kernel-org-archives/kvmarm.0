Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C029B430CF9
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101998; cv=fail; b=ugQEO0ARB3nlOcdE1G3K9R1zuEE6m4dNUUFwPPNZWR/pmkgTkeMHprRsdtF1She5qJsM8JlL9QNn8niQU8P8MdsetHeLVOAs69VTmKcyjm6lbk1HF1TPzV6WcmD/JEuR8vI91KuWC1SzPhPulYe2khUiIcVxJLPtKCtT6zzkQn4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101998; c=relaxed/simple;
	bh=HAo5GyefLO9DHraeuLn1w1qL5i7eNH2r0E7DbNP+VAQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eztNl2URy8PXPQUKyOa2egZCXrxqCgmyU0CKemzqyoZDRt8NILqzLLVQqy0+ViutlXxitvsqPmyOAhgxfQlPl5JcdMYyRNzbYtVnxfKWsltAETErHDDRhxfz3Ocu1V3EILcArSNiePuwY1UD8TBzK84bTOwCQh40106V8BaxHTo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S2+Jeeih; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S2+Jeeih; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S2+Jeeih";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S2+Jeeih"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vXwPwHtPFasq5Ga2AV2QqNnNNEEtZa5BSnlUjKt6+Bkn0hLq/s7lGRcOWvzDbvcwAwYqgYTwKZcxEnkAYl7/X2k0Xw1PcGK4ChCIgAUQxV7GBpMk+0k3mXbCF+Po7A/w4ae1oDSpedTic3gOIoF2EWwjQbPVyyIwg1fjmP+5gb9kZq7dkcBstnghBYFxWUZsPSbIov42w3v/JQceOPDehhMtcYSLoCGm7VVynE1Vt3lL7vFJagFrb+R/tTTExCbjkGlVOCNajoR/Us665Ny5iFrVTeH24uV7SehGBCQpu3XpW3YeTrWqYEa9hXwFINYTwhIqAX6x58zalXSQbLoodg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMgTVsBz0UrHJMmUD6gvhlrmfdZ65cTuyirtqVsFVuw=;
 b=tmGPlHq6X8SX/KplnTFl+pUFGY8S7pwnJsXzwOE8M1BqDqIeCmbd7gjTse/Njqr4pQqEDx/g64IKELm0axW2vnvH52fQGR+Xt9iLMR3FUcD+1+UJ1k39UH0LD5hUq5eFAP7EXYabzpX00xznACjWkiklu2TQrUabGlck2jl5LDGnEyNDFAnN4toOH2G6H3NqE8E0qjeh9GZOC5EJ4/mchmf0Ko2lQjqFnuj5Dx30iEtlm6u2dmKj9YEn4dzyIIUwUeDsSQfKfZWhkCEnjIP/+0N9sQE6CsxaoqVjzS1e5e5HaUF4cWe8q1shOdNyxyEptKC+LTHhm8D7UDVM6aPL2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMgTVsBz0UrHJMmUD6gvhlrmfdZ65cTuyirtqVsFVuw=;
 b=S2+JeeihMlxTYSxCOlciz6z53sYV4DFKLVs6g1xcfop7TEKTHgrXaaw5BzgBR4udgydVKzuB+TN2yj2W9WJYY0OI+tQnyDiu+/7IaiZTcBCmNbqMjQwUh1YP6fwurHNXEr++cvInQAQUAGqkXnXEJBrfv4QnF53mShnSp26DY8I=
Received: from AM8P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::29)
 by GVXPR08MB7848.eurprd08.prod.outlook.com (2603:10a6:150:16::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:26:23 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:20b:21a:cafe::97) by AM8P191CA0024.outlook.office365.com
 (2603:10a6:20b:21a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:26:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:26:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+L83X+cjllwMN6eqxfz3839URp0hZv998E3GsFh/+XwN5UDKNA+a+rObZqMBNta4r/XzyiWkSMbk5WPkWsV4+DBdMH6gzrmcWQyRmK6TlEFwJPJONBRkHUyYroT6S8gBW+6htbzdFcCclw+eA9pNOc3N3Lh15UuMjcSniboOlLN9q0Mhd0DEvScerScSM8ZIljLXitYNkInPh7Q2Cm2ZMkhH0x3/Ot/XW1DKJdD9PtGcMpfb3d9GFFL/WidVURsj03WG2teR3qAjFevkvAFB3ODyRDrDTp78QGXFkRFoXsuXX7k8mV3fhMO9XLn3uu91cfOBrBLhGbARVGIugDYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMgTVsBz0UrHJMmUD6gvhlrmfdZ65cTuyirtqVsFVuw=;
 b=ZvK3TsaqTlUevqVkzO24b36uqZrUwxaJLw2Rw7cgDzIXOLvql4h9DZF4m4usQbLRkY+S4D2UNt/5BlfcrR/2ibaEVCR+cJScT4LgaKXaqxLBizzA8Ic6MJc9p848Qp3P04fJdLKem5f+fUryooTN5BhCoA+rHkzEIjvrHvuSEQMMBosOOoOEpEsr4B8p6FUXVIilOpYivSxbkjjuP3/B45TSOwbE81tSiKKP6zcgqmyxDd4E7tRvcuH8p59Jzon+5Q+2uA9ktgrp7Yppo2fw9Gf1rH3aKHCoUY0bWfvyicjbxurQ/ydB364UmiN2MqVlqlEDHhLj+cjJxOKBcAk97g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMgTVsBz0UrHJMmUD6gvhlrmfdZ65cTuyirtqVsFVuw=;
 b=S2+JeeihMlxTYSxCOlciz6z53sYV4DFKLVs6g1xcfop7TEKTHgrXaaw5BzgBR4udgydVKzuB+TN2yj2W9WJYY0OI+tQnyDiu+/7IaiZTcBCmNbqMjQwUh1YP6fwurHNXEr++cvInQAQUAGqkXnXEJBrfv4QnF53mShnSp26DY8I=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:25:50 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:25:50 +0000
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
Subject: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_state() to
 irq_ops
Thread-Topic: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_state()
 to irq_ops
Thread-Index: AQHdJl+A+eqyJTzMx0qJ+aTmDSWcZA==
Date: Fri, 7 Aug 2026 11:25:50 +0000
Message-ID: <20260807111159.429128-27-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|DB3PEPF0000885B:EE_|GVXPR08MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a08c49a-722e-4257-d78e-08def476b612
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|3023799007|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 vkiDR47HXCf3IDg2RFRRdFkWUZ/D8mNL9rQGQfpMNBxxu68XGysAhTD5dm4MmpDUa8vPQ3vwIbTjU3AzDzEPhngGGXoP50xvbLNh0rhXGGcbnzrThEtYf5YlWV3nlHxfEnCLKf5TVHWj87JGnkL0itYSITGzPYR0lQkS5EB6Tm3/ocobwaOPO4yYSTFsC2Uj+4TX6C1n0bugfFA0cPo3KNcri4sc/5dIAzK/e3g+VKfKFYzaqrZaV/JVZCMhVlQi4/VF2PON+8I7URVgihYPdXZQB880aq13bKZYMJfNfxY03pL2KdHQ9lAvKeZ3hVjieHxH9U+4ALzuWvGaMlzPthA5O7XjHfw7qFKI102mN6okelUaqSCjyvhN7kN6hfc2SsC7Dh0bW8XBBGShHRU8tkClif4VqlRFDIAdfDDcyt9HXwSR1roqn6GmuRgLeTKscOHACEuntmFHV3WOFjABCkVQKk2CZwFMaitTl2MSr+SWom28v9KisQMQiR36fR7XVq+HZiwH5NFx6gujSDq2cd2tYFIyFUa2zGXJePGdk34v8zD7Kt+0kAVRi+95DpNyslAwohRLS2EeMq9LAnR1tLZtAaqqEYWqFjKlWJ2Xvqhq+i49b6Z/mOTYOBMs7LOHj/NWwtIV/7oDf7G9NTTeujGdpbFchyRLibv4AthFc/uABkkRKMWE/0QcCbGXY8lKf2BG3eweBCfKzsC2Q9VTJZNpuq6It4YN9PnaQk63NkE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Ts/AerWftYXRYQs60hW/k3hM69/kQ2EEcmOZh5KG+bmPsEYOcd2wKg/5cv06cHvrtJ1JHhT+vbyC01pMRfTzBotW4YVN8/zrEPOdOO5ZINOnEHxHVALqVpio+4F0lGDb25+Su6AwSA5GXOkuCaar93c7s5F1tZYsnBmCA2uRg/BEYwaPVIvkrXoBd/WdTNP4ROKEM41k8eUeJXhJPSTb+AxJY1ogPzfBpJ6k2PlFso8d4O7uetIlLLpCfwUbqOA6RWWOWO+AQh3DganonuMZFzB2oyYz2ne9OIXmpW3If+/keNhfCDNVEh8LU5rVXDlf6ILuwt6RsB4o5qDO0302oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	72cb953b-4420-48bc-991a-08def476a282
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|36860700016|14060799003|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	OKJlhClcdUk55zSjoAbpnKFudBV4Fr9mmu4rGpqd+Pw6aUl4Btk5ya/2ikdIx1OqFN3xcA0d/W49XWtHxIUMcpZBeV9yCY6EnbDQv6FZq3ZY/8Vk3Gjexa3NT54wKJueV581aZ21GYrcvjGnV1pB1SWzu0K6o3wXH3LqR3ZMeFB1Hnyz/NCLP9HeXwx5MaBYTLV8eaFU6v8YhU4thYSoZHpRdyDp9Q8efX4EUk/RakFduioHTDjOAScbi8AFlxglGDSV6thZql8JB8iRWL8NcAvRcHW3MaasE/P0WxriQWHAQkkriMxUa0ldiKvWYAXjAl+49pcTaZ6cB5hQNZ7nWhJAff721WtUi+ojF0boTHB43uQ1Cr8qDOiIv3X5oCO0Eu/wZ+flcsD0zXwMhcN805SbAs/9WSBGZaFvmoF549qBjlcAZDTvsIvdbDgHDjLXiYNWwkS9aXXHZMWQT1aLAdBtsLr5gixNqgwUMJ2bKzSo7YVxz68xBhDMgbOAwT7pUeObgutTUQAewzGcFjmHLIM+0AtTSFHCHs2GYH7H/Mlj1bsQ9MEIqy66BnP3VA2xrvjIzQrgW7VSBGN9TuOgeicFbI9gUjKU343/rSevIlVgHMxj96udEjPgTaXnkqJjUV0A/U+UNALpGdlTD9QjtaC3ujWd/7bRz7/03OCQycxJzXKTXDFZ14VNJ1zh4yQDbpCzd9Q5Xdneo0iYSEVmcg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(36860700016)(14060799003)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dmOLkUSHgjXUSmZnhQcV9ik0zZifWyPq3FksOGz/kKigvseH7tG/lxtjKBgywM7vLtd8Mc4fOdhdhqN8HB8qHtvoq8c647T57zpNHuUXcOxXUTxLIfXk576g/4tJUrw8WiilXOceVwK4Vnq7iPEyXyr8BmDsQLCY5SWewfjWNQvhctpTfn/gwTi/8xEKg4Z+3Aid/ZiXsaVxFjO85+9NfETbDiwa5wsii1B2DELaVyRYN0H+XIrDL8gtEJVfVY1+/jpxxnPLAWQ0NaGXY3D7I6VBWObUtNcG8bT55oyuyr6tGtQjj69Q5iOcnL40ID6J3ZL56c0pAzgucv2NUR0IpKDvYNU9RYfFZnECVf11nP29/mE3QaQSi63TaGOFZHa603ehT7uHAScCzN/rPs3khnpPGSL0peCasEMhzpvSR5UC60LBVkmE5nMti4VkdtkT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:26:23.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a08c49a-722e-4257-d78e-08def476b612
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7848

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself manages parts of the interrupt lifecycle. This means that
pending state can be directly communicated to the hardware instead of
being represented only in the VGIC shadow state.

In order to accommodate cases where the hardware handles pending state
directly, add a new set_pending_state() function pointer to
irq_ops. The intent is for this to be used after the VGIC shadow
pending state has changed, allowing the backend to mirror the updated
state into hardware.

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 45af0287d6587..8f1994ec37311 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -562,6 +562,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2c7f1274dcc2c..9f16ee63d5763 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -246,6 +246,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly update hardware pending state after the
+	 * VGIC shadow pending state has changed.
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
