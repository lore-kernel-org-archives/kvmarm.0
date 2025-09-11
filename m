Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013037.outbound.protection.outlook.com [40.107.162.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF823126D3
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606733; cv=fail; b=mwIaZC2a1y/CjD6L31tslaKTkfYmmARfFz8XQSAA5PnJ+uaQfv+mF72FI7Rd6hNMLoOZ8zI5UeyqHWJjn6HLfwWcC+BUIEE2E1ygS59MgyERcNuSPA7SXVQ3ro4fQxXwcA4lvGmVkhKcY3U5HGfHjI0eLC5VnUrOfwcsBx/drtw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606733; c=relaxed/simple;
	bh=Ly4vBFdq5JFGPE+ZkbRgocLfkHtkn6rPL/keGLMxHW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q1v7xL3SEe6Y6MgOKVhIAQg9UvVadXFStnEJuo+Ytj4Y2nrTf6MFoT+NOhlvgqmsxNx8ExltG6nnBC3kZFJyLnZy5BOxB5uTW2BnZmy7zJbcglYjKx4kdHnKAmCwz/uBFOKS75yKnS6nkTjidFY6Pdz5Fm4rrusiUIIUfllVrMU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lJir59bR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lJir59bR; arc=fail smtp.client-ip=40.107.162.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lJir59bR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lJir59bR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qrD91Z6rGVtHrOmPGd+yII8gPC+dp0YT3M6sh99nxsNFjuhAl11t2s9VD14Jj387eaui2PwcThGaag4Mw/F9C3y/zMWSV3YviPuNWLQuUQGAxi5N+dtT98x1XFXmpCEBLILNv5V4nvCtsSvvuG9r/G/3vhfc/ZIZF2pfTjbQhHL0BSSIGaX4I8EtqA27kA2A58lA3lH6pzf3oblGv6uZzQfFs6gyweahPYIxy05iQygWPy42Hq9UTOFKdtbEKsCLnz+FxF2r0JjAWlsUdTuy/EKVbcgu8ackwk1gq0bP/coIUPxxKKd0Z+6q8T9rPahfHnHsqxQKrttADNNTQR+KWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1P0KcXVDgzzUVDwp12a7l5etXTQnafm04DDU9am7GA=;
 b=QL5qcKuYkeOl/iZb7IDz89KtivWMKCbryioA6O5SGb83fOx7gktGpOwB6UmItuborepGbzl8Bt4CIfY5XtgZhxpFWPB2VGmCGUBmV9ShLFLeuYm/7DsxbELrW722ErdjnasriL6sgc+zS2riMvGDGxwiGMVOP031LqgdztycSDnMoRSjGxBek2Lnq0B0aJjeYc3ULhhuJdQlPWDh7qpk456qO46IkrAu+aE7mMXIDliH7fXpkWoqYP+rRK6RiTvDsCQXHvPPClNoSaUVLgbYOE3hiRCbC02cjykTCWnV9KuikcI6rDkli03DU0Gce4KoS3N90CNwkHj8K8znyGkWJA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1P0KcXVDgzzUVDwp12a7l5etXTQnafm04DDU9am7GA=;
 b=lJir59bRGtRSQaCZ/962E3UNyMspopxWokwTLnte9zJtCiIljFbxt5H5LbeujvHi8DsgvQQrIs5D6qaSiVCJfBu6bItuKMhNsBIdm6GzBQYXPLUxi9PxnqpMX+KelMZkVsU0VZjQDShnY2ayN8WcXgM6pa64GjmRQ1f5f2ksibo=
Received: from AS4P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::12)
 by AM8PR08MB6531.eurprd08.prod.outlook.com (2603:10a6:20b:355::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:05:28 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::93) by AS4P191CA0015.outlook.office365.com
 (2603:10a6:20b:5d5::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.17 via Frontend Transport; Thu,
 11 Sep 2025 16:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Thu, 11 Sep 2025 16:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7UrdHXTbTswZB6P7/7ri9nult3GOjPUw4xfvcf6fM15NmVcbBk5iOZYkfE0exwPkos2BogtrGiSPDeA+d89NpbLBjLUE3XL+aCU1r8T9FyS9xcFKYDiZYDs16yv0RKFrkoo8BmIirM3MROfria7v9BCAMjtfodkdzWQJVXFyy5Aj0qhWZpIrbMSo5jrOpZJi1E0V/pwNem1uquTw4wrX/s97/NdbBt+uKvyz87mRBkb9YZjEboSI/PWnhhOVJRThYPAFXrqo3Ninc0oT6XtlfVXoKdkV2kJGzJl6OHmlcCin9XNrXntM5M2D7nQsBQdRUX2YEnqTQxq9zkjQktBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1P0KcXVDgzzUVDwp12a7l5etXTQnafm04DDU9am7GA=;
 b=zFd6RWJZaGmz86LoFg/ABNEIBTAaH/IezF7hZFley+a5Ely0iv5hfd0RQKY/vjjCIezAD/73Ut6yA+HqpWoZeWbMkvCaOehp7o6GZ1kJ5IOLoc+2hYYB/6KTmHOgzYxQ1hSYckn42010R9rnH8SHw2kERtD5PEEsXoyVvOWuMZQ3+ITQhNt5PHCMC5lZLnTDiCLkO4dasSHex0+pj5J5ATICbxfJkyPdl524KhoFiQYu57DJDeFnxehzfWp9ETC2R+wveJSgb10avTh6ruCzssLOWRj5ZW03fFKUJj0QohHVj5xmNvy0RUfutPE/ERhwBecVt9rkzqE4FJF1u7Uv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1P0KcXVDgzzUVDwp12a7l5etXTQnafm04DDU9am7GA=;
 b=lJir59bRGtRSQaCZ/962E3UNyMspopxWokwTLnte9zJtCiIljFbxt5H5LbeujvHi8DsgvQQrIs5D6qaSiVCJfBu6bItuKMhNsBIdm6GzBQYXPLUxi9PxnqpMX+KelMZkVsU0VZjQDShnY2ayN8WcXgM6pa64GjmRQ1f5f2ksibo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB9492.eurprd08.prod.outlook.com
 (2603:10a6:10:459::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:04:51 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:04:51 +0000
Date: Thu, 11 Sep 2025 17:04:48 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMLzIN4udcRg6nx+@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMLs2LcnflSw2uNr@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLs2LcnflSw2uNr@willie-the-truck>
X-ClientProxiedBy: LNXP265CA0076.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB9492:EE_|AM3PEPF0000A78F:EE_|AM8PR08MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: d3be8117-8002-4faf-6024-08ddf14d05bc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?zfhYUCCIoGpfqBwyM3gn07vexW8yw6O7vaGJDwVWJVyy80qOhOaHBUCxRBvs?=
 =?us-ascii?Q?nuopETlT4tDLiPhVBanqZ80ARY4nLTI2NLAVUu0EjHZXip5aI/wyVSFs199K?=
 =?us-ascii?Q?3u5HXvjykGUaXUtd1PxkEGUg7rB+KnVUX/a6a3jjQz68P5BSc+BOM2XDR5aY?=
 =?us-ascii?Q?DSp+5W26dnoiwBwDveB8yhRU7DYO5pC30xtjmkOGT6D7SSoaDQQvlG2+ZpYS?=
 =?us-ascii?Q?b08dzkxIOGQvjSaHNQ+7LkTatNixZcrmpwdFQCQu88zX3CRpAmM9ZqNzEDNi?=
 =?us-ascii?Q?RnLhAVapp0nISmuXDaeGK/MTUwiYK5CtPQSIiWK4LmDS1Ld1pNFjQulD05RU?=
 =?us-ascii?Q?RvgBdQ/u0HZ4VfvuqCsI0BVTRtdVJehy5xQ4FcnueR2KGHcJmCN1jDtuxUz4?=
 =?us-ascii?Q?uQk8s9rI1OeBBj7ZnzDwQxEMz8RGKxHCuYgb6x80z/IxqJyRbcp3rP14CpSD?=
 =?us-ascii?Q?dhfmJqp62xfw73tPU9kKWBvfAxTx+JGdet879WmxJit/24BHh/JU11HQoBnX?=
 =?us-ascii?Q?1EQzLkN5nNcWp4TYm2VzDYKsuGRPjsYNvm4rtgd7lueX9FnWa+sPldght3QM?=
 =?us-ascii?Q?suliZMg2GdYvEY29k3iA36XM3aZO77wUMk8QJF0K1cwHNMMAU8M63cfHM9Kh?=
 =?us-ascii?Q?TWj/ee2O61BEONexubNC8AkbHMVwGpHhbmxCmRDi6HdfreD54kA8T7tk2lmH?=
 =?us-ascii?Q?27RkDFk0SMNruA6WuTXRkgfFNLqzctyblkS+8jbhxd9LjDFwMlPHufHSl2FQ?=
 =?us-ascii?Q?OuTVahiaGaJZg9aVw9mBKdUc8csRppi5rVIQFB7HLABAu5VbVY15XyYpfKOZ?=
 =?us-ascii?Q?/0NrpLMm/EQS9Om9LCRMYqFWdNyyX2zP1dd35iG5qPXmOguuCFnDCCsRc1Jt?=
 =?us-ascii?Q?gmAlXPFGw4xXAbE9DWiJFBVAdIaAUQknGq11pbYoiO7JMkrpnXlBrjEbSLQg?=
 =?us-ascii?Q?lZrMvKtNfnZEt9NhfG5JLfo7a6R5ZNi9/roKwXlpRdhRl/wVOYvblcbcH4kK?=
 =?us-ascii?Q?qYznYe7RrpHiOKidQ85SHb19KNKfpLmRv8cZtqwVz9KHqM5EtzviRlnxkNR0?=
 =?us-ascii?Q?q4/ceTH0DxML7PRZAV2dr9LedQQR1WQVkaAy/F43K6OzmYScRa7f6I0aeDLb?=
 =?us-ascii?Q?dVE4GYN+FaOCJdcI4geLoCydV3KEKZIqAA9Vc+n7VAORmONpwyojucq1HHxp?=
 =?us-ascii?Q?Xt/yemvVd3tnE+bBhTuBS3SXCIEOp59CEyTr+dY1FzVbTZLhHA8xO47WH/Qn?=
 =?us-ascii?Q?naf2rJtlluAWnP6xkvdMCIJCGfPMTr6LsOjenmLnMH1+oSpqCU+pLqs9C6nb?=
 =?us-ascii?Q?W2j1Wkuyxc1aQBvyF2KCyc5yUfhsrF9PIfF8BaY8AsWnVfTjYI9+RTSQT5CK?=
 =?us-ascii?Q?mlsN1cQH5F4B0awci6qCRawpKDvX7tfVKmwIyigM/h74zZZ2Vr/S5fonS6iw?=
 =?us-ascii?Q?DGGE9/V24bQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9492
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e57b0cd3-bdd6-466a-f640-08ddf14cf097
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|1800799024|82310400026|7416014|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eNNQbD4q2E9TyNZY9RGLmgo/umyBD7RrYFGv9CCGa4BHeY64kmElpSBT33uv?=
 =?us-ascii?Q?IM76h5/OM3kp4gN5vc8EE/FPwDGNGkWJmhdSYDgFffMDX9i9YkyXJnQI3iV9?=
 =?us-ascii?Q?ZM8+yQEt3lc3yDUONCTdp8t9oGOd/j8Imtz2GVcyJ444SaShsqRj0TfiGfPT?=
 =?us-ascii?Q?/Vt4qio4fncAJ7pcoL+TrO3+7XQvYDYIdJCW1KtEi8gv/+oE6Yc9fikABzib?=
 =?us-ascii?Q?RWks3L0HkoDC84sRDYN9L9YtB32WYB44eXpey26y/SMHbBvhFYkUvjthZGgz?=
 =?us-ascii?Q?HlaQ89pTJTlWyl5jKqmOLHV7yZyBIF7+VlKbhK3RJ9FgyzcW7lunF/S8qbha?=
 =?us-ascii?Q?seUCyEvdeKB6qggquaCVTnfLy+VpczBJtVEAhKzz+Wc0RWLRnM/SXLYf8PG9?=
 =?us-ascii?Q?hLoavCQ6qldAd4RXQJbJrcP75G7OmeJekOZkN7APKCP8L4w8+JvbIchHpLse?=
 =?us-ascii?Q?x7/YvWid8zD2hAXY1X6U0Z+mLNiC6YgrDFQocSJqYz4V2QL8DkgGHllDUgx4?=
 =?us-ascii?Q?Z1C5S9jkCouFtN9DoZBcx8G9cqgkjAZZBLcF+inb1kUNd0zF2rcwgw4ELrG6?=
 =?us-ascii?Q?6eUJxDRj68uomwwH7AOIFrnYJ6DUzRBLK0dgNsTOP/RkAsKW4GjYgbVuYw4n?=
 =?us-ascii?Q?RHIESYxwusY+AVNI+Dgvl9LU285K+TwqBu15gPmuilJw2Y4SEqwmFEUoCFzz?=
 =?us-ascii?Q?CKUKzbBX5HaABU7DG4i4t9V/VepEUyGvEmfoFaSLXLFCrf0WlPRYxPOC4T4b?=
 =?us-ascii?Q?QHRUQ6srHJhV4ZoLhgXsY+us+K5DYWWhchqs+QY79zjSYtsmyvIxey69Rjuc?=
 =?us-ascii?Q?kLPmCk//U4Ec0Z/wX2bVSFKdr+BFIYwrGTKvScyuLblcUT8X8pxlAUYHkbKa?=
 =?us-ascii?Q?a1Uu89qhdZQfA5gSRB9jxBPRnc7PLFSo/11DUJ9erk7rLtgj+DSD89RF95tO?=
 =?us-ascii?Q?x2YjQY+uZ7mUU/ztd4pkXdhoTkYKAjdwM32a4gBrTVVyH4XkQNioxvGLE345?=
 =?us-ascii?Q?W6FbDBv/13k7w4EGyZpqagNRDFp9SUwd5C3bgKLRjxUABwcgj40wQZglei04?=
 =?us-ascii?Q?uL9oQ3Jycli2a5mBhCtdaXlBvjXxSD5ej+de/o6wfk2burw1iovJwy8LXN/a?=
 =?us-ascii?Q?HsNRUoEA0ZI8+0PEOkdPMz0qcvKqIVWwqVcc8co2trMCnwBpUv+dFSip/QMH?=
 =?us-ascii?Q?uags1zSkvb3R0BhcV955iTMJ5AwgTYymf4DXRXzj1Xe1T+OhXV6ZaUSFVslR?=
 =?us-ascii?Q?3SNJTIP/GpwXPH07QOpyWrmejlPZo82Df+mZAgjc+aq06hc0NeIRM57g4iDv?=
 =?us-ascii?Q?Qu4Haif8SMpijNKJDz0/79Z3YGaV9pYWbPk9UNGwiXKWrcpwUXmleCttc9dq?=
 =?us-ascii?Q?d+5e++XpU7Dr9jgzUNCHY1DZ9gV5TdLTaUCdmVuRVU1em8U2x0DPHSyyZrnK?=
 =?us-ascii?Q?0G7Bb8EvXhZXM7zE9HmO9wg4Q9pbMojdJMxrbexrnvNSOBzqVLTVNTtPkQmw?=
 =?us-ascii?Q?cozoRBPTuQ4C8FJhsHjuNVDZsPyjKaOGFtkA?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(1800799024)(82310400026)(7416014)(14060799003)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:05:26.6577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3be8117-8002-4faf-6024-08ddf14d05bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6531

Hi Will,

[...]

> > -#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> > -do {									\
> > -	unsigned int loops = FUTEX_MAX_LOOPS;				\
> > +#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
> > +static __always_inline int						\
> > +__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	unsigned int loops = LLSC_MAX_LOOPS;				\
> > +	int ret, oldval, tmp;						\
> >  									\
> >  	uaccess_enable_privileged();					\
> > -	asm volatile(							\
> > +	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
> >  "	prfm	pstl1strm, %2\n"					\
> >  "1:	ldxr	%w1, %2\n"						\
> >  	insn "\n"							\
> > @@ -35,45 +39,103 @@ do {									\
> >  	: "r" (oparg), "Ir" (-EAGAIN)					\
> >  	: "memory");							\
> >  	uaccess_disable_privileged();					\
> > -} while (0)
> > +									\
> > +	if (!ret)							\
> > +		*oval = oldval;						\
>
> Why push the store to '*oval' down into here?

As __llsc_futext_atomic_##op() is declared with inline function
I think it would be better to pass oval from arch_futex_atomic_op_inuser()
as it is for readability.

Is it awful?

Thanks.

--
Sincerely,
Yeoreum Yun
