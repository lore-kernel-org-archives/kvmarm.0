Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012053.outbound.protection.outlook.com [40.107.200.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601062DC783;
	Wed, 23 Sep 2026 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166890; cv=fail; b=iu1AV7SHO3MzeXx5rg2LQwi2Zd4svOFpN4PCp+4GEWZJeHJ66ImAx5rAuEMROQ9xOI6PVxVaeXUBsIhaaDFGiiKjOM1JwBXINnrydhzVUPeBpygQOZYBqXOSqIYh01SoEgK2Vxr0YekAv/KYhtVPRTtRg22mx5bB63xbQyGpqzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166890; c=relaxed/simple;
	bh=xq8U72PmaU50iP8Rfwm9JvhobEp4btmjzkV+c3vj7x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QuWud4UXWnMtFgb0FhysNdM8kzUExxSG4+6YlygLsB5aYCMGORr0O5ZZx2quOqzdBi3G/GQTRYSkl7ND0du7qC6WOhojrk5yFLtHuPm9MJEz9e7emWbygwx61fSMpbyHRDqedhxjXasBRYErjQYLiNpgkksR6XzaJ4hRr0O36q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BdTBsDtY; arc=fail smtp.client-ip=40.107.200.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BdTBsDtY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HY16sIxnB3DnjbxytUpjftP7v9ox69Tt+H6Fkr3gwZtXvqxLJUHidsWLXlZnuOeQl9yjnNOnv9kx/TTCjnso6Vvjotn7Ahp1EG/z+nRLVQ0ZWhtPWxKI929+7FnbQYI1J/4e2GB48sd8pEErrztFXJmgwLbQ0i0m/vbdtZ8EmEXtiepMdiiuFNMI+KYyTO0e0fjKCdKWFi8kWq37zIc0DrvgO5+IuAz4V9FHbTFGSs+N/PKflDedcv1L4eEYtzynaxswHaMjpZ+ewMLl78Uc+2ztmlx1vRIzJVBquQ6qHIfh5JaJJRYgu1KPpIqijtUxDPXyIoiz1PZMZjm1UzD3YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCoCW5O2nLttnmjDwMxedUuejmkAjIqMAF7cGJXatP4=;
 b=dJfB5IDQ/w1ScGzKfUIzZnCKnIE9l1OZiXh2lfk8nZK9+ZcJVTnjidBeBjJWbfwt8AxRqwXOxaXvse6XAHIgGNPY/dKNOVXSepuEnfxNbXrez6qnJy5Ic/LKltI0W45P1Ih67/CB9Olm2u6miLYUQdF3bjfk/aLI/chUS7lyE8yCGqXX9mhYQ/7rbXuzuQBuiugGOV06vKTTjZrubNlFtmgy5QzJ1gGAryCt5BYbzPeTp+52CtownibbEqEytHIVo4NSzrIjDn/CM6QSh5d7dIIoiGjPAIqXzt2F62CkRTA8Ru7E9pqBumpWj9V3OR1KG/4md4YyAHIFKvneWXui4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCoCW5O2nLttnmjDwMxedUuejmkAjIqMAF7cGJXatP4=;
 b=BdTBsDtYpH3sjpWgUKbtFpCGEIR0XyGHZ/uani+c+y6h2h+t6m2lwwfzgWaUiaxvVTyNTNbsETjovCoVP+iTxGAkELM2hplpT53bdLdeGx+i+sK2gyDatVOq4zWF7306dQf0e33OWLYm45g794olWY8XUPahSs+yEyhDTL4Zo8wN9QX892176dEBUvVECuhrR2dOTFudJnJFA7bls8dtYkHS4+UCRGzKHLJohRVweyJKz+b9MHnwC5wcnp/DI6j1fMvxY/bHBSyjtyRhjny/bjel8dEhOYBT/MpNg2L0qxk/Ol8fc4nUgxAPJLgGi+pqg1YZR50z5ONRuanhhzbMcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB7609.namprd12.prod.outlook.com
 (2603:10b6:930:99::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 12:34:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 12:34:32 +0000
Date: Wed, 23 Sep 2026 09:34:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260923123430.GF2545495@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
 <arOlQtPYzF5yT8fP@google.com>
 <20260923115257.GC2545495@nvidia.com>
 <arPDn5c815X72PSF@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPDn5c815X72PSF@google.com>
X-ClientProxiedBy: SA1PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::21) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY8PR12MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: c7696a7d-e2c1-4159-c06b-08df196f050f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|4143699003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PLX/f5EQQn0qqVdREvDsr4ylyedztfwq97jwmu8WL9t9TLGblJRSHvzzTK6KfG5SeG4sfutZGy9NlH9M/+OZ7Tdp4KTyorfGWrYhtXPkeFfaw/x88ex4rVNJ7PxOkDvwcrrAWNWJw3Uw3s8GAknrlbQQjDw1geSuzYH77nRm4nkimEv8twRq2QHu2IdBn0oCap4JVh5ZRIE0Pq8o/SIW97dJYbrtlvmvWu4r4PKx9WPru1XLh9QB1wPCEmujMiq24kAI7l9OvqIqDg1D8ND9lMxXXIDaCuhXEmigEfQ7lL3mPRWsUNfnLGcS4sVojBYRgkv+TVUNpAll2dEn+IGlyKBj/u9FwhgVqtqD4C003TQFg/78KiIyNopd6fjdBYfZgD6jkKYStFM83DH0CoHlj1pI5uUGpLf7dSA9EUsaR4VJYFc8iqW4+sOqSUnsUQMlrK5fDnCJJrYuK0CkZEjk3blbMa50GSvgYu8eiLwm+lci3Gm41qF+HMjR6dNRMTpnX6XPkmy8JFSzzAfmMOTFCGP9UF4TMSahmsRIN9PaMe/8WAJj/vS3cM4rVmIRG0xNhs7oB+Fe7NcQTKPbRbzt+m9TjylEpVTq5Wt3Me4sQV0j8i9lJ13EMhijAQRM/3OIPOefeB+6bu6UfO4NGYL5xkYD/l+UWDzXkHyCokwrtRE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(4143699003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cJcRknsVV9IjlD1Whwu0nZTWHo+T9NbalmUzFRtEhfYg1k0YmDa63KWIJHlR?=
 =?us-ascii?Q?oSXVXeA1TXS+UOzmYu1EogJ9L9nj6Jdt+p3s/nvMY30Bl9TzziF8ol/QSZgI?=
 =?us-ascii?Q?Oy8ayAyK1yAnn8Z2KvJySru4PvKFoVola4VGYBfyuJL65eHyQaytzOPqE9vi?=
 =?us-ascii?Q?JL8gMJAPAkJ4cwA6hcu+h3nEcBq/2isu96OKAxlctozIjnDe0WqIayIyru3X?=
 =?us-ascii?Q?49ifjKtGY8ZsKZq0kFWb6V6Vrii0HDRvmoQqbOnnI76NZhYOAjY0QteFjD3G?=
 =?us-ascii?Q?Sqx7JI0rzkjpYqFEflusHMVudox+J7O6bEDTU0u4GGCo2M/bLiouF3k1xBbm?=
 =?us-ascii?Q?XraS2VwSjPS8y5wriv1QHhwJ+cQ+Gn10FGgy2ksCmOxmnM4GoyAZSnHX0+r8?=
 =?us-ascii?Q?N1TG0j40AA2w1YTfNtBfobPdkFR/WNmuVkGtpicHtiVPxfynxg4Nub2DJ3/e?=
 =?us-ascii?Q?ShfN5awwf5zz6dfkfx825us+JoVv4RQ1j5FcewZ+fFnEWGUEGnXuqIRRmD+L?=
 =?us-ascii?Q?sOvb39uLqoQ/llehs8KDBveYvmQWfXvHM/4/7I/e5HeyV26zWyTiPyu4WR+H?=
 =?us-ascii?Q?RV885N25IO9d33Ad5ffTrDq53XHG0NY5DlR9nlADfkKAiLtZ+myICJaZPtHs?=
 =?us-ascii?Q?1k7/4zBpYzm9e0UgFZAoJdYkstoepNhCSu0cwSiMUvDXMh9n89wmLjSyPdoQ?=
 =?us-ascii?Q?UnD/kyqXKXwGYajdbPU+4+zC8tkio75PNoClqdvMW/dku5atd8kNn9+p0VyB?=
 =?us-ascii?Q?qobovReImkHlxSatNjGgvnYkDN6L1VdUUWBnrmFmuYrNp+BSQ81tfckQdeNF?=
 =?us-ascii?Q?h3/S7B3V/G3tR4R9x9o9NRQpVUgrLQ0zgCu8APBsOKYIGAx8sK9lzIpsfw9L?=
 =?us-ascii?Q?hlXRanVcgbbXOakdgHA4d3NoOcq9e3O8gICeWiO/1jNPYH2DMtYJI7AEfadi?=
 =?us-ascii?Q?gyApGxHYD2GTGhouFWfBrXrbntMoUjE2P6kEaOTxFX/8r389RX6oFMsoCNIu?=
 =?us-ascii?Q?6u9mCKWmoIl7q5ev2+0vk8kt8aMWUEWFecLnts8l44o4ehsnnl7AVvaGf1tY?=
 =?us-ascii?Q?TM9j5HmXD4WRZgO/hmfkR5j121kOK9ZaChulAxJ7HATnutHEi0sM0k3OotjB?=
 =?us-ascii?Q?EvXL7cvbYF3Rk6Ojk5ygMKVu1DMIh7+Icb0wx87fPnBpM73+TdHzuziHeg4T?=
 =?us-ascii?Q?4oYrEQel21k7OqkKafSIAimB0metGv1/UD1POH0X4KO3C3q1p+otRWnyVdOv?=
 =?us-ascii?Q?RA7q8mAE8QqvWIxMCetRTxN2fmi4rlTzhOGjG8Qp5F4/HIc3lg9tDtRbEh36?=
 =?us-ascii?Q?CfpNGdCZnFepCtGSOke57+jbaw5kQVLMssejSeTqyg4kp6RrQJ5gBcS+uwSF?=
 =?us-ascii?Q?JD48DCb+92PVSqj59TzdeZkNIdcLW2d46KyHGbXgnux4K/SPdG9iEgmw3G2a?=
 =?us-ascii?Q?288x9wgdKDpNWS7AQ9Z/x1edJ1CLr34IU6ucAKTVG5ci47m6teoTkMiiFtuq?=
 =?us-ascii?Q?3o5wEx8evxoxaRE3fxuzB61vpgztsGWjaao56eOYeak3vhi6MNlcQuPEUcxO?=
 =?us-ascii?Q?2NBh263SU7gY2Rk/3tzU/eEf5bbie4xpoSThIpW/AVk1MGeC0uTyhSLQZ42f?=
 =?us-ascii?Q?2hsSsK05liqQTADhsnlKLrZ+uJeUwIEoNRvqZ7oFQyGL59rHogCenV+BeqJf?=
 =?us-ascii?Q?NMbHJHKeJlQFLOPdGeJHiNCdvypNKlM08FQOckgS2QZnHK2b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7696a7d-e2c1-4159-c06b-08df196f050f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 12:34:32.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qGFqhTJBoL8DbZi9IAK0CCXSPmYGTQSXxn+h7kQUUzAguFIhi87I7GQQKgzYrRw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7609

On Wed, Sep 23, 2026 at 12:18:39PM +0000, Mostafa Saleh wrote:
> > But don't you need this FEAT to issue invalidations correctly?
> > pkvm never issues a S1 invalidation?
> 
> No, STRW is enforced to zero (NS-EL1) with pKVM as the kernel must be
> running in EL1.

Hmmm. Ok, that is what the iommufd flow ends up doing too, but still,
I would expect the hypervisor to have ARM_SMMU_FEAT_E2H, though it
would never read it.

Jason
