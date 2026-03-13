Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010000.outbound.protection.outlook.com [52.101.84.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A6379EFC
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 09:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393913; cv=fail; b=fMcImyVo70b8EkVXwcwqfIwm2NtMzq1M0cPeF7SdrVuO5dFe8K76j7YVPDHotF5pV8ltEQWchpOQwMb+YYe/uS+HU0oBr5V4LRBOPNZ91WGBG5MYtsmTenW+2d4DAR4bbeXHlQsPDkxm9zZywyjxDOVkuacnGy8b2M1f+ZeRp/o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393913; c=relaxed/simple;
	bh=sbqLF6TYzWQdnDBvbf+4T5t+NkMtZqrRdtRLLejx/x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BwpJNtsZhSR1d50eeVmZ0L4i833gVYHMtSnf7LT9Zd6FOqJYV32Y+CYWjTgdHBo6vC9blIuZJ4OVfKNqoi2zgO0rRYpeuk9/oxmJjrSOnqZcqoAK5j6vAIh7B3EzuqtCuCfVAcTbGyTkBiD90mRwn9hu55lUgiKz15/QWIMG1Zg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T+BKdRmI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T+BKdRmI; arc=fail smtp.client-ip=52.101.84.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T+BKdRmI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T+BKdRmI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d2IqhmY3lFUB/Xr8irspiJgTxpTjgAIpFdJ88P6TsSsdqsraVsqvbD2Fo5R5ZSI88pE98Tn9JXZpDrswuIUC65ZbxYEA2sMUSn3jKvjgnc4uFPgQupNZoAE6ETyzrBxjp2pL8h5G59EMLG2n2HEhAuv0T7D/5UOHv1+hBP+X8Wz9LtAAl/GcSQ9d5peHGfPtq5kNSGvH1gXR7TKkwE1ZGy7E5NJkgQiQCl5vrSgz/QwE64oJ0QjnqH3zuPc/M6Fqekc3WONEWiu0lTz29Ew8wwUQpyP+krwl1cZcasEoKu3mXwm05A/Q6W3cYvVaVLCOEnSbPM+avqybE31U3FSw6w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEJePSUEyvyBgFeN1ueNf92eHxC4oP3TXKLRDKWNTRs=;
 b=BvgtH1TFzVML/LOtSbtiYZYhjlhuDoX6XoUbzlNfOlZBUcAyQxYX1JyXPMmEoFoG2Y5Wbf6G8YCBscf8msW7qruyIBmUfY5045rkNjpesjVRQ+GakNPpFeVCH5DTE0tSwu/ndK+cdYmMazkQt90Z31KCLfVqHSF2ZzKpB3MkYw43hocZnuhCbgYKOvNpO6hmetZyhIELQ/gBlhCJ+JDpZ+HC3AxgEVZRLYuORnRK7i+vojs3uoUL3fS4d2Gbai/adDaJE9YtTF2Fw2yLCAcRGrMMiY4C90u+k9NUxk3xlPz4rE2yBe1g2UlncmnZPf2473Zdu3aqVpQmLOM+Ai2bOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEJePSUEyvyBgFeN1ueNf92eHxC4oP3TXKLRDKWNTRs=;
 b=T+BKdRmIZAVC5PX+HaCPXp0Pr9nrRh4QZYlMn/AZ/KNV37dGcsf1LyYfz9w3lbDo3plibMIjabC4zLlt1+Uollz80FCY3PhO9hA9NMJJCN1m87kqiTVYy7rGAo7737fTlt1AocfOPMeEVVE5T495yb0f4x6aAzy9tTfmC0gpafs=
Received: from DU7P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::25)
 by DU0PR08MB8232.eurprd08.prod.outlook.com (2603:10a6:10:3b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 09:25:04 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:550:cafe::3c) by DU7P190CA0023.outlook.office365.com
 (2603:10a6:10:550::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.16 via Frontend Transport; Fri,
 13 Mar 2026 09:25:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Fri, 13 Mar 2026 09:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHlWCv+x4zNvqV9UW29H4JBsPJUzvP2rP2kmpk7udqw3uZc6BNHEkdfHLL7IjoCIzo76Stp4dEHd6WUQLYUr1TCga3vxA/yA/Gu0GthdgoRfWqHP6ehVYjdnCAN0mNnRCsHapWASVI2qL9dbict0nW9k/3f7MYiNaH7QCxN2nytQPBiJ47fjSOXqG1tqLGnsV8VX085Q1LSLeBEub4ITu4u5Sox5UUIOOZExEYAYy67pYGFYSSzK4GeDJ1yDeep/JXIpOoqjmKbmUSfXUhhe6vjmzQPzojj8ksiegzZ/J+HPQuAIn6JglmA0OFufkYl7zcI8RZ58BEhZY4CEmmnLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEJePSUEyvyBgFeN1ueNf92eHxC4oP3TXKLRDKWNTRs=;
 b=U83UDVgMVCO42FJQMaSBKcGzM4Gxh/VK6gQ9ToaJVLPyrQX9yaVWNbCmrAzIXneVEnxws88v97rfjUpWhdgRHxgN9TDN8GQ2GStIcT4yv3wQbp5csi6xRRev4VaEEH33M76hBjQqguopbs5BKh7GHfFBReVzUjYfwMRH0odPVNDa2cqdKWzpzk74obX4M1M2CSDpfLJSq40t+j3wSbwdCGMcCMJZExFiSiyvZrSLe613re/IuiohvNEqxr/+Y3wWYasCnQAg4DYEAemyhF2Qa2I1e6sTCjBTARYaeJ/0/6TmOp/QdAaGPgrsO9o6UhRpgElgaRGvsMFNvmbrPjHRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEJePSUEyvyBgFeN1ueNf92eHxC4oP3TXKLRDKWNTRs=;
 b=T+BKdRmIZAVC5PX+HaCPXp0Pr9nrRh4QZYlMn/AZ/KNV37dGcsf1LyYfz9w3lbDo3plibMIjabC4zLlt1+Uollz80FCY3PhO9hA9NMJJCN1m87kqiTVYy7rGAo7737fTlt1AocfOPMeEVVE5T495yb0f4x6aAzy9tTfmC0gpafs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by FRZPR08MB11875.eurprd08.prod.outlook.com
 (2603:10a6:d10:1cb::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 09:24:02 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9700.010; Fri, 13 Mar 2026
 09:24:02 +0000
Date: Fri, 13 Mar 2026 09:23:58 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abPXrvl9tC+nv6q9@e129823.arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
 <abMDOC5DYEm74And@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abMDOC5DYEm74And@arm.com>
X-ClientProxiedBy: PR1P264CA0053.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2ca::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|FRZPR08MB11875:EE_|DU6PEPF0000B621:EE_|DU0PR08MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: 888eadb7-d46e-46f4-5b9c-08de80e268fc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 xl251Pd/EKbOhX8GNX3CKtzy4DlDmkGIkXQHNsSeR8t0+zrc2m9xdusk1f6E94wI4fvR/ORq5TCux+K5/O8E4owS9OxDGrO9EY9azdcLso1NaLyIf0pLwC7piIAdH5QW+pNt/3rJHeSdIBKbDrv/H/PCMMw5vcbwk7z9e1AnOZ0fZzOdf1fPOgDWLLRBQD+KBG6NNdvLLLLI1MusmDaIEseMeQwrfj/4tXkJAQ55oGTFhrpTaXwD+HmVWehMJIb3Sf7lk/mx/5deneiSdf/8mZ408u2R8gEiRApgjR49IHcJTE71tMSrHvvM/sVJ9RJSQJ90uxdU0d03T0P5oyN9OI/ysFuPh4CvaHitA49JP8IVbWQzsc6MJcEU+WTqlHevP8botBOH0ryMcO/ceR523HBlS78gOl6ew++VtiUF8r1F+trXu9/N+tI4Wyo5mEj+pyZMm8Wasrhw2MQf7Zc6TXVZEglpCoei04s8d0k6RuM9koGlUreayz4WxbaqOA0PD4rv4U8KKC/fjGcefjnOtCsKc9DUmYhBMc37rD8RBJ/ztwlM/FWW7E5oiQG05Yr1ylgG1JyosAo6O0AoBvgFzX2ConibDlARW+CKz73noVmeSXfI7AzrHPMeTNiqTTPRMG9Pie2oo+EgMHDcBZ9N7qMhQiukbjKgoOlfqkh53z+Spn9mnjMS11SFn4RtRmCkDZ7nSZdDRZ4nvFmkzsLlVlaIxoSydZyozPk+/kHhfOQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 B5kb0jM6oEcDURXcqmP1b7DWKJmswCwtNNKiMGtBEm3NqzGjeKCp3pWYzMZyjRh6YTslsqEcTV0M5FSvJfG7kB6w8AYIMjBKD0XjbfQ4Stdyi4Nn2COeJTOVHP7ygS/80Arfn7FvK1n801umoOaT/mD9TTKROZKqdJKM7Gfe6CnHK5fwOQ7Zpx8yHv8gZrdtF2STM9hmU7I+NolictlEVuahDcLdVFzsyeAqXPfjP9u096um9uXt5nOgHTLi3KODJRmm7nf1aXaUaTZjGayI2RsyUNLmCab+VUTmx70aIRvakb4OFSFQcompFQm6JDNFSwwEJzNqCaZTQqpw39ZKyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11875
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9296e83a-338c-490d-7ae8-08de80e243a8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|1800799024|7416014|36860700016|35042699022|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GLar6mjse2EhG6fCoyNLFrdqhJcQ6khg7aQhu165a6gszjfd0fT9GxM6FM1HUTCyn46IrXZc8wxrn16ISbr7oPIeznuk2NTUfUvvAo25JPf/YijTyYCUlx6Ao/0qCUz6DDrN3c6qnJxSI3xsewECfKtqkYodiuomG9CuZbhGmMpCwIvbwsPVbYvhlQXLizrDoQJQN+BhYAxdCJimzXW6mf6Wb/G8LAxy2o4pxIU9Io9HpwKFNnb2HSTdsnnG711ReRsFQcZSyl+iEVc2X8ltxk+7xqtWKHU4Ks7R2DW1kuztWs9n43BFpS0M//z2D/Pr17GOICwof53Yb9iaSBdeFTOax18iHjunRZjp+PcN0QX5UBk2YBXru1nqdnG/PIvblQecXjGnTUK/wPW4eauuKroE3LvkH3+w/RZzaDcDKrAnwfbNBalyxu4+IsU+bWS/sAfmh7d6WFolFTIONFhZCjDX0fBqVFoTOX3yCU+j1e/iwDK8H+Y5cw2caIe0373vAsCjap3JZGSj6MwUGKrB26wQTaI1+PWNkncYRCKfxt/9yB7GwCODlOiin6IQjKMBqCmlqAq09Gr//1TJXMLsIQc59q5v1Fl63zomtHG9EehjO22V3q+FC5wsb9qMjw3Od0ioJI/I7xSSGt1laAt0cdxnu7LAZF3r8oRRUdxEUss+cY6yfswIu7K/LmceLcoxN+bsUmkt+5D8uj0cZfbgIrO50e8c1WFyjYMYWhzFt2X6iBGvCC805x9raZxs0b/rB8v2XsOGuvxy8VRrC0CJqg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(1800799024)(7416014)(36860700016)(35042699022)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qRCb6wQJ9oPBRUi+SeJJuWpyfLAHHmky+H90jQEPBHfCd4UQ5xhDD6Tlb7/ydOKa2F7Jwv6tvouz3BSPxGJPlgahIzupavrRnBO3PHOAjW9+Q8YD9Whdqor3ExQFSrEtb+GyXhJqDo6VYrMuf4NE2xhm61+mNYmcowDDqkNp9radMCmvq4iVvGetH0jK1NDiXs26R10V/Rzu1tS0ejzUd/WFHo0DwLliFRC5ERVNWfMgo+3geBS4Vx6XH3GfnJNmMtyQsFxyphA57DoRz2ivwoLqFJl9utN2QepNtIslYwzk44mWDdkJSL+BuP6OzVjyojga1PcttyoXx+7s3HzZa3KpyI0+MY8dkPTky8Ohu7ZWFs4uaH/0haEik4bsc0ZXuG31b1S0l1IgFhcNc6f2lzWNbKLKbkUARXXGHkw332nwsCW91kgC/nLM0ESvaEou
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 09:25:04.4396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 888eadb7-d46e-46f4-5b9c-08de80e268fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8232

Hi Catalin,

Thanks for your review :D

> On Fri, Feb 27, 2026 at 03:17:02PM +0000, Yeoreum Yun wrote:
> > +#ifdef CONFIG_ARM64_LSUI
> > +
> > +/*
> > + * FEAT_LSUI is supported since Armv9.6, where FEAT_PAN is mandatory.
> > + * However, this assumption may not always hold:
> > + *
> > + *   - Some CPUs advertise FEAT_LSUI but lack FEAT_PAN.
> > + *   - Virtualisation or ID register overrides may expose invalid
> > + *     feature combinations.
> > + *
> > + * Rather than disabling FEAT_LSUI when FEAT_PAN is absent, wrap LSUI
> > + * instructions with uaccess_ttbr0_enable()/disable() when
> > + * ARM64_SW_TTBR0_PAN is enabled.
> > + */
>
> I'd just keep this comment in the commit log. Here you could simply say
> that user access instructions don't require (hardware) PAN toggling. It
> should be obvious why we use ttbr0 toggling like for other uaccess
> routines.

Okay. I'll move this into commit log. Thanks!

>
> > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> > +static __always_inline int						\
> > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	int ret = 0;							\
> > +	int oldval;							\
> > +									\
> > +	uaccess_ttbr0_enable();						\
> > +									\
> > +	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
> > +	__LSUI_PREAMBLE							\
> > +"1:	" #asm_op "al	%w3, %w2, %1\n"					\
>
> As I mentioned on a previous patch, can we not use named operators here?

I missed your message before I sent to v16, But v16 already make them
with named operands. Thanks!

[...]

> > +}
> > +
> > +static __always_inline int
> > +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	u64 __user *uaddr64;
> > +	bool futex_pos, other_pos;
> > +	int ret, i;
> > +	u32 other, orig_other;
> > +	union {
> > +		u32 futex[2];
> > +		u64 raw;
> > +	} oval64, orig64, nval64;
> > +
> > +	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
>
> Nit: we don't use space after the type cast.

Oops. I'll remove space.

>
> > +	futex_pos = !IS_ALIGNED((unsigned long)uaddr, sizeof(u64));
> > +	other_pos = !futex_pos;
> > +
> > +	oval64.futex[futex_pos] = oldval;
> > +	ret = get_user(oval64.futex[other_pos], (u32 __user *)uaddr64 + other_pos);
> > +	if (ret)
> > +		return -EFAULT;
> > +
> > +	ret = -EAGAIN;
> > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
>
> I was wondering if we still need the FUTEX_MAX_LOOPS bound with LSUI. I
> guess with CAS we can have some malicious user that keeps updating the
> futex location or the adjacent one on another CPU. However, I think we'd
> need to differentiate between futex_atomic_cmpxchg_inatomic() use and
> the eor case.

Hmm. I'll comment below together in eor..

>
> > +		orig64.raw = nval64.raw = oval64.raw;
> > +
> > +		nval64.futex[futex_pos] = newval;
>
> I'd keep orig64.raw = oval64.raw and set the nval64 separately (I find
> it clearer, not sure the compiler cares much):
>
> 		nval64.futex[futex_pos] = newval;
> 		nval64.futex[other_pos] = oval64.futex[other_pos];
>
> > +
> > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > +			return -EFAULT;
> > +
> > +		oldval = oval64.futex[futex_pos];
> > +		other = oval64.futex[other_pos];
> > +		orig_other = orig64.futex[other_pos];
> > +
> > +		if (other == orig_other) {
> > +			ret = 0;
> > +			break;
> > +		}
>
> Is this check correct? What if the cmpxchg64 failed because futex_pos
> was changed but other_pos remained the same, it will just report success
> here. You need to compare the full 64-bit value to ensure the cmpxchg64
> succeeded.

