Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011051.outbound.protection.outlook.com [52.101.70.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041CB625
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758027108; cv=fail; b=NceFb4HEP/uf8LFQLwBczApVUX1YIPuIrvqtE448/rE9teotYlORkjP/Hr1ZeKFGI/Ja3pk2JoGdo4sY4kCGYG+kEiKZDNU1Y0eR2xvRxWMBYraFV0Nx19RX+d4PoQnP+CKGgrf94BEDmmrrihjDXS+N6SZZ/ZtYO1VWZTGUYwc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758027108; c=relaxed/simple;
	bh=97kHQY22DC831FCYe2WaZ64fAMqSTdysmtH5bEWmFDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lyivvaHlsbAXNStpQMBT0ZN911BD+OWRRBMq7O6HJwoaMKZfNvDEPx0djM695Itz//PYRuaAfg0uBliRqZfwZQrSPARf4wyPQ7fosEzp1fG+0dN2cskjiLJvgqFwBcr4aUyJCYhWtEt1awYBnmto8q8hRH6TDoogFKg7k5y5MpM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oepdc+St; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oepdc+St; arc=fail smtp.client-ip=52.101.70.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oepdc+St";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oepdc+St"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xESJ05QK9bFLHrfo+HDCPiwFAstM8Z/SqBtp9N9UkHMP/NTnIZepB91TeE9H77L7lrpyEQjluNYCpUFjyJ30adoZkLzRZeRL5dcqh15ojQnKZGkPuiHzdqbvjXyGfvPj5GHqDrZDKPw5//f3i2JRfyBdx3iTYHybFRNspta2BJvlVFWHmwkVFq42lFiS0ajLRZ/bt32k73OpUZ0dBQTbB7RQfzxxDNSQO3ffAwLvy3DoccNeg5Dw5GLWJUv6y9grkGF8oZzmeWUAVEWBdx0Pm7mYpHtkNbrtRkvSkRQqPav84nrI2RdOmOPwkyMe4m2x0YO3HMNEe3IXYIGuasUBog==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKM3Sb1aOsl+0UI2xPJsHqwwceH/IAFchUsJp5cMJEY=;
 b=cxdOqDfPn8ct8Ywi5+OQB3T9WnGO2DWYWaGLK8k0yvFw5JK0IhuaxuJEiKkH0RsPtCnqQtH4s55EBSIlTkjzvcXefB65h4T91kyYNkYB0SY2mYJsGDUzaxShq2OeBJUQ5PAjfrvWPO5/Pa6t1itywqP/bKAqawoDwur3N5t2RnajjCZWFredowQLKeNSKu1jJaH2UkfpaHugHEHu2B034TgErdmVp8kNbJto4Ehhac7OK/aQUDv3wGwUD8EDn45o44SEiXXktkCQVXVL2ch3Wfbv1L8Wm3tVQpP3/krAKijsEH5z5hZeiVbx3NwexOOb9sc98kbVIvAFJGs+R0nGSQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKM3Sb1aOsl+0UI2xPJsHqwwceH/IAFchUsJp5cMJEY=;
 b=oepdc+StcqV5MdoVQd88/eB88KrbqTucj17kAKmP9aGlIvMD6B3/CjQj+Fnz5ZIZpiQsh88v/7Uzn+wX59nmJNjwoFr+qx4dgUFReYzRG9BJlFwlWGQ9ehiSfpTmHFIcVXK/Uo+BAqjtQLt2I4dBqVRrl0Zem2pGHtsRrOLEKRg=
Received: from AM8P189CA0024.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::29)
 by AS2PR08MB9103.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 12:51:35 +0000
