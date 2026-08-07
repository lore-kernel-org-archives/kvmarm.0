Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011015.outbound.protection.outlook.com [52.101.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE4C42FCC9
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102571; cv=fail; b=RHm19YhtQKJt0doDwpxzlZmErmkReBhZ7am3d+53Dj5IPMIxJKI7NK17eVXxHOqiIV4W3U/Oq6pEzNDlZNIHCQdRWwCuvvnvMX9GZEje4bJ/XFrWqRDFrAnD2ixfs9qrqSLHFdJC2HZJwQEpYSiwGOY1TFThzoqiO8XHhs80Qw4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102571; c=relaxed/simple;
	bh=OjBc+ovsldohAxPVV+Xkos/30aLPIEOHQkoIClieSoc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RKJqqTd2TzgFqQfu+hNO47EIVXIKD8cacVA9Tl0o0TsAMvzJqauvKOCSPgJmHq97YhTH0DUeEAiWACFZiyG1GATMpwSn5sz/+6V3+l1SLRXTvNGR5I/6Mo9dmlbREmfMqvOqPVF9y7OuBl17qa7L1/L3lOmGYHG3cua7NW+xUlc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kRA+zOWf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kRA+zOWf; arc=fail smtp.client-ip=52.101.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kRA+zOWf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kRA+zOWf"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wqaRTLqGHWDbkGZrhxXg0hphQKMOmE+PfZPFQ6R/CYdauX/esfoiQqTGIxo20ZXIel8XGM0MArsn4W6ebAK8+CHvNTdQRLkUb/NS6JVW0LAZfC72Z+cMf0PvVt/dPPNjfs1SM4JpSRoCYWCWgBF9NgrP3Z/ecQWjC9hgJP9EL/EWeaCtsKTvr9jdfy6mS4yJOYFzp7qyb3JiwiePdOBj7euZNb3au7uou9Vu1A6EybLWPlkfBJnBTQd7671m5lkrw6UClJESrbjORGYhXUgJ0Ao/t6Vl4oTQQMR5L8hQYbXRDENaRxguAKd0ERU87dor84Lq/NFZJ4i4iSyI6ZZo2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWLe6WAcWqmEnfC8DM1S2noeu9HqKxtzb+GHFa5Kslo=;
 b=hF2WH/xPVteohpjQXOSCEMDHQWL3PXzqykX7CNHCqysVRj4V7/AmWbNdV5a8Uh6l0BdDQmVPzPiNwYaskPAzucYyNFVWEpyDHlUyP3nTXtVq07hIqOcd+DKCs+yDJvHm8LcWj6nKl89V0mwdMgpigktww0Hca9McImuiYk7hq2FkrZlRQTmjizLng4XQfBatVGnIQjn7jMUsyUlqx7/1zPseQ4FVIX45YvgrrQvmzjqKhNiAeZVch1i7ICU63JBT/SA4lSNaggmYylJGY9BDK+uxh5bm8eALBrlHbcMEjhHilnSxUws53PMtYmfKN8pXDVGRwQIqSpMTgUnmisJzQA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWLe6WAcWqmEnfC8DM1S2noeu9HqKxtzb+GHFa5Kslo=;
 b=kRA+zOWfeQURX27IEnpvNXvdOISY+Xm8BWxvc4ZAQXygh7+5IktKcMkYNrW+9IxKGv0sVFbVKllh1YUpDRduXTlZz1ju831jbeUsp7XG1gPqj+Bq0fMBQP4OZw7aw3upklY70B4Ia0FRy/YXWbF41+kb8ygMi1pr5syL6wUyXL0=
Received: from DB9PR06CA0018.eurprd06.prod.outlook.com (2603:10a6:10:1db::23)
 by DB8PR08MB5516.eurprd08.prod.outlook.com (2603:10a6:10:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:36:05 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::40) by DB9PR06CA0018.outlook.office365.com
 (2603:10a6:10:1db::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:36:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:36:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xodfMQBNfciwriphlePRn1ojMgAp+je4JpLCmyJJvUFlKhriWtRbA88A25lV/VrTphgj2QOeX3RVkaffWv4geB4ztM3YET+xvtFUgiV1uwK1hAGzDJ70X5zmQ3H00E4KHMOeTwb1CRC9HIklL9zZ8MkTflnMj0IAocqyozH/13DmcoWe/M1zF8hoOMp+L3rea37tzuyucj7JVsy6cihkEblbIrs2JOqjmiqFE4aUwSMAef3YznAVc0+gQe0YU0O5EO52te8q163xTh8SiA/GCVOUWdbhbdV8AQ+SvIAgCgmW5Uy9Y1HLIj07DNFqoQDeNWR0gz4/VDfo5nSDBhrdzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWLe6WAcWqmEnfC8DM1S2noeu9HqKxtzb+GHFa5Kslo=;
 b=CZ20O5UTWmU9Er6tkiLvpXrJ1R3u0lI5R30jRystdF7ombKlaAMRaYLiVzlD4krsTPTf4HqUJwQ5GCQcUZUie//7aIJUoh2VFrDOk5CuxgK60w39+VLex2zIlCv9mIrd9AzNx31oOqjOUpRpeVkwIH5LhrJ3JJs4T2OgjBeSCeHx7gd7gNyUsGPV6BEEAGcIHZU/eTP5Mo+xOpv93x5VRmz/IPZVeJHPILizenO/ayPHsmIfZ1N7TYZIfJpcAG1MYq2n1Pyj3h1rowKMxJcnWtaGjQ9wZq/JMs9oQ59lMYFtgSGf5lCPwuI7f7ExRjcakcHV2bRISDr//TEHEBT/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWLe6WAcWqmEnfC8DM1S2noeu9HqKxtzb+GHFa5Kslo=;
 b=kRA+zOWfeQURX27IEnpvNXvdOISY+Xm8BWxvc4ZAQXygh7+5IktKcMkYNrW+9IxKGv0sVFbVKllh1YUpDRduXTlZz1ju831jbeUsp7XG1gPqj+Bq0fMBQP4OZw7aw3upklY70B4Ia0FRy/YXWbF41+kb8ygMi1pr5syL6wUyXL0=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:35:31 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:35:31 +0000
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
Subject: [PATCH v5 45/49] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Topic: [PATCH v5 45/49] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Index: AQHdJmDaKmpMaK9aL0mJLiQiV6bKdA==
Date: Fri, 7 Aug 2026 11:35:31 +0000
Message-ID: <20260807111159.429128-46-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|DB3PEPF0000885D:EE_|DB8PR08MB5516:EE_
X-MS-Office365-Filtering-Correlation-Id: f737e1ac-307e-4435-296b-08def4781123
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 VguhIcSgEX22g5NBQY3KjSTIluQspn2DoC+FlZ38+w47VtO4CwVHEYT2UtSdtlnUGjhvANYVkmUD3Wcdl6T1buWiswxFKZnj4EVwqJcfvboIi7te9a07ItNmpQBirH6YhezlSLv6PK2uGR69rlhhw1J+ci55qOHiFdymqL930nLR2UvXaz4KF0yyUzV3TttygVzI2rACqWqZKzSQWqjYeLPXCEoUbL54Z+NNbQx7QMu9sq7qQyx6HzE5FsRi0NMAmQHN5dsY+sheKRR3ryoUsrijeO86NGf+JkjnjaHR641jaYKLMgrbCX70fstuOemYWLlyCFvWlGs3iMUlamX5OOsdEVrxmqUezDrdzRW9bkN514Bdv2jIRNAe248U5vewEir+zj3CMHElPNVp/R49jm3tyaUag9suvumX2yIXauyaaaF9oOT4pXPQDZxr0eENvPNE4wHQlSHL0yTE5R4B/SzaR2I4jrz5HLDjzN69jPzvjpH6hMZDqa6spClkrhwsCwySTUsFooBRYD3lWBypYaOu2AdMKnk+mXEmk8hnMvMgppcapTDPIgvOKSBUDihz71wsK0OcxAp7aoa97IYjHjXe0TAb6I1g7iQ6lvCK4FcKyznX3VKhNgrlFto6+a06PjfjSagm2hW/A/N0vokOPl16uOSdsZaxU6IQT52ZRZoV6rSVzg3Frp0RyVhz5ZDDveSXgQ6Y3rJYMvkrGnJyF9VW7dXstQkmtb0PwYUWk2A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 d1pgG1CwGUWu7aEXJ5GZ9ADE9IztsqNnrFyepYLvIIm2B0GROaJr409aWl3MEAVJkcGejNCaCzrD0qUzkAtWD5RZR92t/YUHJNzjlOUd9FKQSJ3ikLYruqpttCNTgzui+naTZfDJ1fwXqwbn2SnOvRQWamQDlI7hr0MzANJ9M3iK+CBrZpeCk4q7Y2u/o77FVFF1GbzYkRO1syky0Wd4vST18xewv9VzeCeDxkftZSvnfTTn/yqUW89Xz5Ixkp6nMti3gtXIH7Gzl0NJapXu5O0W9V1jXwCj8UZh1L1XLMVKoMuHxQJCFE8ofckZsuJFqaXlImoAqkJyLRFxGWzeAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3731a223-6845-455c-eaf5-08def477fd0f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|376014|14060799003|35042699022|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fIkneJQ8cv/C7PLARnW60tYc3cdqldKkb5C8HdjXjngF09cdjMp50mSAoiqIPE+qNysczHPuNRL5GH8kRFkXlsckvEUfRbJqHlAJ+BdWd5eNikOXPkD81H/pgT08cXJBDAdShKtwYa61oUv1s1GPx3pXA1nctWf9rwNyD3OpG7flBQjOatOUSDMVvWZDGhjsYTFKxuhfJ9L3qUzJpZfDkhrzc08wuHTJ8h4JINndfvp2LiX6aviiH5chqHh4FG7+IX20XKehZD1voVSCY4XQSa2qqIkzQFsht5gf33XYWTnGbPolK5RZ+4PSW1x3uBgmUCl6hvcyxRawiTcv73h4aziyeCSk82DxtxUZEOVWt91DZJ/g9/Z2yclCyuL/GESAiGgWIg6BZFliA418moCEU28i/laYziVoHvFTi86qhAIDo0cc6bUoS5+Hkmjr/wmmn3e4U0YNhcQ1le5OU/eiNnbRAZx/zkLSAuulyPb4axsMwx5yNMCGk+LZX3Ad8Xm/UKn0G5B8ZkGSBz8Itf1JrbZ1fyCh7JvkomGs/sBJLIZvNHrFHKPiLlGbii3I9TIqcKee6+FjcaX0RVi0LTQO+RvHy14FYdHjXGHFAvehNc2WWgTHCdDJm8e6VJ6A8JMwaHaZ8nxWP9mwihgqCDZerZC7AJ2uoczP3YTjzGyKnyDC8d0HihHMuyBOS51Q+eOtMogrtzUqTT7fwGUUyPVDnw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(376014)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jw4aNGNbpxGRbXqMTsXPKPSaZKqgtay6R6cz7S8V8D2Oq7DO3AIlGUHYI9gFhevdgv1VdKKY0Bfv6bljYP2Z88B5KeCdqXF+SQ4rRred7H01FQm2hHskmX2tnO7kKTesH+/v+mE6slRvgAad7iHi878IMCgaBte5BY0+HwH5sS8WzirOm4uuTabSw4Tj4ZYWQngC3sjTYS7lPRRT5sBs1P7bbcGcjISHVabVyh+x8fjJFUtjGLoDd999JdZbCnFM2Ao5ZjuzLU2ShzPwODosW83SGwing+FXWBlLY8+UFWoRNSsZZWB99fyvj9aa2rq+xsv6iZu7FuaKj4x5+XN4XADFaA1MPZuojJPQC4RhAFs0D7QXZWFWnzlK4gdi5X2AyyEAzmAS1LWFdsMAQsoITpNbRuIHomIx1iGF8uWuDVtshfvPYUaWyDbGl+ZBtUVJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:36:05.2839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f737e1ac-307e-4435-296b-08def4781123
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5516

Add coverage for the VGICv5 CPU_SYSREGS attribute group. The
vCPU-local CPU interface registers are part of the VGICv5 userspace
ABI, so KVM must expose the supported registers and reject invalid
register or vCPU selectors.

Verify that CPU_SYSREGS access is rejected before VGIC initialization,
that all exposed VGICv5 CPU interface registers can be read and
written back, and that unsupported sysregs, invalid MPIDRs and bad
userspace pointers are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 137 ++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 53aad3d32f08e..e99e24812052c 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -135,11 +135,29 @@ static const struct vgic_region_attr gic_v5_irs_regio=
n =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_sysreg_attr {
+	const char	*name;
+	u32		encoding;
+};
+
 struct vgic_irs_reg_attr {
 	const char	*name;
 	u64		attr;
 };
=20
+#define PACK_SR(r)						\
+	((sys_reg_Op0(r) << 14) |				\
+	 (sys_reg_Op1(r) << 11) |				\
+	 (sys_reg_CRn(r) << 7) |				\
+	 (sys_reg_CRm(r) << 3) |				\
+	 (sys_reg_Op2(r)))
+
+#define SR(r)							\
+	{							\
+		.name		=3D #r,				\
+		.encoding	=3D r,				\
+	}
+
 #define IRS_REG(r)						\
 	{							\
 		.name		=3D #r,				\
@@ -201,6 +219,35 @@ static const struct vgic_irs_reg_attr gic_v5_irs_regs[=
] =3D {
 	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
 };
=20
+static const struct vgic_sysreg_attr gic_v5_cpu_sysregs[] =3D {
+	SR(SYS_ICC_ICSR_EL1),
+	SR(SYS_ICC_PPI_ENABLER0_EL1),
+	SR(SYS_ICC_PPI_ENABLER1_EL1),
+	SR(SYS_ICC_PPI_SACTIVER0_EL1),
+	SR(SYS_ICC_PPI_SACTIVER1_EL1),
+	SR(SYS_ICC_PPI_SPENDR0_EL1),
+	SR(SYS_ICC_PPI_SPENDR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR0_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR2_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR3_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR4_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR5_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR6_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR7_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR8_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR9_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR10_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR11_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR12_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR13_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR14_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR15_EL1),
+	SR(SYS_ICC_APR_EL1),
+	SR(SYS_ICC_CR0_EL1),
+	SR(SYS_ICC_PCR_EL1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -695,6 +742,93 @@ static void test_vgic_v5_userspace_ppis_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_cpu_sysreg_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, attr);
+
+	/* CPU sysregs are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS get before init=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS set before init=
");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all exposed CPU sysregs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_cpu_sysregs); i++) {
+		attr =3D PACK_SR(gic_v5_cpu_sysregs[i].encoding);
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS missing %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS get failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS set failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+	}
+
+	/* Check non existent GICv3 sysreg */
+	attr =3D PACK_SR(SYS_ICC_CTLR_EL1);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 CPU_SYSREGS accepted bad sy=
sreg");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENOENT, "GICv5 CPU_SYSREGS get bad sysreg=
");
+
+	/* Check non existing vCPU */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1) |
+	       (1ULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS accepted bad M=
PIDR");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS get bad MPIDR"=
);
+
+	/* Check bad user pointers */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS get with bad p=
ointer");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS set with bad p=
ointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -837,6 +971,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 userspace PPI attrs\n");
 	test_vgic_v5_userspace_ppis_attrs();
=20
+	pr_info("Test VGICv5 CPU sysreg attrs\n");
+	test_vgic_v5_cpu_sysreg_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
