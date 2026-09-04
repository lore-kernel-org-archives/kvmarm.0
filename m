Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012059.outbound.protection.outlook.com [52.101.66.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4982743CE4C
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521910; cv=fail; b=L41aa2EHOUx+ZQNWU89okXlKwenJi3UI0DNDUgwiKdlkdJzpUZ1jZQSOGqy71eYJPmrzFxI0kSCyarFAoCqDTSl4uiBK3W/2jnxIoSheEl5JmYDdmbk23yzjYuS/VNe7zcI3/z6rSG7lbiErncQ8mFMqCERj4tXwi9r8VGYO22E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521910; c=relaxed/simple;
	bh=66gS5da8DiTFqE5n3VE4eeYqTezgKFjF9xq/+LRJtho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j7WJYkkNmuf6Rr2lTWH8QOw4LDbw0zFezlRhGq/2JOoZn1fr45hWDzLJmbg0TsAnU/C0Iw+TOxD678Q7sLmch/54vTWLoc+tBmWe2lnmNeEslgcM2zSUWrgBatkAZQJOgKN47qRj7vNVjzTGsQGbPAx3dfTHGcF21Rgq4DG01cA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fBuxhxJi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fBuxhxJi; arc=fail smtp.client-ip=52.101.66.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fBuxhxJi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fBuxhxJi"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NIxXDap7ORnHfCgbDJZK5T78jEKO5dvpgjyVpItcZB+/Hh6ADsmgsCG9fAjRyFe4gybPBTIRm2XhzkGbhSCUFD/kE7z/F+0ZQyM8Fjqt1uR8zMef4XGFv//ROxJl4bhefa63afDLfhFw4t1cnbVyhfLzpXs4QnkQ/KYGdskgGZuxbjOTa6OAt4jxvjD9/n4dpvTbYCxMeZk5X/S0D8aRD8ToXyd2/wrply+XXXW6BXFII4kgyBoOQSlCp5zWoCrX9Oo/DZvvgAnnW1534oRHOdqXyblRl+03T+xIYAQG9hpONwZ5id/NdxQWsEO3kj55R1WGPDFIgEseJ9CspTWPpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7w90ZU5IDPF258Vp1+YVJRj1dXrDgPxGrUw9JPbgYs=;
 b=JNeeJeacAF9hm15lJebxWpTxCK7d8a2w8Wl0J/1LxnWKUrw8Udkn4qAYS4vYlizmvHvASY/zutJq8oo0nfTCgkxjrIo9mASNvx343Tona0q35Pwqy0TxCDg6v2IsGNOzKzJTXmdGm7MB7rdBRWiJsghPdRBJDzYS0FhICTYMkhzIR1z14598fxDEK3l6DFDbThtxbFjaX0jC7VapoT4erfpHjSrsUdfaOl/69MAOnHn/5qxRHjbXnLv546WEtMS3949tI4eYr9raPcALGoMnGgZujmx/PpVizvNUYs7EQfjQuqsLsxwOBVwY7FiDu3vRor5Og5cSZYrD8KXL6Gip4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7w90ZU5IDPF258Vp1+YVJRj1dXrDgPxGrUw9JPbgYs=;
 b=fBuxhxJilt1+5ivvw7hSLOLBb8/FksnN6CScsU4WKTkY4VtpBfQ1px5l38PDkUJuvo0uCaG0QeYRIMtRFxpcyyK6zj9z7aMoXmzEy4cPPwA6s0Qoi9ZF7A7yXLCc0TvT6EwTbKoFKALaqk40IpwE5NwoWZa87mRPqBptZ8KXuEI=
Received: from AM8P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::17)
 by DB9PR08MB7747.eurprd08.prod.outlook.com (2603:10a6:10:396::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:38:23 +0000
Received: from AM4PEPF00027A61.eurprd04.prod.outlook.com
 (2603:10a6:20b:219:cafe::87) by AM8P190CA0012.outlook.office365.com
 (2603:10a6:20b:219::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:38:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A61.mail.protection.outlook.com (10.167.16.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:38:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLc8wOlCleBjbdkfhjE5z+ak4CUyY0FWOOcbcG4UceJB1CFF+S5WOwf85ZH4U8MJAOYGJLKQm2BkER93uKbbxlUnDb8B/JqiRYNNkOL/MJlC1/nZ897cBDhPsyQNLagem5BSgblZjN/hNcOszS7y+ML7Qt7msPoq3/8ZwtTvoDal5afqAPJPLF7GVVzDx9KRwUSTsAkRVKELQDUOAy4Po4qTizp3V+NO9OTOJoNqNS3+qEAAVQLKEuxa0NFqTY2i0EQhKqB6A8FCA95NcwCwSASXMrdA9DUW8DfisJ0o+oFKV7Ea+UCA/cy5p4kTXGcY2cOImG9T64ijghtSvInEQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7w90ZU5IDPF258Vp1+YVJRj1dXrDgPxGrUw9JPbgYs=;
 b=oxxSu0hrohF+05pk5YSzGHnftUq45wAItfRX+XAOIt8B+H1UWqRa6ny/xKlIykwzQccOkryXZIzRoiyuuboaRsr6xp8H1wW19CmKyM7OrKEEP4qjppvEpfguDXLCrnY3JoeUslGu7rHxH6P85AGLbxmbrh3Ii1U3wFE41/VDgZwmtgYSA/9Oj3kV3fkhwN42+aq169xPpaqDRmKZTxjKSOgOesPsvdSXbLDgaJ3JmW+YkZ7NQgFPf1R8Q/wdHAr3WhMNnkv5hEHoZ0K8JxDZokSPbJmTUXkNk8Hdgg6Q2k4ceNIECqAPuF5kqFZUocFF7evhmky/u6syV9PnGv5b8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7w90ZU5IDPF258Vp1+YVJRj1dXrDgPxGrUw9JPbgYs=;
 b=fBuxhxJilt1+5ivvw7hSLOLBb8/FksnN6CScsU4WKTkY4VtpBfQ1px5l38PDkUJuvo0uCaG0QeYRIMtRFxpcyyK6zj9z7aMoXmzEy4cPPwA6s0Qoi9ZF7A7yXLCc0TvT6EwTbKoFKALaqk40IpwE5NwoWZa87mRPqBptZ8KXuEI=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:37:50 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:37:50 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Topic: [PATCH v6 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Index: AQHdPGHQ74/OFJmmoE+ghGrlQpzBDA==
Date: Fri, 4 Sep 2026 11:37:50 +0000
Message-ID: <20260904113404.4051341-8-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|AM4PEPF00027A61:EE_|DB9PR08MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b97aae9-3b09-412c-9ee8-08df0a7906af
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Ij3myCwhVeA1IMqwIkaGMJgFU/SZh+ckt+nCdx5KihPqaV2/vx2ZGXaHQ9yhKjdC53nV/YUVpVNtaVAi7PysZ/3mZ5v93swPjuzWHnFD7a61UHZUGM1jv/BKtqpT5dzTsVJ26EXb2O3lXW90J9eaIQE97JePSYTZ4DQd7ybWqcVuCFXDV9i9zZIAHMUbkntUWwIuHqJ50G/RCRsz2l3+Rc1ciwMDV0/EZEsWafrSv9f+SuV1hTA/KLBl0D6MDu8lIrh+G0foGfNLjtuqfOmi9fFejJzO8z813EFnI34qRdmdGOXdJp8xzJtpcxhyzuGShmenEyx1BdktCpKNb1zVEyap8GBZJRaiT1ODkbynRJLLdyWBz5tIJBvaTxLmNpbiZFpZYDnYGlBcXrr3B7V5NYCwkXeHylEqLHq/My9y78+IiFM+XhHd67+jimjyRSrFyR09QWcBqnyTO+tQIZsW1XAjKzaWfxd2n4LF5QZXPwiiSV47WItp/R5sN1FyK5DbttIbfkASxjbZpInXRAZFMAzCYrBbjiWBbMILKnPXSoP4QDr6wuH9ubumD296I01KRi1p1pxK3p8EAdDkkncnxcTF8lSYvnR3ivhxFjfjyOntyEZW3ZPoNKdgbovKWkHGyKcETN/GlDRKplW7ed8emfuIeudHOJPAqXMUAturiKU0k4758t5x9YYw+chk7B5iDVZIcP3BwvA05TNPa4UinW1n/qc4w2sLOnER0AAHMT4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 c0x6p+CZJGJtoLtI7Gd4UqgU+dBi8MAvJzEZQawspOuu22H0UA8TWS/vMlseX1jj9ZlCib+MDldhEH2zj9LeVnIddA19YIes0T9fR/jkRmJ7rdRMvQ98GIxt86nU84MZdeBm87Xnz2eBtgP91GNtf26X3i6osNjVorwcak8aamlk6SFgmOlOQ3cMaqB7V8auaW9GEfuJZyO/Z7JyDKi2ylIs9AET1ccCov1Rd6ht66iyFmQu2MFbN7WaZd1ABvN1YLW8ZCJwi+Gjrgb1A22qPMHpeDJU+IiyMHqpSUYABZxL2zpJfJQWBi2ujlTI/7NGSf4QNMNMWNeb9wFfu/RGXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ed9eafaf-341c-4b3f-24b8-08df0a78f340
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|376014|1800799024|23010399003|36860700016|14060799003|22082099003|18002099003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	xNfI9VBEy2zY/371oflyk3YCLGTiOH26NPNoJwojA3DY8IOnWo6+vFvcznAxgVl+5tgk9XJHUkv0qWNynXiiC8196Y736j32enZfwHCMTA1TFexhpXlHFjW0YZbe+E7RRlPJ1k+BvLQvhBl0/OHaeSW+NHbsywGtGxLtcAAA8ijc/u+k/SmXfAvcBnMDeYUb/3mZksD3avCpc8HsNAX8cfHyWvGNyMKpM8x1rjc0UTnREbzRZgR0HqBKViDQ/Up57dk77bp1Kuk6vqcLx3dzc0bJdUw7wFxC0RcCoqE/W5DMQnhbBchxAP9YXE2lGQtWVPVNAD6RZTqCWGV77ar2EPZPOjBFDngz8Z9GMQJHhNNd7YjXf+NQsCA/clJgoL0gNxWFgNTzY2rvGPqkJJNFkC+133ZbvYo+gHclEdPW/vWK8xuHdP6KobgJ/iSEeOFhzNQANe7HAnS/uMJ0CoJrBVkC9TvnV+TzW7+VAWuPljVP5Rf3Bo68f5GxFZy6YrC6rX1ydr78zBXE5roGRXeBmjGKwXTpEaptEqx7LTjeBp5A8sQmfxZZbkl39yqbEs8y01HkmHLW6y6SBYJs3wso8RjhRfICzvbwVSmcNG3g7nPPm9dhp/dGzGUVTZ5MyzZxbipy6oahlXl1RkRqpSIMO94k2x/bxmnR3R6CiCQdjJ4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(376014)(1800799024)(23010399003)(36860700016)(14060799003)(22082099003)(18002099003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	r7QtP7UNqmDWU4O8zFO9radpRwMKCOrEEkp849bcCAbpp4mIb1UvE7ULHgjNuqpEy7d0x9m6znbXOmTc47XUsT1fiGc83O+7q3vm4BRMRj2mIHPZX8J4/5AHqxJ4F/XbIn3MUjbgfSCteisPXLk2+DnXPEd1d/elDIvu45W41hYp4T32BbNEASz7qBo8Bi4DqlxbBNztHgjZdMdT7rFNJNZg8HEe9KYHRFMpHBhAwfMvp89t7ziDDZSAmMqiRwVgUKl2ufAUpKb/umNhZRSp9vw93B6tx3hW/4IvVezFeiNDs++qQ88NsBiiFvQIqMSvqALvDd+7QzX10pPzAVlh6UOZpBgO39C0SYH3EneV7d7tRnyBoUyxWhK3VOySf5ZKoew7glGT/BKHhjuGR7+1RiIJD/lepWBdXFCojGzH5MrydpyXiLdE6yE3eNCa4ZS5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:38:22.8376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b97aae9-3b09-412c-9ee8-08df0a7906af
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7747

KVM needs access to the host IRS configuration frame to configure
virtual-machine resources. The frame ID registers describe the
capabilities available to KVM.

Cache IRS_IDR2, IRS_IDR3, and IRS_IDR4 rather than extracting their
individual fields into kvm_vgic_global_state. Accessor helpers derive
the required capabilities from the cached registers.

Use the cached IRS_IDR4 VPE capacity to limit the maximum number of
vCPUs, while retaining VGIC_V5_MAX_CPUS as KVM's own upper bound.

Keeping the raw register values lets KVM adjust the exposed
capabilities when needed, as is done for ICH_VTR_EL2, and avoids tying
future EL2 code to the layout of kvm_vgic_global_state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 22 +++++++++-
 include/kvm/arm_vgic.h        | 75 +++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4e3e4db24e773..e75a66b3920aa 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -11,6 +11,7 @@
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
@@ -34,6 +35,21 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void vgic_v5_irs_cache_id_regs(const struct gic_kvm_info *info)
+{
+	irs_caps.irs_base =3D info->gicv5_irs.base;
+	irs_caps.non_coherent =3D info->gicv5_irs.non_coherent;
+
+	irs_caps.idr2 =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+	irs_caps.idr3 =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+	irs_caps.idr4 =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -60,10 +76,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
-
+	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
+	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
+						  VGIC_V5_MAX_CPUS);
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 086b7578e5f33..c82aa7c9e3f32 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -132,6 +132,19 @@ enum vgic_type {
 	VGIC_V5,		/* Newer, fancier GICv5 */
 };
=20
+struct vgic_v5_irs_caps {
+	/* Base address of the host IRS's CONFIG_FRAME */
+	void __iomem	*irs_base;
+
+	/* Raw host IRS ID registers */
+	u32		idr2;
+	u32		idr3;
+	u32		idr4;
+
+	/* Is the IRS coherent with us, or not? */
+	bool		non_coherent;
+};
+
 /* same for all guests, as depending only on the _host's_ GIC model */
 struct vgic_global {
 	/* type of the host GIC */
@@ -182,6 +195,9 @@ struct vgic_global {
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_caps;
+
+	/* GICv5 IRS capabilities */
+	struct vgic_v5_irs_caps vgic_v5_irs_caps;
 };
=20
 extern struct vgic_global kvm_vgic_global_state;
@@ -627,6 +643,65 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+static inline u8 vgic_v5_irs_ist_id_bits(const struct vgic_v5_irs_caps *ca=
ps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_ID_BITS, caps->idr2);
+}
+
+static inline u8 vgic_v5_irs_min_lpi_id_bits(const struct vgic_v5_irs_caps=
 *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, caps->idr2);
+}
+
+static inline bool vgic_v5_irs_ist_levels(const struct vgic_v5_irs_caps *c=
aps)
+{
+	return !!(caps->idr2 & GICV5_IRS_IDR2_IST_LEVELS);
+}
+
+static inline u8 vgic_v5_irs_ist_l2sz(const struct vgic_v5_irs_caps *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, caps->idr2);
+}
+
+static inline bool vgic_v5_irs_istmd(const struct vgic_v5_irs_caps *caps)
+{
+	return !!(caps->idr2 & GICV5_IRS_IDR2_ISTMD);
+}
+
+static inline u8 vgic_v5_irs_istmd_sz(const struct vgic_v5_irs_caps *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, caps->idr2);
+}
+
+static inline u32 vgic_v5_irs_max_vms(const struct vgic_v5_irs_caps *caps)
+{
+	return BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, caps->idr3));
+}
+
+static inline bool vgic_v5_irs_two_level_vmt_support(const struct vgic_v5_=
irs_caps *caps)
+{
+	return !!(caps->idr3 & GICV5_IRS_IDR3_VMT_LEVELS);
+}
+
+static inline u16 vgic_v5_irs_vmd_size(const struct vgic_v5_irs_caps *caps=
)
+{
+	if (!(caps->idr3 & GICV5_IRS_IDR3_VMD))
+		return 0;
+
+	return BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, caps->idr3));
+}
+
+static inline u16 vgic_v5_irs_vped_size(const struct vgic_v5_irs_caps *cap=
s)
+{
+	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, caps->idr4));
+}
+
+static inline u32 vgic_v5_irs_max_vpes(const struct vgic_v5_irs_caps *caps=
)
+{
+	/* Field stores VPE_ID_BITS - 1 */
+	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, caps->idr4) + 1);
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
--=20
2.34.1
