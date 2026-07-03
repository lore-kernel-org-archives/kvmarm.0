Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010035.outbound.protection.outlook.com [52.101.84.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCB6FBF
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094915; cv=fail; b=F4xFvXL5+7O250Gd4+BHUpWLjyz73yMyWCQogw8mGONtoDWqv2881G6XsGroDq704qlHwSPP2y8nkTBi5SN55dVroiDr+3HvR9pPkpQf0iaMiBOD4PuvXnmAIP4nhqSVEXzCiVPRqD4GMoi/xXLCl6nFi8QRuichSZd8Ygq3hYA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094915; c=relaxed/simple;
	bh=n+bRdLlLot1TfpsAkLlcn23sNg4dsJWOdFo6sQi4gfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NvbCA8mBXOVbPRcYy+IcirdTAyQXuLjbFjSnfzmGx2jhtCUUEnSBjeGo/rlL7orv3vFvT5Rx3qQFb+q2r4kl3T37RHg2hkIm+tIeyoOe20b+xibs5pPM7UO4ccHCwrpffsXuC7YC8OE5bJngnTLOeCQAxypf5loWkRdks4eHowU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=empJgqBw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=empJgqBw; arc=fail smtp.client-ip=52.101.84.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="empJgqBw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="empJgqBw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZJkft9voYHL1toFLdvUMRGpmOTnfm4RUrHGLTtJvnIPPwU7zVzIi6pT3dtRMeIIZuLLA7sgnIfocwlZGorMdAhoMfpAI2gft2ptKkVe3sFzADqhBtHsBpsYtiTeM4YzfTU6feDy05VRdw/9GJlHyvFVzAfxtP00KHTBBxaj4k9wPf1p2DO6IxJXVnyfd4JJoY4LFxZgivL+reQu61N5CbL35ykXxotZffqaAbNoEUmqG4tD2fN/yhgCwJI70VMxD3PQWPtwlCPIZiDFsfYLJb0oSM/QVOtHN46unTVmqbitYoLkzmbuC32jX4BU9VawAL63dogQC4eNVBgwCW5wmhA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyEXP/ja2bofyYVWq4NijnD4JEXeYOU7xG64fG8DWFs=;
 b=Hh4NPIB5iB7l/7ha35OvMWdfhasozQYWg9UCVeTBu8UXFaRZ+kLDNwVUKRyLpYqNNHms+1aIV0RxxXmRlv7HVUX7OLnNKDV3aD13kpBAzPnNypw/sy9zGMSgvqsRGBBK7Bq57HBC3d4LicGmgRY8P8lnfWZf8eflfVUzH5m/oKGDBRAiDep2CzCb+tYGcLIVlk5FdKIn5qfwr7gTuTPIPt9GXzgRa8d/Bj5Pm+Zc108TO7mX5D1ymU9bKBAKKTR3DoXrJ01N6POYBFonnPhcGTYR1f7I4AgnwWGo/A/AsVWs0zEdshV+u2ELYHUi+m3RRu2Ic2BBgt4+fhpBQ7GLsA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyEXP/ja2bofyYVWq4NijnD4JEXeYOU7xG64fG8DWFs=;
 b=empJgqBwtypKUeNFHN+PCjlW1JUqRGNUBLT1m+UzYyXJs/CflDb2r7a48JvSsfrXc6uKbte1MQRLk8x/MsQ+o1DkqFVrKkIKlMBKLL0oPdgmIbFbWsl3ArE4BLoHBm2jIeTSvOxag4UrpYR8dYQUAiveVFNR4fh0UFGLCySVIq0=
Received: from AM9P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::7)
 by PAVPR08MB9842.eurprd08.prod.outlook.com (2603:10a6:102:31e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:08:23 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:20b:21d:cafe::6d) by AM9P192CA0002.outlook.office365.com
 (2603:10a6:20b:21d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Fri, 3
 Jul 2026 16:08:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYprDXd8VXxKy7m82gsReLflAYhk5SmsZncEJkZQlS+x9p/w0by8J6FTwZ+FANNhAjlUQfLRiRjT/OvsF5JzsETGADCx+xZjhzd35aWZaw3YK6o9P39DiQf4BYpBXDEhl3hQEC+XyzLXPXXEloYcD8hJ6gdwVYe1UTFiE0nSPaRcaYF9AxhuDtm6keRAVDLJX5NUzZgVlwu+NkbcXojl9EhZPIyGOOi7gapEtmuqiVpLi+aezTaT+OCTsL4bmuv+qZbP6CryJRqA7jlJ22aOJfykEfKU95XvbJNM6enPIr9FLLWVVaUxqZKC3mE6MuCZTww+O/lzjg+TPfuLqWxG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyEXP/ja2bofyYVWq4NijnD4JEXeYOU7xG64fG8DWFs=;
 b=sGBVC3ei3wy6WOiL5pfLUz4RrrAIHVcJcBWNkIzRHwG2O8jOkb6O3lMBrD8APAiFt+DdINO0nymWibDjDmigbU+EVJPBZtlb14eHhS2Bt9rgI3ThCdb4AnPoeF1XCVoU5FpdBE/969S+gkFuiit0aRm9X92YnWkY9qut+nYYNQDRXwjHk61GkiAnXLnJM6helETP7rNcz/vpQsGXF2DqCTtnfHlNedDyL6j8vCpDm6y4eHLKF2Vdmnu2Wcc7AeYiswgRW4W91uiWv+m3Ch4tDgOQ2QhXzusRCpVR7cXyudKmVQdM0SfEY4fUt1GiSjVXaZdh5YKDIFqhUAPZ187amw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyEXP/ja2bofyYVWq4NijnD4JEXeYOU7xG64fG8DWFs=;
 b=empJgqBwtypKUeNFHN+PCjlW1JUqRGNUBLT1m+UzYyXJs/CflDb2r7a48JvSsfrXc6uKbte1MQRLk8x/MsQ+o1DkqFVrKkIKlMBKLL0oPdgmIbFbWsl3ArE4BLoHBm2jIeTSvOxag4UrpYR8dYQUAiveVFNR4fh0UFGLCySVIq0=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:07:20 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:07:20 +0000
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
Subject: [PATCH v3 33/40] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace
 accessors
Thread-Topic: [PATCH v3 33/40] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Index: AQHdCwYGJr5BV1iDGUW65VmkIzWZ4A==
Date: Fri, 3 Jul 2026 16:07:20 +0000
Message-ID: <20260703154811.3355680-34-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AM1PEPF000252DB:EE_|PAVPR08MB9842:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af6ccbe-87b2-470b-3167-08ded91d4ea4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|5023799004|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 U9l52QYzYHVttv0aK/6GOzwJgDkBMd34aJy4d+ohP3nZkj/fl0Kw4pv78CuFO/JKPCtx3NkdSjUA7QpHHHb34u+KT2lJ3oCzR75ImzpxAhlzrX/QaWoWEVhq/XLwqkyd/b3jHV+b+ZsKufSHKQVrKWDlg28tyRUBGbinfa0xQF0jM9R2mqPYNXxqOx8isuEC3Egw3wL7qseuk7dM/dOWZnL0aLLGuH8wOLXXyJ75s1Dog8rZ2TCIDFAMslKyUvUoOcHfqtR6uOyuqFQrOcHlY6AIXc0eSbHMtlQZBtBgsgYT9Hmj2Oc866YDLD7YlAr6pjw4lCrdLWLS10/YzIpqB4KuKNmBpUq0jj19V/xEFGbYZo1xDVEwPNvE0dsUYbN/HPRWG/lEf65icQc+DD7jRZU05EI8tANVarhJSrnrv8xLcqe6WOCTqbHOFMalCqhAokxmvQA/KmYGes8hjmXm77xowa35+WrYcDRcqjjUUIkZ/scH53HkM7/qcjRz6DjeGlPPhJ9v5gHaxBKIscAfBCUiszF6aKEBilnbgYUYtGvUK6aLwlfBqJTTfoQ669zwd7u0fbN8rvAC28VfV+hNXQQXdv3/oPoX90Blrz+J+ZdKPUkTXtl6qow0KIT+uRMuNnHyYUJb83YSVP6+G/n0BBcfZQ4MQMU8lGwCdvLHY1QIQ1XEGh3+Ez3AjMbKP1RLGqUgBM5pWT72VZ22CZp4UxFlHD9nLfXbQyqAiGEXl+c=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006)(5023799004)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qTXDKZvdRETi39VpsIoLgRzoOtI3WHMo2mH4ufe6LYpgSqRCqJDrd+xTUTrPiMtI3ZixSu5bH+V+pEjuryKcV8JHDLKeDQQTFwhBIFvxMFT6dNKhFFhtRFXcqZp3axKdh6Xv7fhZ5cKmN6NYmJF2BIwvFcERwfm5XGSORdA+p3Bpw8333mKxJscHww5sSgXDhqA2BioCe34TQRFH/jxtVit2WH66yMff3M2ZHhcd26jBAa8KL6T69Ar/gX2IybUealvj6lbryxd39yZAd+mZMDMQEKLxWzYlik8ELrBnUzi+W4KdxZkvZD/JAIWTRu31mvtq2zOH1ObO3ecUhAx8qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1fa79ac0-5ba7-4ae7-ffd4-08ded91d297d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|35042699022|14060799003|1800799024|36860700016|376014|11063799006|5023799004|56012099006|22082099003|3023799007|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	QWQ8Y6EV2JzuFaSJvTHiQNchaLwLUL1DnoAKcxOx4zTeDC20PBq96fsS9TjstL5R/lCWrev/YjsVeCDpKuLSTfY42O0IaG9b3DYeI8EVG4ATOzXe9VME1Fqh/pCLHW8DEIgjyQPyw5GBTQ7k8Eqqg6GK1bng82gFCyAvdv6ZxaHEqWu5jI0KcefCqSUtmhLyxwe/pQ5UiNjaa+7z5GlRi79UxqqeHltxblxAZ3y8kI23K+ywJdSVU8NIKWxLyjC6rKjWDhdu13fMDiEMrSDuBGlKE+h9IeOZ0NnzilDrF44fkMsJk5HFlSTCmOUOuFQHeGwL2lfM5oBZwQ6JQJq0Wm+9aidL/nmkZYKZo0zJsbbkBINpT6tok4D6nEQeZT1fME1Zx89/b7hU3aXkUJO0bgOjfbW1zz698/7Wz7567n0wp3ae8xsdD6wl8eEuNAj+1navx9cNYmx9fjtFpcRs716qWrFvywP0SK1+oHfmSYBsg8Y3QlEo/aeH9c2wrMZ03fUN9ZE/zxNsYPcuqOhx0z0B+hTIOQ9aaHClfEpIG6uanXurip9Ks2hoZFMRX5YgqXKJfmzGc2bXqayAuwG0CGCdDAQvtJaJGBiTREcdY/+Rfta14MZ+iZH+XmwlTnkGSt8W/1x0KIW6f9XvrvE4Pj8LHPuMcDuzQJKzI8Kx64MtLQTjs/pkdqT0lR1Aq7ur/kRWpJ3viYt7Rwn/0Pm7Tw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(35042699022)(14060799003)(1800799024)(36860700016)(376014)(11063799006)(5023799004)(56012099006)(22082099003)(3023799007)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oc0cOYXljZjbyvLu2Kby+O7AQYY/HSIqgFxv2asJhO4Y6KuA1trrOWKVk6GYhNEr4U/AayadKK6WGyjWxQ5rtFCcKcBe8G44J5xOXStDssO0KKlUhIIiSmxcxabXhX+3OG+rHwg4L7iCt1PiimpkMVGiSGDrsot/avrQh4QnS/Cskamv5qAlDZnTpyWcydOtNqI9NlUWwY7upDpZnndFk55aDoO0jnPLRUoI95bU2DyhPjddPsaPXuzSY1cjV+tG/GqeZ38PmPNnvumbegXrjd/ypDj+bM8Vl3JNLSPk0Am/QmFsbrnONVBTxP7HT7bw65hTLnKTiuNGDruaGfcrYjU9ltpmeKSN6+ztlKSlY8by1mOYTdmJnqWTt0T2wPWHVkOVdkpOgM+TtqUfcnJtwVMvAWMR7vFc3TObdMlk8f/YFxgTONm9Ll0Kuqxns7H+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:08:22.8896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af6ccbe-87b2-470b-3167-08ded91d4ea4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9842

