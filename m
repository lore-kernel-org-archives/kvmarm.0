Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013031.outbound.protection.outlook.com [52.101.72.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB1476688
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522611; cv=fail; b=aHmiNRIgkwqsLHnNDN6Xme3RhqifQBbfCaWH85XckZaTxGTkwUnCDnQGflJMvuEF6jVKUxEiNKzr1CDZgSknjTsQascRt7ancOfkNQKNh4zdOerJOElnlnkXY83eHwO3bF0xqDSD0V04iBQs2E75btLFU40Te9cKdwj8myQU1oo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522611; c=relaxed/simple;
	bh=MS7mh6Yn5ZarFnQ7MVcu4b+fo48COVm0beuIi4Ay4OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NuvcFf9Egnsl4/59iSfSD7JZ/PhdH+Br8UZOQg4kbZ5J33yhgJSMaKz+4J4E+Y7YhVSCTVdTPTxvhSkJyuBbyt0v2DStI12qHUM+bPW+IfBMLwjzXPoTsv1UXtmwyTYyModndhdBpBTCMWmOyA1bU3yDCHXS9gOLeqZjibz6Gmk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n+gLFxqm; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n+gLFxqm; arc=fail smtp.client-ip=52.101.72.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n+gLFxqm";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n+gLFxqm"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nOHD5jeZsF2qg1tiCAtnqrMdkjVe2dC5HNQ3Ve8U9/2DlEW9EQu7XXbaIJrEMnXDmp9JqQH0Kqp/RB8lqW/1Db8+gjLyrXzqp0kdziN8ZQkVl9dTvDfNbtaH9Lip8WxfuNgN+zwuQWNtE5DFsgGjmVvHt4W7RWdvwu6L0mwW92Is19wKDQYp3rz/LnXicoDqSBEjoBrFnDFyoIT47SgR+ksV/m3p/nFNMKu3dKHGsz8aFpoJM0VAaLlA35RZJGfDy9UDcsPDQ6cGT3YRpKhj5PczYVX4WL2DVNUwJ96redHycIawmjhk7FJuPQdEHnPm1kLIGEwuAG6RxT51rBF9hQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+DiuflHpryOijGKMMQYmpmMgiJRhmUuFCnt7HUc1AI=;
 b=AxQAElAnDxl56qZMHAcfu1V6EeRqVMdu0UVRF1+8OhWkR0h3vRjzha6c9ULrqbbwCJUhL9vETiGX/u83MEJwrGqJ7gTiYmDIx+TPM1gagPKmHD8MBjNrdRJY1NOrJDaajBr5VvJAZUUfblH3BtsX4oL0nM8BVVlVb95Kn2LjZ+1PaRXLuCgI9p9BdHaaRH1uea/s2kfp4eHATLStPurRMT+iTZBM/ztz2XrFgp86HmnRgh/BF9Czn3rE3VklgZDU4Ra7bCzvxbKc9OpRCcXWOwDN2aV3Zh9khFmfy2hjj19XZ99LLfKMoxWQVrcvq+wqT3Yt7gaZUR2weMRuxlYNtw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+DiuflHpryOijGKMMQYmpmMgiJRhmUuFCnt7HUc1AI=;
 b=n+gLFxqmqS/lHRu3l+7Sy87vpIKCwA4sQ42IAcwb4NpvMVzQKAFuZJFyh8JA4xwmrHNwQFHITj9e49wjprusS9d8b7W9pwSQhLwwv+ymdiIstJtvDzWSNjSW4mChp3yNIfiU51dYT9B7dn+jjot+54IzA9vvgEkS1XXw9sTuEjY=
Received: from DB8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::25)
 by VI1PR08MB10175.eurprd08.prod.outlook.com (2603:10a6:800:1cf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:50:04 +0000
Received: from DU6PEPF00009527.eurprd02.prod.outlook.com
 (2603:10a6:10:130:cafe::a0) by DB8P191CA0015.outlook.office365.com
 (2603:10a6:10:130::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:50:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009527.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8 via
 Frontend Transport; Fri, 4 Sep 2026 11:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LhPXigKkVzNRYCqJC/S/hgj2E/G5nl74a0SVFSSswQKrtarLJlyYqycRLvRxky5PzlG/xpZB6q5HshaM/dyYLSJX108NOBlyvWaKzcVRmjDJYQUYs2Aer0S+sLbWuZaqpV+Jeis99L1vVgQfKAJnwgOPGAaZFOU7lSVxodTDbb4iklnA0pNdvACF16hsmFmqDjo5GEYmOUFjp2Y7NfIuQ+0VUP0Xca9XsoPZXikVEx/URaLMcwhM4Kvo/aP+SC67VukrG+nOxFPR65gai9J2k467iLhDv7KGngKbWutKqJD8Ip3VNFQ1cGBWyUYJq2i0V44ASbA3pVolGfP5q74/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+DiuflHpryOijGKMMQYmpmMgiJRhmUuFCnt7HUc1AI=;
 b=HFwuHQxe+bWSSoO6ksU2277hDFMcvw78fIa7Y+pkt711j3iCBcXaJwYUX4SJa9dFAg4jdeREdz4kVNevBVn5F+ngnbwIzjt7v0+f+8aXasmABTH230xnthprR00XhH0czZedVJ7F+dPoHvfg65lOvc3KXyizHxFr9R5ZgeLY21na9h7Qb8aaC1PucGvzQtzqFUq9kHqzzv3f1+127XJPrVaDkPEN4C24asuEUQZIzcpwIdkUPI1X7MkZzjoIazU9BIF3KtO6zRN/lrHDv5wN+0NNkJinxLpn9wGpf5AJFqEcBE5omYGItb42RaVzRjXwjNd9RwrL+P6QnsL9hU9iMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+DiuflHpryOijGKMMQYmpmMgiJRhmUuFCnt7HUc1AI=;
 b=n+gLFxqmqS/lHRu3l+7Sy87vpIKCwA4sQ42IAcwb4NpvMVzQKAFuZJFyh8JA4xwmrHNwQFHITj9e49wjprusS9d8b7W9pwSQhLwwv+ymdiIstJtvDzWSNjSW4mChp3yNIfiU51dYT9B7dn+jjot+54IzA9vvgEkS1XXw9sTuEjY=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:49:32 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:49:31 +0000
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
Subject: [PATCH v6 30/49] KVM: arm64: gic-v5: Mask per-vCPU PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v6 30/49] KVM: arm64: gic-v5: Mask per-vCPU PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHdPGNyug42waMfsUqQiktklCAMdQ==
Date: Fri, 4 Sep 2026 11:49:31 +0000
Message-ID: <20260904113404.4051341-31-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|DU6PEPF00009527:EE_|VI1PR08MB10175:EE_
X-MS-Office365-Filtering-Correlation-Id: 049f1b0f-d47e-46ec-42cc-08df0a7aa8c5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|3023799007|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Prdcw5xORAyPtDib3gqxnoLo+HQ5zR2R57M+DhD/g4kok5YHH7aoT2wU6ojEKByWoNx+s1QzLc35uSzl/jSATB55ZqVASkqZ0qbJfheBZjil5hQiV/S8LFWGT7oCPgHUgsEATTChfqnqLW6M5hCQxgNjN6dp8r1WJxEV4Tzn1+7mSruXXmCane7/82u6bo+3h1yBMExVgK7ul5CoUYOvPTVTkwl3v1lRwdj1RdGuQMcC3f+4rE+oiBpkMx4nPnoXAQ+9soTUeBcLeANUQ/0MfYq+jtFZ6dPP+1MtTxVJUu9r4glu4Q85/AIkWqDTgqjYwaqwcfvaXenJy/+iiuv9SIwcScuLA1eLkRQJSF9O3+jmi5lZz7/R/iJDysquXBtdM64+m+2fNfCq+MRvlf9sidF9WFj81NL2NxTeKLm6kzUke28e/VG3nsyjRcLnF9ikiAvDuJjlMV8pa8tXmgtDlfI9XS7TyVoS6B0Cnz/pwbQzaycqQJj06Sbvn9FfkjOI667P4vMfKlTaCQR9U/3fjAvWvmiM9+kPU3/g+S9twzPMIsI9rYyM3PKVIHYbISKcJrDDmIvOavvSeG4E3/a/Qt2paDCDyTVbC5E3I+pCq5P/4hoEyDGS+kIp9gHRiNf8BgiFjmtjSaXGjJm1jf+fB2NQ3ec6nwQReV9k1a/2EFE3Kar870UEOiKhzKDjG3W3dapqXZ2KqrSW8lcRVE3LKTl3atXNkxGVLPrSYRadvE4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(3023799007)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 V7CmXmDEFUIBjCpRXmLlnmPyjXoRxtWub2PNLYdbnZNuOJR6sYavywiAdUdmIWgkqWWRCDu5JM7ePYhlouMqbc0ei4DFDwK0xdCUNUucsqvc1mlehfn0aJnLapIWx0zhQC9MWe9tG/njfX0wlZKPlFuKSrgdcOY3t5TcEKto9z6iXtm8QhBtX4r48PehEimsPjp4LDnw2QlJp8WUlZlTNgmlIFn+MDnspaHFbT6f7yE63tNN8SbSoQIToermh2OsnKI9VlBBmFmjWU9M8GnNgYlu1hTuZxkNk7TJfNW1Kvi0UO22BoH31FcqZj67hHb/wettl9BWL8bPV1MTMZmVsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a9607d8a-ec4e-4152-5def-08df0a7a9569
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|36860700016|35042699022|23010399003|376014|10067099003|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aEekkUofhRZSbJD49pleUpEk8SHAF3EXGmfS1rxmoc3MYeftN/AIHWjJZfbwi6w85bgkM7SUoC+GKXXUbvHpc0X8eNXaFOVJToaetJQyRqxNguvmWNPV00wa696W/7YV3M9uLCLciMs6piUPrNeM2BRU2antuZBy3rYQqEWVNFcJt23M+86XEhIdGDykYLyOdNAc5IM64DG6LNVVDsjEcqNQUeXPwztZhFduOc3FqrvIkPP/h1jNDwUNmr44LNmnH4RwjzCSE4E8ZIdi1eMuniyf6s+gifiTUq/q6K8Sjb4ttfenvPjNAIU4qNKoLvrxMB95RvjObCJ1cByszgWzX0sEs38c6dO0ZX1VRTLUVi7vD1U7AN3RcBHBT0hyPzXuF830YbFV/h4Wa7m7tHnRWbBgy7Wbcn0NdK0/1pcQG6EZ5Zp0nEjIXzK5Ej5S8Ls+NaG90RRt9CWVlLJjd2nHb2g5Ujq28OhcsGsGSuuPyfwN6GM4UtKhcZW73LiN7Z76kGux8x9KzWwzF7D53RyGl1SgpNzcPNqX7S7waJJbJqC60Bv0vUfckHZOChHVONfLcq1Kdzn/gwg0ff2ZCqej+3ER9wC8OZJ3wecFsN5LIaF2doX2/A9ey1/iDTiVaRmCOt60k6iP/EuUckkLKvwo2kh2noFD7bNnQVHv9UjOudA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(36860700016)(35042699022)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9HcytOs+84MYNFuYMi2jXzagp7cWHHoZFIC8qaNbWUHXG9okH06CQ4cgLnEw5JpzH1cjBtyJzPo/mVZViTt2KVOMFligaIOHN8VkoMh1DsYhsHu0E9qhSmtFJUHcgyDKl0edtECDTryiGvuNaLtznM8DdoXg9bTvNTEOfrIq2x0+WBBk9qbNg88tOqlAOZy4HLXBpKSxBQ206jq//zVM3hVWMDPrdx5y/aAtkVakFgUFf6iNTeLwd0jaBhwSpZbiGweRaW4WrasFCOw3Xer0I1tmIGiMb08uY6oas3uRJF5bWUIW3u0YoT9NcqM+pKNp0mfKxNpE4Bnm4R5HKUVFD9flylcB6EoqhwQj/0mb6YXa2yhgjWfbpZelbB14g03vEvokc3A7wQswFALe/AihxHKXZHgbRuVA34dlWYVxoUzyfUN0r/p8UX2x0uIRlhRj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:50:04.2530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 049f1b0f-d47e-46ec-42cc-08df0a7aa8c5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10175

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIs are considered
by KVM. Secondly, only a set of those is exposed to a guest: those
corresponding to devices that KVM emulates, such as the timers and
PMU, and the GICv5 SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run, as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied both to hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

While preparing userspace access to the GICv5 system registers, it
became apparent that restoring the GICv5 PPI registers can result in a
mismatch between the state supplied by userspace and the state KVM
intends to expose. Userspace can provide Enable, Active, and Pending
state for PPIs that KVM has chosen to hide from the guest.

Userspace must restore PPI state before any vCPU runs. The userspace
access path added subsequently enforces this ordering. Rework
vgic_v5_finalize_ppi_state() to calculate the mask of exposed PPIs and
clear any state belonging to non-exposed PPIs. This ensures that only
the state KVM intends to expose is visible to the guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0bce2b4cb7cc9..b0de4ea7dc39e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -979,7 +979,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d8f106384c6e9..b940f7beeaa56 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -777,9 +777,10 @@ int vgic_v5_map_resources(struct kvm *kvm)
 	return 0;
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -788,35 +789,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 684e8324a6178..fd8d938f46500 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -823,7 +823,7 @@ static inline u32 vgic_v5_irs_max_vpes(const struct vgi=
c_v5_irs_caps *caps)
 	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, caps->idr4) + 1);
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
