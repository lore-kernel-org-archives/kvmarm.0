Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011039.outbound.protection.outlook.com [52.101.65.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC9D1A9B58;
	Fri, 31 Jul 2026 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503974; cv=fail; b=FtpvpbUJea4fdOOFPpuLF+tvd2YUpoGa/0aqOQM4dl43logHzysYiR6PsIYGcvnR9oeSUKQkAoQlMM+779o2vDFdbrq7vbVvqf3Uc52GsyXOdEmNu5qKwTqXtkvIPtDxhvMRWh9Ww/vcM+mnb54milVH6ta/zzk9w7xi63ix6Do=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503974; c=relaxed/simple;
	bh=jw/zRdIeGJ8QLRXJAAaX0ah0WqPRKQMCP+VNuzXFWZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KRmVsCfF59R3jKJEiDSfaAkwBVDDbKyJ4bQBnoGS+33+8x/KSfj1njShOoQMvSg8XTadFJlBkPLTMHrjmrmBZMZjdHzFA81cS47FmNkPWOvAGnbtTxWTSRL2qvDaJdFp1rNpe2rPw5VKNesvCeE5vNL/a/XpC8CG/zT6d6I979I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i17M2VnF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i17M2VnF; arc=fail smtp.client-ip=52.101.65.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i17M2VnF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i17M2VnF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WR3HwjpZjt4sl+k8W/ax4sH+L32q5ePb8ZFNfEtY15UggBc/AwlQJQchyd9b4iYMSEwmg1zfr7nW5++JdhupgaqF3DP3ddLJbwmiPOV2XRQxHInXSL07WHa9dHcWrFBHoAErjRNoYAIOEDJ2nfAaJeIruZOgwZ+h936WwQb8lwRPXRDkwHoTnA+NMZ1iZRRxT+sT1Z7GypnCjgaVczvflMvuZroerDp0/vWRaCRrxW6qnAiieQEJFRWlYk3nq56vhXxwEYHJ+GnVmXu5bUaejuXOiNq8gt6xdcEnCZIcgHQ12MCcP6uUghZeGRjTqp0UNrKRf57R79lSPHTkW5mgag==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw/zRdIeGJ8QLRXJAAaX0ah0WqPRKQMCP+VNuzXFWZY=;
 b=oneZuUYcpSKCLuoz5EurghDo2wum0zLKjGbxNOUbFZcnU9gHPnH7w14VF7nd2zV1DTjrPyHju+tHFkQBNHtn4dqgWiAVN7GIMQZFqOtaXOPRclNNlajCX6qNUVkrJ1m9KkSTz6EPBQ+MuhUFod7YWj3RExCWoymKMFN+iOS/dQiwrV0Yzz9go9V9KWnXkZ8e/PYBbtuKdGbsa2Zl6DbZln5Ncu8HJcpB4JKW4Brhkfmw3kWdqllV1mvTwpaLb5E4FblPKWZJQIoeh5pUfYjQwFxrnNiWkIuULux2uBNyD/RVU0EdxL6IKXIY47o0ycoHzG4Vo43TuAJJxc0VAP/apQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw/zRdIeGJ8QLRXJAAaX0ah0WqPRKQMCP+VNuzXFWZY=;
 b=i17M2VnFJ5xfZCYm1D60L1L5y7EMHveJTJYJNe/sgj2Fc1/t8lQHU0HhKSUOruOa16GF5ajK6PjDklDXydAjgI9GPo6Ya1cdLuCK2XFw+eDUXEmv+Os335rqY2c8gb5k4SgmDQ/d5bdw96BhFZEglp+pE/TQJSxpgOD3+VpTIK8=
Received: from DUZPR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::23) by DU0PR08MB9052.eurprd08.prod.outlook.com
 (2603:10a6:10:474::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 13:19:24 +0000
Received: from DU6PEPF0000B620.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::4e) by DUZPR01CA0117.outlook.office365.com
 (2603:10a6:10:4bc::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 13:19:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B620.mail.protection.outlook.com (10.167.8.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 13:19:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WtczmSd0yUJCE+18d8dd6bRKBAtkEoB0WeGOcxpdpA6VavQEojSIB6vwlLEsXhiFQatguzSjrtr0F+5z2tPclqcvAu0rY9OoGJm0bhx+y/K7Z7WAEJwwWtRd4onHeLpybpQ51wUWPFjSNB/gmFmcM2txkZpR1G+HECiUKZaNxzoHUWFUXXZC6hkh0UngQ9qNalLmdoC5TR10TaLCUb/GWWiiWqH+kIKzqItRdTOYaAuQTswdsYKReIm4unBaKMIAPg3HiZbgY7ROVsxCC+4keRjS8m+AGK2lJQrTOu2m7N/9g6l5iupjQBhZE/9XYWANrwrOgHTOdQzk3COK+7g+zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw/zRdIeGJ8QLRXJAAaX0ah0WqPRKQMCP+VNuzXFWZY=;
 b=fk57BMau3Iv08yDpxWue9iCYHgTqttPenjuog8bFi+NrwnGOc1OIq/WBOtfY8ilz/u+v7z8XOO+5KUPhKibpytlzOgcldsHLrtXtg96QcoGxDzk4PK4Tb5XF6nOkDg9LoMfC8e9VVp8RU6oRr1Jj/sPClMnxzcj152jTH9dYwTxWtgZYX75USbz1AuhVH6RGoQ05foYCMOkGgtdFqGJEzYqZ9nSZS0d2ytJBA6ZKmBgk4smIC0DDFOn5E8msIHvgwmHg5SVTKrl2cDV6xjW9enPz7e6dAkIAGfPv8IqPz90dbDkj75GymNib0ZRg9Cmlu06sOCf6EVCzBmw2zt+JKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw/zRdIeGJ8QLRXJAAaX0ah0WqPRKQMCP+VNuzXFWZY=;
 b=i17M2VnFJ5xfZCYm1D60L1L5y7EMHveJTJYJNe/sgj2Fc1/t8lQHU0HhKSUOruOa16GF5ajK6PjDklDXydAjgI9GPo6Ya1cdLuCK2XFw+eDUXEmv+Os335rqY2c8gb5k4SgmDQ/d5bdw96BhFZEglp+pE/TQJSxpgOD3+VpTIK8=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10400.eurprd08.prod.outlook.com (2603:10a6:10:521::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:18:21 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:18:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Topic: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Index: AQHdG1rZRY3AS5YnW0yTpN5a5H3V1bZ8ijSAgAsdMgA=
Date: Fri, 31 Jul 2026 13:18:20 +0000
Message-ID: <24d826456263b71664093595ba7cad0a82a3262f.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-26-sascha.bischoff@arm.com>
	 <20260724113500.A5DD31F00A3A@smtp.kernel.org>
In-Reply-To: <20260724113500.A5DD31F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10400:EE_|DU6PEPF0000B620:EE_|DU0PR08MB9052:EE_
X-MS-Office365-Filtering-Correlation-Id: dfa59a95-c9b0-4bd4-0684-08deef0656f3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|3023799007|56012099006|5023799004|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 vHfJVWb1MMRQoHoPL0RVFHF8rhjhqVPEjJJK4CDcBmRF4xqYgCqyAZ/ss3oDlcImwpL7suAPGLmjvntlDGbEhZxO7qJ0c4FDdRYAL9B+cH/2DqTMW1JFQkmarYaHE3O9iPVLBNNj/rR8qn4XoEuS74tQWZisL7BZX9EhT/SmDHh10EdHhmdN047pykzdgg956y7eZNWoz//lhedNOwzUVpY7rHDUwhIYmwxkCLG0Oy32XrOtPqjiNd1pPAYddKKGftGW+xR96YysmVpbpIMlhauiim787XlBLqtSk67BcTFhwaR/srFq4RabsZjz4s5hcRW/gUgqq8LToP5Hs602W/4nOG2/d0dMBFnf0YGufOeE3trEiVvE22ogb3rbiQz6sd8PwZGtI5GHiBxjY7cN7CFN3JGhcca+sMGvPZRIJXZeUqTeNmXgbDk7nbOvCMKC/S2oH6whnxoVTNQaxUCFvuoMnwsHQ0z+A2gLh/sL5ZzZPHRbCqSVTHFIQdQOuoO0Zdq/UFZF3ioC6FxOXjo27jxnwxF/APojKlCo1+1Nz8FVxfDrtkJgWjKgkC5TLB0zkAcKY3n1/Oj/NSaLX3biNRi3RvZXXLFUmfTFjp6/fEk4PoD6OG91O+6jXkCZZLchmQRBwiUEr7ckCG2F09wMKxL3pRFV3+JagIcwfEc4xG1iUHcXLftW8pb9QaamrrNWoq+InWBvkX3aWtKTS4ASCCu7niR5495F0Gq2hyjFeJU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(3023799007)(56012099006)(5023799004)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <73DB12FA864DC748805B5759E55E4FBD@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YnZGjEx9F9d2X91mvH3QeDavP8dpS+Nk0Mo1Xigsm9PhTmfBvZDr6RBDD3BrV3QENJOGtZX9azUYsHhPmIOU67pTz++gFBE1yGNnJGLWLKQ73koTxxmgB+KLBd0aUuL66j2CWX9sUbsp6QD+E7QxlgoWHUuSK6R/3ZVbB38ZYCKgvAI+zuBSyH/pGH5atQeIMCmEs0AF14SniQYuDhUGDoh3sGwL62LKIDIiCPqYysIXkOuXGr/6/BRVDIOyGQDY43W6sE55x5uCLogmTTFoYnQT8NmNgTky0cM/ozMJR728V35snccNwTY9bMjJtega8eE4AQJCZEjv3j4XWIab3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10400
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7283698d-2398-4239-20fe-08deef06315b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|14060799003|36860700016|35042699022|376014|18002099003|22082099003|11063799006|56012099006|5023799004|4143699003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	KdPqQgSzria0Z/4MqTdg3ZK4Zy+T2R2r7FZDXxvlx2CLiYD+jWNcTvSeNm+hTH0G4/ZEehxaLnnYvGnHZnl/mXBiAjzS3+4lqtXHHyKSoNAADP807TfBbI+X+DPYjDupDTb1uZyjQ+pnpfn+WuVuXKsFJTPlDW70PRFd+Rd00unFjzzJJYvUg1zrGukByd3HQIqynrkNYPXEf56MHHPTkzKFZMTWHAFTexSPE/3DAX92lqJJwlZGi+6aO/2NTm4CkRd/yq35s0xO4Lt619487tgZlEo8baO2eU9AnSOe0WGsSMmxGgBdJHUNO6w2WbeLni0BuObZuRF9lCft9td4Ge2uCMotT+hmGAmCuMtX8fkmo6T2+eOltabi4IibQdyrct9jt6rkMA/eEwd1NbsBWjd5may6bh9Xvey0RvOiAaaRSVnCgCPMCOmBt6or0Kmb7KFc47+BuJyVmT5MtMH5ieHTHefpWRHF5h4LKyXarqLHLFKFyt/AQ8vpUiwaz0MGNdqFRGESvhc44M/xjbw7LCRdUwFLjSEesObsZvXMXxAgSYZiELhbiUlZoWh3hM7uexG3/hjMc4nTycWFv799QaugirnVzwM+/7utNVhi/n3LIkfuxMutLHgN9B4VAFEy6kc1FbHI5x5JlUNffEOB/V57HjgLeE/8jL59umYNMFQ/bAjHaupt0OxJolu2Mepv2xBWQP9iwObMS2djXJn1DQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(14060799003)(36860700016)(35042699022)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(5023799004)(4143699003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uWHjNudacAH6niD1wSmeMc2Rasv1ZcZu8pNMuw3F7kK9pnaoAVKq+8k3qf/0ot1ulll94SzjMfScD63uEBnWyUGyUOeRoFO4ZwJQipZO+bG/9I+k+BI/ta60V0gwetns/h4eu3ac/mK1tfinwiSSkOTipt1/a3owIG4jGqJ8XgvzvnVoWGS2gh/tF20whIeKzCg6b6EhKJMy5lArAeiYDK40qrTZeU5jxO9umLnvyrjEd0UMWlsTcZnQNdy3MzGV4dx178KaQ6Jv2z5P7396oB1J89fcxBJ67/4bR+pqTfPUUFzboe9UK76s3lWTFIku23CMavfSZpqhZ8TYNebDRrbnJ3F/S6Pvhayqteg/Wa6NmAUGKjm96tU/lzSnZ176QDyxeHaL3fToR+W+XEvSxF+Z8ITvJ2lnH3BgXn+xxehlcb9zQHoFl/tANWHciH5B
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:19:23.9673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa59a95-c9b0-4bd4-0684-08deef0656f3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9052

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjM0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIE1pc3NpbmcgdmFsaWRhdGlvbiBvZiB0aGUgaG9zdC1wcm92aWRlZCBWTUlEIGFsbG93
cyB0aGUNCj4gdW50cnVzdGVkIGhvc3QgdG8gYXJiaXRyYXJpbHkgaW5qZWN0IGludGVycnVwdHMg
aW50byBwcm90ZWN0ZWQgVk1zLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsyNV06IFtQQVRDSCB2
NCAyNS80OF0gS1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgR0lDIFZEUEVORA0KPiBoeXAgY2FsbCAt
LS0NCj4gY29tbWl0IGM0ZGI4Yjk0ZjI0YTc3ODA3MGE1ZGI3NWMyNDA1OTA5NWJhZTk1OWINCj4g
QXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4g
S1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgR0lDIFZEUEVORCBoeXAgY2FsbA0KPiANCj4gVGhpcyBj
b21taXQgYWRkcyBhIGh5cGVyY2FsbCB0byB3cmFwIHRoZSBHSUMgVkRQRU5EIHN5c3RlbQ0KPiBp
bnN0cnVjdGlvbiwgYWxsb3dpbmcNCj4gdGhlIGh5cGVydmlzb3IgdG8gbWFuYWdlIFNQSSBhbmQg
TFBJIHBlbmRpbmcgc3RhdGVzIGZvciBWTXMuIFRoaXMNCj4gaW5zdHJ1Y3Rpb24gaXMNCj4gZXhl
Y3V0YWJsZSBvbmx5IGZyb20gRUwyIGFuZCBwcm92aWRlcyBhIHdheSB0byBpbmplY3QgaW50ZXJy
dXB0cyBpbnRvDQo+IGd1ZXN0cy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L2h5cC9udmhlL2h5cC1tYWluLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL2h5cC1t
YWluLmMNCj4gPiBpbmRleCAwOTc1NmY3MWRmMDhlLi44ZjljYzNjZDQyMmFhIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL2h5cC1tYWluLmMNCj4gPiArKysgYi9hcmNo
L2FybTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jDQo+IFsgLi4uIF0NCj4gPiBAQCAtNzE5LDYg
KzcxOSwxNSBAQCBzdGF0aWMgdm9pZA0KPiA+IGhhbmRsZV9fX3ZnaWNfdjVfcmVzdG9yZV92bWNy
X2FwcihzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0DQo+ID4gKmhvc3RfY3R4dCkNCj4gPiDCoAlfX3Zn
aWNfdjVfcmVzdG9yZV92bWNyX2FwcihrZXJuX2h5cF92YShjcHVfaWYpKTsNCj4gPiDCoH0NCj4g
PiDCoA0KPiA+ICtzdGF0aWMgdm9pZCBoYW5kbGVfX192Z2ljX3Y1X3ZkcGVuZChzdHJ1Y3Qga3Zt
X2NwdV9jb250ZXh0DQo+ID4gKmhvc3RfY3R4dCkNCj4gPiArew0KPiA+ICsJREVDTEFSRV9SRUco
dTMyLCBpbnRpZCwgaG9zdF9jdHh0LCAxKTsNCj4gPiArCURFQ0xBUkVfUkVHKGJvb2wsIHBlbmRp
bmcsIGhvc3RfY3R4dCwgMik7DQo+ID4gKwlERUNMQVJFX1JFRyh1MTYsIHZtLCBob3N0X2N0eHQs
IDMpOw0KPiA+ICsNCj4gPiArCV9fdmdpY192NV92ZHBlbmQoaW50aWQsIHBlbmRpbmcsIHZtKTsN
Cj4gDQo+IFtTZXZlcml0eTogQ3JpdGljYWxdDQo+IERvZXMgdGhpcyBjb2RlIGludHJvZHVjZSBh
IHJlZ3Jlc3Npb24gYnkgYWxsb3dpbmcgYW4gdW50cnVzdGVkIGhvc3QNCj4gdG8NCj4gYXJiaXRy
YXJpbHkgaW5qZWN0IGludGVycnVwdHMgaW50byBwcm90ZWN0ZWQgVk1zPw0KPiANCj4gVGhlIGh5
cGVyY2FsbCBoYW5kbGVyIGV4dHJhY3RzIHRoZSB2bSBhcmd1bWVudCBmcm9tIHRoZSB1bnRydXN0
ZWQNCj4gaG9zdCBjb250ZXh0DQo+IGFuZCBhY3RzIG9uIGl0IHdpdGhvdXQgYW55IHZhbGlkYXRp
b24gYWdhaW5zdCBwcm90ZWN0ZWQgVk0gb3duZXJzaGlwLg0KPiANCj4gU2luY2UgdGhpcyBoeXBl
cmNhbGwgaXMgZGlyZWN0bHkgcmVhY2hhYmxlIGZyb20gdGhlIHVudHJ1c3RlZCBob3N0DQo+IHVu
ZGVyIHBLVk0sDQo+IHRoZSBob3N0IGNvdWxkIHN1cHBseSB0aGUgVk1JRCBvZiBhIHByb3RlY3Rl
ZCBndWVzdCBpbiB0aGUgdm0NCj4gcGFyYW1ldGVyLg0KDQpXZSBkb24ndCBzdXBwb3J0IHBLVk0g
d2l0aCBHSUN2NSBhdCB0aGUgbW9tZW50LiBUaGVyZWZvcmUsIGEgbm9uLWlzc3VlDQphdCB0aGlz
IHBvaW50IGluIHRpbWUuDQoNCj4gDQo+ID4gK30NCj4gPiArDQo+ID4gwqB0eXBlZGVmIHZvaWQg
KCpoY2FsbF90KShzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0ICopOw0KPiA+IMKgDQo+ID4gwqAjZGVm
aW5lIEhBTkRMRV9GVU5DKHgpCVtfX0tWTV9IT1NUX1NNQ0NDX0ZVTkNfIyN4XSA9DQo+ID4gKGhj
YWxsX3QpaGFuZGxlXyMjeA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlw
L3ZnaWMtdjUtc3IuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUtc3IuYw0KPiA+
IGluZGV4IDQ2OTkyYTZjMmNhY2IuLjk0NzQ2MzE3Y2E3OWYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJj
aC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUtc3IuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2h5
cC92Z2ljLXY1LXNyLmMNCj4gWyAuLi4gXQ0KPiA+IEBAIC0xNDksMyArMTQ5LDEzIEBAIHZvaWQg
X192Z2ljX3Y1X3Jlc3RvcmVfc3RhdGUoc3RydWN0DQo+ID4gdmdpY192NV9jcHVfaWYgKmNwdV9p
ZikNCj4gPiDCoHsNCj4gPiDCoAl3cml0ZV9zeXNyZWdfcyhjcHVfaWYtPnZnaWNfaWNzciwgU1lT
X0lDQ19JQ1NSX0VMMSk7DQo+ID4gwqB9DQo+ID4gKw0KPiA+ICt2b2lkIF9fdmdpY192NV92ZHBl
bmQodTMyIGludGlkLCBib29sIHBlbmRpbmcsIHUxNiB2bSkNCj4gPiArew0KPiA+ICsJdTY0IHZh
bHVlOw0KPiA+ICsNCj4gPiArCXZhbHVlID0gaW50aWQgJiAoR0lDVjVfR0lDX1ZEUEVORF9JRF9N
QVNLIHwNCj4gPiBHSUNWNV9HSUNfVkRQRU5EX1RZUEVfTUFTSyk7DQo+ID4gKwl2YWx1ZSB8PSBG
SUVMRF9QUkVQKEdJQ1Y1X0dJQ19WRFBFTkRfUEVORElOR19NQVNLLA0KPiA+IHBlbmRpbmcpOw0K
PiA+ICsJdmFsdWUgfD0gRklFTERfUFJFUChHSUNWNV9HSUNfVkRQRU5EX1ZNX01BU0ssIHZtKTsN
Cj4gPiArCWdpY19pbnNuKHZhbHVlLCBWRFBFTkQpOw0KPiANCj4gW1NldmVyaXR5OiBDcml0aWNh
bF0NCj4gQ291bGQgdGhlIHVudmFsaWRhdGVkIHZtIHBhcmFtZXRlciBjYXVzZSBhIHJlZ3Jlc3Np
b24gYnkgdmlvbGF0aW5nDQo+IGd1ZXN0DQo+IGludGVncml0eSBhbmQgaXNvbGF0aW9uIGhlcmU/
DQo+IA0KPiBUaGUgdW52YWxpZGF0ZWQgdm0gcGFyYW1ldGVyIGlzIHBhY2thZ2VkIGRpcmVjdGx5
IGludG8gdGhlIFZEUEVORA0KPiBzeXN0ZW0NCj4gaW5zdHJ1Y3Rpb24sIG1vZGlmeWluZyB0aGUg
aW50ZXJydXB0IHN0YXRlIG9mIHRoZSB0YXJnZXRlZCBWTS4NCj4gDQoNClNvLCBzdXJlLCBwcm92
aWRpbmcgYW4gaW5jb3JyZWN0IGJ1dCB2YWxpZCBWTSBJRCB3b3VsZCBiZSBiYWQsIGJ1dA0KZnJh
bmtseSB0aGVyZSdzIG5vdGhpbmcgdG8gZG8gaGVyZSBhdCB0aGUgbW9tZW50LiBMYXRlciwgd2l0
aCBwS1ZNLCBpdA0KbWlnaHQgbWFrZSBzZW5zZSB0byBzYW5pdGlzZSB0aGluZ3MgaGVyZSwgYnV0
IGZvciB0aGUgdGltZSBiZWluZyB0aGVyZQ0KaXMgbm90aGluZyB0byBkby4NCg0KPiA+ICt9DQo+
IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
