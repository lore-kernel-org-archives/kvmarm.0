Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011006.outbound.protection.outlook.com [52.101.70.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA40441A785
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101565; cv=fail; b=kZSCvLEiPVa5cFEpiztAVe5bsQWuHALvxncYSNTnzp59efL/Y4/N0AjpUIPvmyV5PnuMf7nWOVfBXc8cTaaB49JV3uyJjh3wLI8XDM9Uef8HRrk33pri2PYVdB7zLrQXufPLzqbk6mFlvFO2TinJshFX4xprCqLG0HWr2XGlcd0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101565; c=relaxed/simple;
	bh=i3ylfEE+Lv9YKPY8/bbHxd9YZGgh0YJojUNbnGEQZ5s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OCnWFhYld/MV6ugxi+WqgA8bn2VvnDVV3H4ShUECoCBJKwGMou/o0YtXO7Mj+TbwuX42j8DJ0yMX2Vy2PIahVbNdEfHUmfPsuVhNLsGIytPW4iRFKM9fi0UIUuQV8sSQBU2cUIVKmyPZclQDn6t4afGJeOFzZDRJ6QGQPAOXZXw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lE8oXAJv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lE8oXAJv; arc=fail smtp.client-ip=52.101.70.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lE8oXAJv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lE8oXAJv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=U1QQz0j3wSO1qOMV+hCat3Ny1vzmXq+z5dZ4BHjWQnCA5pJHrh7dmDNXulpuvj8F7QdKq47h+B4OF9mp3b7tlscTm+6sc7xAzB6vXMyypTJOUECEo3zbqxccFcg1pc+5q7U7Yw67KtRKRwhorFJn529EYZdkoWyK5S3XmlrDzKUWZxr4Rr6et7Pa6wbnR/Vg1y0m3Vu42hZ1anx5krFboKDU1WYvdQzE7b8imyCOLGjENccpJ/V9ghzx0hcFWnJqq1EgETF/BmKnqqimWltxyp170HXehU9XAx8OP82zWJjdb5BZObyK1Rycwr+/6TG/SBE56DMLQB9LhvHyYtRkRA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5rYDFHPT5U3MKicbswy2Tl2GYvfeWYANptdcaD/0o0=;
 b=V2Q1zK6tqvWdIo0XriBDCUUvqKUY+OPYcP2NSDleJMaPGXh9ZQlusLE/FS2FbbdvGAQcOxjx0yPNoD3T74nVDQog94AU8C6HphanTzWVtnr+ycH98L7prBum2LD+I2boeIaqbsofNMGJpwiaS/iGLxcKd7W6xy0+eRxh5Pk03m36QA6Kx41KMiqI/0G0CU67CWdga6iW4xJdiPCSYgSxz1zFumaTkX/Nne97lCAwmUDBKY5qux9pQM5UgnAbedtyiZsLhF4ihCaijrPQj4q9Q2bJwAx1CaNgJVZTB2fy/gTlTK+ouhuywJfDIihU9L7+Y0j9pX9Rbc+2LEfL6yPXdA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5rYDFHPT5U3MKicbswy2Tl2GYvfeWYANptdcaD/0o0=;
 b=lE8oXAJvW0pssWcWetMbENuixiqQ+C3ngCWHsXzEAQm3pns4dta9JjhnTAHiCD6ALrgIeRep1M6By/INZIU1UB73ne0R1N78E/ZuKJ+6Hr3aMJUbQj+hHbr02iiDKbFuQCp0RggCluBtcMHvsLmPYMnkEt0GC0UgwNMgophfhJ0=
Received: from AS4P189CA0010.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::14)
 by GV1PR08MB7706.eurprd08.prod.outlook.com (2603:10a6:150:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:19:16 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::43) by AS4P189CA0010.outlook.office365.com
 (2603:10a6:20b:5d7::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:19:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkngTYx8ftsD9DWe6NnK2woEyJnKDAjyGEwI3RQNZL6AT++Nv4uvpbIAidEv8aUY2QtibuEtEFoRoxBpz2/r7MQ36XjT6ReNd6DmKjL7sL4u+tYza0DxolkJSps+2vzOhsK3kt9yIiNnvLTTm6f7ssmFZ3QE2JX4ZGEoXwyw1ncPWvyo4eZYAclyomZ2+IqwV/4vIpVNZ5zCRX77u1l4giiM6ZBHJ2FPAsJOdj/kAntE6w0TNPYnzI7Y4oC9fsGabrL4SgylqlZp5Jl5UQNOUxHGcPw3ej0E2dIWNJXftp4o2UJvQJkPINgSTW+adHaspmOCNv8TnbYkHwUTuwpLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5rYDFHPT5U3MKicbswy2Tl2GYvfeWYANptdcaD/0o0=;
 b=m7vyJNl8tN4oZLNIpfRxjAVi/imSCaWH0C55v4pook38uuy4BYC62zVeFxcHiKq8ngcWke6UxG2ZRRDVvfO8DRiw66F9/jjukoC94QkC3StSaXCZSsVuiAQrEhRzlTJClR1QwOYT/jHW5ajqftZnswyChgWV2WE76/DSVr2ZClW6Wyb+4TpT0CmkAFvj+lSjD91D3l6Po0CyPiMGn4kVS6NndLWtA8WxVruH8LVn90f1kOiqKoPwKgJJyQaeW3ydfb7oMZRE71IQllCnvHgr6o06znidZ/y/rWBGFsqGK8pXnzdvJ+/159wHfxuIuKRddwB2UiuZD/LFNlYNG0IyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5rYDFHPT5U3MKicbswy2Tl2GYvfeWYANptdcaD/0o0=;
 b=lE8oXAJvW0pssWcWetMbENuixiqQ+C3ngCWHsXzEAQm3pns4dta9JjhnTAHiCD6ALrgIeRep1M6By/INZIU1UB73ne0R1N78E/ZuKJ+6Hr3aMJUbQj+hHbr02iiDKbFuQCp0RggCluBtcMHvsLmPYMnkEt0GC0UgwNMgophfhJ0=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:18:43 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:18:42 +0000
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
Subject: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Topic: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Index: AQHdJl6Bj4OHFsGd9ki5uUJ/gZxkkA==
Date: Fri, 7 Aug 2026 11:18:42 +0000
Message-ID: <20260807111159.429128-13-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|AM3PEPF0000A791:EE_|GV1PR08MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: 0015eca0-2d43-44a4-3637-08def475b792
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 7okYvXcI0BQ1wg71NQpR18HFWp2cNUAVeOPkVF8AIcSLHCCzPkzYp7nCw3KeimyMr9sVs6YqALDEiXUa6PzoR5p8l/Qv4X2DYk+zn+citn6RXMLXR2P5sk5JoZy/yjnz8rVj/z9+k7HDqj1du+Dnvb0J/jeQDfVpx5LFNleSZaKD+X/V4hLOVIpcMXrdeGgOuZi5CtQHOZSeE6vkHLcmDOa4jc7a3ZJRWFvzsleZuTfeoiNI8b23l2MfYhykCnhcxBP9hSJ95fmPmcytB+fI6xQ70l2JR4+4DRLNwSGLMFr2wBewcjv4WTFV0RWrfo6nRs4zAfr3i/E8HbfbIygy3of2qRp6G3e9NqykMSNo049VwFNXRRHq3MeVOXEmqGDayeXzfyOox1kGXRWpl1+oG5cp9wbfCscuEKIPJZujh/sJAS9RAY5VC9+nvkh7d3T/E27yXIIU8chq9BLWLaiKOWehWrCoRq+0m24U+OZWao7OnBR5RSDDkiAKlb4i6WJBcaYAxtGe42AILRuFxFpSq6fpw0GkkWCVX/gvh9LdrjvzO9zAHz4vjE+rELjAUj91flKpmmdssfp+IizTUEDOWHAQVyUU/jIRJZxBdFhvhI+vYfPNbHsm7nCeevc+kHRk0x/yZdb+TJwWCKKkfpeZWX2+sfIdLJql8e9ORPGr+okydjgLRQncFUsVVIM/xsCLiTOXcJugJhi3M8zAGogChFqzfFS8+aqM8CYmTsdiOws=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 SByiU5zGPqY1qMbGNrqB0ZJp490Mhb3Q5zs9cJ9HYW1fIw3RdgEYu6s3sr7OPT7Jo7eXG3jMviJEtfgn5YiHflo5nch18ICAi8tzmPUXzOsr4sCMayU+7wKRAiXccqvwDTgx4BYROyZ9rAyLeP9OuafgZU5HMgdP5oCcZ2ag39Vn05t5utq/pT2+SR54PLLlZm/LSMLe/fKuSwTWiuiZpOpe/I8Xx7ZehI95m+moHc26/RTgkPX1zq+gwjQr56ID2AQOy42VpyxeIY0GeeAH0uSzNNrBmxQ3Wx10etUn1mDY46yWJx4hW7g+wSAkcQta7KlSDzLz/sDJzIAxkmZpRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7d052c90-0afd-4f1b-1d2b-08def475a3bc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|376014|23010399003|14060799003|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	USH1x7vPBL0pq4MpBg2WJToW6tvgXoUGv4nXHpG4f2Kt6h2P+6YdwySzFn/TDHXcV+v+8zwGSeoTtrieN+I2TP+qiyM0lR5dJXW8F96RbeFZRILrZ5EUAk/H+IqIk919gQn6o5GKGYH9704E2+ogiidzzHNfmlBJoF6h2o3hYIw1N/uVIHarlBdM6XLR/5BjEhjyHHobunMaMY314U0ZL6Yro4uPj2MEo/7Ze+tJtI+OomJwp+VHPxp4h/gjUnCEi8fZ88xf6Xq2+uzaBBRGE2XTgwapICrHzjyIO6CZYGjREwCnNFiGp7JKmlI1WmKdqBdDJZQt9xboI0P9ZnvXa3bK2/Rg+UyeXzBICSTb5DW1hQjykIsf63weWQWFX2WEUVWP721X2sKKv9E5CONZh87JEPYKASyInQLo4J33DukdnUimefb9agZ8QprSIcx4EQYFooHQY2udGuVhDJIzvxfETLtEBwEU2qF79We4KTfyKMY9XtzD9GG2d25hG1VUM3lop1uk09DMKnJheSUazp+gd4zla9hhzfALzlnP4VabiWsVsThrA3FqM/Z1jMzbWGL/ojoHDqFN3Y42FRFRVPQSIVuFSYpOnUxDTnLdLdowsLGV/uPUyWqNc14Myjxhk9cmZflAInYb0U9TFETA8DPTLLTIaPWaWdDxTtMd1G0Hu6ZzEBYTVdoBTo4yiIy9zpCQ4S8u+EmUrqvQ3vzqpw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(376014)(23010399003)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dmms/frAANT2OZcylNJlVZOR9CgN7VLtRynxuVtUtq0KNRNNJm4AD19A2bYBIOKxysQuagCGPWxQyZke34wXD/wN7vltc5jzSrlzaqhM+CQi1eRnOrdlUEOMqJLJnelHcJfY2vLnPlEMsA2yTAt1cJf0VxEQx7QAWsd1xrKCBPmimv1nZ6lkRomDtuvtRO5P16gawC+HsstOR3YfxHqc6yLuzWVz62SuC7ET2/WfN+UrdB5mo8eKpk303OG134UmMhUR2zWIc45/Xzzz0A9Rq+6OwgI853Bd68gweCqsEIJ8HSv6K801tOo+MW1gYTbGJWuKZ7V/fDyRvvgWbk9b+3bwtT+cF+F03yAYtn6FeiPoDjVlI5YT+YMIs8YC7shme4/Lcj7VlpHEcdQTswlg4f6mMp/HjgM2rKbo1LzLYEM/u79VEoHbeYMMql8nZ3rC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:19:16.0313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0015eca0-2d43-44a4-3637-08def475b792
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7706

A GICv5 host with FEAT_GCIE_LEGACY can expose either a native vGICv5
or a vGICv3 device. These models do not necessarily have the same vCPU
limit: the native GICv5 limit is probed from the IRS VPE capacity,
while the GICv3 limit remains the fixed KVM vGICv3 limit.

Keep the IRS-derived limit separately for vGICv5 creation. The
pre-VGIC KVM_CAP_MAX_VCPUS value continues to expose the largest limit
among the still-selectable models, and kvm_vgic_create() clamps the VM
to the limit of the VGIC model userspace actually selected.

GICv5 uses the userspace-provided vcpu_id as the index into the VPET,
and therefore as the VPE ID visible to the guest. Enforce the GICv5
limit against individual vCPU IDs as well as the number of vCPUs.
Reject vGICv5 creation if an existing vCPU ID cannot be represented,
and reject an out-of-range vCPU created after userspace has selected
vGICv5.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 53 ++++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-v5.c   | 16 +++++-----
 include/kvm/arm_vgic.h          | 16 +++++++---
 3 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 079a57c2b18f6..8e1e844ed6e93 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -129,13 +129,34 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
 	ret =3D 0;
=20
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
-		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
-				     kvm_vgic_global_state.max_gic_vcpus);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->max_vcpus =3D kvm_vgic_global_state.max_gicv5_vcpus;
+
+		/*
+		 * We use the userspace-allocated vcpu_id as the index into the
+		 * GICv5 VPE table. This ensures that userspace's view and the
+		 * guest's view of IAFFIDs remains consistent - GICv5's virtual
+		 * IAFFID is the VPE ID in that VM's VPET.
+		 *
+		 * Reject vGICv5 creation if we have already got any vCPUs that
+		 * we cannot back with a GICv5 VPE in the VPET.
+		 */
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vcpu->vcpu_id >=3D kvm->max_vcpus) {
+				ret =3D -E2BIG;
+				goto out_unlock;
+			}
+		}
+
+		break;
+	}
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -395,15 +416,27 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
=20
-	/*
-	 * If we are creating a VCPU with a GICv3 we must also register the
-	 * KVM io device for the redistributor that belongs to this VCPU.
-	 */
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		/*
+		 * If we are creating a VCPU with a GICv3 we must also register
+		 * the KVM io device for the redistributor that belongs to this
+		 * VCPU.
+		 */
 		mutex_lock(&vcpu->kvm->slots_lock);
 		ret =3D vgic_register_redist_iodev(vcpu);
 		mutex_unlock(&vcpu->kvm->slots_lock);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		/*
+		 * Ensure that it is possible to represent the
+		 * userspace-allocated vcpu_id in the hardware-limited (or
+		 * KVM-capped) VPE table used by GICv5.
+		 */
+		if (vcpu->vcpu_id >=3D kvm_vgic_global_state.max_gicv5_vcpus)
+			return -EINVAL;
 	}
