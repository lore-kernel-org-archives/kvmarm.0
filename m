Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011037.outbound.protection.outlook.com [52.101.70.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8513346B4
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375326; cv=fail; b=eM+H6cDdrR9gI2of+GRVZFUdv01iGxepLtHOMI9yyNF2KF98yGuXvGQ0tSjptQn+45LVLS3I27QB+V7mpPV0bCNgZySYZkKpKnlX4tKnZG9/fVXcCWKQQg5EOnCO9qSt8g+yezH/85nD52vA8NK8gtmuRbRQQoqJYTPNHlTbXjE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375326; c=relaxed/simple;
	bh=pLazq8QAaVQADNagRpm7ZJzuaMUUqHYw4YK8+/rCGwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B0djFRbGI3mgJOfcGXWUq7k2YshqhrGL5l9nYUnNpuEkZR+WGmohbWbTqAa1ONP9NbDORu39m7f7klp5J7PwU50wWgH9cn8CpoQtTrwsyx8p3Ey1r9KH7sHKpkHvqeHZyW2deLyL5MJ/qwfpJqK3jwcBwmPxfL7KFvjIbvOeUeQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVsafmgD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVsafmgD; arc=fail smtp.client-ip=52.101.70.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVsafmgD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVsafmgD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=JGUqhYEWEFDl5uW1ase3F1bcSsiY1s6I9zzfdGktgTbFrXHRDLVNOV8TkV9US2k/y8Pu+aiMbBlYcxnXESP70bIT79wZ0BT1bPRkP/gRn0THBR2rb763vSTi/YDN/2uDwm4NOaa2rSzNWPvVnQqLIQiLT0bieoLqNM5D2wJ352Z1oDQKarEipTxz9zEq878vgT6+sJMdtf1u0FxVuf9rto4UT3hW/V32NvsmVqJCLkjePX17ooNE3OgKh4wQniEi+UH2kxwYgCiUCRUJLFn+ahzBdo5zpH0XH3PVzW66G9td51njkPx8US0+9und576U+w45jFAtF08Udm0i5SKgrw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AH1h0N/pmJ1K31WmMjaDLAN1pkCmYOtRrzTmMiIvvBo=;
 b=n3tejx2iO/djJjGvoLcp4EWCwSvC7h4e9HAodJaObdDZ8kie9qDBCKPAHE2RZoU29JYCM/zgAwaLepIXSmNojaFisRJE5hD4SJg9rUkSPt48FD/GUFm83vi5dbKhJmV6IES08ZR6Kpb76Uw+SqeLVtySSYaICQbBCOZgv4uUOXVRUYOEw9cUBOb+XjgEf4U6hu9wuXtHHcJurIdV2AWi/82aIrBNOWhs9Qclf90bmwXhrvlK3EoiV4/fgf+wY0jybAlLmlUypOsLQAVACCLA5KWsDSigA7QkI/xYcNmnu4OIVt4EZEo4H+lTVqaLq+ADtka9nrRDq6BvAnDbknO1GA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH1h0N/pmJ1K31WmMjaDLAN1pkCmYOtRrzTmMiIvvBo=;
 b=hVsafmgD/xNQw6vupbBpzxDQ/obnMjMFUWITjWBzlBtvjpmGKDTgeZPo7hnoTZvoiw3RNaR2+OoAS9aYfMq2vwKncCH8SFnUJTiJiSINt3R33/O/uS+FepWRCUqqS+3lUCn6fr63I4XE2G3jNU2JXD9lj8LnG7UouXlR7HxiWkU=
Received: from AS9PR05CA0202.eurprd05.prod.outlook.com (2603:10a6:20b:495::31)
 by VI0PR08MB11405.eurprd08.prod.outlook.com (2603:10a6:800:301::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:55:19 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:495:cafe::80) by AS9PR05CA0202.outlook.office365.com
 (2603:10a6:20b:495::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:55:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORo0obt+9b1CaE9zIVZnt/+VOOC5B38YzVglTPoO2ByA+GaD1gctk98VPVuLF8MMTPuD6+XZMgTBgH5hhdDJdrOMmMOeYuwXX2z5hovAcmYeRqsSpBE/aiZ3Mml9G3Qy5JVdqZaMgM+RTnhdki6COXLQ/An5tcSg215z66M/Dz8LuWFm5mxjHHh6XY9CJaaJWo08heo4lLmEnVzxp7w8eUsjjMCaZiqXOGShEHFVb241+T53nYbXpBpbdK7LMKqv+8YDtp/fYi8oTNCdInR4rrUrrZdPE7uIWTdPXLmiQ0lgnp5T9SfwAS6IioeSVs/k4/HJImK8Kb6UJdjjyfU8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AH1h0N/pmJ1K31WmMjaDLAN1pkCmYOtRrzTmMiIvvBo=;
 b=HgS504xU1yscxKV7/tJXHi31Bpgby8+2TioIf2N/h6uShtOuBAREjBjULhi+sViwNew3pGrHBX8X/oH7R+pKJ78ulI6UWnh+5hQejK9f0ipFvJBO7J+MJN/86SJbhqv04p7ZmtUc3yJVEOR0U37dD5Br5qTx1REGM81D9qfFbSbF2tjrVVRtbxXxy3gvLRbeYr6CDIxzNizW1RyApXevwuO2n6nN9dbdrMGPkqJuRYMlbICTkAyNznciBtY4trhv2EV1sN7ckQAanf2hcP1vLdfXjH40UzyZPBIIQiqWMV7Vw1yU6V1Bl6boqWQd74L/+B8WnPGG7AWqN35Okhz5PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH1h0N/pmJ1K31WmMjaDLAN1pkCmYOtRrzTmMiIvvBo=;
 b=hVsafmgD/xNQw6vupbBpzxDQ/obnMjMFUWITjWBzlBtvjpmGKDTgeZPo7hnoTZvoiw3RNaR2+OoAS9aYfMq2vwKncCH8SFnUJTiJiSINt3R33/O/uS+FepWRCUqqS+3lUCn6fr63I4XE2G3jNU2JXD9lj8LnG7UouXlR7HxiWkU=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:54:17 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:54:17 +0000
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
Subject: [PATCH v2 15/39] KVM: arm64: gic-v5: Add resident/non-resident hyp
 calls
Thread-Topic: [PATCH v2 15/39] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHc6TGyO6LETXlNIUKBRvtdgXBGjg==
Date: Thu, 21 May 2026 14:54:16 +0000
Message-ID: <20260521144846.1899475-16-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|AM3PEPF0000A793:EE_|VI0PR08MB11405:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bb1e87-5b88-4ffa-0c27-08deb748fa22
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 94SNxZ3zcyyM6scvA9/GnSybS8Gn6U2WpUtEHC9gtctGBVb67jzoSbKEGBCgrYNMb6wN4n1jxC5NIAX+V+CMg80oIKb15OPbdzxPQiT7sCSTU3EyAPbIkFSPRKp4vXiyYJ0b7fYa2IV7wSKtH0obEO4ktFgmoDC5WsJdTFJYouGnX1Op2UZzcdKDdB/AQgHqfxJmWtdUjbWxOKLHirKqjpf9YjOVYQTuT3VejjucIdsimndhevpzInKYKqQrzehT+T/Q09DDdbddDi488cchM87wGhzWAfCwGDNnKGycqL7uBpj29CCA9GD4AmhONfzX0gCryeHivoXEO8aBs9PfDdU/iwT1v7X1NcIUExeIvcX/u99Wi8wOEmzYafCXMjY7H+MvnubFYvrDz4CdQGhGoSwpkuu+ynCpzBkriv5SqFEHRpe40PJgZTJKd0TNKIeu6He0LSHwtU2wdJ4PqDeQx49kHfvWXScGnBIY4jypx3hpFeE7gAEOHjv8FCFkw3EnrfiBsToLKhKFoHLF8CwsMjK+9YU9di/vk8GJXjvb4v9K9A0L9VEgq1bc5pPHV6TsOQDpfC1RjyyuiOXZ9zyd5w4U820ojwp2Yo635XQqFQCuQZuEPA8iP0igWgY+nd07hmhFR1Qp1QAy7Z1pY8KqHAs/3bi6MtBOFVSRqRr5P4QXVF91iZ7b5TvX5c1WEvCimWPZaDSNOcCxnrIBQb/F1b/pns0ucVvWFnbQH7kMGUoPKfgTvlNF7EN8L38dBlm6
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XeMwsR55c/Ka09h2mHc0NT5V2OAxyWugeLlKmONLp1spUKnvo77gcxY+qW2rDpelHrDYcpnNzALVid9T9OtzvmPb7QkPyAOaQu16cdU1Qf3Q6u7/dlBavTDy8HlwS6zMbPhTufPRMpJEsVf7KRsiucWcjI+UkJnpHJh5AAYFpEfHXssqIE/zojBz1nEupH9Hd4WLllpR0ipukhjXUQg56yX2ZpjBKOxArIM9Z98fg9V8IlwHipv1yKpg1r8fRXJp3dxDKkPbfJEuWrIR4AC2yuT9HT9t68Wu4Sj/7oW8KfxyIu1Dk+Nk3BLn4RGEOJFjANi3H/flZ3Ljlh1TY6txAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	af74c87f-fb92-4c02-39ec-08deb748d4da
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|14060799003|82310400026|35042699022|376014|56012099003|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZWgjvQsGCmSaCWNOvuqTt0a1IDpYbcXDZ0EirAAyaWOTh+uOlwl6ZxnzMy72NaNqYUCb4QGWzp+Eeh0gMN61BMbAlIdoL7D3+1Xb4cQvnVPx3GN0lW6nVPIhM3pTg+/nTRG8Otpzhh3MX6KWEJWsSoEm64PbJ8HuFPQCH3TlbRrzBArNkHGfZsPZ14gzqYpuxC8ETWSqINY0+zm11sdYXX20A81VFXkWrejKouLeNR8syaWMjuCKvX0Ilo4oivCGtvJQju5UEQSCrNHUv6ibLzNt/w4pM7/iI1U1TmyAH/P685cDIYD8wlU8bdbTEKCWHJBnz5d0can934fo9BI8qQ6cF4zYi9h47UpP6vwLjggqVbWrE6uFLlqj0lMmktsMGDqDtxO2I26sPW9OWZwu/txrk5sRzY/exkFxxgNE6eD3OX7lgMiJf7Rwve5ftxuay5objuQr3t7g8L6vy1aOmklBsbl0bccN0lKDnMZLkWBRk2xfY0pSceIGjnO1RuVHmnLEi19XcUSKPvwUdv15+S67wk+eJYA8Yezb3JTA2NX7ZWSD7xzkxzgJJTpTBj+I6mg5jGAjPsWbg45rtFlXvr9JD1wxGx/YN27W0whbnV8DhI2wDFmwBJqVYpppJnfBoqRVBUKlgBIyqJwC0d+QD+ZjFyAseL1RwBfzdfyu4U3NRVZiADMtNx3spKlAafHNRSP9UzWFVP3ayUFaJdM849ULRJPJ5yvux9ncu0OarSA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(14060799003)(82310400026)(35042699022)(376014)(56012099003)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mFBt05PlF+eKAHhM6Diwzd9kFjxUlKZ2iFMReZHgSBjeT5Y1jtv/mGy+3jPCy6aDZIxRnZIB9832kALuyDOVwiTz8hfmpRX75t/JlUrYtos1OUw01gFjTs1AYr9v3P6mfYSbHFrQy2OF9++lH8ZV+H5C7Z6ocKwsOMjy/ypSd2iLLFelUhAr4F90AH6pzoOtUY+phzv2po5yDOOi9etjHBlHxS8gVGWueXEZzL5N5y8nHMKr86fruEBpmwDFnG6JZvLX2UEGHPppzyHKFq7doVBET+gj1crlY/G33Y5C4F8JcndAFvWIImcl3VjJvEo+jUM5AX2tKcUBFKd3BK48GJpNej16NY0xiPl4KJ+EZ4VmucbbPkMFZ4uwVrdsgkJzLQPvvJn+4pe9tM1qZUF0mqM/nrRu3H2kNTgsr1jkRv++6Yn2PgL99jHmdl33WxxM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:55:19.4249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bb1e87-5b88-4ffa-0c27-08deb748fa22
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11405

GICv5 introduces the concept of VPE residency - a VPE can be either
resident or non-resident. When the VPE is resident, the IRS is allowed
to select interrupts that target that VPE (or the VM) as the HPPI
(Highest Priority Pending Interrupt). As the IRS handles both SPIs and
LPIs, these will only be picked as the IRS's HPPI when a VPE is
resident.

A GICv5 VPE is made resident by writing ICH_CONTEXTR_EL2 with
ICH_CONTEXTR_EL2.V set, together with valid VM and VPE IDs. This
informs the IRS that a specific VPE is running, and that it can begin
HPPI selection for that VPE. Making a VPE non-resident (by making the
ICH_CONTEXTR_EL2 invalid) informs the IRS that the VPE is no longer
running, and it stops HPPI selection for it.

This change introduces two new hyp calls - one to make a VPE resident
and its counterpart to make a VPE non-resident. As part of making a
VPE resident, the resulting ICH_CONTEXTR_EL2.F bit is checked to catch
residency faults. Such a fault indicates a broken VM/VPE setup, so
warn and mark the VM dead.

Furthermore, this change extends vgic_v5_load() and vgic_v5_put() to
make the VPEs resident and non-resident, respectively. Hence, the VPE
is considered resident for the entire load-to-put interval.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 16 ++++++++++++++--
 include/kvm/arm_vgic.h             |  3 +++
 6 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 043495f7fc78b..d9ff9c2999aa7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 8d06b62e7188c..5f9184276b04e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -88,6 +88,8 @@ void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *c=
pu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
 /* GICv5 */
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
 /* No hypercalls for the following */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 06db299c37a89..555275736fa77 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -672,6 +672,20 @@ static void handle___tracing_write_event(struct kvm_cp=
u_context *host_ctxt)
 	trace_selftest(id);
 }
=20
+static void handle___vgic_v5_make_resident(struct kvm_cpu_context *host_ct=
xt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_resident(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_make_non_resident(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_non_resident(kern_hyp_va(cpu_if));
+}
+
 static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
@@ -719,6 +733,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_make_resident),
+	HANDLE_FUNC(__vgic_v5_make_non_resident),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 6d69dfe89a96c..f064045a31aee 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -7,6 +7,32 @@
=20
 #include <asm/kvm_hyp.h>
=20
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+
+	/* Catch any faults */
+	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
+	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))
+		return;
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	/*
+	 * Make as non-resident before actually making non-resident. Avoids race
+	 * with doorbell arriving.
+	 */
+	cpu_if->gicv5_vpe.resident =3D false;
+	dsb(st);
+
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+}
+
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
 {
 	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 08f2411c0a134..25590cf5ebee1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1038,6 +1038,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1050,7 +1052,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D true;
+	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
+
+	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);
+
+	/* Failed to make the VPE resident? Bang! */
+	if (WARN_ON(!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr)))
+		kvm_vm_dead(vcpu->kvm);
 }
=20
 void vgic_v5_put(struct kvm_vcpu *vcpu)
@@ -1068,7 +1078,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D false;
+	cpu_if->vgic_contextr =3D 0;
+
+	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
 	/* The shadow priority is only updated on entering WFI */
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6f736094a0e7e..faecde764fea3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -536,6 +536,9 @@ struct vgic_v5_cpu_if {
 	 */
 	u64	vgic_icsr;
=20
+	/* The contextr used to make VPEs resident and non-resident */
+	u64	vgic_contextr;
+
 	struct gicv5_vpe gicv5_vpe;
 };
=20
--=20
2.34.1
