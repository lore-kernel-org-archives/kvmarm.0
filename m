Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013060.outbound.protection.outlook.com [52.101.72.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC294413236
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774971918; cv=fail; b=aLqYSZ2xNof+u+14vfS2qV1Rfdw2t3+TdQAz6WXsETLLNN8WnOYus3QaZRn2af+B6nGT/Q9+It5nSucE1Tu+7BCBwm+K5nPCcOf8vlqScOzw6SczPPVTRccrM7OWodp2NrTEamK+2Dw6lI83Cx7OURZd2Ey73imW0yucJHPvNco=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774971918; c=relaxed/simple;
	bh=pLZPwmvE9MOGIoUrR4CVd9SCDGJQoGJo8VJdvRj5uJk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RKsplDtFOaU4Uk9ZQAe0rXbecWRvDxLycOolHNX91Pn9+shGsHJLm8V6LknL+DCdtrLvmmoq5RvYq6RY1YQLPHSzeCjO4EX+Y/yTGgQ8/B6Oz72DBjQgwywtU3fcaW+4RFG4KCJsNXwIBLkWrIVVnfhMkaXb4ulguT5X0oW3NkI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oQU2xIJn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oQU2xIJn; arc=fail smtp.client-ip=52.101.72.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oQU2xIJn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oQU2xIJn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=a03v93TbHsDqLYE++vYHiMLSHDBAq+fK0Q2sOodQszyLoQktqdhjKOhBJT0/uhHhbqjIa5xXuoE+6zk/etFGH704dYULr91ZR7500vBuhRZaPDh0DA3Y/tI7kkmCJR9ZfS0zxydY9zEqoVZMsrrvrvjqACv9bxi8rDkbTruiBsEunvKk0bgsPOI2qoxreAK9LpTTcEjJBQ0xyMvnbbvFVbUFV815o0MytfPg4OW42C3XG8BTkYDGKOd+QOcJlXbTnbkZ07ocKl4tJ81CweDitrC1ZAIXo24/wK+g34bX287R7TNsPJMmJck3qTfRmMGHBXSNLxFdBP6i5y920q4hqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLZPwmvE9MOGIoUrR4CVd9SCDGJQoGJo8VJdvRj5uJk=;
 b=GDA8wsAZQwyuKW/tP5eUE0ao+90SPXwG7woaLJuTfNyQeS8qZfI88EnI0L2z8VLBICLYljO6yGB2IKN7F4G7GIKE1SxNtYzxGW6HjZ7mZHy+AEwzUPePmIDfNoCwb/ZuaR03yqoT2/baJiaT/bFPoEa5Oor2KpJmo8pFedGzt8yBpkqckrsCUisHbPv8jeC6MimSchyZykyH3U75nOM1+2rl7vndWiUsyBTg0e8a8BuOTHckTEFWYh2dKNKWzUoRIqBZIkja44lgpxTMF4TXPVsl71dEMf1YtnE9BVIXRxUQ16jQ/3xlTANm+uodqW4nh7XU0EPr15+GwS2fZRJVGg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLZPwmvE9MOGIoUrR4CVd9SCDGJQoGJo8VJdvRj5uJk=;
 b=oQU2xIJnk5oNVCnd9PV+X1zia7B70TYaODwJaj5UWDejoKImj81aSQx7OUmMs35R0aQL6WJDgGQfEDs85ljfcp1v0YAKMCxIys2QdAzJQVoLnY8p2f9Uk+r4Q2db/Z8RKLHg9JIWp5o1qmXRoID/HLW+V+TF4SRDe398JSo/gJE=
Received: from AS4P192CA0023.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::9)
 by DU0PR08MB9464.eurprd08.prod.outlook.com (2603:10a6:10:42c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:45:07 +0000
Received: from AM4PEPF00025F98.EURPRD83.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::71) by AS4P192CA0023.outlook.office365.com
 (2603:10a6:20b:5e1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 15:45:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F98.mail.protection.outlook.com (10.167.16.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.0 via
 Frontend Transport; Tue, 31 Mar 2026 15:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISUlyU7Ijso09/qlFSK6m/AME0p6HxQJZld0QYfoTCFFqRk3W/0c0ZQWlqrKposthsKSCuGQeWsJ9o2SoVCdYjLKiv/P1MvPyg2bGUICDIZW3sbyAiXMIL9Q4SqCdob8DfeU7FfHc+Z38Yy9GJ12kIpLAnK+/NdN9pHnDvHss3fCawZx9TknWQUe4vDu++scpV4K2mW8TJMuIC/AvE95WJu1p3uTbNoA9VNbh9dxEBDFwldmwN7NICzgHOV+hox7zTOF1VSkL+omVtyMfdcacVyeDfKGpnrKmPIloWNytk8UcLbwCmo7rbwMgHodWSOLJ5xFCw8bHr92FE5U6FtS2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLZPwmvE9MOGIoUrR4CVd9SCDGJQoGJo8VJdvRj5uJk=;
 b=f4sDvRgrMZR21TPWr2ugpADGx/p+ExRDHNkjHrdQI+4NHXh4Uq04NRLRjtp/zaKBJg9hMHY1TMrh8cJymYq5f62tcX82zZSw4t8ykMEXu3WvIG+3LOeKL6RykFKc96L1w7xg7vBL7qqD2Bp0eZOLCQ+uvQgCJkL3/zzSeyOj27t6y/PRT+JIGSrOGDyr7v1C2BVAD9ST+spHsCRXuFSfnHYYDA2uefOQnXKi0CbCxj9nJEKvZKqshHdtaGnqmlZC9+cCZp+7ZedoZJzRL0B3ZS4mvsboXEnAU4ollaCzaIhtgZ9Lkvdb5o3frFs5MCaOcg4plrbyK+1VUaDbMkOIqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLZPwmvE9MOGIoUrR4CVd9SCDGJQoGJo8VJdvRj5uJk=;
 b=oQU2xIJnk5oNVCnd9PV+X1zia7B70TYaODwJaj5UWDejoKImj81aSQx7OUmMs35R0aQL6WJDgGQfEDs85ljfcp1v0YAKMCxIys2QdAzJQVoLnY8p2f9Uk+r4Q2db/Z8RKLHg9JIWp5o1qmXRoID/HLW+V+TF4SRDe398JSo/gJE=
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com (2603:10a6:150:3f::12)
 by DU4PR08MB11719.eurprd08.prod.outlook.com (2603:10a6:10:645::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:44:05 +0000
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182]) by GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 15:44:04 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH 12/15] KVM: arm64: Remove evaluation of timer state in
 kvm_cpu_has_pending_timer()
