Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011004.outbound.protection.outlook.com [52.101.70.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6534F378806;
	Tue,  7 Jul 2026 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783437145; cv=fail; b=TGrP3x2pjSNn3O+WXA1p1iSg0pX48NjvdMc6pghX742sIaiuI6P44Apv37vcnUK17Le7gQ4pUM8cCxfRrDJTeq72c0d6wq6ohoOWOyafVB7ISadJbIHhAZzwXt6OXcwzRDiwPCq+d3LZFNyvMMrowNKjhk3+TngoBSR0qibzzaU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783437145; c=relaxed/simple;
	bh=Ab6KVanH5rcXgD6mWSrsjV0dI+MXNnEhL+q6jCVHK+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q5ZLd6HCqVAJbw2ixjwFUA96gILAlkd49Oosza1PvbMgKOIiGtacqoj+KdUe8AkA+IyGh8r7At7ShuNkPCJUY1S1ZvhExH2RdeliJJTYT6fikUKI6K2OT+/EFRmjhqqxEau4rVYKgAHFhaeeWcqf63zpQU9yHxNCDYG+Mpyi68s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b6LW7fjZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b6LW7fjZ; arc=fail smtp.client-ip=52.101.70.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b6LW7fjZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b6LW7fjZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dWP5FtM6/Sp3zpFiaQMdckuQkYy0ocjDXD1C8D60vd1TwVGRNpzbjsvF4394/321NpkIyLCipPH5AlLFgJgCU9EGjwKhxok4r+3vO1+ZgypBdrXvX+lHTtK5WzEQvmccchne/SvItfELJmO1CHzkIIfUgGv7leHCwTidsd0uRtklIx1g5HZFe0xrKo1DO5c5HrAIUjo+dhA6J+GxsDK/OX8CK5ecCGx1CpwvBd81b0o4pQ/jjZ2uQJ+ccAhFG7StOO96UuWYDFMJfCaWWaMlcQb8seXVAbkxZmfMM179CGdTCyETheqQmwn+klFqvwXcDH/XQ4CIUnDzIWcifxGVPQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ab6KVanH5rcXgD6mWSrsjV0dI+MXNnEhL+q6jCVHK+o=;
 b=CJqgWR/FNBs2bxYBVV4AmWdI9LmGD/V6LMbvS3+gx+zoerb8Xw+PljX3NJyyPEramnw0zoen00PmYjOMck33st9NnzmMoqS9N+5nG8v4h8NQ1d44/GV7KTskJvw2xvUXcoO+qV2WFiux6dOCQFFENeb5APNILLBcGi+j2hGVW++3iSRGB/lJPGpajB5iAzu7pChlr3PZRI2rY102iP/7edzyLKr+CCD3ioLfTrvCVCRXUHxJWeKNmZnJ7RwkOErb0jIkILsH7tqf7+F3nob3SThCUtpddyEVjnzmOcJSdM1QavDpvC6aYPcwq9vx4tx2DY/ZE3iVSpdtBou2xlbVqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab6KVanH5rcXgD6mWSrsjV0dI+MXNnEhL+q6jCVHK+o=;
 b=b6LW7fjZHzp2Gkzg1K6gGkCc+JT5Lr/Q5wkKVM0gMg1W4J7/qFmjMLUDylNzfR2ZeM31FmV1K8AW+kzld5Xp0PPaczoqHWwaplFEcCHKNB9fcTeoBDjiiMCM1eD8LFJNMQzWKX4Sahxx/Mgvqj3jY2JoFS8QfbeUUwJTBAkWlgQ=
Received: from AM8P191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::8)
 by GV2PR08MB11418.eurprd08.prod.outlook.com (2603:10a6:150:2c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 15:12:17 +0000
Received: from AM3PEPF00009B9C.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::37) by AM8P191CA0003.outlook.office365.com
 (2603:10a6:20b:21a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 15:12:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9C.mail.protection.outlook.com (10.167.16.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Tue, 7 Jul 2026 15:12:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQ7bgIFCurJGRGF0siXnKQKcLDe6MLYtsEuvsCLl1mpMol0zo5/to9hffvdEkus2UKsslCOFVm9z8vMcg2dhFhlkbByTP30B/oJof5tEX2RE5B8LU8ff6p92kkDewhmeifk2JzinWlfjKzatLzybkQpargvcqiP0XMZrMTUf9g6FB6gYXOCUo3WvDXaLyrKp/5GIq98ug8XjHE3sYhTqKyGEuXyvW3pW6WACwOBCr4cC7ApimXDF9jR5zEKUx3V+SZjlbolwmSQ7Xa3pgCHjWtG+CSxpyjYu5h01cePf67En7YkgBDHnl4S0ZBEpuYxEqyy4J9CM17QzPL8k67YFLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ab6KVanH5rcXgD6mWSrsjV0dI+MXNnEhL+q6jCVHK+o=;
 b=ZqXudPkog6SEOeqtpVvQlta9aoEoCkwUamz/CA7Uhh3RFrqUZo9aeDk6vu6Xr0MfJ5dUgosbjTWdfvK+8sZwrUhFHAIzQANbR//mZIhfrpO0u/HKJ51NvzdlTKj0Wcs1qQ3wXp+D36kdNB/KhDX78w40ljnozeJriIM/MuLqstlkyBre+vxPSyH63dN98mkRFfi4VOdMZpApRev+SyGSbvRFx9xT40c5G7N0XwJtUF1tEcP6aUKwrvJ/Y1/hCPDpe/hq6Y3xGQyMOXDTsTqzhp2xaFyIVskUTwgWQCvgJK32HYU5GBfNVKajT17LYhlyk2qOmUDBRUb0Yut0kw4w3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab6KVanH5rcXgD6mWSrsjV0dI+MXNnEhL+q6jCVHK+o=;
 b=b6LW7fjZHzp2Gkzg1K6gGkCc+JT5Lr/Q5wkKVM0gMg1W4J7/qFmjMLUDylNzfR2ZeM31FmV1K8AW+kzld5Xp0PPaczoqHWwaplFEcCHKNB9fcTeoBDjiiMCM1eD8LFJNMQzWKX4Sahxx/Mgvqj3jY2JoFS8QfbeUUwJTBAkWlgQ=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 15:11:13 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 15:11:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 08/40] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v3 08/40] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdCwRASaU6TURuNUaLMrA5cbnJrLZb+y0AgAY0fAA=