Now that KVM is at the point where it is able to run meaningful VMs
with GICv5, it is important to be able to save/restore the GICv5 state
in order to allow for VM migration.

Add functions to handle the set/get for GICv5 EL1 system registers to
facilitate the save/restore of these. These access the stored
hypervisor state for the guest, rather than the guest registers
themselves. Much of the state that is read out is generated at this
point as it is stored across a range of registers. When writing the
system registers, the state is merged back into the appropriate
places.

The save/restore accessors follow the existing GICv3 CPU sysreg UAPI
encoding, so the GICv5 device can reuse that interface once the device
attribute plumbing is enabled.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile               |   3 +-
 arch/arm64/kvm/sys_regs.c             |   6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c      | 519 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 +++++-
 arch/arm64/kvm/vgic/vgic.h            |   7 +
 5 files changed, 633 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 92dda57c08766..7aaeeb84e788e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,8 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o \
+	 vgic-sys-reg-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d45790..ba5918413f164 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5827,7 +5827,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 int __init kvm_sys_reg_table_init(void)
 {
-	const struct sys_reg_desc *gicv3_regs;
+	const struct sys_reg_desc *gicv3_regs, *gicv5_regs;
 	bool valid =3D true;
 	unsigned int i, sz;
 	int ret =3D 0;
@@ -5840,8 +5840,12 @@ int __init kvm_sys_reg_table_init(void)
 	valid &=3D check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), fal=
