Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF839A812
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335724; cv=fail; b=Sz/QL9ysWp5UI4TYmlOr3tVlNlmlld4m8T9H5i2cS1M5j+Fyb1e6+Ho9+IF6YGdgoO9KaGAffDw2IC0Jr+NN3nwxVndK+tORoVyyK8yMz9xsle3kS0V1IPwflOVespFBTwsXVnPVAQVN0Mwa1+1fy0G8U+HL6+7Tsu2DUBoI92k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335724; c=relaxed/simple;
	bh=zwIlkxi/IbEx0fkx+VjM6LBUxEBEcWi1ALhcYsjjhhs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ls13WLJdR3yK4nNQBBQx9fMOvgeFhJHTMYmQ/8SUeMAOL2mFbBj8KfwKBViqrDL5VPftImdJvHT+IkT+QKl1PYkDTCZfFHn5bRCdA39fYuGyUWMyfiUAPFO0FsSqln2JY6YMP9LFi4riay5sYAPVEYKi/7vF8wF5tZfgJb4FO40=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HEKHD+DJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HEKHD+DJ; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HEKHD+DJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HEKHD+DJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Dr5KXyIfet6O9SPZQ200do++L100DhbZNGrjOcuvd5YekgeFfJKPPgzR9Ae4yethq8WRZ8CxbKcO40LtHyATnRM/hEPiZ4sN0TDemTEodMIcG5ZEOioE6ZhwYyJUUFpUJyIaQSYyK2uSbacZ4fXr5+Uscf7mHcclOnMmf6oZvVI22J+l1VTPBcXeW2g8jAn8Vzj8f/ExD46bQkYKP7u9q5KolPFaNKrPVMxtk75tpKMp7gxEa/vEi/iidOywz0lRG0rk4lHqXpQ3UTVctC/AaLI0dcuE3FTcPjN7BVtyvKe93JQsrzK3mrTSEkJlsOgBn42L+lwgWA3YWnBozpsY6w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLdBv1c0KMnWhu+IkdFkGokyni4/TMaPxlfhmsUupSw=;
 b=od9iFqn3Tt5np1BljCshc6cpI2bA14YcFpBXeAVyzNYYfYDmoNniKTpcapWf6fHaygllWpvXVCOTNQMnVZdwxbmkjdF4soGVQHMQ+7FVFwk2OtuosUxF4wu+Z1WXf7a2ugb94WwfgIGIqMFVD1zLv65+onbfiFsTZlxsvF0FEHxbu7q0CCPD8g5x0v++3mDKR8KUGr1ZitOHJlLZ1Yb0B8g35DwqEvz09DudgThkAd+y69Xx1tuUGSlEbq/q2896dll8uiNveI/iNjZQCecHf0BJq2tBV+xi3nLXnvApabWtio1Ud0y6hnDdUvpi7cl+Y+wqmMZJZCDvTL5+OCEGsQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLdBv1c0KMnWhu+IkdFkGokyni4/TMaPxlfhmsUupSw=;
 b=HEKHD+DJqgr0wSg6bJ5/rlcHQscQdJE915euy7IenOfJMriWokzHcTTngwVrG6vNj2V2J/mzZyfUduAiIxUDalZ9FpDjtEw7nq8Tj6N/oZ/m2s4Ut9nLAVzLkyaQ3sWIuCPEBHWy2Bse3m4Iz+wdKWbciiKtbYEtykrrdegWv6c=
