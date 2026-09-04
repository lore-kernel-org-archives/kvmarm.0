Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013056.outbound.protection.outlook.com [40.107.162.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4543E9D2;
	Fri,  4 Sep 2026 09:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513824; cv=fail; b=OUN0s0y67Nqdh8b3LWJxz9fuGzXg2GPY99pHPwy06AUrn+uHmJz+2xm5dJ4DVpFZs8ubWvAX41+xcDWaV2J6evp3ArJouVhvRiUsmnrwOduavGvv4lUQUtk0w3pmpjC0/IuU/wBJv8U5XRB9gBOGfw0dw15pRBrvV+DjVZypdAM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513824; c=relaxed/simple;
	bh=X/x9HPGKoXtNZPGtLaRIeWRKS33BIdQfBqbKaHA+JWI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GWrNGwTOgpe3psvoWYRXBbGclA1rMEze8D4vHAfaFOAZnKYecue3BstKTv09anI/smn0IlRWkyo225GLQAZK/EyYHyvC5YnZ7DMh5JQtzgEJzvSlStSJN8E4t7geppWdIJfzC0G4sfDWbKYvB5YiGCQg1AMnSff2OCNVyfZU7ds=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IE7MWDGG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IE7MWDGG; arc=fail smtp.client-ip=40.107.162.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IE7MWDGG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IE7MWDGG"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IfGHheaYWKVmrPkMbOyJX14CVvDWaY8o78tKgVIXvfGEid9Og4OEGpcGzqP1Lf+JFuxswVR4+tR3HthvoVRD8TXZHiUtwyKizz7jpS7rgZ9cHtEabVnCq0rrDoqp/6YRxLXpRaRbhGWRywqqZuydYHnNHvLbq6LlLkC792OyQE+s2UA9u9VXm5VIR5Kxt5VSAEgZkFHEY1vjWtoRBi/b23KvZeaTnu8z6K4VWyNacCW/yMtyNUPPL3OUr0oAtoFw2ViZ8EHEylcENU3U6tPXlFdvs6tn50v5wd8Wu9pJt500togMwc8YcIaX/klalvS8PSY1Ea+9wFZ0R5CXzdr7aw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/x9HPGKoXtNZPGtLaRIeWRKS33BIdQfBqbKaHA+JWI=;
 b=A5fg2dTb1WQi9vmycCsW8iIjQPj9lcnNzMPxsOIC9hbLSOG66l98xRvBEaTGOidmO7sgNBsIXMX57WMjab/ibr1l+QSXvoC2fg6+YqA4MhExE434xgq1CQkjzjN9h1ehDaoZDhOzkXkT8eqdCe2cYBj03kJGTKxmfp/fTr30LZ2puH+bpsLs5x85AFinHKEATL6kiz11w0Ta77EP8ifk4ytCD0ESp44NLBfArpdweAWC9kINiI9cMcThkMwwgFOwnRsaLfTjDKSKAdKDm2WqCVuY+SMqT/WtSgdDHQk8wpSbY9EjC+WNinL7lXvnUL3ugk92j/PY7cBMs9RDxn2r3w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/x9HPGKoXtNZPGtLaRIeWRKS33BIdQfBqbKaHA+JWI=;
 b=IE7MWDGGLV7ZIV58MFN5MqTEt8Ft8lYpzCRSDQNx51zv6ilzqXL8lZtTryEjJJQrLo6d8qmJA2NaJawpLjVoJVFl2CRTuaiwB+8zbLjFXWCZoMjOFA4YRaVJfoDp8vd5OPJU4R7uVf5qc75ADBR9IyWrcQ6xoHY+cN9KPFAdoPA=
Received: from DUZPR01CA0096.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::19) by PAVPR08MB9377.eurprd08.prod.outlook.com
 (2603:10a6:102:302::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:23:20 +0000
Received: from DB1PEPF000509F2.eurprd02.prod.outlook.com
 (2603:10a6:10:4bb:cafe::93) by DUZPR01CA0096.outlook.office365.com
 (2603:10a6:10:4bb::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 09:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F2.mail.protection.outlook.com (10.167.242.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umcF+6GMFXm6UzbRO+JAf+eUNEYogOPB1iA9/5hrYkR+6rAI/Ecmt29TPfRIRdq9s1hIm0NOABfW5jUtAxrv1yKNhoGNUM/7KJ2rjRwzakHNatr+M0Lw41Jm6eFXgM27m3gY19t6KrcvZraiH1gF9AOKFUWWaFOpOgeiAgVj6O7Ym6SZRMjAGNVPMCC0vKNAfNccmnVPKEn9KtHTT5x9sMTkRSQDg5ygXfGpK1lksw0FCxZZPqFh+7HswcrB5pBQ2xB8CgsnC7nK9tW5nQKTXqQqUU+HEFSWXWarqcqvzGG5Q/o9XyY+KrHPV/7GYe6g+6ElMdH7Bh3OMtOdEaX5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/x9HPGKoXtNZPGtLaRIeWRKS33BIdQfBqbKaHA+JWI=;
 b=aWGdxCzNP21bYL0xuYHAw8QIERU9PhnIfcQcGExH4vb2aBoc6a9/p+1ICrz6LQCDWJlNqo9HGY0e16x5IqOi1K5+KMkmnjQIHY8pNDG25EnpeSThMyik+b+YasTo2IUQRVnIDojVzcdxpAoHkEyJzCWmAct7UyDzp4QRtFwYrLO1s5bv2ic9X4WOLxEI8Z6B5vQ6+dGgRt5/AmmrLdSLBz9ByaJky/NcrMCnnQSsTmDArhp7wQQ2YXEhrWNJdZbFNCaswXCRizCiMM6YpzUjdOH16jMmLBzKW8j4TTMNpL/07Wse91KYiK7e019CGhH8vjDU5rrpu01KmAfqBDyp4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/x9HPGKoXtNZPGtLaRIeWRKS33BIdQfBqbKaHA+JWI=;
 b=IE7MWDGGLV7ZIV58MFN5MqTEt8Ft8lYpzCRSDQNx51zv6ilzqXL8lZtTryEjJJQrLo6d8qmJA2NaJawpLjVoJVFl2CRTuaiwB+8zbLjFXWCZoMjOFA4YRaVJfoDp8vd5OPJU4R7uVf5qc75ADBR9IyWrcQ6xoHY+cN9KPFAdoPA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DBBPR08MB10530.eurprd08.prod.outlook.com (2603:10a6:10:53c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 09:22:43 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:22:41 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHdJl+SELJ75zgnCEiW7cgM/PUmoraStJ2AgCucgQA=
Date: Fri, 4 Sep 2026 09:22:41 +0000
Message-ID: <6bed35681129190835783d774b7fc398dc757e75.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-28-sascha.bischoff@arm.com>
	 <20260807152322.3E5061F000E9@smtp.kernel.org>
In-Reply-To: <20260807152322.3E5061F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DBBPR08MB10530:EE_|DB1PEPF000509F2:EE_|PAVPR08MB9377:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f60619-dae6-4e8d-47fd-08df0a66294f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|4143699003|10067099003|56012099006|18002099003|22082099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 i0Y3FwrpU+yaEb0kb6/ol3XU0j0NO0lwOzuqJTGbrPB+PZBepkpz0uF7XOgqOo7wT2/X87sMjH3nO2CNW4dOI4f33iP6+OvJ1UHOW1tgXZip8G3Exihy93y61Qgbdi9gi01Rvqn1GhwFU9FFSudPWXPUazAi+aDdbIthjAOFP7GFZGaHpH81CzuuA1jHZUn71WTY22vK3cIZ0KzfljrX+WDc+K8Te/Io5zyB/6LoFVDkqcqDX/AsK3fR6ZWX0PTLKBGM46C76XhyAH2znFkoKW9MBUSazcVOtMzkmOP/diT1vWqlBrjM/vsKZnKEIxWGPL4Ir7bnSqnP51RPLpq1sXlwOCc+pIIpJFdlQDAgk9z5MGubLigwd3UOKK7MXIt6dKxfJq6YsBZFfYGSgDT4hGMkSixXspmjun1NiYWbEyz9d0x0Vn0Zaau0A8GEwZ8dmdvRNqulFaXR7LiV7idLork/7jUy3Hc5W26sO8Oq5t38tbWcSDcmGLnYMcaHSx4NI7Fef3MN5Wu0R5CfKL0/1Y7mVVhZFP3/iu95I1jxH56LoHUh49Pa13/tW5PcQgoEljJkqDdi+s14aSGXy90NW3FBGj+RZSU64hyN483IkipjQoDb4dcftYRMLbP5cHAmxa4UC8EXNXkXDigLrjlvgqWKuKCzBMIApbLTJCv+WObAcPmd48r0Oj8q2Eo53gOpEiDmzmOipCfc7py9gib2PTLgndTqfGyj8B8Mym5WKlE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <395A4EFD4133E84984416037F737C090@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 xV+8NspoKFJhxirmzT3Y/2t7k7IeQqjslYhGCEfzEzuzG7K0aDH/lmQeKkdsEs/3drTd2W0l76k/OUg37vV8J8NYmwE3Cmmklm4F3nrEodi7cEVsa6FfX3ZEgUMVvmzmBtUjWHS+gt1xNl7w+mjaiJ5cF+KmiziyTngfggWHHmqhHJOBfzNbO9nZyJ2XR0l4MQ3tKO+bnbEDUNTXPDCOCPTzCLuWdCrjC/Muqez+rw9Am7rg31yVfAmw1zHix9bVGHwCxZb1QN95qqImlwdZl31o8J2p8MPcuH6rB3yDscy384MedOFwXLEovUTBdDJ1JIt7EsDOygxeH6IerZNdWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10530
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a3f3fe4d-14ee-4fae-101a-08df0a661218
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|35042699022|1800799024|14060799003|13003099007|56012099006|10067099003|22082099003|4143699003|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iMsXfA8qZc/BKUd/xMkEgtA3KjWiciMHC72WQsIbGccUcxiGyCQaTo9nje3WTEaLRHGgeOHCCHIrMOK4+XUD3l9shk2dUFStInPU7A7gUO6sIka5gCzLFL5vzHSdQAmfmAMnjV/hqh6Fh7zHmQqNDG2r20VmpHK2y+ndeEhxHlDzGxBEaxkr+YFwGQfWOW9aa/FiXnqwHzx+JtdrlORt91ynv+RNI7NK4R54i6bfgtoQ58KYIo/TMSQu0cg31923IdLTq6K8GfJULfS5/sJjZIpb7Cf9ymuZZO6rfdmvxhOGirzkSIPRtwrU6akp6QmnW/6vPIXU249rH6+nwCiOuwiquJrVO95T006nbZxwQW6esBksq7PLvt7ZggI6LRHPqWHUTxFv3T5lW14nnFAkv+RRGchZjHgmrm/PObxysvEe1GceWJor38oe0l45lz7//AOmM1iLLaZifQgawlSXcJXTRo6BikQ+sadZFKVgCGV8VqE7DP0LNQo1FYTi+Z0XYV7q9ObR/V8LTfz94Y4uK5lfV9JbXaA5X3V0/9OUEIhacNux20mR7OJzjWD20dloeBD7FBQAfpXK7uAN+LI2oFyn4RWvvzkPzRrlsEVv6ultFLcAO2aT3NagdIjNbOP9nZYzyX1jHPqriuNDewUdujCA8Ms12f2DV3fEccDTMFk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(13003099007)(56012099006)(10067099003)(22082099003)(4143699003)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Xl4kCnVQTxkPM8NtLsBMGYZ6XPFcgG2vjcGxRi7xlMldtI4A9arNy+Ns0hVXS+4w9qRb8a9T3JqX7/oYRSNY8Tx7n8fMZz4aOMossICOmXKqck9Y6KVzyiSDqfCu6Zr9GMq46G0lhevuplyEC0JigSzgLdp+mj53SsC5ciVN3UGeBEzQwK/rSNmUOs+1pQGZU4DzX6wPpnuv+h7M+ENTkoTbX7d6SpR1V7kMfLZpWBMFRDrfo5M9gnukp4VvyIL6EkRNSmwhA8CtgLp0LQVj9CcgQqdOyfIu5ssepxPCXypAyDUtY/P2nG7N+YUG1UyUNnwFYo/7Pmw2Zb4FuuNzLRfVDOfHLfXRgoaQUrL9gxcqeMvmPCPf6++oXJra2R0wpjHSV4a7C/CQOPFYxq2G4NCwvjpyUg0pii4hdUF2rfQSMwKMbQjPyCSkjN2ANZWl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:23:20.4783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f60619-dae6-4e8d-47fd-08df0a66294f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9377

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjIzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIFNwZWN0cmUgdjEgZ2FkZ2V0IGluIGB2Z2lj
X2dldF9pcnFgIGZvciBHSUN2Mi9HSUN2MyBTUElzIGR1ZQ0KPiB0byBpbXByb3BlciB1c2Ugb2Yg
YGFycmF5X2luZGV4X25vc3BlY2AuDQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzI3XTogW1BBVENI
IHY1IDI3LzQ5XSBLVk06IGFybTY0OiBnaWMtdjU6IFN1cHBvcnQgU1BJDQo+IGluamVjdGlvbiAt
LS0NCj4gY29tbWl0IDMzZTkxZWY1MjU3ZmMxOTAxYTk0NWQ2YzNiODRlZGRjNjRjYzllMDkNCj4g
QXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4g
S1ZNOiBhcm02NDogZ2ljLXY1OiBTdXBwb3J0IFNQSSBpbmplY3Rpb24NCj4gDQo+IFRoaXMgY29t
bWl0IGFkZHMgc3VwcG9ydCBmb3IgaW5qZWN0aW5nIEdJQ3Y1IFNQSXMgdG8gdGhlIGNvcmUgVkdJ
Qw0KPiBjb2RlLg0KPiBJdCB1cGRhdGVzIHZnaWNfZ2V0X2lycSgpIHRvIGFsbG93IEdJQ3Y1IFNQ
SSBsb29rdXBzIGJ5IElEIGFuZA0KPiBpbnRyb2R1Y2VzDQo+IHNwZWNpZmljIGlycV9vcHMgZm9y
IGhhbmRsaW5nIHRoZWlyIHBlbmRpbmcgc3RhdGUgd2l0aG91dCBBUCBsaXN0DQo+IHF1ZXVlaW5n
Lg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gaW5kZXggMDIzNzkyYzI4ZmM1Yy4uZDU3
MWZhZmIwN2YzMiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0K
PiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+IA0KPiBbIC4uLiBdDQo+IA0K
PiA+IEBAIC04NiwxOSArODYsMzEgQEAgc3RhdGljIHN0cnVjdCB2Z2ljX2lycSAqdmdpY19nZXRf
bHBpKHN0cnVjdCBrdm0NCj4gPiAqa3ZtLCB1MzIgaW50aWQpDQo+ID4gwqAgKi8NCj4gPiDCoHN0
cnVjdCB2Z2ljX2lycSAqdmdpY19nZXRfaXJxKHN0cnVjdCBrdm0gKmt2bSwgdTMyIGludGlkKQ0K
PiA+IMKgew0KPiA+IC0JLyogTm9uLXByaXZhdGUgSVJRcyBhcmUgbm90IHlldCBpbXBsZW1lbnRl
ZCBmb3IgR0lDdjUgKi8NCj4gPiAtCWlmICh2Z2ljX2lzX3Y1KGt2bSkpDQo+ID4gLQkJcmV0dXJu
IE5VTEw7DQo+ID4gKwllbnVtIGt2bV9kZXZpY2VfdHlwZSB0eXBlID0ga3ZtLT5hcmNoLnZnaWMu
dmdpY19tb2RlbDsNCj4gPiDCoA0KPiA+IMKgCS8qIFNQSXMgKi8NCj4gPiAtCWlmIChpbnRpZCA+
PSBWR0lDX05SX1BSSVZBVEVfSVJRUyAmJg0KPiA+IC0JwqDCoMKgIGludGlkIDwgKGt2bS0+YXJj
aC52Z2ljLm5yX3NwaXMgKw0KPiA+IFZHSUNfTlJfUFJJVkFURV9JUlFTKSkgew0KPiA+IC0JCWlu
dGlkID0gYXJyYXlfaW5kZXhfbm9zcGVjKGludGlkLCBrdm0tDQo+ID4gPmFyY2gudmdpYy5ucl9z
cGlzICsgVkdJQ19OUl9QUklWQVRFX0lSUVMpOw0KPiA+IC0JCXJldHVybiAma3ZtLT5hcmNoLnZn
aWMuc3Bpc1tpbnRpZCAtDQo+ID4gVkdJQ19OUl9QUklWQVRFX0lSUVNdOw0KPiA+ICsJaWYgKF9f
aXJxX2lzX3NwaSh0eXBlLCBpbnRpZCkpIHsNCj4gPiArCQlzd2l0Y2ggKHR5cGUpIHsNCj4gDQo+
IFsgLi4uIF0NCj4gDQo+ID4gKwkJZGVmYXVsdDogew0KPiA+ICsJCQl1MzIgbWF4X2ludGlkID0g
a3ZtLT5hcmNoLnZnaWMubnJfc3BpcyArDQo+ID4gVkdJQ19OUl9QUklWQVRFX0lSUVM7DQo+ID4g
Kw0KPiA+ICsJCQlpZiAoaW50aWQgPCBtYXhfaW50aWQpIHsNCj4gPiArCQkJCWludGlkID0gYXJy
YXlfaW5kZXhfbm9zcGVjKGludGlkLA0KPiA+IG1heF9pbnRpZCk7DQo+ID4gKwkJCQlyZXR1cm4g
Jmt2bS0+YXJjaC52Z2ljLnNwaXNbaW50aWQNCj4gPiAtIFZHSUNfTlJfUFJJVkFURV9JUlFTXTsN
Cj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhpcyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSwg
YnV0IGRvZXMgdGhpcyBhcnJheV9pbmRleF9ub3NwZWMoKQ0KPiB1c2FnZSBsZWF2ZQ0KPiB0aGUg
a2VybmVsIG9wZW4gdG8gc3BlY3VsYXRpdmUgb3V0LW9mLWJvdW5kcyByZWFkcz8NCj4gDQo+IFNp
bmNlIGFycmF5X2luZGV4X25vc3BlYygpIG9ubHkgYm91bmRzIHRoZSB1cHBlciBsaW1pdCwgaWYg
YSBndWVzdCBvcg0KPiB1c2Vyc3BhY2UgaW9jdGwgdHJpZ2dlcnMgdGhpcyBwYXRoIHNwZWN1bGF0
aXZlbHkgd2l0aCBhbiBpbnRpZCBsZXNzDQo+IHRoYW4NCj4gVkdJQ19OUl9QUklWQVRFX0lSUVMg
KGUuZy4sIDAgdG8gMzEpLCB0aGUgdmFsdWUgaXMgcGFzc2VkIHRocm91Z2gNCj4gdW5jaGFuZ2Vk
Lg0KPiANCj4gV2hlbiB0aGUgY29kZSB0aGVuIHN1YnRyYWN0cyBWR0lDX05SX1BSSVZBVEVfSVJR
UywgaXQgdW5kZXJmbG93cyB0byBhDQo+IG5lZ2F0aXZlIGluZGV4LCBhbGxvd2luZyBzcGVjdWxh
dGl2ZSBhY2Nlc3MgdG8gdGhlIG1lbW9yeSBpbW1lZGlhdGVseQ0KPiBwcmVjZWRpbmcgdGhlIHNw
aXMgYXJyYXkuIEFkZGl0aW9uYWxseSwgaWYgdGhlIENQVSBzcGVjdWxhdGl2ZWx5DQo+IGJ5cGFz
c2VzDQo+IHRoZSBib3VuZHMgY2hlY2sgd2l0aCBhIGxhcmdlIGludGlkLCBhcnJheV9pbmRleF9u
b3NwZWMoKSBjbGFtcHMgaXQNCj4gdG8gMCwNCj4gd2hpY2ggYWdhaW4gdW5kZXJmbG93cyB3aGVu
IHRoZSBzdWJ0cmFjdGlvbiBvY2N1cnMuDQo+IA0KPiBTaG91bGQgdGhlIGFycmF5X2luZGV4X25v
c3BlYygpIGluc3RlYWQgYmUgYXBwbGllZCB0byB0aGUgY29tcHV0ZWQNCj4gYXJyYXkNCj4gaW5k
ZXggYWZ0ZXIgdGhlIHN1YnRyYWN0aW9uPw0KDQpUaGlzIGhhcyBiZWVuIGFkZHJlc3MgaW4gdGhl
IHNlcmllcyBoZXJlOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwODExMTUwOTQx
Ljk0MTI5NS0xLXNhc2NoYS5iaXNjaG9mZkBhcm0uY29tLw0KDQpUaGUgY29ycmVzcG9uZGluZyBj
aGFuZ2UgaGFzIGJlZW4gd29ya2VkIGludG8gdGhpcyBjb21taXQgdG9vLCBpLmUuLCB3ZQ0KcHJl
c2VydmUgaXQgZm9yIHRoZSBub24tR0lDdjUgcGF0aC4NCg0KPiANCj4gPiArCQkJfQ0KPiA+ICsJ
CX19DQo+ID4gwqAJfQ0KPiA+IMKgDQo+ID4gwqAJLyogTFBJcyAqLw0KPiANClRoYW5rcywNClNh
c2NoYQ0K
