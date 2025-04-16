Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2139.outbound.protection.outlook.com [40.107.101.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B124C06E
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847744; cv=fail; b=m6izHUMxQ21WN/nLiBFUeSAF5fjf+ODpRMZ61jJFXs6RtrstER4XZyFdYCWmjhVwPsnb9YDgv3n6a/pAwdEfDh7ECV6SROsmo9yhodHbtDf5LF9JAZ0Cd36Xn5uQug5tbIrN2HS/IJd8ewxhxJarvO42heXIIWdTqZuw8VBnX4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847744; c=relaxed/simple;
	bh=7dMlz+xsFDXkCVX3yfDXhKx5xX6W0YVLI4vGlq9Gdhc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=fH/19DQ6TtqL7Goaeb7SJOPInWAVcsV11vqHfnjJPPaANLtLl+8FPjOnbl8ZM1rybVEOpKDW6WIXMehjn2OACH6bTsDnOV2w4dvQgbCdr3005dvKdmjiWHNdo0oEkwQ6Nayz/a7S8rJHXQIL0Q58/Ia/4ZfyPxWcnjk1V5/YneM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=lihBzNQs; arc=fail smtp.client-ip=40.107.101.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="lihBzNQs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxLntNhX9IazW1bPS85YaNVITSVSDCl1VpgXhcd5OQyK+vtf4CELtmb/W+xWslSTaW268MfVrZcSwOiyB0QcGm3g+Iy24H3FOxaHfBFRx5RaTJXOAzZR+p4Y16/1qFvwtrAQZ2u8alT1fhfQKfwj70k3LuykK0M5lsNNw0xBxgmP5oUN3tbVL6XPEeMuLgNPlb2OB++wk3l7j70XqCQF2N+TI+pWyT3YmDiu9i2qmPL+c2JaowD6RpYvgJcUQ/Z/WzA+mOW8EuFIl/+ENtRw/GL7sV6bE8AsKbl2OY40ZhgVt9V52DniFKRfz9XKJeZXXPkuUluHPERJARaCkYFymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W2ouzAQdxfH3Ey+cYZ63YMjl0+1FTi9opr/INz20Bc=;
 b=E1u35wlj1mwoW7TGhYR9WB4bhtHAU8MXqJ+QhBRutfTapxFCX7I8EDINavwnEyPJ2SPHKLIfOBXXxUPbSN4Kwp5BibhydcAn0Rv56VZ22vh0nysSMJq0E49xu7ENZ6cqM+GJWDXonCMggtIZlwMqli6lhvsCAPFPE4/iD6jqVWTqlb4uk5f4n/jBsDbrUEdDbqZb/hnS//cCEchwwiUT/xctk+RJzeSO0IhuhW1ZKleMyHRmY+mPu6q2KyEWxT6CuVPps/HE2Wg5u7rxfzK/qY/aKm5X1JfmDgauc44hpTWO8J7QNaTnz0k910Xcat2uHQZlyikvd8rU3XuVNpAolg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W2ouzAQdxfH3Ey+cYZ63YMjl0+1FTi9opr/INz20Bc=;
 b=lihBzNQsblvnftoE7ngG/0P8FNS2QB08cOMd4fZRHqEVeq2B2kFFvuIHt7m47lOzhDzpoycYn7f1PfXvGq7T4LEl5mbFwH133udMz20cXoW8fKiJ8+pSbte6PTlTNWBmLzPr3Jw5L4KgquTTb4U2VRow7uq8C+vsb5vUp/IN0dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 BL3PR01MB7196.prod.exchangelabs.com (2603:10b6:208:347::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.21; Wed, 16 Apr 2025 23:55:39 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 23:55:39 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, James Clark
 <james.clark@linaro.org>, James Morse <james.morse@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, "Rob Herring (Arm)" <robh@kernel.org>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm64: errata: Work around AmpereOne's erratum
 AC03_CPU_36
In-Reply-To: <86wmbkk1yz.wl-maz@kernel.org>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <86wmbkk1yz.wl-maz@kernel.org>
Date: Wed, 16 Apr 2025 16:14:07 -0700
Message-ID: <86jz7jya0w.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:a03:60::25) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|BL3PR01MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: bccac901-22e8-45b7-fcfc-08dd7d423090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|52116014|376014|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rlX0uY1nUuHdLtEsv19ErnFGydQ99LUWPNZoNw4wHguwwI3R8e2Or+NrFvW7?=
 =?us-ascii?Q?llz9//que5Gxg/6uU64wvy0XzEBlJOAT1eaQrAdXHMfoj85xyCUpy+uEFUPA?=
 =?us-ascii?Q?/94mWLwoh/Ucuyfz8ljgiAqhuY6ZMxZ/IBR0fMWLTJ2Qd2wx3Vt9NSmZvTtS?=
 =?us-ascii?Q?fCiVdhFcIjnqqSxiVe+8nFBsn8e1URvUiNaKy8cDut/rrnZZIvpZe8FtiPYU?=
 =?us-ascii?Q?053tJTSr/uMpQNqD5tkXlkJSYehYjSUuPISpOPmmbZUT33Jl243UeNehDtJv?=
 =?us-ascii?Q?14PVqpxToGMcZpS+p+pGCUUeONW+hrUy51qwj5rs15zJqNksOq0oay1vCIcv?=
 =?us-ascii?Q?brV7y0yVVjkWMzp5R2H/0OpQ8J9kf0HEJEyYpH3WVIZnXbMGrfuBR3YHRVdk?=
 =?us-ascii?Q?OuF5OICFYXKsUrL1fqtRP66nMPuK1iFX0jljHmZOrrffpBu/357sCiZHuoGj?=
 =?us-ascii?Q?TdlcPm8uMDdsPEKBkXq6tqgIthVBZDpLpB6ilPSvzS9iEMh//NWr1jiHPXaM?=
 =?us-ascii?Q?KW0RhYk+ORzd1jq5TTWa4WgfHiNrT54O16NISnaZjY+5MMuAR5IrgPOSZRrC?=
 =?us-ascii?Q?/KhXVRnjmvDJEPGgV7fUPqxBvQn0LfrPaa0Aqj11U/3Hfc3IBN6Yl1vYsbVj?=
 =?us-ascii?Q?ivbrG11QO2NE8o4TKDNqKvjRJPJwjaQ9VtHDjMjYE1X/rvPqtBHn3nWeYNgY?=
 =?us-ascii?Q?vHgB0UB1gyTzQmMUSBDRXAxyoY07Nzbv9bvLB5skRLGET/NfnVqBKoG1hXGa?=
 =?us-ascii?Q?e7z9OgYGi9Qo6bDYEg5BX+NZeqi0Zy6OFBI3SkuFUMfaxkLeyqvwaTMPSAub?=
 =?us-ascii?Q?86e46L1a3dOYFt7BVylLfQj2yc/Z3ejjJ5m0d3s8gqr3gFmzUZzPfSV980cc?=
 =?us-ascii?Q?pFK8oc6f9of96SH5pdpbdGoZl1l09zK7r0aPdpWf8GXEiG/9aoALLGPntlYJ?=
 =?us-ascii?Q?8YiVhutSFxfFm/W7NzlTVvgjB+S1l8EoZqT23ZCAlLnA9WWIX2lwVbC40sZt?=
 =?us-ascii?Q?V4A0USSnAf1MZ+5xnKtZMRwwg0yNIwNJGFcEl7iUaC3E+pF2irTzCLpyn7Mr?=
 =?us-ascii?Q?gSyZC5jUmZYHQnVnPE3yJDycTMQKNiyipv2Spgrf29FOaYVaTL7YtC6DhHx5?=
 =?us-ascii?Q?hOYs3BYFmSemxpt62aoldnstUyPef1M+B3tMUTQdP83t4DOOCccl5geU6EQX?=
 =?us-ascii?Q?/3LI9/66fVAVtTpzkaNi5wjUUFN8bn0I2DqBJ7YDZBiPXXd5INiOjx4ZJzSW?=
 =?us-ascii?Q?53qMxHagha4Wj2U+lclZsyjvOySKNuDv9HkLkVnbfR9wE5hXo7KDxr/b9O9l?=
 =?us-ascii?Q?3E7YdSqz9suFqMKQVgKQdlvQu1vyMC71IpfN+TGZwl1pKNmna/wvCjf/CNKr?=
 =?us-ascii?Q?nC+unxBo5UfbhisyHSrO0IXIoaiU5IvOHEwgWnm53sXH+IaENAUBl98K2ARi?=
 =?us-ascii?Q?/h4Jynnftk7R6wULtKERgfPeK9X+7mkEHlUqWUZl+EXWsWzfQwIpvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(52116014)(376014)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7cI0F6q+XnB3buBribZibugj4xOGK7xAn7/fM3jjfd6NTtaoA3TWxIaqkMxQ?=
 =?us-ascii?Q?XjKj9vbDypGW901zC2AmDTW8GqFT0eXHsSzMZqk+PAZL4139BX+q5PcR/0my?=
 =?us-ascii?Q?B6EHE5XGyFmvNp5koS4Lpw0KAj0nz57Y9LsFKGRC2MadHBxE/cOgkWRwu+X/?=
 =?us-ascii?Q?jcfrhGh7YI4ygvjCm9niY/E+0X4MJHcxVVnbN/KJ6L1E6A3WipZ2IVtw18Zt?=
 =?us-ascii?Q?Xdm9Xdt+hRv54I0VjeuHlMy+/5mM6YfmVcEDRPqhaQTgLHa7ehlITEf+EIv8?=
 =?us-ascii?Q?iahniNt8q90YodRa4QIE3ISHmB6mIH8KZcqC2GXnz31QYdTS64IVR+5X/pbd?=
 =?us-ascii?Q?vubvmEl7IwFMCRkkdBv79V23PdAFnaZsQxmWdN1xxAKErpE7UoHEfVjIIQr0?=
 =?us-ascii?Q?dlLkYDqOF2Qfncgokl6OIbTodREJshpBgqhD1d8Gw5qet3ePgtLsqUW9oA9k?=
 =?us-ascii?Q?hn7yqRET19On4yJonqN33iBqKS1hPKsL4j2mNI/mDbAnQxe69kqLl/FSlcd0?=
 =?us-ascii?Q?wUDR4oxTKsYeZyDe54lWbe/00L0ZLrmhArVv3iMVoFq0TRHhS6e3QrDmTaG6?=
 =?us-ascii?Q?FnBU5p9JNvwZEAYS4BHT+IxNBzpvy6YFY2S4X6JyLqnyMGFYVOX06MOyGh14?=
 =?us-ascii?Q?gNvNcyPdu1IOOWrJQi+oCPLvV/Ny2KJQfiVbVUAJlzIAjJQUiRy7JJsyFw5v?=
 =?us-ascii?Q?xSUWsjspT/kbIxilj2/372Ahmp6S1H7kEvfY2MNXfuEHcKyqTanbih9kx0XA?=
 =?us-ascii?Q?BMVZj4dreDq8MeeUmO5BS7y9uTjHX37k8MnKOkQWuFclzNekXPncfof3uK5D?=
 =?us-ascii?Q?OuR6zsyWWu68jZoaXCBgnAUtP9rNwpXGycBjFs9D0Gu5zjZiqziV84JbPKXq?=
 =?us-ascii?Q?s2qkiSEHsqBHND5vf5xweJJeNr4epFFC/0ycWH9HyXERvV/KgeIZhKQk8AZV?=
 =?us-ascii?Q?QRc6oTuORw4u9RnHYRQLNh9GhFIgx/oOSe4NZGribKxjDBfCQFQ0Ut5yrBhp?=
 =?us-ascii?Q?5vA/2hKgQYYF8GgCgUEalt8Rl0n7r4fIa/8OqsqJjz+1aeDMa7jMd2DdbTnT?=
 =?us-ascii?Q?RXgThFUyam+11tHNUcsEugHzO5MW+243gFqTeinqCthsX38wpxHcPJlNZyI0?=
 =?us-ascii?Q?ZtIY1EtVCcGuNz609RTHaCUWybDYDI14mSUi0eOg+JSWhc75Wq20218idBpx?=
 =?us-ascii?Q?hwf3nmob2N4UQ7ytEoCwK4lWero2IZcSCciJd7rzyiblVgA2qWde/Fhc2fFC?=
 =?us-ascii?Q?TbsnykiK763vSGKOmchAMcT4i2Ha/09nWyGuKYV56Q052WR7n4UziCVD5on5?=
 =?us-ascii?Q?2t+HCFiNn/Lp4gi/ksgk8LKRKHLH80WKDKedje3RrYgBOGpLQ2SuWNYDy2yF?=
 =?us-ascii?Q?pZqmoZFC9QPsCDf1k/I/3/gTATwMN/SbTI2EOADZoa60ZF4ZI+4S4we46cE2?=
 =?us-ascii?Q?x6ZdVEFDgmmtRGMX8esVQ+WLxXEXCb26FczOJkkZbTvribHKG2i0jnVJCxnf?=
 =?us-ascii?Q?X0yNdcR+pMv1N9OW9nBJAwCgSR4baJh58xyr9RjFrpcRyxYpAZOcUAUIgi18?=
 =?us-ascii?Q?BjD0iLNun6LNoyN8zqrnypzyqEOXuM7S4aWI0WFt3/XNLL+6/sBW731lf5PV?=
 =?us-ascii?Q?V6az5rdG2xgiPPRU+2AA5dA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bccac901-22e8-45b7-fcfc-08dd7d423090
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 23:55:39.4225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNyYP9zWsQoAz4eOq/vMdm4pktc1F07KLcnpvdCpdyijReO9j1XFUz0Vz1tKPug/P6SZ8XY768+CXnjKi4wAg8CVm7XnijQZ/9LNVd9mZtU8F86CLDxjqPfGwillnE3Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7196

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 15 Apr 2025 16:47:10 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> AC03_CPU_36 can cause asynchronous exceptions to be routed to the wrong
>> exception level if an async exception coincides with an update to the
>> controls for the target exception level in HCR_EL2. On affected
>> machines, always do writes to HCR_EL2 with async exceptions blocked.
>
> From the actual errata document [1]:
>
> <quote>
> If an Asynchronous Exception to EL2 occurs, while EL2 software is
> changing the EL2 exception control bits from a configuration where
> asynchronous exceptions are routed to EL2 to a configuration where
> asynchronous exceptions are routed to EL1, the processor may exhibit
> the incorrect exception behavior of routing an interrupt taken at EL2
> to EL1.  The affected system register is HCR_EL2, which contains
> control bits for routing and enabling of EL2 exceptions.
> </quote>
>
> My reading is that things can go wrong when clearing the xMO bits.
>
> I don't think we need to touch the xMO bits at all when running
> VHE. So my preference would be to:
>
> - simply leave the xMO bits set at all times (nothing bad can happen
>   from that, can it?)
>
> - prevent these systems from using anything but VHE (and fail KVM init
>   otherwise)
>
> This would save a lot of maintenance hassle and the extreme ugliness
> of this patch.

Yes that also matches my understanding, that having the physical IRQ
routing permanently set to EL2 would avoid the erratum case. I'll take
the approach of restricting to VHE mode in the next version, thanks very
much Marc.
