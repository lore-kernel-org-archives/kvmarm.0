Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C2B1A303F
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354366; cv=fail; b=RC6pIvcycymoXaxPs65ZzkjYGhLXNOzQFiLX6AoWF0vPb0fkLgesmdEWekLN4mdS0piFL20WLAMcyf5tbe3nNvdXiKnGzTnWBNmr73TBuBkUWb98lQFDrcbLIBx+szEULaNs96UBzz67QSerFfUA/c5PXX3S2aaIl5kIHxDT1BU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354366; c=relaxed/simple;
	bh=PYszyiLWU9X2+NL3sLPbhhdJ7RuP5oQPMoLGxBB3a0I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAAUVVkVfMCffD742ahZBDLndUQ2K4ao1PM1OuWFW8ro/+zUJHWrWlZQ80sZAmFTlAC++gb9mBQ8jjBc38CtcV3iw1JrP7K8iKeVcIqBzjTV5J7nKLHF5eQzDSSTYlzPfA7ab0+u21bxQITTOzDMlwxENFuQv/XJjx0yx4/nR08=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HQLJyB0f; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HQLJyB0f; arc=fail smtp.client-ip=40.107.20.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HQLJyB0f";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HQLJyB0f"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lN/DNDCQ2K6PTiOOwSGcNwpGjBlKHf5KEsGNypWTHAgZ9OD5OacoYbKoXa9QoK4QJX50WdaixxunU5NaxzhPqWpyHLetLF0mnXW/tYug57VvlVTQtRS74ctOI+BLYZ3a7OGUuLU8CwQB9VZLTQMIwYFfzUtOzffYUekGTF0hTrI/4tg+i8TpupZKlbsWqgaqLZy9Bp/RJp1Rp4fo+S3GGk8M/97EQbkonYh8DKeCZ1YasLvSOLldni3OFnay/smTDtDz7zMB3TI3nNsIdmyeSEA2HkX45wZUjpnkBN3TMHjqZeQUVGS1+09Sti5NzbTzOCKta/ADPJvmlHw4Fyz8mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sfRshfcYXYAqALdhl/s+8f2cqC2vS3QZ2MqRw6p6SE=;
 b=ZNt1Pcm5NnnAOunJMXVRKNQHy1L7wFvFKRC/BVUHrB3CSTUHqelFQ0G4NmlWNCs3VDKVh8I3Dd904QtlUulX6aH+6XpVQDj+3EjO8fK+9WMUAabbsffuaq/xGdLVgThtY3j9YHD0i8nUrmfYA6LzR7AJymjxiroBQ4CVj6kiIbOghNUcSwhUQkrWdFuDAyaI0b19onYGRH7czra2bDMvbJYq3o3vLwkdlgJMXCcMgvTazDY0WYmZfzoAqxgl/oiXMzkLVfxbcjVe3BNh6QKkFCeuuth1gk3hdC9yvFmdDjsY4DQLZy8ZquJ3m7YrJAKzEQAvNhbHeoY+//tVcEsfzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sfRshfcYXYAqALdhl/s+8f2cqC2vS3QZ2MqRw6p6SE=;
 b=HQLJyB0fckVMsjQg1zqTfAoJK3PvFxhvOjbayrQkOdO8ssN2+A4iVQbLAVWzF1ErbiIhD9LwOZgEkzp5rs81jgsHS3kRo0LAuGH7Vs6JD1LqdKRtjDxYH4I2Cu1zfSPGXBuOw8DHU/+Sgc44iJRV4pK9fa96+vlJZHoDvVU441s=
