Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A5325291F
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 10:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745923684; cv=fail; b=lkiG5dDe4d5D8kigf4H9oe/g8GUgfM3rsd8xFv9ZdtIk82+7vxGfHY1sa/PiWJgjFiowf/GiQkgeX5WeT9vCXIJ4dBpSVHwwnSKYNIlxiqMc2SxR/STIFxxEfVGjCU/HUx+AN+YS5qoSdB7DmwtSskbFm7fnUbfAzOt08gQOnVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745923684; c=relaxed/simple;
	bh=MtN7GvBpFuj0O/Dp3l9Ojs7p67XdJycpICJ/DgN7IIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uu55U/LIPkyxQfyhr72wGUCQEtxdRaHfz5Ed9kU0WG8aNBELXVTIjgpKv4Jr/T1tsjQvBcqpXJEroIFgCBQAN81fwekk0SZx5GiqvzacjdLImo20uG49C7pYcvBO6ubTTTm2zcL/SZpjtH83VtMwkiWqBv9jQO8P3qwSImat/sY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=op0tN1Sr; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="op0tN1Sr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnbPan7DDE26f569yv8MQIpTWt2tCOtiUElCCmgw5qIzZYU3swNXbXM/xKSWlGMJ5Kt5VLbXpA0+Xd+CcMsrb7TFWT/fNznpbIoFKeLzHFP/FvkgkyRHsFpeZVsqWKFehtnZu4DDHrafYGzutwMIvuLPJ/Vbv1PS2CSVZKWaRzMEwt3xfoQcdFIdlzOxHNCIanOHwq1RowML0CDNd9HagHAxGt/DDtDi41lRbyQKHViKiP0AkjGFaRp/Zxb6YqfyeYQboNMGhBuDB2vnE0eZa6pTCMz5uwo93zwpBpcWwG9iVpxakM/izMCANxOqjQ/hSAqvmxzktE/FMQVUNYVZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtN7GvBpFuj0O/Dp3l9Ojs7p67XdJycpICJ/DgN7IIw=;
 b=UUmMOQkoDfxXaoyTOy5Apwtzr6XvO0M57SJY4u5ErNrJoYBFyQvkGEdg3NFrLmbrQaqCO4NIBzX2SUDkdClFmBP0pU9/w0/EGVvIfTVnWtKXc+szZnbqaqwn3nD89pH/SI4gQOJlPeGmacd6gQO+83RdS7gHlK8PwgU7fpSp18WiW2hvMGHGlcfdezQZXyQ0pivrAqTNtYmm8jPDEgzhZm/ZEoZI2N8eFItn3STv7eq81ZJfVF/9Hys/LpYFChzVrxjVChkLpngWVGO/rAvPd2SrT7dK5yVS/QZyOFKfN7R4Q6Pf6lZfQtxZUq2IsIZuDXkyYYC2hTMZ44E9r9P63Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtN7GvBpFuj0O/Dp3l9Ojs7p67XdJycpICJ/DgN7IIw=;
 b=op0tN1SrERQ6gofyuJf6SVLJW+bXZbFP4V533q18z+fytDSU2BZp3qD30MaAF6NSlsxmuuShbYAHi7OPj7WbmeanIAjbZ6D9MUSg38kAp8imVqm5NReqGWO6D1NxdXwWv84VPVYpggVF6degt0mJQX1aCHSM2RJS2uK2pSwO3aG7qBYmAXAqcC1GpOEnDbzOmLCiIDljiUSAhNVI+HV4dLknYkuemUtPfQC/bUluuKOD0NO9ZSS3rW0O/kq/Rzl5QPlaoRbFHrkNi1vrdqAscZJLeHnMTmXKnL8/cYpoxRxuDu+1M2sgJB7xlJ7Q0sZUpgRjAAwbgwlqejWhRipLYA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by LV2PR12MB5726.namprd12.prod.outlook.com (2603:10b6:408:17e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.35; Tue, 29 Apr
 2025 10:47:59 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%6]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 10:47:59 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Catalin Marinas
	<catalin.marinas@arm.com>
