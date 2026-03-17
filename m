Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012011.outbound.protection.outlook.com [52.101.66.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55B3A168C
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747846; cv=fail; b=jfa50BBGyL7ryrW9m4CHkRWEFoMduqkyodfJa6FuVYzX4735b1gARL2FZmYKji55eDl1roWLeqc6w6haxwpcF35k3Z+RlWbXVCeAMLdnmjafg2oGrUJ03Z5B0DYuXmKaYxEV3VIjltHb7+Ji6z9r15HhMPOD4KAbIYc3RJe6ACE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747846; c=relaxed/simple;
	bh=wZWOVNgztsxX43mIN1aJpVk94T3jL/zFvxluOIec/d8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bkN6uPS8HFbrvn7/eknyiTBs6Ezmnp9xp20xL+Nue5RFOkbcH3s2xsYhZ0JZoINKvDxGYPoox5XVwGuW97HMlMZ8Kp6rzxxpH8xL+vgQblGmm+3Yes4fs5oKIrnqWCf7urILI5azI88+TCr3WazTpR3jhhfdRVXU2MoHemAPvnE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCYI5eHs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCYI5eHs; arc=fail smtp.client-ip=52.101.66.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCYI5eHs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCYI5eHs"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TU4NB9oLWuNHxR1LriXFOaG4cUXEsM2ET85yU40+KkEC2tX5BX62IA2GqvKySxNkYpGbhYwtlREYLE4khUNkgLE+Q7NvF0x7M1maaojcvwBzXM7kNMRDQIUktfLt9wJ6+sPVnSFPWlbIR8ARNj3Imh2gBgJyXOqMMWleu5STIPS8S+2g3O+mt+9Od6rXburd35q3ZrKLG9wr3Mt3017N+QW268co3ovHHHH0xaE7NJLp3DWYA3Jc8GXhzfj9pQfBWsRO80guhlcZK2vP/kyyPPbFlvaVRjvzcp7BUvtawGUbmS5w3qG9/xJT2YxG0pYTPhNs4w4/fILw5pOnSha2Mg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZgnaBQ+aDu4zli4QqMNuUvXZleL/LDdl5ISLxjitpw=;
 b=t2CBmUtGdiyjjxxSSDHjpW75HJGBu+5gGyNE4Qbv1FEvRqKjjW7wob2Zc2UEGLScfiA7Mf1zik8bg5O/rGi7FM1Oab4vxOT1Dx3/WtKerh9EIxp9YWsiB06Ivd+pP6VnHpgNYCHhaGLI4MQo6zRR+l/8NRKAaC3EMFbcbbZPW3kk283TndFtlIht27MsaQeDuRCdhEPlDRgdCAyPJi/rocB8aD5i9snUSYwcNQX6wF77BOtJyILXHZwkxK8cilKdj2DbSUJ0BA5deH8fJMmRZ7A5XT9oJcz+ey5bWEDLPymZusQudjORIVyIgUzBuhZIYTT8TZ1z1SvEnVLWpnqWXg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZgnaBQ+aDu4zli4QqMNuUvXZleL/LDdl5ISLxjitpw=;
 b=bCYI5eHsIoxvtFfYPKKzSwiXJNQ+cAP0JfI+NW9N1ynEFlCU0nqxwc9MYe9u5yGYwDTPbvWAy6oUdWVp3dzL0O/Cyta1t6wOxX7FYWQSXZGDncN9n+b/CBQMzCVLR3F+2GpGTpIutN1bhaKlfTTWALuxtofmDzyNr4O+GoT5eIw=
Received: from PA7P264CA0217.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:374::18)
 by DB4PR08MB9141.eurprd08.prod.outlook.com (2603:10a6:10:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:43:54 +0000
Received: from AM4PEPF00025F9B.EURPRD83.prod.outlook.com
 (2603:10a6:102:374:cafe::13) by PA7P264CA0217.outlook.office365.com
 (2603:10a6:102:374::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:43:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9B.mail.protection.outlook.com (10.167.16.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0
 via Frontend Transport; Tue, 17 Mar 2026 11:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gg/Aj9Aoj5HZTyBzFOtH/QXdCpt0wBtm16kHyB0EKVRZzsDGrqd/x1xdfetYgCQmrKCPxiJCOX5s82g9Xiedv6ADdXrdvdryXCgD6u3zWfXnAwE4DxOR4m7t+Wod9heTkwIafCT73AgyQ3MnnkW/iq7woscjzHx1oyp7OcDxe6Cy4M3wse6H5H2lIQrpiKMYQsZjeb4SqiyzfnEAy6dPzrActCNxOy6zDFCHWllPPwjJxKDuxuyJVipHujw4AUE1vc1LILwXMD0Z+/F2Vhma9n2Vr4r3QwAYU2QYYxr/GGjD1pJ6EZ78DWc+c2Y9D2P0pmiQlbtxrtOOZ13hNAvh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZgnaBQ+aDu4zli4QqMNuUvXZleL/LDdl5ISLxjitpw=;
 b=q7BdoH61g7kPJaxKXlSs5NH1D/SlfYiwNyygRIW/+3L7R3qxnySVJIkdbvOyU3rD7Asn1dH2u+EX98EjGEdWi5Y0L001U/q4lLE2IfgflO0qpJR9dK7LuzbWINxr5dkthI4jOy3yIMGJanoKpd3+U1pvEcyyrA/m39Uiie672TYDBrQmZWAqfHHZiWqHq7bQa+eKhnh9Vj0pc2m9HXjRx8ItvSGSdyOQHth/YoqIu4NHv/XCt6bqIawYNON6oqEP0gm00qrYTjMuGRYBUIeM+QFnqwFNIzkQct890w7PHiOQ5BEU0xhgq1oBOvpkK8f2f5GO65ntfdWYMIvA0tozHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZgnaBQ+aDu4zli4QqMNuUvXZleL/LDdl5ISLxjitpw=;
 b=bCYI5eHsIoxvtFfYPKKzSwiXJNQ+cAP0JfI+NW9N1ynEFlCU0nqxwc9MYe9u5yGYwDTPbvWAy6oUdWVp3dzL0O/Cyta1t6wOxX7FYWQSXZGDncN9n+b/CBQMzCVLR3F+2GpGTpIutN1bhaKlfTTWALuxtofmDzyNr4O+GoT5eIw=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:42:48 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:42:48 +0000
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
Subject: [PATCH v6 11/39] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v6 11/39] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHctgMtwLROZhoZTESMbIReHqJDAw==
Date: Tue, 17 Mar 2026 11:42:47 +0000
Message-ID: <20260317113949.2548118-12-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM4PEPF00025F9B:EE_|DB4PR08MB9141:EE_
X-MS-Office365-Filtering-Correlation-Id: 1446bee2-129a-4600-71aa-08de841a770b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 RTeM4IxE3lEMrGmWUNXg4qaISj9KadNaF6Zw0aiBOO/z+qAfsxr2L7c7kWxkmKYDaIPa/IxFuFBZbinokdPOIozIVUNfPZefTmD1vjoeAXZHl/uHweyGyL0K3DYFRpch3ObB0EBxgoLaXvd96qTPaMmrfcP7w42eZlWBrh7MSANObOpRbqRAO6IyhhY6KHlDidSd0PoY8ZRJR85nv/bMqDBAtvHlh/QwqW61XdfLK9w4oAN2iru+L5BdrQPsQyV5kBXEPt4ga7BVSIEPBqcCHNZc2jSP7wlZpQ/5ZdxejQJO2SBe/PR8o8EwmapngkuzluTK8ptDcOhKshZzLllzP1KpBG/3M4TcD5LiByGXULJEteMp8eyG6Vlibjb9FKc/cZEjLrdltMPFyNFNyFLMAo0tYb5IkNCdEMsp1Gqyh+3H780Kpsdo/04qgBR32ucYZg5R5i8Fm+7UGxdr+1q26rP2IneZwiVPDOZZlkGUS40BJXwSEgheWzQeQkJ2dykiMoE56zQFSxengGw8tiGBPRDQAKo1iUCCLd31He/1fZPfcAKf6/qPAcTgfXkoIqCMUqZrl0glq6HvvEtHuzeW9nMGnPAuRUq4qn3nDQncHg/GEBF4xZNH/LSw1PRD6089yZre9eqJlN7UmFA1zlpCFaYthBEK7s/x4C/9u3q1Mb7SFxEBZnzcYjxUUTS3a95v6AGBrcJF+p70IafKmUEqC9XlVxjBPFI0owsf9cba6pk3kZkAoKJcU7emK9k8wX9YTQN0A/q065pr675eDnWydEwbsztsIPoVoSPu+vbwn9E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 l1QJG+u2WNmTFq3BBJbvLobgrwq7OBaoDfgmz+e0d4Rl/pmh5WMLYFC8NMrr60c6Lb0Gry6yhCsoqtsa4XP7b9cceVUieXUWIcxhxkxmZWMivL+MPkIszDqiUfZvBsmUhkv+10UuNo5RNVBs8RxBqugVkHs65f5DIHl6omc8iOJoJXst37HKxKrSX62JQTq8Q+TXVOzRk86eUsg8lVJUq1Se1CSLhY07iQymHHSAVTUuuVv1Oh9Qm19pAz/v7FDm7GfpCE0l7kofWhb0P7eS7X92UhQfTugY8ehEPv99Ef5Ouh9aGlzCwKoU3UKc+smZR15ZP6eLZZ93qryEDd5iSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	254c51df-a03d-4041-1acb-08de841a500c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|82310400026|1800799024|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JcSmU0fe6jOkDJSm1CTXa0lKuPxZr3BBU2m2ZkFsRVX81vvkuCkmfviLXtD6CdQ3DMtaJN0HovkRu9IgH+YVm1j7xUdpNs4VcmW69pxP89ASgPrIFk4PE5jPx/CmQTUj7VUSTz3seLLtdy8c653YL2oVKPILEnfAaUKuhQYeJ7rqYD8tQMcp/B8HeaTx5Yspp07dH8eKz7zR4ehPsM8DMwLo6d1T4RixewSgCY1F6oP/Mlr+OAyhnqdLd/O6DNScT4+5w4hC7H62+JxD7BkPCW7NGc2dw0bLWuutoJUQGOtdHgVlF58Ji9voxXEvtTBLaWQ55kJ6zmzCuJPDOW2xAhgwnoLg/XVYvzMlmI8w/+YrJk0Ho/rqoijKrKba7SdoQu2+UhoJOOgys+hAauL9aVFgCGy/rt1G9I92/qfH/E0X6sWTUvhp3hVBx0X0W2oSti5AWIX4SpiiXQP/4QMe91nJRXrA2i9094MgaQYQah2AKtwKhtpRyWyDHGz0CrItSSLW3TevTPBtTO2aNvSrtIGwV15Ri3a1dC7O9PDkVY2I+XS41LIc5TWEeDu4Gz4iy4tH6JxfHCCyG1lIJp52v55XUWKNlJhAy/mGG83USnImjW1JEkN7GOutShVNquX7IxfPypErNpKIGi4GCI/Ti2cf4pz99Nw+AvbSn9QL6izNu5xC9GN64FpNdODQWr7Mr114FsZw7ZRYihYoY6Qn1DpiAl/F12tAux+qRisTw8n4+AmM4cH/hFR++dmE9GcfVC5ix5irLrmVfwTpK9+1sw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(82310400026)(1800799024)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i6X/NjE0zp5Ijn7E7U8yUM4SAXxjeJqL0ZvAnTM/B+RNxyAUiE3S4SyDdtbIlegT4kdb46sabR4PFn6+BdVT+I/GOGjNI+E9rGPQMHHBytdQG31E7Fv0nCNgInrQ90K+vKCWAPhy/vMEWHmg0KXbFQW7483nlVG5E74PBWrBCiVveYtxufA0OL0WrGmOT816BYB/4Bifx8lWpfL/5IWLXImTgv7J6ISZV7RUycc5mDE8cs3drnTagqUcjN8dMBvUz+D8j1bc+Mp7znPq6lazAl/grEnVVllGhQ3WArrEI32vpU87VGFl/a15azBvU4FwwI3WRC7h55lt7lFeWLdYs/MsUl24Oj+E119WajUAxbweeR/cUy7BO+czbb7+ZyfI4jwTZ+FXxFmeUW/mRDEYmdyBsB+EYUdQ+fH7RhUppVJZGGxfZBAh4Ay7QW7P3k1D
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:43:53.3375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1446bee2-129a-4600-71aa-08de841a770b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9141

Add in a sanitization function for ID_AA64PFR2_EL1, preserving the
already-present behaviour for the FPMR, MTEFAR, and MTESTOREONLY
fields. Add sanitisation for the GCIE field, which is set to IMP if
the host supports a GICv5 guest and NI, otherwise.

Extend the sanitisation that takes place in kvm_vgic_create() to zero
the ID_AA64PFR2.GCIE field when a non-GICv5 GIC is created. More
importantly, move this sanitisation to a separate function,
kvm_vgic_finalize_sysregs(), and call it from kvm_finalize_sys_regs().

We are required to finalize the GIC and GCIE fields a second time in
kvm_finalize_sys_regs() due to how QEMU blindly reads out then
verbatim restores the system register state. This avoids the issue
where both the GCIE and GIC features are marked as present (an
architecturally invalid combination), and hence guests fall over. See
the comment in kvm_finalize_sys_regs() for more details.

Overall, the following happens:

* Before an irqchip is created, FEAT_GCIE is presented if the host
  supports GICv5-based guests.
* Once an irqchip is created, all other supported irqchips are hidden
  from the guest; system register state reflects the guest's irqchip.
* Userspace is allowed to set invalid irqchip feature combinations in
  the system registers, but...
* ...invalid combinations are removed a second time prior to the first
  run of the guest, and things hopefully just work.

All of this extra work is required to make sure that "legacy" GICv3
guests based on QEMU transparently work on compatible GICv5 hosts
without modification.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c       | 70 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-init.c | 49 ++++++++++++++++-------
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 98 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42c84b7900ff5..140cf35f4eeb4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2027,6 +2025,23 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+	       ID_AA64PFR2_EL1_MTEFAR |
+	       ID_AA64PFR2_EL1_MTESTOREONLY;
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_MTEFAR;
+		val &=3D ~ID_AA64PFR2_EL1_MTESTOREONLY;
+	}
+
+	if (vgic_host_has_gicv5())
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2216,6 +2231,12 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3197,10 +3218,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
@@ -5671,8 +5693,40 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_=
GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
+		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_=
GCIE;
+		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, val);
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, val);
+	} else {
+		/*
+		 * Certain userspace software - QEMU - samples the system
+		 * register state without creating an irqchip, then blindly
+		 * restores the state prior to running the final guest. This
+		 * means that it restores the virtualization & emulation
+		 * capabilities of the host system, rather than something that
+		 * reflects the final guest state. Moreover, it checks that the
+		 * state was "correctly" restored (i.e., verbatim), bailing if
+		 * it isn't, so masking off invalid state isn't an option.
+		 *
+		 * On GICv5 hardware that supports FEAT_GCIE_LEGACY we can run
+		 * both GICv3- and GICv5-based guests. Therefore, we initially
+		 * present both ID_AA64PFR0.GIC and ID_AA64PFR2.GCIE as IMP to
+		 * reflect that userspace can create EITHER a vGICv3 or a
+		 * vGICv5. This is an architecturally invalid combination, of
+		 * course. Once an in-kernel GIC is created, the sysreg state is
+		 * updated to reflect the actual, valid configuration.
+		 *
+		 * Setting both the GIC and GCIE features to IMP unsurprisingly
+		 * results in guests falling over, and hence we need to fix up
+		 * this mess in KVM. Before running for the first time we yet
+		 * again ensure that the GIC and GCIE fields accurately reflect
+		 * the actual hardware the guest should see.
+		 *
+		 * This hack allows legacy QEMU-based GICv3 guests to run
+		 * unmodified on compatible GICv5 hosts, and avoids the inverse
+		 * problem for GICv5-based guests in the future.
+		 */
+		kvm_vgic_finalize_idregs(kvm);
 	}
