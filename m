Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010063.outbound.protection.outlook.com [52.101.69.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2D3C1408
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935547; cv=fail; b=FDD8oy1aXmLH339GwFItEim+NwJxadz0hcn7gwq0X7QRldZjK01xUfHSwKoCtXAWtD5ASPrtZi62OKO7M9pZW93sZUy3LsRUqibRv6/62gzZWk0sSXQs4Soix62LNHVmyjYKzD/BTLBZi9YRkRVAeO8po/1WlZimPZF1ZFFuU5o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935547; c=relaxed/simple;
	bh=S0jSX+XpLXhFjX817OLLVQQC/8wFe+lATbzKSIceTNk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=McKgjWqTdO2r3Yx3ae/9kEnEC/v83BhlT61YPp2O96YQXHycjWuXTUNkclUrx+Y1XyizoTze+Y0Djma3hhiS/LTriNhml8twXcySs6KGaBf+CMSnDaCF95vn7w+LZ/tdkL9S3rCLQ8GrWqfHaeOQNDWb9Q3oTn68Ynw5LdoKy3Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TArcT5Mw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TArcT5Mw; arc=fail smtp.client-ip=52.101.69.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TArcT5Mw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TArcT5Mw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dUOlFZxgjJPEKS/SPfT3l/TWRWM2C8TGRzkviHPXjcLfHtXWfve2bomrVbDkC3VFUyYDPliu928e539tFUQl84ihiCsQx/yGznHBF+WnL/RNtaGImm95ps795W2L7Zm5SSxwBuEGHpRVQnarQtVmd2cn0CSW8UEVePI7CPdjMDyLcW8MPw+cw6GQK7MsmwQdRirYupNC9Fhpsa5RVykWodlvX1rvRwirU+/H/QIMY1uHTD0JYpmvBvF+9CDz/eiMxXE7Da89IM2c6fOHzJmqNgfvvbRLlL79R55h0HRWtCDvhptYni1w6kmQPCoz9iJVl+zeNbzD3KBPG47gnegyfA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=Sr5YuMN/mtH8Eqv4m25hGzBT2PF3FX5wWG7KmXduP9rBgKRL4kB9pj1HiWxR2QuzNi5Srfzh7Q3ivGyIvQLMbm4XrIbe1MeZs0TTxYnrHVQDAiaz9/zK8agic3OkWrpBi3AHNppdaN9I7lWg2J26u1M+qm9m3V8nUBMsIr1WPe49gyTOU9ZRCi4c+Kn6ex8wEUjlHZEHSNlxzaSayVnQ705PLViyYeW3YQ1+Dpn/tbJ3KtJwUJZhCIIyv9dvBK3g4WymCu8PESoICCkycS0pw3suqqSsdatpdoURUiH1TGy4rkakc4GN097xACKXayu7x93iG5M0KTrUD3SR6OvMZQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=TArcT5Mw4PBF38Ojw/NoJlSCcL+82d77X+4iOBF3P1nIsEXFxB4ydzwO81gbIE5UPqsvMMJbCwb3HFrmVjALabMSZuJR7hyPwBy310KFlobF21Y3cHSmfVM2an6i0ORmLgLgiUPOWC5iMSHOzFiY7OBFAWyn51T8U/V+dOjBfa0=
Received: from AM8P190CA0007.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::12)
 by AS1PR08MB7657.eurprd08.prod.outlook.com (2603:10a6:20b:478::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:19 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:20b:219:cafe::f4) by AM8P190CA0007.outlook.office365.com
 (2603:10a6:20b:219::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:52:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:52:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HVUngRdLuuuoWOUjg26GzptO3d95Bhb6V1qd273pjd7c3afIQm5Y6dcCG1nQEZ/pNKwexAQ7/qt3ecZ67V9IX/uDBle1YqsyXhARUra4MOX79AM9M7XKxvBB6Wr5EKqgY9k9kn42s4jUqMBOF4Scv6fSJwnJ229gS6STEmswPbzdixqyzYjNcZvwQ8T3e4W7gwvIxIJ1bs869gAibj47AIQdmcKirkKV4i4/A1yrWwsqM6zAOq0ksNNNW2+5lCz9q5ML93Fqswe85Dk8WPZUXsacazVlH8eWOfS1RWoVWjWKtmwaX0YvnMVKPMPz7aUK8f+QQ1B8Wc1Neu5whV8CIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=QRgT1XOWajonzDcdbRO61eNsVcp8dR/IKpgx6moW5cyg+XUjUdwRNVyuwSOSB9GzPjrxtWQU6RRHP211tVtFUQyBlbD/JR6lX14P0cR+V3rsPYa0+kU+F/Wfjq+TyXyJTvp6uXM4h0k/LQF8OxzjDaqJ54VpzMCmkVF4CtQrPIaa2mhe3PeDrXd/p3RxX569f2HcMPKBD85t2vgI6X2sCWHAKtte7ckoc0mUgmFWnj5t3lHErRNC7y3Cd6pFJw3Sg2X4gELuzM2KgxisLLUMD4hczaKBb+h9BX7BCHwPJ23DbCXlSDR5M/Baq66D2fg81Aruv09BZPDPOOC7xMukxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=TArcT5Mw4PBF38Ojw/NoJlSCcL+82d77X+4iOBF3P1nIsEXFxB4ydzwO81gbIE5UPqsvMMJbCwb3HFrmVjALabMSZuJR7hyPwBy310KFlobF21Y3cHSmfVM2an6i0ORmLgLgiUPOWC5iMSHOzFiY7OBFAWyn51T8U/V+dOjBfa0=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:16 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:51:16 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 06/41] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Topic: [PATCH v7 06/41] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHct7g4HUswHv0HyUax0osszNd28w==
