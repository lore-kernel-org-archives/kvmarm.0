Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013050.outbound.protection.outlook.com [52.101.83.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A34480DCF
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522953; cv=fail; b=QchsSNrJtC1mILXIFXfe/Zkkevk/mcIMQBrkNp9qxON6F0IPiWiOg2GJsApIn/WY7r+ExgJndKa3bxi7qKndLbTXv8x6CjfMortjhOmm/IfQYgXxKI7kZfUxwLtZDBEAw9I9tkOHGiJJrTIewKx2RLOXkdN8XDqpQeNbhwCi88s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522953; c=relaxed/simple;
	bh=5tFzPk2VJcGOxs0g+XcFF5I4Tp0ZfM+85SzANCDCWII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b9Vu909vL3C5u0KDvmUl03fZbpMJfiO3azefGYcVnBuhMYQ9fIx8RwT3fQr53Jrqk+eYYjt0piR7xpxwrOLK2lrlJt5XZDuvNukzAZWr8AzDlQBwGxOcWQKiP7UsMj4vNdWtgSSxoUwDm6/nl/jWZ23Gi/RjDQvYAZY1KDJkno8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ULgQuDEI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ULgQuDEI; arc=fail smtp.client-ip=52.101.83.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ULgQuDEI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ULgQuDEI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YQCzQFfli/ieU8DX4bL37RxONYbptWh8BN6Ks+8J2+Z2mYY51lhxCyNxX10gALCGT/3xZlIyKvqQiV+V+fQHpb75BEl9LJ/zNNBE2kUAyZh/u5Q8VnK+IzhOp08Qo3oGXtJBnicpuFas8yp+DnVUtuxgKa5Yphd69T2csCSvBXtK1s+Fj3IWvPXu5pgUQxJ/Go8Zjzf91XAdz/TtOwLm8O0rgsso5Mvq0c0zngxyDGjONyoXQPFgfXq8Yw4SmQcgud83h8X+VyCSYC9ybXAaGIvS/K87pTsVQmqmdkkvx7XKEKNv9K9D1efoUjWhusVM4LddmBMQCbU0J3SmPPIg0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ivxLTeJMdwaBErkIMwQ7kJuBUP7ccK7B1jti5UgO6c=;
 b=dFbPz7SG/UIOW4smhDmfEbv98PdDt8Li/jAhmfO1Z51/ba49bB/6XnB6dDD292NR7vtIIuls2+4SmPgWZZ1Oxdxtjxn8yPaZxn6CkIusE/M4bUVzzyH8OW3jo8SbUR3JHm2ef+9gjSNPg7OkCvW/rIU0KupFeD0q8cxo5KBaHBFy2/NNJ6DOaVjXYkcWa0P+iO53zvctavl0TTYFIcN5TlK+2amByhCFpk5KHbsUVeZjl82ActA95h7yKQm7rWST/Eq4krZGyDnQZtpWJxJTYSLD02LxIWBITzCoINSXNq+VLNevep2HfE+DZEmnc27wz9dq+wH6PuVl0TB6C6GZ2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ivxLTeJMdwaBErkIMwQ7kJuBUP7ccK7B1jti5UgO6c=;
 b=ULgQuDEINScV0C2W+dyR4vvOAHuAQHrDdxCnSt3q8fcmyv79baqHjqj/K4DzUXw36Z3rPo1DTOdaMXWbCQq0PeKWi+wdbVxQJW/cjWDPVL4CiXQUwKognlkCtPrDoyeZ1HGObbyFSrPOprmbuqwJdDj8wYtWcugrzmzP6qiJ4Y8=
Received: from AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::16)
 by PAWPR08MB9006.eurprd08.prod.outlook.com (2603:10a6:102:33f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:55:45 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::56) by AS4PR10CA0024.outlook.office365.com
 (2603:10a6:20b:5d8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBQt2NE7xgvEgyzJNRmuVTfuMr3XzcIys/em/9rsf5pml0NNLFdNq4oEpPBew2YS+e7/koscLy/EgD+3L38LmkdQY/2zIxTaeCGB7g/dLiD71Dcf2MpoLkevLsZvaUI/iLpuGTcvDDZ/k1jhJCneTBfRIxr0+CGXX0z2R6pv0z1gTozNF12nvAXnBMyqkej1QEYG24JwG3nhYKPfYNFgP4uvWvlifR4lMfWYn7CIrP81b1UeLuZRDf+yuT0KXRYsXRFlFrzwvIGzSngjbWz7o7bkG/QdzqHqdLyKrS+0MGbcSorOYD3pcPvi/1tsOGlOAhKxDIrIAb2fwh7nOJBgAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ivxLTeJMdwaBErkIMwQ7kJuBUP7ccK7B1jti5UgO6c=;
 b=yuTcHRYBTHCiO4cbubVXSNkv9uXSWC/PFgDjw37a/JmdcMJh1j7LPCjwWIi4j8mKWQetDBjswid1VlVeCV0d3sk2FCsB3pnEw6sX8SlVCkfIKzyb3+jSDwCfCkYQVlSz46pcXvnCGeCLWI5zxbPGeEsYzxF6kqf4CsSVkKZCaweZq8eTIC7WBdY8JMr3vrkcB/JfOwMfqibLG+ZkmSKxAVTVAEcFJVLd1rACzrnGKWTvkyQT3E4Qz5tBzavxTSp5iDxTwWkFkvzdwhslcgE3hNG+6O9+k6XYuETgSwV0IGBrSRe1k5nTPugXmjaBy8aOCN/5QsqZ3QWhtZl96ly9iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ivxLTeJMdwaBErkIMwQ7kJuBUP7ccK7B1jti5UgO6c=;
 b=ULgQuDEINScV0C2W+dyR4vvOAHuAQHrDdxCnSt3q8fcmyv79baqHjqj/K4DzUXw36Z3rPo1DTOdaMXWbCQq0PeKWi+wdbVxQJW/cjWDPVL4CiXQUwKognlkCtPrDoyeZ1HGObbyFSrPOprmbuqwJdDj8wYtWcugrzmzP6qiJ4Y8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:55:07 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:55:07 +0000
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
Subject: [PATCH v6 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute tests
Thread-Topic: [PATCH v6 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Index: AQHdPGQ6cOlw5PezVkC0siqDrVZd5w==
Date: Fri, 4 Sep 2026 11:55:07 +0000
Message-ID: <20260904113404.4051341-42-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|AM3PEPF0000A79B:EE_|PAWPR08MB9006:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a8815d9-de36-4ace-e46f-08df0a7b7372
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 a/mDIN9cWqhM4Hv6gVYU2R4zRi4wrmqBZH1Rc2+4u39f5YWYxn2pG+jVc8FMxTbA7DXaUoI8x7dplSGJ2ZC7gXBOB+rTPMqAUl9yIDrO6TLwHqKWVN2SyUIyWTCuU15cwIvsaTZXR5bfHR0Ds1TxSrSQSGWnV58ORF61T4iJfm08xnGk8oHk8+GMwi4GyWqdXguaiYvPr07fMknPcuqRPUYH1IlsNpsfnEFLlQvX6MEYcUm5dABoA6q9fUKPjrh05/IiYkkJ/3QoefZvvpfIPFP0ZAG3cup0NV8DvX78AjlgkTiFHvUqDvv1HKUlBedUR7ns2Qjaw9SJcxBPreMB0HzXj6fxtMQJJMuyMVOj7Jd2Kyt6xXSNx2N0GVH7DUvqm4jhbqNrshgjvL0T89IjqhK8ywHeUqNavRpgowOQRzyjRL31o3PvrJP0EifYFOd06PI7wtNWv5iMjXqfjnbIwlPWJCvRgjQqf3wCgWnLVtF5p4zWFerLqfnrCIH8qlzU/mVwqS24IcfZGqUhC1MhwxWMu0CKEydKSFlTFIFtwUGFWtZps9x5pzVZX7SmgLqUcEYjLeHitnNC00toGDMSM8XSddb5lVEHlr+eEIepv/i00Hv55p+lTFhQE0NLo6ZmR+HC4jtieoKB5QF1Z7+s+n0IuApG21GKF5C+yG4xfvAiiLvLvztC3c5CRB9DD+gyoYkkZbeKNbJha69fAgxGZ6aTdqWDQGnLnq/jes8DBLc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kjkEeOs6Y10Jtg/sH/0bNtFxzTohYiiAYpyLVWdPs294NxgyeHkxPmA3VGbZayn5G2dBMU78fRqv4JqaUXeXfKt32kEQC4GHkGAK/hZ4nxf/lPoqpaNIAI5177K3OFzC64ZSFwW5ifIPs5Wl774lTZIK0MHM1GTYkaIabuCOho3Hpa7TQBvaldst0Hn2of8S8YV39VXfTKIs4yNb9nr1i2YZle4NlbYUQ1OF8la7SC6O48bwx7vrw/D7b6TavHVyd9uRoS2Rf9g5I+w91tMUNlstWUJmgeCv7iJ4A4B3HWP/+sCcFe7SabytQiDZtMCvCE1pcCyHNZGgFFAi/62gAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6f1bbae4-e6fc-4f69-1127-08df0a7b5d63
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|23010399003|36860700016|82310400026|376014|1800799024|35042699022|14060799003|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hzYGRTR97uC187zT7xSvwL7uDXmIjA9027RBZ5WYuVYAJI1niGlWQnIo4izkqg6yjNg3RO850yPCU9jrSia6U6fgblV/3W8jWx5G1V+tNNfj+dj6lmnM0GhB/HZNeDyGce8pWbJFlHVJJEEzLM4thycD6frQzsSjRapLfbgfxiruRGryMybuxqfUcmbU5UWCs3zrdalWNWJbqkssJJA4IgHV0arSBH65WXTAC/CBFuHCzP5d8dLzjVC55MDiYMrl9lAz7knycezfGG49nFU32i3oqXT1SNFjf4Vzsrmgg+s7BrKimPkcLGI4dAvQGVR2ZFLg1CSEYaKd9+ET+cp6kWZdLnWcFej6ruwKO73HrTAH+H4e+GC54lA1W9hiZyOjZw75SvWEpjLpkmmF0fIar1xctDCJjfxUAC88KUFKfsyhaUpLnoBqrT3LrseXelRNssQJtj16WyDhBu9LIGD3KoWXyNGytgmSHdaPBNEU7n6q4U40rWvDzQBXNfb5D8tSO7IWcWHyPhER502UL65iUXVdI/iGgVa1x8FzqGRYcqiwuLrC4nnig1EYSI6hG8QLtmK2WM2VJVNAXZtlqX+SIhOOb16aT4mYeMizmDolf3Iqh8iMgHz5DA969fcNuL2SKZuOdQVitT+HwSQrwhW91c+7vQBMGMgVqfNnII+yCSk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(35042699022)(14060799003)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jcf1m2XQBrqpOR8Pg9uvresJlhvX+6E0APjwzYe3ZJUqBt2UZ/Pm9ezz2TXE7Ar4BW12gKM7XtG/JjrouOS3ciW9QcwbM3tvzA13xtYX8T8iQHY9sUmRgmvyskwQfJge+Y0/Rr97eRW7DuvAlgqNv3HP6pgNkemzaggE3Atdx6l5tXsVKAXB5coOv1ip7/LM1XnWKs6JG9kJ281N8agPtoN4u5ItJjrGzct+SBgB1NQ2GsLcIXIHAdyf0o6wwpzKicJrnWrI484UnI0iuHKnnAFNHItxXniLtudcPOFC33wcPffsol3b7Z+o/SFsn4+SBcXUJTJzWo/hlzmzcVtLNKea4zcP3sZkZWoMbpbXN9w5AL4Nt9lweLFoK2ydy/O96MgZsXu64Si8BpOYldEacAo5WGBRSz2yTKEBH8VcgjxUkPkYHNxMP5s+tnhVwMR7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:55:44.3015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8815d9-de36-4ace-e46f-08df0a7b7372
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9006

Add coverage for the VGICv5 NR_IRQS attribute. VGICv5 exposes a
userspace-selectable SPI count, and KVM must reject values outside its
supported range or values that would change the interrupt layout after
it has been fixed.

Verify that the attribute defaults to zero before initialisation,
rejects too few SPIs, non-32-aligned counts, and a 32-aligned count
beyond the 1024-SPI maximum. Also verify that the maximum count is
accepted and can be initialised, that the selected count is reported,
that initialisation selects the default count, and that subsequent
changes are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 189 +++++++++++++++-----
 1 file changed, 141 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 51ea2fe7141ad..bbcf0b5d2b22e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,8 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(10)
=20
 static u64 max_phys_size;
=20
@@ -27,6 +29,63 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	for (;;)
+		cpu_relax();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -51,7 +110,7 @@ static const struct vgic_region_attr gic_v5_irs_region =
=3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
-static void test_vgic_v5_create(void)
+static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct vm_gic v;
@@ -125,60 +184,91 @@ static void test_vgic_v5_create(void)
 	vm_gic_destroy(&v);
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static void test_vgic_v5_nr_irqs_attrs(void)
 {
-	bool valid;
-	u32 hwirq;
-	u64 ia;
-	static int count;
-
-	/*
-	 * We have pending interrupts. Should never actually enter WFI
-	 * here!
-	 */
-	wfi();
-	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
-
-	ia =3D gicr_insn(CDIA);
-	valid =3D GICV5_GICR_CDIA_VALID(ia);
-
-	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
-
-	if (!valid)
-		return;
-
-	gsb_ack();
-	isb();
-
-	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
-
-	gic_insn(hwirq, CDDI);
-	gic_insn(0, CDEOI);
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u32 nr_irqs;
+	int ret;
=20
-	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
=20
-	if (++count >=3D 2)
-		GUEST_DONE();
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0);
+
+	/* Before userspace sets NR_IRQS, no SPI count has been selected. */
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D 0, "GICv5 NR_IRQS defaults to 0 before=
 init");
+
+	/* Too few SPIs */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS - 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS below minimum");
+
+	/* Not a multiple of 32 */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS + 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS not 32-aligned");
+
+	/* Larger than KVM's supported VGICv5 SPI count */
+	nr_irqs =3D VGIC_V5_MAX_NR_SPIS + 32;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS above maximum");
+
+	/* Valid custom SPI count */
+	nr_irqs =3D VGIC_V5_MAX_NR_SPIS;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret, "GICv5 NR_IRQS accepts valid custom SPI count");
+
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_MAX_NR_SPIS,
+		    "GICv5 NR_IRQS returns SPI count only");
+
+	/* A second successful configuration attempt must be rejected. */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set twice");
+
+	/* The maximum supported count must also initialize successfully. */
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	/* Ask for the next interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
-}
+	vm_gic_destroy(&v);
=20
-static void guest_code(void)
-{
-	local_irq_disable();
+	/* If userspace does not set NR_IRQS, init selects the default. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	gicv5_cpu_enable_interrupts();
-	local_irq_enable();
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_DEFAULT_NR_SPIS,
+		    "GICv5 NR_IRQS defaults to 32 SPIs after init");
=20
-	/* Enable the SW_PPI (3) */
-	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set after init");
=20
-	/* Ask for the first interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
+	vm_gic_destroy(&v);
=20
-	/* Loop forever waiting for interrupts */
-	while (1);
 }
=20
 static void test_vgic_v5_ppis(u32 gic_dev_type)
@@ -294,8 +384,11 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
-	pr_info("Test VGICv5 Creation & Setup\n");
-	test_vgic_v5_create();
+	pr_info("Test VGICv5 address attrs\n");
+	test_vgic_v5_addr_attrs();
+
+	pr_info("Test VGICv5 NR_IRQS attrs\n");
+	test_vgic_v5_nr_irqs_attrs();
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
