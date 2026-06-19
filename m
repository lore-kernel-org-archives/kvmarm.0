Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011071.outbound.protection.outlook.com [52.101.65.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051A1396579
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887007; cv=fail; b=kjepgc9/XsomIrpRFdrJQ7xBsdlfLG39fH2ZhovIMeHztBh8KEJL2VQhzarfsJUJ5LwTznf/QklnK+tD7TQ0DD38Qn5rkA6u/tGH5qbAmQKxcyfuMgruItHqFUgGi3yBswheTLVDubhkGhHlNWwKtWZDEmINGBVe1SdMlPjWKd0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887007; c=relaxed/simple;
	bh=Em8JeD1EzAp2t8xCxxgO9QjV+wjBXOyaHqThlxJa164=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YBp/pJpBwzb3PbLdqFmxFY9b3/niVsBgEjNsdRsDbT+fEz3czZwtm9lUs1TQUwsVX0glV8ylPSkkFUwBsz6WZD11O9QboNKD0DS186/psdXjf1gXJ9Pk9lFn2zfWGBWTfbqizXWOhjTdWb7odOdGfsEC7M6iWs5a7SwCSsRPe9Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i7IWK/uE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i7IWK/uE; arc=fail smtp.client-ip=52.101.65.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i7IWK/uE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i7IWK/uE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Cf2Lo7Co0ayZtecoeHgzfaaxoY60nteu9txFh010LRhob6B0+sQX6AzcUM4N3vrE4k+CqWDUxw9L2mMvcjLe/fPhRtAoTzn1Aby8B69dS3srmEsVe7MXZMsVn+659TbXjjyw2g74r7ineaFgAXugYuDSplW9qi98o5yTR0CAAxqt8zyMwt6iVzfRe1Daly7i5YddsbomXF2GEQwUt7vN1tJOkBJ1ChRCvYuUQkn49ez0QcZl+FT54D+Ia63pNg2yM3Z5Q+4l7J23SUSeCRs0oJHml3uJX39QObseuvIX8OOgK0Wr0P2yzJR652IdVsENbHxbUtHYlRusS/PtvDHMLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZESoCrh3bO5Knl0qMC5JeXzVkUKAAVk3pYAqL+jHmA=;
 b=cI5YFc5GFi09WTm2Gsxh5mlwbltXFZm9DeYZgpCUHO4/6ztbkI6CL4B8/wKwM8i7azjN+en7ol+e7EQ1c1GrwFXzBQzL/sn8Qc0XdL3fPd4xFPDXTQqhrQnmzNIoUPcmcqjpfUCsfgAf6ibc5KI7V0L7wofASYkhguzlBEp4dm6brn7QZNriJo0TQesy3wrktIZM5Q5EvGcQu2e69eS7C5ZKF530cBem+n4deo7bTW0I0inwrCiEwaiOZL7/NlYaIrRUrw8wRYlh2/Xip7NGwC5A1LyZIcfm55xu4QLFh+4J9zzQM8l039fIRnwYHYircNoB87gWmsO+VQA+uFTpbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZESoCrh3bO5Knl0qMC5JeXzVkUKAAVk3pYAqL+jHmA=;
 b=i7IWK/uEgd4mretM+UJR9uVyu7SY1YMK1TJIQ7vxnXbDduAn0a3Aq+na2ASui9cL4wnSAv9VYJosAP9r1+NO1StgwYl7tB7Tjl/Tonn8LyqTJ8xVpJsy9JmZa63zKB7XfZGxu3F5SCqSlVvF0wwKefPg756kOOQ3Tely80gKlS8=
Received: from CWLP265CA0460.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d4::20)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 16:36:38 +0000
Received: from AM3PEPF00009B9F.eurprd04.prod.outlook.com
 (2603:10a6:400:1d4:cafe::f) by CWLP265CA0460.outlook.office365.com
 (2603:10a6:400:1d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.14 via Frontend Transport; Fri,
 19 Jun 2026 16:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9F.mail.protection.outlook.com (10.167.16.24) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.8
 via Frontend Transport; Fri, 19 Jun 2026 16:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xg2xdJiWq0ody8leewrwMkhGmXnuJj7gzc8f72B2ApF/4+biZRgUQDvVMAeCE3Djki5ROxB6ISSPYkr5GD29f5WqSp7LLTJdnBdJaBoarcQ9bScmnawR6vRLbepNETyitb/38pKxzme9A77mYadYAGyGJBQDHfHVYxpg2W9eQ2pVhFQJ3sle3ZvPzom7vbp82pGzSypzYUeOhTNvdk9abaKfOKJyZ1VDCYzhOLyBB6Bo9IgDhjar9TxlG8dppkogM768Aw5FhZtksJbWtx59IAjG2Jedf6x1bZQElT6vHLRnARUsbc38+ncBa/LlrNaaDjZn6uAKfBitqVmI1V5FrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZESoCrh3bO5Knl0qMC5JeXzVkUKAAVk3pYAqL+jHmA=;
 b=uPPZkCvNcuXNTHZziIvs6SFqXldu53YgxDGoVDSKZ4i+gvaw9P7d289Vdc642EU8I2h5K3L7/P2bH+SdELA2z5TkXgYQ+6IC/C45KNv77KzbH3zanHjH7/edmRtmnofknNfWn75GFCdvhNKUasNS3DMSRq/wk2vRBnqSIw8RmnchVdoO5U2leWRDxRX0DYPxae8CfoktAcckQfKwWZaoQniv+LM9MH3JPohT2t96lMG2ptv2+K0h96isymevavnPUNAeuiZz2yX05IFGEEQDNIwU8DFt8yjQppBo9eeCBstP8J9NEMJqTjg9Re0uEsL1Qn8qRvA2T1nWozlNHIcwHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZESoCrh3bO5Knl0qMC5JeXzVkUKAAVk3pYAqL+jHmA=;
 b=i7IWK/uEgd4mretM+UJR9uVyu7SY1YMK1TJIQ7vxnXbDduAn0a3Aq+na2ASui9cL4wnSAv9VYJosAP9r1+NO1StgwYl7tB7Tjl/Tonn8LyqTJ8xVpJsy9JmZa63zKB7XfZGxu3F5SCqSlVvF0wwKefPg756kOOQ3Tely80gKlS8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS2PR08MB9974.eurprd08.prod.outlook.com (2603:10a6:20b:643::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 16:35:34 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 16:35:34 +0000
Message-ID: <9f2280f4-8b34-4ce5-b23a-49ed832992d9@arm.com>
Date: Fri, 19 Jun 2026 17:35:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 2/4] virtio: Factor out base features for modern
 virtio transports
To: Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20260619115415.5475-1-will@kernel.org>
 <20260619115415.5475-3-will@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260619115415.5475-3-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::20) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS2PR08MB9974:EE_|AM3PEPF00009B9F:EE_|PA6PR08MB10565:EE_