Date: Tue, 7 Jul 2026 15:11:13 +0000
Message-ID: <41855ba0b2829df70e9ee36e2aff7a5108927f58.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-9-sascha.bischoff@arm.com>
	 <20260703162548.8D5AF1F000E9@smtp.kernel.org>
In-Reply-To: <20260703162548.8D5AF1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS2PR08MB9075:EE_|AM3PEPF00009B9C:EE_|GV2PR08MB11418:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c91f105-38ab-45da-3a04-08dedc3a21cc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|38070700021|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 XAdIOaV1gRkG++zi7QdPNM15nstCE2QtrpNTaDeNSbFz6yjN7++AVNcuWJXv1ent1H1xFYnLGLbp+YX76pAQFhS/tq8txAxpWZm28UGD4D71qnhlDPfGaIcXWPYow/jTBxu9Q5tdKsjBYmZx3cXEzYg3asxdfHAsP8cSwmU2lnFCQku+2CBy/VHv8Vr7hfo2UMN4nj8LpcDcQnn1zksyIZryQaLE564xPvyT0LYkidTkj/iQ8rnKeJFyaoFWRaaz1/ZHjouJOZ26vktr/LRAmgX39IZPTSdytk4CLanFNlPdZDbmmiWN8aSf+A1dB4zTAIhBCo0wUhum0cGJgl2ZRiwP6R2UXhfGk6klidbeqzJ1NAJCgGs3Ne44/UAn2L2G1r27OAwBgHc/YixkoutXoK0HCzr8BLMVgXqZ/ydQH9oJPzXsbsh4KwcAu/obpy31k2io0sKYjVyVgUr/su3AKvvrw6Yyj3tKfYYS9aphjkhI0DzP56bPn/F/iggITZm9VflAQPt518eGrJraAjRoo+bsNC6c7bQOomQCxEqgR6NsJyA+b2dzmAmrwuyg/BKFVkv4xUZeI3yN6JOrZjoGHUSXpacadd7dtVqPrpf0tQ34Fu/0y1Z+jqhfelsLCyG1OdfIJci00MQQLpyEIxDznbh17cBEbeCZS+BFOUtuKAILQLCr2AvPxuRWWelx5AEkhFs7pOzFJr8sUEPtYae9J+sXMMAlQMMWPZkv0OOAoH4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(38070700021)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B842863BE915D46AA70735EAA41A5EE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 U8ITSRQtN/7HYmscJVb7mqDpt0RGJ3YpSbNh6s05X2P+q2Y2a7py3jLCdHgIJk4aO1GY4qBJpl7jKRwYab6JX6E+JC5ueNnzsnQnjtFpzWE92H41IrbqU1xrjYLs9FlIkRemUMFf6JXtXAJ9a2FsEZIOQRQKIDQI/i/U1L4rsQ6HF1xoGwau8+hqiJctR6aUg0HEwEtpxgiEz7VX+MvHCc1EnHPbR4y1j7W97YLqqsoiUnHzDo057rt2ebNjqnNrhRgftJolhGZu+ezuEZL++cVa14sv0iTt3u7e3urjF2BrgZdlzFHQ4fIQO8Re6wID6I6sM5drMVfmXMZmspGhmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9075
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f6e32f2a-495a-4658-c8e5-08dedc39fbe4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|82310400026|1800799024|14060799003|35042699022|11063799006|56012099006|18002099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lk03e5vaqL/ux6sl3pIPjFy6O4RNel5r3L9Q0aMQW2HIsr10oTZ0rTByN8tTEL1urjEmjSgXCA8jWvqIyVB0fcv36kX70pqe6RsNwel9TGI8A/kFod0R1yDRlbS70fa41rSL5prP9+NvajGYtclDws55/7cLiR5plRT9xnf0U2QFicRcr9hAlfgp8ms0eTn79hzVCFow10J7f/DoZLzyT35WaskHWxh6mbIOphtoaZZd0N6c67f1/BTkAG+hpV4IxHeeDYKDd3bw98bwA8DYLCtaSM2Mp6TgwkWmyt3W3qTkMe3VXYUZZyp/XQa985iicPSy1KDp+fzpicjIOL+0GMecbLpO461CfC4utS7iX8HIzM/3pJNfQNWbx0i7I7Wf+3asdiDaRg3aOqne5AicG/tHWw96yNQBvchCWJcLZnIcRRRbUwZwpoA/19fnSCAVmJgeQCcqi2e6MDj+lOqr6XzuX9heOtY1wvMkZH4xER6PEJ6MwV8shjwkOSQc3k2PmZ1zbTyim+YZD8Igts8cWg39FGrvbmAfUiKcADghDgWaDW6pPprtXGhKnbznmvXYXOuTvVEb9KYELiGoqTRoPMsfiZ58fh6lLLiVUqmTgR/Lg9eszAc4Et1r+iZdzGnhb0pQccKtK09J+4V1V0usjrR1bkBnZWZLZnqDbBV7vvPKOa5JRpu9aXaQwCi2wv4n34GlE0OH3b/e9ZWRA3A0Lg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(82310400026)(1800799024)(14060799003)(35042699022)(11063799006)(56012099006)(18002099003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SIkk6lI0J/YhhqjWS6xRNKmEoryoFfy4tN7uQlVPkISQQ+3W0OmKuRvkwGwoRw8InVwXxUSMjwZ7gRJa+wwH9izRu8JKDEGDRt13FMTOzpKeewZNlcEpZFY4+NAhugnxBC1Vp48HhAQhDKTbiCN4JhmN4rl7LyqPazLDk2zI91R0YT1r5GYn4Z+6shOWn2VJvhXit71KokmtI3ZljEs+MCUVNSkKGBY3KvfBPmF7B6YYV6LA3Y6lmGY9CpkbVoX34iPNzu2HlF/gzbjcI8lHmgZCjjJrS93gkz0Sgru0Gd8r87RVSzawiEsj5kBPKpLm+r+wUU+/w8AAIJiLQGMFrLthW3hnVK/wdwuL2oLBXGpFFXuQL2yIzsZnOZ4r1baaIdHL1vafE8iYdMXJDJPYqxjt/QFSZ3hLfoWx0DHeuQi5hpILhlcoRTYWsHSC7/tw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:12:16.5499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c91f105-38ab-45da-3a04-08dedc3a21cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11418

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBNaXNzaW5nIE5VTEwgY2hlY2sgZm9yIGZ3bm9kZSBhbGxvY2F0aW9uIGFsbG93cyB1bmlu
dGVuZGVkDQo+IGZhbGxiYWNrIHRvIG5hbWVsZXNzIGRvbWFpbnMuDQo+IC0tDQo+IA0KPiBjb21t
aXQgNmEzZTFiOTBmZmMxNDIzNWQ3Yzk0ODRhYmUwMTY3YTMxMGU5ZDZjYQ0KPiBBdXRob3I6IFNh
c2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0
OiBnaWMtdjU6IEFkZCBWUEUgZG9vcmJlbGwgZG9tYWluDQo+IA0KPiBUaGlzIGNvbW1pdCBhZGRz
IHN1cHBvcnQgZm9yIGEgcGVyLVZNIFZQRSBkb29yYmVsbCBpcnEgZG9tYWluIHRvDQo+IGhhbmRs
ZQ0KPiBHSUN2NSBoYXJkd2FyZSBub3RpZmljYXRpb25zIGZvciBub24tcmVzaWRlbnQgVlBFcy4g
SXQgYWxsb2NhdGVzIGENCj4gZG9vcmJlbGwNCj4gcGVyIFZQRSB1bmRlciB0aGUgR0lDdjUgTFBJ
IGRvbWFpbiBhbmQgc3RvcmVzIHRoZSBiYXNlIGluIHRoZSBWTSdzDQo+IEdJQ3Y1DQo+IHN0YXRl
LiBUaGUgcGVyLVZQRSBkb29yYmVsbCBzdGF0ZSBpcyBhbHNvIGFkZGVkIHRvIHRoZSBDUFUgaW50
ZXJmYWNlDQo+IHN0YXRlLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5k
ZXggM2Y3YjEzMjExMDExNC4uMWJhZWM4ZTk3YWMyOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBAIC0xNTIsNiArMTUzLDEzMiBAQCBpbnQg
dmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvDQo+ID4gKmluZm8pDQo+ID4g
wqAJcmV0dXJuIDA7DQo+ID4gwqB9DQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+ICtzdGF0aWMgaW50
IHZnaWNfdjVfY3JlYXRlX3Blcl92bV9kb21haW4oc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ICt7DQo+
ID4gKwlzdHJ1Y3QgdmdpY192NV92bSAqdm0gPSAma3ZtLT5hcmNoLnZnaWMuZ2ljdjVfdm07DQo+
ID4gKwlpbnQgbnJfdmNwdXMgPSBhdG9taWNfcmVhZCgma3ZtLT5vbmxpbmVfdmNwdXMpOw0KPiA+
ICsJaW50IGlkID0gdGFza19waWRfbnIoY3VycmVudCk7DQo+ID4gKwlpbnQgcmV0LCBkYl92aXJx
ID0gMDsNCj4gPiArDQo+ID4gKwlpZiAoIWdpY3Y1X2dsb2JhbF9kYXRhLmxwaV9kb21haW4pIHsN
Cj4gPiArCQlrdm1fZXJyKCJMUEkgZG9tYWluIHVuaW5pdGlhbGl6ZWQsIGNhbid0IHNldCB1cA0K
PiA+IEtWTSBEb29yYmVsbHNcbiIpOw0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCXZtLT5md25vZGUgPSBpcnFfZG9tYWluX2FsbG9jX25hbWVkX2lkX2Z3bm9k
ZSgiR0lDdjUtdnBlLQ0KPiA+IGRiIiwgaWQpOw0KPiANCj4gW1NldmVyaXR5OiBNZWRpdW1dDQo+
IElzIGl0IHBvc3NpYmxlIGZvciBpcnFfZG9tYWluX2FsbG9jX25hbWVkX2lkX2Z3bm9kZSgpIHRv
IGZhaWwgYW5kDQo+IHJldHVybiBOVUxMDQo+IGhlcmUgdW5kZXIgbWVtb3J5IHByZXNzdXJlPw0K
DQpJdCBpcy4NCg0KPiANCj4gSWYgaXQgZG9lcywgcGFzc2luZyBhIE5VTEwgZndub2RlIGludG8g
aXJxX2RvbWFpbl9jcmVhdGVfaGllcmFyY2h5KCkNCj4gYmVsb3cNCj4gd2lsbCBjYXVzZSBpdCB0
byBzaWxlbnRseSBmYWxsIGJhY2sgdG8gYSBuYW1lbGVzcyBkb21haW4sIGRlZ3JhZGluZw0KPiB0
aGUNCj4gZGlhZ25vc3RpYyBzdGF0ZS4gU2hvdWxkIHRoZXJlIGJlIGEgY2hlY2sgaGVyZSB0byBy
ZXR1cm4gLUVOT01FTSBpZg0KPiB2bS0+Zndub2RlIGZhaWxzIHRvIGFsbG9jYXRlPw0KDQpZZXMs
IHRoYXQgc2hvdWxkIGJlIGNhdWdodC4gSSd2ZSBmaXhlZCB0aGF0IGZvciB0aGUgbmV4dCBwb3N0
aW5nIG9mDQp0aGlzIHNlcmllcy4NCg0KPiANCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogS1ZN
IHBlci1WTSBWUEUgREIgZG9tYWluOyBjaGlsZCBvZiBMUEkgZG9tYWluOyBvbmx5DQo+ID4gZXZl
ciBoYW5kbGVzDQo+ID4gKwkgKiBkb29yYmVsbHMuIFdlIGtub3cgaG93IG1hbnkgZG9vcmJlbGxz
IHdlIGhhdmUsIGFuZA0KPiA+IHRoZXJlZm9yZSB3ZQ0KPiA+ICsJICogY3JlYXRlIGEgbGluZWFy
IGRvbWFpbi4NCj4gPiArCSAqLw0KPiA+ICsJdm0tPmRvbWFpbiA9DQo+ID4gaXJxX2RvbWFpbl9j
cmVhdGVfaGllcmFyY2h5KGdpY3Y1X2dsb2JhbF9kYXRhLmxwaV9kb21haW4sDQo+ID4gKwkJCQkJ
CSAwLCBucl92Y3B1cywgdm0tDQo+ID4gPmZ3bm9kZSwNCj4gPiArCQkJCQkJDQo+ID4gJnZnaWNf
djVfaXJxX2RiX2RvbWFpbl9vcHMsIHZtKTsNCj4gDQo+IFsgLi4uIF0NCj4gDQoNClRoYW5rcywN
ClNhc2NoYQ0K
