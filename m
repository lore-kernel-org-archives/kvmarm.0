Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013009.outbound.protection.outlook.com [52.101.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB7C2F616B
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095033; cv=fail; b=H9UEN34GZK58Eic4xSMjA5XqPs+uZq596CK1FwkqL4XK8uZoznjA41hZLX2lSptqgIzgh7oiCMfwZJoxhgvo9glObg2MKhFfE0M76Bu2lChV73bd4FbCXiOSWzwIxBOuX0RwuYr/fUYRR0CwfQbXKki8XRG4cERsNXOSK+YrzBM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095033; c=relaxed/simple;
	bh=9Pe6Wf0dQDzHpSnSvUjXpP7evrDDU268jkYvIYubAg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jYSniY/Gcsa6v+p6GA/nBgJGryc/U+TFVAJg21qQQc2mdCZz+D+zGe3K4gmGC2vVyeLE5Gy0ms+VIe+U8dhd7oiqa7AIKSm9basp0qyma9geys38bX/VEawf+VEI6aLTE/e2D5RCtwEKdg2vh0Kk5vA7nBszu9PuYHTcSldTwdI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IUknBxLN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IUknBxLN; arc=fail smtp.client-ip=52.101.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IUknBxLN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IUknBxLN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=skyP4ZBsSFJxctl1tO7XCxwTjMiU2p9OqZMbu93utg+dN2KL8mbxr4UMibICPaudVG+J2vYRolOrZylGOwN/ETKDY/dyO389WjLv6hy+MMZVaBWkyrFd5j5NKSOLkzJZ8Zeaa4IsEbe6qrqaiswx+pzpwOQcsAVsj2gd48Qq2AOPI8JvlRDWY2QLsMpE7N2NU0QKmSK5S50iDbsBoJqdf+aZJbnmEdBSyeCQ6vqeS5hHDR0o0PrSZDGkFQRO0qNWWTybaAkX2xnZ5YPE4YwClUX67IWQY3oGpY8DDwbH22TAGTKvLSD82Fr63gFs3EUjEP/YFnF9ywv88/BMGkJm2g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=LokMIcq3Jp23cGkhMbI0qvgW8JoCulVWEyxPADcNYSmQWA5QMBYoB+JxzZeMLqsDHxwPruqTMKND50j2fPLlLhX8c/wgn3SJtu8bGcKqc+d8vK1FeUwn+P8pvk8Cd0zx0Y3LIH4xGGswMkQTQ/IEgDAqsY0EW8OEivMFN9CIItTyMkTMgiB7h7FdeT6mTJ+K2CJN6X0OcImmV/qkO3Wzo9YG2OprS1pL/D+BHf77hRnLBsNnh+d7IJza91qs/BaYGviuqVVInbaluHFQXiXQHqgQHpqAgMduNgT48RZ4Ya3AMwPYGrTkrsk1UPhjonD2+Q7EWRrotYS3DemSMLf+qQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=IUknBxLNWlInE81rOU4ma5dvETkP59UkCmmpW/eWiHXLzlpH9ygoKXFxSZgYabRrtLGli1x4hVa4ajpYZTBHfc0fv9ReBb2QAWYPT9/JgQmBBhf3fKlvQ33FCwShGL17/gRRrUYbgHF3ImTAbHWlpR+f4pZiz4qeCjiSc6sXCpA=
Received: from DUZPR01CA0290.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::28) by AM9PR08MB6067.eurprd08.prod.outlook.com
 (2603:10a6:20b:287::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:10:27 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::4f) by DUZPR01CA0290.outlook.office365.com
 (2603:10a6:10:4b7::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:10:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l2wvIMutmKN+F5sQBMiwdZFVHjXlMQf3eNmwMSuOg2lA8dQLGUPmJpyEEXJ9Mv63ys7sTyGhJCrsK03QD5wqE0HPEVBZSoU4ZHy5V99AudJ5NBwxf5F/bUkRj8EA/z+64CySdiOW9t9eToUYebLPFShQhApOtn5Dtp39ysEN8bHNlztPTlA3nY6sDH1/0RqkIq58UqNNcQPtl6J48zyP4+FlU/m++CabNdV6nlZE9lxqM8HtQ0MaW0lQ/LoP/nka2e/50Buw9IgLRVdr6dlZN7Wgo9/z+LzYIZp1oDaExPsXC2of5mlYll5xDmBeSQbsreM2D1fMKaDI0JmeZLnjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=cCuYDySUeX7MlKV7iYBustTZJUfZUhUYphWDxhsAV7dftjtIofTllN0uwHiVnZM0RRtmeVIFRL4SvPesBeB5ANqKDbJLx4L0NRX6eN9O6n0LgWqizT5bITGtRp4FKQp9q348s6CoqS1s+X0anj6PHALUenBBZAjKJfpPXxUML0/rJxA6FFJiHqhfDA7Nc2t6QsX8yQ6JSLLIUPBwWEhO4iyvyj0dz1yS3DPArsckaUUnrGBFDKhGMm1sYSu5zAWMfrMgjHg+cR49i6EjPyx4F79MaU6pR+gBGROIB9bQsS7APiS73iovzXPgeSxNyMWrwc9dmu8xJ5z2NquGtIunXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=IUknBxLNWlInE81rOU4ma5dvETkP59UkCmmpW/eWiHXLzlpH9ygoKXFxSZgYabRrtLGli1x4hVa4ajpYZTBHfc0fv9ReBb2QAWYPT9/JgQmBBhf3fKlvQ33FCwShGL17/gRRrUYbgHF3ImTAbHWlpR+f4pZiz4qeCjiSc6sXCpA=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:09:23 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:09:23 +0000
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
Subject: [PATCH v3 37/40] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v3 37/40] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdCwZPDMLj8nZGrE6Ux5IB8a+Z4Q==
Date: Fri, 3 Jul 2026 16:09:22 +0000
Message-ID: <20260703154811.3355680-38-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DB1PEPF0003922F:EE_|AM9PR08MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: 87663c2c-9e90-4d76-b21c-08ded91d97bd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 kC1nZ+FsdnYWieVH6JYvDmOISMnsIfLoXtqDPmPXoqrz7yjxcA3b7NjJxJ5q/VIBMv0EYNH1p0U681NE+Gug9rkCR/Ze0Q6DmrIvVkJ0vkNhQlGH2WnhYUg0U9ENFGz/I/b4TwmyXbNp8Uxd/o5gmQXGw8+DlbIEvMVHR0lIxXF+kbs9+8Ot6dqiJgOHUpA34Y1EjRfD4eGy9AdjurhmF32qx47OKv2hYPNDuK+lf32lrfZGjiskY8KLXqpLLGGeyUQu5nYaNYjf/Blfk60QedCCahe+k5WxRYw2vvURdhfu195aGEoJc1H/FFsx583o3VDdVvYgLsVku0FCWsgm6ntmDngJx+M5Zt+mjZdt7DdhtMGm7nAPFmE71b1hAgl0OCeu1CrE3U15fado1twZuLbnpUf3ikXKzayeNmTjNHaAQWUJWn2OvQEKaTOW9PJ6lqyjxdWGRwT0vMWubmmsN0/NtFhw9oJD6XxtYq7b/PYJOigwzF6aGn6d5Fvj6ZcNShAbrWWp5yn+Kgs/cJzKK27z9bicYR8Uom9pajE/+Jfknjqz2LkzbWfy2nQjBkxVAsdrgQ4Zr3lAY3VzJiSnEaO/8YXbgsz4h6W1/Mq6iMA1473d5Ayl/J7Iqht4R0nGgkPGeTwqOyrVfO8oxbwXf9JoIfy8f7Com5izINjLTN4iEMKNQ4OqrQ6/5B5VmQovc0sC98MNseOmCj4G1P9Uf/BfhT+S6YeZSTDg+SD9oRs=
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
 nItLZDVv91id/ys1/UhQVvzSyjKbQeswVI9s4ysyERQRt4a6FNysu7eYFq/jRi2x+T+UU50X5sulq9QCG09lW8aH76dsgsDNLDD6hlaXu+1Be0fM9J3N0goAFID343yLeIo5V0OX7Kr1MghJ+J2mS5HzFAfkD/Q2tmt+H/0qRgVJUCM9fIJQyeOsjxsBT207/PSIskESiLv9vM/OXyQoRRSx7KeqsQ6f4WXgk/xQOzVcCVxhPczGti1uymQckAYRU3zbw8HVhaH9ds05I6JRK9DS8hFpbBUR3NGLisXNuWSV3l0zf7XKrDwDwS62ByfiNBDe4ip2N7NKwRxnMtaoCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a3e093c3-e222-4c39-704a-08ded91d726f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|35042699022|23010399003|82310400026|14060799003|376014|56012099006|11063799006|22082099003|18002099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	dyyce25sz++cCdAlRDmC+Ekhz8BtaAQKS6A8hI1jnaucmgE5cmVhJF0PmjNSZtEkiTTW7VU2gCKah+8xR/kIsLwq8HMzNrNVDZqh7jeXCSBYKScOl+j0AwlWPPipVGb5UtV8Z4wmeok3qh4rp8OCo0+1ItDa7Lj+e2oAmmLjTcn+upLUTR/ykEMuJXGKEEnvJzzjTOyTot76hJj88i2eXiyVQ44mHg5YpTUWlM/2+X/z7qsKxtjc4wFiE5wEJEeodgLx+3Qf8NaBr8xzdyFNDSIxjVH6XgYoESpCgW8W3JEQ317t5YcgUL/tumPQZtsTsO1n/1FsDTm64MyZh3YV7AXkqzzC+HCfPwfen5OwF109yc/qO8CQPLRqXidcoBpHiViRKU4U9Bz1VKwyQjk4/v3RjAXwzLXYPOYa6lMWLWzV2V4gFb8ievzNN1zDAztXqf/dKaTnEoMfL48xOczZEXR9KjYFWd5v1NNKALoikJMxCi29nh1K7CUePAKUeeP7W6LcpBbyc41Phma3yhN5trfe3v1058J1sWb7MUs+uT5/OBlZ91IwF6fcG5yptsjNaf24H3qVLWPj7M0zVD05mZNGqA6P0/yvTT4uguWGsPfqIgWWUjeBKHTBCs/9RU7Ep9tEyHIsuNeARvZgh4/xcVLgAvraSxOolLra9oTHlE7EvQ5M0khCL61GaIQq/rt4N+ymcJTgHXlnm7dcgayakg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(35042699022)(23010399003)(82310400026)(14060799003)(376014)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	szZTxjZjNJFckU34WDk4Mh5LG2CPkyhe3uClfBszdr4h5fhhNCV/PU1eCOBBRBl/6fAhAynqXUNNtMfW8/njpObKOgzzLIRwK7mbvkMN7OaLlsTZsPcPdyDclLwbqNyvH8V9EdRoPzFo8tGlxb4OKAWZTW9ZaTuL9e3/MZvSEzmoPvGEJPptsJ1svrgdOr+JBlkn0nyLiKPew5AhE/Qz0KNksOkAxjb11PRcj08j5XUTvzfe583BI7O8BJ7VFi9Ve8+OtJiEla+pZeZu349uRn2DJ45frzw6uxRtL/uFOXyx9W6fVH7aq6zWwuSc3/i84bQUE//Z0yKyNf7DNj+03GYx3spvjhir5KZDXodLRst9/LeJ4LyTEA1Jiw1+Tb+unQvqm3JvTQEpo+sOUKo8/ALwCVUSt/Y+16l5XeZ8PLFPJflp4195vO89JpEOanFd
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:10:25.5217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87663c2c-9e90-4d76-b21c-08ded91d97bd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6067

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
read and writes of the system registers, albeit operating on a
different set of registers, of course.

Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for GICv5 in the VGICv5
documentation, explicitly calling out the registers it operates
on. The main body of documentation has been directly copied from the
VGICv3 documentation as it has identical operation.

