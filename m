Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2061.outbound.protection.outlook.com [40.107.241.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBD319F42F
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727972763; cv=fail; b=S+HbnYOqKlje5flf+VKi3M/NFL5mo2AoDW6BhqjeRsc1p8+5JdygZ/r21QqW+5N2asaEkfriQXPmz3iEqjjWQ37sVaZKMHbSv3oGjsULwFeO8gEuyZ6+AmIDJAYQbCTqdcq2Na4sFTrDEbkm7RWUbaIqNiozPpqgn+gY7dATXs8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727972763; c=relaxed/simple;
	bh=WWq1RvtrGZKMosG8DoAVsl8KpsVJqgyMTdM2sW9xVI8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTAV5K/bH3LuNgzgTCJAR+cv5eoqH7QmK795HKOZx60Ko757HMllOWEkNQvjkYHk7kbTWmj85dnqp0OpvEcGkpM9OTinxnYlCuFZ/6UhRNpQQHR6yFcmQPX8ckHhmGMZ5YFzmlMsi7QmtkJxme2SHApEq1ZwQ38etgMiQo60ltU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T729HnV1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T729HnV1; arc=fail smtp.client-ip=40.107.241.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T729HnV1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T729HnV1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sp/u15pPej/NdsyK/CRynHGKyk5z7+EE2J2am0vlOm3ZxBa9P1RoRVH9ec3iBokzt4E73gw/wxs+plq96g5qZLGO0BLxxZ+W0mP7BQA8F9tJH6IlxNysOXPQdr4V4Pa7RW2zTad3lLKqBWr47VaeIjJ53zB78zoH9r+Ivbjbk8QyBZat8GSJT1WCblT92USKNpwmsDCqAE7abE6UT8KctC+OPpSbKMeQ7JQ0q2dZpYTmQMXxdj9HsDGPKTMpp1XlOdsWa5P644/JdZNMrAk06nJ/tuWi9iEzvKYsOFFtYyawL8zWBrpGTIfJYab5e3n9/3lDJMo+7jVH46VnLsncaQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8bUP8pfbQz6muJqZlHMDu2399IoR6iXiLCJQPxtKjs=;
 b=iQ1n9WHB8053wPhdgVmQ/fNS1kkOo6i5yEmkQQ1M/u9TMqv+c7c5n0Zl20PaB1Q2KwddB/2omxoewo8cZTTgoJPF5DcuipQp0YIduSP/+7dAZ6075cIYcy3nyoknj4o1H69BTQOyLXa2KDo8sTGZq7p7pOk9TGomQBP7TqeJmkHx1CP3zT4qGpbgcDEVj8+Y9po1hZhA4PYFsVuou30iYBeq9o506NrHpzefTIv5rX0F47cX1PRqR6qI+6zlVen+9Ef4RVakw7P4wv6CzG+56vKIWS5y0SDcXYr1oEyjBtOhZAxmdxvOLjJuawT4/9Njr3v+M0825hIZ8vZ5AlDnNQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8bUP8pfbQz6muJqZlHMDu2399IoR6iXiLCJQPxtKjs=;
 b=T729HnV1d3YzZSFdybokhO/nxZhmgfEhNbWvg2OlXUtyjkCBEfRQ6CYUkn5AaP6RuixBBkAS9odU729qi4yu4QAvmiW//FvnKJVT3Z81KR+XGhQyptQi/FnucB22sX+/wTn0vILAXGjyf8zbudF/tMbE74UYcDs1v+A8SHTaUK0=
Received: from DB3PR06CA0021.eurprd06.prod.outlook.com (2603:10a6:8:1::34) by
 PA6PR08MB10527.eurprd08.prod.outlook.com (2603:10a6:102:3d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 16:25:55 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:8:1:cafe::a0) by DB3PR06CA0021.outlook.office365.com
 (2603:10a6:8:1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.17 via Frontend
 Transport; Thu, 3 Oct 2024 16:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8026.11 via
 Frontend Transport; Thu, 3 Oct 2024 16:25:55 +0000
Received: ("Tessian outbound bcce15e2414a:v473"); Thu, 03 Oct 2024 16:25:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 4e90799dea60ef9e
X-TessianGatewayMetadata: IF406E2NVOIFiXRMbuixlvdY0LfJgZR9AMmShAAlmhttGJfQeAYOYSCbZhYh2Ti+nmHbQBBe3HifxkkepticuSgFiZA2+glvO/u55hPCMAJrqK/14zh7nhcimx+xz18rBvCOz384enzWSWLP3e8yjw==
X-CR-MTA-TID: 64aa7808
Received: from L6f6aa0bf32e9.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7644A89E-DC81-43F0-9876-09150D533089.1;
	Thu, 03 Oct 2024 16:25:48 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L6f6aa0bf32e9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 03 Oct 2024 16:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUbYYsWhR5PBnawqSnkZON6nMJr9GqcHbnEjrZJLcKGaF52TVkVnWDPkcMqfp5ZWEoEIXamTJaJde1fdOKunjuqxUjWMrEsjCrHG7hu23VFS7UKKSkGwFaLHJqw+Lwo/JkikJLuDRWk14yraZz3jDAUWIe8QqJMnj0j18OOOkNTvfLXjmrkY7h42dQk235sYIJ2r9GN+AlK+1BiSSBWwHMb2d5tAMS7XzCnHGnbE/cu4u35hyKmZiiWMyDlStzqcyKLt50bK1PjJ0Cv4R8Oq7WvZByxkMCkmuzoqZ9pLsQfXAQBk7xxGMOglbf1hMjCwf2uFyx9+eRWiQrzpiU5akw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8bUP8pfbQz6muJqZlHMDu2399IoR6iXiLCJQPxtKjs=;
 b=ERsQT13DCust0Y//m7n3jtK1gDMcshDsRCtA8cIMPJ5Z0PKVDJY5f3vvtjUrSsPAg2FJxmDSLDYLsGlEXfAROBAi1k2ys7nlv/6/yd2FQ7+HXNC4oA8c8SKGLC5FS7bT0AyMlaHN2Fuln9aPpzmXKbhRdJCaXsidQYkz7M0VNR6yZkYzajA5pv3TPseVy2DR6uGl79y6pP5XVV9x1FWEmt7hQ5xLIE/VvwmUE2xiMksaOkyg90VNmvGiHXsOwZ59e/8iYvF/PXyDCCmtIwSeWderOgQsW2F0/9eD4MtX+HAuVk0xBja8R0rtIYdOdz9L5aTDviroRPySbBhc24I+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8bUP8pfbQz6muJqZlHMDu2399IoR6iXiLCJQPxtKjs=;
 b=T729HnV1d3YzZSFdybokhO/nxZhmgfEhNbWvg2OlXUtyjkCBEfRQ6CYUkn5AaP6RuixBBkAS9odU729qi4yu4QAvmiW//FvnKJVT3Z81KR+XGhQyptQi/FnucB22sX+/wTn0vILAXGjyf8zbudF/tMbE74UYcDs1v+A8SHTaUK0=
Received: from AM0PR08CA0004.eurprd08.prod.outlook.com (2603:10a6:208:d2::17)
 by DBBPR08MB10507.eurprd08.prod.outlook.com (2603:10a6:10:53a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 16:25:42 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:208:d2:cafe::64) by AM0PR08CA0004.outlook.office365.com
 (2603:10a6:208:d2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.17 via Frontend
 Transport; Thu, 3 Oct 2024 16:25:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 3 Oct 2024 16:25:42 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 3 Oct
 2024 16:25:41 +0000
Received: from arm.com (10.1.26.195) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Thu, 3 Oct 2024 16:25:40 +0000
Date: Thu, 3 Oct 2024 17:25:39 +0100
From: Yury Khrustalev <yury.khrustalev@arm.com>
To: Mark Brown <broonie@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, "James
 Morse" <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	"Arnd Bergmann" <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, Eric
 Biederman <ebiederm@xmission.com>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta <debug@rivosinc.com>,
	"Ard Biesheuvel" <ardb@kernel.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	"Kees Cook" <kees@kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Thiago Jung Bauermann
	<thiago.bauermann@linaro.org>, Ross Burton <ross.burton@arm.com>, "David
 Spickett" <david.spickett@arm.com>, Wilco Dijkstra <wilco.dijkstra@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v13 18/40] arm64/hwcap: Add hwcap for GCS
Message-ID: <Zv7Fg7BkP18O9CdS@arm.com>
References: <20241001-arm64-gcs-v13-0-222b78d87eee@kernel.org>
 <20241001-arm64-gcs-v13-18-222b78d87eee@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001-arm64-gcs-v13-18-222b78d87eee@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AMS0EPF000001B6:EE_|DBBPR08MB10507:EE_|DU6PEPF00009524:EE_|PA6PR08MB10527:EE_
X-MS-Office365-Filtering-Correlation-Id: ca88ebcf-39f9-4892-0ba4-08dce3c80e81
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?hP7p46UKxp2ySWE7jzcxYuYBJyVfWkRIHtdnwgcT7nr9bz2ll6nBMdoMjbq9?=
 =?us-ascii?Q?YqVp0YJy0qN3B6jzG1STi2rJInulzOOVt4/i6gG9qkEiUYs3VzFVmpPE+Kjl?=
 =?us-ascii?Q?Hx9TpAz1ynXEOskGxvbL9drKSNHhBCufatzPSoZS12JtA4xH+if9s96jGZE2?=
 =?us-ascii?Q?fd8L72ji/xuOU8xSFWWLhcUmeOSmqgav/vJXDhwWyOrqo4UoRi9vsvglQbZH?=
 =?us-ascii?Q?AqnvGsl8v0bUvPVxZ7FMJrhi67XMDt47S1MrKAAQuoRmpqIN832ErUosaKed?=
 =?us-ascii?Q?vDmMVsFY0QTNSXP9AIutjvaXVsiiOMWqJl9O1J8qIjrF8erHU8r5gDm9rjsD?=
 =?us-ascii?Q?m7RUcCW4UxhflJHaTauojOT8z9dnTo95meT5cIesTwFi0rQi+1ZEEF3vvKnj?=
 =?us-ascii?Q?SFqJzkOb9E4VG93ibkGGj8ovPfvu4Mc+RauauueiqMDSzFAwijGE6G1VdgH4?=
 =?us-ascii?Q?sxTPGDIyfnuciiPIK8Onav3hWWg+F+X6K3A3WyefZFCPh5oKy3OjqcRjEV9Z?=
 =?us-ascii?Q?f+/Tw9KM4F/9Wtsot8atK7sEy3mUB/kWkVv2WkAbz5g9JWr/PZ0rYpc555pw?=
 =?us-ascii?Q?kF5BBfJXLjegRwx132AJ1Vqc+2mF7WQ8BOfN6jk7bYcufPTe1LFApOxkFA9y?=
 =?us-ascii?Q?Nk3DM7zIfG0iGZZ0Rl3KwL7YGGDA7Z8LRu6SarhMUJ76DmIeLwiFQ54XwpD8?=
 =?us-ascii?Q?WhwMrN5JIqnItB32YhENIhkNaBhGAXpjgxmzTPM0uQakM11cns2Np7sJDMz8?=
 =?us-ascii?Q?2zJXbd4Andy4M4pA+OBUB9OK+XOVh3e18iQ1VG62vTxqlefJKKlNwWaxDXu4?=
 =?us-ascii?Q?h25vb25ucxIeJ8PF8iJ557J7l6OKMic7syjarHpywFkzhA9iXy74vKm1tWLT?=
 =?us-ascii?Q?55pHIrqOGrB+YZk7kYpJgN55WcH8+Ju02MxUFNDChfCC9UY/LIH5DelgBF9j?=
 =?us-ascii?Q?IZJloaTyPdWPYJm76MWMB6Rox7Dzg5vwExWk3eNZidtBiun88dpckOAZDTxQ?=
 =?us-ascii?Q?2SjESxrYPGfYDW09LCtrnB5YHC7YvqpGqZrpeEJ6yOuieCProFKyhLWCZBof?=
 =?us-ascii?Q?118hsuPMQnfnIQWJwAJ2k7isM/kha03nIvnSn3T5PL5J2D+zRj1bzJOFbZVa?=
 =?us-ascii?Q?hs5irVxunnI9Lq+fq8AfyarXjKeP8HL55fcDbYdjwQGw3G5wqyymjc71W1o5?=
 =?us-ascii?Q?S4G9llEvkIi8THCwHPKT08KimIOtPF1iy8gmXeSWE5UulZ7Bp+TvTIY6dOYC?=
 =?us-ascii?Q?Z4pjduByNtVopwI0vtRN/D+3P2RvaubuNfQquzF0fGEQTRCmogGfm3Fea2s7?=
 =?us-ascii?Q?DE0vV3wy9PjCqyCx4PVfhqQ5JeL/1BfVdyTJxKyQSxhVQ8ZOO5dE6RngAf8Z?=
 =?us-ascii?Q?kD9u/LBBpU7pX/4/985bZ9RVqo9F?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10507
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:208:d2::17];domain=AM0PR08CA0004.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2d6d03c8-dddd-40be-a3b0-08dce3c806bf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OoYjNa2mLjT3j4QKN7t5ZZ+E1QWHmzACXzWjbMNY56DWWEP1qQkxcFOSkILg?=
 =?us-ascii?Q?azTOYbI0lSCkqJotLXY4cA23NvyH6q/+yxrtEPPWTf5Y+smB13hjD3RLDvr+?=
 =?us-ascii?Q?ruUeboJXfkcKyFogTEgsdVkUTupgWjBnZN4AoF8VCvFvGH8UqkA+g3eD0utT?=
 =?us-ascii?Q?jN23ShvAufBbaSC4M+2ur9MWXC1Yu5sqYqwq/DQn6Wy4ZrUWNXMZCBfW3yAy?=
 =?us-ascii?Q?/nMBPEk9yDlYTGDTP2fi/FrTHlJOhMhbiDDgaD/D6JbdvEMnXurb/MQDpVwh?=
 =?us-ascii?Q?xJI/JlNJ0uMKOJWhFvg57fOORWVkHE5BrvyHsvOfIEmEkgo5/l4yWpoaincZ?=
 =?us-ascii?Q?i4v3YgifZVjbUaOvddHisUZKYSjI/QAWJ9fmQf80wsCgdqOap6vWgb4Q+/D8?=
 =?us-ascii?Q?ENa/2mn/gtnUhEZD+sXyl84tzsZCqzSxAyEYUkVR5rIVDALtBZtU3enQ6RoP?=
 =?us-ascii?Q?gvOuBlYjWNT+HABSFxS09t0ba8wSG7edjHMqToKY+jpV0EyAWwdixrKP4Gcj?=
 =?us-ascii?Q?s6mVk2Ku2HusUFFQzI9oLrIx8dYF6MRXfs/3vegN+8iLUL5zcpcB13p0LfPO?=
 =?us-ascii?Q?iYekOsZDMsgdGwVpHQ1EyEIsxCU6dKtp+T3Zy78d/GgDnTBcwDWiVNcJa5GJ?=
 =?us-ascii?Q?OogiDo4z8tLzS24bkHe4PGNKwJgy4xDSFHDCcHaXkRlJ0EPMC1NZ15za9LoK?=
 =?us-ascii?Q?owM+Pdil5jbNT/w4CSCMJ69K5k7FFm4bZn3Mq6cAuj0vkKBcXp4VWifegpti?=
 =?us-ascii?Q?72OfOevhuA90C2ov+R9VUi6KVs/p/5aXECvK86lmQjx4IGJ+L9P/Hpl53p40?=
 =?us-ascii?Q?l1/ffT6ceB2HPB0thkl2JVf8NG65RifTGWnkQa0Qm2VugvHLGlwbxY+uF7eP?=
 =?us-ascii?Q?+tJ+DSY0HGfsOZVsB1h7OYOA7DVwBMeV1t3M4FLINa/F9idA/d/HhF8wDkmC?=
 =?us-ascii?Q?3iwr6YT8+13hvJo/Mj3SmVof8n1fkj7uSv3BUWKzEAon1uIM3T0hzM5v3cLq?=
 =?us-ascii?Q?0+AvLBC20HvEHY9CmewTCfOA6f4Ys+zObtPf1QvpSv+XveTpEeYt9ptjlKtl?=
 =?us-ascii?Q?ox9ObxPFt5jkj5Qu2GS6NKeFb4jAy+mrG4c3MtQSeZUpHItDhzVqdVCFC9T0?=
 =?us-ascii?Q?1sIFwgYqNq7BPTxbKT6cB+LonCm2No3jIWPueYT8Wn2ZtDvyJdUH6lFNiuBD?=
 =?us-ascii?Q?Nc+mogwg61hTcPwqt6/f52QhDxws4fuiwHDwx74eUlOFEQpk5rZg9yX8sDE7?=
 =?us-ascii?Q?9GvuFM9H4okoyy5WZ8ieLSMkCYy6Jou351cZZV4LOJD+Y6+0I1RmlM8geFYx?=
 =?us-ascii?Q?rKc4bDF1W/uwPZ2hrhqocKawZVCFACK2otaPFKQoX6EwwO8uHzdknU2vZ47J?=
 =?us-ascii?Q?32zqYqXosQMPWJ3ZHPohU+B/+ntA?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 16:25:55.5132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca88ebcf-39f9-4892-0ba4-08dce3c80e81
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10527

On Tue, Oct 01, 2024 at 11:58:57PM +0100, Mark Brown wrote:
> Provide a hwcap to enable userspace to detect support for GCS.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
>  #define HWCAP_PACA		(1 << 30)
>  #define HWCAP_PACG		(1UL << 31)
> +#define HWCAP_GCS		(1UL << 32)
>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>

