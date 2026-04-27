Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010056.outbound.protection.outlook.com [52.101.69.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89C434A3DB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306238; cv=fail; b=LdQd+JaNMZSh5PBhbtxarHAh85ZV07/S1lh4lVHfz3+Ixh7XWgPRUXf+7CAsC8zorNuvWRPgL/2HtjYbTi2EJU86oSU3EE4+hdqC1fXdo/Gsqm+xuEkm/jO5mTO6J/ex3ec0iILao8QSD30MxMqubbUp/57kfqq/MRcL24gWcH0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306238; c=relaxed/simple;
	bh=BQC5HbqxkIeXh/FYlOv5n3QQvu5NptjkphOotajQMuA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IcRaMREH4h6hTMlf7gjxE5hHfFoPN8InOi7TqyzgZNiOcRquMfPh/CoBW/VZkESvWn0CAvGdlqN81TVBrs+I//nWJ9zoaNkeyYl2xJhSgsleOekX5K8v3H3yi+DaUHyhoDg5nk4V4WWBtmuapVTTBfe0f8nw1gpuLk5sgNpyt9Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K2V5DFu4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K2V5DFu4; arc=fail smtp.client-ip=52.101.69.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K2V5DFu4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K2V5DFu4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qWIEvvqm8N+JkvxOK1Hra3wq/i1AVMpXdH2s7/87BNIvxKypWI7Sm1B92adja3wrBJ46Edlx6/aUgpe2d76TrTe4rG48E8LyoSoRBkSacVpLUslqWfva+EqMJcuzLQWro5A62F/ddX00EFQrMcQcW2roEAe9VJYZzB4RGxaqqVLKCirClxI/pHB6RxQF2BZN3y8nV+hQlGDg8ljyqdx3r744dK4ixjNyQGZzt7G3cdTp2DG1dKp7smovVz6EtyeeNfiQf2RRoAd7cQ88diQ+7hGji3s3z7teK3lym6Sq7BMS9/E3Bqz6xRlo5eT8O3P33xDQq7SSdKlUxT7xOlaVVg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hkXA9RW4oaAA4IVV53aEsI/vU3UWGkMqssO+m6373s=;
 b=XeiYCipoxW/+Bjg0W83BUTyLVF9uSzpyTBXENC9q7UB1hbHinQEk2vNaQ6sO1wmJ+VCSCgxfNGeP+kEOOVf8z/JhDXfxykpxr6iS+YjzQQKr+8wbRCcnqd+VrZyCtzbc+ffvuMGPL9NjyR/tHnFWrWGri903bAF3T4NLS0O0zIgZlpo9SS22EDNWavpLhTr2MmLOx1yiso11ZGZaULymPoXaGcxmZdK7qtQBuHeI6z+0TSqWzdD9dln7n8sz10w3tG3kLxIwMCGK8WJwn+cXLOkoNkaGmBnVXjcRt7b4hrzDu/ln7W5LiEXbispHEMeHH5STmX77hKcPAuF3KD/Qjw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hkXA9RW4oaAA4IVV53aEsI/vU3UWGkMqssO+m6373s=;
 b=K2V5DFu4A3v8fnQE3PyPo+7MXw5FMkzGPeGZTm1qA6p6fTPWBif1aPJMhicdLES98D6NQm3kpHC7l6Z/PJQlhd1ELIldR0TgnUZnD/28fcJI6vG9L7ZeXW25c9zNrTxbLI4tH+jPL42f004RpvHe4Aq4dB7En+PMk39rrj0mgsQ=
Received: from AS9PR06CA0278.eurprd06.prod.outlook.com (2603:10a6:20b:45a::18)
 by GV2PR08MB8317.eurprd08.prod.outlook.com (2603:10a6:150:bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:10:30 +0000
Received: from DB5PEPF00014B91.eurprd02.prod.outlook.com
 (2603:10a6:20b:45a:cafe::f0) by AS9PR06CA0278.outlook.office365.com
 (2603:10a6:20b:45a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:10:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B91.mail.protection.outlook.com (10.167.8.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upkMnN0J4H8ns1AxGnbsuVT2BIsheDEdB6GA3SixK7WWzpfFOs0z6ZH8hEhXvQrdFKM3Jg8fFxMaReC6Qv4J28xuCU1bFmg7k5K1+JYOfMcaAJFMxITdT3FzFTONQUsN44mO2ejri43/cF00hJBlhDWYMiDi+Mq5ecxLYsmRJTrJhEL1NEwiRWC99K8+9PXq8SX7zgVkb2G1yPCwzFa7UYFSmh90t8Rl6aUjryEeRUaJCq1/zZWk1TvfKfKARJC+3WU7YPrgiPGXmcLwds2gCB8/dScxsc9QW8VptTLncRdwkiPCEjimumJvPzAdwGYJhY0hfkst92gug8kOnKa7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hkXA9RW4oaAA4IVV53aEsI/vU3UWGkMqssO+m6373s=;
 b=Hz6Tt/1rhFoNe5gbtIS5Qk1rRDxYP8J53COejCVQZtF7AoPeIIpzeuZPQ5XEvXatch+5JZ1x5ExA+5w/vu6TgzXKUCZMy5aX1L246lPSr/9lOL+II4Sv5vyedxgk+FEPTUKEr85xRpbmp56iCJOTOi7y/cONLIN9rST68hlKh1RL8UaM8eX/DOm28Qlg62htJ9eGUsNpknpRsYF11wfdFPYTuMRNUfGYS7yCPq1noU3iVLFNKq/iTglE599YB7jL+lG5XTSPcFU5K3/O1qR3Lg2l0Xr+UNsFbRiPQxI8ift2ZYZfMj9gw4XVOzbEzVme+z7loNmAtbN8lyYbw6amUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hkXA9RW4oaAA4IVV53aEsI/vU3UWGkMqssO+m6373s=;
 b=K2V5DFu4A3v8fnQE3PyPo+7MXw5FMkzGPeGZTm1qA6p6fTPWBif1aPJMhicdLES98D6NQm3kpHC7l6Z/PJQlhd1ELIldR0TgnUZnD/28fcJI6vG9L7ZeXW25c9zNrTxbLI4tH+jPL42f004RpvHe4Aq4dB7En+PMk39rrj0mgsQ=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:09:27 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:09:27 +0000
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
Subject: [PATCH 10/43] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH 10/43] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHc1mA45QPYhNK/Qk2OWIOxNxFmXQ==
Date: Mon, 27 Apr 2026 16:09:27 +0000
Message-ID: <20260427160547.3129448-11-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB5PEPF00014B91:EE_|GV2PR08MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: c576b0d7-5d13-4209-7207-08dea47780ec
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Vw6DZNlG6R22sK4Rt28JbQjGLG5e5rFc2pM/7RerThQmtYWAGJ5MkaLo0utrG0P8Di+LbfuViQgADjkAnHoGl+78oxfRhEwnyu43vcB64Izsi1HsgI80xJQ6GCHDZoUTWUHONA10P52SHepyFsZQh9lmSwc3xQng53RW93+yx4aEUe/QCyt+GugTkv62YOyV87icjXp77tCHNjd0FKhoCURswldWmnrh6qFEfNguZ8jop1Gsff6SckAeq7MBkS/6TekYR56bfv8WNQJrJYO/uz6MXGFXm8ouutNRtII5z2VafBtqh+RnmMCYSa9SKKE7ul9bYO3ZPtQvOodKq1AXZGSLUvQChD4E/DJLUemlo/niDI0zb89E+2PcGr5TUzhhtKDLkxExjmT1J7WrMsIwpTlSnBM6uzcDFvjRfAUDBaUDLwjHsor9YWF47Gks6khXZV4LmIxhDpqIgwWFsH5ilgGLsrOWAU7fNpEcbSPEX6aMrdeqTBfU9gVxIrEP6HFHYUy0kTWUL0CS0twckJyRleIgcdIJUG8yIObHJJE2TIdHoBYZSGN9lNDkOjc0fBAaXeNwE9XtQylfci7bQRQ0ktFLbN7qSGhYLme5GjNdlyGtIKqDB88US5dbth22wn48+UVNvR+RJWo8rVBfSuVunDy+Xy+el9LEdADdrJWdzrH5rJ6ITXM0BhSF8bvlF50LPsTUub5qaRx+ScZKEZnG8q82jaDw25FCdNUB32rb9grINMMqGLqtbLW9y6vGzzVm/W6VmJ5XYb2LzSD1g7LVLC9eucEQC6x0jCHEKw9rtcU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OWzdA599X8qeBpINPIAvC6rw9WEYIhZb7Qnm4jqugaa84SmjafQD/8aTqLuSesuN6op0ZsloYNPrewoszeRZjZ7F/4MDA0TYPeARoyj+0yBtLmEzfvSiPdD4VmUSpKEd3DWl/zb9SKLXZ3J6mXR9bqyJgoG6PS6km6akAB9VtkuDSLESiFApco5v00mcVIOUIAPK4hLrkPHDBMWdrL6/JMukPutpn2EWdL66xh6RXba2oJgI054REoV/sDjO+lGbASzrJZGQRyXxtOTj7nMjtBSPFoEWfIDmyTboJsaDbhWyielXfPmEfDZkHO76W+I2Ua1Qh9XUjmZgGetHXjRnqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c21b0eab-a988-4a03-0394-08dea4775b4f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700016|14060799003|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	zOf8qA50kjG+tq3bkT6qRaBM0qSBCemIJXvIPpnqR7yrINeJmTFZfXShCTHGgCJCHxIej1vGIm5SW+sNxpu93+NUfkf1yX3EALAw91r2JBQ6U69XQtUSHzCyHOwCKoYU31yqa/B6cWtmuUwkMpCY3CXxQJ+0paAsbGyjl2xKD2SGx1FjtNaetpaJ5M9YtecS2B/xMjut69ilI12bcu3VqA31sRuceMvuDyHe9e4OuwZqaPIB33h+j30yI3PY051OFxOi2YTr2v94BjlF5Fej7+nES0sGfCkJ1EucWgq2PAhNFmpFGV2UAfpGqTfd4wXTaKmc6a71Ynvg1SyicDnzkLddtUIewCC2rONj/RqdnHtalKqsO4IMyXxnYTAJQYmHTQDvvCarL2KgLkMHap4/H1vCQObWOELgAYL0BWbeqo+Dtf4w8S8dYL5dX3VKeTMmKcv5XuvXanYDOUK2n3M2imPSVdu37Lwu7EDh7LmSuhJ3nDysja2k5oxAhV3ORtUWjfyPdSZhJoPeZ4JP4LztSlBZvCxv/fMqh/Wh+CAwQatf3lI0YHKb+QjI9aGryXViQ5+Dzj+XicCsSX/MzwLSSHIx+8bEme7xBgakttIZx1GMFh2Y+U57i11aj0kaPb2NUyDrpdCXbe5bESwGcKI94wInm0n5KQjMr9AtNUvuCw8Ec7usLFb1XLvYgSG+J5c7z0/J5FNWPuD9/Kny8dxP9k5cgfbpIJk6K++4bRovxBDYNbqO0lhUuCHStudPK/EhkGg58i5Eyu0LAgep73HUmA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7LhhCQZRIYYyLO0NVqq/q9GnMnxtklGP9EekW/eBYtyVl1Y1FNA3xYWMbdUMR7AFKCxtMQNXUgXH7LMKa9vChVS+rZ5LEUjbT/VPVkEYQ7ZFxrPl0TzaBYRey6BzjDie/ckGbxe8iyvDjRLzcnBFqwOkzqSBOamKk7XUfnmua/9lHkCRgJQgrLMrqnc5zDw0UbEd9pXPbW0ZbID5xOzNOEF8Xe7k4BAlLfI6gTgt51nkffd49Zp2XdmvYUpxfaT9L3vanVsQPnrnkE/704ziQpXBlqmBgbYbvKYd2RT7foKffzMT8JjUM1Ql0WV20k/5cumzJP+zKKE59m8v1S/IRmfjkkBn0W0EmDXMRG1q23IcJmEi7N5+PSrG8o0+u4v7tcZyW9nHml4ExnrCCj+u7vlMtFZ3MVL6t51rKjXlpPJo5WkcNx7GFq4lWQce4wYm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:10:30.3147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c576b0d7-5d13-4209-7207-08dea47780ec
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8317

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET
        VPE_CR0_READ - Handle a guest read from IRS_PE_CR0
        VPE_CR0_WRITE - Handle a guest write to IRS_PE_CR0

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 164 +++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  27 +++++
 2 files changed, 191 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 49eb01ca07961..0649729f6b834 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -253,6 +253,25 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 	return 0;
 }
=20
+/* Wait for completion of an VPE_STATUSR change */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	int ret;
+	u32 statusr;
+
+	ret =3D readl_relaxed_poll_timeout_atomic(
+		irs_base + GICV5_IRS_VPE_STATUSR, statusr,
+		FIELD_GET(GICV5_IRS_VPE_STATUSR_IDLE, statusr), 1,
+		USEC_PER_SEC);
+
+	if (ret =3D=3D -ETIMEDOUT) {
+		pr_err_ratelimited("Time out waiting for IRS VPE Op\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base)
 {
 	u64 vmt_baser;
@@ -369,10 +388,142 @@ static int vgic_v5_irs_set_vist_invalid(int vm_id, b=
ool spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(int vm_id, int vpe_id, irq_hw_number_t d=
b_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_M, true);
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_S, true);
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D FIELD_PREP(GICV5_IRS_VPE_CR0_DPS, true);
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (FIELD_GET(GICV5_IRS_VPE_STATUSR_F, statusr))
+		ret =3D -EINVAL;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_LPI_ID, db_hwirq) |
+	      FIELD_PREP(GICV5_IRS_VPE_DBR_DBPM, 0b11111) |
+	      FIELD_PREP(GICV5_IRS_VPE_DBR_REQ_DB, false) |
+	      FIELD_PREP(GICV5_IRS_VPE_DBR_DBV, true);
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (FIELD_GET(GICV5_IRS_VPE_STATUSR_F, statusr))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vgic_v5_irs_vpe_cr0_read(int vm_id, int vpe_id, u64 *cr0)
+{
+	u32 statusr;
+	u64 selr;
+	int ret;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_S, true);
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	*cr0 =3D irs_readl_relaxed(GICV5_IRS_VPE_CR0);
+
+	return 0;
+}
+
+static int vgic_v5_irs_vpe_cr0_update(int vm_id, int vpe_id, u32 cr0)
+{
+	u32 statusr;
+	u64 selr;
+	int ret;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_S, true);
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return ret;
+
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (FIELD_GET(GICV5_IRS_VPE_STATUSR_F, statusr))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	struct gicv5_cmd_info *cmd_info =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	switch (cmd_info->cmd_type) {
 	case VMT_L2_MAP:
@@ -381,6 +532,19 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data !=3D NULL)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
+	case VPE_CR0_READ:
+		return vgic_v5_irs_vpe_cr0_read(vm->vm_id, vpe_id, &cmd_info->data);
+	case VPE_CR0_WRITE:
+		return vgic_v5_irs_vpe_cr0_update(vm->vm_id, vpe_id, cmd_info->data);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index ff5ad653252d2..54b573783cd75 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -90,9 +90,14 @@
 #define GICV5_IRS_VMT_BASER		0x0200
 #define GICV5_IRS_VMT_CFGR		0x0210
 #define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
 #define GICV5_IRS_VMAP_L2_VMTR		0x02c0
 #define GICV5_IRS_VMAP_VMR		0x02c8
 #define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_VPER		0x02e0
=20
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
=20
@@ -199,6 +204,21 @@
=20
 #define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
=20
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_LPI_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_F		BIT(2)
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
 #define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
=20
@@ -211,6 +231,10 @@
 #define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
 #define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
=20
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
 #define GICV5_IRS_ISTL1E_SIZE		8UL
=20
@@ -480,6 +504,9 @@ enum gicv5_vcpu_info_cmd_type {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
+	VPE_CR0_READ,		/* Read of VPE_CR0 (guest read from PE_CR0) */
+	VPE_CR0_WRITE,		/* Write to VPE_CR0 (guest write to PE_CR0) */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
