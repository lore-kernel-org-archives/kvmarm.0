Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567411E0E00
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 05:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751000601; cv=fail; b=og/KKtmpYOrClUd33SmO/T0b1ZI75Lvy8/uA/jUkfSeMpy9C9IiUjKQ2POLRbBZ2F2TdGEO3Lo0Ah92dLyNzmPyXV0Z6YXqDjHJzQZC+pB4gk+bsjowrpFNd5vjzcaIRpY2iljpK9Hphz6EZAZt/PZU68zwcv3gJmgXDFc/dP9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751000601; c=relaxed/simple;
	bh=1P+kkNyNWtrVVAwXIWPcQvIk9QUkl/uFq3PF/QiRY6I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MLzJguXAvZnDELsPqTs1Vpc68k/k+UewwRFYV75VwFYrLR+TB+0uNMhM1BftzAPQtkmfV0s0jatZ7v8usim7ViT2jxRFUNF8Rrs9+NxmylzFoCkwsekuSIgQn5E+Z9fZsEc8R2a/jOrDwUDnj9/Zt9o5MNa09LIZmLuvSeg9FJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BG2Bm8v9; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BG2Bm8v9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUe9MXzkD6hjY6pBCdRxF/3dLadlJr7V+Ptc+Blv8t81qdfApe1b5GNOuq/5pRty2zBKkSwOKnmJVm0vk1LWj5A4ROuwrzHgAOPgF8hErBAyL3zwsAcaBekFSKwYpu6576cFtPM+isjt8qOKGtn0eABc6/7zVDAXBXAOVhZ8JA/Drc4C9fXaZPl4cF4g0qamxLDhSM+agnUio8BpPbLRcmp8cDBz2GG3J+EMNr506UlkliNENzJTgeTAGC6onAJlBgELoB+P+bJ3FWoUrN/pZwQAFke7VeVIN94Iq9KMIFSMJ+E3kZv+Cl6IM814lGw9F1YeCmWpCvrAEWFJ3tRWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1P+kkNyNWtrVVAwXIWPcQvIk9QUkl/uFq3PF/QiRY6I=;
 b=aMiGE7x3Bs1JfxHn+nskdI9tVge01tX2kDPQd6C0Bwo6uuQNL5FgEJEpIegqzyTIlyCoT5uHTMfyN3Zywrtzp13Wuu0FjPtbRavdQGvmRxAccH5/P3kU2oVu4A9uaeDfrp9/JE+KvD9xYKRc9Rt8/H06HhRKqi7WyVMpNVK1dCR9fUlNrgw7msIMOk2CTrOiYVwEA/jlhmlxZIGQiz+5dGFduqG46N8N7PNxXS8EcGE7hnrvvlFgAzHl1vgVTY2ZKResxWQkh8sY8efgRSpgDVwTlviS9vMLb5y2VB4efazM8AUe5d5z0lye4BFYbjsdtz3dGOeG5A+OB/L1LaM79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1P+kkNyNWtrVVAwXIWPcQvIk9QUkl/uFq3PF/QiRY6I=;
 b=BG2Bm8v93J+JQ8tIb9ZF7VoQnKaxMxaRBXTHxFWpezHyVSceTjbW1tdCJVv6G/wBu0nuZ60STiuwFPVy4oqa6ii/7dhdkHmbUMAzBjBi1Q9eSRfidLr3oajPGn42xXSXUVeB7DfDzfiRPM4I6hzEBAC+Ps81ddgrw1nueAUJlpnhxKMuAPJTa6e0fUpwHj0GzQBHUA52JgomBiWod+JgcoOi3uD393DoX2QWL5ko7zOjrc+82kIrMOWQl7i5ae51OXgoof0J1cm68d/24uWb09bm/yStftVXJnK795ZzbWpOiYYTHoSlLkZOZ2Owuv3nJXyXG6TnF16RspwitRfYYw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS7PR12MB8082.namprd12.prod.outlook.com (2603:10b6:8:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Fri, 27 Jun
 2025 05:03:13 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 05:03:13 +0000
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
Subject: Re: [PATCH v9 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Topic: [PATCH v9 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Index: AQHb4mPxHvLAi7AU2UCiiYmQowcOkbQWfAa7
Date: Fri, 27 Jun 2025 05:03:13 +0000
Message-ID:
 <SA1PR12MB7199C4F31576787D0400902EB045A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
In-Reply-To: <20250621042111.3992-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS7PR12MB8082:EE_
x-ms-office365-filtering-correlation-id: 125ff6e2-ff33-4593-f5c3-08ddb537eb3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?wwpJQcfYjKxmaOaNnp7Twe6CUTz/1psDnETHL/vIS5B0wsfDKnh/HYt6Mz?=
 =?iso-8859-1?Q?SrbaOhOtW4ljrcaNjyiCgyDavLKAzKL5vwRntPpwvfDg+4rvtr+Qz3AtmN?=
 =?iso-8859-1?Q?3t5A9hdfOfTIicZBLUbivWZYSMjkDmj/NhKBZ5eUn8iJgPS6fQzkFWRbbu?=
 =?iso-8859-1?Q?jmnY8QwvciLWXkmJqOz/Jwxve6R5sNvPZc8EymCugjYM9VQUU/WzdDANZh?=
 =?iso-8859-1?Q?sMTHAHOKVWxUBIrunTcZNSMdo1NDlp7nVzfc6+J0ZViGCaVR2lE49WsAdf?=
 =?iso-8859-1?Q?Y1PtL1z5qDVz/+DR440zR3PgpDe15BVRL9ZRljGFf1IeSr8M1uYZBSdMzm?=
 =?iso-8859-1?Q?brSQP3Sg4RepUIcFiIOSmAXvUozWlFkXZ25TvfwNzr+Kb3L30GLHn+jIVQ?=
 =?iso-8859-1?Q?bjoowKExrMFxE/8eUBg4jo7ZlPGiEqUI26wKGfHz0PXHjzbJeVh1DH5IWz?=
 =?iso-8859-1?Q?i4LAxM+WAWRwGyHnDBaPnatGWr0k5SoO6Lls8XdbNX6XVuxIXsU2LUfvxj?=
 =?iso-8859-1?Q?YGcFayATOYawvysKA+jrmBMTC8jtJuU8i4egmZl9qy4yK97FsPr87I1s23?=
 =?iso-8859-1?Q?oQqgWc+muFTdeIWVVzWOpU1N1arW/rnMFJRen34sC3yAHAxnOtTbhtgLvL?=
 =?iso-8859-1?Q?vg9lY2YOtTTVZX/8UwLtFwNprinfpIhbFqJhoCoJcuw11QD02u0NXUIY4b?=
 =?iso-8859-1?Q?wEcyIbCuoRQP/40gHsNTyeBh/gaYcdZILuVwKij/g9aVSaZ/RmfmIPfJnz?=
 =?iso-8859-1?Q?WwF+x3/s60nVJorunbzvPkGE5LOoK7oMBVzUfO6QjIBjNpWPVtXmYlb4GA?=
 =?iso-8859-1?Q?83pPXewwUAEJvRtC5rzzxn1uU0POV/B6Fgpe8zsyn+P2gdKSsQQrqZ/mtJ?=
 =?iso-8859-1?Q?PECvte8SkU3pu5sOBSy8alIo+CYO2XYVbyeHctzsxnq+I5CWVUPL2tUV3R?=
 =?iso-8859-1?Q?fsCJR0T54eQaz6dbaD1LjkaaONz9M4OU6TcYdqdQAD18dlcN4P/rZjAj8V?=
 =?iso-8859-1?Q?4hO2k416l2+20S9xLxTXmwk8UI8cmiHWjU1EshtP2ucBxvDxDYRY2/2DUX?=
 =?iso-8859-1?Q?03RRHfAEfNXwIX6GgRzVV0OxVmhexquaDOC4ubGb+evS8850GnCDjCaiNo?=
 =?iso-8859-1?Q?vRXrT9PcCKRhp3jsH4LOtNAZi0/wNh0t6C84TW5fJafnF/nhjchlC6wVzb?=
 =?iso-8859-1?Q?s5hJa1nsZkKzv+8Ck1vCO8PA3teQvsRE1ZeJOTLwmZfChAYc72kI5BRJDO?=
 =?iso-8859-1?Q?U+Si6aBfOTCFmQm8CTS6MLVlZbVRJyDBpFsa3ua4qqNU5zXCC2OJTJC3h/?=
 =?iso-8859-1?Q?MnG8pJ61Io09J5FkPV8Ip5PV4J/o6yWphB2GKZlPvKUphX0jl9W6128RCQ?=
 =?iso-8859-1?Q?LJN3qLjqHjmK4iKz7pQ45tJOcajCMRGp1iROCi5bpErWqAhrdnR8VNadjK?=
 =?iso-8859-1?Q?31sKAbagY5KMz+hAg0d1sDeNR5UFnPZW1K54kQJ+Nqn91CNAehKK/jGREK?=
 =?iso-8859-1?Q?ePYSRuEoGQr/mAFAVKBqjiDteKA+xPYqmtzOzLRVlOU5wC0GGWQKKhjgc0?=
 =?iso-8859-1?Q?zNnE5iE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3LvdciFNJxPG5n754ujksEpwFgfVO/+8ZtMh1kTaz4c4QVixvf3jEQg+xD?=
 =?iso-8859-1?Q?4RFmmcMMhxOlKX/MENWMP9xyf/BvQf6ldII7gmH7YNOu8zj4STgZpBs5N8?=
 =?iso-8859-1?Q?ZOUjGokHFRO52wqc67N5wZi9e7jaWldjHewgPN/NUCsY4fe3N0Fqp3p45M?=
 =?iso-8859-1?Q?oAogWMlzQdLOdxVKSiM+FiG6SMWcrxfoweHGGCekB0t9EKuyLt3jLX1t9A?=
 =?iso-8859-1?Q?d6iS1uk2oAinZXpM/PPjaCoccOX0qmQcR/e+YzY1deg+NAIH9HCZZYk9l8?=
 =?iso-8859-1?Q?W6oPnLFc+oIc2ljCw4Iz2bVp+Nlry5+YnuxfiE6puTBxtzANPFBZZuZibl?=
 =?iso-8859-1?Q?NTHcgoitiVeghzpfI6yueY3+HNKbklyegPp8P6s6aHEBcSRjuLtWyYf330?=
 =?iso-8859-1?Q?QdXE6h2Dd1tS/BEaBwMStrdaofuCNf1/4MnlVNKhG55KifUsilR0xQGoY4?=
 =?iso-8859-1?Q?UD1+GuCjgy5wAPnxXCPL7vxA4tnLCjErYd0qKtWa6Tv2FKd/BGszmxI124?=
 =?iso-8859-1?Q?gYUPB8VczqtY6As7hXabhspdOMh9/fkV3zpoiBWE2FlXT33o2tCO4k6wys?=
 =?iso-8859-1?Q?LFIBf173tKoTCUGBBrjsxDrfwCTjlRj0X9c9pgjJzU2+fJPA542IFrSk4H?=
 =?iso-8859-1?Q?PD51mZ96GFiHISuYtwwTG3yl+S6iZNhi9ZxgCwSfmd106ivGQOQe4CZBje?=
 =?iso-8859-1?Q?Tlb4c+EkW5Pu/pbIstsN1sqfI09v2Jff7UrVmkz3FoXZD+rBuRtYBAbspn?=
 =?iso-8859-1?Q?cWC8tUbBaTLtSKUlBBa399fFWVouevl1PsLUa4pbDlqCI9H/fp9J7MO2Sv?=
 =?iso-8859-1?Q?7V94xdrWekwtayIaIGCbqYkX2VxMush51Mn9DAzhSMQ4rPtpCP9ueoDKOO?=
 =?iso-8859-1?Q?P4AXy/2NaRzMJkzGZK4xrOX954sG9dTfbWJ0BwmA51rjmD1y/69EQ8FeUF?=
 =?iso-8859-1?Q?exroyBDLTcr2hB3HgsclU5fYtJtq3oI7O5J2a6YKZqpmOiArZ0PEM3+4ck?=
 =?iso-8859-1?Q?iFscE2VHuZZSdo2A2ebScXGih+IoCLHk7EvYI/fp07UXKaMJ9JJnDzCJCL?=
 =?iso-8859-1?Q?3jM6Mw5SCR2yGPFLWcqW/kC90hXLWuIMf2G7n8/Yt8IFtYitY176+uy+i1?=
 =?iso-8859-1?Q?rEbbtrQ+LBLYhO9SZ/yYlZecFn8lvZK2A5V6Sls11E67iik2CBNjCtUexZ?=
 =?iso-8859-1?Q?MKkhd6XXwAoGVzZR+Z5qnwHPs+gsHi2ydKIC+22WCAzm26I5zu/Xky2E11?=
 =?iso-8859-1?Q?/F+6oVkM0EDlswk2FDHBTz/B8QB9hKqzDIxI3dQ8fUyxC8FwJ4Ghd9b/vF?=
 =?iso-8859-1?Q?3l2RRKPrLHrUIzqpeEOXJC2mKWK0Lp3Rg2TJDRlXD3TUqmQ2z2hPR/AOZn?=
 =?iso-8859-1?Q?sEVhxujI86aEGL3UVvCbjLzTeDrLskd2sPATAC7Trwn4cf8IHV8L+OZgly?=
 =?iso-8859-1?Q?7nJJTCrBLpho4P4TpsXyzarPc16gwQO7TzKgY4Px/ZUFRfEdN7qyfUXean?=
 =?iso-8859-1?Q?Zthpdn3liRPbAPcAAM5V53JBU2ZaSk2/fbhs7xMl351K504m3637EXbNIU?=
 =?iso-8859-1?Q?tJC2y3LT0aAfdPQjLec7WY21pD7RY8CvksYXmpOy7uPx8MA7tF1EvjToSg?=
 =?iso-8859-1?Q?pKYSEZRYZ1/UU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 125ff6e2-ff33-4593-f5c3-08ddb537eb3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 05:03:13.0584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHY5HVdGRMC1jgQcAeT3EOEBXaHmnaoSXx9xQ05r+pFgNishBt9nA0e7uz9JPhvaTbiBcZuT9CzDedVpimRLRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8082

> Grace based platforms such as Grace Hopper/Blackwell Superchips have=0A=
> CPU accessible cache coherent GPU memory. The GPU device memory is=0A=
> essentially a DDR memory and retains properties such as cacheability,=0A=
> unaligned accesses, atomics and handling of executable faults. This=0A=
> requires the device memory to be mapped as NORMAL in stage-2.=0A=
>=0A=
> Today KVM forces the memory to either NORMAL or DEVICE_nGnRE depending=0A=
> on whether the memory region is added to the kernel. The KVM code is=0A=
> thus restrictive and prevents device memory that is not added to the=0A=
> kernel to be marked as cacheable. The patch aims to solve this.=0A=
>=0A=
> A cachebility check is made by consulting the VMA pgprot value. If=0A=
> the pgprot mapping type is cacheable, it is considered safe to be=0A=
> mapped cacheable as the KVM S2 will have the same Normal memory type=0A=
> as the VMA has in the S1 and KVM has no additional responsibility=0A=
> for safety.=0A=
>=0A=
> Note when FWB (Force Write Back) is not enabled, the kernel expects to=0A=
> trivially do cache management by flushing the memory by linearly=0A=
> converting a kvm_pte to phys_addr to a KVA. The cache management thus=0A=
> relies on memory being mapped. Since the GPU device memory is not kernel=
=0A=
> mapped, exit when the FWB is not supported. Similarly, ARM64_HAS_CACHE_DI=
C=0A=
> allows KVM to avoid flushing the icache and turns icache_inval_pou() into=
=0A=
> a NOP. So the cacheable PFNMAP is made contingent on these two hardware=
=0A=
> features.=0A=
>=0A=
> The ability to safely do the cacheable mapping of PFNMAP is exposed=0A=
> through a KVM capability for userspace consumption.=0A=
>=0A=
> The changes are heavily influenced by the discussions among=0A=
> maintainers Marc Zyngier and Oliver Upton besides Jason Gunthorpe,=0A=
> Catalin Marinas, David Hildenbrand, Sean Christopherson [1]. Many=0A=
> thanks for their valuable suggestions.=0A=
>=0A=
> Applied over next-20250610 and tested on the Grace Blackwell=0A=
> platform by booting up VM, loading NVIDIA module [2] and running=0A=
> nvidia-smi in the VM.=0A=
>=0A=
> To run CUDA workloads, there is a dependency on the IOMMUFD and the=0A=
> Nested Page Table patches being worked on separately by Nicolin Chen.=0A=
> (nicolinc@nvidia.com). NVIDIA has provided git repositories which=0A=
> includes all the requisite kernel [3] and Qemu [4] patches in case=0A=
> one wants to try.=0A=
>=0A=
> v8 -> v9=0A=
> 1. Included MIXEDMAP to also be considered for cacheable mapping.=0A=
> (Jason Gunthorpe).=0A=
> 2. Minor text nits (Jason Gunthorpe).=0A=
=0A=
A humble reminder for the review.=
