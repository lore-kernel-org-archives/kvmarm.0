Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013035.outbound.protection.outlook.com [40.107.162.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498173E8C6F
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935826; cv=fail; b=CzK+9jTK0mAHgp5Z6F5fhONPX6Nlhn9PxKAA9OjCiVLyY8JlYP/telj3ye2oR8wlFrm93PmSia+z+h6LLkMmGe3Cthlty8fUy5BBooicdv5LSBkz0dygA51SNcpcIH5LSU55AVGmT9M7gfAF3qHcSi5JkTgTYvWDC0OdElDNG8g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935826; c=relaxed/simple;
	bh=UH1mKBgaZzvGLKvmrJX8zieDh/pKblUgymKRomaUHn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ufv68nTHPKONjWCpw9gxx+A4shEs9sbflifqB6uHAGTTkt53/KI5HOH53t8GjmAdkoIMiTX41YjIAudfi3vIaqEhRpgxZuEMP4qU8pvuNZzeGPteEnD7koJue433vBMscSu6sLt84ldNb99sgJ7JDB3kIlIqx2IsOiYt0+0ONrw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IYGcmoip; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IYGcmoip; arc=fail smtp.client-ip=40.107.162.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IYGcmoip";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IYGcmoip"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cxZE8nubjWpDfBioKgjoRwCBA+Jkt73oCBu6wOxI+b0Eq1EyWMYcxxWUfr0RjcJVPiB3q3j98b2vSzWXH9yCa7ukbXwNTOxeZpv8xsCqphYSf0en9MjlMr52DMIzkasusngZqZjNhx56kLCKHRQgJFFdy/s0b4v2hIab1cxk89DyzimN0msYaQKFoyFzR/83VX+zZUhRYPtp3kbGcGLs8Aj7BM5IY/VNFQ1QpNwwOsQs1gUA7kAy+hs+kibPLZn1aSO7ZAG2clmdvogGHql1Ip6Apin6CeQbs9B+uZbfngX1z5uLOtfx7XFK+vbzHwkoUpFpF8m2mTMpV5zarvzSDg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=K5+BxH0+cMLNvj4S++VmIbZS2nyVuKoB4GJszmh/tW7SwAKsklx4LX/TyrW4B4e69N6gT2Wr0/FynplU80pBVS73ctjR5Ljz7HXoprxyp4U2P3PghqYXELagN7cl0l6mkxMHIKMRif9WHw49Sk3RAXqoiB1S8Fjzenl93Ln0IyagAQ5fDQt1IKxJ1ZTVqTsKwRrYX1mHRLD2ZkdX+hZEMB4gHMsNkypnBw5hB2xvEKVNV6jtrmXlaV4evnBxiKmkOgdvhYYQPxTHWr1KrU3C5mX/eWwfGSZeTZAYw5NnkMpnvUtpi6Aha+HjYlZSnnWUIo9KStakWbDewGSmDFExlA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=IYGcmoipLszR49qnDHJBsgYocdq0wZ43nBxOCj4V3qExKSDOAUSUJXOVBcnyuFLXh+7Kg6h+cH4NdvbehjtiR6H/a8IXXhCiNOYiCAFeMVrfH1s+eA+McAcGdUX2Xu7qEFX6oUqTo3cbG5EpHmLtB0pDul5G0K+H286NPcDdMzA=
Received: from AS9PR05CA0120.eurprd05.prod.outlook.com (2603:10a6:20b:498::26)
 by PAXPR08MB7352.eurprd08.prod.outlook.com (2603:10a6:102:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:57:00 +0000
Received: from AMS0EPF000001B3.eurprd05.prod.outlook.com
 (2603:10a6:20b:498:cafe::a5) by AS9PR05CA0120.outlook.office365.com
 (2603:10a6:20b:498::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B3.mail.protection.outlook.com (10.167.16.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gR9ZlS1T/qjog+5GZIsfNgICO1yRiCytJGMe8r7sDpRPYDlDYiZFXRRh3ZXjJRrxcv5B7OTryBj+RMrX0gG+zTSek5iSJ6l6ug1oVYOXJ4nxFFOAFTQlKrXziUfj1r7xTyBh+JXQBbmD9I/+djFn/f2Tm18J5e9YQTSpFolC822VNgnOPuOl/W3kphZb5gs1wGN9CRhECpFRIvKFy9NNaHksr06341MAw4JgExVY7sJsJeecbUCCZxKq8wicEALSsA7iSjI586tNC1NZrGsHe0jiWt+JlNBNYsGA6SkntPmRuSNPHN0yHvSJdV7XoKHRgWY2k/ISf8kYa+F+8wo8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=qyAp0qdoPeYYMzTFLrKby81lfq5gS9iw0QWwHNlL+hwkGBoaghsbWkNek9XVUA7cWT0Ef53Iymzw1z658APx97iSrjWQMB7+8vHa0iQNd09yHsj5ml9KkAElNiFBOxwKt8qebxO5bfSB/cmvjGLq+TM3a4n3o7+nNkvCpUAkAKImtDUBwAEBzkYxuvIZXPR60PwR31nCugpjn3dbsXn5jKejUs1PdYfc7wRs8zBEh/CgFc3H1UdxzwXGfEAxOlq/sJH1n0jxPYHiEC3a3v+mndGlhHQHrG5hvYfqw1qFxmEKrRUONbTJuM9rh8Sf5VnDa8TgP9Eow542A2uFlE4zYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=IYGcmoipLszR49qnDHJBsgYocdq0wZ43nBxOCj4V3qExKSDOAUSUJXOVBcnyuFLXh+7Kg6h+cH4NdvbehjtiR6H/a8IXXhCiNOYiCAFeMVrfH1s+eA+McAcGdUX2Xu7qEFX6oUqTo3cbG5EpHmLtB0pDul5G0K+H286NPcDdMzA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:57 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:55:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 24/41] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Topic: [PATCH v7 24/41] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Index: AQHct7jfS4QfnuQZZEyd2ys2aO6eWA==
Date: Thu, 19 Mar 2026 15:55:57 +0000
Message-ID: <20260319154937.3619520-25-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AMS0EPF000001B3:EE_|PAXPR08MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: 5abf9365-a027-4570-3fb1-08de85d02800
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Gtrtq05iCzQWibS+xJbdJEQnZsL9xJ8M+8PvNBOQhTJBbjEz16udXmPQ0LuRV3QvJWDt8LK3WGJi7L9KwvnaUNXTd8Whz2a5s6aT4MDjP0/fXuI49hFjGRVMesGfOXN1t7ZIQ2qPbCryaIpYSL35ScZ+l8M4sYSGOsnrNpaCuR/THnILSCJ6edU4vnBBXSjtkDe8ah6mTKNwyl5I7BmQcC2r5VvawPjcD4AsWiaC8N/7E12IireDDoq3SIm1yus3LaN8HlSfN0UAEDw6n9uVw6xmURLmTUo7vI77B7TPwsELWmH8PBhfnVl6geRNSI0BL765TIcOehW8GWSYhox+tCs5QFA74bHDenFTdbDYufpe83s6kg0RkW3UTBlYLgS8TjCAATzF4VnuNaE1y4HGYr6V21JoMJPKzx5eNQGiHhtP9xLkevZxFwp3fdp+Ej76XrmpzOF987Jp2l9gxejoeWZ/Q2Q45JmY3TgtYjy7E6kJRWJj3eNUe7xAH1zuVzz5WcjgoTrA32ppxZD+RZS45ieDC1H+/MOXdpb/dAf09xcXY7/1b+pVUx50DFqcTDY3EG1Eg23c3DC/NnKJQsKs7QfmgS2v1Mt0QaHm5IKFPKiigTYIHP3YkXMxhAD+yS9WIsT9UlbIFB8QPSC0YNjb3xGfN+a0XqVxe5ih8zGiQmqENDG96GI1r9/oipVGpkGv2+xPKuLvmuT5E1/5wcfPeoBLCVv3LPsIJf66tl4x6FWavShvTx5pqQQ7YPg123pHmTt2nH43DD/QuMgGI7Gwgc6EWl8WTJPXQ2rAhI/ZoaU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gJmS4K1lzh6H+6K+iC0gUc2/8IDWZEpjD0dbC3qY22caTpm6rT4fTfiLmYy5wwJNh5zYfnPrcHCcGv+z0Qk/9X3r+jEODmeju/Hg8sllyfbv4oF4qMT3hp9mYKx3QHFYyGzj5tvSdg/Fd7hQGiGWuZS+IofDprBwy2ViXiWSPFj7tnZfNwmmqqWFClh/Mz1PRpNlYaF94xGU59aliqRTxTnLt7V6ikIXHCz32Hwv9vMWIVe8ZLZDMz70MFO0o6SvhZJ1kB7dkbHMHc551p9OClRmvnfG1KeNQ5So+8LdnLPzuCJAV1YbBh3ofoasSLAtUNXoizlBdVGnHxwRGW1rug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7cc2dccd-77e0-49fe-f0a9-08de85d00263
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	njA72bXNV8oYp+z4wzMBlpa73ihneByxwy4j+aSm0+CXaglq7H2w5CWwqeownAjTyS+PQ50qLZs/GMx7swKlfwgtCEyg/wbmNdU47uxyAzyncjGblrH+F8JVNOQAMC2uWEAjkoocfZwDqCb/S++OloQcuhBRjBTAuTIThFprlFtO9iJaehSc9bHL9w9/v5pAYOAm5eaPdqq0u8tndMdesGUmo/CL7LTGfJz7Nv/Q5Yk+WjBuhyqB19hAzYK9e2lb53Dtlo3Vvu0usZd613PFSPBZIRCpPNZ7C1jqGKxdWEJPWAnEeLNoHU77qmsMQPIEhT8YvYFWyk3hwrh8x5AupJZd9YvWNSG+MD32CFSV/nveBoeB02nJL18esMAMZrODZXin23ylp/XZnJTkZcxRd5wZS77MZJRkqZdmK9/amMJmMjtJ/bQoCkPa+UlxoBA2E+CruDaYQYX3uwnRwmaSFNhHqWvCHfzg2LTTtpvdvledH3nu6vKM+zKyT7Yl7eagBJ0fixm0/jBAe9v3fu9n8tZkCXbWLZGl/t3DUcAoXPQZCltLECvNgmeB0GCJE7Arkgf7NLiBu3EvJLuJJHHp9F4uUMqRnGJuni9rqTBQs8mwj4NMJeB6wXoUfvsfwFAd7GLmqTQGF1T50QeThz5ZSnFSbXQs4PI239Ve1q70iG/XW5H4V7Rz+uxkgwxi/VO4Dgld8cV8PCQ3vtoz2pho+bdlpZfR0Z2D/chPlEXlfqN8VwmwCgRWYEZNgmGxea3UVE7zKNoZAZ5YMgHJW/Xgrw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f1pY1lxJ/n7Twb84q9RuJPe8nzks4Hk84ZGnDm4HoxXfQExQOstTI6yIxr7dEQhHBBwCHMz+aj7hw2vMw3fmulVyxfv4IP3IZ8wZkHMgIXEOV7cyVURTHYDiPXCpMqGS8h9L1Sljy3fMdGISc/jZgmmwRXfJy3UXG/0hctPmEVhtLI16o4TzSrwiuNLiOZ3/qsN47sMIcxp0ed2pGJE6fDw9atg5a94O8sEWlaOHWJJ7prBW9tXBL9YyFlr46uidlhTLztgsk6efSBeCPYRNxAI54NzXERX8Ukkdq9uErp4D3gzbu232/Uxwp/BMQsvMv8EQj0mS0RFKQhduA+XkIuWOv95F6iBhbcaJhRohLBYIfIj62ry+mP/uB58+XW3UdxW/RJ4SKwCxvvruS7T9BAEXqwGUnGYt+obJwNo46fnzkC7ow/Uy2eFei2XvqWEs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:57:00.2890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abf9365-a027-4570-3fb1-08de85d02800
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7352

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. Avoid the guest enabling any PPIs
that are not implemented as far as the guest is concerned by trapping
and masking writes to the two ICC_PPI_ENABLERx_EL1 registers.

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state. As there is now no way for the guest to change
the PPI enable state without it being trapped, saving of the PPI
Enable state is dropped from guest exit.

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
masked version of what the guest last wrote.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/config.c           | 13 +++++++-
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  4 ---
 arch/arm64/kvm/sys_regs.c         | 50 +++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index c4a172b702063..a7dc0aac3b934 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -814,7 +814,6 @@ struct kvm_host_data {
=20
 		/* The saved state of the regs when leaving the guest */
 		DECLARE_BITMAP(activer_exit, VGIC_V5_NR_PRIVATE_IRQS);
-		DECLARE_BITMAP(enabler_exit, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_state;
 };
=20
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 5663f25905e83..e14685343191b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1699,6 +1699,17 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1);
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1721,7 +1732,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
 		__compute_ich_hfgrtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_ich_hfgwtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f34ea219cc4e9..2c4304ffa9f33 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -37,8 +37,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
=20
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
-	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
-		     read_sysreg_s(SYS_ICH_PPI_ENABLER0_EL2), 0, 64);
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
 		     read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2), 0, 64);
=20
@@ -54,8 +52,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128) {
 		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
-		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
-			     read_sysreg_s(SYS_ICH_PPI_ENABLER1_EL2), 64, 64);
 		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
 			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85300e76bbe46..e1001544d4f40 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -718,6 +718,54 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	unsigned long *mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * If we're only handling architected PPIs and the guest writes to the
+	 * enable for the non-architected PPIs, we just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them in
+	 * this case.
+	 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && p->Op2 % 2)
+		return true;
+
+	/*
+	 * Merge the raw guest write into out bitmap at an offset of either 0 or
+	 * 64, then and it with our PPI mask.
+	 */
+	bitmap_write(cpu_if->vgic_ppi_enabler, p->regval, 64 * (p->Op2 % 2), 64);
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler, mask,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * Sync the change in enable states to the vgic_irqs. We consider all
+	 * PPIs as we don't expose many to the guest.
+	 */
+	for_each_set_bit(i, mask, VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3444,6 +3492,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1
