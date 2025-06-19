Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB763085B2
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335284; cv=fail; b=FvODcDlpYZwyZYL1wMUHRo5Gj/T7NzAJNIrM0epr7bh6EldV36f3bTyOXAprR6muV2cOS6KuV4RvuGynbi/V0qD43KxEKC67ilVYeJPrCc/Tas9dMbcIw0yDZkeym9N/h/c0ODyA/Oicj+C6NhYmxw/CTZ5W1Jy16nClNgD6NL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335284; c=relaxed/simple;
	bh=oYHa+xhmAEsQmTuIvOfPpiBz/ZwO9TUHqa68Mh93vqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rX821FBuTjYXq5wzepiPNGXn19GE+hekhgo4bjHP3ep9aZaP1UXNPyZ6g9omNHkaj3JDO5XGWa0+VG3p6Y+ddJ1L6Oh2xguJTAu0d1TUuewjiEB66+5MTxb+jgGyREKzoWrB7AppKiD5nBDp7Q8ZNIfGVvQCbG8/+VLTNnvG73M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I5na4DTO; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I5na4DTO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DGAUrwTgH9rzsqS39BheJzm8oH3FjyZejyfxan0RqY7QksA1VEqhRnBexBzbimWP9i4nakVVu5EEQRdPez1I9iyGcoRBGeHvPAj23WocCO0kwEKm64pGUkTabnkvOzAxnZ9l8jJPW70li6B+oFW3yv6ervz7800fLeiRuS+BLVTm4/f4cRMus9lNbiv/SWV4I7pOik8/b+RvqP48eCuwf/mMD/7CUVDN4W9vEm+PFmCRsKVB/ufUn9gO7wJa9jzwzpOSuTJXciel1ZAHr7ILQ7nObtWwBog8t+N6exE3oZB73Dwp9YlWeXo2Jl3Apuyzxd6rrei4MMXiyfFoOpP9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAUlKIzfkKlfy2UtHqZ2q0kg/TFW9kzAsO6+SUzrGgk=;
 b=LAxZKFT+MGwMsTdVA339ygbufTbernM92ghrOL5J6kyzetEJ/1U2fpPyZNuk3WkatNjszzSm9LPZgLwDbUiyrPRrcTdvJ0WSUT31nqIVgZoA74/fFYnqJaXSu0WCWprms+HEWSukLvtrTssAdo4tH25SY4aaG3t2D6OPkVXIyeZRykSSrKZaQAA0BxGWvkHe8EaBZyIHgNltHueVJC1qd4z+u2Jk8cYyZTkkGHGPID1yRb347WRYr35ZxEEwm0xg7OE1t2+s9NYXzuDvhXnCXmt35WyIQ+eo6N2oSEZu4wrhTqG9LM5pi8YDG2IbjmXaCsUq7ORZ6yyIfhFCw39lEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAUlKIzfkKlfy2UtHqZ2q0kg/TFW9kzAsO6+SUzrGgk=;
 b=I5na4DTO3wMZaJf9mypnBDFRQnn4KFWBEbKAJz/NHF47D57RXRuUAbCRnF/O0tomyvpj3J5wXIbe4nej92u00k7gQm7HgoTgIdWJgE3+12RQ9NZ6FcjsSFDQnu909syhR/iwBsNX/eUcq/TWQpS6VtBGzUc4+2dklak4heuk7DG7gTOvNny8MOfEmn/InsOpUmdvRR97tMzS/pwzIjsH0c7KDUXKoTZ/T/5a3YaSW/mUvkSQ0Erioqdalv9Qb0V7dmXugY/d5nOBzCB6qKZQ7Qq4Wut9hXpbm+g6d8mxzuHzAFeGoySA5zj4pu5b/8D726/xyPQK+ZTvRw+v74FnEw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Thu, 19 Jun
 2025 12:14:38 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8813.024; Thu, 19 Jun 2025
 12:14:38 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Catalin Marinas
	<catalin.marinas@arm.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>, "ddutile@redhat.com"
	<ddutile@redhat.com>, "seanjc@google.com" <seanjc@google.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
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
Subject: Re: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHb4B4TbCVSGMT9r0WVitf7qIEAIrQJHW0AgAABNgCAAUSpXA==
Date: Thu, 19 Jun 2025 12:14:38 +0000
Message-ID:
 <SA1PR12MB7199835E63E1EF48C7C7638DB07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-5-ankita@nvidia.com> <aFLqiAyXZLoOTepi@arm.com>
 <20250618163836.GA1629589@nvidia.com>
