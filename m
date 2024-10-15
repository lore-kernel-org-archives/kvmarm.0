Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2076.outbound.protection.outlook.com [40.107.21.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34E1AF0B3;
	Tue, 15 Oct 2024 13:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.76
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997406; cv=fail; b=fCZerS9NgprATjwHBkuz269Wpy3cEK78sjaMUUdVyfybYAI6LBDuAgbQeKGai7Uiw5o+gL2Kbc5KBcep+kqaGkzYwJEcJJZyHjVVIwnG/vZ08Io1lIAVJADrEgQJjefK6yNUgStTRXqOfILp8EI1jlZXroJeGwHbNDQrF+yn0ec=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997406; c=relaxed/simple;
	bh=THkUA39DFpz2N0HbXudSmExhgHKOGwClTMeCp8YPbgs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mm8f3WSyxHvxDGB9MLaPOV+WUA1Xd5JbFIWy++tX6MTTENicSfRedxQsnSifA7xR8R/flNf4Gxmdn/KN692wutbQmtWZDeoJv0W7cNddHq6L0CZA9jHv81yH4R7/Mbfp75Mlv/S3HdveK8P3v6QmAsP/1TSUfsrdCKueYS4dvVQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXOIwxlw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXOIwxlw; arc=fail smtp.client-ip=40.107.21.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXOIwxlw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXOIwxlw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JMJtVVdW6pa2ua2bMjqyaXkQokGPuBraTNtHzvWTwPBlWPGEI+jSbeE46aSPJ6+j/1obwxPt0DprhdUguuxDYyXQ0Y1Uxmw8s6WpMavR8Af9wbekCKRWaWLZPqNUR3mXxYaHHIEGBbhb2WLRugL0O0L5H12/cG+ZJZUZiQiY/Coqmu81ll6Ml3STj1m+vAhyiZfoy3bmESz94f2SycL+fnUGIpLpGiHl1CEXGuFZhqlV4510XTB1tmIAy7mgjK8bx3J49mYNbWo12BN8eql0e8CexrILBe7gnsZ/in+3CjaC/nqYiVkVAS/HyawxxdT+1NC57Liq5lxK11/7kEk1oQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=Vq5LEPZ+U3rSYTkDsUnMDHV8/2Moye52jxUIZpSIvWi2Fa1yzNaYQnABKdUfUVPtmhycE6MhzODJa4ErUlVBP0eeCrnZTtpMOBTCyZiSp5+cQ5znbUqKsjGpm8BY06RQhvCc+ZFkRMdazxT60hQK86ZYKwP5W7d34RlWw0ZlPN8xjbGnRvwzlC10YNJtFhglr1SUirs+WopPjcqW8cgKXVVF2DiWqmE9cvRoytHA+Q3lVL/0D+K5r1G9O5G6iJN74G0yVjwjMMvnVpKi3a4ZR95U1HzjMSyBQX6undB5rkuAlstZJ+rWCxy9ZqWTDM+xPTgGOLEF0Xl9DfmvJvZVUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=rXOIwxlwk9Ob0LC/Xk+ibVJr8Zwe65oBxk1qrIJwfaKbXOj/jbJmn4gzPDb7ZkGxcnafCcrg8d6XLHCo0/TamitIDRQR8nrlVzeTsR2oQ6acLFcFTRTfFapBQnnukkKubo2cJsD55Pv+7nRlT7i0wZh5WEHKSIlGMDX615ku4o0=
Received: from AM0PR04CA0094.eurprd04.prod.outlook.com (2603:10a6:208:be::35)
 by AS8PR08MB8275.eurprd08.prod.outlook.com (2603:10a6:20b:56f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.21; Tue, 15 Oct
 2024 13:03:15 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:208:be:cafe::f0) by AM0PR04CA0094.outlook.office365.com
 (2603:10a6:208:be::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Tue, 15 Oct 2024 13:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 13:03:15 +0000
Received: ("Tessian outbound de6fe3af73ff:v473"); Tue, 15 Oct 2024 13:03:14 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3fc22c22d7c35add
X-TessianGatewayMetadata: vqU1OiIRKLLMuHHJPbZ/uHBBabNK4k6lz6PuwhoHVT+W4/YaezqEIra9ufM/OXAUiXeOIDJUj1segXJeUpIqP+wicc8z3TbP94/ZiNQmJF1YhVAgXTB0vdxoGpwD+KNDTsZ0Zr4OP5uwgyCvn+WStbm7ML8mZIk0/4AMtYxLlbY=
X-CR-MTA-TID: 64aa7808
Received: from Lb11795a18fa5.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2FF9EFF4-2A81-48C9-88D6-FF13E8F5C77A.1;
	Tue, 15 Oct 2024 13:03:04 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lb11795a18fa5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 13:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOfwdlvy7NM87LMdapTH0DOsIVtsLpFUbu62pZptDpdI1GHhpfkboX2BgJCifxWds8nKPQRtXomKtOZqOFdHGd/ug7R4gOVABFunuIVyPhO16Ja4mvwFXSbElLwTOKo9mYOyw8RQxyzFJfryekPsjQomQD46iAPfExJmTS26CfMzNkY1ndao0fkZr9PAy/sFIWploJOykO4ZIfXAEENbWQuepjNoU95SGYYmu8EkHzk5IxTndAUnRlJQ09d1doYCW9Vv8aHUzShyqQBYRkH/w/jRoyeql2oapsU6I5UG/w7eDBm/0Uf/6NyEpZaL/y+giUFaTEiN09U/wBRxcb5SZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=oWSbkWfax9Z2LUm1QhtqR0+NhdtgjD/ifOeFJ2lIaBVMKiNtEq15/KcSLFtmdkdF/YImJk4USFoa+rVSA3zdWfHlmcWxvUO+xY/iUePaeobogTbFg7y+EpZhtSFyFCExCaCnxhB76/q+xSghzPj/2TOebTVwzje51WjD1azxEOj52R+IaJ7RaNXk9IIiEt3+umT/08Il9AoWzJlzQVHDZNAz01zo5E58leHz4rXqszJRwJ5W6hmGbDxHdw4FMAxO+gHg5Fgfzx4iAJjGUMzd3n4rwyAV7Ss78MqX40DbRmZIhlJNIrSxcPuUYKu/xxnX41yAxoVmy4J6tfN19ftWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=rXOIwxlwk9Ob0LC/Xk+ibVJr8Zwe65oBxk1qrIJwfaKbXOj/jbJmn4gzPDb7ZkGxcnafCcrg8d6XLHCo0/TamitIDRQR8nrlVzeTsR2oQ6acLFcFTRTfFapBQnnukkKubo2cJsD55Pv+7nRlT7i0wZh5WEHKSIlGMDX615ku4o0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by VI0PR08MB11134.eurprd08.prod.outlook.com (2603:10a6:800:250::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 13:03:01 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 13:03:01 +0000
Message-ID: <ee899720-7b13-4609-a00b-86af868a0b1d@arm.com>
Date: Tue, 15 Oct 2024 14:02:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/43] arm64: RME: Support for the VGIC in realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-16-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|VI0PR08MB11134:EE_|AMS1EPF00000044:EE_|AS8PR08MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: fe67d9c0-a207-45e7-40f9-08dced19bb5f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aEZDV2lFQ0FZYXhReUJyRGNyK2dLdVI4d0c3QThsSDQzZHdsYmlwNjhkNlo4?=
 =?utf-8?B?YVdiQXYrWWVNY1RjSktKdjFsYUhRNGpRdHZHWWZDUTByTGZ0NlZ1UUlMQUFo?=
 =?utf-8?B?bVZVRmY0Wi85bFFZUTZEZjFSRnF0RHdFZ3Q2SSsxb0I1WWxsWEZoYVBVeE1V?=
 =?utf-8?B?cDNHSHllNnUrMXdmVVVPUnMvS21uMXJPQVV2czZhcXJVaUVhbm5lVG5XOHRk?=
 =?utf-8?B?Z2ZxalFBNW54SVNubUs0QmVaaG5YZUpUZ0x3ejUrNnFlN1FtQ2M4RGtFOGE4?=
 =?utf-8?B?d2pIZUlDRDV0YXQyS0NYT3hNNWY2Tzl1L3hIYWs5V2JUMDZHUmFEUjU4eDJE?=
 =?utf-8?B?cmxzU1VoQTF6a0g0cWZ0MzRNQVpJa0pFamtrVVpXenZJQzN4VXoySkdBMmhp?=
 =?utf-8?B?R3VEdG5PMnB5MjVTOEJsOG9Rd2NDaGpIV3FSaDVOdFVWOHZKQzlqNXQxL1Zl?=
 =?utf-8?B?SVJWdXJ6dkhEb1JTZDh5eXA5SUdEbys4NmxzdXRFNElja3YzVllrUWJwa1E0?=
 =?utf-8?B?WUxNZXRpNU5nM0lyMlovVHpDSGFON3gzL3N1d2JRUXpBNFNUcGJNcEU4Vkdw?=
 =?utf-8?B?OG1rcUU0bnI2M3A4THZQMnVPeFZlMjBuL3MzTUkydG9sWXdYUFo0YytOQ0lk?=
 =?utf-8?B?ZDR6eUV5OXhydGNiQnE1TWo2TlVMOVJZQ1pBY2Ntb2psWjRDRmlISUhibm5C?=
 =?utf-8?B?MTI5YkR3RGVCSEphYzliT2NNYzVQUFM4Wi9DSWZudTVTd0t5N1BiNTNrSjRE?=
 =?utf-8?B?YmhrZzUzd3l3TmpYM0FaOEtUVmNrNGVwQVRtWlRXWHF1YXN6QTd0d1hsTXhW?=
 =?utf-8?B?d3FMWk82L2RJTWVGK0p3N0dJaS9lTVpCOFFIRmFseGFENy9TMmZpcWdBK1RK?=
 =?utf-8?B?WHBSa2NpMW03SnBxVE14aUVHamljWi9MN0hWQTRlQkFob3BlN1lzQ0F4MHd5?=
 =?utf-8?B?aEcwZFNYdS9ENVhMUW1OL001VUNyVmZ2YUtvWG45NW1nRE5zcGw1UHhGRWov?=
 =?utf-8?B?Ui9DaGEySm1LVElRdDlFWGJrbHkvSjQ0Nm8xYTFFL3AzQjRTRTNXbGVlUDVt?=
 =?utf-8?B?WG0vaTFwUDJlVGp2c2NpV2hNME5KdlZZY0RVQXlHaURZZ1FLakdka3Ayd1B6?=
 =?utf-8?B?eE5iRDNTL0VJMXg4bEgxWGZsV2dlbVFGOE9wdU1ZL0pJeXh6OGhLYzgrQVVL?=
 =?utf-8?B?SFBHOTFRV1h0dDZtM1lxc3VqMjI2eCsrQnltTldQU3ZCNDhmbm5OTmNWell4?=
 =?utf-8?B?SWdGQXNJMENicUM5d3lTMU81aVNQY1lXeUROTUJYUW5ySFFjci9oVW90UDhD?=
 =?utf-8?B?TkF3OEJHbjUwSE1uK1hOaTNrUmRHejZ4enpjbm00YjFwQVNWWXo1bTR5VkVs?=
 =?utf-8?B?eC9NeTZnVjQ0VnVSeUd3VzBtb2paQ2tJSVI2QnI2WDhaTzJJOU54NkxhNFY0?=
 =?utf-8?B?aG1aYndjTmZqZHNaa245TnBmKy92dkdFVUFLRXZNSTN4b3V6bTlXd1F1ektF?=
 =?utf-8?B?VHNaN3JqQ2NvRkFoc09Xa0p5LzhwWTR4WmZFbFF2RFVRV0VmRkVmcEVEdE85?=
 =?utf-8?B?alo1WHFVQUNpOEJ3alFFeU5hR2pkZ05WU1JraGtRNnd0Tk5mMDY2dG9yQjVo?=
 =?utf-8?B?R1pxSnk3OHMxd3h3UEkySFBvbjBOSXJmWjMyOWQxYmU3SENzZFZpcGNVcmto?=
 =?utf-8?B?enNJZjF5S3BVV0Vwa0U2UEVIdE8yMTUrMDQzelRRakFiSWdZUE9QUzBRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11134
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8a430732-3145-4c75-7264-08dced19b2d5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0hLZjQ5eHliSDBQbmxoY2ZlanZKYnpXeUxvOWVGdXViNGxKbTZ1MWtqQU84?=
 =?utf-8?B?YTBxL3hkNG5mWmZ0YUlHZjVlaDFuSTdoaE5GRXh5dG9TRHYxTlNiTnNtQ3kv?=
 =?utf-8?B?SHkwQlAvbkh2YUlPTXJ4M2kveUZ3RnoxckMxenNtRWlaTmVEYkZCaEV2ZGFQ?=
 =?utf-8?B?ay9UdmtCQXNtck4xVlprYTNvSVJvNjVlY3p0M09HY2pLMG1lYTBkK3Fic2hR?=
 =?utf-8?B?UVlqR0xzNkY0U2o1OFdMRnFMSkxoa3JLVW5yajk3UCszeEhRVWZCcW92RUdE?=
 =?utf-8?B?ZFRpa0o5cUNYZ1pkTS9GU1VoMlg1N1FDNS94S2tjZzIvaGFtckwrSUU4TW50?=
 =?utf-8?B?UURnZlhHT1pqVDE2QzdIT3k5dDE5cGlHbUd2L3hxQ1lCb0tzNTNjV096bkpX?=
 =?utf-8?B?K1hLZjFmUEtRQUNBNHdGeENkOTN3b1NLYWc4VEdXTURVWDk3ZkdKK1NPNDEv?=
 =?utf-8?B?VzQ4QmZQSzFBbHJyc2lORHN4bFh4MkVmR3ZnVlkrM0p4MWtpNCs4UmxGZW5p?=
 =?utf-8?B?blVVMlByV1gxREtmblQ2MS81RDMzM2dFMXlLQ3VPSUVVODJObyt2QXRuNUxs?=
 =?utf-8?B?d2lHcDlKT0pzb3RzU3dJS2EyVFlUcnQzL3FaUVJNWHNYNm9yZ2FhSmV6T2w3?=
 =?utf-8?B?MXljMEpPWndjUnBBTk1XY285cGhabjlGbk5ibzdyY1pnTjdVWmFuelZYdHFX?=
 =?utf-8?B?MUhZYzFXQjVNZjhJOUI0YnlqL1BTWndnY25WYWJlYXA3cWhyZEVKSUJ2THBJ?=
 =?utf-8?B?SW5oNDhYa2J4b0xxYmpzVWtuWTBmUHExbHVMYXZtQVQ3UlpvOEhITTJ4OHYx?=
 =?utf-8?B?Q0F0UHIwS09IdHFMOWlFWWtySVRxUUc0YU1TYUppNklraDNOMjhhaWwrYlFV?=
 =?utf-8?B?ZFZiV1U5VDROVHZndFc3ZVdMbU9yODRFcC9OV1V5YlRrTTNKSkVSQndXT04v?=
 =?utf-8?B?VkV4bS9hVFA0TlhyOVllalJ1dS9HNUkwWVQ2NVMxSTROSW1zd0NuU2RIZ0R6?=
 =?utf-8?B?SStsbW5SN2drWnhWRkdFbWNGd2wwekVYbHZsY0d0MVpZckxreE44OXUwaEpK?=
 =?utf-8?B?ZGpXcjZ3RUZ4U2ZpNkp2M2lmZ25tYmVxNGNJKzBublprNzlheEZJcGRTNStW?=
 =?utf-8?B?L2pTaVAzMElwUktIaUZtMlZpcGNaYjJ0Qi8vZkI2THhqRzJ4SnluT2tqbitX?=
 =?utf-8?B?eEF4eTZRM2FLalRsdkI3NDFUSFpLNzFXbEhhL0d2UUJCR05sam9JdUNZakZx?=
 =?utf-8?B?bE5jL05BZWZBYlFNRVEvTFNvZzFkNlZybVJzamF3U044MFo3L3lXTW5zMVdH?=
 =?utf-8?B?QTBUT2RiaFhJakxrUGRZN3JkOWJaSlJTYmlhd0oxYTBicklud0V1NEVldWFn?=
 =?utf-8?B?ZjNLKzBzcUJkaGJoVGNsank0Mmo5MUpPclRkbzg2MXdBVW9zVGQwRFROdGph?=
 =?utf-8?B?ZCs0YnVJd2lNVWtWM0c2aWo4L2pRVEJIaEprTSt0MG9yU0NTRkpFUGFSWjhQ?=
 =?utf-8?B?MDNtNkFiZnU1QTNvSmdCamhRb1QyOXRuOHBOa05CdEw4Y2xVYTdZeHZxMG56?=
 =?utf-8?B?c2Y2RXlORW0rUnNuNE9rNUJMV01odjRiKzg1RUc4WDdONWo0N2V0cnVDUFRK?=
 =?utf-8?B?ZXRkaHluaVoxeEJVYXZGclRCOU9XempRQmdaVXN6cCticnRNaU82NUNEVEFT?=
 =?utf-8?B?K1FVNWdsMUJ6SXFBYUtDOXdIVmc1T1VGa3RJR3ZCdy9lQktVL3V2MHBKcWtl?=
 =?utf-8?B?TFcyQ21DSHh3eUNkR3loUSt3bWVtL3U5a0x2SkN6clJjRnBFOEFRc2NoZ2Zl?=
 =?utf-8?B?SCtpOWx2dlZCcVR4K3V4cGhCZUsrRXFsdCszaFIxZHQxem9yNHlhdzVXUEJs?=
 =?utf-8?Q?/q0iERqU20yZz?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 13:03:15.2377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe67d9c0-a207-45e7-40f9-08dced19bb5f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8275

On 04/10/2024 16:27, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v5: More changes to adapt to rebasing.
> v3: Changes to adapt to rebasing only.
> ---
>   arch/arm64/kvm/arm.c          | 15 ++++++++++---
>   arch/arm64/kvm/vgic/vgic-v3.c |  8 ++++++-
>   arch/arm64/kvm/vgic/vgic.c    | 41 +++++++++++++++++++++++++++++++++--
>   3 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 87aa3f07fae2..ecce40a35cd0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -687,19 +687,24 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +
> +	vcpu->cpu = -1;
> +
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
>   	kvm_arch_vcpu_put_debug_state_flags(vcpu);
>   	kvm_arch_vcpu_put_fp(vcpu);
>   	if (has_vhe())
>   		kvm_vcpu_put_vhe(vcpu);
> -	kvm_timer_vcpu_put(vcpu);
> -	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> -	vcpu->cpu = -1;
>   }
>   
>   static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> @@ -907,6 +912,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (!irqchip_in_kernel(kvm)) {
> +		/* Userspace irqchip not yet supported with Realms */
> +		if (kvm_is_realm(vcpu->kvm))
> +			return -EOPNOTSUPP;
> +
>   		/*
>   		 * Tell the rest of the code that there are userspace irqchip
>   		 * VMs in the wild.
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index b217b256853c..ce782f8524cf 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -7,9 +7,11 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   #include <kvm/arm_vgic.h>
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/rmi_smc.h>
>   
>   #include "vgic.h"
>   
> @@ -679,7 +681,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>   			(unsigned long long)info->vcpu.start);
>   	} else if (kvm_get_mode() != KVM_MODE_PROTECTED) {
>   		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
> -		kvm_vgic_global_state.can_emulate_gicv2 = true;
> +		if (!static_branch_unlikely(&kvm_rme_is_available))
> +			kvm_vgic_global_state.can_emulate_gicv2 = true;

We could avoid this restriction for normal VMs by adding a check in
kvm_vgic_create() ?

>   		ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
>   		if (ret) {
>   			kvm_err("Cannot register GICv2 KVM device.\n");
> @@ -746,6 +749,9 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
>   {
>   	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>   
> +	if (vcpu_is_rec(vcpu))
> +		cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
> +
>   	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
>   	WARN_ON(vgic_v4_put(vcpu));
>   
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index f50274fd5581..78bf9840a557 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -10,7 +10,9 @@
>   #include <linux/list_sort.h>
>   #include <linux/nospec.h>
>   
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
> +#include <asm/rmi_smc.h>
>   
>   #include "vgic.h"
>   
> @@ -848,10 +850,23 @@ static inline bool can_access_vgic_from_kernel(void)
>   	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
>   }
>   
> +static inline void vgic_rmm_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {

I believe we should limit the number of LRs that KVM processes for a 
given REC VCPU to that of the limit imposed by RMM 
(RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS).

Otherwise, theoretically we could loose interrupts for a Realm VM.

e.g., KVM populates the maximum vgic_nr_lrs to rec_run. But RMM
on rec exit, populates only the "number" of LRs from above and thus
KVM could loose the remaining LRs and thus never injected into the Realm.

The rest looks good to me.

Suzuki


> +		cpu_if->vgic_lr[i] = vcpu->arch.rec.run->exit.gicv3_lrs[i];
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = 0;
> +	}
> +}
> +
>   static inline void vgic_save_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_save_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_save_state(vcpu);
>   	else
>   		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -878,10 +893,28 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>   	vgic_prune_ap_list(vcpu);
>   }
>   
> +static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +		/*
> +		 * Also populate the rec.run->exit copies so that a late
> +		 * decision to back out from entering the realm doesn't cause
> +		 * the state to be lost
> +		 */
> +		vcpu->arch.rec.run->exit.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +	}
> +}
> +
>   static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_restore_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_restore_state(vcpu);
>   	else
>   		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -922,7 +955,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm)) ||
> +	    vcpu_is_rec(vcpu)) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;
> @@ -936,7 +971,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_put(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm)) ||
> +	    vcpu_is_rec(vcpu)) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;