Date: Thu, 19 Mar 2026 15:51:16 +0000
Message-ID: <20260319154937.3619520-7-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|AMS0EPF000001A7:EE_|AS1PR08MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8c8cf9-73fc-46b5-2df1-08de85cf8094
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 d2Ym8vtQ4Q/VzUVTEKyFp4D97T37yvKdDNVs+D+5ftNcBsDjYFd57dArTd7NTe87zqtA2M4cSBGmGDHC9lInF0nWXTa+wXQ9W8SaRpu0nUVpnAKyjWtzDJwlecYqArc5TsHbLZALBIOUjISwQ4qhid+6y4c46YmiicWak2yLUW0jZOOYoKAXF+1kytA+C/Qh1nCpBZGPLyndc2+6voeH+nnH89VxgCkYd2jv9jfqoEcwImfU655WZ2z1rDxOx/x6VcLDfR5lyB5U9o4rQdPHnZKX9pwu2CDhVcwNCf7qP8ny1006mn3txCgGmXsSS9+Z4xgcUgoP7G5IzoiHm15izT6PQ7/dY3QToyxda6Y4O6VefdaqDxdUv2rcNq6hMQ/aZR+Lvan0yGVcDdsAw7LAA2hov1PAT5nPqzCvIcBXskkCj/KaQvs94pxw8Va1W1FTOEv3HUwPqSX8MjM3MdcTlm8kg15ftImuNbZxtM2Cgr5bqBArRteFciC7DMzVEA/usEGWNjWBl9sx234hUyuSenCt/YI2vGvR2YOZHSGy87CNua91NiEhJv/UTYWZTEGF5N1aHFCX0FEpZfUKVihzvSRsyA4x18DdgCBvjRAhq+7F+luL6OQ0+C/wMElkCLtBN6PVcIoqHBy/P5V0F+otm/XliJOafvJrOHbLlkWmv+CrEyNawuKAho3CRxRsEVFb9lhlvYOYejhY5ZCQIKxIm9ig/SOL7L2ZxoTioCPYvkYNRWqteJv7GVX7ozufpBXni7gH70k3nIEIvKS78Xgnr4TaFrbd3F5CjD91UkbZMP0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qzANh2pdxTuy9FJdICONYd9eczmwLjpzMDW5ATv6dKfycLOCkKpQUcZWftgw0fF2NfxD5Jj+zJrfzCtvTsZUd5F40vgbQCtH0sPKkNn7RQs0ovFK5JkBt7WbHvEvRrPLkrD/e5HnyXBfft6bKfRm9Ir5MgfXstApZ/mcilvnALQ9wlTbbSgnP8Wt9/DgVmWkLSyEsP0yhh5Asguj/IKPqX8VKq5yhkdqtIt2UUgWdRrrcwcEe/j9PuZ7WuQD7CjIR6hMiv3HBhnn4zZL5eSK2KxBqsFHNhhQJT6SwEWd+nYGahqK3ZCGNe3rtOZgxfj1nYF6Q86EMqnpVw7LhDks3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1ad9f6db-4547-461d-8891-08de85cf5b2f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|14060799003|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/B+mRRaQVSLxOdfaATXqHg/+hzj9U29b5XC9d0zV6hIrWoUygdz0UbURIYnMsSFDsgprfStGKmqJ6Ih//v5M9WzbbAglmrHpwhVTEyVG1pDK2izM+ONPMgpk6oP2IoApRtK2nX16goj6EggVoFrxnvHkfEeIr1YABt17uRX7N8PrTq83tqe5DTVjcl1vVl4ycL6x1KCcs886OExfbvgTljDHqUIG6nmR/TGk4Gwz+5hKScyjnRHkEDV6CFYHmnyMfsOwLdPpro62WuBp2r7Nv1NBoxA06QmxHBlZu4mFrguISvlcNUZj7kllFgb/l1kd/erfdeM94s61oJQz+HMME+hunHbS+YCDu9b33BU/5xx8xsfqpHHUMfh1996NtVbJ5J49+jYyxArp0uHM5z4JWYLyRNgWED4wNW1HyHUusJrfWi+CmFOsH0p8P8GPgU45llomMdOcFcSG32ReAQ4plmPXTcdvJefB80BrziMeIz7vw/ZSUXLNXF2uurY4gqgm8BWNALrfKLIPPywF2kaBMOQ6Ptz2A+sQfrZJQVos4oD1Pds+C0sCPjQFsavkjn/iiowkn6/dKYIvdh4DALw47E/sw1uMlU+oVAM/6rfaSEktHQxbsm/VuHhU6rksO6KkCxsv4ya5x4zMK4qKtA39fM/QdsdQVio4l7gAlu4FRwTVGDVQ/TRaTpwKqrgNd5OWhEBIwpee8qKYb9s+HU7JhlPOdUMWhqe5dgvqVxPEH6G2UO41lUHwLLlh8XoNWNuZDiMLTdvjCiswzrlgqhvO3Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(14060799003)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q5yLJPzE5r676KsGWf8QSKSNLFVnchTWyxFiB932ZWz3PxlLymy/5DlF69FUjuDYcrpxiZQzh8npJwfDiR2yVcNGSMM8mOGefjj3st7cGbDTgRZQQgF3A0iDrlhvuaDwv4SKKjeE3fNX2YO8gMsuImjx7ho7iX64MzkyGnFn0yGNMUTDYcab7cxS/R5+vcSDqH/JEV9oInmWsTGR36fX8WHweCJcjZJAHVtcmAwziDObk21A1VjYI/WsQroCMgr3HtIU+AT6K37EPbF4F63+ZwHnOIo7b7ft7kPrjtKPRi2QZ3akGAxPbAqMpL4AIVAQ4a/91WTkYeAjZjNrPI8Dp+a+YXjkHQkqXePtwTBzcnfEXNblV0mYic5X38QbOuVCIAQKxNcG0Md8mvkIFDMzi6MCnW/dAeDV946FPSYWWloaO/Z4VkLMoSIxwAqef8sJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:52:19.4043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8c8cf9-73fc-46b5-2df1-08de85cf8094
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7657

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9d1c211080571..51dcca5b2fa6e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3243,6 +3243,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3257,6 +3265,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3663,6 +3676,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4687,6 +4736,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4735,6 +4820,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4789,6 +5174,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4810,6 +5207,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1
