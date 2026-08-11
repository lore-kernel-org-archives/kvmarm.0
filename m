Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013013.outbound.protection.outlook.com [40.107.159.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B353264FF;
	Tue, 11 Aug 2026 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786460413; cv=fail; b=aaqAIdJrnavqpqGm4USxGLImmnNRAAsZqL54AM/eUTphMcZHDflEi3hTUIPApFNxL6rqGHqyBA9K/QR2kzNoXQag9o3wD1UnajQ4/cpnIz+yu69FpLqGI5Y+nb9xMiqZVGF/6ht3LfRp7GND2cgEgVagb1mMnQ3frYAs4qY5k0o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786460413; c=relaxed/simple;
	bh=DFC5GybdDTbU1NJP35VSW4FzTdlzP+qQ/g1QOtJwjMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XNaSYfD8SRGALTz78+la8h9YbqFCUr/vb7hjHhsduU/x2Cbnpqy5BWdV4otDS2WhR9avsW09vutmEIdsHrqJPUVxCECP+7KZoVSX+pec3zXqZdOYiwXTrCHGnL41g+kybRBhbsyX2zoxVFourJ21dPa/QAcoIi8FAtGu/EqxwQk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pBE7nR8v; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pBE7nR8v; arc=fail smtp.client-ip=40.107.159.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pBE7nR8v";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pBE7nR8v"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nCkVxBE6CEvsJaPwLkzwOh9pvk3Fjdwn6FD5Lc1goqNy2IjibE4dFLFgVDeQakXkMl1h4lUZDzBCseAyKUJNF5UnSPxGn5qOkEiS5FVNa5j4bGCgicpjA3nF/U1J2OHKx203gT9EtkIR1QeM4rV580d6Y8ZLAnGVOoDV64M10DXmd3uEqCXKCz+GtkdLrg/jlCQz7VM5lnMJ7fUzf6ZAjRPBX04fHKOK8AyClJiQJiwDEFVEFQAYG+/5GoCvKFzzvHBW3tRvUoeFoyvaYDjSaP7RDpW46bp3Zzyf344q7t+d+u/4mAxoocdIHmdkEOKY4yLP6Lxx2G59oC/DckiMsA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFC5GybdDTbU1NJP35VSW4FzTdlzP+qQ/g1QOtJwjMc=;
 b=LeS9qhQujNB/RfwoT2+FyS35livOyzYIdCTO5Aq8ekrEl+Kt/BYWuyoApBflCyN9xdg2WkaJ0RAfdyumaFqD/fqBH0DZeT3wstW3DQ6cHaj64yOAPCYoXuduIPDZ3nvDzOOGo+KWvWBML9ubcX3gY7PqDYEco0iR6lgkd0Nyq0UTiN2r6zsiH9+o0ZWzySuT3yXJ8OTHFCfY+NRxJ7IyqnzJqgTO43CTjadqXYf+EBTE/zr/SxdjF/2d0eewdfPJV4pn748v4pqmzGgiNFIVIavs7NhoC69YKDMRe1iTE8pyX6iHajSX0LN9lIN/BOqSzCnZk5RqR1v6WoY57kfmkQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFC5GybdDTbU1NJP35VSW4FzTdlzP+qQ/g1QOtJwjMc=;
 b=pBE7nR8vThr06JoG4c+GU+hEHd7NZocu4AJGdIm8bBbNaLc24djaFGhGHQWA0tMwWeHA4c2NBU7uy1f5/BeVfE2HVZMkFLhuQqxr8jCLkIm0ATZ/feEL1LHhv43dXAH9cdxaiXx/q3cLnb8jKCrbbuBph3uiCurWdfMCgWiBwes=
Received: from AS4P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::18)
 by DBBPR08MB5913.eurprd08.prod.outlook.com (2603:10a6:10:20b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:00:03 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::23) by AS4P251CA0013.outlook.office365.com
 (2603:10a6:20b:5d2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Tue,
 11 Aug 2026 15:00:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:00:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5B0gGi0JOBliGhr3MC/mYOgz3Ycn6uN1H50v4KgvnHcBpC3uAcFduvXlGhMeyb2Gc4b2xPmAC5Q0EXgun1sxpfMQD8R9ZyYEhOh6GMi900jjhBRy7jWjzvy/3vOrkzoUhSd4ZOS+qKxySLj4woJY+fTXwZrGE4kZrmspdMt8yvoxtdAkfRhMJ6NUNUD/zP3Edpx4oNgxXnKPg0T3IK39M8KLhyKm1xpcqHiVjS3ipAsrA7ZRqFSf8dDIiUfHqzz1szpqWe150wVTMXDIJnyH/qvBA5M2vvOZPi1jpxULkBXh3QT3TdyLlQjQ0GC4C6YCIZQFF/jHTCdBR8OY69+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFC5GybdDTbU1NJP35VSW4FzTdlzP+qQ/g1QOtJwjMc=;
 b=VkjslklKrronyUSbHpF0ak8g/1c7aWWvETZdKQsJ7WBmjXRlbmNQzPaKoCKJVvJFOJMvasqIvNMxMKlqE020vn6oxmPea0hfXJW+amMszlXQwEiLr1SjrO5B3lR/fy+uo12L+2+UuQkUGtmWUIq6/c7VKtCEjv8KZwK/VJsKC/W5xYLXOkvrKe7mg4YxOtij1IWylU8F0GaCg1xiVTORp74koAS2RpsIO21fy5OPJNR9bB3mVYE2Vtuw8g9E0TLFOayJMJbpn3LU3nUclv+HpXJQLHxz3hDBffGwy2SHj/tJ4nPBzpjxvcrst5jrtoyobjM7VX4/Tv/bCz9jb189BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFC5GybdDTbU1NJP35VSW4FzTdlzP+qQ/g1QOtJwjMc=;
 b=pBE7nR8vThr06JoG4c+GU+hEHd7NZocu4AJGdIm8bBbNaLc24djaFGhGHQWA0tMwWeHA4c2NBU7uy1f5/BeVfE2HVZMkFLhuQqxr8jCLkIm0ATZ/feEL1LHhv43dXAH9cdxaiXx/q3cLnb8jKCrbbuBph3uiCurWdfMCgWiBwes=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU0PR08MB8812.eurprd08.prod.outlook.com (2603:10a6:10:47b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 14:59:27 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 14:59:27 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Thread-Topic: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Thread-Index: AQHdKLMlod7tzVDC5EqI7uHOH0KrTbaXIekAgAHQsQA=
Date: Tue, 11 Aug 2026 14:59:27 +0000
Message-ID: <b146aa155e87f2f76e74e10c233cd95c3671e60a.camel@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
	 <20260810102652.758719-6-sascha.bischoff@arm.com>
	 <20260810111614.DDC731F000E9@smtp.kernel.org>
In-Reply-To: <20260810111614.DDC731F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU0PR08MB8812:EE_|AM3PEPF0000A79A:EE_|DBBPR08MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: c8fb0858-6374-4688-3aa4-08def7b938fb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|11063799006|56012099006|10067099003|6133799003|3023799007|22082099003|4143699003|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 YmKWOxmrcVMaSohTjzWo7ixRqQdhnjz+PP+rXzwEL92824i2ItaHlb56Qb6skrCMk5wyPOcudphGcWfIToXXDWcr38iJEGSuwSvQU1BBbJRDSJmayoVyjQIQbxIQ0Hnn5dYtVAM6VidC7ZOfLVlYxEZuy4PsKpB6CQAKjw5XoGOv5AhZjS/rJM7oZV1eMECnIxDNaacAPT3fhGpfgBeJ+U9IG7RpEAmJECgLZsZX+Y06IwvNdZICy9ckyLJD/dlyQ4Q+JEdnZ3j7U1BIqN/LIzLvhMynhM5V/K02lQTc8QZ76BLO60pZZ2nBgNwRAWi5i+LhrEHTVKr6UdxIYh6qQu0WoYZVSqMkXMXuBw/rZDOjdMAz1mV9DC5Vvi0NR020EWo815qjpiTs+sDQzMqyAN1DesACS3Z0KwU9zFLXY+Gqh1n5wmLf8uYCJDKMCbcU69S7EzkD7owHaKO0QkaBRpvS3iJl66h+Jv/TzkvaJjySfRQToVs6kXwoP5QX0twx2NuXVry6t/S9p+JjS3GIvWxqbGl9JqQgYSMarhWjvXaAXM+ZzBCS1kMelvYIePf9VBTb5bACJljFva/Z0ct4SjKvMbO3KT6CzJR46slEHdjnGJ7O5PB5wQ8OVx3mSoVgzEBIs7mXpp+bDlSXj6pcQmvOgV+P9BityNOkJBQp4pQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(22082099003)(4143699003)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB494E08734B01448087C573458D1E5D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 mWurXji5WxWi2DOeT8YlU8aPIMRv9YLhtD76HJeD7p6UJrTNscPKVwmu8CqLoOZCgahlOKf99ZT9EJ94PYWAmpNDydJENjzZhRxuzr4kqK3zpgtZyUWUB7XGGm0LYcyr6nEgKhpa2ToNjA+wowBFTou9NU4l1WBfoJpYv3jEiZAJXsKMJ2I20Jja8kX44bD30SV2/jurDwCrlqIS8upZQPDtI/xqnmVv7Im3/6vkmKY8gH6JsmTwQQP6CEz9XxSJBqkbYpp2CqkhF/9IjcnnOS3ziajgYNRKpJM4m48YxeDKWKAAV69HjYN0xHZJbI2RVkBKjF8YcLO0nibRrttNKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8812
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	71b84756-a089-470c-cb99-08def7b923b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|14060799003|36860700016|35042699022|13003099007|22082099003|18002099003|3023799007|56012099006|10067099003|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	B/5Hx5XxfBiq3QzQ4UvEmnl7/1vvTUVR8ExiJji1k3wT1vtHk2LhBn6gK75ceU+WAKUq3nTOMXlPJXZX8jLwfDKnc/ueuIBJmrrmqdtEmGTapXh0hQ0zLDVbzbBKgKqVpxhkUGeuUE1LZb3iQzrb5kawCk2jvyYX31OIO73jP/qOUZcRx31GvdelZ5ZY2BFU3xBpoaupu9UUvIVuvNdMx3sUak4BJMH/HqFxzep3umTdsghYnSmwgEzj1+sSXId3FGsZjt/s9/U7AoU4r0S7niPLSPkJvI3Ba/DM0tf7lyBVfmaiWksvNypA/pi4oi+uyYgIlEQs3juSSks/3nyHtKJ+5OPFpmPWxqOCOgGroWZeUn3RJCbiKGFq4uW9ZU9Ro54mmAM8nwuotz22kNncQZ0RL2aylQBPerTRLk2V7FN7FDeXLvKUsK1Rh8RFwjopGDq+k0C6ubxni7kk1t181kK9KMVz1hnysfklhuFUwnapP0Sn/dtJr+rjH0bELVxd+XGI8b03J2ntAkKtVM0DLcIL1FTb+1nfdpnasdMNfbHYsI89hE/mWvn2ETX2tS7Q775sXKZkiIpKfekyrpojHH7K/1QDKKA6QhGYDd7X9vdEXyvBgljeas7HI36m/35ha5PZlTuWlpCToMr5DxzTgg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(13003099007)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CLFvK2Vs6IY3FcLovUYlLQS5Dp0NhDmeHnP5lmtA+cJ16anUAXaEtFUL+J6RsvWfy5h8iFlyy2OeeNMOScJnRRWnTDMXWw0XsAhsJY1mZNfyOh/SXRA2NULkvMAfKu8oKW0BhCSK6FbfMqL/zofopX/ZTek/TZ9b2X1MgXuaXyvnk84j3em2hKoZQlPrjd9V9GsMxcivYOchgn6ofMDtUFCl6z19mQtI5Md+P0QlEJXCHdN16Htq1M9GCfBcwb1llrcaDebNCPRWm6+n8WPsGbt6JpqiZMCDqeGLCd/n9KcSjQG3cMK/4jTOWB6FCb2hZG/nne7AcVe4Ha9+AkLu9WUlHixeQIyO2RkylRfkaUwz8VRiv7A/3rHakJDXNdkyOF2KWcK6A/RYvRDaX6cinIsg6fpSBFx1MFQGFHDebn7OD6pDbXOFxKQ8J2bQ7Re0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:00:02.9271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8fb0858-6374-4688-3aa4-08def7b938fb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5913

T24gTW9uLCAyMDI2LTA4LTEwIGF0IDExOjE2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIFJldHVybmluZyBOVUxMIGZvciBvdXQtb2YtcmFuZ2UgR0lDdjUgUFBJcyBjYXVzZXMg
YQ0KPiBkZXRlcm1pbmlzdGljIGhvc3Qga2VybmVsIHBhbmljIHZpYSBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2Ugb3INCj4gQlVHX09OKCkgZHVyaW5nIHRpbWVyIGluaXRpYWxpemF0aW9uIHdpdGgg
dXNlci1jb250cm9sbGVkIGlucHV0cy4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNV06IFtQQVRD
SCA1LzVdIEtWTTogYXJtNjQ6IHZnaWM6IFJlamVjdCBvdXQtb2YtcmFuZ2UNCj4gR0lDdjUgUFBJ
IElEcyAtLS0NCj4gY29tbWl0IGI3NDUzNjRkZTg2ZWQ4ZjM3OWQ5Mjk3YzJkMzM0ZTdhNzM0NjU0
ZDYNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0K
PiANCj4gS1ZNOiBhcm02NDogdmdpYzogUmVqZWN0IG91dC1vZi1yYW5nZSBHSUN2NSBQUEkgSURz
DQo+IA0KPiBUaGUgY29tbWl0IHByZXZlbnRzIEtWTSBmcm9tIGNsYW1waW5nIG91dC1vZi1yYW5n
ZSBHSUN2NSBQUElzIHRvDQo+IGluZGV4IDAuDQo+IEl0IGludHJvZHVjZXMgYSBjaGVjayBpbiB2
Z2ljX2dldF92Y3B1X2lycSgpIHRoYXQgcmV0dXJucyBOVUxMIHdoZW4NCj4gdGhlDQo+IGV4dHJh
Y3RlZCBoYXJkd2FyZSBJUlEgSUQgZXhjZWVkcyB0aGUgc3VwcG9ydGVkIHJhbmdlLg0KPiANCj4g
TGluazoNCj4gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwNzI0MTA0ODE5LjEy
OTY4MDMtMS1zYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT9wYXJ0PTI3DQo+IA0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLmMNCj4gPiBpbmRleCAzMDc3Y2ZkYWExNDZkLi5kMGM5MWYwYzUyNjk4IDEwMDY0NA0K
PiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gKysrIGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBAQCAtMTE4LDYgKzExOCw4IEBAIHN0cnVjdCB2Z2ljX2ly
cSAqdmdpY19nZXRfdmNwdV9pcnEoc3RydWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUsIHUzMiBpbnRp
ZCkNCj4gPiDCoAkJc3dpdGNoICh0eXBlKSB7DQo+ID4gwqAJCWNhc2UgS1ZNX0RFVl9UWVBFX0FS
TV9WR0lDX1Y1Og0KPiA+IMKgCQkJaW50aWQgPSB2Z2ljX3Y1X2dldF9od2lycV9pZChpbnRpZCk7
DQo+ID4gKwkJCWlmIChpbnRpZCA+PSBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUykNCj4gPiArCQkJ
CXJldHVybiBOVUxMOw0KPiANCj4gW1NldmVyaXR5OiBDcml0aWNhbF0NCj4gRG9lcyByZXR1cm5p
bmcgTlVMTCBoZXJlIGFsbG93IGEgbWFsaWNpb3VzIHVzZXJzcGFjZSBwcm9jZXNzIHRvDQo+IHRy
aWdnZXIgYSBob3N0DQo+IGtlcm5lbCBwYW5pYz8NCg0KV2UgYWxyZWFkeSByZXR1cm4gTlVMTCBv
biB0aGUgb3RoZXIgcGF0aHMgc28gdGhpcyBpcyBjb25zaXN0ZW50DQpiZWhhdmlvdXIuIEhvd2V2
ZXIsIHRoZSBmb2xsb3dpbmcgaXMgZGVmaW5pdGVseSBhbiBpc3N1ZSwgYWxiZWl0IG5vdA0Kd2l0
aCB0aGUgZ2VuZXJpYyB2Z2ljIGNvZGUuDQoNCj4gDQo+IElmIGEgdXNlciBjb25maWd1cmVzIGEg
Vk0gYW5kIHNldHMgdGhlIHRpbWVyIElSUSB0byBhbiBvdXQtb2YtYm91bmRzDQo+IEdJQ3Y1IFBQ
SQ0KPiBJRCAoPj0gNjQpIHZpYSB0aGUgS1ZNX1NFVF9ERVZJQ0VfQVRUUiBpb2N0bCwgdGhlIGlu
cHV0IGlzIHZhbGlkYXRlZA0KPiB1c2luZw0KPiBpcnFfaXNfcHBpKCkuIEJlY2F1c2UgaXJxX2lz
X3BwaSgpIG9ubHkgY2hlY2tzIHRoZSB1cHBlciB0eXBlIGJpdHMNCj4gZm9yIEdJQ3Y1LA0KPiBp
dCBhY2NlcHRzIHRoZSBpbnZhbGlkIElEIGFuZCBzdG9yZXMgaXQuDQo+IA0KPiBXaGVuIHRoZSB2
Q1BVIGlzIHN1YnNlcXVlbnRseSBydW4sIGt2bV90aW1lcl9lbmFibGUoKSBpbml0aWFsaXplcyB0
aGUNCj4gdGltZXJzDQo+IGFuZCBjYWxscyBmdW5jdGlvbnMgbGlrZSBrdm1fdmdpY19zZXRfb3du
ZXIoKSBhbmQNCj4ga3ZtX3ZnaWNfbWFwX3BoeXNfaXJxKCkgd2l0aA0KPiB0aGUgb3V0LW9mLWJv
dW5kcyBJUlEuIFRoZXNlIGNhbGxlcnMgbGFjayBOVUxMIGNoZWNrcyBhbmQgYXNzdW1lIHRoZQ0K
PiByZXR1cm5lZA0KPiBwb2ludGVyIGlzIHZhbGlkLg0KPiANCj4gRm9yIGV4YW1wbGUsIGt2bV92
Z2ljX3NldF9vd25lcigpIHVuY29uZGl0aW9uYWxseSBkZXJlZmVyZW5jZXMgaXQ6DQo+IA0KPiBh
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYzprdm1fdmdpY19zZXRfb3duZXIoKSB7DQo+IAlpcnEg
PSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+IAlyYXdfc3Bpbl9sb2NrX2lycXNh
dmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsNCj4gCS4uLg0KPiB9DQo+IA0KPiBBbmQga3ZtX3Zn
aWNfbWFwX3BoeXNfaXJxKCkgZXhwbGljaXRseSBhc3NlcnRzIGl0IHdpdGggQlVHX09OKCk6DQo+
IA0KPiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYzprdm1fdmdpY19tYXBfcGh5c19pcnEoKSB7
DQo+IAlzdHJ1Y3QgdmdpY19pcnEgKmlycSA9IHZnaWNfZ2V0X3ZjcHVfaXJxKHZjcHUsIHZpbnRp
ZCk7DQo+IAkuLi4NCj4gCUJVR19PTighaXJxKTsNCj4gCS4uLg0KPiB9DQo+IA0KPiBTaG91bGQg
dGhlIGJvdW5kYXJ5IGNoZWNrIGJlIGVuZm9yY2VkIGVhcmxpZXIsIHN1Y2ggYXMgZHVyaW5nIHRo
ZQ0KPiBpb2N0bA0KPiB2YWxpZGF0aW9uIGl0c2VsZiwgdG8gcHJldmVudCBzdG9yaW5nIHRoZSBp
bnZhbGlkIElEIGFuZCBjcmFzaGluZw0KPiBkdXJpbmcNCj4gdGltZXIgaW5pdGlhbGl6YXRpb24/
DQoNCldlIHNob3VsZCBmaXggYm90aCBpc3N1ZXMsIGFuZCBzaG91bGRuJ3Qgd29yayBhcm91bmQg
YW4gYXJjaCB0aW1lcg0KaXNzdWUgaW4gdGhlIGNvbW1vbiB2Z2ljIGNvZGUuDQoNCkkndmUgYWRk
ZWQgYSBjaGVjayB0byB0aGUgaXJxX2lzX3BwaSgpIGhlbHBlciB0aGF0IGNoZWNrIHRoYXQgdGhl
IElEIGlzDQp2YWxpZCBmb3IgR0lDdjUuIFRoaXMgaXMgc2FmZXIgYW5kIG1vcmUgY29uc2lzdGVu
dCB3aXRoIHdoYXQgd2FzIGRvbmUNCmZvciBHSUN2Mi8zLg0KDQpJJ3ZlIGhhZCBhIGNsb3NlciBs
b29rIGF0IHRoaXMgYW5kIGNhbiBjb25maXJtIHRoYXQgdGhlIGFyY2ggdGltZXIgY29kZQ0KaGFz
IGEgYnVnIHdpdGggR0lDdjUgd2hlcmUgd2UgbG9vayB1cCBhIHBvdGVudGlhbGx5IGludmFsaWQg
SVJRLCB0aGVuDQpwYXNzIHRoZSBOVUxMIHBvaW50ZXIgdG8ga3ZtX3ZnaWNfc2V0X293bmVyKCks
IHdoaWNoIHRoZW4gdHJpZXMgdG8NCmRlcmVmZXJlbmNlIGl0LiAgSSdkIGFkZGVkIGFub3RoZXIg
cGF0Y2ggdG8gdjIgb2YgdGhpcyBzZXJpZXMgdG8gZmlyc3QNCmNoZWNrIHRoZSBQUEkgaXMgY29y
cmVjdCBhbmQgb25seSB0aGVuIHRyeSBhbmQgc2V0IHRoZSBvd25lci4NCg0KPiANCj4gPiDCoAkJ
CWludGlkID0gYXJyYXlfaW5kZXhfbm9zcGVjKGludGlkLA0KPiA+IFZHSUNfVjVfTlJfUFJJVkFU
RV9JUlFTKTsNCj4gPiDCoAkJCWJyZWFrOw0KPiA+IMKgCQlkZWZhdWx0Og0KPiANCg0KVGhhbmtz
LA0KU2FzY2hhDQo=
