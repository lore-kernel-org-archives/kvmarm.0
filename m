Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013021.outbound.protection.outlook.com [52.101.72.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8778E3ECBEB
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457970; cv=fail; b=YHy1TYweMTNxcM+42rkSKgDtym62zzrSUs8Xj4ewNUTskWLJ8r6/pRZSDugKQWxqNfn2elUc7Xc29d+giUEybeyDcc80hyf74eQMe3t2C81vX4iblbhAQrs5vixCbT7uI/J/81HRjj7bq6eo6jl69nZ/533wWx1ywk0wpHL8GUg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457970; c=relaxed/simple;
	bh=Zt4NGhl3qW5VC/g+W2jysRKWH0eHiO/wbrSQ2Qb5Il0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qT4Xh2SfD6viWaHwpS4ecGcXsoqmytN7YXN0xH4obguPkqkHxgzqYEYmGK2Uf3fvgKCMr7UW67pEQJgIbwnhax9E3ldBJXINcVdhqY7hpCS7mbN+nbwP7WaYgYuaEDJEUvwH2yMxVB6eKlFy2mHbPB6BRocJ7E+OMW3ySD+tX90=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G58CKLeO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G58CKLeO; arc=fail smtp.client-ip=52.101.72.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G58CKLeO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G58CKLeO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pUflKGW1huYhj/gK4C6jmhpJmSQ4OHzHjtGwZCwnUZEsaxkPKCEExievdLJZ2zOKhMtWtjxrt/o1W77NFH+yuuEOHbW1MkVOOo6FZOmMX0AV+o/a+iCOd6y/4evvSUE9IWEsjYZDoKN5UaLzRFPLgIy4ZXLXxepZGKBv+MzFSp0BACJxb278l/8tQWTSMHkDNranQ4CCJTSff59hQCW2HbmTm12UZdrPVw84zXO3aTUN1ibhtzL2TmrtFY8k3Kvx+o5Rj3ti4mWqPKfUGnCXZRbpBEwqmdq1K7+xJg24xzh7mQG76AF5uOOJuJpr9wrFnOXLnpjyCt8yH3JWLT86jA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkRh7r7ikAOWmy+7oCoQCUER1VZyurz0Wy52Qj9oGrE=;
 b=JMhz0FapnCQFYwOLMKFFfIOdGixKZxhp+B1SwXiHWZvwZw2FBmDjl5kxhqV0DrtfnxtYMsMCZn4W09eOQYvHkm8Ht1h9rMiCA3mMTqSU07CcY69Yni6/abswrYV9RJVluRLgauyLcJeSo+K9tHc3WCV3SFnEtpehWr0YvF8FHWECSU+lsaF+DY5ANk2xtnXppv1j9Kz6F8Fs+IXPIOIFIbRDbAE1FozY8Q9mgzK3u40m9D6wurSqQ7AUJYu8uzkFgLQwVfRxQyU2LMpgr8s1ANbtXFszUpZMCnXWYoHj0uDRYjrKZJrkm7CTshY7reA86uCmAGdRkMTO4fqKk/W2Eg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkRh7r7ikAOWmy+7oCoQCUER1VZyurz0Wy52Qj9oGrE=;
 b=G58CKLeO9JthR84fscH/XfZTALIPNcPTOzOw+n+5sY1KlVEMXyQvcRHvfrI0CpGYq2Y3AdOr9SniK3eNBYFsW7OrXKlFYi81j+w/M1HKUo9ebMWud2hsjv/WC8Q+02VjInXWEbtHVloD3qIalr5LHlLtqad2RSfhhHFZLogjto4=
Received: from DB8P191CA0013.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::23)
 by VI0PR08MB10447.eurprd08.prod.outlook.com (2603:10a6:800:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Mon, 2 Mar
 2026 13:25:53 +0000
Received: from DU2PEPF00028CFC.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::2c) by DB8P191CA0013.outlook.office365.com
 (2603:10a6:10:130::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.18 via Frontend Transport; Mon,
 2 Mar 2026 13:25:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFC.mail.protection.outlook.com (10.167.242.180) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Mon, 2 Mar 2026 13:25:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TU2bAfYfpWgQZN/Ue7PzHQlvqrwgHVLduL1GefBhMrt75dZfGbsxeNdIM91Mk+msBqiWohqoBk3BoNuuGIgtqlTedtrHvf/3W+9joybEoNnt0xQUuq0EZdXppKLGHuPHHI8ieXZyz1FNUYCNY9m9jWhpN9IuJtBBDXR+g5e+aXO0wvGoUiIhUalUICf3QiEfkSK25Ohl6A+getMZ+UQ43VrilGWzrlrke6j/GGSkjVew0JZvBmNF7xfcW8O6dXOCI46Anj7nn82kiya/dQSSvhusaoM3k3HM5Sk+PB02aXFCBI69HLAY/D08/5WqPH8A4YJtT/7LsgbA006BefsPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkRh7r7ikAOWmy+7oCoQCUER1VZyurz0Wy52Qj9oGrE=;
 b=ZLIvKZ4ma/KakDUxjfxm/jVTdMSR2e38YG4JtxJcDf4JKlDCxRM6xtteMQJrJ1+t4TvxVtaG9/i5Q6Z7PAH6qbBMfu4ODELWIDFAE4aHBq0U9LKHL2PBrhvwliH8r2a7X9HeJFhIgqUVEGYaarRPzMSxMfZ9LSrpf9GBJ+52v+pb6We9zCXEL0umnjVpkW8OHqd+duTBG/xgU9prp7TbY9Ja48YmQCXPGgDLHqj3a45wqvfYTHxC24sRVK9ivxBMptgJUi/j2C2pyqmYkpVzRbyT3+7azEXw8byqLrHniwKxAJqSNMZsfFV2QXL3At6Shx0NvYwvNM8uIX2QkQHsaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkRh7r7ikAOWmy+7oCoQCUER1VZyurz0Wy52Qj9oGrE=;
 b=G58CKLeO9JthR84fscH/XfZTALIPNcPTOzOw+n+5sY1KlVEMXyQvcRHvfrI0CpGYq2Y3AdOr9SniK3eNBYFsW7OrXKlFYi81j+w/M1HKUo9ebMWud2hsjv/WC8Q+02VjInXWEbtHVloD3qIalr5LHlLtqad2RSfhhHFZLogjto4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 13:24:50 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 13:24:49 +0000
Message-ID: <22e4b4eb-8f9a-459e-a811-015b7f217a93@arm.com>
Date: Mon, 2 Mar 2026 13:24:49 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected by
 an override
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-2-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260302115653.1517326-2-maz@kernel.org>
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
	AM0PR08MB11754:EE_|DB9PR08MB6729:EE_|DU2PEPF00028CFC:EE_|VI0PR08MB10447:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be4771d-2eb7-455a-d55a-08de785f3a51
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 eofWvUGV7L47LfU+0LpG4gfKCzSCnEz0lzLfrgZKymSm8iQQAFvQr4Rb+8/qwhyhLRBA+2eQqT7DQYu49Te8vEtR9LOzvj+yfYiPL3fee+751pfarGUnyhL52gGJAnvBTE+E9FjXa2MNONmg2PiiDiGC/gDz0ErReQSCeSAGA0LRzGbR88O8M+T3Ym6hEbpQINeK4YZIPNWTeT5xLDDbgv6AHIsNjrh3YCyYgAb82FuAEtG7UzY2CEjb5na71jQ52lcN1T/doqz3Dk7okEd2UkL9FENv7CLlcak2Cqcw0R/p2HeaFwuj2N15QXzq/pMKV/t3MhstbHdXAXccy12eHNy2xNwHJRzu4BMPIwBacD2yS8tTl68pPAEpc8PsQqm2DEYIxxi8kjtvgEOMZL+2z/PUJUyMOcfCyj98KgiLvRYend+jSy7RlipUvOdXUngx+S/v3x4D2bvC+jYVq+P91BRsVItu7KXtkmt4IMlaeU7cqgGIuaQVJhuN058BuuuzfXJTJrmt9271zC7Xj0RHakrCWqRneVO8dtEfXAVsQ1v6vcEVEHPbYbjklLgzZbRtA4qLXxbTQ3bR2B+T+tr39md588G1etbf4wZ4N0vIqOzcnETd/LOvzNar8wWkm1shx+jI1TKHNyfGSa8GeG+2M//Elmi9baLmnHVOWidHkRqLKvuuEp+onWNQK1nAmQHqgvwkvNTRtxT8gEvypzlwXXzJO3sXZOQdYweVsboXC9c=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7bd66df7-3356-414b-313f-08de785f14b1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|35042699022|82310400026|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	3hONZBNmj+6vLyKLyP9BOMKXqtzMHo6OoUD/ljxAGzSKvVrYSWwh/49fZXYXC1rgCW+TH4w0wO1LdNu8iiLwAbcka7BgL5Cq6kBAVmAyVqd04wpx7wQaumTuigruJ9QE097VIB4iSuIOEfkiG/b7zlPA2ezRFFqygj2/0J4VtZWtvM1pTryZe/nF9ypv/d4ab3np2DCA8y7m8epCs/XZ2CMi+fhTetS7PvhCsCrFSKTvE7B6DSwk8zMvPwyEKuAAB4/mOZdlsTlk5QEk98UzyW1epLwBLFtPnUaom/IecDA7mZcXv2iwzo0LYziIL9A+F5kiYKe1JgB9KY/pnKnNCGubIBXBT/oL8pvlrCQpFW+zJz2pI0D6Q8IszlMC0Z/41PEqSqVs88a4oAHEWf0BX2pnMMRY0IXFbq7HhNtjoyz8xzI2KR4fTOtjNw6SkZnDKOxi5Xhuo7v8O8nQFvg9PtyOsE+6OqqF+R13x6xj+k0ZVWXL7DwBo4nMzzBK8sFRrHLuoaYfCupnZaC5FRdzhSKhQq47wYrjRcX0l/bsukvjxyjZfUDra0IQyMWvxnJJYlUkE7pXWjkSThp+ja/+B8vtBMuJUtgASBXFbbamSVZ/ZzpbbRc0m0kLytNMtnIVt9GL1uGhxR4Y41Ld1qSNUuKMzcKfGEVRHcCm47AU2TBaz6k2OYoE7JGztnq4XTOODFLd8AvLFuu3gzAVWQf5Qb0SC9kLY8cvT7pZLCHZUuHsDo08KZB97yaY9ip3kSFCAuI1H/c9+jrWE+AQjYilGl78Tl+G7xNJBXvLRKfrAIOeTHVq15SFjnQT5XhA2aeSIbIXcMinXTnKHv7lDahL7w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(35042699022)(82310400026)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jn1/xgoy7jhEkVQWRy/GXBHIP/yT34Cg/rzmQaKjZ+1qzhczaT2nTfzZ70HOpwceYs8v0pnoVhxC3e/pTf2P6kH063eVcAjG5Ql342UqW+1J/xLkKe3RqXTliBeB7MWoK583CcYlwHXC+Iun3/3554Kq3rzsf/CGMHHCpG3yB8YmKubXM1Je1xtczwrcTlk9WINjLRtVcQh8FUps8zKLE7AknOn+8NI8NUp1FKi5K6HBbRbrXogsGXLBWSS03reAqTDoEMCBiEsxHvl4+VdlCkMPo2XijdWgjvwrV500oTxkvQ0vssE8Bh6QxNoZQ37aZ6GwgqGeeCPGZuYY8MrjbxiE0hipxiKn5slj8+Zvg4sOEkk8la1uFN6ldqefWCSo4zY+yN/k38aaCRg4V72WCSNYxVsS87kl1S/2MEvSBnFNvvdcEd9w+D/UTutENuOG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:25:52.7875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be4771d-2eb7-455a-d55a-08de785f3a51
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10447

On 02/03/2026 11:56, Marc Zyngier wrote:
> When computing the new value od an idreg that contains a field
> affected by an override, do not update that particular field.
> 
> The value computed at init-time must be kept as-is, as that's
> what the user has asked for, for better or worse.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a3..28fc77443ccd3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>   		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
>   		s64 ftr_new = arm64_ftr_value(ftrp, new);
>   
> +		/*
> +		 * Don't alter the initial value that has been forced
> +		 * by an override.
> +		 */
> +		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> +			continue;
> +

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



>   		if (ftr_cur == ftr_new)
>   			continue;
>   		/* Find a safe value */

