Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7D17F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 17:15:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUOpYc7QdXfI+VB/0ejGVh6AXf7t4pD34T2gJfRBiC8QkXY2W76sLvOykYWGFOeGOHzBKx1wl2OToS19F4A6l6rj6MUCjqKiHY2ldpuanqqIv82Y22PKso2IGszH944a5YZPTvqRhx4S2C4my7QBHYeAfOJCwb1P6/jd4FriOxH6JfbLh/njvem0YgeGoapb2tecvtKmoqxFMD3f4QIQjLYdQ/lpdma3IBmLOHb+oz0kRqvIESWCHboDLVbNxauYTtn/4Pqv+iVDDMVlApIVrHyr1D6ezwIiljRXpl8ItJZMK/rSsCzKIl84VtuKVxfk2tky4NpqVy3HsXpP6Bl1ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HTITmAPAZAR9Pp8bB/w+Q+vxN848CRAnWxiexOPhd0=;
 b=gp7m5zoPm1dG++1ERyW+eGlkOMNJIRVBPveD7u0h5y0+0FgJrtq8Gs+zrooJ7Yd+48Z6H5ocsC1Tv4vhSSnoUc28sq9s+cfRFrZ16DttMt0rm+gPFE+Fnkkc8Pm1UVwszSHyqFcC7vvVE1Z5Wz0eK9yoEem06l4bQHc9GzbB4dHRrpDByxaHjaWr+pX3GD3Dx/vAl3mhQJIm35Zt6TyOHCHMh0099XIaBuQybv3uf5OCNMhJKX2bfCtriCGPAlF/lAN6VHq5iBG8zJD7ZZwzBeDKKbL9qMC47VoCXF81PXDb4nz/KTltkD/USAX8I9QAPHJcvjdPp9dzT8XF2r0wnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HTITmAPAZAR9Pp8bB/w+Q+vxN848CRAnWxiexOPhd0=;
 b=pYwOMcgFZjUtsh2ImI47D4yjE9UU8riCaKhKPTW+9Eezj5Co3BvNZDqdpyGA6W2/oqvpQ/6knzV2wCJz5zj7MSwE0AgcrxrVQwOUAfT0ECWkvRN0D1Q9PUPoYla4T6b/Kl1685S0wBoC3r2Z8kBmlU1y8+N+/ICswETA+s8FmVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from MWHPR0101MB2893.prod.exchangelabs.com (2603:10b6:301:33::25) by
 DS7PR01MB7781.prod.exchangelabs.com (2603:10b6:8:7c::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.46; Wed, 14 Jun 2023 17:15:41 +0000
Received: from MWHPR0101MB2893.prod.exchangelabs.com
 ([fe80::c3b4:c7ab:46e:476]) by MWHPR0101MB2893.prod.exchangelabs.com
 ([fe80::c3b4:c7ab:46e:476%2]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 17:15:41 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Darren Hart
 <darren@os.amperecomputing.com>, Oliver Upton <oliver.upton@linux.dev>,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/3] arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38
 at stage-2
In-Reply-To: <20230609220104.1836988-2-oliver.upton@linux.dev>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
 <20230609220104.1836988-2-oliver.upton@linux.dev>
Date: Wed, 14 Jun 2023 10:15:34 -0700
Message-ID: <86sfauge2x.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: CH2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:610:52::38) To MWHPR0101MB2893.prod.exchangelabs.com
 (2603:10b6:301:33::25)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR0101MB2893:EE_|DS7PR01MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dcd29c8-8537-4fd3-7a86-08db6cfafb15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cA3CBeBeKOgsp5af3+cNOvI9X9xqx3+olTh8i68eBa+zX5KNqOFuZJ8EBdpqmUTv7w9IawM3+yycDuoid039e2xqaatdEvNci+ruuxqDa/E1nLAuyXcJXWOnPbzckeTVm4NhSilTaroqJK5VPOrmdkEW8jqrq/E0ECAcW4/PLQq8ciaNfIzW3Ug3qmOf6KmpW4ik5oiGjTd60rljTCnn0Pi6hkhsYNuivTGx/uuU/+f7yV0x7Dy1EGdtK18fUIO097EhuRmEPt6J7ymKLeyK1L7vS1usS02gofSTXQ+3XqCS2uoXUZRCJ8U31yiY5hBBUT5usd3ljhjOL5ars2ixfmnF2n9tSl0ilpz8svaVL5EEpFx6E69T8I/ESVcw+LrHssKm2mQ25vnvS3tP/bO8m54m1tt6VpPDLfQcKlmYlnhZ3D3mc7Ofiz0EamNj0VUXGswuA063FGxtD5a6uMwqCp8E/pezkPznP/6UKhHmxWoXiKsWx3DlZOZsRttavXDX7Rf1yrC1X2J61NncFRfU0wulEcQ5qePYwthgUzT7B2l15pNLn3kCTS7OSc9pYnvvTk6wS6H4gwOi7U54pf4YhQHn/sDkW5QjKTfxU3zjwOkJEyhODeDfctZocpmU8lQI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR0101MB2893.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(39850400004)(136003)(396003)(451199021)(6486002)(54906003)(6666004)(8936002)(41300700001)(5660300002)(8676002)(66946007)(4326008)(478600001)(66556008)(66476007)(38100700002)(38350700002)(316002)(186003)(83380400001)(26005)(9686003)(6506007)(6512007)(52116002)(86362001)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O3gmKb4i9ISBb+suydat9RD3VFyAZ5rBdXYocy7H70tg3yNkAwDullCJAB4q?=
 =?us-ascii?Q?Rk03DUAwayilIG7kBxKVSsxVbon4ESN+OMixWQoqqlN8HNUQpVH/UYfRPAgC?=
 =?us-ascii?Q?/PIEplPFrqdhLg3RdYRF8fo6ITFvoc5zRwp/xieLhuBBzy/yoMoTCYnrmI9C?=
 =?us-ascii?Q?0Ur1wCyh4etblIUD/d8Yhh0UZZd6ftwHW8fvYIB8jJ+L/s/SROQ9iJkrd0yX?=
 =?us-ascii?Q?FXYIb7sy0E5zNokMLaTptdMI9MICNdUFIyU2rTav+jkDTSCxwkVWLgf0Ziny?=
 =?us-ascii?Q?+ffkGW6EFtjQ8WR2bHngk3Ep45Y4M5iltJaBhg4z989xyo/Zg/brpxa3sl5a?=
 =?us-ascii?Q?7N5LpNxzcm1OiCMCwb4WJD/3bfQG6BZ0kTXkEUTwa5RI+QNCeT09vUKN+W8y?=
 =?us-ascii?Q?YZUv1ILzyULlM/muMnmJJBjX146ry4MEbEQRKqAnyHnpb9G7OEJxPb/1Y1qu?=
 =?us-ascii?Q?zZUs3u1Bnsvcwh97YjzhiEDKM3nHCYdSJCJXFBkuGQm6cshcQvhd7qa2ewyR?=
 =?us-ascii?Q?ZdzywGlRRGf3LBQwsbZfP1HQfNCxxmTAeYyleYJFY5mz4X9Nx7ExMP0x+W/W?=
 =?us-ascii?Q?B8nXrVGzoI32S/Dhc7zLpYYogDjW2CYXe6Jha+n9Xmm8Dxxsza7mJgv0kt4/?=
 =?us-ascii?Q?URRsgDJNaFvC8bLMBjpbG2voLRjSrKv+JzGPdJCDXeCBccyB3RlxWl9iF9WL?=
 =?us-ascii?Q?xxxrdjMWI3909wF6Zpu7XyZcFgJVINsx21BLwNuTzRS/d11hLTeiUjc68g4l?=
 =?us-ascii?Q?aWHqCRt4EUv00+Ird42lyHEOsACHctqbkCteNcpANZiK5/LvDJhFI95kMhp2?=
 =?us-ascii?Q?8bBvzPt5nwOx9gCSEdZvFC9Fqp3KZyBnWmZevJUkt7V6Zlk7PIKlPApzD9dy?=
 =?us-ascii?Q?X27mz908c8RGQdMXUCyWY5AnzVKz9aVVNjA42MTLM+R+nqMLNbO8QSYkox/u?=
 =?us-ascii?Q?Lwl5LfeW21zisr10yY4JEOILi0lxczNkf63xQ+qPHxDlYodnxFfkuvPG1/NM?=
 =?us-ascii?Q?t37ScNFReSMRuYufKmKCvvsTe9AgWg4SB7gYWnWkXe0d+gsu0xmF225z2Gw9?=
 =?us-ascii?Q?sAHubcgMQKOhG5w22fnN+eDvPuwvg+hrLrPxbZ9LDlZR2EnMSUmk+AHTP0Be?=
 =?us-ascii?Q?gDtsmzf35skBoJ8//Mc+DLYubTNDVUaiQcfgWKl7CIa+gYyVt/teHRqSi+V4?=
 =?us-ascii?Q?/hB380Jt19Napyzo/esY6u5WeJCgx403uMGyFBTiMx3JtTjfRXj7GfCYIVt4?=
 =?us-ascii?Q?SU60KDv2I4UBeYvknClrj0hcOH+2EW/vQiu10ZAGurLGRW30J/Jc7YQfCJ6O?=
 =?us-ascii?Q?qJtpmXO2sKykVBiG0i8Yj78hBDwXS1ncBce7zGSB6TeTO5bIVoD8EaIepMqA?=
 =?us-ascii?Q?YK2P8uVn4KjClSxi3n1VO0uFg1s0/yk1UT0WRjq2gRjyz9ghwGOHDdQeAG1/?=
 =?us-ascii?Q?Wyk0hZr8DN9iN8FvztNzkIDrJWgLJrOTqkWE1DCo1pXgVechiUjQO0wJYNPv?=
 =?us-ascii?Q?58TGyHQqXANBdfPTaRwLJLhZVmLLJC/KIc5Q5PYfFExweHYkV9/Vmb415jAu?=
 =?us-ascii?Q?A0hvsCdUB9OJuPFnOBfqD5vwj0Pd7DBsw1OqAJ+jm8mJbaMN3rexhqGtM192?=
 =?us-ascii?Q?MG2y0Kit+o+5MYT7R/R8zE0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dcd29c8-8537-4fd3-7a86-08db6cfafb15
