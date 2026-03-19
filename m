Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013031.outbound.protection.outlook.com [52.101.72.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3DA3E8C68
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935500; cv=fail; b=he/bL+vdcNblmpEggCNgXxTjNGQrvkxyQiOICJGTRJuuoXI0Q1DpPR+cZIRwXFpEEYCLPO/cuKb/R7dbEVWqRkxENNOT5MqTUA2OWjDQFRgmhdwP76akD1JOWGoGGpP1qvtla1hk7UbQk55BEw/a6PU4qD0rh4nBs/n3OBrmn0I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935500; c=relaxed/simple;
	bh=Oz2qo25XPhg6um8X3QEXAt5d5WA00+j6C+/GmyiZKWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ewHVD+W+BzGXzQmHKmKclMUBFzrGXfW/hDdkvjAqbkuLAdAVSkuI2IORONq5R89XERvRTYQTA7P4ZeIwyOeO31/NPayGdOuFJqP/6IjTZp7DwgjSClQSnufmx4rDBKpA/A88kzA4DVwIwCsl96CYqkLvUJi83BvLNMi5rfNE1Eg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AaowC7VN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AaowC7VN; arc=fail smtp.client-ip=52.101.72.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AaowC7VN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AaowC7VN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rpJD/nTH6NG23gVWjuTya7eQ0ShTQ8Fp4vVEMuUNVKacFn9XzkQQ+fnP07JUB35D4moJ9dm5i305p5k8qnpgGC0b+O4nsiEIB/IvPmzqrKbod67mDaUcHtqOI1wFgaCgkmUr20iXs2lDq1wQ+7XVJYMqEZuR4EjY5Rshd1vuK3HwbA50bCFoh4L+wAHTbP7ArMGwnbFiwqaOelgoR9yAoztRAwo9DkBRe8Ujfz8N+oe9iPOKhgiZ4d8deLuzwml3L9opw5Ua5UThpdbVT1inZqA1kItTzDfmmvQbEjy2B8rTpqB5tnkMNsEEskbxxFwFIsQJGbwIGrdUo4YJMs7X7A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeZQrS1JfLZAYy0t+3NIeBhlklTs6oDw27zcZYVvdJ8=;
 b=ipvfLOfGKi3PcyQzwXAckunhV2CvqDpt6nqxwNKpevux/lLxOeqQjP1Zo1QgPmHpt6hZmSEbPH42MZfqrCftCGDtjnmsXizG2NJYwUgOnFOMzKfqi4iehooClC6sS5yOrhffQbFFHECtWxHuEvMwt+5OD/jHEe2bSjfBW2hsXKNt82C7XMR4fuj1tSaYjDZZVQOjSfn13adzTS7rZbNwjxi4yoia/LYZcjkGeXhmj2swxooGQf8YlcfOxN+OgjuqaKqDbpyAtkIkhovYDL4EtG8LYxZSNIvi99JGM/1IXpVRZqxQTyVf/1t1yYbinKJZ0r1PyjX+MG+xfRlknRrAZA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeZQrS1JfLZAYy0t+3NIeBhlklTs6oDw27zcZYVvdJ8=;
 b=AaowC7VNnIfcnOfHM07GpP9GQ1c7ANJVNWYt4AZwJQ5LB9nDYiXHThKKzcg0slatZEmrZV39qZWZotvDq/fsUH0p5wUiEZ7QvGrEirg7jmTUc8uNXhn65Y9Y0eRX9XnKZ43sxWM4uiFTJ9/9wAMp1zFGyViMfrax4IUHtuHScKA=
Received: from DU7P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:552::33)
 by DB9PR08MB6345.eurprd08.prod.outlook.com (2603:10a6:10:252::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:32 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com
 (2603:10a6:10:552:cafe::53) by DU7P189CA0028.outlook.office365.com
 (2603:10a6:10:552::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:51:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxopyjncOvBOKJXYT3OPtRMW3UEAjP65bO2l4KtzGZoZFbGcgkGOOQ4q6HC6SIg3mZpQRVGlM90jxHzI5CfB0h9kDTp8vLklLbiBcbd5YzxL6JbrtlYZASsJ6HhkZWNqdAs0yhmkxiMHMVixfakqVo41546RFIgonGZh72tR2VrDI2Yr56Km8n56GXhthfrE4/gFk+iS+DHoesCO6cdnbpSnRgNtT3zwbNDDQKVJqfAcINKX+hUbWKLv6dtDIU4LEDonb+ROrUiT+Jz8bkucKaMIMdCR0v6mK9pkPguR5GzhDMUKiIm67uQG83ltkf8/ccOqXiI/FvJ7H6JheCkOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeZQrS1JfLZAYy0t+3NIeBhlklTs6oDw27zcZYVvdJ8=;
 b=ELCf+mk2rD3fFY1q852kRpr/w9ktcteQf1CURNx5og/dlQiUre1qSACxemxlNZ0JJFSJRLYZiIQUr7fOkJi8+M/saMOaxz70l1O07e1s+vPeXWhEjMEHdCdhW6ZV4EqVIzAR7CMSoCXX0Kqd60zdzP1QK3Q1SVG6ul9XNc0ksM7ZPMPqknFQOsSPAvMeO/5/QTbQ97txT+voi1i2HnR7jG3pP9T8N+ADENEgLH+8y6ck0OuMBPtlga2DBTYSeLUllHS8bUy2gLxwKq043pV7Ldq7JuhBeq6pHxE8AEZSRvrMGpt0la6dEGrG6BbuxWyN0hlDZ4X73n0kw3y2h+WyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeZQrS1JfLZAYy0t+3NIeBhlklTs6oDw27zcZYVvdJ8=;
 b=AaowC7VNnIfcnOfHM07GpP9GQ1c7ANJVNWYt4AZwJQ5LB9nDYiXHThKKzcg0slatZEmrZV39qZWZotvDq/fsUH0p5wUiEZ7QvGrEirg7jmTUc8uNXhn65Y9Y0eRX9XnKZ43sxWM4uiFTJ9/9wAMp1zFGyViMfrax4IUHtuHScKA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:50:28 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:50:28 +0000
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
Subject: [PATCH v7 03/41] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Topic: [PATCH v7 03/41] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Index: AQHct7gcVJFHHO5//keEW8atk3h9lQ==
Date: Thu, 19 Mar 2026 15:50:28 +0000
Message-ID: <20260319154937.3619520-4-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|DB5PEPF00014B97:EE_|DB9PR08MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: b99b1e89-d770-40d8-b26a-08de85cf645d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 wNcwDXfLPIGaoJIJzqVxr1hA8fcXgXQcf8GtvMJIQZC5scN8RXVc4iO+BIE2m+iH2TAs+PmCe9kzZ9OFF9ipsL9/LYy977SfI6S1aGx1VTPm22igB3bvOfmsbNKDACC4vFmqdWR4lgij9cIDE2gw/DLpOEQsQTwsxXj+dsC0RavQ8HRlyDjiIr/R/od5EObfLibt75Lp1JD38SXQUI2NJHHch09X7z3TE/PPtHIYS6SL9224yFssSpme9tVex5BIAg0w2EMS2pKY3HzayGFPEHBKBkddgfdmjrJE3BGah9dQwVJZxyWXfK+WWa6MUYqe7Po2UItKC97y5HveFVjpLWGsImAF2Xf76wGRE4h8zYrb94fhjDOLmJIBBdC3C2dtsioLOQjdos2oSlPjzdCaWdBU+/KV5Y3c7J98aC2BT2LpD+M24qd5byYe41wasRdTdS9UezHhrCIICs+2c8SHkBFCULNUBrmvO/iF6ZAUeax7rQcmzQzB//0KmtzdjRvfVq1oUHwWApKf6XjrX/OyhM3CziWoaFynUHAwUDoJzBrVyGJl4kr6tUyuOZ2NbuWpXJwHNAeO/9YkRAWAixQGOlaumx6LFRkgtb9mPfaocc8E7wrln6H5biC5Z+Um5loEk5ygKQF4mZozRHZiB5YZ2yGVE6hY+iQxBsA80Ygj6rYxLjGnPmuDgo9Mad2ZX+94Oq9L+EvBpcgalvy5fVnDk2SDqMf0qgf1+3T2Ge6LAKfR7+oqFxGV6W2sjc+kpA6VLyJcfkLue9qug97FlPlA2k7Bd+Blv9L6O9qCvjYTn+Y=
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
 s9q691XPv4O8DixZuNx8Hiw0q/zKhiJDIniNSyi79Amo+i1LwhaNPVAhTXHQlU9nAPOvLqBpxwo1zJepuaoc4mkXIATbMfp2m+M/5odgee9RmMb1MrQS0a4SBDbQ1VYJnnbsjvQ/WwFiWBEHVwb6Lg1mQRnMp0w46tP9qTpz0fJUoaKRVVpt9S4HSy7n4/qWt6DYAtbnBHrR+jpkRv3sR1fMMm5A0AwwAcbePu3S8AgNJeXcwVCg/MNscE5efjoKiyurbqzlqqdkzPGsLu9NRCZR6s9av+XlV6TN62JzQ9mF6io4x+aJzwbzWLAlWk2aa681H0U8dnw3n9oOkGU1Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f62c81f4-d64c-4771-619b-08de85cf3e81
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|376014|82310400026|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eubCVpoiU4N5NQNh36BpRQBqxHE166BQEgPHZ77fqEohaNVEPeRFQaSttR3MP9ahdS5chzY4Qte/+9QJZBiKl8aV0mcTPGDm/LJlmzKf1Vgqtq+qSm+hy1+x/CfRu7V9ZDslVi/2bLAv7a9PvH3MryhairAOA9hqz8nVJ62aCcf+CcM0NMZouQ+qSMxvVqNl139mBJ5pNvo+vqBsR8ps/i/+SlJF4wkTl1WjZe1d7EAlYCh2gCjrboSTArip8y+jaSQfu0ES5hrmzi1jypI8GbDh22WptWwWLvK1Rp3ITcjmu27iFGUt1s0JsygA02sMB9dlJ2kyzIc0/2oLQgg8JSwL3q+IPIKW3ao33FjkyQCdlFA0YtOPICkQGDL/YAinpB6lAVFsVU6v0sLp5yanFXt3KsgnMG/ZXdge+LpSsXRX2L4EehHWcU4JDJJsUokpx3w6abt+sE7SUz0Or+q8YqrgpqYAQVdeM8QIbtQspKlyhwnG6yC1K52slQak9VnRAM212Pcd1KYFO26B39qgEUKDZdmkr6BQaSsJyFaCrE74MtuVQEW+3FPv8ok96Ekg4+Y2ufn1lgyuwtm44qDxbkdXfbasQcavDbI0uyThUEXhgPWYT0m1c6UgJyq7Iaxri6g6bfJKIdwj9Bey6qLtnppBHY4D6nrqQf30pQze02RG3TozeKVg3tsAq1la4laTB8EurxcC94pUMUsyWhlBQv9Tx2LX9eNURVRHay0y6fLD7ivMeH7c+zAIIslYuANYo46h2YtWdb3nfIK1W5rVuA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(376014)(82310400026)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JyfULcZa+uq5AYCFhs38hn1R0jpNEVfP7YUnGAQYB45PHkOBFjxCiOk8Yi//mr+8Q/XDxMAqK5u4ASjvI7kmXrnOhr6fuOAHcbDFr6Eh1MrMvrWKqkiYkpq8/I84TY4BqBKTE0Fz1XEI1cjED3OuJzRtH7csbSLb+EBU5qDKuHQKdPSe37pyEKhc4kLczYk8tthywmdqKwqQ1iv2NAT3najLEFgbe/Poxxq0lVOm5Pw3oFchi+EAnEARR1vXeUuOAxvZwB3ZkTTm5CJwsyYxaR4Fs6slDOHMubEabTAdGwxffyfAnGXxa2kgDU3f0QEOTqWiYxzAVtanZppJuiTYibgaqiosgHrdiD3x4K6FxyG5S/iI0xxe8qiTcdwNx+WlKOpxwYSrhzE27ysTe+XXB2+VSjq5Glh81QynHKQF4DblhR0cfo6gxReo1lXFxjeu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:51:32.0741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b99b1e89-d770-40d8-b26a-08de85cf645d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6345

If the guest has already run, we have no business finalizing the
system register state - it is too late. Therefore, check early and
bail if the VM has already run.

This change also stops kvm_init_nv_sysregs() from being called once
the RM has run once. Although this looks like a behavioural change,
the function returns early once it has been called the first time.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0acd10e50aaba..42c84b7900ff5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5659,11 +5659,14 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 	guard(mutex)(&kvm->arch.config_lock);
=20
+	if (kvm_vm_has_ran_once(kvm))
+		return 0;
+
 	/*
 	 * This hacks into the ID registers, so only perform it when the
 	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
 	 */
-	if (!irqchip_in_kernel(kvm) && !kvm_vm_has_ran_once(kvm)) {
+	if (!irqchip_in_kernel(kvm)) {
 		u64 val;
=20
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_=
GIC;
--=20
2.34.1