CC: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson
	<seanjc@google.com>, Marc Zyngier <maz@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "sebastianene@google.com"
	<sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com"
	<tabba@google.com>, "qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index:
 AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14ggAFVjACAATjx0YAGtS0AgACvDoCAAOaHAIAANr+AgABucICAAD0IgIAAg/iAgACoeYCAABKYAIAAFAsAgAAouYCACiALVIAAbFcAgAANkACAAAgBgIAAHy6AgAAGMwCAB6GYgIALBt6AgAAPgwCAAAfeAIANn5WYgAleFwCAAGYXAIAAMRUAgAADmACAAEoDAIAAI6kAgAC69ACAABWygIAABr+AgAAKNYCACUShlA==
Date: Tue, 29 Apr 2025 10:47:58 +0000
Message-ID:
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
References:
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev> <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com> <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev> <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com> <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com> <20250423130323.GE1648741@nvidia.com>
In-Reply-To: <20250423130323.GE1648741@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|LV2PR12MB5726:EE_
x-ms-office365-filtering-correlation-id: 49eee2f8-9c57-4bac-8b08-08dd870b4e9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?AAJofV//5XSZ1ra6EVzCim+Ni/GoE6F7Q1ZGbdrZOPBXZEibH6URTBuBVC?=
 =?iso-8859-1?Q?gdmVsUrk7kvorY4V9zfhzzpbDS/ZG80ZdKK9nvHb1U+y9022G0irItdulD?=
 =?iso-8859-1?Q?8SeQdV92oiCmFXDJObNQXQ+aRTmqADbGAgWwLxORmo+aq3UOYaiPX1wZyn?=
 =?iso-8859-1?Q?W7sP4TD9nje0AhOxDDuZbK0LAtRqb2N0tyfl1jcGWYkMYSoiMeyMhOAjbP?=
 =?iso-8859-1?Q?KcvZxg2jCJkwgphEb99hekKV/BYCvCW91r+vjXpNWSKhI5xqeYOl59iAHN?=
 =?iso-8859-1?Q?oRyxBeGPZVgaifbL8CvDwnYu9+/HfWKM0ex5B/H0AuGJDy4qthHnmQE/cy?=
 =?iso-8859-1?Q?eCa+i88nxsTqgPgHrrtNrvIiUzfFY1dtpSYTX23DfTxC1D/yDzxOXpah6l?=
 =?iso-8859-1?Q?d1K8TnlgQJZaIMeyx71pdwgQiCoY6VsIqxxKRLF9wDQ2/6oLyA8cmie6Oq?=
 =?iso-8859-1?Q?7Pf/1PbGIxZ/uzhtUrXuBJJBZN0DYqyEXfrf9hF44TR88DJAFKxdlHoOXR?=
 =?iso-8859-1?Q?WPkHQ806xolPVImu5BYe1A3YNQiyVyyisIGhXTL74MpiYi48yMT5fQaMic?=
 =?iso-8859-1?Q?pbW8VoLbDIf131ZzFrNWg98AVq3eddFGaWgEWnbeBSJd1OtwTK3YXANxBr?=
 =?iso-8859-1?Q?2l3ymNqiNRYRhR6AeQV2srygqNug+Rh1m672A5+FdAf/ZOyYrXImbxHX4b?=
 =?iso-8859-1?Q?1M7wwtTNv96HtNPt6oceAycAWP9ijEfxOWpgHbRsDVrxs5/MSE07EPOKUC?=
 =?iso-8859-1?Q?OPbTW/KDXohDFNr+7RbsK1XL2B0zWvLW8vQAGKzF/CqjDlM5t48bxRjRO2?=
 =?iso-8859-1?Q?eB1dLolPu+cdxoGhHQyYKB304rFH5PH7MVhw7hdSdJ0QmYseBHPo+7OfHF?=
 =?iso-8859-1?Q?kYFNCmviRzIJnh6/y0Po0sfxfUKL540EMPIegRkWcuCni3aWcB66EdTsue?=
 =?iso-8859-1?Q?H8Fzd46pERoIKMZQKatEcD4OACfGt2UzRYmnCXxadFe5HBMLYh8wCpA3+O?=
 =?iso-8859-1?Q?vUTFFedPAR1WMUG0asE80r2gj++2Gx6f3DUGqms4JOS4X6iW0MNR5GmyaI?=
 =?iso-8859-1?Q?WmDmsv1g7Bsy/fvOuK79Gj6F3RYTrrLoMhLmSgWHAsShDw8aq5mB4Xlqw9?=
 =?iso-8859-1?Q?fqt1bVe2U2D6jVxCDscc/PKkAcNL7I2oamLJLiFImfAPMD9rinHB8sf6v0?=
 =?iso-8859-1?Q?gH0uzFLnCCTXUQuM2FQTBHGaONu1Grm3HBTGaQWxwTE/D8QcgRKT1uFwbk?=
 =?iso-8859-1?Q?7ItHXM0Ey3Bd4/JiyuVl6LdI0KOk0mitue7hpPgxhJY1ihn9R2rxbCYOho?=
 =?iso-8859-1?Q?KvmX0Yo3aa9UCHo6vUkzagzofVW2AH9JoXU5CryaAAWG618d+NTwZnCkb/?=
 =?iso-8859-1?Q?KAvKrJy7RPB6Wfjy+oDFZsKuiwxziJ9uDUFasxtfjBZ1WpGF9oso4KX3my?=
 =?iso-8859-1?Q?MoItRXKWP8ie5tL9J5sD4do+Fz6D587oEWouxR2/0FDf38H5N5Umg/UcjA?=
 =?iso-8859-1?Q?tG5idzVFus4fM9vC7HmTGZVgDC/dcxrC/AqgDx2PxOEgpssCmBvvUOcjey?=
 =?iso-8859-1?Q?eHrQ4Ww=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?1fICvVHfFkWSTogBz5sEhVRnzXfKlXWFQTySrSMaT61+GNV9ulXsb6MrEZ?=
 =?iso-8859-1?Q?HsjcV5VsgyWypDt4x6tC7MmXAscJbdzu8MuNKAE3MGE3Rbv9kfhe1T0+vh?=
 =?iso-8859-1?Q?wWZc3Py5SEhhds7KjqTZtAXbq7px5N/S+qfhU9Ha+bFvtfQeUP/e1x9VkI?=
 =?iso-8859-1?Q?KtutPeFsuvl/TCQPSlJ8vCzGyKdk1Hqj5ZSTwQAcQ1iw9Y9cDiSxaK7aoF?=
 =?iso-8859-1?Q?is785h0ehl+MRXkOIcQvkVaRwzGIhUm5dwraR20e0iduPZ42NTRTdbHEVq?=
 =?iso-8859-1?Q?OYzY6P8q4YCxqmELwFv09LaBvrh7h4fWbJtaE80wlQhb4TN9MEagggCE1x?=
 =?iso-8859-1?Q?UDVFqYSm3FzmCHQ52RvXiz0jW9Tqby5Y4t6pso1BtSCkmdbL2wjA94m/eb?=
 =?iso-8859-1?Q?E5XT5ahVygZxyhY8E26IRDqVHNA/7bjOKoxNn29gj6Cpq7aK9XVuLxtXE+?=
 =?iso-8859-1?Q?ENg0dohM9I2Dgzq7ZjAmBZvpRnmknaQGtZuG+0tQN9S1cYmJ3pKSkaDBqn?=
 =?iso-8859-1?Q?QX+u7PwPet6dRLssoHPVk9qsGWlKT9yuD5uy2//MR0NI6jkHIBDM5W0kU/?=
 =?iso-8859-1?Q?LPMf/BqBcX8C13KLW+4vmFo+5sGa1ZY14OLXvqdgL8/+pS4fl0Uz6Qt3iG?=
 =?iso-8859-1?Q?HRcEwDPtfCJx/VNclRvVECmNBZ/Zn182lJ1g6CoB4Tbar7OPyzTrLFb0N0?=
 =?iso-8859-1?Q?EjjSHCbqueGLcuKASCeKT7FDEP59eISZQh3qPSefdni3TCERi21sW7y79S?=
 =?iso-8859-1?Q?x33d2ZaRQbIKXVGl74wsxpr6s8tKzwbUtrImkVolbjswvXVRG/Pay0gC3k?=
 =?iso-8859-1?Q?FCsZ1oNfeHYUpt/YKca2kKHzxO5zVna4Jv9fKBM6J/2zBjUrlIhraOIAii?=
 =?iso-8859-1?Q?CChxOwPRP3PCAqXBpJnZKUkgWd/Y73bC97Kd9FujschQTRi8Q7Qdb/J9vC?=
 =?iso-8859-1?Q?BAQgKHydRmEDgOIWxoj//pgAsK/AyzOlpw3NM3CG/WNP7/XOxfk5hOBvlL?=
 =?iso-8859-1?Q?ybCx7mWYWaAduC2MAS8xrFEHZ+OPt9ufjp1gpX7B9kLIhnKpGIAHM9oQTF?=
 =?iso-8859-1?Q?vfDQFemI1LCU6niXUp9iFqZ1ivQVAzzW6IKLdDLXDIeFvzkEp6UaRm51B1?=
 =?iso-8859-1?Q?Rur5CkgWU7VluQjcIvSlWvN2xSGM4JvCZKCbkR8OcnGvM+cV2pPy2BNSMl?=
 =?iso-8859-1?Q?wZf1bFz0bf29qyfYd1j4yGmOnJfPWmnjR2JbqHfcnSHWPquNrLS1EIwBI9?=
 =?iso-8859-1?Q?rH+QnoOR39pm5o9gz/xSnaFKaQEBK2BN1xh0dnwkTyFytF5hq820NeDutu?=
 =?iso-8859-1?Q?wYln2p5df/PTY1rtvaEFsq4dODHOTFCeLc/45sYB2cH+SYlJqJiKLS9EBD?=
 =?iso-8859-1?Q?odWdOLd3idoc4KsWaJk3jFTrtwuRYaFZdSfAu4mmKdBKrJYryTe6Xcuwxu?=
 =?iso-8859-1?Q?FvARuVAbZjMcWQqiOypID6CVauFw8aUm7XCjAjNZkzD/533cXJOWuUIIru?=
 =?iso-8859-1?Q?U9uOAuNdM4rycd/6jpVwiyYU8/UqcRBIm8iovNbFLOM0uCaididb6mzAsX?=
 =?iso-8859-1?Q?GNHW7qY9aywiswT6dLLtZxIsvWwD+GfUswdRI8FUBuX9UUCYDvWnmTh70V?=
 =?iso-8859-1?Q?twdY0uKuFI6Wc=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 49eee2f8-9c57-4bac-8b08-08dd870b4e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 10:47:58.8650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+AmgQIQoVi6WAj56ZHgjwLafOZTXR7Y/KGsUK1VszhJEP76GP9fjGyvNWUHxa1r0nVMCYpWMwjpF2Jwhi7brQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5726

