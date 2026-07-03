Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010054.outbound.protection.outlook.com [52.101.84.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4D128C2A1
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094700; cv=fail; b=SbEY7ddg8pKHQDrrRIeYk//+vFnTqk0OK7P3Oam7RacH8x8jBbGyo2is+/kGpOAE33yk4b5qphTAYaeVsjYSlsviA5+cus9bynh4C1SmwOT+O0IYkkg5IXEvC2bonAHHqtscFa2Bzi6hTGjQI1J79JwlyqLnfzUWzoM4d7+xK9Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094700; c=relaxed/simple;
	bh=tITM3UiwAc+NjemMYRC4Q03Tp/jQlW05gkvClPm4TOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HibHrh7ySy9uytJmAUvaYpKy8Y+VHYgVeDTLNNJGEUPJTwDsXp0Nn/5z9KR04iypyia5jzgfnW0XYL+uGVt5q03VAup/poxEcthe6OJQajPczf4BAZyM7vEJHexDWvVUzEoHSs+fH2UO0XL/hcVBOiau2I33ENoW3n4bo6dthas=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YazuVfQS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YazuVfQS; arc=fail smtp.client-ip=52.101.84.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YazuVfQS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YazuVfQS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=U2ldRTPs5WMiGPoTeieg8cxb4DLtX5vX1h1G/TiAcWTKH1m7M1o+kSp/Ud2MYvPXg92Q01BmPwJQD7APv+vscemKVjIIC7RQP3mFRvCVtIqVCUoQ+6fDJoWnWuJyRBTjq5LZ0VyA844Ind5P1ljL0K/u3jQQlpy0iGxAo3OqPVSko7fO3jG2fl1e1WH80R/+HmJTC0vDMB6TBMRiIpMWcFi0qLAAaqMwuOZuW1B3k7OV3NBQNVKUcVohUOADYnXhvKXqq0/2JKE2yVxb4PAfCPC9pBjxN3zGV9FnUhYl+vaCpjtqhGRrVbKeIKLcWc1aZp0RmNtSG/LrVL6rkK2Rng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnT4qxtLEF7m+vnFbbOpGI7t8+Y9BMj72qLIFWikUBw=;
 b=nF9rYdisz5bbjSikghmHN8Cy7SIcddaFwe6vKfUG6/hizZmBOVqRqZhqXRlX9RL2jTcBs8+E+zn5a61UEX3rQs9czVo5yJPZ6+wU+lWm298tEw/224pg6ww+N7g99dgPs247tusRLTOhoac9aeTn1ok4Nlcoqq4ugzHvtfpY2jwBMar6A9Z7XDAkJTNKVHLtB7R3XzvXE/g0RP7LMcQZdmCNv6b/HIzRIAu91TlOIoxJPbnl9VJiq4cKWwbbm6AusT8kFAOcmpCb8zy8LWjBBGTOGF6zi9cXLKEGkZdsruCgvDfTo52zV6sr4wWzXJgaBni3jrCUyEBh8DHza/uRWQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnT4qxtLEF7m+vnFbbOpGI7t8+Y9BMj72qLIFWikUBw=;
 b=YazuVfQSRC5Jjsse5+7cW4ndJRy6OOD9QT0iBsJaDiSvuAFSjOYnQOWmQkTzCjswoxCGTSnukAHn/m+p1tYqqDXJjkjhuOaZKtGqDNx+090XqUdCJ5YFLVwvfi23SIVcU1A9zNCoIocN3YwTBl1nUCbuDY/o+ESjhUxg6Mr/Nbs=
Received: from DUZPR01CA0129.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::12) by DU5PR08MB10803.eurprd08.prod.outlook.com
 (2603:10a6:10:525::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Fri, 3 Jul 2026
 16:04:51 +0000
Received: from DB1PEPF000509E3.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::93) by DUZPR01CA0129.outlook.office365.com
 (2603:10a6:10:4bc::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:04:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E3.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mVXn41faFcaI1ZgEOtVKI1nj+p6qtRkGRHVyL8qczZSI5VUTAVqXaN6VSyzsnUmmslKx3kOKVWJLHZdYmPfDMYEIaOo2T4lBIp6CVyIpIXmqLu18kAEtzTbpD6PlLdjU34lmoPK7LoLQSbTQvBG953RBR7W6zZ7eLBc8rJqzap1b2I+s2d6EAf4rle5VKq8w/DmiSv0sEdKw75NVgby28/VwIJgtzDuuiVRw+wkzK6J5FYtoL2r0SxbC9q8mhe2xMuuAhb/8aQAYGXBBGHh4jI2ozAPNFSK9oTiClsXWLLuqxsCF4WiP+8KsjfGJZmoZsDSFo6/o2oNirZwVt8TB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnT4qxtLEF7m+vnFbbOpGI7t8+Y9BMj72qLIFWikUBw=;
 b=d/jJxvbYBst3k9KWsbVN7EIHjettY5IBLGEck857cvyDSCC5PnMTJ169OmVRFY49NxKbK81BDXV3moo1J34rWPZcQE1newsIDFwImsmV9o/l8lIztpm+3onp9OC+hWD4Zum8ulBRs821VKN7QNiKHsp3PPmBjevSWoLm8ZqfP4eR4jKPS/xgXN1Q9xlAv3OkYEmQqbTjXmqmitpOJZxXa3WmbLAZA3JDZxDOtAhVmpQDA9s5PSQPauE9CuxByry4QZ/OkSBq5/2mpL/fv78oWLSJXX7JbnuV9CjOib95tBYeAN18wb1ICboGPuRMcqrU0ZEZRFZeA5N/A3u1JcYijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnT4qxtLEF7m+vnFbbOpGI7t8+Y9BMj72qLIFWikUBw=;
 b=YazuVfQSRC5Jjsse5+7cW4ndJRy6OOD9QT0iBsJaDiSvuAFSjOYnQOWmQkTzCjswoxCGTSnukAHn/m+p1tYqqDXJjkjhuOaZKtGqDNx+090XqUdCJ5YFLVwvfi23SIVcU1A9zNCoIocN3YwTBl1nUCbuDY/o+ESjhUxg6Mr/Nbs=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:03:46 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:03:46 +0000
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
Subject: [PATCH v3 26/40] KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG
 hyp calls
Thread-Topic: [PATCH v3 26/40] KVM: arm64: gic-v5: Add GIC VDPEND and GIC
 VDRCFG hyp calls
Thread-Index: AQHdCwWH3cGLlqKzd0e8BJTczryBqA==
Date: Fri, 3 Jul 2026 16:03:46 +0000
Message-ID: <20260703154811.3355680-27-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DB1PEPF000509E3:EE_|DU5PR08MB10803:EE_
X-MS-Office365-Filtering-Correlation-Id: bc65e9d3-181b-499e-2053-08ded91ccfd5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 +ET4IhMMMo4DyyrJtQa2IukUH0qSMcfDKsQtTFiSR/9Fw7rpXgP/xGaeQGD2dJAlldUNaD1LyAhRZLNRt2fCbhkelhCjuCW8L3DhcZcXIh7eGaUPhvgdZ9X1b6sxHZjKMuldwp21XzyqhewDOjhhri40w0H1nkG3RkeiaI26B+aWZ5dDPuKFnrHH8IK8amJ7vL1rNFaerrpq+P+3PPEXUkn8mHyIJmi05XQ8WFCTMRfsNsw5mkFWoKTNXLJkFGYWaPvYC6iAa+ZAKUYw6OlFjiEiH9GkwAdZqPxDgji02DD8RmFp5UoiqYSv5Gzowb+OPSwxDU7gmhxjQRy/Bsn8rkHLPni9UuJyqSdW7bBmkP7WepFzgzXOGiAgSsCgsXv4wLQdP3S1OtAdKjIN5OYHX5fUWEtH6kQXBOSMat+s0lwhLygPwr6QjraMQZ67qGr2Dlz8qDf4jEARRyM9H+IDIn4zJECI/Ujpmeyd476k9EtcLlZk900u1DSSGZyYtLE22CD+S0AShLfVnlMiosaHuC0k1D7ArsG6uwcxUGVLQDm+gKwss/aG0iPK8iWzUycISz+lj5LjkytZPhCmI0ikah641zjhHwWAD4fhy1Vr8zge7iKQx2QiiSSldCc2AwaidUckfyLHs/neqcijVgMpXiddiWrgEMP0dz9FL8UaxbN24ibZWIh8xW34gsbrg2X/pLbN/EKTE/OPEdLvlIibT/N4tMW4slmLhCJR7pL6LDU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HF1Lfjtlr3ACWnme7E52I0D0z1yG5WrjEXbZb9kj66bIh1C/8mPaPHaSv3e8uxdO/Bpo3q0+pPpP0UBeX21uxEcYmyK6kRnLT3yD4N9slmrEtmVR23u8Zbiyzf17VVvvqkUTk8G2hF/GB632EMyINesqlJoTco94pBgYcX1uxXxpXTsmLSi9BU9YQKxvv+fflkHnpdXpzxiN/mupYUTLxFvKsvTD0WYqbaQvlswnWtvnjhsMv4xzsFk52Lg8OXBjLN0cXvuMUvR2etHYxnIB6MGJOrVVk6JNeyFkDQvKrj1kDgdKcj/w4HxjMbvEX0neuom2J1bqEl/QAZvLLa75Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	833d5269-de6e-4a00-ccc6-08ded91ca9c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|36860700016|1800799024|14060799003|35042699022|18002099003|56012099006|3023799007|11063799006|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gjOSwhebWugTweXm96/aNdNMXL2oJyVI5P61hD3sbJC8mOkZMHdCQ4okA0IhEI59o3/UvkGhULSPuy6IgFmsNUwOUMpFNRNy7xK7z3m+rvBPgwoj/X/ESqRnC4Z0Ll4z0weHSUamA3snZzkZkJ9Cmu8t+bBcFNfFzWdm03YN+JAVqQr18+jF9GdGNavMn6yvrKADJOADkPQ+48qoKc5a17egKytDntzqXbCu0tiDSftwM5UDnejPPZU2pKeoFebSTqh0GkgnGIXXO92h4htYz84zvHU65W4OvABtemOC/I/RxicUYFGGz+usHvkgR3g6doZ5Ro/3LwUUWvCPjPVBokYlB7dgvUYqX48D6ln9p6A4fMIZ+2tkex7oWokgAlG8Bc8C7xH3MdyVI/wY4VxvkGnLv9YH6GjalIy7EpvOblMpbh4Qyw54yYLy6ysnocwGc+v65XnNxeW+XkexOAcr6rIp1eWZP9qFnhrAJ0Ady5wWP/KJv4bGtdJ4oOhPg21kuDl1B4WCsRpF6XPB7vaZXhj35s/j5+5C3covKLBX8yjWHwzd1oYj7+VWYOmaLqSdC8OCHSB4D3DozGwTvIk0SpH1v6uoSngYQYfS0v5hekY3gfSVaVrL72pUD6UUdNFb4AlrPWIARF77VllH3P9cR9+dMO8hQzmAK+vIQFXKgXxLhAXYzKUiGxhorWkP11WcuIxZ6NsymL7+eQKT+rpcuw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(36860700016)(1800799024)(14060799003)(35042699022)(18002099003)(56012099006)(3023799007)(11063799006)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kTu6+0JC2/vXqkIUwJaGqtFOLtEiq+3fgxsClQ6f1sWlcLm1YZMnfV32fq549YpASne1AXEA55YUGmOg4WZWg1MW2liVGUeWF7f4EBgPlX2i7/4+cpkwOcB3YRPBW/PPKgnW5bsaIuPBVnikQ0MAhXQqeK6F3xaqHIQamWUzw2pQMCy8YoJjR1G/jWkzJ6PKaW6m35g/+0SlkX1neR1IaMC5SjVstAEwCliNMUgMF17+sa5lsbomt1k4qzZ6fY9jPTWlmhSnnTl4wT60ky+lsWK9adj+a3tm/w9CNUWaU68ckAYksFn79VcdkiZ45Q3sV9Sie37GkuDwT9ol2aNZISruLO1vVSnjnhMmsqosh1BZh+NFvFmV+09E/eDvpfmiVVkPl4QC5HlIwj2rcM9N9N/GrVbfa+vDnOkh5Y2I4vXKRbhinxEZ0useGNRYWq7b
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:04:50.1224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc65e9d3-181b-499e-2053-08ded91ccfd5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10803

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these
would limit the number of interrupts significantly. Instead, SPI and
LPI pending state can be managed from the hypervisor using the GIC
VDPEND instruction. This provides a way to set an SPI or LPI for a VM
as pending or non-pending, i.e., to inject interrupts into a guest.

At times, it is important to detect when there is an interrupt that
has been "consumed" by the guest (deactivated). For PPIs, it was
possible to do this via the ICH_PPI_x_EL2 registers, but for SPIs and
LPIs this needs to be done using the GIC VDRCFG instruction. This, in
combination with a read of the ICC_ICSR_EL1, allows the hypervisor to
query the state of any valid SPIs/LPIs for a guest.

These system instructions are only executable from EL2, and therefore
they must be wrapped in hypercalls for NVHE/hVHE configurations. In
the case of the GIC VDRCFG, this hypercall also does the read of the
ICSR to ensure that it snapshots the correct state. Not doing this
could result in reading incorrect state from the ICSR as there is no
guarantee that someone else didn't sneak in meanwhile.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 20 ++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index d9ff9c2999aa7..38a4ba998076c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdrcfg,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 8fcbbff719cce..02b38e598176c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,8 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
+u64 __vgic_v5_vdrcfg(u32 intid);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 09756f71df08e..6fb99c4fa9f19 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -719,6 +719,22 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
+static void handle___vgic_v5_vdrcfg(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) =3D __vgic_v5_vdrcfg(intid);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -754,6 +770,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
+	HANDLE_FUNC(__vgic_v5_vdrcfg),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 46992a6c2cacb..c50e6ae93ba3f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -149,3 +149,23 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
+
+u64 __vgic_v5_vdrcfg(u32 intid)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDRCFG_ID_MASK | GICV5_GIC_VDRCFG_TYPE_MASK)=
;
+	gic_insn(value, VDRCFG);
+	isb();
+	return read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
--=20
2.34.1
