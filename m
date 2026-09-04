Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013002.outbound.protection.outlook.com [40.107.159.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABC337AA87
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521980; cv=fail; b=Eymgoq5+XUQY9y0RXMRFKttxHH/BR2M6QzW+vL7CwWAy1buP5J0wMcwBMqb9on69jrITKxEXs8K48JCC825AuZaPAyH23+UaZjREH3xFsBv8imeDx4QUbin5bPbY4+4tiiCi5ybb2TF/JXHxN0FvlCBUxEHf5edPNgjdLwLuFRw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521980; c=relaxed/simple;
	bh=rVQkod3B1ZpMTFdALtBDMzagBK1ea7CxCjDJ3WhPWrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PYegqrVfKU9aIBCGJ2UcqfdAgKbzDNWB/tGrfsNFm5LAp2WQGWf483mK5XKqhdPUiTKewTPdH0HHitIoF9APKd6y93VNFNCJuO60P4DNOm4wyiWJhs+OCVtXvDKA29p4eOtcqaEorxJKCFmrZXuxBv9O5D5eFwZRkXSqH2QK2b8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hCGZkY6s; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hCGZkY6s; arc=fail smtp.client-ip=40.107.159.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hCGZkY6s";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hCGZkY6s"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UMrtsW5e11nk5fOekZQY7Tz8/DJjjsEvQbNkH92cYvj4/ux6MmGWLhv/2mGUTpH4A1vfEfppBNqAaUSxuFkuXSqoteuhm3QxtksgY+F8lfuaf1GtnBw4iozwWbFNKuThW6/CSsXT6RueNClM8JIfgllK8rMpx9cIB/Riv5mIeBaW1iLKZeUyMnowHq4mwmpLOjnF89wlIAPHIlj2u4scwEOzGeLeQoezqSsM/dDI8Sd3xCag6CEPsYWUtpESN9TTatMZ2SfNgPfdeEys82PWobpRQkG+lzeeqLoroR/AlcmPamp2T7Cag58OoAhqBbjjKC5EFQdGN5Ph4lr3h6/R5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grtJgIL0b/ged7qB4sfRyfShmVjHUhuF7BfEiL4Xrdw=;
 b=LRlEcI15Ht6JcohfDkwxtEzKjauu7a+y2DPX3G6GlRl0FKJ8AWiiNPRwO2T2R08BToIsGyK0Y3bZQVUfAqv2EzC0ZwLI91rulrkixmpRTvBiJwtbtzgYBwkHE6BWPWVzacXdD0FZbaocGMS8ed0r1L13NPrZmkW0C6mXB/dQomX3cUeLNYPijX6TQRro1SVnyt7wT5uJ2gUEKKnoOJpS3Zjp6+sy2ybsOi4IjsFE4Bdn2EFfzoG6CxfCY+jKY3Sr/adVeZgjuXYr7fClhc7/YMnfygmmF6/JvMMJDyaWHuKYOIPkD9TbIA/Qz87ZOxHcrWkL34bHU7KwcGS+VdLbSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grtJgIL0b/ged7qB4sfRyfShmVjHUhuF7BfEiL4Xrdw=;
 b=hCGZkY6sK+qFf9JeVEcoLOqxU2oQAXsP2SIStCgn18uKYF2YKa22+BNz/ZeOF/4w5c1nMp8np1qXJj3aCfyG6wXF5QnF3x3BLKbIU2JVqLjn0FLoNe+DljSI3Q5bmJor4K6FtRBNcBKy8WR/rAviAs76TclJGc7QlCB7Ygkb8ok=
Received: from DU2PR04CA0267.eurprd04.prod.outlook.com (2603:10a6:10:28e::32)
 by DB9PR08MB7867.eurprd08.prod.outlook.com (2603:10a6:10:39e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:39:27 +0000
Received: from DB1PEPF00039230.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::49) by DU2PR04CA0267.outlook.office365.com
 (2603:10a6:10:28e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:39:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039230.mail.protection.outlook.com (10.167.8.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+ozYnOfdUq0rO64zz7lYyitE7LHly1yTcCQ/NECTLk0r80kSegPAK4n8j6qGWPpiu0TAucaf3obcjtx0zWT4lv9fDdGsu2wY4a98bMepblO1NOtYRy6+oYYd+oGWXt9FitF2Zz9+cUOd6KASUaPKQrtoOCwls2DOxYoRUOsD3/bIQC/Aev+G5gPv3ZvLE4/q88lrG7Lk4qyIx5DD8vWOqmF/RVfvVEln0XhYAEEkPDScwjb2S1ooHyLs0XVq8GACDXRY1fjhcYRAJKmvXzhZjH+5jwgy8rxAphkGPIwl1jShNVMdipbr1DesSfdCA0aPN2bsw2fSAlhWKib8+s6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grtJgIL0b/ged7qB4sfRyfShmVjHUhuF7BfEiL4Xrdw=;
 b=DRl9u7ZhRpaZZUiDA5UZD5ToCNrI/YHy66crUDWSBYu2N1z/KTcAuGIn3c8eBAkLNy3crwOUf1HSlok4uBhDqT5ufkk7rsxWFkLsYDfTEp0kqLhzGpYh7G5lIWWRQr4CxALncC0UTITfuOWBM065xDuA4ns2LjnV0iNTt4g+dH+YLvtjrt4YpvkuKGe2NV4liTO4mzMGsRVx2S3devMM7mcyreJfkeR85cCQzTwwGUfRMQNwtefwyTNceqwwacwWrOe8YwXbp5VG9yipkTs7xk+zojTmB15wgaqa18JH/PdVXKq5bTrcdiSmjI4SJpc53or8qwWYtOkD7uCzRBC+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grtJgIL0b/ged7qB4sfRyfShmVjHUhuF7BfEiL4Xrdw=;
 b=hCGZkY6sK+qFf9JeVEcoLOqxU2oQAXsP2SIStCgn18uKYF2YKa22+BNz/ZeOF/4w5c1nMp8np1qXJj3aCfyG6wXF5QnF3x3BLKbIU2JVqLjn0FLoNe+DljSI3Q5bmJor4K6FtRBNcBKy8WR/rAviAs76TclJGc7QlCB7Ygkb8ok=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:38:51 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:38:51 +0000
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
Subject: [PATCH v6 09/49] KVM: arm64: gic-v5: Create and manage VM and VPE
 tables
Thread-Topic: [PATCH v6 09/49] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Thread-Index: AQHdPGH1HtE1v8Jj9kivAF1/DuZWRw==
Date: Fri, 4 Sep 2026 11:38:51 +0000
Message-ID: <20260904113404.4051341-10-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|DB1PEPF00039230:EE_|DB9PR08MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 543dba0a-528c-49b3-fa2b-08df0a792d2f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|5023799004|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 r0QcvN6RS9/ZYv1+rB+t4glAjl4U7ZOBfh2Xz1PFQsDeOGfgeU/Ud5NnvWyh2OZYFQJVjbR+6yzw4klDX5t182qOBDd0iDgReyx85DqteKUqB9yilGGvyTSDVzxDzeMNaY0olIE+ECi1Yl/++eVgtXGZr4VCEeXsHfUinzVWuxbC5eY6jTLz7EKfZX9CzfqL8RYD0xopZmmx+Af9yMfGC8QuHXpqYbhRP3EJFZGQwhcPrsIx2sYARViOtMwdj1nnsaI+nbE7anDg6nbRH5dX7pANQwj2VGFgmlzWYbrhIf9y/rlXgxhT7pSbJvUVqstdhGOc0vMfejcdImUDQa2VynewwRH0SAlaNi4wHsF5YB5tKfQncr+3ZzdTg6TBlUgd6zmHbA4lMwdHZ+tHj4aLMAYkntCmcezld3WHkpeQrYDu/gSxzXRLmJUG3FZVmNWXhR0ZEz/VQhBHdiDL/YtHi7tj31RX/a3z/ZjN8Om+WApipOJ2uis24DnHhTV3hmo0TPBzlbfrla51tnw8ROzwb7fMOIebE1XLIsrwRc1Ir5sBANo4K1EoJQNrvWH0XkXAKiJiurJgMA/huhtwu8wPJzwyic4k/H9Ij9dzGhlAs1CgBtt5/ibsMDNDXtNWdUaMQMm5f3pr08vucTZ7z45Zmi3QqFgOjjSSbRIIpAv9kOBDAWkdI7CLXHhvbTfMaBNX5rhBqMfHs5+oxWnzTuGblzcu2nzNCpWbxKOETFOLdfQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(5023799004)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 byHm2yMJhjXg/ZfHuxGy83Ru+6XgPicxM3s1785ZHxnWJgqJ5uBFJe0364JT0wVoRzm/AbJwyzjoXmgRzPZB7mXRO1NAA4aUv9I84bUL50lr8rIPYCkdGdOnlGjMzn7XjfDge2ST1HiEQ+pfmgIvBV/gu7GAfKCA4TJZvhZzdL/YAzuQbChWCOMPGGJZx/GJYL3QT3lEjDBZrhhJTzZjc97KroLE3sartSTAMj2R5lF0CiJkgusxfvuH1Fwwgo5Y0JvSGG3WdcTcKnQj6snJLvvYZ/bwSm/mX2ffgDFsaViq8fYT3FoKWTikVoLIOKXZnZ3wvzns12UBeVSIfkOUBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3162ad87-39cd-4f56-70fb-08df0a7917bc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|14060799003|35042699022|1800799024|376014|6133799003|11063799006|56012099006|10067099003|5023799004|22082099003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	//cPZU/UioM+ikvGJvLuZh0o3YPXJRY+dcDmtNxSNDeSGZ74fJHVRSumuI48BAHsjvXdsumDhtwS9QAN9Z8TiY9c7ha+wbi7E1Bwe9eCfSMvinx20Skxk+JAV+HSOjwpFFC89gHqKfoRHAOxM6wYfb9WWNDTOjVPjmtcM6sidsBqK6AvSfbpBkArlGup/JB1ep27Pt6z9clh4Ex3Dul89jEUftboU0bF7+bQMIurSq4YTSueBKFYxK4JAc6blX1kWFd2deGxKg3wVkTi6Ep/wvbQW//yKlZpcw5fW7vX1EnXyDNItsTV5XCRB+k1QBfXGGVCV7R45HTO15icoYP/7s+RrU9fW6WeNHOeAf4TEsxcaLJJHFPlAsVOBa4MH51b+tXUMxSASY77jvxDYY/MJ0msHusX3TLxnD+Vz+cGNMr5g54hFYudKryPPRG2V6/AEdKrV6r2n+3gPWWxAwRnSKiy2BHTB54wxmmj87lVnYKGc3Z8t51OAEM+pwF0ozkun9Y1JxOzGShLG2MK3iT1XimI4fpB5z4rhTCLBXdLcMs2PEycGQLtsLCXn+ANJcf8dtWc1wEiWcceeIr7PdjnIHnBMaOAJlumAtxpoc9I8oEIz0iQGUULBSmS4LQ4ZpDeub1dQ5TOwxjCREuF9lCfNWZmbXqvB/Z935q1ABEOiKw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(14060799003)(35042699022)(1800799024)(376014)(6133799003)(11063799006)(56012099006)(10067099003)(5023799004)(22082099003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H6n69JW96vco9hM3m/fNGyL5DmbptCS8kwfwX0Bt2lVX4a9QKxz4SFOFrRSt2ouGSnCRttuy4d9Tt9fLIlPebDFjanEnrpKQ9elu2ccv5P3RxuVhRnGNPbXaLsPsYzt0aUnXjdw27VpdguwqiHfW11oierrbAx7vp5Ad33BOGx9jkW7wdFlAtqDp8lpFNVewn7/TE/dpnJ6/3D3zekXs9g9GZU/endGlaGwSB6GOCJ5cB5FWLgEXkoftLrw66Z4/WLTzTsLfEwMMILiqhtKkac+CkBI+S+4cMqr5TOgFe1ZzHvBNBXjEkd/xm6Y9c5U8UEQozUSAe4tmIo2TAzfI+0TxwNLgD+gLK81q+RMnK0FAJ4StXRW59+iFTkjE4cvbbXswejEwnGLuAo3gBJP5MNQnzBBoEN40CaAwO3ce56cV1WLxSw2aYk5921K64OcS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:39:27.4232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 543dba0a-528c-49b3-fa2b-08df0a792d2f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7867

GICv5 uses a set of in-memory tables to track and manage VM state.
These must be allocated by the hypervisor and provided to the IRS.

The VMT (Virtual Machine Table) is a linear or two-level table
comprising VMT Entries (VMTEs). Each VMTE describes the state for a
single VM. This state includes things such as the SPI and LPI IST
configuration (coming in a future commit), an implementation-defined
VM Descriptor, and a VPE Table (VPET).

The VPET contains one entry per possible VPE ID belonging to a VM. It
is used to mark a VPE as valid and provide the address of an
implementation-defined VPE Descriptor (VPED), which the hardware uses
to track and manage VPE state.

Allocate each VM's VPEDs as a single dense array indexed by vcpu_idx,
while the VPET remains indexed by the userspace-provided vcpu_id. This
keeps VPED storage proportional to the number of vCPUs even when their
IDs are sparse.

The VMT and VPET are shared with the IRS. On systems with a
non-coherent IRS, cache maintenance operates at cache-line
granularity, while multiple entries can occupy the same cache line.
Use a common lock for CPU accesses to these tables and IRS command
processing so that writing back one entry cannot overwrite an IRS
update to a neighbouring entry.

The implementation-defined VMD and VPED storage is also visible to the
IRS. Round these allocations up to whole cache lines to prevent cache
maintenance from corrupting unrelated slab objects. Initialise the
storage before publishing its addresses to the IRS.

This commit adds support for allocating the VMT and its descriptor
backing state, and for managing VMTEs. The VMTEs can be initialised or
released for reuse. VM IDs are allocated with an IDA, while an XArray
tracks the host-side allocations associated with populated VMTEs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c      |   2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 681 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h | 100 ++++
 arch/arm64/kvm/vgic/vgic-v5.c        |  19 +
 drivers/irqchip/irq-gic-v5-irs.c     |  12 +-
 include/kvm/arm_vgic.h               |   4 +
 include/linux/irqchip/arm-gic-v5.h   |  14 +-
 8 files changed, 824 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..431de9b145ca1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 052e680b8b60f..d5e05d9794076 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -154,6 +154,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
 	}
=20
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
new file mode 100644
index 0000000000000..7252d48431a5a
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -0,0 +1,681 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#include <kvm/arm_vgic.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_v5_vmt *vmt_info;
+
+/* Serialises IRS MMIO interaction (commands) and accesses to IRS tables. =
*/
+DEFINE_RAW_SPINLOCK(vgic_v5_irs_lock);
+
+/* Serialises lazy installation of shared second-level VMTs. */
+static DEFINE_MUTEX(vmt_l2_lock);
+
+static DEFINE_XARRAY(vm_info);
+
+/* Level 1 Virtual Machine Table Entry */
+#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
+/* Note that there is no shift for the address by design */
+#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
+
+#define GICV5_VMTEL2E_SIZE		32ULL
+/* An L2 table (two-level VMT) is ALWAYS 4kB! */
+#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
+#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2=
E_SIZE)
+
+/*
+ * As the L2 VMTE is a large data structure, we are splitting it into 4 pa=
rts.
+ * We only mask and shift WITHIN each part for simplicity.
+ */
+/* First 64-bit chunk */
+#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
+/* Second 64-bit chunk */
+#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
+#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
+/* Third & fourth 64-bit chunks (the encodings are the same for each) */
+#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
+#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
+#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
+#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
+#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
+
+/* Virtual PE Table Entry */
+#define GICV5_VPE_VALID			BIT_ULL(0)
+/* Note that there is no shift for the address by design. */
+#define GICV5_VPED_ADDR_SHIFT		3ULL
+#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
+
+/*
+ * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
+ * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
+ * manage our cached data explicitly.
+ *
+ * This helper is used to handle both coherent and non-coherent IRSes, and
+ * handles all combinations of cleaning and invalidating to the PoC.
+ */
+static void vgic_v5_clean_inval(void *va, size_t size)
+{
+	unsigned long base =3D (unsigned long)va;
+
+	dsb(ishst);
+
+	if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
+		dcache_clean_inval_poc(base, base + size);
+}
+
+/*
+ * Create a linear VM Table. Directly using the number of entries supplied=
 as
+ * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
+ * the GICv5 requirements for the IRS_VMT_BASER.
+ */
+static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
+{
+	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
+						 num_entries);
+	if (!vmt_info->linear.vmt_base)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->linear.vmt_base,
+			    num_entries * sizeof(struct vmtl2_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level VM table. The second-level VM t=
ables
+ * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
+ */
+static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
+{
+	/*
+	 * Each L2 VMT array is always 4k-sized (covering 128 VMs). This is
+	 * mandated by the GICv5 specification (GICv5 EAC0 Specification rule
+	 * D_LSPBK). Hence, round up the number of entries to be at least 128
+	 * (or the next highest power of two as we give the HW the number of VM
+	 * ID bits).
+	 */
+	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
+		num_entries =3D GICV5_VMT_L2_TABLE_ENTRIES;
+	num_entries =3D roundup_pow_of_two(num_entries);
+
+	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
+	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
+					     vmt_info->l2.num_l1_ents);
+	if (!vmt_info->l2.vmt_base)
+		return -ENOMEM;
+
+	vmt_info->l2.l2ptrs =3D kzalloc_objs(*vmt_info->l2.l2ptrs,
+					   vmt_info->l2.num_l1_ents,
+					   GFP_KERNEL);
+	if (!vmt_info->l2.l2ptrs) {
+		kfree(vmt_info->l2.vmt_base);
+		return -ENOMEM;
+	}
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base,
+			    vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate a second level VMT, if required. This can be called eagerly, a=
nd
+ * will only perform the allocation if required.
+ */
+static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd =3D VMT_L2_MAP;
+	struct vmtl2_entry *l2_table;
+	unsigned int l1_index;
+	int ret;
+
+	/* Nothing to do if we have linear tables! */
+	if (!vmt_info->two_level)
+		return 0;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return -EINVAL;
+
+	/*
+	 * We have 4k-sized L2 tables - this is mandated by the spec for
+	 * two-level VMTs (GICv5 EAC0 Specification rule D_LSPBK). This means
+	 * that we have 128 entries per L1 VMTE.
+	 */
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+
+	guard(mutex)(&vmt_l2_lock);
+
+	/* Already valid? Great! */
+	if (vmt_info->l2.l2ptrs[l1_index])
+		return 0;
+
+	l2_table =3D kzalloc_objs(*l2_table, GICV5_VMT_L2_TABLE_ENTRIES);
+	if (!l2_table)
+		return -ENOMEM;
+
+	/* The VMT is shared between all VMs. */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE);
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index],
+			   cpu_to_le64(virt_to_phys(l2_table)));
+
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+	}
+
+	/*
+	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
+	 * conduit for interacting with the host's IRS. In the current case,
+	 * this lets us resolve the VM ID to pass to the hardware.
+	 */
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	/* We've failed to make the L2 VMT valid - things are very broken! */
+	if (ret) {
+		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+			/* Remove the pointer from L1 table */
+			WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
+
+			vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+					    sizeof(vmtl1_entry));
+		}
+
+		kfree(l2_table);
+		return ret;
+	}
+
+	vmt_info->l2.l2ptrs[l1_index] =3D l2_table;
+
+	return 0;
+}
+
+/*
+ * Allocate the top-level VMT. This can either be linear or two-level.
+ */
+int vgic_v5_vmt_allocate(unsigned int max_vpes)
+{
+	int ret;
+
+	/* Allocate the tracking structure */
+	vmt_info =3D kzalloc_obj(*vmt_info, GFP_KERNEL);
+	if (!vmt_info)
+		return -ENOMEM;
+
+	ida_init(&vmt_info->vm_id_ida);
+	vmt_info->max_vpes =3D max_vpes;
+	vmt_info->vmd_size =3D vgic_v5_irs_vmd_size(&irs_caps);
+	vmt_info->vped_size =3D vgic_v5_irs_vped_size(&irs_caps);
+	vmt_info->two_level =3D vgic_v5_irs_two_level_vmt_support(&irs_caps);
+	vmt_info->num_entries =3D vgic_v5_irs_max_vms(&irs_caps);
+
+	if (vmt_info->two_level)
+		ret =3D vgic_v5_alloc_vmt_two_level(vmt_info->num_entries);
+	else
+		ret =3D vgic_v5_alloc_vmt_linear(vmt_info->num_entries);
+
+	/* If anything failed, free our tracking structure before returning */
+	if (ret) {
+		kfree(vmt_info);
+		vmt_info =3D NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * Free the VMT and associated tracking structures. This isn't strictly ex=
pected
+ * to be called in general operation, but instead exists for completeness.
+ */
+int vgic_v5_vmt_free(void)
+{
+	if (!vmt_info)
+		return 0;
+
+	if (!vmt_info->two_level) {
+		kfree(vmt_info->linear.vmt_base);
+	} else {
+		/* Free the L2 tables; kfree(NULL) is safe */
+		for (int i =3D 0; i < vmt_info->l2.num_l1_ents; ++i)
+			kfree(vmt_info->l2.l2ptrs[i]);
+		kfree(vmt_info->l2.l2ptrs);
+
+		/* And now free the L1 table */
+		kfree(vmt_info->l2.vmt_base);
+	}
+
+	ida_destroy(&vmt_info->vm_id_ida);
+	kfree(vmt_info);
+	vmt_info =3D NULL;
+
+	return 0;
+}
+
+/*
+ * Look up a VMT Entry by VM ID.
+ */
+static struct vmtl2_entry *vgic_v5_get_l2_vmte(u32 vm_id)
+{
+	unsigned int l1_index, l2_index;
+	struct vmtl2_entry *l2_table;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return ERR_PTR(-EINVAL);
+
+	if (!vmt_info->two_level)
+		return &vmt_info->linear.vmt_base[vm_id];
+
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+	l2_index =3D vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
+
+	if (l1_index >=3D vmt_info->l2.num_l1_ents)
+		return ERR_PTR(-E2BIG);
+
+	if (!vmt_info->l2.l2ptrs[l1_index])
+		return ERR_PTR(-EINVAL);
+
+	l2_table =3D vmt_info->l2.l2ptrs[l1_index];
+	return &l2_table[l2_index];
+}
+
+/*
+ * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
+ */
+static int vgic_v5_reset_vmte(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		/*
+		 * The VMT is normal memory shared with the IRS. Invalidate before
+		 * rewriting the entry so that cacheline-granular maintenance cannot
+		 * later push stale data for neighbouring IRS-visible state back to
+		 * memory.
+		 */
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+		/*
+		 * Prevent the compiler from eliding the individual VMTE
+		 * stores. Ordering and visibility to the IRS are provided by the
+		 * surrounding cache maintenance and command protocol, not by
+		 * WRITE_ONCE().
+		 *
+		 * The same compiler-access constraint applies to READ_ONCE() users in
+		 * this file: when inspecting IRS-visible table entries, read the field
+		 * exactly once and prevent the compiler from reusing, merging or
+		 * tearing the access. Coherency and freshness for non-coherent IRSes
+		 * still come from the surrounding cache maintenance.
+		 */
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[1], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[2], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[3], cpu_to_le64(0ULL));
+
+		/* And make our write visible to the IRS (if non-coherent) */
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	return 0;
+}
+
+/*
+ * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
+ * structure. If we're out of VM IDs, the IDA catches that, and we return =
the
+ * error (-ENOSPC). If we've previously allocated a VM ID, we catch that t=
oo and
+ * return -EBUSY.
+ */
+int vgic_v5_allocate_vm_id(struct kvm *kvm)
+{
+	int id;
+
+	if (kvm->arch.vgic.gicv5_vm.vm_id !=3D VGIC_V5_VM_ID_INVAL)
+		return -EBUSY;
+
+	id =3D ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
+			   GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	kvm->arch.vgic.gicv5_vm.vm_id =3D id;
+
+	return 0;
+}
+
+/*
+ * Release the VM ID to allow it to be reallocated in the future.
+ */
+void vgic_v5_release_vm_id(struct kvm *kvm)
+{
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
+	kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
+}
+
+/*
+ * Initialise an entry in the VMT based on the index of the VM.
+ *
+ * Note: We don't mark the VMTE as valid as this needs to be done by
+ * the hardware.
+ */
+int vgic_v5_vmte_init(struct kvm *kvm)
+{
+	size_t vmd_alloc_size, vpet_alloc_size, vped_alloc_size;
+	void *vped_base =3D NULL, *vmd =3D NULL;
+	struct vgic_v5_vm_info *vmi =3D NULL;
+	u64 tmp, vmte_val0 =3D 0, vmte_val1;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	int ret, nr_cpus, nr_vcpus;
+	bool vmi_inserted =3D false;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet =3D NULL;
+	struct kvm_vcpu *vcpu;
+	u16 max_vpe_id =3D 0;
+	unsigned long i;
+
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus > vmt_info->max_vpes)
+		return -E2BIG;
+
+	/*
+	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
+	 * VMTs, this is a NOP.
+	 */
+	ret =3D vgic_v5_alloc_l2_vmt(kvm);
+	if (ret)
+		return ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* If the entry is already valid, something went wrong */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EINVAL;
+	}
+
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	vmi =3D kzalloc_obj(*vmi);
+	if (!vmi) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
+	if (ret)
+		goto out_fail;
+	vmi_inserted =3D true;
+
+	/* Allocate and assign the VM Descriptor, if required. */
+	if (vmt_info->vmd_size !=3D 0) {
+		vmd_alloc_size =3D round_up(vmt_info->vmd_size,
+					  dma_get_cache_alignment());
+		vmd =3D kzalloc(vmd_alloc_size, GFP_KERNEL);
+		if (!vmd) {
+			ret =3D -ENOMEM;
+			goto out_fail;
+		}
+
+		/* Stash the VA so we can free it later */
+		vmi->vmd_base =3D vmd;
+
+		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
+				 virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
+		vmte_val0 =3D tmp;
+	}
+
+	/*
+	 * Allocate and assign the VPE Table.
+	 *
+	 * First of all, iterate over all vcpus to find the highest VPE ID we
+	 * require - we need to ensure that we have enough storage for all
+	 * vcpu_id values that userspace has picked and not just the total
+	 * number of vcpus. This gives us the number of VPEs required for the
+	 * VM.
+	 *
+	 * Round up the number of VPEs to a whole power of two as we cannot
+	 * describe non-powers-of-two in the VMTE field as it conveys the number
+	 * of ID bits used and not the number of vPEs. IRS_IDR1.IAFFID_BITS is
+	 * encoded as N - 1, so expose at least one VPE ID bit even for a
+	 * single-vCPU VM to keep the views consistent.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+
+		if (vpe_id > max_vpe_id)
+			max_vpe_id =3D vpe_id;
+	}
+
+	nr_cpus =3D max(2UL, roundup_pow_of_two(max_vpe_id + 1));
+	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
+
+	vpet_alloc_size =3D round_up((size_t)nr_cpus * sizeof(*vpet),
+				   dma_get_cache_alignment());
+	vpet =3D kzalloc(vpet_alloc_size, GFP_KERNEL);
+	if (!vpet) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	/* Stash the VA so we can free it later */
+	vmi->vpet_base =3D vpet;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
+			 virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
+	vmte_val1 =3D tmp;
+
+	/*
+	 * Allocate a dense VPED array indexed by vcpu_idx. The VPET is indexed
+	 * by the potentially sparse vcpu_id, but using that ID here would waste
+	 * memory. Given that this is not userspace visible, we can cheat a bit
+	 * and use the dense index instead. This is the ONLY place that we do
+	 * this.
+	 *
+	 * Round the requested size up to a whole cacheline. kzalloc() gurantees
+	 * natural alignment, so we ensure that the cachelines cannot be shared
+	 * with unrelated slab objects. VPED and cacheline sizes are powers of
+	 * two, so this also preserves the required VPED alignment when a VPED
+	 * is larger than a cacheline.
+	 */
+	vped_alloc_size =3D round_up((size_t)nr_vcpus * vmt_info->vped_size,
+				   dma_get_cache_alignment());
+	vped_base =3D kzalloc(vped_alloc_size, GFP_KERNEL);
+	if (!vped_base) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+	vmi->vped_base =3D vped_base;
+
+	if (vmd)
+		vgic_v5_clean_inval(vmd, vmd_alloc_size);
+	vgic_v5_clean_inval(vpet, vpet_alloc_size);
+	vgic_v5_clean_inval(vped_base, vped_alloc_size);
+
+	/* Publish the VMTE while serialising access to the shared VMT. */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(vmte_val0));
+		WRITE_ONCE(vmte->val[1], cpu_to_le64(vmte_val1));
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D true;
+
+	return 0;
+
+out_fail:
+	/* kfree(NULL) is safe so we can just kfree() at leisure */
+	kfree(vmd);
+	kfree(vpet);
+	kfree(vped_base);
+	if (vmi_inserted)
+		xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+	vgic_v5_reset_vmte(kvm);
+
+	return ret;
+}
+
+/*
+ * Release the VMT Entry, freeing up any allocated data structures before
+ * zeroing the VMTE.
+ *
+ * The VMTE must be marked as invalid before it is released.
+ */
+int vgic_v5_vmte_release(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Reject if the VMTE has not been marked as invalid! */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EINVAL;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		goto no_vmi;
+
+	kfree(vmi->vped_base);
+	kfree(vmi->vpet_base);
+	kfree(vmi->vmd_base);
+
+	xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+no_vmi:
+	/*
+	 * If we didn't get far enough into allocating a VMTE to create the VM
+	 * info structure, then we just zero the VMTE and move on. There's
+	 * nothing else we can realistically do here.
+	 */
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D false;
+
+	return 0;
+}
+
+/* Provide the preallocated VPE descriptor to the hardware via the VPE Tab=
le. */
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	vpe_entry tmp, *vpet_base;
+	void *vped;
+
+	/* Make sure we're not over what the hardware supports */
+	if (vpe_id >=3D vmt_info->max_vpes)
+		return -E2BIG;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+
+	/* If the VPETE for this CPU is already valid we've gone wrong */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base));
+		if (le64_to_cpu(READ_ONCE(vpet_base[vpe_id])) & GICV5_VPE_VALID)
+			return -EBUSY;
+	}
+
+	vped =3D (u8 *)vmi->vped_base +
+		(size_t)vcpu->vcpu_idx * vmt_info->vped_size;
+
+	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR=
_SHIFT);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+	}
+
+	return 0;
+}
+
+/* Clear the VPE's table entry after the VMTE has been made invalid. */
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet_base;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EBUSY;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vpet_base[vpe_id], 0ULL);
+		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
new file mode 100644
index 0000000000000..962be0c7cd3f6
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#ifndef __KVM_ARM_VGICV5_TABLES_H__
+#define __KVM_ARM_VGICV5_TABLES_H__
+
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/irqchip/arm-gic-v5.h>
+
+/* Level 1 Virtual Machine Table Entry */
+typedef __le64 vmtl1_entry;
+
+/* Level 2 Virtual Machine Table Entry */
+struct vmtl2_entry {
+	__le64 val[4];
+};
+
+/* Virtual PE Table Entry */
+typedef __le64 vpe_entry;
+
+struct vgic_v5_vm_info {
+	void __iomem		*vmd_base;
+	vpe_entry __iomem	*vpet_base;
+	void			*vped_base;
+	u8			vpe_id_bits;
+};
+
+struct vgic_v5_vmt {
+	union {
+		struct {
+			struct vmtl2_entry *vmt_base;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			vmtl1_entry *vmt_base;
+			struct vmtl2_entry **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+	bool		two_level;
+	unsigned int	num_entries;
+	unsigned int	max_vpes;
+	size_t		vmd_size;
+	size_t		vped_size;
+	struct ida	vm_id_ida;
+};
+
+static inline u32 vgic_v5_vm_id(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv5_vm.vm_id;
+}
+
+/*
+ * For vGICv5, we need to consolidate two views:
+ *   - The vcpu ID assigned by userspace, which it can assign however it
+ *     sees fit.
+ *   - The index into the VPET, which is also presented to the guest as
+ *     the IAFFID for the VPE in question.
+ *
+ * Ideally, we don't want to intercept the guest setting an interrupt's af=
finity
+ * - this would somewhat defeat the point of allowing the hardware to mana=
ge the
+ * interrupt directly. Therefore, we need to use vcpu->vcpu_id as our VPE =
ID,
+ * which ensures that both userspace and the GICv5 hardware have a consist=
ent
+ * view.
+ *
+ * This means two things:
+ *   - Our VPET might be sparse, depending on the IDs picked by userspace.
+ *   - We need to check the vcpu ID provided by userspace, and reject anyt=
hing
+ *     we cannot handle.
+ *
+ * In order to at least ensure consistent usage in the places that we need=
 to
+ * use the VPE ID, we provide this helper.
+ */
+static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id;
+}
+
+static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
+}
+
+extern raw_spinlock_t vgic_v5_irs_lock;
+
+int vgic_v5_vmt_allocate(unsigned int max_vpes);
+int vgic_v5_vmt_free(void);
+
+int vgic_v5_allocate_vm_id(struct kvm *kvm);
+void vgic_v5_release_vm_id(struct kvm *kvm);
+
+int vgic_v5_vmte_init(struct kvm *kvm);
+int vgic_v5_vmte_release(struct kvm *kvm);
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 60bb39421ad08..efe11a5a28f9d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -5,10 +5,12 @@
=20
 #include <kvm/arm_vgic.h>