One key thing to note is that for two sets of GICv5 registers - those
pertaining to Active and Pending state - the operation of the
interface is different to how the actual registers operate. Both of
these registers have C and S variants (to set and clear bits) in
hardware. However for this interface, we ONLY implement the S variant,
AND treat it as a raw write. This simplifies the act of reading or
writing the state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 5c6323d82f784..e2045b09f27d0 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -75,3 +75,69 @@ Groups:
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+      values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information i=
n the
+    architecture defined MPIDR, and the field is encoded as follows::
+
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fie=
lds
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero)::
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers =
for the
+    CPU specified by the mpidr field.
+
+    The available registers are:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1    ICC_PPI_CACTIVER0_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER0_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SACTIVER1_EL1    ICC_PPI_CACTIVER1_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER1_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SPENDR0_EL1      ICC_PPI_CPENDR0_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR0_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_SPENDR1_EL1      ICC_PPI_CPENDR1_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR1_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_PRIORITYR0_EL1
+    ICC_PPI_PRIORITYR1_EL1
+    ICC_PPI_PRIORITYR2_EL1
+    ICC_PPI_PRIORITYR3_EL1
+    ICC_PPI_PRIORITYR4_EL1
+    ICC_PPI_PRIORITYR5_EL1
+    ICC_PPI_PRIORITYR6_EL1
+    ICC_PPI_PRIORITYR7_EL1
+    ICC_PPI_PRIORITYR8_EL1
+    ICC_PPI_PRIORITYR9_EL1
+    ICC_PPI_PRIORITYR10_EL1
+    ICC_PPI_PRIORITYR11_EL1
+    ICC_PPI_PRIORITYR12_EL1
+    ICC_PPI_PRIORITYR13_EL1
+    ICC_PPI_PRIORITYR14_EL1
+    ICC_PPI_PRIORITYR15_EL1
+    ICC_APR_EL1
+    ICC_CR0_EL1
+    ICC_PCR_EL1
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
--=20
2.34.1
