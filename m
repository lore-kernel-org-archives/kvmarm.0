Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010054.outbound.protection.outlook.com [52.101.69.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C23335BDB
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747904; cv=fail; b=o5qScOvu8urynzvYkQqg3WodxdAFzQdfwb8uw2/vEETAIThPGE9UWOqVIoW9J/w+gwGjwoC/kKStl+wS37Lz20iKGXYf5UM0L9rHL3nwwqqi5W5qn5OWp45c1i8panpKZoOTZlhOstFfu+yoQNQAnH+gmzTotTXvHtybPlsk6RU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747904; c=relaxed/simple;
	bh=pN+YzLySpV63CQcKMool4deeyKvPoHFCMcE3SL4+FLQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eQ33/5UsWLAMPd3ELb8nbabt8g5JAKaNTJWYTEGervWgWku1hZfh4UUytCtqdncskx7hC0U4ulYy769HnxWqi3SVvYocJU4qSpzKTV7uVqcWYmdi8I95QoLjZI+HFnVRjo31t3XHVlgcvWMR+utGgSiODPsDspYFwCJd6nBaFRE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L2bfbE5F; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L2bfbE5F; arc=fail smtp.client-ip=52.101.69.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L2bfbE5F";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L2bfbE5F"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BmI81m8u5giA3Se7XlMVZ62EfIMfZEqVJxQKf/7afCyRDFG4yZvNvyluOCC2Y2IpEA9dGT/zfZ808tkdO+xFXTC+d7jlBvuvDtT7NUPYteYpt4jhfH/eDKNe78xt8RTzXgJdAAP8I//qAceNyI5Zss5Bi1+P2fR7oqlCY/pMf0jcMcEBzlvJjKav7wxmz2VJlu1a6/0zg2Aq/pRSRl+hX5FUJlhH3ArI1cCX6HtiZybXKcZp1dOAVrMokZRZC0AJeWioyGHp/Ten+6wW78XFgnzdSMEntQETrMmbjAge178mWN+nbIu493Tym98eoE6f/IhQ9JrXRyT4knMuhGcZUQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7myYwpcioAuC96Ao4TCPtTjstQb11ELrjiUkz0fEPtw=;
 b=igVWaSyqHUqr2xB8J0c9SQmbO/1CcEGdXGUkiHR95Uxcwk+9Qv4cL1EFzhW2jiTTi+rDh6NuonyIFdQsgvx513/jfszSZ4iHkfxRRxR7UrO/3KJg1t+dnkAnIKlAsYJBg7RLIbwciVGQeF045mkL6rtXMuxJcV87ZjPJQoNBtuhk/tPt1AjLZTVxTmiprZSi7N5GK+CNKY6xHBZcMEDmHJJYdg7QDGMBHOGfoN8QQSZEPsLO3UQzmM+Zlx3+2u3m9/7rdFqyUE6md839JX6mSCYz1chynRqxZBFN1gwlq18EmTmIHwWNf8SvNgnNKdOfP3ljLEQKmm2HW/T3r4rIjA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7myYwpcioAuC96Ao4TCPtTjstQb11ELrjiUkz0fEPtw=;
 b=L2bfbE5FBKhQPI+zOG9agTMgzFhqdfugk/RJTfal6tcju8nW2otRxxvEQe9Dmq6bSg2UL0HeMkEBZrphVxKJX7EHXZCaIdDX0zVMfsKxKev0FfVLe8a2x9AbclEiuEcs9GapQ6mZ1BAdiD5wOUodcUB/8cFUMClC4I+FlWnTIeQ=
Received: from AM4PR0302CA0025.eurprd03.prod.outlook.com (2603:10a6:205:2::38)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:44:52 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:205:2:cafe::c8) by AM4PR0302CA0025.outlook.office365.com
 (2603:10a6:205:2::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:44:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0deFe7B4clSGRabE+930PdzUP302DR9qtPt0Tgtkkmmra2vVuPZrPwAcznXG3QzYcQDRvDC2iym4i2RzmiYadSzXimZHYpV+th2n+J8272llR+mOZBa+oHoQ6LlFiQBEM+yb5zTCLea57rMLQEgLaeqzreIwmjjLps1fVskvwLWCdnTRkTDAunAjhPTUdU/k/5e9eAyAa+WeLyvw7TTKe7SS448ZXlj7yF14OJHx03KG82lKwdHEBWGoa/WTGJUNyjK4TZl7xKWY7PYrJKG5+/2KsQ5Yg1wcG/8kDg5/piFi4jINa8UDqf15ZMageEp6EQ28PSwT5eIZYen7f+wBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7myYwpcioAuC96Ao4TCPtTjstQb11ELrjiUkz0fEPtw=;
 b=cK9p6HrIjF0owkjqTj5aK3v+KwsZE9/VnSdR19/CwwxI7ocZcU1dhVs3jjYgt6ZRnTV9YSnxYmSoeYh8+zxLHTcF9aPVLyUcGd52m2bD2C8YVW3jRGZihq7Vh8Ic14vliTCyaEJ+RL4rVp7I+efe+m1/VKLude2QJylbzc983bA+pJdKc/P8HUuwRJLJXsGlTfjvyw4W8NIKUFCBvnUv21UUjJipN+Tc7e52oGSbaGfvKfWeNuRdIL6+dnNcyGDTBkDTobl9jQzU+lW/XYZOcxwNqNoSa8/mB0G2mMuUoxq/aRbe45bWAP4+laPhymAk4YaS/rqq+5M41rjf3zRtRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7myYwpcioAuC96Ao4TCPtTjstQb11ELrjiUkz0fEPtw=;
 b=L2bfbE5FBKhQPI+zOG9agTMgzFhqdfugk/RJTfal6tcju8nW2otRxxvEQe9Dmq6bSg2UL0HeMkEBZrphVxKJX7EHXZCaIdDX0zVMfsKxKev0FfVLe8a2x9AbclEiuEcs9GapQ6mZ1BAdiD5wOUodcUB/8cFUMClC4I+FlWnTIeQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:43:50 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:43:50 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 15/39] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v6 15/39] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHctgNS7s1u4UCj90SDuQhv178UEA==
