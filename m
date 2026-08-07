Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013016.outbound.protection.outlook.com [52.101.83.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833572D1F44
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102022; cv=fail; b=UL2jIx7PnWIDSPHbph2To6uja0/rnXLcZj/NKoAeOFrTcWccMy9fEsktdkrsl/UVzEaD+S3HMtDHpRZqwRPYpcKzLm4QpROKuXJSGnMxecrDL+NK0tMN4tflDabARhYP7PzRuexsfITn7aF5GIHLvbROch//0E18yuJixGBcvK4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102022; c=relaxed/simple;
	bh=aQRPKNFn2K2sQw2KeqokJVJ5HoR7vEbNLbm4LsVvUv4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fFWJYHtlrayt+aQ3pNMfJcdb/Zh7H7CPy/bs2EtHSKs0J1j2hD1/NgqFIAlGNs/h22ybcea4n36y0vuZWDL/1rgi/bJr6caJs/IVVvYgzp+k3Nux4MiS9ZBMNWb0HZRonIYvIF9dFHiMcFO/s4xZpTjtRwZUowjp3778WeHw74M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G4WqJaKg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G4WqJaKg; arc=fail smtp.client-ip=52.101.83.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G4WqJaKg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G4WqJaKg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hDRGFK7ib6IhmhnP7ASTLjgu9+7TGP8o9CGO1GvDFaELJ5qFcQFDDzOwWR94TF0FytMUYpiyjURigiu/IwX8pS5aAB+Tqsz0aQwE4NAw4/ti4r8FaTheNT6YDpQGAHxilHPI9yXc6C2/mEdwhrK4bneuAQ3HVSpc3PiEdCd0TbuqycLX3KQgQxIL7ibvdz5XEtDlwSqlbjOKLHjjvF+HXqPi7bdCcaGm4mwozYV/7VBsMSf5E1Qiep1K5CEPv2QFTK3JDhtukIJ/bGYVA2606yVj1Q7ZdQp3G/aghL2LlbVCxEuup3A2nPyv/OLymUwP5RtTiuTHKxjz667Ap+My4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3dI1nCCNEHsyThzfj3cbGMH+0w3BbcDyxCZXUjWWQk=;
 b=Pu/ZATqt2gQD5D5boYiPbRzivOA62DjF/M1jhaYCKFBPhGXZD2WnhorC6GAQNUNKw+ymUsG4cqNc0Y0+cVrVxq7lZg4LKwxJtZqQyEqmF4uw1saaMl2NZ95NzYEfWg0O+p5E/6iGkB25l79FhYCqGFkxi4amCD3RtnIF0DRePCc7LZ+t40VKW4RR4+vg4bH14RUTK8xMWtG7oqHTYtn2S13twjlptdj+AG9Y/Dkzb31kAcmKPadypTOpUq2bNcFM3eThEwU3iufV4OGyjRWJv2QAQpBh1mQFl1kPfcU+QK49yPeCQnnKmvTrSznwIfnqpLIQ66+FRIoZCpK4R1T/Ew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3dI1nCCNEHsyThzfj3cbGMH+0w3BbcDyxCZXUjWWQk=;
 b=G4WqJaKg/njqn82P6KuW/pUSiFcmjQQ0iHm9iJnAkdRUw2LHwTUdQhMZXp/9iguXlFKheUL2Jf7TjhiMcdGXQ4jSWFLFgQrMkRI6NsHqu6gwWBlaw9dx+Rhgm8p7nRlqvcmSblzGH/c/HEAvjjmMscW3B7v4EBmO72z47ZjMqqA=
Received: from DU6P191CA0021.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::26)
 by DBAPR08MB5589.eurprd08.prod.outlook.com (2603:10a6:10:1a2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:26:55 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::5a) by DU6P191CA0021.outlook.office365.com
 (2603:10a6:10:540::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:26:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPR5eTJsuWmNW8dTYE92Ui9v9DtoZdoicryheJ5yuGm7ZZQf3paPW7XOWR1V7qRD5VLGN9tHwkvF/+juSQIlw4FYFVKWni39wBdxxjs9QmFC0AB//10Y0EDrjkLnQU0vElnn3qRFVyBSGG3wGlCl2iBld9poIJLgmv42OFPDnMmB1+iRo6JAkIVJDUuVGyFvmCFibD9k78DqVT//TrHZ4jUIWdNL4Vkd7l8UIhh4s6KaGKn+yAT/jTHPpXL4REw7IeKN1hHGCf5ZR6kEs9rZwTaEhchXyp3alAC/lYatrEwsDBAv8lqCvAL9PTVlAwHoM4ldKnkhGlrbs7pjUGW0vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3dI1nCCNEHsyThzfj3cbGMH+0w3BbcDyxCZXUjWWQk=;
 b=QfAedPe5JkkAzgHj5biL4U2HOQmV42rGoCc9mq9EDlEtB8PK9PuO6anzNN759Vd0YLZb/ocsf/dBiWKFaiPtuEST8798AoGjm9abaHzNcCQN+RI1PHkttlWB1XuQGSXHlilLYNOXwyWsoNgbugAL5gFfahD7n0aFfdZg4BYdZNuVX7Di4Gq7JlHtcqQNpzDFUS83aoqpwrZrm8XMzFNGbfdLS4UAbL60AqSIqCDVPu4kLw4dlpwA85clNIvnnwg/UZ6srBi9XIRL69XHFnkhJHrMmyAWaP5N0G/RKpC0sMRZUyVMilgtHjbHSPClji/bFtwcSz3ao9UpoojH2zY5fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3dI1nCCNEHsyThzfj3cbGMH+0w3BbcDyxCZXUjWWQk=;
 b=G4WqJaKg/njqn82P6KuW/pUSiFcmjQQ0iHm9iJnAkdRUw2LHwTUdQhMZXp/9iguXlFKheUL2Jf7TjhiMcdGXQ4jSWFLFgQrMkRI6NsHqu6gwWBlaw9dx+Rhgm8p7nRlqvcmSblzGH/c/HEAvjjmMscW3B7v4EBmO72z47ZjMqqA=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:26:21 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:26:21 +0000
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
Subject: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHdJl+SELJ75zgnCEiW7cgM/PUmog==
Date: Fri, 7 Aug 2026 11:26:20 +0000
Message-ID: <20260807111159.429128-28-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|DU2PEPF00028D06:EE_|DBAPR08MB5589:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e88055-cffd-46f6-b30f-08def476c899
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 2tOS/+INMXutFtQTW/UxNhgE4Sl0n/mA2PcQ+g52YDLgBJBzUDPpYHTbj3YMjb3Q5VK6JEOlm+rJIiXc6ha9Fbg9SBbqSCJ22/8YdoxgEUVHq3I44ottVdO8VigkiTrwHvg5Dk643+S+R45lHrdJ1C/4eOs/vpYVH1HVQmsHMVRJoXx7gEoZby5hkaZqlG84UOWfgY5ZJPg2Z/BrmHDuJZWU5CF8km/rViMSWZmKAkgF7h3wr7WTEyiYbhrkV22/4cOseR9WxgNg3iWhxsa64eSl6Yo6ARqMSqLBUM/jYGBd8xosvH5B6q+lbse5HkflVYqEEc70NV9WavT2Gr2LyY/MMMVjHvYPyoMScTgVr9HakIWMpSghPlENIbt33pP6EH5a0QHMrbVohMHJNJdYofrpqoZA4pX6DKM0YdUIC+oEo9f5cSbLb0/U9KHapCmrStsu90DuYeIr18iyuJUv5eTAl5QNUwPTeGpSpdVe5jYMrRxFXPjbG5HgT6ldG8aCzIZxQqp3H7oK3d2gndN2B9n6OhrjXgrs6DyxD9a8WKATzlV+qbFV6n/WRauQZ8u4BmBV9SAck2pBWR4SKEX/KMZj5W3YrALUibcQYAdrf27cSzEXw77hGWChfZXQ0NtqnHRAeerB7RyOGJ5dsT4lqI2aSQ20Ve6tSeKwsBUCRbjIUgBIQiPdJwWQDNDqDBW52odhtKarCk9o9/iQyRjaP3ES5hT/4UlAUvPzSufQutQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tARar+HF6w8KjOxk3X3ndcXOKbQ5+A9OPAL5d6DS2lMXrLYlxfw2sd3+K/69KBqSMTMgdw2LpwAom0fu/7p2MPFFDwW45Wph/eVqb4zh/cG6RrHf9B/Ix9LE8n6YDBlX21b+ihdlXZQFAk43X8NjzhloAH4UbASEuz5zdwAtInw19b/B+2vcXUW95wmNUyJabUraFBCanLSOOys4q0hFuxwdNMr7/knkl3X7+mMVPCjRzBP62snlN7uy7NzATXw7sxGW+0osJ8Ai7RFF1Ya9dV2MJsoV2u1VL083vI7C+pC4/NIhqJU3EJiHoZD1a7Mve2UpCGuH5ACP9O0iwvV+aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cfd749e7-e66a-4ff0-5918-08def476b4c5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|82310400026|35042699022|1800799024|36860700016|376014|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	JznrTyDdR4CO7RqMQOyr2p8dTUCk26s8Pg9oUYwH97Q4Zm+KeEXp04zp4vZEmH3TYdJKpjLRAYp/DhXx4A+Nbdnjoffb8aHhHtDcOXsDrP13rBPcH9PNh/Xt9Uan9+cQeDfK+uHBXFjPO841YOCVK8W6+FCqoplF0Vg9ZErcI7BUOy2fBFP/gvfZ2NtZuyLnzG+JQ7UulFGjcx6TbzxykFaNGjtEqUXB2g2m+TkQa1UHReKnAgc7+y7NYJ/F4Aq5R5VS1ZzsZpxpiVSALd9MwWNCTi6nWGGczmYvoOw1R31somYWupGlqwMrMezWbWpmf11VT6wMeN8D89F+PIbJRlhW5atqyEqyVKsNDu5APOtwsGv93R9qYKpi7KeWIt6MxFiQCmj4l6H3Sq/GSeTVOZFEEDC3cczElULJJfzV7in7vPkEJqZ93SolPdT3LNWr44PFne9GuvwdoQfJRANG1FthCnBZVVWM+biOzLvBoxdJj+VgLOJfRZo69m+v8RZp/TlHDpETI6kXxTKOw67YoqYBSctzIW7HOFeq4QEIF4/NifOkWtERB/gukujhtCZ1pg7a02063T+P2sC40baMSmbqQoxFRRaDjGyuOrLpTbZ1ymtpSKZqrBCgCmD+XIlUDzfoTgJuReSqqAjogB7ZVz/RqSwtlX0Tw4Ze15kpRymWR+lKeKBRumXrZYVw5Q63w5hmYOkj0HlJPhKGXxQntw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	joutQext4Z9ysghV0ut9Yq973hD698gI4pP7z/CJTiRhb9Eyyz12clt3UWYyDfbsfe7tdCm8WyDLzEPHo1f0jQqhWlNW55u/T1+tP1h5vGnMnmZzZ7lCWMUpWFUvdzFzD2m/dgfKEIk0ZIS2oWVD2AAtj2Ras4+qaGxtB5mP2hiBv1vEmffbjKLiKUxaHV0w60a4r8LDCiXjeZp+eBm+S3ZWsO48POcuGEPSGLZQcaAKxP8oL0VETw43ACDpL/1fBgIf2WogYSRnQ6Sh3vX+m1kZ6Ngqkj8dAnsTtJUXoD0ZSI8uGn1/Fg/bAVo4D5brYYT7fM0jS8ambA9XeQ8zNtRuiDDu3DDLJAg8iaDvsOQGsOuysOx7lM4CkCYZlcSfqr+pJRgDHVrD3cTtc9DtJe0/bKQitel+hBR7f4+lCpTUxjcEhugTYtuMHBt6/0+5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:26:54.0947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e88055-cffd-46f6-b30f-08def476c899
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5589

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting SPIs to the core VGIC code and
GICv5 code. First of all, allow GICv5 SPIs to be looked up by ID via
vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used for GICv5 SPI injection. The set_pending_state()
irq_op is used to inject the SPI's pending state into the guest. The
queue_irq_unlock() irq_op releases the IRQ lock without queueing the
SPI on a per-vCPU AP list, as GICv5 does not track in-flight SPI state
in KVM. Tracking the affinity and lifecycle of individual SPIs in
software would negate much of the benefit of their lifecycle being
hardware managed.

Limit injection to the configured per-VM SPI range. Since GICv5 SPI
IDs start at zero, KVM_IRQ_LINE accepts IDs from zero through one less
than the configured number of SPIs, up to 1023. Update the
KVM_IRQ_LINE documentation accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/api.rst    |  3 ++-
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 41 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 28 +++++++++++++++------
 arch/arm64/kvm/vgic/vgic.h        |  2 ++
 5 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index e3003a241d5b0..8647980e81c1f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -909,7 +909,8 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_SPI:
 	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
-	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
+	       in-kernel GICv5: SPI, irq_id between 0 and the configured
+	       number of SPIs minus one (1023 maximum)
 - KVM_ARM_IRQ_TYPE_PPI:
 	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
 	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index c6280795ab551..095046c7959fa 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -680,6 +680,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b401e80d74354..62e069c21367a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1061,6 +1061,47 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					 struct vgic_irq *irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	lockdep_assert_held(&irq->irq_lock);
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	return true;
+}
+
+static const struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !READ_ONCE(vcpu->kvm->arch.vgic.enabled);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8f1994ec37311..5f10c0d9aa1c4 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,19 +86,31 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
+	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
=20
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
-	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRI=
VATE_IRQS);
-		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	if (__irq_is_spi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid =3D vgic_v5_get_hwirq_id(intid);
+
+			if (intid >=3D kvm->arch.vgic.nr_spis)
+				return NULL;
+
+			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+			return &kvm->arch.vgic.spis[intid];
+		default: {
+			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+			if (intid < max_intid) {
+				intid =3D array_index_nospec(intid, max_intid);
+				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+			}
+		}}
 	}
=20
 	/* LPIs */
-	if (irq_is_lpi(kvm, intid))
+	if (__irq_is_lpi(type, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 282278e4a6c19..107737c77e4d5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
