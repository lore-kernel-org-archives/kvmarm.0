Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011058.outbound.protection.outlook.com [52.101.70.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C656340DA1
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761745045; cv=fail; b=kjyjlZtriO2CBjnXmlg1B/XqrHOxXyL36EziJD5AYQ7+aa+z0/uxt+yOVgRyPt8S5RP5qgDvacci/ymVHavk/3fbckXo+eit/U5KK44790IDyTusGY3lBRCldYVxo6OEWN5ZJDLEJ/ZNX2nPRNTACXk/7VqrQ2IGLUzLtftVo0U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761745045; c=relaxed/simple;
	bh=jSAUOKWr8YyzBuS4AgdDhIDDh/njPmGwXtBYbZ9Mr7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RCTD7D8tC6IlyWjqPCW5zSmT51eLeq1IWyBZ5PidsxUEUACPs0xPM9RCa0NTzm/UcS3MbA9Sz7VXeneR+RXGUjQMHI6XPuKBs/DWjQWS2o20VzKm8WxGAiKOvMPrM0Xwuum/a5QEBgNq9EWiDXL9e9rT4sIJC5l1Dfi93+Y8sWo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MaOK98iS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MaOK98iS; arc=fail smtp.client-ip=52.101.70.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MaOK98iS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MaOK98iS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NQIVHLH9oAkreBkK/3g58OqQt2QwkbjTrwGO5H9ZZSUgvob4qXdmFHYEJ5PmIexlDSoT59k72KS/ij6JImXas7TCELMee1/KwQmyN9KIPS7wyz7fu9XF7+e7PeBT5MG6SHIi960QXt24rY+bR/H2U/pbEjfzIP8c85TEacfuMepoISuVP2XFHB06DZJofmOWTSCWFveywftOLU3ecUzD7cHo3kmw/gTBbCNQHHodF/g6zMr+ZzErwZMt27rhtEd+Crwgs9Z1+7ueacNiKrf8nYL4bjh7DQmsmnoSLJuUtJvV8pPWTHJUJmGaCeVotc6f2M0JnwnVJndYEW9W/ER+bw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wz8XoRGqMzDQAF6kkq/VK0XuhqI9KEoCp/wMUiIIRNU=;
 b=sXw+fVrTs+9tmJVGzNwJDvfu7X5Gwl2nho1mztdVyve1B2Nc9Qp5V8I8oo2B9QrXeMbJE+pq1OVaDoImGkjH7l6VyHjV4h+THnigQeCHzewviDMlVSHayN8BX5ntTrOheM1HpwY7RVUw3gDkg7tCUfxfg+aFMlIJEfsdtv9wIfFT1YmSLEhAu7TH7YetxqBPOv5Y3fOkHj1xwexdgUQE6Mb/Pqr2x5/D4chwm/1EjZMJsNKFmszxx2XcKZ073wFNemPbNtnerT3LmCnZ13vZSQR8HHMzhe/YtHUN6dDvqPoykqyYCAn+/KRsdLCjiAzI2fwOf1v7eCEMIo4A/Bqyag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wz8XoRGqMzDQAF6kkq/VK0XuhqI9KEoCp/wMUiIIRNU=;
 b=MaOK98iS9ytGKvYCY8AH/6XWe4zXOiWXRxRDo3kPL/iHB1guv1baQbDyy7nza2c49E5meRq3Rp/XJUegBq7+Zdd+IXW66m7rhQoFnY0Fz3SpayQzrHmZ7SLKhUNLIcBvdNoEbsCpLA69+YLDWjlOOH2kbGJyN+a3kpXW/upRcw8=
Received: from AM9P193CA0014.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::19)
 by AS8PR08MB6023.eurprd08.prod.outlook.com (2603:10a6:20b:291::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 29 Oct
 2025 13:37:19 +0000
Received: from AM3PEPF0000A78D.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::a7) by AM9P193CA0014.outlook.office365.com
 (2603:10a6:20b:21e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Wed,
 29 Oct 2025 13:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78D.mail.protection.outlook.com (10.167.16.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Wed, 29 Oct 2025 13:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k42Eq35yDk173gnnXdAUHaH2HBdl27uJkuEcKJHwFpxMYdh4AEeAkiUhlpsZRVgz84IfX56Xo5nO7Wb/ONK3UUqpf3Or1mHvl151wyap/J8gsSC2L2tL/VS3ESJTVkHXHKNsB0Bg/xvW/ZAdYFWRoCnd3upvK/zutKLsNbcBYXhqU2d5T0iXM9Mx6OgOkDXu6JuthA+VsUPWmjedm1eqTCTftkf/UI35qSH4jbWICFdRjbrHZd/tRqK14cj6K4F1kFShM489v09NvVt1lD1YShjYrhJRZMUB0SwXmUAoGDViKpvYeH+3u7Fy/0WF1/EbtdhhYMZHshF6IBykCfsrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wz8XoRGqMzDQAF6kkq/VK0XuhqI9KEoCp/wMUiIIRNU=;
 b=bWTfIoCn0+p9Ze/on+Bju89II42JOpZIix1NhI9lftHuN7DWuJ2skuJ4qib9UcgeB0TddnUhMbmkCOspFEaUl0kTIo+j+UniLg19qOtc/1vvbPkqXJ8hT4Q38pt9yt5xbvwepv3hrgXsGIaRwzOmBAc8LWfH1B2IV6cQv1RQpdRbSkobDbbYKmXl5R5haZn4BUG4AoaIWGXENfHbHr8isvrl/zj2NFdJowoz3JoWe7zgZI5Fo4li3ZHjcMTNCKUwas784yBbhRK9scBC5jgH1rxZzqsTHj/gj4fJzKC6WK+uOfgv7U+1E6lzJe6JArhoJAVYnwdC9TYt78tHwnDJcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wz8XoRGqMzDQAF6kkq/VK0XuhqI9KEoCp/wMUiIIRNU=;
 b=MaOK98iS9ytGKvYCY8AH/6XWe4zXOiWXRxRDo3kPL/iHB1guv1baQbDyy7nza2c49E5meRq3Rp/XJUegBq7+Zdd+IXW66m7rhQoFnY0Fz3SpayQzrHmZ7SLKhUNLIcBvdNoEbsCpLA69+YLDWjlOOH2kbGJyN+a3kpXW/upRcw8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAWPR08MB9543.eurprd08.prod.outlook.com
 (2603:10a6:102:2f1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 13:36:42 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 13:36:41 +0000
Date: Wed, 29 Oct 2025 13:36:38 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
Message-ID: <aQIYZoP5iKcwtXwW@e129823.arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-3-yeoreum.yun@arm.com>
 <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
 <aQEwVe8+okm/Nmso@e129823.arm.com>
 <61e923d6-388b-4cc6-8c26-5581a1e1cc10@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e923d6-388b-4cc6-8c26-5581a1e1cc10@arm.com>
X-ClientProxiedBy: LO4P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAWPR08MB9543:EE_|AM3PEPF0000A78D:EE_|AS8PR08MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: abfa8850-0edd-4c9f-ee25-08de16f0470b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?WjFcDOoxq2PeVeIkcYzY7PbNeg0lVaM4NQk7bdgF5CX4mj94zm10Q0QRq5He?=
 =?us-ascii?Q?kB9t+8U82qnsOxHADXQJHTTIK1Ox2Var9sFGpIGFK8XL3EC/D28hGzbRZ1sP?=
 =?us-ascii?Q?Af40gle1uwwBxAat45d2fYMAnD7wfA18IvPWiEYVsDfQHL0Kc5Lu17hTHBGF?=
 =?us-ascii?Q?0sxe+yvYEulc4LnMTqUN6aah+51/BLIP0vF/vcWgRp2a+wKA/EepTU81f6CL?=
 =?us-ascii?Q?VdooxsIMRvGUPu01eptodL6Qf8QK/GhhJuYVzX2xIwrcnUwHhB8MyEh3gmKG?=
 =?us-ascii?Q?9UTmbj+tWSEYxnYEpVY3uKFG4e/GJRyBMWeU4d5R2D+yNX0tjLsnkrX9weLq?=
 =?us-ascii?Q?qCxRcMmbTYesKnOf5mY0XDA4N4f/uKLPYmgYSbd9mO1DQWHakOcsr+W9xPXA?=
 =?us-ascii?Q?tw5871X/D/pJi5nkleICyjcv0RPOucfvhLfriy9mvZkMtIOOW4brW87lSb3Q?=
 =?us-ascii?Q?z1+92uMu2LMVswnpqI8XKDkCYugo+BWTJrgCg2n75ywnyoa+G9r9vB4i2YH3?=
 =?us-ascii?Q?wUZ6ieu8o5jwvPCVpaCxqUE2k6W/B38kRuUPrf7+bW4kzxL8rVCs6xkw7954?=
 =?us-ascii?Q?DXIDMnJ2IDzvtRfrSRpyjzKrtKsNGVu0x4++pVGuVqtGsXbQEzdq8lNB6qcP?=
 =?us-ascii?Q?9w0jxBRo7XhwgOKAPtcphr6vQBqufdriDDwNUJ5tTTOg6mysE79FB/JvNUQz?=
 =?us-ascii?Q?lbTZVIz4inPy0iyYfT8FyrP/+6MPcu91nohKMPjt9ynHgld2nFDCNXzNjBkQ?=
 =?us-ascii?Q?7Y4vdc59uM1laREdeZS8tVq3xq0LqiCaaozUXWkSwHtNCCbsZgrFW9BJogI6?=
 =?us-ascii?Q?Q1IWxsHlLNUlD6EAgfHQzy89bT9K/kCKENhntbml0bsyA8aS/av7UA8Kw6HR?=
 =?us-ascii?Q?3YWtwzPrL4VuzWGPAgpBpzGjpcstG9fDJIYBcwzDPoMppWESvZ8kBhmlFPWV?=
 =?us-ascii?Q?xoxp7LtcGQAvysxheqv4b8kzsRdtreZzfoBQ1JaQIESEaePYJWBtJcJcNqPA?=
 =?us-ascii?Q?Kwxb/IficScW++ygZT0H7shDC7O5Vot9X5y9LExhduCO1zQvfwtsoAxEL0RZ?=
 =?us-ascii?Q?0H/Xt+gs7sY/UjP2K7nD3V40YnYfR9VrmgES6g3HivZ+V7rJFgrXb/fc+Ji6?=
 =?us-ascii?Q?dgvlh+ZgMkmh4m4Qr5fAScDkSlr0J0kqlyxn1sdbjn0Yq+zAHeKR7NSBom3b?=
 =?us-ascii?Q?W8XuTtZX8JVG1jyyMfPNPt0VgIdspQPkdQgImXdv6bZpPNbsVCo0rV63HcCn?=
 =?us-ascii?Q?HZHblQiq+gtCUMzOb8I/HnO5fRyBKmnxwa/wCSVcAb3IkvW7KsrZbRAj+J4k?=
 =?us-ascii?Q?iua94E+qE0kCFUF3DJV6rJKUjEg8vd7Oi0SyY30luBm7bWfm1XCw4S0kx+Ku?=
 =?us-ascii?Q?K3IKoWLL+3Xr3jpgbSim8QpanEHVwsLNeChe07zeeeOYCB5mBDZx9GB93//u?=
 =?us-ascii?Q?pmXSqOLT0N2dbZfus/skq+AaR6xmHN9V?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9543
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4055c64d-a616-4a4f-c4d5-08de16f0318f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|35042699022|376014|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D+1+pzC9pAyy0Bu9siLjkFwgpFODF0ZLdGUFgmlKpxE2fIALh91q6e1nhuhE?=
 =?us-ascii?Q?BFDbMs0oZkIeJsqeyBWO1GEzrlDaFu9sv608J6puNaCupqnhMaPzYQk2UagE?=
 =?us-ascii?Q?/9F5AbOJlF3Y+i77xe0zrwqhhpmpmdzpiwGVYEgZuv4g4QXLmF7jBB/Lj2du?=
 =?us-ascii?Q?cidWgj5gZcE21Iq7duSYZPs4XJ9q3d/jEaMIt3yQP+5Q6ZP9W64ZriyDGOJ5?=
 =?us-ascii?Q?vhHDU4L5ar9TYmFgffwqcsuzj31Ax9UwBOet5v2yVv9TSyPByRhz1EO+x9+7?=
 =?us-ascii?Q?hz6WnVYtFuF914Qm8MDQukrC7pc4GGk73eyjJNchRXTQaqzMs9Sxzn+Be6uF?=
 =?us-ascii?Q?Wa6wO0Nk77gjWGaUclC8vVLLpFoFWnF/dXc0e1XPBNEok4Rl0lXJNS1OELW2?=
 =?us-ascii?Q?BPFsf+/AukD27AInqlkBj9vqaG4irsYS0bA1y0lUfCFy6BV+j/ZcnNnicJm5?=
 =?us-ascii?Q?KqJ6isJeGNIYkDORZUmsmU79PYeKtrnoLbOO54yWOu6yeBr0E5JZkjFGBtYz?=
 =?us-ascii?Q?gYum0irL5Y4i77hCiLYdsgUVGkHc58ALVhPLwIdHrroXNbAk/5I2WxHFzNsj?=
 =?us-ascii?Q?ad1fBz4UIs6uTciat2nPoXEumo7UPahUmHgLy72wSbKlnH85l8PZ3lwSPoqv?=
 =?us-ascii?Q?/lNHBMFrEyZdDMxa7w5kvgJnNhRNC29ACjuGF5rt2y830d2LZWVou+HxOUbs?=
 =?us-ascii?Q?+JeH0qxOukrXY7nIPd/7bEg1HitvZp3cYx1YO0BPEENJQzFzaHo6EOKjwOFS?=
 =?us-ascii?Q?9RgnuYAeSL4KUhS0xIZH84rxYjLR3Wq7Y9fTuAO2tOT8d/YoNr06YpPuH6lO?=
 =?us-ascii?Q?EtgFKlhE+1JNicAFHFDsxbjpuYUo8Qk8jMIxoDYKlwry0qtGHv676rgtornA?=
 =?us-ascii?Q?0BVLiubvwoXl9D5JS2Wgrak8gVv6uh3KYm1W9u69qCsOlT4iLDeKfre0A14s?=
 =?us-ascii?Q?DLk7+wbZhlNVLQ1wVzlZlv1QxmRyBf+vkc2pgdZAWQxlhj6OqxddNiPdOuZv?=
 =?us-ascii?Q?2H6/YuAT1dDrkGajqiw1VFAgGO0EFGKnOJ6sdzWDlpmjKIxNe6FPLD6IC3Nv?=
 =?us-ascii?Q?//y5VjxlucEVll7ghif7iH4SOvMzv1uhDDgXFpcL8knHlHg1enQ9DCCK12Iy?=
 =?us-ascii?Q?DK9wJs6ZR1DwsJCTGWDodT8cEcAxcNdoxMMsVODBdcDAzKSFclFmcTZSPGk/?=
 =?us-ascii?Q?0PQn8SmARs8jzkqxsy2bJhmt7a/Qg6wDhcP95ydhJZT9Gz0qb44WdU+x1m6h?=
 =?us-ascii?Q?B2WfAWMPzD/ArN5nwzDv47aza2iwhHC5IradYC4TZHww3XfdJRe4hc/KzO9q?=
 =?us-ascii?Q?lLbBBgaQ0q4bMOP4jKgCeddRMmnALNfLlAEtP17tlU5GauZzY9Qp0PGitVzq?=
 =?us-ascii?Q?B3mIQ0qdY5WWjGKJpbdBskzHuKyCOVFL/t58HjNh92bMXlUi5XAykIISQ9Np?=
 =?us-ascii?Q?MWQlznc9B0Gncga6wWO81o6Mm9d74/vdqVpZjkQ11FOpXpB42FDCxa+7cva7?=
 =?us-ascii?Q?f9OiidZVPAL2LCe2Y4Wd0TN5JL6mUw0MNCnKjh8wcC+J1HRDomUliGBRCMkd?=
 =?us-ascii?Q?oadeynfEEM4G4BdVXaE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(35042699022)(376014)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 13:37:17.2180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abfa8850-0edd-4c9f-ee25-08de16f0470b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6023

Hi Ben,

>
> On 10/28/25 21:06, Yeoreum Yun wrote:
> > Hi Ben,
> >
> >>> To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
> >>> support the FF-A v1.2's optinal calls by querying whether
> >>> SPMC supports those.
> >>>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>>  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
> >>>  1 file changed, 18 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> >>> index 0ae87ff61758..9ded1c6369b9 100644
> >>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> >>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> >>> @@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> >>>  		ffa_to_smccc_res(res, ret);
> >>>  }
> >>>
> >>> +static bool ffa_1_2_optional_calls_supported(u64 func_id)
> >>> +{
> >>> +	struct arm_smccc_1_2_regs res;
> >>> +
> >>> +	if (!smp_load_acquire(&has_version_negotiated) ||
> >>> +		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
> >>> +		return false;
> >>> +
> >>> +	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
> >>> +		.a0 = FFA_FEATURES,
> >>> +		.a1 = func_id,
> >>> +	}, &res);
> >>> +
> >>> +	return res.a0 == FFA_SUCCESS;
> >>> +}
> >>> +
> >>>  /*
> >>>   * Is a given FFA function supported, either by forwarding on directly
> >>>   * or by handling at EL2?
> >>> @@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
> >>>  	case FFA_NOTIFICATION_SET:
> >>>  	case FFA_NOTIFICATION_GET:
> >>>  	case FFA_NOTIFICATION_INFO_GET:
> >>> +		return false;
> >>>  	/* Optional interfaces added in FF-A 1.2 */
> >>>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> >>>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> >>>  	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
> >>
> >> Looking at table 13.54 in the FF-A 1.2 spec FFA_CONSOLE_LOG is only supported in secure FF-A
> >> instances and not from the normal world.
> >
> > Thanks. in that case, we can return false for FFA_CONSOLE_LOG
> > unconditionally.
> >
> >>
> >>>  	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> >>> -		return false;
> >>> +		return ffa_1_2_optional_calls_supported(func_id);
> >>>  	}
> >>
> >> I don't think that an smc call here is the right thing to do. This changes this from a light
> >> weight deny list to an extra smc call for each ffa_msg_send_direct_req2 from the driver.
> >>
> >> Instead, I would expect this patch just to remove FFA_MSG_SEND_DIRECT_REQ2 from the deny list
> >> and rely on the TPM driver to use FFA_FEATURES to check whether it's supported.
> >>
> >> So, just this change:
> >>
> >> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
> >>         case FFA_NOTIFICATION_GET:
> >>         case FFA_NOTIFICATION_INFO_GET:
> >>         /* Optional interfaces added in FF-A 1.2 */
> >> -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
> >>         case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
> >>         case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
> >>         case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
> >>
> >> Am I missing something?
> >
> > Nope. I think you don't think you miss anything and
> > I also think about it.
> >
> > But, I'm not sure about "support" means in the pkvm about FF-A.
> > Anyway unless the SPMC doesn't support the specific FF-A ABI,
> > I don't know that's meaningful to return "TRUE" in here.
> > IOW, suppose pkvm returns supports of  FFA_MSG_SEND_DIRECT_REQ2
> > but user receive when it calls FFA_MSG_SEND_DIRECT_REQ2 with NOT SUPPORTED.
>
> As I understand it, the ffa_call_supported() is used in two places:
> 1. To return NOT SUPPORTED to an FFA_FEATURE call for ffa calls that are
> on the deny list.
> 2. To block ffa calls if they are on the deny list.
>
> For both your patch and just removing FFA_MSG_SEND_DIRECT_REQ2 from the
> denylist I think the behaviour is the same.
>
> If FFA_MSG_SEND_DIRECT_REQ2 is not supported at the spmc then:
> a) an FFA_FEATURE call will return not supported
> b) an FFA_MSG_SEND_DIRECT_REQ2 will return not supported
>

Right! I've missed the FFA_FEATURE handles via default_host_smc_handler().
As you said, it just a deny list.

Thanks. I'll change it.


--
Sincerely,
Yeoreum Yun
