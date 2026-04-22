Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013001.outbound.protection.outlook.com [40.107.162.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910FB21CC58
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 13:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776864816; cv=fail; b=MpuwR5iKNKVnkABpkJNrfM1CahJoLxbMw0BZhS/VkDBEBZuMpAN8FSSb6WpMdaYBPGaHaxS+M+J8xiX44paAIOS3xrJxWK+4X0XYfggCBYzj0NJxDIzMOX5D7tUXXQ8rfsEX0KK2+mogziR6EMcpDF0GhUJEZ9kPeJnJDpoTEII=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776864816; c=relaxed/simple;
	bh=k1MKcViPV18CusZwCouOSkCWvFHu/GjKcgzIQgOsydU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aEWZAs1RU0f9ekwUcuPnRUY11msNAYU544LdvWclWFNIOR4pHyn/b3tkTNmFMfnhKHTOjPtmsR210/MyD6Twy29phNUHJQ+BBTC80E35yPmSQA1KcH+ba3YGmuRSIyQPj3v22KYZmVgPchITna7PObhIyTyBfPpa1RgrzsroYPs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WerPrsCd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WerPrsCd; arc=fail smtp.client-ip=40.107.162.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WerPrsCd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WerPrsCd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=se4Fk94sCD/vEbnIi63Kz/6eIny4K7y1c6Hh4Eexd94OSKRoXAVYwzM0+4Pee5SBEQwEiVrNrx30gesNj2cBnN4ZOORX0n6YufAGcGFPa+utxPMWcnaBek5wfr2IULJJfn8vZCOblDEsSf6joRy0KpwBTpOj7XljxrfQGFAWK1Xz4SXgOwa/7bN+4Ekf1vioX0AvsE75IHbFkW6EnMO2p/t+3tTua/pxBlEckh6Yk5MVo6QVmJAaR13oVkKFakEa6fLfdeVA2zJK/iv19wAGUVXGWonq4ZCv4s/imtK3Zu/+TLRNKyEyJCg6z2+mKSL+g71/PX3HFQYGE+Y0vvi+gA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=423ZZsD1xJ8QZ4AKnWEy4rujbGY+o5+lx7RyI+I0kSQ=;
 b=LFd8byqpkZaNVzBDRiCJGO5GS8qVlbXpmGubjv0ulLqlUcfc0jM9TpDrvPzpbQEzywzRjRfhiPEF/gRvfdPvAz3s8JBpOFSC0drlCjL5K8Lzu5yy7WZZMn2XLfSq/sagusBCHmN+s5VOKSR3E/HLjs0WgaAZBThFrR1259FlE8KipCWmXykBSWJKO+65nC+7jP2MEcKEMlXXLDTIMgAEjM6RuiQvHPv6qw5esvm8BTNAHduOUFiKcfJP+AKaRE0pYkgXADg8NcyyO8anFBq9P0HD4OYcmqQbEoenWOC/Z770DkJfiIhTzyvdxByULL7GsIFfI733vdHDDeG2bccinA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=423ZZsD1xJ8QZ4AKnWEy4rujbGY+o5+lx7RyI+I0kSQ=;
 b=WerPrsCdvTIWc3jhdTWQc7Tc/3vDVahUi3bkIAFlA67h49FW6trQEhg2tqDKezOLKYan3Lf1LnUFP2iSaU24LFopV94uq0261USzP5mQOrm8jVHXOec/7jdytcZ77esiPGMOlV9L1w+fMi2zX+DubECytuKpvWdpJWCVgv65FyM=
Received: from DUZPR01CA0252.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::22) by AM0PR08MB5410.eurprd08.prod.outlook.com
 (2603:10a6:208:182::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 13:33:30 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:4b5:cafe::e5) by DUZPR01CA0252.outlook.office365.com
 (2603:10a6:10:4b5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 13:33:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Wed, 22 Apr 2026 13:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hIU52+lPZPq983ZoWa5F3NyaqTwE38NYEIdPdtXPxLuEJKEMmzROtwwDPH36ZvdvxT8VWC4fgYUX0MMmtUd0n2I5toZ+vTAPLzYvEmSkgRixn+IrLHkUqmp+243Pb1Xq08CpzX9zZbkBtxy5KNyR77erxB0fZ6K0arjTox0LtvJDcib7epfnT99ugQ6uaY+K4YghST8GYkYU+76cVfxw48j4JgFCbY4xzn7nfjwMgBmUvSYyC6v1RTd2+4CWgdexl1d8NItN4TXP8vFIHuGyDuwx27358vltlfqfol/OoK+brcdfHjJClT2AUhDkeYI85KnEMdpEHR5l2cO3H4wf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=423ZZsD1xJ8QZ4AKnWEy4rujbGY+o5+lx7RyI+I0kSQ=;
 b=EDJq2TTBg2V/WqnYK3a95m+aNYeMbieJmhBc6Ja1zhViG4duorFrCJwvWmAbCIO1eiJPGvlbd/179Es+uOkS0URgnaHBsNnbYrdiNtZ3rLNsoYVTAppK9YIDRZZ859BT1wiXfzJFqydwGdERueqWITGGXvtYfMaB12Nk1QtDgYq/lGwmVkyN9hp6ucptGJXaP3aS1nBHGD2cgNo23UrLcTgU0TQV3Q2GKxfC3ca/TrmXhhMKYfQNm+COtlZp1lWyQIIMnyd2HUI5loEFkEcWyz3jWu4n2DG5ZnuxP8U7juoiph/grpq/i506+gJQzqkdVMu2XN2Mvyl5JyaI5ZxXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=423ZZsD1xJ8QZ4AKnWEy4rujbGY+o5+lx7RyI+I0kSQ=;
 b=WerPrsCdvTIWc3jhdTWQc7Tc/3vDVahUi3bkIAFlA67h49FW6trQEhg2tqDKezOLKYan3Lf1LnUFP2iSaU24LFopV94uq0261USzP5mQOrm8jVHXOec/7jdytcZ77esiPGMOlV9L1w+fMi2zX+DubECytuKpvWdpJWCVgv65FyM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB6406.eurprd08.prod.outlook.com
 (2603:10a6:20b:33c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 22 Apr
 2026 13:32:27 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 13:32:26 +0000
Date: Wed, 22 Apr 2026 14:32:23 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, zohar@linux.ibm.com,
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, jarkko@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, sebastianene@google.com
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aejN52lwaqfoMuGJ@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aecf57rWloQwDh6v@e129823.arm.com>
 <20260421-married-liberal-ammonite-dffda8@sudeepholla>
 <aec/YSxYO1bOhXhn@e129823.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec/YSxYO1bOhXhn@e129823.arm.com>
X-ClientProxiedBy: LO3P265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB6406:EE_|DU2PEPF00028D07:EE_|AM0PR08MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e8c89a-cc4b-4a84-af1a-08dea073bdf7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 eYcDPQRFV3rEABx2Q4QcqcQ/olJw6+Pf9FP5mrcCIqMfrJMx+Zcm7VwDdRt8oG2xCqX8/wuqssYdzGi/hbtb5T/zZapR4YNlY+yb920aSFt1Bu74RfTfW7U6Uoxb1fk9sD8Rwc4JsXrxRfxf1ROj/sSfZ4PNqseX4/KAde2hdySFIeMio/1gmklfr59v2tUmYbkrKAJk73t4R1XE5w5GxvEmVmneqfCO+5xwWb/G5A+uExOoNT/VsfYiIXp+SQreUF7IoygdERTm7QO9w0+EuRlvynoUXE4zpz8cQ/BoQUfH5TQ132g7mgwRxItmrinMN9HL0GM93tIcoJrV0BGCqlxvQlDJEd0Y/rn0xmh63iIdl4FqR47X12vb4SM2m3x2wBlgOODFIXjZjnCRYJewpZ6979W0yzm4mNwgYjQDQ8f15OZ+Y5kNG17cx3+olih1Ce0lWahhl54fXS/Txca6bnFKB/j+yyx76wO0ov30doXyl4P3aPKzA9J7q1MuFx/ZVWtQHKUV2fbltXeJX1FCeqcuLPf2gwfMcPSzJAO80iBoWcKN+qlE1O09atQfctAAH2ZVKM41fScyv/creiQl/l03wr6CrNGeNHahmaOduICHlXYB292UxxgaFI2Q3lBAhY4m0NeNA1n2wejWu/2h0siiKnfBsDhi/1GB9BcljKTYyKNp5FUPdier4wrCU+JY2jEEq2uWGNxjiWThp9Pze2uA3DP6lHjiUyCAQ94eCOY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 jULWDky+lPAOZOW90f3PB3TZhRiJztr4Da6z1hpLWtmg/MyI9Pwh1gbrUoBGZwgmPR/B9f2ZdOVuttB4ARGCgi+orcy+2tE/tBwgro54u3ZxstpNtvFJy92atGZcxLmhyvzIjcd9DUX0bMSgTRIZ8seY7nxgXh1+5t/Wslt5D6XcoOlx/ixUsyN6WONwy+kM31yFxc8rHtbpbW0MYN6TKEKzfMkLep8bd58NZ7UT2QD43sZXzGXWNYfvx0P984DseTefBYVOo2nivFJ1kj3cBr+nYO7960dGNNuPkoOAcTQ/Zz9kpmzPrhLwQzuvv7AJEmkbkLtpvTsMHxog7zw27Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6406
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5382aaeb-d792-46b8-efb2-08dea07397e3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|14060799003|376014|7416014|36860700016|13003099007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	MW/ff6/QQpvftKOPyrx+n0hAcJGfObte0amtFqLnpCgRVJu2NpsJNgsL0lATlZs59uoE+Fcz6kSzlzKfd9Lq8FOuu59BVmaO37z1uR8ZTjTjgw+E9UweMeihYqlzxhEP7CDipgmGgETBkAq0ZHqMHoKHu/dH2VVHwbmwRCeRB99Rl5pTfvLjBy6Hic0sKPtDi21WWlwh+/g/CZ+oLOwEGq4vdce+wJKmwPj60kn8Pwdi7/sBC2jDuavA9FPj0J7mUJWJj7PF+jS18wVLZsqCXhMB09ywgzI5naTZQNR5Ih02MY+5lmKkoePfx/b8x8TSATQZgnG5bnGT/0B1rR0cmBncF4pESJliuWGoUzH3FMSN17pI2XXTDwtDDAzpn3+qisQaeDi9IYFJZfr9j6UIf3NtB2z7qdEWlfkeKq0OsefMxZOiWcNSO1z87kGvJXg075rs6pmw2ZybcgCuknaUje8xZitBy6tqHODzlrlVbpoilvFF+BxWlelBq2xqGT5knvAFcjz3jn9V07gMIsQZHKiYGcaGTYR9GcJkZhbnzvtWJN0Kro9m+2wVcZJmvH7/YJXL6upcLn/bInRN/T+fnS9gaN0KM3mYZdS9DjDJDoITm8PawkWm/ZmZAnxyUPR04m3WUsLM0Jj2D3dpwhr4BuNzWyru/izVDOHdZIkOLhRhodAP0BLdWQH/BJ3ZqlUDUJetX5pK/RqtyBr3ySPN6BfF93/0ptUATafrmu81U22wWzhqPHsdI1VHY7nW+TIISB9b7HIMPWIEzCYtNdg5qQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(14060799003)(376014)(7416014)(36860700016)(13003099007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vWvPJIt6ScJUqknLxSQy7R4E4NdWVSRtoTgxj2j3Sy15Bw3kY/rC+dzrKiSFG/b6tgcLcUa8jmgx1DV887lCcqea7I8oahMyxR6eOiQOVjeKXytyLztPFuEFd2vU5GMDyJM147TZcn+1PThX5fS7Wn1LZ7m1hMm25amiIZf9gaLLveXOWu6CXzCGWTJGHwyYkB1zuO2ExgdRb5M8U/zM7lbcBOVTQtWJI7l4jV0H6+SWpiby2oKBTXTURO200BhsJozFOyr1oPCw9RWi/HHV5F/xeyYyueZbYQQ72FUtpq71IRybjfnOGQBqqrGRnSLt2ky0A1L9XKyVpoSoVLQHm6uCMVVrKEWVQu2J1yGXPH04ms1osgHJdr4pftRNxUHEljmpUaf+sY0sMNvrwviR8P2HVC5rOHB3hSR/hRYGLPYiRXWorPduKxfmT9JEQSSq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 13:33:30.0488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e8c89a-cc4b-4a84-af1a-08dea073bdf7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5410

Hi All,

> > On Tue, Apr 21, 2026 at 07:57:43AM +0100, Yeoreum Yun wrote:
> >
> > [...]
> >
> > >
> > > Also, the FF-A initialization is not driven by a device probe, but rather
> > > happens as part of the bus registration itself,
> > > so it does not fit well with a device_link or probe deferral based approach.
> > >
> > > Instead, perhaps we could go with the idea I mentioned previously:
> > > either introduce a notifier, or create a pseudo ffa_device
> > > once pKVM initialization has completed, and
> > > then let the ffa driver perform the additional initialization from there.
> > >
> > > Am I missing something?
> > >
> >
> > In order to handle/cleanup some ugliness in interrupt management in the
> > FF-A driver, we may introduce DT node eventually. But it will take sometime.
>
> Unfortunately, I think this DT node wouldn't be helpful to solve
> this situation for dependency with the kvm misc device...
>
> IMHO, current situation, the notifier seems to good option. unless
> we make the initcall to recongise this dependency.
>

I think the best approach for now is to introduce a notifier to handle this situation.
If there are no further suggestions, I’ll send a v2 based on:
  - https://lore.kernel.org/all/aeS4rAeVQ0yJIPYw@e129823.arm.com/

Thanks!

--
Sincerely,
Yeoreum Yun
