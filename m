Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F6019D07B
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 02:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750299757; cv=fail; b=MK30llJc6xfcx8+g/HJGreqszcICHgc8MQBQKNg8kRflgQkGH9zeKJUzg+rQKMw93gjidXcsVC6LDa5hUbXLdD5quE2AKQJpN/02lBwVXBKfjrJMf3hL2PFr8srZoZfyG6aJPUPAmcdgHRqkyrWAGrkqkfnJzbMEOXbSM3hF3BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750299757; c=relaxed/simple;
	bh=wi0Ty6/Ratm93cTjItJ7iDyCe7Un/ly3Qe/7ZY6foag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gx4YblnqODPZrN4Cwdv+hYReO/jGM0jyt6HFseFuVt29uxF77oNgIVcYYcCi56rqyI03VSKd0gBOEREQPW0geSKQguwA2ftN3KxUC7e0cB4ncyQPZUMPcqq4x9HW5rXO1wtZIdas6udUdXN+rNdkH1ckUgzH7ZFbRHf+LaD9Y1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cp+3//tN; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cp+3//tN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yy1wcsVU1WpQQQUFgq6Nqdb7oUeT5PlnrVT74vnay4KjtHWqYgs+iYwotx50hcXchClBGQPF7a20/laQDVbp12JY3STsuHb0x2bChf10mcwWkiD7SGhgl+FmKWeKfB0EdKVECD3MyPR3JzQz7XOrEBqEm6XyWzZpcZO8QYwCIT5TZ4NuUvKy/Am7ExcJwvnSw/jMplzg090yoXIW2dzlStggOAoVqtiCjuAWEx1lKkYhADC+avLf3ZkhhCy7VVSCuamhGrvexHpCRrt8g5y91HSMGYmtwQoQOoIbIVCE17kgmTPE3wr2OF0n49iLzbTxyHQQZeBBd91KzbeinzBgsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi0Ty6/Ratm93cTjItJ7iDyCe7Un/ly3Qe/7ZY6foag=;
 b=Rj8vvtf/U04Xlow3NceDQnC7E//mdtuunTeuEKe/cQetBM6KUPfnNvyBL8Q5NS5IgJ90drU8BXeUQOgnjhNB4UGlwlt3b7sVLn6HYIjyECAZ9twMhFdw73juR6fQfYO3omumWnKXnpB2Y+P8jkM8jNZTVlzK+hSjjxLbHOS+Z56oPNB70vbYm8apIwKDtTXXJteSi9WyguR1SXJ/1F7ZxnRb+eskYJnKHQgqWoYulIyeUzMsWkyUlugEAAikoVnM0ebFQB5L1ywHz2qDDXvc/SaXaHE6QkezJ/Xs78+mtMIATdiNfB19K8h8WxtxnSQsbPktI15vQMTF0+9qVV9CSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi0Ty6/Ratm93cTjItJ7iDyCe7Un/ly3Qe/7ZY6foag=;
 b=cp+3//tNhM3OctZqPccQKC7QzT0wwr03f4XIrJzO60Rjd6ksDVzTGLMfYnmLMJin+btpthbiIAqJqXcBGcXyerlO01z8K1nz3BB75oGRBYEbGPeioOaB+pur7joU+DPZyKqGc377Tq1I6BCOofB3x+FeBrkdZ6YMzvFRyP0waqhTLVvQeZqWDi6Me2cXzagqoht6IpOtgIlfWggUgq271aux+SSW7P0zXXpUZgr7MCRlDLml4HcspvbzIaGvaZ7ew0ld+QD1GnSYkInG6mHoSMD58kbR8ZZvNumJ6qnna8jPPtKbJbpQMx5ZgFpyJB3fOjuSGGNAZZ4geKZ4TbXSRw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB6984.namprd12.prod.outlook.com (2603:10b6:806:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Thu, 19 Jun
 2025 02:22:32 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8813.024; Thu, 19 Jun 2025
 02:22:32 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
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
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v7 1/5] KVM: arm64: Rename symbols to reflect whether CMO
 may be used
