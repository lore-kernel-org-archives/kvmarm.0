Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013070.outbound.protection.outlook.com [52.101.72.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7344644212E;
	Fri, 31 Jul 2026 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785513197; cv=fail; b=MDRfAv2yE96X3FGtZU2IdohPqWp/+YmgwhYtBsW5giHdw5+xAqFE2hAwcmnjdcuehEC+sYr3YFy/G3jR+WUql1Rmt6yShKYZlMu7vC7atVU7zaF+Lkq/awk/luawuvsFHnSKGnktvAO5HA/lTVr2SjNmaU0r6Wiz1Z01cPKSsmY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785513197; c=relaxed/simple;
	bh=edBt9pyyMGo8c5Pum9olgCNeCj1uA4y7iiUvdglthZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QDPfUNElEpIrvNEkttKx3AOUJJG/GMnZHTBVjWC3bYhcLss3XMKHDEA0yFhscXf+K9l0Hhg1b0RlLmv5wSU9typUXCTw5FKi73wUzDek2wlI+b3+DLuNWOlMwr15EkKoFyrYl2kYUPm/PQOZ0hGn2zvtuOGxVNnLD7GiyoXI7/0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EHqHb5rd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EHqHb5rd; arc=fail smtp.client-ip=52.101.72.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EHqHb5rd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EHqHb5rd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ShYJ6EniTRArN9POr5833lV2h28AxPYfoTNbG/aF5eU4gcuw5TjWN0MCKd/LmLkQanW508viFrUGgIfFAdqWTDTKf+lCYNJGwcLYvqB1zQoOCTWhtcu4iACO5gOVno/nyVceGX7O2ncTJekkR1gn65tqgwc2MieyYZwpI5B9zi038pEb/zbjulyrkpHGL8+DO2KGCeR5+CV6A3pwGbWYhvtR1zX+e4nemSYPhHhE+0cQMy+QVxYl9hyv36OShC6AtcqhQvgSJAsakuAo129Ydg8/ln67OQlzkApJCXzDm9fdLaoYrqfy+7Q++8Oh0z4hrOCrtHlUq/BfKk7k45HGVw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edBt9pyyMGo8c5Pum9olgCNeCj1uA4y7iiUvdglthZs=;
 b=bVnELKR3/HagB47gf/wq4jqo4gt1OYXvfJ6iRu6T4jbXqr8F+84mjPsp1McuPm1E1nufzYLfYRk08010+f9J3DWkpTapIT71kqtjxIoLeKNIBszaICn9bvvYeMvjONIb3ULD6lxpdPb2EZEJmhpoTCiNeh3qncxSW8uNidHcmXCfDL0CLh9xIp3e+A0iqTwaoTrBgoBeT6qY6VQ54RHZpFvzKZ+f4TPxt9DQs7c072QgMyrEqZCAUFCsv0qdeDWd4V6oQBDItCidO9Nhu+9uPWb+yma6pX3h7SsFpa4gzvp1knZDJjNFLVRxc88+kbnWRI/D13i+u6XnbfDa61Y5Ng==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edBt9pyyMGo8c5Pum9olgCNeCj1uA4y7iiUvdglthZs=;
 b=EHqHb5rdI2b6MXflNqbRkYFuMuxFm/N8Xshpb1w44s7ch0uVHhZl0yrzX2kI7l35BaohQxe3dT5isV23uuj80e0VTGC0W/UQVl2QPWt/vlP9Co5QZ3AWRgkEYSFnha21sshARe5s3MMtezAGP8lSHcryCK5UxEcaYX/UihwrIJ8=
Received: from DU7PR01CA0037.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::27) by GV1PR08MB8644.eurprd08.prod.outlook.com
 (2603:10a6:150:85::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 15:53:06 +0000
Received: from DU2PEPF00028D0C.eurprd03.prod.outlook.com
 (2603:10a6:10:50e:cafe::6d) by DU7PR01CA0037.outlook.office365.com
 (2603:10a6:10:50e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 15:53:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0C.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 15:53:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlsAudBTo60WGv7Uy2t4t4IEUsQH2WMY4PAz51RVvaC2eZuq/Ax9BxsLfKQP5D9xm14Eu3Grgo29g82Qb101P7FqFHE9n9EAqz4NsO8+/T+3tXiqh62OSlalN5oSu0e0LXZSbDT5xBVHjzq/V47tj8EH7jIJ6GixYWhKybrlRY+3Z2/apxL7uwhssT9VfAdSs7fs8pxUYEjnPekMWzybx/MdhdX4FIdSLOnkL9jy4JsZQIi3f4Suc3aKxo/ckP4o9o/7QGdLi3r2g47rmfAPC8SADWlsb8nWbimMpXYdIMVk9q9Ma/Ur0YwAH2ibTosNjzMbnF7cdVylByoaYGcZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edBt9pyyMGo8c5Pum9olgCNeCj1uA4y7iiUvdglthZs=;
 b=oNC1G7b7c58dnkiXtL1JFwQJsDuzYmedQjbpQ/zRUJ1r9iIDiWBE271v949OMOn0L7XXf/7Cxzoh9cBfUc2/YKoPmRWwhHxsDHgaz8+Xw5DLcHeTxd2N5uR2KG86tAJCoQeYWg+JOTiCgvXwutT6Ljf5e1zMllp1pzNT/MtpPOckNWOnGh1enCeL7/RafspX8A+btaC/zVbClBRLSMcRQFtnb5FioePEbO144LT41Lcl16IKSYnV7WJLLM+cKHVAYdbDDqWn4Lr7qSjp0iTeHPSwAi2C/scjGCoslNhX+ha2h/QR1bnT+mehp84K9MCWYdFJStVyeMfOx9Xr6vl0eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edBt9pyyMGo8c5Pum9olgCNeCj1uA4y7iiUvdglthZs=;
 b=EHqHb5rdI2b6MXflNqbRkYFuMuxFm/N8Xshpb1w44s7ch0uVHhZl0yrzX2kI7l35BaohQxe3dT5isV23uuj80e0VTGC0W/UQVl2QPWt/vlP9Co5QZ3AWRgkEYSFnha21sshARe5s3MMtezAGP8lSHcryCK5UxEcaYX/UihwrIJ8=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS8PR08MB5912.eurprd08.prod.outlook.com (2603:10a6:20b:29f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 15:52:02 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 15:52:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Topic: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Index: AQHdG1t3ostYOtK2AEy0gxJGN9mWHbZ8kv6AgAs/V4A=
Date: Fri, 31 Jul 2026 15:52:02 +0000
Message-ID: <511941c1b8f00cbb48cb669594ea63dc665ffee3.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-43-sascha.bischoff@arm.com>
	 <20260724120628.5FF181F000E9@smtp.kernel.org>
In-Reply-To: <20260724120628.5FF181F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS8PR08MB5912:EE_|DU2PEPF00028D0C:EE_|GV1PR08MB8644:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a960eff-3c02-4e69-aaf9-08deef1bcf63
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|5023799004|11063799006|56012099006|10067099003|6133799003|22082099003|18002099003|3023799007|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 pUTtVxj07HYjD56LXHgexHhllsxUXDMMDs0Wd8xJXK2NDiqrZTOwV4Zei+LckvTLz0g1nqOCYwWGR/epyyCV5qdE+uSC7alHczEu38pw66WHrJyavzXUWUlNHbrc8xc7dN+FOCE5rpBVhNOYESGZW/emcpiuqucVnrb1Dk9cQUS+aRS8xo95VcCd6asvahKpq+09rsHn4yK622jZztleJNUgpMl97Eabgfkw3Df93bfj5NV6blRjoDlBiyrZYZdnGFNSmo5UrMsX3rIgWnWawL2T99RjDBzNZsYAWf4xa1QmVCQCMRgWKIHz2sehYQD02b49RMTrLhqkteet/65/fgfKO4PbzM384ZMDw7QOWaOcRaMdm8UOkbc8zxCvmY5gzV9QDtIE30gjQioVAXLohnn13gzIeo+ssaCSHdjxoxhSSLu1Jh+fVWvUWpZvlbFyultGH3Iei3nlnL0thWIehozlWYWld8ke8UBS1sj4fy/GJQl7cBzYOYkuvCV0dy4k7+6RnisLeoX9fSdSVzOHdRWYzgqGEvayx/Kw7Xb32II6PrR7iNJbJ9VrIXN2SeAYES12/oCdwhEm4NQPTdgaJ9HiaWPiJ8UoSoshWdZkLcijDb5aBfITZRVEjo5kkA345U6xGScHzBZPOeMAbXtXkNArtgUAYo7JPoDuAikZR7hrF+Ggtms1zr0aUqpOzGQ0N2T7HXJ169dk/65VaJLW1W+/HIHCVIQQ4P5Qn8R7IME=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(5023799004)(11063799006)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(3023799007)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEA9645B34411246A0FCD8F46D414F2F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 W8SjbmVx/Hmy1+tlU2TOeLrWhkGMcyiLU8VRwFnc8KFWCKwifabk1/b1gy4+mdesNfauWflMIs90jzSg761jRf/cVomC97mei4h5F+QFdOyo7Qgf/vRXQIrdiZNZFW5PjklYshKdgTw2kCAH4SJG+SE0hUEWgMkx7TBe/g6TPxpSeSj0Jzpzn9Nlhq14dGhRqICLT5I38JxMTi7AcOQ2vhHGFNO5IGwKwHUiu2KRwU9jsSloMhuiT3irlFdIVKBrORrTYD71CZib+wp2hBt7Agpey/EzEdsOpbJ8cSBjsfKorUhalWMfVN0vYgz9svwzBNdR21G92+IggI620t3FeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5912
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0C.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e497e6e3-3b68-417a-c089-08deef1ba9bc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|23010399003|36860700016|82310400026|1800799024|6133799003|10067099003|5023799004|4143699003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	5vmV9CQrJXUIe3dHmqS8g5sSuyl3YVa5VGAcCwLI+iYFoJLXv9KoeeYMzxadlZ0FPyMKa+wHISiIdoacwim2BlJjrFluWn3Ddw9Aw14Ydi64365vgu8Ejv6VjyjnS7jLnN7wfzUStO6c8mdC5SdN1stX/PT4EU+xw1vMwvQqHBEPDAj6NPgoKJpmCbHHaX2QKW2ChtgFL+lDcxTp7+Toibr2HBUPxYRnr4tj2VDydPxNi58ax0lC0Ub/840z8UZHXkRT23v7HYiMqnUK4SHf9FYKp57aXGhU0tgZ8mJ6qPIpqL75pJSf5SyCL+YzipXhTwnrzh8mLbqBe0Lo3voye69oCQmXy0jxnNZmkrAymHa2g5k0VKJgGniMKmohqcgPwZSxjB3F2KTXmGS41eNX6vX3znmQBBNhbxoU9Qo3jNkBVvfirNGAee++/xqqglnjQinSDgVm/B2goWrdmGK5Q53EKwbqsuaYb2IfGzs1Co7oofJpjJqZbC/XD1c9jbbK5vl+64Vyv41P911Af4cgJxsnH+SaGa4wz6WNOGOlarojZ7HSnexrAwo0237B4ptMN9Nc45YoGEE3N1qbjP39dKSVFzAYO5jMteOTk+ouvgAoYSVnTSwlgemPdWaNAptAhofyxIuZL/3h7lR39xXHAb7p3DbvRAibqOWAjCnCwoaHG8y5hPXTOwLZX/dhn4++CREwd3toc8p9Do2Tmo0Q5A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(6133799003)(10067099003)(5023799004)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vaXPOB5bubZV33fmlMPaI6TzAa3qQ6cdPO6icIOOHK/L2Qeo/zEqyJIu4rw6cq1/DoGWB2IMDFZrft4aG7gSWoLF7W7l9NvCxwACaVW+exOYmhjxF57nQjbCvEoJGtiZbnEmlNoUPZOttEvI1l7yB2wILVFldtvc3BnHmyg6ESs/kgcCKODe7igBwJtNVHlaNeoA5ueGL6TynVaSxfINjnbday/hv2ikt34D/2Sm/4XE4enCUVKl3aPe+zQqHlLMnsQcfJcslWelJk4GKtEHnlDh8eOIY5IIrvPc0ADpGpBm0y4BvFyhEDJPKeTWbtJ6maQKAdl/kIHVv1N8UEQPRRRZgEaiBDUQygrQaVyg2+05UvUwbqBf34KHZTKgF4dzc4C+g7o1WsbcI+X6HO2xvpQIaXd/Gdigs0NxqP6Hahc6iJeoWMc4rkX5Jaf7TuNP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 15:53:05.4691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a960eff-3c02-4e69-aaf9-08deef1bcf63
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0C.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8644

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjA2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBVc2luZyBhIGB1NjRgIHZhcmlhYmxlIGZvciAzMi1iaXQgS1ZNIGRldmljZSBhdHRyaWJ1
dGVzDQo+IGNhdXNlcyB0ZXN0IGxvZ2ljIGZhaWx1cmVzIG9uIEJpZy1FbmRpYW4gYXJjaGl0ZWN0
dXJlcy4NCj4gLSBbTWVkaXVtXSBgSVNUX0JBU0VSYCBpcyBjb25maWd1cmVkIHRvIHBvaW50IHRv
IHRoZSBWR0lDIE1NSU8gcmVnaW9uDQo+IGluc3RlYWQgb2YgZ3Vlc3QgUkFNLg0KPiAtIFtNZWRp
dW1dIFNwdXJpb3VzIHRlc3QgZmFpbHVyZSBvbiBoYXJkd2FyZSBzdXBwb3J0aW5nIDggcHJpb3Jp
dHkNCj4gYml0cy4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDJdOiBbUEFUQ0ggdjQgNDIvNDhd
IEtWTTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElSU19SRUdTDQo+IGF0dHJpYnV0ZSB0ZXN0cyAt
LS0NCj4gY29tbWl0IDc0NTdhZTVlYzBkMDNlNjRjZmRiNzQxOTQzNzU1OGRjN2FjYWY5ZGYNCj4g
QXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiBTdWJq
ZWN0OiBLVk06IHNlbGZ0ZXN0czogQWRkIFZHSUN2NSBJUlNfUkVHUyBhdHRyaWJ1dGUgdGVzdHMN
Cj4gDQo+IEFkZCBjb3ZlcmFnZSBmb3IgdGhlIFZHSUN2NSBJUlNfUkVHUyBhdHRyaWJ1dGUgZ3Jv
dXAuIE1pZ3JhdGlvbiBuZWVkcw0KPiBhDQo+IHVzZXJzcGFjZS12aXNpYmxlIHZpZXcgb2YgdGhl
IHZpcnR1YWwgSVJTIHJlZ2lzdGVyIHN0YXRlLCBidXQgS1ZNDQo+IG11c3QNCj4gb25seSBleHBv
c2UgdmFsaWQgcmVnaXN0ZXJzIGFuZCBtdXN0IHJlamVjdCBzdGF0ZSB0aGF0IGNhbm5vdCBiZQ0K
PiByZXN0b3JlZA0KPiBzYWZlbHkuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gK3N0YXRpYyB2b2lk
IHRlc3RfdmdpY192NV9pcnNfcmVnc19hdHRycyh2b2lkKQ0KPiA+ICt7DQo+IA0KPiBbIC4uLiBd
DQo+IA0KPiA+ICsJcmV0ID0gX19rdm1fZGV2aWNlX2F0dHJfZ2V0KHYuZ2ljX2ZkLA0KPiA+IEtW
TV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTLA0KPiA+ICsJCQkJwqDCoMKgIEdJQ1Y1X0lSU19J
RFIxLCAmdmFsKTsNCj4gPiArCVRFU1RfQVNTRVJUKCFyZXQsICJHSUN2NSBJUlNfUkVHUyBnZXQg
SURSMSBmYWlsZWQiKTsNCj4gPiArCXZhbCB8PSBGSUVMRF9QUkVQKEdJQ1Y1X0lSU19JRFIxX1BS
SU9SSVRZX0JJVFMsIDB4Nyk7DQo+ID4gKwlyZXQgPSBfX2t2bV9kZXZpY2VfYXR0cl9zZXQodi5n
aWNfZmQsDQo+ID4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJTX1JFR1MsDQo+ID4gKwkJCQnCoMKg
wqAgR0lDVjVfSVJTX0lEUjEsICZ2YWwpOw0KPiA+ICsJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5v
ID09IEVJTlZBTCwgIkdJQ3Y1IElSU19SRUdTDQo+ID4gYWNjZXB0ZWQgYmFkIElEUjEiKTsNCj4g
DQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBXaWxsIHRoaXMgYXNzZXJ0aW9uIGZhbHNlbHkgZmFp
bCBvbiBoYXJkd2FyZSB0aGF0IHN1cHBvcnRzIDggcHJpb3JpdHkNCj4gYml0cz8NCj4gDQo+IFRo
ZSBhcmNoaXRlY3R1cmUgYWxsb3dzIHVwIHRvIDggcHJpb3JpdHkgYml0cywgd2hpY2ggZW5jb2Rl
cyBhcyAweDcuDQoNCkl0IGRvZXM/IFRoYXQncyBuZXdzIHRvIG1lIQ0KDQpUaGUgc3BlYyBzYXlz
IDUsIGVuY29kZWQgYXMgMGIxMDAuIFdlJ3JlIGV4cGxpY2l0bHkgdHJ5aW5nIHRvIHRlc3QNCnNv
bWV0aGluZyBpbnZhbGlkIGhlcmUuDQoNCj4gSWYgdGhlDQo+IHRlc3QgcnVucyBvbiBhIGhvc3Qg
d2hvc2UgaGFyZHdhcmUgbGVnaXRpbWF0ZWx5IHN1cHBvcnRzIHRoaXMNCj4gY29uZmlndXJhdGlv
biwNCj4gS1ZNIHdpbGwgbGlrZWx5IGFjY2VwdCB0aGUgd3JpdGUgaW5zdGVhZCBvZiByZXR1cm5p
bmcgLUVJTlZBTCwNCj4gY2F1c2luZyBhDQo+IHNwdXJpb3VzIHRlc3QgZmFpbHVyZS4NCg0KQW5k
IGlmIHN1Y2ggYSBob3N0IGV4aXN0cywgdGhlbiB0aGluZ3Mgc2hvdWxkIGZhaWwgYmVjYXVzZSBp
dCBkb2Vzbid0DQptYXRjaCB0aGUgc3BlYy4NCg0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArCXJl
dCA9IF9fa3ZtX2RldmljZV9hdHRyX2dldCh2LmdpY19mZCwNCj4gPiBLVk1fREVWX0FSTV9WR0lD
X0dSUF9JUlNfUkVHUywNCj4gPiArCQkJCcKgwqDCoCBHSUNWNV9JUlNfSURSNSwgJnZhbCk7DQo+
ID4gKwlURVNUX0FTU0VSVCghcmV0LCAiR0lDdjUgSVJTX1JFR1MgZ2V0IElEUjUgZmFpbGVkIik7
DQo+ID4gKwl2YWwrKzsNCj4gPiArCXJldCA9IF9fa3ZtX2RldmljZV9hdHRyX3NldCh2LmdpY19m
ZCwNCj4gPiBLVk1fREVWX0FSTV9WR0lDX0dSUF9JUlNfUkVHUywNCj4gPiArCQkJCcKgwqDCoCBH
SUNWNV9JUlNfSURSNSwgJnZhbCk7DQo+ID4gKwlURVNUX0FTU0VSVChyZXQgJiYgZXJybm8gPT0g
RUlOVkFMLCAiR0lDdjUgSVJTX1JFR1MNCj4gPiBhY2NlcHRlZCBiYWQgSURSNSIpOw0KPiANCj4g
W1NldmVyaXR5OiBNZWRpdW1dDQo+IENvdWxkIHRoaXMgY2F1c2Ugc3B1cmlvdXMgdGVzdCBmYWls
dXJlcyBvbiBCaWctRW5kaWFuIGFyY2hpdGVjdHVyZXM/DQo+IA0KPiBLVk0gcmVhZHMgYW5kIHdy
aXRlcyAzMi1iaXQgYXR0cmlidXRlcyB0byB0aGUgdXBwZXIgMzIgYml0cyBvZiBhIHU2NA0KPiBi
dWZmZXINCj4gb24gQkUgc3lzdGVtcy4gVGhlIHZhbCsrIG9wZXJhdGlvbiBpbmNyZW1lbnRzIHRo
ZSBsb3dlciAzMiBiaXRzLA0KPiBsZWF2aW5nDQo+IHRoZSBhY3R1YWwgMzItYml0IGF0dHJpYnV0
ZSB2YWx1ZSBpbiB0aGUgdXBwZXIgMzIgYml0cyB1bnRvdWNoZWQuDQo+IFdoZW4NCj4gdGhpcyBp
cyB3cml0dGVuIGJhY2ssIEtWTSBtaWdodCBsZWdpdGltYXRlbHkgYWNjZXB0IHRoZSB1bmNoYW5n
ZWQNCj4gdmFsdWUsDQo+IGNhdXNpbmcgdGhpcyBhc3NlcnRpb24gdG8gZmFpbC4NCg0KVGhpcyBp
cyBhIHU2NC4gV2UgYXJlIGluY3JlbWVudGluZyBhIHU2NCBhbmQgcGFzc2luZyB0aGF0IGJhY2sg
dG8gS1ZNLg0KVGhlIHZhbHVlIHdpbGwgc3RpbGwgYmUgaW5jcmVtZW50ZWQgY29ycmVjdGx5LiBU
aGlzIGhhcyBub3RoaW5nIHRvIGRvDQp3aXRoIGVuZGlhbm5lc3MuDQoNCj4gDQo+IFsgLi4uIF0N
Cj4gDQo+ID4gKwkvKiBTdGF0dXMgcmVnaXN0ZXJzIHJlYWQgYXMgaWRsZSB0aHJvdWdoIHVzZXJz
cGFjZQ0KPiA+IGFjY2Vzc29ycy4gKi8NCj4gPiArCXJldCA9IF9fa3ZtX2RldmljZV9hdHRyX2dl
dCh2LmdpY19mZCwNCj4gPiBLVk1fREVWX0FSTV9WR0lDX0dSUF9JUlNfUkVHUywNCj4gPiArCQkJ
CcKgwqDCoCBHSUNWNV9JUlNfU1lOQ19TVEFUVVNSLCAmdmFsKTsNCj4gPiArCVRFU1RfQVNTRVJU
KCFyZXQgJiYgdmFsID09IEdJQ1Y1X0lSU19TWU5DX1NUQVRVU1JfSURMRSwNCj4gPiArCQnCoMKg
wqAgIkdJQ3Y1IElSU19SRUdTIFNZTkNfU1RBVFVTUiBpcyBub3QgaWRsZSIpOw0KPiANCj4gWyAu
Li4gXQ0KPiANCj4gPiArCS8qIFVzZXJzcGFjZSByZXN0b3JlIG9mIElTVF9CQVNFUiB1cGRhdGVz
IHN0YXRlIHdpdGhvdXQNCj4gPiBhbGxvY2F0aW5nIElTVHMuICovDQo+ID4gKwl2YWwgPSBGSUVM
RF9QUkVQKEdJQ1Y1X0lSU19JU1RfQkFTRVJfQUREUl9NQVNLLA0KPiA+ICsJCQkgR0lDVjVfSVJT
X0NPTkZJR19CQVNFX0dQQSA+Pg0KPiA+IEdJQ1Y1X0lSU19JU1RfQkFTRVJfQUREUl9TSElGVCk7
DQo+ID4gKwl2YWwgfD0gR0lDVjVfSVJTX0lTVF9CQVNFUl9WQUxJRDsNCj4gPiArCXJldCA9IF9f
a3ZtX2RldmljZV9hdHRyX3NldCh2LmdpY19mZCwNCj4gPiBLVk1fREVWX0FSTV9WR0lDX0dSUF9J
UlNfUkVHUywNCj4gPiArCQkJCcKgwqDCoCBHSUNWNV9JUlNfSVNUX0JBU0VSLCAmdmFsKTsNCj4g
PiArCVRFU1RfQVNTRVJUKCFyZXQsICJHSUN2NSBJUlNfUkVHUyBmYWlsZWQgdG8gcmVzdG9yZQ0K
PiA+IElTVF9CQVNFUiIpOw0KPiANCj4gW1NldmVyaXR5OiBNZWRpdW1dDQo+IElzIGl0IGludGVu
dGlvbmFsIHRvIGNvbmZpZ3VyZSB0aGUgSW50ZXJydXB0IFN0YXR1cyBUYWJsZSB0byBvdmVybGFw
DQo+IHdpdGggdGhlDQo+IFZHSUMncyBvd24gTU1JTyByZWdpb24gaGVyZT8NCg0KSXNoLiBXZSBq
dXN0IG5lZWQgYW4gYWxpZ25lZCBhZGRyZXNzIHRoYXQgd2UgY2FuIHdyaXRlIHRvIHRoZQ0KSVJT
X0lTVF9CQVNFUiBhbmQgcmVhZCBiYWNrIGFnYWluLiBJdCBpcyBuZXZlciB1c2VkLg0KDQpJJ3Zl
IGNoYW5nZWQgdGhpcyB0byB1c2UgYSBjbGVhciBwbGFjZWhvbGRlciBoZXJlLg0KDQo+IA0KPiBH
SUNWNV9JUlNfQ09ORklHX0JBU0VfR1BBIGlzIHRoZSBiYXNlIGFkZHJlc3Mgb2YgdGhlIElSUyBN
TUlPIHJlZ2lvbiwNCj4gYnV0DQo+IHRoZSBJU1Qgc2hvdWxkIHR5cGljYWxseSByZXNpZGUgaW4g
c3RhbmRhcmQgZ3Vlc3QgUkFNIChzdWNoIGFzDQo+IFZHSUNfVjVfTFBJX0lTVF9CQVNFX0dQQSku
IElmIEtWTSBhZGRzIHZhbGlkYXRpb24gaW4gdGhlIGZ1dHVyZSB0bw0KPiBlbnN1cmUNCj4gSVNU
X0JBU0VSIHBvaW50cyB0byBhIHZhbGlkIG1lbW9yeSBzbG90IGluc3RlYWQgb2YgYW4gTU1JTyBy
ZWdpb24sDQo+IGNvdWxkDQo+IHRoaXMgY29uZmlndXJhdGlvbiBiZSByZWplY3RlZCBhbmQgYnJl
YWsgdGhlIHRlc3Q/DQo+IA0KPiBbIC4uLiBdDQo+IA0KVGhhbmtzLA0KU2FzY2hhDQo=