Date: Tue, 17 Mar 2026 11:43:50 +0000
Message-ID: <20260317113949.2548118-16-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|AMS0EPF00000194:EE_|DBBPR08MB10481:EE_
X-MS-Office365-Filtering-Correlation-Id: e38b65dc-7d00-4428-dfb2-08de841a9a5e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 W7ox7hXuutG1GtUPp72y5hH0XUNB6OtUk1pTY4zP1keVTx3Dg6SgqkaCWpgon3R6n+efZmBTKsh4KsvLceLHfyILtU15vCwQiMuyxpK1yoZdK66w8KrsOfZWrsY7C/mSdGbXBFUUeO007iWHajDGR0ju76k+2WkQMtzd/efqCEqv2ynPQNnJBNyzKJugc8D7RSs9LcpgtIGPN7zQoXAqawp44R8QCKJrPIt/heMdAhh6JAY3PasEvk5CHzlN+Jc2kOFx5DLEX+CJbeS6gdm/7d6rqroG8DrWsKXmtUjOY1F4hwbxELxxZ667pqwIsqGbQ9qCFbVTgFgm9vGVop8VPJItWXx4I4x318rQBrbcbhXfyx5BqSWOloZCvr9gDMmngPaVDEdK07Xz09Iod7LNunwoGOzURt8AGXZiFqFClJMwn6QAD+UBQBbH5nT5DR2uB+QgMaR3Zm7El4koXXtkA/cb9KKhsnRJrfnvYdh7iLOjR0UUExKll5ijz6IrfgYsfsEpPSmN2u5BGupQWrDDyRtoXasF1zgyF3/9Qi1gOnU4jWrHRKFiK6Vz1y3xVV/191rPu5KqL5z3HueVe8Y3xN6AvA6NF2VMh5goCZh1TBhd102IZ9jJbbgmXDeFlrKLAx/xjpoy2EXgCoLXyzpq6aES5rp3gMs295PYSdQ6rcMSP9HSmd/c0rWcDbXFrXj/KT5RWFTkpl6ti9aMCV0OS54J0pP7mUmQ1W4YwCsLc9u1IQAJxoaxR+OGJlcgwBXEJJvGdjDDVukzA1klDIjU3O5hCOOK7QOptanS/JUaTD4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sFDHK7pqBSgi4FfZuRqlf618Nrd2UMYbN7jiaKoINHLMfjPXyijTB2lmOoUqeIpwLsrMxpKFjwwDnAbDqqUN2NhZnqgM1VTBIxntA8YflmtRYw7Tdqby4DYvSi6kNZnytdh0og6AZXURNel5NaGargWHmDWbdF8Fpxk/96ibhfk1PThuz/o8I4zWrMKIR22iAleW3gOQ9fv33FMbRY5qkBJHWxJPhT6E/G6zyM17Ln5UiTzUYyS/l2Lp1+0abSPjj2GCtZGkTROksgh+xZlwQ7qHRALPVtsn1M5D5qwjwa7vtwM70JenzV+k28WgWv1BKB8XXo40za3RE068oKcHUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	03f68d4e-3b74-47f4-8c6d-08de841a7510
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|36860700016|82310400026|35042699022|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/6cGs2hOuyLZaiHU0QDZokDu8kxI3S71AdNfAt67wqIP3CvQio1u7eZB8KpjLrIyFsL9OInuD00dlzG+Mn8vdVBiW+x+BHH4S4aRcxscRlmee3XdqC8gsdIyui4ZRzatMPpggs3WKJClfxkX3UjyuXCPEb4/VRFOxpCn6hw5EGpb6TSGRQvaxrHJQvvV7zaAy7yhqsk5tmRpJO+Xhck54nfyNi/Qqj47m1LMsmmlo70woRGFaPeoRqS9K5qso6225ojtdvOYXUDTrDIFRYy26eQWupkMiUPDxKxOlCBbkPCt55IQS/vTI0K0TSOtoteln5CQBvwXj2RNp36w7xQzfk2k7rvQOBYcMj6IgFaPIbuoRqCIM7JQ7eILF9rM9455WqI1g6/OkWll6T21GipN6UotJlxui8oJN8i5PxUmnIP1tjx/VIwN8WUzX3ckvQP/hHk1G7TU2BQtBNyj4Vh9S73xLthkS1HzbK6QvMmamrwpa/B0zlzDJJxH6r46Aw74R+udjG7QTZPzcRlpwI6z5xPF/oqTdCnDQyVbD+9ixd7pyIji7g215fpUohpOWBRKDRigHneGOC3LVwha+usXBO2fN4JGfhNlzcyMGGDnCES/C/2CPBiGS0UY0jESkdMNDTWnQUO/d1/kVW9VW0cB2sQMjWPYln0TfgPqhOtaTZQAq5gIdDF3l/o3JK7o7qIKzNbvoELEfGlpHpg02h7Hx2CVafl8dN29EqPQNJMnCDs4YQHFX6Sv3DyQNTQd8emoyN0vQWTiYXfSp6AFDbDaQw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(36860700016)(82310400026)(35042699022)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Yt5U186kvgJBSBL3g0qU7sD1UklAehr25bNXUPQzxc0hcElXIrpOuvPxJ0ezRnXfHpP2ZjOIzQkeSZ8iqcTzoXHXHieMbJka+eZvSU4us9cId83iSqS3BpcxwOGqOR+nAT7DrLweblfHtAu/tLPmLzS2wsIDKtdQUZ4B4KbGaLkWbDJHiIsLviKCzQcXh6b9EDA/F0wGyGo6xdr6X+G1/3jurvV7o7QxVm7G5y5PkRYzIeCvwBpV5r7BrMvzmGuhCyWs5TnMZ8/scGblwQJ7FvUyXaDL+mqdxgHpNKxz9XxnnCTHDOWJ6T5QqLQZzwuylwBCtVQei9nAyfS1e8mLgQSaIVZ2uv/X3Vm1xjBFtUp0ApT7Eua/w3ndxqAZxwbiMOu0hU5cTY7Evsk77OCmjPgvQSm4X9SeXvzV3+RQnISvdawWIdbC0QCrvJahD5f9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:44:52.6025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e38b65dc-7d00-4428-dfb2-08de841a9a5e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481

