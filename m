Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013016.outbound.protection.outlook.com [52.101.72.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AB62D052
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757975704; cv=fail; b=frFQzW1U9xejVgcly6y5aJGM8DvwzA9eqBHgo4gUnSE+Uiivbw/ESMiwmgOqLWjMytfPuarTgR+8CPRERa/tghzhetJjNHJaoMvPhSSj38XWekCGhBN34c2ont/nT9EbA4hrnq39hOtF19YFcl8sRScU5cBUMkEpPrmkpAV5Y1E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757975704; c=relaxed/simple;
	bh=uohERjtw2SUR6bbAGqsroYkQrHeUJHmh1J3Vg3Kd48g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VffJWkJjZEFnC+5jvtxdut9kW2kGkmhgzdWPddWQCYRj9WnaCZi0qzwjx2jkaNamcEhlr7LMGM60Ln5CSri5FRiAje9cLShVDAQ/hFmRz8j3K0bPiQndGvYFjYqKRpgqzp2mzts0HCRqMaO61iUinHsoGwaPLeT1jKpnKoXUDX4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ct+PhTiz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ct+PhTiz; arc=fail smtp.client-ip=52.101.72.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ct+PhTiz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ct+PhTiz"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XR+QOL1VQLLFeog8F91ASEHPTAKD8gEuSK5uiiuY5tHb8MlcZ7lQYCw9YnXOAqN6fpWmB+/+3T1BDv6auiM9pGlPBGIdZcNZvyH2LIwF0pnuzYypb0L8aUuIBldw2o8/g1zPBBWxjyfeKW0mdOdSQInJASKzGte8UIO8uwnbNNV369P49jf1KcVpH5aI9tGm2izMlMrM10BbuYJcRzNf4VjOi+EboF3LRw2GsI4gkRTCQ+tuW4qVNUPQZ+qer8M2K76Q18l5q2oArMTddXnilVaKNm0XjsUZwpll50Cn2wvYcrP/wDfxK9/8sLPaFjnqGTqlcO+NR7OuQ2q2OiTZIQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JB0gu3gaecCEmuKi0xOvVNrFR3Z9sMXT1XAybQt4avE=;
 b=UZbPAgfgAnpk9KXIZfOkN9UQhbvz1eEu0VQ01l+cjbgWCgUUAhzu+X71zWvevJIHfimHqe4cYO8wFcnra0OPi8O9P2R39lnXXeaPsjLXcR6PsSuRQ2Dz6vkkM7k1uhjd5IgB5z/ou5sQD24NC8hopH0Udbt+auaIqKAdPgtBtn7ZyFA3uK+sdRZ9RwblQ37r9Av/czexU6aQi6Eh1qd6FhMl/snZeS04wFhNd3w1PSzuncsZTLtZNmKkFwKDAwnRBX+itpX+igYGodUukFo/BHQ0ZM6RHMTl5hW5xhnjder+Eo6+EKq7RHGWeAdGYzf7t1PzYtZ/m37JbSqZnpdQDw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JB0gu3gaecCEmuKi0xOvVNrFR3Z9sMXT1XAybQt4avE=;
 b=Ct+PhTizAsHW0YKffhStsEyE+RkeALq+08KN2bQGz3feVAdGE55lewT95ttWEhL8Twm08FqJMkLd2vqpNe6C9fsjLo2KcIqZFxmuolJYqmB1KJCBGyBifYL+gkLio+EU5FsrVbYmkSyYzjRK9Niorr+oUYwWJLX1wFP1skj7ocg=
Received: from DB8PR06CA0042.eurprd06.prod.outlook.com (2603:10a6:10:120::16)
 by AM9PR08MB6657.eurprd08.prod.outlook.com (2603:10a6:20b:308::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 22:34:58 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::36) by DB8PR06CA0042.outlook.office365.com
 (2603:10a6:10:120::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 22:34:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Mon, 15 Sep 2025 22:34:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OMXCXFEuBORaEwRR74hKqn5KO29nrDR7rjUD+v0XAay1JeJnOJioAjwPowDUZZljNFNIJ1KoRW7WaBBBWY08UJvWir49yOTK+coOPtOf1AbLPJzaYI+eGR9CYmgPbRPYfXEUSttKD4+QDhsgp4pEIzqKAqffmxP4+TCirPHVetX4FDeLpaZ5qhZOmzfdbyQVNNW9Jf+EAqWeNRgXfvCdDOfmv8c8FaQ78f0Mg/jRDBwTdAgp8+lqDxcB2ZdMy9ZvaN3/bx/ADu5HKstQx0VMiuOlVX2NM9mHsq62sEWCe0KV2opcyk8PIURPiWsae0LkCUsl+dTrr0c1CSczrfJgaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JB0gu3gaecCEmuKi0xOvVNrFR3Z9sMXT1XAybQt4avE=;
 b=mMCfcPzpliZe2JFKidJou/j/pjdXU4XRoJod2MZvYdH/Fknpn+BIrEkb1MaEXDr/vnDxIB1ZdJM2SMmBH/9apgg9hw6otoXblG2C8Dm8SKD95k0nNtHKOcpKklqd0cCobJ6jhwACDo5NIEiF5QATgzisI13jZAVQwiG+UmhlyGl+20arfp6lEpQTETmK7FUj4Ro05x2dQkbwFx2P66EL3fvW4u1CXsbroCjj2B5R73I84CbnFvTW/LcktaiO3wk0E0xSWoZmPXSlvAIOMEMjb8LKnhOgFJ3QgB1Ce9bswMPiKTIhjaXz7/iY8CYMgbXYZccZnO1ph0YCncX8GaMmWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JB0gu3gaecCEmuKi0xOvVNrFR3Z9sMXT1XAybQt4avE=;
 b=Ct+PhTizAsHW0YKffhStsEyE+RkeALq+08KN2bQGz3feVAdGE55lewT95ttWEhL8Twm08FqJMkLd2vqpNe6C9fsjLo2KcIqZFxmuolJYqmB1KJCBGyBifYL+gkLio+EU5FsrVbYmkSyYzjRK9Niorr+oUYwWJLX1wFP1skj7ocg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI1PR08MB10052.eurprd08.prod.outlook.com
 (2603:10a6:800:1c7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 22:34:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 22:34:12 +0000
Date: Mon, 15 Sep 2025 23:34:07 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMiUX0O3MpdRyb3f@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhrscd1gz_syMtL@arm.com>
X-ClientProxiedBy: LO6P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::7) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI1PR08MB10052:EE_|DU2PEPF00028D06:EE_|AM9PR08MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: 04068858-b714-44d4-b18f-08ddf4a8198a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?IcPa75Qku+6jONO2aRupmbBazHl9d3waxU/bwpydG8PldKhN8BimA3RMCaMT?=
 =?us-ascii?Q?o5BQo2YEZBN4vadD3+L5gQ6ADUIRtcQ0f1O30TdQT/6hX85uZ4XBCFJhwaZp?=
 =?us-ascii?Q?TH+gPMykJLcY7XYEMeDhi4HGTxKUvH1BTJQllFLDdCQsREnPD4TGHtGOYvaT?=
 =?us-ascii?Q?EYF/kYpDeix9Mg8AfIVLK4VXGCP2qtnoGrjtb0NG8DbWHsVdCEtI+5L8N0Iv?=
 =?us-ascii?Q?Iv6pimFZDAbpwQYm7AmDcby4hr6DbZkHvrKm+QzUIYy9bMaB7xLvyM0nNVMm?=
 =?us-ascii?Q?wuWKGJ5uAqcZCkTLgcOEdw4CnH/8RnrbTol7mRpjExugGxs9C/+iRWWHepO9?=
 =?us-ascii?Q?0bhTRYZPzMvUoTohCp0xsbUzXUujDIM/Oss0h/xuF64OEzLJgtBTEUsrAD+O?=
 =?us-ascii?Q?PfV1CewtJqw9p2rv8wnNYg0Y5JiIAKYHgSzcbgdxm8vanWyVepVNVGp31jU4?=
 =?us-ascii?Q?x9pw+5zK71ud07oVTKRw9r/mZkE3BqGaylIHXjkDDvcNMU92qNGbbvPHPJYf?=
 =?us-ascii?Q?sgRpX3fY3Q98YSFJnViZye7k2KWqmdtSKGjh9GWZIoTkp0uYVlKgseVk/OiP?=
 =?us-ascii?Q?bfG4k4HeKdwLFDRcqBL0XWabk7+K9aJkhrhMI32TsQeuKDae9Hbsqu/jZTbl?=
 =?us-ascii?Q?1FPlHXG9AMtEEO6GwTnjqr/UdxhwspyNaHr4W+kFgVieU1PdcbT7RehdXu3O?=
 =?us-ascii?Q?qv7VXJ4e5hrOVN7wANMhI5/1pkBqTKplG+8YGZ3fbkx3JwyazuP3lot0CYWE?=
 =?us-ascii?Q?IlVv1yhtAmOHsYxvVCfn+aPFDKq3aWJUI7atw9hNTMAQOIQbxSLK2SxSWqP3?=
 =?us-ascii?Q?QNh+gPYmhwbnLxR571KLdoVP/2oi+h1NDTTJNatXCPTkEs3RbdSWhWuTM8go?=
 =?us-ascii?Q?EkA6xaIzYyxM2AtWu7g4cXmXD4Hziw3LVGODO0KOAcI4PNHT0c5CEPdq6qWK?=
 =?us-ascii?Q?B96q/8bdOQu7fjjs7uWW/ag8NQENyn1BoDeJ0yuS7Y+FrhJeAmJNr9SC0QtY?=
 =?us-ascii?Q?2yTaWnovIJLMQ0f7W/cV21x87pRKVIdmaiomFP5o/k4VyyK4/jiMWWTPEMMh?=
 =?us-ascii?Q?Pjfwrmy2zRTXRGBJjXbGJgWSHY13+8qQ8+ILThFEO9uFRVAZ7WOHz4KBkRsQ?=
 =?us-ascii?Q?+nIzvdIA7p29SAF48Oeea/F3dN8dstOQoqooxGGQBknECC4swzmI819pld4Y?=
 =?us-ascii?Q?nGQNmXUkDHo3IipedGhtCeRu350QfkLkIuXSoR7jG+w9xZ2VvkOJT01XoAi9?=
 =?us-ascii?Q?op6gMra6nrYgQupg+ifWO4jZvPVReD5VZBBaw4LR23yfPezUGre+f/2jF7Jt?=
 =?us-ascii?Q?FBkeZT08j5v1rvPPCEUCPKhDh1hTuKYvsfb9WoDe2SHSXKGDYZRzeCAKmoPj?=
 =?us-ascii?Q?PJ8PD0bovoafDVOugyDsqbkqnw2v1bFCqMmAo2YblsoJr1CMjj7kQLIRxA7q?=
 =?us-ascii?Q?YHqJOIjEHHM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10052
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4fc2fd1e-36d1-4350-b7b9-08ddf4a7fd5b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|14060799003|7416014|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KAUp5Fm3qocdoYWEn1pMSkcnKNdV5g4Ukj9Ujy1r53Fj8nyjJMJ9I6CSpKM9?=
 =?us-ascii?Q?8oe/5PSRYWtVmGDaFKpizaCeExH5v/aSRtGqL8irWam3yxO1pqNdr5lzqb8m?=
 =?us-ascii?Q?bJHHhyyRXiKbn7N0cHTBuxTykCfjrtAi/Qp1i0onc+A8HBFZoUZKy2NLS9rz?=
 =?us-ascii?Q?XB/3P+L35XQBc9aPeuHmCaxecjFk+7sNxs+YVC8by/DQF3wJQnIlbmw6AGrB?=
 =?us-ascii?Q?R1IqOqUT8EJtKGxddwJghHqcbRALAcRGOWWLVGcIcQq5uo5jeM3U28g33qr8?=
 =?us-ascii?Q?jA/7RqiDzol4z334iyA88tYq1b/uw/EwRRjVhyNvQQVvP50I+KNBt8XzzIcc?=
 =?us-ascii?Q?DY4Pf8L2x+GVwVdCtrH32IVGNApq9yf1Z6cTfEG7zKzw/2Lv4nLIH7Vwimcd?=
 =?us-ascii?Q?o0vER9cX/klkUJ5ji3/mbIteBqINBXoHDzN3rs59+ZAlW0LrEHJmVfGWwDlh?=
 =?us-ascii?Q?oQ3oD8r5cDWJ4JqQo9Elm0UTeeNVSzwZ9RrFyxwelxqSRT+TYcCUGPhGm0HA?=
 =?us-ascii?Q?DcmBS9MIGfo9AD0RysEJzP9ClQwf2B+0tC9RwRH7kF7LPlwKgOosqx/6sqG5?=
 =?us-ascii?Q?6q9y3GQy6OhYIZnWS0bkdINc0BcxHivNICZBZl1NyOeqX16jzdD3X5mnxgNq?=
 =?us-ascii?Q?ICZk7fNtRWFCkJmLWsAia1JxURZukgogGyD2AL0D3yDSlMGWTwic8DI8nl6r?=
 =?us-ascii?Q?seROGWHll4Gucr9VV1KAf+3vLciTQYCZV+Wo+XHEVWjyAKcgeKUDCKKS/fRi?=
 =?us-ascii?Q?Rek/45nDq8/C+ab7T7Ykms1X9JHTlkVaLAJK9bUP0jW/PonldSH9MDjSYwFA?=
 =?us-ascii?Q?MP+AnOIpENNbPcxFvw6MH18TXtNh+y39+hpU+ir+WMYIG+AAASIHFJ5Wk7EC?=
 =?us-ascii?Q?/NeQTrer3CfqPF9HvplDlxE/hN3QW+ljsFnp/ffuiTywPXHiseYOfsCOL59N?=
 =?us-ascii?Q?+WWWKCfVt8jPgti8BR2HLw5FHNPniSIb3bM2wM+610AUzznNdWFh7kTrUL9R?=
 =?us-ascii?Q?S2GHBJf0UKUfozxmk+U8DBZLCYsAfEuJVsMqgukVChdp2/o+/pzeEU8wUSdt?=
 =?us-ascii?Q?EHpUdrGtDZbP4/GlmgtqJbybluBa9l6AqTS8m3sciQTUaSkyC2NKgDpRtvtk?=
 =?us-ascii?Q?YyA1vhfSs3QlnFp3Ok6MAxEEKSv7ycLhPlpjaUyVMrguQXiqeL0sT2VNyPtk?=
 =?us-ascii?Q?nWz1ldWnql7ncrASbjooEIAe8ilBg0bKshqB7uKaKU2gSotWoRN6TIq5STN7?=
 =?us-ascii?Q?SUgy2jxy8yjE0N+jPJH81+8D74IJF6yuj1Yt/EXtDcmvnd0zvq3s5MzN/5r4?=
 =?us-ascii?Q?D3xkaHjZMSsaBmXqTprWxqMrEJUaqt/5JxsbgZ5MoqUEHFlTQkpMJe/Nw9OH?=
 =?us-ascii?Q?pBsuMfgO+xhHhjogkZ2JKFwDRxy1oABDlY3D6nxsd8dad73UM283Grg2g8Em?=
 =?us-ascii?Q?ob7lBZrA380LBhIwqTVXwuKumqjrmBBWIAhrmmMXsOBi9mrjzUTlPjYm1XSh?=
 =?us-ascii?Q?4GG35hzW32DeLD5D3aYpAl9TsYUIdSuXb1NT?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(14060799003)(7416014)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 22:34:57.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04068858-b714-44d4-b18f-08ddf4a8198a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6657

Hi Catalin,

> > > On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> > > > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > > > index bc06691d2062..ab7003cb4724 100644
> > > > --- a/arch/arm64/include/asm/futex.h
> > > > +++ b/arch/arm64/include/asm/futex.h
> > > > @@ -7,17 +7,21 @@
> > > >
> > > >  #include <linux/futex.h>
> > > >  #include <linux/uaccess.h>
> > > > +#include <linux/stringify.h>
> > > >
> > > >  #include <asm/errno.h>
> > > >
> > > > -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > > > +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > >
> > > I just noticed - you might as well leave the name as is here, especially
> > > if in patch 6 you align down address and use CAS on a 64-bit value as
> > > per Will's comment (and it's no longer LLSC). I think renaming this is
> > > unnecessary.
> >
> > Okay. I'll restore to use origin name.
> > But I think LSUI wouldn't be used with CAS according to patch 6's
> > comments from you and additionally i think
> > chaning the CAS would make a failure because of
> > change of unrelated field. i.e)
> >
> > struct user_structure{
> >   uint32 futex;
> >   uint32 some_value;
> > };
> >
> > In this case, the change of some_value from user side could make a
> > failure of futex atomic operation.
>
> Yes but the loop would read 'some_value' again, fold in 'futex' and
> retry. It would eventually succeed or fail after 128 iterations if the
> user keeps changing that location. Note that's also the case with LL/SC,
> the exclusive monitor would be cleared by some store in the same cache
> line (well, depending on the hardware implementation) and the STXR fail.
> From this perspective, CAS has better chance of succeeding.

Oh. I see Thanks for insight ;)

>
> > So I think it would be better to keep the current LLSC implementation
> > in LSUI.
>
> I think the code would look simpler with LL/SC but you can give it a try
> and post the code sample here (not in a new series).

Okay. I'll try.

>
> BTW, is there a test suite for all the futex operations? The cover
> letter did not mention any.

with selftest's futex testcase, I've tested.
But Since there is no test for each operation even in LTP,
I tested it with additional test from me.

>
> --
> Catalin

--
Sincerely,
Yeoreum Yun
