Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010003.outbound.protection.outlook.com [52.101.69.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648E63043B2
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375376; cv=fail; b=dmaGrdNp7RepXiembRAPXVz+aBzm5iK6/asufrFdli5Ls4DhBi7LaMNeF/6Hqu0UEO0tNmLQ4ctI5p/XJN5ILhpX3fFHraSPBCwubRxL6rgxF8jZxCsfnaqKsEA9v0NoyRzSLDCLTBpAkd7hLhxBKThlQI+29q3xmd8ZbTB8ux8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375376; c=relaxed/simple;
	bh=hEfLHasqBDRuMGjNpWiTfT8MxQvFBGaaHT+T1uk2PG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DB40mpSslY/jfkJLUE+riMi+V9JsVG0QaKUzVSBu99mhHooKGnLUE/KTMv8AegaLMCr0iQfYt6+MiGp1nGhiN5Y6mhsIp1ndIIyCD8hOkDtUZm+Y5WXsaldgMLqyy1DIe6rn3Rl2fJSWJx2eSMXBvizMj99oF0jN2qQY7yd9avE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LXFs6QVR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LXFs6QVR; arc=fail smtp.client-ip=52.101.69.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LXFs6QVR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LXFs6QVR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=emNr7VzCuQ5sh4s6qJFKQovPqGJlNZGrIZxhiRq4yJh8OWmqwwvkqTvg90Nt0Uv5QxR8MXmTESMvWUDFHOsOLhovZuDpk+f6XlwX7CdS0CSr4Zeft0tl8nEPxevuUBTMgwKBBVqgRhskwN06JPxzXfi6AFWx3GthdETn8HqQ/LIMJgBYK776oI764qbriPt2MOYHaLj9BRoha1u3Hn2AuiTNwvdDV4ml9BDVc8RNh4N2JSSOPr4ej4iYT9hlYjahzf0bG6PreAwacj64ilU47i4gEBNQ0pfPgOTv6vg/gwwXFGcHsws/AX3myEdoPSHxsbPkscsfKFi6We+rlKaHtA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=KDj0p4zrj3cZ0rMNIkqtZUiUH+Fo40Uy1pwwZch1AS7Pv6p8J1SDQVd+t787zsKHurcyxRv/VTJB3amCTWpWNC/eUdVdLCN5TsRzDBstSwSg9gcMx9WfxtaGKkhH851hpsp7n2WnRm03JG0/PE2QTtAXcJquBFovELZ26rCpPCOVF+cBZRS9jzgCnrtyFTGIAL+DuxA1DeLhTEv2rl/ZIVIQJhv05GX2HgRruOdk2MsmaPHDVBl/2M+I5DNuZcQ6xB7XQmZuwye3i4wCban1L2RNIzYkV/vd4cMeE14rGv2NfqfTBSO2Trvf4q+yTacGyDFmRCeVgImv3pohBaIGkw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=LXFs6QVRtA92SLruEO70LJEKkl4RvLsnNQrDYVFLu/tX9Ml3XRLEUqwu5BNaghN5mpw9tZLdefsMFCdYcarirAGhpnIf1GLMiwlVXA3dgkGXAJKnU4n9fsF/98KeJZYFqqiOBMe+R6uqqFXv2xFn+DXUbboOdo6IjRFUQKnQAoM=
Received: from CWLP123CA0217.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::21)
 by DB9PR08MB9585.eurprd08.prod.outlook.com (2603:10a6:10:456::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:56:05 +0000
Received: from AM1PEPF000252DD.eurprd07.prod.outlook.com
 (2603:10a6:400:19d:cafe::5) by CWLP123CA0217.outlook.office365.com
 (2603:10a6:400:19d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:56:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DD.mail.protection.outlook.com (10.167.16.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyrRBaN2p5qDm/lzRyouqwCLFops+7/h5hT2VH5USjAwtL69EnrNoSKjvmi8IC5msUaf0PLVYffizLbizvVcqo45capVK86vDB0ZCby0T8fNZT4YpQmaeFe33cYPgBiJf9M4K1fYfUh9mhvWs9X8WW+C5HXyOn/rBynfEGW9C4aYymtrP/DdiHW2ZnQi9X0RUvA4v1V2hWC8iiSDACOOHNiSLrgCGDIyTSaVOCGOpkh2PhDQzyIItZo6GdHtyx41/bR+QmezQVVISUv/5KaJs2WU4xO2La3IIGMlT4raqaeFGMygJCvgeHSOOxkcKGlU4IaQVsCHqWp2FgAf+YmRIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=iatFmf7Ku1dubm6qPr7bri0Qj2Ok1VK0GDTcHtDhtVDuc39QdNKUZU6nCK/Ph1oQbb58W50JBVQbi/WaZCjlh8efG3ZOY2Nk7j5XR8bm/k47aqV2vNn8c3pCGWL+v8lXkLxOFLQ82oqHPJoaKVpeISXa92EuI5Lp2bLG9i5zEUPlNbFUfhV5offfwBAouDRmHQE76bjQZRRNDk248iMWCJEfgh1XFYMdFfgXbYVKXZT4Sc+sobvF9kaLisyAQMjRpGVFVBI68MAfKwgEreoMKrIUc0Sfz3KuNkTu8Q8jmxwCJazF/UV7vbmiWjWuL0X6ZzBfSMZqIMgPK9HzV0Ciqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=LXFs6QVRtA92SLruEO70LJEKkl4RvLsnNQrDYVFLu/tX9Ml3XRLEUqwu5BNaghN5mpw9tZLdefsMFCdYcarirAGhpnIf1GLMiwlVXA3dgkGXAJKnU4n9fsF/98KeJZYFqqiOBMe+R6uqqFXv2xFn+DXUbboOdo6IjRFUQKnQAoM=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:54:58 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:54:58 +0000
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
Subject: [PATCH v2 17/39] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and
 IRS base address
Thread-Topic: [PATCH v2 17/39] KVM: arm64: gic-v5: Introduce struct
 vgic_v5_irs and IRS base address
Thread-Index: AQHc6THKfWlgNBGNRkeNzSt5IS6TXA==
Date: Thu, 21 May 2026 14:54:58 +0000
Message-ID: <20260521144846.1899475-18-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|AM1PEPF000252DD:EE_|DB9PR08MB9585:EE_
X-MS-Office365-Filtering-Correlation-Id: bcafce5a-a1da-4be5-ada4-08deb74912d6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 NN4t4qcgu4uNGRJrZBm1Em8S1zlPlq1szZP3PBTTNoqECIfc0Z3HoLmtYPeWHJItaWayW3+UVB9z+59IQC0sC1VzXPG+pyNxRlrqionExZr/mwTq1kpka23fVZb2iYgjoM9ETVSFDaKjPvE7H+H7LEVo5OcbnWKoE45MozRW9qUN3RgVBTMuxeok4w6/RuxVomnijOzuvXMCSS5eUGJEQb3e1B+PhZHYqvOZRdEH8C046In5BgwoOaLT8zaY6hcuUVS5gjz1GKfPyklG8c7m9IelZY57eki/2SUuNUX22fb193cC2Fp7GUpo98pCkktfZvoi1iJ1B0d8JrZCmfuMZVaGo1cIU2QQg1Dmoz9jVP82SQ+ZQzeH7wApieeeMfUkp5w8K4H5ysL1YuVZzow3VakXoARb97T/CfSSF4FfuT2Tmi5qcpkxX3xaXmXQf+C8u6PXB6Cj7UEvxv1odR7EUFyJ7YWJCTht+5+0NhfIPeRfRu5YCw0e9d9sL9XAz8cGKRdmMJdRiyLZ/AZnUYhz+Q5QdApzdSpK8NQJ5grelM9/JDubksRXzaV46N1tYX1SZp3x7VczWpp8uUVXAndxktrrvlVxKxvK4G4tR3UrKSjQC53RbUYHHNH9FeNdsGrJcmVyN07DGyFzZQaaz9atvyKMb7+ErqlR7o74cDuqvn4JEQecZKAMiafE1NFfpzPM3EVMqLIBOhveD5LbOAuqj9UMEvUK/JztnLWD570oAkzw1zlg5KSfg1GCGNH1kw1G
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JNg97ZV7pPeueTHkpwtmLEuNAPWy+wTa35RW2HyjUrSH10aYxef7JCMOjhVJ0imVlh8tQ+I74vlectgR5x6i5e0bodZhypBANv3h3Dlstn7AqCLMEFHo8GZr+n6tTCBbLjn1TnnG05O94xwrcc3M+sWpkQtF2UBegl95/GihZhITgVarbCH60HUXLGGRtQ3aPgqEgoPkym+bJJXwinefLXI+jgLpslVJBeqfnk608m6mLZUt6QQbbzRlkfM3fNJoKOhZcR247KjprGv6Zr4XvjxkEp3kxwpxMapxlJqR4qGh2ScMaqfHwUwtIY0+1aSL6QMrbZchBr0IW5y/thicJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f9b60152-5dcd-4389-ae56-08deb748ed6a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|36860700016|35042699022|376014|18002099003|22082099003|56012099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	sLcz9WxegrJq+M92MBNtC0GQ8Jhlrmn1GsP0zNtL/FemmSmhI0DFQOpwM2+dHoOoV3M2K0yKBmCb9V/KH0C7PIY+HSQqcmnzVgnrisJnv+6RxUR8p+lplozVimQ8wQiECt6ipoo2EOiSvTsUPMnN3glTK8uewocORaLFKJ1JEWEgDBCgP/t60QjrmpRFZrNin2YLruzEOixc2QE2UthstKiN6SWtTjR+hdzmOq0XqW/mtlmun1eFW4b0BAvSPa/I0FhLzZcfp44Vof+pcrIcZj6t4Pj5b3D8MJMcsqjQBFtBB2CqIwdYWt8njpz7icd05GA9fXMCtJ2QFtcx7uC9XdK05xQGRVu/TsNsd200TCEMDfNfjUCuuTUdRCsnsL6OfcC9Rg5SqDlgnStFvkLQU1HuWHe5Q/tQdccTEZw5wj4w2zR7Sg5yfHE7C2l1awGYWrrb2wJI8AMccGofham+E/f5D8o48DwMxwX8EwiozoA055zD1o5bld72T7rFSxQ4UPgfUSO9vWiEtIN+l3eQVU1gDwnv+/LCC6gRggM4ePVsUAHTjA2gF6Q+sisdLqa1eOgSSXSNdvptAeSM74mQeyNtbb5aT7aI/jyl819lVHOK4xPbE05cDIW9lXZtQXtdlYfE/RBJGLN1Q7n7pW+gye16k3iYMhoVeLKpJZRgwO4Pv+vXSiwOqWkg2JSY2ZP501mKx+eTWAWfogarHUaq9WNk9jbjYn8aJUWRWeeet3g=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(36860700016)(35042699022)(376014)(18002099003)(22082099003)(56012099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l3+2vDG8dLABZMS7zklZ15Hw5uQqQfnf7s25JytliuvCAyuW30KDZR5YtRUdxvyWWJ6h6uJ7FJZ30WK0VaRIgwrX5HS8UktWulG+brhnKr/RQFsMoKyZq7IYLUfPSLiq6ckzdTDIUpMnun7w6i+DGn0tef85UYEd/ixD4NrZunXCqcsNUf56WNdRBugoFrfpCLMRe+mhvVMJa3a6wrCwMzM+oE5G72r7A1np9QkNSYBH5cOtiB2yivoQVShLFpR4furIxM8IJ2t+H+gTq5fl6LQYXAXAmnrilsL3memq+g4Sis9iDvsaGgLmqtX9G211ZHba+rx273tNI/nlmZ7XVkSxsdG1TVG9zW20OgR6b8tC8TO6xwn1aPuU0rPe2n8WaBS8RnVVEGex1nyjflKZ4wxJcATJK6kz7c2eeTpuBAIrruTHnkPP2ulOogjl7dc/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:56:00.8686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcafce5a-a1da-4be5-ada4-08deb74912d6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9585

In order to properly emulate the operation of the IRS from KVM, we
require storage for the MMIO register state. This change introduces
struct vgic_v5_irs, and adds a pointer to it to the struct vgic_dist.

This new data structure contains the storage for IRS MMIO state that
is required for emulating the MMIO interface in KVM. This provides
persistent storage, and a way to track data across MMIO writes, e.g.,
selecting an SPI and updating the configuration of it is two MMIO
writes.

Note that only a pointer to the data structure is added to struct
vgic_dist as this new structure is very large, and hence it makes
sense to dynamically allocate it and just provide a pointer to
retrieve it in struct vgic_dist.

In addition to adding a structure to store the MMIO state for the IRS,
we add the base address in GPA space to struct vgic_v5_irs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/arm_vgic.h | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index faecde764fea3..25368c5cda5df 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -409,6 +409,87 @@ struct vgic_v5_vm {
 	bool			vmte_allocated;
 };
=20
+/*** GICv5 ***/
+struct vgic_v5_irs {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_irs_base;
+
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* IRS state - used for registers etc */
+	struct {
+		u8 domain;
+		u8 pa_range;
+		bool virt;
+		bool setlpi;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 irs_id;
+	} idr0;
+
+	struct {
+		/* PE_CNT is populated from online_vcpus at runtime */
+		u8 priority_bits;
+	} idr1;
+
+	struct {
+		u8 id_bits;
+		u8 min_lpi_id_bits;
+		bool ist_levels;
+		u8 ist_l2sz;
+		bool istmd;
+		u8 istmd_sz;
+	} idr2;
+
+	struct {
+		u32 spi_range;
+	} idr5;
+
+	struct {
+		u32 spi_irs_range;
+	} idr6;
+
+	struct {
+		u32 spi_base;
+	} idr7;
+
+	struct {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool ist_ra;
+		bool ist_wa;
+		bool vmt_ra;
+		bool vpet_ra;
+		bool vmd_ra;
+		bool vmd_wa;
+		bool vped_ra;
+		bool vped_wa;
+	} cr1;
+
+	struct {
+		u32 id;
+	} spi_selr;
+
+	struct {
+		u32 iaffid;
+	} pe_selr;
+
+	struct {
+		u8 lpi_id_bits;
+		u8 l2sz;
+		u8 istsz;
+		bool structure;
+	} ist_cfgr;
+
+	struct {
+		bool valid;
+		u64 addr;
+	} ist_baser;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -486,6 +567,11 @@ struct vgic_dist {
 	 * GICv5 per-VM data.
 	 */
 	struct vgic_v5_vm	gicv5_vm;
+
+	/*
+	 * GICv5 IRS data. Dynamically allocated due to the size.
+	 */
+	struct vgic_v5_irs	*vgic_v5_irs_data;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
