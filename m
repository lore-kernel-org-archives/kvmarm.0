Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013045.outbound.protection.outlook.com [52.101.72.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4943FF889;
	Fri, 31 Jul 2026 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493468; cv=fail; b=i6o6CG0WIHFrX49ixfA/ZyGDRBKtkoK2cqc+8XMum8hLfRUw1E/HjaKz7a7Rhus7D8DHN7A0c/x1rTc9zUOVYbuddwQoBWzGIaKUxSJbpEVA8MCfGXyqfsB1vZPmzIM9V0Fr+chaTdZ6fUMIj3E4hEZ4Ehq3sm9fTVzMjwEOPmE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493468; c=relaxed/simple;
	bh=qxzpo/38/uO5Fjc5S1fFZ1fuA6EWF+kIyF+Jzos0mrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AUkr/VhYX84M8vxlqlfPKGCfd1yfYv2IYy2duFaYIsVWuKEXcxHRuvh7uUSSjPBFjm+zVz0yoEIFcbU0zeCBX4s2Enx1RFh0lTyfPaHagxzBNboNPci40/7xaz+SJA2GIEWgmiU0q9AumheciUfn0ig/lvl9GOusd40VHNofPA0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DBrAlI+j; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DBrAlI+j; arc=fail smtp.client-ip=52.101.72.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DBrAlI+j";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DBrAlI+j"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uWazg6YW2/3m595qb7is+e5Ba4U/Oxu2hq+g/zt6Wq03+UfAgdF8buZtB8On50JL5Rw1Ab5rCnUIGUucVPVnQhICNFVohLo73fF1L11cmSZMT91TWJ10z+29+h7XC2j2vfASGRdk7EIbL6VZu1jICt70kCLEwkAYitmYn1v0JS79wXE44MVvMxvJc0jTuEKQHmicx+X3VRNCW0RlJgNg9rxvWisAcrowM4z0rfIE8uEWyt9x8JoaCv4j2tYrdcpGHQ0M59nr3attKKpZ/MRhW5FUsBkJ7MxQneaSeSIAYFEzLklGQlZv3zdE3V7r1+WfjdHxQK+DdEXIsvL/xBaZZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxzpo/38/uO5Fjc5S1fFZ1fuA6EWF+kIyF+Jzos0mrM=;
 b=womt9pi3s4m7NuGGe3Qgm9NupJKb2UPEOnnJfwywGR1nr0SggkPDlNke7CFW1ymQ+jLhoURuJ2xRTEkFEIvVra0OWaBZfc1temiewSsH9MyXmQ2Hg9uLJVdzN7IUgEEGmmHx46BVCF36arUVKxERqVyxJufuyIJkZ7C6d/kv+XM0D3gRq+J15xoUZXsPwtjO/5R3NR/HwLtfs4N7eU3pC8v3rZKFu6CvVUbwZMfg0monTWJ0GJE/f80a+4L3hlh10WAD1/ny58KBq+O4Wt78lcMQWRmv4+XeFGtQTLGgIpFXsT84jgPqFoRMmlWrhsbZua19jaXzVAX58Bbad9uqPg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxzpo/38/uO5Fjc5S1fFZ1fuA6EWF+kIyF+Jzos0mrM=;
 b=DBrAlI+jsM9lDdeaaU8OeugX11tEecykzwt4M0/JhlahjB3ErNN4KHDCjcUDLj1PXvJSBXhLth33u0ftRSHhm3ZMKAG/qB3Lx+DXM/t/wUivDD6IokqjOL+ZuIoBUyDmiw3rr/qRmeibfIiOAVOAuuvrHyRYV2qGDI6McsU6wxY=
Received: from DUZP191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::13)
 by DB3PR08MB9900.eurprd08.prod.outlook.com (2603:10a6:10:43e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:23:43 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:4f9:cafe::8f) by DUZP191CA0023.outlook.office365.com
 (2603:10a6:10:4f9::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 10:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via
 Frontend Transport; Fri, 31 Jul 2026 10:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHyT2kKGDQZaaoMc6hRpsxJz4YW2IPVOsJR2ye+SHZPN4WeX/h9HcXOctZCBIKWBBMKNJW5+OMmNRhbGAqTe3ejflzD67WdEzaqAx0kjtMhq/rDZaEM7fB0a7ztrsLwixX2KQ96w/7XH7KQPrEPlZ0H1CseNvVtQEoMdT0X2UyyEcH747LyqvmC1/6TiDtk8XF0m6eCd2B27FowCqy/O4prI9dbAeTa90+9Px84eviQjoZdvTVs7D1gLTuJxsQ1SsCh1novmIntiGhpF8ABZhx81ylibTPv+ASrrb4QoVnc5Ho/qEv6rF/Mct94WiEPsvz6rT6ZZctyau5y/lX02rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxzpo/38/uO5Fjc5S1fFZ1fuA6EWF+kIyF+Jzos0mrM=;
 b=SnW/qHnk2OCY9Wy6GGHL0rSnEF4O2ZSpbk9QzLbkEKNb1aCHGphQLNvRSsTzn/pcZxYYA2evMKwNpBTqudaReFHRsQ6MmS7W7aTrSRY58PehSbAcArkM2Tb0L78OTiYH9dcoot2x1ZitEIAxBay2KTdg/lwy7JbVu64JjKwae/a7RLhZ8T1uv1/dJItRHvftTnClOMichxmapQRbJy5U67OIOuQ3DKEJHPb73VUZhTwOh/GQhAiP2a0n/pGGdoIEDt/1SOJ3uZI8IdtL3hZ4ck8WRy88UAtE0E3CelT0KR5rAL3/Nn0OL35nLgmHJy0IOy1KlJ17DS6OvZUcEeXIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxzpo/38/uO5Fjc5S1fFZ1fuA6EWF+kIyF+Jzos0mrM=;
 b=DBrAlI+jsM9lDdeaaU8OeugX11tEecykzwt4M0/JhlahjB3ErNN4KHDCjcUDLj1PXvJSBXhLth33u0ftRSHhm3ZMKAG/qB3Lx+DXM/t/wUivDD6IokqjOL+ZuIoBUyDmiw3rr/qRmeibfIiOAVOAuuvrHyRYV2qGDI6McsU6wxY=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS2PR08MB8312.eurprd08.prod.outlook.com (2603:10a6:20b:557::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:22:40 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 10:22:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 19/48] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Topic: [PATCH v4 19/48] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdG1qi9nc1ATSXo06CeaTJMPHkybZ8iQcAgArtSoA=
Date: Fri, 31 Jul 2026 10:22:40 +0000
Message-ID: <025586decb43324e1f2a11d2ebace52c2d48170a.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-20-sascha.bischoff@arm.com>
	 <20260724113047.2B3021F000E9@smtp.kernel.org>
In-Reply-To: <20260724113047.2B3021F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS2PR08MB8312:EE_|DU6PEPF00009528:EE_|DB3PR08MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: 1853272a-adbb-4c63-cd13-08deeeedcc5d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 rG0Sxc7cx4PeaTUGcDN876JaiVAIrfeR4PJSHXacKs5RUTCua/aQ/Ir2oeXxORPx4SH+0skZa0ux4gFix/GonuQ7uxjwGIOEIFY7jEHkr/S+pvj59meFHtVZznBDKOssYm0D61/6AfjmKRykv7bUm8mqnTwCg0bSMFyGfEcahpxMYjbOmBNVgW720YUBHltnPiXE9xHd7/DXvj/4EVRNaELvItOm5jsmgFdQXolh1mxECiAZbEZ6VpFgz+9MjWg8sW9ds28YqMngzX19a5jx6T8pGymd+v/0Dm3AA0COuZhixeQL0czGzcQQgizOblQSIXY6o7zX5F6ChxrF97qxQp7PtTUEqY0sVD3SHwOzwvkxswQ6Q78tSd7nEUZ1s2MW+EsNBJf8Od5G8JhuVBcxeocKyXB4p7Qhut5xgJTqhF15fYomWCJ825DzfKQqq2VckEN1mVfzuieVzT0U9n5zogBakSC7BJxoZedF27eI/HDCBeuNj0JgxaLFPF6+1NTVq+8RNzWMZisY7VlNwVr5Pu9bU+cxu2XH2hDNM+EVNsOOeJkAbU0d5qQJnLttGUIupuaicPjnboSQZidVUX+hmY/klktkLHFXs4ziV2UuiMLVDK5G7fVSgA+ZCIu7skBXd6zpxYMjEH3y31wVXXwyfYce7AIkqu4zls4Crv49IN4PJftIE2c/hrMRCSskCrs5ZIa+WR6n+5iC+sj3wpkF7/3MBuRHKDcNMmEOzsfF5yE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA609CE9184AC14AAAA7991A0773D27D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 cpaRl7EMhCXJk9bsQIs7J+UGtRgOIW1FzhnxPMB/SqadMfmiG0gfDQOB3ihfk8wyoiwsewDTA9VP3/yykWCkf/nmxWnEB1uawX5OQCZ7WhDroYnfjr8y8hHn/tLwRsP2COuZReVGwpFi/3/mxSbhenxiaJ64n1ItZOqEwFyWzLkt2iSSbloPi7VCSS15nb2VwOZVPYA/o+ukokD+cTPkxqJGAs2F+A+tG4epKXx9X+Vrh+c3vm/pfSvvc9YZbzvZM0+3nn4n9wAI41E7oQhtGWvJKd7ws8fiayBHpUeRjIv5hQyphhBCpnDq+EqonP3KLsdvWwU+ZV11KZRtiFKaag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2a4429a5-6654-43d0-91e7-08deeeeda6d5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|14060799003|23010399003|1800799024|376014|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vspJ6UtvmrBYEX9AxcwVZ2ac9ZjH7/v8hejrQW20DkYig4+n7j3doHFOcyHzq8UrMd1Bqc3h71ksTGyr/cnzU044zVR1sK4j4ogSFEE7TB1fmysJ4n1Q0pe/qx+e+YDAVUmfejhpGqlgq0Eagc5bZiy7Z5jPNoQ7dCLy6E8Duas1UQxys3pQBLXJHs8p0cTL0L3PK1C+GFzJkyl0hTpMVV9VbQt+6iS4qG4S3F9xco0BBDaiQOcV8fJnqHo+nSP+f2F20G8bqYXuWAR0Wu13rth672z8A51aoAjrwwUmSYBDwM3ylCj8Ndr6bC5uVfZn5wDCESXWIwnu2DVPL5tvdZ1YBJzlboueQdtZtB8m230D88asVkx//BpNNbOI5RjRnPdi5x5u6DgrHm6T36jZRxFnWazQG1kNaimIXJK2XAv367bs7fiqJNWcTYbofLLH0pnjK7mmYba+C6xD7jmFRGYkJ2OVaRuC/yVNjx6P5DTU7V27fhu4CaWvuSXlno26tL0plnxnsveVLU5h4aoee+QxymFPfb6MKFzOnJuarUay4XOEx5md0E6Vwd76MrU1nAg/N/FHS+wgHv6sNpPTRMwAVVcgv58wwU1FeVq1x0/AB2ONITgVp4NqDFBFofhguxRcH46HlMaxUDI1O3BIqf1DEYj+BhFbXc9OOfcgehv3PAhOyRF6mW1jwNsDmWxIvc+CK3dWXvHVb7xhfmwxgw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(14060799003)(23010399003)(1800799024)(376014)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4sRL34d7YY2Sbg8X5QKiiOYJ965+jMxWMPM50NFMdhn5PVxdVt7YNqw3avRCKe314+1YX3JF4TM2A4obA0rGL/68N2pRPF1PwUR02QWkGixygN3g10ELhHIvDsmb1LTXA1kagQxahpPNZcSh/thC7lUTIFf6g5dvgSHcoJU9wMAki5WXSEL4s6wMzzAHapuu1mKLO1RmXWebcUKlRDNEXMlTpEtGSIMarc9WvyHx+K/E8+4wwbzjeut91y5gQ/IArx47t0p1qP2qqYjElxWh0+2E8wSbeTLuuZ7FMBfMGLd3BdXb+fKDKmQ1BibbiPRSCwyvf+VVUnIFvQkZiC23IwEwYJjfSC+jdWNG45tTA5d+7LZbze6BhyCjh8dHX3O1KrRiWb3vqUBP0RO8F4moU/X089w26U/QmId/wsJwc+NFyMzrCh/3u00MT2Yt89Zs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 10:23:43.5569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1853272a-adbb-4c63-cd13-08deeeedcc5d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9900

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjMwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIHBhdGNoIGRlZmluZXMgYSBuZXcgVUFQSSBjb25zdGFudCBmb3IgY29uZmlndXJpbmcg
dGhlDQo+IEdJQ3Y1IElSUyBhZGRyZXNzIGJ1dCBwcm92aWRlcyBubyBrZXJuZWwgaW1wbGVtZW50
YXRpb24gdG8gaGFuZGxlIGl0Lg0KPiAtIFtMb3ddIFVBUEkgbWFjcm8gS1ZNX1ZHSUNfVjVfSVJT
X1NJWkUgdXNlcyB0aGUga2VybmVsLWludGVybmFsDQo+IFNaXzY0SyBtYWNybywgY2F1c2luZyBj
b21waWxhdGlvbiBlcnJvcnMgaW4gdXNlcnNwYWNlLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsx
OV06IFtQQVRDSCB2NCAxOS80OF0gS1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQNCj4gS1ZNX1ZHSUNf
VjVfQUREUl9UWVBFX0lSUyB0byBVQVBJIC0tLQ0KPiBjb21taXQgNThlYTU0ZTNkODY0YmRiM2Zl
OGZjMDQ2ZjA5MTJiMGU3MTAzNzdmOA0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hh
LkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6IEFkZCBLVk1fVkdJ
Q19WNV9BRERSX1RZUEVfSVJTIHRvIFVBUEkNCj4gDQo+IERlZmluZSB0aGUgVUFQSSBhZGRyZXNz
IHR5cGUgdXNlZCBieSB1c2Vyc3BhY2UgdG8gZGVzY3JpYmUgdGhlDQo+IGxvY2F0aW9uIG9mIHRo
ZSBlbXVsYXRlZCBJUlMgaW4gZ3Vlc3QgcGh5c2ljYWwgYWRkcmVzcyBzcGFjZSwNCj4gdG9nZXRo
ZXINCj4gd2l0aCB0aGUgc2l6ZSByZXNlcnZlZCBmb3IgdGhhdCByZWdpb24uDQo+IA0KPiBBcyBw
ZXIgdGhlIEdJQ3Y1IHNwZWNpZmljYXRpb24sIHRoZSBJUlMgaGFzIG9uZSBDT05GSUdfRlJBTUUg
YW5kDQo+IG9wdGlvbmFsbHkgb25lIFNFVExQSV9GUkFNRSBwZXIgaW50ZXJydXB0IGRvbWFpbi4g
V2l0aGluIGEgS1ZNIFZNIHdlDQo+IGFyZSBvbmx5IGNvbmNlcm5lZCB3aXRoIG9uZSBpbnRlcnJ1
cHQgZG9tYWluLiBFYWNoIG9mIHRoZXNlIGZyYW1lcyBpcw0KPiA2NGtCIGluIHNpemUsIHNvIHJl
c2VydmUgMng2NGtCIG9mIGNvbnRpZ3VvdXMgbWVtb3J5IGluIHRoZSBHUEEgc3BhY2UNCj4gZm9y
IGEgR0lDdjUgSVJTLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL3Vh
cGkvYXNtL2t2bS5oDQo+ID4gYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4g
PiBpbmRleCAxYzEzYmZhMmQzOGFhLi5kMWIyY2EzMTdmNTg2IDEwMDY0NA0KPiA+IC0tLSBhL2Fy
Y2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5j
bHVkZS91YXBpL2FzbS9rdm0uaA0KPiA+IEBAIC05Nyw2ICs5NywxMSBAQCBzdHJ1Y3Qga3ZtX3Jl
Z3Mgew0KPiA+IMKgI2RlZmluZSBLVk1fVkdJQ19WM19SRURJU1RfU0laRQkJKDIgKiBTWl82NEsp
DQo+ID4gwqAjZGVmaW5lIEtWTV9WR0lDX1YzX0lUU19TSVpFCQkoMiAqIFNaXzY0SykNCj4gPiDC
oA0KPiA+ICsvKiBTdXBwb3J0ZWQgVkdJQ3Y1IGFkZHJlc3MgdHlwZXPCoCAqLw0KPiA+ICsjZGVm
aW5lIEtWTV9WR0lDX1Y1X0FERFJfVFlQRV9JUlMJNg0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0K
PiBJcyB0aGlzIG5ldyBVQVBJIGF0dHJpYnV0ZSBoYW5kbGVkIGJ5IHRoZSBrZXJuZWw/DQo+IA0K
PiBMb29raW5nIGF0IHZnaWNfdjVfc2V0X2F0dHIoKSBpbiBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMta3ZtLQ0KPiBkZXZpY2UuYywNCj4gaXQgY3VycmVudGx5IHJldHVybnMgLUVOWElPIGZvciB0
aGUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiBncm91cDoNCj4gDQo+IGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmM6dmdpY192NV9zZXRfYXR0cigpIHsNCj4gwqDCoMKgIC4u
Lg0KPiDCoMKgwqAgY2FzZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSOg0KPiDCoMKgwqAgY2Fz
ZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9DUFVfU1lTUkVHUzoNCj4gwqDCoMKgIGNhc2UgS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfTlJfSVJRUzoNCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTlhJTzsN
Cj4gwqDCoMKgIC4uLg0KPiB9DQo+IA0KPiBXaWxsIHVzZXJzcGFjZSBjYWxsZXJzIGF0dGVtcHRp
bmcgdG8gY29uZmlndXJlIHRoZSBJUlMgYWRkcmVzcyB2aWENCj4gdGhpcw0KPiBjb25zdGFudCBm
YWlsIGJlY2F1c2UgdGhlIEtWTV9TRVRfREVWSUNFX0FUVFIgaW9jdGwgcGF0aCBpcw0KPiB1bmlt
cGxlbWVudGVkPw0KDQpXaXRoIGp1c3QgdGhpcyBjb21taXQsIHllcy4gVGhlIGFjdHVhbCBwbHVt
YmluZyBmb3IgdGhpcyBpcyBhZGRlZCBpbiBhDQpzdWJzZXF1ZW50IGNvbW1pdC4NCg0KPiANCj4g
PiArDQo+ID4gKyNkZWZpbmUgS1ZNX1ZHSUNfVjVfSVJTX1NJWkUJCSgyICogU1pfNjRLKQ0KPiAN
Cj4gW1NldmVyaXR5OiBMb3ddDQo+IERvZXMgdGhpcyBicmVhayB1c2Vyc3BhY2UgY29tcGlsYXRp
b24/DQo+IA0KPiBUaGUgU1pfNjRLIG1hY3JvIGlzIGEga2VybmVsLWludGVybmFsIGRlZmluaXRp
b24uIElmIGEgdXNlcnNwYWNlDQo+IGFwcGxpY2F0aW9uIGluY2x1ZGVzIDxhc20va3ZtLmg+IGFu
ZCByZWZlcmVuY2VzIEtWTV9WR0lDX1Y1X0lSU19TSVpFLA0KPiB3aWxsIGl0IGZhaWwgdG8gY29t
cGlsZSBkdWUgdG8gYW4gdW5kZWNsYXJlZCBpZGVudGlmaWVyPw0KDQpUaGlzIGlzIGFuIGV4aXN0
aW5nIGNvbnN0cnVjdCwgbm90IHNvbWV0aGluZyBJJ3ZlIGdvbmUgYW5kIGFkZGVkLiBZZXMsDQp1
c2Vyc3BhY2UgbmVlZHMgdG8gc3VwcG9ydCB0aGlzLCBidXQgaXQgaGFzIG5vdCBiZWVuIGFuIGlz
c3VlIHNvIGZhci4NCldvbid0IGZpeC4NCg0KPiANCj4gWyAuLi4gXQ0KPiANCg0KVGhhbmtzLA0K
U2FzY2hhDQo=