Received: from AS9PR06CA0630.eurprd06.prod.outlook.com (2603:10a6:20b:46e::22)
 by DU0PR08MB9251.eurprd08.prod.outlook.com (2603:10a6:10:41a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.13; Tue, 3 Sep
 2024 09:05:48 +0000
Received: from AMS0EPF000001B7.eurprd05.prod.outlook.com
 (2603:10a6:20b:46e:cafe::12) by AS9PR06CA0630.outlook.office365.com
 (2603:10a6:20b:46e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25 via Frontend
 Transport; Tue, 3 Sep 2024 09:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001B7.mail.protection.outlook.com (10.167.16.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 3 Sep 2024 09:05:48 +0000
Received: ("Tessian outbound 7d86ec5dfeb5:v403"); Tue, 03 Sep 2024 09:05:47 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f3126d8f3a8f366f
X-CR-MTA-TID: 64aa7808
Received: from L93db8b2c1ed3.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 50EED0E7-7C43-4A18-9B17-7DBDEBE09C67.1;
	Tue, 03 Sep 2024 09:05:40 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L93db8b2c1ed3.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 03 Sep 2024 09:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpGcUjw9vLVsJx1PxHmpykK8QIy7Iix+969W/ElQaOUz8iglvneeqIyhuY7xO/1LZtsZNFQSefq3Au46Saf49fNqvVOayoTlOnLTaVxukH+FMTizd4AZ2ZldTN1WlSe6Yc+XJB9GwU9Bd1eGa3dNFYKP62p7GpN0ZXahZX3uGO6/Ji9jXs+Wifmj+z4qE8tkK0+0eImQghzYCsXoee0DEuixedeZN3tsZQKu7yy4++ZkhaA744RlpTH8xuJEBk7IAlIvh3THamfRVk61Ki+obFPA1KlsE0E8dulv2GJilQbjIfO40grrTNP1HzSs3B3fKwJx0stQ0EzOZQJ8pklPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sfRshfcYXYAqALdhl/s+8f2cqC2vS3QZ2MqRw6p6SE=;
 b=b7F1sz8g3hHRitB7xh2XzmNythywZFDnvPZlvNxkQkbv1Vwdc6MN54lQ/RXP4UgCp9D8d6jDel4jYWmADTSdPRGJT0Pnc2K82MrWNsQA/Ve8YnGHKeSN/TNvoTfX/7qwHNGpW2IQyPNbh8EbfA51tzMqmtQBEnbBQDwkOXqHzd77tvvXNFHZacaiwUqcnsd4KNoAch2WJPKoQ5l3uLXx/1gZBHuybmmtxR3WDh+kVEdVtw6tNFTj7rqOwCms4RzzpB94cyppnqYHDpwvbq+VCiNPBg47+8Z+mcpD8rzlECk0gKBNqNdkLXA/tlP3kw5AKFrY8S4HtiUEZJPPnVrfSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sfRshfcYXYAqALdhl/s+8f2cqC2vS3QZ2MqRw6p6SE=;
 b=HQLJyB0fckVMsjQg1zqTfAoJK3PvFxhvOjbayrQkOdO8ssN2+A4iVQbLAVWzF1ErbiIhD9LwOZgEkzp5rs81jgsHS3kRo0LAuGH7Vs6JD1LqdKRtjDxYH4I2Cu1zfSPGXBuOw8DHU/+Sgc44iJRV4pK9fa96+vlJZHoDvVU441s=
Received: from DU7PR01CA0012.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::15) by AM8PR08MB5715.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12; Tue, 3 Sep
 2024 09:05:33 +0000
Received: from DU6PEPF0000A7E2.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::e0) by DU7PR01CA0012.outlook.office365.com
 (2603:10a6:10:50f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26 via Frontend
 Transport; Tue, 3 Sep 2024 09:05:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DU6PEPF0000A7E2.mail.protection.outlook.com (10.167.8.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 09:05:33 +0000
Received: from AZ-NEU-EX06.Arm.com (10.240.25.134) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 09:05:08 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX06.Arm.com
 (10.240.25.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 09:05:07 +0000
Received: from arm.com (10.1.28.157) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Tue, 3 Sep 2024 09:05:06 +0000
Date: Tue, 3 Sep 2024 10:05:05 +0100
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
Subject: Re: [PATCH v12 23/39] arm64/mm: Implement map_shadow_stack()
Message-ID: <ZtbRQYiGCZuhQcmX@arm.com>
References: <20240829-arm64-gcs-v12-23-42fec947436a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829-arm64-gcs-v12-23-42fec947436a@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	DU6PEPF0000A7E2:EE_|AM8PR08MB5715:EE_|AMS0EPF000001B7:EE_|DU0PR08MB9251:EE_
X-MS-Office365-Filtering-Correlation-Id: 750eda00-c859-4891-21a5-08dccbf79a05
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?EUH5bqCUfaSNiOsSOX/ZyB/ApFB05j7+3+tyQGeXuDTyfJKvF5dFb+2nP/K9?=
 =?us-ascii?Q?FGdRA88HFm0mOL3UvbgP/9KD3UlDZGUv28Gq6bwhA1XmfD6kOSkCiWFSvFzR?=
 =?us-ascii?Q?jbmJvbUzxOdt29NQM7ANiHF/K8Zh+2J5oAtHzaBG2rOPh1doaxljapVPDIWz?=
 =?us-ascii?Q?qWPjK28s8nvjZx8zB205PzxabwvXt7tbNEedUeElVoEyXV2/wJkDq2F7sVZu?=
 =?us-ascii?Q?fOQM77iuzkqFQWkXwcBYI8WI34ThFhE/1LbKkBsYGGIWbYAJ/Rw9u8m0X2Fl?=
 =?us-ascii?Q?x1TuTOFOfmXC/lTxi/ihLy5vn/7GkacV6Zvx5IrJ22rvgtB5yKNniqRW2ZBO?=
 =?us-ascii?Q?kR3WdiP3nfqQmgDyYSC8I3eqI0aAh+WkqiiKSqGELP+jfMLVmUA3ubuuE8f9?=
 =?us-ascii?Q?5zhBCRL7OkHftumxEVF49sUHhpGgqcF4YZWxOK8FgdwXZx6GJ4WLoMneHqv2?=
 =?us-ascii?Q?w9TX0kwh8BCCIXxC6lv80quNVPe2TPJv3yjf0P0dpdCwJELC9JlRE0YUDx5a?=
 =?us-ascii?Q?MEtZidvYHvgYx3h/qxAtQGblwbvyynkYdsPG1T3FM25qWSo3MudMD6ebjBS3?=
 =?us-ascii?Q?FUiOTqxWkkPubgIH48nCkVyXyp3FpBxt3PPGfHgssJmgxwVL3/x37MfA/SBG?=
 =?us-ascii?Q?fPE8XJShwEFwLiDnWxpZ6vnsg2bo8Hvvg5INJdaRksNFufgW8+ykKsiw1Baf?=
 =?us-ascii?Q?OFn2uXkAogdIrpYzivNnb1B7grf+q2VrrttVZHAt/vcEmGWSvv/xlWXFA/b3?=
 =?us-ascii?Q?oG1Cko91RuiAOGuzxMBLdzBTGSFWe7eukXrWnZWjeailcSzax6CY/2rPZB7Y?=
 =?us-ascii?Q?idrs89+F7DKEqhwta8DolgQpkNFZYHmkYTE7rzOaCVAniiis+CcQdJmPx1CO?=
 =?us-ascii?Q?OfTRMIM7hvkXBIrxddfGGKG3JNI9i5XzMcyKEiBbmJ9JLbHTdiAzoKP0HISD?=
 =?us-ascii?Q?lrXqwdS72ibyeTDEcIlS/LRiRhjnIZjtQOo+mmOic6C/8kCZEfJRkJWUfWsa?=
 =?us-ascii?Q?yPopCqLKTZnNhzuLIEFiAz3wU0nFWE2PPdd/3HS5716lBDOY9hKQX1iVLNfA?=
 =?us-ascii?Q?LHb1roUjgJV2sPGm1D8/l0uk0dyVWQbM1Ju55Tbb3MlcbLM53XpyhJh3wxfM?=
 =?us-ascii?Q?T6/FutITXtckuibP7lauUty179r+zCs7Yrdcj0kpR95ZZGbDJIuxXO2N9xa/?=
 =?us-ascii?Q?oErbUtZrC/mACoyX9wZ/+zWyvVze1fmqNx1CAPhEKwwXvxcXPP6cMS38wl7r?=
 =?us-ascii?Q?kvig+n9gGTrg5v1iTbaJ0bomkuu7FVdNabyvpC6j215hQK3zON0EgTC1mozB?=
 =?us-ascii?Q?annPdDtJRRybq/CW6h568+gSLWVL0EBJQ1FiN6b1ioxzPgNh5Udg6bbJ7v8G?=
 =?us-ascii?Q?zNQIF2SwOxsk+6rLAdUxTKdQW6qNtarTmAFNL6vRI8t5r3kEDNIHFOCak9Bj?=
 =?us-ascii?Q?RJV0fDt5E0OU77u1SUvrU06g6yS85bKG?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5715
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:10:50f::15];domain=DU7PR01CA0012.eurprd01.prod.exchangelabs.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bb5bcc78-003b-42af-fb29-08dccbf79163
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q13+b2o/0eNg2jnvFk8QIWXSF4Aj6hGKrfe6lprHPLq0iDUu8nx1pCZhEtkT?=
 =?us-ascii?Q?KqW80m7AfI6y4T6XRFsspEzo6LIL9JnmgYNdF+yaUFGzVujCotL+kMmTBcs3?=
 =?us-ascii?Q?LWRTX0fl5TUbtkgqVH1zjzQvWtebUs6V8kzwS6Z4jg+izmoJFXHSv/eqtPiy?=
 =?us-ascii?Q?JJNmYtLefzsmUS44FL0Qi80qzYP1c5B4ydCaJ8PRGoCF+axgHx6v/W/CcqB7?=
 =?us-ascii?Q?LpvkD26xnSKFmBCu3ag3vHvq9asYEZ26uJMRgxKR8TyKhEt4MzhIVOPvsDWq?=
 =?us-ascii?Q?1McRDRS0qfaqLHUSyhBqlxKfFleh0U0PZxL7jE4oKjZDkg76BGVef/n9ZNzl?=
 =?us-ascii?Q?r1NUQVlB4RNJcIUKAJIjtvje7V+C8T4FonXrnsrV1E+LG5UlouVZX9zA3b7C?=
 =?us-ascii?Q?armTllmTQ0TFlRAG6AYO4uUm8yNNjEKQ/g2fGCtInK5tPspgOVNiVBkUhCH/?=
 =?us-ascii?Q?N6amZTufAfB9q//heU1r6X1uFtZQpo7hnUD6g71VEiyMcYJgmyYylbDrd4HV?=
 =?us-ascii?Q?iYzYnwNnJS6PwLiJo5umZGn+Xr5+4O8Eal8dhFgZlANCdH+VVUnsOpA0aIes?=
 =?us-ascii?Q?quEfMUjkoIWAC32ni00oxHsX1/bf69nyLJvedZCi5ieoPiBi+iU6lQEYHeMt?=
 =?us-ascii?Q?UTm561wSwLQdmIc/MO1qjxN4viWTChyRasfdZE9ZjVmI7pQ5jXN5WkpD59I1?=
 =?us-ascii?Q?sWtpUUjqZI/Goa6RAnvzarkBN73xuuLdROYUrlPc1OZzZwDTsykHnRsKc5JM?=
 =?us-ascii?Q?H97Uf/0YF05eUMQXauk4dekc1kmreMpJVkicyrgmEsVcO58YEVKmPfloZlD3?=
 =?us-ascii?Q?S7d8uTDUA62BSuPm8y4KQs4cmb5/uB9BBSIs12maHT9Y2TZoTAtbLQjnEhdx?=
 =?us-ascii?Q?LajnK5ex3y3oJNj+pSZw2GJ3vySMK16tmWN3EQbFMfosLQNwH1V4r7zZeFU2?=
 =?us-ascii?Q?/Wj4Cl7R5QN5xM/R3lZ4vJ9oWLwKyes85/EgG51s6IL8g+ZAWryCwMFJZw9S?=
 =?us-ascii?Q?LQsZLfN0TCA1MLNha0qUcOH1gMUEENuo3GDUtk+jS2YOqC/3CkfzmcKeE/dS?=
 =?us-ascii?Q?gxWdgQpz9WZ23ojxOhtUTo3K//92kNUKWZ7+vUfAGckHcq1nTwOZFxgACxsj?=
 =?us-ascii?Q?9coeBmkpn7w6Lf/cS6OOgcxyMQPjM7vwJyOPQqp93RtHzsgw2MKDNR49se65?=
 =?us-ascii?Q?SJGJosxVo9KdDZPkR95L+NdU+FRxgs5w5oZLkXEdrKoRQXjZ8R093OfsgE4y?=
 =?us-ascii?Q?cqzDcoO7nyrqUIr2zEbIOmyVnZkgjJoCLK7gd4+N7g22TKW3Lm7Ah4ASJs0u?=
 =?us-ascii?Q?PPFLV7PGr2ecboCyoDw9EF//Q/HP6unrWTQoucW4ih9AE8cZaYX8j3qy5odW?=
 =?us-ascii?Q?hrs6JF1AfBQ5SSc9cowGiivMqjCQd3rDZbqihxKRQ+LqV9n9nK1K7G/koafV?=
 =?us-ascii?Q?D5B3S7lURUvao88Dopng2Tzn3MpUw/ao?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 09:05:48.0531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 750eda00-c859-4891-21a5-08dccbf79a05
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9251

On Thu, Aug 29, 2024 at 12:27:39AM +0100, Mark Brown wrote:
> As discussed extensively in the changelog for the addition of this
> syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
> existing mmap() and madvise() syscalls do not map entirely well onto the
> security requirements for guarded control stacks since they lead to
> windows where memory is allocated but not yet protected or stacks which
> are not properly and safely initialised. Instead a new syscall
> map_shadow_stack() has been defined which allocates and initialises a
> shadow stack page.
> 
> Implement this for arm64.  Two flags are provided, allowing applications
> to request that the stack be initialised with a valid cap token at the
> top of the stack and optionally also an end of stack marker above that.
> We support requesting an end of stack marker alone but since this is a
> NULL pointer it is indistinguishable from not initialising anything by
> itself.
> 
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>