se);
 	valid &=3D check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs),=
 false);
=20
+	/* The GICv3 system registers... */
 	gicv3_regs =3D vgic_v3_get_sysreg_table(&sz);
 	valid &=3D check_sysreg_table(gicv3_regs, sz, false);
+	/* ...and the GICv5 system registers. */
+	gicv5_regs =3D vgic_v5_get_sysreg_table(&sz);
+	valid &=3D check_sysreg_table(gicv5_regs, sz, false);
=20
 	if (!valid)
 		return -EINVAL;
diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-reg=
-v5.c
new file mode 100644
index 0000000000000..bbdc4f222c029
--- /dev/null
+++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
@@ -0,0 +1,519 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+/*
+ * VGICv5 system registers handling functions for AArch64 mode
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/wordpart.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "vgic/vgic.h"
+#include "sys_regs.h"
+
+#define ICC_PPI_PRIORITYR_PRIORITY_MASK		REPEAT_BYTE(0x1f)
+
+static int set_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* The upper 32 bits are RES0 */
+	cpu_if->vgic_apr =3D val & ~ICC_APR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_apr;
+
+	return 0;
+}
+
+static int set_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We only support setting the ICC_CR0_EL1.En bit, which is actually
+	 * stored in the VMCR.
+	 */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_EN, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_CR0_EL1_EN, val));
+
+	return 0;
+}
+
+static int get_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * PID only applies if EL3 is present. Same applies to IPPT. Hence,
+	 * those fields are always presented as 0.
+	 *
+	 * We always present the link as connected and idle:
+	 *     (LINK =3D 1, LINK_IDLE =3D 1).
+	 */
+	*val =3D FIELD_PREP(ICC_CR0_EL1_EN,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, cpu_if->vgic_vmcr));
+	*val |=3D ICC_CR0_EL1_LINK_MASK;
+	*val |=3D ICC_CR0_EL1_LINK_IDLE_MASK;
+
+	return 0;
+}
+
+static int set_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* Set the VPMR field in the VMCR */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_VPMR, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_PCR_EL1_PRIORITY, val));
+
+	return 0;
+}
+
+static int get_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr));
+
+	return 0;
+}
+
+static int set_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+			u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	cpu_if->vgic_icsr =3D val & ~ICC_ICSR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+			u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_icsr;
+
+	return 0;
+}
+
+/*
+ * Helper macro to iterate over a range of PPIs and execute some code (to =
either
+ * extract or set the vgic_irq state). This is used when `get`-ing the PPI
+ * ENABLER, ACTIVER, PENDR and when setting the PRIORITYR state.
+ *
+ * vcpu: Pointer to struct kvm_vcpu (to which these PPIs belong)
+ * r: The register index. 0 or 1 for all except PRIORITYR (which is 0-15)
+ * nr: The number of PPIs iterated over. 64 for all but PRIORITYR (which i=
s 8)
+ * code: The code snippet to execute for each vgic_irq
+ */
+#define for_ppi_state(vcpu, r, nr, code)				\
+	do {								\
+		struct kvm_vcpu *__vcpu =3D (vcpu);			\
+		int __r =3D (r);						\
+		int __nr =3D (nr);					\
+									\
+		for (int i =3D 0; i < __nr; i++) {			\
+			u32 id =3D vgic_v5_make_ppi(__r * __nr + i);	\
+			struct vgic_irq *irq;				\
+									\
+			irq =3D vgic_get_vcpu_irq(__vcpu, id);		\
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) { \
+				code;					\
+			}						\
+			vgic_put_irq(__vcpu->kvm, irq);			\
+		}							\
+	} while (0)
+
+static int set_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/*
+	 * If we're only handling architected PPIs and the guest writes to the
+	 * enable for the non-architected PPIs, we just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them in
+	 * this case.
+	 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Merge the raw guest write into our bitmap at an offset of either 0 or
+	 * 64.
+	 *
+	 * Note that there is *NO* masking applied - the enable state is written
+	 * unfiltered. The assumption is that userspace uses this interface to
+	 * set initial state before the guest runs, and then the exposed PPI
+	 * mask is applied later, when vgic_v5_finalize_ppi_state() runs on
+	 * first entry to each vCPU. If userspace chooses to set the enabler
+	 * state later, it is fully capable of breaking the illusion we provided
+	 * to the guest by exposing register state (and PPIs) to the guest that
+	 * were not initially exposed. Good luck!
+	 */
+	bitmap_write(cpu_if->vgic_ppi_enabler, val, 64 * reg, 64);
+
+	/*
+	 * Sync the change in enable states to the vgic_irqs for the written
+	 * register slice.
+	 */
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int get_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long enabler =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ENABLER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &enabler, irq->enabled)=
);
+
+	*val =3D enabler;
+
+	return 0;
+}
+
+static int set_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Store the raw guest write. The exposed PPI mask is applied later,
+	 * when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	bitmap_write(cpu_if->vgic_ppi_activer, val, 64 * reg, 64);
+
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int get_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long activer =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ACTIVER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &activer, irq->active))=
;
+
+	*val =3D activer;
+
+	return 0;
+}
+
+static int set_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 val)
+{
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Update each struct vgic_irq with the pending state, treating Level
+	 * and Edge interrupts differently. The exposed PPI mask is applied
+	 * later, when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			bool level =3D !!(val & BIT_ULL(i));
+
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				irq->line_level =3D level;
+			else
+				irq->pending_latch =3D level;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * The pending state is generated from the vgic_irqs on each guest
+	 * entry. Therefore, we don't store the raw value written anywhere in
+	 * the case of userspace PPI_PENDRx_EL1 writes.
+	 */
+
+	return 0;
+}
+
+static int get_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long pendr =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the PENDR value. */
+	for_ppi_state(vcpu, reg, 64, {
+		if (irq_is_pending(irq))
+			__assign_bit(i % 64, &pendr, 1);
+	});
+
+	*val =3D pendr;
+
+	return 0;
+}
+
+static int set_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7)
+		return 0;
+
+	val &=3D ICC_PPI_PRIORITYR_PRIORITY_MASK;
+
+	/*
+	 * Although priorities are not regularly synced back to the vgic_irq
+	 * state, they are explicitly synced back here. This is to ensure that
+	 * any pending PPIs are evaluated correctly when first running the guest
+	 * after setting the state.
+	 */
+	for_ppi_state(vcpu, reg, 8,
+		      irq->priority =3D (u8)(val >> (8 * i));
+		);
+
+	/*
+	 * Update the state that will be written to the ICH_PPI_PRIORITYRx_EL2
+	 * on next guest entry.
+	 */
+	cpu_if->vgic_ppi_priorityr[reg] =3D val;
+
+	return 0;
+}
+
+static int get_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/*
+	 * The priorities are only synced back to the vgic_irq state when the
+	 * vcpu is entering WFI (KVM only needs to know the priorities when
+	 * evaluating if there are pending PPI interrupts for a vcpu). The raw
+	 * register ICH_PPI_PRIORITYRx_EL1 state is simply saved and restored
+	 * blindly. This state is just returned as it contains the most recent
+	 * priorities written by the guest.
+	 */
+	*val =3D cpu_if->vgic_ppi_priorityr[reg];
+
+	return 0;
+}
+
+/*
+ * The following registers are NOT supported:
+ *
+ * - ICC_HAPR_EL1
+ *	The value of this is directly generated by the GICv5 hardware based on
+ *	the ICC_APR_EL1 when the guest is running.
+ * - ICC_IAFFIDR_EL1
+ *	The IAFFID for a GICv5 VPE is the same as the VPE ID, which is the inde=
x
+ *	into the in-memory VPE Table. This is not configurable, and instead we
+ *	rely on userspace recreating the VPEs in the same order prior to
+ *	restoring guest state.
+ * - ICC_PPI_CACTIVER<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ * - ICC_PPI_CPENDR<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ */
+static const struct sys_reg_desc gic_v5_icc_reg_descs[] =3D {
+	{ SYS_DESC(SYS_ICC_ICSR_EL1),
+	  .set_user =3D set_gic_icsr, .get_user =3D get_gic_icsr, },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	/*
+	 * Only ICC_SACTIVER<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER0_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER1_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	/*
+	 * Only ICC_SPENDR<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR0_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR1_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR0_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR1_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR2_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR3_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR4_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR5_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR6_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR7_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR8_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR9_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR10_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR11_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR12_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR13_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR14_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR15_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_APR_EL1),
+	  .set_user =3D set_gic_apr, .get_user =3D get_gic_apr, },
+	{ SYS_DESC(SYS_ICC_CR0_EL1),
+	  .set_user =3D set_gic_cr0, .get_user =3D get_gic_cr0, },
+	{ SYS_DESC(SYS_ICC_PCR_EL1),
+	  .set_user =3D set_gic_pcr, .get_user =3D get_gic_pcr, },
+};
+
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz)
+{
+	*sz =3D ARRAY_SIZE(gic_v5_icc_reg_descs);
+	return gic_v5_icc_reg_descs;
+}
+
+static u64 attr_to_id(u64 attr)
+{
+	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
+}
+
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr)
+{
+	const struct sys_reg_desc *r;
+
+	r =3D get_reg_by_id(attr_to_id(attr->attr), gic_v5_icc_reg_descs,
+			  ARRAY_SIZE(gic_v5_icc_reg_descs));
+
+	if (r && !sysreg_hidden(vcpu, r))
+		return 0;
+
+	return -ENXIO;
+}
+
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	struct kvm_one_reg reg =3D {
+		.id	=3D attr_to_id(attr->attr),
+		.addr	=3D attr->addr,
+	};
+
+	if (is_write)
+		return kvm_sys_reg_set_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+	else
+		return kvm_sys_reg_get_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 2bf1930902b8e..075e4c1326754 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -542,7 +542,7 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
  * Allow access to certain ID-like registers prior to VGIC initialization,
  * thereby allowing the VMM to provision the features / sizing of the VGIC=
.
  */
-static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
+static bool v3_reg_allowed_pre_init(struct kvm_device_attr *attr)
 {
 	if (attr->group !=3D KVM_DEV_ARM_VGIC_GRP_DIST_REGS)
 		return false;
@@ -605,7 +605,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *=
dev,
=20
 	mutex_lock(&dev->kvm->arch.config_lock);
=20
-	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
+	if (!(vgic_initialized(dev->kvm) || v3_reg_allowed_pre_init(attr))) {
 		ret =3D -EBUSY;
 		goto out;
 	}
@@ -773,6 +773,92 @@ static int vgic_v5_get_userspace_ppis(struct kvm_devic=
e *dev,
 	return ret;
 }
=20
+int vgic_v5_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
+		       struct vgic_reg_attr *reg_attr)
+{
+	unsigned long vgic_mpidr, mpidr_reg;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		vgic_mpidr =3D (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+			KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+
+		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
+		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!reg_attr->vcpu)
+		return -EINVAL;
+
+	reg_attr->addr =3D attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	return 0;
+}
+
+/*
+ * Some registers can potentially be read before the core GIC & IRS has be=
en
+ * initialised. Right now, everything is required to be post-init.
+ */
+static bool v5_reg_allowed_pre_init(struct kvm_device_attr *attr)
+{
+	return false;
+}
+
+/*
+ * vgic_v5_attr_regs_access - allows user space to access VGIC v5 state
+ *
+ * @dev:      kvm device handle
+ * @attr:     kvm device attribute
+ * @is_write: true if userspace is writing a register
+ */
+static int vgic_v5_attr_regs_access(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    bool is_write)
+{
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	int ret;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&dev->kvm->arch.config_lock);
+
+	if (!(vgic_initialized(dev->kvm) || v5_reg_allowed_pre_init(attr))) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
+		break;
+	default:
+		ret =3D -EINVAL;
+		break;
+	}
+
+out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(dev->kvm);
+	mutex_unlock(&dev->kvm->lock);
+
+	return ret;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -780,7 +866,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -806,7 +892,7 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -836,8 +922,16 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
+		struct vgic_reg_attr reg_attr;
+		int ret;
+
+		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+		if (ret)
+			return ret;
+
+		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
+	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b5036170430dd..bcdac044a23f4 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -252,6 +252,8 @@ struct ap_list_summary {
 #define irqs_active_outside_lrs(s)		\
 	((s)->nr_act &&	irqs_outside_lrs(s))
=20
+int vgic_v5_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
+		       struct vgic_reg_attr *reg_attr);
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
 		       struct vgic_reg_attr *reg_attr);
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
@@ -383,6 +385,11 @@ void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr, bool is_write);
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
=20
--=20
2.34.1
