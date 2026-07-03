Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011050.outbound.protection.outlook.com [52.101.65.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B9A2DF153
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094520; cv=fail; b=DBJ7XAmUV354tBZ2asF/TwVOsz3x+Gcu3Lfx4sOj7qwsG28TftAEHr2hzRH/BiUydrxUEUOqAh7+1a597UyxEwyAUORRqM9zc7+czJ7lQetFAoMe2/1iX6xqATQiL9Vhqol1HtwZ5BIyT3ekPPUTkX2SUI87PEEMBKQeomLwZXo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094520; c=relaxed/simple;
	bh=3NapHk24LyLwxJtf3wThzW1EPQ4gRKc6FhwgHPIZLJk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uOsFPRIdrmQHptNhG+p43Algn5Lsz0OIh63Er/p3HzkAqmu7WspJRTZEXhJPZrOb5Gxx+A55MbFtQyMtXQs3LPbbNDURnEX0j8yNbYXWcxXXUpa2FdIUHePioLRaz1O+vImsUxhUds9364P9J/gkhCxxQ7A89xkqg/6xFA+woLQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p6MHMxkB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p6MHMxkB; arc=fail smtp.client-ip=52.101.65.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p6MHMxkB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p6MHMxkB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xdZNvic82TaBqeKOsoLLFIR6thfQxTT1qNfW4LOa8mtmcHbt6/y11DEhHlYTHSZ3TnMyfbJ/H1oNM5UElLryPdrSgdMF+8K+5Tld/Eow1bNYo0oSADXu6SooJ9L9svFwvm4KB8d2tZKbe+qjHnwYMXPbbdG8/75PfPWSS+vaeBZWx+qHdja9spQr94DZGfUwzTi3hkGWfVwIXydJP7c9KYTGs4m84Y8Zas5j6U5ZQkY0oJeCwESqZXzl7jzNwiHCkair9M78uJzFHAzD+LFKk7PgqVWU1wgDCTEm29MjUR2RmE39TkjmUeO2YhdbrnlGzfB6vzP29ei2FDnbYT5bfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pnZmJ4HrCCYXImY70qo35HvyLHosCwhHjJ/zdmhS84=;
 b=OTFv5hUwIDVP6PuENVwCVi3gGbvpMDCRiSitFzWDCAHJCXxXyzES76vo3s/vP+ZyMiSCUItaMRbrQh3Tvy1iR5Eqk+ZRT4UsLpKvyBkwt0ApCFe4B2NM7vnszwf7x5zvY9CFr8RJhR2OQgACdhlYibxPwFsSnJNxg+aFaFIGyDEDvtp4CuKjdId6fhRBhMXI5Sd8CudUuQWr/bAVFHK5oqT1XzBKfML7fWcDMCOIBvOkSX+bkOfOq3TXguhMqc6X5QcbbgG0N7b1u3tbYj5EHxaZtCMh22QouxaHU7wtd1/fmunR+vRXcW/449RM5Fca0gG6qs9nXAyy2BgNYsKT3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pnZmJ4HrCCYXImY70qo35HvyLHosCwhHjJ/zdmhS84=;
 b=p6MHMxkB2Jl6dKkdhXycbz0gyzS4+rn/vSxLDhq6aC2tPDWJ80zbJFHB2T0/XlFi6/Ar21PcKtyIJoKyK7iYTgp+RFsVKV9NXpwRMc0an65Oxhe76C6UVH9u7i2o5ShZUt0ag4vO5pEhi5NKBVTP7oDY7tnPIhgVyDKFogVmABk=
Received: from DU6P191CA0055.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::26)
 by AS8PR08MB7791.eurprd08.prod.outlook.com (2603:10a6:20b:52d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 16:01:46 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::1e) by DU6P191CA0055.outlook.office365.com
 (2603:10a6:10:53e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D02.mail.protection.outlook.com (10.167.242.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0h3oWfNo77IRDp87On20V6xP0iw0lG5ZUDD9oYTFHf49Fazecv1IqC7ug978LED3NrhQSxNybtFfsfGRcJtrNk9JgzMft+P4HNbe3hMcsblgSgJzlyo5jQZQWO+vQOqrqHIhGWT7YLjqDZM1gYac+vHITyXquqgKhksIKqiqXaZFYgPp8sgWp8N6K/2qbwTEimHBgf1b/3iFldjD9g2DuIGwLVTCebH/8VjPT/zJwfgy6cUc6i4ZDiLfYbdF8fH9Ay3rzSmLZlEDO2BRBHb1B5sO/HimyajgR2WboH5Fk1GxydPyCwiAPXdc38l5CpRdS1VIpBEISFfBB1WvNgfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pnZmJ4HrCCYXImY70qo35HvyLHosCwhHjJ/zdmhS84=;
 b=PoxbsYsexLOp4I2QmXLzSB6JDPH4DA4+bStLtG8k4rxk0xGF0EbdqZwvdjzvMq9sLSR4U2NZaXK0C8gy+/ZeXS5jX6wWPa2ZhNlWsxB/LIRUoqfvVOLl3oEB8hwz/hISfRArh+zlizfmPdDQIYJiR+8LkANqKyW548AKhqy0Ca1Qjz6NIPv/Q6JhgV5PHFaBzWWFJbCk6UO5tW6CpvH1JEmVEkkMpflwNiQsJ4S1TAXeoLx6qYdr0ACPlK94eeqMwuuqnK++MbNHNedJvxfRKCEdDdeyXcZP1hPIcVajMdxDERh5Pc1rH4iFxpPCVH+9Fr3AA84A+h1NbmT/F6fnQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pnZmJ4HrCCYXImY70qo35HvyLHosCwhHjJ/zdmhS84=;
 b=p6MHMxkB2Jl6dKkdhXycbz0gyzS4+rn/vSxLDhq6aC2tPDWJ80zbJFHB2T0/XlFi6/Ar21PcKtyIJoKyK7iYTgp+RFsVKV9NXpwRMc0an65Oxhe76C6UVH9u7i2o5ShZUt0ag4vO5pEhi5NKBVTP7oDY7tnPIhgVyDKFogVmABk=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:00:43 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:00:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v3 20/40] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v3 20/40] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHdCwUaqZvPBywHLEGKToCGvkUrfg==
