Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2069.outbound.protection.outlook.com [40.107.103.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C21C7677
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 09:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.103.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354272; cv=fail; b=gHVaZOsacPnBzX63rRdjKBaz+ZwAsZxDjHGz8E2biHXIPhLts9ES8grOv7QmBkbZrFr/m6DctNZl85MMFJzo+2P6893v1xK/yfN6UcbAiWY50o6z6cjx54kAHJ/yWe1oiIJScYrypft6CTjaH3EbM10i9bEDjc4yjtKM0mmWCkI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354272; c=relaxed/simple;
	bh=20VxUN1hdqgGvJVVJYLFP4Uqv6Jh/e/DuOr3frCcEJs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNkXUttQFzatwIA+bxDbk5x3H9NW6gF5OfO/sj9paWJws92DHk1/1LRQQ6Kq0d+bBFhsUG0c//D8fS4Ju+hLBU0/bVV2yoyXLIn8jEb+vryw3tQViXPX2ozvBEmnkCtfH6lg5BnXjAIM9D+77PMJmvAC14NKbVgAo9lTKRqM4ko=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyTZ3ao5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyTZ3ao5; arc=fail smtp.client-ip=40.107.103.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyTZ3ao5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyTZ3ao5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kqG8I/mTG2RPIWTwQR9g9M8Yy5xT2Fg/MKKXgyLFR61kbGDtXtNKMC3a+oMW60Ly48C7EnQ06d5Ha9Mao4OQlFvqw+lk+5I9/5wNxgO15Sx2trluLW0DgEcnrO2PzXq3huNzYO3NKfiHW97803JYahEpqug27heCvJ4ztiBqOrehMaXXLJTw/PiVqBtXbrQ//UkC1mssfpQ2d1TZ6YdqEosrNGcCzqqgJKVh5T8NVnWyZV82YjSgnCZeLby2Vr8Busht7kLPC61va5kpZWCe3DChIvQMC1IsN4MtDcmyztZ5j7hkckSWjtp6kdk2Fm3T4//BYAtRkT5Lz6Rj6FKh8g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5r9xHQHG+scXrr2lbtrROl2d6zj7h3adAv4PeUbXxA=;
 b=dqeHT87pifPymqSCsjTKsxHCw4q50zf7QeDxj3qmaZ+EVou7XKkpUUoFGCPTpfjU6GSVo7egAmnBzmabIr9qag3VeWgwx8XhFDTn4azete2PUWLREIF7ulOzRzJLLhLfS8BQ0Wv6GE+otwO4ZNQe4xVxM9AHJucX1gOUdhNK1ZP+QalvVCd0qHYQLwZosSdfElOGz5Pnid13qkeXWh4vBrPhPycqGDBFlayOZcUa2qalE0sRvsiY7KgpdgaFEB6oJbYVI3DsjTCmyBztKz0BGF4xwVO7KYh1ARkC6bDkC0CjxrxxR5hMz04hiYHF2JwDGi6mQPwaHLvRkckh0lKAMQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5r9xHQHG+scXrr2lbtrROl2d6zj7h3adAv4PeUbXxA=;
 b=UyTZ3ao5fXyaGax8FnJq72YkUOJ+jfUV3TvBMEEBDFpQ59EzfXHSGOqt2+pu2mPEPi9HObaBicA6R4BfbGM1Qd2H3qHq04wQX9hdYmNFGjiNMG+h5poaLx0qWAJlw3cApixdihqFJvYCPrd1npvnczn9fKtqMnG/rcd7lvggL34=
Received: from AS4P195CA0021.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::9)
 by PA4PR08MB6174.eurprd08.prod.outlook.com (2603:10a6:102:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 09:04:23 +0000
Received: from AM4PEPF00027A61.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::5d) by AS4P195CA0021.outlook.office365.com
 (2603:10a6:20b:5d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26 via Frontend
 Transport; Tue, 3 Sep 2024 09:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00027A61.mail.protection.outlook.com (10.167.16.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 3 Sep 2024 09:04:23 +0000
Received: ("Tessian outbound 7d86ec5dfeb5:v403"); Tue, 03 Sep 2024 09:04:23 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 80ad58ed9b07736d
X-CR-MTA-TID: 64aa7808
Received: from L9b17469c2d2f.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 347FD1DC-81CC-4A6F-9EB7-015C880B5A28.1;
	Tue, 03 Sep 2024 09:04:17 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L9b17469c2d2f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 03 Sep 2024 09:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CGnSc1tcK1mWJ5kalmbTGs6wPcIQgHIZTsHCQLt4DRB4b5BNcC19lPN4QGqwgL5faDT+kOouF8v0MRzD4HyEpI3vT1vj+pGw7ZD3GyKPKW1utzHMJTT6l13sjg/z5Nh9VlDsQFDKXxx1gWHQZd8k1WfafLSMmQvk/2F4sb3ZUAc50IzQ/pIFJYWv/Y6aiK34oRN/+26hb9djKq5SNKDWBzuqBIoYkAsXSMCOOT/MEyltptBzTvCU8wl2qrD1QEQ3dhrSJa1c7aYWIL4cuDQ85+6zd6o57sTffG3lqG0o6+WTJGdgvHs9OU4UQAygL7yq8lwFhQa2dycIOknQOSzyPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5r9xHQHG+scXrr2lbtrROl2d6zj7h3adAv4PeUbXxA=;
 b=EK0zmy27VTjj5wU/9TCYZ89FU0lnlhEzKptsAfJtgbruaa/VHLWROd8SdNZe5wPbUgm+aKU7KR1x7aXf6QfneSbQix9DgPCFvFrlwBdED0k4cBp7eFn559eeHymC8MabUpCBqWJGp4JySQMTRnLii9pl6a9oHvoOfgU8pgb1fKkz6kSbh444dg9iJLyor2VOZepcHRZnEQSeYyNskbGXs8I0IbqQqvfkPtHWd/0ANgTxuY/UPJhxmd+e94DDaU08eLHmo2rPCKKQSxdViO/NUTpsJ6QhVHYgHKeGffZPasNAHyzFvBqFt8Am2l9ufefrIsYuksalVIVhBYHb7l3rGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5r9xHQHG+scXrr2lbtrROl2d6zj7h3adAv4PeUbXxA=;
 b=UyTZ3ao5fXyaGax8FnJq72YkUOJ+jfUV3TvBMEEBDFpQ59EzfXHSGOqt2+pu2mPEPi9HObaBicA6R4BfbGM1Qd2H3qHq04wQX9hdYmNFGjiNMG+h5poaLx0qWAJlw3cApixdihqFJvYCPrd1npvnczn9fKtqMnG/rcd7lvggL34=
Received: from AS9PR07CA0041.eurprd07.prod.outlook.com (2603:10a6:20b:46b::28)
 by AM0PR08MB5460.eurprd08.prod.outlook.com (2603:10a6:208:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12; Tue, 3 Sep
 2024 09:04:12 +0000
Received: from AMS0EPF0000019B.eurprd05.prod.outlook.com
 (2603:10a6:20b:46b:cafe::e7) by AS9PR07CA0041.outlook.office365.com
 (2603:10a6:20b:46b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.13 via Frontend
 Transport; Tue, 3 Sep 2024 09:04:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AMS0EPF0000019B.mail.protection.outlook.com (10.167.16.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 09:04:12 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 09:04:05 +0000
Received: from arm.com (10.1.28.157) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Tue, 3 Sep 2024 09:04:04 +0000
Date: Tue, 3 Sep 2024 10:04:03 +0100
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
Subject: Re: [PATCH v12 21/39] arm64/gcs: Ensure that new threads have a GCS
Message-ID: <ZtbRA6SUWjo-WTO2@arm.com>
References: <20240829-arm64-gcs-v12-21-42fec947436a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829-arm64-gcs-v12-21-42fec947436a@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AMS0EPF0000019B:EE_|AM0PR08MB5460:EE_|AM4PEPF00027A61:EE_|PA4PR08MB6174:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a4475e0-4411-49d9-81fc-08dccbf767c5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?Sz8qv7zs7o6n0qixkEqGeIyau7O4NlbbTN+sbG91v3+nFVpbgoDhMckdSs79?=
 =?us-ascii?Q?+1qAGjnDGwd9P1KiCuwnXB9NThmQy16eVxA64IGKj19QFNciXYC+SAdW359A?=
 =?us-ascii?Q?81O/P+SUgcqURGW5V1TWjaCZEWvwZeAieBoB2VYG8P19/MhCEWR/CkGmPTRX?=
 =?us-ascii?Q?hxBX9uOecY3yZFzspKU1mibpCv4RdSOdRvH3+TuJ7CEM5vWFv0+UZX5oM1Mu?=
 =?us-ascii?Q?9BLiWurFQQchLA5HyD6PWdYIgActaqCE5lVbtZFTdcn4qVdavHE5u17qCmeR?=
 =?us-ascii?Q?BeyeuvbUjZpiR/Uw0G0b5EEKwkTHvonW2BXRhUsV9ozTUVIEtF5qmxNj+LhY?=
 =?us-ascii?Q?O9HJYDLg4yW1rWlYe/SGLpht1eiPq8AyydGhtzJhTz9xH34n4nH7MG1rU/cs?=
 =?us-ascii?Q?Ah3vLkUt+vKXrWTX+yJG9DGoibBJGfI+3/eu5yH0dNJbL/S6MBJlLi76TB8C?=
 =?us-ascii?Q?n4lkBSDvOJvzgURLCnsoTzF9iaiB+LmbJyby1WR3D/L6o1j40bY7oq50+7k3?=
 =?us-ascii?Q?Dap+Rwtk+dbs3d5lJSQ7uZFGJR95OrHiTXBFdKyyo0C+GsJxevjmx5UX6+o4?=
 =?us-ascii?Q?qpcud/mCtDCZwS6gFCFo6UXpLC0FsWN/zUHslcYHHmfNWQ4ke2KBeAT+gkN6?=
 =?us-ascii?Q?+Q02ZrOfcfEkLRs+WA8RB3OS/5890whhX3LsS8ZOai98vmIsm1reWZRkWgoz?=
 =?us-ascii?Q?V+IkreOU9kEK7sxYZ7P5uzEb5dXUn6nIhyQALR7ojaXKjku3s5LxORdm5/hZ?=
 =?us-ascii?Q?o/xeYtlon4vL/9ByLkNjgS290gzQGTnupyZOqlGXl/409xkT/RdydBLScWKl?=
 =?us-ascii?Q?QltOMTZU1KFQZqcEA+io16WlNwP9PCwgkysi1dWQzqCvp9/s5WHR9Xs5Ciq8?=
 =?us-ascii?Q?h8PeB98bsPNnPtMIcb54rdKat0J2jdWEDu3HljjAolisiFYIzXgiXFZIHyp2?=
 =?us-ascii?Q?07Gahim3WYlgj9a7cfnv3E6uxWTIaqNKISX3Ln5rDM4TbIH4kjXDqRPlsH7R?=
 =?us-ascii?Q?zbwgDI3KtX9CHtYJDKCFzPUcK2XdiqKbcdKa1in/fkLMkmu0YmZNaiJ5PY0B?=
 =?us-ascii?Q?bZZDiWRYjlEZgY1hnET0AJN4DV7SIWHSjr6O8Ty4A7oNXXjRH4hWQsB2pD5T?=
 =?us-ascii?Q?796Ira+XbZHozsw09BaHvwkkuq6e/UPqMBHqFa/EqeChu7JTiU2xAgO+rdAg?=
 =?us-ascii?Q?LESqxThbpeJuNrFXGUzemoozvYRu1ffHV9RJvWcDhGijqIS2S3OMSJHl6ark?=
 =?us-ascii?Q?X3s9K8W2JM7kum0pCVYyxF0sgThQr1aw/irAQwqRoATrgDfHDz00vtknDNGa?=
 =?us-ascii?Q?GqdLPLsZf5NbduMS874QU6OpNLtUVucaRol/V7kxiwvcJyiwdFDsUuFkHLz2?=
 =?us-ascii?Q?/7HAI0FJsGeBXOGRL8ZwUfqaghHw9NNgNRlwietq589CkeCRpeG6cJptAAd4?=
 =?us-ascii?Q?ZLBCnX1WmlkS0NBzarSA7fRsEddgAc2D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5460
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:20b:46b::28];domain=AS9PR07CA0041.eurprd07.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f68233a2-0c1a-4af8-2748-08dccbf76132
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?koE/RFTvWwaF0MeTy4Z/IJwKYj6K/4wfEDUqIXvmxMLiAWZ4g/Ue6GIayI5E?=
 =?us-ascii?Q?C2sU8Slm+BWrJpObeQNQnFhBnWMYiy9RjszNtOWvMMwKkTJ9rYj8dx0+8Om6?=
 =?us-ascii?Q?OTLFoBjfkKb8VVhC9IIy7X9Lg98VavpuMErCkz78kvqFFanWwCpnIiLaAvv9?=
 =?us-ascii?Q?Qv2Xgo0nkJ55sVF89ApsuknYzAs6NTeUSdWrNFGW2Xb2Ig84bR097r9OUuEV?=
 =?us-ascii?Q?qa8xQukkuBiqQeBkfjcTvG0xcA21aYadkZptx0Mkv79n856GRqpyeDNLN6hf?=
 =?us-ascii?Q?vIWzOuynyjFmAef+8LXDX7p9o1/im6LAjA8WqRU8uTICxWGxRzdQeEHLaMKi?=
 =?us-ascii?Q?N1OrRLAGD/8QsdLeFufvlNLwilo4W+mutEFqpzJgCVrA8tMRHgONVpLhVJhQ?=
 =?us-ascii?Q?O+BZPm85ZygziKX57zqoltUCt5/uYzk3hq46GW4umftcJdxsYOqI0EKCSs+m?=
 =?us-ascii?Q?1CdHJ4HKXwa/wR8ORA2WQxlNmjiNAagZiQzIiPEX9G6wDqIqz7L6epTfKKgz?=
 =?us-ascii?Q?STXFaGZQvnmtukvSmG0b0g0PPjKeYxgapuUdgaX/DXaDjmjgqGwigYQ0kVx0?=
 =?us-ascii?Q?EmCa89G33sugLs7V0rFNWnwv9FW1/cPJyCQCk53QVW7a1xu+OUcrAs4eIYMA?=
 =?us-ascii?Q?6cLy+t3X2i7I93yTLEW/8KgzolJq8QjggnBr4b6bU2YI9Vps8jxd6Gh2AgY/?=
 =?us-ascii?Q?/U4EWsrLPdRwh6myJmYtyPylw/MRaNmdTCC59mhTlS2D4snOEJPIgMy2OK2l?=
 =?us-ascii?Q?hxX3dNxqjMQwGnKnjWlrRru3DtZHByJjSnQyVn68+A0c3c22Ui2qSitac4/H?=
 =?us-ascii?Q?aukOKCB3bKWyW1eu6QKnNNKh+KxGoHwXuPxLpM8vGFUdVHAunr6nM0XbSa8H?=
 =?us-ascii?Q?t6DoilXMoOumNe/WHRluwK5CmSHnbQ+Zb8glc60egJu7atWuiZJg+dF+1zXP?=
 =?us-ascii?Q?5bomp05JJ6/iS+8x3n3lgP6UPIwbjS8pE/eCdAutUCWgVLKhf379HJbU88n7?=
 =?us-ascii?Q?MBlSVonA88I7lMuL3ZZ/ifnnmCjN+oTlyutHw1AdEsk3CH585edFtXC3STqt?=
 =?us-ascii?Q?DGnNqScazBULR5JHTozNFHPP1O8/sSy8y0uKqOn3wxjGqICRQ24Zo/jEFfl3?=
 =?us-ascii?Q?DmgJgjU3VHKS3z1TTHROn192slafL+kKbIAI5T/f4j5Z4F6jYnpXKyzciDDF?=
 =?us-ascii?Q?rpZqWBZVPdtl1AxQTlcLjhFvrUVKmyIW8jTlt1wTdclriO7vMDABssWF2A9s?=
 =?us-ascii?Q?fAXEkh55vl6WEbrgNHIiktEh0n6SaMB9DWKo0hV55i1TtnD7z8kgOPXo8VmU?=
 =?us-ascii?Q?JNTcJwe4g29UnSAmKZJq7OZKxCall2d5Ht6ilWOMuA+6hUr/xu3hG0nm4J2Q?=
 =?us-ascii?Q?2/oa3OwkNZ64Y7ktqvknbCwCbSvEtRAICWobUHR1Cr/SVix5jX45SFogPdEL?=
 =?us-ascii?Q?VDGWObU0kghVGjcLwwZC1Z+nibycNfGh?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 09:04:23.7500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4475e0-4411-49d9-81fc-08dccbf767c5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6174

On Thu, Aug 29, 2024 at 12:27:37AM +0100, Mark Brown wrote:
> When a new thread is created by a thread with GCS enabled the GCS needs
> to be specified along with the regular stack.
> 
> Unfortunately plain clone() is not extensible and existing clone3()
> users will not specify a stack so all existing code would be broken if
> we mandated specifying the stack explicitly.  For compatibility with
> these cases and also x86 (which did not initially implement clone3()
> support for shadow stacks) if no GCS is specified we will allocate one
> so when a thread is created which has GCS enabled allocate one for it.
> We follow the extensively discussed x86 implementation and allocate
> min(RLIMIT_STACK, 2G).  Since the GCS only stores the call stack and not
> any variables this should be more than sufficient for most applications.
> 
> GCSs allocated via this mechanism will be freed when the thread exits.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>

