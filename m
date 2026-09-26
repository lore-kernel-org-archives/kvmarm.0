Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013042.outbound.protection.outlook.com [40.93.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80C4423E98;
	Sat, 26 Sep 2026 11:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790422397; cv=fail; b=VCue1wUDMCb1BCZYXf6JT+LGrv/NNRJRoZfSJuSXbG72tw+N/vYgC2ujuXplhNCHlCXV1Te3x8BG6rnn7dPtCczRviRNM0Qd+GQ6XAYubpdJq0QzHzkKRFUC2jZlY5Mf6PMKJn8xOJ+GvlG6JPzGFvHYRRvb+SV4zb4GWvSlH2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790422397; c=relaxed/simple;
	bh=aDsUTFHpgYSoGE4GMgTY2p54I1ZK7Jy6oQelWXVm60g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bkcAvcelj2yHWuSQboda0CLD68sfVLb7P0EYhiJCx3Unbz+xlWg3zyrIMWn0KRSKbncaG393iqTiI6iJiXVbhz1HiweqIojjthYAjpj1lPvhNfUcuJNtXNYY6wWyGM9L4GhykuZryUzYKe4YSq3jK8w5BWXvwx/3sbkyQ9wm/48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EpKOip7Q; arc=fail smtp.client-ip=40.93.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EpKOip7Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YV0rUbIEUKw/qSZyQi9eTkBFZDL5CI17ZFgAipwDr+2WklFWJZrB4vs4KCd9sWKybJyraZ17MO+fOcNdLkRbO8SEbhfK0Plu3Xxv9LWCfEC8GJUTghRi3MKbrzzfE0xK6o6Gg3Jdh8ABSxMRKuRStsljXCaxbVccIrFRmKluUGf4h2KVR2jgA1Tup+fFHWrcWkZ7oQuW5oXX37BpzSACflxc25tedEMbRhmMf4oa942zLhQvKUG4YPAfpBojZRSSYJPUK0y40KYHzXoNMLKvnUUsUJbXijGj9lJ0BcFh1sv8US+W1P+cCI6dH044Nw4QaQLkkc/7GGj6MnNMW0Nt/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDsUTFHpgYSoGE4GMgTY2p54I1ZK7Jy6oQelWXVm60g=;
 b=JDv8wXpNVNIF1wq+MuI1jZqmihIVypXlrtbZ0fJR4qw79dLfoD/m7KxRM0wp0fmeYiDFF8lQh+StbfnorF8Q4eL0uZLX27y3FhxEnaCDgrdvIuZ7v9NglVTdk6d6dhifXBfg9dnSIiZwfQK4sRUBVpEvCJTd5As9Pfxg4ytAVuiKSrBEFdcLWf4khQJF9KaT7pd6BSsPkwdDmVR5+Vtf++8oR5tvRa82L1V6slCm25q+9OvDlJ/mfIjUMCi8Yjp0j0ZiO7AhncnHibvqxsHh3C5Cg6lPCo0oCqJBEt7EtPF+iDjU3N0twO0mR7pe7nVZoVm6G414X/GRcM4wOSZadw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDsUTFHpgYSoGE4GMgTY2p54I1ZK7Jy6oQelWXVm60g=;
 b=EpKOip7QJ4ZUkYIdgernN6bbJDi7eFSgRDWfMOnHGv8DiZN8CDnS4kVfIdSHLlyRuNZs5MJRhb+4urWoxySOmVX5BF7LU8uuJM022ftwgP5Z9dGxqR38NNVjkolkgboGdv/hODsprS09k3qdjK+cckmqMJtslHlzfscx5IVyuy2hPtLdSDFxeZ/PDT/AnUMk2Kvd595HBMN5bgmfNEo44zdSIbD8gWIy8tX4qn4c/9D1tAfNO1Ri6oIh6AHgQEdTeVlksycGewrajAR4prdasafTRXM5uq4wAwg4Ishb/4fXQLRRv/ffcrwxAMZwfPSjDMfWY2sfQN0ipCD4rCKl7Q==
Received: from SAWPR12MB999267.namprd12.prod.outlook.com
 (2603:10b6:806:55f::17) by SA3PR12MB7902.namprd12.prod.outlook.com
 (2603:10b6:806:305::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Sat, 26 Sep
 2026 11:33:09 +0000
Received: from SAWPR12MB999267.namprd12.prod.outlook.com
 ([fe80::fe35:8a00:d9eb:40f9]) by SAWPR12MB999267.namprd12.prod.outlook.com
 ([fe80::fe35:8a00:d9eb:40f9%4]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 11:33:09 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Jonathan Cameron <jic23@kernel.org>, Marc Zyngier
	<maz@kernel.org>, Samuel Ortiz <sameo@rivosinc.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will
 Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH v5 11/15] coco: host: arm64: Connect RMM pdev streams for
 IDE devices
Thread-Topic: [PATCH v5 11/15] coco: host: arm64: Connect RMM pdev streams for
 IDE devices
Thread-Index: AQHdQTBNZsWT6J6bdkaQWvWFEK2da7bg0YGq
Date: Sat, 26 Sep 2026 11:33:09 +0000
Message-ID:
 <SAWPR12MB99926745B6BD6A876FC837D32DB08F2@SAWPR12MB999267.namprd12.prod.outlook.com>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
 <20260910140509.868402-12-aneesh.kumar@kernel.org>
In-Reply-To: <20260910140509.868402-12-aneesh.kumar@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SAWPR12MB999267:EE_|SA3PR12MB7902:EE_
x-ms-office365-filtering-correlation-id: 06b24f39-4015-4edc-9b5b-08df1bc1f112
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|18002099003|22082099003|10067099003|38070700021|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info:
 kRVYnv7029FVcXToD9BOXBL6dC7tbVVVibNsLU+SyNTKTkaY4haJubtaF9cXSVzRL5V08E3mEvWtmuZOuN6B+NkLDoe9YpZ+xxSRz8nsJjB5F1ml6z91FGHRTkc24nnFh0qF64oAfDmdfg7fEVyj/KL3fk7m40MI6adsEh64uWZgVF0Oq6+XEZ4F2k6awSdWH27ZoWngH137XjQql9lZD+6rHIsQ26vq3/jTE3dyUwWGQ8x5pHXxk+iZVraRKY706oWecBKRA0YEGjWnBdqnJLLSGxOxD1/1For2fbGGRpvC+MFmEj0V+XVsYWMSQrwAldmor7FgqUurcU9dH/IJCP/BD0YZE3UzwxiBUOOfRqZSyd85fVQ/mFLtZc/bz6jsO4kFfxC1UL+2+2HarMiH3PZQxQbyu4+gMZrCiNw5o/+RR5a2lp7LhCto5RzSi5LR9E6okMmmyDSdnweE5eF8a6gqXyjgzDuiKNvu+sRrJcvgjulkN77SzsIznrr3XjW+MNqNCFyRFqNF0rckyorB5S4qjZ/m9x4D5nVyp6k1+RVjkhTTs/oc1mHb1gC1LzZXFBHgsXTUg75bFJFDct1VKiyt1GpZasYmS3ZtUnma5KssCsjpslveX594sbFYZZ3YKZlWjx4k/cIQB7U15EOyMVV75YcOMEZ08w57OQRpi2IM96m/P87xBfRzIHMa2INNwDSvB1AmRy+5JIHvqn/8nCCsOsAq/hPnkrheBebCUUA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAWPR12MB999267.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(10067099003)(38070700021)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?MHIPlg9+A29+LmfJYO5zQkgXGSDGdsg1nleRSAg+OVP656JsUzNockOE8E?=
 =?iso-8859-1?Q?HbXZ0ujP8oEPssdUl/9HTCSVo29ibbe2xsjnY/+BxHfAcL38AdIsG2PhB3?=
 =?iso-8859-1?Q?Z17758E1cV70padzmH/e4+/v4XD+SwgZacBuKqvV5B19FFjuLtKfqhESrw?=
 =?iso-8859-1?Q?7PvQ7gmZOSDLG4SeVNMPCy7X2lRU2Q5xEMw+szIPLan3jjpLPsDspB6RVR?=
 =?iso-8859-1?Q?k1fmGGJVZ6BbyV2Suxc+9h732mZoyvPLg0gw3Ge2DrvMx5Baf7IdTO/deT?=
 =?iso-8859-1?Q?MHXWLF/GDqq2Ba7tCQ4+MyPnOZyB6LcNX7ZfFGglbd9gBMQVtJ6mykpG/t?=
 =?iso-8859-1?Q?o5cR4lamlfLLAvYX9M2q73CWiuWsZilSVbosRkBA6y0oSYYIRQ/jid4kr9?=
 =?iso-8859-1?Q?GvVpAg+yxE1zP8O7P7yhWvitLcXfVUkTnX5/yoyHxkRn72o1owawQyPxU0?=
 =?iso-8859-1?Q?yHJl72al9+Xe3suVLLxsIcHl6tjpFxmqM69idr6PjsSG+Y1XtZKRjpd13u?=
 =?iso-8859-1?Q?6IUqEdvF423XkCSc8HAfxaoG4xOhTmOvIZPNyV1EdDQRufyEceTpeNZCWJ?=
 =?iso-8859-1?Q?oRx5bKLSTy+Fk/jVSvtKZ9aTTb5Sxrm2Gj8OZLcSNLHta+TR/D8QX9b+pO?=
 =?iso-8859-1?Q?Q9KSC7+nvvFumGinPQN5VrJ7qOxxnUQLOM56AjGwS8wpKnR92GzdmAcd0w?=
 =?iso-8859-1?Q?spi2rdSA3g2qxSpm2n81E+qghiqKzy++EQiexWUHUjWEWEJjPMkQlhuTjU?=
 =?iso-8859-1?Q?XeP9UukpcFaq1AnTDqFDbbwlLjrRMBLgfa7CdT1Ft2pVcZIqP2BvFvkaNN?=
 =?iso-8859-1?Q?f5twJ+hWWIgPEBgspyTKH5I4Xrzxkzt11ZCTLdD6qTcej1XnOTW0LbWOKq?=
 =?iso-8859-1?Q?UIRm1Q0NcJ5MRPE69pvviIey/QX42FHiEj1ovF5zmX5vUPKx2xEImXFtwP?=
 =?iso-8859-1?Q?hUuLB01TMC7D+8z655q0X7eXNWX9fiFltWzg68RnCY7p3I9zLcsByszf/3?=
 =?iso-8859-1?Q?A/60Cz5tJgdRstJZI8e8n5dska8Aj+f7pEly4mFZ7GdH7eSZUZ51MW0t19?=
 =?iso-8859-1?Q?I1qWE35fj+U5kLhlgSs7xDUXGYvfnIP0Qm9Jnjcai0VUbTvkiL7is1iJkC?=
 =?iso-8859-1?Q?xRR6p0EsPl2Ec18mlAG+U9Zf+1t0gJ8Zpmgu29K9L0dxYmZ0HLd7GN6G4a?=
 =?iso-8859-1?Q?hdMwhmkjp+zx67FpjZw0ZIc9a6N6yF45DWYqwJQp6PFP3ejWFJsxQ0Bbky?=
 =?iso-8859-1?Q?6Hw4lTHTScPBh/GY8/nBV+gONfpAXB386I4MUQWkBxZgMzjjX01HHjEPze?=
 =?iso-8859-1?Q?C7FLedFXvPxHGOLzljGvNOz1sd5V6IauOpX+TqfZ1eF0P9qtvkzm9zURFs?=
 =?iso-8859-1?Q?jAKFiYiNRNXPlFEzsksJdHbVke+yOUI/ioLpR5DUsea2DxYgMtW7nmwt3D?=
 =?iso-8859-1?Q?hJY2aAzAgAomXgjrqd+40P426HLsNUqpxO162Y4mxQ+OY6wzCNHXdz5En+?=
 =?iso-8859-1?Q?pMM/5vhTISgSfF9OESjiMzZQWGO7Nt94lOftcvIsTN9F6e1KQAHgU6HLPb?=
 =?iso-8859-1?Q?z4fP3eDLw67RGWA7e+D7rUUAGd68pPu+BczLC/Z7lkoV75kNwb81APqvHh?=
 =?iso-8859-1?Q?JKkfF6tGLBseHO6kOOexEaADsZJPQlwHd6l7B7X3rX16IW9Vfhi/m6CVok?=
 =?iso-8859-1?Q?IerjPBQAdfNg3/m9fX/KN43/SluQW6R6xrd8o79PugXjrFglT2laC6308n?=
 =?iso-8859-1?Q?8fDkE2Bwx4gOnKW3Vsir2RJhravMKvCZLGh9X0v+fxTjAo?=
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
X-MS-Exchange-CrossTenant-AuthSource: SAWPR12MB999267.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b24f39-4015-4edc-9b5b-08df1bc1f112
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2026 11:33:09.6132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uTpbvobMeWzkpWpP9D7XhQCuorqVI2gfukXCj8WJ531Rrslws/59kwYRbVp/NE12heL3q382Q/F0Q09J8yUs4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902

Hi Aneesh=0A=
=0A=
It isn't clear to me why does pci_dev_addr_range() derive addr_range=0A=
from the upstream bridge PCI_BRIDGE_MEM_WINDOW /=0A=
PCI_BRIDGE_PREF_MEM_WINDOW rather than from pdev's own=0A=
regions? Should it be filled up with device regions instead?=0A=
=0A=
IIUC, there may be a couple of issues with the current approach:=0A=
1. The bridge's window can be wider than what pdev actually owns due=0A=
to alignment padding.=0A=
2. If the bridge has multiple downstream devices (are there any?),=0A=
the window spans address space belonging to sibling devices too=0A=
and not just this pdev. So RMM would get a range that isn't=0A=
exclusive to the pdev/stream being connected.=0A=
