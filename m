Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF613E8C53
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935527; cv=fail; b=p69DW+N3NpfJ46oK+ysRNJ3aKeU/6fnsgevRpVsJEKCEMiojbqYf8DTBf6IDy47jDQxzPvU9cUDCD4WmKz5T6vwxsecQ2QgJ36A/4u1PtNRdmL33sLOyK+OdIfgk9QJVD03PYGk+xtZoT89kDbQwO+4k4bl1dLrrImdzD0BWBgs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935527; c=relaxed/simple;
	bh=2TQSy+Pq+el1Vwg1ovrwx0zS5/qwPtF1wQ3+wB5WfPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cxJb2AOPaunF/Kn/f4cyggQaewLyOsdh+TVJkFOtNGDz4VXocGl3QTj7qatYYlXuG1+t1A2B30h2H1A9fNk3uumxTdqVUUEZuWAqhGXkGswGqalwqwvWhI26FnlMTQtu+CwfKiXV0MfPxXFWJGs9b1Kiz5e1mkEw9kj+HUSaZf8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m88lVb7x; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m88lVb7x; arc=fail smtp.client-ip=52.101.69.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m88lVb7x";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m88lVb7x"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=icqu1qyg+guujAhsM0nEyXrF/oJ8m4s/nJMIp7YA29+RFUlJAFyz/zyqvN1FuiSrOW20quTsVapLntGu/qh3a3mt5HNji3s4GIy4IbfJRfQnh23VmdWSIAx5LVUUHLtatl1/eJeafMwqt3X7J+g5TtV0x2PleLaQxsbo0n3/KdwIr2WPZ47GsAYES7v+47KoZNc5KS7g5JCIwwDiF9hZP1UvjC+cZwcZhOVljKyF0/wUZ3KsBIMoldienvnDKjGj1r/bNWKKzsz7XOiXU0cfX6dZFUAZSv9orUum2MnvV1CFGKzuC2WzRfLua0w4Dd0syznuGx8mmgYuqAgdOu5iUw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTiuYlqhelssRwJGClS9Q5bzffVpDS+3ciQ8Sy7itGo=;
 b=RWdVRJmZodIACy0Qp9qAfQw8Gm7x25qt1NBRfqGOqQSLewmnyCZE7aoC0XRcd5htqr6kD694Htoa2uhCyZ2VsyJ8W//HxN/3W2K/dGHF+AfJU06S7BiLMRnvf/0jWFB77+lRGc68QndS3xS/cnwN1vuD0lDvs/tqYjnmID+CeyM70vkfr3B2mrnEXPpzsE1tuG6ZiG4G4A9zbk4fLO0cr56XGIbSnQ8g990UunBTKd4LeIvWXZojIJ8PBDp0opSJ0ACO2SwvBDftzHbcfANlm1q+UT7SS2cxcH3n9qeyLQZzmumvHXlLDpvxL/6hFl3C6fcsZpQ5sJq7PP1XNQ/bYQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTiuYlqhelssRwJGClS9Q5bzffVpDS+3ciQ8Sy7itGo=;
 b=m88lVb7xpRT+mUiHartu6+tWyMEXTecYonVx7JjO2cfMFx1MN7ENpDsjLuV5r6ZczwaPelO3naGRZHrSqQI3cOCYcwi3mxKDR7FK8iJoEAQLcoHJS/v0Cni/i6svHkWqAFtK38JIDv9Lrh38jtocOcLDTVH5NUVXP/5N5hN0kaw=