X-MS-Exchange-CrossTenant-AuthSource: MWHPR0101MB2893.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 17:15:41.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d08IoWWU28diCR9rfnvG/pgQv2hFMrHEeD3nHSIAPjXfQ+aa2y3ywZi19lYzhKIBzgn69TSOMpkMJ0AA69oPTit/z5wCl+dxPiMnMGXZ+q8rGhzXiFsUvtLghbVsY9p1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7781

Oliver Upton <oliver.upton@linux.dev> writes:

> AmpereOne has an erratum in its implementation of FEAT_HAFDBS that
> required disabling the feature on the design. This was done by reporting
> the feature as not implemented in the ID register, although the
> corresponding control bits were not actually RES0. This does not align
> well with the requirements of the architecture, which mandates these
> bits be RES0 if HAFDBS isn't implemented.
>
> The kernel's use of stage-1 is unaffected, as the HA and HD bits are
> only set if HAFDBS is detected in the ID register. KVM, on the other
> hand, relies on the RES0 behavior at stage-2 to use the same value for
> VTCR_EL2 on any cpu in the system. Mitigate the non-RES0 behavior by
> leaving VTCR_EL2.HA clear on affected systems.
>
> Cc: stable@vger.kernel.org
> Cc: D Scott Phillips <scott@os.amperecomputing.com>
> Cc: Darren Hart <darren@os.amperecomputing.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: D Scott Phillips <scott@os.amperecomputing.com>