Received: from AS4P190CA0069.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::15)
 by DU0PR08MB7520.eurprd08.prod.outlook.com (2603:10a6:10:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 11:01:57 +0000
Received: from AMS0EPF000001A1.eurprd05.prod.outlook.com
 (2603:10a6:20b:656:cafe::49) by AS4P190CA0069.outlook.office365.com
 (2603:10a6:20b:656::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 11:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A1.mail.protection.outlook.com (10.167.16.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 11:01:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZBUHt0KlVUscXdjmxWSNRr8urmuyZl0ifeudkBA/wltphlMKH0c8z22OtXsvtZqff/MkR0c2r0tHMp+4UaYMf2JidzpyfTqtkVWKj+hohS2NFM+2GLfVPhpYavMglfkRL6Xsba1Gug+aDcDZUY21q2S0YDDDNeCxOP7/4NrUPRW2ycBdYT8Sz9M//ljHZ5B3i7MOt5nRILXquuG4kdKMVb700JiWNAr4oO84x9zIzrzTWkiIVH8fEWj3BsBFWQHc28pCKzOtmeqx/axwnehp8CZxpBZ9vNrgUj5JUfuGedandXH5ZxPDLhZQ+SuaGEhCP5WNy+N0c5SP9Esy+7/hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLdBv1c0KMnWhu+IkdFkGokyni4/TMaPxlfhmsUupSw=;
 b=J7a4a2eiw23YPYI6Aw9dZ2kUuXuNqSf79IqeTmhF1ZNTTwXxfm7AKCW/iTmekp3IWpIGXhpGtjeECdtF0+XJcaPrQl9JP89d5cmd0K82Tg/VtGw27VfaL8YL19lZqUb+CxBNg5i7doyd40vApdgrAnCSqG/58BKFnyCqKGjKwL8Syhdi9yH64MfmoiwfVPfUSHRW2wPifww07wjAceRoE/KKNQf6XfvWhz+dWH+xIkNP5dsrtxarTg18bjY7Z+LFSjy87G0Juimr18Sqc1v2EaCJbrJKDU2V7pT1Ms+eoFBJCqRGAMjQnK9s65yaUUmGed4A3pMeLhfLppSFINu5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLdBv1c0KMnWhu+IkdFkGokyni4/TMaPxlfhmsUupSw=;
 b=HEKHD+DJqgr0wSg6bJ5/rlcHQscQdJE915euy7IenOfJMriWokzHcTTngwVrG6vNj2V2J/mzZyfUduAiIxUDalZ9FpDjtEw7nq8Tj6N/oZ/m2s4Ut9nLAVzLkyaQ3sWIuCPEBHWy2Bse3m4Iz+wdKWbciiKtbYEtykrrdegWv6c=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS2PR08MB9222.eurprd08.prod.outlook.com (2603:10a6:20b:59e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 11:00:52 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 11:00:52 +0000
Message-ID: <5a699a28-07ce-4a6c-bc41-8b9bc7ca0d4a@arm.com>
Date: Mon, 6 Jul 2026 12:00:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 4/5] Add guest_memfd support to
 kvm__register_mem()
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-5-fuad.tabba@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260706083555.302972-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO6P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::14) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS2PR08MB9222:EE_|AMS0EPF000001A1:EE_|DU0PR08MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1da9ee-1898-4662-61e9-08dedb4dfea5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|11063799006|4143699003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 QU340qWWvP4V8mgDq5sAFvVLATupkas+kERu3s8JzvWkygZ+VQ6o9jlfL1klTIuWxDBlClQFNVolm9Vt5h+n2bR+jpIMN3ywj54IfAikhZeNfZm/qZwsfXR7Oivr3QagyEDjjNGxrAZbDk00Y2NDGEHj7D90m+LRn8l+eKTMKWrsa7H0WcK8g9RlgZKES2XJG7Xx0NZMmqc0dyNPFJYS9KbagZSDONe1Y/LOSsUN2IcucHHw+qo/Syi8phNedAX7O52NXPHxIiu0Iw0q27nb5R13AMHoCPUKlpNi+dbLgFLNWdfaU0T5ULuXWTgPJAUxHPnphIgGVlmlg/XxC4nvJePf4tAGav0dp0rwpqBC0x3us47f2bWo2h1UQbuXzj9LRkVCTPmZBeDrAc1z4w2fZM05I4UYXrfhIokSRvxJVoCC9psuhfbJJ9qTERhCdYEnP1LThXXls1i+VCqzcse2vmTGmUxxo8GIsZGYOj0Pzv7hamQoft1izYN/CmOnNCSrct2Y/MGoCFki+dVhAIW+t9qpbs1iCuqp4o6qH3w/3I+KnU2zZh4/DinX4imptnfFTUh16tMtnNgfD6GG0t0jV/N/JX6HzME14pMduZJGhg2m35UyyLorMFGoBeVi9KYe6BMjX2u2kAgB0oIaAg5+umDJMLVHaMoVFsOMQKA3qGY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(11063799006)(4143699003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Sf0C5o6W3mV5QTvmQAqaQskOFGCEWhho7S1Ysltz0T7QwwUMcEr2pt23nEyI1nsJ97NTI34wXvoPbWN2DfkxPH+S7kL+FiI/gz4Gj0FAUNBBPp62JC5cNEjU6vuZajG6XVOXpccAZjGBkL48P0dF6VfPH8gqR23IwWX5UcbVFGtKxD4LT7/lGOvnG+SyWLZwcRBkCXx/eG5cD1rfMOfafRN5hWKwewECLeqLmyHaEsLzUsETgdwM0WWeE1nm0PNHAIuB0DV7c45ciuIum+DltXRuugwqEbct5s21Fh30HFKpPus8sruhRy2tlf6dVnUpLVrMjTJxxlpFznI+C/az6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9222
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	22400790-53a3-46ce-2ada-08dedb4dd880
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|23010399003|35042699022|1800799024|82310400026|376014|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	81eWjLleqis555rHEOhWWqw2IXpd3KN2wSeyzvBD6/15OgAsWFBWZzZECN/MHZMgIeDsmeaooqjHztlEZe6GcdozWUy/ZcAYBPC84Dbb+jizu1bhFawf/vuugjLmarHF1VPDUbDBp59Vty5O04kI95Cq92yVKy3XcN1Mlvn/Bi5dROr3kutLexy5Y30GKFY3nLp8Bk+z5nVl/m3zgQyYLoqbncRWWVK6XTRR6onUKxaluQ9h+BgkcxSUY5Ltm9IoGSVjLZHvQPL7UENVVxY6zhPgvObGShu9OzPeSexmyo8IvXRDq3YT6akcSb00cUWpbRU8xAyZ17huyMOon0VG26sVwfA7G2QW5SFInEiOZGa1jVvr/RdG50kTbXqowYmPk3VBi95arnNHDWZjnlqKbu08c/+siefbcrWZflbkzmCnXbOpcYiZrid1RSXSOaeZtuRYJGdOUt+btMf3sfyqAwRWcaUSD4vSsmvaXn5HG2udS8Au2O4kp/5LPo+j3MS6SCvKFnNPHnVi8TR3bZjbDjD9B4G1ai27xF8NSTjcFecTGcWZ0drV0rpnv0G/xJUwbhvvhpBORUwNvn2SOADjFNcBjRXXZXsr/9uiT6qi3iUgroZVUH1OJ9DVingcVsWhhzIdEpduXxqhbrp9k/JOLk9K9O3OxLNNr51LijkrcFZA+41sgDwOUEWWPOmCzsDMkLFrpLpHc8NqF4D27h0pGA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(23010399003)(35042699022)(1800799024)(82310400026)(376014)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RfqlmN7N9WjmlXwSg7mnHXA+pIvAlZeTvGtsNFovRoIHHLNCsyJyfmzNqX9uIRXKTPL6yINPO90OTkcflPpa4Jo8cG3MT1qSAuOYuga5k8wBjSGr6D5gaoIOUF8GssijFe4KBdMA49VGmBu0Pu4E4EVqyXID+AQf31VkvT5+9CqXZivpX+Qyucb6C7H36kCl1zrPbuAc5mHYBqUAXcS8wlnyaBslFmipw3yDDLEFEfmU9MM9WSzE9SXw1MVSF0KgQ7j4Qd6wjI72DTukZ1Q/3Ln3u4UQ+HorU7l+LDIsZr7YjqHcQ3btDyl5R1/K0/0JsYZsBB6dH9Wu+gQdtZDVoee/pC1WqPG8yPcppsVA7je72+xvwnjq0paz/f09ftwrhKn3rG45ee9wkMRP32DfZqEBIFzOusjE3KCZAha0cIc/yj34euTA1UTXJkJkDC29
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:01:56.3434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1da9ee-1898-4662-61e9-08dedb4dfea5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7520

On 06/07/2026 09:35, Fuad Tabba wrote:
> Add a guest_memfd file descriptor and offset to kvm__register_mem().
> When guest_memfd >=3D 0, set KVM_MEM_GUEST_MEMFD and populate the
> guest_memfd fields, binding the memslot to the file. This prepares
> for backing guest RAM with guest_memfd on arm64.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Looks good to me

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   hw/cfi_flash.c    |  2 +-
>   include/kvm/kvm.h | 15 +++++++++++++--
>   kvm.c             |  9 ++++++++-
>   3 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
> index b68d9e0..4413955 100644
> --- a/hw/cfi_flash.c
> +++ b/hw/cfi_flash.c
> @@ -451,7 +451,7 @@ static int map_flash_memory(struct kvm *kvm, struct c=
fi_flash_device *sfdev)
>       int ret;
>
>       ret =3D kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
> -                             sfdev->flash_memory,
> +                             sfdev->flash_memory, -1, 0,
>                               KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
>       if (!ret)
>               sfdev->is_mapped =3D true;
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index eb23e2f..5e7b5eb 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -128,11 +128,22 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port=
, void *data, int direction,
>   bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u=
32 len, u8 is_write);
>   int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *u=
serspace_addr);
>   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *=
userspace_addr,
> +                   int guest_memfd, u64 guest_memfd_offset,
>                     enum kvm_mem_type type);
>   static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u6=
4 size,
>                                   void *userspace_addr)
>   {
>       return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> +                              -1, 0, KVM_MEM_TYPE_RAM);
> +}
> +
> +static inline int kvm__register_ram_guest_memfd(struct kvm *kvm, u64 gue=
st_phys,
> +                                             u64 size, void *userspace_a=
ddr,
> +                                             int guest_memfd,
> +                                             u64 guest_memfd_offset)
> +{
> +     return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> +                              guest_memfd, guest_memfd_offset,
>                                KVM_MEM_TYPE_RAM);
>   }
>
> @@ -140,13 +151,13 @@ static inline int kvm__register_dev_mem(struct kvm =
*kvm, u64 guest_phys,
>                                       u64 size, void *userspace_addr)
>   {
>       return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> -                              KVM_MEM_TYPE_DEVICE);
> +                              -1, 0, KVM_MEM_TYPE_DEVICE);
>   }
>
>   static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64=
 size)
>   {
>       return kvm__register_mem(kvm, guest_phys, size, NULL,
> -                              KVM_MEM_TYPE_RESERVED);
> +                              -1, 0, KVM_MEM_TYPE_RESERVED);
>   }
>
>   int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u=
64 len,
> diff --git a/kvm.c b/kvm.c
> index 8a7fd09..3d05756 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -237,7 +237,8 @@ out:
>   }
>
>   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> -                   void *userspace_addr, enum kvm_mem_type type)
> +                   void *userspace_addr, int guest_memfd,
> +                   u64 guest_memfd_offset, enum kvm_mem_type type)
>   {
>       struct kvm_mem_bank *merged =3D NULL;
>       struct kvm_mem_bank *bank;
> @@ -327,6 +328,12 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phy=
s, u64 size,
>                       .userspace_addr         =3D (unsigned long)userspac=
e_addr,
>               };
>
> +             if (guest_memfd >=3D 0) {
> +                     mem.flags       |=3D KVM_MEM_GUEST_MEMFD;
> +                     mem.guest_memfd         =3D guest_memfd;
> +                     mem.guest_memfd_offset  =3D guest_memfd_offset;
> +             }
> +
>               ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem=
);
>               if (ret < 0) {
>                       ret =3D -errno;

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
