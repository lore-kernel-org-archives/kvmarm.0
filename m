Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793914583;
	b=gfSgRFl4mmgkVazHCBVaTxdYPTmRPxDRRN7wLf6kCc7KmoVV7rRAe8ohPZaWxY97zKIg
	 o+kKFJeIWgtqaKP96IPeSnsqvCBk001IbCwxJhLHhPXO8iZGEdF7FMP/pUMJkDlgw/x7u
	 op7bKH1hsJXB2V08pG4VTPmgTGuVI8UOpjRtNBPXyzwouFAg1239pgXN0tQ9Bymi+x+cl
	 VpZ0qG8AorBsZ7AA+W/K8TgWCtbXYug5tiaF/wlDmgBEpbLFf4483AwsjAb1d8QvH/GCx
	 3GOlYMPl42yrCIjN6XgGOhiaV+7J58UPCgmMJkBcGO1Er8D7ujzx8hgz9RLE1M2H0/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914583;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ffOlhY0edizRkUbuvKbot2I8Et1phstXhLA9S0EOflE=;
	b=mZ0DXtpCceMijHFRhzrr8ikopYM/4zfk6lecoVYUzBVsnXnw63bUXzkQPbuZW5RRX2Ov
	 Kj3QWuvCv1Yzvvs9GLcIsSKJg0pEcX2E/YnNIw6l9Hef/pmgMUPsIKMGJSDaKrQa69dht
	 DDjrv3Rg8yYhXu7Rkn0qyRqNEB0UOhxrfgAMTIxNpvuim2LxJq9bN+NYlKfUm89DOgDmK
	 UckGBgE/E/yrIaanEcofkjKio2JCVTRg4OfWxj/jUKlzl0AKu5ZGfA7W4jSLPQNQDFPVl
	 YsyU0Tio81VEqBu18gqu+2ExLfQBAFtt68gyOLM2FNhiVHkZUakhZ5QZg9n4NVHLPFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hi+59SID;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.35
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819AC606A32C;
	Thu,  5 Nov 2026 21:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 819AC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hi+59SID
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQbDj7HLXMffh8GDuEoJdvftxmuLovJKw+IRCo0h22M2zWsJkDmEnVL7rCssKmpYdq8bcfAfxNItWNYaPZo2S9w1smKqJIQh8vx9R6cjbfvFThDOVOGOfdLAw+Y2YgKeMlJQPCPUmTDY6OrZUll/Z64dV3rg6pwWxMlicE/LCebVIWCu53KWSIxlmXLeHiu9qHODeGCmVIULm1hF3HchEAZbBIazdegC2LRe8Fsi7XL1U3HzC4CmspmFGoffArVyDvmjsL/Wd9BYdD2FK/el1owEy5a0h1AlPKRG6AN83U9qXr8OeILitLuga3ghg2I64asDKWpzbRf/L9CN+nT4Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffOlhY0edizRkUbuvKbot2I8Et1phstXhLA9S0EOflE=;
 b=Fr5NqPGiQ6C5JvibE5GHuqvC/7NeZYHN38upjk7Hl+nC+eNeyOnhX4wmFuz+XKAL+KZbQmDB+GF02Hr0MCxn/hVKJou+kyCqYhdiyxcdeeMVnM0o36myF6lEstoKPoD2RYmuRVklrHmW7qjtPusCD+6808XosDwiGRkDZ4JqaXHXqRzzCAhgLTwrWCaPNWFSwgjGU/UFCVfE8s68LOOvrJ7LxAOe7x4HgHRvmmXjFfyTGuqeXUt/pCwvTx0zVdESSAgmuWtWvJLsr83ruCT1pjLVRCgmD06SP4QcOD1bhtzuOe6njx7669bCGuLfDswYI/RaaCqeLMFtVOTl8/C7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffOlhY0edizRkUbuvKbot2I8Et1phstXhLA9S0EOflE=;
 b=hi+59SIDmMv4wWRbo++FEeAaSx6TbVi1L4bRe4zChiyTaSbaGsGmSrq9FseO9NZP6KbxGqKrhq6+44gDyphdkXi/vmd1mr+DUFQcWisecJ9+1EizxFNs1iX5PPgPDzMS+Hfnj0q84YOD4xsyi/BQ4G0sBU6M4706ci+NTkKQX40zJdqjWUOyR18pbllCr2W3kK2d5tLkQ6JN1Dl5Vt9ukf3fve5GGzvtn2f8To3WmTQWS3iOvd5yNvLdsDXeJPDOrhXUAuvlaBxLPKhL3P9toToCObVCyfgASWwNe0hU7nEEsNflE/w+4GoCOrl9HYS3hzD3GuUQcEPYYmg+ayLAvQ==