This is not matter since "futex_cmpxchg_value_locked()" checks
the "curval" and "oldval" IOW, though it returns success,
caller of this function always checks the "curval" and "oldval"
and when it's different, It handles to change return as -EAGAIN.

>
> > +	}
> > +
> > +	if (!ret)
> > +		*oval = oldval;
> > +
> > +	return ret;
> > +}
> > +
> > +static __always_inline int
> > +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	/*
> > +	 * Undo the bitwise negation applied to the oparg passed from
> > +	 * arch_futex_atomic_op_inuser() with FUTEX_OP_ANDN.
> > +	 */
> > +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> > +}
> > +
> > +static __always_inline int
> > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	u32 oldval, newval, val;
> > +	int ret, i;
> > +
> > +	if (get_user(oldval, uaddr))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * there are no ldteor/stteor instructions...
> > +	 */
> > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > +		newval = oldval ^ oparg;
> > +
> > +		ret = __lsui_cmpxchg32(uaddr, oldval, newval, &val);
>
> Since we have a FUTEX_MAX_LOOPS here, do we need it in cmpxchg32 as
> well?
>
> For eor, we need a loop irrespective of whether futex_pos or other_pos
> have changed. For cmpxchg, we need the loop only if other_pos has
> changed and return -EAGAIN if futex_pos has changed since the caller
> needs to update oldval and call again.
>
> So try to differentiate these cases, maybe only keep the loop outside
> cmpxchg32 (I haven't put much though into it).

I think we can remove loops on __lsui_cmpxchg32() and return -EAGAIN
when other_pos is different. the __lsui_cmpxchg32() will be called
"futex_cmpxchg_value_locked()" and as I said, this always checks
whether curval & oldval when it successed.

But in "eor" when it receive "-EAGAIN" from __lsui_cmxchg32()
we can simply continue the loop.

>
> > +		if (ret)
> > +			return ret;
> > +
> > +		if (val == oldval) {
> > +			*oval = val;
> > +			return 0;
> > +		}
>
> I can see you are adding another check here for the actual value which
> solves the other_pos comparison earlier but that's only for eor and not
> the __lsui_futex_cmpxchg() case.

As I mention above, though it success, caller of futex who calls
__lsui_futex_cmpxchg() via "futex_cmpxchg_value_locked()" checks
curval and oldval is the same even on the success.

So it's not a matter.

>
> > +
> > +		oldval = val;
> > +	}
> > +
> > +	return -EAGAIN;
> > +}
> > +
> > +static __always_inline int
> > +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> > +}
> > +#endif	/* CONFIG_ARM64_LSUI */
>
> --
> Catalin

Thanks!

--
Sincerely,
Yeoreum Yun
