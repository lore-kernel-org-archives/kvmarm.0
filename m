Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013050.outbound.protection.outlook.com [40.107.159.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05A379EC4
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457945; cv=fail; b=hBXUBs551Ei18O/N+ov6OtR8UTcUqJ26N6t7ihWwtQDI89AgPeRxszAfhROVZWw8HbC/LSU9v1peUIJxJDVxHN3zFBD+gfv7HIZyJ6Bx/i65mfVkq7RIxBEVQpwDzANyQsCI3mkz6RchBUO0kAJF5aa6eqXnnVLnwmnKMUUPaR4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457945; c=relaxed/simple;
	bh=waSPlTadX/XJQg55ivwb6u0/DR/F+rw0NMhpdEBw/Cc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LdURmejJczDO558Qmkuc22HZOLXVJelgC6asjzdpBcodUKo/Z1wg71jvo3pWv75NF9FCuJ5icEpHflqNQM0y0WLSshMZryi0gFtAMp8zLMAOLCCa+sfo63pOiX3w/eqk1/XTsMx+1OnIfyac6nidlOudPiaNJXLyC72sKp0tPIk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S16zt85u; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S16zt85u; arc=fail smtp.client-ip=40.107.159.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S16zt85u";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S16zt85u"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tXo9Fk1ddjnaKEHJNYWEwOt1ucK24lScFwmTCCFx24Bc9CKqVEgagBsIfn9rUTcwTynhaOCeCDpiKgFFax8NnNMf5QrUZWkJnMkPp5Xp2pDEXDdaYo1NFuulAlrWGgcN8bPZNqNTMCgHIpzXPbJBUgg3vdlLUtGTPHTyowYoE625UEekXRZA6gxL4PKJQqJc3s6xiXVipY7jfN7lmUili9t3kmsWwBVRPa+rEIHz1PuVZMJ+Zr+vm8AFcka2rv8+yF6smFuzMSgzIRJ7pbK0Pj53qHfpzllphnvihU1KREFDbwcYfL4TgGZcIc0a8J34qmGhqKgcKMWWA4QEC2gfrw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSfYrdcvYZCq6fjK/fG5DKRg2HDKNwBkeGLukGZ6Dx4=;
 b=F6Tqj+Qwb3LBO2kc03st1P9AN8bsAVk40LT1DHAfbAyAQLi2A7ti+yfBaqcWDScInCf3MA4Lrdg/cCw3RwEzjhmJYETFua6SjrS0BjBi4knF3WVHrNrgcg2wH84Qqe/ju3oh8PyTj/z2DnSK5FBwbU1AtrhcKuBukAbyrLtEpqiHfFttq1qWv6r3kE5tSjynW4wDpG5D3Tmp/Vh2WWlSAcFhSE7/FT/+zy57PDLNIOK694YwBiMnEec3ahrfJ48tNUCcj7JIwX5rNYLhg2n+NEkp9tQ+Pn8Ppg4IeBnqXghUYs0bJPe9kJ6k7fLNACnzLMpFuBVcQH5tJ7D8NUKQHQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSfYrdcvYZCq6fjK/fG5DKRg2HDKNwBkeGLukGZ6Dx4=;
 b=S16zt85uRdE+fK/9fAG/IOQCBKIO9Conm54eGMUYzAeA6VxXl7ZnCnORDxr0pRDS1RpMUQkY/5tzxf0kr/9PpFyV6sQgq+ke5xUtGZDUwzQuXNZ5K2zcB3YXTu0OiFURH0s0xLgwL1t5gO+PyoUdd78TUzZ62Jl/CdzC8tPCsdE=
Received: from DU7P251CA0006.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::7) by
 VI0PR08MB11797.eurprd08.prod.outlook.com (2603:10a6:800:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 13:25:27 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:551:cafe::bf) by DU7P251CA0006.outlook.office365.com
 (2603:10a6:10:551::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.20 via Frontend Transport; Mon,
 2 Mar 2026 13:25:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Mon, 2 Mar 2026 13:25:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XexuVWVztA+CJAK4iVco65kMZe4q5GnE0Cq1NdC5MX1hwIPtJ0WY2IfXa0yI1cQQuzTsGUnRlauhKhrhqklmvZsRsHKwAZu0plOIlymVgaDeT27RtChWNc5F2Df2bBmgO1XH8hreBiYQM4OtdvOfIvUUAHkmLMheATkFryXC7VRCGubEEQv4M2d3VIpXr9ZyHUmCgXP5Vz49b4KYTNWrvPwmcgLRMG0KU9YI8/sVhO8cShORPN3J3/5gwAlkSMCxDUT0FLmatHBQ/zshP3Mz4+Syl5J6C3XzsmZ/lX2T5ZCl242gOj3G6WsSSoaGcC1IiQzjYzF65vHOtfLc6UAc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSfYrdcvYZCq6fjK/fG5DKRg2HDKNwBkeGLukGZ6Dx4=;
 b=YzgKkokUAUSgXxG9UaddsB6pB1HVt2DzN2bLAD9vsCKUiyUHKNkQr/HrUgfqQzc0kvvZhN3mHU9FZLrBziLrO7ACxfr3+qliPnSoOYRDxA08Fyfdzxck/5FmAOu2xqjGtJ+aeCh+s+BQvYbCdy/H4/NGynrfCpBQ5HTx3wkhPjsl4TeOFsblg7Eb7lcvm0ZvTo7mOjq+aCRPNV2WFcCBxN34Z8aVujAH15hUkB7TEz39Fw/wHrJfsNt9iVClfNF7+nNNPTGd5IEvr5qCImJSJ4e9FC/MVMpnKSNpJJqakwINwffKBS5pB0zP0hmYCVtQgpAFVZNvh82Yj4g7DL1IcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSfYrdcvYZCq6fjK/fG5DKRg2HDKNwBkeGLukGZ6Dx4=;
 b=S16zt85uRdE+fK/9fAG/IOQCBKIO9Conm54eGMUYzAeA6VxXl7ZnCnORDxr0pRDS1RpMUQkY/5tzxf0kr/9PpFyV6sQgq+ke5xUtGZDUwzQuXNZ5K2zcB3YXTu0OiFURH0s0xLgwL1t5gO+PyoUdd78TUzZ62Jl/CdzC8tPCsdE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by GV2PR08MB11467.eurprd08.prod.outlook.com (2603:10a6:150:2b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 13:24:22 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 13:24:22 +0000
Message-ID: <da8a9feb-d365-4fcc-a7f4-65240aa00e30@arm.com>
Date: Mon, 2 Mar 2026 13:24:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] arm64: Add a helper setting a feature field to
 its safe value
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-3-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260302115653.1517326-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0575.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::7) To AM0PR08MB11754.eurprd08.prod.outlook.com
 (2603:10a6:20b:743::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB11754:EE_|GV2PR08MB11467:EE_|DU2PEPF00028D07:EE_|VI0PR08MB11797:EE_
X-MS-Office365-Filtering-Correlation-Id: a27ffa18-aa7b-46a1-38e1-08de785f2ab5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 Gi2aySPSbmDRhJrorfRJBK8yU6MPzvmLIGrnoB7/D7UtDxcYv7loy+DcnYGsV7ZH4s4hSNXzQJ/5Mo8stEyHLqHkwCgOY7xSDWFGT1sbDqzKUdlxPkdeCRxQW4LGGwgvt38eym812K7MbaL7LpRpMD59B0xOmfxqIfw8TOZrTuERwnyrjU/f8mi165XzXC/wTf94LWaslcDsDi+gi+KW28GIHG9JBKw/Ci+zpAoZo8Stvd3V7UOJSTGm3wWNydUFQ2zBAhQwZ7MBZWxV+aMDFFBklfKDJ8g2nH9PK4XwX3wLyviJIJMJL85hBRrGhZHU4jGCk3RlPV7UgRkI+gQtoc7NtN/HBWWiJsvpKyD1LM4y2a5z0MgartkQfD4M8eYWEFcUCWIoXgkjRdqUAy8AGqNVpMqCADm/+G2+lf/LpnTWGks7pR09nGaK+qIh68AUqQMOZt0BVFNnLuOmBNCjZNDANDKLoLsC3Y/v+P+jDcPV1i16KJ4crHIu97a60/AMPYpUGF3DIbO921Tkb943vtv5rd98ePrDzth2BVTTvVQ9FJuVhysFyR0U6+Fq5kl0phuRkLbAdBUpQEZCaYWMQVnBCsO2YuWRR5evv05czenymaDjMajJDbrkJbc1h2bNyq3ttOqeDO+0zxdLA6DBTsPjhmvtbjtGx+ck7AHcoX+PTrsxWxw78Ci5+365IUjNwUOLHl1/j3HRbrdqJc8ecIlUwic7jkn34b1uuYuHqZI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11467
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f35db181-ef7f-48a7-3257-08de785f0417
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|376014|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	/xT2xIFg8I4Sl6CAWJN6fjbsnNR2XAqwAYmIaTphVwF5ALYxkgT20DeRL/nppBJfgdVDFXBBtx4qsFhP4wTxeCjPsY4XVdG8m9ANcUR6vbbV82sPqaz67kEgMULRY4U6+c+UmpFQW9MY2+ubWbmKFGsmm+HGmKiuOERvk3+2yL6nhNp5Cs2wn8tc+N+wDfDlmE0mYiufZYbZplQMQpZo5LnL4NP09u7h0vLXVUTTuCHhxHSeP4Cm8XaM3a2fW8jkLroOtH2vM4FIHCGWwBf+4D5pT/5E5mnhqc7apRQTB0Hyk6cZi8qWsKQQn43BK32uuTzmVWmbT94KH6VJBuoqt7TyyLGGY8Q7rSnN6VnJA2PDOPzXmFAtvGOY+BIGXE80z6gWSAdWbFRun9+6+Tk/D1xLSvCsBusHzagjY+PB+y6Lm6r3JKjmhyMeVVN4DY0BhpB8mEra/QfVPVYHuR8xW+mTaazoyg3ClvL4Zl7eTqmy2O6ZEGD3bHbARX3C9ax09QrolY5yRSV95XFFdrbv40X7l2mYia5smTbHF6Aj5MU88iIQMqRhZRmbGwIwmMlb1euIbDxUVQR2MDKlhvIaLZu84PYO8KiXTorWF+IZ78ne+lRlYw7g5ERj6XsAolkJ3o1cNYpE+UaQRE/6+C6ZHncWLRqklarzZLD8xMIOaTzpk/2prUEX7HJTozwu7CwylwFlOY2a0LQV6Y8z6JV73lp5/1xIIVOb8RgPraElzZlchkO26Vcwdry8uM5uHJJUMBsgCNM0I0QM6snd3tCIetjK1TOBCTihu0RiGq3dzwUmo0JQNgZ/3554mXNZ43C3Cn6YAFFMFIp1+Ad7je+m0A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(376014)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ItjDsQjdar/QuX+W8VmTfCReeUoB7c0xhEhT2KXWMQOdUtKMciig9l0QcyTmAtfT4eCa1cgybFasRd/emTgC+FFG1y3ioXKMCFzmr6jv28c+4hyN9cEvwwv+NRMaKCpkyClBtnjx9RCghTi2YRIalOvHe+RTxQmZPFrJRI4YNUPw5KfwcVIkUDJIyFdwSJaFkgBIRfvnqC5mOSZLZUMSLXPqtXsVTfXJLv76wyejBqdLe4BeZgWt31pYpZa1Art76zxPvAK4HSkZZSYaz5y/kmB6f/0Kcchnr7D8dbzv3/JNz/0CzzbIlCwaDY0J2FYkimz55WNh1QcxTxVQaF2gxpou9rnwjZ2MyzA7rSm+3WmTnhBEAI2Ch3JZPfDtZ/qkaqtVWi3cbUorDIbMv2OxEO51v/Xx7Qvs+oHaAJO9NUAFqmsdYPFVwavwzLaRtykY
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:25:26.5866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a27ffa18-aa7b-46a1-38e1-08de785f2ab5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11797

On 02/03/2026 11:56, Marc Zyngier wrote:
> In order to make the code more readable, add a simple helper
> setting a given field to its safe value, and update the only
> user so far. More will be added later.
> 
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/kernel/cpufeature.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 28fc77443ccd3..102c5bac4d502 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -926,6 +926,11 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
>   	return reg;
>   }
>   
> +static u64 arm64_ftr_set_safe_value(const struct arm64_ftr_bits *ftrp, s64 reg)
> +{
> +	return arm64_ftr_set_value(ftrp, reg, ftrp->safe_val);
> +}
> +
>   s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
>   				s64 cur)
>   {
> @@ -1066,9 +1071,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>   		if (ftrp->visible)
>   			user_mask |= ftr_mask;
>   		else
> -			reg->user_val = arm64_ftr_set_value(ftrp,
> -							    reg->user_val,
> -							    ftrp->safe_val);
> +			reg->user_val = arm64_ftr_set_safe_value(ftrp,
> +								 reg->user_val);
>   	}
>   
>   	val &= valid_mask;

