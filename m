Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC422335BA
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 04:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748318646; cv=fail; b=CEg/SxPErZcKTv1/G0MKqErs2uhID9sK/BJMwFMDvRKves1XpK3np1f3PNtTUlLr9tB67YB5i4clrBGZ6aPah1Y3jJWo0eBQDT2xHLmRSfFzI3qHq6qLXpr+/cIWuu0q5Da68L23gfSPVuxhEUsdso99pI8m13IDv3+yY3J+HcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748318646; c=relaxed/simple;
	bh=2yjyD2S09HvRAFzGBHJbqdQL+mcZYGub5gnDEImvqXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgYY5iEbzr/RZ2auZYcXUZlyBsziaNthBR4hws46TqHD1ITxKJmG6xsOPpIqIrdUj7ty3aKrVIu80EKVi3nkb1dTBkVIe9ezZOOYQOPIgMpCFe00o5tJ2PCDY3SYzYo0ri8OnDRUJ597XnuZQL8HQuk0v0AO7Gnv9yMKrSjhrKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WahwaglE; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WahwaglE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KHR/41Zm1eV7WPgnfQuPvcoLhHOsrgX28qmbbdUaIqbwBEsyXF55FH9XfKuMG4/IPqxoJnEVg+AcCEFQa7ltXgcsgpycyyEaHG5xVxJDR3NGP8oto8QLeThD3kGEE0E8zi+o9VGmGuSkA0ZfT22N2M2djCZX58CYMfAPMy0oD8wqrTkEH99x1KF0dxDpxaD3+ZAzDXQAfy4Jb00x5e9sdEMSd8x/8fJRUamWBECokWIWrJnddc0HmNF350VsztSv+fERnNpgx6tfjTJbVG+JdjWqZUKO3RvnHuh1aQKzgv6yi3wM7EQWAf8Y5VMy3kicxYb6dRpqGdwlF/j0SaQCBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yjyD2S09HvRAFzGBHJbqdQL+mcZYGub5gnDEImvqXU=;
 b=Y2gUnk18tPNubkLrIDf6dz9BaWmkdzy7olAq2RhkbyAe/65NQsQI9/RZeuBO565UpvZX4w4aKHsTUM+HusR8dao0cFNAFy7AE1MpKTF3Mq+rBnvfQ9TyqXxOw12j7eaN66zRenIP3xUl2DyM7SPmpQYRybd2LSFjGbiD0tSfsQHlIrhxVTaJ+0SgMqQ/vStSdhUCiWcKQU4fQNQ4dqU54BkTBz1491P0uPsOrAfunCRmKdu12B1FMjRCNx+KWaVhQEjqLUgMOohoPpI6mArJF2nfZbYaAT2880HAJvcCMuIt+ZKKFo0B6JbhfvQXq1QEsrjiTzQTPb6Z6K+yMsDQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yjyD2S09HvRAFzGBHJbqdQL+mcZYGub5gnDEImvqXU=;
 b=WahwaglEFHVBtUrxV1VhErOZ2uwHaAr9rLbZl7FxSPy7pJc25d2BB1HEbmHFVxa5MNqIlEZ6U3UBKCiYg3b4lEsGc74tM8zIOj+0XVELDVfNl+b56pd/pU+r4rsM7AONoquMZL/cMhTM+lqMAKFwDVoXKgGQcJ7U2xkpjqB12JIEKSPmyTlWHi/KVzT+L4WB0Ee5aFpyqVRUK74Kygp4ngYPCYdpYL6Sx5SW+3GDmNnKH7gOYJVLeRi5gyHrRGJNZe2bzWGmBKdwMRx+6WzEHsdEvWoYFoSEmT08gLQYyVAJWL9HNwgLHLfQCy1ErDvWDQPMlIBdWaS29RwBBB8KhA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ5PPFC41ACEE7B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 27 May
 2025 04:04:00 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 04:04:00 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com"
	<david@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>, "qperret@google.com"
	<qperret@google.com>, "seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Topic: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Thread-Index: AQHbzEzDl+XUj5qKLkGqyGQGUTire7PlDCcAgADTl94=
Date: Tue, 27 May 2025 04:04:00 +0000
Message-ID:
 <SA1PR12MB719952194BB7CF27915806A7B064A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-2-ankita@nvidia.com> <20250526152514.GE9786@nvidia.com>
