Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C311A76BC
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751647890; cv=fail; b=ELtTfOQ6oI1J9QwHn58sPc+oiC3fYicHP0HXjAcgx9qt9P+bpUEaM+2BaYsF5ZRNquTDDwBSGlnecD4yiPouYP/XPWmDOTelT6NMmrsewVsrXOdokADOzLi9tLDYD7s5KhPCjOIRlrkXqTFVji1XDTtcTTFha+wvnwlgbsMdBJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751647890; c=relaxed/simple;
	bh=bI2llRidJ786BnXZDS3UkYoj3HjfZIkhZTzozCVaurg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZueC99qTapAlpCWoFZbUxvntr1OVVkUWs0NKp2xUq0kqz4260m0jnhYDb+pSSpiXniU9C4sTimqt+mytYfZd06tkGTz9UzHlpg5s43bmDrmC2fj+b/XnNMDAkLb+p5ZKfgN2QDgVCXXqC8gQAZRV+hWUrRgvswx4Ksg/6B1BJo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=btJn+gZI; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="btJn+gZI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzudBjFpegW9pxpOT4myLSeJnUwnj/cUW1sWiPZdKncxxj8zrv6l1fj2nDGon2FBKLb9f/ybf3Eel6kjZULYrCLW3nZYGeozHutWEdo4UaXsq082RNt/diGZhYl6BKgbBKM8FIcyEPcbP9XPa7BwkaOPuMLEFbLCDhTV6k12i9l09h1jSnky01ZI9SPdvpbZ7poy8BnUhHItY4ZFlbNrQklbSYJGBeIiwTCzZ+e/XWmp0RAUATCpy8F03zOOVOY6iuCEdzwyFoHSdILoQe+Mp7QNNUVO1xpsk+2ZdLjaskglGbivAgyupUMZNayq0SJeOjO/OPbPjB8wyURNQjEMYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sm9iw0vLXW8CBQNS5yAHZfWIMpFaKOpyLL/aCTfRlwk=;
 b=lrdOcdQSy5yRo10Vn/gbIxOjjeIV2qz9lX4kys4WNV/IdPjGhcCFmkjJITxcXze34+Qf/LCMFzXrw2bT8DTr3r26hzQlOjkUqYLl9HsWG3CCmHJQ1q5R/p68q7ilztq4JwgccQQPNTd4GDxwWjMeibqjNZ4sITSrKuh1I/b28Nx8zny6d9ojvAsf8MHgPUU6Vt5k/thB/FiAh+zgUgvfOc3YydHfYDuowV7YorFtjW7n+L4BMWeqe1AFBFm7HbgC86A/TWedrg7QodgEAhC2B/Y9rUHUxKnBmzi3Tzoayt07du8TWFB6YwEVIHahy5ETspVrvEccdlkQRKS2srBfqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sm9iw0vLXW8CBQNS5yAHZfWIMpFaKOpyLL/aCTfRlwk=;
 b=btJn+gZIQGTz1G8rayAt/gajO3i7AQgPRWZ6IbaFcW/Zud6D/4QmhWHo32QrYLLL+tJZGODRr+WCx8QW/TvwCkAFKvQUkemDyBiDvDdNDA88birQrkG329lQD9oGBFAtsAUbiixCOxzdrC8KEGRFDxe6+3lXhMgK/ivBfzt9KgaMYJBHq+I/c7gHIEMdpWU1neNwyUCsytTqc3ZmOX2HU+iLljD4OuaqmPOkBq3urMmvDSbvAwYopoW4/VKjIpnCy0JIvhu9YwlNH3eXxwQtLI4erF4TQajaIRXMjPdWLCtqtgSqJz2xnjB4tLejx8NxetgrASFaw/iJJscBz+tVdg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CYYPR12MB8891.namprd12.prod.outlook.com (2603:10b6:930:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 4 Jul
 2025 16:51:25 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8901.018; Fri, 4 Jul 2025
 16:51:25 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "ddutile@redhat.com"
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
Subject: Re: [PATCH v9 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v9 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHb4mP29FdVbgxB8EOb5cMp1eIgb7QiFFiAgAACeQCAACndcw==
Date: Fri, 4 Jul 2025 16:51:25 +0000
Message-ID:
 <SA1PR12MB719988B006EBB121DF0CB07BB042A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-6-ankita@nvidia.com>
 <20250704140431.GH1410929@nvidia.com>
 <07e0fddd-76ba-4905-95f4-b98063215866@redhat.com>
In-Reply-To: <07e0fddd-76ba-4905-95f4-b98063215866@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CYYPR12MB8891:EE_
x-ms-office365-filtering-correlation-id: c4f1b4d6-4b0a-4c89-87d9-08ddbb1b0387
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?JjK25NYfaWqq04dZtGJZhv7PKfv8/BmMh52UyVuSx1tYgXM1ftWeJC0Fan?=
 =?iso-8859-1?Q?Wkmxm3BYhNKkQqf6wfFN/7rJjPXqN6OMNTovAVf4lzm5HjGsouWmCv0epy?=
 =?iso-8859-1?Q?XnHCxFQ6/VO6KVh7DZPPbH35pkzkgLoqg/pf9de6dOtENtdteI++NSYkxZ?=
 =?iso-8859-1?Q?SDR+IAlxbi5Mrwccl5xJfnYS6PVu/fAUCF7Nah9yuFy6lz7/huvQf+QB9t?=
 =?iso-8859-1?Q?gMlMVpDvsX6uqfPO5G1L52a99I/Ah7n1ES/oS1hO5F5y8jfV0OtwS+W5sw?=
 =?iso-8859-1?Q?EgMJdIVu4z8ThqFRiXIEMwFKNuFGuphBtjY2JzDY0oagCYcnFD8Z3EJ7Gd?=
 =?iso-8859-1?Q?TYYnRmZPWINusgKm7Xo6BAcpTb2cEUakYfJMN+oZsWUt+ophsMtEdsszJm?=
 =?iso-8859-1?Q?MTO9yciVK5Inxv/jrwy8+5xFjTFi2fVQtwRYwzbN4sfEt6C4JFnr/Up7AC?=
 =?iso-8859-1?Q?k6e9BYNFTgE9GDcJZPoqbMn4sZ+lbaSG5LUjRYXIczml5oEc8bGOUg1UPo?=
 =?iso-8859-1?Q?TX9c1rEHLGpOWv4afVavsjaNjCIZGvWN7deniQto4HPwCUE/ZSxgV/Hrn5?=
 =?iso-8859-1?Q?J0B4qwXPk8PeWMh5VHgQpoffEHGgjvM8/UbWm7p0wfD0s5n+DPFTRfqI3O?=
 =?iso-8859-1?Q?7zvZ2HaI/2eo99uuG5wP3eRORAD3NbbGiwh4VeIX//Lu0Bn5HMY/giHYxw?=
 =?iso-8859-1?Q?JwyGzAvNJVYXvrTGfmQiq/FbwQfUbgAfIh6sHoPdrrkx8/Nt0B0P2wu4vj?=
 =?iso-8859-1?Q?dzqJZtTcQcHjMehHofCb4Eeld8Ar7VjP2OwDMsEtCBre83TARxAXcCGIeG?=
 =?iso-8859-1?Q?PXUwWnimwcSGEU5Jx3MSeI5M3A5FqraI7DU7jpyimbhKelp9yX3VHP5sdF?=
 =?iso-8859-1?Q?igRTS7xmTcYzy6fiqOAAig1iEqBJyoeySNdsEqxDLoks2+8KvFnJLOTQ60?=
 =?iso-8859-1?Q?RLn5CkYx3i/M+7GnJmyJGM7UnjdhSUnD2fNteqL/v0O77Cxo0uZy+Z9+5D?=
 =?iso-8859-1?Q?2730AqDyqdqEkckpToAiYlioT8YuAe2VmF3sb+JHgp4iL5ovcY+8dJ7MCS?=
 =?iso-8859-1?Q?gEJRke0vjXEE58zK8dpIAZlUEZNVXrF7yZmwExHz7MTvJb7DkPSARseS1g?=
 =?iso-8859-1?Q?tUQdUh9qZYgVzf5nhW8WGRwGYn78AhSAn2BbR9hg/k8/GiC4M9FRFVMZH3?=
 =?iso-8859-1?Q?xB4GemNvniO4Jzf0E4aG8YCBIJepQgF3KepFBRCSqqxJBvpk1Bm9qWJ74U?=
 =?iso-8859-1?Q?RxxdNq8Vc+kUzsCZvVnjWxSe8xgonRkwcywQU+f6+W5DSd43x0xP1e9wVL?=
 =?iso-8859-1?Q?lxHZapJ8uhvBSvwj3l76w3s9lzQLqkViDg3NlXlkfkS4Y2z2jDEVXjJjXU?=
 =?iso-8859-1?Q?KXfJC6AaNr1sqI9gV3ljlJFkwdYIOUDiKiDuwtYich7lJ2utOi/w5+Jk0B?=
 =?iso-8859-1?Q?lQvIcCDz0RaCyeaywE9us7dH3gTjtOI8o3b71vyAPjCgNfINkgB3J23uQg?=
 =?iso-8859-1?Q?nNobWljduvGVAoRruY4DWOP0uyTTB5MzPK//S/eoCbAQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?2lUS3CWxWSFeOQKrNqd05iUtVDRm1xPb+k+ZDw7SJoan8Z33zVYlh9N1ro?=
 =?iso-8859-1?Q?8LMNy5ApXVFMgKA0FoSS+VZTZFm4f+TJw9j4R+u2IT8yYcHK/zVk9DR+gp?=
 =?iso-8859-1?Q?Vs4D8uc3yMnUsXktj3v3oCFppJg8TGZAzpG3awpZ3KGnY2XWvherXEQqPW?=
 =?iso-8859-1?Q?nT8vOyNzLccQCg4GwLTgtDK8kP2oYHXxlV88yzEBH23aEs5PVFM0OdlkAw?=
 =?iso-8859-1?Q?bYGCQZ9WFb9PtSpFnS95IE35VV4ioIJbrWo5+Rm6p/wiq1Fr2PpeKYRjNO?=
 =?iso-8859-1?Q?tt9RRLG1MkeRddMmlyUBiJ2uIaPCvbJzU0OHpS5hjIsG53jvLldQhkSZo1?=
 =?iso-8859-1?Q?8+8RBUzkZjyyFVDYvH4GMg2jzBO1hmnnqyPjFty0CK80by0uoUhy4+rCke?=
 =?iso-8859-1?Q?USA8DU+cdbn5uOhHfLoEIHSZHv7tG6zG3P4eBcsFM6H0ceRmON7VJpe+b1?=
 =?iso-8859-1?Q?IvI29zjGX0CyJ9ugOufbwoStluAH0G7WoqOXmHAWnDDIiCfIo517svWZfb?=
 =?iso-8859-1?Q?0w2QQ5Ov+0eh5PgMnqsq4S9pnjgn9OV4VjO/kJ9KopoSlsjGtkvl7wXUBG?=
 =?iso-8859-1?Q?yXnHa03NwH9M3j4F7Hmw1MCV1e8RTs5zj9B3HHejxNHNoUlBbrV3TUyfZF?=
 =?iso-8859-1?Q?dRfqTfKNVwTxwQeFZ1E9fVKYJ9LlWo090fQH8KYXJGJ69QWg7ETv2wfue1?=
 =?iso-8859-1?Q?QQd3AeGGZ2T668h7JHEwx9BVVn+5rnfiWl3sLDGnN5k+2k5P40S5ZyOVZU?=
 =?iso-8859-1?Q?Cw3eDql2Urlz5TZaUGR1ROqOXlvcOINVALXHgez+AKXUVaz1UDVC1tpNRr?=
 =?iso-8859-1?Q?YG4JD3MxTxtO6reqjb7CcZA7XcSyOvAcdkc80PRZpJwsJZDU3yVgUVK/Pt?=
 =?iso-8859-1?Q?zTUZhKfHMSqeZKsBXqj36XJfY9oCj0pAF4iManYr/nbbeuHmKiEv7ZOf0C?=
 =?iso-8859-1?Q?6CYBqIVqar6GUMa9mFy8gawf3TA8ekrEn82XOlyqI5A9yg+C26rj/Cwrp4?=
 =?iso-8859-1?Q?/xhlruilz3JGWgaLefwi3w28PdQkzFODKChjD7Mqig7Tqvpq3r7wvO3ZTV?=
 =?iso-8859-1?Q?LTc0H9mE54MEl9ShcnlDfILHyw0ehYFPJxpg+ZwrAnfrYYYSEBdj5f974t?=
 =?iso-8859-1?Q?//3m89os6BxBW4oGVQCTGvfsy64k7nEjFOGk6dvSIJIyUtkpPL6UPXfLgV?=
 =?iso-8859-1?Q?mNI8VnymNOutWwma3T5UNSe+3wdvZtQsgjpzJpZZl5Maccv9aCxpBkGUQT?=
 =?iso-8859-1?Q?eDZvHPy9t3eBj21p8gxlcvozcyUNj414N1sTAnVitr6krOHbTeImEMLfSy?=
 =?iso-8859-1?Q?lLZjmV9fmLEKR4f6NeBn9VNTswZVpRCCC+niTn1a/l5MJYBoxQnyVaMq1K?=
 =?iso-8859-1?Q?KPgzgAJVZ/BoYe0UIxwHhdo/FomEt3+fO0R6o7wIQUWPsfudAbFy5OAlBm?=
 =?iso-8859-1?Q?jRuSP+2ttJXcsmJqAuqwwrHxrETUpfvy6oxwSvdgtafgpxIh+6imRSnVuN?=
 =?iso-8859-1?Q?7v7qfGFwnR94Q4t2lJifMMG1SXcqmitrd3FUvg3UfkwOtU3+emKRNeIOjX?=
 =?iso-8859-1?Q?k9hhz1bcXN6ZpGIxE1Y75YrqMtc7a+nFRFdgiU84KlPuR5aoEez+UpQmrQ?=
 =?iso-8859-1?Q?HK/A0a0RRHJLU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f1b4d6-4b0a-4c89-87d9-08ddbb1b0387
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2025 16:51:25.4127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AsQPB7IdONxizx+7MV/Ia2PnirwkQwAY8bFeZo4Lq2PEJjurNOPwoqgs4jnAazP8UHIe0eFjBBC6/UlN6nDXNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8891

Thank you Jason and David to review this and other patches in the series!=
=0A=
Comments inline.=0A=
=0A=
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * COW VM_PFNMAP is possible when =
doing a MAP_PRIVATE=0A=
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * /dev/mem mapping on systems tha=
t allow such mapping.=0A=
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Reject such case.=0A=
>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s2_force_noncacheable =3D true;=0A=
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_cow_mapping(vm_flags))=0A=
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINV=
AL;=0A=
>>=0A=
>> I still would like an explanation why we need to block this.=0A=
>>=0A=
>> COW PFNMAP is like MIXEDMAP, you end up with a VMA where there is a=0A=
>> mixture of MMIO and normal pages. Arguably you are supposed to use=0A=
>> vm_normal_page() not pfn_is_map_memory(), but that seems difficult for=
=0A=
>> KVM.=0A=
>>=0A=
>> Given we exclude the cachable case with the pfn_is_map_memory() we=0A=
>> know this is the non-struct page memory already, so why do we need to=0A=
>> block the COW?=0A=
>>=0A=
>> I think the basic rule we are going for is that within the VMA the=0A=
>> non-normal/special PTE have to follow the vma->vm_pgprot while the=0A=
>> normal pages have to be cachable.=0A=
>>=0A=
>> So if we find a normal page (ie pfn_is_map_memory()) then we know it=0A=
>> is cachable and s2_force_noncacheable =3D false. Otherwise we use the=0A=
>> vm_pgprot to decide if the special PTE is cachable.=0A=
>>=0A=
>> David can you think of any reason to have this is_cow_mapping() test?=0A=
>=0A=
> I think with that reasoning, it should be fine to drop it.=0A=
>=0A=
> I think, the COW test made sense when we were talking about limiting it=
=0A=
> to VM_PFNMAP only and simplifying by dropping other checks. Then, it=0A=
> would have identified that something is certainly not "normal" memory.=0A=
>=0A=
=0A=
Ack, I'll drop the check in the next version.=0A=
=0A=
> Then this logic that immediately follows:=0A=
>=0A=
>        if (is_vma_cacheable && s2_force_noncacheable)=0A=
>                return -EINVAL;=0A=
>=0A=
> Doesn't make alot of sense either, the only cases that set=0A=
> s2_force_noncacheable=3Dtrue are the else block of 'if (is_vma_cacheable)=
'=0A=
> so this is dead code too.=0A=
=0A=
I had left it there so that that condition doesn't get violated in the=0A=
future. But perhaps it doesn't make much sense to keep it. I'll remove in=
=0A=
the next version.=0A=
=0A=
> Seems like this still needs some cleanup to remove these impossible=0A=
> conditions. The logic make sense to me otherwise though.=0A=
=0A=
Sure, I'll fix that in the next version.=0A=
=0A=