Introduce the following hyp functions to save/restore GICv5 state:

* __vgic_v5_save_apr()
* __vgic_v5_restore_vmcr_apr()
* __vgic_v5_save_ppi_state()	- no hypercall required
* __vgic_v5_restore_ppi_state()	- no hypercall required
* __vgic_v5_save_state()	- no hypercall required
* __vgic_v5_restore_state()	- no hypercall required

Note that the functions tagged as not requiring hypercalls are always
called directly from the same context. They are either called via the
vgic_save_state()/vgic_restore_state() path when running with VHE, or
via __hyp_vgic_save_state()/__hyp_vgic_restore_state() otherwise. This
mimics how vgic_v3_save_state()/vgic_v3_restore_state() are
implemented.

Overall, the state of the following registers is saved/restored:

* ICC_ICSR_EL1
* ICH_APR_EL2
* ICH_PPI_ACTIVERx_EL2
* ICH_PPI_DVIRx_EL2
* ICH_PPI_ENABLERx_EL2
* ICH_PPI_PENDRx_EL2
* ICH_PPI_PRIORITYRx_EL2
* ICH_VMCR_EL2

All of these are saved/restored to/from the KVM vgic_v5 CPUIF shadow
state, with the exception of the PPI active, pending, and enable
state. The pending state is saved and restored from kvm_host_data as
any changes here need to be tracked and propagated back to the
vgic_irq shadow structures (coming in a future commit). Therefore, an
entry and an exit copy is required. The active and enable state is
restored from the vgic_v5 CPUIF, but is saved to kvm_host_data. Again,
this needs to by synced back into the shadow data structures.