In-Reply-To: <20250526152514.GE9786@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ5PPFC41ACEE7B:EE_
x-ms-office365-filtering-correlation-id: 8ddab9ae-8f17-4ecc-f2a2-08dd9cd382cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?xfMWNILwAaeJKCvMV/e6Inj3JSH+jf8/CPi4Q/qUQuZtxQGl8FSE92DTS1?=
 =?iso-8859-1?Q?90d/d3TrAqvT3J310zoA7O+EItdVnoflzcDWdx1XV03F03OrZFgOf+dooV?=
 =?iso-8859-1?Q?W3qX1ljIbI3mVqCo0pDcqcvkF76SCuIX0Hfw5q5i6fanS0VDvVl+d5EWbp?=
 =?iso-8859-1?Q?qlLayj9IjNpmeHLGAKlbgyUY8naL9ulC1rlk3b8vl1dHiTX1JAIgM3hZf1?=
 =?iso-8859-1?Q?245EK8Uz26VqCdN8YMXj41LmpkjZ2mzEUFMfZ4LzXQMiRLHG28V5xy1v2v?=
 =?iso-8859-1?Q?Tq6T3QK67GczTAS+ZZZ3+2jzsWZvsJss0esgXt5EraoWGJPoDi8mm3log2?=
 =?iso-8859-1?Q?VQsHZ588wvI7Z0MNdv7FGHrv4Y9GNjhr0OyhbHTuYxU640dWztrbP921oU?=
 =?iso-8859-1?Q?/V1/qecjs1bpkASxvf2GQ8DK8xPOAfI9/n5qnOIC4KhRPYtNsZByBxHVmJ?=
 =?iso-8859-1?Q?gxwWGgvF1SffiMcNwORR9jgdvmz6nqceqRiKfsK/80aLG0eTat5oNLksNT?=
 =?iso-8859-1?Q?/L3/dT4mgcSNCQlT5/Wqd5EgH1UC7FYkQaX/aDYDXjq01o0rUP/2JM/VV0?=
 =?iso-8859-1?Q?FHpMWVB29rsqvcPQS/cQUzPfbZ/eI1bJAwIFZT1XsLVkCiMLAQhg6feCWB?=
 =?iso-8859-1?Q?ZjxnKN4FMKeewhyNQRKwHWErzTCiQw+xaHZsvqYBPQJXa4uGf6+OmTbgr1?=
 =?iso-8859-1?Q?mehJnDNUH4Bx4BRVNuw5ll1AHZuNtg7Ci96RORk/JNByPcX5OttBmdPJoS?=
 =?iso-8859-1?Q?OKx6z/FJJZnDngs2ieLy8W4UkIR/7OUuaGhLV5BlkcsdUVnKswVH0Ldt8V?=
 =?iso-8859-1?Q?J5YuwzEYopEsZ0AJOapt4IAhaoTsH4y9Cs8gOCglJ7yeVZ4vsUhp9kkXXd?=
 =?iso-8859-1?Q?ZIZC+T2eexr5eJpe18kk5eX2q76NuA83eBihjDLRVWHt0coIiAo1pDLweQ?=
 =?iso-8859-1?Q?G9sBsFV1+AsGRS6q12E/6iSLpNlBaZ0icRe7y6jPvZU0EPQru2XE8zEXlf?=
 =?iso-8859-1?Q?iSyPiXeiCD2PObxCs6eRtPhnv9d454vaCGA/heeKIAhLyA/7hwvhAKOj5B?=
 =?iso-8859-1?Q?EEZmo2xTzzjkMmrQpqtysQSzL1BJLKjUJ4lQWSCH6Qxitw7tqSNC7E5ium?=
 =?iso-8859-1?Q?WjApNoIjfJVTc9ZzecYWfAS/VaICe4SF/uXMJfic+7QGs8woSG/esfxXmK?=
 =?iso-8859-1?Q?rpLWLDNoqmAQfKh1If2WIl34zuWPt8VVj2aBDLYlXVDB9P9gT9qg4QqGE7?=
 =?iso-8859-1?Q?n1f4Xqop3h0BkE3MFAVg5U6lYFit+4RXvxcxMGiiM643J1pJAuGAVuoOvd?=
 =?iso-8859-1?Q?dmyT95CvvcF66J+0H2gHuqEHS+o60TXBi/k92QedES39SZHKerY7Hw0J+B?=
 =?iso-8859-1?Q?Q6wlAlqXSCn6azJLQsC3Ie+/9RraEyKGTllR/vIFQwIg9Nhhti0HXdqBqw?=
 =?iso-8859-1?Q?vUrb5EJ/qfbyxtm7droVL/UN/aggxnWNZgZcwdF18GbOlhMSDpKKJf3Y1p?=
 =?iso-8859-1?Q?huZVXauPCgkGrjNmg3vt0aRZM/docQYswivB4V9r7mTw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dGrDK6G+kOjHrGN25fq3smLrAUEOzWhOJGZVj/7VCke74Z4WTY8NLywibs?=
 =?iso-8859-1?Q?AqHer8uV8/AgmJkw9My9v01rKI8n0S8EOJgRiiQJkfLSG56VuInyb0OUJp?=
 =?iso-8859-1?Q?a3Fm4ZQYb5/jl4SGD1qH92J67MGnauUI5mFDC6Ew6+Fz5gvJvONfHym4yt?=
 =?iso-8859-1?Q?GxUeoY/LWerrNJwq8K6SPAyCn50mSCh0zwzz0qIY8RVVCKgK382OfSmKzs?=
 =?iso-8859-1?Q?CeoVP7GbbpFU/wYsSMnQ2MXmOXEf9pfp9VWYStki82eaMFbVP+Iq4w8RBh?=
 =?iso-8859-1?Q?0qaHZvyF9AkBLcXP3/jB44L0dg/2A3txwexJ5upDmDwUnbmThEle2qCVOt?=
 =?iso-8859-1?Q?pE38hrII+Tr02TJn2MtBMl9k5v0czeI0XO4ZP539ymhYaKK/hp2VwRes3B?=
 =?iso-8859-1?Q?3z4is5Vo1EcyCvtwtIbj3OhG+GdgZjMcn//Tv5LqxlYKqCR7W5Hik50QCa?=
 =?iso-8859-1?Q?KGc+H6EI7S1bYs1vZnmRXXqUAd/dPSnlRyH8DkO0JbcYvyRv9Ag5whgPN4?=
 =?iso-8859-1?Q?u67HrFTxNJvvKXwy97YGmxJfM/uCS+wAlEsY5dqLnk4rlSrIF0rXULO4+A?=
 =?iso-8859-1?Q?ci3PbpMEvGTvPCSEDeWgDohnK9gV0QGEn9jwQ2KA0lXmCqHFhs3JEuslYL?=
 =?iso-8859-1?Q?OZNemkrY0FxhZgrZkA870sTVPGLW3cBZGZUKG2cnYR+QM6xbiM3Z4yqoAG?=
 =?iso-8859-1?Q?WtAupC5lMK6UA+elgaNhlQuHK9Coooxk+VinUS3qvlBFpC2LVppeUY6yrX?=
 =?iso-8859-1?Q?AiWOAMdzJljvnK+8xXAbHTVxSPPstWNDjeA2Mfq7NXN3GzBU8FPLgBpcDS?=
 =?iso-8859-1?Q?5x0FEf5isR6yLBlrBb9gdkMsmzLLf1asoB/pT/OuvqmwAvfJBJTUIu9UYW?=
 =?iso-8859-1?Q?bkfAkJ1gI84+3WeomK3cTU/yoYxnAGjU6230AKHsWeekQEvB70YgmVg0bB?=
 =?iso-8859-1?Q?CsQJTJMQD/xy681YCqHocRMD+agHa91Tv4WSKkwjXD/zdu0RCGcvL8yLMV?=
 =?iso-8859-1?Q?DLcD3+JQIN3sKkdn2l8H76GrpwEifnEh4fAE3upD82Qcsoa73GJ0gLxDrW?=
 =?iso-8859-1?Q?QOLN3pSbkGkYA376kAbXCjxzZBqAJ60X7VCJIDE+g3/x0RSfgkOAxA/Gn1?=
 =?iso-8859-1?Q?QZ1KvAnP7d1J6etM8+uWEZLOSLazyON3T7NJi72tV+nObSDkY0CxyYbPJF?=
 =?iso-8859-1?Q?WYNc+YEI1NlaTkolqdWcTdRt5k5xOmLUeePvdwd28FQP+9iMWD8wJC0MJp?=
 =?iso-8859-1?Q?BI4PenixM3jz/XzdiBRKVAb15L+njyjX8wb2oo/wVesdKr1YJovMKVcrmw?=
 =?iso-8859-1?Q?TwJy85bLmbKPkvWcgGgamJ3vr0lLPYb+cz7zElG7TIfU2CwIxGJqNDGSq5?=
 =?iso-8859-1?Q?dI5KDE+T/mhlsTx6B6ko3bLLhnFUqtqhAnIqgnY/QmFURkEpAgeEdB04zh?=
 =?iso-8859-1?Q?Vt2cRsHLB5r7ue84agevHtEp5qcXJBednXdqt92M0IqqhrBItEMafbCgzj?=
 =?iso-8859-1?Q?JNABf0go4LHnN2JLeFmNzuNBP6jcAP0NHnnMsqj2BAs+O9tW2ZIDZwKTe0?=
 =?iso-8859-1?Q?lRthIhGrvQFyQuZYJb4jDBoF6xrpI9jktlyp3UPtOWxWU8PaKUcp3bDuU/?=
 =?iso-8859-1?Q?8lv5bJG82Qetg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddab9ae-8f17-4ecc-f2a2-08dd9cd382cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 04:04:00.2949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jxg009z0ahCEi4qyIm1LwSR1QVy5ASEBOEdTD4/LTOyT3+N6GclqycQM4kQ/Pdqg7DlTlYWj3yAXA8tS/Z0gIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41ACEE7B

>> Fixes a security bug due to mismatched attributes between S1 and=0A=
>> S2 mapping.=0A=
>>=0A=
>> Currently, it is possible for a region to be cacheable in S1, but=0A=
>> mapped=0A=
>=0A=
> "cachable in the userspace VMA"=0A=
=0A=
Thanks Jason for catching that! Will update the text.=
