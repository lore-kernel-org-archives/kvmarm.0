Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013059.outbound.protection.outlook.com [52.101.83.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1C2330D25
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 11:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920578; cv=fail; b=oXaD3tWGyAeVcF4L3QNx10lQ+deedj4Fm/BMrGFmTptIHG9w5n9+F+kJzT6QX1miHfKEk+Nqj0uWNNhW2VP+xP2aEF7tllBn93ZpYEOcrOvtYFlJ0pJZjOjCm5/AsCQQlqFcqD8P2zmhG9kBcUT8X3DsplVeuoM+oj+8f0gJpAk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920578; c=relaxed/simple;
	bh=iHABhbBS68XrX5P1H4GfrZ5mw+9CrcjltWxCqHXWtFc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZZ1+pflOaDNFOhEO7+TyrZpfbM9+o/H5XnpwWVmjR/yq6mw1tTFClaX3GoUaqIfC7WaKu+MgvRCw1NFJdFYh4qkJyL15L/8KtvlfQB+8yrsQKm2tx6+xAfVexcM34oWqLa24TOmmWeFLkAJhrtlOpbFvO9mD/Y2akrCLG80Aynw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S82I7gMF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S82I7gMF; arc=fail smtp.client-ip=52.101.83.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S82I7gMF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S82I7gMF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YG4/E3zbu+Txt0lxcfLIugO9V+krhJqsSAC/Xboz0ooOXtd2VZBLmZdMY0ZO7Xdz1q9fHTpyOcVNXompj1Zbl4GqRByfyRaeAQSQqO/+r+wNujhhgoro1Fk5piEL/pj+XNiGGDqMXktmZR5n3gHnOX1JapLp6EocC85xpeuqzAnPACOpB8jJTVpm4ousmnoSyB/0zpeWMq5JK35NxQSSdBi8+fmZAaohsAaEBeJJx1t5FTFUpNC67TqZCYaezx2hOKMgL3SNBHfAq1TzuA0TvZymHTZJ4n8M/sCB3VmqE82r/iNIDFm0y+4WlQqQ+fCn/0qEuVM/wu5o8xXHSIXLEQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHABhbBS68XrX5P1H4GfrZ5mw+9CrcjltWxCqHXWtFc=;
 b=sucNX+9OBSPZKxDYP0kpH9mX/BgXb1lbogTOhmlJ35D4ceuVlUlH1aD51nDjYb25D8B7DxPSXxJkT6GhRHkQm3d5Unxu1IyIvAGD5Ak1RW6jWBhTsXd/vU0FhwDT83bS5jy6ex8EEJyO89aKNhylIF3n+HoohxjcrP2S37YAM01Yn+k1zg9XffuRDIDutP0+53x6Lz1aZ/hjM+q3qgXrm4vOud2RXgx+NY9x7chvpAsV8+X408pVNb+kL5w8GLRDQnzOUWXxQK8yPGjr3J1Q+4JUrRe3CMHxbTuE+xzY63+JPK+JiwvtG41aUNKHq2KK4s8LuhrJ0n2770TxCMTkcw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHABhbBS68XrX5P1H4GfrZ5mw+9CrcjltWxCqHXWtFc=;
 b=S82I7gMFRiQbnyIZKhhZB33+gMz5nr7Bexnk5eYH3RScXEDLbn0U+CiC4/Y/zqe9HbclCLv+qlLZ57dRwYL0BsYFGwJhiQTEQ8aiwsneIt89djqEhb0fRWLsSzV866+BNA8Rr3V0LfoN1MVFGkuwH449AMeign8J1dqdfE6EuFo=
Received: from DB8PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:10:110::35)
 by AS2PR08MB9294.eurprd08.prod.outlook.com (2603:10a6:20b:59a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 11:42:50 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::c2) by DB8PR04CA0025.outlook.office365.com
 (2603:10a6:10:110::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 11:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 11:42:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D912ShT/4Soz7KoUzKcoxNgpDopWJ4obxEcT3MPOAm+lOd/cJL++SvTPrRZj+FN6VFuzEQca15rvNjne68dN325zDfVu+DPDf/VhCEvNw5wThKQFBwBaqzWqKXVcYSIIuZ8164y+9x9wIQXElzBJDDqXfi8jwpbiGB2r1Bjo88KbrNfV1OOg6u4gaEs/gN5NcdJP5vwbdZjg1qaSVAu0Boggd516V9+Hc+eDnQJyBjGqiHqy4Di5hlo4KT0hUl70nPUpuZ1OsMyY3BWMc08brT/sVdiSOc72xzXBJ7z7znViH+tUEwcWCpooxl148/M8SjQpNdYyUFVbg7CXs5G9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHABhbBS68XrX5P1H4GfrZ5mw+9CrcjltWxCqHXWtFc=;
 b=alx16QMPVyLQbZBnf4t0uVBB70DUyGCMPmQufZSRpufc40Tv0YmuA6XSIDVNRLTTwfp5K97LOg4hA3EycDVmyiHheDSQkB7b6nKpCTxVWyokdIq4aQ0gAyKAxhMgZJax+TUMOj3fyyqYRFNWvHckm1X+hGVMThyrGoX/S93b7/k40XJxnxmhwW1f7ZfxD3zLV+GnLOCDGDC8DKzWOXjwNIHWIGY/++GMqr1TaYiyycZiOhh1NJ/1HmneQ3+gBMgx8bsbSYzFu3dUV67eov6alWy2t+w6h23iBMqJ8E/KRxCFDQ8ijNKt9rBrqRLEKAJwN8lxtc0Z5PNAA7xGgIr7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHABhbBS68XrX5P1H4GfrZ5mw+9CrcjltWxCqHXWtFc=;
 b=S82I7gMFRiQbnyIZKhhZB33+gMz5nr7Bexnk5eYH3RScXEDLbn0U+CiC4/Y/zqe9HbclCLv+qlLZ57dRwYL0BsYFGwJhiQTEQ8aiwsneIt89djqEhb0fRWLsSzV866+BNA8Rr3V0LfoN1MVFGkuwH449AMeign8J1dqdfE6EuFo=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PAVPR08MB8991.eurprd08.prod.outlook.com (2603:10a6:102:32f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 11:41:45 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 11:41:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 03/39] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Topic: [PATCH v6 03/39] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Index: AQHctgLjp4iWVEuIGEy0s65+xvO5o7W1pcOAgAAY8IA=
Date: Thu, 19 Mar 2026 11:41:45 +0000
Message-ID: <5d01cb27098d522bd9350698bdfd718e54eb13c8.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-4-sascha.bischoff@arm.com>
	 <20260319101229.000040f2@huawei.com>
In-Reply-To: <20260319101229.000040f2@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PAVPR08MB8991:EE_|DB3PEPF0000885F:EE_|AS2PR08MB9294:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f4a926-5cb5-466a-a1df-08de85aca619
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 EwIl9oixNWddgPcNyNNqUUTyUIVWYmQ+rOq9l0GcM/RqEUbecIrZbeJjyN9ntdfCnyn2P/5TV4OPXRunWESZqPxCVzqwlaqwnl1jbnPqN4AYNC0GyK3y/u+/DddzVnjQzL9xL2bI13ezDWrMhrIhx/mfTXB9KLu8fO9mUd9D5RHsT/XUGnCIt3ZMOlL/2MXTGSwnZXkQ/9FlQmjSNo6hy3TArW+hgJfaASBQcQuoShd/6K4u1+wwBzI7O8sXRDUDnMAa8ue08h+sknpOww7N0QdeU4xybPMitcUiF4Dqmd7t1l5SHxPraBN+NNasZYr4a4XLM905q03QqFtqZ+gKF8kXDU2RVzj+SKyEq9D8jmCQRP7quQInDnYOTwlCykQcjCJ2mytKrirQgryVoRwVUtym+4tMe67KjJ+BAfL4rXHE5iAJRpZ1Xpvluw7tc4oJlCoYbKfMuuNv29q1ViLH5dgCzJydr3/ofcVvnIWsm8IA75Yymy1q5xvSiQJJGcfhx58PYScmQUMKNHZh3OdSpISPgpai+BG+NF5riOQ7bTKLSSAi9AuJ1mdrmmdMT4rVUOfdpcKPR7ioIosKAOgh/lfqtSr3tPLlfZuVeQkhzxtyBPQBSgEypU2pVXaHzgDRelolCaGgllYzY9ta5cEHEr0brBUmlbgzUgI7wPodWr8cVf2LdOCsIcMY1LmetJz0e34kFnLmcN3fXLETObZX9zDHqXX9O2JHVVo3tuHzzCFMBFjFuMWMTEMm/YB57xj5lwLb0AkgE5FhPEp1hbaZ1ilxZxqP/k+U2ZzbLzUffmk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6B619CD7AB99C4E8CAAEF8A0E6C568A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 eA2Xhu3+v2j4ATTNEKTOPtxn7oqwJ66/kNpPZZuLIYEHm+CeDZfuqN0FBGLVHDVnf8aqqLg0hd7xs1wBFxFC20fVbZRWH6AaT3UE7c+bn/UbQP7U1Vf3m5KP4xWbSS4dnd3B+4lP2af0avkNukIsgD2m3zch+Ak2715NoQ/9vUH59yheUr7x3T/KWogpF7/RXu0GgSfT1L2el+vJjGLR7p1FvHh32KRcVVG4We2Jqz+Hjeos2Z71isOtSQA53y4cwMDl1idW/2t8zZXXJAeANSrqledzvv5mPpHLyJyrnRx2cjNWpqtWbZeAIgGRWx6qWRMKTrXEnOLKsqkcOPS++Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8991
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a759ee76-626b-4e54-717d-08de85ac7fc0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|376014|82310400026|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RP48UOTW38zVVJbjZKgZDVobG2sQ/FoQOfKIbx/zAt8juX4bzLI/sc0CzJRvgbnejBEAp1X7ke7U88S5heh5D3oMEhPstitsi2R2wPVPA7fDliZ98bDyx4LqMH7TALJOd7zsmqCXYeRYNloCuNoj+akGQPhH4wHs/hLaQvXUY6axCqVJD3tV2b96VBRpzEgVv7eD1h6//kkYfLAApR79d8YpzSFNczNipgyKgqdwnrVSQVJs8pNdwaduFjWZcWJgSlkNRLQS7yZTvApCDKIaZGnowcUZGGLLL64dl7ih3n2o1WGqaiTcRmxpayXwo1nzaImf9Kf2FxxuxKUIfBr2DDlPGlBNJ2IkZ5FT1kJJYfbg/paRslleR58UgpaltOYsUSL/UaapbojvOKV4BfjHFCJWl8+fanlNPHjm3LNioIl1zszhGVOiecuEmM+UqVstxa+rga3T45BtxWdNVmoQx/dwoGMNWnvMueqZ1JYcpsSF+HTJdAPl7WUoRZHCAYg3Oe2IVH0r+u85sjrz3g79QvwrTYkNAfs9aHyTe+KjQLL2cL2iNzpezMM5MZU1umqa/qeOZ/Rn84JMPb14V9zI81jkEj7qpnBO3UgyPsqENSt6KkzSCHjlqafvPmmEuebwgxis/l8B7tVR4lCWH4wBuOzvBku3VRLTSm9dGOgrnpPkhrZaGlGm2IpHmiE9uSS2K4pHXqdLNnbAIggPkIkXvBrll6sAo2+/CkFR9axNwqFADMuA7D5/1rgGTljH+0vitfS4Rg3b2qmKvmXtUeoY/Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(376014)(82310400026)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cv1qkD+0ct46/eN4oLTsmSG78zbQA/oFO8a3UEC9W+3UYdq+r1jG4LtV82eGNOELGIYZkmmIyajo7L7H1YW4lxMJzQjBNge/LOqFUl8h55XiVMdJdeqL3oi15kXq1lAGXYUGGnU4M2tKwvqgLVJWYlVQUuEx+EF95gfmgsQMIyLlSJ5KVGWBd3kEHUJhIhm83CacbM6ymZcQYZ6h6J0WSD83mj1a184k0Gp7vTqqZrAoy6YyaMpY/9mCifbgcl0BOKG85x0uNuEecMlO3y7k2qjte6QJYOUtHwc9yd02gGX+HC7B2yX4RipVvlwMuPv4viE+/Jjxdnpcwr4uXqH1dZhG/3LincfSA/kYaIwGHYtF9q4CGK3MxplJ+ElX3j6fXMSsFphD0z2OTGrUsNYRU0m80lRlYpTDrIPINFMBFjhse4ry1Jpm6K9pacq7zRC8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 11:42:49.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f4a926-5cb5-466a-a1df-08de85aca619
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9294

T24gVGh1LCAyMDI2LTAzLTE5IGF0IDEwOjEyICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBUdWUsIDE3IE1hciAyMDI2IDExOjQwOjQ0ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBJZiB0aGUgZ3Vlc3Qg
aGFzIGFscmVhZHkgcnVuLCB3ZSBoYXZlIG5vIGJ1c2luZXNzIGZpbmFsaXppbmcgdGhlDQo+ID4g
c3lzdGVtIHJlZ2lzdGVyIHN0YXRlIC0gaXQgaXMgdG9vIGxhdGUuIFRoZXJlZm9yZSwgY2hlY2sg
ZWFybHkgYW5kDQo+ID4gYmFpbCBpZiB0aGUgVk0gaGFzIGFscmVhZHkgcnVuLg0KPiBHaXZlbiBp
dCBpc24ndCBpbiB0aGUgc2NvcGUgYmVsb3csIG1pZ2h0IGJlIHdvcnRoIGNhbGxpbmcgb3V0IHRo
YXQNCj4gdGhpcyBpcyBza2lwcGluZyBrdm1faW5pdF9udl9zeXNyZWdzKCnCoCBTbyBvbiBub24g
TlYgc2V0dXBzIGlzbid0DQo+IGNoYW5naW5nIGFueXRoaW5nIGJ1dCBvbiB0aG9zZSBpdCdzIGlu
ZGVlZCBza2lwcGluZyBzZXR1cCBvZiBzeXN0ZW0NCj4gcmVnaXN0ZXJzLg0KDQpJJ2xsIGFkZCB0
aGF0IHRvIHRoZSBkZXNjcmlwdGlvbiB0byBtYWtlIGl0IGNsZWFyZXIsIHRoYW5rcyENCg0KPiAN
Cj4gU2VlbXMgY29ycmVjdCB0byBtZSwgYnV0IGlzIHRoaXMgYSBmaXg/wqAgU28gc2hvdWxkIGl0
IGhhdmUgYSBmaXhlcw0KPiB0YWc/DQoNCkknbSBub3Qgc3VyZSBpdCBpcyBhIGZpeCBhcyBzdWNo
IC0gaXQgaXMgbW9yZSBvZiBhbiBvcHRpbWlzYXRpb24uIFdoaWxlDQp0aGUgY2FsbCB0byBrdm1f
aW5pdF9udl9zeXNyZWdzKCkgd2FzIHByZXZpb3VzbHkgaGFwcGVuaW5nIGlycmVzcGVjdGl2ZQ0K
b2YgdGhlIFZNIGhhdmluZyBydW4gb3Igbm90LCBpdCB3YXMgbm90IGFjdHVhbGx5IGRvaW5nIGFu
eXRoaW5nIGFzIGt2bS0NCj5hcmNoLnN5c3JlZ19tYXNrcyBpcyBub24tbnVsbCB0aGUgc2Vjb25k
IHRpbWUgaXQgaXMgY2FsbGVkLCBhbmQgaGVuY2UNCnJldHVybmVkIGVhcmx5Lg0KDQpOb3cgd2Ug
anVzdCBza2lwIGNhbGxpbmcgaXQgYWx0b2dldGhlciBpZiBpdCBoYXMgYWxyZWFkeSBydW4gb25j
ZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4g
wqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgNSArKysrLQ0KPiA+IMKgMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0K
PiA+IGluZGV4IDBhY2QxMGU1MGFhYmEuLjQyYzg0Yjc5MDBmZjUgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19y
ZWdzLmMNCj4gPiBAQCAtNTY1OSwxMSArNTY1OSwxNCBAQCBpbnQga3ZtX2ZpbmFsaXplX3N5c19y
ZWdzKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKgDQo+ID4gwqAJZ3VhcmQobXV0
ZXgpKCZrdm0tPmFyY2guY29uZmlnX2xvY2spOw0KPiA+IMKgDQo+ID4gKwlpZiAoa3ZtX3ZtX2hh
c19yYW5fb25jZShrdm0pKQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiDCoAkvKg0KPiA+
IMKgCSAqIFRoaXMgaGFja3MgaW50byB0aGUgSUQgcmVnaXN0ZXJzLCBzbyBvbmx5IHBlcmZvcm0g
aXQNCj4gPiB3aGVuIHRoZQ0KPiA+IMKgCSAqIGZpcnN0IHZjcHUgcnVucywgb3IgdGhlIGt2bV9z
ZXRfdm1faWRfcmVnKCkgaGVscGVyIHdpbGwNCj4gPiBzY3JlYW0uDQo+ID4gwqAJICovDQo+ID4g
LQlpZiAoIWlycWNoaXBfaW5fa2VybmVsKGt2bSkgJiYgIWt2bV92bV9oYXNfcmFuX29uY2Uoa3Zt
KSkNCj4gPiB7DQo+ID4gKwlpZiAoIWlycWNoaXBfaW5fa2VybmVsKGt2bSkpIHsNCj4gPiDCoAkJ
dTY0IHZhbDsNCj4gPiDCoA0KPiA+IMKgCQl2YWwgPSBrdm1fcmVhZF92bV9pZF9yZWcoa3ZtLCBT
WVNfSURfQUE2NFBGUjBfRUwxKQ0KPiA+ICYgfklEX0FBNjRQRlIwX0VMMV9HSUM7DQo+IA0KDQo=
