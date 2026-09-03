Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011020.outbound.protection.outlook.com [52.101.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152F4B5CB2;
	Thu,  3 Sep 2026 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445285; cv=fail; b=A0DgnilQ1HTkQioO8HpI9h3JnWA+d7ebWHhWVtdSmjQePFBQCGmQR1kKvdAxA517/nRPfyX7px8Xyj/GW/qvvpEjL9ZksCC5OInCL37WPOb9xeq+26hopPUMGIikD92l3YPpyKobcQ4FpdfUAdQr8e+NjAz9q+Wlht5yAdods4M=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445285; c=relaxed/simple;
	bh=f6S1XHyTW78HkKiwx0p/XIR7BT+wP0p39Z+oteXKS/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e9CqY9MgFGJLIQy55w3y+sD6drGc9Qa0UildqwKP5DmIOymfHUH+h2f8GpR1bYC6AzMzQjh73fW0Hofe4cSJkyCyE5Umh25JosmHnfshPgINAkYSEQcVewUlAit5dfAaxvFOOltKU2IaFwCgIhGzsd85WEZajeRrXlkDq/eey0w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=goQdpuDR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=goQdpuDR; arc=fail smtp.client-ip=52.101.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="goQdpuDR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="goQdpuDR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QgEhOy4Jj2GUI0Usz3SKC+dkCcnfEEaUZFetexXXdf2ntHO1M+HaI4Gb399jqGLd8vnThdXBa8z21/iIg8+ODEJalWSRJ1fVkOWD73lzejxPrNlMdF2qZhjaWrPWtQsXIC3Hm1W/puyhCGoGQqInGFvMsfkT6X8oylT2HalES5vlEHUaTPeh/9nI/MUq1fi6SiwZBO5CTufTrXkGBmPHCb9wUppyJhhX3IYxoWVe7sxnOt3VkI/d44JWqXvYROvx+rMHfRKnMPNi8NfiWnyn7SJSQk+iTH0Libj4Bw7TGSIc1YddLUu2Ffmd/2w9+4Hbf5KKwxF9hsQPy92WjWKhSg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6S1XHyTW78HkKiwx0p/XIR7BT+wP0p39Z+oteXKS/Y=;
 b=L1uGHqgZICbIAwsJfJkcvlDp2ys6Y7g6IZZOeOAZ08B8y4t/1+fG7Bfp2v1wfIb3v2d0mody4bbrVoDbWu3SEiuM7EE+ccdKDh2L9jubtru9zKnlpBvPIw7fUR/YWNY1gKGPqrJdZ8gC+RKlaQ79JuWWUKeIPjDOWJuqxrwqAyKrbRjnNzqDfn/b/MUBylT+sx0EogtrOqgp+D3wFdSmNfA3kg1Fuf1YizTIwYVMnbM/ScDC2grpV7zjbEwCO3in7hY3uXRzFwKLLlJWG2rBjTJsnYLa+HA56j7ps+4VLQcbEfgVyWW4WFWuaKc7nE/3j611lldcinjl0yiEmASGfQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6S1XHyTW78HkKiwx0p/XIR7BT+wP0p39Z+oteXKS/Y=;
 b=goQdpuDRvH+cbu9PglnJYxZeSPyOc+MTwYDopw70Q9YoauYQyouG8JgP3uK2Xm1I42CfI0ZpIGLDW4ID3o4lpttAgyBKHDkC81amqwH2KasENqP9lGIywZJ0j8puGll/UORvCY308kibJm2mDH/tuIySPmvdd7sy9eYW63m+f1Q=
Received: from DB9PR01CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::33) by DBBPR08MB6185.eurprd08.prod.outlook.com
 (2603:10a6:10:207::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:21:05 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::6f) by DB9PR01CA0028.outlook.office365.com
 (2603:10a6:10:1d8::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 14:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 14:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vr6S/uIT9CsbUX6qTIMkL8TkXkv3RhDcoRjMrcpfwLFNW1wSUnmmkZtIbMl7V5ZJ/8BA43YnoZGxm7nZ8Ur4VRmqYJRCgdG9YHo4PKMP4cR8pXrP0u9NXbDYCghRjs2XvdIgPtBqP7feifsYLmyAWsaNJMvqJbzXCGdw0A4EJAmv+8XoR5GMI5d4xELjPKLlY1xPug81lH+XO0rTwRSVUaB/n8ckbCbOji3uXZHIHHwvc23A0S1rqApt2iBZsnDfAxs1nIdodIdUunejyXwstyhPCL6J3bhacRMHBqj3uilsRmLu6tKWHk1jElVL7qWppCD7De/Vd/hFfSnRUw8o0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6S1XHyTW78HkKiwx0p/XIR7BT+wP0p39Z+oteXKS/Y=;
 b=jbFTo+xvCZZb4iFYeroX/nhQs9MMZq/YLUM9Yspl0uFE3vgDGxb1L01Yuaxy8NVXuUKg+FjLNYjdI9OFXtgn/U2xfVW5cE8g1M2Rv3W+2t/SjMb6UI/PcNjqB0INjUK+QMlQufhoIglN2UAgi+5imiUOCSDlraW/QaCNBXTEZd9NnlUwC8olP/AYsy5apmrKcADe+E0ixNwrdz0lPnp8HYvQw0yPmfl71b0SAi+fzW2TXU254IVt66Hz3TKyzq5TMJmGo4llZsqjPNJPoj1NVipc40etmrPTh7NBve/k4gTf+AIY5oaxG3EWJ2WVXccQUw4oHXHPXz8kc4UFMrlVUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6S1XHyTW78HkKiwx0p/XIR7BT+wP0p39Z+oteXKS/Y=;
 b=goQdpuDRvH+cbu9PglnJYxZeSPyOc+MTwYDopw70Q9YoauYQyouG8JgP3uK2Xm1I42CfI0ZpIGLDW4ID3o4lpttAgyBKHDkC81amqwH2KasENqP9lGIywZJ0j8puGll/UORvCY308kibJm2mDH/tuIySPmvdd7sy9eYW63m+f1Q=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by MRWPR08MB11683.eurprd08.prod.outlook.com (2603:10a6:501:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:20:31 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 14:20:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Topic: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdJl3KQVx539nr6E+f1sNlGKe2T7aSee4AgCqYFQA=
Date: Thu, 3 Sep 2026 14:20:30 +0000
Message-ID: <80cc4b76a66dbd0e8d5f7c0cfb3addd45cae6dcd.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-3-sascha.bischoff@arm.com>
	 <20260807115317.724081F000E9@smtp.kernel.org>
In-Reply-To: <20260807115317.724081F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|MRWPR08MB11683:EE_|DB1PEPF000509FD:EE_|DBBPR08MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b58048-3507-4d8f-6c2a-08df09c69671
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|11063799006|38070700021|4143699003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 BLANnl3DPayHwhZe1iuWLc7XE5i+y/b/8KzacMfHLRY2xfQK3VEZ5o5VjeCOY5OmsA+ipz/vO1/oqGrEEjlHBLHBLyQVZEJp9OOyaPW2XGnI4654sbwMP8P3wbEQzPqzVHrHiEd9+2Y/qvrs/h20pvIEi7IGd006MLAwgTkBXfzbLJOJzrvOceQGzak01ebgg1V7GIxV1NutxUCDTk0APPzsbeslCIJBcqU6nlpF4IGnI1P0JguSJlOv1GQN+qEuxdsw8W5LuiDgCUCcBFBqPcr4ZCNVyEhBNZlCZdUvHeFajutUbmILDDdlR6BsNjWGfJilVRoDV1fxqhjMTgP6ehu9Q/mL5Zmx+K2e3iR2SOzSm4vsTEHGT8N5h2ZHBE/ES2ZepktfhxQWrzd0Vqm3oTnbgFIJG5MtUwsPIU7XA2IzSjPe1VTkjvLWUVYWAezIWJBrA5ZQjMu2MHUCmsx6u8pUHDESjTlanX4rmpjKsgk43bg68lqURrrXcMEsUg4tbjH/N4kCxL8pJStcURNQ9nwvkwH2jV/nVvsQzef2U/4OjmWj5wwuvODYzUbhuDa5x+5t3ejcRmLZsxv2MVv7gp0UGUj+zpBZkpwR13e8xX4BJCIGeCgsDznm5fKIEGdckiyPsZv+gDgH5ZcBglTKyoT0zv6nHsoJSVvFcJf+YVurluf/EOAbk/x1uxntgdfAnzb3KHxlm0KjsjRmCTcvEkKMEX7VWaZAovFQzivoUho=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(11063799006)(38070700021)(4143699003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <156C6834012C7743A1CFE73774F071C0@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kZQ0ifKilqmS4K2xSen5OkNm6vtXdXQkYRLyIrpqLnw/dkwELbgaRl/ryzSxPR0fGwc9x3JbKNc/NY/FvWuDSM91osw5jG0ThTCdYhLtwKFsNvR55MGIpww638X+V2lkwGdOYKqZCTAoL3xrPAMQ8KmUN278gtF6/Uq1GY/4Q3+kbx7WEsRYeGDBVdu+ApMfmv3B/1MqU2ShkEFUDau1NdkVJRljFLTkxWlOXP0mLShhJBZ3z/pIQUPx5drtO3caSyKP/MAEvLtWH2uccrdPTzb9jFIU0rTSiqcgLKcvfrBvpxd0ykGUCF7ToBneQhM1ales7wtH5x8HC5Se2hThiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11683
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4e8c6de7-9d9e-418c-41ae-08df09c68268
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|82310400026|23010399003|35042699022|376014|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	79t7a0wZaUQjL/hyvKeeWOiPI0VwJbEx9VIfDnTZ1DeK+GqAb5o4gNVifZSu92D+qMXMdZ5+wqpVWCfiymNqMXhXyfAQ0NqdVOtOHXgOIGzrIHwUF/t4cnKlIyRvIiVUrioqTwYOn/PlE2TgRSwMUWZ45qvzBzzi8u8Rgw+yVoPPAe/SjLo+TheXA+tiz1NEXTpLsBUjqUl0tx313sAeaSNysRud6dw2IwIyJoH2kKLg6GKWu/fpy6Q9ZqyiAkHePuE7gsHmKjylG/yFa4zT2l0w9vBpfQQWcyU5ACicM8sPMk/RylRJNLtvfrxHswwnEHWqVk74EPkK1nNCw7gNLob5N8Tl90L4N3Bdq644IPgFWTy7mJ1VTFqEU+pOg4922loJ+qkoEE63uKRwwm6xsGcHfAOgC/vf0iWkoZklFQi+U2sAXG3VHvFk8CyYvz7pjAGZ5uRNArkpVkGS9Qe7tQnGzIqDuuZkiGGpiXyLqpCNY/On+/0Pqbgqd/h4/DiZ27YUAksSLH+QRjXsFLc5SXjn0WxSj0vmr7Bw5R/8BIaGhYuMpgHAFX79ezdFRXV3gEjYkFSrWNJN2c9ZamXUzTWXNAkDTlvRZJbbMh1Y0GPlW967XC+AcdQJnMqOrdVWrDiXPORpZdpcCYcn2vUpwot85Lh8h7KCeTu3Mb5oURw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(82310400026)(23010399003)(35042699022)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	B8jz7oXfSQwivRYJMXVNYmW0Bp0WEVSZh3LWdalvKNEcoIjLVC3PyyIYhj3i1DMyAR4y5qudz6ZLA48+BzHBfcAuevHqtA6bB3DKW7LXVh0ZSau00uD2yaWSv9SdqHwgaOq8mSVyZVaOqcJYQObstHM5FAg7HPP7HwCUfh2MnWJMiRK9qlIcATuhvPEcPbfshS7XGumn9v6Yda7VDLnroZ1wtQAaOtA2RbuOCIw9uCMa/GFu4MJzTtdfohuKvgevzWR0gxOsvqhFRLyQI39oBiLoCyQN9W1aQ5bsYB6smHJyBd4csh7tx95D9716etM22cLUtvnYKH8UpyMjbnja8OEM6r0o9v3CfsROQnZo+6qztIUlorGHoWJ+QtNyh39HV5r+MngeHbrZbS+HWu4/OBqR8I24osJYcGnVC7KCoNSdtvBqBW8rwDd7tqn6pkCQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 14:21:04.0969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b58048-3507-4d8f-6c2a-08df09c69671
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6185

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDExOjUzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IE5l
dyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIGBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oKWAgdW5jb25kaXRp
b25hbGx5IGRlcmVmZXJlbmNlcw0KPiBgaXJzX2RhdGFgLCB3aGljaCBtYXkgYmUgTlVMTCBpZiBD
UFUgMCBpcyBub3QgY29ubmVjdGVkIHRvIGEgR0lDdjUNCj4gSVJTLg0KPiANCj4gUHJlLWV4aXN0
aW5nIGlzc3VlczoNCj4gLSBbSGlnaF0gRmFpbHVyZSBkdXJpbmcgSVJTIGluaXRpYWxpemF0aW9u
IGxlYXZlcyBkYW5nbGluZyBwb2ludGVycw0KPiBpbiBgcGVyX2NwdV9pcnNfZGF0YWAsIGxlYWRp
bmcgdG8gYSBVc2UtQWZ0ZXItRnJlZS4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMl06IFtQQVRD
SCB2NSAwMi80OV0gaXJxY2hpcC9naWMtdjU6IFByb3ZpZGUgT0YgSVJTIGNvbmZpZw0KPiBmcmFt
ZSBhdHRycyB0byBLVk0gLS0tDQo+IGNvbW1pdCAxYjkzNWI0N2Q0YjYxODZlYzQyZGFmYTI0MTY2
YWY5YTFkOGFkYjNkDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZA
YXJtLmNvbT4NCj4gU3ViamVjdDogaXJxY2hpcC9naWMtdjU6IFByb3ZpZGUgT0YgSVJTIGNvbmZp
ZyBmcmFtZSBhdHRycyB0byBLVk0NCj4gDQo+IFRoaXMgY29tbWl0IHBhc3NlcyBhIHBvaW50ZXIg
dG8gYW4gSVJTIGNvbmZpZyBmcmFtZSB0byBLVk0gdmlhIHRoZQ0KPiBnaWNfa3ZtX2luZm8gc3Ry
dWN0dXJlLiBJdCB1c2VzIHRoZSBJUlMgY29uZmlnIGZyYW1lIGZyb20gQ1BVIDAgYXMNCj4gYSBy
ZXByZXNlbnRhdGl2ZSBmcmFtZSwgYXNzdW1pbmcgYWxsIElSUyBjb25maWcgZnJhbWVzIGFyZQ0K
PiBjb25zaXN0ZW50LA0KPiBhbmQgcGFzc2VzIGFsb25nIGNvaGVyZW5jeSBmbGFncy4NCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gYi9k
cml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiA+IGluZGV4IGYzZmNlMGIxZTI1ZDku
LjYwN2UwNjY4MjFiNTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMt
djUtaXJzLmMNCj4gPiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiBb
IC4uLiBdDQo+ID4gQEAgLTUwLDYgKzQ4LDExIEBAIHN0YXRpYyB2b2lkIGlyc193cml0ZXFfcmVs
YXhlZChzdHJ1Y3QNCj4gPiBnaWN2NV9pcnNfY2hpcF9kYXRhICppcnNfZGF0YSwNCj4gPiDCoAl3
cml0ZXFfcmVsYXhlZCh2YWwsIGlyc19kYXRhLT5pcnNfYmFzZSArIHJlZ19vZmZzZXQpOw0KPiA+
IMKgfQ0KPiA+IMKgDQo+ID4gK3N0cnVjdCBnaWN2NV9pcnNfY2hpcF9kYXRhICpnaWN2NV9pcnNf
Z2V0X2NoaXBfZGF0YSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gcGVyX2NwdShwZXJfY3B1
X2lyc19kYXRhLCAwKTsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4g
VGhpcyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSwgYnV0IGlmIGdpY3Y1X2lyc19pbml0KCkgZmFp
bHMgZHVyaW5nDQo+IElSUw0KPiBpbml0aWFsaXphdGlvbiwgYSBkYW5nbGluZyBwb2ludGVyIG1h
eSBiZSBsZWZ0IGluIHBlcl9jcHVfaXJzX2RhdGE6DQo+IA0KPiBkcml2ZXJzL2lycWNoaXAvaXJx
LWdpYy12NS1pcnMuYzpnaWN2NV9pcnNfb2ZfaW5pdCgpIHsNCj4gwqDCoMKgIC4uLg0KPiAJcmV0
ID0gZ2ljdjVfaXJzX29mX2luaXRfYWZmaW5pdHkobm9kZSwgaXJzX2RhdGEsDQo+IGlhZmZpZF9i
aXRzKTsNCj4gwqDCoMKgIC4uLg0KPiAJcmV0ID0gZ2ljdjVfaXJzX2luaXQoaXJzX2RhdGEpOw0K
PiAJaWYgKHJldCkNCj4gCQlnb3RvIG91dF9pb21lbTsNCj4gwqDCoMKgIC4uLg0KPiBvdXRfZXJy
Og0KPiAJa2ZyZWUoaXJzX2RhdGEpOw0KPiAJcmV0dXJuIHJldDsNCj4gfQ0KPiANCj4gVGhlIGVy
cm9yIHBhdGggZnJlZXMgaXJzX2RhdGEgd2l0aG91dCBjbGVhcmluZyB0aGUgcG9pbnRlcnMNCj4g
cHJldmlvdXNseSBwb3B1bGF0ZWQNCj4gaW4gcGVyX2NwdV9pcnNfZGF0YSBieSBnaWN2NV9pcnNf
b2ZfaW5pdF9hZmZpbml0eSgpIChhbmQgdGhlIEFDUEkNCj4gZXF1aXZhbGVudCkuDQo+IFNpbmNl
IElSUyBwcm9iaW5nIGlnbm9yZXMgZmFpbHVyZXMgb2YgaW5kaXZpZHVhbCBJUlMgbm9kZXMsIGEN
Cj4gZGFuZ2xpbmcgcG9pbnRlcg0KPiByZW1haW5zIGluIHRoZSBwZXItQ1BVIGFycmF5Lg0KPiAN
Cj4gV2lsbCByZXR1cm5pbmcgdGhhdCBkYW5nbGluZyBwb2ludGVyIGhlcmUgbGVhZCB0byBhIFVz
ZS1BZnRlci1GcmVlDQo+IHdoZW4gaXQgaXMNCj4gbGF0ZXIgYWNjZXNzZWQ/DQoNClRoZSB1bmRl
cmx5aW5nIGlzc3VlcyBoYXMgYmVlbiBhZGRyZXNzZWQgaW4gdGhlIHNlcmllcw0KaGVyZTpodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjYwODExMTUyNjMwLjk0MjAyMy0xLXNhc2NoYS5i
aXNjaG9mZkBhcm0uY29tLw0KDQpXaXRoIHRoZSBjaGFuZ2VzIHRoZXJlLCB0aGUgZGFuZ2xpbmcg
cG9pbnRlcnMgYXJlIHJlc2V0IHRvIE5VTEwsIHNvDQp0aGlzIGlzIG5vIGxvbmdlciBhbiBpc3N1
ZS4NCg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYyBi
L2RyaXZlcnMvaXJxY2hpcC9pcnEtDQo+ID4gZ2ljLXY1LmMNCj4gPiBpbmRleCBjMDQ1MjNhNDM4
Y2VlLi5lN2E3YWVkY2ZhZjc4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEt
Z2ljLXY1LmMNCj4gPiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4gQEAg
LTExMjgsNiArMTEyOCw4IEBAIHN0YXRpYyBzdHJ1Y3QgZ2ljX2t2bV9pbmZvIGdpY192NV9rdm1f
aW5mbw0KPiA+IF9faW5pdGRhdGE7DQo+ID4gwqANCj4gPiDCoHN0YXRpYyB2b2lkIF9faW5pdCBn
aWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9ub2RlICpub2RlKQ0KPiA+IMKgew0K
PiA+ICsJc3RydWN0IGdpY3Y1X2lyc19jaGlwX2RhdGEgKmlyc19kYXRhID0NCj4gPiBnaWN2NV9p
cnNfZ2V0X2NoaXBfZGF0YSgpOw0KPiA+ICsNCj4gWyAuLi4gXQ0KPiA+IEBAIC0xMTQwLDYgKzEx
NDIsOSBAQCBzdGF0aWMgdm9pZCBfX2luaXQNCj4gPiBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3Ry
dWN0IGRldmljZV9ub2RlICpub2RlKQ0KPiA+IMKgDQo+ID4gwqAJZ2ljX3Y1X2t2bV9pbmZvLnR5
cGUgPSBHSUNfVjU7DQo+ID4gwqANCj4gPiArCWdpY192NV9rdm1faW5mby5naWN2NV9pcnMuYmFz
ZSA9IGlyc19kYXRhLT5pcnNfYmFzZTsNCj4gPiArCWdpY192NV9rdm1faW5mby5naWN2NV9pcnMu
bm9uX2NvaGVyZW50ID0gISEoaXJzX2RhdGEtDQo+ID4gPmZsYWdzICYgSVJTX0ZMQUdTX05PTl9D
T0hFUkVOVCk7DQo+ID4gKw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBJZiBDUFUgMCBpcyBu
b3QgZXhwbGljaXRseSBsaXN0ZWQgaW4gdGhlICdjcHVzJyBkZXZpY2UgdHJlZSBwcm9wZXJ0eQ0K
PiBmb3IgYW55DQo+IElSUyAobWVhbmluZyBDUFUgMCBsYWNrcyBhbiBJUlMpLCBnaWN2NV9pcnNf
Z2V0X2NoaXBfZGF0YSgpIHdpbGwNCj4gcmV0dXJuIE5VTEwuDQoNCmdpY3Y1X29mX2luaXQoKSBj
YWxscyBnaWN2NV9pbml0X2NvbW1vbigpIGJlZm9yZQ0KZ2ljX29mX3NldHVwX2t2bV9pbmZvKCku
IFRoZSBjb21tb24gaW5pdGlhbGlzYXRpb24gY2FsbHMNCmdpY3Y1X3N0YXJ0aW5nX2NwdSgpIGZv
ciB0aGUgYm9vdCBDUFUsIHdoaWNoIHJlYWNoZXMNCmdpY3Y1X2lyc19yZWdpc3Rlcl9jcHUoKS4g
SWYgQ1BVMCBoYXMgbm8gYXNzb2NpYXRlZCBJUlMvSUFGRklELCB0aGF0DQpyZXR1cm5zIGFuIGVy
cm9yIGFuZCBHSUN2NSBpbml0aWFsaXNhdGlvbiB1bndpbmRzLiBIZW5jZSwNCmdpY19vZl9zZXR1
cF9rdm1faW5mbygpIGlzIG5ldmVyIHJlYWNoZWQgd2l0aCBhIE5VTEwgQ1BVMCBJUlMgcG9pbnRl
ci4NCg0KSW4gZWl0aGVyIGNhc2UsIGEgdG9wb2xvZ3kgd2l0aG91dCBhIHdvcmtpbmcgSVJTIGZv
ciB0aGUgYm9vdCBDUFUNCmNhbm5vdCBzdXBwb3J0IElQSXMgd2l0aCBHSUN2NSwgc28gaXQgaXMg
bm90IGEgdXNhYmxlIHRvcG9sb2d5Lg0KDQo+IA0KPiBDYW4gdGhpcyB1bmNvbmRpdGlvbmFsbHkg
ZGVyZWZlcmVuY2UgaXJzX2RhdGEgd2l0aG91dCBhIE5VTEwgY2hlY2ssDQo+IHBvdGVudGlhbGx5
DQo+IGNhdXNpbmcgYSBwYW5pYyBkdXJpbmcgYm9vdCBvbiB2YWxpZCB0b3BvbG9naWVzPw0KPiAN
Cg0KSW4gc2hvcnQsIG5vLg0KDQpUaGFua3MsDQpTYXNjaGENCg0K