Thread-Topic: [PATCH 12/15] KVM: arm64: Remove evaluation of timer state in
 kvm_cpu_has_pending_timer()
Thread-Index: AQHcvTY2WDg7wXCK502ordwnLxCEDrXIz/mA
Date: Tue, 31 Mar 2026 15:44:04 +0000
Message-ID: <2779510cb9795d1c934d2122478485847930358a.camel@arm.com>
References: <20260326153530.3981879-1-maz@kernel.org>
	 <20260326153530.3981879-13-maz@kernel.org>
In-Reply-To: <20260326153530.3981879-13-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GVXPR08MB8233:EE_|DU4PR08MB11719:EE_|AM4PEPF00025F98:EE_|DU0PR08MB9464:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a5ab41c-0f0f-4a8e-8f04-08de8f3c7c0e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 /JFspQr3GiaOTg904MJl9Ipdn/fmt0hout/rnR2c8jI6gPUH/ChZ+Y9zcFoHygpNnBT7g7lxRRoeoJzX0igpAohnscp5jIsnIbNYENjzbeSYIT63Cvu3m8Jch5G8+M84hUBkJ+L4zDql0vdXqiqHb2ucOElcSvz9WK2gNCz6OzusLzOzVEiiFmbkXgybC0oYfQlKxtzJci+cDEmFCpAxwStQVsDUDTSAXoPvd+lBtawrt2oHwarDRLoz85bM9+BoCmIF8Vn44bV8x79AGj0OJ8nPzcXKpRsN1azBouFb1A6eFayTqlwDioD7QMcev6MtQlsBI22Hc420CtHzi37uEquGdBsjYYLZd6Z2uBTRpqQBGUv2Sh3JjS2TP3OAQc7rKK0NsEIg4SQqPZ+B0IY+9Lq9tW0QqkrhAz1wLuP6liMo0joUQrCr/WTTKysvQOn4KL0TLll1F46CldhFqzoBpU9Ey4oqUJgjWhybx5tbhmOJVCLcImeSdcGMD/WIhgoFDtz0hG1bRFfU0soMTtf8NB5TH0fphd1G0nbohC0LKwbFbBzXnLJyWvP6dyVqGs+zrG5ZXCrg+1MXEMHd6ee1junYW1axVfzOPNicjtCGRCKWkr6nujTiB8VahjI/6qLv4Z4rb3dnV3FR9/QVvNi5W4ZHu/yFtcfMWt+KJmj9AdLPJs3nl7K3Sedcfb9f4nrRnFeXdgMc5YMDdxNRhou7HdTfQ8/xETa4+V6TmAW4ylc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB8233.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <98C7CA9122AAC749B8A71DE07983E698@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 lU2q7lk9C2gAP5+2rVHeIy60Ks0dSbXb9EdlwM8Znt/kM1cX8hy6CbZeWM9TUJnLfUINjI9fUNudiCIs84adI9GUWLH0IDWN59X/5k6AGmeKKwx+FBnUeqJ1LEQr2W7otTVYVyiJHkoObHZTAsqEGPA2IbKxYaCz1AczeMlrWFz8OwH0OtDGbQx+fo0GdkiVlEFXN9c6EFrnqMm7OIgfVGxpNSVstu3WSghFS8b6PHnxeJ1UF4FwKdJ2HFD4y2lzeYzvdIq6TrxiziukBE0DCWKHGevZANRV6WK3JtWKxMuoqlakLfSB/nov+6CP/QLfxsIFZrWiPeiwW8D8FD6csg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11719
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9a8d5bd6-d42c-415e-c5ac-08de8f3c565f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|35042699022|376014|1800799024|82310400026|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X3IH0n8lx/og0uWcrZGx+w0ofTJ5HdqvXYxwaUWILu7dBbAvdDXz8H6KmkpIq/Vuo27symfCRVHoLhkzZ7iegkPD3hgiJ2dw4R5WOJgK8giEX22KhQpgdsFLCmsxi68qGRkAgA2Oim+FwtmCC5RTMx73cRT5P4a2KXtl4KCvi/LX8DEFtOw3NomCjl1FA8tyZ+hRdyd4om6s/oekHqgzY1IhVmSoJYExhMJ2R7WsbN+JMomyPo2AsXGzP/uEr9+eJIVNqfaCaGWrmh06mj4ntz4/9vyhRiYw9tAhthsYSjiwypReq+rRm0Scz+uTxxCxI6M72Hz5j3EEAZCJ+yrbBIKAu5z0E/Hfq/MVdthgLeYs9HtlueHbBWz4YK3w7ijHemwaGth4/O7gScDxeeQIYJrLGsp/oFaHrBcgpg1eN2yeiBJYWhvWKrHq7XLNQrj3FgIN0cjJtLCixOpB+l1QosPs6rbupn1O3NG5yp1Xf9u+yCK3TooIzh8zu6n8GyToaVwa/oH+U60nvrhl7HzBQnJ1fYEq3ssP2XKNjf+7PVo9aNEqc0d23aab3ftomBzzH4Y0bUdj5zb44xCE3t3Uoi6WWM9dhBv6l4VFeqzUNr6V6LzFLU5jxUr2fbEr76BhCDNqmjmsRwBseUoS4tFCFsI2yvTJyniFToMMesUUs3XZOijw1hfYHO5qUW1YtGuy8UtsV5KhdaGroh7/i5e4pA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(35042699022)(376014)(1800799024)(82310400026)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jTYR7fVJRBm52K8y6Tsyau2x8oyXpk2NeoTL+BOGJwbET8wQFx+OUmSSaOQJfCmz5vJdZxvDLeYsQEUk9nC8I5lg1Zm4u+takd8LMkVC0REZBYymzYo59Y1zlrN6/MZtw8SGItdgZPD6gecqknh2SoDpvwVAQNUuVXQlFUgdWnzZA86t7k6DtaNQRNrJM5hVYI7pYkAetPKEzAyqwbzDjRh+8249Csu7VQ15ERViTvI96qRjKjz/04warbKcy4cEPb+rdlYVV/LY3WOxV4Od4MWCFuNyOKOPpiE9y/FbypJZxVt2KmqKsL+eB6PLQCUYJbGS4qDmWj28gqs8uhuaa7t8Vs33T2kdTcSuqRvuJyhrLSfGhevSc8icXvdrjsPAB/ubdIKxGQBVoZ+16VjSn7w0k7WiKT9IE/sJsNa2A/OcvzyqY11wEHZ7CRc419iK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 15:45:07.4254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5ab41c-0f0f-4a8e-8f04-08de8f3c7c0e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9464

