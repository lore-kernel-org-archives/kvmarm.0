Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013055.outbound.protection.outlook.com [40.107.159.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD83A9D90
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785482546; cv=fail; b=tLGTSW/RhDrrtVsQoJnOOsrYs5ezqY1w8j4gtdEXxgnftqyxRISL0cSVkrHmZw8QODQV48Srh+FspFNqm4XsaNAAuztW1vSjR968aKFqJCySmf/+VkNPk5NkSt5DJVAZBSCe7JHhG73NwKxi97WqhNTmG9jMN/w9Km4Cmo/iH/k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785482546; c=relaxed/simple;
	bh=paqgFsVi9nCAeaVf/bNTCfAATwactx1KU3m9+NWFwOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ny9uVPrbKzZTFZWP04KGkQ50GVR5H1S2+oK/Cn2NnowGYBYKctzHEEr/Flg1hDb2x7jK+G3CiYZXyABiH20Jvkm/gBcscWOyZZiRv8JxP8lNrLeziTanI6QebBMKgEwm0/ppxX6z35f4N6g+/XtxpTemh9PEgiWGka18+U7l3ts=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cvvMAkEI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cvvMAkEI; arc=fail smtp.client-ip=40.107.159.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cvvMAkEI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cvvMAkEI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MMYWAN9CtwcubwDKuU+rmuCOmd1C0AqeD0YWqSuKybOYZHhtppjRoD9Mg/4COesVvH9scoM2NI0twkSaa/NkT9qzwy4mgfEC5LOWUyPLEQHMgdY3XX7+QWPNW017FIPQ0tMMQi+fJ3bxSERGI628oaRhHUvkRNfgOzAMGOnw/mV2k95gtUKt0obrxkYxVd/Y7SBAV7olWDw8HOU/1/F30obZNZjKNoI+gMWln/OYq7ASnIgROg8l/euAdzBBcbZ91veAf1exgsVBW+46BocbsF3r1OUix+mfrNQ894M/beYQ5WGEhCmKJDCUlOZFFVu6CVbsdY2GkODdsSYms+Kedg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paqgFsVi9nCAeaVf/bNTCfAATwactx1KU3m9+NWFwOk=;
 b=LwWMQg7DolKoXWZnpUeS3Nc8aC/ZBymm7ssTOB/HxuwZLLV5r8LV3ysWfbMQEQMA8Bt2kHrZl7amSgB5ipKto/vbjXYutsC4rWzWzgRWeiApWcPUxX3iHmBx1btnH1NNgLhUn/leNpfrxq+FwzNbY4UbqqIGZYgpe8x9RoJLxnrdGNynBKt8LSJHAVMal8IF3+oMNZ0UrToH8vLNWUEEGLqsG7Rr1aBxudxqGOUZMGFbvaVrQVA9lRIUKuB/O6TxRtRyTOsJIMIdlhbfbftdzperJAdIwxPYFo89DkVq+AIJqRRyeswIV2cqScdF8EPacQgedgabmG4b+rMT9D39FA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paqgFsVi9nCAeaVf/bNTCfAATwactx1KU3m9+NWFwOk=;
 b=cvvMAkEIbKJ/vTNTFuFCUon4fGIIee/b7YYNf39LhIkI6b8sJFCRLE/Euqx87yseBqpBpUF5M9kAilzUv89ODgmZmyEWUZ2NQ/VSwrYdPrWPGsJoh5CF57sYiXR7Fqd5wNDr2EAm+mjIRv/IRPar0YanXYEEU7PYYfVyse+5zUM=
Received: from DUZPR01CA0300.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::24) by PAWPR08MB10091.eurprd08.prod.outlook.com
 (2603:10a6:102:366::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 07:22:10 +0000
Received: from DU6PEPF00009526.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::43) by DUZPR01CA0300.outlook.office365.com
 (2603:10a6:10:4b7::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 07:22:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009526.mail.protection.outlook.com (10.167.8.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via
 Frontend Transport; Fri, 31 Jul 2026 07:22:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xu1wyM0xnwYuCMzYFVvYawZ49TZJdxTRwdvNtcAnNk/ImOHnf/i8BfizPq84XZUZIDQv+AnNIXwTt7EowJciaCtSh2hnxjqzHV2xfAwtMRGXbw7J5mOwqxMhHuvib5+8rs4ZDlQdUd4y3TGqCsVhHQ1E90UvxyZl7SuX6MzGJJridvao67kKjGwjY/GE8raMHZo58e6NMXgFbWEZYl+mMxEHY8ni9lo3vky0hM90y7qedhg4/SviKtl2DmHOtrKI/1S0fQNsM/rAHS76T3+zeGSInisyDr8kcYFJc6ko2TjHtE1M9fg2QU+61+/POAcfpnd9Yne3u/cnXxNQYI1kCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paqgFsVi9nCAeaVf/bNTCfAATwactx1KU3m9+NWFwOk=;
 b=KYb0jpHjOAOZQA4vFMdBxanP+SgmF0wBXoFIym69pU6hD3BTqdcEGh7tEbDr6iJNUdn5tPj6+DLq48Xsg0MCYkoFxb7Cxmqfyi6+sJ4sJJeMknRkPEoMG+1H0N7EJBI6mA6PM+I2B6hQHUiASVNJyP9N8RCpt5VlNeRyOxkGiHzxKCI62ezuLE8qXduPU1TXUd4E/jwR/kWYIMwvG0YoXPa4+pohmoVKRa2sqzoVm/toncYVVObHVaM5ox+XDzLsq/hRH3kDgT8ol89mpCINQTzpAnC59kLxn+codUS7/AV2qXdP3Atj1tdIwLlJJGf8WBX9LRTITSBuuzTC8OclTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paqgFsVi9nCAeaVf/bNTCfAATwactx1KU3m9+NWFwOk=;
 b=cvvMAkEIbKJ/vTNTFuFCUon4fGIIee/b7YYNf39LhIkI6b8sJFCRLE/Euqx87yseBqpBpUF5M9kAilzUv89ODgmZmyEWUZ2NQ/VSwrYdPrWPGsJoh5CF57sYiXR7Fqd5wNDr2EAm+mjIRv/IRPar0YanXYEEU7PYYfVyse+5zUM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PAWPR08MB11523.eurprd08.prod.outlook.com (2603:10a6:102:50a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 07:21:07 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:21:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Topic: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdG1oPG3RMJAfolkyg5EHOLdLQgbZ9+xSAgAlIg4A=
Date: Fri, 31 Jul 2026 07:21:07 +0000
Message-ID: <3a5fe868fee31b62e66f7dc19865a83cdfadf6de.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-4-sascha.bischoff@arm.com>
	 <874ihnquni.wl-maz@kernel.org>
In-Reply-To: <874ihnquni.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PAWPR08MB11523:EE_|DU6PEPF00009526:EE_|PAWPR08MB10091:EE_
X-MS-Office365-Filtering-Correlation-Id: 16454df2-d425-449f-df22-08deeed46f62
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|11063799006|5023799004|56012099006|3023799007|4143699003|10067099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xwTZRB6ymeZ+pePRoOsxIZ1l0/noh43m6ov5KdhMTvVwVZ38dKSQPiuTUegqgcWdWU6CeMAYElzNUc1ICvj4aHaB27Y1OCaBetEWsWfbXRUG9P9krAZyTT1GrIKuNzt/cEzi0Vb+3w/tRqs5vNCfLMxoPWlzqneGUlVzjbxL7Qad35og5bl7+KKDlYCGQBW2U+5sHUS8gYTyY1FnYU8GQBFsrNogwuxevEK+LMuB34fc6C13UkE8YBumCIZo73Ey6DbYSeSiuwm8+8W+VRmd9H/zmx5mOCgirM9p+lFGbUPiELp5YagukIDqcEzxTUj2Ucrv/RQbxfMnY/vLoIXnvLccLg4V3Bqa15phC84xt9MfIc6uhmCLxgflBVnryQQKbEeX3t+CaB8fLdQambUoVFwn4EQ9f59DfEJz2JDSJBKFGVPmYTMMEv/9qXPOy6mlYvcc6L+0ICLal23NTvOLa1UiTU1gfRYlkbdVTSrYOzWCa7BKthNIL/8SWy4pzKNrp/8serykVK535OEfO2KWHNN40O/gdxG+sfi63asXOYj0hyry1TVvw3pbu/V0uCmhBGh5iDywRtyuYK0BU4g5OcLnFoNU8zlkwLOAIePhogk2Ye3MYN2OrvYNJy2JIvqb0bZRdc4B5+jD3SEXvQPSI3y9AORP6V+tScKHKqmWio9WLz1sOFYQsM2pNh7+v+L0CEhEUqXkJnjD+rjEaHB9eAULKdswRmcDDhdEbRpFnSE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(11063799006)(5023799004)(56012099006)(3023799007)(4143699003)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F5BCC35D1FFBA468A248AE2D3492604@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ebbjEuEsAC0t/YKhFHv3IQBX5UsG9cQY4rS/HUbJ9Llj94idfX3f+VRs+ekhwHT5PyfLxh4qHg5pm/VL0XlT5HZVJ53AhO4VGZCg9AUg4olWe5v1+0P3IMShPIY2KmR8rIkVUdNr+2zHXnKtqh5AnuqnIixSKvTnwVt3RrUS/BZIPVJco+VpYRSR8v3QfHGckqF/MJpRm9L8DrTb+Ou6CINDSaO2vHlrgemNnOKk18IREgGvlBxk7p+7Rdb+aiKmG3SeOY6ZNHrAxKozdHto8ZyZG3xU1oqTHr9c5w1ZJaRm6WGKYyoR1RAGck+uZTPkZ7Qwi2tmsHH4rUuahdcM9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11523
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	949edafb-99ee-490c-2a4a-08deeed449f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|23010399003|376014|14060799003|1800799024|82310400026|6133799003|10067099003|56012099006|5023799004|11063799006|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	etHzHgHPX4DErHTWm5JvQdX95XRmuFzPEEKlWoCjw1AO0tkTAn0obOHaRae2yFPiI1G1bg7Fe1YXWda0Jg+5Kl7fthKpMiZk4uT01bOSEVf7UquxZdn6kd4lKZ/XhIUcoLGYrzxyBnOMq1gNEx/mpa8U3fZDaUN1X7Lppqtv2Akeen2ddxQGDIr5avGdOjD36SHBzULZwYQn1J8anes6BhHncBq26deib6LKPNsJz7I15ElQ0zAsVpKgeMOGUkPzewZwnWmClRqqjuck8MsdULTx7SYA2B40RpsE/Aw5f7+hmaOj5/CxSC/CH00MpyguHzYHdkq+KFj6tamL14OHiyAt0WL+GIQRQ3aALexf94gX2XnllCDI764sg2iHJHwqoHJfSBJleis9BMqSa4J2sumJAOt6bHTQdga0WNHkK/rFyJBB3Svfjo5GMO31dpZXLHAWqbnSI0MfbhLeOU2j8Lv6aeMEqIN0U7j20uSM0a+03pFsjnRki1sHEhi2MCCqQoX2znGaNm//66AKBrYAGcm45ovZMjyH8jzv2ufNGw0KpbT4jbfPjXGefzzU5E3vXiKOihBd+udjmFvX0B2a2Ab3q1vjHTnJbJPCp/NKv+iZMfeN6N1fgXPosEe6CRqL+m/ss6B2RnS1xkO7YdWWlKg/rbj+41kRtw1t4OOg3OLQCiffqNVRN8feeFdlkXlV2WQBgq+W6LADaphr2Mkypw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(23010399003)(376014)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HUohFW9Yy6NbS0F4npHfBO500/HD6eJQg6pE+Vxc7DI2/R6AYqEY9e2130BD/skAM7KwXbrqz33bfRYNA53fcZ/qIBAy4dJ9BdT6d4DMKOj57o4xdCyeY296nNCsvX8zo6nKCCv6oQQbwR0naKftDoaqQDnSVaTVrHDFN40uxdbmPLFuq8Qt/ereiRtcZy6fBlFMz9XsMYursMzANOTfNK4JEA2BWpJkxWzQLz8Cfu9DkVh/EN1ZeRLXVkoyGIozfE3QkLN+keMiD12fasUlBQ2YLPF8iAU8LETkgqbSSH75aw8IJgo57EJ951xFsLvQ9H6qnK6BhQigUxbhK/DdsYpewCZVh9tztqlDwRMWkxOfi/n1WFbtVOPIBmKQBGXdkZFjMpfN0yd8i103HXON1JN1LilUmIGPxLy9JoRgQycCToNMiLYOYXUJb0QWpLsD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 07:22:10.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16454df2-d425-449f-df22-08deeed46f62
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10091

T24gU2F0LCAyMDI2LTA3LTI1IGF0IDEwOjM1ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMjQgSnVsIDIwMjYgMTE6NDk6MTEgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IERldmljZS10cmVlIGJh
c2VkIEdJQ3Y1IHByb2JpbmcgYWxyZWFkeSBwYXNzZXMgdGhlIElSUyBkZXRhaWxzIGFuZA0KPiA+
IG1haW50ZW5hbmNlIGludGVycnVwdCB0byBLVk0sIGJ1dCB0aGUgQUNQSSBwYXRoIG9ubHkgaW5p
dGlhbGlzZXMNCj4gPiB0aGUNCj4gPiBpcnFjaGlwIGFuZCBpbnN0YWxscyB0aGUgQUNQSSBJUlEg
bW9kZWwuIEFzIGEgcmVzdWx0LCBLVk0gbmV2ZXINCj4gPiBzZWVzDQo+ID4gdGhlIEdJQ3Y1IGhv
c3QgaW5mb3JtYXRpb24gcmVxdWlyZWQgdG8gcHJvYmUgdGhlIHZHSUMgb24gQUNQSQ0KPiA+IHN5
c3RlbXMuDQo+ID4gDQo+ID4gQWRkIHRoZSBBQ1BJIGVxdWl2YWxlbnQgb2YgdGhlIERUIEtWTSBz
ZXR1cC4gUGFyc2UgdGhlIE1BRFQgR0lDQw0KPiA+IGVudHJpZXMgZm9yIHRoZSBtYWludGVuYW5j
ZSBpbnRlcnJ1cHQsIHJlcXVpcmUgYWxsIHJlbGV2YW50IGVudHJpZXMNCj4gPiB0bw0KPiA+IGFn
cmVlLCByZWdpc3RlciB0aGUgaW50ZXJydXB0IGFzIGEgR0lDdjUgUFBJLWVuY29kZWQgR1NJLCBh
bmQgcGFzcw0KPiA+IHRoZQ0KPiA+IHJlc3VsdGluZyBJUlEgdG9nZXRoZXIgd2l0aCB0aGUgSVJT
IGJhc2UgYW5kIGNvaGVyZW5jeSBpbmZvcm1hdGlvbg0KPiA+IHRvDQo+ID4gS1ZNLiBOYXRpdmUg
R0lDdjUgZG9lcyBub3QgcmVxdWlyZSBhIG1haW50ZW5hbmNlIGludGVycnVwdCB1bmxlc3MNCj4g
PiB0aGUNCj4gPiBsZWdhY3kgR0lDdjMtY29tcGF0aWJsZSBDUFUgaW50ZXJmYWNlIGlzIHByZXNl
bnQsIHNvIHByZXNlcnZlIHRoZQ0KPiA+IGV4aXN0aW5nIG5vLW1haW50ZW5hbmNlLUlSUSBoYW5k
bGluZyBmb3IgdGhhdCBjYXNlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12NS5jIHwgMTAwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCspLCA0IGRlbGV0
aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12
NS5jIGIvZHJpdmVycy9pcnFjaGlwL2lycS0NCj4gPiBnaWMtdjUuYw0KPiA+IGluZGV4IGU3YTdh
ZWRjZmFmNzguLjBkOTA2NzVmYjMxOWIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlw
L2lycS1naWMtdjUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMNCj4g
PiBAQCAtMTEyNiw3ICsxMTI2LDcgQEAgc3RhdGljIHZvaWQgZ2ljdjVfc2V0X2NwdWlmX2lkYml0
cyh2b2lkKQ0KPiA+IMKgI2lmZGVmIENPTkZJR19LVk0NCj4gPiDCoHN0YXRpYyBzdHJ1Y3QgZ2lj
X2t2bV9pbmZvIGdpY192NV9rdm1faW5mbyBfX2luaXRkYXRhOw0KPiA+IMKgDQo+ID4gLXN0YXRp
YyB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9ub2RlICpu
b2RlKQ0KPiA+ICtzdGF0aWMgdm9pZCBfX2luaXQgZ2ljX3NldHVwX2t2bV9pbmZvKHVuc2lnbmVk
IGludCBtYWludF9pcnEpDQo+ID4gwqB7DQo+ID4gwqAJc3RydWN0IGdpY3Y1X2lyc19jaGlwX2Rh
dGEgKmlyc19kYXRhID0NCj4gPiBnaWN2NV9pcnNfZ2V0X2NoaXBfZGF0YSgpOw0KPiA+IMKgDQo+
ID4gQEAgLTExMzcsMTcgKzExMzcsMTkgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+ID4gZ2ljX29m
X3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoAkgKi8NCj4g
PiDCoAlpZiAoIWdpY3Y1X2dsb2JhbF9kYXRhLnZpcnRfY2FwYWJsZSkgew0KPiA+IMKgCQlwcl9p
bmZvKCJHSUMgaW1wbGVtZW50YXRpb24gaXMgbm90IHZpcnR1YWxpemF0aW9uDQo+ID4gY2FwYWJs
ZVxuIik7DQo+ID4gLQkJcmV0dXJuOw0KPiA+ICsJCWdvdG8gb3V0X2Rpc3Bvc2VfbWFpbnRfaXJx
Ow0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IC0JZ2ljX3Y1X2t2bV9pbmZvLnR5cGUgPSBHSUNfVjU7
DQo+ID4gKwlpZiAoV0FSTl9PTighaXJzX2RhdGEpKQ0KPiA+ICsJCWdvdG8gb3V0X2Rpc3Bvc2Vf
bWFpbnRfaXJxOw0KPiA+IMKgDQo+ID4gKwlnaWNfdjVfa3ZtX2luZm8udHlwZSA9IEdJQ19WNTsN
Cj4gPiDCoAlnaWNfdjVfa3ZtX2luZm8uZ2ljdjVfaXJzLmJhc2UgPSBpcnNfZGF0YS0+aXJzX2Jh
c2U7DQo+ID4gwqAJZ2ljX3Y1X2t2bV9pbmZvLmdpY3Y1X2lycy5ub25fY29oZXJlbnQgPSAhIShp
cnNfZGF0YS0NCj4gPiA+ZmxhZ3MgJiBJUlNfRkxBR1NfTk9OX0NPSEVSRU5UKTsNCj4gPiDCoA0K
PiA+IMKgCS8qIEdJQyBWaXJ0dWFsIENQVSBpbnRlcmZhY2UgbWFpbnRlbmFuY2UgaW50ZXJydXB0
ICovDQo+ID4gwqAJZ2ljX3Y1X2t2bV9pbmZvLm5vX21haW50X2lycV9tYXNrID0gZmFsc2U7DQo+
ID4gLQlnaWNfdjVfa3ZtX2luZm8ubWFpbnRfaXJxID0gaXJxX29mX3BhcnNlX2FuZF9tYXAobm9k
ZSwgMCk7DQo+ID4gKwlnaWNfdjVfa3ZtX2luZm8ubWFpbnRfaXJxID0gbWFpbnRfaXJxOw0KPiA+
IMKgDQo+ID4gwqAJLyoNCj4gPiDCoAkgKiBXZSByZXF1aXJlIGFuIE1JIGlmIHdlIGhhdmUgbGVn
YWN5IHN1cHBvcnQsIGJ1dCBkb24ndCwNCj4gPiBvdGhlcndpc2UuDQo+ID4gQEAgLTExNjIsMTEg
KzExNjQsMTAwIEBAIHN0YXRpYyB2b2lkIF9faW5pdA0KPiA+IGdpY19vZl9zZXR1cF9rdm1faW5m
byhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUpDQo+ID4gwqAJCWdpY192NV9rdm1faW5mby5ub19t
YWludF9pcnFfbWFzayA9IHRydWU7DQo+ID4gwqANCj4gPiDCoAl2Z2ljX3NldF9rdm1faW5mbygm
Z2ljX3Y1X2t2bV9pbmZvKTsNCj4gPiArCXJldHVybjsNCj4gPiArDQo+ID4gK291dF9kaXNwb3Nl
X21haW50X2lycToNCj4gPiArCWlycV9kaXNwb3NlX21hcHBpbmcobWFpbnRfaXJxKTsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgX19pbml0IGdpY19vZl9zZXR1cF9rdm1faW5mbyhz
dHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUpDQo+ID4gK3sNCj4gPiArCS8qIEdJQyBWaXJ0dWFsIENQ
VSBpbnRlcmZhY2UgbWFpbnRlbmFuY2UgaW50ZXJydXB0ICovDQo+ID4gKwlnaWNfc2V0dXBfa3Zt
X2luZm8oaXJxX29mX3BhcnNlX2FuZF9tYXAobm9kZSwgMCkpOw0KPiA+ICt9DQo+ID4gKw0KPiA+
ICsjaWZkZWYgQ09ORklHX0FDUEkNCj4gPiArc3RydWN0IGdpY3Y1X2FjcGlfa3ZtX2luZm8gew0K
PiA+ICsJdTMyIG1haW50X2lycTsNCj4gPiArCWludCBtYWludF9pcnFfbW9kZTsNCj4gPiArfTsN
Cj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgZ2ljdjVfYWNwaV9rdm1faW5mbyBhY3BpX3Y1X2t2
bV9pbmZvIF9faW5pdGRhdGE7DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IF9faW5pdCBnaWNfYWNw
aV9wYXJzZV92aXJ0X21hZHRfZ2ljYyh1bmlvbg0KPiA+IGFjcGlfc3VidGFibGVfaGVhZGVycyAq
aGVhZGVyLA0KPiA+ICsJCQkJCQljb25zdCB1bnNpZ25lZA0KPiA+IGxvbmcgZW5kKQ0KPiA+ICt7
DQo+ID4gKwlzdHJ1Y3QgYWNwaV9tYWR0X2dlbmVyaWNfaW50ZXJydXB0ICpnaWNjID0NCj4gPiAr
CQkoc3RydWN0IGFjcGlfbWFkdF9nZW5lcmljX2ludGVycnVwdCAqKWhlYWRlcjsNCj4gPiArCXN0
YXRpYyBpbnQgZmlyc3RfbWFkdCA9IHRydWU7DQo+ID4gKwlpbnQgbWFpbnRfaXJxX21vZGU7DQo+
ID4gKw0KPiA+ICsJaWYgKCEoZ2ljYy0+ZmxhZ3MgJg0KPiA+ICsJwqDCoMKgwqDCoCAoQUNQSV9N
QURUX0VOQUJMRUQgfA0KPiA+IEFDUElfTUFEVF9HSUNDX09OTElORV9DQVBBQkxFKSkpDQo+ID4g
KwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJbWFpbnRfaXJxX21vZGUgPSAoZ2ljYy0+ZmxhZ3Mg
JiBBQ1BJX01BRFRfVkdJQ19JUlFfTU9ERSkgPw0KPiA+ICsJCQkgQUNQSV9FREdFX1NFTlNJVElW
RSA6DQo+ID4gQUNQSV9MRVZFTF9TRU5TSVRJVkU7DQo+ID4gKw0KPiANCj4gVGhpcyBsb29rcyB3
cm9uZywgYXMgdGhlIE1JIGNhbm5vdCBiZSBlZGdlLXRyaWdnZXJlZC4gVGhpcyBpcw0KPiBjYXJn
by1jdWx0ZWQgZnJvbSB0aGUgR0lDdjMgY29kZSwgd2hpY2ggaXMganVzdCBhcyBidWdneSAoSSds
bCBnbyBhbmQNCj4gY2xlYW4gaXQgdXApLg0KPiANCj4gVGhpcyBzaG91bGQgc2ltcGx5IGJlIGln
bm9yZWQsIGFuZCB0aGUgZXhpc3RlbmNlIG9mIHRoZSBmaWVsZCBzaG93cw0KPiBob3cgbGl0dGxl
IHVuZGVyc3RhbmRpbmcgb2YgdGhlIGFyY2hpdGVjdHVyZSB0aGUgQUNQSSB6ZWFsb3RzIGhhdmUu
DQoNCkhhdmUgZG9uZSB0aGF0LCBhbmQgaGF2ZSBicm9hZGx5IG1hdGNoZWQgeW91ciBHSUN2MyBj
aGFuZ2VzLg0KDQo+IA0KPiA+ICsJaWYgKGZpcnN0X21hZHQpIHsNCj4gPiArCQlmaXJzdF9tYWR0
ID0gZmFsc2U7DQo+ID4gKw0KPiA+ICsJCWFjcGlfdjVfa3ZtX2luZm8ubWFpbnRfaXJxID0gZ2lj
Yy0+dmdpY19pbnRlcnJ1cHQ7DQo+ID4gKwkJYWNwaV92NV9rdm1faW5mby5tYWludF9pcnFfbW9k
ZSA9IG1haW50X2lycV9tb2RlOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsNCj4g
PiArCS8qIFRoZSBtYWludGVuYW5jZSBpbnRlcnJ1cHQgbXVzdCBiZSB0aGUgc2FtZSBmb3IgZXZl
cnkNCj4gPiBHSUNDIGVudHJ5LiAqLw0KPiA+ICsJaWYgKGFjcGlfdjVfa3ZtX2luZm8ubWFpbnRf
aXJxICE9IGdpY2MtPnZnaWNfaW50ZXJydXB0IHx8DQo+ID4gKwnCoMKgwqAgYWNwaV92NV9rdm1f
aW5mby5tYWludF9pcnFfbW9kZSAhPSBtYWludF9pcnFfbW9kZSkNCj4gPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gDQo+IFNpbWlsYXJseSwgdGhpcyBzZWNvbmQgY2hlY2sgc2hvdWxkIGJlIGRyb3Bw
ZWQuIFdlJ3JlIG5vdCBpbiB0aGUNCj4gYnVzaW5lc3Mgb2YgdmFsaWRhdGluZyBBQ1BJIHRhYmxl
cy4gUHJpbnQgYSBGV19CVUcgd2FybmluZyBpZiB5b3UNCj4gd2FudCwgYnV0IHRoYXQncyBhbGwg
dGhhdCBuZWVkcyBkb2luZywgYW5kIHdlIGRvbid0IG5lZWQgdG8gc2NyZXcgdGhlDQo+IHVzZXIg
b3ZlciB0aGUgRlcncyBicm9rZW5uZXNzLg0KDQpPSywgZG9uZS4gSSd2ZSBsZWZ0IGEgd2Fybmlu
ZywgYnV0IG90aGVyd2lzZSBjb250aW51ZS4NCg0KPiANCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGJvb2wgX19pbml0IGdpY19hY3BpX2NvbGxlY3Rf
dmlydF9pbmZvKHZvaWQpDQo+ID4gK3sNCj4gPiArCWludCBjb3VudDsNCj4gPiArDQo+ID4gKwlj
b3VudCA9DQo+ID4gYWNwaV90YWJsZV9wYXJzZV9tYWR0KEFDUElfTUFEVF9UWVBFX0dFTkVSSUNf
SU5URVJSVVBULA0KPiA+ICsJCQkJwqDCoMKgwqDCoA0KPiA+IGdpY19hY3BpX3BhcnNlX3ZpcnRf
bWFkdF9naWNjLCAwKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gY291bnQgPiAwOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBfX2luaXQgZ2ljX2FjcGlfc2V0dXBfa3ZtX2luZm8odm9p
ZCkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQgaW50IG1haW50X2lycSA9IDA7DQo+ID4gKwlpbnQg
aXJxOw0KPiA+ICsNCj4gPiArCWlmICghZ2ljX2FjcGlfY29sbGVjdF92aXJ0X2luZm8oKSkgew0K
PiA+ICsJCXByX3dhcm4oIlVuYWJsZSB0byBnZXQgaGFyZHdhcmUgaW5mb3JtYXRpb24gdXNlZA0K
PiA+IGZvciB2aXJ0dWFsaXphdGlvblxuIik7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+
ICsNCj4gPiArCWlmIChhY3BpX3Y1X2t2bV9pbmZvLm1haW50X2lycSkgew0KPiA+ICsJCWlycSA9
IGFjcGlfcmVnaXN0ZXJfZ3NpKE5VTEwsDQo+ID4gYWNwaV92NV9rdm1faW5mby5tYWludF9pcnEs
DQo+ID4gKwkJCQkJYWNwaV92NV9rdm1faW5mby5tYWludF9pcnENCj4gPiBfbW9kZSwNCj4gPiAr
CQkJCQlBQ1BJX0FDVElWRV9ISUdIKTsNCj4gDQo+IEp1c3QgaGFyZGNvZGUgdGhlIHRyaWdnZXIg
bW9kZSBoZXJlLg0KDQpEb25lLg0KDQo+IA0KPiA+ICsJCWlmIChpcnEgPiAwKQ0KPiA+ICsJCQlt
YWludF9pcnEgPSBpcnE7DQo+ID4gKwkJZWxzZQ0KPiA+ICsJCQlwcl93YXJuKCJGYWlsZWQgdG8g
cmVnaXN0ZXIgR1NJIGZvciBHSUN2NQ0KPiA+IG1haW50ZW5hbmNlIElSUVxuIik7DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJZ2ljX3NldHVwX2t2bV9pbmZvKG1haW50X2lycSk7DQo+ID4gwqB9DQo+
ID4gKyNlbmRpZg0KPiANCj4gbml0OiBhZGQgJy8vIENPTkZJR19BQ1BJJyBoZXJlLCBmb3IgY29u
c2lzdGVuY3kuDQoNCkFuZCBkb25lLg0KDQo+IA0KPiA+IMKgI2Vsc2UNCj4gPiDCoHN0YXRpYyBp
bmxpbmUgdm9pZCBfX2luaXQgZ2ljX29mX3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9k
ZQ0KPiA+ICpub2RlKQ0KPiA+IMKgew0KPiA+IMKgfQ0KPiA+ICsNCj4gPiArI2lmZGVmIENPTkZJ
R19BQ1BJDQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCBfX2luaXQgZ2ljX2FjcGlfc2V0dXBfa3Zt
X2luZm8odm9pZCkNCj4gPiArew0KPiA+ICt9DQo+ID4gKyNlbmRpZg0KPiA+IMKgI2VuZGlmIC8v
IENPTkZJR19LVk0NCj4gPiDCoA0KPiA+IMKgc3RhdGljIGludCBfX2luaXQgZ2ljdjVfaW5pdF9j
b21tb24oc3RydWN0IGZ3bm9kZV9oYW5kbGUNCj4gPiAqcGFyZW50X2RvbWFpbikNCj4gPiBAQCAt
MTI2NSw2ICsxMzU2LDcgQEAgc3RhdGljIGludCBfX2luaXQgZ2ljX2FjcGlfaW5pdCh1bmlvbg0K
PiA+IGFjcGlfc3VidGFibGVfaGVhZGVycyAqaGVhZGVyLCBjb25zdCB1bnNpZw0KPiA+IMKgCQln
b3RvIG91dF9pcnM7DQo+ID4gwqANCj4gPiDCoAlhY3BpX3NldF9pcnFfbW9kZWwoQUNQSV9JUlFf
TU9ERUxfR0lDX1Y1LA0KPiA+IGdpY192NV9nZXRfZ3NpX2RvbWFpbl9pZCk7DQo+ID4gKwlnaWNf
YWNwaV9zZXR1cF9rdm1faW5mbygpOw0KPiA+IMKgDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqAN
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANClRoYW5rcywNClNhc2NoYQ0K
