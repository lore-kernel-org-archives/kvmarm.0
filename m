Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011069.outbound.protection.outlook.com [40.107.130.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A261E282F02
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413839; cv=fail; b=PCedXJO7jR3XWEpr5mFSO1LkpcyvlpRZo9Ma0usUgDFC/lFcuGApuWhRZ/FFizOqhTI8txdPyhj7fq2n3Rm6Xryb6kcQ6LKsbsbY2GVEppCymu+rkf+LiEhA9cMgGdxDbhfMVDdGOH3clBefcaNQy+YimeXy50c5EvdDaWmw2cI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413839; c=relaxed/simple;
	bh=Ko3pvx2A+x177WlyEn7IHNs46dZIMPM2TdS7O+yBeyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZpEHebK5NQep3BjbBhkwtocHrJ1lHsbM0aQPTbSWxKFsdjoO2w1ggolvO9bcJMP0SznbG1QTHm8mlTaNmQY+24bpQkD7yJaEPlo/uHKR+1udmOo6ptSN9HX8faqsEmCPtUWIwyuq147dV3ujRbccfVyurh9JmXzXxcKPoU1EJS4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SVpfGtvn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SVpfGtvn; arc=fail smtp.client-ip=40.107.130.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SVpfGtvn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SVpfGtvn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d7q3GoA4p/VhjbD1M5d7w18vJURTH4vaPE8w6WYy3PN9S9FSTHPcuBTKgzx3DlPZV5sBeYwlZIIO+/K8UiBKasvPU+BRlRe6ypTeMg2iPRPau39GotuDP6+wUegJ0TOzNUZJkXhFebpvoCxPelKdbMFQVhiTa79rla0Efh8UBUmYL3cWXZBxlQB2u+CcBVITeoTkozzTrv1iZj4OWrOoYO03IclTIkd3ut+vdnK/opQS+QLTNrCRI+1+H4oN2amY8UZAkumxuKtEPnwAX+q7Kfff39FnwXKZbvzNE75rgfHtBc4Szvs5Uf/LCWgbP+SYjRY5xA3JhiTqwhxSOJeiWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39RzhhJo+1gj6LF54QxHTXc3uvluMPKcd5thGlqO5a0=;
 b=x8u+DC499UofwJ/tr6ajWZDiFA2IIcbyluqyDZbeHAwa4RfeXIjwGZM6psjNvACQAN/SSpb9hfvx86MDE8hechTroKjGTeo1JrGg8RAL8WoKM9JsaxMtUBjC9ud4dBVLGTXA45siuZnsx1rMuYrHV5EafpoqOtGGlnuHhH8LRXD/4S5q7A8Or2e63SmybeVTaWdMBtRVpLX6HKY+j8/XL2MSGn7OrpS3ibusx7HXZbWerI8V5loD/sSvw5jp5AwKszevUHqUV+cuzk2k33T3DipEM4d4anHUw3+sp8RTtp6fX+yvVKzFHzDKF86EJ2hFFFhmirkV1bQPxb7fEmhpvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39RzhhJo+1gj6LF54QxHTXc3uvluMPKcd5thGlqO5a0=;
 b=SVpfGtvngTlb6+BC8BzOnQxOxGueSZw3wgvPMxFkG9BVyTX/XYZNdQjRtkJMBrIuiVwUSmBkySQnFbDfFaT+EPhdxPa+GchkQY0lJvfkS549b0kjFnrPFKWX6YN5SMOacn5cGH5+teHfTVUF/P1o3vbDZY8nVbFvLW867A2AMyw=
Received: from DUZPR01CA0216.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::14) by AM7PR08MB5318.eurprd08.prod.outlook.com
 (2603:10a6:20b:104::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 14:57:13 +0000
Received: from DB1PEPF0003922E.eurprd03.prod.outlook.com
 (2603:10a6:10:4b4:cafe::1f) by DUZPR01CA0216.outlook.office365.com
 (2603:10a6:10:4b4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.29 via Frontend Transport; Fri,
 13 Mar 2026 14:57:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922E.mail.protection.outlook.com (10.167.8.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Fri, 13 Mar 2026 14:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9e8PbyuzXKGrdN/2q/uTNqpzuGDDR89ylUyyUde24jYWbzez1OsZ0OsFFvTA3L5BEiL6c4WBS3Mk1l6KAmpqvuZaERyXTKwIEgtnduDZ29agCFp2IuuePmHZy3enMHrtr7wetzNtAbC6+4o6SM51M7U/QpB2hkqsJ1f9aO8eoXcFfU0W4UDttuBOJZzAFJYUA7VTqnanYSxy6Asn2ytNcV7txzQRd7tEAzJR3U/I3bM8YfyegDLERiJmRt0q/JZL0ObGTRrrBDy9f6ePniiAz38+KOD0xX1j2X16X6gXvp/u/gvpJG3th79WYlnT3JOQTHDpRYipDv3jC87X8ADXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39RzhhJo+1gj6LF54QxHTXc3uvluMPKcd5thGlqO5a0=;
 b=tAmmfWXgZfQGsI211kRGnSOOojCancxptbRNJpCua26wmuSnFdXniqODuRBWWbE094/Q7i2N/AZsBdflFW66KsaglB0qyrc8CYQ9B0gK0jTIkzuvPQHQTQT411NOcvWQ2PMh7cOETNxOxn5eYIpEDdJvI+N8ZhQpF/iAkP+GgVCYdCKgmtsxDe5D+k+0jgJbmSrcwoHL/L0aouLR9hw/X8PVuw+usVr94hJKTtA3RBTqJMsAWmwO5wHZAlmgW78KeLlqE7DRZmLQml/CenBk12Gf8m5PJ4AYvAITGhw00X9Zcx7T8SukhhMa2YhLC0RbbTIbg48fVmlBNNPGNMEt1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39RzhhJo+1gj6LF54QxHTXc3uvluMPKcd5thGlqO5a0=;
 b=SVpfGtvngTlb6+BC8BzOnQxOxGueSZw3wgvPMxFkG9BVyTX/XYZNdQjRtkJMBrIuiVwUSmBkySQnFbDfFaT+EPhdxPa+GchkQY0lJvfkS549b0kjFnrPFKWX6YN5SMOacn5cGH5+teHfTVUF/P1o3vbDZY8nVbFvLW867A2AMyw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU4PR08MB11792.eurprd08.prod.outlook.com
 (2603:10a6:10:642::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 14:56:09 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9700.010; Fri, 13 Mar 2026
 14:56:09 +0000
Date: Fri, 13 Mar 2026 14:56:06 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abQlhhSDkmzUugMW@e129823.arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
 <abMDOC5DYEm74And@arm.com>
 <abPXrvl9tC+nv6q9@e129823.arm.com>
 <abQiSiX_xxjSY96-@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQiSiX_xxjSY96-@arm.com>
X-ClientProxiedBy: LO4P123CA0378.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::23) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU4PR08MB11792:EE_|DB1PEPF0003922E:EE_|AM7PR08MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: 237f5e9b-5134-4caf-f1e1-08de8110cf2d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 CZxkb6pQ5di5xgmS7LhaBooKIClAXqNSKEu1QiVw2KxpqE5rNB9ZBkCGrmPjR8k5QYDOjH5Dt2zE5lZDjvxOyUdllj8R1+7521VUjiGxKplnvEaDwy9rlY9RP/w6OgoSMcinvPnLWCyxon219OJFWHwD7QBmGYKV8Y5dVCWzAQCR3fRq4b8A436UiUnSbTBscWRs2fhJtxwuwlq2glPCtAkxLbTGqu9unRArryaHgswSpv/oczlFxgVZPi7HBHRkK3OB6fvqsN7nqbGsMIbZ2a+3VxRU6Vt4iOtonMGzELaKW71tdYbIzlQrWqki4m1/7SQEzPF8q8IbBdWNHePfbq/bsdHQtcTDlbsSDpeQUhsE9V7T5v4qBuT0xpJ2pn09VoXuj4TMLD3qZzbroZBZ4Y4O6HTaXm1L5xWVoX4jxGtZzPKgWbwHusKsQ7iXb5TNi53vnIviXqAcJVn/T1yt34YJdlY6h882p6eITUXqCPNpNXp3Mx0YNaGRUlu9D7IZbmV+t3dkXoRXWvy9OTxrxDUm9AGmtCw5Pb3hrgdb14kDrPpEfJTBeQKDJPLESmatR92TT0K/zRsgzrsXMaVudfbG1iEuIADotQq02vNYaqEptdXMB8UIj3Qt2eKhasz0f6qoqN66YGkqECqxEk0Z9YjzCLYnl9L8swAC79bWeVjoWvkQbtNOv2DlHxbxzAe2rqTTmftiPXO1VzjcYR+cRX0m6QrqWcPqQFhAq3nfncs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 pjp/522ZQjDThWOzDZFarVEAnSE5uo/hByO37QaPkATdpuDNmjviUMjd1VtyXqjAGhHV6OcCQbLuEsER73eGIJh4SptkD65Jut/vrDSc9B29PPkkWR6OJ4dd+34zvMzjq1pchBrfTIR8ke82QOlzzHtu2kSCnAMNwPhoRTaIhy7E+/EaLV4zcYGslxHGitf9eZNZN8QKWcpiaoYWqhxEVOTYMp4K2AAbQ0WS05T6rGDotn9ZjnnHiT9OU2pqrp7F/Wyqi5YOIvomhJHKZIrSl4gx16eVDTPsfs2GBuVjl2x2WNjGLy9rooulYzCjNRdgcEtrCr0YyXohBE+z/CIiYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ab57a7f4-94af-4207-f0eb-08de8110a96b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700016|376014|7416014|14060799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q+PfbHD76HDPylnEuR0BBRgzGVKSnJyYfDMG2KGKAtyTdc21YCi13TO/Hgycqc2I92k3RcsG6egx4+dujjwv+HYtdkXAFFgVgLMyv1H07D9EHWUHhceiX/6FquNVNWyynLkoaF8QuswMOQKhmMj66mYnZS0sBDei5mxBo1dK6Du5s/m2nI737Nm0eUwv9q3cxSKyU6Ed+5YRChTsPj4UkiVHaReAbbDxEkWIJFZ0AlMunfVeJgoGbocq6i22GYJ/cF/0qiz1ra/zVZ3R1ICpIhKBrlV2Hb1fT090ALIaVG1P4UnvyhEQdddMgLZwNFnCB3XDhq46BaOIpVTl4IrYC0vIuBheo2Wc8U0I3d6JX0XJ+BgBJ036bQsA+Ixjva+bmbPaWqMik1ot4glN8qlpHvgH1OFoD1LQgXO/ar6LZLCm45izMsljJ/hPh7qUSR6UEVCJBcBY+F5YkAHJ+6USjYkTvnRIGSEfiLwDONR8yBHNDWwN85JqNqKltooEaUKNdAjk8Idl97aIPBR64KvRDQxoiTFM9bcHSXMTKmvj18gBOavq8syCQ5HRyYcoFRYHFWXuQIkdZQDG7EFMgHV8u+ZA7Uc4P1fFuUeZBCG7CiJ1/v3hs22HFZmozxzNALy/lCngZ9kQgAQhF/jeXuqAfXBYJThAFCpICox8klmQcHvhP7rEMgQrleF745AzvVazO/KtfSabzOwb+W21jBCWd9CNnYB33Oiv7CZC1+CV5gFaJSQiL89yuSEMMESlhgcGD7wp9oyYIhB6KLUdckbpvg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700016)(376014)(7416014)(14060799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uq3Y1awlSUMldDrILCo+5xY9w8Akye/By0h9SLKuSirYvINupPLo1SyE8ipq4pPEScOR6cte6deKXdbjro4fPOnyOfqTLRiySjv80xZJqlbmXUa2wavTqbHXYIby69NuZcWKBDOgnNX85jzdQTQbDOkgKlmpN36KAVPq07sts05PrXM/ftGdD79d4W2EhIbt7vNZEXmyK1bS527qc5IxaCoHoVEXl2+Bz3psoAxpPP64ezObv8Y/+ng4t/PEgb7W1aGBsBAfKmqCVHfJDTlJZ+FtmKGcNkn/PybK478N/MBq8Z6GhU3KKFULWhXHQyMz5FueZPWkQn5MgGKEimZVEsRColChOp/9JwNYnfcd2CePpQ3v9AIatZDHtRyzx52iE4OccJjze0R8qNdvvx0VnGirBLBQpcZ1TACStYgq3/2OGvJRIHUaz4hweBspizF1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 14:57:12.7566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 237f5e9b-5134-4caf-f1e1-08de8110cf2d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5318

Hi Catalin,

> On Fri, Mar 13, 2026 at 09:23:58AM +0000, Yeoreum Yun wrote:
> > > On Fri, Feb 27, 2026 at 03:17:02PM +0000, Yeoreum Yun wrote:
> > > > +
> > > > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > > > +			return -EFAULT;
> > > > +
> > > > +		oldval = oval64.futex[futex_pos];
> > > > +		other = oval64.futex[other_pos];
> > > > +		orig_other = orig64.futex[other_pos];
> > > > +
> > > > +		if (other == orig_other) {
> > > > +			ret = 0;
> > > > +			break;
> > > > +		}
> > >
> > > Is this check correct? What if the cmpxchg64 failed because futex_pos
> > > was changed but other_pos remained the same, it will just report success
> > > here. You need to compare the full 64-bit value to ensure the cmpxchg64
> > > succeeded.
> >
> > This is not matter since "futex_cmpxchg_value_locked()" checks
> > the "curval" and "oldval" IOW, though it returns success,
> > caller of this function always checks the "curval" and "oldval"
> > and when it's different, It handles to change return as -EAGAIN.
>
> Ah, ok, it makes sense (I did not check the callers).
>
> > > > +	}
> > > > +
> > > > +	if (!ret)
> > > > +		*oval = oldval;
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static __always_inline int
> > > > +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> > > > +{
> > > > +	/*
> > > > +	 * Undo the bitwise negation applied to the oparg passed from
> > > > +	 * arch_futex_atomic_op_inuser() with FUTEX_OP_ANDN.
> > > > +	 */
> > > > +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> > > > +}
> > > > +
> > > > +static __always_inline int
> > > > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > > > +{
> > > > +	u32 oldval, newval, val;
> > > > +	int ret, i;
> > > > +
> > > > +	if (get_user(oldval, uaddr))
> > > > +		return -EFAULT;
> > > > +
> > > > +	/*
> > > > +	 * there are no ldteor/stteor instructions...
> > > > +	 */
> > > > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > > > +		newval = oldval ^ oparg;
> > > > +
> > > > +		ret = __lsui_cmpxchg32(uaddr, oldval, newval, &val);
> > >
> > > Since we have a FUTEX_MAX_LOOPS here, do we need it in cmpxchg32 as
> > > well?
> > >
> > > For eor, we need a loop irrespective of whether futex_pos or other_pos
> > > have changed. For cmpxchg, we need the loop only if other_pos has
> > > changed and return -EAGAIN if futex_pos has changed since the caller
> > > needs to update oldval and call again.
> > >
> > > So try to differentiate these cases, maybe only keep the loop outside
> > > cmpxchg32 (I haven't put much though into it).
> >
> > I think we can remove loops on __lsui_cmpxchg32() and return -EAGAIN
> > when other_pos is different. the __lsui_cmpxchg32() will be called
> > "futex_cmpxchg_value_locked()" and as I said, this always checks
> > whether curval & oldval when it successed.
>
> Yes, I think for the futex_cmpxchg_value_locked(), the bounded loop
> doesn't matter since the core would invoke it back on -EAGAIN. It's nice
> not to fail if the actual futex did not change but in practice it
> doesn't make any difference and I'd rather keep the code simple.
>
> > But in "eor" when it receive "-EAGAIN" from __lsui_cmxchg32()
> > we can simply continue the loop.
>
> Yes, for eor we need the bounded loop. Only return -EAGAIN to the user
> if we finished the loop and either __lsui_cmpxchg32() returned -EAGAIN
> or the updated on futex_pos failed.
>
> Thanks.
>

Thanks for confirmation, I've changed them as we discussed.
But let me sent it on v7.0-rc4 based with v17.
(Unfortunately, I sent v16 yesterday with missing of those review in
this thread).

--
Sincerely,
Yeoreum Yun
