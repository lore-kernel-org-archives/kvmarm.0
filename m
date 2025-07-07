Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0749C221F1F
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 16:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751906401; cv=fail; b=ZyPI8tDH02jElpW8pm+rM5F8DLvqUvXdK4bMS+ZujeBXabg50ek7vZWTHIIlUPGMH5b7TAWCpgSY1VdzBcP/ee+oaCawlFLqNN5V5WcqMXGpz31GRnr4SLRhFV49alXtADOrHKWb+DnzRmmZAeAhHQp98sL+gPRdTodV5G4YvOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751906401; c=relaxed/simple;
	bh=OKJ+SePL8ad905xXZJicXIbTXk637WzjFgDNc9XGFyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehLrPRSzDbMTiYc70aHkVgqIswLe1rS82Oygqqd8cQSYizXqykVf8Js6ujcXW6L/QCe33Uvf6nZtq+ctiB5TnuCNajuoQDWcVkbASs/ufz33PbGXVLyIOC0PhvWZPPSVzfMTIZtG2j6E2+PyX5WcgyitV5+dSmrSBS7TPrQDx+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jIFfTR9A; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jIFfTR9A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCisJUybt6fje82swAywLvi2KHnCUjtDMWX1OcQifkm+8cozrSEVH70jx1XomfwQwEP7LC//7BA2WMB/+UASRPHgMvZ2yLB878NJAVR3uMq0C1tJtjDK4y+2vkqgIwoBgCj4UfiO+nhNXHLvpOPSk/IR9PKlBRnfFcifJZfS5pKwtHC+8d2iAsRZuHtiMfWjRrQrbHDCl0kWcDD5A5EN6kIyBS8G3dFbNY88Q03t5gmnx7/jzx8+VE1LpaioecZTwnOtsFzgFnvuZBfU0obq6OY/aRxjbOwRaOxI9WoadtJS9teE7xC0bmMfo9DPgrw4C4J98Xa+rQxxN2g9w1iWJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKJ+SePL8ad905xXZJicXIbTXk637WzjFgDNc9XGFyI=;
 b=IM2v06Tu6mo+WtT0DZ5JMVOlI+vnLsvqUFZ6HB0qwlGLiNNQ1HerDRBRmm8XsM/WBhyh7X4YHV+hR9NkLSq1btQ5Z78ZjzY5PAyRZR7dG3SM59D60DKQUqI2U41tSprVjvonVLbMQrM0ffHo8EE3pf4xqhL+av5BQcEIiHJnGbs78dnkZyhkLdo93sU+TVIqEdsQWY2e0WOOFkJ1L+9hgzOCIiROSsuxrzf12CRfPkOLl38GYCqc8xpni7hHDnXFPAFoOHEhapH8C4tJwnynaXZ57eYAmFFGvYQ87PINfxrfDpoZxhnozL3gGedfUKnVd6HDek0kMwMQNzcgccMP3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKJ+SePL8ad905xXZJicXIbTXk637WzjFgDNc9XGFyI=;
 b=jIFfTR9ABwbUZuLzIO10Jyu4CI0VC+wM9Mokn9dQV9TM+vP9JVxlWBjMbsQv1x1TFlOA8DbMOqJMrC5+/kje18F4h7aHRzBR+yf+o/eKpzcr9on6JDacDdmu1ilqv2Ux/OiOhmxn1TTJ/Ey/Z8QyeBuiFCAYN2NlUbS+1FXTN4B0p1cxQUJrU4lFcy3/8jaa6P4d20MK+pKx0+MtjF0YXCtI/k5LC4QG002gFBnUSJ7PuGyjgT5XYTM1P7L/wHAzk31usfyth1KrhxvWHsmqFEVqLCbzmFo/GQppiMTGOWUjV50gV2LPhY+VUnSxIxU8WYVlLU8IIkW/lh0yTM/zlA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 7 Jul
 2025 16:39:56 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8901.018; Mon, 7 Jul 2025
 16:39:56 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>, "ddutile@redhat.com"
	<ddutile@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Topic: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Index: AQHb7Xzh2Hcw1h6RA06LwUDPmEcqgLQmzm7Z
Date: Mon, 7 Jul 2025 16:39:55 +0000
Message-ID:
 <SA1PR12MB71990F54565B56BD2E422CF5B04FA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
