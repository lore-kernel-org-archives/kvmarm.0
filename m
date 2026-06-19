Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A1038330E
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887046; cv=fail; b=L5jnqZpuhaH5nTmnCCYdY2l2fmEeaq/5HIQ+Whhz85cc388mwY70JQaxqTt7pajVoIxOiGB7WJTWehGa5YasajSOR/yux19xfLeno8Ig3Fnlj3qE4eSqUW3C/uQp+P2vUvXQulAyh4DDN0YDh/sQuxXMU0/iH8dYUm33sEMAbiU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887046; c=relaxed/simple;
	bh=i1ZvNVTFeTo55ldtE9PjL9l7EUHqjJF3aXHcgYmY9W0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pdl/Gg29BK0VbilwJ38zKBn5nfGxpPNZctoLDGb0lIxNhAkGvT0KYCy6Js/Hsizmm6NQiLi5YTYSZDAUcHq7Ze2Ga+23nuY1rFUCewHax758brwKbbl7BhcdtHzAUIaAhqsY+8rZ6AoyMqJNC2VSu98++KkrdZTiE2dor5IWPVU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CnDkdsfR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CnDkdsfR; arc=fail smtp.client-ip=52.101.84.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CnDkdsfR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CnDkdsfR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Dt6rqzFKKlh91FSCLC+iK9EwS2vhI46a7V1kPkiS6FHTe8ObMmFAnEvVXZLem6UMMTqiINiM4D4y5agLewNKnSATc5lA2qlEFXh56NCfRyCW3urprxZee/L4NCFUZGQzsno8aNp7952oLvRRPbZL10o0bbA1tzhGIYeFjFC5P0+OwefF74GLdr+XxiVA/YRA50fO+9m8IlbBoz58Gh6+410nqRyBE0Y2fePMD5BQk4iJczCgRnRnbSicjjwFP4u2y0KJ20d6xnF8DX3FGC5PjjO64kk9HnPE8UzGllBcYS83IOvTQ/7wMC3hs/YTgk4Nn3yHsSqtVKDVCWVL5osS2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TkRaFhyDU4F6AekNecB/3AwvVr5H8tmS/Mzio3sYfY=;
 b=QmhKITKcKsZeX29n9gWaMUNB8e8LKPz9jgpcaRaJ8o5uO/q7rTkORl7H/pyLGYXaXDY51pmCB7wAd/TxOwnrOsLAz4GuL2ZCjwHwPWTX8sCDOJPQSr9fk/JtUY593boiM7yRh5xw1wE6VazNRh1b5ajH3w0qXjRn1X8mVnAhGzDTYHzMGZBrwkVMCv69ri2vzejuKrmhyRZjv5P2DuYZW3r3GOGLFDIwIK3SeJbBeMJUISfXjivh5bxkNgbNZ5SfaQo4uV+bEsMwFXA60xU98XO6YHxztHFFVdieuLB21NBLHCmI8dtoP18a37NMSFFoQ5N4L+Z2axA2JE/6r+tWmw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TkRaFhyDU4F6AekNecB/3AwvVr5H8tmS/Mzio3sYfY=;
 b=CnDkdsfRj/XkQcHy7qEGCCH6AkB2sgCBbP1kTdZl78Q0cDEIq8unOotr4ZlLRugZp9YYmdVI3fiYp99eOx4xMmj8rXrhuz6oeROIul7f5dT3O4s0t+RirIWCARzQ8xa1uGbpCV45lHnU1djaRxquuGotVHDcsFidOpAzNEfRbsc=
