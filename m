Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012055.outbound.protection.outlook.com [52.101.66.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AD22DCBE0
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758650758; cv=fail; b=FAKDfk+ToCW+dAEyygHnzzIZpY9SB/hiri/EhQwuq9qn3yMkNhcKwo/fJ84w3goseXwM4vBL7y5lrn2AceS9sbGFYxAkvetNppSpeBv9wUHADzbYXBpL01VmCu/y4RnyyUpg0uIyAuBecFvwHIxBT3mGEU02/Kd6tGtNbOpwYfQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758650758; c=relaxed/simple;
	bh=3rNYa/hfeD2gHMuNXPkt6/ScJ2nAMzK+LddXksXWzMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=enfjqqA7ToGjOZYkrX1acIPVnVGeXYRfDM+f3g/wGCAw6giAOusBKysd1Prwus1S/DKQ8bQHidywcp/9Fs6u8YE5DVz3yC8SGPIUwXI2Wv0Q71sLDblKE7ZpRhUQhfGaB3685e5XSdUPBfDWYIQ5j0sBnkrCNF6BypBBw493uZ4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lgZ9jPmV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lgZ9jPmV; arc=fail smtp.client-ip=52.101.66.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lgZ9jPmV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lgZ9jPmV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GjKmAiisz0D7TqCdFny5jlDIARdIkFqUO/PCcwxovY+7ixY2W/A9Eus5dHMHBwjg4bFiD4yJCtXQp7TW4dul5DnBWDaa5GeDTJ8XqBRInMIYmYxVpa/eLlIxIPYnLsJUIzd+8jjsvSNyTzjJHxROIxKsECDJJ0yApY+kZUjYkBqWHhTZrjC+uGW088ciyZ8t07YMbHpQ48GXkjvbkc+6LZcx8wLnZsHAWToDS1dIBfzcXy9moczi47slvuF61f6M4BQhiIZJ6RsmP1Aq7daXgsxBlgA0CNbJSiKQjn4krpDcLIHkC78lFjAo564PyIUlwv6DWqJpfwlTR7/K4bsUag==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rNYa/hfeD2gHMuNXPkt6/ScJ2nAMzK+LddXksXWzMI=;
 b=ipvHtYleLoJR76Q/3IJqfsbrGRQWq7FJ3L1efJPq2z2G7OXbAHhYRzHCTCM9k7+93ZPMUk2HcXdRQ3EXUdacpXxZttulGNLWd5aJEygWO7AP98Hvg5olBijswkpwzJ0nHaqhEvle71jv9m3i+Uo5hz2KS6njmDtpufR93ULcdAlqTg+9h40GvvyvKQ7bW+eWWwGH0jPR6kKMd24K7idv1CGQWNzIsE3Xj3TW83swq9PaPK0T8xjn1FAHB4ziOqQDhNu0aWnQx46khSuXjrHrjiBpnrtF1bcBKQCuUwtFE4ge4FIBKnX3niy9MiZ9CFtlsPEIVd8AIrvmh5Puv3yDOQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rNYa/hfeD2gHMuNXPkt6/ScJ2nAMzK+LddXksXWzMI=;
 b=lgZ9jPmV8NsPH10M4ZvCq1ksFDL5bUgu5iWS9ynmy9n38GJUU20KqoQqW0OddJUZfI4rn6zDTNziosPdI8p9N789xqysv9IcfOemGFYiQmEslkMc2CXpgoYieOqdl58r5qagYKnYvxwI20qHdGzSdCzsqeI5gAoFQA8X9L/da6g=
Received: from DB8PR06CA0057.eurprd06.prod.outlook.com (2603:10a6:10:120::31)
 by DU0PR08MB8493.eurprd08.prod.outlook.com (2603:10a6:10:406::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 18:05:53 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::d9) by DB8PR06CA0057.outlook.office365.com
 (2603:10a6:10:120::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 18:05:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 23 Sep 2025 18:05:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=So2q6LUKIZi9n/ASGH8Ecfl3IpkUSEGniRR+WZHfr82vXWQCal/J469UOgqrmscsNYsyVn07eYk/XglRvxvVOkAUteRMNcj23/PhqYwPAJ0PfFTgbG316phKXVBQUx/73w5cJTQcVaBH2ljm/sbHVmJED0OA7+mQhaZM9AQhzW59ZZmAB2wlaBof1As5hVtPb+HBRu5UMjWx2RkrOrlaDCX9LBI0WtOSd4PxAhals8TbkNqcXzBQF59Np1awRD2f4D74Aros7lYampgiwvcMfe+/WWx+KCKjjihFXqFSIW6WPZZ9m08gDBx5rIRkkI5RalgPDZD9XSogRpM3gdM6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rNYa/hfeD2gHMuNXPkt6/ScJ2nAMzK+LddXksXWzMI=;
 b=ucGW+E/8eHgFzmHkdghjYxFuC1TS3fSE5CLpYt4ww+TX0GU4A7fR+eM/4P1kn1QYmtvK9RIp2fs3bEaoew7qdng0OWhm4cYS3AZS5SSMKmTY6EWd0UnoVG4tWrOhBt/FEzuTNonQmtsdyEQFX3UbfxIpVWQjrQbSNIHOXDw5EYYG2+KxdiV9FyJimF82ht6lj2LZtb6Vp88l04qtHRmFYASQ6xs8Rwz1l49JeOora1r3NGxNAR2Zq6MnzGYLAPizG0iuaUt8TENRQe75IGFubRB+4fme9m9xZUbENiCiqxNg9OfLHr74OcKVzwFFR9SpZsJe/PH923TL4aqDGX5r3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rNYa/hfeD2gHMuNXPkt6/ScJ2nAMzK+LddXksXWzMI=;
 b=lgZ9jPmV8NsPH10M4ZvCq1ksFDL5bUgu5iWS9ynmy9n38GJUU20KqoQqW0OddJUZfI4rn6zDTNziosPdI8p9N789xqysv9IcfOemGFYiQmEslkMc2CXpgoYieOqdl58r5qagYKnYvxwI20qHdGzSdCzsqeI5gAoFQA8X9L/da6g=
Received: from DU2PR08MB7256.eurprd08.prod.outlook.com (2603:10a6:10:2d3::21)
 by GV2PR08MB9277.eurprd08.prod.outlook.com (2603:10a6:150:d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 18:05:16 +0000
Received: from DU2PR08MB7256.eurprd08.prod.outlook.com
 ([fe80::2056:69d4:d72d:eb1f]) by DU2PR08MB7256.eurprd08.prod.outlook.com
 ([fe80::2056:69d4:d72d:eb1f%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 18:05:15 +0000
From: Christoffer Dall <Christoffer.Dall@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Alexander Graf <graf@amazon.com>, Priscilla Lam <prl@amazon.com>, Marc
 Zyngier <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"gurugubs@amazon.com" <gurugubs@amazon.com>, "jgrall@amazon.co.uk"
	<jgrall@amazon.co.uk>, Joey Gouly <Joey.Gouly@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Thread-Topic: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Thread-Index: AQHcLGWPlrZ7TD3uxUiTrQ1NdoKaVbSgeNMAgACXj4A=
Date: Tue, 23 Sep 2025 18:05:15 +0000
Message-ID: <71A90F04-2CF2-4FC6-B1D2-AE921BE3802B@arm.com>
References: <86frcd1tp4.wl-maz@kernel.org>
 <20250923082955.66602-1-prl@amazon.com>
 <97759f51-385b-4ce4-8766-d00ed5af580b@amazon.com>
 <c8a8ddbc4b1c53429748d239f2a8461f180a5133.camel@infradead.org>
In-Reply-To: <c8a8ddbc4b1c53429748d239f2a8461f180a5133.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.600.51.1.1)
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7256:EE_|GV2PR08MB9277:EE_|DB1PEPF000509ED:EE_|DU0PR08MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: e3be0a56-833b-4cab-0417-08ddfacbd520
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?c3VwUUZvSC9QcTZQcjZvMjgzM1hYVmJpSU1jQUZqSG45bEx2RFFpQnJRRHl0?=
 =?utf-8?B?YzNqSmJZZnBqMlBYS1p6bFBuQ1M5RGxlZHBFZm53cFFYTmd6R1VGNnZPSzg3?=
 =?utf-8?B?WlFsVys1RTdjTDNnM2JwUkNnbW9mWFRJZDk3SFpyeHdON1hMV0J2UHBZZVdv?=
 =?utf-8?B?bGFkUUh3MHJxY2RVRmFDTStnSEVVWm1VSE9ya3N0ZHhudzAzUWNvbzlFNHRa?=
 =?utf-8?B?VjVOTit1NWc3Qkthc1krTVBUR01xb0JrT01sODNNWm9KbDNnd0VLajJneG5Y?=
 =?utf-8?B?TXo4R1U5UmtpZFZjVkh0a2dxUnBmUTBUbTBYS1R4S25Vc2RPc0w2dGJFVXAw?=
 =?utf-8?B?Q3FCR0hNdzN4cEJzbml1dlNLSUFoUEhXZHJZM2MrVGI5S3NyRVV4M3ZvYUM1?=
 =?utf-8?B?R2Rnekx6YzZVL2gxMXBUZWF0L3FkYk04amhkd0ViNjJEYlpmT1dzcm92QXcy?=
 =?utf-8?B?aW91ZjBycVNKWGdSNnZLb0ppTTdmTmRoeGlHMnJrbTJiQis1NVBJRUFnSWNY?=
 =?utf-8?B?VGhWOWdxS01LMW4rbm4wc2dFZ1VkeThlM3RrcE94Z3Uzb0tzb09kSmdpVTZ2?=
 =?utf-8?B?VnE3ZTMzWDJRY0hyVHcyWk1zREY2OXVtc1BHbEdaTnVLaTk3Sk1QdGlXYXg0?=
 =?utf-8?B?Z3dtOTRyRXNYN1dVajRpUkJ5MW5rTlBaVzFqZUZqenBUQ0JCd0krbTBaa3Ro?=
 =?utf-8?B?NGpKZlJiR0pxNnpwZFBXeEtGVSt2VUM4QVhia1h0YXJUdGZzcEJZd3hGSG53?=
 =?utf-8?B?ZFdLSjdGdWFRRmloVWRWckhaM2ozSW00Ym9UQ1JuTFR3cWJDZmlUWDFUR21p?=
 =?utf-8?B?K1hWN2lvZTQyalhNRlFHVEMrckpndCt2Mmk5Uk1IQ3pKc2R4ZEYwejlWaTB5?=
 =?utf-8?B?Y2pBbm9yZC9VQzA2UGZZa1A2SVpYUmRSbEp2MHZLVGZrdEQvdm0yVDBmSXRG?=
 =?utf-8?B?TUxwcHJqUkxoWUhkT3hVemZhZFplQ0VnU3AzYVdlTUl0NGVKamMrVUlzQW1j?=
 =?utf-8?B?MVFyUXE1RC9vMFRIYnBXcEdyODh5aVhPczBTUmNmUHp3MXl1b2p2RGo4b2Nn?=
 =?utf-8?B?aHdiR3NpSHZtSXFGOXAxTXZrNDAwU3RkUmJ0Z1VKVFNvN1hMWW81RW43dnNk?=
 =?utf-8?B?b1h0OHRQSENpbkRhYW5ZblhBcU9pTnVSOHhtLzlFS1k1andtbEJ0V0tBelMy?=
 =?utf-8?B?R0ZBcTcwQU5OSzRJbFBPT001VXp0czZUc2w5VEtkZ2Zja2IvSjVmUFZTb3V5?=
 =?utf-8?B?QlBkWnYvTHZwM0licmxuVmM2UlAwUGw2bGpKdGhqTStad3JvZXVtSkJsVWVS?=
 =?utf-8?B?cTg2UzJNcmNjQkZaNXNhclhLdmxFeTJOK2JtbFFManZvdjB6Zi9HZmtMMGNO?=
 =?utf-8?B?TVRmaFc2M2pOR0pVWW5tWGtxbS9neWN3c3poUVpjRGgxN0xyRUJsR0RGak84?=
 =?utf-8?B?QVBVNkJjQzVPSmM0U2V0QllKNFd4NG4xRThCQkNvVkE5VmJYaTJRbEJlM01D?=
 =?utf-8?B?WnhsdnM2N0JyV3VVUHh5am45TWNtUEl1YTgzOUx3dHhweVBORTBPa1ViQzV6?=
 =?utf-8?B?SHZEcUR1T3U4NENaaXd1K0FaR0RBWFRSUnE4bFdYTFJHMzUxNEpTNjBsKzVG?=
 =?utf-8?B?UENqSFNySkhkcFM3S0ZETnZIVXhSNWpDaDFzWjd0MWdseUY0dkRpcGczRlJP?=
 =?utf-8?B?aEpvTklMOHY3OGFJUTExM2htUkkxcy9JYVc4dlNjalh3bGlGS0Erc1pqN3NM?=
 =?utf-8?B?T2hqTzg1L3A0T0RjMWZhTFZEbCtKSTRoT2NZU3QzbGZKRzJ3Wi9vNWJja1pD?=
 =?utf-8?B?eUpnRFZYQ1ZKbytNYTloTTJ2T21aRHFzWHlsaWs2WlB0YythRFE1QlpCdjJ3?=
 =?utf-8?B?UWxZa2xXcXppc2dlY0VPcm1udmQ5dTZIS2NVVEt5UFVobDBMUlVtbkc2WkRz?=
 =?utf-8?B?U2Z6aUpkYmExQlZOSUlXaGZuZHAxRVRtTUk0TkJ0RFkvQ0ptTnkyUEllaEVo?=
 =?utf-8?Q?c1Rje8ynD+bMa0pWaZfQy3gh/5+LAs=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7256.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9351E2B44CB6BF4C89E6C41B9E494CA2@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9277
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2dd4085a-a145-41e5-455e-08ddfacbbfc3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|14060799003|35042699022|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SytaYmlzWXNrL3FBVk02Q2RqQU4rL3V5Y282Zy95QU0zTEk2TnhyWnpsazdZ?=
 =?utf-8?B?eGp4UFJnc3piVzhSZjVTQTVnQXpKT01EMHZBQ08yaXVINi9ER2IwOHVQdHFW?=
 =?utf-8?B?VnI1Yk1GRzNvWUxwZUxYTUp4TmlXK0xqM1N5Nmt5aVZLVGt4SG1PZDNJdFNt?=
 =?utf-8?B?eVNRbVB1dlRINllhbEJrVnE0V2hDZkdUbUFWTzJKUjBFQ0doWGlWeWNRSnFZ?=
 =?utf-8?B?UGtvVkJHOUovZlhUdlAvSFhpUTdNNGltUTJtOTYzdlJqRXpZdUV6UytSV3Qr?=
 =?utf-8?B?M1o0RHcyS092ZXJRV2NtTzZrdmljNEp1MlNTL3hnanY0TDlXK2JPREErQnhB?=
 =?utf-8?B?YmtwN0ZUNHNGMHBiK1U4NHVhQlQ0eHpjM0g5SDZoZjJUUnM2OEFibzRPNDJ3?=
 =?utf-8?B?UmswWEZNdm1lOWYvUWdadG5Ja2Y2Z3dHOS8xZzMranJ0K0dFL2pib0dFMGdi?=
 =?utf-8?B?NHA1UjlsbWlnUURKajlTcGVHc2RXZUxkU094UyswSzVwMEJyYUlvdUwwV1VN?=
 =?utf-8?B?cHRrWTB2LzhwK3N3M0Z1QllFV2d1aldmNDZUQUlnNDRRUG0zbExCNTJlS3cz?=
 =?utf-8?B?cUFsVHhQZWtUdnRQOXp3V0lJb3BCNlVISkF0bGhIdHo5TXNSeWNQekdsVyt5?=
 =?utf-8?B?ZkdBWTA5RDZldHVJT09PYXBGV1phN2d5K21HVmFTRWNDZldtRURVZVNCWklB?=
 =?utf-8?B?WmxwT2xLREJHOGFaN3BKVksxTE55aDVYeDZKY1RMQ2JYc0d0NzMyLzZyUElD?=
 =?utf-8?B?UFVSTXFPbVFIdmxncE5aVUhFclBidjJsKzR0dEs1cXF0RjNRZGRUU2N3cWl4?=
 =?utf-8?B?eTE5YXlBbmxqN1oraTFnNzAyTjJRU2dHMlhBNHdFZWJIQUJNM0k0MlliQkgz?=
 =?utf-8?B?RFlkL1AyYkZ0TzZZdHI1SHJRV2dPMmVLQUtmZGE0RVJ1WmN2SzJ3TXlEbDJQ?=
 =?utf-8?B?b3QwV1d2eHBYZ1gwcnJrTHpuYmc0WVJzNGR4Q09ra3RDbWppV1NZYTVTYzBO?=
 =?utf-8?B?OFRHVDVRem5RaGU5VGVERUx4Qy9IZi9WME94TXR4bGJEbmY1RXRYY2dia3ph?=
 =?utf-8?B?cEJIOGFSazBFK2k5VmNwcXZJd1ZpbVF4M1RYemd1YVNZRklVOGtJay9jVU8z?=
 =?utf-8?B?L05wT3lZak4vMm04aWpTd1g5VnJhOU8xNUhCSmhKelBLNE1hdGI3UituTTRO?=
 =?utf-8?B?V0hEeVJiUFg3RnZyNEVxM0FOR1N4V2RvdUhtZWdUMnJ3ZlhoT1dCb2hJWHFy?=
 =?utf-8?B?YXFQQ1U1bUFjaFRTenBybkZMemRBelBWeHRrZ1BiVmV3NEh0cjZRdWs2YjhR?=
 =?utf-8?B?Rk90cDJaUFdUbXNZOVc4TEV1MlREYXRwVEt2Z2tmUDVURkdnSSszNEFJbUdJ?=
 =?utf-8?B?SDZ0MkZ4ZGg4Wmk2WjJLQ08vK3M0K0FYK21FQ21JeHAwa05YODdUUUFycEhL?=
 =?utf-8?B?cHZmbDVTQUtKSTFzK2ViKzBmUnQrekhGOGJDcGpLVkpMUnFQN2VPRFl1S2FE?=
 =?utf-8?B?RDBnVXM1aU1pRnNVaHd0aUR0NUV5Yk9LaXYyTjkzOUcyVjBNVkZkR0FQTndZ?=
 =?utf-8?B?YlVVUVBIOVIrN1Z1YUZqN2lQOWE4eS9Gc3hMcjkxSnZ0Ulp5c0o2MUlTcXJC?=
 =?utf-8?B?NC8zNXJLUXN6SEkvRGZjTXZSc2NQQXZ5Q3Era2R5YnZZN1QyYkFFK1JWTVlY?=
 =?utf-8?B?eHhxU2xhVm90cjhEVDd5aE1HVlE2Rmw5M3BkZUY1aFdJZnVUYjFPY1lVZDlK?=
 =?utf-8?B?d0pIM1pSTnY1OWpRdHdlZXdYN0tQaHY1QVJsdlFWZzB0V21nTnRqdk9NVVdK?=
 =?utf-8?B?T1piakVRRGwrVFRXcW45MXBkaDUwRWpVSEFOb0VROW1aSGhJRkN0a1pyVmRC?=
 =?utf-8?B?NDc4eEFpTHhOTUt0cndHaTJNUm5aeko5ZXBjemVtYk5GT1pqQ0lIcCthMktJ?=
 =?utf-8?B?YnN5bTYvMlM3U3gxa1R5OCtyNzQ5RWxGd2VMN2JheXpkYmVDRXhjNjN6QnVE?=
 =?utf-8?B?dytxcm12dGpoc1owbnE1ek5HM3FlRlRqYkNXWVMvc2dTRFlJNytZNnI2Z3Mw?=
 =?utf-8?B?REkwOEVSZzlXNlZacldQakY1V3pGM3lldStYUT09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(14060799003)(35042699022)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 18:05:51.6426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3be0a56-833b-4cab-0417-08ddfacbd520
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8493

DQoNCj4gT24gMjMgU2VwIDIwMjUsIGF0IDExLjAyLCBEYXZpZCBXb29kaG91c2UgPGR3bXcyQGlu
ZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCAyMDI1LTA5LTIzIGF0IDEwOjM5ICsw
MjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4+IA0KPj4gQWxsIG1vZGVybiBPU3MgY29uc3Ry
YWluIHRoZW1zZWx2ZXMgdG8gb25seSBJU1YgZW5hYmxlZCBNTUlPIA0KPj4gaW5zdHJ1Y3Rpb25z
Lg0KPiANCj4gV2h5PyBTdWNoIGRvZXMgbm90IGFwcGVhciB0byBiZSByZXF1aXJlZCBieSB0aGUg
YXJjaGl0ZWN0dXJlLCBBRkFJQ1Q/DQoNCg0KRllJLCB3ZSBhcmUgaW4gdGhlIHByb2Nlc3Mgb2Yg
Y2xhcmlmeWluZyB0aGlzIGFyZWEgb2YgbGltaXRhdGlvbiB0aGUgYXJjaGl0ZWN0dXJl4oCZcyBz
dXBwb3J0IGZvciB2aXJ0dWFsaXphdGlvbi4NCg0KVGhlcmUgaXMgYSBub3RlIG9uIHRoZSBleHBl
Y3RhdGlvbnMgZm9yIExEUCBhbmQgU1RQIGhlcmU6DQpodHRwczovL2RldmVsb3Blci5hcm0uY29t
L2RvY3VtZW50YXRpb24vMTAyMzc0LzAxMDMvTG9hZHMtYW5kLXN0b3Jlcy0tLWxvYWQtcGFpci1h
bmQtc3RvcmUtcGFpcj9sYW5nPWVuDQoNCg0KVGhhbmtzLA0KQ2hyaXN0b2ZmZXINCg0K
