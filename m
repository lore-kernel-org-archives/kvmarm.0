Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011002.outbound.protection.outlook.com [40.107.130.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060F47B40D
	for <kvmarm@lists.linux.dev>; Thu, 26 Feb 2026 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121705; cv=fail; b=o4VQjTCKMcG/YX5Hux9QtUs6/iJ/04q6IqmhoqiuGL3X06M5LieAEI4Ni44Lyz1MmNoaY+2ZDNMRJ8exmVO7vZ2K8cWA7M66Mwb5R1/cQkiIpst/Ws1yqWcC3JaUbAbRnsHE14jHF10VippQnagwnCKCdZqa+5a+fht5gRrSH7Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121705; c=relaxed/simple;
	bh=laCGubCPvTDlXwznDhqmtVWe1DJ1gi36K+ZvdXegWuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nN3TZZDpz4RKA3nHHrr/Mhg4EfrVkkRN/0qGR9aIBPw6SAksKwTQ3Jgcrpyj3Y/4yppvbu7eKXGTaMKZZUvzXTl0HskQne/ZU4KGL33w2kSJafyywjn2WxI1Dx6c/h0L4RPBGjoruDcVO8m2L/RyJkrGlrDCQY30UJlfjtWIkQA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pmL0LBIr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pmL0LBIr; arc=fail smtp.client-ip=40.107.130.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pmL0LBIr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pmL0LBIr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SE4yl/YCNsw9xhN7RDQGrKuecl3UvdU6Uxwcu+97piYXQoIvEYKudU1FlzB6hx4LeX6TV0Ot0mJ6HYGpq+JzIZl2QVhoCbkAe+JKlz5ElmDusrCAXZm6DBL4M/m2YX8zYy0MeXJjV8nrzWs2KyAqQSYHQosc79g5UESSoxyPHqiCx0G73yRZDBVqBy7lhmlxhyz0qjmyXrN/R9gZLDhTcWhgKFNi23X4tHnJFmm1b6qoZ4qMOiTfFgHm5iRMwn2pWvtarfh53zLcsqa7M+KJYaaxw02C5Dc5z0MiAk9wQdt6IazwgXCP/uHJX009JwGkwYFtHjTneK6TRqpOVwviMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep1eIrfc78rZwm+CcA746Xggt6ZJs9IaeZhnt0JliLU=;
 b=tJazlMDGj6oeXUJchQOi3d1ICw+clImZl1YEfhhGfymAlJnpViVm/0EbVTa9eUSSBOohXTdiLMPou96ThjRfUQreY93WKlovjMJ0//wcEPIJwWTWIo2fx4K7bjx4E0kATd1KAOVL1wkmDPgsbkHJGk8+MCibL++LvSk8/7OJjaXhi01K5CoDKfN2izZboSXUo8b+RUWfrZ/LE+NCzl2wtv7RV5YTRUnmgdS5r2MOERnProPlhDq0JPVdDxsWZiW/Vf7g3Eva9TGA2LDeTqO8QH+wbAlI6EvWh5HW2TGyg4hlfilyqlN1ARuo0hEqZhGGoJEtz1rGQvh5YSiTre75NA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep1eIrfc78rZwm+CcA746Xggt6ZJs9IaeZhnt0JliLU=;
 b=pmL0LBIrAm0wThDWaMw8vU2cVcgZ5ObckVC32JBP1YSN8wiV+jXm1e5JmCVXjm8jx9BBSnwypU57+bSuhhPqv7PgxiRYBfZJHMKjgNYmFsxXWj07M6E4uYnh8Y6xj5FD5j1tRml+9Fv6zKL5LvNYJa5Tao0GsbSf3eoz5c4Ic/0=
Received: from AS8PR04CA0100.eurprd04.prod.outlook.com (2603:10a6:20b:31e::15)
 by VE1PR08MB5744.eurprd08.prod.outlook.com (2603:10a6:800:1af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:01:24 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:20b:31e:cafe::8c) by AS8PR04CA0100.outlook.office365.com
 (2603:10a6:20b:31e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 16:01:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OqIPBxV8026rNIl5hqKOfSxr/XSEp9lP4AIo3ZRSvA1VkzG3XOEknHHueZmmc9/49md6mjyRRaWt+gErgBPaPZZfEfZAOTfNvZPSFCkIIhmplruMMC+eexK1U+ahKpp9A09IhjGo6BQkaf47/RCX2+maAEDSjLO/P60zH/h9nGnZWasn7DchMtRjqp723rWgwDuog40NgqlFNtNceR459wHiQexAoWUQQQ6GEf6PQ3DJxL6VkWdo0QgKxaxUf0k96OA73zXRgXddLrH8dR704WWiisez5UB57vtf0cSz+qH29Eb3Gu3KqalFN8tg9leWKzmRWkjK7JvYiBC3HCJpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep1eIrfc78rZwm+CcA746Xggt6ZJs9IaeZhnt0JliLU=;
 b=TDNL0TPGj5pRyFow8xNr9Ve+d1lF7rggtruEGfE35PGtu4i4nNnps0tSMD3QtOJv7ggDwqxzVWPm8eunHUIdjzpfaAsHAw9eYv3nQMWiJQlWXLiGFo3W6fxHkLaARAkliMouHv0QEiY2rxdGxxloA/JE6jvzMLeFN0lTIoWsdK2g9q+q13R/ZnrsFTJR0+i0LVAfF8FXLf25jdyU5TKk5b2E5ATkSt5eDxvKnEEF4CJBcA11Osgu7Jh3Tdb4axD/Dd4kFM4ZPNm2tioVJKcCjBZTvQymrTWkhzO9z/YzNYxKj9a9FrzR67W6mH3N3AQMHQQl0Z7IQy9M0kqo89vMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep1eIrfc78rZwm+CcA746Xggt6ZJs9IaeZhnt0JliLU=;
 b=pmL0LBIrAm0wThDWaMw8vU2cVcgZ5ObckVC32JBP1YSN8wiV+jXm1e5JmCVXjm8jx9BBSnwypU57+bSuhhPqv7PgxiRYBfZJHMKjgNYmFsxXWj07M6E4uYnh8Y6xj5FD5j1tRml+9Fv6zKL5LvNYJa5Tao0GsbSf3eoz5c4Ic/0=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:00:21 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:00:21 +0000
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
Subject: [PATCH v5 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v5 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHcpzkCzY33xDS0FUK+BHWIRp9nlQ==
Date: Thu, 26 Feb 2026 16:00:21 +0000
Message-ID: <20260226155515.1164292-20-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|AMS0EPF00000196:EE_|VE1PR08MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7bd879-e4b8-4af5-9cfe-08de75504ac7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 A9/lF8s45rIDZetEwJp3BGwUglRK7v1jvB8Y6wC1w6KoCqYON5BsnNSSDgNoqotTTAHKNMkgHdHM/UNFBq+CPe+eCppcRE8L/mNs8UB7ljt21L91jakYIPfwrSL1zoQe+FGKMbk/iwr5dd67sBUFGRF1z3WdCPZ7I1SJjXZTF+c5K6SyEoMpVT3wuOwKYogieAFDfJC58q1lG685y3F27Lc4MfM3egUJdGZsMG9apgI0hsdDdnw34Jq1BrOOcEBg91VrbkIExv0vxE4ubLGVdO95QjGy0g7fAlyUOXbs5G1kwiANgAQe8LOKKAzQSSLImyIjurMPQIDZv+WpzzQjuNY7E2xeiUi2BkKnF1ZqY9YbiFsiNEt9LPfQ5wWoutMjlDgQL9b2PmhQzm6mFOtnBTOmL87P233PB18LQLqxQ3L9E7A+WziELqaIatNSmN7B9sG2kcvTSOl1TUuifoXA+P/bf8NNxkYAXBu9vFEvAeJJmg4uKQF587oXKOASHESnHOeZ8AFm7EipOFlag47WOTpkrZH7hexuVO7oMRHqMZI0MihyJox0FvhyfK44111wWtcqKDzOYi3czMyAHW+W8z1EntdP0yf5xbIeL0WImi3TfHFrs8Hozz9X9TzfOfYFTHhaFIHk91pH6KX6jAzzqmrtZQugG6r4s4btjjeA/6VmSe/dB3vN8QHOP/4KS/Ukc5/y03ZwLbndV0wTE+blbn31cx3ZSFZuH0Qr9PbRjXRsuBtX0OkVuHPr43DEH3kuaH2bllkvvxs4M7ldIIHkUaAONUFCQ5kZ34i5AwNDOXg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	64c59a69-592c-428e-6e91-08de75502505
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|36860700013|376014|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	YJ+8HiLv+j7wS87vrSUPUfgpy1dKOklzfCvfv5K6hMza1Dvd58a2Kfhtd65eW2PglJlc9zlljCI+I8gt+b7SXdCippawcLggGwGMH0dC/uIKW2axubQmT8AGyq9aOhSerqW1lXp7FAA0Ju7VrfURAovFx8dhQ6tZgOjFinv7Q45FH6ttOQESOH1k3jKEhFvUB1GUNjqsbC9bOJInjk37Ww5rDiq7d/DscyysWfGEH77ytjihNEF9HTMfCpOYn3CweMkyl6D4Fh1lOzZZELO/NJfjdH41R3z4tJlcmRke6aIEb8aVGQd41ON3Rwi9+i5rXSmkiY5kPLoKX49kMAdQFfwZbBJvRFEjLeFQQ8LzH0VmUF7ntmbA0a+Ogy2A5mAAaQ68iaFlg+Ev2jMeHVEdcRZ8zJO1Ju3mneLtrPX7LGpbYuTZGMG+DfFRSaY5zZAR/RbutZh6O6J7xkMbnwRuyrk9+3dkr2AdfStAipTTwdjim1WFAjyMhVbOplrX+mM82eu8ynWVJBve/KfgVpIj5Fe1KWila0evWEl4NpT2l75E/JSefaGmYxaIs4D8QZga4krYlCql0rmCKGg/oH/nxSK6ZZnGrBjnlGDQzsLB4CihMP0vVvIQ6CfyqH9jicTUBQxWAwXybF9UhmVxYg1G54jPuT+wU3bP66GJw2KIoB6CrshNpynOLo9GD8j9RPioqCKQwOuI4UZy2kqylzh34KqVlF3d8iudyvZ62lmMNrNIJvxRxLwyZU+i+m1qsnMOgQEJGSBWYs3tffTpYkx50HiY3/Iv7qxbHWRxy4CzJiGEW8LLm5mCQicWjRBvKUgrQlOUl4ExkFolxs3uH1MfOw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(36860700013)(376014)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iGLADgyy6camIeQbQkELgnQxqwpzod1yqU9xWPOE2KBe3wEy2XLJntQxDcRJ2Gzo+T5GjyIU7IdhdBKkWPEfOn6OrjKteb+mDdfYIn2UT9fVzj35hruPSUCCotUBenXOiBD4LgjJslYoHkARQeSkARnQyd2+Sth1Orlz1Granagy1N0zxpV4m7FkcDQJuIiCx0daQhqMnXyCg2bBAYLe5loljCoSeF0dRk29HLdYNYyp6zAqyueIcqnWFJtNUaEnP3/6ptCHiAdkWtibPZrhwkyRkX0NsygRJLjTHEWMQ819z+2/9cS6A1sn2IAacHGCO8EbdZRNol2cD7YD7CuEgpZwfgV6AuW2LDE2h1VJf6uJxLjJP8mSfZ4DMfchIdn9+4ochrMUs2uQb+UQLMD6PnVUxUf0oWx4gFgMaIHfsEIiztkiTR1E7YTJGSyXAQ4r
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:01:24.4538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7bd879-e4b8-4af5-9cfe-08de75504ac7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5744

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the
PPI-specific vgic_irq structure. The PPIs are made pending via the
ICH_PPI_PENDRx_EL2 registers, the value of which is generated from the
vgic_irq structures for each PPI exposed on guest entry. The
queue_irq_unlock() irq_op is required to kick the vCPU to ensure that
it seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state() is called from
kvm_vgic_flush_hwstate(). This generates the pending state to inject
into the guest, and snapshots it (twice - an entry and an exit copy)
in order to track any changes. These changes can come from a guest
consuming an interrupt or from a guest making an Edge-triggered
interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's vgic_irq state in vgic_v5_merge_ppi_state() from
kvm_vgic_sync_hwstate(). The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 160 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  40 +++++++--
 arch/arm64/kvm/vgic/vgic.h    |  25 ++++--
 3 files changed, 209 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index db2225aefb130..a230c45db46ee 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -132,6 +132,166 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
+ * hypervisor) handle the pending, active, enable state save/restore, but =
don't
+ * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
+ * state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq))
+		return;
+
+	guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+	if (!WARN_ON(irq->ops))
+		irq->ops =3D &vgic_v5_ppi_irq_ops;
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	for (int reg =3D 0; reg < 2; reg++) {
+		const u64 activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit[reg=
];
+		const u64 pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit[reg];
+		unsigned long changed_bits;
+		int i;
+
+		/*
+		 * Track what changed across activer, pendr, but mask with
+		 * ~DVI.
+		 */
+		changed_bits =3D cpu_if->vgic_ppi_activer[reg] ^ activer;
+		changed_bits |=3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry[reg] ^ p=
endr;
+		changed_bits &=3D ~cpu_if->vgic_ppi_dvir[reg];
+
+		for_each_set_bit(i, &changed_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				irq->active =3D !!(activer & BIT(i));
+
+				/*
+				 * This is an OR to avoid losing incoming
+				 * edges!
+				 */
+				if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+					irq->pending_latch |=3D !!(pendr & BIT(i));
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+
+		/*
+		 * Re-inject the exit state as entry state next time!
+		 *
+		 * Note that the write of the Enable state is trapped, and hence
+		 * there is nothing to explcitly sync back here as we already
+		 * have the latest copy by definition.
+		 */
+		cpu_if->vgic_ppi_activer[reg] =3D activer;
+	}
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	unsigned long pendr[2];
+
+	/*
+	 * Time to enter the guest - we first need to build the guest's
+	 * ICC_PPI_PENDRx_EL1, however.
+	 */
+	pendr[0] =3D 0;
+	pendr[1] =3D 0;
+	for (int reg =3D 0; reg < 2; reg++) {
+		u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg];
+		unsigned long bm_p =3D 0;
+		int i;
+
+		bitmap_from_arr64(&bm_p, &mask, 64);
+
+		for_each_set_bit(i, &bm_p, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq_is_pending(irq))
+					__assign_bit(i % 64, &pendr[reg], 1);
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	/*
+	 * Copy the shadow state to the pending reg that will be written to the
+	 * ICH_PPI_PENDRx_EL2 regs. While the guest is running we track any
+	 * incoming changes to the pending state in the vgic_irq structures. The
+	 * incoming changes are merged with the outgoing changes on the return
+	 * path.
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[0] =3D pendr[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[1] =3D pendr[1];
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D pendr[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D pendr[1];
+}
+
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 49d65e8cc742b..69bfa0f81624c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm)) {
+		u32 int_num, hwirq_id;
+
+		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
+			return NULL;
+
+		hwirq_id =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+		int_num =3D array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
+
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -825,9 +837,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_fold_ppi_state(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
 		vgic_v3_fold_lr_state(vcpu);
@@ -1034,8 +1048,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1059,6 +1075,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1095,13 +1122,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gic=
v4)
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d7fe867a27b64..47b9eac06e97a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,7 +364,10 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -433,15 +436,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -487,6 +481,19 @@ static inline bool vgic_host_has_gicv5(void)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1
