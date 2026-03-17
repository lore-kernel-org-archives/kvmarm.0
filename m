Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012007.outbound.protection.outlook.com [52.101.66.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C2A34DCD1
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747685; cv=fail; b=QrFPgVxkP9APfmayoD5MGQsa03CSyclEGb7+rOWuLzUCkmp2E0c6VyVNoDeiJelUqgYx1zKC5qVGL18eoLijZS/OLqUn3SgTxHKYGtOeiuTIAYQvnyO49o9OioUy1Je/xYPLzxb1AaL1Yo/7UmJWX4bYMq31UIcS49VxI5+YI+U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747685; c=relaxed/simple;
	bh=ghOBzplAXss5mlrkFwyxE2tlnMPSc234xGPVa5AkbHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gYXvMEZ7J29R150vhckPya5bXOnQPzIYcrx9L1ywoOBcCMjPGtWdue2FNEqUoLvPz5dGhHiT81loZMjHopHad1jhsTtlr+4JM6zjxqsELjUZ8nNXBMKqspoH/hjFFCFp+8vf83FWTJKDuzN/zry+gEcckrogZqXMk5aa3Cmxk8Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SgHE8gAB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SgHE8gAB; arc=fail smtp.client-ip=52.101.66.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SgHE8gAB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SgHE8gAB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cyLJruQJFVf62ZFAlei0ZQJX5Km59WiY4TFjmbSIFlDE0MmIU63W4tJOlOcsgS4P1GuvS/tTID+igfaahukNw9YYEgolkp6tJX1XyXuQqELs0/yGOTrkCiMw9DkteNh4nNKVzlTxwU+Vao+5GfkzByMSvo/l2bFY7yM62s7VDskj8BxSbiY5/c4Hr2SCJE99+Ix2D9fYQf+dPoCb6EAuMEDrroaA2CD6qhYKXURSIEFcPcjio6uYc80eMn7+6gNT6fRmZX9+086xjWhRKfarjEpBxsPKGCTe/DcdeoCvrMt+aDa1gngtrmWqMAt4t5o/d69uVdkpsXOSQQOaI6p5Ww==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsBHkggrd95NgV3qxDnALmBk0lWaQaEKFHc9jr8MuT8=;
 b=RVtx7Sc0A6f6YzMpmrnH/CP1Fu+uk0TPTC6KHHZarmvPvdadll8uHefxD8g76lkIQETEufZFnuMPr5yxblLJGW0Lir+K6pKC+COZAV61lQH0rU3nybqT4PvqBFoztNxfjFBQXQVyF1C0Vo4kQbnWDb0YL4LMHYDhUUVnNdR3AHkpjMs4Gm5e3jPPXpkFovZBeFQ7ihJv6z0gPVFPIUcTuIgySKxq8uwFWDLi+imqQZ3qOtr/B/xJqbuO3UvfLD4ggxAM3qA3VKFdgVXp7yXZSHsxv7mq5QyEybAgBlZOcne6KUdVTpim9DoGE8QO+UZbzo9qAXMIe+8ShOS2pLdYMg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsBHkggrd95NgV3qxDnALmBk0lWaQaEKFHc9jr8MuT8=;
 b=SgHE8gAB7ChYc5lcIiq1eHEW0RbHvfMWEngxXC+crmtOMXKG0fvGJA2sdOzN/NV1ptTkdAPWQQdmNEgLi5G6q0Lngp1UPHh1a7H1xYxy1GvFL6huI3PBmdNPcPiThAZgXvS/BPPDDfCBisfu4wrxMBetwpFBdg9VD4sVJJZgOa4=
Received: from DU2PR04CA0068.eurprd04.prod.outlook.com (2603:10a6:10:232::13)
 by VI0PR08MB10582.eurprd08.prod.outlook.com (2603:10a6:800:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:41:18 +0000
Received: from DB1PEPF00039234.eurprd03.prod.outlook.com
 (2603:10a6:10:232:cafe::88) by DU2PR04CA0068.outlook.office365.com
 (2603:10a6:10:232::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:41:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039234.mail.protection.outlook.com (10.167.8.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3meFmf3sFPWaDkZ2BxWfPO4HG8wwGU9SEnDhqRyyKwLkwCE2zbMVcF4uSNXRjIxymMBKrx6f02IAKqY77EyR7W7bx8NGmTRMrtZZKlMHza99N5JuvLLQ7WRG8xmUdfe3n0m+wieWYDYA9kQTSfTi20+9jMf8yYgYUT1yizqPZ+SZNEejkN0F5NeA9y5yXyG0odbJUJfMADISgZ/hdKlXSvdABckmDb32bXxXpN+CsT0WnWSHTo5FSLIstjO1P/lFxS4sT4relypL4cF/sj/KyeD9A28QML8FB1U39aNWkOLHbSGRfoo/wK5WNBdC300Pw6keDEqbMIvmG2t94OO3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsBHkggrd95NgV3qxDnALmBk0lWaQaEKFHc9jr8MuT8=;
 b=r/T4GFt4G9HX3xJZrSfhXJdm546n2p27A6FAhrYD6iAuwcVHXwJfgV7Enz2pEhYDC+5AqNvB5DfW+H+hBUA9Xly4PIHXVSCAcHfbRxiSoGsQZ6v36HMiUUrmj3N2oqTGcNRPL+o4BLRLf4qDtO2e+edng+hO5l8OHJKaro7SFZu/mwnyGxoSA/Q9wza48MalMD9axaXDMDMC5kCKluD7BIcFZSYhrOUN9iFgBhMtUfF9Yjblb2zOCPEinW2UvhFumjDNlOVXXs+ka19PL4zRK4M8RxnE6EkyZnYjqV4q18+ZK9zKpCaMoZHVWwE4JWj5J5TxX1nKN071Mmv9AKOnnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsBHkggrd95NgV3qxDnALmBk0lWaQaEKFHc9jr8MuT8=;
 b=SgHE8gAB7ChYc5lcIiq1eHEW0RbHvfMWEngxXC+crmtOMXKG0fvGJA2sdOzN/NV1ptTkdAPWQQdmNEgLi5G6q0Lngp1UPHh1a7H1xYxy1GvFL6huI3PBmdNPcPiThAZgXvS/BPPDDfCBisfu4wrxMBetwpFBdg9VD4sVJJZgOa4=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by GV1PR08MB8741.eurprd08.prod.outlook.com (2603:10a6:150:85::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:40:13 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:40:13 +0000
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
Subject: [PATCH v6 01/39] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Topic: [PATCH v6 01/39] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Index: AQHctgLRLUYEpAPoHkKTVpo+4ahohA==
Date: Tue, 17 Mar 2026 11:40:13 +0000
Message-ID: <20260317113949.2548118-2-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|GV1PR08MB8741:EE_|DB1PEPF00039234:EE_|VI0PR08MB10582:EE_
X-MS-Office365-Filtering-Correlation-Id: dc93704c-b6d9-45bb-cc1d-08de841a19ab
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 nwy7VRaPsz3Rt0CxemtJoO8GGEacBgfCr1qvTuzG+xcR7ye5pHADRaMKE3/dsS/8HYtXBj97UBWhRVy49nUCo76iuvadt7QyocHus4LrolT1Ilt0g3Q0ql/bmiyj6vW/mWwP5hdOTTS+xs1L976qqrSVadWjlJX/9AEklp1Dt8xmQbQ/foahYj2hIR3HU2AJkzE5+vMaC8U1vmDalyPTfJY9nNvuvEjJknMiiVGf+8Kt0GTQskDAA2ROLJVe/DLUKeRM7ONLU+/PNjGnJhf/ylhN88XcWnprq4aoTa+ZNMaTUREM3/q6SdIhUbRPGNGDit5fHVcLlTpi2EV/VBlygBnv+q6EGYhg6nzTa+YLJmgh2JFH6Z/h73xNJ52rq1E5V51VtnfFITYNcNaNyNQBN4gfkME/3Wnp2A9jDe4MAF2cJ/deTwwLC/HkqM1KsiL5Xd1WEs5EF74tfXP6dxBYFVGPE5HIW7WEOJ3gixhatyCKQMFuR2WAATh1uhhW83XvYkqGY+NpD9v6BtSF8An09f+1+J4yF20qKw+ZCdLgg7ka8HwfCvHfA+rRT9aPpM4rVUTQV6qtTCFsn7w9yO5zef8Ze1SYTyTryloqVNAKeIct8g8AmXk3AFmvEWBB7607+Pr/u9bVkzLqUeNp6QN1l0QCSYbNCbIuNMa4zHmQigEl/+HBvCziWoTHQQPsAes1SOZk4xz10Op+rT9I3PEWlUU4CboqM1zXbMr4P7A1HQwAJ1Yx9rTZHZ/Amg3egcKaYYPzK4EzDCQPxMObZ4b4At4dT6NRMoYq+cxho6lWfLk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 LJj7dtXE5rbLj7w2K89YDA8ObDuZbJPM+99Q2FKrCT64HYVECaE1SdRhmgeHwhHEif2dUMCAl27r7tQsOMdkzOxtfhzi0AAPqt+us2raaQd1JwEzU1QhF5Mrn4vVRtGnHodsQWh/afU1k9OGZ2+wUsRfOYp0Ezt1XsXlexMLwKYm6zW9WOLpqyYivd1+isRRY3kASQ5/0byhNiAC0TkiDH6psYgLR+AnTXVvTOJJTUe/PVfe78AtKOpu8iPsu5jQeWQ2yTupvEHqjU49MX91+8ZCV8phbT6ATSshYRtLQQJXJvUY/KBCDHq2O23zsoiH29BbPhaPQyXZNvDSDpJfTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8741
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039234.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c54d5093-2b8c-462c-7a2e-08de8419f3c1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|35042699022|82310400026|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	0LdIWObRoYjU1qOFcmTkq/dnLFiPAfdoxSGq/GsMFx52UKqygoLA63xJ26LZGq7hj2yG57dAZjeLG/23vVY6wGjF1KK5QUWZqpNMGIpyx8S022ef1lYM2FjvMHixb/2+Kr2ZN8e6UUsYimzbup82FRxwjDmuT/YA+2uO+s2nxgLGwinc1vNJgxxcOPKJGNw6+ztzCx5HRN+nEYY1SEx93JGYanIXx0V5E3XDgHpkOpOnpZYSGmWT6YCIXR9RBoDBO9c+OAqedI0mzHeBig+hM73bohetz+mFwlmD+KmJXEDltP+GEhFO8bOZF4Cvz1BjXtRvjkRTmvmYnlZ6uiWQPGIHVxgx+A9FyZVz5D43kvme2pAN0emsBaHNoqHe3Ada+AuQqFGsvaLI2+kVYfhz98AOrcYim6dCVaJarufOoku4TBSrkKj1iqpX3WSr5Y3Lxr7DY87AHzEB4pSrtKXTuR4liGHQ1XMtDsEeMARUNvqOWc+0GSaoL9xXpplePwI4nghPm5w2jNiigxy2QqDWr6DsbrSpKIcZOy1ep3IuLdVyKhd/QnWktUdNW3URZHLw40Y0buNOhGCc0/Zm/ARcBfLQ0m5O5slEGoMrcOhsKIsZwu6bOl7AJVHfC0ne/jNN+3awdvo8uhIi7gGgrZOhnK9oRd0cOeEZPtv0vibqJhPrw8vKmGDgCssnaIJFgr10TE6kzmbKYr63wHr2W7p7P+Iyk+MTit0YDITXoA01QR6KBIVBrUrnFOy5p2luT7HQM0meHDWsgylLXD5ClVOYGQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(35042699022)(82310400026)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZJDEzTlBLgkUyPbIjsfUrC/n7o//ja56WfE1gjgmrdMpdxmk4RxYt0vnMayAvKMp7PKPt8ga4ZIjNaZ3WsE3GWeTNldKfQ8v1SxJ6DkEZBgLmh/Va4bOi/W229NclujEr1ZS4VGNPPemq7R/FY1Ti9+b0Rn1JimT0unJ+3ASMOtUMd6Lil0MreR8Fxk0QNurHXUGiMVauXfUZj9s3NYRXqSvmUMRkYM0faJA7DSreyv4HntPvwwwr2KW3EJhBUdbAMH9a/IuZYpRzIcBlNLB4EFKervICY67EqVwGkdBCu0cMBf5zguV6GDnMNU/Iu+U80B7p7+ZBXyZCarBiCfqubqRpv6BTna3o/TNou/Kq7hYg/Ur09ttXLMPS9o+K1ydvipG4MqAkLBDph1+/1bTTaIUYE0TA/sePqMgodGuoWtUXe+RkYmE4pvuDUTw1+sp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:41:16.6888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc93704c-b6d9-45bb-cc1d-08de841a19ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039234.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10582

Drop a check that blocked userspace writes to ID_AA64PFR0_EL1 for
writes that set the GIC field to 0 (NI) on GICv5 hosts. There is no
such check for GICv3 native systems, and having inconsistent behaviour
both complicates the logic and risks breaking existing userspace
software that expects to be able to write the register.

This means that userspace is now able to create a GICv3 guest on GICv5
hosts, and disable the guest from seeing that it has a GICv3. This
matches the already existing behaviour for GICv3-native VMs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4cacb6e918a..4b9f4e5d946b1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2177,14 +2177,6 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu=
,
 	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
 		return -EINVAL;
=20
-	/*
-	 * If we are running on a GICv5 host and support FEAT_GCIE_LEGACY, then
-	 * we support GICv3. Fail attempts to do anything but set that to IMP.
-	 */
-	if (vgic_is_v3_compat(vcpu->kvm) &&
-	    FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D ID_AA64PFR0_EL1_GI=
C_IMP)
-		return -EINVAL;
-
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
--=20
2.34.1
