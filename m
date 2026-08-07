Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013024.outbound.protection.outlook.com [40.107.162.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56B41D4EA
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101899; cv=fail; b=Q7AWtZGwa/14t6DSSP+NyyOPeW/uGTzPG0YHgFjr9LV7/YgID/OBkW0lJAGmX8DbQrp0fiNuEBqaOiUAjKg+KxyLi42YX3KHDlP5P8gd7Z70DRuCRM9KP8/ZfvUKeHq3OIs4OeTKWC/nGEw/3ORWmD0yx/nK52Jb5jN/Qs8LgZs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101899; c=relaxed/simple;
	bh=gK4FPrPSEu1mJnSDLFSXf53I+UVI+ePshPvmqUgFjzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fursm+KbbBoKCheLu9QpXXl3TzoyFjDsjZVUS7iBPkossf45zSdlR4DmBs0AIb1W9xbhfMbFr8Solu0l54yXlqrkRqHzuYtTs4K0Jjwkw2/nac9typcP+Xop2NRnZEZmpBwAaitlk4wCOJ5pDXXpYiix1zCLnEIr0S/FVLvxVdc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dwauf13t; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dwauf13t; arc=fail smtp.client-ip=40.107.162.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dwauf13t";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dwauf13t"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cUKS7N7Hua1SRDCS+12zZh/TarKZh51819TsHr6b/skMPUjSjIoBqx3G5TcCiPUqhvqNHhKe02CkvWbdjNP51gBNMLhxOUTK6LI7QQcFEi8gqOKx7f+xDi1o/uXQ86sgc2nVFkgvAtMg5KG/BOzDYogrd7kosxvyceXdZx/nIf8BzWCSOdIjq/864Or40KKepbzj3vnHpi2sSEXN6Ta/Gco1TPZ+RqQHOIf7Z+ieeh+7VqND8lURx6qq2HXk9a1XRF6/ruaiCAVf4d/Lp1ahFWg4x8KdXWbcNgmaLps5efUqH0A+uLEeuzsDDQpjKbOyGWYfSlivOnTeCothSLSzGg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEWa/gugJmuPOUeRvElqDM71/nzZZwYo4mrY54CnVAU=;
 b=L/Xkbe+vBwEcb2GtmsuQ4ViL9sKEaTNUeX4NfTlJtvuEDNxv9qvOlSuApjV8mR/V13tfYuyWVrUAo+gIISJ0c6UYHqk0zlV82MdLeq0ZlKzVbHXeekjxYU5FifFdxRDIIO+Q76Xctz5jtVPyZljm+Y7n7WuykfDWeoQmmjUpt5T9BsY3Fx4VOwVRbHFyBoG9VPutWduHyZMQIgTb0FugzuaqkaznZilIuwHW7YN8ayc9fovlAmo7Lv8ZREf5F4AR7eIKEsiEiGSAYM6hJEAmSCEwV0vnGq//iJrn2kf0NshDtGxQM9T77WqHm9r0pIJYMvsU46JJOX+TKY1ocM9krQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEWa/gugJmuPOUeRvElqDM71/nzZZwYo4mrY54CnVAU=;
 b=Dwauf13t+HPCROWpxkbI3XbFDE+cslSjf+y06MBnoI7AWp6Qb1YgNWtMcmQwmzwlXB97/gCKBEI666vnQGoBGpCprYegxJUgnEFHxSBp9HquPvoKoMGdJhjdJosXDnoY/Kf9Elj5WRnGhlkQ9m5/8crALawBsLxaxBT1V9DCxr0=
Received: from AM8P251CA0006.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::11)
 by PAWPR08MB9031.eurprd08.prod.outlook.com (2603:10a6:102:343::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:24:51 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:20b:21b:cafe::84) by AM8P251CA0006.outlook.office365.com
 (2603:10a6:20b:21b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:24:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ta1j6wC0QirmgiQIZj2gGx0vW6iVpYSmvltWFypxLA5VgVeyZyM6ReJ5FlryRpOB1ZVQr+y2wH6wWTISI3lZdPg/nY0uCpe8EI5KdOihr07QD0q1vCy8gW8vW1RBcLPsnECq2ZK10sgLTbqFa/fSiHYG9uYoqxYV2Mn5tf7UAt7Q5TONwcD9gmkaznSDhCjf/VjGl0m01+soslnC5AmYNweHrVBjQrAWWnDHAxKP3t7iKKSn3fNuAvJt4g6zYo9LvUdFxXtAFnunLnNtYgHLF9Qe6hRptXwAKhx+ivZbb2A2/Inirw8+7WMEDgw7c8TcRPUr2bJ4Fkn7RENg8yNmwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEWa/gugJmuPOUeRvElqDM71/nzZZwYo4mrY54CnVAU=;
 b=QhF5iWJ5Xc5jV5ABkIBbcI+7PsZKn/B4/uhp2C3t6HReSkLjNtD9dhVaB41/E+e6HYL68XWNBnZfdjJ7rtES0cg5txcmtfQrDSOQJAE91ABNYZHP2pwuHL4J6sc+cn0D3exjN3+W1j/9bGbgU2lr0immnAv7pVHsejrNv2fBbpDeHWWaycBGUfADNRZEOwCrZjjVvu5nBD5F1pqSRc5kaefz79CbfeU4RN5YITX7SSfQNAjZXJGCZ8pGqAda0DVGYPUamyaunPn+EjeVYzTJywV5WCiXjzkRg6ReF2tAz9Eo7k5iZYS1GoXvY/2JgQAYcbZjK+r/kmUzL5wl7GrhCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEWa/gugJmuPOUeRvElqDM71/nzZZwYo4mrY54CnVAU=;
 b=Dwauf13t+HPCROWpxkbI3XbFDE+cslSjf+y06MBnoI7AWp6Qb1YgNWtMcmQwmzwlXB97/gCKBEI666vnQGoBGpCprYegxJUgnEFHxSBp9HquPvoKoMGdJhjdJosXDnoY/Kf9Elj5WRnGhlkQ9m5/8crALawBsLxaxBT1V9DCxr0=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:24:18 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:24:18 +0000
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
Subject: [PATCH v5 23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v5 23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdJl9Jw6+b3T6MuUu1f5uE39p3rA==
Date: Fri, 7 Aug 2026 11:24:18 +0000
Message-ID: <20260807111159.429128-24-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DB9PR08MB6729:EE_|DB3PEPF0000885F:EE_|PAWPR08MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 53da9206-92cf-4330-9470-08def4767f48
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|18002099003|22082099003|38070700021|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 o1A3x16nme+z3OWZtD49w3eo4S7snqull04NwyHJtd3vY3hTTLfS7TmswOWYYQ7DQ0CE/+uCM5qJ+vEvXb1yZI7YVZoAzOjQZS7jjKK0wbqJw6cTOa08dlPaIwJ5Iz1ZqNxVFD+7/s90CavSFPwt60IWayExxig0V/dvQtnq2kqcEFi6tXA33eT0mPKDlA2pxxjFPKORL4HYORSHXn92NHysDaFRPeeJWGIPvee9obrFFK5I4gqME7Hvd4Dz4Q5Rt56wokps/15u2ikh9jFaZeDk0orkkUriCwXXqMBn/6nJrYuYsIJgEFj80sVpIs10mlE4aBL/TEaDu3BMa4gPFn5kYuAgc+x54ANa9ioYwzOTsgFq6iACOC00e0A04xpapmucyQLBmX7AAbQjILoJm3Xtuj4kFHguAntLou6KMNPely/lwvJ3pyNXFg7fPJOfckqMUrRYGKxnUezX55lru8GCHwmcPr57H0WM78lx+lWHF9P+wHFP7a10nuA6vS5mlVs57l+AKFNs2eZ/NQSa3OtoU+0tIxj9H3BGOmGxa0EozyEK8VRDXkMvIQJ6qbXZgPZtP8ki7O8wQqYMTiiNxZqZHJzG7tPTZiAkWQ25WtuBe2p8wIj15razGUc1bmdNJhwuVq6k1GcYuLpqTFMuUOQqEceeMpi/P5WpMRCYDi87prVKIlxL6PSmu9YMvAqN2NscvFISOAqOMbmExAzQLRym/tv6UBiHy9OZKJh101U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(18002099003)(22082099003)(38070700021)(10067099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 IPtkiszsa1Lfw3QdpCrguVhbCD7rsuuOaWzZgGC7kKb3pzYzFb97DQcrkanvnsJP5/EaCJWU+WJBWBB5A2HpIne5ufipH/Ig0yoTx80wko0p8YgFvWUJ2ecvmxu/e3pNv93bsX+QYJehN0Tan8pso1v09NgKl8C7myDXdFvfQrl0mmxVrXbepUHUMe58EDJ/lc/H3TCu2bG5EXi5ECG4imoCEylhYo0zZcIdC/yWb2OtXxRXrGVn/01QEm86W8ZFpeksO1NOpPss1xVk9tNz1SvKlTGehEzDSaWD9y5ROBpL3ne0AB9cVcoLxzQPYWQLYxUUOkx/t4ZYB1Yuc+xPSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	47d18997-71f7-4a5e-b836-08def4766bf3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|23010399003|36860700016|14060799003|82310400026|1800799024|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vaMOzq6VaPexSUgRuW1CVqLcCN5mCq4CPuO/8AdeWkVtB3QaQvqTTM69XWQKb8Evk/pTdYhHIFMSzR9urAfh1nLeVPpd8Sjoy6MLZ9Gge/9ho9Kmyf9z9uIQDb56Zi4CfVD/p8kf8thAmtC9RXjFwrIb/4AJCrNFNp/fl1cwircSM1pzx4wn9JM9D/jtSF1qehN/svBircSxT0xP71PwpE5W1uX9gE9dIagUyefaRdNJ9+mYq+B5RfEa+Ah+BYLbn5Y5JZOq8mSe3WESRopViELBvkNJJB8MJPiCPdDlXGh8kUFZhe8UYTzkYZDMiBjo+PLPLa8Wc9MyzfMveVubrjNIpr/UWhkTwNNYJMsXWpULzQpEEwCrM0+wAEO91R+tBmP/qfmD7mEwp4OdB9aZWGjXmg+DovemwLI+uDCfhMPuNvaTTx9Tkoq+rVvhFwzbvq+VcNQHIHjxsmlZg7sJFIM8V82bG9z+gRBAqL/LGVgXnwnoZGNPnwJIsvVSyYYyKGM0tnpfwjp5GV6EJdKLBwEzc/RsdFavK4Himl4jTEHI3aw8rlA9Nk4Jm6eg4EgC/m57IR4Cq7/PsE1XdC6K5+rT1R/lRqP9Ms/+uviE7ItgTFxVDKGnUFslMsQRBir77xqfnPsnGYCZDXLrZWIWMahTEmP4ha/cRSG1ZXjVEDpHzV4sCVYrh0vrjDGnGzL+ppHPg1CAlHJhSOVzeBvTPg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(23010399003)(36860700016)(14060799003)(82310400026)(1800799024)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KtMY5fv78juU5ZmRyjSD8QGWDEOKbS12rd0GHJdW1WVIwhoHYwVrItgcoowCYbl/q/RO9755EwdMNLtgG6L0C0K1eFHUghMVoFGySOP/POu0G4jxkk6ulttP0HTHLAV0SEZeGhwsdCcyF8Kq45Uu9899UfKiSmIo00asxhyCJPFxX75yq5PuAdALpyqACVdcqi+HnvBa7Qao8GsbEG+YGIEMQ20KrmpDfYXAvTRxoeE49hRAtotQh6ADDkNomXp9gAU2jjSUIGTWhhehBAGnRs6vCLtgfCGiEWywMVoMRVMD3sJdo6WbqkA+/ruPnU2oxyGq35N3yMVNtEjsO4P9oy+5V5S9eWNjYiN40abp2HS689w/3UXR2kD8YURHzKGT9X7GIRnNdXI6fkQy66tdV5rblDKNPIGUnpGFGrXapHWl00SfYtna5VRRTGc4tqcJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:24:51.0964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53da9206-92cf-4330-9470-08def4767f48
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9031

The GICv5 ICH_CONTEXTR_EL2 register has the IRICHPPIDIS field, which
allows the hypervisor to disable HPPI selection for SPIs and LPIs.
Use this to emulate the guest enabling and disabling the IRS.

Program IRICHPPIDIS from the virtual IRS enable state when loading a
VPE. This prevents SPIs and LPIs from being delivered until the guest
enables the emulated IRS, matching the behaviour of real hardware.

Likewise, when making a VPE non-resident as it enters WFI, only
calculate the doorbell priority mask and request a doorbell if the
virtual IRS is enabled. A disabled IRS cannot select an SPI or LPI to
wake the VPE, so neither the priority calculation nor a doorbell
request serves any purpose in that state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6a7dabf90dd1b..b401e80d74354 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1063,6 +1063,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !READ_ONCE(vcpu->kvm->arch.vgic.enabled);
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1079,6 +1080,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
@@ -1105,7 +1107,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
-	if (vcpu_get_flag(vcpu, IN_WFI)) {
+
+	/* Request a doorbell if entering WFI, unless the IRS is disabled */
+	if (vcpu_get_flag(vcpu, IN_WFI) &&
+	    READ_ONCE(vcpu->kvm->arch.vgic.enabled)) {
 		u32 priority_mask;
 		int dbpm;
=20
--=20
2.34.1
