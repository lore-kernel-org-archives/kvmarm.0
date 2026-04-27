Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010070.outbound.protection.outlook.com [52.101.84.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCD5352C2C
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306758; cv=fail; b=GTh35O07I2Zld/yQS4sURvWTwTk1WEFLUSxPD8YGGqNjboY09n3WPj9spiOEgtB4TZb3YW9Lt1ZmSVm97FbqsvNseDylh7fTL7px5AGqiqq0J6sugA1bL8wr5HUCLewBnBDzNstvkWTaNBf83bNv44txx4MtXNiCuaxPSNkv+94=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306758; c=relaxed/simple;
	bh=B/nlKbOAm7TyDudLn9qWPPHj2/tagR6vVf4kEBJ5a9U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJvBa7fRfOJFKKJKZNHgpFSZP5fhRNkSPCT2FjaaMHadF6/gvRlvkAefCFyzADIjqupQckPfyLCw7ZltjeGR6jjATben+vPLBCOEF5CldErfspHQ6qSLgIOoKPMhmA4eQEvvk/9dWQQkh0A3+dc06sqXtfifzFN3m5Iy5otWhFM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ITSmciNJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ITSmciNJ; arc=fail smtp.client-ip=52.101.84.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ITSmciNJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ITSmciNJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FRlJbNUdYpxneH+mlBVsZLHsUzBmRk1AByma8uUfXS+Zulih0feEcbsUyuf5TaH3Uv+MIkrK8RUoWCrPaG2v+TVwUT+6zmb4CRBGdhlF+TfuVGE5q5hPmQb7yae4xnm0XmGKTpJgVyMxV/ED3dHxM+857cqEHBEsbgFFQd3DvzL6nDq5SgVBuvxxPcKTkuzHTUNjzQdEjdESmkNAJS5FdzPYmOHWuHZdiCbN1DCerYncAQsbhwCOZ4oOTwCJETgVdsQZ4LF4ZyCs27H+fQ2CLIC1OZ1xQc/EcQw+2cEtD/2QHlArueh4xTrJb05BsGib5B8yLoEvOLYI33WGLzaLSA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCLoj1nKqeuiZgAmqLhO7nyANAhZqWsS5BpqF7HJRHg=;
 b=b18o6+yMLXLtaty0FyyT6eRKKEQcsTWNA9RVCZkQOm641Hg5SqUVtjzR6APfvWynSKrrHNPmehEd3uIC4wHZrp5gIQbkCPndx0/vM/xjWxdVikjUfOCC8PwG+bIaLFc5h41FKRPaYFE0m8Kcav4YVnW6STyeu/8nbahLEWLAdLwnGBR5RKRwgeUeB562TpUp+bbPF2Xk2lFOAroJftNsy+F5e3d9tHyXLPgXCn7llVCY5I0UhaSaj6GzY32AVLuUXajJeq1lST7tWoSqHAdefBOEkyy8dLPNVrQIb/Vtb9Zk0Em/qR6fqAsjJg5zkO6dNzK/1Xy3BiWxRPTTLsF6ow==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCLoj1nKqeuiZgAmqLhO7nyANAhZqWsS5BpqF7HJRHg=;
 b=ITSmciNJKU4A5rkTXzwj/Hc3Wxybg2wkg8FD49tIOW62jnxmk7eDNfT9I6kpkTdqre/ZP5f5jrFb0L5J5/tchocghl7pgVkDw44jvcbOHQd9hBVflzw9p60Ie9JD8XqwlwBOjKh98kKzXoQiVSWdXY2y3rVAi8n8b/1OEOMGQDE=
Received: from CWLP265CA0334.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:57::34)
 by PAXPR08MB6382.eurprd08.prod.outlook.com (2603:10a6:102:15b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:03 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:401:57:cafe::73) by CWLP265CA0334.outlook.office365.com
 (2603:10a6:401:57::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:19:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UBEOsiY5+mNljXxWFx1LFZIYpe1aWjKqs8CTAI53f/gL3wy+xmRM/Hs6Q7REc0CtwSsqccOSd2bOF1JXF2WoA9+XZrLaag+YfiKJQ+IBkCCP249KT7BAzzcG4jseKDfW32dJOJ/mjrSBoPVM4V+BRvaG4RG2uPqyxqVUkZsd/dbON6N6aGXz+vMNlXI82ZMZgPXEOzl5YwWYCGPlwRTj5+iG/WyoJHc40WUqinddopQfXdDOZMAPGOPCi/0xyRZCAL2LLWnbLLMaEbKXGS5ew5LtGH8ikW2/D3hwEf3BFKVb0j8FWXBjlqotYcfWqH1ccfqDsnqy3JBh5MMR+9gfDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCLoj1nKqeuiZgAmqLhO7nyANAhZqWsS5BpqF7HJRHg=;
 b=Id1/KB8XqYnQbBWOUouNFG87/qxY14jh2nJXWu9dIRvtc5lk64aVYm5a/X5KQjDu9C8B/UDkaQDB13c7XM5HWwhYhuBiKF2drxQDMyIxfm9bfaZz+42H8aX73k9VzjuEzVmfIm6W55q3s+p2wL0RXJYN2gTePXO7fUeqZ3704T7x+25uTZX7GQDxNdILKcHPSiahQh6EYpjJa/cbqxcGjO/kKM09m6AUqiVQeFvW+0ut47udVK5GMkMVGwP4wEnXudDorzY54FH5aYb+Z09Vhf7CfmYf6NxbtptCqUmwRSgG6Q7hDol/yTEjf/2IPx6kSPEI/8xeMiX+axZ7p7AEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCLoj1nKqeuiZgAmqLhO7nyANAhZqWsS5BpqF7HJRHg=;
 b=ITSmciNJKU4A5rkTXzwj/Hc3Wxybg2wkg8FD49tIOW62jnxmk7eDNfT9I6kpkTdqre/ZP5f5jrFb0L5J5/tchocghl7pgVkDw44jvcbOHQd9hBVflzw9p60Ie9JD8XqwlwBOjKh98kKzXoQiVSWdXY2y3rVAi8n8b/1OEOMGQDE=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:59 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:17:59 +0000
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
Subject: [PATCH 35/43] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace
 set/get interface
Thread-Topic: [PATCH 35/43] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace
 set/get interface
Thread-Index: AQHc1mFqQVFMVZqmz0WOepKU+tqGWg==
Date: Mon, 27 Apr 2026 16:17:59 +0000
Message-ID: <20260427160547.3129448-36-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AM4PEPF00027A68:EE_|PAXPR08MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e36a22-b140-489b-da3c-08dea478b2b3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003|11006099003;
X-Microsoft-Antispam-Message-Info-Original:
 HxXGNeHjIByNPxa60rlN7O+TjW0WnrLcf7ScdhKwmOuDb/fHv5i30J5VZh2I06bX63ppxYhYjqQa+rEBGdzwTL1Znxk7cwuZ8ztZNFh1Sem/iulqkTr/TO304JgLGdjbkcLUIZFyCHXWm1tDVc8PlhgLkjdqgOfsPSmyV254koXGObEJnOh3oTDC3Tsh6VYXObV3F62oxNmG8MhPqa1TE5PNqV8m9dmRLdql1xtBzFwMWArIFDqVgvrEmMQ+ms416DQsNG6bPnt1gKnOxAILstFMyD4ii4jyzliyWDx9ayCT40A9nVx9TLDG/SxV/zFu04Xw+cu91HSsVm6xhvZFBVwctwEyll4cK3QMr2JtbnTlODcMj1UaiZfAn+rQwI4RVBr7Xglnncry8IL/6PlUyZm019D/pbwQ6OcLS4hoVzUK2XueTTPTEaOB4W3ebO9IzDN+hYZEJvMm6MmEu2c9jDza5i0DV+5e3xYJqlva06BDKJ8SGgJLuaMVvYnyHtobC0DPAIAZ469Py9AIzwacgg+553TPXZ86rAWFdTcGzuE6DfZ7qwN+qaoEDMU4iaeJpMf3MZx8B2zw2b1o7AM+goAs7Twe9NF3Tg3tNvJXSSPlNWdwP9Bksd5XO8/Vn/qK+SGmfM0zpBUefoT8M/+Kq8Dd1T0Hrlpxw/MTkZ3PP6LfRez3Kb5Osgq9Ripn53qMGeQ2bdVJofqyU/p19A7PtkX5dWGIFdBVAT5Kb+ZeduF3+lhjLEvrZ/Z1gDPr80vPd2mCW3sCD7/YzCDVdZI5SE7nCq6JMzQU/6HNyLQIfWo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003)(11006099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 dtppeuIrkv6Ld6hOOWtNjvbQsaE5RG1jxigtgC7zblQzKeYrr9s6eNRo5T4y/p9/iIecHPN59pcwLP1q+YKRl2otwHXAHPYSg6MzV0LXUmb1+0eCWHkih/nA6bKECHR9jXOrFGhFjA39NAcPUJjHzNX2g0Csv2JwVwMFmi35Jz4Bm+CKgztSJkHMAsp12puY4+S24D7/SlK7HjMPU7ZcsZ8clsGbIzY9vjrZCWc8gvgo75JjCbaR89/5aed4qi4Tva7dppNT85f+bj9sktV1QCPGdF3k5A969eSczw6vwIdXIrT5kuNDCsnp/QMUhMSIvuTFs+5DEipikPKPhtN5tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3a129042-cf36-4842-21a2-08dea4788cc8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|82310400026|35042699022|36860700016|56012099003|22082099003|18002099003|11006099003;
X-Microsoft-Antispam-Message-Info:
	uzNjWb17VxXbG8CcvYq7mAj0SWA8UsmEJXBxtCRypAh4wZunGZkhMvaZQvNZoz/SByJKwdPDdeF7GNOqfTSXvim4IK9emdm0Y0Oug6FCPxeVylXRj6jK/XbFkmoYTO60S4uXHRf3kIlGNeYgkDuApFVFtM7G14sCxK+qsry+v7KucXWtZ4CQv2dHy/GTQJ80MkSs5QdRlc4ehVN6ZHtgKANJ50tAjPQULAAlbrkCSlI6qyadUQDR2gIc1jZ7ZUzs91Ivj7h1Nq8KIdB4qqRRCA9zAai1wpYyiNG/Nxzdz34KAzbqN2EwrJXs+JIBL4IZhA297cyg49A5QZAApzJOHP00A3FBIiifHLq0o13XhbOyioDW0UcfUOuKOAaM1Cs54qCHUYPTfIkWnAeec5lKh+M09xAtN2xw0Z4fcUnXq/0hs1g0Td9qOhikbJBnhhcNcmJJ01AHRWaQ2iPzOiP39y10AGJdGGHoOI9oqMQXS8eXwjGS54xYffqNs7KL+I2p1NHnrkGRP8cLdNdf5vKJD+Qb0tMfs/yLnPT5fpYXeoIYocUqwQHqJgwTzAB2B8s4Qf+ou5/TNfjLZIswZFqgAXfL2HoGy8SmtFbFtyam9yFg767rx25xXVIWr1ai4aUvBzZldYmAfh0iCec0kwrxhq8J7NP5XNBzRYKQmkksGUvE4tNFUy2yWr71qr8ywc6TR/By/p+pLza6RH1lLnXUVS8P7RaliQKiaw9QbnLkfxvuqEn6YIuTXKZcbuG26ZX9yDcLTCfC/HzM6DPukczA2Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(82310400026)(35042699022)(36860700016)(56012099003)(22082099003)(18002099003)(11006099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nOyYZ8kfu+Zqo7hH88wrqOa1FQrQPK/O/QRw1xLgdde4trrMTzSLoI/xTpQSDf+fyoykWZht6sMCgXjYB2InmyQhlkjrBmQjGio+9/7BdfNa2Sng4TZfkJc7wZQQ3sjNhq+DdqKY13k6v5omNSIbmpphSFVhPRQrbsiQ4Z2TiEtkhxjZDIqMtHuhbyBYrzIZ1c52GB9azZNs1VlZC88VjFUEEXKexBusP7lYqGFgBUsoWMx8j4zfigtZsjZLYgtDCHO2gdI00ivpXrysMGsGAcDpQuFYhlD3jzUwLDzGseblv8XfUvETAG1KOhEIfWzcQxc9wZVyVqz6vVfRhxfotyi0sd4x12r30HQphuzpTzv2kfoEz9b/jmEnrNWLPWnQPu2ExopShM2DiItLalcEHL3Wh0VDjd8Ld0c+2C59FzJn3PLYmjRrXtv07YTNyu/I
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:19:03.3379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e36a22-b140-489b-da3c-08dea478b2b3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6382

Now that KVM is at the point where it is able to run meaningful VMs
with GICv5, it is important to be able to save/restore the GICv5
state in order to allow for VM migration.

Add functions to handle the set/get for GICv5 EL1 system registers to
facilitate the save/restore of these. These access the stored
hypervisor state for the guest, rather than the guest's registers
themselves. Much of the state that is read out is generated at this
point as it is stored across a range of registers. When writing the
system registers, the state is merged back into the appropriate
places.

The save/restore mechanism introduced here matches that already
present for GICv3 - there are no changes required to that interface,
so we are able to reuse the existing UAPI for GICv5.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile          |   3 +-
 arch/arm64/kvm/sys_regs.c        |   6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c | 510 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h       |   5 +
 4 files changed, 522 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 92dda57c08766..7aaeeb84e788e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,8 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o \
+	 vgic-sys-reg-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6083a1b23dbf9..af0d8357003be 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5831,7 +5831,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 int __init kvm_sys_reg_table_init(void)
 {
-	const struct sys_reg_desc *gicv3_regs;
+	const struct sys_reg_desc *gicv3_regs, *gicv5_regs;
 	bool valid =3D true;
 	unsigned int i, sz;
 	int ret =3D 0;
@@ -5844,8 +5844,12 @@ int __init kvm_sys_reg_table_init(void)
 	valid &=3D check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), fal=
se);
 	valid &=3D check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs),=
 false);