The ICSR must be save/restored as this register is shared between host
and guest. Therefore, to avoid leaking host state to the guest, this
must be saved and restored. Moreover, as this can by used by the host
at any time, it must be save/restored eagerly. Note: the host state is
not preserved as the host should only use this register when
preemption is disabled.

As with GICv3, the VMCR is eagerly saved as this is required when
checking if interrupts can be injected or not, and therefore impacts
things such as WFI.

As part of restoring the ICH_VMCR_EL2 and ICH_APR_EL2, GICv3-compat
mode is also disabled by setting the ICH_VCTLR_EL2.V3 bit to 0. The
correspoinding GICv3-compat mode enable is part of the VMCR & APR
restore for a GICv3 guest as it only takes effect when actually
running a guest.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |   2 +
 arch/arm64/include/asm/kvm_host.h  |  16 +++
 arch/arm64/include/asm/kvm_hyp.h   |   9 ++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  16 +++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 170 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile    |   2 +-
 include/kvm/arm_vgic.h             |  22 ++++
 8 files changed, 237 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a1ad12c72ebf1..44e4696ca113e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 64a1ee6c442f0..c4a172b702063 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -800,6 +800,22 @@ struct kvm_host_data {
=20
 	/* Last vgic_irq part of the AP list recorded in an LR */
 	struct vgic_irq *last_lr_irq;
+
+	/* PPI state tracking for GICv5-based guests */
+	struct {
+		/*
+		 * For tracking the PPI pending state, we need both the entry
+		 * state and exit state to correctly detect edges as it is
+		 * possible that an interrupt has been injected in software in
+		 * the interim.
+		 */
+		DECLARE_BITMAP(pendr_entry, VGIC_V5_NR_PRIVATE_IRQS);
+		DECLARE_BITMAP(pendr_exit, VGIC_V5_NR_PRIVATE_IRQS);
+
+		/* The saved state of the regs when leaving the guest */
+		DECLARE_BITMAP(activer_exit, VGIC_V5_NR_PRIVATE_IRQS);
+		DECLARE_BITMAP(enabler_exit, VGIC_V5_NR_PRIVATE_IRQS);
+	} vgic_v5_ppi_state;
 };