Date: Fri, 3 Jul 2026 16:00:43 +0000
Message-ID: <20260703154811.3355680-21-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|DU2PEPF00028D02:EE_|AS8PR08MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: 9475112f-7f7d-4398-1c3f-08ded91c622d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|5023799004|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 gv6ZXiOP/dQfvBCPP/qP4wQKjJwaCy+RUZ+LXEqdYBcWN4BZJI5ZOmzqmcononMBW8NILA2JpJ4zcYcm2IkPuXHvvW6PWDUtC22exDyooZUFEQQaxdNmM0mqa8+YSWtWEkfPB/X6v2yOO1nbOuo7jhCmfq4BYpUVwzpG7ZePBj1N5jem1MKcPa06f0SUrCa70z+dJGfPoQr6rlvr1gx3Pez9yi8ybQzp94wKvZKGHbiZeggr4LvbfGEKY7rc/5ZpqNyKFlMaYxSpBiFrLD97iT3cUpamt9TKKtPpyojRLY2Ypr11Bjhyl0IUfwk2K7QUbpExuQ74UyBcL3jaChtC98IMoav7lsIegWF/nRZWuxc67/1Bm9pQxJ50sfxxNpAUqqolfgmVZymDVLDlLcckoL8Ot+UgmM441vR9K7eWAfPxQdMzPHcn/ZWLNFSt1XrJ/whV23LlFMwwgBt2KqzDNGyAhyL1taexHiek/icV3YS3iaitwUQ2ejsm7pKPmigF3+vF+vfuxjdebCR+WjU3FfRoA4tRDelqONqc0WrdNi3DtBRD7itS1/lTV+cXtFCyYSHGmzlAOvhSWFqsB43IoA+HRAJ3JkuodSewmL6gSpJCRmvvrYEMeC4tyt/2OOpnO38BkzqYgl9Jzt+08i2fWhY/i9xirrkCJnGBlUtF6k0+PMyb0uVDlEOHucIraeyawOpuqpoNKl0rIC+Or3ZT/A1pmYvECxX1roPm4uMzmSQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(5023799004)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EzjOzWd0QzKkD2WmRE0tHke+8faWbzKl9Pi4AE/4y7Je1JLDj1/sEkANUXZqSviIjn+HIoF5wIm6ntCoeygnP1XhyglsgeqK72UxXWYMSLH+6BUHzCAoCi/UtLea0mQsPmpGAYzibI5pnBW3YavSdzAXeFf7pdEUV3wgLE2yAfeTVBzkt8nYlWA/Am7KIc2Dd4/897ctA4CBLwigvQ7wMNTNXpML3wE3iZyqZm8ql6QGKeQamJ0pbdAiJ6EFderyhDjK4JXhmmUI7t7XkUQhzdo/AZe27WTUnurLLkYSQ0EvS3kLQF8qruL9aaxiNZfhq5Amh89/qjTUIUtW9MgbSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ef554ce7-4d27-4773-b4f2-08ded91c3caf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|14060799003|23010399003|376014|35042699022|22082099003|18002099003|6133799003|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	X61z7eWHVZ5RyTpgdZqhYA0PjIqRds9G3do+mXZrQO+ck43D7rQU/T6AQotOtGwYURIJDN9jJy7941jp1Rf1s2UkUR/5COQOq/fXcft9d/h50rLEM0Ua1+m4dRD/d1cc/9nLLwYjw/gVGlw1JnzR0qwXz9MaQJXFvUVJHz2dBGKl3cB1xLQHlmaH2obtrDp+HBDLeTyG4AmaBktnBwWozytZT349rtzI2uSQrs7MLKJqVhH/iDWXWpjpM6iSwrwlYyEkNcY3Bb7P1TixyMLTbKiu6ijGpX0QC00CmIXpp8oXvaxQ5DFjJRyswX2PfKtUXk6uCrimOSjn1cYbW5st3VnfIvTBARgmrBjNqJSP4tlXZNQaDykpt9dfBZkIfFbZzDUk4Zg9aGH0mY74SMinN7G8pQADmmMDs5HhE8OfytwmqicTITyNiQSERBYkhVD//8Mz/8bw0AN57Uipg5KUEVbYEs7wcyCPeoTbWdDZw8V50lGiLWhJDnr7kewALFhxQ0nVc/YEPCsLfyGoRse0XZ1LRkidcpT/m47QWEhtrxbE4vfWDwBpm101+p6ZzpygjwFH97E0ou1xhaC30nGBsjBUEAyVM6ZudPwLW8ADRgZbOHa6UT0H2XJ0DZ10N932GD+7DefZoYCQbAgIPvQ/G6Zbir1jQIsrKENXN89bVis8T63Z9Z0xZ4k7zaKsha8lPpcLbtTPspVDdoYXDnwiSw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(14060799003)(23010399003)(376014)(35042699022)(22082099003)(18002099003)(6133799003)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bCuxqyeVLcrQR3ShsSobk/WOv9DKU2yIqnTTclEsrpZ/xgfl0WmdYhprasyvhWdVank0FzngLSvkWpOpQdeC8kL1U1I87Op7K9GCLXFp/3rIRTQC/oXkYO8E5YMNigO4gchoErx+Tf3wlyXcyVLzZkAUZutqFmSk9ABJW5m8ombMQ5ZkdUDC007efGxxAJyZi4ZYP5RKVqtBPQxNuJypoVMc329lK3HvMEye1lNKXGVJWVz2buuRhxMiXnOtFzm6f+CY9sK8oMya666sbA2SkizjUa60WR7oUavvRxRPqwO3yU6KSw8VJjDlM+4htKHc10iCksrPVUV0lEVjoAZF5X3jN6gbqjhbEcAmmSUR6+ya5vihtU/rGwalNTj8CmbqCduRxw7BT9N7WpVGxMud/GIn5hZUa5QVexdKRWVfS3pSjgDSf85G/eEOms1lJWVL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:01:46.1544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9475112f-7f7d-4398-1c3f-08ded91c622d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7791