Received: from DUZPR01CA0091.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::26) by AS8PR08MB8222.eurprd08.prod.outlook.com
 (2603:10a6:20b:52a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 16:37:19 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::ae) by DUZPR01CA0091.outlook.office365.com
 (2603:10a6:10:4bb::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.14 via Frontend Transport; Fri,
 19 Jun 2026 16:37:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.8
 via Frontend Transport; Fri, 19 Jun 2026 16:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNLCWLmV8Pa9UG14vrApbL8CQ8+7kJe0F8jE1oGoTEgR2g+0MGlowKBzOHXbolhZAuaKBHEL18y2BEO7oxHATguinKZ4+5VUqHeK2p1G4YxYC+MAvnpEjB3H6hh4EgSbECh/3EeesWUYfJ3zw0BqO9BNZN+OSp6tnOQ2KB1I5rVpXbeS/zJkp2XHxatHKcf9vw7eNuCzRkDJI45X4dtSHzaAGnkjFU6kQQw6znDQBgH+Noc82Fa93oGv51/+Bk4+C0Knn+5JX44pMZA48geRq0y7yyiDCP97ant4utO3iIsY+P709212BKpXxS9aYUeJOJZkBdVQU6tL0LOTRgf30w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TkRaFhyDU4F6AekNecB/3AwvVr5H8tmS/Mzio3sYfY=;
 b=CyZHnTbI9Y8DtVi1ZOcw9Hf4RKyrNh3ueY8+jKFBF13LZhEMFeeQFG8Pz0OyMGKHehIcg2ot2ddp5+2uwly3Kilgrig+3W4zOsaZxos0ffSgfmGTXqMYHRnvFVWn4fI0ew22p6NHlsLP1ItNcAIU5frzf+yCVsLahweCg9Ch4txEhGWZih9kmfPzggxEWtWhVhdmP0cypbzuwap7IwLrU0/n/GRoDrOcBBDlulpHlzLr7mHS9LiICcm8aX1s5sKwKr0xczXWkJi4GrBuiKgNuVbb/HP94pkKd8meZJ5v9Vp2GeL8FOJSjXRDhedpHtiibHpxSMC2iCQFnTDYgwlmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TkRaFhyDU4F6AekNecB/3AwvVr5H8tmS/Mzio3sYfY=;
 b=CnDkdsfRj/XkQcHy7qEGCCH6AkB2sgCBbP1kTdZl78Q0cDEIq8unOotr4ZlLRugZp9YYmdVI3fiYp99eOx4xMmj8rXrhuz6oeROIul7f5dT3O4s0t+RirIWCARzQ8xa1uGbpCV45lHnU1djaRxquuGotVHDcsFidOpAzNEfRbsc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS2PR08MB9974.eurprd08.prod.outlook.com (2603:10a6:20b:643::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 16:36:14 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 16:36:14 +0000
Message-ID: <fe83422c-12e2-40ac-aa9e-26e97e6d2d31@arm.com>
Date: Fri, 19 Jun 2026 17:36:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 3/4] virtio: Add helper for enabling
 VIRTIO_F_ACCESS_PLATFORM
To: Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20260619115415.5475-1-will@kernel.org>
 <20260619115415.5475-4-will@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260619115415.5475-4-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::17) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS2PR08MB9974:EE_|DB1PEPF000509E5:EE_|AS8PR08MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: ee5b95de-7e42-4de5-33c2-08dece210693
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|4143699003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 0JjoMQlUePCtQ4BsxqphIxb/h70qc3DGhJFdNWPMXsfJTNAE/xjpSX1e9k0MhnbbbcFoNz3T5zAeToO8kJkHpr7QeEKTa1xrdjFH2rqIM2N4UMrdr1/o/hi+0V8d16sQSQn4HwrHXPd+71dRgQ0CVkmesOCQvB5Mo+T8gljZZ9uOHL5up6rtmRo2RWneK2I8SskRg1Yku9LmOO9kFs1e9CUHEhe8s+2SUnm1QJTnNa969ZCoPuxvJQHfSdM9xoZKNeTOTaDG8MBsWMTvzSDfS5sw2Cdj9VpapOBvhB34BmpLMtNFRg59Pw3wmzPQ0itprRSjojD/10IBbTEz/AmEb+ZXhl/AejdTnIudhOqNyO0qgfY+1vFuQBm270CF0AJdVCCmMQYgWLRG2BDYGnaeu2UGRKvFTWcqXjZPGUWWpRZRZDRe+EaCjWje+tkwTzz88xurxRN/Cm7OlA4QGKdVu1BFdlQTlN5Wj9JsNrEMjy2SMF8T8xOqZLOL7CIjnqu8UR36JUasoT/GSTmcfCgDc283qyliV7MR2HAAUdXyWkghKIAlkZLumltZwKHrKno8hv6Lcv2eqhEGQsCKGcrS5vIO47/D8mNjmFlLOqcphZMpowz2YmSUmDsD+3ER1DIxQIxgvdrpsRbusoan1ny8rli7+dOnCWkWubK4X4dhOEk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(4143699003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 fwFT6+ACtGeUDgNhZ4D/4SRthRVsQUCDZSqDu4CkOg5fz9YHKDnhXPwS9AwViFD6CaT789xnYCr/tcLGJ87UWu8CtYZlaVoco0XNM/AV4ihhulpFV7bGiD7VuXorZGSNQggzXs8CsBtV+or408PliOXkNP3tynCZ7pUaN4okBvZpdQmPS91QgEpYJSGIygKO8t4PxkjQZYNVEl/SXz4WpzKsznrcFPMmY3a8xVCP0urk4IeT3+YWWpg4MfI+6HIWlJB0CjV3F7qHLbF5tcohhICANfP52BsOjwRzYuqsvfnuRZMkBOAlrApQleEKGH/KFRytu47iu9RUfufMcEwU0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a346d13b-9d60-48f8-cf29-08dece20e144
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|82310400026|36860700016|35042699022|376014|1800799024|56012099006|6133799003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HemW3XPSTm/nJQqJa00TAmcF/nCF1onjmR8l38tPc9kPxvdRmT6ydl2XCqVx+hi8frqTOIRJnyKJwi6SXiTMpcPd/1q2a0FLhc87e45Zq2TaUFGn82gdDrgSERvO4txC9xoeiA5LRSkEO6fPPHg7ozRluHrQ1Yc1/XXwSqOZRwhrvQ5vG+3NwlaZvFbDzPg4vLamGc+SHa4q8hb7CxeJyC8QhdkzGf0QqK6c8tWYuxBkMyJkXRGwTi7cNZSyqqq0ynpbnR8MX7SYdHxvE4dCfTD29ntNnNfXCO7kvPmPffimRXOBQQ8HX3UYvAt+iRt3XIq8daJOvNpK876mSE799BmNAK5UshfCBHpjExyGSomWYY2GNjF/GbnyL6ngtcXOep9mZOt6gICOT8jYQxJlNDxsjlael3v5hCpCQYSZ3K1Fff5xAph5TmALfcAwGkngDpvZkJUZXNEN8Sejgy0zpiJyGxQF1Nd+C1lUzPIR5qyfTXJtjLeaWQk8UV1cOmNNjnnvK5RoUKckKJq9dgUAjLUz+LPOKfMyYHnQA2KPeQnHTg/HzRU7Y+pi4Stu5z6UOvXWKjGGz10Ji7/Mb7liPFqy3Z5ubRUSFRRqRyTLCUeaXSBLtGu0Gz3YFB6tLov6icmzKvODXlUrXmThqNWbySupiw+nMqm7YlDRlQ7m1vn/mCv6DSUOOobEmbf5I6BhC9bsVhbOXeZTa529yccj2w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(82310400026)(36860700016)(35042699022)(376014)(1800799024)(56012099006)(6133799003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DoRPLaNpOvqDGiSIXer4DAGuWSkuImtHxUkQxfavOoVcf+bKAyqQjygMEEQqOQRT+Nf5dkYbQ+XX1cv7L8SCkHo6DeiDKr70bIFy53+cIVvb2B/4ZiCDdYpNJdbc9f6rC9mgVa8wdGh6yJ/crgTMTG/Dhn5zAlxzKQAnf69WFxtuFqN7t8Fkvm9k4GGJaHhL52ZSpuBAMM/qvjVayJb8KHdTJMbgUiOm0JvB2JotXTaAbdLuKuI5xW75SHez1FCMtMqlR56jKkeqisnumGJuE8DuaWEtDeruYOmnF2qKFOXLRsBcpj9vvh3n1KVbca6ksr9MoPVap/Kf/ffUqb3Qy07kInsEiww9GWVSgop47p2vbXYaiaxVx3S5LsBGxX4qAArftIfkZgHRA+hmWexKrWmFOcgLMllDpc+LqUAabqPLXR326PeSTuk5Pb/+ENRv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 16:37:17.1715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5b95de-7e42-4de5-33c2-08dece210693
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8222

On 19/06/2026 12:54, Will Deacon wrote:
> In preparation for supporting protected guests on arm64, introduce a
> virtio helper to advertise the VIRTIO_F_ACCESS_PLATFORM feature for the
> modern transport.
>
> Signed-off-by: Will Deacon <will@kernel.org>

This works fine for us with CCA. Thanks for this.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   include/kvm/virtio.h | 1 +
>   virtio/core.c        | 5 +++++
>   2 files changed, 6 insertions(+)
>
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index c95183b..dd3117b 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -277,6 +277,7 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vh=
ost_fd, u32 index,
>   int virtio_vhost_set_features(int vhost_fd, u64 features);
>
>   int virtio_transport_parser(const struct option *opt, const char *arg, =
int unset);
> +void virtio_modern_enable_feat_access_platform(void);
>   u64 virtio_get_modern_transport_features(void);
>
>   #endif /* KVM__VIRTIO_H */
> diff --git a/virtio/core.c b/virtio/core.c
> index 8c5086d..96bbf96 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -355,6 +355,11 @@ bool virtio_access_config(struct kvm *kvm, struct vi=
rtio_device *vdev,
>
>   static u64 virtio_modern_transport_features =3D 1ULL << VIRTIO_F_VERSIO=
N_1;
>
> +void virtio_modern_enable_feat_access_platform(void)
> +{
> +     virtio_modern_transport_features |=3D 1ULL << VIRTIO_F_ACCESS_PLATF=
ORM;
> +}
> +
>   u64 virtio_get_modern_transport_features(void)
>   {
>       return virtio_modern_transport_features;

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