Thread-Topic: [PATCH v7 1/5] KVM: arm64: Rename symbols to reflect whether CMO
 may be used
Thread-Index: AQHb4B4N1wf8XS5vvUiK0jUwBZiI7bQI/CQAgADCHeg=
Date: Thu, 19 Jun 2025 02:22:32 +0000
Message-ID:
 <SA1PR12MB7199C4E718B01D373C9554B7B07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-2-ankita@nvidia.com> <aFLOnN_Ha3s724rK@arm.com>
In-Reply-To: <aFLOnN_Ha3s724rK@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB6984:EE_
x-ms-office365-filtering-correlation-id: e2dc3f7e-4391-4d93-aa14-08ddaed825a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?HRpYkf+q0Ms1DM862oayfFBjdEgELQlmL4mXdNMzQE2FvE5pX7GRKhdkhV?=
 =?iso-8859-1?Q?slJR4AoRpwDfzc2NFoIfx+alf25iiM1jSHutF/cnvzikQ7vGlRFm5Scmr2?=
 =?iso-8859-1?Q?PlnR++TegM0FH/Iu2d8+IcMfd3dWi2WobRW5YwHuKIW0iSF26FNmMc2FQl?=
 =?iso-8859-1?Q?g3I1Jxlyx2cXfANZg0G0MGpE/AwKfaMeJBSiHNTtwwASWPTcjyqskF7JEY?=
 =?iso-8859-1?Q?EKqZuTw30C9qFrKynTgtRalf0+TeHYQKW9+RkR6YuRuHBuJ6QvE7JLhPlF?=
 =?iso-8859-1?Q?sfjx+VpQPWnNnYPInJq6DyRABxq4IX27Di/pEZnz4Z/cXVTIcQhTRE3px7?=
 =?iso-8859-1?Q?/OkHHE0Kx/yTqO5TY8VrM0Ld7iY80ncBl4DNe/TFR4zIyM9OTG6M1I/5we?=
 =?iso-8859-1?Q?5q7dfRg2EtpMwfqPJkPs1nfQ/VdjLYfiuq+MqVD6vyoRvnJwRJxSUVZkfk?=
 =?iso-8859-1?Q?YpznHeIo10qrpn5GA+wUe9C8dzO3zmHYPMY98vMOht3wd+h3qjHPP0grU+?=
 =?iso-8859-1?Q?5sCB/IMb/G+DO4DsobSVWTbPT5HdMdCMBMvHZJqAcrvlf5tP8Kh3hBxczW?=
 =?iso-8859-1?Q?XHqvBtFzDX9iqGtgVDnZps4ns30g0XG3azV2h8PGKAbW6xr0GRPqlvPbGp?=
 =?iso-8859-1?Q?QMz4hWBoiBwcz/xWYpngoMbCy86pKefx+2oFyo5IfCreQ62SAHEM/iENco?=
 =?iso-8859-1?Q?4Jg0PO59fe8soThQdViROeL/MSexQFyqZ5wmEDehN25hYzV+xI25736NIb?=
 =?iso-8859-1?Q?QYhgoJ+ISL/LVON/U6npRomNGDF72uRcIpMUnOfge+05zY3KUXBAZf4pB4?=
 =?iso-8859-1?Q?KkCVekqm4HD08DTsK5M3RXs2iYG5z/FdWqEmzThRHxHPKN35xT/+csPLDv?=
 =?iso-8859-1?Q?ttHTza4ZIU3bHjRoLvdmmZHSc9vbDSVEBF+oolzBnzunQwe1bnoiY2NWAy?=
 =?iso-8859-1?Q?f6r9AlCXfggTvJ4afzChksUCXB9LmCsh6aUM7KYVkypMDB12IsHg5Ym7Da?=
 =?iso-8859-1?Q?Zr3Yqmyj5QEUNO34TShk3VuaF4r+SMnmzTcOmX+Uew6/RUVjLRVdK8p2ip?=
 =?iso-8859-1?Q?OF+DBX2xsbptvs6cGK7v4mcVkvkv+SBNEIP6m0SEHbmauumlDDiDSwVlXK?=
 =?iso-8859-1?Q?GUYjgLD2y/X8IIyxl5bJHjXKbQ+f/4HmwwnWUyXyEl0Zo/yARU+AgXscL2?=
 =?iso-8859-1?Q?IXlV7m5qvR6GSz48VJd0DJitH4BT0cCeeqXPuq5tyV7ne0oz1YzngIVKYO?=
 =?iso-8859-1?Q?8CyjWxWI4SH+biSEoinAOyCBx5LTN7xlfXlUHeo861kWJFw3avh2KfNfHE?=
 =?iso-8859-1?Q?QLuYPFb992RPmbfNAMufE8PESsOOu2aGoJjFMmXRPIg2R1NTa9NrnZWS/C?=
 =?iso-8859-1?Q?IEkhIq61/Snizf/Tj7A7K/LveIlE/wvVLc/5zS3IF7KJTW4Lfzk8PmIVr/?=
 =?iso-8859-1?Q?Qx5isaP27xyZ4KeK3G/RaoIbU7v5tCPVHhpo0EFi/53YLCQdlB1xs9+Gl+?=
 =?iso-8859-1?Q?YHsnJgS9Pq2ha9ZMTSWn70lhCa7wsvhc1HqLPg8pXCZw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?St+26rUmCX45y7STRtq387i2qOmyvi4Oem2yZgmISgPhcQP+rw5kny/QGV?=
 =?iso-8859-1?Q?3Dz1rxDZm/vwjVHvoIEWbMi/rqTbL3TlWGyKQfp7gi5haCQwIkfPzeUyz3?=
 =?iso-8859-1?Q?3jLYQyzacDfbzB37bLE2ZoyhcLRyJES1d/aaJIjnQx+Q2mwKXL8MGGsO9i?=
 =?iso-8859-1?Q?dR+MyH9xbcl5hRjryIN3Bw+lyRO00xeLa8eQVE8WwzaU7cCllEIMPuXTM/?=
 =?iso-8859-1?Q?X2gdEqhnJEOL138bwPp9+FWgvPOr7bnhhmDltF2aHTyQzGriSx60OKEfkI?=
 =?iso-8859-1?Q?suSeEwAQryrdk9mWH3V1i2wD+c/p44pesxjvlN9LpMr1YjFrLIlXnsx6GH?=
 =?iso-8859-1?Q?8twYC6zoFbpj9XY217kGZ2NhW7K11084pqD6YI+6KGnwKIF5JU5X3GGCz6?=
 =?iso-8859-1?Q?BKbXUvq+UGO8JO7d5o6pJAUCON3d7psf8yrKoiVC7UUBVRp3FEznzGm8Yn?=
 =?iso-8859-1?Q?159eMaptbAw2QEg4Ti29RT9E98hnvTeErI6wNr3IDv9hNuqk5qLh26hCvG?=
 =?iso-8859-1?Q?09HMvDXSnCd9UogCKOZuUNm6zp+4gup8E560r+gF/tdcizrzjuCf5JrkB/?=
 =?iso-8859-1?Q?55/ayipTbyWV8L6I+oUWLLf9O5tY8opJQVzvTu6FYJ0mSLCowDpTvCUQLF?=
 =?iso-8859-1?Q?ulrVkdX/qx4iQ9KpatWdy+spyjdKUiZwTK+nlxUDRpIf6YomVoXte6E6NG?=
 =?iso-8859-1?Q?oehrPnOmHkZcJlIBEEobit528baTsTImrZEJ7FmW1JJgxc9Xtm5HFxCfVH?=
 =?iso-8859-1?Q?CEMP5gFmWHO83yrjQIoE1UlaMwuQzusNnvG0/hQyt2U9x5DZst72X0RN+6?=
 =?iso-8859-1?Q?F/7MRRkixMocUJMzZ1tr9mOsJueDWUKIMJ95UcpJkAHlGFRB0PfPeJQ04R?=
 =?iso-8859-1?Q?/4AygZBSW+wGHUfhldoUbUf8nEpBbjr/cTqQUm7v1jJJFK6xXSnFJTt7yE?=
 =?iso-8859-1?Q?Egv4tU19ltdxIQAdrDvK/waW34lvHl71qcRGh1ZCdcU0EIOpmswCp+VLye?=
 =?iso-8859-1?Q?4Dn5YwD/uFWADOCEfFzAIsixML4K4W4PiFx4GQr0AUHQSuUvYXD0ZVz+X3?=
 =?iso-8859-1?Q?PWw/WkTHtLHUdnlHh+PXNOT6QDc+Q7jbRNVPiRkjB8s1yjsIZZUbzv5r4x?=
 =?iso-8859-1?Q?02of8XqPOk+CIB0no+mH7KtVdeKXI0UqsWvzzP3Iot3TMVtUCwBE3Jtc0u?=
 =?iso-8859-1?Q?DLgNo4F/j0aSiY0oNUh/hLhyGo5ISGyfteajSkk03mtYxLpsSw4a9o8bj8?=
 =?iso-8859-1?Q?nEQNUA9B/sw4/4yquG3Co+xonP245jiY9v7AMLKp1px46gK2ujJpQiF75R?=
 =?iso-8859-1?Q?1vsGmOsL9QgbQ9sUVUvas7e1DLcaYLgjtNzQmVaQMAPRJrbhnpH5yRzXsD?=
 =?iso-8859-1?Q?/KapyO4oa1bZwId1hrUplAGXAUE5bAImPiVCOF5+n17Y6VW45BeJhVaARr?=
 =?iso-8859-1?Q?nHiyMoPuIgwBidCbPyHHvWXoCKIxyslDOLIusARsFMDSWRy/8WpGoH7tqz?=
 =?iso-8859-1?Q?y9jD00a/pyAH8eJxgtMXF6itlvZA/77VcyJyJCbUpPsIQiAA2SPwIPMKwM?=
 =?iso-8859-1?Q?VL3tKOEzOKW6vZtxSTNOfCD/813u7mMDZ+uLoWaydCaxNK3acB7dXmygyJ?=
 =?iso-8859-1?Q?wEH5NYFHjWOBI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2dc3f7e-4391-4d93-aa14-08ddaed825a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 02:22:32.4178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqEY/QuIcphqkF1UWCp2ED8+wZXucCcjcKFUhwk/2LpHI1X7+CKh1AhIyawgZxtKZXRBl1NzN5F935VafgzqzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6984

