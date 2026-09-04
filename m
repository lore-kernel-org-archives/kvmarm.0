Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010033.outbound.protection.outlook.com [52.101.84.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C82470EB9
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521882; cv=fail; b=k9uY8DdvEP2s12VLbxb8rMX7Se4TDaHTzCe/Iz1CCSbB5hb2ztg3VCmBk1un02lCILNNJnymCbI5WMmtXNda3V7IfgJfMTFlaG9gZ+L7z8kGsW3b07yJ6xpGDBlusGmMDa4t+W5SiRULdYggXE+gO7nNNURtxUKgBfXn7O2rPQw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521882; c=relaxed/simple;
	bh=Te2HlIH/ekj3un6SFj59Ag8n3tS/6Y+nQbeiN52Qgig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FNeqC71omxYRHkuy4MaUmHYqe+KGwCTnmp1mHbel3wIp56O4KVb+6U5NQoogMJ6RwO8HFsrlk5/n4Sc0rAH5fzhhKPhsQhMXrK8AVDnzdaioDcHPaXbQmd1/dXoWCEsQC6JPi5Box2qNIN4HQaImaxTwCVNbD4hgNZvwRSMLMbQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pFXIlySk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pFXIlySk; arc=fail smtp.client-ip=52.101.84.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pFXIlySk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pFXIlySk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ewWdAkkEIkI2n1ABjFowWRf3FZc0Mx41+aSauWUvm7TSihgVwDCQCjqmjyaxKyLPWCkZhn5+Vt+gwuDCcMBgq7IxhxKoLfmswkGAEty3KdwXQ/fnAZZk+0QsCqGmwRWZsxvjnN5kfK8C7DRvnqv+osmRWwX0OIz+gHoIZu+vZLhfJXyaxGZojyJSRpVjxa+1H7goMLft/qUeuwdHlf9uXGP0EwdFRtiGfklX374Huv8VfyxBdXNr46McML5d0f06tNCDhKBokhfOUv0Yw/SDBTuZu1bPMAm9jXQjjDv3GAgO05kf2aXzsxp+WSJhJGoJuR5p3hjHBTstEO7KGSSUAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hcw4U6A7Z0WqZSjX8PcZJLBd/2Q8YFWoJoYFnpXH1Q4=;
 b=dCnm2ZQm18n+cfpbbBq70lVmlT+OD2OoPtGxlEZ3HhTp8F9GqNdWxJYlCfIaLk/mcuz3QFbj628hL7vtiNjrkp5+KEfVv5uzQ8Qp679HPNnYnSZoo7cIHBqPMjvs60MlMQXb2BwobuFhQRQewBfJbIzJy0zJDz+p8H0WYQCqvc8A/+NJHlm6j7tduClZ0W5JA/vYu0FwnbAcJaQ5DpKIIUNk8N0YU/Z2t9CcoKsCvTsR/h7RUg8Smv8Fad8/KeONICfyIkdtSOG8AM6Hx2wQim9g4E+m5t2XgVND+wJogFzcphYCHBo6GRdEb1DN0Ros0sIsDTVP/A0vxLH5tXxp2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcw4U6A7Z0WqZSjX8PcZJLBd/2Q8YFWoJoYFnpXH1Q4=;
 b=pFXIlySkzY0PUNC4opuEG/K1gU79UVXsV3GXLHJUuO1i5GemtK2yA7OGzoodyFRzv3eljGQwYpZA+K3CZ3XNYJDpBSS9PuYcgRFvkN43gLQn+FKzRrl8G7DONZc6SNsxsXqGArWLYoiP8fDn2rmTN2M2icwS1YKAPoz5GPceukM=
Received: from DUZPR01CA0301.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::18) by GV2PR08MB11818.eurprd08.prod.outlook.com
 (2603:10a6:150:30d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:37:55 +0000
Received: from DB1PEPF00039234.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::67) by DUZPR01CA0301.outlook.office365.com
 (2603:10a6:10:4b7::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:37:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039234.mail.protection.outlook.com (10.167.8.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5ttpwC6eAzyO7uB5h7gd2q+RN+Rl1m4hMto2u9FGvK+yRWYlcJ9xUCoc2jDC6K+jTxTNf4P7LfS8cXKxkFA/Q+bPxsuDL8iNS58XFIcMc2tyMu5+IAp1hGUQ+/S2haiT+YWGSDdS38nr6yW4I/6TvuIkGd5exc52hToGCSdEbKGAkA/SeYMk0GgBVhKpieSuGe1Yc+Lxp5iFfQFBL0nEvPq+8a9thKpVGpb85gahDi2MRqN1xPekvfCdKT/j0bGTxASV4XGUhuL+WgcUz/n2Is3ymLMlAzicMGI5W2hnlddYimGHkUI/dkOU9eTbo4A9Z+Dapw9+D94+sd0wTu4cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hcw4U6A7Z0WqZSjX8PcZJLBd/2Q8YFWoJoYFnpXH1Q4=;
 b=rq15JZ1ijo2Gvt1HQrID8Qz3gPu4lDrX07O0SUMFkxHU9kh8qdMe1DT4Vr6HHo6fyn4SZ6oCVS/BOJQ6Ob7UsGMva8Q4phOoQQUehkMj4dtBxWcV94nYCNIcfeKz75Bsrb7odK3GKCoe9zSYjLaUSPfY8Y8PUBUh8yL2yvm5JbSNkzT8x990wou4YYv2q+Y/PIFt5fVUsU+eZTn0VAz+nvmZMgswZskhvf6TAomCdAK3hZg5MSjyCrIj0hmBjYNUlZ9Pa+7YdkAonqiYKrTYxDloccgp3YtwWDPd8U+rTIBO/U0XMO8fUEM+MP3AyStH8InDs52GUxqnpKg0FAVhuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcw4U6A7Z0WqZSjX8PcZJLBd/2Q8YFWoJoYFnpXH1Q4=;
 b=pFXIlySkzY0PUNC4opuEG/K1gU79UVXsV3GXLHJUuO1i5GemtK2yA7OGzoodyFRzv3eljGQwYpZA+K3CZ3XNYJDpBSS9PuYcgRFvkN43gLQn+FKzRrl8G7DONZc6SNsxsXqGArWLYoiP8fDn2rmTN2M2icwS1YKAPoz5GPceukM=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:37:19 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:37:19 +0000
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
Subject: [PATCH v6 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v6 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdPGG+sbdbBbDchk+uDvmAQFi0CA==
Date: Fri, 4 Sep 2026 11:37:19 +0000
Message-ID: <20260904113404.4051341-7-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|DB1PEPF00039234:EE_|GV2PR08MB11818:EE_
X-MS-Office365-Filtering-Correlation-Id: c6d22783-9230-4471-f45a-08df0a78f65f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 gPV9T8tiF8EQA5dbeL1bj4f9f5jo5fd8Wx/nlkKb8/Usknul1hYFqw4EO9R64MqSXofs0alzw79PDfM6T4BqUce7OFWuEExlim3PXdU8/8wBY9FYa8cXNnOvI66OCyIoS2Uz37RYY1hbwqW9KsBslEJREg8vG2X1Kcsmi2NhcetipFb80Z/swxtqCYSlWbWNcQcVaFOCwKCClaDyCjQviN14uXPMw1EjEgNKTH8dQbyk80ZqnYQOZ7gZPuBRTyD68gCoSo883UALWWol+pDBee0tTAW2jqN6wXZTA/+NBjOtoFLbi7o2w0F6IX8gFaJI6P3uz5GZ1M2e45Ylhx8+rgOYVNjHXGpp5d6UFMPiBFdJGISVh4NS6uMcL29XYoYG6+Vgewvf1SX8lEwV+xdze0Xzvl9hFdbU/Wd3q5ewg8/2kz4HuwOSmdbr/A5KMjBUSjnDygSY4MtJYZEkRRTlFYXu5YX14+TXFCrKZnx2WAmUWWt0QuaoPdyeA+dBJIQzrxWKAhcit4I8ze6xDWlSWGTKNGNAUqvz1Uv6irKIYoFwaFwJ+JcOmISI+g6pVgCgTpCaW8dSZs/13MGdgU8PhGWMYuOBnHu7Ux9hcJGOYDpDwBN5oKUa6FzLL0zHeHcXyxFiLGfDaStrKcsWsrmHg0ORDBdc9ghEO/ENbbgi/5kRR/EknRkuo34S0tIDld4TkOm4qoToX5AoBgyZsIrSpRWFph5ZaFakPle2cXC/bCE=
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
 RIBMqoeBYsoThywQluNL77zqW4YcOfJJLLBMTgciPA++nPyFtjKZf3Wa+57pUyh6UsByJneYuu9NgAxBKwT1fb01tAqtJP/6asd7C18N4on0neop8ig6sA32BIyttJM+MUbfQ0PTaQ5T+wW/psZFa2uq3su0MmLLVLltPWQz8Qczt6xSRz/ceiy9mzZsTb1xgE+lKOGWRySaoxYCCvH0KV9wyL1vekZUAKljNjzU/uUSotAr5NJkX9tPQX0abUvcMEncVox7ZboKwguq6PsZHvVRZ0/gebxtOccWsJVAhIQQ0DgjTvoDD0BPgsKJkhr3K2QtkGHeV09CnbThQoyQLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039234.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	03737ef5-e137-468c-92b7-08df0a78e118
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|35042699022|1800799024|376014|14060799003|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	bh0QryvndEknOalaKdsTGJZbErOW0K34T9XtMNtJCTBV6f+9rjeHCiG2q2JVC/5kTfzU/REJkVW31QOsOQPE6xNo89aCfhAnyetmFPdcCriJvs2SCyINYHNwEXCt194g8dAYx/ehk4Yobl6P/cDcqDlP82/MpHJ4aakIXTKhYLiQ+CGz8TM7FrzAhsMvx1m86TOLdb+aQCrXQLzwA4CkJnqPor1/JpxfF6c5D02Mw+EnAUC4fdU5tZuSD3gqYYEcdAkVJDOtxNABbWF3+EFvmXqFCxYZVNBo+CE/7+8XTca+eBKUC7qId7qvX96/9jqsuSYY4Y92KtMgBVVzFuAyJPU52zrIo26X2D4nGjE9ZAoyvrjfCbaNpe9z5f0UoB9mnaqHsGQfpoF0xbJMnnwo8obx+UrB5hldeL9/q84J5fU9jSZSjOcjL+yhWEghSvWoeXW65T3fp6rzUDa8Wc+/6Te7CH4d+NSf60R+EMtaSrTKH/rklXvSz+RL1hhtuiJivWI2XYyVEr+JKI1OI3V+z3KHgnBIHduB+YatSBurW1WHDJOUw/15q+JaZuFwnQMIGCXcsyccbXN6pebSByrXikYeWGlnrnV3KhRUQLP5vjpwLCpeM7/jIknBAW7mPXcHBQ8UvQU7DNBDMIuvd2DyXqSnajtksXeEDfCOvLSydcw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(35042699022)(1800799024)(376014)(14060799003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DmXQAewDDuUgDWTs/N+iy63Ia4Xhmb3DS5aIOhWnh9a8LXXEF0V7WQwOPDu4Vu632XpUayDPB76pivrKMIZPjTd3LGraQv2/RQe/pgiAAgPUUYTKe6k0QTeep9uu+V31UXFYwvVVRL48esg3OHrdc4TrUzDt57qQ7uy7v/2MfMrxh5nQX/EwDypBy9WQcJg7LH+wcSBjs6Yx+/2FRbOC1++AFCTpgX3UMGhWbTU6H73tn90TImGIizy8BsgOtKJiBHrOaMd52pusvR61RBM+aHjNPHsmhGNA1wjT7i950DIJOEVx9HXZr/3jV76qsdeEys/dRHYjkJcyi3YyfBEg1y0yZO04kjLUxQvJFaPRgC5FdHvW+cH9ANo6Sd1b2qyi93Dcr4DifqCQ1fGHFeVcb2ilFnTeLBqNWSNMzTCOgCYK0KHoDN1jKYBCKfGpuAQJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:37:55.4712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d22783-9230-4471-f45a-08df0a78f65f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039234.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11818

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 94bf065c8ac71..e2d37ee221b84 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3761,7 +3761,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
=20
--=20
2.34.1