T24gVGh1LCAyMDI2LTAzLTI2IGF0IDE1OjM1ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IFRoZSB2Z2ljLXY1IGNvZGUgYWRkZWQgc29tZSBldmFsdWF0aW9ucyBvZiB0aGUgdGltZXJzIGlu
IGEgaGVscGVyDQo+IGZ1bnRpb24NCj4gKGt2bV9jcHVfaGFzX3BlbmRpbmdfdGltZXIoKSkgdGhh
dCBpcyBjYWxsZWQgdG8gZGV0ZXJtaW5lIHdoZXRoZXINCj4gdGhlIHZjcHUgY2FuIHdha2UtdXAu
DQo+IA0KPiBCdXQgbG9va2luZyBhdCB0aGUgdGltZXIgdGhlcmUgaXMgd3Jvbmc6DQo+IA0KPiAt
IHdlIHdhbnQgdG8gc2VlIHRpbWVycyB0aGF0IGFyZSBzaWduYWxsaW5nIGFuIGludGVycnVwdCB0
byB0aGUNCj4gwqAgdmNwdSwgYW5kIG5vdCBqdXN0IHRoYXQgaGF2ZSBhIHBlbmRpbmcgaW50ZXJy
dXB0DQo+IA0KPiAtIHdlIGFscmVhZHkgaGF2ZSBrdm1fYXJjaF92Y3B1X3J1bm5hYmxlKCkgdGhh
dCBldmFsdWF0ZXMgdGhlDQo+IMKgIHN0YXRlIG9mIGludGVycnVwdHMNCj4gDQo+IC0ga3ZtX2Nw
dV9oYXNfcGVuZGluZ190aW1lcigpIHJlYWxseSBpcyBhYm91dCBXRklULCBhcyB0aGUgdGltZW91
dA0KPiDCoCBkb2VzIG5vdCBnZW5lcmF0ZSBhbiBpbnRlcnJ1cHQsIGFuZCBpcyB0aGVyZWZvcmUg
ZGlzdGluY3QgZnJvbQ0KPiDCoCB0aGUgcG9pbnQgYWJvdmUNCj4gDQo+IEFzIGEgY29uc2VxdWVu
Y2UsIHJldmVydCB0aGVzZSBjaGFuZ2VzLg0KPiANCj4gRml4ZXM6IDk0OTFjNjNiNmNkN2IgKCJL
Vk06IGFybTY0OiBnaWMtdjU6IEVubGlnaHRlbiBhcmNoIHRpbWVyIGZvcg0KPiBHSUN2NSIpDQo+
IExpbms6DQo+IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDMxOTE1NDkzNy4z
NjE5NTIwLTEtc2FzY2hhLmJpc2Nob2ZmJTQwYXJtLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJj
IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiAtLS0NCj4gwqBhcmNoL2FybTY0L2t2bS9hcmNo
X3RpbWVyLmMgfCA2ICstLS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcmNoX3Rp
bWVyLmMNCj4gYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gaW5kZXggMzcyNzlmODc0
ODY5NS4uNjYwOGM0N2QxZjYyOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJjaF90
aW1lci5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiBAQCAtNDAyLDEx
ICs0MDIsNyBAQCBzdGF0aWMgYm9vbCBrdm1fdGltZXJfc2hvdWxkX2ZpcmUoc3RydWN0DQo+IGFy
Y2hfdGltZXJfY29udGV4dCAqdGltZXJfY3R4KQ0KPiDCoA0KPiDCoGludCBrdm1fY3B1X2hhc19w
ZW5kaW5nX3RpbWVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gwqB7DQo+IC0Jc3RydWN0IGFy
Y2hfdGltZXJfY29udGV4dCAqdnRpbWVyID0gdmNwdV92dGltZXIodmNwdSk7DQo+IC0Jc3RydWN0
IGFyY2hfdGltZXJfY29udGV4dCAqcHRpbWVyID0gdmNwdV9wdGltZXIodmNwdSk7DQo+IC0NCj4g
LQlyZXR1cm4ga3ZtX3RpbWVyX3Nob3VsZF9maXJlKHZ0aW1lcikgfHwNCj4ga3ZtX3RpbWVyX3No
b3VsZF9maXJlKHB0aW1lcikgfHwNCj4gLQnCoMKgwqDCoMKgwqAgKHZjcHVfaGFzX3dmaXRfYWN0
aXZlKHZjcHUpICYmIHdmaXRfZGVsYXlfbnModmNwdSkgPT0NCj4gMCk7DQo+ICsJcmV0dXJuIHZj
cHVfaGFzX3dmaXRfYWN0aXZlKHZjcHUpICYmIHdmaXRfZGVsYXlfbnModmNwdSkgPT0NCj4gMDsN
Cj4gwqB9DQo+IMKgDQo+IMKgLyoNCg0KSGkgTWFyYywNCg0KSXQgYXBwZWFycyB0aGF0IEknZCBt
aXN1bmRlcnN0b29kIHRoZSBpbnRlbnQgb2YgdGhpcyBmdW5jdGlvbiB3aGVuIEkNCm9yaWdpbmFs
bHkgd3JvdGUgdGhpcyBiaXQgY29kZS4gVGhhdCBpczogSSBhZ3JlZSB0aGF0IHRoZXNlIGNoZWNr
cw0Kc2hvdWxkbid0IGJlIGhlcmUuDQoNCkhvd2V2ZXIsIHNhaWQgY2hlY2tzIGFyZSBuZWVkZWQg
c29tZXdoZXJlLiBXaXRoIEdJQ3Y1LCB3ZSBkaXJlY3RseQ0KaW5qZWN0IHRoZSB0aW1lciBzdGF0
ZSAod2hlbiBwb3NzaWJsZSwgYXQgbGVhc3QpIHdoaWNoIG1lYW5zIHRoYXQgd2UNCm5ldmVyIHNl
ZSB0aGUgdGltZXIgaW50ZXJydXB0IGZpcmluZyBvbiB0aGUgaG9zdCwgYW5kIGRvbid0IHRyYWNr
IGlmIGl0DQppcyBwZW5kaW5nIG9yIG5vdCBpbiBzdHJ1Y3QgdmdpY19pcnEgYXMgdGhlIHBlbmRp
bmcgc3RhdGUgaXMgZHJpdmVuIGJ5DQp0aGUgaGFyZHdhcmUgaXRzZWxmLiBUaGUgcmVzdWx0IG9m
IHRoaXMgaXMgdGhhdCB3ZSBleHBsaWNpdGx5IG5lZWQgdG8NCmNoZWNrIGlmIHRoZSB0aW1lciBp
bnRlcnJ1cHQgd291bGQgYmUgcGVuZGluZyBpZiB0aGUgZ3Vlc3Qgd2VyZSBydW5uaW5nDQpzb21l
d2hlcmUuDQoNCkkndmUgcnVuIHdpdGggdGhpcyBjb21wbGV0ZSBzZXJpZXMgYW5kIGhhdmUgdGVz
dGVkIHRoZSBmb2xsb3dpbmcNCmNoYW5nZS4gSXQgaXMgc3VmZmljaWVudCB0byBjYXRjaCB0aGlz
IGNhc2UsIGFuZCBkb2VzIGl0IGFzIHBhcnQgb2YNCmNoZWNraW5nIGlmIHRoZXJlIGFyZSBwZW5k
aW5nIGludGVycnVwdHMsIGkuZS4sIGEgbW9yZSBhcHByb3ByaWF0ZQ0KcGxhY2UgY2FsbGVkIHZp
YSBrdm1fYXJjaF92Y3B1X3J1bm5hYmxlKCkuIEl0IGlzIHlldC1hbm90aGVyIEdJQ3Y1DQpzcGVj
aWFsIGNhc2UsIGhvd2V2ZXIuIEknZCBsb3ZlIHRvIGhlYXIgeW91ciB0aG91Z2h0cy4NCg0KZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYyBiL2FyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuYw0KaW5kZXggY2JlYTRkOWVlOTU1Mi4uZjhiOTU3MjE4NTdjMyAxMDA2NDQNCi0t
LSBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KKysrIGIvYXJjaC9hcm02NC9rdm0vYXJj
aF90aW1lci5jDQpAQCAtNDAwLDYgKzQwMCwxNCBAQCBzdGF0aWMgYm9vbCBrdm1fdGltZXJfc2hv
dWxkX2ZpcmUoc3RydWN0IGFyY2hfdGltZXJfY29udGV4dCAqdGltZXJfY3R4KQ0KICAgICAgICBy
ZXR1cm4gY3ZhbCA8PSBub3c7DQogfQ0KIA0KK2ludCBrdm1fY3B1X3RpbWVyX3Nob3VsZF9maXJl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCit7DQorICAgICAgIHN0cnVjdCBhcmNoX3RpbWVyX2Nv
bnRleHQgKnZ0aW1lciA9IHZjcHVfdnRpbWVyKHZjcHUpOw0KKyAgICAgICBzdHJ1Y3QgYXJjaF90
aW1lcl9jb250ZXh0ICpwdGltZXIgPSB2Y3B1X3B0aW1lcih2Y3B1KTsNCisNCisgICAgICAgcmV0
dXJuIGt2bV90aW1lcl9zaG91bGRfZmlyZSh2dGltZXIpIHx8IGt2bV90aW1lcl9zaG91bGRfZmly
ZShwdGltZXIpOw0KK30NCisNCiBpbnQga3ZtX2NwdV9oYXNfcGVuZGluZ190aW1lcihzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQogew0KICAgICAgICByZXR1cm4gdmNwdV9oYXNfd2ZpdF9hY3RpdmUo
dmNwdSkgJiYgd2ZpdF9kZWxheV9ucyh2Y3B1KSA9PSAwOw0KZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCmluZGV4IDc2
ODBjZWQ5MmY3MTUuLmZmYjkxZjUzNWVmZTggMTAwNjQ0DQotLS0gYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMuYw0KKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCkBAIC0xMjM4LDYg
KzEyMzgsOSBAQCBpbnQga3ZtX3ZnaWNfdmNwdV9wZW5kaW5nX2lycShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpDQogICAgICAgICAgICAgICAgaWYgKFJFQURfT05DRSh2Y3B1LT5hcmNoLnZnaWNfY3B1
LnZnaWNfdjUuZ2ljdjVfdnBlLmRiX2ZpcmVkKSkNCiAgICAgICAgICAgICAgICAgICAgICAgIHJl
dHVybiB0cnVlOw0KIA0KKyAgICAgICAgICAgICAgIGlmIChrdm1fY3B1X3RpbWVyX3Nob3VsZF9m
aXJlKHZjcHUpKQ0KKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQorDQogICAg
ICAgICAgICAgICAgcmV0dXJuIHZnaWNfdjVfaGFzX3BlbmRpbmdfcHBpKHZjcHUpOw0KICAgICAg
ICB9DQogDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3Zt
L2FybV92Z2ljLmgNCmluZGV4IGYwZTU2YWQzNmJmMWYuLjFiZDZmMjM5Nzk4MzcgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQorKysgYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5o
DQpAQCAtODI1LDYgKzgyNSw3IEBAIGludCBrdm1fdmdpY19nZXRfbWFwKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgdW5zaWduZWQgaW50IHZpbnRpZCk7DQogYm9vbCBrdm1fdmdpY19tYXBfaXNfYWN0
aXZlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgaW50IHZpbnRpZCk7DQogDQogaW50
IGt2bV92Z2ljX3ZjcHVfcGVuZGluZ19pcnEoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCitpbnQg
a3ZtX2NwdV90aW1lcl9zaG91bGRfZmlyZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KIA0KIHZv
aWQga3ZtX3ZnaWNfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KIHZvaWQga3ZtX3ZnaWNf
cHV0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQoNCg0K