Thanks Catalin for reviewing the patch.=0A=
=0A=
>> -static bool kvm_is_device_pfn(unsigned long pfn)=0A=
>> +static bool kvm_can_use_cmo_pfn(unsigned long pfn)=0A=
>>=A0 {=0A=
>> -=A0=A0=A0=A0 return !pfn_is_map_memory(pfn);=0A=
>> +=A0=A0=A0=A0 return pfn_is_map_memory(pfn);=0A=
>>=A0 }=0A=
>=0A=
> I wonder, why not just use pfn_is_map_memory() directly? At a quick=0A=
> grep, it's only used in one place and your patches don't seem to modify=
=0A=
> this function further.=0A=
=0A=
Ok sure, will make the change.=0A=
=0A=
>> Currently, the kvm_is_device_pfn() detects if the memory is kernel=0A=
>> mapped. It thus implies whether KVM can use Cache Maintenance=0A=
>> Operations (CMOs) on that PFN. Rename the function to reflect this.=0A=
>>=0A=
>> Additionally, the "device" variable is effectively trying to setup the S=
2=0A=
>> to prevent CMOs. Calling it 'disable_cmo' would make this code clearer.=
=0A=
>=0A=
> I'm not sure CMOs is the only reason. Another is to prevent the guest=0A=
> from mapping device memory as something other than Device with=0A=
> possible implications for external aborts.=0A=
=0A=
Ack.=