Received: from AM4PEPF00027A64.eurprd04.prod.outlook.com
 (2603:10a6:20b:218:cafe::7b) by AM8P189CA0024.outlook.office365.com
 (2603:10a6:20b:218::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Tue,
 16 Sep 2025 12:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A64.mail.protection.outlook.com (10.167.16.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 12:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFlY3KLSPmocneubKzTmHYcg/BLi5yRY/PV1+zPBuWw3g8CjwD5nR+T9GZoeJnoWyqFza+46Cas/OX5KIG6KXilSHNgClOBARKyaD7HFRSyAwycTQ9JNyAjRa6HVu9y16h0fueMr+kE5Zq3ajs4VZ7zT57m/BxnZmVqE8AfswUgnoAI0hcV7eZApdAZN4prrWLsb754qBGPzJ55Ki78h9hGEBROiA6nv6KHdCogGGBkfnTeyKTV/L48zN4CXLgmtalsFyKgoIsKISR5CExJ+LG3FnOIzs7EKfkkhCYUbVPqrah0A6jpL78isrWGRgEEegbfhIRrbJ+9428Ds3SB0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKM3Sb1aOsl+0UI2xPJsHqwwceH/IAFchUsJp5cMJEY=;
 b=PJAp0hn3Mq+8AzQKBJ5qOaf+KG/wnbTlw5r2oLNhOgwc9FSuLlwLnJOjHT/FazJfuq1wt3RGp8fqkqfk3ojeKK62l9u1kRYIDmUu3Kkn/RvtPkxYPZuNsx+gV95gfDYpG5soU+b0e7PhYa8ojsLvFLAcER6D4mCNBGxoQr/hjp8nn9pgZNAP5ZPvPIOnMtFNDnrOju/3ktk3yAsxGjBLjYqZg6ZEBukWCg23MHxUBqCuE1P5LGwlYmtQhk/F0j744F6nKtJP0fC2ZiKBwUcXAhXO5mHgjT9CulK1gZzrWGwVXYhl8bMM9SrG53o8Ba6yLBDw/ZylxPT+Lhk3Y7tqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKM3Sb1aOsl+0UI2xPJsHqwwceH/IAFchUsJp5cMJEY=;
 b=oepdc+StcqV5MdoVQd88/eB88KrbqTucj17kAKmP9aGlIvMD6B3/CjQj+Fnz5ZIZpiQsh88v/7Uzn+wX59nmJNjwoFr+qx4dgUFReYzRG9BJlFwlWGQ9ehiSfpTmHFIcVXK/Uo+BAqjtQLt2I4dBqVRrl0Zem2pGHtsRrOLEKRg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI1PR08MB5327.eurprd08.prod.outlook.com
 (2603:10a6:803:13b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 12:51:00 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 12:51:00 +0000
Date: Tue, 16 Sep 2025 13:50:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMldMSCz+zHBguRK@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMk49UZ1EiUu3-Y2@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMk49UZ1EiUu3-Y2@willie-the-truck>
X-ClientProxiedBy: LO2P265CA0231.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::27) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI1PR08MB5327:EE_|AM4PEPF00027A64:EE_|AS2PR08MB9103:EE_
X-MS-Office365-Filtering-Correlation-Id: 69b020d7-ac15-4a54-97ff-08ddf51fc495
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?mbwd2h1OjnCpaFA1JYYOVT34MrXoCoUCxpwWX8CdCqKmStktqsYUr0tiUoaC?=
 =?us-ascii?Q?F7OOh39DB/Ldh3E4l05ZiIoaN1vLN19ugDAX9QPu4ZXuDETw9yG2TWA+aeWp?=
 =?us-ascii?Q?0rjKehXIhi+Tcpmlj21tUdkO0cuzQoDYSksY/ps7HgJz8nBjWwPmGXDha7NG?=
 =?us-ascii?Q?NwVJco/sVexmcva3MJT9+OTSgMadNTSnAVKdCl48o9hfSxGYtjWiWoM/96sn?=
 =?us-ascii?Q?zi0AvnHNu3hJ6/J1d/JDQvnnzXXvQK8nIir9ji5yCO7T7WLT0xbtRSFvLwUi?=
 =?us-ascii?Q?I43GMQFMI2fVyicQqQIOhAamIbgm+HMMxhQpTL7f7x+60jFKRX1V2IDRVg7R?=
 =?us-ascii?Q?chEh3uWVqgMap1rxeBT/OmIyTnx29LthJqKn4zYRsfI2RMosginf0sO27PKm?=
 =?us-ascii?Q?BYYfo/n93MgC/neIfnZdBiMG07YZPPm8ivPWv5KloPeSlc1T10+XS0NhlCwz?=
 =?us-ascii?Q?JzKmJiO06FAGLOib7+iksdDdFn4i9oU4CdOXpSO/jjFaXtmfr5c1bGqzS0SE?=
 =?us-ascii?Q?GkI5vwiIzcE7aWfRCwtASfAB9krGrPYnL3lXNPmYdgVimj2BiWDo4dasQtax?=
 =?us-ascii?Q?1gE+lmEwLTlSZC59QGz2rdP2hKn3dPGhL45ieEN/UWXxY6n7zC3Qe4Ib6vXX?=
 =?us-ascii?Q?k3LzWLdeZDPrlSPZjN8791EMj8jAkUqSv4T0dcGjI188d81qe1PVi4gdpdPo?=
 =?us-ascii?Q?Qt9C3uMpw1wUBqFIs+J0ZqmTia827uvlNsMP5pTP8dhIZ88WVkcJCWun8ge5?=
 =?us-ascii?Q?IB7zkiyTUKQvAQLK5jIZXsqNtNqDekdRX7LFSFlOQMtCCITDUoSelBSnZPPd?=
 =?us-ascii?Q?AB/h+pLg5jy41OWDuZhm8uZ8fIj3kFLXd3YRzY7eR2kGh4JUpjYqxP0BvbBS?=
 =?us-ascii?Q?hRZIH7hw38yY9UL/oy6Z1i6MfmwqVvzAHuYOY/UmUnxxBE4x7qeAvop/9m4J?=
 =?us-ascii?Q?PnTpw/FeFgXTtuukFb5Fv2uXOaNBwOQ6B/Mmk9ZlZ122rwFoVCx9QXkPEREH?=
 =?us-ascii?Q?2A0tG0M0XVvgmvGGdXv9EHRkHpOYtF+CalRDCRcDG/4MtWIyK7Y//+sBq1ww?=
 =?us-ascii?Q?QXoB4/Z2+mkV+tgxhMdC0h5skKN4GhBjJ07FHPIA8oL1Fzx/6kZRWnsFzjIw?=
 =?us-ascii?Q?KcTN/1ViiH6tMtpzRRNQgjwV4Rg8JB042KtGcpXQWKdxoSztxVS4cjiOIWrH?=
 =?us-ascii?Q?cq24mUvq3XuLYDGjm8vacoGa8k9RiP+B+m9yPLnBqo1/MdF94f+SXooxjfRP?=
 =?us-ascii?Q?/DCJzbLGUH7VIWf9S82dRcnTXsrSyxJJ4nWjgOm5knV8LfDlXVCluzt0CmiL?=
 =?us-ascii?Q?UM60fCHZ3iZOnr7R0VJFbAJrmnOaJbYkuZm4slKhV9v+fUUoaSlGXaKxhGO2?=
 =?us-ascii?Q?x7ikoaq/9TMVjDcVC5etWp21iddpfy1kTpDp2qN3YSyBnG4QEd2fXW+EV6YD?=
 =?us-ascii?Q?Zr11dmj3Ej0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5327
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	08411190-688b-48d7-8992-08ddf51fafbc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|376014|7416014|14060799003|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zMU0lfQPFqNXleW0lSSDyWiLEumvBMlr6nYVNtyW3BMk82GjhFlsfIYinzaM?=
 =?us-ascii?Q?zw8ytErHkMfNhXv4kXNW9U4WKB40RrYbKelprKgE1zevRt6kSuos0bTgu0+o?=
 =?us-ascii?Q?NHaocxQbh0bDlB5s0PouRrWpTNtofxvnw/fyeQ0TcwCNLtkW1i0Vlx+5hDZO?=
 =?us-ascii?Q?FPC4RIsvWGP3k0lauP0ZpifaEh8o+7Rm5IzD4SfhJB9MapBBf0jaWihRa1nm?=
 =?us-ascii?Q?MjMUwasacsEVZke6ZzCyQGn7UjIUbWZeZGkp/7cXE+CtrN0gTM2I5M7pStDW?=
 =?us-ascii?Q?jhW8ijnZ2u3HiDRiG0NgAwfNPfBL/5Mscj6Ssi0ahpmUPJorIfzxjHQmqg/h?=
 =?us-ascii?Q?cIcYT+Qok150AftpsJc876SRwcJbaUWs7n4aaC8TqU+apPeG/vW55CaYGX+p?=
 =?us-ascii?Q?BKozA9Jrd+wM2ru/D6uvqUDyb1q2pwEX6/W2M1tvewmoKnvdzKr7ciMX+vQ5?=
 =?us-ascii?Q?8BjhJfeOgvUfpOwRY/IfdiP4LLUTlaSoaPhCZV8cO7SX3mX04YAMHEtur+bA?=
 =?us-ascii?Q?JEX1ezM/BrJlG1VkBvJZRyKZtArpdvhjOVaz8ZzBkgKLTO549muY5PupbwYD?=
 =?us-ascii?Q?2+V+9A4K2bhNYWfbWwcTnvrELSW+RDtpQdesl7vvXcShQnylROhT/ts6hbmb?=
 =?us-ascii?Q?RH/LKgEK88TIQw9q+JZ4cpqA4L3KRCpcoCS1QWbPc7/Wp9GWjO0oL2fT5PMd?=
 =?us-ascii?Q?w4U2RCMXD++86xydH+Cg8gY53/23OSJg1FWphVilkFPTwpHAeK51BaP576IR?=
 =?us-ascii?Q?AXYC69wdF0OrYObj3MAoA0fgyqlomlwkXBkhKs9ntXW7spOpCOcc/Wk8dI5k?=
 =?us-ascii?Q?KojOkx2wcRsXDgaB6SeHMqlHmZBQcmr6q8XMu0T3sg4mKMD/5MYveeKk+csy?=
 =?us-ascii?Q?/Q7h/EM+f06Cm0PueIQ6mp5KH4R+wd9xskTnVsfb4Lm9XuVsMxcva3Pvo3AZ?=
 =?us-ascii?Q?rXuBx+HpYGE/kSXfdr2liC3mOs1wukplls5DCh02/ZjwCjFwnFWMN2rxEJsw?=
 =?us-ascii?Q?oIuN7Smn1Cn69f6kaNvFPHj+yFCi1fIPNysR3bBg64yJ5bl/iG4IS4vfwYJb?=
 =?us-ascii?Q?+IdMf3w8Yka+DjcyajagoNsIBH3RDXys2F7nfw2hVWiZVBMVXnCiGh+OXEdh?=
 =?us-ascii?Q?m4KzgIEqDX03yFTbzYzbVEMryYWDxyEUyhFKJzc8KQAItc6wAG+d9J2Kh+Kl?=
 =?us-ascii?Q?91mOs1BPsHCpKKjEHjmSM9JGtt3VP7iwYnh1HkVUJSe4qhojrTetQtVVli8R?=
 =?us-ascii?Q?ksdi9criDMIw8fEC27UQQB3EodDQ2AYO+AGZz6cNrT9r8kVI/yFAnioAUUjf?=
 =?us-ascii?Q?nlOZqK/S67mlVkDFWhakg0I2W56oDD29wlAx076rWTK6UFJgfWOefepIYGjl?=
 =?us-ascii?Q?4E7AJuiTu4qXBK9d5DgLwpGI9C0ekW/FCdRepwVhfoX2Bn77TDihVUztL395?=
 =?us-ascii?Q?3dDBv4MqB6+mHTFQNb4v8Cpdcw6oJKBEuheuHi3uLXRGYBjkDMLK8pkoXFNq?=
 =?us-ascii?Q?CBP6x7iOv3cw4qvexMxFt8b/f5S9g6qHZZdn?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(376014)(7416014)(14060799003)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:51:34.6427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b020d7-ac15-4a54-97ff-08ddf51fc495
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9103

Hi,

[...]
> > +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> > +static __always_inline int                                                     \
> > +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> > +{                                                                              \
> > +       int ret = 0;                                                            \
> > +       u64 oval, nval, tmp;                                                    \
> > +                                                                               \
> > +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> > +       __LSUI_PREAMBLE                                                         \
> > +"      prfm    pstl1strm, %2\n"                                                \
> > +"1:    ldtr    %x1, %2\n"                                                      \
> > +"      mov     %x3, %x1\n"                                                     \
> > +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> > +"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
> > +"      mov     %x4, %x1\n"                                                     \
> > +"2:    caslt   %x1, %x3, %2\n"                                                 \
> > +"      sub     %x1, %x1, %x4\n"                                                \
> > +"      cbz     %x1, 3f\n"                                                      \
> > +"      mov     %w0, %w7\n"                                                     \
> > +"3:\n"                                                                         \
> > +"      dmb     ish\n"                                                          \
> > +"4:\n"                                                                         \
> > +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> > +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> > +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> > +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> > +       : "memory");                                                            \
>
> The vast majority of this can be written in C.

Here is the version with C base on patch 6:

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 1d6d9f856ac5..68af15ba545a 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -127,81 +127,77 @@ LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
 LSUI_FUTEX_ATOMIC_OP(set, swpt, al)

 static __always_inline int
-__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
+__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 {
-       return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
-}
+       int ret = -EAGAIN;
+       u64 __user *uaddr_al;
+       u64 oval64, nval64, tmp;
+       static const u64 lo32_mask = GENMASK_U64(31, 0);
+
+       uaddr_al = (u64 __user *) ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
+       unsafe_get_user(oval64, uaddr_al, err_fault);
+
+       if ((u32 __user *)uaddr_al != uaddr) {
+               nval64 = ((oval64 & lo32_mask) | ((u64)newval << 32));
+               oval64 = ((oval64 & lo32_mask) | ((u64)oldval << 32));
+       } else {
+               nval64 = ((oval64 & ~lo32_mask) | newval);
+               oval64 = ((oval64 & ~lo32_mask) | oldval);
+       }

-static __always_inline int
-__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
-{
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       int ret, oldval, tmp;
+       tmp = oval64;

-       /*
-        * there are no ldteor/stteor instructions...
-        */
-       asm volatile("// __lsui_futex_atomic_eor\n"
+       asm volatile("//__lsui_cmpxchg_helper\n"
        __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"2:    stltxr  %w0, %w3, %2\n"
-"      cbz     %w0, 3f\n"
-"      sub     %w4, %w4, %w0\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w6\n"
-"3:\n"
+"1:    caslt   %x1, %x3, %2\n"
+"      sub     %x1, %x1, %x4\n"
+"      cbnz    %x1, 2f\n"
+"      mov     %w0, %w5\n"
+"2:\n"
 "      dmb     ish\n"
+"3:\n"
        _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
-       : "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
-         "+r" (loops)
-       : "r" (oparg), "Ir" (-EAGAIN)
+       : "+r" (ret), "=&r" (oval64), "+Q" (*uaddr_al)
+       : "r" (nval64), "r" (tmp), "Ir" (0)
        : "memory");

        if (!ret)
                *oval = oldval;

+err_fault:
        return ret;
 }

 static __always_inline int
-__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
 {
-       int ret = 0;
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       u32 val, tmp;
+       return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
+}
+
+static __always_inline int
+__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
+{
+{
+       int ret = -EAGAIN;
+       u32 oldval, newval;

        /*
-        * cas{al}t doesn't support word size...
+        * there are no ldteor/stteor instructions...
         */
-       asm volatile("//__lsui_futex_cmpxchg\n"
-       __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"      cbnz    %w3, 4f\n"
-"2:    stltxr  %w3, %w6, %2\n"
-"      cbz     %w3, 3f\n"
-"      sub     %w4, %w4, %w3\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w7\n"
-"3:\n"
-"      dmb     ish\n"
-"4:\n"
-       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
-       : "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
-       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
-       : "memory");
+       unsafe_get_user(oldval, uaddr, err_fault);
+       newval = oldval ^ oparg;

-       if (!ret)
-               *oval = oldval;
+       ret = __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);

+err_fault:
        return ret;
 }

+static __always_inline int
+__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+       return __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
+}
+
 #define __lsui_llsc_body(op, ...)                                      \
 ({                                                                     \
        alternative_has_cap_likely(ARM64_HAS_LSUI) ?                    \
(END)

I'm not sure this is good for you.
But If you share your thought, That's would be greatful.
(Note:
  When I test with 256 threads for futex_atomic_eor op, there is not much
  difference with former assembly version)

Thanks!

--
Sincerely,
Yeoreum Yun
