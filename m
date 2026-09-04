Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011069.outbound.protection.outlook.com [40.107.130.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615DD3E7625;
	Fri,  4 Sep 2026 08:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510742; cv=fail; b=bGs6X5OjIalV1wVh1DOa+JV93uUjEmpHfl8Bghae1KMn/SNp4Fi6A4xVurzr/mWXRx1lwhRoXgL9zMc1+/vDSdVV9iJ2z4sAOOUn+MzZkKCpAC6/RRUNs+RwVhgNsVzfczywcI5ZNrGH0pDOuxiAKey9nO4XtvwYo1g40/HD66Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510742; c=relaxed/simple;
	bh=py1SaPu/JsUYcZ72Xjh+dMtfxFckUja2RjESXNYWz9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DzuCRiSBWrVFm0HDD0lhm6mH1nTth1lypWYDOe0ofq271zBk8byoBc0V4/lPW//dfwMW1D5K3fbedd9UShgPHys0HoPqjDFADq3lWhe5oVXwFI8AbAZ4PJvAryAaZpjcFqgcqoIXDB/5jq5q4aRxF6dJYgNX8SDhFX6zycWUTg0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c0Sws0uT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c0Sws0uT; arc=fail smtp.client-ip=40.107.130.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c0Sws0uT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c0Sws0uT"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pKKmYDaRVXdI5tlYTLPNNahvT4rxBw27aimSTngjAM3THdJWlL4L0cKHSpl8libZ+6lug2xBNawns4v7xkGmKLXUPDXUWj6S5UdQI0egWLw0X2lj48v8Nt918LTSAiv1xENBEO79Lzs7TUpG1jwlF4TCXMaOVt/ftpcVTu8pB39oG8LdaVkHS0IoK7Rj3ug2W8eXQV5gME+85uk2VkCt2WeuGyKePJf7143nogoCihEVtCCr6fsC08xCrnD+UGp/mEhr4r9Pb8iMrKoUN2F6Tt4fSiRc52ktw/rTFAvwN9aIlWBQ7RMyDSOUCnda55zxdzIn3ywWkyZ6vRsVAGxOuw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=py1SaPu/JsUYcZ72Xjh+dMtfxFckUja2RjESXNYWz9M=;
 b=o39CwIVT9lltCsyx9Xs0SJ+w63tG0ZlweV3lDXNc6rqQVopiNQrXLuEo1bVG/ldEXUFK3HHLuMBy37sDLabwSChF3zS9WHezP7yROPwJS/9myRHJWCYJ1b36KGVTvkik1gxnMTM94SaySEVtQw2Rw0iOdYaKWTOiecAqamxb1NkN/MH+M980qnOooz3Ed+j34rqpK2LYqcs/kPVKr2jYhxp7q8a40b33BSgNTYqrNh+sPq8D0Rl3NRKmbdhvwGRUKT4TVeWNcVGPGcum4GZoskwc81pEz6CbAnF1146kMTwKpytLg1FH5RHSg28aoAnWDTbuKreZXblu+HBeTjshvg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=py1SaPu/JsUYcZ72Xjh+dMtfxFckUja2RjESXNYWz9M=;
 b=c0Sws0uTyYY+Nr5q/dYze83sl8ZQ+PuiMMRyRg0f6Wae5qHn2wNLj34LElUbQVkQenSLLm4bc2tyNemPNumu1XEdl9Mht4Pfl9G8lfAF4fhqN876c7++t8rwpTMcVOFtA8G2rR9VsmhGmZiH/R8vrDQPOAUCKbMrVtYOFhOD39E=
Received: from AM9P250CA0003.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::8)
 by PAWPR08MB10118.eurprd08.prod.outlook.com (2603:10a6:102:368::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:32:14 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:20b:21c:cafe::92) by AM9P250CA0003.outlook.office365.com
 (2603:10a6:20b:21c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 08:32:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:32:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwU/jGVYnOUysrvx/yp5ZTaod35iSGXohTM+zv4R9Xy6pZS4u6VD+rkkSZMWFDy3/gKGfQ/Hm3Moxr69XJsFVEsN1MNJ5rMvr9XD9Lkhh2DpsYtoyrVd5mSOKNw1f0dsooLTCVWS4RV8Lzee+fbaDoVUT/InFvKlo5BooslmXzmZfijCtF0v6eOBksNAICtFDrvL+L4TBvsUqpfXSNXxFFA2FlIjzovTH+tWfxfcjs4rohoQbvJ9jC9WkozJy1Wy2HnfzE7M9ZMoPYtoGFyrjQ86Uda1Fa5/C7rqunXSU5w89bZcPiZIBHIuXR1oHZ7eJR3B7AbvO67yTNKzWk8GgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=py1SaPu/JsUYcZ72Xjh+dMtfxFckUja2RjESXNYWz9M=;
 b=ynS63QkXRBFb8xP5ox5XAHvCB0xBltiPYFPuu9E254CRfPuTDd3V6UWvWFXGA+G08tqIRXM1eb8Z4tGtiwVmk7dOwMzVuxtXzoNuWdNHf/ZvcvtDLVDZSv9wi21ebBUdkk3jUgumBMw6ofix+xV8rV7H7i//bKAA91lO5lEoTEXPq6yC9ALUyFRf4biSbXZziCohsmA6gYmM7sEGGPnrU1LOPplKJYkR7P9k4bedNddxQDB8rPhbGlBCwjos0sSHIbS+I9aD8vALBUM9XrT8LiEmC9EIjLZs8KLfawwWEx2xmwfkp55g3UkWPZSZ7dkVhnLAM0HCpYovs4jDV1t2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=py1SaPu/JsUYcZ72Xjh+dMtfxFckUja2RjESXNYWz9M=;
 b=c0Sws0uTyYY+Nr5q/dYze83sl8ZQ+PuiMMRyRg0f6Wae5qHn2wNLj34LElUbQVkQenSLLm4bc2tyNemPNumu1XEdl9Mht4Pfl9G8lfAF4fhqN876c7++t8rwpTMcVOFtA8G2rR9VsmhGmZiH/R8vrDQPOAUCKbMrVtYOFhOD39E=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DB9PR08MB7470.eurprd08.prod.outlook.com (2603:10a6:10:36e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:31:39 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:31:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdJl7KxhfkqiSaIE2YpLmrTWFajLaSoh4AgCugvwA=
Date: Fri, 4 Sep 2026 08:31:39 +0000
Message-ID: <886b3705d06f706ed51e89098c2ba41a25386666.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-17-sascha.bischoff@arm.com>
	 <20260807141709.4925A1F000E9@smtp.kernel.org>
In-Reply-To: <20260807141709.4925A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DB9PR08MB7470:EE_|AMS0EPF00000196:EE_|PAWPR08MB10118:EE_
X-MS-Office365-Filtering-Correlation-Id: 71e855cb-7eb4-49f3-9edf-08df0a5f0582
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|6133799003|3023799007|18002099003|22082099003|5023799004|56012099006|4143699003|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 /XGbjLj2OflqOA/OlYY1+5krUaG+wOB1SkqCLaKY87uaXpUyj5/twGkE4NxtSI1obwPmG1hE1t9J9yTHCV854XsER0dPe75ctGhFmjXS4KUkLWMEojJ6Ik/wPVfR/7ne01Uz41MIKELy3Wq4qKlq+bE5OAWDBUWbspUCVYUJxYF7KrPZGXFuGhDkhtOlFC8+Xu6gGrzoM/13fOJ97AmhtdW2evD27FQKbZj6+mNSFkfUK+M2VwyZz/eH/OuIciMv1N6VmeDU8l2/Nilr14ji8xg49Kn+yiHcB444RVs0jgGDWuDARySXyihG4I1rbSm9rpg/YAtcz5xsExyJJWz/O8lD6Xrg2dvyNj/19FCiemEHCWtPOsobaZu6UAfwRc345FhaUE3r7MzlVGy3uWZjKFpQgMFQ0Znt7CI+iHtFUdn/77R2TpS2A940EMUWlw6Bm3+ea5Q+/N0WrCGkDkrUruRobfXcks97sYoj95wBohFK/JRL2BeMfRMEZA2hVfu483gTuwQORD9YqG4AIp+R/i3TiQm3NhtdWrTSwekaNukYTYu2AKfSNoFPpYO3AJ0c3fmHR3E9bBsLM9Md7ObQeN6RoQaisj56mvFsCzKHUObA4jd2OSMBywIzT6yiU97r+P7DUBgE+8E+zbkcl3LVjcnkptx706WaW5/xILbfqNrAPMmLgMCLbLDhwcYfeem5zMHvlNjn+gHHhU/ArZNLRhTTz34I84v91ytGGZcfe0U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(5023799004)(56012099006)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0D31BB1567CB64FAAAF0AB2C3FD6492@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 1qdYhD661ZitiuHXy/q+pruewSEwCTLDBCF8s3DlGuuTR2ioY/0cBci/HkmkNg8pf7GlijixZXc7trBnccV112eCsftWzwFVTEPERFW99kQWDqT90rH2PI6dX3aOcxvtBR5RlWdPwuq/I+Riq9zz8Pg11SairbcApDBSFuAdyQkhFfEFiiStFLEaFAzmc3q3OyVeqj4z62a/PRenlaeAEiwJz8bLhCIgxvTcWd2viIjVC1VtqNa8L4rvyiGUJzb/e2xwZ/rY03BDBqMbBYYHiI70EDi4TQZpkBYJZuxlDy0XFx05tNnrX4jQL+fxjFBkmY9XXXTNabv+ZZohlfaZbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7470
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	856c4209-a203-4e95-9470-08df0a5ef0d8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|30052699003|14060799003|36860700016|82310400026|1800799024|3023799007|11063799006|6133799003|10067099003|5023799004|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZPLidOpZxz1O01kmrHmjZZ3rgAwaw8l4zd+/NPlSQCC5K0ljNeA5fYrTiLPKRAPkhOr6es+X19LjY1k5/4P3UAoRJ4gc0FcFYDQ8XoSuV0xid3iWcpGK9KcnBzRr+PRNmaU8UytU06ZG6CnTBBq1cMInxH95NQH0T2dERiPqDwoPfmhGaLpdpqlvxKG+gUpFvob59q+nhKytrGsJoaXasPYQMs1NKYUvRBaF7OKwVVozm9s1Txuk7+Cmu72E/kih5W/J37FlVxrgs31VpsKuoH4vKXaZyNa1+xGWo5cwjnykPh8YFLW92B7SLivdY8o3q1Og3IhWpCUY2ZhLKSqnkcb4042cb3G4ckR0jzwNILzngGUZN0tR0tEyQqdx6zVONCu7Hj/wRfbcZwLqvbuPucNnQ2SNQu+VVxXw/5+JaFcmnGokwht8I3CDY+yAAK3MU9L4Za3yy2/orX4jnDHkQZUjCgj06jhptpv+CZrU+ukDyJ7+I1Nx7hppswek2XjweDXWtktGKbDDY42XdHDbdc5itna+zsLzRN4yTajxGPsZJxUp+5pwHEoqnYAuqBXvKhD9Ql/n5/asZzbFJ9SONJagS3bU1Q2AzZfFcw3FqBigpeGIVTUpbZlAo1zvbM6oQLpwwx9r5Lmro49RNEjp3lI23WTzussesAVd1xmXN9A=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(30052699003)(14060799003)(36860700016)(82310400026)(1800799024)(3023799007)(11063799006)(6133799003)(10067099003)(5023799004)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4jdxTLyWB7YqmUyGph3bkAgKSGsmhee+Qn8cGPW6fRiAlSnOdMvHJ3T1Zap4ho4l/p4cOztgvPZnlNolXm6V23lbzV/NIMINwjUEDkaifDh6c1YzBAPaBMYWksHSaci3CVg4IaYmJWpCkD6UkrcaGUATGA62HfZpKzxyiybolypPV1COX4Zu4syIqMW+9MoiNwt04UPCELJY9R5KwC8YRwTEkfm2JoTeHPqyfZGXdR8QeqW4fCFTfO79xtnY0SXSoYYeaI1+P+DoxBRSbMgkyJdCVJWKLthE+Tf3iD+NVXGBicECaDDBoR22Mx/vXTPs+HTWj4EwKMQWSs6CL93REdmMDoN89a3GInJY7Bq7wfSgwGu0RWdCRKJXuxqmpABAzAv/7gszeaWfRaLGdNJ3JxKMiEa4IPlUJY2S5QoQCAEBKO/CHmf0hSkzKHVsiYz3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:32:13.9561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e855cb-7eb4-49f3-9edf-08df0a5f0582
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10118

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE0OjE3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gQUJCQSBkZWFkbG9jayBiZXR3ZWVuIGBycV9sb2NrYCBhbmQgYGRlc2MtPmxvY2tgIGluDQo+
IGB2Z2ljX3Y1X3B1dGAgdmlhIGBpcnFfc2V0X2FmZmluaXR5YC4NCj4gLSBbSGlnaF0gU3RhbGUg
YGRiX2ZpcmVkYCBzdGF0ZSBjYXVzZXMgaW5maW5pdGUgVk1FWElUIGxvb3BzIHVwb24NCj4gc3Vi
c2VxdWVudCBXRklzLg0KPiAtIFtIaWdoXSBHdWVzdC1yZWFjaGFibGUgV0FSTl9PTiBkdWUgdG8g
aG9zdC1zaWRlIGBpcnFfc2V0X2FmZmluaXR5YA0KPiBmYWlsdXJlcy4NCj4gLS0NCj4gDQo+IC0t
LSBQYXRjaCBbMTZdOiBbUEFUQ0ggdjUgMTYvNDldIEtWTTogYXJtNjQ6IGdpYy12NTogUmVxdWVz
dA0KPiBkb29yYmVsbHMgd2hlbiBWUEVzIGVudGVyIFdGSSAtLS0NCj4gY29tbWl0IGM0MDk0OGI0
MjZhNjRkYzQ4ZGFlMjhlNjAzMDRlN2YyOTYwMGFiM2MNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hv
ZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBS
ZXF1ZXN0IGRvb3JiZWxscyB3aGVuIFZQRXMgZW50ZXIgV0ZJDQo+IA0KPiBXaGVuIGEgR0lDdjUg
VlBFIGlzIG1hZGUgbm9uLXJlc2lkZW50IGFzIHBhcnQgb2YgdGhlIHZjcHUgZW50ZXJpbmcNCj4g
V0ZJLCByZXF1ZXN0IGEgVlBFIGRvb3JiZWxsIHNvIHRoYXQgS1ZNIGNhbiBiZSBub3RpZmllZCB3
aGVuIGENCj4gc3VpdGFibGUgU1BJIG9yIExQSSBiZWNvbWVzIHBlbmRpbmcgZm9yIHRoYXQgVlBF
Lg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUtc3IuYw0K
PiA+IGIvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUtc3IuYw0KPiA+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL2h5cC92Z2ljLXY1LXNyLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9oeXAvdmdp
Yy12NS1zci5jDQo+ID4gQEAgLTIyLDYgKzIyLDE1IEBAIHZvaWQgX192Z2ljX3Y1X21ha2VfcmVz
aWRlbnQoc3RydWN0DQo+ID4gdmdpY192NV9jcHVfaWYgKmNwdV9pZikNCj4gPiDCoA0KPiA+IMKg
dm9pZCBfX3ZnaWNfdjVfbWFrZV9ub25fcmVzaWRlbnQoc3RydWN0IHZnaWNfdjVfY3B1X2lmICpj
cHVfaWYpDQo+ID4gwqB7DQo+ID4gKwkvKg0KPiA+ICsJICogQ2xlYXIgdGhlIGRiX2ZpcmVkIHN0
YXRlIHRvIGVuc3VyZSB0aGF0IHdlJ3JlIHJlYWR5IGZvcg0KPiA+IHRoZSBuZXh0DQo+ID4gKwkg
KiBkb29yYmVsbCB3aGVuIGl0IGlzIHJlcXVlc3RlZC4gSWYgYSBkb29yYmVsbCBmaXJpbmcNCj4g
PiBjYXVzZWQgdXMgdG8NCj4gPiArCSAqIGVudGVyIHRoZSBndWVzdCwgdGhlbiB3ZSd2ZSBhbHJl
YWR5IGNvbnN1bWVkIHRoYXQgc3RhdGUNCj4gPiBhdCB0aGlzDQo+ID4gKwkgKiBwb2ludCwgc28g
dGhpcyBpcyBzYWZlIHRvIGNsZWFyLiBVc2UgV1JJVEVfT05DRSgpIHRvDQo+ID4gZW5zdXJlIHdl
J3JlIG5vdA0KPiA+ICsJICogcmFjaW5nIHdpdGggdGhlIGRvb3JiZWxsIGZpcmluZyBhbmQgc2V0
dGluZyB0aGUgc3RhdGUNCj4gPiB0cnVlIGFnYWluLg0KPiA+ICsJICovDQo+ID4gKwlXUklURV9P
TkNFKGNwdV9pZi0+Z2ljdjVfdnBlLmRiX2ZpcmVkLCBmYWxzZSk7DQo+IA0KPiBbU2V2ZXJpdHk6
IEhpZ2hdDQo+IFdpbGwgdGhpcyBzdGF0ZSBtYW5hZ2VtZW50IHJlZ3Jlc3Npb24gbGVhdmUgdGhl
IGRiX2ZpcmVkIHN0YXRlIHN0YWxlDQo+IGZvcg0KPiBiYWNrLXRvLWJhY2sgV0ZJcz8NCj4gDQo+
IFNpbmNlIF9fdmdpY192NV9tYWtlX25vbl9yZXNpZGVudCgpIGlzIGNhbGxlZCBmcm9tIHZnaWNf
djVfcHV0KCksDQo+IHdoaWNoIGlzDQo+IGludm9rZWQgdXBvbiBob3N0IHByZWVtcHRpb24gb3Ig
dXNlciBleGl0IChidXQgbm90IHN0YW5kYXJkIGd1ZXN0IHJlLQ0KPiBlbnRyeQ0KPiBhZnRlciBr
dm1fdmNwdV9ibG9jayksIGRiX2ZpcmVkIGFwcGVhcnMgdG8gcmVtYWluIHRydWUgd2hlbiB0aGUg
Z3Vlc3QNCj4gcmVzdW1lcy4NCg0KV2UgY2xlYXIgZGJfZmlyZWQgYXMgcGFydCBvZiBtYWtpbmcg
YSBWUEUgbm9uLXJlc2lkZW50LiBUaGF0IG1lYW5zIHRoYXQNCnRoZSBzdGF0ZSBwZXJzaXN0cyB1
bnRpbCBjb250cm9sIHJldHVybnMgdG8gdGhlIGhvc3QgYW5kIHRoZSBWUEUgaXMNCm1hZGUgbm9u
LXJlc2lkZW50LiBJbiBvcmRlciBmb3IgaXQgdG8gYmUgc2V0IHRvIHRydWUgYWdhaW4gdGhlIGRv
b3JiZWxsDQpuZWVkcyB0byBiZSByZXF1ZXN0ZWQgYW5kIHRoZW4gbmVlZHMgdG8gZmlyZS4gVGhp
cyBjYW4gaGFwcGVuLCBidXQNCnRoYXQncyBieSBkZXNpZ24gYmVjYXVzZSB0aGV5IGd1ZXN0IGhh
cyBleHBsaWNpdGx5IGVudGVyZWQgV0ZJIGFnYWluLg0KDQo+IA0KPiBJZiB0aGUgZ3Vlc3QgZXhl
Y3V0ZXMgV0ZJIGFnYWluLCBrdm1fdmNwdV9jaGVja19ibG9jaygpIGNoZWNrcw0KPiBrdm1fdmdp
Y192Y3B1X3BlbmRpbmdfaXJxKCkgaW4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMgYW5kDQo+
IG9ic2VydmVzDQo+IGRiX2ZpcmVkIGlzIHN0aWxsIHRydWUsIHdoaWNoIGNhdXNlcyBpdCB0byBp
bnN0YW50bHkgYWJvcnQgYmxvY2tpbmcuDQo+IFRoaXMNCj4gY291bGQgcmVzdWx0IGluIHRoZSBn
dWVzdCBjb250aW51b3VzbHkgc3Bpbm5pbmcgaW4gVk1FWElUcy4NCg0KSXQgd29uJ3Qgc3RpbGwg
YmUgdHJ1ZSBpbiB0aGlzIGNhc2UuIEl0IHdpbGwgaGF2ZSBiZWVuIGNsZWFyZWQuIEkgZG9uJ3QN
CmJlbGlldmUgdGhpcyB0byBiZSBhIHJlYWwgaXNzdWUuDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjUuYw0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4g
KysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gWyAuLi4gXQ0KPiA+IEBAIC0x
MDk5LDYgKzEwOTksNDYgQEAgdm9pZCB2Z2ljX3Y1X3B1dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
DQo+IFsgLi4uIF0NCj4gPiArCQkJLyoNCj4gPiArCQkJICogTWFrZSB0aGUgZG9vcmJlbGwgYWZm
aW5lIHRvIHRoaXMgQ1BVLA0KPiA+IGlmIGl0IGlzbid0DQo+ID4gKwkJCSAqIGFscmVhZHkuIEFj
dGl2ZWx5IGNoZWNrIHRoZSBjcHVtYXNrDQo+ID4gZmlyc3QgYXMgaXQgaXMNCj4gPiArCQkJICog
Y2hlYXBlciB0aGFuIGNoYW5naW5nIHRoZSBhZmZpbml0eQ0KPiA+IGV2ZXJ5IHRpbWUuDQo+ID4g
KwkJCSAqLw0KPiA+ICsJCQlpZiAoIWNwdW1hc2tfdGVzdF9jcHUoY3B1LCBhZmYpKQ0KPiA+ICsJ
CQkJV0FSTl9PTihpcnFfc2V0X2FmZmluaXR5KGRiX2lycSwNCj4gPiBjcHVtYXNrX29mKGNwdSkp
KTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlzIGludHJvZHVjZSBhbiBBQkJB
IGRlYWRsb2NrIHJlZ3Jlc3Npb24gYmV0d2VlbiBycV9sb2NrIGFuZA0KPiBkZXNjLT5sb2NrPw0K
PiANCj4gV2hlbiBhIGd1ZXN0IHZDUFUgdGhyZWFkIGlzIHByZWVtcHRlZCBvciBlbnRlcnMgV0ZJ
LCB0aGUgaG9zdA0KPiBzY2hlZHVsZXIncw0KPiBfX3NjaGVkdWxlKCkgaG9sZHMgdGhlIHJ1bnF1
ZXVlIGxvY2sgKHJxX2xvY2spIHdoaWxlIGNhbGxpbmcNCj4gcHJlcGFyZV90YXNrX3N3aXRjaCgp
LiBUaGlzIHRyaWdnZXJzIHRoZSBzY2hlZF9vdXQgcHJlZW1wdCBub3RpZmllciwNCj4gdGFraW5n
DQo+IHVzIHRocm91Z2gga3ZtX3NjaGVkX291dCgpIC0+IGt2bV9hcmNoX3ZjcHVfcHV0KCkgLT4g
a3ZtX3ZnaWNfcHV0KCkNCj4gYW5kDQo+IGZpbmFsbHkgdG8gdmdpY192NV9wdXQoKS4NCj4gDQo+
IEluc2lkZSB2Z2ljX3Y1X3B1dCgpLCBpcnFfc2V0X2FmZmluaXR5KCkgYWNxdWlyZXMgdGhlIGhh
cmR3YXJlDQo+IGludGVycnVwdA0KPiBkZXNjcmlwdG9yIGxvY2sgKGRlc2MtPmxvY2spLiBUYWtp
bmcgZGVzYy0+bG9jayB3aGlsZSBhbHJlYWR5IGhvbGRpbmcNCj4gcnFfbG9jayB2aW9sYXRlcyB0
aGUgbG9ja2luZyBoaWVyYXJjaHkgd2hlcmUgZGVzYy0+bG9jayBtdXN0IGJlDQo+IGFjcXVpcmVk
DQo+IGJlZm9yZSBycV9sb2NrLg0KDQpUaGlzIGlzIHdoeSB3ZSBoYXZlIGEgaWYgKCFjcHVfaWYt
PmdpY3Y1X3ZwZS5yZXNpZGVudCkgY2hlY2sgaW4gdGhlDQpjb2RlLiBPbiB0aGUgZmlyc3QgY2Fs
bCB0byB2Z2ljX3Y1X3B1dCgpLCB3ZSBtYWtlIHRoZSBWTSBub24tcmVzaWRlbnQuDQpPbiB0aGUg
c2Vjb25kIGNhbGwsIGl0IGJlY29tZXMgYSBOT1AuIEkgZG9uJ3QgYmVsaWV2ZSB0aGF0IHRoaXMg
aXMgYQ0KcmVhbCBpc3N1ZS4NCg0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBDYW4gYSBndWVz
dCB0cmlnZ2VyIHRoaXMgV0FSTl9PTiByZWdyZXNzaW9uIHRvIGNhdXNlIGEgaG9zdCBkZW5pYWwg
b2YNCj4gc2VydmljZT8NCj4gDQo+IENhbGxzIHRvIGlycV9zZXRfYWZmaW5pdHkoKSBjYW4gbGVn
aXRpbWF0ZWx5IGZhaWwgYW5kIHJldHVybiBuZWdhdGl2ZQ0KPiBlcnJvcg0KPiBjb2RlcyBkdWUg
dG8gaGFyZHdhcmUgY29uc3RyYWludHMgKHN1Y2ggYXMgSVRTIHNvY2tldC1jcm9zc2luZw0KPiBs
aW1pdGF0aW9ucykNCj4gb3IgcmVzb3VyY2UgZXhoYXVzdGlvbi4NCj4gDQo+IFNpbmNlIHRoZSBn
dWVzdCBjb250cm9scyB3aGVuIGl0IGV4ZWN1dGVzIFdGSSwgaXQgY2FuIHJlbGlhYmx5DQo+IHRy
aWdnZXIgdGhpcw0KPiBXQVJOX09OIGlmIHRoZSBob3N0IHNjaGVkdWxlciBwbGFjZXMgaXQgb24g
YSByZXN0cmljdGVkIENQVS4gSWYNCj4gcGFuaWNfb25fd2Fybg0KPiBpcyBlbmFibGVkLCB0aGlz
IGFsbG93cyB0aGUgZ3Vlc3QgdG8gY3Jhc2ggdGhlIGhvc3QuDQo+IA0KDQpJJ3ZlIGNoYW5nZWQg
dGhlIHdhcm4gdG8gYSBrdm1fZGVidWdfcmF0ZWxpbWl0ZWQoKS4gV2Ugc3RpbGwgd2FudCB0bw0K
Y2F0Y2ggaXQgZ29pbmcgd3JvbmcsIGJ1dCBpdCBzaG91bGQgbmV2ZXIgZG8gbW9yZSB0aGFuIHRo
YXQuDQoNClRoYW5rcywNClNhc2NoYQ0K
