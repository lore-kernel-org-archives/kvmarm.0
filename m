Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C940B2DCF7B
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118066; cv=fail; b=P/aUcXro19BpwFEqPqgTpB00tfaa4Z/S9ZSs+l9qhbQajM7RSAHqlxBuVoQjV/x1TWMHf0sixcwSf3VH/phkbE+l7DwXU0kNPvL1+SrbbArl/YB9m0kiltZa99chU8rtciciJqSX/Vu2dCiIEKnPFA60VbXX5BXkABNxNAw1mYs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118066; c=relaxed/simple;
	bh=ZLQANhO6Vgtz7JBzvUTZqiIFGoQpeC5aePmfpwhPyIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uWDz9VpswoFOs3nBS1m7TzGbb9qg7tRCjA9F/AkPoPxQ/P5IhI9Hvl8EpQNVhKaIRNRln1kOmcjVy2KzPDnhGoct031aWKg2s7iuxANI4eTPC6l+tzm795xYs5/bonp33Chqb2ul1UMSveTwXbZG7prWs4njc6FNiWjniV3IoCA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h4JK7AfV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h4JK7AfV; arc=fail smtp.client-ip=52.101.72.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h4JK7AfV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h4JK7AfV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X/7klh58/IPEK7J5t885CJTnC8w9wSNHXFzt4aH278tIz/bKCXaayZ6zkFDQ/QubRuYt8bSmRVvAmzD+iHH+KyTTo/9mM+oCNaLgM35W8SMD3LMEw47Mln9jDvr9pNIxaJV9ekQB5scMMJ1kexIL5HLGe66vV82h8NZbiNcBWmK3ZXdam98xLpH33L7ShgLZowgd0bPq7qzHyqLpaAZNzabLp5+KZ8pmIvqArcSx5U3AHVv5Z6JO383xCTLdq0Ti/lUGcNjsNZ6FWsqYfk+XBKCuIZdqZ5jscee1hGdQUGl3aqvxRqq74xPkI7PEIJ9tJ65ke1cg/IyJ6fTXbP9zqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKTr83LNaABcj5fz+TrF1DVxUuoLcn8Q/XJ3dh5aBxs=;
 b=FfEQeo1/xX7KKvxCNBCuXCQpDkp9knnnVXnVEqqE89Ddvpp+U172Jg0u/xGDHRtpNR0u8EENWqYQKS2QrdciKeAXcNSo+G39ldaq0XMxYCmg9CzhBXF75UjTmdL7PzM9tDuDOv+n2KJv+nJDcmPc8i7jVf61+GJWHyDEBh4sj8ipjT1Soo2M5mPFzys4VuFdWRuE911sRNpJGo69lWToxOgO+K/rQTtSa57r/wA9zwzBuDo9QmTt9NXuAwBh23Gu9XjpQdJa7z2+MHLUm8Vr/U0OTBhAHRBRpjAstm579+IIPBncSuapREA8bwU0Aiee4MIYbvyw4/FiqDhlMhyH9Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKTr83LNaABcj5fz+TrF1DVxUuoLcn8Q/XJ3dh5aBxs=;
 b=h4JK7AfVYCRPsTM0lTcW610LjG66/P2GLBGV8AJpiH3SPknQ9+LtzCDReH9RvqiO6pSUmoMxvAocvqF3twPdxoBTf91lr6CmPiH/b//km1GT2IX1xQdSzN0MiIBosXi0aDX6xdkX5L83cdgtsklW7R5DYJTtKHg1Wz3VDBio1+s=
