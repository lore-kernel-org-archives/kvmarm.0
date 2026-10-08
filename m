Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010048.outbound.protection.outlook.com [52.101.69.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6125483BF9
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 13:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466305; cv=fail; b=elD8wa5Fil5CnmnvxYVvQi4rA68CiL6JbBpOEbDy3EnbwaQwWZ5VbUeFdoBwFWI56CJUz23KLbQPq3IFX3ySIr6qLCzxT0em62XmG1FQbY2QQQnBQuD9CDrmUVbNl8HIQS61NzXY0ShBYcj8jOqaJrs9duxMrLRFe3UiRPYkOOg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466305; c=relaxed/simple;
	bh=SjbvM43bFqokIJ0FTsNloBzxv9mCqkbAcizyV+1PqBk=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RgF9zflbLubDFRC4ipQrF49BzwZFZtzb+z+SoP4UjTXxMNdaKOYIlTGh6mQBGO6s9iWhXWbrcXp1Gm9cI+IW/oVypLr+Mf2mz8y5ksNBmBbRjXSR1dUbiYojcnWtSWA9H9qOFOWM2G06/WAn0jUFHSKvukzWFTct0/kMmmhAoJY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dc5XZMoi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dc5XZMoi; arc=fail smtp.client-ip=52.101.69.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dc5XZMoi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dc5XZMoi"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sNu8oFGqnjqX0yvgVrkf/e8R25NqE1Ths7NPkZLL/vEY4/wtKH7t/aLypeCrc94+xizsP4lZvYlhwyHnWEMMGhmV/1wKlUkrAFY0N1UmySkIG+ftaDXoIFJOxvH/fKtLnCqBa2zaZg7b1JDAGsU5KAsmueQ0v2GclKsywDlBwIHeLu3RLLZCK1Ew3Ab/1bgaDuyHacnT3/ch5jBDxkiNyR1O+z5iBIjL8Gu6nCIAsQh9jJsfvSvEFNLc4d5ITh15NMcmqekjoF5tzEyIZYGsLx2a9M9Pod955ozwwS/CNJsbKihlAyjb9e5Bk61z65p4TPDwZugBxvllzx4ig7Hxew==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAW3OLbgZC90aIme5i9hpgfNIpHUOlGliRJb4ffbfng=;
 b=QDcQkyY9xrrkquCedXwCY0XPvf4pVJW/iTA1UpWIBvMAawOvUuqLmWymrAgzHeZziRFkIuso8aRjRtxr8dLEF8RKy+x+kOV0FnHjuRNd2EHUetkcV0WN0UUgux7DyNV138MfEhx1TbT2hOlrjxh29b55Q5nTZPr37hF7rYHd5ZTayHBEbsTHDmMIFHbiBgTWOcl9xe+mEw88b0rbT2RKDesBxzgSnn/Q+zPPA0YGIozXwsJ9CtumFlf0vncwbbIgCvtzWUuSr6J/YgEBTaLjQv4aWLbXKGxATJ1MXNu9sMReLch4mRFHm5B0fCbRiLZbpqZuoRikQpF8tna6FhivgQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAW3OLbgZC90aIme5i9hpgfNIpHUOlGliRJb4ffbfng=;
 b=Dc5XZMoiDpY9msIuE0CsstmW45PP/qur3JDjiF5o+2oM3O89D80vRukinWKS9jhCRIBt05IvNvwoT+gvbD5vOBLk4lChxuFu1cYEZcx+BJB1dL6jtePeSPN1PYg8QewLVN9s4JuWMAEw+ErERy4TGhhsn6ryEFKHdRs+KW0LFTg=
Received: from AM0P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::33)
 by MMZPR08MB072916.eurprd08.prod.outlook.com (2603:10a6:190:36::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.6; Thu, 8 Oct 2026
 13:31:39 +0000
Received: from AM2PEPF00070CF8.eurprd02.prod.outlook.com
 (2603:10a6:208:190:cafe::53) by AM0P190CA0023.outlook.office365.com
 (2603:10a6:208:190::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 13:31:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF00070CF8.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.14
 via Frontend Transport; Thu, 8 Oct 2026 13:31:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWg7TGhmpLhMhY5dIc95/eRLTunrn0Lv5j/sf5eq6KSX2pltXOxzN6XFjQQ05saWqa0A/Mu1kb1Yu9FbLv5i8JzaAzipFlYD1p8VXXrGpMaeBMqH4MvPcwJXclV4N70AMdquIs2+VvvUH/BItrbYB9eW3h1YtWTV/R3lnz39En44uEvHH5NGWXRFlUhPYUk/xotR+L706DAqLs07A7CPkQKnx1OruzRYCczbea94zkOcutToUPfYHSaKf6daa/BM5nLNmK/rY/jbYuC3OhcFUYvkfg3NDmf89h7DITYxLzDdS7CX2iu41Fjn32Qg1Ts1t+Kd9YK6JOio4ONhN5f1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAW3OLbgZC90aIme5i9hpgfNIpHUOlGliRJb4ffbfng=;
 b=lkEslZ+oBJ9E0/gfAr1ZVi0c5a7cu4Z7B9FuCXxb/Xq2+xUVdR99R/qmyY3VZ2BujQKGfBclzsv1So2833bS2+/SWCDNk31r+ETqG7/X7Sh7kgPeWbWqunBFH3B0SU3Z/iaXVH2pwp24p1sPlRx+nbRn0gWlNj7itaq7dPyykswDl356zhjoYCAoDoCIAOXIciBScZh8LP7w5zoJDk/9buXb8Yru3lffqL2lywBCQu6pwFBoobP2aV/he8gR0q0acMGtRPxeqVDoh06ADWKVOtnuC5FFLUb+oQ6jbLnTc0+CMINK99MfsLZYgm105pEeoiot+Fx6L67bd+CUaZ415g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAW3OLbgZC90aIme5i9hpgfNIpHUOlGliRJb4ffbfng=;
 b=Dc5XZMoiDpY9msIuE0CsstmW45PP/qur3JDjiF5o+2oM3O89D80vRukinWKS9jhCRIBt05IvNvwoT+gvbD5vOBLk4lChxuFu1cYEZcx+BJB1dL6jtePeSPN1PYg8QewLVN9s4JuWMAEw+ErERy4TGhhsn6ryEFKHdRs+KW0LFTg=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS8PR08MB8948.eurprd08.prod.outlook.com (2603:10a6:20b:5b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.14; Thu, 8 Oct
 2026 13:30:22 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 13:30:21 +0000
Message-ID: <ec298ee5-5080-494d-b735-7ba7bd20cdf0@arm.com>
Date: Thu, 8 Oct 2026 14:30:20 +0100
User-Agent: Mozilla Thunderbird
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
To: Catalin Marinas <catalin.marinas@arm.com>,
 Leonardo Bras <leo.bras@arm.com>
Cc: usama.anjum@arm.com, Linus Walleij <linusw@kernel.org>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
 <aqq1sxdQNZ93oV9A@LeoBrasDK> <aqq7oZzutLP82WYB@LeoBrasDK>
 <arP619hd9Rx8Vlrx@arm.com>
Content-Language: en-US
In-Reply-To: <arP619hd9Rx8Vlrx@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::23) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS8PR08MB8948:EE_|AM2PEPF00070CF8:EE_|MMZPR08MB072916:EE_
X-MS-Office365-Filtering-Correlation-Id: c044d8ea-e010-4199-cacd-08df25407b46
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|4143699003|6133799003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 mg9k5snoRTocOdc00qvoX9jy91PRcvx+Q9QdjJkZxSeZ8gVmcdDIPp+mk37YuC1Z0huZEvM2pATel2XBdCFRIy6jenKp9/Mho4udqTJ6iGnE7eVtPSEfl9vse0Ps1mpuKGyUdv9gccbYCy7dhoZnrdgg9Po0sl00hMrbyC8iO+jshweKbk4BBLLZwvuStwS9fGJS438izphg0b561kfhZWu7c6YQmmnqjbUMAddcG5UXUbfraiQUr2fjD0KOceBpGFlzITKNnYptP6faQaiI45I5snEld8u0LNDgpey3soUvqbJ8BV6WNV3e6JlKAMf6jWHp9k3t6zKVkfjUTYh4hJgjUIG/zQR6mhmag5del4FK/GUqs3b24N8OiPKQKcPQA77eNq6b5zxNYc01qCnv0IkyGDYQCT+G9h68zyukn6MmtaVYwqeiNsdstNpExHVmHlxRMy5Gj1A4NxvmVfEZvcwdmn8hQUdbOG9E7yDlbqjMTDEcVtDloqGiRaB9t/0K9jBp2jPo27Oyts3s0zYIXVBE193mjGZYxIdEtaKDs/1fbh0/eikBgKwhQh6oWkFDjC3/h0mVgViTfUAl7jH3MUl2jSGyFasFvWflPzP6imHEGCQLABq7JC5NMhZuaNltUo5IHsmPL1lHC8M0EYeWkF1ZWg97sI02mxNv4nROGDg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dNRmg/wKXH1+eJ/oSlEhjcoXSelsXwm8Ss9OSF9vxAFUl2rx/XoupNbG5YY6RRR36/rQY+hHYFPyGSvmuy1NWQz4nOFxMfAo+X6OARI8GkBfwXrFQCDH7f3wXumsphhxblby2xChf6K2U4z4Cc/xlLzw2PJQ2gcYwLFOjzwiKpa2ZwKqovODn6Xcgc+BQ5sRr/1B3S/44XlEqR7ZS2iwcVhcdLp6tA/UMeaxtAQ/pNy22UxtyGdeEd/yGBJv/B/c+cAnhb9FSZXj1XjE8mbsJpLr7V3vAmltVSWjD9XxqpQIKWsBW7TfUqgCbNOW0ydQlcQGfKGbTZEV+65IxJ1qpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8948
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF00070CF8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5f727187-0a06-49a8-cff4-08df25404d5a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|23010399003|376014|36860700016|35042699022|4143699003|56012099006|10067099003|6133799003|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	BbVF2RsBnBL1ebI79NLR5wV3DlPhBiJPJ+/L3l2yn028Xk0uaKTKz2EEEIEY3bOG6EfbBdy4WuUUWTqOHxiSU8QDB6pYYCwteEybEYZiehEa6oYgrSkeb0QtcRj3CqpJAaZSnb2OwqDNqJvKUgKwA+SC98aH2uZh9VrhgOPsyEMnvFeTHHpJ9MQ/tHtKezaqKxcEwha275ATDAsDDZC+DDolC2SJkpJy1A3S1+0cG4D/9tyvNE7xGaxqY+QPiLxUVwmOHRCLvY+z3O8+yxiwO6qjQA3KeNfzFK2fDKjqBK7zqbmVb690p7IpUlQxRAkTYZHf/fvvmi5csYDm4QPSHw53m9qxQLvRTiKWJAhrXrftmLskJ2WjZ1lQWo2euRMCHeM7cnqD2ljipAK1vZf7bCh4K1pway2v/SlCYiRbumv9T97JB3FLu3JxfAFfEqg7WvPNzWnFIcBRbhZjTK6Rcc8/QUQjOSXM47FOJ5GMKI3WpDHn8AnuGUxM6QaRNSAQXIM3pGRVE8eMGW4IZsw2ZCleVW9qBFWL4vgQXr0hp0YSU5WASYTc75kqyEw5U+PsEjbnoHDHYT9xjhy6ged+9hYxCLS7jkEatIzDJpHxLPwnJwje9RI/YLPlka90dnb7FdqvxF2i/p39SLitfAJujZgQV99vhwZZ1kDwWrMFMLyiwSQU/HfOkt9oat3tw7jmUkaAoJYcOgy3fV+fqcAWRw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(23010399003)(376014)(36860700016)(35042699022)(4143699003)(56012099006)(10067099003)(6133799003)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wEu1V7rTdjQDIN4IF8ChqW9vkOWDwTPz1QZxFFXUAGfJuuuFjhHRgkCguzsK0GCSFjExqpO5FG4WrNUWyNTAzc/3kGROWlBp+WmZaM/EtW8wc3nUzOD5dsTepYcm03j3jVGAAGG6G+GbDDF7uheXGdjfW6ea2D0g+s8dl3dtS5I1JiQ4wn/rMjAfMh6+MT8nX6E6QsMXtNWpv4jg6R68E1dhOjDi6tTQNEl0F35nAvTCyE+lu57r2uu69Q8FvB6ZfeyMR7cU4euYKjjAq8wb6mTVDBJJWAP0GrcrB/ABNjuTKtDUPPAAWg5RKt41BK3YNqqw58fuWDFIbBasSQspPjmhswEPZNsiumrhwE++vtc6jexd6mTxiCunE3bOxICoykeUUf5EI44L82BML2MTcicN2iICj2msSCd6SwUrVZFYFu6bDjK3O7/o/lP/FCv6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:31:38.5242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c044d8ea-e010-4199-cacd-08df25407b46
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF00070CF8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR08MB072916

On 23/09/2026 5:14 pm, Catalin Marinas wrote:
> On Wed, Sep 16, 2026 at 04:54:09PM +0100, Leonardo Bras wrote:
>> On Wed, Sep 16, 2026 at 04:28:51PM +0100, Leonardo Bras wrote:
>>> On Wed, Sep 16, 2026 at 12:03:56PM +0200, Linus Walleij wrote:
>>>> There is no need to try to second-guess the compiler when
>>>> clearing memory. Just call memset() like everyone else.
>>>>
>>>> Since memset() already has an architecture-local MOPS
>>>> optimization, we do not need to do anything else to preserve
>>>> the MOPS optimization.
>>>>
>>>> While at it, implement the shorthand for directly calling
>>>> the new prototype clear_pages() for larger page chunks.
>>>>
>>>> No performance regressions can be seen, the fastpath
>>>> benchmarks differences are in the noise.
>>>>
>>>> Usama Anjum tested next-20260821 with one warm-up and three repeats
>>>> in four sessions, for a total of 12 measured runs. The commands were:
>>>>
>>>>   perf bench mem memset -k 1GB -f default -s 16GB
>>>>   perf bench mem mmap -p 1GB -f demand -s 32GB -l 5
>>>>   perf bench mem mmap -p 4KB -f demand -s 32GB -l 5
>>>>
>>>> The results were:
>>>>
>>>> aws-m7g.metal:
>>>>   Benchmark    Base bytes/sec   Change with patch
>>>>   memset 1GB   63932542232.12                1.92%
>>>>   mmap 1GB     63272579168.03               -0.57%
>>>>   mmap 4KB     49692830849.48               -1.11%
>>>>
>>>> cesw-aarch64-ampereone-1s-a192-32x:
>>>>   Benchmark    Base bytes/sec   Change with patch
>>>>   memset 1GB   33895562998.71                0.25%
>>>>   mmap 1GB     34338454210.17                1.16%
>>>>   mmap 4KB     25687107580.90               -0.85%
> [...]
>>> Looking on that, I see that the memset() implementation uses setp, setm, 
>>> sete, while the clear_page()'s uses setpn, setmn, setn for the case with 
>>> MOPS. But then, reading into the docs, the instructions seem pretty much 
>>> the same thing. 
> [...]
>> Oh, I browsed a bit here, and IIUC none of the tested machines have 
>> FEAT_MOPS, is that right?
>>
>> If that's the case, the tests are exactly to what is different between 
>> patched and current versions. There should be no impact on MOPS version as 
>> the instructions are basically the same.
> 
> Logically, yes, they are the same. From a performance perspective, there
> may be a difference between the temporal and non-temporal variants,
> depending on the usage.
> 
> I think it would be good to run the benchmarks with the current
> implementation without DC ZVA. I don't think we have an easy way to do
> this on the command line, so we can simply hard-code the DZP=1 check and
> fall back to the STP or STNP in both cases.
> 
> Otherwise I'm fine with the patch as well, good clean-up.


With DC ZVA bypassed, clear_page() STNP and patched memset() STP showed only
2 statistically significant regressions on AmpereOne machine.

Results for SUT Class aws-m7g.metal:

+-----------+------------------------------------------------+-----------------------+---------------------+--------------------+-------------------------+
| Benchmark | Result Class                                   | next-20260922-vanilla | next-20260922-patch | next-20260922-stnp | next-20260922-patch_stp |
+===========+================================================+=======================+=====================+====================+=========================+
| perf/mem  | memset -k 1GB -f default -s 16GB (bytes/sec)   |        65367617364.09 |              -0.32% |              0.70% |                  -0.80% |
|           | mmap -p 1GB -f demand -s 32GB -l 5 (bytes/sec) |        63750796288.65 |               0.59% |             -1.56% |                  -1.15% |
|           | mmap -p 4KB -f demand -s 32GB -l 5 (bytes/sec) |        49588573632.22 |              -0.39% |             -0.40% |                  -0.93% |
+-----------+------------------------------------------------+-----------------------+---------------------+--------------------+-------------------------+

Results for SUT Class cesw-aarch64-ampereone-1s-a192-32x:

+-----------+------------------------------------------------+-----------------------+---------------------+--------------------+-------------------------+
| Benchmark | Result Class                                   | next-20260922-vanilla | next-20260922-patch | next-20260922-stnp | next-20260922-patch_stp |
+===========+================================================+=======================+=====================+====================+=========================+
| perf/mem  | memset -k 1GB -f default -s 16GB (bytes/sec)   |        35882584735.80 |              -0.36% |              0.43% |                  -0.00% |
|           | mmap -p 1GB -f demand -s 32GB -l 5 (bytes/sec) |        36204572635.77 |              -1.17% |         (R) -2.07% |                   0.14% |
|           | mmap -p 4KB -f demand -s 32GB -l 5 (bytes/sec) |        27149223683.79 |               0.54% |         (R) -2.48% |                  -0.13% |
+-----------+------------------------------------------------+-----------------------+---------------------+--------------------+-------------------------+

Patches
-------

Forced STNP:

diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index bd6f7d5eb6eb6..29796024b3254 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -28,8 +28,7 @@ alternative_else_nop_endif
 	ret
 .Lno_mops:
 #endif
-	mrs	x1, dczid_el0
-	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
+	b	2f		/* Test-only: disable DC ZVA. */
 	and	w1, w1, #0xf
 	mov	x2, #4
 	lsl	x1, x2, x1

Forced STP:

diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 97157da65ec6b..9a51511dc57f7 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -146,8 +146,7 @@ SYM_FUNC_START_LOCAL(__pi_memset_generic)
 	cmp	count, #128
 	b.lt	.Lnot_short /*count is at least  128 bytes*/
 
-	mrs	tmp1, dczid_el0
-	tbnz	tmp1, #4, .Lnot_short
+	b	.Lnot_short	/* Test-only: disable DC ZVA. */
 	mov	tmp3w, #4
 	and	zva_len, tmp1w, #15	/* Safety: other bits reserved.  */
 	lsl	zva_len, tmp3w, zva_len

-- 
Thanks,
Usama