=20
 struct kvm_host_psci_config {
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 76ce2b94bd97e..2d8dfd534bd9d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -87,6 +87,15 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
+/* GICv5 */
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
+/* No hypercalls for the following */
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index a244ec25f8c5b..84a3bf96def6b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y +=3D ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index e7790097db93a..007fc993f2319 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -589,6 +589,20 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -630,6 +644,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__vgic_v5_save_apr),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
new file mode 100644
index 0000000000000..f34ea219cc4e9
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 - Arm Ltd
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <asm/kvm_hyp.h>
+
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
+}
+
+static void  __vgic_v5_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	__vgic_v5_compat_mode_disable();
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+	write_sysreg_s(cpu_if->vgic_apr, SYS_ICH_APR_EL2);
+}
+
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	/*
+	 * The following code assumes that the bitmap storage that we have for
+	 * PPIs is either 64 (architected PPIs, only) or 128 bits (architected &
+	 * impdef PPIs).
+	 */
+	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
+
+	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
+		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
+	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
+		     read_sysreg_s(SYS_ICH_PPI_ENABLER0_EL2), 0, 64);
+	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
+		     read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2), 0, 64);
+
+	cpu_if->vgic_ppi_priorityr[0] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL=
2);
+	cpu_if->vgic_ppi_priorityr[1] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR1_EL=
2);
+	cpu_if->vgic_ppi_priorityr[2] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR2_EL=
2);
+	cpu_if->vgic_ppi_priorityr[3] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR3_EL=
2);
+	cpu_if->vgic_ppi_priorityr[4] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR4_EL=
2);
+	cpu_if->vgic_ppi_priorityr[5] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR5_EL=
2);
+	cpu_if->vgic_ppi_priorityr[6] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL=
2);
+	cpu_if->vgic_ppi_priorityr[7] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL=
2);
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128) {
+		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
+			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
+		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
+			     read_sysreg_s(SYS_ICH_PPI_ENABLER1_EL2), 64, 64);
+		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
+			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
+
+		cpu_if->vgic_ppi_priorityr[8] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_E=
L2);
+		cpu_if->vgic_ppi_priorityr[9] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_E=
L2);
+		cpu_if->vgic_ppi_priorityr[10] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR10=
_EL2);
+		cpu_if->vgic_ppi_priorityr[11] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR11=
_EL2);
+		cpu_if->vgic_ppi_priorityr[12] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR12=
_EL2);
+		cpu_if->vgic_ppi_priorityr[13] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR13=
_EL2);
+		cpu_if->vgic_ppi_priorityr[14] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR14=
_EL2);
+		cpu_if->vgic_ppi_priorityr[15] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR15=
_EL2);
+	}
+
+	/* Now that we are done, disable DVI */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+}
+
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* We assume 64 or 128 PPIs - see above comment */
+	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
+
+	/* Enable DVI so that the guest's interrupt config takes over */
+	write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 0, 64),
+		       SYS_ICH_PPI_DVIR0_EL2);
+
+	write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_activer, 0, 64),
+		       SYS_ICH_PPI_ACTIVER0_EL2);
+	write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_enabler, 0, 64),
+		       SYS_ICH_PPI_ENABLER0_EL2);
+
+	/* Update the pending state of the NON-DVI'd PPIs, only */
+	bitmap_andnot(pendr, host_data_ptr(vgic_v5_ppi_state)->pendr_entry,
+		      cpu_if->vgic_ppi_dvir, VGIC_V5_NR_PRIVATE_IRQS);
+	write_sysreg_s(bitmap_read(pendr, 0, 64), SYS_ICH_PPI_PENDR0_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[0],
+		       SYS_ICH_PPI_PRIORITYR0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[1],
+		       SYS_ICH_PPI_PRIORITYR1_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[2],
+		       SYS_ICH_PPI_PRIORITYR2_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[3],
+		       SYS_ICH_PPI_PRIORITYR3_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[4],
+		       SYS_ICH_PPI_PRIORITYR4_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[5],
+		       SYS_ICH_PPI_PRIORITYR5_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[6],
+		       SYS_ICH_PPI_PRIORITYR6_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
+		       SYS_ICH_PPI_PRIORITYR7_EL2);
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128) {
+		/* Enable DVI so that the guest's interrupt config takes over */
+		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 64, 64),
+			       SYS_ICH_PPI_DVIR1_EL2);
+
+		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_activer, 64, 64),
+			       SYS_ICH_PPI_ACTIVER1_EL2);
+		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_enabler, 64, 64),
+			       SYS_ICH_PPI_ENABLER1_EL2);
+		write_sysreg_s(bitmap_read(pendr, 64, 64),
+			       SYS_ICH_PPI_PENDR1_EL2);
+
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
+			       SYS_ICH_PPI_PRIORITYR8_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
+			       SYS_ICH_PPI_PRIORITYR9_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
+			       SYS_ICH_PPI_PRIORITYR10_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
+			       SYS_ICH_PPI_PRIORITYR11_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
+			       SYS_ICH_PPI_PRIORITYR12_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
+			       SYS_ICH_PPI_PRIORITYR13_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
+			       SYS_ICH_PPI_PRIORITYR14_EL2);
+		write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
+			       SYS_ICH_PPI_PRIORITYR15_EL2);
+	} else {
+		write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+
+		write_sysreg_s(0, SYS_ICH_PPI_ACTIVER1_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PENDR1_EL2);
+
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR8_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR9_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR10_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR11_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR12_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR13_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR14_EL2);
+		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR15_EL2);
+	}
+}
+
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_vmcr =3D read_sysreg_s(SYS_ICH_VMCR_EL2);
+	cpu_if->vgic_icsr =3D read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
+
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index afc4aed9231ac..9695328bbd96e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -10,4 +10,4 @@ CFLAGS_switch.o +=3D -Wno-override-init
=20
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 24969fa8d02d6..07e394690dccb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -428,6 +428,27 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+struct vgic_v5_cpu_if {
+	u64	vgic_apr;
+	u64	vgic_vmcr;
+
+	/* PPI register state */
+	DECLARE_BITMAP(vgic_ppi_dvir, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(vgic_ppi_activer, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(vgic_ppi_enabler, VGIC_V5_NR_PRIVATE_IRQS);
+	/* We have one byte (of which 5 bits are used) per PPI for priority */
+	u64	vgic_ppi_priorityr[VGIC_V5_NR_PRIVATE_IRQS / 8];
+
+	/*
+	 * The ICSR is re-used across host and guest, and hence it needs to be
+	 * saved/restored. Only one copy is required as the host should block
+	 * preemption between executing GIC CDRCFG and acccessing the
+	 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
+	 * it is the hyp's responsibility to keep the state constistent.
+	 */
+	u64	vgic_icsr;
+};
+
 /* What PPI capabilities does a GICv5 host have */
 struct vgic_v5_ppi_caps {
 	DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
@@ -438,6 +459,7 @@ struct vgic_cpu {
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1
