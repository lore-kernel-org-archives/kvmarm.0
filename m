Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB70C4908B5
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890365; cv=fail; b=YJnrGTzkMHM4ZeLcpRRFy9doBC/DWNKvFSJ3jysIX+MiU68DPkHTXYR98jtJfUL75SUUO8xpWlCgMW26w4K46AvvF7C6I1I7aQR0g/QnKTtE/wrw296OuFmou13LjedVkIktPD0DRfhKZYHJVw3YYrbJI/4pJZR8qc06eRkzpgU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890365; c=relaxed/simple;
	bh=qGy4CCV7gSHJPrLkgEV4Pz7gFySxLlUNbmaY2kEYXm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GTPBkBCCWCpnPrp+qlRIN05NW2bLG0mwtAvMPqNU2bXhyUP2GdhffV+jW+17RbQzrdlkmgR+8UZkAq8iP97KmixmFpffXTnAIkSxtvPJuW/YLZjuCkJnT8ZVFPII5Z+WI0e/NI1bVlc83l+3F3K1q2tgtG3Ma7gpccrbhfKhpms=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bF6nh9F+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bF6nh9F+; arc=fail smtp.client-ip=52.101.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bF6nh9F+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bF6nh9F+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KWCLiYpQLUA+4o7GXhsGBbORMjxF0XYHtoQj01PxqoXlPThytahe+niPTAxVOgGt4p+BDdc6CoxMAn3ivGjFmWDMXWU58Hagak2NxTc54WrFO9ZNFAdu/ZOpY9mEW+g85Bm3bt1aK2D7SKyWc5RcJ7s5uTK3l6PufYEYOAsmjdWYtoDDYJFu6o2hAXjXyYgE5/QL4WCshDABZ44LbKhNhY96+EZxzX7UQe4u3YoQqAQlZzvwodNJmt8As49ONSbCGgTO6jZsHbNUK++tK6By0IZrOZlHzWl/wRO2alK7+UoWGnkxfipoDwpJrKw1j08JvyuaYrgtqn05O5r00BJnUw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yi4FBZsN/Bn5LEPvWOMyBcJCvsgDi8/T4S4jkaVFgPA=;
 b=xJ677KZlunt9GQ/n5MvpChPRP6xM16Cd5ZWottyPNa3k+I7l5uaU+/FyXFg9EC2gf21JYMB26um4r9N7I6HdTNZHTEsxO4Fuy2AUVenehLEO8FRvbjZTPapj1kCgxo1yWpHG83wNjTyb0aGN/c27FGMjelKnJUImoXp+9ipbesKHBMUFmTWFZPXSL3tb5YCNazdbqiran6YMAz2MrkzUWg620UIcnMHy4TjcaHoU/iX3+285BWlOv7ihpOYHtABvj6SRyYH71BTrxmlXeJj9ByrT+W0/L7M20sNBpIN3V9RL8F2IsPxAHVfh6/GCCdFGnMlvT2REsDbcd7q/V0l6gQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yi4FBZsN/Bn5LEPvWOMyBcJCvsgDi8/T4S4jkaVFgPA=;
 b=bF6nh9F+t+1XkqxckDGmX4yzoFxKMNlbhgUQttTC3xU9d8Ap04f3tv3PYEmUwp4+5MubYQnuW2AsqQBiD0IKYVYZOed2lAKQpFJgBPAIuA8wRBl1/FOEfGR8ABSJ6fhnk23d2VsoFETDuBS9D4izUXibI65qDar+KEVa9MGWdmw=
