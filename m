Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010042.outbound.protection.outlook.com [52.101.69.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36D834CFAB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306362; cv=fail; b=RlYO3kA7L6EbFmit0Ys55nKc0+l29ss/nXTIItYhUpqJifird1ddFZb9j5O1hWTd63lk/FN/VmNKE/1yVyd81Uj5xHhuKIseRlElzsDLNjEMkI+1iEOjQWl5OqGRaIIeySNBe7nN1o5rFnJbA7jst2aW37lWBuPGBJ1r4MOqOzY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306362; c=relaxed/simple;
	bh=TJC2lQ99l2A9glYge6BUliQbchRAvKbcnd9nb6zy02Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qayo7rIL0tBLeTfyteTM9XXbvX6tIQ+pIRh4H5jZhHHzdm7XppphHjmkUnO77nRRwPLcwk8SYOUhiGeL1zYVtNyj+kaWuDpGxJ5kvWJzBt8iTQq6Lr7mt7m8EIoilkWR38HQitMvr6C96Zz8ocOmH3xfIG9i1Isbakd9OxDyUe4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fJfLEb67; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fJfLEb67; arc=fail smtp.client-ip=52.101.69.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fJfLEb67";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fJfLEb67"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sQ59bOqhq53LKxXRJBFJ/nGWwq7Xg3VROpvqjkNuBi/UdQ6BYkY9bh3Q46xaOXS82gv4eMdeqm46rstOcdVWh4nJKp/zDjvdJ5cD+7jrjRhGHu3OnZIhdN1NgF7AGk+fCZVFjNHwVj91sLBmrWhhgUXt7jnNSL6qetg2KpqeAcmAhSU5rV4huRCdu61P58UMaqCxb1nBrGn4g93pHxXCrYX8yMkVywTbxScV8+OhvhtFCnsZ74JyXIh1VG4IrrKUoy2JeQ3xJPXGdoMFqDc0VHLTtG8bFOhmk46xdKYo5MvbDqMc+BqIJBZ2Ab6J9ZTAMMIDsmC7qAemgc0mQ8R+fg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEzk5/ftOjP9t5FUtZXb7ocNcJTG+bqI8vlQ6/paoMo=;
 b=aiU+1zqcN0pSd4+ZxDVr/ZePFSDfVlTCo2e+KIzr2AbHVT+v/tRnzu7T+cm4h6nYwxr9hHkJ4AegZEkuoQHpZmwKS6eB0WBCVe3l9ykA7fkc9uly2TlAFdkKVL0mVrpDYUhqPDJzYKxt8OUs4reYEsGbKjVS39PX85Cs98bRJQ8zBfHeYJTyVTvtPWGAtukh8KHyWm+VuWr9g2hAg/m//uUbanTMxHa96mtCU9sK1/kMVMBcw3DYquAB7lVfsjDhfMEIYGzbG/Fv8NagETp1XXHVQqS1mfCs/peL5USEViPKaXJxKC/cN5zphwYSkbxbX7nzcAjXM82Ht3Ppms7Z9g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEzk5/ftOjP9t5FUtZXb7ocNcJTG+bqI8vlQ6/paoMo=;
 b=fJfLEb672tO0cE82NZ7FczaB3LOs4FBEDqFAi2CsaVUfRBzpINkHe1i58BFMMD6VNKghkJwgMIE8MvzhHHRKVJ6xPMKqQoT+iQIvZoxAeF7fmf6BswQ7NSfl4piEn15M/miSMDykI3L0CP66lScbuYIAu1jNKlnO3N++D/fAGZY=
Received: from DUZP191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::22)
 by AM9PR08MB5972.eurprd08.prod.outlook.com (2603:10a6:20b:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:33 +0000
Received: from DB5PEPF00014B92.eurprd02.prod.outlook.com
 (2603:10a6:10:4f9:cafe::91) by DUZP191CA0003.outlook.office365.com
 (2603:10a6:10:4f9::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:12:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B92.mail.protection.outlook.com (10.167.8.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JR/HFpDADDfDXTZ/5fAbi01fOL35sV0XKlOL6MUZqVUz8u8+sPBdOy9x09DxNQ3be05ckUIz2djpkk3MWfXEBlTrdmx+ngE7iPEj7JO1VUfv8NBAcpVXcO91GzJrxrWCHEy5OGsM3XkZuZShsuzslKWeGIiHBJ1qY34rGKwvY41lDep7po/WJ//s8ffX6qnT9PcGmINiG59f695j7BxJczxN9grdGJ0mOARpOtrfJWLiu0JUVlW1oWmnf36GsqJlNM2QPZLdGojhnUlVT+0MvuPeB5+qljJ+Rzkx63hlk2cAmdkHM9lZpG/eKmL4CFHIyecC03XdhCz8r2G8Z3t3mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEzk5/ftOjP9t5FUtZXb7ocNcJTG+bqI8vlQ6/paoMo=;
 b=bCKvB6owKKNLUDEhCfYGfeqOBM6unu62XVcyeAkaCi/YEUbSSl3nh90bV4rnttDBeOjj3Q512eKwXmxelvZEZMqBXVqH60htGoRZNuB8FX6R4XsMAcDdPah78hABjJam914vrLC2uFIrnLf/7aT42fmpWQlIyoCh3279F8gUjEeNhZfrZO8UaNsFWalFNlKPsjHRtfAt/KfdX5eJwXv7kJuI0oxHvBnbRz0F1M9LXwdAcJji3fjQ44YnSHoUu+Ko4roOqQjxP4nlylLHL7d7zHbgcd62cofL2Y5o8mGlLb3J0GM0UBowfTD8bkikO/1kAFf1KO9dKAcg7f8fgaMiKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEzk5/ftOjP9t5FUtZXb7ocNcJTG+bqI8vlQ6/paoMo=;
 b=fJfLEb672tO0cE82NZ7FczaB3LOs4FBEDqFAi2CsaVUfRBzpINkHe1i58BFMMD6VNKghkJwgMIE8MvzhHHRKVJ6xPMKqQoT+iQIvZoxAeF7fmf6BswQ7NSfl4piEn15M/miSMDykI3L0CP66lScbuYIAu1jNKlnO3N++D/fAGZY=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:11:30 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:11:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 16/43] KVM: arm64: gic-v5: Initialise and teardown VMTEs &
 doorbells
Thread-Topic: [PATCH 16/43] KVM: arm64: gic-v5: Initialise and teardown VMTEs
 & doorbells
Thread-Index: AQHc1mCCUr0KkYvGbEegStwLs8VTUA==
Date: Mon, 27 Apr 2026 16:11:30 +0000
Message-ID: <20260427160547.3129448-17-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DB5PEPF00014B92:EE_|AM9PR08MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b9ae85-bfb9-4f6f-a739-08dea477ca24
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003|18096099003;
X-Microsoft-Antispam-Message-Info-Original:
 apy6frdsbs/EdlJddP+IoicIq5o6+6DvfBnmokRHznPurULGN4JqB5dHp1khRZIghgGWSvnzg5Km4v9ooqkh1ygExxuZs9Fm+1sW5HvSzkyNdNP6jNCsOtr1HdwcM9R50EoAotkUzAQpquHIq5A0UhkoTTvceN4ZDx559ypZxq0nKjxMqSYaq0QA6Nqex7r/JiTlRnpFxIfnXR3tXLy0Wqou59gKOcLFP6F6Xhz3Php002EUUrJj9C7KaxFDkkzb6X/UQ3OK/fVfZ9sKcqI4Dg/qLt07LE9SS5gdUDNy6/zGt9qWK7M2uT9r7dUSjzrmOfc2ovxmeP8qs547XC8lGxqyPfnZOBiRTE0O7YcR25+XzU65Uy8dIbmBwOEE9MQdNRfve8zgaCcBs25blOHpVw9p3g5iQ2f4nAwFWGMdlzWOhsk02TozOMuJUYMYFy33iAPSuUbTvRG3ukriR4AYEMv/54E/e0KGjpqGxR5s1tRdCGldJ9SnjlnWcIjz+0zS6oVvX+TgKKNRAT4OxXnmjIBEMqIYXrAHnhKJQ5Wm5+YywIdrZF5Wsu2xW0WxgrSCh1hwB+/t827PV+3Tl5Ll1TukMVxI9m1iQn1u9rKMpL6rrmSL/R5n2WGjLLHXUp2mBCbaN39QcaIQul8NKZd4+M3neRGJ+FUO4ItHBOzuslnkLZ1F6mlaDiPO6FE2cu97NAcEMuDFyYMHioyvOtFsH9qQ4pDzk055unN0YVKF4CyQjbKDGcBQioIw3Kvr7zgTjbNAgYwHf5J2FBkHJ56zUTTIrpIOgJh3gEpHQUT2zck=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003)(18096099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qO76S5I57eI7PYqwjZSpaQA42+0xX93gMzdtn4n/4NbjccoeCe4hXSjqdwLd4NYV9h2wsqQUslQ8WH+tJvbacGkJQkj9Evl6ZM9beT+kFkdhEwZa6vZ8b/d8tl5WAlGv7hOt0KKmHVJfmjLNQzLwPqZ20QwKRXuhJ9hZbsI/THq9gaj8trSvLBlZbA7GEPogBel0T2fTcXPGmz9zePjHghEFgFBC0qg2J0px0jmbaYPkwB5vDkN2R+sgLY4Gmu38ofKDoJVrYiTPfRQSbChBFIJOTRcUETRTXY9bhEpbOYtgSn+QTuCsswjNkgrOLOFftolwuQQayhf1xcvd7Rq6nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	daad4c2d-bd36-4269-2639-08dea477a4b2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003|18096099003;
X-Microsoft-Antispam-Message-Info:
	+Uq38uXNn/WEKcgj2IwDNurGnhjxlsKteo75n4sioar2cSEJrOywtsvPjIhssLETzpMQ7eZQE36ffpY29M/wvL9FKH+QmwUM3wBP8WtFNKANvYDGwOEaP0QgCFXN8yVkbShTZvhjzVebgeL13ug4xtjLj2Ti30qd5pDCFpk8fsD3BpToVF/mKy2BBQblJm1XVAZhmz2/hcvrsZ4S2qm/l5ZioIcVoqxtdcK/9FovB/IwJ+eRljs1RTGJFTR4HygiZ8ze+rakCE77fLB6IP9/m/REbqdNwxGh+knRTB+LLavXOWNcnVyB7YXEZL0L9UDijOgyDeaWFAhbY9Xkc/eZULxHBGDwFPd1tPAkXR4A35HPPAx3i9S+sCVVS2XGua6+p6jlf5QNOcHKB+tWXeNZvURQJpQoYDna+uR/QXoIfdVzQo5Pl3Dd8/yEIpVnfOZLVK+n55xyAHeJ/mbyInxlHCpY8+N11fIj3tF5AxtSkKHJJI7r0jsfRxL/XGF/E9+f9wsn/iTwmbxq3Spya11KV2LyZHWlIeQGTLHwzqjWrDQAB+FkugTunaOSHzZ7ySYzIWChixMTHmhXoilOtqx18A4/6e8wlbJM4T80NicxFtUISVtVTIqP4m3bABvyKeDnc5JQsB8bIX+xpvJaPBnXYbjR8vwD+072Tg+6HpPjHbnd6/qq0Nk8hyg3u6vQKCKcnhK61LuF71ES02fyG9CY/iopGYZty5UUVrtrm1dBO9xZawwZflnDGYSFEiTCzNmdcLuGccbZOQhUqmYnvZjWGQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003)(18096099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EnoS8w59uN+1VA9fGlsXdKdHkLjfJVbcRfauihG7Z1sRMVUWbXRP+uH0jl1Zu0P4A1nJwV/Q9OJXJm9S7IMpGrLhN15mFKa9c5OtRIxEtBd5UPTKpuGigZpKuIIsKzNR7LvcZJ9prKnwk6gj0B87TeX84TeqxuOZva4pTY9hts5e10lRJGFy1e4T1gBfwK8nEtqczOpVXIANZhw7L6G8JwWpz9fRQNBsM2dUhrX6EVnh1yFckvvmPyTndOQrtbE3BGxaIDtAJwWfREmuKMUEOCp1g+Rpb3r3YnGVhv3jfZT/975HXarJpkzEpHyiOT/Ku9PJQgw/yIkAbzjRiGqAU2qAkvQMGEknHOVBVeYnYtjMpA8ZAwSyjZoAPTxUDS582dT7/+mnHkNHQd4UDzzi6VPdzocHApG9G873djNYZSBMr4bnb+5GAdJKUrG+0aHO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:12:33.1480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b9ae85-bfb9-4f6f-a739-08dea477ca24
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5972

Each GICv5 VM requires a valid VM Table Entry (VMTE). The VM Table
itself is allocated during probe time, but a VM needs to provision a
VMTE before it is able to properly run (PPIs will work, but nothing
else will - and PPIs only are not useful!).

The correct time for setting up the VMTE is during VM
initialisation. For GICv5, this is vgic_v5_init(). Each VM needs a VM
ID - this is actually the index into the VM Table so it is how a
specific VMTE is selected too. As part of vgic_v5_init get a VM ID via
vgic_v5_allocate_vm_id(), which internally uses an IDA to select an
unused VM ID (and hence VMTE) within the range of allowed VM IDs.

Once the VM ID has been allocated, the doorbell domain for the VM is
allocated, and each of the doorbells itself is allocated and assigned
to a vcpu.

Assuming everything up until this point has succeeded, initialise the
VMTE. Internally this allocates the additional data structures
required by the hardware - the VM Descriptor, VPE Table, etc. This
VMTE is then made valid via the IRS's MMIO interface. Finally, all
VPEs are allocated within the VPET.

On teardown, this process is reversed again. The VMTE is made invalid,
the VPEs are freed, the doorbells are released and the domain torn
down, and finally the VM ID is released. The latter allows the VM ID
and VMTE to be reused for a future VM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 146 +++++++++++++++++++++++++++++-----
 1 file changed, 128 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2fc6fa4df034f..9347bc6895223 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -518,6 +518,18 @@ static int vgic_v5_irs_vpe_cr0_update(int vm_id, int v=
pe_id, u32 cr0)
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
 static int vgic_v5_send_command(struct kvm_vcpu *vcpu,
 				enum gicv5_vcpu_info_cmd_type type)
 {
@@ -726,26 +738,46 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	}
 }
=20
-int vgic_v5_init(struct kvm *kvm)
+int vgic_v5_map_resources(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	return 0;
+}
=20
-	ret =3D vgic_v5_create_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
-	if (ret)
-		return ret;
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
+int vgic_v5_init(struct kvm *kvm)
+{
+	int nr_vcpus, ret =3D 0;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	unsigned long i;
+	struct irq_data *d;
+	unsigned int db_virq;
+
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
+	kvm->arch.vgic.gicv5_vm.nr_vpes =3D nr_vcpus;
+
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -754,20 +786,98 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
-	return 0;
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret) {
+		kvm_err("Maximum number of GICv5 VMs reached!\n");
+		return ret;
+	}
+
+	ret =3D vgic_v5_create_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+	if (ret)
+		return ret;
+
+	/*
+	 * Allocate VPE doorbells first - these are our conduit for
+	 * communicating with the host irqchip driver.
+	 */
+	db_virq =3D irq_domain_alloc_irqs(kvm->arch.vgic.gicv5_vm.domain,
+					nr_vcpus, NUMA_NO_NODE,
+					&kvm->arch.vgic.gicv5_vm);
+	if (db_virq < 0) {
+		/* Simplify teardown by doing this early! */
+		vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+		return db_virq;
+	}
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		d =3D irq_domain_get_irq_data(kvm->arch.vgic.gicv5_vm.domain,
+					    db_virq + i);
+		irq_set_status_flags(db_virq + i, IRQ_NOAUTOEN);
+
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			return ret;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		return ret;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		return ret;
+
+	/* Loop over all VPEs, allocate/populate their data structures */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
-	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
-}
+	struct kvm_vcpu *vcpu, *vcpu0;
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	unsigned long i;
+	int rc;
=20
-int vgic_v5_map_resources(struct kvm *kvm)
-{
-	if (!vgic_initialized(kvm))
-		return -EBUSY;
+	/*
+	 * If the VM's ID isn't valid, then we failed init very early. Nothing
+	 * to do here.
+	 */
+	if (!kvm->arch.vgic.gicv5_vm.vm_id_valid)
+		return;
=20
-	return 0;
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc)
+			kvm_err("could not make VMTE invalid\n");
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu))
+				kvm_err("Failed to free VPE\n");
+		}
+
+		if (vgic_v5_vmte_release(kvm))
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+	}
+
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	vgic_v5_release_vm_id(kvm);
 }
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm)
--=20
2.34.1