In order to properly support GICv5-based VMs in KVM, we need to
emulate the CONFIG_FRAME for a virtual IRS. This emulation needs to
handle all guest accesses to the MMIO region, and mimic the behaviour
of a real IRS.

Introduce an IODEV for the GICv5 IRS, and an associated init function
that sets up the SPIs and initial state for the IRS. The MMIO
emulation provides support for the guest to query the IRS_IDx
registers, manipulate SPIs, configure ISTs, and so forth.

The emulation tracks selector state across MMIO accesses. For example,
a guest writes IRS_PE_SELR to select a PE by IAFFID. This is the VPE
ID for a VM, but the guest does not know this. If the guest reads
IRS_PE_STATUSR, KVM checks whether that IAFFID selects a valid VPE and
sets the V bit accordingly. IRS_PE_CR0 is accepted as write-ignored,
because KVM does not support 1-of-N routing.

The same selector/status register model is exposed for SPIs too.

When it comes to the LPI IST this also requires KVM to perform actions
on behalf of the guest. When the emulated IRS_IST_BASER is written,
KVM re-allocates the IST on the host, matching the guest's
configuration (from the emulated IRS_IST_CFGR) where appropriate. This
is then provided to the physical IRS via the VMTE. As far as the guest
is concerned, the IST it allocated is being used by the hardware, but
in reality the host IST is used instead.

