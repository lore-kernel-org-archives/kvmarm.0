Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011031.outbound.protection.outlook.com [52.101.65.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0E3EE1D7
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935813; cv=fail; b=YMgwU2ARAHWTjlKC/pVTotR4bDW2FJi1mzEJCO16F0w93oFBzdIw6YqvJMBIC8XDc8GUkNgj/wZL4yNagXkxV2vyhbYXPPVtBDpc9N14M0GAjlxDjS73uZdny05fwZ0hPmcrdj4vZzrikWZLBc4PCmBcHSVIDDj3QcLbY3WjFTs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935813; c=relaxed/simple;
	bh=dHptrPeeJXF9TL6cNPQS6iRDygecbguJpEuYxCnkxzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TMDpdLjEdjWzW5gRyZuYZglsOBk4DfBhWgntiQicKZHkhLmGqwQPJN8luGSDv1ZFxHTrzDk2HngZPAwXCwF6LoXVqpDE8Cgz+YmEByDILn6ZS13IcYfTPFZpjTPM5KPXFdrzOGm/gBqdDbiOBd1at0mgFuS+JBohedT3Sg+U65M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CK2WEqfp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CK2WEqfp; arc=fail smtp.client-ip=52.101.65.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CK2WEqfp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CK2WEqfp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lsN8JTeB2YHehrcBFFp1fZ8I4rJdIVsgoW7xywJdN3lWkncXCXsYAkUT8JGudo0U/7D/WjDGLt5n7PkWkrEkwrYyXN221sCEmm1Tcp4KjUZEDgm68fOAwoR5dU7y/KmryMAM+82D3AmAjxM+y56mWSydJvtD6k13XAVyC+n7fXmR6oXsau7VrxlxXWCxzWocZtbGiMXb/ZoNjRsFqT/INoUyKb4QuoMWL5llJOkZIkZh8kRll+p2w5vm8RJSyBUYgS7DdQgRlnoBpRHq1GqSF+83cCluPQdYeHADlqsVNCJay0ya0IzX0sbaoMGKYm6eM2LqElXs8Rmy2Sj3qncmow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewAW/8lfVxIMA8K3o3m+nzCqhDfvHN3W2KIGI0C7204=;
 b=T3O2iGiCG8oFL7va5hoWOAV+XolerVH+MDdN+v8VAgOEUBOjYeIIXRddHEWspVRkdO7xafYlfWP5QJjN+JoOdc4F3/nYYFQsx8Jeh21JZW5eUX9Y71K7P0lX2jBlJXW6s1VQBnop6Gz3urET/0TIx98u2dC4hmZTWNz2j62nnqzB2KS7CiYpxV3NTON68T6fn7re3rg51C3OPIUIpaj1v1usapEd5s/gc6lWgIweytyPIfcCHPiGRyAMk26J4O5E3mi1+FaC5vV01hkoQAVwH6niqyhj56HhaoJulnMU3FcwByPgT1ndzriOUxDuMU/6E4TOfsXSfmTFNlfuR4/cAA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewAW/8lfVxIMA8K3o3m+nzCqhDfvHN3W2KIGI0C7204=;
 b=CK2WEqfp3A3P+VAl1p798w3Xen3knFh9mAAyOhaTUm28hPMloSAF+8xjlzaDmbX6zGkzzxS9vgqQyXN7tOVVVVRxRPr1clDU8OsZI9jL2wvkr3sWQ7LLA4UkyL4r3EDOtleR4C4Vu/i2+i2e7ru98TGK3HQIk2OUsxloKLK69jI=
Received: from AM6P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::29)
 by AS2PR08MB9391.eurprd08.prod.outlook.com (2603:10a6:20b:595::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:46 +0000
Received: from AMS1EPF00000048.eurprd04.prod.outlook.com
 (2603:10a6:209:83:cafe::68) by AM6P192CA0016.outlook.office365.com
 (2603:10a6:209:83::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000048.mail.protection.outlook.com (10.167.16.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YpqHoTC2cFbl2WTE5qC8/pkuxPfKn5eXIbQAf2nNZSvC1bKdglkUaaFDGOb42wiQ02BsiF2/1g5E2rZNBSD/2BzwYFTwKMWcS7n2KeRb+nPn5gtIlL1AmcU54Fgi7oPXbSjVrtiAqE8TP76YUrIjHz6gmOi7piMuAvfpYR5NEU1ygVoYSzuQ9nDR4zdLrPrekwETuWtNUGx+BbQXuieRDPS6l0EpAYJqBBel8vzQjGmugO30KSd0ZYtwF4ZSfBvA5n3OnmVnrZFlCJ7ekXKJrtr3xo7A8dKY9fp2MotV7ubrNbWwe8AwGw5KN0hQVph5N76bZP0aarrXqmZ2Ch4tlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewAW/8lfVxIMA8K3o3m+nzCqhDfvHN3W2KIGI0C7204=;
 b=MRIrP25Bc/UCUlQVotrwz1qskMs9MrTnyBirB5HVlQigJCGVekMD+3m1z/Vq3jC87s5uKG1pV+GNXkPVKSo0N+hwlWjKotAgroTWySpQJgzJdMcjFTuY6Sfinw9LkeP6sWZFRPNUIJtLM2fz9EFPQl75SFTzjPbjYvOjqy1Qi07bqPkyH/zkn4p+uYC6Lno/FAw5NkZQVvHTaZhBPKdLpGxBs84P8ZDIa9h8oL+KZz0axIdY0wpsB9CUwDlnsQ2tlbv1InnDva0Ut7BEIAypOoum3ECyanqSYRut6HFiWC7t3zro7pAF/ABXQzcc1xYPpqxc8jBrhSut98Nkwj6C1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewAW/8lfVxIMA8K3o3m+nzCqhDfvHN3W2KIGI0C7204=;
 b=CK2WEqfp3A3P+VAl1p798w3Xen3knFh9mAAyOhaTUm28hPMloSAF+8xjlzaDmbX6zGkzzxS9vgqQyXN7tOVVVVRxRPr1clDU8OsZI9jL2wvkr3sWQ7LLA4UkyL4r3EDOtleR4C4Vu/i2+i2e7ru98TGK3HQIk2OUsxloKLK69jI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:42 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:55:41 +0000
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
Subject: [PATCH v7 23/41] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v7 23/41] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHct7jWwFDRisppFUGXOw3Ne2jocA==
Date: Thu, 19 Mar 2026 15:55:41 +0000
Message-ID: <20260319154937.3619520-24-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AMS1EPF00000048:EE_|AS2PR08MB9391:EE_
X-MS-Office365-Filtering-Correlation-Id: af8cea18-6480-4a6d-add7-08de85d01f52
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 zAunxvBSmMirSQv7/wtZYf6kV5X9ubV6IYpzlUrQ5+n9POzziCT9ehTS6JfMBIad+PNqap1nfGmk+VwlsbDoJ7XEiP1iFDy1s8m3Bi5FNsFt1mUPFiPyn6fzCZuBWxB/1zIYGcG02HllMSx0FFxjXGtxj70KhFJDrifzGzy4BMFW4bJ8gej8d/9/2SnFxztXmKOaDq8dJBPG41m/NYiS4K00rtGkwVIZbERiDEBeD514aZD3SprnJlwcXEzR7IgB3ofy9Kgk+J13fdEiaowwaZAyMvEUc/uleaN3/90GmCUjmLV9F41Ln1yqYSuN/FcJXHQ+UHgHvSCvTamRkUxwcSz6ZyJEpjjtp453W228RPuQCgCGwIxNc8M45fK7iPrXwWrGAVX0Nb3i8s8o8wrF43s6PgSL35m5IUnejcXOGZDLxbiV/iJny2hh03CSoHexGLzzBsIlaqeOK1pZyJ6IwkwwCVzSGOLOV15hqxHuGKqltgk1Xaz8NvcovzQZ61Y+6aI/kcCRXj1SmzGojNrRVXiZxnjaI3TMyEHWkiJ3hblrpgtN/SRWXA/RPYOc0kHtxPzzizsJjrItkkTrds8Oi9cLKVfqivg8hpOaBxCiqIJcxqN/c1RqVCAdC4R1IPEapKroui29OjxwJ325yzN0m++KUu/Y0G030kHYHzEkVxPilkkfcFZvE83sCCtquCwFlZf/m3dJ1RENEZxiEOWs6e0nqqKLyCC+GrCrXdktlojPOU/JN8ioOidBxpnEAxcp73fzLhfl0R5HgyY9+6TO91O+Zh9enzFRtUiQJPvPUrg=
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
 uJ3WaKiQtHE9Wf7rOkIZeXj11cWnzOt1clozSu3HQ+TyRf2D1f/wL8PqgY5MgGhuzhHLhlG8bwazBZkkGVRssIp5jlRT7F9kU20Fcxi+d2lWN/rXrR2YH99OM9tta4SAf8lq1smnfJgq1EPdwDaBkGjTKJKsUwtG5nSG+V6TLUAK0qJHFqOXw3+8A8ENGqDNYes18kN/VqgNMn/L2exvGScRQ58hZC/Z0GkeZ+MV3mZS6/XNevwCDuKbE9E2x+ySivG2U0OIwbdbUrZrnmVmrpGYTA9Y9lvrpGd+H8ZvOI4gsxKUsUbyCT7RPpg0uzTX7L54s9nmIti4WOSJ8nPpQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	302f30a7-e37f-4945-2a28-08de85cff928
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IH9VYHJqlXrI0whBj4aIrIrH5CNCCJn3ugEX5CAgutXT493LUkcT6aa74DWQEWoJRrjApSkwCdkBeSRrUf/R3+pdsBuO7WfG1Yz+inxq6fokYVKa1hpigtDKYc24TolhfckWky2h2zzET7D+oTxazxigmlomPf5GxTY/8LG68H6sDhHLg3EHN9QyY96y20tQYp7iErZy8AmNRqi5IPIijXlPaFDNmeZrjkWjalkdOq2FQpnl0uGM3fZskWcGY++jGvmYOi40/2Zsvug4SLaXy91GkpgDqW88p0lDSQiejVeA8SgC51w92VJBJxERQB4phjSV2nQXVL36uM+VkjaPRiB5RyrBkZhLJdwrFK2+/F1+eqyE0xURfJQoCCT0m4F+ZhR2kvcMWoVBEzsN3qrwRppb60VkJP6zTJNOJNJwKZMpp7ECW8ZchRz9UsbUsBER0voy/1Bn0J5WE87yhKjodtxRMCRM2oCoydi37qe5Q5njxE0lQKzEa86JrFlRI8fL0fkcZ/6eo82u3lek3E4uJaDutJtw9ARP70pU8N4Ar6GBDd4SYwKIAfZ386/zCGA6pmCOAB+UnIAFR0ZyOI3b3rug0T6R+oxNa1p49DMdmsr6+zNNe3PPNIo9FTMcgm3/2UajrtP/JcrBqxGAuhZLnILu5Couf7jDUsv1S2/Xdxzws54skShXhPAEFeyeTx9KGkU0DTUOpbfE4C6yT9UaIgmEfzf0Qzf/xhG/IgQpvOIlsP6dzkSt9L5vBqIa6SoAuiRo76YcyHd5LYohnK7uWg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mr4XSJco96oFXhYmSF5wM4XKo+kfsJ6C8/KszmguwwS9kQLK9jPSof3x/e+0IiL4UqXnRFXSJR9qB5Or9a4rfEkV5yXGjoyyu1O/VeGCaqyG+px6SiFlBfgnRMP4gNzeOeo3bdLS1rLqEMS6F2R8kSRAsRUqbXG/F8NNt//3WRyPM0rbR9HToO778I98etgc5MGVQTrvRTAau5u+odo1CFHRf+gRZ/EXsr/xI5AQB/38QZ7DwVIp9Djl8eVMZlHQ1b+YwLT6jUxAuQzirAs/bewtqo9zvBZpDNIRSXeZ4E1zdw8kPFJ/Zh24Wf31LZJinn/ci37RsJeV+bqgKXKhf/oYjt+OglTzftzbn4Z0miTKDAMLFk1Q82/dDVl/YQnQH9kbY61zflbciHoSop2MpUZ9ZRVlwUwGY68grbwBSNCm5aXQ8eD55jH9yIWKcDBl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:56:45.7268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af8cea18-6480-4a6d-add7-08de85d01f52
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9391

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's priority is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state on WFI entry - this is skipped in general
operation as it isn't required and is rather expensive. If any Enabled
and Pending PPIs are of sufficient priority to be signalled, then
there are pending PPIs. Else, there are not. This ensures that a VPE
is not woken when it cannot actually process the pending interrupts.

As the PPI priorities are not synced back to the KVM shadow state on
every guest exit, they must by synced prior to checking if there are
pending interrupts for the guest. The sync itself happens in
vgic_v5_put() if, and only if, the vcpu is entering WFI as this is the
only case where it is not planned to run the vcpu thread again. If the
vcpu enters WFI, the vcpu thread will be descheduled and won't be
rescheduled again until it has a pending interrupt, which is checked
from kvm_arch_vcpu_runnable().

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 113 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   3 +
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 117 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 014d6fc1d44ac..f0600be619b14 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,37 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 highest_ap, priority_mask;
+
+	/*
+	 * If the guest's CPU has not opted to receive interrupts, then the
+	 * effective running priority is the highest priority. Just return 0
+	 * (the highest priority).
+	 */
+	if (!FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, cpu_if->vgic_vmcr))
+		return 0;
+
+	/*
+	 * Counting the number of trailing zeros gives the current active
+	 * priority. Explicitly use the 32-bit version here as we have 32
+	 * priorities. 32 then means that there are no active priorities.
+	 */
+	highest_ap =3D cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+
+	return min(highest_ap, priority_mask + 1);
+}
+
 /*
  * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
  * hypervisor) handle the pending, active, enable state save/restore, but =
don't
@@ -166,6 +197,84 @@ void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vi=
ntid)
 	kvm_vgic_set_irq_ops(vcpu, vintid, &vgic_v5_ppi_irq_ops);
 }
=20
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state for any inter=
rupts
+ * exposed to the guest (skipping all others).
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 priorityr;
+	int i;
+
+	/*
+	 * We have up to 16 PPI Priority regs, but only have a few interrupts
+	 * that the guest is allowed to use. Limit our sync of PPI priorities to
+	 * those actually exposed to the guest by first iterating over the mask
+	 * of exposed PPIs.
+	 */
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_=
NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+		int pri_idx, pri_reg, pri_bit;
+		u8 priority;
+
+		/*
+		 * Determine which priority register and the field within it to
+		 * extract.
+		 */
+		pri_reg =3D i / 8;
+		pri_idx =3D i % 8;
+		pri_bit =3D pri_idx * 8;
+
+		priorityr =3D cpu_if->vgic_ppi_priorityr[pri_reg];
+		priority =3D field_get(GENMASK(pri_bit + 4, pri_bit), priorityr);
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->priority =3D priority;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority_mask;
+	int i;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/*
+	 * If the combined priority mask is 0, nothing can be signalled! In the
+	 * case where the guest has disabled interrupt delivery for the vcpu
+	 * (via ICV_CR0_EL1.EN->ICH_VMCR_EL2.EN), we calculate the priority mask
+	 * as 0 too (the highest possible priority).
+	 */
+	if (!priority_mask)
+		return false;
+
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_=
NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		bool has_pending =3D false;
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			has_pending =3D (irq->enabled && irq_is_pending(irq) &&
+				       irq->priority <=3D priority_mask);
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		if (has_pending)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
@@ -293,6 +402,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->gicv5_vpe.resident =3D false;
+
+	/* The shadow priority is only updated on entering WFI */
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		vgic_v5_sync_ppi_priorities(vcpu);
 }
=20
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 485a9a3fab8dc..d9ca5509147a9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1219,6 +1219,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return vgic_v5_has_pending_ppi(vcpu);
+
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d90af676d5d06..8f15f7472458e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -365,6 +365,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1
