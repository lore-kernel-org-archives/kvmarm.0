Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013066.outbound.protection.outlook.com [40.107.159.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C0D3812DB
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890594; cv=fail; b=UW1RIPTYllxVh6q8LMceTwPSzhTV2iG+2GzQ3f30sb6MVYeAa5HdrRLqzPAbAoZGri/LEF54xsXrvPUGPNae/+Kp+VjEL3s1Bi4oHv2CF2WV/865tf7R1QLd+clXlo2aZvYJLQW+1cNQvNusxSe4QzH8LXf4tmDb8DmiCHXzWvM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890594; c=relaxed/simple;
	bh=CwtvFvHenGyDhAiFcd5OUl91r2KfZUZ5Z75C3ST70Lc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W8wU2Bh6inesCLg7VexP0DeIH6UrrEcDQvsek84ogGs1I2iUqvQbrlS9ZnplCQJcUzoP0iJ0i77I5U65PREv3Ncgx54NpFqKu4lzkaYQHOhBjpPppqorssjqg1tSqt8d4RjB2a+0x6Waaanifh49m5NK0uDf9+ehliC12R0WiFk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RyyAmXRB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RyyAmXRB; arc=fail smtp.client-ip=40.107.159.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RyyAmXRB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RyyAmXRB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jAHqkTp3iZXYSSFlKZKNSjmkXDmdL+MZtD370jX2cFeFhjAXicogXMWIrYJO48v+UVjyLAhPOwut62kqW5NJr5oo5FBzeHYjnu0KlsxQYP9Xg8YiXomEhphxFIxuZ0Q1cPh/5q0M4lxuZY/5kiTGeBFTmPaFRMUlykwX2BA+nJOYjOlCRGfI220VQBWlpsFSkDb/9A12vCM7Xl0MC6DI5lLp3bsSb+gQBXLIAJ8bGl54FVd/0igIZ0d+kIDe1YSUzvTlNWubQdq3XMTxlo5DliVdP5/r0GbNa7T2niCosKLpKuZOJupGQAl7Ne7tgAJGTe2+CfA7xPyGP4AOWSPziA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5I+OLmdSy2UzkGQoOjF75s4yPZHXAoHaLq1NMdq3TMQ=;
 b=RAY96nCldXHY7pwec1KneVzNlHFoQW8MtZCwi+NbF82FqCGTY19YZQEyy3bFfD1ev/fCygMNpVbhyA10u0sPuEp9hPeZC9GuQc8uHwy3eUkKuejDpwxtZxIeS7ptbwunnHapUr9AiMFRbzPBjIHkrSCh6X75/6Vi3E7k997RPL1d+K01tKwxvv4tdQ48iIMRnJ5WVmTJ/+BVBYB2XkzqPrWPxhTarLO684mnCCpMIjqKuWoSN18hdzFCiDBxWKainsg6zjolve5gS0QIBc/4BEtwJibSYcWubcB4MRj27MDxRz4MEzEMKnHaAdgZTeCFlj63bYD5ltuu1ml/g575RA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5I+OLmdSy2UzkGQoOjF75s4yPZHXAoHaLq1NMdq3TMQ=;
 b=RyyAmXRBIaHHKXzRIQ8cCGFoYaUed6iAW37zCCFdbNrIpVGZUNi6+K7eXzeh0alSvCjIUA/wr8zDlkO+8js+R8yQxwwN3Y9YyCyuyWH7OpttnJ8gu5kVYkjUhmGXDYOirStWq8lqyCL1IWW3nrLxC4Eow/KICW8yFVR6XJX7320=
Received: from AS9PR05CA0166.eurprd05.prod.outlook.com (2603:10a6:20b:496::12)
 by PR3PR08MB5820.eurprd08.prod.outlook.com (2603:10a6:102:90::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:56:25 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:20b:496:cafe::4d) by AS9PR05CA0166.outlook.office365.com
 (2603:10a6:20b:496::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:56:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:56:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4mF6jGeSYoPuLHtMLrTGr/ULGUp2+AOOq2vAooiUqTc7IssJwJwcNYjp8ZZdZ1Lgn5f6SunwLYY42Ac0aU2HzgL9qIsKIzhPycpwxDCb4TRnzm8i1Sg9GhiO9kIrkDwG0EKLOdtQ2mTUeh2CEIt1EwRm1Nyw4IwwHutIzw6R9iFDyDoQabc58dbX4BYZGzD2j+BgrtLkLB95clBZS9VwtdcnqXF1vgayfBOLMwYWWFXffa1a6Cy9kLpmh664aiF5ks/CKjxO9NYgEiAejauGUr5q7DLfFSmm2mXv/Qm27XLT/VjqaNJgW9uvq2DzAUOItL/LxoeuI2XMuEG16Ex8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5I+OLmdSy2UzkGQoOjF75s4yPZHXAoHaLq1NMdq3TMQ=;
 b=O97jrp0Q83Mrmvn7/uDIhq8rVe2kptv7ysb1RcdKKLC0yfMfUV1GWFyg7BZx3YbQbfIFcACxQsTMPf/eauJKEUlN14UFnx2zeF9w8L6khsHeEvtTZMQ7RCREHnP5usoEeq1YWtyJbUyTwFHTgjIjqsQHyXbyNmArCi3gDwbNphVQCJjZ2Q4mXUZVFSu0MD7+N99RLLvmaFZDttAav6E6OCpYhSSAmCE0HyBTSEk3IXVxsB1y3UdZDJsrRS/3ET8UXlz4d+eF6Dd2wJhJHc6air3X5s9Dmr0Hsobwc00S5JHOm9XXaXl5atje13bLvMrWoOUvt4fcNHBU66Tz7lzJFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5I+OLmdSy2UzkGQoOjF75s4yPZHXAoHaLq1NMdq3TMQ=;
 b=RyyAmXRBIaHHKXzRIQ8cCGFoYaUed6iAW37zCCFdbNrIpVGZUNi6+K7eXzeh0alSvCjIUA/wr8zDlkO+8js+R8yQxwwN3Y9YyCyuyWH7OpttnJ8gu5kVYkjUhmGXDYOirStWq8lqyCL1IWW3nrLxC4Eow/KICW8yFVR6XJX7320=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:22 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:55:22 +0000
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
Subject: [PATCH v4 27/48] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v4 27/48] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHdG1rs0y3of9Fi70CyN1OpnUvr6Q==
Date: Fri, 24 Jul 2026 10:55:21 +0000
Message-ID: <20260724104819.1296803-28-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AMS1EPF00000047:EE_|PR3PR08MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 303aa20c-52b8-404c-1b1c-08dee9723475
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 +YBHMT0xyBUnF36wILdT5ux0uVbi/sNGckEBmWZWf1sY6xrxPSC93xCAoYH0c0vsGEvJ6H1VRPNGMZOS7lW4EleVfjmr10oZZBP9tmgl5fz7OQzc059kHpTpg0xxFNEKPO28W7XJZ21x7OYz9MMgixnxN5P7Urmt3l6o76GamFojKpYW63/tn5L2RdfBrj/sRvt/cpWBahtM+FjLU5S5nKCc0Az4tUcqoL6jjDuD3Sbh6A//YQFf10xt5h45Xf/czKTEWGhy/wV3y3eMF9eYe1CnVSa795hfiUXZ6lBPfqJsJwOODmqZeqbv/iqQjTDAlDZ0LlzDZkbNu8kK7w9bIezFVzqyXnQzTyiqTg4uzag4ye7qvW4xXmvrsxPuRjtgNzOIQFyRu4PltwifdQUU2OfdlLrd1FNOX8rYiWq1mNwWPXe9AGosN3VqgsApl5Jz4lq3/bYtQqX9MV5ox4dHoeCp8lk+QWQewnaPy7tU2zHDTXLZCz8xdtLFmVr3Ynvi/BTOHVNqQI2c0CkBxy8CYXjBSDPfpsm6ZoTfZKOMr+b/e6ublhILCxqPn+HTU0aKzp8nKWt7/mTZRtULGMVAfEaDBX1DdAW4Blundqz1JL+GR3tB3SANteQiBpQ8UrItlQ3LRYZKIARbHsYjkaD70f+aPR4vgHaKM1TA98dT5LQL4sqTO/kIxqnB4u06cpCYFT+tvfF7UMSwEzcMinfMARgJZqXOpJbDDZGW0/tW90k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TH1ATsVayyJyHUgPKEl48scuigBlut2GW7gr6C7efU5Mb37CDu6/mImwJOKU6rTR2HCOwFLB7+AEHOYKu/7LDvPtjW+ZNNkymJusuHjDBNwv9nuPANNtidJ+3Bmex1rk67HzB5BCCWgS6g2j4diM1YNhnG3221OnJBeomiiYnneDR3EVwC49InUxYDZQEqVamlGp479gJrGAvacdr4H2YQUsgfkcXKXUyrsrDbMj1dkCvg125QErxNTgnLYeAq5crgCtF1oHzfWGNWLD3gvF0KqOnSgpahwj17e+dAAEUog08s9oMvHn0GHPDbwWKFbbX5wkZK0DQa7g+dHkpW+v/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e4bffca4-81a6-487f-363c-08dee9720ef1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|82310400026|36860700016|23010399003|1800799024|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	gPfbAhf0GVDMgUCfcQejUm0j84Y6356yz6H7dmw8L9SSnmUpKdTGMAyPxpYL9VV2N1QdnqT1slNbRobm/NuM59pzmuKupsUMHkLWi8+2lPe4AdteQ/TkXF9ls495d9qr5s878okjk9wXuVrSKa6vqzl0dcGEr71YIfBvc7bx5DWRwDM9EujURICGGx2fJ2mj619TVNVhytVrONvruW/mnVUVqE2T9XCCGWqAddxBwwQzYeZUSoimtyXdiqVH7VVROmd052l4aL5i+8AFmCK5hiNDQ4fe1Qo+sNe3VFor0CxtjDImHHctdgEXvm7PeacWeGtzQ6N3UYi8uqJjfck4zb99EihmoMxPvp2kDqaMBaYP8aRVrxwS8E5cxFFS0I/u7IjXk6QmFyEH4ASL3+ba9THfJqfU5OEZn6eJc7Oi7ZeqGy+X2cpXHBT50iWmaRRQ+R+BgiwJvJLJKRcYzjqVwRLb+svaIeSAWcSnegLP3AjzOO7iy080sK2JPZbR5YLaF6yF/9PNKPrOIJQ1zslFUHf7n0vVT3EjSRrjCpILpmclhikiZ9wQ8EveadjH0bkHl6NqU8BKhYaFit8LyIhj4qifGxkzs5BjHrRXWdOw9Nt28UoZdXa0WEZmygpIC808aqyNPPEuNA6HqdZGuuTpemD1/F/DCPL9A98HYezwBwIWYZniDU3cV0ev+tYROTYFLObbmL7/Y26QzGaSh/juUw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(82310400026)(36860700016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ij/aOynQbXjcoDgK7Y9nk8vqlcpU8X9DOQp8bgXHGjMwFEC3bPVC3tk8yv7Gc12A35E0hRlvvLEALqSJx8MY7EQr+HBpgJ9j4kxxbH0R1OG+KVdqMJCcw0JbvADMMRK7KoUMWKUWMo9yp7XgLvhzcT65/1cT9R3Ij8sdao+kmUgtTqaZB1PHiOJI3iUv9wdXpThltoCxlspndUKbPUdMqE5pXJLSk9UvyWzs5s4S9ndO9AGuwDBn4HsuTrKi31XUth0fpnlAUgFJpjpMMKtyypdtGjny+Yt/8ta7s1vUjcRkK6L9YGqYAfGyQMHAbdeaqk6E1ii3cB4ObmjDc6I+bqvzuLexkIWbs9rM4BiIAd9lxpA65XNI8MmmAxwoSC7tXkC6kU15dsMpBcG3zVeIBsGwUid6M7vRXpDPC82opvNB7ooFk1ENgeDgD7R4cTAL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:56:24.7863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 303aa20c-52b8-404c-1b1c-08dee9723475
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5820

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting SPIs to the core VGIC code and
GICv5 code. First of all, allow GICv5 SPIs to be looked up by ID via
vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used for GICv5 SPI injection. The set_pending_state()
irq_op is used to inject the SPI's pending state into the guest. The
queue_irq_unlock() irq_op releases the IRQ lock without queueing the SPI
on a per-vCPU AP list, as GICv5 does not track in-flight SPI state in
KVM. Tracking the affinity and lifecycle of individual SPIs in software
would negate much of the benefit of their lifecycle being hardware
managed.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 41 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 28 +++++++++++++++------
 arch/arm64/kvm/vgic/vgic.h        |  2 ++
 4 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index da8914dd682fc..7a068e7db250e 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -671,6 +671,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 7957b9da95e7c..04392b686c2e2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1064,6 +1064,47 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					 struct vgic_irq *irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	lockdep_assert_held(&irq->irq_lock);
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	return true;
+}
+
+static const struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 69e0965846aaf..a27895295ecbb 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,19 +86,31 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
+	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
=20
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
-	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRI=
VATE_IRQS);
-		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	if (__irq_is_spi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid =3D vgic_v5_get_hwirq_id(intid);
+
+			if (intid >=3D kvm->arch.vgic.nr_spis)
+				return NULL;
+
+			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+			return &kvm->arch.vgic.spis[intid];
+		default: {
+			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+			if (intid < max_intid) {
+				intid =3D array_index_nospec(intid, max_intid);
+				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+			}
+		}}
 	}
=20
 	/* LPIs */
-	if (irq_is_lpi(kvm, intid))
+	if (__irq_is_lpi(type, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 282278e4a6c19..107737c77e4d5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
