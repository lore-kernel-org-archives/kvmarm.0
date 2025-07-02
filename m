Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C472376E0
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 09:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751448792; cv=fail; b=Sb+38yPHEeNO+ikSPg7sf5Nyvy/QPTxRgzZuDRHx/TbW260eHth0b3pGcQCwDGaesvnn7nmSxfVWmdYxhLYYlZfZV2nSiDT7papoAQEnG2HXZXcflH+lHjcbaS5r8w2YlgYoJBEUndQWsF+KYYH0lZDRekFq7pa7dMxUFZy4bVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751448792; c=relaxed/simple;
	bh=VAdQGkQ8Fb4m6A5sOw9uSBimE73cvWxijQ2O6CFMaRQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GeeTqtRmsFmNrS/Gg/elvDRZeNLAig/af0U1GZZLMubyxR31Wbtdk1vlk5KD4nBOtlys3Es8R6MfV/hTn8XoQOs1/nhJ8HX8OVRrW7Z+yl38OA5pH8H5RW5FezKL0cnw8mcsGict7QfeZQOkdZ+Vs4LUDXXNHa+ebApzIaQOOKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tqI6CrMT; arc=fail smtp.client-ip=40.107.92.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tqI6CrMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PG9PmdWgVLiAejn3MCKA+aLg6w6XajqVBdkK1yenm9QBljkgsipZ3ySIoMap1rwH9nkRKN6T+KaDn3GxAddl0NLVHbghDkhMJJg6hxsM+mYbUgom+ANHALhdMfmh1JS63IAv+VRI9yA8fnaqeNf2CcdVSXsd+MW9rcWPQ1jL1xyXHpL66zUUDd2hYier4lOnap2NuG2iMWcEsww9aycLj9W9BHVZRu+hP5GLd+WGCFqk3I/EnC5kNS3j/RwK6HYxJ42BfgBflZbaKd21SC8Xr6D/Xt0zvfEvAPiKgSRz8GYWTPNqUO2+boBmOV7DuWkJ6HnXWu6yD9DGw3DPhqma1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAdQGkQ8Fb4m6A5sOw9uSBimE73cvWxijQ2O6CFMaRQ=;
 b=CFOs7eMvSgRrFAMgTLSQHGH+fQLhC5v20SIrbbEhdCO6JZdnhrrmEaLJzGlUw2aAoFIHj+I5phEZBFvNV8cM7H/jMXb/S0RCSFGG7hKxlfuFXkt5N8iBGwcIZRCJ9p/KZO2y8PfVSXnKGCC9GAWWL5jo3U0Dc4/sLdOW2r9zMDq+WZJlKKF8cis+/4OMoaMDirbUfnl2qOBMDm7CLR9ALU0fWQY2n9FzEBFOhDORkfDflSU1vGgzgoJ3wFgbXzxBDqivlgDE23vxI19MNR2AjmMuhuaLvH2goeT9jSFLgizvkExBV9qofN1SmqJCLBz+ff8aNpnKJqRi2d5wbeyJ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAdQGkQ8Fb4m6A5sOw9uSBimE73cvWxijQ2O6CFMaRQ=;
 b=tqI6CrMTzNgLFdzRUdTyMPmxwQIStxTTKfB3ABrXaJtpxklFxgXUIvrPL8fFA3yfL26LeCLRqocNAsE2sgk0551xHKg0QwYI3AqseZdMH7SQhS9gv4A0jBkAdCRReXcGQeJtrWYMuaQI2EZl+GAp61ir5xBL+NP9E6BkE+5SbrePcvzXpIBWe4myoa9SBmoTGmIpAozhLoELMZLFpua7tlzayfbdSCFcaH8p/t+t1QDGqP33c6oTLa8sYBl1vazyquv24nTdyrfIWbAlAM3xDdstY7+pCyBCv8fxtGA8ogK9Eyu5PdK/otumNZpDPtthDts6utgriJ7YVngneb5aDA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ5PPFFA661D690.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9ab) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Wed, 2 Jul
 2025 09:33:07 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 09:33:07 +0000
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
Thread-Index: AQHb4mPxHvLAi7AU2UCiiYmQowcOkbQeo1Ok
Date: Wed, 2 Jul 2025 09:33:06 +0000
Message-ID:
 <SA1PR12MB7199F8346F2CA802E9F3965DB040A@SA1PR12MB7199.namprd12.prod.outlook.com>
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
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ5PPFFA661D690:EE_
x-ms-office365-filtering-correlation-id: c0d51525-ed16-4999-e36f-08ddb94b7398
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Tb1tyz2rKdAal7dbRBiT878tQ1eV0AWkGaC1/wtp+dd4vtvC4EEGwxAq3M?=
 =?iso-8859-1?Q?eGm4u3Tfm48u6T8bdmlOvc1DV2IxA1YMV8+NySJrckAgKxn9iT6LoeYEX1?=
 =?iso-8859-1?Q?xhNn5pBZP8SVUDINjV0HmHHneQPOz5anVsGSYfTXRybtOiKcyud8mAB8CD?=
 =?iso-8859-1?Q?yc3j55nxnRkMUaWnEd6lR7HwG/j1MO/6JzCHxF79AopLY0b9hHTLQIaS5x?=
 =?iso-8859-1?Q?+gvjX/L2XD2cEt1uYTY4+Ac76wCz7XJPrl5WDywQN9yp+qDJXbGpS44ZBp?=
 =?iso-8859-1?Q?B0RbTSaFLTPbZsMcNmnHuVVeKyiuwTDhtAFHk0hKINtHDxGAYR2JpQTXZ0?=
 =?iso-8859-1?Q?fEMgkf0gVtnV1QDBQp9rboaJ3fhUHzwC+RLQSN/egO0k0EZgY2Y7ltKGDU?=
 =?iso-8859-1?Q?p7U4qN1mR3OHBvgPBDBqVBoPDgRzg3zjoxSYTIw5HIqIzOa1u9cAjgdvdK?=
 =?iso-8859-1?Q?wqtXGO9tL4+wAweNlW269w/NTEJ/RGRUUSCJi03GkvYCTWHg9WmZBCDbUH?=
 =?iso-8859-1?Q?R/cPvl4GgVlmhDmAQiNpve5hIVbqZ/B/Qi42L0NvI64GAcFc2j23qIc721?=
 =?iso-8859-1?Q?H/nilBcdEYjc1IyjQAxv2qaih5xolExhWEGT+rNXQ1HHi41cmfnoRhGPH4?=
 =?iso-8859-1?Q?II1wU+OvNFQ72KIwYj0OG7BQOcwmXjsb6TC/Bv1yj4RFzNTDM2CYOK1B2F?=
 =?iso-8859-1?Q?Zy9c60cREJ9r6FjtssqmBsSSaPxHWyby8y8HdI/yyc4vX8B+wRlHiFQzcs?=
 =?iso-8859-1?Q?1H2MzR1jB4u/Nsn4BtI4mz+0G4rUfsP3VowU/aX4cfYIi1mSrqolIGF7yx?=
 =?iso-8859-1?Q?BQzbz3Q4d9+1RGuV8sUtTb/EBk97NqK/+5vj1DCJJ0hgrY4B/fD/6qrSbj?=
 =?iso-8859-1?Q?ZAorFNqdwtOojjMaUb8pK5xkNUTfX6XebiLWlSZl+5KrU7qxLCWLPulFhU?=
 =?iso-8859-1?Q?taRe+iTNw+R5dZ99j88k50uvvOqL2JghcyFtynmNPB53QJRrsOynByP4nu?=
 =?iso-8859-1?Q?D6M1IwgBUAI7t4AcJ4ciqt/nThnI6/bsN1AQFSVJANZHaEVe45Dx1sjOcM?=
 =?iso-8859-1?Q?U4c7jjpDeMY+mPpwmAR/CrCXKBcHqKq4X+vW3NBlZ9PoYbB8SNkYwFlant?=
 =?iso-8859-1?Q?wjOfA7yJlh4uXGmt4/5Ieh9Y0Z0mjyxrQeRETUc6rmDr4byy9ZUV64r9bj?=
 =?iso-8859-1?Q?4yE6873SQqu/zpE8loDxNQgSZppCsQqAvW0BkVeCel4B1hACJruVbGlD3b?=
 =?iso-8859-1?Q?eD6l7wYqjkjVgowc/NEWp+Ntf205V1hIecl2QF8kTiL9shMs1qzKXqmKo6?=
 =?iso-8859-1?Q?4rsxFEtuhIyhp4jIg/5KRNGYn3uktHjIscpDOwTADn+BBPjI2yat+Cd2ze?=
 =?iso-8859-1?Q?8Vg2hE80sWDKc3gxxGXsugpUY0N4ypuZZmkso0fSKCcndfF3OlWAMyRk0X?=
 =?iso-8859-1?Q?rS89fbqwcj4sug74PrW6TcckPs8vWKW8ZetUnKTZbzgRL6kJmw/dc1q9qC?=
 =?iso-8859-1?Q?vKtzmIpToGAuzh4q7gKxHEKcgnvOMTV9Jp4fBntxnFAyh974Ijsk5k1QGe?=
 =?iso-8859-1?Q?y3JbqQQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+2+Sh0PSy7/g5M2FMKfXC2kWZKVCpumIv7QL2x8FubcuD1K6QM3vlzz47z?=
 =?iso-8859-1?Q?ss6LwPFI8VcMjYHlYEbtCvZ7VzPFAPtOilPObt2MpxDNaeQj5mF1N13bRr?=
 =?iso-8859-1?Q?+RIjlbSlXBMDIt99hLilZf4ImOco6IGwip2iuvZjEApRvRJ7oHJymBKWzz?=
 =?iso-8859-1?Q?1FDercG+ZmjobKZlhAI3J64VJgaQTY5OfPL7jNAW8H//xOfzZj/oRQLPeH?=
 =?iso-8859-1?Q?XkbkGoUbdcTd41VupvOi1CNzbB4iIPiUqvMIGBP4NW0xw5yKDWUHJ3Gw9l?=
 =?iso-8859-1?Q?E3RGe7wg+H3tb6LHmEIngakTc/GDaOE7FYwGEiWnviO0+bYYl90k4oizFl?=
 =?iso-8859-1?Q?J6LVXWl7Ykto9Iaw1q97uju/eDO5D6NL54mO9IkqcXSTsdsIvTmTSxkTCn?=
 =?iso-8859-1?Q?76oTCAQq8w2+f1PyfsBKjjo1m7kfyMdpiKETmZaKVijsN5wp2V8yJkPmhf?=
 =?iso-8859-1?Q?K3JMKoDeeen1yIkZvQdwAnYSmzwZ36xm27z/CRCJrm1onT7uMfyubAKNJO?=
 =?iso-8859-1?Q?/N/2LpxTpYakkuyEHwlwqW5oBBrfM+R5xwpLhoKpJndCVidEd1Z1b/lTyI?=
 =?iso-8859-1?Q?mGysRGVU9QE8xD6CFA6iMk77TJlWFulat9c1paRlDm/cePR1fnxpknczOp?=
 =?iso-8859-1?Q?JKVcXiiS5xzqgg29wtkynC8q+7zpq6nVhWiwSQF3FMXeVqd10f9OWf7GPH?=
 =?iso-8859-1?Q?MOjMzTgUKNT4qjGdMARbIHizLKTuHcBNPW38To/13yLd55F4w5aIfAtwJK?=
 =?iso-8859-1?Q?p2vQbMxcJH+9WuW/KJWQDmZHDtyEL6LXUw8kkE3txNaarYPFZYWXj9VRo/?=
 =?iso-8859-1?Q?qwtyxw4j3cmeNkJdtazgSF1W/mdmAZpzlb0JHDq4GdL81Y9T+x7PDSbHFq?=
 =?iso-8859-1?Q?Nq+0mEkAuEFaawuzcVrpoIDEcB2hfAdYt7Yvo52lRjAJhxxBmlGAzoSgmU?=
 =?iso-8859-1?Q?yayGl0/AXHwugkJg6gxh5cioJzGissN9K6PILnTfSW4iCUVcpq+pv69TX2?=
 =?iso-8859-1?Q?L3kVKcc75iTfNAe2ttxmKCylTC97xqOq/vE3NG+YxmSa7skCQKvQgl07hg?=
 =?iso-8859-1?Q?wt3qyYqPziY5Fm6c90gy0da3prntSoUWmh6vF2k3e2ImguOnWsxWRV/m4j?=
 =?iso-8859-1?Q?EKSBz6dyTTinEqjvKRpFf2kM0PrauOI9DgqbxWREMFKyGIxKRXCZtg6Jyi?=
 =?iso-8859-1?Q?T4BcPl96eCk0c8hDtp+/Q+AC/ZsZdyTGJZEmDHgZLgSzf9eYnmnL76XWZO?=
 =?iso-8859-1?Q?yuzh8dQ4/TDU11CYvE2zgtR903VChi16phMbenBkBgwMM8Whdjh9gO/k/5?=
 =?iso-8859-1?Q?sbkd8ZZDIK3HvOqo7JJ3Fpl4t3fTcqGtakINyFCVfbgcuAZdzK52Go7eL4?=
 =?iso-8859-1?Q?qaB/6MK6farHg/tv0eWVagUV9uU7oeZKF1s++CwpMbx3XQIgdK2j5E2+rf?=
 =?iso-8859-1?Q?u2+fBic9AvjMcUb+7woe1NxiwaXVqmR/OvH7MmrApRiaexD+b5jve7Vsv0?=
 =?iso-8859-1?Q?eJyK8aOQfC5HzeQSEOXBNEIJaGxotzm+0D9XhXEtRf+17ShAFj2mcH+HTj?=
 =?iso-8859-1?Q?DQr+FMpTIPr/vcvV9aUba4Mtsc2Nf2toFSoZ/3yT+/5oqqSM1nTk+Gxe93?=
 =?iso-8859-1?Q?a69oIF8g3E/Xc=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d51525-ed16-4999-e36f-08ddb94b7398
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 09:33:06.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bS53zGTec7sVWMaIbRPKB4c9zpSRb/NwukWvEaOeDONX3GQJv14RghnawDwLqv/fq5zU+SoXv34xg2oeHlYRkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFFA661D690

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
Humble reminder for review.=
