Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011005.outbound.protection.outlook.com [40.107.130.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0B3385A1
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890271; cv=fail; b=aNPWOGGgWfKSzdONp31AyiuP9W8llWL30Zjt1my4dfynH+IljT+C/Na2txHDTYxcSAxSwoWkiHih7boVzBwjs0hQkaLRIGIi+LX0BTGWmuexTNLhM+9a1o4Biyuy7yzdb86+7CQB6Xx2NBCt7KXKur6l0wGQD+DawIcM8/KrFr4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890271; c=relaxed/simple;
	bh=e7/yiqZZwJxNWZd/ehhvAwZMkP0HeZKeVsiSjmdD0l8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vwwzqhxeoxb4Ykjsk7ckkMe6djUf+SwoA5ElYvOfaCjtImBihqPPCub/NYn++XyH7BbDhrA7DIb6MCfCwEvZIXzCOov7uRhQx8orMKyLoYRwzcwmioumLUSN0G6Cnrpr3zQ4akw8CxUXcM+bAhbLKSmuyWuIbJW2mOuVXcLrOOw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XCXoqc28; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XCXoqc28; arc=fail smtp.client-ip=40.107.130.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XCXoqc28";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XCXoqc28"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=M89y9ajq2wj6GIYpih3CxEUPPdaffu/KFQH4Up7XzRNABG9HG5zdxYyJl8bKl58kgjM23gVxgCs1MVD3QHoQZ9UsEfmSmxuNpnVjr4GwcVSUY3EnUmR9Xgp2Iv9lJXDgIEX27pu2wQZ8WbvV/GIaeFEPz0YtgATeBkzLZ0TQ++en9ySC2gH9A8aNajl9hPa2AGpjon5+9v8sPiIh0N8e3lAmySqa/dUzzuHLwUJFBystMgfr14QqISU+OUKS1xlubtfO1zjzkgwT/WpJWY07EQAPbYhilmu0toXtzIVZdRG7BbeCrn/vJAywTEtzLfaDB/Yq1b3wNhpVDjwZvvun8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=TeS5N4TrANcvDYgbx8JL19nBLpT9I820ri7L0iq9wJfSGT3axFVpXLgMd0cvMg/4yVuH6pQahgJWuU7Y9VLjPZaxbl9HjwcleGXKwp57gct0nmg5vVkk9wcM2GfJ0YRkAKJkMHWYXRIC+yfeD7AAJbZqdA+A5W+IeZxgpQn7/ovcFi8WArpMlPuVu9GMWV+pu0tZuEJdJKuGiOVMM9i8lXBA9WRZXB+Rf835TuX8VlILE3tg+dZcS3BC1wFbBeA+pLVjGfkTgqjZApox9DpI1MPVcV+sLpWKK9mEqJZUurRW7cxuZdPAxzIssugUWFVsdzBBHi3Uvl76JEy0qqFE1w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=XCXoqc28dH5tRsLgIEIkxakqU1ivRy8WT9YQ7f2h6vWOGOcf+nLT2VvBHbSiF2uqExnFGG0ZWqgPZtreYcPq41h1oPWh8FmHfSVxQTDv6JqKxKXBhsu2wLERnr6UbPqJdN6io7vtTKS33jI5Tg/0M18RnSFVgHNYLjNs2npAT10=
Received: from AS4P190CA0015.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5de::19)
 by AS8PR08MB8133.eurprd08.prod.outlook.com (2603:10a6:20b:54e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:00 +0000
Received: from AMS1EPF0000004A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5de:cafe::7c) by AS4P190CA0015.outlook.office365.com
 (2603:10a6:20b:5de::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004A.mail.protection.outlook.com (10.167.16.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMwUmZIjKH/85xtn5a+bvIKiND8a9G3MBMRNeN5MsBg1Odu4Y/rBjVibZ6wdI2BsDXDrktn8efyCckUvOSccWAlpZOQjTUbwCf96r0wR3W+YUWFe4EQ1GGnobd2Tyy++xSoVnFvZHUsJpBr14ffmoxh+cRkpdRIW0dHeghJkMrkziJFkxGWNTtaE64cnTcI+diRvuS9R1xx9VLGU3bAwgd/fzq+Ql/h2XJibzi7tAOa27ChVJiQNtQV/bH+ex+KATECg6xHd9KHnLEY09uEhUq8uzKZmp1miru+hlYuBpjyTCqEDgV+0M2qE7grg36O0rvjsT6mk4ZV37G2YtqC1fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=eEmzUGZ02VJrUlVa3AjPGunE5aDk/olqZjsvwuWt0EmhfWYcJwBwerf3+7mW57N5hOHAag/RJOP5o/asvMlIGXTrzMQ+hAOw+dbxHf77FY/ogQD6VnmqKrYk77fOjffmPhXdfFlKB8kZEIp36+4TE2CVPhWTlSzMYA1rZVYPMzM7Y7coX7IX0OSGitsRkuJz7/0oscoGvejCIprqJE8waVVvRzm+AB4jxrKdJUUSHubIgkVW5tzsX5WWdSB+XD+WkptynsMXZYQdyuAaZjjZ9gLyEXtaxnvqosM+P0yr1/AomSR+MexsAAxnQHpaUgi4k5bsYRq8isVeOxJOh9qsHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=XCXoqc28dH5tRsLgIEIkxakqU1ivRy8WT9YQ7f2h6vWOGOcf+nLT2VvBHbSiF2uqExnFGG0ZWqgPZtreYcPq41h1oPWh8FmHfSVxQTDv6JqKxKXBhsu2wLERnr6UbPqJdN6io7vtTKS33jI5Tg/0M18RnSFVgHNYLjNs2npAT10=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:57 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:49:57 +0000
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
Subject: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdG1org3jaXTCfYEatWTNEozH+CQ==
Date: Fri, 24 Jul 2026 10:49:57 +0000
Message-ID: <20260724104819.1296803-7-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|AMS1EPF0000004A:EE_|AS8PR08MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: 811e57bf-ea11-4914-9259-08dee9717337
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 FB7tVMSxyaob72FvU9w2avleEPaAejYne+uw45LBHq2WW03Fr5kOiguquD6URorLfD8Gg4vg7wWGJ2xir2173whypF7olnQlW0lPSYkJgGDkpe+rJ7qEIUz0yZewcPgsGqaY/0Umza6m59zmozMQ9Td23gkd8pEsd2qIqayrzzzyUhSCUyAcQpAo/J647nf4vDMrTGGkrio6xp21DJusaG3WqMi9OgXX4WejYT+iqcY+grlcVI9u5nZh7/StebfEIDOLhve1SfkNnI90ULVqgTlqHk3DA3+R+o1raRRKyn4TAwY9C+YhTIoTnLfq86y+ahwONLe2dR2Dty5lAOrJFsUPCA4ho7PBUhmHazxVjA6yVRotMa8AZskdcIVpr6sZ4p0inQ9V2+vyK/rPQsfCmgpkjFLbOF4Lb4Rx/fzusEu0671DLBJD0HDJm8SDdkZNdtWuKBxqBiiZ1jIIbl78QurwQ6coF45Sjnt6BzYIIUlVzFWXRN48ykqv0d+her7FbENrcLQrxUBJbt6Ys6OsRj4ahFJH67bPEN2VmWtUP/QIR+2h/S/P5aieWpIQcn1VfugtyBFpEndOQZDOQ62KAYvIgOWYyGkhlfVo6Q8KfPJUz3uxM2CdQACF+O7VknS8aOONa9DAtMyEqlt7vV1GAValZse5by5ooyZTtKnndm8y/WIELFZQORyN8EPVf/dS8yyhXAzGk86q5Nl/Moqbn6Qu4AB5axwCesUMwsZ/bZk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JqNXNu51KE4dVtlN1JijZUnxYvJgbG2OnDdPk5Wd12VNMnd6DzE9EEWWeEnulkOBrVzYTS204XnyX1zQHTfeFp1uHBcj7pGMBOA82kG3sdXRUDCfashIfPxhAVIh8u0/vhPmwb8AloWt6vmcle6XM7GaqLIbiOeLnNDjYmKB58MueS6rkqu/GSFvCjaS5pemrWK4DM9BAACk1B3U9LmWFo031eGIOHQhi6qAU4ynuAc0S2Iwp6jWKAcXbrkuBbV8oMtMHEBs4VHBHi/v4WF44tuc43R04fo6Z3ewqjfTr0+cvf/8XXsfmif1DbL+uhmQ3hPXfaRFmYDJArwFzMDrWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9e5f077-f9d3-4d7b-41d4-08dee9714dc0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|23010399003|1800799024|82310400026|36860700016|6133799003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z7bCeNFg9j9MMl4RIRMhLjtjpdrTPU4cMjjX2OCZephh8P5iW1I3dxl085F/kbO/nmzxWOvokZXbVFpSzKvpx1qkiwFY3AzKrzAeWEmkGtSTI8fjsrQRoaIiTbGErLRu3lSBy6GGiDBSBnxgXliLz3xgWWshFaMn7LPAINaVYVjY7rl5cGDtmvyewKUY6aCPd3mEADsr81XrnAAfujq0r4ETbMQ/MpHFjAMUT4BUSsVsRdCkLaWaqiNmefQmkZihOQNMtyG6FNdjXcHEqSGUi59CyQ6uhXEp2AX18cSW23d/E3osQBRxq9PgdSXweIFq6/fQeFiYGuzPD9yfgd3TaOAfmuyAyRxzgxaQmAp99nE13bQhHcHSorkcuNOjSoLHPDhWFqdF/KtOSZ2JWnjXUC3+MalOQ47TwkUZnpm+fq324h/J5Rtx847my53Pb0pVzbE8p1xhHDacXa2c8GNN7o+4gGLv8Yt1H56oiIYN+PiUj6Bg6Op4uz4489dZ5D9SaYmmjuxa1PJAYGBzQopCbGjkt6obWTKYELtSJNXZCUA6NneQRpRdQjTmVAV/sTTbXO2mpabrzgx9+YLkaIewLxt4cHAjiv4dO5AmcOWJMl529Wh9r8oJ3R+qvJqqt3Li2zD7ZtLeVdP4Hn2F9Xcv6oefHlz9PpOY90p400BLufYpPTXf118cK15cvNl2EGiUKeG90MBCaDcUglVVL2UPaQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(23010399003)(1800799024)(82310400026)(36860700016)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RUT+ocYBFQE4074PANbuoGfK/r0qcVOU62+U40fXPypcYdo7qNy7htOV0stpe0W840wE98WZHDqiPQjRBw+G9V5GwnFyrrKrtmADnRKDLyinBSnVuGqgrXnH8413cByvhYPs2WcxD4ddyKJGOT9zdqqAYmaveRUNSd2DKnGgyr9EtCY3hOphIncQ7JmTUdP2ZOO5/dcM/Va61VAUuMXKzTGqJnU6mGWrMnSBg+i7Qe3vcNEfMavHAg6tv44t002gLx4y9vwfRFXIPxgGOlEbI2Rf/e/ClHUehDQAihd8x+jAJfG3ZXXKOpLSfzl7lEhcQwvMTEBvsTElqPAbMxPyPlVf0Ix7CM9LLi8/Yg0jRH30kTwXluXvEHQuA+QFo9oyfPjGX7mrceVnd19Z/ox3Mv+g2wgO37hOmr2+66e6sbXINvFvQXI+2/+5WlCcEGyn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:51:00.5915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 811e57bf-ea11-4914-9259-08dee9717337
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8133

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7cb61aca3797f..03f5e1755a633 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
=20
--=20
2.34.1
