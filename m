Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4291A262D
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742977897; cv=fail; b=H/qrH3pGBE4omFX3b+6ow6Gx38HzVrUdMwTcQdfUTVHdz3aH9yvxhJhMymgivEtaIVnDG6+q+VpSHUcYG5UG3tdpzum2kC5O8U4rNx1r2CLr3kt76C3iOiuRknghwimt4XpJl21p7uVUclftnd9nOcovjesZWZvNo32oBC02SeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742977897; c=relaxed/simple;
	bh=5xupXlCCHxCQgjm2o1iTKBzNqk8y1IjsKcoRHPpxxag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WpTq+kLwBNqESpICU/fyiSeiJ+QB/Bz6qs4nyDz5Sfqfy7u/QDu+y+ZX21zevG6HPhC/obCZ7b/NStijh3wCM/z/MHC6EiHa3ZL9SdCQkTFmPkCGQASueJT9JClEl+B1A6KW4KkUfXZxeTv9l9zNgMj34fwF1dboc5gs0eFdyS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nzFq9bRh; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nzFq9bRh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QrF5B+KudWPdh290TbjMm9AcTBfJDjQIUecfK34CU7u1DfQJ9Ff1WG+9RYbdd3FaNVoHhDVHsU9RWGGhyjJDFtbdxUk5h/loVva4l3X8UuwHg7fn654xmlZ4BucpVMnLcrQazLSAemvw4feD4bHPME11X7cZUlwIaVAITEZIyKpLF/+KMqRJNp5UvVxjw6dALqSIZ9qAEAKE8ZsYEUnyAn7baMvoPm4kmW0i7bgSKJvWLByd6VFJDHGyKOzN4FAQpJBKsslDTi3GP3c7UkBZje+5rANyfPHoFsIveLSxggfuo2M6XYE2pI3+prGJ3PYlEFwwKiQNiqyPlcbvGrgMaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xupXlCCHxCQgjm2o1iTKBzNqk8y1IjsKcoRHPpxxag=;
 b=a6/+rcoeuCIrWpMtnyjIKfAcp17WCrTYSyHu5Q87Y5zI7tRb3UVZ4e5v0tui4BILrUkcw+Yui4/epAe9Y/DErHuTupcWUsrXXs+gwOPdwelFC9LJtBILP6F3G/1mzprx3SN7j+mBojY9FJ2+/AdD9G/gLcs/QJiI0fXdygDjd/kM4e+z508b/ei/42eiQXjwSjRuFdwgaWFFr3buSMx8feey/eSbIS0aPYuZDy1aXp5NGpiEtC33r7OZG96VP0XeDALRUzzUy7rYJacQMI3nhHQBIL6acPBn77twumckmpi/OsyH4SK2fAn61dqru1cpjMsE19lTK47flByfVCnC3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xupXlCCHxCQgjm2o1iTKBzNqk8y1IjsKcoRHPpxxag=;
 b=nzFq9bRhJu87/OaRngp6bUe2pJ/1wfq1CIdb6cY32Yi4XGjaMxwCzkWmGSaCR8JCJ7ulCVH3CwJQUduSe8cvSNUcXFWjr/AMZraabwYKRAe9+TUv1T0QFi1KySZp/saMFduzd6t/aj7MARoqqhmJNXW5UN/HmwbNWBoA73YyVUL8BPxbIR+KhtU/P8RZiCUppdrdnkV8O0/bVbPg/Sn4gUwXvabKqnuNb7BvZCXYEiDiTs6swYzse+zYHZcjWDAeHJuR4BFt3W7Pb9znD6aKRHTcrVyVjEnCy6kDSoMk2JUGVZ9O7CQNLy7kKAgvhk1RDRd1QEfoM8PtwmNB4N0z9g==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB6834.namprd12.prod.outlook.com (2603:10b6:510:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 08:31:32 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 08:31:32 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com"
	<david@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "sebastianene@google.com"
	<sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com"
	<tabba@google.com>, "qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index:
 AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14ggAFVjACAATjx0YAGtS0AgACvDoCAAOaHAIAANr+AgABucICAAD0IgIAAg/iAgACoeYCAABKYAIAAFAsAgAAouYCACiALVA==
Date: Wed, 26 Mar 2025 08:31:32 +0000
Message-ID:
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <8634fcnh0n.wl-maz@kernel.org> <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org> <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev> <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev> <20250319170429.GK9311@nvidia.com>
 <Z9sItt8BIgvbBY8M@arm.com> <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com>
In-Reply-To: <Z9s7r2JocpoM_t-m@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB6834:EE_
x-ms-office365-filtering-correlation-id: 094c2f20-0bbb-44ec-3870-08dd6c409cc3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?PJGK1Mqufw6e0UUqXogvTIGi2T4CkywJzxiVUHE6G5unt0v9wLJjxpKp1P?=
 =?iso-8859-1?Q?3T5gzM0Yn6F56mV+d3On6TPzHAM5Z5Kg185ZVKsaAc1g2fm6JMRrk0pCJr?=
 =?iso-8859-1?Q?/alVEZluQVjQ+xWxcZsbtN0q+3SENvJfQ35gKw0WFB+3FtL8+WHIpUGhkY?=
 =?iso-8859-1?Q?C3x8yCbVmRR7QiWpqQepbk1XmqLIYcsBJ7AKp4WSo3b3MikvWtKZrNKFxD?=
 =?iso-8859-1?Q?YC3XS2NtEmhDpCUNz+0ErctoE2qv3dn9n6YnQmv2TOphRgldvjZYpDiLgK?=
 =?iso-8859-1?Q?uhkkmlMRgzGrItL41xSJqwqd9N44uSF0gI8i+5dk3c2ZABOjSJPpgWKj46?=
 =?iso-8859-1?Q?vwOTJlh1vNrZ7vroeQspd8EE3wjTnmQuK2063KnVYmwQa+TFBNsz3UzArE?=
 =?iso-8859-1?Q?TnWC3R+98wVTs3KMtA4h4C5ROeA2kV5wuhVW1kdZ5bFsl0d6luGyjfS4og?=
 =?iso-8859-1?Q?HXoyYq3tS196ZCpRMGkIdwDNKCPH8FQabDOO19YL3YpLJBRtd1dmC3Ofs6?=
 =?iso-8859-1?Q?Nj0wHn1pU7Z/EKHD5ocJggr4z52cHMg4Ndi5Jx5tCSwce+H3Ra5+Wnlc4g?=
 =?iso-8859-1?Q?SBOFTqzF/tp2HNza4ngYoSR2I0Jglq2wdB+WjAii9Oi0WLzKdUuJvSqxRj?=
 =?iso-8859-1?Q?e64mLt++MwJhynd3amrul0NCC7l+z++UQBnP7dJ+xa/75LbDBWgVdkJAsQ?=
 =?iso-8859-1?Q?VgCzwWCDKzeA/WWI2j522PUrC8tGxKitjSbpxyYG5q5V9VE5Fl8kCUEwH9?=
 =?iso-8859-1?Q?toI6nZyuvKAsNqVJUjjHZ8dyiX98Dfj8zsI7UIQmjOPkquOrtSlZhyr2EH?=
 =?iso-8859-1?Q?Y6YWhvrj1YyqKQS34pU6D8Go8wzSA4y2O8UXuxJiHtji2ATmNWVXofL6g0?=
 =?iso-8859-1?Q?pZ54Saq5g0A9XYvJKJ14h6KKjFzP85KTK3v6Bi2j+B5r0BKl6sdNF+gif9?=
 =?iso-8859-1?Q?0lbAe3jADkFNGnf78TKEd1VOtgPNXWdgkR7OSHjJmccLNRRFSYcJXq6R3J?=
 =?iso-8859-1?Q?ZWJGm6NruGoc+TrLTpcHLqYq7rmOMws3Ta17dFsm+oWd0jyya0/fXsrQJB?=
 =?iso-8859-1?Q?4+BbmH5hnzS+vkPITO3/wjaB9LF0jreDfCddbejYvEvAvcjXCZfzOs8NXn?=
 =?iso-8859-1?Q?UhG9gWdCgIxv7bQMmID+EYeC/6wDn0Pt8gq5n/iXlyYWuVL8E0NSD4cjCy?=
 =?iso-8859-1?Q?ItJtV6WpXMl3lYqP+e9e8YJRJglfvnYzIrHs+HsS6pGx6lALA9gxFq3ry4?=
 =?iso-8859-1?Q?3a/SpZvIAsBAv+2PPM0NWf2poP356QIMVJL5B1sknDMvU7kcKjpDbxRJYZ?=
 =?iso-8859-1?Q?Z7z0m9nWEZXObFj8me3YEYTMPDnhjWxg0aUQKD4SXr6oTSCw0ZHmF2pX9N?=
 =?iso-8859-1?Q?8zpegZP0Vwr280ELsnzZf3/+2AinWoi9jUdh3ZZd+rk+1+jhV1P2oZnTxs?=
 =?iso-8859-1?Q?vCVNQs7sSOfqi2Fx8x6zF3wpr9yaDiEjcXuigSJQgQ6KL/KxCQjfH1jPLg?=
 =?iso-8859-1?Q?jiDhXYf4AWYCamGTIGoCwb3ovKXSpGcS1XB9iu9QcPMA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?8FJpxjFKLmoTWt9gG4qP0YvDAgVZ2sVtJ/cCxzQaEuzrOfUvk3zqUlvlfA?=
 =?iso-8859-1?Q?X19+BmKOs690Fj8Y6u8l2Q0s4yTMzC4S1ij+1KM/9WO30M0sHcIsWpu7Xa?=
 =?iso-8859-1?Q?JY7EndpBn7Nmw7YRJfDu4jYdlKTginwBFe9DL9Lr6cNrP6vQFw0G1x3wzT?=
 =?iso-8859-1?Q?n8OpuASS062caYanmvUQF8C2MnRHux+pHUQpVoRHVTXY70iSUDPTIn2Wc8?=
 =?iso-8859-1?Q?TtaglXDLPMYGxIMYcJU8ifEI1iGMA/gaJ2gfOl3Ye3jnJHgTyT06GGGdpy?=
 =?iso-8859-1?Q?/L+3c1Xnj20bqL8/YGSTRgbxqM94a+A/Hmi4F+y81AgCzc1/z1HfksC0S4?=
 =?iso-8859-1?Q?4fUOeXq2b3nVleRBuaoXIVa4tjgFeYKwmivY1bCJAbwDDYPwU+NKD4pN6N?=
 =?iso-8859-1?Q?7/MJdHvPqmsQnyt3JacdkB/+8Bj7Grljrzc90UKzwepiAI7o0TsxH6Ybrq?=
 =?iso-8859-1?Q?+CvL6xc+2JzKrcqMbwgphrS/4bC1A697MAuq6SUSPjx6lhw5URoewmlP2R?=
 =?iso-8859-1?Q?nf70V4GTNRnr4fD5rPS2BdvB57zoccBfCInfo8q/LsynGQjW27whd2Sy7w?=
 =?iso-8859-1?Q?f5M2wIrLkpbqmMLqv+faU85YXrzZGI5N7SfLMRr89ZJCIR2GvDyHHJtvyq?=
 =?iso-8859-1?Q?iHww1R550xje4kvXIxaAyeLZELkbgKQSzf/vQo+CeFLLsfG7zfst3lfJCl?=
 =?iso-8859-1?Q?/HUQdTdGJvQkmCx6wLLvqTht9vd6IwYnw44Og3Kr6FV+dpnoSnJiSQIBkE?=
 =?iso-8859-1?Q?s2m3ssq6i/LKE5kXeoskhILJSPkWieFY/HWNYTyMnmaSYFvcbSPCKqo/gt?=
 =?iso-8859-1?Q?rKKn2R2CoowtDkRfhc2GCBrfk7avJiU43ZosnicWkS+wseYHTysWaBBemc?=
 =?iso-8859-1?Q?mjypgwJXi9lvOribKX3ClC14jNGufYHcLDyi9p5TfKN3/iaZ/Zlc9/2h4H?=
 =?iso-8859-1?Q?FouSikTHlCBHuvXFt7/56HkaaWGCRdHn2Yx0AdmGITGlW8VTbykCOECKUN?=
 =?iso-8859-1?Q?1MFIQDHNTi7tYydbKJCHvQ+XpAysMptRM4K0124r+zqiJdmjqE3yIlzfSO?=
 =?iso-8859-1?Q?BaVcgMfQabABuiyRbrJSIl3oT+2qvaxNSreKKpwirYbnxdVujdIKH9f+ce?=
 =?iso-8859-1?Q?rUezfyn44D7Lf1zZmme87OgGmgq7l4/xyWGysI3E5guuznrCGDT6ROmHLS?=
 =?iso-8859-1?Q?N+o2O+Fe0uXiuLQ4Js29KnZ/TogHsvPrizEJZdLsGsWrPPvzxUDGWUzcOi?=
 =?iso-8859-1?Q?cJSeV3IhflQt28tnV5iHn6fmmhZOBBW/hq52P41w5HGU2ljwBEQnu9EUuY?=
 =?iso-8859-1?Q?KrBSo72t5Gkn+LTyJM7CPrFZYyxCVEU/a3W6szzF/jK5WebChH4ijjffy9?=
 =?iso-8859-1?Q?qS31xUooR5oMYTMdhRxAvh/U8KaNeIMbNTomqFIQMbpd3+4Mys/93RW5Kj?=
 =?iso-8859-1?Q?VbT33LHk74uAC9l4BNm1vMK2Bzobdi1im+w3D8U4jp1wxhQ4OmUdSi/np2?=
 =?iso-8859-1?Q?hJ/b5qOmfAB/Sae8fHAjZqXWWTbhuSjYqAmi8zp8qndT2pAelgUBIbKbTI?=
 =?iso-8859-1?Q?UnfsGP8C2AbqEJhFknN5E5vjIwpVoc7mWj0CZAlyILbw90vKM3gXC/haBu?=
 =?iso-8859-1?Q?SiRbW4qyf5BpE=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 094c2f20-0bbb-44ec-3870-08dd6c409cc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2025 08:31:32.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GwCMl/Ll0xPN/6C3bMPa3HxUmjMhtUaxt/gcyBZ8P/TjrBpFrUFRtTGj3JqHwv5FIIb8zsEi964TbvjOTUSgTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6834

> On Wed, Mar 19, 2025 at 04:22:46PM -0300, Jason Gunthorpe wrote:=0A=
> > On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:=0A=
> > > On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:=0A=
> > > > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:=0A=
> > > > > You have a very good point that KVM is broken for cacheable PFNMA=
P'd=0A=
> > > > > crap since we demote to something non-cacheable, and maybe that=
=0A=
> > > > > deserves fixing first. Hopefully nobody notices that we've taken =
away=0A=
> > > > > the toys...=0A=
> > > >=0A=
> > > > Fixing it is either faulting all access attempts or mapping it=0A=
> > > > cachable to the S2 (as this series is trying to do)..=0A=
> > >=0A=
> > > As I replied earlier, it might be worth doing both - fault on !FWB=0A=
> > > hardware (or rather reject the memslot creation), cacheable S2=0A=
> > > otherwise.=0A=
> >=0A=
> > I have no objection, Ankit are you able to make a failure patch?=0A=
>=0A=
> I'd wait until the KVM maintainers have their say.=0A=
> =0A=
=0A=
Maz, Oliver any thoughts on this? Can we conclude to create this failure=0A=
patch in memslot creation?=0A=
=0A=
=0A=
> --=0A=
> Catalin=