=20
+	/* The GICv3 system registers... */
 	gicv3_regs =3D vgic_v3_get_sysreg_table(&sz);
 	valid &=3D check_sysreg_table(gicv3_regs, sz, false);
+	/* ...and the GICv5 system registers. */
+	gicv5_regs =3D vgic_v5_get_sysreg_table(&sz);
+	valid &=3D check_sysreg_table(gicv5_regs, sz, false);
=20
 	if (!valid)
 		return -EINVAL;
diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-reg=
-v5.c
new file mode 100644
index 0000000000000..7623edd01dce5
--- /dev/null
+++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+/*
+ * VGICv5 system registers handling functions for AArch64 mode
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "vgic/vgic.h"
+#include "sys_regs.h"
+
+static int set_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* The upper 32 bits are RES0 */
+	cpu_if->vgic_apr =3D val & ~ICC_APR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_apr;
+
+	return 0;
+}
+
+static int set_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We only support setting the ICC_CR0_EL1.En bit, which is actually
+	 * stored in the VMCR.
+	 */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_EN, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_CR0_EL1_EN, val));
+
+	return 0;
+}
+
+static int get_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * PID only applies if EL3 is present. Same applies to IPPT. Hence,
+	 * those fields are always presented as 0.
+	 *
+	 * We always present the link as connected and idle:
+	 *     (LINK =3D 1, LINK_IDLE =3D 1).
+	 */
+	*val =3D FIELD_PREP(ICC_CR0_EL1_EN,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, cpu_if->vgic_vmcr));
+	*val |=3D ICC_CR0_EL1_LINK_MASK;
+	*val |=3D ICC_CR0_EL1_LINK_IDLE_MASK;
+
+	return 0;
+}
+
+static int set_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* Set the VPMR field in the VMCR */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_VPMR, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_PCR_EL1_PRIORITY, val));
+
+	return 0;
+}
+
+static int get_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr));
+
+	return 0;
+}
+
+static int set_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	cpu_if->vgic_icsr =3D val & ~ICC_ICSR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_icsr;
+
+	return 0;
+}
+
+/*
+ * Helper macro to iterate over a range of PPIs and execute some code (to =
either
+ * extract or set the vgic_irq state). This is used when `get`-ing the PPI
+ * ENABLER, ACTIVER, PENDR and when setting the PRIORITYR state.
+ *
+ * vcpu: Pointer to struct kvm_vcpu (to which these PPIs belong)
+ * r: The register index. 0 or 1 for all except PRIORITYR (which is 0-15)
+ * nr: The number of PPIs iterated over. 64 for all but PRIORITYR (which i=
s 8)
+ * code: The code snippet to execute for each vgic_irq
+ */
+#define for_ppi_state(vcpu, r, nr, code)				\
+	({								\
+		for (int i =3D 0; i < nr; i++) {				\
+			u32 id =3D vgic_v5_make_ppi(r * nr + i);		\
+			struct vgic_irq *irq;				\
+									\
+			irq =3D vgic_get_vcpu_irq(vcpu, id);		\
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) { \
+				code;					\
+			}						\
+			vgic_put_irq(vcpu->kvm, irq);			\
+		}							\
+	})
+
+static int set_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/*
+	 * If we're only handling architected PPIs and the guest writes to the
+	 * enable for the non-architected PPIs, we just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them in
+	 * this case.
+	 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Merge the raw guest write into our bitmap at an offset of either 0 or
+	 * 64.
+	 *
+	 * Note that there is *NO* masking applied - the enable state is written
+	 * unfiltered. The assumption is that userspace uses this interface to
+	 * set initial state before the guest runs, and then the exposed PPI
+	 * mask is applied later, when vgic_v5_finalize_ppi_state() runs on
+	 * first entry to each vCPU. If userspace chooses to set the enabler
+	 * state later, it is fully capable of breaking the illusion we provided
+	 * to the guest by exposing register state (and PPIs) to the guest that
+	 * were not initially exposed. Good luck!
+	 */
+	bitmap_write(cpu_if->vgic_ppi_enabler, val, 64 * reg, 64);
+
+	/*
+	 * Sync the change in enable states to the vgic_irqs for the written
+	 * register slice.
+	 */
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
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
+	return 0;
+}
+
+static int get_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long enabler =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ENABLER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &enabler, irq->enabled)=
);
+
+	*val =3D enabler;
+
+	return 0;
+}
+
+static int set_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Store the raw guest write. The exposed PPI mask is applied later,
+	 * when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	bitmap_write(cpu_if->vgic_ppi_activer, val, 64 * reg, 64);
+
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int get_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long activer =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ACTIVER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &activer, irq->active))=
;
+
+	*val =3D activer;
+
+	return 0;
+}
+
+static int set_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 val)
+{
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Update each struct vgic_irq with the pending state, treating Level
+	 * and Edge interrupts differently. The exposed PPI mask is applied
+	 * later, when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	start =3D VGIC_V5_NR_PRIVATE_IRQS * reg;
+	end =3D start + VGIC_V5_NR_PRIVATE_IRQS;
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			bool level =3D !!(val & BIT_ULL(i));
+
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				irq->line_level =3D level;
+			else
+				irq->pending_latch =3D level;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * The pending state is generated from the vgic_irqs on each guest
+	 * entry. Therefore, we don't store the raw value written anywhere in
+	 * the case of userspace PPI_PENDRx_EL1 writes.
+	 */
+
+	return 0;
+}
+
+static int get_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long pendr =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the PENDR value. */
+	for_ppi_state(vcpu, reg, 64,
+		if (irq_is_pending(irq))
+			__assign_bit(i % 64, &pendr, 1);
+		);
+
+	*val =3D pendr;
+
+	return 0;
+}
+
+static int set_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7)
+		return 0;
+
+	/*
+	 * Although priorities are not regularly synced back to the vgic_irq
+	 * state, they are explcitly synced back here. This is to ensure that
+	 * any pending PPIs are evaluated correctly when first running the guest
+	 * after setting the state.
+	 */
+	for_ppi_state(vcpu, reg, 8,
+		      irq->priority =3D (val >> 8 * i) & ICC_PPI_PRIORITYRx_EL1_Priority=
0;
+		);
+
+	/*
+	 * Update the state that will be written to the ICH_PPI_PRIORITYRx_EL2
+	 * on next guest entry.
+	 */
+	cpu_if->vgic_ppi_priorityr[reg] =3D val;
+
+	return 0;
+}
+
+static int get_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/*
+	 * The priorities are only synced back to the vgic_irq state when the
+	 * vcpu is entering WFI (KVM only needs to know the priorities when
+	 * evaluating if there are pending PPI interrupts for a vcpu). The raw
+	 * register ICH_PPI_PRIORITYRx_EL1 state is simply saved and restored
+	 * blindly. This state is just returned as it contains the most recent
+	 * priorities written by the guest.
+	 */
+	*val =3D cpu_if->vgic_ppi_priorityr[reg];
+
+	return 0;
+}
+
+/*
+ * The following registers are NOT supported:
+ *
+ * - ICC_HAPR_EL1
+ *	The value of this is directly generated by the GICv5 hardware based on
+ *	the ICC_APR_EL1 when the guest is running.
+ * - ICC_IAFFIDR_EL1
+ *	The IAFFID for a GICv5 VPE is the same as the VPE ID, which is the inde=
x
+ *	into the in-memory VPE Table. This is not configurable, and instead we
+ *	rely on userspace recreating the VPEs in the same order prior to
+ *	restoring guest state.
+ * - ICC_PPI_CACTIVER<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ * - ICC_PPI_CPENDR<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ */
+static const struct sys_reg_desc gic_v5_icc_reg_descs[] =3D {
+	{ SYS_DESC(SYS_ICC_ICSR_EL1),
+	  .set_user =3D set_gic_icsr, .get_user =3D get_gic_icsr, },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	/*
+	 * Only ICC_SACTIVER<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER0_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER1_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	/*
+	 * Only ICC_SPENDR<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR0_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR1_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR0_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR1_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR2_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR3_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR4_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR5_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR6_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR7_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR8_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR9_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR10_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR11_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR12_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR13_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR14_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR15_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_APR_EL1),
+	  .set_user =3D set_gic_apr, .get_user =3D get_gic_apr, },
+	{ SYS_DESC(SYS_ICC_CR0_EL1),
+	  .set_user =3D set_gic_cr0, .get_user =3D get_gic_cr0, },
+	{ SYS_DESC(SYS_ICC_PCR_EL1),
+	  .set_user =3D set_gic_pcr, .get_user =3D get_gic_pcr, },
+};
+
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz)
+{
+	*sz =3D ARRAY_SIZE(gic_v5_icc_reg_descs);
+	return gic_v5_icc_reg_descs;
+}
+
+static u64 attr_to_id(u64 attr)
+{
+	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
+}
+
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr)
+{
+	const struct sys_reg_desc *r;
+
+	r =3D get_reg_by_id(attr_to_id(attr->attr), gic_v5_icc_reg_descs,
+			  ARRAY_SIZE(gic_v5_icc_reg_descs));
+
+	if (r && !sysreg_hidden(vcpu, r))
+		return 0;
+
+	return -ENXIO;
+}
+
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	struct kvm_one_reg reg =3D {
+		.id	=3D attr_to_id(attr->attr),
+		.addr	=3D attr->addr,
+	};
+
+	if (is_write)
+		return kvm_sys_reg_set_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+	else
+		return kvm_sys_reg_get_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b5036170430dd..36604f911e089 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -383,6 +383,11 @@ void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr, bool is_write);
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
=20
--=20
2.34.1