Received: from AS4P251CA0030.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::18)
 by DBBPR08MB10409.eurprd08.prod.outlook.com (2603:10a6:10:52c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:34 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::85) by AS4P251CA0030.outlook.office365.com
 (2603:10a6:20b:5d3::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:52:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:52:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m9GpqsDQu5tMnwKXxQ7HKCu6t+WuVUSwKmXcv7yLy06RywCy6+Ihq2RGCGL+MrA/B3epfVeh0Bs2NjBNkQIezi5kwA131MPJVL3zyBCOFC4RyIHS7CV5NVQ15GB0eJ5xZiMPWeqWuLepmQ6DbUveUC5dAKiLoAB6Gj1kFdQVlIvUJXjKMqHw2IFtwf6AS5H21lTPAVLp/AZYU3tt8ZI02amarU/BdnhJOCESW/PqlqAlfHQjREEtG4B02/Phn3WUJJr5lrIlURPZc1wmTjsxB5JcNs3LtgHdUTlVs/AC/tPUPJkFCAaQsHfKweJ3PB/GH0o9WyP1ZdzYgOgvW/rSNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yi4FBZsN/Bn5LEPvWOMyBcJCvsgDi8/T4S4jkaVFgPA=;
 b=BNcZ01vl/vqqKkxBZqB97gYXCO7ORAtQO7WPCQ4OrFwub8YxBWmGDmG4eDKleGkM+AQdNOYmZunpSMeidRZky6Ns9AGK9Ie6I7sNpUpJwSJ8HWCTM4PeKKfrA8fXbKJkmnp6VY4cDeugTAe4wVZJaXJpIKFwBaiOhxvZwG3CwAMomVOB/FTdq0htfrDmH7tgliewmyg+bpi1qaXEojTM1gXrhXQUwPc4Hl0ukIJ7b9kZn7+Bby1lXgZdO7OzPB5UX5xaqQbHhe88PixQUcmoWxxktDaaPNX591dMGb+3yYBZa6hizdlqTRpVLwDo2wGtRnx9yfFRuQmA8/jhG/q9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yi4FBZsN/Bn5LEPvWOMyBcJCvsgDi8/T4S4jkaVFgPA=;
 b=bF6nh9F+t+1XkqxckDGmX4yzoFxKMNlbhgUQttTC3xU9d8Ap04f3tv3PYEmUwp4+5MubYQnuW2AsqQBiD0IKYVYZOed2lAKQpFJgBPAIuA8wRBl1/FOEfGR8ABSJ6fhnk23d2VsoFETDuBS9D4izUXibI65qDar+KEVa9MGWdmw=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:30 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:51:30 +0000
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
Subject: [PATCH v4 12/48] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Topic: [PATCH v4 12/48] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Index: AQHdG1piyY96yLB6t02MQx+yByW6bA==
Date: Fri, 24 Jul 2026 10:51:30 +0000
Message-ID: <20260724104819.1296803-13-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|AM3PEPF00009B9D:EE_|DBBPR08MB10409:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f89b7fd-1b9d-4930-1468-08dee971aaff
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 jhCEsovRwHkF4Nd0VhjfVwL7pCrsbREu5pwOeagkBrp0+A0ezH7Kp5kdYN6ZpbM7saXPNtZvM8QlfudvvLNvNwL2G093eN5aUTq+KhfXxD0TZLOPr7baYglpzT0OfTukRjLkT/vUDzdmPxBm+mAynfsDSvyTfPGTZW9OJKL9EIRV3ZC2YDV/g0QmnSu+70yyDbhxCr3Tc6QrrWOWz5dKw3fLPjF5LiSmTENEyxFGKUuC/qM/6PLX5NRiTJqeJTMy25sy5wcLy6RBA+Ym5KJz9U+NCNzsQtXcr51AWfYuuEonEoGYHIL+qrt6JPHoOtTeFhRfbVB9n4wRoAncvHM2/yxMrS0rZFthTFMIh53BeMD9FTZg/20vdZNULpZh4Noz3AAvenSCW+WIAEhoJ/v+e0t499GiaFjhpf5BUDxjemXHx5CspvwOYhOo+wGUa8Ll95dEuTnFiZ7x5nqiI1WTdWV8WWZs9W8LLgchYAuvByDcxCwzDLlskPcc+vMW6fGg7AzAITbwbsUQj0Q9j71j7b6PiiKfAM/m//cL425LgeR0v2FEgstXWpw0YK/lal6VgjJbEKtiDNP1oTcj4+0GDBqqLQC27a/Uo9NiCYAmvtDKRz48UE8DepEiZn3PRLfPep0jOr0cr1kjl/zpXgdB7+Y3Omd+vl5AHAMFvfXpeo6VYuUsMI/bb+bJtJnmI3if0hnToe3MOrx8gXWpskX3H07WSdtraAqh7d6ih2LwFiA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 p4pSfj+W0J07fHzULZYAcV5jxV4uxopkXNnStv0lE8aipgDF1UFXhyKAbC2d1XQi44uueBfTNgnCEN/MUGB3IIvKxTAkhZE3m80xnR6uqyRglY0lVvEYsPPQAfJxOpfrIoY5Dk5+q281o4/qt+FfxyGWq4RJRsQpO07K7gcwYjVLfoK1wiPM+aE9JsU9wYcn06VsgFzVIhxQFa7GxZC4JNdFBXF0O2TXgJ/23UUXmW2yPqz7oNTxUdI9IMJH1gorVq0gF+CFOj1xns3aqCMJoJbk6QtB+RX7g+kn3072iEgH2c0EUa8VKIREn9l7s+8lpbUqnIzMTrAaMaMIwYkuew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a4363706-1c8e-402f-cb99-08dee97184d1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|14060799003|35042699022|82310400026|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9hlQkIHb/OcWB3W+ZViPgKLCZJBm853kISCPhL6jmfJ49RMBsakzgOfym/lLteDcdwCBctZfWhgOmVlfRTWzc9yr/NIdBGzpsrSBKLcavc/7tAeomUVI3tFaAzh1jp+J0vLIeD/lxD5Sf7zMeSjzsvdR+sI467g0K/Jp7hpYYUWaSKahj7dtRCU54J9rcQ7/frqKAWJkRfITYgWjbXoR5CMansL22TIO3wB3ZcW3XYaAN38OrB+IuCzDmg9Q1ujkR5Yg9Twgxxu7zxTjKSeoLCTdM0qLIY67MSPCHZe7HjUqEvUF5azgtI1sVi3Coz34H2PWyEhgoobPZBYrOehfgeijTwZAF5mNgcoZ1DHDSN7wOC+QfvFoylyqmK5E0OpxXjrJjKIHYgXfsKwo90NtB0C6LasY+yfMS6/oQMjAyfrfTXGTxAOmdTSnq3UkUtpWPIaN9vHnStXQtJWxXHnAkNTsHyj6ZVQc0w3ylZBBYU7sMzYNvxT3n17MLfbaXqkwpGAGzkSwjEhfzbQNsg4zh6IVyqjTLk2GgSvMt2ZpTc3Z04gre0m95Ekv4eMG+1vvxldixRtQ7TgpzYXzAwXW+dIzrcn7H2q4T2oqab8QOfel+Pt6RQlFDjnGXI86AkajyT4b98XbSfCTTldVF17O01PQzT126uMSKJh6T3pSquvEwAftY9impTX+R1AqLFFc9tXd2gNc1Tkkf5gQjlDfiQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(14060799003)(35042699022)(82310400026)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+JPIEdkZYjjTo+cOMwexzq91CJLyRdDjbF/BXq4rlhovma3LaAK757bRwBg/hYGT8btKorELY2k8MU7deJ89X0BtCcV6teoCmwFJkwD4YKYN4LJlskThznxYXg0BGF+/MSdo7Mur25Al15vvrR68NESAVUrPKO1jh52V/z022DV5ymI7UolPW6faMlUhpjmCsLtsnzDbgo7GOfheT5iwOpZzh+iWUlqtLWu76QCYvDT0K6f35vk0T/PiSXN/p5lHcmQItY4XO58tCuDOqVYtvhqpi/LQLfreZ5KOQTsxkJ5qXNjg+EUPJGArtXX9ia7DYadPTbXlWsyx/KU3qkgfu4oIYwf+7XJzP/qUwFh0VL4IGX3eE46rNzuJL40INQKm+LXcHhKsaM0Ue8g01XJFnAHtKCz40jW1Rde1Tcz9uxPLdJ6IXeTB0M0oSCMxhE6s
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:52:34.1576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f89b7fd-1b9d-4930-1468-08dee971aaff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10409

A GICv5 host with FEAT_GCIE_LEGACY can expose both a native vGICv5 or
a vGICv3 device. These models do not necessarily have the same vCPU
limit: the native GICv5 limit is probed from the IRS VPE capacity,
while the GICv3 limit remains the fixed KVM vGICv3 limit.

Keep the IRS-derived limit separately for vGICv5 creation. The
pre-VGIC KVM_CAP_MAX_VCPUS value continues to expose the largest limit
among the still-selectable models, and kvm_vgic_create() clamps the VM
to the limit of the VGIC model userspace actually selected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 14 +++++++++-----
 arch/arm64/kvm/vgic/vgic-v5.c   | 19 +++++++++----------
 include/kvm/arm_vgic.h          | 16 ++++++++++++----
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 079a57c2b18f6..94632fd90b728 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -129,13 +129,17 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
 	ret =3D 0;
=20
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
-		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
-				     kvm_vgic_global_state.max_gic_vcpus);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->max_vcpus =3D kvm_vgic_global_state.max_gicv5_vcpus;
+		break;
+	}
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c68ca4f63f3a2..21252bd11d96f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -110,7 +110,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	kvm_vgic_global_state.max_gic_vcpus =3D 0;
+	kvm_vgic_global_state.max_gicv5_vcpus =3D 0;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -135,8 +136,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
 	 * can't use them all.
 	 */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