Received: from AM6P192CA0034.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::47)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 14:07:42 +0000
Received: from AM2PEPF0001C716.eurprd05.prod.outlook.com
 (2603:10a6:209:83:cafe::a8) by AM6P192CA0034.outlook.office365.com
 (2603:10a6:209:83::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 14:07:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C716.mail.protection.outlook.com (10.167.16.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Wed, 17 Sep 2025 14:07:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRneQ4YBrhbfCkb/Prrz3UqJmE4aGpbUhfI7ftfmyXSvTZWvPWOz7hrN95/Q7zFZfnTYkKn8/ybASYYSdcS06iq2gq0IXS2EQ8NUufIXs8D81v3SXkpsGFrwmEqlOHvLX8bozb7n2sL+UhPsUEH3pxUvlaNwOl8GSru5JwzEJ4XzRxM3TCA7uG0D5fK+iHfcAc8yJi8pBNsoZ/L7OMwqOxjaDciS9SKiKqna7kypMz6BBewBnyBTXFIN0Xn04+fNEiQ+7VQwFRW6l4hsozIMIeNitTmanls3set689G6b0IUV1xSAVnsnD/JYhWQ6bHRAil4lK+VC5kdehvGPstmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKTr83LNaABcj5fz+TrF1DVxUuoLcn8Q/XJ3dh5aBxs=;
 b=sFdNWmWXsXH2r+KuuqCdn5G/9NWLIo0/jCMAkyUlWHvCKJ5MWHWHqvdSv+ftxEywmRzct66RXK0UYqCSFahhVoBXvuBtFOpJDrhkq6vbNOyarPclw7IlbePdjUWagI5NZD5UHqSoOHHUwqvqboaXsaf3VqPNTtg0Ct27MgsS3xeThHI28EOBSUS9bcWGOuDOVdNncVQvXBwET5iBE0h72EWygwPCnG6lERUqOxG33/bAXg5Ghb4QSF6xStkflW5QHJqWK/LcPKgU/JVr6Lr5y6CKBWPttcZRb+RCaFgpvLenT6NP2KlRu1q8Ftq14bm191Ij0q8F2Y4L6Y/TyXTv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKTr83LNaABcj5fz+TrF1DVxUuoLcn8Q/XJ3dh5aBxs=;
 b=h4JK7AfVYCRPsTM0lTcW610LjG66/P2GLBGV8AJpiH3SPknQ9+LtzCDReH9RvqiO6pSUmoMxvAocvqF3twPdxoBTf91lr6CmPiH/b//km1GT2IX1xQdSzN0MiIBosXi0aDX6xdkX5L83cdgtsklW7R5DYJTtKHg1Wz3VDBio1+s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AMBPR08MB11591.eurprd08.prod.outlook.com
 (2603:10a6:20b:6f0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 14:07:08 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 14:07:08 +0000
Date: Wed, 17 Sep 2025 15:07:05 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMrAic2NbXTDsctJ@e129823.arm.com>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
 <aMqx67lZZEgYW-x5@J2N7QTR9R3>
 <aMq5DbqsXj6vP7Xe@e129823.arm.com>
 <aMq-VKIo-tYoGRSz@J2N7QTR9R3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMq-VKIo-tYoGRSz@J2N7QTR9R3>
X-ClientProxiedBy: LO4P123CA0350.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AMBPR08MB11591:EE_|AM2PEPF0001C716:EE_|DB9PR08MB11461:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f23990-05aa-4bee-9619-08ddf5f3904c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?RoLc+Atds4guzPLe7+iQs3uVcPqrKKqHEDud6qhyCmTxjTH3GXN/TEQDO+iN?=
 =?us-ascii?Q?/QmBE0tSUyFP8fq4IazvFJEoGHkZCN8OL4RzJ9FvtsFpZ+XAvHySUWZqicKM?=
 =?us-ascii?Q?ooJQ6Jz52yracKhNa4FwUxqpDG0YPVWfVPfB4ahzbmcBg217uvaILnGqFCo7?=
 =?us-ascii?Q?F9va9CpanuXDR8Mb0BIUiRenI7GzZBwjSXb/rPf5CWcFyjYsdQuLPCDranN1?=
 =?us-ascii?Q?UZv3+TJeP492dDbLJTBeytmxl0cKXvxafP1tutTAkcYskTWIgDI8BRpjIyea?=
 =?us-ascii?Q?LDJZ2cSdmEDzx1MpruynkjkfhRdhU3kVTLMm2B4KH03WY5en6Gb/ExLSJ7iu?=
 =?us-ascii?Q?2rJmE2rBc/vza5RXKyLJBEqGg73wE3wII6l6epNPRCYYLcsEzAqrrvY47KzO?=
 =?us-ascii?Q?W35TKNaaCTEmWk2/xwk3F33bM5WdhJ5rukPeipUeCcfMe47Xss1CTa27p5Ly?=
 =?us-ascii?Q?SrXgs++kKSrYxm65FuctCM+Q71QF5oyW3AZdTPnY5KY+EdxjLKXBvWt1UcdT?=
 =?us-ascii?Q?mURbRuIpXHLcd/1twvEeLg28ogn/Kme3H90hJiYOSZPESywV90a3neX8AOtS?=
 =?us-ascii?Q?9kMcy4V35SUAkMEksaMpsy8T5xbsmcLr7G4OYubRiaPgCKWQI1kNWDQd/G3P?=
 =?us-ascii?Q?7at0XXN88w2vHAbrtGB60CbCl24AItfK368LqmSijz1fdX4TXbJXSW3AEOF7?=
 =?us-ascii?Q?ysRYGr7hzvLVQ99fcJGMiLthemXRaPlaghKUsWjvBna9MNKTaRwD9q4tzBjM?=
 =?us-ascii?Q?a1YnX1G5RTD8AT4+aR4Vi/gY0uIvX271ylKqyTkEyh6+6WBu28gD+MbXA325?=
 =?us-ascii?Q?SwHIANv5PwkpFvjx4Z307/ORHx7ifUWnyOUvw5hqAp9QighaZAyku4fJc3D5?=
 =?us-ascii?Q?ddt59Hzy7BLImOL4TqMG2YUmpox2il+cTMN1kyWwCgeUbp4MTpAUCzGe6KHt?=
 =?us-ascii?Q?r1n5ZBVXPZgt48lGNBPCgoV4m5yavXJMMcVHlZiapKweFeMFCEpQ5Syiz7Po?=
 =?us-ascii?Q?Y5/7COhhHUwx0i1ohZui6vZ/vF70WGpyqZh/NYtY40E71NnjaeUtTaSYFxHs?=
 =?us-ascii?Q?F87PyBa8URHiMG4OwNC+VNwjHjO+BUyV1OX1mu+24HoZZ7h2ZIoUwAtwtiyI?=
 =?us-ascii?Q?cRlyEBAUixoFtyIMThTLvB3laLTwGcgCwpWvgpIfR4dOTcDtrkU8YRIehF3D?=
 =?us-ascii?Q?pGhhpPJKHNL1LhKN4ThCkhkg17NL2UBIAnR6r7STOhlaFqiO6eZuOA7WUAfR?=
 =?us-ascii?Q?CaqWPU3T7SEIjpBH3mZnngwwNkzEIzj6exIrBYrsbg1J+JiiYpeb3YqniZNd?=
 =?us-ascii?Q?hcA/osSZK2CEd+SrTqeQ5wpiSyeT9i+5q4WpWzGv0VShXpRZzM+uUSoUQgp2?=
 =?us-ascii?Q?lxUmOcDdWb2CYK5rUlPSxQ61SG0WwDD/YBvzGH8/b4ugr75RgiVfuMTgwr0/?=
 =?us-ascii?Q?GYFbmJNls7o=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11591
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9207099e-45d9-4750-8cbe-08ddf5f37d0e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RpF/HjCgU5e3f6DfhxTzUYsAvMVoO76sm7ZJ0URmmzTV/EiIC2jwysbUrBgf?=
 =?us-ascii?Q?hbfiFcvvrZ/bkYl6fG5fK8pB3oPAte6Vjh+ToVOoHJyMO7PyT2LDmOJZP0jz?=
 =?us-ascii?Q?G/1/yh/L4izkO+s9MdIbUxUw2R90Y9Rdi/N0qgMJ8wfd3F+lpnbrl+dJUPey?=
 =?us-ascii?Q?agLelfCBpjMupitU9bCszOI/gzmj6Q5QE9eJUbft1Ycr3yU0XqG2p/UZ87st?=
 =?us-ascii?Q?lqKba2KM1RCJHiwwsIbrkVtbM4MLf6macHL8bnOC3aktmpoY1ElM61jLLYk0?=
 =?us-ascii?Q?/U4I0HcETZx5ZTnIiYvGKyjCAsMuIa+NegLbel8sQI51RC3JFQLbQ5LEHlQw?=
 =?us-ascii?Q?MAAIcxFRUPLQu9fCpDx6GIqWdp9EvrVY6omSR5BbGlmetHMFjGnvPJyC08bc?=
 =?us-ascii?Q?Lw8ecrRBCfGiziGoAAD9LWB+HEQSNSWQlmWAibmtpWphvuoT5eOhWvaLM3s8?=
 =?us-ascii?Q?iV1jv5YrVRo81VpNFdSAvM2IOYJhEP2oyLWJvlAa06TOm7x9LqV3IbqbB1dl?=
 =?us-ascii?Q?EDNEJUkGYVi7pH52rQ0IKN3GlnJpLszFBv1nya3MNdwipvxn5kRKEuw4SI/Y?=
 =?us-ascii?Q?xNfq7YY6854UurvkCN6ggfcir26/DctiCwvvHwrLjD2lkVFJL6Knlwnk7979?=
 =?us-ascii?Q?xWrYYjuczozxnakQUSSWniqA4T9cMR66DKAGDErhMWdviVDk86rjAP9yVRya?=
 =?us-ascii?Q?JJTffCv03rlYBaVXZLe9w9vQMMHbKqNwef7reJQUbL5Et3SESR2tMAItzyIr?=
 =?us-ascii?Q?U2zLuyVx4Vzrk6IpX3U6M5ska37R6x9ZP5pqQR3fXra/HXGKqYRYj0wnITPP?=
 =?us-ascii?Q?UfLxIinXRllYEUUh0dwIakWDYOenZmbzJzlPgVMZmquJ1yc0LxEE0TQD6tF5?=
 =?us-ascii?Q?YBBfNQMvnSuPYfW2WArWqtV8H+FAqTAw3uyhegPor1VmfVUE7ZU+g04PsStg?=
 =?us-ascii?Q?xR+Jlklj//RVr1N4y8swA9ZD72AOrituFlLo1sd76f/v9y7e/7lU3Jg2M0hf?=
 =?us-ascii?Q?tFeAp74grmMYQEKUeHwh/jI/T8/5suN07Z85uLHkCkQDLuapagSl1oAWm4KS?=
 =?us-ascii?Q?L2esMGjNbvp9C3JkLxFGCG834MJAGp5M/OruBZFxRGPvLSIeIwqLlPUfr0YE?=
 =?us-ascii?Q?jQdKuxWD1o+PTNAJLEymEnj1CxDgi778g3C5LM/ZGFJ7xnpKPR6Y0cgdcFQy?=
 =?us-ascii?Q?4cUDTBZPFWtWtf6R1Lzi5KZm+5OVs9kYQp+0q0vDC651p7zkvbgLDLtQc9BZ?=
 =?us-ascii?Q?4Sdn2Slp5mXIzLoZSyyaHaiau0bln2SpUjQ9YK6Nipr946x6ruG3c325UZMk?=
 =?us-ascii?Q?FBtEEAcnZue2I2ejjTTDUblo+/bn5/MtUfD74mMGv9YBpEV6pVtNO8zbFZGe?=
 =?us-ascii?Q?bRLadSAeYfAUqldLd0sbCY58CyptJ56YieeUOC4Czls2SjpHW1jf4RR0DzRH?=
 =?us-ascii?Q?7D8CoQQk6j1Wy3jfCD1EGN0XRpGTWJj1kOOqYWwFb1WZhY5Q3kYZZ6LFLyqK?=
 =?us-ascii?Q?BSD4bvpOT1Y7GTrfaEXB16vtkKZz4my857LE?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 14:07:40.2283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f23990-05aa-4bee-9619-08ddf5f3904c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461

Hi Mark,

[...]

> > > 		FIELD_MODIFY(GENMASK_U64(31, 0), &oval64, oldval);
> > > 		FIELD_MODIFY(GENMASK_U64(31, 0), &nval64, newval);
> > > 	} else {
> > > 		FIELD_MODIFY(GENMASK_U64(63, 32), &oval64, oldval);
> > > 		FIELD_MODIFY(GENMASK_U64(63, 32), &nval64, newval);
> > > 	}
> > > 	orig64 = oval64;
> > >
> > > 	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> > > 		return -EFAULT;
> > >
> > > 	if (oval64 != orig64)
> > > 		return -EAGAIN;
> > >
> > > 	*oval = oldval;
> > > 	return 0;
> > > }
> >
> > Hmm I think this wouldn'b cover the case below when big-endianess used.
> >
> > struct {
> >   u32 others 0x55667788;
> >   u32 futex = 0x11223344;
> > };
> >
> > In this case, memory layout would be:
> >
> >   55 66 77 88 11 22 33 44
> >
> > So, the value of fetched oval64 is 0x5566778811223344;
>
> Ok, so the entire struct is aligned to 8 bytes, and the 'futex' field is
> 4 bytes after that (and not itself aligned to 8 bytes). In that case:
[...]

Sorry and thanks for explation. I've misread the condition as

  if (IS_ALIGNED(uaddr, sizeof(64) && IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN)

Again. sorry for my bad eyes :\


[...]

--
Sincerely,
Yeoreum Yun