X-MS-Office365-Filtering-Correlation-Id: b86bfc39-977b-4070-6bbb-08dece20eed9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|4143699003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 /Kfzd0iuTn5NX26jOM8Dvk4Q+yDMB0hBdlo8PmsqV7sdLLA7b5s4ULrbGiyZ72Ut6TcXyHxo5DaLr6fsHru+gvscf5x8d1ovXl259eoDxMCO/9UNWlruBSm+fiOsIsvc4EiX5i7fz7yHtyuhQD6pmoMYF1TTFYfLdo6+XENzIP5LPTs5AY6lq79qKP4HSYjKqtWnaAG3uMyiLv0llqCM6HXDGsu8842SrvLw9J2/takVnHz/QGfIT6lfTby/c9fuaGWB/NkvhjQxLL/CKP52bq1jYw5NRfXoAxPmjWA/e50LemRONjSkgb6ebyQQ2Gr2uPxQFZMfpC1vGnSW1nhatlPpCpvt5bsYPWa9D0XZ3wX5gLEMj6l/VbqLS2gDJ6KHyHlcBZSF0g54bc9pUNvC3s4AnPd+Wf5t5gy8KeRHmZSpoVPzM5B1ZdWUxUBvIgumkzj/ejdXXXXW0JMMkRYF7h60MruGre9KlPDd4QOmOnT5wmJbt1rQHLfPw9SB65EY/mzD/bW48mjbKaVjDn9pkFUlmBetomieCsN0g83+mn++sVZNUQgFoXPSe0EKiA25h5itDNNTKtlWRltKxaAwlRN0EK0TlYGU4iUOr8hOwE2UO/Wvgin+tD4DMp/nUFafBMHphX5lNTIoCNlNaBq6BaAnWGIx38urTtXTNjqL8QQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(4143699003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 TD/a8UqHrX1m55H4niWzov+rdPQMl5fisslkcUgDhEtkZeZxLXliAXWLNW0r0AY0urrV2Rv+H5QYu+FLQrJJ1DnO+DtKtNvct9IAME0W1+SrJC3mSQGu1hxggWzY752toMQwX1s6BreDHZcl8RtDRJ5xhs8cVjjcZvLshOUqP/++omOt4BU4avIuZPhAtGT8VokHpchaMHpoPoUniZDB82pPU1c4FFNzxTL3lP8BY+vvGrb/2oxieIu6/KiuCOxAk/Z+g5j2JCmYvfE0uD5EYLlW9XuJjFVvhBKETyYjmlLXXmbf3WHg8T2Thlli9Is9k0DXrOY7qdR/+hoaZwExUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1f168ec5-60e0-4665-3a08-08dece20c925
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|36860700016|376014|14060799003|82310400026|1800799024|56012099006|4143699003|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xYsUTLOxBXAG84r27EsaOYJ3ctOQV57H4SS/o5vVbNZ0TewYRopOp4kywfP6QRiX/EL89iy9d19+QVKPBfdwgfP2dQHhoNGEFd7zp6pPeCM5x6hVSefS5zmjh2D7vyNxM8sZKhlc1YtfTj4cevKq+awYXX7NQlJIo58cIZro2pBXYhXGuePdMlyXodGxnSZDeg8ZXyew3/ZoVVZ4g+6Pzw3L2ekHpEOwFxIv3Y5h9JGjC1fhY9lD0CgAIpb5Q32u2MaK9ZzllmbJPko+Nequ57P92cn82YeQhiew3HiE2rEMu9JBI7xUTGhSToo8vIj08z/WFYNzsfpihTaW1yeOlWGI4mB6pW1D7GdTsodGrSQ3vSPnyYWg+sgfNw5IjN1NtiGvhvOyhmui38s+5kxcj82aPpdeGhE+S3guxc83Edt1akyoE0piD04fZ0/FPZBXFQIzXZd9XpzMko08VwJvFY1+Q61Tt5bWBfcjI/MBMrR3bSXLkXHu2ibMxS48kmK/xgLy9vDCjsImLnBwUm0q2J5dbFrrvKil8eXy/ySkkHA2DY5ijvbGzt7q4Cma7j5pK5hcPkMoF5jDIknbSsHXEtYrvxMtCJmei24VVqkZhfMvc8lfVngZuKtLs6/sWsD4cMs811aMPNWt2DLGr6UBA2W4TFHopKdj1EFJun2tNiFckU/x/8FGkjCKG8LCSdNWjHzZpULaojf87wLLgmJ2cg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(36860700016)(376014)(14060799003)(82310400026)(1800799024)(56012099006)(4143699003)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GGj6LVlR7bW7kwo3Frv9WNBHwkLRC8igbgCJnOpjsEK5EbBVDmdECN1oTxkZRII05tyaUmaRSVaM9jJLXDW1rrrwj1zOtrsK3DQ8PIgBiETz3v31foTBxdW1FzIdY1z0ZeuHnZtaJOPM2rf2d7JEJox6vC066wEYxyX4eJ4mB4vdZhMPK1s2yFK0blHCjqrjCvcx42x+HWMM+chlnzrGiLFIWutR1E21c6oL485oD2NUFR1bQLyLpqzpf2QvfDXGYjxRJyqAt0JleIMWsbeRjjbVdE0b1euzBateAHSASsBNfWq2y0Ay6klgtj/G1cSw2OJ6dnD/99bAW21EqbjmcM4tiqR/82FExizv6l8zUCJkm2hImUpU8lU16wOhW5ZjpO+vA5iC0VrgA4g5eT4qCiw6Uzv9Ul0zZ9xXkquX+nlBxTpM0xQx+48xCUN6rJ7s
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 16:36:37.3709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b86bfc39-977b-4070-6bbb-08dece20eed9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565

On 19/06/2026 12:54, Will Deacon wrote:
> In preparation for optionally enabling VIRTIO_F_ACCESS_PLATFORM,
> factor out the base features for modern virtio transports.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   include/kvm/virtio.h | 1 +
>   virtio/core.c        | 7 +++++++
>   virtio/mmio-modern.c | 2 +-
>   virtio/pci-modern.c  | 2 +-
>   4 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 8b7ec1b..c95183b 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -277,5 +277,6 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vh=
ost_fd, u32 index,
>   int virtio_vhost_set_features(int vhost_fd, u64 features);
>
>   int virtio_transport_parser(const struct option *opt, const char *arg, =
int unset);
> +u64 virtio_get_modern_transport_features(void);
>
>   #endif /* KVM__VIRTIO_H */
> diff --git a/virtio/core.c b/virtio/core.c
> index 50c9ddd..8c5086d 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -353,6 +353,13 @@ bool virtio_access_config(struct kvm *kvm, struct vi=
rtio_device *vdev,
>       return true;
>   }
>
> +static u64 virtio_modern_transport_features =3D 1ULL << VIRTIO_F_VERSION=
_1;
> +
> +u64 virtio_get_modern_transport_features(void)
> +{
> +     return virtio_modern_transport_features;
> +}
> +
>   int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>               struct virtio_ops *ops, enum virtio_trans trans,
>               int device_id, int subsys_id, int class)
> diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
> index 6c0bb38..7787508 100644
> --- a/virtio/mmio-modern.c
> +++ b/virtio/mmio-modern.c
> @@ -11,7 +11,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>                                 struct virtio_device *vdev)
>   {
>       struct virtio_mmio *vmmio =3D vdev->virtio;
> -     u64 features =3D 1ULL << VIRTIO_F_VERSION_1;
> +     u64 features =3D virtio_get_modern_transport_features();
>       u32 val =3D 0;
>
>       switch (addr) {
> diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
> index ef2f3e2..888afa5 100644
> --- a/virtio/pci-modern.c
> +++ b/virtio/pci-modern.c
> @@ -148,7 +148,7 @@ static bool virtio_pci__common_read(struct virtio_dev=
ice *vdev,
>   {
>       u32 val;
>       struct virtio_pci *vpci =3D vdev->virtio;
> -     u64 features =3D 1ULL << VIRTIO_F_VERSION_1;
> +     u64 features =3D virtio_get_modern_transport_features();
>
>       switch (offset - VPCI_CFG_COMMON_START) {
>       case VIRTIO_PCI_COMMON_DFSELECT:

Rev
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