=20
+#include <linux/kvm_host.h>
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
=20
+#include "vgic-v5-tables.h"
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
@@ -126,6 +128,22 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
+{
+	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	switch (*cmd) {
+	case VMT_L2_MAP:
+	case VMTE_MAKE_VALID:
+	case VMTE_MAKE_INVALID:
+		/* Not yet implemented */
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
@@ -137,6 +155,7 @@ static const struct irq_chip vgic_v5_db_irq_chip =3D {
 	.irq_set_affinity =3D irq_chip_set_affinity_parent,
 	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
 	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.irq_set_vcpu_affinity =3D vgic_v5_db_set_vcpu_affinity,
 	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
 		 IRQCHIP_MASK_ON_SUSPEND,
 };
diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index 1014cbd80e873..a779b6ffa4359 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -269,24 +269,24 @@ int gicv5_irs_iste_alloc(const u32 lpi)
  * itself is not supported) again serves to make it easier to find physica=
lly
  * contiguous blocks of memory.
  */
-static unsigned int gicv5_irs_l2_sz(u32 idr2)
+unsigned int gicv5_irs_l2_sz(u32 l2sz)
 {
 	switch (PAGE_SIZE) {
 	case SZ_64K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_64K;
 		fallthrough;
 	case SZ_4K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_4K;
 		fallthrough;
 	case SZ_16K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_16K;
 		break;
 	}
=20
-	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 		return GICV5_IRS_IST_CFGR_L2SZ_4K;
=20
 	return GICV5_IRS_IST_CFGR_L2SZ_64K;
@@ -334,7 +334,7 @@ static int __init gicv5_irs_init_ist(struct gicv5_irs_c=
hip_data *irs_data)
 	lpi_id_bits =3D min(lpi_id_bits, gicv5_global_data.cpuif_id_bits);
=20
 	if (two_levels)
-		l2sz =3D gicv5_irs_l2_sz(idr2);
+		l2sz =3D gicv5_irs_l2_sz(FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr2));
=20
 	istmd =3D !!FIELD_GET(GICV5_IRS_IDR2_ISTMD, idr2);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 78a442046ebc5..3ec3f7e1b88b4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -361,6 +361,8 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+#define VGIC_V5_VM_ID_INVAL		(-1)
+
 struct vgic_v5_vm {
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
@@ -383,6 +385,8 @@ struct vgic_v5_vm {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
 	int			vpe_db_base;
+	u32			vm_id;
+	bool			vmte_allocated;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 6ed886c09becb..fae3af230953a 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -160,9 +160,9 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(0), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(1), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(2), (r))
=20
 #define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
 #define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
@@ -611,6 +611,7 @@ int gicv5_irs_cpu_to_iaffid(int cpu_id, u16 *iaffid);
 struct gicv5_irs_chip_data *gicv5_irs_lookup_by_spi_id(u32 spi_id);
 int gicv5_spi_irq_set_type(struct irq_data *d, unsigned int type);
 int gicv5_irs_iste_alloc(u32 lpi);
+unsigned int gicv5_irs_l2_sz(u32 l2sz);
 void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
@@ -655,4 +656,11 @@ void gicv5_deinit_lpis(void);
=20
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
+
+enum gicv5_vcpu_cmd {
+	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
+	VMTE_MAKE_VALID,	/* Make the VMTE valid */
+	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+};
+
 #endif
--=20
2.34.1