+	kvm_vgic_global_state.max_gicv5_vcpus =3D min(irs_caps.max_vpes,
+						    VGIC_V5_MAX_CPUS);
=20
 	/*
 	 * GICv5 requires a set of tables to be allocated in order to manage
@@ -145,7 +146,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * we want to run. For now, we match the maximum number offered by the
 	 * hardware, but this might not be a wise choice in the long term.
 	 */
-	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gicv5_vcpus);
 	if (ret) {
 		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
 		return -ENODEV;
@@ -167,9 +168,6 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return -ENODEV;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
-
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
@@ -183,6 +181,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
=20
 	v5_registered =3D true;
+	kvm_vgic_global_state.max_gic_vcpus =3D
+		kvm_vgic_global_state.max_gicv5_vcpus;
 	kvm_info("GCIE system register CPU interface\n");
=20
 skip_v5:
@@ -210,9 +210,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return v5_registered ? 0 : ret;
 	}
=20
-	/* We potentially limit the max VCPUs further than we need to here */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  kvm_vgic_global_state.max_gic_vcpus);
+	kvm_vgic_global_state.max_gic_vcpus =3D max(kvm_vgic_global_state.max_gic=
_vcpus,
+						  VGIC_V3_MAX_CPUS);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ba32cd71fe0a7..6f736094a0e7e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -157,9 +157,16 @@ struct vgic_global {
 	/* Maintenance IRQ number */
 	unsigned int		maint_irq;
=20
-	/* maximum number of VCPUs allowed (GICv2 limits us to 8) */
+	/*
+	 * Maximum number of VCPUs exposed before userspace has selected a
+	 * VGIC model. Individual VGIC models can impose a lower limit
+	 * (GICv2 limits us to 8).
+	 */
 	int			max_gic_vcpus;
=20
+	/* Maximum number of VCPUs allowed for a GICv5 VM. */
+	int			max_gicv5_vcpus;
+
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
=20
@@ -635,10 +642,11 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group=
1);
=20
 /**
- * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
+ * kvm_vgic_get_max_vcpus - Get the pre-VGIC-selection VCPU limit
  *
- * The host's GIC naturally limits the maximum amount of VCPUs a guest
- * can use.
+ * Userspace can query KVM_CAP_MAX_VCPUS before selecting a VGIC model, so
+ * expose the highest model-specific limit and let kvm_vgic_create() enfor=
ce
+ * the selected model's actual limit.
  */
 static inline int kvm_vgic_get_max_vcpus(void)
 {
--=20
2.34.1