This change provides the IRS IODEV as a whole, but this is not plumbed
into the rest of KVM yet.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c    | 754 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  16 +
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 include/kvm/arm_vgic.h               |   1 +
 6 files changed, 775 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 431de9b145ca1..92dda57c08766 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
new file mode 100644
index 0000000000000..20c13c582f710
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -0,0 +1,754 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_dist *vgic_v5_get_vgic(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.vgic;
+}
+
+static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct kvm_vcpu *target_vcpu;
+	u8 vpe_id_bits;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		value =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, irs->idr0.domain);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_PA_RANGE, irs->idr0.pa_range);
+		if (irs->idr0.virt)
+			value |=3D GICV5_IRS_IDR0_VIRT;
+		if (irs->idr0.setlpi)
+			value |=3D GICV5_IRS_IDR0_SETLPI;
+		if (irs->idr0.mec)
+			value |=3D GICV5_IRS_IDR0_MEC;
+		if (irs->idr0.mpam)
+			value |=3D GICV5_IRS_IDR0_MPAM;
+		if (irs->idr0.swe)
+			value |=3D GICV5_IRS_IDR0_SWE;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_IRSID, irs->idr0.irs_id);
+		break;
+	case GICV5_IRS_IDR1:
+		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
+				   atomic_read(&vcpu->kvm->online_vcpus));
+		/*
+		 * IRS_IDR1 encodes IAFFID_BITS as N - 1.
+		 */
+		vpe_id_bits =3D fls(kvm_vgic_global_state.vgic_v5_irs_caps.max_vpes) - 1=
;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority_b=
its);
+		break;
+	case GICV5_IRS_IDR2:
+		value =3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD_SZ, irs->idr2.istmd_sz);
+		if (irs->idr2.istmd)
+			value |=3D GICV5_IRS_IDR2_ISTMD;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_L2SZ, irs->idr2.ist_l2sz);
+		if (irs->idr2.ist_levels)
+			value |=3D GICV5_IRS_IDR2_IST_LEVELS;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, irs->idr2.min_lpi_=
id_bits);
+		value |=3D GICV5_IRS_IDR2_LPI;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ID_BITS, irs->idr2.id_bits);
+		break;
+	case GICV5_IRS_IDR5:
+		value =3D FIELD_PREP(GICV5_IRS_IDR5_SPI_RANGE, irs->idr5.spi_range);
+		break;
+	case GICV5_IRS_IDR6:
+		value =3D FIELD_PREP(GICV5_IRS_IDR6_SPI_IRS_RANGE, irs->idr6.spi_irs_ran=
ge);
+		break;
+	case GICV5_IRS_IDR7:
+		value =3D FIELD_PREP(GICV5_IRS_IDR7_SPI_BASE, irs->idr7.spi_base);
+		break;
+	case GICV5_IRS_IIDR:
+		/* Revision, Variant, ProductID are implementation defined */
+		value =3D FIELD_PREP(GICV5_IRS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_VARIANT, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_REVISION, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_IMPLEMENTER, IMPLEMENTER_ARM);
+		break;
+	case GICV5_IRS_AIDR:
+		value =3D FIELD_PREP(GICV5_IRS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_IRS);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_IRS_CR0:
+		/*
+		 * The IRS is ALWAYS idle as we handle things instantaneously
+		 * from a guest's viewpoint.
+		 */
+		value =3D GICV5_IRS_CR0_IDLE;
+		if (vcpu->kvm->arch.vgic.enabled)
+			value |=3D GICV5_IRS_CR0_IRSEN;
+		break;
+	case GICV5_IRS_CR1:
+		if (irs->cr1.vped_wa)
+			value |=3D GICV5_IRS_CR1_VPED_WA;
+		if (irs->cr1.vped_ra)
+			value |=3D GICV5_IRS_CR1_VPED_RA;
+		if (irs->cr1.vmd_wa)
+			value |=3D GICV5_IRS_CR1_VMD_WA;
+		if (irs->cr1.vmd_ra)
+			value |=3D GICV5_IRS_CR1_VMD_RA;
+		if (irs->cr1.vpet_ra)
+			value |=3D GICV5_IRS_CR1_VPET_RA;
+		if (irs->cr1.vmt_ra)
+			value |=3D GICV5_IRS_CR1_VMT_RA;
+		if (irs->cr1.ist_wa)
+			value |=3D GICV5_IRS_CR1_IST_WA;
+		if (irs->cr1.ist_ra)
+			value |=3D GICV5_IRS_CR1_IST_RA;
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IC, irs->cr1.ic);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_OC, irs->cr1.oc);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_SH, irs->cr1.sh);
+		break;
+	case GICV5_IRS_SYNC_STATUSR:
+		value =3D GICV5_IRS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_IRS_PE_SELR:
+		value =3D FIELD_PREP(GICV5_IRS_PE_SELR_IAFFID, irs->pe_selr.iaffid);
+		break;
+	case GICV5_IRS_PE_STATUSR:
+		/* We assume that the PE is Online if present. Always IDLE too */
+		value =3D GICV5_IRS_PE_STATUSR_IDLE;
+
+		/* Set ONLINE and V if IAFFID selects a present PE */
+		if (kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid)) {
+			value |=3D GICV5_IRS_PE_STATUSR_ONLINE;
+			value |=3D GICV5_IRS_PE_STATUSR_V;
+		}
+		break;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+		if (!target_vcpu) {
+			kvm_debug("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\=
n",
+				  irs->pe_selr.iaffid);
+			break;
+		}
+
+		value =3D GICV5_IRS_PE_CR0_DPS;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_IRS_CR0:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		/*
+		 * We need to make sure that the IRS coming online (or
+		 * going offline) is visible to all vCPUs, even if
+		 * they are currently resident. Halt all of the vCPUs
+		 * now, and resume once we've done the update.
+		 */
+		kvm_arm_halt_guest(vcpu->kvm);
+
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+
+		kvm_arm_resume_guest(vcpu->kvm);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+		return;
+	case GICV5_IRS_CR1:
+		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
+		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
+		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
+		irs->cr1.ist_ra =3D !!(val & GICV5_IRS_CR1_IST_RA);
+		irs->cr1.ist_wa =3D !!(val & GICV5_IRS_CR1_IST_WA);
+		irs->cr1.vmt_ra =3D !!(val & GICV5_IRS_CR1_VMT_RA);
+		irs->cr1.vpet_ra =3D !!(val & GICV5_IRS_CR1_VPET_RA);
+		irs->cr1.vmd_ra =3D !!(val & GICV5_IRS_CR1_VMD_RA);
+		irs->cr1.vmd_wa =3D !!(val & GICV5_IRS_CR1_VMD_WA);
+		irs->cr1.vped_ra =3D !!(val & GICV5_IRS_CR1_VPED_RA);
+		irs->cr1.vped_wa =3D !!(val & GICV5_IRS_CR1_VPED_WA);
+		return;
+	case GICV5_IRS_PE_SELR:
+		irs->pe_selr.iaffid =3D FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val);
+		return;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * We actually have nothing to do here as we don't support
+		 * 1-of-N routing. The only thing that the guest can correctly
+		 * write here is 0x1. However, there's no way to fault if it
+		 * writes something else. This is effectively a WI in our case,
+		 * but we keep it here for the purposes of documenting it.
+		 */
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_is_spi_selr_valid(struct vgic_v5_irs *irs)
+{
+	/* Invalid - we don't have any SPIs at all */
+	if (irs->idr5.spi_range =3D=3D 0)
+		return false;
+
+	/* Invalid - we don't have any on this IRS */
+	if (irs->idr6.spi_irs_range =3D=3D 0)
+		return false;
+
+	/* Invalid - ID is less than min */
+	if (irs->spi_selr.id < irs->idr7.spi_base)
+		return false;
+
+	/* Invalid - ID is greater than max */
+	if (irs->spi_selr.id >=3D
+	    (irs->idr7.spi_base + irs->idr6.spi_irs_range))
+		return false;
+
+	return true;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_spi(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		/* Return whatever was last written */
+		value =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, irs->spi_selr.id);
+		break;
+	case GICV5_IRS_SPI_STATUSR:
+		/* We assume that we can always claim to be idle */
+		value =3D GICV5_IRS_SPI_STATUSR_IDLE;
+		if (vgic_v5_is_spi_selr_valid(irs))
+			value |=3D GICV5_IRS_SPI_STATUSR_V;
+		break;
+	case GICV5_IRS_SPI_DOMAINR:
+		value =3D FIELD_PREP(GICV5_IRS_SPI_DOMAINR_DOMAIN,
+				   GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs)) {
+			/* Fault with IRS_SPI_SELR; return 0*/
+			value =3D 0;
+			break;
+		}
+
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
+		if (!irq) {
+			kvm_err("Guest trying to access SPI not backed by KVM\n");
+			value =3D 0;
+			break;
+		}
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				value =3D GICV5_IRS_SPI_CFGR_TM;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		irs->spi_selr.id =3D FIELD_GET(GICV5_IRS_SPI_SELR_ID, val);
+		return;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs))
+			return;
+
+		/*
+		 * Find KVM's representation of the interrupt - we need to make
+		 * sure that KVM's view agrees with the guest's, else interrupt
+		 * injection won't work properly for level-triggered interrupts
+		 * (we fail to handle the clearing of the pending state if KVM
+		 * thinks that the interrupt is edge-triggered, which is the
+		 * default.)
+		 */
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
+		if (!irq)
+			return;
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (val & GICV5_IRS_SPI_CFGR_TM)
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			else
+				irq->config =3D VGIC_CONFIG_EDGE;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs *irs)
+{
+	unsigned int expected_istsz;
+
+	if (irs->ist_cfgr.lpi_id_bits < irs->idr2.min_lpi_id_bits ||
+	    irs->ist_cfgr.lpi_id_bits > irs->idr2.id_bits)
+		return false;
+
+	if (!irs->idr2.istmd)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+	else if (irs->ist_cfgr.lpi_id_bits >=3D irs->idr2.istmd_sz)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+	else
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+
+	if (irs->ist_cfgr.istsz !=3D expected_istsz)
+		return false;
+
+	if (irs->ist_cfgr.structure && !irs->idr2.ist_levels)
+		return false;
+
+	if (!irs->ist_cfgr.structure)
+		return true;
+
+	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	case GICV5_IRS_IST_CFGR:
+		if (irs->ist_cfgr.structure)
+			value |=3D GICV5_IRS_IST_CFGR_STRUCTURE;
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, irs->ist_cfgr.istsz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_L2SZ, irs->ist_cfgr.l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, irs->ist_cfgr.lpi_=
id_bits);
+		break;
+	case GICV5_IRS_IST_BASER:
+		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+		if (irs->ist_baser.valid)
+			value |=3D GICV5_IRS_IST_BASER_VALID;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+
+	switch (offset) {
+	case GICV5_IRS_IST_CFGR:
+		irs->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, =
val);
+		irs->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		return;
+	case GICV5_IRS_IST_BASER: {
+		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+		/* Valid -> Invalid */
+		if (irs->ist_baser.valid && !valid) {
+			/* Make the LPI IST invalid and then ... */
+			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
+				break;
+
+			/*
+			 * ... free the host IST if we successfully marked the
+			 * IST as invalid. Frankly, if we failed to make the
+			 * guest's IST as invalid, we're cooked because it means
+			 * that the IRS may still be using the memory that we
+			 * want to free. Hence, we leave it allocated and skip
+			 * the clearing of valid bit in the baser.
+			 */
+			if (vgic_v5_lpi_ist_free(vcpu->kvm))
+				break;
+		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+			if (!vgic_v5_ist_cfgr_valid(irs)) {
+				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+				break;
+			}
+
+			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
+				break;
+		}
+
+		/* Now that we've handled the edges, update the valid bit and addr */
+		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
+	/*
+	 * This is the IRS_CONFIG_FRAME.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
+				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
+				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/*
+	 * The following registers are only for running VMs. They are not yet
+	 * supported as we don't currently support nested, so expose them as
+	 * read-as-zero/write-ignored.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_BASER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_CFGR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_HPPIR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_CR0, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VMTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VPER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/* MEC, MPAM, SWERR - all unimplemented */
+
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_MECID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_PARTID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER0,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+};
+
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
+{
+	dev->regions =3D vgic_v5_irs_registers;
+	dev->nr_regions =3D ARRAY_SIZE(vgic_v5_irs_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	/* We represent both of the IRS frames back to back, so this is 128K */
+	return KVM_VGIC_V5_IRS_SIZE;
+}
+
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address)
+{
+	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->io=
dev;
+	unsigned int len;
+
+	/*
+	 * Design choice: Force MMIO region to be 64k aligned. Simplifies
+	 * pulling out registers.
+	 */
+	if (!IS_ALIGNED(irs_base_address, SZ_64K))
+		return -EINVAL;
+
+	len =3D vgic_v5_init_irs_iodev(io_device);
+
+	io_device->base_addr =3D irs_base_address;
+	io_device->iodev_type =3D IODEV_GICV5_IRS;
+	io_device->redist_vcpu =3D NULL;
+
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, irs_base_address, len,
+				       &io_device->dev);
+}
+
+/**
+ * kvm_vgic_v5_irs_init: initialize the IRS data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	size_t nr_spi_bits;
+	u64 mmfr0;
+	int ret, i;
+
+	/*
+	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
+	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
+	 * is 4 bytes in size (or larger if metadata storage is required), so 16
+	 * entries would be enough for alignment. Keep the minimum at 32 SPIs to
+	 * match KVM's vGICv3 minimum and the VGICv5 device API.
+	 */
+	if (nr_spis && nr_spis < VGIC_V5_DEFAULT_NR_SPIS)
+		nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
+	if (nr_spis) {
+		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
+				     GFP_KERNEL_ACCOUNT);
+		if (!dist->spis)
+			return -ENOMEM;
+
+		/*
+		 * In the following code we do not take the irq struct lock since
+		 * no other action on irq structs can happen while the VGIC is
+		 * not initialized yet.
+		 */
+		for (i =3D 0; i < nr_spis; i++) {
+			struct vgic_irq *irq =3D &dist->spis[i];
+
+			irq->intid =3D vgic_v5_make_spi(i);
+			INIT_LIST_HEAD(&irq->ap_list);
+			raw_spin_lock_init(&irq->irq_lock);
+			irq->vcpu =3D NULL;
+			irq->target_vcpu =3D vcpu0;
+			refcount_set(&irq->refcount, 0);
+			/*
+			 * The guest controls the enable state, and again it is
+			 * directly handled by the hardware. From our point of
+			 * view it is always enabled.
+			 */
+			irq->enabled =3D 1;
+		}
+
+		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
+
+		ret =3D vgic_v5_spi_ist_alloc(kvm, nr_spi_bits);
+		if (ret) {
+			kfree(dist->spis);
+			dist->spis =3D NULL;
+			return ret;
+		}
+	}
+
+	/* Set sane initial state for the IRS MMIO registers */
+
+	irs->idr0.domain =3D GICV5_IRS_IDR0_INT_DOM_NON_SECURE;
+
+	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	irs->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(mmfr0,
+								  ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	irs->idr0.virt =3D 0;
+	irs->idr0.setlpi =3D 0;
+	irs->idr0.mec =3D 0;
+	irs->idr0.mpam =3D 0;
+	irs->idr0.swe =3D 0;
+	irs->idr0.irs_id =3D 0;
+
+	irs->idr1.priority_bits =3D gicv5_global_data.irs_pri_bits - 1;
+
+	/*
+	 * Support 16-bits of ID space for the IRS. This should be sufficient
+	 * for most applications, and the CPUIF is guaranteed to have at least
+	 * 16-bits of ID space support (we actually present 16-bits there, even
+	 * if the hardware supports more). Warn if the hardware doesn't support
+	 * 16 bits, and use the smaller value. YMMV!
+	 *
+	 * As for the minimum number of ID bits, we match the hardware's
+	 * capability.
+	 */
+	if (irs_caps.ist_id_bits < 16)
+		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
+			irs_caps.ist_id_bits);
+
+	irs->idr2.id_bits =3D min(16, irs_caps.ist_id_bits);
+	irs->idr2.min_lpi_id_bits =3D irs_caps.min_lpi_id_bits;
+
+	/* Only allow the guest to create Linear ISTs - simplifies Save/Restore *=
/
+	irs->idr2.ist_levels =3D 0;
+	irs->idr2.ist_l2sz =3D GICV5_IRS_IST_CFGR_L2SZ_4K;
+	irs->idr2.istmd =3D 0;
+	irs->idr2.istmd_sz =3D 0;
+
+	/* We have a single IRS, only. All SPIs reside here! */
+	irs->idr5.spi_range =3D nr_spis;
+	irs->idr6.spi_irs_range =3D nr_spis;
+	irs->idr7.spi_base =3D 0;
+
+	irs->cr1.sh =3D 0;
+	irs->cr1.oc =3D 0;
+	irs->cr1.ic =3D 0;
+	irs->cr1.ist_ra =3D 0;
+	irs->cr1.ist_wa =3D 0;
+	irs->cr1.vmt_ra =3D 0;
+	irs->cr1.vpet_ra =3D 0;
+	irs->cr1.vmd_ra =3D 0;
+	irs->cr1.vmd_wa =3D 0;
+	irs->cr1.vped_ra =3D 0;
+	irs->cr1.vped_wa =3D 0;
+
+	irs->spi_selr.id =3D -1;
+
+	irs->pe_selr.iaffid =3D -1;
+
+	irs->ist_cfgr.lpi_id_bits =3D 0;
+	irs->ist_cfgr.l2sz =3D 0;
+	irs->ist_cfgr.istsz =3D 0;
+	irs->ist_cfgr.structure =3D 0;
+
+	irs->ist_baser.valid =3D 0;
+	irs->ist_baser.addr =3D 0;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index ce269ae7ff6f7..a3f817b82c44c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -582,6 +582,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * Provide a way for the IRS MMIO emulation to correctly populate the numb=
er of
+ * IAFFID bits (which correspond to our vpe_id_bits.
+ */
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return 0;
+
+	return vmi->vpe_id_bits;
+}
+
 /*
  * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
  */
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 6b159a7e386cf..bc2fc5cb2c8d9 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -89,6 +89,7 @@ void vgic_v5_release_vm_id(struct kvm *kvm);
=20
 int vgic_v5_vmte_init(struct kvm *kvm);
 int vgic_v5_vmte_release(struct kvm *kvm);
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2f5fdc3211d7..282278e4a6c19 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
@@ -378,6 +379,7 @@ void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgi=
c_vmcr *vmcr);
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4d930a2651213..143e75743da86 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -40,6 +40,7 @@
  * in KVM for now. At a future stage, this can be bumped up to 128, if req=
uired.
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
+#define VGIC_V5_DEFAULT_NR_SPIS	32
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