>> In this case KVM still needs to know the properties of the device. Not=
=0A=
>> sure how it could best do this without a vma.=0A=
>=0A=
> Well, the idea I hope to succeed with would annotate this kind of=0A=
> information inside the page list that would be exchanged through the=0A=
> FD.=0A=
>=0A=
> There is an monstrous thread here about this topic:=0A=
>=0A=
>=0A=
>=0A=
> https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.=
com/=0A=
>=0A=
> I can't find it in the huge thread but I did explain some thoughts on=0A=
> how it could work=0A=
>=0A=
> Jason=0A=
=0A=
Hi,=0A=
=0A=
Based on the recent discussions, I gather that having a KVM_CAP=0A=
to expose the support for cacheable PFNMAP to the VMM would be=0A=
useful from VM migration point of view.=0A=
=0A=
However it appears that the memslot flag isn't a must-have. The memslot=0A=
flag cannot influence the KVM code anyways. For FWB, the PFNMAP would=0A=
be cacheable and userspace should just assume S2FWB behavior; it would=0A=
be a security bug otherwise as Jason pointed earlier (S1 cacheable,=0A=
S2 noncacheable). For !FWB, a cacheable PFNMAP could not be allowed=0A=
and VMM shouldn't attempt to create memslot at all by referring the cap.=0A=
=0A=
Also, can we take the fd based communication path between VFIO=0A=
and KVM separately?=0A=
=0A=
I am planning to send out the series with the following implementation.=0A=
Please let me know if there are any disagreements or concerns.=0A=
=0A=
1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_reg=
ion)=0A=
and during fault handling (user_mem_abort()).=0A=
2. Enable support for cacheable PFN maps if S2FWB is enabled by following=
=0A=
the vma pgprot (this patch).=0A=
3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to false=
=0A=
for !FWB).=0A=
