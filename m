Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013045.outbound.protection.outlook.com [40.107.159.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E13AD529;
	Wed, 15 Jul 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784131443; cv=fail; b=pQh6EvYsHFm4EaGQXDE8rMhgZGgjRx5ojVfO/dQZKGV1XVJgeh7WLdn/fi9OyUYOJHf+jIjOprkoATSLdgcLJzAywEKq+EC11uY6ZRVB77rJFDBmvLi4xbWhdfoHQrYKOyFslYZ1AgNDiY+EJDjS/NAzfyKDaTr5fu4nUmJ3+EI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784131443; c=relaxed/simple;
	bh=7xIKAPBO0hE4TrhO7scACFhg5G4DNprf7yvFjWX2sQg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b5CwMuSJpYfsWgkECPRRe/FAlsyquWmKI3WBjuVdZfhPGS92VMFLUzhhnpA6GK3I5MYwCJKvQdHLbmYjv0vEcngeG09xE/M6U89fSDQu6QQ/t5MyV/AAquseNk3egDYi9DiBvvirX8IGL0tLP1ZhoOT5zIlsiy2Cc6OGeCPf4FA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dRSwUtYW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dRSwUtYW; arc=fail smtp.client-ip=40.107.159.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dRSwUtYW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dRSwUtYW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GhCCr12FuB8DQ6dXzFwAvdzp5/s/Kck/hzjT+7B6ZEPrRpkMuAFt4l2uQS4QBKJu6zbUaKGbT+Ob/dAJugC1OCGFcikpHmhh3ZU4N0FF510+W/FlDC0a4YDL3AMIaST0Ju7lcDHnUziESQstQK/JpEPLfYwwovHGqIvpXAt0gEgN8xCTMrd7D61cto1hFT/wjD0loKaHM5oC3bqAvUYK2bzHIpTVRYV5t4DruM0WJ+T3wTNYGqowx3jgVg/jQYYS4MIDZi7Al+YMnmUlrbokZvMzojlQMBH3qwmZTRgfL+NPRy2l2giTDnQ6XBMkUyqdkZTtCcNKFnvD1vYF9SxGUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xIKAPBO0hE4TrhO7scACFhg5G4DNprf7yvFjWX2sQg=;
 b=uTP7SQMykPMHZOxUpctPzU4nDhc5grerHzns0DBCtZ63zGRz8E7e3wMZ2AdF2seErKmNM2stUbkn25pK/ln6SiIgko+5JeUDmk8lmtr+K+fWSPSul4Drf7OiaRymIyHxBB3TA0X09yZF8VPqpNf50dhhACVBybCqGRENofrbgRys39/XEh2rl9VMeZhDkjHsjwyQROBqApRmWcsTzoBwZJM/7omSRruMdSI1NVEvdWkzeDf/sTW2kEX/BJH+4EIJTg62VnjEsESYcqGpQ0tTuoMAvXNM4W9GO+HwhMq/TttazKbvvh28x6tLku0iobc6l9zVJgHRPXvd4cnrXFol4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xIKAPBO0hE4TrhO7scACFhg5G4DNprf7yvFjWX2sQg=;
 b=dRSwUtYWjxG61+zv6otXOW2TEbulGfoRL1wpOfyeq+4ZJcfGBU/t/d7LupHm/7aIa/ZAL1HCpyPNYO3WjlBBUTeSxnpxrppodmdF5JJyEnQJl9c1BVe6cBnTwF8vadJRb8M8J0Jn0mQy8YmYO2SivCFm+4t14lNpzO+sPW+CoCk=
Received: from AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::38)
 by PA4PR08MB6096.eurprd08.prod.outlook.com (2603:10a6:102:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 16:03:55 +0000
Received: from AM3PEPF00009BA2.eurprd04.prod.outlook.com
 (2603:10a6:20b:150:cafe::36) by AM0PR10CA0058.outlook.office365.com
 (2603:10a6:20b:150::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.11 via Frontend Transport; Wed,
 15 Jul 2026 16:03:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA2.mail.protection.outlook.com (10.167.16.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:03:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFPLmVeL6aUrrQ0AAA887QAaz5rr1n+l5Y4b0y4k98rUPDQBRBhxQXEmx0pbx8hwBHGlYAZV+NAy3jE8no8J9PVCt6JxmhWbaQ1b4k3WnTNGbzkF5DQBnUUTQ9C0vLSwI+Y9G+zTmNuElaCXkr4RB1sVjE4WKf0hum/ZN2p0VLUAyKXS9m1MIpdJeSZd530jL1yn7SKeDSRMrD1jDpufAAeJOthx7peEDD/ntAm4vIB5wWdmKGE1Rwcwbgsky3WMvHEvCqlgLnGmXWyrdgMGzLfV81mrt0yQvXtWQqtrT92C16t3iPscfbGT+1NrokUzJtRr/K1vZsnmK7qCu+lRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xIKAPBO0hE4TrhO7scACFhg5G4DNprf7yvFjWX2sQg=;
 b=OBjv/3u3/Bhb2tzoH4UCcXQ7nRkZzIqEwtpNwYEKAIRvTwyXkFh5ZU23YPLVkre68BbqGCrDUcCbDgBUD8DlGT4i6xUh1hhFgh+AnvM+CV+RtV5NKWXfGo+O6BPpB4c5Wy9F3ltmU96RBzlx4QCxxT7PuuO71xwkIPNRIiWeWnswzfshznbGrEWUp1mZn0EzypcWJ3ETHpHHo8O+wcgkuXB37t9K+tH59W0KahsRdAZdEkZ7AG7Q9HOD1wYJc4bVhzXj8QCNu8sW6i4gguaN5nmaAz2C5NrWlZSLxzAz9t19RktwJsfGP/S861FGq+cj+3UI0VZvZwLAFeLQ2n/b+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xIKAPBO0hE4TrhO7scACFhg5G4DNprf7yvFjWX2sQg=;
 b=dRSwUtYWjxG61+zv6otXOW2TEbulGfoRL1wpOfyeq+4ZJcfGBU/t/d7LupHm/7aIa/ZAL1HCpyPNYO3WjlBBUTeSxnpxrppodmdF5JJyEnQJl9c1BVe6cBnTwF8vadJRb8M8J0Jn0mQy8YmYO2SivCFm+4t14lNpzO+sPW+CoCk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by MRWPR08MB11808.eurprd08.prod.outlook.com (2603:10a6:501:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 16:02:50 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:02:50 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 27/40] KVM: arm64: gic-v5: Track SPI state for
 in-flight SPIs
Thread-Topic: [PATCH v3 27/40] KVM: arm64: gic-v5: Track SPI state for
 in-flight SPIs
Thread-Index: AQHdCwWZkCP3nWVP5EqWIWg3Go4KY7Zb/6wAgBLRDIA=
Date: Wed, 15 Jul 2026 16:02:50 +0000
Message-ID: <a5e1eddc23deb8185ef16466c385e10df669648f.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-28-sascha.bischoff@arm.com>
	 <20260703164156.A794C1F000E9@smtp.kernel.org>
In-Reply-To: <20260703164156.A794C1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|MRWPR08MB11808:EE_|AM3PEPF00009BA2:EE_|PA4PR08MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc64e5d-3dda-45fe-9ceb-08dee28aabcc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 MwU88xG9FnKrJR4hUmCpXxE6S8haOitGn4xdc7aFFOko1nTYWm6GnmhyDLZpg5GrFDGCWs+SfyNzLBSl7sk0hbZdFnZVk7zO1yBxyVhnpxU12m69UL3w/ncUTz/rIlLC4rRabaMtpW2bN4FIKjRYqttNQv0uE/TByc4pkd61CkWdrdijXuTfGOKzTeDJnGSApv9TBUXssPWybM2OEyQi1a459E9xVLGddtY5hKhbqHXUtwXVEhxnxEGAiZLm7YGg3Br9qjoAooskL9oBzVhq3QUGhgQgqWCKK8diViTtLsi08Cg2zFjD6QIBgfbtFKjqE3Aa14o8wKhqb0roOgV5FU2YVV6MG/riu4mVLCOoDTtrE4JbeWKeoWevs6tOwI2lLcgDClCK+DMicVObvtlSX3jD2n8RJKZw+1ZDIP8F7scjvun4C9+V5IROvIuISnJlnK4zLW7s9TJ1jTJpA1Mu/XlN6bmbX4USxCkOPaXtG3uFq1QYBpawTedkR/z3SWXzSdAqGw+soUOZBIaPG8cK0I28BrB/aw+69mp8PDIFtUBFJF8MK00WNxoYqhuK94SISmWGgoNNEYc4LI7vVFCnboj6KTjtfZ4FVy5Ge1m5+0eWWIIpSf4Woo+K56J0n+auAZNSZg20PHf/W4DRldURX55Sf8oofAdcUrIYA5a2assTgWwYHBQC5JGGEAuAPpC7WI3Sfh2eJ9IbdE4wHxZCjXhN483JsOj9mHxSoywoefE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E3E7076B126E94BA0988418D34C6D8A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 q7J6UDEyWlnvWXsdiymvaYAC531dMZju+QbhiXRkdwDJT7hEhYSb5DXgt1PuZkRxI76yLHJamPCj23iaSp57VenBIVOs9wxeGUobAq1dTqKSsmnjD/BJcbWwk8rhjT/rP03+N+CFTyzQzLBkxKYv2HBxAmgiuGk0l45HVvAwmtUDIWi/zCzZqyoxsmAM2/hOGBLNyvxIy9h0/wB2VccO76a6xWQ2X0q0QI4lmLIZOwSV+H3TRhS2BvU66cM5Y1WzR9tpT0KbNSGYxz3Zr7D1EB+8IU/KXHcz6KektKmlPaYtKm855FHMHt7C7UMHG3GpN+c2Ue7Ayr86LDrVejQxZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11808
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b66b086e-430b-4bc3-2cca-08dee28a8555
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|1800799024|36860700016|23010399003|82310400026|11063799006|4143699003|6133799003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cTbTNta9oiTqvQKKU26ZDM749POhhLedMWFzsfb+LXQMGp8YLPLgbHcIObfpLl5LFotVLXCY+jfZaS91wR/vIErEaNOXfZpO16s2LYKqQhYNmKZ0U1oQFDQUNL2/yZ47H59jvRnrr6X5x/2APIL5D3G7LmP50CQjHCwasqhqVVd0vA0+WUs320mYOh71Gc6s4NW0FXsmN2ru/eAhNz4Cwy3kIU3UuiFyErkrrHl+Dnr5v9v8LOAvhA/ZlrVu2PJyNx45c+5aw9Qvv1O9+S9HfZNTSgZQXfBD/mSq+iyPsi6Ip2ya/257dhG592AQteMwTA24KzjVnMi4d15Kw0aoRJHjNQd2U7uevaG0NRrH/Z/ovhOwLsX+rPWt5xpyXN9TbneqRKLgj+BjhyOoWncbPAy29hpxiIDhN8I/hfijjKCTcg55XCdfY0UezrzcAsMNzq4zaro4HSUM5B/2//8JKWkPqwmKKnh4gXTXPjOWxupHd5/6KiklToW8L3u/q+tYdD2A/DnvFAqPmRgRn4tcKwlgoxgGKBFK10UxfiWUZUWU17awI7amJYuFd1ggXUf7kgAs9dThQfF9/WkUqGaL2wGD44iaawNWoRzgmGk0FN9yHBlUruKC1XLqdherWc7H+uzquMPL/FaO/YkIOW2Cp5hnIYhQTHXfl9qV5dTX/4+VV+PHfExXok6Ew6s9tMJgIZLeU0gUrFpZIMRJucthjA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(1800799024)(36860700016)(23010399003)(82310400026)(11063799006)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V5LGSIvkYODuck51l1W3leli3LUx6km/lztnr3MtOjP20bBNzQs5WW+gn5gbEmnHreONJEU7c/Fp04/XBW0rqRFVnMBAjCKdgx0XiuiBk2m6DNR8ZLTNShk12IelhZJ4YrkW9mz3vm29JI9WFIOi9CX/I0tjjkamghlxH6S1Ah3wMRWS+ybGohz2q+2rYaTQNuLPxMyDqJWvasmONq5IV/YxHpYvLT0U50lVmY9coM+iV6freHXnRKnYHyA0XGI0XlQzfZhLS7p5Z9h+JmXilKFugCQod43X4N9zvwh71c59bECiCtuqd6rjBIFT6o/E/l18zZqcofgM1fMj+Neo6zxByYKnRij2USAYojiVDVR+X/xLqGw7RJkJ7cHI7N33dPyIijOyHERpwvmIpI5SPcZ+oTx/SMKVRTnm4OXDmYtajzAzxpaXdA0ZtQ1+WJod
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:03:54.7886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc64e5d-3dda-45fe-9ceb-08dee28aabcc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6096

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjQxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTyhOXjIpIGxpc3QgaXRlcmF0aW9uIGFuZCBoeXBlcmNhbGxzIHVuZGVyIGEgZ2xvYmFsIGxv
Y2sNCj4gY2F1c2VzIHNldmVyZSBsb2NrIGNvbnRlbnRpb24uDQo+IC0gW0hpZ2hdIExldmVsLXRy
aWdnZXJlZCBTUElzIHdpbGwgcGVybWFuZW50bHkgZGVhZGxvY2sgYmVjYXVzZSB0aGUNCj4gYWNr
IG5vdGlmaWVyIGlzIGdhdGVkIGJlaGluZCBgIWlycV9pc19wZW5kaW5nKGlycSlgLg0KPiAtIFtI
aWdoXSBVbmNvbmRpdGlvbmFsIGFjcXVpc2l0aW9uIG9mIHRoZSBnbG9iYWwNCj4gYHZnaWNfdjVf
c3BpX2FwX2xpc3RfbG9ja2AgaW4gdGhlIHZDUFUgZmFzdC1wYXRoIGNyZWF0ZXMgc2V2ZXJlIGxv
Y2sNCj4gY29udGVudGlvbi4NCj4gLS0NCj4gDQo+IGNvbW1pdCAyOGEyYzRhODk0ZGYyNDZjOTIy
ZDdmMTVhODBhMGVjMjQxMTFiMjcxDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEu
QmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTogVHJhY2sgU1BJIHN0
YXRlIGZvciBpbi1mbGlnaHQgU1BJcw0KPiANCj4gVGhpcyBjb21taXQgYWRkcyB0cmFja2luZyBm
b3IgR0lDdjUgU1BJIHN0YXRlIHRvIHRyaWdnZXIgZGVhY3RpdmF0aW9uDQo+IG5vdGlmaWVycyB3
aGVuIFNQSXMgYXJlIGNvbnN1bWVkIGJ5IHRoZSBndWVzdC4gSXQgc3luY2hyb25pemVzIGd1ZXN0
DQo+IFBQSSBhbmQgU1BJIHN0YXRlcyBiYWNrIHRvIEtWTSdzIHNoYWRvdyBzdGF0ZSBkdXJpbmcg
dkNQVSBleGl0cy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IGZm
YjA1MDBhNGM5YTcuLjIwYWU3ZGFmNGM0NTEgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiBAQCAtMTA1Niw2ICsxMDU2LDYzIEBAIHZvaWQgdmdp
Y192NV9mbHVzaF9wcGlfc3RhdGUoc3RydWN0IGt2bV92Y3B1DQo+ID4gKnZjcHUpDQo+ID4gK3Zv
aWQgdmdpY192NV9mb2xkX2lycV9zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gK3sN
Cj4gPiArCXN0cnVjdCB2Z2ljX2Rpc3QgKnZnaWNfZGlzdCA9ICZ2Y3B1LT5rdm0tPmFyY2gudmdp
YzsNCj4gPiArCXN0cnVjdCB2Z2ljX2lycSAqaXJxOw0KPiA+ICsNCj4gPiArCS8qIFN5bmMgYmFj
ayB0aGUgZ3Vlc3QgUFBJIHN0YXRlIHRvIHRoZSBLVk0gc2hhZG93IHN0YXRlDQo+ID4gKi8NCj4g
PiArCXZnaWNfdjVfZm9sZF9wcGlfc3RhdGUodmNwdSk7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiAr
CSAqIEZvciBTUElzLCB3aGljaCBhcmUgb24gdGhlIGdsb2JhbCBBUCBsaXN0LCB3ZQ0KPiA+IHN5
bmNocm9uaXNlIHRoZWlyIHN0YXRlDQo+ID4gKwkgKiB3aXRoIHRoZSBoYXJkd2FyZSBzdGF0ZS4g
SWYgdGhleSBoYXZlIGJlZW4gZGVhY3RpdmF0ZWQsDQo+ID4gaW1tZWRpYXRlbHkNCj4gPiArCSAq
IHBvcCB0aGVtIG9mZiB0aGUgbGlzdC4gVGhlIG5vdGlmaWVyIGlzIGNhbGxlZCB3aXRob3V0DQo+
ID4gdGhlIFNQSSBBUCBsaXN0DQo+ID4gKwkgKiBsb2NrIGhlbGQgdG8gYXZvaWQgZGVhZGxvY2tz
Lg0KPiA+ICsJICovDQo+ID4gK3JldHJ5Og0KPiA+ICsJcmF3X3NwaW5fbG9jaygmdmdpY19kaXN0
LT52Z2ljX3Y1X3NwaV9hcF9saXN0X2xvY2spOw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBU
aGUgY29tbWl0IG1lc3NhZ2Ugc3RhdGVzICJXaGVuIG5vIFNQSXMgYXJlIGluIGZsaWdodCwgbm8g
U1BJIHN0YXRlDQo+IGlzDQo+IHF1ZXJpZWQiLCBidXQgZG9lcyB0aGlzIGNvZGUgdW5jb25kaXRp
b25hbGx5IGFjcXVpcmUgdGhlIGdsb2JhbA0KPiB2Z2ljX3Y1X3NwaV9hcF9saXN0X2xvY2sgb24g
ZXZlcnkgdkNQVSBleGl0IGV2ZW4gaWYgdGhlIGxpc3QgaXMNCj4gZW1wdHk/DQo+IA0KPiBDb3Vs
ZCB0aGlzIGludHJvZHVjZSBjYWNoZWxpbmUgYm91bmNpbmcgYW5kIGdsb2JhbCBsb2NrIGNvbnRl
bnRpb24NCj4gYWNyb3NzIGFsbCB2Q1BVcyBkdXJpbmcgbm9ybWFsIFZNIG9wZXJhdGlvbj8NCg0K
QWdyZWVkIHRoYXQgdGhpcyBpcyBub24taWRlYWwuIExvbmcgdGVybSwgaXQgbGlrZWx5IG1ha2Vz
IHNlbnNlIHRvIHVzZQ0KbGlzdF9lbXB0eV9jYXJlZnVsKCkgb3Igc2ltaWxhciBoZXJlIHRvIGF2
b2lkIHRha2luZyB0aGUgbG9jayB1bmxlc3Mgd2UNCnJlYWxseSBuZWVkIHRvLg0KDQo+IA0KPiA+
ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShpcnEsICZ2Z2ljX2Rpc3QtDQo+ID4gPnZnaWNfdjVfc3Bp
X2FwX2xpc3RfaGVhZCwgYXBfbGlzdCkgew0KPiA+ICsJCWJvb2wgcGVuZGluZzsNCj4gPiArCQl1
MzIgaW50aWQ7DQo+ID4gKwkJdTY0IGljc3I7DQo+ID4gKw0KPiA+ICsJCXJhd19zcGluX2xvY2so
JmlycS0+aXJxX2xvY2spOw0KPiA+ICsNCj4gPiArCQlpY3NyID0ga3ZtX2NhbGxfaHlwX3JldChf
X3ZnaWNfdjVfdmRyY2ZnLCBpcnEtDQo+ID4gPmludGlkKTsNCj4gPiArDQo+ID4gKwkJaXJxLT5h
Y3RpdmUgPSAhIUZJRUxEX0dFVChJQ0NfSUNTUl9FTDFfQWN0aXZlLA0KPiA+IGljc3IpOw0KPiA+
ICsJCXBlbmRpbmcgPSAhIUZJRUxEX0dFVChJQ0NfSUNTUl9FTDFfUGVuZGluZywgaWNzcik7DQo+
ID4gKw0KPiA+ICsJCWlmIChpcnEtPmNvbmZpZyA9PSBWR0lDX0NPTkZJR19FREdFKQ0KPiA+ICsJ
CQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBwZW5kaW5nOw0KPiA+ICsNCj4gPiArCQlpZiAoaXJxLT5j
b25maWcgPT0gVkdJQ19DT05GSUdfTEVWRUwgJiYgIShwZW5kaW5nDQo+ID4gfHwgaXJxLT5hY3Rp
dmUpKQ0KPiA+ICsJCQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBmYWxzZTsNCj4gPiArDQo+ID4gKwkJ
LyogRGVhY3RpdmF0ZWQ/ICovDQo+ID4gKwkJaWYgKCFpcnEtPmFjdGl2ZSAmJiAhcGVuZGluZyAm
Jg0KPiA+ICFpcnFfaXNfcGVuZGluZyhpcnEpKSB7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+
IFdpbGwgdGhpcyBjb25kaXRpb24gcGVybWFuZW50bHkgYmxvY2sgbGV2ZWwtdHJpZ2dlcmVkIFNQ
SXMgZnJvbQ0KPiBmaXJpbmcgdGhlDQo+IGFjayBub3RpZmllcj8NCj4gDQo+IEZvciBhIGxldmVs
LXRyaWdnZXJlZCBpcnFmZCwgaXJxX2lzX3BlbmRpbmcoaXJxKSBjaGVja3MgaXJxLQ0KPiA+bGlu
ZV9sZXZlbCwNCj4gd2hpY2ggc3RheXMgaGlnaCB1bnRpbCB0aGUgcmVzYW1wbGVyIHJ1bnMuIElm
IGt2bV9ub3RpZnlfYWNrZWRfaXJxKCkNCj4gaXMNCj4gZ2F0ZWQgYnkgdGhpcyBjaGVjaywgdGhl
IHJlc2FtcGxlciB3aWxsIG5ldmVyIHJ1biB0byBjbGVhciB0aGUNCj4gc29mdHdhcmUNCj4gbGlu
ZSBsZXZlbCwgbG9ja2luZyB1cCB0aGUgaW50ZXJydXB0IGFmdGVyIGl0cyBmaXJzdCBpbmplY3Rp
b24uDQoNCkkgYWdyZWUgdGhhdCB0aGlzIGlzIGFuIGlzc3VlLiBUaGUgYmVzdCBhcHByb2FjaCBm
b3IgdGhlIHRpbWUgYmVpbmcgaXMNCnRvIGRyb3AgdGhlIHVzZXJzcGFjZSBub3RpZmljYXRpb24g
c3VwcG9ydCBmb3IgR0lDdjUuIFRoaXMgcmVxdWlyZXMNCnNvbWUgcmV0aGlua2luZyB0byBtYWtl
IHN1cmUgdGhhdCBpdCB3aWxsIHdvcmsgaW4gdGhlIGludGVuZGVkIHdheS4NCg0KRldJVywgR0lD
djUgaGFzIHR3byBtYWluIGRpZmZlcmVuY2VzIGluIHRoaXMgYXJlYSBjb21wYXJlZCB0byBHSUN2
MzogDQoNCkdJQ3Y1IGJ5IGRlc2lnbiBoYXMgbm8gbWFpbnRlbmFuY2UgaW50ZXJydXB0LCB3aGlj
aCBtZWFucyB0aGF0IHdlIGNhbid0DQpyZXF1ZXN0IG9uZSBmb3IgdGhlIGd1ZXN0IGRlYWN0aXZh
dGlvbiBvZiB0aGUgaW50ZXJydXB0IChhcyB3ZSBjb3VsZA0KcHJldmlvdXNseSB2aWEgdGhlIEVP
SSBiaXQgaW4gdGhlIExSKSwgYW5kIGhlbmNlIHdlIG5lZWQgdG8gZmluZCBzb21lDQpvdGhlciB3
YXkgb2YgdHJhY2tpbmcgdGhlIGd1ZXN0J3MgZGVhY3RpdmF0aW9uIG9mIExldmVsIFNQSXMuDQoN
ClNlY29uZGx5LCBMZXZlbCBpbnRlcnJ1cHRzIHdpdGggR0lDdjUgZ28gdGhyb3VnaCB0aGUgbGlm
ZWN5Y2xlIHRoYXQNCnlvdSd2ZSBtZW50aW9uZWQgYWJvdmUgLSB0aGUgcGVuZGluZyBzdGF0ZSBp
cyBhbHdheXMgZHJpdmVuIGJ5IHRoZQ0KaW5jb21pbmcgc2lnbmFsLCBhbmQgaGVuY2UgaXMgbm90
IGNvbnN1bWVkIGFzIHBhcnQgb2YgdGhlIG5vcm1hbA0KQWNrbm93bGVkZ2UtRGVhY3RpdmF0ZSBp
bnRlcnJ1cHQgbGlmZWN5Y2xlLg0KDQo+IA0KPiA+ICsJCQkvKiBVc2UgcmF3IFNQSSBpbmRleCB3
aXRob3V0IHR5cGUgZm9yIHRoZQ0KPiA+IEdTSSAqLw0KPiA+ICsJCQlpbnRpZCA9IEZJRUxEX0dF
VChHSUNWNV9IV0lSUV9JRCwgaXJxLQ0KPiA+ID5pbnRpZCk7DQo+ID4gKw0KPiA+ICsJCQkvKiBB
bmQgd2UncmUgZG9uZSB3aXRoIHRoaXMgU1BJICovDQo+ID4gKwkJCWxpc3RfZGVsKCZpcnEtPmFw
X2xpc3QpOw0KPiA+ICsJCQlpcnEtPnZjcHUgPSBOVUxMOw0KPiA+ICsNCj4gPiArCQkJcmF3X3Nw
aW5fdW5sb2NrKCZpcnEtPmlycV9sb2NrKTsNCj4gPiArCQkJcmF3X3NwaW5fdW5sb2NrKCZ2Z2lj
X2Rpc3QtDQo+ID4gPnZnaWNfdjVfc3BpX2FwX2xpc3RfbG9jayk7DQo+ID4gKw0KPiA+ICsJCQlr
dm1fbm90aWZ5X2Fja2VkX2lycSh2Y3B1LT5rdm0sIDAsIGludGlkKTsNCj4gPiArCQkJdmdpY19w
dXRfaXJxKHZjcHUtPmt2bSwgaXJxKTsNCj4gPiArDQo+ID4gKwkJCWdvdG8gcmV0cnk7DQo+IA0K
PiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBnb3RvIHJldHJ5IHJlc3VsdCBpbiBhbiBP
KE5eMikgbG9vcD8NCj4gDQo+IFdoZW5ldmVyIGFuIFNQSSBpcyBkZWxldGVkLCB0aGUgbG9vcCBy
ZXN0YXJ0cyBmcm9tIHRoZSBoZWFkIG9mDQo+IHZnaWNfdjVfc3BpX2FwX2xpc3RfaGVhZC4gVGhp
cyBmb3JjZXMgdGhlIGNvZGUgdG8gcmUtZXZhbHVhdGUgYWxsDQo+IHByZXZpb3VzbHkgdmlzaXRl
ZCBTUElzIHVzaW5nIHRoZSBfX3ZnaWNfdjVfdmRyY2ZnIGh5cGVyY2FsbA0KPiB3aGlsZSBob2xk
aW5nIHRoZSBnbG9iYWwgbGlzdCBsb2NrLCB3aGljaCBtaWdodCBoZWF2aWx5IHBlbmFsaXplIA0K
PiBwZXJmb3JtYW5jZSB3aGVuIG11bHRpcGxlIFNQSXMgZGVhY3RpdmF0ZSBzaW11bHRhbmVvdXNs
eS4NCg0KQWdyZWVkLiBUaGUgYmV0dGVyIHdheSB0byB3cml0ZSB0aGlzIGlzIGJ5IHRyYWNraW5n
IHRoZSBwb3NpdGlvbiBvZiB0aGUNCmxhc3QgaW50ZXJydXB0IHByb2Nlc3NlZCBhbmQgcmVzdW1p
bmcgZnJvbSB0aGF0IHBvaW50IGluIHRoZSBsaXN0IGluDQp0aGUgbGlzdCBvbiByZXRyeS4NCg0K
QXMgSSdtIGRyb3BwaW5nIHRoaXMgc3VwcG9ydCBmb3IgdGhlIHRpbWUgYmVpbmcsIHRoaXMgaXNu
J3QgcmVsZXZhbnQNCmFueW1vcmUuIEhvd2V2ZXIsIGlmIGFuZCB3aGVuIGl0IGNvbWVzIGJhY2sg
aW4gdGhlIGZ1dHVyZSBJJ2xsIGJlYXINCnRoaXMgZmVlZGJhY2sgaW4gbWluZC4NCg0KPiANCj4g
PiArCQl9DQo+ID4gKw0KPiA+ICsJCXJhd19zcGluX3VubG9jaygmaXJxLT5pcnFfbG9jayk7DQo+
ID4gKwl9DQo+ID4gKwlyYXdfc3Bpbl91bmxvY2soJnZnaWNfZGlzdC0+dmdpY192NV9zcGlfYXBf
bGlzdF9sb2NrKTsNCj4gPiArfQ0KPiA+ICsNCj4gDQoNClRoYW5rcywNClNhc2NoYQ0KDQo=