In-Reply-To: <20250705071717.5062-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW4PR12MB6754:EE_
x-ms-office365-filtering-correlation-id: 4a707742-45d9-4c14-4332-08ddbd74e7cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?joEvQ+Kegx75AkDB9gnlQYbSabYnRDa/ehfPYkhd06WI1udCUoHF26SIOo?=
 =?iso-8859-1?Q?gljlj33k6xROr5xAayvVVIoAiF5SkFrJhbffG7noZkA8pjyH705j90X0Si?=
 =?iso-8859-1?Q?alH+uYOk4aQItaMNSMV9MSkbwbP2OBcT1cObLykutcDVMsTQdY7h2vNuMJ?=
 =?iso-8859-1?Q?tn6l4F9ArXY+cSComGdJPcx+IPh+oHJxuNCGEUyw7OgbcqeJpeFMe4QjZ9?=
 =?iso-8859-1?Q?5Pbr3HdsJJoG7iWjh+30/GoxL4LraU9qDg1cIDjmYBipByFG+Lq4twYkpZ?=
 =?iso-8859-1?Q?ZpWvya0Bx+PmVbeZMPqO8cF0b/P1dep7klLZRu58xzOHka3WKXbzlGObue?=
 =?iso-8859-1?Q?9L7wMduJoYZ6vz1YG5Z8SZSgYcCd35Frmp/CimUSzKcmHoyFCF6bNnPE6x?=
 =?iso-8859-1?Q?KVXAV5A+IxKGsnjjjYUAFEdxmy57fQ6HaRd3kbbguhbTozeNEiEXKbs45k?=
 =?iso-8859-1?Q?Dlv1TLYM2TblCVtrOZSbMlzUnZifYYfGTItdfFFGlMi+dbAV7BXIDCXHm5?=
 =?iso-8859-1?Q?Ubc0OCwduwhW4lqEk7Gg6IkgMm/35PLT6PzGET5gSw3Ad8plTr8ZlXxdJf?=
 =?iso-8859-1?Q?Tw04xg1B8NN3C7fdTMQNOxNWkDFyFklyUwiRf/ujQ4fsjm8/ki0hUDvA1V?=
 =?iso-8859-1?Q?bvOradGB5zrY0FBKGqYFnbIHwklx3bkSCxBlZwch4TGNU2IkNDdHm/N5qL?=
 =?iso-8859-1?Q?h6fm1nqTjNgd21QcpyHSuX20pjIagOEpN6G4jNLPteQRCK3BW/NKJMeqRP?=
 =?iso-8859-1?Q?JYIkmbA91bmUw5GAMo30u7vurAIt+5gNA+basy83Yu6EQAQLyir+xX3cxs?=
 =?iso-8859-1?Q?uv0B/Gi6zXBunAmvtpKupYMqo/SAFQZ0Q4nTsnVfWzaLfWhqa8zNpvMPYm?=
 =?iso-8859-1?Q?WWCFF1CZzFSEWuKEHdqNhzZrTVXJE5UDE+BFjda3+lkRiZbmZh7HWhM80H?=
 =?iso-8859-1?Q?vvZK5lXI3k13OHRMnSjSkKw9Raa4f4ap7Ju1Im/wKYmaEGqkvSH1e1aaHm?=
 =?iso-8859-1?Q?MUEN4r3qx8S5U7VH1P2qKW4dqU5viDFLrmyScAAj/9gJtp7EylzkWcABCw?=
 =?iso-8859-1?Q?TToEDiKXuSV6tveHteKsZtEolzWZA+7rdbdyEsuREbSSVLZsAljST+Vly9?=
 =?iso-8859-1?Q?tYD1sCueKjzhitbdJivYlH0iZjYPViFoQgPMTWKz3FNQbUltNf5fKNEy9P?=
 =?iso-8859-1?Q?yilYD3zEAMDSFQGTwIiuDpSB85Q0wn+wpkXyhtV02s3xnlHoRer8Tvl39O?=
 =?iso-8859-1?Q?7QksAYKEjHl/7jtYAy0t4JsXQi0ae9/HVYvVsrC+KKE8STEO8WSIfkRF3W?=
 =?iso-8859-1?Q?n/UXpmKpQLOY2PhMivc9MucM7wB1M3Rul2WECkrNi4gOgz1VrN0L5Apl50?=
 =?iso-8859-1?Q?8z/sYA5Qv2uQhlnc17YbOkAXZqA+/byS83nk/7R1TDSJzKwvsjUDVtsukr?=
 =?iso-8859-1?Q?KyKlvS17c0xYaL133UZEwEom7W61cOcEv0/OOMZ+6vsgS23KO8i0RlDpXp?=
 =?iso-8859-1?Q?uId7ou5HbFxgbAjg3pKBFfOr23ezjE8kmAxcVIyDAfDnouPNQnCSj6jc25?=
 =?iso-8859-1?Q?IhcL6RM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?sp1JMxV7ELKuikSGWoNN0JlcBUyMu8T/MxzNtbz1edBN1Taxx57TJ3BF8A?=
 =?iso-8859-1?Q?Zxkf7YFT3mh1qca1T1pDnjc98NATtkPcdmLR9R4HiT5CnPtrz3zi2Qz1J9?=
 =?iso-8859-1?Q?luXkL9johlLpFte0bI8bdmowyhM9hWm3y0IG0vG6f8PdR/ElWRK3kg6nRn?=
 =?iso-8859-1?Q?+c8N+bUBcf9+vHRih4Gxw14b6ipIDwL4yYjQWfXFq9c6qeGoVtqKUPHcO0?=
 =?iso-8859-1?Q?rEXkAK1DGumIQD7vAPdTMYTzcQg14j2e0fHw90rySqkuXFWvNEfKY5AUfa?=
 =?iso-8859-1?Q?+cbDEskTxRheuDS+p6cW6yNrtBK8bfEkzuXyQoEma4GJxicGH/c7hB+PqV?=
 =?iso-8859-1?Q?+QNQe7TKCeekAkEE7I85hZ2EXbcuIkQryYu8dzUoaRT7SEwh9at+tem1Yk?=
 =?iso-8859-1?Q?YW3RQ/iXzO1O8PYtbfjWhBQmtwEcPlLDTFufhl0VIG8E1GknaZwV/pdCNU?=
 =?iso-8859-1?Q?UXWRVKt/Co23DQOUa1wKOxeOCIWJvbGB1PMy2xOY38esQZTtam4ZjlMceg?=
 =?iso-8859-1?Q?+0cukAnhR2DrIZ1GpHemj0mSvKXPJb6PQKuYm63iYloGPFQtdMGhdELp2z?=
 =?iso-8859-1?Q?QsYAnBCfvuZYT0gFIL7dpRFkDC3k0Ow3UwcJ6hDbMHu2NunJQA1OI4TK4i?=
 =?iso-8859-1?Q?axc5Kt9WzPz/oDSmp0pW/s1IL7KJyS5GVg/ZlbkIXBzJQhc9C2Cdh034vr?=
 =?iso-8859-1?Q?1+YlFu3U6BkPbNfXuZ5IZF615vOt+gfyDAUxVRQHjMFI2Ii6Egz/feHeFi?=
 =?iso-8859-1?Q?Dt/aigfjI5XeHo2M0ClPRjhowVD3B7sIeWClSINSnA1JPuw5B1FGkePu7J?=
 =?iso-8859-1?Q?IqTUPRT0muoxljlBneMouYdurATduuXla/F9S95Pm+bjpRBAg5l3Beoi6a?=
 =?iso-8859-1?Q?7s7sAxHWc2swq72IgXztV8rZzLQxosLLPDxxiaZLtJOEe/RAEkmUSQq4//?=
 =?iso-8859-1?Q?KSjpPvvqivakub02JJ3Goy97umnvrZEbcQeCwYcqOfxR9hfhUVnWAAXFlZ?=
 =?iso-8859-1?Q?J8DAXsT2PQb0u2xP4CZRU1GebmL1Y5cSU+XvDcDYO8wWgp/m4EnprD4kTi?=
 =?iso-8859-1?Q?N+CpPWynvtjYDVPP83POiY8Z/CKCs5uJhyKppCKISDVKT47kffjqIRLzWR?=
 =?iso-8859-1?Q?cdpgfOV/cOTtzONVgFV5zyEZk16Ouhd1yOFPwGkJ5uH5Wx1+RrE8dQdDWQ?=
 =?iso-8859-1?Q?aPDTcvIrGXwiYEvBwf3NF7iJBOD9jRtchAsOKcLjxnA38cfwPEECajHP2A?=
 =?iso-8859-1?Q?hZFIojbeYqEkHc4ql9saDHxPqJWwuY1wOSHlFKt2vZKpIxXFXYwVpr/mK5?=
 =?iso-8859-1?Q?ccZVECOfrcLNpgRpeeDNRcILagRNmmcwLBKejv7g74vZhy1wBHCQLOjUgX?=
 =?iso-8859-1?Q?KIw6x2K5wPQTXrdkI8hWXW/fbkHKEmYidqFSzwCKOwOrCPUeRIUtqR6etO?=
 =?iso-8859-1?Q?4EvEoAOjyYlZv7ULxvYanGGmMPC701Sp1xxVjGDws/0FInzGauvt1Q4tSb?=
 =?iso-8859-1?Q?97Js/XbZegnco2EDXrZb4iN40xtBDC4j/s68JFFZEpeZ6mHVJ7mzFoP+zO?=
 =?iso-8859-1?Q?SgessH/wqAPknTjtjM56GGlkOEjLvNwrxpJdjif52yaQ0ah9MP0nprTeVS?=
 =?iso-8859-1?Q?vS3QfpixeyV7I=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a707742-45d9-4c14-4332-08ddbd74e7cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 16:39:55.8630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3m++Tbb3kF7PiG0dMs4c2rOExeuCvzKGCsuqmpTxXcHQRNV5hdBodROEDy5CmXQarEarfQdznkHVzK6Xrs2Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

Thank you so much Jason, Catalin and David for reviewing the patch series=
=0A=
and providing your Reviewed-by.=0A=
=0A=
Oliver, would you be able to apply the series if everything looks fine?=0A=
=0A=
Thanks=0A=
Ankit Agrawal=
