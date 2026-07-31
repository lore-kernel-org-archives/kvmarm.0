Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010036.outbound.protection.outlook.com [52.101.69.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957CF3B058A;
	Fri, 31 Jul 2026 09:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490458; cv=fail; b=QGrvXmIY6On8qIjFcDCaHWvxUr4+4NSIHiDD2fY/u9KAU4m/78CVKIO9KwAjx92sQGBV2pu+VLYAbBotaFcQprzCEyP1q6JqI6gWwrQbS6kecuVwd9iCp8ZceZ76goFAbygwhRjmG/RFedpS4MvNXMgA3z4xSYmvHM09VxXpSDY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490458; c=relaxed/simple;
	bh=5fS8KQl0EBPraHsrwiRBR7GcS8ByFVoyrcWXzY7WTgs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aYvzkH0yAj5g6MDG0WGaqLpA0Wg1ZM79yBMVXUwVq4dJRAz48+7qtV/ojTsMciXxHNxB4xRfO9P7Oai4F4vj2ek7uH/G0fCWn13Po8HaDUXibzgE+HA+tNIiR3BPJfG1ldqjFkGIDdqeqksQxYb1pQAK+ZpBiRpmMLg1iN2bwSM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ghL9VPoJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ghL9VPoJ; arc=fail smtp.client-ip=52.101.69.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ghL9VPoJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ghL9VPoJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lB302rz9+G04k6Ux3LHjzILp9sb5pUTUrS9LCfRrqQSjO6Qq/8XG0YBVNsu5jzY+3kR6s1XxjD1HFbykpb8xYMYVW2/w1oMn0jm+IGxSQwc8O43R1S13tFQNQsyv2WEpX9fEeWbep7bZB2GouzjxJYurK4Co9g9f6z9a627srbU3LzkISaXR7wM6fRzMTGwGlE9759qVeVkx/XEecTDAB3POZMn43uq/7OJNw4FRLN3Jv2Fsq0Lz11ailuxqA2GcnHCMsuZR+FrHQNFA/Dfhv16DVueJBuoytj1um0nTktAebSO+GGcFi4xxroY21TyCLPHsuSHIvl7jC37itpPjaA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fS8KQl0EBPraHsrwiRBR7GcS8ByFVoyrcWXzY7WTgs=;
 b=rUmz+/qRJmFMtbZrRAUhcjEMDdIRae5FRBPiVa/9m/b1SHSyXEVqYoXgUhuYB7ntTmhUEgnAk0KWiWVHpS9IC+oqSxLMP1LW+l85VGtRYXnT365ESVojg0F7fW9GmlE2p3/+GwQlWoR98bvmrJLGLd1jFUIhSsOkPf/Kafguw+wue159G1asfmXGpq4urkfCIM+RqJOyJRYNcYZ0kLurBTATBctc0pMJVQgjS+mNQlgwPfiMR5Kdkv2Z4BLFwuZ0CaTE5ia0YYnGQnBvKMJ6IDuHtUxcgL3GFmN2W3xapdvdSlY44Y8qeN19Sm/KBL1RI2iNKpit9+Z7PIjQy2kcwg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fS8KQl0EBPraHsrwiRBR7GcS8ByFVoyrcWXzY7WTgs=;
 b=ghL9VPoJFseJOj2eNalHUWUvAfvFsHKRRx9O69siRbpLuOSDRqDqoGZkhAaHlAZe32IJe/tBi+yHdtusA53hmWvSReW2Vw0YhC9zTo0wGcwMNVh2AOe9o0xXcd8Kzv2lF3rQTmyBudglKWtuNWdYZA2FNo+NaU4zUdIs0qJYGDs=
Received: from AM0PR10CA0028.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::38)
 by GV2PR08MB9328.eurprd08.prod.outlook.com (2603:10a6:150:d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:34:11 +0000
Received: from AM3PEPF0000A796.eurprd04.prod.outlook.com
 (2603:10a6:208:17c:cafe::1e) by AM0PR10CA0028.outlook.office365.com
 (2603:10a6:208:17c::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 09:34:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A796.mail.protection.outlook.com (10.167.16.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joTKrXyBoo7cZFdOMKGER5gWjRDD+jxrPjyug0dIkyCDHmUgB50IhCE/YAZuDYw8zEzL97boSicSl300j3Ym6BXDA6M5UHzfCFN1WSLFdLQ09VIHgf14aP/EVXWj9gZ0guNzVdrrCEFQR7AeXlYZs9JXHWwzsilcxNNoujqZouDrSqx9TuGTIbwsnr/KwCMqd7+Ud08jkguaJjTaVCXmqllx0S58FVCKRXjTHgTb+3Eodzbh6tEWug9ehhfNddLChaYxMwgFUmAi9TkyNTLI0Seiwa5EU6tprhejbA7d/xVQIQAkKQKX6ecdUSmDEW404f92YVZzl9aBaSR0VvrO1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fS8KQl0EBPraHsrwiRBR7GcS8ByFVoyrcWXzY7WTgs=;
 b=hFFjyPrfEbCzwXrXqzNB+knLbddtZkEiCcgO/VMGDc5yiUqV1vdrRGgFKRrq02DsCHhlSutfULlsqL1d34b9v1Yd4gbueAWpzyfKSL9G6ncvcW5MiXNoe82SaHsqqfhoG7js0Te3s32I/Tsmw+VcQFN20JnDB+PrOuebf42JnqNM9QjtXFh+JTna4QJTX8NZKj8CiBRhfBeZfL7WC8GAq8R6BDaxN3XcxoOt9wVTL5rlMmEdmw+nBB9rASJOYJwIKDl+WrHBA4IInZbbeLtzyqVo+9HcFcrr+fv7drSKVJrbjc0EZiB8hcwJQx1fCa8umIZ7MORJwn0FplEhlYhmrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fS8KQl0EBPraHsrwiRBR7GcS8ByFVoyrcWXzY7WTgs=;
 b=ghL9VPoJFseJOj2eNalHUWUvAfvFsHKRRx9O69siRbpLuOSDRqDqoGZkhAaHlAZe32IJe/tBi+yHdtusA53hmWvSReW2Vw0YhC9zTo0wGcwMNVh2AOe9o0xXcd8Kzv2lF3rQTmyBudglKWtuNWdYZA2FNo+NaU4zUdIs0qJYGDs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GVXPR08MB10861.eurprd08.prod.outlook.com (2603:10a6:150:154::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:33:08 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:33:08 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdG1o9o4xfPVyRiEiLv1Ols+Ph4rZ8g6gAgArk0gA=
Date: Fri, 31 Jul 2026 09:33:07 +0000
Message-ID: <2b43bb2d8c79d8ee1d053eba7f4a3470c7645300.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-9-sascha.bischoff@arm.com>
	 <20260724111133.6B12E1F0429A@smtp.kernel.org>
In-Reply-To: <20260724111133.6B12E1F0429A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GVXPR08MB10861:EE_|AM3PEPF0000A796:EE_|GV2PR08MB9328:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b97ffac-a296-4067-4557-08deeee6e09a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|11063799006|6133799003|56012099006|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 WBjL8jmBLAlFrxq8y2e9bbC4a7chJ9H4FEuYTF7Q09Mv5ffH2dHIwDUpaaAWEbk9+KNAec2ncjZolv8K6Ppz0ssvT6kmLdm9cY8TbXk6hwWrikAThCMUEgaPVGkId25j86vQ4Dz0MAVu1YGYQvwbUUsAd6pfFiIkL3ataZZ+cPwxSENoGbJnUCx7nIAtamQWozf6KVfk2yBmOUxW3xFyu9vQJGyEZXyd1alLHutL896QbmD5fjYYwmXB1R9xfqhDhj+gPkH9FDVizr6jSIpUfve2u9uRRu9+tnuF/aW3MhTSTj1b/v0767QI/s+UMq0ajjVO4v4gf62nadgD3X2MBMNCfWA6A4HcHx2HDdLDbEmjtKSrontLX4TfEt7UF7/5SaWA30ESlArnhrtt36KDGE6pkJiDhaoVrlo7iRMXuqy+jOtNWFqkW/V9U3qQ5eRwdRHCTAcyEHd/TXSf7b/WZkKP+m4uyOmO0Dx0MtnsNk+cByUCPMA2J6hiPTJgnHlGAO5jdqRJOPK/2uoimtjqIVuKm383sCVoGE2Ba2oekiH4Ik2LvLycKX0zRRTcngkRIvsjwUTrQlALKyWk832znpny/y4S3kmOCqONAnVi4k6ORQuVwRp086gTlvlH1x2uC6bmiJzQGRsvG32wv3wl6DIaDey48pbD8U7cffGY0LCRvm5/3LOokvcttTWSIXqNEucpwYLz9MagifI21ytdkiWOeJtD3JYMiltNYlEBqK0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <46E7F2421C9FAF4BB4A918BC93EF6FC8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 F0PCIzf0zhpW02YubwYxbfhmIFwjTuD1ta18onKwzbBs8P3iyA299riK6s1JISxIIqGYIfqM1yNgI2/n5q4YQ2Ja7wxH0pyVrMP2RPICeDl7FwGll39fSgXeoEsegA45kkE7QEHt6qYYNTnMokpsHHs/r2KGfsH9uxrHUs2I9QwL6Q95ZfxqnrY8W1Jvl0diu+ZzhC2qbizHeTBbfW3915FTqrH4cGMj5v4rkE96fdY7p6SuHdh4ul38gpvs6imb4xdFQyZEYFchbX7N9j0p/tuwTmM+fRCUb64iuLrYq2/l2ZyEPCujfExFCM5IT2n/i5zgGTQoyElO4r6oEjkgkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10861
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6986cb8f-849b-4471-b3f3-08deeee6baf5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|35042699022|14060799003|376014|4143699003|56012099006|11063799006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VGx6fX+lMHOkqGjqkuQX6oSxGpfCm3Vi2Qty7IN1Jj1DSG/CLpanrV1+VW6Jr9DQLasHm6PZoT+7vTxireJ6e3l8rg3SgxQ7Fsl3DBfmlUxsw3iSdXLdmgJJ4jOpARLu7zs8c44loV/RO6WzxU30HdDrHaUDaDgGcimTiZ5aeoWMnjpVFCr6LS1rSaULu5TJ53p6SLtfZryld62KLTVlv18p0s6oTUJpDfFUejlCYGAgfIp5KSWSAs1IGnAa6nq2du9sk0wk7DqTuZbY8hDcsRCTAZEJUSZmFjP8vCYZba7/Og4a/9pIyoTn9mxCBuXsxTUXEHhSDeZQDU2Z5yK2i+kmQBaCeA0RAsV5tzbQ6BF4qFerg3h8Dc8A2p/KT4yvDBc9UKl2Q+hV3mi8TlKtzq/48/XwQDKHUOrNvAd7NR7gsyp0olMls8NTOQmXnBhx04s2iAQLCTlylERCBEk4xY2Fd0WZ/JeIsrMh//CeZGm8VjQyIiGRByTfW+pNgG8X8AQaEwDww2JemTOtervNRJF1D65WB5VH4gXwp8DDLdsDXLTiVYcJWYK4pd0x3TcVm6VDfjfMdFRuqHeC8eAm6frvlm+yCclflXHyWXmjHBmhqghqm1jezUKhpGcl8EJfWco5tEuAMA4TBZbbz/y/IZbW5sB6/pzEs7B9h0+irQUxuURbl82VpqivG5yQPgFC2/4eDEqXIPVRscUEJ8BXng==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(35042699022)(14060799003)(376014)(4143699003)(56012099006)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uMON5Ylsulz1gfS0S4mXaZhiQ6rMIM+gRV3X4awjdusrw5gjyQOWsdQg5Rtavl4fo1gvnVZRGFU2Q6TMfbVHFyGcYtQ8dBqz30PqP6TSSNfgBH1jLpjQQyVzZ7rRC2NgUsc0FSAbdkeHOFPZjAKENfX8zEOEoDPFX7f8cCqu4xb66L6p6eMXry56WkF/j7fP10xafMQzDaiFcMIb82RdEmrg7NLEyRah6NUHUI6UH9QHsWp48VdDbzdYb2nJtq6UoGbQS3nFjyMkwj67+lLxJoNI6Z58zKLaKNxzPuwGnFnpN6oFhqNL5LK3esj97lepkmX35ikwnztTJqOKx833bfnK+FRKeOpFGzyRwvpFb2AsecWD3R+laGR2HTrP8yQogqzYNdYcBcSJblMteHizrFm9Qpa3Wea6rxN3zPDwFdRmdWcGtNz1jqJ4HFOWVar7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:34:11.0414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b97ffac-a296-4067-4557-08deeee6e09a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9328

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjExICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiA+ICtzdGF0aWMgdm9pZCB2Z2ljX3Y1X3RlYXJkb3duX3Blcl92bV9kb21haW4o
c3RydWN0IHZnaWNfdjVfdm0gKnZtKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIXZtLT5kb21haW4pDQo+
ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlz
IGNvZGUgbGVhayB0aGUgYWxsb2NhdGVkIGRvb3JiZWxsIElSUXMgYW5kIHRoZWlyIHJlcXVlc3QN
Cj4gaGFuZGxlcnM/DQo+IA0KPiBEdXJpbmcgaW5pdGlhbGl6YXRpb24sIHZnaWNfdjVfY3JlYXRl
X3Blcl92bV9kb21haW4oKSBhbGxvY2F0ZXMgSVJRcw0KPiB2aWENCj4gaXJxX2RvbWFpbl9hbGxv
Y19pcnFzKCksIGFuZCB2Z2ljX3Y1X2luaXQoKSByZXF1ZXN0cyB0aGVtIHZpYQ0KPiByZXF1ZXN0
X2lycSgpLg0KPiANCj4gU2hvdWxkIGZyZWVfaXJxKCkgYW5kIGlycV9kb21haW5fZnJlZV9pcnFz
KCkgYmUgY2FsbGVkIGJlZm9yZSB0ZWFyaW5nDQo+IGRvd24gdGhlIGRvbWFpbj/CoA0KDQpZZXMs
IGl0IHNob3VsZCBkbyBpcnFfZG9tYWluX2ZyZWVfaXJxcygpLiBJdCB3YXMgbWlzc2luZyBpbiB0
aGlzDQpjb21taXQsIGJ1dCBpcyBoYW5kbGVkIGluIGEgZnV0dXJlIGNvbW1pdC4gSSd2ZSB1cGRh
dGVkIHRoaXMgY29tbWl0IHRvDQpjYWxsIGlycV9kb21haW5fZnJlZV9pcnFzKCkuDQoNCj4gUmVt
b3ZpbmcgYSBkb21haW4gdGhhdCBzdGlsbCBoYXMgYWxsb2NhdGVkIElSUXMgY2FuIHRyaWdnZXIg
YQ0KPiB3YXJuaW5nIGluIHRoZSBjb3JlIElSUSBzdWJzeXN0ZW0sIGFuZCByZXBlYXRlZGx5IGNy
ZWF0aW5nIGFuZA0KPiBkZXN0cm95aW5nDQo+IFZNcyBjb3VsZCBldmVudHVhbGx5IGV4aGF1c3Qg
dGhlIElSUSBkZXNjcmlwdG9yIHNwYWNlLg0KDQpUaGFua3MsDQpTYXNjaGENCg==
