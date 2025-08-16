Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011057.outbound.protection.outlook.com [52.101.70.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAC0A926
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755357457; cv=fail; b=qGvACh0AmBNrTDPr7JIOZSrgws0EJoXFfSnZSA5s56REtjdP7V9m/vqJLFBRxIO4roQ25YTAzqimk9DKxR7rtyvUGL2vL2p4BGRJRtdWeN4nAlctFJmG0etuDtGT8tXsRVgepwPTHatfyOOshDG719NX02bnxVzW9HffYfL/QZs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755357457; c=relaxed/simple;
	bh=T3tui1vGSTQ+b1WNIiHA2uYLeUP0hFKnAWssUR8u8NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vAls0wns3fvxq+FGmjpU7/yPCmyd+eOK1VEd/hVjxolTxINJumkk6vMLHkt/0TlRnVggMo1EGLXOzVaWFAPsLGz6ZcQpXk57KFvffF2W6uODY0lFb5wSG+A4SlZ6Ma+hRjnhLt0ByGnAdcCtVd0YNsr8CjuNmPt2snZ6B9lT4Pk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SmX6u2+r; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SmX6u2+r; arc=fail smtp.client-ip=52.101.70.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SmX6u2+r";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SmX6u2+r"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DYrxU62/zGg66CuVtlUnasfbgEqjICeorCg1DtXjOPd/xd8syvpuT+FpfQWpSoqLrwJhUR+e6boNLZCB51ZNSLoNULYcnOBHyJKqF0I5kbxPz2DfnVtORYXw53ZHNt7a8TFhoUBFRMqJ+1b9jN4hX2KHGSiBEXULpuZwIqSTO+tHseFiN/tzu3is1s5muZLzhsvVsbzX3R7HmaK42tsXQa1xvWty9eNDwm33Y3jFXr0CAwF73J26H2SZoj1n+/uX2fCnd4j2ioNi9BlFpJA3IkkH+X5V0/HryQsENYKUgnwHb3A+RwJgC2KdPGe30mDVELWW00pqIXm4wTqcKqlccA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tfs/wYxqtFDfN2Pxv4UtWgjVivti4atR1WWt7Ke26VQ=;
 b=KgnAtleqR14T3UFD8397BL+PD7SzNVlQCCqNUw8DjJ/IfCmNSwAFipCJ2GuaTTx6oCCZK53iNtJNdsyCSg7Et8QnP3b2xK18uaDJmOlhgoeRoOCkqXGz+iF08eNkEHqpXkQij5zZYQMRdXmdqX3NCajo1YpZfM5DFYXisWuTTZinx+xjaJtKiR1DCVJs2WNkRC+wTulX86whiIs1iTXJKhGc4Aw0f/nSeeh9wFZzMWu+oz1/pp6TEEt6cc0v+jex7BN4UOXIlDFPuvfB9962rnmAaiOncA1yR8gWYpL0ioErAgoHerLYDtusnou/36TK6yHG7q7otQiZFM3OkvewGQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tfs/wYxqtFDfN2Pxv4UtWgjVivti4atR1WWt7Ke26VQ=;
 b=SmX6u2+rdyAFGTu6mhjqL3TY01ujGpN5i0KJ+GhALMee4kEzFyoQnm6ejqgZQ/qkFdJNrN6WlqLHijDCiFBT1GGIUchmtWWfoj7HsQNIrOhzmyMlOP3DSwO784O+4vzKJZ5+CKMVKz/3G8T+DJgz26034QS/SNIvyzSIMkfiWXk=
Received: from DB7PR03CA0084.eurprd03.prod.outlook.com (2603:10a6:10:72::25)
 by AS8PR08MB9815.eurprd08.prod.outlook.com (2603:10a6:20b:614::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Sat, 16 Aug
 2025 15:17:30 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:72:cafe::51) by DB7PR03CA0084.outlook.office365.com
 (2603:10a6:10:72::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sat,
 16 Aug 2025 15:17:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Sat, 16 Aug 2025 15:17:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/4qN/xhA9YKtTEq7V5vE8HysCWbnhEiDI//ncloqTKWgqAdmUXAXea05zQD1URTIgBSZvBcb+MlZq5+d6N4BMfJjuCZg1gPa5BGbCft/BPaGADxAJHdvhogxpS/+Le0Lae9tbv+boDN5HYS7vJg4jZ9NpC39nttOjsbyB+hEc/XgbsIIj3VaVccgQN12azQieqj7tM1AF6L4+D3nGJntE+SSa0A8TZ411pNN0COh2tayS4igTdW9rQUxwtnlsfFkPiALwnH/lrAZlKgDNKnMzW6lGCYDGaGqlAGbyaS1By1xkUs7/imGUtW7ef07CYOFZ1369jsORBo4awth4pMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tfs/wYxqtFDfN2Pxv4UtWgjVivti4atR1WWt7Ke26VQ=;
 b=ncxl/Z3idKLGRRLCYPrcA43egDLYKrkhIA2aIEDq8cuFiMJ6gGzkrWp4sKfg8brU3Dtx2P3gw0mEdvqyfMK9FScOwtki6pq0FkB9DeezaXztG0ggffxNQO96XV5MlDoZHgnhzGARihf8tijUtk0X9YPU/6oI7rM5voq2RyvW0EBBNgQ/FgAdep7fhYxnpiAqPuEmoYZtg4HfdwRwlVMgv53nJPL3h8wJNHZFyRVWB7AmvrJnb6JHO+YrZv9siL1oFeKcdNTD2mBZuEE6y10T9EEqdrR3Ju5E5mIw9+8erpWqrU2IPIcMMDEMB+pwa2rkf33gypYcokzVImpH7oFKBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tfs/wYxqtFDfN2Pxv4UtWgjVivti4atR1WWt7Ke26VQ=;
 b=SmX6u2+rdyAFGTu6mhjqL3TY01ujGpN5i0KJ+GhALMee4kEzFyoQnm6ejqgZQ/qkFdJNrN6WlqLHijDCiFBT1GGIUchmtWWfoj7HsQNIrOhzmyMlOP3DSwO784O+4vzKJZ5+CKMVKz/3G8T+DJgz26034QS/SNIvyzSIMkfiWXk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB6471.eurprd08.prod.outlook.com
 (2603:10a6:20b:338::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Sat, 16 Aug
 2025 15:16:55 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.019; Sat, 16 Aug 2025
 15:16:55 +0000
Date: Sat, 16 Aug 2025 16:16:52 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/6] support FEAT_LSUI and apply it on futex atomic ops
Message-ID: <aKCg5NGTaX/lrfS9@e129823.arm.com>
References: <20250816151326.195587-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151326.195587-1-yeoreum.yun@arm.com>
X-ClientProxiedBy: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB6471:EE_|DU2PEPF00028D06:EE_|AS8PR08MB9815:EE_
X-MS-Office365-Filtering-Correlation-Id: ce74847c-b1df-4912-4743-08dddcd803f6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?Am0MuZLXCU8mbX5A7FPfo725fuqvmqoVBimkHPKfYV1rUAx4cmtfG+NGVMt0?=
 =?us-ascii?Q?RgNnDgDgqSHC8DettSADHR656qcfCig4XWVe3i7SUSuzYcRnLq4vqiLDDhjj?=
 =?us-ascii?Q?LnnzF45a6lpfRT+IPEVlEhGI9cSEsYxORWFqOvCUWg0TO1RTyBsrjJ/7Ftk4?=
 =?us-ascii?Q?X0BKzmTpngSu/uXICGenipl5qLCzJXZzK2sjE4B1uDvB0raVBhnS8PSEGE+R?=
 =?us-ascii?Q?4opQ91ElgVR9++4QMpF84/EeV15G5Z27mIpgl4XLKu5EDdYICnGiXSos5JoU?=
 =?us-ascii?Q?zO4fa/81aLs8Dfov66QfkpL/R3TmMoNiqNJSMNOJ7FV1btdU1Pv8ONkVPQzo?=
 =?us-ascii?Q?qHEqsApfDJAkageaTVYi4qYdwUryaNpxxz9MAG9MEVUDMAYCHmxsKFHDGd8+?=
 =?us-ascii?Q?r5brEjaG/mbmfWfvBwXJa/VmWrp8xYh/y33UBiE8RZHh0ah58dP3NpEpUNRn?=
 =?us-ascii?Q?hkznZdxaIU+HWCcPkz5ywvajHxlJDB0vI4WkL28BLX6JSggRNvbsxJXb4suQ?=
 =?us-ascii?Q?fYyGKkB5wsX+sttXseqgoHzPw/MHhBBza0w+9DgNTbvT6lee2OzfxSFMnaZd?=
 =?us-ascii?Q?HEssxDu3yLThwwxKO+k3A6Q/3BbEIpwsz2KEZ0ls1JLG2lo/cCVrEEtuiIVC?=
 =?us-ascii?Q?T34l4+bcp/xhSP5MTQK2n2ZzTtshxwc4Ywk5DdUly7gljAQimb8Hq1N7QwGC?=
 =?us-ascii?Q?+5vj5SkCnxBp4gkZtXBYHUI7gO9x1Kle+RS1V2PYS02w0EHo1d5PP1KcxQZ2?=
 =?us-ascii?Q?eW9udRtxOBl5sYTuIBlVtF1U0s/n0XN/C6vvcEq2tD+NyoGaYft7sUDpif/R?=
 =?us-ascii?Q?oHcGNV2NVP+pn9QxkCZQNqIWVUuZadN9+WdlQAFw6UF2hJTSzGuWNbkTsbnq?=
 =?us-ascii?Q?4YmYOcAPi5IQQPbxRCNWvaoh/mKmA3x0Nw+xbmXcBy5eiL+kU8gLS2kP4szP?=
 =?us-ascii?Q?IYYvrmrZb7Z0X+Y1STZLgx5rP7xOVGa6aFBMrVpnWk86k5s/+al0LRBBE36G?=
 =?us-ascii?Q?XxYh9CU2QTwkBxjz6772DqJ0LITnrCGOUSxcoZajSzlZnG5tItBdGiOeC4ZQ?=
 =?us-ascii?Q?jj41KSPkkYO4RYft4aATiGI4jfYOu0lgsHekW9t8dtlUyABtZ3jkelD9XLsY?=
 =?us-ascii?Q?8RPWImleHW0b+hAnoo4RC0vwgGz/WUuKZTFw8+P1wZxN5E2aNNkQuZqxgNym?=
 =?us-ascii?Q?ypGGVHwy7arbwz8t8uBFU7GSYEHsaWifsBYUIkg+vHQcipd9mQnFs7GJyNDJ?=
 =?us-ascii?Q?e6vSOLfFI1gptJH7YJIGG/O0NB7p4IrcS5lBHu8/K3x4lmyFXXBk5eRdd7oB?=
 =?us-ascii?Q?Zzqw5MOqhTmH/cVEUdlegPG9SC5SlGjnEyOPVUsbh6T8bwGCFbGbE8iCunRN?=
 =?us-ascii?Q?Bc914lDH2AWSTDVurSL9R9IT+jOgXLRE7ADbKSNwtEGZ4yURo6WNpdPFnvD4?=
 =?us-ascii?Q?Kt5NTSQwEJP6PQCI5XnTcyuZ8skBk1lvaGQfFB4ziQyGa3tAI0TIxQ=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6471
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	17c9b371-4add-41f7-6ed1-08dddcd7efb1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|1800799024|36860700013|35042699022|82310400026|7416014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1pWNT/nkuZp5gBB4SjfpZeZXveYONDp1x1BM922YKOaLJojgzO3pJr5RXPy?=
 =?us-ascii?Q?+tD1oj57TOOwubiTw+bysnvP7lbvLSfa2fD1/Da0vlOhpJ5oj1O919cJekFX?=
 =?us-ascii?Q?zL8/zrlUzULlzg1o4mziWjnGe2tR6AuIwlVao5Jz7wlhtInw+M3UXKQ7LuCV?=
 =?us-ascii?Q?fA+tiyY7++dXHCsuOUyvaG3hf5PpXMRe29Jyi0yi0A4KzM+y0Tt3Dty/WGqM?=
 =?us-ascii?Q?6scok3BjPXw4Sc9jbHx0yde0cTTclGnEmQgWrfP3Yz5Ecw65c1t/PJv8R4kw?=
 =?us-ascii?Q?rFU3TfSl1C5xo7QjBFF9TkaPnIiVp8eoq5GxH3yxrSsr3YdNYuFb4a/F7wTu?=
 =?us-ascii?Q?y6BYOeg6pRqWgefIHqTHGBKSxZLRYTV/4jrrWWvQ75Z6uUWeJgpxMkXLXSd2?=
 =?us-ascii?Q?dfN6U+3wc8d0JSnbTnmVjfZWPEJT9GwK3/jQIVXiSFfbyrFbIz0w3rjVdJXR?=
 =?us-ascii?Q?nBHcwyhcXF4xc8PFy70/oIGU2gFf6zj4mxuaDklNZInKNg3iozHao3U16h04?=
 =?us-ascii?Q?b3+CnekQgFYspVaWdDUVVBtmKzAY8FmyTvlNk/m4TD/kkj/NI/5R6J7cYMqq?=
 =?us-ascii?Q?DsoCzQ9bN6RSnxuaiwd5YRkj9XIAp8NIHDKQiFY6Gy/0tSykqmHI4OScnQHy?=
 =?us-ascii?Q?bVD8K44WLrc9UB0FA6yURUZAIATSze8vJNtWziCQSWuA2MzIroJgm9FPAg/o?=
 =?us-ascii?Q?2cTYnXB3fdJ5c992YSZLsN4/8oo1yP6w1OpMn3f4kkicyEJlT+5czLyFmJwx?=
 =?us-ascii?Q?N5EfpE00pnz/d+OrLN9zq33XIp6J3cuQlvzuuWgyqFC0UqCN4xopUeaWoubW?=
 =?us-ascii?Q?c1bYaQe5vzyIIGPAsUDBzOqv2awb9Fu/y/so9+fg4yyimxUSoNmbIH6g1zDy?=
 =?us-ascii?Q?dEw3vx3AEckIQHI2Zl2hd8IIibajK0ag1D6jXtU/nfudiot3kJdmogGLB1bC?=
 =?us-ascii?Q?MmqDUgjR06HZy3u2+zD39W7WbZUm4HozJQT6uRtYf7V7mahPWIOeCYA5y9eK?=
 =?us-ascii?Q?VUvbeN1S1UKS8gHyJWq/Eb3yC80xxdo51E20PZSfb0AX027jOwr2zoowm9YF?=
 =?us-ascii?Q?+/kA4auR1DOUkiDpGyYU/mzo6kgPItr+fOSdoFIH0EqyNof8+HNF9y0QI8t+?=
 =?us-ascii?Q?x171r4HhOfPLgKHueF0ESDXwQYFogLmDAaKpv9roSva6bhpOhj/Fdxmn1kbb?=
 =?us-ascii?Q?iH4tde1JyrfD7L5LAhQBYOT10M9W6n1ovivhxO++KW3PccbafvHDaVzuDfU2?=
 =?us-ascii?Q?tDTx6ucPhMtXZmIPwb4Pw6wU/fJGdxUMzzoX1d5WCYKUd2a0PZHIHcLgFZ94?=
 =?us-ascii?Q?QdQ7eqbG4USdUGHsFPxVBlqFnVGcnF1s4i+i14fGXaX4rnJw7iJOc+nC3eIn?=
 =?us-ascii?Q?vrBwFQj4Un/8u/zrDEU6XjXkN2iYTVkE11ltwm6s1+AEiX7+dGoaBfMFqCiJ?=
 =?us-ascii?Q?ds354B2xyYhBPZhkuRZdQ2xNYbUwnLyghBsLmDtXP1ei+k4nRfFM5ocK9AnC?=
 =?us-ascii?Q?5/1GlIyLf8JLmxeVbSrjkv+/7lNfHc2pG0dbbVf/l5jLD79AND0JQOdA0Wo3?=
 =?us-ascii?Q?wH9El6ZRZt/hsippQuk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(1800799024)(36860700013)(35042699022)(82310400026)(7416014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 15:17:29.2976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce74847c-b1df-4912-4743-08dddcd803f6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9815

Sorry for everyone.
I've sent wrongly.... I'll resend it again properly.

Sorry again for mail-boom..

> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
>
> This patchset support FEAT_LSUI and applies in futex atomic operation
> where can replace from ldxr/stlxr pair implmentation with clearing
> PSTATE.PAN bit to correspondant load/store unprevileged atomic operation
> without clearing PSTATE.PAN bit.
>
> Patch Sequences
> ================
>
> Patch #1 adds cpufeature for FEAT_LSUI
>
> Patch #2 expose FEAT_LSUI to guest
>
> Patch #3 adds Kconfig for FEAT_LSUI
>
> Patch #4 refactor former futex atomic-op implmentation with ll/sc &
>          clearing PSTATE.PAN
>
> Patch #5 applies small optimisation for __llc_futex_atomic_set().
>
> Patch #6 support futext atomic-op with FEAT_LSUI
>
> Patch History
> ==============
> from v6 to v7:
>   - wrap FEAT_LSUI with CONFIG_AS_HAS_LSUI in cpufeature
>   - remove unnecessary addition of indentation.
>   - remove unnecessary mte_tco_enable()/disable() on LSUI operation.
>   - https://lore.kernel.org/all/20250811163635.1562145-1-yeoreum.yun@arm.com/
>
> from v5 to v6:
>   - rebase to v6.17-rc1
>   - https://lore.kernel.org/all/20250722121956.1509403-1-yeoreum.yun@arm.com/
>
> from v4 to v5:
>   - remove futex_ll_sc.h futext_lsui and lsui.h and move them to futex.h
>   - reorganize the patches.
>   - https://lore.kernel.org/all/20250721083618.2743569-1-yeoreum.yun@arm.com/
>
> from v3 to v4:
>   - rebase to v6.16-rc7
>   - modify some patch's title.
>   - https://lore.kernel.org/all/20250617183635.1266015-1-yeoreum.yun@arm.com/
>
> from v2 to v3:
>   - expose FEAT_LUSI to guest
>   - add help section for LUSI Kconfig
>   - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/
>
> from v1 to v2:
>   - remove empty v9.6 menu entry
>   - locate HAS_LUSI in cpucaps in order
>   - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/
>
>
> Yeoreum Yun (6):
>   arm64: cpufeature: add FEAT_LSUI
>   KVM: arm64: expose FEAT_LSUI to guest
>   arm64: Kconfig: add LSUI Kconfig
>   arm64: futex: refactor futex atomic operation
>   arm64: futex: small optimisation for __llsc_futex_atomic_set()
>   arm64: futex: support futex with FEAT_LSUI
>
>  arch/arm64/Kconfig             |   5 +
>  arch/arm64/include/asm/futex.h | 291 +++++++++++++++++++++++++++------
>  arch/arm64/kernel/cpufeature.c |  10 ++
>  arch/arm64/kvm/sys_regs.c      |   5 +-
>  arch/arm64/tools/cpucaps       |   1 +
>  5 files changed, 261 insertions(+), 51 deletions(-)
>
>
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Sincerely,
Yeoreum Yun
