Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020132.outbound.protection.outlook.com [52.101.193.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86148229B30
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744741038; cv=fail; b=l7oZHUDeK5VO7XrDwbRpRM+RK4XHDcHhJR9ZtiFEAFSn2GG5mpTTsqxesmvM1iNDnePhM7n0w7gLpuV/Bbuqe07MVrA6EE4nZMxdSMK/tXTLlFPwDG5Vh15JtBGj/NDWIse7e4X8puTh4I6WsPQ8KLQ86SeDDhWvH7HvZOQQ6qY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744741038; c=relaxed/simple;
	bh=htVQCNcKR9qiu6aHJIDLwxxggRtspqN7v4rQajRhwL4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=q/WyYllcI6YreUh4jUqXSa2iY5v6fc5pXxkiPhcdeAcY7kUOsS6wc42ZsEkTHtZR3eDh7+nEhX7RhzYTk4y7hd/YTEMensqC205SR99OuVP0hM6ECYI04Ivt7mqbmBA1bYhJuFVdKt1ijB5qPvWSm9YCMtT1/4687dYapVCfgVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=SwGlYC8j; arc=fail smtp.client-ip=52.101.193.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="SwGlYC8j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kU8Wb+nhW8iRRj9lL6jCvBMIKnH7jT98+Fc1trtNG1yJhD8pPSgXaGcuLW2UZhfGFvEDLptZdZa/Tga9fzT5Y3V+g8hEvtvw38as5E8/9HrV9/L7HZZ6InzR4vcg2lqZQ3dpM7g9RkwL0uWzncL8mQFGinzgCAzjPLDp/ibUYgsDlvwCqa9vEPUQqeDtwXqLifAs/kIiUO43aFfEDIoiufnA2c1bQ9PnJuvRpM4skMfPlZsz6Lbvj+oqgs7xH0kTNk88dYP/9rb5PdypRNVklIVQvEvvVdlnZHhB7ELF7BbAJlDUOGWVBv1eoeaTY9CKYFRxIbdE9LhIzSqn4rJrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HueGFHZKdk1stB4LBy+sHc6tDOz2N0G8J5QR17FEFQU=;
 b=uL8AX8C82QLAnmSKq+EDSIbNJqpVJmIGZYXQ/+SfBiaT8TBCjL82qZUZJoObGNxoKMBybclUiW+4tgetyi97967Gwob0ygBDvBkSwbNSCqZFqqQYTwRl8KQVrj3IVF3Vf62h5d8mVWzqJutqwOVRGJD1RpsLTF/8+HLSFAHifSFAsKHeRJIM6+DhpLNXic8oHaA6iVFUw0KHYtYavrdekXXWfvw09HyDP0K1tUlra5ZP6M+WZe6+nTvP6aUD1Thqrd3+BWoSTkaM2e/8eV/rdD/FabCREkhC/2OYay2pFax2Swam3btqrlt/zZ/2FWemHGyAw8cIJBvhsFRwWVeM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HueGFHZKdk1stB4LBy+sHc6tDOz2N0G8J5QR17FEFQU=;
 b=SwGlYC8jyYY8+T0WBzU3VKzaJAgaNoTwVw05j1rdQazrXeUF3DHwqdgXYoi49X0ccvK4Nq+jbpYmszhHiX9W9rtXC7iYYqVv4J7l98XN2DYaBPaU1TkrM0iSIgMIsxYqgw3wgm8uzgPO0GUUMAEf7LBQmaOtdBsAUQ21TUUwBvw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 SJ2PR01MB8104.prod.exchangelabs.com (2603:10b6:a03:4f2::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.27; Tue, 15 Apr 2025 18:17:11 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 18:17:11 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, James Clark
 <james.clark@linaro.org>, James Morse <james.morse@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Marc Zyngier
 <maz@kernel.org>, Mark Brown <broonie@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, "Rob Herring (Arm)" <robh@kernel.org>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: errata: Work around AmpereOne's erratum
 AC03_CPU_36
In-Reply-To: <Z_6hjKOJ6TvXYa87@linux.dev>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <Z_6Te1TjMqyXChvQ@linux.dev>
 <86cyddgwn7.fsf@scott-ph-mail.amperecomputing.com>
 <Z_6hjKOJ6TvXYa87@linux.dev>
Date: Tue, 15 Apr 2025 11:17:07 -0700
Message-ID: <868qo1guho.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0037.namprd10.prod.outlook.com
 (2603:10b6:930:4b::9) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|SJ2PR01MB8104:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0bb1a4-f231-4389-8e85-08dd7c49bd73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|52116014|7416014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9EfIvYQGQAkDvUOjmKowLpDMTFz+/d57fLxZvSatu+xxfEUAVk6HHWBgWEad?=
 =?us-ascii?Q?EOchV/6Coo6yR83jPIduTndjNoz3OH7kogxXa0kpL+1Pt90hxr/g4DHzgJVX?=
 =?us-ascii?Q?BwnDxCuIzLzR0oj0eR+k5WtE5ucvfOC4EiOMt+5I7/RypeZOPb2hyIV6OEyc?=
 =?us-ascii?Q?XNlrWxvBg9igFyM2T1x1A8+L9mZPfGiQuWBlp5ORmzHPJiHBP+V6LogBX/qb?=
 =?us-ascii?Q?bRxLzTzz3QI9LMpKUoyDBkC7ZxHKSLNCwCcArAw67UfbbklsOu+bE1eLBR/K?=
 =?us-ascii?Q?k9m8/iymQ/yiZVBO3+2PDxNzJYVacoEqbPi155KmME8zwuTHI2OkdJJJ5Bsb?=
 =?us-ascii?Q?orfExBElHdEqh2eGs7bFV28HoDJULDDXxGW9JYdoDn2PQLCQhZD0e5bjvSaV?=
 =?us-ascii?Q?SFJxClWLjmPU5RYvimHjgyGe+Y5gpk/nMV/T/KD1AFo7GO9ll8gSuGGRwq5k?=
 =?us-ascii?Q?Py7OMkyLD5UJPDoDFCsEL0+8YPB5MG6zttPWuCtIJLd+2fDgWwyvW+CKHEby?=
 =?us-ascii?Q?bFURJC7R8963bTLZFcEFOu3mfp5nhmyjv0IGGPS6ugykpq2abN5FGcJGUbWI?=
 =?us-ascii?Q?zUwdY7ZwxZ07faunH+YYwjMezgt0z0s9apwDrdPZZp7nHopJDkp7fXeadVQJ?=
 =?us-ascii?Q?Dsd4JrUy9WgdusWum7ND59pt/Klq2+KW3qeD6P39KH3GQ38QrJjNFhib6h2t?=
 =?us-ascii?Q?vZemM/pRkPmk2oxdqGeKH5jyRln/r6I7Io7vrfzpNzr6o8pYU1r7NEL1Cg4A?=
 =?us-ascii?Q?MWLfHrQyp2+v8HJlPbscLp+GC0or3R2hvFnJPyP57HfRFwNROdrI600bj7IG?=
 =?us-ascii?Q?K+Hjp1VcivLQ3QpwVKGfLBZAhbHwYpjPjvLxyzmecP3SM7DNCRM87L+gEnYj?=
 =?us-ascii?Q?p82a1a1uHdMuKxvHmUtaICA2pujEu5n3jmM5Ao9eqTPezXhqhUubOQh4Q5vd?=
 =?us-ascii?Q?snaRUy9X88hvOFDxBldgKgesb/8YLP+KDRGWZJT0aRYp7IMLXR+EgUMGEkTW?=
 =?us-ascii?Q?KQf8eapAyY8qpXin2C/QKjyK9Rx/vxzc4rqdtfIghdmv/YbwDsdCrqqlTTYg?=
 =?us-ascii?Q?xRww0WRvIRr4nf6nytbQu92Y5Wnc2Ak54anhVKKdLgwYBkrJfCN0pl+smnrX?=
 =?us-ascii?Q?2z2dompk+M1ceWikHhuRlAgNA5/V0IdIzzLIlIsJt3tL2e8S+Qb5eayUYhI8?=
 =?us-ascii?Q?tkx6EqMPU8FGdic6simmV2mZli2H1KEz6jB4nMyKUGukr8bLAsxENAZbTePM?=
 =?us-ascii?Q?sEQjXlqlnQHf+ETJE6Hssu1jASMqyrvX8VbyTjMuq/Vi03Tll1qxXWzIXTap?=
 =?us-ascii?Q?knIdAu3NLqIKToazAecJJwcDwDhAe9j1DUd+iT2DBkcyq/vI/MmH+A/Uj6ta?=
 =?us-ascii?Q?kMSGj9noa8pikZjwdJAhR0wa5M6rF+gP9JlGIeXvGtWcszgJynctVZNDeQqT?=
 =?us-ascii?Q?odUwqmJK8pe06SYJVUsO2/Mvy0SZoOQFmLRCKKSUJ1n4I9hvMGLt6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(52116014)(7416014)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hgYHdV0g4xxBZNfArb43K95DAHoEcRoo/TDmV/o4sq85KMiHLNMKex2F2O+s?=
 =?us-ascii?Q?nsmPMjk5TIkI29x/VhHc/9zTX+1G5QdQnSH8+Jmku/aFDbGOnCjExJjyxNk9?=
 =?us-ascii?Q?rZj4UD3YQTmVnpYIVFwyxh2p+Zq6cOqBth9hzD2G3tQIUppgX8IgyoYXjflt?=
 =?us-ascii?Q?7DomGBENXNE6SOa8ahxmMQxoOEIRzCDWvImPst8uRKitAC3B1w8IaPwfBQJq?=
 =?us-ascii?Q?h9XajqN9T0tGH0oS3aIEUvxzsRRFyP/kq067XWAFRr+63GppBQqJU6n8Kfp5?=
 =?us-ascii?Q?egbwT4fzqHeNsul8ty3QwlYVsPyqTbG8/suppXe66Yft/flk5nKLSYAeXeJy?=
 =?us-ascii?Q?JQO9ShogKVCpZ5aZ5gwKo47/u3aFrym3P/0fijJk+rdyWO+5noOo2qb8Yw5M?=
 =?us-ascii?Q?zYyF2jUFI5HIMCig9xZ4zoqTDGZA/Ja28jKB3O12eyUSxIBVmHvUZGbD+YLN?=
 =?us-ascii?Q?BxejRl+bg2naWKP7iYxMy9Wg5Icp+GI2PWRMrnS0fhKDm0xCyni1a58BhcA3?=
 =?us-ascii?Q?PJ3ft4YByDDQWQnu9o+ij9x0oHAd6as6NgYCD5kAC+3bIuxCGu1uA+Gk26je?=
 =?us-ascii?Q?+vLdJkOXXiq0PZMjAnPoiBUUk2Kl3o9djUHrcjcyv+hj/FwKV5JMNZ5lPX+I?=
 =?us-ascii?Q?Eo7NGHkcttW9dyvREjoPAQ0GrmoswquHcTyelzzHPuQeOrO/lCt54eMWNlly?=
 =?us-ascii?Q?ulQK4wAjNzLUjV+QSL4lKDqfmHMfFZGD78IzpMDAhUoiBRormTsfaIupCKg9?=
 =?us-ascii?Q?8jBOOAfZaJbW5YRryb4CJt/LoR5L+IOj7JvMBDCmeh1mawrb7/amOMtCKQEc?=
 =?us-ascii?Q?x5s8J6LwT6gZ/YhrClQNulAyfwEJC9LZCwZXXwg8XruEO4FqNk7pNXF5IZlw?=
 =?us-ascii?Q?btUPRS/LD2llGOsYY0c37w69nyZSECz7tFKArIYad+zuiNL7o13dNMt88D7/?=
 =?us-ascii?Q?c9Nefm4hIFjIUoO+IOGM3WgdW3uutofQAS0Fm2tf2kOU8zmQlKOhlUaWeuKD?=
 =?us-ascii?Q?ltlMQj1TSdENgqXETkw36cfcLE9O1LnB34SSN8Ku8cQShcf/WUIBrdBtY4Jh?=
 =?us-ascii?Q?w2SAmKcZX8sStveddZh4D3ZmpwY/wp4TvMeTeGx9NFwxpNJY6Jt7rbj2PMPK?=
 =?us-ascii?Q?Qj0Ejeni8aZCLt7L02PtujJY9XtfbVakBrgu0kOuqX995j8+PFYAHaBVM0by?=
 =?us-ascii?Q?TSzc1rvILxgxN9r1gpWKqsdZWck+QurpRl+TUydEcgF9omYM+rgQe/w78B9V?=
 =?us-ascii?Q?KVM8rk6PeugWXD5DJs1ARAAw8x4HvPkfVhMicY4KwxpPR5TpkKREGPKw8UY0?=
 =?us-ascii?Q?MFS7ipRQYZaqKpCfZCMwULfoC+O+P1X8Rm+Q9jIVrg4UjHqmVny/Z8hnFQwr?=
 =?us-ascii?Q?n7GjYpcjxphfUXEJEm1brCvsqwWDP+bEvSQvuDW4xYwxzIaEPlIlwr1w+vnW?=
 =?us-ascii?Q?Xh4ube+KaJC+ArBM9bLzzNP3oC6ISP9cy6sb9nZDgxzTuke2cbgsGxVmcGxH?=
 =?us-ascii?Q?rSm7Nueah0uRxzmWNl8vknWUZe0z+o+Df0e/XF5BP+q4mwyG73lANucTRYKr?=
 =?us-ascii?Q?1hbytd/tDwAB+NV2XPOrHragoid4r9CYZ3ahnWK427bDPObJdutwARNymkpI?=
 =?us-ascii?Q?37jvUwyUNxMzbmT8165DV4c=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0bb1a4-f231-4389-8e85-08dd7c49bd73
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 18:17:11.1165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtqyRDF+Mfl6IJX0OoDDlRoyyMN/V1kVH/itlcclRQM4fz2ZZmaDfRxPidPHE9AyMp7182l6+MkIvTBmzPPTgTJ0tPk7V4pRB2VLgtBGCYYUZn4+kNMdO0Z6n6LllItQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8104

Oliver Upton <oliver.upton@linux.dev> writes:

> On Tue, Apr 15, 2025 at 10:30:36AM -0700, D Scott Phillips wrote:
>> Oliver Upton <oliver.upton@linux.dev> writes:
>> > On Tue, Apr 15, 2025 at 08:47:10AM -0700, D Scott Phillips wrote:
>> >> AC03_CPU_36 can cause asynchronous exceptions to be routed to the wrong
>> >> exception level if an async exception coincides with an update to the
>> >> controls for the target exception level in HCR_EL2. On affected
>> >> machines, always do writes to HCR_EL2 with async exceptions blocked.
>> >> 
>> >> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> >> ---
>> >>  arch/arm64/Kconfig              | 17 +++++++++++++++++
>> >>  arch/arm64/include/asm/sysreg.h | 18 ++++++++++++++++--
>> >>  arch/arm64/kernel/cpu_errata.c  | 14 ++++++++++++++
>> >>  arch/arm64/tools/cpucaps        |  1 +
>> >>  4 files changed, 48 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> >> index a182295e6f08b..e5fd87446a3b8 100644
>> >> --- a/arch/arm64/Kconfig
>> >> +++ b/arch/arm64/Kconfig
>> >> @@ -445,6 +445,23 @@ menu "Kernel Features"
>> >>  
>> >>  menu "ARM errata workarounds via the alternatives framework"
>> >>  
>> >> +config AMPERE_ERRATUM_AC03_CPU_36
>> >> +        bool "AmpereOne: AC03_CPU_36: CPU can take an invalid exception, if an asynchronous exception to EL2 occurs while EL2 software is changing the EL2 exception controls."
>> >> +	default y
>> >> +	help
>> >> +	  This option adds an alternative code sequence to work around Ampere
>> >> +	  errata AC03_CPU_36 on AmpereOne.
>> >> +
>> >> +	  If an async exception happens at the same time as an update to the
>> >> +	  controls for the target EL for async exceptions, an exception can be
>> >> +	  delivered to the wrong EL. For example, an EL may be routed from EL2
>> >> +	  to EL1.
>> >> +
>> >> +	  The workaround masks all asynchronous exception types when writing
>> >> +	  to HCR_EL2.
>> >> +
>> >> +	  If unsure, say Y.
>> >> +
>> >>  config AMPERE_ERRATUM_AC03_CPU_38
>> >>          bool "AmpereOne: AC03_CPU_38: Certain bits in the Virtualization Translation Control Register and Translation Control Registers do not follow RES0 semantics"
>> >>  	default y
>> >> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> >> index 2639d3633073d..e7781f7e7f7a7 100644
>> >> --- a/arch/arm64/include/asm/sysreg.h
>> >> +++ b/arch/arm64/include/asm/sysreg.h
>> >> @@ -1136,14 +1136,28 @@
>> >>  	__val;							\
>> >>  })
>> >>  
>> >> +#define __sysreg_is_hcr_el2(r)					\
>> >> +	(__builtin_strcmp("hcr_el2", __stringify(r)) == 0)
>> >
>> > This looks fragile. What about:
>> >
>> > 	write_sysreg(hcr, HCR_EL2);
>> >
>> > or:
>> >
>> > 	write_sysreg_s(hcr, SYS_HCR_EL2);
>> 
>> I had also thought about changing the users of write_sysreg(..hcr_el2)
>> to some new function write_hcr_el2() or something, but I guess that
>> would have the same fragility. Any suggestions on a better way? Trying
>> harder with the string stuff, or do something totally else?
>
> I think the least bad approach would be to convert to HCR-specific
> accessors. It's the most likely to encourage folks to respect the errata
> mitigation + keeps the ugliness out of unrelated common helpers.

OK, will do
