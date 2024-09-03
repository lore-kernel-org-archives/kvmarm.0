Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2070.outbound.protection.outlook.com [40.107.105.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA81C7681
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 08:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353992; cv=fail; b=NjH/ushzA5GKb3LInloDS69t0RR7oQEaN0zsqArhzkGlVHBYrNdxbeiv8FB40t6ByG8Dp+ZFwZo4uVpMNzs0pkhubAjekFdEx0zdYuqBC3Uzfg+BjMTqKNaFpz/wYXI4cDL1c4jaoaK2dBMd9TXZPG+Xwr2Dw/j9DEatmrYPKhM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353992; c=relaxed/simple;
	bh=QVZDicLIIDEh8+UxaII1b9Rmx0hQ2PQ1aPBNmVPVewQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL7YwdD2L5TtHiofg0Fh36b9GQlAvBpK5hL6OHEt4ASmpAmYrQZEB8z8hZW6u2ix/tNH6KcxUBO7VDUKGSxFaZjU+2VUdoEEBR0VbG8fzqUlfcLPjCw1esuOL9ZH60GAKcrAOm7GmellOULtePmj5nBmiqX+gCiQY/mWibEz5vw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OtMx3czd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OtMx3czd; arc=fail smtp.client-ip=40.107.105.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OtMx3czd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OtMx3czd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lX5WIJzM1LAAglb/2ABhEbuI/EAYhwfhWYGiuA1APx82uQWIzKEb5qlB5D/RSQHk1A94gHhw9/CQgG8wjW/DLaDJkbNS0Qjfi1SYPhiFfMES9Jc1uKFkMs6VhBrjhpMqe2Dy4YNLpS+sQJOa0ZHEWFPwFFxyHHhP5lNvpo05NouLYS62YL3N7sDW8mfnEssT4w+qSnTY4Y2Uu0uNFpWtzxpTyR9sRo1MiSCR808gLaEReqRnIJG/mFa3Kiabz4gS/1Ic4k+W4kqOPc5hq6Oe/Ue6IiYIAxV2EkMNjmRcDFmR10Lr1M7sqVKQfCnIlNnMq8tY9wd0EkHx+SVjgMSpQg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/SgidYbx5KvfjOVnSHraJQCl9k5fI/hYvTUxgdL9mU=;
 b=ZfBYyvZhCQYNubqx7B3gO7Ug+GBaSq8Zftd2HFS26MufLPDecVws2Iab546jCrI79FO5199n6bb0vBrGOF3GdH/ZMLNa66uvlbYbgij1INgy2xNikkD9htRrDKG4ZgPlwC9vx816Suoart1B8XFd9iKyNKr4dGKrszK05OmdymM/Hlu+GJNyWYwOut8Bdnzc+fegP5sjnASX5INCtKgijKOlA+IVv8g+TVH9UTqTUZ+z4LUO1sszYs+SOzBwJzCxBmPIlqA2BQAYPL7fGboUw5iHzdnk3IRlqUXW66aJXz+bPHH5oc1bjR5DSjgP19yuIN6dkk/L6ZrSNpZyvMOsTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/SgidYbx5KvfjOVnSHraJQCl9k5fI/hYvTUxgdL9mU=;
 b=OtMx3czdVb2Aw8M0JAM6+ZWAxgIZM6HeSILRpmc9IhLlRCF0o7pZg3V7GUB5gcrdsyNaQIbMW/c2VEimWcGgz5y0M4ndpjqOIRj1rKmYXLLTWU4FsUpxmsSsuFURmc6cN4VVj4MutzEDPguhjus8di8HsgDZMK5SURR+b4DkZPw=
Received: from DU7P250CA0014.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::8) by
 AM9PR08MB5890.eurprd08.prod.outlook.com (2603:10a6:20b:281::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.13; Tue, 3 Sep
 2024 08:59:45 +0000
Received: from DB3PEPF00008860.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::89) by DU7P250CA0014.outlook.office365.com
 (2603:10a6:10:54f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25 via Frontend
 Transport; Tue, 3 Sep 2024 08:59:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB3PEPF00008860.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 3 Sep 2024 08:59:44 +0000
Received: ("Tessian outbound bc251c670828:v403"); Tue, 03 Sep 2024 08:59:43 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3658db58a5709976
X-CR-MTA-TID: 64aa7808
Received: from Lf3bdea9c928f.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id C0D68F0C-EBEB-4E1A-BD63-AA6D48D2C02F.1;
	Tue, 03 Sep 2024 08:59:38 +0000
Received: from EUR03-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lf3bdea9c928f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 03 Sep 2024 08:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJAO6HjuZvBj0WhuuQQLFo5LrBmkPWJNuMR4wBGTkk8xD1vvA4kDWzniShXAKjAg6Ly+Y5EgKfO+6/We8XLjFUwrWPv9I7ZmJiwylPUIvQtl+CZrH+2EHYxaAzYww4D/DRjevhkryptYcRnWwu7ioUpS4fcMHa88wvHp8xNSRf/QWJq3pq6d9iDAsaML5UjbfKhuMyC+H7yDNBYmVfA+9ilXysrI6+unWCvaPgS9OWKd4vjhf52T7YzW4rZJ48zUwrVU47+OpkjulVG7oAQ+C8cNc+oXUjIAxtyIO+7pI7ChRnno7wxXEubCGZ0HMikcDGMhayJaUhcXXBz47Jv/dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/SgidYbx5KvfjOVnSHraJQCl9k5fI/hYvTUxgdL9mU=;
 b=trlX37pqjgsg2d/zJczs4er33StYZgec7hC/KfpQ55lSy/MI5io4OIQIagtAXxH5UrggZYcn4Rt/A27B9ni08ZtrTMbOoH8jjwEaqQaVv1R+AgtpiudJrlgQQ/L4vTs0t0LuyeDKr1IVyBdxl8o1+YOdGp/2FwJDtmFsr0HKgYI+rho4U9n4BeKhdJX+F26sGfS+PHjTLFurC/dCqb2AKIquC7YzzPPqUP0I7X0x/nqnCkRKQweSQ7R7pS4RztPZlpH53r1G6JFqs4arUOFdjjdaKwGpafyPqhDoUdEYGG97oyNmv5dkbitSQM/7TrRmsqvGqJE6Erk6OceAu1ZODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/SgidYbx5KvfjOVnSHraJQCl9k5fI/hYvTUxgdL9mU=;
 b=OtMx3czdVb2Aw8M0JAM6+ZWAxgIZM6HeSILRpmc9IhLlRCF0o7pZg3V7GUB5gcrdsyNaQIbMW/c2VEimWcGgz5y0M4ndpjqOIRj1rKmYXLLTWU4FsUpxmsSsuFURmc6cN4VVj4MutzEDPguhjus8di8HsgDZMK5SURR+b4DkZPw=
Received: from AS4P192CA0036.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::29)
 by AS4PR08MB7506.eurprd08.prod.outlook.com (2603:10a6:20b:4f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 08:59:30 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:658:cafe::74) by AS4P192CA0036.outlook.office365.com
 (2603:10a6:20b:658::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26 via Frontend
 Transport; Tue, 3 Sep 2024 08:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:59:30 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 08:59:30 +0000
Received: from arm.com (10.1.28.157) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Tue, 3 Sep 2024 08:59:29 +0000
Date: Tue, 3 Sep 2024 09:59:28 +0100
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
Subject: Re: [PATCH v12 6/39] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <ZtbP8CAOPDanw6-o@arm.com>
References: <20240829-arm64-gcs-v12-6-42fec947436a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829-arm64-gcs-v12-6-42fec947436a@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM1PEPF000252E1:EE_|AS4PR08MB7506:EE_|DB3PEPF00008860:EE_|AM9PR08MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f0d9d09-93fb-47f7-555a-08dccbf6c146
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?w7uhcZb5zn+2LXSvvsvj+/E7Z22yrs8NNEKAVHq4yKJKs1guieTgBIGjpulO?=
 =?us-ascii?Q?rvHV4ceJ4Ihmg22eG+NK4vPhxyxhE8dbcia/yu2Vt15ORtsPzeRu6A4535eN?=
 =?us-ascii?Q?QssdCgUnuAvFpk4vFAcAQ2pyDb4bmwnPELaNOT2lZywGL2Abx/LaYOHGlFzE?=
 =?us-ascii?Q?4yJUnsJdNz3MzQz1M9gn4EYGkmpV4MaDGyfLijphu80ckMfCnqrYVFZiSK/J?=
 =?us-ascii?Q?hr/jhXPuww+392aO/d+ZN2qp9IFYHoJ5MzQ04o7OQKc2jHwhYf7Dhro48OVK?=
 =?us-ascii?Q?uLhb/4hzVzAFK0msteuZ+6VP/sDTeGMLNwwDT5gcor0rVBzsRtWlKDUc2+A+?=
 =?us-ascii?Q?asCRxwFmjvQ0FuTm7wvJn1S9DIyY4AQDtRVTyIPW7WfUL7UXXYf2vUGQqU7f?=
 =?us-ascii?Q?Cbe+VVh6smpQQ6XfxtyudNMVUfLtNTlOUTCZMcOMP1ci+knk5RSnsG0faFij?=
 =?us-ascii?Q?IC7VUjdtUtHMytA1y22dVWaePT2BdD4WzlLrAkfKzNM6Tp4jUpbuqP5X2Qc/?=
 =?us-ascii?Q?KkMm/bCdpM90ftTckZz4S9aipk+/ExDmAZf+woOK5udCDv/gaoPDkFBuufow?=
 =?us-ascii?Q?gjG+o1Wom+aGah8BDrEucFsoiY6/LG/W1kYeZvAZGrXVA/VrNuS6T0x5miwY?=
 =?us-ascii?Q?EicsO3EIkoAsTEcpJHN3WshRYVFJ89erCsxXt13LnNlzg97R2a7cDDcTf1KW?=
 =?us-ascii?Q?ERhllegIU8XVKeeoWmxhlrZ8ripA50Y/gjaoDuHeu9Wdd47XFf3+CEcZLdI/?=
 =?us-ascii?Q?NKZlcjpyTz4/ZjxVZjWjx4EM0joyPXcDmHhxfTh/eC88/iT8+ldDM8iR367P?=
 =?us-ascii?Q?wYR1/7yVy+isPGU9Wmcimnz6J3jgKsPZ/JmK/5o0I3oixa7n8sB15KDxBVpq?=
 =?us-ascii?Q?/fe7uZP6TDq2OW0ZKlk23LGrIVGvogwdGqMVbOtJSMJScW67lgRLiLrnUoUV?=
 =?us-ascii?Q?3JJqyc3WH//EiFa4vpDquK+Ea98jFvZOpXlPowQnYDQe36Br0XXAkNA+Kmyc?=
 =?us-ascii?Q?anoOcShnEKHozDQKh2r8RyuubbsmiOzZm3Cyy72shmIuZX3vzVOdlvt1q6p4?=
 =?us-ascii?Q?qEIasn70Ae1nkImpMDv45EuoW529pGAJkIQTXdI2wL0XdFStOYHxgF4PO5z8?=
 =?us-ascii?Q?1rrq2Jn14Eczl0wOPzqdSOZyevXv1BYhoXki6WwwTIZ9Fip1sl7HG3db+S84?=
 =?us-ascii?Q?1NbJxe5RNtbs+6Erk2mV/TMXI96VXurlHUayCjNdWlem+9EQmAyN+6iWO0dJ?=
 =?us-ascii?Q?srqbCy8PG4pxWKlbIE3IjzNwNGBVfgv1RM3nVN3aB3+QEx/pFuv4TDJ6cMQO?=
 =?us-ascii?Q?oPCdex33MuvjVxcYAOobV0BOMVxy0Zu01KgMj00CQlLrSygrc4+hv/tSsw11?=
 =?us-ascii?Q?Hanis2BGdUKqnMaUJI1DTkcazc8Xv4uRQ8QLUzFIufws8c06iYbPvAVZWryt?=
 =?us-ascii?Q?pladoRTL4Jc+F3NH2j9Vwr4+H13ggXgB?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7506
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:20b:658::29];domain=AS4P192CA0036.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0f4d5341-ad86-43b8-ac0f-08dccbf6b919
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q/TrT2Vd1g2iKilDvdzAcO7QmmfjlXiYMKwAqeMYb5rbs96aPDneu1JPT3ZR?=
 =?us-ascii?Q?tkGuPpauLGq697Usa25yEnCVPf/IGS+gRUDA7oMBZ1vPhjYbQyd6V0TzRVnU?=
 =?us-ascii?Q?ofqaWvm1jj57LoustmKwd86gWj0HYe3fxydsz4kUVszOGq9Iyh9oVJ9nE/3G?=
 =?us-ascii?Q?oh4nkGZfF/ip6MS+f67baNHvldOeLP2VDWisZ5oMK1MUoG5rsJURkXgPqolp?=
 =?us-ascii?Q?y5tDQ2lKDDBTpE2xQurLkYgdhKeWQ+loGaAEsjAY1IFxweh1XhWl5RtsZBKu?=
 =?us-ascii?Q?Vh9KUdDhFSKT/xFTFmSMxDuN7HZWI5ZivCK21WdYLQTgtH719NNjLIBL3Jjg?=
 =?us-ascii?Q?/pmcz7bRh+LXs9WmNkp66vzX25Zkc4NTzatIgo2w4++N6j+SuSwuyxVbb2YB?=
 =?us-ascii?Q?QMZvAl+L6lDqlAD5hvrBmfbbPdzmTca+7jsOWlqSyA4qNnCzjoZeSWwn2K1p?=
 =?us-ascii?Q?v1zYXZRa+FUE45bJM53Jgmv32agjE2+g+WdjsWV/1NzOBEIbsV6cLXLsNiJ4?=
 =?us-ascii?Q?v3Q4ymn9Bbc1cA/mtf4KoYwWgpX5IDe6ceL2G+YAixsWOXYozvgjz1etdMAU?=
 =?us-ascii?Q?K0ZygJaHN51PoMUvy11ZaXU7ZmmYhYf3tKCBl9LTGOWbTMB+GAPyjDMjOdbZ?=
 =?us-ascii?Q?5dMEmOjQ+U4oHACrOFQf6h9iWDxJhbE2bP2bG/0qF/amD1i2CZVtOxyCt7Wp?=
 =?us-ascii?Q?RfF6ZO3CvSB7SUHXpCx/s5Q1qdrkfgIKzkT4HEZLD59/l9/8g/ujkO41Hdj+?=
 =?us-ascii?Q?VpKRG56YS5WJN6nGorrQYd6rDV2TRLChQbmcWiKCzeV+7My0tr3OygxuIEm8?=
 =?us-ascii?Q?gcnGNSvCXioDdCfG3RvyKYpJJYfH9IguNhck3xJ+wdtDNCweOvPctZt5xRoE?=
 =?us-ascii?Q?6yri9YNI1uoopHV/xad7nHVLcLZht1SZmx+Eg2O8zkoipy0pcmibPX+HNL3f?=
 =?us-ascii?Q?bAFKx+gqAv2K0hnEJHzovbQ04hy0PSRhqWwUgypUbWn/adWkOOtubBoQBR2o?=
 =?us-ascii?Q?P93UcHWtTqfxI2eSVJms3Idzpx190vQcYz98kR9qO+fXqagkLyU0EB/84Wef?=
 =?us-ascii?Q?ihZd1olYuz3n0Fd6ljQ2eXOSr2xQASp8UIcqqNvvEe1Awo/wB7YWQKSzdW3r?=
 =?us-ascii?Q?mdRucYV55UGQgYninpuHwaViJRWkfcMm6H1vldPMcCt/v0twL0mqh/o3vXnl?=
 =?us-ascii?Q?X57+amqV3SGNv2PZplio+EkgmZjH7Dd3ofX3UHyHsFiUHkdPpL4iuwLe1Jd0?=
 =?us-ascii?Q?Ipd1NdBvnaUXVJdapG6Rs7evsNsiNvd0huWFumtqVF4al6bb1BvRf0piPp2K?=
 =?us-ascii?Q?vBzUzTKL5MSyburXPd+OecGMQA1lcNYoKWeQkQzEXlOyxIa8VmINUUrDfkyj?=
 =?us-ascii?Q?lwlCUquTnukxX0MMUVk4c5QPE4wVqff6rYAJblE+4jcDlf3LXio0BIEVj8xp?=
 =?us-ascii?Q?hBip6I6V0YyCCNRrbJ5zEL0ykg9faDEe?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:59:44.2117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0d9d09-93fb-47f7-555a-08dccbf6c146
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5890

On Thu, Aug 29, 2024 at 12:27:22AM +0100, Mark Brown wrote:
> Add some documentation of the userspace ABI for Guarded Control Stacks.
> 
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>


