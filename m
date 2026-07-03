Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013019.outbound.protection.outlook.com [52.101.72.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EFC2DB7B8
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094453; cv=fail; b=T0Khw/SemV617CkAsZnWTuc0Hs+jcVhGxxRVcAtLl2wHhR0WEeT2EZNZqXy5qL5BaA15DFUbEI5CcF0hPgp3DHBS3o0cOl+4JCkeKBPz3AUyLV0e0++WakqMwUOAz4rjMDWNwyDRazjxdaWYh4gegc0GsQJpOcS/HaJSxqQPuZA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094453; c=relaxed/simple;
	bh=5bQ16C3mYUqq3TyZmvrYuZ2jh6Fjz12177R8P1om80U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n7yKFXCjqwHXG+1Zn4jrI1x73xT9DxGh1a/9UJyQikk5Mq+XLIdL4b/FReXUelDItnneFnJ5UzmS4uv30+ODBmGbc/1xlFvuHVwCvXqB4RR6LEQFowUAzOXE9DGBNh7y0HFxrThhCC6t5NpqS/Xu75PraCXYkFGvFVg/NSZ6VT0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oKv27KgV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oKv27KgV; arc=fail smtp.client-ip=52.101.72.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oKv27KgV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oKv27KgV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KEYUKeU8FEUlA08ENGEzNDWB5ghadS/ATMOe7xako2g5K+kyEVrPtHSZ93Val38kQ0YTLjqS+w8wLLHRPf1SaRIfd/Ib44KzkGZw27CJ/quJj0QZ6trRiTSXNo0aIsDEKKJ92NzIJsEZmg+nG/rFWdwQYFFmzJRZ0NPPz2HPOwVOg1tza/1u8OLJ4z+fyyGoQw9mEABzISnfy/djeI1RFgBlbhxVma0R68KPDp1MMf9vWHLEwe/Y22GJaZfa62tED38uLpcU6sBL/kv7bnlmoCSssAP5wAbF22bOi2EZLgjylz1RzZtQP2ViJEc0s41vvEH60BwRtQ+1v1bDAvGS2A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=PDzmH7/loDL/vbDPlGeLb+0VvZMqeq8Ns//7Z2OsjSWCVx+AwUU/sDvAsfjyRf3faRs8GEfg8KEXjZDxe+9y1WOucyjwistC9wPh6yNWXuniIY7vffYKgFh6baYpwj5loiKfZEjlBDkT+9+esrSTiC9vGGCprcfuxA8TGGeFrTS2iWGgj8E8SjszqcD3tW1MOe6Wmc4KmsE3ocA4tVoAapnMXV/wYbRj9To/4AbBgtqTNqkL1P4sbEOPelH5bmzi7i/HVdxqcZY2YyhXnKvczOYMHoduwZGuRUnXHp1bmsJDuzu7JArR1FifeIYXx4G5Kl6rRZ3MIrMDSMue9+WrmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=oKv27KgVQdr6YIK/RlLvY1Er9pktwn8bYrMh99SRTzM+poLQJsAeSIgx/FE95xgAuzSGR3QiduFkgDys4FmAPu34QuzdfUZrncleiDlPFGSfD5SdltuCA2ZLd94Kufdk86lfVni/JlK9quxVbJdtkN/BeuEY0xjsfNamDUokI9c=
Received: from AS9PR04CA0038.eurprd04.prod.outlook.com (2603:10a6:20b:46a::20)
 by DU0PR08MB9025.eurprd08.prod.outlook.com (2603:10a6:10:471::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:00:45 +0000
Received: from AM3PEPF00009B9F.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::4) by AS9PR04CA0038.outlook.office365.com
 (2603:10a6:20b:46a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.9 via Frontend Transport; Fri, 3
 Jul 2026 16:00:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9F.mail.protection.outlook.com (10.167.16.24) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTm/5nqCUqm3u27U6R+IGLPpIcHeiamHFOfjeEWI1X1mPjLf/v5g9Gyz2OUk27UbH5zmB+vnReN4gxKJIy1cSng375zVpGztrCSOvH8Zye4idCdC7swKQvjym/h0cQhvu5xfTBRaZuEXXoWtJN2jP5PTWbruUbHvuUS2xjto7LCz1d27qgc9QsYMdAzlQRH1W2WJvW0vAfigcdbvgTwp4u2C+VRzWSSVOMNV0Y1vstkQzoiRQlCaCLsBFmeAh/bA7taIMMlcR/ZrNdLy0FLZf/DWoguguTGKSYditV7oQ94jQLjOwPJIJBl1G8+OfGSfer7J9zugnMQhlmJs2/F4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=Yhk557S1ij5QLGFSSFJ8xFFawvnBEqNltI6st8+vwEXM/vhd1yjfqn+9IGDUAb/JawD2QAultfT19aoN9iQLaA0ZshEoLij3IQmUE6FhfJci+K5J7/ieyJEw+Bb94x1uP28n9w5tknjoYzMK2GTvdMfjtoU5K/FbZbHQmPgsdnB3i9I9DPCxh+a9JiMSToHhOpWBaszPivHhZbeH5qqNbG/XpiVJd5EGEx8/9rOGkWwpg+1kUUscN0EVewbPeEkkm5bL5YcYF8LMLbIM5ffLJ9cj6Z5XnEgOOl9bV4G3zOgmR6qQ+2/XfIh4kfftoOvnWErknewzQdXEbXac0ol0vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=oKv27KgVQdr6YIK/RlLvY1Er9pktwn8bYrMh99SRTzM+poLQJsAeSIgx/FE95xgAuzSGR3QiduFkgDys4FmAPu34QuzdfUZrncleiDlPFGSfD5SdltuCA2ZLd94Kufdk86lfVni/JlK9quxVbJdtkN/BeuEY0xjsfNamDUokI9c=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:59:42 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:59:42 +0000
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
Subject: [PATCH v3 18/40] KVM: arm64: gic-v5: Add IRS IODEV support to MMIO
 handlers
Thread-Topic: [PATCH v3 18/40] KVM: arm64: gic-v5: Add IRS IODEV support to
 MMIO handlers
Thread-Index: AQHdCwT1xCf+v1zQMUewp4WRmRhDwA==
Date: Fri, 3 Jul 2026 15:59:42 +0000
Message-ID: <20260703154811.3355680-19-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AM3PEPF00009B9F:EE_|DU0PR08MB9025:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a882362-cfe0-4279-a6a3-08ded91c3dcd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Qvw8jg4AmD82hPA0CQ88trXULdne2vTHQCziLrmKex42ukSRas8KmZ5uqG5mram+QFnAg9MF6kUSX/2vHOnKXkFupbp5jWqzKRMUIMnc48v9yo7fciycsGb1yBwnkrOzGB1QixRwA292LAoOPXKUrJFsfJY+nbPaasSnfNwvUVWDqzD6AT9BLuOqMDAI+kdJ8XL+wrTzeNpN0CgoKfyD+CjQ9Ddsogwbgl1RntU5A8gboF8gbHNzKtovMdOzrEiM5eXBgk29/Tm+rtw5njDS/cpMZ3ER3jiORybHLjjmf54FVkJTQ5mW+Iuo3dKvBcRknXNd0Cg0QBNxEHeKavNgifM82fhmHwEDbCeVLtPN0Qkfi4KjQhrk7vtHnY/M9fw5eTX94PjYac0wPc1j/fl6Zv18Yku/lq7ICqEW2BHsIKAuj0VXSxUertl36WSjvW0KOmi1TllnTJEnpma7807FGOQUEBJnGOOgoZGSFjZ9KKPo3JQQpOZ/1PanEJo0KPN0jxzOuAK6bWLRCtbW93SkbVcZMHUPZzoBjVhvigZmd/31gbTnvbpD3FjTE3Xvdy4JRvYBXNeBb2TBKGRFirrtmNs/p9rQLuImzZuZAA00/mPFSQ8ddKM3dm6wgRpmdNi2vIk0yyolM4QHcHFbjnh8sqIaEediQmGgOAwBhRLbrAdB1q/mq+lU7pH0vB920lqQNR5qoIOR7zyJW0i1jeen+2bKIjnlQmJu6JVvq4tmM1s=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TeK7aVkP3YAqv/MKrHX3QBcxJyqAF2Ds+un0nOw7icQXJ5JgEbhNZF9SHqFaOz50//unLz9d2GD5a6fYH+Ur8Ep00cq50lbPcyMYAP+eoHf7NtWY9wKOWlPolmV6uzs7YtwnxLut1VaBEbcOMGK4FHmQA82FgcvQGp8kMjjfdXAlBfieaY5IZggmPdWct7nTjCmO/lsVufklBwztKNXGuKLxnm+SEe6rPigfOTnHEt18ldMrHAJ1u55ZtRK+NfH6VcSNY9VLFq39LgOcf+Am9dX7U7Wh6F//EBjgablkWjvirl/PA5uoVz4Qer1ePTFaEf3C+u961LEld8pSm3FH0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	00314a88-ee4b-405d-7183-08ded91c1855
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|35042699022|14060799003|376014|1800799024|23010399003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zRzqebu3PX8IU1KQ61xQtm2+dpuSyRJYOvsmTkW7/7hnm3tuN0VnvOvMyXxKj6MA7C8LO0Q2ZwPgGwrJEgPe1uuqeen6G/IDGn6QiTysZxBzpG1zZBfS75fO02PFtA65j5PgDjP7E/p/iQR/XRaPBovmHZxYYPiIFPx0wLjKp+YmjNIV6NiOaio08PT0gSJ6dic0rbvOK36lR8FjtZG5bRVEfBjTZz/4OenjUpsE2z2GY7UUSVFNt7xYBuyk7+gQ/n0ubqx/OynOnq3LwlCE1tpFnlNmVwfx5bKDWtCdcWmu+K3nsbIemiC8orLUqFrbjpc1tr9JGF2f4lRguIWedcVOEzeekPhrON20YF1doeGGDEHx1sfcINEQv+bNzqkSYxXOzbWPfyRlqAv7REwF8K9jwSPnNEhDkUOUz1DVLHw3wYFIy+247uM1LL23xRdMPXW05VDJA1Txxo9FGdJ2fAziUn+dXYyIF5H4oabHTzW5u2id1CFLd3p1xP7ntc5dWakSdrBwoqQ2OLqqE3FtD08iHi8jx5DDdrzjzfnygir3xDIzR64Tb0xW0W3sdqrtYBefnUV8GUWrO7q20l5aQZzDpwxFi1fxke5ibTEcMZcLu9Z0S3zrY5OxXt3hyBPvMdMWZ/RLLrp+LiFOHM4cumJLaHkNFKai1fjQYpnRaEWTt5KucVkYnJiV+vwyjkTxs5ckVtSFQAJF506Rb4cSfw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(35042699022)(14060799003)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	izIKB+59wSY0QfOpOoKZCQpUgH1ddCqJZa0Qd87spyHgdcZOOCLhOzT7e6RcWJId686ohdYa9O8zduQvmQPod6yJt1rK+kvhPA+653rOMNlN1qcexnkRRan6FCB5rXk30W0ooIoGDBiT08fPlQyMNM5VF6tKINd2U51Cbk7mn//VTGBEYwZyYbexmRnIhnoGAi0Lhwga8aY0FccbVBKYncC2DkRmsTFSyXGUArrKWCCtr6a3yPty+lyt9oNGH1Ax1FUcm/IYekX27ZlGfFe/Y1myOc1svAsyel9m0oAAMtd9qrO9VdyugdqqHtf7ck5FtoBIsKktEodNTnRfFRAwMGDclY5dq/GUcLbJ4lyfHweFKgmcmDQuSjDpgWaoDzb3DAfRRu3e/u7yRRnu9zR3EDdiu279rW7g662cL/LvULOa4vzCCFTrOknXLgNiVCo8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:00:45.1384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a882362-cfe0-4279-a6a3-08ded91c3dcd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9025

In order to support proper VMs (that support more than just PPIs) for
GICv5, it is important to emulate the GICv5 IRS too. The IRS includes
an MMIO interface which is used to interact with and configure the
IRS.

As part of providing the emulated IRS MMIO interface in KVM, extend
enum iodev_type to include a GICv5 IRS device, and extend the MMIO
code to handle reads and writes to that type of IO device. This will
allow the creation of a GICv5 IRS IO Device in KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 ++
 include/kvm/arm_vgic.h          | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index 74d76dec97304..fddb9da0403d5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1065,6 +1065,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, =
struct kvm_io_device *dev,
 	case IODEV_ITS:
 		data =3D region->its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
+	case IODEV_GICV5_IRS:
+		data =3D region->read(vcpu, addr, len);
+		break;
 	}
=20
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -1095,6 +1098,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu,=
 struct kvm_io_device *dev,
 	case IODEV_ITS:
 		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
+	case IODEV_GICV5_IRS:
+		region->write(vcpu, addr, len, data);
+		break;
 	}
=20
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmi=
o.h
index 50dc80220b0f3..38ed730d68ac3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -217,6 +217,8 @@ unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_de=
vice *dev);
=20
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
=20
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev);
+
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 25368c5cda5df..4d930a2651213 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -323,7 +323,8 @@ enum iodev_type {
 	IODEV_CPUIF,
 	IODEV_DIST,
 	IODEV_REDIST,
-	IODEV_ITS
+	IODEV_ITS,
+	IODEV_GICV5_IRS
 };
=20
 struct vgic_io_device {
--=20
2.34.1
