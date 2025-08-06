Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013044.outbound.protection.outlook.com [52.101.72.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5A28C029
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489886; cv=fail; b=G34xaHZDanEgIEcjX38SLnM0dYZrmiTVUeXALpIR6bQ59cpZkzjQ9m9l70bPm+2IBTnvAb/IGAqXij5porLA5WLKlpiZ/+kYWQUjMSJDnxU35MLKkoZfQtjQfymdIs198Ww/W0cFNTyE8VgLlnwmlrFlPy/1NW0ZJVCFNgiq8UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489886; c=relaxed/simple;
	bh=E5FiGe5GIMjYl+GQt/1k3mFwMbS73eBNbkqvtOK8dxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R+6Pf+fFOUPC0E2RYRyA74dcN8Rqbbz0d2mP1ouqYI/BkRGZxZ6udfUrlnn8yr5tkQUICtm0fTtXXNsFbg0mvxCFy15obWCga5xH7/BfPs71hxvi0MMAuhWXTOYoKoeflNctSfnYrJ4+CBtpyTMZXXIHxk5JsPnA3tvQ103DS0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=YqmCBJ34; arc=fail smtp.client-ip=52.101.72.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="YqmCBJ34"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRLYYMzhKyLnmzEenJc6xgjI1P5J+jE0Jawu0EFfDOQa7sWVZ2hO2MPlvR146lE1+1U5SXRrN+CxyHEyusAcKBOQ/fhRvmByppWHmJz55HP4OZVeGWZnow78vJWMctKb4MZDN2vlMTZe4Kry1KED06HPLDwYIVzC6RRs9uFWLoA6sgjChqEn05d2UhMEPYe/xUdquPObl+wlhaobRm+EoDVtMHMXJ0tSZcLCHTy0VEYfyAnbZEV8OBXc3mFwgv+u+UGn0tLkBkRv4ua2cQagkPnUroM3AF2zFj6oAWjdjJaKYM6gbcQg0DcY7QADkIZKeWRNNnf+m866CuyP70w6Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rss9DgkKC4tUBJW8jUoutVhG0+BlmoDiH60X7ZNrfpo=;
 b=gzX03UgWFmggKqU1TO39GgmswwTYgZcQxW0swvd6RkR/iMeA5wv0mI3vNU6fKLrN6qa1IssUI5Oq1LkcdTwM2ajiU30c6RE8wKEwi7fTIm1QP3XRVvyKn8k+M8Pr5RU8jIoH8iLTh9xIRZG42LJaG3Y+ri9lCHyyZwHhym8v7hYmrScXGN43LlQPCcKkbjm8WipZGcADEffuKO4Gpav0JPwsL3rCDsOFvVy6RJIoMewfUJ0C8sptaOqo8Yr+X8HUeN1cZp4PMH1lR9t2cK6KqHSRzzAr2mH3g399Z5FLWlvyP9/JOgenCssGWUbVRELzbwC8+fqvaf5iafT93O4EUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rss9DgkKC4tUBJW8jUoutVhG0+BlmoDiH60X7ZNrfpo=;
 b=YqmCBJ34d3R0T8MoFtVwAW3YqK/CJesrhe1W6YoxFS98MI3NBRtGyquC5QoI1BZxT7AnDjACyFABKkYM7qcPAAlzpgPYslZJzIqcZ840ckfIghmwTKXDJUbt+NcrR9cuH7E+/YaR485VRpWZcild1U2NHLsg4v4kNVrblrUJCccjlDMo/iGRWPNiMHAYfMjoEQS48Xnl4YHylgBXRtJhrIE07S1iZ+EM4hUAZKPdyyv7t1TX5ErPrCpH1QkVMbBUh4iNL603hee1iCqeP7NCfr8YePaKfVCz7QSaxd6UvpbrrmCXPPhWbyeLikjvBjnqmW9J/bSBziieUAXsWQjz7g==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by GV2PR03MB8803.eurprd03.prod.outlook.com
 (2603:10a6:150:b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 14:17:55 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 14:17:55 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>
Subject: [PATCH v1 1/2] KVM: arm64: nv: fix S2 translation for nVHE guests
Thread-Topic: [PATCH v1 1/2] KVM: arm64: nv: fix S2 translation for nVHE
 guests
Thread-Index: AQHcBtzmN7VC96uQ9UewPbGjpVfSjA==
Date: Wed, 6 Aug 2025 14:17:55 +0000
Message-ID: <20250806141707.3479194-2-volodymyr_babchuk@epam.com>
References: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
In-Reply-To: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.50.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|GV2PR03MB8803:EE_
x-ms-office365-filtering-correlation-id: 9ef1bf12-a236-4229-371c-08ddd4f4097f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|42112799006|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?qL5mqiCD6uMdDb0B1PIMjLazCIHdTcfw6CQNu9zjwEf54RLqf9ZKLYb7PX?=
 =?iso-8859-1?Q?B9rkDYOi0/TYmn2TTXOFR9r1phuIVcUM09zXudncZXJsJbyA4bXDLHl9Dd?=
 =?iso-8859-1?Q?j1/S/o9J8Qstgs0FwV4KutjghRGR82vdDtVOmwui4Yg8KTR0dmqodf4+Eh?=
 =?iso-8859-1?Q?FzyM5RG3+ysUrO5wwsJhR31MilnU5P2YFIGjBPkQG6TUasX8Ao+neEFN1Q?=
 =?iso-8859-1?Q?+Q1jKccr0Ef10zz8I5PitPgooH/zRod4Y/ck+SuOBR1UFyRmVG+bcomKHd?=
 =?iso-8859-1?Q?791mGClTgewKa2J9ccSOzTnMBIScc35Wy6dGKzsXyyojRnuf6P8RxT4wS4?=
 =?iso-8859-1?Q?ERZUGqQrXMbqYnzpIsadY8K9TaXwQZQW+zheMQXAZkxMzgjBOjRTOy0/AZ?=
 =?iso-8859-1?Q?FzUjAs6TIUGB1igZEZgPSjIcyGOauSZx1vQWRapXxejP1VdCP8+G5kl21p?=
 =?iso-8859-1?Q?BBNUcAvMCkSdddZGfiz8j0MoRZX3GyqYwY/Lv8Zn/Wj5yZbep/AU+/MCNQ?=
 =?iso-8859-1?Q?MzIe/kMd8JgZiwdewOM2AIjksjavmdlS+Q6mey+TTxEOOwp5ph9P+Khphy?=
 =?iso-8859-1?Q?bm329eIc95uyX8Um2HzQlPZdDvWpiU890fkp5F85h1w11ub2Iv2UJca17g?=
 =?iso-8859-1?Q?sghV6TxpiaRJFBHxQKZcJJn/4dGLJN8j+OJNbACbnT4hQJeqXIWiQirVaE?=
 =?iso-8859-1?Q?+FNBfTZ275DJnFQbpEBPWDK7NrxFMnf+ebIeIhD8hI3KxIonBOJRA6EaNQ?=
 =?iso-8859-1?Q?aS10XJN84Mqq0yr8MmGM7CftqdNADUWAeMfKAnnk/aGvwO0yx8iGe4Nktm?=
 =?iso-8859-1?Q?NKJVY5JpVAensQlaQy8He35fKyfvJXRfe8B+vX3Unx+T/EpC+RwJAqEXjN?=
 =?iso-8859-1?Q?i8zHKZlkBXyqUPnjVNpKAeWwZOlZCY9PceP2u7NOiH+1SPyJouoWoPHzhH?=
 =?iso-8859-1?Q?6U7ajkwi/gpCtmIU5s3ciAkHVZFWNmdDUeXcvOCZO+2W+7ju9ZsoydaHbc?=
 =?iso-8859-1?Q?Cwt440ok9O2kxCZyGb+EehY2C+Q3fPaJZ+8Ae+fb4m25pHQI3syMG+2xoU?=
 =?iso-8859-1?Q?A6bAYyMHopqyeVj/rRqZRU1vvSLVjcZZYZkscQRSrKJfE4rqjYymMlu0hx?=
 =?iso-8859-1?Q?rncxf00ljrRLMCq5rGODypI6VFhM7tjS3mkoWyOrKBFiCiN0g+emG+EfuW?=
 =?iso-8859-1?Q?sMkhsE9K+E1R3IQpOO4BwRo28H1wigqzO0tnYw5gLszO+CR/RQQonAsjap?=
 =?iso-8859-1?Q?ZC2UOzR19BqIhSOxs8a4+p132k1cIdDuV2tWg1mCVLNYbkjKlNTONPn9H6?=
 =?iso-8859-1?Q?Jw4JboORA5f4NiU9LOgyFtjupgSB9LEk7lRqbo6YefMFRen4YFqOHUoicH?=
 =?iso-8859-1?Q?rUiyJtCTebI8v/zruqwILooPb11i/fOlHvzYj481ZUoci8uwLZu5oKiyop?=
 =?iso-8859-1?Q?0shcFv5w5EMW6KYOOwUhboW+ca2OeyExLijxzXqNI1ExvpN6+N3d8iH6lv?=
 =?iso-8859-1?Q?2sym5wfgzeVAzP2YLhLOZDBI0aWmks9hJ19Z/zecX/Cg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(42112799006)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?j2h2we1BVAVAtm7+U9Z9dGcL8IZklxFu/bWJvumGSK7oJ01hjDNTZIsxKG?=
 =?iso-8859-1?Q?RZGoJfIFT1XdGYmwqDKhrwY/FYCzen69unCVs6Wlq+WK84G/2ZQ21cSjme?=
 =?iso-8859-1?Q?Udq4Pz6cd73siawdXQ+ET4AlC3AUclPt9oJlXc/jjoAlFaf/I4fLoIsp8E?=
 =?iso-8859-1?Q?LO7LPWZI41ixh1d9D5HHa9zCmWWf/3+bFeEI3Qzvgo1q3jdczSIOajhgt2?=
 =?iso-8859-1?Q?4iKI2t+5q343aP30rpateJC0pItEPs1wMeDa+Y6/ACYetMyQos2DZbSi/H?=
 =?iso-8859-1?Q?8Gx+SBqJOczsZnhQNduCIJPUNGVhpZ3Ts3T0tGcBNf0k6Q+zvLK4m3sGl4?=
 =?iso-8859-1?Q?GyRAv3DbGpmXdHmRopRx+26ssATUFiyhF1m4+puhZoE3ltQzsr1JKo8Mb2?=
 =?iso-8859-1?Q?/BSJOqXDc+//DRJzF95waSQGiC0yRYsO8I13EKp2q+toqEPj1fODBF6EqR?=
 =?iso-8859-1?Q?2kcj0uMo1nFgu+maUf7uhSa5UpymOeGzP18yPSfF7fVzQNpQFSkTJvgnqt?=
 =?iso-8859-1?Q?SH/yNwInhm+02DO2WiP12yDpuyS3iBkZLKhV+IcSfMaJBiKf7vWu6W1yLe?=
 =?iso-8859-1?Q?Z/b88iZnQ/yhjUm4QmBN0fJ3CqqVNtYzOPUWJUPiiw27Frja+lvlvB8/Bk?=
 =?iso-8859-1?Q?WLyY3PpWcdwB2rgOkpZyktHwm0tnGGQxzU/9mT66v/KmdKHl7kObG0R0I2?=
 =?iso-8859-1?Q?o5+rtP0Qj4Em1BjEE8mK5NsNyBdOXrBdMGoiFKEByRbqI0sdP14jJQglZd?=
 =?iso-8859-1?Q?AjIHz5DjYveznAfekvgrSKaC2p9MZpJGdx385tNFXEOXnJfkSn+jg4XgAq?=
 =?iso-8859-1?Q?O640iawCeQ9jrapsZdayj3gOwmo3VplLfmx/pVHmmqwapgm7JjZtEnBDEE?=
 =?iso-8859-1?Q?yn34ZgNEqcmGk4CouN6XPulIMxOdmC7t6UxbpmuZj6Ks92+LecoYm0SLwd?=
 =?iso-8859-1?Q?FvRdo9EWlYAun6pibpu4K8mcMl7/8oln81duplPvOjvMmeKf/dw+TAf8vs?=
 =?iso-8859-1?Q?zpgCzON4R+NDaq0f51hmF8cGnuvszs9491TB5SAj/BVV+p9oKtQbxgYDI8?=
 =?iso-8859-1?Q?Xhg4/NAuVLiZc4QWeKdIyD92Dz7jujjHy0va0QIWOAS0OcDjEqhvNRqodb?=
 =?iso-8859-1?Q?dZQhpvQoY5EkKG2ACoe37uVa6cd3S3Q6qIWG3tTcJtGnvKbSdbTpIMz1qM?=
 =?iso-8859-1?Q?BwUhtouDrVOoUsY+s7Y+K06PODG14NecSMrWBuppzW6ry7pLtmxo+kXWAq?=
 =?iso-8859-1?Q?pmcwepg0LYcWN3HwO1I1uQQHHcEgimzph2VNR9pFx9NbpfiLVX4q0QHyQr?=
 =?iso-8859-1?Q?hl/OmBTQ8n9PChkiL6KLbIdH/aVfOkTowO51m52ySgDWEOef99iOxkjvBm?=
 =?iso-8859-1?Q?9OsXGiwiG+2BYHznQ3BOwjwozrU2d2+F9d6CcbcNoj0PUhhrIx86pZ+WyI?=
 =?iso-8859-1?Q?R+RjloCiRj3s0L8StmYBZZ05r7fm2n3AfYUy5uXSTa1dSno0JTU9igmFwg?=
 =?iso-8859-1?Q?kT4fP5kzmOKgNHFhp9HSA8YZpEveI+raz+gn3kJHL94g07u9k6DSxZudfp?=
 =?iso-8859-1?Q?qlI8ix0yL9fenmmF+OVUGgfZPvfmkJ4HvyGxOiLd82WhSJIe/+MIGmXoYy?=
 =?iso-8859-1?Q?SyqRU0595fZr6Mq5xCtGRXDQ/6DnUSJSGfgE+KZTU8FCXVdhiquVFL7g?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef1bf12-a236-4229-371c-08ddd4f4097f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 14:17:55.2401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vamFS989o8lwJg5VzB5xQuGetLbZNC0va1FY8q3R4wTl2Se6PeMnziBEjRBQMaCBqLyOoix0h8yOsDsS3W3D5z+p1a/fB2M0LHvxfoXeAeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8803

According to ARM architecture specification (ARM DDI 0487 L.a, section
C5.4.3), Stage 2 translation should be skipped when VHE is active, or,
in other words, E2H bit is set. Fix the code by inverting both check
and comment.

Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
---
 arch/arm64/kvm/at.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a25be111cd8f8..5e7c3fb01273c 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1412,10 +1412,10 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u6=
4 vaddr)
 		return;
=20
 	/*
-	 * If we only have a single stage of translation (E2H=3D0 or
+	 * If we only have a single stage of translation (E2H=3D1 or
 	 * TGE=3D1), exit early. Same thing if {VM,DC}=3D=3D{0,0}.
 	 */
-	if (!vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||
+	if (vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||
 	    !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
 		return;
=20
--=20
2.50.1