Received: from AS4PR10CA0014.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::18)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:49 +0000
Received: from AM4PEPF00027A5F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::59) by AS4PR10CA0014.outlook.office365.com
 (2603:10a6:20b:5dc::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5F.mail.protection.outlook.com (10.167.16.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNY1RERweJR4ArX27ZV5+b2FATWo014YpwH4mg+hSjJiSLQgJao3wshNSXtp5swiG6sjeo2QYCRoqMPPR0+zZylf3dY4MZ2vJiwLTxMw304V1MR9De2iymObjywSxaI5aSeq9WFhZga2M334Wfua5OcsRo0kihS3R96YwBQte6B7+jJx+V/YoqOu3RDPFbYBFwsY/OCTHLl6V6sF3P9uOpCFOhGeBFXDinm1uHM64mKPSksJr/4Rv3QpDMNowetym+tIgCA+EHlgJy3NIenwPsEmm3sGy4R+QlFK+5XwAAl8hEs05/lIkBlS/8GBbON+gGBi88yv0T1XxurJw86sMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTiuYlqhelssRwJGClS9Q5bzffVpDS+3ciQ8Sy7itGo=;
 b=JRHzng6EFxWNL1CqgbyVrrM7K6NwsFPcj1TI+HCxLh6zLogr1polpUiFpFxvEcmURbeBXfodnAkaPqQJlSBSI4gE2ML/TEC3PmyyeUVMIz0EJs4HX6lhVIfbR58MxxD9U5KBbMjNnOJj2ITChFwLtoHnMSndw++1NtJb5Ld8cVeitCr1c8969PaG6Q2Z9aQtS+q7QU1zuDecZiA/FLD0JaKfKzYpx0xmRwlqspCA5gzaiAXCHwta2nX7n6QLbB54Ms4Nu0h/dyysupgD2i2FhyIVjNHoWwIPylUb2HbD37OqETPbG6IGoq7ykR9N8CalrIr/ysrIeGMi4IFslEcZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTiuYlqhelssRwJGClS9Q5bzffVpDS+3ciQ8Sy7itGo=;
 b=m88lVb7xpRT+mUiHartu6+tWyMEXTecYonVx7JjO2cfMFx1MN7ENpDsjLuV5r6ZczwaPelO3naGRZHrSqQI3cOCYcwi3mxKDR7FK8iJoEAQLcoHJS/v0Cni/i6svHkWqAFtK38JIDv9Lrh38jtocOcLDTVH5NUVXP/5N5hN0kaw=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:50:45 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:50:45 +0000
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
Subject: [PATCH v7 04/41] KVM: arm64: Init vcpu prior to the timers and PMU
Thread-Topic: [PATCH v7 04/41] KVM: arm64: Init vcpu prior to the timers and
 PMU
Thread-Index: AQHct7gmbjlPYeaZeUiWVObYmik/BA==
Date: Thu, 19 Mar 2026 15:50:45 +0000
Message-ID: <20260319154937.3619520-5-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|AM4PEPF00027A5F:EE_|AS8PR08MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 462b0346-d633-4a6e-35e6-08de85cf6df8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 6/3BYjEPODIDALm4zyskaH9lBgwYWlicEkwPzygQbWGJbUq7y9DKcMA91IA1+V8zSSLe5mWB4/0m1LcGi9k/I83Jgo9XrpwwLX18EUpkU8HLDgYcP6d7Zx00OtgdU2PzLmOHMIVJuahUo/QE8fpRO95GU9vY4OZqZnzj7yoAafjQx3RjCSJtj8N44j6v1SNFNXToF8aYJTrL23dBSDSZtgrcEpkWQaVaF0UkqUjx9eZWXsH6iF2VIr/w+rlyW0lLRZeGsupNYkBXXaKze0H55CEahdCmmtjQbnjprTK8+12FXWbyhdPeYbKll3rUoZTZ5H6IaAcEvSMUCcB7NPCgk0N7nUuqqTYjN9SRLEF7eOx5DWJplypwOuaQ/hBDjI5ihvNfNaegeLgWrg6HTgNlIRFrgmbOsddno2zbVvy5VKt83QWeIWhYKKHSru9NAAaz+xOKniwJi2wJN52VhcXexK/153r6HlvcHYY1T5gkDkRdvO2IRUySUrddRo1DWNePQNtPLqh04ff/7ld6LikqfhlN4sFojwMNF7tk7ATfZtxB36aLlLbPvCPOTEPqWto75xkGTpJxF+2gndgb4PuByHLWzCBOD5stgtIaHkdiZA0lx4uMLEusXjgeLh+lGb1g6JtjbWkVpYHZZV09AsYfOQNR/sb9Ez5naXtxqyZdet33f4Yj0yPi+kBNW4ex3/E50mAIEysDVBADS9lUt5E6aJt/syA6FdRZ2CXDxqI6q8p5d+IOdUKEYVnRTE1l10GGw6NIJ4wc6CFv11VDylMMAigI5fIWiwGrthdqEh3CAHo=
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
 wXEE2Zs78bnxCWRDobn+o8aEvV+DUm2kw9aLTPbKujJt//PZkw1ZJ88baSMQ7R0NPXDQr+3MyKx1thArUP5dYufVYG5IMUnHdajmc+PtKMe1J02GYhLDCmN/JPnXUBwLTDWAoSNt9+NI5dvxw3wzT2DvTY8+Bld5Uxm66ZcbvijkkVV33h4TmrFjSrmUNNOauLILIwzFkHecZR/3he8xsKFnbDvrzZkgkkFsaO/BrBUjMo6GAxQFYYolEvRu5IFQKzO6td/ONwEglRzBOCmFqSzJnUClJBXxO+F7r0k5jWqKIZYj3vytVGHhW5fZshhX8TrB+E3I86i3i4l8+XhW6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a2ec544a-8d33-452e-0207-08de85cf48b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UEhEFMoak9/Ui7xadAPnUOjCWmcnijsLMXstp42fktGmh8BzRWnxCNzbCmnWT0UwnbCvXbqxgy4skZ1+v+Xe6C6BwsiMzbWq5T9tUlQWA3DSuY3igkt/oKQO8KyC9A4xs4UgMvcsfx77ci1HWyqRpcDUqSj9haX2AJFqA6fitmCVEgWw+MXVc4xzF2/EZWaP0B1gesfKkfOlg6cDoBhfI6Vfu0RnmCwJvvdrwyJ08EDBliPgjNOIoyMi2e406DftgaZ/PXTERJOi9lUnj+ZnJr9owe/XaITgcRhEn1lXG+7EiPk0wyXQcTy6ApsPNFUWa95FEJmsfHME5skpPHmtS+Msv1a8cLhoDVhMKg46FAHPdxyfmXKOwfBr4VIQoxgCzAv2JVxRzbpIvu7Y986AlgBRT37tOvqrtoQek9oaLkEXYVg+byBE9E8iK7LahZqWM8GO0JSUBtwxNtFnErc2f94OVqcolo7yW9q/7NqWA6JqxrfT/dGCIB2pTa2TGtwKPb87Yg4ec9ykEfNXwaofwxjNqj6Cs7PtYNizVjtMFp4ahC4HjvJs46S/7fDpr9CoJp0f3+VviqFuZ8AurstOcAG8fPDftko40xZj4K9joEsw+d936kGj4/Ly34XovFGhFe4IyNZlfcdu+oTVhZogex8auv5EhsTTxYQHYMSIcAA46I/9Hr5quQM9UQUGEAPbvH0c+EQs3W8+cynBAfYN18dJI/S7I9hOf5K+1T0nMpHrx2cFb4OZ/M5N3qbZtGJn
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xnAYDj/ljYJq9534Ybm1d9++z7cFQHA8Q4JqjbpDd7L/DS7smuuTy5/nXkpLTKyHEsp6fbVL6IsCzWBZlNAXPXK620ekCkgrXW94N4HrYfvXJIMvO4sIIXRmrJFjq2UQ8xpQmDbOaOU/gBHlfQA+z5GEGk1xo6JgvwG4zsArBpjkYHhVsif4meCdfJywmyLAx6qge3alRaY0KAy027jTUsfXxTDqqt0SEaUQeg7D7KkgF/cLD8f5yo/qeMANQE8p8H1vPJ3MQCLX41/OwMnJA6Na7G/+pDnPzTWueUvOA8PKUX+wYlyZTLgRhGflyc/jOaC+lpNkprCHWxZgv58ARVcOGx71cbbL2t4WM3EORicX5djTJBoOAQ5Cr6acdR0W8WnVlGzK26pMB7VNS3TMXmSIHUcfGpEVpuS1Uth1v6apd0WXljhLYZFO3aamRm2M
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:51:48.1894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 462b0346-d633-4a6e-35e6-08de85cf6df8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308

In kvm_arch_vcpu_create() the vcpus, timers, pmu are
initialised. Prior to this change, the timer and PMU initialisation
was happening before the vcpu initialisation. This causes a bit of an
issue as it means that private irqs are yet to be initialised at that
stage. This means that any operations (mapping, setting irq_ops, etc)
on private irqs are not possible in the timer and PMU init code.

In order to address this, re-order the initialisation to initialise
the vcpu prior to the timers and PMU. This ensures that the private
IRQs have been initialised at the stage where the timer and PMUs are.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73a..4e46336798946 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -523,15 +523,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
=20
 	vcpu->arch.mmu_page_cache.gfp_zero =3D __GFP_ZERO;
=20
-	/* Set up the timer */
-	kvm_timer_vcpu_init(vcpu);
-
-	kvm_pmu_vcpu_init(vcpu);
-
-	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
-
-	vcpu->arch.hw_mmu =3D &vcpu->kvm->arch.mmu;
-
 	/*
 	 * This vCPU may have been created after mpidr_data was initialized.
 	 * Throw out the pre-computed mappings if that is the case which forces
@@ -543,6 +534,15 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
=20
+	/* Set up the timer */
+	kvm_timer_vcpu_init(vcpu);
+
+	kvm_pmu_vcpu_init(vcpu);
+
+	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
+
+	vcpu->arch.hw_mmu =3D &vcpu->kvm->arch.mmu;
+
 	err =3D kvm_share_hyp(vcpu, vcpu + 1);
 	if (err)
 		kvm_vgic_vcpu_destroy(vcpu);
--=20
2.34.1