Received: from CH0PR03CA0073.namprd03.prod.outlook.com (2603:10b6:610:cc::18)
 by CH3PR12MB297944.namprd12.prod.outlook.com (2603:10b6:610:367::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:36:14 +0000
Received: from CH2PEPF000166BD.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::aa) by CH0PR03CA0073.outlook.office365.com
 (2603:10b6:610:cc::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:36:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF000166BD.mail.protection.outlook.com (10.167.252.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:36:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:35:53 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:35:52 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:35:48 -0800
Date: Thu, 5 Nov 2026 13:35:45 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 12/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <auz2sUAFRdzFjtxT@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-13-smostafa@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261015200903.2735565-13-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BD:EE_|CH3PR12MB297944:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da32274-ecdb-49d2-411e-08df3b84d19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|7416014|1800799024|10067099003|18002099003|6133799003|22082099003|11063799006|56012099006|4143699003|261028144727099003|261026140227099003|261022105027099003|261021121427099003|261021135927099003|261102123227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	6lnr4Ir1dUlZlPcKI9YKXiiRWdG1Bmr/pZm4gG4j1kybgJB9tDCD2pqqjcFKCOHz3YJipxmAV4Mhu/AmKPwacMEJG9r3MKbmECaoKb9LtGYXbCAW9fMuVEOD2aat8AtaaWm5DxaNze5rkzEVGuKnbcvqp9Pxxx2z1KysMAKdtjLgXfo3YtpY/qrArAc0sDwVxhkg2INucPmFJDUxtTr7NTOJdSsHMze4nhQchI0JcrGuqiMDfL7w5EQ0yUaNiHCG7dIDM7A1pcNwZ6RcZJqr7HZuiqvjVE8qoT/D10IeLqovZKHTwLfjwqNdIya8gVUdXU411afgfY0wTJzN/1ZS2Pmb1fh8r+4YEwjW1XjWVrIJWIvv97FGQU13m6eP9aZyXf4GklD/PKlO+bs+Ewt6Q2dN2ZTKOqziu8l93DeiotzZDC38NElzatWFLwseTwiz/KiHe4jKmdHZjk9Z79CTxEn9gPRSEvXLakJPxrZpQOf3EOb8n2T9LCXlcak8upnTohupzfw1XyHDHKJviQlwMlntOkH1ixDQYVjsaDQgqUFlN25TFvMkolbOZvc+415ZfUdWsRBmX3elgoFDX0d+2xm3Rstf2ylZ7V+xSnAvrARVouONkhDzTSwyJItmIiBCXcTaLfo4rUEjP9eJv4jD+6tO2V/PcHftxZTBupI5reepMSys5UTfQH8HakCWFe8G+5Nd3J2hsyLvkQaB4tjmhQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(7416014)(1800799024)(10067099003)(18002099003)(6133799003)(22082099003)(11063799006)(56012099006)(4143699003)(261028144727099003)(261026140227099003)(261022105027099003)(261021121427099003)(261021135927099003)(261102123227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n9rDfx0oqXveyXfkdKmC4BPKMnn4Tuc52bqgE+XD90SD0Iilx4SUK/cf4opBWULhgUL7d4qV+FLcjPzwV/x4Ik6lgddaqcTf1R4Jqzmkjyp7A+vEa8bmWxuY8JO7tOcSuyXR56gW+p1CZNKzQQgnFT8lSNamGthlY62xtFAuhMkMYATzS2v6P/NeIwJt7xR1ao+/FRLMYxwTBCrVNoCeHp3KNvzJuvvIAt1RtkCSQM0OP4AKRb9yt0JyIKBbxBrVR6gG0gIqOjocwxcnXdeSLosIyAEtkROIRzTQeI3fwIlsuBzTyA6fEVQDpvaCYoemNCKm4Y5c89sbHtkbS6uyjEJ1/3o/xXKjt7zQ9rzmzdK4rwdvK4ijHlz6ToV6tnY6VytsK3ZU7qO+Asgofmgm8PPQHEmLhmKkX5bfazpuqNAHNs1zF+92RKhqgPXmAqEE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:36:14.7129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da32274-ecdb-49d2-411e-08df3b84d19a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB297944

On Thu, Oct 15, 2026 at 08:08:43PM +0000, Mostafa Saleh wrote:
> Probe the SMMU features from the IDR registers with the functions shared
> with the kernel driver. SubstreamID bits and queue sizes are not needed
> here: CDs are not shadowed and the command queue is set up later.
> 
> The hypervisor requires two things the kernel driver does not:
> - Coherent table walks, reported by both firmware and IDR0.COHACC, as
>   it does no cache maintenance on its tables.
> - Nested translation, as the host keeps stage-1 and the hypervisor adds
>   stage-2.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