In-Reply-To: <20250618163836.GA1629589@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB8033:EE_
x-ms-office365-filtering-correlation-id: 2fcc1de3-ea44-452e-5086-08ddaf2adca2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?XjWZQk45uapJ3DJVWIiNrkvQjvwcb3FQP60f9akNWcEEVwWVIMwvrDmxCh?=
 =?iso-8859-1?Q?HSSZkIICwJ6oy/CvGs+Cv4t/ZLr7rMa8vFDs+VZRS1qTTmZhiUsFiZN6lE?=
 =?iso-8859-1?Q?GQbFhFWUKSDLWiy5r/aQ7XewQ43qFL+KKRJRCbvfI3Ljb1626Vf6ltvPsO?=
 =?iso-8859-1?Q?1A411avwSGXiCrxGxgEGzNIyg66j6lN6vaL0lxQivYl5q6iCNo0WIGrkl7?=
 =?iso-8859-1?Q?4eOw4OK1bYj4AsWUQ9DprXAAe9kiN55ky4a4v+tAuwILxfNrE7xM4Y0S5i?=
 =?iso-8859-1?Q?Uwo+dLWe88Z9TztEPbT2hBEveEraqaO9MIUaXXjEMxbq64piE7kN4Q7zz+?=
 =?iso-8859-1?Q?P1feUNa51nWrRBKubza/UPg1fvo8z8NKHmu8Jq1krVR8vfsnQrptee2wvK?=
 =?iso-8859-1?Q?rB1u3Bn2XXLQlTLxq5RavWa5r820IreFdkJ7iMCGXQ/kjO/S/wrR0P3akC?=
 =?iso-8859-1?Q?qtVC19heRcshzwVfPbk4ZbZYo0GSvkRFH1NlYx1V/aLNmEbs2UuqQr2WQJ?=
 =?iso-8859-1?Q?HjRiUBjnyBxGHgM9jUzyoUv6JMNugf4WApVL3cj5PSgLvv+bab/vBmK/gO?=
 =?iso-8859-1?Q?Z+5jrUyoy5VhypDwqkKVgsxEDHyINvu/BjwtoVT3+ZvgMAbaq5Hl7k+/Ft?=
 =?iso-8859-1?Q?qJ51Scta3nRx6zFyEZJ21NxgFesZvogh7D2tBDMefxFiJ2EVpGyPwP3MuK?=
 =?iso-8859-1?Q?/oD+xojf+f+U4TLw7C8yZKpiClQotOyI3TqL2ZVOJy3AOOHTRzS1arq6Yd?=
 =?iso-8859-1?Q?Luon6ofRkyF5E7IS4balC+ij14cJawM/XMfqv1Kva+FtsjNHhYy0KWFt1h?=
 =?iso-8859-1?Q?WXCpVpahzAzvCs0ehM6wN3B+zSFrr4W85ygyyKj+VIuip5wDNy6VkXLWdN?=
 =?iso-8859-1?Q?Qzl8itFyW7sHmPvohxltyAn2qCWNMijal2kejvHbSYrSyV2eR1atsoJPkW?=
 =?iso-8859-1?Q?U6Jnl0QEs8KGyeH01FoPwLT0ZjgTfBwB8VavZAwkz/MrH19fQVUwniR6YB?=
 =?iso-8859-1?Q?MsmTcmz5691POcNBPuhp8exkIXm3DJF6ON68GaS8fK44ELPn1d8EOfnBhb?=
 =?iso-8859-1?Q?hf1R6jWjV/0X2ZyuHxjQGPnNBGMEt3IevABytw8hH85F1wk+WPpAbCSfnB?=
 =?iso-8859-1?Q?Q1slR5sb71u8pphMEkYl+vNiroUFNYTwqneqH+rPRclw09OALTJwycbEbs?=
 =?iso-8859-1?Q?zG6+/gjbc74VbavFAeZF0/64eIbF7FDIa9jrxD9mtBWsdtM+SKf9rfWw2s?=
 =?iso-8859-1?Q?Izl2WpMPXHL/xrAYBY88UerXrzGVX+Zw3kHn/PLtmF9hZ8pFwG/wXHZU+T?=
 =?iso-8859-1?Q?81m2MN7NfbDj7LU41kLlpvNwdRbX5ZZpjxL/9n/ItyhLJ/MbVSC/CnhHwX?=
 =?iso-8859-1?Q?5Fi2I2hIRmWOij+BG9wgPL+/mKH7FdCXxei9H/u3rKfvhg8aUeBd1BSFEo?=
 =?iso-8859-1?Q?bp9U/emwUcasWIQ9LqNHNT4ZK2S+t0ozyFpg/caXXNrPIU47zFIgymhCT8?=
 =?iso-8859-1?Q?cQgscBEUJ2loXDQlc8UoyxDRlFm9ZM77c/tg7sNLWDVg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?qeB30cwd4z3DnsCKqVdj3AOwHw/9bAok5rYf3VvIshW0+YlJPUWLSextAo?=
 =?iso-8859-1?Q?O6+oHHcYBeyT7FLqJGvH5SkElRSPVPBV48E2clO+eU475ecjLbgNFaXWUo?=
 =?iso-8859-1?Q?GtKSlmQurk/W2Dd8sFMZLLsx0JE0LHnRA7b89t0nLce47/YrUiFYmaCayq?=
 =?iso-8859-1?Q?ES29N8u30liGblC1wbV25KNxkJC82AiC51hYX8t5+mnaQtAdpbcBZ7fww/?=
 =?iso-8859-1?Q?0+MgX94EaprHPXoioFUaPEZFMu61u/QdtEycn4sS1EzMlnN5ACO21BwiA+?=
 =?iso-8859-1?Q?ueeQZM+N/xlAun9LW/Rh7WqJphntZ0Xq9Oyt4MjlaOxzDUDfXoAIxjLKs6?=
 =?iso-8859-1?Q?txHfszCJNOnmv1vrcwgRrG594grIQqdUj2je18VX96c1T5w0HOrp4cYubT?=
 =?iso-8859-1?Q?yZG9C0NbG3Z37nqCdNooridw4Y9hQg4Ba8tQZ5pBEX0ZGBSiPtpC6tobPv?=
 =?iso-8859-1?Q?SdaThaUCpST80n4ErfOQGcApbGY6K0aox/N8cSeLkAe/muolcrqkTZwDih?=
 =?iso-8859-1?Q?+X3U498EbM5lUn6Ii+XWk3LnBeRPz/M4/vKd4h6OC7Q5mR4ANKFPpz42x/?=
 =?iso-8859-1?Q?dRIKDiMQd37hI+aZYq9bacKm8rEGxLZnBqt4GebFTa8+ehxkl5ovlb7/oZ?=
 =?iso-8859-1?Q?1Z0Aq3dxNqEBZn7S3QwKDr1bvym+/FiLnFbSh45ocQqPsJd9j7lhXZMd2B?=
 =?iso-8859-1?Q?r7JiZ/YLmJU+69MTuKmhzoT3+uDfXTFflSTqjoC7TEBiseQZWaQ/GDc4RB?=
 =?iso-8859-1?Q?6hu3rvE9wIaBIwrpERNzJGvbmGEpv+9vwYpLwI1hijEqQa37Ytr7XUSin5?=
 =?iso-8859-1?Q?eWR8NYt5vHYJqwPcLHGA7YrCdvCT5psrp/42ypdPFad1Hg7pzDIA52+0+E?=
 =?iso-8859-1?Q?xGrwxlT45Ds1aJPvdlbrwjELv8sQ0H45vp0H858PQLIKjh9SHIDGyWYwM5?=
 =?iso-8859-1?Q?De6TuGnYRxIBX/ZBfxWDtAaFt60xkMQhdJ0hBOEomCa5mfazR0RdosCQTy?=
 =?iso-8859-1?Q?YNg3inEGig2drZpsuj64jvDt7YU008PeD+Q/3HTFJg2UVLC3CkO2Wnn9rR?=
 =?iso-8859-1?Q?HOe6Xo8MWaEJ0m7/q33EqTH2vk4Dw4M++m8+aILeU0y2vUYVI1QcAk6CTT?=
 =?iso-8859-1?Q?ghrjxserf3kw+7awmW5h+sVT3dl/+ne9NEL/oAJ4LHXVbaAOf2D6cKG7iT?=
 =?iso-8859-1?Q?UZJ28ZyiXnCuy9eVeRtx27DcA0CjG7wrvf/NAaXVzm5lzXRTu1xWd2SoZM?=
 =?iso-8859-1?Q?9Qa6oHSy+8qmBcmzmlER/FkFFubbVlq4UZyeXqMR6KFw/TkeqeFJvZC9/N?=
 =?iso-8859-1?Q?uL/4l+OmENtG5xVm1oDAkid87olnkI8mmXFoFH0z9xZx5bu61P69Kc8Tq0?=
 =?iso-8859-1?Q?+yAyt0oYsCzRgdY8/5Y5738JZmhlky0OikCM1YD08Px32DJhJidQjIQwpx?=
 =?iso-8859-1?Q?mFXlVXRRXqjn7kEAyOQ69qH3Re7j5FWOFbbqTJX0niwduxA5qHCInCdupC?=
 =?iso-8859-1?Q?YvjBh6dO/o7unW2IWvvD+TeD9A4VPgH7RB2t4Wae30kWifVhZxBivgRHpS?=
 =?iso-8859-1?Q?XLlTQ8uQ5JN6KCb2sO3f9fxNLxIePTREE9ZYLXV4ZWR67UKtwRhiDfRnSf?=
 =?iso-8859-1?Q?ZFPIMrS+vfdGM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcc1de3-ea44-452e-5086-08ddaf2adca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 12:14:38.1036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aniiUCaKu73M5UTLbnm/QY3cqXRGqF9KwfDcj4psgaB8Xfu9mmTJcfpR2wLDcxN77Z5PVz9QcSf0XMrwT6wmgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

>> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disable_cmo =3D true;=0A=
>> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!is_vma_cacheable)=0A=
>> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disable_cmo =
=3D true;=0A=
>>=0A=
>> I'm tempted to stick to the 'device' variable name. Or something like=0A=
>> s2_noncacheable. As I commented, it's not just about disabling CMOs.=0A=
>=0A=
> I think it would be clearer to have two concepts/variable then because=0A=
> the cases where it is really about preventing cachable access to=0A=
> prevent aborts are not linked to the logic that checks pfn valid. We=0A=
> have to detect those cases separately (through the VMA flags was it?).=0A=
>=0A=
> Having these two things together is IMHO confusing..=0A=
>=0A=
> Jason=0A=
=0A=
Thanks Catalin and Jason for the comments.=0A=
=0A=
Considering the feedback, I think we may do the following here:=0A=
1. Rename the device variable to S2_noncacheable to represent if the S2=0A=
    is going to be marked non cacheable. Otherwise S2 will be mapped NORMAL=
.=0A=
2. Detect what PFN has to be marked S2_noncacheable. If a PFN is not in the=
=0A=
    kernel map, mark as S2 except for PFNMAP + VMA cacheable.=0A=
3. Prohibit cacheable PFNMAP if hardware doesn't support FWB and CACHE DIC.=
=0A=
4. Prohibit S2 non cached mapping for cacheable VMA for all cases, whether=
=0A=
    pre-FWB hardware or not.=0A=
