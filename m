Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013061.outbound.protection.outlook.com [40.107.162.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B20481FCA
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523202; cv=fail; b=ji2DPIg+L2UzykX6iFEzdTJXtWJCE46zeEaXk/AcShfOzuxVw69tqnYPvWGba+W/3JC/yyw/P/z8D/7aoWoTZdG6utb+KVsj8WW+9c8gR/100Rma/6GewCQR/KOzP3K2bapCZVno4RIY2cgM5Th88ppn1zB34F+aOgEfDrIRyoM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523202; c=relaxed/simple;
	bh=PxijJIJ/VSadySNCXEc+sqAHdWAmJ3OYEKEpt7K6SmI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vFn2b6UQI8FuQS4/vky8PbC2CNT88NKefjhOIreAuNvLSSKOyAzX39tpMqUrOY6WM96oDeBAKkHdwyVkI9dpfEf7gWjyA1LG/dcGTr6YQZmyGIynJi7DS22d68Kue98mHPIEn7f+QKVa8ZrJgjqMKOeb09ssGXgm7f+TwntIDQY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=csgDIKT5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=csgDIKT5; arc=fail smtp.client-ip=40.107.162.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="csgDIKT5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="csgDIKT5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kSgT3qFS1/In+dj6kvcmBw0aWGCNokR25UlQA/hRGcQpWN0uib63cdBA6bkW5aTWOB/VXtK3v1I/I9CBGGwCyAvd3q/ujjaiLyjqZL0qufmVjH4pvjHWZbdguRKi3l7jGAOKfZmpcy5HkNTRbGCwhcmB9bb09EI67f7Fbk/tBPj8hF5BRSUH3RrpcpwPbQb6zNgkgrrV0U1E/epMC/p14AMWCOqeOPRphjy8t6R/tozQ5U372/svQFj9DLG030lB9Iu0nl/cF1rF6NAnkR3X9tYbDho5yIq1OF9hWRwKtN1hf+ExiizT6GDJutzjJ6JKTiqDHPJoR8KOJAwFLuAqrA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IAL7wEqqe99RpiWPoFYfaY6dp/XvqCRZnaSLSfaXnA=;
 b=Agr3cvFAw4vaYR5PbEycSpsz11ZCF0oZ98OfGrhTGFqAwt2eIXT+BXuZvxLK3haA4+hVOcCzTn/NyIy6r+uzv3LKlqUAKW5opRAIPjeSobNzN3dOuU9PbvK9+LlFhINYl06X00Zp7mad78gx5IogOcQ/dpTHSbVy4cIGSSWyZz+11Z+d3Y0JVSnLpgcv4wC/92fz2kCrinSRTRYa110n1NZYVRHzRv6BE7dQn8FU9j9H8PWfxZDXbFhjEYZYeLLHdspgS32tw9UmZsgHCJN5R0HHc16I3gNn4jbSuIVpOHNxrW3Itvz/LlquNa3yIGbVK32KYjQD0z0LgaSz6xr1Mg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IAL7wEqqe99RpiWPoFYfaY6dp/XvqCRZnaSLSfaXnA=;
 b=csgDIKT5I3qY55i8bsHorrkuftnUkA8BvHROr7eNZyZF7HMkywQGZmXE27XhzQMKaLKMp5ghUobLKQkhrvpCZulAQk+cf7/OeDdt2h3Vn6bUqhGS5WALOMfPosW8irWaPkgTFQh5Pu1pn7i8Yh+5f1e8VU4WZv9meSwjWUUcBgw=
Received: from DU2PR04CA0248.eurprd04.prod.outlook.com (2603:10a6:10:28e::13)
 by GVXPR08MB7846.eurprd08.prod.outlook.com (2603:10a6:150::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Fri, 4 Sep 2026 11:59:49 +0000
Received: from DU6PEPF0000B61F.eurprd02.prod.outlook.com
 (2603:10a6:10:28e:cafe::a7) by DU2PR04CA0248.outlook.office365.com
 (2603:10a6:10:28e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:59:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61F.mail.protection.outlook.com (10.167.8.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:59:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oq9XK1jnx/ibX4OvbwM+2Bro6BpdqDY1PgKUsAEZ9yk0/o/1QvNxv9eWxfJuOxxv8PBo1ukHpEuoJQKgk6jjLbDc7ShLMU6rSAWknQcUhAcFMGtSiqqTrgHi6OPHakXLfbXijO1mK8MibJgRK+iiXDf24SttyqamRUe6ZDL+ETDT8AgCNIUd2T6el8aH5tuTHBaulERv4XTHxnJfc12dYEtTNdV0HPDNHZwM6oIG3el5UqQ+0wx+L4JMnSVUhs91T8ERDhPl97Ld5uhgx9QSdRmPaSsanEh3hG6+WEHcMD2BCZHvZVfGZmclJqjdFu7izm5ctXkwyK/7qo07ZFWFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IAL7wEqqe99RpiWPoFYfaY6dp/XvqCRZnaSLSfaXnA=;
 b=bEvYeYA2VtvxiGJl8BqbmW6nR9aU2nlcwiDfnieTK7T5kKR9e0HN5sPnzw/fwCBEyCSJF2rMlNCKFYWz246qZ52JCqtTuG4Ae370J3g8xjoEKoYnGfs9RfDIni2YHg2Y5/opcCx/ftWVvFzsL4C/S3BBp0TQQOBEX+QnB4X8YvE4liyIxvNDxHAGURwMEXqJnY8xXEsAs4oaDOFxt2nl/2oQiOHLalSMrS1siLQ6ChdvSZvyv0dvQei3dyu/ofcDFztHtvb/tOTCYlNddutTUoeR1iD4sENc4KKeDYUyKQkNfKX/sYRFdAkI5S8tOns4AJWmSxDywx2gwlBOfj2S4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IAL7wEqqe99RpiWPoFYfaY6dp/XvqCRZnaSLSfaXnA=;
 b=csgDIKT5I3qY55i8bsHorrkuftnUkA8BvHROr7eNZyZF7HMkywQGZmXE27XhzQMKaLKMp5ghUobLKQkhrvpCZulAQk+cf7/OeDdt2h3Vn6bUqhGS5WALOMfPosW8irWaPkgTFQh5Pu1pn7i8Yh+5f1e8VU4WZv9meSwjWUUcBgw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV1PR08MB10954.eurprd08.prod.outlook.com (2603:10a6:150:1ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:59:12 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:59:11 +0000
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
Subject: [PATCH v6 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Topic: [PATCH v6 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Index: AQHdPGTMgzOLZWATwk2itLDbM/0sAw==
Date: Fri, 4 Sep 2026 11:59:11 +0000
Message-ID: <20260904113404.4051341-50-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV1PR08MB10954:EE_|DU6PEPF0000B61F:EE_|GVXPR08MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d020bd7-ed88-4a6c-5ac7-08df0a7c0440
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|10067099003|56012099006|11063799006|18002099003|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 n/bgCak9KVOxbcOn6xMx4CZN5G2PIiIkCWGCwPrKHV/xcjHOk04bqU95JaLaRMJMxUOJH8j5SWSSkyTsfAxaVGD0rkqkCCN24kD47rqmAubdkv31boMCheecvXjyqsyJg+rCtR/tZIpaUhyxSXdSKZOmF9iG+3WthCzgkHMMGBirUwmPj+i7bwUe6HbRU9icPU/VZMjICmuHYfMg9NlaRsHaRLK1A4qIGjpCdY6z4D1LcZ9hz2l7EdAqyuvnTsGkMgGMLNOx55tI1bXHEZbpFiRTqXAqlvlzl+sG8YGGZRM+805z85KUWjBqtC+dqz/zxi0OKUUGTXqjvT0PXSImvquHJotIbDpvueZVUjNUNWah8Th6PXgMwIKZ8f2/y6UUnpgEANxSvwisXnWEKBRNqsa0wt6vWGZEq2Ywef+oUdQU4fUeg6uDQ5jEH4+qUoCS11zhAln0XwqTH4FpoeHzJUrGnR18QX6TFSRDfBQDTs4DzVk8LosIt4kWryil0s39MPFQzxc/P1l2je8jhhG422Ruhm+5wxVZlm4UWKKcX43PSk/InJPAx/Wq4wmXha8eC3G40WORCfTq8Inxalfl32lMkntqgSMYVBFyTN4j5mvEZk+cY9VoR0aVTsBUWFFtTdEEyfF7L9YzdVJY73Pr/NPGFCXrcOUGJESRTwEriy9C8LdaWjMUlEp3OclkGY0wpwZUtp3lY33NTdfealJzC+7XD5cyqFPUhLy+CGMfr4o=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(10067099003)(56012099006)(11063799006)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 vkF6UX8c5vatSvdI/WkCm8nkZf0VMwj2Fa5yRAZEP94LpFHdBryFmu1hQxKYC0hCWsFU4Z3baavezP7KAwWkXkmARwxf3Xu3+AfLT14m5Z88iNluc54cAlULUU8Emb61UVsuk7No8RSdyIVyl6gEr0UhH6FeQG7Wr5d0C62UsxICNRyu6ms8YF8WDkzcaM7Ab0wWnozyAy7E/9oyb3LxxTGQPXiaKfAgpjR5SeNTGcbav/8k+3yB1lKuBUcvQNvq459459uq7CK5oGGLZnwgqa4cyT+s/rUBzqUMzCJC5FX24Nk8KftQ10Bdep9XgXcSGl5qiM9D7pp4zp87r2L4QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10954
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eeb6b9fb-3204-423e-bfc6-08df0a7bef0c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|82310400026|23010399003|376014|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	BdZlL+8V0HcWMsIQ2kPOhzeeWAeHKGsS+041sQRSaGwqbsjO02Z5r+lsWYUqb3KqEPW+g1HLJD0PFS3jKinRSC6iF5qkzXfVokI2+yJdyJ4vozUsn7LbGcDKzl29Ha/ytLGGyPf7BHedBBH8GQZzsZyII+/+hsRBHZo51+PvUay+UBrPKUZBI/AW2kb1v94fF5ayB9eMotpYH4kEjukNlc3s8jy4P2qJCT9I5HOXW1eUJAnsCXkWDy/LwTYr07i9byYJhsSn7ZRA9gCo6ZxuBLGZBl/gknXbmPflk4yxzc5kd8Y+xBkYem2LZsiGcx/a/VZCO2h2Levdtv9196UbhZXnylnLMWdMfAISKvPIoM6OKqJaLcDDd6D924nPMgRgunfLAMGhBdrL7vvj4/j+R8Xy/z+AH1GmcU5dWvArj6jkLasGVhzXB+m26hA9iP5aeYDnFxpyjSMq0Ik93Xte+zO5bVCYcxcToWxnHvHKHMQ7z3+khJi2PZ4BAY6E0Cl2wYzV8jEOwouBLJDzJs/TxUHKWeAD7OJ6h//J9bXDW5ZyD/1ZcwnwWuzB0BRsdcF6N0CoQlM+m0yXtR+6vrItusxWya0uYaK8iNWAkLcLD5FQFUqS0ur9bUC8DOJSE8YmQDn/f1O8jY07r7b2s1mP8WSOm7hRDxQmMO+aKDd1cZ8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(82310400026)(23010399003)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vLsQiP86C1ykpMiPAnPo+H+z7g3ERIcNUr/EKnYxSMksD3nlemOpnEGFSqQ5ROWQUyzTo0hiJrff2Smq0qSO1/KSG/sQemXjavTlBSl6bh2rkAyjGZ5mF9IjrLqj8UVFQwZ9835+W2fz7LSahk/43dBjRtrUs2Z1Q2FlOzcvIbjHIhkLwcXZSdKhQktv7xT/6VhksOQG2Gvq7KwguCYFYWceLdjHbEDkJH+M0c1EQx8FN4COGF+6AzAui+4y/8syl3J84fKm8UH4Yst996eyg4+ZtDu3rGw8TeE7+yuIXjNqPtTJtkS3hCPMd81DjU0lPzE6mwVHAWG22lD6x1C6Qdf9urZVrlNvP7ZcnD4cUAzFgkWvTtd10385MlNPNGhyD7Xkd4RprJ1GwffsLpDKYorqGVj+47qF+1RQNFwBL5blBTT9uXO6qWYna0E8lTls
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:59:47.2459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d020bd7-ed88-4a6c-5ac7-08df0a7c0440
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7846

GICv5 uses the userspace-provided vCPU ID as the VPE ID. This must
work when vCPU IDs are sparse and differ from the dense internal vCPU
index.

Add a test that creates vCPUs with IDs 17 and 3 and runs both vCPUs to
check that ICC_IAFFIDR_EL1 reports the correct VPE ID on each.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 60 +++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 6caac6cf7c62a..d5df742b23001 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -14,6 +14,9 @@
=20
 #define NR_VCPUS		1
 #define VGIC_V5_LPI_NR_VCPUS	2
+#define VGIC_V5_SPARSE_NR_VCPUS	2
+#define VGIC_V5_SPARSE_VCPU0_ID	17
+#define VGIC_V5_SPARSE_VCPU1_ID	3
 #define VGIC_V5_LPI_MEMSLOT	1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
@@ -297,6 +300,13 @@ static void guest_code(void)
 		cpu_relax();
 }
=20
+static void guest_iaffid_code(void)
+{
+	GUEST_SYNC(FIELD_GET(ICC_IAFFIDR_EL1_IAFFID,
+				     read_sysreg_s(SYS_ICC_IAFFIDR_EL1)));
+	GUEST_DONE();
+}
+
 static void guest_spi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -1522,6 +1532,53 @@ static void test_vgic_v5_cpu_sysreg_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_sparse_vcpu_ids(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_SPARSE_NR_VCPUS];
+	const u32 vcpu_ids[VGIC_V5_SPARSE_NR_VCPUS] =3D {
+		VGIC_V5_SPARSE_VCPU0_ID,
+		VGIC_V5_SPARSE_VCPU1_ID,
+	};
+	int ret, i;
+	struct ucall uc;
+	struct vm_gic v;
+	u64 attr;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_SPARSE_NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+
+	/* Create two vCPUs with legal, albeit sparse, IDs. */
+	for (i =3D 0; i < ARRAY_SIZE(vcpus); i++) {
+		vcpus[i] =3D vm_vcpu_add(v.vm, vcpu_ids[i], guest_iaffid_code);
+		TEST_ASSERT(vcpus[i], "Failed to create vCPU %u", vcpu_ids[i]);
+	}
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v.vm);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Check both are runnable, and read back their correct IAFFIDs */
+	for (i =3D 0; i < ARRAY_SIZE(vcpus); i++) {
+		/* IAFFID is the VPE ID and must match the userspace vCPU ID. */
+		ret =3D run_vcpu(vcpus[i]);
+		TEST_ASSERT(!ret, "Failed to run GICv5 vCPU %u", vcpu_ids[i]);
+		TEST_ASSERT(get_ucall(vcpus[i], &uc) =3D=3D UCALL_SYNC &&
+			    uc.args[1] =3D=3D vcpu_ids[i],
+			    "GICv5 vCPU %u IAFFID mismatch", vcpu_ids[i]);
+
+		ret =3D run_vcpu(vcpus[i]);
+		TEST_ASSERT(!ret, "Failed to complete GICv5 vCPU %u", vcpu_ids[i]);
+		TEST_ASSERT(get_ucall(vcpus[i], NULL) =3D=3D UCALL_DONE,
+			    "GICv5 vCPU %u did not complete", vcpu_ids[i]);
+	}
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -1966,6 +2023,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 CPU sysreg attrs\n");
 	test_vgic_v5_cpu_sysreg_attrs();
=20
+	pr_info("Test VGICv5 sparse vCPU IDs\n");
+	test_vgic_v5_sparse_vcpu_ids();
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
=20
--=20
2.34.1
