Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013056.outbound.protection.outlook.com [52.101.72.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E7418C008;
	Thu,  9 Jul 2026 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783597257; cv=fail; b=Jls0x1FtFjCIL+ooHKrMT55a9LWIPhGUQHtF4538cM8kXrzJefk6dEW2+U6aTm2EheuD5OoSW2YgnoqllsOx5tIGMaAcYR21buUBXQUfOsnI0n/7ont0GzSS6l+8oQe1/inX/MNr1JM7d4isbYNKAu/UaE16a4lNx0rj64VQ5/s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783597257; c=relaxed/simple;
	bh=isIRQFONsHrmJmjUC059463ZDwYMqRUutslMjAOwsWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ABI+qSY+I9Wh77Ii/5c8I6h1mpn0zWf8t8GLGFzMa8uUH4OnSD1W1Fy4vgkw3PA5NAvNTIh/e0T1vdS1WnZ0DxQJaIUY4d1voZzYwsBtJ/LSH3A8eB4jwVeykJyanCfW/vSQb7Wjz4egTHQF+ST0YT4LwThl0lZjca4BbqRm0kc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TuVk6TvE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TuVk6TvE; arc=fail smtp.client-ip=52.101.72.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TuVk6TvE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TuVk6TvE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oOAEz5gsd7sfR+7vSS47VnigAaOmmS1vIHH/oOHcvhSJVBQ55vFxzH5+D7gQxMlxzuZ+0VQEcxNQcQMkoTEWZUcw2JRO7HunHB8lLZyREtvhClTxszuzYdNxsE1vmhCwygf7V0fGcjN/w9kQdTqGPcpMUO+95zN3/6bOjPX8GWAYOQH9SEhRtOe14zXZ8idawl1S8iep54IbpL++SgoSoS0MfNAzGoahuqPjq+AJLE+pvI8wSuxx79QJoffY4cEWxVMpUQ0xJbs3Mk7xI3PglqJCUwm4DZcbA+D/ww6DEkkvuYUjiG0xqr8AIOppgR8v26lqMcwq6Ze55LYAiSRPiA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isIRQFONsHrmJmjUC059463ZDwYMqRUutslMjAOwsWQ=;
 b=KB93ZK+/rG8yI+K0RH8o7otAA9gY81dwRwhgxCgNBZYRTTSDWm39ahHWO4jCZtpYSXoCRyt/+TIQQqXODQPXapKmUBUJQabfTNSV/a6qHyH3IlOG67bZZNt5NfNbmm7yO5iubIguhsLHlN3N0RkhrJ7v0hTd89TIJIdMPu8k3zMQ/TwdyHS6OGCAm1vw/BiD7FyH9aJvUCG1wwCebYp77KUpB7+VY6SFw/TOh7QKwdoBVv+n4BGE7UE9v5p8n3MfaV2vx1q4m65uvxBjdzVsJUts2GctCP5mD0nW9i2Q3B7d1daewRN6M7UFDNDM+/klr2bsoomLYPo2EJrl2k0NJw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isIRQFONsHrmJmjUC059463ZDwYMqRUutslMjAOwsWQ=;
 b=TuVk6TvEZ7fuJylKUT4yiqg90AVwxnbu35O+zyer+ReQ6sG3pi6OyhEOkyG/zJCrtKTBXkX8+sNaP3+i1/Xf8dPe+yRmedfWFPKHlvduUOSSARb9i/aaKXITe9HSNeRtXAHYbunCAvKhWtYCLjrv9Tm+gP6grb/2ohm9+rnFDrs=
Received: from FR3P281CA0073.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1f::17)
 by DB9PR08MB8226.eurprd08.prod.outlook.com (2603:10a6:10:39e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Thu, 9 Jul
 2026 11:40:48 +0000
Received: from DB1PEPF000509F4.eurprd02.prod.outlook.com
 (2603:10a6:d10:1f:cafe::60) by FR3P281CA0073.outlook.office365.com
 (2603:10a6:d10:1f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.3 via Frontend Transport; Thu, 9
 Jul 2026 11:40:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F4.mail.protection.outlook.com (10.167.242.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Thu, 9 Jul 2026 11:40:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRtu8bgnsKqzJKy41Gs+ZgDzSGVU8Baa5D5XfSIeciY+Her0sdz5iWS9pbKnA/l/YGdOzHtiJrMRL5I6z++R0boRXJ5a4+ANrWquU0HHTryA+59M2v5PviIm3XA2StN9h7U66ABEkMr0lp0EyeEp8g2joi1QFdAY4isaUJWD2KRdaJfuw1opGXIXQzdWLL2JYtbY0C+8ywaPlQJkcIYf0OxH1IyVOtbOMcDhu6Oh5SG3yR94WmKm23aT7tgSoVQM6K6gtrnPWIpnG9xmHZI5SxTCkW6v4w02phcwfsXYMX7IPA1bF1YwrxoQqVBO1r45zw43ZOjZYA6T2SiroCqaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isIRQFONsHrmJmjUC059463ZDwYMqRUutslMjAOwsWQ=;
 b=OWp8Ag9piNC8NGV34PmYNchGW8H4B7ByTKn25vykmq2NraOov4SqrxOgzM3xG6jWNik6JrCflUZuRSVxqjv2Faw8SU2IB1XLDR65vmr7OjCN/yNPHsyVimpSJTK8aj0v4Gy+tljLocang4R4RMYW446KKke3ROao6sMu+johv4J1Y6uKCFF2pd8gHTC9QrH8gBKU3Dl4oUzNzT/NVi1ty8OvGLEi2npVAMZjICvIWGNmOqYrfsvubcTzowyJDfCmL+t0cNUvHWl7QkO88UJ6Z/ZWOsYjjNYxYxhglXIO5cWEE4kmjQ5dZzCVT37FzjC+laqzyRnl72CeKHWmJs/g+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isIRQFONsHrmJmjUC059463ZDwYMqRUutslMjAOwsWQ=;
 b=TuVk6TvEZ7fuJylKUT4yiqg90AVwxnbu35O+zyer+ReQ6sG3pi6OyhEOkyG/zJCrtKTBXkX8+sNaP3+i1/Xf8dPe+yRmedfWFPKHlvduUOSSARb9i/aaKXITe9HSNeRtXAHYbunCAvKhWtYCLjrv9Tm+gP6grb/2ohm9+rnFDrs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU0PR08MB8470.eurprd08.prod.outlook.com (2603:10a6:10:406::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 11:39:43 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Thu, 9 Jul 2026
 11:39:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 23/40] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v3 23/40] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdCwVQPWmLJFHgdUS0om/TT2vVKrZb/YQAgAkbs4A=
Date: Thu, 9 Jul 2026 11:39:42 +0000
Message-ID: <d26f4556dfbc6885209396e5578077a0754e83d7.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-24-sascha.bischoff@arm.com>
	 <20260703163413.4C5351F000E9@smtp.kernel.org>
In-Reply-To: <20260703163413.4C5351F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU0PR08MB8470:EE_|DB1PEPF000509F4:EE_|DB9PR08MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 5375bc2b-ff96-488b-35e3-08deddaeebb5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|18002099003|22082099003|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 b1yrNZnnjQgP+5eT1sEE2fDCt/g6zY5xHcQS36CZFQ/Sqov8Kp4Zth2D88evsPV+SRKDE59N0oHWQ36649w2dgSe28K2hqsThNxeEBH1bxm+p1zRimqObnORqM6KuzAfhA+gKpch5HOg+5Vh3rA399pQUhCQiooTWVRBQig/XvcBqydcxLVw8M5cdEtlmTqGWOG6UhCVLpABklbcHOnLaKWXDsIWdSeENoEyBma72eU6cCQKaBml/jZXJzVp2xSpKO9vJZHtAIhvwXLKNhKJc+LIBKABvXuAbfSDG/SVL1r9zrnRzZCJSrFTR75Faw3o/k2BxXIdQvAO3V3jKwYmuRFUSF8YRHGwlSt3yVoVlpn71jCS+kQ42A6vnqZlt+7NSX/OkrfGFwa/wFGZ+28oV7vpfTKWVnJkcXjN7doOCKufYOeRNsugBRPrZ6S/AxTsf05yeKNnwtdNVeeMiG19Spn6hYIfiNI51jkyE35pP47jjmN2QRx54EfMm9LL/fuoSNikpMFs2YqAZqHhrpYh2w4YHkzkTWOr4G50HpKCK19VrmS9SSEp0mUPWW5+PRgjllwHQQIZFHe2i8yNzCGNIw9TZZbvuqGdtmjW6dVxkShKwN0CYpDxvyQHcH7XWYAVVtLLL8ruW3/59kEsXeuWJHaU3w4lurQXSujkt6e/XA/4zNgqthjEcem/At03ZaXvr/9MDtvC1RUhYPhrUOkas0pQyh5NtUe/EfMpDcMX0LU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D12355E2B4AE1A4096BF954000A93501@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 M8eAByVZU+NG7ZBzT0/UjmMvpSIC7A+jK04Qluaodw/rvwTr1ht327U6+9F6m7p2KB3heSsqwYu91o5tRTfTyb+k6DgPcAnK6WJ8KdSfqjoDvpMW0haiWHvOo202DdpOgW8ocG4qf1rGQEKS+tRGmHssY+vCmfhtwC11MksotM22s+XcSUNcDwnIq6o+Eud/h3w/3YgRes596LQmoWYRn+zAiPt7lilW+QwGAcOqddF1TZcyg0bOOuwVSZ1/NXFW0l9VMM+LWV8g7vXR7dOfQBxAMkryXRmkYeFCGB/1ERglNNo72uUGvJ3ny0DSCtWR2/2qhmkUNh78AB4P8hxXCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8470
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	608eee6b-06bb-41e4-f645-08deddaec4d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|35042699022|23010399003|14060799003|56012099006|4143699003|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	iYkd2If1kGQg0Q0Hc60jcWTuY9k1Z2+rzQ0kq5Mq/yoHwlo92PCsdrLTBONBHycET08JwI66STS4RB1U15vBg253HgAdh1pHpaM3bOAFE/0rcfxGmnGRmy2M/QFgZTZWnEymfy39YEWDY1u6yVEPtWeRit5aVDGPTnYGQKnhDjxPgKyByXaBzaBNBCW3zuU5XQ7ZfKc78BReDDbf7zuykrdtjwVl2m/pYWE1UP/RfQn0PDXzdbHAif2pGjx2kNiUK3Ysb4H4VF2C9iWhWOHbTcr2kxhRHAUZFFN04xsrxqFsdFa47b5xGbGerCbJfBKo8CkE6/mXaNLAll8TV7xhYmrX+xmPnjQf7WNEE192vZttnxkp486EaD5AP/Fa6YImH30RYvK7dJCpjsokSnyubRUqCVArYq8HTVQ2znbeKJzx5Be4u24dL3/EXff6pEIK2ZkQuDe2KPTjZqIYlXXZ61fVNAPwBlL0EKd0hTQFm8Bi9vEfy0gMnvXemwIUtS68aoMQ0pza5lfv6LWX6miJSF300pF9zgFNMECO1IzeQLhceC2gg3PwqDV+WYRUvSSxvPRWTjLrDmNnsLKJ0tLhf6/wjlSzC/TGqi4dNfcrrPQIh7fsEWw9T8WepDHfdLCdRzvb/c3I5EgVedVQwzO1e6IoHNEETqVxWEhnLD5Al0uNS45oOCGON1jgyR++DDShiYSVSzI+sQ8/qJhxpdHXJg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(35042699022)(23010399003)(14060799003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JCzrUr/swSMv8GZU0G/NKfy3T2am6+nsSkqXLl2Be+Y9Xai0Pu1/9gNYnxnDOdsF8aPWNKKo7u40Ui8UZgJRApQuSdwdSwSjb3YLUaOxGEAH+6CL1QBRwY9LowNa7Z0jNKybLNCF3SAmXxHocz1Vx9TSf2GvYSplGfPXvkxVjUwpu9c67KkTfdAGCstTofrCzJNplY8NT645WwTEj/sQXHaERbG7u4K2rSdaGEFgRootmOjlUHNHh867kBiEGABZNV4Fqmvh0KxXB4w3/hUC7pU8BvV+bLOsoRVwECStQRRP+FeqmqTv51VdvIRd47XN+ifblf+2QFv2hzl6+crjAY1LyEfPink1YIGXAT4BOWRCarM4SLbABTbdIj2NoqBLTqwc+WzP4Pxj0oFeld3Q6JOkXBK/8hIN190VWDLxYJtc/Z0rn/PyzD1hFyW2Wr/q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 11:40:48.0772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5375bc2b-ff96-488b-35e3-08deddaeebb5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8226

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIEdJQ3Y1IElDSF9DT05URVhUUl9FTDIuSVJJQ0hQUElESVMgaGFyZHdhcmUgc3RhdGUN
Cj4gYmVjb21lcyBzdGFsZSB3aGVuIHRoZSBndWVzdCBkeW5hbWljYWxseSBjaGFuZ2VzIHRoZSBJ
UlMgZW5hYmxlDQo+IHN0YXRlLg0KPiAtLQ0KPiANCj4gY29tbWl0IGQzMTM5OTJkZTM3Njg0ZmVh
MjM2YjAwMTAzYjg3NDEyMjYwNjA4ZDENCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2No
YS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBTZXQgSVJJQ0hQ
UElESVMgYmFzZWQgb24gSVJTIGVuYWJsZSBzdGF0ZQ0KPiANCj4gVGhpcyBjb21taXQgdXBkYXRl
cyB0aGUgR0lDdjUgSUNIX0NPTlRFWFRSX0VMMiByZWdpc3RlcidzIElSSUNIUFBJRElTDQo+IGZp
ZWxkDQo+IHRvIHJlZmxlY3QgdGhlIGh5cGVydmlzb3IncyBJUlMgZW5hYmxlIHN0YXRlLiBJdCBh
cHBsaWVzIHRoaXMgc3RhdGUNCj4gZHVyaW5nDQo+IHZnaWNfdjVfbG9hZCgpIHRvIGNvbnRyb2wg
dGhlIGRlbGl2ZXJ5IG9mIFNQSXMgYW5kIExQSXMgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggMmRmNjE0MjZjYzcxNC4uZmZiMDUwMGE0Yzlh
NyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsr
KyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gQEAgLTEwNTgsNiArMTA1OCw3
IEBAIHZvaWQgdmdpY192NV9mbHVzaF9wcGlfc3RhdGUoc3RydWN0IGt2bV92Y3B1DQo+ID4gKnZj
cHUpDQo+ID4gwqANCj4gPiDCoHZvaWQgdmdpY192NV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkNCj4gPiDCoHsNCj4gPiArCWJvb2wgaXJpY2hwcGlkaXMgPSAhdmNwdS0+a3ZtLT5hcmNoLnZn
aWMuZW5hYmxlZDsNCj4gPiDCoAlzdHJ1Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZiA9ICZ2Y3B1
LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZnaWNfdjU7DQo+ID4gwqAJdTE2IHZtID0gdmdpY192NV92
bV9pZCh2Y3B1LT5rdm0pOw0KPiA+IMKgCXUxNiB2cGUgPSB2Z2ljX3Y1X3ZwZV9pZCh2Y3B1KTsN
Cj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gwqAJY3B1X2lmLT52Z2ljX2NvbnRleHRyID0gRklFTERf
UFJFUChJQ0hfQ09OVEVYVFJfRUwyX1YsDQo+ID4gdHJ1ZSkgfA0KPiA+ICsJCQkJRklFTERfUFJF
UChJQ0hfQ09OVEVYVFJfRUwyX0lSSUNIUA0KPiA+IFBJRElTLCBpcmljaHBwaWRpcykgfA0KPiA+
IMKgCQkJCUZJRUxEX1BSRVAoSUNIX0NPTlRFWFRSX0VMMl9WUEUsDQo+ID4gdnBlKSB8DQo+ID4g
wqAJCQkJRklFTERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX1ZNLA0KPiA+IHZtKTsNCj4gDQo+IFtT
ZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlzIGxlYXZlIHRoZSBoYXJkd2FyZSBzdGF0ZSBzdGFs
ZSB3aGVuIHRoZSBndWVzdCBkeW5hbWljYWxseQ0KPiBjaGFuZ2VzDQo+IHRoZSBJUlMgZW5hYmxl
IHN0YXRlPw0KPiANCj4gV2hlbiB0aGUgZ3Vlc3QgdG9nZ2xlcyB0aGUgSVJTIGVuYWJsZSBzdGF0
ZSBieSB3cml0aW5nIHRvDQo+IEdJQ1Y1X0lSU19DUjAsDQo+IHRoZSBNTUlPIGhhbmRsZXIgdHJp
Z2dlcnMgYSBzZXF1ZW5jZSBsaWtlIHRoaXM6DQo+IA0KPiB2Z2ljX3Y1X21taW9fd3JpdGVfaXJz
X21pc2MoKQ0KPiDCoMKgwqAga3ZtX2FybV9oYWx0X2d1ZXN0KHZjcHUtPmt2bSk7DQo+IMKgwqDC
oCB2Z2ljLT5lbmFibGVkID0gISEodmFsICYgR0lDVjVfSVJTX0NSMF9JUlNFTik7DQo+IMKgwqDC
oCBrdm1fYXJtX3Jlc3VtZV9ndWVzdCh2Y3B1LT5rdm0pOw0KPiANCj4gQmVjYXVzZSBrdm1fYXJt
X2hhbHRfZ3Vlc3QoKSBzaW1wbHkgc2VuZHMgS1ZNX1JFUV9TTEVFUCBhbmQNCj4ga3ZtX2FybV9y
ZXN1bWVfZ3Vlc3QoKSBpbW1lZGlhdGVseSBjbGVhcnMgdGhlIHBhdXNlIGZsYWcsIHJ1bm5pbmcN
Cj4gdkNQVXMNCj4gdGhhdCBleGl0IHRvIGhhbmRsZSB0aGUgcmVxdWVzdCB3aWxsIHNlZSBwYXVz
ZSA9PSBmYWxzZSBpbg0KPiBrdm1fdmNwdV9zbGVlcCgpLg0KPiANCj4gVGhleSB3aWxsIHRoZW4g
cmUtZW50ZXIgdGhlIGd1ZXN0IHdpdGhvdXQgY2FsbGluZyBzY2hlZHVsZSgpLCB3aGljaA0KPiBi
eXBhc3NlcyBrdm1fYXJjaF92Y3B1X3B1dCgpIGFuZCBrdm1fYXJjaF92Y3B1X2xvYWQoKS4gVGhp
cyBtZWFucw0KPiB2Z2ljX3Y1X2xvYWQoKSBpcyBuZXZlciBjYWxsZWQgdG8gdXBkYXRlIGNwdV9p
Zi0+dmdpY19jb250ZXh0ciB3aXRoDQo+IHRoZQ0KPiBuZXcgaXJpY2hwcGlkaXMgc3RhdGUuDQo+
IA0KPiBTaG91bGQgdGhlcmUgYmUgYSBtZWNoYW5pc20gdG8gZm9yY2UgYSBHSUN2NSBjb250ZXh0
IHJlbG9hZCAoc2ltaWxhcg0KPiB0bw0KPiBLVk1fUkVRX1JFTE9BRF9HSUN2NCkgdG8gZW5zdXJl
IHRoZSB1cGRhdGVkIHJlZ2lzdGVyIHZhbHVlIGlzDQo+IGFwcGxpZWQ/DQo+IA0KSSd2ZSBhZGRl
ZCBLVk1fUkVRX1JFTE9BRF9HSUN2NSwgYW5kIGhhdmUgYXBwbGllZCB0aGUgc2FtZSBsb2dpYyBh
cw0Kd2l0aCBHSUN2NCB0aGVyZS4gV2Ugbm93IGV4cGxpY2l0bHkgdmdpY192NV9sb2FkKCkvcHV0
KCkgb24gYWxsIGd1ZXN0DQpWQ1BVcyAoYXMgd2FzIG15IG9yaWdpbmFsIGludGVudCwgYW5kIEkn
ZCBub3QgcmVhbGlzZWQgdGhhdCBqdXN0IHRoZQ0KaGFsdCB3YXMgbm90IHN0cm9uZy1lbm91Z2gp
Lg0KDQpUaGFua3MsDQpTYXNjaGENCg==
