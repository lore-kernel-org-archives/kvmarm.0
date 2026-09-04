Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010011.outbound.protection.outlook.com [52.101.84.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357C1395ADD;
	Fri,  4 Sep 2026 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511942; cv=fail; b=pcB/fYBMeCdLLth7Wk5i/PwKmpeOCXKTzC4nMuriT6Vd3JZjguy79N/wz4Mog3mJaqThuH/epTivHz+xTWs+z42ue0KV6fGH3gxgmFj6iXvwSA0HOsobrt61h9GWGcz2VOh4WX82nH33wb9kLibeaLGUQGE29s6gHnWyhHWWoas=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511942; c=relaxed/simple;
	bh=k69Gb0Yz4HaWmGIi7LPcF8FPJp95a/tHe/j1kE7mSC0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SflXQU519MjLIPI38zb0wxRV7eGNPUxpr9yN5fL6Dd951J9MvHK3xrZr/fb5OTNpYnBeowD8NT0pgZ8mcMV1fASNhn7OwfG/3JKDNbYYAYRr52R8GJs/9nCPMnwmVVlrUC4SO38+aYp08LcbCPrd1e0CIWkNSXr31FI6L00uzLc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oqhYSFoP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oqhYSFoP; arc=fail smtp.client-ip=52.101.84.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oqhYSFoP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oqhYSFoP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HAVP9FxkeCo6ax2whBZf4JO8QtFsw9lc/19zKGrTZTdme0/W92bhOaa2tTMNNzv/RdxJLJLPuIigz6vn32LF7Pv0tkU/15Z28uB6eC7qTjzjPVY+HACb0g+HbFORNpTht+6tKG0J4+O5Wxk6YkrpInec2D4RmiJWhPXnwa5QcQvPlVam4oEJsts+G/uHTDqY0CeUbCKyhuAfwiPHskFTfYHVp4ukCZx97BT+hYV9mSsCol7kzjUYfFS8cvuGXnnULJ97cwSkfJ/ETHXaXQ9CHrheRVG6V6doHbRphZsnKxGJi2YVcJ0DypcCc9A+h7cygjW3sJ+yAeKGCLQEk4w1vw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k69Gb0Yz4HaWmGIi7LPcF8FPJp95a/tHe/j1kE7mSC0=;
 b=b2bov8AP+YxSVNMNnwmLqmiC4a3Ndq5+q6dGHW7g8APJcurPYxuWx3sXKRn3LhBTCGruM3h+etoZ+3BEmnuS5EixH7oXdwxtjSZUCexA6KBvq7QLGeFB45+P8K96F2r/9411e7k8vT2UvtVoDy5F/RBeT9B3D+Z94AFVUWIebJuF/MskOxFlNF9TFX9IHLXRTLPdiAaiT3HbF0q4EeMPzdsxPpiD/+ugZfEd2X2IjSS5uxOPJ8oMMJ64rYyqhRDD8GMwFcxwH1aJPcxzeTZd6zuJU9yH22NVtibmHDEzB3nmuu8zaVWe5QruQqb+znGHY8G5XypjK4rBEk3ZPn6RSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k69Gb0Yz4HaWmGIi7LPcF8FPJp95a/tHe/j1kE7mSC0=;
 b=oqhYSFoP6cT7AqifpkC+RDsSBZxp84vKsQd2V7De9UmRd+HQh0GTyI6JPgmYDa8X1JAK98l1t+p5iv8OtbcsuWS/7lmrJnfb87TQ5c7c+4jvtY4wGmXgYfawIom5SqGqyFiH3C4UGHqNEsihdZwiB9WfSwj1HegLqh//y5ZTM8E=
Received: from AS9P251CA0011.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:50f::13)
 by AS8PR08MB8567.eurprd08.prod.outlook.com (2603:10a6:20b:566::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:52:14 +0000
Received: from AM2PEPF00070CF6.eurprd02.prod.outlook.com
 (2603:10a6:20b:50f:cafe::9a) by AS9P251CA0011.outlook.office365.com
 (2603:10a6:20b:50f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 08:52:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF00070CF6.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:52:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApPfQ0NQD+yqNxVDH5uLBfsvfyTnj8UdU5VJFkE6ji9LPASkGEx/1oOfF6+mVV8abIVyj/7WKcjN7+DLEI9FsAehhKvhubRUjpKaIJPXI5tMqW5/6P27K7UYhWVIb3ugm+SdsGlFfvulnJqH5vtIe27IiHOUpuB/NOq9WwevsljPsIna1+HcB8eawym0xmTlKqZwltGzBcLRvKTVJR/WSRlaFlCLpvNX9xf48eGqU5eRWtl+GDZWceqUJeMx+U7lWTnbPOATcuRf6HI0jr7ZcKIbUl8bcWWIhNO7qJ2WEM+LFJqlA20u9lkrOnsp0bLq8TF2kmXBpE4LcO6xn+DdUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k69Gb0Yz4HaWmGIi7LPcF8FPJp95a/tHe/j1kE7mSC0=;
 b=OS7zYUFNpmLEdBmkJ2X+Xga687tLjXGwq1ySAkWIGC2F56M1PezFrPhOhCOiZOQZtYaYL3SHIHQMPZ3iOSjxnTZrpkf1kA7L0/cBL3E40ruxzgBNcPl0HxwW6F1+s1NYcoMrqCm+yATU02soMFBdhw98oexYBE2Xdthw8BaznMRNOkzYqb0MI+CnXszC7XJBorm4WylW67Zkhm/FELQNCFdu2QP/nB8zvNSmSunGj4YZyrSDC56DbZwY4WstEiKUJVXfSXlZ0McS9DnDQ2IVKa2I0FpY3sFqEF79+VYi8yyOMVUL4U9fVNN5Ss7bJCTAEP3wwLd8LVTyZ/x7QmiL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k69Gb0Yz4HaWmGIi7LPcF8FPJp95a/tHe/j1kE7mSC0=;
 b=oqhYSFoP6cT7AqifpkC+RDsSBZxp84vKsQd2V7De9UmRd+HQh0GTyI6JPgmYDa8X1JAK98l1t+p5iv8OtbcsuWS/7lmrJnfb87TQ5c7c+4jvtY4wGmXgYfawIom5SqGqyFiH3C4UGHqNEsihdZwiB9WfSwj1HegLqh//y5ZTM8E=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DB4PR08MB8101.eurprd08.prod.outlook.com (2603:10a6:10:387::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 08:51:41 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:51:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHdJl8kNHJ4D0scJkuPPMPROE2EmbaSqyCAgCudVIA=
Date: Fri, 4 Sep 2026 08:51:40 +0000
Message-ID: <081314fd0c4ed7a5968969c8e275f971db7c0479.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-22-sascha.bischoff@arm.com>
	 <20260807144924.42A8B1F00A3D@smtp.kernel.org>
In-Reply-To: <20260807144924.42A8B1F00A3D@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DB4PR08MB8101:EE_|AM2PEPF00070CF6:EE_|AS8PR08MB8567:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e0b514-980d-4114-6b62-08df0a61d0bc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|38070700021|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 XBWdHs8NaCBiqqnkri6m5udr34jT3TYPmR4uL41jIY3UrMm+oyFEd94KsQnzUCbaB9vwar7mDzHgKCj1eKKexP8oAB6uASLuDgBt6Wnr3UmruGCeFJYZDWXNROiU3Tbx307Qi6BheaOxzDfiM/+vGV5EqvAdiaVsLRTpMi9McslXvKQxtQJJXAbNQngI/QnHmsMpvPlS8Rr36yiG15mebBv/JgNAOHNdivGCv0DYh6hCnJgfk6gx3rwvIGO87hDAdyn1dUVz1B7TmfFFvGIvamnVqGjBZr/8wLJYBm9ibnzy+9Zslq0DYVSfVhWpCFS4IyvEmX/rKhitdFWBVoaeocQ9L+Zsm+Nf8/qvgs1l8EKE5KbTnZq32IgovXMFGainhqe2IZ2E2kD0Oqtnjx0ZF++HG716tN9R8T+ZczVnnT/UbFdLhX+5MwZrhOwM0QtRBy2bOLEm3PtnBlrYwEIBcSvMZqMVFgZ59iD4yJ25mxz2SQQJ5WGVzmYLjcy7SxHU8v3aOBQyJa0i3iGgfPfQCqDPIr1S38ZHMYlOhOr/BqXrzCBOXT1lBP9yuiwy3/NMQyoq5dw0UfxmKghmJwMP+FS2EJMXmML+sIZ8w9c6lz/ALl5JREf48G/KZ84cFiurEFFJ6yItHQWE2LjcZM/aXbkNR7sCt2ixYP2tf0XxqdyiF1WkEfAOdLavV+NoUboQ7EV8kjfbSLQl/BotDqdKPrQ/K7TQJcqcJAGPhUZwrkY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(38070700021)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B050095B360544CB21BF21CBCF4C6DC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 06gaKU+hmUPe30l/XAGJDpXUw/jZ4Vt2QDJP2ieNTtQu1jnSghDLb8XKlGhLHUkoLWztrt3jnNOm58fDchSek40pPetd29hkOykXciDuVM+aEUN9GeQKDVGihCeRxv/6ShyHaxTjFjkKyYSRHrO4wQ3tNGOuKPR04vdAFtfEzBbPseJ6Ygu1hXqrAkL8IK+K/15esLiwFGVehxhR27WTk/K9d+quordMcu51YsDK4xtAsaqos1KKQJzn1RKK6KiEi2v4u7cD1nIY29JLVldvilFEM86BsCd6as7kKgvr497XWQMQb7VZ9rBvp5BxJj/0P8BVbrG9GlHuRTssMa1KbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8101
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF00070CF6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d3a2cfed-b851-4387-4a05-08df0a61bd01
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|23010399003|1800799024|35042699022|36860700016|376014|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JPswE8HV3Lg+dqJZwpU1sTjokCldoRhu0fSWvhBDrEnh7A9T06baukMOTkd2C5W7MUBcW9yd3UqGHO59jKk+ocNRMnTy8I9UIrpoBpwRIi4Lcb7+bsB3H0TifzfzdJfwXSzbqFyLIT3J3ULz8aas1zwb563gi0IcN3902pTzSRyfNKWR2+gFin9nyduwtZD/lE4vSTy8YMAlAm6GCb9kIWWsZHIbYhOcD/vnFFf01Frhh0nNoHvN023bpsUxmRKcPKKYt3sLju+jSBhCu6pYzmQYeo+Pb6PjnL63Hy8MwZdVGzD2pqSBMye6Jwb0rILRxoCgJ0tLejtYkSCk9MkbTrtCQ2+nTbgt2X4Jz8z15fVzoyqsXzOWrpRQjQQoA6oJ/PPuC4SKGHAr7XgZGAua9j4KehFqNLuizJfnEnqqaXZTrtSJjx4leFK0ZpKK9fE3y1ciSfGzn5Oz5WsO+3EedkwrcyjqCR37pOhrLEY2P+3LkhsovmabUGKR52Xjpw2DvdsfxreE/AK713bjmFTvKu6dyZppmYT8HZe0fk7nU/Rekt9spoNp8UZVhQPuUIRqVp/70G3nAgg4WsxefK3FP7r1BCbxzI9v4onhnjTftgQY8UC7Z7qBOF95t7f3lq5q04KnjU5YipJpFX5ng0w92peokheDQ/9pKvv9MpJFqEk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(23010399003)(1800799024)(35042699022)(36860700016)(376014)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tu8wKiyR5StUFHbvVlhmVdw4LmatTn7MwFJU9mJs/S+1qP5BkjDfhA6bRiZxDNxvMMnTMxXlXkEWtd8q4/PpkZWci2z9VljnZHCX189RcfR8u4ZsG5zA9oTvzfzIlXPYhDVMV9HIep/ZnArG1jIReYREBHZB1D0YRgRW89fO1A0vzmPsKvyBfpMPzOpuT09DjAPSoT4KfUzmRoo+t3erSdYpr2ckXl5M0lfQJS9X/bLAe65NrFHqt5ovrkdeHhhrS9SrUUQoiA1ydjN4Vqh5vfvCsym++DqahBbRUcOwQNdJZ58v4r7hkC6cEvCO0eSR9BE28wXExCy6ZT+xPsEYwG+zDM0ESsFEHCWg8r+SsVxjL7GILc0vb3hH1rl5tSu523AkBQTnym22NMj8RyM99X9x0R2nE4pmuyYfMIpRRFhZQyTiMDowcGRGKVQp+gVV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:52:13.8955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e0b514-980d-4114-6b62-08df0a61d0bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF00070CF6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8567

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE0OjQ5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBVbnByaXZpbGVnZWQgdXNlcnNwYWNlIGNhbiBmbG9vZCB0aGUga2VybmVsIGxvZyAoZG1l
c2cpIGJ5DQo+IHJlcGVhdGVkbHkgdHJpZ2dlcmluZyBhIGBwcl93YXJuYCBpbiBga3ZtX3ZnaWNf
djVfaXJzX2luaXQoKWAuDQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzIxXTogW1BBVENIIHY1IDIx
LzQ5XSBLVk06IGFybTY0OiBnaWMtdjU6IEluaXRpYWxpc2UgcGVyLQ0KPiBWTSBJUlMgc3RhdGUg
LS0tDQo+IGNvbW1pdCAxNDcxNTkzZWVhM2U5OGM3ZDE3NDdjZjA4OTQ0MjQ5NTVjZGRkZTQ0DQo+
IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+
IEtWTTogYXJtNjQ6IGdpYy12NTogSW5pdGlhbGlzZSBwZXItVk0gSVJTIHN0YXRlDQo+IA0KPiBB
IHZpcnR1YWwgR0lDdjUgbmVlZHMgYW4gZW11bGF0ZWQgSVJTIGluIGFkZGl0aW9uIHRvIHRoZSBo
b3N0IElSUw0KPiBzdGF0ZSB1c2VkIHRvIGJhY2sgVk1URXMsIFZQRXMsIGFuZCBJU1RzLiBUaGlz
IHBhdGNoIGFsbG9jYXRlcyB0aGUNCj4gcGVyLVZNIGVtdWxhdGVkIElSUyBzdGF0ZSB3aGVuIGNy
ZWF0aW5nIGEgdmlydHVhbCBHSUN2NSwgYW5kDQo+IGluaXRpYWxpc2VzDQo+IGl0IGZyb20gdmdp
Y192NV9pbml0KCkuIEl0IGFsc28gaGFuZGxlcyB0aGUgdGVhcmRvd24gYW5kIGNsZWFudXAgb2YN
Cj4gdGhlDQo+IElSUyBzdGF0ZSBkdXJpbmcgVkdJQyBkZXN0cnVjdGlvbi4NCj4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IDI5MzJmM2NmYmU4ZjQuLjZhN2RhYmY5MGRk
MWIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiAr
KysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiANCj4gWyAuLi4gXQ0KPiANCj4g
PiBAQCAtNzUxLDYgKzc1MiwxMSBAQCBpbnQgdmdpY192NV9pbml0KHN0cnVjdCBrdm0gKmt2bSkN
Cj4gPiDCoAkJCWdvdG8gZXJyOw0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+ICsJLyogSW5pdCBJUlMg
KGFuZCBhbGxvYyBTUEkgSVNUKSAqLw0KPiA+ICsJcmV0ID0ga3ZtX3ZnaWNfdjVfaXJzX2luaXQo
a3ZtLCBrdm0tPmFyY2gudmdpYy5ucl9zcGlzKTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0K
PiBEb2VzIHRoaXMgbmV3IGNhbGwgcGF0aCBhbGxvdyB1c2Vyc3BhY2UgdG8gZmxvb2QgdGhlIGtl
cm5lbCBsb2c/DQo+IA0KPiBXaGVuIHVzZXJzcGFjZSBpbml0aWFsaXplcyBhIEdJQ3Y1IHZpYSBp
b2N0bCwgdGhpcyBwYXRoIGNhbGxzDQo+IGt2bV92Z2ljX3Y1X2lyc19pbml0KCkuIElmIHRoZSBo
b3N0IElSUyBoYXJkd2FyZSBzdXBwb3J0cyBmZXdlciB0aGFuDQo+IDE2IElEDQo+IGJpdHMgZm9y
IElTVHMsIGt2bV92Z2ljX3Y1X2lyc19pbml0KCkgZW1pdHMgYW4gdW5jb25kaXRpb25hbCB3YXJu
aW5nOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jOmt2bV92Z2ljX3Y1
X2lyc19pbml0KCkgew0KPiDCoMKgwqAgLi4uDQo+IMKgwqDCoCBpZiAodmdpY192NV9pcnNfaXN0
X2lkX2JpdHMoJmlyc19jYXBzKSA8IDE2KQ0KPiDCoMKgwqDCoMKgwqDCoCBwcl93YXJuKCJIb3N0
IElSUyBzdXBwb3J0cyBmZXdlciB0aGFuIDE2IElEIGJpdHMgZm9yIElTVHMNCj4gKCV1KVxuIiwN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZnaWNfdjVfaXJzX2lzdF9pZF9iaXRz
KCZpcnNfY2FwcykpOw0KPiDCoMKgwqAgLi4uDQo+IH0NCj4gDQo+IFNpbmNlIGFuIHVucHJpdmls
ZWdlZCB1c2VyIGNhbiByZXBlYXRlZGx5IGNyZWF0ZSBhbmQgZGVzdHJveSBhIFZNIGluDQo+IGEg
dGlnaHQNCj4gbG9vcCwgY2FuIHRoaXMgYmUgdXNlZCB0byBzcGFtIGRtZXNnIGFuZCBkZWdyYWRl
IHN5c3RlbSBwZXJmb3JtYW5jZT8NCj4gU2hvdWxkDQo+IHRoaXMgd2FybmluZyBiZSBjb252ZXJ0
ZWQgdG8gcHJfd2Fybl9vbmNlKCkgb3IgYmUgcmF0ZS1saW1pdGVkPw0KDQpJJ3ZlIG1hZGUgaXQg
cmF0ZS1saW1pdGVkLiBJIGZlZWwgdGhhdCB1cyBtb3JlIHVzZWZ1bCB0aGFuIGENCnByX3dhcm5f
b25jZSgpLg0KDQo+IA0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIGVycjsNCj4gPiArDQo+
ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqANCj4gPiDCoGVycjoNCj4gDQpUaGFua3MsDQpTYXNjaGEN
Cg==
