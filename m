Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90C22C326F
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 04:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748839342; cv=fail; b=CMbGtMO+7smvi2+hZFtUBDkNUKSYGWeYYX1r5+NHbs8m4d3YSYtL8xlNMw2imvrIWFDeMtzIvZzvibWZD8GOpUgZDFhrkIm/PiK8I+MakBR55YqqQwDNDGGnqdiRacoXm2ANXQh8EnV+FQ0wqYZbqJ5V9yWQBW3IQ0aaRhVeQjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748839342; c=relaxed/simple;
	bh=fdzk8Ukusn4zkC9BYQmw5SjnrabEPysYLtMtVVR56ZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CeSpazfRbavg5hrhLP6gIj4NBjS/WeM69ZkrAeOB0xpsBC2Prj8hpgEIBujj4haYLlQLawOiZHzEM4LdntMdFUm0a48UBoMxZ/Vx2WpCDKwXQqJqFbIs0pXJvMd7PGLhulMGj3U94wLSlOCJepma7PkwqJuYylOoRTVhWaxwnco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I9r0Uisf; arc=fail smtp.client-ip=40.107.243.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I9r0Uisf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXkXbmOs6AK+YJdZ8WsU5RKq5WpPcw/D1imp+E69gM+HTC60152wDYrGPU4FTnFB80qorCyxtXDFBp5njzI3yVeKzX7/E59w/AiWOeRzz88WFQyeV/dAPMLtaXnnISnEL7Z5Fw71HwV1j02kVsCcGMOABGu+FYNJoDpz4vDNgaSLQ5vWODc6W64h+HfjQ9IOrXe/4C4dO7Sy5x6GYvL1ugCyDhUkLutPQE6cT4ddPRzckptYxZLG3Y880QPVZZ4UEV0gMfStagq2uDV0/tbYOtTIUb8PUDNTIBuMPJPLJEQV3Jxr0hh6RSz4UtkBzj8wMuGExUkOeIUw7VXnmkybKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdzk8Ukusn4zkC9BYQmw5SjnrabEPysYLtMtVVR56ZM=;
 b=qZrP0g3/rSzHEUFnJDoipmwxY4c2ZXNE/gRRCWNJlZ1n7Bt8q9DsKlYGc5IfjUNJQIAcu7q0wnnCce1tSSgpnEEfY31ImNiB+66Tr2QClV+1kVee5Edxc1YsyvemPsDbVJ6vlMA3ALlvrQETlAfKVVTmJDA8y8bu8ZMqZhet2WJHw8IeKEWz3hslZL5OVJJFtgxT3Hg9eud8U6/SNCLiW0xbLdbJVT/5Hw2Ze7qIVPnFs1pMUAmaCJCfZt4jrCD6FMmyYfxHTqKGnL4myAcs5svU+kUMHsUcUhlm1dqgOy51Le7tPsz87/RmquHwyblJMAdCQr0PPQUg1o3uFfQrSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdzk8Ukusn4zkC9BYQmw5SjnrabEPysYLtMtVVR56ZM=;
 b=I9r0Uisf1Ui4tkIZdpu9bt1eAv7r/31tBhIInCj76j3cI3pkrBfiXQnPTV7R1m+1qiu7+3Vr+y42hkuNLo0tg1clwX4hC+WrmG/fDLK/oCVUwqt9TlszfZaNYdo7bOoOHDV9zBChPmf4UBcEDM2c2ehClvVVrfJB3y8nAE8+uMgdEuwD8WWE2+rUL19RaZEWXzps4+o/n4689dUlDfQS0VSQroCjSUfgirVWgwVzzcXlfZ6c+PR86stcPFQcz+O3/FgTZBuVnssQChJXW8Wz/RE0hQCnUdM5OwDH63eeodSVT6sJQlTjWPUmVp9/jGagxGspXFJZj7iVDhiNaFRuNw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CYYPR12MB8853.namprd12.prod.outlook.com (2603:10b6:930:cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 04:42:14 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8769.029; Mon, 2 Jun 2025
 04:42:14 +0000
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
Subject: Re: [PATCH v6 3/5] kvm: arm64: New memslot flag to indicate cacheable
 mapping
Thread-Topic: [PATCH v6 3/5] kvm: arm64: New memslot flag to indicate
 cacheable mapping
Thread-Index: AQHbzEzI+6vBCHMvLU6Sk33wF14jHrPlo3wAgABB1qiACXLwVQ==
Date: Mon, 2 Jun 2025 04:42:14 +0000
Message-ID:
 <SA1PR12MB71994C3F10A7E0136562B975B062A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-4-ankita@nvidia.com> <20250527002652.GM61950@nvidia.com>
 <SA1PR12MB71990A84FDB4350DC02CEC6EB064A@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB71990A84FDB4350DC02CEC6EB064A@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CYYPR12MB8853:EE_
x-ms-office365-filtering-correlation-id: 35faa044-c565-41d1-20fb-08dda18fd89d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?AInnkGe+72NWch+WCOFbs+y8pJ+Jp2jcRGdLWuVPl4iipRa7YsE4ZaYx9D?=
 =?iso-8859-1?Q?dsHjLa3pRO1R8mWrqQEkhoKWjbH2EzHGaDQ10pgBduxk6KD+w5pZ+LwZCe?=
 =?iso-8859-1?Q?AUK9jS4Pu1htlEM30IZuZT1pU7Exe3rRR5bsTcYL2PuSAgsyi3IeV8HfI8?=
 =?iso-8859-1?Q?R9UQPQ8/MakMeNfVqNXVtu0pTCc4krA2ay3Py1S7LAihJivUzfcidOGrtY?=
 =?iso-8859-1?Q?4qYQJ2JKgIdQfV+kL7FR5Ezk74nlaQphJaWSXh455z2ThfjASQ76S5CJmW?=
 =?iso-8859-1?Q?MSj9s50lXUh5eaCY8ARuMqddWSBfEQRYLkUZ4NorwafXsC8GKmMkm6Ep1o?=
 =?iso-8859-1?Q?ILT2E/yrEXFnekr/sqziSNdU5S5BHuVCmYGxGbfXnGbLwAp6PgehqCVoVj?=
 =?iso-8859-1?Q?w59wh+yf9TiwFCPAtbYaU8gck7LqGnXnXkV+zL4wKRT7nS5rGBKKZhR7qe?=
 =?iso-8859-1?Q?eW9/dixD0odewP4/sZIMzqynb/0sM17wnGop337ikqW74Wn+ich2qF+2gw?=
 =?iso-8859-1?Q?T95ZhsLUaO0COBbGqSdx0nof5z0Q+OQQVSykfXnuP9FfMuq/tDPnpGBbMy?=
 =?iso-8859-1?Q?CgNUHgVQHJk46miPLAxoyhQKjLKPjLDxUDMJjnPELyuFbCOFBjGetBahXM?=
 =?iso-8859-1?Q?1gLEAH/O1DZKggsPOBL/kaCFaKU94BToQckNAPldsvvcFqoF7Oh+OkfVb2?=
 =?iso-8859-1?Q?aoUGH8XPmNladAnPV/ydjcixKjlKFiP8AcHuMtR67ckANhRTHFzTT8/N8V?=
 =?iso-8859-1?Q?2vfdiwc7WFmD7AVTovqB/eHziJjeZf+U+OoKLasJJW43m6ekCypp5UdSbE?=
 =?iso-8859-1?Q?ZBoOBP0XJQY9+IR26mgSI2q2pIYZgcWvgc5xzyuYFyaryJo+3+0sRJe/9N?=
 =?iso-8859-1?Q?bLwh0VS2cRKSmwZzvKtAOPw4upRaurqEp9DZGxJRJuGAjKK/G4swv77wg+?=
 =?iso-8859-1?Q?oWVRY661ZnaX+hESRYvBqbpu4xmzJVsyc5B9AdN9a3HTtQfYgmrFHvo46z?=
 =?iso-8859-1?Q?w0m6dB3rMX4SpCo5uNIXk+cNQ2DFST3hRXu8u8oMhEj0SYO6hsrm1doR//?=
 =?iso-8859-1?Q?OthnSRIs5XkltLcICelWent1IOFg56PcKeswkeHZQmnTD4+HLN+xLoDA2j?=
 =?iso-8859-1?Q?KiD2P0jn8PKH6FxIzExmwDVJ2xM81KBkILHIlSmGTD6RW2ciurd4rfOebx?=
 =?iso-8859-1?Q?qN5uC9ZNPRIyoBkwCKojdQHfKn+trYTJcpxsOyFbopp95QEhmCgq9MNvvV?=
 =?iso-8859-1?Q?nqThM9eX3yD7YHIYfTKFX4R8XTgfG9YQ480i1rA8Fn6Sa1D8yQH/j1ZSdz?=
 =?iso-8859-1?Q?en/9oFJqTmWJwNOb5LtSFrQY0nh18DXAISQ5H3C9jOXp//MzLySboMn/ay?=
 =?iso-8859-1?Q?Ch29jx3qT6zlNJ8ti3oYjFdeu1wLz/8tAo7diC3gqgaCXsEZ1WVn3024rW?=
 =?iso-8859-1?Q?Du4hQLnavTA8kqWBnh0jQy25KOFxfKejSZGHvRUxQ75tnq4E7wgeES26pa?=
 =?iso-8859-1?Q?q2Z1UOVJhD5V4yYbLJCCYEzlhFGd6TEOOOpbrpojTRh6qULpU5hNCX7Y98?=
 =?iso-8859-1?Q?tyh9laQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?kl/jkbhIQsg6+TNVpvhf7JRUB8pluiefWSEoblJbEKYN9oJX2mGdhNBHER?=
 =?iso-8859-1?Q?6Q85Z2Ra7Lc+A7dP6UMTrBhG8YiBGfjdP0jiyfPW5kDzwARrceIxKWtmAl?=
 =?iso-8859-1?Q?0rqYyc7YCsygLSYGZkL70NA/NqFbKZ/C4gILs94xNO+J1IMvA3VaoDER7x?=
 =?iso-8859-1?Q?yFEgbrAA/FfnVDzzndUcKdUwarXsYOT5gi2og4bSsfc1dJMBN8puPNvtcy?=
 =?iso-8859-1?Q?SPwhtQSTosD3QzqWmz/S0IyAMhJN81kaQiceKOdoc/YB8XljTT65TjVLXm?=
 =?iso-8859-1?Q?dETBRTKvuUAntn8Vv9hn9PEQuAY6jcXeNAT6MSsqN3TlpxDCzOH+InAiZ/?=
 =?iso-8859-1?Q?DGAeked0ZNKQT+vBPH6BCLCx5IGWVy42CgwOEOk7xQ2JAjCQO4fgODEP2m?=
 =?iso-8859-1?Q?iHSHB5mkXlvCAygOt0hO3Aj8OqvkU5P36DB6icGfd6Efw4SqHQWvwzkxel?=
 =?iso-8859-1?Q?e2PxyebCHo+kfoEvjRAFGsq4lNud1uf2H/mutJtNJGXBBO6bUCJZYCyjxB?=
 =?iso-8859-1?Q?xPdxGm0PgLO64yo0RJWy5mfa2CN4oafzlwjqp4lkms1zAqtisipUd5fThm?=
 =?iso-8859-1?Q?KrR4eOiNkz4Q352HrCERAz5ZdvGRR0h+b7YvutjPGNhG7tI+uNV60O+hXb?=
 =?iso-8859-1?Q?nPrryRRvM3JDGQ+r4fjur3raBsjYvfK9ULbHqzOq85Z8avEuhvrr4JyUtS?=
 =?iso-8859-1?Q?2LGc7uEjls26lTx9bnZv7K5S+mxYZspjI2WXJOnyjJ/6f3FNJiyjRjgOFN?=
 =?iso-8859-1?Q?AV4E2TaEgjPpocHL6SuzFRvOVzkAZJ2ip7lNdpbFsiQIra79O2A22UIuWX?=
 =?iso-8859-1?Q?9HaBVAsV/X30JLSagqjytOOEknA/JjzLARyczJMeeX8Ln45CLidv2UGjN3?=
 =?iso-8859-1?Q?+NKmMroXlzt25ughXjwK2P0jT0G63az7V8cOLJqtYzRrix4iTJSSqNo1xQ?=
 =?iso-8859-1?Q?1KW6javeYOejvB0cftrf1LIMd+Olbp7bDQBzm4K2W8en6nR7Vy6lecM0Nv?=
 =?iso-8859-1?Q?tr4EJUFx8jxs0Ipi4OgAtLN6nh5JMqTRmwORN7+BGsvIiTwS9Pv7TLJyWu?=
 =?iso-8859-1?Q?UxW8giDRbLeRBhyqWWzEkVbjP2X4I14XtwpEx0OQMvAlGuVcaj/s5lF4zo?=
 =?iso-8859-1?Q?Sj7jx9tGKMswBSaL6l8wCno3sDRR5Ya3oj9Q2KXK0rzHD9q3vU1mfnHVB0?=
 =?iso-8859-1?Q?aLLito7fgGJOxXCK6IG0RYe/QX7pGQEpsVcthqa94Dm1SSNOorWKOP3I7j?=
 =?iso-8859-1?Q?vgtrnbLxGP/zVgEUlNjcLZuzJ5SIRNqjMcvEAZOFniolICQUYKamZQUuwj?=
 =?iso-8859-1?Q?GoYYZS/qW1XpbcKenQ07gkyj1GIWwlC0o4xzB7OlFZqpgyCbI517jnocIh?=
 =?iso-8859-1?Q?D738xsYseD4rjPHusk9wo9/kpKHEghLkG4aJt19HltM3azSjoQ+biqcI6P?=
 =?iso-8859-1?Q?vLBHSHLcUm30AOjgOgrYJw8qBXU1oJQ7gUAPfAAB0iW+QRPqUkEFWxwn1C?=
 =?iso-8859-1?Q?L/LE9rPnlOL3aADcErXoDd1t+NKSHwsQ1DbqTDpw+JNGnHS7esmPzNIE5L?=
 =?iso-8859-1?Q?lsalm7L8Ztlaa+IJitEvlE/ldpj0DqiYM6TuML0xDKkZ2vdpd8AZL5b6no?=
 =?iso-8859-1?Q?rMGPKNYhMTpMs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 35faa044-c565-41d1-20fb-08dda18fd89d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2025 04:42:14.2688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p7pPbmdthPCReO7pOx4fc7aQudUmiLe8+jPtBHGOt594vdLlyxiesoYeSWY0g7m60QDhLd3UbwiXvn5eKHKQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8853

>> I thought we agreed not to do this? Sean was strongly against it=0A=
>> right?=0A=
>>=0A=
>> There is no easy way for VFIO to know to set it, and the kernel will=0A=
>> not allow switching a cachable VMA to non-cachable anyhow.=0A=
>>=0A=
>> So all it does is make it harder to create a memslot.=0A=
=0A=
> Oliver had mentioned earlier that he would still prefer a memslot flag as=
=0A=
> VMM should convey its intent through that flag:=0A=
> https://lore.kernel.org/all/aAdKCGCuwlUeUXKY@linux.dev/=0A=
>=0A=
> Oliver, could you please confirm if you are convinced with not having thi=
s=0A=
> flag? Can we rely on MT_NORMAL in vma mapping to convey this?=0A=
=0A=
Humble reminder for Oliver to comment to conclude on whether we really=0A=
need this memslot flag.=
