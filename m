Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013044.outbound.protection.outlook.com [52.101.72.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B6828C029
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489884; cv=fail; b=FV8O08tZfk7wyX3C+qvS4NHNCnoB6Zkpiba3DdFp7pbP8Xo0dNlSpSN2XeQm880a1fz9k/XofwQFe42pc2X4CxJiyUmmB8NiTWa1GpHdAzY62pm5wcaUYPe8mrmaYjlEGBR7DrDNXPcYdmEluMc3gc5tG3tmuKvu7rMnDqohj6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489884; c=relaxed/simple;
	bh=X2lAY3pMeLItKzpsiv/np4upnjwOygISQGS3lcAWcIM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qKWk0ZSnADNbjNm4ddtFXh+ne+jnjNHjLsGT2usJXU/4nTDRlMCb8eeMdR7B8Nj0xQh55kSOp4l57RIq0RDmbup2zqauoN1o7Rh8OrD6wriRxS4PmIoiJNRRdM5XueqEQT+qnMT3F2pjgGNxPe0R5Wb9CIrxM6bSu17/YPP6nQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=tQ+8znYL; arc=fail smtp.client-ip=52.101.72.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="tQ+8znYL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Loa1W0bSVbfVIEgBN1mDT7rnHVKYTtwMTTCU6I094F1Dwh+p7nKWb5M8YuZmyUWGPsIaaNCYIWxtbIz0fnxrMjGTAgWh7vKScuA1L68Oz0ek53rEbwza0dwnSRqH2EqthaYGLrxKb01CyqdVIi61qDWR2Rc1Fg+JB0bAMgr1i7BhDT2MyWS4PZnrXd5IaGU/0LSoOW/h5AB6LvseYW1UT1FvfOKXuwYy3sd7JqpQGWKTE1dBU+hdZLd8Bwpiit/TkhWdvwHTbBFBpG5YPJMpJaQt7G/8WlqmGCZ9zkLfUQb+XMKtRzV7id03+0/G56FAfEwzituOhER41Ddw6i+N9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nneyGG+jvxOw3+fLu8LGAK3V1BeWcSfJ+8MV2vW7j8=;
 b=c1l5xgcwQ5HklkgH74GSmmt9nHsb1WOpXDhXOLxZLRnnhw22Q11m4FfpH3PAr/6biwnNa3az2ktA3rquahSHYBxDjAn//a32TlJZdebgJPBBvuMFksY5ir5sq+q8zy4iXDq8gzX0kCcgpeFQP4qKQMQJhb0SwXgdTOf+C+BTqCXjA3YGnluohRS/J4YIA1nWs9Z5+wKDmCmSj9seJlERE0CNdCmIKaZSmh6KrRc1reMEfMiYfgLCAYfmURJu/gSvK6g/XyDioyGZ2SCHTp7F3oPcu0az/vSzMheyYn5AAu7N/mzFekbCq760jeyb8Hf3TWe+80AJOqrWzBJ8p+YEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nneyGG+jvxOw3+fLu8LGAK3V1BeWcSfJ+8MV2vW7j8=;
 b=tQ+8znYLEzzg7LsBMtJfuP7DwDIaAFUAUB7/2cjHEAc8sK9I4UFgk/wZIZ6y5ItDc4ANmFMCIcfDz/HGgj4qQcEinq5AkjiMrMMC7QOpkPYmrDhB13E6qZbvCnUEVIqFAE9qeNmO4YGh6ZRxYcZiA4RNI3kAxMqp+h1DFf+JtABkiM4z5hhh4pZvxjOwmsZqn1u+t8c9KCVBQb2O4/VZBuw2CqATEELCks3IRVeTzZ3YL7G3V85tV2pceKnJW0HMSfStYWLlcNyz9BodKIezqxPEIWS+yHvMaQW7Tb0iItvmvClwAP1Y3J7GT3G6Z8wmjJDGbQfu2dELFLl3IMDJdw==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by GV2PR03MB8803.eurprd03.prod.outlook.com
 (2603:10a6:150:b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 14:17:54 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 14:17:54 +0000
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
Subject: [PATCH v1 0/2] KVM: arm: nv: fix AT S* behaviour
Thread-Topic: [PATCH v1 0/2] KVM: arm: nv: fix AT S* behaviour
Thread-Index: AQHcBtzmSijIPhuut0KCUxeLZebeRQ==
Date: Wed, 6 Aug 2025 14:17:54 +0000
Message-ID: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.50.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|GV2PR03MB8803:EE_
x-ms-office365-filtering-correlation-id: 41dbaec9-ec3a-43db-e614-08ddd4f40927
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|42112799006|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ophVWkKVMUKYuEUsb/bjWJQCOw9fsnb1ZzH3Avc4lvrK8e8foCsrSq69Df?=
 =?iso-8859-1?Q?OLDnM2LHWH1cNkMqYbQ7zsIrzJdrh20IT/k49iI4oD96qGTErVgggIJFAf?=
 =?iso-8859-1?Q?iKMPKQVBYQ2X4PHHv6B0JkeVO2K5jKiwLqN1KctBpwVCx6VCeSFGhZMv2J?=
 =?iso-8859-1?Q?77dJ2OOOVgPffDZAK0ZMS2wy+zEUy+PDESRujdoOmKq0lV9XEF0cndYnLD?=
 =?iso-8859-1?Q?Io7DWDsWm5I5tX9zHZUphmVnv+JXZ0P6P7+xrP8dH3/vXr772u07+hVI8F?=
 =?iso-8859-1?Q?pgj2ondVzDYCrMGWAqHXIDF/brpD/B0Lqn+VuIRMRbCyumz+rpLVo5Wil5?=
 =?iso-8859-1?Q?DCwq1ASnZX/N3xx+U3Rk23cHm+jd8bAE/wWMqbV+Y+7nfIa8GvsTxGf0MJ?=
 =?iso-8859-1?Q?GUx+lmGrc5I2fy5P/CwPb0wdD4sbCMN0gbBDCpRfQYbR4+z3nnqzM+1OcZ?=
 =?iso-8859-1?Q?MBRFfwF26JnDSxarA2o616ejRUTCENEc1KldMQyiJTgfUr3FKilH0RzXhr?=
 =?iso-8859-1?Q?cY+S4NiA5QtgN6i/uWNatBRXDW6F0NGnGREGGNT1Vx2cEMbv52tsdG9G1M?=
 =?iso-8859-1?Q?AF7S8/2feHKFwui3HLm0ZhQYkrpZHvXd0H545WO2Ha/ofQEKjCaA2/SRKO?=
 =?iso-8859-1?Q?q9B3cWWCBvGcjL/3cYxag//X1YvZ/4Z//RLXiyaJiM8CdNto24+siXPdrF?=
 =?iso-8859-1?Q?yaaRhg2+98J81lG8ygY7FHU2RfOplaS+Zy3EbDLXbQQvpVHa9+wm/Rd8y6?=
 =?iso-8859-1?Q?jNjDDrODRp3kp5Kr1g0nIzsctttUSQhAB22VladCr6a1J1o1oN2qW3Sq2m?=
 =?iso-8859-1?Q?T7/TwRuWXx5XSZs0t6bt0v9LA2IjkMRMU8h+Opb5aO9jqukbrUzOEc30hY?=
 =?iso-8859-1?Q?tEQsZCzoGBCvNppyxPFwwoogXmXLLGA5Gby7ixgvFvLf84VovJC/eANwn7?=
 =?iso-8859-1?Q?NDOPEP6O4slLio05t1xe9ME98a9mnanvk3247doSpp8Q9GVC5fs6VJg0sw?=
 =?iso-8859-1?Q?B+mKGevBusCA7GXRqiDPWYByqGUKKDOyfZJScBjjhEoRsMEzD2MALm7E7B?=
 =?iso-8859-1?Q?20Nn5M7dTjuFEpiKGLb5uaNshOr5SuCMywEscuaj3N9CX6jfXbdO8jpfBt?=
 =?iso-8859-1?Q?exy7LeBWAwyDAsooJnCrwUeYlb2ADx/gB0bCIYRY7he1cPr55Q24HfU7Vx?=
 =?iso-8859-1?Q?+wvxSAOH4tzo4HLjmZvS11FJje+vg24bXmfeDYwr0IQyd+Vv3sXiVTJmEJ?=
 =?iso-8859-1?Q?4LTUHvJ4A99PUOwTfV5DMhN0sGTcUjrU57GpGXLuD760mtZ0wXzQ1wGl7G?=
 =?iso-8859-1?Q?xurhFIFjwuSNQ2IbeNLsDSQOaGzazRcTSVqlpVUfFnwhm8i1SveoT5y87/?=
 =?iso-8859-1?Q?1LUczUezc/tBmrmY4AMP0R0z9MnK6tWoBFbyyzODINPpB+Ff7T6A2QWoX5?=
 =?iso-8859-1?Q?s3asTMMgOK8alIVqeBsV1GekJiHikcYzjs+DkoC1lqZ41jWmrnujK1O4Fg?=
 =?iso-8859-1?Q?wuSKVf9wVFwdDm/nXj3JfcpOtr5ewq4JnkGlv0TH98/A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(42112799006)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?gPjaePm/0YdjIfTjJ+3ZntRJjIhy3YXauahob8WD/qTD5S1IqVUBfDQiKt?=
 =?iso-8859-1?Q?MMQuKNArluQ431Upoc428s4XpA7VB/GsQvFDb92YkuGnOhX6cz0KLdIVsm?=
 =?iso-8859-1?Q?e42kdCJGc8H88cMIBjsnc6VlOR1zDXwOHx5WfpMUjbajX1Tg9FhTdBJ3TH?=
 =?iso-8859-1?Q?UU0+9o8Fq9Wz0rCDzJvrny1gFgq8I/cCh/z9Pek29tZ8Z+rsblM4cjO2s8?=
 =?iso-8859-1?Q?Shs7+7utai+/GGgtEg6mGIZag3mOm8H3dP5E1bNgo3zFu+Pj4XfE9YhYze?=
 =?iso-8859-1?Q?HFm1uHVs1QXAYMsvedLIQU0EdUulq4DiqsMWNRTqYy0sTYm0+3YEh/BZZr?=
 =?iso-8859-1?Q?ghDuTidYw1BHiPIjX5j3wrj4XBgmsOxfYjaUeRpO9RzXFGmiLJfyrVuTGo?=
 =?iso-8859-1?Q?VbPEiUUyDKwoC3yrM6taw5aeUir6NCjUpOQetua35IQU4CHOHimSHUg9vp?=
 =?iso-8859-1?Q?7ykJUcFCH3lfS1XFisS7fPGMUrNZTPf969q/6j4N1j3KpSeP5R5JZvLKOH?=
 =?iso-8859-1?Q?4QyPVZJ5SyfcQTizC4EAwxENBDE2F0WNoEoREWrzsGaTAfdW36BxEvOWEB?=
 =?iso-8859-1?Q?oq4T3fnGPiPkFMbkdxp1lsWklRa2qxJk/O43FBQ4Was9giBeREwdrKc+I8?=
 =?iso-8859-1?Q?adgvIDBqLDM01JkG2v0y7RVk5Gs96gkAkAagYEqAF4xl4CLb5uPR/tu4p0?=
 =?iso-8859-1?Q?RFQb2tyX+eP0L4hY6w+x+pLfq4L+oBB4wG5uiMuAYjSVejods90vKJjxxG?=
 =?iso-8859-1?Q?QPRzjtKjLJc2blndhwLZEu0bEklFzeD8A4DrrbvmxlJbBmR5dtHuNpzWUr?=
 =?iso-8859-1?Q?0zB8rzNTn/Q+hvAeznQobxPVuDRrbCDM3cBdBdKdV5JTa80DkjgHw950TG?=
 =?iso-8859-1?Q?GGbsfHDzKGFlm9hPFcjSnb5I9CD0tTxmGuV6XY4ksLRECXS6ClmgLkB6ZS?=
 =?iso-8859-1?Q?9WQNkoSVnXzPSxcLPEj9cymMI/rJevdgcUaSCtCu8kCVwRs91IvTA1C+1h?=
 =?iso-8859-1?Q?Unp9X4iA41+SE5RwDm7G1HAPc/z9sHeco+roUyhO5tsnJew8FCv6EYzrVg?=
 =?iso-8859-1?Q?qiUQgC+OuzsDn37qLD110GAsxyhk5pFo1mPHTNG7Q+3vsRCbLT0bDLgrMv?=
 =?iso-8859-1?Q?jh5OOFg3czj35lw5ZFEHlbm6RYLixmjAIG2YqyIO/+6WLA1d2JcSrXuVzi?=
 =?iso-8859-1?Q?87uNuYvKJ7k1/RD2G0RG0NEWncbECV5WjjaCetPfxbVbp85tViIloE19NA?=
 =?iso-8859-1?Q?cI2NspdQuyaFkgejK/XwFdGU14flgPd9Plae4u+deX81lCTCFcmRuUo3DA?=
 =?iso-8859-1?Q?wn5jfPWxFyDzjZbjr1GziK+e0icZiFoTV2id4QasNtmLMUK1E2rApSNotF?=
 =?iso-8859-1?Q?4VE7hAXsm6uA+92fLTyPm+kHV/EZACDAxL4VegycG29V+4B+uaUSnlQqA8?=
 =?iso-8859-1?Q?dtwvZ7NTf8d1HJHbMIj3VbzmjfCQSr5OYOWcYXdTiebI4wHE2rmLVoy1gp?=
 =?iso-8859-1?Q?AF1Mx3WVsh8sjZwL8fPNgi6yOR0qQQ26nxZ034lLEp5RtjzDfyKQTkoLmS?=
 =?iso-8859-1?Q?ah8Az+uP6CakI1D6jr/vcbqcl1qXPCK+aDSVDmIQiJpx/IuDRnYlRAxh/u?=
 =?iso-8859-1?Q?1h1EsHi9k4YxApzEQ81McNLfDn0Wcng9vOtjPix5At8D8aNo98WmltYw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41dbaec9-ec3a-43db-e614-08ddd4f40927
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 14:17:54.6851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DrXSkRBnksRNPotDxvLq6vKNnb2mrG5dwTX3xksgyYidpOLhW7tAhFCjGImWuU5Kj6aGkupewd8YsPPdOdUVTQIOuCxeO3kAIBNskpELwKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8803

These two small patches fix bug in AT S12*/AT S1* emulation, which
returned IPA (aka result of S1 translation) regardles of what nested
hypervisor asked.

This was a tricky issue, as it worked for VHE nested hypervisors by
pure chance. These hypervisors require S1 translation only, and they
got it becase KVM tried fast path first, which left correct values in
PAR_EL1 almost by accident.

Also, this worked fine for Xen with Dom0 only, because Dom0 is
identity mapped (IPA=3DPA). So again, returning result of S1 translation
when emulating AT S12 worked for Dom0.

I stumbled on this issue only when I tried to launch DomU under
Xen. In that case IPA!=3DPA and we need real S2 translation.

The first patch ensures that nVHE hypevisor will got its S2
translation, the second patch ensures that the hypervisor will really
see result of this translation.

Volodymyr Babchuk (2):
  KVM: arm64: nv: fix S2 translation for nVHE guests
  KVM: arm64: nv: update CPU register PAR_EL1 after 'at s*'

 arch/arm64/kvm/at.c       | 4 ++--
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--=20
2.50.1
