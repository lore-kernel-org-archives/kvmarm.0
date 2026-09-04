Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011051.outbound.protection.outlook.com [52.101.70.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1310E4766A9
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521704; cv=fail; b=V02P6bhG9PMDyktdSTwITCMxFAlbXAvndErXlV0Lp6ZZsVClANSjsne6p6RAdRlhZ9mVfAJewS80dBOWKjuVy3AWWZzc6s/MuRlWwP/Qa/QwylGYuQU290k/VqZClNn0844TAB7vDGaAwRx4oKnq2ecQ3pxdkpnJgEstdbaprEg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521704; c=relaxed/simple;
	bh=OvhIS2zgdXvPvC4OmDqHg+FSwAw4RTV9UJI+zu3AyuY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dtTJCms7TER+mF+iuxufrXWBMis8XDIm+LbLcl3PfFHb5AdDKNm7ZLroGqHtA8DzUraoU+XCrAlAmILpJEXNSanXFnWXimfjAzWFzts5C3T2dobAbWJ3hVTdhPgl1h6GmOFvMnDmNi77KczrhkPuc9nCQn7ieNASfaidIh+TJus=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pVWqv/j0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pVWqv/j0; arc=fail smtp.client-ip=52.101.70.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pVWqv/j0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pVWqv/j0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pQ2tLmRmgxrAROEUEFIqD1MTQSlM819qcRTHOGa0mGIy4Om6HqInn8jUInzy9g0GG0DTTygV5594Y312kkSeiriqvwwJKNoaV0CjF2hg0VjrVBTWBe2QAgGuMC6AyL1t0HSPJV9x5TIgrfeuRl0Ihv/lsWGxDcTO0J3rU3OeCelcYGfg3lnx3QmAWEI4wktU45cQTYNnybU36c+SmOo5Pt8k5hlkqP+oyNWXvL5AqhPbIJcY8CKNbfTI4PUxkL+rer/VhPrJabdgDozj74z7m6FePvyoIWg10GEQo9dxNmP0qDnWJH3qxe0wG9UWAMf23i3SJJaULpp1Ll1lUJYcvg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fx62shX4flJ0ThszJ5RFpUr7o7/42kDdE0ed31W3SJ4=;
 b=EL1ZFDrUFfPpXCflZPsdzH6nRdQQNXJdjaahiSPhMEcxA+ngBsEF+FMpVmzPWRwof2pjUlE+Ob56N89TTURBWDJ8ROf/OSNuKEZaeF1lEw9DMZMonTGqo22wl+Xxx3cJLd4vQrQks38O/8GrDUrMcLvDfY8dkcp9jmq+sQHbZKYNrsyJ2zH1umO2F7f0U5UMpvY2lmbQti2/MXkv1wrKvMy38zq/BkXqXMgMQZLr8B78EU1eo6XgnZY/+fVISssflvjqc/4HrsNcPhAWWZqQEl5eZhe+avCVAl8YnEsI8X+9j0i7jhr47yEdL5Tjrt5U7svNnkazruQk0tgSp/4Cbw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx62shX4flJ0ThszJ5RFpUr7o7/42kDdE0ed31W3SJ4=;
 b=pVWqv/j0YPKi5W9nT4oGALQ+qUHZ+dlb3cG0rDtFXs7t+5ngsZ0r7oHJDmLOdiSfyeUPV8jYjDFZKB5UK3FoPXbejc1hoOTGiZ5LAdOyCyJ7j1VsS8lqLlQ+34ncJOLh67GrCb3EsREtnKdfuTgeXCLRToGHLsNtyKceTIr8PYI=
Received: from AS4P189CA0049.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::27)
 by AMBPR08MB11617.eurprd08.prod.outlook.com (2603:10a6:20b:736::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:34:54 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:20b:659:cafe::1) by AS4P189CA0049.outlook.office365.com
 (2603:10a6:20b:659::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:34:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwSlx86OY4nvZ1HB2BPZt6Eihl1yqOHKj0MdATmooszMLKtKs0U3dOe7aYs3f8ItwAAlW1ln3OkCG8phMHVeIUeHEsf3Jy+lzagdhhF8PiqmJ/f+bm4XDjeXUl+3hqnLRyo0CInXB6s9XuMlCNMsBfqvpNG5t0mfw6Ky9Aa36WEiTWt5XV7/LyQ+JZZzRDwTwSOC+h8xNs3waFnFn0jArlKSM3gL9UlLtlLCXVP3OwhrpAD6tbLkxtaIMQiNHRY5KcbSaHiCq7/VHrmmUUf1/aV3jNiYeHhhQl5fofAhBj2iDExGWV9z6uO0slnCGHAuSPYplRFt5tJTb9hkeAtimg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fx62shX4flJ0ThszJ5RFpUr7o7/42kDdE0ed31W3SJ4=;
 b=FIJZPpr7HOfnciGigNURSbQd5ot9vyAABItRVdO4xISZQpAEJf9eV/umdOB1xZ3kl9cUUl3n6RTa1CpSimEfIdbzO4jok49zCEJVXKZMpE0k4V8iTRscElPCFOc7UepEH6f7tVHH9qDogOIq6TteiRmrU/NmQqIqEW2zWRVX3GSrOF4Nx8OqEBIo6xJ1z/x8jtK7qC8WhQaE8aD4ZNh0xi0B985Q3M/az7ijAOgqwLBimb9GcLHYwBnUEkbTRMwAX/bnEFthNphmrYeq10Wb6tpYoorLSUTDPfk/SeEv+JQVsp5BiaoppBWg6t/lkn74bYhFbRE6wKmAGevsRAu3Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx62shX4flJ0ThszJ5RFpUr7o7/42kDdE0ed31W3SJ4=;
 b=pVWqv/j0YPKi5W9nT4oGALQ+qUHZ+dlb3cG0rDtFXs7t+5ngsZ0r7oHJDmLOdiSfyeUPV8jYjDFZKB5UK3FoPXbejc1hoOTGiZ5LAdOyCyJ7j1VsS8lqLlQ+34ncJOLh67GrCb3EsREtnKdfuTgeXCLRToGHLsNtyKceTIr8PYI=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:34:17 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:34:16 +0000
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
Subject: [PATCH v6 00/49] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH v6 00/49] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHdPGFRXpcORpRmUk6qKcjWZdUKqw==
Date: Fri, 4 Sep 2026 11:34:16 +0000
Message-ID: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|AMS0EPF00000197:EE_|AMBPR08MB11617:EE_
X-MS-Office365-Filtering-Correlation-Id: 60388ccd-ecaa-4942-1208-08df0a788a1c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|11063799006|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 mbNg3kUkEelf5aQVRmc7H3nQOeWOaG2IxFEOcFq66A6k4Giql3bOWWuNki/FjFdoMxovZOdAdz0wsUpTJLaOficxmBi3dmTu3O2kWbPPuAPLq0nUR0EnLNDdh9dJbTgtOmNqoGAY3QZaiE5NaIVTIMyKl2zFFMjiS+bq4K38BXmSp1aQMCjiQ/CbDTlVFHOr4FirhaH2hfcUTg7tIFMD9H1/7hzQKmHv9/rEhZzskWDfADtODXEA+CU4/U8Lc5b9h+9+itKUSS7+8FODe8y65F+wLH4sfelcHEsdk6L9GyJZJqjE3MXBn+uTg2dYBfs+TsSQP07wSuAiHhtjqLeAjHIhpZJL6GFt9Am4ZtXtz0LO594IEtODc7d2jLHPWF27DkY4F5WAUcraV3WOt/w5CVVmzQhjaWWjBT3J6yoqpCsvyBQyru3hN5MdP0KGQ9cWJejJ3y4I5LmPLMxfax7qjhrW/OO3ZFzRzvDyue0xB8MF86cEgT16wCa+t5uKt7aP7uNkGZa5WbPKr9ALplbX+EvARliaxRrhAO4NhESkPlTbz6ug4yxpIyal9Eoyp5c3b55tYr1G/8volA9RMAkz6irOXbdfFRc0tsHke8HPV4a/MXAhxj4YhK6KQoNyep9H+67WbBUOq/BetSOFLiBb3BwX35LuNlU+HEdGmG+qDf2JNIrV7AjLUaLJrrbQANml5DcRdmQSkXjXMnbR72A8Ei6NUD8gnxo8kRzKZxLy568=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(11063799006)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 j1MBYLoeBSgwa11RnxJMJXemDeW8YGYDiyoI49Kd/2RWuHfOgJoKakZggbT6mcVaZ9ZKo648CxZ2cRQZqB4A6PJ7yb9CBhxUplR950msWz+nrW32yuwYRelpN56dHwztXQAPn3WITWCD2HkV8UaTaHqVFvmdcFJVKLLFcLSUXc4VDUUYSXRhgA7C3anpLFBOXQqOzV4zhvckPMpsKpyMOj7jNGuztt3UF2CgdxIfVH1467xUpuvJkZIdi4em44Mfjpe70t5crfG+DW0LSMhoIId9tgovXn8AGjTXAwnb0mkmwt7J6aKh5Uu/inFHTiQ60ZScRFsYgQAKIXsfNQQgdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f5b63002-c08d-4870-3121-08df0a7873b8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|14060799003|23010399003|35042699022|376014|10067099003|6133799003|11063799006|56012099006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	GrLYaeIGcJWjBbUdJrObHkTDA/4ch7ckd72Wi/Wn0loe4WNfBGAaMbKof6dczi/KsA+zG2hZv2AIPdkGx9mFaXi+nQMc26relFWPKMbSblJykYbQogyJEUlfHYCJc07+XHs+6ipqCUc62QfolXbF9+8tn61a0XGO7n9a2Nnt3/BlFTusdErs7ei1vHEEZf4fGgsw169GZtRphKmf+4T8libp0SnhTBLkJcmH5sltwSAAeRVuKvSZZzbVZc3iaR+RINWu9q/yfdFClWGw6wj/+rebxLmQFEBSuuzgdys4BYBVyFbRqqmKFxkQCjpkDpZV77QFus8ItNoMSZlxXkpMADHa4uEyG02ZC3AoHLduju5WOEC5947GLb7TtVNMOq0fkGBOVR63jOt96t1wjEqAn2Rhpq1/n8zLkVXcrKrHgnDfK53urkwnrVQBaZBWX+fKlWtRlAzV2qxKn7s74jvdQJnta3i35OAr3zEw0YGMlijGAmsr9lSBZXQ8aqWzbzSGNpbORfCXYiFCE91a3MFzAiJ+PslS2gH7IEnSCp9bJeDWX6sNlxcQTyiZcEb0BpAJk7It4bWEnH4IddDI1wKJIBRjyCIiD94UgrOGtYf3NpaXINf/r3Trim/73glX+PTDO0YAkhM3lePNwPXrUsEY5oserJISFQ3R5OdSE9ormvc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(14060799003)(23010399003)(35042699022)(376014)(10067099003)(6133799003)(11063799006)(56012099006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ko42Wnl0ENzfjjp77Mv0+zKVYRtxKJLz+vtjOZKMc9N8cGYdiWFLZQXc8e/7llfzWipOlM0pulU8lfdmyMWy6ApSRUo3cRNjbu7+eziwuw4ARXxziIT96Z/EdNbWPdcOJERPUmXQ9Nd/oEcS+vRl9qANVOARP9UBKj+YWRh2WNwoMpGZDilblgIYy+wr4okZlsW43m/CzEQzddpxMEPruAKKU8qO4tDTiuzpfmZJVvP6Dm4jafvisuAx3Eu0+axDGsFYzYLjQzzT2ZBXOw3GRvGEGEjDp2FNUSmTA88xnC6rVKWJpzFkd2aaX8NQiXRq29rBtOOJJKJ/T/0ikDIldeQb8f9kAZrtvLppkjYj27go7pRvrw9zqr4zuk4PgKFnet958h+YpWldyGFljj3RYuk29tkO7fo1AY7s7cLZUEZPamhWWmSZk6z170Wt2kDX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:34:53.8202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60388ccd-ecaa-4942-1208-08df0a788a1c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11617

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can make
use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described in
Lorenzo's GICv5 Linux software enablement guide [4]. In addition, GICv5
IPIs are typically implemented as LPIs, so LPI support is what makes
guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is not
included here.

The IRS is created as part of the vgic-v5 device, and is not a separate
KVM device. This is because implementing the CPU interface alone would
limit a guest to a single vCPU and PPIs only. Hence, the IRS is bundled
into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE residency,
and VPE doorbells. It also adds an emulated IRS MMIO interface for the
guest, together with the UAPI needed for userspace to configure the IRS
address and to save/restore the IRS and IST state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and host-backed guest IST storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, and SWERR are not supported and are
  RAZ/WI.

* SPI injection support using GIC VDPEND. Once injected, the GICv5
  hardware manages the SPI lifecycle.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs. SPI and LPI IST state is transferred through
  userspace-owned buffers using KVM_DEV_ARM_VGIC_GRP_IST.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

* Selftests for the UAPI components, the PPI, SPI, and LPI support, and
  save/restore.

This series keeps SPI, LPI, and save/restore support together
intentionally. SPI and LPI support are needed to run realistic guests,
while the save/restore interface is included at the same time so that the
new userspace ABI is complete from the point it is exposed: userspace
should not be able to create VGICv5 state that it cannot also migrate.

The IST migration selftest restores state into a separate VM, re-saves
the SPI and LPI IST images before the destination runs, and compares
them byte-for-byte with the source images. It also validates restored IRS
MMIO state through SPI/LPI delivery, priority, enable, and affinity
behaviour.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, MSI support, or GICv5
ITS emulation. KVM_IRQFD_FLAG_RESAMPLE is also not supported, as the
state of in-flight SPIs is fully tracked in hardware.

These changes are based on v7.3-rc1. I've pushed the full set of changes
to a branch at [6].

Changes since v5 [7]:

* Rebased onto v7.3-rc1 and addressed the Sashiko reports for v5.

* Hardened IRS command and teardown failure handling. VIST assignment
  timeouts now retain potentially hardware-owned memory and mark the VM
  dead, while teardown stops if the VPE table cannot be cleared.

* Generalised model-specific vCPU ID validation across VGIC models,
  covering both the GICv2 ID limit and the GICv5 VPE ID limit regardless
  of vCPU creation order.

* Added support for architecturally permitted 32-bit accesses to 64-bit
  IRS registers, including correct merging of partial IRS_IST_BASER
  writes.

* Tightened LPI IST restore ordering. Restoring IRS_IST_BASER.Valid now
  prevents the guest from running until userspace has restored the host
  LPI IST, and IST snapshots are completed before checking quiescence.

* Made doorbell affinity updates best-effort and tightened resource
  cleanup when ACPI discovery or default IRQ routing setup fails.

* Expanded the selftests to cover symmetric IST descriptor validation,
  preserve unrelated IRS ID register fields during invalid-state tests,
  and avoid assumptions about the host VPE ID width.

I shall be out of office from 9 September until 4 October, so my
responses will be delayed during this period.

Thanks for taking the time to look at these changes!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_=
v6
[7] https://lore.kernel.org/all/20260807111159.429128-1-sascha.bischoff@arm=
.com/

Sascha Bischoff (49):
  irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
  irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
  irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  arm64/sysreg: Add GICv5 GIC VDPEND encoding
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Cache host IRS ID registers
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create and manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: vgic: Enforce model-specific vCPU limits
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Initialise per-VM IRS state
  KVM: arm64: gic-v5: Register the IRS IODEV
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Add GIC VDPEND hyp call
  KVM: arm64: gic: Introduce set_pending_state() to irq_ops
  KVM: arm64: gic-v5: Support SPI injection
  Documentation: KVM: Extend VGICv5 device attribute docs
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vCPU PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
  KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences
  KVM: selftests: Add VGICv5 IRS address attribute tests
  KVM: selftests: Add VGICv5 NR_IRQS attribute tests
  KVM: selftests: Add VGICv5 IRS_REGS attribute tests
  KVM: selftests: Add VGICv5 IST attribute tests
  KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
  KVM: selftests: Add VGICv5 CPU sysreg attribute tests
  KVM: selftests: Add VGICv5 SPI injection tests
  KVM: selftests: Add VGICv5 LPI delivery tests
  KVM: selftests: Add VGICv5 IST save/restore coverage
  KVM: selftests: Add VGICv5 sparse vCPU IDs test

 Documentation/virt/kvm/api.rst                |    3 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  271 ++-
 arch/arm64/include/asm/kvm_asm.h              |    3 +
 arch/arm64/include/asm/kvm_host.h             |    1 +
 arch/arm64/include/asm/kvm_hyp.h              |    3 +
 arch/arm64/include/asm/sysreg.h               |   13 +-
 arch/arm64/include/uapi/asm/kvm.h             |   15 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |   10 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   35 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   45 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |  154 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   18 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1217 +++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  270 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1875 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  140 ++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1154 +++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   39 +-
 arch/arm64/kvm/vgic/vgic.h                    |   21 +
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
 drivers/irqchip/irq-gic-v5.c                  |  111 +-
 include/kvm/arm_vgic.h                        |  213 +-
 include/linux/irqchip/arm-gic-v5.h            |  256 ++-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   15 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 1935 ++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  105 +
 33 files changed, 8280 insertions(+), 206 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1=
