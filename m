Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060.outbound.protection.outlook.com [40.107.21.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2FB1C766B
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354094; cv=fail; b=KKtlHz/zUE6AArcoeouV4o1WKsi3yoakvbM3KY3QL40tyAJZ3a2ddw9mfBxee7gJWwsyJ6A9Q/lfauLxoBSjlfoHGQrjQh5CAlhEg/1Bnh2TQfPV6eIxLTBDgRGQCdQGmNFutBqZuQnIpiTCqpH+mgQn4FPGx7vlTFkCyF2Qadk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354094; c=relaxed/simple;
	bh=RdWZh1HQppO8SWYbVCyDFEjc90dR3YyZKcxNWe69gZI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJFXzlTCv29L6ywhjqDIQ1p7xPMs5xpxoMCXrV0SinZv5fe9TTZHbqcXKAahoAvVXFXPtmo7AKIC+6dj4JAh55p5KJazk6wwXGV7ngqbTHmv348Amgux9Sxjmumenx4aDEMHitOxcQqhTJSVHnF1fU610zybZGMtzlH9vT6xxEs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WYr3riJk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WYr3riJk; arc=fail smtp.client-ip=40.107.21.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WYr3riJk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WYr3riJk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Um8n9n908/ZpoZ+YDRynSLneAmnuVDFw9OrdGZlEYX74A2TZhd6AMd0MwCWEmJ6z7tc9+Hk/+ZBz7hG1l3eC+W7OTWo//9gmlQ8P/ApC4hTqiLBehI9foODlgtRKSiNgykBF5LksAYCa4wiU20bE6ZkbUIKmbGozKI9CinqJuqoCYYx/MO+37QyAWorkrSkXSuH4AKmMkbkGC9ACcB/FiN9kjq5BNZQtbfV27cEmo0BvGGL423FZ+3OqKQT9VpsltdrmqMcoipi2RbnGTW0bh2MSLFvh9Ra33jZtsp2DxcZHM11p7jGDwvzNPpdr7JkUBC4V+YNnxtbHtLGc6XIHHg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPZRN1D5kGw6NeRm4Sx5KT9gcnlou788LX7V+C5wfSc=;
 b=Bh4K5HSja/w5zMttztHIndi0nyOQq6Dv1vqyy1/OtuXqbxFAtpxZWEAc4yi5E6X5845ekL4Q8XH3U47mIHo9NW8pDqpmW8WgiwmYBig2r9wpLTOmhwgbeyxl8iD3ED7F6Y4WLYiygVxxUJEJwbFgaJ0YzPJCyLmkI4minaenpbvd9ylQVLdOaiUf0cVs5SHBhGLL6JDBJAgglWm/PNujsyS6GFbjKbFjYea/ZsjopSh4brwSKzLJlQgVP5CJWC+3bK9nBjPX9hrvEL3lsUueAnXXxbuqkEvQsgbwpo8AqlolowySqhKEJYGFE7vWjUG2trojz08jeWPnN3Zuj+HMwg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPZRN1D5kGw6NeRm4Sx5KT9gcnlou788LX7V+C5wfSc=;
 b=WYr3riJk/3yZC1hIiGpXusAQjlRqtxdou9uuIK9AtnVlA0PoFgYpvdiSmwytnOLpRaxDoPu0mWpUi/p0Ynq6yu+BIJPUCpXfzFpNYx4xq7fqRBaXO/dS1BjwvbTJxPkBXg1vQJcJIrBbwHcIW7yoxH20JZrj5LcY035hm18V2/E=
Received: from DU6P191CA0047.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::12)
 by PAWPR08MB8790.eurprd08.prod.outlook.com (2603:10a6:102:333::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.13; Tue, 3 Sep
 2024 09:01:24 +0000
Received: from DU2PEPF0001E9C6.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::69) by DU6P191CA0047.outlook.office365.com
 (2603:10a6:10:53f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Tue, 3 Sep 2024 09:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU2PEPF0001E9C6.mail.protection.outlook.com (10.167.8.75) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13 via
 Frontend Transport; Tue, 3 Sep 2024 09:01:22 +0000
Received: ("Tessian outbound 901f45c3f9e8:v403"); Tue, 03 Sep 2024 09:01:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f965453a8a7b612f
X-CR-MTA-TID: 64aa7808
Received: from Le5e2ffb7fe9b.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 85A8DC65-3AD2-4CF9-99CD-E2E71F6C9E2B.1;
	Tue, 03 Sep 2024 09:01:15 +0000
Received: from EUR03-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Le5e2ffb7fe9b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 03 Sep 2024 09:01:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3BZi23XJ48EBaOVm546fD9hku4FX5sSC7JwULmlrtLLkbDF9iHNJQM4+xopwVcggZDNggQqS2u48QeaZbSR3quj+MtW/76ic/Lhh8YCzL3G9rgPDpH6M284znP+YzRIX9OKkVaUKD6cilkPReNv8QhchOJjBWHzHap75YI9mezj9WkLuzbhPNwpSPLRQGmUhUkVXzJwqSARIjbTpyqr3Tv92djDJF8UKhz3v/5Fp3ltPfxxPxb9I7CbY3Ci0SpLFLGbqalM5gEPLz3J45F9wlwgITwyEi/YXBc0We0Up1Ec6Yap0i+oT3nnyC/Hs/oijRjsd6sKe7kxS7dSG3K58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPZRN1D5kGw6NeRm4Sx5KT9gcnlou788LX7V+C5wfSc=;
 b=Yj2xNOPR+9cPLI4VAHzGhfFLQ7hHT9jAbFEXhAzpNla1JXahmvzJHG6+lamicSOs03o3LqB9RORhSFX9dO9DnZtl1fLsGT7Qo380h0fk0Vo795CcqMWgk2FTz4zHgeNqh3WMKC3wnaH+BMzDUhmEHLep3DcgVJylFZzMwTFvh6il3hwxPg3/mW5tDG41YaCHZJpbspe2w7XNG1Vq1m89PBy6QwpTeoZFi0EsPWnmFD+kjwhhqTsyFLIzTgQoTK4StL0t9UH6/S115EbednrpuM0g7We9aBb/djxGKvrWS7pqNnMJ6Rk4oXtM68fLpVIgQZqeEkC43oQJ1vyIs2VtKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPZRN1D5kGw6NeRm4Sx5KT9gcnlou788LX7V+C5wfSc=;
 b=WYr3riJk/3yZC1hIiGpXusAQjlRqtxdou9uuIK9AtnVlA0PoFgYpvdiSmwytnOLpRaxDoPu0mWpUi/p0Ynq6yu+BIJPUCpXfzFpNYx4xq7fqRBaXO/dS1BjwvbTJxPkBXg1vQJcJIrBbwHcIW7yoxH20JZrj5LcY035hm18V2/E=
Received: from AS9PR04CA0087.eurprd04.prod.outlook.com (2603:10a6:20b:50e::9)
 by AS8PR08MB9477.eurprd08.prod.outlook.com (2603:10a6:20b:5ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 09:01:10 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:20b:50e:cafe::96) by AS9PR04CA0087.outlook.office365.com
 (2603:10a6:20b:50e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25 via Frontend
 Transport; Tue, 3 Sep 2024 09:01:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 09:01:08 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 09:00:46 +0000
Received: from arm.com (10.1.28.157) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Tue, 3 Sep 2024 09:00:45 +0000
Date: Tue, 3 Sep 2024 10:00:44 +0100
From: Yury Khrustalev <yury.khrustalev@arm.com>
To: Mark Brown <broonie@kernel.org>
CC: <Szabolcs.Nagy@arm.com>, <akpm@linux-foundation.org>,
	<aou@eecs.berkeley.edu>, <ardb@kernel.org>, <arnd@arndb.de>,
	<brauner@kernel.org>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<debug@rivosinc.com>, <ebiederm@xmission.com>, <fweimer@redhat.com>,
	<hjl.tools@gmail.com>, <james.morse@arm.com>, <kees@kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-riscv@lists.infradead.org>, <maz@kernel.org>, <oleg@redhat.com>,
	<oliver.upton@linux.dev>, <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
	<rick.p.edgecombe@intel.com>, <ross.burton@arm.com>, <shuah@kernel.org>,
	<suzuki.poulose@arm.com>, <thiago.bauermann@linaro.org>,
	<wilco.dijkstra@arm.com>, <will@kernel.org>, <yury.khrustalev@arm.com>
Subject: Re: [PATCH v12 17/39] arm64/hwcap: Add hwcap for GCS
Message-ID: <ZtbQPBSl6Ym7g4QE@arm.com>
References: <20240829-arm64-gcs-v12-17-42fec947436a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829-arm64-gcs-v12-17-42fec947436a@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM1PEPF000252DE:EE_|AS8PR08MB9477:EE_|DU2PEPF0001E9C6:EE_|PAWPR08MB8790:EE_
X-MS-Office365-Filtering-Correlation-Id: c669a93d-ed15-40c4-1972-08dccbf6fc05
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?ltwBowyxfJd+X0njlSGHHNYB1Oi0VFO8Duzg8Dzi52d5JlYTIi2Jeyn7V41U?=
 =?us-ascii?Q?VKb+3O7ganFofnUsoaF2s5P/REuKBeTAwbFH5+agqmCynBLbVFFmMEhkxNMP?=
 =?us-ascii?Q?kJePSRlq62ce8hwl+KViL1Y5Xf/B1u7rJc8ivp2ao06TvlZBf9nqPEXd2v1p?=
 =?us-ascii?Q?yEnwa/K0c7+JURurtDdxbaT9jNzyj4D3fx/tXyVBTXa5gLbWY2TdaqTEfcSW?=
 =?us-ascii?Q?vNxmVYf81tSYt6cx6Gagjn7staXsttFF797eVFm1Wz6+w1AlhL90MNAueaKI?=
 =?us-ascii?Q?g445WGZHnwb5Zq19IqgM9jbgmX92Zd1h/S+KVwOrmtA1zPoac8XYAJcf1xOi?=
 =?us-ascii?Q?sNitsQNCg34+iFU5feqn+2HApmoFdPA4DjskIqNE9iOdJLpOMgsDAtySKmjp?=
 =?us-ascii?Q?u4OUpqWBiRRzecDhVgfKd5/Byucb7xPgvppgmsI/4H7PUxVzsKhqtYjQCRZF?=
 =?us-ascii?Q?rqFwZn+yuT7UR5wd5aJca7UqTRWxmS1qWcAwu8DRQPWdlJsOTzZE8ePmCq0B?=
 =?us-ascii?Q?1Y3QZpblmcHxe2kTXoeGD2LFbNbKFtiEjILsrhPHT+/iVjyqat8wRvOXEhRN?=
 =?us-ascii?Q?urgzO+GYL6VcDJiR1hqZIQnO628nacxtDpy20dN5ezVwIhYS1arPvKd861rm?=
 =?us-ascii?Q?QkB4avirqhDXodkCuXMQPb91X3DjK17CfrbBbu4ILJSSOOe5gSingqLTrQkF?=
 =?us-ascii?Q?3gCuk2eop3mMtYMJ03SK+/ItGCgLn/IyLDcgCAifYbc3U0d48E5czI2eybsX?=
 =?us-ascii?Q?BJ+PMAMTPpA62FqkYQJrPmYw/DkNzHcuZNwjYyoVlm4wmY5MuknErWNGETka?=
 =?us-ascii?Q?KSwsCKPjw9ZDoy6vnKnmu3YwgAoLaYhGARTwcWG28LPky2z06qNJJZVXL9nK?=
 =?us-ascii?Q?velzBDH+qmDneI4p7WinQDUmzpqpNk0+VC6RPp8tgdlVbS8cZP628ITMq/Om?=
 =?us-ascii?Q?OdHJDc4Cp+YPoyJIgMtqNPVMakcj2aiU7qbcdKQSfQBbKyhgHflwmk3LvjDh?=
 =?us-ascii?Q?AxzlDdVTiZdTUmazyyUNJXVn/CLfpbxMpdRZn9nSsAKbOD9yaBOKHUBN2NyT?=
 =?us-ascii?Q?NeDkpMH/5D/XyjQxDLMZeSd6ulcTkBar9oiGN/IfxeH/qnlPStAF8hkpWCx7?=
 =?us-ascii?Q?NGQi8pr6W8dZub/XMUdO/ayIs6Ctke0bYExxqYBIlPc+mXdtig5RuW0lfm42?=
 =?us-ascii?Q?+iOgMWIlJzNtZDCb5ztKn/JBaakXbZ35/C8BYvRqfkXnXZp7NFkLBbs7zl55?=
 =?us-ascii?Q?8UrQCS/2j8xKzhVVT3Jm0vsgf9Uo5GkRce8dColjQvNMY5arySv53xVJRd6O?=
 =?us-ascii?Q?UoLIx96tY8+IbPDD1dOdFsWjaVucvWrfMPXHnZk6+PShJ+uWr0uVWUlvOfpi?=
 =?us-ascii?Q?2kAmY/A4O1d3g2dvVaVUppZqgZGZG7nfA0vplfSmWDsZo+Ve3YNOjRpX9O6i?=
 =?us-ascii?Q?8W1AW7qRSnNJPHe2o7RZymv5zoJyyS2E?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9477
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:20b:50e::9];domain=AS9PR04CA0087.eurprd04.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f39cb02c-83c8-44a1-ca60-08dccbf6f33b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OKMpGRV9RxmNpG5ulPuonb0IhqOh4JbUJxP5uxDPJa/+xwE2PVKehWvelgyx?=
 =?us-ascii?Q?v+ahscGeibyRgJ3yZ6bad6ralAqhmVFkPPB4SubFyZy3+dtWWYeHem2wf/0k?=
 =?us-ascii?Q?hg57RdxwdqwbA9ZHKIl/cnuyMEqgSN6E2FeWkAQPR0NRSllTPUtW9BX5jn2o?=
 =?us-ascii?Q?cE5elsPv3dbdBTN68wkLThbp+YbHvviOW28UGubSHshqC6D6nyqzf4YwmFtk?=
 =?us-ascii?Q?KrLh+RW5xudrA68Iq6bQ0HjayI46cX8vSW9FJE/E2nhleOEst0XOhyI8foQd?=
 =?us-ascii?Q?ckStgEHXVkrP+Rm+HNUk2OlYZ02oTR+JmIh+GnnNoR4wmCtBFp0r5xX4Fdxf?=
 =?us-ascii?Q?akGqT/LHCGvBFj/1vOgfkdG0442ZkE7lbcHLFjMcnoMqsWQHSrL46zMtHONy?=
 =?us-ascii?Q?3Uz//nayFfTWWmu5eqOto2v4qB3bHkpcHCo58w1PdNL0Gx9mEN9+qR6e7Ck2?=
 =?us-ascii?Q?iMpz2Q7WxTsOKOadMwRA0dqMabGHgLNZcHgz27//6AwIhd3hvKjhrc2u/VZu?=
 =?us-ascii?Q?abPfaZESPSVI9sfSm5RAbVFCXU7w7sdPt3FGQBIbscWJfG4uyQU5R4m5NdUU?=
 =?us-ascii?Q?LAK/PDtLUsyohtreqztEl0atwlnapIJLIKmc3jwixhEIckiA+FQfygSb0wsZ?=
 =?us-ascii?Q?9t0K8wruFDPUIzHxd6VjJeUP5vji/5CRZqmm+V1F1r6dX2qEJp+NKr+3yiS/?=
 =?us-ascii?Q?m3GK3nssfFLbSB8CY85svSWFVSoRCUPu58c1fscILLlg7Inc56qpgNkFkV9k?=
 =?us-ascii?Q?EBx/Q9JZ3ojA5z/MgbsAgoEuuAkCF4ZNFA4LVZslUBSxwc41qSehPErbNL3r?=
 =?us-ascii?Q?IYG1wdlLlSwhomnpDA3eGp+AVDq3N9Nai2Ao2Pt311r2kICaBCzfs87WXyz6?=
 =?us-ascii?Q?+rSh0XYkxJaAuo4omjPMQbKs9uwepWvxvbRPyImgzAXSOGuBjDt4ONnemPKe?=
 =?us-ascii?Q?N8dVOM5wNCMVXt4PEwxo/vRuOdBkZ3ykBSDQz7ccpTpS/7XKh144tpgW9F++?=
 =?us-ascii?Q?Zg/AatpEJ8LGoT1ocMNEFJ48pPxz6pynNUp9IF1dQ83rDNxqgIEEGVFvLnuh?=
 =?us-ascii?Q?KsOALAPCg3NvXu4cefeiQHvRcBHDfVaOEW576sjhtIJULNOL/2WVBsH3JyVk?=
 =?us-ascii?Q?QGvICzz1iJMBu8ibt1byrrSuQn395x3PNVpYC6mviBDwW0h1YKT+H3uYY0Lx?=
 =?us-ascii?Q?7imwkIxJjrFglkV5lxE96I16bd3eVmPsL4zDhS29DoD2hmNxAgyXF52IDwth?=
 =?us-ascii?Q?gz7kknyYgznEAPlzTdpxmcjVuDt784xjRJhTL/DqCxImi6507tD7yGC1rRQG?=
 =?us-ascii?Q?EsLh42WpSMBII0rVSsDHlY/bIVRy7gyZr1hIgczRYu/3m0z6iLgSn3FItY6k?=
 =?us-ascii?Q?JpLmErSxEz+NckzCbNQ3f6P5o1EUGQfqq2wqB6QZ1ggOJcx2nr+TkdDJMjsE?=
 =?us-ascii?Q?GRd4fx4hsyGWrdmlO3mGfT5JIBca+8Qx?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 09:01:22.8634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c669a93d-ed15-40c4-1972-08dccbf6fc05
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8790

On Thu, Aug 29, 2024 at 12:27:33AM +0100, Mark Brown wrote:
> Provide a hwcap to enable userspace to detect support for GCS.
> 
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>

