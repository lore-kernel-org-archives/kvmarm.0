Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013036.outbound.protection.outlook.com [40.107.159.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A22386425
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 09:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489620; cv=fail; b=IgO3+R0Ly/Q+aefffWpgOCbS+Uc2AplQVJ00NIFMShPXSXLdbuHAq7mPil4M8sTxOwM646s8PwK3dsS0XExG980nC0e6kucer3BUMcEq+4P9Udis8G1yU6yJSnVTASi0zfkQiYiN4saB2Y1XfkPfzs9DN+KtYQKcFyd1oRlJRIM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489620; c=relaxed/simple;
	bh=GevbzdHFn9D7BybZqtCgX4khP+EyqZ9yDW/P+MSs4js=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HRwRlPKw3AGP7lZUcbtQcAWt7OIwMBTpUo123l80F9KavtNSSnI+Sjfcxbh7z9Xwpl8NEvHdO8pwEyEXaw2YeMR12DFvP1KUISeGm/RHoI9yBFGF3M9cFj+QdQh8V642begYt+TAq0xuFzUbYIBlWejs96MBk+gKY+lg/SRVT9s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G+ttuKHv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G+ttuKHv; arc=fail smtp.client-ip=40.107.159.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G+ttuKHv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G+ttuKHv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qsl3QHr+5iMuxcfMNwnihcpdBSbSrZirfYRnH9Nqc2ZqvautEKNDV95DaxALmlWJFJ2rDMKPMZdp3Ibo2TfzGcWH+gEz3kVRwBLBYNa38JDrRyOskbBJeLALDcuPSijnljgrmPHXm6jF57k4z1T2B9DyH4cJXkWnnMGF8VafHkmW1WIABv1rByuozsvzqSNr7fGdOymjbNcNezkhiyZY0pCTbqQTACruO5EQXyxI+R2HRf+cJD6HJoIKSvoroHPPHWHb9fP7bVudzh05EzO2RKtoQNpWpcMOiPx16FhyOePAzJhNHCcYPhZrkgsheUoIMwpswN3MzMxp9LfhPXFlow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GevbzdHFn9D7BybZqtCgX4khP+EyqZ9yDW/P+MSs4js=;
 b=y+jyt/IweQKDwKmls4cG6/Nt6aY4Ynjqb3542HLVmLq0JJX54n/PwqkkUruGFrYwRfhCPwiZXuJ6J9KvC9oE7t1KOu3r9yboyibkTPr47W7NTVOVa9cXweFmpDXOQX2HJRJprrpHURbMy7H+LIizdaxy7SJjOGKAUX2cALp0VVERefiTko7ia4H9PFG6zKk+AVcQwF0xdMVkdhSAOKvAHO/RjQU++d53Qw3Ee6/TIvOMVL2eKca2xr/fmpZTqiXxPaDmmTHCdPOSwqkknHi1SpWVLOT8f/Lqesq1XIc63eoNOBKz7Hn75QQNAluBk91FNDJbFA5FHlDy2O3GmLVy0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GevbzdHFn9D7BybZqtCgX4khP+EyqZ9yDW/P+MSs4js=;
 b=G+ttuKHv367LsZDCM45n4B418qtFSqy6vpgTJkmJLuo+hSs20V9KaZjas3Ns7ntj3SosU/Jdb7Nv99g7RmC+4vWoBRQkjRfpGh7NYyHRWvUPwNqKIUrI4kru3PpcaZqWf3Hz7ULmprJT5L4y/zym+xBZhR/lMo2xLZ9PsljCduQ=
Received: from AM8P189CA0001.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::6)
 by AS8PR08MB8085.eurprd08.prod.outlook.com (2603:10a6:20b:54a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:20:09 +0000
Received: from AMS0EPF000001B0.eurprd05.prod.outlook.com
 (2603:10a6:20b:218:cafe::b) by AM8P189CA0001.outlook.office365.com
 (2603:10a6:20b:218::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 09:20:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B0.mail.protection.outlook.com (10.167.16.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsM4LSYcwREZG1QrqRWj8lg07BgNCsGQB+GZ9UWsGtFI79GMMxVecVM0ApbNrUXMuJ71r0cX37Wtikqd7k1fIJzZDF6L/5SUrOXZWUTC+RmoNrLxCwYKgIXFOcBnX5iafiHigMYJktYc4k+4LE/f5P1yQFGQWrcDw1ubKNkwquHnBNqhi2ZZ7rH1/FuKEDJdmDMNMvbrRD8ttoH6CSwBBYF2Xs6m4qpnX4ZRSoprAqg+dtxA7q+6M5+4A4lY6SF6CtmZ7dkAOGjODzfYS5bMa4nsPESpPnCqaFhSzQ3ODQCgTf/CZ5xqv5Zn+Sk3bk1qsaz2TtAQlSODKoPBIgGonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GevbzdHFn9D7BybZqtCgX4khP+EyqZ9yDW/P+MSs4js=;
 b=eNrOMe0UzSomwgDSkcAercL/QmMZchD628+NxlXmO8swVL4usWhoPmY7ZqmIPITgViaSErYkHaa047gkigF2Zv/vYbuegvIdNS8TbvjEHYfXa84Bv3OrgydKkVnij/BR0m4R/HoCA0n+tLNnoOff4OoyKNk9OeNqO5HNQfIGk9QLXEn/dKRpYrcYpns/vNdjcowVM8Lwy7ww2x77TVVRmRSGN0umEoMgQhlrR5TLKetarvMjvcBau/Hy8AMneHddQJpa/LXomuu4bFyFA+mdYDmLVerwGp5F+iswb6Z0zi40oUv6sGEGi+V+GYvtOs/y/5i/JPphb/omj+e8Edc/Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GevbzdHFn9D7BybZqtCgX4khP+EyqZ9yDW/P+MSs4js=;
 b=G+ttuKHv367LsZDCM45n4B418qtFSqy6vpgTJkmJLuo+hSs20V9KaZjas3Ns7ntj3SosU/Jdb7Nv99g7RmC+4vWoBRQkjRfpGh7NYyHRWvUPwNqKIUrI4kru3PpcaZqWf3Hz7ULmprJT5L4y/zym+xBZhR/lMo2xLZ9PsljCduQ=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA6PR08MB10768.eurprd08.prod.outlook.com (2603:10a6:102:3d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:19:02 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:19:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 38/48] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v4 38/48] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHdG1tSr9NcrFmlv0WxIv2o24r6v7aBxMwAgAWfvIA=
Date: Fri, 31 Jul 2026 09:19:02 +0000
Message-ID: <18f44272b49ee3914eed594b254630c48e50405d.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-39-sascha.bischoff@arm.com>
	 <CA+EHjTxk_OnWEd_2w-w=Ub3ANXdHhqx_ai52cjy0vMo5bGOnfQ@mail.gmail.com>
In-Reply-To:
 <CA+EHjTxk_OnWEd_2w-w=Ub3ANXdHhqx_ai52cjy0vMo5bGOnfQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA6PR08MB10768:EE_|AMS0EPF000001B0:EE_|AS8PR08MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e44f43b-4c3b-40ea-47b8-08deeee4ea84
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|4143699003|11063799006|56012099006|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 dlxsxQHlkmro+B7aVvx8HLRNrXO3orTNg2eBwKt+ZG2MDGkedxX1vk/+/4fq6bSqdSh07EGjoUadb3imkp40qiu2pfJU0eFNFbw0JuiMQZoXPhwG7ArBBXZCvCkJIFhOaJqtt2OXWBTbnwpCRrKnMb4xRhbFgBIsQkhul+Wth5h9F/kA6Rx/vYYMhsZENuy9Cuti8Ab5n+XLU1hCuixuKho770XLoQzpdDYdhN3SH1febrffszzyfsPp01hQiwEK2h546/REoI32ALhiFIiczknNpkbUIt/cBO4OsNKLaEKDP8CKvAZGyqi9JS9YEV0edZAPFlG5vjwqnyZl6pnnN1uuqOfKVrezOzTjCNbz7UNnEEcLNTML3Vps+MS9HECDVWqL3Lq7Fjb7uCVpUP3AnAeCpNTK6WpRBf6G1V4qK/pBLSKXnVdtHq8QT8DFxF4eiWRFiGJQQCD1YLRNGMtW0chpLuRQP8ndZzWejmpPxgB8xpf6lI+1EaNUhgYMeNgDO1UpgHvxc0k3PkmWR5Lk6WftLOf0fgdX1uVPjAkUFq3EdY0HrR23nPgdSze4nAdwI0dJ+JiEcbBj6oKi6blq/wYmidQGAx3cufcLLe0P3cw9kwl17CN9qwjQHFVrmHS1C58yXuDW9JqiMTfNJ017yWdKzMhuxvCWWX5fhu7icwYDCE/cxp/X9WNltTNQreY6kMqwVtV+W3KfiL46UKTxEd/21Qii/gmz3nBqO8o3+yg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0A6C0D60995114B8AB9C96B6C5773A8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TYJ6GQuizoWT2C2feF/JuI2fJuDBqQPGxmSKkfdFJyxQPmkzVHL7Q6yXHqPCYR6XD2ZJFRGmcmm9ftPBW52tgJWZfwRFr48atx6i4aK6LwgJal6Fy+Ad0uNyEMeUVg9amUebdcp75olxkb3Oc6V+CYRxdJ6izwAZdas6C5nzpysOuuJ65LKuX2MLY7Dhm1iikf7zYlaq7AbFnKYDwQ0p6CU8v1fnOlJSrp+UvanWmFdUvgNJTvOgrSjL9YSCyeSWOd5X+zreF9fH8EtwiItbmeDMLTsAyUKOkpUjjsdZuZHC2lOZGOMPjXwxbSllPyvtAuunxewd2XUGBOl1KN6Zcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10768
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	81ee6fc1-6ad3-4ffd-0f17-08deeee4c313
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|1800799024|36860700016|23010399003|14060799003|18002099003|22082099003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Rd1zGMEsB31hDq2zJweGCeoj6U6QMJ1L2ds3VOPIBEn0qpFDhbnZMkAl4L46kTIO7G9oW4i7J5OM/4J9qfzHlod2PuwfLdXdA7fG4eJbbfXFcBBroJDk2JhX7j8RLY5a3g7+eMCpCIh5mL6YaqdDNYCWcGbgvXQ7pkrRhQxPg9BJq/zNWlSbOz4HHxyvbHRP0MYD3kpaatuUmSgbC6+Ai3vB4jCqa+TlMAWoWSfkTTsFCv3naos6NaXrZ5qb0aBvdb5LoE6kxg4yYnbPK4QhfbYckcfVkyI4M1Q8TbqQ3SliQFMlzZubQ0cJkYvgv91n+uxh1O4Tbj08lfmJ27t30o0Wt+wOgtzLR7rsE6FfcsejKb8o1j34Hiivb2WR7X35lagBOCC8xlvn1CRtBZG/BbU5RYcFNvHBPDWuKOENo70sMeq5o1O16e+FDVAQmFZT8IgM3JPWkbevFs9Mr2shiLis/+wZcd1TUWswk0whTT2S406/ZwzpUG8W5t+CCbqqKRN6GhSBaJokQvvaOKcbz4DRJEnfgCGyYdqzdNCtsqryC3Lvaj4rouimSlzZ0akTv3hywTb20bX6t1qboIl3feFU30iHMJoCv8d/86jgpvV/fQA3HRvEhT6blCcyXwBMC1b6VYU79ATl1bn9sHNLqc93L16xSBeLjppzGQhlhAqNhXtDOgMNZFmY7YbqRUHRNMvlbD7nOO+x+20UMcMGBw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(1800799024)(36860700016)(23010399003)(14060799003)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yPxxAWAlrkllWBrss64WPhHnt2UxvttyeMFI+jy1QLZvOJ7jUe8YTc5zYN1+2CF6kDbIq6vZCqQ4tP5B8hVdmTWdhze7z5XuI4vvfikGUuvpZnPpwkOMPwYGvQeRuP30BNXFB9WinYbA0XPfuFZRciLwTm5saaEAm2FEWMtUt0vjVqG2sIBkO+AA7Sdvs+Yq3Leo7+Cf4LcjpweInK8m+jQLoVZfr/Zr8geS2CHCxCVXablTd7BtZaNS3hDd5VA+cEif++dSOLyAiB9z3/YJN2XQ83iSwtscXGmV3SdtRwpYFjTaP4gliHhir+OUKOZycGNSVydX23SxyBvJ5WQs++dtziXGw2+VfQO0g3g0dT8iA4TyRY6Js1+1p/aeB3Gjd8fImTQmZgF0gPpMKlCPhNexOAwYrurzs7YCsbXWSVNoBkN3TrL6oRJI+ymwHs+9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:20:08.6538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e44f43b-4c3b-40ea-47b8-08deeee4ea84
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8085

SGkgRnVhZCwNCg0KT24gTW9uLCAyMDI2LTA3LTI3IGF0IDIwOjI2ICswMTAwLCBGdWFkIFRhYmJh
IHdyb3RlOg0KPiBIaSBTYXNjaGEsDQo+IA0KPiBPbiBGcmksIDI0IEp1bCAyMDI2IGF0IDExOjU5
LCBTYXNjaGEgQmlzY2hvZmYNCj4gPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPiB3cm90ZToNCj4g
Li4uDQo+ID4gK8KgwqDCoMKgwqAgLUVOT0VOVMKgwqDCoMKgwqAgQSB1c2Vyc3BhY2UgU1BJIElT
VCBidWZmZXIgd2FzIHN1cHBsaWVkLCBidXQNCj4gPiB0aGVyZSBpcyBubyBTUEkNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElTVCB0byBzZXJpYWxpc2UvdW5zZXJp
YWxpc2UNCj4gDQo+IEkgZG8gbm90IHRoaW5rIC1FTk9FTlQgY2FuIGJlIHJldHVybmVkLg0KDQpZ
ZWFoLCBhZnRlciB0aGUgcmV3b3JrIHRoYXQgSSBkaWQgbGFzdCB0aW1lIEkgZG9uJ3QgdGhpbmsg
aXQgY2FuIGJlDQplaXRoZXIuDQoNCj4gVGhlIGJyYW5jaCBwcm9kdWNpbmcgaXQgaW4NCj4gYHZn
aWNfdjVfZ2V0X3NwaV9pc3RfZGVzYygpYCBuZWVkcyBgIWlzdC0+YmFzZSAmJiB1c2Vyc3BhY2Vf
YnVmYCwgYnV0DQo+IGB2Z2ljX3Y1X3ZhbGlkYXRlX2lzdF9hdHRyKClgIHJ1bnMgZmlyc3QgYXQg
Ym90aCBjYWxsIHNpdGVzIGFuZA0KPiByZWplY3RzIGEgemVybyBgc3BpX2lzdF9hZGRyYCwgYW5k
IGEgVkdJQ3Y1IFZNIGFsd2F5cyBoYXMgYW4gU1BJIElTVA0KPiBieSB0aGUgdGltZSB0aGlzIGF0
dHJpYnV0ZSBpcyByZWFjaGFibGUuIFRoYXQgbGVhdmVzIHRoZQ0KPiBgdXNlcnNwYWNlX2J1ZmAg
YXJndW1lbnQgd2l0aG91dCBhbiBlZmZlY3QgZWl0aGVyLCBzbyB0aGlzIG1heSBiZSBhDQo+IGNv
ZGUgZml4IHJhdGhlciB0aGFuIGEgZG9jdW1lbnRhdGlvbiBvbmUuDQoNCkFncmVlZC4gSSd2ZSBy
ZW1vdmVkIGB1c2Vyc3BhY2VfYnVmYCBhcyBpdCBpcyBjb21wbGV0ZWx5IHJlZHVuZGFudCBub3cu
DQpUaGUgcGF0aHMgcmV0dXJuIC1FTk9FTlQgd2VyZSBhbHNvIHVucmVhY2hhYmxlIG5vdywgc28g
SSd2ZSBwcnVuZWQNCnRob3NlIHRvbywgYXMgd2VsbCBhcyBkcm9wcGluZyBpdCBmcm9tIHRoZSBk
b2N1bWVudGF0aW9uLg0KDQo+IA0KPiBDaGVlcnMsDQo+IC9mdWFkDQoNClRoYW5rcywNClNhc2No
YQ0K