=0A=
This would be how the patch would look.=0A=
=0A=
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c=0A=
index 339194441a25..979668d475bd 100644=0A=
--- a/arch/arm64/kvm/mmu.c=0A=
+++ b/arch/arm64/kvm/mmu.c=0A=
@@ -1516,8 +1516,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,=0A=
 {=0A=
        int ret =3D 0;=0A=
        bool write_fault, writable, force_pte =3D false;=0A=
-       bool exec_fault, mte_allowed, is_vma_cacheable;=0A=
-       bool device =3D false, vfio_allow_any_uc =3D false;=0A=
+       bool exec_fault, mte_allowed, is_vma_cacheable, cacheable_pfnmap =
=3D false;=0A=
+       bool s2_noncacheable =3D false, vfio_allow_any_uc =3D false;=0A=
        unsigned long mmu_seq;=0A=
        phys_addr_t ipa =3D fault_ipa;=0A=
        struct kvm *kvm =3D vcpu->kvm;=0A=
@@ -1660,6 +1660,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,=0A=
=0A=
        is_vma_cacheable =3D kvm_vma_is_cacheable(vma);=0A=
=0A=
+       if (vma->vm_flags & VM_PFNMAP) {=0A=
+               /* Reject COW VM_PFNMAP */=0A=
+               if (is_cow_mapping(vma->vm_flags))=0A=
+                       return -EINVAL;=0A=
+=0A=
+               if (is_vma_cacheable)=0A=
+                       cacheable_pfnmap =3D true;=0A=
+       }=0A=
+=0A=
        /* Don't use the VMA after the unlock -- it may have vanished */=0A=
        vma =3D NULL;=0A=
=0A=
@@ -1684,8 +1693,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,=0A=
                return -EFAULT;=0A=
=0A=
        if (kvm_is_device_pfn(pfn)) {=0A=
-               if (is_vma_cacheable)=0A=
-                       return -EINVAL;=0A=
+               /*=0A=
+                * When FWB is unsupported KVM needs to do cache flushes=0A=
+                * (via dcache_clean_inval_poc()) of the underlying memory.=
 This is=0A=
+                * only possible if the memory is already mapped into the k=
ernel map.=0A=
+                *=0A=
+                * Outright reject as the cacheable device memory is not pr=
esent in=0A=
+                * the kernel map and not suitable for cache management.=0A=
+                */=0A=
+               if (cacheable_pfnmap && !kvm_arch_supports_cacheable_pfnmap=
())=0A=
+                       return -EFAULT;=0A=
=0A=
                /*=0A=
                 * If the page was identified as device early by looking at=
=0A=
@@ -1696,8 +1713,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,=0A=
                 *=0A=
                 * In both cases, we don't let transparent_hugepage_adjust(=
)=0A=
                 * change things at the last minute.=0A=
+                *=0A=
+                * Allow S2 to be mapped cacheable for PFNMAP device memory=
=0A=
+                * marked as cacheable in VMA. Note that such mapping is sa=
fe=0A=
+                * as the KVM S2 will have the same Normal memory type as t=
he=0A=
+                * VMA has in the S1.=0A=
                 */=0A=
-               device =3D true;=0A=
+               if (!cacheable_pfnmap)=0A=
+                       s2_noncacheable =3D true;=0A=
        } else if (logging_active && !write_fault) {=0A=
                /*=0A=
                 * Only actually map the page as writable if this was a wri=
te=0A=
@@ -1706,7 +1729,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,=0A=
                writable =3D false;=0A=
        }=0A=
=0A=
-       if (exec_fault && device)=0A=
+       /*=0A=
+        * Prohibit a region to be mapped non cacheable in S2 and marked as=
=0A=
+        * cacheabled in the userspace VMA. Such mismatched mapping is a=0A=
+        * security risk.=0A=
+        */=0A=
+       if (is_vma_cacheable && s2_noncacheable)=0A=
+               return -EINVAL;=0A=
+=0A=
+       if (exec_fault && s2_noncacheable)=0A=
                return -ENOEXEC;=0A=
=0A=
        /*=0A=
@@ -1739,7 +1770,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,=0A=
         * If we are not forced to use page mapping, check if we are=0A=
         * backed by a THP and thus use block mapping if possible.=0A=
         */=0A=
-       if (vma_pagesize =3D=3D PAGE_SIZE && !(force_pte || device)) {=0A=
+       if (vma_pagesize =3D=3D PAGE_SIZE && !(force_pte || s2_noncacheable=
)) {=0A=
                if (fault_is_perm && fault_granule > PAGE_SIZE)=0A=
                        vma_pagesize =3D fault_granule;=0A=
                else=0A=
@@ -1753,7 +1784,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,=0A=
                }=0A=
        }=0A=
=0A=
-       if (!fault_is_perm && !device && kvm_has_mte(kvm)) {=0A=
+       if (!fault_is_perm && !s2_noncacheable && kvm_has_mte(kvm)) {=0A=
                /* Check the VMM hasn't introduced a new disallowed VMA */=
=0A=
                if (mte_allowed) {=0A=
                        sanitise_mte_tags(kvm, pfn, vma_pagesize);=0A=
@@ -1769,7 +1800,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,=0A=
        if (exec_fault)=0A=
                prot |=3D KVM_PGTABLE_PROT_X;=0A=
=0A=
-       if (device) {=0A=
+       if (s2_noncacheable) {=0A=
                if (vfio_allow_any_uc)=0A=
                        prot |=3D KVM_PGTABLE_PROT_NORMAL_NC;=0A=
                else=0A=
@@ -2266,8 +2297,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,=
=0A=
                                break;=0A=
                        }=0A=
=0A=
-                       /* Cacheable PFNMAP is not allowed */=0A=
-                       if (kvm_vma_is_cacheable(vma)) {=0A=
+                       /*=0A=
+                        * Cacheable PFNMAP is allowed only if the hardware=
=0A=
+                        * supports it.=0A=
+                        */=0A=
+                       if (kvm_vma_is_cacheable(vma) &&=0A=
+                           !kvm_arch_supports_cacheable_pfnmap()) {=0A=
                                ret =3D -EINVAL;=0A=
                                break;=0A=
                        }=0A=
=0A=
