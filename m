Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011056.outbound.protection.outlook.com [40.107.130.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EEC368278
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748150; cv=fail; b=K2lTHxwPKTSlaA3XcE0Nz9Os2A18FwQz+IOkkpM/9QrZux3RCqJaXEEY+AH1Ff1fHDgeUSvkBsIKh7P9BiiBr38jK7DEMI9WCQvZGgQTDz8+2MWROX2GOQD7d4OlVggVLTarS4ZfrwKCSMCk6u6jAidW9YjJUNWhibyjLmXxkiE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748150; c=relaxed/simple;
	bh=+MHIF5c+2vRDKKGrJcQFZrxNJW1Z2TEyEwmeZseogyA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MVsw+5U/0MeGNiWfO0xml9/WCf3YnHwZ3HvucXnnY6aEp4fsU5yZ5DzZXFb9nr733swgSt32i5Sk43E5n4wdT1i0KCdv2sptnhXSRDRLRBhyxvMycK/CC0Yqi9HRN14TNdJ7FDyLi8i17xwHMcGwoLAwx8C1ISyBrSlZPWBa6oM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Opeyd89f; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Opeyd89f; arc=fail smtp.client-ip=40.107.130.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Opeyd89f";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Opeyd89f"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NmtcTfj7JlIOXRbTPNvoSdLfQ1mVEiz05kZ7Fm8BFil6Sfe/LX8JRs2HviDwd4h26nEl2fqw09fy+pHyWpMq4ZqulkIXnG5VGbJ3CuTRJhoHDdb4tH8TWAiM6REoeEzJp6cxTTWBA3OQu5/rUsXM3ssaN2ywMC0DqHnBogWtt7kLeMCd4TAeyf7mE47CmjqX00pi7EvMsmuLolx7zYZGrcGUmA85/BkEX8eFXIJvG/twGbj93pc0BjFtfEMl/aRNnC6gdUWrP0HpLMpV0hn9223GBd9WKYma3HZ1FqNJYZZWu7VDaEdaPATfCq7PbbGSCzacUqjEmJYF3fE840vSAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=Zes7svW5HfAw1rlcf6y+UxJFLvE0m2CkV1X3Yp4SPDXk8H81vwHUHRXF43fHV1gNYQyyV7gPTA0ceHYIvIbfgPMFvzCCX0G4QsEsiSgaKX3bhc+R40y/tUP0Mh4aBD0LTj0EuXkwHzxjRt0jMdZJWoM+VmS0mKIVGAO4CD+UvMVfIwctd4PqGXpQzYDcbDMoca21+ogTFH4VUc4mROaiIBonzBi7i6iIc4o2F4T6DEz5deS6McGDs4dS02CLG1NusrS/fqvMRB6ZGT7x/oSUZTpRPpVj4S4QjdHzt4S5nghDDn435nxEKnmmdRifFzZl8JCZph6DyxY+tscAdsKu1A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=Opeyd89f57DbeICacdBfvWueKfkpECa0egufGFwqxflEiMtdQ5rTdDaH4YhJstKHbhXS8vSzQGXXYpjGMAXC4VMbwel8Y85eNWXf7GloFYIUlX0wkc62802x6s6az7DBL2I8KF/4igIfwzMfDgNWxHfFpM/tFC4ycu2/yUzvvVg=
Received: from DU7P194CA0007.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::30)
 by AS2PR08MB8902.eurprd08.prod.outlook.com (2603:10a6:20b:5f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:48:49 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::44) by DU7P194CA0007.outlook.office365.com
 (2603:10a6:10:553::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:48:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Tue, 17 Mar 2026 11:48:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpa4elInoxsKji0iW+8SlkX0KATlo0VpHF5tFJIwn72h5fpdPiDl9i4OUzJ/7zv1MGO0vC4OaemWhRIgo6O4NgTs5GPSBU9yZu6GXjGqJOV7gcesHl9su5Mj6//YuN8o//NaLFX85DTslKMFhxSNbNS4JYuK/CLfjayrK7OW0v8YI6wCdXk2F6GBgFAbjOnShgDrwGGEJg2Ptk+qd2DILCKr6EPY28ziFmFc4Fu36tvK7HYHXOr7ymYv5sT8iZ5AYnZHkQApKVU7XWJlIOh9Yrq2dp1bzD0CD85RIEORHN5upWWOsEhLt+Rmz2GReT3yW5t4obNRlgx5GaBPc1TlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=sg3UD/zbaAdlAcEPT7jwBzWuXnZpH6aoEuwUqtILjFeRYCXOw5VxL0yZhR6LAK1vyUljWf9f8IPqSy9ZCwNJ+Cts+tj5MSI3Aey5OjwzR9U4tVN1jzQ3dss5NxLYuNkPKdUckl7UoBue5PSHLXKDj2OEMBSTtXNOp9ZvN9Laq5KCAvlxJ2Ex75gIf9/nGdPvyy5XxFnPDi6StqZ39SXZ9e1NJ1zqVs7zrLitYg6JYvnoSXUjF+xnu2mkre4Jgve3jJdnDWVtnXnl0Rkk4Q8Y3nXdUjdka8VLr6Uj1dPPmwf5JmjUwloLsCbaxMoQn3eNy62z8d3lynqCic7dxxqqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=Opeyd89f57DbeICacdBfvWueKfkpECa0egufGFwqxflEiMtdQ5rTdDaH4YhJstKHbhXS8vSzQGXXYpjGMAXC4VMbwel8Y85eNWXf7GloFYIUlX0wkc62802x6s6az7DBL2I8KF/4igIfwzMfDgNWxHfFpM/tFC4ycu2/yUzvvVg=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:47:46 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:47:45 +0000
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
Subject: [PATCH v6 30/39] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v6 30/39] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHctgPeBect9hTnAkuq8LvnvaCDdg==
Date: Tue, 17 Mar 2026 11:47:45 +0000
Message-ID: <20260317113949.2548118-31-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DU6PEPF00009523:EE_|AS2PR08MB8902:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1b7955-e7f6-4e45-e5a9-08de841b2783
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 oDiSIhd044dhPxcLKmt+f+BaIM82tcL276oGlqvwEpLLBzQ5TYl4j0v+PaS/AV/5KN0p9DUI2KBQr34pDw9VaIJ1zSypBIxi/nnf0feKSMzdRkRY/BQphS0XqGN8SPtw9EXoB4Rvu1mcAiYPSLqBZy7sF2xjlahrz81X+Tq/MItCK5wuenMY3YmpJdF/kmmDGH5zZ+1n/OwBebe/a3NfE6WXPCMvTi+jNcQ7kDeaM+26mpkC01vsJb04CywOBrigVHOw1rosqXkSb405Onr4fw1GFqbvkirQI+LjKULsFMM/4gnYf9XkqZeDgdIg0+feKF8nDEO1WAe0G2O6itzTMLcoyr9Um7+QEZfkoxe8j9UaHuHk1+fwykE3xOdphHS1/mV2m0SpE7wItNJaziKOJHjXsZN/XfaDCVla24CqlLxPyA+AV+wrqHuyn12sEHTaawZ57mVzIXFuARRQRgxne/tnEZabR2QnUMMec2tmrNy7qgw7J01n0cTAfmY1vn7oFxqkAHvOfroHA6Amy2+qG4JmccS1wLoiiw9E65m8b7d+d5VeN0ryttPw+9kXhYoFAM8UertxbBHrwdrYV0Ek6HwwoR74CQXcKdDyBM4pt0qbx3WOq1HE1u6h+D0RJu/HqgOuQ1QQi5sZujw9KwB4s1h8CWQlkcv5O5618uaVQmHqk/+WArRQs5wwusPCh1oGE4QkVzubWWh1zxR2EDcjwE0VdC3fn5wQNEwHmnfj5ksdocXjsKjFmXsJYDx6GJOz2kEL9ThoiVk6QhiCha5Aq2DtHKVV4NSI95dPodLvP34=
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
 cSScvxR6A1QJh+8/PS+Wwwxukc00Hp54PDcuEHTaZs6PbnIsuoBsXRosGa/SbPzGvwTSaYgNF9FP5hU4pOUy+QMlnlO6UvAJD9b8BCEXMLo6GtGbLgaq5UcFlf6TMtPVY8kZ1PdGUVMdeEGaZ0JWQdrYY21nMG3Ah0MJ0KRGCmMpkjq3XpKqkVpBrrOXkkdOewCBf2dZn1u1PdtYzzcsFd/84tB86OT6xhIgd4tx3ZwJurmV25qxyP3+DMWWXnoJKAOGGeqDLKG1Kcaj6DAoWCsk9CQ3xRSbKG5tEMiJ7iY2XZxiSsGExTGW0Gs/sc+UMQevOKt1XkaNLTla7Xrwxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	051597e4-002f-4c62-7b94-08de841b0137
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|82310400026|35042699022|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yDFkdvGfIMsxRj3COBqsmSTJjShLPS1GqUXhRDOV893uvpZFgCyLirQMPa34mTtqc3J97nMST++RlR7+ws1GGhCWWwGoyGeGz5CEzV2ZyHtw3NFhICEHyoJKbgM2ThyE5C5JBzxl7ckdt0ESpRoxa/oTCcqas7uPlPEf1pXhr+e5682PVvny1uQn/CxJnhHnMVfdg04uu95jCTEnKvpoYurpvViDOpHeXPPQLkPifnSNP06fpId39bxIPzgiDT8FYEdB5cWXUIKOhsM4G36tum+cQKM+zejE2g5XRnyRDWwyrXBYy/Xdx2G01QaG3Jz/5C2VHgZ879r4d379pmLGzBBn2qG5oo9mWFNjlGa+uovbhg2wnYwgHiYoj5JqhfcZisoklJU4DWlIFIzFAsjxvDrruJdnQYS4hz/eFSmTsF9Z3Mmj5Vno8vKRWWlho6XEQRegxguSviI6CYD86sn0puiyjc2WZ3wCf2usgoxptnPIa6NOBEWRgS7Rw3mqUF2xdLaVOxa5OdsrYgSVdg0PVI8FuYQxR2BHh0qSlpdM44YVLnLqf52pbEQCM/9pNp1O5fiUCBmUllOl01GPzaiQOf61xANUEJuliPvf6vbEHAdF2uQSN+jAGuckYbGpqMPshxO0qlwkpkznPZCNq8ROHiK/yyYYJRhGUp8vIRNWKBj8SDo5ET9lv2ap1NZ7arW2ALCXkSMJbbqtw7H8vNfUs2BEhAn3FsljExqe+z4ObdfcX0WTFb6LxrNPwKl/NA50TKFr4B2ALhbO8L6h8xqf2Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(82310400026)(35042699022)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gYoTnKlfVhNBSNt9qPQQIobn9ShbuGDwcG7H8zh3E/8jMVQp+vH3tkfFl//RfXxSoEhThvsieP3RsJe5YXVYm7ZAeo2QPPOjdSezrGvMqukDAPMUx4cB9cjqgKK6j48xwJoEqOs+SBOepY8nGFUYlOhPNAjWt2PUByzNlBJnHKRQi01wouJBh1SWMJAZW1GNgFgaiG5v3MZ18ca3XAHoq8dw4Hhu/TmEoP9qNBjgDdioDcRnssDWDsfqXHmXM2VT16MfBJj5SJH0G8k3xdnHCpvzXWcUselZKpj6ba3x6/Uc8FVCvOaL8CjbvOjCuMmB0df+qCEOcqrPKXsSW3vjoz8EXpA0AjSnPiQoLSJtUOEyspiHkhcqru8ucak+uYyYHvnR9IDi8OloWbVDt6mVej2EK6tLKyFAIB6zBVKjrEGEom7HZdraZ3wUCyuju4gh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:48:49.4146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1b7955-e7f6-4e45-e5a9-08de841b2783
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8902

