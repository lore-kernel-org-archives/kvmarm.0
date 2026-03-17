Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012010.outbound.protection.outlook.com [52.101.66.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D053ACA42
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747700; cv=fail; b=F+VmSkXzj52QUKwZn3b3QMFaqT3IXzkOSWXQ/2thPQyvmPeU3Ek859rgYxe/J8tC+Uk/7Uc+9Dte2ZSgP5TSH4ZLMa4IeD3p3I0SjU4/v+1ELKX7GwjVIPuOITlRhA/skXb/gbBE7KDoNBI4jOIsDj/UF6LQa7o1YyT9G9mPTcY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747700; c=relaxed/simple;
	bh=rwGSDZ8br631kLb0Rt+SUs8zXNsNGN4eIFNyAnj0snU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kF/QYsPxdUq7pZcGuUg6rn+psxAQIgni2T4fgahKTIR4LyiKSZkhtA24qjtGfA63gSUvZbMmWSXojwqGbacuOi+Nn/94A9/MOWcMCgxhs8LvkWfUR330Wos+3yCGwqtAscsmOsNA3vpVmzJFbuzMqD2wTA5IKxEBvz37SKuD/N0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RAzDlvj8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RAzDlvj8; arc=fail smtp.client-ip=52.101.66.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RAzDlvj8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RAzDlvj8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NyDgSQHgo8PDaZyDzkj/H+GtbRsYPiH4J2yuUkebr3IYQc9mE0oOkceB7tNcp3rI9vdm8S5naeyLPZY07Vxi+l4r5RxU/YQFd1tmSWS8/Ff4LFzscwK+n5gusIwtG8OTAWOF+iBzT/pKXo43lfBkD9oSBPqxj8Y9c6T7GWitGiYEYfiVWAPbSm58oBI2jHkLFD/f19vWo27CZGKjs+Y7sa292i0GA1qJ3pw5vFg8mSpcF5DHV3mFNesAF5JBeEtiQdPbw5YGmQjnGS2SUHIvHu6fmsGhEyAUuScXkbgKptLBMsUzpwfdRrZOHr/ugQ4dJqlXp8fI4IH5YmR//zXLtw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=l576GSFtfcM/jP9MKuT6mzRrfNiRfdzGLkuwrLtZmQsuFlrk7fNYZmvLTXUL6zi3JZy79N3fbkh47yQ9Xl6rGF59ZonTEgSLTlOpoTl+hGjqKwgkfJ/mxHLGOXpkn80NoH8h5vrEUkddIJ/BAI3tYhHNmFdWmy3F5GhpS5ji+z/5VMYbj98PVeVJkpVNip+uZv/JWDdnZq9OBHVUQS2EqPmI4hp6DbTY/aF1kbBAmWuoyRcQh3s9AoJv/0Cvecj/AyWCTx+wbNlXlmgJYOxx5230uLF4tMMuUwaigKDR73bYDaZsZt4/xUwYqlZwlmxgx0hsltREbkvuFYO0oB3hhA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=RAzDlvj8HTe6H4/SUCPbXEGTZfYEZrDkbQtitoVsaVjQ1Ah9hde8dZ5D8XXiCUTbSVwL0mF5hZZJTpz+IA8H3qM6jdOIUM1o9ipgdN0osCNoL3vThAlMEP2ujHvH0+wtWk7liTxvl0LNLBSb0EjG9+ghPMoRxYsEYOPeesNLwWM=
Received: from AM6P191CA0027.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::40)
 by PAWPR08MB8983.eurprd08.prod.outlook.com (2603:10a6:102:340::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:41:32 +0000
Received: from AMS1EPF00000045.eurprd04.prod.outlook.com
 (2603:10a6:209:8b:cafe::5c) by AM6P191CA0027.outlook.office365.com
 (2603:10a6:209:8b::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:41:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000045.mail.protection.outlook.com (10.167.16.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:41:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+hWuYEQaf3oyLI6zAc/wz0kxlLPxlwQZ/kmzD5ZUpRwwTuVM4fsuVO5z8QLi+a5lJQA9eLH/i0J5E4czVujaNoBGUkws725GmneDoFgXVZwwn9XwVJllYzhhBtXKeWhbT5QG0/gvGr3LooFiGRO2uRHVgXs5Tktq/7cnf4c/Hxh1DP+RcJehPeU1LX7liK8pnpqs+uO2OhvgGSCytNEfMGIvhu85WONpRWmtvzVg2KNpUfDlSBkaQdpTV7/Rmc7o1zTGWkbZaDz/ZsqKTmASx8pD74xZbT9i3UA2MdA9Yn1zANM9InGTKgQCPiZfPqtjvD4H8z+EXse18y+lNUYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=rcjGo0Ghku2Mvx08Y4J98Kyz+8csn3lfz9M06BdYdySSk2mLFBCcX5o0bvM3leTySJBp7Gwn242MJNeZOefYvfJa0HRlsylZdcxtSW/E43LTTxVfKjzpCRKnLZJEK2/VkHCentt9jBoHwyxFqpnACeExRM3Row18fVdM9EHCzOWUQ4sMwcOFbBHqplZzohZTRq/F5Efeq1NiUmjPU1pP4hMjRUIZDv20kF3Y8Hf728/mYIkGLtBtCRv81d+kCDPvSP1LB9U1uh3mcu0JRbankp0R3GlMV1XdK9L8rhsQ6m92rxZD13okoJfF5yRIeE+zHhvPwuc+oLfpvYG2ruNY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=RAzDlvj8HTe6H4/SUCPbXEGTZfYEZrDkbQtitoVsaVjQ1Ah9hde8dZ5D8XXiCUTbSVwL0mF5hZZJTpz+IA8H3qM6jdOIUM1o9ipgdN0osCNoL3vThAlMEP2ujHvH0+wtWk7liTxvl0LNLBSb0EjG9+ghPMoRxYsEYOPeesNLwWM=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by GV1PR08MB8741.eurprd08.prod.outlook.com (2603:10a6:150:85::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:40:28 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:40:28 +0000
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
Subject: [PATCH v6 02/39] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Topic: [PATCH v6 02/39] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Index: AQHctgLakvPhJHEj606OuMukBtJx9Q==
Date: Tue, 17 Mar 2026 11:40:28 +0000
Message-ID: <20260317113949.2548118-3-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|GV1PR08MB8741:EE_|AMS1EPF00000045:EE_|PAWPR08MB8983:EE_
X-MS-Office365-Filtering-Correlation-Id: 16174d6c-59d1-4432-c391-08de841a22e3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 JlZovorwhkss0jJAyRMzSGaR/bupBPnTEEfsjxBW6Wa4uRsilv1688rwvc+9MzZMNFIsm1icPZhEALJSldZkAx5vRwIWvWwrb3F38ORgze3wKQVo97PhajCNcnR1rrRCnt5AtevilG/BeOD4NmlQgoA7H81X+QKsD5aPrfNswB53fczXM0FA2Rg7oknbkFzkABAqP42fkt45POP/xypuR/CxqICKKrXEIk38nFX4/dl7lRKzHo2/BxLN7jXygvbBPvtnZyMsUQhm8pQ6OTIoy9CJ6dElr8w/RL6ACtSS6wBgPoaDdT7mIUfrVLD22DJsJGWSamGFYbaWB6Y3emhs5ZfBAHHXXVqD+qXjxAuGCeC4xeNuZX2DmG6pFA1qjAkn3QkkqXFMgm7+l3YTXBdyl9MnnjxJ+amz9BHz3cymGpetpAPEYr2CdOncrcRAJkxj/m72PBAnQ84sWE0UUztOKg0bAVxEa7P1/dy0ds2zfhBbaqaptffRUzfjSPbOnb+QqnpJ9oNI0k+VTIL8BEDUNHnSDyLDM62K9AMNDlOG0ff7vEuzmJqleJJCyWbTmEXJselx09ng+L5eg+/qLdFEBtPd8nYYG6O7B50+LuluwNEcGMI9YshhBSKLDQHgvstBaDj+w3mrIW4CwaZEgVYWUGdUq6UFrnQfzxN6aPWy/SuSoDyoXOxksakvuIDPI/T4QcE++Y24zC5nwFIvz4bFsiEgMxMbgGpi+ve2jmwCb86119Yt2+tnR8pV9M3dX2xWupHA7ApzoWt0FHdcH+LWWYdgnkxH+ugmxavXES8rHPU=
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
 H0OgB/SGji0lifZy375dc0N4Nn+0buy7tqs3Ck1kUAMrvpycyXmM4wtPTXoW2ejTuPB8nn2+AL+vG/PVizdBIOmrO7sDVRHoXVP7UnD4RCXwb49GfkwXI6pK2mIAWOSBx/Fw9pRV7ZA4MNsH5o9wgu0wJu2b6PbPRvzU1aBDso6rxGVxt4npQekJvi1dLB72U8E6oU43S5e6tSvLBVLnS4LU7J6RH3T3Mk7DzJxkyTzMv0FMu70NC7kuCwa4ah1tnpe+OwBr2eMkCeCkYhalZTYhLmv60rxTdU3gLiYn7ylzF/r5Ig7ga9fG/34SKwu5drjvGrRGPJTGFaERHEPILQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8741
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c1dd18b5-36e8-4265-cd6e-08de8419fcff
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|14060799003|35042699022|376014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xgqiyxsK+B0xCSHvjlMusjG/qH28stTx+oCKyeKpk5u/CWinLEf/cVeCRM8pTL+kU4J5ck+9P2nNFO4DWDbFwCPtcIOfm6H+tX2XsDOVrmPq++0lDH31pVt9JqlQVmH8ju0rkKMX2mRGe6hlQUVtHLPDN3FCsdvQH1aVZhavERv5ZDClh6c4rKT2DU/yiX5LVdjhIV4ecBrihCl7gPn26wLAz+8uSA3IMbIIPM43LZKF41CrXv6RWm9zqjFMfFI4dD0yozDzKu2VxZMy3Xoq8YsyMNvyMh2DkePq7SCHxhk4boJHKeuYZGx0k3o4PHnt2biXLAo70N1uiRnpu9FV1aZIxu5Ccm5ooY+AfPoPy3fVLgWyiDnyTchD/r5YENu9jAOaevOAwMZMMG137VsA7LdeyRwpm0Z5B4NRQ387Lme1UGbsKHB+REEbW/mMpYIOyrN/GzfS4etCH5z5rIJ8IKzUukN+Wq4oWxNRdVsNwcY8yyHVixXoHIcFk0GSGawTjQrLqpelpn1aronbWDNRLcrH4t5bCJFEW2xpm19qjul2G0uBI8+cbUxgsgeJqxB2E2M5a87hFurkWWKEZscwUgKXwioE9JE3QcGHciMv99RiUW137c1fFreaonhgjmEpjiONi0vqBptoUmDfQT3vCKXqaBxFUtWqqrDDBcTNxrj9ItF4lpBQiMzuwqeFPZgCqRw45pZ1pwdmeKsN4BnTIa3uOuPVkuefhAuVjGre/XvD1SRDOlzfUf/Ga915vnJZQ6ORA+N8AOGHFs/AcmExzQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(14060799003)(35042699022)(376014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GJJW5uYPJwWssztpWX9KkI6RwaxHO40P99i7ScL7FkuC8ZsTzQeXYQKEhuz4i2Gt9RIejGZ1H5guy5VyXWeApfJILqw1vazb+rlxMTZMxORL3Z3KjSuT+cST1TCSGpLd1BsrfgSGUFk0k6gzR6OTlveHTi5ulv9zd6SjoGRCUS4Gii/v6TlG0UiOLId2dIjn5OOE7GsRjltu5PJ23SNpEb5VsxFAhPov6B/mAwCp7QWWfasio8mRFz+nK3lPKXcDCNmG4TNkbx4pcIAmFrcy8QeFpPAO8gEWr4PMhqUdNEkc8TOgbcYkQMtMexugooVzSyK2riWxTIPaFc7BdYi8evzgY3nJ79jy0l1B3RpDFcddTwtwi+q1R2tmMRdDOYDPUNWyUpeAwhPj8a7JFjbGdhC6QvZ+CqndDBPh3eLUQeZKtm9akgAplZ3bOGgjDNUt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:41:32.1465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16174d6c-59d1-4432-c391-08de841a22e3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8983

The GIC version checks used to determine host capabilities and guest
configuration have become somewhat conflated (in part due to the
addition of GICv5 support). vgic_is_v3() is a prime example, which
prior to this change has been a combination of guest configuration and
host cabability.

Split out the host capability check from vgic_is_v3(), which now only
checks if the vgic model itself is GICv3. Add two new functions:
vgic_host_has_gicv3() and vgic_host_has_gicv5(). These explicitly
check the host capabilities, i.e., can the host system run a GICvX
guest or not.

The vgic_is_v3() check in vcpu_set_ich_hcr() has been replaced with
vgic_host_has_gicv3() as this only applies on GICv3-capable hardware,
and isn't strictly only applicable for a GICv3 guest (it is actually
vital for vGICv2 on GICv3 hosts).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic.h    | 17 +++++++++++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4b9f4e5d946b1..0acd10e50aaba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1985,7 +1985,7 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_=
vcpu *vcpu, u64 val)
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
 	}
=20
-	if (vgic_is_v3(vcpu->kvm)) {
+	if (vgic_host_has_gicv3()) {
 		val &=3D ~ID_AA64PFR0_EL1_GIC_MASK;
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6a355eca19348..9e841e7afd4a7 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -499,7 +499,7 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 =3D &vcpu->arch.vgic_cpu.vgic_v3;
=20
-	if (!vgic_is_v3(vcpu->kvm))
+	if (!vgic_host_has_gicv3())
 		return;
=20
 	/* Hide GICv3 sysreg if necessary */
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c9b3bb07e483c..0bb8fa10bb4ef 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -454,15 +454,24 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
-static inline bool vgic_is_v3_compat(struct kvm *kvm)
+static inline bool vgic_is_v3(struct kvm *kvm)
+{
+	return kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3;
+}
+
+static inline bool vgic_host_has_gicv3(void)
 {
-	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
+	/*
+	 * Either the host is a native GICv3, or it is GICv5 with
+	 * FEAT_GCIE_LEGACY.
+	 */
+	return kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
 		kvm_vgic_global_state.has_gcie_v3_compat;
 }
=20
-static inline bool vgic_is_v3(struct kvm *kvm)
+static inline bool vgic_host_has_gicv5(void)
 {
-	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
+	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
 int vgic_its_debug_init(struct kvm_device *dev);
--=20
2.34.1