+
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 89d39b287a615..b9257e0554b73 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -81,7 +81,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	kvm_vgic_global_state.max_gic_vcpus =3D 0;
+	kvm_vgic_global_state.max_gicv5_vcpus =3D 0;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -106,8 +107,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
 	 * can't use them all.
 	 */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
-						  VGIC_V5_MAX_CPUS);
+	kvm_vgic_global_state.max_gicv5_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_c=
aps),
+						    VGIC_V5_MAX_CPUS);
=20
 	/*
 	 * GICv5 requires a set of tables to be allocated in order to manage
@@ -116,7 +117,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * we want to run. For now, we match the maximum number offered by the
 	 * hardware, but this might not be a wise choice in the long term.
 	 */
-	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gicv5_vcpus);
 	if (ret) {
 		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
 		return -ENODEV;
@@ -151,6 +152,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
=20
 	v5_registered =3D true;
+	kvm_vgic_global_state.max_gic_vcpus =3D
+		kvm_vgic_global_state.max_gicv5_vcpus;
 	kvm_info("GCIE system register CPU interface\n");
=20
 skip_v5:
@@ -178,9 +181,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return v5_registered ? 0 : ret;
 	}
=20
-	/* We potentially limit the max VCPUs further than we need to here */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  kvm_vgic_global_state.max_gic_vcpus);
+	kvm_vgic_global_state.max_gic_vcpus =3D max(kvm_vgic_global_state.max_gic=
_vcpus,
+						  VGIC_V3_MAX_CPUS);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7923ff20d9d7d..6d0cc38efa673 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -170,9 +170,16 @@ struct vgic_global {
 	/* Maintenance IRQ number */
 	unsigned int		maint_irq;
=20
-	/* maximum number of VCPUs allowed (GICv2 limits us to 8) */
+	/*
+	 * Maximum number of VCPUs exposed before userspace has selected a
+	 * VGIC model. Individual VGIC models can impose a lower limit
+	 * (GICv2 limits us to 8).
+	 */
 	int			max_gic_vcpus;
=20
+	/* Maximum number of VCPUs allowed for a GICv5 VM. */
+	int			max_gicv5_vcpus;
+
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
=20
@@ -622,10 +629,11 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group=
1);
=20
 /**
- * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
+ * kvm_vgic_get_max_vcpus - Get the pre-VGIC-selection VCPU limit
  *
- * The host's GIC naturally limits the maximum amount of VCPUs a guest
- * can use.
+ * Userspace can query KVM_CAP_MAX_VCPUS before selecting a VGIC model, so
+ * expose the highest model-specific limit and let kvm_vgic_create() enfor=
ce
+ * the selected model's actual limit.
  */
 static inline int kvm_vgic_get_max_vcpus(void)
 {
--=20
2.34.1