Make it mandatory to use the architected PPI when running a GICv5
guest. Attempts to set anything other than the architected PPI (23)
are rejected.

Additionally, KVM_ARM_VCPU_PMU_V3_INIT is relaxed to no longer require
KVM_ARM_VCPU_PMU_V3_IRQ to be called for GICv5-based guests. In this
case, the architectued PPI is automatically used.

Documentation is bumped accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  5 +++--
 arch/arm64/kvm/pmu-emul.c               | 13 +++++++++++--
 include/kvm/arm_pmu.h                   |  5 ++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/k=
vm/devices/vcpu.rst
index 60bf205cb3730..5e38058200105 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -37,7 +37,8 @@ Returns:
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interr=
upt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interr=
upt
 type must be same for each vcpu. As a PPI, the interrupt number is the sam=
e for
-all vcpus, while as an SPI it must be a separate number per vcpu.
+all vcpus, while as an SPI it must be a separate number per vcpu. For
+GICv5-based guests, the architected PPI (23) must be used.
=20
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 ---------------------------------------
@@ -50,7 +51,7 @@ Returns:
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set
+		  number not set (non-GICv5 guests, only)
 	 -EBUSY   PMUv3 already initialized
 	 =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 41a3c5dc2bcac..e1860acae641f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
=20
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			if (!vgic_is_v5(vcpu->kvm))
+				return -ENXIO;
+
+			/* Use the architected irq number for GICv5. */
+			vcpu->arch.pmu.irq_num =3D KVM_ARMV8_PMU_GICV5_IRQ;
+		}
=20
 		ret =3D kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
 					 &vcpu->arch.pmu);
@@ -988,6 +993,10 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
=20
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (vgic_is_v5(kvm) && irq !=3D KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..0a36a3d5c8944 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,9 @@
=20
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
=20
+/* PPI #23 - architecturally specified for GICv5 */
+#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -38,7 +41,7 @@ struct arm_pmu_entry {
 };
=20
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_NR=
_SGIS)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 =
val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx,=
 u64 val);
--=20
2.34.1