=20
 	if (vcpu_has_nv(vcpu)) {
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index e9b8b5fc480c7..e1be9c5ada7b3 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -71,7 +71,6 @@ static int vgic_allocate_private_irqs_locked(struct kvm_v=
cpu *vcpu, u32 type);
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -145,19 +144,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
-	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
-		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
-	}
-
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
-	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+	/*
+	 * We've now created the GIC. Update the system register state
+	 * to accurately reflect what we've created.
+	 */
+	kvm_vgic_finalize_idregs(kvm);
=20
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret =3D vgic_allocate_private_irqs_locked(vcpu, type);
@@ -617,6 +608,36 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	return ret;
 }
=20
+void kvm_vgic_finalize_idregs(struct kvm *kvm)
+{
+	u32 type =3D kvm->arch.vgic.vgic_model;
+	u64 aa64pfr0, aa64pfr2, pfr1;
+
+	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
+	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+		break;
+	default:
+		WARN_ONCE(1, "Unknown VGIC type!!!\n");
+	}
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
+	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+}
+
 /* GENERIC PROBE */
=20
 void kvm_vgic_cpu_up(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 0fabeabedd6d7..24969fa8d02d6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -485,6 +485,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_map_resources(struct kvm *kvm);
+void kvm_vgic_finalize_idregs(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
=20
--=20
2.34.1
