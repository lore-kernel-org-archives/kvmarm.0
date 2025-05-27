Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3203154C15
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 04:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748320427; cv=fail; b=HC04YlFV+2k5kh62FCVoUjNAuTz05bC1WIhn4agCjUUWfzwL0yc/NgHnszZtgVuNK2tCWjHmVfOr9EQVKOUwmAi+iNjLsr6pjpJg0ZWjSb1QcCIQST7l5ItXcNVa3GDVnCyXNNPVT+wOjQNCerEl4zwe2waewfzeKXoylcpN+2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748320427; c=relaxed/simple;
	bh=zZz8gjfyP7pKzxpnQO5BIVe1YYz/zQshSs9gpsxy3j4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XAVSTJkTo6BcDl2MOZRxcmH7W+PHBSW0cn5m3298ILwvPccxIBtN1JCsI3Vf83v7VahUCcxA1LQrIgwY7Nex/nvVLvaJ0NlDcslzzKaAz7cjOSYuX0K3aURtRm9VxH8Xjx+SKeaj1tl+OKg75he5IMzQxqybpRL/MzEr/Yddzks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WR6WPSzO; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WR6WPSzO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsy5mS7fWRMGG06CN4mHlHOF4ZqQOQ4LZ3b5GP6B1XYfKSNxV+0sIHvJ+cs6bngCnuHIr4hmMKr11Y+lcarESpRAUAfoHynwRwYCI4kGWJIqDOSpj51aksiMZVktbLQj4/ff4xOS4ufL3hN2vd6SV++KkftS8vCmEroxJTZyBBi/xf4jSv8uBjtxXeNP1P9X4tIxZ1M5xEn1/C0Nbs/M5+A5mRgGigolqErgKh9+xdPmty/MxNEvyv/kbAWe58Me5ceKTyzF3SkrAkaSli7LEam1pAzfSN/viDG7UM7BuAhIoK4ECjGNxbJMK+OC1aIbAYK/dZN8XOeEWpUCC6gHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZz8gjfyP7pKzxpnQO5BIVe1YYz/zQshSs9gpsxy3j4=;
 b=YOQi83Mc81aSqRhoK2DwnskE4AxzKkREv6MexREJSDbIkz+OcdYfXImNoBwUloi6B6te3UNzbU0gTE802YrP+h7eWalUlggeXSC2aq31yus5fGgtnlxND5UG8htMHkBdx7XCURNF6nP0Cn3nFwqxHoE7UaSOgUfbHxINoi4M0tOEOq6gkNVLgXJoy+CTNbYMnRKnyPzeRbQ1904VVp/jC97Frlu4Mk5eGDqtMbwbyEoBygyoMTx/mVGbjVaUZIiVh6QsWxYR/ZOqPymvC0BF/hrxR0RF2QZbfF8PdnbwatPkD9hymTtYfq3TdDrtwF15ttxn0LhcPt8FLL2j0jpAJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZz8gjfyP7pKzxpnQO5BIVe1YYz/zQshSs9gpsxy3j4=;
 b=WR6WPSzOeoMTZ9juaNrXCF2g2Srluugx/Hg7SH41qad4Gb1SisS01OTLWXj18jrsKg96ThLLkhsATuKt1V25U+/ODy/HLoM7wXyC/XbUA+uyttX67qi10ZB3O+C6sdNJYMBaGlcSIHQRPaPnfwiO/XC0IGwJRnBmmUeDEnpC91tadx+6ohy5T+RMfM7Bj0LgWR9v7mqguLxK6ixzoxMI8SpSAfoBRVZ8nxQA6AhrssJ0Bx1H9JKRw6rzdH3BOlvlwZEAEZhE30nv+A/RNvZW7umucCScPpBaiJZkBFHqNCDOjGGSigG2Y4vWM71jTCcG+K+iLUTeJGHqT1GkgkZQUg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW4PR12MB6873.namprd12.prod.outlook.com (2603:10b6:303:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Tue, 27 May
 2025 04:33:41 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 04:33:41 +0000
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
Thread-Index: AQHbzEzI+6vBCHMvLU6Sk33wF14jHrPlo3wAgABB1qg=
Date: Tue, 27 May 2025 04:33:41 +0000
Message-ID:
 <SA1PR12MB71990A84FDB4350DC02CEC6EB064A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-4-ankita@nvidia.com> <20250527002652.GM61950@nvidia.com>
In-Reply-To: <20250527002652.GM61950@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW4PR12MB6873:EE_
x-ms-office365-filtering-correlation-id: 7924279c-963b-4553-75e1-08dd9cd7a85d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?hMLJ1iUgvPYl72UEKYSmtlJXV48jtpiOmhNVOia2ClLF9pY/6O2zJ9zCEA?=
 =?iso-8859-1?Q?va5aVx8mxMp3xccaJ6qnDraUaTZliQGQBFqJvYksEB+MmT8DOFWbEV2Gpz?=
 =?iso-8859-1?Q?Bah/284PVV3/7qbTjFzlOb5BZdw1Ps7jwu/aibh+nTUAgDXPBCf4WFrKEJ?=
 =?iso-8859-1?Q?4AtouCsirNzGHm/9eQrLxJgu5R6s7zXBbmifPN+wyWB4fMGq8DgH8q0vxI?=
 =?iso-8859-1?Q?++pSIir/JSxQTz3wJtWm64qP+hVBLuQIwkWa9n3xSM4riIPJ9pzHSO/Ppd?=
 =?iso-8859-1?Q?OYDnmyhbXZwx2wJe/OmraV3v5xKx+Y490dGKZjZ691CoXAlhhYH8baIAk8?=
 =?iso-8859-1?Q?NuvlpyUa7Bs/OMzSSPRGTO4JpKkmKYSJKMmzqu1FiE276l3/BEJgb4N0xQ?=
 =?iso-8859-1?Q?ymd5mw2RSt0jMsQuDBTjJJbXoXiVHpgnUiDP3Yk/OOs7D11v8ilWx8cYh4?=
 =?iso-8859-1?Q?cxLcSCdkRUdLfyB9VSlvihlWSMHPUxdoLQUlHno4UMuhSqr6wFlq8tsaQP?=
 =?iso-8859-1?Q?y7OTtp3xDxW0ZZqfgf0EMdJAdXwWe0bdQ3bmyomXEfH98xgHbo1lefumCG?=
 =?iso-8859-1?Q?klcNELeDP3A6jQl+7G28fIbVO4iLr4PbDCa5sgpw8yFvX+zDuQZ6SEu0EL?=
 =?iso-8859-1?Q?P3s7WDLjPB192QUTSMXeOaYv+SJ2oYbF9DHZfN7mqFQyl6Zmm1YdDCIbKk?=
 =?iso-8859-1?Q?qbYD0Ro7z6tP+2KBDiOZr/o15l4c3yG63xdxX44CsOAusyM1kgRL6Qj8Hm?=
 =?iso-8859-1?Q?828g9fLBuaCIope2W8k9V3EC01T8Td2qVABD9mPbZffuKVO7cZ+NeyhPAt?=
 =?iso-8859-1?Q?CwHXNrBOwADlkvHsjVQIxoRXZfBu6LNNJDLjgheHeX4dnKaOF+iAwEDwok?=
 =?iso-8859-1?Q?YoZVXFdLTaWr/2E7Cao808hjWN13W7uhoPQz1FZ1xGcNc3c4PSaI3USmQN?=
 =?iso-8859-1?Q?ssjdIKGCGQabIDZX1eaGGhtB47kPm3sWPB2SFr3r51BHKueh5HmT+qIPoC?=
 =?iso-8859-1?Q?YjgdcOpVvbe+uu87YXUu/+VdeJNHGmk5w/DODF1186PgbhLjrMP4ceZZbA?=
 =?iso-8859-1?Q?rAi6UWkATEAyrVR3B4QWDgv4EG3N9IBYNddF8xLag3B/vMXpb8hRgaukhW?=
 =?iso-8859-1?Q?Jh7k7Zc6JZEGepSi8V+qbfc+mzEC6um4nktJedr+ptWBgHMcjHgM/ZtTYH?=
 =?iso-8859-1?Q?bqefFPY6Brj3YLGKjwKrkFy5UxZ+M1M8IgG1D/q6hoCSE91JM4onOLFoME?=
 =?iso-8859-1?Q?rqTuFoa6jHYmhlzy7CX5dgm6hAqQ8PcfcPQMQwnzV/sryMlKxVcFFe7g7U?=
 =?iso-8859-1?Q?YzeKTV+HipaShCPzU7XyO1GMUbH5uBnDDnhWU3CEDG5brqyby8UnqvqQw4?=
 =?iso-8859-1?Q?3hhTMiaWbVfN/FwOHZJKtHvIxG0Cm3kha1ZMNE0SEUn8z8UjYpGFuvb0Qv?=
 =?iso-8859-1?Q?V8rgQXtMWeSwz3h6cgdA9J5gdsk1PfwvCCh8PEo4fnWDnrRNBaiE6rIGtr?=
 =?iso-8859-1?Q?lLg9oSS5fB2+AHilAQXWgkVPZ6nPwt456k4G7ZPTovrOUd85dAzNclAmSq?=
 =?iso-8859-1?Q?KjWzj1g=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?p7/HfBuRh13vCLGi7oohL0a1sz9JU3Lmz/voscZPxbBRrKLt/RCsixeIoD?=
 =?iso-8859-1?Q?KL9/gmGfAE13PkpQ9+rgaKLlSKk1R3vJ3X7Gg1cJzw247jYZPJQb9rewUw?=
 =?iso-8859-1?Q?VVhBz25lnEMFK7V5l/qTSn3U+4dL4gf+jbZ0/dWSyRa2uVWbwa3q2m4JvQ?=
 =?iso-8859-1?Q?AACiHNbdxMlpsljfvtfWymofnRbh+Wz+4H9LVzZBa6sz438pazhQ1nJHdS?=
 =?iso-8859-1?Q?Vx/httm+fP8MFY7Bu72B9aGOPd+v/VKV3ppXfgHuwRiQWmqP5LGFmeIODW?=
 =?iso-8859-1?Q?B5AowBDVfjzJMCf+KBFiDyUzdmRc97+oE5d8jD5pn5QJrHJFxjEwfjaGJt?=
 =?iso-8859-1?Q?1n9PVnjt6XkMPYs8cqSah8TDHtHzLi/2nf97FbLBohzM8ymtupJv1BurBx?=
 =?iso-8859-1?Q?cKTOHVGK6f+mXAznSDU7lHD4tFEuTQzbHX0mJvqcDOdpjdg0n998I3DISL?=
 =?iso-8859-1?Q?4xk/b01dVJeRZRlZQLSXWPzQcTlXFvnxv5dj+rBhWwBEcSWMVgf9tKQYNZ?=
 =?iso-8859-1?Q?wF+Zc2QguD5KhW3cztb/+LzujRtDrVuWPRwbE/uGrZ8PgWmHvd5N9ag9wq?=
 =?iso-8859-1?Q?lvhgw6VRUFwEqmSywg6lxM9aGLJuPhGPAQ7nbEzavX3EkUsctv9BDuNrLC?=
 =?iso-8859-1?Q?IPTglfHcjM67kMO82Wl24LTUlq265zqiKWOUdQWhkoXps+eumzKhd7D5t/?=
 =?iso-8859-1?Q?d7mzdwzsDAFbLfs4afBIGz8yRcNcqmphUEPsEvDADM/ZJjw4G2BGEX4b67?=
 =?iso-8859-1?Q?amtvY9LzRNovIXCOqo5gRHna2t6PsCFbROLgRiXN/fucn32taL/ZzDNkwM?=
 =?iso-8859-1?Q?hhRfBDHQDKd+ynjhsotCrxNp59+HWMl/iDU9cu3ofzIIzdUwrhBKUWL6aL?=
 =?iso-8859-1?Q?pjOAt0qnJ7zag6oZhVdeGAk++6EP0YNhgnSwUjRYQrXEjgAFAcyGym4XNs?=
 =?iso-8859-1?Q?gu02+prfa+6trMsq8BGz13tDWTxm23Pil2Rer3zLwekNXleWJBe/RTbw+X?=
 =?iso-8859-1?Q?kCOPaF1qiW4RpLdYBqR/FRWhAYVX7IotUMMU5BkqT2ldMWwSzORtonvtED?=
 =?iso-8859-1?Q?rnmVMSDHMKGLpBXRwenFZOO67sciyADwE/FvNIxbzBOFelg/oP8d3WJwSi?=
 =?iso-8859-1?Q?rZaWCgmEu3Vrdj/E9W5+nqEJlg5eAK1x32tKbMu+0GZ7BfT+Y/mc/vdegw?=
 =?iso-8859-1?Q?t8PoudO+1YzfZKa+nex9lyUdHAMj7JvLXDXubbbSdVBJevKcDFtUcrPnw4?=
 =?iso-8859-1?Q?hkcKf4zoqH8o7XkWRoNJELYihkIjUhUl1vbwOfgDbCytKKcdMfO+8ye2Rq?=
 =?iso-8859-1?Q?SQ9+ZF1/RC0AfI+qbcXrNvmNUStt9cucHUv4rXLTSWdhtxJMCLna8zVJID?=
 =?iso-8859-1?Q?M0Wx1dqm991h/zUSjL8CSE/+BMsZvE3t2M/ZpjrV3dBlvMVE47TP+hvpm/?=
 =?iso-8859-1?Q?Mr06IWXlF2C0SbfGOaf24Rt/RdvOY7tT67BOLPRQaeufNCYYp0aIoH8+Mk?=
 =?iso-8859-1?Q?UA3/PxPmjZN3H16lyNDnFJux5Lh+miNuvK7ZLkS9oAzDpLGjkSeDIhKLhk?=
 =?iso-8859-1?Q?dqBIcK+OjaizdIS1rh/7ox6ivJFFxaIM9y0N3f5RVNb0VYYmupWo4nZWU4?=
 =?iso-8859-1?Q?7u5zN5zojII0w=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7924279c-963b-4553-75e1-08dd9cd7a85d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 04:33:41.2406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TMGBbf/CtH1gFK/l9kN2BLx4nSjlT7vgYE3kBucbrgikX0eTHAnqxK6Iks3CPzpHNiIlfgDDS4ZKL9ZmAqZarA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6873

> I thought we agreed not to do this? Sean was strongly against it=0A=
> right?=0A=
=0A=
> There is no easy way for VFIO to know to set it, and the kernel will=0A=
> not allow switching a cachable VMA to non-cachable anyhow.=0A=
=0A=
> So all it does is make it harder to create a memslot.=0A=
=0A=
Oliver had mentioned earlier that he would still prefer a memslot flag as=
=0A=
VMM should convey its intent through that flag:=0A=
https://lore.kernel.org/all/aAdKCGCuwlUeUXKY@linux.dev/=0A=
=0A=
Oliver, could you please confirm if you are convinced with not having this=
=0A=
flag? Can we rely on MT_NORMAL in vma mapping to convey this?=0A=
