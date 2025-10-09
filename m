Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A61115D1
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760022957; cv=fail; b=ecX/c2p9/ejzHoHYDZIf5w/ikiCUww4kZDa+LculN4WE/cPfDUY2jvM2DXppLibIYF+vIzBHPpWle6afskrNE10PBS3daPdj6G+XMKPU0Pk08Eu8zF53L9dFkoUVhc1yLNDgn7jtSz8RaBdjELLX2OKkEC63IB7Af+9Wjcp5NOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760022957; c=relaxed/simple;
	bh=FPyCqAH9uvYfrfbp5UPMF33dedruGRo8DSoAYQORbHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=abFUYMOl9iglqGTnBgI4Z3hBlRVPM5+LCv20p61VJacpSAe+6HI+25lLpuUlq5HkvhMMmHlntG/zrDTs/qXyiLPhBk6CrnbppNMKGrRoeUXsw6jCCY2oKOQwAY7g/ZsoEBFXMaCDsnvd5/Dacv5hjyXjFOes9PW6Am8avrkc0Ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=BC5BkT1l; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=T9fCVk/w; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="BC5BkT1l";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="T9fCVk/w"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599EoEqH020464;
	Thu, 9 Oct 2025 08:15:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=hrUkBGn1AJjvyCKAisi+9exiArxheYmFWB9ngm0r+28=; b=B
	C5BkT1lhwXpZH/cv5Ol1SCTo97Ee9LOTcGZ8ODysEIbxqwcrBpr6ldwZCWWfftW5
	sEDs2ZAM3cKWmFBMe50MXD91DKwJjjJS6iDSqKN57ab9gzbmvjKxxnA4cprwc94h
	vvqwzMHHWRCbyDY7Bx3IKqxhWeEuM3k36rEwrSgNWeRZ8lL/0yMUf5K1LAQvIzrQ
	HkaGciM1jqC/6F74QHxqi7UeufWr2UIYLqIAg7y3tf1ZBBklG7qBKyR2Zcfz0RMw
	LWQv+wg5RNYs1dhXxOtHxjQWl0p9OwKPRm9zGhbq37tb3s2f0XitDPiCUcn1Lhom
	635G3kA6Y0G2b9eXI4aqw==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022096.outbound.protection.outlook.com [52.101.53.96])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv5yw9wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 08:15:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVJzp1f9uhF0xMxVH+iW6Qq3z8NKapHK6EKV2T4hZHuHoGildvZZ53IA/ulDZA9XfR1d2k+LOm8A5vv0aDhZvpK0OVAXYqiDJUoY50As1VcgNUM97FZ2NB2yqTKd2ph0g8ddZrDnaquLGm1aUNzIu11e2Bc8R/htV/twYulcOYCWPjUOXy5+HZOuhdMhFV/Cxx1SJlKITfrwb7QHoaFPgbe69BLolvHfgk495snS33crLuYsfpbyF0SiKl/RmEj5jT6IYZeR2HHhzcStCHap8nZJB+IHh5ZJJxIZJtLJDW13dW+salgwiBzaNZnugsVYLf3VR5If/UG7llddMq9h1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrUkBGn1AJjvyCKAisi+9exiArxheYmFWB9ngm0r+28=;
 b=nowj21MENGnaW3BrgFUE0HPLS2u6OAYva4+OhplLm+HG5QR4Kye2bqdQyuaBjYlhmY0Sd4ga5r3MJewN5NNEs1yAebTGGz9BTMY9jL6Q4vEua9MnCp4Cfid24JBcrBih8bN+ZtcFuo4V1Aq0lCWz0WEYfeXZRtRY1NDw9jB64Ei5XqmKfVBgIe3g3ZwFPKUXcnjFY8dlfHmPD/9dy+z/YzpD8MYGkdpBx3NHF+DMkNx62ItHK9Fo14fIed8ETD/bY6Yhp04Yko9R4UUQ/NKCueJbfw0wlzEhZqwS2lNTf5/X+1uhTt20voERStUyTjZasvsflyTUVd77re66P3T6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrUkBGn1AJjvyCKAisi+9exiArxheYmFWB9ngm0r+28=;
 b=T9fCVk/wDxYuy/xLDn7+NkGAPnA0EuDVgTRNZuYsJbXZjPrfpwvrQZyb0EiskV6m2/M5Dl5DXj7lC8p8NgGdy6C3j9PwKzSj+jzK5BnAXcGRAu5VXQNzPp6xawhy1qfs2/OjpdnPZRZWNbT1cdluuT/dODTLA0qSkmwccHfERDU=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by DM8PR07MB8805.namprd07.prod.outlook.com (2603:10b6:8:30::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 15:15:20 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 15:15:20 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose
	<suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu
	<yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Thread-Topic: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Thread-Index: AQHcORYHl8k/JSGPrkmeWYXbJsfh07S5xysAgAATfYCAABIsgA==
Date: Thu, 9 Oct 2025 15:15:20 +0000
Message-ID: <C9CD1224-FE74-48C0-BA3A-E029EBD6F25F@global.cadence.com>
References: <20251009121239.29370-1-maz@kernel.org>
 <aOex5rmMU5Q-vvss@J2N7QTR9R3> <86sefsxj28.wl-maz@kernel.org>
In-Reply-To: <86sefsxj28.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|DM8PR07MB8805:EE_
x-ms-office365-filtering-correlation-id: b88c4ea0-3b16-429e-8e22-08de0746a936
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3SLr59BR3ctFQld3nLQ7Pb2o78gACabQiALPaWg9gRWSUxwWRH78+/C5R8b0?=
 =?us-ascii?Q?vdFZddP3CM041oWigAKSYozwte8IaNSpHjB/lmJ9pOJY4XP7DxB3LQ3tGtam?=
 =?us-ascii?Q?XEfN+NTUhOskbPzT7Io+lXgEb9R5YvKbd2VrFJB3QEpaFzXhHAgavPzBf4Z/?=
 =?us-ascii?Q?KXj7N2SckRdjFBJnKPstk4VYIVSkzWg/06W/GLeBgKJ1SgSFfkLolMJ2SyXA?=
 =?us-ascii?Q?11+HEMWgHbDrYAIdj4yGlFPfbEKTugg0l5yC8ZntJg8ft/aTHxSGPah/FFmG?=
 =?us-ascii?Q?B9QGwwqHdAkzcKXAorpVuwMmuiHBM+vAlfRjqWEjPZ6kdANYhHYBO9fL3SMa?=
 =?us-ascii?Q?ojzXp9o+frKc4wUXSf0TTNvAVOLdeC8QDunKTSPyZKdgJ8GoLH647PspH5+P?=
 =?us-ascii?Q?0V14if2eMfSsvWfwSUtM/DMK9tvjFajqO1/3sL8fy9oidDKSluTm7oiI+vvM?=
 =?us-ascii?Q?7c5ef2i4N2iqmPZ7YFf04OFqMWAgTDNMDGnTGB7/f2QHzP39dCfmmdMia0Tp?=
 =?us-ascii?Q?D5WZCl3mr2Xx/rsOF0mTofI0NCmTTCRkcSjn/LGf/ncmT2RVaFhXYxdhbzzh?=
 =?us-ascii?Q?mhumfcg5WZbvqUiyNIkLj+tYRGuzKtIUtowA941vhRF15G/3IB+AZujBmZCb?=
 =?us-ascii?Q?T767lDHmSI/0TGd6yjyztLkRDwPI/j1n+iPP1bChf9GpxlW3K5wkuMCAvaEY?=
 =?us-ascii?Q?mi9Kna859EnoqLqdW19RhXKjDLuWfzHGPR9zdnGvLZmhObzJZuhPBSEdXfAk?=
 =?us-ascii?Q?BSvdAqp2he6peheLK9GUyIKU17rojFHmC2T2hcZvJg60x8wK7mLc+wjtO3i2?=
 =?us-ascii?Q?fekibT1HuHLEHxAeQvyLCWvBsGTyIiMWuOaRuxI7Urx1zl8iI3K0cuIWLc2e?=
 =?us-ascii?Q?Neb+3+mwHL+Nrb2WsGUgDcYPYr5+Ma5it94rbXFMvWRUJdnWN4mH3BJFoW2U?=
 =?us-ascii?Q?wb5CL2QtgwYeXlTClcHyvvRMQraM87FVB6G2iPMcpIeDV6n6loeTi7R19fmb?=
 =?us-ascii?Q?er0H50WUdX4hSAYYGC7be31REotvV2euGzmfXCrxSAvornBhRd7htYg2RwfX?=
 =?us-ascii?Q?OvCjvtb5loCJjDJRnEffYSBqy8VZqLGlDHjLFEnSfkfznJpZjlAHDXAv30KS?=
 =?us-ascii?Q?7jJfSk1ExNBeRt054R6nZyFRPiEWHk6xwjUaPP//BJzdQNWCTNNs6Z/ZilkB?=
 =?us-ascii?Q?bUIcjDg9Yz+kYVay+os7HvmdXO/4PLhL7Wo3SOpRFnKwtBavT+hAes+KAqPE?=
 =?us-ascii?Q?2+EqHVpti/iAFHt3egbXXp4q5BTtfkm/69QzfmP82tKafkNSUbuhpl4EeZYN?=
 =?us-ascii?Q?xaAd9j0OgXoSUp5nwEKaOB6HptU754XS8sLnreKyDKT2wSaudkUZvlefnnSH?=
 =?us-ascii?Q?JswkpUAaKpU5yA4g1ZT57eabl9rQYQJGZW4mFcLN/po7JPFyvKawyGgvaiJC?=
 =?us-ascii?Q?Z+BZJd3rka5xoRUqUzqKhFaIf3oFUuMpypMI95A0tmpN+hscdxi6Gi1Z4v1G?=
 =?us-ascii?Q?rpZhuoM76+4PJbx950Br8bIkMvZW5axPltnP?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ersgx1lxk9EaV5nox4ZTY+DSZMBV0U9kfZ5ttfCZPrYE6M2kXeYjUP5REUk8?=
 =?us-ascii?Q?Sqq8lyRPpOYlYa5xMocwTE6MaWF2zTrYYkV9wkgAjmREtjMZYaoyjgL9RPas?=
 =?us-ascii?Q?6BCUwbQJkQp6GGO/HIUu8SsOiuSh6yNP89cvn7CRgwqHnsOmwb0XKZEF+H7+?=
 =?us-ascii?Q?xxjRsvj1AxUkiZVvs92TGheVjc6j3oiDmsQC96N4zGR+Ns3nyUW0d9NakpTG?=
 =?us-ascii?Q?z8xvDMADZcHBr1WCYnekDxnvoIxonqw7Ts/51uSKw7xAlc3F5u7g021T1tgH?=
 =?us-ascii?Q?ZkP5OQkLiGfun6Ti2ZuIMjlH6z2ciGlxFhEIapTkEtbeLQeBnIiizPo0P483?=
 =?us-ascii?Q?HUss0qU2imuCfhuPp6EKWgJR4H7ytUBd6BW2cfmtfq9aP193EBw4cp0I9oNE?=
 =?us-ascii?Q?udGBnFzYmjT4QCF0ShJecRobNznDWBn9UUF4WLcsY/GskL/GPf1WBKu5DVI0?=
 =?us-ascii?Q?o1ccaeDcjmIZ4xjpampwu9kiQzNjJvwlcJuSD00a0vd7sf8WIvpRUvqyioMc?=
 =?us-ascii?Q?dGnACTmJWwurQb/3pmTkWvBS0jwKrFPKYtu1qrJsz4orKTQNZDAX7t+cQz3V?=
 =?us-ascii?Q?3wbOKFNUKbApad0Lojdpz/w52gBG/8IHslbLHSBzruJUXRMSFb1xng/ikCFb?=
 =?us-ascii?Q?KEXQlKv9tJqLjCkZRT72bSWOyO2GeXnvocuagwy3PXS/LLPkbwTcvL9HHvCA?=
 =?us-ascii?Q?Lnmgew6Jj/XAi7+49JufHdX6buW3SVw9Fi9gb5u/yoVw+p8jrSR9cNnP31yJ?=
 =?us-ascii?Q?esZAQoX2uUZaGR0aih1Z1K8nQQ1xKF2cnEA4wfKq3UMY9s04n0BoiqZo7FtW?=
 =?us-ascii?Q?FSs+kPzyTWVJBuULXIgvtvV32UimjKhq6EUfYCJUQQP5ew73skoLv2y1RxLH?=
 =?us-ascii?Q?ldtFAyA7YfYBqL+gJHcZgzLMzHZQJ7wC5x9EGWwK60wxFJy0ObX29FwYEgYU?=
 =?us-ascii?Q?maWN/yVd3n42n5zbWMBc/pfjF0W80FTZuNDgSpdP8eu2IlgUlToTABzDcu2b?=
 =?us-ascii?Q?KliQFGE5/TqN8XeRReyd8NItEBpqBl6+sFr6zcGujr75+MZiBCBz6j+ZKPXb?=
 =?us-ascii?Q?JZy7N4X7WiY8i3fJIPjiryrG5okI13RSOB9O2moI/0SiluFSNmRhFsEftk8/?=
 =?us-ascii?Q?BHi34yF72Fg31prRJpwYOfrepK3cCjoieDOl3P+YKd0l94VfUPP+oP2mE6DB?=
 =?us-ascii?Q?CnBi+qNV8H+/RTwDCq5g5rORCYyAwRZQLw4Sqn1LTY9GLn7VYOAz8F4KfODw?=
 =?us-ascii?Q?Ka2n4DQSCSeBg6y9ayfiFeJqy0zGHhFQrvSSvIYp7cWQj1VZE8QTjXKmuylg?=
 =?us-ascii?Q?6Y6YD9aOp3MkOrHT+Eit+bpwuhNFAMPOaDc+LH8pDIwbRpsjZTN/ltrN+wc8?=
 =?us-ascii?Q?cKFjgUrtSoLOG45xUUNEKTUdCmld6I8EzTFuGtPQGg1d9k3Omdc2dJv6HmsY?=
 =?us-ascii?Q?W4X5CAIO/dM5BcYd1Gvfn626ty6O2Ey9/AEBI8xNQx8u1eANdMN7XtHoQCdv?=
 =?us-ascii?Q?WFfgyeSF7ihb8nfI1zcUFfXM9OvhN53BixAD2qcVGlWfQn5FfR8Bd+kzn0vg?=
 =?us-ascii?Q?crp+nubCZTF6ywP6O784PXZAMhbkgSxUsJhhQIvFNWyDq0Ny+e5KcUApY2sl?=
 =?us-ascii?Q?dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A45DC37B4F72CC4FA88ADA77AFE6B902@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b88c4ea0-3b16-429e-8e22-08de0746a936
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 15:15:20.0687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UfPt38jsPN0r+8FENy5ypWekqVZlaCuDdk3aJ0KZessd32kjjN9iczXGSg4SZgFZZZeFR+lbX4oZEuIejUelEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR07MB8805
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX40kRflru45QO
 8Y+SOCihQvKI/+wrnoIiNeYcdrg5aLOaKUy52RDeWeyMPhASezNhGFapTrSuFNu40lt0XZ5reFa
 MtxW81ZZxM2dkizQSrIIwAKyoM7SYWHvbB/Ezcy4YGxg+dDVxiyh5XhMRvqwd37csQ/4/bVXFUs
 1SQIRWF6EpaN7ZgRAHgovZ5Q6Avvy7A3qXWF/TeyExofuK4gbWtDc63wZOzF/UZt57HTPHXhuRY
 U6me3fgqU3eG/uyMTtsXAkOeHZEoRPeKy5c4IYWNszvXeq/QExngev6SX4pPL23jN4GzxHYAK40
 E6nq+CFABN+sVIapH/2j6pi7hZoI++dwC9kMX93uyEAXTzID0sZlNVeLfSESmZYh96MQsI8kK9k
 TM72CVht6AyqvwaRbV3G2mQ/dKYHXA==
X-Authority-Analysis: v=2.4 cv=VuQuwu2n c=1 sm=1 tr=0 ts=68e7d18b cx=c_pps
 a=6BO/oEg3A5udCF6k6mmjlA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=7CQSdrXTAAAA:8 a=ftU1ScGpSNtTWeu5PRwA:9 a=CjuIK1q_8ugA:10
 a=WmXOPjafLNExVIMTj843:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: tQMp4zv1-NNk0ZOmAcAgsHsWAMifUdbG
X-Proofpoint-GUID: tQMp4zv1-NNk0ZOmAcAgsHsWAMifUdbG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121




> On 9 Oct 2025, at 16:10, Marc Zyngier <maz@kernel.org> wrote:
>=20
> EXTERNAL MAIL
>=20
>=20
> On Thu, 09 Oct 2025 14:00:22 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
>>=20
>> On Thu, Oct 09, 2025 at 01:12:39PM +0100, Marc Zyngier wrote:
>>> We currently have two ways to identify CPUs that only implement FEAT_VH=
E
>>> and not FEAT_E2H0:
>>>=20
>>> - either they advertise it via ID_AA64MMFR4_EL1.E2H0,
>>> - or the HCR_EL2.E2H bit is RAO/WI
>>>=20
>>> However, there is a third category of "cpus" that fall between these
>>> two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
>>> an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
>>> is zero.
>>>=20
>>> A consequence of this is that on systems such as Neoverse V2, a NV
>>> guest cannot reliably detect that it is in a VHE-only configuration
>>> (E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
>>> best effort to repaint the id register.
>>>=20
>>> Replace the RAO/WI test by a sequence that makes use of the VHE
>>> register remnapping between EL1 and EL2 to detect this situation,
>>> and work out whether we get the VHE behaviour even after having
>>> set HCR_EL2.E2H to 0.
>>>=20
>>> This solves the NV problem, and provides a more reliable acid test
>>> for CPUs that do not completely follow the letter of the architecture
>>> while providing a RES1 behaviour for HCR_EL2.E2H.
>>>=20
>>> Suggested-by: Marc Rutland <mark.rutland@arm.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/15A85F2B-1A=
0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com__;!!EHscmS1ygiU1lA!CgHR7mq8v0O=
MxlFNUnMJU9oQbdQUMKM4aqCTSj6AfXwJUJssNBDP_LJCfmcZuKxkC-aq1Ce7$
>>> ---
>>> arch/arm64/include/asm/el2_setup.h | 30 ++++++++++++++++++++++++------
>>> 1 file changed, 24 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/as=
m/el2_setup.h
>>> index 46033027510cc..b7640e2c20503 100644
>>> --- a/arch/arm64/include/asm/el2_setup.h
>>> +++ b/arch/arm64/include/asm/el2_setup.h
>>> @@ -24,22 +24,40 @@
>>>  * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
>>>  * can reset into an UNKNOWN state and might not read as 1 until it has
>>>  * been initialized explicitly.
>>> -  *
>>> -  * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
>>> -  * don't advertise it (they predate this relaxation).
>>> -  *
>>>  * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
>>>  * indicating whether the CPU is running in E2H mode.
>>>  */
>>> mrs_s x1, SYS_ID_AA64MMFR4_EL1
>>> sbfx x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
>>> cmp x1, #0
>>> - b.ge .LnVHE_\@
>>> + b.lt .LnE2H0_\@
>>>=20
>>=20
>>> + /*
>>> +  * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but don't
>>> +  * advertise it (they predate this relaxation). Check for an
>>> +  * essential VHE property (system register remapping) to decide
>>> +  * whether we're effectively VHE-only or not.
>>> +  *
>>> +  * This is also useful for for NV guests on CPUs that can't trap
>>> +  * ID_AA64MMFR4_EL1 as they don't have FEAT_FGT.
>>> +  */
>>=20
>> Would you be happy to elaborate this comment to:
>>=20
>> /*
>>  * Unfortunately, HCR_EL2.E2H can be RES1 even if not advertised
>>  * as such via ID_AA64MMFR4_EL1.E2H0:
>>  *
>>  * - Fruity CPUs predate the !FEAT_E2H0 relaxation, and seem to
>>  *   have HCR_EL2.E2H implemented as RAO/WI.
>>  *
>>  * - On CPUs that lack FEAT_FGT, a hypervisor can't trap guest
>>  *   reads of ID_AA64MMFR4_EL1 to advertise !FEAT_E2H0. NV
>>  *   guests on these hosts can write to HCR_EL2.E2H without
>>  *   trapping to the hypervisor, but these writes have no
>>  *   functional effect.
>>  *
>>  * Handle both cases by checking for an essential VHE property
>>  * (system register remapping) to decide whether we're
>>  * effectively VHE-only or not.
>>  */
>=20
> Yup. Applied.
>=20
>>=20
>> Other than that, this all looks good to me:
>>=20
>> Acked-by: Mark Rutland <mark.rutland@arm.com>

I tested on a Neoverse-V2 machine.
Works as expected with KVM_ARM_VCPU_HAS_EL2_E2H0, and without it.=20

Tested-by: Jan Kotas <jank@cadence.com>

Regards,
Jan

>=20
> Thanks!
>=20
> M.
>=20
> --=20
> Without deviation from the norm, progress is not possible.


