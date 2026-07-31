Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010019.outbound.protection.outlook.com [52.101.69.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A353B8BBB;
	Fri, 31 Jul 2026 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507276; cv=fail; b=mVPohfLaEQaTj1baoPekkwyP3Hkh5VfggTUUJZAW8d03c1a8kyiuYAeM738MWGHVRXfCaKyin0Z2cJDFlZeHqA8HJNXPfxXL0Le4RxHsR0ylVrjeMSIMLrtA5u+yQlQnS7WeJ6aympWiV1zjw3XkLsIHZfqeHp1RSkDiwDIyZQk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507276; c=relaxed/simple;
	bh=K4wJWsTZz6cc6fQV9g73A5Bqg2SgVjc0lcHLanox6YU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rz5m+9KrOwbuRl3IaJa2mrTksOO6Zsv+5ScyyBx/pR7EhTeOikzCh/EDEyk7CSfFOvarefssSXxhFdutYM6/Ti6bhxOmdzMOUPE6MzBbu3/S6SayjeU8h5fMi+5E7gTI0fysWD8jE9/Ut2CLLFluRvHhyKa4QMQh9u7cXBApBhI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c9A60GGn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c9A60GGn; arc=fail smtp.client-ip=52.101.69.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c9A60GGn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c9A60GGn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YcVik71bw7OzYfTw+q7Y0f/PZMzRfcEkFolidjzjP9iCJPoUv1brsNWdU3eLBmvykZRk2KNzdu57kEq7BkTrODdomviChbEVgKozZi1uJ24WolM5nQYLbvKuCIdrqk9XsWij0ZomdJFOKobahchOg2phoJjDQI0KRyNmMCxmirsz+HdyUER+jQ/Bf+NiGeUxTqG6oPSWVmwZjN3TBn7V9o1lFI6cWhYCGtuaqfnBxmiDDIH3EhNC43IWBiANy2YFdG7wwaTS/b+HkPEqMUgUYTvuVChlGEXM9HFZCUGglBukMcKY3LptwBdUlZJ2t3fLNhY0CvJR/8RAzUDrGoC/6g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4wJWsTZz6cc6fQV9g73A5Bqg2SgVjc0lcHLanox6YU=;
 b=AXCQ3tSmf2xcUMkgrYYGKNGYPY2nY2xm7WPAKxqa4HWXPHdr4qN3/d4zRT12heyIDNqAt2nz07DhuZ7UmfvbDJ4wLNtp6auYTeU5SajCAjHCtSMGCmyS8OhPclhJuVwVEFArEcK0xEEzTza/sE9biLSzmW+fvunMYDf0CT/Dnk/7XWuJoMJhM2vh+fTZd3EwMaQYfv56/beLCWf+z4zNEgJyPRO56tMEZgat9K+Q++wHJ02k7Ib7EJSamgirW8NeFE1hHVtrTMW6bjGXVvh+MluqZl1XfVgFMQ5Hei0oEZtqP6T2WNb+NQ+Q6Szm6BFbL3sDcSEWvVrUJmR3SarRBQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4wJWsTZz6cc6fQV9g73A5Bqg2SgVjc0lcHLanox6YU=;
 b=c9A60GGnJqK89Zw9fgIh+PPu80FyRdFbI/1K/5SKm3tKGyDBZkZ8Kvzfo+4X2athZRRksRx8VoV/O05vXJEO/6iiWG4XK766aG5e26chdghDBLGUVjKf+fujY+sSD9s7ErdeUs1jSJPj3Gf/XpH+1nJ3SADx4tpVVzEVwtgq2/o=
Received: from AS9PR04CA0078.eurprd04.prod.outlook.com (2603:10a6:20b:48b::25)
 by AM7PR08MB5382.eurprd08.prod.outlook.com (2603:10a6:20b:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:14:27 +0000
Received: from AM3PEPF00009B9B.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b:cafe::40) by AS9PR04CA0078.outlook.office365.com
 (2603:10a6:20b:48b::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:14:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9B.mail.protection.outlook.com (10.167.16.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqzUdshkTIZUwgh1ZUpJ1UluXbFgrIieWf0IrjXim3+sEb8Q3aco5svKE1aa7jk6jzuyXZnmIpf8URg0gn1dv3e49taOUN/+zALSN/8ncDovi/1mio/ISlJJNPjDpNP7ucZRwgfrvxVPf7O78w3h5svxBMuqZN1P2163uU6lu5zo6zuG2j6bq3Eluv3SD0lSty1A23zXI6fXvD+Ej7AqJwxflB5DZlVPFpOZbmkQPq1VXG0L6LDwrPte7Gg2xZEXL47TRHic3CEVkQaJkf6gmXZmQIx6LWGv2vfchp05VYZfgTXjK6or9vg/M8Kt1G1XWNi9+5CZ/tJG2o/W0qEPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4wJWsTZz6cc6fQV9g73A5Bqg2SgVjc0lcHLanox6YU=;
 b=zAM2tHFJIHhnYKFf5Hfar73dI8YosT6pzFmC+DUL58lz9EmQaglmoxw3g2lCdNo6kl50PSefifEST61sPkmHOnTRB37iqn+4KqeTuTo9cqtZJvEjicP3aKr2NUms8jcx8vo2irC9dajM6OarkVbCf6MIw9lhyri0LlJWumuMNefE3uIcPXS89o7SYwRjMGStXABHkWbJVEJPDj0QAMQr2+0UaRFHkkejY8tC9BTaWKbZGZlTXZ3Jk18A1npB/pABVnN6O8v5wWsgR1qjMAiN7RKggWX9kXzyZeu69/2nqmF/b3FmQ+PZgPMFVu4Hgyol6Wv8srW2hB4zXDmFQofvMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4wJWsTZz6cc6fQV9g73A5Bqg2SgVjc0lcHLanox6YU=;
 b=c9A60GGnJqK89Zw9fgIh+PPu80FyRdFbI/1K/5SKm3tKGyDBZkZ8Kvzfo+4X2athZRRksRx8VoV/O05vXJEO/6iiWG4XK766aG5e26chdghDBLGUVjKf+fujY+sSD9s7ErdeUs1jSJPj3Gf/XpH+1nJ3SADx4tpVVzEVwtgq2/o=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PAWPR08MB8982.eurprd08.prod.outlook.com (2603:10a6:102:33f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:13:23 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:13:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Topic: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdG1r+UyoBN0GdlECBCdVMmX3QlbZ8lpWAgAsgMQA=
Date: Fri, 31 Jul 2026 14:13:22 +0000
Message-ID: <007ddd645b13708d87c902b8a6c04a3f1d48eb44.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-30-sascha.bischoff@arm.com>
	 <20260724121917.A6C241F000E9@smtp.kernel.org>
In-Reply-To: <20260724121917.A6C241F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PAWPR08MB8982:EE_|AM3PEPF00009B9B:EE_|AM7PR08MB5382:EE_
X-MS-Office365-Filtering-Correlation-Id: c8ac5823-945b-4e71-9ae1-08deef0e07ea
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|4143699003|38070700021|10067099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 P9q7mFPT1OX116v5GyCtm7ihxnJBK7GSbvWBodYIa9aeq9hfEufieJm9iWSGJFdo68IQZZPef0szBNdACyCYlkaIaE42ZGrrbsMBh3vICwWg2zHfymcHsgKgFgmLAt54PHz5XG277oB4f2eaiF69q6H5sdPROPUVkUgngaykFm3VA/eByYEorEEfsTCn9weQIrEuBfaKBD78mtaN6Hhhwx/E9iQjYD/3IqK4muXs5Dkw0968A0CABldxjMmLes+6dT5YU6yFOZME4DrWTZVtD99wKQvDI1DokBqq9CfovuTBiZK4mmMZvoWB+nfwKCSLAPAOPNdUNzTAyCAzt4qgLzAxb2cuKztEMxwigtulj2tJ1O4a+cNsgJzc2Buy7dGChPvYM/ZrOf5xCgkori3xbVNruu7LKeO0BdQr3gNQhxLmVSaM9heOpEdifr2EMdWHwc2cWSMCVyubCA1XjbDvpyXRCDBMmagJk9Dg6icm8QY/jRfbF2xFeSR+me/vCpynBcldCr55A00VxgnuDPImfm/BraV3Wlm3o1r0fDvjoP1lN+0jpiJw6t09egCjY77YD036QQ9IbF0ZEQhfhAbZspK3ZsYDHI50joIzG6HjXpMIbwm8plCLs5yV0/wkH9AaU7O3C8F3Ns7CW37ksyfKygHHBTXaeAiDIti4Z9ZDmPsZ/LV/F0fBrIcvVdq/ApM9LfMgA3nJdPTEUseGWN0v/yIO0URPoV76X5Nzxz7C40k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(38070700021)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9EF5B49CB522E4E93BBEE61EAAEC39F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jcFz40J/E73s3HSBf6bS/D8t5tM1iWinNr+ZIJ8un27uZKzwJpEskMWBF4CyyWWt2fDy6+Ks1y5700uERZtw1PgF6dnsjQtP3gzIkfLYIwgs+qvrqsG72urayFU73XiqEt9Gp0WsjILq7PF5qemM6qsm5P63BpRuJf9KtYA2lsqAgzRnX5NRiMYO+Ij9zSvAQ0dYa/zl8yxdUwLTuYw4ESlY1pu2R9Yqb/X+lxAmuolLcSvfbJdKBXT9YGvyaK+trx3CGQS9oG/sLJE47nXSuxKONlZ/gS+0lgr20kGmZUKVm5oxE/rzlYTA/tKdkBScEFC83LtEo4HfE/sFMJyHwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8982
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cae65444-358d-43f7-039e-08deef0de189
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|35042699022|1800799024|14060799003|23010399003|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vJ0GAdpCJMJpzyNtLlczh8K5B6rD6CICEJjM2KigsQQ1aFLrlTnMx94E0Zo3VeNuUwiWSxhCrPcFR1O71Ug0jfT4+tboDA9zvRzhSk4PG7nvkeZJq4zvjObuntI3VuqkJBAwvi7IBm3S2OgMeceyhsnBQ0BM2Ne0/M/F5DRkRiKxmK8ITofYLxTvX+4Kr0D1KvLVjqSToYhIrKivKh3466Pbsow5W3tvCjhZJpn7sT51+rPg7EZ2snkKDqhOH+uH056Kvh1fE53Igv2mPojxf3cgmjsrdM1YbrUY7Gho/3ycgFG0i4Ir8xnK9/jFOm76xp6fKpTPW7420NSHXVd4ZH5/kWR8iWsPzaqvbLaNtnu2vaog/DVBllvHbCXnw7ycCzDqLObSfWwN4q8+o9IzsncKYzgycB3OT9b7dVdf7UAiMs/pj5pArOWg7cc9jeyliNwPdbrlHt5aiClSL4BP1P7B//r9bn7bmBMh7SmguzdhMwhzHsjeb/Zg6M1Z6uOvlKT4Yw5BlLEai9NAj6KggC0102Nh0LjTpN3l5gcfU02lSQ6JXsUpXlWpcD5xw5UFP5HJ/N/yLffktSlBlYcxlwXDD816Yoych1zI2oxqrI6jW1GDxO+vIrN8Lw2hxFnW9XZuZDex7bV5QF0xfOK7f8lcmnxwztRYhfucZHIwjjORKn8GtxsZKewtnCWoMH8H8rIuMl9GKa5cjx+AgTm1ag==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(23010399003)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j5lep/mTz0XljkyYG3KCXHfZWnw8yKoQsPm27s1L9FRpbX3Qv3HqDH4kn/yiEScCcNLRcU0AhEhNDC6I/rRmLRImko3SbXY8HK24Ae7p3gPJ+3u6iMsZQJ0u1Ds1zb9C/fkKFE0kCdxzz+89vJSP9hVt4wq04jijQo+5vDDhbkW1MYVjbtNreA5e9xAt2Op+IEYDKCyIylinlYIBZ9j/N1jCpUKe1v3sTOZQNpl/C0Qlz00IndTvmc0ZN43ixGxN0VpdtqVPdbSS8WdG/SQj8bw0Vu5Viyk4LjHCaCWP6BC0fgFyl8eOWeQ4XQxdTGAYWuMsdOPJF2tnE56FO7KPoHUGJwVCcSLK4/bVs268eI1/sbqwZtPx0NRne9ysL6XcTVDezUorgGJTDknwYkxmCSzuFN4znCvYurinbA37zYGVIyjtVAKg6KjNsdkYKuAH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:14:27.3680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ac5823-945b-4e71-9ae1-08deef0e07ea
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5382

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjE5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIEdJQ3Y1IFZNcyBjb25maWd1cmVkIHdpdGgg
bW9yZSB0aGFuIDk4OCBTUElzIHdpbGwNCj4gdW5jb25kaXRpb25hbGx5IGZhaWwgdG8gaW5pdGlh
bGl6ZSBiZWNhdXNlIHRoZSBkZWZhdWx0IElSUSByb3V0aW5nDQo+IHNldHVwIGdlbmVyYXRlcyBy
b3V0aW5nIGVudHJpZXMgdGhhdCBleGNlZWQgS1ZNX0lSUUNISVBfTlVNX1BJTlMuDQo+IC0tDQo+
IA0KPiAtLS0gUGF0Y2ggWzI5XTogW1BBVENIIHY0IDI5LzQ4XSBLVk06IGFybTY0OiBnaWMtdjU6
IEFkZCBHSUN2NSBTUEkNCj4gaW5qZWN0aW9uIHRvIGlycWZkIC0tLQ0KPiBjb21taXQgYTlkYTk2
NmZjN2I0NDlhZGFhOTI5MTcxODVlMjc3MGQ2ZDAxMmY2Zg0KPiBBdXRob3I6IFNhc2NoYSBCaXNj
aG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6
IEFkZCBHSUN2NSBTUEkgaW5qZWN0aW9uIHRvIGlycWZkDQo+IMKgwqDCoCANCj4gTm93IHRoYXQg
dGhlcmUgaXMgc3VwcG9ydCBmb3IgR0lDdjUgU1BJcyBpbiBLVk0sIHVwZGF0ZQ0KPiB2Z2ljX2ly
cWZkX3NldF9pcnEoKSB0byB0cmFuc2xhdGUgaXJxY2hpcCBwaW5zIGludG8gR0lDdjUgU1BJIElu
dElEcw0KPiBiZWZvcmUgaW5qZWN0aW5nIHRoZW0uDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJxZmQuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLWlycWZkLmMNCj4gPiBpbmRleCAxOWExMDk0NTM2ZTZhLi44M2U4NDE1MWQ3YWEyIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jDQo+ID4gKysrIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZkLmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4g
QEAgLTUyLDggKzU3LDggQEAgaW50IGt2bV9zZXRfcm91dGluZ19lbnRyeShzdHJ1Y3Qga3ZtICpr
dm0sDQo+ID4gwqAJCWUtPnNldCA9IHZnaWNfaXJxZmRfc2V0X2lycTsNCj4gPiDCoAkJZS0+aXJx
Y2hpcC5pcnFjaGlwID0gdWUtPnUuaXJxY2hpcC5pcnFjaGlwOw0KPiA+IMKgCQllLT5pcnFjaGlw
LnBpbiA9IHVlLT51LmlycWNoaXAucGluOw0KPiA+IC0JCWlmICgoZS0+aXJxY2hpcC5waW4gPj0g
S1ZNX0lSUUNISVBfTlVNX1BJTlMpIHx8DQo+ID4gLQkJwqDCoMKgIChlLT5pcnFjaGlwLmlycWNo
aXAgPj0gS1ZNX05SX0lSUUNISVBTKSkNCj4gPiArCQlpZiAoZS0+aXJxY2hpcC5waW4gPj0gS1ZN
X0lSUUNISVBfTlVNX1BJTlMgfHwNCj4gPiArCQnCoMKgwqAgZS0+aXJxY2hpcC5pcnFjaGlwID49
IEtWTV9OUl9JUlFDSElQUykNCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzbid0IGEgYnVn
IGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCwgYnV0IGRvZXMgdGhpcyBjaGVjayBjYXVzZQ0KPiBW
TQ0KPiBpbml0aWFsaXphdGlvbiB0byBmYWlsIGlmIGEgR0lDdjUgVk0gaXMgY29uZmlndXJlZCB3
aXRoIG1vcmUgdGhhbiA5ODgNCj4gU1BJcz8NCj4gDQo+IFdoZW4gdXNlcnNwYWNlIGNvbmZpZ3Vy
ZXMgYSBWTSB3aXRoIG5yX3NwaXMgPiA5ODgsDQo+IGt2bV92Z2ljX3NldHVwX2RlZmF1bHRfaXJx
X3JvdXRpbmcoKSBhdHRlbXB0cyB0byBzZXQgdXAgYSAxOjEgZGVmYXVsdA0KPiByb3V0aW5nDQo+
IGZvciBhbGwgU1BJczoNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jOmt2
bV92Z2ljX3NldHVwX2RlZmF1bHRfaXJxX3JvdXRpbmcoKQ0KPiB7DQo+IAlmb3IgKGkgPSAwOyBp
IDwgbnI7IGkrKykgew0KPiAJCWVudHJpZXNbaV0uZ3NpID0gaTsNCj4gCQllbnRyaWVzW2ldLnR5
cGUgPSBLVk1fSVJRX1JPVVRJTkdfSVJRQ0hJUDsNCj4gCQllbnRyaWVzW2ldLnUuaXJxY2hpcC5p
cnFjaGlwID0gMDsNCj4gCQllbnRyaWVzW2ldLnUuaXJxY2hpcC5waW4gPSBpOw0KPiAJfQ0KPiAJ
cmV0ID0ga3ZtX3NldF9pcnFfcm91dGluZyhrdm0sIGVudHJpZXMsIG5yLCAwKTsNCj4gCS4uLg0K
PiB9DQo+IA0KPiBCZWNhdXNlIGt2bV9zZXRfcm91dGluZ19lbnRyeSgpIGNhcHMgZS0+aXJxY2hp
cC5waW4gYXQNCj4gS1ZNX0lSUUNISVBfTlVNX1BJTlMNCj4gKHdoaWNoIGlzIDk4OCksIGFueSBl
bnRyaWVzIGJleW9uZCA5ODggd2lsbCBiZSByZWplY3RlZCBoZXJlIHdpdGggLQ0KPiBFSU5WQUws
DQo+IGNhdXNpbmcgVk0gaW5pdGlhbGl6YXRpb24gdG8gYWJvcnQuDQoNCkkndmUgcmUtd29ya2Vk
IHRoaXMgdG8gYnVtcCB1cCB0aGUgbGltaXQgdG8gMTAyNCB0byBtYXRjaCB0aGUgbWF4IEdJQ3Y1
DQpTUElzIChwaWNraW5nIDk4OCBmb3IgR0lDdjUgZmVlbHMgYSB0YWQgd3JvbmcsIGFuZCB3ZSdk
IHdhc3RlIG1lbW9yeQ0KdGhlcmUgYXMgd2UgYWxsb2NhdGUgYSB3aG9sZSBwb3dlciBvZiAyIG9m
IGVudHJpZXMgZm9yIHRoZSBJU1QpLg0KDQpJJ3ZlIGFkZGVkIGEgR0lDIHR5cGUgY2hlY2sgaGVy
ZSB0b28sIGVsc2UgaXQgYmVjb21lcyBwb3NzaWJsZSBmb3INCkdJQ3YyLzMgdG8gc2V0IHJvdXRp
bmcgZW50cmllcyBmb3IgU1BJcyB0aGF0IGNhbiBuZXZlciBleGlzdCAoYW5kIGhlbmNlDQpjYXVz
ZSB0aGUgdmdpY19pcnEgc2VsZnRlc3QgdG8gZmFpbCkuIEhlbmNlLCB0aGUgbGltaXQgZm9yIEdJ
Q3YyLzMNCnJlbWFpbnMgYXQgOTg4LCBhbmQgaXMgMTAyNCBmb3IgR0lDdjUuDQoNCj4gDQo+ID4g
wqAJCQlnb3RvIG91dDsNCj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJY2FzZSBLVk1fSVJRX1JPVVRJ
TkdfTVNJOg0KPiANClRoYW5rcywNClNhc2NoYQ0K
